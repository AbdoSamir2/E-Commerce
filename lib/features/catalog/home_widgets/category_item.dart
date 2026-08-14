import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.title,
    required this.icon,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final activeBg = isDark ? Colors.white : const Color(0xFF1E1E2C);
    final activeText = isDark ? const Color(0xFF1E1E2C) : Colors.white;
    final inactiveBg = isDark
        ? const Color(0xFF2D2D3F)
        : const Color(0xFFF3F4F8);
    final inactiveText = isDark ? Colors.white70 : const Color(0xFF5A5C6E);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : inactiveBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeBg.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: isSelected ? activeText : inactiveText),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? activeText : inactiveText,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
