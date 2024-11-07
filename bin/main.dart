// main.dart
import 'dart:io';
import 'dart:math';
import 'character.dart';
import 'monster.dart';

// Game 클래스: 게임 전체 흐름과 주요 로직을 관리하는 클래스
class Game {
  Character character; // 플레이어 캐릭터
  List<Monster> monsters = []; // 몬스터 리스트
  int defeatedMonsters = 0; // 물리친 몬스터 개수

  Game(this.character, this.monsters);

  // 캐릭터 데이터를 파일에서 불러오는 정적 함수
  static Character loadCharacter() {
    try {
      final file = File('characters.txt'); // 파일 불러오기
      final contents = file.readAsStringSync();
      final stats = contents.split(','); // CSV 형태로 데이터 분리
      if (stats.length != 3) throw FormatException('잘못된 캐릭터 데이터입니다.');

      int health = int.parse(stats[0]);
      int attack = int.parse(stats[1]);
      int defense = int.parse(stats[2]);

      // 캐릭터 이름 입력받기
      stdout.write('캐릭터의 이름을 입력하세요: ');
      String name = stdin.readLineSync()!;
      Character character = Character(name, health, attack, defense);
      character.applyHealthBonus(); // 30% 확률로 체력 보너스 적용
      return character;
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  // 몬스터 데이터를 파일에서 불러오는 정적 함수
  static List<Monster> loadMonsters() {
    try {
      final file = File('monsters.txt');
      final contents = file.readAsLinesSync(); // 각 줄을 리스트 형태로 불러오기
      return contents.map((line) {
        final stats = line.split(',');
        if (stats.length != 3) throw FormatException('잘못된 몬스터 데이터입니다.');

        String name = stats[0];
        int health = int.parse(stats[1]);
        int maxAttack = int.parse(stats[2]);
        return Monster(name, health, maxAttack, 0);
      }).toList();
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  // 게임 시작 메서드
  void startGame() {
    print('게임을 시작합니다!');
    while (character.health > 0 && defeatedMonsters < monsters.length) {
      Monster monster = getRandomMonster(); // 랜덤 몬스터 선택
      bool result = battle(monster); // 전투 시작
      if (result) {
        defeatedMonsters++;
        if (defeatedMonsters >= monsters.length) {
          print('축하합니다! 모든 몬스터를 물리쳤습니다!');
          saveResult('승리'); // 게임 승리 결과 저장
          return;
        }
      } else {
        saveResult('패배'); // 게임 패배 결과 저장
        print('게임 오버!');
        return;
      }
    }
  }

  // 전투 메서드
  bool battle(Monster monster) {
    print('${monster.name}가 나타났습니다! 체력: ${monster.health}, 방어력: ${monster.defense}');
    while (character.health > 0 && monster.health > 0) {
      stdout.write('행동을 선택하세요: 공격하기(1), 방어하기(2), 아이템 사용(3): ');
      String? choice = stdin.readLineSync();
      switch (choice) {
        case '1':
          int damage = character.attack - monster.defense; // 방어력 고려하여 데미지 계산
          if (damage > 0) monster.health -= damage;
          print('${character.name}의 공격! ${monster.name}에게 ${damage}의 데미지를 입혔습니다.');
          break;
        case '2':
          print('${character.name}이 방어 태세를 취했습니다.');
          break;
        case '3':
          character.useSpecialItem(); // 특수 아이템 사용
          break;
        default:
          print('잘못된 선택입니다.');
          continue;
      }
      if (monster.health <= 0) {
        print('${monster.name}를 물리쳤습니다!');
        return true;
      }
      monster.increaseDefenseEveryThreeTurns(); // 3턴마다 방어력 증가
      int monsterAttack = monster.getRandomAttack(); // 랜덤 공격력 계산
      character.health -= monsterAttack; // 캐릭터의 체력 감소
      print('${monster.name}의 공격! ${character.name}에게 ${monsterAttack}의 데미지를 입었습니다. 남은 체력: ${character.health}');
      if (character.health <= 0) {
        print('${character.name}이 쓰러졌습니다.');
        return false;
      }
    }
    return false;
  }

  // 랜덤으로 몬스터를 선택하는 메서드
  Monster getRandomMonster() {
    Random random = Random();
    return monsters.removeAt(random.nextInt(monsters.length));
  }

  // 게임 결과를 파일에 저장하는 메서드
  void saveResult(String result) {
    stdout.write('결과를 저장하시겠습니까? (y/n): ');
    String? choice = stdin.readLineSync();
    if (choice?.toLowerCase() == 'y') {
      final file = File('result.txt');
      file.writeAsStringSync('캐릭터 이름: ${character.name}, 남은 체력: ${character.health}, 게임 결과: $result');
      print('결과가 저장되었습니다.');
    }
  }
}

// main 함수: 게임 시작
void main() {
  Character character = Game.loadCharacter(); // 캐릭터 데이터 로드
  List<Monster> monsters = Game.loadMonsters(); // 몬스터 데이터 로드
  Game game = Game(character, monsters); // 게임 인스턴스 생성
  game.startGame(); // 게임 시작
}
