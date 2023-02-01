//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import 'base64-sol/base64.sol';
import "hardhat/console.sol";
import './HexStrings.sol';



abstract contract CapeContract {
  function renderTokenById(uint256 id) external virtual view returns (string memory);
  function transferFrom(address from, address to, uint256 id) external virtual;
}
abstract contract ArmsContract {
  function renderTokenById(uint256 id) external virtual view returns (string memory);
  function transferFrom(address from, address to, uint256 id) external virtual;
}
abstract contract ChestContract {
  function renderTokenById(uint256 id) external virtual view returns (string memory);
  function transferFrom(address from, address to, uint256 id) external virtual;
}
abstract contract CapeFrontContract {
  function renderTokenById(uint256 id) external virtual view returns (string memory);
  function transferFrom(address from, address to, uint256 id) external virtual;
}
abstract contract BootsContract {
  function renderTokenById(uint256 id) external virtual view returns (string memory);
  function transferFrom(address from, address to, uint256 id) external virtual;
}
abstract contract WaistContract {
  function renderTokenById(uint256 id) external virtual view returns (string memory);
  function transferFrom(address from, address to, uint256 id) external virtual;
}
abstract contract HeadmailContract {
  function renderTokenById(uint256 id) external virtual view returns (string memory);
  function transferFrom(address from, address to, uint256 id) external virtual;
}
abstract contract HelmetContract {
  function renderTokenById(uint256 id) external virtual view returns (string memory);
  function transferFrom(address from, address to, uint256 id) external virtual;
}
abstract contract ETHLogoContract {
  function renderTokenById(uint256 id) external virtual view returns (string memory);
  function transferFrom(address from, address to, uint256 id) external virtual;
}
abstract contract SwordContract {
  function renderTokenById(uint256 id) external virtual view returns (string memory);
  function transferFrom(address from, address to, uint256 id) external virtual;
}

contract Noob is ERC721Enumerable, IERC721Receiver {

  error UNRECOGNIZED_TOKEN();

  using Strings for uint256;
  using Strings for uint8;
  using HexStrings for uint160;
  using Counters for Counters.Counter;

  Counters.Counter private _tokenIds;

  
 uint256 private _totalSupply;

  CapeContract cape;
  ArmsContract arms;
  ChestContract chest;
  CapeFrontContract capeFront;
  BootsContract boots;
  WaistContract waist;
  HeadmailContract headmail;
  HelmetContract helmet;
  ETHLogoContract ethlogo;
  SwordContract sword;
//   CastleContract castle;

  mapping(uint256 => uint256[]) capeById;
  mapping(uint256 => uint256[]) armsById;
  mapping(uint256 => uint256[]) chestById;
  mapping(uint256 => uint256[]) capeFrontById;
  mapping(uint256 => uint256[]) bootsById;
  mapping(uint256 => uint256[]) waistById;
  mapping(uint256 => uint256[]) headmailById;
  mapping(uint256 => uint256[]) helmetById;
  mapping(uint256 => uint256[]) ethlogoById;
  mapping(uint256 => uint256[]) swordById;

  constructor(
    address _cape, 
    address _arms, 
    address _chest, 
    address _capeFront, 
    address _boots, 
    address _waist, 
    address _headmail, 
    address _helmet, 
    address _ethlogo, 
    address _sword 
    ) ERC721("Noob", "NOOB") {
    cape = CapeContract(_cape);
    arms = ArmsContract(_arms);
    chest = ChestContract(_chest);
    capeFront = CapeFrontContract(_capeFront);
    boots = BootsContract(_boots);
    waist = WaistContract(_waist);
    headmail = HeadmailContract(_headmail);
    helmet = HelmetContract(_helmet);
    ethlogo = ETHLogoContract(_ethlogo);
    sword = SwordContract(_sword);

    _totalSupply = 0;
  }

  function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

  function mintItem() public returns (uint256) {


      _tokenIds.increment();
      _totalSupply++;
      uint256 id = _tokenIds.current();
      _mint(msg.sender, id);

      return id;
  }

  

  function tokenURI(uint256 id) public view override returns (string memory) {
      require(_exists(id), "not exist");
      string memory name = string(abi.encodePacked('#', id.toString(), ' Guidler'));
      string memory description = string(abi.encodePacked('Ready to take on the challenges of old.'));
      string memory image = Base64.encode(bytes(generateSVGofTokenById(id)));

      return string(abi.encodePacked(
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
      ));
  }

  function generateSVGofTokenById(uint256 id) internal view returns (string memory) {

    string memory svg = string(abi.encodePacked(
    '<svg width="100%" height="100%" viewBox="0 0 2048 1536" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve" xmlns:serif="http://www.serif.com/" style="fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:1.5;">',
        renderTokenById(id),
        '<g id="Layer1">',
            '<path d="M904.381,920.149L903.621,920.149L903.621,1439.49L1018.18,1439.49L1018.18,929.695L1075.5,929.695L1075.5,1439.49L1190.05,1439.49L1188.59,920.149L1188.58,669.327L1187.83,668.731L1188.57,550.619L1186.66,311.12L905.091,310.202L904.386,550.619L584.257,835.339L645.277,901.95L903.667,665.245L904.381,920.149ZM1522.93,822.249L1188.57,550.619L1188.58,669.327L1468.34,892.141L1522.93,822.249Z" style="fill:rgb(215,234,240);"/>',
            '<path d="M898.479,916.71C897.819,917.693 897.435,918.876 897.435,920.149L896.62,1439.49C896.62,1443.36 899.755,1446.49 903.621,1446.49L1018.18,1446.66C1022.14,1446.66 1025.35,1443.45 1025.35,1439.49C1025.35,1439.49 1025.96,1002.06 1026.05,937.592C1026.05,937.592 1067.52,937.651 1067.52,937.651C1067.52,937.651 1066.92,1439.49 1066.92,1439.49C1066.92,1444.23 1070.76,1448.07 1075.5,1448.07L1190.05,1448.18C1192.36,1448.18 1194.57,1447.26 1196.2,1445.62C1197.83,1443.99 1198.74,1441.78 1198.73,1439.47L1197.67,920.142L1197.71,688.256C1217.43,703.933 1254.56,733.395 1295.06,765.266C1373.31,826.86 1464.06,897.513 1464.06,897.513C1465.49,898.655 1467.32,899.176 1469.14,898.961C1470.96,898.746 1472.62,897.813 1473.75,896.368L1527.57,825.871L1527.57,826.057C1529.54,823.401 1529.13,819.573 1526.64,817.448C1526.82,817.448 1233.18,575.87 1197.65,546.642L1195.65,311.048C1195.61,306.12 1191.62,302.141 1186.69,302.125L905.119,301.534C902.82,301.527 900.612,302.433 898.981,304.054C897.35,305.675 896.43,307.877 896.424,310.176L896.093,546.898C864.776,574.854 579.264,829.725 579.264,829.725C577.761,831.062 576.857,832.946 576.754,834.955C576.651,836.964 577.359,838.93 578.717,840.413L639.887,906.888C642.614,909.865 647.238,910.067 650.215,907.34L897.227,680.028L898.479,916.71ZM1179.44,672.348L1179.51,920.15L1188.59,929.231L1179.51,920.175L1181.34,1430.82C1181.34,1430.82 1084.06,1430.91 1084.06,1430.91C1084.06,1430.91 1083.46,929.695 1083.46,929.695C1083.46,925.295 1079.9,921.728 1075.5,921.728L1018.18,921.808C1013.82,921.808 1010.29,925.339 1010.29,929.695L1011,1432.33C1011,1432.33 910.612,1432.48 910.612,1432.48L909.813,922.962C910.306,922.102 910.57,921.13 910.567,920.133L910.265,920.133L910.185,665.227C910.177,662.646 908.648,660.312 906.284,659.276C903.92,658.239 901.167,658.696 899.264,660.439C899.264,660.439 682.952,857.7 645.753,891.622C645.753,891.622 594.942,835.907 594.942,835.907C637.936,797.811 909.901,556.82 909.901,556.82C911.666,555.25 912.678,553.004 912.685,550.643L913.719,318.907C913.719,318.907 1177.73,320.075 1177.73,320.075C1177.73,320.075 1179.45,550.623 1179.45,550.623C1179.45,550.623 1178.69,668.674 1178.69,668.674C1178.68,669.954 1178.94,671.203 1179.44,672.348ZM1197.58,569.18L1514.48,823.4L1514.48,823.4L1467.3,882.439C1447,865.917 1372.21,805.068 1305.91,751.639C1255.65,711.138 1210.26,674.931 1197.69,664.92L1197.49,582.852L1197.58,569.18Z"/>',
            '<g transform="matrix(0.338298,-0.0543862,-0.00270847,-0.0231788,682.944,486.841)">',
                '<rect x="918.371" y="284.173" width="103.194" height="13.67" style="fill:rgb(222,175,175);stroke:black;stroke-width:65.09px;"/>',
            '</g>',
            '<g transform="matrix(0.312245,0.0339857,0.0249004,-0.314747,730.723,482.407)">',
                '<rect x="1073.24" y="284.786" width="97.737" height="9.019" style="fill:rgb(222,175,175);stroke:black;stroke-width:51.1px;"/>',
            '</g>',
            '<g transform="matrix(-0.235288,0.00799767,0.000223268,0.00903688,1304.31,508.96)">',
                '<rect x="962.034" y="380.869" width="188.078" height="15.908" style="fill:rgb(222,175,175);stroke:black;stroke-width:95.13px;"/>',
            '</g>',
        '</g>',
        renderFrontTokenById(id),
    '</svg>'
    ));

    return svg;
  }

   // Visibility is `public` to enable it being called by other contracts for composition.
  function renderTokenById(uint256 id) public view returns (string memory) {
    string memory render = string(abi.encodePacked(
       '<g>',
        renderCape(id),
       '</g>'
    ));

    return render;
  }
  function renderFrontTokenById(uint256 id) public view returns (string memory) {
    string memory render = string(abi.encodePacked(
       '<g>',
        renderArms(id),
        renderChest(id),
        renderCapeFront(id),
        renderBoots(id),
        renderWaist(id),
        renderHeadmail(id),
        renderHelmet(id),
        renderETHLogo(id),
        renderSword(id),
       '</g>'
    ));

    return render;
  }

   function renderCape(uint256 _id) internal view returns (string memory) {
    string memory capeSVG = "";

    for (uint8 i = 0; i < capeById[_id].length; i++) {

      capeSVG = string(abi.encodePacked(
        capeSVG,
          '<g>',
          cape.renderTokenById(capeById[_id][i]),
          '</g>'
          ));
    
      }
    
    return capeSVG;
  }
  function renderArms(uint256 _id) internal view returns (string memory) {
    string memory armsSVG = "";

    for (uint8 i = 0; i < armsById[_id].length; i++) {

    armsSVG = string(abi.encodePacked(
      armsSVG,
        '<g>',
        arms.renderTokenById(armsById[_id][i]),
        '</g>'));
    }

    return armsSVG;
  }
  function renderChest(uint256 _id) internal view returns (string memory) {
    string memory chestSVG = "";

    for (uint8 i = 0; i < chestById[_id].length; i++) {

    chestSVG = string(abi.encodePacked(
      chestSVG,
        '<g>',
        chest.renderTokenById(chestById[_id][i]),
        '</g>'));
    }
     return chestSVG;
  }
  function renderCapeFront(uint256 _id) internal view returns (string memory) {
    string memory capeFrontSVG = "";

    for (uint8 i = 0; i < capeFrontById[_id].length; i++) {
    capeFrontSVG = string(abi.encodePacked(
      capeFrontSVG,
        '<g>',
        capeFront.renderTokenById(capeFrontById[_id][i]),
        '</g>'));
    }

    return capeFrontSVG;
  }
  function renderBoots(uint256 _id) internal view returns (string memory) {
    string memory bootsSVG = "";

    for (uint8 i = 0; i < bootsById[_id].length; i++) {
    bootsSVG = string(abi.encodePacked(
      bootsSVG,
        '<g>',
        boots.renderTokenById(bootsById[_id][i]),
        '</g>'));
    }

    return bootsSVG;
  }
  function renderWaist(uint256 _id) internal view returns (string memory) {
    string memory waistSVG = "";

    for (uint8 i = 0; i < waistById[_id].length; i++) {
    waistSVG = string(abi.encodePacked(
      waistSVG,
        '<g>',
        waist.renderTokenById(waistById[_id][i]),
        '</g>'));
    }

    return waistSVG;
  }
  function renderHeadmail(uint256 _id) internal view returns (string memory) {
    string memory headmailSVG = "";

    for (uint8 i = 0; i < headmailById[_id].length; i++) {
    headmailSVG = string(abi.encodePacked(
      headmailSVG,
        '<g>',
        headmail.renderTokenById(headmailById[_id][i]),
        '</g>'));
    }

    return headmailSVG;
  }
  function renderHelmet(uint256 _id) internal view returns (string memory) {
    string memory helmetSVG = "";

    for (uint8 i = 0; i < helmetById[_id].length; i++) {
    helmetSVG = string(abi.encodePacked(
      helmetSVG,
        '<g>',
        helmet.renderTokenById(helmetById[_id][i]),
        '</g>'));
    }

    return helmetSVG;
  }
  function renderETHLogo(uint256 _id) internal view returns (string memory) {
    string memory ethlogoSVG = "";

    for (uint8 i = 0; i < ethlogoById[_id].length; i++) {
    ethlogoSVG = string(abi.encodePacked(
      ethlogoSVG,
        '<g>',
        ethlogo.renderTokenById(ethlogoById[_id][i]),
        '</g>'));
    }

    return ethlogoSVG;
  }
  function renderSword(uint256 _id) internal view returns (string memory) {
    string memory swordSVG = "";

    for (uint8 i = 0; i < swordById[_id].length; i++) {
    swordSVG = string(abi.encodePacked(
      swordSVG,
        '<g>',
        sword.renderTokenById(swordById[_id][i]),
        '</g>'));
    }

    return swordSVG;
  }
  
 
  // https://github.com/GNSPS/solidity-bytes-utils/blob/master/contracts/BytesLib.sol#L374
  function toUint256(bytes memory _bytes) internal pure returns (uint256) {
        require(_bytes.length >= 32, "toUint256_outOfBounds");
        uint256 tempUint;

        assembly {
            tempUint := mload(add(_bytes, 0x20))
        }

        return tempUint;
  } 

  // to receive  ERC721 tokens
  function onERC721Received(
      address operator,
      address from,
      uint256 nftTokenId,
      bytes calldata _data) external override returns (bytes4) {
        
      uint256 tokenId = toUint256(_data);
      
      require(ownerOf(tokenId) == operator, "you can only add collectables to your Guidler.");

      if (msg.sender == address(cape)) {

        capeById[tokenId].push(nftTokenId);

      } else if (msg.sender == address(arms)){

        armsById[tokenId].push(nftTokenId);

      } else if (msg.sender == address(chest)){

        chestById[tokenId].push(nftTokenId);

      } else if (msg.sender == address(capeFront)){

        capeFrontById[tokenId].push(nftTokenId);

      } else if (msg.sender == address(boots)){

        bootsById[tokenId].push(nftTokenId);

      } else if (msg.sender == address(waist)){

        waistById[tokenId].push(nftTokenId);

      } else if (msg.sender == address(headmail)){

        headmailById[tokenId].push(nftTokenId);

      } else if (msg.sender == address(helmet)){

        helmetById[tokenId].push(nftTokenId);

      } else if (msg.sender == address(ethlogo)){

        ethlogoById[tokenId].push(nftTokenId);

      } else if (msg.sender == address(sword)){

        swordById[tokenId].push(nftTokenId);

      } else {
        revert UNRECOGNIZED_TOKEN();
      }


      return this.onERC721Received.selector;
    }
}