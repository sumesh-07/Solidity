// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract VotingSystem {
    struct candidate {
        address candidateAddr;            // candidates struct 
        string name;
        string party;
        uint noOfvoters;
    }

    struct voters{
        address addr;                  // voters  struct
        bool isVoted;
        
     }

    mapping(uint=>candidate) public  candidatelist;    // key-value pair (0  , struct{ candidate})
    mapping (uint=>voters) public  voterList;      // (0  , struct{ voter })
    mapping (address=>bool) public voteCheack;     // (0x583031D1113aD414F02576BD6afaBfb302140225  , flase)
    uint candidateCnt;
    uint public globalVoters;
    uint public totalcandidate;
    address owner;
    uint votingPeriod;

    constructor(uint time)
    {
        owner = msg.sender;
        votingPeriod=block.timestamp+time;
    }

    modifier onlyOwner()
    {
        require(msg.sender==owner,"you cannot have access to call this function");
        _;
    }

    function createUmdevar(string memory _name,string memory _party,address addr) public 
    {
        candidate storage u1=candidatelist[candidateCnt];
        candidateCnt++;
        u1.name = _name;
        u1.party = _party;
        u1.candidateAddr=addr;
        totalcandidate++;
        
    }

    uint voterCnt;
    bool cheackcandidate=false;

    function vote(uint idx)public 
    {
        for(uint i=0;i<=totalcandidate;i++)
        {
            candidate storage u1 = candidatelist[i];
            if(u1.candidateAddr == msg.sender)
            {
            cheackcandidate=true;

            }
            
        }
        require(cheackcandidate == false,"you are candidate,you are not eligible to vote");

        require(voteCheack[msg.sender] == false, "you already voted");
        require(votingPeriod > block.timestamp, "voting period is closed");

        voters storage v1 = voterList[voterCnt];
        voterCnt++;
        v1.addr=msg.sender;
        v1.isVoted=true;

        voteCheack[msg.sender] = true;


        globalVoters++;
        candidate storage u1 = candidatelist[idx];
        u1.noOfvoters++;

    }
    uint num=0;
    string str="winner not decided yet";

    function winnner(uint idx) public onlyOwner returns(string memory) 
    {
        require(block.timestamp > votingPeriod,"voting is live");
        for(uint i=0;i<idx;i++)
        {
            candidate storage u1 = candidatelist[i];
            if(u1.noOfvoters > num)
            {
            num = u1.noOfvoters;
            str = u1.name;

            }
            
        }

        return str;

    }

 









}
