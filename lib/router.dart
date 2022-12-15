import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tap_tap/level/levels.dart';
import 'package:tap_tap/level/score.dart';
import 'package:tap_tap/screen/level_selection_screen.dart';
import 'package:tap_tap/screen/main_menu_screen.dart';
import 'package:tap_tap/screen/play_screen.dart';
import 'package:tap_tap/screen/settings_screen.dart';
import 'package:tap_tap/screen/win_screen.dart';
import 'package:tap_tap/style/ink_transition.dart';
import 'package:tap_tap/style/palette.dart';

/// issue: https://github.com/flutter/flutter/issues/99663

final router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) =>
            const MainMenuScreen(key: Key('main menu')),
        routes: [
          GoRoute(
            path: 'play',
            pageBuilder: (context, state) => buildTransition(
              child: const LevelSelectionScreen(key: Key('level selection')),
              color: context.watch<Palette>().backgroundLevelSelection,
            ),
            routes: [
              GoRoute(
                path: 'session/:level',
                pageBuilder: (context, state) {
                  final levelNumber = int.parse(state.params['level']!);
                  final level =
                      gameLevels.singleWhere((e) => e.number == levelNumber);
                  return buildTransition(
                    child: PlayScreen(
                      level: level,
                      key: const Key('play session'),
                    ),
                    color: context.watch<Palette>().purplePen,
                    flipHorizontally: true,
                  );
                },
              ),
              GoRoute(
                path: 'won',
                pageBuilder: (context, state) {
                  final map = state.extra! as Map<String, dynamic>;
                  final score = map['score'] as Score;

                  return buildTransition(
                    child: WinScreen(
                      score: score,
                      key: const Key('win game'),
                    ),
                    color: context.watch<Palette>().backgroundPlaySession,
                    flipHorizontally: true,
                  );
                },
              )
            ],
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) =>
                const SettingsScreen(key: Key('settings')),
          ),
        ]),
  ],
);
