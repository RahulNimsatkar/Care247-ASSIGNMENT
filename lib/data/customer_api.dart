import 'dart:convert';
import 'dart:io';

import '../models/customer.dart';

class CustomerApiException implements Exception {
  const CustomerApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

class CustomerApi {
  CustomerApi(this.endpoint, {HttpClient? client})
    : _client = client ?? HttpClient();
  final String endpoint;
  final HttpClient _client;

  Future<List<Customer>> fetchCustomers() async {
    try {
      final request = await _client
          .getUrl(Uri.parse(endpoint))
          .timeout(const Duration(seconds: 12));
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      final response = await request.close().timeout(
        const Duration(seconds: 12),
      );
      final body = await utf8.decoder.bind(response).join();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw CustomerApiException(
          'The customer service returned an error (${response.statusCode}). Try again.',
        );
      }
      final decoded = jsonDecode(body);
      if (decoded is! List) {
        throw const FormatException('Expected a customer list.');
      }
      return decoded
          .map((item) {
            if (item is! Map<String, dynamic>) {
              throw const FormatException('Invalid customer record.');
            }
            return Customer.fromJson(item);
          })
          .toList(growable: false);
    } on CustomerApiException {
      rethrow;
    } on FormatException {
      throw const CustomerApiException(
        'The customer service returned data in an unexpected format.',
      );
    } on SocketException {
      throw const CustomerApiException(
        'Could not connect to the customer service. Check that JSON Server is running and try again.',
      );
    } on HttpException {
      throw const CustomerApiException(
        'The customer request failed. Please try again.',
      );
    } on Exception {
      throw const CustomerApiException(
        'Could not load customers. Please check your connection and try again.',
      );
    }
  }

  void close() => _client.close(force: true);
}
