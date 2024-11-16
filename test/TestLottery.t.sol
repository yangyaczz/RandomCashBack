// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/Lottery.sol";
import "src/Mock/MockUSDC.sol";

contract TestLottery is Test {
    Lottery lottery;
    MockUSDC usdc;
    address alice = 0xBEbAF2a9ad714fEb9Dd151d81Dd6d61Ae0535646;

    function setUp() public {
        usdc = new MockUSDC();
        lottery = new Lottery(address(usdc));
    }

    function testBar() public {
        // assertEq(uint256(1), uint256(1), "ok");

        vm.startPrank(alice);
        usdc.mint(alice, 1000 * 10 ** 18);
        usdc.transfer(address(lottery), 500 * 10 ** 18);

        //
        uint256[] memory uints = new uint256[](3);
        uints[0] = 1 * 10 ** 18;
        uints[1] = 2 * 10 ** 18;
        uints[2] = 3 * 10 ** 18;

        lottery.createRound(block.timestamp, block.timestamp + 20, uints);

        console2.log("balance", usdc.balanceOf(alice));

        lottery.settleRound(1, bytes32(0));

        bytes32[] memory mp = new bytes32[](1);
        mp[0] = bytes32(0);
        lottery.claimReward(1, 2, mp);

        console2.log("balance", usdc.balanceOf(alice));
    }
}
