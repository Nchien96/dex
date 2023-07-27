// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/forge-std/src/Test.sol";
import "contracts/CryptoSimsToken.sol";

contract SimTokenTest is Test {
    CryptoSims public simToken;

    function setUp() public {
        deployer = vm.addr(0x1234);
        vm.startPrank(deployer);
        simToken = new CryptoSims("CryptoSims", "SIM");
        _SimAddress = address(simToken);
    }

    function testBalance_ShouldDeployBalance_WhencallToBanlance() public {
        uint deployBalance = simToken.balanceOf(deployer);
        uint totolSupply = 50_000_000_000 * 10 ** uint(18);

        assertEqUint(deployBalance, totolSupply);
    }
}
