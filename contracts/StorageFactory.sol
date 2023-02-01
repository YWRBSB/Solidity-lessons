// SPDX-License-Identifier: MIT
// FREE CAMP CODE COURSE

pragma solidity ^0.6.0;

import "./SimpleStorage.sol";

// inheritance "is"
contract StorageFactory is SimpleStorage {

    SimpleStorage[] public simpleStorageArray;

   function createSimpleStorageContract() public {
       SimpleStorage simpleStorage = new SimpleStorage();
       simpleStorageArray.push(simpleStorage);
   }

   function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
       // Address
       // ABI - Application Binary Interface

       SimpleStorage SimpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
       SimpleStorage.store(_simpleStorageNumber);
   }

   function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
       SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
       return simpleStorage.retrieve();
       
       // another way to return:
       
       // return SimpleStorage(address(simpleStorageArray[_simpleStorageindex])).retrieve(); 
   }
}