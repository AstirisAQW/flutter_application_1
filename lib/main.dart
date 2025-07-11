import 'dart:async';
import 'package:flutter/material.dart';
import 'app/view/widgets/bird_widget.dart'; // Make sure this path is correct

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Bird physics variables
  double birdY = 0;
  double initialPos = 0;
  double height = 0;
  double time = 0;
  double gravity = -4.9; // How strong gravity is
  double velocity = 3.5; // How strong the jump is

  // NEW: Bird rotation variable
  double birdRotation = 0;

  // Bird animation variables
  int birdFrame = 0;
  late Timer animationTimer;

  // Game state
  bool gameHasStarted = false;

  final List<String> birdAssets = [
    'assets/Flappy Bird Assets/Player/StyleBird1/Bird1-1.png',
    'assets/Flappy Bird Assets/Player/StyleBird1/Bird1-2.png',
    'assets/Flappy Bird Assets/Player/StyleBird1/Bird1-3.png',
    'assets/Flappy Bird Assets/Player/StyleBird1/Bird1-4.png',
  ];

  @override
  void initState() {
    super.initState();
    startBirdAnimation();
  }
  
  @override
  void dispose() {
    animationTimer.cancel();
    super.dispose();
  }

  void startBirdAnimation() {
    animationTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        birdFrame = (birdFrame + 1) % birdAssets.length;
      });
    });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
      // When jumping, tilt the bird slightly up
      birdRotation = -0.4; // A negative angle rotates counter-clockwise (up)
    });
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPos - height;

        // NEW: Calculate rotation
        // If the bird is falling, gradually increase its downward rotation
        // We clamp the value to prevent it from spinning too much
        if (height < 0) { // height < 0 means the bird is falling below its initial jump position
          birdRotation = (birdRotation + 0.05).clamp(-0.4, 1.0);
        }
      });
      
      if (birdY > 1.1) {
        timer.cancel();
        setState(() {
          gameHasStarted = false;
          birdY = 0;
          initialPos = 0;
          time = 0;
          birdRotation = 0; // Reset rotation on game over
        });
      }

      time += 0.1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Flappy Bird Assets/Background/Background1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Stack(
                    children: [
                      // The BirdWidget is now self-contained!
                      BirdWidget(
                        birdY: birdY,
                        birdRotation: birdRotation,
                      ),
                      if (!gameHasStarted)
                        const Align(
                          alignment: Alignment(0, -0.5),
                          child: Text(
                            'T A P   T O   P L A Y',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 15,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}