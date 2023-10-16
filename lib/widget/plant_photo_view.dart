import 'dart:io';
import 'package:flutter/material.dart';

import '../styles.dart';

class PlantPhotoView extends StatelessWidget {
  final File? file;
  final String plantImageURL;

  const PlantPhotoView({Key? key, this.file, required this.plantImageURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        // width: 260,
        // height: 260,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(10.0),
        //   color: Colors.blueGrey[100],

        // ),
        Positioned(
            top: 0,
            right: 0,

            // borderRadius: BorderRadius.circular(10.0),
            child: (file == null)
                ? _buildEmptyView()
                : SizedBox(
                    height: 250,
                    width: 340,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.file(
                        file!,
                        fit: BoxFit.contain,
                      ),
                    )));
  }

  Widget _buildEmptyView() {
    // return const Center(
    //   child: Text(
    //     'Please pick a photo',
    //     style: kAnalyzingTextStyle,
    //   ),
    // );

    return Stack(
      children: [
        SizedBox(
          height: 250,
          width: 340,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Opacity(
              opacity: 0.6, // Set the opacity value here (0.0 to 1.0)
              child: Image.asset(
                plantImageURL,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 50,
          right: 50,
          top: 100,
          child: Text(
            'Match the leaf to the background for better predictions.',
            style: kAnalyzingTextStyle,
          ),
        )
      ],
    );
  }
}
