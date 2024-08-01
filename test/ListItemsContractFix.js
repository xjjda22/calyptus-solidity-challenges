const { expect } = require('chai');

describe('ListItemsContractFix', function () {
    let ListItemsContractFix;
    let listItems;

    beforeEach(async function () {
        ListItemsContractFix = await ethers.getContractFactory('ListItemsContractFix');
        listItems = await ListItemsContractFix.deploy();
        await listItems.deployed();
    });

    it('Should add an item correctly', async function () {
        await listItems.addItem('Item 1');
        const item = await listItems.items(0);
        expect(item.name).to.equal('Item 1');
    });

    it('Should delete an item correctly', async function () {
        await listItems.addItem('Item 1');
        await listItems.addItem('Item 2');

        await listItems.deleteItem(0);
        const item = await listItems.items(0);
        expect(item.name).to.equal('Item 2');
    });
});
