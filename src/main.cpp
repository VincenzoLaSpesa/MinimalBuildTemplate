#include <fmt/printf.h>
#include <fmt/chrono.h>
#include <fmt/color.h>

int main() {
    using namespace std::literals::chrono_literals;
    fmt::print("Hello, world!\n");
    fmt::print("Default format: {} {}\n", 42s, 100ms);
    fmt::print("strftime-like format: {:%H:%M:%S}\n", 3h + 15min + 30s);
    fmt::print("The function below may fail on a non posix terminal\n");
    fmt::print(fg(fmt::color::crimson) | fmt::emphasis::underline, "Hello, {}!\n", "world");
    fmt::print(fg(fmt::color::yellow) | bg(fmt::color::blue) | fmt::emphasis::bold, "Hello, {}!\n", "миp");
    fmt::print(fg(fmt::color::steel_blue) | fmt::emphasis::italic, "Hello, {}!\n", "世界");
}