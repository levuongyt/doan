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
        print('dsa ${response.data}');
        return RatesCurrencyModel.fromJson(response.data as Map<String,dynamic>);
      } else {
        print('lỗi là: ');
        return null;
      }
    } catch (e) {
      print('Error hệ thống lấy api là : $e');
      return null;
    }
  }

//  Future<Map<String, double>?> getExchangeRates() async {
//     final url = 'https://api.exchangerate-api.com/v4/latest/USD';
//     try {
//       final response = await dio.get(url);
//       if (response.statusCode == 200) {
//         final data = response.data['rates'];
//         double usdToVnd = data['VND'];
//         double vndToUsd = 1 / usdToVnd;
//         return {'USD_TO_VND': usdToVnd, 'VND_TO_USD': vndToUsd};
//       } else {
//         print('Failed to fetch exchange rates');
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching exchange rates: $e');
//       return null;
//     }
// }
}
