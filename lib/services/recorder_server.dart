import 'dart:async';
import 'dart:io';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

class RecordServices {
  Future startRecording(String time) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    String path = '${appDocDirectory.path}/${time.toString().codeUnits}}';
    await AudioRecorder.start(
      path: path,
      audioOutputFormat: AudioOutputFormat.AAC,
    );
  }

  Future<File> stopRecording() async {
    var recording = await AudioRecorder.stop();
    File recordingFile = File(recording.path);
    return recordingFile;
  }
}
