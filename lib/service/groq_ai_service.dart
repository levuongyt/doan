import 'package:groq/groq.dart';
import 'package:get/get.dart';

class GroqAIService {
  Groq? _groq;
  
  // API key được cung cấp
  static const String _apiKey = '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';
  
  GroqAIService() {
    _initializeGroq();
  }
  
  void _initializeGroq() {
    try {
      _groq = Groq(
        apiKey: _apiKey,
        model: "meta-llama/llama-4-scout-17b-16e-instruct", 
      );
      
      // Bắt đầu chat session
      _groq?.startChat();
      
      // Thiết lập hướng dẫn cho AI
      _groq?.setCustomInstructionsWith(
        "Bạn là trợ lý AI tài chính thông minh và thân thiện tên là FinBot. "
        "Chuyên môn chính của bạn là tư vấn tài chính cá nhân, quản lý chi tiêu và tiết kiệm. "
        "Tuy nhiên, bạn cũng có thể trò chuyện thân thiện về các chủ đề khác. "
        "Khi được hỏi về tài chính, hãy phân tích dữ liệu chi tiêu và đưa ra lời khuyên cụ thể. "
        "Khi được hỏi về chủ đề khác, hãy trả lời một cách thân thiện và cố gắng liên kết về tài chính nếu có thể. "
        "Luôn trả lời bằng tiếng Việt, ngắn gọn, dễ hiểu và sử dụng emoji phù hợp."
      );
      
      print('✅ Groq AI đã được khởi tạo thành công');
    } catch (e) {
      print('❌ Lỗi khởi tạo Groq: $e');
      _groq = null;
    }
  }
  
  Future<String> getFinancialAdvice(String userQuestion, Map<String, dynamic> expenseData) async {
    print('🔍 Debug: getFinancialAdvice called with question: $userQuestion');
    print('🔍 Debug: _groq is null? ${_groq == null}');
    
    // Kiểm tra khởi tạo Groq
    if (_groq == null) {
      print('❌ Debug: Groq is null, returning default advice');
      return _getDefaultAdvice(userQuestion);
    }
    
    String prompt = '''
Dữ liệu tài chính của tôi:
- Tổng thu nhập: ${expenseData['total_income'] ?? 0} VND
- Tổng chi tiêu: ${expenseData['total_expense'] ?? 0} VND
- Số dư hiện tại: ${expenseData['current_balance'] ?? 0} VND
- Chi tiêu theo danh mục: ${expenseData['categories'] ?? {}}

Câu hỏi của tôi: $userQuestion

Hãy đưa ra lời khuyên cụ thể và thực tế để giúp tôi quản lý tài chính tốt hơn.
    ''';
    
    try {
      print('🚀 Debug: Calling Groq API...');
      GroqResponse response = await _groq!.sendMessage(prompt);
      print('✅ Debug: Groq API response received');
      String content = response.choices.first.message.content ?? "Xin lỗi, tôi không thể trả lời câu hỏi này lúc này.";
      print('📝 Debug: Response content: ${content.substring(0, content.length > 100 ? 100 : content.length)}...');
      return content;
    } catch (e) {
      print('❌ Groq AI Error: $e');
      print('🔄 Debug: Falling back to default advice');
      
      // Trả về lời khuyên mặc định nếu API không hoạt động
      return _getDefaultAdvice(userQuestion);
    }
  }
  
  String _getDefaultAdvice(String question) {
    final lowerQuestion = question.toLowerCase();
    
    // Xử lý câu hỏi về tên và giới thiệu
    if (lowerQuestion.contains('tên') || lowerQuestion.contains('là ai') || 
        lowerQuestion.contains('giới thiệu') || lowerQuestion.contains('hello') || 
        lowerQuestion.contains('xin chào')) {
      return "👋 Xin chào! Tôi là FinBot - trợ lý AI tài chính của bạn!\n\n"
          "🤖 Tôi có thể giúp bạn:\n"
          "💰 Tư vấn về tiết kiệm và đầu tư\n"
          "📊 Phân tích chi tiêu cá nhân\n"
          "📈 Lập kế hoạch tài chính\n"
          "💡 Đưa ra lời khuyên quản lý tiền bạc\n\n"
          "Hãy hỏi tôi bất cứ điều gì về tài chính nhé! 😊";
    }
    
    // Xử lý câu hỏi về tiết kiệm
    if (lowerQuestion.contains('tiết kiệm')) {
      return "💰 Lời khuyên tiết kiệm:\n\n"
          "• Áp dụng quy tắc 50/30/20: 50% cho nhu cầu thiết yếu, 30% cho giải trí, 20% cho tiết kiệm\n"
          "• Tự động chuyển tiền tiết kiệm ngay khi nhận lương\n"
          "• Cắt giảm các chi phí không cần thiết như đăng ký dịch vụ không sử dụng\n"
          "• Mua sắm thông minh: so sánh giá và chờ khuyến mãi";
    }
    
    // Xử lý câu hỏi về chi tiêu
    if (lowerQuestion.contains('chi tiêu') || lowerQuestion.contains('cắt giảm')) {
      return "📊 Quản lý chi tiêu hiệu quả:\n\n"
          "• Ghi chép mọi khoản chi tiêu trong 1 tháng để hiểu rõ thói quen\n"
          "• Ưu tiên chi tiêu theo thứ tự: nhu cầu thiết yếu → tiết kiệm → giải trí\n"
          "• Sử dụng phương pháp 'chờ 24h' trước khi mua đồ không thiết yếu\n"
          "• Đặt ngân sách cụ thể cho từng danh mục chi tiêu";
    }
    
    // Xử lý câu hỏi về ngân sách và kế hoạch
    if (lowerQuestion.contains('ngân sách') || lowerQuestion.contains('kế hoạch')) {
      return "📈 Lập kế hoạch tài chính:\n\n"
          "• Xác định mục tiêu tài chính ngắn hạn và dài hạn\n"
          "• Tạo quỹ khẩn cấp bằng 3-6 tháng chi phí sinh hoạt\n"
          "• Đầu tư học hỏi về tài chính cá nhân\n"
          "• Xem xét các kênh đầu tư phù hợp với khả năng rủi ro";
    }
    
    // Xử lý câu hỏi chung khác
    if (lowerQuestion.contains('cảm ơn') || lowerQuestion.contains('thank')) {
      return "😊 Không có gì! Tôi luôn sẵn sàng giúp bạn quản lý tài chính tốt hơn.\n\n"
          "💡 Nhớ rằng: Quản lý tài chính tốt là chìa khóa cho cuộc sống hạnh phúc! 🔑";
    }
    
    // Trả lời mặc định cho các câu hỏi khác
    return "🤖 Tôi là FinBot - chuyên gia tư vấn tài chính của bạn!\n\n"
        "💡 Tôi có thể giúp bạn về:\n"
        "• Lập kế hoạch tiết kiệm và chi tiêu\n"
        "• Phân tích thói quen tài chính\n"
        "• Tư vấn đầu tư cơ bản\n"
        "• Quản lý ngân sách cá nhân\n\n"
        "Hãy hỏi tôi về tài chính hoặc chia sẻ tình hình chi tiêu để được tư vấn cụ thể nhé! 😊";
  }
  
  Future<String> getGeneralFinancialTip() async {
    if (_groq == null) {
      return "💡 Mẹo tài chính hôm nay: Hãy theo dõi chi tiêu hàng ngày để kiểm soát tài chính tốt hơn! 📊";
    }
    
    try {
      GroqResponse response = await _groq!.sendMessage(
        "Hãy đưa ra một lời khuyên ngắn gọn về quản lý tài chính cá nhân bằng tiếng Việt."
      );
      return response.choices.first.message.content ?? "Hãy lập kế hoạch chi tiêu và tiết kiệm đều đặn! 💰";
    } catch (e) {
      return "💡 Mẹo tài chính: Hãy lập kế hoạch chi tiêu và tiết kiệm đều đặn! 💰";
    }
  }
  
  List<String> getSuggestedQuestions() {
    return [
      "Tên bạn là gì?",
      "Tôi nên cắt giảm chi tiêu ở đâu?",
      "Làm sao để tiết kiệm hiệu quả?",
      "Chi tiêu của tôi có hợp lý không?",
      "Cách lập ngân sách chi tiêu?",
      "Đầu tư tiền nhàn rỗi như thế nào?",
    ];
  }
} 