import 'package:flutter/material.dart';
import 'package:statement/404.dart';
import 'package:statement/post_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: StateMApp()));
}

class StateMApp extends StatelessWidget {
  const StateMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => PostsScreen());
          default:
            return MaterialPageRoute(builder: (context) => NotFound());
        }
      },
    );
  }
}
