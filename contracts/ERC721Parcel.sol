// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

/// @author CityDAO team: @odyslam, @CruzMolina

contract cityDaoParcel is ERC721, Ownable {
    address proxyRegistryAddress;
    int256 parcelId = 0;
    uint256 private _currentTokenId = 0;

    mapping(uint256 => uint256) public tokenSupply;
    mapping(uint256 => address) public parcelIdToOwners;
    mapping(uint256 => Parcel) public parcelIdToParcels;

    constructor(
        string memory _name,
        string memory _symbol,
        address _proxyRegistryAddress
    ) ERC721(_name, _symbol) {
        proxyRegistryAddress = _proxyRegistryAddress;
        _initializeEIP712(_name);
    }

    struct Parcel {
        bytes32 lat;
        bytes32 long;
        uint16 leaseLength;
        string metadataLocationHash;
        // locationHash = IPFS://<hash> or AR://<hash>
    }

    function transferParcel(
        address _toAddress,
        address _fromAddress,
        uint256 _parcelId
    ) public {
        safeTransferFrom(_toAddress, _fromAddress, _parcelId, 1);
        // Assume that the above will revert if _fromAddress does not own the parcel
        parcelIdToOwners[_parcelId] = _toAddress;
    }

    function mintParcelToAddress(
        address _toAddress,
        uint256 _quantity,
        bytes32 _lat,
        bytes32 _long,
        uint16 _leaseLength,
        string _metadataLocationHash
    ) external onlyOwner returns (uint256) {
        uint256 newTokenId = _getNextTokenId();
        Parcel parcel = Parcel(
            _lat,
            _long,
            _leaseLength,
            _metadataLocationHash
        );
        parcelIdToOwners[parcelId] = _toAddress;
        parcelIdToParcels[parcelId] = parcel;
        _mint(_toAddress, parcelId);
        parcelOwners[_toAddress] = parcel;
        _incrementTokenId();
        return parcelId;
    }

    function getParcelOwner(uint256 _parcelId) external view returns (address) {
        return parcelIdToOwners[_parcelId];
    }

    function setBaseMetadataURI(string memory _newBaseMetadataURI)
        public
        onlyOwner
    {
        _setBaseMetadataURI(_newBaseMetadataURI);
    }

    function _incrementTokenId() private {
        _currentTokenId++;
    }

    function baseTokenURI() public pure virtual returns (string memory);

    function tokenURI(uint256 _tokenId)
        public
        pure
        override
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(baseTokenURI(), Strings.toString(_tokenId))
            );
    }

    function isApprovedForAll(address owner, address operator)
        public
        view
        override
        returns (bool)
    {
        // Whitelist OpenSea proxy contract for easy trading.
        ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
        if (address(proxyRegistry.proxies(owner)) == operator) {
            return true;
        }

        return super.isApprovedForAll(owner, operator);
    }

    /**
     * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
     */
    function _msgSender() internal view override returns (address sender) {
        return ContextMixin.msgSender();
    }
}
