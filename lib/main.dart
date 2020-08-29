import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zyuedu/res/colors.dart';
import 'package:zyuedu/ui/splash/splash_page.dart';

void main() {
  runApp(MyApp());
  //设置状态栏透明
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cursorColor: MyColors.textPrimaryColor,
        scaffoldBackgroundColor: MyColors.white,
        primaryColor: MyColors.primary,
      ),
      home: SplashPage(),
      // locale: const Locale("zh", "CH"),
      // supportedLocales: [
      //   const Locale("zh", "CH"),
      //   const Locale("en", "US"),
      // ],
      // localizationsDelegates: [],
    );
  }
}
