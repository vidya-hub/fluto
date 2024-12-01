import 'package:fluto_core/fluto.dart';
import 'package:fluto_core/src/extension/fluto_log_extension.dart';
import 'package:fluto_core/src/logger/log_details_page.dart';
import 'package:fluto_core/src/logger/logger_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogViewer extends StatefulWidget {
  const LogViewer({super.key});

  @override
  State<LogViewer> createState() => _LogViewerState();
}

class _LogViewerState extends State<LogViewer> {
  late FlutoLoggerProvider _flutoLoggerProvider;
  FlutoLogType _selectedLogType = FlutoLogType.debug;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      setState(() {
        _flutoLoggerProvider =
            Provider.of<FlutoLoggerProvider>(context, listen: false);
        _flutoLoggerProvider.syncLocalLogs();
        _selectedLogType = FlutoLogType.values.first;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${_selectedLogType.name.camelCase} logs"),
        actions: [
          PopupMenuButton<FlutoLogType>(
            icon: const Icon(Icons.filter_list),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            onSelected: (FlutoLogType logType) {
              setState(() {
                _selectedLogType = logType;
              });
            },
            itemBuilder: (BuildContext context) {
              return FlutoLogType.values.map((logType) {
                return PopupMenuItem<FlutoLogType>(
                  value: logType,
                  child: Row(
                    children: [
                      Checkbox(
                        value: logType == _selectedLogType,
                        onChanged: (value) {
                          setState(() {
                            _selectedLogType = logType;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      Text(logType.toString().split('.').last),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Consumer<FlutoLoggerProvider>(
        builder: (context, logProvider, child) {
          final logs = logProvider.getAllLogs(
            logType: _selectedLogType,
          );
          return LogsTab(
            logs: logs,
            logType: _selectedLogType,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Clear ${_selectedLogType.name} logs",
        onPressed: () {
          _flutoLoggerProvider.clearLogs(type: _selectedLogType);
        },
        child: const Icon(Icons.clear_all_rounded),
      ),
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
    if (logs.isEmpty) {
      return Center(
        child: Text("No ${logType.name} logs found"),
      );
    }
    return ListView.builder(
      key: ValueKey(logs.length),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onTap: () {
              showLogDetailsDialog(
                context: context,
                flutoLog: log,
              );
            },
            title: Text(
              log.logMessage,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(log.getFormattedLogTime),
            tileColor: Theme.of(context).focusColor,
          ),
        );
      },
    );
  }
}
