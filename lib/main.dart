import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram/provider/user_provider.dart';
import 'package:instagram/responsive/mobilescreenlayout.dart';
import 'package:instagram/responsive/responsive_layoutscreen.dart';
import 'package:instagram/responsive/webscreenlayout.dart';
import 'package:instagram/screens/loginscreen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        title: 'instagram',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        debugShowCheckedModeBanner: false,
        // home: ResponsiveLayoutscreen(
        //   webscreenlayout: Webscreenlayout(),
        //   mobilescreenlayout: Mobilescreenlayout(),
        // ),
        home: StreamBuilder(
          // Listen to the Firebase authentication state changes
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            print("StreamBuilder is running");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              return const ResponsiveLayoutscreen(
                webscreenlayout: Webscreenlayout(),
                mobilescreenlayout: Mobilescreenlayout(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else {
              return const Loginscreen();
            }
          },
        ),
      ),
    );
  }
}
