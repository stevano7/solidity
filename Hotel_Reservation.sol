//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

import "./Vaccine_Data.sol";
import "./Guest_Data.sol";
import "./Hotel_Token.sol";

contract Reservation {

         uint private rooms;
         uint private guestCount;
         uint private token;
         uint private HTK;
         string public guestId;
         string public guestName;
         uint private vaccineStat;
         uint private duration;
         bool private isFilled;
         address payable private hotel;
         address vacDatAddr = 0xa131AD247055FD2e2aA8b156A11bdEc81b9eAD95;
         address guestAddr = 0xd9145CCE52D386f254917e481eB44e9943F39138;
         address tknAddr = 0x99CF4c4CAE3bA61754Abd22A8de7e8c7ba3C196d;
         VaccineData _vacdata = VaccineData(vacDatAddr);
         GuestData _guestdata = GuestData(guestAddr);
         HotelToken _hotelTkn = HotelToken(tknAddr);
        
         event bookdata(string Guest_Id, string Guest_Name, uint Check_In_Date, uint Check_Out_Date);
         event reserve(string Guest_Id, string Guest_Name, string Booking_Code, uint HTK);
        

        constructor(uint _rooms, uint _token) {
            rooms = _rooms;
            token = _token;
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
                    HTK = token * duration;        
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

        

        function generateBookingCode(uint _index) private pure returns (string memory) {

              string[10] memory code1 = ["G-A001","G-B002","G-C125","G-X337","G-J940",
                                        "G-Y357","G-U404","G-W972","G-Z666","G-Q234"];

              return code1[_index];

        }


         function bookRoom() public checkRoom checkisFilled checkVaccStat {

             string memory bookCode;

                 require((_hotelTkn.balanceOf(msg.sender)) >= HTK, "Not Enough HTK");
                _hotelTkn.trfToken(msg.sender, hotel, HTK);
                          
                rooms--;
                bookCode = generateBookingCode(guestCount);
                isFilled = false;
                _guestdata.inputGuest(block.timestamp, guestId, guestName, bookCode, msg.sender);
                guestCount++;
                 emit reserve(guestId, guestName, bookCode, HTK);

                
         }

         function getAvailableRooms() public view returns (uint) {
             return rooms;
         }

         function getTotalHTK() public view returns (uint) {
             return HTK;
         }

         function checkOut() public {

             require(msg.sender == hotel, "You Are Not Hotel Admin");
             rooms++;
         }

}
