import 'package:flutter/material.dart';
import 'package:headlessfluto/bottom_sheet.dart';
import 'package:headlessfluto/fluto_log_type.dart';
import 'package:headlessfluto/provider/headless_fluto_logger_provider.dart';
import 'package:headlessfluto/provider/supabase_provider.dart';
import 'package:provider/provider.dart';

class HeadlessFluto extends StatefulWidget {
  @override
  State<HeadlessFluto> createState() => _HeadlessFlutoState();
}

class _HeadlessFlutoState extends State<HeadlessFluto>
    with SingleTickerProviderStateMixin {
  Stream<List<Map<String, dynamic>>>? logStream;
  SupabaseProvider? supabaseProvider;
  HeadlessFlutoLoggerProvider? loggerProvider;
  TabController? tabController;

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
      await supabaseProvider?.setInitialLogData(
        loggerProvider: loggerProvider!,
      );
      logStream?.listen((List<Map<String, dynamic>> event) {
        for (var element in event) {
          loggerProvider?.addLog(element);
        }
      });
    });
    tabController = TabController(
      length: FlutoLogType.values.length,
      vsync: this,
    );
    super.initState();
  }

  @override
  dispose() {
    tabController?.dispose();
    super.dispose();
  }

  Future<void> _refreshLogs() async {
    await supabaseProvider?.setInitialLogData(
      loggerProvider: loggerProvider!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Log Entries'),
        bottom: TabBar(
          controller: tabController,
          isScrollable: true,
          tabs: FlutoLogType.values
              .map((type) => Tab(text: type.toString().split('.').last))
              .toList(),
        ),
      ),
      body: Consumer<HeadlessFlutoLoggerProvider>(
          builder: (context, loggerProvider, child) {
        return TabBarView(
          controller: tabController,
          children: FlutoLogType.values.map((type) {
            List<Map<String, dynamic>> logs =
                loggerProvider.segregatedLogs[type]!;
            return RefreshIndicator(
              onRefresh: _refreshLogs,
              child: logs.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'No logs available for ${type.toString().split('.').last}..',
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: logs.length,
                      itemBuilder: (_, index) {
                        return ListTile(
                          onTap: () {
                            showLogDetailsDialog(
                              context: context,
                              flutoLog: logs[index],
                            );
                          },
                          title: Text(logs[index]['log_name']),
                          
                        );
                      },
                    ),
            );
          }).toList(),
        );
      }),
    );
  }
}
