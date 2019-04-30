class NoteArguments {
  final String note;
  final Function(String, int) doSave;
  final int noteIndex;
  final Function(int) doDelete;

  NoteArguments({this.note, this.doSave, this.noteIndex, this.doDelete});
}