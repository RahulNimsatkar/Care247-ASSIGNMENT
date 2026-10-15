import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:care247_customer_search/data/customer_api.dart';
import 'package:care247_customer_search/data/customer_repository.dart';
import 'package:care247_customer_search/models/customer.dart';

void main() {
  test('Customer parses nested data and selects primary contacts', () {
    final customer = Customer.fromJson({
      'id': 'cust-1', 'firstName': 'Rita', 'lastName': 'Shah', 'dateOfBirth': '1985-03-15',
      'maritalStatus': 'Married', 'secureId': '123-45-6789',
      'addresses': [{'id': 'a1', 'type': 'Home', 'street': '1 Main St', 'city': 'Austin', 'state': 'TX', 'zipCode': '78701'}],
      'phones': [
        {'id': 'p1', 'type': 'Work', 'number': '555-0100', 'isPrimary': false},
        {'id': 'p2', 'type': 'Mobile', 'number': '555-0101', 'isPrimary': true},
      ],
      'emails': [{'id': 'e1', 'type': 'Personal', 'address': 'rita@example.com', 'isPrimary': true}],
    });
    expect(customer.fullName, 'Rita Shah');
    expect(customer.addresses.single.city, 'Austin');
    expect(customer.primaryPhone?.number, '555-0101');
    expect(customer.primaryEmail?.address, 'rita@example.com');
  });

  test('Repository applies configured criteria case-insensitively', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final serverTask = server.forEach((request) async {
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode([{
        'id': 'cust-1', 'firstName': 'Sarah', 'lastName': 'Johnson', 'dateOfBirth': '1990-07-22',
        'maritalStatus': 'Single', 'secureId': '987-65-4321', 'addresses': [], 'phones': [], 'emails': [],
      }, {
        'id': 'cust-2', 'firstName': 'James', 'lastName': 'Brown', 'dateOfBirth': '1980-08-17',
        'maritalStatus': 'Married', 'secureId': '890-12-3456', 'addresses': [], 'phones': [], 'emails': [],
      }]));
      await request.response.close();
    });
    final api = CustomerApi('http://${server.address.address}:${server.port}/customers');
    addTearDown(() async { api.close(); await server.close(force: true); await serverTask; });

    final results = await CustomerRepository(api).search({'firstName': 'sar', 'dateOfBirth': ''});
    expect(results.map((customer) => customer.id), ['cust-1']);
  });

  test('Malformed customer fields produce a format error', () {
    expect(
      () => Customer.fromJson({'id': 'cust-1'}),
      throwsA(isA<FormatException>()),
    );
  });
}
