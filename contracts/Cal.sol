// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Calyp is ERC20 {
    constructor() ERC20("Calyp", "Cal") {
        _mint(msg.sender, 2500 * 10 ** decimals());
    }
}
