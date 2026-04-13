import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/api_client.dart';
import 'package:flutter_application_1/src/core/config.dart';
import 'package:flutter_application_1/src/core/session_controller.dart';
import 'package:flutter_application_1/src/widgets/app_password_field.dart';
import 'package:flutter_application_1/src/widgets/app_text_field.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({required this.sessionController, super.key});

  final SessionController sessionController;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();

  bool _showAuthForm = false;
  bool _registerMode = false;
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      if (_registerMode) {
        await widget.sessionController.register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _displayNameController.text.trim(),
        );
      } else {
        await widget.sessionController.login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
    } on ApiException catch (error) {
      setState(() {
        _error = error.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width >= 920;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A1220), Color(0xFF040B13)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              left: -80,
              child: _HeroGlow(
                color: theme.colorScheme.primary.withValues(alpha: 0.18),
                size: 260,
              ),
            ),
            Positioned(
              top: 120,
              right: -100,
              child: _HeroGlow(
                color: theme.colorScheme.secondary.withValues(alpha: 0.14),
                size: 320,
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 40,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1120),
                      child: _showAuthForm
                          ? Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 430,
                                ),
                                child: _buildFormCard(theme),
                              ),
                            )
                          : (isWide
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: _buildEditorialPanel(theme),
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      _buildEditorialPanel(
                                        theme,
                                        compact: true,
                                      ),
                                    ],
                                  )),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditorialPanel(ThemeData theme, {bool compact = false}) {
    return Container(
      padding: EdgeInsets.all(compact ? 24 : 32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Icon(
              Icons.movie_creation_outlined,
              size: 36,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: compact ? 24 : 36),
          Text(
            'SPOILIFLY',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Retrouve tes spoilers premium sur mobile.',
            style: TextStyle(
              fontSize: compact ? 34 : 52,
              height: 0.95,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Teasers gratuits, révélations verrouillées, packs complets et bibliothèque personnelle dans une interface plus lisible.',
            style: TextStyle(
              fontSize: 16,
              height: 1.55,
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _AuthBadge(label: 'Spoilers premium'),
              _AuthBadge(label: 'Bibliothèque'),
              _AuthBadge(label: 'Packs'),
              _AuthBadge(label: 'Catalogue'),
            ],
          ),
          SizedBox(height: compact ? 24 : 36),
          Row(
            children: [
              FilledButton.icon(
                onPressed: () {
                  setState(() {
                    _showAuthForm = true;
                  });
                },
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('C’est parti'),
              ),
              if (_showAuthForm) ...[
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _showAuthForm = false;
                      _error = null;
                    });
                  },
                  child: const Text('Retour'),
                ),
              ],
            ],
          ),
          SizedBox(height: compact ? 24 : 36),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Accès rapide',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 12),
                _FeatureLine(
                  icon: Icons.lock_open_rounded,
                  text: 'Déverrouille tes contenus achetés',
                ),
                SizedBox(height: 10),
                _FeatureLine(
                  icon: Icons.auto_awesome_rounded,
                  text: 'Retrouve les dernières révélations',
                ),
                SizedBox(height: 10),
                _FeatureLine(
                  icon: Icons.bookmark_added_rounded,
                  text: 'Ouvre ta bibliothèque depuis mobile',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _registerMode ? 'Créer un compte' : 'Connexion',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showAuthForm = false;
                    _error = null;
                  });
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Revenir à l’accueil'),
              ),
              const SizedBox(height: 8),
              Text(
                _registerMode
                    ? 'Inscris-toi pour enregistrer ta progression et accéder à ta bibliothèque.'
                    : 'Connecte-toi pour retrouver tes achats et tes révélations premium.',
                style: TextStyle(
                  height: 1.45,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _ModeButton(
                        label: 'Connexion',
                        selected: !_registerMode,
                        onTap: () {
                          setState(() {
                            _registerMode = false;
                            _error = null;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ModeButton(
                        label: 'Inscription',
                        selected: _registerMode,
                        onTap: () {
                          setState(() {
                            _registerMode = true;
                            _error = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              if (_registerMode) ...[
                AppTextField(
                  controller: _displayNameController,
                  labelText: 'Nom affiché',
                  hintText: 'Lina Reader',
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  validator: (value) {
                    if (_registerMode &&
                        (value == null || value.trim().isEmpty)) {
                      return 'Champ requis';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
              ],
              AppTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'reader@spoilifly.local',
                prefixIcon: const Icon(Icons.mail_outline_rounded),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Email invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              AppPasswordField(
                controller: _passwordController,
                hintText: 'Minimum 8 caractères',
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return '8 caractères minimum';
                  }
                  return null;
                },
              ),
              if (_error != null) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0x33FF6B6B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x66FF6B6B)),
                  ),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Color(0xFFFFC5C5)),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(58),
                ),
                child: Text(
                  _isSubmitting
                      ? 'Chargement...'
                      : _registerMode
                      ? 'Créer le compte'
                      : 'Se connecter',
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _registerMode = !_registerMode;
                      _error = null;
                    });
                  },
                  child: Text(
                    _registerMode
                        ? 'Déjà un compte ? Se connecter'
                        : 'Pas encore de compte ? S’inscrire',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Base API: ${AppConfig.apiBaseUrl}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.44),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: selected ? const Color(0xFF111827) : Colors.white,
          ),
        ),
      ),
    );
  }
}

class _AuthBadge extends StatelessWidget {
  const _AuthBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}

class _FeatureLine extends StatelessWidget {
  const _FeatureLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.76)),
          ),
        ),
      ],
    );
  }
}

class _HeroGlow extends StatelessWidget {
  const _HeroGlow({required this.color, this.size = 180});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}
