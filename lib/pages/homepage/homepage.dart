import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_dev_app/models/brew.dart';
import 'package:farm_dev_app/pages/homepage/setting_form.dart';
import 'package:farm_dev_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



import 'package:farm_dev_app/services/databaseFirebase.dart';
import 'package:farm_dev_app/pages/homepage/brew_list.dart';















class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);
  static final String id="Homepage";
  @override
  State<Homepage> createState() => _HomepageState();
}


class _HomepageState extends State<Homepage> {

  final AuthService _auth=AuthService();

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel(){
      showModalBottomSheet(context: context, builder:(context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 60.0),
          child: SettingsForm(),
        );
      });
    }

    //StreamProvider<QuerySnapshot?>.value when using DtabaseQuery().brews
    return StreamProvider<List<Brew>?>.value(
      initialData: null,
      //value is DatabaseQuery().brews when we need Query Snapshots
      //value:DatabaseQuery().brews,
      value:DatabaseQuery().brewList,
      child: Scaffold(
        appBar:AppBar(
          title:Text('Farm Dev Tech'),
          backgroundColor: Colors.blue,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(icon:Icon(Icons.person),onPressed: () async{
              await _auth.userSignOut();
            }),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: (){
                _showSettingsPanel();
              },
            ),
          ],
        ),
          body:BrewList(),
      ),
    );
  }
}
