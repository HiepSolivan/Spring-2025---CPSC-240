#/bin/bash/

# Your name as author: Solivan Hiep
# Your section number: CPSC 240-3
# Today’s date: March 10, 2025
# Your preferred return email address: hiepsolivan@csu.fullerton.edu

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

echo "Assemble the source file sum_of_reciprocals.asm"
nasm -f elf64 -l sum_of_reciprocals.lis -o sum_of_reciprocals.o sum_of_reciprocals.asm

echo "Compile the source file main.cpp"
gcc  -m64 -Wall -no-pie -o main.o -std=c++20 -c main.cpp

echo "Link the object modules to create an executable file"
g++  -m64 -no-pie -o harmonic.out manager.o input_array.o isfloat.o output_array.o sum_of_reciprocals.o main.o -std=c++20 -Wall -z noexecstack -lm

echo "Execute the program"
chmod +x harmonic.out
./harmonic.out

echo "This bash script will now terminate."
