pragma solidity >=0.4.21 <0.6.0;
pragma experimental ABIEncoderV2;

import "./AssetsRegistry.sol";

contract AssetsRegistryFactory {
    event NewRegistry(address creator, AssetsRegistry registry);

    mapping(address => AssetsRegistry) public registries;

    function newRegistry(
        bytes32[] memory tickers,
        string[] memory reserveAddresses
    ) public returns (AssetsRegistry) {
        AssetsRegistry registry = new AssetsRegistry(tickers, reserveAddresses);

        registry.transferOwnership(msg.sender);
        registries[msg.sender] = registry;
        emit NewRegistry(msg.sender, registry);

        return registry;
    }
}
