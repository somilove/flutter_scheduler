import 'package:calendar_scheduler/model/schedule.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

//private 값까지 불러올 수 있음
part 'drift_database.g.dart'; //part파일 지정

@DriftDatabase(tables: [Schedules])
class LocalDatabase extends _$LocalDatabase {
  //Code Generation 으로 생성할 부모클래스, 클래스명 앞에 '_$'룰 붙여 작성
  //terminal 에서 fluuter pub run build_runner build 명령어로 코드 생성 진행
  //코드 생성을 실행하면 테이블과 관련된 쿼리를 작성하는데 필요한 기능이 모두 생성됨
  // LocalDatabase(super.e);
  LocalDatabase() : super(_openConnection());

  Stream<List<Schedule>> watchSchedules(DateTime date) =>
      //대이터를 조회하고 변화 감지
  (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
    //드리프트의 SELECT 기능 두가지 - get(), watch()
    //watch() 함수는 데이터가 업데이트 될때마다 새로운 값을 반영해줘야 할 때 사용됨

  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();
    //selet() 함수에서 watch()함수와 get()함수를 실행하듯이
    //delete() 함수에는 go()함수를 실행해주어야 삭제가 완료됨

  @override
  int get schemaVersion => 1;
  //schemaVersion : 필수로 지정해야 하는 값으로
  //기본적으로 1부터 시작해 테이블의 변화가 있을 때마다 1씩 올려주어 테이블 구조가 변경된 걸 드리프트에 인지시켜주는 기능
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {

    //데이터베이스 파일 저장할 폴더
    //path_provider 패키지에서 제공하는 getApplicatonDocumentsDirectory()함수를 사용하면
    //현재 앱에 배정된 폴더의 경로를 받을 수 있다
    //해당 폴더에 db.sqlite라는 파일을 데이터베이스 파일로 지정
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}