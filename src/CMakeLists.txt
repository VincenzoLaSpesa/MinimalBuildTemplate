add_executable(FmtTest main.cpp)
set_target_properties(FmtTest PROPERTIES CXX_STANDARD 14 CXX_STANDARD_REQUIRED YES VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/bin/Debug")
target_link_libraries(FmtTest PRIVATE fmt::fmt)

target_compile_features(FmtTest PRIVATE cxx_std_14)

  install(
    TARGETS
    FmtTest
    RUNTIME DESTINATION ${PROJECT_INSTALL_DIR})