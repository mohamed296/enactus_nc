import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const kSpacingUnit = 10;
//const KMainColor = Color(0xFF);

const KMainColor = Color(0xFF19355D);
const KSacandColor = Color(0xFFF6BD33);
const kDarkColor = Color(0xFF242A38);
const kDarkPrimaryColor = Color(0xFF212121);
const kDarkSecondaryColor = Color(0xFF373737);
const kLightPrimaryColor = Color(0xFFFFFFFF);
const kLightSecondaryColor = Color(0xFFF3F7FB);
const kAccentColor = Color(0xFFFFC107);

const Kpost = 'post';
const Kaddpost = 'addpost';

final CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');

// this is the post collection
final CollectionReference postCollection = FirebaseFirestore.instance.collection('Posts');

final CollectionReference commentsCollection = FirebaseFirestore.instance.collection('comments');

final CollectionReference chatCollection = FirebaseFirestore.instance.collection('Chat');

final kTitleTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.7),
  fontWeight: FontWeight.w600,
);

final kCaptionTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.3),
  fontWeight: FontWeight.w100,
);

final kButtonTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
  fontWeight: FontWeight.w400,
  color: kDarkPrimaryColor,
);
