//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import 'base64-sol/base64.sol';
import './HexStrings.sol';


contract Cape is ERC721Enumerable, Ownable {

  using Strings for uint256;
  using HexStrings for uint160;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() ERC721("Cape", "CAPE") {}


  function mintItem()
      public
      payable
      returns (uint256)
  {
      
      _tokenIds.increment();

      uint256 id = _tokenIds.current();
      _mint(msg.sender, id);

      return id;
  }

  function tokenURI(uint256 id) public view override returns (string memory) {
      require(_exists(id), "not exist");
      string memory name = string(abi.encodePacked('#', id.toString(), ' Cape'));
      string memory description = string(abi.encodePacked('The cape for a guidler conquering Speedrunethereum challenges.'));
      string memory image = Base64.encode(bytes(generateSVGofTokenById(id)));

      return
          string(
              abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                          abi.encodePacked(
                              '{"name":"',
                              name,
                              '", "description":"',
                              description,
                              '", "external_url":"https://burnyboys.com/token/',
                              id.toString(),
                              '", "attributes": [{"trait_type": "color", "value": "#',
                              '"}], "owner":"',
                              (uint160(ownerOf(id))).toHexString(20),
                              '", "image": "',
                              'data:image/svg+xml;base64,',
                              image,
                              '"}'
                          )
                        )
                    )
              )
          );
  }

  function generateSVGofTokenById(uint256 id) internal view returns (string memory) {

    string memory svg = string(abi.encodePacked(
      '<svg width="100%" height="100%" viewBox="0 0 2048 1536" version="1.1" xmlns="http://www.w3.org/2000/svg',
      '" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve" xmlns:serif="http://www.serif.com/',
      '" style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;">',
        renderTokenById(id),
      '</svg>'
    ));

    return svg;
  }

  // Visibility is `public` to enable it being called by other contracts for composition.
  function renderTokenById(uint256 id) public view returns (string memory) {
    string memory render = string(abi.encodePacked(
      '<g id="_1-Layer4" serif:id="1 Layer4">',
        '<g id="cape-back" serif:id="cape back">',
            '<rect x="839.908" y="533.945" width="405.002" height="814.834" style="fill:rgb(195,34,34);"/>',
            '<path d="M1250.79,533.945C1250.79,530.528 1248.16,527.759 1244.91,527.759C1244.91,527.759 839.908,526.593 839.908,526.593C835.847,526.593 832.555,529.884 832.555,533.945L830.853,1348.78C830.853,1353.78 834.907,1357.83 839.908,1357.83L1244.91,1357.65C1249.81,1357.65 1253.78,1353.68 1253.78,1348.78C1253.78,1348.78 1253.31,1145.07 1252.56,941.362C1251.82,737.651 1250.79,533.945 1250.79,533.945ZM1239,540.147C1238.82,575.709 1237.93,758.533 1237.26,941.362C1236.6,1120.01 1236.16,1298.65 1236.06,1339.91C1236.06,1339.91 848.943,1339.73 848.943,1339.73C848.768,1255.95 847.433,617.022 847.275,541.276L1239,540.147Z"/>',
        '</g>',
    '</g>'
     
        ));

    return render;
  }

}