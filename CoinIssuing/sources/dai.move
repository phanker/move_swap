module coin_inssuing::dai {

    use std::coin;
    use std::signer;
    use std::string;
    use aptos_framework::coin::{BurnCapability, MintCapability};

    struct DAI has key, store {}

    struct HoldCap has key {
        burn: BurnCapability<DAI>,
        mint: MintCapability<DAI>,
    }

    public fun init_coin(sender: &signer) {
        let (burnCapability, freezeCapability, mintCapability) = coin::initialize<DAI>(
            sender,
            string::utf8(b"USDT"),
            string::utf8(b"USDT"),
            8,
            true
        );

        let holdCap = HoldCap { burn: burnCapability, mint: mintCapability };
        move_to(sender, holdCap);

        coin::destroy_freeze_cap(freezeCapability);
    }

    fun mint(sender: &signer, amount: u64) acquires HoldCap {

        let cap = borrow_global<HoldCap>(@coin_inssuing);

        let coin_amount = coin::mint(amount,&cap.mint);

        let addr = signer::address_of(sender);

        if(!coin::is_account_registered<DAI>(addr)){
            coin::register<DAI>(sender);
        };

        coin::deposit(addr,coin_amount);
    }
}
