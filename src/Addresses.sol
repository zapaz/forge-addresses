// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Script.sol";
import {LibString} from "src/LibString.sol";

contract Addresses is Script {
    using LibString for string;

    string public filePath = "json/addresses.json";

    function writeJsonWithReplace(string memory key, string memory value) public {
        string memory search = string.concat("\"", vm.toString(block.chainid), "\": {");
        string memory replacement = string.concat(search, "\n    \"", key, "\": \"", value, "\",");

        string memory json = vm.readFile(filePath);
        vm.writeFile(filePath, json.replace(search, replacement));
    }

    function setFilePath(string calldata filePath_) public {
        filePath = filePath_;
    }

    function readAddress(string calldata name) public view returns (address) {
        string memory json = vm.readFile(filePath);
        string memory jsonKey = string.concat(".", vm.toString(block.chainid), ".", name);

        return abi.decode(vm.parseJson(json, jsonKey), (address));
    }

    function writeAddress(string calldata name, address addr) public {
        string memory jsonKey = string.concat(".", vm.toString(block.chainid), ".", name);

        vm.writeJson(vm.toString(addr), filePath, jsonKey);
        if (addr != readAddress(name)) {
            writeJsonWithReplace(name, vm.toString(addr));
        }
    }

    function _stringEqual(string memory string1, string memory string2) internal pure returns (bool) {
        return keccak256(bytes(string1)) == keccak256(bytes(string2));
    }
}
