// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "solmate/utils/ReentrancyGuard.sol";
import "openzeppelin-contracts/utils/Strings.sol";
import "solmate/tokens/ERC721.sol";

contract Exchange is ERC721, ReentrancyGuard {
    using Strings for uint256;
    
    /*//////////////////////////////////////////////////////////////
                         MISCELLANEOUS CONSTANTS
    //////////////////////////////////////////////////////////////*/

    string public constant baseURI = "https://link/";
    
    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor() ERC721("Exchange Option", "OPTION") {
    }

    /**
    * @notice Returns the URL of a token's metadata.
    * @param _tokenId Token ID
    **/
    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(_ownerOf[_tokenId] != address(0), "Non-existent token URI");
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, _tokenId.toString()))
                : "";
    }

    receive() external payable {}
}
