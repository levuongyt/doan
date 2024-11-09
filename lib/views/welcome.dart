import 'package:doan_ql_thu_chi/views/sign_in.dart';
import 'package:doan_ql_thu_chi/views/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../config/images/image_app.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    final doubleHeight = MediaQuery.of(context).size.height;
    final doubleWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      //backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: PageView(
                  controller: pageController,
                  children: [
                    //_buildPageContent(ImageApp.imageWelcome),
                    buildPage(
                        context,
                        ImageApp.imageWelcome,
                        'Chào mừng bạn đến với Sổ thu chi cá nhân\n',
                        'Ứng dụng giúp bạn quản lý thu nhập, chi tiêu và ngân sách một cách hiệu quả. Đăng ký ngay để bắt đầu kiểm soát tài chính của bạn!'),
                    buildPage(
                        context,
                        ImageApp.imageWcome2,
                        'Kiểm soát chi tiêu thông minh\n',
                        'Phân loại các khoản chi tiêu hàng ngày, từ ăn uống, mua sắm đến hóa đơn. Xác định các khoản chi lớn và tối ưu ngân sách.'),
                    buildPage(
                      context,
                      ImageApp.imageWelcome3,
                      'Báo cáo và phân tích tài chính\n',
                      'Xem báo cáo tổng quan về tình hình tài chính, biểu đồ chi tiêu và thu nhập. Đưa ra quyết định tài chính dựa trên các phân tích chi tiết.',
                    ),
                  ],
                ),
              ),
              SmoothPageIndicator(
                controller: pageController,
                count: 3,
                effect: const WormEffect(
                  dotHeight: 12,
                  dotWidth: 12,
                  dotColor: Colors.grey,
                  activeDotColor: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: doubleWidth * (250 / 360),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).indicatorColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Get.off(const SignUp());
                  },
                  child: const Text(
                    'Đăng ký',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: doubleWidth * (250 / 360),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).indicatorColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // Get.to(const SignIn());
                    Get.off(SignIn());
                  },
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildPage(BuildContext context, String imagePath, String titleText,
      String subText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 250),
          const SizedBox(height: 20),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.titleMedium,
              children: [
                TextSpan(
                  text: titleText,
                  // style: TextStyle(
                  //   fontSize: 18,
                  //   fontWeight: FontWeight.bold,
                  // ),
                ),
                TextSpan(
                  text: subText,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
