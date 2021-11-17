import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(
              'assets/images/ic_launcher.png'),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Welcome in Fake call',
          style: TextStyle(
              fontSize: 45,
              color: Colors.green
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20,
        ),
        Text('You can make a incoming call as a real call'),
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.1,
              left: MediaQuery.of(context).size.height * 0.05,
              right: MediaQuery.of(context).size.height * 0.05
          ),
          child: Container(
            height: 40,
            decoration: ShapeDecoration(
              color: Colors.green.shade50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Swipe to left to read our privacy ',
                  style: TextStyle(

                  ),),
                Icon(Icons.arrow_right_alt_rounded)
              ],
            ),
          ),),
      ],
    );
  }
}
