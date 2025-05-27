import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:productive_flutter/features/splash/splash_screen.dart';
import 'package:productive_flutter/providers/auth_provider.dart';
import 'package:productive_flutter/utils/extensions/navigation_extension.dart';

import '../../core/theme/theme_notifier.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider.notifier);
    final userEmail = authController.userEmail;
    final userDisplayName = authController.userDisplayName;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          shrinkWrap: false,
          children: [
            _buildHeader(context, ref),
            _buildProfileInfo(userDisplayName, userEmail),
            const SizedBox(height: 16),
            _buildSettingsSection(context),
            const SizedBox(height: 64),
            _buildLogoutButton(context, ref),
            const SizedBox(height: 16),
            _buildDeleteAccountButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildThemeToggle(context, ref),
      ],
    );
  }

  Widget _buildProfileInfo(String? displayName, String? email) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Hero(
          tag: 'profile_image',
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.withAlpha(26),
                width: 4,
              ),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: 'https://picsum.photos/seed/user1/200',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.withAlpha(26),
                  child: const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).colorScheme.primary.withAlpha(51),
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                ),
                memCacheHeight: 200,
                memCacheWidth: 200,
                maxHeightDiskCache: 200,
                maxWidthDiskCache: 200,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          displayName ?? 'User',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          email ?? 'user@example.com',
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue[500],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(32),
          ),
          child: const Text(
            'Top 5% this week',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeToggle(BuildContext context, WidgetRef ref) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final ThemeMode themeMode = ref.watch(themeProvider);

    return IconButton(
      icon: Icon(
        isDarkTheme ? Icons.light_mode : Icons.dark_mode,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => _ThemeSelectionDialog(
            themeMode: themeMode,
            onThemeSelected: (themeMode) {
              ref.read(themeProvider.notifier).setTheme(themeMode);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildSettingsTile(
            context,
            icon: Icons.account_circle,
            title: 'Account Settings',
            onTap: () {
              // Navigate to Account Settings
            },
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            context,
            icon: Icons.settings,
            title: 'Other Settings',
            onTap: () {
              // Navigate to Other Settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDeleteAccountButton() {
    return TextButton(
      onPressed: () {},
      child: const Text(
        "Delete Account",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.surface,
        onPressed: authState.isLoading
            ? null
            : () async {
                // Show confirmation dialog
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );

                if (shouldLogout == true && context.mounted) {
                  final authController =
                      ref.read(authControllerProvider.notifier);
                  await authController.signOut();

                  if (context.mounted) {
                    // Navigate to splash screen
                    context.navigateToReplacing(const SplashScreen());
                  }
                }
              },
        heroTag: 'logout_button',
        icon: authState.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(
                Icons.logout_rounded,
                size: 28,
              ),
        label: Text(
          authState.isLoading ? 'Logging out...' : 'Logout',
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ThemeSelectionDialog extends StatelessWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) onThemeSelected;

  const _ThemeSelectionDialog({
    required this.themeMode,
    required this.onThemeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Theme',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _ThemeOption(
              icon: Icons.light_mode,
              title: 'Light Theme',
              description: 'Bright and clean interface',
              isSelected: themeMode == ThemeMode.light,
              onTap: () => onThemeSelected(ThemeMode.light),
            ),
            const SizedBox(height: 16),
            _ThemeOption(
              icon: Icons.dark_mode,
              title: 'Dark Theme',
              description: 'Easier on the eyes in low light',
              isSelected: themeMode == ThemeMode.dark,
              onTap: () => onThemeSelected(ThemeMode.dark),
            ),
            const SizedBox(height: 16),
            _ThemeOption(
              icon: Icons.settings_brightness,
              title: 'System Theme',
              description: 'Automatically match system settings',
              isSelected: themeMode == ThemeMode.system,
              onTap: () => onThemeSelected(ThemeMode.system),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.withAlpha(51),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 28,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
