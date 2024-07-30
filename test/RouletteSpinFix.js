const { expect } = require("chai");

describe("RouletteSpinFix", function () {
  it("Should participate with 10 ether and win when divisible by 15", async function () {
    const RouletteSpinFix = await ethers.getContractFactory("RouletteSpinFix");
    const rouletteSpin = await RouletteSpinFix.deploy();
    await rouletteSpin.deployed();

    // Assuming current timestamp is divisible by 15
    await expect(rouletteSpin.spin({ value: ethers.utils.parseEther("10") }))
      .to.changeEtherBalance(rouletteSpin, -10);
  });
});
