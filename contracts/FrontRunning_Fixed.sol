// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract FindTheWordFixed {

    struct Commit {
        bytes32 solution;
        uint256 commitTime;
        bool revealed;
    }

    mapping (address => Commit) commits;

    bytes32 public constant secretHash = 0x7ce2480ae379810bd95934eb0abae6daf3a1d1c49a259a0e4d608de64a3700cd;
    address public winner;
    bool public ended;
    uint public reward;

    modifier gameActive() {
        require (!ended, "Game already ended");
        _;
    }

    constructor () payable {
        reward = msg.value;
    }

    function commitSolution (bytes32 _solution) public gameActive{
        Commit storage commit = commits[msg.sender];
        require(commit.commitTime == 0, "Already committed");
        commit.solution = _solution;
        commit.commitTime = block.timestamp;
        commit.revealed = false;
    }

    function getMySolution() public view gameActive returns (bytes32, uint256, bool) {
        Commit storage commit = commits[msg.sender];

        require(commit.commitTime > 0, "No commited yet");
        return (commit.solution, commit.commitTime, commit.revealed);
    }


    function revealSolution(string memory _solution, string memory _key) public gameActive{
        Commit storage commit = commits[msg.sender];
        require(commit.commitTime > 0, "No commited yet");
        require(commit.commitTime < block.timestamp, "Cannot reveal in the same block");
        require(!commit.revealed, "Solution already committed and revealed"); 

        bytes32 solutionHash = keccak256(abi.encodePacked(Strings.toHexString(msg.sender), _solution, _key));

        require (solutionHash == commit.solution, "Hash doesn't match"); 
        require (keccak256(abi.encodePacked(_solution))==secretHash, "Incorrect answer");

        winner = msg.sender;
        ended = true; 

        (bool sent, ) = payable(msg.sender).call{value: reward}("");

    }





}