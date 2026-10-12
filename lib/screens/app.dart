import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import '../data/culture_content.dart';
import '../data/language_basics.dart';
import '../data/culture_sections.dart';
import '../l10n/culture_translations.dart';
import '../models/culture_entry.dart';
import '../models/culture_section.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/favorites_controller.dart';
import '../services/profile_repository.dart';
import '../l10n/app_strings.dart';
import '../l10n/language_controller.dart';
import '../theme/app_theme.dart';
import '../theme/theme_controller.dart';
import '../theme/theme_mode_selector.dart';
import '../widgets/petal_animation.dart';
import '../widgets/cultural_image.dart';

class HanariApp extends StatefulWidget {
  const HanariApp({super.key});

  @override
  State<HanariApp> createState() => _HanariAppState();
}

class _HanariAppState extends State<HanariApp> {
  late final LanguageController languageController;
  late final FavoritesController favoritesController;
  late final ThemeController themeController;

  @override
  void initState() {
    super.initState();
    languageController = LanguageController()..load();
    favoritesController = FavoritesController()..loadForCurrentUser();
    themeController = ThemeController()..load();
  }

  @override
  void dispose() {
    languageController.dispose();
    favoritesController.dispose();
    themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge([languageController, themeController]),
    builder: (context, _) => LanguageScope(
      controller: languageController,
      child: FavoritesScope(
        controller: favoritesController,
        child: ThemeScope(
          controller: themeController,
          child: MaterialApp(
            title: 'HANARI',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeController.themeMode,
            themeAnimationDuration: const Duration(milliseconds: 250),
            builder: (context, child) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: isDark
                      ? Brightness.light
                      : Brightness.dark,
                  statusBarBrightness: isDark
                      ? Brightness.dark
                      : Brightness.light,
                  systemNavigationBarColor: Theme.of(context)
                      .scaffoldBackgroundColor,
                  systemNavigationBarIconBrightness: isDark
                      ? Brightness.light
                      : Brightness.dark,
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
            initialRoute: '/',
            routes: {
              '/': (_) => const SplashScreen(),
              '/onboarding': (_) => const OnboardingScreen(),
              '/login': (_) => const AuthScreen(isRegistration: false),
              '/register': (_) => const AuthScreen(isRegistration: true),
              '/home': (_) => const _ProtectedHomeRoute(),
            },
          ),
        ),
      ),
    ),
  );
}

void openPage(BuildContext context, Widget page) {
  final languageController = LanguageScope.of(context);
  final favoritesController = FavoritesScope.of(context);
  HapticFeedback.selectionClick();
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => LanguageScope(
        controller: languageController,
        child: FavoritesScope(controller: favoritesController, child: page),
      ),
    ),
  );
}

class _ProtectedHomeRoute extends StatelessWidget {
  const _ProtectedHomeRoute();

  @override
  Widget build(BuildContext context) {
    final hasSession =
        SupabaseConfig.isConfigured &&
        Supabase.instance.client.auth.currentSession != null;
    return hasSession
        ? const MainShell()
        : const AuthScreen(isRegistration: false);
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      final hasSession =
          SupabaseConfig.isConfigured &&
          Supabase.instance.client.auth.currentSession != null;
      Navigator.pushReplacementNamed(
        context,
        hasSession ? '/home' : '/onboarding',
      );
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              'assets/branding/hanari_app_icon.png',
              width: 104,
              height: 104,
              fit: BoxFit.cover,
              excludeFromSemantics: true,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'HANARI',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.6,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '안녕, Корея!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 6),
          Text(
            context.strings.get('splashTagline'),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ),
  );
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  int index = 0;
  void finish() => Navigator.pushReplacementNamed(context, '/login');

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.strings;
    final pages = [
      _Intro(
        icon: Icons.temple_buddhist_rounded,
        title: t.get('onboarding1Title'),
        text: t.get('onboarding1Text'),
      ),
      _Intro(
        icon: Icons.ramen_dining_rounded,
        title: t.get('onboarding2Title'),
        text: t.get('onboarding2Text'),
      ),
      _Intro(
        icon: Icons.translate_rounded,
        title: t.get('onboarding3Title'),
        text: t.get('onboarding3Text'),
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/branding/hanari_app_icon.png',
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          excludeFromSemantics: true,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'HANARI',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const LanguagePicker(),
                  TextButton(onPressed: finish, child: Text(t.get('skip'))),
                ],
              ),
              Expanded(
                child: PageView(
                  controller: controller,
                  onPageChanged: (value) => setState(() => index = value),
                  children: pages,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == index ? 22 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: i == index
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (index == 2) {
                    finish();
                  } else {
                    controller.nextPage(
                      duration: const Duration(milliseconds: 240),
                      curve: Curves.easeOut,
                    );
                  }
                },
                child: Text(index == 2 ? t.get('start') : t.get('next')),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro({required this.icon, required this.title, required this.text});
  final IconData icon;
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 190,
        height: 190,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 92,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      const SizedBox(height: 38),
      Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 12),
      Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.isRegistration});
  final bool isRegistration;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final formKey = GlobalKey<FormState>();
  final authService = AuthService();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final passwordConfirmation = TextEditingController();
  bool isSubmitting = false;
  String? feedback;
  bool feedbackIsError = true;
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    passwordConfirmation.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final languageController = LanguageScope.of(context);
    final favoritesController = FavoritesScope.of(context);
    if (!formKey.currentState!.validate()) return;
    setState(() {
      isSubmitting = true;
      feedback = null;
    });
    try {
      if (widget.isRegistration) {
        final result = await authService.register(
          name: name.text,
          email: email.text,
          password: password.text,
        );
        if (!mounted) return;
        if (result == RegistrationStatus.confirmationRequired) {
          setState(() {
            feedback = context.strings.get('emailConfirmation');
            feedbackIsError = false;
          });
          return;
        }
      } else {
        await authService.signIn(email: email.text, password: password.text);
      }

      // A language selected before sign-in is copied to the user's profile.
      try {
        await languageController.setLanguage(languageController.languageCode);
      } catch (_) {
        // Authentication should still finish if profile language sync is offline.
      }
      try {
        await favoritesController.loadForCurrentUser();
      } catch (_) {
        // A local storage failure should not block a successful sign-in.
      }

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
      }
    } on AuthException catch (error) {
      if (mounted) {
        setState(() {
          feedback = _friendlyAuthError(error.message, context.strings);
          feedbackIsError = true;
        });
      }
    } on StateError {
      if (mounted) {
        setState(() {
          feedback = context.strings.get('configureSupabase');
          feedbackIsError = true;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          feedback = context.strings.get('connectionError');
          feedbackIsError = true;
        });
      }
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  String _friendlyAuthError(String message, AppStrings strings) {
    final normalized = message.toLowerCase();
    if (normalized.contains('invalid login credentials')) {
      return strings.get('badCredentials');
    }
    if (normalized.contains('user already registered')) {
      return strings.get('alreadyRegistered');
    }
    if (normalized.contains('password should be at least')) {
      return strings.get('weakPassword');
    }
    if (normalized.contains('email not confirmed')) {
      return strings.get('emailUnconfirmed');
    }
    return strings.get('connectionError');
  }

  @override
  Widget build(BuildContext context) {
    final registration = widget.isRegistration;
    final t = context.strings;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: LanguagePicker(),
                    ),
                    Icon(
                      Icons.local_florist_rounded,
                      size: 52,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      registration ? t.get('welcome') : t.get('welcomeBack'),
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      registration
                          ? t.get('signUpPrompt')
                          : t.get('signInPrompt'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 28),
                    if (registration) ...[
                      _FieldLabel(t.get('name')),
                      TextFormField(
                        controller: name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: t.get('yourName'),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? t.get('enterName')
                            : null,
                      ),
                      const SizedBox(height: 16),
                    ],
                    _FieldLabel(t.get('email')),
                    TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'name@example.com',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return t.get('enterEmail');
                        }
                        if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                            .hasMatch(value.trim())) {
                          return t.get('invalidEmail');
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel(t.get('password')),
                    TextFormField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: t.get('passwordHint'),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return t.get('enterPassword');
                        }
                        if (v.length < 6) return t.get('minPassword');
                        return null;
                      },
                    ),
                    if (registration) ...[
                      const SizedBox(height: 16),
                      _FieldLabel(t.get('confirmPassword')),
                      TextFormField(
                        controller: passwordConfirmation,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: t.get('repeatPassword'),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return t.get('confirmPasswordError');
                          }
                          if (value != password.text) {
                            return t.get('passwordMismatch');
                          }
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(height: 22),
                    FilledButton(
                      onPressed: isSubmitting ? null : submit,
                      child: isSubmitting
                          ? SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                          : Text(
                              registration ? t.get('signUp') : t.get('signIn'),
                            ),
                    ),
                    const SizedBox(height: 16),
                    if (feedback != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          feedback!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: feedbackIsError
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                    Text(
                      authService.isConfigured
                          ? t.get('authReady')
                          : t.get('configureSupabase'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        registration ? '/login' : '/register',
                      ),
                      child: Text(
                        registration ? t.get('hasAccount') : t.get('noAccount'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    ),
  );
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    final t = context.strings;
    final screens = [
      const HomeScreen(),
      const ExploreScreen(),
      const FavoritesScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: selected, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (i) {
          HapticFeedback.selectionClick();
          setState(() => selected = i);
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: t.get('home'),
            tooltip: t.get('home'),
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: t.get('explore'),
            tooltip: t.get('explore'),
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: t.get('favorites'),
            tooltip: t.get('favorites'),
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: t.get('profile'),
            tooltip: t.get('profile'),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final t = context.strings;
    final savedEntries = allCultureEntries
        .where((entry) => context.favorites.contains(entry.id))
        .toList();
    final fact = historyEntries[DateTime.now().day % historyEntries.length];
    final preferredKind = savedEntries.isEmpty ? null : savedEntries.first.kind;
    final personalizedEntries = preferredKind == null
        ? traditionEntries
        : allCultureEntries
              .where(
                (entry) =>
                    entry.kind == preferredKind &&
                    !context.favorites.contains(entry.id),
              )
              .toList();
    final recommendations = personalizedEntries.isEmpty
        ? traditionEntries
        : personalizedEntries;
    final recommendation =
        recommendations[DateTime.now().weekday % recommendations.length];
    final featuredFood = foodEntries.first;
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: PetalAnimation(child: const SizedBox.expand()),
          ),
        ),
        SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.get('hello'),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                        Text(
                          t.get('homeWelcome'),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    child: Icon(
                      Icons.person_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CulturalImage(
                      assetPath: 'assets/culture/tradition_hanbok.jpg',
                      semanticsLabel: 'Traditional Korean hanbok clothing',
                      fallbackIcon: Icons.checkroom_rounded,
                      aspectRatio: 2.25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.get('todayTrip'),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            t.get('todayCulture'),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            t.get('homeSummary'),
                            style: TextStyle(height: 1.4),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () =>
                                openPage(context, const ExploreScreen()),
                            icon: const Icon(Icons.explore_rounded),
                            label: Text(t.get('startExploring')),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _SectionHeader(title: t.get('continueLearning')),
              const SizedBox(height: 10),
              if (savedEntries.isEmpty)
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondaryContainer,
                      child: Icon(
                        Icons.bookmark_add_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: Text(t.get('savedShelfEmpty')),
                    subtitle: Text(t.get('savedShelfEmptyHint')),
                    trailing: const Icon(Icons.arrow_forward_rounded),
                    onTap: () => openPage(context, const ExploreScreen()),
                  ),
                )
              else ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    t
                        .get('savedShelfCount')
                        .replaceAll('{count}', savedEntries.length.toString()),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                _CultureEntryCard(entry: savedEntries.first),
              ],
              const SizedBox(height: 24),
              _SectionHeader(title: t.get('dailyFact')),
              const SizedBox(height: 10),
              _CultureEntryCard(
                entry: fact,
                eyebrow: localizedCultureCopy(
                  fact,
                  LanguageScope.of(context).languageCode,
                ).period,
              ),
              const SizedBox(height: 22),
              _SectionHeader(title: t.get('recommended')),
              const SizedBox(height: 10),
              _CultureEntryCard(entry: recommendation),
              const SizedBox(height: 22),
              _SectionHeader(title: t.get('popularFood')),
              const SizedBox(height: 10),
              _CultureEntryCard(entry: featuredFood),
              const SizedBox(height: 22),
              _SectionHeader(
                title: t.get('sections'),
                action: t.get('all'),
                onTap: () => openPage(context, const ExploreScreen()),
              ),
              const SizedBox(height: 12),
              ...cultureSections.map(
                (section) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SectionTile(section: section),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    child: Icon(
                      Icons.lightbulb_outline_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(t.get('wordOfDay')),
                  subtitle: Text('안녕하세요 · ${t.get('koreanGreeting')}'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action, this.onTap});
  final String title;
  final String? action;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(title, style: Theme.of(context).textTheme.titleLarge),
      ),
      if (action != null) TextButton(onPressed: onTap, child: Text(action!)),
    ],
  );
}

class SectionTile extends StatelessWidget {
  const SectionTile({super.key, required this.section});
  final CultureSection section;
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => openPage(context, CategoryScreen(section: section)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                section.icon,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.strings.get(_sectionTitleKey(section.id)),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    context.strings.get(_sectionSubtitleKey(section.id)),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    ),
  );
}

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key, this.sections = cultureSections});
  final List<CultureSection> sections;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Scaffold(
      appBar: AppBar(title: Text(strings.get('explore'))),
      body: SafeArea(
        child: sections.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.explore_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 52,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        strings.get('materialUnavailable'),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Text(
                    strings.get('exploreSubtitle'),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  ...sections.map(
                    (section) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SectionTile(section: section),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = allCultureEntries
        .where((entry) => context.favorites.contains(entry.id))
        .toList();
    return SafeArea(
      child: entries.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondaryContainer,
                      child: Icon(
                        Icons.favorite_border_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 34,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      context.strings.get('favorites'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.strings.get('emptyFavorites'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      onPressed: () => openPage(context, const ExploreScreen()),
                      icon: const Icon(Icons.explore_rounded),
                      label: Text(context.strings.get('openSavedShelf')),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  context.strings.get('favorites'),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 14),
                ...entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _CultureEntryCard(entry: entry),
                  ),
                ),
              ],
            ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.section});
  final CultureSection section;
  @override
  Widget build(BuildContext context) {
    final t = context.strings;
    final entries = switch (section.id) {
      'history' => historyEntries,
      'tradition' => traditionEntries,
      'food' => foodEntries,
      _ => const <CultureEntry>[],
    };
    return Scaffold(
      appBar: AppBar(title: Text(t.get(_sectionTitleKey(section.id)))),
      body: section.id == 'language'
          ? ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                Text(
                  t.get('languageIntro'),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                const CulturalImage(
                  assetPath: 'assets/culture/language_hangul.png',
                  semanticsLabel: 'Hangul, the Korean writing system',
                  fallbackIcon: Icons.translate_rounded,
                  aspectRatio: 2.6,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                ...koreanStarterPhrases.map(
                  (phrase) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        child: Icon(
                          Icons.translate_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      title: Text(
                        phrase.korean,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        '${phrase.romanization} · ${localizedPhraseCopy(phrase.korean, LanguageScope.of(context).languageCode).meaning}',
                      ),
                      trailing: Icon(Icons.chevron_right_rounded),
                      onTap: () => openPage(
                        context,
                        LanguagePhraseScreen(phrase: phrase),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : entries.isEmpty
          ? Center(child: Text(t.get('materialUnavailable')))
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                Text(
                  t.get(_sectionSubtitleKey(section.id)),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                if (section.id == 'history')
                  _HistoryTimeline(entries: entries)
                else
                  ...entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _CultureEntryCard(entry: entry),
                    ),
                  ),
              ],
            ),
    );
  }
}

String _sectionTitleKey(String id) => switch (id) {
  'history' => 'history',
  'tradition' => 'tradition',
  'food' => 'food',
  _ => 'languageBasics',
};

String _sectionSubtitleKey(String id) => switch (id) {
  'history' => 'historySubtitle',
  'tradition' => 'traditionSubtitle',
  'food' => 'foodSubtitle',
  _ => 'languageSubtitle',
};

class LanguagePhraseScreen extends StatelessWidget {
  const LanguagePhraseScreen({super.key, required this.phrase});
  final LanguagePhrase phrase;

  @override
  Widget build(BuildContext context) {
    final phraseCopy = localizedPhraseCopy(
      phrase.korean,
      LanguageScope.of(context).languageCode,
    );
    return Scaffold(
      appBar: AppBar(title: Text(phrase.korean)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        children: [
          const CulturalImage(
            assetPath: 'assets/culture/language_hangul.png',
            semanticsLabel: 'Hangul, the Korean writing system',
            fallbackIcon: Icons.translate_rounded,
            aspectRatio: 2.6,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text(
                  phrase.korean,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  phraseCopy.meaning,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text(
            context.strings.get('pronunciation'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            phrase.romanization,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Text(
            context.strings.get('phraseUse'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            phraseCopy.note,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 10),
          Text(
            '${context.strings.get('source')}: National Institute of Korean Language — Korean-English Learners’ Dictionary',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          SelectableText(
            'https://krdict.korean.go.kr/eng',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}

class _HistoryTimeline extends StatelessWidget {
  const _HistoryTimeline({required this.entries});
  final List<CultureEntry> entries;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (var i = 0; i < entries.length; i++)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 28,
                  child: Column(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        margin: const EdgeInsets.only(top: 18),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (i < entries.length - 1)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: _CultureEntryCard(
                    entry: entries[i],
                    eyebrow: localizedCultureCopy(
                      entries[i],
                      LanguageScope.of(context).languageCode,
                    ).period,
                  ),
                ),
              ],
            ),
          ),
        ),
    ],
  );
}

class _CultureEntryCard extends StatelessWidget {
  const _CultureEntryCard({required this.entry, this.eyebrow});
  final CultureEntry entry;
  final String? eyebrow;

  @override
  Widget build(BuildContext context) {
    final content = localizedCultureCopy(
      entry,
      LanguageScope.of(context).languageCode,
    );
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openPage(context, CultureEntryScreen(entry: entry)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 156,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _EntryImage(
                    entry: entry,
                    width: double.infinity,
                    height: 156,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface
                            .withValues(alpha: .94),
                        shape: BoxShape.circle,
                      ),
                      child: FavoriteButton(entry: entry),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (eyebrow != null) ...[
                    Text(
                      eyebrow!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    content.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    content.summary,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.entry});
  final CultureEntry entry;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.favorites.contains(entry.id);
    return IconButton(
      tooltip: context.strings.get(
        isFavorite ? 'removeFavorite' : 'addFavorite',
      ),
      onPressed: () {
        HapticFeedback.selectionClick();
        context.favorites.toggle(entry.id);
      },
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          key: ValueKey(isFavorite),
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isFavorite
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _EntryImage extends StatelessWidget {
  const _EntryImage({
    required this.entry,
    required this.width,
    required this.height,
  });
  final CultureEntry entry;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CulturalImage(
      assetPath: entry.imageAssetPath,
      imageUrl: entry.imageUrl,
      semanticsLabel: entry.title,
      fallbackIcon: entry.icon,
      width: width,
      height: height,
      aspectRatio: width / height,
      fit: BoxFit.cover,
    );
  }
}

class CultureEntryScreen extends StatelessWidget {
  const CultureEntryScreen({super.key, required this.entry});
  final CultureEntry entry;

  @override
  Widget build(BuildContext context) {
    final content = localizedCultureCopy(
      entry,
      LanguageScope.of(context).languageCode,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(content.title),
        actions: [FavoriteButton(entry: entry)],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _EntryImage(entry: entry, width: double.infinity, height: 220),
          if (entry.imageSourceName != null) ...[
            const SizedBox(height: 6),
            Text(
              '${context.strings.get('image')}: ${entry.imageSourceName} · ${context.strings.get('license')}: ${entry.imageLicense ?? ''}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 18),
          if (content.period != null) ...[
            Text(
              content.period!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
          ],
          Text(content.summary, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          for (final paragraph in content.paragraphs) ...[
            Text(
              paragraph,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(height: 1.55),
            ),
            const SizedBox(height: 14),
          ],
          if (content.ingredients.isNotEmpty) ...[
            Text(
              context.strings.get('ingredients'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: content.ingredients
                  .map((ingredient) => Chip(label: Text(ingredient)))
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],
          const Divider(),
          const SizedBox(height: 10),
          Text(
            '${context.strings.get('source')}: ${entry.sourceName}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          SelectableText(
            entry.sourceUrl,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          if (entry.imageSourceUrl != null &&
              entry.imageSourceUrl != entry.sourceUrl) ...[
            const SizedBox(height: 10),
            Text(
              '${context.strings.get('imageSource')}: ${entry.imageSourceName}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SelectableText(
              entry.imageSourceUrl!,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            if (entry.imageLicenseUrl != null) ...[
              const SizedBox(height: 4),
              Text(
                '${context.strings.get('license')}: ${entry.imageLicense ?? ''}',
              ),
              SelectableText(
                entry.imageLicenseUrl!,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserProfile?> profileFuture;

  @override
  void initState() {
    super.initState();
    profileFuture = _loadProfile();
  }

  Future<UserProfile?> _loadProfile() {
    if (!SupabaseConfig.isConfigured) return Future.value(null);
    return ProfileRepository().currentProfile();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SafeArea(bottom: false, child: _ThemePreferenceCard()),
      Expanded(
        child: SafeArea(
          top: false,
          child: FutureBuilder<UserProfile?>(
            future: profileFuture,
            builder: (context, snapshot) {
              if (!SupabaseConfig.isConfigured) {
                return _profileMessage(
                  context.strings.get('profileConfigure'),
                  icon: Icons.cloud_off_rounded,
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 12),
                      Text(context.strings.get('loadingProfile')),
                    ],
                  ),
                );
              }
              if (snapshot.hasError) {
                return _profileMessage(
                  context.strings.get('profileLoadError'),
                  icon: Icons.error_outline_rounded,
                  retry: true,
                );
              }
              final profile = snapshot.data;
              if (profile == null) {
                return _profileMessage(
                  context.strings.get('profileMissing'),
                  icon: Icons.person_search_rounded,
                  retry: true,
                );
              }
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    context.strings.get('profile'),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  Center(child: _ProfileAvatar(url: profile.avatarUrl)),
                  const SizedBox(height: 12),
                  Text(
                    profile.name.isEmpty
                        ? context.strings.get('traveler')
                        : profile.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.of(context)
                          .push<ProfileUpdateResult>(
                            MaterialPageRoute<ProfileUpdateResult>(
                              builder: (_) =>
                                  ProfileEditorScreen(profile: profile),
                            ),
                          );
                      if (!context.mounted || result == null) return;
                      setState(() => profileFuture = _loadProfile());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            result.emailConfirmationPending
                                ? context.strings.get(
                                    'emailConfirmationPending',
                                  )
                                : context.strings.get('profileUpdated'),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.edit_rounded),
                    label: Text(context.strings.get('editProfile')),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.language_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(context.strings.get('selectedLanguage')),
                          subtitle: Text(
                            AppStrings.languageNames[LanguageScope.of(context)
                                    .languageCode] ??
                                profile.language,
                          ),
                          trailing: const LanguagePicker(),
                        ),
                        if (profile.createdAt != null)
                          ListTile(
                            leading: Icon(
                              Icons.calendar_month_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            title: Text(context.strings.get('registeredOn')),
                            subtitle: Text(_dateLabel(profile.createdAt!)),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: _signOut,
                    icon: Icon(Icons.logout_rounded),
                    label: Text(context.strings.get('signOut')),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ],
  );

  String _dateLabel(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  Widget _profileMessage(
    String message, {
    required IconData icon,
    bool retry = false,
  }) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 52),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          if (retry) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => setState(() => profileFuture = _loadProfile()),
              child: Text(context.strings.get('retry')),
            ),
          ],
        ],
      ),
    ),
  );

  Future<void> _signOut() async {
    final favoritesController = FavoritesScope.of(context);
    try {
      await AuthService().signOut();
      try {
        await favoritesController.loadForCurrentUser();
      } catch (_) {
        // Sign-out has succeeded even if the local favorites cache is unavailable.
      }
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.strings.get('signOutError'))),
        );
      }
    }
  }
}

class _ThemePreferenceCard extends StatelessWidget {
  const _ThemePreferenceCard();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.get('appearance'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              strings.get('themeDescription'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            const ThemeModeSelector(),
          ],
        ),
      ),
    );
  }
}

class ProfileEditorScreen extends StatefulWidget {
  const ProfileEditorScreen({super.key, required this.profile});
  final UserProfile profile;

  @override
  State<ProfileEditorScreen> createState() => _ProfileEditorScreenState();
}

class _ProfileEditorScreenState extends State<ProfileEditorScreen> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController avatarController;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    emailController = TextEditingController(text: widget.profile.email);
    avatarController = TextEditingController(
      text: widget.profile.avatarUrl ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    avatarController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isSaving = true);
    try {
      final result = await ProfileRepository().updateCurrentProfile(
        name: nameController.text,
        email: emailController.text,
        avatarUrl: avatarController.text.trim().isEmpty
            ? null
            : avatarController.text.trim(),
      );
      if (mounted) Navigator.pop(context, result);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.strings.get('profileUpdateError'))),
        );
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.strings;
    return Scaffold(
      appBar: AppBar(title: Text(t.get('editProfile'))),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              Text(t.get('editProfileHint')),
              const SizedBox(height: 20),
              Center(child: _ProfileAvatar(url: avatarController.text)),
              const SizedBox(height: 22),
              _FieldLabel(t.get('name')),
              TextFormField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(hintText: t.get('yourName')),
                validator: (value) => value == null || value.trim().isEmpty
                    ? t.get('enterName')
                    : null,
              ),
              const SizedBox(height: 16),
              _FieldLabel(t.get('email')),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return t.get('enterEmail');
                  }
                  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                      .hasMatch(value.trim())) {
                    return t.get('invalidEmail');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _FieldLabel(t.get('avatarUrl')),
              TextFormField(
                controller: avatarController,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: t.get('avatarUrlHint'),
                  suffixIcon: IconButton(
                    tooltip: t.get('clearAvatar'),
                    onPressed: () {
                      avatarController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.close_rounded),
                  ),
                ),
                onChanged: (_) => setState(() {}),
                validator: (value) {
                  final raw = value?.trim() ?? '';
                  if (raw.isEmpty) return null;
                  final uri = Uri.tryParse(raw);
                  if (uri == null ||
                      !uri.hasAuthority ||
                      !const {'http', 'https'}.contains(uri.scheme)) {
                    return t.get('avatarUrlInvalid');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 26),
              FilledButton(
                onPressed: isSaving ? null : save,
                child: isSaving
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    : Text(t.get('save')),
              ),
              TextButton(
                onPressed: isSaving ? null : () => Navigator.pop(context),
                child: Text(t.get('cancel')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({this.url});
  final String? url;

  @override
  Widget build(BuildContext context) {
    return CulturalImage(
      imageUrl: url,
      semanticsLabel: 'Profile photo',
      fallbackIcon: Icons.person_rounded,
      width: 84,
      height: 84,
      aspectRatio: 1,
      circular: true,
    );
  }
}
