import 'package:blog_app/utlis/input_field/textField.dart';
import 'package:blog_app/utlis/simple_button/roundButton.dart';
import 'package:blog_app/view/login/loginView.dart';
import 'package:blog_app/view/signUp/signUpModel.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    passwordController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<SignUpModel>(
          builder: (context, register, child) => SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Image(
                    height: 350,
                    image: AssetImage('images/su.png'),
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Register Now!',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                        ),
                        const Text(
                          'SignUp to your account',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 158, 220, 215)),
                        ),
                        const SizedBox(height: 10),
                        InputField(
                          controller: nameController,
                          onValidator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid Name';
                            }
                            return null;
                          },
                          hintText: 'UserName',
                          prefixIcon: const Icon(Icons.person),
                        ),
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
                          obscureText: register.toggle,
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
                            onTap: register.setToggle,
                            child: Icon(
                              register.toggle
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CommonButton(
                          loading: register.loading,
                          color: const Color.fromARGB(255, 84, 190, 181),
                          onPress: () {
                            if (_formKey.currentState!.validate()) {
                              register.signUp(
                                nameController.text.toString(),
                                emailController.text.toString(),
                                passwordController.text.toString(),
                                context,
                              );
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.reset();
                              
                              }
                            }
                          },
                          title: 'Sign Up',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an Account?",
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
                                            const LoginScreen()));
                              },
                              child: const Text(
                                'Login',
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
        ),
      ),
    );
  }
}
