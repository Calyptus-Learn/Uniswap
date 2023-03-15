const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Create-Pool", function () {
  async function deployFixture() {
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

  describe("Creating pool...", function () {
    it("Should be able to deploy the Calyp token", async function () {
      const { calyp } = await loadFixture(deployFixture);
      expect(await calyp.name()).to.equal("Calyp");
    });
    it("Should be able to deploy the tus token", async function () {
      const { tus } = await loadFixture(deployFixture);
      expect(await tus.name()).to.equal("Tus");
    });
    it("Should be able to deploy the Uniswap Pair Contract", async function () {
      const { uniswapV2Pair, addressCalyp, addressTus } = await loadFixture(
        deployFixture
      );
      const res = await uniswapV2Pair.getReserves();
      expect(res._reserve0).to.equal("0");
      expect(res._reserve1).to.equal("0");
      expect(await uniswapV2Pair.token1()).to.equal(addressCalyp);
      expect(await uniswapV2Pair.token0()).to.equal(addressTus);
    });
  });
});
