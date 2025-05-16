#/bin/bash/

#Program Name: Non-deterministic Random Numbers
#Author: Solivan Hiep
#Author Email: hiepsolivan@csu.fullerton.edu
#CWID: 884845876
#Class: CPSC 240-03 - Class Nbr 13604

#Deletes unnecessary files
rm *.o
rm *.out

echo "Assemble the source file faraday.asm"
nasm -f elf64 -l faraday.lis -o faraday.o faraday.asm

echo "Assemble the source file edison.asm"
nasm -f elf64 -l edison.lis -o edison.o edison.asm

echo "Assemble the source file syscall_fgets.asm"
nasm -f elf64 -l syscall_fgets.lis -o syscall_fgets.o syscall_fgets.asm

echo "Assemble the source file syscall_strlen.asm"
nasm -f elf64 -l syscall_strlen.lis -o syscall_strlen.o syscall_strlen.asm

echo "Assemble the source file input_array.asm"
nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm

echo "Assemble the source file isfloat.asm"
nasm -f elf64 -l isfloat.lis -o isfloat.o isfloat.asm

echo "Assemble the source file atof.asm"
nasm -f elf64 -l atof.lis -o atof.o atof.asm

echo "Assemble the source file tesla.asm"
nasm -f elf64 -l tesla.lis -o tesla.o tesla.asm

echo "Assemble the source file ftoa.asm"
nasm -f elf64 -l ftoa.lis -o ftoa.o ftoa.asm

echo "Link the object modules to create an executable file"
ld -o electricity.out faraday.o edison.o syscall_fgets.o syscall_strlen.o input_array.o isfloat.o atof.o tesla.o ftoa.o

echo "Execute the program"
chmod +x electricity.out
./electricity.out

echo "This bash script will now terminate."
