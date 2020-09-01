import 'package:enactusnca/Widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PostImage extends StatelessWidget {
  final imageUrl;
  PostImage({this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      width: double.infinity,
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
      margin: EdgeInsets.symmetric(horizontal: 1.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
            return loadingProgress == null
                ? child
                : Center(
                    child: SpinKitFoldingCube(
                      //color: Theme.of(context).primaryColor,
                      color: KSacandColor,
                      size: 18.0,
                    ),
                  );
          },
        ),
      ),
    );
  }
}
