%lang starknet

@external
func up() {
    %{  
        contract_address = deploy_contract(
             "./build/main.json",
             config={"wait_for_acceptance": True}
        ).contract_address

        invoke(
            contract_address,
            "initializer",
            {
                "xoroshiro_address": 1,
                "adventurer_address": 2,
                "proxy_admin": 3,
            },
            config={
                "max_fee": 100000000000000000,
                "wait_for_acceptance": True,
            }
        )

        result = call(
            contract_address,
            "get_adventurer_address"
        )

        assert result.address == 2
    %}

    return ();
}

