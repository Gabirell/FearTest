import 'package:flutter/material.dart';
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart' as vm;

void main() {
  runApp(const FearTestApp());
}

class FearTestApp extends StatelessWidget {
  const FearTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DavidTestScene(),
    );
  }
}

class DavidTestScene extends StatefulWidget {
  const DavidTestScene({super.key});

  @override
  State<DavidTestScene> createState() => _DavidTestSceneState();
}

class _DavidTestSceneState extends State<DavidTestScene> {
  final Scene scene = Scene();

  bool ready = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadScene();
  }

  Future<void> _loadScene() async {
    try {
      await Scene.initializeStaticResources();

      final david = await loadScene(
        'assets/models/David-model-rigged.glb',
      );

      // Start David at the origin.
      david.position = vm.Vector3.zero();

      scene.add(david);

      if (!mounted) return;

      setState(() {
        ready = true;
      });
    } catch (e, stackTrace) {
      debugPrint('FearTest scene error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Failed to load David:\\n\\n$error',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    if (!ready) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SceneView(
        scene,
        camera: PerspectiveCamera(
          position: vm.Vector3(0, 2, 6),
          target: vm.Vector3(0, 1, 0),
        ),
      ),
    );
  }
}
