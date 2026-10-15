import 'package:flutter/material.dart';

import 'config/api_config.dart';
import 'data/customer_api.dart';
import 'data/customer_repository.dart';
import 'screens/customer_search_screen.dart';
import 'state/customer_search_controller.dart';

void main() {
  runApp(const Care247App());
}

class Care247App extends StatefulWidget {
  const Care247App({super.key});

  @override
  State<Care247App> createState() => _Care247AppState();
}

class _Care247AppState extends State<Care247App> {
  late final CustomerApi _api;
  late final CustomerSearchController _controller;

  @override
  void initState() {
    super.initState();
    _api = CustomerApi(ApiConfig.baseUrl);
    _controller = CustomerSearchController(CustomerRepository(_api));
  }

  @override
  void dispose() {
    _controller.dispose();
    _api.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Care247 Customer Search',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF176B87)),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: CustomerSearchScreen(controller: _controller),
    );
  }
}
