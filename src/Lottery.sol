// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "solmate/utils/SafeTransferLib.sol";
import "solmate/tokens/ERC20.sol";

contract Lottery is Ownable {
    using SafeTransferLib for ERC20;

    ERC20 public rewardToken; // 奖励代币

    struct Round {
        address owner; // 轮次创建者
        uint256 startTime; // 开始时间戳
        uint256 endTime; // 结束时间戳
        uint256[3] numbers; // 中奖号码
        uint256[3] rewards; // 各等级奖励数量
        bytes32 merkleRoot; // merkle树根
        bool isSettled; // 是否已开奖
        bool isEnded; // 是否已结束
        mapping(address => bool) hasClaimed; // 记录地址是否已领奖
    }

    mapping(uint256 => Round) public rounds;
    uint256 public currentRound;

    event RoundCreated(uint256 indexed roundNum, uint256 startTime, uint256 endTime, uint256[3] rewards);
    event RoundSettled(uint256 indexed roundNum, uint256[3] numbers);
    event RewardClaimed(uint256 indexed roundNum, address indexed user, uint256 level, uint256 amount);

    constructor(address _rewardToken) Ownable(msg.sender) {
        rewardToken = ERC20(_rewardToken);
    }

    // round
    function createRound(uint256 startTime, uint256 endTime, uint256[] memory rewards) external {
        require(startTime < endTime, "Invalid time range");

        // check
        uint256 totalRewards = rewards[0] + rewards[1] + rewards[2];
        require(rewardToken.balanceOf(address(this)) >= totalRewards, "Insufficient reward token balance");

        currentRound++;
        Round storage newRound = rounds[currentRound];

        newRound.owner = msg.sender;
        newRound.startTime = startTime;
        newRound.endTime = endTime;
        newRound.rewards[0] = rewards[0];
        newRound.rewards[1] = rewards[1];
        newRound.rewards[2] = rewards[2];
        newRound.merkleRoot = bytes32(0);
        newRound.isSettled = false;
        newRound.isEnded = false;

        emit RoundCreated(currentRound, startTime, endTime, [rewards[0], rewards[1], rewards[2]]);
    }

    // fake vfr
    function generateRandom() internal view returns (uint256[3] memory) {
        uint256[3] memory numbers;
        bytes32 hash = keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender));

        // 0-9
        numbers[0] = uint256(hash) % 10;
        numbers[1] = uint256(keccak256(abi.encodePacked(hash, "SECOND"))) % 10;
        numbers[2] = uint256(keccak256(abi.encodePacked(hash, "THIRD"))) % 10;

        return numbers;
    }

    // 开奖
    function settleRound(uint256 roundNum, bytes32 merkleRoot) external {
        Round storage round = rounds[roundNum];

        require(block.timestamp >= round.endTime, "Round not ended yet");
        require(!round.isSettled, "Round already settled");

        round.numbers = generateRandom();
        round.merkleRoot = merkleRoot;
        round.isSettled = true;
        round.isEnded = true;

        emit RoundSettled(roundNum, round.numbers);
    }

    // 领取奖励
    function claimReward(uint256 roundNum, uint256 level, bytes32[] calldata merkleProof) external {
        require(level < 3, "Invalid reward level");
        Round storage round = rounds[roundNum];

        require(round.isSettled, "Round not settled");
        require(!round.hasClaimed[msg.sender], "Already claimed");

        // merkle
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, level));
        require(MerkleProof.verify(merkleProof, round.merkleRoot, leaf), "Invalid merkle proof");

        round.hasClaimed[msg.sender] = true;

        // SafeTransferLib
        uint256 reward = round.rewards[level];
        rewardToken.safeTransfer(msg.sender, reward);

        emit RewardClaimed(roundNum, msg.sender, level, reward);
    }

    // query claim
    function hasUserClaimed(uint256 roundNum, address user) external view returns (bool) {
        return rounds[roundNum].hasClaimed[user];
    }

    // query round info
    function getRoundInfo(uint256 roundNum)
        external
        view
        returns (
            address owner,
            uint256 startTime,
            uint256 endTime,
            uint256[3] memory numbers,
            uint256[3] memory rewards,
            bool isSettled,
            bool isEnded
        )
    {
        Round storage round = rounds[roundNum];
        return
            (round.owner, round.startTime, round.endTime, round.numbers, round.rewards, round.isSettled, round.isEnded);
    }

    function emergencyWithdraw(uint256 amount) external onlyOwner {
        rewardToken.safeTransfer(msg.sender, amount);
    }
}
