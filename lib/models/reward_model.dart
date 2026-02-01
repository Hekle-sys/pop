class Reward {
  final String id;
  final String name;
  final String type; // 'skin', 'badge', 'theme'
  final int requiredPopCorns;
  final String category; // 'corn', 'particle', 'ui'
  final Map<String, dynamic> metadata;

  Reward({
    required this.id,
    required this.name,
    required this.type,
    required this.requiredPopCorns,
    required this.category,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'requiredPopCorns': requiredPopCorns,
      'category': category,
      'metadata': metadata,
    };
  }

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      requiredPopCorns: json['requiredPopCorns'] as int,
      category: json['category'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }
}

// Rewards prédéfinis
final List<Reward> defaultRewards = [
  Reward(
    id: 'corn_halloween',
    name: 'Corn Halloween',
    type: 'skin',
    requiredPopCorns: 10,
    category: 'corn',
  ),
  Reward(
    id: 'corn_christmas',
    name: 'Corn Christmas',
    type: 'skin',
    requiredPopCorns: 20,
    category: 'corn',
  ),
  Reward(
    id: 'theme_dark',
    name: 'Dark Theme',
    type: 'theme',
    requiredPopCorns: 15,
    category: 'ui',
  ),
];
