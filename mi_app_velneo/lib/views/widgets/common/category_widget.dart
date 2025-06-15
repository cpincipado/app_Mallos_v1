// lib/views/widgets/common/category_widget.dart - MEJORADO CON MANEJO DE ERRORES
import 'package:flutter/material.dart';
import 'package:mi_app_velneo/services/category_service.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:flutter/foundation.dart';

class CategoryWidget extends StatefulWidget {
  final int? categoryId;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderRadius? borderRadius;
  final bool showOnError; // ✅ NUEVO: Mostrar algo cuando hay error

  const CategoryWidget({
    super.key,
    required this.categoryId,
    this.textStyle,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.showOnError = false, // ✅ Por defecto no mostrar nada si hay error
  });

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  String? _categoryName;
  bool _isLoading = true;
  bool _hasError = false;

  /// ✅ LOGGING HELPER
  void _log(String message) {
    if (kDebugMode) {
      print('CategoryWidget: $message');
    }
  }

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
        _hasError = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      _log('Cargando categoría ID: ${widget.categoryId}');

      final categoryName = await CategoryService.getCategoryName(
        widget.categoryId!,
      );

      if (mounted) {
        setState(() {
          _categoryName = categoryName;
          _isLoading = false;
          _hasError = false;
        });

        _log('Categoría cargada: $categoryName');
      }
    } catch (e) {
      _log('Error cargando categoría ${widget.categoryId}: $e');

      if (mounted) {
        setState(() {
          _categoryName = null;
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ LOADING STATE
    if (_isLoading) {
      return Container(
        padding:
            widget.padding ??
            EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getSmallSpacing(context),
              vertical: ResponsiveHelper.getSmallSpacing(context) * 0.5,
            ),
        child: SizedBox(
          width: 60,
          height: 16,
          child: LinearProgressIndicator(
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.backgroundColor ??
                  AppTheme.primaryColor.withValues(alpha: 0.3),
            ),
          ),
        ),
      );
    }

    // ✅ ERROR STATE
    if (_hasError) {
      if (!widget.showOnError) {
        return const SizedBox.shrink(); // No mostrar nada
      }

      // Mostrar indicador de error si se solicita
      return Container(
        padding:
            widget.padding ??
            EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getSmallSpacing(context),
              vertical: ResponsiveHelper.getSmallSpacing(context) * 0.5,
            ),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Text(
          'Error',
          style:
              widget.textStyle ??
              TextStyle(
                fontSize: ResponsiveHelper.getCaptionFontSize(context),
                color: Colors.red.shade700,
                fontWeight: FontWeight.w600,
              ),
          textAlign: TextAlign.center,
        ),
      );
    }

    // ✅ EMPTY STATE - No hay categoría
    if (_categoryName == null || _categoryName!.isEmpty) {
      return const SizedBox.shrink(); // No mostrar nada si no hay categoría
    }

    // ✅ SUCCESS STATE - Mostrar categoría
    return Container(
      padding:
          widget.padding ??
          EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSmallSpacing(context),
            vertical: ResponsiveHelper.getSmallSpacing(context) * 0.5,
          ),
      decoration: BoxDecoration(
        color:
            widget.backgroundColor ??
            AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      ),
      child: Text(
        _categoryName!,
        style:
            widget.textStyle ??
            TextStyle(
              fontSize: ResponsiveHelper.getCaptionFontSize(context),
              color: widget.textColor ?? AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// ✅ WIDGET SIMPLIFICADO PARA USAR EN LISTAS - MEJORADO
class SimpleCategoryChip extends StatelessWidget {
  final int? categoryId;

  const SimpleCategoryChip({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return CategoryWidget(
      categoryId: categoryId,
      showOnError: false, // ✅ No mostrar nada si hay error
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
