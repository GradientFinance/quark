// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface LongShortPair {
    function claimFees(uint256 claimAmount, address recipient) external;
    function getClaimableFeesAmount() external view returns (uint256);
}

contract FeeToken is ERC721, ERC721Burnable, Ownable {
    mapping(uint256 => address) public longShortPairs; // maps the token id to the long short pair that it receives the fees for

    constructor(address optionContract_) ERC721("Fees Recipient", "FeesRecipient") {}

    function mint(address recipient, uint256 tokenId, address longShortPair_) external onlyOwner {
        longShortPairs[tokenId] = longShortPair_;
        _mint(recipient, tokenId);
    }

    function claimFees(uint256 tokenId, uint256 claimAmount, address recipient) public {
        LongShortPair(longShortPairs[tokenId]).claimFees(claimAmount, recipient);
    }

    function claimAllFees(uint256 tokenId, address recipient) external {
        claimFees(tokenId, LongShortPair(longShortPairs[tokenId]).getClaimableFeesAmount(), recipient);
    }
}