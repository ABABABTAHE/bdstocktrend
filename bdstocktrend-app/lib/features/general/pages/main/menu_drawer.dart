import 'package:bd_stock_trend/core/core.dart';
import 'package:bd_stock_trend/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({
    super.key,
    required this.dataMenu,
    required this.currentIndex,
    required this.onLogoutPressed,
  });

  final List<DataHelper> dataMenu;
  final Function(int) currentIndex;
  final VoidCallback onLogoutPressed;

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> with MainBoxMixin {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade50,
      child: Column(
        children: <Widget>[
          _buildHeader(context),
          const SpacerV(value: 8),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: Dimens.space16),
              children: widget.dataMenu.map<Widget>((menu) {
                final isSelected = menu.isSelected;
                return Container(
                  margin: EdgeInsets.only(bottom: Dimens.space8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Palette.primary.withOpacity(0.08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(Dimens.radiusLarge),
                  ),
                  child: ListTile(
                    dense: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimens.radiusLarge),
                    ),
                    minLeadingWidth: 20,
                    leading: Icon(
                      _getIconForMenu(menu.title),
                      size: 24,
                      color: isSelected ? Palette.primary : Palette.subText,
                    ),
                    title: Text(
                      menu.title ?? "-",
                      style: TextStyle(
                        color: isSelected ? Palette.primary : Palette.text,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      for (final m in widget.dataMenu) {
                        m.isSelected = m.title == menu.title;
                        if (m.title == menu.title) {
                          widget.currentIndex(widget.dataMenu.indexOf(m));
                        }
                      }
                      _selectedPage(menu.title!);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + Dimens.space24,
        bottom: Dimens.space24,
        left: Dimens.space24,
        right: Dimens.space24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Palette.primary, width: 2),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 28,
                  backgroundImage:
                      const NetworkImage("https://i.pravatar.cc/300"),
                  onBackgroundImageError: (_, __) => const Icon(Icons.person),
                  child: null,
                ),
              ),
              const SpacerH(value: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getData(MainBoxKeys.username) ?? "BDStockTrend",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Palette.text,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      getData(MainBoxKeys.email) ?? "user@example.com",
                      style: TextStyle(
                        color: Palette.subText,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Dimens.space24,
        0,
        Dimens.space24,
        MediaQuery.of(context).padding.bottom + Dimens.space24,
      ),
      child: InkWell(
        onTap: widget.onLogoutPressed,
        borderRadius: BorderRadius.circular(Dimens.radiusLarge),
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: Dimens.space12, horizontal: Dimens.space16),
          decoration: BoxDecoration(
            color: Palette.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(Dimens.radiusLarge),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout_rounded, color: Palette.error, size: 20),
              const SpacerH(value: 8),
              const Text(
                "Logout",
                style: TextStyle(
                  color: Palette.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForMenu(String? title) {
    if (title == Strings.of(context)!.dashboard) {
      return Icons.dashboard_rounded;
    } else if (title == Strings.of(context)!.companies) {
      return Icons.business_rounded;
    } else if (title == Strings.of(context)!.settings) {
      return Icons.settings_rounded;
    }
    return Icons.circle_outlined;
  }

  void _selectedPage(String title) {
    //Update page from selected Page
    if (title == Strings.of(context)!.settings) {
      context.goNamed(Routes.settings.name);
    } else if (title == Strings.of(context)!.companies) {
      context.goNamed(Routes.companies.name);
    } else if (title == Strings.of(context)!.dashboard) {
      context.goNamed(Routes.dashboard.name);
    } else if (title == Strings.of(context)!.logout) {
      widget.onLogoutPressed.call();
    }
  }
}
