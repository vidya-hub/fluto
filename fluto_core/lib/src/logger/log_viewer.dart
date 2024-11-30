import 'package:fluto_core/fluto.dart';
import 'package:fluto_core/src/logger/logger_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogViewer extends StatefulWidget {
  const LogViewer({super.key});

  @override
  State<LogViewer> createState() => _LogViewerState();
}

class _LogViewerState extends State<LogViewer>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: FlutoLogType.values.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log Viewer"),
        bottom: TabBar(
          controller: _tabController,
          tabs: FlutoLogType.values.map((logType) {
            return Tab(text: logType.toString().split('.').last);
          }).toList(),
        ),
      ),
      body: Consumer<FlutoLoggerProvider>(
        builder: (context, provider, _) {
          return TabBarView(
            controller: _tabController,
            children: FlutoLogType.values.map(
              (logType) {
                List<FlutoLog> logs;
                switch (logType) {
                  case FlutoLogType.debug:
                    logs = provider.debugLogs;
                    break;
                  case FlutoLogType.info:
                    logs = provider.infoLogs;
                    break;
                  case FlutoLogType.warning:
                    logs = provider.warningLogs;
                    break;
                  case FlutoLogType.error:
                    logs = provider.errorLogs;
                    break;
                }
                print(logs.length);
                return ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(logs[index].logMessage),
                    );
                  },
                );
              },
            ).toList(),
          );
        },
      ),
    );
  }
}
