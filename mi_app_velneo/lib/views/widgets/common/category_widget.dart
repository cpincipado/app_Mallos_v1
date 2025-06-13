// lib/views/widgets/common/category_widget.dart - WIDGET PARA CATEGORÍAS ASYNC
import 'package:flutter/material.dart';
import 'package:mi_app_velneo/services/category_service.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/config/theme.dart';

class CategoryWidget extends StatefulWidget {
  final int? categoryId;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderRadius? borderRadius;

  const CategoryWidget({
    super.key,
    required this.categoryId,
    this.textStyle,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
  });

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  String? _categoryName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategory();
  }

  @override
  void didUpdateWidget(CategoryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryId != widget.categoryId) {
      _loadCategory();
    }
  }

  Future<void> _loadCategory() async {
    if (widget.categoryId == null) {
      setState(() {
        _categoryName = null;
        _isLoading = false;
      });
      return;
    }

    try {
      final categoryName = await CategoryService.getCategoryName(widget.categoryId!);
      if (mounted) {
        setState(() {
          _categoryName = categoryName;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _categoryName = null;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        padding: widget.padding ?? EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getSmallSpacing(context),
          vertical: ResponsiveHelper.getSmallSpacing(context) * 0.5,
        ),
        child: SizedBox(
          width: 60,
          height: 16,
          child: LinearProgressIndicator(
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.backgroundColor ?? AppTheme.primaryColor.withValues(alpha: 0.3),
            ),
          ),
        ),
      );
    }

    if (_categoryName == null || _categoryName!.isEmpty) {
      return const SizedBox.shrink(); // No mostrar nada si no hay categoría
    }

    return Container(
      padding: widget.padding ?? EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSmallSpacing(context),
        vertical: ResponsiveHelper.getSmallSpacing(context) * 0.5,
      ),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      ),
      child: Text(
        _categoryName!,
        style: widget.textStyle ?? TextStyle(
          fontSize: ResponsiveHelper.getCaptionFontSize(context),
          color: widget.textColor ?? AppTheme.primaryColor,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// ✅ WIDGET SIMPLIFICADO PARA USAR EN LISTAS
class SimpleCategoryChip extends StatelessWidget {
  final int? categoryId;

  const SimpleCategoryChip({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryWidget(
      categoryId: categoryId,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getSmallSpacing(context),
        vertical: ResponsiveHelper.getSmallSpacing(context) * 0.3,
      ),
      textStyle: TextStyle(
        fontSize: ResponsiveHelper.getCaptionFontSize(context) * 0.9,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}