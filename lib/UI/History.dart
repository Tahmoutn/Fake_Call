import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:fake_call/Monetization/MyBannerWidget.dart';
import 'package:fake_call/database/HistoryDatabase.dart';
import 'package:fake_call/database/database.dart';
import 'package:fake_call/model/ListCallModel.dart';
import 'package:fake_call/monetization/AdsManager.dart';
import 'package:fake_call/constants.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  List<ListCallModel> items = [];

  @override
  initState(){
    _getData();
    super.initState();
  }

  Future _getData() async {
    await HistoryDatabase().getCalls().then((value){
      if(value!=null){
        setState(() {
          items = value;
        });
      }
      else
        items.clear();
      return true;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 16,top: 8,bottom: 8),
            child: Tooltip(
              message: 'Return',
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_rounded,
                color: Colors.green,),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('History call',
        style: TextStyle(
          color: Colors.green
        ),),
        actions: [
          Container(
            height: 50,
            width: 55,
            child: Padding(
              padding: const EdgeInsets.only(right: 16,top: 8,bottom: 8),
              child: Tooltip(
                message: 'Clear all',
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    if(items.isEmpty){
                      _showAlertToClearAll(msg:'Your history box is empty');
                    }else{
                      _showAlertToClearAll();
                    }
                  },
                  child: Icon(Icons.clear_all_rounded,
                    color: Colors.deepOrange,),
                ),
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        builder: (context,snapshot){
          if(items.isEmpty){
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Center(
                    child: Image.asset('assets/images/history_design.png'),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    //TODO
                    child : new MyBannerWidget(
                      placementId: historyActivityBannerAdUnitId(),
                      bannerSize: BannerSize.STANDARD,
                    ),
                  ),
                )
              ],
            );
          }else if(items.isNotEmpty){
            return ListView.separated(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top :4.0, left: 4.0, right: 4.0, bottom: 80.0),
              itemCount: items.length,
              itemBuilder: (context,index){
                return Container(
                  child: Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(top: 8.0,right: 12.0,left: 12.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            width: 0.8,
                            color: Colors.black12
                        )
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      // onLongPress: _selected ? null : (){
                      //   setState(() {
                      //     selectItems.add(items[index]);
                      //     _selected = true;
                      //   });
                      // },
                      onTap: (){
                        //_showCall(item: items[index],color : _circleIcon[index]);
                      },
                      child: ListTile(
                        title: items[index].name == null ? Text('${items[index].number}')
                            : Text('${items[index].name}'),
                        subtitle: Text('${items[index].number} • at ${items[index].time.replaceAll('TimeOfDay(', '').replaceAll(')', '')}',
                          overflow: TextOverflow.ellipsis,),
                        leading: Padding(
                          padding: EdgeInsets.all(2),
                          child: CircleAvatar(
                            radius: 20.3,
                            backgroundColor: Colors.black26,
                            child: CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person,
                                  color: Colors.black45),
                            ),
                          ),
                        ),
                        trailing: SizedBox(
                          height: 50,
                          width: 50,
                          child: InkWell(
                            onTap: (){
                              _showAlert(items[index],index);
                            },
                            borderRadius: BorderRadius.circular(30.0),
                            child: Icon(Icons.remove_circle,
                              color: Colors.red,),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                if(index % 10 == 0) {
                  return Container(
                    padding: EdgeInsets.only(top: 8.0,right: 12.0,left: 12.0),
                    child: new MyBannerWidget(
                      placementId: historyActivityBannerAdUnitId(),
                      bannerSize: BannerSize.STANDARD,
                    ),
                  );
                }
                return SizedBox();
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  _showAlert(ListCallModel call,int index) async{
    showDialog(
        context: context,
        builder: (context){
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
                    text: '${call.name} ?',
                    style: new TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87),
                  ),
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No. cancel',style: TextStyle(
                    color: Colors.green
                ),),
              ),
              MaterialButton(
                color: Color(0xFFE8F5E9),
                elevation: 0.5,
                onPressed: () async{
                  deleteCall(HISTORY_DB,call);
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes. delete it',style: TextStyle(
                    color: Colors.green
                ),),
              ),
            ],
          );
        }
        //=> AlertDeleteCall(HISTORY_DB,call)
    ).then((value){
      if(value != null){
        if(value){
          setState(() {
            items.removeAt(index);
          });
        }
      }
    });
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

  _showAlertToClearAll({String msg}){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)
          ),
          actionsPadding: const EdgeInsets.only(right: 14,bottom: 10),

          title: msg == null ? Text('Are you sure?',
            style: TextStyle(
                fontWeight: FontWeight.w400
            ),
          ) : null,
          content: msg == null ? RichText(
            text: new TextSpan(
              style: new TextStyle(
                color: Colors.black,
              ),
              children: <TextSpan>[
                new TextSpan(text: 'Did you want to clear ',
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16
                    )),
                new TextSpan(
                  text: 'History ?',
                  style: new TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87),
                ),
              ],
            ),
          ) : Text(msg,
          textAlign: TextAlign.center,),
          actions: [
            msg == null ?
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No. cancel'),
            ) : SizedBox(),
            msg == null ? MaterialButton(
              color: Colors.green,
              onPressed: (){
                _clearHistory().then((value) {
                  _getData();
                  Navigator.pop(context);
                });
              },
              child: Text('Yes. Clear all',
              style: TextStyle(
                color: Colors.white
              ),),
            ) : MaterialButton(
              color: Colors.green,
              onPressed: (){
                  Navigator.pop(context);
              },
              child: Text('Ok. I got it',style: TextStyle(
                color: Colors.white
              ),),
            ),
          ],
        ));
  }

  Future<bool> _clearHistory() async{
    await HistoryDatabase().db;
    var dbHelper =  HistoryDatabase();
    var result = await dbHelper.deleteAll();
    return result;
  }


}
