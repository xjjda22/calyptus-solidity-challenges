const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('TicketingSystemFix', function () {
    let ticketingSystem;
    let owner;
    let addr1;

    beforeEach(async function () {
        const TicketingSystemFix = await ethers.getContractFactory('TicketingSystemFix');
        [owner, addr1] = await ethers.getSigners();
        ticketingSystem = await TicketingSystemFix.deploy();
        await ticketingSystem.deployed();

        // Setup some initial data
        await ticketingSystem.setTicketDetails(1, 10, ethers.utils.parseEther('0.1')); // ticketId 1
        await ticketingSystem.setTicketDetails(2, 20, ethers.utils.parseEther('0.2')); // ticketId 2
    });

    it('should buy tickets correctly', async function () {
        const ids = [1, 2];
        const quantities = [2, 3]; // total price = 0.1*2 + 0.2*3 = 0.8 ETH

        await expect(ticketingSystem.connect(addr1).buyTicketsBatch(addr1.address, ids, quantities, { value: ethers.utils.parseEther('0.8') })).to.not.be.reverted;

        expect(await ticketingSystem.totalSupply(1)).to.equal(2);
        expect(await ticketingSystem.totalSupply(2)).to.equal(3);
    });

    it('should revert if max supply is reached', async function () {
        await ticketingSystem.setTicketDetails(1, 2, ethers.utils.parseEther('0.1')); // set max supply for ticketId 1 to 2

        const ids = [1, 1];
        const quantities = [1, 2]; // total quantity = 3 > max supply

        await expect(ticketingSystem.connect(addr1).buyTicketsBatch(addr1.address, ids, quantities, { value: ethers.utils.parseEther('0.3') })).to.be.revertedWith('MaxSupplyReached');
    });

    it('should revert if incorrect price is paid', async function () {
        const ids = [1, 2];
        const quantities = [1, 1]; // total price = 0.1*1 + 0.2*1 = 0.3 ETH

        await expect(ticketingSystem.connect(addr1).buyTicketsBatch(addr1.address, ids, quantities, { value: ethers.utils.parseEther('0.2') })).to.be.revertedWith('InvalidPrice');
    });
});
