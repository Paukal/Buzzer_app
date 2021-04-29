/*
* Lets Go App
* Paulius Tomas Kalvers
* Account verification logic
* */

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'client.dart';
import 'menu.dart';

class AccVerification extends StatefulWidget {
  @override
  State<AccVerification> createState() => AccVerificationState();
}

class AccVerificationState extends State<AccVerification> {
  var s1 = LoggedInSingleton();

  late File _image;
  bool picked = false;
  String path = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 32,
          ),
          Center(
            child: GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: picked == true
                    ? Container(
                        width: 250,
                        height: 250,
                        child: Image.file(
                          _image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : Column(
                        children: [
                          Center(
                              child: Text(
                            "Select document picture with your name and surname to verify your identity",
                            textAlign: TextAlign.center,
                          )),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(0)),
                            width: 250,
                            height: 250,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      )),
          ),
          picked == true ? Align(
            alignment: Alignment(0, 0),
            child: ElevatedButton(
              onPressed: () {
                sendPhoto(File(path), s1.userId);
                s1.sentVerificationPhoto = true;
              },
              child: Text("Send photo to verify"),
            ),
          ) : Container(),
        ],
      ),
    );
  }

  _imgFromCamera() async {
    ImagePicker picker = new ImagePicker();
    File image = (await picker.getImage(
        source: ImageSource.camera, imageQuality: 50)) as File;

    setState(() {
      _image = image;
      picked = true;
    });
  }

  _imgFromGallery() async {
    ImagePicker picker = new ImagePicker();
    PickedFile? image =
        (await picker.getImage(source: ImageSource.gallery, imageQuality: 50));

    if (image != null) {
      path = image.path;

      setState(() {
        _image = File(path);
        picked = true;
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
