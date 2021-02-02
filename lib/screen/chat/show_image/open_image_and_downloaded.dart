import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';

class OpenImage extends StatelessWidget {
  final String url;

  const OpenImage({this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              downloadImage();
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(url)),
        ),
      ),
    );
  }

  Future downloadImage() async {
    try {
      await ImageDownloader.downloadImage(url);
    } catch (e) {
      return e;
    }
  }
}
