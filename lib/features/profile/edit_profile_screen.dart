import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/l10n.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/widgets.dart';
import '../../state/session_controller.dart';

/// Sửa hồ sơ: họ tên, giới thiệu ngắn, mô tả, ngôn ngữ, kỹ năng.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  /// Giá trị lưu trong hồ sơ (dữ liệu) – nhãn hiển thị dịch ở [_languageLabel].
  static const _allLanguages = ['Tiếng Việt', 'Tiếng Anh', 'Tiếng Trung', 'Tiếng Nhật', 'Tiếng Hàn', 'Tiếng Pháp'];

  static String _languageLabel(AppLocalizations l, String v) => switch (v) {
    'Tiếng Việt' => l.profileSpokenVietnamese,
    'Tiếng Anh' => l.profileSpokenEnglish,
    'Tiếng Trung' => l.profileSpokenChinese,
    'Tiếng Nhật' => l.profileSpokenJapanese,
    'Tiếng Hàn' => l.profileSpokenKorean,
    'Tiếng Pháp' => l.profileSpokenFrench,
    _ => v,
  };
  static const _maxSkills = 15;

  late final TextEditingController _name;
  late final TextEditingController _headline;
  late final TextEditingController _bio;
  final _skill = TextEditingController();
  late Set<String> _languages;
  late List<String> _langOptions;
  late List<String> _skills;
  String? _nameError;
  String? _skillError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final u = context.read<SessionController>().user;
    _name = TextEditingController(text: u?.displayName ?? '');
    _headline = TextEditingController(text: u?.headline ?? '');
    _bio = TextEditingController(text: u?.bio ?? '');
    _languages = {...?u?.languages};
    _langOptions = {..._allLanguages, ..._languages}.toList();
    _skills = [...?u?.skills];
  }

  @override
  void dispose() {
    _name.dispose();
    _headline.dispose();
    _bio.dispose();
    _skill.dispose();
    super.dispose();
  }

  void _addSkill() {
    final v = _skill.text.trim();
    final l = context.l10n;
    String? err;
    if (v.isEmpty) {
      err = l.profileSkillEmpty;
    } else if (_skills.any((s) => s.toLowerCase() == v.toLowerCase())) {
      err = l.profileSkillDuplicate;
    } else if (_skills.length >= _maxSkills) {
      err = l.profileSkillMax(_maxSkills);
    }
    setState(() {
      _skillError = err;
      if (err == null) {
        _skills.add(v);
        _skill.clear();
      }
    });
  }

  Future<void> _save() async {
    final session = context.read<SessionController>();
    final u = session.user;
    final l = context.l10n;
    if (u == null) return;
    final name = _name.text.trim();
    if (name.length < 2) {
      setState(() => _nameError = l.profileNameTooShort);
      return;
    }
    if (_languages.isEmpty) {
      showAppSnack(context, l.profileLanguageRequired, success: false);
      return;
    }
    setState(() => _saving = true);
    try {
      await session.updateProfile(
        u.copyWith(
          displayName: name,
          headline: _headline.text.trim(),
          bio: _bio.text.trim(),
          languages: _langOptions.where(_languages.contains).toList(),
          skills: _skills,
        ),
      );
      if (!mounted) return;
      showAppSnack(context, l.profileSaved);
      context.canPop() ? context.pop() : context.go('/profile');
    } catch (_) {
      if (mounted) showAppSnack(context, l.profileSaveFailed, success: false);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(top: Space.xl, bottom: Space.sm),
    child: Text(t, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
  );

  @override
  Widget build(BuildContext context) {
    final user = context.watch<SessionController>().user;
    final l = context.l10n;
    return Scaffold(
      appBar: SimpleAppBar(title: l.profileEditProfile),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, Space.xxl),
        children: [
          Center(
            child: Stack(
              children: [
                UserAvatar(user: user, size: 84),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleIconButton(
                    icon: Icons.photo_camera_outlined,
                    size: 32,
                    tooltip: l.profileChangeAvatar,
                    onPressed: () => showAppSnack(context, l.profileAvatarUploadSoon),
                  ),
                ),
              ],
            ),
          ),
          _label(l.profileFullName),
          TextField(
            key: const ValueKey('edit_name'),
            controller: _name,
            textCapitalization: TextCapitalization.words,
            onChanged: (_) => _nameError == null ? null : setState(() => _nameError = null),
            decoration: InputDecoration(hintText: l.profileNameHint, errorText: _nameError),
          ),
          _label(l.profileHeadline),
          TextField(
            key: const ValueKey('edit_headline'),
            controller: _headline,
            maxLength: 70,
            decoration: InputDecoration(hintText: l.profileHeadlineHint),
          ),
          _label(l.profileBio),
          CountedTextField(
            fieldKey: const ValueKey('edit_bio'),
            controller: _bio,
            hint: l.profileBioHint,
            maxLength: 600,
            minLines: 4,
            maxLines: 8,
          ),
          _label(l.profileLanguage),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              for (final lang in _langOptions)
                SelectChip(
                  label: _languageLabel(l, lang),
                  selected: _languages.contains(lang),
                  showCheck: true,
                  onTap: () =>
                      setState(() => _languages.contains(lang) ? _languages.remove(lang) : _languages.add(lang)),
                ),
            ],
          ),
          _label(l.profileSkills),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  key: const ValueKey('edit_skill'),
                  controller: _skill,
                  onSubmitted: (_) => _addSkill(),
                  onChanged: (_) => _skillError == null ? null : setState(() => _skillError = null),
                  decoration: InputDecoration(hintText: l.profileSkillHint, errorText: _skillError),
                ),
              ),
              Gaps.h8,
              SizedBox(
                height: 50,
                child: OutlinedButton(
                  key: const ValueKey('add_skill'),
                  onPressed: _addSkill,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    padding: const EdgeInsets.symmetric(horizontal: Space.lg),
                  ),
                  child: Text(l.profileAddSkill),
                ),
              ),
            ],
          ),
          Gaps.v10,
          if (_skills.isEmpty)
            Text(l.profileNoSkills, style: context.textTheme.bodySmall)
          else
            Wrap(
              spacing: Space.sm,
              runSpacing: Space.sm,
              children: [
                for (final s in _skills)
                  InputChip(
                    label: Text(s),
                    onDeleted: () => setState(() => _skills.remove(s)),
                    deleteButtonTooltipMessage: l.commonDelete,
                  ),
              ],
            ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        child: PrimaryButton(
          key: const ValueKey('edit_save'),
          label: l.profileSaveChanges,
          loading: _saving,
          onPressed: _save,
        ),
      ),
    );
  }
}
