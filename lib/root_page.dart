import 'package:flutter/material.dart';
import 'common/Navbar_components/navbar_insertdata_btn.dart';
import 'common/Navbar_components/navbar_btn.dart';
//import 'package:page_transition/page_transition.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:plantrecogniser/widget/plant_notification.dart';
import 'widget/plant_recogniser.dart';
import 'common/appbar.dart';
import '/app.dart';

void requestPermission() async {
  final diseasNotificationMsg = FirebaseMessaging.instance;

  final settings = await diseasNotificationMsg.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    debugPrint('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    debugPrint('User granted provisional permission');
  } else {
    debugPrint('User declined or has not accepted permision');
  }
}

Future<void> initNotification() async {
  initPushNotification();
}

void handleMessage(RemoteMessage? message) {
  if (message == null) return;

  navigatorKey.currentState?.pushNamed(
    '/plant_notification',
    arguments: message,
  );
}

Future initPushNotification() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    handleMessage(message);
  });

  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      handleMessage(message);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((handleMessage));
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);
  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  List<Widget> models = [
    const PlantRecogniser(
      labelsFileNameMain: 'assets/labels_potato.txt',
      modelFileNameMain: 'model_unquant_potato.tflite',
      plantName: 'Potato',
      plantImagesURL: 'assets/images/thumb.jpg',
      plantID: 2,
    ), // potato
    const PlantRecogniser(
      labelsFileNameMain: 'assets/labels_rice.txt',
      modelFileNameMain: 'model_unquant.tflite',
      plantName: 'Paddy',
      plantImagesURL: 'assets/images/paddy_leaf.jpg',
      plantID: 0,
    ), // paddy
    const PlantRecogniser(
      labelsFileNameMain: 'assets/labels_tealeaves.txt',
      modelFileNameMain: 'trained_model_tealeaves_v1.tflite',
      plantName: 'Tea',
      plantImagesURL: 'assets/images/tea_leaves.jpg',
      plantID: 1,
    ), // tea
    const PlantRecogniser(
      labelsFileNameMain: 'assets/labels_tomato.txt',
      modelFileNameMain: 'tflite_quant_model_tomato_v1.tflite',
      plantName: 'Tomato',
      plantImagesURL: 'assets/images/tomato_leaf.png',
      plantID: 3,
    ) // tomato
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNotification();
    requestPermission();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: const AppBarMain(),
          backgroundColor: const Color.fromARGB(255, 162, 189, 163),
          elevation: 2.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 35, left: 15, bottom: 35),
                child: const Text('Select your crop to heal',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    )),
              ),
              SizedBox(
                height: size.height * 0.3,
                child: ListView.builder(
                  itemCount: Crops.cropList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push<PlantRecogniser>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => models[index],
                          ),
                        );
                      },
                      child: Container(
                        width: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 166, 191, 170),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: 10,
                              right: 10,
                              top: 10,
                              bottom: 10,
                              child: Image.asset(
                                Crops.cropList[index].imageURL,
                                height: 100,
                                width: 200,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            Positioned(
                              bottom: 15,
                              left: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Crops.cropList[index].cropName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 55,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    color: const Color.fromARGB(255, 166, 191, 170),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text(
                            'Add new crop diseases',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'If you are a expert in crop disease identification'
                            ' click the upload icon below to add new diseases'
                            ' and help us train new AI models for prediction.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: const NavBarMainInsertDataBtn(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const NavBarMainBtn());
  }
}

class Crops {
  final int cropId;
  final String cropName;
  final String imageURL;

  Crops({required this.cropId, required this.cropName, required this.imageURL});
  static List<Crops> cropList = [
    Crops(
      cropId: 0,
      cropName: 'Potato',
      imageURL: 'assets/images/potato_image.png',
    ),
    Crops(
        cropId: 1,
        cropName: 'Paddy',
        imageURL: 'assets/images/paddy_image.png'),
    Crops(cropId: 2, cropName: 'Tea', imageURL: 'assets/images/tea_leaf.png'),
    Crops(
        cropId: 3,
        cropName: 'Tomato',
        imageURL: 'assets/images/tomato_plant.png')
  ];
}
