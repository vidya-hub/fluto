import 'package:fluto_core/fluto.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Testing Fluto"),
              const Padding(padding: EdgeInsets.all(10)),
              ElevatedButton(
                onPressed: () {
                  FlutoLog.log(
                    "This is a test log",
                    logType: FlutoLogType.info,
                  );
                },
                child: const Text("Print The Stuff"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
