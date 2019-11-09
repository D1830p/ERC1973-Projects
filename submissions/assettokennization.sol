pragma solidity ^0.5.0;

// safemath lib

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }


    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }


    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }


    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }


    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }


    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

//role lib

// library Roles {
//     struct Role {
//         mapping (address => bool) bearer;
//     }

//     function add(Role storage role, address account) internal {
//         require(!has(role, account), "Roles: account already has role");
//         role.bearer[account] = true;
//     }

//     function remove(Role storage role, address account) internal {
//         require(has(role, account), "Roles: account does not have role");
//         role.bearer[account] = false;
//     }

//     function has(Role storage role, address account) internal view returns (bool) {
//         require(account != address(0), "Roles: account is the zero address");
//         return role.bearer[account];
//     }
// }

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

//Context sol

// contract Context {
//     constructor () internal { }
//     // solhint-disable-previous-line no-empty-blocks

//     function _msgSender() internal view returns (address) {
//         return msg.sender;
//     }

//     function _msgData() internal view returns (bytes memory) {
//         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
//         return msg.data;
//     }
// }

// ownable contract

// contract Ownable is Context {
//     address private _owner;

//     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
//     constructor () internal {
//         _owner = _msgSender();
//         emit OwnershipTransferred(address(0), _owner);
//     }

//     function owner() public view returns (address) {
//         return _owner;
//     }

//     modifier onlyOwner() {
//         require(isOwner(), "Ownable: caller is not the owner");
//         _;
//     }

//     function isOwner() public view returns (bool) {
//         return _msgSender() == _owner;
//     }

//     function renounceOwnership() public onlyOwner {
//         emit OwnershipTransferred(_owner, address(0));
//         _owner = address(0);
//     }

//     function transferOwnership(address newOwner) public onlyOwner {
//         _transferOwnership(newOwner);
//     }

//     function _transferOwnership(address newOwner) internal {
//         require(newOwner != address(0), "Ownable: new owner is the zero address");
       emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
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
//         _removeMinter(_msgSender());
//     }

//     function _addMinter(address account) internal {
//         _minters.add(account);
//         emit MinterAdded(account);
//     }

//     function _removeMinter(address account) internal {
//         _minters.remove(account);
//         emit MinterRemoved(account);
//     }
// }

//erc20detailed contract

contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
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
        _totalSupply = totalSupply;
        _balances[msg.sender] = _totalSupply;
    }


    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

 
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }


    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }


    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender,msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

 
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }


    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

  
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        
        uint256 percentage = (amount/_totalSupply)*100;
        if(percentage>1){
            if(percentage>=25 && percentage <50){
                percentageShare[recipient] = 1;    
                percentageTotal = percentageTotal.add(1);
            }else if(percentage>=50 && percentage <75){
                percentageShare[recipient] = 2;
                percentageTotal = percentageTotal.add(2);
            }else if(percentage>=75){
                percentageShare[recipient] = 3;
                percentageTotal = percentageTotal.add(3);
            }
        }
        
        if(participants[recipient]==false){
            totalParticipants = totalParticipants.add(1);
            participants[recipient] = true;
        }
        
    	if(balanceOf(sender) == 0){
            participants[sender] = false;
            totalParticipants = totalParticipants.sub(1);
	    }else{
            participants[sender] = true;
    	}
        emit Transfer(sender, recipient, amount);
    }


    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    
    function getParticipantState(address _address) public view returns (bool){
        return participants[_address];
    }
    
    function getPercentageShare(address _address) public view returns (uint256){
        return percentageShare[_address];
    }
    
    function getTotalParticipant() public view returns (uint256){
        return totalParticipants;
    }
}

//incentivetoken contract

contract IncentiveToken is ERC20Detailed {
    using SafeMath for uint256;
    
    uint256 private _totalSupply;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;


// distributor properties
    uint256 public roundMask;
    uint256 public lastMintedBlockNumber;
    uint256 public tokensPerBlock; 
    uint256 public blockFreezeInterval; 
    address public tokencontractAddress = address(this);
    address public tokencontractAddressPainting = address(0x00db1B2A1Dc8B758011305822c60143c372535B8);
    PaintingToken contractInstance = PaintingToken(tokencontractAddressPainting);
    mapping(address => uint256) public participantMask;
    
    constructor(string memory name, string memory symbol, uint8 decimals,uint256 totalSupply,uint256 _tokensPerBlock, uint256 _blockFreezeInterval) ERC20Detailed(name,symbol,decimals) public {
        _totalSupply = totalSupply;
        _balances[msg.sender] = _totalSupply;
	    lastMintedBlockNumber = block.number;
        tokensPerBlock = _tokensPerBlock;
        blockFreezeInterval = _blockFreezeInterval;
       // contractInstance = PaintingToken(tokencontractAddressPainting);
    }
    

     modifier isAuthorized() {
//        require(isMinter(msg.sender));
	    require(contractInstance.getParticipantState(msg.sender) == true);
        _;
    }

  
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

 
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }


    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(address(this), recipient, amount);
        return true;
    }

  
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }


    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }


    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender,msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }


    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }


    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }


    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }


    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
    
    
    function mint(address account, uint256 amount) public isAuthorized returns (bool) {
        _mint(account, amount);
        return true;
    }
    

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    
    // for reward we are using the same contract

//    modifier isAuthorized() {
//        require(isMinter(msg.sender));
//	    require(tokencontractAddressPainting.balanceOf(msg.sender) > 0);
//        _;
//    }

    //function addMinters(address _minter) external returns (bool) {
    //    _addMinter(_minter);
    //    totalParticipants = totalParticipants.add(1);
    //    updateParticipantMask(_minter);
    //    return true;
    // }


 
    //function removeMinters(address _minter) external returns (bool) {
    //    totalParticipants = totalParticipants.sub(1);
    //    _removeMinter(_minter); 
    //    return true;
    //}


    function trigger() external isAuthorized returns (bool) {
        bool res = readyToMint();
        if(res == false) {
            return false;
        } else {
            mintTokens();
        return true;
        }
    }


    function withdraw() external isAuthorized returns (bool) {
        uint256 amount = calculateRewards();
        require(amount >0);
        transfer(msg.sender, amount.add((amount.mul(contractInstance.getPercentageShare(msg.sender)))));
    }

    function readyToMint() public view returns (bool) {
        uint256 currentBlockNumber = block.number;
        uint256 lastBlockNumber = lastMintedBlockNumber;
        if(currentBlockNumber > lastBlockNumber + blockFreezeInterval) { 
            return true;
        } else {
            return false;
    	}
    }


    function calculateRewards() private returns (uint256) {
        uint256 playerMask = participantMask[msg.sender];
        uint256 rewards = roundMask.sub(playerMask);
        updateParticipantMask(msg.sender);
        return rewards;
    }

  
    function mintTokens() private returns (bool) {
        uint256 currentBlockNumber = block.number;
        
        //multiply to cover up % reward
        uint256 tokenReleaseAmount = (currentBlockNumber.sub(lastMintedBlockNumber)).mul(tokensPerBlock);
        lastMintedBlockNumber = currentBlockNumber;
        mint(tokencontractAddress, tokenReleaseAmount);
        calculateTPP(tokenReleaseAmount);
        return true;
    }


    function calculateTPP(uint256 tokens) private returns (bool) {
        uint256 tpp = tokens.div(contractInstance.getTotalParticipant());
        updateRoundMask(tpp);
        return true;
    }


    function updateRoundMask(uint256 tpp) private returns (bool) {
        roundMask = roundMask.add(tpp);
        return true;
    }


    function updateParticipantMask(address participant) private returns (bool) {
        uint256 previousRoundMask = roundMask;
        participantMask[participant] = previousRoundMask;
        return true;
    }
    
}
