import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '../classifier/classifier.dart';
import '../styles.dart';
import 'plant_photo_view.dart';

const _labelsFileName = 'assets/labels_potato.txt';
const _modelFileName = 'model_unquant_potato.tflite';

class PlantRecogniserPotato extends StatefulWidget {
  const PlantRecogniserPotato ({super.key});

  @override
  State<PlantRecogniserPotato > createState() => _PlantRecogniserState();
}

enum _ResultStatus {
  notStarted,
  notFound,
  found,
}

class _PlantRecogniserState extends State<PlantRecogniserPotato > {
  bool _isAnalyzing = false;
  final picker = ImagePicker();
  File? _selectedImageFile;

  // Result
  _ResultStatus _resultStatus = _ResultStatus.notStarted;
  String _plantLabel = ''; // Name of Error Message
  double _accuracy = 0.0;

  late Classifier _classifier;

  @override
  void initState() {
    super.initState();
    _loadClassifier();
  }

  Future<void> _loadClassifier() async {
    debugPrint(
      'Start loading of Classifier with '
      'labels at $_labelsFileName, '
      'model at $_modelFileName',
    );

    final classifier = await Classifier.loadWith(
      labelsFileName: _labelsFileName,
      modelFileName: _modelFileName,
    );
    _classifier = classifier!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.pop(context); // Navigate back to the home page
      //     },
      //   ),

      //   title: const Text('My Page'),
      //   backgroundColor: Colors.green,
      // ),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        onTap: (label) => {Navigator.pop<PlantRecogniserPotato >(context)},
      ),

      body: Container(
        color: kBgColor,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
             
              const Text.rich(
                TextSpan(
                  text: 'crop',
                  style: TextStyle(fontSize: 20.0),
                  children: [
                    TextSpan(
                        text: 'Disease',
                        style: TextStyle(
                            fontSize: 50.0, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' Detector',
                        style: TextStyle(fontSize: 30.0, color: Colors.green)),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),
              // Padding(
              //   padding: const EdgeInsets.only(top: 30),
              //   child: _buildTitle(),
              // ),
          
              _buildPhotolView(),
              const SizedBox(height: 20),
              
              _buildResultView(),
             const SizedBox(height: 80),

             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
              _buildPickPhotoButtonfromcamera(
                title: 'Take a photo',
                source: ImageSource.camera,
              ),
              const SizedBox(width: 30), 
              _buildPickPhotoButtonfromgallery(
                title: 'Pick from gallery',
                source: ImageSource.gallery,
              )]),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotolView() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        PlantPhotoView(file: _selectedImageFile),
        _buildAnalyzingText(),
      ],
    );
  }

  Widget _buildAnalyzingText() {
    if (!_isAnalyzing) {
      return const SizedBox.shrink();
    }
    return const Text('Analyzing...', style: kAnalyzingTextStyle);
  }

  // Widget _buildTitle() {
  //   return const Text(
  //     'Crop Disease Recognizer',
  //     style: kTitleTextStyle,
  //     textAlign: TextAlign.center,
  //   );
  // }

  Widget _buildPickPhotoButtonfromgallery({
    required ImageSource source,
    required String title,
  }) {
    return IconButton(
      onPressed: () => _onPickPhoto(source),
      icon: const Icon(Icons.photo_library,size: 50),
    );
  }
    Widget _buildPickPhotoButtonfromcamera({
    required ImageSource source,
    required String title,
  }) {
    return IconButton(
      onPressed: () => _onPickPhoto(source),
      icon: const Icon(Icons.camera_alt, size: 50,),
    );
  }

  void _setAnalyzing(bool flag) {
    setState(() {
      _isAnalyzing = flag;
    });
  }

  void _onPickPhoto(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) {
      return;
    }

    final imageFile = File(pickedFile.path);
    setState(() {
      _selectedImageFile = imageFile;
    });

    _analyzeImage(imageFile);
  }

  void _analyzeImage(File image) {
    _setAnalyzing(true);

    final imageInput = img.decodeImage(image.readAsBytesSync())!;

    final resultCategory = _classifier.predict(imageInput);

    final result = resultCategory.score >= 0
        ? _ResultStatus.found
        : _ResultStatus.notFound;
    final plantLabel = resultCategory.label;
    final accuracy = resultCategory.score;

    _setAnalyzing(false);

    setState(() {
      _resultStatus = result;
      _plantLabel = plantLabel;
      _accuracy = accuracy;
    });
  }

  Widget _buildResultView() {
    var title = '';

    if (_resultStatus == _ResultStatus.notFound) {
      title = 'Fail to recognise';
    } else if (_resultStatus == _ResultStatus.found) {
      title = _plantLabel;
    } else {
      title = '';
    }

    //
    var accuracyLabel = '';
    if (_resultStatus == _ResultStatus.found) {
      accuracyLabel = 'Accuracy: ${(_accuracy * 100).toStringAsFixed(2)}%';
    }

    return Column(
      children: [
        Text(title, style: kResultTextStyle),
        const SizedBox(height: 10),
        Text(accuracyLabel, style: kResultRatingTextStyle)
      ],
    );
  }
}
