// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

struct IonianSubmissionNode {
    bytes32 root;
    uint256 height;
}

struct IonianSubmission {
    IonianSubmissionNode[] nodes;
}

library IonianSubmissionLibrary {
    uint256 constant MAX_DEPTH = 64;

    function size(IonianSubmission memory submission)
        internal
        pure
        returns (uint256)
    {
        uint256 _size = 0;
        for (uint256 i = 0; i < submission.nodes.length; i++) {
            _size += 1 << submission.nodes[i].height;
        }
        return _size;
    }

    function valid(IonianSubmission memory submission)
        internal
        pure
        returns (bool)
    {
        if (submission.nodes.length == 0) {
            return false;
        }

        if (submission.nodes[0].height >= MAX_DEPTH) {
            return false;
        }

        for (uint256 i = 0; i < submission.nodes.length - 1; i++) {
            if (submission.nodes[i + 1].height >= submission.nodes[i].height) {
                return false;
            }
        }

        return true;
    }

    function digest(IonianSubmission memory submission)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(submission.nodes));
    }
}
