// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Asset.sol";


contract Land is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 landPriceAmount = 10000000000000000;
    
    address[] private _assets;

    modifier onlyNFTOwner(uint256 tokenID) {
        require(ownerOf(tokenID) == msg.sender, "You are not the owner of the land");
        _;
    }

    constructor() ERC721("LandNFT", "LNFT") {}

    function mint(string memory tokenURI) public returns (uint256) {
       _tokenIds.increment();
       uint256 newItemId = _tokenIds.current();
       _safeMint(msg.sender, newItemId);
       _setTokenURI(newItemId, tokenURI);
       return newItemId;
   }
    
    function addAssetToLand(address _assetAddress) public {   
        _assets.push(_assetAddress);
    }  

    function getAssets() public view returns (address [] memory) {    
        return _assets;
    }

    // TODO: send ether to land owner
   function sellLand(address to, uint256 tokenID) public payable onlyNFTOwner(tokenID){
       require(msg.value >= landPriceAmount, "Not enough funds to buy land");
       safeTransferFrom(msg.sender, to, tokenID);
   }

   function sellLandWithAssets(address to, uint256 landTokenID) public payable onlyNFTOwner(landTokenID){
        address[] memory assets = getAssets();
        
        for (uint i = 0; i < assets.length; i++) {
            Asset(assets[i]).sellAsset{ value: 10000000000000000 }(to, i+1);
        }

        sellLand(to, landTokenID);
    }  
}
