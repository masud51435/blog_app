import 'package:flutter/material.dart';


class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.onPress,
    this.loading = false,
    this.color = Colors.blue,
    required this.title,
    required this.style,
  });
  final VoidCallback onPress;
  final bool loading;
  final String title;
  final TextStyle style;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20,
                ),
              ),
            ),
          ),
          onPressed: loading ? null : onPress,
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Text(
                  title,
                  style: style,
                ),
        ),
      ),
    );
  }
}
