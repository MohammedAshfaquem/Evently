import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FireStoreMyServivce {
    var now = DateTime.now();
  final CollectionReference myevents =
      FirebaseFirestore.instance.collection('My Events');
              User? user = FirebaseAuth.instance.currentUser;

  Future<void> addmyevents(
     String category, // CameraMan, MakeupArtist, Caterers, Invitations
     String hosterName,
     String number,
     String eventName,
     String location,
     String amount,
     String description,
     String image,
     DateTime time,
     String eventId,
      ) {
    return myevents.add({
       'category': category,
      'hostername': hosterName, // ✅ Ensure consistent key names
      'number': number,
      'eventname': eventName,
      'location': location,
      'amount': amount,
      'description': description,
      'image': image,
      'time': Timestamp.fromDate(time), 
      'uid': user?.uid,
      'eventid': eventId,
      'timestamp': FieldValue.serverTimestamp(), 
      
    });
  }

  Future<void> deletenote(String docId) {
    return myevents.doc(docId).delete();
  }

  Stream<QuerySnapshot> getNotesStream() {
    final notesstream =
        myevents.orderBy('time', descending: true).snapshots();
    return notesstream;
  }
}
