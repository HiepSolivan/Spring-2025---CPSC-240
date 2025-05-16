#/bin/bash/

#Program Name: Triangles
#Author: Solivan Hiep
#Author Email: hiepsolivan@csu.fullerton.edu
#CWID: 884845876
#Class: CPSC 240-03 - Class Nbr 13604

#Deletes unnecessary files
rm *.o
rm *.out

echo "Assemble the source file triangle.asm"
nasm -f elf64 -l triangle.lis -o triangle.o triangle.asm

echo "Compile the source file geometry.c"
gcc  -m64 -Wall -no-pie -o geometry.o -std=c2x -c geometry.c

echo "Link the object modules to create an executable file"
g++ -m64 -no-pie -o length.out triangle.o geometry.o -std=c++20 -Wall -z noexecstack

echo "Execute the program"
chmod +x length.out
./length.out

echo "This bash script will now terminate."
