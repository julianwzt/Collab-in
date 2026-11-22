import 'package:flutter/material.dart';
import '../../../../core/common/color_value.dart';

class CategoryChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.isSelected ? ColorValue.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.isSelected
                ? ColorValue.primaryColor
                : ColorValue.primaryColor.withValues(alpha: 0.45),
            width: 1,
          ),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: widget.isSelected ? Colors.white : ColorValue.primaryColor,
            fontSize: 12.5,
            fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}