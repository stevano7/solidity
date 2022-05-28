//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

import "./Hotel_Token.sol";

contract HTKExchange {

    address tknAddr = 0xd9145CCE52D386f254917e481eB44e9943F39138;
    address HTKAddr = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;
    HotelToken _hotelTkn = HotelToken(tknAddr);
    uint private HTKPrice;


    constructor(uint _HTKPrice) {

           HTKPrice = _HTKPrice;

        }

    function getHTKPrice() public view returns (uint) {

        return HTKPrice;
    }


    function buyHTK() payable public {

         require(msg.value >= HTKPrice, "Not Enough Balance");

    }

    function checkHTKBalance() public view returns (uint256) {

        return _hotelTkn.balanceOf(msg.sender);
    }

}
