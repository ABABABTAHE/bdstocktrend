import 'package:bd_stock_trend/core/core.dart';
import 'package:bd_stock_trend/features/features.dart';
import 'package:bd_stock_trend/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with MainBoxMixin {
  late final List<DataHelper> _listLanguage = [
    DataHelper(title: Constants.get.english, type: "en"),
    DataHelper(title: Constants.get.bahasa, type: "id"),
  ];

  @override
  Widget build(BuildContext context) {
    return Parent(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Dimens.space16),
          child: Column(
            children: [
              BlocBuilder<SettingsCubit, DataHelper>(
                builder: (context, state) {
                  return Column(
                    children: [
                      DropDown<ActiveTheme>(
                        key: const Key("dropdown_theme"),
                        hint: Strings.of(context)!.chooseTheme,
                        value: state.activeTheme,
                        prefixIcon: const Icon(Icons.light),
                        items: ActiveTheme.values
                            .map(
                              (data) => DropdownMenuItem(
                                value: data,
                                child: Text(
                                  _getThemeName(data, context),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          /// Reload theme
                          context
                              .read<SettingsCubit>()
                              .updateTheme(value ?? ActiveTheme.system);
                        },
                      ),

                      /// Language
                      DropDown<DataHelper>(
                        key: const Key("dropdown_language"),
                        hint: Strings.of(context)!.chooseLanguage,
                        value: _listLanguage.firstWhere(
                          (element) => element.type == (state.type ?? "en"),
                          orElse: () => _listLanguage[0],
                        ),
                        prefixIcon: const Icon(Icons.language_outlined),
                        items: _listLanguage
                            .map(
                              (data) => DropdownMenuItem(
                                value: data,
                                child: Text(
                                  data.title ?? "-",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (DataHelper? value) async {
                          /// Reload theme
                          if (!mounted) return;
                          context
                              .read<SettingsCubit>()
                              .updateLanguage(value?.type ?? "en");
                        },
                      ),
                    ],
                  );
                },
              ),
              const SpacerV(value: 24),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text("Edit Profile"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  context.pushNamed(Routes.editProfile.name);
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text("Change Password"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  context.pushNamed(Routes.changePassword.name);
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment_outlined),
                title: const Text("Payment Subscription"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  context.pushNamed(Routes.payment.name);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getThemeName(ActiveTheme activeTheme, BuildContext context) {
    if (activeTheme == ActiveTheme.system) {
      return Strings.of(context)!.themeSystem;
    } else if (activeTheme == ActiveTheme.dark) {
      return Strings.of(context)!.themeDark;
    } else {
      return Strings.of(context)!.themeLight;
    }
  }
}
