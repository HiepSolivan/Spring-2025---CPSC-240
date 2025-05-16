#/bin/bash/

# Your name as author: Solivan Hiep
# Your section number: CPSC 240-3
# Today’s date: March 10, 2025
# Your preferred return email address: hiepsolivan@csu.fullerton.edu

#Deletes unnecessary files
rm *.o
rm *.out

echo "Assemble the source file manager.asm"
nasm -f elf64 -gdwarf -l manager.lis -o manager.o manager.asm

echo "Compile the source file main.cpp"
gcc  -g -m64 -Wall -no-pie -o main.o -std=c++20 -c main.cpp

echo "Link the object modules to create an executable file"
g++  -g -m64 -no-pie -o compute_mean.out manager.o main.o -std=c++20 -Wall -z noexecstack -lm

echo "Debug the program"
chmod +x compute_mean.out
gdb ./compute_mean.out

echo "This bash script will now terminate."
