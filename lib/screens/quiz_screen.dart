import 'package:flutter/material.dart';
import 'package:final_project_pmd/data/quiz_data.dart';
import 'package:final_project_pmd/screens/result_screen.dart';
import 'package:final_project_pmd/const/constant.dart';
import 'package:final_project_pmd/services/quiz_service.dart';

class QuizScreen extends StatefulWidget {

  // QUIZ CATEGORY
  final String category;

  // CURRENT USER
  final Map<String, dynamic> user;

  const QuizScreen({
    super.key,
    required this.category,
    required this.user,
  });

  @override
  State<QuizScreen> createState() =>
      _QuizScreenState();
}

/////////////////////////////////////////////////////////////

class _QuizScreenState
    extends State<QuizScreen> {

  // QUESTION LIST

  late List<Map<String, dynamic>>
  questions;

  ///////////////////////////////////////////////////////////

  // QUIZ STATE

  int currentIndex = 0;
  int selected = -1;
  int score = 0;

  bool isAnswered = false;

  ///////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();

    // LOAD QUESTIONS
    questions =
    quizData[widget.category]!;
  }

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

      /////////////////////////////////////////////////////////

      // APP BAR

      appBar: AppBar(
        title: Text(widget.category),
      ),

      /////////////////////////////////////////////////////////

      // BODY

      body: SafeArea(

        child: Padding(

          padding: EdgeInsets.all(
            screenWidth * 0.05,
          ),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              ///////////////////////////////////////////////////

              // QUIZ PROGRESS BAR

              LinearProgressIndicator(

                value:
                (currentIndex + 1) /
                    questions.length,

                backgroundColor:
                AppColors.primary
                    .withOpacity(0.2),

                valueColor:
                AlwaysStoppedAnimation(
                  AppColors.primary,
                ),

                minHeight: 6,
              ),

              SizedBox(
                height:
                screenHeight * 0.03,
              ),

              ///////////////////////////////////////////////////

              // QUESTION TEXT

              Text(

                questions[currentIndex]
                ["question"],

                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(

                  fontSize:
                  isSmall
                      ? 20
                      : 24,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              SizedBox(
                height:
                screenHeight * 0.03,
              ),

              ///////////////////////////////////////////////////

              // ANSWER OPTIONS

              ...(questions[currentIndex]
              ["options"] as List<String>)

                  .asMap()
                  .entries
                  .map((e) {

                int correctAnswer =
                questions[currentIndex]
                ["answer"];

                Color? tileColor;

                ///////////////////////////////////////////////////

                // ANSWER FEEDBACK COLOR

                if (isAnswered) {

                  if (e.key ==
                      correctAnswer) {

                    tileColor =
                        Colors.green
                            .withOpacity(0.3);
                  }

                  else if (e.key ==
                      selected) {

                    tileColor =
                        Colors.red
                            .withOpacity(0.3);
                  }
                }

                ///////////////////////////////////////////////////

                return Container(

                  margin:
                  const EdgeInsets.symmetric(
                    vertical: 4,
                  ),

                  decoration:
                  BoxDecoration(

                    color: tileColor,

                    borderRadius:
                    BorderRadius.circular(12),
                  ),

                  child: RadioListTile<int>(

                    value: e.key,

                    groupValue:
                    selected,

                    ///////////////////////////////////////////////////

                    // OPTION SELECT

                    onChanged:
                    isAnswered
                        ? null
                        : (v) {

                      setState(() {

                        selected =
                            v ?? -1;
                      });
                    },

                    ///////////////////////////////////////////////////

                    // OPTION TEXT

                    title: Text(

                      e.value,

                      style: TextStyle(

                        fontSize:
                        isSmall
                            ? 14
                            : 16,
                      ),
                    ),
                  ),
                );
              }).toList(),

              ///////////////////////////////////////////////////

              // PUSH BUTTON TO BOTTOM

              const Spacer(),

              ///////////////////////////////////////////////////

              // SUBMIT / NEXT BUTTON

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  style:
                  ElevatedButton.styleFrom(

                    padding:
                    EdgeInsets.symmetric(

                      vertical:
                      screenHeight * 0.018,
                    ),

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),

                  ///////////////////////////////////////////////////

                  // BUTTON ACTION

                  onPressed:
                  selected >= 0
                      ? submitAnswer
                      : null,

                  ///////////////////////////////////////////////////

                  // BUTTON TEXT

                  child: Text(

                    isAnswered
                        ? "Next"
                        : "Submit",

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
            ],
          ),
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////

  // SUBMIT ANSWER FUNCTION

  Future<void> submitAnswer() async {

    /////////////////////////////////////////////////////////

    // FIRST CLICK → CHECK ANSWER

    if (!isAnswered) {

      setState(() {

        isAnswered = true;

        /////////////////////////////////////////////////////

        // ADD SCORE

        if (selected ==
            questions[currentIndex]
            ["answer"]) {

          score++;
        }
      });
    }

    /////////////////////////////////////////////////////////

    // SECOND CLICK → NEXT QUESTION

    else {

      ///////////////////////////////////////////////////////

      // GO TO NEXT QUESTION

      if (currentIndex <
          questions.length - 1) {

        setState(() {

          currentIndex++;

          selected = -1;

          isAnswered = false;
        });
      }

      ///////////////////////////////////////////////////////

      // QUIZ FINISHED

      else {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (context) =>
                ResultScreen(

                  score: score,

                  total: questions.length,

                  user: widget.user,

                  category: widget.category,
                ),
          ),
        );
      }
    }
  }
}