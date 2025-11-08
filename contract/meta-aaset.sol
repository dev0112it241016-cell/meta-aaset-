// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MetaAssetRegistry is ERC721, Ownable {
    struct Asset {
        string name;
        string metadataURI;
        uint256 registrationDate;
    }

    uint256 private _nextTokenId = 1;
    mapping(uint256 => Asset) public assets;

    event AssetRegistered(address indexed owner, uint256 indexed tokenId, string name);
    event AssetTransferred(uint256 indexed tokenId, address indexed from, address indexed to);

    constructor() ERC721("MetaAssetRegistry", "MAR") Ownable(msg.sender) {}

    function registerAsset(string memory _name, string memory _metadataURI) external {
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
        assets[tokenId] = Asset(_name, _metadataURI, block.timestamp);
        emit AssetRegistered(msg.sender, tokenId, _name);
    }

    function transferAsset(address _to, uint256 _tokenId) external {
        require(ownerOf(_tokenId) == msg.sender, "Not asset owner");
        _transfer(msg.sender, _to, _tokenId);
        emit AssetTransferred(_tokenId, msg.sender, _to);
    }

    function getAsset(uint256 _tokenId) external view returns (Asset memory) {
        return assets[_tokenId];
    }
}
// 
End
// 
