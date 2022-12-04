import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tap_tap/level/levels.dart';
import 'package:tap_tap/settings/settings_screen.dart';
import 'package:tap_tap/style/ink_transition.dart';
import 'package:tap_tap/style/palette.dart';

// import 'package:tap_tap/games_services/games_services.dart';
// import 'package:tap_tap/games_services/score.dart';
// import 'package:tap_tap/in_app_purchase/in_app_purchase.dart';
// import 'package:tap_tap/level_selection/level_selection_screen.dart';
// import 'package:tap_tap/level_selection/levels.dart';
// import 'package:tap_tap/main_menu/main_menu_screen.dart';
// import 'package:tap_tap/play_session/play_session_screen.dart';
// import 'package:tap_tap/win_game/win_game_screen.dart';

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
                child: const LevelSelectionScreen(
                    key: Key('level selection')),
                color: context.watch<Palette>().backgroundLevelSelection,
              ),
              routes: [
                GoRoute(
                  path: 'session/:level',
                  pageBuilder: (context, state) {
                    final levelNumber = int.parse(state.params['level']!);
                    final level = gameLevels
                        .singleWhere((e) => e.number == levelNumber);
                    return buildTransition(
                      child: PlaySessionScreen(
                        level,
                        key: const Key('play session'),
                      ),
                      color: context.watch<Palette>().backgroundPlaySession,
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
                      child: WinGameScreen(
                        score: score,
                        key: const Key('win game'),
                      ),
                      color: context.watch<Palette>().backgroundPlaySession,
                      flipHorizontally: true,
                    );
                  },
                )
              ]),
          GoRoute(
            path: 'settings',
            builder: (context, state) =>
            const SettingsScreen(key: Key('settings')),
          ),
        ]),
  ],
);
