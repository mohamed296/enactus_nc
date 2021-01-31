import 'dart:io';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:enactusnca/services/recorder_server.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class MessageController {
  final RecordServices _recordServices = RecordServices();

  startRecording() async {
    if (await AudioRecorder.hasPermissions) {
      final String _time = getTime();
      _recordServices.startRecording(_time);
    } else {
      await askForAppPermissions();
    }
  }

  Future<dynamic> stopRecording(String chatId) async {
    if (await AudioRecorder.hasPermissions) {
      final String _time = getTime();
      final File _recordFile = await _recordServices.stopRecording();
      final String _fileName = '${_time.hashCode.toString()}-${_recordFile.hashCode.toString()}';
      final dynamic _url = await uploadFile(
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
    final DateTime selectedDate = DateTime.now();
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

  Future<dynamic> uploadFile({String chatId, String fileName, bool image, File file}) async {
    try {
      final StorageReference reference = FirebaseStorage.instance.ref().child('$chatId/$fileName');
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
      final StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
      final dynamic url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } catch (ex) {
      return ex.toString();
    }
  }

  Future<Map<Permission, PermissionStatus>> askForAppPermissions() async {
    final Map<Permission, PermissionStatus> statuses = await [
      // Permission.location,
      Permission.storage,
      // Permission.camera,
      Permission.microphone,
    ].request();
    return statuses;
  }
}
