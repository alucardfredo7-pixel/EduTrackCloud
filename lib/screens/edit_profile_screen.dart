import 'package:flutter/material.dart';
import 'package:final_project_pmd/const/constant.dart';
import 'package:final_project_pmd/screens/login_screen.dart';
import 'package:final_project_pmd/services/user_service.dart';

class EditProfileScreen extends StatefulWidget {

  final Map<String, dynamic> user;

  const EditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

/////////////////////////////////////////////////////////////

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  // ====================
  // FORM KEY
  // ====================

  final _formKey =
  GlobalKey<FormState>();

  // ====================
  // TEXT CONTROLLERS
  // ====================

  final _nameController =
  TextEditingController();

  final _emailController =
  TextEditingController();

  final _passwordController =
  TextEditingController();

  // ====================
  // PASSWORD VISIBILITY
  // ====================

  bool _obscurePassword = true;

  /////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    // Load current user data
    _nameController.text =
    widget.user['name'];

    _emailController.text =
    widget.user['email'];

    _passwordController.text =
    widget.user['password'];
  }

  /////////////////////////////////////////////////////////////

  @override
  void dispose() {

    _nameController.dispose();
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

      hintText: label,

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
              .withOpacity(0.3),
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

  Future<void> saveProfile() async {

    if (_formKey.currentState!
        .validate()) {

      final userService =
      UserService();

      await userService.updateUser(

        widget.user['id'],

        _nameController.text.trim(),

        _emailController.text.trim(),

        _passwordController.text.trim(),
      );

      if (!mounted) return;

      showDialog(

        context: context,

        builder: (context) {

          return AlertDialog(

            title: const Text("Success"),

            content: const Text(
              "Profile updated successfully.\nPlease login again.",
            ),

            actions: [

              TextButton(

                onPressed: () {

                  Navigator.pushAndRemoveUntil(

                    context,

                    MaterialPageRoute(
                      builder: (context) =>
                      const LoginScreen(),
                    ),

                        (route) => false,
                  );
                },

                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  /////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final screenHeight =
        MediaQuery.sizeOf(context).height;

    return Scaffold(

      backgroundColor:
      AppColors.background,

      /////////////////////////////////////////////////////////

      appBar: AppBar(

        title: const Text("Edit Profile"),

        backgroundColor:
        AppColors.primary,

        foregroundColor:
        Colors.white,
      ),

      /////////////////////////////////////////////////////////

      body: SafeArea(

        child: Form(

          key: _formKey,

          child: ListView(

            padding: EdgeInsets.all(
              screenWidth * 0.06,
            ),

            children: [

              ///////////////////////////////////////////////////

              // PROFILE AVATAR

              Center(

                child: Container(

                  padding:
                  const EdgeInsets.all(4),

                  decoration: BoxDecoration(

                    shape: BoxShape.circle,

                    border: Border.all(

                      color: AppColors.primary,
                      width: 3,
                    ),
                  ),

                  child: CircleAvatar(

                    radius:
                    screenWidth < 400
                        ? 50
                        : 60,

                    backgroundColor:
                    AppColors.primary,

                    child: Icon(

                      Icons.person,

                      size:
                      screenWidth < 400
                          ? 50
                          : 60,

                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: screenHeight * 0.04,
              ),

              ///////////////////////////////////////////////////

              // NAME FIELD

              TextFormField(

                controller:
                _nameController,

                decoration:
                buildInputDecoration(
                  "Full Name",
                  Icons.person,
                ),

                validator: (value) {

                  if (value != null &&
                      value.isNotEmpty &&
                      value.length < 2) {

                    return "Name is too short";
                  }

                  return null;
                },
              ),

              SizedBox(
                height: screenHeight * 0.025,
              ),

              ///////////////////////////////////////////////////

              // EMAIL FIELD

              TextFormField(

                controller:
                _emailController,

                decoration:
                buildInputDecoration(
                  "Email",
                  Icons.email,
                ),

                validator: (value) {

                  if (value != null &&
                      value.isNotEmpty &&
                      !value.contains("@")) {

                    return "Invalid email";
                  }

                  return null;
                },
              ),

              SizedBox(
                height: screenHeight * 0.025,
              ),

              ///////////////////////////////////////////////////

              // PASSWORD FIELD

              TextFormField(

                controller:
                _passwordController,

                obscureText:
                _obscurePassword,

                decoration:
                buildInputDecoration(

                  "New Password",

                  Icons.lock,

                  suffix: IconButton(

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
              ),

              SizedBox(
                height: screenHeight * 0.05,
              ),

              ///////////////////////////////////////////////////

              // SAVE BUTTON

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

                  onPressed: saveProfile,

                  child: Text(

                    "Save Changes",

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
            ],
          ),
        ),
      ),
    );
  }
}