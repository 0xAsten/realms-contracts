%lang starknet

from starkware.cairo.common.uint256 import Uint256
from contracts.loot.constants.adventurer import AdventurerState

@contract_interface
namespace IAdventurer {
    func getAdventurerById(tokenId: Uint256) -> (adventurer: AdventurerState) {
    }
}
