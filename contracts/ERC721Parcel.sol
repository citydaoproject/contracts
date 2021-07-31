// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/// @author CityDao team: @odyslam

contract cityDaoParcel is ERC721Full, Ownable{
  using SafeMath for uint256;
  
  address proxyRegistryAddress; 
  uint256 private _currentTokenId = 0;

  uint256 private _currentTokenId = 0;
  int  parcelId = 0;
  mapping(uint256 => uint256) public tokenSupply;
  mapping(uint256 => address) public parcelIdToOwners;
  mapping(uint256 => Parcel) public parcelIdToParcels;
  constructor(
    string memory _name, 
    string memory _symnbol, 
    address _proxyRegistryAddress
  ) ERC721(_name, _symbol){
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
  
  function transferParcel (
    address _toAddress, 
    address _fromAddress, 
    uint256 _parcelId
  ){
    _safeTransferFrom(_toAddress, _fromAddress, _parcelId, 1);
    // Assume that the above will revert if _fromAddress does not own the parcel
    parcelIdToOwners[_parcelId] = _toAddress
  }



  function mintParcelToAddress (
    address _toAddress,
  	uint256 _quantity,
    bytes32 _lat, 
    bytes32 _long, 
    uint16 _leaseLength,
    string metadataLocationHash;
   ) external onlyOwner returns(uint256) { 
    uint256 newTokenId = _getNextTokenId();
    Parcel parcel = Parcel( _lat, _long, _leaseLength, _metadataLocationHash);
    parcelIdToOwners[parcelId] = _toAddress;
  	parcelIdToParcels[parcelId] = parcel;
    _mint( _toAddress, parcelId);
    parcelOwners[_toAddress] = parcel;
    _incrementTokenId();
    return parcelId;
   }

   function getParcelOwner(
     uint256 _parcelId
   ) external view returns(address) {
     return parcelIdtoOwners[_parcelId];
   }


 	function setBaseMetadataURI(
    string memory _newBaseMetadataURI
  ) public onlyOwner {
    _setBaseMetadataURI(_newBaseMetadataURI);
  }

	function _incrementTokenId() private {
        _currentTokenId++;
  }
  function baseTokenURI() virtual public pure returns (string memory);

  function tokenURI(uint256 _tokenId) override public pure returns (string memory) {
        return string(abi.encodePacked(baseTokenURI(), Strings.toString(_tokenId)));
   }
  function isApprovedForAll(address owner, address operator)
		override
			public
			view
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
	function _msgSender()
			internal
			override
			view
			returns (address sender)
	{
			return ContextMixin.msgSender();
	}
}

