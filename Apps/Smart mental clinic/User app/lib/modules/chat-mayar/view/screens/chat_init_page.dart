import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/bloc/chat_bloc.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/bloc/chat_event.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/bloc/chat_state.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/helper-stuff/custom_snackbar.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/view/screens/chat_page.dart';

class ChatInitPage extends StatefulWidget {
  final int therapistID;
  const ChatInitPage({super.key, required this.therapistID});

  @override
  State<ChatInitPage> createState() => _ChatInitPageState();
}

class _ChatInitPageState extends State<ChatInitPage> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  late String _token = '';

  Future<void> getToken() async {
    String? token = await _storage.read(key: "accessToken");
    _token = token!;
    print(_token);
  }

  late ChatBloc chatBloc;

  // late ChatInitController chatInitController;
  @override
  void initState() {
    super.initState();
    chatBloc = context.read<ChatBloc>();
  }

  bool firstTimeDidChange = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstTimeDidChange) {
      firstTimeDidChange = false;
      chatBloc.add(GetChatInformation(patientID: widget.therapistID));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        print('the state in init page   $state');
        if (state is GotChatInfoState) {
          print('the state in init page  ininni $state');
          Get.off(ChatPagem(therapistID: widget.therapistID));
          print('new new');
        } else if (state is ChatErrorState) {
          customSnackBarmm(state.errorMessage, context);
          Get.back();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Text('preparing the chat'.tr,
                style: const TextStyle(color: Colors.blue)),
            const Expanded(
                child: Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ))
          ],
        ),
      ),
    );
  }
}
