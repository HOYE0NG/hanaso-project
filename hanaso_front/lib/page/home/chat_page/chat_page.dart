import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hanaso_front/service/api_client.dart';

import '../../../interface/user_interface.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  List<String> _chatHistory = [];
  int _messageCount = 0; // 답변 받은 횟수를 추적

  Future<void> _sendMessage(String message) async {
    try {
      final String apiUrl = '$BASE_URL/api/chat/';
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'message': message,
          'messageCount' : _messageCount.toString()
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String chatGptResponse = responseData['response'];

        setState(() {
          _chatHistory.add('You: $message');
          _chatHistory.add('maru: $chatGptResponse');
          _messageCount++; // 답변 받은 횟수 증가
        });

        // 답변을 5번 받았을 때 대화 종료
        if (_messageCount == 5) {
          _endConversation();
        }
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  // 대화 종료 시 서버로 대화 기록 전송
  Future<void> _endConversation() async {
    try {
      final String apiUrl = '$BASE_URL/api/chat/score';
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'chatHistory': _chatHistory,
        }),
      );

      if (response.statusCode == 200) {
        print('Conversation ended. Chat history sent to server.');
      } else {
        throw Exception('Failed to end conversation: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('일본어로 maru에게 인사를 해보세요!'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_chatHistory[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String message = _messageController.text;
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                      _messageController.clear();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
