import 'package:fake_call/model/ListCallModel.dart';
import 'package:flutter/material.dart';

class ShowCallSheet extends StatefulWidget {
  final ListCallModel item;
  final Color color;
  ShowCallSheet(this.item,this.color);

  @override
  _ShowCallSheetState createState() => _ShowCallSheetState();
}

class _ShowCallSheetState extends State<ShowCallSheet> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Wrap(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0,
                      right: 12.0,
                      left: 12.0,
                      bottom: 12.0
                  ),
                  child: Card(
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: Colors.transparent
                        ),
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0,right: 12.0),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: CircleAvatar(
                                      radius: 20.2,
                                      backgroundColor: Colors.black45,
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: widget.color,
                                        child: Icon(Icons.person_rounded,
                                        color: Colors.black45,),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(widget.item.name.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600
                              ),)
                            ],
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),

                        ListTile(
                          leading: Icon(Icons.phone_rounded),
                          subtitle: Center(
                            child: Text('The phone number'),
                          ),
                          title: Center(
                            child: Text(widget.item.number,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 30.0
                              ),
                            ),
                          ),
                        ),

                        Divider(
                          height: 1,
                        ),
                        ListTile(
                          leading: Icon(Icons.timelapse),
                          subtitle: Center(child: Text('Call delivery time')),
                          title: Center(
                            child: Text(widget.item.time.toString().replaceAll('TimeOfDay(', '').replaceAll(')', ''),
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 30.0
                              ),),
                          ),
                        ),
                      ],
                    ),
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
