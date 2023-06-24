import 'package:flutter/material.dart';
import 'package:native_notify/native_notify.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'home_page.dart';
import 'login.dart';
import 'EditProfilePage.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  NativeNotify.initialize(3124, 'bkrvpzyobJBPbiDkW60jbd', null, null);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<UserProvider>(
      create: (context) => UserProvider(), // Create an instance of UserProvider
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Your App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(),
      ),
    );
  }
}
