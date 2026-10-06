import 'package:flutter/material.dart';
import 'package:shodasha_mineral_water/core/constants/app_constants.dart';
import 'package:shodasha_mineral_water/core/theme/app_theme.dart';

class WalletScreenHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;

  const WalletScreenHeader({super.key, this.onBackPressed});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: AppColors.surface,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: 8,
        ),
        child: Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onBackPressed ?? () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
                child: Container(
                  width: AppConstants.minTapTarget,
                  height: AppConstants.minTapTarget,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: AppConstants.iconSize,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Wallet & Can Tracking',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
