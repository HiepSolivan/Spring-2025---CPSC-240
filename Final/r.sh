#/bin/bash/

#Your name: Solivan Hiep
#Your cwid: 884845876
#Your section number: 240-3
#Your email address: hiepsolivan@csu.fullerton.edu
#Today’s date: 4/23/2025
#Identifier: Final program.

#Deletes unnecessary files
rm *.o
rm *.out

echo "Assemble the source file manager.asm"
nasm -f elf64 -l manager.lis -o manager.o manager.asm

echo "Assemble the source file getqword.asm"
nasm -f elf64 -l getqword.lis -o getqword.o getqword.asm

echo "Compile the source file welcome.cpp"
gcc  -m64 -Wall -no-pie -o welcome.o -std=c++20 -c welcome.cpp

echo "Link the object modules to create an executable file"
g++  -m64 -no-pie -o final.out manager.o getqword.o welcome.o -std=c++20 -Wall -z noexecstack -lm

echo "Execute the program"
chmod +x final.out
./final.out

echo "This bash script will now terminate."
