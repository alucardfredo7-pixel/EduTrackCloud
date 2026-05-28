import 'package:flutter/material.dart';
import 'package:final_project_pmd/const/constant.dart';
import 'package:final_project_pmd/screens/login_screen.dart';
import 'package:final_project_pmd/screens/edit_profile_screen.dart';
import 'package:final_project_pmd/services/user_service.dart';
import 'package:final_project_pmd/services/quiz_service.dart';

class ProfileScreen extends StatefulWidget {

  final Map<String, dynamic> user;

  const ProfileScreen({
    super.key,
    required this.user,
  });


  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

/////////////////////////////////////////////////////////////

class _ProfileScreenState
    extends State<ProfileScreen> {

  // USER QUIZ RESULTS

  List<Map<String,dynamic>> results = [];

  ///////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    loadResults();
  }

  ///////////////////////////////////////////////////////////

  // LOAD QUIZ RESULTS

  Future<void> loadResults() async {

    final quizService = QuizService();

    results = await quizService.getUserResults(
      widget.user['id'],
    );

    setState(() {});
  }

  ///////////////////////////////////////////////////////////

  // DELETE ACCOUNT CONFIRMATION

  Future<void> confirmDeleteAccount(
      BuildContext context,
      ) async {

    showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          title: const Text(
            "Delete Account",
          ),

          content: const Text(
            "Are you sure you want to delete your account?",
          ),

          actions: [

            ///////////////////////////////////////////////////

            // CANCEL BUTTON

            TextButton(

              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancel"),
            ),

            ///////////////////////////////////////////////////

            // DELETE BUTTON

            TextButton(

              onPressed: () async {

                final navigator =
                Navigator.of(context);

                navigator.pop();

                final quizService =
                QuizService();

                final userService =
                UserService();

                ///////////////////////////////////////////////////

                // DELETE QUIZ RESULTS

                await quizService.deleteUserResults(
                  widget.user['id'],
                );

                ///////////////////////////////////////////////////

                // DELETE USER

                await userService.deleteUser(
                  widget.user['id'],
                );

                ///////////////////////////////////////////////////

                // GO LOGIN SCREEN

                navigator.pushAndRemoveUntil(

                  MaterialPageRoute(
                    builder: (context) =>
                    const LoginScreen(),
                  ),

                      (route) => false,
                );
              },

              child: const Text(

                "Delete",

                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
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

      // BODY

      body: Column(

        children: [

          /////////////////////////////////////////////////////

          // TOP HEADER

          const Expanded(
            flex: 2,
            child: _TopPortion(),
          ),

          /////////////////////////////////////////////////////

          // PROFILE CONTENT

          Expanded(

            flex: 3,

            child: SingleChildScrollView(



              child: Padding(

                padding: EdgeInsets.all(
                  screenWidth * 0.05,
                ),

                child: Column(

                  children: [

                    ///////////////////////////////////////////////////

                    // USER NAME

                    Text(

                      widget.user['name'],

                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(

                        fontWeight:
                        FontWeight.bold,

                        fontSize:
                        isSmall
                            ? 24
                            : 28,
                      ),
                    ),

                    SizedBox(
                      height:
                      screenHeight * 0.005,
                    ),

                    ///////////////////////////////////////////////////

                    // USER EMAIL

                    Text(

                      widget.user['email'],

                      style: TextStyle(

                        color: Colors.grey[600],

                        fontSize:
                        isSmall
                            ? 13
                            : 15,
                      ),
                    ),

                    SizedBox(
                      height:
                      screenHeight * 0.015,
                    ),

                    ///////////////////////////////////////////////////

                    // AVERAGE SCORE

                    _ProfileInfoRow(
                      results: results,
                    ),

                    SizedBox(
                      height:
                      screenHeight * 0.015,
                    ),

                    ///////////////////////////////////////////////////

                    // CATEGORY PERFORMANCE

                    Align(

                      alignment:
                      Alignment.centerLeft,

                      child: Text(

                        "Category Performance",

                        style: TextStyle(

                          fontWeight:
                          FontWeight.bold,

                          fontSize:
                          isSmall
                              ? 15
                              : 16,

                          color:
                          AppColors.textPrimary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    ///////////////////////////////////////////////////

                    // CATEGORY LIST

                    ...results.map((result) {

                      int percentage = (

                          (result['score'] /
                              result['totalQuestion']) * 100

                      ).toInt();

                      return _buildCategory(

                        result['category'],

                        percentage,
                      );
                    }),

                    SizedBox(
                      height:
                      screenHeight * 0.03,
                    ),

                    ///////////////////////////////////////////////////

                    // EDIT PROFILE BUTTON

                    SizedBox(

                      width: double.infinity,

                      child: ElevatedButton(

                        style:
                        ElevatedButton.styleFrom(

                          backgroundColor:
                          AppColors.primary,

                          foregroundColor:
                          Colors.white,

                          padding:
                          const EdgeInsets.symmetric(
                            vertical: 12,
                          ),

                          shape:
                          RoundedRectangleBorder(

                            borderRadius:
                            BorderRadius.circular(30),
                          ),

                          elevation: 4,
                        ),

                        onPressed: () {

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (context) =>
                                  EditProfileScreen(
                                    user: widget.user,
                                  ),
                            ),
                          );
                        },

                        child: Text(

                          "Edit Profile",

                          style: TextStyle(

                            fontSize:
                            isSmall
                                ? 14
                                : 16,

                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height:
                      screenHeight * 0.015,
                    ),

                    ///////////////////////////////////////////////////

                    // LOGOUT BUTTON

                    SizedBox(

                      width: double.infinity,

                      child: OutlinedButton(

                        style:
                        OutlinedButton.styleFrom(

                          side: BorderSide(
                            color:
                            AppColors.primary,
                          ),

                          padding:
                          const EdgeInsets.symmetric(
                            vertical: 12,
                          ),

                          shape:
                          RoundedRectangleBorder(

                            borderRadius:
                            BorderRadius.circular(30),
                          ),
                        ),

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

                        child: Text(

                          "Logout",

                          style: TextStyle(

                            color:
                            AppColors.primary,

                            fontSize:
                            isSmall
                                ? 14
                                : 16,

                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height:
                      screenHeight * 0.01,
                    ),

                    ///////////////////////////////////////////////////

                    // DELETE ACCOUNT BUTTON

                    TextButton(

                      onPressed: () {

                        confirmDeleteAccount(
                          context,
                        );
                      },

                      child: Text(

                        "Delete Account",

                        style: TextStyle(

                          color: Colors.red,

                          fontSize:
                          isSmall
                              ? 13
                              : 14,

                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////

  // CATEGORY ITEM

  Widget _buildCategory(
      String title,
      int value,
      ) {

    return Padding(

      padding:
      const EdgeInsets.symmetric(
        vertical: 4,
      ),

      child: Row(

        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

        children: [

          Text(title),

          Text("$value%"),
        ],
      ),
    );
  }
}

/////////////////////////////////////////////////////////////

class _ProfileInfoRow
    extends StatelessWidget {

  final List<Map<String, dynamic>>
  results;

  const _ProfileInfoRow({
    required this.results,
  });

  ///////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    int totalQuestions = 0;
    int correctAnswers = 0;

    /////////////////////////////////////////////////////////

    // CALCULATE AVG SCORE

    for (var result in results) {

      totalQuestions +=
      result['totalQuestion'] as int;

      correctAnswers +=
      result['score'] as int;
    }

    double overallPercent = 0;

    if (totalQuestions > 0) {

      overallPercent =
          (correctAnswers / totalQuestions)
              * 100;
    }

    /////////////////////////////////////////////////////////

    return Container(

      height: 80,

      decoration: BoxDecoration(

        color:
        AppColors.background,

        borderRadius:
        BorderRadius.circular(16),
      ),

      child: Row(

        mainAxisAlignment:
        MainAxisAlignment.spaceEvenly,

        children: [

          Expanded(

            child: Center(

              child: Column(

                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  Text(

                    "${overallPercent.toStringAsFixed(0)}%",

                    style: const TextStyle(

                      fontWeight:
                      FontWeight.bold,

                      fontSize: 22,
                    ),
                  ),

                  const Text(
                    "Avg Score",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/////////////////////////////////////////////////////////////

class _TopPortion
    extends StatelessWidget {

  const _TopPortion();

  ///////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    return Stack(

      fit: StackFit.expand,

      children: [

        ///////////////////////////////////////////////////////

        // BLUE HEADER

        Container(

          margin:
          const EdgeInsets.only(
            bottom: 40,
          ),

          decoration:
          const BoxDecoration(

            gradient:
            LinearGradient(

              colors: [

                AppColors.primaryDark,
                AppColors.primary,
              ],

              begin:
              Alignment.bottomCenter,

              end:
              Alignment.topCenter,
            ),

            borderRadius:
            BorderRadius.only(

              bottomLeft:
              Radius.circular(40),

              bottomRight:
              Radius.circular(40),
            ),
          ),
        ),

        ///////////////////////////////////////////////////////

        // PROFILE IMAGE

        Align(

          alignment:
          Alignment.bottomCenter,

          child: CircleAvatar(

            radius: 55,

            backgroundColor:
            Colors.white,

            child: const CircleAvatar(

              radius: 50,

              backgroundImage:
              AssetImage("assets/images/profile.jpg"),
              ),
            ),
          ),


        ///////////////////////////////////////////////////////

        // BACK BUTTON

        Positioned(

          top: 50,
          left: 16,

          child: IconButton(

            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),

            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}