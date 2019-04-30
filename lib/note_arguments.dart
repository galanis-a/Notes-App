class NoteArguments {
  final String note;
  final Function(String, int) doSave;
  final int noteIndex;

  NoteArguments({this.note, this.doSave, this.noteIndex});
}