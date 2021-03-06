pragma solidity 0.4.21;

import "./TitanToken.sol";
/*Implements token factory 
*/
contract SuperTitan{
    //this is only for testing purpose 
    address public addr ;
    //counter is used to count the token number
    uint public counter;
    struct Tokendetails {
        uint256 initialSupply;
        bytes32 symbol;
        bytes32 name;
        address tokenaddress;
        //currentholdings for initialSupply-spending tokens
        //uint256 currentholdings; 
        
    }
    mapping(
        uint => Tokendetails
        )public tokendetails;
   
        
    //superowner is the address  who can deploy the contract 
    //address superowner;
    modifier check_registered(bytes32 _tokenname, bytes32 _symbol){
        for(uint i=0; i<counter; i++){
        assert(!(tokendetails[counter].name == _tokenname));
        assert(!(tokendetails[counter].symbol == _symbol));
        }
        _;
        
    }
    event TokenAddedToTitan(address, bytes32);
    //modifier only_superTitanOwner(address){
    //    require(msg.sender==superowner);
    //    _;
    //    }
    
    function SuperTitan()public{}
    
    
    //add new token in the list of token types 
    function addToken(address _tokenaddress, bytes32 _tokenname, bytes32 _symbol, uint256 _initialSupply)
    //only_superTitanOwner(msg.sender) 
    private {
    
        tokendetails[counter].tokenaddress = _tokenaddress;
        tokendetails[counter].name = _tokenname;
        tokendetails[counter].symbol = _symbol;
        tokendetails[counter].initialSupply =_initialSupply;
        //tokendetails[counter].currentholdings = _initialSupply; 
        counter++;
        
    }
    
    function viewTokens()
    public
    view
    returns(address[], bytes32[], bytes32[], uint256[]){
        address[] memory arr_address = new address[](counter);
        bytes32[] memory arr_name = new bytes32[](counter);
        bytes32[] memory arr_symbol = new bytes32[](counter);
        uint256[] memory arr_initialsupply = new uint256[](counter);
        //uint256[] memory arr_currentholdings =  new uint256[](counter);
        Tokendetails memory currentTokendetails;
        for(uint i=0; i<counter; i++){
            currentTokendetails = tokendetails[i];
            arr_address[i] = currentTokendetails.tokenaddress;
            arr_name[i] = currentTokendetails.name;
            arr_symbol[i] = currentTokendetails.symbol;
            arr_initialsupply[i] = currentTokendetails.initialSupply;
            //arr_currentholdings[i] = currentTokendetails.currentholdings;
         
        }
        return(arr_address,arr_name,arr_symbol,arr_initialsupply);
    }

   
    //Generating new Token . 
    function newToken(uint256 _initialSupply, bytes32 _name, bytes32 _symbol) 
    //only_superTitanOwner(msg.sender)
    check_registered(_name, _symbol)
    public
    returns(address, bytes32){
        TitanToken T = new TitanToken(_initialSupply,_name,_symbol);
        addToken(T, _name, _symbol, _initialSupply);
        emit TokenAddedToTitan(T, _name);
        //addr used for testing purpose
        addr = T;
        return (T, _name);
    }
}


