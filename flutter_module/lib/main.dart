import 'package:flutter/material.dart';
import 'package:flutter_module/people/people.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/people?id=108',
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final Uri uri = Uri.parse(settings.name ?? '');
    final path = uri.path;
    final queryParams = uri.queryParameters;

    switch (path) {
      case '/people':
        final id = int.tryParse(queryParams['id'] ?? '') ?? 0;
        return MaterialPageRoute(
            builder: (_) => PeoplePage(
                  id: id,
                ));
      default:
        return MaterialPageRoute(
            builder: (_) => const PeoplePage(
                  id: 108,
                ));
    }
  }
}
