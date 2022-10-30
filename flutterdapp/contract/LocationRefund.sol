// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

contract RefundContract {
    address[] public employees;
    address public employeer;

    struct ContractStatus {
        int8 latitude;
        int8 longitude;
        int8 maxRadius;
        uint8 payment;
        uint8 compCount;
        uint8 reqAmount;
    }
    mapping (address => ContractStatus) public empContractStatus;
    constructor() {
        employeer = msg.sender;
    }
    
    modifier onlyEmployeer() {
        require(msg.sender == employeer, "Only employeer has access to this function");
        _;
    }

    modifier onlyEmployee(address _addr) {

        bool exists = false;

        if(msg.sender == _addr){
            exists = true;
        }

        for (uint256 i = 0; i < employees.length; i++) {
            if (employees[i] == _addr) {
                exists = true;
                break;
            }
        }

        require(exists, "");
        _;
    }

    function payEmployee(address payable _to) public payable onlyEmployee(_to) {
        require(empContractStatus[_to].compCount > empContractStatus[_to].reqAmount,"The employee did not remain in compliance with all the agreements.");
        bool sent = _to.send(empContractStatus[_to].payment);
        require(sent, "Failed to send Ether");
    }

        
    // only employer has access
    function setEmployeeAccount(
        address _empAddr,
        int8 _latitude,
        int8 _longitude,
        int8 _maxRadius,
        uint8 _payAmount,
        uint8 _reqAmount
        // Should also set the duration the contract will be checking for
        ) public onlyEmployeer() {
            employees.push(_empAddr); // should delete if it is already in the list
            empContractStatus[_empAddr].latitude = _latitude;
            empContractStatus[_empAddr].longitude = _longitude;
            empContractStatus[_empAddr].maxRadius = _maxRadius;
            empContractStatus[_empAddr].payment = _payAmount;
            empContractStatus[_empAddr].compCount = 0;
            empContractStatus[_empAddr].reqAmount = _reqAmount;
    }

    function getAdmin() public view returns(address) {
        return employeer;
    }


    function getEmployees() public view returns(address[] memory){
        return employees;
    }
}