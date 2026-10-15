import 'package:flutter/material.dart';

import '../models/customer.dart';

class CustomerListItem extends StatelessWidget {
  const CustomerListItem({
    super.key,
    required this.customer,
    required this.onTap,
  });
  final Customer customer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Text(customer.firstName.isEmpty ? '?' : customer.firstName[0]),
        ),
        title: Text(
          customer.fullName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date of birth: ${customer.dateOfBirth}'),
            if (customer.primaryPhone != null)
              Text(customer.primaryPhone!.number),
            if (customer.primaryEmail != null)
              Text(
                customer.primaryEmail!.address,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
