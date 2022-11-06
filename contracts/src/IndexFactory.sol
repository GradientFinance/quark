// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "solmate/utils/ReentrancyGuard.sol";
import './Index.sol';

contract IndexFactory is ReentrancyGuard {
    
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event IndexCreated(
        int256[] _coefficients,
        int256 _intercept,
        uint8 _accuracy,
        string[] _attributes,
        address indexed _collection,
        address _denomination,
        string indexed _name,
        uint256 _manipulation, 
        bool _opensource,
        address index
    );

    /*//////////////////////////////////////////////////////////////
                                 STORAGE
    //////////////////////////////////////////////////////////////*/

    // Store all the created indeces.
    mapping(string => address) public getIndex;
    mapping(address => bool) public isIndex;
    mapping(address => bool) public valid_denomination;

    address public immutable uma; 
    address public immutable exchange;
    address[] public indeces;

    struct Parameters {
        address _exchange;
        int256[] _coefficients;
        int256 _intercept;
        uint8 _accuracy;
        string[] _attributes;
        address _collection;
        address _denomination;
        address _uma;
        string _name;
        uint256 _manipulation;
        bool _opensource;
    }

    Parameters public _parameters;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor() {
        // WETH (goerli)
        valid_denomination[0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6] = true;
        // USDC (goerli)
        valid_denomination[0x07865c6E87B9F70255377e024ace6630C1Eaa37F] = true;

        // TODO: Add the exchange contract
        exchange = address(0);

        uma = 0xA5B9d8a0B0Fa04Ba71BDD68069661ED5C0848884;
    }

    /*//////////////////////////////////////////////////////////////
                            EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function createIndex(
        int256[] memory _coefficients,
        int256 _intercept,
        uint8 _accuracy,
        string[] memory _attributes,
        address _collection,
        address _denomination,
        string memory _name,
        uint256 _manipulation,
        bool _opensource
    ) external nonReentrant returns (address index) {
        require(getIndex[_name] == address(0), "Index with given _name already exists.");
        require(valid_denomination[_denomination], "Collateral _denomination token is not approved.");

        index = deploy(exchange, _coefficients, _intercept, _accuracy, _attributes, _collection, _denomination, _name, _manipulation, _opensource);

        getIndex[_name] = index;
        isIndex[index] = true;
        indeces.push(index);

        emit IndexCreated(_coefficients, _intercept, _accuracy, _attributes, _collection, _denomination, _name, _manipulation, _opensource, index);
    }

    function getParameters() external view returns (
        address,
        int256[] memory,
        int256,
        uint8,
        string[] memory,
        address,
        address,
        address,
        string memory,
        uint256,
        bool
    ) {
        return (_parameters._exchange, _parameters._coefficients, _parameters._intercept, _parameters._accuracy, _parameters._attributes, _parameters._collection, _parameters._uma, _parameters._denomination, _parameters._name, _parameters._manipulation, _parameters._opensource);
    }

    function isValid(address index) external view returns (bool) {
        return isIndex[index];
    }

    function getIndeces() external view returns (address[] memory) {
        return indeces;
    }

    /*//////////////////////////////////////////////////////////////
                            INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function deploy(
        address _exchange,
        int256[] memory _coefficients,
        int256 _intercept,
        uint8 _accuracy,
        string[] memory _attributes,
        address _collection,
        address _denomination,
        string memory _name,
        uint256 _manipulation,
        bool _opensource
    ) internal returns (address index) {
        _parameters = Parameters({_exchange: _exchange, _coefficients: _coefficients, _intercept: _intercept, _accuracy:_accuracy, _attributes: _attributes, _collection: _collection, _uma: uma, _denomination: _denomination, _name: _name, _manipulation: _manipulation, _opensource: _opensource});
        
        index = address(new Index{salt: keccak256(abi.encode(_coefficients, _intercept, _accuracy, _attributes, _collection, uma, _denomination, _name, _manipulation, _opensource))}());
        
        delete _parameters;
    }

}
