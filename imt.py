import sha3
from eth_utils import big_endian_to_int, encode_hex 

def sha3_256(x):
    return sha3.keccak_256(x).digest()

print(encode_hex(sha3_256(bytes("0", 'utf-8'))))

submissions = [["0x9ddd4e0a2cad64671092292c85e736e362d7fc73a193c68e12fff5a3cba7df59", 10], 
["0x3d49c5e5b9dadd942c04fb70ed30e02788ac47561c714377da87292d6f592d9c", 8],
["0x0b91417b713c4795d51830a6be8ad86794560336be1642181a9297af540714a7",7], 
["0x23cba87dd3c1f8d3c455d3e4b3fce1a2483c397b776bdeb3f1b5efcac8210289",6],
["0x17ee0d3e1822ef9947b8459b24f92375c6fb8e36560302c414211a74d25c1727",5],
["0xf4a2d6ffbd5d0fba22f9fd9929f017f43f8c082c5aafdca45dbdba1a063b3645",4],
["0xcd8ca15a3f52c0d350b5f61f8e2ea71d58c61fb52b3f0717f935c94dc4196194",3],
["0x9ca8c070594f948cfa9bdc4f3d037fde5b7168290d6084f53c2926a6edfa468a",2],
["0x0ea5ce3fa71bcea63c898b7ffad9ce3730d5b24fd1686d37e195619bc0c1fa20",1],
["0x2f22c23651b666520dfe7fae3ea30b51d0e1cffd3aa2065d759059211c847eb7",0],
["0x9ddd4e0a2cad64671092292c85e736e362d7fc73a193c68e12fff5a3cba7df59", 10]]

currentLength = 1
openNodes = []
openNodes.append("0x044852b2a670ade5407e78fb2863c51de9fcb96542a07186fe3aeda6bb8a116d")
unstagedHeight = 1


def nextAlign(_length, alignExp):
    length = _length

    if (length == 0):
        return 0

    length -= 1
    length >>= alignExp
    length += 1
    length <<= alignExp

    return length
    

def zeros(height):
    if (height == 0):
        return "d397b3b043d87fcd6fad1291ff0bfd16401c274896d8c63a923727f077b8e0b5"
    elif (height == 1):
        return "f73e6947d7d1628b9976a6e40d7b278a8a16405e96324a68df45b12a51b7cfde"
    elif (height == 2):
        return "a1520264ae93cac619e22e8718fc4fa7ebdd23f493cad602434d2a58ff4868fb"
    elif (height == 3):
        return "de5747106ac1194a1fa9071dbd6cf19dc2bc7964497ef0afec7e4bdbcf08c47e"
    elif (height == 4):
        return "09c7082879180d28c789c05fafe7030871c76cedbe82c948b165d6a1d66ac15b"
    elif (height == 5):
        return "aa7a02bcf29fba687f84123c808b5b48834ff5395abe98e622fadc14e4180c95"
    elif (height == 6):
        return "7608fd46b710b589e0f2ee5a13cd9c41d432858a30d524f84c6d5db37f66273a"
    elif (height == 7):
        return "a5d9a2f7f3573ac9a1366bc484688b4daf934b87ea9b3bf2e703da8fd9f09708"
    elif (height == 8):
        return "6c1779477f4c3fca26b4607398859a43b90a286ce8062500744bd4949981757f"
    elif (height == 9):
        return "45c22df3d952c33d5edce122eed85e5cda3fd61939e7ad7b3e03b6927bb598ea"
    elif (height == 10):
        return "e68d02859bb6211cec64f52368b77d422de3b8eac34bf615942b814b643301b5"
    elif (height == 11):
        return "62d78399b954d51cb9728601738ad13ddc43b2300064660716bb661d2f4d686f"
    elif (height == 12):
        return "6e250d9abdbbb3993fce08de0395cdb56f0483e67d8762a798de011f6a50866a"
    elif (height == 13):
        return "1d1a3a74062fd94078617e33eb901eaf16a830f67c387d8eed342db2ac5e2cc5"
    elif (height == 14):
        return "19b3b3886526917eae8650223d0be20a0301be960eb339696e673ad8a804440f"
    elif (height == 15):
        return "ee9e05df53f10e62a897e5140a3f58732dd849e69cd1d62b21ed80ead711a014"
    elif (height == 16):
        return "2cc7aa6e611a113a34505dc1c96b220f14909b70e2c2c7b1a74655da21013c5e"
    elif (height == 17):
        return "949b52dfece7ca3bad3cb27f7750ecaee64cedb6243a275c35984e92956c530a"
    elif (height == 18):
        return "b2680d060b763b932c150434c3812ba9fbc50937e0ebcf5758de884be81bab65"
    elif (height == 19):
        return "523aebf4a085edbc9c8cdc99c83f46262e5f029b395ff7bf561a48a3f387e6b8"
    elif (height == 20):
        return "c9ab73827ab33c0cedb7ecf0ed2e6e32583c0fe887133a7f381ea4ba84d95b76"
    elif (height == 21):
        return "23eb397dec7e564ebe97f160a5e1081a77d9861f316807079b6be4731beb331e"
    elif (height == 22):
        return "dfa44a274c60f090df034aaf75539fd40e94cfd6362dd53d26ed20c8ad529563"
    elif (height == 23):
        return "15b13ee358e1044a53381243c094e54bf7aceb9b5325a0313d6b85fd44e8b3a5"
    elif (height == 24):
        return "1a7a93871e2daa0f1860aa91d4ece4ccd012dac5fe581176a21b155cfeca6d40"
    elif (height == 25):
        return "b12665fd0b884a7c7d1e0294d369170d7e672d9e125eb87784556305f98292df"
    elif (height == 26):
        return "2a5543b0b2f8cf550524390291774f4d6c8c0a25ff5393b09c44d75c92a5bd8e"
    elif (height == 27):
        return "f9df1841a6e7164b67a1242f1c74975137085ffd9721831f6c469d3a4d5ba42e"
    elif (height == 28):
        return "ba24736b1b48246c1f7803be967be43ca0dddc9c2c0687a2957952249bc89371"
    elif (height == 29):
        return "f3f706b73790c73ca0a8f0460ac3a2a102e280415586b520e70cd5e8264388b4"
    elif (height == 30):
        return "c1f5a9a9f357e1c37814688cf7290c87a264ed3d6174a12b978da1c586f53825"
    elif (height == 31):
        return "766f7702e19ce23d426cdad03e4292a5a42c4669420101fed74400ec7cda3ac6"
    elif (height == 32):
        return "070fec213e105b3e4d9b0434ac2fc7ca721d35093dc741fb9419797003e2394a"
    elif (height == 33):
        return "9a7aade05b49e43f5fd3782571cc8c90eadacd5d660b53842b4e5b63d675ae0c"
    elif (height == 34):
        return "b27b35a8236d0f9b6692820429c025ed58ed378dc98d316b762f0c865c68be6f"
    elif (height == 35):
        return "dc567ad38d9b90cc9bea4e0f82ec05eca10b3aa94eddc7b63c4fd20c001bb53b"
    elif (height == 36):
        return "b208dfc457c8b30661ae49544c8e57399818095aab8dd7a426fb8dd56bb8c559"
    elif (height == 37):
        return "c4a72e1ff84f7a22631f3f95c61c392f98f52050360215a9d7e75d79b0bcd2ca"
    elif (height == 38):
        return "bb093ec8c0d7defb1de668b5b5dd4f2619e5cd92d29cc144862364a83ab993a8"
    elif (height == 39):
        return "e341796f2fe3975012c1e6badfa2e9c4523e43f911dc845082c3f4d7b4ff871d"
    elif (height == 40):
        return "42d356a11a0b39243eca3c3263299cb6f8c3e9728af6d9d8b0ddb6d354f1890d"
    elif (height == 41):
        return "0ce506e834e3a50a33f80074bc7fa16cf3c0712b36a41b69699177ea25de6c30"
    elif (height == 42):
        return "d8fa5bf130aeb7756b1ed09090cc80ed78dae0617978540f0fabd06dfb978938"
    elif (height == 43):
        return "eed69a20fe36eb604f2153efa3b01c0e143cdf02229a1b8f741c9c2719059eb0"
    elif (height == 44):
        return "303c9c566ebf5bfe252796e5c131a99801226152a514688b5ca6883e99031d88"
    elif (height == 45):
        return "c7c3765ba96cfbccf3ae718393fa89791070cc8cd85f280b6ac46aea10d96042"
    elif (height == 46):
        return "1ca65b0a2b8034ee6bfb1fa4526832304e393af835c2c42b4dace58048746800"
    elif (height == 47):
        return "957add5e02350fd47de3a8e1da38fd774ceb31214d5897ed6315740a83cd634a"
    elif (height == 48):
        return "787892cb439d5d358870774e163557cf02ec3cb87be6fde11abf1acee14eeaa4"
    elif (height == 49):
        return "047c0962d4f5c8f60692c587de07739528c4d2059240d61dd34d2a547a438ee6"
    elif (height == 50):
        return "c18727efc9e4df63020dcd90edc17dfd2ad14f02328c912b13898e0b53735556"
    elif (height == 51):
        return "e38b9218987e451effe1648c3c9851ad03b64b052a5a3f5ca30f4d7b1ecf7120"
    elif (height == 52):
        return "0e48ecb1a5418e6218289acc8cf723e67ac6eae3ecb80f644336ab4365a2f2b2"
    elif (height == 53):
        return "d60e66f5b8cd08d71a1a4d7798952a7afa5a6e93a886c587a46a5500ebef4a60"
    elif (height == 54):
        return "5162aa9c31d9105f689cf6e71e19548bc9f0218b7d0f99ff7fa8bc2f19c68462"
    elif (height == 55):
        return "6fa8519b4b0e8fb97a9b618e97627d97b9b9d29d04521fd96472e9c502700568"
    elif (height == 56):
        return "41f5dcf0cdee270a2ad9a5f8130aaaab94b237463e09757c28b0321f09e24eb0"
    elif (height == 57):
        return "87a119239fa90732197108adfd029938b4743874d959d3da79b3a30f4832899e"
    elif (height == 58):
        return "8e96dbaa5c72e84a5297b040ccc1a60750a3201166e3b7740d352837233608a1"
    elif (height == 59):
        return "01605058d167ce967af8c475d2f6c341c3e0b437babf899c9da73a520aa4ecb5"
    elif (height == 60):
        return "04529eb80532c5118949d700d8dfd2aa86850b1c6479b26276b9486784a145ff"
    elif (height == 61):
        return "d191814ad13f27361ae20a46cbac8f6e76c10ebe9af0806d6720492ee2f296f0"
    elif (height == 62):
        return "a28df63f78821060570da371c0be1312188346b92a7965cc4b980b26c134a4d7"
    elif (height == 63):
        return "b48a92d40b61dc995ceecee4cded6415050dcece448b1e0b5e5b6a0e6981f3ef"
    else:
        return ""
    

def _addNewLevel():
    global currentLength, openNodes, unstagedHeight
    _totalHeight = len(openNodes)
    _left = openNodes[_totalHeight - 1]
    _right = zeros(_totalHeight - 1)
    openNodes.append( encode_hex(sha3_256(bytes(_left + _right, 'utf-8'))))
    
def commitRoot():
    global currentLength, openNodes, unstagedHeight
    if (unstagedHeight == len(openNodes)):
        return

    totalHeight = len(openNodes)

    left = openNodes[unstagedHeight - 1]
    right = zeros(unstagedHeight - 1)

    for i in range(unstagedHeight, totalHeight):
        currentHeightHash = encode_hex(sha3_256(bytes(left + right, 'utf-8'))) 
        if ((currentLength >> i) % 2 == 0):
            left = currentHeightHash
            right = zeros(i)
            openNodes[i] = currentHeightHash
        else:
            left = openNodes[i]
            right = currentHeightHash

    unstagedHeight = totalHeight
    

def _commitUnstaged(minHeight):
    global currentLength, openNodes, unstagedHeight
    if (unstagedHeight > minHeight):
        return
    
    totalHeight = len(openNodes)
    left = openNodes[unstagedHeight - 1]
    right = zeros(unstagedHeight - 1)

    for i in range(unstagedHeight, totalHeight):
        currentHeightHash = encode_hex(sha3_256(bytes(left + right, 'utf-8'))) 
        if ((currentLength >> i) % 2 == 0):
            left = currentHeightHash
            right = zeros(i)
            if (i >= minHeight):
                openNodes[i] = currentHeightHash
                return
        else:
            left = openNodes[i]
            right = currentHeightHash

def _insertNode(nodeRoot, height):
    global currentLength, openNodes, unstagedHeight
    startIndex = nextAlign(currentLength, height)
    afterLength = startIndex + (1 << height)

    if afterLength > (1 << (len(openNodes) - 1)):
        commitRoot()
        _addNewLevel()
        while (afterLength > 1 << (len(openNodes) - 1)):
            _addNewLevel()
        
        unstagedHeight = len(openNodes)

    totalHeight = len(openNodes)

    _commitUnstaged(height)

    left = None
    right = None
    currentHeightHash = nodeRoot


    for i in range(height, totalHeight):
        if ((startIndex >> i) % 2 == 0):
            openNodes[i] = currentHeightHash
            unstagedHeight = i + 1
            break
        else:
            left = openNodes[i]
            right = currentHeightHash

        currentHeightHash = encode_hex(sha3_256(bytes(left + right, 'utf-8')))
    

    currentLength = startIndex + (1 << height)


    return startIndex
    
for nodeRoot, height in submissions:
    nodeStartIndex = _insertNode(nodeRoot, height)