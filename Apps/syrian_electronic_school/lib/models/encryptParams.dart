import 'dart:isolate';

class EncryptParams {
  final List<int> bytes;
  final String filePath;
  final SendPort sendPort;

  EncryptParams(this.bytes, this.filePath, this.sendPort);
}
