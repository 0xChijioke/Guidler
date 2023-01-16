//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import 'base64-sol/base64.sol';
import './HexStrings.sol';


contract CapeFront is ERC721Enumerable, Ownable {

  using Strings for uint256;
  using HexStrings for uint160;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() ERC721("Front Cape", "CF") {}
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
      string memory name = string(abi.encodePacked('#', id.toString(), ' CF'));
      string memory description = string(abi.encodePacked('The cape front'));
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
      '<g id="_1-cape-front" serif:id="1 cape front">',
        '<g transform="matrix(0.974489,-0.224436,0.224436,0.974489,-100.618,210.684)">',
            '<rect x="839.392" y="491.572" width="74.101" height="112.734" style="fill:rgb(195,34,34);"/>',
            '<path d="M919.392,491.506C919.428,488.099 916.817,485.366 913.559,485.402C913.493,485.387 839.392,484.012 839.392,484.012C835.216,484.012 831.831,487.397 831.831,491.572L830.337,604.306C830.337,609.307 834.391,613.36 839.392,613.36L913.493,613.001C918.295,613.001 922.187,609.108 922.187,604.306L919.376,491.572L919.392,491.506ZM907.452,497.87L905.016,595.57C905.016,595.57 848.327,595.295 848.327,595.295C848.327,595.295 847.051,498.991 847.051,498.991L907.452,497.87Z"/>',
        '</g>',
        '<g transform="matrix(0.570316,-0.278823,0.32073,0.656034,171.06,459.535)">',
            '<rect x="839.392" y="491.572" width="74.101" height="112.734" style="fill:rgb(195,34,34);"/>',
            '<path d="M922.853,491.409C922.956,486.775 918.85,483.091 913.68,483.181C913.493,483.102 839.392,481.364 839.392,481.364C832.907,481.364 827.649,485.935 827.649,491.572L825.129,604.306C825.129,611.154 831.514,616.705 839.392,616.705L913.493,616.333C921.133,616.333 927.328,610.948 927.328,604.306C927.328,604.306 926.579,576.129 925.437,547.939C924.294,519.725 922.761,491.572 922.761,491.572L922.853,491.409ZM903.766,500.271C903.225,510.77 902.302,529.341 901.548,547.939C900.871,564.66 900.332,581.377 900.005,592.211C900.005,592.211 853.379,591.977 853.379,591.977C853.379,591.977 851.356,501.5 851.356,501.5C851.356,501.5 903.766,500.271 903.766,500.271L903.766,500.271Z"/>',
        '</g>',
        '<g transform="matrix(0.692546,0.284265,-0.358665,0.873804,799.259,-176.597)">',
            '<rect x="839.392" y="491.572" width="74.101" height="112.734" style="fill:rgb(195,34,34);"/>',
            '<path d="M921.41,491.685C921.332,488.093 917.724,485.132 913.351,485.07C913.493,485.024 839.392,483.753 839.392,483.753C833.943,483.753 829.525,487.254 829.525,491.572L827.297,604.306C827.297,609.6 832.712,613.892 839.392,613.892L913.493,613.664C920.014,613.664 925.3,609.474 925.3,604.306C925.3,604.306 924.671,576.126 923.684,547.939C922.696,519.736 921.352,491.572 921.352,491.572L921.41,491.685ZM905.323,498.261C904.868,508.269 903.996,528.095 903.301,547.939C902.665,566.12 902.177,584.297 901.911,594.912C901.911,594.912 851.298,594.757 851.298,594.757C851.298,594.757 849.409,499.22 849.409,499.22L905.323,498.261Z"/>',
        '</g>',
        '<g transform="matrix(0.515984,0.333893,-0.347702,0.537325,989.768,-3.39589)">',
            '<rect x="839.392" y="491.572" width="74.101" height="112.734" style="fill:rgb(195,34,34);"/>',
            '<path d="M923.211,491.787C923.087,486.527 918.636,482.165 913.269,482.047C913.493,481.908 839.392,479.808 839.392,479.808C832.625,479.808 827.14,485.075 827.14,491.572L824.659,604.306C824.659,612.119 831.255,618.453 839.392,618.453L913.493,617.931C921.329,617.931 927.682,611.831 927.682,604.306L923.066,491.572L923.211,491.787ZM903.512,501.52L899.865,590.584C899.865,590.584 853.815,590.26 853.815,590.26C853.815,590.26 851.894,502.983 851.894,502.983L903.512,501.52Z"/>',
        '</g>',
      '</g>'
     
    ));

    return render;
  }

}