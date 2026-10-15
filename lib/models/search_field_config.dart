enum SearchFieldType { text, date, select }

class SearchFieldConfig {
  const SearchFieldConfig({
    required this.key,
    required this.type,
    required this.label,
    this.placeholder,
    required this.renderOrder,
    this.options = const [],
  });
  final String key;
  final SearchFieldType type;
  final String label;
  final String? placeholder;
  final int renderOrder;
  final List<String> options;
}
