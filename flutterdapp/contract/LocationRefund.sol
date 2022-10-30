// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.7;

contract LocationRefund.sol {

    address payable employee;
    address payable employer;

    struct Employee{
        string employeeName;
        bool paid;
        bool done;
        uint timestamp;
        uint payment;
        string employee_address;
        uint latitude;
        uint longtude;
        address payable employee;
        address payable employer;
        uint no_of_jobs

    }

    mapping (uint => Employee) public Request_Number;

    //to check if the sender is an employer

    modifier onlyEmployer(uint _index)  {
        require(msg.sender == Request_Number[_index].employer, "Only Employer can access this");
    }

    //to check if the sender is an employer

    modifier onlyNotDone(uint _index)  {
        require(Request_Number[_index].done == false, "The job is not currently available");
    }

    //to check if the sender has enough money 
    modifier enoughpayment(uint _index)  {
        require(msg.value >= uint(Request_Number[_index].payment), "Not enough Ether in your waller);
    }

    function addJob(string memory _jobname, uint memory _joblatitude, uint _payment, uint _joblongtude) public {
        require(msg.sender != address(0));
        no_of_jobs ++;
        bool done = false;
        Request_Number[no_of_jobs] = Employee(_no_of_jobs, _jobname , _joblatitude, _payment, _joblongtude, msg.sender,address(0))
    }

    function payment(uint _index) public payable enoughpayment(_index) onlyNotDone(_index){
        require(msg.sender == address(0));
        address payable _employer = Request_Number[_index].employer;
        uint totalfee = Request_Number[_index].payment
        _employer.transfer(totalfee);
        Request_Number[_index].employer = msg.sender;
        Request_Number[_index].done = true;
        Request_Number[_index].timestamp = block.timestamp;
    }
}