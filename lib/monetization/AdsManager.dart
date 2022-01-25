
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
  return 'AD_UNIT_ID';
}

String historiesBannerAdUnitId() {
  return 'AD_UNIT_ID';
}

String momentBannerAdUnitId(){
  return 'AD_UNIT_ID';
}

String interstitialAdUnitId() {
  return 'AD_UNIT_ID';
}

String videoInterstitialAdUnitId() {
  return 'AD_UNIT_ID';
}

// Testing ad units for Admob only ...

String testBannerAdUnitId() {
  return 'AD_UNIT_ID';
}

String testInterstitialAdUnitId() {
  return 'AD_UNIT_ID';
}

String testVideoInterstitialAdUnitId() {
  return 'AD_UNIT_ID';
}
