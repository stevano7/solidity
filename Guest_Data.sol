//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

contract GuestData {

        uint guestCount;

        struct Guest {

                uint bookTime;
                uint num;
                string guestId;
                string guestName;
                string bookCode;
                address addr;
                uint tknBalance;
            }

        event guestdata(uint Booking_Time, string Guest_Id, string Guest_Name, string Booking_Code, address Guest_Addr, uint256 Guest_Token);

        constructor() {
             guestCount = 0;
        }

         Guest[] public guest;

        function inputGuest(uint _bookTime, string memory _guestId, string memory _guestName, string memory _bookCode, address _addr, uint256 _tknBalance) external {

             guestCount++;
             guest.push(Guest(_bookTime, guestCount, _guestId, _guestName, _bookCode, _addr, _tknBalance));
             emit guestdata (_bookTime, _guestId, _guestName, _bookCode, _addr, _tknBalance);

         }

    
         function getGuestName() public view returns (string memory) {

             return guest[guest.length - 1].guestName;
         }

         function getGuestAddr() public view returns (address) {

             return guest[guest.length - 1].addr;
         }

         function getGuestBookCode() public view returns (string memory) {

             return guest[guest.length - 1].bookCode;
         }

         function getBookTime() public view returns (uint256) {

             return guest[guest.length - 1].bookTime;
         }



        function getGuestToken() public view returns (uint256) {

            return guest[guest.length - 1].tknBalance;
        }

         
}