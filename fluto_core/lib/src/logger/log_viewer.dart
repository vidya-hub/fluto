import 'package:fluto_core/fluto.dart';
import 'package:fluto_core/src/logger/log_details_page.dart';
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
        builder: (context, logProvider, child) {
          return TabBarView(
            controller: _tabController,
            children: FlutoLogType.values.map((logType) {
              return LogsTab(
                logs: logProvider.logs(type: logType),
                logType: logType,
              );
            }).toList(),
          );
        },
      ),
      // floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     ...FlutoLogType.values.map(
      //       (logType) {
      //         return Padding(
      //           padding: const EdgeInsets.symmetric(vertical: 10),
      //           child: FloatingActionButton(
      //             child: Center(child: Text(logType.name)),
      //             onPressed: () {
      //               FlutoLog.log(
      //                 "Hello, I am ${logType.name} type",
      //                 logType: logType,
      //               );
      //               if (_tabController.index != logType.index) {
      //                 _tabController.animateTo(logType.index);
      //               }
      //             },
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),
    );
  }
}

class LogsTab extends StatelessWidget {
  final List<FlutoLogModel> logs;
  final FlutoLogType logType;

  const LogsTab({
    super.key,
    required this.logs,
    required this.logType,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: ValueKey(logs.length),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return ListTile(
          onTap: () {
            showLogDetailsDialog(
              context: context,
              flutoLog: log,
            );
          },
          title: Text(log.logMessage),
          subtitle: Text(log.getFormattedLogTime),
        );
      },
    );
  }
}
