class ChatMessage {
  final String text;
  final bool isSentByMe;
  final DateTime timestamp;
  final bool isClickable; // Add isClickable field

  ChatMessage({
    required this.text,
    required this.isSentByMe,
    required this.timestamp,
    this.isClickable = false, // Default to false if not provided
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isSentByMe': isSentByMe,
      'timestamp': timestamp.toIso8601String(),
      'isClickable': isClickable, // Include isClickable in JSON
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'],
      isSentByMe: json['isSentByMe'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      isClickable: json['isClickable'] ?? false, // Handle null case
    );
  }
}
