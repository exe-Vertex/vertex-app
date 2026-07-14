import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../models/ai_history_model.dart';

class AiProvider extends ChangeNotifier {
  final AiService _aiService = AiService();

  List<AiHistoryModel> _history = [];
  bool isLoading = false;
  bool isTyping = false;
  String? errorMessage;

  /// Returns a flat list of messages suitable for UI, ordered by time descending (newest first).
  /// Each message is a Map with 'sender' ('user' or 'ai') and 'text'.
  List<Map<String, dynamic>> get messages {
    final List<Map<String, dynamic>> flatMessages = [];

    // History is usually sorted by createdAt ascending or descending from backend.
    // Let's sort it locally by createdAt descending just to be sure.
    final sortedHistory = List<AiHistoryModel>.from(_history)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    for (var item in sortedHistory) {
      // Prepend to UI list. Since we want reverse=true in ListView (newest at bottom/top),
      // If the ListView is reverse: true, index 0 is at the bottom.
      // So we want newest messages at index 0.
      if (item.planSummary != null && item.planSummary!.isNotEmpty) {
        flatMessages.add({'sender': 'ai', 'text': item.planSummary!});
      }
      flatMessages.add({'sender': 'user', 'text': item.prompt});
    }

    return flatMessages;
  }

  Future<void> fetchHistory() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _aiService.getHistory();
      _history = data.map((e) => AiHistoryModel.fromJson(e)).toList();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String prompt, String? orgId) async {
    // Add optimistic user message to history with a fake ID
    final tempItem = AiHistoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: '',
      prompt: prompt,
      planSummary: null, // No AI response yet
      createdAt: DateTime.now(),
    );
    _history.add(tempItem);

    isTyping = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _aiService.chat(prompt, orgId);
      // Remove the optimistic item and add the real one
      _history.removeWhere((item) => item.id == tempItem.id);
      _history.add(AiHistoryModel.fromJson(data));
    } catch (e) {
      errorMessage = e.toString();
      // Remove optimistic item on failure
      _history.removeWhere((item) => item.id == tempItem.id);
    } finally {
      isTyping = false;
      notifyListeners();
    }
  }
}
