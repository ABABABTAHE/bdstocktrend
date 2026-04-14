import 'package:bd_stock_trend/core/core.dart';
import 'package:bd_stock_trend/features/features.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';


class CompanyListPage extends StatefulWidget {
  const CompanyListPage({super.key});

  @override
  State<CompanyListPage> createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyListPage> {
  final int _currentPage = 1;
  List<Company> _companies = [];
  final List<Company> _filteredItems = [];
  String noLogo =
      "https://image.spreadshirtmedia.net/image-server/v1/products/T1459A839PA4459PT28D11017255W10000H5096/views/1,width=550,height=550,appearanceId=839,backgroundColor=F2F2F2/no-logo-sticker.jpg";

  @override
  void initState() {
    super.initState();
    context
        .read<CompanyListCubit>()
        .fetchCompanies(UsersParams(page: _currentPage));

    context.read<CompanyListCubit>().stream.listen((state) {
      setState(() {
        state.maybeWhen(
          success: (data) => {
            _companies = data.companies ?? [],
            _filteredItems.addAll(_companies),
          },
          orElse: () {},
        );
      });
    });
  }

  // Function to handle filtering the list based on search input
  void _filterList(String query) {
    setState(() {
      _filteredItems.clear();
      if (query.isEmpty) {
        _filteredItems.addAll(_companies);
      } else {
        _filteredItems.addAll(_companies
            .where((item) =>
                item.name!.toLowerCase().contains(query.toLowerCase()) ||
                item.code!.toLowerCase().contains(query.toLowerCase()))
            .toList());
      }
      print('Size ${_filteredItems.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Parent(
      child: BlocBuilder<CompanyListCubit, CompanyListState>(
        builder: (_, state) {
          return state.when(
            loading: () => const Center(child: Loading()),
            success: (data) {
              return Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: EdgeInsets.all(Dimens.space16),
                    child: TextField(
                      onChanged: (query) => _filterList(query),
                      decoration: InputDecoration(
                        hintText: 'Search by name or code...',
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: Dimens.space16,
                          vertical: Dimens.space12,
                        ),
                      ),
                    ),
                  ),

                  // Company List
                  Expanded(
                    child: _filteredItems.isNotEmpty
                        ? ListView.builder(
                            itemCount: _filteredItems.length,
                            padding: EdgeInsets.fromLTRB(
                              Dimens.space16,
                              0,
                              Dimens.space16,
                              Dimens.space16,
                            ),
                            itemBuilder: (context, index) {
                              final company = _filteredItems[index];
                              return Padding(
                                padding:
                                    EdgeInsets.only(bottom: Dimens.space12),
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () {
                                      context.pushNamed(
                                        Routes.companyDetails.name,
                                        pathParameters: {
                                          'code': company.code ?? '',
                                        },
                                      ).then((value) => context
                                          .read<MainCubit>()
                                          .updateIndex(1));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(Dimens.space12),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 56.r,
                                            height: 56.r,
                                            decoration: BoxDecoration(
                                              color: Palette.background,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.radiusSmall),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.radiusSmall),
                                              child: CachedNetworkImage(
                                                imageUrl: company.logo ?? "",
                                                fit: BoxFit.contain,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CupertinoActivityIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.network(
                                                  noLogo,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SpacerH(value: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  company.code ?? "-",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                Text(
                                                  company.name ?? "-",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: Palette.subText,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color: Palette.subText
                                                .withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off_rounded,
                                    size: 64,
                                    color: Palette.subText.withOpacity(0.5)),
                                const SpacerV(value: 12),
                                Text(
                                  'No companies found',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Palette.subText,
                                      ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              );
            },
            failure: (message) => Center(child: Empty(errorMessage: message)),
            empty: () => const Center(child: Empty()),
          );
        },
      ),
    );
  }

  String getDomain(String? website) {
    final String domain = website ?? "";

    final int dotIndex = domain.indexOf('.');

    // Check if '.' exists in the string
    if (dotIndex != -1) {
      // Get the substring after the first '.' occurrence
      String substringAfterDot = domain.substring(dotIndex + 1);

      //remove last '/'
      if (substringAfterDot.contains('/')) {
        final int slashIndex = substringAfterDot.indexOf('/');
        substringAfterDot = substringAfterDot.substring(0, slashIndex);
      }

      return "https://logo.clearbit.com/$substringAfterDot";
    } else {
      return noLogo;
    }
  }
}
