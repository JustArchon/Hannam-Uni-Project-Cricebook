import 'package:flutter/material.dart';
import 'MainPage/CircleMainPage.dart';
import 'Group/CircleMainGroup.dart';
import 'Profile/CircleMainProfile.dart';

class CircleMain extends StatefulWidget {
  const CircleMain({Key? key}) : super(key: key);
   @override
   State<CircleMain> createState() => CircleMainState();
}
  
class CircleMainState extends State<CircleMain>{
  int selectedIndex = 0; // 선택된 페이지의 인덱스 넘버 초기화

  final List<Widget> _widgetOptions = <Widget>[
    CircleMainPage(),
    CircleMainGroup(),
    CircleMainProfile(),
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
          icon: Icon(Icons.home),
          label: '메인화면',
          ),
          BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: '그룹',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
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

  