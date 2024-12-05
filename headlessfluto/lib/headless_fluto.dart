import 'package:flutter/material.dart';
import 'package:headlessfluto/provider/headless_fluto_logger_provider.dart';
import 'package:headlessfluto/provider/supabase_provider.dart';
import 'package:provider/provider.dart';

class HeadlessFluto extends StatefulWidget {
  @override
  State<HeadlessFluto> createState() => _HeadlessFlutoState();
}

class _HeadlessFlutoState extends State<HeadlessFluto> {
  Stream<List<Map<String, dynamic>>>? logStream;
  SupabaseProvider? supabaseProvider;
  HeadlessFlutoLoggerProvider? loggerProvider;
  @override
  void initState() {
    supabaseProvider = Provider.of<SupabaseProvider>(
      context,
      listen: false,
    );
    loggerProvider = Provider.of<HeadlessFlutoLoggerProvider>(
      context,
      listen: false,
    );
    Future.delayed(Duration.zero, () async {
      await supabaseProvider?.initSupabase();
      logStream = await supabaseProvider?.getLogStream();
      logStream?.listen((List<Map<String, dynamic>> event) {
        for (var element in event) {
          loggerProvider?.addLog(element);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Entries'),
      ),
      body: Builder(builder: (context) {
        if (logStream == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return Consumer<HeadlessFlutoLoggerProvider>(
            builder: (context, loggerProvider, child) {
          return ListView.builder(
            itemCount: loggerProvider.logs.length,
            itemBuilder: (context, index) {
              final log = loggerProvider.logs[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Log Name: ${log['log_name']}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.0),
                      Text('Log Type: ${log['log_type']}'),
                      SizedBox(height: 8.0),
                      Text('Created At: ${log['created_at']}'),
                      SizedBox(height: 8.0),
                      if (log['error'] != null) ...[
                        Text('Error: ${log['error']}',
                            style: TextStyle(color: Colors.red)),
                        SizedBox(height: 8.0),
                      ],
                      if (log['stacktrace'] != null) ...[
                        Text('Stacktrace: ${log['stacktrace']}'),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        });
      }),
    );
  }
}
