import 'package:archive_idea_udemy/database/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../data/idea_info.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var dbHelper = DatabaseHelper(); // 데이터베이스 접근을 용이하게 해주는 유틸 객체
  List<IdeaInfo> lstIdeaInfo = []; // 아이디어 목록 데이터들이 담길 공간

  @override
  void initState() {
    // 아이디어 목록들 가져오기 !
    getIdeaInfo();

    // 임시용으로 insert data
    // setInsertIdeaInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Archive Idea',
          style: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: lstIdeaInfo.length,
          itemBuilder: (context, index) {
            return listItem(index);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 새 아이디어 작성 화면으로 이동
        },
        child: Image.asset(
          'assets/idea.png',
          width: 48,
          height: 48,
        ),
        backgroundColor: Color(0xff7f52fd).withOpacity(0.7),
      ),
    );
  }

  Widget listItem(int index) {
    return Container(
      height: 82,
      margin: EdgeInsets.only(top: 16),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xffd9d9d9d9), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          /// 아이디어 제목
          Container(
            margin: EdgeInsets.only(left: 16, bottom: 16),
            child: Text(
              lstIdeaInfo[index].title,
              style: TextStyle(fontSize: 16),
            ),
          ),

          /// 일시
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(right: 16, bottom: 8),
              child: Text(
                DateFormat("yyyy.MM.dd HH:mm").format(
                  DateTime.fromMillisecondsSinceEpoch(lstIdeaInfo[index].createdAt),
                ),
                style: TextStyle(color: Color(0xffaeaeae), fontSize: 10),
              ),
            ),
          ),

          /// 아이디어 중요도 점수 (별 형태로)
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(left: 16, bottom: 8),
              child: RatingBar.builder(
                initialRating: lstIdeaInfo[index].priority.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemSize: 16,
                itemPadding: EdgeInsets.symmetric(horizontal: 0),
                itemBuilder: (context, index) {
                  return Icon(
                    Icons.star,
                    color: Colors.amber,
                  );
                },
                ignoreGestures: true,
                updateOnDrag: false,
                onRatingUpdate: (value) {},
              ),
            ),
          )
        ],
      ),
    );
  }

  Future getIdeaInfo() async {
    // 아이디어 목록 조회 (select)
    await dbHelper.initDatabase();
    // idea 정보들을 가지고 와서 맴버 (전역) 변수 리스트 객체에 넣기
    lstIdeaInfo = await dbHelper.getAllIdeaInfo();
    // 리스트 객체 역순으로 정렬
    lstIdeaInfo.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    setState(() {}); // list ui update
  }

  Future setInsertIdeaInfo() async {
    // 삼입 하는 메서드
    await dbHelper.initDatabase();
    await dbHelper.insertIdeaInfo(IdeaInfo(
      title: '# 환경 보존 문제해결 앱 아이디어',
      motive: '길가다가 쓰레기 주우면서 알게됨',
      content: '자세한 내용 입니다 .... 자세한 내용',
      priority: 5,
      feedback: '피드백 사항 입니다.',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    ));
  }
}
