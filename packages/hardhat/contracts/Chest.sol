//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import 'base64-sol/base64.sol';
import './HexStrings.sol';


contract Chest is ERC721Enumerable, Ownable {

  using Strings for uint256;
  using HexStrings for uint160;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() ERC721("Breast Plate", "BP") {}

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
      string memory name = string(abi.encodePacked('#', id.toString(), ' Brest Plate'));
      string memory description = string(abi.encodePacked('The shield from code heartbreaks.'));
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
      '<g id="_2-breast-plate" serif:id="2 breast plate">',
        '<rect x="885.159" y="550.614" width="320.246" height="344.169" style="fill:rgb(252,239,239);"/>',
        '<path d="M1211.29,550.614C1211.29,547.197 1208.65,544.428 1205.4,544.428C1205.4,544.428 885.159,542.777 885.159,542.777C880.831,542.777 877.323,546.286 877.323,550.614L876.105,894.782C876.105,899.783 880.159,903.837 885.159,903.837C885.159,903.837 965.221,903.991 1045.28,903.83C1125.35,903.668 1205.4,903.19 1205.4,903.19C1210.05,903.19 1213.81,899.426 1213.81,894.782L1211.29,550.614ZM1199.48,556.83C1199.48,556.83 1197.44,834.029 1197.06,886.327C1174.55,886.203 1109.92,885.866 1045.28,885.735C981.285,885.606 917.287,885.679 894.182,885.713C894.182,885.713 893.202,608.74 893.024,558.41C941.666,558.159 1199.48,556.83 1199.48,556.83L1199.48,556.83Z"/>',
    '</g>'
     
        ));

    return render;
  }

}