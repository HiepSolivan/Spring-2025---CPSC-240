#/bin/bash/

#Program Name: Huron's Triangles
#Author: Solivan Hiep
#Author Email: hiepsolivan@csu.fullerton.edu
#CWID: 884845876
#Class: CPSC 240-03 - Class Nbr 13604

#Deletes unnecessary files
rm *.o
rm *.out

echo "Assemble the source file manager.asm"
nasm -f elf64 -gdwarf -l manager.lis -o manager.o manager.asm

echo "Assemble the source file isfloat.asm"
nasm -f elf64 -gdwarf -l isfloat.lis -o isfloat.o isfloat.asm

echo "Assemble the source file istriangle.asm"
nasm -f elf64 -gdwarf -l istriangle.lis -o istriangle.o istriangle.asm

echo "Assemble the source file huron.asm"
nasm -f elf64 -gdwarf -l huron.lis -o huron.o huron.asm

echo "Compile the source file triangle.cpp"
gcc  -g -m64 -Wall -no-pie -o triangle.o -std=c++20 -c triangle.cpp

echo "Link the object modules to create an executable file"
g++  -g -m64 -no-pie -o compute.out manager.o isfloat.o istriangle.o huron.o triangle.o -std=c++20 -Wall -z noexecstack -lm

echo "Debug the program"
chmod +x compute.out
gdb ./compute.out

echo "This bash script will now terminate."
