import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stop Watch',
      home: Scaffold(
        appBar: AppBar(backgroundColor: const Color.fromARGB(255, 34, 34, 34)),
        body: TimerApp(),
        backgroundColor: const Color.fromARGB(255, 34, 34, 34),
      ),
    );
  }
}

class TimerApp extends StatefulWidget {
  const TimerApp({super.key});

  @override
  State<TimerApp> createState() {
    return _TimerApp();
  }
}

class _TimerApp extends State<TimerApp> {
  bool isTimerActive = false;
  Timer? timer;
  Duration elapsed = Duration.zero;
  DateTime? startTime;
  List<String> lapses = [];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 30), (_) {
      if (isTimerActive && startTime != null) {
        setState(() {
          elapsed = DateTime.now().difference(startTime!);
        });
      }
    });
  }

  void reset() {
    setState(() {
      isTimerActive = false;
      elapsed = Duration.zero;
      startTime = null;
      lapses.clear();
    });
  }

  void startOrStop() {
    setState(() {
      if (!isTimerActive) {
        startTime = DateTime.now().subtract(elapsed);
      }
      isTimerActive = !isTimerActive;
    });
  }

  void lapse() {
    if(!isTimerActive) return;
    int hours = elapsed.inHours;
    int minutes = elapsed.inMinutes % 60;
    int seconds = elapsed.inSeconds % 60;
    int milliseconds = (elapsed.inMilliseconds % 1000) ~/ 10;
    setState(() {
      lapses.add(
        "#${lapses.length + 1}   ${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}:${milliseconds.toString().padLeft(2, "0")}",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    int hours = elapsed.inHours;
    int minutes = elapsed.inMinutes % 60;
    int seconds = elapsed.inSeconds % 60;
    int milliseconds = (elapsed.inMilliseconds % 1000) ~/ 10;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: hours / 23,
                strokeWidth: 10,
                strokeCap: StrokeCap.round,
                color: const Color.fromARGB(255, 255, 0, 0),
                constraints: BoxConstraints(minHeight: 300, minWidth: 300),
              ),
              CircularProgressIndicator(
                value: minutes / 59,
                strokeWidth: 10,
                strokeCap: StrokeCap.round,
                color: Colors.amber[800],
                constraints: BoxConstraints(minHeight: 320, minWidth: 320),
              ),
              CircularProgressIndicator(
                value: seconds / 59,
                strokeWidth: 10,
                strokeCap: StrokeCap.round,
                color: Colors.yellow[700],
                constraints: BoxConstraints(minHeight: 340, minWidth: 340),
              ),
              Text(
                "${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}:${milliseconds.toString().padLeft(2, "0")}",
                style: GoogleFonts.mPlusRounded1c(
                  color: const Color.fromARGB(255, 255, 51, 0),
                  fontWeight: FontWeight.normal,
                  fontSize: 30,
                ),
              ),
              GestureDetector(
                onTap: lapse,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 300,
            child: 
            Padding(padding: EdgeInsets.all(50),
            child: 
            SingleChildScrollView(
              child: Column(
              children: [
                ...lapses.map((element) => Text(element, style: TextStyle(color: const Color.fromARGB(255, 167, 167, 167), fontSize: 25, height: 2 )))
                ],
            ),
            ) ,
            )
          ),
          SizedBox(
            width: 350,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //start or stop
                IconButton(
                  onPressed: startOrStop,
                  icon: Icon(
                    isTimerActive
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: Colors.amber[700],
                  ),
                  iconSize: 60,
                ),

                //reset
                IconButton(
                  onPressed: reset,
                  icon: Icon(Icons.cached_rounded, color: Colors.amber[700]),
                  iconSize: 60,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
