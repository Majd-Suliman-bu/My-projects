class ChatResponse {
  final String recipientId;
  final String? text;
  final List<Button>? buttons;
  final CustomData? custom;

  ChatResponse({
    required this.recipientId,
    this.text,
    this.buttons,
    this.custom,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      recipientId: json['recipient_id'],
      text: json['text'] ??
          (json['custom'] != null ? json['custom']['text'] : null),
      buttons: json['buttons'] != null
          ? (json['buttons'] as List).map((i) => Button.fromJson(i)).toList()
          : null,
      custom:
          json['custom'] != null ? CustomData.fromJson(json['custom']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipient_id': recipientId,
      'text': text,
      'buttons': buttons?.map((button) => button.toJson()).toList(),
      'custom': custom?.toJson(),
    };
  }
}

class Button {
  final String title;
  final String payload;

  Button({
    required this.title,
    required this.payload,
  });

  factory Button.fromJson(Map<String, dynamic> json) {
    return Button(
      title: json['title'],
      payload: json['payload'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'payload': payload,
    };
  }
}

class CustomData {
  final String? type; // Make type nullable
  final String? doctorName;
  final String? doctorCity;
  final int? id;

  CustomData({
    this.type, // Update constructor
    required this.doctorName,
    required this.doctorCity,
    required this.id,
  });

  factory CustomData.fromJson(Map<String, dynamic> json) {
    return CustomData(
      type: json['type'], // No need to handle null explicitly, it's nullable
      doctorName: json['doctor_name'],
      doctorCity: json['doctor_city'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'doctor_name': doctorName,
      'doctor_city': doctorCity,
      'id': id,
    };
  }
}
