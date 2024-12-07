import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangeLocationScreen extends StatelessWidget {
  const ChangeLocationScreen({
    super.key,
    required this.router,
  });

  final ChangeLocationRouter router;

  @override
  Widget build(BuildContext context) {
    final latController = TextEditingController();
    final longController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Change Location"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Change Location",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                FutureBuilder<String?>(
                  future: router.getValue('fluto_latitude'),
                  builder: (context, snapshot) {
                    latController.text = snapshot.data ?? '';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Latitude",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          controller: latController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^-?\d*\.?\d*$'),
                            ),
                          ],
                          decoration: InputDecoration(
                            hintText: "Enter Latitude",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onFieldSubmitted: (newValue) async {
                            if (newValue.isNotEmpty) {
                              await router.setValue('fluto_latitude', newValue, false);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
                FutureBuilder<String?>(
                  future: router.getValue('fluto_longitude'),
                  builder: (context, snapshot) {
                    longController.text = snapshot.data ?? '';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Longitude",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          controller: longController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^-?\d*\.?\d*$'),
                            ),
                          ],
                          decoration: InputDecoration(
                            hintText: "Enter Longitude",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onFieldSubmitted: (newValue) async {
                            if (newValue.isNotEmpty) {
                              await router.setValue('fluto_longitude', newValue, false);
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final latitude = latController.text;
                    final longitude = longController.text;

                    if (latitude.isNotEmpty && longitude.isNotEmpty) {
                      await router.setValue('fluto_latitude', latitude, false);
                      await router.setValue('fluto_longitude', longitude, true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Location updated successfully!"),
                        ),
                      );
                    }
                  },
                  child: const Text("Save Location"),
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    await router.setValue('fluto_latitude', null, false);
                    await router.setValue('fluto_longitude', null, true);
                    latController.clear();
                    longController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Location reset successfully!"),
                      ),
                    );
                  },
                  child: const Text("Reset Location"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

abstract class ChangeLocationRouter {
  Future<String?> getValue(String key);
  Future<void> setValue(String key, String? value, bool? shouldExit);
}
