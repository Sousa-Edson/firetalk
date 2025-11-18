import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Salas
  Stream<List<String>> getRooms() {
    return _firestore
        .collection('rooms')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  Future<void> createRoom(String roomName) async {
    final roomRef = _firestore.collection('rooms').doc(roomName);
    final doc = await roomRef.get();
    if (!doc.exists) {
      await roomRef.set({'createdAt': FieldValue.serverTimestamp()});
    }
  }

  Future<void> deleteRoom(String roomName) async {
    await FirebaseFirestore.instance.collection('rooms').doc(roomName).delete();
  }

  // Mensagens
  Stream<List<Message>> getMessages(String roomName) {
    return _firestore
        .collection('rooms')
        .doc(roomName)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) {
                final data = doc.data();
                return Message(
                  username: data['username'] ?? 'Anon',
                  text: data['text'] ?? '',
                  timestamp:
                      (data['timestamp'] as Timestamp?)?.toDate() ??
                      DateTime.now(),
                );
              }).toList(),
        );
  }

  Future<void> sendMessage(
    String roomName,
    String username,
    String text,
  ) async {
    final messagesRef = _firestore
        .collection('rooms')
        .doc(roomName)
        .collection('messages');
    await messagesRef.add({
      'username': username,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
