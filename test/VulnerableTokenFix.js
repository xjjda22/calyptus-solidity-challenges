const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
  const { expect } = require("chai");
  const { ethers } = require("hardhat");
  
  describe("VulnerableTokenFix", function () {
    async function deployVulnerableTokenFixFixture() {
      const initialSupply = ethers.parseEther("1000");
  
      const [owner, otherAccount, bidder1, bidder2] = await ethers.getSigners();
  
      const VulnerableTokenFix = await ethers.getContractFactory("VulnerableTokenFix");
      const vToken = await VulnerableTokenFix.deploy();
  
      return { vToken, initialSupply, owner, otherAccount, bidder1, bidder2 };
    }
  
    describe("Deployment", function () {
      it("Should set the right initial supply", async function () {
        const { vToken, initialSupply } = await loadFixture(deployVulnerableTokenFixFixture);
  
        expect(await vToken.totalSupply()).to.equal(initialSupply);
      });
  
      it("Should assign the total supply of tokens to the owner", async function () {
        const { vToken, owner, initialSupply } = await loadFixture(deployVulnerableTokenFixFixture);
  
        const ownerBalance = await vToken.balanceOf(owner.address);
        expect(await vToken.totalSupply()).to.equal(ownerBalance);
      });
    });
  
    describe("Transactions", function () {
      it("Should transfer tokens between accounts", async function () {
        const { vToken, owner, otherAccount } = await loadFixture(deployVulnerableTokenFixFixture);
  
        // Transfer 50 tokens from owner to otherAccount
        await expect(vToken.transfer(otherAccount.address, 50))
          .to.changeTokenBalances(vToken, [owner, otherAccount], [-50, 50]);
      });
  
      it("Should fail if sender doesn’t have enough tokens", async function () {
        const { vToken, owner, otherAccount } = await loadFixture(deployVulnerableTokenFixFixture);
        const initialOwnerBalance = await vToken.balanceOf(owner.address);
  
        // Try to send 1 token from otherAccount (0 tokens) to owner.
        await expect(vToken.connect(otherAccount).transfer(owner.address, 1))
          .to.be.revertedWith("ERC20: transfer amount exceeds balance");
  
        // Owner balance shouldn't have changed.
        expect(await vToken.balanceOf(owner.address)).to.equal(initialOwnerBalance);
      });
    });
  
    describe("Auction Bidding", function () {
      it("Should allow bidding and update the highest bid", async function () {
        const { vToken, owner, bidder1, bidder2 } = await loadFixture(deployVulnerableTokenFixFixture);
  
        // Bidder1 bids 100 tokens
        await vToken.connect(owner).approve(bidder1.address, 100);
        await vToken.connect(bidder1).bid(100);
        expect(await vToken.highestBid()).to.equal(100);
        expect(await vToken.highestBidder()).to.equal(bidder1.address);
  
        // Bidder2 outbids with 200 tokens
        await vToken.connect(owner).approve(bidder2.address, 200);
        await vToken.connect(bidder2).bid(200);
        expect(await vToken.highestBid()).to.equal(200);
        expect(await vToken.highestBidder()).to.equal(bidder2.address);
      });
  
      it("Should allow previous highest bidder to withdraw after being outbid", async function () {
        const { vToken, owner, bidder1, bidder2 } = await loadFixture(deployVulnerableTokenFixFixture);
  
        // Bidder1 bids 100 tokens
        await vToken.connect(owner).approve(bidder1.address, 100);
        await vToken.connect(bidder1).bid(100);
  
        // Bidder2 outbids with 200 tokens
        await vToken.connect(owner).approve(bidder2.address, 200);
        await vToken.connect(bidder2).bid(200);
  
        // Bidder1 withdraws their bid
        await expect(vToken.connect(bidder1).withdraw())
          .to.changeTokenBalances(vToken, [bidder1, vToken], [100, -100]);
      });
  
      it("Should transfer the highest bid to the owner when auction ends", async function () {
        const { vToken, owner, bidder2 } = await loadFixture(deployVulnerableTokenFixFixture);
  
        // Bidder2 bids 200 tokens
        await vToken.connect(owner).approve(bidder2.address, 200);
        await vToken.connect(bidder2).bid(200);
  
        // End the auction
        await vToken.connect(owner).endAuction();
  
        expect(await vToken.balanceOf(owner.address)).to.equal(200);
      });
    });
  });
  