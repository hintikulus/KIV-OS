# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.18

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Disable VCS-based implicit rules.
% : %,v


# Disable VCS-based implicit rules.
% : RCS/%


# Disable VCS-based implicit rules.
% : RCS/%,v


# Disable VCS-based implicit rules.
% : SCCS/s.%


# Disable VCS-based implicit rules.
% : s.%


.SUFFIXES: .hpux_make_needs_suffix_list


# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/hintik/dev/KIV-RTOS-master/sources/userspace

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/hintik/dev/KIV-RTOS-master/sources/userspace/build

# Include any dependencies generated for this target.
include CMakeFiles/logger_task.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/logger_task.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/logger_task.dir/flags.make

CMakeFiles/logger_task.dir/crt0.s.obj: CMakeFiles/logger_task.dir/flags.make
CMakeFiles/logger_task.dir/crt0.s.obj: ../crt0.s
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/hintik/dev/KIV-RTOS-master/sources/userspace/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building ASM object CMakeFiles/logger_task.dir/crt0.s.obj"
	/usr/bin/arm-none-eabi-gcc $(ASM_DEFINES) $(ASM_INCLUDES) $(ASM_FLAGS) -o CMakeFiles/logger_task.dir/crt0.s.obj -c /home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.s

CMakeFiles/logger_task.dir/crt0.c.obj: CMakeFiles/logger_task.dir/flags.make
CMakeFiles/logger_task.dir/crt0.c.obj: ../crt0.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/hintik/dev/KIV-RTOS-master/sources/userspace/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object CMakeFiles/logger_task.dir/crt0.c.obj"
	/usr/bin/arm-none-eabi-gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/logger_task.dir/crt0.c.obj -c /home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.c

CMakeFiles/logger_task.dir/crt0.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/logger_task.dir/crt0.c.i"
	/usr/bin/arm-none-eabi-gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.c > CMakeFiles/logger_task.dir/crt0.c.i

CMakeFiles/logger_task.dir/crt0.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/logger_task.dir/crt0.c.s"
	/usr/bin/arm-none-eabi-gcc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.c -o CMakeFiles/logger_task.dir/crt0.c.s

CMakeFiles/logger_task.dir/cxxabi.cpp.obj: CMakeFiles/logger_task.dir/flags.make
CMakeFiles/logger_task.dir/cxxabi.cpp.obj: ../cxxabi.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/hintik/dev/KIV-RTOS-master/sources/userspace/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object CMakeFiles/logger_task.dir/cxxabi.cpp.obj"
	/usr/bin/arm-none-eabi-g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/logger_task.dir/cxxabi.cpp.obj -c /home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp

CMakeFiles/logger_task.dir/cxxabi.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/logger_task.dir/cxxabi.cpp.i"
	/usr/bin/arm-none-eabi-g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp > CMakeFiles/logger_task.dir/cxxabi.cpp.i

CMakeFiles/logger_task.dir/cxxabi.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/logger_task.dir/cxxabi.cpp.s"
	/usr/bin/arm-none-eabi-g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp -o CMakeFiles/logger_task.dir/cxxabi.cpp.s

CMakeFiles/logger_task.dir/logger_task/main.cpp.obj: CMakeFiles/logger_task.dir/flags.make
CMakeFiles/logger_task.dir/logger_task/main.cpp.obj: ../logger_task/main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/hintik/dev/KIV-RTOS-master/sources/userspace/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object CMakeFiles/logger_task.dir/logger_task/main.cpp.obj"
	/usr/bin/arm-none-eabi-g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/logger_task.dir/logger_task/main.cpp.obj -c /home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp

CMakeFiles/logger_task.dir/logger_task/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/logger_task.dir/logger_task/main.cpp.i"
	/usr/bin/arm-none-eabi-g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp > CMakeFiles/logger_task.dir/logger_task/main.cpp.i

CMakeFiles/logger_task.dir/logger_task/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/logger_task.dir/logger_task/main.cpp.s"
	/usr/bin/arm-none-eabi-g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp -o CMakeFiles/logger_task.dir/logger_task/main.cpp.s

# Object files for target logger_task
logger_task_OBJECTS = \
"CMakeFiles/logger_task.dir/crt0.s.obj" \
"CMakeFiles/logger_task.dir/crt0.c.obj" \
"CMakeFiles/logger_task.dir/cxxabi.cpp.obj" \
"CMakeFiles/logger_task.dir/logger_task/main.cpp.obj"

# External object files for target logger_task
logger_task_EXTERNAL_OBJECTS =

logger_task: CMakeFiles/logger_task.dir/crt0.s.obj
logger_task: CMakeFiles/logger_task.dir/crt0.c.obj
logger_task: CMakeFiles/logger_task.dir/cxxabi.cpp.obj
logger_task: CMakeFiles/logger_task.dir/logger_task/main.cpp.obj
logger_task: CMakeFiles/logger_task.dir/build.make
logger_task: ../../build/libkivrtos_stdlib.a
logger_task: CMakeFiles/logger_task.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/hintik/dev/KIV-RTOS-master/sources/userspace/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Linking CXX executable logger_task"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/logger_task.dir/link.txt --verbose=$(VERBOSE)
	arm-none-eabi-objcopy ./logger_task -O binary ./logger_task.bin
	arm-none-eabi-objdump -l -S -D ./logger_task > ./logger_task.asm
	xxd -i ./logger_task > ./src_logger_task.h

# Rule to build all files generated by this target.
CMakeFiles/logger_task.dir/build: logger_task

.PHONY : CMakeFiles/logger_task.dir/build

CMakeFiles/logger_task.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/logger_task.dir/cmake_clean.cmake
.PHONY : CMakeFiles/logger_task.dir/clean

CMakeFiles/logger_task.dir/depend:
	cd /home/hintik/dev/KIV-RTOS-master/sources/userspace/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/hintik/dev/KIV-RTOS-master/sources/userspace /home/hintik/dev/KIV-RTOS-master/sources/userspace /home/hintik/dev/KIV-RTOS-master/sources/userspace/build /home/hintik/dev/KIV-RTOS-master/sources/userspace/build /home/hintik/dev/KIV-RTOS-master/sources/userspace/build/CMakeFiles/logger_task.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/logger_task.dir/depend

