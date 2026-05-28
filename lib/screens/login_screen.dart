import 'package:flutter/material.dart';
import 'package:final_project_pmd/screens/dashboard_screen.dart';
import 'package:final_project_pmd/screens/sign_up_screen.dart';
import 'package:final_project_pmd/screens/quiz_list_screen.dart';
import 'package:final_project_pmd/const/constant.dart';
import 'package:final_project_pmd/services/user_service.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

/////////////////////////////////////////////////////////////

class _LoginScreenState
    extends State<LoginScreen> {

  // ====================
  // FORM KEY
  // ====================

  final _formKey =
  GlobalKey<FormState>();

  // ====================
  // TEXT CONTROLLERS
  // ====================

  final _emailController =
  TextEditingController();

  final _passwordController =
  TextEditingController();

  // ====================
  // PASSWORD VISIBILITY
  // ====================

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  /////////////////////////////////////////////////////////////

  @override
  void dispose() {

    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  /////////////////////////////////////////////////////////////

  InputDecoration buildInputDecoration(

      String label,
      IconData icon,

      {Widget? suffix}

      ) {

    return InputDecoration(

      labelText: label,

      prefixIcon: Icon(icon),

      suffixIcon: suffix,

      filled: true,

      fillColor: Colors.white,

      contentPadding:
      const EdgeInsets.symmetric(
        vertical: 18,
      ),

      enabledBorder: OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(14),

        borderSide: BorderSide(
          color:
          AppColors.primary
              .withOpacity(0.4),
        ),
      ),

      focusedBorder: OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(14),

        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),

      border: OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(14),
      ),
    );
  }

  /////////////////////////////////////////////////////////////

  Future<void> login() async {

    if (_isLoading) return;

    if (_formKey.currentState!
        .validate()) {

      setState(() {

        _isLoading = true;
      });

      final userService =
      UserService();

      final user =
      await userService.loginUser(

        _emailController.text.trim(),

        _passwordController.text.trim(),
      );

      ///////////////////////////////////////////////////////////

      if (user.isNotEmpty) {

        setState(() {

          _isLoading = false;
        });

        if (!mounted) return;

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (context) =>
                DashboardScreen(
                  user: user.first,
                ),
          ),
        );
      }

      ///////////////////////////////////////////////////////////

      else {

        showDialog(

          context: context,

          builder: (context) {

            return AlertDialog(

              title:
              const Text("Login Failed"),

              content: const Text(
                "Invalid email or password",
              ),

              actions: [

                TextButton(

                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: const Text("OK"),
                ),
              ],
            );
          },
        );

        setState(() {

          _isLoading = false;
        });
      }
    }
  }

  /////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final screenHeight =
        MediaQuery.sizeOf(context).height;

    final isSmall =
        screenWidth < 600;

    return Scaffold(

      backgroundColor:
      AppColors.background,

      /////////////////////////////////////////////////////////

      body: SafeArea(

        child: Center(

          child: isSmall

          /////////////////////////////////////////////////////
          // MOBILE LAYOUT
          /////////////////////////////////////////////////////

              ? SingleChildScrollView(

            padding: EdgeInsets.all(
              screenWidth * 0.06,
            ),

            child: Column(

              mainAxisSize:
              MainAxisSize.min,

              children: [

                const _Logo(),

                SizedBox(
                  height:
                  screenHeight * 0.03,
                ),

                buildForm(
                  screenWidth,
                  screenHeight,
                ),
              ],
            ),
          )

          /////////////////////////////////////////////////////
          // TABLET / DESKTOP LAYOUT
          /////////////////////////////////////////////////////

              : SizedBox(

            height: screenHeight,

            child: Center(

                child: Column(

                  mainAxisSize:
                  MainAxisSize.min,

                  children: [

                    const _Logo(),

                    const SizedBox(height: 30),

                    buildForm(
                      screenWidth,
                      screenHeight,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }

  /////////////////////////////////////////////////////////////

  Widget buildForm(
      double screenWidth,
      double screenHeight,
      ) {

    return Container(

      constraints:
      const BoxConstraints(
        maxWidth: 360,
      ),

      padding:
      const EdgeInsets.all(24),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(20),

        boxShadow:
        AppShadow.cardShadow,
      ),

      child: Form(

        key: _formKey,

        child: Column(

          children: [

            ///////////////////////////////////////////////////

            // EMAIL FIELD

            TextFormField(

              controller:
              _emailController,

              validator: (value) {

                if (value == null ||
                    value.isEmpty) {

                  return "Required";
                }

                if (!value.contains("@")) {

                  return "Invalid email";
                }

                return null;
              },

              decoration:
              buildInputDecoration(
                "Email",
                Icons.email,
              ),
            ),

            SizedBox(
              height:
              screenHeight * 0.02,
            ),

            ///////////////////////////////////////////////////

            // PASSWORD FIELD

            TextFormField(

              controller:
              _passwordController,

              obscureText:
              !_isPasswordVisible,

              validator: (value) {

                if (value == null ||
                    value.isEmpty) {

                  return "Required";
                }

                if (value.length < 6) {

                  return "Min 6 characters";
                }

                return null;
              },

              decoration:
              buildInputDecoration(

                "Password",

                Icons.lock,

                suffix: IconButton(

                  icon: Icon(

                    _isPasswordVisible

                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),

                  onPressed: () {

                    setState(() {

                      _isPasswordVisible =
                      !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),

            SizedBox(
              height:
              screenHeight * 0.03,
            ),

            ///////////////////////////////////////////////////

            // LOGIN BUTTON

            SizedBox(

              width: double.infinity,

              height:
              screenHeight * 0.065,

              child: ElevatedButton(

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  AppColors.primary,

                  foregroundColor:
                  Colors.white,

                  elevation: 4,

                  shape:
                  RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(30),
                  ),
                ),

                onPressed: login,

                child: Text(

                  "Log In",

                  style: TextStyle(

                    fontSize:
                    screenWidth < 400
                        ? 14
                        : 16,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(
              height:
              screenHeight * 0.02,
            ),

            ///////////////////////////////////////////////////

            // SIGN UP LINK

            Row(

              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [

                const Text(
                  "Don't have an account? ",
                ),

                GestureDetector(

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (context) =>
                        const SignUpScreen(),
                      ),
                    );
                  },

                  child: const Text(

                    "Sign Up",

                    style: TextStyle(

                      color: AppColors.primary,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            TextButton(

              onPressed: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (context) =>
                    const QuizListScreen(),
                  ),
                );
              },

              child: const Text(

                "Continue as Guest",

                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////

class _Logo extends StatelessWidget {

  const _Logo();

  @override
  Widget build(BuildContext context) {

    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final isSmall =
        screenWidth < 600;

    return Column(

      mainAxisSize:
      MainAxisSize.min,

      children: [

        ///////////////////////////////////////////////////////

        Image.asset(

          'assets/images/logo.png',

          width:
          isSmall ? 220 : 260,

          fit: BoxFit.contain,
        ),

        const SizedBox(height: 5),

        ///////////////////////////////////////////////////////

        Text(

          "Welcome Back",

          style: TextStyle(

            fontSize:
            isSmall ? 20 : 26,

            fontWeight:
            FontWeight.bold,

            color:
            AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 8),

        ///////////////////////////////////////////////////////

        Text(

          "Login to continue your SDG journey",

          textAlign: TextAlign.center,

          style: TextStyle(

            fontSize:
            isSmall ? 14 : 16,

            color:
            AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}