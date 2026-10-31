import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/widgets.dart';
import '../../data/models/catalog.dart';
import '../../data/models/chat.dart';
import '../../data/models/user.dart';
import '../../data/repositories/repositories.dart';
import '../../state/app_controllers.dart';
import '../../state/session_controller.dart';
import 'widgets/chat_app_bar.dart';
import 'widgets/chat_composer.dart';
import 'widgets/chat_message_list.dart';
import 'widgets/chat_sheets.dart';
import 'widgets/forward_sheet.dart';
import 'widgets/inbox_common.dart';
import 'widgets/message_widgets.dart';
import 'widgets/quick_responses.dart';

/// Màn hình trò chuyện với một đối tác.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.conversationId});
  final String conversationId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _focus = FocusNode();

  bool _started = false;
  bool _loading = true;
  Object? _error;
  List<ChatMessage> _messages = [];
  AppUser? _other;
  String? _otherId;
  final Map<String, Gig?> _gigs = {};
  final Set<String> _declinedCalls = {};
  ChatMessage? _replyTo;
  String? _pendingGigId;
  bool _showDown = false;
  bool _sending = false;

  Timer? _replyTimer;
  bool _autoReplied = false;
  bool _typing = false;

  String get _id => widget.conversationId;
  String _me = '';

  @override
  void initState() {
    super.initState();
    _input.addListener(() => setState(() {}));
    _scroll.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _me = context.read<SessionController>().userId;
    try {
      _pendingGigId = GoRouterState.of(context).uri.queryParameters['gig'];
    } catch (_) {
      _pendingGigId = null;
    }
    _load();
  }

  @override
  void dispose() {
    _replyTimer?.cancel();
    _input.dispose();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------ dữ liệu
  Future<void> _load() async {
    final inbox = context.read<InboxController>();
    final catalog = context.read<CatalogRepository>();
    final me = _me;
    try {
      final msgs = await inbox.messages(_id);
      String? otherId = inbox.byId(_id)?.participantId;
      otherId ??= msgs.where((m) => m.senderId != me).firstOrNull?.senderId;
      final other = otherId == null ? null : await catalog.userById(otherId);
      await _fetchGigs(msgs);
      if (!mounted) return;
      setState(() {
        _messages = msgs;
        _otherId = otherId;
        _other = other;
        _loading = false;
      });
      inbox.markRead(_id);
      _scrollToEnd(animate: false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  Future<void> _fetchGigs(List<ChatMessage> msgs) async {
    final catalog = context.read<CatalogRepository>();
    final ids = <String>{
      for (final m in msgs) ...[?m.relatedGigId, ?m.offer?.gigId],
      ?_pendingGigId,
    }.where((id) => !_gigs.containsKey(id));
    for (final id in ids) {
      _gigs[id] = await catalog.gigById(id);
    }
  }

  Future<void> _reload() async {
    final msgs = await context.read<InboxController>().messages(_id);
    await _fetchGigs(msgs);
    if (!mounted) return;
    setState(() => _messages = msgs);
  }

  // ------------------------------------------------------------ cuộn
  void _onScroll() {
    if (!_scroll.hasClients) return;
    final away = _scroll.position.maxScrollExtent - _scroll.offset > 240;
    if (away != _showDown) setState(() => _showDown = away);
  }

  void _scrollToEnd({bool animate = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      final max = _scroll.position.maxScrollExtent;
      if (animate) {
        _scroll.animateTo(max, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      } else {
        _scroll.jumpTo(max);
      }
    });
  }

  // ------------------------------------------------------------ gửi
  ChatMessage _draft({
    MessageType type = MessageType.text,
    String text = '',
    String? fileName,
    String? fileSize,
    String? replyTo,
    String? gigId,
  }) => ChatMessage(
    id: '',
    conversationId: _id,
    senderId: _me,
    sentAt: DateTime.now(),
    type: type,
    text: text,
    fileName: fileName,
    fileSize: fileSize,
    replyTo: replyTo,
    relatedGigId: gigId,
  );

  Future<void> _sendMessage(ChatMessage draft) async {
    final inbox = context.read<InboxController>();
    setState(() => _sending = true);
    try {
      final sent = await inbox.send(draft);
      if (!mounted) return;
      setState(() {
        _messages = [..._messages, sent];
        _sending = false;
      });
      _scrollToEnd();
      _scheduleAutoReply();
    } catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      showAppSnack(context, context.l10n.inboxSendFailed, success: false);
    }
  }

  Future<void> _sendText() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending) return;
    final reply = _replyTo;
    final gig = _pendingGigId;
    _input.clear();
    setState(() {
      _replyTo = null;
      _pendingGigId = null;
    });
    final quote = reply == null ? null : '${_senderName(reply)}: ${_plain(reply)}';
    await _sendMessage(_draft(text: text, replyTo: quote, gigId: gig));
  }

  void _scheduleAutoReply() {
    final other = _otherId;
    final conv = context.read<InboxController>().byId(_id);
    if (_autoReplied || other == null || (conv?.blocked ?? false)) return;
    _autoReplied = true;
    setState(() => _typing = true);
    _replyTimer = Timer(const Duration(milliseconds: 1500), () async {
      if (!mounted) return;
      final inbox = context.read<InboxController>();
      final text = context.l10n.inboxAutoReply;
      final sent = await inbox.send(
        ChatMessage(id: '', conversationId: _id, senderId: other, sentAt: DateTime.now(), text: text),
      );
      if (!mounted) return;
      setState(() {
        _typing = false;
        _messages = [..._messages, sent];
      });
      _scrollToEnd();
    });
  }

  String _senderName(ChatMessage m) =>
      m.senderId == _me ? context.l10n.inboxYou : (_other?.displayName ?? context.l10n.inboxUser);

  String _plain(ChatMessage m) => messagePlainText(context.l10n, m);

  // ------------------------------------------------------------ hành động
  Future<void> _openAttach() async {
    final action = await showAttachSheet(context, seller: context.read<SessionController>().sellerMode);
    if (action == null || !mounted) return;
    final now = DateTime.now();
    ChatMessage file(String name, String size) => _draft(type: MessageType.file, fileName: name, fileSize: size);
    switch (action) {
      case 'album':
        await _sendMessage(file('IMG_${now.millisecondsSinceEpoch % 10000}.jpg', '1,8 MB'));
      case 'camera':
        await _sendMessage(file('Anh-chup-${Fmt.time(now).replaceAll(':', 'h')}.jpg', '2,4 MB'));
      case 'file':
        await _sendMessage(file('Tai-lieu-du-an.pdf', '245 KB'));
      case 'offer':
        await context.push('/chat/$_id/offer/new');
        if (!mounted) return;
        await _reload();
        _scrollToEnd();
      case 'quick':
        await _pickQuick();
      case 'video':
        await _sendMessage(_draft(type: MessageType.videoCall, text: context.l10n.inboxVideoInviteText));
    }
  }

  Future<void> _pickQuick() async {
    final body = await showQuickResponses(context);
    if (body == null || !mounted) return;
    final name = _other?.displayName ?? context.l10n.inboxQuickFallbackName;
    final text = body.replaceAll('{username}', name);
    _input.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    _focus.requestFocus();
  }

  Future<void> _onLongPress(ChatMessage m) async {
    final action = await showMessageActions(context, canCopy: _plain(m).trim().isNotEmpty);
    if (action == null || !mounted) return;
    switch (action) {
      case 'reply':
        setState(() => _replyTo = m);
        _focus.requestFocus();
      case 'forward':
        final ids = await showForwardSheet(context, preview: _plain(m), excludeConversationId: _id);
        if (ids == null || ids.isEmpty || !mounted) return;
        await forwardMessage(context, m: m, plain: _plain(m), ids: ids, senderId: _me);
      case 'copy':
        await Clipboard.setData(ClipboardData(text: _plain(m)));
        if (mounted) showAppSnack(context, context.l10n.inboxCopied);
    }
  }

  Future<void> _viewOffer(ChatMessage m) async {
    await context.push('/chat/$_id/offer/${m.id}');
    if (mounted) await _reload();
  }

  Future<void> _setOfferStatus(ChatMessage m, OfferStatus status) async {
    final l = context.l10n;
    final withdraw = status == OfferStatus.withdrawn;
    final ok = await confirmOfferStatus(context, withdraw: withdraw);
    if (!ok || !mounted) return;
    await context.read<InboxController>().updateOffer(m.id, status);
    await _reload();
    if (mounted) showAppSnack(context, withdraw ? l.inboxOfferWithdrawn : l.inboxOfferDeclined);
  }

  void _openOrders() =>
      showActiveOrdersSheet(context, partnerId: _otherId, name: _other?.displayName ?? context.l10n.inboxThisPartner);

  // ------------------------------------------------------------ build
  @override
  Widget build(BuildContext context) {
    final conv = context.watch<InboxController>().byId(_id);
    final meUser = context.watch<SessionController>().user;
    _me = meUser?.id ?? _me;
    return Scaffold(
      appBar: ChatAppBar(
        other: _other,
        onOrders: _otherId == null ? null : _openOrders,
        onMenu: conv == null ? null : () => showChatMenu(context, conv),
      ),
      body: _buildBody(conv, meUser),
    );
  }

  Widget _buildBody(Conversation? conv, AppUser? meUser) {
    final l = context.l10n;
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return EmptyState(
        icon: Icons.error_outline_rounded,
        title: l.inboxLoadFailed,
        message: '$_error',
        actionLabel: l.commonRetry,
        onAction: () {
          setState(() {
            _loading = true;
            _error = null;
          });
          _load();
        },
      );
    }
    if (conv == null && _messages.isEmpty && _otherId == null) {
      return EmptyState(icon: Icons.forum_outlined, title: l.inboxNotFoundTitle, message: l.inboxNotFoundMessage);
    }
    final reply = _replyTo;
    return Column(
      children: [
        Expanded(
          child: ChatMessageList(
            controller: _scroll,
            messages: _messages,
            meId: _me,
            meUser: meUser,
            other: _other,
            otherId: _otherId,
            gigs: _gigs,
            declinedCalls: _declinedCalls,
            typing: _typing,
            onLongPress: _onLongPress,
            onViewOffer: _viewOffer,
            onSetOfferStatus: _setOfferStatus,
            onDeclineCall: (m, fromMe) {
              setState(() => _declinedCalls.add(m.id));
              showAppSnack(context, fromMe ? l.inboxCallCancelled : l.inboxCallDeclined);
            },
            showScrollDown: _showDown,
            onScrollDown: _scrollToEnd,
          ),
        ),
        if (conv?.blocked ?? false)
          ChatBlockedBar(onUnblock: () => ConversationActions.toggleBlock(context, conv!))
        else
          ChatComposer(
            controller: _input,
            focusNode: _focus,
            canSend: _input.text.trim().isNotEmpty && !_sending,
            onAttach: _openAttach,
            onQuick: _pickQuick,
            onSend: _sendText,
            replyName: reply == null ? null : _senderName(reply),
            replyPreview: reply == null ? null : _plain(reply),
            onCancelReply: () => setState(() => _replyTo = null),
            pendingGig: _pendingGigId == null ? null : _gigs[_pendingGigId],
            sellerName: _other?.displayName,
            onClosePendingGig: () => setState(() => _pendingGigId = null),
          ),
      ],
    );
  }
}
