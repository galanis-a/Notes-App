import 'package:flutter/material.dart';
import 'package:notes_app/notes_page.dart';
import 'package:notes_app/add_note_page.dart';
import 'package:notes_app/note_arguments.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final NoteArguments args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => NotesPage());
      case '/add':
        if(args.doSave is Function(String, int)) {
          return MaterialPageRoute(builder: (_) => AddNotePage(doSave: args.doSave, noteIndex: null));
        }

        return _errorRoute();

      case '/edit':
        if(args.doSave is Function(String, int) && args.noteIndex is int && args.note is String) {
          return MaterialPageRoute(builder: (_) => AddNotePage(doSave: args.doSave, noteIndex: args.noteIndex, note: args.note));
        }

        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}