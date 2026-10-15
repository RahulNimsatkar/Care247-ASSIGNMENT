class Address {
  const Address({
    required this.id,
    required this.type,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
  });
  final String id, type, street, city, state, zipCode;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: _string(json, 'id'),
    type: _string(json, 'type'),
    street: _string(json, 'street'),
    city: _string(json, 'city'),
    state: _string(json, 'state'),
    zipCode: _string(json, 'zipCode'),
  );
}

class Phone {
  const Phone({
    required this.id,
    required this.type,
    required this.number,
    required this.isPrimary,
  });
  final String id, type, number;
  final bool isPrimary;

  factory Phone.fromJson(Map<String, dynamic> json) => Phone(
    id: _string(json, 'id'),
    type: _string(json, 'type'),
    number: _string(json, 'number'),
    isPrimary: json['isPrimary'] == true,
  );
}

class Email {
  const Email({
    required this.id,
    required this.type,
    required this.address,
    required this.isPrimary,
  });
  final String id, type, address;
  final bool isPrimary;

  factory Email.fromJson(Map<String, dynamic> json) => Email(
    id: _string(json, 'id'),
    type: _string(json, 'type'),
    address: _string(json, 'address'),
    isPrimary: json['isPrimary'] == true,
  );
}

class Customer {
  const Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.maritalStatus,
    required this.secureId,
    required this.addresses,
    required this.phones,
    required this.emails,
  });
  final String id, firstName, lastName, dateOfBirth, maritalStatus, secureId;
  final List<Address> addresses;
  final List<Phone> phones;
  final List<Email> emails;

  String get fullName => '$firstName $lastName'.trim();
  Phone? get primaryPhone => _primary(phones, (value) => value.isPrimary);
  Email? get primaryEmail => _primary(emails, (value) => value.isPrimary);

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: _string(json, 'id'),
    firstName: _string(json, 'firstName'),
    lastName: _string(json, 'lastName'),
    dateOfBirth: _string(json, 'dateOfBirth'),
    maritalStatus: _string(json, 'maritalStatus'),
    secureId: _string(json, 'secureId'),
    addresses: _list(json, 'addresses', Address.fromJson),
    phones: _list(json, 'phones', Phone.fromJson),
    emails: _list(json, 'emails', Email.fromJson),
  );
}

String _string(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String) {
    throw FormatException('Invalid or missing "$key" field.');
  }
  return value;
}

List<T> _list<T>(
  Map<String, dynamic> json,
  String key,
  T Function(Map<String, dynamic>) parse,
) {
  final value = json[key];
  if (value is! List) {
    throw FormatException('Invalid or missing "$key" list.');
  }
  return value
      .map((item) {
        if (item is! Map<String, dynamic>) {
          throw FormatException('Invalid item in "$key" list.');
        }
        return parse(item);
      })
      .toList(growable: false);
}

T? _primary<T>(List<T> values, bool Function(T) isPrimary) {
  for (final value in values) {
    if (isPrimary(value)) return value;
  }
  return values.isEmpty ? null : values.first;
}
