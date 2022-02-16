import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FlutterLocalNotificationsPlugin? local;

  @override
  void initState() {
    var and = const AndroidInitializationSettings('icon');
    var i = const IOSInitializationSettings();
    var initial = InitializationSettings(android: and, iOS: i);
    local = FlutterLocalNotificationsPlugin();
    local!.initialize(initial);
    super.initState();
  }

  int sec = 0, min = 0, hour = 0;
  String digitSec = '00', digitMin = '00', digitHour = '00';
  Timer? timer;
  bool started = false;
  List laps = [];

  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  void reset() {
    timer!.cancel();
    setState(() {
      sec = 0;
      min = 0;
      hour = 0;

      digitSec = '00';
      digitMin = '00';
      digitHour = '00';
      started = false;
    });
  }

  void addLaps() {
    String lap = '$digitHour:$digitMin:$digitSec';
    setState(() {
      laps.add(lap);
    });
  }

  void start() {
    started = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int localS = sec + 1;
      int localM = min;
      int localH = hour;
      if (localS > 59) {
        if (localM > 59) {
          localH++;
          localM = 0;
        } else {
          localM++;
          localS = 0;
        }
      }
      setState(() {
        sec = localS;
        min = localM;
        hour = localH;
        digitSec = (sec >= 10) ? '$sec' : '0$sec';
        digitMin = (min >= 10) ? '$min' : '0$min';
        digitHour = (hour >= 10) ? '$hour' : '0$hour';
      });
    });
  }

  Future show(String id, desc) async {
    var detail = const AndroidNotificationDetails('channelId', 'Local',
        channelDescription: 'Description of Notification',
        importance: Importance.high);
    var ios = const IOSNotificationDetails();
    var gene = NotificationDetails(android: detail, iOS: ios);
    await local!.show(0, id, desc, gene);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF1C2757),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    'Stopwatch App',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    '$digitHour:$digitMin:$digitSec',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 82,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: const Color(0xFF323F68),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    itemCount: laps.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Lap#${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${laps[index]}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    laps.removeAt(index);
                                  });
                                },
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RawMaterialButton(
                        onPressed: () {
                          (!started) ? start() : stop();
                          setState(() {
                            (!started)
                                ? show(
                                    'Stopped', '$digitHour:$digitMin:$digitSec')
                                : show('Started', 'Stopwatch started');
                          });
                        },
                        shape: const StadiumBorder(
                            side: BorderSide(color: Colors.blue)),
                        child: Text(
                          (!started) ? 'Start' : 'Stop',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                        onPressed: () {
                          addLaps();
                        },
                        icon: const Icon(
                          Icons.flag,
                          color: Colors.white,
                        )),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RawMaterialButton(
                        onPressed: () {
                          reset();
                          show('Reseted',
                              'Stopwatch was resetted to  $digitHour:$digitMin:$digitSec');
                        },
                        shape: const StadiumBorder(
                            side: BorderSide(color: Colors.blue)),
                        child: const Text(
                          'Reset',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
