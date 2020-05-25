import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mapsminhasviagensapp/screens/maps_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Firestore _db = Firestore.instance;
  String id;

  Future _addListenerTraveling() async {
    final stream = _db.collection('viagens').snapshots();

    stream.listen((data) {
      _controller.add(data);
    });
  }

  void _abriMapa(String id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MapsScreen(
                  id: id,
                )));
  }

  void _excluirViagem(String id) {
    _db.collection('viagens').document(id).delete();
  }

  void _addLocal() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => MapsScreen()));
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addListenerTraveling();
  }

  @override
  Widget build(BuildContext context) {
    Color _primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: Text('Minhas Viagens'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addLocal();
        },
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _controller.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.active:
              case ConnectionState.done:
              default:
                QuerySnapshot querySnapshot = snapshot.data;
                List<DocumentSnapshot> traveling = querySnapshot.documents.toList();
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemCount: traveling.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot item = traveling[index];
                          String id = item.documentID;
                          String title = item['title'];
                          return GestureDetector(
                            onTap: () {
                              _abriMapa(id);
                            },
                            child: Card(
                              child: ListTile(
                                title: Text(title),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.remove_circle),
                                      color: Colors.red,
                                      onPressed: () {
                                        _excluirViagem(id);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
            }
          }),
    );
  }
}
