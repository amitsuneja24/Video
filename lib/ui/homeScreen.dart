import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media/Widgets/customButton.dart';
import 'package:path/path.dart' as path;
import 'package:video_player/video_player.dart';

class homeScreen extends StatefulWidget {
  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  File _videoFile;
  final picker = ImagePicker();
  VideoPlayerController _controller;
  bool _loading = false;

  //bool isSuccessful=false;
  @override
  void dispose() {
    if (_controller != null) {
      _controller.setVolume(0.0);
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media'),
      ),
      body: customListview(),
    );
  }

  customListview() {
    return ListView(
      //padding: EdgeInsets.symmetric(horizontal: 10),
      children: <Widget>[
        if (_videoFile == null)
          customButton(
              title: 'Choose Video',
              onPressed: onChooseVideoPressed,
              context: context),
        if (_videoFile == null)
          customButton(
              title: 'Record Video',
              onPressed: onRecordVideoPressed,
              context: context),
        if (_controller != null)
          Container(
            child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  children: <Widget>[
                    VideoPlayer(_controller),
                    InkWell(
                      child: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_circle_outline,
                        size: 80,
                        color: Colors.white,
                      ),
                      onTap: () {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      },
                    )
                  ],
                  alignment: Alignment.center,
                )),
            margin: EdgeInsets.only(top: 10, left: 30, right: 30),
          ),
        if ((_controller != null) && (_loading == false))
          customButton(
              title: 'Upload Video',
              context: context,
              onPressed: onUploadVideo),
        if ((_controller != null) && (_loading == false))
          customButton(title: 'Cancel', context: context, onPressed: onCancel),
        if (_loading == true)
          Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
            margin: EdgeInsets.only(top: 30),
          )
      ],
    );
  }

  Future getVideoByCamera() async {
    final pickedVideo = await picker.getVideo(source: ImageSource.camera);
    setState(() {
      _videoFile = File(pickedVideo.path);
      _controller = VideoPlayerController.file(_videoFile)
        ..addListener(() {
          setState(() {});
        })
        ..initialize()
        ..setLooping(true)
        ..play();
    });
  }

  Future getVideoByGallery() async {
    final pickedVideo = await picker.getVideo(source: ImageSource.gallery);
    setState(() {
      _videoFile = File(pickedVideo.path);
      _controller = VideoPlayerController.file(_videoFile)
        ..addListener(() {
          setState(() {});
        })
        ..initialize()
        ..setLooping(true)
        ..pause();
    });
  }

  void onRecordVideoPressed() {
    getVideoByCamera();
  }

  void onChooseVideoPressed() {
    getVideoByGallery();
  }

  void onCancel() {
    _controller.setVolume(0.0);
    _controller = null;
    _videoFile = null;
    _loading = false;
  }

  void onUploadVideo() {
    uploadVideo();
  }

  Future uploadVideo() async {
    print(path.basename(_videoFile.path));
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('videos/${path.basename(_videoFile.path)}');
    StorageUploadTask storageUploadTask = storageReference.putFile(_videoFile);
    try {
      setState(() {
        _loading = true;
      });
      await storageUploadTask.onComplete;
      onCancel();
      Fluttertoast.showToast(
          msg: 'Video Uploaded Successfully', toastLength: Toast.LENGTH_LONG);
    } catch (err) {
      onCancel();
      Fluttertoast.showToast(
          msg: 'Video Upload Failed', toastLength: Toast.LENGTH_LONG);
    }
  }
}
