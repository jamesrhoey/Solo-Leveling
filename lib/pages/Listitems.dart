import 'package:flutter/material.dart';
import 'package:my_app/pages/Quests.dart';
import 'package:my_app/pages/questCard.dart';
import 'package:my_app/services/quest_service.dart';

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

  @override
  void initState() {
    super.initState();
    _loadQuests();
  }

  Future<void> _loadQuests() async {
    setState(() {
      isLoading = true;
    });

    try {
      final loadedQuests = await QuestService.getAllQuests();
      setState(() {
        quests = loadedQuests;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading quests: $e');
      setState(() {
        isLoading = false;
      });
    }
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
      await _loadQuests();

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
                  Icon(Icons.attach_money, color: Colors.amber, size: 20),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 27, 23),
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
                  : filteredQuests.isEmpty
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
                  : ListView.builder(
                      itemCount: filteredQuests.length,
                      itemBuilder: (context, index) {
                        return ItemCard(
                          quests: filteredQuests[index],
                          onTap: () => _showQuestDetails(filteredQuests[index]),
                          onStatusChange: () =>
                              _updateQuestStatus(filteredQuests[index]),
                        );
                      },
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
        child: Icon(Icons.add),
      ),
    );
  }
}
