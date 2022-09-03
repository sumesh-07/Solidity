// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

contract helloSolidity {
    string massage;
    function hello()public returns(string memory)
    {
        massage = "hello solidty :)";
        return massage;
    }


}