import 'package:fake_call/UI/log.dart';
import 'package:fake_call/constants.dart';
import 'package:flutter/material.dart';

class HAppBar extends StatelessWidget implements PreferredSizeWidget{

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shadowColor: Colors.green.withOpacity(0.05),
      elevation: 5,
      backgroundColor: Colors.white,
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 30,
            width: 40,
            child: Tooltip(
              message: 'Call log',
              child: InkWell(
                highlightColor: Colors.green.shade100,
                borderRadius: BorderRadius.circular(30),
                onTap: () async {
                  await Navigator.of(context)
                      .push(MaterialPageRoute(
                      builder: (context) {
                        return Log();
                      }),
                  );
                },
                child: Icon(
                  Icons.history_rounded,
                  color: Colors.green,
                ),
                // Column(
                //   children: [
                //     Icon(
                //       Icons.history_rounded,
                //       color: Colors.green,
                //     ),
                //     Text('Call log',
                //       style: TextStyle(
                //           fontSize: 10,
                //           color: Colors.green
                //       ),),
                //   ],
                // ),
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
            message: 'Menu',
            child: InkWell(
              highlightColor: Colors.green.shade100,
              borderRadius: BorderRadius.circular(30),
              onTap: () async {
                Scaffold.of(context).openDrawer();
              },
              child: Icon(
                Icons.menu_rounded,
                color: Colors.green,
              ),
              // Column(
              //   children: [
              //     Icon(
              //       Icons.menu_rounded,
              //       color: Colors.green,
              //     ),
              //     Text('Menu',
              //       style: TextStyle(
              //           fontSize: 10,
              //           color: Colors.green
              //       ),),
              //   ],
              // ),
            ),
          ),
        ),
      ),
      title: Text( APPLICATION_NAME ,
        style: TextStyle(color: Colors.green,
            fontFamily: 'myFont',
            letterSpacing: 4,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
