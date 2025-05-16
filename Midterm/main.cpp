// Your name as author: Solivan Hiep
// Your section number: CPSC 240-03
// Today’s date: March 10, 2025
// Your preferred return email address: hiepsolivan@csu.fullerton.edu

#include <iostream>

extern "C" double manager();

int main()
{
  std::cout << "Welcome to Computations by Solivan Hiep.\n";

  double manager_caller{ 0.0 };
  manager_caller = manager();

  std::cout << "The main function received this number " << manager_caller
            << " and will keep it for a while.\n"
            << "A zero will be returned to the OS. Bye reciprocal!\n";

  return 0;
}
