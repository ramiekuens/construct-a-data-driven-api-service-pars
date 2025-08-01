pragma solidity ^0.8.0;

/**
 * @title DataDrivenAPIServiceParser
 * @author Duve
 * @notice A data-driven API service parser for constructing and parsing API requests
 */

contract DataDrivenAPIServiceParser {

    // Mapping of API endpoints to their corresponding parsers
    mapping (string => APIServiceParser) public parsers;

    // Event emitted when a new parser is added
    event ParserAdded(string endpoint, address parser);

    // Event emitted when a request is parsed
    event RequestParsed(string endpoint, string requestData);

    // Structure for API service parsers
    struct APIServiceParser {
        address parserAddress;
        string[] acceptableMethods;
        string[] acceptableRequestDataTypes;
    }

    // Function to add a new parser for an API endpoint
    function addParser(string memory _endpoint, address _parserAddress, string[] memory _acceptableMethods, string[] memory _acceptableRequestDataTypes) public {
        APIServiceParser storage parser = parsers[_endpoint];
        parser.parserAddress = _parserAddress;
        parser.acceptableMethods = _acceptableMethods;
        parser.acceptableRequestDataTypes = _acceptableRequestDataTypes;
        emit ParserAdded(_endpoint, _parser);
    }

    // Function to parse a request for an API endpoint
    function parseRequest(string memory _endpoint, string memory _requestData) public {
        APIServiceParser storage parser = parsers[_endpoint];
        require(parser.parserAddress != address(0), "Parser not found for endpoint");
        (bool success, bytes memory result) = parser.parserAddress.call(abi.encodeWithSignature("parseRequest(string)", _requestData));
        require(success, "Parser failed to parse request");
        emit RequestParsed(_endpoint, _requestData);
    }

    // Function to get an API endpoint's acceptable methods
    function getAcceptableMethods(string memory _endpoint) public view returns (string[] memory) {
        return parsers[_endpoint].acceptableMethods;
    }

    // Function to get an API endpoint's acceptable request data types
    function getAcceptableRequestDataTypes(string memory _endpoint) public view returns (string[] memory) {
        return parsers[_endpoint].acceptableRequestDataTypes;
    }
}