import 'package:flutter/material.dart';

enum AvatarRarity { common, rare, epic, legendary }

class Avatar {
  final String id;
  final String name;
  final String description;
  final int cost;
  final AvatarRarity rarity;
  final IconData icon;
  final Color color;
  final bool isUnlocked;

  const Avatar({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.rarity,
    required this.icon,
    required this.color,
    this.isUnlocked = false,
  });

  Color get rarityColor {
    switch (rarity) {
      case AvatarRarity.common:
        return Colors.grey;
      case AvatarRarity.rare:
        return Colors.blue;
      case AvatarRarity.epic:
        return Colors.purple;
      case AvatarRarity.legendary:
        return Colors.orange;
    }
  }

  String get rarityText {
    switch (rarity) {
      case AvatarRarity.common:
        return "Common";
      case AvatarRarity.rare:
        return "Rare";
      case AvatarRarity.epic:
        return "Epic";
      case AvatarRarity.legendary:
        return "Legendary";
    }
  }
}

class AvatarCollection {
  static List<Avatar> getAllAvatars() {
    return [
      // Common Avatars (300 gold)
      const Avatar(
        id: 'warrior',
        name: 'Warrior',
        description: 'A brave warrior ready for any quest',
        cost: 300,
        rarity: AvatarRarity.common,
        icon: Icons.person,
        color: Colors.brown,
      ),
      const Avatar(
        id: 'mage',
        name: 'Mage',
        description: 'A wise mage with magical powers',
        cost: 300,
        rarity: AvatarRarity.common,
        icon: Icons.auto_awesome,
        color: Colors.purple,
      ),
      const Avatar(
        id: 'archer',
        name: 'Archer',
        description: 'A skilled archer with precise aim',
        cost: 300,
        rarity: AvatarRarity.common,
        icon: Icons.visibility,
        color: Colors.green,
      ),
      const Avatar(
        id: 'knight',
        name: 'Knight',
        description: 'A noble knight in shining armor',
        cost: 300,
        rarity: AvatarRarity.common,
        icon: Icons.security,
        color: Colors.grey,
      ),

      // Rare Avatars (500 gold)
      const Avatar(
        id: 'dragon_slayer',
        name: 'Dragon Slayer',
        description: 'A legendary hero who defeated dragons',
        cost: 500,
        rarity: AvatarRarity.rare,
        icon: Icons.local_fire_department,
        color: Colors.red,
      ),
      const Avatar(
        id: 'ninja',
        name: 'Ninja',
        description: 'A stealthy ninja master',
        cost: 500,
        rarity: AvatarRarity.rare,
        icon: Icons.visibility_off,
        color: Colors.black,
      ),
      const Avatar(
        id: 'wizard',
        name: 'Wizard',
        description: 'A powerful wizard with ancient knowledge',
        cost: 500,
        rarity: AvatarRarity.rare,
        icon: Icons.psychology,
        color: Colors.indigo,
      ),
      const Avatar(
        id: 'paladin',
        name: 'Paladin',
        description: 'A holy warrior with divine powers',
        cost: 500,
        rarity: AvatarRarity.rare,
        icon: Icons.church,
        color: Colors.yellow,
      ),

      // Epic Avatars (750 gold)
      const Avatar(
        id: 'phoenix',
        name: 'Phoenix',
        description: 'A mythical phoenix reborn from ashes',
        cost: 750,
        rarity: AvatarRarity.epic,
        icon: Icons.flutter_dash,
        color: Colors.orange,
      ),
      const Avatar(
        id: 'shadow_assassin',
        name: 'Shadow Assassin',
        description: 'A deadly assassin from the shadows',
        cost: 750,
        rarity: AvatarRarity.epic,
        icon: Icons.dark_mode,
        color: Colors.deepPurple,
      ),
      const Avatar(
        id: 'crystal_mage',
        name: 'Crystal Mage',
        description: 'A mage wielding crystal magic',
        cost: 750,
        rarity: AvatarRarity.epic,
        icon: Icons.diamond,
        color: Colors.cyan,
      ),
      const Avatar(
        id: 'time_master',
        name: 'Time Master',
        description: 'A master who controls time itself',
        cost: 750,
        rarity: AvatarRarity.epic,
        icon: Icons.schedule,
        color: Colors.teal,
      ),

      // Legendary Avatars (1000 gold)
      const Avatar(
        id: 'quest_god',
        name: 'Quest God',
        description: 'The ultimate quest master',
        cost: 1000,
        rarity: AvatarRarity.legendary,
        icon: Icons.auto_awesome,
        color: Colors.amber,
      ),
      const Avatar(
        id: 'eternal_legend',
        name: 'Eternal Legend',
        description: 'A legend that will never fade',
        cost: 1000,
        rarity: AvatarRarity.legendary,
        icon: Icons.star,
        color: Colors.yellow,
      ),
      const Avatar(
        id: 'cosmic_warrior',
        name: 'Cosmic Warrior',
        description: 'A warrior from the cosmos',
        cost: 1000,
        rarity: AvatarRarity.legendary,
        icon: Icons.rocket_launch,
        color: Colors.deepPurple,
      ),
      const Avatar(
        id: 'infinity_master',
        name: 'Infinity Master',
        description: 'Master of infinite possibilities',
        cost: 1000,
        rarity: AvatarRarity.legendary,
        icon: Icons.all_inclusive,
        color: Colors.pink,
      ),
    ];
  }

  static Avatar getDefaultAvatar() {
    return const Avatar(
      id: 'default',
      name: 'Default',
      description: 'Default avatar',
      cost: 0,
      rarity: AvatarRarity.common,
      icon: Icons.person,
      color: Colors.grey,
      isUnlocked: true,
    );
  }
}
