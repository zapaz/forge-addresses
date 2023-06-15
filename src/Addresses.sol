// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Script.sol";

contract Addresses is Script {
    string public filePath = "json/addresses.json";

    // add a non-existing field to a JSON file, where root object has chainIds as fields
    // requires `sed` avalaible and new field must not already exists (check to do by the caller)
    // replace
    // {
    //   "31337": {
    //     "Test": "My test string",
    //   }
    // }
    // with
    // {
    //   "31337": {
    //     "Test": "My test string",
    //     "Other": "Other test String"
    //   }
    // }
    function writeJsonWithSed(string memory key, string memory value) public {
        string memory stringFrom = string.concat("\"", vm.toString(block.chainid), "\": {");
        string memory stringTo = string.concat(stringFrom, "\\n    \"", key, "\": \"", value, "\",");
        string memory sed = string.concat("s/", stringFrom, "/", stringTo, "/");
        // console.log("sed:", sed);

        string[] memory inputs = new string[](6);
        inputs[0] = "/usr/bin/sed";
        inputs[1] = "-i";
        inputs[3] = "";
        inputs[3] = "-e";
        inputs[4] = sed;
        inputs[5] = filePath;
        vm.ffi(inputs);
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
            writeJsonWithSed(name, vm.toString(addr));
        }
    }

    function _stringEqual(string memory string1, string memory string2) internal pure returns (bool) {
        return keccak256(bytes(string1)) == keccak256(bytes(string2));
    }
}
