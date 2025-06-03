import 'dart:ui';

import 'package:fluentzy/routing/paths.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/flash_card/edit/edit_view_model.dart';
import 'package:fluentzy/extensions/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FlashCardEditScreen extends StatefulWidget {
  const FlashCardEditScreen({super.key});

  @override
  State<FlashCardEditScreen> createState() => _FlashCardEditScreenState();
}

class _FlashCardEditScreenState extends State<FlashCardEditScreen> {
  List<TextEditingController> wordControllers = [];
  List<TextEditingController> descControllers = [];

  @override
  void initState() {
    super.initState();
    final flashCardSet = context.read<FlashCardEditViewModel>().flashCardSet;

    if (flashCardSet != null) {
      for (var card in flashCardSet.cards) {
        wordControllers.add(TextEditingController(text: card.word));
        descControllers.add(TextEditingController(text: card.description));
      }
    } else {
      _addCard(); // Add an empty card for creation mode
    } // Add initial empty card
  }

  @override
  void dispose() {
    // Always dispose controllers!
    for (var c in wordControllers) {
      c.dispose();
    }
    for (var c in descControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addCard() {
    setState(() {
      wordControllers.add(TextEditingController());
      descControllers.add(TextEditingController());
    });
  }

  void _removeCard(int index) {
    if (wordControllers.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.atLeastOneCardRequired),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    setState(() {
      wordControllers[index].dispose();
      descControllers[index].dispose();
      wordControllers.removeAt(index);
      descControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FlashCardEditViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.isOperationSuccessful) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.flashCardSetSavedSuccessfully,
            ),
            backgroundColor: AppColors.success,
          ),
        );
        context.go(RoutePath.flashCardList);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.isAiGenerating) {
        context.showLoadingDialog();
      } else {
        context.hideLoadingDialog();
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(RoutePath.flashCardList);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          surfaceTintColor: AppColors.onSecondary,
          backgroundColor: AppColors.background,
          leading: IconButton(
            onPressed: () => {context.go(RoutePath.flashCardList)},
            icon: SvgPicture.asset("assets/back.svg"),
          ),
          titleSpacing: 0.0,
          title: Text(AppLocalizations.of(context)!.flashCardEdit),
          actions: [
            if (viewModel.flashCardSet == null)
              IconButton(
                onPressed: () {
                  context.showInputDialog(
                    title: AppLocalizations.of(context)!.giveTopicForAi,
                    labelText: AppLocalizations.of(context)!.topic,
                    onSaved: (topic) async {
                      final suggestedCards = await viewModel
                          .generateFlashCardsByAi(topic: topic);
                      if (suggestedCards.isNotEmpty) {
                        setState(() {
                          wordControllers.clear();
                          descControllers.clear();
                          for (var card in suggestedCards) {
                            wordControllers.add(
                              TextEditingController(text: card.word),
                            );
                            descControllers.add(
                              TextEditingController(text: card.description),
                            );
                          }
                        });
                      }
                    },
                  );
                },
                icon: Icon(Icons.auto_awesome_rounded),
              ),
            IconButton(
              onPressed: () {
                if (wordControllers[0].text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.pleaseAddAtLeastOneCard,
                      ),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }
                context.showInputDialog(
                  title: AppLocalizations.of(context)!.setName,
                  labelText: AppLocalizations.of(context)!.name,
                  initValue: viewModel.flashCardSet?.name ?? '',
                  onSaved: (name) async {
                    viewModel.saveFlashCardSet(
                      setName: name,
                      wordControllers: wordControllers,
                      descControllers: descControllers,
                    );
                  },
                );
              },
              icon: const Icon(Icons.check_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: wordControllers.length + 1, // Add 1 for the Add button
            itemBuilder: (context, index) {
              if (index == wordControllers.length) {
                // This is the Add Button at the bottom
                return Center(
                  child: Container(
                    width: 600,
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary,
                          blurRadius: 4,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton.filled(
                      onPressed: () {
                        final lastWord = wordControllers.last.text.trim();
                        if (lastWord.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(
                                  context,
                                )!.pleaseFillWordBeforeAdding,
                              ),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }
                        _addCard();
                      },
                      icon: Icon(Icons.add),
                      iconSize: 32,
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          AppColors.surface,
                        ),
                        foregroundColor: WidgetStatePropertyAll(Colors.black),
                      ),
                    ),
                  ),
                );
              }

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600), // Set max width
                  child: Card(
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                    color: AppColors.onSecondary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => _removeCard(index),
                                icon: Icon(Icons.remove_circle_outline),
                                color: AppColors.error,
                              ),
                            ],
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              textSelectionTheme: TextSelectionThemeData(
                                selectionColor: AppColors.primary.withAlpha(
                                  (0.2 * 255).toInt(),
                                ),
                                cursorColor: AppColors.primary,
                              ),
                            ),
                            child: TextField(
                              controller: wordControllers[index],
                              style: TextStyle(color: AppColors.onSecondary),
                              decoration: InputDecoration(
                                labelText: 'Word',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.onSecondary,
                                    width: 2,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  color: AppColors.onSecondary,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Theme(
                            data: Theme.of(context).copyWith(
                              textSelectionTheme: TextSelectionThemeData(
                                selectionColor: AppColors.primary.withAlpha(
                                  (0.2 * 255).toInt(),
                                ),
                                cursorColor: AppColors.primary,
                              ),
                            ),
                            child: TextField(
                              controller: descControllers[index],
                              style: TextStyle(color: AppColors.onSecondary),
                              decoration: InputDecoration(
                                labelText: 'Description',
                                labelStyle: TextStyle(
                                  color: AppColors.onSecondary,
                                ),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.onSecondary,
                                    width: 2,
                                  ),
                                ),
                              ),
                              maxLines: 2,
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
        ),
      ),
    );
  }
}
