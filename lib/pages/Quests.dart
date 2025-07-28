import 'package:flutter/material.dart';

enum QuestDifficulty { easy, medium, hard }

enum QuestCategory {
  health,
  learning,
  productivity,
  fitness,
  mindfulness,
  social,
  creative,
  financial,
}

enum QuestStatus { pending, inProgress, completed, failed }

class Quests {
  String title;
  String description;
  QuestStatus status;
  double gold;
  double exp;
  QuestDifficulty difficulty;
  QuestCategory category;
  DateTime? deadline;
  bool isDaily;
  DateTime? createdAt;
  DateTime? completedAt;
  int streak; // For daily quests
  String? notes;
  double? finalExpEarned; // Store the final XP earned after all multipliers

  Quests({
    required this.title,
    required this.description,
    required this.status,
    required this.gold,
    required this.exp,
    required this.difficulty,
    required this.category,
    this.deadline,
    this.isDaily = false,
    this.createdAt,
    this.completedAt,
    this.streak = 0,
    this.notes,
    this.finalExpEarned,
  });

  // Calculate XP based on difficulty and streak
  double get calculatedExp {
    double baseExp = exp;

    // Difficulty multiplier
    switch (difficulty) {
      case QuestDifficulty.easy:
        baseExp *= 1.0;
        break;
      case QuestDifficulty.medium:
        baseExp *= 1.5;
        break;
      case QuestDifficulty.hard:
        baseExp *= 2.0;
        break;
    }

    // Streak bonus for daily quests
    if (isDaily && streak > 0) {
      baseExp *= (1 + (streak * 0.1)); // 10% bonus per streak
    }

    return baseExp;
  }

  // Calculate gold based on difficulty
  double get calculatedGold {
    double baseGold = gold;

    switch (difficulty) {
      case QuestDifficulty.easy:
        baseGold *= 1.0;
        break;
      case QuestDifficulty.medium:
        baseGold *= 1.3;
        break;
      case QuestDifficulty.hard:
        baseGold *= 1.8;
        break;
    }

    return baseGold;
  }

  // Check if quest is overdue
  bool get isOverdue {
    if (deadline == null) return false;
    return DateTime.now().isAfter(deadline!) && status != QuestStatus.completed;
  }

  // Get days remaining
  int? get daysRemaining {
    if (deadline == null) return null;
    final now = DateTime.now();
    final remaining = deadline!.difference(now).inDays;
    return remaining < 0 ? 0 : remaining;
  }

  // Get category color
  Color get categoryColor {
    switch (category) {
      case QuestCategory.health:
        return Colors.red;
      case QuestCategory.learning:
        return Colors.blue;
      case QuestCategory.productivity:
        return Color.fromARGB(255, 172, 245, 0);
      case QuestCategory.fitness:
        return Colors.orange;
      case QuestCategory.mindfulness:
        return Colors.purple;
      case QuestCategory.social:
        return Colors.pink;
      case QuestCategory.creative:
        return Colors.indigo;
      case QuestCategory.financial:
        return Colors.amber;
    }
  }

  // Get difficulty color
  Color get difficultyColor {
    switch (difficulty) {
      case QuestDifficulty.easy:
        return Color.fromARGB(255, 172, 245, 0);
      case QuestDifficulty.medium:
        return Colors.orange;
      case QuestDifficulty.hard:
        return Colors.red;
    }
  }

  // Get status color
  Color get statusColor {
    switch (status) {
      case QuestStatus.pending:
        return Colors.grey;
      case QuestStatus.inProgress:
        return Colors.blue;
      case QuestStatus.completed:
        return Color.fromARGB(255, 172, 245, 0);
      case QuestStatus.failed:
        return Colors.red;
    }
  }

  // Get category icon
  IconData get categoryIcon {
    switch (category) {
      case QuestCategory.health:
        return Icons.favorite;
      case QuestCategory.learning:
        return Icons.school;
      case QuestCategory.productivity:
        return Icons.work;
      case QuestCategory.fitness:
        return Icons.fitness_center;
      case QuestCategory.mindfulness:
        return Icons.self_improvement;
      case QuestCategory.social:
        return Icons.people;
      case QuestCategory.creative:
        return Icons.brush;
      case QuestCategory.financial:
        return Icons.account_balance; // Changed from attach_money to account_balance
    }
  }

  // Get difficulty text
  String get difficultyText {
    switch (difficulty) {
      case QuestDifficulty.easy:
        return 'Easy';
      case QuestDifficulty.medium:
        return 'Medium';
      case QuestDifficulty.hard:
        return 'Hard';
    }
  }

  // Get category text
  String get categoryText {
    switch (category) {
      case QuestCategory.health:
        return 'Health';
      case QuestCategory.learning:
        return 'Learning';
      case QuestCategory.productivity:
        return 'Productivity';
      case QuestCategory.fitness:
        return 'Fitness';
      case QuestCategory.mindfulness:
        return 'Mindfulness';
      case QuestCategory.social:
        return 'Social';
      case QuestCategory.creative:
        return 'Creative';
      case QuestCategory.financial:
        return 'Financial';
    }
  }

  // Get status text
  String get statusText {
    switch (status) {
      case QuestStatus.pending:
        return 'Pending';
      case QuestStatus.inProgress:
        return 'In Progress';
      case QuestStatus.completed:
        return 'Completed';
      case QuestStatus.failed:
        return 'Failed';
    }
  }
}
