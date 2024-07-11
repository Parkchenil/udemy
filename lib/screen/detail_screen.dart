import 'package:archive_idea_udemy/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../data/idea_info.dart';

/// 상세 화면
class DetailScreen extends StatelessWidget {
  IdeaInfo? ideaInfo;
  final dbHelper = DatabaseHelper();

  DetailScreen({super.key, this.ideaInfo});

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
          ideaInfo!.title,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              /// 아이디어 삭제 처리 but 그전에 알림으로 물어보는 창 띄우기 !
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('주의'),
                    content: Text('아이디어를 삭제하시겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // 다이얼로그 팝업 종료
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          '취소',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          // 아이디어 삭제 처리
                          await setDeleteIdeaInfo(
                              ideaInfo!.id!); // database 내의 데이터 제거
                          // 이전 화면으로 복귀 1. 팝업 종료, 2. 화면 종료
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            Navigator.pop(context, 'delete');
                          }
                        },
                        child: Text(
                          '삭제',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              '삭제',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 아이디어를 떠올린 계기
                    Text(
                      '아이디어를 떠올린 계기',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ideaInfo!.motive,
                      style: TextStyle(
                        color: Color(0xffa5a5a5),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    /// 아이디어 내용
                    Text(
                      '아이디어 내용',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ideaInfo!.content,
                      style: TextStyle(
                        color: Color(0xffa5a5a5),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    /// 아이디어 중요도 점수
                    Text(
                      '아이디어 중요도 점수',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: ideaInfo!.priority.toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 35,
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
                    SizedBox(
                      height: 30,
                    ),

                    /// 유저 피드백 사항
                    Text(
                      '유저 피드백 사항',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ideaInfo!.feedback,
                      style: TextStyle(
                        color: Color(0xffa5a5a5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// 내용 편집하기 버튼
          GestureDetector(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              height: 65,
              alignment: Alignment.center,
              child: Text('내용 편집하기'),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onTap: () async {
              // 아이디어 수정 화면으로 이동
              var result = await Navigator.pushNamed(context, '/edit', arguments: ideaInfo);
              if (result != null) {
                if (context.mounted) {
                  Navigator.pop(context, 'update');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Future setDeleteIdeaInfo(int id) async {
    // 기존 아이디어 정보를 제거
    await dbHelper.initDatabase();
    await dbHelper.deleteIdeaInfo(id);
  }
}
