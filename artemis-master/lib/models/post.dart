import 'package:vector_math/vector_math_64.dart' as vector;

class Post {
  final String id;
  final String text;
  final vector.Vector3 position;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.text,
    required this.position,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert Post to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'position': {
        'x': position.x,
        'y': position.y,
        'z': position.z,
      },
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // Create Post from Map (for retrieval)
  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      text: map['text'],
      position: vector.Vector3(
        map['position']['x'],
        map['position']['y'],
        map['position']['z'],
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}
