// BUILDINGS LIBRARY
//   functions for
//
//
// MIT License

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.uint256 import Uint256, uint256_check
from starkware.starknet.common.syscalls import get_caller_address

from openzeppelin.token.erc721.IERC721 import IERC721

from contracts.settling_game.interfaces.ixoroshiro import IXoroshiro


@storage_var
func Xoroshiro_address() -> (address: felt) {
}

@storage_var
func Adventurer_address() -> (address: felt) {
}

const PALYER = 0;
const OPPOSITE = 1;

struct Action{
    Attacker: felt,
    Defender: felt,
    ab: felt,
    ac: felt,
    Attacker_health: felt,
    Defender_health: felt,
    Damage: felt,
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

        return (modifer = q - 5);
    }

    // roll a d{x} 
    func roll_dice{
        range_check_ptr, 
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*
    }(x: felt) -> (r: felt) {
        alloc_locals;
        let (xoroshiro_address_) = Xoroshiro_address.read();
        let (rnd) = IXoroshiro.next(xoroshiro_address_);

        let (_, r) = unsigned_div_rem(rnd, x);
        return (r = r + 1); 
    }

    // get attack bonus
    // increases by 1 for each level
    func attack_bonus{
        range_check_ptr, 
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*
    }(str: felt, level: felt, roll_d20: felt) -> (ab: felt) {
        alloc_locals;
        let (modifer) = ability_modifier(str);

        return (ab = roll_d20 + modifer + level);
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

        return (ac = 10 + modifer + q);
    }

    // calculate damage
    func damage{
        range_check_ptr, 
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*
    } (str: felt) -> (damage: felt) {
        alloc_locals;
        let (modifer) = ability_modifier(str);
        let (r) = roll_dice(6);

        let is_le0 = is_le(modifer + r,  0);
        if (is_le0 == 1) {
            return (damage = 1);
        }

        return (damage = modifer + r);
    }

    func assert_only_token_owner{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*, 
        range_check_ptr
    }(tokenId: Uint256, address: felt) {
        uint256_check(tokenId);
        let (caller) = get_caller_address();
        let (owner) = IERC721.ownerOf(address, tokenId);

        with_attr error_message("ERC721: caller is not the token owner") {
            assert caller = owner;
        }
        return ();
    }

}