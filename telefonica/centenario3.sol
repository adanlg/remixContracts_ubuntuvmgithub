// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StringStorage {
    // Struct to hold the string and its uploader identifier
    struct StringData {
        string content;
        string uploader;
    }

    // Mapping from an ID to the StringData
    mapping(uint256 => StringData) public strings;

    // Counter for the number of strings stored
    uint256 public stringCount;

    // Event that is emitted when a new string is uploaded
    event StringUploaded(uint256 indexed id, string content, string uploader);

    // Function to upload a string and its uploader identifier
    function uploadString(string memory _content, string memory _uploader) public {
        strings[stringCount] = StringData(_content, _uploader);
        emit StringUploaded(stringCount, _content, _uploader);
        stringCount++;
    }

    // Function to retrieve a string and its uploader identifier
    function getString(uint256 _id) public view returns (string memory, string memory) {
        StringData memory stringData = strings[_id];
        return (stringData.content, stringData.uploader);
    }

    // Function to return all uploaded strings and their uploaders
    function getAllStrings() public view returns (string[] memory, string[] memory) {
        string[] memory contents = new string[](stringCount);
        string[] memory uploaders = new string[](stringCount);

        for (uint256 i = 0; i < stringCount; i++) {
            StringData storage stringData = strings[i];
            contents[i] = stringData.content;
            uploaders[i] = stringData.uploader;
        }

        return (contents, uploaders);
    }
}
