import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:collabin/core/common/api_config.dart';
import 'package:collabin/core/common/api_exception.dart';
import 'package:collabin/core/common/shared_code.dart';

/// Percakapan = chat grup satu project (owner + anggota yang sudah ACCEPTED).
class Conversation {
  Conversation({
    required this.projectId,
    required this.title,
    required this.projectPicture,
    required this.isOwner,
    required this.memberCount,
    required this.lastMessage,
    required this.unreadCount,
  });

  final int projectId;
  final String title;
  final String? projectPicture;
  final bool isOwner;
  final int memberCount;
  final ChatMessage? lastMessage;
  final int unreadCount;

  factory Conversation.fromJson(Map<String, dynamic> j) => Conversation(
        projectId: j['projectId'] as int,
        title: j['title']?.toString() ?? '',
        projectPicture: j['projectPicture']?.toString(),
        isOwner: j['isOwner'] == true,
        memberCount: (j['memberCount'] as num?)?.toInt() ?? 1,
        lastMessage: j['lastMessage'] == null
            ? null
            : ChatMessage.fromJson(Map<String, dynamic>.from(j['lastMessage'])),
        unreadCount: (j['unreadCount'] as num?)?.toInt() ?? 0,
      );
}

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderPicture,
    required this.text,
    required this.createdAt,
  });

  final int id;
  final int senderId;
  final String senderName;
  final String? senderPicture;
  final String text;
  final DateTime createdAt;

  factory ChatMessage.fromJson(Map<String, dynamic> j) => ChatMessage(
        id: j['id'] as int,
        senderId: j['senderId'] as int,
        senderName: j['senderName']?.toString() ?? '',
        senderPicture: j['senderPicture']?.toString(),
        text: j['text']?.toString() ?? '',
        createdAt: DateTime.tryParse(j['createdAt']?.toString() ?? '') ?? DateTime.now(),
      );
}

/// Endpoint chat grup project (`/api/v1/messages/*`) pada backend Spring Boot.
class MessageService {
  final SharedCode _sharedCode = SharedCode();

  Future<Map<String, String>> _headers() async => {
        HttpHeaders.authorizationHeader: 'Bearer ${await _sharedCode.getAuthToken()}',
        HttpHeaders.contentTypeHeader: 'application/json',
      };

  dynamic _data(http.Response r, String fallback) {
    Map<String, dynamic>? json;
    try {
      json = jsonDecode(r.body) as Map<String, dynamic>;
    } catch (_) {}
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw ApiException(json?['message']?.toString() ?? fallback, r.statusCode);
    }
    return json?['data'];
  }

  Future<List<Conversation>> getConversations() async {
    final r = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/v1/messages/conversations'),
      headers: await _headers(),
    );
    final data = _data(r, 'Gagal memuat percakapan') as List? ?? [];
    return data.map((e) => Conversation.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<List<ChatMessage>> getMessages(int projectId) async {
    final r = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/v1/messages/project/$projectId'),
      headers: await _headers(),
    );
    final data = _data(r, 'Gagal memuat pesan') as List? ?? [];
    return data.map((e) => ChatMessage.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<ChatMessage> send(int projectId, String text) async {
    final r = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/v1/messages/project/$projectId'),
      headers: await _headers(),
      body: jsonEncode({'text': text}),
    );
    return ChatMessage.fromJson(Map<String, dynamic>.from(_data(r, 'Gagal mengirim pesan')));
  }
}
