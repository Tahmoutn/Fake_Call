import 'package:fake_call/database/HistoryDatabase.dart';
import 'package:fake_call/database/database.dart';
import 'package:fake_call/model/ListCallModel.dart';
import 'package:fake_call/constants.dart';
import 'package:flutter/material.dart';

class AlertDeleteCall extends StatefulWidget {
  final ListCallModel call;
  final String db;
  AlertDeleteCall(this.db,this.call);

  @override
  _AlertDeleteCallState createState() => _AlertDeleteCallState();
}

class _AlertDeleteCallState extends State<AlertDeleteCall> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0)
      ),
      actionsPadding: const EdgeInsets.only(right: 14,bottom: 10),

      title: Text('Are you sure?',
      style: TextStyle(
        fontWeight: FontWeight.w400
       ),
      ),
      content: RichText(
        text: new TextSpan(
          style: new TextStyle(
            color: Colors.black,
          ),
          children: <TextSpan>[
            new TextSpan(text: 'Did you want to delete ',
            style: TextStyle(
                color: Colors.black54,
                fontSize: 16
            )),
            new TextSpan(
                text: '${widget.call.name} ?',
                style: new TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('No. cancel',style: TextStyle(
              color: Colors.green
            ),),
        ),
        MaterialButton(
          color: Colors.green,
          onPressed: () async{
            deleteCall(widget.db,widget.call);
            Navigator.of(context).pop(true);
          },
          child: Text('Yes. delete it',style: TextStyle(
              color: Colors.white
          ),),
        ),
      ],
    );
  }

  Future deleteCall(String db,ListCallModel call) async{
      switch(db){
        case MAIN_DB:{
          await DatabaseHelper().db;
          var dbHelper =  DatabaseHelper();
          await dbHelper.deleteCall(call);
          break;
        }
        case HISTORY_DB:{
          await HistoryDatabase().db;
          var hdbHelper =  HistoryDatabase();
          await hdbHelper.deleteCall(call);
          break;
        }
      }
  }
}
