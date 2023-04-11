import 'package:flutter/material.dart';
import 'Group/CircleGroupMain.dart';

class CircleMain extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Circle Book Main')),
      body: Container()
    );
  }
}
class CircleMainPage extends StatefulWidget {
  const CircleMainPage({Key? key}) : super(key: key);
   @override
   State<CircleMainPage> createState() => CircleMainPageState();
}
  
class CircleMainPageState extends State<CircleMainPage>{
  int selectedIndex = 0; // 선택된 페이지의 인덱스 넘버 초기화

  final List<Widget> _widgetOptions = <Widget>[
    CircleGroupMain(),
  ];

  void onItemTapped(int index) { // 탭을 클릭했을떄 지정한 페이지로 이동
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
          icon: Icon(Icons.text_snippet),
          label: '메인화면',
          ),
          BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '그룹',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '프로필'
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
  @override
  void initState() {
    //해당 클래스가 호출되었을떄
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }
}

  