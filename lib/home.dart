import 'package:flutter/material.dart';
import 'widget/potato_recogniser.dart';
import 'widget/rice_recogniser.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.green,
        // ),
        // drawer: Drawer(
        //   child: ListView(
        //     children: [
        //       DrawerHeader(
        //           padding: const EdgeInsets.all(0),
        //           child: Container(
        //             color: Colors.green,
        //             child:  Column(
        //               children:[Text('hi')],
        //             ),
        //           )),
        //        ListTile(leading: const Icon(Icons.home),
        //        title:const Text('Home'),
        //        onTap: () =>{Navigator.push<PlantRecogniser>(
        //                         context,
        //                         MaterialPageRoute(
        //
        //builder: (context) => const PlantRecogniser(),
        //                         ),
        //                       )})
        //     ],
        //   ),
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
          onTap: (label) => {
            Navigator.push<PlantRecogniserPotato>(
              context,
              MaterialPageRoute(
                builder: (context) => const PlantRecogniserPotato(),
              ),
            )
          },
        ),
        body: Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
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
                              style: TextStyle(
                                  fontSize: 30.0, color: Colors.green)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50.0),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push<PlantRecogniserPotato>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PlantRecogniserPotato(),
                                ),
                              );
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.green,
                                      width: 3.0,
                                    ),
                                  ),
                                  child: const Image(
                                    image: NetworkImage(
                                      'https://media.istockphoto.com/id/1153044117/vector/potato-plant-vector-isolated-illustration.jpg?s=612x612&w=0&k=20&c=UY8HP3EvyjrQfoKvg4miFgPDXyUEheP9P8TOw8Au6-Y=',
                                    ),
                                  ),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push<PlantRecogniserRice>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PlantRecogniserRice(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 3.0,
                                  ),
                                ),
                                child: const Image(
                                  image: NetworkImage(
                                    'https://us.123rf.com/450wm/mything/mything2003/mything200300001/141890155-rice-spikes-stem-with-leaves-vector-illustration-cartoon-flat-icon-isolated-on-white.jpg?ver=6',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push<PlantRecogniserRice>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PlantRecogniserRice(),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Image(
                                image: NetworkImage(
                                  'https://thumbs.dreamstime.com/b/hand-drawn-fresh-green-tea-leaf-bud-twig-sketch-style-vector-illustration-isolated-white-background-realistic-drawing-96879128.jpg',
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push<PlantRecogniserRice>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PlantRecogniserRice(),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Image(
                                image: NetworkImage(
                                  'https://t4.ftcdn.net/jpg/02/85/26/15/360_F_285261563_nAma67q0PG1nafKzlNHdp29p16rUj6ON.jpg',
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push<PlantRecogniserRice>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PlantRecogniserRice(),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Image(
                                image: NetworkImage(
                                  'https://thumbs.dreamstime.com/b/growing-pepper-plant-isolated-white-vector-photo-realistic-illustration-87525551.jpg',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}
