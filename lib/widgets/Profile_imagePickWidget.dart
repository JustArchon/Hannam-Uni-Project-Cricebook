import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePickImage extends StatefulWidget {
  const ProfilePickImage(this.addImageFunc, {super.key});

  final Function(File pickedImage)? addImageFunc;

  @override
  State<ProfilePickImage> createState() => _ProfilePickImageState();
}

class _ProfilePickImageState extends State<ProfilePickImage> {

  File? pickedImage;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void _pickImage() async{
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 150
      );
      
      setState(() {
        if(pickedImageFile != null){
        pickedImage = File(pickedImageFile.path);
        }
      });
  if(pickedImageFile != null){
    widget.addImageFunc!(pickedImage!);
   }
  }

  void _shotImage() async{
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxHeight: 150
      );
      
      setState(() {
        if(pickedImageFile != null){
        pickedImage = File(pickedImageFile.path);
        }
      });
  if(pickedImageFile != null){
    widget.addImageFunc!(pickedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
              padding: EdgeInsets.only(top:10),
              width: 150,
              height: 300,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xff6DC4DB),
                    backgroundImage: pickedImage !=null ? FileImage(pickedImage!) : null,
                  ),
                  SizedBox(height: 10,),
                  OutlinedButton.icon(
                    onPressed: () {
                      _pickImage();
                    },
                    icon: const Icon(Icons.image),
                    label: const Text('프로필 이미지 선택하기'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      _shotImage();
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text('프로필 사진 촬영하기'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final newUser = FirebaseAuth.instance.currentUser;
                        ByteData imageByteData = await rootBundle.load('assets/icons/usericon.png');
                        Uint8List imageUint8List = imageByteData.buffer.asUint8List(imageByteData.offsetInBytes, imageByteData.lengthInBytes);
                        final tempDir = await getTemporaryDirectory();
                        File file = await File('${tempDir.path}/image.png').create();
                        file.writeAsBytesSync(imageUint8List);
                        final refImage = FirebaseStorage.instance.ref()
                        .child('UserProfile')
                        .child('${newUser!.uid}.png');
                        await refImage.putFile(file);
                        final url = await refImage.getDownloadURL();
                        firestore.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).update(
                        {
                          "UserProfileImage": url
                        });
                         Navigator.pop(context);
                    },
                    icon: const Icon(Icons.person),
                    label: const Text('기본 프로필 지정하기'),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      if(pickedImage != null){
                      final newUser = FirebaseAuth.instance.currentUser;
                      final refImage = FirebaseStorage.instance.ref()
                                    .child('UserProfile')
                                    .child('${newUser!.uid}.png');
                                    refImage.putFile(pickedImage!);
                                    await refImage.getDownloadURL();
                                    final url = await refImage.getDownloadURL();
                      firestore.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).update(
                        {
                          "UserProfileImage": url
                        });
                      }
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.done),
                    label: Text('Apply'),
                  ),
                ],
              ),
            );
  }
}