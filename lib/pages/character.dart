import 'package:flutter/material.dart';
import 'package:my_app/services/quest_service.dart';
import 'package:my_app/services/user_service.dart';
import 'package:my_app/services/lazy_loading_service.dart';
import 'package:my_app/models/ranking_system.dart';
import 'package:my_app/models/avatar.dart';
import 'package:my_app/models/shop_items.dart';

class Character extends StatefulWidget {
  const Character({super.key});

  @override
  State<Character> createState() => _CharacterState();
}

class _CharacterState extends State<Character> with WidgetsBindingObserver {
  double totalXP = 0;
  int userGold = 0;
  int level = 1;
  int completedQuests = 0;
  int pendingQuests = 0;
  int dailyStreak = 0;
  bool isLoading = true;

  // Ranking system data
  Rank currentRank = Rank.bronzeV;
  RankRewards rankRewards = RankingSystem.getRankRewards(Rank.bronzeV);
  int xpRequired = 0;
  double rankProgress = 0.0;

  // Avatar data
  String currentAvatarId = 'default';
  Avatar currentAvatar = AvatarCollection.getDefaultAvatar();

  // Inventory data
  Map<String, int> inventory = {};

  // Active booster status
  bool xpBoosterActive = false;
  bool goldBoosterActive = false;
  bool streakProtectionActive = false;
  int xpBoosterQuestsLeft = 0;
  int goldBoosterQuestsLeft = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
    _preloadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Method to refresh data when returning from other screens
  void refreshOnReturn() {
    if (mounted && !isLoading) {
      _refreshData();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && mounted && !isLoading) {
      // Refresh data when app becomes active again
      _refreshData();
    }
  }

  // Preload data in background
  void _preloadData() {
    LazyLoadingService.preloadData('character_stats', () => QuestService.getQuestStats());
    LazyLoadingService.preloadData('character_gold', () => UserService.getUserGold());
    LazyLoadingService.preloadData('character_current_avatar', () => UserService.getCurrentAvatar());
    LazyLoadingService.preloadData('character_inventory', () => UserService.getUserInventory());
    LazyLoadingService.preloadData('character_user_data', () => UserService.getUserData());
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Load data with lazy loading
      final batchResults = await LazyLoadingService.batchLoadData({
        'character_stats': () => QuestService.getQuestStats(),
        'character_gold': () => UserService.getUserGold(),
        'character_current_avatar': () => UserService.getCurrentAvatar(),
        'character_inventory': () => UserService.getUserInventory(),
        'character_user_data': () => UserService.getUserData(),
      });

      final stats = batchResults['character_stats'] as Map<String, dynamic>;
      final gold = batchResults['character_gold'] as int;
      final currentAvatarId = batchResults['character_current_avatar'] as String;
      final userInventory = batchResults['character_inventory'] as Map<String, int>;
      final userData = batchResults['character_user_data'] as Map<String, dynamic>;

      // Load ranking data
      final rankInfo = await UserService.getRankInfo(stats['totalXP']);

      // Get current avatar
      final avatars = AvatarCollection.getAllAvatars();
      final currentAvatar = avatars.firstWhere(
        (a) => a.id == currentAvatarId,
        orElse: () => AvatarCollection.getDefaultAvatar(),
      );

      setState(() {
        totalXP = stats['totalXP'];
        userGold = gold;
        level = stats['level'];
        completedQuests = stats['completedQuests'];
        pendingQuests = stats['pendingQuests'];
        dailyStreak = stats['dailyStreak'];

        // Ranking data
        currentRank = rankInfo['currentRank'];
        rankRewards = rankInfo['rankRewards'];
        xpRequired = rankInfo['xpRequired'];
        rankProgress = rankInfo['progress'];

        // Avatar data
        this.currentAvatarId = currentAvatarId;
        this.currentAvatar = currentAvatar;

        // Inventory data
        inventory = userInventory;

        // Active booster status
        this.xpBoosterActive = userData['xpBoosterActive'] ?? false;
        this.goldBoosterActive = userData['goldBoosterActive'] ?? false;
        this.streakProtectionActive = userData['streakProtectionActive'] ?? false;
        this.xpBoosterQuestsLeft = userData['xpBoosterQuestsLeft'] ?? 0;
        this.goldBoosterQuestsLeft = userData['goldBoosterQuestsLeft'] ?? 0;

        isLoading = false;
      });
    } catch (e) {
      print('Error loading character data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Refresh data (clear cache and reload)
  Future<void> _refreshData() async {
    LazyLoadingService.clearCache('character_stats');
    LazyLoadingService.clearCache('character_gold');
    LazyLoadingService.clearCache('character_current_avatar');
    LazyLoadingService.clearCache('character_inventory');
    LazyLoadingService.clearCache('character_user_data');
    await _loadData();
  }

  Future<void> _useItem(String itemId) async {
    try {
      bool success = false;
      String message = '';
      
      switch (itemId) {
        case 'xp_booster':
          success = await UserService.activateXPBooster();
          message = success ? 'XP Booster activated! Get 2x XP for next 3 quests.' : 'Failed to activate XP Booster.';
          break;
        case 'gold_booster':
          success = await UserService.activateGoldBooster();
          message = success ? 'Gold Booster activated! Get 1.5x gold for next 5 quests.' : 'Failed to activate Gold Booster.';
          break;
        case 'streak_protector':
          success = await UserService.useStreakProtector();
          message = success ? 'Streak Protector activated! Your daily streak is protected for 24 hours.' : 'Failed to activate Streak Protector.';
          break;
        case 'quest_extension':
          // This is handled in quest details, show info
          message = 'Quest Extension can be used from quest details when a quest has a deadline.';
          success = true;
          break;
        default:
          message = 'Unknown item type.';
          success = false;
      }

      if (success && itemId != 'quest_extension') {
        // Clear cache and reload data to update inventory and active effects
        await _refreshData();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error using item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 27, 23),
        title: Text(
          'Character',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 172, 245, 0),
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 28, 27, 23),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 172, 245, 0),
                ),
              )
            : RefreshIndicator(
              onRefresh: _refreshData,
              color: Color.fromARGB(255, 172, 245, 0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Character Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            currentAvatar.color.withOpacity(0.15),
                            currentAvatar.color.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: currentAvatar.color.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: currentAvatar.color.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              currentAvatar.imagePath,
                                width: 56,
                                height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.person,
                                    color: currentAvatar.color,
                                      size: 32,
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Character Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentAvatar.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  currentAvatar.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: currentAvatar.rarityColor
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    currentAvatar.rarityText,
                                    style: TextStyle(
                                      color: currentAvatar.rarityColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Rank Information
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 53, 51, 51),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: rankRewards.rankColor.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                rankRewards.rankIcon,
                                color: rankRewards.rankColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Rank Information',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Rank Stats Row
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Current Rank',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      rankRewards.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: rankRewards.rankColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Gold Bonus',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '+${rankRewards.goldBonus}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // XP Multiplier and Progress
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'XP Multiplier',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${(rankRewards.xpMultiplier * 100).toInt()}%',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (xpRequired > 0)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'XP to Next',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      xpRequired.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: rankRewards.rankColor,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),

                          // Progress Bar
                          if (xpRequired > 0) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Progress to Next Rank',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(
                              value: rankProgress,
                              backgroundColor: Colors.grey[700],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                rankRewards.rankColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Statistics
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 53, 51, 51),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.analytics,
                                color: const Color.fromARGB(255, 172, 245, 0),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Statistics',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Stats Grid
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Total XP',
                                  totalXP.toStringAsFixed(0),
                                  Icons.show_chart,
                                  Colors.green,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildStatCard(
                                  'Gold',
                                  userGold.toString(),
                                  '₱',
                                  Colors.amber,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Level',
                                  level.toString(),
                                  Icons.trending_up,
                                  Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildStatCard(
                                  'Daily Streak',
                                  dailyStreak.toString(),
                                  Icons.local_fire_department,
                                  Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Completed',
                                  completedQuests.toString(),
                                  Icons.check_circle,
                                  Colors.green,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildStatCard(
                                  'Pending',
                                  pendingQuests.toString(),
                                  Icons.pending,
                                  Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Daily Streak Calendar
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 53, 51, 51),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: const Color.fromARGB(255, 172, 245, 0),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Daily Streak',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      dailyStreak.toString(),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Text(
                                      'Day Streak',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.local_fire_department,
                                      color: dailyStreak > 0 ? Colors.orange : Colors.grey,
                                      size: 32,
                                    ),
                                    Text(
                                      dailyStreak > 0 ? 'On Fire!' : 'Start your streak',
                                      style: TextStyle(
                                        color: dailyStreak > 0 ? Colors.orange : Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (streakProtectionActive) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.shield, color: Colors.blue, size: 16),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      'Streak protected for 24 hours',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Add spacing after Daily Streak (always)
                    const SizedBox(height: 16),

                    // Active Effects Section
                    if (xpBoosterActive || goldBoosterActive || streakProtectionActive)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 53, 51, 51),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.flash_on,
                                  color: const Color.fromARGB(255, 172, 245, 0),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Active Effects',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (xpBoosterActive)
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.trending_up, color: Colors.green, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'XP Booster Active ($xpBoosterQuestsLeft quests left)',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (goldBoosterActive)
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.account_balance, color: Colors.amber, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Gold Booster Active ($goldBoosterQuestsLeft quests left)',
                                        style: const TextStyle(
                                          color: Colors.amber,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (streakProtectionActive)
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.shield, color: Colors.blue, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: const Text(
                                        'Streak Protection Active',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                    // Add spacing after Active Effects section
                    const SizedBox(height: 16),

                    // Inventory
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 53, 51, 51),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.inventory,
                                color: const Color.fromARGB(255, 172, 245, 0),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Inventory',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          if (inventory.isEmpty)
                            Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.inventory_2,
                                    color: Colors.grey,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No items in inventory',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Visit the shop to buy items!',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            ...inventory.entries.map((entry) {
                              final item = ShopItems.getItemById(entry.key);
                              if (item == null) return SizedBox.shrink();

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      item.icon,
                                      color: item.color,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Quantity: ${entry.value}',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.7),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Use button for consumable items
                                    if (item.isConsumable && entry.value > 0)
                                      ElevatedButton(
                                        onPressed: () => _useItem(item.id),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: item.color,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          minimumSize: const Size(0, 32),
                                        ),
                                        child: const Text(
                                          'Use',
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    dynamic icon, // Changed from IconData to dynamic to support both IconData and String
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          icon is IconData
              ? Icon(icon, color: color, size: 20)
              : Text(
                  icon,
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10)),
        ],
      ),
    );
  }
}
