module swap_pool::router {

    use std::signer;
    use aptos_framework::coin;

    use swap_pool::pool;

    public entry fun init<A, B>(sender: &signer) {
        // init the swap pool
        pool::create_poll<A, B>(sender);
    }

    public entry fun add_coin<A, B>(sender: &signer, coin_a_mount: u64, coin_b_amount: u64) {
        //firstly,withdraw the a and b coin from sender then add the coin pool
        let coin_a = coin::withdraw<A>(sender, coin_a_mount);
        let coin_b = coin::withdraw<A>(sender, coin_b_amount);
        pool::add_coin(coin_a, coin_b);
    }

    public entry fun swap<IN, OUT>(sender: &signer, in_amount: u64) {
        let sender_addr = signer::address_of(sender);
       let  in_coin = coin::withdraw<IN>(sender,in_amount);
        if (pool::isExsitPoll<IN, OUT>()) {
            let out = pool::a_swap_b<IN, OUT>(in_coin);
            coin::deposit(sender_addr, out);
        }else {
            let out = pool::b_swap_a<OUT, IN>(in_coin);
            coin::deposit(sender_addr, out);
        }
    }
}
