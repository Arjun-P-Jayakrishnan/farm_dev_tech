import 'package:farm_dev_app/models/user.dart';
import 'package:farm_dev_app/services/databaseFirebase.dart';
import 'package:farm_dev_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:farm_dev_app/shared/constants.dart';
import 'package:provider/provider.dart';


class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}





class _SettingsFormState extends State<SettingsForm> {

  GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  final List<String> sugars=['0','1','2','3','4'];

  //current Values
  String? _currentName;
  String? _currentSugar;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserObj>(context);
    print("user id ${user.uid}");
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      //reference to data in stream not firebase snapshot its flutters implementation
      builder: (context,AsyncSnapshot snapshot) {

        if(snapshot.hasData){

            UserData? userData=snapshot.data;

            return Form(
              key: _formKey,
              child: Column(
                children:<Widget>[
                  Text(
                    'Update your brew settings',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height:20.0),
                  TextFormField(
                    initialValue: userData?.name,
                    decoration: textInputDecoration,
                    validator: (val)=> val!.isEmpty ? 'Please Enter a name':null,
                    onChanged: (val)=>{setState(()=>{_currentName=val})},
                  ),
                  SizedBox(height: 20.0),
                  DropdownButtonFormField(
                    value: _currentSugar ?? userData?.sugars,
                    decoration: textInputDecoration,
                    items: sugars.map((sugar){
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars'),
                      );
                    }).toList(),
                    onChanged: (val){
                      setState(() {
                        _currentSugar=val;
                      });
                    },
                  ),

                  SizedBox(height: 20.0),
                  Slider(
                    value: (_currentStrength ?? userData!.strength).toDouble(),
                    activeColor: Colors.brown[_currentStrength ?? 100],
                    inactiveColor: Colors.brown[_currentStrength ?? 100],
                    min: 100,
                    max: 900,
                    divisions: 8,
                    onChanged: (val){
                      setState(() {
                        _currentStrength=val.round();
                      });
                    },
                  ),

                  ElevatedButton(

                    child:Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async{

                      if(_formKey.currentState!.validate()){
                        await DatabaseService(uid:user.uid).updateUserData(
                          _currentSugar ?? userData!.sugars,
                          _currentName ?? userData!.name,
                          _currentStrength ?? userData!.strength
                        );
                        Navigator.pop(context);
                      }
                    },

                  ),

                ],
              ),
            );

        }
        else{
            return Loading();
        }


      }
    );
  }
}



