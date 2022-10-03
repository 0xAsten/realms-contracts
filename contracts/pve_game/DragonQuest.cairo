// -----------------------------------
//      Module.DragonQuest

// MIT License
// -----------------------------------


%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.uint256 import Uint256

from openzeppelin.upgrades.library import Proxy

from contracts.pve_game.library import DragonQuest, Xoroshiro_address, Adventurer_address, Action, PALYER, OPPOSITE, Adventure_count
from contracts.loot.adventurer.IAdventurer import IAdventurer
from contracts.loot.constants.adventurer import AdventurerState

namespace Dragon {
    const Health = 200;
    const Level = 4;

    const Strength = 16;
    const Dexterity = 16;
    const Vitality = 16;
    const Intelligence = 16;
    const Wisdom = 16;
    const Charisma = 16;  
}

@event
func Attack(
    adventurerId: Uint256,
    count: felt,
    attacker: felt,
    defender: felt,
    ab: felt,
    ac: felt,
    attackerHealth: felt,
    defenderHealth: felt,
    damage: felt,
    roll_d20: felt,
    is_hit: felt,
) {
}

@external
func initializer{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(
        xoroshiro_address: felt,
        adventurer_address: felt,
        proxy_admin: felt
    ){
    DragonQuest.initializer(xoroshiro_address, adventurer_address);
    Proxy.initializer(proxy_admin);
    return ();
}

@external
func upgrade{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(new_implementation: felt){
    Proxy.assert_only_admin();
    Proxy._set_implementation_hash(new_implementation);
    return ();
}

@external
func combat{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(adventurerId: Uint256) {
    alloc_locals;

    let (adventurer_address) = Adventurer_address.read();
    DragonQuest.assert_only_token_owner(adventurerId, adventurer_address);

    let (adventurer) = IAdventurer.getAdventurerById(adventurer_address, adventurerId);
    
    let strength = adventurer.Strength;
    let is_le7 = is_le(strength, 7);
    if (is_le7 == 1) {
        tempvar strength = 8;
    } else {
        tempvar strength = strength;
    }

    let dexterity = adventurer.Dexterity;
    let is_le7 = is_le(dexterity, 7);
    if (is_le7 == 1) {
        tempvar dexterity = 8;
    }else {
        tempvar dexterity = dexterity;
    }

    let level = adventurer.Level;

    let (count) = Adventure_count.read(adventurerId);
    let count = count + 1;
    Adventure_count.write(adventurerId, count);

    attack(adventurerId, count, strength, dexterity, level, adventurer.Health, Dragon.Health);

    return ();
}

func attack{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
}(adventurerId: Uint256, count: felt, strength: felt, dexterity: felt, level: felt, adventurerHealth: felt, dragonHealth: felt) -> (result: felt){
    alloc_locals;

    let is_le0 = is_le(adventurerHealth, 0);
    if (is_le0 == 1) {
        return (result = 0);
    }

    let is_le0 = is_le(adventurerHealth, 0);
    if (is_le0 == 1) {
        return (result = 1);
    }

    // attack
    let (adventurerHealth, dragonHealth) = attack_action(adventurerId, count, PALYER, OPPOSITE, strength, Dragon.Dexterity, level, Dragon.Level, adventurerHealth, dragonHealth);

    // defend
    let (dragonHealth, adventurerHealth) = attack_action(adventurerId, count, OPPOSITE, PALYER, Dragon.Strength, dexterity, Dragon.Level, level, dragonHealth, adventurerHealth);

    let (r) = attack(adventurerId, count, strength, dexterity, level, adventurerHealth, dragonHealth);

    return (result = r);
}

func attack_action{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} (
    adventurerId: Uint256, 
    count: felt,
    attacker: felt,
    defender: felt,
    attackerStrength: felt, 
    defenderDexterity: felt, 
    attackerLevel: felt, 
    defenderLevel: felt, 
    attackerHealth: felt, 
    defenderHealth: felt,
) -> (attacker_health: felt, defender_health: felt) {
    let (roll_d20) = DragonQuest.roll_dice(20);
    let (damage) = DragonQuest.damage(attackerStrength);

    if (roll_d20 == 20) {
        tempvar damage = damage * 2;

        Attack.emit(
            adventurerId,
            count,
            attacker,
            defender,
            0,
            0,
            attackerHealth,
            defenderHealth,
            damage,
            roll_d20,
            1,
        );

        tempvar defenderHealth = defenderHealth - damage*5;

        return (attackerHealth, defenderHealth);
    } else {
        let (ab) = DragonQuest.attack_bonus(attackerStrength, attackerLevel, roll_d20);
        let (ac) = DragonQuest.armor_class(defenderDexterity, defenderLevel);

        let is_hit = is_le(ac, ab);

        Attack.emit(
            adventurerId,
            count,
            attacker,
            defender,
            ab,
            ac,
            attackerHealth,
            defenderHealth,
            damage,
            roll_d20,
            is_hit,
        );

        if(is_hit == 1){
            tempvar defenderHealth = defenderHealth - damage*5;

            return (attackerHealth, defenderHealth);
        }

        return (attackerHealth, defenderHealth);
    }
}

@external
func set_xoroshiro{ 
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(xoroshiro: felt) {
    Proxy.assert_only_admin();
    Xoroshiro_address.write(xoroshiro);
    return ();
}

@external
func set_adventurer{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(adventurer: felt) {
    Proxy.assert_only_admin();
    Adventurer_address.write(adventurer);
    return ();
}

@view
func get_count{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(adventurerId: Uint256) -> (count: felt) {
    return Adventure_count.read(adventurerId);
}

@view
func get_xoroshiro_address{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}() -> (address: felt) {
    return Xoroshiro_address.read();
}

@view
func get_adventurer_address{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}() -> (address: felt) {
    return Adventurer_address.read();
}