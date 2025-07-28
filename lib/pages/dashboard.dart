import 'package:flutter/material.dart';
import 'package:my_app/pages/Quests.dart';
import 'package:my_app/services/quest_service.dart';
import 'package:my_app/services/user_service.dart';
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
      // Initialize sample data if needed
      await QuestService.initializeSampleData();

      // Load quest statistics
      final stats = await QuestService.getQuestStats();

      // Load recent completed quests
      final recentCompletedQuests = await QuestService.getCompletedQuests(
        limit: 5,
      );

      // Load user data
      final userGold = await UserService.getUserGold();
      final currentAvatarId = await UserService.getCurrentAvatar();

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

        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
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
          // Profile Avatar
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/character');
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
            : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 172, 245, 0).withOpacity(0.1),
                            Color.fromARGB(255, 172, 245, 0).withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Color.fromARGB(
                            255,
                            172,
                            245,
                            0,
                          ).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back, Rowi!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 172, 245, 0),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Level $level • $dailyStreak day streak',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 8),
                          // Rank Display
                          Row(
                            children: [
                              Icon(
                                rankRewards.rankIcon,
                                color: rankRewards.rankColor,
                                size: 20,
                              ),
                              SizedBox(width: 8),
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
                          SizedBox(height: 4),
                          Text(
                            rankRewards.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Stats Cards
                    Row(
                      children: [
                        // XP Card
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.show_chart,
                                  color: Colors.green,
                                  size: 32,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  totalXP.toStringAsFixed(0),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  'Total XP',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        // Gold Card
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.amber.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '₱',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  userGold.toStringAsFixed(0),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                                Text(
                                  'Total Gold',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Rank Progress
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
                                'Rank Progress',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
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
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (xpRequired > 0)
                                Text(
                                  '${xpRequired} XP to next rank',
                                  style: TextStyle(
                                    color: rankRewards.rankColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
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
                      ),
                    ),
                    SizedBox(height: 16),

                    // Quest Progress
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
                                Icons.task,
                                color: Color.fromARGB(255, 172, 245, 0),
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Quest Progress',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      completedQuests.toString(),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 172, 245, 0),
                                      ),
                                    ),
                                    Text(
                                      'Completed',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      pendingQuests.toString(),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    Text(
                                      'Pending',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      dailyStreak.toString(),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Text(
                                      'Day Streak',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

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
