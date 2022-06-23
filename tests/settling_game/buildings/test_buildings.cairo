%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_add, uint256_sub
from starkware.cairo.common.math_cmp import is_nn, is_le
from starkware.cairo.common.math import unsigned_div_rem, signed_div_rem
from lib.cairo_math_64x61.contracts.Math64x61 import Math64x61_div
from contracts.settling_game.utils.game_structs import (
    BuildingsFood,
    BuildingsPopulation,
    BuildingsCulture,
    RealmBuildings,
)
from contracts.settling_game.library.library_buildings import BUILDINGS
from starkware.cairo.common.pow import pow

const time_balance = 500
const decay_slope = 400
const building_id = 1

@external
func test_get_building_left{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals

    # now - timestamp = param
    let (base_building_number) = BUILDINGS.get_base_building_left(time_balance)

    let (decay_slope) = BUILDINGS.get_decay_slope(1)

    # pass slope determined by building
    let (decay_rate) = BUILDINGS.get_decay_rate(base_building_number, decay_slope)

    # pass actual time balance + decay rate
    let (effective_building_time) = BUILDINGS.get_decayed_building_time(time_balance, decay_rate)

    let (buildings_left) = BUILDINGS.get_effective_buildings(effective_building_time)

    %{ print(ids.base_building_number) %}
    %{ print(ids.decay_rate) %}
    %{ print(ids.effective_building_time) %}
    %{ print(ids.buildings_left) %}
    return ()
end

@external
func test_calculate_effective_buildings{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals

    # now - timestamp = param
    let (base_building_number) = BUILDINGS.calculate_effective_buildings(1, time_balance)

    %{ print(ids.base_building_number) %}
    return ()
end

@external
func test_get_decay_slope{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals

    let (decay_slope) = BUILDINGS.get_decay_slope(1)

    %{ print(ids.decay_slope) %}
    return ()
end

@external
func test_get_integrity_length{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals

    let (final_time) = BUILDINGS.get_integrity_length(1000, 1, 1)

    %{ print(ids.final_time) %}
    return ()
end

@external
func test_can_build{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals

    let test_buildings = RealmBuildings(1, 1, 1, 1, 1, 1, 1, 1, 2)

    BUILDINGS.can_build(1, 1, test_buildings, 20, 3)

    return ()
end

@external
func test_building_size{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
    alloc_locals

    let (building_size) = BUILDINGS.get_building_size(1)

    %{ print(ids.building_size) %}

    return ()
end

@external
func test_get_current_built_buildings_sqm{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}():
    alloc_locals

    let test_buildings = RealmBuildings(1, 2, 1, 1, 1, 1, 1, 1, 2)

    let (buildings_sqm) = BUILDINGS.get_current_built_buildings_sqm(test_buildings)

    %{ print(ids.buildings_sqm) %}

    return ()
end
