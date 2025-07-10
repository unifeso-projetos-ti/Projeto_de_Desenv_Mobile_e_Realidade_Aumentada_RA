import 'package:ar_flutter_plugin_2/models/ar_anchor.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

class MeasurementSegment {
  final List<ARNode> lineNodes;
  final List<ARAnchor> lineAnchors;
  final vector_math.Vector3 position;
  final double distance;

  MeasurementSegment({
    required this.lineNodes,
    required this.lineAnchors,
    required this.position,
    required this.distance,
  });
}
