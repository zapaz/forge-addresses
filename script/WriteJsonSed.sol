// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Script.sol";

contract WriteJsonSed is Script {
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
    function writeJsonSed(string memory filePath, string memory key, string memory value) public {
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

    function writeJsonSedWithShell(string memory filePath, string memory key, string memory value) internal {
        string[] memory inputs = new string[](7);
        inputs[0] = "/bin/sh";
        inputs[1] = "script/writeJsonSed.sh";
        inputs[2] = filePath;
        inputs[3] = vm.toString(block.chainid);
        inputs[4] = key;
        inputs[5] = value;

        bytes memory res = vm.ffi(inputs);
        console.logBytes(res);
    }
}
