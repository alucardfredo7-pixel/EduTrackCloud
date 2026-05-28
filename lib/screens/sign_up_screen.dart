import 'package:flutter/material.dart';
import 'package:final_project_pmd/screens/login_screen.dart';
import 'package:final_project_pmd/const/constant.dart';
import 'package:final_project_pmd/services/user_service.dart';

class SignUpScreen extends StatefulWidget {

  const SignUpScreen({
    super.key,
  });

  @override
  State<SignUpScreen> createState() =>
      _SignUpScreenState();
}

/////////////////////////////////////////////////////////////

class _SignUpScreenState
    extends State<SignUpScreen> {

  // FORM KEY

  final _formKey =
  GlobalKey<FormState>();

  ///////////////////////////////////////////////////////////

  // TEXT CONTROLLERS

  final _nameController =
  TextEditingController();

  final _emailController =
  TextEditingController();

  final _passwordController =
  TextEditingController();

  final _confirmController =
  TextEditingController();

  ///////////////////////////////////////////////////////////

  // PASSWORD VISIBILITY

  bool _obscurePassword = true;

  ///////////////////////////////////////////////////////////

  @override
  void dispose() {

    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();

    super.dispose();
  }

  ///////////////////////////////////////////////////////////

  // REGISTER FUNCTION

  void _register() async {

    if (_formKey.currentState!
        .validate()) {

      final userService =
      UserService();

      ///////////////////////////////////////////////////////

// CHECK EMAIL EXIST

      final emailExists =
      await userService.checkEmailExists(
        _emailController.text,
      );

      if (emailExists) {

        showDialog(

          context: context,

          builder: (context) {

            return AlertDialog(

              title: const Text(
                "Registration Failed",
              ),

              content: const Text(
                "Email already exists",
              ),

              actions: [

                TextButton(

                  onPressed: () {

                    Navigator.pop(context);
                  },

                  child: const Text(
                    "OK",
                  ),
                ),
              ],
            );
          },
        );

        return;
      }

      ///////////////////////////////////////////////////////

      // INSERT USER

      await userService.insertUser({

        'name':
        _nameController.text,

        'email':
        _emailController.text,

        'password':
        _passwordController.text,
      });

      ///////////////////////////////////////////////////////

      // SUCCESS DIALOG

      showDialog(

        context: context,

        builder: (_) => AlertDialog(

          title: const Text(
            "Success",
          ),

          content: const Text(
            "Account created successfully",
          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(context);

                Navigator.pushReplacement(

                  context,

                  MaterialPageRoute(

                    builder: (context) =>
                    const LoginScreen(),
                  ),
                );
              },

              child: const Text(
                "OK",
              ),
            ),
          ],
        ),
      );
    }
  }

  ///////////////////////////////////////////////////////////

  // REUSABLE INPUT STYLE

  InputDecoration _inputDecoration(
      String label,
      {
        Widget? suffixIcon,
      }
      ) {

    return InputDecoration(

      labelText: label,

      filled: true,

      fillColor: Colors.white,

      ///////////////////////////////////////////////////////

      enabledBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(12),

        borderSide: BorderSide(

          color:
          AppColors.primary
              .withOpacity(0.4),
        ),
      ),

      ///////////////////////////////////////////////////////

      focusedBorder:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(12),

        borderSide: BorderSide(

          color:
          AppColors.primary,

          width: 2,
        ),
      ),

      ///////////////////////////////////////////////////////

      border:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(12),
      ),

      suffixIcon: suffixIcon,
    );
  }

  ///////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    // RESPONSIVE SIZE

    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final screenHeight =
        MediaQuery.sizeOf(context).height;

    final isSmall =
        screenWidth < 400;

    return Scaffold(

      backgroundColor:
      AppColors.background,

      /////////////////////////////////////////////////////////

      // APP BAR

      appBar: AppBar(

        title: const Text(
          "Create Account",
        ),

        backgroundColor:
        AppColors.primary,

        foregroundColor:
        Colors.white,
      ),

      /////////////////////////////////////////////////////////

      // BODY

      body: SafeArea(

        child: Form(

          key: _formKey,

          child: ListView(

            padding: EdgeInsets.all(
              screenWidth * 0.06,
            ),

            children: [

              ///////////////////////////////////////////////////

              // FULL NAME

              TextFormField(

                controller:
                _nameController,

                decoration:
                _inputDecoration(
                  "Full Name",
                ),

                validator: (v) =>

                v == null || v.isEmpty
                    ? 'Required'
                    : null,
              ),

              SizedBox(
                height:
                screenHeight * 0.025,
              ),

              ///////////////////////////////////////////////////

              // EMAIL

              TextFormField(

                controller:
                _emailController,

                decoration:
                _inputDecoration(
                  "Email",
                ),

                keyboardType:
                TextInputType.emailAddress,

                validator: (v) {

                  if (v == null ||
                      v.isEmpty) {

                    return 'Required';
                  }

                  if (!v.contains("@")) {

                    return 'Invalid email';
                  }

                  return null;
                },
              ),

              SizedBox(
                height:
                screenHeight * 0.025,
              ),

              ///////////////////////////////////////////////////

              // PASSWORD

              TextFormField(

                controller:
                _passwordController,

                obscureText:
                _obscurePassword,

                decoration:
                _inputDecoration(

                  "Password",

                  suffixIcon:
                  IconButton(

                    icon: Icon(

                      _obscurePassword

                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),

                    onPressed: () {

                      setState(() {

                        _obscurePassword =
                        !_obscurePassword;
                      });
                    },
                  ),
                ),

                validator: (v) {

                  if (v == null ||
                      v.isEmpty) {

                    return 'Required';
                  }

                  if (v.length < 8) {

                    return 'Min 8 characters';
                  }

                  return null;
                },
              ),

              SizedBox(
                height:
                screenHeight * 0.025,
              ),

              ///////////////////////////////////////////////////

              // CONFIRM PASSWORD

              TextFormField(

                controller:
                _confirmController,

                obscureText: true,

                decoration:
                _inputDecoration(
                  "Confirm Password",
                ),

                validator: (v) {

                  if (v == null ||
                      v.isEmpty) {

                    return 'Required';
                  }

                  if (v !=
                      _passwordController
                          .text) {

                    return
                      'Passwords do not match';
                  }

                  return null;
                },
              ),

              SizedBox(
                height:
                screenHeight * 0.04,
              ),

              ///////////////////////////////////////////////////

              // CREATE ACCOUNT BUTTON

              SizedBox(

                width: double.infinity,

                height:
                isSmall
                    ? 50
                    : 55,

                child: ElevatedButton(

                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    AppColors.primary,

                    foregroundColor:
                    Colors.white,

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(30),
                    ),

                    elevation: 3,
                  ),

                  onPressed:
                  _register,

                  child: Text(

                    "Create Account",

                    style: TextStyle(

                      fontSize:
                      isSmall
                          ? 15
                          : 16,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(
                height:
                screenHeight * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}