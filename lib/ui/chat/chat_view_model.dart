import 'package:fluentzy/data/models/chat_message.dart';
import 'package:fluentzy/data/repositories/ai_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class ChatViewModel extends ChangeNotifier {
  final AiRepository _aiRepository;
  final Box<ChatMessage> _chatBox = Hive.box<ChatMessage>('chatBox');

  List<ChatMessage> get messages => _chatBox.values.toList();

  bool _isThinking = false;
  bool get isThinking => _isThinking;

  ChatViewModel(this._aiRepository) {
    final List<ChatMessage> userMessages =
        messages.where((message) => message.isUser).toList();
    _aiRepository.startChatSession(userMessages);
  }
  
  @override
  dispose() {
    _aiRepository.endChatSession();
    super.dispose();
  }

  void addMessage({required String text, bool isUser = true}) {
    if (isUser) {
      getResponse(text: text);
    }
    _chatBox.add(ChatMessage(text: text, isUser: isUser));
    notifyListeners();
  }

  Future<void> getResponse({required String text}) async {
    _isThinking = true;
    notifyListeners();
    final response = await _aiRepository.sendMessage(text: text);
    _isThinking = false;
    if (response != null) {
      addMessage(text: response, isUser: false);
    } else {
      addMessage(text: "Error: Unable to get response", isUser: false);
    }
  }

  Future<void> clearMessages() async {
    await _chatBox.clear();
    notifyListeners();
  }

}
