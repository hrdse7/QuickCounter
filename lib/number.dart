import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NumberMode extends StatefulWidget {
  // //MainPageからdataのタイムと入力値を受け取る名前を代入する変数を定義
  String name;
  String timeData;
  //受け取る値を上記の変数に代入
  NumberMode({required this.name, required this.timeData});

  @override
  NumberModeState createState() =>
      NumberModeState(name: name, timeData: timeData);
}

class NumberModeState extends State<NumberMode> {
  //MainPageから受け取る名前を代入する変数を定義
  String name;
  String timeData;
  // //受け取る値を上記の変数に代入
  NumberModeState({required this.name, required this.timeData});

  //タイマー
  Stopwatch s = Stopwatch();
  String _time = '';

  //効果音
  final _audio = AudioCache();

  //randomList宣言
  var randomList;

  //カウント表示
  bool isShowCount = true;
  //GameOver表示
  bool isShowGameOver = false;
  String gameOverText = 'Game Over!';
  //Congratulations表示
  bool isShowCongrats = false;
  String congratsText = 'Congratulations!';
  //ボタン非活性
  bool _isEnabled = true;

  //カウントアップ
  int _counter = 1;
  void _incrementCounter() {
    setState(() {
      _counter++;
      print(_counter);
    });
  }

  //重複のない乱数の関数
  List _shuffle(List items) {
    var random = Random();
    for (var i = items.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);
      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }
    return items;
  }

  //タイマー関数
  void _onTimer(Timer timer) {
    var milliSeconds = ((s.elapsedMilliseconds / 10).floor() % 100);
    if (mounted) {
      setState(() => _time = '${s.elapsed.inSeconds}'.padLeft(2, '0') +
          '.' +
          '$milliSeconds'.padLeft(2, '0'));
    }
  }

  @override
  void initState() {
    super.initState();
    //タイマー
    s.start();
    Timer.periodic(
      const Duration(milliseconds: 10),
      _onTimer,
    );

    //ボタンシャッフル
    final list = List<int>.generate(30, (i) => i + 1);

    randomList = _shuffle(list);
    print(randomList);
  }

  //shared_preferences
  // データのスコアと現在のスコアを比較し最大スコアをデータの書き込み保存
  _setPrefItems(userName) async {
    final prefs = await SharedPreferences.getInstance();

    //データがあるか確認
    var data = prefs.getString('1-$userName') ?? '---';
    // データが無い場合入れる
    if (data == '---') {
      await prefs.setString('1-$userName', _time);
    }

    //タイムのstring型を比較するためにdouble型に変換
    var doubleTimeData =
        double.parse(timeData); //double型のデータタイム(timeData)が出力される。
    var doubleTime = double.parse(_time); //double型のタイム結果(_time)が出力される。

    //データのタイムと比較し早ければデータに入れる
    if (doubleTime < doubleTimeData) {
      await prefs.setString('1-$userName', _time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            // ChangeNotifierProvider<StopWatchModel>(
            // create: (_) => StopWatchModel(),
            // child: Consumer<StopWatchModel>(builder: (context, model, child) {
            // return
            Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: const AssetImage('images/backgrond_shinchan.jpeg'),
        fit: BoxFit.cover,
        //背景画像薄く
        colorFilter: ColorFilter.mode(
          Colors.white.withOpacity(0.5),
          BlendMode.dstATop,
        ),
      )),
      child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, // これで両端に寄せる

                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 85, left: 20),
                    child: Text(
                      _time,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 60,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80, right: 10),
                    child: OutlinedButton(
                      onPressed: () {
                        s.stop();
                        Navigator.pop(context);
                        if (_counter == 31) {
                          //クリアだとデータに保存
                          _setPrefItems(name);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(160, 60),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 255, 0, 221), //枠線の色
                          width: 2,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          'Q U I T',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
            const SizedBox(height: 30),
            Visibility(
              visible: isShowCount,
              child: SizedBox(
                height: 60,
                child: Text(
                  '$_counter',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 55,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isShowGameOver,
              child: SizedBox(
                height: 60,
                child: Text(
                  gameOverText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Color.fromARGB(255, 0, 217, 255),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isShowCongrats,
              child: SizedBox(
                height: 60,
                child: Text(
                  congratsText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                    color: Color.fromARGB(255, 0, 217, 255),
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: SizedBox(
                  height: 630.0,
                  child: GridView.count(
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 6 / 7, //横幅:高さ = 4:5
                      physics: const NeverScrollableScrollPhysics(), //スクロールしない
                      crossAxisCount: 5,
                      children: List.generate(randomList.length, (index) {
                        return _button(
                          randomList[index],
                        ); //randomListの数をreturnする
                      })),
                ))
          ]),
    ));
  }

  Widget _button(number) {
    return GestureDetector(
        child: Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        //ゲームオーバー時ボタン非活性の時の色透明
        color: _isEnabled
            ? const Color.fromARGB(213, 0, 217, 255)
            : const Color.fromARGB(107, 0, 217, 255),

        /// 枠線の色とサイズ
        border: Border.all(
            color: const Color.fromARGB(255, 255, 0, 221), width: 2.0),

        /// 角丸の丸み
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextButton(
        child: Text(
          '$number',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        onPressed: !_isEnabled
            ? null
            : () {
                if (_counter == number) {
                  //効果音
                  _audio.play('peta.mp3');
                  _incrementCounter();
                  if (_counter == 31) {
                    _audio.play('congrats.mp3');
                    isShowCount = false;
                    isShowCongrats = true;
                    _isEnabled = false;
                    //タイマー停止処理
                    s.stop();
                  }
                } else if (_counter != number) {
                  _audio.play('bubu.mp3');
                  isShowCount = false;
                  isShowGameOver = true;
                  _isEnabled = false;
                  //タイマー停止処理
                  s.stop();
                }
              },
      ),
    ));
  }
}
