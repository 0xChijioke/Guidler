//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import 'base64-sol/base64.sol';
import './HexStrings.sol';


contract Arms is ERC721Enumerable, Ownable {

  using Strings for uint256;
  using HexStrings for uint160;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() ERC721("Arms", "ARMS") {}


  function mintItem()
      public
      payable
      returns (uint256)
  {
      //require(msg.value >= price, "Not enough ETH");
      _tokenIds.increment();

      uint256 id = _tokenIds.current();
      _mint(msg.sender, id);

      return id;
  }

  function tokenURI(uint256 id) public view override returns (string memory) {
      require(_exists(id), "not exist");
      string memory name = string(abi.encodePacked('#', id.toString(), ' Arms'));
      string memory description = string(abi.encodePacked('The god mode arms for writing dangerous software'));
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
      '<g id="_4-greaves" serif:id="4 greaves">',
        '<g>',
            '<g transform="matrix(0.617242,0.628054,-2.82135,2.77278,2413.33,-1758.41)">',
                '<rect x="642.534" y="698.533" width="116.141" height="94.36" style="fill:rgb(252,239,239);"/>',
                '<path d="M765.53,698.571C765.436,697.729 762.29,697.029 758.503,697.008C758.674,696.969 642.534,696.773 642.534,696.773C638.167,696.773 634.628,697.561 634.628,698.533L632.252,792.893C632.252,794.157 636.855,795.182 642.534,795.182L758.674,795.188C764.368,795.188 768.983,794.161 768.983,792.893C768.983,792.893 768.752,775.207 768.024,755.149C767.072,728.874 765.356,698.533 765.356,698.533L765.53,698.571ZM751.905,700.108C751.543,706.653 750.149,732.422 749.325,755.149C748.753,770.901 748.488,785.19 748.401,790.599C748.401,790.599 652.758,790.604 652.758,790.604C652.758,790.604 650.803,712.976 650.484,700.279L751.905,700.108Z"/>',
            '</g>',
            '<g transform="matrix(0.956374,0.292146,-0.292146,0.956374,272.011,-89.2306)">',
                '<rect x="641.995" y="592.673" width="108.365" height="105.18" style="fill:rgb(252,239,239);"/>',
                '<path d="M756.27,592.758C756.223,589.356 753.54,586.56 750.276,586.514C750.36,586.488 641.995,584.755 641.995,584.755C637.622,584.755 634.076,588.3 634.076,592.673L632.941,697.853C632.941,702.854 636.994,706.908 641.995,706.908C641.995,706.908 669.087,707.071 696.178,706.886C723.273,706.7 750.36,706.166 750.36,706.166C754.951,706.166 758.673,702.444 758.673,697.853L756.244,592.673L756.27,592.758ZM744.331,598.955L742.242,689.393C732.191,689.221 714.186,688.944 696.178,688.821C678.662,688.701 661.145,688.727 650.951,688.76C650.951,688.76 649.998,600.464 649.998,600.464L744.331,598.955Z"/>',
            '</g>',
        '</g>',
        '<g transform="matrix(-0.995132,0.0985482,0.0985482,0.995132,2020.31,-82.9179)">',
            '<g transform="matrix(0.617242,0.628054,-2.82135,2.77278,2413.33,-1758.41)">',
                '<rect x="642.534" y="698.533" width="116.141" height="94.36" style="fill:rgb(252,239,239);"/>',
                '<path d="M758.842,696.999C762.607,696.979 765.583,697.649 765.491,698.496C765.356,698.533 767.072,728.874 768.024,755.149C768.752,775.207 768.983,792.893 768.983,792.893C768.983,794.161 764.368,795.188 758.674,795.188L642.534,795.182C636.855,795.182 632.252,794.157 632.252,792.893L634.628,698.533C634.628,697.561 638.167,696.773 642.534,696.773L758.674,696.969L758.842,696.999ZM751.905,700.108L650.484,700.279C650.484,700.279 652.758,790.604 652.758,790.604C652.758,790.604 748.401,790.599 748.401,790.599C748.488,785.19 748.753,770.901 749.325,755.149C750.149,732.422 751.543,706.653 751.905,700.108L751.905,700.108Z"/>'
            '</g>'
            '<g transform="matrix(0.956374,0.292146,-0.292146,0.956374,272.011,-89.2306)">',
                '<rect x="641.995" y="592.673" width="108.365" height="105.18" style="fill:rgb(252,239,239);"/>',
                '<path d="M750.467,586.745C753.859,586.686 756.56,589.292 756.501,592.566L756.244,592.673L758.673,697.853C758.673,702.444 754.951,706.166 750.36,706.166C750.36,706.166 723.273,706.7 696.178,706.886C669.087,707.071 641.995,706.908 641.995,706.908C636.994,706.908 632.941,702.854 632.941,697.853L634.076,592.673C634.076,588.3 637.622,584.755 641.995,584.755L750.36,586.488L750.467,586.745ZM744.331,598.955L649.998,600.464C649.998,600.464 650.951,688.76 650.951,688.76C661.145,688.727 678.662,688.701 696.178,688.821C714.186,688.944 732.191,689.221 742.242,689.393L744.331,598.955Z"/>',
            '</g>',
        '</g>',
    '</g>'
     
        ));

    return render;
  }

}