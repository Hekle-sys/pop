import 'package:flutter/material.dart';
import 'package:pop/models/reward_model.dart';
import 'package:pop/models/user_model.dart';
import 'package:pop/storage/app_storage.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  late UserProfile _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await AppStorage.loadUserProfile();
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  bool _isRewardUnlocked(Reward reward) {
    return _user.totalPopCorns >= reward.requiredPopCorns;
  }

  Future<void> _unlockReward(Reward reward) async {
    if (!_isRewardUnlocked(reward)) return;

    if (!_user.unlockedSkins.contains(reward.id)) {
      final updated = _user.copyWith(
        unlockedSkins: [..._user.unlockedSkins, reward.id],
      );
      await AppStorage.saveUserProfile(updated);
      await _loadUser();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 ${reward.name} débloqué!'),
            duration: const Duration(milliseconds: 800),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        title: const Text('Récompenses'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Barre de progression pop corn
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Pop Corns Accumulés',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '🍿 ${_user.totalPopCorns}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: 0.5, // À adapter selon le palier max
                        minHeight: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.amber[600]!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Récompenses
              Text(
                'Récompenses disponibles',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 16),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: defaultRewards.length,
                itemBuilder: (context, index) {
                  final reward = defaultRewards[index];
                  final isUnlocked = _isRewardUnlocked(reward);
                  final isOwned =
                      _user.unlockedSkins.contains(reward.id);

                  return GestureDetector(
                    onTap: isUnlocked && !isOwned
                        ? () => _unlockReward(reward)
                        : null,
                    child: Card(
                      elevation: isOwned ? 3 : 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isOwned ? Colors.green[300]! : Colors.grey[300]!,
                          width: isOwned ? 2 : 1,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isOwned
                              ? Colors.green[50]
                              : isUnlocked
                                  ? Colors.white
                                  : Colors.grey[100],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _getRewardEmoji(reward.id),
                              style: const TextStyle(fontSize: 48),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              reward.name,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            if (isOwned)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  '✓ Possédé',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            else
                              Text(
                                '🍿 ${reward.requiredPopCorns}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isUnlocked
                                      ? Colors.green
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRewardEmoji(String rewardId) {
    switch (rewardId) {
      case 'corn_halloween':
        return '🎃';
      case 'corn_christmas':
        return '🎄';
      case 'theme_dark':
        return '🌙';
      default:
        return '🎁';
    }
  }
}
