//****************************************************************************************************************************
// Program name: "Non-deterministic random numbers".  The intent of this program is to generate up to 100 random number using *
// the non-deterministic random number generator found inside of modern X86 microprocessors.                                  *
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
//  Program name: Non-deterministic Random Numbers
//  Programming languages: Five modules in X86, two modules in C++, and one in bash
//  Date program began: 2025-Mar-24
//  Date of last update: 2025-Mar-27
//  Files in the program: executive.asm, fill_random_array.asm, isnan.asm, normalize.asm, show_array.asm, main.cpp, sort.cpp, r.sh
//  Testing: Alpha testing completed. All functions are correct.
//  Status: Ready for release
//
// Purpose
//  The intent of this program is to generate up to 100 random number using
//  the non-deterministic random number generator found inside of modern X86 microprocessors.
//
// This file
//  File name: main.cpp
//  Language: C++ language, 202x standardization where x will be a decimal digit.
//  Max page width: 132 columns
//  Optimal print specification: 7 point font, monospace, 132 columns, 8½x11 paper
//  Compile: gcc  -m64 -Wall -no-pie -o sort.o -std=c++20 -c sort.cpp
//  Link: g++ -m64 -no-pie -o generate.out executive.o fill_random_array.o isnan.o show_array.o normalize_array.o sort.o main.o -std=c++20 -Wall -z noexecstack -lm
//
// Execution: ./generate.out
//
//===== Begin code area ===================================================================================================================================================
#include <iostream>

    extern "C" char *
    executive();

int main(){
  std::cout << "Welcome to Random Products, LLC.\n"
            << "This software is maintained by Solivan Hiep.\n";

  char * executive_caller = executive();
  std::cout << "Oh, " << executive_caller << ". We hope you enjoyed your arrays. Do come again.\n"
            << "A zero will be returned to the operating system.\n";
  return 0;
}
