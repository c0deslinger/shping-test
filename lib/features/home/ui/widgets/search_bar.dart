import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../providers/photo_provider.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  static const double _borderRadius = 32.0;
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 8.0;

  final TextEditingController _controller = TextEditingController();
  bool _isFocused = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onClear() {
    _controller.clear();
    _getPhotoProvider.clearSearch();
  }

  void _onSubmitted(String value) {
    if (value.isNotEmpty) {
      _getPhotoProvider.searchPhotos(value);
    } else {
      _getPhotoProvider.fetchPhotos(refresh: true);
    }
  }

  PhotoProvider get _getPhotoProvider =>
      Provider.of<PhotoProvider>(context, listen: false);

  InputDecoration _buildInputDecoration(ColorScheme colorScheme) {
    return InputDecoration(
      hintText: 'home.search_hint'.tr(),
      hintStyle: TextStyle(
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        fontSize: 16,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: 16,
      ),
      filled: true,
      fillColor: colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(
          color: colorScheme.primary.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      prefixIcon: Icon(
        Icons.search_rounded,
        color: _isFocused ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
      suffixIcon: _buildSuffixIcon(colorScheme),
    );
  }

  Widget? _buildSuffixIcon(ColorScheme colorScheme) {
    return _controller.text.isNotEmpty
        ? IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
            onPressed: _onClear,
            splashRadius: 20,
            tooltip: 'Clear search',
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      child: Material(
        elevation: _isFocused ? 3 : 1,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(_borderRadius),
        color: colorScheme.surface,
        child: Focus(
          onFocusChange: (focused) => setState(() => _isFocused = focused),
          child: TextField(
            controller: _controller,
            onSubmitted: _onSubmitted,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
            cursorColor: colorScheme.primary,
            decoration: _buildInputDecoration(colorScheme),
          ),
        ),
      ),
    );
  }
}
