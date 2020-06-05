import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'camera.dart';
import 'bndbox.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = ssd;
  int _cameraIndex=0;
  Icon _cameraIcon=Icon(Icons.camera_rear);

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  loadModel() async {
    String res;
   res = await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt");
    print(res);
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.settings),
          ),
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.apps),
          ),
        ],
        leading: Icon(Icons.arrow_left),
        title:Text("Fikido Object Detector"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _cameraIndex==0?Theme.of(context).primaryColor:Colors.grey,
        onPressed: (){
          setState(() {
            _cameraIndex=_cameraIndex==0?1:0;
            print("$_cameraIndex $_cameraIcon");
          });
        },
        child:_cameraIndex==0?_cameraIcon:Icon(Icons.camera_front,),
      ),
      body: _model == ""
          ? onSelect(ssd)
          : Stack(
              children: [
                Camera(
                  widget.cameras,
                  _model,
                  setRecognitions,
                  _cameraIndex
                ),
                BndBox(
                    _recognitions == null ? [] : _recognitions,
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width,
                    _model),
              ],
            ),
    );
  }
}
