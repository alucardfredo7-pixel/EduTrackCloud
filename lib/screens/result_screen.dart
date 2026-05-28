import 'package:flutter/material.dart';
import 'package:final_project_pmd/services/quiz_service.dart';
import 'package:final_project_pmd/const/constant.dart';
import 'package:final_project_pmd/screens/dashboard_screen.dart';
import 'package:final_project_pmd/screens/quiz_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResultScreen extends StatelessWidget {

  final int score;
  final int total;
  final Map<String, dynamic> user;
  final String category;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.user,
    required this.category,
  });

  ///////////////////////////////////////////////////////////

  Future<void> confirmReset(
      BuildContext context,
      ) async {

    showDialog(

      context: context,

      builder: (dialogcontext) => AlertDialog(

        title: const Text(
          "Reset Progress",
        ),

        content: const Text(
          "This will delete ALL quiz results. Are you sure?",
        ),

        actions: [

          TextButton(

            onPressed: () =>
                Navigator.pop(dialogcontext),

            child: const Text(
              "Cancel",
            ),
          ),

          ///////////////////////////////////////////////////

          TextButton(

            onPressed: () async {

              Navigator.of(
                dialogcontext,
                rootNavigator: true,
              ).pop();

              final quizService =
              QuizService();

              await quizService.deleteUserResults(
                user['id'],
              );

              Navigator.pushReplacement(

                context,

                MaterialPageRoute(

                  builder: (context) =>

                      DashboardScreen(

                        user: user,

                        latestResult: 0,
                      ),
                ),
              );
            },

            child: const Text(

              "Reset",

              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
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

    /////////////////////////////////////////////////////////

    // CALCULATE PERCENTAGE

    double percent =
    total == 0
        ? 0
        : (score / total) * 100;

    final QuizService
    quizService =
    QuizService();

    /////////////////////////////////////////////////////////

    // PERFORMANCE MESSAGE

    String getMessage() {

      if (percent >= 80) {
        return "Excellent!";
      }

      if (percent >= 60) {
        return "Good Job!";
      }

      return "Keep Improving!";
    }

    /////////////////////////////////////////////////////////

    // RESULT IMAGE

    String getImage() {

      if (percent >= 80) {
        return "assets/images/trophy.png";
      }

      if (percent >= 60) {
        return "assets/images/progress.png";
      }

      return "assets/images/study.png";
    }

    /////////////////////////////////////////////////////////

    return Scaffold(

      backgroundColor:
      AppColors.background,

      /////////////////////////////////////////////////////////

      // APP BAR

      appBar: AppBar(

        title: const Text(
          "Your Result",
        ),

        backgroundColor:
        AppColors.primary,

        foregroundColor:
        Colors.white,
      ),

      /////////////////////////////////////////////////////////

      // BODY

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding: EdgeInsets.all(
              screenWidth * 0.06,
            ),

            ///////////////////////////////////////////////////

            child: Column(

              children: [

                ///////////////////////////////////////////////////

                // TOP SPACING

                SizedBox(
                  height:
                  screenHeight * 0.08,
                ),

                ///////////////////////////////////////////////////

                // RESULT IMAGE

                Image.asset(

                  getImage(),

                  height:
                  isSmall
                      ? 120
                      : 140,
                ),

                SizedBox(
                  height:
                  screenHeight * 0.05,
                ),

                ///////////////////////////////////////////////////

                // SCORE PERCENTAGE

                Text(

                  "${percent.toStringAsFixed(0)}%",

                  style: TextStyle(

                    fontSize:
                    isSmall
                        ? 48
                        : 56,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height:
                  screenHeight * 0.015,
                ),

                ///////////////////////////////////////////////////

                // SCORE DETAIL

                Text(

                  "$score / $total correct",

                  style: TextStyle(

                    fontSize:
                    isSmall
                        ? 15
                        : 16,

                    color:
                    AppColors.textSecondary,
                  ),
                ),

                SizedBox(
                  height:
                  screenHeight * 0.03,
                ),

                ///////////////////////////////////////////////////

                // MESSAGE

                Text(

                  getMessage(),

                  style: TextStyle(

                    fontSize:
                    isSmall
                        ? 18
                        : 20,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height:
                  screenHeight * 0.06,
                ),

                ///////////////////////////////////////////////////

                // BACK BUTTON

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
                        vertical: 16,
                      ),

                      shape:
                      RoundedRectangleBorder(

                        borderRadius:
                        BorderRadius.circular(14),
                      ),

                      elevation: 4,
                    ),

                    onPressed: () async {

                      await quizService
                          .saveQuizResult({

                        'userId': user['id'],

                        'category': category,

                        'score': score,

                        'wrongAnswer': total - score,

                        'totalQuestion': total,

                        'percentage':
                        percent.toInt(),

                        'timestamp':
                        Timestamp.now(),
                      });

                      await Future.delayed(

                        const Duration(
                          milliseconds: 300,
                        ),
                      );

                      Navigator.pushAndRemoveUntil(

                        context,

                        MaterialPageRoute(

                          builder: (context) =>
                              DashboardScreen(

                                user: user,

                                latestResult:
                                percent.toInt(),
                              ),
                        ),

                            (route) => false,
                      );
                    },

                    child: Text(

                      "Back to Dashboard",

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
                  screenHeight * 0.025,
                ),

                ///////////////////////////////////////////////////

                // RETRY BUTTON

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
                        vertical: 16,
                      ),

                      shape:
                      RoundedRectangleBorder(

                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                    ),

                    onPressed: () {

                      Navigator.pushReplacement(

                        context,

                        MaterialPageRoute(

                          builder: (context) =>
                              QuizScreen(

                                category:
                                category,

                                user: user,
                              ),
                        ),
                      );
                    },

                    child: Text(

                      "Retry Quiz",

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
                  screenHeight * 0.03,
                ),

                ///////////////////////////////////////////////////

                // RESET BUTTON

                OutlinedButton(

                  style:
                  OutlinedButton.styleFrom(

                    side:
                    const BorderSide(
                      color: Colors.red,
                    ),
                  ),

                  onPressed: () =>
                      confirmReset(context),

                  child: Text(

                    "Reset All Progress",

                    style: TextStyle(

                      color: Colors.red,

                      fontSize:
                      isSmall
                          ? 13
                          : 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}