import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:tap_tap/audio/sounds.dart';
import 'package:tap_tap/settings/settings.dart';
import 'package:tap_tap/style/delayed_appear.dart';
import 'package:tap_tap/style/palette.dart';
import 'package:tap_tap/style/responsive_screen.dart';
import 'package:tap_tap/style/rough/button.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  late final palette = context.watch<Palette>();
  late final settingsController = context.watch<SettingsController>();

  Artboard? _riveArtBoard;
  SMIInput<bool>? _riveWolvieBerserker;
  SMIInput<bool>? _riveWolvieWalk;
  SMIInput<bool>? _riveWolvieDirectionRight;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();

    rootBundle.load('assets/rive/wolvie.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artBoard = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(artBoard, 'State Machine 1');
        if (controller != null) {
          artBoard.addController(controller);
          _riveWolvieBerserker =
              controller.findInput<bool>('berserkerRage') as SMIBool;
          _riveWolvieWalk = controller.findInput<bool>('walk') as SMIBool;
          _riveWolvieDirectionRight =
              controller.findInput<bool>('direction(defaultRight)') as SMIBool;
        }
        setState(() => _riveArtBoard = artBoard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: palette.purplePen,
      body: ResponsiveScreen(
        // mainAreaProminence: 0.45,
        squarishMainArea: DelayedAppear(
          ms: 1000,
          child: Center(
            child: Transform.scale(
              scale: 1.5,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Stack(
                    children: [
                      PositionedTransition(
                        rect: RelativeRectTween(
                          begin: RelativeRect.fromSize(
                            const Rect.fromLTWH(0, 0, 120, 120),
                            const Size(120, 120),
                          ),
                          end: RelativeRect.fromSize(
                              Rect.fromLTWH(constraints.maxWidth, 0, 120, 120),
                              const Size(120, 120)),
                        ).animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: Curves.easeIn,
                          ),
                        ),
                        child: _riveArtBoard != null
                            ? Rive(
                                artboard: _riveArtBoard!,
                              )
                            : Container(),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 102),
                          child: Text(
                            "Tap - Tap",
                            style: GoogleFonts.shrikhand(
                              color: Colors.white,
                              fontSize: 34,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DelayedAppear(
              ms: 800,
              child: RoughButton(
                onTap: onClickPlay,
                drawRectangle: true,
                textColor: palette.redPen,
                fontSize: 36,
                soundEffect: SfxType.erase,
                child: const Text('Play'),
              ),
            ),
            DelayedAppear(
              ms: 600,
              child: RoughButton(
                onTap: onClickAchievement,
                child: const Text('Achievements'),
              ),
            ),
            DelayedAppear(
              ms: 200,
              child: RoughButton(
                onTap: onClickSetting,
                child: const Text('Settings'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ValueListenableBuilder<bool>(
                valueListenable: settingsController.muted,
                builder: (context, muted, child) {
                  return IconButton(
                    onPressed: () => settingsController.toggleMuted(),
                    icon: Icon(
                      muted ? Icons.volume_off : Icons.volume_up,
                      color: palette.trueWhite,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  onClickPlay() async {
    _riveWolvieBerserker?.value = true;
    _riveWolvieWalk?.value = true;
    await _controller.forward();
    // ignore: use_build_context_synchronously
    GoRouter.of(context).go('/play');
  }

  onClickAchievement() async {}

  onClickSetting() async {
    _riveWolvieBerserker?.value = true;
    _riveWolvieWalk?.value = true;
    await _controller.forward();
    // ignore: use_build_context_synchronously
    GoRouter.of(context).go('/settings');
  }
}
