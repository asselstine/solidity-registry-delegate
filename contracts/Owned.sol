pragma solidity ^0.4.23;

contract Owned {
  event TransferredOwnership(address previousOwner, address newOwner);

  modifier onlyOwner() {
    require(msg.sender == getOwner());
    _;
  }
  
  /**
   * This function should return something like keccak256("org.myorg.owned.owner") in
   * order to provide a unique storage position for the data.
   */
  function ownerPosition() internal returns (bytes32);

  function transferOwnership(address _newOwner) onlyOwner external {
    address owner = getOwner();
    require(_newOwner != address(0));
    require(_newOwner != owner);
    emit TransferredOwnership(owner, _newOwner);
    setOwner(_newOwner);
  }

  function getOwner() internal view returns (address owner) {
    bytes32 position = ownerPosition;
    assembly {
      owner := sload(position)
    }
  }

  function setOwner(address _owner) internal {
    bytes32 position = ownerPosition;
    assembly {
      sstore(position, _owner)
    }
  }
}
