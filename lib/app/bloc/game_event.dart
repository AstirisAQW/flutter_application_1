abstract class GameEvent {
  const GameEvent();
}

class GameInitialized extends GameEvent {}

class GameStarted extends GameEvent {}

class BirdJumped extends GameEvent {}

class _GameTick extends GameEvent {
  final double deltaTime;
  const _GameTick(this.deltaTime);
}

class GameOver extends GameEvent {}