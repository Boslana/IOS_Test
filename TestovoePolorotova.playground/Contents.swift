
import PlaygroundSupport

class Entity {
    
    public let attack, protection : UInt8?
    public var maximumHealth, health: Int?
    public let damage: ClosedRange<Int>?
    
    init?(attack: UInt8, protection: UInt8, health: Int, damage: ClosedRange<Int>) {
        
        self.attack = attack // атака
        self.protection = protection // защита
        self.maximumHealth = health // максимальное здоровье
        self.health = health // текущее здоровье
        self.damage = damage // урон
        // проверка входных данных
        guard checkAttack(attack: attack), checkProtection (protection:protection),
              checkHealth (health:health), checkDamage (damage:damage) else {
            print("Введите корректные значения")
            return nil
        }
    }
    // получаем урон
    public func takeDamage(damage: Int) {
        health = health! - damage
    }
    
    private func checkAttack(attack: UInt8) -> Bool {
        return 1...30 ~= attack
    }
    
    private func checkProtection(protection: UInt8) -> Bool {
        return 1...30 ~= protection
    }
    
    private func checkHealth(health: Int) -> Bool {
        return health > 0
    }
    
    private func checkDamage(damage: ClosedRange<Int>) -> Bool {
        return damage.lowerBound > 0 && damage.upperBound > 0 && damage.lowerBound < damage.upperBound
    }
}

class Player: Entity {
    // начальное кол-во исцелений
    private var remainsOfHealing: Int = 4
    // хилимся
    public func healing() {
        if remainsOfHealing > 0 {
            health = Int(Double (health!) + Double (maximumHealth!) * 0.3)
            remainsOfHealing = remainsOfHealing - 1
        }
    }
}

class Monster: Entity {
}

class Game {
    // играем
    public func game() {
        var playerAttack = true
        
        var player = Player(attack: 29, protection: 14, health: 20, damage: 1...5)
        var monster = Monster(attack: 28, protection: 15, health: 15, damage: 1...22)
        // цикл игры
        repeat {
            if playerAttack {
                attacka(attacker: player!, defender: monster!)
                playerAttack = false
            } else {
                attacka(attacker: monster!, defender: player!)
                player!.healing()
                playerAttack = true
            }
        } while player!.health! > 0 && monster!.health! > 0
        
        if player!.health! < 0 {
            print("Монстр выиграл!")
        } else {
            print ("Игрок выиграл!")
        }
    }
    // расчет модификатора атаки
    private func modificationAttack (attacker: Entity, defender: Entity) -> Int {
        return Int(attacker.attack! - defender.protection! + 1)
    }
    // бросаем кубики и получаем урон
    private func attacka(attacker: Entity, defender: Entity) {
        var attack = modificationAttack(attacker: attacker, defender: defender)
        
        for _ in 1...attack {
            var randomInt = Int.random(in: 1...6)
            
            if randomInt == 5 || randomInt == 6 {
                var dam = Int.random(in: attacker.damage!)
                defender.takeDamage(damage: dam)
                break
            }
        }
    }
}

var game = Game()
game.game()

