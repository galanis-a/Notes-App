import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:notes_app/note_arguments.dart';

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

  Future<void> _saveEditedNote(String noteText, int index) async {
    _notes[index] = noteText;
    await refreshNotes();
  }

  Future<void> refreshNotes() async {
    var jsonString = convertNotesToJson();

    await saveNotesToFile(jsonString);
    _notes.clear();
    await _retrieveNotes();
  }

  String convertNotesToJson() {
    var jsonString = '{"Notes":[';
    _notes.asMap().forEach((i, note) {
      if (i + 1 == _notes.length) {
        jsonString += '{"note":"$note"}';
      } else {
        jsonString += '{"note":"$note"},';
      }
    });
    jsonString += ']}';

    return jsonString;
  }

  Future<void> saveNotesToFile(String jsonNotes) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/notes.json');
    await file.writeAsString(jsonNotes);
  }

  Future<void> _saveNote(String newNote, int index) async {
    _notes.add(newNote);
    await refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _deleteNote(index) async {
      setState(() {
        _notes.removeAt(index);
      });
      await refreshNotes();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var _note = _notes[index];
          var _noteNumber = index + 1;

          return Dismissible(
            key: Key(_note),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              _deleteNote(index);
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('Note deleted')));
            },
            background: Container(
              color: Colors.red,
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            child: Container(
              height: 80.0,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/edit',
                    arguments: NoteArguments(
                        note: _note,
                        doSave: _saveEditedNote,
                        noteIndex: index,
                        doDelete: _deleteNote)),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('#$_noteNumber'),
                      ),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            '$_note',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: _notes.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .pushNamed('/add', arguments: NoteArguments(doSave: _saveNote)),
        tooltip: 'Add note',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
