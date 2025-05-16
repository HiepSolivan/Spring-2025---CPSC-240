//****************************************************************************************************************************
// Program name: "Huron's Triangle".  The intent of this program is to compute the area of any triangle where the lengths of the
// three sides is known using Huron's formula. The educational purpose is to reinforce my skill of using a few techniques from
// the past such as data validation and parameter passing and use macros in this program to hopefully understand how to use   *
// macros in other situations                                                                                                 *
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
//  Program name : Huron's Triangle ;
//  Programming languages : Five modules in X86, one module in C++, and one in bash;
//  Date program began : 2025 - Feb - 24;
//  Date of last update : 2025 - Mar - 05;
//  Files in the program : manager.asm, istriangle.asm, isfloat.asm, huron.asm, triangle.inc, main.c, r.sh
//  Testing: Alpha testing completed. All functions are correct.
//  Status: Ready for release
//
// Purpose
//  The intent of this program is to compute the area of any triangle where the lengths of the
//  three sides is known using Huron's formula.
//  The educational purpose is to reinforce my skill of using a few techniques from the past such as data validation
//  and parameter passing as well as use macros in this program to hopefully understand how to use
//  macros in other situations

// This file
//  File name: triangle.cpp
//  Language: C++ language
//  Development Platform: Windows 11 Enterprise Ver. 24H2. Intel(R) Core(TM) i3-8145U CPU @ 2.10GHz 2.30 GHz Processor. Running on Ubuntu 22.04.5 LTS.
//  Max page width: 132 columns
//  Optimal print specification: 7 point font, monospace, 132 columns, 8½x11 paper
//  Compile: gcc  -m64 -Wall -no-pie -o triangle.o -std=c++20 -c triangle.cpp
//  Compile (debug in GDB): gcc -g -m64 -Wall -no-pie -o triangle.o -std=c++20 -c triangle.cpp
//  Link: g++ -m64 -no-pie -o compute.out manager.o isfloat.o istriangle.o huron.o triangle.o -std=c++20 -Wall -z noexecstack -lm
//  Link: (debug in GDB): g++ -g -m64 -no-pie -o compute.out manager.o isfloat.o istriangle.o huron.o triangle.o -std=c++20 -Wall -z noexecstack -lm

//
// Execution: ./compute.out
//
//===== Begin code area ===================================================================================================================================================

#include <iostream>
#include <iomanip>
#include <string>

extern "C" double manager();

int main()
{
  std::cout << "Welcome to Huron’s Triangles.  We take care of all your triangle needs.\n"
            << "Please enter your name : ";
  std::string name;
  std::getline(std::cin, name);
  std::cout << '\n';

  double manager_area{0.0};
  manager_area = manager();

  std::cout << "The main function has received this number " << std::fixed << manager_area
            << ", and will keep it for a while.\n\n"
            << "Thank you " << name << ". Your patronage is appreciated.\n\n";

  if( manager_area == -1 )
  {
    std::cout << "A -1 will be returned to the operating system";
    return 0;
  }

  std::cout << "A zero will now be return to the operating system\n";
  return 0;
}
