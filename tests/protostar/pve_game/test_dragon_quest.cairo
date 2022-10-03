%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256

from contracts.loot.constants.adventurer import AdventurerState
from contracts.loot.adventurer.library import AdventurerLib

from contracts.pve_game.DragonQuest import attack, set_xoroshiro

from tests.protostar.loot.test_structs import (
    TestAdventurerState,
    get_adventurer_state,
    get_item,
    TEST_WEAPON_TOKEN_ID,
)

@external
func __setup__{
        range_check_ptr, 
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*
    }() {
    alloc_locals;

    local xoroshiro_address;
    %{
        context.xoroshiro_address = deploy_contract("./contracts/utils/xoroshiro128_starstar.cairo", [921374095]).contract_address
        ids.xoroshiro_address = context.xoroshiro_address
    %}

    set_xoroshiro(xoroshiro_address);

    return ();
}

@external
func test_combat{
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*, 
    range_check_ptr
}() {
    alloc_locals;

    let (result: felt) = attack(Uint256(1, 0), 1, 8, 8, 0, 100, 200);

    assert result = 0;

    return ();
}