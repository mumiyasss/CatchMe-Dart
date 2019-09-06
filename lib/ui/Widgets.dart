import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Widgets {
    static Widget profilePicture(BuildContext context, String photoUrl,
        double sizeProportion) {
        double size = MediaQuery
            .of(context)
            .size
            .width * sizeProportion;
        return Container(
            width: size,
            height: size,
            child: (photoUrl == null)
                ? SvgPicture.asset('assets/profile.svg')
                : CachedNetworkImage(
                imageUrl: photoUrl,
                width: size,
                height: size,
                imageBuilder: (context, imageProvider) =>
                    Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: imageProvider
                            ),
                        ),
                    ),
                placeholder: (context, url) =>
                    Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(Random().nextInt(0xFFFFFFFF)),
                        ),
                    ),
            ),
        );
    }
}
