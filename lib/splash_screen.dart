import 'package:firebase_demo/home.dart';
import 'package:firebase_demo/login_screen.dart';
import 'package:firebase_demo/shared_preference_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigateToMainScreen(context);
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Icon(
          Icons.account_balance,
          color: Colors.blue,
          size: 150,
        ),
      ),
    );
  }
  
  navigateToMainScreen(BuildContext context) async{

    // bool isUserLoggedIn = SharedPreferenceService.getBoolToSharedPreference('user_logged_in');

    Future.delayed(
        const Duration(seconds: 2),
        (){
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false);
        }
    );
  }
}
