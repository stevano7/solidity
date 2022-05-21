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

        function cekVaksinee(string memory _noKTP) public view returns (bool) {

                bool exist;
                
                for (uint i = 0; i < vaksinee.length; i++) {

                    if (keccak256(abi.encodePacked(_noKTP)) == keccak256(abi.encodePacked(vaksinee[i].noKTP))) {
                        exist = true;
                        break;

                    } else {

                        exist = false;
                    }

                }

                 return exist;

        }

        function getStatusVaksin(string memory _noKTP) public view returns (uint) {

                
                uint statNum;

               
                if (StatusVaksin.BELUM_VAKSIN == VacsMap[_noKTP]) statNum = 0;
                if (StatusVaksin.VAKSIN_PERTAMA == VacsMap[_noKTP]) statNum = 1;   
                if (StatusVaksin.VAKSIN_KEDUA == VacsMap[_noKTP]) statNum = 2;

                return statNum;        

        }

        

}
