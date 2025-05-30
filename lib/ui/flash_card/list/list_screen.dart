import 'package:fluentzy/routing/paths.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/flash_card/list/list_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FlashCardListScreen extends StatelessWidget {
  const FlashCardListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FlashCardListViewModel>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(RoutePath.home);
        }
      },
      child: LayoutBuilder(
        builder: (context, constraint) {
          final isMediumScreen =
              constraint.maxWidth > 600 && constraint.maxWidth < 840;
          final isMediumHighScreen =
              constraint.maxWidth >= 840 && constraint.maxWidth <= 1200;
          final isLargeScreen = constraint.maxWidth > 1200;
          int columnCount = 1;
          if (isLargeScreen) {
            columnCount = 4;
          } else if (isMediumHighScreen) {
            columnCount = 3;
          } else if (isMediumScreen) {
            columnCount = 2;
          }
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              surfaceTintColor: AppColors.onSecondary,
              backgroundColor: AppColors.background,
              leading: IconButton(
                onPressed: () => {context.go(RoutePath.home)},
                icon: SvgPicture.asset("assets/back.svg"),
              ),
              titleSpacing: 0.0,
              title: Text(AppLocalizations.of(context)!.sets),
              actions: [
                IconButton(
                  onPressed: () => {context.go(RoutePath.flashCardCreate)},
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            body: SafeArea(
              child: Builder(
                builder: (context) {
                  if (viewModel.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (viewModel.flashCardSets.isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.noFlashCardSetsAvailable,
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kIsWeb ? 8 : 0,
                    ),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columnCount,
                        crossAxisSpacing: 8,
                        childAspectRatio: 3.5, // Width/Height ratio
                      ),
                      itemCount: viewModel.flashCardSets.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap:
                              () => {
                                context.go(
                                  RoutePath.flashCardLearn,
                                  extra: viewModel.flashCardSets[index],
                                ),
                              },
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    context.go(
                                      RoutePath.flashCardEdit,
                                      extra: viewModel.flashCardSets[index],
                                    );
                                  },
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    viewModel.deleteFlashCardSet(
                                      viewModel.flashCardSets[index].id,
                                    );
                                  },
                                  backgroundColor: AppColors.error,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Container(
                              color:
                                  kIsWeb
                                      ? AppColors.surface
                                      : AppColors.background,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: 72,
                                      height: 72,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.primary,
                                          width: 3,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          (index + 1).toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Text(
                                          viewModel.flashCardSets[index].name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${viewModel.getLearnedCards(index)}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.success,
                                      ),
                                    ),
                                    Container(
                                      width: 2,
                                      height: 16,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      color: Colors.black,
                                    ),
                                    Text(
                                      "${viewModel.getTotalCards(index) - viewModel.getLearnedCards(index)}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.error,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
