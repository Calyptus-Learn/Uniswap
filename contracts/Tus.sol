// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Tus is ERC20 {
    constructor() ERC20("Tus", "Tus") {
        _mint(msg.sender, 3000 * 10 ** decimals());
    }
}
