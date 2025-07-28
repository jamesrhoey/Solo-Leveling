import 'package:flutter/material.dart';
import 'package:my_app/pages/Quests.dart';
import 'package:my_app/services/quest_service.dart';
import 'package:my_app/services/user_service.dart';
import 'package:my_app/services/lazy_loading_service.dart';
import 'package:my_app/models/ranking_system.dart';
import 'package:my_app/models/avatar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Data that will be loaded from the service
  double totalXP = 0;
  double userGold = 0;
  int level = 1;
  int completedQuests = 0;
  int pendingQuests = 0;
  int dailyStreak = 0;
  List<Quests> recentQuests = [];
  bool isLoading = true;

  // Ranking system data
  Rank currentRank = Rank.bronzeV;
  RankRewards rankRewards = RankingSystem.getRankRewards(Rank.bronzeV);
  int xpRequired = 0;
  double rankProgress = 0.0;

  // Avatar data
  String currentAvatarId = 'default';
  Avatar currentAvatar = AvatarCollection.getDefaultAvatar();

  // Active booster status
  bool xpBoosterActive = false;
  bool goldBoosterActive = false;
  bool streakProtectionActive = false;
  int xpBoosterQuestsLeft = 0;
  int goldBoosterQuestsLeft = 0;

  // Shop notification
  bool hasAffordableItems = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _preloadData();
  }

  // Preload data in background
  void _preloadData() {
    LazyLoadingService.preloadData('quest_stats', () => QuestService.getQuestStats());
    LazyLoadingService.preloadData('recent_quests', () => QuestService.getCompletedQuests(limit: 5));
    LazyLoadingService.preloadData('user_gold', () => UserService.getUserGold());
    LazyLoadingService.preloadData('user_data', () => UserService.getUserData());
    LazyLoadingService.preloadData('affordable_items', () => UserService.hasAffordableItems());
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Initialize sample data if needed
      await QuestService.initializeSampleData();
      
      // Check for daily quest streak loss
      await QuestService.checkDailyQuestStreakLoss();

      // Load data with lazy loading
      final batchResults = await LazyLoadingService.batchLoadData({
        'quest_stats': () => QuestService.getQuestStats(),
        'recent_quests': () => QuestService.getCompletedQuests(limit: 5),
        'user_gold': () => UserService.getUserGold(),
        'user_data': () => UserService.getUserData(),
        'affordable_items': () => UserService.hasAffordableItems(),
      });

      final stats = batchResults['quest_stats'] as Map<String, dynamic>;
      final recentCompletedQuests = batchResults['recent_quests'] as List<Quests>;
      final userGold = batchResults['user_gold'] as int;
      final userData = batchResults['user_data'] as Map<String, dynamic>;
      final hasAffordableItems = batchResults['affordable_items'] as bool;

      // Load ranking data
      final rankInfo = await UserService.getRankInfo(stats['totalXP']);

      // Get current avatar
      final currentAvatarId = await UserService.getCurrentAvatar();
      final avatars = AvatarCollection.getAllAvatars();
      final currentAvatar = avatars.firstWhere(
        (a) => a.id == currentAvatarId,
        orElse: () => AvatarCollection.getDefaultAvatar(),
      );

      setState(() {
        totalXP = stats['totalXP'];
        this.userGold = userGold.toDouble();
        level = stats['level'];
        completedQuests = stats['completedQuests'];
        pendingQuests = stats['pendingQuests'];
        dailyStreak = stats['dailyStreak'];
        recentQuests = recentCompletedQuests;

        // Ranking data
        currentRank = rankInfo['currentRank'];
        rankRewards = rankInfo['rankRewards'];
        xpRequired = rankInfo['xpRequired'];
        rankProgress = rankInfo['progress'];

        // Avatar data
        this.currentAvatarId = currentAvatarId;
        this.currentAvatar = currentAvatar;

        // Active booster status
        this.xpBoosterActive = userData['xpBoosterActive'] ?? false;
        this.goldBoosterActive = userData['goldBoosterActive'] ?? false;
        this.streakProtectionActive = userData['streakProtectionActive'] ?? false;
        this.xpBoosterQuestsLeft = userData['xpBoosterQuestsLeft'] ?? 0;
        this.goldBoosterQuestsLeft = userData['goldBoosterQuestsLeft'] ?? 0;

        // Shop notification
        this.hasAffordableItems = hasAffordableItems;

        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Refresh data (clear cache and reload)
  Future<void> _refreshData() async {
    LazyLoadingService.clearCache('quest_stats');
    LazyLoadingService.clearCache('recent_quests');
    LazyLoadingService.clearCache('user_gold');
    LazyLoadingService.clearCache('user_data');
    LazyLoadingService.clearCache('affordable_items');
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 27, 23),
        automaticallyImplyLeading: false, // Remove back button
        title: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromARGB(255, 172, 245, 0),
                width: 2.0,
              ),
            ),
          ),
          child: Text(
            'Questify',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 172, 245, 0),
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 172, 245, 0)),
        actions: [
          // Shop Button
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                IconButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/shop');
                    // Refresh data when returning from shop
                    _refreshData();
                  },
                  icon: Icon(
                    Icons.shop,
                    color: Color.fromARGB(255, 172, 245, 0),
                    size: 24,
                  ),
                  tooltip: 'Shop',
                ),
                // Notification indicator for affordable items
                if (hasAffordableItems)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Profile Avatar
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () async {
                await Navigator.pushNamed(context, '/character');
                // Refresh data when returning from character page
                _refreshData();
              },
              child: ClipOval(
                child: Image.asset(
                  currentAvatar.imagePath,
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.person, color: currentAvatar.color, size: 24),
                ),
              ),
            ),
          ),
        ],
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
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(255, 172, 245, 0).withOpacity(0.08),
                            const Color.fromARGB(255, 172, 245, 0).withOpacity(0.02),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color.fromARGB(255, 172, 245, 0).withOpacity(0.15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 172, 245, 0).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    currentAvatar.imagePath,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Icon(
                                      Icons.person,
                                      color: const Color.fromARGB(255, 172, 245, 0),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                              Text(
                                      'Welcome back, Phunsukh Wangdu!',
                                style: TextStyle(
                                        fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 172, 245, 0),
                                ),
                              ),
                          Text(
                                      'Level $level • $dailyStreak day streak',
                            style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          
                          // Stats Row
                    Row(
                      children: [
                              // XP
                        Expanded(
                                child: Row(
                              children: [
                                Icon(
                                  Icons.show_chart,
                                  color: Colors.green,
                                      size: 18,
                                ),
                                    const SizedBox(width: 6),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                Text(
                                  totalXP.toStringAsFixed(0),
                                  style: TextStyle(
                                            fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                          'XP',
                                  style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.white.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                                  ],
                                ),
                              ),
                              
                              // Divider
                              Container(
                                width: 1,
                                height: 30,
                                color: Colors.white.withOpacity(0.1),
                              ),
                              
                              // Gold
                              Expanded(
                                child: Row(
                              children: [
                                Text(
                                  '₱',
                                  style: TextStyle(
                                    color: Colors.amber,
                                        fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                    const SizedBox(width: 6),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                Text(
                                  userGold.toStringAsFixed(0),
                                  style: TextStyle(
                                            fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                                Text(
                                          'Gold',
                                  style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.white.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                                  ],
                                ),
                              ),
                              
                              // Divider
                              Container(
                                width: 1,
                                height: 30,
                                color: Colors.white.withOpacity(0.1),
                              ),
                              
                              // Rank
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(
                                      rankRewards.rankIcon,
                                      color: rankRewards.rankColor,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            rankRewards.title,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: rankRewards.rankColor,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            'Rank',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Rank Progress
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
                                'Rank Progress',
                                style: const TextStyle(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rankRewards.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: rankRewards.rankColor,
                                      ),
                                    ),
                                    Text(
                                      '${totalXP.toInt()} / ${(totalXP + xpRequired).toInt()} XP',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (xpRequired > 0)
                                Text(
                                  '${xpRequired} XP to next',
                                  style: TextStyle(
                                    color: rankRewards.rankColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: rankProgress,
                            backgroundColor: Colors.grey[700],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              rankRewards.rankColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Quest Progress
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
                                Icons.task,
                                color: const Color.fromARGB(255, 172, 245, 0),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Quest Progress',
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
                                      completedQuests.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 172, 245, 0),
                                      ),
                                    ),
                                    Text(
                                      'Completed',
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
                                    Text(
                                      pendingQuests.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 255, 0, 0),
                                      ),
                                    ),
                                    Text(
                                      'Pending',
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
                                    Text(
                                      dailyStreak.toString(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 253, 132, 3),
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
                            ],
                          ),
                        ],
                      ),
                    ),
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

                    // Recent Completed Quests
                    Text(
                      'Recent Completed Quests',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12),

                    // Show message if no completed quests
                    if (recentQuests.isEmpty)
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 53, 51, 51),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.task_alt, color: Colors.grey, size: 48),
                            SizedBox(height: 12),
                            Text(
                              'No completed quests yet',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Complete some quests to see them here!',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    else
                      // Recent quest cards
                      ...recentQuests
                          .map(
                            (quest) => Container(
                              margin: EdgeInsets.only(bottom: 12),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 53, 51, 51),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Category icon
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: quest.categoryColor.withOpacity(
                                        0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      quest.categoryIcon,
                                      color: quest.categoryColor,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  // Quest info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          quest.title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          quest.description,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: quest.difficultyColor
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                quest.difficultyText,
                                                style: TextStyle(
                                                  color: quest.difficultyColor,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            if (quest.isDaily)
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  'DAILY',
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        if (quest.completedAt != null) ...[
                                          SizedBox(height: 8),
                                          Text(
                                            'Completed: ${_formatDate(quest.completedAt!)}',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  // Rewards
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          'COMPLETED',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            '₱',
                                            style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            quest.calculatedGold
                                                .toStringAsFixed(0),
                                            style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.show_chart,
                                            size: 12,
                                            color: Colors.green,
                                          ),
                                          Text(
                                            quest.calculatedExp.toStringAsFixed(
                                              0,
                                            ),
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),

                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
