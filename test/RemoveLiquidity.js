const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const amountA = ethers.utils.parseEther("1000");
const amountB = ethers.utils.parseEther("2000");

describe("Remove Liquidity", function () {
  async function poolWithLiquidityFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const Pool = await ethers.getContractFactory("Pool");
    const pool = await Pool.deploy();

    const addressCalyp = await pool.calyp();
    const calyp = await ethers.getContractAt("Calyp", addressCalyp);
    const addressTus = await pool.tus();
    const tus = await ethers.getContractAt("Tus", addressTus);
    const addressUPair = await pool.uniswapV2Pair();
    const uniswapV2Pair = await ethers.getContractAt(
      "UniswapV2Pair",
      addressUPair
    );

    await calyp.connect(owner).mint(amountA);
    await calyp.approve(pool.address, amountA);
    expect(await calyp.allowance(owner.address, pool.address)).to.equal(
      amountA
    );

    await tus.connect(owner).mint(amountB);
    await tus.approve(pool.address, amountB);
    expect(await tus.allowance(owner.address, pool.address)).to.equal(amountB);

    await pool.addLiquidity(amountA, amountB);
    const res = await uniswapV2Pair.getReserves();
    expect(res._reserve1).to.equal(amountA);
    expect(res._reserve0).to.equal(amountB);

    return {
      owner,
      otherAccount,
      pool,
      addressCalyp,
      addressTus,
      calyp,
      tus,
      addressUPair,
      uniswapV2Pair,
    };
  }

  describe("Removing Liquidity...", function () {
    it("Should be able to do the setup", async function () {
      const { calyp, tus, pool, owner } = await loadFixture(
        poolWithLiquidityFixture
      );
      await pool.removeLiquidity();
      expect(await calyp.balanceOf(owner.address)).to.be.closeTo(
        amountA,
        "10000"
      );
      expect(await tus.balanceOf(owner.address)).to.be.closeTo(
        amountB,
        "10000"
      );
    });
  });
});
