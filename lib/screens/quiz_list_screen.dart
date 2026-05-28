import 'package:flutter/material.dart';
import 'package:final_project_pmd/const/constant.dart';
import 'package:final_project_pmd/screens/quiz_screen.dart';

class QuizListScreen extends StatelessWidget {

  // CURRENT LOGGED IN USER

  final Map<String, dynamic>? user;

  const QuizListScreen({
    super.key,
    this.user,
  });

  ///////////////////////////////////////////////////////////

  // QUIZ CATEGORY LIST

  static const _categories = [

    {
      'name': 'General SDG',
      'icon': Icons.public,
    },

    {
      'name': 'Social & Education',
      'icon': Icons.school,
    },

    {
      'name': 'Environment',
      'icon': Icons.eco,
    },

    {
      'name': 'Mixed Challenge',
      'icon': Icons.auto_awesome,
    },
  ];

  ///////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    // RESPONSIVE SCREEN SIZE

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
          "Select Quiz Category",
        ),

        backgroundColor:
        AppColors.primary,

        foregroundColor:
        Colors.white,
      ),

      /////////////////////////////////////////////////////////

      // BODY

      body: SafeArea(

        child: GridView.builder(

          padding: EdgeInsets.all(
            screenWidth * 0.06,
          ),

          itemCount:
          _categories.length,

          /////////////////////////////////////////////////////

          // RESPONSIVE GRID

          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(

            crossAxisCount:
            screenWidth < 600
                ? 2
                : 3,

            crossAxisSpacing:
            screenWidth * 0.04,

            mainAxisSpacing:
            screenWidth * 0.04,

            childAspectRatio:
            isSmall
                ? 1.0
                : 1.2,
          ),

          /////////////////////////////////////////////////////

          itemBuilder: (
              context,
              index,
              ) {

            final category =
            _categories[index];

            return Container(

              decoration: BoxDecoration(

                color:
                AppColors.white,

                borderRadius:
                BorderRadius.circular(16),

                boxShadow: [

                  BoxShadow(

                    color:
                    Colors.black.withOpacity(0.05),

                    blurRadius: 6,

                    offset:
                    const Offset(0, 2),
                  ),
                ],
              ),

              ///////////////////////////////////////////////////

              // CATEGORY BUTTON

              child: InkWell(

                borderRadius:
                BorderRadius.circular(16),

                onTap: () {

                  if (user == null) {

                    showDialog(

                      context: context,

                      builder: (context) {

                        return AlertDialog(

                          title: const Text(
                            "Login Required",
                          ),

                          content: const Text(
                            "Please login to start the quiz.",
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

                    return;
                  }

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (context) =>
                          QuizScreen(

                            category:
                            category['name']
                            as String,

                            user: user!,
                          ),
                    ),
                  );
                },

                ///////////////////////////////////////////////////

                child: Padding(

                  padding:
                  EdgeInsets.all(
                    screenWidth * 0.03,
                  ),

                  child: Column(

                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [

                      ///////////////////////////////////////////////////

                      // CATEGORY ICON

                      Icon(

                        category['icon']
                        as IconData,

                        size:
                        isSmall
                            ? 42
                            : 48,

                        color:
                        AppColors.primary,
                      ),

                      SizedBox(
                        height:
                        screenHeight * 0.015,
                      ),

                      ///////////////////////////////////////////////////

                      // CATEGORY TITLE

                      Text(

                        category['name']
                        as String,

                        textAlign:
                        TextAlign.center,

                        style: TextStyle(

                          fontWeight:
                          FontWeight.bold,

                          fontSize:
                          isSmall
                              ? 13
                              : 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}