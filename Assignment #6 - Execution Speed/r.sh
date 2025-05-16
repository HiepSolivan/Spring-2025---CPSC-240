#/bin/bash/

#Program Name: Execution Speed
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

echo "Assemble the source file sum.asm"
nasm -f elf64 -l sum.lis -o sum.o sum.asm

echo "Assemble the source file getfrequency.asm"
nasm -f elf64 -l getfrequency.lis -o getfrequency.o getfrequency.asm

echo "Compile the source file clock.cpp"
gcc  -m64 -Wall -no-pie -o clock.o -std=c++20 -c clock.cpp

echo "Link the object modules to create an executable file"
g++  -m64 -no-pie -o time.out manager.o input_array.o isfloat.o sum.o getfrequency.o clock.o -std=c++20 -Wall -z noexecstack -lm

echo "Execute the program"
chmod +x time.out
./time.out

echo "This bash script will now terminate."
