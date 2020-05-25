import 'package:flutter/material.dart';
import 'package:mapsminhasviagensapp/screens/maps_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _listViagens = ['Cristo Redentor', 'Grande Muralha', 'Taj Mahal', 'Mach Picchu', 'Coliseu'];
  void _abriMapa(){}
  void _excluirViagem(){}
  void _addLocal(){
   Navigator.push(context, MaterialPageRoute(builder: (_) => MapsScreen()));
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
       onPressed: (){
        _addLocal();
       },
       backgroundColor: _primaryColor,
       foregroundColor: Colors.white,
       child: Icon(Icons.add),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _listViagens.length,
              itemBuilder: (context, index){
               String title = _listViagens[index];
               return GestureDetector(
                onTap: (){
                 _abriMapa();
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
                     onPressed: (){
                      _excluirViagem();
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
      ),
    );
  }
}
