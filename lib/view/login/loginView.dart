
import 'package:blog_app/utlis/input_field/textField.dart';
import 'package:blog_app/utlis/session/session_manager.dart';
import 'package:blog_app/utlis/simple_button/roundButton.dart';
import 'package:blog_app/view/HomePage/HomeScreen.dart';
import 'package:blog_app/view/login/loginModel.dart';
import 'package:blog_app/view/signUp/signUpView.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utlis/toastMsg/toastMessage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Consumer<LoginModel>(
        builder: (context, loginUser, child) => SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  child: Image(
                    height: 350,
                    width: double.infinity,
                    image: AssetImage('images/login.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'WelCome!',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                      const Text(
                        'Login to your account',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 158, 220, 215)),
                      ),
                      const SizedBox(height: 10),
                      InputField(
                        controller: emailController,
                        onValidator: (value) => EmailValidator.validate(value)
                            ? null
                            : 'Enter a valid mail',
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                      ),
                      InputField(
                        controller: passwordController,
                        obscureText: true,
                        keyBoardType: TextInputType.visiblePassword,
                        onValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: InkWell(
                          onTap: loginUser.setToggle,
                          child: Icon(
                            loginUser.toggle
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                color: Colors.teal),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CommonButton(
                        color: const Color.fromARGB(255, 84, 190, 181),
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            loginUser.login(
                              emailController.text.toString(),
                              passwordController.text.toString(),
                              context,
                            );
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.reset();
                            }
                          }
                        },
                        title: 'Login',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Divider(
                            indent: 10,
                            endIndent: 10,
                            thickness: 2,
                          )),
                          Text(
                            'Or login with',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(164, 0, 0, 0),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 2,
                              indent: 10,
                              endIndent: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButtons(
                            onPress: () {
                              loginUser.googleLogin().then((value) {
                                if (context.mounted) {
                                  Utils.toastMessage(
                                      'Login successfully',
                                      Colors.blue,
                                      const Icon(Icons.check),
                                      context);
                                }
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomePage()));
                                SessionController().userId =
                                    value.user!.uid.toString();
                              }).onError((error, stackTrace) {
                                if (context.mounted) {
                                  Utils.toastMessage(
                                      error.toString(),
                                      Colors.red,
                                      const Icon(Icons.error),
                                      context);
                                }
                              });
                            },
                            image: const AssetImage('images/google.png'),
                          ),
                          IconButtons(
                            onPress: () {},
                            image: const AssetImage('images/facebook.png'),
                          ),
                          IconButtons(
                            onPress: () {},
                            image: const AssetImage('images/apple.png'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an Account?",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 55, 59, 61)),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen()));
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 17,
                                letterSpacing: 1,
                                color: Colors.teal,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class IconButtons extends StatelessWidget {
  const IconButtons({
    super.key,
    required this.onPress,
    required this.image,
  });

  final VoidCallback onPress;
  final AssetImage image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 95,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPress,
        child: Image(
          image: image,
          height: 35,
          width: 35,
        ),
      ),
    );
  }
}
