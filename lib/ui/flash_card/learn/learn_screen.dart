import 'package:fluentzy/routing/paths.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/flash_card/learn/learn_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FlashCardLearnScreen extends StatelessWidget {
  const FlashCardLearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FlashCardLearnViewModel>();
    String cardContent =
        viewModel.isCardFlipped
            ? viewModel
                    .flashCardSet
                    ?.cards[viewModel.currentIndex]
                    .description ??
                ""
            : viewModel.flashCardSet?.cards[viewModel.currentIndex].word ?? "";
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () {
            viewModel.saveFlashCardSet();
            context.go(RoutePath.flashCardList);
          },
          icon: SvgPicture.asset("assets/back.svg"),
        ),
        titleSpacing: 0.0,
        title: const Text('Flash Card Learn'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              "${viewModel.currentIndex + 1} / ${viewModel.getTotalCards()}",
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${viewModel.getTotalCards() - viewModel.getLearnedCards()}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${viewModel.getLearnedCards()}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        viewModel.flipCard();
                      },
                      child: Container(
                        height: kIsWeb ? 400 : 240,
                        width: kIsWeb ? 700 : double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.secondary,
                              blurRadius: 8,
                              offset: Offset(2, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            cardContent,
                            style: TextStyle(
                              fontSize: viewModel.isCardFlipped ? 20 : 32,
                              fontWeight:
                                  viewModel.isCardFlipped
                                      ? FontWeight.normal
                                      : FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: kIsWeb ? 700 : double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton.filled(
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.surface,
                              shape: const CircleBorder(),
                              shadowColor: AppColors.secondary,
                              elevation: 4,
                            ),
                            color: AppColors.error,
                            onPressed: () {
                              viewModel.setCardLearned(false);
                              viewModel.nextCard();
                            },
                            iconSize: 32,
                            icon: Icon(Icons.close_rounded),
                          ),
                          IconButton(
                            onPressed: () {
                              viewModel.undoCard();
                              if (viewModel.currentIndex == 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("No more cards to undo"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            icon: Icon(Icons.undo_rounded),
                          ),
                          IconButton.filled(
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.surface,
                              shape: const CircleBorder(),
                              shadowColor: AppColors.secondary,
                              elevation: 4,
                            ),
                            color: AppColors.success,
                            onPressed: () {
                              viewModel.setCardLearned(true);
                              viewModel.nextCard();
                              if (viewModel.currentIndex ==
                                  viewModel.getTotalCards() - 1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("No more cards to learn"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            iconSize: 32,
                            icon: Icon(Icons.check_rounded),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
