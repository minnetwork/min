pragma solidity 0.5.16;

import "./Context.sol";
import "./Ownable.sol";
import "./Pausable.sol";
import "./IBEP20.sol";

contract MINStaking is Context,Ownable,Pausable{
    
    uint private insureAmount;
    

    //投保成功事件
    event Insured(address insurer,uint amount,uint MINAmount);
    
    IBEP20 constant internal busdInstance = IBEP20(0xF1BE3176b53E9C4d5938631BD0F964Cf1dBBe044);
    IBEP20 constant internal mintInstance = IBEP20(0x8eeC8a0C24174CF0BdCB23665d7454eabAAB5Be3);
    IBEP20 constant internal mintLPInstance = IBEP20(0xd984ffdD3c2E4fA6E1Fa13722262af1B8A4C564b);
    
    /*
    * 投保
     */ 
    function insure(uint insureBusdAmount,uint MINAmount) public payable whenNotPaused{
         require(insureBusdAmount >0&&MINAmount>0, "Not enough input");
         address sender = _msgSender();
         
         busdInstance.transferFrom(sender,address(this),insureBusdAmount*1e18);
         mintInstance.transferFrom(sender,address(this),MINAmount*1e18);
         records[sender].push(InsuranceRecords(block.timestamp,insureBusdAmount*1e18,MINAmount*1e18));
         emit Insured(sender,insureBusdAmount*1e18,MINAmount*1e18);
    }
    
    // 合约内部授权后，才能投资，用于测式 --需要在UI端，因为在合约时，msg就是合约
    // function toUsdtApprove(address spender,uint amount) public returns(bool){
    //   return busdInstance.approve(spender,amount*1e18);
    // }
    // //合约内部授权后，才能投资，用于测式 南--需要在UI端，因为在合约时，msg就是合约
    // function toMinApprove(address spender,uint amount) public returns(bool){
    //   return mintInstance.approve(spender,amount*1e18);
    // }

    function getUsdtAllowance(address spender) public view returns(uint){
        return busdInstance.allowance(_msgSender(),spender);
    }
    
    function getMinAllowance(address spender) public view returns(uint){
        return mintInstance.allowance(_msgSender(),spender);
    }
    
    function getInsureRecords() public view returns(uint[3][] memory){
        InsuranceRecords[] memory records =  records[_msgSender()];
        uint[3][] memory v = new uint[3][](records.length);

        for(uint32 i=0;i<records.length;i++){
            v[i][0] = records[i].insuranceTime;
            v[i][1] = records[i].insuranceAmount;
            v[i][2] = records[i].MINAmount;
        }
        return v;
    }
    
    //投资人地址==>投资记录数组
    mapping(address=>InsuranceRecords[]) records;

    // 投保记录
    struct InsuranceRecords{
        //投保时间
        uint insuranceTime;
        //投保金额
        uint insuranceAmount;
        //投保时 MIN的数量
        uint MINAmount;
    }


}