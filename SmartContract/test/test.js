const { expect } = require("chai");

const {
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");

describe("Token contract", function () {
  async function deployTokenFixture() {
    const [owner, addr1, addr2] = await ethers.getSigners();

    const CryptoSimsToken = await ethers.deployContract("CryptoSims");

    await CryptoSimsToken.waitForDeployment();

    return { CryptoSimsToken, owner, addr1, addr2 };
  }

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      const { CryptoSimsToken, owner } = await loadFixture(deployTokenFixture);

      expect(await CryptoSimsToken.owner()).to.equal(owner.address);
    });

    it("Should assign the total supply of tokens to the owner", async function () {
      const { CryptoSimsToken, owner } = await loadFixture(deployTokenFixture);
      const ownerBalance = await CryptoSimsToken.balanceOf(owner.address);
      expect(await CryptoSimsToken.totalSupply()).to.equal(ownerBalance);
    });
  });

  describe("Transactions", function () {
    it("Should transfer tokens between accounts", async function () {
      const { CryptoSimsToken, owner, addr1, addr2 } = await loadFixture(
        deployTokenFixture
      );
      // Transfer 50 tokens from owner to addr1
      await expect(
        CryptoSimsToken.transfer(addr1.address, 50)
      ).to.changeTokenBalances(CryptoSimsToken, [owner, addr1], [-50, 50]);

      // Transfer 50 tokens from addr1 to addr2
      // We use .connect(signer) to send a transaction from another account
      await expect(
        CryptoSimsToken.connect(addr1).transfer(addr2.address, 50)
      ).to.changeTokenBalances(CryptoSimsToken, [addr1, addr2], [-50, 50]);
    });

    it("Should emit Transfer events", async function () {
      const { CryptoSimsToken, owner, addr1, addr2 } = await loadFixture(
        deployTokenFixture
      );

      // Transfer 50 tokens from owner to addr1
      await expect(CryptoSimsToken.transfer(addr1.address, 50))
        .to.emit(CryptoSimsToken, "Transfer")
        .withArgs(owner.address, addr1.address, 50);

      // Transfer 50 tokens from addr1 to addr2
      // We use .connect(signer) to send a transaction from another account
      await expect(CryptoSimsToken.connect(addr1).transfer(addr2.address, 50))
        .to.emit(CryptoSimsToken, "Transfer")
        .withArgs(addr1.address, addr2.address, 50);
    });

    it("Should fail if sender doesn't have enough tokens", async function () {
      const { CryptoSimsToken, owner, addr1 } = await loadFixture(
        deployTokenFixture
      );
      const initialOwnerBalance = await CryptoSimsToken.balanceOf(
        owner.address
      );

      // Try to send 1 token from addr1 (0 tokens) to owner.
      // `require` will evaluate false and revert the transaction.
      await expect(
        CryptoSimsToken.connect(addr1).transfer(owner.address, 1)
      ).to.be.revertedWith("ERC20: transfer amount exceeds balance");

      // Owner balance shouldn't have changed.
      expect(await CryptoSimsToken.balanceOf(owner.address)).to.equal(
        initialOwnerBalance
      );
    });
  });
});
