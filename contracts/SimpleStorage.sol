// SPDX-License-Identifier: MIT

// FREE CAMP CODE COURSE

pragma solidity ^0.6.0;

contract SimpleStorage {

   // this will get initialized to 0!
   uint256 public favoriteNumber;
   bool favoriteBool;
   
  
   struct People {
       uint256 favoriteNumber;
       string name;
   }

   // Array
   People[] public people;

   // Mapping
   mapping(string => uint256) public nametoFavoriteNumber;

    

   function store(uint256 _favoritedNumber) public {
       favoriteNumber = _favoritedNumber;
   }

    // view functions to visualise, pure functions to do math calculations
   function retrieve() public view  returns(uint256){
       return favoriteNumber;
   }

   // Add person into the array
   // memory only store during the execution of the function
   // storage - the data will persist after function executes
   function AddPerson(string memory _name, uint256 _favoriteNumber) public {
    // add data into the array People
       people.push(People({favoriteNumber:_favoriteNumber, name: _name} ));
    // Link the name to the favoriteNumber (mapping)
       nametoFavoriteNumber[_name] = _favoriteNumber;
   }
        
}
