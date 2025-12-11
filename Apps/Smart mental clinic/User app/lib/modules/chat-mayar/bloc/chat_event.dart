import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/models/message_model.dart';

sealed class ChatEvent extends Equatable {}

class SendMessageEvent extends ChatEvent {
  final String message;
  final MessageTypeEnum messageType;
  final Uint8List? imageData;
  final String? imageName;
  final String timestamp =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  SendMessageEvent(
      {this.message = '',
      required this.messageType,
      this.imageData,
      this.imageName});

  @override
  List<Object?> get props => [message, messageType, imageData];
}

class SubscribeMessagesEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class ReceiveNewMessageEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class GetAllChatsEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class GetChatInformation extends ChatEvent {
  final int patientID;
  GetChatInformation({required this.patientID});
  @override
  List<Object?> get props => [];
}

class GetAllMessagesEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class UnsubscribeEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class AddImageToSendEvent extends ChatEvent {
  final Uint8List imageToSend;
  AddImageToSendEvent({required this.imageToSend});
  @override
  List<Object?> get props => [];
}

class LoadEarlierMessagesEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class SendToBackendForNotification extends ChatEvent {
  final int patientID;
  SendToBackendForNotification({required this.patientID});
  @override
  List<Object?> get props => [];
}
