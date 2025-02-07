import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  // collection path
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  // get current UID
  String get currentUID => FirebaseAuth.instance.currentUser?.uid ?? '';

  // stream notes
  Stream<QuerySnapshot> getNotesStream() {
    return users
        .doc(currentUID)
        .collection('notes')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // add note
  Future<void> addNote(String note) async {
    await users.doc(currentUID).collection('notes').add({
      'note': note,
      'timestamp': Timestamp.now(),
      'uid': currentUID,
    });
  }

  // update note
  Future<void> updateNote(String docID, String newNote) async {
    await users.doc(currentUID).collection('notes').doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  // delete note
  Future<void> deleteNote(String docID) async {
    await users.doc(currentUID).collection('notes').doc(docID).delete();
  }
}
