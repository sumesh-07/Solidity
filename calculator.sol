// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

contract cal {
    uint firstNum;
    uint secNum;

    function getFirstNum(uint a) public
    {
        firstNum=a;
    }

    function getSecNum(uint b) public
    {
        secNum=b;
    }

    function add() public view returns(uint)
    {
        uint ans= firstNum + secNum;
        return ans;
    }

    function sub() public view returns(uint)
    {
        uint ans= firstNum - secNum;
        return ans;
    }

    function mul() public view returns(uint)
    {
        uint ans= firstNum * secNum;
        return ans;
    }

    function div() public view returns(uint)
    {
        uint ans= firstNum / secNum;
        return ans;
    }
}