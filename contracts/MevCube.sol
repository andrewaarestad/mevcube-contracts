//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;


import "hardhat/console.sol";



contract MevCube {

    address private immutable owner;

    bytes colors = "UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB";

//    bytes colors = [1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9];

//    uint[4][5] Lmoves = [[0, 18, 27, 53], [3, 21, 30, 50], [6, 24, 33, 47], [36, 38, 44, 42], [37, 41, 43, 39]];

    mapping(string => uint[4][]) public moves;


    //    const defaultState = 'UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB';
//
//const notationSwapTable: {
//[indexOf: string]: [number, number, number, number][];
//} = {
//L: [[0, 18, 27, 53], [3, 21, 30, 50], [6, 24, 33, 47], [36, 38, 44, 42], [37, 41, 43, 39]],
//M: [[1, 19, 28, 52], [4, 22, 31, 49], [7, 25, 34, 46]],
//R: [[20, 2, 51, 29], [23, 5, 48, 32], [26, 8, 45, 35], [9, 11, 17, 15], [10, 14, 16, 12]],
//U: [[9, 18, 36, 45], [10, 19, 37, 46], [11, 20, 38, 47], [0, 2, 8, 6], [1, 5, 7, 3]],
//E: [[39, 21, 12, 48], [40, 22, 13, 49], [41, 23, 14, 50]],
//D: [[15, 51, 42, 24], [16, 52, 43, 25], [17, 53, 44, 26], [27, 29, 35, 33], [28, 32, 34, 30]],
//F: [[6, 9, 29, 44], [7, 12, 28, 41], [8, 15, 27, 38], [18, 20, 26, 24], [19, 23, 25, 21]],
//S: [[3, 10, 32, 43], [4, 13, 31, 40], [5, 16, 30, 37]],
//B: [[2, 36, 33, 17], [1, 39, 34, 14], [0, 42, 35, 11], [45, 47, 53, 51], [46, 50, 52, 48]],
//};

    constructor() payable {
        owner = msg.sender;
//        if (msg.value > 0) {
//            console.log('Depositing initial value as weth: %s', msg.value);
//            WETH.deposit{value: msg.value}();
//        }

        moves["L"] = [[0, 18, 27, 53], [3, 21, 30, 50], [6, 24, 33, 47], [36, 38, 44, 42], [37, 41, 43, 39]];

//        Lmoves.push([0, 18, 27, 53], [3, 21, 30, 50], [6, 24, 33, 47], [36, 38, 44, 42], [37, 41, 43, 39]);
    }

    function getState() public view returns(bytes memory state) {
        return colors;
    }

//    move(notationStr: string) {
//        console.log('move: ', notationStr);
//        const notations = notationStr.trim().split(' ');
//        this.queuedMoves.push(...notations);
//        console.log('queued moves: ', this.queuedMoves);
//        for (const i of notations) {
//        let toward = 1;
//        let rotationTimes = 1;
//        const notation = i[0];
//        const secondNota = i[1];
//        if (secondNota) {
//            if (secondNota === `'`) {
//            toward = -1;
//            } else if (secondNota === `2`) {
//            rotationTimes = 2;
//            } else {
//            throw new Error(`Wrong secondNota: ${secondNota}`);
//            }
//        }
//
//        for (let j = 0; j < rotationTimes; j++) {
//            const actions = notationSwapTable[notation];
//            for (const k of actions) {
//            this.swapFaceColor(k, toward);
//            }
//            }
//        }
//    }

    function move(string memory slice, uint times, bool toward) public {

        for (uint moveIndex=0; moveIndex<times; moveIndex++) {
            for (uint ii=0; ii<moves[slice].length; ii++) {
                swapFaceColor(moves[slice][ii], toward);
            }
        }
    }

//    function Lmove(uint[4][] memory moves, bool toward) public {
//        console.log('moving: ');
//
//        for (uint ii=0; ii<moves.length; ii++) {
//            swapFaceColor(moves[ii], toward);
//        }
//
////        for (const k of actions) {
////            this.swapFaceColor(k, toward);
////        }
//    }

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

//swapFaceColor(faceColorNums: number[], toward: number) {
//const [a, b, c, d] = faceColorNums;
//const colors = this.colors;
//const aColor = colors[a];
//if (toward === -1) {
//colors[a] = colors[b];
//colors[b] = colors[c];
//colors[c] = colors[d];
//colors[d] = aColor;
//} else if (toward === 1) {
//colors[a] = colors[d];
//colors[d] = colors[c];
//colors[c] = colors[b];
//colors[b] = aColor;
//} else {
//throw new Error(`Wrong toward: ${toward}`);
//}
//}

}
