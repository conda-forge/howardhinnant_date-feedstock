#include <date/tz.h>
#include <iostream>

int main() {
    auto const& tzdb = date::get_tzdb();
    if (tzdb.locate_zone("CondaTest") == nullptr) {
        std::cout << "CondaTest zone not found, something is wrong with the patch\n";
        return 1;
    }
    std::cout << "num zones: " << tzdb.zones.size() << "\n";
    return 0;
}
