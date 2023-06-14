// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Script.sol";

contract Addresses is Script {
    string public filePath  = "addresses.json";

    function setFilePath(string memory name) public {
        filePath = name;
    }

    function writeAddress(string memory name, address addr) public {
        string memory path = string.concat(".", vm.toString(block.chainid), ".", name);
        vm.writeJson(vm.toString(addr), filePath, path);
    }

    function readAddress(string memory name) public view returns (address) {
        string memory jsonFile = vm.readFile(filePath);
        string memory path = string.concat(".", vm.toString(block.chainid), ".", name);

        return abi.decode(vm.parseJson(jsonFile, path), (address));
    }
}
