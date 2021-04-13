import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'enums/connectivity_status.dart';
import 'service_locator.dart';
import 'services/connectivity_service.dart';
import 'ui/views/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Register all the models and services before the app starts
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<ConnectivityStatus>(
      initialData: ConnectivityStatus.Offline,
      create: (context) =>
          ConnectivityService().connnectionStatusController.stream,
      child: MaterialApp(
          title: 'Skeleton Watcher',
          theme: ThemeData(
              primaryColor: Color.fromARGB(255, 9, 202, 172),
              backgroundColor: Color.fromARGB(255, 26, 27, 30),
              textTheme: Theme.of(context).textTheme.apply(
                  fontFamily: 'Open Sans',
                  bodyColor: Colors.white,
                  displayColor: Colors.white)),
          home: HomeView()),
    );
  }
}
