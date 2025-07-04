import 'package:flutter/material.dart';

enum ItemType { streakProtector, questExtension, xpBooster, goldBooster }

class ShopItem {
  final String id;
  final String name;
  final String description;
  final int cost;
  final ItemType type;
  final IconData icon;
  final Color color;
  final int quantity; // For consumable items
  final bool isConsumable;

  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.type,
    required this.icon,
    required this.color,
    this.quantity = 1,
    this.isConsumable = true,
  });
}

class ShopItems {
  static List<ShopItem> getAllItems() {
    return [
      // Streak Protector
      const ShopItem(
        id: 'streak_protector',
        name: 'Streak Protector',
        description: 'Prevents losing your daily quest streak for 24 hours',
        cost: 300,
        type: ItemType.streakProtector,
        icon: Icons.shield,
        color: Colors.blue,
        quantity: 1,
      ),

      // Quest Extension
      const ShopItem(
        id: 'quest_extension',
        name: 'Quest Extension',
        description: 'Extend any quest deadline by 24 hours',
        cost: 200,
        type: ItemType.questExtension,
        icon: Icons.schedule,
        color: Colors.orange,
        quantity: 1,
      ),

      // XP Booster
      const ShopItem(
        id: 'xp_booster',
        name: 'XP Booster',
        description: 'Get 2x XP for your next 3 quests',
        cost: 500,
        type: ItemType.xpBooster,
        icon: Icons.trending_up,
        color: Colors.green,
        quantity: 3,
      ),

      // Gold Booster
      const ShopItem(
        id: 'gold_booster',
        name: 'Gold Booster',
        description: 'Get 1.5x gold for your next 5 quests',
        cost: 800,
        type: ItemType.goldBooster,
        icon: Icons.attach_money,
        color: Colors.amber,
        quantity: 5,
      ),
    ];
  }

  static ShopItem? getItemById(String id) {
    try {
      return getAllItems().firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}
