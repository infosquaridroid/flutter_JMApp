import 'package:jmapp/helpers/constants.dart';
import 'package:jmapp/helpers/strings.dart';
import 'package:jmapp/helpers/widget_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jmapp/helpers/colors.dart';
import 'package:jmapp/helpers/font_constant.dart';
import 'package:jmapp/helpers/image_constant.dart';
import 'package:jmapp/helpers/sharepreference_helper.dart';
import 'package:jmapp/pages/Home.dart';
import 'package:jmapp/pages/Menu.dart';
import 'package:jmapp/pages/SignupDetail.dart';

class Bottombar extends StatefulWidget {


  @override
  BottombarState createState() => BottombarState();
}

class BottombarState extends State<Bottombar> {
   List<Widget> _children;
   int _currentIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _children = [
       Home(),
       Container(),
       Container(),
       Container(),
       Menu()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index){
          this.setState(() {_currentIndex = index;});
        }, // new
        currentIndex: _currentIndex,
        fixedColor: ColorsHelper.themeColor,
        type: BottomNavigationBarType.fixed,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home',style: TextStyle(fontSize: 13)),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.grade),
            title: Text('Favourites',style: TextStyle(fontSize: 13)),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.autorenew),
              title: Text('Recurring',style: TextStyle(fontSize: 13))
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.more_vert),
              title: Text('Transaction',style: TextStyle(fontSize: 13))
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              title: Text('Menu',style: TextStyle(fontSize: 13))
          )
        ],
      ),
    );
  }
}
