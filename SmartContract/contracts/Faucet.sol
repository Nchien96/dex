// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

contract Faucet is Ownable {
    address payable owners;
    IERC20 public tokenSim;
    IERC20 public tokenUsdt;
    uint public faucetAmount = 50 * (10 ** 18);
    uint public locktime = 1 minutes;
    mapping(address => uint) nextAccessTime;

    struct balances {
        uint Sim;
        uint Usdt;
    }

    balances public myBalances;

    constructor() payable {
        owners = payable(msg.sender);
    }

    function setTokenSim(address tokenAddress) public onlyOwner {
        tokenSim = IERC20(tokenAddress);
    }

    function setTokenUsdt(address tokenAddress) public onlyOwner {
        tokenUsdt = IERC20(tokenAddress);
    }

    event Deposit(address indexed form, uint indexed amount);

    function requesttoken() public {
        require(
            msg.sender != address(0),
            "Request must not originate from a zero account"
        );
        require(
            tokenSim.balanceOf(address(this)) >= faucetAmount,
            "Insufficient balance in faucet for withdrawl request"
        );
        require(
            tokenUsdt.balanceOf(address(this)) >= faucetAmount,
            "Insufficient balance in faucet for withdrawl request"
        );
        require(
            block.timestamp >= nextAccessTime[msg.sender],
            "Insufficient time elapsed since last withdral - last again later"
        );

        nextAccessTime[msg.sender] = block.timestamp + locktime;

        tokenSim.transfer(msg.sender, faucetAmount);
        tokenUsdt.transfer(msg.sender, faucetAmount);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function deposits(uint _amount) external {
        require(
            tokenSim.balanceOf(msg.sender) >= _amount,
            "Insufficient account balance"
        );
        require(
            tokenUsdt.balanceOf(msg.sender) >= _amount,
            "Insufficient account balance"
        );

        SafeERC20.safeTransferFrom(
            tokenSim,
            msg.sender,
            address(this),
            _amount * (10 ** 18)
        );
        SafeERC20.safeTransferFrom(
            tokenUsdt,
            msg.sender,
            address(this),
            _amount * (10 ** 18)
        );
    }

    function getBalance() external returns (balances memory) {
        myBalances = balances(
            tokenSim.balanceOf(address(this)),
            tokenUsdt.balanceOf(address(this))
        );
        return myBalances;
    }

    function setFaucetAmount(uint amount) public onlyOwner {
        faucetAmount = amount * (10 ** 18);
    }

    function setLocktime(uint amount) public onlyOwner {
        locktime = amount * 1 minutes;
    }

    function withdraws() external onlyOwner {
        tokenUsdt.transfer(msg.sender, tokenUsdt.balanceOf(address(this)));
        tokenSim.transfer(msg.sender, tokenSim.balanceOf(address(this)));
    }
}
