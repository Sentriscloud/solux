import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class Numpad extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final int maxLength;

  const Numpad({
    super.key,
    required this.onChanged,
    this.maxLength = 10,
  });

  @override
  State<Numpad> createState() => _NumpadState();
}

class _NumpadState extends State<Numpad> {
  String _value = '';

  void _tap(String key) {
    setState(() {
      if (key == '⌫') {
        if (_value.isNotEmpty) _value = _value.substring(0, _value.length - 1);
      } else if (key == '.') {
        if (!_value.contains('.') && _value.length < widget.maxLength) {
          _value = _value.isEmpty ? '0.' : '$_value.';
        }
      } else {
        if (_value.length < widget.maxLength) {
          if (_value == '0' && key != '.') {
            _value = key;
          } else {
            _value += key;
          }
        }
      }
    });
    widget.onChanged(_value);
  }

  @override
  Widget build(BuildContext context) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', '⌫'];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: keys.length,
      itemBuilder: (_, i) {
        final key = keys[i];
        final isBackspace = key == '⌫';
        return GestureDetector(
          onTap: () => _tap(key),
          child: Container(
            decoration: BoxDecoration(
              color: isBackspace
                  ? AppColors.glassPrimary
                  : AppColors.glassShimmer,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.glassBorder,
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: isBackspace
                ? const Icon(
                    Icons.backspace_outlined,
                    color: AppColors.textSecondary,
                    size: 20,
                  )
                : Text(
                    key,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
