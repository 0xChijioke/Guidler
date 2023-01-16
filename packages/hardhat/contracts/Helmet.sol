//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import 'base64-sol/base64.sol';
import './HexStrings.sol';




contract Helmet is ERC721Enumerable, Ownable {

  using Strings for uint256;
  using HexStrings for uint160;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() ERC721("Helmet", "HELMET") {}


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
      string memory name = string(abi.encodePacked('#', id.toString(), ' Helmet'));
      string memory description = string(abi.encodePacked('The sheild from mental breakdowns.'));
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
      '<g id="_7-helmet-knight" serif:id="7 helmet knight">',
        '<path d="M1201.71,253.885L1048.7,221.65L899.052,259.335L893.456,561.503L1052.23,593.258L1208.13,562.946L1201.71,253.885ZM923.037,452.709L1052.06,442.239L1174.07,456.19L1052.16,398.808L923.037,452.709Z" style="fill:rgb(252,239,239);"/>',
        '<path d="M1206.41,253.77C1206.36,251.182 1204.82,248.972 1202.68,248.439C1202.86,248.439 1049.88,216.062 1049.88,216.062C1049.03,215.883 1048.15,215.9 1047.31,216.112L897.623,253.658C895.06,254.304 893.248,256.585 893.199,259.227L887.352,561.39C887.298,564.342 889.364,566.91 892.259,567.489L1051.01,599.343C1051.81,599.501 1052.62,599.504 1053.41,599.349L1209.32,569.048C1212.29,568.471 1214.41,565.841 1214.34,562.817L1206.41,253.788L1206.41,253.77ZM1197.09,258.603C1197.09,258.603 1201.19,517.565 1201.83,557.839C1201.83,557.839 1052.25,586.933 1052.25,586.933C1052.25,586.933 899.65,556.513 899.65,556.513C899.65,556.513 904.17,301.014 904.826,263.914C904.826,263.914 1048.83,227.511 1048.83,227.511L1197.09,258.603ZM921.227,447.572C919.094,448.626 917.926,451.362 918.471,454.022C919.016,456.683 921.114,458.478 923.417,458.257C923.488,458.257 1051.95,448.115 1051.95,448.115C1051.95,448.115 1173.38,462.244 1173.38,462.244C1176.35,462.583 1179.12,460.726 1179.93,457.856C1180.75,454.986 1179.37,451.948 1176.67,450.677L1054.81,393.184C1053.22,392.436 1051.39,392.395 1049.77,393.072C1049.77,393.072 1025.54,403.1 998.198,414.822C962.383,430.179 921.227,448.372 921.227,448.372L921.227,447.572ZM957.073,444.286C970.896,438.785 987.39,432.185 1002.83,425.915C1025.09,416.875 1045.13,408.497 1052.02,405.608C1052.02,405.608 1138.07,446.014 1138.07,446.014C1138.07,446.014 1052.72,436.428 1052.72,436.428C1052.34,436.385 1051.96,436.379 1051.58,436.409L957.071,444.286L957.073,444.286Z"/>',
        '<g transform="matrix(2.65881,0,0,7.80187,-1502.86,-6692.2)">',
            '<path d="M958.636,887.821L909.46,892.316L907.176,928.45L958.645,931.844L958.642,915.785L910.477,916.028L958.64,907.821L958.636,887.821Z" style="fill:rgb(128,128,128);fill-opacity:0.2;"/>',
        '</g>',
    '</g>'
     
        ));

    return render;
  }

}