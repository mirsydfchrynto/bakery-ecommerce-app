import 'package:flutter/material.dart';

/// Widget untuk menampilkan ikon kategori (All, Breads, Cakes, dll).
/// Dipisahkan agar HomeScreen lebih rapi dan bisa dibaca (Human Readable).
class CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF9800) : Colors.white,
                border: Border.all(
                  color: isSelected ? const Color(0xFFFF9800) : const Color(0xFFE0E0E0),
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  if (!isSelected)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  if (isSelected)
                    BoxShadow(
                      color: const Color(0xFFFF9800).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Icon(
                icon,
                size: 32,
                color: isSelected ? Colors.white : const Color(0xFF757575),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xFF1A1A1A) : const Color(0xFF757575),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
