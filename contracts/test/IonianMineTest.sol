// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "../miner/IonianMine.sol";

contract IonianMineTest is IonianMine {
    constructor(address flow, uint256 settings) IonianMine(flow, settings) {}

    function setMiner(bytes32 minerId) external {
        minerIds[msg.sender] = minerId;
    }
}
