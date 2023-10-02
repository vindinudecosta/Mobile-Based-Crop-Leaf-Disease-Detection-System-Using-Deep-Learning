import 'package:flutter/material.dart';
import 'common/Navbar_components/navbar_insertdata_btn.dart';
import 'common/Navbar_components/navbar_btn.dart';
//import 'package:page_transition/page_transition.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'widget/plant_recogniser.dart';
import 'common/appbar.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);
  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  //list of the pages
  var _bottomNavIndex = 0;
  List<String> imagesURL = [
    'assets/images/thumb.jpg',
    'assets/images/paddy_leaf.jpg',
    'assets/images/thumb.jpg',
    'assets/images/paddy_leaf.jpg',
  ];
  List<Widget> models = [
    const PlantRecogniser(
      labelsFileNameMain: 'assets/labels_potato.txt',
      modelFileNameMain: 'model_unquant_potato.tflite',
      plantName: 'Potato',
      plantImagesURL: 'assets/images/thumb.jpg',
      plantID: 1,
    ), // potato
    const PlantRecogniser(
      labelsFileNameMain: 'assets/labels_rice.txt',
      modelFileNameMain: 'model_unquant.tflite',
      plantName: 'Paddy',
      plantImagesURL: 'assets/images/paddy_leaf.jpg',
      plantID: 0,
    ), // paddy
    const PlantRecogniser(
      labelsFileNameMain: 'assets/labels_tomato.txt',
      modelFileNameMain: 'tflite_quant_model_tomato_v1.tflite',
      plantName: 'Tea',
      plantImagesURL: 'assets/images/tea_leaves.jpg',
      plantID: 0,
    ), // tea
    const PlantRecogniser(
      labelsFileNameMain: 'assets/labels_tomato.txt',
      modelFileNameMain: 'tflite_quant_model_tomato_v1.tflite',
      plantName: 'Tomato',
      plantImagesURL: 'assets/images/tomato_leaf.png',
      plantID: 1,
    ) // tomato
  ];

  List<IconData> iconList = [
    Icons.home,
    Icons.favorite,
    Icons.shopping_cart,
    Icons.person,
  ];

  @override
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
                padding: const EdgeInsets.only(top: 30, left: 15, bottom: 15),
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
