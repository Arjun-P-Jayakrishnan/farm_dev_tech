import 'dart:convert';

import 'package:farm_dev_app/models/brew.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'brew_tile.dart';



class BrewList extends StatefulWidget {
  const BrewList({Key? key}) : super(key: key);

  @override
  State<BrewList> createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {

    //to get QuerySnapshot values from net when database changes
    //final brews=Provider.of<QuerySnapshot>(context);
    //print(brews.docs);

    final brews=Provider.of<List<Brew>?>(context) ?? [];

      //brews.docs for going through the data
      brews.forEach((brew){
        print(brew.name);
        print(brew.strength);
        print(brew.sugars);
      });

    return ListView.builder(
        itemCount: brews.length,
        itemBuilder: (context,index){
          return BrewTile(brew:brews[index]);
        }
    );
  }
}

