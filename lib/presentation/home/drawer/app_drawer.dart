import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/providers.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final user = authState.user;
    final profileImage = ref.watch(profileImageProvider);
    final colors = context.appColors;

    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 24,
              bottom: 24,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              color: colors.cardColor,
              border: Border(
                bottom: BorderSide(color: colors.borderColor),
              ),
            ),
            child: Column(
              children: [
                _buildDrawerAvatar(
                  context: context,
                  ref: ref,
                  name: user?.name ?? 'Usuario',
                  profileImage: profileImage,
                ),
                const SizedBox(height: 16),
                Text(
                  user?.name ?? 'Usuario',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildDrawerItem(
            context: context,
            icon: Icons.person_outline,
            title: 'Perfil',
            onTap: () {
              Navigator.pop(context);
              context.push('/profile');
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: themeMode == ThemeMode.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            title: themeMode == ThemeMode.dark ? 'Modo claro' : 'Modo oscuro',
            onTap: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.lock_outline,
            title: 'Cambiar contraseña',
            onTap: () {
              Navigator.pop(context);
              context.push('/change-password');
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Divider(color: colors.borderColor, height: 1),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.settings_outlined,
            title: 'Configuración',
            onTap: () {
              Navigator.pop(context);
              context.showSnackBar('Próximamente');
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Divider(color: colors.borderColor, height: 1),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.logout,
            title: 'Cerrar sesión',
            isDestructive: true,
            onTap: () async {
              Navigator.pop(context);
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDrawerAvatar({
    required BuildContext context,
    required WidgetRef ref,
    required String name,
    File? profileImage,
  }) {
    final colors = context.appColors;
    
    return GestureDetector(
      onTap: () => _showImagePicker(context, ref),
      child: Stack(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: context.colorScheme.primary.withValues(alpha: 0.3),
                width: 3,
              ),
            ),
            child: CircleAvatar(
              radius: 37,
              backgroundColor: context.theme.scaffoldBackgroundColor,
              backgroundImage: profileImage != null 
                  ? FileImage(profileImage) 
                  : null,
              child: profileImage == null
                  ? Text(
                      name.initials,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.primary,
                      ),
                    )
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: colors.cardColor, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showImagePicker(BuildContext context, WidgetRef ref) async {
    final imagePickerService = ref.read(imagePickerServiceProvider);
    final file = await imagePickerService.showImageSourceDialog(context);
    
    if (file != null) {
      ref.read(profileImageProvider.notifier).setImage(file);
      if (context.mounted) {
        context.showSnackBar('Imagen de perfil actualizada');
      }
    }
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.error : context.colorScheme.primary;
    final textColor = isDestructive ? AppColors.error : context.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
