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
            icon: Icon(Icons.file_download),
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
    //StorageReference rec = FirebaseStorage.instance.ref().child('$url');

    // Dio dio = Dio();
    try {
      /* final String image = await rec.getDownloadURL();
      Response response = await dio.get(image);
      final Directory dir = Directory.systemTemp;
      final File file = File('${dir.path}/tmp.jpg');
      await file.create();
      final StorageFileDownloadTask task = rec.writeToFile(file);*/

      var imageId = await ImageDownloader.downloadImage(url);

      /* var path = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);*/
      //  var dir =  await getExternalStorageDirectories(type: StorageDirectory.downloads);
      // await dio.download(url, "$dir/myimage.jpg");

      //File file =File(dir)as List;
      //var raf = file.openSync(mode: FileMode.write);
      // raf.writFromSync(response.data);
    } catch (e) {}
  }
}
