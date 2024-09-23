module MyModule::Betting {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a betting event.
    struct BettingEvent has store, key {
        outcome: u8, // 0 = undecided, 1 = option A wins, 2 = option B wins
        total_bet_a: u64,
        total_bet_b: u64,
    }

    /// Function for users to place a bet on a real-world event.
    public fun place_bet(bettor: &signer, event_owner: address, option: u8, amount: u64) acquires BettingEvent {
        let event = borrow_global_mut<BettingEvent>(event_owner);
        let payment = coin::withdraw<AptosCoin>(bettor, amount);
        coin::deposit<AptosCoin>(event_owner, payment);

        if (option == 1) {
            event.total_bet_a = event.total_bet_a + amount;
        } else if (option == 2) {
            event.total_bet_b = event.total_bet_b + amount;
        } else {
            abort 1; // Invalid option
        }
    }

    /// Function for the oracle to update the event outcome and distribute winnings.
    public fun update_outcome(oracle: &signer, event_owner: address, outcome: u8) acquires BettingEvent {
        let event = borrow_global_mut<BettingEvent>(event_owner);
        assert!(event.outcome == 0, 1); // Outcome must be undecided
        assert!(outcome == 1 || outcome == 2, 2); // Valid outcomes are 1 or 2
        event.outcome = outcome;
        // Logic to distribute winnings based on the outcome would go here
    }
}
