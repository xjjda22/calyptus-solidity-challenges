const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ChallengeFix", function () {
    let ChallengeFix;
    let challengeFix;
    let owner;
    let addr1;
    let addr2;

    beforeEach(async function () {
        [owner, addr1, addr2] = await ethers.getSigners();
        ChallengeFix = await ethers.getContractFactory("ChallengeFix");
        challengeFix = await ChallengeFix.deploy(60); // Staking period of 60 seconds
        await challengeFix.deployed();
    });

    it("Should allow staking", async function () {
        await challengeFix.connect(addr1).stake({ value: ethers.utils.parseEther("1") });
        expect(await challengeFix.stakes(addr1.address)).to.equal(ethers.utils.parseEther("1"));
    });

    it("Should allow claiming rewards after staking period", async function () {
        await challengeFix.connect(addr1).stake({ value: ethers.utils.parseEther("1") });
        await ethers.provider.send("evm_increaseTime", [61]); // Increase time to after staking period
        await ethers.provider.send("evm_mine", []); // Mine a new block to update time

        const initialBalance = await ethers.provider.getBalance(addr1.address);
        await challengeFix.connect(addr1).claimReward();
        const finalBalance = await ethers.provider.getBalance(addr1.address);

        expect(finalBalance).to.be.gt(initialBalance);
    });
});
