// SPDX_License_Identifier: MIT

pragma solidity ^0.8.18;

import {Test , console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {FundFundMe} from "../../script/Interactions.s.sol";


contract IntegrationTest is Test {

    FundMe fundMe;
    address USER = makeAddr("User");

    function setUp() external {
        DeplyFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER , 10e18);
    }

    function testUserCanFund() public {
        FundFundMe fundFundMe = new FundFundMe();
        vm.prank(USER);
        fundFundMe.fundFundMe(address(fundMe));

        address fundersAddress = fundMe.getFunder(0);
        assertEq(USER,fundersAddress);
    }
}  