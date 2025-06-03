import 'package:flutter/material.dart';
import 'core/routes/app_router.dart';

void main() {
  runApp(const FixTrackApp());
}

class FixTrackApp extends StatelessWidget {
  const FixTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixTrack-Ticket',
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/login',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
