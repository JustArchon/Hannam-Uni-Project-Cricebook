import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class NewMessage extends StatefulWidget {
  final String groupId;
  const NewMessage({
    super.key,
    required this.groupId,
  });

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _userEnterMessage = '';

  File? imageFile;
  String? ImageLink;
  bool ImageMessage = false;

  Future getImage() async {
    ImagePicker picker = ImagePicker();

    await picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = const Uuid().v1();
    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");
    var uploadTask = await ref.putFile(imageFile!);
    ImageLink = await uploadTask.ref.getDownloadURL();
    setState(() {
      ImageMessage = true;
    });
  }

  void _sendImage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .collection('GroupChats')
        .add({
      'image': ImageLink,
      'text': _userEnterMessage,
      'time': Timestamp.now(),
      'userID': user.uid,
      'type': 1
    });
    ImageMessage = false;
  }

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .collection('GroupChats')
        .add({
      'text': _userEnterMessage,
      'time': Timestamp.now(),
      'userID': user.uid,
      'type': 0
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            IconButton(
              onPressed: () => getImage(),
              icon: const Icon(Icons.image),
              color: const Color(0xff6DC4DB),
            ),
            Expanded(
              child: TextField(
                maxLines: null,
                controller: _controller,
                decoration: const InputDecoration(labelText: '메시지 전송'),
                onChanged: (value) {
                  setState(() {
                    _userEnterMessage = value;
                  });
                },
              ),
            ),
            IconButton(
              onPressed: ImageMessage == true
                  ? _sendImage
                  : _userEnterMessage.trim().isEmpty
                      ? null
                      : _sendMessage,
              icon: const Icon(Icons.send),
              color: const Color(0xff6DC4DB),
            ),
          ],
        ));
  }
}
