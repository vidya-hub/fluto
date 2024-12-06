import 'package:flutter/material.dart';
import 'package:headlessfluto/bottom_sheet.dart';
import 'package:headlessfluto/model/network_model.dart';
import 'package:provider/provider.dart';
import 'package:headlessfluto/fluto_log_type.dart';
import 'package:headlessfluto/provider/supabase_provider.dart';
import 'package:headlessfluto/provider/fluto_logger_provider.dart';
import 'package:headlessfluto/provider/fluto_network_provider.dart';

class HeadlessFluto extends StatefulWidget {
  @override
  _HeadlessFlutoState createState() => _HeadlessFlutoState();
}

class _HeadlessFlutoState extends State<HeadlessFluto>
    with TickerProviderStateMixin {
  TabController? tabController;
  SupabaseProvider? supabaseProvider;
  HeadlessFlutoLoggerProvider? loggerProvider;
  FlutoNetworkProvider? networkProvider;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    supabaseProvider = Provider.of<SupabaseProvider>(
      context,
      listen: false,
    );
    loggerProvider = Provider.of<HeadlessFlutoLoggerProvider>(
      context,
      listen: false,
    );
    networkProvider = Provider.of<FlutoNetworkProvider>(
      context,
      listen: false,
    );
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await supabaseProvider?.initSupabase();
      var logStream = await supabaseProvider?.getLogStream();
      logStream?.listen((List<Map<String, dynamic>> event) {
        for (var element in event) {
          loggerProvider?.addLog(element);
        }
      });
      var networkStream = await supabaseProvider?.getNetworkStream();
      networkStream?.listen((List<Map<String, dynamic>> event) {
        for (var element in event) {
          networkProvider?.addNetworkCall(NetworkNetworkCall.fromJson(
            element,
          ));
        }
      });
    });
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  Future<void> _refreshLogs() async {
    await supabaseProvider?.setInitialLogData(
      loggerProvider: loggerProvider!,
      networkProvider: networkProvider!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Viewer'),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Log Viewer'),
            Tab(text: 'Network Viewer'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Consumer<HeadlessFlutoLoggerProvider>(
            builder: (context, loggerProvider, child) {
              return DefaultTabController(
                length: FlutoLogType.values.length,
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    bottom: TabBar(
                      tabs: FlutoLogType.values.map((type) {
                        return Tab(text: type.toString().split('.').last);
                      }).toList(),
                    ),
                  ),
                  body: TabBarView(
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
                                    title: Text(logs[index].toString()),
                                  );
                                },
                              ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          Consumer<FlutoNetworkProvider>(
            builder: (context, networkProvider, child) {
              List<NetworkNetworkCall> networkCalls =
                  networkProvider.networkCalls;
              return RefreshIndicator(
                onRefresh: _refreshLogs,
                child: networkCalls.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('No network calls available.'),
                        ),
                      )
                    : ListView.builder(
                        itemCount: networkCalls.length,
                        itemBuilder: (_, index) {
                          return ListTile(
                            title: Text(
                              networkCalls[index].toString(),
                            ),
                          );
                        },
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
