import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

class TemporaTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TemporaTopAppBar({
    super.key,
    this.onSearchTap,
    this.onAddTap,
  });

  final VoidCallback? onSearchTap;
  final VoidCallback? onAddTap;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: preferredSize.height +
              MediaQuery.of(context).padding.top,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(100),
            border: Border(
              bottom: BorderSide(
                color: TemporaColors.rimLight,
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onSearchTap,
                  child: const Icon(
                    Symbols.search,
                    size: 24,
                    color: TemporaColors.cyan,
                    weight: 200,
                    fill: 0,
                  ),
                ),
                Text(
                  'ZEPHYR',
                  style: TemporaTextStyles.appBarTitle(),
                ),
                GestureDetector(
                  onTap: onAddTap,
                  child: const Icon(
                    Symbols.add,
                    size: 24,
                    color: TemporaColors.cyan,
                    weight: 200,
                    fill: 0,
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
