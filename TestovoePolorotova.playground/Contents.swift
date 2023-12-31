import PlaygroundSupport

class Entity {
    
    let attack, protection : UInt8
    var maximumHealth, health: Int
    let damage: ClosedRange<Int>
    
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
    func takeDamage(damage: Int) {
        health = health - damage
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
    func healing() {
        if remainsOfHealing > 0 {
            health = Int(Double (health) + Double (maximumHealth) * 0.3)
            remainsOfHealing = remainsOfHealing - 1
            
            if health > maximumHealth {
                health = maximumHealth
            }
        }
    }
}

class Monster: Entity {
}

class Game {
    // играем
    func game() {
        var playerAttack = true
        
        var player = Player(attack: 25, protection: 14, health: 40, minDamage: 1, maxDamage: 10)
        var monster = Monster(attack: 28, protection: 15, health: 50, minDamage: 1, maxDamage: 22)
        
        if player != nil && monster != nil {
            // цикл игры
            repeat {
                if playerAttack {
                    attack(attacker: player!, defender: monster!)
                    playerAttack = false
                } else {
                    attack(attacker: monster!, defender: player!)
                    player!.healing()
                    playerAttack = true
                }
            } while player!.health > 0 && monster!.health > 0
            
            if player!.health <= 0 {
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
        return Int(attacker.attack - defender.protection + 1)
    }
    // бросаем кубики и получаем урон
    private func attack(attacker: Entity, defender: Entity) {
        var attack = modificationAttack(attacker: attacker, defender: defender)
        
        for _ in 1...attack {
            var randomInt = Int.random(in: 1...6)
            
            if randomInt == 5 || randomInt == 6 {
                var randomDamage = Int.random(in: attacker.damage)
                defender.takeDamage(damage: randomDamage)
                break
            }
        }
    }
}

let game = Game()
game.game()
