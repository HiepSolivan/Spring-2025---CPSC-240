#/bin/bash/

#Program Name: Arrays
#Author: Solivan Hiep
#Author Email: hiepsolivan@csu.fullerton.edu
#CWID: 884845876
#Class: CPSC 240-03 - Class Nbr 13604

#Deletes unnecessary files
rm *.o
rm *.out

echo "Assemble the source file manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

echo "Assemble the source file input_array.asm"
nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm

echo "Assemble the source file isfloat.asm"
nasm -f elf64 -l isfloat.lis -o isfloat.o isfloat.asm

echo "Assemble the source file output_array.asm"
nasm -f elf64 -l output_array.lis -o output_array.o output_array.asm

echo "Assemble the source file sum.asm"
nasm -f elf64 -l sum.lis -o sum.o sum.asm

echo "Assemble the source file swap.asm"
nasm -f elf64 -l swap.lis -o swap.o swap.asm

echo "Compile the source file sort.c"
gcc  -m64 -Wall -no-pie -o sort.o -std=c2x -c sort.c

echo "Compile the source file main.cpp"
g++  -m64 -Wall -no-pie -o main.o -std=c++20 -c main.cpp

echo "Link the object modules to create an executable file"
g++ -m64 -no-pie -o arrays.out manager.o input_array.o isfloat.o output_array.o sum.o swap.o sort.o main.o -std=c++20 -Wall -z noexecstack -lm

echo "Execute the program"
chmod +x arrays.out
./arrays.out

echo "This bash script will now terminate."
