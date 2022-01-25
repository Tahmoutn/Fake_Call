import 'package:fake_call/providers/IntroProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SecondPage extends StatefulWidget {

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  Future<void> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'': ''},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text('Privacy Policy',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600
              ),
              textAlign: TextAlign.center,),
          ),
        ],
      ),
    );
  }
}
