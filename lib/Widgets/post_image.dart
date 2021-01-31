import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:enactusnca/Widgets/constants.dart';

class PostImage extends StatelessWidget {
  final String imageUrl;
  const PostImage({
    Key key,
    this.imageUrl,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.0,
      width: double.infinity,
      child: ClipRRect(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
            return loadingProgress == null
                ? child
                : Center(
                    child: SpinKitFoldingCube(
                      color: kSacandColor,
                      size: 18.0,
                    ),
                  );
          },
        ),
      ),
    );
  }
}
