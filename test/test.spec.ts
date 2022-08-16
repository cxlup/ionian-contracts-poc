import chai, { expect } from "chai";
import { Contract } from "ethers";
import { ethers, waffle } from "hardhat";
import { hexlify, arrayify } from "ethers/utils";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

describe("Ionian Flow", function () {
  let owner: SignerWithAddress;
  before(async () => {
    [owner] = await ethers.getSigners();
  });

  let flow: Contract;
  let token: Contract;
  beforeEach(async () => {
    let erc20ABI = await ethers.getContractFactory("MockToken");
    token = await erc20ABI.deploy();

    let flowABI = await ethers.getContractFactory("Flow");
    flow = await flowABI.deploy(token.address);

    await token.approve(flow.address, 100000);
  });

  it("submit", async () => {
    let root = Buffer.from(
      "ccc2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470",
      "hex"
    );
    await flow.submit({ nodes: [{ root, height: 8 }] });
    expect(await token.balanceOf(owner.address)).to.equal(999947900);
  });
});
