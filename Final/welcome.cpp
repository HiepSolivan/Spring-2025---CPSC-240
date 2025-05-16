//Your name : Solivan Hiep
//Your cwid : 884845876
//Your section number : 240 - 3
//Your email address : hiepsolivan @csu.fullerton.edu
//Today’s date : 4 / 23 / 2025
//Identifier : Final program.

#include <iostream>

extern "C" long manager();

int main()
{
  std::cout << "Welcome to getqwords test program developed by Solivan Hiep\n\n";
  long manager_caller = manager();

  std::cout << "The driver received " << manager_caller << '\n'
            << "A zero will be sent to the OS. Bye.\n";
  return 0;
}
