// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

contract Donate is Ownable {
    address payable owners;
    IERC20 public token;

    constructor() payable {
        owners = payable(msg.sender);
    }

    event Deposit(address indexed form, uint indexed amount);
    event withdraw(address indexed to, uint256 value);

    function setToken(address tokenAddress) public onlyOwner {
        token = IERC20(tokenAddress);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function donate(uint _donateAmount) external {
        require(
            token.balanceOf(msg.sender) >= _donateAmount,
            "Insufficient account balance"
        );
        SafeERC20.safeTransferFrom(
            token,
            msg.sender,
            address(this),
            _donateAmount * (10 ** 18)
        );
    }

    function getBalance() external view returns (uint) {
        return token.balanceOf(address(this));
    }

    function withdraws() external onlyOwner {
        emit withdraw(msg.sender, token.balanceOf(address(this)));
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }
}
