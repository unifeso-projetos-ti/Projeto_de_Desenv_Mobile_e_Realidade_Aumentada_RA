import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:camera/camera.dart';

class Product3DViewScreen extends StatefulWidget {
  final String modelPath;

  const Product3DViewScreen({super.key, required this.modelPath});

  @override
  _Product3DViewScreenState createState() => _Product3DViewScreenState();
}

class _Product3DViewScreenState extends State<Product3DViewScreen> {
  late Scene _scene;
  double _scale = 2.0; // Escala inicial do modelo
  final Vector3 _position = Vector3(0, 0, 3); // Posição inicial da câmera
  Object? _model;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras!.first,
      ResolutionPreset.high,
    );
    await _cameraController!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    _scene.camera.position.z = _position.z; // Define a posição inicial da câmera

    // Carrega o modelo 3D com textura
    _model = Object(
      fileName: widget.modelPath,
      scale: Vector3(_scale, _scale, _scale),
    );

    print('Carregando modelo: ${widget.modelPath}');
    _scene.world.add(_model!);
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Visualização 3D')),
      body: Stack(
        children: [
          // Feed da câmera
          CameraPreview(_cameraController!),
          // Modelo 3D sobreposto
          Positioned.fill(
            child: GestureDetector(
              onScaleUpdate: (details) {
                if (details.pointerCount == 1) {
                  _updatePosition(details.focalPointDelta);
                }
                if (details.pointerCount == 2 && details.scale != 1.0) {
                  _updateScale(details.scale > 1.0 ? 0.1 : -0.1);
                }
              },
              child: Cube(
                onSceneCreated: _onSceneCreated,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'zoomIn',
            onPressed: () => _updateZoom(-0.5), // Zoom in
            child: const Icon(Icons.zoom_in),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'zoomOut',
            onPressed: () => _updateZoom(0.5), // Zoom out
            child: const Icon(Icons.zoom_out),
          ),
        ],
      ),
    );
  }

  void _updateScale(double scaleDelta) {
    setState(() {
      _scale = (_scale + scaleDelta).clamp(0.5, 5.0); // Limita a escala
      if (_model != null) {
        _model!.scale.setValues(_scale, _scale, _scale);
        _scene.update();
      }
    });
  }

  void _updatePosition(Offset delta) {
    setState(() {
      _position.x -= delta.dx * 0.01; // Sensibilidade horizontal
      _position.y += delta.dy * 0.01; // Sensibilidade vertical
      _scene.camera.position.setValues(_position.x, _position.y, _position.z);
      _scene.update();
    });
  }

  void _updateZoom(double zoomDelta) {
    setState(() {
      _position.z = (_position.z + zoomDelta).clamp(1.0, 10.0); // Limita o zoom
      _scene.camera.position.z = _position.z;
      _scene.update();
    });
  }
}