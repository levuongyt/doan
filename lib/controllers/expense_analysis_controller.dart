import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ExpenseAnalysisController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var totalSpending = 0.0.obs;
  var budgetLimit = 0.0.obs;
  var lastMonthSpending = 0.0.obs;
  var savingsGoal = 0.0.obs;
  
  // Analysis data
  var spendingCategories = <SpendingCategoryModel>[].obs;
  var optimizationSuggestions = <OptimizationSuggestion>[].obs;
  var savingsTips = <SavingTipModel>[].obs;
  
  // Time period for analysis
  var selectedMonth = DateTime.now().obs;
  var analysisTimeRange = 'thisMonth'.obs; // thisMonth, lastMonth, last3Months, last6Months
  
  @override
  void onInit() {
    super.onInit();
    loadExpenseAnalysis();
  }
  
  // Load expense analysis data
  void loadExpenseAnalysis() {
    isLoading.value = true;
    
    // Load spending data
    _loadSpendingData();
    
    // Generate optimization suggestions
    _generateOptimizationSuggestions();
    
    // Load savings tips
    _loadSavingsTips();
    
    isLoading.value = false;
  }
  
  void _loadSpendingData() {
    totalSpending.value = 15000000;
    budgetLimit.value = 20000000;
    lastMonthSpending.value = 18000000;
    savingsGoal.value = 5000000;
    
    spendingCategories.addAll([
      SpendingCategoryModel(
        id: '1',
        name: 'Ăn uống',
        amount: 6000000,
        color: Colors.red,
        icon: Icons.restaurant,
        percentage: 40.0,
        trend: 'increase',
        trendPercentage: 15.0,
      ),
      SpendingCategoryModel(
        id: '2',
        name: 'Di chuyển',
        amount: 3000000,
        color: Colors.blue,
        icon: Icons.directions_car,
        percentage: 20.0,
        trend: 'stable',
        trendPercentage: 2.0,
      ),
      SpendingCategoryModel(
        id: '3',
        name: 'Mua sắm',
        amount: 2500000,
        color: Colors.green,
        icon: Icons.shopping_bag,
        percentage: 16.7,
        trend: 'decrease',
        trendPercentage: -5.0,
      ),
      SpendingCategoryModel(
        id: '4',
        name: 'Giải trí',
        amount: 2000000,
        color: Colors.orange,
        icon: Icons.movie,
        percentage: 13.3,
        trend: 'increase',
        trendPercentage: 8.0,
      ),
      SpendingCategoryModel(
        id: '5',
        name: 'Khác',
        amount: 1500000,
        color: Colors.purple,
        icon: Icons.more_horiz,
        percentage: 10.0,
        trend: 'stable',
        trendPercentage: 1.0,
      ),
    ]);
  }
  
  void _generateOptimizationSuggestions() {
    optimizationSuggestions.addAll([
      OptimizationSuggestion(
        id: '1',
        title: 'Chi tiêu ăn uống cao'.tr,
        description: 'Bạn đang chi 6M cho ăn uống (40% tổng chi). Thử nấu ăn tại nhà nhiều hơn.',
        category: 'Ăn uống',
        potentialSavings: 1500000,
        priority: 'high',
        icon: Icons.warning,
        color: Colors.red,
        actionItems: [
          'Nấu ăn tại nhà 3-4 bữa/tuần',
          'Mang cơm trưa đi làm',
          'Giảm số lần order food',
        ],
      ),
      OptimizationSuggestion(
        id: '2',
        title: 'Tối ưu di chuyển'.tr,
        description: 'Cân nhắc sử dụng xe bus/grab bike thay vì grab car để tiết kiệm.',
        category: 'Di chuyển',
        potentialSavings: 800000,
        priority: 'medium',
        icon: Icons.directions_car,
        color: Colors.blue,
        actionItems: [
          'Sử dụng xe bus cho quãng đường xa',
          'Đi grab bike thay vì grab car',
          'Xem xét mua xe máy nếu di chuyển thường xuyên',
        ],
      ),
      OptimizationSuggestion(
        id: '3',
        title: 'Kiểm soát mua sắm'.tr,
        description: 'Lập danh sách mua sắm và tránh mua đồ không cần thiết.',
        category: 'Mua sắm',
        potentialSavings: 500000,
        priority: 'low',
        icon: Icons.shopping_bag,
        color: Colors.green,
        actionItems: [
          'Lập danh sách trước khi đi mua',
          'So sánh giá trước khi mua',
          'Tránh mua đồ impulse',
        ],
      ),
    ]);
  }
  
  void _loadSavingsTips() {
    savingsTips.addAll([
      SavingTipModel(
        id: '1',
        title: '50/30/20 Rule'.tr,
        description: '50% nhu cầu thiết yếu, 30% giải trí, 20% tiết kiệm',
        icon: Icons.pie_chart,
        color: Colors.blue,
        category: 'budgeting',
      ),
      SavingTipModel(
        id: '2',
        title: 'Nấu ăn tại nhà'.tr,
        description: 'Tiết kiệm 40-60% chi phí ăn uống mỗi tháng',
        icon: Icons.home,
        color: Colors.green,
        category: 'food',
      ),
      SavingTipModel(
        id: '3',
        title: 'So sánh giá'.tr,
        description: 'Sử dụng app so sánh giá trước khi mua sắm',
        icon: Icons.compare_arrows,
        color: Colors.orange,
        category: 'shopping',
      ),
      SavingTipModel(
        id: '4',
        title: 'Tự động tiết kiệm'.tr,
        description: 'Thiết lập chuyển tiền tự động vào tài khoản tiết kiệm',
        icon: Icons.autorenew,
        color: Colors.purple,
        category: 'savings',
      ),
    ]);
  }
  
  // Calculate spending percentage of budget
  double get spendingPercentage {
    if (budgetLimit.value == 0) return 0;
    return (totalSpending.value / budgetLimit.value) * 100;
  }
  
  // Calculate comparison with last month
  double get monthlyComparison {
    if (lastMonthSpending.value == 0) return 0;
    return ((totalSpending.value - lastMonthSpending.value) / lastMonthSpending.value) * 100;
  }
  
  // Get spending status
  String get spendingStatus {
    final percentage = spendingPercentage;
    if (percentage > 90) return 'danger';
    if (percentage > 80) return 'warning';
    if (percentage > 60) return 'caution';
    return 'good';
  }
  
  // Update budget limit
  void updateBudgetLimit(double newLimit) {
    budgetLimit.value = newLimit;
  }
  
  // Update analysis time range
  void updateTimeRange(String timeRange) {
    analysisTimeRange.value = timeRange;
    loadExpenseAnalysis(); // Reload data for new time range
  }
  
  // Get total potential savings
  double get totalPotentialSavings {
    return optimizationSuggestions.fold(0.0, (sum, suggestion) => sum + suggestion.potentialSavings);
  }
  
  // Apply optimization suggestion
  void applyOptimization(String suggestionId) {
    // This could update user preferences, set reminders, etc.
  }
  
  // Mark tip as helpful
  void markTipAsHelpful(String tipId) {

  }
}

class SpendingCategoryModel {
  final String id;
  final String name;
  final double amount;
  final Color color;
  final IconData icon;
  final double percentage;
  final String trend; // 'increase', 'decrease', 'stable'
  final double trendPercentage;
  
  SpendingCategoryModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.color,
    required this.icon,
    required this.percentage,
    required this.trend,
    required this.trendPercentage,
  });
}

class OptimizationSuggestion {
  final String id;
  final String title;
  final String description;
  final String category;
  final double potentialSavings;
  final String priority; // 'high', 'medium', 'low'
  final IconData icon;
  final Color color;
  final List<String> actionItems;
  
  OptimizationSuggestion({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.potentialSavings,
    required this.priority,
    required this.icon,
    required this.color,
    required this.actionItems,
  });
}

class SavingTipModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String category;
  
  SavingTipModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.category,
  });
} 