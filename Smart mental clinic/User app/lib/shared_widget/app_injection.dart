import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:smart_medical_clinic/modules/chat-mayar/bloc/chat_bloc.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/data_source/data_source.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/repo/chat_repo.dart';
import 'package:smart_medical_clinic/modules/videoCall/bloc/video_call_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Repository
  sl.registerLazySingleton<ChatRepositoryImp>(
      () => ChatRepositoryImp(chatDataSource: sl<ChatDataSource>()));

  // Datasources
  sl.registerLazySingleton<ChatDataSource>(
      () => ChatDataSource(client: http.Client()));

  // Bloc
  sl.registerLazySingleton<VideoCallBloc>(
      () => VideoCallBloc(chatRepositoryImp: sl<ChatRepositoryImp>()));

  sl.registerLazySingleton<ChatBloc>(
      () => ChatBloc(chatRepositoryImp: sl<ChatRepositoryImp>()));

  // External
}
