// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.4.0/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@4.4.0/access/Ownable.sol";

contract ITUBlockchainGenesisNFT is ERC1155, Ownable {
    string public name;
    string public symbol;
    uint public supply;
    bool public activeMint;
    string private INITIAL_URI = "https://";
    uint private constant GENESIS_ID = 0;
    mapping (address => bool) private minters;

    constructor() ERC1155(INITIAL_URI) {
        name = "ITU Blockchain Genesis NFT";
        symbol = "ITUBC";
        activeMint = true;
    }
    

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mintGenesis() public payable {
        require(activeMint, "Mint operations have stopped!");
        require(msg.value >= .2 ether, "Inappropriate payment!");
        minters[msg.sender] == true;
        supply++;
        _mint(msg.sender, GENESIS_ID, 1, "");
    }

    function changeMintStatus() public onlyOwner {
        activeMint = !activeMint;
    }

    function isMinter() external view returns (bool) {
        return minters[msg.sender];
    }
}
