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
    
    function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
        uint256 c = add(a,m);
        uint256 d = sub(c,1);
        return mul(div(d,m),m);
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
        
        uint256 balanceOfReceiver = balanceOf(recipient);
        uint256 balanceOfSender = balanceOf(sender);
        
        uint256 percentage = (balanceOfReceiver/_totalSupply)*100;
        uint256 percentageOfSender = (balanceOfSender/_totalSupply)*100;
        
        // to maintain the % share of receiver
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
        
        // to maintian the % share of sender also
    	if(balanceOfSender == 0){
            participants[sender] = false;
            totalParticipants = totalParticipants.sub(1);
	    }else{
	         if(percentageOfSender>=25 && percentageOfSender <50){
                percentageShare[sender] = 1;
            }else if(percentageOfSender>=50 && percentageOfSender <75){
                percentageShare[sender] = 2;
            }else if(percentageOfSender>=75){
                percentageShare[sender] = 3;
                
            }
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
    
    function getTotalPercentage() public view returns (uint256){
        return percentageTotal;
    }
}

//incentivetoken contract

contract IncentiveToken is ERC20Detailed {
    using SafeMath for uint256;
    
    uint256 private _totalSupply;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;
    
    uint256 public basePercent = 100;


// distributor properties
    uint256 public roundMask;
    uint256 public lastMintedBlockNumber;
    uint256 public tokensPerBlock; 
    uint256 public blockFreezeInterval; 
    address public tokencontractAddress = address(this);
    address public tokencontractAddressPainting = address(0x00db1B2A1Dc8B758011305822c60143c372535B8);
    PaintingToken contractInstance = PaintingToken(tokencontractAddressPainting);
    mapping(address => uint256) public participantMask;
    
    constructor(string memory name, string memory symbol, uint256 totalSupply,uint256 _tokensPerBlock, uint256 _blockFreezeInterval) ERC20Detailed(name,symbol,2) public {
        _totalSupply = totalSupply;
        _balances[msg.sender] = _totalSupply;
	    lastMintedBlockNumber = block.number;
        tokensPerBlock = _tokensPerBlock;
        blockFreezeInterval = _blockFreezeInterval;
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
        transfer(msg.sender, amount.add(amount.mul(contractInstance.getPercentageShare(msg.sender))));
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
        tokenReleaseAmount = tokenReleaseAmount.mul(contractInstance.getTotalPercentage());
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
    
