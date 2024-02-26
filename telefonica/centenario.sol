// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC721, ERC721URIStorage, ERC721Pausable, Ownable {
    uint256 private _nextTokenId;
    mapping(address => bool) private _hasMinted;
    mapping(address => bool) public isAllowedToMint;
    address[] public allowedAddresses;

    constructor()
        ERC721("MyToken", "MTK")
    {}

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to, string memory uri) public {
        require(isAllowedToMint[msg.sender], "Not allowed to mint");
        require(!_hasMinted[to], "Address has already minted a token");

        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        _hasMinted[to] = true;
    }

    function addAllowedAddress(address _address) public onlyOwner {
        require(!isAllowedToMint[_address], "Address already allowed");
        isAllowedToMint[_address] = true;
        allowedAddresses.push(_address);
    }

    function removeAllowedAddress(address _address) public onlyOwner {
        require(isAllowedToMint[_address], "Address not in the list");
        isAllowedToMint[_address] = false;

        // Remove the address from the allowedAddresses array
        for (uint256 i = 0; i < allowedAddresses.length; i++) {
            if (allowedAddresses[i] == _address) {
                allowedAddresses[i] = allowedAddresses[allowedAddresses.length - 1];
                allowedAddresses.pop();
                break;
            }
        }
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
