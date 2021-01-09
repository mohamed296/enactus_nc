import 'dart:io';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:enactusnca/services/recorder_server.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class MessageController {
  RecordServices _recordServices = RecordServices();

  void startRecording() async {
    if (await AudioRecorder.hasPermissions) {
      String _time = getTime();
      _recordServices.startRecording(_time);
    } else {
      await askForAppPermissions();
    }
  }

  Future<String> stopRecording(String chatId) async {
    if (await AudioRecorder.hasPermissions) {
      String _time = getTime();
      File _recordFile = await _recordServices.stopRecording();
      String _fileName = '${_time.hashCode.toString()}-${_recordFile.hashCode.toString()}';
      String _url = await uploadFile(
        chatId: chatId,
        fileName: _fileName,
        file: _recordFile,
        image: false,
      );
      return _url;
    }
    return null;
  }

  Future<DateTime> selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019, 8),
      lastDate: DateTime(2100),
      useRootNavigator: true,
    );
    if (picked != null && picked != selectedDate) {
      return picked;
    } else {
      return null;
    }
  }

  String getTime() {
    final String formattedDateTime = DateFormat().add_yMd().add_jms().format(DateTime.now());
    return formattedDateTime;
  }

  Future<File> getImage() async {
    File _image;
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
    return _image;
  }

  Future uploadFile({String chatId, String fileName, bool image, File file}) async {
    try {
      StorageReference reference = FirebaseStorage.instance.ref().child('$chatId/$fileName');
      StorageUploadTask storageUploadTask;
      if (image) {
        storageUploadTask = reference.putFile(file);
      } else {
        storageUploadTask = reference.putFile(
          file,
          StorageMetadata(
            contentType: 'audio/m4a',
            customMetadata: <String, String>{'file': 'audio'},
          ),
        );
      }
      StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } catch (ex) {
      print(ex.toString());
    }
  }

  askForAppPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      // Permission.location,
      Permission.storage,
      // Permission.camera,
      Permission.microphone,
    ].request();
    return statuses;
  }
}
