import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';

class LiqPayService {
  final String publicKey = 'your_public_key';
  final String privateKey = 'your_private_key';

  Future<bool> processPayment(double amount, String currency) async {
    String data = base64Encode(utf8.encode(jsonEncode({
      "version": "3",
      "public_key": publicKey,
      "action": "pay",
      "amount": amount.toString(),
      "currency": currency,
      "description": "Booking Payment",
      "order_id": DateTime.now().millisecondsSinceEpoch.toString(),
      "sandbox": "1", // Remove in production
    })));

    String signature = base64Encode(
        sha1.convert(utf8.encode(privateKey + data + privateKey)).bytes);

    try {
      final response = await http.post(
        Uri.parse('https://www.liqpay.ua/api/3/checkout'),
        body: {
          "data": data,
          "signature": signature,
        },
      );

      if (response.statusCode == 200) {
        // Handle successful payment
        print('Payment successful');
        return true;
      } else {
        // Handle payment failure
        print('Payment failed with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Payment error: $e');
      return false;
    }
  }
}
