//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import 'base64-sol/base64.sol';
import './HexStrings.sol';


//learn more: https://docs.openzeppelin.com/contracts/3.x/erc721

// GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two

contract ETHLogo is ERC721Enumerable, Ownable {

  using Strings for uint256;
  using HexStrings for uint160;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() ERC721("ETHLogo", "ETH") {}

  uint256 constant public price = 1; // 0.005 eth
  uint256 mintDeadline = block.timestamp + 1 weeks;

  function mintItem()
      public
      payable
      returns (uint256)
  {
      require( block.timestamp < mintDeadline, "DONE MINTING");
      //require(msg.value >= price, "Not enough ETH");
      _tokenIds.increment();

      uint256 id = _tokenIds.current();
      _mint(msg.sender, id);

      return id;
  }

  function tokenURI(uint256 id) public view override returns (string memory) {
      require(_exists(id), "not exist");
      string memory name = string(abi.encodePacked('#', id.toString(), ' ETHLogo'));
      string memory description = string(abi.encodePacked('The symbol of greatness'));
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
                              '", "owner":"',
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
      '<svg width="100%" height="100%" viewBox="0 0 2048 1536" version="1.1" xmlns="http://www.w3.org/2000/svg'
      '" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve" xmlns:serif="http://www.serif.com/'
      '" style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;">',
        renderTokenById(id),
      '</svg>'
    ));

    return svg;
  }

  // Visibility is `public` to enable it being called by other contracts for composition.
  function renderTokenById(uint256 id) public view returns (string memory) {
    string memory render = string(abi.encodePacked(
      '<g id="_8-eth-logo" serif:id="8 eth logo" transform="matrix(1,0,0,1,5.79823,38.7241)">',
        '<g transform="matrix(1,0,0,1,5.76415,-0.867506)">',
            '<rect x="963.958" y="568.668" width="153.581" height="41.891" style="fill:rgb(195,34,34);"/>',
        '</g>'
        '<g transform="matrix(1,0,0,1,5.76415,81.8717)">',
            '<rect x="963.958" y="568.668" width="153.581" height="41.891" style="fill:rgb(195,34,34);"/>',
        '</g>',
        '<g transform="matrix(1,0,0,1,5.76415,160.468)">',
            '<rect x="963.958" y="568.668" width="153.581" height="41.891" style="fill:rgb(195,34,34);"/>',
        '</g>',
    '</g>'
     
        ));

    return render;
  }

}