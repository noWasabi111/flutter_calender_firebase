import 'package:flutter/material.dart';

const backgroundColor = Color(0xFFe3dfd6);
const lighter = Color(0xFFe5e2da);
const TextColor = Color(0xFF1d454d);
const selectColor = Color(0xFFc15123);
const eventColor = Color(0XFFc8a086);

class MySeparator extends StatelessWidget {
  const MySeparator({super.key, this.height = 1, this.width = 10.0, this.color = Colors.black});
  final double height;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = width;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}