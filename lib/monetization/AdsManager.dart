import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';

class AdsManager {

  bool showAdsCond = true;

   void listener (result, value ){
     switch (result) {
       case BannerAdResult.ERROR:
         print("Error: $value");
         break;
       case BannerAdResult.LOADED:
         print("Loaded: $value");
         break;
       case BannerAdResult.CLICKED:
         print("Clicked: $value");
         break;
       case BannerAdResult.LOGGING_IMPRESSION:
         print("Logging Impression: $value");
         break;
     }
   }

    initMainInterstitial(){
      FacebookInterstitialAd.loadInterstitialAd(
       placementId: getMainInterstitialAdUnitId(),listener: (result,value){
         listener(result, value);
        }
     );
  }

    initDoneInterstitial(){
      FacebookInterstitialAd.loadInterstitialAd(
        placementId: getDoneInterstitialAdUnitId(),listener: (result,value){
        listener(result, value);
         }
      );
   }

   Future<bool> loadAds() async{
     return await FacebookInterstitialAd.loadInterstitialAd(
         placementId: getDoneInterstitialAdUnitId(),
         listener: (result,value){
          listener(result, value);
         }
     );
   }

   void showAds() async {
     if (showAdsCond) {
       FacebookInterstitialAd.showInterstitialAd();
       showAdsCond = false;
       Future.delayed(new Duration(seconds: 30), () {
           showAdsCond = true;
       });
     }
   }

}


String mainActivityBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'Test -- ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return '1866713713479068_1867249276758845';
  }
  return null;
}

String historyActivityBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'Test -- ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return '1866713713479068_1867169586766814';
  }
  return null;
}

String callNowBannerAdUnitId(){
  if (Platform.isIOS) {
    return 'Test -- ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return '1866713713479068_1867163543434085';
  }
  return null;
}

String getMainInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return 'Test -- ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return '1866713713479068_1867240650093041';
  }
  return null;
}

String getDoneInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return 'Test -- ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return '1866713713479068_1867242503426189';
  }
  return null;
}


// String getNativeAdUnitId() {
//   if (Platform.isIOS) {
//     return 'ca-app-pub-3940256099942544/1712485313';
//   } else if (Platform.isAndroid) {
//     return "ca-app-pub-3940256099942544/2247696110";
//   }
//   return null;
// }

String testMainActivityBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/6300978111';
  }
  return null;
}

String testHistoryActivityBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/6300978111';
  }
  return null;
}

String testCallNowBannerAdUnitId(){
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/6300978111';
  }
  return null;
}

String testGetMainInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/4411468910';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/1033173712';
  }
  return null;
}

String testGetDoneInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/4411468910';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/8691691433';
  }
  return null;
}


String testGetNativeAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/1712485313';
  } else if (Platform.isAndroid) {
    return "ca-app-pub-3940256099942544/2247696110";
  }
  return null;
}