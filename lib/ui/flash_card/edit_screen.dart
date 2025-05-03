import 'package:fluentzy/routing/paths.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:fluentzy/ui/flash_card/edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
          content: Text('At least one card is required.'),
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

  void showFlashCardSetNameDialog(
    BuildContext context,
    String name,
    Function(String) onSaved,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController setNameController = TextEditingController();
        setNameController.text = name; // Set the initial value

        return AlertDialog(
          title: const Text('Set Name'),
          titleTextStyle: TextStyle(color: AppColors.onSecondary, fontSize: 20),
          content: TextField(
            controller: setNameController,
            decoration: const InputDecoration(
              labelText: 'Flash card set name',
              labelStyle: TextStyle(color: AppColors.onSecondary),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.onSecondary, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.onSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                final setName = setNameController.text.trim();
                if (setName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Set name cannot be empty.'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }
                onSaved(setName); // Call the function passed from the parent
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Save',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FlashCardEditViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.isOperationSuccessful) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Flash card set saved successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go(RoutePath.flashCardList);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () => {context.go(RoutePath.flashCardList)},
          icon: SvgPicture.asset("assets/back.svg"),
        ),
        titleSpacing: 0.0,
        title: const Text('Flash Card Edit'),
        actions: [
          IconButton(
            onPressed: () {
              if (wordControllers[0].text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Please add at least one card.'),
                    backgroundColor: AppColors.error,
                  ),
                );
                return;
              }
              showFlashCardSetNameDialog(
                context,
                viewModel.flashCardSet?.name ?? '',
                (setName) {
                  viewModel.saveFlashCardSet(
                    setName: setName,
                    wordControllers: wordControllers,
                    descControllers: descControllers,
                  );
                },
              );
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
            itemCount: wordControllers.length + 1, // Add 1 for the Add button
            itemBuilder: (context, index) {
              if (index == wordControllers.length) {
                // This is the Add Button at the bottom
                return Center(
                  child: Container(
                    width: 600, // Set max width
                    margin: const EdgeInsets.only(top: 8),
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
                                'Please fill the word before adding a new card.',
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
                    margin: const EdgeInsets.symmetric(vertical: 8),
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
                                  '${index + 1}',
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
                          TextField(
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
                          SizedBox(height: 12),
                          TextField(
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
