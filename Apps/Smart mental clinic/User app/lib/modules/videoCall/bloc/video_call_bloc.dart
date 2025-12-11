import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:screenshot/screenshot.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/repo/chat_repo.dart';

part 'video_call_event.dart';
part 'video_call_state.dart';

class VideoCallBloc extends Bloc<VideoCallEvent, VideoCallState> {
  late String token;
  late String channelName;
  String cachedAppointmentId = '-10';
  TextEditingController videoCallReportDescriptionController =
      TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();

  ChatRepositoryImp chatRepositoryImp;
  void setToken(String newToken) {
    token = newToken;
  }

  Future<Uint8List?> takeScreenshotAndReturnImage(
      ScreenshotController screenshotController) async {
    try {
      // Capture the screenshot
      final Uint8List? image = await screenshotController.capture();

      if (image != null) {
        print('Screenshot taken!: ${image.length}');
        return image;
      } else {
        print('Failed to capture screenshot.');
      }
    } catch (e) {
      print('Error taking screenshot: $e');
    }

    return null;
  }

  VideoCallBloc({
    required this.chatRepositoryImp,
  }) : super(VideoCallInitial()) {
    on<VideoCallEvent>((event, emit) {});
    on<VideoInitEvent>((event, emit) {
      emit(VideoCallInitial());
    });
    on<GetChatInformation>((event, emit) async {
      final getData =
          await chatRepositoryImp.getChatInformation(event.patientID);
      getData.fold((l) => emit(VideoCallErrorState(error: l)), (chatInfoModel) {
        channelName = chatInfoModel.data.channelName;
        token = chatInfoModel.data.token;
        // bool isReady = chatInfoModel.data.
        emit(GotVideoInfoState());
      });
    });
    on<SendCompleteSessionEvent>((event, emit) async {
      emit(SessionCompletedLoadingState());

      final getData =
          await chatRepositoryImp.sendCompleteSession(event.appointmentId);
      getData.fold((l) => emit(VideoCallErrorState(error: l)), (done) {
        emit(SessionCompletedFromOneSideDoneState());
      });
    });
    on<CheckIfSessionCompletedEvent>((event, emit) async {
      emit(CheckIfSessionCompletedLoadingtState());

      final getData =
          await chatRepositoryImp.checkIfSessionComplete(event.appointmentId);
      getData.fold((l) => emit(VideoCallErrorState(error: l)), (done) {
        emit(SessionIsCompletedState(status: done));
      });
    });
    on<ReportVideoCallEvent>((event, emit) async {
      emit(ReportingVideoCallLoadingtState());

      final getData = await chatRepositoryImp.reportVideoCall(
          event.appointmentId,
          videoCallReportDescriptionController.text,
          event.pic);
      getData.fold((l) => emit(VideoCallReportingErrorState(errorMessage: l)),
          (done) {
        emit(ReportingVideoCallCompletedState());
      });
    });
    on<SendToBackendForNotification>((event, emit) async {
      late String userName;
      FlutterSecureStorage storage =
          const FlutterSecureStorage(); // Secure storage instance

      if (await storage.read(key: 'username') != null) {
        userName = (await storage.read(key: 'username'))!;
      } else {
        userName = 'Unkown';
      }
      await chatRepositoryImp.sendToBackendForNotification(
          event.patientID, userName, "video call");
    });
  }
}
