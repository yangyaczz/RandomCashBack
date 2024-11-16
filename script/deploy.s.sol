// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console, console2} from "forge-std/Script.sol";
import {MockUSDC} from "../src/Mock/MockUSDC.sol";

contract MockUSDCScript is Script {
    // deploy
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        MockUSDC usdt = new MockUSDC();

        usdt.mint(0xBEbAF2a9ad714fEb9Dd151d81Dd6d61Ae0535646, 1000 * 10 ** 18);

        vm.stopBroadcast();
    }

    // function run() public {
    //     uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    //     vm.startBroadcast(deployerPrivateKey);

    //     // console2.log(atSBT.balanceOf(0xA552c195A6eEC742B61042531fb92732F8A91D6b,0));

    //     atSBT.mintAddressTagSBT(0x7d964297869A22f9b116Fe3f68C1090d4D708a77,3);

    //     // uint256[] memory ids = new uint256[](4);
    //     // ids[0] = 0;
    //     // ids[1] = 1;
    //     // ids[2] = 2;
    //     // ids[3] = 3;

    //     // bytes32[] memory bytes32s = new bytes32[](4);
    //     // bytes32s[0] = keccak256("whale trader");
    //     // bytes32s[1] = keccak256("malicious actor");
    //     // bytes32s[2] = keccak256("arbitrage trader");
    //     // bytes32s[3] = keccak256("nft collector");
    //     // atSBT.addTagType(ids, bytes32s);

    //     vm.stopBroadcast();
    // }

    // forge script script/deploy.s.sol:MockUSDTScript --rpc-url https://sepolia.base.org --legacy --broadcast

    // forge script script/deploy.s.sol:MockUSDCScript --rpc-url https://alfajores-forno.celo-testnet.org --legacy --broadcast
    // forge script script/deploy.s.sol:MockUSDCScript --rpc-url https://sepolia.base.org --legacy --broadcast



    // forge script script/AddressTagSBT.s.sol:AddressTagSBTScript --rpc-url https://network.ambrosus-test.io --legacy --broadcast -vvvv
}
