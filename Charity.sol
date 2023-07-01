// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


contract Charity_Contract {
    address public charity;

    struct DonationStruct {
        address donor;
        uint256 amount;
        bool isVerified;
    }

    mapping(address => DonationStruct) public donations;
    uint256 public totalDonations;

    constructor () {
        charity = msg.sender;
        totalDonations = 0;
    }

    /*---------Events---------*/
    event DonationMade(address indexed _donorAddress, uint256 _amount);
    event DonationVerified(address indexed _donorAddress);


    /*---------Modifier---------*/
    modifier OnlyCharity () {
        require(msg.sender == charity, "only charity can call this function!");
        _;
    }


    /*---------Make-Donation---------*/
    function makeDonation () public payable {
        require(msg.value > 0, "Donation amount must be greater than 0");

        DonationStruct memory donation = DonationStruct(msg.sender, msg.value, false);
        donations[msg.sender] = donation;
        
        totalDonations += msg.value;

        emit DonationMade(msg.sender, msg.value);        
    }


    /*---------Varify-Donation---------*/
    function verifyDonation (address _donorAddr) public OnlyCharity {
        DonationStruct storage donation = donations[_donorAddr];

        require(donation.donor != address(0), "Donation not found!");
        require(!donation.isVerified, "Donation has already been verified!");

        donation.isVerified = true;

        emit DonationVerified(donation.donor);
    }


    /*---------Get-Donation---------*/
    function getDonation (address _donorAddr) public view returns (uint256, bool) {
        DonationStruct memory donation = donations[_donorAddr];
        return (donation.amount, donation.isVerified);
    }
}