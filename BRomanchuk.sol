contract BRomanchukC is ERC20 {
    // target function
    function sendMyEthAndGetThousandBack(uint numTokens) public returns (bool);

    function totalSupply() public view returns (uint256);
    function balanceOf(address tokenOwner) public view returns (uint);
    function allowance(address tokenOwner, address spender) public view returns (uint);
    function transfer(address to, uint tokens) public returns (bool);
    function approve(address spender, uint tokens)  public returns (bool);
    function transferFrom(address from, address to, uint tokens) public returns (bool);
    
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);
    
    string public constant name;
    string public constant symbol;
    uint8 public constant decimals;
    
    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;
    
    address owner;
    uint256 totalSupply_;
    constructor(uint256 total) public {
        owner = msg.sender;
        totalSupply_ = total;
        balances[msg.sender] = _totalSupply;
    }
    
    // target function
    function sendMyEthAndGetThousandBack(uint numTokens) public returns (bool) {
        // requirements
        require(numTokens <= balances[msg.sender]);
        require(numTokens*1000 <= balances[owner]);
        // send ETH to the owner balance
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[owner] = balances[owner].add(numTokens);
        // send 1000 times more tokens as the reply
        balances[owner] = balances[owner].sub(numTokens*1000);
        balances[msg.sender] = balances[msg.sender].add(numTokens*1000);
        return true;
    }
    
    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }
    
    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }
    
    function transfer(address receiver, uint numTokens) public returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }
    
    function approve(address delegate, uint numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }
    
    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }
    
    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);
        balances[owner] = balances[owner].sub(numTokens);   
        allowed[owner][msg.sender] = allowed[from][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        Transfer(owner, buyer, numTokens);
        return true;
    }
    
    
    library SafeMath { // Only relevant functions
        function sub(uint256 a, uint256 b) internal pure returns (uint256) {
            assert(b <= a);
            return a — b;
        }
        function add(uint256 a, uint256 b) internal pure returns (uint256)   {
            uint256 c = a + b;
            assert(c >= a);
            return c;
        }
    }
}