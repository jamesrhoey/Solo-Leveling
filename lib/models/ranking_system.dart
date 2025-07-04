import 'package:flutter/material.dart';

enum Rank {
  bronzeV,
  bronzeIV,
  bronzeIII,
  bronzeII,
  bronzeI,
  silverV,
  silverIV,
  silverIII,
  silverII,
  silverI,
  goldV,
  goldIV,
  goldIII,
  goldII,
  goldI,
  platinumV,
  platinumIV,
  platinumIII,
  platinumII,
  platinumI,
  diamondV,
  diamondIV,
  diamondIII,
  diamondII,
  diamondI,
  master,
  grandmaster,
  legend,
}

class RankRewards {
  final int goldBonus;
  final double xpMultiplier;
  final String title;
  final Color rankColor;
  final IconData rankIcon;
  final String description;

  const RankRewards({
    required this.goldBonus,
    required this.xpMultiplier,
    required this.title,
    required this.rankColor,
    required this.rankIcon,
    required this.description,
  });
}

class RankingSystem {
  static const Map<Rank, int> _rankXPRequirements = {
    Rank.bronzeV: 0,
    Rank.bronzeIV: 200,
    Rank.bronzeIII: 400,
    Rank.bronzeII: 600,
    Rank.bronzeI: 800,
    Rank.silverV: 1000,
    Rank.silverIV: 1300,
    Rank.silverIII: 1600,
    Rank.silverII: 1900,
    Rank.silverI: 2200,
    Rank.goldV: 2500,
    Rank.goldIV: 3000,
    Rank.goldIII: 3500,
    Rank.goldII: 4000,
    Rank.goldI: 4500,
    Rank.platinumV: 5000,
    Rank.platinumIV: 6000,
    Rank.platinumIII: 7000,
    Rank.platinumII: 8000,
    Rank.platinumI: 9000,
    Rank.diamondV: 10000,
    Rank.diamondIV: 12000,
    Rank.diamondIII: 14000,
    Rank.diamondII: 16000,
    Rank.diamondI: 18000,
    Rank.master: 20000,
    Rank.grandmaster: 50000,
    Rank.legend: 100000,
  };

  static Rank getRankFromXP(double xp) {
    if (xp >= 100000) return Rank.legend;
    if (xp >= 50000) return Rank.grandmaster;
    if (xp >= 20000) return Rank.master;
    if (xp >= 18000) return Rank.diamondI;
    if (xp >= 16000) return Rank.diamondII;
    if (xp >= 14000) return Rank.diamondIII;
    if (xp >= 12000) return Rank.diamondIV;
    if (xp >= 10000) return Rank.diamondV;
    if (xp >= 9000) return Rank.platinumI;
    if (xp >= 8000) return Rank.platinumII;
    if (xp >= 7000) return Rank.platinumIII;
    if (xp >= 6000) return Rank.platinumIV;
    if (xp >= 5000) return Rank.platinumV;
    if (xp >= 4500) return Rank.goldI;
    if (xp >= 4000) return Rank.goldII;
    if (xp >= 3500) return Rank.goldIII;
    if (xp >= 3000) return Rank.goldIV;
    if (xp >= 2500) return Rank.goldV;
    if (xp >= 2200) return Rank.silverI;
    if (xp >= 1900) return Rank.silverII;
    if (xp >= 1600) return Rank.silverIII;
    if (xp >= 1300) return Rank.silverIV;
    if (xp >= 1000) return Rank.silverV;
    if (xp >= 800) return Rank.bronzeI;
    if (xp >= 600) return Rank.bronzeII;
    if (xp >= 400) return Rank.bronzeIII;
    if (xp >= 200) return Rank.bronzeIV;
    return Rank.bronzeV;
  }

  static RankRewards getRankRewards(Rank rank) {
    switch (rank) {
      case Rank.bronzeV:
        return const RankRewards(
          goldBonus: 0,
          xpMultiplier: 1.0,
          title: "Bronze V",
          rankColor: Colors.brown,
          rankIcon: Icons.star,
          description: "Beginner Quest Master",
        );
      case Rank.bronzeIV:
        return const RankRewards(
          goldBonus: 5,
          xpMultiplier: 1.02,
          title: "Bronze IV",
          rankColor: Colors.brown,
          rankIcon: Icons.star,
          description: "Novice Quest Master",
        );
      case Rank.bronzeIII:
        return const RankRewards(
          goldBonus: 10,
          xpMultiplier: 1.03,
          title: "Bronze III",
          rankColor: Colors.brown,
          rankIcon: Icons.star,
          description: "Aspiring Quest Master",
        );
      case Rank.bronzeII:
        return const RankRewards(
          goldBonus: 15,
          xpMultiplier: 1.04,
          title: "Bronze II",
          rankColor: Colors.brown,
          rankIcon: Icons.star,
          description: "Dedicated Quest Master",
        );
      case Rank.bronzeI:
        return const RankRewards(
          goldBonus: 20,
          xpMultiplier: 1.05,
          title: "Bronze I",
          rankColor: Colors.brown,
          rankIcon: Icons.star,
          description: "Skilled Quest Master",
        );
      case Rank.silverV:
        return const RankRewards(
          goldBonus: 25,
          xpMultiplier: 1.06,
          title: "Silver V",
          rankColor: Colors.grey,
          rankIcon: Icons.star,
          description: "Silver Quest Master",
        );
      case Rank.silverIV:
        return const RankRewards(
          goldBonus: 30,
          xpMultiplier: 1.07,
          title: "Silver IV",
          rankColor: Colors.grey,
          rankIcon: Icons.star,
          description: "Experienced Quest Master",
        );
      case Rank.silverIII:
        return const RankRewards(
          goldBonus: 35,
          xpMultiplier: 1.08,
          title: "Silver III",
          rankColor: Colors.grey,
          rankIcon: Icons.star,
          description: "Veteran Quest Master",
        );
      case Rank.silverII:
        return const RankRewards(
          goldBonus: 40,
          xpMultiplier: 1.09,
          title: "Silver II",
          rankColor: Colors.grey,
          rankIcon: Icons.star,
          description: "Elite Quest Master",
        );
      case Rank.silverI:
        return const RankRewards(
          goldBonus: 45,
          xpMultiplier: 1.1,
          title: "Silver I",
          rankColor: Colors.grey,
          rankIcon: Icons.star,
          description: "Master Quest Master",
        );
      case Rank.goldV:
        return const RankRewards(
          goldBonus: 50,
          xpMultiplier: 1.12,
          title: "Gold V",
          rankColor: Colors.amber,
          rankIcon: Icons.star,
          description: "Golden Quest Master",
        );
      case Rank.goldIV:
        return const RankRewards(
          goldBonus: 60,
          xpMultiplier: 1.14,
          title: "Gold IV",
          rankColor: Colors.amber,
          rankIcon: Icons.star,
          description: "Distinguished Quest Master",
        );
      case Rank.goldIII:
        return const RankRewards(
          goldBonus: 70,
          xpMultiplier: 1.16,
          title: "Gold III",
          rankColor: Colors.amber,
          rankIcon: Icons.star,
          description: "Honored Quest Master",
        );
      case Rank.goldII:
        return const RankRewards(
          goldBonus: 80,
          xpMultiplier: 1.18,
          title: "Gold II",
          rankColor: Colors.amber,
          rankIcon: Icons.star,
          description: "Revered Quest Master",
        );
      case Rank.goldI:
        return const RankRewards(
          goldBonus: 90,
          xpMultiplier: 1.2,
          title: "Gold I",
          rankColor: Colors.amber,
          rankIcon: Icons.star,
          description: "Legendary Quest Master",
        );
      case Rank.platinumV:
        return const RankRewards(
          goldBonus: 100,
          xpMultiplier: 1.22,
          title: "Platinum V",
          rankColor: Colors.blue,
          rankIcon: Icons.star,
          description: "Platinum Quest Master",
        );
      case Rank.platinumIV:
        return const RankRewards(
          goldBonus: 120,
          xpMultiplier: 1.24,
          title: "Platinum IV",
          rankColor: Colors.blue,
          rankIcon: Icons.star,
          description: "Distinguished Platinum Master",
        );
      case Rank.platinumIII:
        return const RankRewards(
          goldBonus: 140,
          xpMultiplier: 1.26,
          title: "Platinum III",
          rankColor: Colors.blue,
          rankIcon: Icons.star,
          description: "Elite Platinum Master",
        );
      case Rank.platinumII:
        return const RankRewards(
          goldBonus: 160,
          xpMultiplier: 1.28,
          title: "Platinum II",
          rankColor: Colors.blue,
          rankIcon: Icons.star,
          description: "Master Platinum Master",
        );
      case Rank.platinumI:
        return const RankRewards(
          goldBonus: 180,
          xpMultiplier: 1.3,
          title: "Platinum I",
          rankColor: Colors.blue,
          rankIcon: Icons.star,
          description: "Grand Platinum Master",
        );
      case Rank.diamondV:
        return const RankRewards(
          goldBonus: 200,
          xpMultiplier: 1.32,
          title: "Diamond V",
          rankColor: Colors.cyan,
          rankIcon: Icons.diamond,
          description: "Diamond Quest Master",
        );
      case Rank.diamondIV:
        return const RankRewards(
          goldBonus: 250,
          xpMultiplier: 1.34,
          title: "Diamond IV",
          rankColor: Colors.cyan,
          rankIcon: Icons.diamond,
          description: "Distinguished Diamond Master",
        );
      case Rank.diamondIII:
        return const RankRewards(
          goldBonus: 300,
          xpMultiplier: 1.36,
          title: "Diamond III",
          rankColor: Colors.cyan,
          rankIcon: Icons.diamond,
          description: "Elite Diamond Master",
        );
      case Rank.diamondII:
        return const RankRewards(
          goldBonus: 350,
          xpMultiplier: 1.38,
          title: "Diamond II",
          rankColor: Colors.cyan,
          rankIcon: Icons.diamond,
          description: "Master Diamond Master",
        );
      case Rank.diamondI:
        return const RankRewards(
          goldBonus: 400,
          xpMultiplier: 1.4,
          title: "Diamond I",
          rankColor: Colors.cyan,
          rankIcon: Icons.diamond,
          description: "Grand Diamond Master",
        );
      case Rank.master:
        return const RankRewards(
          goldBonus: 500,
          xpMultiplier: 1.45,
          title: "Master",
          rankColor: Colors.purple,
          rankIcon: Icons.auto_awesome,
          description: "Master Quest Legend",
        );
      case Rank.grandmaster:
        return const RankRewards(
          goldBonus: 750,
          xpMultiplier: 1.5,
          title: "Grandmaster",
          rankColor: Colors.deepPurple,
          rankIcon: Icons.auto_awesome,
          description: "Grandmaster Quest Legend",
        );
      case Rank.legend:
        return const RankRewards(
          goldBonus: 1000,
          xpMultiplier: 1.6,
          title: "Legend",
          rankColor: Colors.red,
          rankIcon: Icons.auto_awesome,
          description: "Legendary Quest God",
        );
    }
  }

  static int getXPRequiredForNextRank(double currentXP) {
    final currentRank = getRankFromXP(currentXP);
    final ranks = Rank.values;
    final currentIndex = ranks.indexOf(currentRank);

    if (currentIndex >= ranks.length - 1) {
      return 0; // Already at max rank
    }

    final nextRank = ranks[currentIndex + 1];
    final nextRankXP = _rankXPRequirements[nextRank]!;
    return nextRankXP - currentXP.toInt();
  }

  static double getProgressToNextRank(double currentXP) {
    final currentRank = getRankFromXP(currentXP);
    final ranks = Rank.values;
    final currentIndex = ranks.indexOf(currentRank);

    if (currentIndex >= ranks.length - 1) {
      return 1.0; // Already at max rank
    }

    final currentRankXP = _rankXPRequirements[currentRank]!;
    final nextRank = ranks[currentIndex + 1];
    final nextRankXP = _rankXPRequirements[nextRank]!;

    final progress = (currentXP - currentRankXP) / (nextRankXP - currentRankXP);
    return progress.clamp(0.0, 1.0);
  }
}
