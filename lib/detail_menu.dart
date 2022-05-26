import 'package:flutter/material.dart';
import 'main.dart';

class detailMenu extends StatefulWidget {
  final String id;
  const detailMenu({Key? key, required this.id}) : super(key: key);

  @override
  State<detailMenu> createState() => _detailMenuState();
}

class _detailMenuState extends State<detailMenu> {
  API api = API();
  late Future<cMenu> detail;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detail = api.getSingleMenu(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Detail Menu",
        home: Scaffold(
            appBar: AppBar(title: Text("Detail Menu")),
            body: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: FutureBuilder<cMenu>(
                          future: detail,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              cMenu data = snapshot.data!;
                              return Column(
                                children: [
                                  Text("ID: ${data.id}"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Image(image: NetworkImage(data.images[0]),height: 60,),
                                      Image(image: NetworkImage(data.images[1]),height: 60),
                                      Image(image: NetworkImage(data.images[2]),height: 60),
                                    ],
                                  ),
                                  Text(data.name),
                                  Text(data.description),
                                ],
                              );
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }
                            return Text("Loading...");
                          },
                        ),
                      ),
                    )
                  ],
                ))));
  }
}
