import 'package:flutter/material.dart';
import 'package:my_app/services/quest_service.dart';
import 'package:my_app/services/user_service.dart';
import 'package:my_app/models/ranking_system.dart';
import 'package:my_app/models/avatar.dart';
import 'package:my_app/models/shop_items.dart';

class Character extends StatefulWidget {
  const Character({super.key});

  @override
  State<Character> createState() => _CharacterState();
}

class _CharacterState extends State<Character> {
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Load quest statistics
      final stats = await QuestService.getQuestStats();

      // Load user data
      final gold = await UserService.getUserGold();
      final currentAvatarId = await UserService.getCurrentAvatar();
      final userInventory = await UserService.getUserInventory();

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

        isLoading = false;
      });
    } catch (e) {
      print('Error loading character data: $e');
      setState(() {
        isLoading = false;
      });
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
        iconTheme: IconThemeData(color: Color.fromARGB(255, 172, 245, 0)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
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
            : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Character Header
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            currentAvatar.color.withOpacity(0.2),
                            currentAvatar.color.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: currentAvatar.color.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          ClipOval(
                            child: Image.asset(
                              currentAvatar.imagePath,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.person,
                                    color: currentAvatar.color,
                                    size: 48,
                                  ),
                            ),
                          ),
                          SizedBox(width: 16),

                          // Character Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentAvatar.name,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  currentAvatar.description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: currentAvatar.rarityColor
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    currentAvatar.rarityText,
                                    style: TextStyle(
                                      color: currentAvatar.rarityColor,
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
                    SizedBox(height: 24),

                    // Rank Information
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 53, 51, 51),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: rankRewards.rankColor.withOpacity(0.3),
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
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Rank Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),

                          // Current Rank
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Current Rank',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      rankRewards.title,
                                      style: TextStyle(
                                        fontSize: 20,
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
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '+${rankRewards.goldBonus}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 16),

                          // XP Multiplier
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'XP Multiplier',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${(rankRewards.xpMultiplier * 100).toInt()}%',
                                      style: TextStyle(
                                        fontSize: 20,
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
                                      'XP to Next Rank',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      xpRequired.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: rankRewards.rankColor,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          SizedBox(height: 16),

                          // Progress Bar
                          if (xpRequired > 0) ...[
                            Text(
                              'Progress to Next Rank',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),
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
                    SizedBox(height: 16),

                    // Statistics
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 53, 51, 51),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.analytics,
                                color: Color.fromARGB(255, 172, 245, 0),
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Statistics',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),

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
                              SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  'Gold',
                                  userGold.toString(),
                                  Icons.attach_money,
                                  Colors.amber,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
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
                              SizedBox(width: 12),
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
                          SizedBox(height: 12),
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
                              SizedBox(width: 12),
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
                    SizedBox(height: 16),

                    // Inventory
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 53, 51, 51),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.inventory,
                                color: Color.fromARGB(255, 172, 245, 0),
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Inventory',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),

                          if (inventory.isEmpty)
                            Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.inventory_2,
                                    color: Colors.grey,
                                    size: 48,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'No items in inventory',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
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
                                margin: EdgeInsets.only(bottom: 8),
                                padding: EdgeInsets.all(12),
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
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            item.description,
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: item.color.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'x${entry.value}',
                                        style: TextStyle(
                                          color: item.color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
