// BUILDINGS LIBRARY
//   functions for
//
//
// MIT License

%lang starknet

from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le


from contracts.settling_game.interfaces.ixoroshiro import IXoroshiro


@storage_var
func Xoroshiro_address() -> (address: felt) {
}

@storage_var
func Adventurer_address() -> (address: felt) {
}

namespace DragonQuest{

    func initializer{
            syscall_ptr : felt*,
            pedersen_ptr : HashBuiltin*,
            range_check_ptr
        }(
            xoroshiro_address: felt,
            adventurer_address: felt,
        ){
        Xoroshiro_address.write(xoroshiro_address);
        Adventurer_address.write(adventurer_address);
        return ();
    }

    // calculate the ability modifer 
    func ability_modifier{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*, 
        range_check_ptr
    } (score: felt) -> (modifer: felt) {
        let (q, _) = unsigned_div_rem(score, 2);

        return (q - 5);
    }

    // roll a d{x} 
    func roll_dice{
        range_check_ptr, 
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*
    }(x: felt) -> (r: felt) {
        alloc_locals;
        let (xoroshiro_address_) = xoroshiro_address.read();
        let (rnd) = IXoroshiro.next(xoroshiro_address_);

        let (_, r) = unsigned_div_rem(rnd, x);
        return (r + 1,); 
    }

    // get attack bonus
    // increases by 1 for each level
    func attack_bonus{
        range_check_ptr, 
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*
    }(str: felt, level: felt) -> (ab: felt, role: felt) {
        alloc_locals;
        let (roll_d20) = roll_dice(20);
        let (modifer) = ability_modifier(str);

        return (roll_d20 + modifer + level, role);
    }

    // get armor class
    // increases by 1 for every 5 levels
    func armor_class{
        range_check_ptr, 
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*
    }(dex: felt, level: felt) -> (ac: felt) {
        alloc_locals;
        let (modifer) = ability_modifier(dex);
        let (q, _) = unsigned_div_rem(level, 5);

        return (10 + modifer + q);
    }

    // calculate damage
    func damage{
        range_check_ptr, 
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*
    } (str: felt) -> () {
        alloc_locals;
        let (modifer) = ability_modifier(str);
        let (_, r) = unsigned_div_rem(level, 6);

        if (is_le(modifer + r,  0) == 1) {
            return (1);
        }

        return (modifer + r);
    }

}