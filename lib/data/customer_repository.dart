import '../models/customer.dart';
import 'customer_api.dart';

class CustomerRepository {
  const CustomerRepository(this._api);
  final CustomerApi _api;

  Future<List<Customer>> search(Map<String, String> criteria) async {
    final customers = await _api.fetchCustomers();
    return customers
        .where((customer) {
          return criteria.entries.every((entry) {
            final expected = entry.value.trim();
            if (expected.isEmpty) return true;
            final actual = switch (entry.key) {
              'firstName' => customer.firstName,
              'lastName' => customer.lastName,
              'dateOfBirth' => customer.dateOfBirth,
              'maritalStatus' => customer.maritalStatus,
              _ => null,
            };
            return actual != null &&
                actual.toLowerCase().contains(expected.toLowerCase());
          });
        })
        .toList(growable: false);
  }
}
