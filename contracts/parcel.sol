// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// import "./ERC721Tradable.sol";

/// @author CityDAO team
/// @title A simple ERC721 token that represents land parcels

contract Parcel is ERC721Parcel {
    constructor(address _proxyRegistryAddress)
        ERC721Tradable("CityDAO land parcels", "CITY", _proxyRegistryAddress)
    {}

    function baseTokenURI() public pure override returns (string memory) {
        return "https://parcels.cityDAO.com/api/parcels/";
    }

    function contractURI() public pure returns (string memory) {
        return "https://parcels.cityDAO.com/contracts/ERC721-parcels";
    }
}
