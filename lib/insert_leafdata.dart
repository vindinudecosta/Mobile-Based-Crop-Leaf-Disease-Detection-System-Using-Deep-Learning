import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class InsertData extends StatefulWidget {
  const InsertData({Key? key}) : super(key: key);

  @override
  State<InsertData> createState() => _InsertDataState();
}

class _InsertDataState extends State<InsertData> {
  final cropNameController = TextEditingController();
  final cropDiseaseNameController = TextEditingController();
  final cropDiseaseSymptomsController = TextEditingController();
  final cropDiseasePrecautionsController = TextEditingController();
  late DatabaseReference dbRef;
  final List<File> _image = [];
  bool _isLoading = false;

  List<String> urlsList = [];
  double val = 0;
  dynamic chooseImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
  }

  Future uploadFile() async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });

      var ref = FirebaseStorage.instance.ref().child(
          'newCropDiseases/ ${cropNameController.text}_${cropDiseaseNameController.text}/${Path.basename(img.path)}');

      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          urlsList.add(value);
          i++;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('NewCropDisease');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 101, 158, 119),
        title: const Text('Insert new cropdiseases'),
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                  // Center the loading indicator
                )
              : Column(
                  children: [
                    // const SizedBox(
                    //   height: 50,
                    // ),
                    // const Text(
                    //   'Inserting New Crop Diseases to the database',
                    //   style: TextStyle(
                    //     fontSize: 24,
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: cropNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Crop Name',
                        hintText: 'Enter the Crop Name',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: cropDiseaseNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Disease Name',
                        hintText: 'Enter the disease name',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: cropDiseaseSymptomsController,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Add Disease Symptoms',
                        hintText: 'Enter the disease symptoms',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: cropDiseasePrecautionsController,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Add Disease precautions',
                        hintText: 'Enter the disease precautions',
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text('Insert at least 1500 images of the disease',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromARGB(255, 146, 146, 146),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: _image.length + 1,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? Center(
                                      child: IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          chooseImage();
                                        },
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image:
                                                  FileImage(_image[index - 1]),
                                              fit: BoxFit.cover)),
                                    );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        final cropData = <String, String>{
                          'crop name': cropNameController.text,
                          'disease name': cropDiseaseNameController.text,
                          'symptoms': cropDiseaseSymptomsController.text,
                          'precautions': cropDiseasePrecautionsController.text
                        };

                        await uploadFile()
                            .whenComplete(() => Navigator.pop(context));
                        setState(() {
                          _isLoading = false;
                        });

                        dbRef.push().set(cropData);
                      },
                      color: Color.fromARGB(255, 101, 158, 119),
                      textColor: Colors.white,
                      minWidth: 300,
                      height: 40,
                      child: const Text('Upload'),
                    ),
                  ],
                ),
        ),
      )),
    );
  }
}
