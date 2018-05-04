pragma solidity ^0.4.23;

import "./IRegistry.sol";

contract Registry is IRegistry {
  mapping(bytes32 => address) registry;

  function _register(bytes32 _key, address _targetContract) internal {
    require(_targetContract != address(0));
    registry[_key] = _targetContract;
  }

  function lookup(bytes32 _key) external view returns (address) {
    return registry[_key];
  }
}
