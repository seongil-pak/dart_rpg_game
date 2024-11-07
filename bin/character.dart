// character.dart
import 'dart:math';

class Character {
  String name; // 캐릭터의 이름
  int health; // 캐릭터의 체력
  int attack; // 캐릭터의 공격력
  int defense; // 캐릭터의 방어력
  bool hasUsedItem = false; // 특수 아이템 사용 여부를 저장하는 변수

  // Character 클래스의 생성자
  Character(this.name, this.health, this.attack, this.defense);

  // 보너스 체력을 추가하는 함수 (30% 확률로 체력 10 증가)
  void applyHealthBonus() {
    if (Random().nextDouble() <= 0.3) { // 30% 확률 체크
      health += 10; // 체력 10 증가
      print('보너스 체력을 얻었습니다! 현재 체력: $health');
    }
  }

  // 특수 아이템을 사용하여 캐릭터의 공격력을 두 배로 만드는 함수
  void useSpecialItem() {
    if (!hasUsedItem) { // 이미 사용한 경우는 다시 사용할 수 없도록 제한
      attack *= 2; // 공격력 두 배
      hasUsedItem = true; // 아이템 사용 표시
      print('$name이 특수 아이템을 사용하여 공격력이 두 배가 되었습니다!');
    } else {
      print('이미 아이템을 사용하였습니다.');
    }
  }
}
