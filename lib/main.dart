import 'package:flutter/material.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:get_it/get_it.dart'; //get_it : 의존성 주입을 구현하는 플러그인
import 'package:calendar_scheduler/provider/schedule_provider.dart';
import 'package:calendar_scheduler/repository/schedule_repository.dart';
import 'package:provider/provider.dart';

void main() async {
  //플러터 프레임워크가 준비될 때까지 대기
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(); //intl 패키지 초기화(다국어화)

  // final database = LocalDatabase(); //데이터 베이스 생성
  //
  // GetIt.I.registerSingleton<LocalDatabase>(database);
  //GetIt에 데이터베이스 변수 주입하기
  //database 클래스를 전역에서 사용하기 위함으로서
  //GetIt으로 값을 한번 등록해두면 같은 database변수를 GetIt.I를 통해 프로젝트 어디서든 사용가능

  final repository = ScheduleRepository();
  final scheduleProvider = ScheduleProvider(repository: repository);


  runApp(
    ChangeNotifierProvider(
      create: (_) => scheduleProvider,
      child: MaterialApp(
        home: HomeScreen(),
      ),
    ),
  );
}
