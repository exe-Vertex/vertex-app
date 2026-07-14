import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/ai_provider.dart';

class AiChatWidget extends StatefulWidget {
  final String? orgId;
  const AiChatWidget({super.key, this.orgId});

  @override
  State<AiChatWidget> createState() => _AiChatWidgetState();
}

class _AiChatWidgetState extends State<AiChatWidget> {
  final _messageController = TextEditingController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        context.read<AiProvider>().fetchHistory();
        _isInitialized = true;
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final prompt = _messageController.text.trim();
    _messageController.clear();

    context.read<AiProvider>().sendMessage(prompt, widget.orgId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F1A2A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Vertex AI Assistant',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: Consumer<AiProvider>(
              builder: (context, aiProvider, child) {
                if (aiProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (aiProvider.errorMessage != null) {
                  return Center(
                    child: Text(
                      aiProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final messages = aiProvider.messages;

                if (messages.isEmpty && !aiProvider.isTyping) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 48,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No history yet. Ask me anything!',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  reverse: true, // newest messages at the bottom
                  itemCount: messages.length + (aiProvider.isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (aiProvider.isTyping && index == 0) {
                      return _buildMessageBubble(
                        context: context,
                        isUser: false,
                        text: 'Thinking...',
                        isTypingIndicator: true,
                      );
                    }

                    final msgIndex = aiProvider.isTyping ? index - 1 : index;
                    final msg = messages[msgIndex];
                    final isUser = msg['sender'] == 'user';

                    return _buildMessageBubble(
                      context: context,
                      isUser: isUser,
                      text: msg['text'],
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Ask me anything...',
                    filled: true,
                    fillColor: const Color(0xFF162032),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  onPressed: _sendMessage,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required BuildContext context,
    required bool isUser,
    required String text,
    bool isTypingIndicator = false,
  }) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).primaryColor
              : const Color(0xFF162032),
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isUser
                ? const Radius.circular(0)
                : const Radius.circular(16),
            bottomLeft: !isUser
                ? const Radius.circular(0)
                : const Radius.circular(16),
          ),
        ),
        child: isTypingIndicator
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              )
            : SelectableText(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.grey[300],
                ),
              ),
      ),
    );
  }
}
