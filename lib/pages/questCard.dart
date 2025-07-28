import 'package:flutter/material.dart';
import 'package:my_app/pages/Quests.dart';
import 'package:my_app/services/user_service.dart';
import 'package:my_app/services/quest_service.dart';
import 'package:my_app/services/lazy_loading_service.dart';

class ItemCard extends StatelessWidget {
  final Quests quests;
  final VoidCallback? onTap;
  final VoidCallback? onStatusChange;
  final VoidCallback? onDelete;
  final Map<String, int>? inventory; // Add inventory parameter
  final VoidCallback? onInventoryUpdate; // Add callback for inventory updates
  final VoidCallback? onQuestUpdate; // Add callback for quest updates

  const ItemCard({
    super.key,
    required this.quests,
    this.onTap,
    this.onStatusChange,
    this.onDelete,
    this.inventory,
    this.onInventoryUpdate,
    this.onQuestUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: const Color.fromARGB(255, 53, 51, 51),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header with category icon and daily badge
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  // Category icon
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: quests.categoryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      quests.categoryIcon,
                      color: quests.categoryColor,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  // Title and description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                quests.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Delete button for incomplete quests
                            if ((quests.status == QuestStatus.pending || 
                                 quests.status == QuestStatus.inProgress) && 
                                onDelete != null)
                              GestureDetector(
                                onTap: onDelete,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                ),
                              ),
                            if ((quests.status == QuestStatus.pending || 
                                 quests.status == QuestStatus.inProgress) && 
                                onDelete != null)
                              const SizedBox(width: 6),
                            // Daily badge
                            if (quests.isDaily)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.repeat,
                                      size: 12,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Daily',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          quests.description,
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Difficulty and category badges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Difficulty badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: quests.difficultyColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      quests.difficultyText,
                      style: TextStyle(
                        color: quests.difficultyColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  // Category badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: quests.categoryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      quests.categoryText,
                      style: TextStyle(
                        color: quests.categoryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  // Status badge
                  GestureDetector(
                    onTap: onStatusChange,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: quests.statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: quests.statusColor, width: 1),
                      ),
                      child: Text(
                        quests.statusText,
                        style: TextStyle(
                          color: quests.statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12),

            // Deadline and streak info
            if (quests.deadline != null || quests.isDaily)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    if (quests.deadline != null) ...[
                      Icon(
                        quests.isOverdue ? Icons.warning : Icons.schedule,
                        size: 16,
                        color: quests.isOverdue ? Colors.red : Colors.orange,
                      ),
                      SizedBox(width: 4),
                      Text(
                        quests.isOverdue
                            ? 'Overdue by ${quests.daysRemaining!.abs()} days'
                            : '${quests.daysRemaining} days left',
                        style: TextStyle(
                          color: quests.isOverdue ? Colors.red : Colors.orange,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    if (quests.isDaily && quests.streak > 0) ...[
                      Spacer(),
                      Icon(
                        Icons.local_fire_department,
                        size: 16,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${quests.streak} day streak',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

            SizedBox(height: 12),

            // Rewards section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  // Gold reward
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
                        SizedBox(width: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gold',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              quests.calculatedGold.toStringAsFixed(0),
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // XP reward
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.show_chart, size: 18, color: Colors.green),
                        SizedBox(width: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'XP',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              quests.calculatedExp.toStringAsFixed(0),
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Action button
                  if (quests.status == QuestStatus.pending ||
                      quests.status == QuestStatus.inProgress)
                    ElevatedButton(
                      onPressed: onStatusChange,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        quests.status == QuestStatus.pending
                            ? 'Start'
                            : 'Complete',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),

            // Quick use booster buttons
            if (inventory != null && 
                (inventory!['xp_booster'] != null && inventory!['xp_booster']! > 0 ||
                 inventory!['gold_booster'] != null && inventory!['gold_booster']! > 0)) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (inventory!['xp_booster'] != null && inventory!['xp_booster']! > 0)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _useBooster(context, 'xp_booster'),
                          icon: const Icon(Icons.trending_up, size: 16),
                          label: const Text('XP Boost', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            minimumSize: const Size(0, 32),
                          ),
                        ),
                      ),
                    if (inventory!['xp_booster'] != null && inventory!['xp_booster']! > 0 &&
                        inventory!['gold_booster'] != null && inventory!['gold_booster']! > 0)
                      const SizedBox(width: 8),
                    if (inventory!['gold_booster'] != null && inventory!['gold_booster']! > 0)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _useBooster(context, 'gold_booster'),
                          icon: const Icon(Icons.account_balance, size: 16),
                          label: const Text('Gold Boost', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            minimumSize: const Size(0, 32),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],

            // Quest extension button
            if (inventory != null && 
                inventory!['quest_extension'] != null && 
                inventory!['quest_extension']! > 0 &&
                (quests.status == QuestStatus.pending || quests.status == QuestStatus.inProgress)) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _useQuestExtension(context),
                    icon: const Icon(Icons.schedule, size: 16),
                    label: Text(
                      quests.deadline != null 
                          ? 'Extend Deadline (${inventory!['quest_extension']} available)'
                          : 'Add Deadline (${inventory!['quest_extension']} available)',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      minimumSize: const Size(0, 32),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _useBooster(BuildContext context, String boosterType) async {
    try {
      bool success = false;
      
      if (boosterType == 'xp_booster') {
        success = await UserService.activateXPBooster();
        if (success) {
          // Clear relevant cache
          LazyLoadingService.clearCache('user_inventory');
          LazyLoadingService.clearCache('shop_inventory');
          LazyLoadingService.clearCache('character_inventory');
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('XP Booster activated! Next 3 quests will give 2x XP!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          // Refresh inventory display
          onInventoryUpdate?.call();
          
          // Refresh quest list
          onQuestUpdate?.call();
        }
      } else if (boosterType == 'gold_booster') {
        success = await UserService.activateGoldBooster();
        if (success) {
          // Clear relevant cache
          LazyLoadingService.clearCache('user_inventory');
          LazyLoadingService.clearCache('shop_inventory');
          LazyLoadingService.clearCache('character_inventory');
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gold Booster activated! Next 5 quests will give 1.5x Gold!'),
              backgroundColor: Colors.amber,
              duration: Duration(seconds: 3),
            ),
          );
          // Refresh inventory display
          onInventoryUpdate?.call();
        }
      }
      
      if (!success) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to activate $boosterType booster!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error activating booster: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _useQuestExtension(BuildContext context) async {
    try {
      final success = await UserService.useQuestExtension();
      if (success) {
        // Update the quest deadline
        final newDeadline = quests.deadline != null 
            ? quests.deadline!.add(Duration(days: 1))  // Extend existing deadline
            : DateTime.now().add(Duration(days: 1));  // Add new deadline
        
        final updatedQuest = Quests(
          title: quests.title,
          description: quests.description,
          status: quests.status,
          gold: quests.gold,
          exp: quests.exp,
          difficulty: quests.difficulty,
          category: quests.category,
          deadline: newDeadline,
          isDaily: quests.isDaily,
          createdAt: quests.createdAt,
          completedAt: quests.completedAt,
          streak: quests.streak,
          notes: quests.notes,
          finalExpEarned: quests.finalExpEarned,
        );

        // Save the updated quest
        await QuestService.updateQuest(updatedQuest);

        // Clear relevant cache
        LazyLoadingService.clearCache('user_inventory');
        LazyLoadingService.clearCache('shop_inventory');
        LazyLoadingService.clearCache('character_inventory');
        LazyLoadingService.clearCache('all_quests');

        // Refresh inventory display
        onInventoryUpdate?.call();

        final action = quests.deadline != null ? 'extended by 24 hours' : 'deadline added (24 hours)';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Quest $action!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No quest extensions available!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error using quest extension: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
