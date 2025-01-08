import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    required this.state,
  });

  final bool state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2,
      child: (state) ? const LinearProgressIndicator() : null,
    );
  }
}
