import 'package:flutter/material.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/models/sale_model.dart';
import 'package:mi_app_velneo/services/merchant_service.dart';

class SalesListScreen extends StatefulWidget {
  const SalesListScreen({super.key});

  @override
  State<SalesListScreen> createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  List<SaleModel> _sales = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  Future<void> _loadSales() async {
    try {
      final sales = await MerchantService.getMerchantSales();
      setState(() {
        _sales = sales;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al cargar las ventas'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _refreshSales() async {
    setState(() {
      _isLoading = true;
    });
    await _loadSales();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshSales,
      child: Column(
        children: [
          // ✅ Header de la tabla
          Container(
            width: double.infinity,
            padding: ResponsiveHelper.getCardPadding(context),
            margin: ResponsiveHelper.getHorizontalPadding(
              context,
            ).copyWith(top: ResponsiveHelper.getMediumSpacing(context)),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getCardBorderRadius(context),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Socio (Tarjeta)',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getCaptionFontSize(context),
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Fecha',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getCaptionFontSize(context),
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Importe',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getCaptionFontSize(context),
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Puntos',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getCaptionFontSize(context),
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),

          // ✅ Lista de ventas
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _sales.isEmpty
                ? _buildEmptyState()
                : _buildSalesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesList() {
    return ListView.builder(
      padding: ResponsiveHelper.getHorizontalPadding(context).copyWith(
        top: ResponsiveHelper.getSmallSpacing(context),
        bottom: ResponsiveHelper.getLargeSpacing(context),
      ),
      itemCount: _sales.length,
      itemBuilder: (context, index) {
        final sale = _sales[index];
        return _buildSaleCard(sale);
      },
    );
  }

  Widget _buildSaleCard(SaleModel sale) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getSmallSpacing(context),
      ),
      padding: ResponsiveHelper.getCardPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getCardBorderRadius(context),
        ),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: ResponsiveHelper.getCardElevation(context),
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showSaleDetail(sale),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getCardBorderRadius(context),
        ),
        child: Row(
          children: [
            // ✅ Tarjeta (enmascarada)
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sale.maskedCardNumber,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getCaptionFontSize(context),
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    sale.formattedTime,
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.getCaptionFontSize(context) - 1,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Fecha
            Expanded(
              flex: 2,
              child: Text(
                sale.formattedDate,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getCaptionFontSize(context),
                  color: AppTheme.textSecondary,
                ),
              ),
            ),

            // ✅ Importe
            Expanded(
              flex: 1,
              child: Text(
                sale.formattedAmount,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getCaptionFontSize(context),
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.right,
              ),
            ),

            // ✅ Puntos (con color según signo)
            Expanded(
              flex: 1,
              child: Text(
                sale.netPoints > 0
                    ? '+${sale.netPoints}'
                    : sale.netPoints < 0
                    ? '${sale.netPoints}'
                    : '0',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getCaptionFontSize(context),
                  fontWeight: FontWeight.w600,
                  color: sale.netPoints > 0
                      ? Colors.green
                      : sale.netPoints < 0
                      ? Colors.red
                      : Colors.grey,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: ResponsiveHelper.getMenuButtonIconSize(context) * 1.5,
            color: Colors.grey,
          ),
          ResponsiveHelper.verticalSpace(context, SpacingSize.medium),
          Text(
            'No hay ventas registradas',
            style: TextStyle(
              fontSize: ResponsiveHelper.getBodyFontSize(context),
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          ResponsiveHelper.verticalSpace(context, SpacingSize.small),
          Text(
            'Las ventas aparecerán aquí una vez registradas',
            style: TextStyle(
              fontSize: ResponsiveHelper.getCaptionFontSize(context),
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showSaleDetail(SaleModel sale) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle del modal
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Flexible(
              child: SingleChildScrollView(
                padding: ResponsiveHelper.getCardPadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveHelper.verticalSpace(context, SpacingSize.medium),

                    // Título
                    Text(
                      'Detalle de Venta',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getSubtitleFontSize(context),
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),

                    ResponsiveHelper.verticalSpace(context, SpacingSize.large),

                    // Detalles de la venta
                    _buildDetailRow('ID de Venta:', sale.id),
                    _buildDetailRow('Tarjeta:', sale.cardNumber),
                    _buildDetailRow('Fecha y Hora:', sale.formattedDateTime),
                    _buildDetailRow('Importe:', sale.formattedAmount),

                    if (sale.pointsAdded > 0)
                      _buildDetailRow(
                        'Puntos Sumados:',
                        '+${sale.pointsAdded}',
                        Colors.green,
                      ),

                    if (sale.pointsSubtracted > 0)
                      _buildDetailRow(
                        'Puntos Restados:',
                        '-${sale.pointsSubtracted}',
                        Colors.red,
                      ),

                    ResponsiveHelper.verticalSpace(context, SpacingSize.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, [Color? valueColor]) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveHelper.getSmallSpacing(context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getCaptionFontSize(context),
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveHelper.getCaptionFontSize(context),
                color: valueColor ?? AppTheme.textPrimary,
                fontWeight: valueColor != null
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
