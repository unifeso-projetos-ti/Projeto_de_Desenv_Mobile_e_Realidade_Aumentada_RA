import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/rendering.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:uuid/uuid.dart';
import 'package:flutter_app/models/post.dart';

class ARScreen extends StatefulWidget {
  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  ArCoreController? arCoreController;
  final TextEditingController _textController = TextEditingController();
  String message = "";
  List<Post> posts = [];
  bool isCreatingPost = false;
  vector.Vector3? newPostPosition;

  final uuid = Uuid();

  @override
  void dispose() {
    arCoreController?.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AR Social Media'),
      ),
      body: Stack(
        children: [
          // AR View
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableTapRecognizer: true,
          ),

          // Bottom panel for text input and button
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.black54,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text for position status
                  if (isCreatingPost)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Tap in AR space to place your post",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),

                  // Text input field
                  TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter your post text',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white12,
                    ),
                    style: TextStyle(color: Colors.white),
                    enabled: !isCreatingPost,
                  ),
                  SizedBox(height: 12),

                  // Button to create post
                  ElevatedButton(
                    onPressed: isCreatingPost ? null : _startCreatingPost,
                    child: Text('Create AR Post'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Display message when sphere is clicked
          if (message.isNotEmpty)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;

    // Handle node taps (show post message)
    controller.onNodeTap = (name) {
      // Find the post associated with this node
      for (var post in posts) {
        if (name == "post_${post.id}") {
          setState(() {
            message = post.text;

            // Hide the message after 3 seconds
            Future.delayed(Duration(seconds: 3), () {
              if (mounted) {
                setState(() {
                  message = "";
                });
              }
            });
          });
          break;
        }
      }
    };

    // Handle plane detection for placement
    controller.onPlaneTap = (List<ArCoreHitTestResult> hitResults) {
      if (isCreatingPost && hitResults.isNotEmpty) {
        final hitResult = hitResults.first;
        final hitPosition = hitResult.pose.translation;
        newPostPosition =
            vector.Vector3(hitPosition.x, hitPosition.y, hitPosition.z);
        _createPost();
      }
    };
  }

  void _startCreatingPost() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter text for your post')));
      return;
    }

    setState(() {
      isCreatingPost = true;
    });
  }

  void _createPost() {
    if (arCoreController == null || newPostPosition == null) return;

    // Create a new Post object
    final post = Post(
      id: uuid.v4(),
      text: _textController.text,
      position: newPostPosition!,
    );

    // Add to posts list
    posts.add(post);

    // Create sphere for this post
    _addSphereForPost(post);

    // Reset state
    setState(() {
      isCreatingPost = false;
      _textController.clear();
      newPostPosition = null;
    });

    // Show confirmation
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Post created successfully!')));
  }

  void _addSphereForPost(Post post) {
    if (arCoreController == null) return;

    // Create a material with semi-random color based on post ID
    // This helps visually distinguish different posts
    final int colorValue =
        int.parse(post.id.substring(0, 6), radix: 16) | 0xFF000000;
    final material = ArCoreMaterial(
      color: Color(colorValue),
      metallic: 1.0,
    );

    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.1,
    );

    final node = ArCoreNode(
      shape: sphere,
      position: post.position,
      name: "post_${post.id}",
    );

    arCoreController?.addArCoreNode(node);
  }
}
