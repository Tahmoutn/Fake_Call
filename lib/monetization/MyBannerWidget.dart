

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:fake_call/Monetization/AdsManager.dart';
import 'package:flutter/material.dart';

class MyBannerWidget extends StatefulWidget {

  const MyBannerWidget({
    Key key,
    this.placementId,
    this.bannerSize
  }):  assert(placementId!=null),
       assert(bannerSize!=null),
      super(key: key);

  final String placementId;
  final BannerSize bannerSize;


  @override
  _MyBannerWidgetState createState() => _MyBannerWidgetState();
}

class _MyBannerWidgetState extends State<MyBannerWidget>{

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: widget.bannerSize.width * 1.0,
      child: FacebookBannerAd(
        placementId: widget.placementId,
        bannerSize: widget.bannerSize,
        listener: (result,value){
          AdsManager().listener(result, value);
        },
      ),
    );
  }


}
