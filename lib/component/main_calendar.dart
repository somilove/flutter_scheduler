import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:calendar_scheduler/const/colors.dart';

class MainCalendar extends StatelessWidget {
  final OnDaySelected onDaySelected; //날짜 선택 시 실행할 함수
  final DateTime selectedDate; //선택된 날짜

  MainCalendar({super.key,
    required this.onDaySelected,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_kr', //한국어로 언어 변경
      onDaySelected: onDaySelected, //날짜 선택시 실행할 함수
      selectedDayPredicate: (date) => //선택된 날짜를 구분할 로직
        date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day,
        //selectedDayPredicate : 어떤 날짜를 선택된 날짜로 지정할지 결정하는 함수
        //현재 달력에 보이는 모든 날짜를 순회하며 true가 반환되면 선택된 날짜로 표시

        focusedDay: DateTime.now(), //화면에 보여지는 날
        firstDay: DateTime(1800, 1, 1), //첫째 날
        lastDay: DateTime(3000, 1, 1), //마지막 날
        headerStyle: const HeaderStyle( //달력 최상단 스타일
          titleCentered: true,
          formatButtonVisible: false, //달력 크기 선택 옵션 없애기 (일주일치 보여줄지, 2주일치보여줄지,전체를 다 보여줄지 선택하는 옵션)
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16.0,
          ),
        ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false, //기본 날짜 스타일
        defaultDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY_COLOR,
        ),
        weekendDecoration: BoxDecoration( //주말 날짜 스타일
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY_COLOR,
        ),
        selectedDecoration: BoxDecoration( //선택된 날짜 스타일
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: PRIMARY_COLOR,
            width: 1.0,
          ),
        ),
        defaultTextStyle: TextStyle( //기본 글꼴
          fontWeight: FontWeight.w600,
          color: DARK_GREY_COLOR,
        ),
        weekendTextStyle: TextStyle( //주말 글꼴
          fontWeight: FontWeight.w600,
          color: DARK_GREY_COLOR,
        ),
        selectedTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: PRIMARY_COLOR,
        ),
      ),
    );
  }
}
