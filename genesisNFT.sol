// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.4.0/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@4.4.0/access/Ownable.sol";

contract ITUBlockchainGenesisToken is ERC1155, Ownable {
    string public name;
    string public symbol;
    uint256 public supply;
    bool public activeMint;
    string private INITIAL_URI = "ipfs://QmUeJJwXPo1XFvvvFcKjZUY2yCYjuogRH2vg1f1B7kXS7B";
    uint256 private constant GENESIS_ID = 0;
    uint256 public price = .1773 ether;
    mapping(address => uint256) private minters;
    event Minted(address _address);

    constructor() ERC1155(INITIAL_URI) {
        name = "ITU Blockchain Genesis Token";
        symbol = "ITUGT";
        activeMint = true;
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mintGenesis() public payable {
        require(activeMint, "Mint operations have stopped!");
        require(msg.value >= price, "Inappropriate payment!");
        minters[msg.sender]++;
        supply++;
        _mint(msg.sender, GENESIS_ID, 1, "");
        emit Minted(msg.sender);
    }

    function giftGenesis(address _receiver) public onlyOwner {
        minters[_receiver]++;
        supply++;
        _mint(_receiver, GENESIS_ID, 1, "");
        emit Minted(_receiver);
    }

    function changeMintStatus() public onlyOwner {
        activeMint = !activeMint;
    }

    function getMintCounts(address _user) external view returns (uint256) {
        return minters[_user];
    }

    function changePrice(uint256 _newPrice) public onlyOwner {
        require(price != _newPrice, "Price is already set to this value!");
        price = _newPrice;
    }

    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "No balance!");
        payable(owner()).transfer(address(this).balance);
    }
}