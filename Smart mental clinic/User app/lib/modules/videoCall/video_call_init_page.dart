import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/helper-stuff/custom_snackbar.dart';
import 'package:smart_medical_clinic/modules/videoCall/bloc/video_call_bloc.dart';
import 'package:smart_medical_clinic/modules/videoCall/call.dart';

class VideoCallInitPage extends StatefulWidget {
  const VideoCallInitPage({super.key});

  @override
  State<VideoCallInitPage> createState() => _VideoCallInitPageState();
}

class _VideoCallInitPageState extends State<VideoCallInitPage> {
  late VideoCallBloc videoCallBloc;
  bool firstTimeDidChange = true;

  @override
  void initState() {
    super.initState();
    videoCallBloc = context.read<VideoCallBloc>();
  }

  @override
  void dispose() {
    super.dispose();
    firstTimeDidChange = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstTimeDidChange) {
      firstTimeDidChange = false;
      final int patientID = Get.arguments as int? ?? -1;

      videoCallBloc.add(GetChatInformation(patientID: patientID));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) => {
        videoCallBloc.add(VideoInitEvent()),
        firstTimeDidChange = true,
      },
      child: BlocListener<VideoCallBloc, VideoCallState>(
        listener: (context, state) {
          if (state is GotVideoInfoState) {
            Get.to(VideoCallPage());
          } else if (state is VideoCallErrorState) {
            customSnackBarmm(state.error, context);
            Get.back();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.black45,
          body: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Text('preparing the video call'.tr,
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
              const Expanded(
                  child: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
