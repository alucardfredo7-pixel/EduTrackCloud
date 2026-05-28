import 'package:flutter/material.dart';
import 'package:final_project_pmd/services/quiz_service.dart';
import 'package:final_project_pmd/widgets/side_menu.dart';
import 'package:final_project_pmd/const/constant.dart';
import 'package:final_project_pmd/screens/quiz_list_screen.dart';
import 'package:final_project_pmd/screens/profile_screen.dart';
import 'package:final_project_pmd/screens/login_screen.dart';
import 'package:final_project_pmd/screens/sign_up_screen.dart';

class DashboardScreen extends StatefulWidget {

  final Map<String, dynamic> user;
  final int? latestResult;

  const DashboardScreen({
    super.key,
    required this.user,
    this.latestResult,
  });

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

/////////////////////////////////////////////////////////////

class _DashboardScreenState
    extends State<DashboardScreen> {

 // final QuizService _quizService =
 // QuizService();

  final QuizService
  _quizService =
  QuizService();

  double overallPercent = 0;
  bool isLoading = true;

  int totalQuestions = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  int latestScore = 0;

  /////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    loadOverallProgress();
  }

  /////////////////////////////////////////////////////////////

  Future<void> loadOverallProgress() async {

    final results =
    await _quizService
        .getUserResults(
      widget.user['id'],
    );


    totalQuestions = 0;
    correctAnswers = 0;
    wrongAnswers = 0;

    for (var result in results) {

      totalQuestions +=
      result['totalQuestion'] as int;

      correctAnswers +=
      result['score'] as int;
    }

    if (widget.latestResult != null) {

      latestScore =
      widget.latestResult!;

    }

    wrongAnswers =
        totalQuestions - correctAnswers;

    if (totalQuestions > 0) {

      overallPercent =
          (correctAnswers / totalQuestions)
              * 100;
    } else {

      overallPercent = 0;

      latestScore = 0;
    }

    setState(() {

      isLoading = false;
    });
  }

  /////////////////////////////////////////////////////////////

  String getPerformanceMessage() {

    if (totalQuestions == 0) {
      return "Start your first quiz";
    }

    if (overallPercent >= 80) {
      return "Excellent Progress";
    }

    if (overallPercent >= 60) {
      return "Good Job";
    }

    return "Keep Improving";
  }

  /////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    final screenWidth =
        MediaQuery.sizeOf(context).width;

    return Scaffold(

      backgroundColor:
      AppColors.background,

      /////////////////////////////////////////////////////////

      appBar: AppBar(

        title: const Text("Dashboard"),

        backgroundColor:
        AppColors.primary,

        foregroundColor:
        AppColors.white,

        actions: [

          PopupMenuButton<String>(

            icon: const Icon(Icons.person),

            onSelected: (value) {

              ///////////////////////////////////////////////////

              if (value == 'profile') {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfileScreen(
                          user: widget.user,
                        ),
                  ),
                );
              }

              ///////////////////////////////////////////////////

              else if (value == 'signup') {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const SignUpScreen(),
                  ),
                );
              }

              ///////////////////////////////////////////////////

              else if (value == 'logout') {

                Navigator.pushAndRemoveUntil(

                  context,

                  MaterialPageRoute(
                    builder: (context) =>
                    const LoginScreen(),
                  ),

                      (route) => false,
                );
              }
            },

            /////////////////////////////////////////////////////

            itemBuilder: (context) => [

              const PopupMenuItem(
                value: 'profile',
                child: Text('Profile'),
              ),

              const PopupMenuItem(
                value: 'signup',
                child: Text('Sign Up'),
              ),

              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),

      /////////////////////////////////////////////////////////

      drawer: SideMenu(
        currentPage: "dashboard",
        user: widget.user,
      ),

      /////////////////////////////////////////////////////////

      body: SafeArea(

        child: Padding(

          padding: AppSpacing.padding,

          child: SingleChildScrollView(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                ///////////////////////////////////////////////////

                Text(

                  "Welcome back, ${widget.user['name']}!",

                  style: TextStyle(

                    fontSize:
                    screenWidth < 400
                        ? 18
                        : 22,

                    fontWeight:
                    FontWeight.bold,

                    color:
                    AppColors.textPrimary,
                  ),
                ),

                SizedBox(
                  height: AppSpacing.small,
                ),

                ///////////////////////////////////////////////////

                Text(

                  "Ready to continue your SDG learning journey?",

                  style: TextStyle(

                    fontSize:
                    screenWidth < 400
                        ? 15
                        : 19,

                    color:
                    AppColors.textSecondary,
                  ),
                ),

                SizedBox(
                  height: AppSpacing.large,
                ),

                ///////////////////////////////////////////////////

                buildPerformanceCard(
                  screenWidth,
                ),

                SizedBox(
                  height: AppSpacing.large,
                ),

                ///////////////////////////////////////////////////

                buildSummaryCard(),

                SizedBox(
                  height: AppSpacing.large,
                ),

                ///////////////////////////////////////////////////

                buildLatestResult(),

                SizedBox(
                  height: AppSpacing.large,
                ),

                ///////////////////////////////////////////////////

                buildContinueQuiz(
                  context,
                  widget.user,
                ),

                SizedBox(
                  height: AppSpacing.large,
                ),

                buildSDGInfo(
                  context,
                  widget.user,
                ),

                ///////////////////////////////////////////////////

              ],
            ),
          ),
        ),
      ),
    );
  }

  /////////////////////////////////////////////////////////////

  Widget buildPerformanceCard(
      double screenWidth,
      ) {

    return Container(

      padding: EdgeInsets.all(
        screenWidth * 0.05,
      ),

      decoration: BoxDecoration(

        color: AppColors.primary,

        borderRadius:
        AppRadius.card,

        boxShadow:
        AppShadow.strongShadow,
      ),

      child: Row(

        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

        children: [

          ///////////////////////////////////////////////////////

          Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Row(

                children: [

                  Text(

                    "Quiz Performance",

                    style: TextStyle(

                      color:
                      AppColors.white
                          .withOpacity(0.8),

                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(width: 6),

                  const Icon(
                    Icons.show_chart,
                    color: Colors.white70,
                  ),
                ],
              ),

              SizedBox(
                height: AppSpacing.small,
              ),

              ///////////////////////////////////////////////////

              Text(

                "${overallPercent.toStringAsFixed(0)}%",

                style: TextStyle(

                  fontSize:
                  screenWidth < 400
                      ? 30
                      : 36,

                  fontWeight:
                  FontWeight.bold,

                  color:
                  AppColors.white,
                ),
              ),

              const SizedBox(height: 4),

              ///////////////////////////////////////////////////

              Text(

                getPerformanceMessage(),

                style: TextStyle(

                  color:
                  AppColors.white
                      .withOpacity(0.8),

                  fontSize: 12,
                ),
              ),
            ],
          ),

          ///////////////////////////////////////////////////////

          const Icon(
            Icons.bar_chart,
            color: AppColors.white,
            size: 40,
          ),
        ],
      ),
    );
  }

  /////////////////////////////////////////////////////////////

  Widget buildSummaryCard() {

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: AppColors.white,

        borderRadius:
        AppRadius.card,

        boxShadow:
        AppShadow.cardShadow,
      ),

      child: Column(

        children: [

          buildRow(
            "Total Quiz Question",
            "$totalQuestions",
          ),

          SizedBox(
            height: AppSpacing.small,
          ),

          buildRow(
            "Correct Answers",
            "$correctAnswers",
            color: AppColors.success,
          ),

          SizedBox(
            height: AppSpacing.small,
          ),

          buildRow(
            "Wrong Answers",
            "$wrongAnswers",
            color: AppColors.error,
          ),
        ],
      ),
    );
  }

  /////////////////////////////////////////////////////////////

  Widget buildLatestResult() {

    String getFeedback(int latestScore) {

      if (totalQuestions == 0) {
        return "No Quiz Yet";
      }

      if (latestScore >= 80) {
        return "Excellent";
      }

      if (latestScore >= 60) {
        return "Good Job";
      }

      return "Keep Improving";
    }

    return Container(

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: AppColors.white,

        borderRadius:
        AppRadius.card,

        boxShadow:
        AppShadow.cardShadow,
      ),

      child: Row(

        children: [

          ///////////////////////////////////////////////////////

          Container(

            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(

              color:
              AppColors.primary
                  .withOpacity(0.1),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.history,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 12),

          ///////////////////////////////////////////////////////

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                const Text(

                  "Latest Result",

                  style: TextStyle(

                    fontSize: 12,

                    color:
                    AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 4),

                Text(

                  getFeedback(latestScore),

                  style: const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          ///////////////////////////////////////////////////////

          Text(

            "$latestScore%",

            style: TextStyle(

              fontSize: 20,

              fontWeight:
              FontWeight.bold,

              color:
              latestScore >= 80
                  ? Colors.green
                  : latestScore >= 60
                  ? Colors.orange
                  : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

/////////////////////////////////////////////////////////////

Widget buildContinueQuiz(
    BuildContext context,
    Map<String, dynamic> user,
    ) {

  return Container(

    padding: const EdgeInsets.all(16),

    decoration: BoxDecoration(

      gradient:
      AppColors.primaryGradient,

      borderRadius:
      AppRadius.card,

      boxShadow:
      AppShadow.cardShadow,
    ),

    child: Row(

      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

      children: [

        /////////////////////////////////////////////////////////

        Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: const [

            Text(

              "Continue Quiz",

              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),

            SizedBox(height: 4),

            Text(

              "Next SDG set available",

              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),

        /////////////////////////////////////////////////////////

        ElevatedButton(

          style:
          ElevatedButton.styleFrom(

            backgroundColor:
            Colors.white,

            foregroundColor:
            AppColors.primary,

            shape: RoundedRectangleBorder(

              borderRadius:
              BorderRadius.circular(15),
            ),

            padding:
            const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
          ),

          onPressed: () {

            Navigator.push(

              context,

              MaterialPageRoute(

                builder: (context) =>
                    QuizListScreen(
                      user: user,
                    ),
              ),
            );
          },

          child: const Text("Start"),
        ),
      ],
    ),
  );
}

/////////////////////////////////////////////////////////////

Widget buildSDGInfo(
    BuildContext context,
    Map<String, dynamic> user,) {

  return Container(

    padding: const EdgeInsets.all(16),

    decoration: BoxDecoration(

      color: const Color(0xFFFFFBEB),

      borderRadius:
      AppRadius.card,

      boxShadow:
      AppShadow.cardShadow,
    ),

    child: Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children:  [

        Text(

          "About This App",

          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 8),

        Text(
          "Test your knowledge on Sustainable Development Goals and track your progress with each quiz you complete.",
        ),
      ],
    ),
  );
}

/////////////////////////////////////////////////////////////

Widget buildRow(
    String title,
    String value,
    {Color? color}
    ) {

  return Row(

    mainAxisAlignment:
    MainAxisAlignment.spaceBetween,

    children: [

      Text(

        title,

        style: const TextStyle(

          color:
          AppColors.textSecondary,

          fontSize: 14,
        ),
      ),

      ///////////////////////////////////////////////////////////

      Container(

        padding:
        const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),

        decoration: BoxDecoration(

          color:
          (color ?? Colors.grey)
              .withOpacity(0.1),

          borderRadius:
          BorderRadius.circular(10),
        ),

        child: Text(

          value,

          style: TextStyle(

            fontWeight:
            FontWeight.bold,

            color:
            color ??
                AppColors.textPrimary,
          ),
        ),
      ),
    ],
  );
}