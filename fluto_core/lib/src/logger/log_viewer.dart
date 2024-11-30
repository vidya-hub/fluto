import 'package:fluto_core/fluto.dart';
import 'package:fluto_core/src/logger/logger_provider.dart';
import 'package:flutter/material.dart';

class LogViewer extends StatefulWidget {
  const LogViewer({super.key});

  @override
  State<LogViewer> createState() => _LogViewerState();
}

class _LogViewerState extends State<LogViewer>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final logProvider = ValueNotifier(FlutoLoggerProvider());

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
      body: ValueListenableBuilder(
        valueListenable: logProvider,
        builder: (context, provider, _) {
          return TabBarView(
            controller: _tabController,
            children: [
              LogsTab(logs: provider.debugLogs),
              LogsTab(logs: provider.infoLogs),
              LogsTab(logs: provider.warningLogs),
              LogsTab(logs: provider.errorLogs),
            ],
          );
        },
      ),
    );
  }
}

class LogsTab extends StatelessWidget {
  final List<FlutoLog> logs;

  const LogsTab({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    print("log length ${logs.length}");
    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return ListTile(
          title: Text(log.logMessage),
          subtitle: Text(log.logTime.toString()),
        );
      },
    );
  }
}
