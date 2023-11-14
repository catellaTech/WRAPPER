// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import { ERC20Wrapper } from "../src/ERC20Wrapper.sol";
import { ERC20Mock } from "./ERC20Mock/ERC20Mock.sol";

contract ERC20WrapperTest is Test {
    ERC20Wrapper  ERC20WrapperContract;
    ERC20Mock token;
    address public user = vm.addr(0x01);

    ///@notice Event emitted when tokens are wrapped
    event Wrapped(address indexed from, uint256 amount);
    ///@notice Event emitted when tokens are unwrapped
    event Unwrapped(address indexed to, uint256 amount);

    function setUp() public {
        token = new ERC20Mock("WrapCatellaToken", "WCTHT");
        ERC20WrapperContract = new ERC20Wrapper(token, "WrapCatellaToken", "WCTHT");

        token.mint(user,100e18);
    }

    function testWrap() public {
        vm.expectEmit(true, true, true, true);
        // We emit the event we expect to see.
        emit Wrapped(user, 50e18);
        // sending the tokens into the contract address -> Remember approve the tokens first👾
        vm.startPrank(user);
        // We perform the call.
        token.approve(address(ERC20WrapperContract), 50e18);
        ERC20WrapperContract.wrap(50e18);
        vm.stopPrank();
    }

    function testUnwrap() public {
        testWrap();
        vm.expectEmit(true, true, false, true);
        // We emit the event we expect to see.
        emit Unwrapped(user, 50e18);
        vm.startPrank(user);
        ERC20WrapperContract.unwrap(50e18);
    }
}