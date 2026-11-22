/// Helper nomor WhatsApp: simpan & tampilkan sebagai NOMOR, bukan link.
class PhoneHelper {
  PhoneHelper._();

  /// Ambil digit saja dari input apa pun ("+62 812-3456", "https://wa.me/62812...", "0812...").
  static String digitsOnly(String? value) => (value ?? '').replaceAll(RegExp(r'[^0-9]'), '');

  /// Normalisasi ke format internasional tanpa "+" (contoh: 6281234567890).
  static String normalize(String? value) {
    var d = digitsOnly(value);
    if (d.isEmpty) return '';
    if (d.startsWith('0')) d = '62${d.substring(1)}';
    if (d.startsWith('8')) d = '62$d';
    return d;
  }

  /// Bagian nomor setelah kode negara, untuk diisi ke field (+62 sudah jadi prefix).
  static String localPart(String? value) {
    final n = normalize(value);
    return n.startsWith('62') ? n.substring(2) : n;
  }

  /// Tampilan yang enak dibaca: +62 812-3456-7890
  static String pretty(String? value) {
    final local = localPart(value);
    if (local.isEmpty) return '';
    final parts = <String>[local.substring(0, local.length < 3 ? local.length : 3)];
    for (var i = 3; i < local.length; i += 4) {
      parts.add(local.substring(i, i + 4 > local.length ? local.length : i + 4));
    }
    return '+62 ${parts.join('-')}';
  }

  /// Validasi nomor Indonesia: 9–13 digit setelah +62 dan diawali 8.
  static String? validate(String? value) {
    final local = digitsOnly(value);
    if (local.isEmpty) return null; // opsional
    final n = localPart(local);
    if (!n.startsWith('8')) return 'Nomor WhatsApp diawali 8 (contoh: 81234567890)';
    if (n.length < 9 || n.length > 13) return 'Nomor WhatsApp harus 9–13 digit';
    return null;
  }

  static Uri waUri(String? value) => Uri.parse('https://wa.me/${normalize(value)}');
}
