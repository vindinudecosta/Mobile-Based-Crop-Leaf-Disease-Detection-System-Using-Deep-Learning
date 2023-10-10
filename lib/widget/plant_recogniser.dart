import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '../classifier/classifier.dart';
import '../styles.dart';
import 'plant_photo_view.dart';
//import '/common/plant_databse.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
// import '/insert_leafdata.dart';

const _labelsFileName = 'assets/labels_leaves.txt';
const _modelFileName = 'tflite_model_leaves_v1.tflite';

class PlantRecogniser extends StatefulWidget {
  const PlantRecogniser(
      {Key? key,
      required this.labelsFileNameMain,
      required this.modelFileNameMain,
      required this.plantName,
      required this.plantImagesURL,
      required this.plantID})
      : super(key: key);

  final String labelsFileNameMain;
  final String modelFileNameMain;
  final String plantName;
  final String plantImagesURL;
  final int plantID;

  @override
  State<PlantRecogniser> createState() => _PlantRecogniserState();
}

enum _ResultStatus {
  notStarted,
  notFound,
  found,
}

class _PlantRecogniserState extends State<PlantRecogniser> {
  int _bottomNavIndex = 0;

  List<IconData> iconList = [
    Icons.home,
    Icons.favorite,
    Icons.shopping_cart,
    Icons.person,
  ];

  bool _isAnalyzing = false;
  final picker = ImagePicker();
  File? _selectedImageFile;

  // Result
  _ResultStatus _resultStatus = _ResultStatus.notStarted;
  String _plantLabel = ''; // Name of Error Message
  double _accuracy = 0.0;

  late Classifier _classifier;
  late Classifier _classifierMain;
  List<String> plantIDs = [];

  List<String> plantDiseaseIDs = [];

  List<String> diseaseNames = [];
  List<String> diseaseSymptoms = [];
  List<String> diseasePrecautions = [];
  String _diseaseSymptomsmain = '';

  String _diseasePrecautionsmain = '';
  String _nonLeafMsg = '';

  @override
  void initState() {
    super.initState();
    _loadClassifier();
    _loadClassifierMain();

    getPlantID();
  }

  final CollectionReference plantList =
      FirebaseFirestore.instance.collection('Crop');

  Future getPlantID() async {
    final snapshot = await plantList.get();
    plantIDs.addAll(snapshot.docs.map((doc) => doc.reference.id));
    debugPrint('Plant IDs retrieved successfully: $plantIDs');

    if (plantIDs.isNotEmpty) {
      debugPrint(' plantIDs list is not empty.');
      return;
    }
  }

  Future getData() async {
    List<String> cropdiseaseName = [];
    List<String> cropdiseaseSymptom = [];
    List<String> cropdiseasePrecautions = [];
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Crop')
        .doc(plantIDs[widget.plantID])
        .collection('CropDiseases')
        .get();
    // .then((DocumentSnapshot documentSnap) => {
    //       if (documentSnap.exists)
    //         {debugPrint('Document data: ${documentSnap.data()}')}
    //       else
    //         {debugPrint('document does not exist')}
    //     });

    for (final doc in querySnapshot.docs) {
      final diseaseName = doc.get('DiseaseName') as String;
      final diseaseSymptom = doc.get('DiseaseSymptoms') as String;
      final diseasePrecaution = doc.get('DiseasePrecautions') as String;

      cropdiseaseName.add(diseaseName);
      cropdiseaseSymptom.add(diseaseSymptom);
      cropdiseasePrecautions.add(diseasePrecaution);

      debugPrint('diseaseName retrieved successfully: $cropdiseaseName');
      debugPrint('diseaseSymptoms retrieved successfully: $cropdiseaseSymptom');
      debugPrint(
          'diseasePrecautions retrieved successfully:$cropdiseasePrecautions');
    }
    setState(() {
      diseaseNames = cropdiseaseName;
      diseaseSymptoms = cropdiseaseSymptom;
      diseasePrecautions = cropdiseasePrecautions;
    });

    if (diseaseNames.isEmpty) {
      debugPrint('disease names array is empty');
    } else {
      debugPrint('disease names array is not  empty = $diseaseNames');
    }

    if (diseaseSymptoms.isEmpty) {
      debugPrint('disease symptoms array is empty');
    } else {
      debugPrint('disease symptoms array is not  empty = $diseaseSymptoms');
    }

    if (diseasePrecautions.isEmpty) {
      debugPrint('disease precautions array is empty');
    } else {
      debugPrint(
          'disease precautions array is not  empty = $diseasePrecautions');
    }
    // Now, diseaseNames and diseaseSymptoms arrays are populated with data
    // You can access these arrays as needed
  }

  // Future _getData() async {
  //   PlantDatabaseManager(widget.plantID).getData();
  // }

  // Future _getplantId() {
  //   final plantids = PlantDatabaseManager(widget.plantID).getPlantID();
  //   return plantids;
  // }

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

  Future<void> _loadClassifierMain() async {
    debugPrint(
      'Start loading of Classifier with '
      'labels at ${widget.labelsFileNameMain}, '
      'model at ${widget.modelFileNameMain}',
    );

    final classifierMain = await Classifier.loadWith(
      labelsFileName: widget.labelsFileNameMain,
      modelFileName: widget.modelFileNameMain,
    );
    _classifierMain = classifierMain!;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(left: 16, bottom: 20, top: 20),
                    child: Text(
                      widget.plantName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color.fromARGB(255, 64, 108, 65)
                                .withOpacity(.15)),
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                        )),
                  ),
                ],
              )),

          Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Container(
                  width: size.width * .8,
                  height: size.height * .8,
                  padding: const EdgeInsets.all(0),
                  child: _buildPhotolView())),

          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                  height: size.height * .55,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(236, 211, 211, 211)
                        .withOpacity(.6),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                      child: Container(
                    padding: const EdgeInsets.only(top: 0, left: 30, right: 30),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildPickPhotoButtonfromcamera(
                                  title: 'Take a photo',
                                  source: ImageSource.camera,
                                ),
                                const SizedBox(width: 30),
                                _buildPickPhotoButtonfromgallery(
                                  title: 'Pick from gallery',
                                  source: ImageSource.gallery,
                                )
                              ]),
                          _buildPhotolView(),
                          const SizedBox(height: 20),
                          _buildResultView(),
                        ]),
                  ))))

          // Padding(
          //   padding: const EdgeInsets.only(top: 30),
          //   child: _buildTitle(),
          // ),

          // _buildPhotolView(),
          // const SizedBox(height: 20),

          // _buildResultView(),
          // const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildPhotolView() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        PlantPhotoView(
            file: _selectedImageFile, plantImageURL: widget.plantImagesURL),
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
      icon: const Icon(Icons.photo_library, size: 50),
    );
  }

  Widget _buildPickPhotoButtonfromcamera({
    required ImageSource source,
    required String title,
  }) {
    return IconButton(
      onPressed: () => _onPickPhoto(source),
      icon: const Icon(
        Icons.camera_alt,
        size: 50,
      ),
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

  void _analyzeImage(File image) async {
    _setAnalyzing(true);

    final imageInput = img.decodeImage(image.readAsBytesSync())!;
    var diseaseSymptomsmain = '';
    var diseasePrecationsmain = '';
    var resultCategory = _classifier.predict(imageInput);

    var result = resultCategory.score >= 0
        ? _ResultStatus.found
        : _ResultStatus.notFound;
    var plantLabel = resultCategory.label;
    var accuracy = resultCategory.score;

    _setAnalyzing(false);
    if (plantLabel == 'Leaves') {
      resultCategory = _classifierMain.predict(imageInput);
      result = resultCategory.score >= 0
          ? _ResultStatus.found
          : _ResultStatus.notFound;
      plantLabel = resultCategory.label;
      accuracy = resultCategory.score;

      await getData();

      // Ensure that plantIDs is not empty and widget.plantID is within valid
      // if (plantIDs.isNotEmpty && widget.plantID < plantIDs.length) {
      //   diseaseSymptomsmain = plantIDs[widget.plantID];
      // } else {
      //   diseaseSymptomsmain = 'No data found';
      // }

      if (diseaseNames.isNotEmpty) {
        debugPrint('diseeaseName array is not empty!!!!');

        for (var i = 0; i < diseaseNames.length; i++) {
          if (plantLabel == diseaseNames[i]) {
            diseaseSymptomsmain = diseaseSymptoms[i];
            diseasePrecationsmain = diseasePrecautions[i];

            break;
          } else {
            diseaseSymptomsmain = 'no data found';
          }
        }

        debugPrint(' disease  =  $diseaseNames');
      } else {
        debugPrint('empty disease name arrray after coming out of getData();');
      }

      setState(() {
        _resultStatus = result;
        _plantLabel = plantLabel;
        _accuracy = accuracy;

        _diseaseSymptomsmain = diseaseSymptomsmain;
        _diseasePrecautionsmain = diseasePrecationsmain;
      });
    } else {
      const messageNonLeaves = 'Please add a crop to heal !';
      setState(() {
        _resultStatus = result;
        _plantLabel = plantLabel;
        _accuracy = accuracy;
        _diseaseSymptomsmain = '';
        _diseasePrecautionsmain = '';
        _nonLeafMsg = messageNonLeaves;
      });
    }
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Text(title, style: kResultTextStyle),
        const SizedBox(height: 40),
        Text(accuracyLabel, style: kResultRatingTextStyle),
        const SizedBox(height: 30),
        if (_diseasePrecautionsmain == '' && _diseaseSymptomsmain == '')
          Text(_nonLeafMsg, style: kResultRatingTextStyle)
        else
          Column(
            children: [
              Text(_diseaseSymptomsmain, style: kResultRatingTextStyle),
              const SizedBox(height: 30),
              Text(_diseasePrecautionsmain, style: kResultRatingTextStyle),
              const SizedBox(height: 30),
            ],
          )
      ],
    );
  }
}
