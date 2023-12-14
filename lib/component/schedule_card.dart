import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  final int startTime;
  final int endTime;
  final String content;

  const ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.content,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: PRIMARY_COLOR,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          //높이를 내부 위젯들의 최대 높이로 설정
          //_Time위젯은 Column위젯을 사용중이기 때문에 ScheduleCard 위젯의 최대 크기만큼 높이를 차지하지만
          //_Content 위젯은 Column 위젯을 사용하지 않기 때문에 최소 크기만 차지하며 세로로 가운데정렬이 되는데
          //이럴 때 _Time위젯과 _Content위젯의 높이를 똑같이 맞춰주려면 IntrinsicHeight 위젯을 사용해 최대 크기를 차지하는 위젯만큼 다른 위젯들 크기를 동일하게 맞춤
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Time( //시작과 종료시간을 보여줄 위젯
                startTime: startTime,
                endTime: endTime,
              ),
              SizedBox(width: 16.0),
              _Content( //일정 내용을 보여줄 위젯
                content: content,
              ),
              SizedBox(width: 16.0),
            ],
          ),
        ),
      ),
    );
  }

}

class _Time extends StatelessWidget {
  final int startTime;
  final int endTime;


  const _Time({
    required this.startTime,
    required this.endTime,
    Key? key,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: PRIMARY_COLOR,
      fontSize: 16.0
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          //숫자가 두 자리수가 안 되면 0으로 채워주기
          '${startTime.toString().padLeft(2, '0')}:00',
          style: textStyle,
        ),
        Text(
          // 숫자가 두 자리수가 안 되면 0으로 채워주기
          '${endTime.toString().padLeft(2, '0')}:00',
          style: textStyle.copyWith(
            fontSize: 10.0,
         ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final String content;

  const _Content({
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded( //최대한 넓게 늘리기
      child: Text(
        content,
      ),
    );
  }
}