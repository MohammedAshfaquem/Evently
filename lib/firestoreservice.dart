import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreService {
  User? user = FirebaseAuth.instance.currentUser;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to add an event to Firestore
  Future<void> addEvent({
    required String category, // CameraMan, MakeupArtist, Caterers, Invitations
    required String hosterName,
    required String number,
    required String eventName,
    required String location,
    required String amount,
    required String description,
    required String image,
    required DateTime time,
    required String eventId,
  }) async {
    
    // Reference to the specific category collection inside "Events"
    final CollectionReference eventCategoryCollection =
        _firestore.collection("Events").doc(category).collection("Listings");

    await eventCategoryCollection.doc(eventId).set({
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

  // Fetch events based on category
  Stream<QuerySnapshot> getEventsByCategory(String category) {
    return _firestore
        .collection("Events")
        .doc(category)
        .collection("Listings")
        .orderBy('timestamp', descending: true) // ✅ Order by latest events
        .snapshots();
  }
}
