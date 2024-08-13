const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("GiftCardDistributorFix", function () {
  let distributor;
  let owner, addr1, addr2;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();

    const GiftCardDistributorFix = await ethers.getContractFactory("GiftCardDistributorFix");
    distributor = await GiftCardDistributorFix.deploy();
    await distributor.deployed();
  });

  it("should allow users to purchase gift cards", async function () {
    await distributor.connect(addr1).purchaseGiftCards({ value: ethers.utils.parseEther("1") });
    const balance = await distributor.giftCardBalances(addr1.address);
    expect(balance).to.equal(ethers.utils.parseEther("1"));
  });

  it("should only allow the marketplace owner to distribute gift cards", async function () {
    await expect(
      distributor.connect(addr1).distributeGiftCards([addr1.address], [ethers.utils.parseEther("0.5")])
    ).to.be.revertedWith("NotMarketplaceOwner");
  });

  it("should distribute gift cards correctly", async function () {
    await distributor.purchaseGiftCards({ value: ethers.utils.parseEther("2") });

    await distributor.distributeGiftCards(
      [addr1.address, addr2.address],
      [ethers.utils.parseEther("0.5"), ethers.utils.parseEther("0.5")]
    );

    const balanceAddr1 = await ethers.provider.getBalance(addr1.address);
    const balanceAddr2 = await ethers.provider.getBalance(addr2.address);
    const balanceOwner = await distributor.giftCardBalances(owner.address);

    expect(balanceAddr1).to.be.above(ethers.utils.parseEther("10000.5")); // Adjust for initial balance
    expect(balanceAddr2).to.be.above(ethers.utils.parseEther("10000.5")); // Adjust for initial balance
    expect(balanceOwner).to.equal(ethers.utils.parseEther("1"));
  });

  it("should revert if recipients and amounts lengths do not match", async function () {
    await expect(
      distributor.distributeGiftCards([addr1.address], [ethers.utils.parseEther("0.5"), ethers.utils.parseEther("0.5")])
    ).to.be.revertedWith("InvalidInput");
  });

  it("should revert if insufficient gift card balance", async function () {
    await distributor.purchaseGiftCards({ value: ethers.utils.parseEther("1") });

    await expect(
      distributor.distributeGiftCards(
        [addr1.address, addr2.address],
        [ethers.utils.parseEther("0.5"), ethers.utils.parseEther("0.6")]
      )
    ).to.be.revertedWith("InsufficientGiftCardBalance");
  });
});
