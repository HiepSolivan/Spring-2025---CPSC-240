//****************************************************************************************************************************
// Program name: "Triangles".  The intent of this program is to compute the length of the third
// side of a triangle given other information about the triangle taken via user input.                                        *
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
//  Program name: Triangles
//  Programming languages: Main function in C; assembly function in X86-64; one bash function.
//  Date program began: 2025-Jan-26
//  Date of last update: 2025-Feb-5
//  Files in the program: geometry.c, triangle.asm, r.sh
//  Testing: Alpha testing completed. All functions are correct.
//  Status: Ready for release
//
// Purpose
//  The intent of this program is to compute the length of the third
//  side of a triangle given other information about the triangle taken via user input.

// This file
//  File name: geometry.c
//  Language: C++
//  Max page width: 132 columns
//  Optimal print specification: 7 point font, monospace, 132 columns, 8½x11 paper
//  Compile: gcc  -m64 -Wall -no-pie -o geometry.o -std=c2x -c geometry.c
//  Link: g++ -m64 -std=c++14 -fno-pie -no-pie -o length.out geometry.o triangle.o -z noexecstack -lm
//
// Execution: ./length.out
//
//===== Begin code area ===================================================================================================================================================

#include <math.h>
#include <stdio.h>

extern double triangle();

int main()
{
  printf("Welcome to the Triangle program maintained by Solivan Hiep.\n");
  printf("If errors are discovered please report them to Solivan Hiep at hiepsolivan@csu.fullerton.edu for a quick fix.");
  printf(" At California State University: Fullerton the customer comes first.\n");
  double length_of_third_side = 0;

  // Here, geometry calls the assembly file triangle.asm to compute the third side.
  // The assembly file will print several prompts as well as ask for user input.
  length_of_third_side = triangle();
  printf("The main function received this number %.10lf and plans to keep it until needed.\n", length_of_third_side);
  printf("An integer zero will be returned to the operating system. Bye.\n");
  return 0;
}
