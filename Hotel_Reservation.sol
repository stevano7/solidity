//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

import "./Vaccine_Data.sol";

contract Reservation {

         uint private rooms;
         uint private guestCount;
         uint private rate;
         uint private totRate;
         string public guestId;
         string public guestName;
         uint private vaccineStat;
         uint private duration;
         bool private isFilled;
         address payable private hotel;
         address vacDatAddr = 0xa131AD247055FD2e2aA8b156A11bdEc81b9eAD95;
         VaccineData _vacdata = VaccineData(vacDatAddr);
        
         event bookdata(string Guest_Id, string Guest_Name, uint Check_In_Date, uint Check_Out_Date);
         event reserve(string Guest_Id, string Guest_Name, string Booking_Code);
        

        constructor(uint _rooms, uint _rate) {
            rooms = _rooms;
            rate = _rate;
            hotel = msg.sender;
            guestCount = 0;
            isFilled = false;
        }

        // Fill booking form
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
                    totRate = rate * duration;     
                    isFilled = true;

                    emit bookdata(guestId, guestName, _checkInDate, _checkOutDate);
         }

         // Get vaccine status of the guest     
         function getVaccStat() public view returns (string memory) {

                string memory stat;

                if (vaccineStat == 0) stat = "Not Vaccinated";
                if (vaccineStat == 1) stat = "Vaccinated";     

                return stat;

         }

        // Check if any room is available
         modifier checkRoom() {
             require (rooms != 0, "Rooms Full Booked");
             _;
         }

        // Check if booking form has been filled
         modifier checkisFilled() {
             require (isFilled, "Please Fill Booking Data First");
             _;
         }

        // Check if the guest has been vaccinated
         modifier checkVaccStat() {
             require (vaccineStat != 0, "You Are Not Vaccinated");
             _;
         }      

        
        // Generate booking code
        function generateBookingCode(uint _index) private pure returns (string memory) {

              string[10] memory code1 = ["G-A001","G-B002","G-C125","G-X337","G-J940",
                                        "G-Y357","G-U404","G-W972","G-Z666","G-Q234"];

              return code1[_index];

        }

        // Make a booking
         function bookRoom() payable public checkRoom checkisFilled checkVaccStat {

             string memory bookCode;

                require(msg.value >= totRate, "Not Enough Balance");
                     hotel.transfer(msg.value);
                          
                rooms--;
                bookCode = generateBookingCode(guestCount);
                isFilled = false;
                guestCount++;
                 emit reserve(guestId, guestName, bookCode);

                
         }

        // Get total rooms remaining
         function getAvailableRooms() public view returns (uint) {
             return rooms;
         }

        // Get the total rate that has to be paid by guest
         function getTotRate() public view returns (uint) {
             return totRate;
         }

        // Checkout can only be done by hotel admin
         function checkOut() public {

             require(msg.sender == hotel, "You Are Not Hotel Admin");
             rooms++;
         }

}
