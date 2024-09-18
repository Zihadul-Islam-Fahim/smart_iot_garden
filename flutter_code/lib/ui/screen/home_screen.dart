import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iot_garden/ui/utilities/app_colors.dart';

import '../widgets/circle_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final databaseRef = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              "https://iot-garden-b741c-default-rtdb.asia-southeast1.firebasedatabase.app")
      .ref("gardenData");
  final ref = FirebaseDatabase.instance.ref("gardenData");

  bool isMotorOn = false;

  Future<void> motorOn(value) async {
    isMotorOn = !isMotorOn;
    setState(() {});
    await databaseRef.update(
      {
        "waterMotor": isMotorOn,
      },
    );
  }

  Future<void> refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'IOT Garden',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'samsung',
              fontWeight: FontWeight.w700,
            ),
          ),
          // centerTitle: true,
          backgroundColor: AppColors.primaryColor.withOpacity(0.8),
        ),
        body: StreamBuilder(
          stream: databaseRef.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              Map<dynamic, dynamic> map =
                  snapshot.data!.snapshot.value as dynamic;
              return RefreshIndicator(
                color: Colors.teal,
                backgroundColor: Colors.amberAccent,
                onRefresh: refresh,
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 3,
                    crossAxisCount: 2,
                    mainAxisSpacing: 3,
                    childAspectRatio: 0.52,
                  ),
                  children: [
                    Container(
                      //height: 220,
                      width: double.infinity,
                      color: AppColors.primaryColor.withOpacity(0.9),
                      child: Center(
                        child: CircleProgress(
                          barValue: int.parse(map["soilHumidity"].toString()),
                          barColor: Colors.blue.shade300.withOpacity(0.7),
                          barName: 'Soil Humidity',
                        ),
                      ),
                    ),
                    Container(
                      //height: 220,
                      width: double.infinity,
                      color: AppColors.primaryColor.withOpacity(0.9),
                      child: Center(
                        child: CircleProgress(
                          barName: "Temperature",
                          barValue: int.parse(map["temprature"].toString()),
                          barColor: Colors.orange.shade300.withOpacity(0.7),
                        ),
                      ),
                    ),
                    Container(
                      //height: 220,
                      width: double.infinity,
                      color: AppColors.primaryColor.withOpacity(0.9),
                      child: Center(
                        child: CircleProgress(
                          barName: "Humidity",
                          barValue: int.parse(map["humidity"].toString()),
                          barColor: Colors.teal.shade300.withOpacity(0.7),
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: double.infinity,
                      color: AppColors.primaryColor.withOpacity(0.9),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 90,
                            ),
                            Transform.scale(
                              scale: 2.0,
                              child: Switch(
                                value: map["waterMotor"],
                                onChanged: motorOn,
                                activeColor: AppColors.primaryColor,
                                activeTrackColor: Colors.greenAccent,
                                inactiveTrackColor: Colors.red,
                                inactiveThumbColor: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                            const Text(
                              'Water Motor',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'samsung',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
