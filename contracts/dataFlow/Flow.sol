// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Submission.sol";
import "./IncrementalMerkleTree.sol";
import "./IFlow.sol";
import "../utils/IDigestHistory.sol";
import "../utils/DigestHistory.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Flow is Pausable, IFlow, IncrementalMerkleTree {
    using IonianSubmissionLibrary for IonianSubmission;
    using SafeERC20 for IERC20;

    uint256 constant MAX_DEPTH = 64;
    uint256 constant BASE_FEE = 1000;
    uint256 constant ENTRY_FEE = 100;
    uint256 constant ROOT_AVALIABLE_WINDOW = 20;
    uint256 constant CONTEXT_PERIOD = 100;
    uint256 constant DEPLOY_DELAY = 0;

    bytes32 constant EMPTY_HASH =
        hex"c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470";

    IERC20 token;
    IDigestHistory rootHistory;

    uint256 submissionIndex;
    uint256 firstBlock;
    uint256 epoch;
    uint256 epochStartPosition;
    MineContext context;
    mapping(bytes32 => EpochRange) epochRanges;

    error InvalidSubmission();

    constructor(address _token) IncrementalMerkleTree(bytes32(0x0)) {
        token = IERC20(_token);
        epoch = 0;
        rootHistory = new DigestHistory(ROOT_AVALIABLE_WINDOW);
        firstBlock = block.number + DEPLOY_DELAY;
        context = MineContext({
            epoch: 0,
            epochStart: firstBlock,
            flowRoot: EMPTY_HASH,
            flowLength: 1,
            digest: EMPTY_HASH
        });
    }

    modifier launched() {
        require(block.number >= firstBlock, "Contract has not launched.");
        _;
    }

    function submit(IonianSubmission calldata submission)
        public
        whenNotPaused
        launched
        returns (
            uint256,
            bytes32,
            uint256,
            uint256
        )
    {
        require(submission.valid(), "Invalid submission");
        makeContext();

        uint256 startIndex;

        uint256 beforeAppendLength = currentLength;

        for (uint256 i = 0; i < submission.nodes.length; i++) {
            bytes32 nodeRoot = submission.nodes[i].root;
            uint256 height = submission.nodes[i].height;
            uint256 nodeStartIndex = insertNode(nodeRoot, height);
            if (i == 0) {
                startIndex = nodeStartIndex;
            }
        }

        uint256 afterAppendLength = currentLength;

        uint256 chargedLength = afterAppendLength - beforeAppendLength;
        chargeFee(chargedLength);

        uint256 length = submission.size();
        bytes32 digest = submission.digest();
        uint256 index = submissionIndex;
        submissionIndex += 1;

        emit Submission(
            msg.sender,
            digest,
            index,
            startIndex,
            length,
            submission
        );

        return (index, digest, startIndex, length);
    }

    function makeContext() public launched {
        uint256 nextEpochStart;
        unchecked {
            nextEpochStart = firstBlock + (epoch + 1) * CONTEXT_PERIOD;
        }

        if (nextEpochStart >= block.number) {
            return;
        }
        commitRoot();
        bytes32 currentRoot = root();
        uint256 index = rootHistory.insert(currentRoot);
        assert(index == epoch);

        bytes32 contextDigest;

        if (nextEpochStart + 256 < block.number) {
            contextDigest = EMPTY_HASH;
        } else {
            bytes32 blockDigest = blockhash(nextEpochStart);
            contextDigest = keccak256(
                abi.encode(blockDigest, currentRoot, currentLength)
            );

            uint128 startPosition = uint128(epochStartPosition);
            uint128 endPosition = uint128(currentLength);
            epochRanges[contextDigest] = EpochRange({
                start: startPosition,
                end: endPosition
            });

            epochStartPosition = currentLength;
        }

        epoch += 1;

        context = MineContext({
            epoch: epoch,
            epochStart: nextEpochStart,
            flowRoot: currentRoot,
            flowLength: currentLength,
            digest: contextDigest
        });

        emit NewEpoch(
            msg.sender,
            epoch,
            currentRoot,
            submissionIndex,
            currentLength,
            contextDigest
        );

        // TODO: send reward.

        // Recursive call to handle a rare case: the contract is more than one epoch behind.
        makeContext();
    }

    function makeContextWithResult()
        external
        launched
        returns (MineContext memory)
    {
        makeContext();
        return getContext();
    }

    function getContext() public view returns (MineContext memory) {
        MineContext memory _context = context;
        return _context;
    }

    function getEpochRange(bytes32 digest)
        external
        view
        returns (EpochRange memory)
    {
        return epochRanges[digest];
    }

    function chargeFee(uint256 size) internal {
        uint256 fee = BASE_FEE + ENTRY_FEE * size;
        token.safeTransferFrom(msg.sender, address(this), fee);
    }
}
