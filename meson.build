project('minimal_build_template', 'cpp')
src = ['./src/main.cpp']

# dependencies will be handled transparently by conan ( hopefully )
deps = [# i trust conan to install only one version, so i just accept anything from here
	dependency('fmt', version : '>=0.0.1'),
]

executable('FmtTest', src, dependencies: deps, install : true, install_dir : './output/', cpp_args : '-std=c++17')


# IMPORTANT: for making Mason+Conan work on windows you need to install pkgconfiglite and ninja
#		choco install meson ninja pkgconfiglite
#		pip install conan
# imho is safer to install meson with choco and conan with pip.
