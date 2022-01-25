import 'package:flutter/material.dart';

class TimeCalculator {


  String calculate ([TimeOfDay tod]){
    TimeOfDay now = TimeOfDay.now();
    if(tod == now){
      return 'now';
    }else{
      var minutes;
      var hours;
      var dec = 0;
      // Minutes
      var k = (tod.minute - now.minute);
      if(k.isNegative){
        if(tod.minute != now.minute && tod.hour > now.hour){
          dec++;
        }
      }
      if(tod.minute > now.minute){
        minutes = tod.minute-now.minute;
      }else if(tod.minute != now.minute){
        var a = 60;
        var b = a - now.minute;
        minutes = b + tod.minute;
      }else{
        minutes = 0;
      }
      // Hours
      if(tod.hour > now.hour){
        hours = tod.hour-now.hour;
      }else if(now.hour!=tod.hour){
        //print('now.hour!=tod.hour');
        var v = 24;
        var g = v - now.hour;
        hours = g + tod.hour;
      } else{
        if(now.minute > tod.minute){
          hours = 23;
        }else{
          hours = now.hour - tod.hour;
        }
      }
      hours = hours - dec;
      if(hours == 0){
        return '$minutes minutes';
      }else{
        return '$hours hours and $minutes minutes';
      }
    }
  }

  List calculateFromString(String time){
    TimeOfDay tod = TimeOfDay(hour: int.parse('${time.substring(10,12)}'), minute: int.parse('${time.substring(13,15)}'));
    TimeOfDay now = TimeOfDay.now();
    if(tod == now){
      List format = [int.parse('${time.substring(10,12)}'),int.parse('${time.substring(13,15)}')];
      return format;
    }else{
      var minutes;
      var hours;
      var dec = 0;
      var k = (tod.minute - now.minute);
      if(k.isNegative){
        if(tod.minute != now.minute && tod.hour > now.hour){
          dec++;
        }
      }
      if(tod.minute > now.minute){
        minutes = tod.minute-now.minute;
      }else if(tod.minute != now.minute){
        var a = TimeOfDay.minutesPerHour;
        var b = a - now.minute;
        minutes = b + tod.minute;
      }else{
        minutes = 0;
      }
      // Hours
      if(tod.hour > now.hour){
        hours = tod.hour-now.hour;
      }else if(now.hour!=tod.hour){
        var v = 24;
        var g = v - now.hour;
        hours = g + tod.hour;
      } else{
        if(now.minute > tod.minute){
          hours = 23;
        }else{
          hours = now.hour - tod.hour;
        }
      }
      hours = hours - dec;
      //print('$hours Hours and $minutes minutes');
      List format = [hours,minutes];
      return format;
    }
  }

  bool isNegative(String timeFromDb){
    TimeOfDay timeOfDay = TimeOfDay(hour: int.parse('${timeFromDb.substring(10,12)}'), minute: int.parse('${timeFromDb.substring(13,15)}'));
    if(timeOfDay == TimeOfDay.now()) return false;
    else if(calculateFromString(timeFromDb).first > 0) {
      if(calculateFromString(timeFromDb).last > 0){

      }
    }
    return true;
  }

  Map<dynamic,dynamic> isAfter(String time){
    int hours = 0;
    int minutes = 0;
    TimeOfDay timeOfDb = TimeOfDay(hour: int.parse('${time.substring(10,12)}'), minute: int.parse('${time.substring(13,15)}'));
    // db 2:05
    // now 2 : 40
    if((TimeOfDay.now().hour - timeOfDb.hour).isNegative){
      return {bool :false, int : [hours ,minutes] };
      // var res = hours - timeOfDb.hour;
      // res += TimeOfDay.now().hour;
      // hours = res;
    }else{
      hours = TimeOfDay.now().hour - timeOfDb.hour;
      //hours = 0
      if((TimeOfDay.now().minute - timeOfDb.minute).isNegative){
        hours -=  1;
        if((TimeOfDay.now().hour - timeOfDb.hour).isNegative) return {bool :false, int : [hours ,minutes] };
        var min = 60;
        var res = min - timeOfDb.minute;
        res += TimeOfDay.now().minute;
        if(res >= min){
          hours += 1;
          minutes -= min;
        }
        minutes = res;
        return {bool :true, int : [hours ,minutes] };
      }else{
        minutes = TimeOfDay.now().minute - timeOfDb.minute;
        if(minutes >= 60){
          hours += 1;
          minutes -= 60;
        }
        return {bool :true, int : [hours ,minutes] };
      }
    }
  }

}