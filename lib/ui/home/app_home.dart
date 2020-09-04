import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zyuedu/ui/bookshelf/bookshelf_page.dart';


///@author longshaohua
///小说首页

class MyHomePage extends StatefulWidget {
  static const platform = const MethodChannel("samples.flutter.io/permission");

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State {


  @override
  void initState() {
    super.initState();
//    动态申请相机权限示例，原生部分请查看 Android 下的 MainActivity
//    _getPermission();
  }

  // Future<Null> _getPermission() async {
  //   final String result =
  //       await MyHomePage.platform.invokeMethod('requestCameraPermissions');
  //   print("result=$result");
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: BookshelfPage()
    );
  }

}
