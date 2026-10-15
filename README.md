# Care247 Customer Search

A Flutter mobile app for searching the supplied customer records, reviewing matches, and opening full customer details.

## Requirements

- Flutter stable 3.47.0 (Dart 3.13.0 used for this implementation)
- Node.js and JSON Server

## Setup and run

Start the mock API from the directory containing the supplied `db.json` (for example, `C:\Users\rahul\Downloads`):

```sh
npx --yes json-server@0.17.4 --watch db.json --port 3001
```

If the Android emulator or a physical device cannot reach the server, stop it with `Ctrl+C` and use this fallback command:

```sh
npx --yes json-server@0.17.4 --watch db.json --host 0.0.0.0 --port 3001
```

In another terminal, from this repository:

```sh
flutter pub get
flutter run
```

The app uses `http://10.0.2.2:3001/customers` on Android Emulator and `http://localhost:3001/customers` on iOS Simulator. Override the endpoint when needed:

```sh
flutter run --dart-define=CUSTOMER_API_URL=http://YOUR_MACHINE_IP:3001/customers
```

For a physical device, use the computer's LAN IP and make sure the device can reach port 3001. The supplied `db.json` stays outside this repository as requested by the assignment.

## Architecture

- `lib/models`: strongly typed customer, address, phone, email, and search-field models.
- `lib/config`: API endpoint selection and the ordered search field configuration.
- `lib/data`: HTTP access and repository filtering, separate from presentation.
- `lib/state`: a `ChangeNotifier` search controller with initial, loading, success, empty, and error states.
- `lib/screens` and `lib/widgets`: search, results, customer details, and reusable form/list components.

The app uses Flutter's built-in `ChangeNotifier` rather than adding a state-management package; it is sufficient for this focused flow and keeps dependencies small. Navigation uses standard Material routes. The results screen owns no request logic and listens to the controller; its list is built lazily and supports pull-to-refresh.

## Configuration-driven search

`searchFields` defines each field's key, type, label, placeholder/options, and render order. `DynamicSearchForm` sorts and renders fields generically for text, date picker, and select types, and submits a map keyed by the configured field names. To add a select field such as Marital Status, add a `SearchFieldConfig` with its options in `lib/config/search_fields.dart`; the renderer needs no screen-specific field code. The repository currently recognizes `firstName`, `lastName`, `dateOfBirth`, and `maritalStatus` criteria.

## Flutter decisions and trade-offs

- The date of birth input uses Flutter's date picker and submits an ISO date (`YYYY-MM-DD`).
- JSON Server data is fetched and filtered locally to provide case-insensitive partial name matching without depending on JSON Server-specific query behavior. For this small supplied dataset, this keeps search semantics predictable.
- API calls use `async`/`await`, timeouts, typed parsing, and user-readable failures. The results route opens before the request completes so loading is visible. The date picker checks `mounted` after awaiting before applying a result. The app disposes the search controller and HTTP client; the form disposes its text controllers.
- The API client uses `dart:io` `HttpClient` to avoid an extra runtime dependency. The endpoint is centralized and can be overridden at launch.
- Search criteria are intentionally limited to the supplied fields; there is no pagination or persistent local cache.

## Tests

Run the automated tests with:

```sh
flutter test
```

They cover nested JSON parsing and primary contact selection, malformed model data, repository filtering against a local mock HTTP server, and configuration-driven field ordering/submission.

## Time spent

Approximately 15 minutes for this implementation and verification pass.
