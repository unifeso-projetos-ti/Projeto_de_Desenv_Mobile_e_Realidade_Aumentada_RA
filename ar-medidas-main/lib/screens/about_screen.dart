import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String appName = "AR Medidas";
  String version = "Desconhecida";

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        version = "${info.version}+${info.buildNumber}";
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Sobre o App',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
          ),
        ),
        leading: IconButton(
          icon: AppStyles.backIcon,
          tooltip: 'Voltar',
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: AppStyles.paddingBig,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                elevation: 4,
                shape: CircleBorder(),
                shadowColor: Theme.of(context).brightness == Brightness.light
                    ? Colors.black.withAlpha((0.2 * 255).toInt())
                    : Colors.white.withAlpha((0.2 * 255).toInt()),
                child: ClipOval(
                  child: Image.asset(
                    'assets/Image.png',
                    width: 125,
                    height: 125,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: AppStyles.spacingMedium),
              Text(
                'AR Medidas',
                style: AppStyles.listTileTitle(context).copyWith(fontSize: 18),
              ),
              const SizedBox(height: AppStyles.spacingNormal),
              Text(
                'Versão: $version',
                style: AppStyles.listTileTitle(context).copyWith(fontSize: 18),
              ),
              const SizedBox(height: AppStyles.spacingLarge),
              Text(
                'Este aplicativo utiliza realidade aumentada para ajudar você a fazer medições espaciais precisas em tempo real. Foi desenvolvido como parte de um projeto de estudo, com foco em acessibilidade e simplicidade.',
                style: AppStyles.listTileTitle(context).copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppStyles.spacingLarge),
              Tooltip(
                message: 'Voltar para a tela inicial',
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(FeatherIcons.arrowLeft, size: 30),
                  label: const Text("Voltar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.light
                        ? AppColors.bambooBase
                        : AppColors.oregonBase,
                    textStyle: AppStyles.buttonText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
