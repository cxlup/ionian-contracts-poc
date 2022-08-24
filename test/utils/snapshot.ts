import env = require("hardhat");

class Snapshot {
  snapshotId;
  constructor() {
    this.snapshotId = "";
  }

  async snapshot(): Promise<Snapshot> {
    this.snapshotId = await env.network.provider.send("evm_snapshot", []);
    return this;
  }

  async revert() {
    await env.network.provider.send("evm_revert", [this.snapshotId]);
    await this.snapshot();
  }
}

export { Snapshot };
