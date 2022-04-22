//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

contract DataVaksin {

        enum StatusVaksin {
            BELUM_VAKSIN,
            VAKSIN_PERTAMA,
            VAKSIN_KEDUA
        }

        struct Vaksinee {

             string noKTP;
             string nama;
             StatusVaksin statVac;
            
        }

        Vaksinee[] private vaksinee;

        mapping (string => StatusVaksin) private VacsMap;

      

        function createVaksenee(string memory _noKTP, string memory _nama) public {

            vaksinee.push(Vaksinee(_noKTP, _nama, StatusVaksin.BELUM_VAKSIN));
            VacsMap[_noKTP] = StatusVaksin.BELUM_VAKSIN;

        }

        function updateStatusVaksin(uint _index, StatusVaksin _statVac) public {

                Vaksinee storage vaks = vaksinee[_index];
                vaks.statVac = _statVac;
                VacsMap[vaks.noKTP] = _statVac;
        }

        function getStatusVaksin(string memory _noKTP) public view returns (uint) {

                
                uint statNum;

                if (StatusVaksin.BELUM_VAKSIN == VacsMap[_noKTP]) statNum = 0;
                if (StatusVaksin.VAKSIN_PERTAMA == VacsMap[_noKTP]) statNum = 1;   
                if (StatusVaksin.VAKSIN_KEDUA == VacsMap[_noKTP]) statNum = 2;

                return statNum;        

        }

}

contract Reservasi {

         uint private jmlKamar;
         uint private tarif;
         string public noKTP;
         string public nama;
         uint public statusVaksin;
         bool private isiData;

         event reserve(string noKTP, uint harga);

        constructor(uint _jmlKamar, uint _tarif) {
            jmlKamar = _jmlKamar;
            tarif = _tarif;
            isiData = false;
        }


        function setDataPemesan(string memory _noKTP, string memory _nama) public {

                    DataVaksin _datavac;
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



         function pesanKamar(address payable _hotel) payable public cekKamar cekisiData cekStatVak cekEther {
                jmlKamar--;
                _hotel.transfer(msg.value);
                emit reserve(noKTP, msg.value);
         }

         function cekJmlKamar() public view returns (uint) {
             return jmlKamar;
         }

}
