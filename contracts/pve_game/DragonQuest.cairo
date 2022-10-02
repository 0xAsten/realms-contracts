// -----------------------------------
//      Module.DragonQuest

// MIT License
// -----------------------------------


%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math_cmp import is_le

from openzeppelin.upgrades.library import Proxy

from contracts.pve_game.library import DragonQuest, Xoroshiro_address, Adventurer_address, Action, PALYER, OPPOSITE
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
}(adventurerId: felt) {
    let (adventurer_address) = Adventurer_address.read();
    DragonQuest.assert_only_token_owner(adventurerId, adventurer_address);

    let (adventurer) = IAdventurer.getAdventurerById(adventurer_address, adventurerId);


    return ();
}

func attack{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(adventurer: AdventurerState, adventurerHealth: felt, dragonHealth: felt) -> (result: felt){
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
    let (adventurerHealth, dragonHealth) = attack_action(PALYER, OPPOSITE, adventurer.Strength, Dragon.Dexterity, adventurer.Level, Dragon.Level, adventurerHealth, dragonHealth);

    // defend
    let (dragonHealth, adventurerHealth) = attack_action(OPPOSITE, PALYER, Dragon.Strength, adventurer.Dexterity, Dragon.Level, adventurer.Level, dragonHealth, adventurerHealth);

    let (r) = attack(adventurer, adventurerHealth, dragonHealth);

    return (result = r);
}

func attack_action{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} (
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

        // Action(
        //     Attacker = attacker,
        //     Defender = defender,
        //     ab = 0,
        //     ac = 0,
        //     Attacker_health = attackerHealth,
        //     Defender_health = defenderHealth,
        //     Damage = damage,
        // );

        tempvar defenderHealth = defenderHealth - damage*10;

        return (attackerHealth, defenderHealth);
    } else {
        let (ab) = DragonQuest.attack_bonus(attackerStrength, attackerLevel, roll_d20);
        let (ac) = DragonQuest.armor_class(defenderDexterity, defenderLevel);

        let is_hit = is_le(ac, ab);
        if(is_hit == 1){
            // Action(
            //     Attacker = attacker,
            //     Defender = defender,
            //     ab = ab,
            //     ac = ac,
            //     Attacker_health = attackerHealth,
            //     Defender_health = defenderHealth,
            //     Damage = damage,
            // );

            tempvar defenderHealth = defenderHealth - damage*10;

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