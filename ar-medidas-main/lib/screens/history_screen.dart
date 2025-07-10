import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import '../models/measurement.dart';
import '../services/firebase_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  late List<Measurement> measurements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMeasurements();
  }

  Future<void> _loadMeasurements() async {
    setState(() => _isLoading = true);
    final result = await MeasurementFirebaseService.getAll();
    setState(() {
      measurements = result;
      _isLoading = false;
    });
  }

  void _deleteMeasurement(int index) async {
    final measurementToDelete = measurements[index];

    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        elevation: 4,
        shadowColor: Theme.of(context).brightness == Brightness.light
            ? Colors.black.withAlpha((0.2 * 255).toInt())
            : Colors.white.withAlpha((0.2 * 255).toInt()),
        insetPadding: EdgeInsets.all(17),
        title: Row(
          children: [
            AppStyles.warningIcon(context),
            SizedBox(width: AppStyles.spacingNormal),
            Text(
              "Excluir a Medida?",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        content: Text(
          "Essa ação não poderá ser desfeita!",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Tooltip(
                message: 'Cancelar a Exclusão',
                child: TextButton.icon(
                  icon: AppStyles.cancelIcon,
                  label: Text("Cancelar"),
                  onPressed: () => Navigator.pop(context, false),
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.light
                        ? AppColors.cornBase
                        : AppColors.cornShades[7],
                    shadowColor:
                        Theme.of(context).brightness == Brightness.light
                        ? Colors.black.withAlpha((0.2 * 255).toInt())
                        : Colors.white.withAlpha((0.2 * 255).toInt()),
                  ),
                ),
              ),
              const SizedBox(width: AppStyles.spacingNormal),
              Tooltip(
                message: 'Excluir Medida do Histórico',
                child: TextButton.icon(
                  icon: AppStyles.deleteIcon,
                  onPressed: () => Navigator.pop(context, true),
                  label: Text("Excluir"),
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.light
                        ? AppColors.bambooBase
                        : AppColors.oregonBase,
                    shadowColor:
                        Theme.of(context).brightness == Brightness.light
                        ? Colors.black.withAlpha((0.2 * 255).toInt())
                        : Colors.white.withAlpha((0.2 * 255).toInt()),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (confirm == true) {
      await MeasurementFirebaseService.removeMeasurement(measurementToDelete);
      setState(() {
        measurements.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Medida excluída com sucesso!"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _clearAllMeasurements() async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.all(17),
        title: Row(
          children: [
            AppStyles.warningIcon(context),
            SizedBox(width: AppStyles.spacingNormal),
            Text(
              "Limpar Histórico?",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        content: Text(
          "Isso apagará todo o histórico!\nEssa ação não poderá ser desfeita!",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Tooltip(
                message: 'Cancelar a Limpeza',
                child: TextButton.icon(
                  icon: AppStyles.cancelIcon,
                  onPressed: () => Navigator.pop(context, false),
                  label: Text("Cancelar"),
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.light
                        ? AppColors.cornBase
                        : AppColors.cornShades[7],
                    shadowColor:
                        Theme.of(context).brightness == Brightness.light
                        ? Colors.black.withAlpha((0.2 * 255).toInt())
                        : Colors.white.withAlpha((0.2 * 255).toInt()),
                  ),
                ),
              ),
              const SizedBox(width: AppStyles.spacingNormal),
              Tooltip(
                message: 'Limpar Todo o Histórico',
                child: TextButton.icon(
                  icon: AppStyles.deleteForeverIcon,
                  onPressed: () => Navigator.pop(context, true),
                  label: Text("Limpar"),
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.light
                        ? AppColors.bambooBase
                        : AppColors.oregonBase,
                    shadowColor:
                        Theme.of(context).brightness == Brightness.light
                        ? Colors.black.withAlpha((0.2 * 255).toInt())
                        : Colors.white.withAlpha((0.2 * 255).toInt()),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (confirm == true) {
      await MeasurementFirebaseService.clearAllMeasurements();
      setState(() {
        measurements.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Histórico limpo com sucesso!"),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(
                FeatherIcons.arrowLeft,
                size: screenWidth > 400 ? 38 : 32,
              ),
              tooltip: 'Retornar',
              onPressed: () => Navigator.pop(context),
            );
          },
        ),
        centerTitle: true,
        title: LayoutBuilder(
          builder: (context, constraints) {
            return Text(
              "Histórico de Medidas",
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
                fontSize: constraints.maxWidth > 260 ? 24 : 20,
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(FeatherIcons.trash2, size: screenWidth > 400 ? 38 : 32),
            tooltip: 'Limpar Todo o Histórico',
            onPressed: _clearAllMeasurements,
          ),
        ],
      ),

      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : measurements.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppStyles.infoIcon(context),
                  const SizedBox(height: AppStyles.spacingNormal),
                  Text(
                    "Nenhuma medida salva :(",
                    style: AppStyles.fadedText(context),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: AppStyles.paddingSmall,
              itemCount: measurements.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppStyles.spacingNormal),
              itemBuilder: (context, index) {
                final m = measurements[index];
                return AppStyles.materialCard(
                  context: context,
                  child: ListTile(
                    leading: AppStyles.avatar(
                      context: context,
                      child: AppStyles.straightenIcon(context),
                    ),
                    title: GestureDetector(
                      onLongPress: () {
                        Clipboard.setData(ClipboardData(text: m.totalDistance));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Distância copiada!"),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Text(
                        m.totalDistance,
                        style: AppStyles.listTileTitle(context),
                      ),
                    ),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(m.timestamp),
                      style: AppStyles.listTileSubtitle(context),
                    ),
                    trailing: Tooltip(
                      message: 'Excluir a Medida',
                      child: IconButton(
                        icon: AppStyles.deleteIcon,
                        onPressed: () => _deleteMeasurement(index),
                        color: Theme.of(context).brightness == Brightness.light
                            ? AppColors.bambooBase
                            : AppColors.oregonBase,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
