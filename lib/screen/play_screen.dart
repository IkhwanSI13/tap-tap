import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:tap_tap/audio/audio_controller.dart';
import 'package:tap_tap/audio/sounds.dart';
import 'package:tap_tap/level/levels.dart';
import 'package:tap_tap/level/score.dart';
import 'package:tap_tap/style/delayed_appear.dart';
import 'package:tap_tap/style/palette.dart';
import 'package:tap_tap/style/responsive_screen.dart';
import 'package:tap_tap/style/rough/button.dart';

class PlayScreen extends StatefulWidget {
  final GameLevel level;

  const PlayScreen({
    required this.level,
    super.key,
  });

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late Palette palette = context.watch<Palette>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: palette.purplePen,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          children: [
            DelayedAppear(
              ms: ScreenDelays.first,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Select wolvie in walk state',
                    style: TextStyle(
                      fontFamily: 'Permanent Marker',
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _BoardGame(
                level: widget.level.number,
              ),
            ),
          ],
        ),
        rectangularMenuArea: DelayedAppear(
          ms: ScreenDelays.fourth,
          child: RoughButton(
            onTap: () {
              GoRouter.of(context).pop();
            },
            textColor: palette.ink,
            child: const Text('Back'),
          ),
        ),
      ),
    );
  }
}

///
class _BoardGame extends StatefulWidget {
  final int level;

  const _BoardGame({
    required this.level,
    super.key,
  });

  @override
  State<_BoardGame> createState() => _BoardGameState();
}

class _BoardGameState extends State<_BoardGame> {
  late DateTime _startOfPlay;
  int _selected = 0;
  int _wolvieRun = 0;
  int _keyGenerate = 2;

  @override
  void initState() {
    super.initState();
    _startOfPlay = DateTime.now();
    _wolvieRun = _getRandomRun();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$_selected / 10 selected',
          style: const TextStyle(
            fontFamily: 'Permanent Marker',
            fontSize: 32,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
            child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          padding: EdgeInsets.zero,
          itemCount: widget.level * 2,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            var number = index + 1;
            return _WolvieRiv(
              key: ValueKey("Wolvie$_keyGenerate$index"),
              _wolvieRun == number,
              () {
                _onClickWolvie(number);
              },
            );
          },
        ))
      ],
    );
  }

  void _onClickWolvie(int number) {
    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.buttonTap);

    _keyGenerate++;
    if (_wolvieRun == number) {
      _selected++;
    } else {
      _selected--;
    }

    ///
    if (_selected == 10) {
      _onWin();
    } else {
      setState(() {
        _wolvieRun = _getRandomRun();
      });
    }
  }

  void _onWin() {
    final score = Score(
      widget.level,
      DateTime.now().difference(_startOfPlay),
    );

    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.congrats);

    GoRouter.of(context).go('/play/won', extra: {'score': score});
  }

  int _getRandomRun() {
    var rnd = Random();
    int min = 1;
    int max = (widget.level * 2) + 1;
    return min + rnd.nextInt(max - min);
  }
}

///
class _WolvieRiv extends StatelessWidget {
  final bool isWalk;
  final Function() onClick;

  _WolvieRiv(this.isWalk, this.onClick, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: RiveAnimation.asset(
        "assets/rive/wolvie.riv",
        animations: [isWalk ? "walk" : "idle"],
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
