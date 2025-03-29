import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'TodoListScreen/todo_list_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyAIO4FL1l3ztjtHIHin4166bAu5C-N64EE",
    appId: "1:255128220515:android:ce17ba86024699dc10d956",
    messagingSenderId: "255128220515",
    projectId: "todotask-6eaa5",
    storageBucket: "YOUR_STORAGE_BUCKET",
    authDomain: "YOUR_AUTH_DOMAIN",
    databaseURL:
        "https://todotask-6eaa5-default-rtdb.firebaseio.com/", // Optional if using Realtime Database
    measurementId: "YOUR_MEASUREMENT_ID", // Optional if using Google Analytics
  );
  try {
    await Firebase.initializeApp(options: firebaseOptions,name: "Todo Task");
    runApp(const MyApp());
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Firebase GetX Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthScreen(),
      // home: Splash(),
       debugShowCheckedModeBanner: false,
      // home: TodoListScreen(),
    );
  }
}
