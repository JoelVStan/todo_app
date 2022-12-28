import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/screens/add_task.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid = '';
  @override
  void initState() {
    getuid();
    super.initState();
  }

  getuid(){
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    setState(() {
      uid = user!.uid;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TODO'), backgroundColor: Colors.blue,),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(stream: FirebaseFirestore.instance.collection('tasks').doc(uid).collection('mytasks').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else{
            final docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length, 
              itemBuilder: (context, index) {
                return Container(
                  height: 200,
                  child: Column(children: [
                    Text(docs[index]['title'])
                ]),
              );
            },);
          }
        },),
        //color: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.blue, //Theme.of(context).primaryColor
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTask()));
        }),
    );
  }
}