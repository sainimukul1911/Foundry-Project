// SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";

contract HelperConfig is Script{
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor(){
        if(block.chainid == 11155111){
            activeNetworkConfig = getSepoliaEthConfig();
        }else if (block.chainid == 1){
            activeNetworkConfig = getMainnetEthConfig();
        }else{
            activeNetworkConfig = getAnvilEthConfig();
        }
    }
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory){
        NetworkConfig memory networkConfig = NetworkConfig({
            priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return networkConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory){
        NetworkConfig memory networkConfig = NetworkConfig({
            priceFeed:0x5C00128d4d1c2F4f652C267d7bcdD7aC99C16E16
        });
        return networkConfig;
    }

    function getAnvilEthConfig() public returns (NetworkConfig memory){

        if(activeNetworkConfig.priceFeed != address(0)){
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(8,2000e8);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed:address(mockV3Aggregator)
        });
        
        return anvilConfig;
    }
}