import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:fake_call/UI/History.dart';
import 'package:fake_call/monetization/AdsManager.dart';
import 'package:fake_call/constants.dart';
import 'package:flutter/material.dart';

class HAppBar extends StatelessWidget implements PreferredSizeWidget{

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 30,
            width: 40,
            child: Tooltip(
              message: 'Open history calls',
              child: InkWell(
                highlightColor: Color(0xFF66BB6A),
                borderRadius: BorderRadius.circular(30),
                onTap: () async {
                  // TODO ASD HERE
                  await Navigator.of(context)
                      .push(MaterialPageRoute(
                      builder: (context) {
                        try{
                          FacebookInterstitialAd.loadInterstitialAd(
                            placementId: getMainInterstitialAdUnitId(),
                            listener: (result, value){
                              AdsManager().listener(result, value);
                            },
                          );
                        }catch(e){

                        }
                        return History();
                      } ))
                      .then((value){
                    AdsManager().showAds();
                  });
                },
                child: Icon(
                  Icons.settings_rounded,
                  color: Colors.green,
                ),
              ),
            ),
          ),
        )
      ],
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 30,
          width: 40,
          child: Tooltip(
            message: 'Open settings',
            child: InkWell(
              highlightColor: Color(0xFF66BB6A),
              borderRadius: BorderRadius.circular(30),
              onTap: () async {
                Scaffold.of(context).openDrawer();
              },
              child: Icon(
                Icons.menu_rounded,
                color: Colors.green,
              ),
            ),
          ),
        ),
      ),
      title: Text( APPLICATION_NAME ,
        style: TextStyle(color: Colors.green,
            fontFamily: 'myFont'),
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
