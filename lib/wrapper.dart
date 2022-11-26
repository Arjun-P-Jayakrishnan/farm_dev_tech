import 'package:farm_dev_app/models/user.dart';
import 'package:farm_dev_app/pages/homepage/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './pages/Authentication/login.dart';
















class Wrapper extends StatelessWidget {

  var id=Login.id;
  @override
  Widget build(BuildContext context) {

    final user=Provider.of<UserObj?>(context);

    if(user==null)
   {
     return Login();
   }
    else{
      return Homepage();
    }
  }
}