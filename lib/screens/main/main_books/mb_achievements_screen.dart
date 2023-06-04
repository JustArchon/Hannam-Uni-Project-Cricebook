import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen(this.userID, {super.key});
  final String userID;

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: const Color(0xff6DC4DB),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "업적 리스트",
          style: TextStyle(
            fontSize: 24,
            fontFamily: "Ssurround",
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
            //future: _getGroupData(),
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userID)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  //List<dynamic>? ca = snapshot.data!['mounted_Achievements'];
                  int Bookcount = snapshot.data!['readingbookcount'];
                  int GroupLeaderCount = snapshot.data!['groupleadercount'];
                  int CertifiCount = snapshot.data!['certificount'];
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                                Column(children: [
                                              const Text("독서 횟수 업적"),
                                              ListTile(
                                                leading: Image.asset(
                                                'assets/medal/readcount1medal.png'),
                                                title: const Text(
                                                    '그룹 독서 1회 완료'),
                                                subtitle: const Text(
                                                    '그룹 독서 1회를 완료하세요!'),
                                                trailing: CircularPercentIndicator(
                                                            radius: 28.0,
                                                            lineWidth: 7.0,
                                                            animation: true,
                                                            percent: Bookcount > 1 ? 1 : Bookcount/ 1,
                                                            center: Text(
                                                            Bookcount > 1 ? '100%' : '${(Bookcount / 1)*100}%',
                                                      style:
                                                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                                                      ),
                                                      circularStrokeCap: CircularStrokeCap.round,
                                                      progressColor: const Color(0xff6DC4DB),
                                                  ),
                                                onTap: () {
                                                  if(Bookcount >= 1){
                                                    var newlist = snapshot.data!['mounted_Achievements'];
                                                    if(snapshot.data!['complete_Achievements'].contains('readcount1') == false)
                                                    {
                                                      var comlist = snapshot.data!['complete_Achievements'];
                                                      comlist.add('readcount1');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "complete_Achievements": comlist,
                                                    });
                                                    }
                                                    if(snapshot.data!['mounted_Achievements'].contains('readcount1medal')){
                                                      newlist.remove('readcount1medal');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "mounted_Achievements": newlist,
                                                    });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('정상적으로 업적 뱃지 제거가 완료되었습니다.'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                    }else{
                                                      newlist.add('readcount1medal');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "mounted_Achievements": newlist,
                                                    });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('정상적으로 업적 뱃지 추가가 완료되었습니다.'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                    }
                                                  }else{
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('아직 획득하지 못한 뱃지입니다. 목표를 달성후 장착해보세요!'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                  }
                                                },
                                              ),
                                                ListTile(
                                                leading: Image.asset(
                                                        'assets/medal/readcount5medal.png'),
                                                title: const Text(
                                                    '그룹 독서 5회 완료'),
                                                subtitle: const Text(
                                                    '그룹 독서 5회를 완료하세요!'),
                                                trailing: CircularPercentIndicator(
                                                            radius: 28.0,
                                                            lineWidth: 7.0,
                                                            animation: true,
                                                            percent: Bookcount > 5 ? 1 : Bookcount / 5,
                                                            center: Text(
                                                            Bookcount > 5 ? '100%' : '${(Bookcount / 5)*100}%',
                                                      style:
                                                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                                                      ),
                                                      circularStrokeCap: CircularStrokeCap.round,
                                                      progressColor: const Color(0xff6DC4DB),
                                                  ),
                                                onTap: () {
                                                  if(Bookcount >= 5){
                                                    var newlist = snapshot.data!['mounted_Achievements'];
                                                    if(snapshot.data!['complete_Achievements'].contains('readcount5') == false)
                                                    {
                                                      var comlist = snapshot.data!['complete_Achievements'];
                                                      comlist.add('readcount5');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "complete_Achievements": comlist,
                                                    });
                                                    }
                                                    if(snapshot.data!['mounted_Achievements'].contains('readcount5medal')){
                                                      newlist.remove('readcount5medal');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "mounted_Achievements": newlist,
                                                    });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('정상적으로 업적 뱃지 제거가 완료되었습니다.'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                    }else{
                                                      newlist.add('readcount5medal');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "mounted_Achievements": newlist,
                                                    });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('정상적으로 업적 뱃지 추가가 완료되었습니다.'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                    }
                                                  }else{
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('아직 획득하지 못한 뱃지입니다. 목표를 달성후 장착해보세요!'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                  }
                                                },
                                              ),
                                              ListTile(
                                                leading: Image.asset(
                                                        'assets/medal/readcount10medal.png'),
                                                title: const Text(
                                                    '그룹 독서 10회 완료'),
                                                subtitle: const Text(
                                                    '그룹 독서 10회를 완료하세요!'),
                                                trailing: CircularPercentIndicator(
                                                            radius: 28.0,
                                                            lineWidth: 7.0,
                                                            animation: true,
                                                            percent: Bookcount > 10 ? 1 : Bookcount / 10,
                                                            center: Text(
                                                            Bookcount > 10 ? '100%' : '${(Bookcount / 10)*100}%',
                                                      style:
                                                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                                                      ),
                                                      circularStrokeCap: CircularStrokeCap.round,
                                                      progressColor: const Color(0xff6DC4DB),
                                                  ),
                                                onTap: () {
                                                  if(Bookcount >= 10){
                                                    var newlist = snapshot.data!['mounted_Achievements'];
                                                    if(snapshot.data!['complete_Achievements'].contains('readcount10') == false)
                                                    {
                                                      var comlist = snapshot.data!['complete_Achievements'];
                                                      comlist.add('readcount10');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "complete_Achievements": comlist,
                                                    });
                                                    }
                                                    if(snapshot.data!['mounted_Achievements'].contains('readcount10medal')){
                                                      newlist.remove('readcount10medal');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "mounted_Achievements": newlist,
                                                    });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('정상적으로 업적 뱃지 제거가 완료되었습니다.'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                    }else{
                                                      newlist.add('readcount10medal');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "mounted_Achievements": newlist,
                                                    });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('정상적으로 업적 뱃지 추가가 완료되었습니다.'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                    }
                                                  }else{
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('아직 획득하지 못한 뱃지입니다. 목표를 달성후 장착해보세요!'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                  }
                                                },
                                              ),
                                              Container( height:1.0,
                                              width:500.0,
                                              color:Colors.black,),
                                              const Text("그룹장 횟수 업적"),
                                              ListTile(
                                                leading: Image.asset(
                                                        'assets/medal/groupleadercount1medal.png'),
                                                title: const Text(
                                                    '그룹 독서장 1회 완료'),
                                                subtitle: const Text(
                                                    '그룹장을 맡아 그룹 독서 1회를 완료하세요!'),
                                                trailing: CircularPercentIndicator(
                                                            radius: 28.0,
                                                            lineWidth: 7.0,
                                                            animation: true,
                                                            percent: GroupLeaderCount > 1 ? 1 : GroupLeaderCount / 1,
                                                            center: Text(
                                                            GroupLeaderCount > 1 ? '100%' : '${(GroupLeaderCount / 1)*100}%',
                                                      style:
                                                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                                                      ),
                                                      circularStrokeCap: CircularStrokeCap.round,
                                                      progressColor: const Color(0xff6DC4DB),
                                                  ),
                                                onTap: () {
                                                  if(GroupLeaderCount >= 1){
                                                    var newlist = snapshot.data!['mounted_Achievements'];
                                                    if(snapshot.data!['complete_Achievements'].contains('groupleadercount1') == false)
                                                    {
                                                      var comlist = snapshot.data!['complete_Achievements'];
                                                      comlist.add('groupleadercount1');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "complete_Achievements": comlist,
                                                    });
                                                    }
                                                    if(snapshot.data!['mounted_Achievements'].contains('groupleadercount1medal')){
                                                      newlist.remove('groupleadercount1medal');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "mounted_Achievements": newlist,
                                                    });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('정상적으로 업적 뱃지 제거가 완료되었습니다.'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                    }else{
                                                      newlist.add('groupleadercount1medal');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "mounted_Achievements": newlist,
                                                    });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('정상적으로 업적 뱃지 추가가 완료되었습니다.'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                    }
                                                  }else{
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('아직 획득하지 못한 뱃지입니다. 목표를 달성후 장착해보세요!'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                  }
                                                },
                                              ),
                                              ListTile(
                                                leading: Image.asset(
                                                        'assets/medal/groupleadercount5medal.png'),
                                                title: const Text(
                                                    '그룹 독서장 5회 완료'),
                                                subtitle: const Text(
                                                    '그룹장을 맡아 그룹 독서 5회를 완료하세요!'),
                                                trailing: CircularPercentIndicator(
                                                            radius: 28.0,
                                                            lineWidth: 7.0,
                                                            animation: true,
                                                            percent: GroupLeaderCount > 5 ? 1 : GroupLeaderCount / 5,
                                                            center: Text(
                                                            GroupLeaderCount > 5 ? '100%' : '${(GroupLeaderCount / 5)*100}%',
                                                      style:
                                                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                                                      ),
                                                      circularStrokeCap: CircularStrokeCap.round,
                                                      progressColor: const Color(0xff6DC4DB),
                                                  ),
                                                onTap: () {
                                                  if(GroupLeaderCount >= 5){
                                                    var newlist = snapshot.data!['mounted_Achievements'];
                                                    if(snapshot.data!['complete_Achievements'].contains('groupleadercount5') == false)
                                                    {
                                                      var comlist = snapshot.data!['complete_Achievements'];
                                                      comlist.add('groupleadercount5');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "complete_Achievements": comlist,
                                                    });
                                                    }
                                                    if(snapshot.data!['mounted_Achievements'].contains('groupleadercount5medal')){
                                                      newlist.remove('groupleadercount5medal');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "mounted_Achievements": newlist,
                                                    });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('정상적으로 업적 뱃지 제거가 완료되었습니다.'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                    }else{
                                                      newlist.add('groupleadercount5medal');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "mounted_Achievements": newlist,
                                                    });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('정상적으로 업적 뱃지 추가가 완료되었습니다.'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                    }
                                                  }else{
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('아직 획득하지 못한 뱃지입니다. 목표를 달성후 장착해보세요!'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                  }
                                                },
                                              ),
                                              ListTile(
                                                leading: Image.asset(
                                                        'assets/medal/groupleadercount10medal.png'),
                                                title: const Text(
                                                    '그룹 독서장 10회 완료'),
                                                subtitle: const Text(
                                                    '그룹장을 맡아 그룹 독서 10회를 완료하세요!'),
                                                trailing: CircularPercentIndicator(
                                                            radius: 28.0,
                                                            lineWidth: 7.0,
                                                            animation: true,
                                                            percent: GroupLeaderCount > 10 ? 1 : GroupLeaderCount / 10,
                                                            center: Text(
                                                            GroupLeaderCount > 10 ? '100%' : '${(GroupLeaderCount / 10)*100}%',
                                                      style:
                                                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                                                      ),
                                                      circularStrokeCap: CircularStrokeCap.round,
                                                      progressColor: const Color(0xff6DC4DB),
                                                  ),
                                                onTap: () {
                                                  if(GroupLeaderCount >= 10){
                                                    var newlist = snapshot.data!['mounted_Achievements'];
                                                    if(snapshot.data!['complete_Achievements'].contains('groupleadercount10') == false)
                                                    {
                                                      var comlist = snapshot.data!['complete_Achievements'];
                                                      comlist.add('groupleadercount10');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "complete_Achievements": comlist,
                                                    });
                                                    }
                                                    if(snapshot.data!['mounted_Achievements'].contains('groupleadercount10medal')){
                                                      newlist.remove('groupleadercount10medal');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "mounted_Achievements": newlist,
                                                    });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('정상적으로 업적 뱃지 제거가 완료되었습니다.'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                    }else{
                                                      newlist.add('groupleadercount10medal');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "mounted_Achievements": newlist,
                                                    });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('정상적으로 업적 뱃지 추가가 완료되었습니다.'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                    }
                                                  }else{
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('아직 획득하지 못한 뱃지입니다. 목표를 달성후 장착해보세요!'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                  }
                                                },
                                              ),
                                              Container( height:1.0,
                                              width:500.0,
                                              color:Colors.black,),
                                              const Text("독서인증 횟수 업적"),
                                              ListTile(
                                                leading: Image.asset(
                                                        'assets/medal/certificount1medal.png'),
                                                title: const Text(
                                                    '그룹 독서 인증 1회 완료'),
                                                subtitle: const Text(
                                                    '그룹 독서 인증을 1회를 완료하세요!'),
                                                trailing: CircularPercentIndicator(
                                                            radius: 28.0,
                                                            lineWidth: 7.0,
                                                            animation: true,
                                                            percent: CertifiCount > 1 ? 1 : CertifiCount / 1,
                                                            center: Text(
                                                            CertifiCount > 1 ? '100%' : '${(CertifiCount / 1)*100}%',
                                                      style:
                                                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                                                      ),
                                                      circularStrokeCap: CircularStrokeCap.round,
                                                      progressColor: const Color(0xff6DC4DB),
                                                  ),
                                                onTap: () {
                                                  if(CertifiCount >= 1){
                                                    var newlist = snapshot.data!['mounted_Achievements'];
                                                    if(snapshot.data!['complete_Achievements'].contains('certificount1') == false)
                                                    {
                                                      var comlist = snapshot.data!['complete_Achievements'];
                                                      comlist.add('certificount1');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "complete_Achievements": comlist,
                                                    });
                                                    }
                                                    if(snapshot.data!['mounted_Achievements'].contains('certificount1medal')){
                                                      newlist.remove('certificount1medal');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "mounted_Achievements": newlist,
                                                    });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('정상적으로 업적 뱃지 제거가 완료되었습니다.'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                    }else{
                                                      newlist.add('certificount1medal');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "mounted_Achievements": newlist,
                                                    });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('정상적으로 업적 뱃지 추가가 완료되었습니다.'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                    }
                                                  }else{
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('아직 획득하지 못한 뱃지입니다. 목표를 달성후 장착해보세요!'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                  }
                                                },
                                              ),
                                              ListTile(
                                                leading: Image.asset(
                                                        'assets/medal/certificount5medal.png'),
                                                title: const Text(
                                                    '그룹 독서 인증 5회 완료'),
                                                subtitle: const Text(
                                                    '그룹 독서 인증을 5회를 완료하세요!'),
                                                trailing: CircularPercentIndicator(
                                                            radius: 28.0,
                                                            lineWidth: 7.0,
                                                            animation: true,
                                                            percent: CertifiCount > 5 ? 1 : CertifiCount / 5,
                                                            center: Text(
                                                            CertifiCount > 5 ? '100%' : '${(CertifiCount / 5)*100}%',
                                                      style:
                                                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                                                      ),
                                                      circularStrokeCap: CircularStrokeCap.round,
                                                      progressColor: const Color(0xff6DC4DB),
                                                  ),
                                                onTap: () {
                                                  if(CertifiCount >= 5){
                                                    var newlist = snapshot.data!['mounted_Achievements'];
                                                    if(snapshot.data!['complete_Achievements'].contains('certificount5') == false)
                                                    {
                                                      var comlist = snapshot.data!['complete_Achievements'];
                                                      comlist.add('certificount5');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "complete_Achievements": comlist,
                                                    });
                                                    }
                                                    if(snapshot.data!['mounted_Achievements'].contains('certificount5medal')){
                                                      newlist.remove('certificount5medal');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "mounted_Achievements": newlist,
                                                    });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('정상적으로 업적 뱃지 제거가 완료되었습니다.'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                    }else{
                                                      newlist.add('certificount5medal');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "mounted_Achievements": newlist,
                                                    });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('정상적으로 업적 뱃지 추가가 완료되었습니다.'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                    }
                                                  }else{
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('아직 획득하지 못한 뱃지입니다. 목표를 달성후 장착해보세요!'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                  }
                                                },
                                              ),
                                              ListTile(
                                                leading: Image.asset(
                                                        'assets/medal/certificount10medal.png'),
                                                title: const Text(
                                                    '그룹 독서 인증 10회 완료'),
                                                subtitle: const Text(
                                                    '그룹 독서 인증을 10회를 완료하세요!'),
                                                trailing: CircularPercentIndicator(
                                                            radius: 28.0,
                                                            lineWidth: 7.0,
                                                            animation: true,
                                                            percent: CertifiCount > 10 ? 1 : CertifiCount / 10,
                                                            center: Text(
                                                            CertifiCount > 10 ? '100%' : '${(CertifiCount / 10)*100}%',
                                                      style:
                                                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                                                      ),
                                                      circularStrokeCap: CircularStrokeCap.round,
                                                      progressColor: const Color(0xff6DC4DB),
                                                  ),
                                                onTap: () {
                                                  if(CertifiCount >= 10){
                                                    var newlist = snapshot.data!['mounted_Achievements'];
                                                    if(snapshot.data!['complete_Achievements'].contains('certificount10') == false)
                                                    {
                                                      var comlist = snapshot.data!['complete_Achievements'];
                                                      comlist.add('certificount10');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "complete_Achievements": comlist,
                                                    });
                                                    }
                                                    if(snapshot.data!['mounted_Achievements'].contains('certificount10medal')){
                                                      newlist.remove('certificount10medal');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "mounted_Achievements": newlist,
                                                    });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('정상적으로 업적 뱃지 제거가 완료되었습니다.'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                    }else{
                                                      newlist.add('certificount10medal');
                                                      FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "mounted_Achievements": newlist,
                                                    });
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('정상적으로 업적 뱃지 추가가 완료되었습니다.'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                    }
                                                  }else{
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                        content: Text('아직 획득하지 못한 뱃지입니다. 목표를 달성후 장착해보세요!'),
                                                        backgroundColor: Colors.blue,
                                                        ),
                                                      );
                                                  }
                                                },
                                              ),
                                ]
                                )
                                ]
                                ),
                        );
                }
              }
              return const Center(
                child: Text('데이터를 불러올 수 없습니다.'),
          );
        }
      )
    );
  }
}

                  