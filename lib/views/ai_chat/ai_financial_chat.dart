import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/ai_chat_controller.dart';
import '../../models/chat_message_model.dart';
import '../../config/themes/themes_app.dart';

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

  void _scrollToNewMessage(int messageIndex) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients && controller.messages.isNotEmpty) {
        final message = controller.messages[messageIndex];
        
        // Chỉ scroll khi AI trả lời (không phải user)
        if (!message.isUser) {
          // Kiểm tra xem user có đang scroll ở cuối không
          double currentPosition = scrollController.position.pixels;
          double maxScroll = scrollController.position.maxScrollExtent;
          bool isNearBottom = (maxScroll - currentPosition) < 200; // Trong vòng 200px từ cuối
          
          // Chỉ scroll nếu user đang ở gần cuối màn hình
          if (isNearBottom) {
            // Tính toán vị trí để hiển thị đầu tin nhắn AI
            double estimatedItemHeight = 120.0;
            double padding = 16.0;
            double targetPosition = (messageIndex * estimatedItemHeight) + padding - 50;
            
            // Đảm bảo không scroll quá giới hạn
            double minScroll = scrollController.position.minScrollExtent;
            double scrollPosition = targetPosition.clamp(minScroll, maxScroll);
            
            scrollController.animateTo(
              scrollPosition,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
          // Nếu user đang scroll ở giữa, không làm gì cả (giữ nguyên vị trí)
        }
        // Với tin nhắn của user, không scroll gì cả (giữ nguyên vị trí input)
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gradientTheme = Theme.of(context).extension<AppGradientTheme>();
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: gradientTheme?.primaryGradient ?? LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: gradientTheme?.shadowColor ?? Colors.blue.shade300.withValues(alpha: 0.5),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        title: Text(
          'TRỢ LÝ AI TÀI CHÍNH'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showNewChatDialog();
            },
            icon: const Icon(Icons.add_comment, color: Colors.white),
            tooltip: 'Cuộc trò chuyện mới'.tr,
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
                // Chỉ scroll khi có tin nhắn mới và là tin nhắn cuối cùng
                if (index == controller.messages.length - 1) {
                  _scrollToNewMessage(index);
                }
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
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              side: BorderSide(color: Theme.of(context).primaryColor.withValues(alpha: 0.3)),
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
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              child: Icon(
                Icons.smart_toy,
                size: 18,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
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
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          message.content,
                          style: TextStyle(
                            color: isUser ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      message.content,
                      style: TextStyle(
                        color: isUser ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    DateFormat('HH:mm').format(message.timestamp),
                    style: TextStyle(
                      color: isUser ? Colors.white70 : Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
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
              backgroundColor: Theme.of(context).primaryColor,
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
      padding: EdgeInsets.fromLTRB(
        16, 
        16, 
        16, 
        16 + MediaQuery.of(context).padding.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Theme.of(context).cardColor 
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
                border: Theme.of(context).brightness == Brightness.dark 
                    ? Border.all(color: Theme.of(context).dividerColor) 
                    : null,
              ),
              child: TextField(
                controller: messageController,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                                  decoration: InputDecoration(
                  hintText: 'Hỏi về tài chính cá nhân...'.tr,
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Obx(() => Container(
            decoration: BoxDecoration(
              color: controller.isLoading.value 
                  ? Theme.of(context).disabledColor 
                  : Theme.of(context).primaryColor,
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
    );
  }

  void _sendMessage() {
    final message = messageController.text.trim();
    if (message.isNotEmpty && !controller.isLoading.value) {
      controller.sendMessage(message);
      messageController.clear();
    }
  }

  void _showNewChatDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'Cuộc trò chuyện mới'.tr,
          style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
        ),
        content: Text(
          'Bạn có muốn bắt đầu cuộc trò chuyện mới? Lịch sử trò chuyện hiện tại sẽ bị xóa.'.tr,
          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Hủy'.tr,
              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.clearChat();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Bắt đầu mới'.tr,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
} 