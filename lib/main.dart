import 'package:archive_idea_udemy/data/idea_info.dart';
import 'package:archive_idea_udemy/screen/detail_screen.dart';
import 'package:archive_idea_udemy/screen/edit_screen.dart';
import 'package:archive_idea_udemy/screen/main_screen.dart';
import 'package:archive_idea_udemy/screen/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Archive Idea',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/main': (context) => MainScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/edit') {
          // 아이디어 기록값을 넘기지 못한다면 작성 시나리오

          // 아이디어 기록값을 넘길 수 있다면 수정 시나리오
          final IdeaInfo? ideaInfo = settings.arguments as IdeaInfo?;
          return MaterialPageRoute(builder: (context) {
            return EditScreen(ideaInfo: ideaInfo,);
          },);
        } else if (settings.name == '/detail') {
          final IdeaInfo? ideaInfo = settings.arguments as IdeaInfo?;
          return MaterialPageRoute(builder: (context) {
            return DetailScreen(ideaInfo: ideaInfo,);
          },);
        }
      },
    );
  }
}

