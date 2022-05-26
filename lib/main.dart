import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latihan_api/detail_menu.dart';

void main() {
  runApp(const MyApp());
}

//Class Menu
class cMenu {
  List<dynamic> images;
  // String image0;
  // String image1;
  // String image2;
  String id;
  String name;
  String description;

  cMenu(
      {required this.images,
      // required this.image0,
      // required this.image1,
      // required this.image2,
      required this.id,
      required this.name,
      required this.description});

  factory cMenu.fromJson(Map<String, dynamic> json) {
    return cMenu(
        images: json['images'],
        // image0: json['images'],
        // image1: json['images'],
        // image2: json['images'],
        id: json['_id'],
        name: json['menuname'],
        description: json['description']);
  }
}

//API
class API {
  Future<List<cMenu>> getAllMenu() async {
    final response = await http
        .get(Uri.parse('https://foodbukka.herokuapp.com/api/v1/menu'));
    if (response.statusCode == 200) {
      //List jsonRes = jsonDecode(respone.body);
      Map<String, dynamic> map = jsonDecode(response.body);
      List<dynamic> data = map["Result"];
      return data.map((data) => cMenu.fromJson(data)).toList();
    } else {
      throw Exception("Error getting all menu!");
    }
  }

  Future<cMenu> getSingleMenu(String id) async {
    final response = await http.get(
      Uri.parse("https://foodbukka.herokuapp.com/api/v1/menu/$id"),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      Map<String, dynamic> data = map["Result"];
      cMenu jsonResponse = cMenu.fromJson(data);
      return jsonResponse;
    } else {
      throw Exception('Error getting menu id $id!');
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  API api = API();
  late Future<List<cMenu>> list;
  @override
  void initState() {
    super.initState();
    list = api.getAllMenu();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Latihan API Restaurant",
      home: Scaffold(
        appBar: AppBar(title: const Text("Latihan API Restaurant")),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text("Semua menu:"),
              Expanded(
                  child: FutureBuilder<List<cMenu>>(
                future: list,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<cMenu> data = snapshot.data!;

                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Image(image: NetworkImage(data[index].images[0])),
                            title: Text(data[index].name),
                            subtitle: Text(data[index].description),
                            onTap: (){
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return detailMenu(id: data[index].id);
                            }));
                            },
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const Text("Loading...");
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
