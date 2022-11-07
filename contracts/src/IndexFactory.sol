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
                         MISCELLANEOUS CONSTANTS
    //////////////////////////////////////////////////////////////*/

    address public immutable uma;

    address public immutable exchange;

    /*//////////////////////////////////////////////////////////////
                                 STORAGE
    //////////////////////////////////////////////////////////////*/

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

    mapping(string => address) public getIndex;

    mapping(address => bool) public isIndex;

    mapping(address => bool) public valid_denomination;

    address[] public indices;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /**
    * @notice Assigns the alloved denominations, UMA oracle, and Exchange address.
    * @param _denominations Array of valid denomination addresses.
    * @param _uma Address of UMA oracle.
    * @param _exchange Address of Exchange.
    **/
    constructor(address[] memory _denominations, address _uma, address _exchange) {
        for (uint i = 0; i < _denominations.length; i++) {
            valid_denomination[_denominations[i]] = true;
        }

        uma = _uma;
        exchange = _exchange;
    }

    /*//////////////////////////////////////////////////////////////
                            EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
    * @notice Creates a custom price index.
    * @param _coefficients Coefficients of trained linear model.
    * @param _intercept Intercept of trained linear model.
    * @param _accuracy Reported r^2 accuracy of trained linear model.
    * @param _attributes Targetted attributes of given NFT collection.
    * @param _collection Address of NFT collecion.
    * @param _denomination Denomination token collateral for index.
    * @param _name Name of index.
    * @param _manipulation Manipulation score of index.
    * @param _opensource True if open source, false if not.
    **/
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
        indices.push(index);

        emit IndexCreated(_coefficients, _intercept, _accuracy, _attributes, _collection, _denomination, _name, _manipulation, _opensource, index);
    }

    /**
    * @notice Returns the parameters to the newly created index.
    **/
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

    /**
    * @notice Verifies that a given address is a valid index created by the factory.
    **/
    function isValid(address index) external view returns (bool) {
        return isIndex[index];
    }

    /**
    * @notice Returns all the indices created by the factory.
    **/
    function getIndices() external view returns (address[] memory) {
        return indices;
    }

    /*//////////////////////////////////////////////////////////////
                            INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
    * @notice Deploys a price index with the given parameters.
    * @param _exchange Address of Exchange.
    * @param _coefficients Coefficients of trained linear model.
    * @param _intercept Intercept of trained linear model.
    * @param _accuracy Reported r^2 accuracy of trained linear model.
    * @param _attributes Targetted attributes of given NFT collection.
    * @param _collection Address of NFT collecion.
    * @param _denomination Denomination token collateral for index.
    * @param _name Name of index.
    * @param _manipulation Manipulation score of index.
    * @param _opensource True if open source, false if not.
    **/
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
