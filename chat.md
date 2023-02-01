I apologize for the confusion, you are correct that you cannot convert a uint256 value to an address directly, as the two types have different sizes and formats.

In the example I provided, I suggested using the address() function to convert the bytes32 value stored in _data to an address value. However, this will not work as it's trying to convert a uint256 to address which is not possible.

A more suitable approach would be to use a struct to store the contract address and tokenId together and then use ABI encoding to convert the struct to bytes and pass it to _data.

Here is an example of how you might pass the contract address and tokenId in the _data parameter using struct and ABI encoding:

struct TokenData {
    address contractAddress;
    uint256 tokenId;
}

function transfer(address _to,uint256 _tokenId) public {
    TokenData memory data = TokenData(address(this), _tokenId);
    bytes memory encodedData = abi.encode(data);
    erc721.transferFrom(msg.sender, _to, _tokenId, encodedData);
}

In the Noob contract, you can then use ABI decoding to extract the contract address and tokenId in the onERC721Received() function:

function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes memory _data) public {
    TokenData memory tokenData = abi.decode(_data, (address, uint256));
    address contractAddress = tokenData.contractAddress;
    uint256 tokenId = tokenData.tokenId;
    // Perform any other necessary logic here, such as storing the contract address and tokenId in a mapping or array
}

Please note that this is just an example and you may need to adapt it to suit your specific use case. Additionally, you should add proper error handling and validation to make sure that the data passed is the expected data and the contract address and tokenId are valid.
