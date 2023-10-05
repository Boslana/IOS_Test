
import PlaygroundSupport

class Entity {
    
    public let attack, protection : UInt8?
    public var maximumHealth, health: Int?
    public let damage: ClosedRange<Int>?
    
    init?(attack: UInt8, protection: UInt8, health: Int, minDamage: Int, maxDamage: Int) {
        // проверка входных данных
        guard Entity.checkAttack(attack: attack), Entity.checkProtection (protection:protection),
              Entity.checkHealth (health:health), Entity.checkDamage (minDamage:minDamage, maxDamage:maxDamage) else {
            print("Введите корректные значения")
            return nil
        }
        
        self.attack = attack // атака
        self.protection = protection // защита
        self.maximumHealth = health // максимальное здоровье
        self.health = health // текущее здоровье
        self.damage = minDamage...maxDamage // урон
    }
    // получаем урон
    public func takeDamage(damage: Int) {
        health = health! - damage
    }
    
    private static func checkAttack(attack: UInt8) -> Bool {
        return 1...30 ~= attack
    }
    
    private static func checkProtection(protection: UInt8) -> Bool {
        return 1...30 ~= protection
    }
    
    private static func checkHealth(health: Int) -> Bool {
        return health > 0
    }
    
    private static func checkDamage(minDamage: Int, maxDamage: Int) -> Bool {
        return minDamage > 0 && maxDamage > 0 && minDamage < maxDamage
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
        
        var player = Player(attack: 29, protection: 14, health: 20, minDamage: 1, maxDamage: 5)
        var monster = Monster(attack: 28, protection: 15, health: 15, minDamage: 1, maxDamage: 22)
        
        if player != nil && monster != nil {
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
        } else {
            print("Что-то пошло не так")
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

let game = Game()
game.game()
