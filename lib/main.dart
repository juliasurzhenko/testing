import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test/controllers/auth_service.dart';
import 'package:test/home_page.dart';
import 'package:test/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBWc30E3YaNQwmLmKUTsduGB7TsqNdM4-w",
          authDomain: "test-dc92c.firebaseapp.com",
          projectId: "test-dc92c",
          storageBucket: "test-dc92c.appspot.com",
          messagingSenderId: "1092865868839",
          appId: "1:1092865868839:web:7a10f81bdae35a39ec7a02"),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: StreamBuilder(
          stream: AuthService().authChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              return const HomePage();
            }
            return const LoginPage();
          },
        )

        // const LoginPage()
        );
  }
}
