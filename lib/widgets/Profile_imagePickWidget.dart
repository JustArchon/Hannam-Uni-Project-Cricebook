import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePickImage extends StatefulWidget {
  const ProfilePickImage(this.addImageFunc, {super.key});

  final Function(File pickedImage)? addImageFunc;

  @override
  State<ProfilePickImage> createState() => _ProfilePickImageState();
}

class _ProfilePickImageState extends State<ProfilePickImage> {

  File? pickedImage;

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
                    label: const Text('Pick Gallary Profile Image'),
                  ),
                  SizedBox(height: 10,),
                  OutlinedButton.icon(
                    onPressed: () {
                      _shotImage();
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text('Camera shot Profile Image'),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  TextButton.icon(
                    onPressed: () {
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