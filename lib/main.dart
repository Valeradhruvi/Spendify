import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spendify/dashboard/bottom_button/bottom_nav_bar.dart';
import 'package:spendify/dashboard/screen/edit_profile_screen.dart';
import 'package:spendify/dashboard/screen/home_screen.dart';
import 'package:spendify/firebase_options.dart';
import 'package:spendify/user/auth/forgot_pass_screen.dart';
import 'package:spendify/user/auth/login_screen.dart';
import 'package:spendify/user/auth/onboarding_screen.dart';
import 'package:spendify/user/auth/register_screen.dart';
import 'package:spendify/user/auth/splash_screen.dart';

import 'admin/admin_dashboard.dart';
// import 'screens/home_screen.dart'; // if you've built this

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FinanceOptimizerApp());
}

class FinanceOptimizerApp extends StatelessWidget {
  const FinanceOptimizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ML Finance Optimizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(), // Use your custom theme here
      home: LoginScreen(),
      routes: {
        '/splash': (context) =>  SplashScreen(),
        '/onboarding': (context) =>  OnboardingScreen(),
        '/login': (context) =>  LoginScreen(),
        '/forgot': (context) =>  ForgotPasswordScreen(),
        '/register': (context) =>  RegisterScreen(),
        '/bottomnavbar':(context)=>BottomNavBar(),
        '/admindashboard':(context)=>AdminDashboardScreen()

        // Later
      },
    );
  }
}