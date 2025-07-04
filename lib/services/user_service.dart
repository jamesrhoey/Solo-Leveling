import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/models/ranking_system.dart';
import 'package:my_app/models/avatar.dart';
import 'package:my_app/models/shop_items.dart';

class UserService {
  static const String _userDataKey = 'user_data';
  static const String _inventoryKey = 'user_inventory';
  static const String _activeBoostsKey = 'active_boosts';

  // User data structure
  static Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString(_userDataKey);

    if (userDataJson != null) {
      return jsonDecode(userDataJson);
    }

    // Default user data
    return {
      'gold': 1000, // Starting gold
      'currentAvatar': 'default',
      'unlockedAvatars': ['default'],
      'xpBoosterActive': false,
      'xpBoosterQuestsLeft': 0,
      'goldBoosterActive': false,
      'goldBoosterQuestsLeft': 0,
      'streakProtectionActive': false,
      'streakProtectionExpiry': null,
    };
  }

  // Save user data
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, jsonEncode(userData));
  }

  // Get user's gold
  static Future<int> getUserGold() async {
    final userData = await getUserData();
    return userData['gold'] ?? 0;
  }

  // Add gold to user
  static Future<void> addGold(int amount) async {
    final userData = await getUserData();
    userData['gold'] = (userData['gold'] ?? 0) + amount;
    await saveUserData(userData);
  }

  // Deduct gold from user
  static Future<bool> deductGold(int amount) async {
    final userData = await getUserData();
    final currentGold = userData['gold'] ?? 0;

    if (currentGold >= amount) {
      userData['gold'] = currentGold - amount;
      await saveUserData(userData);
      return true;
    }
    return false;
  }

  // Get current avatar
  static Future<String> getCurrentAvatar() async {
    final userData = await getUserData();
    return userData['currentAvatar'] ?? 'default';
  }

  // Set current avatar
  static Future<void> setCurrentAvatar(String avatarId) async {
    final userData = await getUserData();
    userData['currentAvatar'] = avatarId;
    await saveUserData(userData);
  }

  // Get unlocked avatars
  static Future<List<String>> getUnlockedAvatars() async {
    final userData = await getUserData();
    final unlocked = userData['unlockedAvatars'] as List<dynamic>?;
    return unlocked?.cast<String>() ?? ['default'];
  }

  // Unlock avatar
  static Future<void> unlockAvatar(String avatarId) async {
    final userData = await getUserData();
    final unlocked = List<String>.from(
      userData['unlockedAvatars'] ?? ['default'],
    );

    if (!unlocked.contains(avatarId)) {
      unlocked.add(avatarId);
      userData['unlockedAvatars'] = unlocked;
      await saveUserData(userData);
    }
  }

  // Purchase avatar
  static Future<bool> purchaseAvatar(String avatarId) async {
    final avatars = AvatarCollection.getAllAvatars();
    final avatar = avatars.firstWhere((a) => a.id == avatarId);

    final success = await deductGold(avatar.cost);
    if (success) {
      await unlockAvatar(avatarId);
      return true;
    }
    return false;
  }

  // Get user inventory
  static Future<Map<String, int>> getUserInventory() async {
    final prefs = await SharedPreferences.getInstance();
    final inventoryJson = prefs.getString(_inventoryKey);

    if (inventoryJson != null) {
      final Map<String, dynamic> inventory = jsonDecode(inventoryJson);
      return inventory.map((key, value) => MapEntry(key, value as int));
    }

    return {};
  }

  // Add item to inventory
  static Future<void> addItemToInventory(String itemId, int quantity) async {
    final inventory = await getUserInventory();
    inventory[itemId] = (inventory[itemId] ?? 0) + quantity;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_inventoryKey, jsonEncode(inventory));
  }

  // Remove item from inventory
  static Future<bool> removeItemFromInventory(
    String itemId,
    int quantity,
  ) async {
    final inventory = await getUserInventory();
    final currentQuantity = inventory[itemId] ?? 0;

    if (currentQuantity >= quantity) {
      inventory[itemId] = currentQuantity - quantity;
      if (inventory[itemId] == 0) {
        inventory.remove(itemId);
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_inventoryKey, jsonEncode(inventory));
      return true;
    }
    return false;
  }

  // Purchase shop item
  static Future<bool> purchaseShopItem(String itemId) async {
    final item = ShopItems.getItemById(itemId);
    if (item == null) return false;

    final success = await deductGold(item.cost);
    if (success) {
      await addItemToInventory(itemId, item.quantity);
      return true;
    }
    return false;
  }

  // Use streak protector
  static Future<bool> useStreakProtector() async {
    final success = await removeItemFromInventory('streak_protector', 1);
    if (success) {
      final userData = await getUserData();
      userData['streakProtectionActive'] = true;
      userData['streakProtectionExpiry'] = DateTime.now()
          .add(Duration(days: 1))
          .toIso8601String();
      await saveUserData(userData);
      return true;
    }
    return false;
  }

  // Check if streak protection is active
  static Future<bool> isStreakProtectionActive() async {
    final userData = await getUserData();
    final isActive = userData['streakProtectionActive'] ?? false;

    if (isActive) {
      final expiryStr = userData['streakProtectionExpiry'];
      if (expiryStr != null) {
        final expiry = DateTime.parse(expiryStr);
        if (DateTime.now().isAfter(expiry)) {
          // Expired, remove protection
          userData['streakProtectionActive'] = false;
          userData['streakProtectionExpiry'] = null;
          await saveUserData(userData);
          return false;
        }
      }
    }

    return isActive;
  }

  // Use quest extension
  static Future<bool> useQuestExtension() async {
    return await removeItemFromInventory('quest_extension', 1);
  }

  // Activate XP booster
  static Future<bool> activateXPBooster() async {
    final success = await removeItemFromInventory('xp_booster', 1);
    if (success) {
      final userData = await getUserData();
      userData['xpBoosterActive'] = true;
      userData['xpBoosterQuestsLeft'] = 3;
      await saveUserData(userData);
      return true;
    }
    return false;
  }

  // Activate gold booster
  static Future<bool> activateGoldBooster() async {
    final success = await removeItemFromInventory('gold_booster', 1);
    if (success) {
      final userData = await getUserData();
      userData['goldBoosterActive'] = true;
      userData['goldBoosterQuestsLeft'] = 5;
      await saveUserData(userData);
      return true;
    }
    return false;
  }

  // Check if XP booster is active
  static Future<bool> isXPBoosterActive() async {
    final userData = await getUserData();
    return userData['xpBoosterActive'] ?? false;
  }

  // Check if gold booster is active
  static Future<bool> isGoldBoosterActive() async {
    final userData = await getUserData();
    return userData['goldBoosterActive'] ?? false;
  }

  // Consume XP booster (called when quest is completed)
  static Future<void> consumeXPBooster() async {
    final userData = await getUserData();
    if (userData['xpBoosterActive'] == true) {
      int questsLeft = userData['xpBoosterQuestsLeft'] ?? 0;
      questsLeft--;

      if (questsLeft <= 0) {
        userData['xpBoosterActive'] = false;
        userData['xpBoosterQuestsLeft'] = 0;
      } else {
        userData['xpBoosterQuestsLeft'] = questsLeft;
      }

      await saveUserData(userData);
    }
  }

  // Consume gold booster (called when quest is completed)
  static Future<void> consumeGoldBooster() async {
    final userData = await getUserData();
    if (userData['goldBoosterActive'] == true) {
      int questsLeft = userData['goldBoosterQuestsLeft'] ?? 0;
      questsLeft--;

      if (questsLeft <= 0) {
        userData['goldBoosterActive'] = false;
        userData['goldBoosterQuestsLeft'] = 0;
      } else {
        userData['goldBoosterQuestsLeft'] = questsLeft;
      }

      await saveUserData(userData);
    }
  }

  // Get rank information
  static Future<Map<String, dynamic>> getRankInfo(double totalXP) async {
    final currentRank = RankingSystem.getRankFromXP(totalXP);
    final rankRewards = RankingSystem.getRankRewards(currentRank);
    final xpRequired = RankingSystem.getXPRequiredForNextRank(totalXP);
    final progress = RankingSystem.getProgressToNextRank(totalXP);

    return {
      'currentRank': currentRank,
      'rankRewards': rankRewards,
      'xpRequired': xpRequired,
      'progress': progress,
    };
  }
}
