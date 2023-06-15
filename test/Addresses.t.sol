// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Addresses.sol";

contract AddressesTest is Test {
    using stdJson for string;

    Addresses addresses;
    string testPath;

    function setUpJson(string memory name) public {
        testPath = string.concat("test/json/", name, ".json");
        addresses.setFilePath(testPath);

        try vm.removeFile(testPath) {} catch (bytes memory) {}
        vm.writeLine(testPath, string.concat('{\n  "', vm.toString(block.chainid), '": {\n    "Test": ""\n  }\n}'));
        vm.closeFile(testPath);
    }

    function setUp() public {
        addresses = new Addresses();
    }

    function test_setUpJson() public {
        setUpJson("test_setUpJson");

        assertEq(addresses.filePath(), testPath);
        assertEq(addresses.readAddress("Test"), address(0x20));
    }

    function test_SetFilePath() public {
        string memory otherPath = "../other/other.json";

        addresses.setFilePath(otherPath);
        assertEq(addresses.filePath(), otherPath);
    }

    function test_writeAddressExists() public {
        setUpJson("test_writeAddressExists");

        addresses.writeAddress("Test", address(this));
        assertEq(addresses.readAddress("Test"), address(this));
    }

    function test_writeAddressNotExists() public {
        setUpJson("test_writeAddressNotExists");

        addresses.writeAddress("NoTestHere", address(this));
        assertEq(addresses.readAddress("NoTestHere"), address(this));
    }

    function test_readAddressExists() public {
        setUpJson("test_readAddressExists");

        addresses.writeAddress("Test", address(this));
        assertEq(addresses.readAddress("Test"), address(this));
    }

    function test_readAddressNotExists() public {
        setUpJson("test_readAddressNotExists");

        assertEq(addresses.readAddress("NoTestHere"), address(0x20));
    }
}
