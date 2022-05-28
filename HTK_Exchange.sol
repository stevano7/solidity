//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

import "./Hotel_Token.sol";

contract HTKExchange {

    address tknAddr = 0xd7B63981A38ACEB507354DF5b51945bacbe28414;
    address payable private HTKAddr = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;
    HotelToken _hotelTkn = HotelToken(tknAddr);
    uint private HTKPrice;
    uint private totalPay;

    event buytoken(address buyer, address seller, uint HTK_Amount, uint Total_Price);


    constructor(uint _HTKPrice) {

           HTKPrice = _HTKPrice;

        }

    function getHTKPrice() public view returns (uint) {

        return HTKPrice;
    }


    function buyHTK(uint HTK) payable public {

        totalPay = HTK * HTKPrice;

        require(msg.value >= totalPay, "Not Enough Balance");
        HTKAddr.transfer(msg.value);
        _hotelTkn.trfToken(HTKAddr, msg.sender, HTK);
        emit buytoken(msg.sender, HTKAddr, HTK, totalPay);

    }

    function checkHTKBalance() public view returns (uint256) {

        return _hotelTkn.balanceOf(msg.sender);
    }

}
