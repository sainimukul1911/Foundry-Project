// SPDX_License_Identifier: MIT

pragma solidity ^0.8.18;

import {Test , console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";


contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("User");

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER , 10e18);
    }

    function testDemo() view public {
        console.log(fundMe.MINIMUM_USD());
    }

    function testVersion() public {
        assertEq(fundMe.getVersion(),4);
    }

    function testMinvalrevert() public {
        vm.expectRevert();
        fundMe.fund{value:1e18}();
        
    }

    function testFundUpdateDS() public funded{
        uint amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(10e18, amountFunded);
    }

    function testIndexAddress() public funded{
        address fundersAddress = fundMe.getFunder(0);
        assertEq(USER,fundersAddress);
    }

    modifier funded(){
        vm.prank(USER);
        fundMe.fund{value:10e18}();
        _;
    }

    function testWithdraw() public funded{
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdrawSingleFunder() public funded{
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingContractBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingContractBalance = address(fundMe).balance;

        assertEq(endingContractBalance,0);
        assertEq(startingOwnerBalance + startingContractBalance , endingOwnerBalance);
    }

    function testWithdrawMultipleFunders() public{
        uint160 totalFunders = 11;
        uint160 startingIndex = 1;

        for(uint160 i=startingIndex; i<totalFunders ; i++){
            hoax(address(i), 10e18);
            fundMe.fund{value:10e18}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingContractBalance = address(fundMe).balance;
        
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingContractBalance = address(fundMe).balance;

        assertEq(endingContractBalance,0);
        assertEq(startingOwnerBalance + startingContractBalance , endingOwnerBalance);
    }
}