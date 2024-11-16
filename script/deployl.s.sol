// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console, console2} from "forge-std/Script.sol";
import {Lottery} from "../src/Lottery.sol";

contract LotteryScript is Script {
    // deploy
    // function run() public {
    //     uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    //     vm.startBroadcast(deployerPrivateKey);

    //     Lottery lottery = new Lottery(
    //         0x2EC5CfDE6F37029aa8cc018ED71CF4Ef67C704AE
    //     );

    //     vm.stopBroadcast();
    // }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        Lottery lottery = Lottery(0xEe93D1909Ba7377cfa4e2831cdAe258553d051bc);

        uint256[] memory uints = new uint256[](3);
        uints[0] = 688 * 10 ** 16;
        uints[1] = 888 * 10 ** 16;
        uints[2] = 1888 * 10 ** 16;
        lottery.createRound(1731686400, 1731772800, uints);

        lottery.settleRound(1, bytes32(0));

        bytes32[] memory mp = new bytes32[](1);
        mp[0] = bytes32(0);
        lottery.claimReward(1, 1, mp);

        vm.stopBroadcast();
    }

    // forge script script/deploy.s.sol:MockUSDTScript --rpc-url https://sepolia.base.org --legacy --broadcast

    // forge script script/deployl.s.sol:LotteryScript --rpc-url https://sepolia.base.org --legacy --broadcast
    // forge script script/deployl.s.sol:LotteryScript --rpc-url https://alfajores-forno.celo-testnet.org --legacy --broadcast

    // forge script script/AddressTagSBT.s.sol:AddressTagSBTScript --rpc-url https://network.ambrosus-test.io --legacy --broadcast -vvvv
}
