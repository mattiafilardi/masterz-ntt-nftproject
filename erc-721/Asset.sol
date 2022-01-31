// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract Asset is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 public assetPriceAmount = 10000000000000000;

    constructor() ERC721("AssetsNFT", "ANFT") {}

    function mint(string memory tokenURI) public returns (uint256) {
       _tokenIds.increment();
       uint256 newItemId = _tokenIds.current();
       _safeMint(msg.sender, newItemId);
       _setTokenURI(newItemId, tokenURI);
       return newItemId;
   }

    // The address of the LandNTFContract must be approved before execute this function
    // TODO: send ether to asset owner
   function sellAsset(address to, uint256 tokenID) public payable {
       require(msg.value >= assetPriceAmount, "Not enough funds to buy asset");
        address owner = ownerOf(tokenID);
        
        safeTransferFrom(owner, to, tokenID);
    }

}
