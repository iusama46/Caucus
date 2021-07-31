/*

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
class CameraScreen extends StatelessWidget{
  @override
  Widget build (BuildContext context){
    return new Center(
      child: new Text(
        "Camera",
        style: new TextStyle(fontSize: 20.0),
      ),
    );
  }
}
class CameraDescription {
  final String name;
  final CameraLensDirection lensDirection;
  CameraDescription ({required this.name, required this.lensDirection});
  @override
  bool operator==(Object o){
    return o is CameraDescription &&
    o.name== name &&
    o.lensDirection==lensDirection;
  }
  @override
  int get hashCode{
    return hashValues(name, lensDirection);
  }
  @override
  String toString(){
    return'$runtimeType($name,$lensDirection)';
  }

}
class CameraException implements Exception{
  String code;
  String description;
  CameraException(this.code, this.description);
  @override
  String toString()=> '$runtimeType($code,$description)';
}

class CameraPreview extends StatelessWidget{
  final CameraController controller;
  const CameraPreview(this.controller);
  @override
  Widget build (BuildContext context){
    return controller.value.isInitialized
        ? new Texture (textureId: controller._textureId)
        :new Container();
  }

*/
