// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import {ERC20} from "solmate/tokens/ERC20.sol";

contract MockUSDC is ERC20("USDC", "USDC", 18) {
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
