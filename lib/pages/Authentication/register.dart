import 'package:farm_dev_app/shared/constants.dart';
import 'package:farm_dev_app/shared/loading.dart';
import 'package:flutter/material.dart';

import '../../services/auth.dart';

















class Register extends StatefulWidget {

  final Function toggleView;
  Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth=AuthService();

  //check if the form is valid
  final _formKey=GlobalKey<FormState>();

  bool loading =false;

  //text field state
  String email='';
  String password='';
  String error='';

  @override
  Widget build(BuildContext context) {
    return loading?Loading(): Scaffold(
        appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              title: Text('Sign Up'),
              elevation: 0.0,
                actions: <Widget>[
                  IconButton(icon:Icon(Icons.person),onPressed: (){
                    widget.toggleView();
                  })
                ],
        ),
        body:Container(
          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
          child: Center(
                  child:Form(
                    key: _formKey,
                    child:Column(
                      children: <Widget>[
                        SizedBox(height:20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(hintText:'Email'),
                          validator: (val)=> val!.isEmpty? "Enter an email" :null,
                            onChanged: (val){
                              setState(() {
                                email=val;
                              });
                            }),
                        SizedBox(height:20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(hintText: 'Password'),
                          validator: (val) => val!.length<6? "Enter a password 6+ characters long" : null,
                            obscureText: true,
                            onChanged:(val){
                              setState(() {
                                password=val;
                              });
                            } ),
                        SizedBox(height:20.0),
                        ElevatedButton(
                            child:Text('Register',
                                style: TextStyle(color: Colors.brown)),
                            onPressed:() async {
                              if(_formKey.currentState!.validate()){
                                setState(() {
                                  loading=true;
                                });
                                dynamic result= await _auth.registerWithEmailAndPassword(email, password);
                                if(result==null){
                                    setState(() {
                                      loading=false;
                                      error = 'please provide a valid email ';
                                    }
                                    );
                                }

                              }
                            } ),
                          SizedBox(height:12.0),
                          Text(
                            error,
                            style: TextStyle(color:Colors.red,fontSize: 14.0),
                          )
                      ],
                    ),
                  ),
          ),
        ),
    );
  }
}
