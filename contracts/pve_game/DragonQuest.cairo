// -----------------------------------
//      Module.DragonQuest

// MIT License
// -----------------------------------


%lang starknet

from openzeppelin.upgrades.library import Proxy

from contracts.pve_game.library import DragonQuest, Xoroshiro_address, Adventurer_address
from contracts.loot.adventurer.IAdventurer import IAdventurer


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
    DragonQuest.initializer(xoroshiro_address, adventurer_address)
    Proxy.initializer(proxy_admin)
    return ()
}

@external
func upgrade{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(new_implementation: felt){
    Proxy.assert_only_admin()
    Proxy._set_implementation_hash(new_implementation)
    return ()
}

@external
func combat{
    range_check_ptr, 
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*
}(adventurerId: felt) {
    Proxy.assert_only_admin();

    let (adventurer_address) = Adventurer_address.read();
    let (adventurer) = IAdventurer.getAdventurerById(adventurer_address, adventurerId);


    return ();
}


@external
func set_xoroshiro{
    range_check_ptr, 
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*
}(xoroshiro: felt) {
    Proxy.assert_only_admin();
    xoroshiro_address.write(xoroshiro);
    return ();
}

@external
func set_adventurer{
    range_check_ptr, 
    syscall_ptr: felt*, 
    pedersen_ptr: HashBuiltin*
}(adventurer: felt) {
    Proxy.assert_only_admin();
    Adventurer_address.write(adventurer);
    return ();
}