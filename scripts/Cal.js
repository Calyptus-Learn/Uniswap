async function main() {
  const [deployer] = await ethers.getSigners();

  const Cal = await ethers.getContractFactory("Calyp", deployer);
  const cal = await Cal.deploy();

  console.log("Cal deployed at: ", cal.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// Cal deployed at:  0x7b643628ef8Ca175219D603301c14512B6F58656
