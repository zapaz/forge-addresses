// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Script.sol";
import {LibString} from "src/LibString.sol";
import {IAddresses} from "src/interfaces/IAddresses.sol";

contract Addresses is Script, IAddresses {
    using LibString for string;

    string public filePath = "json/addresses.json";

    function setFilePath(string calldata filePath_) public override(IAddresses) {
        filePath = filePath_;
    }

    function readAddress(string calldata name) public view override(IAddresses) returns (address) {
        string memory json = vm.readFile(filePath);
        string memory jsonKey = string.concat(".", vm.toString(block.chainid), ".", name);

        return abi.decode(vm.parseJson(json, jsonKey), (address));
    }

    function writeAddress(string calldata name, address addr) public override(IAddresses) {
        string memory jsonKey = string.concat(".", vm.toString(block.chainid), ".", name);

        vm.writeJson(vm.toString(addr), filePath, jsonKey);
        if (addr != readAddress(name)) {
            writeJsonWithReplace(name, vm.toString(addr));
        }
    }

    function writeJsonWithReplace(string memory key, string memory value) internal {
        string memory search = string.concat("\"", vm.toString(block.chainid), "\": {");
        string memory replacement = string.concat(search, "\n    \"", key, "\": \"", value, "\",");

        string memory json = vm.readFile(filePath);
        vm.writeFile(filePath, json.replace(search, replacement));
    }

    function _stringEqual(string memory string1, string memory string2) internal pure returns (bool) {
        return keccak256(bytes(string1)) == keccak256(bytes(string2));
    }
}
