import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_dev_app/models/brew.dart';

import '../models/user.dart';














class DatabaseService{

  final String uid;
  DatabaseService({required this.uid});

  //collection referance
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection("brews");

  Future updateUserData(String sugars,String name,int strength) async{

    return await brewCollection.doc(uid).set({
      'sugars':sugars,
      'name':name,
      'strength':strength,
    });

  }

  //get brews collection get snaphsot when something changes
  Stream<QuerySnapshot> get brews{

    return brewCollection.snapshots();

  }


  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){

    String _userDataJSON=jsonEncode(snapshot.data());
    Map<String,dynamic> _userData=jsonDecode(_userDataJSON);

    print("user data ${_userData["strength"]}");



    return UserData(
      uid:uid,
      name:_userData["name"],
      sugars: _userData["sugars"],
      strength: _userData["strength"],
    );

  }

  //stream to listen to chnages in brew collection and get document snapshot//not used insted used userData
  Stream<DocumentSnapshot> get userDataDocument{
    return brewCollection.doc(uid).snapshots();
  }

  Stream<UserData> get userData{
    print("brew snapshots ${brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot)}");
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }


}

class DatabaseQuery{

  //connect to database
  final CollectionReference brewCollection=FirebaseFirestore.instance.collection("brews");

  //brewList
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot){


    return snapshot.docs.map((docValue){
      print(docValue.data());
      String docVal=jsonEncode(docValue.data());
      Map<String,dynamic> docValueJson=jsonDecode(docVal);
      return Brew(name:  docValueJson["name"] ?? "", sugars: docValueJson["sugars"] ?? "0", strength: docValueJson["strength"] ?? 0);
    }).toList();
  }

  //return a Stream of Query Snapshots
  Stream<QuerySnapshot> get brews{

    return brewCollection.snapshots();

  }

  Stream<List<Brew>> get brewList{

    return brewCollection.snapshots().map(_brewListFromSnapshot);

  }


}