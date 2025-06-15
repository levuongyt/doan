import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/ai_chat_controller.dart';
import '../../models/chat_message_model.dart';

class AIFinancialChat extends StatefulWidget {
  const AIFinancialChat({super.key});

  @override
  State<AIFinancialChat> createState() => _AIFinancialChatState();
}

class _AIFinancialChatState extends State<AIFinancialChat> {
  final AIChatController controller = Get.put(AIChatController());
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Trợ lý AI Tài chính',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              _showClearChatDialog();
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Xóa cuộc trò chuyện',
          ),
        ],
      ),
      body: Column(
        children: [
          // Suggested Questions
          _buildSuggestedQuestions(),
          
          // Chat Messages
          Expanded(
            child: Obx(() => ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final message = controller.messages[index];
                _scrollToBottom();
                return _buildMessageBubble(message);
              },
            )),
          ),
          
          // Input Area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildSuggestedQuestions() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.getSuggestedQuestions().length,
        itemBuilder: (context, index) {
          final question = controller.getSuggestedQuestions()[index];
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(
                question,
                style: const TextStyle(fontSize: 12),
              ),
              onPressed: () {
                controller.sendSuggestedQuestion(question);
              },
              backgroundColor: Colors.blue.shade50,
              side: BorderSide(color: Colors.blue.shade200),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    final isLoading = message.isLoading;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue.shade100,
              child: Icon(
                Icons.smart_toy,
                size: 18,
                color: Colors.blue.shade600,
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue.shade600 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isLoading)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue.shade600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          message.content,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      message.content,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    DateFormat('HH:mm').format(message.timestamp),
                    style: TextStyle(
                      color: isUser ? Colors.white70 : Colors.grey.shade600,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue.shade600,
              child: const Icon(
                Icons.person,
                size: 18,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: messageController,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: const InputDecoration(
                    hintText: 'Hỏi về tài chính cá nhân...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Obx(() => Container(
              decoration: BoxDecoration(
                color: controller.isLoading.value 
                    ? Colors.grey.shade300 
                    : Colors.blue.shade600,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: controller.isLoading.value ? null : _sendMessage,
                icon: controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final message = messageController.text.trim();
    if (message.isNotEmpty && !controller.isLoading.value) {
      controller.sendMessage(message);
      messageController.clear();
    }
  }

  void _showClearChatDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Xóa cuộc trò chuyện'),
        content: const Text('Bạn có chắc chắn muốn xóa toàn bộ cuộc trò chuyện?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.clearChat();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
} 