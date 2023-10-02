import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlantDatabaseManager {
  int plantid = 0;

  PlantDatabaseManager(int plantID) {
    plantid = plantID;
  }

  List<String> plantIDs = [];
  List<String> plantDiseaseIDs = [];

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
  // Future getPlantName() async {
  //   try {
  //     await plantList.doc(plantIDs[_plantID]).get().then((snapshot) {
  //   Map<String,dynamic> data = snapshot.data() as Map<String,dynamic>;

  //     });
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  String plantName = '';

  List<String> diseaseNames = [];
  List<String> diseaseSymptoms = [];

  Future getData() async {
    final DocumentReference document =
        FirebaseFirestore.instance.collection('Crop').doc(plantIDs[plantid]);
    final CollectionReference subcollection =
        document.collection('CropDiseases');
    final DocumentSnapshot plantdata = await FirebaseFirestore.instance
        .collection('Crop')
        .doc(plantIDs[plantid])
        .get();

    plantName = plantdata.get('CropName').toString();

    final snapshot = await subcollection.get();
    for (final element in snapshot.docs) {
      plantDiseaseIDs.add(element.reference.id);
    }

    final subcollectionSnapshot = await subcollection.get();
    for (final document in subcollectionSnapshot.docs) {
      final diseaseName = document.get('DiseaseName').toString();
      final diseaseSymptom = document.get('DiseaseSymptoms').toString();

      diseaseNames.add(diseaseName);
      diseaseSymptoms.add(diseaseSymptom);
    }
  }
}
