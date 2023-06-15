// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Script.sol";

contract Addresses is Script {
    string public filePath = "json/addresses.json";

    function writeJsonWithSed(string memory key, string memory value) internal {
        string[] memory inputs = new string[](7);
        inputs[0] = "/bin/sh";
        inputs[1] = "src/writeJson.sh";
        inputs[2] = filePath;
        inputs[3] = vm.toString(block.chainid);
        inputs[4] = key;
        inputs[5] = value;

        bytes memory res = vm.ffi(inputs);
        console.logBytes(res);
    }

    function stringEqual(string memory string1, string memory string2) public pure returns (bool) {
        return keccak256(bytes(string1)) == keccak256(bytes(string2));
    }

    function setFilePath(string calldata filePath_) public {
        filePath = filePath_;
    }

    function writeString(string calldata jsonKey, string memory value) public {
        string memory jsonPath = string.concat(".", vm.toString(block.chainid), ".", jsonKey);

        // writeJsonWithSed(jsonKey, value);
        vm.writeJson(value, filePath, jsonPath);
    }

    function writeAddress(string calldata jsonKey, address addr) public {
        writeString(jsonKey, vm.toString(addr));
    }

    function readBytes(string calldata jsonKey) public view returns (bytes memory) {
        string memory jsonFile = vm.readFile(filePath);
        string memory jsonPath = string.concat(".", vm.toString(block.chainid));
        if (bytes(jsonKey).length > 0) jsonPath = string.concat(jsonPath, ".", jsonKey);

        return vm.parseJson(jsonFile, jsonPath);
    }

    function readString(string calldata jsonKey) public view returns (string memory) {
        return abi.decode(readBytes(jsonKey), (string));
    }

    function readAddress(string calldata jsonKey) public view returns (address) {
        return abi.decode(readBytes(jsonKey), (address));
    }
}
