pragma solidity >=0.8.0 <0.9.0

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract cityDaoParcel is ERC1155, Ownable {
  uint256 private _currentTokenId = 0;
  storage int parcelId = 0;
  mapping(uint256 => uint256) public tokenSupply;
  constructor(string memory _uri, string memory _name, string memory _symbol) ERC1155(https://parcels.citydao/api/parcels/{id}.json) 
  {
    name = _name;
    symbol = _symbol;
    Ownable.initialize(msg.sender);
  }
  struct Parcel {
  uint256 id;
  bytes32 lat;
  bytes32 long;
  uint16 leaseLength;
  string metadataLocationHash;
  // locationHash = IPFS://<hash> or AR://<hash>
  }
  mapping(uint256 => Parcel) public parcelOwners;
  function mintParcel (
    address _toAddress,
    uint256 _quantity
    ) external onlyOwner returns(uint256) { 
    parcelId = parcelId + 1;
    Parcel parcel = Parcel(parcelId, _lat, _long, _leaseLength, _metadataLocationHash)
    _mint( _toAddress, parcelId);
    parcelOwners[_toAddress] = parcelId;
    parcels
    return parcelId;
   }

   function getParcelOwner (address parcelOwner) returns(

