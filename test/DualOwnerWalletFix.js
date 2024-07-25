const { expect } = require('chai');
const { ethers } = require('hardhat');
const { keccak256 } = require('ethers/lib/utils');

describe('DualOwnerWalletFix', function () {
    let DualOwnerWalletFix;
    let dualOwnerWalletFix;
    let owner1, owner2, recipient;

    beforeEach(async function () {
        [owner1, owner2, recipient] = await ethers.getSigners();
        DualOwnerWalletFix = await ethers.getContractFactory('DualOwnerWalletFix');
        dualOwnerWalletFix = await DualOwnerWalletFix.deploy([owner1.address, owner2.address], { value: ethers.utils.parseEther('10') });
        await dualOwnerWalletFix.deployed();
    });

    it('should deploy with initial custodians', async function () {
        expect(await dualOwnerWalletFix.custodians(0)).to.equal(owner1.address);
        expect(await dualOwnerWalletFix.custodians(1)).to.equal(owner2.address);
    });

    it('should allow sending funds with valid signatures', async function () {
        const amount = ethers.utils.parseEther('1');
        const txHash = await dualOwnerWalletFix.calculateTxHash(recipient.address, amount);
        const ethSignedTxHash = await dualOwnerWalletFix.provider.getSigner(0).signMessage(ethers.utils.arrayify(txHash));
        const signatures = [await owner1.signMessage(ethers.utils.arrayify(txHash)), await owner2.signMessage(ethers.utils.arrayify(txHash))];

        await expect(dualOwnerWalletFix.sendFunds(recipient.address, amount, signatures))
            .to.emit(dualOwnerWalletFix, 'FundsSent')
            .withArgs(recipient.address, amount);

        const balance = await ethers.provider.getBalance(recipient.address);
        expect(balance).to.equal(amount);
    });

    it('should reject sending funds with invalid signatures', async function () {
        const amount = ethers.utils.parseEther('1');
        const txHash = await dualOwnerWalletFix.calculateTxHash(recipient.address, amount);
        const invalidSignature = await owner1.signMessage(ethers.utils.arrayify(txHash));
        await expect(dualOwnerWalletFix.sendFunds(recipient.address, amount, [invalidSignature, invalidSignature])).to.be.revertedWith('Invalid signature');
    });
});
