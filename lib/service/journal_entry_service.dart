import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_app_in_flutter/data/general_entry_data.dart';

class JournalEntryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add new journal entry
  Future<void> addEntry(JournalEntry entry) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        throw Exception("User is not logged in");
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('entries')
          .add(entry.toMap());
    } catch (e) {
      print("Error adding journal entry: $e");
      rethrow;
    }
  }

  // Get journal entries
  Stream<List<JournalEntry>> getEntries() {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        throw Exception("User is not logged in");
      }

      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('entries')
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => JournalEntry.fromFireStore(doc))
                .toList(),
          );
    } catch (e) {
      print("Error getting journal entries: $e");
      rethrow;
    }
  }
}
