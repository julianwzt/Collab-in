import 'package:flutter/material.dart';

import 'package:collabin/core/common/app_ui_helper.dart';
import 'package:collabin/core/common/color_value.dart';
import 'package:collabin/core/widget/loading_shimmer.dart';
import 'package:collabin/core/widget/profile_avatar.dart';
import 'package:collabin/feature/messages/message_service.dart';
import 'package:collabin/feature/profile/repository/profile_repository.dart';

String _timeLabel(DateTime t) {
  final now = DateTime.now();
  final local = t.toLocal();
  final hm =
      '${local.hour.toString().padLeft(2, '0')}.${local.minute.toString().padLeft(2, '0')}';
  if (local.year == now.year && local.month == now.month && local.day == now.day) return hm;
  final diff = DateTime(now.year, now.month, now.day)
      .difference(DateTime(local.year, local.month, local.day))
      .inDays;
  if (diff == 1) return 'Kemarin';
  return '${local.day}/${local.month}';
}

/// Tab "Messages": daftar chat grup dari setiap project yang kamu miliki
/// atau ikuti sebagai kolaborator.
class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final MessageService _service = MessageService();
  final TextEditingController _search = TextEditingController();
  List<Conversation> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final items = await _service.getConversations();
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = AppUiHelper.readableError(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _search.text.trim().toLowerCase();
    final items = q.isEmpty ? _items : _items.where((c) => c.title.toLowerCase().contains(q)).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Text('Pesan',
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w700, color: ColorValue.textPrimary)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Diskusi dengan tim di setiap project kolaborasi',
                  style: TextStyle(fontSize: 13, color: ColorValue.textSecondary)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: SizedBox(
                height: 46,
                child: TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Cari percakapan',
                    hintStyle: const TextStyle(color: ColorValue.textSecondary, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: ColorValue.textSecondary, size: 20),
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: ColorValue.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: ColorValue.primaryColor),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: ColorValue.primaryColor,
                onRefresh: _load,
                child: _loading
                    ? ListView(
                        children: List.generate(
                          5,
                          (_) => const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Row(children: [
                              LoadingShimmer(width: 52, height: 52, borderRadius: 14),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LoadingShimmer(width: 160, height: 14),
                                    SizedBox(height: 8),
                                    LoadingShimmer(width: double.infinity, height: 12),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ),
                      )
                    : items.isEmpty
                        ? ListView(children: [_empty()])
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1, indent: 84, endIndent: 20),
                            itemBuilder: (_, i) => _tile(items[i]),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _empty() => Padding(
        padding: const EdgeInsets.fromLTRB(40, 80, 40, 0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(color: ColorValue.primaryLight, shape: BoxShape.circle),
              child: const Icon(Icons.forum_outlined, color: ColorValue.primaryColor, size: 36),
            ),
            const SizedBox(height: 16),
            Text(_error ?? 'Belum ada percakapan',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 6),
            const Text(
              'Chat grup otomatis tersedia saat kamu membuat project atau diterima menjadi kolaborator.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: ColorValue.textSecondary, height: 1.5),
            ),
          ],
        ),
      );

  Widget _tile(Conversation c) {
    final last = c.lastMessage;
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ChatRoomScreen(conversation: c)),
        );
        _load();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                c.projectPicture ?? '',
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 52,
                  height: 52,
                  color: ColorValue.primaryLight,
                  child: const Icon(Icons.groups_rounded, color: ColorValue.primaryColor),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(c.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: ColorValue.textPrimary)),
                      ),
                      if (last != null)
                        Text(_timeLabel(last.createdAt),
                            style: TextStyle(
                              fontSize: 11.5,
                              color: c.unreadCount > 0
                                  ? ColorValue.primaryColor
                                  : ColorValue.textSecondary,
                            )),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          last == null
                              ? '${c.isOwner ? 'Pemilik' : 'Anggota'} · ${c.memberCount} anggota · Mulai obrolan'
                              : '${last.senderName.split(' ').first}: ${last.text}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12.5, color: ColorValue.textSecondary),
                        ),
                      ),
                      if (c.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: ColorValue.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('${c.unreadCount}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ruang chat grup satu project.
class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, required this.conversation});

  final Conversation conversation;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final MessageService _service = MessageService();
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  List<ChatMessage> _messages = [];
  int? _myId;
  bool _loading = true;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        ProfileRepositoryImpl().getViewProfile(),
        _service.getMessages(widget.conversation.projectId),
      ]);
      if (!mounted) return;
      setState(() {
        _myId = (results[0] as dynamic).idPengguna as int;
        _messages = results[1] as List<ChatMessage>;
        _loading = false;
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      AppUiHelper.showError(context, AppUiHelper.readableError(e));
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      final msg = await _service.send(widget.conversation.projectId, text);
      _input.clear();
      if (!mounted) return;
      setState(() => _messages = [..._messages, msg]);
      _scrollToBottom();
    } catch (e) {
      if (mounted) AppUiHelper.showError(context, AppUiHelper.readableError(e));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.conversation;
    return Scaffold(
      backgroundColor: ColorValue.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: ColorValue.textPrimary,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(c.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700)),
            Text('${c.memberCount} anggota',
                style: const TextStyle(fontSize: 12, color: ColorValue.textSecondary)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: ColorValue.primaryColor))
                : _messages.isEmpty
                    ? const Center(
                        child: Text('Belum ada pesan. Sapa tim kamu!',
                            style: TextStyle(color: ColorValue.textSecondary)),
                      )
                    : ListView.builder(
                        controller: _scroll,
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        itemCount: _messages.length,
                        itemBuilder: (_, i) => _bubble(_messages[i], i),
                      ),
          ),
          SafeArea(
            top: false,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: 'Tulis pesan...',
                        hintStyle: const TextStyle(color: ColorValue.textSecondary, fontSize: 14),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    onPressed: _sending ? null : _send,
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: ColorValue.primaryColor, shape: BoxShape.circle),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(ChatMessage m, int i) {
    final mine = m.senderId == _myId;
    final prev = i > 0 ? _messages[i - 1] : null;
    final showName = !mine && (prev == null || prev.senderId != m.senderId);
    return Padding(
      padding: EdgeInsets.only(top: showName ? 10 : 3),
      child: Row(
        mainAxisAlignment: mainAxis(mine),
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!mine)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: showName
                  ? ProfileAvatar(
                      imageUrl: m.senderPicture, fullName: m.senderName, size: 30, fontSize: 11)
                  : const SizedBox(width: 30),
            ),
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 280),
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
              decoration: BoxDecoration(
                color: mine ? ColorValue.primaryColor : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(mine ? 16 : 4),
                  bottomRight: Radius.circular(mine ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showName)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(m.senderName,
                          style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: ColorValue.primaryColor)),
                    ),
                  Text(m.text,
                      style: TextStyle(
                          fontSize: 13.5,
                          height: 1.4,
                          color: mine ? Colors.white : ColorValue.textPrimary)),
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(_timeLabel(m.createdAt),
                        style: TextStyle(
                            fontSize: 10, color: mine ? Colors.white70 : ColorValue.textSecondary)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  MainAxisAlignment mainAxis(bool mine) => mine ? MainAxisAlignment.end : MainAxisAlignment.start;
}
