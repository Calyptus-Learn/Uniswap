// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Tus is ERC20 {
    constructor() ERC20("Tus", "Tus") {}

    function mint(uint amount) external {
        _mint(msg.sender, amount);
    }
}
