const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SwapVariables", function () {
    let SwapVariables;
    let swapVariables;

    beforeEach(async function () {
        SwapVariables = await ethers.getContractFactory("SwapVariables");
        swapVariables = await SwapVariables.deploy();
        await swapVariables.deployed();
    });

    it("Should compare gas usage correctly", async function () {
        const result = await swapVariables.compareGasUsage();
        console.log("Gas usage comparison result:", result);
    });
});
