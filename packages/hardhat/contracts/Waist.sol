pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import 'base64-sol/base64.sol';


import './HexStrings.sol';
import './ToColor.sol';
//learn more: https://docs.openzeppelin.com/contracts/3.x/erc721

// GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two

contract Waist is ERC721Enumerable, Ownable {

  using Strings for uint256;
  using HexStrings for uint160;
  using ToColor for bytes3;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() ERC721("Arms", "ARMS") {
    // BE HAPPY!
  }

  mapping (uint256 => bytes3) public color;
  mapping(uint256 => bytes32) public genes;
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

      bytes32 predictableRandom = keccak256(abi.encodePacked( blockhash(block.number-1), msg.sender, address(this), id ));
      color[id] = bytes2(predictableRandom[0]) | ( bytes2(predictableRandom[1]) >> 8 ) | ( bytes3(predictableRandom[2]) >> 16 );
      genes[id] = keccak256(abi.encodePacked( blockhash(block.number-1), msg.sender, address(this) ));

      return id;
  }

  function tokenURI(uint256 id) public view override returns (string memory) {
      require(_exists(id), "not exist");
      string memory name = string(abi.encodePacked('#', id.toString(), ' Smile'));
      string memory description = string(abi.encodePacked('The color of your Smile is #',color[id].toColor()));
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
                              color[id].toColor(),
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
      '<g id="_5-waist-armour" serif:id="5 waist armour">',
        '<g transform="matrix(1,0,0,1,226.086,-160.944)">',
            '<path d="M981.53,1018.25L660.985,1024.17L646.564,1203.68L828.552,1337.63L990.255,1201.94L981.53,1018.25Z" style="fill:rgb(252,239,239);"/>',
            '<path d="M987.407,1017.95C987.256,1014.61 984.604,1012 981.421,1012.06C981.416,1012.06 660.835,1016.05 660.835,1016.05C656.663,1016.13 653.228,1019.36 652.894,1023.52L637.704,1202.97C637.457,1206.04 638.816,1209.02 641.295,1210.84L823.238,1344.85C826.569,1347.3 831.146,1347.15 834.314,1344.49L995.157,1207.79C996.981,1206.26 997.985,1203.96 997.872,1201.58L987.407,1017.97L987.407,1017.95ZM975.882,1024.57L982.493,1198.47C963.361,1214.32 853.987,1304.92 828.224,1326.26C828.224,1326.26 681.926,1218.66 655.8,1199.44C655.8,1199.44 666.009,1065.16 668.522,1032.1L975.882,1024.57Z"/>',
        '</g>',
        '<g id="Layer5" transform="matrix(1,0,0,1,-17.6998,-8.02073)">',
            '<g transform="matrix(1,0,0,1,1.80624,-15.1672)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,22.616,9.88399)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,47.7369,-14.7348)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,70.4511,10.77)">'
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,94.3781,33.657)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,119.153,8.16943)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,95.185,-14.105)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,2.82966,33.1565)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,23.6395,58.2076)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,48.7603,33.5888)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,71.4745,59.0936)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,95.4016,81.9806)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,120.177,56.493)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,3.42222,83.9478)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,24.232,108.999)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,49.3528,84.3802)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,72.0671,109.885)">'
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,95.9941,132.772)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,120.769,107.284)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.23;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,4.01478,134.739)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.2;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,24.8246,159.79)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.2;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,49.9454,135.172)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.2;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,72.6596,160.676)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.2;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,96.5867,183.563)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.2;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,121.362,158.076)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.2;"/>',
            '</g>',
        '</g>',
    '</g>'
     
        ));

    return render;
  }

  function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
      if (_i == 0) {
          return "0";
      }
      uint j = _i;
      uint len;
      while (j != 0) {
          len++;
          j /= 10;
      }
      bytes memory bstr = new bytes(len);
      uint k = len;
      while (_i != 0) {
          k = k-1;
          uint8 temp = (48 + uint8(_i - _i / 10 * 10));
          bytes1 b1 = bytes1(temp);
          bstr[k] = b1;
          _i /= 10;
      }
      return string(bstr);
  }
}