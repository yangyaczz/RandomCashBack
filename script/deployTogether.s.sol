// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console, console2} from "forge-std/Script.sol";
import {MockUSDC} from "../src/Mock/MockUSDC.sol";
import {Lottery} from "../src/Lottery.sol";

contract DTScript is Script {
    // deploy
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        MockUSDC usdc = new MockUSDC();
        usdc.mint(0xBEbAF2a9ad714fEb9Dd151d81Dd6d61Ae0535646, 10000 * 10 ** 18);
        usdc.mint(0xB4F205238b7556790dACef577D371Cb8f6C87215, 10000 * 10 ** 18);

        Lottery lottery = new Lottery(address(usdc));

        usdc.transfer(address(lottery), 800 * 10 ** 18);

        uint256[] memory uints = new uint256[](3);
        uints[0] = 3 * 10 ** 16;
        uints[1] = 6 * 10 ** 16;
        uints[2] = 9 * 10 ** 16;
        lottery.createRound(1731686400, 1731772800, uints);

        lottery.settleRound(1, bytes32(0));

        bytes32[] memory mp = new bytes32[](1);
        mp[0] = bytes32(0);
        lottery.claimReward(1, 1, mp);

        vm.stopBroadcast();
    }
}
// forge script script/deployTogether.s.sol:DTScript --rpc-url https://testnet.evm.nodes.onflow.org --legacy --broadcast
// forge script script/deployTogether.s.sol:DTScript --rpc-url https://rpc-quicknode-holesky.morphl2.io --legacy --broadcast
