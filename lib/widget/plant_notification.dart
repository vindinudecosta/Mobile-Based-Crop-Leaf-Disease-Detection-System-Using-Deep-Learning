import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../root_page.dart';

class PlantNotification extends StatefulWidget {
  const PlantNotification({Key? key}) : super(key: key);

  @override
  State<PlantNotification> createState() => _PlantNotificationState();
}

class _PlantNotificationState extends State<PlantNotification> {
  List<String> notificationTitleList = [];
  List<String> notificationBodyList = [];

  @override
  void initState() {
    super.initState();
    refreshNotificationData();
  }

  final notificationDB = Hive.box<List<String>?>('notificationDB');

  void getnotificationTitle() {
    notificationTitleList = notificationDB.get('newTitle') ?? [];
  }

  void getnotificationBody() {
    notificationBodyList = notificationDB.get('newBody') ?? [];
  }

  void refreshNotificationData() {
    getnotificationTitle();
    getnotificationBody();
  }

  void updateNotificationTitle() {
    notificationDB.put('newTitle', notificationTitleList);
  }

  void updateNotificationBody() {
    notificationDB.put('newBody', notificationBodyList);
  }

  void updateNotificationData() {
    updateNotificationBody();
    updateNotificationTitle();
  }

  void deleteItem(int itemkey) {
    notificationBodyList.removeAt(itemkey);
    notificationTitleList.removeAt(itemkey);

    setState(() {
      updateNotificationData();
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A notification has been deleted')));
  }

  @override
  Widget build(BuildContext context) {
    final message =
        ModalRoute.of(context)?.settings.arguments as RemoteMessage?;

    String notificationTitle;
    String notificationBody;

    if (message != null) {
      notificationTitle = message.notification?.title ?? '';
      notificationBody = message.notification?.body ?? '';
      if (!notificationTitleList.contains(notificationTitle) ||
          !notificationBodyList.contains(notificationBody)) {
        setState(() {
          notificationTitleList.add(notificationTitle);
          notificationBodyList.add(notificationBody);

          updateNotificationData();
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 101, 158, 119),
        title: const Text('Crop Disease Notification'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push<Widget>(context,
                MaterialPageRoute(builder: (context) => const RootPage()));
          },
        ),
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              refreshNotificationData();
            });
          },
          child: notificationTitleList.isEmpty
              ? const Text(' No notifications yet.')
              : ListView.builder(
                  itemCount: notificationTitleList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.green.shade100,
                      margin: const EdgeInsets.all(20),
                      elevation: 3,
                      child: ListTile(
                        title: Text(notificationTitleList[index]),
                        subtitle: Text(notificationBodyList[index]),
                        trailing:
                            Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                            onPressed: () {
                              deleteItem(index);
                              Navigator.push<Widget>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PlantNotification(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ]),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
