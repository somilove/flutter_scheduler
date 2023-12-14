import 'package:calendar_scheduler/model/schedule.dart';
import 'package:calendar_scheduler/model/schedule_model.dart';
import 'package:calendar_scheduler/repository/schedule_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleRepository repository; //API 요청 로직을 담은 클래스

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  Map<DateTime, List<ScheduleModel>> cache = {}; //일정 정보를 저장해둘 변수

  ScheduleProvider({
    required this.repository,
  }) : super() {
    getSchedules(date: selectedDate);
  }

  void getSchedules({
    required DateTime date,
  }) async {
    final resp = await repository.getSchedules(date: date); //GET 메서드 보내기

    //선택한 날짜의 일정들 업데이트하기
    cache.update(date, (value) => resp, ifAbsent: () => resp);

    notifyListeners();
  }

  void createSchedule({
    required ScheduleModel schedule,
  }) async {
    final targetDate = schedule.date;

    final uuid = Uuid();

    final tempId = uuid.v4(); //유일한 아이디값 생성
    final newSchedule = schedule.copyWith(
      id: tempId //임시 아이디 지정
    );

    //긍정적 응답 구간, 서버에서 응답을 받기 전에 캐시를 먼저 업데이트
      cache.update(
        targetDate, (value) => [
        ...value,
        newSchedule,
      ]..sort(
            (a, b) => a.startTime.compareTo(
          b.startTime,
        ),
      ),
        ifAbsent: () => [newSchedule],
      );

      notifyListeners();

      try {
        //API 요청
        final savedSchedule = await repository.createSchedule(schedule: schedule);

        cache.update( //서버 응답 기반으로 캐시 업데이트
            targetDate,
            (value) => value.map((e) => e.id == tempId ? e.copyWith(
              id: savedSchedule, //API요청이 성공하면 임시로 저장한 일정의 ID만 서버에서 생성된 값으로 변경해준다
                )
              : e)
            .toList(),
        );
      } catch (e) {
        cache.update( //생성 실패 시 캐시에서도 일정을 삭제해준다
          targetDate,
            (value) => value.where((e) => e.id != tempId).toList(),
        );
      }
      notifyListeners();
  }

  void deleteSchedule({
    required DateTime date,
    required String id,
  }) async {
    final targetSchedule = cache[date]!.firstWhere((e) => e.id == id, //e: element
    ); //삭제할 일정 기억

    cache.update(
        date,
            (value) => value.where((e) => e.id != id).toList(),
        ifAbsent: () => [],
    ); //긍정적 응답(응답 전에 캐시 먼저 업데이트)

    notifyListeners(); //캐시 업데이트 반영

    try {
      await repository.deleteSchedule(id: id); //삭제 함수 실행
    } catch (e) {
      //삭제 실패시 캐시 롤백하기
      cache.update(
        date,
          (value) => [...value, targetSchedule]..sort(
              (a, b) => a.startTime.compareTo(b.startTime,),
          ),
      );
    }
  }

  void changeSelectedDate({
    required DateTime date,
  }) {
    selectedDate = date; //현재 선택된 날짜를 매개변수로 입력받은 날짜로 변경
    notifyListeners();
  }
}