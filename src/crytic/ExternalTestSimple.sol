// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {NaughtCoin} from "src/NaughtCoin.sol";

contract ExternalTestSimple {
    NaughtCoin public naughtCoin;
    address player;

    constructor() {
        player = msg.sender;
        naughtCoin = new NaughtCoin(player);
    }

    function always_true() public pure {
        assert(true);
    }

    function token_is_deployed() public {
        assert(address(naughtCoin) != address(0));
    }

    function sender_balance_is_equal_to_initial_supply() public {
        uint256 currentTime = block.timestamp;
        if (currentTime < naughtCoin.timeLock()) {
            assert(naughtCoin.balanceOf(player) == naughtCoin.INITIAL_SUPPLY());
        }
    }
}
