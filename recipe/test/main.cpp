#include <date/tz.h>
#include <iostream>

int main() {
    if (date::locate_zone("CondaTest") == nullptr) {
        std::cout << "CondaTest zone not found, something is wrong with the patch\n";
        return 1;
    }
    return 0;
}
