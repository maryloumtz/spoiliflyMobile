import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/api_client.dart';
import 'package:flutter_application_1/src/core/models.dart';
import 'package:flutter_application_1/src/core/session_controller.dart';
import 'package:flutter_application_1/src/services/messages_service.dart';
import 'package:flutter_application_1/src/widgets/app_scaffold.dart';
import 'package:flutter_application_1/src/widgets/status_views.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({required this.sessionController, super.key});

  final SessionController sessionController;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final _recipientController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _selectedConversationId;
  bool _isSending = false;
  String? _sendError;

  @override
  void dispose() {
    _recipientController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<_MessagesPageData> _load() async {
    final service = MessagesService(widget.sessionController.apiClient);
    final accessToken = widget.sessionController.accessToken ?? '';
    final messagesFuture = service.fetchMessages(accessToken: accessToken);
    final usersFuture = service.fetchUsers(accessToken: accessToken);

    return _MessagesPageData(
      messages: await messagesFuture,
      users: await usersFuture,
    );
  }

  Future<void> _submit(MessagesService service) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSending = true;
      _sendError = null;
    });

    try {
      await service.sendMessage(
        accessToken: widget.sessionController.accessToken ?? '',
        recipientEmail: _recipientController.text.trim(),
        content: _contentController.text.trim(),
      );
      _contentController.clear();
      if (mounted) {
        setState(() {});
      }
    } on ApiException catch (error) {
      setState(() {
        _sendError = error.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = MessagesService(widget.sessionController.apiClient);

    return AppScaffold(
      title: 'Chat',
      subtitle: 'Conversations privées et envoi de nouveaux messages.',
      child: FutureBuilder<_MessagesPageData>(
        future: _load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          if (snapshot.hasError) {
            return ErrorView(error: '${snapshot.error}');
          }

          final pageData = snapshot.data!;
          final messagesData = pageData.messages;
          final selectedConversationId =
              _selectedConversationId ??
              messagesData.conversations.firstOrNull?.id;
          final selectedMessages = messagesData.messages
              .where((entry) => entry.conversationId == selectedConversationId)
              .toList();

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;

              final conversationsPanel = _ConversationsPanel(
                conversations: messagesData.conversations,
                selectedConversationId: selectedConversationId,
                onSelect: (conversationId) {
                  setState(() {
                    _selectedConversationId = conversationId;
                  });
                },
              );

              final contentPanel = _MessagesContentPanel(
                formKey: _formKey,
                recipientController: _recipientController,
                contentController: _contentController,
                isSending: _isSending,
                sendError: _sendError,
                selectedMessages: selectedMessages,
                users: pageData.users,
                currentUserId: widget.sessionController.user?.id,
                onSubmit: () => _submit(service),
                useExpandedMessages: isWide,
              );

              if (isWide) {
                return Row(
                  children: [
                    SizedBox(width: 320, child: conversationsPanel),
                    const SizedBox(width: 16),
                    Expanded(child: contentPanel),
                  ],
                );
              }

              return ListView(
                children: [
                  SizedBox(height: 260, child: conversationsPanel),
                  const SizedBox(height: 16),
                  contentPanel,
                  const SizedBox(height: 24),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _MessagesPageData {
  _MessagesPageData({required this.messages, required this.users});

  final MessagesPayload messages;
  final List<UserDirectoryItem> users;
}

class _ConversationsPanel extends StatelessWidget {
  const _ConversationsPanel({
    required this.conversations,
    required this.selectedConversationId,
    required this.onSelect,
  });

  final List<ConversationView> conversations;
  final String? selectedConversationId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    if (conversations.isEmpty) {
      return const EmptyView(message: 'Aucune conversation pour le moment.');
    }

    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        final isSelected = conversation.id == selectedConversationId;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.16)
              : null,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(conversation.title),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                conversation.lastMessage?.content ?? 'Aucun message',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            onTap: () => onSelect(conversation.id),
          ),
        );
      },
    );
  }
}

class _UserSearchField extends StatefulWidget {
  const _UserSearchField({required this.controller, required this.users});

  final TextEditingController controller;
  final List<UserDirectoryItem> users;

  @override
  State<_UserSearchField> createState() => _UserSearchFieldState();
}

class _UserSearchFieldState extends State<_UserSearchField> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<UserDirectoryItem>(
      textEditingController: widget.controller,
      focusNode: _focusNode,
      displayStringForOption: (option) => option.email,
      optionsBuilder: (value) {
        final query = value.text.trim().toLowerCase();
        if (query.isEmpty) {
          return widget.users.take(8);
        }

        return widget.users
            .where((user) {
              return user.email.toLowerCase().contains(query) ||
                  user.displayName.toLowerCase().contains(query);
            })
            .take(8);
      },
      onSelected: (user) {
        widget.controller.text = user.email;
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: const InputDecoration(
                labelText: 'Destinataire',
                hintText: 'Recherche un utilisateur',
                prefixIcon: Icon(Icons.search_rounded),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return 'Email invalide';
                }
                return null;
              },
            );
          },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surface,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 260, maxWidth: 420),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final user = options.elementAt(index);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.avatarUrl == null
                          ? null
                          : NetworkImage(user.avatarUrl!),
                      child: user.avatarUrl == null
                          ? Text(user.displayName.substring(0, 1))
                          : null,
                    ),
                    title: Text(user.displayName),
                    subtitle: Text(user.email),
                    onTap: () => onSelected(user),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MessagesContentPanel extends StatelessWidget {
  const _MessagesContentPanel({
    required this.formKey,
    required this.recipientController,
    required this.contentController,
    required this.isSending,
    required this.sendError,
    required this.selectedMessages,
    required this.users,
    required this.currentUserId,
    required this.onSubmit,
    required this.useExpandedMessages,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController recipientController;
  final TextEditingController contentController;
  final bool isSending;
  final String? sendError;
  final List<ChatMessage> selectedMessages;
  final List<UserDirectoryItem> users;
  final String? currentUserId;
  final VoidCallback onSubmit;
  final bool useExpandedMessages;

  @override
  Widget build(BuildContext context) {
    final composerCard = Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nouveau message',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              _UserSearchField(
                controller: recipientController,
                users: users
                    .where((entry) => entry.id != currentUserId)
                    .toList(),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: contentController,
                minLines: 4,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  hintText: 'Écris ton message...',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 64),
                    child: Icon(Icons.chat_bubble_outline_rounded),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Message requis';
                  }
                  return null;
                },
              ),
              if (sendError != null) ...[
                const SizedBox(height: 12),
                Text(
                  sendError!,
                  style: const TextStyle(color: Color(0xFFFFC5C5)),
                ),
              ],
              const SizedBox(height: 14),
              FilledButton(
                onPressed: isSending ? null : onSubmit,
                child: Text(isSending ? 'Envoi...' : 'Envoyer'),
              ),
            ],
          ),
        ),
      ),
    );

    final threadCard = Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: selectedMessages.isEmpty
            ? const EmptyView(
                message:
                    'Sélectionne une conversation ou envoie un premier message.',
              )
            : ListView.builder(
                shrinkWrap: !useExpandedMessages,
                physics: useExpandedMessages
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                itemCount: selectedMessages.length,
                itemBuilder: (context, index) {
                  final message = selectedMessages[index];
                  final isMine = message.senderUserId == currentUserId;

                  return Align(
                    alignment: isMine
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      constraints: const BoxConstraints(maxWidth: 420),
                      decoration: BoxDecoration(
                        color: isMine
                            ? Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.18)
                            : Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(message.content),
                          const SizedBox(height: 8),
                          Text(
                            message.createdAt,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.52),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );

    if (useExpandedMessages) {
      return Column(
        children: [
          composerCard,
          const SizedBox(height: 16),
          Expanded(child: threadCard),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [composerCard, const SizedBox(height: 16), threadCard],
    );
  }
}
