# Questify - Quest Management App

A Flutter-based quest management application that helps users track, manage, and complete daily tasks with gamification elements including XP, gold, avatars, and active effects.

## 🎯 Purpose

Questify transforms your daily tasks into an engaging quest system where you can:
- Create and manage quests with different difficulty levels
- Earn XP and gold for completing quests
- Unlock avatars and purchase items in the shop
- Use active effects to boost your progress
- Track your daily streak and rank progression

## 🚀 Features

### Core Features
- **Quest Management**: Create, edit, and track quests with different categories and difficulty levels
- **Gamification System**: Earn XP and gold for completing quests
- **Ranking System**: Progress through different ranks (Bronze → Silver → Gold → Platinum → Diamond)
- **Avatar System**: Unlock and equip different avatars with unique designs
- **Shop System**: Purchase boosters and items to enhance your questing experience
- **Daily Streak**: Maintain a daily streak for bonus rewards
- **Active Effects**: Use boosters to enhance XP and gold earnings

### Technical Features
- **Lazy Loading**: Optimized data loading with caching for better performance
- **Pull-to-Refresh**: Swipe down to refresh data on all screens
- **Dark Theme**: Consistent dark theme with green accent color
- **Responsive Design**: Works on various screen sizes
- **Local Storage**: Data persists between app sessions

## 📱 Screens & Navigation

### 1. Dashboard
- **Overview**: Main screen showing your character stats and recent quests
- **Features**:
  - Character avatar and basic info
  - Current rank and progress
  - XP, Gold, and Level display
  - Recent completed quests
  - Active effects status
  - Shop notification (red dot when affordable items available)

### 2. Quest List
- **Overview**: View and manage all your quests
- **Features**:
  - Separate sections for active and completed quests
  - Quest status management (pending, in progress, completed)
  - Quest details and rewards
  - Delete quests
  - Pull-to-refresh functionality

### 3. Add Quest
- **Overview**: Create new quests with detailed information
- **Features**:
  - Quest title and description
  - Difficulty selection (Easy, Medium, Hard)
  - Category selection (Work, Personal, Health, Learning, etc.)
  - Deadline setting (optional)
  - Daily quest option
  - Automatic XP and gold calculation based on difficulty

### 4. Shop
- **Overview**: Purchase items and avatars with earned gold
- **Features**:
  - Two tabs: Items and Avatars
  - Item categories:
    - XP Booster (500 gold): 2x XP for next 3 quests
    - Gold Booster (800 gold): 1.5x gold for next 5 quests
    - Streak Protector (300 gold): Protects daily streak for 24 hours
    - Quest Extension (200 gold): Extends quest deadline by 24 hours
  - Avatar collection with different rarities (Common, Rare, Epic, Legendary)
  - Current gold display
  - Purchase confirmation

### 5. Character Screen
- **Overview**: Detailed character information and inventory
- **Features**:
  - Character avatar and stats
  - Rank information and progress
  - Statistics (XP, Gold, Level, Streak, Completed/Pending quests)
  - Daily streak display
  - Active effects status
  - Inventory management
  - Item usage functionality

### 6. Settings
- **Overview**: Navigation to Shop and Character screens
- **Features**:
  - Quick access to Shop
  - Quick access to Character screen

## 🎮 Active Effects System

### What are Active Effects?
Active effects are temporary boosts that enhance your questing experience. They are purchased from the shop and provide various benefits.

### Available Effects

#### 1. XP Booster (500 gold)
- **Effect**: Doubles XP earned from quests
- **Duration**: Next 3 quests
- **Best Use**: When you have high-value quests to complete
- **Strategy**: Use before completing difficult or high-reward quests

#### 2. Gold Booster (800 gold)
- **Effect**: Increases gold earned by 1.5x
- **Duration**: Next 5 quests
- **Best Use**: When you need gold for shop purchases
- **Strategy**: Use when you have multiple quests ready to complete

#### 3. Streak Protector (300 gold)
- **Effect**: Protects your daily streak from being lost
- **Duration**: 24 hours
- **Best Use**: When you might miss a day but want to maintain your streak
- **Strategy**: Use proactively when you're busy or traveling

#### 4. Quest Extension (200 gold)
- **Effect**: Extends a quest's deadline by 24 hours
- **Duration**: One quest
- **Best Use**: When a quest is about to expire
- **Strategy**: Use on high-value quests that you want to complete

### How to Use Active Effects
1. **Purchase**: Buy effects from the Shop using gold
2. **Activate**: Use items from your inventory in the Character screen
3. **Monitor**: Check active effects status in Dashboard or Character screen
4. **Maximize**: Plan your quest completion around active effects

## 🏆 Ranking System

### Rank Progression
- **Bronze V** → **Bronze IV** → **Bronze III** → **Bronze II** → **Bronze I**
- **Silver V** → **Silver IV** → **Silver III** → **Silver II** → **Silver I**
- **Gold V** → **Gold IV** → **Gold III** → **Gold II** → **Gold I**
- **Platinum V** → **Platinum IV** → **Platinum III** → **Platinum II** → **Platinum I**
- **Diamond V** → **Diamond IV** → **Diamond III** → **Diamond II** → **Diamond I**

### XP Requirements
- Each rank requires increasing amounts of XP
- Higher ranks provide better XP multipliers
- Progress is shown with a progress bar

## 🎨 Avatar System

### Avatar Rarities
- **Common** (300 gold): Basic avatars with simple designs
- **Rare** (500 gold): More detailed avatars with unique themes
- **Epic** (750 gold): Special avatars with advanced designs
- **Legendary** (1000 gold): Premium avatars with exclusive designs

### Avatar Features
- Each avatar has a unique color scheme
- Avatars affect the character screen's visual theme
- Default avatar is free and always available

## 💰 Economy System

### Earning Gold
- Complete quests to earn gold
- Gold amount depends on quest difficulty
- Active effects can boost gold earnings

### Spending Gold
- Purchase active effects from the shop
- Buy avatars to customize your character
- Gold is displayed in the top-right corner of most screens

## 📊 Quest Categories

### Available Categories
- **Work**: Professional tasks and projects
- **Personal**: Personal development and hobbies
- **Health**: Exercise and wellness activities
- **Learning**: Educational goals and skill development
- **Social**: Social activities and relationships
- **Finance**: Financial planning and management
- **Home**: Household tasks and organization
- **Creative**: Artistic and creative projects

### Quest Difficulties
- **Easy**: Low XP and gold rewards, quick completion
- **Medium**: Balanced rewards and time investment
- **Hard**: High rewards but requires significant effort

## 🔧 Technical Features

### Lazy Loading
- Optimized data loading with intelligent caching
- Faster app performance and reduced loading times
- Background data preloading for smooth navigation

### Data Persistence
- All data is stored locally using SharedPreferences
- Progress is saved automatically
- No internet connection required

### Performance Optimizations
- Efficient state management
- Optimized image loading for avatars
- Smooth animations and transitions

## 🎯 Getting Started

### First Time Setup
1. **Launch the app**: Start Questify
2. **Create your first quest**: Use the "+" button to add a quest
3. **Complete quests**: Mark quests as complete to earn XP and gold
4. **Visit the shop**: Purchase your first active effect or avatar
5. **Check your character**: View your progress and stats

### Daily Routine
1. **Review quests**: Check your active quests in the Quest List
2. **Use active effects**: Activate boosters before completing quests
3. **Complete quests**: Mark completed quests to earn rewards
4. **Maintain streak**: Complete at least one quest daily
5. **Shop visit**: Purchase new items or avatars with earned gold

### Advanced Strategies
1. **Effect Timing**: Use XP boosters before high-value quests
2. **Streak Protection**: Use streak protectors during busy periods
3. **Quest Planning**: Create quests with realistic deadlines
4. **Gold Management**: Save gold for important purchases
5. **Rank Progression**: Focus on completing quests to advance ranks

## 🎮 Tips & Tricks

### Maximizing XP
- Use XP boosters before completing difficult quests
- Focus on completing multiple quests when boosters are active
- Create quests with appropriate difficulty levels

### Gold Management
- Use gold boosters when you have multiple quests ready
- Save gold for important purchases like streak protectors
- Balance spending between effects and avatars

### Streak Maintenance
- Use streak protectors during busy periods
- Create easy daily quests to maintain consistency
- Plan ahead for days when you might be busy

### Quest Creation
- Be specific with quest descriptions
- Set realistic deadlines
- Use appropriate difficulty levels
- Create a mix of short and long-term quests

## 🔧 Development

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation
```bash
# Clone the repository
git clone [repository-url]

# Navigate to project directory
cd Solo-Leveling-6

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Project Structure
```
lib/
├── main.dart                 # App entry point and routing
├── models/                   # Data models
│   ├── avatar.dart          # Avatar system
│   ├── ranking_system.dart  # Rank progression
│   └── shop_items.dart      # Shop items
├── pages/                   # UI screens
│   ├── dashboard.dart       # Main dashboard
│   ├── character.dart       # Character screen
│   ├── shop.dart           # Shop interface
│   ├── Listitems.dart      # Quest list
│   ├── addQuests.dart      # Add quest form
│   └── questCard.dart      # Quest card widget
├── services/               # Business logic
│   ├── quest_service.dart  # Quest management
│   ├── user_service.dart   # User data management
│   └── lazy_loading_service.dart # Performance optimization
└── utils/                  # Utility functions
    └── app_icon_generator.dart
```

### Key Technologies
- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language
- **SharedPreferences**: Local data storage
- **Provider**: State management (if used)

## 📱 Supported Platforms

- **Android**: API level 21 and above
- **iOS**: iOS 11.0 and above
- **Web**: Modern browsers (Chrome, Firefox, Safari, Edge)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

If you encounter any issues or have questions:
1. Check the FAQ section
2. Review the troubleshooting guide
3. Create an issue on GitHub
4. Contact the development team

## 🎉 Acknowledgments

- Flutter team for the amazing framework
- The quest management community for inspiration
- All contributors and beta testers

---

**Questify** - Transform your daily tasks into epic quests! 🚀
