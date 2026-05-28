import 'package:flutter/material.dart';
import 'package:final_project_pmd/screens/login_screen.dart';
import 'package:final_project_pmd/const/constant.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {

  // Control onboarding page movement
  final PageController _controller =
  PageController();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    // Screen size for responsive UI
    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final screenHeight =
        MediaQuery.sizeOf(context).height;

    return Scaffold(

      backgroundColor: AppColors.background,

      body: SafeArea(

        child: Column(

          children: [

            // ====================
            // TOP NAVIGATION
            // ====================

            Padding(

              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.06,
                screenHeight * 0.01,
                screenWidth * 0.06,
                0,
              ),

              child: Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [

                  // Back button
                  currentIndex > 0

                      ? TextButton(

                    onPressed: () {

                      _controller.previousPage(

                        duration: const Duration(
                          milliseconds: 300,
                        ),

                        curve: Curves.easeInOut,
                      );
                    },

                    child: const Text("Back"),
                  )

                      : const SizedBox(width: 60),

                  // Skip button
                  currentIndex != 2

                      ? TextButton(

                    onPressed: () {

                      _controller.jumpToPage(2);
                    },

                    child: const Text("Skip"),
                  )

                      : const SizedBox(width: 60),
                ],
              ),
            ),

            // ====================
            // PAGE VIEW
            // ====================

            Expanded(

              child: PageView(

                controller: _controller,

                onPageChanged: (index) {

                  setState(() {

                    currentIndex = index;
                  });
                },

                children: [

                  buildPage(

                    screenWidth: screenWidth,

                    image:
                    "assets/images/onboarding1.png",

                    title:
                    "Take Exams Easily",

                    desc:
                    "Complete your exams smoothly and track your progress.",
                  ),

                  buildPage(

                    screenWidth: screenWidth,

                    image:
                    "assets/images/onboarding2.png",

                    title:
                    "Track Progress",

                    desc:
                    "Monitor your performance in real time and gain insights to improve your result.",
                  ),

                  buildPage(

                    screenWidth: screenWidth,

                    image:
                    "assets/images/onboarding3.png",

                    title:
                    "Improve Skills",

                    desc:
                    "Analyze results effectively and improve your performance.",
                  ),
                ],
              ),
            ),

            // ====================
            // PAGE INDICATOR
            // ====================

            Row(

              mainAxisAlignment:
              MainAxisAlignment.center,

              children: List.generate(

                3,

                    (index) {

                  return AnimatedContainer(

                    duration: const Duration(
                      milliseconds: 250,
                    ),

                    margin:
                    const EdgeInsets.all(4),

                    width:
                    currentIndex == index
                        ? 18
                        : 8,

                    height: 8,

                    decoration: BoxDecoration(

                      color:
                      currentIndex == index
                          ? AppColors.primary
                          : Colors.grey,

                      borderRadius:
                      BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              height: screenHeight * 0.02,
            ),

            // ====================
            // NEXT / START BUTTON
            // ====================

            Padding(

              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
              ),

              child: SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(

                    backgroundColor:
                    AppColors.primary,

                    padding:
                    EdgeInsets.symmetric(
                      vertical:
                      screenHeight * 0.018,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      AppRadius.card,
                    ),
                  ),

                  onPressed: () {

                    if (currentIndex == 2) {

                      Navigator.pushReplacement(

                        context,

                        MaterialPageRoute(

                          builder: (context) =>
                          const LoginScreen(),
                        ),
                      );

                    } else {

                      _controller.nextPage(

                        duration: const Duration(
                          milliseconds: 300,
                        ),

                        curve: Curves.easeInOut,
                      );
                    }
                  },

                  child: Text(

                    currentIndex == 2
                        ? "Start"
                        : "Next",

                    style: TextStyle(

                      fontSize:
                      screenWidth < 400
                          ? 14
                          : 16,

                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: screenHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}

// ====================
// REUSABLE PAGE WIDGET
// ====================

Widget buildPage({

  required double screenWidth,
  required String image,
  required String title,
  required String desc,

}) {

  return Padding(

    padding: AppSpacing.padding,

    child: Column(

      children: [

        // ====================
        // ONBOARDING IMAGE
        // ====================

        Expanded(

          flex: 6,

          child: Center(

            child: Image.asset(

              image,

              fit: BoxFit.contain,
            ),
          ),
        ),

        // ====================
        // TEXT CONTENT
        // ====================

        Expanded(

          flex: 3,

          child: Column(

            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [

              Text(

                title,

                textAlign: TextAlign.center,

                style: TextStyle(

                  fontSize:
                  screenWidth < 400
                      ? 24
                      : 28,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(

                desc,

                textAlign: TextAlign.center,

                style: TextStyle(

                  fontSize:
                  screenWidth < 400
                      ? 14
                      : 16,

                  color: Colors.black54,

                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}