// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import { EtherWrapper } from "../src/EtherWrapper.sol";

contract EtherWrapperTest is Test {
    EtherWrapper  etherWrapperContract;
    address public user = vm.addr(0x01);

    ///@notice Event emitted when tokens are wrapped
    event Wrapped(address indexed from, uint256 amount);
    ///@notice Event emitted when tokens are unwrapped
    event Unwrapped(address indexed to, uint256 amount);

    function setUp() public {
        etherWrapperContract = new EtherWrapper("WrapCatella", "WCTH");
        vm.deal(user, 5 ether);
    }

    function testWrap() public {
        vm.expectEmit(true, true, true, true);
        // We emit the event we expect to see.
        emit Wrapped(user, 5e18);
        // sending ETH in the contract address
        vm.startPrank(user);
        // We perform the call.
        (bool success, ) = address(etherWrapperContract).call{value: 5 ether}("");
        require(success, "Failed to unwrap tokens!");
        vm.stopPrank();
    }

    function testUnwrap() public {
        testWrap();
        vm.expectEmit(true, true, false, true);
        // We emit the event we expect to see.
        emit Unwrapped(user, 5e18);
        vm.startPrank(user);
        etherWrapperContract.unwrap(5e18);
    }
}
