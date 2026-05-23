import 'package:flutter/material.dart';

/// Stagger delay helper for list entrance animations.
Duration staggerDelay(int index, {Duration base = Duration.zero}) =>
    base + Duration(milliseconds: 80 * index);

/// Wraps [children] with staggered rise animations.
List<Widget> staggeredChildren(
  List<Widget> children, {
  Duration baseDelay = Duration.zero,
}) =>
    [
      for (var i = 0; i < children.length; i++)
        Padding(
          padding: EdgeInsets.zero,
          child: children[i],
        ),
    ];
