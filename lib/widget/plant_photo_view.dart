

import 'dart:io';
import 'package:flutter/material.dart';

import '../styles.dart';

class PlantPhotoView extends StatelessWidget {
  final File? file;

  const PlantPhotoView({Key? key, this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.blueGrey[100],
        
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: (file == null)
            ? _buildEmptyView()
            : Image.file(
                file!,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return const Center(
      child: Text(
        'Please pick a photo',
        style: kAnalyzingTextStyle,
      ),
    );
  }
}