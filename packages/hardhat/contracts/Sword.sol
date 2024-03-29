//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import 'base64-sol/base64.sol';
import './HexStrings.sol';


contract Sword is ERC721Enumerable, Ownable {

  using Strings for uint256;
  using HexStrings for uint160;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() ERC721("Sword", "SWORD") {}


  function mintItem() public payable returns (uint256) {
    require(balanceOf(msg.sender) == 0, "User has already minted an NFT");

    _tokenIds.increment();
    uint256 id = _tokenIds.current();
    _mint(msg.sender, id);
    return id;
  }

  function tokenURI(uint256 id) public view override returns (string memory) {
      require(_exists(id), "not exist");
      string memory name = string(abi.encodePacked('#', id.toString(), ' Sword'));
      string memory description = string(abi.encodePacked('The weapon for rapid prototyping.'));
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
      '<g transform="matrix(1,0,0,1,-15.4543,-211.53)">',
        '<g id="_9-sword" serif:id="9 sword">',
            '<g>',
                '<path d="M1107.58,572.995L1039.44,572.995L1046.33,1188.42L1077.66,1248.68L1103.21,1188.51L1107.58,572.995Z" style="fill:white;"/>',
                '<path d="M1113.46,573.039C1113.48,571.391 1112.86,569.806 1111.76,568.636C1110.65,567.467 1109.15,566.809 1107.58,566.809C1107.58,566.809 1039.44,566.465 1039.44,566.465C1037.7,566.465 1036.03,567.163 1034.8,568.404C1033.58,569.644 1032.89,571.323 1032.91,573.068L1037.34,1188.52C1037.36,1189.93 1037.7,1191.31 1038.36,1192.56L1069.59,1252.88C1071.22,1256.01 1074.5,1257.91 1078.02,1257.78C1081.54,1257.64 1084.66,1255.48 1086.04,1252.24L1111.63,1192.09C1112.1,1190.98 1112.35,1189.78 1112.36,1188.58C1112.36,1188.58 1113.19,1034.7 1113.47,880.811C1113.75,726.92 1113.46,573.036 1113.46,573.036L1113.46,573.039ZM1101.6,579.21C1101.12,609.514 1099,745.099 1097.32,880.696C1095.53,1024.77 1094.24,1168.86 1094.08,1186.62C1094.08,1186.62 1076.81,1227.38 1076.81,1227.38C1076.81,1227.38 1055.28,1186.15 1055.28,1186.15C1055.28,1186.15 1046.07,579.491 1046.07,579.491L1101.6,579.21Z"/>',
                '<rect x="990.174" y="557.379" width="163.143" height="25.78" style="fill:white;"/>',
                '<path d="M1159.2,557.379C1159.2,553.963 1156.57,551.194 1153.32,551.194C1153.32,551.194 990.174,549.775 990.174,549.775C985.974,549.775 982.569,553.179 982.569,557.379L982.461,583.159C982.461,587.419 985.914,590.872 990.174,590.872C990.174,590.872 1020.75,590.956 1055.43,590.682C1100.86,590.324 1153.32,589.422 1153.32,589.422C1156.78,589.422 1159.58,586.618 1159.58,583.159C1159.58,583.159 1159.2,557.379 1159.2,557.379ZM1147.34,563.617L1147.15,576.794C1131.98,576.547 1091.49,575.92 1055.43,575.636C1031.26,575.445 1009.07,575.428 997.854,575.436C997.854,575.436 997.81,564.917 997.81,564.917C997.81,564.917 1147.34,563.617 1147.34,563.617L1147.34,563.617Z"/>',
                '<g transform="matrix(0.77705,0,0,1.08289,240.176,-48.3599)">',
                    '<rect x="1046.96" y="421.682" width="46.332" height="136.339" style="fill:white;"/>',
                    '<path d="M1100.87,421.682C1100.87,418.527 1097.47,415.97 1093.29,415.97C1093.29,415.97 1046.96,415.316 1046.96,415.316C1042.06,415.316 1038.09,418.166 1038.09,421.682L1035.31,558.021C1035.31,562.639 1040.53,566.382 1046.96,566.382L1093.29,566.424C1099.76,566.424 1105,562.662 1105,558.021C1105,558.021 1104.56,523.936 1103.53,489.851C1102.49,455.748 1100.87,421.682 1100.87,421.682ZM1085.45,427.505C1084.94,438.667 1083.83,464.249 1083.06,489.851C1082.33,513.639 1081.9,537.426 1081.71,549.628C1081.71,549.628 1058.44,549.649 1058.44,549.649C1058.44,549.649 1055.96,427.921 1055.96,427.921L1085.45,427.505Z"/>',
                '</g>',
                '<g transform="matrix(1,0,0,1,-0.0836883,1.36703)">',
                    '<ellipse cx="1071.21" cy="387.219" rx="23.704" ry="20.164" style="fill:white;"/>',
                    '<path d="M1071.21,361.171C1063.42,360.558 1056.27,362.915 1050.66,366.71C1043.68,371.436 1039.69,378.959 1039.17,387.219C1038.82,395.741 1042.83,403.63 1049.55,409.139C1055.16,413.735 1062.85,416.429 1071.21,416.437C1079.52,416.212 1087.08,413.424 1092.59,408.784C1099.13,403.28 1103.15,395.603 1102.81,387.219C1102.43,379.056 1098.46,371.646 1091.66,366.832C1086.14,362.919 1079.01,360.462 1071.21,360.869L1071.21,361.171ZM1071.21,373.24C1075.83,373.482 1079.88,375.348 1082.91,377.978C1085.64,380.355 1087.19,383.665 1087.02,387.219C1086.89,390.559 1084.73,393.269 1081.98,395.282C1079.12,397.381 1075.31,398.44 1071.21,398.328C1067.17,398.333 1063.52,397.031 1060.72,394.927C1058.11,392.962 1055.98,390.422 1055.85,387.219C1055.63,383.753 1056.99,380.477 1059.61,378.099C1062.6,375.384 1066.56,373.304 1071.21,372.939L1071.21,373.24Z"/>',
                '</g>',
            '</g>',
        '</g>',
    '</g>'
     
        ));

    return render;
  }

 
}