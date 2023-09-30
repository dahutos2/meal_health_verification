import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../page/page.dart';
import '../../share/share.dart';

const _gap = 10.0;

enum TabType { page01, page02, page03 }

const pages = [
  Page01(),
  CameraPage(),
  Page03(),
];

final tabTypeProvider = StateProvider<TabType>((_) => TabType.page01);

class FooterView extends ConsumerWidget {
  const FooterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomAppBar(
      color: ColorType.footer.background,
      child: Row(
        children: [
          _buildBottomNavItem(0, IconType.footer.page01,
              L10n.of(context)!.page01FooterLabel, context, ref),
          _buildBottomNavItem(1, IconType.footer.page02,
              L10n.of(context)!.pageCameraFooterLabel, context, ref),
          _buildBottomNavItem(2, IconType.footer.page03,
              L10n.of(context)!.page03FooterLabel, context, ref),
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
                    ? ColorType.footer.item
                    : ColorType.footer.unselectedItem,
              ),
              if (tabType.state.index != index)
                Expanded(child: Text(label, style: StyleType.footer.label))
            ],
          ),
        ),
      ),
    );
  }
}
