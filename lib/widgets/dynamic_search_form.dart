import 'package:flutter/material.dart';

import '../models/search_field_config.dart';

class DynamicSearchForm extends StatefulWidget {
  const DynamicSearchForm({
    super.key,
    required this.fields,
    required this.onSubmit,
    required this.onClear,
  });
  final List<SearchFieldConfig> fields;
  final ValueChanged<Map<String, String>> onSubmit;
  final VoidCallback onClear;

  @override
  State<DynamicSearchForm> createState() => _DynamicSearchFormState();
}

class _DynamicSearchFormState extends State<DynamicSearchForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, String> _values = {};

  @override
  void initState() {
    super.initState();
    _syncControllers();
  }

  @override
  void didUpdateWidget(covariant DynamicSearchForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncControllers();
  }

  void _syncControllers() {
    for (final field in widget.fields.where(
      (field) => field.type != SearchFieldType.select,
    )) {
      _textControllers.putIfAbsent(field.key, TextEditingController.new);
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(Map.unmodifiable(_values));
    }
  }

  void _clear() {
    for (final controller in _textControllers.values) {
      controller.clear();
    }
    setState(_values.clear);
    widget.onClear();
  }

  Future<void> _pickDate(SearchFieldConfig field) async {
    FocusScope.of(context).unfocus();
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: field.label,
    );
    if (!mounted || selected == null) return;
    final formatted =
        '${selected.year.toString().padLeft(4, '0')}-${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}';
    setState(() {
      _values[field.key] = formatted;
      _textControllers[field.key]?.text = formatted;
    });
  }

  Widget _buildField(SearchFieldConfig field, int index) {
    final controller = _textControllers[field.key];
    switch (field.type) {
      case SearchFieldType.text:
        return TextFormField(
          key: ValueKey(field.key),
          controller: controller,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: field.label,
            hintText: field.placeholder,
          ),
          onChanged: (value) => _values[field.key] = value,
        );
      case SearchFieldType.date:
        return TextFormField(
          key: ValueKey(field.key),
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            labelText: field.label,
            hintText: field.placeholder,
            suffixIcon: const Icon(Icons.calendar_month_outlined),
          ),
          onTap: () => _pickDate(field),
        );
      case SearchFieldType.select:
        return DropdownButtonFormField<String>(
          key: ValueKey(field.key),
          initialValue: _values[field.key],
          decoration: InputDecoration(labelText: field.label),
          items: field.options
              .map(
                (option) =>
                    DropdownMenuItem(value: option, child: Text(option)),
              )
              .toList(),
          onChanged: (value) => setState(() {
            if (value == null) {
              _values.remove(field.key);
            } else {
              _values[field.key] = value;
            }
          }),
        );
    }
  }

  @override
  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fields = [...widget.fields]
      ..sort((a, b) => a.renderOrder.compareTo(b.renderOrder));
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < fields.length; i++) ...[
            _buildField(fields[i], i),
            const SizedBox(height: 16),
          ],
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.search),
                  label: const Text('Search'),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(onPressed: _clear, child: const Text('Clear')),
            ],
          ),
        ],
      ),
    );
  }
}
