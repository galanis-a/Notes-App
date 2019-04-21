import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() => runApp(NotesApp());

class NotesApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _notes = <String>[];

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if(_notes.isEmpty) {
      await _retrieveNotes();
    }
  }

  Future<void> _retrieveNotes() async {
    try{
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/notes.json');
      var jsonString = file.readAsString();

      final data = JsonDecoder().convert(await jsonString);
      if(data is! Map) {
        throw ('Data retrieved from file is not a Map');
      }

      data['Notes'].forEach((note){
        setState(() {
          _notes.add(note['note']);
        });
      });
    }catch (e) {
      print('Error reading file $e');
    }

  }

  Future<void> _saveTest() async {
    var jsonString = '{"Notes":[';
    _notes.forEach((note){
      jsonString += '{"note":"$note"},';
    });
    jsonString += '{"note":"Test note"}';
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
          _saveTest();
        },
        tooltip: 'Add note',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
