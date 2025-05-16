#/bin/bash/

#Program Name: Non-deterministic Random Numbers
#Author: Solivan Hiep
#Author Email: hiepsolivan@csu.fullerton.edu
#CWID: 884845876
#Class: CPSC 240-03 - Class Nbr 13604

#Deletes unnecessary files
rm *.o
rm *.out

echo "Assemble the source file executive.asm"
nasm -f elf64 -l executive.lis -o executive.o executive.asm

echo "Assemble the source file fill_random_array.asm"
nasm -f elf64 -l fill_random_array.lis -o fill_random_array.o fill_random_array.asm

echo "Assemble the source file isnan.asm"
nasm -f elf64 -l isnan.lis -o isnan.o isnan.asm

echo "Assemble the source file show_array.asm"
nasm -f elf64 -l show_array.lis -o show_array.o show_array.asm

echo "Assemble the source file normalize_array.asm"
nasm -f elf64 -l normalize_array.lis -o normalize_array.o normalize_array.asm

echo "Compile the source file main.cpp"
gcc  -m64 -Wall -no-pie -o main.o -std=c++20 -c main.cpp

echo "Compile the source file sort.cpp"
gcc  -m64 -Wall -no-pie -o sort.o -std=c++20 -c sort.cpp

echo "Link the object modules to create an executable file"
g++  -m64 -no-pie -o generate.out executive.o fill_random_array.o isnan.o show_array.o normalize_array.o sort.o main.o -std=c++20 -Wall -z noexecstack -lm

echo "Execute the program"
chmod +x generate.out
./generate.out

echo "This bash script will now terminate."
