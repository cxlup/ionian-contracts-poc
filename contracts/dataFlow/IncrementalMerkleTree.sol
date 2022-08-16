// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract IncrementalMerkleTree {
    using SafeMath for uint256;

    uint256 currentLength;
    bytes32[] openNodes;
    uint256 unstagedHeight;

    constructor(bytes32 identifier) {
        currentLength = 1;
        openNodes = new bytes32[](0);
        openNodes.push(identifier);
        unstagedHeight = 0;
    }

    function root() public view returns (bytes32) {
        return openNodes[openNodes.length - 1];
    }

    function nextAlign(uint256 _length, uint256 alignExp)
        public
        pure
        returns (uint256)
    {
        uint256 length = _length;
        if (length == 0) {
            return 0;
        }
        length -= 1;
        length >>= alignExp;
        length += 1;
        length <<= alignExp;
        return length;
    }

    function commitRoot() public {
        if (unstagedHeight == 0) {
            return;
        }
        uint256 totalHeight = openNodes.length;

        bytes32 left = openNodes[unstagedHeight - 1];
        bytes32 right = zeros(unstagedHeight - 1);

        for (uint256 i = unstagedHeight; i < totalHeight; i++) {
            bytes32 currentHeightHash = keccak256(abi.encode(left, right));
            if ((currentLength >> i) % 2 == 0) {
                left = currentHeightHash;
                right = zeros(i);
                openNodes[i] = currentHeightHash;
            } else {
                left = openNodes[i];
                right = currentHeightHash;
            }
        }
        unstagedHeight = 0;
    }

    function commitUnstaged(uint256 minHeight) internal {
        // We do not change `unstaged` in this function since it will be updated again soon.
        if (unstagedHeight == 0 || unstagedHeight > minHeight) {
            return;
        }
        uint256 totalHeight = openNodes.length;

        bytes32 left = openNodes[unstagedHeight - 1];
        bytes32 right = zeros(unstagedHeight - 1);

        for (uint256 i = unstagedHeight; i < totalHeight; i++) {
            bytes32 currentHeightHash = keccak256(abi.encode(left, right));
            if ((currentLength >> i) % 2 == 0) {
                left = currentHeightHash;
                right = zeros(i);
                if (i >= minHeight) {
                    openNodes[i] = currentHeightHash;
                    return;
                }
            } else {
                left = openNodes[i];
                right = currentHeightHash;
            }
        }
    }

    function insertNode(bytes32 nodeRoot, uint256 height)
        internal
        returns (uint256)
    {
        // If merkle tree is not high enough, add a new level.
        if (openNodes.length <= height) {
            commitRoot();
            while (openNodes.length <= height) {
                uint256 _totalHeight = openNodes.length;
                bytes32 _left = openNodes[_totalHeight - 1];
                bytes32 _right = zeros(_totalHeight - 1);
                openNodes.push(keccak256(abi.encode(_left, _right)));
            }
        }

        uint256 startIndex = nextAlign(currentLength, height);
        uint256 totalHeight = openNodes.length;

        commitUnstaged(height);

        bytes32 left;
        bytes32 right;
        bytes32 currentHeightHash = nodeRoot;

        for (uint256 i = height; i < totalHeight; i++) {
            if ((startIndex >> i) % 2 == 0) {
                openNodes[i] = currentHeightHash;
                unstagedHeight = i + 1;
                break;
            } else {
                left = openNodes[i];
                right = currentHeightHash;
            }
            if (i == totalHeight - 1) {
                unstagedHeight = 0;
                break;
            }
            currentHeightHash = keccak256(abi.encode(left, right));
        }

        currentLength = startIndex + (1 << height);

        return startIndex;
    }

    function zeros(uint256 height) public pure returns (bytes32) {
        if (height == 0)
            return
                bytes32(
                    0xd397b3b043d87fcd6fad1291ff0bfd16401c274896d8c63a923727f077b8e0b5
                );
        else if (height == 1)
            return
                bytes32(
                    0xf73e6947d7d1628b9976a6e40d7b278a8a16405e96324a68df45b12a51b7cfde
                );
        else if (height == 2)
            return
                bytes32(
                    0xa1520264ae93cac619e22e8718fc4fa7ebdd23f493cad602434d2a58ff4868fb
                );
        else if (height == 3)
            return
                bytes32(
                    0xde5747106ac1194a1fa9071dbd6cf19dc2bc7964497ef0afec7e4bdbcf08c47e
                );
        else if (height == 4)
            return
                bytes32(
                    0x09c7082879180d28c789c05fafe7030871c76cedbe82c948b165d6a1d66ac15b
                );
        else if (height == 5)
            return
                bytes32(
                    0xaa7a02bcf29fba687f84123c808b5b48834ff5395abe98e622fadc14e4180c95
                );
        else if (height == 6)
            return
                bytes32(
                    0x7608fd46b710b589e0f2ee5a13cd9c41d432858a30d524f84c6d5db37f66273a
                );
        else if (height == 7)
            return
                bytes32(
                    0xa5d9a2f7f3573ac9a1366bc484688b4daf934b87ea9b3bf2e703da8fd9f09708
                );
        else if (height == 8)
            return
                bytes32(
                    0x6c1779477f4c3fca26b4607398859a43b90a286ce8062500744bd4949981757f
                );
        else if (height == 9)
            return
                bytes32(
                    0x45c22df3d952c33d5edce122eed85e5cda3fd61939e7ad7b3e03b6927bb598ea
                );
        else if (height == 10)
            return
                bytes32(
                    0xe68d02859bb6211cec64f52368b77d422de3b8eac34bf615942b814b643301b5
                );
        else if (height == 11)
            return
                bytes32(
                    0x62d78399b954d51cb9728601738ad13ddc43b2300064660716bb661d2f4d686f
                );
        else if (height == 12)
            return
                bytes32(
                    0x6e250d9abdbbb3993fce08de0395cdb56f0483e67d8762a798de011f6a50866a
                );
        else if (height == 13)
            return
                bytes32(
                    0x1d1a3a74062fd94078617e33eb901eaf16a830f67c387d8eed342db2ac5e2cc5
                );
        else if (height == 14)
            return
                bytes32(
                    0x19b3b3886526917eae8650223d0be20a0301be960eb339696e673ad8a804440f
                );
        else if (height == 15)
            return
                bytes32(
                    0xee9e05df53f10e62a897e5140a3f58732dd849e69cd1d62b21ed80ead711a014
                );
        else if (height == 16)
            return
                bytes32(
                    0x2cc7aa6e611a113a34505dc1c96b220f14909b70e2c2c7b1a74655da21013c5e
                );
        else if (height == 17)
            return
                bytes32(
                    0x949b52dfece7ca3bad3cb27f7750ecaee64cedb6243a275c35984e92956c530a
                );
        else if (height == 18)
            return
                bytes32(
                    0xb2680d060b763b932c150434c3812ba9fbc50937e0ebcf5758de884be81bab65
                );
        else if (height == 19)
            return
                bytes32(
                    0x523aebf4a085edbc9c8cdc99c83f46262e5f029b395ff7bf561a48a3f387e6b8
                );
        else if (height == 20)
            return
                bytes32(
                    0xc9ab73827ab33c0cedb7ecf0ed2e6e32583c0fe887133a7f381ea4ba84d95b76
                );
        else if (height == 21)
            return
                bytes32(
                    0x23eb397dec7e564ebe97f160a5e1081a77d9861f316807079b6be4731beb331e
                );
        else if (height == 22)
            return
                bytes32(
                    0xdfa44a274c60f090df034aaf75539fd40e94cfd6362dd53d26ed20c8ad529563
                );
        else if (height == 23)
            return
                bytes32(
                    0x15b13ee358e1044a53381243c094e54bf7aceb9b5325a0313d6b85fd44e8b3a5
                );
        else if (height == 24)
            return
                bytes32(
                    0x1a7a93871e2daa0f1860aa91d4ece4ccd012dac5fe581176a21b155cfeca6d40
                );
        else if (height == 25)
            return
                bytes32(
                    0xb12665fd0b884a7c7d1e0294d369170d7e672d9e125eb87784556305f98292df
                );
        else if (height == 26)
            return
                bytes32(
                    0x2a5543b0b2f8cf550524390291774f4d6c8c0a25ff5393b09c44d75c92a5bd8e
                );
        else if (height == 27)
            return
                bytes32(
                    0xf9df1841a6e7164b67a1242f1c74975137085ffd9721831f6c469d3a4d5ba42e
                );
        else if (height == 28)
            return
                bytes32(
                    0xba24736b1b48246c1f7803be967be43ca0dddc9c2c0687a2957952249bc89371
                );
        else if (height == 29)
            return
                bytes32(
                    0xf3f706b73790c73ca0a8f0460ac3a2a102e280415586b520e70cd5e8264388b4
                );
        else if (height == 30)
            return
                bytes32(
                    0xc1f5a9a9f357e1c37814688cf7290c87a264ed3d6174a12b978da1c586f53825
                );
        else if (height == 31)
            return
                bytes32(
                    0x766f7702e19ce23d426cdad03e4292a5a42c4669420101fed74400ec7cda3ac6
                );
        else if (height == 32)
            return
                bytes32(
                    0x070fec213e105b3e4d9b0434ac2fc7ca721d35093dc741fb9419797003e2394a
                );
        else if (height == 33)
            return
                bytes32(
                    0x9a7aade05b49e43f5fd3782571cc8c90eadacd5d660b53842b4e5b63d675ae0c
                );
        else if (height == 34)
            return
                bytes32(
                    0xb27b35a8236d0f9b6692820429c025ed58ed378dc98d316b762f0c865c68be6f
                );
        else if (height == 35)
            return
                bytes32(
                    0xdc567ad38d9b90cc9bea4e0f82ec05eca10b3aa94eddc7b63c4fd20c001bb53b
                );
        else if (height == 36)
            return
                bytes32(
                    0xb208dfc457c8b30661ae49544c8e57399818095aab8dd7a426fb8dd56bb8c559
                );
        else if (height == 37)
            return
                bytes32(
                    0xc4a72e1ff84f7a22631f3f95c61c392f98f52050360215a9d7e75d79b0bcd2ca
                );
        else if (height == 38)
            return
                bytes32(
                    0xbb093ec8c0d7defb1de668b5b5dd4f2619e5cd92d29cc144862364a83ab993a8
                );
        else if (height == 39)
            return
                bytes32(
                    0xe341796f2fe3975012c1e6badfa2e9c4523e43f911dc845082c3f4d7b4ff871d
                );
        else if (height == 40)
            return
                bytes32(
                    0x42d356a11a0b39243eca3c3263299cb6f8c3e9728af6d9d8b0ddb6d354f1890d
                );
        else if (height == 41)
            return
                bytes32(
                    0x0ce506e834e3a50a33f80074bc7fa16cf3c0712b36a41b69699177ea25de6c30
                );
        else if (height == 42)
            return
                bytes32(
                    0xd8fa5bf130aeb7756b1ed09090cc80ed78dae0617978540f0fabd06dfb978938
                );
        else if (height == 43)
            return
                bytes32(
                    0xeed69a20fe36eb604f2153efa3b01c0e143cdf02229a1b8f741c9c2719059eb0
                );
        else if (height == 44)
            return
                bytes32(
                    0x303c9c566ebf5bfe252796e5c131a99801226152a514688b5ca6883e99031d88
                );
        else if (height == 45)
            return
                bytes32(
                    0xc7c3765ba96cfbccf3ae718393fa89791070cc8cd85f280b6ac46aea10d96042
                );
        else if (height == 46)
            return
                bytes32(
                    0x1ca65b0a2b8034ee6bfb1fa4526832304e393af835c2c42b4dace58048746800
                );
        else if (height == 47)
            return
                bytes32(
                    0x957add5e02350fd47de3a8e1da38fd774ceb31214d5897ed6315740a83cd634a
                );
        else if (height == 48)
            return
                bytes32(
                    0x787892cb439d5d358870774e163557cf02ec3cb87be6fde11abf1acee14eeaa4
                );
        else if (height == 49)
            return
                bytes32(
                    0x047c0962d4f5c8f60692c587de07739528c4d2059240d61dd34d2a547a438ee6
                );
        else if (height == 50)
            return
                bytes32(
                    0xc18727efc9e4df63020dcd90edc17dfd2ad14f02328c912b13898e0b53735556
                );
        else if (height == 51)
            return
                bytes32(
                    0xe38b9218987e451effe1648c3c9851ad03b64b052a5a3f5ca30f4d7b1ecf7120
                );
        else if (height == 52)
            return
                bytes32(
                    0x0e48ecb1a5418e6218289acc8cf723e67ac6eae3ecb80f644336ab4365a2f2b2
                );
        else if (height == 53)
            return
                bytes32(
                    0xd60e66f5b8cd08d71a1a4d7798952a7afa5a6e93a886c587a46a5500ebef4a60
                );
        else if (height == 54)
            return
                bytes32(
                    0x5162aa9c31d9105f689cf6e71e19548bc9f0218b7d0f99ff7fa8bc2f19c68462
                );
        else if (height == 55)
            return
                bytes32(
                    0x6fa8519b4b0e8fb97a9b618e97627d97b9b9d29d04521fd96472e9c502700568
                );
        else if (height == 56)
            return
                bytes32(
                    0x41f5dcf0cdee270a2ad9a5f8130aaaab94b237463e09757c28b0321f09e24eb0
                );
        else if (height == 57)
            return
                bytes32(
                    0x87a119239fa90732197108adfd029938b4743874d959d3da79b3a30f4832899e
                );
        else if (height == 58)
            return
                bytes32(
                    0x8e96dbaa5c72e84a5297b040ccc1a60750a3201166e3b7740d352837233608a1
                );
        else if (height == 59)
            return
                bytes32(
                    0x01605058d167ce967af8c475d2f6c341c3e0b437babf899c9da73a520aa4ecb5
                );
        else if (height == 60)
            return
                bytes32(
                    0x04529eb80532c5118949d700d8dfd2aa86850b1c6479b26276b9486784a145ff
                );
        else if (height == 61)
            return
                bytes32(
                    0xd191814ad13f27361ae20a46cbac8f6e76c10ebe9af0806d6720492ee2f296f0
                );
        else if (height == 62)
            return
                bytes32(
                    0xa28df63f78821060570da371c0be1312188346b92a7965cc4b980b26c134a4d7
                );
        else if (height == 63)
            return
                bytes32(
                    0xb48a92d40b61dc995ceecee4cded6415050dcece448b1e0b5e5b6a0e6981f3ef
                );
        else revert("Index out of bound");
    }
}
