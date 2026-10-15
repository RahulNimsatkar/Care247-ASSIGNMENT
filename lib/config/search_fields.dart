import '../models/search_field_config.dart';

const List<SearchFieldConfig> searchFields = [
  SearchFieldConfig(
    key: 'firstName',
    type: SearchFieldType.text,
    label: 'First Name',
    placeholder: 'Enter first name',
    renderOrder: 1,
  ),
  SearchFieldConfig(
    key: 'lastName',
    type: SearchFieldType.text,
    label: 'Last Name',
    placeholder: 'Enter last name',
    renderOrder: 2,
  ),
  SearchFieldConfig(
    key: 'dateOfBirth',
    type: SearchFieldType.date,
    label: 'Date of Birth',
    placeholder: 'Select date of birth',
    renderOrder: 3,
  ),
  // Example of an additional field supported by the generic renderer:
  // SearchFieldConfig(key: 'maritalStatus', type: SearchFieldType.select, label: 'Marital Status', renderOrder: 4,
  //   options: ['Single', 'Married', 'Divorced', 'Widowed']),
];
