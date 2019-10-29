pragma solidity ^0.5.0;

// safemath lib

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {

    }


    function sub(uint256 a, uint256 b) internal pure returns (uint256) {

    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        
    }


    function div(uint256 a, uint256 b) internal pure returns (uint256) {

    }


    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        
    }


    function mod(uint256 a, uint256 b) internal pure returns (uint256) {

    }


    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {

    }
}



// IERC20 Interface


interface IERC20 {
 
    function totalSupply() external view returns (uint256);

 
    function balanceOf(address account) external view returns (uint256);


    function transfer(address recipient, uint256 amount) external returns (bool);

 
    function allowance(address owner, address spender) external view returns (uint256);


    function approve(address spender, uint256 amount) external returns (bool);


    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);


    event Approval(address indexed owner, address indexed spender, uint256 value);
}


//minterrole contract

// contract MinterRole is Context {
//     using Roles for Roles.Role;

//     event MinterAdded(address indexed account);
//     event MinterRemoved(address indexed account);

//     Roles.Role private _minters;

//     constructor () internal {
//         _addMinter(_msgSender());
//     }

//     modifier onlyMinter() {
//         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
//         _;
//     }

//     function isMinter(address account) public view returns (bool) {
//         return _minters.has(account);
//     }

//     function addMinter(address account) public onlyMinter {
//         _addMinter(account);
//     }

//     function renounceMinter() public {
//     }

//     function _addMinter(address account) internal {

//     }

//     function _removeMinter(address account) internal {

//     }
// }

//erc20detailed contract

contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name, string memory symbol, uint8 decimals) public {

    }

    function name() public view returns (string memory) {
        return _name;
    }


    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

//painting contract

contract PaintingToken is ERC20Detailed {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;
    
    mapping (address => uint256) public percentageShare;
    
    uint256 public percentageTotal;

    mapping (address => bool) public participants;
    
    uint256 public totalParticipants = 0;
    
    constructor(string memory name, string memory symbol, uint8 decimals,uint256 totalSupply) ERC20Detailed(name,symbol,decimals) public {

    }


    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

 
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }


    function transfer(address recipient, uint256 amount) public returns (bool) {

    }

    function allowance(address owner, address spender) public view returns (uint256) {

    }


    function approve(address spender, uint256 amount) public returns (bool) {

    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {

    }

 
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {

    }


    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {

    }

  
    function _transfer(address sender, address recipient, uint256 amount) internal {

        

    }


    function _approve(address owner, address spender, uint256 amount) internal {

    }
    
    function getParticipantState(address _address) public view returns (bool){
        return participants[_address];
    }
    
    function getPercentageShare(address _address) public view returns (uint256){
        return percentageShare[_address];
    }
    
    function getTotalParticipant() public view returns (uint256){

    }
}



