import 'package:flutter/material.dart';
import 'package:my_app/models/shop_items.dart';
import 'package:my_app/models/avatar.dart';
import 'package:my_app/services/user_service.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  int userGold = 0;
  Map<String, int> inventory = {};
  List<String> unlockedAvatars = [];
  bool isLoading = true;

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
      final gold = await UserService.getUserGold();
      final userInventory = await UserService.getUserInventory();
      final unlocked = await UserService.getUnlockedAvatars();

      setState(() {
        userGold = gold;
        inventory = userInventory;
        unlockedAvatars = unlocked;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading shop data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _purchaseItem(String itemId) async {
    final success = await UserService.purchaseShopItem(itemId);
    if (success) {
      await _loadData(); // Reload data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item purchased successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Not enough gold!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _purchaseAvatar(String avatarId) async {
    final success = await UserService.purchaseAvatar(avatarId);
    if (success) {
      await _loadData(); // Reload data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Avatar purchased successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Not enough gold!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 27, 23),
        title: Text(
          'Shop',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 172, 245, 0),
          ),
        ),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 172, 245, 0)),
        actions: [
          // Gold display
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text(
                  '₱',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  userGold.toString(),
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
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
            : DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    // Tab bar
                    Container(
                      color: Color.fromARGB(255, 53, 51, 51),
                      child: TabBar(
                        labelColor: Color.fromARGB(255, 172, 245, 0),
                        unselectedLabelColor: Colors.white70,
                        indicatorColor: Color.fromARGB(255, 172, 245, 0),
                        tabs: [
                          Tab(text: 'Items'),
                          Tab(text: 'Avatars'),
                        ],
                      ),
                    ),

                    // Tab content
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Items Tab
                          _buildItemsTab(),

                          // Avatars Tab
                          _buildAvatarsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildItemsTab() {
    final items = ShopItems.getAllItems();

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final quantity = inventory[item.id] ?? 0;

        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 53, 51, 51),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: item.color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              // Item icon
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(item.icon, color: item.color, size: 32),
              ),
              SizedBox(width: 16),

              // Item info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      item.description,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    if (quantity > 0)
                      Text(
                        'Owned: $quantity',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),

              // Purchase button
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '₱',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item.cost.toString(),
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: userGold >= item.cost
                        ? () => _purchaseItem(item.id)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: item.color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Buy'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarsTab() {
    final avatars = AvatarCollection.getAllAvatars();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: avatars.length,
      itemBuilder: (context, index) {
        final avatar = avatars[index];
        final isUnlocked = unlockedAvatars.contains(avatar.id);
        final isOwned = isUnlocked;

        return RepaintBoundary(
          child: GestureDetector(
            onTap: () {
              _showAvatarDetails(context, avatar, isOwned);
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 53, 51, 51),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isOwned
                      ? avatar.color.withOpacity(0.5)
                      : Colors.grey.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  // Avatar icon
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: avatar.color.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.asset(
                          avatar.imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          cacheWidth: 200, // Optimize memory usage
                          cacheHeight: 200,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.person, color: Colors.grey, size: 48),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Avatar info
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          avatar.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          avatar.description,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),

                        // Rarity badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: avatar.rarityColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            avatar.rarityText,
                            style: TextStyle(
                              color: avatar.rarityColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Price or status
                        if (isOwned)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'OWNED',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '₱',
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                avatar.cost.toString(),
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 4),

                        // Action button
                        if (!isOwned)
                          SizedBox(
                            width: double.infinity,
                            height: 32,
                            child: ElevatedButton(
                              onPressed: userGold >= avatar.cost
                                  ? () => _purchaseAvatar(avatar.id)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: avatar.color,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text('Buy', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            height: 32,
                            child: ElevatedButton(
                              onPressed: () async {
                                await UserService.setCurrentAvatar(avatar.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Avatar equipped!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text('Equip', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAvatarDetails(BuildContext context, Avatar avatar, bool isOwned) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AvatarDetailsSheet(
        avatar: avatar,
        isOwned: isOwned,
        isEquipped: false, // TODO: pass actual equipped state
        userGold: userGold,
        onBuy: isOwned ? null : () async {
          Navigator.of(context).pop();
          await _purchaseAvatar(avatar.id);
        },
        onEquip: isOwned ? () async {
          Navigator.of(context).pop();
          await UserService.setCurrentAvatar(avatar.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Avatar equipped!'),
              backgroundColor: Colors.green,
            ),
          );
        } : null,
      ),
    );
  }
}

class AvatarDetailsSheet extends StatelessWidget {
  final Avatar avatar;
  final bool isOwned;
  final bool isEquipped;
  final int userGold;
  final VoidCallback? onBuy;
  final VoidCallback? onEquip;

  const AvatarDetailsSheet({
    Key? key,
    required this.avatar,
    required this.isOwned,
    required this.isEquipped,
    required this.userGold,
    this.onBuy,
    this.onEquip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 28, 27, 23),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                avatar.imagePath,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                cacheWidth: 240, // Optimize memory usage
                cacheHeight: 240,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  width: 120,
                  height: 120,
                  child: const Icon(Icons.person, color: Colors.grey, size: 64),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              avatar.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              avatar.description,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: avatar.rarityColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                avatar.rarityText,
                style: TextStyle(
                  color: avatar.rarityColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isOwned)
              isEquipped
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'EQUIPPED',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: onEquip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Equip', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    )
            else
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('₱', style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                        avatar.cost.toString(),
                        style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: userGold >= avatar.cost ? onBuy : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: avatar.color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Buy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  if (userGold < avatar.cost)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text('Not enough gold!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }
}
