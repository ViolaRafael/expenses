import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeButton extends StatelessWidget {
  final String? label;
  final Function()? onPressed;

  AdaptativeButton({
    this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? CupertinoButton(
            color: Theme.of(context).colorScheme.primary,
            child: Text(label!),
            onPressed: onPressed!,
      padding: EdgeInsets.symmetric(
        horizontal: 20
      ),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.secondary),
            child: Text(label!),
            onPressed: onPressed!,
          );
  }
}
