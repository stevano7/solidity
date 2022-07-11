Solidity Project
================

Hotel Reservation Smart Contract
--------------------------------

In this mini-project, I build a simple smart contract for hotel reservation.
A person can book a hotel room for a certain duration of time through this smart contract. 
The payment for this booking is using Ether.
The main requirement before they can book a room is they must have got vaccinated first. 
After the requirement passed and they complete the payment, then the reservation is successful and the booking code is issued.


Business Flow
-------------
1. A person has to get vaccinated first before booking a hotel
2. In the booking process, one has to fill in the booking form with some data beforehand (ID number, name, check-in date, check-out date)
3. This booking will be paid using Ether, so the guest has to make sure that they have enough Ether
4. When a person makes a booking, the contract will check if any room is available 
5. This contract will call the Vaccine_Data contract to check if the person has already got vaccinated or not based on the ID number.
6. If all of the condition is fulfilled and the payment is successful, then the booking process is done, and the guest will receive the booking code.


Diagram
-------
