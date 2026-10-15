import 'package:flutter/material.dart';

import '../config/search_fields.dart';
import '../state/customer_search_controller.dart';
import '../widgets/dynamic_search_form.dart';
import 'customer_results_screen.dart';

class CustomerSearchScreen extends StatefulWidget {
  const CustomerSearchScreen({super.key, required this.controller});
  final CustomerSearchController controller;

  @override
  State<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
  void _search(Map<String, String> criteria) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CustomerResultsScreen(controller: widget.controller),
      ),
    );
    widget.controller.search(criteria);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Customer Search')),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Find a customer',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Enter one or more details to search the customer directory.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          DynamicSearchForm(
            fields: searchFields,
            onSubmit: _search,
            onClear: () {},
          ),
        ],
      ),
    ),
  );
}
