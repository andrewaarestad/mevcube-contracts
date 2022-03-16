//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;


import "hardhat/console.sol";



contract MevCube {

    event Solved(address indexed _solver, string _solution);

    address private immutable owner;

    bytes version = "1.0.1";

    bytes colors = "UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB";

    mapping(bytes1 => uint[4][]) public moves;
    mapping(uint => bytes1) public moveIndexes;

    constructor() payable {
        owner = msg.sender;

        moves["L"] = [[0, 18, 27, 53], [3, 21, 30, 50], [6, 24, 33, 47], [36, 38, 44, 42], [37, 41, 43, 39]];
        moves["M"] = [[1, 19, 28, 52], [4, 22, 31, 49], [7, 25, 34, 46]];
        moves["R"] = [[20, 2, 51, 29], [23, 5, 48, 32], [26, 8, 45, 35], [9, 11, 17, 15], [10, 14, 16, 12]];
        moves["U"] = [[9, 18, 36, 45], [10, 19, 37, 46], [11, 20, 38, 47], [0, 2, 8, 6], [1, 5, 7, 3]];
        moves["E"] = [[39, 21, 12, 48], [40, 22, 13, 49], [41, 23, 14, 50]];
        moves["D"] = [[15, 51, 42, 24], [16, 52, 43, 25], [17, 53, 44, 26], [27, 29, 35, 33], [28, 32, 34, 30]];
        moves["F"] = [[6, 9, 29, 44], [7, 12, 28, 41], [8, 15, 27, 38], [18, 20, 26, 24], [19, 23, 25, 21]];
        moves["S"] = [[3, 10, 32, 43], [4, 13, 31, 40], [5, 16, 30, 37]];
        moves["B"] = [[2, 36, 33, 17], [1, 39, 34, 14], [0, 42, 35, 11], [45, 47, 53, 51], [46, 50, 52, 48]];

        moveIndexes[0] = "L";
        moveIndexes[1] = "M";
        moveIndexes[2] = "R";
        moveIndexes[3] = "U";
        moveIndexes[4] = "E";
        moveIndexes[5] = "D";
        moveIndexes[6] = "F";
        moveIndexes[7] = "S";
        moveIndexes[8] = "B";
    }

    function getVersion() public view returns(bytes memory) {
        return version;
    }

    function getState() public view returns(bytes memory) {
        return colors;
    }

    function isSolved() public view returns(bool) {
        bool solved = true;
        for (uint faceIndex=0; faceIndex<5; faceIndex++) {
            for (uint tileIndex=0; tileIndex<8; tileIndex++) {
                solved = solved && colors[faceIndex*9+tileIndex] == colors[faceIndex*9+tileIndex+1];
            }
        }
//        console.log("isSolved: %s", solved);
        return solved;
    }

    function move(string memory rotations) public {
        bytes memory rotationBytes = bytes(rotations);
        for (uint rotIndex=0; rotIndex<rotationBytes.length; rotIndex++) {
            bytes1 thisRotation = rotationBytes[rotIndex];
            bytes1 thisRotationUpper = _upper(thisRotation);
            bool toward = thisRotation == thisRotationUpper;
            for (uint ii=0; ii<moves[thisRotationUpper].length; ii++) {
                swapFaceColor(moves[thisRotationUpper][ii], toward);
            }
        }
        if (isSolved()) {
            emit Solved(msg.sender, rotations);
        }
    }

    function moveSingleAxis(string memory sliceString, uint times, bool toward) public {
        bytes memory sliceBytes = bytes(sliceString);
        bytes1 slice = sliceBytes[0];
//        bytes1 sliceIndex = slice[0];
        for (uint moveIndex=0; moveIndex<times; moveIndex++) {
            for (uint ii=0; ii<moves[slice].length; ii++) {
                swapFaceColor(moves[slice][ii], toward);
            }
        }
    }

    // TODO: This function is really inefficient.  Can probably generate a single random uint256, chop it up into uint16's, and use those for each move
    function scramble() public {

        // By scrambling the cube with 30 rotations, we guarantee that there will exist a solution that is shorter than the inverse of the scramble
        uint numRotations = 30;
        string memory seed = string(abi.encodePacked(toString(4), msg.sender, toString(block.number)));
//        uint256 numRotations = getRandomGaussianNumber(seed);

//        console.log("scrambling cube with %s rotations", numRotations);

//        uint256 upperLimit = 10;

//        console.log("n2: %s", n2);
        bool toward = true;

        for (uint moveIndex=0; moveIndex<numRotations; moveIndex++) {

//            uint256 randomNumberSeed = uint256(keccak256(seed));
            uint256 randomSeed = uint256(keccak256(abi.encodePacked(seed, toString(moveIndex))));

            uint n2 = UniformRandomNumber.uniform(randomSeed, 9);
//            swapFaceColor(moves[moveIndexes[n2]][ii], toward);

            for (uint ii=0; ii<moves[moveIndexes[n2]].length; ii++) {
                swapFaceColor(moves[moveIndexes[n2]][ii], toward);
            }

//            string memory debug = string(colors);
//            console.log("scramble move %i / %i, state is now: %s", (moveIndex+1), n2, debug);
        }

//        colors = "BUUBUULDDFLLBRRDRRBRRFFUFFBDDRDDUDDURRULLLLLLFFUFBBFBB";
    }

    function reset() public {
        colors = "UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB";
    }

    function swapFaceColor(uint[4] memory faceColorNums, bool toward) private {
        bytes1 aColor = colors[faceColorNums[0]];
        if (!toward) {
            colors[faceColorNums[0]] = colors[faceColorNums[1]];
            colors[faceColorNums[1]] = colors[faceColorNums[2]];
            colors[faceColorNums[2]] = colors[faceColorNums[3]];
            colors[faceColorNums[3]] = aColor;
        } else {
            colors[faceColorNums[0]] = colors[faceColorNums[3]];
            colors[faceColorNums[3]] = colors[faceColorNums[2]];
            colors[faceColorNums[2]] = colors[faceColorNums[1]];
            colors[faceColorNums[1]] = aColor;
        }
    }

    function _upper(bytes1 _b1) private pure returns (bytes1) {
        if (_b1 >= 0x61 && _b1 <= 0x7A) {
            return bytes1(uint8(_b1) - 32);
        }
        return _b1;
    }

    function random(string memory seed, uint8 offset) internal pure returns (uint8) {
        return uint8(uint256(keccak256(abi.encodePacked(seed, toString(offset)))));
    }

    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT license
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }



    function getRandomGaussianNumber(string memory seed) public pure returns (uint256) {
//        uint256[8] memory numbers;
        uint256 number;
//        for (uint8 i = 0; i < 8; ++i) {
            int64 accumulator = 0;
            for (uint8 j = 0; j < 16; ++j) {
//                uint8 offset = (i * 16) + j;
//                accumulator += int64(uint64(random(seed, offset)));
                accumulator += int64(uint64(random(seed, 0)));
            }

            accumulator *= 10000;
            accumulator /= 16;
            accumulator = accumulator - 1270000;
            accumulator *= 10000;
            accumulator /= 733235;
            accumulator *= 8;
            accumulator += 105000;
            accumulator /= 10000;
            number = uint256(uint64(accumulator));
//        }

        return number;
    }

}

/**
 * @author Brendan Asselstine
 * @notice A library that uses entropy to select a random number within a bound.  Compensates for modulo bias.
 * @dev Thanks to https://medium.com/hownetworks/dont-waste-cycles-with-modulo-bias-35b6fdafcf94
 */
library UniformRandomNumber {
    /// @notice Select a random number without modulo bias using a random seed and upper bound
    /// @param _entropy The seed for randomness
    /// @param _upperBound The upper bound of the desired number
    /// @return A random number less than the _upperBound
    function uniform(uint256 _entropy, uint256 _upperBound) internal pure returns (uint256) {
        require(_upperBound > 0, "UniformRand/min-bound");
        uint256 min = (type(uint256).max - _upperBound + 1) % _upperBound;
        uint256 random = _entropy;
        while (true) {
            if (random >= min) {
                break;
            }
            random = uint256(keccak256(abi.encodePacked(random)));
        }
        return random % _upperBound;
    }
}
