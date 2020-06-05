import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'models.dart';

class BndBox extends StatelessWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final String model;

  BndBox(this.results, this.previewH, this.previewW, this.screenH, this.screenW,
      this.model);

  @override
  Widget build(BuildContext context) {
    List<Widget> _renderBoxes() {
      return results.map((re) {
        var _x = re["rect"]["x"];
        var _w = re["rect"]["w"];
        var _y = re["rect"]["y"];
        var _h = re["rect"]["h"];
        var scaleW, scaleH, x, y, w, h;

        if (screenH / screenW > previewH / previewW) {
          scaleW = screenH / previewH * previewW;
          scaleH = screenH;
          var difW = (scaleW - screenW) / scaleW;
          x = (_x - difW / 2) * scaleW;
          w = _w * scaleW;
          if (_x < difW / 2) w -= (difW / 2 - _x) * scaleW;
          y = _y * scaleH;
          h = _h * scaleH;
        } else {
          scaleH = screenW / previewW * previewH;
          scaleW = screenW;
          var difH = (scaleH - screenH) / scaleH;
          x = _x * scaleW;
          w = _w * scaleW;
          y = (_y - difH / 2) * scaleH;
          h = _h * scaleH;
          if (_y < difH / 2) h -= (difH / 2 - _y) * scaleH;
        }
        Color _colorobject=Colors.green;
        switch (re['detectedClass']) {
          case 'chair':
            re['detectedClass']='intebe';
            _colorobject=Colors.blue;
            break;
          case 'table':
            re['detectedClass']='imeza';
            _colorobject=Colors.black;
            break;
          case 'dining table':
            re['detectedClass']='imeza yuburiro';
            _colorobject=Colors.lightBlue;
            break;
          case 'clock':
            re['detectedClass']='isaha';
            _colorobject=Colors.orange;
            break;
          case 'zebra':
            re['detectedClass']='imparage';
            _colorobject=Colors.black;
            break;
          case 'oven':
            re['detectedClass']='ifuru';
            _colorobject=Colors.blueGrey;
            break;
          case 'refrigerator':
            re['detectedClass']='firigo';
            _colorobject=Colors.blueGrey;
            break;
          case 'couch':
            re['detectedClass']='intebe z\'imifariso';
            _colorobject=Colors.blueGrey;
            break;
          case 'bed':
            re['detectedClass']='igitanda';
            _colorobject=Colors.orangeAccent;
            break;
          case 'toilet':
            re['detectedClass']='ubwiherero';
            _colorobject=Colors.orangeAccent;
            break;
          case 'umbrella':
            re['detectedClass']='umutaka';
            _colorobject=Colors.orange;
            break;
          case 'person':
            re['detectedClass']='umuntu';
            _colorobject=Colors.redAccent;
            break;
          case 'cup':
            re['detectedClass']='igikombe';
            _colorobject=Colors.orange;
            break;
          case 'bench':
            re['detectedClass']='intebe rusange';
            _colorobject=Colors.orange;
            break;
          case 'tv':
            re['detectedClass']='television';
            _colorobject=Colors.orange;
            break;
          case 'cat':
            re['detectedClass']='ipusi';
            _colorobject=Colors.orange;
            break;
          case 'dog':
            re['detectedClass']='imbwa';
            _colorobject=Colors.pink;
            break;
          case 'pen':
            re['detectedClass']='ikaramu';
            _colorobject=Colors.orange;
            break;
          case 'book':
            re['detectedClass']='igitabo';
            _colorobject=Colors.red;
            break;
          case 'laptop':
            re['detectedClass']='mudasobwa';
            _colorobject=Colors.indigo;
            break;
          case 'cell phone':
            re['detectedClass']='telephone';
            _colorobject=Colors.redAccent;
            break;
          default:
            re['detectedClass']=re['detectedClass'];
            _colorobject=Colors.green;
        }
        return Positioned(
          left: math.max(0, x),
          top: math.max(0, y),
          width: w,
          height: h,
          child: Container(
            padding: EdgeInsets.only(top: 5.0, left: 5.0),
            decoration: BoxDecoration(
              border: Border.all(
                color:_colorobject,
                width: 3.0,
              ),
            ),
            child: Text(
              "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                color: Color.fromRGBO(37, 213, 253, 1.0),
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList();
    }

    List<Widget> _renderStrings() {
      double offset = -10;
      return results.map((re) {
        offset = offset + 14;
        return Positioned(
          left: 10,
          top: offset,
          width: screenW,
          height: screenH,
          child: Text(
            "${re["label"]} ${(re["confidence"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              color: Color.fromRGBO(37, 213, 253, 1.0),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList();
    }

    List<Widget> _renderKeypoints() {
      var lists = <Widget>[];
      results.forEach((re) {
        var list = re["keypoints"].values.map<Widget>((k) {
          var _x = k["x"];
          var _y = k["y"];
          var scaleW, scaleH, x, y;

          if (screenH / screenW > previewH / previewW) {
            scaleW = screenH / previewH * previewW;
            scaleH = screenH;
            var difW = (scaleW - screenW) / scaleW;
            x = (_x - difW / 2) * scaleW;
            y = _y * scaleH;
          } else {
            scaleH = screenW / previewW * previewH;
            scaleW = screenW;
            var difH = (scaleH - screenH) / scaleH;
            x = _x * scaleW;
            y = (_y - difH / 2) * scaleH;
          }
          return Positioned(
            left: x - 6,
            top: y - 6,
            width: 100,
            height: 12,
            child: Container(
              child: Text(
                "● ${k["part"]}",
                style: TextStyle(
                  color: Color.fromRGBO(37, 213, 253, 1.0),
                  fontSize: 14.0,
                ),
              ),
            ),
          );
        }).toList();

        lists..addAll(list);
      });

      return lists;
    }

    return Stack(
      children: model == mobilenet
          ? _renderStrings()
          : model == posenet ? _renderKeypoints() : _renderBoxes(),
    );
  }
}
