import 'package:flutter/material.dart';
import 'package:final_project_pmd/const/constant.dart';
import 'package:final_project_pmd/screens/login_screen.dart';
import 'package:final_project_pmd/screens/quiz_list_screen.dart';
import 'package:final_project_pmd/screens/dashboard_screen.dart';
import 'package:final_project_pmd/screens/profile_screen.dart';

/////////////////////////////////////////////////////////////
/// SIDE MENU
/////////////////////////////////////////////////////////////

class SideMenu extends StatelessWidget {

  // CURRENT PAGE
  final String currentPage;

  // CURRENT USER
  final Map<String, dynamic> user;

  const SideMenu({
    super.key,
    required this.currentPage,
    required this.user,
  });

  ///////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    // RESPONSIVE SIZE

    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final isSmall =
        screenWidth < 400;

    /////////////////////////////////////////////////////////

    return Drawer(

      child: ListView(

        padding: EdgeInsets.zero,

        children: [

          ///////////////////////////////////////////////////
          /// HEADER
          ///////////////////////////////////////////////////

          DrawerHeader(

            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                ///////////////////////////////////////////////////
                /// LOGOS
                ///////////////////////////////////////////////////

                Row(

                  children: [

                    Expanded(

                      child: Image.asset(

                        'assets/images/logo.png',

                        height:
                        isSmall
                            ? 45
                            : 50,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(

                      child: Image.asset(

                        'assets/images/sdglogo.png',

                        height:
                        isSmall
                            ? 45
                            : 50,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                ///////////////////////////////////////////////////
                /// APP TITLE
                ///////////////////////////////////////////////////

                Text(

                  "EduTrack",

                  style: TextStyle(

                    color: Colors.white,

                    fontSize:
                    isSmall
                        ? 22
                        : 25,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                ///////////////////////////////////////////////////
                /// SUBTITLE
                ///////////////////////////////////////////////////

                Text(

                  "Track. Learn. Improve.",

                  style: TextStyle(

                    color: Colors.white,

                    fontSize:
                    isSmall
                        ? 16
                        : 20,
                  ),
                ),
              ],
            ),
          ),

          ///////////////////////////////////////////////////
          /// PROFILE
          ///////////////////////////////////////////////////

          ListTile(

            leading:
            const Icon(Icons.person),

            title:
            const Text("Profile"),

            selected: false,

            selectedTileColor:
            AppColors.menuHighlight,

            splashColor:
            AppColors.menuSplash,

            hoverColor:
            AppColors.menuHover,

            onTap: () {

              Navigator.pop(context);

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (context) =>
                      ProfileScreen(
                        user: user,
                      ),
                ),
              );
            },
          ),

          ///////////////////////////////////////////////////
          /// DASHBOARD
          ///////////////////////////////////////////////////

          ListTile(

            leading:
            const Icon(Icons.dashboard),

            title:
            const Text("Dashboard"),

            selected:
            currentPage == "dashboard",

            selectedTileColor:
            AppColors.menuHighlight,

            splashColor:
            AppColors.menuSplash,

            hoverColor:
            AppColors.menuHover,

            onTap: () {

              Navigator.pop(context);

              Navigator.pushAndRemoveUntil(

                context,

                MaterialPageRoute(

                  builder: (context) =>
                      DashboardScreen(
                        user: user,
                      ),
                ),

                    (route) => false,
              );
            },
          ),

          ///////////////////////////////////////////////////
          /// QUIZ
          ///////////////////////////////////////////////////

          ListTile(

            leading:
            const Icon(Icons.quiz),

            title:
            const Text("Quiz"),

            selected: false,

            selectedTileColor:
            AppColors.menuHighlight,

            splashColor:
            AppColors.menuSplash,

            hoverColor:
            AppColors.menuHover,

            onTap: () {

              Navigator.pop(context);

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
          ),

          ///////////////////////////////////////////////////
          /// LOGOUT
          ///////////////////////////////////////////////////

          ListTile(

            leading:
            const Icon(Icons.logout),

            title:
            const Text("Logout"),

            selected: false,

            selectedTileColor:
            AppColors.menuHighlight,

            splashColor:
            AppColors.menuSplash,

            hoverColor:
            AppColors.menuHover,

            onTap: () {

              Navigator.pushAndRemoveUntil(

                context,

                MaterialPageRoute(

                  builder: (context) =>
                  const LoginScreen(),
                ),

                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}