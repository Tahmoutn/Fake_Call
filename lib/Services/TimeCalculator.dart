import 'package:flutter/material.dart';

class TimeCalculator{
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
}