//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;


import "hardhat/console.sol";



contract MevCube {

    address private immutable owner;

    bytes colors = "UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB";

    mapping(string => uint[4][]) public moves;

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

    }

    function getState() public view returns(bytes memory state) {
        return colors;
    }

    function move(string memory slice, uint times, bool toward) public {

        for (uint moveIndex=0; moveIndex<times; moveIndex++) {
            for (uint ii=0; ii<moves[slice].length; ii++) {
                swapFaceColor(moves[slice][ii], toward);
            }
        }
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

}
