import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tap_tap/level/score.dart';
import 'package:tap_tap/style/palette.dart';
import 'package:provider/provider.dart';
import 'package:tap_tap/style/responsive_screen.dart';
import 'package:tap_tap/style/rough/button.dart';

class WinScreen extends StatelessWidget {
  final Score score;

  const WinScreen({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    const gap = SizedBox(height: 10);

    return Scaffold(
      backgroundColor: palette.backgroundPlaySession,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            gap,
            const Center(
              child: Text(
                'You won!',
                style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 50),
              ),
            ),
            gap,
            Center(
              child: Text(
                'Score: ${score.score}\n'
                    'Time: ${score.formattedTime}',
                style: const TextStyle(
                    fontFamily: 'Permanent Marker', fontSize: 20),
              ),
            ),
          ],
        ),
        rectangularMenuArea: RoughButton(
          onTap: () {
            GoRouter.of(context).pop();
          },
          textColor: palette.ink,
          child: const Text('Continue'),
        ),
      ),
    );
  }
}
