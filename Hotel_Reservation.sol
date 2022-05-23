//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

import "./Vaccine_Data.sol";
import "./Guest_Data.sol";
import "./Hotel_Token.sol";

contract Reservation {

         uint private rooms;
         uint private rate;
         uint private guestCount;
         uint private pay;
         string public guestId;
         string public guestName;
         uint private vaccineStat;
         uint private duration;
         bool private isFilled;
         address payable private hotel;
         address vacDatAddr = 0x9C9fF5DE0968dF850905E74bAA6a17FED1Ba042a;
         address guestAddr = 0xddaAd340b0f1Ef65169Ae5E41A8b10776a75482d;
         address tknAddr = 0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005;
         VaccineData _vacdata = VaccineData(vacDatAddr);
         GuestData _guestdata = GuestData(guestAddr);
         HotelToken _hotelTkn = HotelToken(tknAddr);
        
         event bookdata(string Guest_Id, string Guest_Name, uint Check_In_Date, uint Check_Out_Date);
         event reserve(string Guest_Id, string Guest_Name, string Booking_Code, uint Paid);
        

        constructor(uint _rooms, uint _rate) {
            rooms = _rooms;
            rate = _rate;
            hotel = msg.sender;
            guestCount = 0;
            isFilled = false;
        }


        function setBookData(string memory _guestId, string memory _guestName, uint _checkInDate, uint _checkOutDate) public {

            if ((keccak256(abi.encodePacked(_guestId)) != keccak256(abi.encodePacked(guestId))) && isFilled) {

                        revert("Please Complete Previous Booking Process");
                }


                if (bytes(_guestId).length == 0) {

                        revert("ID Number Cannot Be Empty");
                    }

                if (bytes(_guestName).length == 0) {

                        revert("Name Cannot Be Empty ");
                    }

                if (_checkInDate == 0) {

                        revert("Check In Date Cannot Be Empty");
                    }

                if (_checkOutDate == 0) {

                        revert("Check Out Date Cannot Be Empty");
                    }

                if (_checkOutDate <= _checkInDate) {

                        revert("Check Out Date Must Be Later Than Check In Date");
                    }          
      

                if (_vacdata.checkVaccinee(_guestId) == false) {

                        revert("Vaccinee Data Not Found");
                }



                    guestId = _guestId;
                    guestName = _guestName;
                    vaccineStat = _vacdata.getVaccineStat(_guestId); 
                    duration = _checkOutDate - _checkInDate;
                    pay = rate * duration;         
                    isFilled = true;

                    emit bookdata(guestId, guestName, _checkInDate, _checkOutDate);
         }

            
         function getVaccStat() public view returns (string memory) {

                string memory stat;

                if (vaccineStat == 0) stat = "Not Vaccinated";
                if (vaccineStat == 1) stat = "Vaccinated";     

                return stat;

         }

         modifier checkRoom() {
             require (rooms != 0, "Rooms Full Booked");
             _;
         }

         modifier checkisFilled() {
             require (isFilled, "Please Fill Booking Data First");
             _;
         }

         modifier checkVaccStat() {
             require (vaccineStat != 0, "You Are Not Vaccinated");
             _;
         }

         modifier checkBalance() {
                require(msg.value >= pay, "Not Enough Balance");
                _;
        }

        function generateBookingCode(uint _index) private pure returns (string memory) {

              string[5] memory code1 = ["G-A001","G-B002","G-C125","G-X337","G-J940"];

              return code1[_index];

        }


         function bookRoom() payable public checkRoom checkisFilled checkBalance checkVaccStat {

             string memory bookCode;

                rooms--;
                //_hotelTkn.trfToken(hotel,3);
                hotel.transfer(msg.value);
                _hotelTkn.mint(msg.sender, 1);
                bookCode = generateBookingCode(guestCount);
                isFilled = false;
                _guestdata.inputGuest(block.timestamp, guestId, guestName, bookCode, msg.sender, _hotelTkn.balanceOf(msg.sender));
                guestCount++;
                 emit reserve(guestId, guestName, bookCode, msg.value);

                
         }

         function getRooms() public view returns (uint) {
             return rooms;
         }

         function getPay() public view returns (uint) {
             return pay;
         }

         function checkOut() public {

             require(msg.sender == hotel, "You Are Not Hotel Admin");
             rooms++;
         }

}
