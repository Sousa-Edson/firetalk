class Message {
  final String username;
  final String text;
  final DateTime timestamp;

  Message({
    required this.username,
    required this.text,
    required this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      username: map['username'] ?? 'Anon',
      text: map['text'] ?? '',
      timestamp: (map['timestamp'] as DateTime?) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'username': username, 'text': text, 'timestamp': timestamp};
  }
}
