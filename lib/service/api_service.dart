import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:doan_ql_thu_chi/models/rates_currency_model.dart';

class ApiService {
  // Lấy API key từ .env file
  String get apiKey => dotenv.env['EXCHANGE_RATE_API_KEY'] ?? '';
  final Dio dio = Dio();

  Future<RatesCurrencyModel?> getExchangeRate() async {
    final url = 'https://v6.exchangerate-api.com/v6/$apiKey/latest/VND';
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return RatesCurrencyModel.fromJson(response.data as Map<String,dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

}
