import 'package:flutter/material.dart';

import '../state/customer_search_controller.dart';
import '../widgets/customer_list_item.dart';
import 'customer_detail_screen.dart';

class CustomerResultsScreen extends StatelessWidget {
  const CustomerResultsScreen({super.key, required this.controller});
  final CustomerSearchController controller;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Search Results')),
    body: AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        switch (controller.status) {
          case SearchStatus.initial:
          case SearchStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case SearchStatus.error:
            return _MessageState(
              icon: Icons.cloud_off_outlined,
              message: controller.errorMessage ?? 'Unable to load customers.',
              actionLabel: 'Try again',
              onAction: controller.refresh,
            );
          case SearchStatus.empty:
            return RefreshIndicator(
              onRefresh: controller.refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [SizedBox(height: 180), _EmptyMessage()],
              ),
            );
          case SearchStatus.success:
            return RefreshIndicator(
              onRefresh: controller.refresh,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.customers.length,
                itemBuilder: (context, index) {
                  final customer = controller.customers[index];
                  return CustomerListItem(
                    customer: customer,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            CustomerDetailScreen(customer: customer),
                      ),
                    ),
                  );
                },
              ),
            );
        }
      },
    ),
  );
}

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage();
  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      children: [
        Icon(Icons.search_off, size: 48),
        SizedBox(height: 12),
        Text('No customers matched your search.'),
      ],
    ),
  );
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });
  final IconData icon;
  final String message, actionLabel;
  final VoidCallback onAction;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    ),
  );
}
