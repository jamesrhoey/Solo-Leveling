import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/pages/Quests.dart';
import 'package:my_app/services/user_service.dart';

class QuestService {
  static const String _questsKey = 'quests';
  static const String _completedQuestsKey = 'completed_quests';

  // Save a quest
  static Future<void> saveQuest(Quests quest) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> quests = prefs.getStringList(_questsKey) ?? [];

    // Convert quest to JSON
    final questJson = _questToJson(quest);
    quests.add(questJson);

    await prefs.setStringList(_questsKey, quests);
  }

  // Get all quests
  static Future<List<Quests>> getAllQuests() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> questsJson = prefs.getStringList(_questsKey) ?? [];

    return questsJson.map((json) => _questFromJson(json)).toList();
  }

  // Get completed quests (sorted by completion date, most recent first)
  static Future<List<Quests>> getCompletedQuests({int limit = 5}) async {
    final allQuests = await getAllQuests();
    final completedQuests = allQuests
        .where(
          (quest) =>
              quest.status == QuestStatus.completed &&
              quest.completedAt != null,
        )
        .toList();

    // Sort by completion date (most recent first)
    completedQuests.sort((a, b) => b.completedAt!.compareTo(a.completedAt!));

    // Return limited number of quests
    return completedQuests.take(limit).toList();
  }

  // Update quest
  static Future<void> updateQuest(Quests updatedQuest) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> questsJson = prefs.getStringList(_questsKey) ?? [];

    for (int i = 0; i < questsJson.length; i++) {
      final quest = _questFromJson(questsJson[i]);
      if (quest.title == updatedQuest.title) {
        questsJson[i] = _questToJson(updatedQuest);
        break;
      }
    }

    await prefs.setStringList(_questsKey, questsJson);
  }

  // Update quest status
  static Future<void> updateQuestStatus(
    String questTitle,
    QuestStatus newStatus,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> questsJson = prefs.getStringList(_questsKey) ?? [];

    for (int i = 0; i < questsJson.length; i++) {
      final quest = _questFromJson(questsJson[i]);
      if (quest.title == questTitle) {
        quest.status = newStatus;
        if (newStatus == QuestStatus.completed) {
          quest.completedAt = DateTime.now();
          if (quest.isDaily) {
            quest.streak++;
          }

          // Apply boosters and add rewards to user
          final calculatedExp = quest.calculatedExp;
          final calculatedGold = quest.calculatedGold;

          // Check for active boosters
          final isXPBoosterActive = await UserService.isXPBoosterActive();
          final isGoldBoosterActive = await UserService.isGoldBoosterActive();

          double finalExp = calculatedExp;
          double finalGold = calculatedGold;

          if (isXPBoosterActive) {
            finalExp *= 2.0; // 2x XP booster
            await UserService.consumeXPBooster();
          }

          if (isGoldBoosterActive) {
            finalGold *= 1.5; // 1.5x Gold booster
            await UserService.consumeGoldBooster();
          }

          // Add rewards to user
          await UserService.addGold(finalGold.toInt());
        }
        questsJson[i] = _questToJson(quest);
        break;
      }
    }

    await prefs.setStringList(_questsKey, questsJson);
  }

  // Get quest statistics
  static Future<Map<String, dynamic>> getQuestStats() async {
    final allQuests = await getAllQuests();

    int completed = allQuests
        .where((q) => q.status == QuestStatus.completed)
        .length;
    int pending = allQuests
        .where((q) => q.status == QuestStatus.pending)
        .length;
    int inProgress = allQuests
        .where((q) => q.status == QuestStatus.inProgress)
        .length;

    double totalXP = allQuests
        .where((q) => q.status == QuestStatus.completed)
        .fold(0.0, (sum, q) => sum + q.calculatedExp);

    double totalGold = allQuests
        .where((q) => q.status == QuestStatus.completed)
        .fold(0.0, (sum, q) => sum + q.calculatedGold);

    // Calculate level (simple formula: every 1000 XP = 1 level)
    int level = (totalXP / 1000).floor() + 1;

    // Calculate daily streak (consecutive days with completed daily quests)
    int dailyStreak = _calculateDailyStreak(allQuests);

    return {
      'totalXP': totalXP,
      'totalGold': totalGold,
      'level': level,
      'completedQuests': completed,
      'pendingQuests': pending,
      'inProgressQuests': inProgress,
      'dailyStreak': dailyStreak,
    };
  }

  // Calculate daily streak
  static int _calculateDailyStreak(List<Quests> quests) {
    final completedDailyQuests = quests
        .where(
          (q) =>
              q.isDaily &&
              q.status == QuestStatus.completed &&
              q.completedAt != null,
        )
        .toList();

    if (completedDailyQuests.isEmpty) return 0;

    // Sort by completion date
    completedDailyQuests.sort(
      (a, b) => b.completedAt!.compareTo(a.completedAt!),
    );

    int streak = 0;
    DateTime? currentDate = DateTime.now();

    for (final quest in completedDailyQuests) {
      final questDate = DateTime(
        quest.completedAt!.year,
        quest.completedAt!.month,
        quest.completedAt!.day,
      );
      final checkDate = DateTime(
        currentDate!.year,
        currentDate.month,
        currentDate.day,
      );

      if (questDate.isAtSameMomentAs(checkDate)) {
        streak++;
        currentDate = currentDate.subtract(Duration(days: 1));
      } else if (questDate.isBefore(checkDate)) {
        break;
      }
    }

    return streak;
  }

  // Convert quest to JSON
  static String _questToJson(Quests quest) {
    return jsonEncode({
      'title': quest.title,
      'description': quest.description,
      'status': quest.status.index,
      'gold': quest.gold,
      'exp': quest.exp,
      'difficulty': quest.difficulty.index,
      'category': quest.category.index,
      'deadline': quest.deadline?.toIso8601String(),
      'isDaily': quest.isDaily,
      'createdAt': quest.createdAt?.toIso8601String(),
      'completedAt': quest.completedAt?.toIso8601String(),
      'streak': quest.streak,
      'notes': quest.notes,
    });
  }

  // Convert JSON to quest
  static Quests _questFromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    return Quests(
      title: json['title'],
      description: json['description'],
      status: QuestStatus.values[json['status']],
      gold: json['gold'].toDouble(),
      exp: json['exp'].toDouble(),
      difficulty: QuestDifficulty.values[json['difficulty']],
      category: QuestCategory.values[json['category']],
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : null,
      isDaily: json['isDaily'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      streak: json['streak'] ?? 0,
      notes: json['notes'],
    );
  }

  // Initialize with sample data if no quests exist
  static Future<void> initializeSampleData() async {
    final prefs = await SharedPreferences.getInstance();
    final existingQuests = prefs.getStringList(_questsKey);

    if (existingQuests == null || existingQuests.isEmpty) {
      final sampleQuests = [
        Quests(
          title: 'Morning Exercise',
          description: 'Complete 30 minutes of cardio',
          status: QuestStatus.completed,
          gold: 500,
          exp: 200,
          difficulty: QuestDifficulty.easy,
          category: QuestCategory.fitness,
          isDaily: true,
          completedAt: DateTime.now().subtract(Duration(hours: 2)),
          streak: 3,
        ),
        Quests(
          title: 'Read 30 Minutes',
          description: 'Read educational content',
          status: QuestStatus.completed,
          gold: 400,
          exp: 180,
          difficulty: QuestDifficulty.medium,
          category: QuestCategory.learning,
          isDaily: true,
          completedAt: DateTime.now().subtract(Duration(hours: 4)),
          streak: 1,
        ),
        Quests(
          title: 'Project Proposal',
          description: 'Finish quarterly proposal',
          status: QuestStatus.completed,
          gold: 2000,
          exp: 800,
          difficulty: QuestDifficulty.hard,
          category: QuestCategory.productivity,
          completedAt: DateTime.now().subtract(Duration(days: 1)),
          createdAt: DateTime.now().subtract(Duration(days: 2)),
        ),
        Quests(
          title: 'Meditation Session',
          description: 'Practice mindfulness meditation for 20 minutes',
          status: QuestStatus.completed,
          gold: 200,
          exp: 100,
          difficulty: QuestDifficulty.easy,
          category: QuestCategory.mindfulness,
          completedAt: DateTime.now().subtract(Duration(days: 2)),
          createdAt: DateTime.now().subtract(Duration(days: 3)),
        ),
        Quests(
          title: 'Drink 8 Glasses of Water',
          description: 'Stay hydrated throughout the day',
          status: QuestStatus.completed,
          gold: 300,
          exp: 150,
          difficulty: QuestDifficulty.easy,
          category: QuestCategory.health,
          isDaily: true,
          completedAt: DateTime.now().subtract(Duration(days: 1)),
          streak: 5,
        ),
      ];

      final questsJson = sampleQuests
          .map((quest) => _questToJson(quest))
          .toList();
      await prefs.setStringList(_questsKey, questsJson);
    }
  }
}
