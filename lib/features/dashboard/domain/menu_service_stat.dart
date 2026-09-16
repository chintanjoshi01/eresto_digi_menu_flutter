class MenuServiceStat {
  final String id; // 'all', 'dine_in', 'ird'
  final String name; // 'All menus', 'Dine-In', 'IRD'
  final int scansCount; // e.g. 247, 156, 91
  final int sessionsCount; // e.g. 3, 5

  const MenuServiceStat({
    required this.id,
    required this.name,
    required this.scansCount,
    this.sessionsCount = 0,
  });
}
