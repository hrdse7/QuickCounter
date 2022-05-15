import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lowercase.dart';
import 'mode.dart';
import 'number.dart';
import 'uppercase.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //googleFont
        theme: ThemeData(
          textTheme: GoogleFonts.margarineTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        //Slow Mode"バナーを非表示
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          //キーボード表示の時エラーを出さない
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: const AssetImage('images/backgrond_shinchan.jpeg'),
              fit: BoxFit.cover,
              //背景画像薄く
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.2),
                BlendMode.dstATop,
              ),
            )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
                MainPage(),
              ],
            ),
          ),
        ));
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  //効果音
  final _audio = AudioCache();

  //TextEditingController
  final _controller = TextEditingController();

  //TextFieldの値を代入する変数を定義
  String inputName = '';

  //データの入る変数を定義
  String timeScore1 = '';
  String timeScore2 = '';
  String timeScore3 = '';

  //モード選択のgroupValueの変数定義
  int _value = 1;

  //書き込まれているデータのスコアを表示する変数定義
  String timerViewScore1 = '---';
  String timerViewScore2 = '---';
  String timerViewScore3 = '---';

  //表示/非表示
  bool isShow = false;
  bool isHide = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    final prefs = await SharedPreferences.getInstance();

    _controller.text = prefs.getString('currentUser')!;
    _value = prefs.getInt('mode')!;

    //currentUserを_getPrefItemsのkyeの名前に格納
    inputName = _controller.text;
    //inputNameに_getDataに保存されている名前入れる
    _getPrefItems(inputName);

    if (_controller.text != null) {
      isShow = true;
    }
  }

  //保存
  Future<void> _setData(inputName) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('currentUser', inputName);
    prefs.setInt('mode', _value);
  }

  //保存されているデータを読み込んで、にセットする
  _getPrefItems(userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 以下の「inputname」がキー名。見つからなければ空文字を返す
    setState(() {
      timeScore1 = prefs.getString('1-$userName') ?? '---';
      timeScore2 = prefs.getString('2-$userName') ?? '---';
      timeScore3 = prefs.getString('3-$userName') ?? '---';
    });

    print(timeScore1);
    print(timeScore2);
    print(timeScore3);

    timerViewScore1 = timeScore1;
    timerViewScore2 = timeScore2;
    timerViewScore3 = timeScore3;

    if (inputName.isEmpty) {
      isShow = false;
      isHide = true;
      timerViewScore1 = '---';
      timerViewScore2 = '---';
      timerViewScore3 = '---';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  const Text('1 - 30',
                      style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 255, 0, 221),
                        fontWeight: FontWeight.bold,
                      )),
                  Text(timerViewScore1,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 0, 217, 255),
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  const Text('A - Z',
                      style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 255, 0, 221),
                        fontWeight: FontWeight.bold,
                      )),
                  Text(timerViewScore2,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 0, 217, 255),
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  const Text('a - z',
                      style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 255, 0, 221),
                        fontWeight: FontWeight.bold,
                      )),
                  Text(timerViewScore3,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 0, 217, 255),
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 80),
        child: Text(
          'Quick\nCounter',
          style: TextStyle(
              fontSize: 75, color: Colors.black, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(
        width: 290,
        height: 50,
        child: TextFormField(
            //テキスト中央揃え
            textAlign: TextAlign.center,
            //テキストのサイズ
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 217, 255),
              fontSize: 25,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 5, /*数値*/
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),

              //初期値の文字
              hintText: "Enter Nickname...",
              hintStyle: TextStyle(
                fontSize: 23.0,
                color: Color.fromARGB(103, 0, 217, 255),
              ),

              //TextFormFieldの下の枠線を削除
              border: InputBorder.none,

              //「fillColor引数」で背景色
              fillColor: Colors.white,
              //「filled引数」に「true」
              filled: true,
            ),

            //TextEditingController
            controller: _controller,

            //入力された値時データを取得
            onChanged: (text) {
              inputName = text;
              // ignore: prefer_is_empty
              if (inputName.length >= 0) {
                isShow = true;
                isHide = false;
                //入力値のデータを格納
                _setData(inputName);
                //データ取得
                _getPrefItems(inputName);
              }
            }),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Visibility(
            visible: isShow,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 28, left: 20),
              child: ModeRadioList<int>(
                  value: 1,
                  groupValue: _value,
                  leading: '1  -  30',
                  onChanged: (value) => setState(() {
                        _value = value!;
                        _setData(inputName);
                      })),
            ),
          ),
          Visibility(
            visible: isShow,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 28, left: 5, right: 5),
              child: ModeRadioList<int>(
                  value: 2,
                  groupValue: _value,
                  leading: 'A  -  Z',
                  onChanged: (value) => setState(() {
                        _value = value!;
                        _setData(inputName);
                      })),
            ),
          ),
          Visibility(
            visible: isShow,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 28, right: 20),
              child: ModeRadioList<int>(
                  value: 3,
                  groupValue: _value,
                  leading: 'a  -  z',
                  onChanged: (value) => setState(() {
                        _value = value!;
                        _setData(inputName);
                      })),
            ),
          ),
        ],
      ),
      Visibility(
        visible: isShow,
        child: Container(
          margin:
              const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 80),
          child: OutlinedButton(
            onPressed: () {
              //効果音
              _audio.play('start.mp3');

              if (_value == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        //表示するページ(ウィジェット)を指定する
                        builder: (context) => NumberMode(
                            name: inputName,
                            timeData: timeScore1))).then((value) {
                  //画面が戻ってきたら最大スコアを表示
                  _getPrefItems(inputName);
                });
              } else if (_value == 2) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        //表示するページ(ウィジェット)を指定する
                        builder: (context) => UpperCaseMode(
                            name: inputName,
                            timeData: timeScore2))).then((value) {
                  //画面が戻ってきたら最大スコアを表示
                  _getPrefItems(inputName);
                });
              } else if (_value == 3) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        //表示するページ(ウィジェット)を指定する
                        builder: (context) => LowerCaseMode(
                            name: inputName,
                            timeData: timeScore3))).then((value) {
                  //画面が戻ってきたら最大スコアを表示
                  _getPrefItems(inputName);
                });
              }
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(350, 70),
              side: const BorderSide(
                color: Color.fromARGB(255, 255, 0, 221), //枠線の色
                width: 2,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                'P L A Y !',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
