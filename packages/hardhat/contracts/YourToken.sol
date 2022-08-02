pragma solidity 0.8.15;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// learn more: https://docs.openzeppelin.com/contracts/3.x/erc20

contract YourToken is ERC20 {
    constructor() ERC20("King Analytics", "KING") {
        _mint(0xcD05AE8EB5Dfed6aCaFCa65d19d99775A8a89Ed0, 1000 * 10 * 18);
    }
}
