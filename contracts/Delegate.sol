pragma solidity ^0.4.23;

import "./IRegistry.sol";

contract Delegate {
  /**
   * This function should return something like keccak256("org.myorg.delegate.registry") in
   * order to provide a unique storage position for the data.
   */
  function registryPosition() internal view returns (bytes32);

  /**
   * This function should return something like keccak256("org.myorg.delegate.key") in
   * order to provide a unique storage position for the data.
   */
  function keyPosition() internal view returns (bytes32);

  function getRegistry() public view returns (address impl) {
    bytes32 position = registryPosition();
    assembly {
      impl := sload(position)
    }
  }

  function getKey() public view returns (bytes32 key) {
    bytes32 position = keyPosition();
    assembly {
      key := sload(position)
    }
  }

  function _setRegistry(address registry) internal {
    bytes32 position = registryPosition();
    assembly {
      sstore(position, registry)
    }
  }

  function _setKey(bytes32 key) internal {
    bytes32 position = keyPosition();
    assembly {
      sstore(position, key)
    }
  }

  /**
  * @dev Tells the address of the implementation where every call will be delegated.
  * @return address of the implementation to which it will be delegated
  */
  function implementation() public view returns (address) {
    IRegistry registry = IRegistry(getRegistry());
    return registry.lookup(getKey());
  }

  /**
  * @dev Fallback function allowing to perform a delegatecall to the given implementation.
  * This function will return whatever the implementation call returns
  */
  function () payable public {
    address _impl = implementation();
    require(_impl != address(0));

    assembly {
      let ptr := mload(0x40)
      calldatacopy(ptr, 0, calldatasize)
      let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
      let size := returndatasize
      returndatacopy(ptr, 0, size)

      switch result
      case 0 { revert(ptr, size) }
      default { return(ptr, size) }
    }
  }
}
