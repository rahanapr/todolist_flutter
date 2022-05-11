import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoHomeScreen extends StatelessWidget {
   TodoHomeScreen({ Key? key }) : super(key: key);

  final TextEditingController _controller = TextEditingController();

 void _addTask(){
   FirebaseFirestore.instance.collection("todos").add({
     'title':_controller.text
   });
  }

  onDelete(String id){
    FirebaseFirestore.instance.collection("todos").doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('todoList'),),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Type here'),
                    
                  ),
                ),
              ),
               TextButton(onPressed: (() {
                 _addTask();
               }), 
          child:const Text('add Task'))
            ],
          ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("todos").snapshots(),
          builder:(context,snapshot){
            if(!snapshot.hasData){
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child:  CircularProgressIndicator(),
              );
            }else{
              return Expanded(
                child: ListView(
                  children:snapshot.data!.docs.map((document) {
                    return Dismissible(
                      key: Key(document.id),
                      onDismissed: (direction){
                        onDelete(document.id);
                      },
                      background: Container(
                        color: Colors.red[300],
                        child: const Icon(Icons.delete),
                        
                      ),
                      child: ListTile(
                        title: Text(document["title"]),
                        trailing: const Icon(Icons.navigate_next),
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          } ,
          )
        ],
      ),
    );
  }
}