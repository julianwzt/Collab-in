import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collabin/feature/home/model/view_project_model.dart';
import 'package:collabin/feature/home/presentation/widget/category_chip.dart';
import 'package:collabin/feature/home/presentation/widget/collaboration_card.dart';
import 'package:collabin/feature/home/service/collaboration_service.dart';
import 'package:collabin/feature/notification/bloc/notification_bloc.dart';
import 'package:collabin/feature/notification/bloc/notification_event.dart';
import 'package:collabin/feature/notification/bloc/notification_state.dart';
import 'package:collabin/feature/notification/presentation/notification_screen.dart';
import 'package:collabin/feature/profile/model/view_profile_model.dart';
import 'package:collabin/feature/profile/repository/profile_repository.dart';

import 'package:collabin/core/widget/profile_avatar.dart';
import 'package:collabin/core/widget/loading_shimmer.dart';
import '../../../core/common/color_value.dart';
import '../../search/presentation/search_result_screen.dart';
import 'create_collaboration.dart';
import 'detail_collaboration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  String _selectedSort = 'Terbaru';
  String _selectedStatusFilter = 'Semua';

  final ProfileRepository _profileRepository = ProfileRepositoryImpl();
  final CollaborationService _collaborationService = CollaborationService();
  late TextEditingController _searchController;

  ViewProfileModel? _profile;
  List<Datum> _projects = [];
  bool _isLoadingProfile = true;
  bool _isLoadingProjects = true;

  List<Datum> get _filteredProjects {
    List<Datum> filtered = List.from(_projects);

    // 1. Filter by Category (pakai kelompok kata kunci agar kategori bebas
    //    seperti "Flutter" atau "Frontend Development" tetap masuk tab yang benar)
    if (_selectedCategoryIndex != 0) {
      final label = _categories[_selectedCategoryIndex];
      filtered = filtered.where((project) => _matchesCategory(project, label)).toList();
    }

    // 2. Filter by Status
    if (_selectedStatusFilter != 'Semua') {
      filtered = filtered.where((project) {
        final done = _isFinished(project.status);
        return _selectedStatusFilter == 'Selesai' ? done : !done;
      }).toList();
    }

    // 3. Sorting
    if (_selectedSort == 'Terbaru') {
      filtered.sort((a, b) => b.id.compareTo(a.id));
    } else if (_selectedSort == 'Terlama') {
      filtered.sort((a, b) => a.id.compareTo(b.id));
    } else if (_selectedSort == 'Deadline Terdekat') {
      filtered.sort((a, b) {
        if (a.deadline == null) return 1;
        if (b.deadline == null) return -1;
        return a.deadline!.compareTo(b.deadline!);
      });
    }

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    context.read<NotificationBloc>().add(FetchUnreadCount());
    await Future.wait([
      _fetchProfile(),
      _fetchProjects(),
    ]);
  }

  Future<void> _fetchProfile() async {
    try {
      final profile = await _profileRepository.getViewProfile();
      if (mounted) {
        setState(() {
          _profile = profile;
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProfile = false;
        });
      }
      debugPrint('Error fetching profile: $e');
    }
  }

  Future<void> _fetchProjects() async {
    try {
      final projects = await _collaborationService.getAllProjects();
      if (mounted) {
        setState(() {
          _projects = projects;
          _isLoadingProjects = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProjects = false;
        });
      }
      debugPrint('Error fetching projects: $e');
    }
  }

  Widget _buildProfileAvatar(String? source) {
    return ProfileAvatar(
      imageUrl: source,
      fullName: _profile?.namaLengkap,
      size: 52,
      fontSize: 16,
    );
  }

  Widget _buildShimmerProjectCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LoadingShimmer.circle(size: 40),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  LoadingShimmer(width: 120, height: 14),
                  SizedBox(height: 6),
                  LoadingShimmer(width: 80, height: 12),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const LoadingShimmer(width: double.infinity, height: 18),
          const SizedBox(height: 8),
          const LoadingShimmer(width: 200, height: 18),
          const SizedBox(height: 16),
          Row(
            children: const [
              LoadingShimmer(width: 60, height: 12),
              SizedBox(width: 12),
              LoadingShimmer(width: 80, height: 12),
            ],
          ),
          const SizedBox(height: 16),
          const LoadingShimmer(width: double.infinity, height: 40),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: List.generate(3, (index) => const LoadingShimmer(width: 70, height: 24, borderRadius: 20)),
          ),
        ],
      ),
    );
  }

  final List<String> _categories = const [
    'Semua',
    'Mobile Dev',
    'Web Dev',
    'UI/UX Design',
    'Backend',
    'Data & AI',
    'Game Dev',
    'IoT',
    'Cyber Security',
    'DevOps & Cloud',
  ];

  /// Kata kunci per tab kategori. Dicocokkan ke kategori project
  /// (huruf kecil). Kata pendek dicocokkan sebagai kata utuh.
  static const Map<String, List<String>> _categoryKeywords = {
    'Mobile Dev': ['mobile', 'android', 'ios', 'flutter', 'kotlin', 'swift', 'react native', 'app development'],
    'Web Dev': ['web', 'frontend', 'front end', 'front-end', 'fullstack', 'full stack', 'laravel', 'react', 'vue', 'next', 'javascript'],
    'UI/UX Design': ['ui', 'ux', 'design', 'figma', 'desain'],
    'Backend': ['backend', 'back end', 'back-end', 'api', 'server', 'database', 'fullstack', 'full stack', 'golang', 'spring'],
    'Data & AI': ['data', 'machine learning', 'ml', 'ai', 'artificial intelligence', 'deep learning', 'nlp', 'natural language', 'computer vision', 'analyst', 'analytics', 'intelligence'],
    'Game Dev': ['game', 'unity', 'unreal'],
    'IoT': ['iot', 'internet of things', 'embedded', 'hardware', 'arduino'],
    'Cyber Security': ['security', 'cyber', 'keamanan'],
    'DevOps & Cloud': ['devops', 'cloud', 'sre', 'site reliability', 'infrastructure', 'network', 'system administrator'],
  };

  bool _matchesCategory(Datum project, String label) {
    final keywords = _categoryKeywords[label] ?? [label.toLowerCase()];
    return project.category.any((raw) {
      final cat = raw.toLowerCase();
      return keywords.any((k) => k.length <= 3
          ? RegExp('(^|[^a-z])${RegExp.escape(k)}([^a-z]|\$)').hasMatch(cat)
          : cat.contains(k));
    });
  }

  static bool _isFinished(String? status) {
    final s = status?.toUpperCase() ?? '';
    return s == 'DONE' || s == 'COMPLETED' || s == 'CLOSED' || s == 'SELESAI';
  }

  static const List<String> _sortOptions = ['Terbaru', 'Terlama', 'Deadline Terdekat'];
  static const Map<String, String> _sortHints = {
    'Terbaru': 'Project yang paling baru dibuat',
    'Terlama': 'Project yang paling lama dibuat',
    'Deadline Terdekat': 'Deadline paling dekat di atas',
  };
  static const List<String> _statusOptions = ['Semua', 'Mencari Rekan', 'Selesai'];
  static const Map<String, String> _statusHints = {
    'Semua': 'Tampilkan semua project',
    'Mencari Rekan': 'Belum selesai, masih bisa diajukan bergabung',
    'Selesai': 'Project sudah selesai / berakhir',
  };

  int get _activeFilterCount =>
      (_selectedSort != 'Terbaru' ? 1 : 0) + (_selectedStatusFilter != 'Semua' ? 1 : 0);

  void _showFilterSheet() {
    // Pilihan sementara di dalam sheet, baru diterapkan saat "Terapkan".
    String tempSort = _selectedSort;
    String tempStatus = _selectedStatusFilter;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Widget sectionTitle(String title, String subtitle) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700, color: ColorValue.textPrimary)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(fontSize: 12, color: ColorValue.textSecondary)),
                  ],
                );

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Filter & Urutkan',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700, color: ColorValue.textPrimary)),
                        ),
                        TextButton(
                          onPressed: () => setModalState(() {
                            tempSort = 'Terbaru';
                            tempStatus = 'Semua';
                          }),
                          child: const Text('Reset',
                              style: TextStyle(color: ColorValue.primaryColor, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ── Bagian 1: URUTKAN (pilih satu) ──────────────────
                    sectionTitle('Urutkan', 'Atur urutan daftar project'),
                    const SizedBox(height: 8),
                    ..._sortOptions.map((sort) {
                      final selected = tempSort == sort;
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => setModalState(() => tempSort = sort),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Icon(
                                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                                color: selected ? ColorValue.primaryColor : Colors.grey.shade400,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(sort,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                                          color: ColorValue.textPrimary,
                                        )),
                                    Text(_sortHints[sort]!,
                                        style: const TextStyle(fontSize: 11.5, color: ColorValue.textSecondary)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1),
                    ),

                    // ── Bagian 2: STATUS PROJECT (pilih satu) ───────────
                    sectionTitle('Status Project', 'Saring project berdasarkan statusnya'),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: _statusOptions.map((status) {
                          final selected = tempStatus == status;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setModalState(() => tempStatus = status),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: selected ? ColorValue.primaryColor : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: selected ? Colors.white : ColorValue.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_statusHints[tempStatus]!,
                        style: const TextStyle(fontSize: 11.5, color: ColorValue.textSecondary)),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedSort = tempSort;
                            _selectedStatusFilter = tempStatus;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorValue.primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Terapkan',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Ringkasan filter aktif yang tampil di bawah judul list.
  Widget _buildActiveFilterSummary() {
    if (_activeFilterCount == 0) return const SizedBox.shrink();
    Widget pill(String text, VoidCallback onClear) => Container(
          padding: const EdgeInsets.only(left: 10, right: 4, top: 4, bottom: 4),
          decoration: BoxDecoration(
            color: ColorValue.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text,
                  style: const TextStyle(
                      fontSize: 12, color: ColorValue.primaryColor, fontWeight: FontWeight.w600)),
              const SizedBox(width: 2),
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.close_rounded, size: 16, color: ColorValue.primaryColor),
              ),
            ],
          ),
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: [
          if (_selectedSort != 'Terbaru')
            pill('Urutan: $_selectedSort', () => setState(() => _selectedSort = 'Terbaru')),
          if (_selectedStatusFilter != 'Semua')
            pill('Status: $_selectedStatusFilter', () => setState(() => _selectedStatusFilter = 'Semua')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorValue.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchData,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildProfileAvatar(_profile?.profilePicture),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isLoadingProfile ? 'Loading...' : (_profile
                                      ?.namaLengkap ?? 'Guest'),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: ColorValue.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _isLoadingProfile
                                      ? '...'
                                      : ((_profile?.keahlian.isNotEmpty ?? false)
                                          ? _profile!.keahlian.first
                                          : (_profile?.institusi ?? '-')),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: ColorValue.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Add button
                          GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CreateCollaborationPage(),
                                ),
                              );
                              if (result == true) {
                                _fetchProjects();
                              }
                            },
                            child: Container(
                              width: 38,
                              height: 38,
                              child: const Icon(
                                Icons.add,
                                color: ColorValue.textPrimary,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NotificationScreen(),
                                ),
                              ).then((_) {
                                // Refresh unread count when returning from notification screen
                                context.read<NotificationBloc>().add(FetchUnreadCount());
                              });
                            },
                            child: BlocBuilder<NotificationBloc, NotificationState>(
                              builder: (context, state) {
                                final unreadCount = state.unreadData?.unreadCount ?? 0;
                                
                                return Stack(
                                  children: [
                                    SizedBox(
                                      width: 38,
                                      height: 38,
                                      child: const Icon(
                                        Icons.notifications_outlined,
                                        color: ColorValue.textPrimary,
                                        size: 20,
                                      ),
                                    ),
                                    if (unreadCount > 0)
                                      Positioned(
                                        right: 4,
                                        top: 4,
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 1.5),
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 14,
                                            minHeight: 14,
                                          ),
                                          child: Text(
                                            unreadCount > 9 ? '9+' : '$unreadCount',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: _searchController,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchResultScreen(
                                  initialQuery: _searchController.text,
                                ),
                              ),
                            );
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Cari Kolaborasi',
                            hintStyle: const TextStyle(
                              color: ColorValue.textSecondary,
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: ColorValue.textSecondary,
                              size: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: ColorValue.borderColor,
                                width: 1.2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: ColorValue.borderColor,
                                width: 1.2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Color(0xFFF7941D),
                                width: 1.4,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15),
                          ),

                        ),
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Kategori',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: ColorValue.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pilih kategori pilihanmu yang kamu ingin cari',
                        style: TextStyle(
                          fontSize: 13,
                          color: ColorValue.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, i) =>
                        CategoryChip(
                          label: _categories[i],
                          isSelected: _selectedCategoryIndex == i,
                          onTap: () =>
                              setState(() => _selectedCategoryIndex = i),
                        ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 14)),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rekomendasi untuk anda',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: ColorValue.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: _showFilterSheet,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(
                                _activeFilterCount > 0 ? 'Filter ($_activeFilterCount)' : 'Filter',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: ColorValue.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: ColorValue.primaryColor,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(child: _buildActiveFilterSummary()),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: _isLoadingProjects
                    ? SliverToBoxAdapter(
                        child: Column(
                          children: List.generate(3, (index) => _buildShimmerProjectCard()),
                        ),
                      )
                    : _filteredProjects.isEmpty
                    ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text(
                        _selectedCategoryIndex == 0 && _selectedStatusFilter == 'Semua'
                            ? 'Belum ada proyek tersedia'
                            : 'Tidak ada proyek di kategori/filter ini',
                        style: const TextStyle(
                          color: ColorValue.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                )
                    : SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, i) {
                      final item = _filteredProjects[i];
                      
                      // Extract collaborator images
                      final List<String> memberImages = item.collaborators
                          ?.where((c) => c.profilePicture != null && c.profilePicture!.isNotEmpty)
                          .map((c) => c.profilePicture!)
                          .toList() ?? [];

                      // Limit to show only a few in the stack, rest as +N
                      const int maxDisplay = 3;
                      final List<String> displayImages = memberImages.take(maxDisplay).toList();
                      final int extraMembers = memberImages.length > maxDisplay ? memberImages.length - maxDisplay : 0;

                      return CollaborationCard(
                        id: item.id,
                        ownerName: item.owner.fullName,
                        ownerRole: 'Pemilik Kolaborasi',
                        ownerImageUrl: (item.owner.profilePicture != null && item.owner.profilePicture.toString().isNotEmpty)
                            ? item.owner.profilePicture.toString()
                            : 'https://ui-avatars.com/api/?name=${item.owner.fullName}&background=random',
                        memberImages: displayImages,
                        extraMembers: extraMembers,
                        projectTitle: item.title,
                        projectType: item.category.isNotEmpty ? item.category.first : 'General',
                        projectDate: item.deadline != null ? '${item.deadline!.day}/${item.deadline!.month}/${item.deadline!.year}' : '-',
                        deadline: item.deadline,
                        projectDescription: item.description,
                        skills: item.category.isNotEmpty ? item.category : const ['General'],
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetailCollaboration(
                                    project: item,
                                    owner: _profile,
                                  ),
                            ),
                          );
                          if (result == true) {
                            _fetchProjects();
                          }
                        },
                      );
                    },
                    childCount: _filteredProjects.length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
