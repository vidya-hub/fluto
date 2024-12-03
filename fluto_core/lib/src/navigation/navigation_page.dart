import 'package:flutter/material.dart';
import 'package:graphite/graphite.dart';

class NavigationPage extends StatelessWidget {
  final List<NodeInput> flowChart = [
    NodeInput(id: "start", next: [EdgeInput(outcome: "navigation_track")]),
    NodeInput(
        id: "navigation_track", next: [EdgeInput(outcome: "route_added")]),
    NodeInput(id: "route_added", next: [EdgeInput(outcome: "navigation_page")]),
    NodeInput(
        id: "navigation_page",
        size: const NodeSize(width: 100, height: 100),
        next: [EdgeInput(outcome: "list_view")]),
    NodeInput(id: "list_view", next: [EdgeInput(outcome: "end")]),
    NodeInput(id: "end", next: []),
  ];

  final Map<String, FlowStep> data = {
    "start": FlowStep(text: "App Start", type: FlowStepType.start),
    "navigation_track":
        FlowStep(text: "Track Navigation", type: FlowStepType.process),
    "route_added": FlowStep(text: "Add Route", type: FlowStepType.process),
    "navigation_page":
        FlowStep(text: "Navigation Page", type: FlowStepType.decision),
    "list_view": FlowStep(text: "Render Routes", type: FlowStepType.process),
    "end": FlowStep(text: "End", type: FlowStepType.end),
  };

  NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Flow')),
      body: Center(
        child: DirectGraph(
          cellPadding: const EdgeInsets.all(2),
          list: flowChart,
          defaultCellSize: const Size(200.0, 100.0),
          nodeBuilder: (context, node) => _buildNode(node),
          orientation: MatrixOrientation.Vertical,
        ),
      ),
    );
  }

  Widget _buildNode(NodeInput node) {
    final info = data[node.id]!;
    return Container(
      decoration: BoxDecoration(
        color: _getColorForType(info.type),
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          info.text,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Color _getColorForType(FlowStepType type) {
    switch (type) {
      case FlowStepType.start:
        return Colors.green;
      case FlowStepType.process:
        return Colors.blue;
      case FlowStepType.decision:
        return Colors.orange;
      case FlowStepType.end:
        return Colors.red;
    }
  }
}

enum FlowStepType { start, process, decision, end }

class FlowStep {
  final String text;
  final FlowStepType type;

  FlowStep({required this.text, required this.type});
}
