async function main() {
  const [deployer] = await ethers.getSigners();

  const Tus = await ethers.getContractFactory("Tus", deployer);
  const tus = await Tus.deploy();

  console.log("Tus deployed at: ", tus.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// Tus deployed at:  0x62b0280dE04dcC91751e12b45fC1E36b0D486128
