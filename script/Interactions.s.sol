//SPDX_License_Identifier:MIT

pragma solidity ^0.8.18;

import {Script , console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecentlyDeployed){       
        FundMe(payable(mostRecentlyDeployed)).fund{value:SEND_VALUE }();
        console.log("Funded contract with %s", SEND_VALUE);
    }
    
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe", block.chainid
        );
        vm.startBroadcast();
        fundFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}