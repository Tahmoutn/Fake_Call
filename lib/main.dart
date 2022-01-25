import 'package:callkeep/callkeep.dart';
import 'package:fake_call/UI/Home/Home.dart';
import 'package:fake_call/UI/Intro/Intro.dart';
import 'package:fake_call/constants.dart';
import 'package:fake_call/providers/HomeProvider.dart';
import 'package:fake_call/providers/IntroProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_applovin_max/flutter_applovin_max.dart';
import 'package:provider/provider.dart';

const String testDevice = "TestId";
final FlutterCallkeep callKeep = FlutterCallkeep();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  FlutterApplovinMax.initSDK();


  runApp(
      MultiProvider(
        providers:[
          ChangeNotifierProvider(create: (_)=> IntroProvider()),
          ChangeNotifierProvider(create: (_)=> HomeProvider())
        ],
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(new SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarDividerColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarContrastEnforced: true,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APPLICATION_NAME,
      theme: ThemeData(
        canvasColor: Colors.white,
        accentColor: Colors.green,
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: APPLICATION_NAME),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool acceptingAgreementState = true;

  @override
  void didChangeDependencies() {
    IntroProvider().getAcceptingAgreementState().then((value) => setState((){
      acceptingAgreementState = value;
    }));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
     return acceptingAgreementState ? Home() : Intro();
  }
}
