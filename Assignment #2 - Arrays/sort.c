//****************************************************************************************************************************
// Program name: "Arrays".  The intent of this program is to sort, print, and compute the mean of an array of float numbers
//  in which the array was constructed using user input. The educational purpose is to gain experience programming with arrays.                                    *
// Copyright (C) 2025  Solivan Hiep                                                                                           *
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
// version 3 as published by the Free Software Foundation.                                                                    *
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
// A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
//****************************************************************************************************************************

//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
// Author information
//  Author name: Solivan Hiep
//  Author email: hiepsolivan@csu.fullerton.edu
//  CWID: 8848458756
//  Class: CPSC 240-03 - Class Nbr 13604
//
// Program information
//  Program name: Arrays
//  Programming languages: Six modules in X86, one module in C, one module in C++, and one in bash
//  Date program began: 2025-Feb-09
//  Date of last update: 2025-Feb-20
//  Files in the program: manager.asm, input_array.asm, isfloat.asm, output_array.asm, sum.asm, swap.asm, sort.c, main.c, r.sh
//  Testing: Alpha testing completed. All functions are correct.
//  Status: Ready for release
//
// Purpose
//  The intent of this program is to sort, print, and compute the mean of an array of float numbers
//  in which the array was constructed using user input.
//  The educational purpose is to gain experience programming with arrays.

// This file
//  File name: sort.c
//  Language: C language, 202x standardization where x will be a decimal digit.
//  Max page width: 132 columns
//  Optimal print specification: 7 point font, monospace, 132 columns, 8½x11 paper
//  Compile: gcc  -m64 -Wall -no-pie -o sort.o -std=c2x -c sort.c
//  Link: g++ -m64 -no-pie -o arrays.out manager.o input_array.o isfloat.o output_array.o sum.o swap.o sort.o main.o -std=c++20 -Wall -z noexecstack -lm
//
// Execution: ./arrays.out
//
//===== Begin code area ===================================================================================================================================================

extern void swap(double * float_1, double * float_2);

void sort (double array[], long array_size) {
  // The sort used is insertion sort
  for( int outer_index = 0; outer_index < array_size; ++outer_index ) {
    int minimum_index = outer_index;

    for ( int inner_index = outer_index + 1; inner_index < array_size; ++inner_index ) {
      if ( array[inner_index] < array[minimum_index] ) {
        minimum_index = inner_index;

        swap(&array[outer_index], &array[minimum_index]);
      }
    }
  }
}
