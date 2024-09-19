// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

contract sort {

    function sortAnArray(uint8[] memory array) public pure returns(uint8[] memory){
        for (uint8 i =0;i <array.length;i++ ){
          for(uint8 j =i+1;j <array.length;j++){
             if(array[i]>array[j]){
               uint8 temp = array[i];
               array[i] = array[j];
               array[j] = temp;
             }
          }
        }
      return array;
    }

}