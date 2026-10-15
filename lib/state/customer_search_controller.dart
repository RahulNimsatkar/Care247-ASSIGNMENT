import 'package:flutter/foundation.dart';

import '../data/customer_repository.dart';
import '../models/customer.dart';

enum SearchStatus { initial, loading, success, empty, error }

class CustomerSearchController extends ChangeNotifier {
  CustomerSearchController(this._repository);
  final CustomerRepository _repository;
  SearchStatus status = SearchStatus.initial;
  List<Customer> customers = const [];
  String? errorMessage;
  Map<String, String> _criteria = const {};
  int _requestVersion = 0;
  bool _isDisposed = false;

  Future<void> search(Map<String, String> criteria) async {
    _criteria = Map.unmodifiable(criteria);
    await _load();
  }

  Future<void> refresh() => _load();

  Future<void> _load() async {
    if (_isDisposed) return;
    final requestVersion = ++_requestVersion;
    status = SearchStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      final results = await _repository.search(_criteria);
      if (_isDisposed || requestVersion != _requestVersion) return;
      customers = results;
      status = customers.isEmpty ? SearchStatus.empty : SearchStatus.success;
    } catch (error) {
      if (_isDisposed || requestVersion != _requestVersion) return;
      errorMessage = error.toString();
      status = SearchStatus.error;
    }
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
