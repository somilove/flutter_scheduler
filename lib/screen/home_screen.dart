import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc( //선택된 날짜를 관리할 변수
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton( //새 일정 버튼
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet( //BottomSheet 열기
              context: context,
              isDismissible: true, //배경 탭했을 때 BottomSheet 닫기
              builder: (_) => ScheduleBottomSheet(),
              isScrollControlled: true,
            //showModalBottomSheet()함수는 기본적으로 최대 높이를 화면의 반으로 규정하지만 isScrollControlled:true로 설정하면 최대 높이를 화면 전체로 변경 가능
            //ScheduleBottomSheet에서 텍스트필드를 선택할 경우 키보드가 보이는 만틈 ScheduleBottomSheet 위젯이 위로 이동됨
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(
                selectedDate: selectedDate,
                onDaySelected: onDaySelected,
            ),
            const SizedBox(height: 8.0),
            TodayBanner(
                selectedDate: selectedDate,
                count: 0,
            ),
            const SizedBox(height: 8.0),
            const ScheduleCard(
              startTime: 12,
              endTime: 14,
              content: '프로그래밍 공부',
            )
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}