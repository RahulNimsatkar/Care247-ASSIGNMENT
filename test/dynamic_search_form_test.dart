import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:care247_customer_search/models/search_field_config.dart';
import 'package:care247_customer_search/widgets/dynamic_search_form.dart';

void main() {
  testWidgets(
    'renders configured fields in render order and collects select values',
    (tester) async {
      Map<String, String>? submitted;
      const fields = [
        SearchFieldConfig(
          key: 'maritalStatus',
          type: SearchFieldType.select,
          label: 'Marital Status',
          renderOrder: 3,
          options: ['Single', 'Married'],
        ),
        SearchFieldConfig(
          key: 'lastName',
          type: SearchFieldType.text,
          label: 'Last Name',
          renderOrder: 2,
        ),
        SearchFieldConfig(
          key: 'firstName',
          type: SearchFieldType.text,
          label: 'First Name',
          renderOrder: 1,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicSearchForm(
                fields: fields,
                onSubmit: (values) => submitted = values,
                onClear: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(
        tester.getTopLeft(find.byType(TextFormField).first).dy,
        lessThan(tester.getTopLeft(find.byType(TextFormField).last).dy),
      );
      await tester.enterText(find.byKey(const ValueKey('firstName')), 'Ada');
      await tester.tap(find.text('Search'));
      await tester.pump();
      expect(submitted?['firstName'], 'Ada');
      expect(submitted?['lastName'], isNull);
    },
  );
}
