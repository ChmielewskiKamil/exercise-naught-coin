// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {NaughtCoin} from "src/NaughtCoin.sol";

contract ExternalTestSimple {
    NaughtCoin public naughtCoin;
    address player;
    address bob;

    event AssertionFailed(uint256 amount);

    constructor() {
        player = msg.sender;
        // Bob is our second user, we need him to transfer tokens to someone.
        // You can give him a random address like: 0x123456
        bob = address(0x123456);
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

    function transfer_should_fail_before_timelock_period(uint256 amount)
        public
    {
        // pre-conditions
        uint256 playerBalanceBefore = naughtCoin.balanceOf(player);
        uint256 bobBalanceBefore = naughtCoin.balanceOf(bob);
        uint256 currentTime = block.timestamp;
        if (currentTime < naughtCoin.timeLock()) {
            // actions
            bool success1 = naughtCoin.transfer(bob, amount);
            if (success1) {
                emit AssertionFailed(amount);
            }
        }
        // post-conditions
        assert(
            naughtCoin.balanceOf(player) == playerBalanceBefore &&
                naughtCoin.balanceOf(bob) == bobBalanceBefore
        );
    }

    function approve_should_not_fail_if_caller_has_enough_tokens(uint256 amount)
        public
    {
        // pre-conditions
        uint256 playerBalance = naughtCoin.balanceOf(player);
        if (playerBalance >= amount) {
            // actions
            bool success1 = naughtCoin.approve(bob, amount);
            // post-conditions
            assert(success1);
        }
    }

    function transfer_from_should_fail_before_timelock_period(uint256 amount)
        public
    {
        // pre-conditions
        uint256 playerBalanceBefore = naughtCoin.balanceOf(player);
        uint256 bobBalanceBefore = naughtCoin.balanceOf(bob);
        uint256 currentTime = block.timestamp;
        if (currentTime < naughtCoin.timeLock()) {
            // actions
            bool success1 = naughtCoin.transferFrom(player, bob, amount);
            if (success1) {
                emit AssertionFailed(amount);
            }
            // post-conditions
            assert(
                naughtCoin.balanceOf(player) == playerBalanceBefore &&
                    naughtCoin.balanceOf(bob) == bobBalanceBefore
            );
        }
    }
}
