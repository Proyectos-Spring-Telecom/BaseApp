import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/providers.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final profileImage = ref.watch(profileImageProvider);
    final colors = context.appColors;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildAvatar(
            context: context,
            ref: ref,
            name: user?.name ?? 'Usuario',
            profileImage: profileImage,
          ),
          const SizedBox(height: 16),
          Text(
            user?.name ?? 'Usuario',
            style: context.textTheme.headlineSmall?.copyWith(
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
          const SizedBox(height: 12),
          _buildActiveTag(context),
          const SizedBox(height: 24),
          _buildEditProfileButton(context),
          const SizedBox(height: 32),
          _buildMenuItem(
            context: context,
            icon: Icons.person_outline,
            title: 'Mi Perfil',
            onTap: () => context.push('/profile'),
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.settings_outlined,
            title: 'Configuración',
            onTap: () => context.showSnackBar('Próximamente'),
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.lock_outline,
            title: 'Cambiar contraseña',
            onTap: () => context.push('/change-password'),
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.description_outlined,
            title: 'Términos y Condiciones',
            onTap: () => context.showSnackBar('Próximamente'),
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.help_outline,
            title: 'Ayuda y Soporte',
            onTap: () => context.showSnackBar('Próximamente'),
          ),
          const SizedBox(height: 16),
          _buildLogoutButton(context, ref),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAvatar({
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
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: context.colorScheme.primary.withValues(alpha: 0.3),
                width: 3,
              ),
            ),
            child: CircleAvatar(
              radius: 52,
              backgroundColor: colors.cardColor,
              backgroundImage: profileImage != null 
                  ? FileImage(profileImage) 
                  : null,
              child: profileImage == null
                  ? Text(
                      name.initials,
                      style: TextStyle(
                        fontSize: 36,
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
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.theme.scaffoldBackgroundColor,
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 18,
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

  Widget _buildActiveTag(BuildContext context) {
    final successColor = context.appColors.successColor;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: successColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: successColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 14,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Activo',
            style: TextStyle(
              color: successColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () => context.push('/profile'),
        child: const Text(
          'Editar Perfil',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final colors = context.appColors;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderColor),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: context.colorScheme.primary,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: context.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderColor),
      ),
      child: ListTile(
        onTap: () async {
          await ref.read(authControllerProvider.notifier).logout();
          if (context.mounted) {
            context.go('/login');
          }
        },
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.logout,
            color: AppColors.error,
            size: 22,
          ),
        ),
        title: const Text(
          'Cerrar Sesión',
          style: TextStyle(
            color: AppColors.error,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
