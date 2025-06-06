import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/helper-stuff/custom_snackbar.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/helper-stuff/show_bottom_sheet.dart';
import 'package:smart_medical_clinic/modules/videoCall/bloc/video_call_bloc.dart';
import 'package:smart_medical_clinic/shared_widget/video_call_appbar_option_mune.dart';

const appId = '94292e56f62b4ac59f1b5396df053647';

class VideoCallPage extends StatefulWidget {
  final ClientRoleType role = ClientRoleType.clientRoleBroadcaster;

  VideoCallPage({
    super.key,
  });

  @override
  State<VideoCallPage> createState() => VideoCallPageState();
}

class VideoCallPageState extends State<VideoCallPage> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool viewPanel = false;
  bool _isInitialized = false;
  late RtcEngine _engine;
  late VideoCallBloc videoCallBloc;
  String timeMessage = '';
  @override
  void initState() {
    super.initState();
    videoCallBloc = context.read<VideoCallBloc>();
    _handlePermission();
    initialize();
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  void _onToggleVideo() {
    setState(() {
      viewPanel = !viewPanel;
    });
    _engine.muteLocalVideoStream(viewPanel);
  }

  void _onCallEnd(BuildContext context) async {
    videoCallBloc.add(CheckIfSessionCompletedEvent(
        appointmentId: videoCallBloc.cachedAppointmentId));
    await showBottomSheetWidget(context, endVideoCallBottomSheet(context));
  }

  @override
  void dispose() {
    _users.clear();
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  Future<void> _handlePermission() async {
    await [Permission.camera, Permission.microphone].request();
  }

  Future<void> initialize() async {
    if (appId.isEmpty) {
      setState(() {
        _infoStrings.add('APP ID is missing, please enter your APP ID');
        _infoStrings.add("Agora Engine is not starting");
      });
      return;
    }

    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(appId: appId));

    await _engine.enableVideo();
    await _engine
        .setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    await _engine.setClientRole(role: widget.role);
    if (mounted) {
      _addAgoraEventHandlers();
    }
    VideoEncoderConfiguration configuration = const VideoEncoderConfiguration(
      dimensions: VideoDimensions(width: 1080, height: 720),
    );
    await _engine.setVideoEncoderConfiguration(configuration);

    await _engine.joinChannel(
      token: videoCallBloc.token,
      channelId: videoCallBloc.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );

    setState(() {
      _isInitialized = true;
    });
  }

  void _addAgoraEventHandlers() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (err, msg) {
          setState(() {
            final info = 'Error $err: $msg';
            _infoStrings.add(info);
          });
        },
        onJoinChannelSuccess: (connection, elapsed) {
          setState(() {
            final info = 'Join Channel: $connection';
            _infoStrings.add(info);
          });
        },
        onLeaveChannel: (connection, stats) {
          // setState(() {
          final info = 'Leave Channel: $stats';
          _infoStrings.add(info);
          // });
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          setState(() {
            final info = 'User Joined: $remoteUid';
            _infoStrings.add(info);
            _users.add(remoteUid);
          });
        },
        onUserOffline: (connection, remoteUid, reason) {
          setState(() {
            final info = 'User Offline: $remoteUid';
            _infoStrings.add(info);
            _users.remove(remoteUid);
          });
        },
      ),
    );
  }

  Widget _viewRows() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRoleType.clientRoleBroadcaster) {
      list.add(AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine,
          canvas: const VideoCanvas(uid: 0),
        ),
      ));
    }
    for (var uid in _users) {
      list.add(AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: uid),
          connection: RtcConnection(channelId: videoCallBloc.channelName),
        ),
      ));
    }
    final views = list;
    return list.length == 1
        ? Column(
            children: [
              const Text(
                "Wating for another user to enter the session",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const Icon(Icons.hourglass_empty_rounded, color: Colors.blue),
              Expanded(child: views[0]),
            ],
          )
        : Stack(
            children: [
              // Add all other elements first
              Column(
                children: List.generate(views.length - 1, (index) {
                  return Expanded(
                    child: views[index + 1],
                  );
                }),
              ),
              // Add the first element last to make sure it's on top
              myCameraView(views),
              Positioned(
                  left: Get.size.height * .4,
                  child: Text(
                    timeMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 20),
                  ))
            ],
          );
  }

  double myCameraViewOnTop = 10;
  double myCameraViewOnleft = 10;
  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      myCameraViewOnTop += details.delta.dy;
      myCameraViewOnleft += details.delta.dx;
    });
  }

  Positioned myCameraView(List<StatefulWidget> views) {
    return Positioned(
      top: myCameraViewOnTop,
      left: myCameraViewOnleft,
      child: GestureDetector(
        onPanUpdate: _onDragUpdate,
        child: Container(
          height: 200,
          width: 150,
          alignment: Alignment.topCenter,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10), child: views[0]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VideoCallBloc, VideoCallState>(
      listener: (context, state) {
        if (state is SessionCompletedFromOneSideDoneState) {
          customSnackBarmm('Your request was received successfully.', context,
              isFloating: true);
        } else if (state is VideoCallErrorState) {
          customSnackBarmm(state.error, context, isFloating: true);
        } else if (state is VideoCallReportingErrorState) {
          customSnackBarmm(state.errorMessage, context, isFloating: true);
        }
      },
      child: Screenshot(
        controller: videoCallBloc.screenshotController,
        child: Scaffold(
          backgroundColor: Colors.black45,
          appBar: AppBar(
            title: const Text(
              'Video Call',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            actions: [
              buildAppbarVedieCallMenu(
                  context, videoCallBloc.cachedAppointmentId),
            ],
          ),
          body: Center(
            child: Stack(
              children: [
                _isInitialized
                    ? _viewRows()
                    : const Center(
                        child: CircularProgressIndicator(
                        color: Colors.blue,
                      )),
                _toolbar(),
              ],
            ), // Show a loading indicator until initialized
          ),
        ),
      ),
    );
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          muteButton(),
          const SizedBox(
            width: 20,
          ),
          callEndButton(),
          const SizedBox(
            width: 20,
          ),
          switchCameraButton(),
          const SizedBox(
            width: 20,
          ),
          muteVideoButton(),
        ],
      ),
    );
  }

  FloatingActionButton muteVideoButton() {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: () => _onToggleVideo(),
      heroTag: "btn3",
      backgroundColor:
          viewPanel ? Color(0xff14181b) : Colors.black54.withOpacity(0.3),
      child: Icon(
        viewPanel ? Icons.videocam_off : Icons.videocam,
        color: Colors.white,
      ),
    );
  }

  FloatingActionButton switchCameraButton() {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: _onSwitchCamera,
      heroTag: "btn2",
      backgroundColor: Colors.black54.withOpacity(0.3),
      child: const Icon(Icons.switch_camera, color: Colors.white),
    );
  }

  FloatingActionButton callEndButton() {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: () => _onCallEnd(context),
      heroTag: "btn1",
      backgroundColor: Colors.redAccent,
      child: const Icon(Icons.call_end, color: Colors.white),
    );
  }

  FloatingActionButton muteButton() {
    return FloatingActionButton(
      shape: const CircleBorder(),
      onPressed: () => _onToggleMute(),
      backgroundColor:
          muted ? Color(0xff14181b) : Colors.black54.withOpacity(0.3),
      child: Icon(
        muted ? Icons.mic_off : Icons.mic,
        color: Colors.white,
      ),
    );
  }

  Widget endVideoCallBottomSheet(BuildContext context) {
    return BlocBuilder<VideoCallBloc, VideoCallState>(
      builder: (context, state) {
        if (state is SessionIsCompletedState) {
          return endVideoCallBottomSheetBody(context, state.status);
        } else if (state is VideoCallErrorState) {
          return tryAgain();
        }
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.blue,
        ));
      },
    );
  }

  Center tryAgain() {
    return Center(
        child: Column(
      children: [
        Text(
          'Error, Try agin'.tr,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        // ... existing code ...
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: GestureDetector(
            onTap: () {
              videoCallBloc.add(CheckIfSessionCompletedEvent(
                  appointmentId: videoCallBloc.cachedAppointmentId));
            },
            child: Text(
              'Try again'.tr,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
// ... existing code ...
      ],
    ));
  }

  Container endVideoCallBottomSheetBody(BuildContext context, bool status) {
    return Container(
        padding: const EdgeInsets.all(20),
        height: Get.size.height * .35,
        decoration: const BoxDecoration(
          color: Color(0xff14181b),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to end this video call session? The session will only be fully ended if both users agree. If you end the session without mutual agreement, the other user may choose to report this action?'
                    .tr,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    '${'Both agree:'.tr} ',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    status ? "Agreed".tr : "Do Not Agree".tr,
                    style: const TextStyle(color: Colors.white, fontSize: 18)
                        .copyWith(color: status ? Colors.green : Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  yesButton(),
                  noButton(context),
                ],
              ),
            ],
          ),
        ));
  }

  ElevatedButton noButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.red),
      ),
      onPressed: () {
        Navigator.pop(context); // Close the bottom sheet
      },
      child: Text(
        'No'.tr,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  ElevatedButton yesButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.blue),
      ),
      onPressed: () {
        _engine.leaveChannel();

        Get.back();
        Get.back();
        Get.back();
      },
      child: Text(
        'Yes'.tr,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
