/*
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

void main() => runApp(MyApp());

const String ssd="SDD MobileNet";
const String yolo="Tiny YOLOv2";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Detector(),
    );
  }
}

class Detector extends StatefulWidget {
  @override
  _DetectorState createState() => _DetectorState();
}

class _DetectorState extends State<Detector> {
  String _model=ssd;
  File _image;

  double _imageWidth;
  double _imageHeight;
  bool _busy=false;

  List _recognitions;

  @override
  void initState(){
    super.initState();
    _busy=true;
    loadModel().then((val){
      setState(() {
        _busy=false;
      });
    });
  }

  loadModel()async{
    Tflite.close();
    try{
      String res;
      if(_model==yolo){
        res=await Tflite.loadModel(
          model: 'assets/tflite/yolov2_tiny.tflite',
          labels: 'assets/tflite/yolov2_tiny.txt'
        );
      }
      else{
        res=await Tflite.loadModel(
          model: 'assets/tflite/ssd_mobilenet.tflite',
          labels: 'assets/tflite/ssd_mobilenet.txt'
        );
      }
      print(res);
    }on PlatformException{
      print("Failed toload Model");
    }
  }

  selectFromImagePicker() async{
    var image=await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image==null)return;
    setState(() {
      _busy=true;
    });
    predictImage(image);
  }

  predictImage(File image) async{
     if(image==null)return;
     if(_model==yolo){
       await yolo2Tiny(image);
     }
     else{
       await ssdMobilenet(image);
     }

     FileImage(image).resolve(ImageConfiguration()).addListener(
       ImageStreamListener((ImageInfo info,bool _){
         setState(() {
           _imageWidth=info.image.width.toDouble();
           _imageHeight=info.image.height.toDouble();
         });
       })
     );

     setState(() {
       _image=image;
       _busy=false;
     });
  }

  yolo2Tiny(File image) async{
    var recognition=await Tflite.detectObjectOnImage(
      path: image.path,
      model: "YOLO",
      threshold: 0.3,
      numResultsPerClass: 1,
      imageStd: 255.0,
      imageMean: 0.0,
    );

    setState(() {
      _recognitions=recognition;
    });

  }

  ssdMobilenet(File image) async{
    var recognition=await Tflite.detectObjectOnImage(
      path: image.path,
      numResultsPerClass: 1,
    );
    setState(() {
      _recognitions=recognition;
    });
  }


  List<Widget> renderBoxes(Size screen){
    if(_recognitions==null)return[];
    if( _imageHeight==null || _imageWidth==null)return[];

    double factorX=screen.width;
    double factorY=_imageHeight/_imageHeight*screen.width;

    Color blue=Colors.blue;

    return _recognitions.map((re){
      return Positioned(
        top: re['rect']['y']*factorY,
        left: re['rect']['x']*factorX,
        width: re['rect']['w']*factorX,
        height: re['rect']['h']*factorY,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: blue,
              width: 3,
            )
          ),
          child: Text("${re['detectedClass']} ${(re['confidenceInClass']*100).toStringAsFixed(0)}%",style: TextStyle(
            background: Paint()..color=blue,
            color: Colors.white,
            fontSize: 15,
          ),)
        ),
      );
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    Size size=Size(600, 40);
    List<Widget> stackChildren=[];
    stackChildren.add(Positioned(
      top: 0.0,
      left: 0.0,
      child: _image==null?Text("No Image Loaded"):Image.file(_image),
    ));

    stackChildren.addAll(renderBoxes(size));
    if(_busy){
      stackChildren.add(
        Center(child:CircularProgressIndicator())
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Fikido Object Detector"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: selectFromImagePicker,
        child: Icon(Icons.file_upload),
      ),
      body:Stack(
          children: stackChildren,
        ),
    );
  }
}
*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'home.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fikido Detection',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blueGrey,
      ),
      home: HomePage(cameras),
    );
  }
}