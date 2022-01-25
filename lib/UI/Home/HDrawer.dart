import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share/share.dart';

class HDrawer extends StatefulWidget {
  @override
  State<HDrawer> createState() => _HDrawerState();
}

class _HDrawerState extends State<HDrawer> {
  bool switchThemeValue = false;
  final InAppReview inAppReview = InAppReview.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
        child: LayoutBuilder(
          builder: (context, constraint){
           return SingleChildScrollView(
            child: ConstrainedBox(constraints: BoxConstraints(
              minHeight: constraint.maxHeight
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/favicon.png',
                          width: 40,
                          filterQuality: FilterQuality.high,
                          height: 40,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Image.asset(
                          'assets/images/ic_launcher.png',
                          width: 20,
                          filterQuality: FilterQuality.high,
                          height: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Fake call',
                          style: TextStyle(
                              color: Colors.black38,
                              fontFamily: 'myFont',
                              fontSize: 18),
                        ),
                        // Spacer(),
                        // Switch(
                        //   value: switchThemeValue,
                        //   onChanged: (value){
                        //     print(value);
                        //     setState(() {
                        //       if(switchThemeValue){
                        //         switchThemeValue = false;
                        //       }else{
                        //         switchThemeValue = true;
                        //       }
                        //     });
                        //   })
                        // IconButton(
                        //   color: Colors.green,
                        //   onPressed: (){},
                        //   icon: Icon(Icons.wb_sunny_rounded),
                        // ),
                      ],
                    ),
                  ),
                  Divider(
                    indent: 30,
                    endIndent: 30,
                  ),
                  ListTile(
                    trailing: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Tooltip(
                        message: 'Link',
                        child: Icon(
                          Icons.launch_outlined,
                        ),
                      ),
                    ),
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.rate_review_outlined,
                        color: Colors.green,
                      ),
                    ),
                    title: Text(
                      'Write a review',
                      style: TextStyle(color: Colors.green),
                    ),
                    subtitle: Text(
                      'Tell others what you think',
                      maxLines: 1,
                      style: TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis),
                    ),
                    onTap: () async {
                      try{
                        inAppReview.openStoreListing(appStoreId:'com.tahmoutn.fake_call');
                      }catch(e){

                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        )),
                  ),
                  ListTile(
                    trailing: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Tooltip(
                        message: 'Link',
                        child: Icon(
                          Icons.launch_outlined,
                        ),
                      ),
                    ),
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.share_outlined,
                        color: Colors.green,
                      ),
                    ),
                    title: Text(
                      'Share with others',
                      style: TextStyle(color: Colors.green),
                    ),
                    subtitle: Text(
                      'Tell others about us',
                      maxLines: 1,
                      style: TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis),
                    ),
                    onTap: () {
                      try {
                        Share.share(
                            'hey! check out this new app https://play.google.com/store/apps/details?id=com.tahmoutn.fake_call');
                        Navigator.pop(context);
                      } catch (e) {}
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        )),
                  ),
                  Divider(
                    indent: 30,
                    endIndent: 30,
                  ),
                  Spacer(
                  ),
                  Divider(
                    indent: 30,
                    endIndent: 30,
                    thickness: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.04,
                        right: 25,
                        left: 25),
                    child: Center(
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'myFont',
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Created by | ',
                                  ),
                                  TextSpan(
                                      text: 'Next Studio ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800
                                      )
                                  ),
                                  TextSpan(
                                    text:
                                    '@2019 - 2021 | Fake call v1.2 | All rights reserved ',
                                  )
                                ]))),
                  )
                ],
              ),
            ),),
           );
          }
        ),
      ),
    );
  }
}
