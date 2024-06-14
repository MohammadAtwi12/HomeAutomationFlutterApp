import 'dart:async';
import 'package:flicky/features/login_signup/loginpage.dart';
import 'package:flicky/helpers/utils.dart';
import 'package:flicky/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart' as rive;

class LoadingPage extends ConsumerStatefulWidget {
  
  static const String route = '/loading';
  const LoadingPage({super.key});

  @override
  ConsumerState<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends ConsumerState<LoadingPage> {
  late rive.StateMachineController smController;
  late rive.RiveAnimation animation;
  Map<Brightness, rive.SMIBool> states = {};
  bool isInitialized = false;
  Timer loadingTimer = Timer(Duration.zero,(){});

  @override
  void initState() {
    super.initState();

    animation = rive.RiveAnimation.asset(
      './assets/anims/flicky.riv',
      artboard: 'flickylogo',
      fit: BoxFit.contain,
      onInit: onRiveInit,
    );
  }

  void onRiveInit(rive.Artboard artboard) {
    
    smController = rive.StateMachineController.fromArtboard(
      artboard,
        'flickylogo'
      )!;
    
    artboard.addController(smController);

    for(var theme in Brightness.values) {
      states[theme] = smController.findInput<bool>(theme.name) as rive.SMIBool;
      states[theme]!.value = false;
    }

    setState(() {
      isInitialized = true;
      //states[MediaQuery.platformBrightnessOf(context)]!.value = true;
    });
  }
  @override
  Widget build(BuildContext context){
    final theme = MediaQuery.platformBrightnessOf(context);

    if (isInitialized) {

      for(var valueThemes in Brightness.values) {
        states[valueThemes]!.value = theme == valueThemes;
      }
    }

    loadingTimer = Timer(const Duration(seconds: 2),(){
      GoRouter.of(Utils.mainNav.currentContext!).go(LoginPage.route);
    });


    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: HomeAutomationStyles.loadingIconSize,
              height: HomeAutomationStyles.loadingIconSize,
              child: animation),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    loadingTimer.cancel();
    super.dispose();
  }

}
