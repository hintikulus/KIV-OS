# The set of languages for which implicit dependencies are needed:
set(CMAKE_DEPENDS_LANGUAGES
  "ASM"
  "CXX"
  )
# The set of files for implicit dependencies of each language:
set(CMAKE_DEPENDS_CHECK_ASM
  "/home/hintik/dev/final/src/sources/kernel/src/interrupts.s" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/interrupts.s.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/memory/mmu.s" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/memory/mmu.s.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/process/spinlock.s" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/process/spinlock.s.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/process/switch.s" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/process/switch.s.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/start.s" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/start.s.obj"
  )
set(CMAKE_ASM_COMPILER_ID "GNU")

# Preprocessor definitions for this target.
set(CMAKE_TARGET_DEFINITIONS_ASM
  "RPI0"
  "RPI0=1"
  )

# The include file search paths:
set(CMAKE_ASM_TARGET_INCLUDE_PATH
  "../kernel/include"
  "../kernel/include/drivers"
  "../stdlib/include"
  "../stdutils/include"
  "../kernel/include/board/rpi0"
  )
set(CMAKE_DEPENDS_CHECK_CXX
  "/home/hintik/dev/final/src/sources/kernel/src/cxx.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/cxx.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/drivers/bcm_aux.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/drivers/bcm_aux.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/drivers/gpio.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/drivers/gpio.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/drivers/shiftregister.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/drivers/shiftregister.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/drivers/timer.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/drivers/timer.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/drivers/trng.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/drivers/trng.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/drivers/uart.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/drivers/uart.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/fs/filesystem.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/fs/filesystem.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/fs/filesystem_drivers.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/fs/filesystem_drivers.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/initsys.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/initsys.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/interrupt_controller.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/interrupt_controller.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/main.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/main.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/memory/kernel_heap.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/memory/kernel_heap.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/memory/mmu.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/memory/mmu.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/memory/pages.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/memory/pages.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/memory/pt_alloc.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/memory/pt_alloc.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/process/condvar.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/process/condvar.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/process/mutex.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/process/mutex.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/process/pipe.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/process/pipe.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/process/process_manager.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/process/process_manager.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/process/resource_manager.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/process/resource_manager.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/process/scheduler.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/process/scheduler.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/process/semaphore.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/process/semaphore.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/startup.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/startup.cpp.obj"
  "/home/hintik/dev/final/src/sources/kernel/src/test_processes.cpp" "/home/hintik/dev/final/src/sources/build/CMakeFiles/kernel.dir/kernel/src/test_processes.cpp.obj"
  )
set(CMAKE_CXX_COMPILER_ID "GNU")

# Preprocessor definitions for this target.
set(CMAKE_TARGET_DEFINITIONS_CXX
  "RPI0"
  "RPI0=1"
  )

# The include file search paths:
set(CMAKE_CXX_TARGET_INCLUDE_PATH
  "../kernel/include"
  "../kernel/include/drivers"
  "../stdlib/include"
  "../stdutils/include"
  "../kernel/include/board/rpi0"
  )

# Targets to which this target links.
set(CMAKE_TARGET_LINKED_INFO_FILES
  "/home/hintik/dev/final/src/sources/build/CMakeFiles/kivrtos_stdlib.dir/DependInfo.cmake"
  )

# Fortran module output directory.
set(CMAKE_Fortran_TARGET_MODULE_DIR "")
