// monster.dart
import 'dart:math';

class Monster {
  String name; // 몬스터의 이름
  int health; // 몬스터의 체력
  int maxAttack; // 몬스터의 최대 공격력 (랜덤 공격력을 생성하기 위한 값)
  int defense; // 몬스터의 방어력
  int turnCounter = 0; // 방어력 증가를 위한 턴 카운터

  // Monster 클래스의 생성자
  Monster(this.name, this.health, this.maxAttack, this.defense);

  // 몬스터의 랜덤 공격력을 반환하는 함수
  int getRandomAttack() {
    return Random().nextInt(maxAttack) + 1; // 1에서 maxAttack 사이의 값을 반환
  }

  // 3턴마다 방어력을 증가시키는 함수
  void increaseDefenseEveryThreeTurns() {
    turnCounter++; // 턴 카운트 증가
    if (turnCounter % 3 == 0) { // 3턴마다 방어력 증가
      defense += 2; // 방어력 2 증가
      print('$name의 방어력이 증가했습니다! 현재 방어력: $defense');
    }
  }
}
