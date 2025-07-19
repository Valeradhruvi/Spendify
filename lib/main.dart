import 'package:flutter/material.dart';
import 'package:spendify/analysis/expense_prediction_screen.dart';
import 'package:spendify/analysis/sending_insight_screen.dart' hide AnalyticsChartsScreen;
import 'package:spendify/bank_sync/banksync_screen.dart';
import 'package:spendify/dashboard/bottom_button/bottom_nav_bar.dart';
import 'package:spendify/dashboard/screen/analysis_screen.dart';
import 'package:spendify/dashboard/screen/edit_profile_screen.dart';
import 'package:spendify/dashboard/screen/goal_screen.dart';
import 'package:spendify/dashboard/screen/profileScreens/about_us_screen.dart';
import 'package:spendify/dashboard/screen/profileScreens/feedback_screen.dart';
import 'package:spendify/dashboard/screen/profileScreens/help_center.dart';
import 'package:spendify/dashboard/screen/profile_page.dart';
import 'package:spendify/notification/notification_screen.dart';
import 'package:spendify/transaction/add_transaction.dart';
import 'package:spendify/user/auth/forgot_pass_screen.dart';
import 'package:spendify/user/auth/login_screen.dart';
import 'package:spendify/user/auth/onboarding_screen.dart';
import 'package:spendify/user/auth/regitser_screen.dart';
import 'package:spendify/user/auth/splash_screen.dart';



// import 'screens/home_screen.dart'; // if you've built this

void main() {
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
      initialRoute: '/bottomnav',
      routes: {
        '/splash': (context) =>  SplashScreen(),
        '/onboarding': (context) =>  OnboardingScreen(),
        '/login': (context) =>  LoginScreen(),
        '/forgot': (context) =>  ForgotPasswordScreen(),
        '/register': (context) =>  RegisterScreen(),
        '/bottomnav':(context)=>BottomNavBar(),
        '/homepage':(context)=>GoalsScreen(),
        '/goalpage':(context)=>BottomNavBar(),
        '/add':(context)=>AddTransactionScreen(),
        '/profilepage':(context)=>ProfilePage(),
        '/notificationscreen':(context)=>NotificationScreen(),
        '/editprofile':(context)=>EditProfilePage(username: 'darvi',email: 'dh@gail.com'),
        '/banksyncscreen':(context)=>BankSyncScreen(),
        '/sendinginsightscreen':(context)=>AnalyticsChartsScreen(),
        '/aboutscreen':(context)=>AboutAppScreen(),
        '/helpcenterscreen':(context)=>HelpCenterScreen(),
        '/feedbackscreen':(context)=>FeedbackScreen(),

        // '/home': (context) => const HomeScreen(), // Later
      },
    );
  }
}