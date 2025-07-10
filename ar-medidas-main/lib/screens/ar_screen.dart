import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;
import 'package:screenshot/screenshot.dart';
import 'package:gal/gal.dart';
import 'package:ar_flutter_plugin_2/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_2/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_2/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/models/ar_anchor.dart';
import 'package:ar_flutter_plugin_2/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
import '../models/measurement_segment.dart';
import '../models/measurement.dart';
import '../screens/history_screen.dart';
import '../services/firebase_service.dart';
import '../theme/app_styles.dart';

class ArScreen extends StatefulWidget {
  const ArScreen({super.key});

  @override
  State<ArScreen> createState() => _ArScreenState();
}

class _ArScreenState extends State<ArScreen> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  final ScreenshotController screenshotController = ScreenshotController();
  List<MeasurementSegment> measurementSegments = [];

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  String selectedUnit = 'cm';
  vector_math.Vector3? lastPosition;
  String? lastDistance;
  late double currentDistance;
  double totalDistance = 0.0;

  @override
  void dispose() {
    super.dispose();
    arSessionManager?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'AR Medidas',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
          ),
        ),
        leading: IconButton(
          icon: AppStyles.backIcon,
          tooltip: 'Retornar',
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: AppStyles.historyIcon,
            iconSize: 38,
            tooltip: 'Acessar o Histórico de Medições',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Stack(
          children: [
            ARView(
              onARViewCreated: onARViewCreated,
              planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
            ),
            Align(
              alignment: const FractionalOffset(0.5, 0.985),
              child: Tooltip(
                message: 'Remover Todas Medições',
                child: SizedBox(
                  width: 206.5,
                  child: ElevatedButton(
                    onPressed: onRemoveEverything,
                    child: Text("Remover Tudo", style: AppStyles.buttonText),
                  ),
                ),
              ),
            ),
            if (totalDistance > 0.0)
              const SizedBox(height: AppStyles.spacingMedium),
            Align(
              alignment: const FractionalOffset(0.5, 0.9),
              child: Tooltip(
                message: 'Salvar Medição',
                child: SizedBox(
                  width: 206.5,
                  child: ElevatedButton(
                    onPressed: _saveMeasurement,
                    child: Text("Salvar Medição", style: AppStyles.buttonText),
                  ),
                ),
              ),
            ),
            Align(
              alignment: const FractionalOffset(0.945, 0.948),
              child: FloatingActionButton(
                onPressed: takeScreenshot,
                tooltip: 'Capturar Tela',
                child: AppStyles.screenShotIcon,
              ),
            ),
            Align(
              alignment: const FractionalOffset(0.055, 0.948),
              child: FloatingActionButton(
                onPressed: onUndo,
                tooltip: 'Desfazer Medição',
                child: AppStyles.undoIcon,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 112.0),
                child: Tooltip(
                  message: 'Selecionar a unidade de medida',
                  child: DropdownMenu<String>(
                    initialSelection: selectedUnit,
                    trailingIcon: Tooltip(
                      message: 'Abrir lista de unidades',
                      child: AppStyles.arrowDownIcon(context),
                    ),
                    selectedTrailingIcon: Tooltip(
                      message: 'Fechar lista de unidades',
                      child: AppStyles.arrowUpIcon(context),
                    ),
                    inputDecorationTheme: AppStyles.inputDecoration(context),
                    textStyle: AppStyles.listTileTitle(context),
                    onSelected: (value) {
                      setState(() {
                        selectedUnit = value!;
                      });
                      if (lastDistance != null) {
                        setState(() {
                          lastDistance =
                              "Distância Atual: ${_formatDistance(currentDistance, selectedUnit)}\nDistância Total: ${_formatDistance(totalDistance, selectedUnit)}";
                        });
                      }
                    },
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: 'mm',
                        label: 'Milímetros',
                        labelWidget: Tooltip(
                          message: 'Mudar a unidade para milímetros',
                          child: Text(
                            'Milímetros',
                            style: AppStyles.listTileTitle(
                              context,
                            ).copyWith(fontSize: 14),
                          ),
                        ),
                      ),
                      DropdownMenuEntry(
                        value: 'cm',
                        label: 'Centímetros',
                        labelWidget: Tooltip(
                          message: 'Mudar a unidade para centímetros',
                          child: Text(
                            'Centímetros',
                            style: AppStyles.listTileTitle(
                              context,
                            ).copyWith(fontSize: 14),
                          ),
                        ),
                      ),
                      DropdownMenuEntry(
                        value: 'm',
                        label: 'Metros',
                        labelWidget: Tooltip(
                          message: 'Mudar a unidade para metros',
                          child: Text(
                            'Metros',
                            style: AppStyles.listTileTitle(
                              context,
                            ).copyWith(fontSize: 14),
                          ),
                        ),
                      ),
                      DropdownMenuEntry(
                        value: 'in',
                        label: 'Polegadas',
                        labelWidget: Tooltip(
                          message: 'Mudar a unidade para polegadas',
                          child: Text(
                            'Polegadas',
                            style: AppStyles.listTileTitle(
                              context,
                            ).copyWith(fontSize: 14),
                          ),
                        ),
                      ),
                      DropdownMenuEntry(
                        value: 'ft',
                        label: 'Pés',
                        labelWidget: Tooltip(
                          message: 'Mudar a unidade para pés',
                          child: Text(
                            'Pés',
                            style: AppStyles.listTileTitle(
                              context,
                            ).copyWith(fontSize: 14),
                          ),
                        ),
                      ),
                      DropdownMenuEntry(
                        value: 'yd',
                        label: 'Jardas',
                        labelWidget: Tooltip(
                          message: 'Mudar a unidade para jardas',
                          child: Text(
                            'Jardas',
                            style: AppStyles.listTileTitle(
                              context,
                            ).copyWith(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                    menuStyle: AppStyles.menu(context),
                  ),
                ),
              ),
            ),
            if (lastDistance != null)
              Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(ClipboardData(text: "$lastDistance"));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Distância copiada!"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: AppStyles.paddingMedium,
                        child: Text(
                          "$lastDistance",
                          textAlign: TextAlign.center,
                          style: AppStyles.containerText(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _saveMeasurement() async {
    final measurement = Measurement(
      timestamp: DateTime.now(),
      totalDistance: _formatDistance(totalDistance.toDouble(), selectedUnit),
      unit: selectedUnit,
    );

    await MeasurementFirebaseService.addMeasurement(measurement);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Medição salva com sucesso!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager arSessionManager,
    ARObjectManager arObjectManager,
    ARAnchorManager arAnchorManager,
    ARLocationManager arLocationManager,
  ) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
      showFeaturePoints: true,
      showPlanes: false,
      showWorldOrigin: false,
    );
    this.arObjectManager!.onInitialize();
    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
  }

  Future<void> onRemoveEverything() async {
    for (var anchor in anchors) {
      arAnchorManager!.removeAnchor(anchor);
    }
    for (var node in nodes) {
      arObjectManager!.removeNode(node);
    }
    anchors.clear();
    nodes.clear();
    lastPosition = null;
    totalDistance = 0.0;
    setState(() {
      lastDistance = null;
    });
  }

  Future<void> onPlaneOrPointTapped(
    List<ARHitTestResult> hitTestResults,
  ) async {
    var singleHitTestResult = hitTestResults.firstWhere(
      (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane,
    );

    var position = vector_math.Vector3(
      singleHitTestResult.worldTransform.getColumn(3).x,
      singleHitTestResult.worldTransform.getColumn(3).y,
      singleHitTestResult.worldTransform.getColumn(3).z,
    );

    var newAnchor = ARPlaneAnchor(
      transformation: singleHitTestResult.worldTransform,
    );

    bool? didAddAnchor = await arAnchorManager!.addAnchor(newAnchor);

    if (didAddAnchor!) {
      anchors.add(newAnchor);

      if (!mounted) return;

      var newNode = ARNode(
        type: NodeType.localGLTF2,
        uri: Theme.of(context).brightness == Brightness.light
            ? "assets/turquoise_sphere.glb"
            : "assets/dark_turquoise_sphere.glb",
        scale: vector_math.Vector3.all(0.03),
        position: vector_math.Vector3.zero(),
      );

      bool? didAddNodeToAnchor = await arObjectManager!.addNode(
        newNode,
        planeAnchor: newAnchor,
      );

      if (didAddNodeToAnchor!) {
        nodes.add(newNode);
      }

      if (lastPosition == null) {
        measurementSegments.add(
          MeasurementSegment(
            lineNodes: [],
            lineAnchors: [],
            position: position,
            distance: 0.0,
          ),
        );
      } else {
        List<ARNode> segmentNodes = [];
        List<ARAnchor> segmentAnchors = [];
        int numberOfNodes = 20;

        for (int i = 1; i <= numberOfNodes; i++) {
          var interpolatedPosition =
              lastPosition! +
              (position - lastPosition!) * (i / (numberOfNodes + 1));

          var transform = vector_math.Matrix4.identity()
            ..setTranslation(interpolatedPosition);

          var lineAnchor = ARPlaneAnchor(transformation: transform);
          bool? anchorAdded = await arAnchorManager!.addAnchor(lineAnchor);

          if (anchorAdded!) {
            anchors.add(lineAnchor);
            segmentAnchors.add(lineAnchor);

            if (!mounted) return;

            var lineNode = ARNode(
              type: NodeType.localGLTF2,
              uri: Theme.of(context).brightness == Brightness.light
                  ? "assets/yellow_sphere.glb"
                  : "assets/dark_yellow_sphere.glb",
              scale: vector_math.Vector3.all(0.015),
              position: vector_math.Vector3.zero(),
            );

            bool? nodeAddedToAnchor = await arObjectManager!.addNode(
              lineNode,
              planeAnchor: lineAnchor,
            );

            if (nodeAddedToAnchor!) {
              nodes.add(lineNode);
              segmentNodes.add(lineNode);
            }
          }
        }

        currentDistance = _calculateDistanceBetweenPoints(
          position,
          lastPosition!,
        );
        totalDistance += currentDistance;

        measurementSegments.add(
          MeasurementSegment(
            lineNodes: segmentNodes,
            lineAnchors: segmentAnchors,
            position: lastPosition!,
            distance: currentDistance,
          ),
        );

        setState(() {
          lastDistance =
              "Distância Atual: ${_formatDistance(currentDistance, selectedUnit)}\nDistância Total: ${_formatDistance(totalDistance, selectedUnit)}";
        });
      }

      lastPosition = position;
    }
  }

  double _calculateDistanceBetweenPoints(
    vector_math.Vector3 A,
    vector_math.Vector3 B,
  ) {
    return A.distanceTo(B);
  }

  String _formatDistance(double distance, String unit) {
    switch (unit) {
      case 'mm':
        return "${(distance * 1000).toStringAsFixed(2)} mm";
      case 'cm':
        return "${(distance * 100).toStringAsFixed(2)} cm";
      case 'in':
        return "${(distance * 39.3701).toStringAsFixed(2)} in";
      case 'ft':
        return "${(distance * 3.28084).toStringAsFixed(2)} ft";
      case 'yd':
        return "${(distance * 1.09361).toStringAsFixed(2)} yd";
      case 'm':
      default:
        return "${distance.toStringAsFixed(2)} m";
    }
  }

  Future<void> onUndo() async {
    if (measurementSegments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nenhuma medição para ser desfeita!'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    final lastSegment = measurementSegments.removeLast();

    for (var node in lastSegment.lineNodes) {
      await arObjectManager!.removeNode(node);
      nodes.remove(node);
    }

    for (var anchor in lastSegment.lineAnchors) {
      await arAnchorManager!.removeAnchor(anchor);
      anchors.remove(anchor);
    }

    if (nodes.isNotEmpty) {
      await arObjectManager!.removeNode(nodes.last);
      nodes.removeLast();
    }

    if (anchors.isNotEmpty) {
      await arAnchorManager!.removeAnchor(anchors.last);
      anchors.removeLast();
    }

    totalDistance -= lastSegment.distance;

    lastPosition = lastSegment.position;

    setState(() {
      if (measurementSegments.isNotEmpty) {
        currentDistance = measurementSegments.last.distance;
        lastDistance =
            "Distância Atual: ${_formatDistance(currentDistance, selectedUnit)}\nDistância Total: ${_formatDistance(totalDistance, selectedUnit)}";
      } else {
        lastPosition = null;
        currentDistance = 0.0;
        lastDistance = null;
      }
    });
  }

  Future<void> takeScreenshot() async {
    final image = await screenshotController.capture();

    String getErrorMessage(GalExceptionType type) {
      switch (type) {
        case GalExceptionType.accessDenied:
          return 'Você não tem permissão para acessar a Galeria.';
        case GalExceptionType.notEnoughSpace:
          return 'Sem espaço suficiente para salvar a imagem.';
        case GalExceptionType.notSupportedFormat:
          return 'Formato de arquivo não suportado.';
        case GalExceptionType.unexpected:
          return 'Ocorreu um erro inesperado.';
      }
    }

    if (image == null) return;

    try {
      await Gal.putImageBytes(image, album: 'Screenshots');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Captura de tela salva com sucesso!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } on GalException catch (e) {
      log(getErrorMessage(e.type));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(getErrorMessage(e.type)),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
