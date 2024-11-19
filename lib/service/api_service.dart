import 'package:dio/dio.dart';
import 'package:doan_ql_thu_chi/models/rates_currency_model.dart';

class ApiService {
  final String apiKey = '14d0306192d750bb3165c7dd';
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
