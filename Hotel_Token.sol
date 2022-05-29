//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

import "./ERC20.sol";

contract HotelToken is ERC20 {

    address public hotel;
    constructor() ERC20('Hotel_Token', 'HTK') {

        _mint(msg.sender, 10);
        hotel = msg.sender;
    }

    function mint(address to, uint amount) external {
        _mint(to, amount);
    }

    function burn(uint amount) external {
        _burn(msg.sender, amount);
    }

    // Transfer token
    function trfToken(address from, address to, uint amount) external {
        _transfer(from, to, amount);
    }

}
