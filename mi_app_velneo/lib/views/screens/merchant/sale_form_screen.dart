import 'package:flutter/material.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/utils/validators.dart';
import 'package:mi_app_velneo/services/merchant_service.dart';

class SaleFormScreen extends StatefulWidget {
  const SaleFormScreen({super.key});

  @override
  State<SaleFormScreen> createState() => _SaleFormScreenState();
}

class _SaleFormScreenState extends State<SaleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardController = TextEditingController();
  final _amountController = TextEditingController();
  final _pointsAddController = TextEditingController();
  final _pointsSubtractController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _cardController.dispose();
    _amountController.dispose();
    _pointsAddController.dispose();
    _pointsSubtractController.dispose();
    super.dispose();
  }

  Future<void> _submitSale() async {
    if (!_formKey.currentState!.validate()) return;

    // Validar que no se sumen y resten puntos a la vez
    final pointsAdd = int.tryParse(_pointsAddController.text) ?? 0;
    final pointsSubtract = int.tryParse(_pointsSubtractController.text) ?? 0;

    if (pointsAdd > 0 && pointsSubtract > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pueden sumar y restar puntos simultáneamente'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await MerchantService.registerSale(
        cardNumber: _cardController.text,
        amount: double.parse(_amountController.text),
        pointsAdded: pointsAdd,
        pointsSubtracted: pointsSubtract,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Limpiar formulario
        _cardController.clear();
        _amountController.clear();
        _pointsAddController.clear();
        _pointsSubtractController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Venta registrada con éxito!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar venta: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showScannerInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escáner de tarjetas'),
        content: const Text('Funcionalidad de escáner disponible próximamente'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxContentWidth = ResponsiveHelper.isDesktop(context)
            ? 600.0
            : double.infinity;

        return SingleChildScrollView(
          padding: ResponsiveHelper.getHorizontalPadding(context),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: Column(
                children: [
                  ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                  // ✅ Botón "Alta Venta" decorativo
                  Container(
                    width: double.infinity,
                    height: ResponsiveHelper.getButtonHeight(context),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8BC34A), Color(0xFF4CAF50)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getButtonBorderRadius(context),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Alta Venta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.getSubtitleFontSize(
                            context,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  ResponsiveHelper.verticalSpace(context, SpacingSize.large),

                  // ✅ Ilustración de personas diversas
                  Container(
                    width: double.infinity,
                    height: ResponsiveHelper.isDesktop(context) ? 200 : 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getCardBorderRadius(context),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.groups,
                            size:
                                ResponsiveHelper.getMenuButtonIconSize(
                                  context,
                                ) *
                                2,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Registro de Ventas',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getBodyFontSize(
                                context,
                              ),
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ResponsiveHelper.verticalSpace(context, SpacingSize.large),

                  // ✅ Formulario
                  Container(
                    width: double.infinity,
                    padding: ResponsiveHelper.getCardPadding(context),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getCardBorderRadius(context),
                      ),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: ResponsiveHelper.getCardElevation(
                            context,
                          ),
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✅ Campo Tarjeta con botón escanear
                          Text(
                            'Tarjeta',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getBodyFontSize(
                                context,
                              ),
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          ResponsiveHelper.verticalSpace(
                            context,
                            SpacingSize.small,
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _cardController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'El número de tarjeta es obligatorio';
                                    }
                                    if (!MerchantService.validateCardNumber(
                                      value,
                                    )) {
                                      return 'Número de tarjeta inválido';
                                    }
                                    return null;
                                  },
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.getBodyFontSize(
                                      context,
                                    ),
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Número de tarjeta EU MALLOS',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.credit_card),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: _showScannerInfo,
                                icon: const Icon(Icons.qr_code_scanner),
                                tooltip: 'Escanear tarjeta',
                                style: IconButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor
                                      .withValues(alpha: 0.1),
                                  foregroundColor: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),

                          ResponsiveHelper.verticalSpace(
                            context,
                            SpacingSize.medium,
                          ),

                          // ✅ Campo Importe
                          Text(
                            'Importe',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getBodyFontSize(
                                context,
                              ),
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          ResponsiveHelper.verticalSpace(
                            context,
                            SpacingSize.small,
                          ),

                          TextFormField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El importe es obligatorio';
                              }
                              if (double.tryParse(value) == null ||
                                  double.parse(value) <= 0) {
                                return 'Ingrese un importe válido';
                              }
                              return null;
                            },
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getBodyFontSize(
                                context,
                              ),
                            ),
                            decoration: const InputDecoration(
                              hintText: '0.00',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.euro),
                              suffixText: '€',
                            ),
                          ),

                          ResponsiveHelper.verticalSpace(
                            context,
                            SpacingSize.medium,
                          ),

                          // ✅ Campo Puntos a sumar
                          Text(
                            'Puntos a sumar',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getBodyFontSize(
                                context,
                              ),
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          ResponsiveHelper.verticalSpace(
                            context,
                            SpacingSize.small,
                          ),

                          TextFormField(
                            controller: _pointsAddController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (int.tryParse(value) == null ||
                                    int.parse(value) < 0) {
                                  return 'Ingrese un número válido';
                                }
                              }
                              return null;
                            },
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getBodyFontSize(
                                context,
                              ),
                            ),
                            decoration: const InputDecoration(
                              hintText: '0',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.add_circle_outline,
                                color: Colors.green,
                              ),
                            ),
                          ),

                          ResponsiveHelper.verticalSpace(
                            context,
                            SpacingSize.medium,
                          ),

                          // ✅ Campo Puntos a restar
                          Text(
                            'Puntos a restar',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getBodyFontSize(
                                context,
                              ),
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          ResponsiveHelper.verticalSpace(
                            context,
                            SpacingSize.small,
                          ),

                          TextFormField(
                            controller: _pointsSubtractController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (int.tryParse(value) == null ||
                                    int.parse(value) < 0) {
                                  return 'Ingrese un número válido';
                                }
                              }
                              return null;
                            },
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getBodyFontSize(
                                context,
                              ),
                            ),
                            decoration: const InputDecoration(
                              hintText: '0',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red,
                              ),
                            ),
                          ),

                          ResponsiveHelper.verticalSpace(
                            context,
                            SpacingSize.large,
                          ),

                          // ✅ Botón ENVIAR
                          SizedBox(
                            width: double.infinity,
                            height: ResponsiveHelper.getButtonHeight(context),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submitSale,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveHelper.getButtonBorderRadius(
                                      context,
                                    ),
                                  ),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      'ENVIAR',
                                      style: TextStyle(
                                        fontSize:
                                            ResponsiveHelper.getHeadingFontSize(
                                              context,
                                            ),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ResponsiveHelper.verticalSpace(context, SpacingSize.xl),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
