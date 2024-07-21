// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/SwapVariables.sol";

contract SwapVariablesTest is Test {
    SwapVariables public swapVariables;

    function setUp() public {
        swapVariables = new SwapVariables();
    }

    function testCompareGasUsage() public {
        string memory result = swapVariables.compareGasUsage();
        emit log_string(result);
    }
}
