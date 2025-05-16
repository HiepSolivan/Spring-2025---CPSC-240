//****************************************************************************************************************************
// Program name: "Execution Speed".  The academic objective is to learn how to utilize the clock.
// The application objective is to measure the average time require to perform one floating point addition: addsd xmm10,xmm11 *
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
//  Program name: Execution Speed
//  Programming languages: Six modules in X86, two modules in C++, and one in bash
//  Date program began: 2025-Apr-21
//  Date of last update: 2025-Apr-25
//  Files in the program: manager.asm, input_array.asm, isfloat.asm, sum.asm, getfrequency.asm, utilities.inc, clock.cpp, r.sh
//  Testing: Alpha testing completed. All functions are correct.
//  Status: Ready for release
//
// Purpose
//  The academic objective is to learn how to utilize the clock.
//  The application objective is to measure the average time require to perform one floating point addition: addsd xmm10,xmm11
//
// This file
//  File name: clock.cpp
//  Language: C++ language, 202x standardization where x will be a decimal digit.
//  Max page width: 132 columns
//  Optimal print specification: 7 point font, monospace, 132 columns, 8½x11 paper
//  Compile: gcc  -m64 -Wall -no-pie -o clock.o -std=c++20 -c clock.cpp
//  Link: g++  -m64 -no-pie -o time.out manager.o input_array.o isfloat.o sum.o getfrequency.o clock.o -std=c++20 -Wall -z noexecstack -lm
//
// Execution: ./time.out
//
//===== Begin code area ===================================================================================================================================================
#include <iostream>
#include <iomanip>

extern "C" double manager();

int main() {
  std::cout << "Welcome to Time Measure programmed by Solivan Hiep.\n\n";

  double manager_caller{0.0};
  manager_caller = manager();

  std::cout << std::fixed << std::setprecision(1)
            << "The main function received " << manager_caller << " and will keep it.\n"
            << "Have a nice summer in 2025.\n\n";

  return 0;
}
