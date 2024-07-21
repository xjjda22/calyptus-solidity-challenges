// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SwapVariables {
    uint public x = 1;
    uint public y = 2;

    function swapWithTemp() internal {
        uint temp = x;
        x = y;
        y = temp;
    }

    function swapWithTuple() internal {
        (x, y) = (y, x);
    }

    function compareGasUsage() external returns (string memory) {
        uint256 gasUsedWithTemp;
        uint256 gasUsedWithTuple;

        uint gasStart = gasleft();
        swapWithTemp();
        gasUsedWithTemp = gasStart - gasleft();

        // Reset x and y to original values
        (x, y) = (y, x);

        gasStart = gasleft();
        swapWithTuple();
        gasUsedWithTuple = gasStart - gasleft();

        if (gasUsedWithTemp > gasUsedWithTuple) {
            return "swapWithTemp used more gas";
        } else if (gasUsedWithTuple > gasUsedWithTemp) {
            return "swapWithTuple used more gas";
        } else {
            return "Both methods used the same amount of gas";
        }
    }
}
