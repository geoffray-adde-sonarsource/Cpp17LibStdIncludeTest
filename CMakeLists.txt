cmake_minimum_required (VERSION 2.8.11)
project (cpp17-include-test)

file(GLOB_RECURSE CPP_SOURCES CONFIGURE_DEPENDS *.cpp)

source_group(TREE "${CMAKE_CURRENT_SOURCE_DIR}" PREFIX "Source Files" FILES ${CORE_SOURCES})

add_library (testLib ${CPP_SOURCES})

function(append value)
  foreach(variable ${ARGN})
    set(${variable} "${${variable}} ${value}" PARENT_SCOPE)
  endforeach(variable)
endfunction()

if(MSVC)
  append("/std:c++20 /D_SILENCE_CXX17_ITERATOR_BASE_CLASS_DEPRECATION_WARNING" CMAKE_CXX_FLAGS)

  string(REGEX REPLACE "(^| ) */EH[-cs]+ *( |$)" "\\1 \\2" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  append("/EHs-c- /D_HAS_EXCEPTIONS=0" CMAKE_CXX_FLAGS)

  string(REGEX REPLACE "(^| ) */GR-? *( |$)" "\\1 \\2" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  append("/GR-" CMAKE_CXX_FLAGS)

  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MTd")

  string(REGEX REPLACE " /W[0-4]" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  append("/W4" CMAKE_CXX_FLAGS)
  add_compile_options(
    -wd4141 # Suppress "'modifier' : used more than once"
    -wd4146 # Suppress "unary minus operator applied to unsigned type, result still unsigned"
    -wd4244 # Suppress "conversion from 'type1' to 'type2', possible loss of data"
    -wd4291 # Suppress "'declaration' : no matching operator delete found; memory will not be freed if initialization throws an exception"
    -wd4267 # Suppress "conversion from 'size_t' to 'type', possible loss of data"
    -wd4624 # Suppress "'type' : destructor was implicitly defined as deleted"
    -wd4800 # Suppress "'type' : forcing value to bool 'true' or 'false' (performance warning)"

    -wd4100 # Suppress "'p': unreferenced formal parameter"
    -wd4127 # Suppress "conditional expression is constant"
    -wd4245 # Suppress "'conversion' : conversion from 'type1' to 'type2', signed/unsigned mismatch"
    -wd4324 # Suppress "'type': structure was padded due to alignment specifier"
    -wd4389 # Suppress "'operator': signed/unsigned mismatch"
    -wd4456 # Suppress "declaration of 'var' hides previous local declaration"
    -wd4458 # Suppress "declaration of 'var' hides class member"
    -wd4459 # Suppress "declaration of 'var' hides global declaration"
    -wd4702 # Suppress "unreachable code"
    -wd4706 # Suppress "assignment within conditional expression"
  )

  # Compile files in parallel when using MSBuild
  add_compile_options("/MP")
else()
  # Because of explicit compiler version check above
  # CMAKE_CXX_STANDARD doesn't bring benefits,
  # however requires update of minimum CMake version to 3.8
  append("--std=c++20" CMAKE_CXX_FLAGS)

  append("-fno-exceptions -fno-rtti -fPIC -fvisibility-inlines-hidden" CMAKE_CXX_FLAGS)

  if(NOT "${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
    if(ENABLE_COVERAGE)
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage")
      set(CMAKE_CXX_FLAGS_RELEASE "-O0 -DNDEBUG")
    endif()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-strict-aliasing")
  endif()

  append("-Wall" CMAKE_CXX_FLAGS)
  append("-Wextra -Wno-unused-parameter" CMAKE_CXX_FLAGS)
  append("-pedantic" CMAKE_CXX_FLAGS)
endif()

