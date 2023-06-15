// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Addresses.sol";

contract AddressesTest is Test {
    using stdJson for string;

    Addresses addresses;
    address addr;
    string testPath;

    function setUpJson(string memory name) public {
        testPath = string.concat("test/json/", name, ".json");
        addresses.setFilePath(testPath);

        try vm.removeFile(testPath) {} catch (bytes memory) {}
        vm.writeLine(testPath, string.concat('{\n  "', vm.toString(block.chainid), '": {\n    "Test": ""\n  }\n}'));
    }

    function setUp() public {
        addr = address(this);
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

        addresses.writeAddress("Test", addr);
        assertEq(addresses.readAddress("Test"), addr);
    }

    function test_writeAddressNotExists() public {
        setUpJson("test_writeAddressNotExists");

        addresses.writeAddress("NoTestHere", addr);
        assertEq(addresses.readAddress("NoTestHere"), addr);
    }

    function test_writeString() public {
        setUpJson("test_writeString");

        addresses.writeString("Test", "String");
        assertEq(addresses.readString("Test"), "String");
    }

    function test_readAddressExists() public {
        setUpJson("test_readAddressExists");

        addresses.writeAddress("Test", addr);
        assertEq(addresses.readAddress("Test"), addr);
    }

    function test_readAddressNotExists() public {
        setUpJson("test_readAddressNotExists");

        assertEq(addresses.readAddress("NoTestHere"), address(0x20));
    }

    function test_readString() public {
        setUpJson("test_readString");

        string memory string42 = "String 42";
        addresses.writeString("Test", string42);

        string memory readString = addresses.readString("Test");
        assertEq(readString, string42);
    }
}
