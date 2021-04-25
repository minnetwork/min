pragma solidity 0.5.16;

import "./BEP20Token.sol";

contract MINLP is BEP20Token{
    constructor() BEP20Token("Mutual Insurance Network LP","MIN-LP",18,1e27) public{       
    }

}