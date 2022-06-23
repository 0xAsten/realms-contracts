# Game Structs
#   A struct that holds the Realm statistics.
#   Each module will need to add a struct with their metadata.
#
# MIT License

%lang starknet

namespace TraitsIds:
    const Region = 1
    const City = 2
    const Harbour = 3
    const River = 4
end

struct RealmData:
    member regions : felt
    member cities : felt
    member harbours : felt
    member rivers : felt
    member resource_number : felt
    member resource_1 : felt
    member resource_2 : felt
    member resource_3 : felt
    member resource_4 : felt
    member resource_5 : felt
    member resource_6 : felt
    member resource_7 : felt
    member wonder : felt
    member order : felt
end

struct RealmBuildings:
    member House : felt
    member StoreHouse : felt
    member Granary : felt
    member Farm : felt
    member FishingVillage : felt
    member Barracks : felt
    member MageTower : felt
    member ArcherTower : felt
    member Castle : felt
end

namespace RealmBuildingsIds:
    const House = 1
    const StoreHouse = 2
    const Granary = 3
    const Farm = 4
    const FishingVillage = 5
    const Barracks = 6
    const MageTower = 7
    const ArcherTower = 8
    const Castle = 9
end

# square meters
namespace RealmBuildingsSize:
    const House = 2
    const StoreHouse = 3
    const Granary = 3
    const Farm = 3
    const FishingVillage = 3
    const Barracks = 6
    const MageTower = 6
    const ArcherTower = 6
    const Castle = 12
end

namespace BuildingsFood:
    const House = 2
    const StoreHouse = 3
    const Granary = 3
    const Farm = 3
    const FishingVillage = 3
    const Barracks = 6
    const MageTower = 6
    const ArcherTower = 6
    const Castle = 12
end

namespace BuildingsCulture:
    const House = 2
    const StoreHouse = 3
    const Granary = 3
    const Farm = 3
    const FishingVillage = 3
    const Barracks = 6
    const MageTower = 6
    const ArcherTower = 6
    const Castle = 12
end

namespace BuildingsPopulation:
    const House = 2
    const StoreHouse = 3
    const Granary = 3
    const Farm = 3
    const FishingVillage = 3
    const Barracks = 6
    const MageTower = 6
    const ArcherTower = 6
    const Castle = 12
end

namespace BuildingsTime:
    const House = 1000
    const StoreHouse = 2000
    const Granary = 2000
    const Farm = 2000
    const FishingVillage = 2000
    const Barracks = 3000
    const MageTower = 3000
    const ArcherTower = 3000
    const Castle = 9000
end

namespace ArmyCap:
    const House = 2
    const StoreHouse = 3
    const Granary = 3
    const Farm = 3
    const FishingVillage = 3
    const Barracks = 6
    const MageTower = 6
    const ArcherTower = 6
    const Castle = 12
end

namespace ModuleIds:
    const L01_Settling = 1
    const L02_Resources = 2
    const L03_Buildings = 3
    const L04_Calculator = 4
    const L05_Wonders = 5
    const L06_Combat = 11  # TODO: Refactor Combat code so this can be 6 to fit in sequence with other contracts
    const L07_Crypts = 7
    const L08_Crypts_Resources = 8
    const L09_Relics = 12
end

namespace ExternalContractIds:
    const Lords = 1
    const Realms = 2
    const S_Realms = 3
    const Resources = 4
    const Treasury = 5
    const Storage = 6
    const Crypts = 7
    const S_Crypts = 8
end

struct CryptData:
    member resource : felt  # uint256 - resource generated by this dungeon (23-28)
    member environment : felt  # uint256 - environment of the dungeon (1-6)
    member legendary : felt  # uint256 - flag if dungeon is legendary (0/1)
    member size : felt  # uint256 - size (e.g. 6x6) of dungeon. (6-25)
    member num_doors : felt  # uint256 - number of doors (0-12)
    member num_points : felt  # uint256 - number of points (0-12)
    member affinity : felt  # uint256 - affinity of the dungeon (0, 1-58)
    # member name : felt  # string - name of the dungeon
end

# struct holding the different environments for Crypts and Caverns dungeons
# we'll use this to determine how many resources to grant during staking
namespace EnvironmentIds:
    const DesertOasis = 1
    const StoneTemple = 2
    const ForestRuins = 3
    const MountainDeep = 4
    const UnderwaterKeep = 5
    const EmbersGlow = 6
end

namespace EnvironmentProduction:
    const DesertOasis = 170
    const StoneTemple = 90
    const ForestRuins = 80
    const MountainDeep = 60
    const UnderwaterKeep = 25
    const EmbersGlow = 10
end

namespace ResourceIds:
    # Realms Resources
    const Wood = 1
    const Stone = 2
    const Coal = 3
    const Copper = 4
    const Obsidian = 5
    const Silver = 6
    const Ironwood = 7
    const ColdIron = 8
    const Gold = 9
    const Hartwood = 10
    const Diamonds = 11
    const Sapphire = 12
    const Ruby = 13
    const DeepCrystal = 14
    const Ignium = 15
    const EtherealSilica = 16
    const TrueIce = 17
    const TwilightQuartz = 18
    const AlchemicalSilver = 19
    const Adamantine = 20
    const Mithral = 21
    const Dragonhide = 22
    # Crypts and Caverns Resources
    const DesertGlass = 23
    const DivineCloth = 24
    const CuriousSpore = 25
    const UnrefinedOre = 26
    const SunkenShekel = 27
    const Demonhide = 28
    # IMPORTANT: if you're adding to this enum
    # make sure the SIZE is one greater than the
    # maximal value; certain algorithms depend on that
    const SIZE = 29
end

namespace TroopId:
    const Watchman = 1
    const Guard = 2
    const GuardCaptain = 3
    const Squire = 4
    const Knight = 5
    const KnightCommander = 6
    const Scout = 7
    const Archer = 8
    const Sniper = 9
    const Scorpio = 10
    const Ballista = 11
    const Catapult = 12
    const Apprentice = 13
    const Mage = 14
    const Arcanist = 15
    const GrandMarshal = 16
    # IMPORTANT: if you're adding to this enum
    # make sure the SIZE is one greater than the
    # maximal value; certain algorithms depend on that
    const SIZE = 17
end

namespace TroopType:
    const Melee = 1
    const Ranged = 2
    const Siege = 3
end

struct Troop:
    member id : felt  # TroopId
    member type : felt  # TroopType
    member tier : felt
    member agility : felt
    member attack : felt
    member defense : felt
    member vitality : felt
    member wisdom : felt
end

# # TODO: add a t4 Troop that's a Character from our Character module;
# #       it should be optional
struct Squad:
    # tier 1 troops
    member t1_1 : Troop
    member t1_2 : Troop
    member t1_3 : Troop
    member t1_4 : Troop
    member t1_5 : Troop
    member t1_6 : Troop
    member t1_7 : Troop
    member t1_8 : Troop
    member t1_9 : Troop
    member t1_10 : Troop
    member t1_11 : Troop
    member t1_12 : Troop
    member t1_13 : Troop
    member t1_14 : Troop
    member t1_15 : Troop
    member t1_16 : Troop

    # tier 2 troops
    member t2_1 : Troop
    member t2_2 : Troop
    member t2_3 : Troop
    member t2_4 : Troop
    member t2_5 : Troop
    member t2_6 : Troop
    member t2_7 : Troop
    member t2_8 : Troop

    # tier 3 troop
    member t3_1 : Troop
end

struct PackedSquad:
    # one packed troop fits into 2 bytes (troop ID + vitality)
    # one felt is ~31 bytes -> can hold 15 troops
    # a squad has 25 troops -> fits into 2 felts when packed
    member p1 : felt  # packed Troops t1_1 ... t1_15
    member p2 : felt  # packed Troops t1_16 ... t3_1
end

struct SquadStats:
    member agility : felt
    member attack : felt
    member defense : felt
    member vitality : felt
    member wisdom : felt
end

# this struct holds everything related to a Realm & combat
# a Realm can have two squads, one used for attacking
# and another used for defending; this struct holds them
struct RealmCombatData:
    member attacking_squad : PackedSquad
    member defending_squad : PackedSquad
    member last_attacked_at : felt
end

# struct holding how much resources does it cost to build/buy a thing
struct Cost:
    # the count of unique ResourceIds necessary
    member resource_count : felt
    # how many bits are the packed members packed into
    member bits : felt
    # packed IDs of the necessary resources
    member packed_ids : felt
    # packed amounts of each resource
    member packed_amounts : felt
end

struct ResourceOutput:
    member resource_1 : felt
    member resource_2 : felt
    member resource_3 : felt
    member resource_4 : felt
    member resource_5 : felt
    member resource_6 : felt
    member resource_7 : felt
end
