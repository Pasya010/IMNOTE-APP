abstract class NoteEvent {}

class LoadNotes extends NoteEvent {}

class AddNote extends NoteEvent {
  final String note;
  AddNote(this.note);
}

class UpdateNote extends NoteEvent {
  final String docID;
  final String newNote;
  UpdateNote(this.docID, this.newNote);
}

class DeleteNote extends NoteEvent {
  final String docID;
  DeleteNote(this.docID);
}
