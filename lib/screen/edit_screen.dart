import 'package:archive_idea_udemy/data/idea_info.dart';
import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  IdeaInfo? ideaInfo;

  EditScreen({super.key, this.ideaInfo});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 24,
            color: Colors.black,
          ),
          onTap: () {
            // back button
            Navigator.pop(context);
          },
        ),
        title: Text(
          '새 아이디어 작성하기',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }
}
