import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  addtasktofirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    String uid = user!.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
    .collection('taks')
    .doc(uid)
    .collection('mytaks')
    .doc(time.toString())
    .set({
      'title':titleController.text,
      'description':descController.text,
      'time':time.toString()
    });
    Fluttertoast.showToast(msg: 'Data Added');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task'), backgroundColor: Colors.blue,
      ),
      body: Container(padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: TextField(
              controller: titleController,
              decoration: InputDecoration( labelText: 'Enter Title',
                border: OutlineInputBorder()
              ),
            ),
            ),
            const SizedBox(height: 10),
            Container(
              child: TextField(
              controller: descController,
              decoration: InputDecoration( labelText: 'Enter Description',
                border: OutlineInputBorder()
              ),
            ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if(states.contains(MaterialState.pressed))
                      return Colors.blue.shade400;
                    return Colors.blue;
                  })),
                  onPressed: () {
                    addtasktofirebase();
                  }, 
                  child: Text('Add Task', style: GoogleFonts.roboto(fontSize: 16)) ),
            )
            
          ],
        ),
      ),
    );
  }
}