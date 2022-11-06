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
    address[] public indeces;

    struct Parameters {
        address _factory;
        int256[] _coefficients;
        int256 _intercept;
        uint8 _accuracy;
        string[] _attributes;
        address _collection;
        address _uma;
        string _name;
        address _denomination;
    }

    Parameters public _parameters;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address[] memory denominations, address _umaAddress) {
        for (uint i = 0; i < denominations.length; i++) {
            valid_denomination[denominations[i]] = true;
        }

        uma = _umaAddress;
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
        string memory _name
    ) external nonReentrant returns (address index) {
        require(getIndex[_name] == address(0), "Index with given _name already exists.");
        require(valid_denomination[_denomination], "Collateral _denomination token is not approved.");

        index = deploy(address(this), _coefficients, _intercept, _accuracy, _attributes, _collection, _denomination, _name);

        getIndex[_name] = index;
        isIndex[index] = true;
        indeces.push(index);

        emit IndexCreated(_coefficients, _intercept, _accuracy, _attributes, _collection, _denomination, _name, index);
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
        string memory
    ) {
        return (_parameters._factory, _parameters._coefficients, _parameters._intercept, _parameters._accuracy, _parameters._attributes, _parameters._collection, _parameters._uma, _parameters._denomination, _parameters._name);
    }

    function isValid(address index) external view returns (bool) {
        return isIndex[index];
    }

    /*//////////////////////////////////////////////////////////////
                            INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function deploy(
        address _factory,
        int256[] memory _coefficients,
        int256 _intercept,
        uint8 _accuracy,
        string[] memory _attributes,
        address _collection,
        address _denomination,
        string memory _name
    ) internal returns (address index) {
        _parameters = Parameters({_factory: _factory, _coefficients: _coefficients, _intercept: _intercept, _accuracy:_accuracy, _attributes: _attributes, _collection: _collection, _uma: uma, _denomination: _denomination, _name: _name});
        
        index = address(new Index{salt: keccak256(abi.encode(_coefficients, _intercept, _accuracy, _attributes, _collection, uma, _denomination, _name))}());
        
        delete _parameters;
    }

}
