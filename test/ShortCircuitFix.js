const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ShortCircuitFix", function () {
  let ShortCircuitFix;
  let shortCircuitFix;
  let owner;
  let addr1;

  beforeEach(async function () {
    ShortCircuitFix = await ethers.getContractFactory("ShortCircuitFix");
    [owner, addr1] = await ethers.getSigners();
    shortCircuitFix = await ShortCircuitFix.deploy();
    await shortCircuitFix.deployed();
  });

  describe("Deposit", function () {
    it("Should deposit tokens correctly", async function () {
      await shortCircuitFix.connect(addr1).deposit(1000);
      expect(await shortCircuitFix.balanceOf(addr1.address)).to.equal(1000);
    });
  });

  describe("Withdraw", function () {
    it("Should withdraw tokens correctly if conditions are met", async function () {
      await shortCircuitFix.connect(addr1).deposit(1000);
      await shortCircuitFix.connect(addr1).withdraw(500);
      expect(await shortCircuitFix.balanceOf(addr1.address)).to.equal(500);
    });

    it("Should fail to withdraw tokens if amount is zero", async function () {
      await shortCircuitFix.connect(addr1).deposit(1000);
      await expect(shortCircuitFix.connect(addr1).withdraw(0)).to.be.revertedWith("Invalid amount");
    });

    it("Should fail to withdraw tokens if costly check fails", async function () {
      await shortCircuitFix.connect(addr1).deposit(3);
      await expect(shortCircuitFix.connect(addr1).withdraw(1)).to.be.revertedWith("Failed costly check");
    });
  });
});
