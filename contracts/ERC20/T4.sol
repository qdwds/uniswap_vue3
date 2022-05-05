// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Test4 is ERC20 {
    constructor() ERC20("Test 4", "T4") {
        _mint(msg.sender, 100000000000000000 * 10 ** decimals());
    }
}