import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imnote_app/services/firestore_service.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final FirestoreService firestoreService;

  NoteBloc(this.firestoreService) : super(NoteInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
  }

  void _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) {
    emit(NoteLoading());
    firestoreService.getNotesStream().listen((snapshot) {
      final notes = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'note': doc['note'],
        };
      }).toList();
      emit(NoteLoaded(notes));
    });
  }

  Future<void> _onAddNote(AddNote event, Emitter<NoteState> emit) async {
    await firestoreService.addNote(event.note);
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NoteState> emit) async {
    await firestoreService.updateNote(event.newNote, event.docID);
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    await firestoreService.deleteNote(event.docID);
  }
}
