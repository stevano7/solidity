//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

contract VaccineData {

        enum vaccineStatus {
            NOT_VACCINATED,
            VACCINATED
        }

        struct Vaccinee {

             string vaccineeId;
             string vaccineeName;
             vaccineStatus statVac;
            
        }

        event createvacc(string Vaccinee_Id, string Vaccinee_Name, vaccineStatus Vaccinee_Status);
        event updatevacc(string Vaccinee_Id, string Vaccinee_Name, vaccineStatus Vaccinee_Status);

        Vaccinee[] private vaccinee;

        mapping (string => vaccineStatus) private VacsMap;

      
        // Input the data of the person
        function createVaccinee(string memory _vaccineeId, string memory _vaccineeName) public {

            vaccinee.push(Vaccinee(_vaccineeId, _vaccineeName, vaccineStatus.NOT_VACCINATED));
            VacsMap[_vaccineeId] = vaccineStatus.NOT_VACCINATED;
            emit createvacc(_vaccineeId, _vaccineeName, vaccineStatus.NOT_VACCINATED);

        }

        // Update status after the person get vaccinated
        function updateVaccineStatus(uint _index, vaccineStatus _statVac) public {

                Vaccinee storage vacc = vaccinee[_index];
                vacc.statVac = _statVac;
                VacsMap[vacc.vaccineeId] = _statVac;
                emit updatevacc(vacc.vaccineeId, vacc.vaccineeName, vacc.statVac);
        }


        //Check if the data of a person exist in vaccination record
        function checkVaccinee(string memory _vaccineeId) public view returns (bool) {

                bool exist;
                
                for (uint i = 0; i < vaccinee.length; i++) {

                    if (keccak256(abi.encodePacked(_vaccineeId)) == keccak256(abi.encodePacked(vaccinee[i].vaccineeId))) {
                        exist = true;
                        break;

                    } else {

                        exist = false;
                    }

                }

                 return exist;

        }

        // Get vaccination status of a person
        function getVaccineStat(string memory _vaccineeId) public view returns (uint) {

                
                uint statNum;

               
                if (vaccineStatus.NOT_VACCINATED == VacsMap[_vaccineeId]) statNum = 0;
                if (vaccineStatus.VACCINATED == VacsMap[_vaccineeId]) statNum = 1;   
                
                return statNum;        

        }

        

}
