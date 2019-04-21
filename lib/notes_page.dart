import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'add_note_page.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _notes = <String>[];

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (_notes.isEmpty) {
      await _retrieveNotes();
    }
  }

  Future<void> _retrieveNotes() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/notes.json');
      var jsonString = file.readAsString();

      final data = JsonDecoder().convert(await jsonString);
      if (data is! Map) {
        throw ('Data retrieved from file is not a Map');
      }

      data['Notes'].forEach((note) {
        setState(() {
          _notes.add(note['note']);
        });
      });
    } catch (e) {
      print('Error reading file $e');
    }
  }

  void _navigateToAddNote(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return AddNotePage(doSave: _saveNote,);
    }));
  }

  Future<void> _saveNote(String newNote) async {
    var jsonString = '{"Notes":[';
    _notes.forEach((note) {
      jsonString += '{"note":"$note"},';
    });
    jsonString += '{"note":"$newNote"}';
    jsonString += ']}';

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/notes.json');
    await file.writeAsString(jsonString);
    _notes.clear();
    await _retrieveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var _note = _notes[index];
          var _noteNumber = index + 1;

          return Container(
            height: 80.0,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('#$_noteNumber'),
                  ),
                  Text('$_note'),
                ],
              ),
            ),
          );
        },
        itemCount: _notes.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddNote(context);
        },
        tooltip: 'Add note',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
