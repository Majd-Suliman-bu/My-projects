// import 'package:get/get.dart';
// import 'package:smart_medical_clinic/modules/chat-mayar/repo/chat_repo.dart';
// import 'package:smart_medical_clinic/shared_widget/app_injection.dart';

// class ChatInitController extends GetxController {
//   ChatRepositoryImp chatRepositoryImp = ChatRepositoryImp(chatDataSource: sl());

//   var channelName = ''.obs;
//   var isLoading = false.obs;
//   var errorMessage = ''.obs;

//   void getChatInformation(int patientID) async {
//     isLoading.value = true;
//     final getData = await chatRepositoryImp.getChatInformation(patientID);
//     getData.fold(
//       (error) {
//         errorMessage.value = error;
//         isLoading.value = false;
//       },
//       (chatInfoModel) {
//         channelName.value = chatInfoModel.data.channelName;
//         isLoading.value = false;
//       },
//     );
//   }
// }
