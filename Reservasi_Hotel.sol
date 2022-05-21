//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

import "./Data_Vaksin.sol";

contract Reservasi {

         uint private jmlKamar;
         uint private tarif;
         string public noKTP;
         string public nama;
         uint public statusVaksin;
         bool public isiData;
         address addr = 0xD7ACd2a9FD159E69Bb102A1ca21C9a3e3A5F771B;
         DataVaksin _datavac = DataVaksin(addr);

         event reserve(string noKTP, uint harga);

        constructor(uint _jmlKamar, uint _tarif) {
            jmlKamar = _jmlKamar;
            tarif = _tarif;
            isiData = false;
        }


        function setDataPemesan(string memory _noKTP, string memory _nama) public {

            if ((keccak256(abi.encodePacked(_noKTP)) != keccak256(abi.encodePacked(noKTP))) && isiData) {

                        revert("Harap Selesaikan Pemesanan Sebelumnya");
                }


                if (bytes(_noKTP).length == 0) {

                        revert("Harap isi No KTP");
                    }

                if (bytes(_nama).length == 0) {

                        revert("Harap isi Nama");
                    }       

                if (_datavac.cekVaksinee(_noKTP) == false) {

                        revert("Data Vaksin Tidak Ditemukan");
                }



                    noKTP = _noKTP;
                    nama = _nama;
                    statusVaksin = _datavac.getStatusVaksin(_noKTP);             
                    isiData = true;
         }

         
         function getStatVak() public view returns (string memory) {

                string memory stat;

                if (statusVaksin == 0) stat = "Belum Vaksin";
                if (statusVaksin == 1) stat = "Sudah Vaksin Pertama";     
                if (statusVaksin == 2) stat = "Sudah Vaksin Kedua"; 

                return stat;

         }

         modifier cekKamar() {
             require (jmlKamar != 0, "Kamar Sudah Penuh");
             _;
         }

         modifier cekisiData() {
             require (isiData, "Data Belum Diisi");
             _;
         }

         modifier cekStatVak() {
             require (statusVaksin != 0, "Anda Belum Vaksin");
             _;
         }

         modifier cekEther() {
                require(msg.value >= tarif, "Ether tidak cukup");
                _;
        }



         function pesanKamar(address payable _hotel) payable public cekKamar cekisiData cekEther cekStatVak {

                //if (statusVaksin == 0) {
                    
                    //revert("Anda Belum Vaksin");
                //}

                jmlKamar--;
                _hotel.transfer(msg.value);
                emit reserve(noKTP, msg.value);
                isiData = false;
                
         }

         function cekJmlKamar() public view returns (uint) {
             return jmlKamar;
         }

}
