// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract CryptoSims is ERC20("CryptoSims", "SIM"), ERC20Burnable, Ownable {
    uint private cap = 50_000_000_000 * 10 ** uint(18);

    constructor() {
        _mint(msg.sender, cap);
        transferOwnership(msg.sender);
    }

    function mint(address to, uint amount) public onlyOwner {
        require(
            ERC20.totalSupply() + amount <= cap,
            "CryptoSims: cap exceeded"
        );

        _mint(to, amount);
    }
}
