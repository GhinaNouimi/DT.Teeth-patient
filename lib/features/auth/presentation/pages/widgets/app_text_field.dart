import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final _fieldKey = GlobalKey<FormFieldState<String>>();

  late bool _isObscure;
  bool _isFocused = false;
  Locale? _lastLocale;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentLocale = Localizations.localeOf(context);

    if (_lastLocale != null && _lastLocale != currentLocale) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        final fieldState = _fieldKey.currentState;
        if (fieldState != null && fieldState.hasError) {
          fieldState.validate();
        }
      });
    }

    _lastLocale = currentLocale;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMultiline = !widget.obscureText && widget.maxLines > 1;
    final effectiveKeyboardType = isMultiline
        ? TextInputType.multiline
        : widget.keyboardType;

    return Focus(
      onFocusChange: (value) => setState(() => _isFocused = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withValues(
                alpha: _isFocused ? 0.16 : 0.08,
              ),
              theme.colorScheme.secondary.withValues(
                alpha: _isFocused ? 0.14 : 0.06,
              ),
            ],
          ),
          border: Border.all(
            color: _isFocused
                ? theme.colorScheme.primary.withValues(alpha: 0.65)
                : theme.colorScheme.outline.withValues(alpha: 0.45),
            width: _isFocused ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(
                alpha: _isFocused ? 0.14 : 0.06,
              ),
              blurRadius: _isFocused ? 22 : 14,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: TextFormField(
          key: _fieldKey,
          controller: widget.controller,
          validator: widget.validator,
          obscureText: _isObscure,
          keyboardType: effectiveKeyboardType,
          textInputAction:
          isMultiline ? TextInputAction.newline : widget.textInputAction,
          onChanged: widget.onChanged,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(start: 10, end: 6),
              child: Icon(widget.prefixIcon),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 44),
            suffixIcon: widget.obscureText
                ? IconButton(
              onPressed: () => setState(() => _isObscure = !_isObscure),
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  _isObscure
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  key: ValueKey(_isObscure),
                ),
              ),
            )
                : (widget.readOnly && widget.onTap != null)
                ? Icon(
              Icons.keyboard_arrow_down_rounded,
              color: theme.colorScheme.primary.withValues(alpha: 0.8),
            )
                : null,
          ),
        ),
      ),
    );
  }
}