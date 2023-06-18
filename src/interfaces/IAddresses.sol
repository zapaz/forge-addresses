// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// add comments
interface IAddresses {
    function setFilePath(string calldata filePath) external;
    function readAddress(string calldata name) external view returns (address);
    function writeAddress(string calldata name, address addr) external;
}
