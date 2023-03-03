//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import 'base64-sol/base64.sol';
import './HexStrings.sol';



contract HeadMail is ERC721Enumerable, Ownable {

  using Strings for uint256;
  using HexStrings for uint160;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() ERC721("Headmail", "HM") {}


  function mintItem() public payable returns (uint256) {
    require(balanceOf(msg.sender) == 0, "User has already minted an NFT");

    _tokenIds.increment();
    uint256 id = _tokenIds.current();
    _mint(msg.sender, id);
    return id;
  }

  function tokenURI(uint256 id) public view override returns (string memory) {
      require(_exists(id), "not exist");
      string memory name = string(abi.encodePacked('#', id.toString(), ' Headmail'));
      string memory description = string(abi.encodePacked('The protection from learning gabage.'));
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
      '<g id="_6-headmail" serif:id="6 headmail">',
        '<path d="M1200.49,265.187C1200.49,265.187 1099.06,232.88 1049.63,233.404C1000.2,233.927 902.567,267.806 902.567,267.806L899.608,545.432L1051.03,597.874L1172.99,569.758L1205.61,479.706L1200.94,338.934L1200.49,265.187ZM1052.07,560.099L944.88,510.076L941.099,407.886L1052.31,432.981L1160.33,407.532L1155.9,510.851L1052.07,560.099Z" style="fill:rgb(252,239,239);"/>',
        '<path d="M1206.37,265.149C1206.36,262.47 1204.7,260.106 1202.27,259.293C1202.37,259.293 1157.15,244.588 1112.24,234.83C1089.32,229.852 1066.47,226.2 1049.55,226.278C1032.72,226.364 1010.42,230.15 988.131,235.223C944.014,245.267 899.959,260.29 899.959,260.29C896.787,261.391 894.647,264.364 894.612,267.722L890.57,545.336C890.529,549.223 892.977,552.701 896.65,553.973L1048.08,606.4C1049.68,606.955 1051.4,607.047 1053.06,606.667L1174.88,577.981C1177.67,577.338 1179.94,575.324 1180.92,572.633L1212.93,482.358C1213.27,481.427 1213.43,480.439 1213.39,479.448L1207.53,338.742C1207.53,338.742 1206.37,265.15 1206.37,265.15L1206.37,265.149ZM1194.59,269.854L1194.35,338.974C1194.35,339.034 1194.35,339.093 1194.36,339.152L1197.79,478.405C1197.79,478.405 1166.66,562.535 1166.66,562.535C1166.66,562.535 1068.71,584.634 1051.55,588.506C1051.55,588.506 908.69,539.013 908.69,539.013C908.69,539.013 910.485,273.493 910.485,273.493C923.296,269.139 957.373,257.918 991.522,249.75C1012.62,244.703 1033.73,240.786 1049.7,240.53C1065.81,240.262 1087.58,243.573 1109.45,248.047C1145.92,255.508 1182.64,266.255 1194.59,269.854L1194.59,269.854ZM1049.45,565.431C1051.12,566.173 1053.05,566.167 1054.72,565.416C1054.59,565.416 1159.2,517.814 1159.2,517.814C1161.78,516.589 1163.48,514.036 1163.6,511.181L1169.16,407.911C1169.28,405.146 1168.1,402.484 1165.97,400.72C1163.83,398.956 1161,398.292 1158.3,398.927L1052.24,423.686C1052.24,423.686 942.941,399.72 942.941,399.72C940.407,399.148 937.751,399.786 935.752,401.445C933.753,403.105 932.638,405.599 932.734,408.195L937.455,510.351C937.558,513.136 939.212,515.63 941.738,516.809L1049.45,565.705L1049.45,565.431ZM1052.37,553.387L952.182,505.337C952.182,505.337 949.767,418.49 949.767,418.49C949.767,418.49 1050.31,441.826 1050.31,441.826C1051.65,442.129 1053.05,442.122 1054.38,441.806L1151.13,418.806C1151.13,418.806 1148.34,505.988 1148.34,505.988L1052.37,553.387Z"/>',
        '<g id="Layer5" transform="matrix(1,0,0,1,-4.69263,-649.844)">',
            '<g transform="matrix(1,0,0,1,70.4511,10.77)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,94.3781,33.657)">',
                '<rect x="912.715" y="890.059" width="37.163" height="38.867" style="fill:rgb(128,128,128);fill-opacity:0.35;"/>',
            '</g>',
            '<g transform="matrix(1,0,0,1,119.153,8.16943)">',
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
            '<g transform="matrix(1,0,0,1,72.0671,109.885)">',
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
        '</g>',
    '</g>'
     
        ));

    return render;
  }

}