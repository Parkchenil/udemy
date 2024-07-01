import 'package:archive_idea_udemy/data/idea_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  late Database database;

  // 데이터 베이스 초기화 및 열기
  Future<void> initDatabase() async {
    // 데이터 베이스 경로 가져오기
    String path = join(await getDatabasesPath(), 'archiv_idea.db');

    // 데이터 베이스 열기 또는 생성
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // 데이터 베잇스가 생성될 때 실행되는 코드
        db.execute('''
      CREATE TABLE IF NOT EXISTS tb_idea (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT, 
        motive TEXT,
        content TEXT,
        priorty INTEGER,
        feedback TEXT,
        createdAt INTEGER
      )
      ''');
      },
    );
  }

  // IdeaInfo 데이터 삽입 (insert)m
  Future<int> insertIdeaInfo(IdeaInfo idea) async {
    return await database.insert('tb_idea', idea.toMap());
  }

  // IdeaInfo 데이터 조회 (select)
  Future<List<IdeaInfo>> getAllIdeaInfo() async {
    final List<Map<String, dynamic>> result = await database.query('tb_idea');
    return List.generate(
      result.length,
      (index) {
        return IdeaInfo.fromMap(result[index]);
      },
    );
  }

  // IdeaInfo 데이터 수정 (update)
  Future<int> updateIdeaInfo(IdeaInfo idea) async {
    return await database.update(
      'tb_idea',
      idea.toMap(),
      where: 'id = ?',
      whereArgs: [idea.id],
    );
  }

  // IdeaInfo 데이터 삭제 (delete)
  Future<int> deleteIdeaInfo(IdeaInfo idea) async {
    return await database.delete(
      'tb_idea',
      where: 'id = ?',
      whereArgs: [idea.id],
    );
  }

  // 데이터 베이스 닫기 ( 앱 내에서 데이터베이스 사용을 하지 않게될 경우 닫아줘야함)
  Future<void> closeDatebase() async {
    await database.close();
  }
}
