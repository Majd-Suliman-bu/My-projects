import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_medical_clinic/main.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/bloc/chat_bloc.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/bloc/chat_event.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/bloc/chat_state.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/helper-stuff/custom_snackbar.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/helper-stuff/loadin_widget.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/helper-stuff/pic_picture_sheet.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/helper-stuff/show_bottom_sheet.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/models/message_model.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/view/widgets/message_card.dart';

bool isThisFirstMessage = true;

class ChatPagem extends StatefulWidget {
  final int therapistID;
  const ChatPagem({super.key, required this.therapistID});

  @override
  State<ChatPagem> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPagem> {
  final _textFeildController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<MessageModel> messages = [];
  late final ChatBloc chatBloc;

  @override
  void initState() {
    isThisFirstMessage = true;
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset <=
              _scrollController.position.minScrollExtent &&
          !_scrollController.position.outOfRange) {
        chatBloc.add(LoadEarlierMessagesEvent());
      }
    });
    chatBloc = context.read<ChatBloc>();
    chatBloc.add(SubscribeMessagesEvent());
  }

  bool firstTime = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstTime) {
      chatBloc.add(GetAllMessagesEvent());
      chatBloc.add(ReceiveNewMessageEvent());
      _jumpToBottom();

      firstTime = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textFeildController.dispose();
    _scrollController.dispose();
    chatBloc.add(UnsubscribeEvent());
    messages.clear();
  }

  void _jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      } else {
        print("we can't jumb to bottom, yet.");
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  bool isLoadingOrError = true;
  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatErrorState) {
          if (state.errorMessage.length > 20) {
            customSnackBarmm('Server error', context);
          } else {
            customSnackBarmm(state.errorMessage, context);
          }
        }
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
            title: const Text(
          'Chat',
        )),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatsLoadingState) {
                    return messageListShimmer();
                  } else if (state is GotAllMessagesState) {
                    messages.addAll(state.messages);
                    _jumpToBottom();
                    return listOfMessagesBody();
                  } else if (state is MessageSentState) {
                    messages.add(state.messageModel);
                    _scrollToBottom();
                    return listOfMessagesBody();
                  } else if (state is NewMessageReceivedState) {
                    if (!messages.contains(state.messageModel)) {
                      messages.add(state.messageModel);
                      _scrollToBottom();
                    }
                    return listOfMessagesBody();
                  } else if (state is EarlierMessagesLoadedState) {
                    messages.clear();
                    messages.addAll(state.earlierMessages);
                    return listOfMessagesBody(
                        noMoreMessages: state.noMoreMessages);
                  } else if (state is LoadingEarlierMessagesState) {
                    return listOfMessagesBody(isLoadingEarlierMessages: true);
                  }
                  return listOfMessagesBody();
                },
              ),
            ),
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                isLoadingOrError = (chatBloc.state is ChatsLoadingState ||
                    chatBloc.state is ChatErrorState);

                return Visibility(
                    visible: !isLoadingOrError, child: messageTextField());
              },
            )
          ],
        ),
      ),
    );
  }

  Widget listOfMessagesBody(
      {bool isLoadingEarlierMessages = false, bool noMoreMessages = false}) {
    if (messages.isEmpty) {
      return noMessageYetContainer();
    } else {
      return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          child: Column(children: [
            isLoadingEarlierMessages
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  )
                : const SizedBox(),
            noMoreMessages
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text(
                          'That was all your messages'.tr,
                          // style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          'Long press on any message to see the date'.tr,
                          // style: customTextStyle.bodySmall,
                        ),
                      ],
                    ))
                : const SizedBox(),
            const SizedBox(height: 20),
            ...List.generate(messages.length, (index) {
              MessageTypeEnum messageTypeEnum = messages[index].type;
              bool iAmTheSender = messages[index].iAmTheSender;
              switch (messageTypeEnum) {
                case MessageTypeEnum.text:
                  return MessageCard(
                    date: messages[index].timestamp,
                    iAmTheSender: iAmTheSender,
                    isConsecutiveMessage:
                        shouldMessageHaveTail(iAmTheSender, index),
                    text: messages[index].content as String?,
                    messageType: messages[index].type,
                  );
                case MessageTypeEnum.image:
                  return MessageCard(
                    date: messages[index].timestamp,
                    iAmTheSender: iAmTheSender,
                    isConsecutiveMessage:
                        shouldMessageHaveTail(iAmTheSender, index),
                    text: '',
                    imageData: messages[index].content as Uri? ?? Uri(),
                    messageType: messages[index].type,
                  );

                case MessageTypeEnum.voice:
                  return const SizedBox();
                default:
                  return const SizedBox();
              }
            })
          ]));
    }
  }

  Padding noMessageYetContainer() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Container(
              width: responsiveUtil.screenWidth,
              height: responsiveUtil.screenHeight * .1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue.withOpacity(0.1),
              ),
              child: Center(
                  child: Text(
                "No messages yet".tr,
                // style: const TextStyle(color: Colors.white, fontSize: 18)
              ))),
          const Spacer(),
        ],
      ),
    );
  }

  bool shouldMessageHaveTail(bool iAmTheSender, int index) {
    return iAmTheSender
        ? index == 0
            ? true
            : !messages[index - 1].iAmTheSender
        : index == 0
            ? true
            : messages[index - 1].iAmTheSender;
  }

  Future<void> pickImageToSend(ImageSource source, BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      final Uint8List imageBytes = await image.readAsBytes();
      final String fileName =
          image.name; // Get the file name from the XFile object
      chatBloc.add(SendMessageEvent(
        imageData: imageBytes,
        imageName: fileName,
        messageType: MessageTypeEnum.image,
      ));
    }
  }

  Widget messageTextField() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              onTap: () {
                _scrollToBottom();
              },
              cursorColor: Colors.blue,
              controller: _textFeildController,
              enabled: chatBloc.state is! ChatsLoadingState,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () async {
                    await showBottomSheetWidget(
                        context,
                        buildimageSourcesBottomSheet(context,
                            pickImage: pickImageToSend));
                  },
                ),
                hintText: 'Send a message',
                // hintStyle: const TextStyle(color: Colors.white, fontSize: 18)
                //     .copyWith(color: customColors.secondaryText)
              ),
              // style: const TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (message) {
                onSubmittedTextField(message);
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            String message = _textFeildController.text;
            onSubmittedTextField(message);
          },
        ),
      ],
    );
  }

  void onSubmittedTextField(String message) {
    message = message.trim();
    if (message.isNotEmpty) {
      if (isThisFirstMessage) {
        chatBloc
            .add(SendToBackendForNotification(patientID: widget.therapistID));
      }

      chatBloc.add(SendMessageEvent(
          message: message, messageType: MessageTypeEnum.text));
      _textFeildController.clear();
    }
  }
}
