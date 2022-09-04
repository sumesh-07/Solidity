// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

// The main moto of this smart contract is to raised funding for social use through smart contract functionality

contract crowdFund {
    address public  manager;              
    uint public minimumAmount;
    uint public deadline;
    uint public target;
    uint public totalAmt;
    uint public noOfContributors;

    struct Request {
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping (address=>bool) voters;

    }

    mapping(address=>uint) public contributors;
    mapping (uint=>Request) public requests;

    constructor (uint _tar,uint _deadline) public //int constructor we have passed two parameters one is target and deadline
    {
        manager = msg.sender;
        minimumAmount = 100 wei;
        target = _tar;
        deadline = block.timestamp+_deadline;
        
    }

    uint extraAmt;

    function sendContribution()public payable 
    {
        require(msg.value >minimumAmount , "minimum amout is 100 wei");
        require(block.timestamp < deadline , "deadline closed");
       // require(target > totalAmt , "check target amt");   // added
        if((totalAmt +msg.value) > target)
        {
            extraAmt = target - totalAmt;
        
        }

        if(contributors[msg.sender] ==0)
        {
            noOfContributors++;
        }

        contributors[msg.sender]=msg.value;
        totalAmt += msg.value;

        if(extraAmt>0)
        {
            
            address payable user = payable(msg.sender);
            user.transfer(extraAmt);
            totalAmt = totalAmt-extraAmt;
            
          
        }
    }

    function contractBalance()public view returns(uint)
    {
        return address(this).balance;
        
    }

    function refund()public 
    {
        require(contributors[msg.sender] >0 , "you are not a contributor");
        require(deadline < block.timestamp , "deadline is not occured");
        require(totalAmt < target, "you cannot widraw your funds");

        address payable user = payable(msg.sender);
        user.transfer(contributors[msg.sender]);
        totalAmt = totalAmt-contributors[msg.sender];   // added
        contributors[msg.sender]=0;
        
        
    }

    uint cnt=0;
    modifier onlyManager()
    {
        require(manager==msg.sender);
        _;
    }

    function createRequest(string memory _des,address payable  _add,uint _val) public onlyManager 
    {
        Request storage newReq=requests[cnt];
        cnt++;
        newReq.description = _des;
        newReq.recipient=_add;
        newReq.value=_val;
        newReq.completed=false;
        newReq.noOfVoters=0;

    }
   // "bui"0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,1000

    function viewReq(uint _num)public view returns (string memory description,address payable recipient,uint value) 
     {
        Request storage req = requests[_num];

        return (req.description,req.recipient,req.value);
    }

    function vote(uint idx)public
    {
        require(contributors[msg.sender]>0,"you must be a contributor");
        Request storage req = requests[idx];

        require(req.voters[msg.sender]==false,"you already voted");
        req.voters[msg.sender]==true;
        req.noOfVoters++;
    

    }

    function makePayment(uint idx)public  onlyManager
    {
        require(totalAmt >= target);
        Request storage req = requests[idx];

        require(req.completed == false,"request already completed");
        require(req.noOfVoters > noOfContributors/2,"majority does not agree");
        req.recipient.transfer(req.value);
        req.completed=true;

    }

    
    



    








}