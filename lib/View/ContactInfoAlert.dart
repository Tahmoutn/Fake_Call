import 'package:flutter/material.dart';

class ContactInfoAlert extends StatefulWidget {
  @override
  _ContactInfoAlertState createState() => _ContactInfoAlertState();
}

class _ContactInfoAlertState extends State<ContactInfoAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.amber,
      actionsPadding: const EdgeInsets.only(right: 14,bottom: 10),
      contentPadding: const EdgeInsets.only(top: 20,right: 20,left: 20),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Contact information!',
          style: TextStyle(
            fontFamily: 'Lato-Thin',
            fontSize: 20,
            fontWeight: FontWeight.w600
          ),),
          Icon(Icons.lightbulb_outline_rounded,color: Colors.white,)
        ],
      ),
      content: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black87,
            fontSize: 15
          ),
          children: <TextSpan>[
            TextSpan(text:'In this case',
            style: TextStyle(
              fontWeight: FontWeight.w300
            ),
            ),
            TextSpan(text: ', we did not show Contact name, only the number, if you want to display their name,',
              style: TextStyle(
                  fontWeight: FontWeight.w800
              ),
            ),
            TextSpan(text: ' please register the contact and try again.',
              style: TextStyle(
                  fontWeight: FontWeight.w300
              ),
            ),
          ],
        ),
      ),
      actions: [
        MaterialButton(
          color: Colors.white,
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Text('Ok. I got it',
          style: TextStyle(
            fontFamily: 'Lato-Thin',
            fontWeight: FontWeight.w600
          ),),
        ),
      ],
    );
  }
}
