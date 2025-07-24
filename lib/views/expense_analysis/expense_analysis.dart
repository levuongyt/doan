import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpenseAnalysis extends StatefulWidget {
  const ExpenseAnalysis({super.key});

  @override
  State<ExpenseAnalysis> createState() => _ExpenseAnalysisState();
}

class _ExpenseAnalysisState extends State<ExpenseAnalysis> {
  final NumberFormat currencyFormatter = NumberFormat('#,##0');
  
  final double totalSpending = 15000000;
  final double budgetLimit = 20000000;
  final double lastMonthSpending = 18000000;
  final double savingsGoal = 5000000;
  final List<SpendingCategory> spendingData = [
    SpendingCategory('Ăn uống', 6000000, Colors.red, Icons.restaurant, 40.0),
    SpendingCategory('Di chuyển', 3000000, Colors.blue, Icons.directions_car, 20.0),
    SpendingCategory('Mua sắm', 2500000, Colors.green, Icons.shopping_bag, 16.7),
    SpendingCategory('Giải trí', 2000000, Colors.orange, Icons.movie, 13.3),
    SpendingCategory('Khác', 1500000, Colors.purple, Icons.more_horiz, 10.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Đánh giá chi tiêu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade600,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              _showAnalysisSettings();
            },
            icon: const Icon(Icons.tune, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Spending Overview Card
            buildSpendingOverview(),
            const SizedBox(height: 20),
            
            // Spending Chart
            buildSpendingChart(),
            const SizedBox(height: 20),
            
            // Optimization Suggestions
            buildOptimizationSuggestions(),
            const SizedBox(height: 20),
            
            // Spending Categories
            buildSpendingCategories(),
            const SizedBox(height: 20),
            
            // Savings Tips
            buildSavingsTips(),
          ],
        ),
      ),
    );
  }

  Widget buildSpendingOverview() {
    final double spendingPercentage = (totalSpending / budgetLimit) * 100;
    final double comparisonPercentage = ((totalSpending - lastMonthSpending) / lastMonthSpending) * 100;
    final bool isIncreased = comparisonPercentage > 0;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: spendingPercentage > 80 
              ? [Colors.red.shade600, Colors.red.shade400]
              : spendingPercentage > 60 
                  ? [Colors.orange.shade600, Colors.orange.shade400]
                  : [Colors.green.shade600, Colors.green.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chi tiêu tháng này',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                spendingPercentage > 80 ? Icons.warning : Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${currencyFormatter.format(totalSpending)} đ',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Đã dùng ${spendingPercentage.toStringAsFixed(1)}% ngân sách',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: spendingPercentage / 100,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                'Ngân sách: ${currencyFormatter.format(budgetLimit)} đ',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Comparison with last month
          Row(
            children: [
              Icon(
                isIncreased ? Icons.trending_up : Icons.trending_down,
                color: isIncreased ? Colors.white : Colors.green.shade200,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${isIncreased ? '+' : ''}${comparisonPercentage.toStringAsFixed(1)}% so với tháng trước',
                style: TextStyle(
                  color: isIncreased ? Colors.white : Colors.green.shade200,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSpendingChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phân bổ chi tiêu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: SfCircularChart(
              legend: const Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                textStyle: TextStyle(fontSize: 12),
              ),
              series: <CircularSeries>[
                DoughnutSeries<SpendingCategory, String>(
                  dataSource: spendingData,
                  xValueMapper: (SpendingCategory data, _) => data.name,
                  yValueMapper: (SpendingCategory data, _) => data.amount,
                  pointColorMapper: (SpendingCategory data, _) => data.color,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                  dataLabelMapper: (SpendingCategory data, _) => '${data.percentage.toStringAsFixed(1)}%',
                  innerRadius: '60%',
                ),
              ],
              tooltipBehavior: TooltipBehavior(enable: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptimizationSuggestions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.amber.shade600, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Đề xuất tối ưu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // High spending alert
          buildSuggestionItem(
            Icons.warning,
            'Chi tiêu ăn uống cao',
            'Bạn đang chi 6M cho ăn uống (40% tổng chi). Thử nấu ăn tại nhà nhiều hơn.',
            Colors.red,
            '- 1.5M/tháng',
          ),
          
          const SizedBox(height: 12),
          
          buildSuggestionItem(
            Icons.directions_car,
            'Tối ưu di chuyển',
            'Cân nhắc sử dụng xe bus/grab bike thay vì grab car để tiết kiệm.',
            Colors.blue,
            '- 800K/tháng',
          ),
          
          const SizedBox(height: 12),
          
          buildSuggestionItem(
            Icons.shopping_bag,
            'Kiểm soát mua sắm',
            'Lập danh sách mua sắm và tránh mua đồ không cần thiết.',
            Colors.green,
            '- 500K/tháng',
          ),
        ],
      ),
    );
  }

  Widget buildSuggestionItem(IconData icon, String title, String description, Color color, String savings) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          Text(
            savings,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSpendingCategories() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chi tiết theo danh mục',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: spendingData.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final category = spendingData[index];
              return buildCategoryItem(category);
            },
          ),
        ],
      ),
    );
  }

  Widget buildCategoryItem(SpendingCategory category) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(category.icon, color: category.color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${category.percentage.toStringAsFixed(1)}% tổng chi tiêu',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${currencyFormatter.format(category.amount)} đ',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: category.percentage > 30 ? Colors.red.shade100 : 
                         category.percentage > 20 ? Colors.orange.shade100 : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  category.percentage > 30 ? 'Cao' : 
                  category.percentage > 20 ? 'Trung bình' : 'Hợp lý',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: category.percentage > 30 ? Colors.red.shade700 : 
                           category.percentage > 20 ? Colors.orange.shade700 : Colors.green.shade700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSavingsTips() {
    final List<SavingTip> tips = [
      SavingTip(
        '50/30/20 Rule',
        '50% nhu cầu thiết yếu, 30% giải trí, 20% tiết kiệm',
        Icons.pie_chart,
        Colors.blue,
      ),
      SavingTip(
        'Nấu ăn tại nhà',
        'Tiết kiệm 40-60% chi phí ăn uống mỗi tháng',
        Icons.home,
        Colors.green,
      ),
      SavingTip(
        'So sánh giá',
        'Sử dụng app so sánh giá trước khi mua sắm',
        Icons.compare_arrows,
        Colors.orange,
      ),
      SavingTip(
        'Tự động tiết kiệm',
        'Thiết lập chuyển tiền tự động vào tài khoản tiết kiệm',
        Icons.autorenew,
        Colors.purple,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tips_and_updates, color: Colors.amber.shade600, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Tips tiết kiệm',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: tips.length,
            itemBuilder: (context, index) {
              final tip = tips[index];
              return buildTipCard(tip);
            },
          ),
        ],
      ),
    );
  }

  Widget buildTipCard(SavingTip tip) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tip.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tip.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(tip.icon, color: tip.color, size: 24),
          const SizedBox(height: 8),
          Text(
            tip.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: tip.color,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              tip.description,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade700,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showAnalysisSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
                      title: Text('Cài đặt phân tích'.tr),
                content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: Text('Chọn khoảng thời gian'.tr),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: const Icon(Icons.tune),
              title: Text('Tùy chỉnh ngân sách'.tr),
              trailing: const Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: Text('Quản lý danh mục'.tr),
              trailing: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'.tr),
          ),
        ],
      ),
    );
  }
}

class SpendingCategory {
  final String name;
  final double amount;
  final Color color;
  final IconData icon;
  final double percentage;

  SpendingCategory(this.name, this.amount, this.color, this.icon, this.percentage);
}

class SavingTip {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  SavingTip(this.title, this.description, this.icon, this.color);
} 