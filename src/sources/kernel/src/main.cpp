#include <drivers/gpio.h>
#include <drivers/uart.h>
#include <drivers/timer.h>

#include <interrupt_controller.h>

#include <memory/memmap.h>
#include <memory/kernel_heap.h>

#include <process/process_manager.h>

#include <fs/filesystem.h>

#include <stdstring.h>
#include <stdfile.h>

extern "C" void Timer_Callback()
{
	sProcessMgr.Schedule();
}

extern "C" unsigned char __init_task[];
extern "C" unsigned int __init_task_len;

extern "C" unsigned char __user_task[];
extern "C" unsigned int __user_task_len;

extern "C" int _kernel_main(void)
{
	// inicializace souboroveho systemu
	sFilesystem.Initialize();

	// vytvoreni hlavniho systemoveho (idle) procesu
	sProcessMgr.Create_Process(__init_task, __init_task_len, true);

	// vytvoreni vsech tasku
	sProcessMgr.Create_Process(__user_task, __user_task_len, false);

	// zatim zakazeme IRQ casovace
	sInterruptCtl.Disable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);

	// nastavime casovac - v callbacku se provadi planovani procesu
	sTimer.Enable(Timer_Callback, 0x80, NTimer_Prescaler::Prescaler_1);

	// povolime IRQ casovace
	sInterruptCtl.Enable_Basic_IRQ(hal::IRQ_Basic_Source::Timer);
	sInterruptCtl.Enable_IRQ(hal::IRQ_Source::AUX);
	sInterruptCtl.Enable_IRQ2(hal::IRQ_Source::UART);

	// povolime IRQ (nebudeme je maskovat) a od tohoto momentu je vse v rukou planovace
	sInterruptCtl.Set_Mask_IRQ(false);

	// vynutime prvni spusteni planovace
	sProcessMgr.Schedule();

	// tohle uz se mockrat nespusti - dalsi IRQ preplanuje procesor na nejaky z tasku (bud systemovy nebo uzivatelsky)
	while (true)
		;
	
	return 0;
}
