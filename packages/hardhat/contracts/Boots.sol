//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import 'base64-sol/base64.sol';
import './HexStrings.sol';


contract Boots is ERC721Enumerable, Ownable {

  using Strings for uint256;
  using HexStrings for uint160;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() ERC721("Boots", "BOOTS") {}

  function mintItem() public payable returns (uint256) {
    require(balanceOf(msg.sender) == 0, "User has already minted an NFT");

    _tokenIds.increment();
    uint256 id = _tokenIds.current();
    _mint(msg.sender, id);
    return id;
  }

  function tokenURI(uint256 id) public view override returns (string memory) {
      require(_exists(id), "not exist");
      string memory name = string(abi.encodePacked('#', id.toString(), ' Boots'));
      string memory description = string(abi.encodePacked('The Guidler boots to conquer ecosystems.'));
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
      '<g id="_3-boots" serif:id="3 boots">',
        '<g>',
            '<rect x="892.778" y="1105.89" width="132.572" height="346.447" style="fill:rgb(252,239,239);"/>',
            '<path d="M1031.23,1105.89C1031.23,1102.47 1028.6,1099.7 1025.35,1099.7C1025.35,1099.7 892.778,1098.72 892.778,1098.72C888.816,1098.72 885.604,1101.93 885.604,1105.89L883.724,1452.34C883.724,1457.34 887.777,1461.39 892.778,1461.39L1025.35,1461.34C1030.32,1461.34 1034.36,1457.31 1034.36,1452.34C1034.36,1452.34 1034.08,1387.4 1033.45,1313.76C1032.62,1217.29 1031.23,1105.89 1031.23,1105.89ZM1019.39,1112.12C1019.09,1136.86 1017.97,1230.82 1017.25,1313.76C1016.76,1371.03 1016.48,1423.04 1016.39,1443.33C1016.39,1443.33 901.783,1443.29 901.783,1443.29C901.783,1443.29 900.254,1161.67 899.99,1113.01L1019.39,1112.12Z"/>',
            '<g transform="matrix(1,0,0,1,184.308,0)">',
                '<rect x="892.778" y="1105.89" width="132.572" height="346.447" style="fill:rgb(252,239,239);"/>',
                '<path d="M1031.23,1105.89C1031.23,1102.47 1028.6,1099.7 1025.35,1099.7C1025.35,1099.7 892.778,1098.72 892.778,1098.72C888.816,1098.72 885.604,1101.93 885.604,1105.89L883.724,1452.34C883.724,1457.34 887.777,1461.39 892.778,1461.39L1025.35,1461.34C1030.32,1461.34 1034.36,1457.31 1034.36,1452.34C1034.36,1452.34 1034.08,1387.4 1033.45,1313.76C1032.62,1217.29 1031.23,1105.89 1031.23,1105.89ZM1019.39,1112.12C1019.09,1136.86 1017.97,1230.82 1017.25,1313.76C1016.76,1371.03 1016.48,1423.04 1016.39,1443.33C1016.39,1443.33 901.783,1443.29 901.783,1443.29C901.783,1443.29 899.99,1113.01 899.99,1113.01L1019.39,1112.12Z"/>',
            '</g>',
        '</g>',
        '<g id="Layer6">',
            '<g transform="matrix(0.66154,-0.74991,0.74991,0.66154,-416.681,1033.67)">',
                '<rect x="759.236" y="1052.53" width="118.195" height="118.057" style="fill:rgb(252,239,239);"/>',
                '<path d="M883.484,1052.38C883.567,1049.06 880.924,1046.43 877.58,1046.51C877.431,1046.34 759.236,1044.63 759.236,1044.63C754.875,1044.63 751.34,1048.17 751.34,1052.53L750.181,1170.59C750.181,1175.59 754.235,1179.64 759.236,1179.64C759.236,1179.64 788.785,1179.8 818.333,1179.62C847.886,1179.44 877.431,1178.93 877.431,1178.93C882.037,1178.93 885.77,1175.19 885.77,1170.59L883.315,1052.53L883.484,1052.38ZM871.416,1058.8L869.267,1162.11C858.453,1161.95 838.395,1161.67 818.333,1161.55C798.76,1161.43 779.186,1161.46 768.201,1161.5C768.201,1161.5 767.208,1060.31 767.208,1060.31L871.416,1058.8Z"/>',
            '</g>',
            '<g transform="matrix(0.66154,-0.74991,0.74991,0.66154,-232.373,1033.67)">',
                '<rect x="759.236" y="1052.53" width="118.195" height="118.057" style="fill:rgb(252,239,239);"/>',
                '<path d="M883.484,1052.38C883.567,1049.06 880.924,1046.43 877.58,1046.51C877.431,1046.34 759.236,1044.63 759.236,1044.63C754.875,1044.63 751.34,1048.17 751.34,1052.53L750.181,1170.59C750.181,1175.59 754.235,1179.64 759.236,1179.64C759.236,1179.64 788.785,1179.8 818.333,1179.62C847.886,1179.44 877.431,1178.93 877.431,1178.93C882.037,1178.93 885.77,1175.19 885.77,1170.59L883.315,1052.53L883.484,1052.38ZM871.416,1058.8L869.267,1162.11C858.453,1161.95 838.395,1161.67 818.333,1161.55C798.76,1161.43 779.186,1161.46 768.201,1161.5C768.201,1161.5 767.208,1060.31 767.208,1060.31L871.416,1058.8Z"/>',
            '</g>',
        '</g>',
    '</g>'
     
        ));

    return render;
  }

}