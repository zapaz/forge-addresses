// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Addresses.sol";

contract AddressesTest is Test {
    Addresses addresses;
    address addr;

    function setUp() public {
        addresses = new Addresses();
        addr = address(this);

        vm.removeFile(addresses.filePath());
        vm.writeLine(addresses.filePath(), '{"31337":{"Test":""}}');
    }

    function testWrite() public {
        console.log("testWrite:", addr);
        addresses.writeAddress("Test", addr);
    }

    function testRead() public {
        addresses.writeAddress("Test", addr);

        address readAddr = addresses.readAddress("Test");
        console.log("testRead:", readAddr);

        assertEq(readAddr, addr);
    }
}
