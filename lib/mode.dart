import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class ModeRadioList<M> extends StatelessWidget {
  //効果音
  final _audio = AudioCache();

  final M value;
  final M groupValue;
  final String leading;

  final ValueChanged<M?> onChanged;

  ModeRadioList({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {_audio.play('koka.mp3'), onChanged(value)},
      child: Container(
        height: 60,
        // padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _customRadioButton,
          ],
        ),
      ),
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return Container(
      //vertical　＝　文字と枠の間の幅
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
      decoration: BoxDecoration(
        color: isSelected ? Colors.transparent : null,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected
              ? Color.fromARGB(255, 255, 0, 221)
              : Color.fromARGB(82, 255, 0, 221),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, right: 5, left: 5),
        child: Text(
          leading,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
      ),
    );
  }
}
