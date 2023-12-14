import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label; //텍스트 필드 제목
  final bool isTime; //시간 선택하는 텍스트 필드인지 여부
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;

  const CustomTextField({
    required this.label,
    required this.isTime,
    required this.onSaved,
    required this.validator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        //TextField : 각 텍스트 필드가 독립된 형태일 때 많이 사용
        //TextFormField : 여러개의 텍스트 필드를 하나의 폼으로 제어할 때 사용
        Expanded(
          flex: isTime ? 0 : 1,
            child: TextFormField(
              onSaved: onSaved,
              validator: validator,
              cursorColor: Colors.grey,
              maxLines: isTime  ? 1 : null, //시간을 입력할 땐 한 줄만 입력 / 아닐 경우 줄 개수에 제한을 두지 않음 = null
              expands: !isTime, //expands : 텍스트 필드를 부모 위젯 크기만큼 세로로 늘릴지 여부 / 기본값은 false로 최소 크기만 차지/ true로 입력하면 부모의 위젯 크기만큼 텍스트 필드를 늘릴 수 있음.
              keyboardType: isTime ? TextInputType.number : TextInputType.multiline, //keyboardType 매개변수는 핸드폰에서 보여주는 키보드만 제한할 수 있음
              inputFormatters: isTime ? [FilteringTextInputFormatter.digitsOnly] : [],
              //inputFormatters은 특정 입력 자체를 제한할 수 있음
              // 블루투스키보드나 보안키보드와 같은 커스텀 구현된 키보드 대응 가능
              // 시간 관련 텍스트필드는 숫자만 입력하도록 제한
              decoration: InputDecoration(
                border: InputBorder.none, //테두리 삭제
                filled: true, //배경색 지정하겠다는 선언
                fillColor: Colors.grey[300], //배경색
                suffixText: isTime ? '시' : null, //시간관련 텍스트 필드는 접미사 추가
              ),
            )),
      ],
    );
  }
}