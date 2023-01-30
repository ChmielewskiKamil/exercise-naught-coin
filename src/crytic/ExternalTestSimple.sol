// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {NaughtCoin} from "src/NaughtCoin.sol";

contract ExternalTestSimple {
    NaughtCoin public naughtCoin;

    constructor() {
        naughtCoin = new NaughtCoin(msg.sender);
    }

    function always_true() public pure {
        assert(true);
    }

    function token_is_deployed() public {
        assert(address(naughtCoin) != address(0));
    }

    function sender_balance_is_equal_to_initial_supply() public {
        assert(naughtCoin.balanceOf(msg.sender) == naughtCoin.INITIAL_SUPPLY());
    }
}
