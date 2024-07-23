const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('DigitalWalletFix', function () {
    let DigitalWalletFix;
    let digitalWalletFix;
    let owner;
    let addr1;

    beforeEach(async function () {
        [owner, addr1] = await ethers.getSigners();
        DigitalWalletFix = await ethers.getContractFactory('DigitalWalletFix');
        digitalWalletFix = await DigitalWalletFix.deploy();
        await digitalWalletFix.deployed();
    });

    it("Should initialize the owner's wallet", async function () {
        const wallet = await digitalWalletFix.wallets(owner.address);
        expect(wallet.id).to.equal(1);
        expect(wallet.balance).to.equal(100);
    });

    it('Should allow the owner to update their wallet balance', async function () {
        await digitalWalletFix.updateWalletBalance(owner.address, 200);
        const wallet = await digitalWalletFix.wallets(owner.address);
        expect(wallet.balance).to.equal(200);
    });

    it('Should prevent unauthorized updates', async function () {
        await expect(digitalWalletFix.connect(addr1).updateWalletBalance(owner.address, 200)).to.be.revertedWith('Unauthorized update');
    });

    it('Should prevent updating invalid wallet address', async function () {
        await expect(digitalWalletFix.updateWalletBalance('0x0000000000000000000000000000000000000000', 200)).to.be.revertedWith('Invalid wallet address');
    });
});
