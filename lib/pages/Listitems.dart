import 'package:flutter/material.dart';
import 'package:my_app/pages/Quests.dart';
import 'package:my_app/pages/questCard.dart';
import 'package:my_app/services/quest_service.dart';
import 'package:my_app/services/user_service.dart';
import 'package:my_app/services/lazy_loading_service.dart';

class Listitems extends StatefulWidget {
  const Listitems({super.key});

  @override
  State<Listitems> createState() => _ListitemsState();
}

class _ListitemsState extends State<Listitems> {
  List<Quests> quests = [];
  QuestCategory? selectedCategory;
  QuestDifficulty? selectedDifficulty;
  String searchQuery = '';
  bool isLoading = true;

  // User inventory for items
  Map<String, int> inventory = {};

  @override
  void initState() {
    super.initState();
    _loadQuests();
    _preloadData();
  }

  // Preload data in background
  void _preloadData() {
    LazyLoadingService.preloadData('all_quests', () => QuestService.getAllQuests());
    LazyLoadingService.preloadData('user_inventory', () => UserService.getUserInventory());
  }

  Future<void> _loadQuests() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Check for daily quest streak loss
      await QuestService.checkDailyQuestStreakLoss();
      
      // Load data with lazy loading
      final batchResults = await LazyLoadingService.batchLoadData({
        'all_quests': () => QuestService.getAllQuests(),
        'user_inventory': () => UserService.getUserInventory(),
      });

      final loadedQuests = batchResults['all_quests'] as List<Quests>;
      final userInventory = batchResults['user_inventory'] as Map<String, int>;

      setState(() {
        quests = loadedQuests;
        inventory = userInventory;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading quests: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Refresh data (clear cache and reload)
  Future<void> _refreshQuests() async {
    LazyLoadingService.clearCache('all_quests');
    LazyLoadingService.clearCache('user_inventory');
    await _loadQuests();
  }

  List<Quests> get incompleteQuests {
    return quests.where((quest) {
      // Only show incomplete quests
      if (quest.status == QuestStatus.completed || quest.status == QuestStatus.failed) {
        return false;
      }

      // Category filter
      if (selectedCategory != null && quest.category != selectedCategory) {
        return false;
      }

      // Difficulty filter
      if (selectedDifficulty != null &&
          quest.difficulty != selectedDifficulty) {
        return false;
      }

      // Search query filter
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        return quest.title.toLowerCase().contains(query) ||
            quest.description.toLowerCase().contains(query);
      }

      return true;
    }).toList();
  }

  List<Quests> get completedQuests {
    return quests.where((quest) {
      // Only show completed quests
      if (quest.status != QuestStatus.completed) {
        return false;
      }

      // Category filter
      if (selectedCategory != null && quest.category != selectedCategory) {
        return false;
      }

      // Difficulty filter
      if (selectedDifficulty != null &&
          quest.difficulty != selectedDifficulty) {
        return false;
      }

      // Search query filter
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        return quest.title.toLowerCase().contains(query) ||
            quest.description.toLowerCase().contains(query);
      }

      return true;
    }).toList();
  }

  List<Quests> get filteredQuests {
    return quests.where((quest) {
      // Category filter
      if (selectedCategory != null && quest.category != selectedCategory) {
        return false;
      }

      // Difficulty filter
      if (selectedDifficulty != null &&
          quest.difficulty != selectedDifficulty) {
        return false;
      }

      // Search query filter
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        return quest.title.toLowerCase().contains(query) ||
            quest.description.toLowerCase().contains(query);
      }

      return true;
    }).toList();
  }

  Future<void> _updateQuestStatus(Quests quest) async {
    try {
      QuestStatus newStatus;
      switch (quest.status) {
        case QuestStatus.pending:
          newStatus = QuestStatus.inProgress;
          break;
        case QuestStatus.inProgress:
          newStatus = QuestStatus.completed;
          break;
        case QuestStatus.completed:
        case QuestStatus.failed:
          return;
      }

      await QuestService.updateQuestStatus(quest.title, newStatus);

      // Reload quests to get updated data
      await _refreshQuests();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quest status updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating quest status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteQuest(Quests quest) async {
    // Show confirmation dialog
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 53, 51, 51),
        title: const Text(
          'Delete Quest',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete "${quest.title}"? This action cannot be undone.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        final success = await QuestService.deleteQuest(quest.title);
        if (success) {
          // Reload quests to get updated data
          await _refreshQuests();

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Quest "${quest.title}" deleted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot delete completed or failed quests!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting quest: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showQuestDetails(Quests quest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 53, 51, 51),
        title: Text(
          quest.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(quest.description, style: TextStyle(color: Colors.white70)),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    quest.categoryIcon,
                    color: quest.categoryColor,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    quest.categoryText,
                    style: TextStyle(
                      color: quest.categoryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: quest.difficultyColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      quest.difficultyText,
                      style: TextStyle(
                        color: quest.difficultyColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              if (quest.deadline != null) ...[
                Row(
                  children: [
                    Icon(
                      quest.isOverdue ? Icons.warning : Icons.schedule,
                      color: quest.isOverdue ? Colors.red : Colors.orange,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      quest.isOverdue
                          ? 'Overdue by ${quest.daysRemaining!.abs()} days'
                          : '${quest.daysRemaining} days left',
                      style: TextStyle(
                        color: quest.isOverdue ? Colors.red : Colors.orange,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
              ],
              if (quest.isDaily && quest.streak > 0) ...[
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${quest.streak} day streak',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
              ],
              Row(
                children: [
                  Text(
                    '₱',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${quest.calculatedGold.toStringAsFixed(0)} Gold',
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.show_chart, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '${quest.calculatedExp.toStringAsFixed(0)} XP',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Item usage options
              if (inventory['quest_extension'] != null &&
                  inventory['quest_extension']! > 0) ...[
                SizedBox(height: 16),
                Divider(color: Colors.white24),
                SizedBox(height: 8),
                Text(
                  'Use Items',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _useQuestExtension(quest);
                  },
                  icon: Icon(Icons.schedule, size: 16),
                  label: Text(
                    quest.deadline != null 
                        ? 'Extend Deadline (${inventory['quest_extension']} available)'
                        : 'Add Deadline (${inventory['quest_extension']} available)',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Future<void> _useQuestExtension(Quests quest) async {
    final success = await UserService.useQuestExtension();
    if (success) {
      // Update the quest deadline
      final newDeadline = quest.deadline != null 
          ? quest.deadline!.add(Duration(days: 1))  // Extend existing deadline
          : DateTime.now().add(Duration(days: 1));  // Add new deadline
      
      final updatedQuest = Quests(
        title: quest.title,
        description: quest.description,
        status: quest.status,
        gold: quest.gold,
        exp: quest.exp,
        difficulty: quest.difficulty,
        category: quest.category,
        deadline: newDeadline,
        isDaily: quest.isDaily,
        createdAt: quest.createdAt,
        completedAt: quest.completedAt,
        streak: quest.streak,
        notes: quest.notes,
      );

      // Save the updated quest
      await QuestService.updateQuest(updatedQuest);

      // Reload data
      await _loadQuests();

      final action = quest.deadline != null ? 'extended by 24 hours' : 'deadline added (24 hours)';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quest $action!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No quest extensions available!'),
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
        automaticallyImplyLeading: false, // Remove back button
        title: Text(
          'Quests',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 172, 245, 0),
          ),
        ),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 172, 245, 0)),
      ),
      body: Container(
        color: const Color.fromARGB(255, 28, 27, 23),
        child: Column(
          children: [
            // Search and filters
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search bar
                  TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search quests...',
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                  SizedBox(height: 12),
                  // Filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Category filters
                        ...QuestCategory.values.map(
                          (category) => Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(category.name.toUpperCase()),
                              selected: selectedCategory == category,
                              onSelected: (selected) {
                                setState(() {
                                  selectedCategory = selected ? category : null;
                                });
                              },
                              backgroundColor: Colors.grey[800],
                              selectedColor: category == QuestCategory.health
                                  ? Colors.red.withOpacity(0.3)
                                  : category == QuestCategory.learning
                                  ? Colors.blue.withOpacity(0.3)
                                  : category == QuestCategory.productivity
                                  ? Colors.green.withOpacity(0.3)
                                  : category == QuestCategory.fitness
                                  ? Colors.orange.withOpacity(0.3)
                                  : category == QuestCategory.mindfulness
                                  ? Colors.purple.withOpacity(0.3)
                                  : category == QuestCategory.social
                                  ? Colors.pink.withOpacity(0.3)
                                  : category == QuestCategory.creative
                                  ? Colors.indigo.withOpacity(0.3)
                                  : Colors.amber.withOpacity(0.3),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        // Difficulty filters
                        ...QuestDifficulty.values.map(
                          (difficulty) => Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(difficulty.name.toUpperCase()),
                              selected: selectedDifficulty == difficulty,
                              onSelected: (selected) {
                                setState(() {
                                  selectedDifficulty = selected
                                      ? difficulty
                                      : null;
                                });
                              },
                              backgroundColor: Colors.grey[800],
                              selectedColor: difficulty == QuestDifficulty.easy
                                  ? Colors.green.withOpacity(0.3)
                                  : difficulty == QuestDifficulty.medium
                                  ? Colors.orange.withOpacity(0.3)
                                  : Colors.red.withOpacity(0.3),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Quest list
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 172, 245, 0),
                      ),
                    )
                  : (incompleteQuests.isEmpty && completedQuests.isEmpty)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.white70,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No quests found',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Try adjusting your filters',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                    onRefresh: _refreshQuests,
                    color: Color.fromARGB(255, 172, 245, 0),
                    child: ListView(
                      padding: EdgeInsets.all(16),
                      children: [
                        // Incomplete Quests Section
                        if (incompleteQuests.isNotEmpty) ...[
                          // Section Header
                          Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pending_actions,
                                  color: Color.fromARGB(255, 172, 245, 0),
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Active Quests (${incompleteQuests.length})',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 172, 245, 0),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Incomplete quests
                          ...incompleteQuests.map((quest) => Container(
                            margin: EdgeInsets.only(bottom: 12),
                            child: ItemCard(
                              quests: quest,
                              onTap: () => _showQuestDetails(quest),
                              onStatusChange: () => _updateQuestStatus(quest),
                              onDelete: () => _deleteQuest(quest),
                              inventory: inventory,
                              onInventoryUpdate: _loadQuests,
                              onQuestUpdate: _loadQuests,
                            ),
                          )),
                          SizedBox(height: 24),
                        ],

                        // Completed Quests Section
                        if (completedQuests.isNotEmpty) ...[
                          // Section Header
                          Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.task_alt,
                                  color: Colors.green,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Completed Quests (${completedQuests.length})',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Completed quests
                          ...completedQuests.map((quest) => Container(
                            margin: EdgeInsets.only(bottom: 12),
                            child: ItemCard(
                              quests: quest,
                              onTap: () => _showQuestDetails(quest),
                              onStatusChange: () => _updateQuestStatus(quest),
                              inventory: inventory,
                              onInventoryUpdate: _loadQuests,
                              onQuestUpdate: _loadQuests,
                            ),
                          )),
                        ],
                      ],
                    ),
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: Color.fromARGB(255, 172, 245, 0),
        child: Icon(
          Icons.add,
          color: Colors.black, // Changed from default white to black for better contrast
        ),
      ),
    );
  }
}
