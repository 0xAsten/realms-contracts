%lang starknet

@external
func up() {
    %{  
        contract_address = deploy_contract(
             "./build/adventurer.json",
             config={"wait_for_acceptance": True}
        ).contract_address
    %}

    return ();
}

