pragma solidity 0.5.16;

import "./Ownable.sol";

contract Pausable is Ownable{
     event Pause(address account);
     event Unpause(address account);

     bool private _paused;

     constructor () internal{
          _paused = false;
     }

     function paused() public view returns(bool){
          return _paused;
     }
    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
     modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }
    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
     modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

     /**
     * @dev Called by a pauser to pause, triggers stopped state.
     */
    function pause() public onlyOwner whenNotPaused {
        _paused = true;
        emit Pause(msg.sender);
    }

    /**
     * @dev Called by a pauser to unpause, returns to normal state.
     */
    function unpause() public onlyOwner whenPaused {
        _paused = false;
        emit Unpause(msg.sender);
    }

}