import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message_model.dart';
import '../service/groq_ai_service.dart';
import 'home_controller.dart';

class AIChatController extends GetxController {
  final GroqAIService _aiService = GroqAIService();
  final HomeController homeController = Get.find();
  
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxString currentInput = ''.obs;
  
  final Uuid _uuid = const Uuid();
  
  @override
  void onInit() {
    super.onInit();
    _addWelcomeMessage();
  }
  
  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      id: _uuid.v4(),
      content: "Xin chào! 👋 Tôi là FinBot - trợ lý AI tài chính thông minh của bạn!\n\n"
          "🤖 Tôi có thể giúp bạn:\n"
          "💰 Phân tích chi tiêu và thu nhập\n"
          "📊 Đưa ra lời khuyên tiết kiệm\n"
          "📈 Lập kế hoạch tài chính\n"
          "💡 Tối ưu hóa ngân sách cá nhân\n\n"
          "Bạn có thể hỏi tôi về tài chính hoặc trò chuyện thân thiện! 😊\n"
          "Ví dụ: 'Tên bạn là gì?' hoặc 'Tôi nên tiết kiệm như thế nào?'",
      isUser: false,
      timestamp: DateTime.now(),
    );
    messages.add(welcomeMessage);
  }
  
  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;
    
    // Add user message
    final userChatMessage = ChatMessage(
      id: _uuid.v4(),
      content: userMessage.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userChatMessage);
    
    // Add loading message
    final loadingMessage = ChatMessage(
      id: _uuid.v4(),
      content: "Đang suy nghĩ...",
      isUser: false,
      timestamp: DateTime.now(),
      isLoading: true,
    );
    messages.add(loadingMessage);
    
    isLoading.value = true;
    
    try {
      // Get financial data
      final expenseData = _getExpenseData();
      
      // Get AI response
      final aiResponse = await _aiService.getFinancialAdvice(userMessage, expenseData);
      
      // Remove loading message
      messages.removeWhere((msg) => msg.id == loadingMessage.id);
      
      // Add AI response
      final aiChatMessage = ChatMessage(
        id: _uuid.v4(),
        content: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(aiChatMessage);
      
    } catch (e) {
      // Remove loading message
      messages.removeWhere((msg) => msg.id == loadingMessage.id);
      
      // Add error message
      final errorMessage = ChatMessage(
        id: _uuid.v4(),
        content: "Xin lỗi, có lỗi xảy ra. Vui lòng thử lại sau. 😔",
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }
  
  Map<String, dynamic> _getExpenseData() {
    final user = homeController.userModel.value;
    return {
      'current_balance': user?.tongSoDu ?? 0,
      'total_income': _calculateTotalIncome(),
      'total_expense': _calculateTotalExpense(),
      'categories': _getCategoryBreakdown(),
    };
  }
  
  double _calculateTotalIncome() {
    // Calculate from transactions or use mock data
    return homeController.listResultTK
        .where((transaction) => transaction.type == 'Thu Nhập')
        .fold(0.0, (sum, transaction) => sum + (transaction.amount));
  }
  
  double _calculateTotalExpense() {
    // Calculate from transactions or use mock data
    return homeController.listResultTK
        .where((transaction) => transaction.type == 'Chi Tiêu')
        .fold(0.0, (sum, transaction) => sum + (transaction.amount));
  }
  
  Map<String, double> _getCategoryBreakdown() {
    final Map<String, double> categories = {};
    
    for (final transaction in homeController.listResultTK) {
      if (transaction.type == 'Chi Tiêu') {
        // Get category name from categoryIdToDetails map
        final categoryModel = homeController.categoryIdToDetails[transaction.categoryId];
        final category = categoryModel?.name ?? 'Khác';
        categories[category] = (categories[category] ?? 0) + transaction.amount;
      }
    }
    
    return categories;
  }
  
  List<String> getSuggestedQuestions() {
    return _aiService.getSuggestedQuestions();
  }
  
  void clearChat() {
    messages.clear();
    _addWelcomeMessage();
  }
  
  Future<void> sendSuggestedQuestion(String question) async {
    await sendMessage(question);
  }
} 