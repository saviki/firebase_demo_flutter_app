import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/home.dart';
import 'package:firebase_demo/shared_preference_service.dart';
import 'package:firebase_demo/show_error_message.dart';
import 'package:firebase_demo/signup_screen.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Login'),
      ),
      body: Stack(
        children: [
          Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 200,
                    height: 200,
                    child: Center(
                      child: Icon(Icons.home_repair_service, color: Colors.blue,),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: _emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Email'
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: _passwordEditingController,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      onChanged: (changedText){},
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Password'
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: signIn,
                      child: const Text('Sign In', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: signUp,
                      child: const Text('Sign Up', style: TextStyle(color: Colors.white),),
                    ),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: _isLoading,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.1),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  signIn(){
    setState(() {
      _isLoading = true;
    });

    if(_emailEditingController.text.isNotEmpty && _passwordEditingController.text.isNotEmpty){
      AuthService().loginUser(_emailEditingController.text, _passwordEditingController.text);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const HomeScreen()),
          (route) => false
      );
      // SharedPreferenceService.saveBoolToSharedPreference('user_logged_in', true);
    }
    else{
      ShowErrorMsg.showErrorMessage(context, 'Enter a valid email & password');
    }
    setState(() {
      _isLoading = false;
    });
  }

  signUp(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }
}
