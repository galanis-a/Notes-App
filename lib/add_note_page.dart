import 'package:flutter/material.dart';

class AddNotePage extends StatelessWidget {
  final String note;
  final Function(String, int) doSave;
  final int noteIndex;
  final Function(int) doDelete;

  const AddNotePage({this.note, @required this.doSave, this.noteIndex, this.doDelete});

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();
    controller.text = note;

    _getActions() {
      if(noteIndex != null) {
        return [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              doDelete(noteIndex);
              Navigator.pop(context);
            },
          ),
        ];
      }else {
        return null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
        actions: _getActions(),
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
