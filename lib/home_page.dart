import 'dart:async';
// import 'dart:html';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF1C2757),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Stpwatch App',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    '$digitHour:$digitMin:$digitSec',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 82,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Color(0xFF323F68),
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
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${laps[index]}',
                              style: TextStyle(
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
                                icon: Icon(Icons.delete))
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RawMaterialButton(
                        onPressed: () {
                          (!started) ? start() : stop();
                        },
                        shape:
                            StadiumBorder(side: BorderSide(color: Colors.blue)),
                        child: Text(
                          (!started) ? 'Start' : 'Stop',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                        onPressed: () {
                          addLaps();
                        },
                        icon: Icon(
                          Icons.flag,
                          color: Colors.white,
                        )),
                    SizedBox(width: 8),
                    Expanded(
                      child: RawMaterialButton(
                        onPressed: () {
                          reset();
                        },
                        shape:
                            StadiumBorder(side: BorderSide(color: Colors.blue)),
                        child: Text(
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
