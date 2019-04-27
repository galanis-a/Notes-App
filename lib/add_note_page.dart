import 'package:flutter/material.dart';

class AddNotePage extends StatelessWidget {
  final String note;
  final Function(String, int) doSave;
  final int noteIndex;

  const AddNotePage({this.note, @required this.doSave, this.noteIndex});

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();
    controller.text = note;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Note',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(noteIndex == null) {
            doSave(controller.text, null);
          }else {
            doSave(controller.text, noteIndex);
          }
          Navigator.pop(context);
        },
        tooltip: 'Save note',
        child: Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
