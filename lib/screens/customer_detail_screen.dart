import 'package:flutter/material.dart';

import '../models/customer.dart';

class CustomerDetailScreen extends StatelessWidget {
  const CustomerDetailScreen({super.key, required this.customer});
  final Customer customer;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(customer.fullName)),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Section(
          title: 'Basic Information',
          children: [
            _DetailRow(label: 'First Name', value: customer.firstName),
            _DetailRow(label: 'Last Name', value: customer.lastName),
            _DetailRow(label: 'Date of Birth', value: customer.dateOfBirth),
            _DetailRow(label: 'Marital Status', value: customer.maritalStatus),
            _DetailRow(label: 'Secure ID', value: customer.secureId),
          ],
        ),
        _Section(
          title: 'Addresses',
          children: customer.addresses
              .map(
                (address) => _ContactCard(
                  title: address.type,
                  lines: [
                    address.street,
                    '${address.city}, ${address.state} ${address.zipCode}',
                  ],
                ),
              )
              .toList(),
        ),
        _Section(
          title: 'Phones',
          children: customer.phones
              .map(
                (phone) => _ContactCard(
                  title: phone.type,
                  lines: [phone.number],
                  primary: phone.isPrimary,
                ),
              )
              .toList(),
        ),
        _Section(
          title: 'Emails',
          children: customer.emails
              .map(
                (email) => _ContactCard(
                  title: email.type,
                  lines: [email.address],
                  primary: email.isPrimary,
                ),
              )
              .toList(),
        ),
      ],
    ),
  );
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...children,
      ],
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 125,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.title,
    required this.lines,
    this.primary = false,
  });
  final String title;
  final List<String> lines;
  final bool primary;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      title: Row(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          if (primary) ...[
            const SizedBox(width: 8),
            const Chip(label: Text('Primary')),
          ],
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines.map(Text.new).toList(),
      ),
    ),
  );
}
