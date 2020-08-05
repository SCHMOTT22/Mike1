import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedCard extends StatelessWidget {
  RoundedCard({
    this.margin,
    this.padding,
    this.child,
    this.color,
  });

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: child,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(const Radius.circular(8)),
        color: color ?? Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16.0, // has the effect of softening the shadow
            spreadRadius: 4.0, // has the effect of extending the shadow
            offset: Offset(
              2.0, // horizontal, move right 10
              2.0, // vertical, move down 10
            ),
          )
        ],
      ),
    );
  }
}
