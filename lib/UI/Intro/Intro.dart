import 'package:fake_call/UI/Home.dart';
import 'package:fake_call/UI/Intro/FirstPage.dart';
import 'package:fake_call/UI/Intro/SecondPage.dart';
import 'package:fake_call/providers/IntroProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> with SingleTickerProviderStateMixin{

  TabController _tabController;
  ScrollController _scrollController;
  int _selectedIndex;
  double _scrollOffset = 0.0;
  bool checkboxValue = false;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener(_listener);
    _scrollController = new ScrollController(initialScrollOffset: 0.0,keepScrollOffset: true);
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
    super.initState();
  }

  void _listener () => setState(() =>  _selectedIndex = _tabController.index);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:new BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        persistentFooterButtons: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                elevation: 0,
                  color: Colors.green.shade50,
                  textColor: Colors.green,
                  onPressed: _selectedIndex != 0 ? (){
                    _tabController.animateTo(
                        _tabController.previousIndex,
                        curve: Curves.bounceInOut,
                        duration: Duration(milliseconds: 200)
                    );
                  } : null,
                  child: Row(
                    children: [
                      Icon(Icons.keyboard_arrow_left_rounded),
                      Text('Previous')
                    ],
                  ),
              ),
              MaterialButton(
                elevation: 0,
                color: Colors.green.shade50,
                textColor: Colors.green,
                onPressed: _selectedIndex == 0  ?
                    (){
                      _tabController.animateTo(
                          1,
                          curve: Curves.easeInBack,
                          duration: Duration(milliseconds: 200)
                      );
                }  :  context.watch<IntroProvider>().checkboxValue ? (){
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_)=> Home(),
                      ),
                          (route) => false
                  );
                } : null,
                child: Row(
                  children: [
                    Text(_selectedIndex == 0 ? 'Next' : 'Ok, I agree'),
                    Icon(Icons.keyboard_arrow_right_rounded),
                  ],
                ),
              ),
            ],
          )
        ],
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Container(
                      child: Center(
                        child: FirstPage()
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(4),
                      child: Stack(
                        children: [
                          Scrollbar(
                            thickness: 8,
                            radius: Radius.circular(10),
                            child: SingleChildScrollView(
                                controller: _scrollController,
                                padding: EdgeInsets.only(top: 80,left: 20, right: 20,bottom: 30),
                                physics: BouncingScrollPhysics(),
                                child: SecondPage(),
                              ),
                            ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.94,
                              height: 20,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0, 1.0],
                                  colors: [
                                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0),
                                    Theme.of(context).scaffoldBackgroundColor,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ),
                  ],
                  controller: _tabController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0,top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        child: Container(
                          height: _selectedIndex == 0 ? 8 : 4,
                          width: 8,
                          decoration: ShapeDecoration(
                              color: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)
                              )),
                        )
                    ),
                    Padding(padding: EdgeInsets.only(right: 2,left: 2)),
                    InkWell(
                        child: Container(
                          height: _selectedIndex != 0 ? 8 : 4,
                          width: 8,
                          decoration: ShapeDecoration(
                              color: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)
                              )),
                        )
                    )
                  ],
                ),
              )
              // TabBar(
              //   unselectedLabelColor: Colors.black,
              //   labelColor: Colors.red,
              //   tabs: [
              //     Tab(
              //       text: '1st tab',
              //     ),
              //     Tab(
              //       text: '2 nd tab',
              //     )
              //   ],
              //   controller: _tabController,
              //   indicatorSize: TabBarIndicatorSize.tab,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
