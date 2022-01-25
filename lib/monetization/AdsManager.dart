
import 'package:flutter_applovin_max/flutter_applovin_max.dart';

class AdsManager {

   void listener (AppLovinAdListener adListener){
     switch (adListener) {
       case AppLovinAdListener.adLoadFailed:
         print("Error to loadAd: $adListener");
         break;
       case AppLovinAdListener.adLoaded:
         print("Loaded ad successfully: $adListener");
         break;
       case AppLovinAdListener.adDisplayed:
         print("adDisplayed successfully: $adListener");
         break;
       case AppLovinAdListener.adClicked:
         print("adClicked successfully: $adListener");
         break;
       case AppLovinAdListener.adHidden:
         print("adHidden: $adListener");
         break;
       case AppLovinAdListener.onAdDisplayFailed:
         print("onAdDisplayFailed: $adListener");
         break;
       case AppLovinAdListener.onRewardedVideoStarted:
         print("onRewardedVideoStarted: $adListener");
         break;
       case AppLovinAdListener.onRewardedVideoCompleted:
         print("onRewardedVideoCompleted: $adListener");
         break;
       case AppLovinAdListener.onUserRewarded:
         print("👍 onUserRewarded: $adListener");
         break;
     }
   }

  //  showInterstitialAd(){
  //     final interstitialAd = InterstitialAd(getMainInterstitialAdUnitId());
  //     interstitialAd.listener = InterstitialAdListener(
  //       onLoaded: () {
  //         interstitialAd.show();
  //       },
  //       onDismissed: () {
  //         interstitialAd.destroy();
  //         print('Interstitial dismissed');
  //       },
  //     );
  //     interstitialAd.load();
  // }
}


String mainBannerAdUnitId() {
  return 'be884c66244bc5f8';
}

String historiesBannerAdUnitId() {
  return 'be884c66244bc5f8';
}

String momentBannerAdUnitId(){
  return 'be884c66244bc5f8';
}

String interstitialAdUnitId() {
  return '610f3fc458d89381';
}

String videoInterstitialAdUnitId() {
  return '1866713713479068_1867242503426189';
}

// Testing ad units for Admob only ...

String testBannerAdUnitId() {
  return 'ca-app-pub-3940256099942544/6300978111';
}

String testInterstitialAdUnitId() {
  return 'ca-app-pub-3940256099942544/1033173712';
}

String testVideoInterstitialAdUnitId() {
  return 'ca-app-pub-3940256099942544/8691691433';
}
