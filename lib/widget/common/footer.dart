import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../page/page.dart';
import '../../share/share.dart';

const _gap = 10.0;

enum TabType { home, camera, confirm }

const pages = [
  HomePage(),
  CameraPage(),
  DataConfirm(),
];

final tabTypeProvider = StateProvider<TabType>((_) => TabType.home);

class FooterView extends ConsumerWidget {
  const FooterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomAppBar(
      color: ColorType.footer.background,
      child: Row(
        children: [
          _buildBottomNavItem(0, IconType.footer.home,
              L10n.of(context)!.homePageFooterLabel, context, ref),
          _buildBottomNavItem(1, IconType.footer.camera,
              L10n.of(context)!.pageCameraFooterLabel, context, ref),
          _buildBottomNavItem(2, IconType.footer.confirm,
              L10n.of(context)!.dataConfirmLabel, context, ref),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(
      int index, Icon icon, String label, BuildContext context, WidgetRef ref) {
    final tabType = ref.watch(tabTypeProvider.notifier);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: _gap),
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            tabType.state = TabType.values[index];
            Navigator.of(context).pushAndRemoveUntil<void>(
                RouteType.fadeIn(nextPage: pages[index]), (_) => false);
          },
          icon: Column(
            children: [
              Icon(
                icon.icon,
                color: tabType.state.index != index
                    ? ColorType.footer.unSelectedItem
                    : ColorType.footer.selectedItem,
              ),
              Expanded(
                child: Text(label,
                    style: tabType.state.index != index
                        ? StyleType.footer.unSelectedLabel
                        : StyleType.footer.selectedLabel),
              )
            ],
          ),
        ),
      ),
    );
  }
}
