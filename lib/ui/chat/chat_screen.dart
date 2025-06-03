import 'package:fluentzy/data/models/chat_message.dart';
import 'package:fluentzy/ui/chat/chat_view_model.dart';
import 'package:fluentzy/ui/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessage(ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: msg.isUser ? AppColors.surfacePrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(msg.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ChatViewModel viewModel = context.watch<ChatViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      resizeToAvoidBottomInset: true, // Important
      appBar: AppBar(
        surfaceTintColor: AppColors.onSecondary,
        title: Text(AppLocalizations.of(context)!.chat),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: AppColors.surface,
                    title: Text(AppLocalizations.of(context)!.confirmClearChat),
                    content: Text(
                      AppLocalizations.of(context)!.areYouSureClearChat,
                    ),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.onSecondary,
                        ),
                        onPressed: () {
                          context.pop();
                        },
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          context.pop();
                          viewModel.clearMessages();
                        },
                        child: Text(AppLocalizations.of(context)!.clear),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 800,
            child: Column(
              children: [
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (viewModel.messages.isEmpty) {
                        return Center(
                          child: Text(
                            AppLocalizations.of(context)!.startChatNow,
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      }
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8),
                        itemCount: viewModel.messages.length + 1,
                        itemBuilder: (context, index) {
                          if (index == viewModel.messages.length) {
                            return viewModel.isThinking
                                ? const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: CircularProgressIndicator(
                                      color: AppColors.onSecondary,
                                    ),
                                  ),
                                )
                                : const SizedBox.shrink();
                          }
                          return _buildMessage(viewModel.messages[index]);
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    8,
                    8,
                    8,
                    MediaQuery.of(context).viewInsets.bottom +
                        8, // keyboard height
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: TextField(
                            cursorColor: AppColors.primary,
                            controller: _controller,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.border,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(36),
                                borderSide: BorderSide.none, // No border line
                              ),
                              contentPadding: EdgeInsets.all(12),
                              hintText:
                                  AppLocalizations.of(context)!.typeQuestion,
                            ),
                            onSubmitted: (_) {
                              viewModel.addMessage(text: _controller.text);
                              _controller.clear();
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            AppColors.primary,
                          ),
                          shape: WidgetStatePropertyAll(CircleBorder()),
                        ),
                        color: Colors.white,
                        icon: const Icon(Icons.arrow_upward_rounded),
                        onPressed: () {
                          if (_controller.text.isEmpty || viewModel.isThinking)
                            return;
                          viewModel.addMessage(text: _controller.text);
                          _controller.clear();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
