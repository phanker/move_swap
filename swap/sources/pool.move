module swap_pool::pool {
    use aptos_framework::coin;
    use aptos_framework::coin::Coin;

    // this is a poll stored A & B coins
    struct Poll<phantom A, phantom B> has key {
        coin_a: Coin<A>,
        coin_b: Coin<B>
    }


    public fun create_poll<A, B>(sender: &signer) {
        move_to(sender, Poll<A, B> {
            coin_a: coin::zero(),
            coin_b: coin::zero()
        })
    }

    public fun add_coin<A, B>(coin_a: Coin<A>, coin_b: Coin<B>) acquires Poll {
        let pool = borrow_global_mut<Poll<A, B>>(@swap_pool);
        coin::merge(&mut pool.coin_a, coin_a);
        coin::merge(&mut pool.coin_b, coin_b);
    }

    public fun isExsitPoll<A, B>(): bool {
        exists<Poll<A, B>>(@swap_pool)
    }


    // this is a simple demo for a-coin swap b-coin,and contains no other complex logic
    public fun a_swap_b<A, B>(coin_a: Coin<A>): Coin<B> acquires Poll {
        // if(!isExsitPoll<A,B>()){
        // }
        let poll = borrow_global_mut<Poll<A, B>>(@swap_pool);
        // get the value of coin A
        let coin_amount = coin::value(&coin_a);

        coin::merge(&mut poll.coin_a, coin_a);

        let out = coin::extract(&mut poll.coin_b, coin_amount);
        out
    }

    // this is a simple demo for b-coin swap a-coin,and contains no other complex logic
    public fun b_swap_a<A, B>(coin_b: Coin<B>): Coin<A> acquires Poll {
        // if(!isExsitPoll<A,B>()){
        // }
        let poll = borrow_global_mut<Poll<A, B>>(@swap_pool);
        // get the value of coin A
        let coin_amount = coin::value(&coin_b);

        coin::merge(&mut poll.coin_b, coin_b);
        let out = coin::extract(&mut poll.coin_a, coin_amount);
        out
    }

}
