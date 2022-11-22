
./tilt_task:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.s:10
;@ startovaci symbol - vstupni bod z jadra OS do uzivatelskeho programu
;@ v podstate jen ihned zavola nejakou C funkci, nepotrebujeme nic tak kritickeho, abychom to vsechno museli psal v ASM
;@ jen _start vlastne ani neni funkce, takze by tento vstupni bod mel byt psany takto; rovnez je treba se ujistit, ze
;@ je tento symbol relokovany spravne na 0x8000 (tam OS ocekava, ze se nachazi vstupni bod)
_start:
    bl __crt0_run
    8000:	eb000019 	bl	806c <__crt0_run>

00008004 <_hang>:
_hang():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.s:13
    ;@ z funkce __crt0_run by se nemel proces uz vratit, ale kdyby neco, tak se zacyklime
_hang:
    b _hang
    8004:	eafffffe 	b	8004 <_hang>

00008008 <__crt0_init_bss>:
__crt0_init_bss():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.c:10

extern unsigned int __bss_start;
extern unsigned int __bss_end;

void __crt0_init_bss()
{
    8008:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    800c:	e28db000 	add	fp, sp, #0
    8010:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.c:11
    unsigned int* begin = (unsigned int*)__bss_start;
    8014:	e59f3048 	ldr	r3, [pc, #72]	; 8064 <__crt0_init_bss+0x5c>
    8018:	e5933000 	ldr	r3, [r3]
    801c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.c:12
    for (; begin < (unsigned int*)__bss_end; begin++)
    8020:	ea000005 	b	803c <__crt0_init_bss+0x34>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.c:13 (discriminator 2)
        *begin = 0;
    8024:	e51b3008 	ldr	r3, [fp, #-8]
    8028:	e3a02000 	mov	r2, #0
    802c:	e5832000 	str	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.c:12 (discriminator 2)
    for (; begin < (unsigned int*)__bss_end; begin++)
    8030:	e51b3008 	ldr	r3, [fp, #-8]
    8034:	e2833004 	add	r3, r3, #4
    8038:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.c:12 (discriminator 1)
    803c:	e59f3024 	ldr	r3, [pc, #36]	; 8068 <__crt0_init_bss+0x60>
    8040:	e5933000 	ldr	r3, [r3]
    8044:	e1a02003 	mov	r2, r3
    8048:	e51b3008 	ldr	r3, [fp, #-8]
    804c:	e1530002 	cmp	r3, r2
    8050:	3afffff3 	bcc	8024 <__crt0_init_bss+0x1c>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.c:14
}
    8054:	e320f000 	nop	{0}
    8058:	e28bd000 	add	sp, fp, #0
    805c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8060:	e12fff1e 	bx	lr
    8064:	00008f04 	andeq	r8, r0, r4, lsl #30
    8068:	00008f14 	andeq	r8, r0, r4, lsl pc

0000806c <__crt0_run>:
__crt0_run():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.c:17

void __crt0_run()
{
    806c:	e92d4800 	push	{fp, lr}
    8070:	e28db004 	add	fp, sp, #4
    8074:	e24dd008 	sub	sp, sp, #8
/home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.c:19
    // inicializace .bss sekce (vynulovani)
    __crt0_init_bss();
    8078:	ebffffe2 	bl	8008 <__crt0_init_bss>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.c:22

    // volani konstruktoru globalnich trid (C++)
    _cpp_startup();
    807c:	eb000040 	bl	8184 <_cpp_startup>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.c:27

    // volani funkce main
    // nebudeme se zde zabyvat predavanim parametru do funkce main
    // jinak by se mohly predavat napr. namapovane do virtualniho adr. prostoru a odkazem pres zasobnik (kam nam muze OS pushnout co chce)
    int result = main(0, 0);
    8080:	e3a01000 	mov	r1, #0
    8084:	e3a00000 	mov	r0, #0
    8088:	eb000069 	bl	8234 <main>
    808c:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.c:30

    // volani destruktoru globalnich trid (C++)
    _cpp_shutdown();
    8090:	eb000051 	bl	81dc <_cpp_shutdown>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.c:33

    // volani terminate() syscallu s navratovym kodem funkce main
    asm volatile("mov r0, %0" : : "r" (result));
    8094:	e51b3008 	ldr	r3, [fp, #-8]
    8098:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.c:34
    asm volatile("svc #1");
    809c:	ef000001 	svc	0x00000001
/home/hintik/dev/KIV-RTOS-master/sources/userspace/crt0.c:35
}
    80a0:	e320f000 	nop	{0}
    80a4:	e24bd004 	sub	sp, fp, #4
    80a8:	e8bd8800 	pop	{fp, pc}

000080ac <__cxa_guard_acquire>:
__cxa_guard_acquire():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:11
	extern "C" int __cxa_guard_acquire (__guard *);
	extern "C" void __cxa_guard_release (__guard *);
	extern "C" void __cxa_guard_abort (__guard *);

	extern "C" int __cxa_guard_acquire (__guard *g)
	{
    80ac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80b0:	e28db000 	add	fp, sp, #0
    80b4:	e24dd00c 	sub	sp, sp, #12
    80b8:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:12
		return !*(char *)(g);
    80bc:	e51b3008 	ldr	r3, [fp, #-8]
    80c0:	e5d33000 	ldrb	r3, [r3]
    80c4:	e3530000 	cmp	r3, #0
    80c8:	03a03001 	moveq	r3, #1
    80cc:	13a03000 	movne	r3, #0
    80d0:	e6ef3073 	uxtb	r3, r3
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:13
	}
    80d4:	e1a00003 	mov	r0, r3
    80d8:	e28bd000 	add	sp, fp, #0
    80dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80e0:	e12fff1e 	bx	lr

000080e4 <__cxa_guard_release>:
__cxa_guard_release():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:16

	extern "C" void __cxa_guard_release (__guard *g)
	{
    80e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80e8:	e28db000 	add	fp, sp, #0
    80ec:	e24dd00c 	sub	sp, sp, #12
    80f0:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:17
		*(char *)g = 1;
    80f4:	e51b3008 	ldr	r3, [fp, #-8]
    80f8:	e3a02001 	mov	r2, #1
    80fc:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:18
	}
    8100:	e320f000 	nop	{0}
    8104:	e28bd000 	add	sp, fp, #0
    8108:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    810c:	e12fff1e 	bx	lr

00008110 <__cxa_guard_abort>:
__cxa_guard_abort():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:21

	extern "C" void __cxa_guard_abort (__guard *)
	{
    8110:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8114:	e28db000 	add	fp, sp, #0
    8118:	e24dd00c 	sub	sp, sp, #12
    811c:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:23

	}
    8120:	e320f000 	nop	{0}
    8124:	e28bd000 	add	sp, fp, #0
    8128:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    812c:	e12fff1e 	bx	lr

00008130 <__dso_handle>:
__dso_handle():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:27
}

extern "C" void __dso_handle()
{
    8130:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8134:	e28db000 	add	fp, sp, #0
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:29
    // ignore dtors for now
}
    8138:	e320f000 	nop	{0}
    813c:	e28bd000 	add	sp, fp, #0
    8140:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8144:	e12fff1e 	bx	lr

00008148 <__cxa_atexit>:
__cxa_atexit():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:32

extern "C" void __cxa_atexit()
{
    8148:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    814c:	e28db000 	add	fp, sp, #0
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:34
    // ignore dtors for now
}
    8150:	e320f000 	nop	{0}
    8154:	e28bd000 	add	sp, fp, #0
    8158:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    815c:	e12fff1e 	bx	lr

00008160 <__cxa_pure_virtual>:
__cxa_pure_virtual():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:37

extern "C" void __cxa_pure_virtual()
{
    8160:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8164:	e28db000 	add	fp, sp, #0
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:39
    // pure virtual method called
}
    8168:	e320f000 	nop	{0}
    816c:	e28bd000 	add	sp, fp, #0
    8170:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8174:	e12fff1e 	bx	lr

00008178 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:42

extern "C" void __aeabi_unwind_cpp_pr1()
{
    8178:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    817c:	e28db000 	add	fp, sp, #0
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:43 (discriminator 1)
	while (true)
    8180:	eafffffe 	b	8180 <__aeabi_unwind_cpp_pr1+0x8>

00008184 <_cpp_startup>:
_cpp_startup():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:61
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _cpp_startup(void)
{
    8184:	e92d4800 	push	{fp, lr}
    8188:	e28db004 	add	fp, sp, #4
    818c:	e24dd008 	sub	sp, sp, #8
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:66
	ctor_ptr* fnptr;
	
	// zavolame konstruktory globalnich C++ trid
	// v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8190:	e59f303c 	ldr	r3, [pc, #60]	; 81d4 <_cpp_startup+0x50>
    8194:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:66 (discriminator 3)
    8198:	e51b3008 	ldr	r3, [fp, #-8]
    819c:	e59f2034 	ldr	r2, [pc, #52]	; 81d8 <_cpp_startup+0x54>
    81a0:	e1530002 	cmp	r3, r2
    81a4:	2a000006 	bcs	81c4 <_cpp_startup+0x40>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:67 (discriminator 2)
		(*fnptr)();
    81a8:	e51b3008 	ldr	r3, [fp, #-8]
    81ac:	e5933000 	ldr	r3, [r3]
    81b0:	e12fff33 	blx	r3
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:66 (discriminator 2)
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    81b4:	e51b3008 	ldr	r3, [fp, #-8]
    81b8:	e2833004 	add	r3, r3, #4
    81bc:	e50b3008 	str	r3, [fp, #-8]
    81c0:	eafffff4 	b	8198 <_cpp_startup+0x14>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:69
	
	return 0;
    81c4:	e3a03000 	mov	r3, #0
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:70
}
    81c8:	e1a00003 	mov	r0, r3
    81cc:	e24bd004 	sub	sp, fp, #4
    81d0:	e8bd8800 	pop	{fp, pc}
    81d4:	00008f01 	andeq	r8, r0, r1, lsl #30
    81d8:	00008f01 	andeq	r8, r0, r1, lsl #30

000081dc <_cpp_shutdown>:
_cpp_shutdown():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:73

extern "C" int _cpp_shutdown(void)
{
    81dc:	e92d4800 	push	{fp, lr}
    81e0:	e28db004 	add	fp, sp, #4
    81e4:	e24dd008 	sub	sp, sp, #8
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:77
	dtor_ptr* fnptr;
	
	// zavolame destruktory globalnich C++ trid
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    81e8:	e59f303c 	ldr	r3, [pc, #60]	; 822c <_cpp_shutdown+0x50>
    81ec:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:77 (discriminator 3)
    81f0:	e51b3008 	ldr	r3, [fp, #-8]
    81f4:	e59f2034 	ldr	r2, [pc, #52]	; 8230 <_cpp_shutdown+0x54>
    81f8:	e1530002 	cmp	r3, r2
    81fc:	2a000006 	bcs	821c <_cpp_shutdown+0x40>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:78 (discriminator 2)
		(*fnptr)();
    8200:	e51b3008 	ldr	r3, [fp, #-8]
    8204:	e5933000 	ldr	r3, [r3]
    8208:	e12fff33 	blx	r3
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:77 (discriminator 2)
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    820c:	e51b3008 	ldr	r3, [fp, #-8]
    8210:	e2833004 	add	r3, r3, #4
    8214:	e50b3008 	str	r3, [fp, #-8]
    8218:	eafffff4 	b	81f0 <_cpp_shutdown+0x14>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:80
	
	return 0;
    821c:	e3a03000 	mov	r3, #0
/home/hintik/dev/KIV-RTOS-master/sources/userspace/cxxabi.cpp:81
}
    8220:	e1a00003 	mov	r0, r3
    8224:	e24bd004 	sub	sp, fp, #4
    8228:	e8bd8800 	pop	{fp, pc}
    822c:	00008f01 	andeq	r8, r0, r1, lsl #30
    8230:	00008f01 	andeq	r8, r0, r1, lsl #30

00008234 <main>:
main():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/tilt_task/main.cpp:15
 * 
 * Ceka na vstup ze senzoru naklonu, a prehraje neco na buzzeru (PWM) dle naklonu
 **/

int main(int argc, char** argv)
{
    8234:	e92d4800 	push	{fp, lr}
    8238:	e28db004 	add	fp, sp, #4
    823c:	e24dd020 	sub	sp, sp, #32
    8240:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    8244:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
/home/hintik/dev/KIV-RTOS-master/sources/userspace/tilt_task/main.cpp:16
	char state = '0';
    8248:	e3a03030 	mov	r3, #48	; 0x30
    824c:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/hintik/dev/KIV-RTOS-master/sources/userspace/tilt_task/main.cpp:17
	char oldstate = '0';
    8250:	e3a03030 	mov	r3, #48	; 0x30
    8254:	e54b3005 	strb	r3, [fp, #-5]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/tilt_task/main.cpp:19

	uint32_t tiltsensor_file = open("DEV:gpio/23", NFile_Open_Mode::Read_Only);
    8258:	e3a01000 	mov	r1, #0
    825c:	e59f009c 	ldr	r0, [pc, #156]	; 8300 <main+0xcc>
    8260:	eb000047 	bl	8384 <_Z4openPKc15NFile_Open_Mode>
    8264:	e50b000c 	str	r0, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/tilt_task/main.cpp:27
	NGPIO_Interrupt_Type irtype;
	
	//irtype = NGPIO_Interrupt_Type::Rising_Edge;
	//ioctl(tiltsensor_file, NIOCtl_Operation::Enable_Event_Detection, &irtype);

	irtype = NGPIO_Interrupt_Type::Falling_Edge;
    8268:	e3a03001 	mov	r3, #1
    826c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/userspace/tilt_task/main.cpp:28
	ioctl(tiltsensor_file, NIOCtl_Operation::Enable_Event_Detection, &irtype);
    8270:	e24b3018 	sub	r3, fp, #24
    8274:	e1a02003 	mov	r2, r3
    8278:	e3a01002 	mov	r1, #2
    827c:	e51b000c 	ldr	r0, [fp, #-12]
    8280:	eb000083 	bl	8494 <_Z5ioctlj16NIOCtl_OperationPv>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/tilt_task/main.cpp:30

	uint32_t logpipe = pipe("log", 32);
    8284:	e3a01020 	mov	r1, #32
    8288:	e59f0074 	ldr	r0, [pc, #116]	; 8304 <main+0xd0>
    828c:	eb00010a 	bl	86bc <_Z4pipePKcj>
    8290:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/tilt_task/main.cpp:34

	while (true)
	{
		wait(tiltsensor_file, 0x800);
    8294:	e3e02001 	mvn	r2, #1
    8298:	e3a01b02 	mov	r1, #2048	; 0x800
    829c:	e51b000c 	ldr	r0, [fp, #-12]
    82a0:	eb0000a0 	bl	8528 <_Z4waitjjj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/tilt_task/main.cpp:39

		// "debounce" - tilt senzor bude chvili flappovat mezi vysokou a nizkou urovni
		//sleep(0x100, Deadline_Unchanged);

		read(tiltsensor_file, &state, 1);
    82a4:	e24b3011 	sub	r3, fp, #17
    82a8:	e3a02001 	mov	r2, #1
    82ac:	e1a01003 	mov	r1, r3
    82b0:	e51b000c 	ldr	r0, [fp, #-12]
    82b4:	eb000043 	bl	83c8 <_Z4readjPcj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/tilt_task/main.cpp:43

		//if (state != oldstate)
		{
			if (state == '0')
    82b8:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    82bc:	e3530030 	cmp	r3, #48	; 0x30
    82c0:	1a000004 	bne	82d8 <main+0xa4>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/tilt_task/main.cpp:45
			{
				write(logpipe, "Tilt UP", 7);
    82c4:	e3a02007 	mov	r2, #7
    82c8:	e59f1038 	ldr	r1, [pc, #56]	; 8308 <main+0xd4>
    82cc:	e51b0010 	ldr	r0, [fp, #-16]
    82d0:	eb000050 	bl	8418 <_Z5writejPKcj>
    82d4:	ea000003 	b	82e8 <main+0xb4>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/tilt_task/main.cpp:49
			}
			else
			{
				write(logpipe, "Tilt DOWN", 10);
    82d8:	e3a0200a 	mov	r2, #10
    82dc:	e59f1028 	ldr	r1, [pc, #40]	; 830c <main+0xd8>
    82e0:	e51b0010 	ldr	r0, [fp, #-16]
    82e4:	eb00004b 	bl	8418 <_Z5writejPKcj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/tilt_task/main.cpp:51
			}
			oldstate = state;
    82e8:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    82ec:	e54b3005 	strb	r3, [fp, #-5]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/tilt_task/main.cpp:54
		}

		sleep(0x1000, Indefinite/*0x100*/);
    82f0:	e3e01000 	mvn	r1, #0
    82f4:	e3a00a01 	mov	r0, #4096	; 0x1000
    82f8:	eb00009e 	bl	8578 <_Z5sleepjj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/tilt_task/main.cpp:34
		wait(tiltsensor_file, 0x800);
    82fc:	eaffffe4 	b	8294 <main+0x60>
    8300:	00008e94 	muleq	r0, r4, lr
    8304:	00008ea0 	andeq	r8, r0, r0, lsr #29
    8308:	00008ea4 	andeq	r8, r0, r4, lsr #29
    830c:	00008eac 	andeq	r8, r0, ip, lsr #29

00008310 <_Z6getpidv>:
_Z6getpidv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8310:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8314:	e28db000 	add	fp, sp, #0
    8318:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    831c:	ef000000 	svc	0x00000000
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8320:	e1a03000 	mov	r3, r0
    8324:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:11

    return pid;
    8328:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:12
}
    832c:	e1a00003 	mov	r0, r3
    8330:	e28bd000 	add	sp, fp, #0
    8334:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8338:	e12fff1e 	bx	lr

0000833c <_Z9terminatei>:
_Z9terminatei():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    833c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8340:	e28db000 	add	fp, sp, #0
    8344:	e24dd00c 	sub	sp, sp, #12
    8348:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    834c:	e51b3008 	ldr	r3, [fp, #-8]
    8350:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    8354:	ef000001 	svc	0x00000001
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:18
}
    8358:	e320f000 	nop	{0}
    835c:	e28bd000 	add	sp, fp, #0
    8360:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8364:	e12fff1e 	bx	lr

00008368 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    8368:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    836c:	e28db000 	add	fp, sp, #0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    8370:	ef000002 	svc	0x00000002
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:23
}
    8374:	e320f000 	nop	{0}
    8378:	e28bd000 	add	sp, fp, #0
    837c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8380:	e12fff1e 	bx	lr

00008384 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    8384:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8388:	e28db000 	add	fp, sp, #0
    838c:	e24dd014 	sub	sp, sp, #20
    8390:	e50b0010 	str	r0, [fp, #-16]
    8394:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    8398:	e51b3010 	ldr	r3, [fp, #-16]
    839c:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    83a0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83a4:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    83a8:	ef000040 	svc	0x00000040
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    83ac:	e1a03000 	mov	r3, r0
    83b0:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:34

    return file;
    83b4:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:35
}
    83b8:	e1a00003 	mov	r0, r3
    83bc:	e28bd000 	add	sp, fp, #0
    83c0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83c4:	e12fff1e 	bx	lr

000083c8 <_Z4readjPcj>:
_Z4readjPcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    83c8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83cc:	e28db000 	add	fp, sp, #0
    83d0:	e24dd01c 	sub	sp, sp, #28
    83d4:	e50b0010 	str	r0, [fp, #-16]
    83d8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    83dc:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    83e0:	e51b3010 	ldr	r3, [fp, #-16]
    83e4:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    83e8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83ec:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    83f0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83f4:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    83f8:	ef000041 	svc	0x00000041
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    83fc:	e1a03000 	mov	r3, r0
    8400:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    8404:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:48
}
    8408:	e1a00003 	mov	r0, r3
    840c:	e28bd000 	add	sp, fp, #0
    8410:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8414:	e12fff1e 	bx	lr

00008418 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    8418:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    841c:	e28db000 	add	fp, sp, #0
    8420:	e24dd01c 	sub	sp, sp, #28
    8424:	e50b0010 	str	r0, [fp, #-16]
    8428:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    842c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8430:	e51b3010 	ldr	r3, [fp, #-16]
    8434:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    8438:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    843c:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    8440:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8444:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    8448:	ef000042 	svc	0x00000042
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    844c:	e1a03000 	mov	r3, r0
    8450:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    8454:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:61
}
    8458:	e1a00003 	mov	r0, r3
    845c:	e28bd000 	add	sp, fp, #0
    8460:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8464:	e12fff1e 	bx	lr

00008468 <_Z5closej>:
_Z5closej():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    8468:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    846c:	e28db000 	add	fp, sp, #0
    8470:	e24dd00c 	sub	sp, sp, #12
    8474:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    8478:	e51b3008 	ldr	r3, [fp, #-8]
    847c:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    8480:	ef000043 	svc	0x00000043
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:67
}
    8484:	e320f000 	nop	{0}
    8488:	e28bd000 	add	sp, fp, #0
    848c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8490:	e12fff1e 	bx	lr

00008494 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    8494:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8498:	e28db000 	add	fp, sp, #0
    849c:	e24dd01c 	sub	sp, sp, #28
    84a0:	e50b0010 	str	r0, [fp, #-16]
    84a4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84a8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    84ac:	e51b3010 	ldr	r3, [fp, #-16]
    84b0:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    84b4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84b8:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    84bc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84c0:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    84c4:	ef000044 	svc	0x00000044
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    84c8:	e1a03000 	mov	r3, r0
    84cc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    84d0:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:80
}
    84d4:	e1a00003 	mov	r0, r3
    84d8:	e28bd000 	add	sp, fp, #0
    84dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84e0:	e12fff1e 	bx	lr

000084e4 <_Z6notifyjj>:
_Z6notifyjj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    84e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84e8:	e28db000 	add	fp, sp, #0
    84ec:	e24dd014 	sub	sp, sp, #20
    84f0:	e50b0010 	str	r0, [fp, #-16]
    84f4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    84f8:	e51b3010 	ldr	r3, [fp, #-16]
    84fc:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    8500:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8504:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    8508:	ef000045 	svc	0x00000045
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    850c:	e1a03000 	mov	r3, r0
    8510:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    8514:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:92
}
    8518:	e1a00003 	mov	r0, r3
    851c:	e28bd000 	add	sp, fp, #0
    8520:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8524:	e12fff1e 	bx	lr

00008528 <_Z4waitjjj>:
_Z4waitjjj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    8528:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    852c:	e28db000 	add	fp, sp, #0
    8530:	e24dd01c 	sub	sp, sp, #28
    8534:	e50b0010 	str	r0, [fp, #-16]
    8538:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    853c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8540:	e51b3010 	ldr	r3, [fp, #-16]
    8544:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    8548:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    854c:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    8550:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8554:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    8558:	ef000046 	svc	0x00000046
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    855c:	e1a03000 	mov	r3, r0
    8560:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    8564:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:105
}
    8568:	e1a00003 	mov	r0, r3
    856c:	e28bd000 	add	sp, fp, #0
    8570:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8574:	e12fff1e 	bx	lr

00008578 <_Z5sleepjj>:
_Z5sleepjj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    8578:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    857c:	e28db000 	add	fp, sp, #0
    8580:	e24dd014 	sub	sp, sp, #20
    8584:	e50b0010 	str	r0, [fp, #-16]
    8588:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    858c:	e51b3010 	ldr	r3, [fp, #-16]
    8590:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    8594:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8598:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    859c:	ef000003 	svc	0x00000003
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    85a0:	e1a03000 	mov	r3, r0
    85a4:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    85a8:	e51b3008 	ldr	r3, [fp, #-8]
    85ac:	e3530000 	cmp	r3, #0
    85b0:	13a03001 	movne	r3, #1
    85b4:	03a03000 	moveq	r3, #0
    85b8:	e6ef3073 	uxtb	r3, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:117
}
    85bc:	e1a00003 	mov	r0, r3
    85c0:	e28bd000 	add	sp, fp, #0
    85c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85c8:	e12fff1e 	bx	lr

000085cc <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    85cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85d0:	e28db000 	add	fp, sp, #0
    85d4:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    85d8:	e3a03000 	mov	r3, #0
    85dc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    85e0:	e3a03000 	mov	r3, #0
    85e4:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    85e8:	e24b300c 	sub	r3, fp, #12
    85ec:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    85f0:	ef000004 	svc	0x00000004
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:128

    return retval;
    85f4:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:129
}
    85f8:	e1a00003 	mov	r0, r3
    85fc:	e28bd000 	add	sp, fp, #0
    8600:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8604:	e12fff1e 	bx	lr

00008608 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    8608:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    860c:	e28db000 	add	fp, sp, #0
    8610:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    8614:	e3a03001 	mov	r3, #1
    8618:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    861c:	e3a03001 	mov	r3, #1
    8620:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    8624:	e24b300c 	sub	r3, fp, #12
    8628:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    862c:	ef000004 	svc	0x00000004
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:140

    return retval;
    8630:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:141
}
    8634:	e1a00003 	mov	r0, r3
    8638:	e28bd000 	add	sp, fp, #0
    863c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8640:	e12fff1e 	bx	lr

00008644 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    8644:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8648:	e28db000 	add	fp, sp, #0
    864c:	e24dd014 	sub	sp, sp, #20
    8650:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    8654:	e3a03000 	mov	r3, #0
    8658:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    865c:	e3a03000 	mov	r3, #0
    8660:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    8664:	e24b3010 	sub	r3, fp, #16
    8668:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    866c:	ef000005 	svc	0x00000005
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:150
}
    8670:	e320f000 	nop	{0}
    8674:	e28bd000 	add	sp, fp, #0
    8678:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    867c:	e12fff1e 	bx	lr

00008680 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    8680:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8684:	e28db000 	add	fp, sp, #0
    8688:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    868c:	e3a03001 	mov	r3, #1
    8690:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    8694:	e3a03001 	mov	r3, #1
    8698:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    869c:	e24b300c 	sub	r3, fp, #12
    86a0:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    86a4:	ef000005 	svc	0x00000005
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    86a8:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:162
}
    86ac:	e1a00003 	mov	r0, r3
    86b0:	e28bd000 	add	sp, fp, #0
    86b4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86b8:	e12fff1e 	bx	lr

000086bc <_Z4pipePKcj>:
_Z4pipePKcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    86bc:	e92d4800 	push	{fp, lr}
    86c0:	e28db004 	add	fp, sp, #4
    86c4:	e24dd050 	sub	sp, sp, #80	; 0x50
    86c8:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    86cc:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    86d0:	e24b3048 	sub	r3, fp, #72	; 0x48
    86d4:	e3a0200a 	mov	r2, #10
    86d8:	e59f108c 	ldr	r1, [pc, #140]	; 876c <_Z4pipePKcj+0xb0>
    86dc:	e1a00003 	mov	r0, r3
    86e0:	eb0000a6 	bl	8980 <_Z7strncpyPcPKci>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    86e4:	e24b3048 	sub	r3, fp, #72	; 0x48
    86e8:	e283300a 	add	r3, r3, #10
    86ec:	e3a02035 	mov	r2, #53	; 0x35
    86f0:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    86f4:	e1a00003 	mov	r0, r3
    86f8:	eb0000a0 	bl	8980 <_Z7strncpyPcPKci>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    86fc:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    8700:	eb0000f9 	bl	8aec <_Z6strlenPKc>
    8704:	e1a03000 	mov	r3, r0
    8708:	e283300a 	add	r3, r3, #10
    870c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    8710:	e51b3008 	ldr	r3, [fp, #-8]
    8714:	e2832001 	add	r2, r3, #1
    8718:	e50b2008 	str	r2, [fp, #-8]
    871c:	e24b2004 	sub	r2, fp, #4
    8720:	e0823003 	add	r3, r2, r3
    8724:	e3a02023 	mov	r2, #35	; 0x23
    8728:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    872c:	e24b2048 	sub	r2, fp, #72	; 0x48
    8730:	e51b3008 	ldr	r3, [fp, #-8]
    8734:	e0823003 	add	r3, r2, r3
    8738:	e3a0200a 	mov	r2, #10
    873c:	e1a01003 	mov	r1, r3
    8740:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    8744:	eb000009 	bl	8770 <_Z4itoajPcj>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    8748:	e24b3048 	sub	r3, fp, #72	; 0x48
    874c:	e3a01002 	mov	r1, #2
    8750:	e1a00003 	mov	r0, r3
    8754:	ebffff0a 	bl	8384 <_Z4openPKc15NFile_Open_Mode>
    8758:	e1a03000 	mov	r3, r0
    875c:	e320f000 	nop	{0}
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:179
}
    8760:	e1a00003 	mov	r0, r3
    8764:	e24bd004 	sub	sp, fp, #4
    8768:	e8bd8800 	pop	{fp, pc}
    876c:	00008ee4 	andeq	r8, r0, r4, ror #29

00008770 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    8770:	e92d4800 	push	{fp, lr}
    8774:	e28db004 	add	fp, sp, #4
    8778:	e24dd020 	sub	sp, sp, #32
    877c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8780:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8784:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:10
	int i = 0;
    8788:	e3a03000 	mov	r3, #0
    878c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:12

	while (input > 0)
    8790:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8794:	e3530000 	cmp	r3, #0
    8798:	0a000014 	beq	87f0 <_Z4itoajPcj+0x80>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    879c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    87a0:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    87a4:	e1a00003 	mov	r0, r3
    87a8:	eb000199 	bl	8e14 <__aeabi_uidivmod>
    87ac:	e1a03001 	mov	r3, r1
    87b0:	e1a01003 	mov	r1, r3
    87b4:	e51b3008 	ldr	r3, [fp, #-8]
    87b8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87bc:	e0823003 	add	r3, r2, r3
    87c0:	e59f2118 	ldr	r2, [pc, #280]	; 88e0 <_Z4itoajPcj+0x170>
    87c4:	e7d22001 	ldrb	r2, [r2, r1]
    87c8:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:15
		input /= base;
    87cc:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    87d0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    87d4:	eb000113 	bl	8c28 <__udivsi3>
    87d8:	e1a03000 	mov	r3, r0
    87dc:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:16
		i++;
    87e0:	e51b3008 	ldr	r3, [fp, #-8]
    87e4:	e2833001 	add	r3, r3, #1
    87e8:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:12
	while (input > 0)
    87ec:	eaffffe7 	b	8790 <_Z4itoajPcj+0x20>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    87f0:	e51b3008 	ldr	r3, [fp, #-8]
    87f4:	e3530000 	cmp	r3, #0
    87f8:	1a000007 	bne	881c <_Z4itoajPcj+0xac>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    87fc:	e51b3008 	ldr	r3, [fp, #-8]
    8800:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8804:	e0823003 	add	r3, r2, r3
    8808:	e3a02030 	mov	r2, #48	; 0x30
    880c:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:22
        i++;
    8810:	e51b3008 	ldr	r3, [fp, #-8]
    8814:	e2833001 	add	r3, r3, #1
    8818:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    881c:	e51b3008 	ldr	r3, [fp, #-8]
    8820:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8824:	e0823003 	add	r3, r2, r3
    8828:	e3a02000 	mov	r2, #0
    882c:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:26
	i--;
    8830:	e51b3008 	ldr	r3, [fp, #-8]
    8834:	e2433001 	sub	r3, r3, #1
    8838:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    883c:	e3a03000 	mov	r3, #0
    8840:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:28 (discriminator 3)
    8844:	e51b3008 	ldr	r3, [fp, #-8]
    8848:	e1a02fa3 	lsr	r2, r3, #31
    884c:	e0823003 	add	r3, r2, r3
    8850:	e1a030c3 	asr	r3, r3, #1
    8854:	e1a02003 	mov	r2, r3
    8858:	e51b300c 	ldr	r3, [fp, #-12]
    885c:	e1530002 	cmp	r3, r2
    8860:	ca00001b 	bgt	88d4 <_Z4itoajPcj+0x164>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    8864:	e51b2008 	ldr	r2, [fp, #-8]
    8868:	e51b300c 	ldr	r3, [fp, #-12]
    886c:	e0423003 	sub	r3, r2, r3
    8870:	e1a02003 	mov	r2, r3
    8874:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8878:	e0833002 	add	r3, r3, r2
    887c:	e5d33000 	ldrb	r3, [r3]
    8880:	e54b300d 	strb	r3, [fp, #-13]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    8884:	e51b300c 	ldr	r3, [fp, #-12]
    8888:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    888c:	e0822003 	add	r2, r2, r3
    8890:	e51b1008 	ldr	r1, [fp, #-8]
    8894:	e51b300c 	ldr	r3, [fp, #-12]
    8898:	e0413003 	sub	r3, r1, r3
    889c:	e1a01003 	mov	r1, r3
    88a0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    88a4:	e0833001 	add	r3, r3, r1
    88a8:	e5d22000 	ldrb	r2, [r2]
    88ac:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    88b0:	e51b300c 	ldr	r3, [fp, #-12]
    88b4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88b8:	e0823003 	add	r3, r2, r3
    88bc:	e55b200d 	ldrb	r2, [fp, #-13]
    88c0:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    88c4:	e51b300c 	ldr	r3, [fp, #-12]
    88c8:	e2833001 	add	r3, r3, #1
    88cc:	e50b300c 	str	r3, [fp, #-12]
    88d0:	eaffffdb 	b	8844 <_Z4itoajPcj+0xd4>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:34
	}
}
    88d4:	e320f000 	nop	{0}
    88d8:	e24bd004 	sub	sp, fp, #4
    88dc:	e8bd8800 	pop	{fp, pc}
    88e0:	00008ef0 	strdeq	r8, [r0], -r0

000088e4 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    88e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    88e8:	e28db000 	add	fp, sp, #0
    88ec:	e24dd014 	sub	sp, sp, #20
    88f0:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:38
	int output = 0;
    88f4:	e3a03000 	mov	r3, #0
    88f8:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    88fc:	e51b3010 	ldr	r3, [fp, #-16]
    8900:	e5d33000 	ldrb	r3, [r3]
    8904:	e3530000 	cmp	r3, #0
    8908:	0a000017 	beq	896c <_Z4atoiPKc+0x88>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    890c:	e51b2008 	ldr	r2, [fp, #-8]
    8910:	e1a03002 	mov	r3, r2
    8914:	e1a03103 	lsl	r3, r3, #2
    8918:	e0833002 	add	r3, r3, r2
    891c:	e1a03083 	lsl	r3, r3, #1
    8920:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    8924:	e51b3010 	ldr	r3, [fp, #-16]
    8928:	e5d33000 	ldrb	r3, [r3]
    892c:	e3530039 	cmp	r3, #57	; 0x39
    8930:	8a00000d 	bhi	896c <_Z4atoiPKc+0x88>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:43 (discriminator 1)
    8934:	e51b3010 	ldr	r3, [fp, #-16]
    8938:	e5d33000 	ldrb	r3, [r3]
    893c:	e353002f 	cmp	r3, #47	; 0x2f
    8940:	9a000009 	bls	896c <_Z4atoiPKc+0x88>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    8944:	e51b3010 	ldr	r3, [fp, #-16]
    8948:	e5d33000 	ldrb	r3, [r3]
    894c:	e2433030 	sub	r3, r3, #48	; 0x30
    8950:	e51b2008 	ldr	r2, [fp, #-8]
    8954:	e0823003 	add	r3, r2, r3
    8958:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:48

		input++;
    895c:	e51b3010 	ldr	r3, [fp, #-16]
    8960:	e2833001 	add	r3, r3, #1
    8964:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    8968:	eaffffe3 	b	88fc <_Z4atoiPKc+0x18>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:51
	}

	return output;
    896c:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:52
}
    8970:	e1a00003 	mov	r0, r3
    8974:	e28bd000 	add	sp, fp, #0
    8978:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    897c:	e12fff1e 	bx	lr

00008980 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    8980:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8984:	e28db000 	add	fp, sp, #0
    8988:	e24dd01c 	sub	sp, sp, #28
    898c:	e50b0010 	str	r0, [fp, #-16]
    8990:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8994:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8998:	e3a03000 	mov	r3, #0
    899c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58 (discriminator 4)
    89a0:	e51b2008 	ldr	r2, [fp, #-8]
    89a4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    89a8:	e1520003 	cmp	r2, r3
    89ac:	aa000011 	bge	89f8 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58 (discriminator 2)
    89b0:	e51b3008 	ldr	r3, [fp, #-8]
    89b4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    89b8:	e0823003 	add	r3, r2, r3
    89bc:	e5d33000 	ldrb	r3, [r3]
    89c0:	e3530000 	cmp	r3, #0
    89c4:	0a00000b 	beq	89f8 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    89c8:	e51b3008 	ldr	r3, [fp, #-8]
    89cc:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    89d0:	e0822003 	add	r2, r2, r3
    89d4:	e51b3008 	ldr	r3, [fp, #-8]
    89d8:	e51b1010 	ldr	r1, [fp, #-16]
    89dc:	e0813003 	add	r3, r1, r3
    89e0:	e5d22000 	ldrb	r2, [r2]
    89e4:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    89e8:	e51b3008 	ldr	r3, [fp, #-8]
    89ec:	e2833001 	add	r3, r3, #1
    89f0:	e50b3008 	str	r3, [fp, #-8]
    89f4:	eaffffe9 	b	89a0 <_Z7strncpyPcPKci+0x20>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    89f8:	e51b2008 	ldr	r2, [fp, #-8]
    89fc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a00:	e1520003 	cmp	r2, r3
    8a04:	aa000008 	bge	8a2c <_Z7strncpyPcPKci+0xac>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8a08:	e51b3008 	ldr	r3, [fp, #-8]
    8a0c:	e51b2010 	ldr	r2, [fp, #-16]
    8a10:	e0823003 	add	r3, r2, r3
    8a14:	e3a02000 	mov	r2, #0
    8a18:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8a1c:	e51b3008 	ldr	r3, [fp, #-8]
    8a20:	e2833001 	add	r3, r3, #1
    8a24:	e50b3008 	str	r3, [fp, #-8]
    8a28:	eafffff2 	b	89f8 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:63

   return dest;
    8a2c:	e51b3010 	ldr	r3, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:64
}
    8a30:	e1a00003 	mov	r0, r3
    8a34:	e28bd000 	add	sp, fp, #0
    8a38:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a3c:	e12fff1e 	bx	lr

00008a40 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    8a40:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a44:	e28db000 	add	fp, sp, #0
    8a48:	e24dd01c 	sub	sp, sp, #28
    8a4c:	e50b0010 	str	r0, [fp, #-16]
    8a50:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8a54:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    8a58:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a5c:	e2432001 	sub	r2, r3, #1
    8a60:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8a64:	e3530000 	cmp	r3, #0
    8a68:	c3a03001 	movgt	r3, #1
    8a6c:	d3a03000 	movle	r3, #0
    8a70:	e6ef3073 	uxtb	r3, r3
    8a74:	e3530000 	cmp	r3, #0
    8a78:	0a000016 	beq	8ad8 <_Z7strncmpPKcS0_i+0x98>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    8a7c:	e51b3010 	ldr	r3, [fp, #-16]
    8a80:	e2832001 	add	r2, r3, #1
    8a84:	e50b2010 	str	r2, [fp, #-16]
    8a88:	e5d33000 	ldrb	r3, [r3]
    8a8c:	e54b3005 	strb	r3, [fp, #-5]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    8a90:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8a94:	e2832001 	add	r2, r3, #1
    8a98:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8a9c:	e5d33000 	ldrb	r3, [r3]
    8aa0:	e54b3006 	strb	r3, [fp, #-6]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    8aa4:	e55b2005 	ldrb	r2, [fp, #-5]
    8aa8:	e55b3006 	ldrb	r3, [fp, #-6]
    8aac:	e1520003 	cmp	r2, r3
    8ab0:	0a000003 	beq	8ac4 <_Z7strncmpPKcS0_i+0x84>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    8ab4:	e55b2005 	ldrb	r2, [fp, #-5]
    8ab8:	e55b3006 	ldrb	r3, [fp, #-6]
    8abc:	e0423003 	sub	r3, r2, r3
    8ac0:	ea000005 	b	8adc <_Z7strncmpPKcS0_i+0x9c>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    8ac4:	e55b3005 	ldrb	r3, [fp, #-5]
    8ac8:	e3530000 	cmp	r3, #0
    8acc:	1affffe1 	bne	8a58 <_Z7strncmpPKcS0_i+0x18>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:76
        	return 0;
    8ad0:	e3a03000 	mov	r3, #0
    8ad4:	ea000000 	b	8adc <_Z7strncmpPKcS0_i+0x9c>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8ad8:	e3a03000 	mov	r3, #0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:80
}
    8adc:	e1a00003 	mov	r0, r3
    8ae0:	e28bd000 	add	sp, fp, #0
    8ae4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ae8:	e12fff1e 	bx	lr

00008aec <_Z6strlenPKc>:
_Z6strlenPKc():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8aec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8af0:	e28db000 	add	fp, sp, #0
    8af4:	e24dd014 	sub	sp, sp, #20
    8af8:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:84
	int i = 0;
    8afc:	e3a03000 	mov	r3, #0
    8b00:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8b04:	e51b3008 	ldr	r3, [fp, #-8]
    8b08:	e51b2010 	ldr	r2, [fp, #-16]
    8b0c:	e0823003 	add	r3, r2, r3
    8b10:	e5d33000 	ldrb	r3, [r3]
    8b14:	e3530000 	cmp	r3, #0
    8b18:	0a000003 	beq	8b2c <_Z6strlenPKc+0x40>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:87
		i++;
    8b1c:	e51b3008 	ldr	r3, [fp, #-8]
    8b20:	e2833001 	add	r3, r3, #1
    8b24:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8b28:	eafffff5 	b	8b04 <_Z6strlenPKc+0x18>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:89

	return i;
    8b2c:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:90
}
    8b30:	e1a00003 	mov	r0, r3
    8b34:	e28bd000 	add	sp, fp, #0
    8b38:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b3c:	e12fff1e 	bx	lr

00008b40 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8b40:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b44:	e28db000 	add	fp, sp, #0
    8b48:	e24dd014 	sub	sp, sp, #20
    8b4c:	e50b0010 	str	r0, [fp, #-16]
    8b50:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8b54:	e51b3010 	ldr	r3, [fp, #-16]
    8b58:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8b5c:	e3a03000 	mov	r3, #0
    8b60:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8b64:	e51b2008 	ldr	r2, [fp, #-8]
    8b68:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8b6c:	e1520003 	cmp	r2, r3
    8b70:	aa000008 	bge	8b98 <_Z5bzeroPvi+0x58>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8b74:	e51b3008 	ldr	r3, [fp, #-8]
    8b78:	e51b200c 	ldr	r2, [fp, #-12]
    8b7c:	e0823003 	add	r3, r2, r3
    8b80:	e3a02000 	mov	r2, #0
    8b84:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8b88:	e51b3008 	ldr	r3, [fp, #-8]
    8b8c:	e2833001 	add	r3, r3, #1
    8b90:	e50b3008 	str	r3, [fp, #-8]
    8b94:	eafffff2 	b	8b64 <_Z5bzeroPvi+0x24>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:98
}
    8b98:	e320f000 	nop	{0}
    8b9c:	e28bd000 	add	sp, fp, #0
    8ba0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ba4:	e12fff1e 	bx	lr

00008ba8 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8ba8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8bac:	e28db000 	add	fp, sp, #0
    8bb0:	e24dd024 	sub	sp, sp, #36	; 0x24
    8bb4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8bb8:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8bbc:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8bc0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8bc4:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8bc8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8bcc:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8bd0:	e3a03000 	mov	r3, #0
    8bd4:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8bd8:	e51b2008 	ldr	r2, [fp, #-8]
    8bdc:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8be0:	e1520003 	cmp	r2, r3
    8be4:	aa00000b 	bge	8c18 <_Z6memcpyPKvPvi+0x70>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8be8:	e51b3008 	ldr	r3, [fp, #-8]
    8bec:	e51b200c 	ldr	r2, [fp, #-12]
    8bf0:	e0822003 	add	r2, r2, r3
    8bf4:	e51b3008 	ldr	r3, [fp, #-8]
    8bf8:	e51b1010 	ldr	r1, [fp, #-16]
    8bfc:	e0813003 	add	r3, r1, r3
    8c00:	e5d22000 	ldrb	r2, [r2]
    8c04:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8c08:	e51b3008 	ldr	r3, [fp, #-8]
    8c0c:	e2833001 	add	r3, r3, #1
    8c10:	e50b3008 	str	r3, [fp, #-8]
    8c14:	eaffffef 	b	8bd8 <_Z6memcpyPKvPvi+0x30>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:107
}
    8c18:	e320f000 	nop	{0}
    8c1c:	e28bd000 	add	sp, fp, #0
    8c20:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c24:	e12fff1e 	bx	lr

00008c28 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1150
    8c28:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1152
    8c2c:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1153
    8c30:	3a000074 	bcc	8e08 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1154
    8c34:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1155
    8c38:	9a00006b 	bls	8dec <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    8c3c:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    8c40:	0a00006c 	beq	8df8 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    8c44:	e16f3f10 	clz	r3, r0
    8c48:	e16f2f11 	clz	r2, r1
    8c4c:	e0423003 	sub	r3, r2, r3
    8c50:	e273301f 	rsbs	r3, r3, #31
    8c54:	10833083 	addne	r3, r3, r3, lsl #1
    8c58:	e3a02000 	mov	r2, #0
    8c5c:	108ff103 	addne	pc, pc, r3, lsl #2
    8c60:	e1a00000 	nop			; (mov r0, r0)
    8c64:	e1500f81 	cmp	r0, r1, lsl #31
    8c68:	e0a22002 	adc	r2, r2, r2
    8c6c:	20400f81 	subcs	r0, r0, r1, lsl #31
    8c70:	e1500f01 	cmp	r0, r1, lsl #30
    8c74:	e0a22002 	adc	r2, r2, r2
    8c78:	20400f01 	subcs	r0, r0, r1, lsl #30
    8c7c:	e1500e81 	cmp	r0, r1, lsl #29
    8c80:	e0a22002 	adc	r2, r2, r2
    8c84:	20400e81 	subcs	r0, r0, r1, lsl #29
    8c88:	e1500e01 	cmp	r0, r1, lsl #28
    8c8c:	e0a22002 	adc	r2, r2, r2
    8c90:	20400e01 	subcs	r0, r0, r1, lsl #28
    8c94:	e1500d81 	cmp	r0, r1, lsl #27
    8c98:	e0a22002 	adc	r2, r2, r2
    8c9c:	20400d81 	subcs	r0, r0, r1, lsl #27
    8ca0:	e1500d01 	cmp	r0, r1, lsl #26
    8ca4:	e0a22002 	adc	r2, r2, r2
    8ca8:	20400d01 	subcs	r0, r0, r1, lsl #26
    8cac:	e1500c81 	cmp	r0, r1, lsl #25
    8cb0:	e0a22002 	adc	r2, r2, r2
    8cb4:	20400c81 	subcs	r0, r0, r1, lsl #25
    8cb8:	e1500c01 	cmp	r0, r1, lsl #24
    8cbc:	e0a22002 	adc	r2, r2, r2
    8cc0:	20400c01 	subcs	r0, r0, r1, lsl #24
    8cc4:	e1500b81 	cmp	r0, r1, lsl #23
    8cc8:	e0a22002 	adc	r2, r2, r2
    8ccc:	20400b81 	subcs	r0, r0, r1, lsl #23
    8cd0:	e1500b01 	cmp	r0, r1, lsl #22
    8cd4:	e0a22002 	adc	r2, r2, r2
    8cd8:	20400b01 	subcs	r0, r0, r1, lsl #22
    8cdc:	e1500a81 	cmp	r0, r1, lsl #21
    8ce0:	e0a22002 	adc	r2, r2, r2
    8ce4:	20400a81 	subcs	r0, r0, r1, lsl #21
    8ce8:	e1500a01 	cmp	r0, r1, lsl #20
    8cec:	e0a22002 	adc	r2, r2, r2
    8cf0:	20400a01 	subcs	r0, r0, r1, lsl #20
    8cf4:	e1500981 	cmp	r0, r1, lsl #19
    8cf8:	e0a22002 	adc	r2, r2, r2
    8cfc:	20400981 	subcs	r0, r0, r1, lsl #19
    8d00:	e1500901 	cmp	r0, r1, lsl #18
    8d04:	e0a22002 	adc	r2, r2, r2
    8d08:	20400901 	subcs	r0, r0, r1, lsl #18
    8d0c:	e1500881 	cmp	r0, r1, lsl #17
    8d10:	e0a22002 	adc	r2, r2, r2
    8d14:	20400881 	subcs	r0, r0, r1, lsl #17
    8d18:	e1500801 	cmp	r0, r1, lsl #16
    8d1c:	e0a22002 	adc	r2, r2, r2
    8d20:	20400801 	subcs	r0, r0, r1, lsl #16
    8d24:	e1500781 	cmp	r0, r1, lsl #15
    8d28:	e0a22002 	adc	r2, r2, r2
    8d2c:	20400781 	subcs	r0, r0, r1, lsl #15
    8d30:	e1500701 	cmp	r0, r1, lsl #14
    8d34:	e0a22002 	adc	r2, r2, r2
    8d38:	20400701 	subcs	r0, r0, r1, lsl #14
    8d3c:	e1500681 	cmp	r0, r1, lsl #13
    8d40:	e0a22002 	adc	r2, r2, r2
    8d44:	20400681 	subcs	r0, r0, r1, lsl #13
    8d48:	e1500601 	cmp	r0, r1, lsl #12
    8d4c:	e0a22002 	adc	r2, r2, r2
    8d50:	20400601 	subcs	r0, r0, r1, lsl #12
    8d54:	e1500581 	cmp	r0, r1, lsl #11
    8d58:	e0a22002 	adc	r2, r2, r2
    8d5c:	20400581 	subcs	r0, r0, r1, lsl #11
    8d60:	e1500501 	cmp	r0, r1, lsl #10
    8d64:	e0a22002 	adc	r2, r2, r2
    8d68:	20400501 	subcs	r0, r0, r1, lsl #10
    8d6c:	e1500481 	cmp	r0, r1, lsl #9
    8d70:	e0a22002 	adc	r2, r2, r2
    8d74:	20400481 	subcs	r0, r0, r1, lsl #9
    8d78:	e1500401 	cmp	r0, r1, lsl #8
    8d7c:	e0a22002 	adc	r2, r2, r2
    8d80:	20400401 	subcs	r0, r0, r1, lsl #8
    8d84:	e1500381 	cmp	r0, r1, lsl #7
    8d88:	e0a22002 	adc	r2, r2, r2
    8d8c:	20400381 	subcs	r0, r0, r1, lsl #7
    8d90:	e1500301 	cmp	r0, r1, lsl #6
    8d94:	e0a22002 	adc	r2, r2, r2
    8d98:	20400301 	subcs	r0, r0, r1, lsl #6
    8d9c:	e1500281 	cmp	r0, r1, lsl #5
    8da0:	e0a22002 	adc	r2, r2, r2
    8da4:	20400281 	subcs	r0, r0, r1, lsl #5
    8da8:	e1500201 	cmp	r0, r1, lsl #4
    8dac:	e0a22002 	adc	r2, r2, r2
    8db0:	20400201 	subcs	r0, r0, r1, lsl #4
    8db4:	e1500181 	cmp	r0, r1, lsl #3
    8db8:	e0a22002 	adc	r2, r2, r2
    8dbc:	20400181 	subcs	r0, r0, r1, lsl #3
    8dc0:	e1500101 	cmp	r0, r1, lsl #2
    8dc4:	e0a22002 	adc	r2, r2, r2
    8dc8:	20400101 	subcs	r0, r0, r1, lsl #2
    8dcc:	e1500081 	cmp	r0, r1, lsl #1
    8dd0:	e0a22002 	adc	r2, r2, r2
    8dd4:	20400081 	subcs	r0, r0, r1, lsl #1
    8dd8:	e1500001 	cmp	r0, r1
    8ddc:	e0a22002 	adc	r2, r2, r2
    8de0:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    8de4:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    8de8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    8dec:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    8df0:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    8df4:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1169
    8df8:	e16f2f11 	clz	r2, r1
    8dfc:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1171
    8e00:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1172
    8e04:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1176
    8e08:	e3500000 	cmp	r0, #0
    8e0c:	13e00000 	mvnne	r0, #0
    8e10:	ea000007 	b	8e34 <__aeabi_idiv0>

00008e14 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1207
    8e14:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1208
    8e18:	0afffffa 	beq	8e08 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1209
    8e1c:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1210
    8e20:	ebffff80 	bl	8c28 <__udivsi3>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1211
    8e24:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1212
    8e28:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1213
    8e2c:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1214
    8e30:	e12fff1e 	bx	lr

00008e34 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1512
    8e34:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00008e38 <_ZL13Lock_Unlocked>:
    8e38:	00000000 	andeq	r0, r0, r0

00008e3c <_ZL11Lock_Locked>:
    8e3c:	00000001 	andeq	r0, r0, r1

00008e40 <_ZL21MaxFSDriverNameLength>:
    8e40:	00000010 	andeq	r0, r0, r0, lsl r0

00008e44 <_ZL17MaxFilenameLength>:
    8e44:	00000010 	andeq	r0, r0, r0, lsl r0

00008e48 <_ZL13MaxPathLength>:
    8e48:	00000080 	andeq	r0, r0, r0, lsl #1

00008e4c <_ZL18NoFilesystemDriver>:
    8e4c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008e50 <_ZL9NotifyAll>:
    8e50:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008e54 <_ZL24Max_Process_Opened_Files>:
    8e54:	00000010 	andeq	r0, r0, r0, lsl r0

00008e58 <_ZL10Indefinite>:
    8e58:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008e5c <_ZL18Deadline_Unchanged>:
    8e5c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008e60 <_ZL14Invalid_Handle>:
    8e60:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008e64 <_ZN3halL18Default_Clock_RateE>:
    8e64:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00008e68 <_ZN3halL15Peripheral_BaseE>:
    8e68:	20000000 	andcs	r0, r0, r0

00008e6c <_ZN3halL9GPIO_BaseE>:
    8e6c:	20200000 	eorcs	r0, r0, r0

00008e70 <_ZN3halL14GPIO_Pin_CountE>:
    8e70:	00000036 	andeq	r0, r0, r6, lsr r0

00008e74 <_ZN3halL8AUX_BaseE>:
    8e74:	20215000 	eorcs	r5, r1, r0

00008e78 <_ZN3halL25Interrupt_Controller_BaseE>:
    8e78:	2000b200 	andcs	fp, r0, r0, lsl #4

00008e7c <_ZN3halL10Timer_BaseE>:
    8e7c:	2000b400 	andcs	fp, r0, r0, lsl #8

00008e80 <_ZN3halL9TRNG_BaseE>:
    8e80:	20104000 	andscs	r4, r0, r0

00008e84 <_ZN3halL9BSC0_BaseE>:
    8e84:	20205000 	eorcs	r5, r0, r0

00008e88 <_ZN3halL9BSC1_BaseE>:
    8e88:	20804000 	addcs	r4, r0, r0

00008e8c <_ZN3halL9BSC2_BaseE>:
    8e8c:	20805000 	addcs	r5, r0, r0

00008e90 <_ZL11Invalid_Pin>:
    8e90:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    8e94:	3a564544 	bcc	159a3ac <__bss_end+0x1591498>
    8e98:	6f697067 	svcvs	0x00697067
    8e9c:	0033322f 	eorseq	r3, r3, pc, lsr #4
    8ea0:	00676f6c 	rsbeq	r6, r7, ip, ror #30
    8ea4:	746c6954 	strbtvc	r6, [ip], #-2388	; 0xfffff6ac
    8ea8:	00505520 	subseq	r5, r0, r0, lsr #10
    8eac:	746c6954 	strbtvc	r6, [ip], #-2388	; 0xfffff6ac
    8eb0:	574f4420 	strbpl	r4, [pc, -r0, lsr #8]
    8eb4:	0000004e 	andeq	r0, r0, lr, asr #32

00008eb8 <_ZL13Lock_Unlocked>:
    8eb8:	00000000 	andeq	r0, r0, r0

00008ebc <_ZL11Lock_Locked>:
    8ebc:	00000001 	andeq	r0, r0, r1

00008ec0 <_ZL21MaxFSDriverNameLength>:
    8ec0:	00000010 	andeq	r0, r0, r0, lsl r0

00008ec4 <_ZL17MaxFilenameLength>:
    8ec4:	00000010 	andeq	r0, r0, r0, lsl r0

00008ec8 <_ZL13MaxPathLength>:
    8ec8:	00000080 	andeq	r0, r0, r0, lsl #1

00008ecc <_ZL18NoFilesystemDriver>:
    8ecc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ed0 <_ZL9NotifyAll>:
    8ed0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ed4 <_ZL24Max_Process_Opened_Files>:
    8ed4:	00000010 	andeq	r0, r0, r0, lsl r0

00008ed8 <_ZL10Indefinite>:
    8ed8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008edc <_ZL18Deadline_Unchanged>:
    8edc:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008ee0 <_ZL14Invalid_Handle>:
    8ee0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ee4 <_ZL16Pipe_File_Prefix>:
    8ee4:	3a535953 	bcc	14df438 <__bss_end+0x14d6524>
    8ee8:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    8eec:	0000002f 	andeq	r0, r0, pc, lsr #32

00008ef0 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    8ef0:	33323130 	teqcc	r2, #48, 2
    8ef4:	37363534 			; <UNDEFINED> instruction: 0x37363534
    8ef8:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    8efc:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00008f04 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1684918>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x39510>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3d124>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c7e10>
   4:	35312820 	ldrcc	r2, [r1, #-2080]!	; 0xfffff7e0
   8:	322d383a 	eorcc	r3, sp, #3801088	; 0x3a0000
   c:	2d393130 	ldfcss	f3, [r9, #-192]!	; 0xffffff40
  10:	312d3371 			; <UNDEFINED> instruction: 0x312d3371
  14:	2931622b 	ldmdbcs	r1!, {r0, r1, r3, r5, r9, sp, lr}
  18:	332e3820 			; <UNDEFINED> instruction: 0x332e3820
  1c:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
  20:	30393130 	eorscc	r3, r9, r0, lsr r1
  24:	20333037 	eorscs	r3, r3, r7, lsr r0
  28:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
  2c:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
  30:	675b2029 	ldrbvs	r2, [fp, -r9, lsr #32]
  34:	382d6363 	stmdacc	sp!, {r0, r1, r5, r6, r8, r9, sp, lr}
  38:	6172622d 	cmnvs	r2, sp, lsr #4
  3c:	2068636e 	rsbcs	r6, r8, lr, ror #6
  40:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
  44:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
  48:	33373220 	teqcc	r7, #32, 4
  4c:	5d373230 	lfmpl	f3, 4, [r7, #-192]!	; 0xffffff40
	...

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	00000066 	andeq	r0, r0, r6, rrx
   4:	00500003 	subseq	r0, r0, r3
   8:	01020000 	mrseq	r0, (UNDEF: 2)
   c:	000d0efb 	strdeq	r0, [sp], -fp
  10:	01010101 	tsteq	r1, r1, lsl #2
  14:	01000000 	mrseq	r0, (UNDEF: 0)
  18:	2f010000 	svccs	0x00010000
  1c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
  20:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
  24:	2f6b6974 	svccs	0x006b6974
  28:	2f766564 	svccs	0x00766564
  2c:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
  30:	534f5452 	movtpl	r5, #62546	; 0xf452
  34:	73616d2d 	cmnvc	r1, #2880	; 0xb40
  38:	2f726574 	svccs	0x00726574
  3c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
  40:	2f736563 	svccs	0x00736563
  44:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
  48:	63617073 	cmnvs	r1, #115	; 0x73
  4c:	63000065 	movwvs	r0, #101	; 0x65
  50:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
  54:	00010073 	andeq	r0, r1, r3, ror r0
  58:	05000000 	streq	r0, [r0, #-0]
  5c:	00800002 	addeq	r0, r0, r2
  60:	01090300 	mrseq	r0, (UNDEF: 57)
  64:	00020231 	andeq	r0, r2, r1, lsr r2
  68:	009f0101 	addseq	r0, pc, r1, lsl #2
  6c:	00030000 	andeq	r0, r3, r0
  70:	00000050 	andeq	r0, r0, r0, asr r0
  74:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
  78:	0101000d 	tsteq	r1, sp
  7c:	00000101 	andeq	r0, r0, r1, lsl #2
  80:	00000100 	andeq	r0, r0, r0, lsl #2
  84:	6f682f01 	svcvs	0x00682f01
  88:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
  8c:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
  90:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
  94:	494b2f76 	stmdbmi	fp, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
  98:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
  9c:	6d2d534f 	stcvs	3, cr5, [sp, #-316]!	; 0xfffffec4
  a0:	65747361 	ldrbvs	r7, [r4, #-865]!	; 0xfffffc9f
  a4:	6f732f72 	svcvs	0x00732f72
  a8:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
  ac:	73752f73 	cmnvc	r5, #460	; 0x1cc
  b0:	70737265 	rsbsvc	r7, r3, r5, ror #4
  b4:	00656361 	rsbeq	r6, r5, r1, ror #6
  b8:	74726300 	ldrbtvc	r6, [r2], #-768	; 0xfffffd00
  bc:	00632e30 	rsbeq	r2, r3, r0, lsr lr
  c0:	00000001 	andeq	r0, r0, r1
  c4:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
  c8:	00800802 	addeq	r0, r0, r2, lsl #16
  cc:	01090300 	mrseq	r0, (UNDEF: 57)
  d0:	05671b05 	strbeq	r1, [r7, #-2821]!	; 0xfffff4fb
  d4:	05054a13 	streq	r4, [r5, #-2579]	; 0xfffff5ed
  d8:	0010052f 	andseq	r0, r0, pc, lsr #10
  dc:	2f020402 	svccs	0x00020402
  e0:	02003305 	andeq	r3, r0, #335544320	; 0x14000000
  e4:	05650204 	strbeq	r0, [r5, #-516]!	; 0xfffffdfc
  e8:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
  ec:	05056601 	streq	r6, [r5, #-1537]	; 0xfffff9ff
  f0:	01040200 	mrseq	r0, R12_usr
  f4:	68010566 	stmdavs	r1, {r1, r2, r5, r6, r8, sl}
  f8:	680505bd 	stmdavs	r5, {r0, r2, r3, r4, r5, r7, r8, sl}
  fc:	33120531 	tstcc	r2, #205520896	; 0xc400000
 100:	31850505 	orrcc	r0, r5, r5, lsl #10
 104:	2f01054b 	svccs	0x0001054b
 108:	01000602 	tsteq	r0, r2, lsl #12
 10c:	0000ee01 	andeq	lr, r0, r1, lsl #28
 110:	62000300 	andvs	r0, r0, #0, 6
 114:	02000000 	andeq	r0, r0, #0
 118:	0d0efb01 	vstreq	d15, [lr, #-4]
 11c:	01010100 	mrseq	r0, (UNDEF: 17)
 120:	00000001 	andeq	r0, r0, r1
 124:	01000001 	tsteq	r0, r1
 128:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 74 <shift+0x74>
 12c:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 130:	6b69746e 	blvs	1a5d2f0 <__bss_end+0x1a543dc>
 134:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
 138:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 13c:	4f54522d 	svcmi	0x0054522d
 140:	616d2d53 	cmnvs	sp, r3, asr sp
 144:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 148:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe21 <__bss_end+0xffff6f0d>
 14c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 150:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 154:	61707372 	cmnvs	r0, r2, ror r3
 158:	00006563 	andeq	r6, r0, r3, ror #10
 15c:	61787863 	cmnvs	r8, r3, ror #16
 160:	632e6962 			; <UNDEFINED> instruction: 0x632e6962
 164:	01007070 	tsteq	r0, r0, ror r0
 168:	623c0000 	eorsvs	r0, ip, #0
 16c:	746c6975 	strbtvc	r6, [ip], #-2421	; 0xfffff68b
 170:	3e6e692d 	vmulcc.f16	s13, s28, s27	; <UNPREDICTABLE>
 174:	00000000 	andeq	r0, r0, r0
 178:	00020500 	andeq	r0, r2, r0, lsl #10
 17c:	80ac0205 	adchi	r0, ip, r5, lsl #4
 180:	0a030000 	beq	c0188 <__bss_end+0xb7274>
 184:	830c0501 	movwhi	r0, #50433	; 0xc501
 188:	052e0b05 	streq	r0, [lr, #-2821]!	; 0xfffff4fb
 18c:	02052e0a 	andeq	r2, r5, #10, 28	; 0xa0
 190:	0e058583 	cfsh32eq	mvfx8, mvfx5, #-61
 194:	67020583 	strvs	r0, [r2, -r3, lsl #11]
 198:	01058485 	smlabbeq	r5, r5, r4, r8
 19c:	4c854c86 	stcmi	12, cr4, [r5], {134}	; 0x86
 1a0:	05854c85 	streq	r4, [r5, #3205]	; 0xc85
 1a4:	04020002 	streq	r0, [r2], #-2
 1a8:	01054b01 	tsteq	r5, r1, lsl #22
 1ac:	052e1203 	streq	r1, [lr, #-515]!	; 0xfffffdfd
 1b0:	24056b0d 	strcs	r6, [r5], #-2829	; 0xfffff4f3
 1b4:	03040200 	movweq	r0, #16896	; 0x4200
 1b8:	0004054a 	andeq	r0, r4, sl, asr #10
 1bc:	83020402 	movwhi	r0, #9218	; 0x2402
 1c0:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 1c4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 1c8:	04020002 	streq	r0, [r2], #-2
 1cc:	09052d02 	stmdbeq	r5, {r1, r8, sl, fp, sp}
 1d0:	2f010585 	svccs	0x00010585
 1d4:	6a0d05a1 	bvs	341860 <__bss_end+0x33894c>
 1d8:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
 1dc:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 1e0:	04020004 	streq	r0, [r2], #-4
 1e4:	0b058302 	bleq	160df4 <__bss_end+0x157ee0>
 1e8:	02040200 	andeq	r0, r4, #0, 4
 1ec:	0002054a 	andeq	r0, r2, sl, asr #10
 1f0:	2d020402 	cfstrscs	mvf0, [r2, #-8]
 1f4:	05850905 	streq	r0, [r5, #2309]	; 0x905
 1f8:	0a022f01 	beq	8be04 <__bss_end+0x82ef0>
 1fc:	42010100 	andmi	r0, r1, #0, 2
 200:	03000002 	movweq	r0, #2
 204:	00020200 	andeq	r0, r2, r0, lsl #4
 208:	fb010200 	blx	40a12 <__bss_end+0x37afe>
 20c:	01000d0e 	tsteq	r0, lr, lsl #26
 210:	00010101 	andeq	r0, r1, r1, lsl #2
 214:	00010000 	andeq	r0, r1, r0
 218:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 21c:	2f656d6f 	svccs	0x00656d6f
 220:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
 224:	642f6b69 	strtvs	r6, [pc], #-2921	; 22c <shift+0x22c>
 228:	4b2f7665 	blmi	bddbc4 <__bss_end+0xbd4cb0>
 22c:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 230:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
 234:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
 238:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
 23c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 240:	752f7365 	strvc	r7, [pc, #-869]!	; fffffee3 <__bss_end+0xffff6fcf>
 244:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 248:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 24c:	6c69742f 	cfstrdvs	mvd7, [r9], #-188	; 0xffffff44
 250:	61745f74 	cmnvs	r4, r4, ror pc
 254:	2f006b73 	svccs	0x00006b73
 258:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 25c:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 260:	2f6b6974 	svccs	0x006b6974
 264:	2f766564 	svccs	0x00766564
 268:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 26c:	534f5452 	movtpl	r5, #62546	; 0xf452
 270:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 274:	2f726574 	svccs	0x00726574
 278:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 27c:	2f736563 	svccs	0x00736563
 280:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 284:	63617073 	cmnvs	r1, #115	; 0x73
 288:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 28c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 290:	2f6c656e 	svccs	0x006c656e
 294:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 298:	2f656475 	svccs	0x00656475
 29c:	636f7270 	cmnvs	pc, #112, 4
 2a0:	00737365 	rsbseq	r7, r3, r5, ror #6
 2a4:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 1f0 <shift+0x1f0>
 2a8:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 2ac:	6b69746e 	blvs	1a5d46c <__bss_end+0x1a54558>
 2b0:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
 2b4:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 2b8:	4f54522d 	svcmi	0x0054522d
 2bc:	616d2d53 	cmnvs	sp, r3, asr sp
 2c0:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 2c4:	756f732f 	strbvc	r7, [pc, #-815]!	; ffffff9d <__bss_end+0xffff7089>
 2c8:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 2cc:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 2d0:	61707372 	cmnvs	r0, r2, ror r3
 2d4:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
 2d8:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
 2dc:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 2e0:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 2e4:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 2e8:	616f622f 	cmnvs	pc, pc, lsr #4
 2ec:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
 2f0:	2f306970 	svccs	0x00306970
 2f4:	006c6168 	rsbeq	r6, ip, r8, ror #2
 2f8:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 244 <shift+0x244>
 2fc:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 300:	6b69746e 	blvs	1a5d4c0 <__bss_end+0x1a545ac>
 304:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
 308:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 30c:	4f54522d 	svcmi	0x0054522d
 310:	616d2d53 	cmnvs	sp, r3, asr sp
 314:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 318:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffff1 <__bss_end+0xffff70dd>
 31c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 320:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 324:	61707372 	cmnvs	r0, r2, ror r3
 328:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
 32c:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
 330:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 334:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 338:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 33c:	0073662f 	rsbseq	r6, r3, pc, lsr #12
 340:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 28c <shift+0x28c>
 344:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 348:	6b69746e 	blvs	1a5d508 <__bss_end+0x1a545f4>
 34c:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
 350:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 354:	4f54522d 	svcmi	0x0054522d
 358:	616d2d53 	cmnvs	sp, r3, asr sp
 35c:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 360:	756f732f 	strbvc	r7, [pc, #-815]!	; 39 <shift+0x39>
 364:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 368:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 36c:	61707372 	cmnvs	r0, r2, ror r3
 370:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
 374:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
 378:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 37c:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 380:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 384:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
 388:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
 38c:	616d0000 	cmnvs	sp, r0
 390:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
 394:	01007070 	tsteq	r0, r0, ror r0
 398:	77730000 	ldrbvc	r0, [r3, -r0]!
 39c:	00682e69 	rsbeq	r2, r8, r9, ror #28
 3a0:	69000002 	stmdbvs	r0, {r1}
 3a4:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
 3a8:	00682e66 	rsbeq	r2, r8, r6, ror #28
 3ac:	73000003 	movwvc	r0, #3
 3b0:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
 3b4:	2e6b636f 	cdpcs	3, 6, cr6, cr11, cr15, {3}
 3b8:	00020068 	andeq	r0, r2, r8, rrx
 3bc:	6c696600 	stclvs	6, cr6, [r9], #-0
 3c0:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
 3c4:	2e6d6574 	mcrcs	5, 3, r6, cr13, cr4, {3}
 3c8:	00040068 	andeq	r0, r4, r8, rrx
 3cc:	6f727000 	svcvs	0x00727000
 3d0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 3d4:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 3d8:	72700000 	rsbsvc	r0, r0, #0
 3dc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 3e0:	616d5f73 	smcvs	54771	; 0xd5f3
 3e4:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
 3e8:	00682e72 	rsbeq	r2, r8, r2, ror lr
 3ec:	70000002 	andvc	r0, r0, r2
 3f0:	70697265 	rsbvc	r7, r9, r5, ror #4
 3f4:	61726568 	cmnvs	r2, r8, ror #10
 3f8:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
 3fc:	00000300 	andeq	r0, r0, r0, lsl #6
 400:	6f697067 	svcvs	0x00697067
 404:	0500682e 	streq	r6, [r0, #-2094]	; 0xfffff7d2
 408:	05000000 	streq	r0, [r0, #-0]
 40c:	02050001 	andeq	r0, r5, #1
 410:	00008234 	andeq	r8, r0, r4, lsr r2
 414:	05010e03 	streq	r0, [r1, #-3587]	; 0xfffff1fd
 418:	054b9f07 	strbeq	r9, [fp, #-3847]	; 0xfffff0f9
 41c:	09054c21 	stmdbeq	r5, {r0, r5, sl, fp, lr}
 420:	4b07058a 	blmi	1c1a50 <__bss_end+0x1b8b3c>
 424:	05a01905 	streq	r1, [r0, #2309]!	; 0x905
 428:	05878607 	streq	r8, [r7, #1543]	; 0x607
 42c:	0405a20e 	streq	sl, [r5], #-526	; 0xfffffdf2
 430:	4c0a052e 	cfstr32mi	mvfx0, [sl], {46}	; 0x2e
 434:	840d05a2 	strhi	r0, [sp], #-1442	; 0xfffffa5e
 438:	054d0805 	strbeq	r0, [sp, #-2053]	; 0xfffff7fb
 43c:	666c0307 	strbtvs	r0, [ip], -r7, lsl #6
 440:	01000a02 	tsteq	r0, r2, lsl #20
 444:	0002a301 	andeq	sl, r2, r1, lsl #6
 448:	6d000300 	stcvs	3, cr0, [r0, #-0]
 44c:	02000001 	andeq	r0, r0, #1
 450:	0d0efb01 	vstreq	d15, [lr, #-4]
 454:	01010100 	mrseq	r0, (UNDEF: 17)
 458:	00000001 	andeq	r0, r0, r1
 45c:	01000001 	tsteq	r0, r1
 460:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 3ac <shift+0x3ac>
 464:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 468:	6b69746e 	blvs	1a5d628 <__bss_end+0x1a54714>
 46c:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
 470:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 474:	4f54522d 	svcmi	0x0054522d
 478:	616d2d53 	cmnvs	sp, r3, asr sp
 47c:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 480:	756f732f 	strbvc	r7, [pc, #-815]!	; 159 <shift+0x159>
 484:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 488:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 48c:	2f62696c 	svccs	0x0062696c
 490:	00637273 	rsbeq	r7, r3, r3, ror r2
 494:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 3e0 <shift+0x3e0>
 498:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 49c:	6b69746e 	blvs	1a5d65c <__bss_end+0x1a54748>
 4a0:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
 4a4:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 4a8:	4f54522d 	svcmi	0x0054522d
 4ac:	616d2d53 	cmnvs	sp, r3, asr sp
 4b0:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 4b4:	756f732f 	strbvc	r7, [pc, #-815]!	; 18d <shift+0x18d>
 4b8:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 4bc:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 4c0:	2f6c656e 	svccs	0x006c656e
 4c4:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 4c8:	2f656475 	svccs	0x00656475
 4cc:	636f7270 	cmnvs	pc, #112, 4
 4d0:	00737365 	rsbseq	r7, r3, r5, ror #6
 4d4:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 420 <shift+0x420>
 4d8:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 4dc:	6b69746e 	blvs	1a5d69c <__bss_end+0x1a54788>
 4e0:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
 4e4:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 4e8:	4f54522d 	svcmi	0x0054522d
 4ec:	616d2d53 	cmnvs	sp, r3, asr sp
 4f0:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 4f4:	756f732f 	strbvc	r7, [pc, #-815]!	; 1cd <shift+0x1cd>
 4f8:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 4fc:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 500:	2f6c656e 	svccs	0x006c656e
 504:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 508:	2f656475 	svccs	0x00656475
 50c:	2f007366 	svccs	0x00007366
 510:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 514:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 518:	2f6b6974 	svccs	0x006b6974
 51c:	2f766564 	svccs	0x00766564
 520:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 524:	534f5452 	movtpl	r5, #62546	; 0xf452
 528:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 52c:	2f726574 	svccs	0x00726574
 530:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 534:	2f736563 	svccs	0x00736563
 538:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 53c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 540:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 544:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 548:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 54c:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 550:	61682f30 	cmnvs	r8, r0, lsr pc
 554:	7300006c 	movwvc	r0, #108	; 0x6c
 558:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
 55c:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
 560:	01007070 	tsteq	r0, r0, ror r0
 564:	77730000 	ldrbvc	r0, [r3, -r0]!
 568:	00682e69 	rsbeq	r2, r8, r9, ror #28
 56c:	73000002 	movwvc	r0, #2
 570:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
 574:	2e6b636f 	cdpcs	3, 6, cr6, cr11, cr15, {3}
 578:	00020068 	andeq	r0, r2, r8, rrx
 57c:	6c696600 	stclvs	6, cr6, [r9], #-0
 580:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
 584:	2e6d6574 	mcrcs	5, 3, r6, cr13, cr4, {3}
 588:	00030068 	andeq	r0, r3, r8, rrx
 58c:	6f727000 	svcvs	0x00727000
 590:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 594:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 598:	72700000 	rsbsvc	r0, r0, #0
 59c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 5a0:	616d5f73 	smcvs	54771	; 0xd5f3
 5a4:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
 5a8:	00682e72 	rsbeq	r2, r8, r2, ror lr
 5ac:	69000002 	stmdbvs	r0, {r1}
 5b0:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
 5b4:	00682e66 	rsbeq	r2, r8, r6, ror #28
 5b8:	00000004 	andeq	r0, r0, r4
 5bc:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 5c0:	00831002 	addeq	r1, r3, r2
 5c4:	1a051600 	bne	145dcc <__bss_end+0x13ceb8>
 5c8:	2f2c0569 	svccs	0x002c0569
 5cc:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 5d0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 5d4:	1a058332 	bne	1612a4 <__bss_end+0x158390>
 5d8:	2f01054b 	svccs	0x0001054b
 5dc:	4b1a0585 	blmi	681bf8 <__bss_end+0x678ce4>
 5e0:	852f0105 	strhi	r0, [pc, #-261]!	; 4e3 <shift+0x4e3>
 5e4:	05a13205 	streq	r3, [r1, #517]!	; 0x205
 5e8:	1b054b2e 	blne	1532a8 <__bss_end+0x14a394>
 5ec:	2f2d054b 	svccs	0x002d054b
 5f0:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 5f4:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 5f8:	3005bd2e 	andcc	fp, r5, lr, lsr #26
 5fc:	4b2e054b 	blmi	b81b30 <__bss_end+0xb78c1c>
 600:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 604:	0c052f2e 	stceq	15, cr2, [r5], {46}	; 0x2e
 608:	2f01054c 	svccs	0x0001054c
 60c:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 610:	054b3005 	strbeq	r3, [fp, #-5]
 614:	1b054b2e 	blne	1532d4 <__bss_end+0x14a3c0>
 618:	2f2e054b 	svccs	0x002e054b
 61c:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 620:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 624:	1b05832e 	blne	1612e4 <__bss_end+0x1583d0>
 628:	2f01054b 	svccs	0x0001054b
 62c:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 630:	054b3305 	strbeq	r3, [fp, #-773]	; 0xfffffcfb
 634:	1b054b2f 	blne	1532f8 <__bss_end+0x14a3e4>
 638:	2f30054b 	svccs	0x0030054b
 63c:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 640:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 644:	2f05a12e 	svccs	0x0005a12e
 648:	4b1b054b 	blmi	6c1b7c <__bss_end+0x6b8c68>
 64c:	052f2f05 	streq	r2, [pc, #-3845]!	; fffff74f <__bss_end+0xffff683b>
 650:	01054c0c 	tsteq	r5, ip, lsl #24
 654:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 658:	4b2f05bd 	blmi	bc1d54 <__bss_end+0xbb8e40>
 65c:	054b3b05 	strbeq	r3, [fp, #-2821]	; 0xfffff4fb
 660:	30054b1b 	andcc	r4, r5, fp, lsl fp
 664:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 668:	852f0105 	strhi	r0, [pc, #-261]!	; 56b <shift+0x56b>
 66c:	05a12f05 	streq	r2, [r1, #3845]!	; 0xf05
 670:	1a054b3b 	bne	153364 <__bss_end+0x14a450>
 674:	2f30054b 	svccs	0x0030054b
 678:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 67c:	05859f01 	streq	r9, [r5, #3841]	; 0xf01
 680:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
 684:	4b31054d 	blmi	c41bc0 <__bss_end+0xc38cac>
 688:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 68c:	0105300c 	tsteq	r5, ip
 690:	2005852f 	andcs	r8, r5, pc, lsr #10
 694:	4d2d0567 	cfstr32mi	mvfx0, [sp, #-412]!	; 0xfffffe64
 698:	054b3105 	strbeq	r3, [fp, #-261]	; 0xfffffefb
 69c:	0c054b1a 			; <UNDEFINED> instruction: 0x0c054b1a
 6a0:	2f010530 	svccs	0x00010530
 6a4:	83200585 			; <UNDEFINED> instruction: 0x83200585
 6a8:	054c2d05 	strbeq	r2, [ip, #-3333]	; 0xfffff2fb
 6ac:	1a054b3e 	bne	1533ac <__bss_end+0x14a498>
 6b0:	2f01054b 	svccs	0x0001054b
 6b4:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 6b8:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
 6bc:	1a054b30 	bne	153384 <__bss_end+0x14a470>
 6c0:	300c054b 	andcc	r0, ip, fp, asr #10
 6c4:	872f0105 	strhi	r0, [pc, -r5, lsl #2]!
 6c8:	9fa00c05 	svcls	0x00a00c05
 6cc:	05bc3105 	ldreq	r3, [ip, #261]!	; 0x105
 6d0:	36056629 	strcc	r6, [r5], -r9, lsr #12
 6d4:	300f052e 	andcc	r0, pc, lr, lsr #10
 6d8:	05661305 	strbeq	r1, [r6, #-773]!	; 0xfffffcfb
 6dc:	10058409 	andne	r8, r5, r9, lsl #8
 6e0:	9e3305d8 	mrcls	5, 1, r0, cr3, cr8, {6}
 6e4:	022f0105 	eoreq	r0, pc, #1073741825	; 0x40000001
 6e8:	01010008 	tsteq	r1, r8
 6ec:	00000232 	andeq	r0, r0, r2, lsr r2
 6f0:	00580003 	subseq	r0, r8, r3
 6f4:	01020000 	mrseq	r0, (UNDEF: 2)
 6f8:	000d0efb 	strdeq	r0, [sp], -fp
 6fc:	01010101 	tsteq	r1, r1, lsl #2
 700:	01000000 	mrseq	r0, (UNDEF: 0)
 704:	2f010000 	svccs	0x00010000
 708:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 70c:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 710:	2f6b6974 	svccs	0x006b6974
 714:	2f766564 	svccs	0x00766564
 718:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 71c:	534f5452 	movtpl	r5, #62546	; 0xf452
 720:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 724:	2f726574 	svccs	0x00726574
 728:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 72c:	2f736563 	svccs	0x00736563
 730:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
 734:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
 738:	00006372 	andeq	r6, r0, r2, ror r3
 73c:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
 740:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
 744:	70632e67 	rsbvc	r2, r3, r7, ror #28
 748:	00010070 	andeq	r0, r1, r0, ror r0
 74c:	01050000 	mrseq	r0, (UNDEF: 5)
 750:	70020500 	andvc	r0, r2, r0, lsl #10
 754:	1a000087 	bne	978 <shift+0x978>
 758:	05bb0605 	ldreq	r0, [fp, #1541]!	; 0x605
 75c:	21054c0f 	tstcs	r5, pc, lsl #24
 760:	ba0b0568 	blt	2c1d08 <__bss_end+0x2b8df4>
 764:	05662705 	strbeq	r2, [r6, #-1797]!	; 0xfffff8fb
 768:	09054a0d 	stmdbeq	r5, {r0, r2, r3, r9, fp, lr}
 76c:	9f04052f 	svcls	0x0004052f
 770:	05620205 	strbeq	r0, [r2, #-517]!	; 0xfffffdfb
 774:	11053505 	tstne	r5, r5, lsl #10
 778:	66220568 	strtvs	r0, [r2], -r8, ror #10
 77c:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
 780:	05692f0a 	strbeq	r2, [r9, #-3850]!	; 0xfffff0f6
 784:	0305660c 	movweq	r6, #22028	; 0x560c
 788:	680b054b 	stmdavs	fp, {r0, r1, r3, r6, r8, sl}
 78c:	02001805 	andeq	r1, r0, #327680	; 0x50000
 790:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 794:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 798:	15059e03 	strne	r9, [r5, #-3587]	; 0xfffff1fd
 79c:	02040200 	andeq	r0, r4, #0, 4
 7a0:	00180568 	andseq	r0, r8, r8, ror #10
 7a4:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 7a8:	02000805 	andeq	r0, r0, #327680	; 0x50000
 7ac:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 7b0:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
 7b4:	0c054b02 			; <UNDEFINED> instruction: 0x0c054b02
 7b8:	02040200 	andeq	r0, r4, #0, 4
 7bc:	000f0566 	andeq	r0, pc, r6, ror #10
 7c0:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 7c4:	02001b05 	andeq	r1, r0, #5120	; 0x1400
 7c8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 7cc:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 7d0:	0b052e02 	bleq	14bfe0 <__bss_end+0x1430cc>
 7d4:	02040200 	andeq	r0, r4, #0, 4
 7d8:	000d052f 	andeq	r0, sp, pc, lsr #10
 7dc:	66020402 	strvs	r0, [r2], -r2, lsl #8
 7e0:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 7e4:	05460204 	strbeq	r0, [r6, #-516]	; 0xfffffdfc
 7e8:	05858801 	streq	r8, [r5, #2049]	; 0x801
 7ec:	09058306 	stmdbeq	r5, {r1, r2, r8, r9, pc}
 7f0:	4a10054c 	bmi	401d28 <__bss_end+0x3f8e14>
 7f4:	054c0a05 	strbeq	r0, [ip, #-2565]	; 0xfffff5fb
 7f8:	0305bb07 	movweq	fp, #23303	; 0x5b07
 7fc:	0017054a 	andseq	r0, r7, sl, asr #10
 800:	4a010402 	bmi	41810 <__bss_end+0x388fc>
 804:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 808:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 80c:	14054d0d 	strne	r4, [r5], #-3341	; 0xfffff2f3
 810:	2e0a054a 	cfsh32cs	mvfx0, mvfx10, #42
 814:	05680805 	strbeq	r0, [r8, #-2053]!	; 0xfffff7fb
 818:	66780302 	ldrbtvs	r0, [r8], -r2, lsl #6
 81c:	0b030905 	bleq	c2c38 <__bss_end+0xb9d24>
 820:	2f01052e 	svccs	0x0001052e
 824:	bd090585 	cfstr32lt	mvfx0, [r9, #-532]	; 0xfffffdec
 828:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 82c:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
 830:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
 834:	16058202 	strne	r8, [r5], -r2, lsl #4
 838:	02040200 	andeq	r0, r4, #0, 4
 83c:	00120582 	andseq	r0, r2, r2, lsl #11
 840:	4b030402 	blmi	c1850 <__bss_end+0xb893c>
 844:	02000905 	andeq	r0, r0, #81920	; 0x14000
 848:	05660304 	strbeq	r0, [r6, #-772]!	; 0xfffffcfc
 84c:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 850:	0b056603 	bleq	15a064 <__bss_end+0x151150>
 854:	03040200 	movweq	r0, #16896	; 0x4200
 858:	0002052e 	andeq	r0, r2, lr, lsr #10
 85c:	2d030402 	cfstrscs	mvf0, [r3, #-8]
 860:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 864:	05840204 	streq	r0, [r4, #516]	; 0x204
 868:	04020009 	streq	r0, [r2], #-9
 86c:	0b058301 	bleq	161478 <__bss_end+0x158564>
 870:	01040200 	mrseq	r0, R12_usr
 874:	00020566 	andeq	r0, r2, r6, ror #10
 878:	49010402 	stmdbmi	r1, {r1, sl}
 87c:	05850b05 	streq	r0, [r5, #2821]	; 0xb05
 880:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 884:	1105bc0e 	tstne	r5, lr, lsl #24
 888:	bc200566 	cfstr32lt	mvfx0, [r0], #-408	; 0xfffffe68
 88c:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
 890:	0a054b1f 	beq	153514 <__bss_end+0x14a600>
 894:	4b080566 	blmi	201e34 <__bss_end+0x1f8f20>
 898:	05831405 	streq	r1, [r3, #1029]	; 0x405
 89c:	08054a16 	stmdaeq	r5, {r1, r2, r4, r9, fp, lr}
 8a0:	6711054b 	ldrvs	r0, [r1, -fp, asr #10]
 8a4:	054d0b05 	strbeq	r0, [sp, #-2821]	; 0xfffff4fb
 8a8:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 8ac:	0c058306 	stceq	3, cr8, [r5], {6}
 8b0:	820e054c 	andhi	r0, lr, #76, 10	; 0x13000000
 8b4:	054b0405 	strbeq	r0, [fp, #-1029]	; 0xfffffbfb
 8b8:	09056502 	stmdbeq	r5, {r1, r8, sl, sp, lr}
 8bc:	2f010531 	svccs	0x00010531
 8c0:	9f080585 	svcls	0x00080585
 8c4:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
 8c8:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 8cc:	08054a03 	stmdaeq	r5, {r0, r1, r9, fp, lr}
 8d0:	02040200 	andeq	r0, r4, #0, 4
 8d4:	000a0583 	andeq	r0, sl, r3, lsl #11
 8d8:	66020402 	strvs	r0, [r2], -r2, lsl #8
 8dc:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 8e0:	05490204 	strbeq	r0, [r9, #-516]	; 0xfffffdfc
 8e4:	05858401 	streq	r8, [r5, #1025]	; 0x401
 8e8:	0805bb0e 	stmdaeq	r5, {r1, r2, r3, r8, r9, fp, ip, sp, pc}
 8ec:	4c0b054b 	cfstr32mi	mvfx0, [fp], {75}	; 0x4b
 8f0:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 8f4:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 8f8:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 8fc:	0b058302 	bleq	16150c <__bss_end+0x1585f8>
 900:	02040200 	andeq	r0, r4, #0, 4
 904:	00170566 	andseq	r0, r7, r6, ror #10
 908:	66020402 	strvs	r0, [r2], -r2, lsl #8
 90c:	02000d05 	andeq	r0, r0, #320	; 0x140
 910:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 914:	04020002 	streq	r0, [r2], #-2
 918:	01052d02 	tsteq	r5, r2, lsl #26
 91c:	00080284 	andeq	r0, r8, r4, lsl #5
 920:	00790101 	rsbseq	r0, r9, r1, lsl #2
 924:	00030000 	andeq	r0, r3, r0
 928:	00000046 	andeq	r0, r0, r6, asr #32
 92c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 930:	0101000d 	tsteq	r1, sp
 934:	00000101 	andeq	r0, r0, r1, lsl #2
 938:	00000100 	andeq	r0, r0, r0, lsl #2
 93c:	2f2e2e01 	svccs	0x002e2e01
 940:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 944:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 948:	2f2e2e2f 	svccs	0x002e2e2f
 94c:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 89c <shift+0x89c>
 950:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 954:	6f632f63 	svcvs	0x00632f63
 958:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 95c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 960:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 964:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
 968:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
 96c:	00010053 	andeq	r0, r1, r3, asr r0
 970:	05000000 	streq	r0, [r0, #-0]
 974:	008c2802 	addeq	r2, ip, r2, lsl #16
 978:	08fd0300 	ldmeq	sp!, {r8, r9}^
 97c:	2f2f3001 	svccs	0x002f3001
 980:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
 984:	1401d002 	strne	sp, [r1], #-2
 988:	2f2f312f 	svccs	0x002f312f
 98c:	322f4c30 	eorcc	r4, pc, #48, 24	; 0x3000
 990:	2f661f03 	svccs	0x00661f03
 994:	2f2f2f2f 	svccs	0x002f2f2f
 998:	02022f2f 	andeq	r2, r2, #47, 30	; 0xbc
 99c:	5c010100 	stfpls	f0, [r1], {-0}
 9a0:	03000000 	movweq	r0, #0
 9a4:	00004600 	andeq	r4, r0, r0, lsl #12
 9a8:	fb010200 	blx	411b2 <__bss_end+0x3829e>
 9ac:	01000d0e 	tsteq	r0, lr, lsl #26
 9b0:	00010101 	andeq	r0, r1, r1, lsl #2
 9b4:	00010000 	andeq	r0, r1, r0
 9b8:	2e2e0100 	sufcse	f0, f6, f0
 9bc:	2f2e2e2f 	svccs	0x002e2e2f
 9c0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 9c4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 9c8:	2f2e2e2f 	svccs	0x002e2e2f
 9cc:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 9d0:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 9d4:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 9d8:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 9dc:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
 9e0:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
 9e4:	73636e75 	cmnvc	r3, #1872	; 0x750
 9e8:	0100532e 	tsteq	r0, lr, lsr #6
 9ec:	00000000 	andeq	r0, r0, r0
 9f0:	8e340205 	cdphi	2, 3, cr0, cr4, cr5, {0}
 9f4:	e7030000 	str	r0, [r3, -r0]
 9f8:	0202010b 	andeq	r0, r2, #-1073741822	; 0xc0000002
 9fc:	03010100 	movweq	r0, #4352	; 0x1100
 a00:	03000001 	movweq	r0, #1
 a04:	0000fd00 	andeq	pc, r0, r0, lsl #26
 a08:	fb010200 	blx	41212 <__bss_end+0x382fe>
 a0c:	01000d0e 	tsteq	r0, lr, lsl #26
 a10:	00010101 	andeq	r0, r1, r1, lsl #2
 a14:	00010000 	andeq	r0, r1, r0
 a18:	2e2e0100 	sufcse	f0, f6, f0
 a1c:	2f2e2e2f 	svccs	0x002e2e2f
 a20:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a24:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a28:	2f2e2e2f 	svccs	0x002e2e2f
 a2c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 a30:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
 a34:	6e692f2e 	cdpvs	15, 6, cr2, cr9, cr14, {1}
 a38:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 a3c:	2e2e0065 	cdpcs	0, 2, cr0, cr14, cr5, {3}
 a40:	2f2e2e2f 	svccs	0x002e2e2f
 a44:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a48:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a4c:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
 a50:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
 a54:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a58:	2f2e2e2f 	svccs	0x002e2e2f
 a5c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a60:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a64:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 a68:	2f636367 	svccs	0x00636367
 a6c:	672f2e2e 	strvs	r2, [pc, -lr, lsr #28]!
 a70:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 a74:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 a78:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 a7c:	2e2e006d 	cdpcs	0, 2, cr0, cr14, cr13, {3}
 a80:	2f2e2e2f 	svccs	0x002e2e2f
 a84:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a88:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a8c:	2f2e2e2f 	svccs	0x002e2e2f
 a90:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 a94:	00006363 	andeq	r6, r0, r3, ror #6
 a98:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
 a9c:	2e626174 	mcrcs	1, 3, r6, cr2, cr4, {3}
 aa0:	00010068 	andeq	r0, r1, r8, rrx
 aa4:	6d726100 	ldfvse	f6, [r2, #-0]
 aa8:	6173692d 	cmnvs	r3, sp, lsr #18
 aac:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 ab0:	72610000 	rsbvc	r0, r1, #0
 ab4:	70632d6d 	rsbvc	r2, r3, sp, ror #26
 ab8:	00682e75 	rsbeq	r2, r8, r5, ror lr
 abc:	69000002 	stmdbvs	r0, {r1}
 ac0:	2d6e736e 	stclcs	3, cr7, [lr, #-440]!	; 0xfffffe48
 ac4:	736e6f63 	cmnvc	lr, #396	; 0x18c
 ac8:	746e6174 	strbtvc	r6, [lr], #-372	; 0xfffffe8c
 acc:	00682e73 	rsbeq	r2, r8, r3, ror lr
 ad0:	61000002 	tstvs	r0, r2
 ad4:	682e6d72 	stmdavs	lr!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}
 ad8:	00000300 	andeq	r0, r0, r0, lsl #6
 adc:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 ae0:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
 ae4:	00040068 	andeq	r0, r4, r8, rrx
 ae8:	6c626700 	stclvs	7, cr6, [r2], #-0
 aec:	6f74632d 	svcvs	0x0074632d
 af0:	682e7372 	stmdavs	lr!, {r1, r4, r5, r6, r8, r9, ip, sp, lr}
 af4:	00000400 	andeq	r0, r0, r0, lsl #8
 af8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 afc:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
 b00:	00040063 	andeq	r0, r4, r3, rrx
	...

Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	00000022 	andeq	r0, r0, r2, lsr #32
       4:	00000002 	andeq	r0, r0, r2
       8:	01040000 	mrseq	r0, (UNDEF: 4)
       c:	00000000 	andeq	r0, r0, r0
      10:	00008000 	andeq	r8, r0, r0
      14:	00008008 	andeq	r8, r0, r8
      18:	00000000 	andeq	r0, r0, r0
      1c:	0000003a 	andeq	r0, r0, sl, lsr r0
      20:	00000073 	andeq	r0, r0, r3, ror r0
      24:	009a8001 	addseq	r8, sl, r1
      28:	00040000 	andeq	r0, r4, r0
      2c:	00000014 	andeq	r0, r0, r4, lsl r0
      30:	00dc0104 	sbcseq	r0, ip, r4, lsl #2
      34:	810c0000 	mrshi	r0, (UNDEF: 12)
      38:	3a000000 	bcc	40 <shift+0x40>
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	a4000080 	strge	r0, [r0], #-128	; 0xffffff80
      44:	6a000000 	bvs	4c <shift+0x4c>
      48:	02000000 	andeq	r0, r0, #0
      4c:	000001a0 	andeq	r0, r0, r0, lsr #3
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	1ccf0704 	stclne	7, cr0, [pc], {4}
      5c:	d2020000 	andle	r0, r2, #0
      60:	01000000 	mrseq	r0, (UNDEF: 0)
      64:	00311507 	eorseq	r1, r1, r7, lsl #10
      68:	b2040000 	andlt	r0, r4, #0
      6c:	01000001 	tsteq	r0, r1
      70:	806c0610 	rsbhi	r0, ip, r0, lsl r6
      74:	00400000 	subeq	r0, r0, r0
      78:	9c010000 	stcls	0, cr0, [r1], {-0}
      7c:	0000006a 	andeq	r0, r0, sl, rrx
      80:	0000cb05 	andeq	ip, r0, r5, lsl #22
      84:	091b0100 	ldmdbeq	fp, {r8}
      88:	0000006a 	andeq	r0, r0, sl, rrx
      8c:	00749102 	rsbseq	r9, r4, r2, lsl #2
      90:	69050406 	stmdbvs	r5, {r1, r2, sl}
      94:	0700746e 	streq	r7, [r0, -lr, ror #8]
      98:	000000bb 	strheq	r0, [r0], -fp
      9c:	08060901 	stmdaeq	r6, {r0, r8, fp}
      a0:	64000080 	strvs	r0, [r0], #-128	; 0xffffff80
      a4:	01000000 	mrseq	r0, (UNDEF: 0)
      a8:	0000979c 	muleq	r0, ip, r7
      ac:	01ac0500 			; <UNDEFINED> instruction: 0x01ac0500
      b0:	0b010000 	bleq	400b8 <__bss_end+0x371a4>
      b4:	00009713 	andeq	r9, r0, r3, lsl r7
      b8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
      bc:	31040800 	tstcc	r4, r0, lsl #16
      c0:	00000000 	andeq	r0, r0, r0
      c4:	00000202 	andeq	r0, r0, r2, lsl #4
      c8:	009f0004 	addseq	r0, pc, r4
      cc:	01040000 	mrseq	r0, (UNDEF: 4)
      d0:	00000265 	andeq	r0, r0, r5, ror #4
      d4:	0003a504 	andeq	sl, r3, r4, lsl #10
      d8:	00003a00 	andeq	r3, r0, r0, lsl #20
      dc:	0080ac00 	addeq	sl, r0, r0, lsl #24
      e0:	00018800 	andeq	r8, r1, r0, lsl #16
      e4:	00010d00 	andeq	r0, r1, r0, lsl #26
      e8:	03880200 	orreq	r0, r8, #0, 4
      ec:	2f010000 	svccs	0x00010000
      f0:	00003120 	andeq	r3, r0, r0, lsr #2
      f4:	37040300 	strcc	r0, [r4, -r0, lsl #6]
      f8:	04000000 	streq	r0, [r0], #-0
      fc:	00025c02 	andeq	r5, r2, r2, lsl #24
     100:	20300100 	eorscs	r0, r0, r0, lsl #2
     104:	00000031 	andeq	r0, r0, r1, lsr r0
     108:	00002505 	andeq	r2, r0, r5, lsl #10
     10c:	00005700 	andeq	r5, r0, r0, lsl #14
     110:	00570600 	subseq	r0, r7, r0, lsl #12
     114:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
     118:	0700ffff 			; <UNDEFINED> instruction: 0x0700ffff
     11c:	1ccf0704 	stclne	7, cr0, [pc], {4}
     120:	7a080000 	bvc	200128 <__bss_end+0x1f7214>
     124:	01000003 	tsteq	r0, r3
     128:	00441533 	subeq	r1, r4, r3, lsr r5
     12c:	22080000 	andcs	r0, r8, #0
     130:	01000002 	tsteq	r0, r2
     134:	00441535 	subeq	r1, r4, r5, lsr r5
     138:	38050000 	stmdacc	r5, {}	; <UNPREDICTABLE>
     13c:	89000000 	stmdbhi	r0, {}	; <UNPREDICTABLE>
     140:	06000000 	streq	r0, [r0], -r0
     144:	00000057 	andeq	r0, r0, r7, asr r0
     148:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
     14c:	023c0800 	eorseq	r0, ip, #0, 16
     150:	38010000 	stmdacc	r1, {}	; <UNPREDICTABLE>
     154:	00007615 	andeq	r7, r0, r5, lsl r6
     158:	03450800 	movteq	r0, #22528	; 0x5800
     15c:	3a010000 	bcc	40164 <__bss_end+0x37250>
     160:	00007615 	andeq	r7, r0, r5, lsl r6
     164:	01dc0900 	bicseq	r0, ip, r0, lsl #18
     168:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
     16c:	0000cb10 	andeq	ip, r0, r0, lsl fp
     170:	0081dc00 	addeq	sp, r1, r0, lsl #24
     174:	00005800 	andeq	r5, r0, r0, lsl #16
     178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f766c>
     17c:	0a000000 	beq	184 <shift+0x184>
     180:	000001ea 	andeq	r0, r0, sl, ror #3
     184:	d20c4a01 	andle	r4, ip, #4096	; 0x1000
     188:	02000000 	andeq	r0, r0, #0
     18c:	0b007491 	bleq	1d3d8 <__bss_end+0x144c4>
     190:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     194:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
     198:	00000038 	andeq	r0, r0, r8, lsr r0
     19c:	00036d09 	andeq	r6, r3, r9, lsl #26
     1a0:	103c0100 	eorsne	r0, ip, r0, lsl #2
     1a4:	000000cb 	andeq	r0, r0, fp, asr #1
     1a8:	00008184 	andeq	r8, r0, r4, lsl #3
     1ac:	00000058 	andeq	r0, r0, r8, asr r0
     1b0:	01029c01 	tsteq	r2, r1, lsl #24
     1b4:	ea0a0000 	b	2801bc <__bss_end+0x2772a8>
     1b8:	01000001 	tsteq	r0, r1
     1bc:	01020c3e 	tsteq	r2, lr, lsr ip
     1c0:	91020000 	mrsls	r0, (UNDEF: 2)
     1c4:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
     1c8:	00000025 	andeq	r0, r0, r5, lsr #32
     1cc:	0001c50c 	andeq	ip, r1, ip, lsl #10
     1d0:	11290100 			; <UNDEFINED> instruction: 0x11290100
     1d4:	00008178 	andeq	r8, r0, r8, ror r1
     1d8:	0000000c 	andeq	r0, r0, ip
     1dc:	fb0c9c01 	blx	3271ea <__bss_end+0x31e2d6>
     1e0:	01000001 	tsteq	r0, r1
     1e4:	81601124 	cmnhi	r0, r4, lsr #2
     1e8:	00180000 	andseq	r0, r8, r0
     1ec:	9c010000 	stcls	0, cr0, [r1], {-0}
     1f0:	0003520c 	andeq	r5, r3, ip, lsl #4
     1f4:	111f0100 	tstne	pc, r0, lsl #2
     1f8:	00008148 	andeq	r8, r0, r8, asr #2
     1fc:	00000018 	andeq	r0, r0, r8, lsl r0
     200:	2f0c9c01 	svccs	0x000c9c01
     204:	01000002 	tsteq	r0, r2
     208:	8130111a 	teqhi	r0, sl, lsl r1
     20c:	00180000 	andseq	r0, r8, r0
     210:	9c010000 	stcls	0, cr0, [r1], {-0}
     214:	0001f00d 	andeq	pc, r1, sp
     218:	9e000200 	cdpls	2, 0, cr0, cr0, cr0, {0}
     21c:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
     220:	0000024a 	andeq	r0, r0, sl, asr #4
     224:	6d121401 	cfldrsvs	mvf1, [r2, #-4]
     228:	0f000001 	svceq	0x00000001
     22c:	0000019e 	muleq	r0, lr, r1
     230:	01bd0200 			; <UNDEFINED> instruction: 0x01bd0200
     234:	04010000 	streq	r0, [r1], #-0
     238:	0001a41c 	andeq	sl, r1, ip, lsl r4
     23c:	020e0e00 	andeq	r0, lr, #0, 28
     240:	0f010000 	svceq	0x00010000
     244:	00018b12 	andeq	r8, r1, r2, lsl fp
     248:	019e0f00 	orrseq	r0, lr, r0, lsl #30
     24c:	10000000 	andne	r0, r0, r0
     250:	00000391 	muleq	r0, r1, r3
     254:	cb110a01 	blgt	442a60 <__bss_end+0x439b4c>
     258:	0f000000 	svceq	0x00000000
     25c:	0000019e 	muleq	r0, lr, r1
     260:	04030000 	streq	r0, [r3], #-0
     264:	0000016d 	andeq	r0, r0, sp, ror #2
     268:	5f050807 	svcpl	0x00050807
     26c:	11000003 	tstne	r0, r3
     270:	0000015b 	andeq	r0, r0, fp, asr r1
     274:	00008110 	andeq	r8, r0, r0, lsl r1
     278:	00000020 	andeq	r0, r0, r0, lsr #32
     27c:	01c79c01 	biceq	r9, r7, r1, lsl #24
     280:	9e120000 	cdpls	0, 1, cr0, cr2, cr0, {0}
     284:	02000001 	andeq	r0, r0, #1
     288:	11007491 			; <UNDEFINED> instruction: 0x11007491
     28c:	00000179 	andeq	r0, r0, r9, ror r1
     290:	000080e4 	andeq	r8, r0, r4, ror #1
     294:	0000002c 	andeq	r0, r0, ip, lsr #32
     298:	01e89c01 	mvneq	r9, r1, lsl #24
     29c:	67130000 	ldrvs	r0, [r3, -r0]
     2a0:	300f0100 	andcc	r0, pc, r0, lsl #2
     2a4:	0000019e 	muleq	r0, lr, r1
     2a8:	00749102 	rsbseq	r9, r4, r2, lsl #2
     2ac:	00018b14 	andeq	r8, r1, r4, lsl fp
     2b0:	0080ac00 	addeq	sl, r0, r0, lsl #24
     2b4:	00003800 	andeq	r3, r0, r0, lsl #16
     2b8:	139c0100 	orrsne	r0, ip, #0, 2
     2bc:	0a010067 	beq	40460 <__bss_end+0x3754c>
     2c0:	00019e2f 	andeq	r9, r1, pc, lsr #28
     2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     2c8:	0e030000 	cdpeq	0, 0, cr0, cr3, cr0, {0}
     2cc:	00040000 	andeq	r0, r4, r0
     2d0:	000001c6 	andeq	r0, r0, r6, asr #3
     2d4:	02650104 	rsbeq	r0, r5, #4, 2
     2d8:	5a040000 	bpl	1002e0 <__bss_end+0xf73cc>
     2dc:	3a00000b 	bcc	310 <shift+0x310>
     2e0:	34000000 	strcc	r0, [r0], #-0
     2e4:	dc000082 	stcle	0, cr0, [r0], {130}	; 0x82
     2e8:	ff000000 			; <UNDEFINED> instruction: 0xff000000
     2ec:	02000001 	andeq	r0, r0, #1
     2f0:	0dce0801 	stcleq	8, cr0, [lr, #4]
     2f4:	25030000 	strcs	r0, [r3, #-0]
     2f8:	02000000 	andeq	r0, r0, #0
     2fc:	0e420502 	cdpeq	5, 4, cr0, cr2, cr2, {0}
     300:	04040000 	streq	r0, [r4], #-0
     304:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     308:	08010200 	stmdaeq	r1, {r9}
     30c:	00000dc5 	andeq	r0, r0, r5, asr #27
     310:	04070202 	streq	r0, [r7], #-514	; 0xfffffdfe
     314:	0500000a 	streq	r0, [r0, #-10]
     318:	00000ee6 	andeq	r0, r0, r6, ror #29
     31c:	5e1e0903 	vnmlspl.f16	s0, s28, s6	; <UNPREDICTABLE>
     320:	03000000 	movweq	r0, #0
     324:	0000004d 	andeq	r0, r0, sp, asr #32
     328:	cf070402 	svcgt	0x00070402
     32c:	0300001c 	movweq	r0, #28
     330:	0000005e 	andeq	r0, r0, lr, asr r0
     334:	00005e06 	andeq	r5, r0, r6, lsl #28
     338:	07810700 	streq	r0, [r1, r0, lsl #14]
     33c:	02080000 	andeq	r0, r8, #0
     340:	00950806 	addseq	r0, r5, r6, lsl #16
     344:	72080000 	andvc	r0, r8, #0
     348:	08020030 	stmdaeq	r2, {r4, r5}
     34c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     350:	72080000 	andvc	r0, r8, #0
     354:	09020031 	stmdbeq	r2, {r0, r4, r5}
     358:	00004d0e 	andeq	r4, r0, lr, lsl #26
     35c:	09000400 	stmdbeq	r0, {sl}
     360:	000005e8 	andeq	r0, r0, r8, ror #11
     364:	00380405 	eorseq	r0, r8, r5, lsl #8
     368:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
     36c:	0000cc0c 	andeq	ip, r0, ip, lsl #24
     370:	08360a00 	ldmdaeq	r6!, {r9, fp}
     374:	0a000000 	beq	37c <shift+0x37c>
     378:	000012d9 	ldrdeq	r1, [r0], -r9
     37c:	12a30a01 	adcne	r0, r3, #4096	; 0x1000
     380:	0a020000 	beq	80388 <__bss_end+0x77474>
     384:	00000aa6 	andeq	r0, r0, r6, lsr #21
     388:	0d2b0a03 	vstmdbeq	fp!, {s0-s2}
     38c:	0a040000 	beq	100394 <__bss_end+0xf7480>
     390:	000007ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     394:	8b090005 	blhi	2403b0 <__bss_end+0x23749c>
     398:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
     39c:	00003804 	andeq	r3, r0, r4, lsl #16
     3a0:	0c3f0200 	lfmeq	f0, 4, [pc], #-0	; 3a8 <shift+0x3a8>
     3a4:	00000109 	andeq	r0, r0, r9, lsl #2
     3a8:	0004630a 	andeq	r6, r4, sl, lsl #6
     3ac:	240a0000 	strcs	r0, [sl], #-0
     3b0:	01000006 	tsteq	r0, r6
     3b4:	000ce60a 	andeq	lr, ip, sl, lsl #12
     3b8:	540a0200 	strpl	r0, [sl], #-512	; 0xfffffe00
     3bc:	03000012 	movweq	r0, #18
     3c0:	0012e30a 	andseq	lr, r2, sl, lsl #6
     3c4:	0a0a0400 	beq	2813cc <__bss_end+0x2784b8>
     3c8:	0500000c 	streq	r0, [r0, #-12]
     3cc:	000a240a 	andeq	r2, sl, sl, lsl #8
     3d0:	09000600 	stmdbeq	r0, {r9, sl}
     3d4:	00001145 	andeq	r1, r0, r5, asr #2
     3d8:	00380405 	eorseq	r0, r8, r5, lsl #8
     3dc:	66020000 	strvs	r0, [r2], -r0
     3e0:	0001340c 	andeq	r3, r1, ip, lsl #8
     3e4:	0da30a00 			; <UNDEFINED> instruction: 0x0da30a00
     3e8:	0a000000 	beq	3f0 <shift+0x3f0>
     3ec:	000009e6 	andeq	r0, r0, r6, ror #19
     3f0:	0e4c0a01 	vmlaeq.f32	s1, s24, s2
     3f4:	0a020000 	beq	803fc <__bss_end+0x774e8>
     3f8:	00000a29 	andeq	r0, r0, r9, lsr #20
     3fc:	78050003 	stmdavc	r5, {r0, r1}
     400:	04000006 	streq	r0, [r0], #-6
     404:	00381703 	eorseq	r1, r8, r3, lsl #14
     408:	620b0000 	andvs	r0, fp, #0
     40c:	0400000c 	streq	r0, [r0], #-12
     410:	00591405 	subseq	r1, r9, r5, lsl #8
     414:	03050000 	movweq	r0, #20480	; 0x5000
     418:	00008e38 	andeq	r8, r0, r8, lsr lr
     41c:	000c9e0b 	andeq	r9, ip, fp, lsl #28
     420:	14060400 	strne	r0, [r6], #-1024	; 0xfffffc00
     424:	00000059 	andeq	r0, r0, r9, asr r0
     428:	8e3c0305 	cdphi	3, 3, cr0, cr12, cr5, {0}
     42c:	f40b0000 	vst4.8	{d0-d3}, [fp], r0
     430:	0500000b 	streq	r0, [r0, #-11]
     434:	00591a07 	subseq	r1, r9, r7, lsl #20
     438:	03050000 	movweq	r0, #20480	; 0x5000
     43c:	00008e40 	andeq	r8, r0, r0, asr #28
     440:	0006530b 	andeq	r5, r6, fp, lsl #6
     444:	1a090500 	bne	24184c <__bss_end+0x238938>
     448:	00000059 	andeq	r0, r0, r9, asr r0
     44c:	8e440305 	cdphi	3, 4, cr0, cr4, cr5, {0}
     450:	b70b0000 	strlt	r0, [fp, -r0]
     454:	0500000d 	streq	r0, [r0, #-13]
     458:	00591a0b 	subseq	r1, r9, fp, lsl #20
     45c:	03050000 	movweq	r0, #20480	; 0x5000
     460:	00008e48 	andeq	r8, r0, r8, asr #28
     464:	0009d30b 	andeq	sp, r9, fp, lsl #6
     468:	1a0d0500 	bne	341870 <__bss_end+0x33895c>
     46c:	00000059 	andeq	r0, r0, r9, asr r0
     470:	8e4c0305 	cdphi	3, 4, cr0, cr12, cr5, {0}
     474:	a70b0000 	strge	r0, [fp, -r0]
     478:	05000007 	streq	r0, [r0, #-7]
     47c:	00591a0f 	subseq	r1, r9, pc, lsl #20
     480:	03050000 	movweq	r0, #20480	; 0x5000
     484:	00008e50 	andeq	r8, r0, r0, asr lr
     488:	000f4609 	andeq	r4, pc, r9, lsl #12
     48c:	38040500 	stmdacc	r4, {r8, sl}
     490:	05000000 	streq	r0, [r0, #-0]
     494:	01e30c1b 	mvneq	r0, fp, lsl ip
     498:	b20a0000 	andlt	r0, sl, #0
     49c:	0000000f 	andeq	r0, r0, pc
     4a0:	0012930a 	andseq	r9, r2, sl, lsl #6
     4a4:	e10a0100 	mrs	r0, (UNDEF: 26)
     4a8:	0200000c 	andeq	r0, r0, #12
     4ac:	0d880c00 	stceq	12, cr0, [r8]
     4b0:	270d0000 	strcs	r0, [sp, -r0]
     4b4:	9000000e 	andls	r0, r0, lr
     4b8:	56076305 	strpl	r6, [r7], -r5, lsl #6
     4bc:	07000003 	streq	r0, [r0, -r3]
     4c0:	000011f6 	strdeq	r1, [r0], -r6
     4c4:	10670524 	rsbne	r0, r7, r4, lsr #10
     4c8:	00000270 	andeq	r0, r0, r0, ror r2
     4cc:	0020b70e 	eoreq	fp, r0, lr, lsl #14
     4d0:	28690500 	stmdacs	r9!, {r8, sl}^
     4d4:	00000356 	andeq	r0, r0, r6, asr r3
     4d8:	05dc0e00 	ldrbeq	r0, [ip, #3584]	; 0xe00
     4dc:	6b050000 	blvs	1404e4 <__bss_end+0x1375d0>
     4e0:	00036620 	andeq	r6, r3, r0, lsr #12
     4e4:	a70e1000 	strge	r1, [lr, -r0]
     4e8:	0500000f 	streq	r0, [r0, #-15]
     4ec:	004d236d 	subeq	r2, sp, sp, ror #6
     4f0:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     4f4:	0000064c 	andeq	r0, r0, ip, asr #12
     4f8:	6d1c7005 	ldcvs	0, cr7, [ip, #-20]	; 0xffffffec
     4fc:	18000003 	stmdane	r0, {r0, r1}
     500:	000dae0e 	andeq	sl, sp, lr, lsl #28
     504:	1c720500 	cfldr64ne	mvdx0, [r2], #-0
     508:	0000036d 	andeq	r0, r0, sp, ror #6
     50c:	05b00e1c 	ldreq	r0, [r0, #3612]!	; 0xe1c
     510:	75050000 	strvc	r0, [r5, #-0]
     514:	00036d1c 	andeq	r6, r3, ip, lsl sp
     518:	480f2000 	stmdami	pc, {sp}	; <UNPREDICTABLE>
     51c:	05000008 	streq	r0, [r0, #-8]
     520:	04de1c77 	ldrbeq	r1, [lr], #3191	; 0xc77
     524:	036d0000 	cmneq	sp, #0
     528:	02640000 	rsbeq	r0, r4, #0
     52c:	6d100000 	ldcvs	0, cr0, [r0, #-0]
     530:	11000003 	tstne	r0, r3
     534:	00000373 	andeq	r0, r0, r3, ror r3
     538:	bc070000 	stclt	0, cr0, [r7], {-0}
     53c:	18000006 	stmdane	r0, {r1, r2}
     540:	a5107b05 	ldrge	r7, [r0, #-2821]	; 0xfffff4fb
     544:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
     548:	000020b7 	strheq	r2, [r0], -r7
     54c:	562c7e05 	strtpl	r7, [ip], -r5, lsl #28
     550:	00000003 	andeq	r0, r0, r3
     554:	0005d10e 	andeq	sp, r5, lr, lsl #2
     558:	19800500 	stmibne	r0, {r8, sl}
     55c:	00000373 	andeq	r0, r0, r3, ror r3
     560:	125a0e10 	subsne	r0, sl, #16, 28	; 0x100
     564:	82050000 	andhi	r0, r5, #0
     568:	00037e21 	andeq	r7, r3, r1, lsr #28
     56c:	03001400 	movweq	r1, #1024	; 0x400
     570:	00000270 	andeq	r0, r0, r0, ror r2
     574:	000ba012 	andeq	sl, fp, r2, lsl r0
     578:	21860500 	orrcs	r0, r6, r0, lsl #10
     57c:	00000384 	andeq	r0, r0, r4, lsl #7
     580:	0008fd12 	andeq	pc, r8, r2, lsl sp	; <UNPREDICTABLE>
     584:	1f880500 	svcne	0x00880500
     588:	00000059 	andeq	r0, r0, r9, asr r0
     58c:	000e8a0e 	andeq	r8, lr, lr, lsl #20
     590:	178b0500 	strne	r0, [fp, r0, lsl #10]
     594:	000001f5 	strdeq	r0, [r0], -r5
     598:	0aac0e00 	beq	feb03da0 <__bss_end+0xfeafae8c>
     59c:	8e050000 	cdphi	0, 0, cr0, cr5, cr0, {0}
     5a0:	0001f517 	andeq	pc, r1, r7, lsl r5	; <UNPREDICTABLE>
     5a4:	680e2400 	stmdavs	lr, {sl, sp}
     5a8:	05000009 	streq	r0, [r0, #-9]
     5ac:	01f5178f 	mvnseq	r1, pc, lsl #15
     5b0:	0e480000 	cdpeq	0, 4, cr0, cr8, cr0, {0}
     5b4:	000012c3 	andeq	r1, r0, r3, asr #5
     5b8:	f5179005 			; <UNDEFINED> instruction: 0xf5179005
     5bc:	6c000001 	stcvs	0, cr0, [r0], {1}
     5c0:	000e2713 	andeq	r2, lr, r3, lsl r7
     5c4:	09930500 	ldmibeq	r3, {r8, sl}
     5c8:	000006a7 	andeq	r0, r0, r7, lsr #13
     5cc:	0000038f 	andeq	r0, r0, pc, lsl #7
     5d0:	00030f01 	andeq	r0, r3, r1, lsl #30
     5d4:	00031500 	andeq	r1, r3, r0, lsl #10
     5d8:	038f1000 	orreq	r1, pc, #0
     5dc:	14000000 	strne	r0, [r0], #-0
     5e0:	00000b4f 	andeq	r0, r0, pc, asr #22
     5e4:	620e9605 	andvs	r9, lr, #5242880	; 0x500000
     5e8:	0100000a 	tsteq	r0, sl
     5ec:	0000032a 	andeq	r0, r0, sl, lsr #6
     5f0:	00000330 	andeq	r0, r0, r0, lsr r3
     5f4:	00038f10 	andeq	r8, r3, r0, lsl pc
     5f8:	63150000 	tstvs	r5, #0
     5fc:	05000004 	streq	r0, [r0, #-4]
     600:	0f2b1099 	svceq	0x002b1099
     604:	03950000 	orrseq	r0, r5, #0
     608:	45010000 	strmi	r0, [r1, #-0]
     60c:	10000003 	andne	r0, r0, r3
     610:	0000038f 	andeq	r0, r0, pc, lsl #7
     614:	00037311 	andeq	r7, r3, r1, lsl r3
     618:	01be1100 			; <UNDEFINED> instruction: 0x01be1100
     61c:	00000000 	andeq	r0, r0, r0
     620:	00002516 	andeq	r2, r0, r6, lsl r5
     624:	00036600 	andeq	r6, r3, r0, lsl #12
     628:	005e1700 	subseq	r1, lr, r0, lsl #14
     62c:	000f0000 	andeq	r0, pc, r0
     630:	b6020102 	strlt	r0, [r2], -r2, lsl #2
     634:	1800000a 	stmdane	r0, {r1, r3}
     638:	0001f504 	andeq	pc, r1, r4, lsl #10
     63c:	2c041800 	stccs	8, cr1, [r4], {-0}
     640:	0c000000 	stceq	0, cr0, [r0], {-0}
     644:	00001266 	andeq	r1, r0, r6, ror #4
     648:	03790418 	cmneq	r9, #24, 8	; 0x18000000
     64c:	a5160000 	ldrge	r0, [r6, #-0]
     650:	8f000002 	svchi	0x00000002
     654:	19000003 	stmdbne	r0, {r0, r1}
     658:	e8041800 	stmda	r4, {fp, ip}
     65c:	18000001 	stmdane	r0, {r0}
     660:	0001e304 	andeq	lr, r1, r4, lsl #6
     664:	0e901a00 	vfnmseq.f32	s2, s0, s0
     668:	9c050000 	stcls	0, cr0, [r5], {-0}
     66c:	0001e814 	andeq	lr, r1, r4, lsl r8
     670:	08a90b00 	stmiaeq	r9!, {r8, r9, fp}
     674:	04060000 	streq	r0, [r6], #-0
     678:	00005914 	andeq	r5, r0, r4, lsl r9
     67c:	54030500 	strpl	r0, [r3], #-1280	; 0xfffffb00
     680:	0b00008e 	bleq	8c0 <shift+0x8c0>
     684:	000003ee 	andeq	r0, r0, lr, ror #7
     688:	59140706 	ldmdbpl	r4, {r1, r2, r8, r9, sl}
     68c:	05000000 	streq	r0, [r0, #-0]
     690:	008e5803 	addeq	r5, lr, r3, lsl #16
     694:	06830b00 	streq	r0, [r3], r0, lsl #22
     698:	0a060000 	beq	1806a0 <__bss_end+0x17778c>
     69c:	00005914 	andeq	r5, r0, r4, lsl r9
     6a0:	5c030500 	cfstr32pl	mvfx0, [r3], {-0}
     6a4:	0900008e 	stmdbeq	r0, {r1, r2, r3, r7}
     6a8:	00000b1f 	andeq	r0, r0, pc, lsl fp
     6ac:	00380405 	eorseq	r0, r8, r5, lsl #8
     6b0:	0d060000 	stceq	0, cr0, [r6, #-0]
     6b4:	0004140c 	andeq	r1, r4, ip, lsl #8
     6b8:	654e1b00 	strbvs	r1, [lr, #-2816]	; 0xfffff500
     6bc:	0a000077 	beq	8a0 <shift+0x8a0>
     6c0:	00000b16 	andeq	r0, r0, r6, lsl fp
     6c4:	0ea20a01 	vfmaeq.f32	s0, s4, s2
     6c8:	0a020000 	beq	806d0 <__bss_end+0x777bc>
     6cc:	00000ad1 	ldrdeq	r0, [r0], -r1
     6d0:	0a980a03 	beq	fe602ee4 <__bss_end+0xfe5f9fd0>
     6d4:	0a040000 	beq	1006dc <__bss_end+0xf77c8>
     6d8:	00000cec 	andeq	r0, r0, ip, ror #25
     6dc:	f2070005 	vhadd.s8	d0, d7, d5
     6e0:	10000007 	andne	r0, r0, r7
     6e4:	53081b06 	movwpl	r1, #35590	; 0x8b06
     6e8:	08000004 	stmdaeq	r0, {r2}
     6ec:	0600726c 	streq	r7, [r0], -ip, ror #4
     6f0:	0453131d 	ldrbeq	r1, [r3], #-797	; 0xfffffce3
     6f4:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     6f8:	06007073 			; <UNDEFINED> instruction: 0x06007073
     6fc:	0453131e 	ldrbeq	r1, [r3], #-798	; 0xfffffce2
     700:	08040000 	stmdaeq	r4, {}	; <UNPREDICTABLE>
     704:	06006370 			; <UNDEFINED> instruction: 0x06006370
     708:	0453131f 	ldrbeq	r1, [r3], #-799	; 0xfffffce1
     70c:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
     710:	00000808 	andeq	r0, r0, r8, lsl #16
     714:	53132006 	tstpl	r3, #6
     718:	0c000004 	stceq	0, cr0, [r0], {4}
     71c:	07040200 	streq	r0, [r4, -r0, lsl #4]
     720:	00001cca 	andeq	r1, r0, sl, asr #25
     724:	00045303 	andeq	r5, r4, r3, lsl #6
     728:	04d10700 	ldrbeq	r0, [r1], #1792	; 0x700
     72c:	06700000 	ldrbteq	r0, [r0], -r0
     730:	04ef0828 	strbteq	r0, [pc], #2088	; 738 <shift+0x738>
     734:	cd0e0000 	stcgt	0, cr0, [lr, #-0]
     738:	06000012 			; <UNDEFINED> instruction: 0x06000012
     73c:	0414122a 	ldreq	r1, [r4], #-554	; 0xfffffdd6
     740:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     744:	00646970 	rsbeq	r6, r4, r0, ror r9
     748:	5e122b06 	vnmlspl.f64	d2, d2, d6
     74c:	10000000 	andne	r0, r0, r0
     750:	001aa80e 	andseq	sl, sl, lr, lsl #16
     754:	112c0600 			; <UNDEFINED> instruction: 0x112c0600
     758:	000003dd 	ldrdeq	r0, [r0], -sp
     75c:	0b2b0e14 	bleq	ac3fb4 <__bss_end+0xabb0a0>
     760:	2d060000 	stccs	0, cr0, [r6, #-0]
     764:	00005e12 	andeq	r5, r0, r2, lsl lr
     768:	390e1800 	stmdbcc	lr, {fp, ip}
     76c:	0600000b 	streq	r0, [r0], -fp
     770:	005e122e 	subseq	r1, lr, lr, lsr #4
     774:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
     778:	0000079a 	muleq	r0, sl, r7
     77c:	ef312f06 	svc	0x00312f06
     780:	20000004 	andcs	r0, r0, r4
     784:	000bac0e 	andeq	sl, fp, lr, lsl #24
     788:	09300600 	ldmdbeq	r0!, {r9, sl}
     78c:	00000038 	andeq	r0, r0, r8, lsr r0
     790:	0fbc0e60 	svceq	0x00bc0e60
     794:	31060000 	mrscc	r0, (UNDEF: 6)
     798:	00004d0e 	andeq	r4, r0, lr, lsl #26
     79c:	5c0e6400 	cfstrspl	mvf6, [lr], {-0}
     7a0:	06000008 	streq	r0, [r0], -r8
     7a4:	004d0e33 	subeq	r0, sp, r3, lsr lr
     7a8:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
     7ac:	00000853 	andeq	r0, r0, r3, asr r8
     7b0:	4d0e3406 	cfstrsmi	mvf3, [lr, #-24]	; 0xffffffe8
     7b4:	6c000000 	stcvs	0, cr0, [r0], {-0}
     7b8:	03951600 	orrseq	r1, r5, #0, 12
     7bc:	04ff0000 	ldrbteq	r0, [pc], #0	; 7c4 <shift+0x7c4>
     7c0:	5e170000 	cdppl	0, 1, cr0, cr7, cr0, {0}
     7c4:	0f000000 	svceq	0x00000000
     7c8:	11e70b00 	mvnne	r0, r0, lsl #22
     7cc:	0a070000 	beq	1c07d4 <__bss_end+0x1b78c0>
     7d0:	00005914 	andeq	r5, r0, r4, lsl r9
     7d4:	60030500 	andvs	r0, r3, r0, lsl #10
     7d8:	0900008e 	stmdbeq	r0, {r1, r2, r3, r7}
     7dc:	00000ad9 	ldrdeq	r0, [r0], -r9
     7e0:	00380405 	eorseq	r0, r8, r5, lsl #8
     7e4:	0d070000 	stceq	0, cr0, [r7, #-0]
     7e8:	0005300c 	andeq	r3, r5, ip
     7ec:	05fd0a00 	ldrbeq	r0, [sp, #2560]!	; 0xa00
     7f0:	0a000000 	beq	7f8 <shift+0x7f8>
     7f4:	000003e3 	andeq	r0, r0, r3, ror #7
     7f8:	8d070001 	stchi	0, cr0, [r7, #-4]
     7fc:	0c000010 	stceq	0, cr0, [r0], {16}
     800:	65081b07 	strvs	r1, [r8, #-2823]	; 0xfffff4f9
     804:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
     808:	000004a3 	andeq	r0, r0, r3, lsr #9
     80c:	65191d07 	ldrvs	r1, [r9, #-3335]	; 0xfffff2f9
     810:	00000005 	andeq	r0, r0, r5
     814:	0005b00e 	andeq	fp, r5, lr
     818:	191e0700 	ldmdbne	lr, {r8, r9, sl}
     81c:	00000565 	andeq	r0, r0, r5, ror #10
     820:	10300e04 	eorsne	r0, r0, r4, lsl #28
     824:	1f070000 	svcne	0x00070000
     828:	00056b13 	andeq	r6, r5, r3, lsl fp
     82c:	18000800 	stmdane	r0, {fp}
     830:	00053004 	andeq	r3, r5, r4
     834:	5f041800 	svcpl	0x00041800
     838:	0d000004 	stceq	0, cr0, [r0, #-16]
     83c:	00000696 	muleq	r0, r6, r6
     840:	07220714 			; <UNDEFINED> instruction: 0x07220714
     844:	000007f3 	strdeq	r0, [r0], -r3
     848:	000ac70e 	andeq	ip, sl, lr, lsl #14
     84c:	12260700 	eorne	r0, r6, #0, 14
     850:	0000004d 	andeq	r0, r0, sp, asr #32
     854:	054a0e00 	strbeq	r0, [sl, #-3584]	; 0xfffff200
     858:	29070000 	stmdbcs	r7, {}	; <UNPREDICTABLE>
     85c:	0005651d 	andeq	r6, r5, sp, lsl r5
     860:	180e0400 	stmdane	lr, {sl}
     864:	0700000f 	streq	r0, [r0, -pc]
     868:	05651d2c 	strbeq	r1, [r5, #-3372]!	; 0xfffff2d4
     86c:	1c080000 	stcne	0, cr0, [r8], {-0}
     870:	00001181 	andeq	r1, r0, r1, lsl #3
     874:	6a0e2f07 	bvs	38c498 <__bss_end+0x383584>
     878:	b9000010 	stmdblt	r0, {r4}
     87c:	c4000005 	strgt	r0, [r0], #-5
     880:	10000005 	andne	r0, r0, r5
     884:	000007f8 	strdeq	r0, [r0], -r8
     888:	00056511 	andeq	r6, r5, r1, lsl r5
     88c:	461d0000 	ldrmi	r0, [sp], -r0
     890:	07000010 	smladeq	r0, r0, r0, r0
     894:	04a80e31 	strteq	r0, [r8], #3633	; 0xe31
     898:	03660000 	cmneq	r6, #0
     89c:	05dc0000 	ldrbeq	r0, [ip]
     8a0:	05e70000 	strbeq	r0, [r7, #0]!
     8a4:	f8100000 			; <UNDEFINED> instruction: 0xf8100000
     8a8:	11000007 	tstne	r0, r7
     8ac:	0000056b 	andeq	r0, r0, fp, ror #10
     8b0:	10cf1300 	sbcne	r1, pc, r0, lsl #6
     8b4:	35070000 	strcc	r0, [r7, #-0]
     8b8:	00100b1d 	andseq	r0, r0, sp, lsl fp
     8bc:	00056500 	andeq	r6, r5, r0, lsl #10
     8c0:	06000200 	streq	r0, [r0], -r0, lsl #4
     8c4:	06060000 	streq	r0, [r6], -r0
     8c8:	f8100000 			; <UNDEFINED> instruction: 0xf8100000
     8cc:	00000007 	andeq	r0, r0, r7
     8d0:	000a1713 	andeq	r1, sl, r3, lsl r7
     8d4:	1d370700 	ldcne	7, cr0, [r7, #-0]
     8d8:	00000e01 	andeq	r0, r0, r1, lsl #28
     8dc:	00000565 	andeq	r0, r0, r5, ror #10
     8e0:	00061f02 	andeq	r1, r6, r2, lsl #30
     8e4:	00062500 	andeq	r2, r6, r0, lsl #10
     8e8:	07f81000 	ldrbeq	r1, [r8, r0]!
     8ec:	1e000000 	cdpne	0, 0, cr0, cr0, cr0, {0}
     8f0:	00000bdc 	ldrdeq	r0, [r0], -ip
     8f4:	11443907 	cmpne	r4, r7, lsl #18
     8f8:	0c000008 	stceq	0, cr0, [r0], {8}
     8fc:	06961302 	ldreq	r1, [r6], r2, lsl #6
     900:	3c070000 	stccc	0, cr0, [r7], {-0}
     904:	0012a909 	andseq	sl, r2, r9, lsl #18
     908:	0007f800 	andeq	pc, r7, r0, lsl #16
     90c:	064c0100 	strbeq	r0, [ip], -r0, lsl #2
     910:	06520000 	ldrbeq	r0, [r2], -r0
     914:	f8100000 			; <UNDEFINED> instruction: 0xf8100000
     918:	00000007 	andeq	r0, r0, r7
     91c:	00063713 	andeq	r3, r6, r3, lsl r7
     920:	123f0700 	eorsne	r0, pc, #0, 14
     924:	00001156 	andeq	r1, r0, r6, asr r1
     928:	0000004d 	andeq	r0, r0, sp, asr #32
     92c:	00066b01 	andeq	r6, r6, r1, lsl #22
     930:	00068000 	andeq	r8, r6, r0
     934:	07f81000 	ldrbeq	r1, [r8, r0]!
     938:	1a110000 	bne	440940 <__bss_end+0x437a2c>
     93c:	11000008 	tstne	r0, r8
     940:	0000005e 	andeq	r0, r0, lr, asr r0
     944:	00036611 	andeq	r6, r3, r1, lsl r6
     948:	55140000 	ldrpl	r0, [r4, #-0]
     94c:	07000010 	smladeq	r0, r0, r0, r0
     950:	0d3a0e42 	ldceq	14, cr0, [sl, #-264]!	; 0xfffffef8
     954:	95010000 	strls	r0, [r1, #-0]
     958:	9b000006 	blls	978 <shift+0x978>
     95c:	10000006 	andne	r0, r0, r6
     960:	000007f8 	strdeq	r0, [r0], -r8
     964:	097b1300 	ldmdbeq	fp!, {r8, r9, ip}^
     968:	45070000 	strmi	r0, [r7, #-0]
     96c:	00056f17 	andeq	r6, r5, r7, lsl pc
     970:	00056b00 	andeq	r6, r5, r0, lsl #22
     974:	06b40100 	ldrteq	r0, [r4], r0, lsl #2
     978:	06ba0000 	ldrteq	r0, [sl], r0
     97c:	20100000 	andscs	r0, r0, r0
     980:	00000008 	andeq	r0, r0, r8
     984:	0005be13 	andeq	fp, r5, r3, lsl lr
     988:	17480700 	strbne	r0, [r8, -r0, lsl #14]
     98c:	00000fc8 	andeq	r0, r0, r8, asr #31
     990:	0000056b 	andeq	r0, r0, fp, ror #10
     994:	0006d301 	andeq	sp, r6, r1, lsl #6
     998:	0006de00 	andeq	sp, r6, r0, lsl #28
     99c:	08201000 	stmdaeq	r0!, {ip}
     9a0:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     9a4:	00000000 	andeq	r0, r0, r0
     9a8:	00120414 	andseq	r0, r2, r4, lsl r4
     9ac:	0e4b0700 	cdpeq	7, 4, cr0, cr11, cr0, {0}
     9b0:	00000468 	andeq	r0, r0, r8, ror #8
     9b4:	0006f301 	andeq	pc, r6, r1, lsl #6
     9b8:	0006f900 	andeq	pc, r6, r0, lsl #18
     9bc:	07f81000 	ldrbeq	r1, [r8, r0]!
     9c0:	13000000 	movwne	r0, #0
     9c4:	00001046 	andeq	r1, r0, r6, asr #32
     9c8:	0e0e4d07 	cdpeq	13, 0, cr4, cr14, cr7, {0}
     9cc:	66000008 	strvs	r0, [r0], -r8
     9d0:	01000003 	tsteq	r0, r3
     9d4:	00000712 	andeq	r0, r0, r2, lsl r7
     9d8:	0000071d 	andeq	r0, r0, sp, lsl r7
     9dc:	0007f810 	andeq	pc, r7, r0, lsl r8	; <UNPREDICTABLE>
     9e0:	004d1100 	subeq	r1, sp, r0, lsl #2
     9e4:	13000000 	movwne	r0, #0
     9e8:	0000098f 	andeq	r0, r0, pc, lsl #19
     9ec:	5b125007 	blpl	494a10 <__bss_end+0x48bafc>
     9f0:	4d00000d 	stcmi	0, cr0, [r0, #-52]	; 0xffffffcc
     9f4:	01000000 	mrseq	r0, (UNDEF: 0)
     9f8:	00000736 	andeq	r0, r0, r6, lsr r7
     9fc:	00000741 	andeq	r0, r0, r1, asr #14
     a00:	0007f810 	andeq	pc, r7, r0, lsl r8	; <UNPREDICTABLE>
     a04:	03951100 	orrseq	r1, r5, #0, 2
     a08:	13000000 	movwne	r0, #0
     a0c:	0000050e 	andeq	r0, r0, lr, lsl #10
     a10:	c20e5307 	andgt	r5, lr, #469762048	; 0x1c000000
     a14:	66000008 	strvs	r0, [r0], -r8
     a18:	01000003 	tsteq	r0, r3
     a1c:	0000075a 	andeq	r0, r0, sl, asr r7
     a20:	00000765 	andeq	r0, r0, r5, ror #14
     a24:	0007f810 	andeq	pc, r7, r0, lsl r8	; <UNPREDICTABLE>
     a28:	004d1100 	subeq	r1, sp, r0, lsl #2
     a2c:	14000000 	strne	r0, [r0], #-0
     a30:	000009f1 	strdeq	r0, [r0], -r1
     a34:	ee0e5607 	cfmadd32	mvax0, mvfx5, mvfx14, mvfx7
     a38:	01000010 	tsteq	r0, r0, lsl r0
     a3c:	0000077a 	andeq	r0, r0, sl, ror r7
     a40:	00000799 	muleq	r0, r9, r7
     a44:	0007f810 	andeq	pc, r7, r0, lsl r8	; <UNPREDICTABLE>
     a48:	00951100 	addseq	r1, r5, r0, lsl #2
     a4c:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     a50:	11000000 	mrsne	r0, (UNDEF: 0)
     a54:	0000004d 	andeq	r0, r0, sp, asr #32
     a58:	00004d11 	andeq	r4, r0, r1, lsl sp
     a5c:	08261100 	stmdaeq	r6!, {r8, ip}
     a60:	14000000 	strne	r0, [r0], #-0
     a64:	00000ff5 	strdeq	r0, [r0], -r5
     a68:	350e5807 	strcc	r5, [lr, #-2055]	; 0xfffff7f9
     a6c:	01000007 	tsteq	r0, r7
     a70:	000007ae 	andeq	r0, r0, lr, lsr #15
     a74:	000007cd 	andeq	r0, r0, sp, asr #15
     a78:	0007f810 	andeq	pc, r7, r0, lsl r8	; <UNPREDICTABLE>
     a7c:	00cc1100 	sbceq	r1, ip, r0, lsl #2
     a80:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     a84:	11000000 	mrsne	r0, (UNDEF: 0)
     a88:	0000004d 	andeq	r0, r0, sp, asr #32
     a8c:	00004d11 	andeq	r4, r0, r1, lsl sp
     a90:	08261100 	stmdaeq	r6!, {r8, ip}
     a94:	15000000 	strne	r0, [r0, #-0]
     a98:	00000665 	andeq	r0, r0, r5, ror #12
     a9c:	c70e5b07 	strgt	r5, [lr, -r7, lsl #22]
     aa0:	66000006 	strvs	r0, [r0], -r6
     aa4:	01000003 	tsteq	r0, r3
     aa8:	000007e2 	andeq	r0, r0, r2, ror #15
     aac:	0007f810 	andeq	pc, r7, r0, lsl r8	; <UNPREDICTABLE>
     ab0:	05111100 	ldreq	r1, [r1, #-256]	; 0xffffff00
     ab4:	2c110000 	ldccs	0, cr0, [r1], {-0}
     ab8:	00000008 	andeq	r0, r0, r8
     abc:	05710300 	ldrbeq	r0, [r1, #-768]!	; 0xfffffd00
     ac0:	04180000 	ldreq	r0, [r8], #-0
     ac4:	00000571 	andeq	r0, r0, r1, ror r5
     ac8:	0005651f 	andeq	r6, r5, pc, lsl r5
     acc:	00080b00 	andeq	r0, r8, r0, lsl #22
     ad0:	00081100 	andeq	r1, r8, r0, lsl #2
     ad4:	07f81000 	ldrbeq	r1, [r8, r0]!
     ad8:	20000000 	andcs	r0, r0, r0
     adc:	00000571 	andeq	r0, r0, r1, ror r5
     ae0:	000007fe 	strdeq	r0, [r0], -lr
     ae4:	003f0418 	eorseq	r0, pc, r8, lsl r4	; <UNPREDICTABLE>
     ae8:	04180000 	ldreq	r0, [r8], #-0
     aec:	000007f3 	strdeq	r0, [r0], -r3
     af0:	006f0421 	rsbeq	r0, pc, r1, lsr #8
     af4:	04220000 	strteq	r0, [r2], #-0
     af8:	00105e1a 	andseq	r5, r0, sl, lsl lr
     afc:	195e0700 	ldmdbne	lr, {r8, r9, sl}^
     b00:	00000571 	andeq	r0, r0, r1, ror r5
     b04:	6c616823 	stclvs	8, cr6, [r1], #-140	; 0xffffff74
     b08:	0b050800 	bleq	142b10 <__bss_end+0x139bfc>
     b0c:	000008f4 	strdeq	r0, [r0], -r4
     b10:	000c1124 	andeq	r1, ip, r4, lsr #2
     b14:	19070800 	stmdbne	r7, {fp}
     b18:	00000065 	andeq	r0, r0, r5, rrx
     b1c:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
     b20:	000e7a24 	andeq	r7, lr, r4, lsr #20
     b24:	1a0a0800 	bne	282b2c <__bss_end+0x279c18>
     b28:	0000045a 	andeq	r0, r0, sl, asr r4
     b2c:	20000000 	andcs	r0, r0, r0
     b30:	000bea24 	andeq	lr, fp, r4, lsr #20
     b34:	1a0d0800 	bne	342b3c <__bss_end+0x339c28>
     b38:	0000045a 	andeq	r0, r0, sl, asr r4
     b3c:	20200000 	eorcs	r0, r0, r0
     b40:	000e3325 	andeq	r3, lr, r5, lsr #6
     b44:	15100800 	ldrne	r0, [r0, #-2048]	; 0xfffff800
     b48:	00000059 	andeq	r0, r0, r9, asr r0
     b4c:	09722436 	ldmdbeq	r2!, {r1, r2, r4, r5, sl, sp}^
     b50:	42080000 	andmi	r0, r8, #0
     b54:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b58:	21500000 	cmpcs	r0, r0
     b5c:	08652420 	stmdaeq	r5!, {r5, sl, sp}^
     b60:	71080000 	mrsvc	r0, (UNDEF: 8)
     b64:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b68:	00b20000 	adcseq	r0, r2, r0
     b6c:	0f0d2420 	svceq	0x000d2420
     b70:	a4080000 	strge	r0, [r8], #-0
     b74:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b78:	00b40000 	adcseq	r0, r4, r0
     b7c:	08ee2420 	stmiaeq	lr!, {r5, sl, sp}^
     b80:	b3080000 	movwlt	r0, #32768	; 0x8000
     b84:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b88:	10400000 	subne	r0, r0, r0
     b8c:	083e2420 	ldmdaeq	lr!, {r5, sl, sp}
     b90:	be080000 	cdplt	0, 0, cr0, cr8, cr0, {0}
     b94:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b98:	20500000 	subscs	r0, r0, r0
     b9c:	089f2420 	ldmeq	pc, {r5, sl, sp}	; <UNPREDICTABLE>
     ba0:	bf080000 	svclt	0x00080000
     ba4:	00045a1a 	andeq	r5, r4, sl, lsl sl
     ba8:	80400000 	subhi	r0, r0, r0
     bac:	05402420 	strbeq	r2, [r0, #-1056]	; 0xfffffbe0
     bb0:	c0080000 	andgt	r0, r8, r0
     bb4:	00045a1a 	andeq	r5, r4, sl, lsl sl
     bb8:	80500000 	subshi	r0, r0, r0
     bbc:	46260020 	strtmi	r0, [r6], -r0, lsr #32
     bc0:	26000008 	strcs	r0, [r0], -r8
     bc4:	00000856 	andeq	r0, r0, r6, asr r8
     bc8:	00086626 	andeq	r6, r8, r6, lsr #12
     bcc:	08762600 	ldmdaeq	r6!, {r9, sl, sp}^
     bd0:	83260000 			; <UNDEFINED> instruction: 0x83260000
     bd4:	26000008 	strcs	r0, [r0], -r8
     bd8:	00000893 	muleq	r0, r3, r8
     bdc:	0008a326 	andeq	sl, r8, r6, lsr #6
     be0:	08b32600 	ldmeq	r3!, {r9, sl, sp}
     be4:	c3260000 			; <UNDEFINED> instruction: 0xc3260000
     be8:	26000008 	strcs	r0, [r0], -r8
     bec:	000008d3 	ldrdeq	r0, [r0], -r3
     bf0:	0008e326 	andeq	lr, r8, r6, lsr #6
     bf4:	0bb60b00 	bleq	fed837fc <__bss_end+0xfed7a8e8>
     bf8:	08090000 	stmdaeq	r9, {}	; <UNPREDICTABLE>
     bfc:	00005914 	andeq	r5, r0, r4, lsl r9
     c00:	90030500 	andls	r0, r3, r0, lsl #10
     c04:	0900008e 	stmdbeq	r0, {r1, r2, r3, r7}
     c08:	00000d1c 	andeq	r0, r0, ip, lsl sp
     c0c:	005e0407 	subseq	r0, lr, r7, lsl #8
     c10:	0b090000 	bleq	240c18 <__bss_end+0x237d04>
     c14:	0009860c 	andeq	r8, r9, ip, lsl #12
     c18:	10400a00 	subne	r0, r0, r0, lsl #20
     c1c:	0a000000 	beq	c24 <shift+0xc24>
     c20:	00000cda 	ldrdeq	r0, [r0], -sl
     c24:	0aee0a01 	beq	ffb83430 <__bss_end+0xffb7a51c>
     c28:	0a020000 	beq	80c30 <__bss_end+0x77d1c>
     c2c:	0000049d 	muleq	r0, sp, r4
     c30:	045d0a03 	ldrbeq	r0, [sp], #-2563	; 0xfffff5fd
     c34:	0a040000 	beq	100c3c <__bss_end+0xf7d28>
     c38:	00000abb 			; <UNDEFINED> instruction: 0x00000abb
     c3c:	0ac10a05 	beq	ff043458 <__bss_end+0xff03a544>
     c40:	0a060000 	beq	180c48 <__bss_end+0x177d34>
     c44:	00000497 	muleq	r0, r7, r4
     c48:	12870a07 	addne	r0, r7, #28672	; 0x7000
     c4c:	00080000 	andeq	r0, r8, r0
     c50:	00042409 	andeq	r2, r4, r9, lsl #8
     c54:	38040500 	stmdacc	r4, {r8, sl}
     c58:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     c5c:	09b10c1d 	ldmibeq	r1!, {r0, r2, r3, r4, sl, fp}
     c60:	5c0a0000 	stcpl	0, cr0, [sl], {-0}
     c64:	00000009 	andeq	r0, r0, r9
     c68:	00078d0a 	andeq	r8, r7, sl, lsl #26
     c6c:	f80a0100 			; <UNDEFINED> instruction: 0xf80a0100
     c70:	02000008 	andeq	r0, r0, #8
     c74:	776f4c1b 			; <UNDEFINED> instruction: 0x776f4c1b
     c78:	0d000300 	stceq	3, cr0, [r0, #-0]
     c7c:	00001279 	andeq	r1, r0, r9, ror r2
     c80:	0728091c 			; <UNDEFINED> instruction: 0x0728091c
     c84:	00000d32 	andeq	r0, r0, r2, lsr sp
     c88:	00062907 	andeq	r2, r6, r7, lsl #18
     c8c:	33091000 	movwcc	r1, #36864	; 0x9000
     c90:	000a000a 	andeq	r0, sl, sl
     c94:	0ee10e00 	cdpeq	14, 14, cr0, cr1, cr0, {0}
     c98:	35090000 	strcc	r0, [r9, #-0]
     c9c:	0003950b 	andeq	r9, r3, fp, lsl #10
     ca0:	1a0e0000 	bne	380ca8 <__bss_end+0x377d94>
     ca4:	09000012 	stmdbeq	r0, {r1, r4}
     ca8:	004d0d36 	subeq	r0, sp, r6, lsr sp
     cac:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     cb0:	000004a3 	andeq	r0, r0, r3, lsr #9
     cb4:	37133709 	ldrcc	r3, [r3, -r9, lsl #14]
     cb8:	0800000d 	stmdaeq	r0, {r0, r2, r3}
     cbc:	0005b00e 	andeq	fp, r5, lr
     cc0:	13380900 	teqne	r8, #0, 18
     cc4:	00000d37 	andeq	r0, r0, r7, lsr sp
     cc8:	460e000c 	strmi	r0, [lr], -ip
     ccc:	09000006 	stmdbeq	r0, {r1, r2}
     cd0:	0d43202c 	stcleq	0, cr2, [r3, #-176]	; 0xffffff50
     cd4:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     cd8:	00000612 	andeq	r0, r0, r2, lsl r6
     cdc:	48412f09 	stmdami	r1, {r0, r3, r8, r9, sl, fp, sp}^
     ce0:	0400000d 	streq	r0, [r0], #-13
     ce4:	000caa0e 	andeq	sl, ip, lr, lsl #20
     ce8:	42310900 	eorsmi	r0, r1, #0, 18
     cec:	00000d48 	andeq	r0, r0, r8, asr #26
     cf0:	0f980e0c 	svceq	0x00980e0c
     cf4:	3b090000 	blcc	240cfc <__bss_end+0x237de8>
     cf8:	000d3712 	andeq	r3, sp, r2, lsl r7
     cfc:	9c0e1400 	cfstrsls	mvf1, [lr], {-0}
     d00:	0900000e 	stmdbeq	r0, {r1, r2, r3}
     d04:	01340e3d 	teqeq	r4, sp, lsr lr
     d08:	13180000 	tstne	r8, #0
     d0c:	00000cc2 	andeq	r0, r0, r2, asr #25
     d10:	a3084109 	movwge	r4, #33033	; 0x8109
     d14:	66000009 	strvs	r0, [r0], -r9
     d18:	02000003 	andeq	r0, r0, #3
     d1c:	00000a5a 	andeq	r0, r0, sl, asr sl
     d20:	00000a6f 	andeq	r0, r0, pc, ror #20
     d24:	000d5810 	andeq	r5, sp, r0, lsl r8
     d28:	004d1100 	subeq	r1, sp, r0, lsl #2
     d2c:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
     d30:	1100000d 	tstne	r0, sp
     d34:	00000d5e 	andeq	r0, r0, lr, asr sp
     d38:	0c8b1300 	stceq	3, cr1, [fp], {0}
     d3c:	43090000 	movwmi	r0, #36864	; 0x9000
     d40:	000c3308 	andeq	r3, ip, r8, lsl #6
     d44:	00036600 	andeq	r6, r3, r0, lsl #12
     d48:	0a880200 	beq	fe201550 <__bss_end+0xfe1f863c>
     d4c:	0a9d0000 	beq	fe740d54 <__bss_end+0xfe737e40>
     d50:	58100000 	ldmdapl	r0, {}	; <UNPREDICTABLE>
     d54:	1100000d 	tstne	r0, sp
     d58:	0000004d 	andeq	r0, r0, sp, asr #32
     d5c:	000d5e11 	andeq	r5, sp, r1, lsl lr
     d60:	0d5e1100 	ldfeqe	f1, [lr, #-0]
     d64:	13000000 	movwne	r0, #0
     d68:	00000f56 	andeq	r0, r0, r6, asr pc
     d6c:	a3084509 	movwge	r4, #34057	; 0x8509
     d70:	66000011 			; <UNDEFINED> instruction: 0x66000011
     d74:	02000003 	andeq	r0, r0, #3
     d78:	00000ab6 			; <UNDEFINED> instruction: 0x00000ab6
     d7c:	00000acb 	andeq	r0, r0, fp, asr #21
     d80:	000d5810 	andeq	r5, sp, r0, lsl r8
     d84:	004d1100 	subeq	r1, sp, r0, lsl #2
     d88:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
     d8c:	1100000d 	tstne	r0, sp
     d90:	00000d5e 	andeq	r0, r0, lr, asr sp
     d94:	10db1300 	sbcsne	r1, fp, r0, lsl #6
     d98:	47090000 	strmi	r0, [r9, -r0]
     d9c:	000f6908 	andeq	r6, pc, r8, lsl #18
     da0:	00036600 	andeq	r6, r3, r0, lsl #12
     da4:	0ae40200 	beq	ff9015ac <__bss_end+0xff8f8698>
     da8:	0af90000 	beq	ffe40db0 <__bss_end+0xffe37e9c>
     dac:	58100000 	ldmdapl	r0, {}	; <UNPREDICTABLE>
     db0:	1100000d 	tstne	r0, sp
     db4:	0000004d 	andeq	r0, r0, sp, asr #32
     db8:	000d5e11 	andeq	r5, sp, r1, lsl lr
     dbc:	0d5e1100 	ldfeqe	f1, [lr, #-0]
     dc0:	13000000 	movwne	r0, #0
     dc4:	0000059d 	muleq	r0, sp, r5
     dc8:	a0084909 	andge	r4, r8, r9, lsl #18
     dcc:	66000010 			; <UNDEFINED> instruction: 0x66000010
     dd0:	02000003 	andeq	r0, r0, #3
     dd4:	00000b12 	andeq	r0, r0, r2, lsl fp
     dd8:	00000b27 	andeq	r0, r0, r7, lsr #22
     ddc:	000d5810 	andeq	r5, sp, r0, lsl r8
     de0:	004d1100 	subeq	r1, sp, r0, lsl #2
     de4:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
     de8:	1100000d 	tstne	r0, sp
     dec:	00000d5e 	andeq	r0, r0, lr, asr sp
     df0:	0c701300 	ldcleq	3, cr1, [r0], #-0
     df4:	4b090000 	blmi	240dfc <__bss_end+0x237ee8>
     df8:	00090f08 	andeq	r0, r9, r8, lsl #30
     dfc:	00036600 	andeq	r6, r3, r0, lsl #12
     e00:	0b400200 	bleq	1001608 <__bss_end+0xff86f4>
     e04:	0b5a0000 	bleq	1680e0c <__bss_end+0x1677ef8>
     e08:	58100000 	ldmdapl	r0, {}	; <UNPREDICTABLE>
     e0c:	1100000d 	tstne	r0, sp
     e10:	0000004d 	andeq	r0, r0, sp, asr #32
     e14:	00098611 	andeq	r8, r9, r1, lsl r6
     e18:	0d5e1100 	ldfeqe	f1, [lr, #-0]
     e1c:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
     e20:	0000000d 	andeq	r0, r0, sp
     e24:	000a8113 	andeq	r8, sl, r3, lsl r1
     e28:	0c4f0900 	mcrreq	9, 0, r0, pc, cr0	; <UNPREDICTABLE>
     e2c:	00000dd3 	ldrdeq	r0, [r0], -r3
     e30:	0000004d 	andeq	r0, r0, sp, asr #32
     e34:	000b7302 	andeq	r7, fp, r2, lsl #6
     e38:	000b7900 	andeq	r7, fp, r0, lsl #18
     e3c:	0d581000 	ldcleq	0, cr1, [r8, #-0]
     e40:	14000000 	strne	r0, [r0], #-0
     e44:	000011d2 	ldrdeq	r1, [r0], -r2
     e48:	0a085109 	beq	215274 <__bss_end+0x20c360>
     e4c:	02000007 	andeq	r0, r0, #7
     e50:	00000b8e 	andeq	r0, r0, lr, lsl #23
     e54:	00000b99 	muleq	r0, r9, fp
     e58:	000d6410 	andeq	r6, sp, r0, lsl r4
     e5c:	004d1100 	subeq	r1, sp, r0, lsl #2
     e60:	13000000 	movwne	r0, #0
     e64:	00001279 	andeq	r1, r0, r9, ror r2
     e68:	63035409 	movwvs	r5, #13321	; 0x3409
     e6c:	6400000e 	strvs	r0, [r0], #-14
     e70:	0100000d 	tsteq	r0, sp
     e74:	00000bb2 			; <UNDEFINED> instruction: 0x00000bb2
     e78:	00000bbd 			; <UNDEFINED> instruction: 0x00000bbd
     e7c:	000d6410 	andeq	r6, sp, r0, lsl r4
     e80:	005e1100 	subseq	r1, lr, r0, lsl #2
     e84:	14000000 	strne	r0, [r0], #-0
     e88:	0000055d 	andeq	r0, r0, sp, asr r5
     e8c:	f3085709 	vabd.u8	d5, d8, d9
     e90:	0100000c 	tsteq	r0, ip
     e94:	00000bd2 	ldrdeq	r0, [r0], -r2
     e98:	00000be2 	andeq	r0, r0, r2, ror #23
     e9c:	000d6410 	andeq	r6, sp, r0, lsl r4
     ea0:	004d1100 	subeq	r1, sp, r0, lsl #2
     ea4:	3d110000 	ldccc	0, cr0, [r1, #-0]
     ea8:	00000009 	andeq	r0, r0, r9
     eac:	000efb13 	andeq	pc, lr, r3, lsl fp	; <UNPREDICTABLE>
     eb0:	12590900 	subsne	r0, r9, #0, 18
     eb4:	0000122b 	andeq	r1, r0, fp, lsr #4
     eb8:	0000093d 	andeq	r0, r0, sp, lsr r9
     ebc:	000bfb01 	andeq	pc, fp, r1, lsl #22
     ec0:	000c0600 	andeq	r0, ip, r0, lsl #12
     ec4:	0d581000 	ldcleq	0, cr1, [r8, #-0]
     ec8:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     ecc:	00000000 	andeq	r0, r0, r0
     ed0:	000cd614 	andeq	sp, ip, r4, lsl r6
     ed4:	085c0900 	ldmdaeq	ip, {r8, fp}^
     ed8:	00000af4 	strdeq	r0, [r0], -r4
     edc:	000c1b01 	andeq	r1, ip, r1, lsl #22
     ee0:	000c2b00 	andeq	r2, ip, r0, lsl #22
     ee4:	0d641000 	stcleq	0, cr1, [r4, #-0]
     ee8:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     eec:	11000000 	mrsne	r0, (UNDEF: 0)
     ef0:	00000366 	andeq	r0, r0, r6, ror #6
     ef4:	103c1300 	eorsne	r1, ip, r0, lsl #6
     ef8:	5f090000 	svcpl	0x00090000
     efc:	00052108 	andeq	r2, r5, r8, lsl #2
     f00:	00036600 	andeq	r6, r3, r0, lsl #12
     f04:	0c440100 	stfeqe	f0, [r4], {-0}
     f08:	0c4f0000 	mareq	acc0, r0, pc
     f0c:	64100000 	ldrvs	r0, [r0], #-0
     f10:	1100000d 	tstne	r0, sp
     f14:	0000004d 	andeq	r0, r0, sp, asr #32
     f18:	0eef1300 	cdpeq	3, 14, cr1, cr15, cr0, {0}
     f1c:	62090000 	andvs	r0, r9, #0
     f20:	00043908 	andeq	r3, r4, r8, lsl #18
     f24:	00036600 	andeq	r6, r3, r0, lsl #12
     f28:	0c680100 	stfeqe	f0, [r8], #-0
     f2c:	0c7d0000 	ldcleq	0, cr0, [sp], #-0
     f30:	64100000 	ldrvs	r0, [r0], #-0
     f34:	1100000d 	tstne	r0, sp
     f38:	0000004d 	andeq	r0, r0, sp, asr #32
     f3c:	00036611 	andeq	r6, r3, r1, lsl r6
     f40:	03661100 	cmneq	r6, #0, 2
     f44:	13000000 	movwne	r0, #0
     f48:	00001222 	andeq	r1, r0, r2, lsr #4
     f4c:	7f086409 	svcvc	0x00086409
     f50:	66000008 	strvs	r0, [r0], -r8
     f54:	01000003 	tsteq	r0, r3
     f58:	00000c96 	muleq	r0, r6, ip
     f5c:	00000cab 	andeq	r0, r0, fp, lsr #25
     f60:	000d6410 	andeq	r6, sp, r0, lsl r4
     f64:	004d1100 	subeq	r1, sp, r0, lsl #2
     f68:	66110000 	ldrvs	r0, [r1], -r0
     f6c:	11000003 	tstne	r0, r3
     f70:	00000366 	andeq	r0, r0, r6, ror #6
     f74:	0bc21400 	bleq	ff085f7c <__bss_end+0xff07d068>
     f78:	67090000 	strvs	r0, [r9, -r0]
     f7c:	0003f908 	andeq	pc, r3, r8, lsl #18
     f80:	0cc00100 	stfeqe	f0, [r0], {0}
     f84:	0cd00000 	ldcleq	0, cr0, [r0], {0}
     f88:	64100000 	ldrvs	r0, [r0], #-0
     f8c:	1100000d 	tstne	r0, sp
     f90:	0000004d 	andeq	r0, r0, sp, asr #32
     f94:	00098611 	andeq	r8, r9, r1, lsl r6
     f98:	8e140000 	cdphi	0, 1, cr0, cr4, cr0, {0}
     f9c:	0900000d 	stmdbeq	r0, {r0, r2, r3}
     fa0:	07b10869 	ldreq	r0, [r1, r9, ror #16]!
     fa4:	e5010000 	str	r0, [r1, #-0]
     fa8:	f500000c 			; <UNDEFINED> instruction: 0xf500000c
     fac:	1000000c 	andne	r0, r0, ip
     fb0:	00000d64 	andeq	r0, r0, r4, ror #26
     fb4:	00004d11 	andeq	r4, r0, r1, lsl sp
     fb8:	09861100 	stmibeq	r6, {r8, ip}
     fbc:	14000000 	strne	r0, [r0], #-0
     fc0:	000012e9 	andeq	r1, r0, r9, ror #5
     fc4:	41086c09 	tstmi	r8, r9, lsl #24
     fc8:	0100000a 	tsteq	r0, sl
     fcc:	00000d0a 	andeq	r0, r0, sl, lsl #26
     fd0:	00000d10 	andeq	r0, r0, r0, lsl sp
     fd4:	000d6410 	andeq	r6, sp, r0, lsl r4
     fd8:	24270000 	strtcs	r0, [r7], #-0
     fdc:	0900000c 	stmdbeq	r0, {r2, r3}
     fe0:	0eaa086f 	cdpeq	8, 10, cr0, cr10, cr15, {3}
     fe4:	21010000 	mrscs	r0, (UNDEF: 1)
     fe8:	1000000d 	andne	r0, r0, sp
     fec:	00000d64 	andeq	r0, r0, r4, ror #26
     ff0:	00039511 	andeq	r9, r3, r1, lsl r5
     ff4:	004d1100 	subeq	r1, sp, r0, lsl #2
     ff8:	00000000 	andeq	r0, r0, r0
     ffc:	0009b103 	andeq	fp, r9, r3, lsl #2
    1000:	be041800 	cdplt	8, 0, cr1, cr4, cr0, {0}
    1004:	18000009 	stmdane	r0, {r0, r3}
    1008:	00006a04 	andeq	r6, r0, r4, lsl #20
    100c:	0d3d0300 	ldceq	3, cr0, [sp, #-0]
    1010:	4d160000 	ldcmi	0, cr0, [r6, #-0]
    1014:	58000000 	stmdapl	r0, {}	; <UNPREDICTABLE>
    1018:	1700000d 	strne	r0, [r0, -sp]
    101c:	0000005e 	andeq	r0, r0, lr, asr r0
    1020:	04180001 	ldreq	r0, [r8], #-1
    1024:	00000d32 	andeq	r0, r0, r2, lsr sp
    1028:	004d0421 	subeq	r0, sp, r1, lsr #8
    102c:	04180000 	ldreq	r0, [r8], #-0
    1030:	000009b1 			; <UNDEFINED> instruction: 0x000009b1
    1034:	000bd61a 	andeq	sp, fp, sl, lsl r6
    1038:	16730900 	ldrbtne	r0, [r3], -r0, lsl #18
    103c:	000009b1 			; <UNDEFINED> instruction: 0x000009b1
    1040:	00129e28 	andseq	r9, r2, r8, lsr #28
    1044:	050e0100 	streq	r0, [lr, #-256]	; 0xffffff00
    1048:	00000038 	andeq	r0, r0, r8, lsr r0
    104c:	00008234 	andeq	r8, r0, r4, lsr r2
    1050:	000000dc 	ldrdeq	r0, [r0], -ip
    1054:	0dfa9c01 	ldcleq	12, cr9, [sl, #4]!
    1058:	61290000 			; <UNDEFINED> instruction: 0x61290000
    105c:	01000012 	tsteq	r0, r2, lsl r0
    1060:	00380e0e 	eorseq	r0, r8, lr, lsl #28
    1064:	91020000 	mrsls	r0, (UNDEF: 2)
    1068:	1140295c 	cmpne	r0, ip, asr r9
    106c:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    1070:	000dfa1b 	andeq	pc, sp, fp, lsl sl	; <UNPREDICTABLE>
    1074:	58910200 	ldmpl	r1, {r9}
    1078:	001aa82a 	andseq	sl, sl, sl, lsr #16
    107c:	07100100 	ldreq	r0, [r0, -r0, lsl #2]
    1080:	00000025 	andeq	r0, r0, r5, lsr #32
    1084:	2a6b9102 	bcs	1ae5494 <__bss_end+0x1adc580>
    1088:	000005b5 			; <UNDEFINED> instruction: 0x000005b5
    108c:	25071101 	strcs	r1, [r7, #-257]	; 0xfffffeff
    1090:	02000000 	andeq	r0, r0, #0
    1094:	d62a7791 			; <UNDEFINED> instruction: 0xd62a7791
    1098:	0100000e 	tsteq	r0, lr
    109c:	004d0b13 	subeq	r0, sp, r3, lsl fp
    10a0:	91020000 	mrsls	r0, (UNDEF: 2)
    10a4:	10352a70 	eorsne	r2, r5, r0, ror sl
    10a8:	16010000 	strne	r0, [r1], -r0
    10ac:	00098617 	andeq	r8, r9, r7, lsl r6
    10b0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    10b4:	0012f42a 	andseq	pc, r2, sl, lsr #8
    10b8:	0b1e0100 	bleq	7814c0 <__bss_end+0x7785ac>
    10bc:	0000004d 	andeq	r0, r0, sp, asr #32
    10c0:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    10c4:	0e000418 	cfmvdlreq	mvd0, r0
    10c8:	04180000 	ldreq	r0, [r8], #-0
    10cc:	00000025 	andeq	r0, r0, r5, lsr #32
    10d0:	000cd700 	andeq	sp, ip, r0, lsl #14
    10d4:	4c000400 	cfstrsmi	mvf0, [r0], {-0}
    10d8:	04000004 	streq	r0, [r0], #-4
    10dc:	00130f01 	andseq	r0, r3, r1, lsl #30
    10e0:	144b0400 	strbne	r0, [fp], #-1024	; 0xfffffc00
    10e4:	15020000 	strne	r0, [r2, #-0]
    10e8:	83100000 	tsthi	r0, #0
    10ec:	04600000 	strbteq	r0, [r0], #-0
    10f0:	04450000 	strbeq	r0, [r5], #-0
    10f4:	01020000 	mrseq	r0, (UNDEF: 2)
    10f8:	000dce08 	andeq	ip, sp, r8, lsl #28
    10fc:	00250300 	eoreq	r0, r5, r0, lsl #6
    1100:	02020000 	andeq	r0, r2, #0
    1104:	000e4205 	andeq	r4, lr, r5, lsl #4
    1108:	05040400 	streq	r0, [r4, #-1024]	; 0xfffffc00
    110c:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1110:	c5080102 	strgt	r0, [r8, #-258]	; 0xfffffefe
    1114:	0200000d 	andeq	r0, r0, #13
    1118:	0a040702 	beq	102d28 <__bss_end+0xf9e14>
    111c:	e6050000 	str	r0, [r5], -r0
    1120:	0700000e 	streq	r0, [r0, -lr]
    1124:	005e1e09 	subseq	r1, lr, r9, lsl #28
    1128:	4d030000 	stcmi	0, cr0, [r3, #-0]
    112c:	02000000 	andeq	r0, r0, #0
    1130:	1ccf0704 	stclne	7, cr0, [pc], {4}
    1134:	81060000 	mrshi	r0, (UNDEF: 6)
    1138:	08000007 	stmdaeq	r0, {r0, r1, r2}
    113c:	8b080602 	blhi	20294c <__bss_end+0x1f9a38>
    1140:	07000000 	streq	r0, [r0, -r0]
    1144:	02003072 	andeq	r3, r0, #114	; 0x72
    1148:	004d0e08 	subeq	r0, sp, r8, lsl #28
    114c:	07000000 	streq	r0, [r0, -r0]
    1150:	02003172 	andeq	r3, r0, #-2147483620	; 0x8000001c
    1154:	004d0e09 	subeq	r0, sp, r9, lsl #28
    1158:	00040000 	andeq	r0, r4, r0
    115c:	00162108 	andseq	r2, r6, r8, lsl #2
    1160:	38040500 	stmdacc	r4, {r8, sl}
    1164:	02000000 	andeq	r0, r0, #0
    1168:	00a90c0d 	adceq	r0, r9, sp, lsl #24
    116c:	4f090000 	svcmi	0x00090000
    1170:	0a00004b 	beq	12a4 <shift+0x12a4>
    1174:	0000148b 	andeq	r1, r0, fp, lsl #9
    1178:	e8080001 	stmda	r8, {r0}
    117c:	05000005 	streq	r0, [r0, #-5]
    1180:	00003804 	andeq	r3, r0, r4, lsl #16
    1184:	0c1e0200 	lfmeq	f0, 4, [lr], {-0}
    1188:	000000e0 	andeq	r0, r0, r0, ror #1
    118c:	0008360a 	andeq	r3, r8, sl, lsl #12
    1190:	d90a0000 	stmdble	sl, {}	; <UNPREDICTABLE>
    1194:	01000012 	tsteq	r0, r2, lsl r0
    1198:	0012a30a 	andseq	sl, r2, sl, lsl #6
    119c:	a60a0200 	strge	r0, [sl], -r0, lsl #4
    11a0:	0300000a 	movweq	r0, #10
    11a4:	000d2b0a 	andeq	r2, sp, sl, lsl #22
    11a8:	ff0a0400 			; <UNDEFINED> instruction: 0xff0a0400
    11ac:	05000007 	streq	r0, [r0, #-7]
    11b0:	118b0800 	orrne	r0, fp, r0, lsl #16
    11b4:	04050000 	streq	r0, [r5], #-0
    11b8:	00000038 	andeq	r0, r0, r8, lsr r0
    11bc:	1d0c3f02 	stcne	15, cr3, [ip, #-8]
    11c0:	0a000001 	beq	11cc <shift+0x11cc>
    11c4:	00000463 	andeq	r0, r0, r3, ror #8
    11c8:	06240a00 	strteq	r0, [r4], -r0, lsl #20
    11cc:	0a010000 	beq	411d4 <__bss_end+0x382c0>
    11d0:	00000ce6 	andeq	r0, r0, r6, ror #25
    11d4:	12540a02 	subsne	r0, r4, #8192	; 0x2000
    11d8:	0a030000 	beq	c11e0 <__bss_end+0xb82cc>
    11dc:	000012e3 	andeq	r1, r0, r3, ror #5
    11e0:	0c0a0a04 			; <UNDEFINED> instruction: 0x0c0a0a04
    11e4:	0a050000 	beq	1411ec <__bss_end+0x1382d8>
    11e8:	00000a24 	andeq	r0, r0, r4, lsr #20
    11ec:	45080006 	strmi	r0, [r8, #-6]
    11f0:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
    11f4:	00003804 	andeq	r3, r0, r4, lsl #16
    11f8:	0c660200 	sfmeq	f0, 2, [r6], #-0
    11fc:	00000148 	andeq	r0, r0, r8, asr #2
    1200:	000da30a 	andeq	sl, sp, sl, lsl #6
    1204:	e60a0000 	str	r0, [sl], -r0
    1208:	01000009 	tsteq	r0, r9
    120c:	000e4c0a 	andeq	r4, lr, sl, lsl #24
    1210:	290a0200 	stmdbcs	sl, {r9}
    1214:	0300000a 	movweq	r0, #10
    1218:	0c620b00 			; <UNDEFINED> instruction: 0x0c620b00
    121c:	05030000 	streq	r0, [r3, #-0]
    1220:	00005914 	andeq	r5, r0, r4, lsl r9
    1224:	b8030500 	stmdalt	r3, {r8, sl}
    1228:	0b00008e 	bleq	1468 <shift+0x1468>
    122c:	00000c9e 	muleq	r0, lr, ip
    1230:	59140603 	ldmdbpl	r4, {r0, r1, r9, sl}
    1234:	05000000 	streq	r0, [r0, #-0]
    1238:	008ebc03 	addeq	fp, lr, r3, lsl #24
    123c:	0bf40b00 	bleq	ffd03e44 <__bss_end+0xffcfaf30>
    1240:	07040000 	streq	r0, [r4, -r0]
    1244:	0000591a 	andeq	r5, r0, sl, lsl r9
    1248:	c0030500 	andgt	r0, r3, r0, lsl #10
    124c:	0b00008e 	bleq	148c <shift+0x148c>
    1250:	00000653 	andeq	r0, r0, r3, asr r6
    1254:	591a0904 	ldmdbpl	sl, {r2, r8, fp}
    1258:	05000000 	streq	r0, [r0, #-0]
    125c:	008ec403 	addeq	ip, lr, r3, lsl #8
    1260:	0db70b00 			; <UNDEFINED> instruction: 0x0db70b00
    1264:	0b040000 	bleq	10126c <__bss_end+0xf8358>
    1268:	0000591a 	andeq	r5, r0, sl, lsl r9
    126c:	c8030500 	stmdagt	r3, {r8, sl}
    1270:	0b00008e 	bleq	14b0 <shift+0x14b0>
    1274:	000009d3 	ldrdeq	r0, [r0], -r3
    1278:	591a0d04 	ldmdbpl	sl, {r2, r8, sl, fp}
    127c:	05000000 	streq	r0, [r0, #-0]
    1280:	008ecc03 	addeq	ip, lr, r3, lsl #24
    1284:	07a70b00 	streq	r0, [r7, r0, lsl #22]!
    1288:	0f040000 	svceq	0x00040000
    128c:	0000591a 	andeq	r5, r0, sl, lsl r9
    1290:	d0030500 	andle	r0, r3, r0, lsl #10
    1294:	0800008e 	stmdaeq	r0, {r1, r2, r3, r7}
    1298:	00000f46 	andeq	r0, r0, r6, asr #30
    129c:	00380405 	eorseq	r0, r8, r5, lsl #8
    12a0:	1b040000 	blne	1012a8 <__bss_end+0xf8394>
    12a4:	0001eb0c 	andeq	lr, r1, ip, lsl #22
    12a8:	0fb20a00 	svceq	0x00b20a00
    12ac:	0a000000 	beq	12b4 <shift+0x12b4>
    12b0:	00001293 	muleq	r0, r3, r2
    12b4:	0ce10a01 	vstmiaeq	r1!, {s1}
    12b8:	00020000 	andeq	r0, r2, r0
    12bc:	000d880c 	andeq	r8, sp, ip, lsl #16
    12c0:	0e270d00 	cdpeq	13, 2, cr0, cr7, cr0, {0}
    12c4:	04900000 	ldreq	r0, [r0], #0
    12c8:	035e0763 	cmpeq	lr, #25952256	; 0x18c0000
    12cc:	f6060000 			; <UNDEFINED> instruction: 0xf6060000
    12d0:	24000011 	strcs	r0, [r0], #-17	; 0xffffffef
    12d4:	78106704 	ldmdavc	r0, {r2, r8, r9, sl, sp, lr}
    12d8:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
    12dc:	000020b7 	strheq	r2, [r0], -r7
    12e0:	5e286904 	vmulpl.f16	s12, s16, s8	; <UNPREDICTABLE>
    12e4:	00000003 	andeq	r0, r0, r3
    12e8:	0005dc0e 	andeq	sp, r5, lr, lsl #24
    12ec:	206b0400 	rsbcs	r0, fp, r0, lsl #8
    12f0:	0000036e 	andeq	r0, r0, lr, ror #6
    12f4:	0fa70e10 	svceq	0x00a70e10
    12f8:	6d040000 	stcvs	0, cr0, [r4, #-0]
    12fc:	00004d23 	andeq	r4, r0, r3, lsr #26
    1300:	4c0e1400 	cfstrsmi	mvf1, [lr], {-0}
    1304:	04000006 	streq	r0, [r0], #-6
    1308:	03751c70 	cmneq	r5, #112, 24	; 0x7000
    130c:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
    1310:	00000dae 	andeq	r0, r0, lr, lsr #27
    1314:	751c7204 	ldrvc	r7, [ip, #-516]	; 0xfffffdfc
    1318:	1c000003 	stcne	0, cr0, [r0], {3}
    131c:	0005b00e 	andeq	fp, r5, lr
    1320:	1c750400 	cfldrdne	mvd0, [r5], #-0
    1324:	00000375 	andeq	r0, r0, r5, ror r3
    1328:	08480f20 	stmdaeq	r8, {r5, r8, r9, sl, fp}^
    132c:	77040000 	strvc	r0, [r4, -r0]
    1330:	0004de1c 	andeq	sp, r4, ip, lsl lr
    1334:	00037500 	andeq	r7, r3, r0, lsl #10
    1338:	00026c00 	andeq	r6, r2, r0, lsl #24
    133c:	03751000 	cmneq	r5, #0
    1340:	7b110000 	blvc	441348 <__bss_end+0x438434>
    1344:	00000003 	andeq	r0, r0, r3
    1348:	06bc0600 	ldrteq	r0, [ip], r0, lsl #12
    134c:	04180000 	ldreq	r0, [r8], #-0
    1350:	02ad107b 	adceq	r1, sp, #123	; 0x7b
    1354:	b70e0000 	strlt	r0, [lr, -r0]
    1358:	04000020 	streq	r0, [r0], #-32	; 0xffffffe0
    135c:	035e2c7e 	cmpeq	lr, #32256	; 0x7e00
    1360:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1364:	000005d1 	ldrdeq	r0, [r0], -r1
    1368:	7b198004 	blvc	661380 <__bss_end+0x65846c>
    136c:	10000003 	andne	r0, r0, r3
    1370:	00125a0e 	andseq	r5, r2, lr, lsl #20
    1374:	21820400 	orrcs	r0, r2, r0, lsl #8
    1378:	00000386 	andeq	r0, r0, r6, lsl #7
    137c:	78030014 	stmdavc	r3, {r2, r4}
    1380:	12000002 	andne	r0, r0, #2
    1384:	00000ba0 	andeq	r0, r0, r0, lsr #23
    1388:	8c218604 	stchi	6, cr8, [r1], #-16
    138c:	12000003 	andne	r0, r0, #3
    1390:	000008fd 	strdeq	r0, [r0], -sp
    1394:	591f8804 	ldmdbpl	pc, {r2, fp, pc}	; <UNPREDICTABLE>
    1398:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    139c:	00000e8a 	andeq	r0, r0, sl, lsl #29
    13a0:	fd178b04 	ldc2	11, cr8, [r7, #-16]	; <UNPREDICTABLE>
    13a4:	00000001 	andeq	r0, r0, r1
    13a8:	000aac0e 	andeq	sl, sl, lr, lsl #24
    13ac:	178e0400 	strne	r0, [lr, r0, lsl #8]
    13b0:	000001fd 	strdeq	r0, [r0], -sp
    13b4:	09680e24 	stmdbeq	r8!, {r2, r5, r9, sl, fp}^
    13b8:	8f040000 	svchi	0x00040000
    13bc:	0001fd17 	andeq	pc, r1, r7, lsl sp	; <UNPREDICTABLE>
    13c0:	c30e4800 	movwgt	r4, #59392	; 0xe800
    13c4:	04000012 	streq	r0, [r0], #-18	; 0xffffffee
    13c8:	01fd1790 			; <UNDEFINED> instruction: 0x01fd1790
    13cc:	136c0000 	cmnne	ip, #0
    13d0:	00000e27 	andeq	r0, r0, r7, lsr #28
    13d4:	a7099304 	strge	r9, [r9, -r4, lsl #6]
    13d8:	97000006 	strls	r0, [r0, -r6]
    13dc:	01000003 	tsteq	r0, r3
    13e0:	00000317 	andeq	r0, r0, r7, lsl r3
    13e4:	0000031d 	andeq	r0, r0, sp, lsl r3
    13e8:	00039710 	andeq	r9, r3, r0, lsl r7
    13ec:	4f140000 	svcmi	0x00140000
    13f0:	0400000b 	streq	r0, [r0], #-11
    13f4:	0a620e96 	beq	1884e54 <__bss_end+0x187bf40>
    13f8:	32010000 	andcc	r0, r1, #0
    13fc:	38000003 	stmdacc	r0, {r0, r1}
    1400:	10000003 	andne	r0, r0, r3
    1404:	00000397 	muleq	r0, r7, r3
    1408:	04631500 	strbteq	r1, [r3], #-1280	; 0xfffffb00
    140c:	99040000 	stmdbls	r4, {}	; <UNPREDICTABLE>
    1410:	000f2b10 	andeq	r2, pc, r0, lsl fp	; <UNPREDICTABLE>
    1414:	00039d00 	andeq	r9, r3, r0, lsl #26
    1418:	034d0100 	movteq	r0, #53504	; 0xd100
    141c:	97100000 	ldrls	r0, [r0, -r0]
    1420:	11000003 	tstne	r0, r3
    1424:	0000037b 	andeq	r0, r0, fp, ror r3
    1428:	0001c611 	andeq	ip, r1, r1, lsl r6
    142c:	16000000 	strne	r0, [r0], -r0
    1430:	00000025 	andeq	r0, r0, r5, lsr #32
    1434:	0000036e 	andeq	r0, r0, lr, ror #6
    1438:	00005e17 	andeq	r5, r0, r7, lsl lr
    143c:	02000f00 	andeq	r0, r0, #0, 30
    1440:	0ab60201 	beq	fed81c4c <__bss_end+0xfed78d38>
    1444:	04180000 	ldreq	r0, [r8], #-0
    1448:	000001fd 	strdeq	r0, [r0], -sp
    144c:	002c0418 	eoreq	r0, ip, r8, lsl r4
    1450:	660c0000 	strvs	r0, [ip], -r0
    1454:	18000012 	stmdane	r0, {r1, r4}
    1458:	00038104 	andeq	r8, r3, r4, lsl #2
    145c:	02ad1600 	adceq	r1, sp, #0, 12
    1460:	03970000 	orrseq	r0, r7, #0
    1464:	00190000 	andseq	r0, r9, r0
    1468:	01f00418 	mvnseq	r0, r8, lsl r4
    146c:	04180000 	ldreq	r0, [r8], #-0
    1470:	000001eb 	andeq	r0, r0, fp, ror #3
    1474:	000e901a 	andeq	r9, lr, sl, lsl r0
    1478:	149c0400 	ldrne	r0, [ip], #1024	; 0x400
    147c:	000001f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1480:	0008a90b 	andeq	sl, r8, fp, lsl #18
    1484:	14040500 	strne	r0, [r4], #-1280	; 0xfffffb00
    1488:	00000059 	andeq	r0, r0, r9, asr r0
    148c:	8ed40305 	cdphi	3, 13, cr0, cr4, cr5, {0}
    1490:	ee0b0000 	cdp	0, 0, cr0, cr11, cr0, {0}
    1494:	05000003 	streq	r0, [r0, #-3]
    1498:	00591407 	subseq	r1, r9, r7, lsl #8
    149c:	03050000 	movweq	r0, #20480	; 0x5000
    14a0:	00008ed8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    14a4:	0006830b 	andeq	r8, r6, fp, lsl #6
    14a8:	140a0500 	strne	r0, [sl], #-1280	; 0xfffffb00
    14ac:	00000059 	andeq	r0, r0, r9, asr r0
    14b0:	8edc0305 	cdphi	3, 13, cr0, cr12, cr5, {0}
    14b4:	1f080000 	svcne	0x00080000
    14b8:	0500000b 	streq	r0, [r0, #-11]
    14bc:	00003804 	andeq	r3, r0, r4, lsl #16
    14c0:	0c0d0500 	cfstr32eq	mvfx0, [sp], {-0}
    14c4:	0000041c 	andeq	r0, r0, ip, lsl r4
    14c8:	77654e09 	strbvc	r4, [r5, -r9, lsl #28]!
    14cc:	160a0000 	strne	r0, [sl], -r0
    14d0:	0100000b 	tsteq	r0, fp
    14d4:	000ea20a 	andeq	sl, lr, sl, lsl #4
    14d8:	d10a0200 	mrsle	r0, R10_fiq
    14dc:	0300000a 	movweq	r0, #10
    14e0:	000a980a 	andeq	r9, sl, sl, lsl #16
    14e4:	ec0a0400 	cfstrs	mvf0, [sl], {-0}
    14e8:	0500000c 	streq	r0, [r0, #-12]
    14ec:	07f20600 	ldrbeq	r0, [r2, r0, lsl #12]!
    14f0:	05100000 	ldreq	r0, [r0, #-0]
    14f4:	045b081b 	ldrbeq	r0, [fp], #-2075	; 0xfffff7e5
    14f8:	6c070000 	stcvs	0, cr0, [r7], {-0}
    14fc:	1d050072 	stcne	0, cr0, [r5, #-456]	; 0xfffffe38
    1500:	00045b13 	andeq	r5, r4, r3, lsl fp
    1504:	73070000 	movwvc	r0, #28672	; 0x7000
    1508:	1e050070 	mcrne	0, 0, r0, cr5, cr0, {3}
    150c:	00045b13 	andeq	r5, r4, r3, lsl fp
    1510:	70070400 	andvc	r0, r7, r0, lsl #8
    1514:	1f050063 	svcne	0x00050063
    1518:	00045b13 	andeq	r5, r4, r3, lsl fp
    151c:	080e0800 	stmdaeq	lr, {fp}
    1520:	05000008 	streq	r0, [r0, #-8]
    1524:	045b1320 	ldrbeq	r1, [fp], #-800	; 0xfffffce0
    1528:	000c0000 	andeq	r0, ip, r0
    152c:	ca070402 	bgt	1c253c <__bss_end+0x1b9628>
    1530:	0600001c 			; <UNDEFINED> instruction: 0x0600001c
    1534:	000004d1 	ldrdeq	r0, [r0], -r1
    1538:	08280570 	stmdaeq	r8!, {r4, r5, r6, r8, sl}
    153c:	000004f2 	strdeq	r0, [r0], -r2
    1540:	0012cd0e 	andseq	ip, r2, lr, lsl #26
    1544:	122a0500 	eorne	r0, sl, #0, 10
    1548:	0000041c 	andeq	r0, r0, ip, lsl r4
    154c:	69700700 	ldmdbvs	r0!, {r8, r9, sl}^
    1550:	2b050064 	blcs	1416e8 <__bss_end+0x1387d4>
    1554:	00005e12 	andeq	r5, r0, r2, lsl lr
    1558:	a80e1000 	stmdage	lr, {ip}
    155c:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    1560:	03e5112c 	mvneq	r1, #44, 2
    1564:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
    1568:	00000b2b 	andeq	r0, r0, fp, lsr #22
    156c:	5e122d05 	cdppl	13, 1, cr2, cr2, cr5, {0}
    1570:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    1574:	000b390e 	andeq	r3, fp, lr, lsl #18
    1578:	122e0500 	eorne	r0, lr, #0, 10
    157c:	0000005e 	andeq	r0, r0, lr, asr r0
    1580:	079a0e1c 			; <UNDEFINED> instruction: 0x079a0e1c
    1584:	2f050000 	svccs	0x00050000
    1588:	0004f231 	andeq	pc, r4, r1, lsr r2	; <UNPREDICTABLE>
    158c:	ac0e2000 	stcge	0, cr2, [lr], {-0}
    1590:	0500000b 	streq	r0, [r0, #-11]
    1594:	00380930 	eorseq	r0, r8, r0, lsr r9
    1598:	0e600000 	cdpeq	0, 6, cr0, cr0, cr0, {0}
    159c:	00000fbc 			; <UNDEFINED> instruction: 0x00000fbc
    15a0:	4d0e3105 	stfmis	f3, [lr, #-20]	; 0xffffffec
    15a4:	64000000 	strvs	r0, [r0], #-0
    15a8:	00085c0e 	andeq	r5, r8, lr, lsl #24
    15ac:	0e330500 	cfabs32eq	mvfx0, mvfx3
    15b0:	0000004d 	andeq	r0, r0, sp, asr #32
    15b4:	08530e68 	ldmdaeq	r3, {r3, r5, r6, r9, sl, fp}^
    15b8:	34050000 	strcc	r0, [r5], #-0
    15bc:	00004d0e 	andeq	r4, r0, lr, lsl #26
    15c0:	16006c00 	strne	r6, [r0], -r0, lsl #24
    15c4:	0000039d 	muleq	r0, sp, r3
    15c8:	00000502 	andeq	r0, r0, r2, lsl #10
    15cc:	00005e17 	andeq	r5, r0, r7, lsl lr
    15d0:	0b000f00 	bleq	51d8 <shift+0x51d8>
    15d4:	000011e7 	andeq	r1, r0, r7, ror #3
    15d8:	59140a06 	ldmdbpl	r4, {r1, r2, r9, fp}
    15dc:	05000000 	streq	r0, [r0, #-0]
    15e0:	008ee003 	addeq	lr, lr, r3
    15e4:	0ad90800 	beq	ff6435ec <__bss_end+0xff63a6d8>
    15e8:	04050000 	streq	r0, [r5], #-0
    15ec:	00000038 	andeq	r0, r0, r8, lsr r0
    15f0:	330c0d06 	movwcc	r0, #52486	; 0xcd06
    15f4:	0a000005 	beq	1610 <shift+0x1610>
    15f8:	000005fd 	strdeq	r0, [r0], -sp
    15fc:	03e30a00 	mvneq	r0, #0, 20
    1600:	00010000 	andeq	r0, r1, r0
    1604:	00051403 	andeq	r1, r5, r3, lsl #8
    1608:	15740800 	ldrbne	r0, [r4, #-2048]!	; 0xfffff800
    160c:	04050000 	streq	r0, [r5], #-0
    1610:	00000038 	andeq	r0, r0, r8, lsr r0
    1614:	570c1406 	strpl	r1, [ip, -r6, lsl #8]
    1618:	0a000005 	beq	1634 <shift+0x1634>
    161c:	00001302 	andeq	r1, r0, r2, lsl #6
    1620:	15f30a00 	ldrbne	r0, [r3, #2560]!	; 0xa00
    1624:	00010000 	andeq	r0, r1, r0
    1628:	00053803 	andeq	r3, r5, r3, lsl #16
    162c:	108d0600 	addne	r0, sp, r0, lsl #12
    1630:	060c0000 	streq	r0, [ip], -r0
    1634:	0591081b 	ldreq	r0, [r1, #2075]	; 0x81b
    1638:	a30e0000 	movwge	r0, #57344	; 0xe000
    163c:	06000004 	streq	r0, [r0], -r4
    1640:	0591191d 	ldreq	r1, [r1, #2333]	; 0x91d
    1644:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1648:	000005b0 			; <UNDEFINED> instruction: 0x000005b0
    164c:	91191e06 	tstls	r9, r6, lsl #28
    1650:	04000005 	streq	r0, [r0], #-5
    1654:	0010300e 	andseq	r3, r0, lr
    1658:	131f0600 	tstne	pc, #0, 12
    165c:	00000597 	muleq	r0, r7, r5
    1660:	04180008 	ldreq	r0, [r8], #-8
    1664:	0000055c 	andeq	r0, r0, ip, asr r5
    1668:	04620418 	strbteq	r0, [r2], #-1048	; 0xfffffbe8
    166c:	960d0000 	strls	r0, [sp], -r0
    1670:	14000006 	strne	r0, [r0], #-6
    1674:	1f072206 	svcne	0x00072206
    1678:	0e000008 	cdpeq	0, 0, cr0, cr0, cr8, {0}
    167c:	00000ac7 	andeq	r0, r0, r7, asr #21
    1680:	4d122606 	ldcmi	6, cr2, [r2, #-24]	; 0xffffffe8
    1684:	00000000 	andeq	r0, r0, r0
    1688:	00054a0e 	andeq	r4, r5, lr, lsl #20
    168c:	1d290600 	stcne	6, cr0, [r9, #-0]
    1690:	00000591 	muleq	r0, r1, r5
    1694:	0f180e04 	svceq	0x00180e04
    1698:	2c060000 	stccs	0, cr0, [r6], {-0}
    169c:	0005911d 	andeq	r9, r5, sp, lsl r1
    16a0:	811b0800 	tsthi	fp, r0, lsl #16
    16a4:	06000011 			; <UNDEFINED> instruction: 0x06000011
    16a8:	106a0e2f 	rsbne	r0, sl, pc, lsr #28
    16ac:	05e50000 	strbeq	r0, [r5, #0]!
    16b0:	05f00000 	ldrbeq	r0, [r0, #0]!
    16b4:	24100000 	ldrcs	r0, [r0], #-0
    16b8:	11000008 	tstne	r0, r8
    16bc:	00000591 	muleq	r0, r1, r5
    16c0:	10461c00 	subne	r1, r6, r0, lsl #24
    16c4:	31060000 	mrscc	r0, (UNDEF: 6)
    16c8:	0004a80e 	andeq	sl, r4, lr, lsl #16
    16cc:	00036e00 	andeq	r6, r3, r0, lsl #28
    16d0:	00060800 	andeq	r0, r6, r0, lsl #16
    16d4:	00061300 	andeq	r1, r6, r0, lsl #6
    16d8:	08241000 	stmdaeq	r4!, {ip}
    16dc:	97110000 	ldrls	r0, [r1, -r0]
    16e0:	00000005 	andeq	r0, r0, r5
    16e4:	0010cf13 	andseq	ip, r0, r3, lsl pc
    16e8:	1d350600 	ldcne	6, cr0, [r5, #-0]
    16ec:	0000100b 	andeq	r1, r0, fp
    16f0:	00000591 	muleq	r0, r1, r5
    16f4:	00062c02 	andeq	r2, r6, r2, lsl #24
    16f8:	00063200 	andeq	r3, r6, r0, lsl #4
    16fc:	08241000 	stmdaeq	r4!, {ip}
    1700:	13000000 	movwne	r0, #0
    1704:	00000a17 	andeq	r0, r0, r7, lsl sl
    1708:	011d3706 	tsteq	sp, r6, lsl #14
    170c:	9100000e 	tstls	r0, lr
    1710:	02000005 	andeq	r0, r0, #5
    1714:	0000064b 	andeq	r0, r0, fp, asr #12
    1718:	00000651 	andeq	r0, r0, r1, asr r6
    171c:	00082410 	andeq	r2, r8, r0, lsl r4
    1720:	dc1d0000 	ldcle	0, cr0, [sp], {-0}
    1724:	0600000b 	streq	r0, [r0], -fp
    1728:	083d4439 	ldmdaeq	sp!, {r0, r3, r4, r5, sl, lr}
    172c:	020c0000 	andeq	r0, ip, #0
    1730:	00069613 	andeq	r9, r6, r3, lsl r6
    1734:	093c0600 	ldmdbeq	ip!, {r9, sl}
    1738:	000012a9 	andeq	r1, r0, r9, lsr #5
    173c:	00000824 	andeq	r0, r0, r4, lsr #16
    1740:	00067801 	andeq	r7, r6, r1, lsl #16
    1744:	00067e00 	andeq	r7, r6, r0, lsl #28
    1748:	08241000 	stmdaeq	r4!, {ip}
    174c:	13000000 	movwne	r0, #0
    1750:	00000637 	andeq	r0, r0, r7, lsr r6
    1754:	56123f06 	ldrpl	r3, [r2], -r6, lsl #30
    1758:	4d000011 	stcmi	0, cr0, [r0, #-68]	; 0xffffffbc
    175c:	01000000 	mrseq	r0, (UNDEF: 0)
    1760:	00000697 	muleq	r0, r7, r6
    1764:	000006ac 	andeq	r0, r0, ip, lsr #13
    1768:	00082410 	andeq	r2, r8, r0, lsl r4
    176c:	08461100 	stmdaeq	r6, {r8, ip}^
    1770:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
    1774:	11000000 	mrsne	r0, (UNDEF: 0)
    1778:	0000036e 	andeq	r0, r0, lr, ror #6
    177c:	10551400 	subsne	r1, r5, r0, lsl #8
    1780:	42060000 	andmi	r0, r6, #0
    1784:	000d3a0e 	andeq	r3, sp, lr, lsl #20
    1788:	06c10100 	strbeq	r0, [r1], r0, lsl #2
    178c:	06c70000 	strbeq	r0, [r7], r0
    1790:	24100000 	ldrcs	r0, [r0], #-0
    1794:	00000008 	andeq	r0, r0, r8
    1798:	00097b13 	andeq	r7, r9, r3, lsl fp
    179c:	17450600 	strbne	r0, [r5, -r0, lsl #12]
    17a0:	0000056f 	andeq	r0, r0, pc, ror #10
    17a4:	00000597 	muleq	r0, r7, r5
    17a8:	0006e001 	andeq	lr, r6, r1
    17ac:	0006e600 	andeq	lr, r6, r0, lsl #12
    17b0:	084c1000 	stmdaeq	ip, {ip}^
    17b4:	13000000 	movwne	r0, #0
    17b8:	000005be 			; <UNDEFINED> instruction: 0x000005be
    17bc:	c8174806 	ldmdagt	r7, {r1, r2, fp, lr}
    17c0:	9700000f 	strls	r0, [r0, -pc]
    17c4:	01000005 	tsteq	r0, r5
    17c8:	000006ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    17cc:	0000070a 	andeq	r0, r0, sl, lsl #14
    17d0:	00084c10 	andeq	r4, r8, r0, lsl ip
    17d4:	004d1100 	subeq	r1, sp, r0, lsl #2
    17d8:	14000000 	strne	r0, [r0], #-0
    17dc:	00001204 	andeq	r1, r0, r4, lsl #4
    17e0:	680e4b06 	stmdavs	lr, {r1, r2, r8, r9, fp, lr}
    17e4:	01000004 	tsteq	r0, r4
    17e8:	0000071f 	andeq	r0, r0, pc, lsl r7
    17ec:	00000725 	andeq	r0, r0, r5, lsr #14
    17f0:	00082410 	andeq	r2, r8, r0, lsl r4
    17f4:	46130000 	ldrmi	r0, [r3], -r0
    17f8:	06000010 			; <UNDEFINED> instruction: 0x06000010
    17fc:	080e0e4d 	stmdaeq	lr, {r0, r2, r3, r6, r9, sl, fp}
    1800:	036e0000 	cmneq	lr, #0
    1804:	3e010000 	cdpcc	0, 0, cr0, cr1, cr0, {0}
    1808:	49000007 	stmdbmi	r0, {r0, r1, r2}
    180c:	10000007 	andne	r0, r0, r7
    1810:	00000824 	andeq	r0, r0, r4, lsr #16
    1814:	00004d11 	andeq	r4, r0, r1, lsl sp
    1818:	8f130000 	svchi	0x00130000
    181c:	06000009 	streq	r0, [r0], -r9
    1820:	0d5b1250 	lfmeq	f1, 2, [fp, #-320]	; 0xfffffec0
    1824:	004d0000 	subeq	r0, sp, r0
    1828:	62010000 	andvs	r0, r1, #0
    182c:	6d000007 	stcvs	0, cr0, [r0, #-28]	; 0xffffffe4
    1830:	10000007 	andne	r0, r0, r7
    1834:	00000824 	andeq	r0, r0, r4, lsr #16
    1838:	00039d11 	andeq	r9, r3, r1, lsl sp
    183c:	0e130000 	cdpeq	0, 1, cr0, cr3, cr0, {0}
    1840:	06000005 	streq	r0, [r0], -r5
    1844:	08c20e53 	stmiaeq	r2, {r0, r1, r4, r6, r9, sl, fp}^
    1848:	036e0000 	cmneq	lr, #0
    184c:	86010000 	strhi	r0, [r1], -r0
    1850:	91000007 	tstls	r0, r7
    1854:	10000007 	andne	r0, r0, r7
    1858:	00000824 	andeq	r0, r0, r4, lsr #16
    185c:	00004d11 	andeq	r4, r0, r1, lsl sp
    1860:	f1140000 			; <UNDEFINED> instruction: 0xf1140000
    1864:	06000009 	streq	r0, [r0], -r9
    1868:	10ee0e56 	rscne	r0, lr, r6, asr lr
    186c:	a6010000 	strge	r0, [r1], -r0
    1870:	c5000007 	strgt	r0, [r0, #-7]
    1874:	10000007 	andne	r0, r0, r7
    1878:	00000824 	andeq	r0, r0, r4, lsr #16
    187c:	0000a911 	andeq	sl, r0, r1, lsl r9
    1880:	004d1100 	subeq	r1, sp, r0, lsl #2
    1884:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1888:	11000000 	mrsne	r0, (UNDEF: 0)
    188c:	0000004d 	andeq	r0, r0, sp, asr #32
    1890:	00085211 	andeq	r5, r8, r1, lsl r2
    1894:	f5140000 			; <UNDEFINED> instruction: 0xf5140000
    1898:	0600000f 	streq	r0, [r0], -pc
    189c:	07350e58 			; <UNDEFINED> instruction: 0x07350e58
    18a0:	da010000 	ble	418a8 <__bss_end+0x38994>
    18a4:	f9000007 			; <UNDEFINED> instruction: 0xf9000007
    18a8:	10000007 	andne	r0, r0, r7
    18ac:	00000824 	andeq	r0, r0, r4, lsr #16
    18b0:	0000e011 	andeq	lr, r0, r1, lsl r0
    18b4:	004d1100 	subeq	r1, sp, r0, lsl #2
    18b8:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    18bc:	11000000 	mrsne	r0, (UNDEF: 0)
    18c0:	0000004d 	andeq	r0, r0, sp, asr #32
    18c4:	00085211 	andeq	r5, r8, r1, lsl r2
    18c8:	65150000 	ldrvs	r0, [r5, #-0]
    18cc:	06000006 	streq	r0, [r0], -r6
    18d0:	06c70e5b 			; <UNDEFINED> instruction: 0x06c70e5b
    18d4:	036e0000 	cmneq	lr, #0
    18d8:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    18dc:	10000008 	andne	r0, r0, r8
    18e0:	00000824 	andeq	r0, r0, r4, lsr #16
    18e4:	00051411 	andeq	r1, r5, r1, lsl r4
    18e8:	08581100 	ldmdaeq	r8, {r8, ip}^
    18ec:	00000000 	andeq	r0, r0, r0
    18f0:	00059d03 	andeq	r9, r5, r3, lsl #26
    18f4:	9d041800 	stcls	8, cr1, [r4, #-0]
    18f8:	1e000005 	cdpne	0, 0, cr0, cr0, cr5, {0}
    18fc:	00000591 	muleq	r0, r1, r5
    1900:	00000837 	andeq	r0, r0, r7, lsr r8
    1904:	0000083d 	andeq	r0, r0, sp, lsr r8
    1908:	00082410 	andeq	r2, r8, r0, lsl r4
    190c:	9d1f0000 	ldcls	0, cr0, [pc, #-0]	; 1914 <shift+0x1914>
    1910:	2a000005 	bcs	192c <shift+0x192c>
    1914:	18000008 	stmdane	r0, {r3}
    1918:	00003f04 	andeq	r3, r0, r4, lsl #30
    191c:	1f041800 	svcne	0x00041800
    1920:	20000008 	andcs	r0, r0, r8
    1924:	00006504 	andeq	r6, r0, r4, lsl #10
    1928:	1a042100 	bne	109d30 <__bss_end+0x100e1c>
    192c:	0000105e 	andeq	r1, r0, lr, asr r0
    1930:	9d195e06 	ldcls	14, cr5, [r9, #-24]	; 0xffffffe8
    1934:	16000005 	strne	r0, [r0], -r5
    1938:	0000002c 	andeq	r0, r0, ip, lsr #32
    193c:	00000876 	andeq	r0, r0, r6, ror r8
    1940:	00005e17 	andeq	r5, r0, r7, lsl lr
    1944:	03000900 	movweq	r0, #2304	; 0x900
    1948:	00000866 	andeq	r0, r0, r6, ror #16
    194c:	0014d722 	andseq	sp, r4, r2, lsr #14
    1950:	0ca40100 	stfeqs	f0, [r4]
    1954:	00000876 	andeq	r0, r0, r6, ror r8
    1958:	8ee40305 	cdphi	3, 14, cr0, cr4, cr5, {0}
    195c:	f7230000 			; <UNDEFINED> instruction: 0xf7230000
    1960:	01000012 	tsteq	r0, r2, lsl r0
    1964:	15680aa6 	strbne	r0, [r8, #-2726]!	; 0xfffff55a
    1968:	004d0000 	subeq	r0, sp, r0
    196c:	86bc0000 	ldrthi	r0, [ip], r0
    1970:	00b40000 	adcseq	r0, r4, r0
    1974:	9c010000 	stcls	0, cr0, [r1], {-0}
    1978:	000008eb 	andeq	r0, r0, fp, ror #17
    197c:	0020b724 	eoreq	fp, r0, r4, lsr #14
    1980:	1ba60100 	blne	fe981d88 <__bss_end+0xfe978e74>
    1984:	0000037b 	andeq	r0, r0, fp, ror r3
    1988:	7fac9103 	svcvc	0x00ac9103
    198c:	0015c724 	andseq	ip, r5, r4, lsr #14
    1990:	2aa60100 	bcs	fe981d98 <__bss_end+0xfe978e84>
    1994:	0000004d 	andeq	r0, r0, sp, asr #32
    1998:	7fa89103 	svcvc	0x00a89103
    199c:	00155022 	andseq	r5, r5, r2, lsr #32
    19a0:	0aa80100 	beq	fea01da8 <__bss_end+0xfe9f8e94>
    19a4:	000008eb 	andeq	r0, r0, fp, ror #17
    19a8:	7fb49103 	svcvc	0x00b49103
    19ac:	0013f922 	andseq	pc, r3, r2, lsr #18
    19b0:	09ac0100 	stmibeq	ip!, {r8}
    19b4:	00000038 	andeq	r0, r0, r8, lsr r0
    19b8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    19bc:	00002516 	andeq	r2, r0, r6, lsl r5
    19c0:	0008fb00 	andeq	pc, r8, r0, lsl #22
    19c4:	005e1700 	subseq	r1, lr, r0, lsl #14
    19c8:	003f0000 	eorseq	r0, pc, r0
    19cc:	0015ac25 	andseq	sl, r5, r5, lsr #24
    19d0:	0a980100 	beq	fe601dd8 <__bss_end+0xfe5f8ec4>
    19d4:	00001601 	andeq	r1, r0, r1, lsl #12
    19d8:	0000004d 	andeq	r0, r0, sp, asr #32
    19dc:	00008680 	andeq	r8, r0, r0, lsl #13
    19e0:	0000003c 	andeq	r0, r0, ip, lsr r0
    19e4:	09389c01 	ldmdbeq	r8!, {r0, sl, fp, ip, pc}
    19e8:	72260000 	eorvc	r0, r6, #0
    19ec:	01007165 	tsteq	r0, r5, ror #2
    19f0:	0557209a 	ldrbeq	r2, [r7, #-154]	; 0xffffff66
    19f4:	91020000 	mrsls	r0, (UNDEF: 2)
    19f8:	155d2274 	ldrbne	r2, [sp, #-628]	; 0xfffffd8c
    19fc:	9b010000 	blls	41a04 <__bss_end+0x38af0>
    1a00:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1a04:	70910200 	addsvc	r0, r1, r0, lsl #4
    1a08:	15d62700 	ldrbne	r2, [r6, #1792]	; 0x700
    1a0c:	8f010000 	svchi	0x00010000
    1a10:	00141506 	andseq	r1, r4, r6, lsl #10
    1a14:	00864400 	addeq	r4, r6, r0, lsl #8
    1a18:	00003c00 	andeq	r3, r0, r0, lsl #24
    1a1c:	719c0100 	orrsvc	r0, ip, r0, lsl #2
    1a20:	24000009 	strcs	r0, [r0], #-9
    1a24:	000014c3 	andeq	r1, r0, r3, asr #9
    1a28:	4d218f01 	stcmi	15, cr8, [r1, #-4]!
    1a2c:	02000000 	andeq	r0, r0, #0
    1a30:	72266c91 	eorvc	r6, r6, #37120	; 0x9100
    1a34:	01007165 	tsteq	r0, r5, ror #2
    1a38:	05572091 	ldrbeq	r2, [r7, #-145]	; 0xffffff6f
    1a3c:	91020000 	mrsls	r0, (UNDEF: 2)
    1a40:	89250074 	stmdbhi	r5!, {r2, r4, r5, r6}
    1a44:	01000015 	tsteq	r0, r5, lsl r0
    1a48:	14e80a83 	strbtne	r0, [r8], #2691	; 0xa83
    1a4c:	004d0000 	subeq	r0, sp, r0
    1a50:	86080000 	strhi	r0, [r8], -r0
    1a54:	003c0000 	eorseq	r0, ip, r0
    1a58:	9c010000 	stcls	0, cr0, [r1], {-0}
    1a5c:	000009ae 	andeq	r0, r0, lr, lsr #19
    1a60:	71657226 	cmnvc	r5, r6, lsr #4
    1a64:	20850100 	addcs	r0, r5, r0, lsl #2
    1a68:	00000533 	andeq	r0, r0, r3, lsr r5
    1a6c:	22749102 	rsbscs	r9, r4, #-2147483648	; 0x80000000
    1a70:	000013f2 	strdeq	r1, [r0], -r2
    1a74:	4d0e8601 	stcmi	6, cr8, [lr, #-4]
    1a78:	02000000 	andeq	r0, r0, #0
    1a7c:	25007091 	strcs	r7, [r0, #-145]	; 0xffffff6f
    1a80:	00001698 	muleq	r0, r8, r6
    1a84:	990a7701 	stmdbls	sl, {r0, r8, r9, sl, ip, sp, lr}
    1a88:	4d000014 	stcmi	0, cr0, [r0, #-80]	; 0xffffffb0
    1a8c:	cc000000 	stcgt	0, cr0, [r0], {-0}
    1a90:	3c000085 	stccc	0, cr0, [r0], {133}	; 0x85
    1a94:	01000000 	mrseq	r0, (UNDEF: 0)
    1a98:	0009eb9c 	muleq	r9, ip, fp
    1a9c:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1aa0:	79010071 	stmdbvc	r1, {r0, r4, r5, r6}
    1aa4:	00053320 	andeq	r3, r5, r0, lsr #6
    1aa8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1aac:	0013f222 	andseq	pc, r3, r2, lsr #4
    1ab0:	0e7a0100 	rpweqe	f0, f2, f0
    1ab4:	0000004d 	andeq	r0, r0, sp, asr #32
    1ab8:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1abc:	0014fc25 	andseq	pc, r4, r5, lsr #24
    1ac0:	066b0100 	strbteq	r0, [fp], -r0, lsl #2
    1ac4:	000015e8 	andeq	r1, r0, r8, ror #11
    1ac8:	0000036e 	andeq	r0, r0, lr, ror #6
    1acc:	00008578 	andeq	r8, r0, r8, ror r5
    1ad0:	00000054 	andeq	r0, r0, r4, asr r0
    1ad4:	0a379c01 	beq	de8ae0 <__bss_end+0xddfbcc>
    1ad8:	5d240000 	stcpl	0, cr0, [r4, #-0]
    1adc:	01000015 	tsteq	r0, r5, lsl r0
    1ae0:	004d156b 	subeq	r1, sp, fp, ror #10
    1ae4:	91020000 	mrsls	r0, (UNDEF: 2)
    1ae8:	0853246c 	ldmdaeq	r3, {r2, r3, r5, r6, sl, sp}^
    1aec:	6b010000 	blvs	41af4 <__bss_end+0x38be0>
    1af0:	00004d25 	andeq	r4, r0, r5, lsr #26
    1af4:	68910200 	ldmvs	r1, {r9}
    1af8:	00169022 	andseq	r9, r6, r2, lsr #32
    1afc:	0e6d0100 	poweqe	f0, f5, f0
    1b00:	0000004d 	andeq	r0, r0, sp, asr #32
    1b04:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1b08:	00142c25 	andseq	r2, r4, r5, lsr #24
    1b0c:	125e0100 	subsne	r0, lr, #0, 2
    1b10:	00001638 	andeq	r1, r0, r8, lsr r6
    1b14:	0000008b 	andeq	r0, r0, fp, lsl #1
    1b18:	00008528 	andeq	r8, r0, r8, lsr #10
    1b1c:	00000050 	andeq	r0, r0, r0, asr r0
    1b20:	0a929c01 	beq	fe4a8b2c <__bss_end+0xfe49fc18>
    1b24:	e1240000 			; <UNDEFINED> instruction: 0xe1240000
    1b28:	0100000e 	tsteq	r0, lr
    1b2c:	004d205e 	subeq	r2, sp, lr, asr r0
    1b30:	91020000 	mrsls	r0, (UNDEF: 2)
    1b34:	1592246c 	ldrne	r2, [r2, #1132]	; 0x46c
    1b38:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1b3c:	00004d2f 	andeq	r4, r0, pc, lsr #26
    1b40:	68910200 	ldmvs	r1, {r9}
    1b44:	00085324 	andeq	r5, r8, r4, lsr #6
    1b48:	3f5e0100 	svccc	0x005e0100
    1b4c:	0000004d 	andeq	r0, r0, sp, asr #32
    1b50:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1b54:	00001690 	muleq	r0, r0, r6
    1b58:	8b166001 	blhi	599b64 <__bss_end+0x590c50>
    1b5c:	02000000 	andeq	r0, r0, #0
    1b60:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1b64:	00001556 	andeq	r1, r0, r6, asr r5
    1b68:	310a5201 	tstcc	sl, r1, lsl #4
    1b6c:	4d000014 	stcmi	0, cr0, [r0, #-80]	; 0xffffffb0
    1b70:	e4000000 	str	r0, [r0], #-0
    1b74:	44000084 	strmi	r0, [r0], #-132	; 0xffffff7c
    1b78:	01000000 	mrseq	r0, (UNDEF: 0)
    1b7c:	000ade9c 	muleq	sl, ip, lr
    1b80:	0ee12400 	cdpeq	4, 14, cr2, cr1, cr0, {0}
    1b84:	52010000 	andpl	r0, r1, #0
    1b88:	00004d1a 	andeq	r4, r0, sl, lsl sp
    1b8c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1b90:	00159224 	andseq	r9, r5, r4, lsr #4
    1b94:	29520100 	ldmdbcs	r2, {r8}^
    1b98:	0000004d 	andeq	r0, r0, sp, asr #32
    1b9c:	22689102 	rsbcs	r9, r8, #-2147483648	; 0x80000000
    1ba0:	00001667 	andeq	r1, r0, r7, ror #12
    1ba4:	4d0e5401 	cfstrsmi	mvf5, [lr, #-4]
    1ba8:	02000000 	andeq	r0, r0, #0
    1bac:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1bb0:	00001661 	andeq	r1, r0, r1, ror #12
    1bb4:	430a4501 	movwmi	r4, #42241	; 0xa501
    1bb8:	4d000016 	stcmi	0, cr0, [r0, #-88]	; 0xffffffa8
    1bbc:	94000000 	strls	r0, [r0], #-0
    1bc0:	50000084 	andpl	r0, r0, r4, lsl #1
    1bc4:	01000000 	mrseq	r0, (UNDEF: 0)
    1bc8:	000b399c 	muleq	fp, ip, r9
    1bcc:	0ee12400 	cdpeq	4, 14, cr2, cr1, cr0, {0}
    1bd0:	45010000 	strmi	r0, [r1, #-0]
    1bd4:	00004d19 	andeq	r4, r0, r9, lsl sp
    1bd8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1bdc:	00153124 	andseq	r3, r5, r4, lsr #2
    1be0:	30450100 	subcc	r0, r5, r0, lsl #2
    1be4:	0000011d 	andeq	r0, r0, sp, lsl r1
    1be8:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1bec:	00001598 	muleq	r0, r8, r5
    1bf0:	58414501 	stmdapl	r1, {r0, r8, sl, lr}^
    1bf4:	02000008 	andeq	r0, r0, #8
    1bf8:	90226491 	mlals	r2, r1, r4, r6
    1bfc:	01000016 	tsteq	r0, r6, lsl r0
    1c00:	004d0e47 	subeq	r0, sp, r7, asr #28
    1c04:	91020000 	mrsls	r0, (UNDEF: 2)
    1c08:	fc270074 	stc2	0, cr0, [r7], #-464	; 0xfffffe30
    1c0c:	01000012 	tsteq	r0, r2, lsl r0
    1c10:	153b063f 	ldrne	r0, [fp, #-1599]!	; 0xfffff9c1
    1c14:	84680000 	strbthi	r0, [r8], #-0
    1c18:	002c0000 	eoreq	r0, ip, r0
    1c1c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1c20:	00000b63 	andeq	r0, r0, r3, ror #22
    1c24:	000ee124 	andeq	lr, lr, r4, lsr #2
    1c28:	153f0100 	ldrne	r0, [pc, #-256]!	; 1b30 <shift+0x1b30>
    1c2c:	0000004d 	andeq	r0, r0, sp, asr #32
    1c30:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1c34:	0015d025 	andseq	sp, r5, r5, lsr #32
    1c38:	0a320100 	beq	c82040 <__bss_end+0xc7912c>
    1c3c:	0000159e 	muleq	r0, lr, r5
    1c40:	0000004d 	andeq	r0, r0, sp, asr #32
    1c44:	00008418 	andeq	r8, r0, r8, lsl r4
    1c48:	00000050 	andeq	r0, r0, r0, asr r0
    1c4c:	0bbe9c01 	bleq	fefa8c58 <__bss_end+0xfef9fd44>
    1c50:	e1240000 			; <UNDEFINED> instruction: 0xe1240000
    1c54:	0100000e 	tsteq	r0, lr
    1c58:	004d1932 	subeq	r1, sp, r2, lsr r9
    1c5c:	91020000 	mrsls	r0, (UNDEF: 2)
    1c60:	167d246c 	ldrbtne	r2, [sp], -ip, ror #8
    1c64:	32010000 	andcc	r0, r1, #0
    1c68:	00037b2b 	andeq	r7, r3, fp, lsr #22
    1c6c:	68910200 	ldmvs	r1, {r9}
    1c70:	0015cb24 	andseq	ip, r5, r4, lsr #22
    1c74:	3c320100 	ldfccs	f0, [r2], #-0
    1c78:	0000004d 	andeq	r0, r0, sp, asr #32
    1c7c:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1c80:	00001632 	andeq	r1, r0, r2, lsr r6
    1c84:	4d0e3401 	cfstrsmi	mvf3, [lr, #-4]
    1c88:	02000000 	andeq	r0, r0, #0
    1c8c:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1c90:	000016ba 			; <UNDEFINED> instruction: 0x000016ba
    1c94:	840a2501 	strhi	r2, [sl], #-1281	; 0xfffffaff
    1c98:	4d000016 	stcmi	0, cr0, [r0, #-88]	; 0xffffffa8
    1c9c:	c8000000 	stmdagt	r0, {}	; <UNPREDICTABLE>
    1ca0:	50000083 	andpl	r0, r0, r3, lsl #1
    1ca4:	01000000 	mrseq	r0, (UNDEF: 0)
    1ca8:	000c199c 	muleq	ip, ip, r9
    1cac:	0ee12400 	cdpeq	4, 14, cr2, cr1, cr0, {0}
    1cb0:	25010000 	strcs	r0, [r1, #-0]
    1cb4:	00004d18 	andeq	r4, r0, r8, lsl sp
    1cb8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1cbc:	00167d24 	andseq	r7, r6, r4, lsr #26
    1cc0:	2a250100 	bcs	9420c8 <__bss_end+0x9391b4>
    1cc4:	00000c1f 	andeq	r0, r0, pc, lsl ip
    1cc8:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1ccc:	000015cb 	andeq	r1, r0, fp, asr #11
    1cd0:	4d3b2501 	cfldr32mi	mvfx2, [fp, #-4]!
    1cd4:	02000000 	andeq	r0, r0, #0
    1cd8:	fe226491 	mcr2	4, 1, r6, cr2, cr1, {4}
    1cdc:	01000013 	tsteq	r0, r3, lsl r0
    1ce0:	004d0e27 	subeq	r0, sp, r7, lsr #28
    1ce4:	91020000 	mrsls	r0, (UNDEF: 2)
    1ce8:	04180074 	ldreq	r0, [r8], #-116	; 0xffffff8c
    1cec:	00000025 	andeq	r0, r0, r5, lsr #32
    1cf0:	000c1903 	andeq	r1, ip, r3, lsl #18
    1cf4:	15632500 	strbne	r2, [r3, #-1280]!	; 0xfffffb00
    1cf8:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    1cfc:	0016c60a 	andseq	ip, r6, sl, lsl #12
    1d00:	00004d00 	andeq	r4, r0, r0, lsl #26
    1d04:	00838400 	addeq	r8, r3, r0, lsl #8
    1d08:	00004400 	andeq	r4, r0, r0, lsl #8
    1d0c:	709c0100 	addsvc	r0, ip, r0, lsl #2
    1d10:	2400000c 	strcs	r0, [r0], #-12
    1d14:	000016b1 			; <UNDEFINED> instruction: 0x000016b1
    1d18:	7b1b1901 	blvc	6c8124 <__bss_end+0x6bf210>
    1d1c:	02000003 	andeq	r0, r0, #3
    1d20:	78246c91 	stmdavc	r4!, {r0, r4, r7, sl, fp, sp, lr}
    1d24:	01000016 	tsteq	r0, r6, lsl r0
    1d28:	01c63519 	biceq	r3, r6, r9, lsl r5
    1d2c:	91020000 	mrsls	r0, (UNDEF: 2)
    1d30:	0ee12268 	cdpeq	2, 14, cr2, cr1, cr8, {3}
    1d34:	1b010000 	blne	41d3c <__bss_end+0x38e28>
    1d38:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1d3c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1d40:	14b72800 	ldrtne	r2, [r7], #2048	; 0x800
    1d44:	14010000 	strne	r0, [r1], #-0
    1d48:	00140406 	andseq	r0, r4, r6, lsl #8
    1d4c:	00836800 	addeq	r6, r3, r0, lsl #16
    1d50:	00001c00 	andeq	r1, r0, r0, lsl #24
    1d54:	279c0100 	ldrcs	r0, [ip, r0, lsl #2]
    1d58:	0000166e 	andeq	r1, r0, lr, ror #12
    1d5c:	3d060e01 	stccc	14, cr0, [r6, #-4]
    1d60:	3c000014 	stccc	0, cr0, [r0], {20}
    1d64:	2c000083 	stccs	0, cr0, [r0], {131}	; 0x83
    1d68:	01000000 	mrseq	r0, (UNDEF: 0)
    1d6c:	000cb09c 	muleq	ip, ip, r0
    1d70:	14902400 	ldrne	r2, [r0], #1024	; 0x400
    1d74:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    1d78:	00003814 	andeq	r3, r0, r4, lsl r8
    1d7c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1d80:	16bf2900 	ldrtne	r2, [pc], r0, lsl #18
    1d84:	04010000 	streq	r0, [r1], #-0
    1d88:	0015450a 	andseq	r4, r5, sl, lsl #10
    1d8c:	00004d00 	andeq	r4, r0, r0, lsl #26
    1d90:	00831000 	addeq	r1, r3, r0
    1d94:	00002c00 	andeq	r2, r0, r0, lsl #24
    1d98:	269c0100 	ldrcs	r0, [ip], r0, lsl #2
    1d9c:	00646970 	rsbeq	r6, r4, r0, ror r9
    1da0:	4d0e0601 	stcmi	6, cr0, [lr, #-4]
    1da4:	02000000 	andeq	r0, r0, #0
    1da8:	00007491 	muleq	r0, r1, r4
    1dac:	0000032e 	andeq	r0, r0, lr, lsr #6
    1db0:	06f70004 	ldrbteq	r0, [r7], r4
    1db4:	01040000 	mrseq	r0, (UNDEF: 4)
    1db8:	0000130f 	andeq	r1, r0, pc, lsl #6
    1dbc:	00170604 	andseq	r0, r7, r4, lsl #12
    1dc0:	00150200 	andseq	r0, r5, r0, lsl #4
    1dc4:	00877000 	addeq	r7, r7, r0
    1dc8:	0004b800 	andeq	fp, r4, r0, lsl #16
    1dcc:	0006ec00 	andeq	lr, r6, r0, lsl #24
    1dd0:	00490200 	subeq	r0, r9, r0, lsl #4
    1dd4:	48030000 	stmdami	r3, {}	; <UNPREDICTABLE>
    1dd8:	01000017 	tsteq	r0, r7, lsl r0
    1ddc:	00611005 	rsbeq	r1, r1, r5
    1de0:	30110000 	andscc	r0, r1, r0
    1de4:	34333231 	ldrtcc	r3, [r3], #-561	; 0xfffffdcf
    1de8:	38373635 	ldmdacc	r7!, {r0, r2, r4, r5, r9, sl, ip, sp}
    1dec:	43424139 	movtmi	r4, #8505	; 0x2139
    1df0:	00464544 	subeq	r4, r6, r4, asr #10
    1df4:	03010400 	movweq	r0, #5120	; 0x1400
    1df8:	00002501 	andeq	r2, r0, r1, lsl #10
    1dfc:	00740500 	rsbseq	r0, r4, r0, lsl #10
    1e00:	00610000 	rsbeq	r0, r1, r0
    1e04:	66060000 	strvs	r0, [r6], -r0
    1e08:	10000000 	andne	r0, r0, r0
    1e0c:	00510700 	subseq	r0, r1, r0, lsl #14
    1e10:	04080000 	streq	r0, [r8], #-0
    1e14:	001ccf07 	andseq	ip, ip, r7, lsl #30
    1e18:	08010800 	stmdaeq	r1, {fp}
    1e1c:	00000dce 	andeq	r0, r0, lr, asr #27
    1e20:	00006d07 	andeq	r6, r0, r7, lsl #26
    1e24:	002a0900 	eoreq	r0, sl, r0, lsl #18
    1e28:	770a0000 	strvc	r0, [sl, -r0]
    1e2c:	01000017 	tsteq	r0, r7, lsl r0
    1e30:	17620664 	strbne	r0, [r2, -r4, ror #12]!
    1e34:	8ba80000 	blhi	fea01e3c <__bss_end+0xfe9f8f28>
    1e38:	00800000 	addeq	r0, r0, r0
    1e3c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1e40:	000000fb 	strdeq	r0, [r0], -fp
    1e44:	6372730b 	cmnvs	r2, #738197504	; 0x2c000000
    1e48:	19640100 	stmdbne	r4!, {r8}^
    1e4c:	000000fb 	strdeq	r0, [r0], -fp
    1e50:	0b649102 	bleq	1926260 <__bss_end+0x191d34c>
    1e54:	00747364 	rsbseq	r7, r4, r4, ror #6
    1e58:	02246401 	eoreq	r6, r4, #16777216	; 0x1000000
    1e5c:	02000001 	andeq	r0, r0, #1
    1e60:	6e0b6091 	mcrvs	0, 0, r6, cr11, cr1, {4}
    1e64:	01006d75 	tsteq	r0, r5, ror sp
    1e68:	01042d64 	tsteq	r4, r4, ror #26
    1e6c:	91020000 	mrsls	r0, (UNDEF: 2)
    1e70:	17dc0c5c 			; <UNDEFINED> instruction: 0x17dc0c5c
    1e74:	66010000 	strvs	r0, [r1], -r0
    1e78:	00010b0e 	andeq	r0, r1, lr, lsl #22
    1e7c:	70910200 	addsvc	r0, r1, r0, lsl #4
    1e80:	0017540c 	andseq	r5, r7, ip, lsl #8
    1e84:	08670100 	stmdaeq	r7!, {r8}^
    1e88:	00000111 	andeq	r0, r0, r1, lsl r1
    1e8c:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    1e90:	00008bd0 	ldrdeq	r8, [r0], -r0
    1e94:	00000048 	andeq	r0, r0, r8, asr #32
    1e98:	0100690e 	tsteq	r0, lr, lsl #18
    1e9c:	01040b69 	tsteq	r4, r9, ror #22
    1ea0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ea4:	0f000074 	svceq	0x00000074
    1ea8:	00010104 	andeq	r0, r1, r4, lsl #2
    1eac:	04111000 	ldreq	r1, [r1], #-0
    1eb0:	69050412 	stmdbvs	r5, {r1, r4, sl}
    1eb4:	0f00746e 	svceq	0x0000746e
    1eb8:	00007404 	andeq	r7, r0, r4, lsl #8
    1ebc:	6d040f00 	stcvs	15, cr0, [r4, #-0]
    1ec0:	0a000000 	beq	1ec8 <shift+0x1ec8>
    1ec4:	000016ed 	andeq	r1, r0, sp, ror #13
    1ec8:	fa065c01 	blx	198ed4 <__bss_end+0x18ffc0>
    1ecc:	40000016 	andmi	r0, r0, r6, lsl r0
    1ed0:	6800008b 	stmdavs	r0, {r0, r1, r3, r7}
    1ed4:	01000000 	mrseq	r0, (UNDEF: 0)
    1ed8:	0001769c 	muleq	r1, ip, r6
    1edc:	17d51300 	ldrbne	r1, [r5, r0, lsl #6]
    1ee0:	5c010000 	stcpl	0, cr0, [r1], {-0}
    1ee4:	00010212 	andeq	r0, r1, r2, lsl r2
    1ee8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1eec:	0016f313 	andseq	pc, r6, r3, lsl r3	; <UNPREDICTABLE>
    1ef0:	1e5c0100 	rdfnee	f0, f4, f0
    1ef4:	00000104 	andeq	r0, r0, r4, lsl #2
    1ef8:	0e689102 	lgneqe	f1, f2
    1efc:	006d656d 	rsbeq	r6, sp, sp, ror #10
    1f00:	11085e01 	tstne	r8, r1, lsl #28
    1f04:	02000001 	andeq	r0, r0, #1
    1f08:	5c0d7091 	stcpl	0, cr7, [sp], {145}	; 0x91
    1f0c:	3c00008b 	stccc	0, cr0, [r0], {139}	; 0x8b
    1f10:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1f14:	60010069 	andvs	r0, r1, r9, rrx
    1f18:	0001040b 	andeq	r0, r1, fp, lsl #8
    1f1c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1f20:	7e140000 	cdpvc	0, 1, cr0, cr4, cr0, {0}
    1f24:	01000017 	tsteq	r0, r7, lsl r0
    1f28:	17970552 			; <UNDEFINED> instruction: 0x17970552
    1f2c:	01040000 	mrseq	r0, (UNDEF: 4)
    1f30:	8aec0000 	bhi	ffb01f38 <__bss_end+0xffaf9024>
    1f34:	00540000 	subseq	r0, r4, r0
    1f38:	9c010000 	stcls	0, cr0, [r1], {-0}
    1f3c:	000001af 	andeq	r0, r0, pc, lsr #3
    1f40:	0100730b 	tsteq	r0, fp, lsl #6
    1f44:	010b1852 	tsteq	fp, r2, asr r8
    1f48:	91020000 	mrsls	r0, (UNDEF: 2)
    1f4c:	00690e6c 	rsbeq	r0, r9, ip, ror #28
    1f50:	04065401 	streq	r5, [r6], #-1025	; 0xfffffbff
    1f54:	02000001 	andeq	r0, r0, #1
    1f58:	14007491 	strne	r7, [r0], #-1169	; 0xfffffb6f
    1f5c:	000017c5 	andeq	r1, r0, r5, asr #15
    1f60:	85054201 	strhi	r4, [r5, #-513]	; 0xfffffdff
    1f64:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    1f68:	40000001 	andmi	r0, r0, r1
    1f6c:	ac00008a 	stcge	0, cr0, [r0], {138}	; 0x8a
    1f70:	01000000 	mrseq	r0, (UNDEF: 0)
    1f74:	0002159c 	muleq	r2, ip, r5
    1f78:	31730b00 	cmncc	r3, r0, lsl #22
    1f7c:	19420100 	stmdbne	r2, {r8}^
    1f80:	0000010b 	andeq	r0, r0, fp, lsl #2
    1f84:	0b6c9102 	bleq	1b26394 <__bss_end+0x1b1d480>
    1f88:	01003273 	tsteq	r0, r3, ror r2
    1f8c:	010b2942 	tsteq	fp, r2, asr #18
    1f90:	91020000 	mrsls	r0, (UNDEF: 2)
    1f94:	756e0b68 	strbvc	r0, [lr, #-2920]!	; 0xfffff498
    1f98:	4201006d 	andmi	r0, r1, #109	; 0x6d
    1f9c:	00010431 	andeq	r0, r1, r1, lsr r4
    1fa0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1fa4:	0031750e 	eorseq	r7, r1, lr, lsl #10
    1fa8:	15104401 	ldrne	r4, [r0, #-1025]	; 0xfffffbff
    1fac:	02000002 	andeq	r0, r0, #2
    1fb0:	750e7791 	strvc	r7, [lr, #-1937]	; 0xfffff86f
    1fb4:	44010032 	strmi	r0, [r1], #-50	; 0xffffffce
    1fb8:	00021514 	andeq	r1, r2, r4, lsl r5
    1fbc:	76910200 	ldrvc	r0, [r1], r0, lsl #4
    1fc0:	08010800 	stmdaeq	r1, {fp}
    1fc4:	00000dc5 	andeq	r0, r0, r5, asr #27
    1fc8:	0017cd14 	andseq	ip, r7, r4, lsl sp
    1fcc:	07360100 	ldreq	r0, [r6, -r0, lsl #2]!
    1fd0:	000017b4 			; <UNDEFINED> instruction: 0x000017b4
    1fd4:	00000111 	andeq	r0, r0, r1, lsl r1
    1fd8:	00008980 	andeq	r8, r0, r0, lsl #19
    1fdc:	000000c0 	andeq	r0, r0, r0, asr #1
    1fe0:	02759c01 	rsbseq	r9, r5, #256	; 0x100
    1fe4:	e8130000 	ldmda	r3, {}	; <UNPREDICTABLE>
    1fe8:	01000016 	tsteq	r0, r6, lsl r0
    1fec:	01111536 	tsteq	r1, r6, lsr r5
    1ff0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ff4:	72730b6c 	rsbsvc	r0, r3, #108, 22	; 0x1b000
    1ff8:	36010063 	strcc	r0, [r1], -r3, rrx
    1ffc:	00010b27 	andeq	r0, r1, r7, lsr #22
    2000:	68910200 	ldmvs	r1, {r9}
    2004:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    2008:	30360100 	eorscc	r0, r6, r0, lsl #2
    200c:	00000104 	andeq	r0, r0, r4, lsl #2
    2010:	0e649102 	lgneqs	f1, f2
    2014:	38010069 	stmdacc	r1, {r0, r3, r5, r6}
    2018:	00010406 	andeq	r0, r1, r6, lsl #8
    201c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2020:	17a41400 	strne	r1, [r4, r0, lsl #8]!
    2024:	24010000 	strcs	r0, [r1], #-0
    2028:	0017a905 	andseq	sl, r7, r5, lsl #18
    202c:	00010400 	andeq	r0, r1, r0, lsl #8
    2030:	0088e400 	addeq	lr, r8, r0, lsl #8
    2034:	00009c00 	andeq	r9, r0, r0, lsl #24
    2038:	b29c0100 	addslt	r0, ip, #0, 2
    203c:	13000002 	movwne	r0, #2
    2040:	000016e2 	andeq	r1, r0, r2, ror #13
    2044:	0b162401 	bleq	58b050 <__bss_end+0x58213c>
    2048:	02000001 	andeq	r0, r0, #1
    204c:	5b0c6c91 	blpl	31d298 <__bss_end+0x314384>
    2050:	01000017 	tsteq	r0, r7, lsl r0
    2054:	01040626 	tsteq	r4, r6, lsr #12
    2058:	91020000 	mrsls	r0, (UNDEF: 2)
    205c:	e3150074 	tst	r5, #116	; 0x74
    2060:	01000017 	tsteq	r0, r7, lsl r0
    2064:	17e80608 	strbne	r0, [r8, r8, lsl #12]!
    2068:	87700000 	ldrbhi	r0, [r0, -r0]!
    206c:	01740000 	cmneq	r4, r0
    2070:	9c010000 	stcls	0, cr0, [r1], {-0}
    2074:	0016e213 	andseq	lr, r6, r3, lsl r2
    2078:	18080100 	stmdane	r8, {r8}
    207c:	00000066 	andeq	r0, r0, r6, rrx
    2080:	13649102 	cmnne	r4, #-2147483648	; 0x80000000
    2084:	0000175b 	andeq	r1, r0, fp, asr r7
    2088:	11250801 			; <UNDEFINED> instruction: 0x11250801
    208c:	02000001 	andeq	r0, r0, #1
    2090:	72136091 	andsvc	r6, r3, #145	; 0x91
    2094:	01000017 	tsteq	r0, r7, lsl r0
    2098:	00663a08 	rsbeq	r3, r6, r8, lsl #20
    209c:	91020000 	mrsls	r0, (UNDEF: 2)
    20a0:	00690e5c 	rsbeq	r0, r9, ip, asr lr
    20a4:	04060a01 	streq	r0, [r6], #-2561	; 0xfffff5ff
    20a8:	02000001 	andeq	r0, r0, #1
    20ac:	3c0d7491 	cfstrscc	mvf7, [sp], {145}	; 0x91
    20b0:	98000088 	stmdals	r0, {r3, r7}
    20b4:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    20b8:	1c01006a 	stcne	0, cr0, [r1], {106}	; 0x6a
    20bc:	0001040b 	andeq	r0, r1, fp, lsl #8
    20c0:	70910200 	addsvc	r0, r1, r0, lsl #4
    20c4:	0088640d 	addeq	r6, r8, sp, lsl #8
    20c8:	00006000 	andeq	r6, r0, r0
    20cc:	00630e00 	rsbeq	r0, r3, r0, lsl #28
    20d0:	6d081e01 	stcvs	14, cr1, [r8, #-4]
    20d4:	02000000 	andeq	r0, r0, #0
    20d8:	00006f91 	muleq	r0, r1, pc	; <UNPREDICTABLE>
    20dc:	00220000 	eoreq	r0, r2, r0
    20e0:	00020000 	andeq	r0, r2, r0
    20e4:	0000081e 	andeq	r0, r0, lr, lsl r8
    20e8:	09220104 	stmdbeq	r2!, {r2, r8}
    20ec:	8c280000 	stchi	0, cr0, [r8], #-0
    20f0:	8e340000 	cdphi	0, 3, cr0, cr4, cr0, {0}
    20f4:	17f40000 	ldrbne	r0, [r4, r0]!
    20f8:	18240000 	stmdane	r4!, {}	; <UNPREDICTABLE>
    20fc:	18890000 	stmne	r9, {}	; <UNPREDICTABLE>
    2100:	80010000 	andhi	r0, r1, r0
    2104:	00000022 	andeq	r0, r0, r2, lsr #32
    2108:	08320002 	ldmdaeq	r2!, {r1}
    210c:	01040000 	mrseq	r0, (UNDEF: 4)
    2110:	0000099f 	muleq	r0, pc, r9	; <UNPREDICTABLE>
    2114:	00008e34 	andeq	r8, r0, r4, lsr lr
    2118:	00008e38 	andeq	r8, r0, r8, lsr lr
    211c:	000017f4 	strdeq	r1, [r0], -r4
    2120:	00001824 	andeq	r1, r0, r4, lsr #16
    2124:	00001889 	andeq	r1, r0, r9, lsl #17
    2128:	0a098001 	beq	262134 <__bss_end+0x259220>
    212c:	00040000 	andeq	r0, r4, r0
    2130:	00000846 	andeq	r0, r0, r6, asr #16
    2134:	29290104 	stmdbcs	r9!, {r2, r8}
    2138:	6b0c0000 	blvs	302140 <__bss_end+0x2f922c>
    213c:	2400001b 	strcs	r0, [r0], #-27	; 0xffffffe5
    2140:	ff000018 			; <UNDEFINED> instruction: 0xff000018
    2144:	02000009 	andeq	r0, r0, #9
    2148:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    214c:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    2150:	001ccf07 	andseq	ip, ip, r7, lsl #30
    2154:	05080300 	streq	r0, [r8, #-768]	; 0xfffffd00
    2158:	0000035f 	andeq	r0, r0, pc, asr r3
    215c:	70040803 	andvc	r0, r4, r3, lsl #16
    2160:	04000024 	streq	r0, [r0], #-36	; 0xffffffdc
    2164:	00001bd8 	ldrdeq	r1, [r0], -r8
    2168:	24162a01 	ldrcs	r2, [r6], #-2561	; 0xfffff5ff
    216c:	04000000 	streq	r0, [r0], #-0
    2170:	0000203b 	andeq	r2, r0, fp, lsr r0
    2174:	51152f01 	tstpl	r5, r1, lsl #30
    2178:	05000000 	streq	r0, [r0, #-0]
    217c:	00005704 	andeq	r5, r0, r4, lsl #14
    2180:	00390600 	eorseq	r0, r9, r0, lsl #12
    2184:	00660000 	rsbeq	r0, r6, r0
    2188:	66070000 	strvs	r0, [r7], -r0
    218c:	00000000 	andeq	r0, r0, r0
    2190:	006c0405 	rsbeq	r0, ip, r5, lsl #8
    2194:	04080000 	streq	r0, [r8], #-0
    2198:	000028da 	ldrdeq	r2, [r0], -sl
    219c:	790f3601 	stmdbvc	pc, {r0, r9, sl, ip, sp}	; <UNPREDICTABLE>
    21a0:	05000000 	streq	r0, [r0, #-0]
    21a4:	00007f04 	andeq	r7, r0, r4, lsl #30
    21a8:	001d0600 	andseq	r0, sp, r0, lsl #12
    21ac:	00930000 	addseq	r0, r3, r0
    21b0:	66070000 	strvs	r0, [r7], -r0
    21b4:	07000000 	streq	r0, [r0, -r0]
    21b8:	00000066 	andeq	r0, r0, r6, rrx
    21bc:	08010300 	stmdaeq	r1, {r8, r9}
    21c0:	00000dc5 	andeq	r0, r0, r5, asr #27
    21c4:	00229e09 	eoreq	r9, r2, r9, lsl #28
    21c8:	12bb0100 	adcsne	r0, fp, #0, 2
    21cc:	00000045 	andeq	r0, r0, r5, asr #32
    21d0:	00290809 	eoreq	r0, r9, r9, lsl #16
    21d4:	10be0100 	adcsne	r0, lr, r0, lsl #2
    21d8:	0000006d 	andeq	r0, r0, sp, rrx
    21dc:	c7060103 	strgt	r0, [r6, -r3, lsl #2]
    21e0:	0a00000d 	beq	221c <shift+0x221c>
    21e4:	00001f42 	andeq	r1, r0, r2, asr #30
    21e8:	00930107 	addseq	r0, r3, r7, lsl #2
    21ec:	17020000 	strne	r0, [r2, -r0]
    21f0:	0001e606 	andeq	lr, r1, r6, lsl #12
    21f4:	1a3f0b00 	bne	fc4dfc <__bss_end+0xfbbee8>
    21f8:	0b000000 	bleq	2200 <shift+0x2200>
    21fc:	00001e3a 	andeq	r1, r0, sl, lsr lr
    2200:	23960b01 	orrscs	r0, r6, #1024	; 0x400
    2204:	0b020000 	bleq	8220c <__bss_end+0x792f8>
    2208:	0000281e 	andeq	r2, r0, lr, lsl r8
    220c:	23220b03 			; <UNDEFINED> instruction: 0x23220b03
    2210:	0b040000 	bleq	102218 <__bss_end+0xf9304>
    2214:	000026e5 	andeq	r2, r0, r5, ror #13
    2218:	260b0b05 	strcs	r0, [fp], -r5, lsl #22
    221c:	0b060000 	bleq	182224 <__bss_end+0x179310>
    2220:	00001a60 	andeq	r1, r0, r0, ror #20
    2224:	26fa0b07 	ldrbtcs	r0, [sl], r7, lsl #22
    2228:	0b080000 	bleq	202230 <__bss_end+0x1f931c>
    222c:	00002708 	andeq	r2, r0, r8, lsl #14
    2230:	27f90b09 	ldrbcs	r0, [r9, r9, lsl #22]!
    2234:	0b0a0000 	bleq	28223c <__bss_end+0x279328>
    2238:	00002264 	andeq	r2, r0, r4, ror #4
    223c:	1c190b0b 			; <UNDEFINED> instruction: 0x1c190b0b
    2240:	0b0c0000 	bleq	302248 <__bss_end+0x2f9334>
    2244:	00001fcb 	andeq	r1, r0, fp, asr #31
    2248:	27510b0d 	ldrbcs	r0, [r1, -sp, lsl #22]
    224c:	0b0e0000 	bleq	382254 <__bss_end+0x379340>
    2250:	00001f86 	andeq	r1, r0, r6, lsl #31
    2254:	1f9c0b0f 	svcne	0x009c0b0f
    2258:	0b100000 	bleq	402260 <__bss_end+0x3f934c>
    225c:	00001e71 	andeq	r1, r0, r1, ror lr
    2260:	23060b11 	movwcs	r0, #27409	; 0x6b11
    2264:	0b120000 	bleq	48226c <__bss_end+0x479358>
    2268:	00001efe 	strdeq	r1, [r0], -lr
    226c:	2bb60b13 	blcs	fed84ec0 <__bss_end+0xfed7bfac>
    2270:	0b140000 	bleq	502278 <__bss_end+0x4f9364>
    2274:	000023ce 	andeq	r2, r0, lr, asr #7
    2278:	212b0b15 			; <UNDEFINED> instruction: 0x212b0b15
    227c:	0b160000 	bleq	582284 <__bss_end+0x579370>
    2280:	00001abd 			; <UNDEFINED> instruction: 0x00001abd
    2284:	28410b17 	stmdacs	r1, {r0, r1, r2, r4, r8, r9, fp}^
    2288:	0b180000 	bleq	602290 <__bss_end+0x5f937c>
    228c:	00002a4b 	andeq	r2, r0, fp, asr #20
    2290:	284f0b19 	stmdacs	pc, {r0, r3, r4, r8, r9, fp}^	; <UNPREDICTABLE>
    2294:	0b1a0000 	bleq	68229c <__bss_end+0x679388>
    2298:	00001f4e 	andeq	r1, r0, lr, asr #30
    229c:	285d0b1b 	ldmdacs	sp, {r0, r1, r3, r4, r8, r9, fp}^
    22a0:	0b1c0000 	bleq	7022a8 <__bss_end+0x6f9394>
    22a4:	00001919 	andeq	r1, r0, r9, lsl r9
    22a8:	286b0b1d 	stmdacs	fp!, {r0, r2, r3, r4, r8, r9, fp}^
    22ac:	0b1e0000 	bleq	7822b4 <__bss_end+0x7793a0>
    22b0:	00002879 	andeq	r2, r0, r9, ror r8
    22b4:	18b20b1f 	ldmne	r2!, {r0, r1, r2, r3, r4, r8, r9, fp}
    22b8:	0b200000 	bleq	8022c0 <__bss_end+0x7f93ac>
    22bc:	000024f1 	strdeq	r2, [r0], -r1
    22c0:	22d80b21 	sbcscs	r0, r8, #33792	; 0x8400
    22c4:	0b220000 	bleq	8822cc <__bss_end+0x8793b8>
    22c8:	00002834 	andeq	r2, r0, r4, lsr r8
    22cc:	21a80b23 			; <UNDEFINED> instruction: 0x21a80b23
    22d0:	0b240000 	bleq	9022d8 <__bss_end+0x8f93c4>
    22d4:	000025fc 	strdeq	r2, [r0], -ip
    22d8:	209e0b25 	addscs	r0, lr, r5, lsr #22
    22dc:	0b260000 	bleq	9822e4 <__bss_end+0x9793d0>
    22e0:	00001d7a 	andeq	r1, r0, sl, ror sp
    22e4:	20bc0b27 	adcscs	r0, ip, r7, lsr #22
    22e8:	0b280000 	bleq	a022f0 <__bss_end+0x9f93dc>
    22ec:	00001e16 	andeq	r1, r0, r6, lsl lr
    22f0:	20cc0b29 	sbccs	r0, ip, r9, lsr #22
    22f4:	0b2a0000 	bleq	a822fc <__bss_end+0xa793e8>
    22f8:	0000224a 	andeq	r2, r0, sl, asr #4
    22fc:	20450b2b 	subcs	r0, r5, fp, lsr #22
    2300:	0b2c0000 	bleq	b02308 <__bss_end+0xaf93f4>
    2304:	00002510 	andeq	r2, r0, r0, lsl r5
    2308:	1dbb0b2d 			; <UNDEFINED> instruction: 0x1dbb0b2d
    230c:	002e0000 	eoreq	r0, lr, r0
    2310:	001fd80a 	andseq	sp, pc, sl, lsl #16
    2314:	93010700 	movwls	r0, #5888	; 0x1700
    2318:	03000000 	movweq	r0, #0
    231c:	049f0617 	ldreq	r0, [pc], #1559	; 2324 <shift+0x2324>
    2320:	2d0b0000 	stccs	0, cr0, [fp, #-0]
    2324:	0000001c 	andeq	r0, r0, ip, lsl r0
    2328:	002adf0b 	eoreq	sp, sl, fp, lsl #30
    232c:	3d0b0100 	stfccs	f0, [fp, #-0]
    2330:	0200001c 	andeq	r0, r0, #28
    2334:	001c600b 	andseq	r6, ip, fp
    2338:	180b0300 	stmdane	fp, {r8, r9}
    233c:	04000029 	streq	r0, [r0], #-41	; 0xffffffd7
    2340:	0025760b 	eoreq	r7, r5, fp, lsl #12
    2344:	ea0b0500 	b	2c374c <__bss_end+0x2ba838>
    2348:	0600001c 			; <UNDEFINED> instruction: 0x0600001c
    234c:	001e5f0b 	andseq	r5, lr, fp, lsl #30
    2350:	700b0700 	andvc	r0, fp, r0, lsl #14
    2354:	0800001c 	stmdaeq	r0, {r2, r3, r4}
    2358:	002ba50b 	eoreq	sl, fp, fp, lsl #10
    235c:	900b0900 	andls	r0, fp, r0, lsl #18
    2360:	0a000019 	beq	23cc <shift+0x23cc>
    2364:	002ace0b 	eoreq	ip, sl, fp, lsl #28
    2368:	b70b0b00 	strlt	r0, [fp, -r0, lsl #22]
    236c:	0c000021 	stceq	0, cr0, [r0], {33}	; 0x21
    2370:	002a620b 	eoreq	r6, sl, fp, lsl #4
    2374:	fe0b0d00 	vdot.bf16	d0, d11, d0[0]
    2378:	0e000024 	cdpeq	0, 0, cr0, cr0, cr4, {1}
    237c:	0027970b 	eoreq	r9, r7, fp, lsl #14
    2380:	4b0b0f00 	blmi	2c5f88 <__bss_end+0x2bd074>
    2384:	1000001d 	andne	r0, r0, sp, lsl r0
    2388:	001c4d0b 	andseq	r4, ip, fp, lsl #26
    238c:	b60b1100 	strlt	r1, [fp], -r0, lsl #2
    2390:	12000024 	andne	r0, r0, #36	; 0x24
    2394:	001d360b 	andseq	r3, sp, fp, lsl #12
    2398:	bd0b1300 	stclt	3, cr1, [fp, #-0]
    239c:	1400002a 	strne	r0, [r0], #-42	; 0xffffffd6
    23a0:	0019ba0b 	andseq	fp, r9, fp, lsl #20
    23a4:	060b1500 	streq	r1, [fp], -r0, lsl #10
    23a8:	16000021 	strne	r0, [r0], -r1, lsr #32
    23ac:	001c800b 	andseq	r8, ip, fp
    23b0:	570b1700 	strpl	r1, [fp, -r0, lsl #14]
    23b4:	18000019 	stmdane	r0, {r0, r3, r4}
    23b8:	002b4b0b 	eoreq	r4, fp, fp, lsl #22
    23bc:	060b1900 	streq	r1, [fp], -r0, lsl #18
    23c0:	1a000028 	bne	2468 <shift+0x2468>
    23c4:	00261a0b 	eoreq	r1, r6, fp, lsl #20
    23c8:	7e0b1b00 	vmlavc.f64	d1, d11, d0
    23cc:	1c000027 	stcne	0, cr0, [r0], {39}	; 0x27
    23d0:	0028e20b 	eoreq	lr, r8, fp, lsl #4
    23d4:	a00b1d00 	andge	r1, fp, r0, lsl #26
    23d8:	1e00001c 	mcrne	0, 0, r0, cr0, cr12, {0}
    23dc:	001a2b0b 	andseq	r2, sl, fp, lsl #22
    23e0:	330b1f00 	movwcc	r1, #48896	; 0xbf00
    23e4:	20000026 	andcs	r0, r0, r6, lsr #32
    23e8:	001d970b 	andseq	r9, sp, fp, lsl #14
    23ec:	880b2100 	stmdahi	fp, {r8, sp}
    23f0:	22000025 	andcs	r0, r0, #37	; 0x25
    23f4:	0021880b 	eoreq	r8, r1, fp, lsl #16
    23f8:	900b2300 	andls	r2, fp, r0, lsl #6
    23fc:	2400001c 	strcs	r0, [r0], #-28	; 0xffffffe4
    2400:	0027360b 	eoreq	r3, r7, fp, lsl #12
    2404:	a30b2500 	movwge	r2, #46336	; 0xb500
    2408:	2600001b 			; <UNDEFINED> instruction: 0x2600001b
    240c:	0028c70b 	eoreq	ip, r8, fp, lsl #14
    2410:	920b2700 	andls	r2, fp, #0, 14
    2414:	2800002b 	stmdacs	r0, {r0, r1, r3, r5}
    2418:	0024890b 	eoreq	r8, r4, fp, lsl #18
    241c:	300b2900 	andcc	r2, fp, r0, lsl #18
    2420:	2a00001f 	bcs	24a4 <shift+0x24a4>
    2424:	00265d0b 	eoreq	r5, r6, fp, lsl #26
    2428:	e60b2b00 	str	r2, [fp], -r0, lsl #22
    242c:	2c000021 	stccs	0, cr0, [r0], {33}	; 0x21
    2430:	001a7e0b 	andseq	r7, sl, fp, lsl #28
    2434:	020b2d00 	andeq	r2, fp, #0, 26
    2438:	2e00001a 	mcrcs	0, 0, r0, cr0, cr10, {0}
    243c:	002a200b 	eoreq	r2, sl, fp
    2440:	740b2f00 	strvc	r2, [fp], #-3840	; 0xfffff100
    2444:	30000021 	andcc	r0, r0, r1, lsr #32
    2448:	001d100b 	andseq	r1, sp, fp
    244c:	530b3100 	movwpl	r3, #45312	; 0xb100
    2450:	32000021 	andcc	r0, r0, #33	; 0x21
    2454:	0024020b 	eoreq	r0, r4, fp, lsl #4
    2458:	f00b3300 			; <UNDEFINED> instruction: 0xf00b3300
    245c:	34000019 	strcc	r0, [r0], #-25	; 0xffffffe7
    2460:	002b800b 	eoreq	r8, fp, fp
    2464:	370b3500 	strcc	r3, [fp, -r0, lsl #10]
    2468:	36000022 	strcc	r0, [r0], -r2, lsr #32
    246c:	001ec90b 	andseq	ip, lr, fp, lsl #18
    2470:	740b3700 	strvc	r3, [fp], #-1792	; 0xfffff900
    2474:	38000022 	stmdacc	r0, {r1, r5}
    2478:	002a880b 	eoreq	r8, sl, fp, lsl #16
    247c:	350b3900 	strcc	r3, [fp, #-2304]	; 0xfffff700
    2480:	3a00001b 	bcc	24f4 <shift+0x24f4>
    2484:	001edc0b 	andseq	sp, lr, fp, lsl #24
    2488:	a80b3b00 	stmdage	fp, {r8, r9, fp, ip, sp}
    248c:	3c00001e 	stccc	0, cr0, [r0], {30}
    2490:	0018c10b 	andseq	ip, r8, fp, lsl #2
    2494:	c90b3d00 	stmdbgt	fp, {r8, sl, fp, ip, sp}
    2498:	3e000021 	cdpcc	0, 0, cr0, cr0, cr1, {1}
    249c:	001fa80b 	andseq	sl, pc, fp, lsl #16
    24a0:	490b3f00 	stmdbmi	fp, {r8, r9, sl, fp, ip, sp}
    24a4:	4000001a 	andmi	r0, r0, sl, lsl r0
    24a8:	002a340b 	eoreq	r3, sl, fp, lsl #8
    24ac:	190b4100 	stmdbne	fp, {r8, lr}
    24b0:	42000021 	andmi	r0, r0, #33	; 0x21
    24b4:	001e920b 	andseq	r9, lr, fp, lsl #4
    24b8:	020b4300 	andeq	r4, fp, #0, 6
    24bc:	44000019 	strmi	r0, [r0], #-25	; 0xffffffe7
    24c0:	0020760b 	eoreq	r7, r0, fp, lsl #12
    24c4:	620b4500 	andvs	r4, fp, #0, 10
    24c8:	46000020 	strmi	r0, [r0], -r0, lsr #32
    24cc:	0025dd0b 	eoreq	sp, r5, fp, lsl #26
    24d0:	a50b4700 	strge	r4, [fp, #-1792]	; 0xfffff900
    24d4:	48000026 	stmdami	r0, {r1, r2, r5}
    24d8:	0029ff0b 	eoreq	pc, r9, fp, lsl #30
    24dc:	c80b4900 	stmdagt	fp, {r8, fp, lr}
    24e0:	4a00001d 	bmi	255c <shift+0x255c>
    24e4:	0023b80b 	eoreq	fp, r3, fp, lsl #16
    24e8:	720b4b00 	andvc	r4, fp, #0, 22
    24ec:	4c000026 	stcmi	0, cr0, [r0], {38}	; 0x26
    24f0:	00251f0b 	eoreq	r1, r5, fp, lsl #30
    24f4:	330b4d00 	movwcc	r4, #48384	; 0xbd00
    24f8:	4e000025 	cdpmi	0, 0, cr0, cr0, cr5, {1}
    24fc:	0025470b 	eoreq	r4, r5, fp, lsl #14
    2500:	c30b4f00 	movwgt	r4, #48896	; 0xbf00
    2504:	5000001b 	andpl	r0, r0, fp, lsl r0
    2508:	001b200b 	andseq	r2, fp, fp
    250c:	480b5100 	stmdami	fp, {r8, ip, lr}
    2510:	5200001b 	andpl	r0, r0, #27
    2514:	0027a90b 	eoreq	sl, r7, fp, lsl #18
    2518:	8e0b5300 	cdphi	3, 0, cr5, cr11, cr0, {0}
    251c:	5400001b 	strpl	r0, [r0], #-27	; 0xffffffe5
    2520:	0027bd0b 	eoreq	fp, r7, fp, lsl #26
    2524:	d10b5500 	tstle	fp, r0, lsl #10
    2528:	56000027 	strpl	r0, [r0], -r7, lsr #32
    252c:	0027e50b 	eoreq	lr, r7, fp, lsl #10
    2530:	220b5700 	andcs	r5, fp, #0, 14
    2534:	5800001d 	stmdapl	r0, {r0, r2, r3, r4}
    2538:	001cfc0b 	andseq	pc, ip, fp, lsl #24
    253c:	8a0b5900 	bhi	2d8944 <__bss_end+0x2cfa30>
    2540:	5a000020 	bpl	25c8 <shift+0x25c8>
    2544:	0022870b 	eoreq	r8, r2, fp, lsl #14
    2548:	100b5b00 	andne	r5, fp, r0, lsl #22
    254c:	5c000020 	stcpl	0, cr0, [r0], {32}
    2550:	0018950b 	andseq	r9, r8, fp, lsl #10
    2554:	4a0b5d00 	bmi	2d995c <__bss_end+0x2d0a48>
    2558:	5e00001e 	mcrpl	0, 0, r0, cr0, cr14, {0}
    255c:	0022b00b 	eoreq	fp, r2, fp
    2560:	dc0b5f00 	stcle	15, cr5, [fp], {-0}
    2564:	60000020 	andvs	r0, r0, r0, lsr #32
    2568:	00259b0b 	eoreq	r9, r5, fp, lsl #22
    256c:	fd0b6100 	stc2	1, cr6, [fp, #-0]
    2570:	6200002a 	andvs	r0, r0, #42	; 0x2a
    2574:	0023a30b 	eoreq	sl, r3, fp, lsl #6
    2578:	ed0b6300 	stc	3, cr6, [fp, #-0]
    257c:	6400001d 	strvs	r0, [r0], #-29	; 0xffffffe3
    2580:	0019690b 	andseq	r6, r9, fp, lsl #18
    2584:	270b6500 	strcs	r6, [fp, -r0, lsl #10]
    2588:	66000019 			; <UNDEFINED> instruction: 0x66000019
    258c:	0022e80b 	eoreq	lr, r2, fp, lsl #16
    2590:	230b6700 	movwcs	r6, #46848	; 0xb700
    2594:	68000024 	stmdavs	r0, {r2, r5}
    2598:	0025bf0b 	eoreq	fp, r5, fp, lsl #30
    259c:	f10b6900 			; <UNDEFINED> instruction: 0xf10b6900
    25a0:	6a000020 	bvs	2628 <shift+0x2628>
    25a4:	002b360b 	eoreq	r3, fp, fp, lsl #12
    25a8:	070b6b00 	streq	r6, [fp, -r0, lsl #22]
    25ac:	6c000022 	stcvs	0, cr0, [r0], {34}	; 0x22
    25b0:	0018e60b 	andseq	lr, r8, fp, lsl #12
    25b4:	160b6d00 	strne	r6, [fp], -r0, lsl #26
    25b8:	6e00001a 	mcrvs	0, 0, r0, cr0, cr10, {0}
    25bc:	001e010b 	andseq	r0, lr, fp, lsl #2
    25c0:	b10b6f00 	tstlt	fp, r0, lsl #30
    25c4:	7000001c 	andvc	r0, r0, ip, lsl r0
    25c8:	07020300 	streq	r0, [r2, -r0, lsl #6]
    25cc:	00000a04 	andeq	r0, r0, r4, lsl #20
    25d0:	0004bc0c 	andeq	fp, r4, ip, lsl #24
    25d4:	0004b100 	andeq	fp, r4, r0, lsl #2
    25d8:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    25dc:	000004a6 	andeq	r0, r0, r6, lsr #9
    25e0:	04c80405 	strbeq	r0, [r8], #1029	; 0x405
    25e4:	b60e0000 	strlt	r0, [lr], -r0
    25e8:	03000004 	movweq	r0, #4
    25ec:	0dce0801 	stcleq	8, cr0, [lr, #4]
    25f0:	c10e0000 	mrsgt	r0, (UNDEF: 14)
    25f4:	0f000004 	svceq	0x00000004
    25f8:	00001aae 	andeq	r1, r0, lr, lsr #21
    25fc:	1a014404 	bne	53614 <__bss_end+0x4a700>
    2600:	000004b1 			; <UNDEFINED> instruction: 0x000004b1
    2604:	001e820f 	andseq	r8, lr, pc, lsl #4
    2608:	01790400 	cmneq	r9, r0, lsl #8
    260c:	0004b11a 	andeq	fp, r4, sl, lsl r1
    2610:	04c10c00 	strbeq	r0, [r1], #3072	; 0xc00
    2614:	04f20000 	ldrbteq	r0, [r2], #0
    2618:	000d0000 	andeq	r0, sp, r0
    261c:	0020ae09 	eoreq	sl, r0, r9, lsl #28
    2620:	0d2d0500 	cfstr32eq	mvfx0, [sp, #-0]
    2624:	000004e7 	andeq	r0, r0, r7, ror #9
    2628:	0028a309 	eoreq	sl, r8, r9, lsl #6
    262c:	1c350500 	cfldr32ne	mvfx0, [r5], #-0
    2630:	000001e6 	andeq	r0, r0, r6, ror #3
    2634:	001d5e0a 	andseq	r5, sp, sl, lsl #28
    2638:	93010700 	movwls	r0, #5888	; 0x1700
    263c:	05000000 	streq	r0, [r0, #-0]
    2640:	057d0e37 	ldrbeq	r0, [sp, #-3639]!	; 0xfffff1c9
    2644:	fb0b0000 	blx	2c264e <__bss_end+0x2b973a>
    2648:	00000018 	andeq	r0, r0, r8, lsl r0
    264c:	001f950b 	andseq	r9, pc, fp, lsl #10
    2650:	9a0b0100 	bls	2c2a58 <__bss_end+0x2b9b44>
    2654:	0200002a 	andeq	r0, r0, #42	; 0x2a
    2658:	002a750b 	eoreq	r7, sl, fp, lsl #10
    265c:	510b0300 	mrspl	r0, (UNDEF: 59)
    2660:	04000023 	streq	r0, [r0], #-35	; 0xffffffdd
    2664:	0026f30b 	eoreq	pc, r6, fp, lsl #6
    2668:	f10b0500 			; <UNDEFINED> instruction: 0xf10b0500
    266c:	0600001a 			; <UNDEFINED> instruction: 0x0600001a
    2670:	001ad30b 	andseq	sp, sl, fp, lsl #6
    2674:	260b0700 	strcs	r0, [fp], -r0, lsl #14
    2678:	0800001c 	stmdaeq	r0, {r2, r3, r4}
    267c:	0021df0b 	eoreq	sp, r1, fp, lsl #30
    2680:	f80b0900 			; <UNDEFINED> instruction: 0xf80b0900
    2684:	0a00001a 	beq	26f4 <shift+0x26f4>
    2688:	001b640b 	andseq	r6, fp, fp, lsl #8
    268c:	5d0b0b00 	vstrpl	d0, [fp, #-0]
    2690:	0c00001b 	stceq	0, cr0, [r0], {27}
    2694:	001aea0b 	andseq	lr, sl, fp, lsl #20
    2698:	4a0b0d00 	bmi	2c5aa0 <__bss_end+0x2bcb8c>
    269c:	0e000027 	cdpeq	0, 0, cr0, cr0, cr7, {1}
    26a0:	0024410b 	eoreq	r4, r4, fp, lsl #2
    26a4:	04000f00 	streq	r0, [r0], #-3840	; 0xfffff100
    26a8:	000025f5 	strdeq	r2, [r0], -r5
    26ac:	0a013c05 	beq	516c8 <__bss_end+0x487b4>
    26b0:	09000005 	stmdbeq	r0, {r0, r2}
    26b4:	000026c6 	andeq	r2, r0, r6, asr #13
    26b8:	7d0f3e05 	stcvc	14, cr3, [pc, #-20]	; 26ac <shift+0x26ac>
    26bc:	09000005 	stmdbeq	r0, {r0, r2}
    26c0:	0000276d 	andeq	r2, r0, sp, ror #14
    26c4:	1d0c4705 	stcne	7, cr4, [ip, #-20]	; 0xffffffec
    26c8:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    26cc:	00001a9e 	muleq	r0, lr, sl
    26d0:	1d0c4805 	stcne	8, cr4, [ip, #-20]	; 0xffffffec
    26d4:	10000000 	andne	r0, r0, r0
    26d8:	00002887 	andeq	r2, r0, r7, lsl #17
    26dc:	0026d509 	eoreq	sp, r6, r9, lsl #10
    26e0:	14490500 	strbne	r0, [r9], #-1280	; 0xfffffb00
    26e4:	000005be 			; <UNDEFINED> instruction: 0x000005be
    26e8:	05ad0405 	streq	r0, [sp, #1029]!	; 0x405
    26ec:	09110000 	ldmdbeq	r1, {}	; <UNPREDICTABLE>
    26f0:	00001f5f 	andeq	r1, r0, pc, asr pc
    26f4:	d10f4b05 	tstle	pc, r5, lsl #22
    26f8:	05000005 	streq	r0, [r0, #-5]
    26fc:	0005c404 	andeq	ip, r5, r4, lsl #8
    2700:	26481200 	strbcs	r1, [r8], -r0, lsl #4
    2704:	3e090000 	cdpcc	0, 0, cr0, cr9, cr0, {0}
    2708:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    270c:	05e80d4f 	strbeq	r0, [r8, #3407]!	; 0xd4f
    2710:	04050000 	streq	r0, [r5], #-0
    2714:	000005d7 	ldrdeq	r0, [r0], -r7
    2718:	001c0c13 	andseq	r0, ip, r3, lsl ip
    271c:	58053400 	stmdapl	r5, {sl, ip, sp}
    2720:	06191501 	ldreq	r1, [r9], -r1, lsl #10
    2724:	b7140000 	ldrlt	r0, [r4, -r0]
    2728:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    272c:	b60f015a 			; <UNDEFINED> instruction: 0xb60f015a
    2730:	00000004 	andeq	r0, r0, r4
    2734:	001bf014 	andseq	pc, fp, r4, lsl r0	; <UNPREDICTABLE>
    2738:	015b0500 	cmpeq	fp, r0, lsl #10
    273c:	00061e14 	andeq	r1, r6, r4, lsl lr
    2740:	0e000400 	cfcpyseq	mvf0, mvf0
    2744:	000005ee 	andeq	r0, r0, lr, ror #11
    2748:	0000b90c 	andeq	fp, r0, ip, lsl #18
    274c:	00062e00 	andeq	r2, r6, r0, lsl #28
    2750:	00241500 	eoreq	r1, r4, r0, lsl #10
    2754:	002d0000 	eoreq	r0, sp, r0
    2758:	0006190c 	andeq	r1, r6, ip, lsl #18
    275c:	00063900 	andeq	r3, r6, r0, lsl #18
    2760:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    2764:	0000062e 	andeq	r0, r0, lr, lsr #12
    2768:	001fe70f 	andseq	lr, pc, pc, lsl #14
    276c:	015c0500 	cmpeq	ip, r0, lsl #10
    2770:	00063903 	andeq	r3, r6, r3, lsl #18
    2774:	22570f00 	subscs	r0, r7, #0, 30
    2778:	5f050000 	svcpl	0x00050000
    277c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2780:	86160000 	ldrhi	r0, [r6], -r0
    2784:	07000026 	streq	r0, [r0, -r6, lsr #32]
    2788:	00009301 	andeq	r9, r0, r1, lsl #6
    278c:	01720500 	cmneq	r2, r0, lsl #10
    2790:	00070e06 	andeq	r0, r7, r6, lsl #28
    2794:	23320b00 	teqcs	r2, #0, 22
    2798:	0b000000 	bleq	27a0 <shift+0x27a0>
    279c:	000019a2 	andeq	r1, r0, r2, lsr #19
    27a0:	19ae0b02 	stmibne	lr!, {r1, r8, r9, fp}
    27a4:	0b030000 	bleq	c27ac <__bss_end+0xb9898>
    27a8:	00001d8a 	andeq	r1, r0, sl, lsl #27
    27ac:	236e0b03 	cmncs	lr, #3072	; 0xc00
    27b0:	0b040000 	bleq	1027b8 <__bss_end+0xf98a4>
    27b4:	00001ef1 	strdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    27b8:	19cc0b04 	stmibne	ip, {r2, r8, r9, fp}^
    27bc:	0b050000 	bleq	1427c4 <__bss_end+0x1398b0>
    27c0:	00001fbe 			; <UNDEFINED> instruction: 0x00001fbe
    27c4:	1ff80b05 	svcne	0x00f80b05
    27c8:	0b050000 	bleq	1427d0 <__bss_end+0x1398bc>
    27cc:	00001f22 	andeq	r1, r0, r2, lsr #30
    27d0:	1a8f0b05 	bne	fe3c53ec <__bss_end+0xfe3bc4d8>
    27d4:	0b050000 	bleq	1427dc <__bss_end+0x1398c8>
    27d8:	000019d8 	ldrdeq	r1, [r0], -r8
    27dc:	21670b06 	cmncs	r7, r6, lsl #22
    27e0:	0b060000 	bleq	1827e8 <__bss_end+0x1798d4>
    27e4:	00001be2 	andeq	r1, r0, r2, ror #23
    27e8:	247c0b06 	ldrbtcs	r0, [ip], #-2822	; 0xfffff4fa
    27ec:	0b060000 	bleq	1827f4 <__bss_end+0x1798e0>
    27f0:	00002716 	andeq	r2, r0, r6, lsl r7
    27f4:	219b0b06 	orrscs	r0, fp, r6, lsl #22
    27f8:	0b060000 	bleq	182800 <__bss_end+0x1798ec>
    27fc:	000021fa 	strdeq	r2, [r0], -sl
    2800:	19e40b06 	stmibne	r4!, {r1, r2, r8, r9, fp}^
    2804:	0b070000 	bleq	1c280c <__bss_end+0x1b98f8>
    2808:	00002315 	andeq	r2, r0, r5, lsl r3
    280c:	237a0b07 	cmncs	sl, #7168	; 0x1c00
    2810:	0b070000 	bleq	1c2818 <__bss_end+0x1b9904>
    2814:	00002760 	andeq	r2, r0, r0, ror #14
    2818:	1bb50b07 	blne	fed4543c <__bss_end+0xfed3c528>
    281c:	0b070000 	bleq	1c2824 <__bss_end+0x1b9910>
    2820:	000023f5 	strdeq	r2, [r0], -r5
    2824:	19450b08 	stmdbne	r5, {r3, r8, r9, fp}^
    2828:	0b080000 	bleq	202830 <__bss_end+0x1f991c>
    282c:	00002724 	andeq	r2, r0, r4, lsr #14
    2830:	24160b08 	ldrcs	r0, [r6], #-2824	; 0xfffff4f8
    2834:	00080000 	andeq	r0, r8, r0
    2838:	002aaf0f 	eoreq	sl, sl, pc, lsl #30
    283c:	01920500 	orrseq	r0, r2, r0, lsl #10
    2840:	0006581f 	andeq	r5, r6, pc, lsl r8
    2844:	1ebe0f00 	cdpne	15, 11, cr0, cr14, cr0, {0}
    2848:	95050000 	strls	r0, [r5, #-0]
    284c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2850:	480f0000 	stmdami	pc, {}	; <UNPREDICTABLE>
    2854:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    2858:	1d0c0198 	stfnes	f0, [ip, #-608]	; 0xfffffda0
    285c:	0f000000 	svceq	0x00000000
    2860:	00002005 	andeq	r2, r0, r5
    2864:	0c019b05 			; <UNDEFINED> instruction: 0x0c019b05
    2868:	0000001d 	andeq	r0, r0, sp, lsl r0
    286c:	0024520f 	eoreq	r5, r4, pc, lsl #4
    2870:	019e0500 	orrseq	r0, lr, r0, lsl #10
    2874:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2878:	21480f00 	cmpcs	r8, r0, lsl #30
    287c:	a1050000 	mrsge	r0, (UNDEF: 5)
    2880:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2884:	9c0f0000 	stcls	0, cr0, [pc], {-0}
    2888:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    288c:	1d0c01a4 	stfnes	f0, [ip, #-656]	; 0xfffffd70
    2890:	0f000000 	svceq	0x00000000
    2894:	00002358 	andeq	r2, r0, r8, asr r3
    2898:	0c01a705 	stceq	7, cr10, [r1], {5}
    289c:	0000001d 	andeq	r0, r0, sp, lsl r0
    28a0:	0023630f 	eoreq	r6, r3, pc, lsl #6
    28a4:	01aa0500 			; <UNDEFINED> instruction: 0x01aa0500
    28a8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    28ac:	245c0f00 	ldrbcs	r0, [ip], #-3840	; 0xfffff100
    28b0:	ad050000 	stcge	0, cr0, [r5, #-0]
    28b4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    28b8:	3a0f0000 	bcc	3c28c0 <__bss_end+0x3b99ac>
    28bc:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    28c0:	1d0c01b0 	stfnes	f0, [ip, #-704]	; 0xfffffd40
    28c4:	0f000000 	svceq	0x00000000
    28c8:	00002af1 	strdeq	r2, [r0], -r1
    28cc:	0c01b305 	stceq	3, cr11, [r1], {5}
    28d0:	0000001d 	andeq	r0, r0, sp, lsl r0
    28d4:	0024660f 	eoreq	r6, r4, pc, lsl #12
    28d8:	01b60500 			; <UNDEFINED> instruction: 0x01b60500
    28dc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    28e0:	2bce0f00 	blcs	ff3864e8 <__bss_end+0xff37d5d4>
    28e4:	b9050000 	stmdblt	r5, {}	; <UNPREDICTABLE>
    28e8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    28ec:	7c0f0000 	stcvc	0, cr0, [pc], {-0}
    28f0:	0500002a 	streq	r0, [r0, #-42]	; 0xffffffd6
    28f4:	1d0c01bc 	stfnes	f0, [ip, #-752]	; 0xfffffd10
    28f8:	0f000000 	svceq	0x00000000
    28fc:	00002aa1 	andeq	r2, r0, r1, lsr #21
    2900:	0c01c005 	stceq	0, cr12, [r1], {5}
    2904:	0000001d 	andeq	r0, r0, sp, lsl r0
    2908:	002bc10f 	eoreq	ip, fp, pc, lsl #2
    290c:	01c30500 	biceq	r0, r3, r0, lsl #10
    2910:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2914:	1aff0f00 	bne	fffc651c <__bss_end+0xfffbd608>
    2918:	c6050000 	strgt	r0, [r5], -r0
    291c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2920:	d60f0000 	strle	r0, [pc], -r0
    2924:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    2928:	1d0c01c9 	stfnes	f0, [ip, #-804]	; 0xfffffcdc
    292c:	0f000000 	svceq	0x00000000
    2930:	00001daa 	andeq	r1, r0, sl, lsr #27
    2934:	0c01cc05 	stceq	12, cr12, [r1], {5}
    2938:	0000001d 	andeq	r0, r0, sp, lsl r0
    293c:	001ada0f 	andseq	sp, sl, pc, lsl #20
    2940:	01cf0500 	biceq	r0, pc, r0, lsl #10
    2944:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2948:	24a60f00 	strtcs	r0, [r6], #3840	; 0xf00
    294c:	d2050000 	andle	r0, r5, #0
    2950:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2954:	2d0f0000 	stccs	0, cr0, [pc, #-0]	; 295c <shift+0x295c>
    2958:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    295c:	1d0c01d5 	stfnes	f0, [ip, #-852]	; 0xfffffcac
    2960:	0f000000 	svceq	0x00000000
    2964:	000022c5 	andeq	r2, r0, r5, asr #5
    2968:	0c01d805 	stceq	8, cr13, [r1], {5}
    296c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2970:	0028ac0f 	eoreq	sl, r8, pc, lsl #24
    2974:	01df0500 	bicseq	r0, pc, r0, lsl #10
    2978:	00001d0c 	andeq	r1, r0, ip, lsl #26
    297c:	2b600f00 	blcs	1806584 <__bss_end+0x17fd670>
    2980:	e2050000 	and	r0, r5, #0
    2984:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2988:	700f0000 	andvc	r0, pc, r0
    298c:	0500002b 	streq	r0, [r0, #-43]	; 0xffffffd5
    2990:	1d0c01e5 	stfnes	f0, [ip, #-916]	; 0xfffffc6c
    2994:	0f000000 	svceq	0x00000000
    2998:	00001bf9 	strdeq	r1, [r0], -r9
    299c:	0c01e805 	stceq	8, cr14, [r1], {5}
    29a0:	0000001d 	andeq	r0, r0, sp, lsl r0
    29a4:	0028f30f 	eoreq	pc, r8, pc, lsl #6
    29a8:	01eb0500 	mvneq	r0, r0, lsl #10
    29ac:	00001d0c 	andeq	r1, r0, ip, lsl #26
    29b0:	23dd0f00 	bicscs	r0, sp, #0, 30
    29b4:	ee050000 	cdp	0, 0, cr0, cr5, cr0, {0}
    29b8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    29bc:	230f0000 	movwcs	r0, #61440	; 0xf000
    29c0:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    29c4:	1d0c01f2 	stfnes	f0, [ip, #-968]	; 0xfffffc38
    29c8:	0f000000 	svceq	0x00000000
    29cc:	00002698 	muleq	r0, r8, r6
    29d0:	0c01fa05 			; <UNDEFINED> instruction: 0x0c01fa05
    29d4:	0000001d 	andeq	r0, r0, sp, lsl r0
    29d8:	001cdc0f 	andseq	sp, ip, pc, lsl #24
    29dc:	01fd0500 	mvnseq	r0, r0, lsl #10
    29e0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    29e4:	001d0c00 	andseq	r0, sp, r0, lsl #24
    29e8:	08c60000 	stmiaeq	r6, {}^	; <UNPREDICTABLE>
    29ec:	000d0000 	andeq	r0, sp, r0
    29f0:	001f0d0f 	andseq	r0, pc, pc, lsl #26
    29f4:	03eb0500 	mvneq	r0, #0, 10
    29f8:	0008bb0c 	andeq	fp, r8, ip, lsl #22
    29fc:	05be0c00 	ldreq	r0, [lr, #3072]!	; 0xc00
    2a00:	08e30000 	stmiaeq	r3!, {}^	; <UNPREDICTABLE>
    2a04:	24150000 	ldrcs	r0, [r5], #-0
    2a08:	0d000000 	stceq	0, cr0, [r0, #-0]
    2a0c:	24dc0f00 	ldrbcs	r0, [ip], #3840	; 0xf00
    2a10:	74050000 	strvc	r0, [r5], #-0
    2a14:	08d31405 	ldmeq	r3, {r0, r2, sl, ip}^
    2a18:	f0160000 			; <UNDEFINED> instruction: 0xf0160000
    2a1c:	0700001f 	smladeq	r0, pc, r0, r0	; <UNPREDICTABLE>
    2a20:	00009301 	andeq	r9, r0, r1, lsl #6
    2a24:	057b0500 	ldrbeq	r0, [fp, #-1280]!	; 0xfffffb00
    2a28:	00092e06 	andeq	r2, r9, r6, lsl #28
    2a2c:	1d6c0b00 	vstmdbne	ip!, {d16-d15}
    2a30:	0b000000 	bleq	2a38 <shift+0x2a38>
    2a34:	00002225 	andeq	r2, r0, r5, lsr #4
    2a38:	197b0b01 	ldmdbne	fp!, {r0, r8, r9, fp}^
    2a3c:	0b020000 	bleq	82a44 <__bss_end+0x79b30>
    2a40:	00002b22 	andeq	r2, r0, r2, lsr #22
    2a44:	25680b03 	strbcs	r0, [r8, #-2819]!	; 0xfffff4fd
    2a48:	0b040000 	bleq	102a50 <__bss_end+0xf9b3c>
    2a4c:	0000255b 	andeq	r2, r0, fp, asr r5
    2a50:	1a6e0b05 	bne	1b8566c <__bss_end+0x1b7c758>
    2a54:	00060000 	andeq	r0, r6, r0
    2a58:	002b120f 	eoreq	r1, fp, pc, lsl #4
    2a5c:	05880500 	streq	r0, [r8, #1280]	; 0x500
    2a60:	0008f015 	andeq	pc, r8, r5, lsl r0	; <UNPREDICTABLE>
    2a64:	29ee0f00 	stmibcs	lr!, {r8, r9, sl, fp}^
    2a68:	89050000 	stmdbhi	r5, {}	; <UNPREDICTABLE>
    2a6c:	00241107 	eoreq	r1, r4, r7, lsl #2
    2a70:	c90f0000 	stmdbgt	pc, {}	; <UNPREDICTABLE>
    2a74:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    2a78:	1d0c079e 	stcne	7, cr0, [ip, #-632]	; 0xfffffd88
    2a7c:	04000000 	streq	r0, [r0], #-0
    2a80:	0000289b 	muleq	r0, fp, r8
    2a84:	93167b06 	tstls	r6, #6144	; 0x1800
    2a88:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    2a8c:	00000955 	andeq	r0, r0, r5, asr r9
    2a90:	42050203 	andmi	r0, r5, #805306368	; 0x30000000
    2a94:	0300000e 	movweq	r0, #14
    2a98:	1cc50708 	stclne	7, cr0, [r5], {8}
    2a9c:	04030000 	streq	r0, [r3], #-0
    2aa0:	001b1a04 	andseq	r1, fp, r4, lsl #20
    2aa4:	03080300 	movweq	r0, #33536	; 0x8300
    2aa8:	00001b12 	andeq	r1, r0, r2, lsl fp
    2aac:	75040803 	strvc	r0, [r4, #-2051]	; 0xfffff7fd
    2ab0:	03000024 	movweq	r0, #36	; 0x24
    2ab4:	25b00310 	ldrcs	r0, [r0, #784]!	; 0x310
    2ab8:	610c0000 	mrsvs	r0, (UNDEF: 12)
    2abc:	a0000009 	andge	r0, r0, r9
    2ac0:	15000009 	strne	r0, [r0, #-9]
    2ac4:	00000024 	andeq	r0, r0, r4, lsr #32
    2ac8:	900e00ff 	strdls	r0, [lr], -pc	; <UNPREDICTABLE>
    2acc:	0f000009 	svceq	0x00000009
    2ad0:	00002387 	andeq	r2, r0, r7, lsl #7
    2ad4:	1601fc06 	strne	pc, [r1], -r6, lsl #24
    2ad8:	000009a0 	andeq	r0, r0, r0, lsr #19
    2adc:	001ac90f 	andseq	ip, sl, pc, lsl #18
    2ae0:	02020600 	andeq	r0, r2, #0, 12
    2ae4:	0009a016 	andeq	sl, r9, r6, lsl r0
    2ae8:	28be0400 	ldmcs	lr!, {sl}
    2aec:	2a070000 	bcs	1c2af4 <__bss_end+0x1b9be0>
    2af0:	0005d110 	andeq	sp, r5, r0, lsl r1
    2af4:	09bf0c00 	ldmibeq	pc!, {sl, fp}	; <UNPREDICTABLE>
    2af8:	09d60000 	ldmibeq	r6, {}^	; <UNPREDICTABLE>
    2afc:	000d0000 	andeq	r0, sp, r0
    2b00:	00037a09 	andeq	r7, r3, r9, lsl #20
    2b04:	112f0700 			; <UNDEFINED> instruction: 0x112f0700
    2b08:	000009cb 	andeq	r0, r0, fp, asr #19
    2b0c:	00023c09 	andeq	r3, r2, r9, lsl #24
    2b10:	11300700 	teqne	r0, r0, lsl #14
    2b14:	000009cb 	andeq	r0, r0, fp, asr #19
    2b18:	0009d617 	andeq	sp, r9, r7, lsl r6
    2b1c:	09360800 	ldmdbeq	r6!, {fp}
    2b20:	0103050a 	tsteq	r3, sl, lsl #10
    2b24:	1700008f 	strne	r0, [r0, -pc, lsl #1]
    2b28:	000009e2 	andeq	r0, r0, r2, ror #19
    2b2c:	0a093708 	beq	250754 <__bss_end+0x247840>
    2b30:	8f010305 	svchi	0x00010305
    2b34:	Address 0x0000000000002b34 is out of bounds.


Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x377d00>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb9e08>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9e28>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9e40>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <__bss_end+0x17c>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7a980>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39e64>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	000f0800 	andeq	r0, pc, r0, lsl #16
  98:	13490b0b 	movtne	r0, #39691	; 0x9b0b
  9c:	01000000 	mrseq	r0, (UNDEF: 0)
  a0:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
  a4:	0e030b13 	vmoveq.32	d3[0], r0
  a8:	01110e1b 	tsteq	r1, fp, lsl lr
  ac:	17100612 			; <UNDEFINED> instruction: 0x17100612
  b0:	16020000 	strne	r0, [r2], -r0
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x377da8>
  b8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  bc:	0013490b 	andseq	r4, r3, fp, lsl #18
  c0:	000f0300 	andeq	r0, pc, r0, lsl #6
  c4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
  c8:	15040000 	strne	r0, [r4, #-0]
  cc:	05000000 	streq	r0, [r0, #-0]
  d0:	13490101 	movtne	r0, #37121	; 0x9101
  d4:	00001301 	andeq	r1, r0, r1, lsl #6
  d8:	49002106 	stmdbmi	r0, {r1, r2, r8, sp}
  dc:	00062f13 	andeq	r2, r6, r3, lsl pc
  e0:	00240700 	eoreq	r0, r4, r0, lsl #14
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf79e04>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c5a1c>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7aa04>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe39ee8>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <shift+0x16c>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9efc>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__bss_end+0x24c>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7aa3c>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe39f20>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeb9f30>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x377eb8>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c5aa8>
 180:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 184:	00193c13 	andseq	r3, r9, r3, lsl ip
 188:	012e1100 			; <UNDEFINED> instruction: 0x012e1100
 18c:	01111347 	tsteq	r1, r7, asr #6
 190:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 194:	01194297 			; <UNDEFINED> instruction: 0x01194297
 198:	12000013 	andne	r0, r0, #19
 19c:	13490005 	movtne	r0, #36869	; 0x9005
 1a0:	00001802 	andeq	r1, r0, r2, lsl #16
 1a4:	03000513 	movweq	r0, #1299	; 0x513
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c5abc>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x377eec>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf79efc>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 1e8:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 1ec:	0b0b0024 	bleq	2c0284 <__bss_end+0x2b7370>
 1f0:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 1f4:	16050000 	strne	r0, [r5], -r0
 1f8:	3a0e0300 	bcc	380e00 <__bss_end+0x377eec>
 1fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 200:	0013490b 	andseq	r4, r3, fp, lsl #18
 204:	00350600 	eorseq	r0, r5, r0, lsl #12
 208:	00001349 	andeq	r1, r0, r9, asr #6
 20c:	03011307 	movweq	r1, #4871	; 0x1307
 210:	3a0b0b0e 	bcc	2c2e50 <__bss_end+0x2b9f3c>
 214:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 218:	0013010b 	andseq	r0, r3, fp, lsl #2
 21c:	000d0800 	andeq	r0, sp, r0, lsl #16
 220:	0b3a0803 	bleq	e82234 <__bss_end+0xe79320>
 224:	0b390b3b 	bleq	e42f18 <__bss_end+0xe3a004>
 228:	0b381349 	bleq	e04f54 <__bss_end+0xdfc040>
 22c:	04090000 	streq	r0, [r9], #-0
 230:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 234:	0b0b3e19 	bleq	2cfaa0 <__bss_end+0x2c6b8c>
 238:	3a13490b 	bcc	4d266c <__bss_end+0x4c9758>
 23c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 240:	0013010b 	andseq	r0, r3, fp, lsl #2
 244:	00280a00 	eoreq	r0, r8, r0, lsl #20
 248:	0b1c0e03 	bleq	703a5c <__bss_end+0x6fab48>
 24c:	340b0000 	strcc	r0, [fp], #-0
 250:	3a0e0300 	bcc	380e58 <__bss_end+0x377f44>
 254:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 258:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 25c:	00180219 	andseq	r0, r8, r9, lsl r2
 260:	00020c00 	andeq	r0, r2, r0, lsl #24
 264:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 268:	020d0000 	andeq	r0, sp, #0
 26c:	0b0e0301 	bleq	380e78 <__bss_end+0x377f64>
 270:	3b0b3a0b 	blcc	2ceaa4 <__bss_end+0x2c5b90>
 274:	010b390b 	tsteq	fp, fp, lsl #18
 278:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 27c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 280:	0b3b0b3a 	bleq	ec2f70 <__bss_end+0xeba05c>
 284:	13490b39 	movtne	r0, #39737	; 0x9b39
 288:	00000b38 	andeq	r0, r0, r8, lsr fp
 28c:	3f012e0f 	svccc	0x00012e0f
 290:	3a0e0319 	bcc	380efc <__bss_end+0x377fe8>
 294:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 298:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 29c:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 2a0:	10000013 	andne	r0, r0, r3, lsl r0
 2a4:	13490005 	movtne	r0, #36869	; 0x9005
 2a8:	00001934 	andeq	r1, r0, r4, lsr r9
 2ac:	49000511 	stmdbmi	r0, {r0, r4, r8, sl}
 2b0:	12000013 	andne	r0, r0, #19
 2b4:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 2b8:	0b3b0b3a 	bleq	ec2fa8 <__bss_end+0xeba094>
 2bc:	13490b39 	movtne	r0, #39737	; 0x9b39
 2c0:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 2c4:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 2c8:	03193f01 	tsteq	r9, #1, 30
 2cc:	3b0b3a0e 	blcc	2ceb0c <__bss_end+0x2c5bf8>
 2d0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2d4:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 2d8:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 2dc:	00130113 	andseq	r0, r3, r3, lsl r1
 2e0:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 2e4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2e8:	0b3b0b3a 	bleq	ec2fd8 <__bss_end+0xeba0c4>
 2ec:	0e6e0b39 	vmoveq.8	d14[5], r0
 2f0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 2f4:	13011364 	movwne	r1, #4964	; 0x1364
 2f8:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 2fc:	03193f01 	tsteq	r9, #1, 30
 300:	3b0b3a0e 	blcc	2ceb40 <__bss_end+0x2c5c2c>
 304:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 308:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 30c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 310:	16000013 			; <UNDEFINED> instruction: 0x16000013
 314:	13490101 	movtne	r0, #37121	; 0x9101
 318:	00001301 	andeq	r1, r0, r1, lsl #6
 31c:	49002117 	stmdbmi	r0, {r0, r1, r2, r4, r8, sp}
 320:	000b2f13 	andeq	r2, fp, r3, lsl pc
 324:	000f1800 	andeq	r1, pc, r0, lsl #16
 328:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 32c:	21190000 	tstcs	r9, r0
 330:	1a000000 	bne	338 <shift+0x338>
 334:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 338:	0b3b0b3a 	bleq	ec3028 <__bss_end+0xeba114>
 33c:	13490b39 	movtne	r0, #39737	; 0x9b39
 340:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 344:	281b0000 	ldmdacs	fp, {}	; <UNPREDICTABLE>
 348:	1c080300 	stcne	3, cr0, [r8], {-0}
 34c:	1c00000b 	stcne	0, cr0, [r0], {11}
 350:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 354:	0b3a0e03 	bleq	e83b68 <__bss_end+0xe7ac54>
 358:	0b390b3b 	bleq	e4304c <__bss_end+0xe3a138>
 35c:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 360:	13011364 	movwne	r1, #4964	; 0x1364
 364:	2e1d0000 	cdpcs	0, 1, cr0, cr13, cr0, {0}
 368:	03193f01 	tsteq	r9, #1, 30
 36c:	3b0b3a0e 	blcc	2cebac <__bss_end+0x2c5c98>
 370:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 374:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 378:	01136419 	tsteq	r3, r9, lsl r4
 37c:	1e000013 	mcrne	0, 0, r0, cr0, cr3, {0}
 380:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 384:	0b3b0b3a 	bleq	ec3074 <__bss_end+0xeba160>
 388:	13490b39 	movtne	r0, #39737	; 0x9b39
 38c:	0b320b38 	bleq	c83074 <__bss_end+0xc7a160>
 390:	151f0000 	ldrne	r0, [pc, #-0]	; 398 <shift+0x398>
 394:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
 398:	00130113 	andseq	r0, r3, r3, lsl r1
 39c:	001f2000 	andseq	r2, pc, r0
 3a0:	1349131d 	movtne	r1, #37661	; 0x931d
 3a4:	10210000 	eorne	r0, r1, r0
 3a8:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 3ac:	22000013 	andcs	r0, r0, #19
 3b0:	0b0b000f 	bleq	2c03f4 <__bss_end+0x2b74e0>
 3b4:	39230000 	stmdbcc	r3!, {}	; <UNPREDICTABLE>
 3b8:	3a080301 	bcc	200fc4 <__bss_end+0x1f80b0>
 3bc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3c0:	0013010b 	andseq	r0, r3, fp, lsl #2
 3c4:	00342400 	eorseq	r2, r4, r0, lsl #8
 3c8:	0b3a0e03 	bleq	e83bdc <__bss_end+0xe7acc8>
 3cc:	0b390b3b 	bleq	e430c0 <__bss_end+0xe3a1ac>
 3d0:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 3d4:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
 3d8:	34250000 	strtcc	r0, [r5], #-0
 3dc:	3a0e0300 	bcc	380fe4 <__bss_end+0x3780d0>
 3e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3e4:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 3e8:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 3ec:	26000019 			; <UNDEFINED> instruction: 0x26000019
 3f0:	13470034 	movtne	r0, #28724	; 0x7034
 3f4:	2e270000 	cdpcs	0, 2, cr0, cr7, cr0, {0}
 3f8:	03193f01 	tsteq	r9, #1, 30
 3fc:	3b0b3a0e 	blcc	2cec3c <__bss_end+0x2c5d28>
 400:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 404:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 408:	00136419 	andseq	r6, r3, r9, lsl r4
 40c:	012e2800 			; <UNDEFINED> instruction: 0x012e2800
 410:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 414:	0b3b0b3a 	bleq	ec3104 <__bss_end+0xeba1f0>
 418:	13490b39 	movtne	r0, #39737	; 0x9b39
 41c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 420:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 424:	00130119 	andseq	r0, r3, r9, lsl r1
 428:	00052900 	andeq	r2, r5, r0, lsl #18
 42c:	0b3a0e03 	bleq	e83c40 <__bss_end+0xe7ad2c>
 430:	0b390b3b 	bleq	e43124 <__bss_end+0xe3a210>
 434:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 438:	342a0000 	strtcc	r0, [sl], #-0
 43c:	3a0e0300 	bcc	381044 <__bss_end+0x378130>
 440:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 444:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 448:	00000018 	andeq	r0, r0, r8, lsl r0
 44c:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 450:	030b130e 	movweq	r1, #45838	; 0xb30e
 454:	110e1b0e 	tstne	lr, lr, lsl #22
 458:	10061201 	andne	r1, r6, r1, lsl #4
 45c:	02000017 	andeq	r0, r0, #23
 460:	0b0b0024 	bleq	2c04f8 <__bss_end+0x2b75e4>
 464:	0e030b3e 	vmoveq.16	d3[0], r0
 468:	26030000 	strcs	r0, [r3], -r0
 46c:	00134900 	andseq	r4, r3, r0, lsl #18
 470:	00240400 	eoreq	r0, r4, r0, lsl #8
 474:	0b3e0b0b 	bleq	f830a8 <__bss_end+0xf7a194>
 478:	00000803 	andeq	r0, r0, r3, lsl #16
 47c:	03001605 	movweq	r1, #1541	; 0x605
 480:	3b0b3a0e 	blcc	2cecc0 <__bss_end+0x2c5dac>
 484:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 488:	06000013 			; <UNDEFINED> instruction: 0x06000013
 48c:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 490:	0b3a0b0b 	bleq	e830c4 <__bss_end+0xe7a1b0>
 494:	0b390b3b 	bleq	e43188 <__bss_end+0xe3a274>
 498:	00001301 	andeq	r1, r0, r1, lsl #6
 49c:	03000d07 	movweq	r0, #3335	; 0xd07
 4a0:	3b0b3a08 	blcc	2cecc8 <__bss_end+0x2c5db4>
 4a4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4a8:	000b3813 	andeq	r3, fp, r3, lsl r8
 4ac:	01040800 	tsteq	r4, r0, lsl #16
 4b0:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 4b4:	0b0b0b3e 	bleq	2c31b4 <__bss_end+0x2ba2a0>
 4b8:	0b3a1349 	bleq	e851e4 <__bss_end+0xe7c2d0>
 4bc:	0b390b3b 	bleq	e431b0 <__bss_end+0xe3a29c>
 4c0:	00001301 	andeq	r1, r0, r1, lsl #6
 4c4:	03002809 	movweq	r2, #2057	; 0x809
 4c8:	000b1c08 	andeq	r1, fp, r8, lsl #24
 4cc:	00280a00 	eoreq	r0, r8, r0, lsl #20
 4d0:	0b1c0e03 	bleq	703ce4 <__bss_end+0x6fadd0>
 4d4:	340b0000 	strcc	r0, [fp], #-0
 4d8:	3a0e0300 	bcc	3810e0 <__bss_end+0x3781cc>
 4dc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4e0:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 4e4:	00180219 	andseq	r0, r8, r9, lsl r2
 4e8:	00020c00 	andeq	r0, r2, r0, lsl #24
 4ec:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 4f0:	020d0000 	andeq	r0, sp, #0
 4f4:	0b0e0301 	bleq	381100 <__bss_end+0x3781ec>
 4f8:	3b0b3a0b 	blcc	2ced2c <__bss_end+0x2c5e18>
 4fc:	010b390b 	tsteq	fp, fp, lsl #18
 500:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 504:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 508:	0b3b0b3a 	bleq	ec31f8 <__bss_end+0xeba2e4>
 50c:	13490b39 	movtne	r0, #39737	; 0x9b39
 510:	00000b38 	andeq	r0, r0, r8, lsr fp
 514:	3f012e0f 	svccc	0x00012e0f
 518:	3a0e0319 	bcc	381184 <__bss_end+0x378270>
 51c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 520:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 524:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 528:	10000013 	andne	r0, r0, r3, lsl r0
 52c:	13490005 	movtne	r0, #36869	; 0x9005
 530:	00001934 	andeq	r1, r0, r4, lsr r9
 534:	49000511 	stmdbmi	r0, {r0, r4, r8, sl}
 538:	12000013 	andne	r0, r0, #19
 53c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 540:	0b3b0b3a 	bleq	ec3230 <__bss_end+0xeba31c>
 544:	13490b39 	movtne	r0, #39737	; 0x9b39
 548:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 54c:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 550:	03193f01 	tsteq	r9, #1, 30
 554:	3b0b3a0e 	blcc	2ced94 <__bss_end+0x2c5e80>
 558:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 55c:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 560:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 564:	00130113 	andseq	r0, r3, r3, lsl r1
 568:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 56c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 570:	0b3b0b3a 	bleq	ec3260 <__bss_end+0xeba34c>
 574:	0e6e0b39 	vmoveq.8	d14[5], r0
 578:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 57c:	13011364 	movwne	r1, #4964	; 0x1364
 580:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 584:	03193f01 	tsteq	r9, #1, 30
 588:	3b0b3a0e 	blcc	2cedc8 <__bss_end+0x2c5eb4>
 58c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 590:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 594:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 598:	16000013 			; <UNDEFINED> instruction: 0x16000013
 59c:	13490101 	movtne	r0, #37121	; 0x9101
 5a0:	00001301 	andeq	r1, r0, r1, lsl #6
 5a4:	49002117 	stmdbmi	r0, {r0, r1, r2, r4, r8, sp}
 5a8:	000b2f13 	andeq	r2, fp, r3, lsl pc
 5ac:	000f1800 	andeq	r1, pc, r0, lsl #16
 5b0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 5b4:	21190000 	tstcs	r9, r0
 5b8:	1a000000 	bne	5c0 <shift+0x5c0>
 5bc:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 5c0:	0b3b0b3a 	bleq	ec32b0 <__bss_end+0xeba39c>
 5c4:	13490b39 	movtne	r0, #39737	; 0x9b39
 5c8:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 5cc:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
 5d0:	03193f01 	tsteq	r9, #1, 30
 5d4:	3b0b3a0e 	blcc	2cee14 <__bss_end+0x2c5f00>
 5d8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 5dc:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
 5e0:	00130113 	andseq	r0, r3, r3, lsl r1
 5e4:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 5e8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5ec:	0b3b0b3a 	bleq	ec32dc <__bss_end+0xeba3c8>
 5f0:	0e6e0b39 	vmoveq.8	d14[5], r0
 5f4:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 5f8:	13011364 	movwne	r1, #4964	; 0x1364
 5fc:	0d1d0000 	ldceq	0, cr0, [sp, #-0]
 600:	3a0e0300 	bcc	381208 <__bss_end+0x3782f4>
 604:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 608:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 60c:	000b320b 	andeq	r3, fp, fp, lsl #4
 610:	01151e00 	tsteq	r5, r0, lsl #28
 614:	13641349 	cmnne	r4, #603979777	; 0x24000001
 618:	00001301 	andeq	r1, r0, r1, lsl #6
 61c:	1d001f1f 	stcne	15, cr1, [r0, #-124]	; 0xffffff84
 620:	00134913 	andseq	r4, r3, r3, lsl r9
 624:	00102000 	andseq	r2, r0, r0
 628:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 62c:	0f210000 	svceq	0x00210000
 630:	000b0b00 	andeq	r0, fp, r0, lsl #22
 634:	00342200 	eorseq	r2, r4, r0, lsl #4
 638:	0b3a0e03 	bleq	e83e4c <__bss_end+0xe7af38>
 63c:	0b390b3b 	bleq	e43330 <__bss_end+0xe3a41c>
 640:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 644:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
 648:	03193f01 	tsteq	r9, #1, 30
 64c:	3b0b3a0e 	blcc	2cee8c <__bss_end+0x2c5f78>
 650:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 654:	1113490e 	tstne	r3, lr, lsl #18
 658:	40061201 	andmi	r1, r6, r1, lsl #4
 65c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 660:	00001301 	andeq	r1, r0, r1, lsl #6
 664:	03000524 	movweq	r0, #1316	; 0x524
 668:	3b0b3a0e 	blcc	2ceea8 <__bss_end+0x2c5f94>
 66c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 670:	00180213 	andseq	r0, r8, r3, lsl r2
 674:	012e2500 			; <UNDEFINED> instruction: 0x012e2500
 678:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 67c:	0b3b0b3a 	bleq	ec336c <__bss_end+0xeba458>
 680:	0e6e0b39 	vmoveq.8	d14[5], r0
 684:	01111349 	tsteq	r1, r9, asr #6
 688:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 68c:	01194297 			; <UNDEFINED> instruction: 0x01194297
 690:	26000013 			; <UNDEFINED> instruction: 0x26000013
 694:	08030034 	stmdaeq	r3, {r2, r4, r5}
 698:	0b3b0b3a 	bleq	ec3388 <__bss_end+0xeba474>
 69c:	13490b39 	movtne	r0, #39737	; 0x9b39
 6a0:	00001802 	andeq	r1, r0, r2, lsl #16
 6a4:	3f012e27 	svccc	0x00012e27
 6a8:	3a0e0319 	bcc	381314 <__bss_end+0x378400>
 6ac:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6b0:	110e6e0b 	tstne	lr, fp, lsl #28
 6b4:	40061201 	andmi	r1, r6, r1, lsl #4
 6b8:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6bc:	00001301 	andeq	r1, r0, r1, lsl #6
 6c0:	3f002e28 	svccc	0x00002e28
 6c4:	3a0e0319 	bcc	381330 <__bss_end+0x37841c>
 6c8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6cc:	110e6e0b 	tstne	lr, fp, lsl #28
 6d0:	40061201 	andmi	r1, r6, r1, lsl #4
 6d4:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6d8:	2e290000 	cdpcs	0, 2, cr0, cr9, cr0, {0}
 6dc:	03193f01 	tsteq	r9, #1, 30
 6e0:	3b0b3a0e 	blcc	2cef20 <__bss_end+0x2c600c>
 6e4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6e8:	1113490e 	tstne	r3, lr, lsl #18
 6ec:	40061201 	andmi	r1, r6, r1, lsl #4
 6f0:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6f4:	01000000 	mrseq	r0, (UNDEF: 0)
 6f8:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 6fc:	0e030b13 	vmoveq.32	d3[0], r0
 700:	01110e1b 	tsteq	r1, fp, lsl lr
 704:	17100612 			; <UNDEFINED> instruction: 0x17100612
 708:	39020000 	stmdbcc	r2, {}	; <UNPREDICTABLE>
 70c:	00130101 	andseq	r0, r3, r1, lsl #2
 710:	00340300 	eorseq	r0, r4, r0, lsl #6
 714:	0b3a0e03 	bleq	e83f28 <__bss_end+0xe7b014>
 718:	0b390b3b 	bleq	e4340c <__bss_end+0xe3a4f8>
 71c:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 720:	00000a1c 	andeq	r0, r0, ip, lsl sl
 724:	3a003a04 	bcc	ef3c <__bss_end+0x6028>
 728:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 72c:	0013180b 	andseq	r1, r3, fp, lsl #16
 730:	01010500 	tsteq	r1, r0, lsl #10
 734:	13011349 	movwne	r1, #4937	; 0x1349
 738:	21060000 	mrscs	r0, (UNDEF: 6)
 73c:	2f134900 	svccs	0x00134900
 740:	0700000b 	streq	r0, [r0, -fp]
 744:	13490026 	movtne	r0, #36902	; 0x9026
 748:	24080000 	strcs	r0, [r8], #-0
 74c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 750:	000e030b 	andeq	r0, lr, fp, lsl #6
 754:	00340900 	eorseq	r0, r4, r0, lsl #18
 758:	00001347 	andeq	r1, r0, r7, asr #6
 75c:	3f012e0a 	svccc	0x00012e0a
 760:	3a0e0319 	bcc	3813cc <__bss_end+0x3784b8>
 764:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 768:	110e6e0b 	tstne	lr, fp, lsl #28
 76c:	40061201 	andmi	r1, r6, r1, lsl #4
 770:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 774:	00001301 	andeq	r1, r0, r1, lsl #6
 778:	0300050b 	movweq	r0, #1291	; 0x50b
 77c:	3b0b3a08 	blcc	2cefa4 <__bss_end+0x2c6090>
 780:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 784:	00180213 	andseq	r0, r8, r3, lsl r2
 788:	00340c00 	eorseq	r0, r4, r0, lsl #24
 78c:	0b3a0e03 	bleq	e83fa0 <__bss_end+0xe7b08c>
 790:	0b390b3b 	bleq	e43484 <__bss_end+0xe3a570>
 794:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 798:	0b0d0000 	bleq	3407a0 <__bss_end+0x33788c>
 79c:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 7a0:	0e000006 	cdpeq	0, 0, cr0, cr0, cr6, {0}
 7a4:	08030034 	stmdaeq	r3, {r2, r4, r5}
 7a8:	0b3b0b3a 	bleq	ec3498 <__bss_end+0xeba584>
 7ac:	13490b39 	movtne	r0, #39737	; 0x9b39
 7b0:	00001802 	andeq	r1, r0, r2, lsl #16
 7b4:	0b000f0f 	bleq	43f8 <shift+0x43f8>
 7b8:	0013490b 	andseq	r4, r3, fp, lsl #18
 7bc:	00261000 	eoreq	r1, r6, r0
 7c0:	0f110000 	svceq	0x00110000
 7c4:	000b0b00 	andeq	r0, fp, r0, lsl #22
 7c8:	00241200 	eoreq	r1, r4, r0, lsl #4
 7cc:	0b3e0b0b 	bleq	f83400 <__bss_end+0xf7a4ec>
 7d0:	00000803 	andeq	r0, r0, r3, lsl #16
 7d4:	03000513 	movweq	r0, #1299	; 0x513
 7d8:	3b0b3a0e 	blcc	2cf018 <__bss_end+0x2c6104>
 7dc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 7e0:	00180213 	andseq	r0, r8, r3, lsl r2
 7e4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 7e8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 7ec:	0b3b0b3a 	bleq	ec34dc <__bss_end+0xeba5c8>
 7f0:	0e6e0b39 	vmoveq.8	d14[5], r0
 7f4:	01111349 	tsteq	r1, r9, asr #6
 7f8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 7fc:	01194297 			; <UNDEFINED> instruction: 0x01194297
 800:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 804:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 808:	0b3a0e03 	bleq	e8401c <__bss_end+0xe7b108>
 80c:	0b390b3b 	bleq	e43500 <__bss_end+0xe3a5ec>
 810:	01110e6e 	tsteq	r1, lr, ror #28
 814:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 818:	00194296 	mulseq	r9, r6, r2
 81c:	11010000 	mrsne	r0, (UNDEF: 1)
 820:	11061000 	mrsne	r1, (UNDEF: 6)
 824:	03011201 	movweq	r1, #4609	; 0x1201
 828:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 82c:	0005130e 	andeq	r1, r5, lr, lsl #6
 830:	11010000 	mrsne	r0, (UNDEF: 1)
 834:	11061000 	mrsne	r1, (UNDEF: 6)
 838:	03011201 	movweq	r1, #4609	; 0x1201
 83c:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 840:	0005130e 	andeq	r1, r5, lr, lsl #6
 844:	11010000 	mrsne	r0, (UNDEF: 1)
 848:	130e2501 	movwne	r2, #58625	; 0xe501
 84c:	1b0e030b 	blne	381480 <__bss_end+0x37856c>
 850:	0017100e 	andseq	r1, r7, lr
 854:	00240200 	eoreq	r0, r4, r0, lsl #4
 858:	0b3e0b0b 	bleq	f8348c <__bss_end+0xf7a578>
 85c:	00000803 	andeq	r0, r0, r3, lsl #16
 860:	0b002403 	bleq	9874 <__bss_end+0x960>
 864:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 868:	0400000e 	streq	r0, [r0], #-14
 86c:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 870:	0b3b0b3a 	bleq	ec3560 <__bss_end+0xeba64c>
 874:	13490b39 	movtne	r0, #39737	; 0x9b39
 878:	0f050000 	svceq	0x00050000
 87c:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 880:	06000013 			; <UNDEFINED> instruction: 0x06000013
 884:	19270115 	stmdbne	r7!, {r0, r2, r4, r8}
 888:	13011349 	movwne	r1, #4937	; 0x1349
 88c:	05070000 	streq	r0, [r7, #-0]
 890:	00134900 	andseq	r4, r3, r0, lsl #18
 894:	00260800 	eoreq	r0, r6, r0, lsl #16
 898:	34090000 	strcc	r0, [r9], #-0
 89c:	3a0e0300 	bcc	3814a4 <__bss_end+0x378590>
 8a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8a4:	3f13490b 	svccc	0x0013490b
 8a8:	00193c19 	andseq	r3, r9, r9, lsl ip
 8ac:	01040a00 	tsteq	r4, r0, lsl #20
 8b0:	0b3e0e03 	bleq	f840c4 <__bss_end+0xf7b1b0>
 8b4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 8b8:	0b3b0b3a 	bleq	ec35a8 <__bss_end+0xeba694>
 8bc:	13010b39 	movwne	r0, #6969	; 0x1b39
 8c0:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
 8c4:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 8c8:	0c00000b 	stceq	0, cr0, [r0], {11}
 8cc:	13490101 	movtne	r0, #37121	; 0x9101
 8d0:	00001301 	andeq	r1, r0, r1, lsl #6
 8d4:	0000210d 	andeq	r2, r0, sp, lsl #2
 8d8:	00260e00 	eoreq	r0, r6, r0, lsl #28
 8dc:	00001349 	andeq	r1, r0, r9, asr #6
 8e0:	0300340f 	movweq	r3, #1039	; 0x40f
 8e4:	3b0b3a0e 	blcc	2cf124 <__bss_end+0x2c6210>
 8e8:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 8ec:	3c193f13 	ldccc	15, cr3, [r9], {19}
 8f0:	10000019 	andne	r0, r0, r9, lsl r0
 8f4:	0e030013 	mcreq	0, 0, r0, cr3, cr3, {0}
 8f8:	0000193c 	andeq	r1, r0, ip, lsr r9
 8fc:	27001511 	smladcs	r0, r1, r5, r1
 900:	12000019 	andne	r0, r0, #25
 904:	0e030017 	mcreq	0, 0, r0, cr3, cr7, {0}
 908:	0000193c 	andeq	r1, r0, ip, lsr r9
 90c:	03011313 	movweq	r1, #4883	; 0x1313
 910:	3a0b0b0e 	bcc	2c3550 <__bss_end+0x2ba63c>
 914:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 918:	0013010b 	andseq	r0, r3, fp, lsl #2
 91c:	000d1400 	andeq	r1, sp, r0, lsl #8
 920:	0b3a0e03 	bleq	e84134 <__bss_end+0xe7b220>
 924:	0b39053b 	bleq	e41e18 <__bss_end+0xe38f04>
 928:	0b381349 	bleq	e05654 <__bss_end+0xdfc740>
 92c:	21150000 	tstcs	r5, r0
 930:	2f134900 	svccs	0x00134900
 934:	1600000b 	strne	r0, [r0], -fp
 938:	0e030104 	adfeqs	f0, f3, f4
 93c:	0b0b0b3e 	bleq	2c363c <__bss_end+0x2ba728>
 940:	0b3a1349 	bleq	e8566c <__bss_end+0xe7c758>
 944:	0b39053b 	bleq	e41e38 <__bss_end+0xe38f24>
 948:	00001301 	andeq	r1, r0, r1, lsl #6
 94c:	47003417 	smladmi	r0, r7, r4, r3
 950:	3b0b3a13 	blcc	2cf1a4 <__bss_end+0x2c6290>
 954:	020b3905 	andeq	r3, fp, #81920	; 0x14000
 958:	00000018 	andeq	r0, r0, r8, lsl r0

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	0000001c 	andeq	r0, r0, ip, lsl r0
   4:	00000002 	andeq	r0, r0, r2
   8:	00040000 	andeq	r0, r4, r0
   c:	00000000 	andeq	r0, r0, r0
  10:	00008000 	andeq	r8, r0, r0
  14:	00000008 	andeq	r0, r0, r8
	...
  20:	0000001c 	andeq	r0, r0, ip, lsl r0
  24:	00260002 	eoreq	r0, r6, r2
  28:	00040000 	andeq	r0, r4, r0
  2c:	00000000 	andeq	r0, r0, r0
  30:	00008008 	andeq	r8, r0, r8
  34:	000000a4 	andeq	r0, r0, r4, lsr #1
	...
  40:	0000001c 	andeq	r0, r0, ip, lsl r0
  44:	00c40002 	sbceq	r0, r4, r2
  48:	00040000 	andeq	r0, r4, r0
  4c:	00000000 	andeq	r0, r0, r0
  50:	000080ac 	andeq	r8, r0, ip, lsr #1
  54:	00000188 	andeq	r0, r0, r8, lsl #3
	...
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	02ca0002 	sbceq	r0, sl, #2
  68:	00040000 	andeq	r0, r4, r0
  6c:	00000000 	andeq	r0, r0, r0
  70:	00008234 	andeq	r8, r0, r4, lsr r2
  74:	000000dc 	ldrdeq	r0, [r0], -ip
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	10d10002 	sbcsne	r0, r1, r2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008310 	andeq	r8, r0, r0, lsl r3
  94:	00000460 	andeq	r0, r0, r0, ror #8
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	1dac0002 	stcne	0, cr0, [ip, #8]!
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008770 	andeq	r8, r0, r0, ror r7
  b4:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	20de0002 	sbcscs	r0, lr, r2
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00008c28 	andeq	r8, r0, r8, lsr #24
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	21040002 	tstcs	r4, r2
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00008e34 	andeq	r8, r0, r4, lsr lr
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	212a0002 			; <UNDEFINED> instruction: 0x212a0002
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff7038>
       4:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
       8:	6b69746e 	blvs	1a5d1c8 <__bss_end+0x1a542b4>
       c:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
      10:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
      14:	4f54522d 	svcmi	0x0054522d
      18:	616d2d53 	cmnvs	sp, r3, asr sp
      1c:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
      20:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffcf9 <__bss_end+0xffff6de5>
      24:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
      28:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
      2c:	61707372 	cmnvs	r0, r2, ror r3
      30:	632f6563 			; <UNDEFINED> instruction: 0x632f6563
      34:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
      38:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
      3c:	2f656d6f 	svccs	0x00656d6f
      40:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
      44:	642f6b69 	strtvs	r6, [pc], #-2921	; 4c <shift+0x4c>
      48:	4b2f7665 	blmi	bdd9e4 <__bss_end+0xbd4ad0>
      4c:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
      50:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
      54:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
      58:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
      5c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
      60:	752f7365 	strvc	r7, [pc, #-869]!	; fffffd03 <__bss_end+0xffff6def>
      64:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
      68:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
      6c:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
      70:	4700646c 	strmi	r6, [r0, -ip, ror #8]
      74:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
      78:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
      7c:	322e3533 	eorcc	r3, lr, #213909504	; 0xcc00000
      80:	6f682f00 	svcvs	0x00682f00
      84:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
      88:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
      8c:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
      90:	494b2f76 	stmdbmi	fp, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
      94:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
      98:	6d2d534f 	stcvs	3, cr5, [sp, #-316]!	; 0xfffffec4
      9c:	65747361 	ldrbvs	r7, [r4, #-865]!	; 0xfffffc9f
      a0:	6f732f72 	svcvs	0x00732f72
      a4:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
      a8:	73752f73 	cmnvc	r5, #460	; 0x1cc
      ac:	70737265 	rsbsvc	r7, r3, r5, ror #4
      b0:	2f656361 	svccs	0x00656361
      b4:	30747263 	rsbscc	r7, r4, r3, ror #4
      b8:	5f00632e 	svcpl	0x0000632e
      bc:	7472635f 	ldrbtvc	r6, [r2], #-863	; 0xfffffca1
      c0:	6e695f30 	mcrvs	15, 3, r5, cr9, cr0, {1}
      c4:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
      c8:	72007373 	andvc	r7, r0, #-872415231	; 0xcc000001
      cc:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
      d0:	5f5f0074 	svcpl	0x005f0074
      d4:	5f737362 	svcpl	0x00737362
      d8:	00646e65 	rsbeq	r6, r4, r5, ror #28
      dc:	20554e47 	subscs	r4, r5, r7, asr #28
      e0:	20373143 	eorscs	r3, r7, r3, asr #2
      e4:	2e332e38 	mrccs	14, 1, r2, cr3, cr8, {1}
      e8:	30322031 	eorscc	r2, r2, r1, lsr r0
      ec:	37303931 			; <UNDEFINED> instruction: 0x37303931
      f0:	28203330 	stmdacs	r0!, {r4, r5, r8, r9, ip, sp}
      f4:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
      f8:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
      fc:	63675b20 	cmnvs	r7, #32, 22	; 0x8000
     100:	2d382d63 	ldccs	13, cr2, [r8, #-396]!	; 0xfffffe74
     104:	6e617262 	cdpvs	2, 6, cr7, cr1, cr2, {3}
     108:	72206863 	eorvc	r6, r0, #6488064	; 0x630000
     10c:	73697665 	cmnvc	r9, #105906176	; 0x6500000
     110:	206e6f69 	rsbcs	r6, lr, r9, ror #30
     114:	30333732 	eorscc	r3, r3, r2, lsr r7
     118:	205d3732 	subscs	r3, sp, r2, lsr r7
     11c:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
     120:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
     124:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     128:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     12c:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     130:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
     134:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     138:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
     13c:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
     140:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
     144:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
     148:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
     14c:	6f6c666d 	svcvs	0x006c666d
     150:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
     154:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
     158:	20647261 	rsbcs	r7, r4, r1, ror #4
     15c:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
     160:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
     164:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
     168:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
     16c:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     170:	36373131 			; <UNDEFINED> instruction: 0x36373131
     174:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
     178:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
     17c:	206d7261 	rsbcs	r7, sp, r1, ror #4
     180:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     184:	613d6863 	teqvs	sp, r3, ror #16
     188:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
     18c:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
     190:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
     194:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     198:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     19c:	00304f2d 	eorseq	r4, r0, sp, lsr #30
     1a0:	73625f5f 	cmnvc	r2, #380	; 0x17c
     1a4:	74735f73 	ldrbtvc	r5, [r3], #-3955	; 0xfffff08d
     1a8:	00747261 	rsbseq	r7, r4, r1, ror #4
     1ac:	69676562 	stmdbvs	r7!, {r1, r5, r6, r8, sl, sp, lr}^
     1b0:	5f5f006e 	svcpl	0x005f006e
     1b4:	30747263 	rsbscc	r7, r4, r3, ror #4
     1b8:	6e75725f 	mrcvs	2, 3, r7, cr5, cr15, {2}
     1bc:	675f5f00 	ldrbvs	r5, [pc, -r0, lsl #30]
     1c0:	64726175 	ldrbtvs	r6, [r2], #-373	; 0xfffffe8b
     1c4:	615f5f00 	cmpvs	pc, r0, lsl #30
     1c8:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
     1cc:	776e755f 			; <UNDEFINED> instruction: 0x776e755f
     1d0:	5f646e69 	svcpl	0x00646e69
     1d4:	5f707063 	svcpl	0x00707063
     1d8:	00317270 	eorseq	r7, r1, r0, ror r2
     1dc:	7070635f 	rsbsvc	r6, r0, pc, asr r3
     1e0:	7568735f 	strbvc	r7, [r8, #-863]!	; 0xfffffca1
     1e4:	776f6474 			; <UNDEFINED> instruction: 0x776f6474
     1e8:	6e66006e 	cdpvs	0, 6, cr0, cr6, cr14, {3}
     1ec:	00727470 	rsbseq	r7, r2, r0, ror r4
     1f0:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     1f4:	69626178 	stmdbvs	r2!, {r3, r4, r5, r6, r8, sp, lr}^
     1f8:	5f003176 	svcpl	0x00003176
     1fc:	6178635f 	cmnvs	r8, pc, asr r3
     200:	7275705f 	rsbsvc	r7, r5, #95	; 0x5f
     204:	69765f65 	ldmdbvs	r6!, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     208:	61757472 	cmnvs	r5, r2, ror r4
     20c:	5f5f006c 	svcpl	0x005f006c
     210:	5f617863 	svcpl	0x00617863
     214:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
     218:	65725f64 	ldrbvs	r5, [r2, #-3940]!	; 0xfffff09c
     21c:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
     220:	5f5f0065 	svcpl	0x005f0065
     224:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
     228:	444e455f 	strbmi	r4, [lr], #-1375	; 0xfffffaa1
     22c:	5f005f5f 	svcpl	0x00005f5f
     230:	6f73645f 	svcvs	0x0073645f
     234:	6e61685f 	mcrvs	8, 3, r6, cr1, cr15, {2}
     238:	00656c64 	rsbeq	r6, r5, r4, ror #24
     23c:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
     240:	4c5f524f 	lfmmi	f5, 2, [pc], {79}	; 0x4f
     244:	5f545349 	svcpl	0x00545349
     248:	5f5f005f 	svcpl	0x005f005f
     24c:	5f617863 	svcpl	0x00617863
     250:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
     254:	62615f64 	rsbvs	r5, r1, #100, 30	; 0x190
     258:	0074726f 	rsbseq	r7, r4, pc, ror #4
     25c:	726f7464 	rsbvc	r7, pc, #100, 8	; 0x64000000
     260:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
     264:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
     268:	2b2b4320 	blcs	ad0ef0 <__bss_end+0xac7fdc>
     26c:	38203431 	stmdacc	r0!, {r0, r4, r5, sl, ip, sp}
     270:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
     274:	31303220 	teqcc	r0, r0, lsr #4
     278:	30373039 	eorscc	r3, r7, r9, lsr r0
     27c:	72282033 	eorvc	r2, r8, #51	; 0x33
     280:	61656c65 	cmnvs	r5, r5, ror #24
     284:	20296573 	eorcs	r6, r9, r3, ror r5
     288:	6363675b 	cmnvs	r3, #23855104	; 0x16c0000
     28c:	622d382d 	eorvs	r3, sp, #2949120	; 0x2d0000
     290:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
     294:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
     298:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
     29c:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
     2a0:	32303337 	eorscc	r3, r0, #-603979776	; 0xdc000000
     2a4:	2d205d37 	stccs	13, cr5, [r0, #-220]!	; 0xffffff24
     2a8:	6f6c666d 	svcvs	0x006c666d
     2ac:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
     2b0:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
     2b4:	20647261 	rsbcs	r7, r4, r1, ror #4
     2b8:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
     2bc:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
     2c0:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
     2c4:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
     2c8:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     2cc:	36373131 			; <UNDEFINED> instruction: 0x36373131
     2d0:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
     2d4:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
     2d8:	616f6c66 	cmnvs	pc, r6, ror #24
     2dc:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
     2e0:	61683d69 	cmnvs	r8, r9, ror #26
     2e4:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
     2e8:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
     2ec:	7066763d 	rsbvc	r7, r6, sp, lsr r6
     2f0:	746d2d20 	strbtvc	r2, [sp], #-3360	; 0xfffff2e0
     2f4:	3d656e75 	stclcc	14, cr6, [r5, #-468]!	; 0xfffffe2c
     2f8:	316d7261 	cmncc	sp, r1, ror #4
     2fc:	6a363731 	bvs	d8dfc8 <__bss_end+0xd850b4>
     300:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     304:	616d2d20 	cmnvs	sp, r0, lsr #26
     308:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     30c:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     310:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     314:	7a36766d 	bvc	d9dcd0 <__bss_end+0xd94dbc>
     318:	70662b6b 	rsbvc	r2, r6, fp, ror #22
     31c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     320:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     324:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
     328:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
     32c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 19c <shift+0x19c>
     330:	65637865 	strbvs	r7, [r3, #-2149]!	; 0xfffff79b
     334:	6f697470 	svcvs	0x00697470
     338:	2d20736e 	stccs	3, cr7, [r0, #-440]!	; 0xfffffe48
     33c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1ac <shift+0x1ac>
     340:	69747472 	ldmdbvs	r4!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     344:	445f5f00 	ldrbmi	r5, [pc], #-3840	; 34c <shift+0x34c>
     348:	5f524f54 	svcpl	0x00524f54
     34c:	5f444e45 	svcpl	0x00444e45
     350:	5f5f005f 	svcpl	0x005f005f
     354:	5f617863 	svcpl	0x00617863
     358:	78657461 	stmdavc	r5!, {r0, r5, r6, sl, ip, sp, lr}^
     35c:	6c007469 	cfstrsvs	mvf7, [r0], {105}	; 0x69
     360:	20676e6f 	rsbcs	r6, r7, pc, ror #28
     364:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
     368:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     36c:	70635f00 	rsbvc	r5, r3, r0, lsl #30
     370:	74735f70 	ldrbtvc	r5, [r3], #-3952	; 0xfffff090
     374:	75747261 	ldrbvc	r7, [r4, #-609]!	; 0xfffffd9f
     378:	5f5f0070 	svcpl	0x005f0070
     37c:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
     380:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
     384:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
     388:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
     38c:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
     390:	635f5f00 	cmpvs	pc, #0, 30
     394:	675f6178 			; <UNDEFINED> instruction: 0x675f6178
     398:	64726175 	ldrbtvs	r6, [r2], #-373	; 0xfffffe8b
     39c:	7163615f 	cmnvc	r3, pc, asr r1
     3a0:	65726975 	ldrbvs	r6, [r2, #-2421]!	; 0xfffff68b
     3a4:	6f682f00 	svcvs	0x00682f00
     3a8:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
     3ac:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
     3b0:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
     3b4:	494b2f76 	stmdbmi	fp, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
     3b8:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
     3bc:	6d2d534f 	stcvs	3, cr5, [sp, #-316]!	; 0xfffffec4
     3c0:	65747361 	ldrbvs	r7, [r4, #-865]!	; 0xfffffc9f
     3c4:	6f732f72 	svcvs	0x00732f72
     3c8:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     3cc:	73752f73 	cmnvc	r5, #460	; 0x1cc
     3d0:	70737265 	rsbsvc	r7, r3, r5, ror #4
     3d4:	2f656361 	svccs	0x00656361
     3d8:	61787863 	cmnvs	r8, r3, ror #16
     3dc:	632e6962 			; <UNDEFINED> instruction: 0x632e6962
     3e0:	54007070 	strpl	r7, [r0], #-112	; 0xffffff90
     3e4:	5f6b6369 	svcpl	0x006b6369
     3e8:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     3ec:	6e490074 	mcrvs	0, 2, r0, cr9, cr4, {3}
     3f0:	69666564 	stmdbvs	r6!, {r2, r5, r6, r8, sl, sp, lr}^
     3f4:	6574696e 	ldrbvs	r6, [r4, #-2414]!	; 0xfffff692
     3f8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     3fc:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     400:	5f4f4950 	svcpl	0x004f4950
     404:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     408:	3172656c 	cmncc	r2, ip, ror #10
     40c:	616e4539 	cmnvs	lr, r9, lsr r5
     410:	5f656c62 	svcpl	0x00656c62
     414:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     418:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     41c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     420:	30326a45 	eorscc	r6, r2, r5, asr #20
     424:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     428:	6e495f4f 	cdpvs	15, 4, cr5, cr9, cr15, {2}
     42c:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     430:	5f747075 	svcpl	0x00747075
     434:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     438:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     43c:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     440:	5f4f4950 	svcpl	0x004f4950
     444:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     448:	3172656c 	cmncc	r2, ip, ror #10
     44c:	73655231 	cmnvc	r5, #268435459	; 0x10000003
     450:	65767265 	ldrbvs	r7, [r6, #-613]!	; 0xfffffd9b
     454:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     458:	62626a45 	rsbvs	r6, r2, #282624	; 0x45000
     45c:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     460:	4f00305f 	svcmi	0x0000305f
     464:	006e6570 	rsbeq	r6, lr, r0, ror r5
     468:	314e5a5f 	cmpcc	lr, pc, asr sl
     46c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     470:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     474:	614d5f73 	hvcvs	54771	; 0xd5f3
     478:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     47c:	42313272 	eorsmi	r3, r1, #536870919	; 0x20000007
     480:	6b636f6c 	blvs	18dc238 <__bss_end+0x18d3324>
     484:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     488:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     48c:	6f72505f 	svcvs	0x0072505f
     490:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     494:	41007645 	tstmi	r0, r5, asr #12
     498:	335f746c 	cmpcc	pc, #108, 8	; 0x6c000000
     49c:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     4a0:	7000345f 	andvc	r3, r0, pc, asr r4
     4a4:	00766572 	rsbseq	r6, r6, r2, ror r5
     4a8:	314e5a5f 	cmpcc	lr, pc, asr sl
     4ac:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     4b0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4b4:	614d5f73 	hvcvs	54771	; 0xd5f3
     4b8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     4bc:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     4c0:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     4c4:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     4c8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4cc:	31504573 	cmpcc	r0, r3, ror r5
     4d0:	61545432 	cmpvs	r4, r2, lsr r4
     4d4:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
     4d8:	63757274 	cmnvs	r5, #116, 4	; 0x40000007
     4dc:	5a5f0074 	bpl	17c06b4 <__bss_end+0x17b77a0>
     4e0:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
     4e4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     4e8:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     4ec:	33316d65 	teqcc	r1, #6464	; 0x1940
     4f0:	5f534654 	svcpl	0x00534654
     4f4:	65657254 	strbvs	r7, [r5, #-596]!	; 0xfffffdac
     4f8:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 500 <shift+0x500>
     4fc:	46303165 	ldrtmi	r3, [r0], -r5, ror #2
     500:	5f646e69 	svcpl	0x00646e69
     504:	6c696843 	stclvs	8, cr6, [r9], #-268	; 0xfffffef4
     508:	4b504564 	blmi	1411aa0 <__bss_end+0x1408b8c>
     50c:	6e550063 	cdpvs	0, 5, cr0, cr5, cr3, {3}
     510:	5f70616d 	svcpl	0x0070616d
     514:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     518:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     51c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     520:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     524:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     528:	5f4f4950 	svcpl	0x004f4950
     52c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     530:	3972656c 	ldmdbcc	r2!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     534:	5f746547 	svcpl	0x00746547
     538:	75706e49 	ldrbvc	r6, [r0, #-3657]!	; 0xfffff1b7
     53c:	006a4574 	rsbeq	r4, sl, r4, ror r5
     540:	32435342 	subcc	r5, r3, #134217729	; 0x8000001
     544:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     548:	506d0065 	rsbpl	r0, sp, r5, rrx
     54c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     550:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     554:	5f747369 	svcpl	0x00747369
     558:	64616548 	strbtvs	r6, [r1], #-1352	; 0xfffffab8
     55c:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     560:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     564:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     568:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     56c:	5f006e6f 	svcpl	0x00006e6f
     570:	314b4e5a 	cmpcc	fp, sl, asr lr
     574:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     578:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     57c:	614d5f73 	hvcvs	54771	; 0xd5f3
     580:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     584:	47393172 			; <UNDEFINED> instruction: 0x47393172
     588:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     58c:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     590:	505f746e 	subspl	r7, pc, lr, ror #8
     594:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     598:	76457373 			; <UNDEFINED> instruction: 0x76457373
     59c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     5a0:	4550475f 	ldrbmi	r4, [r0, #-1887]	; 0xfffff8a1
     5a4:	4c5f5344 	mrrcmi	3, 4, r5, pc, cr4	; <UNPREDICTABLE>
     5a8:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     5ac:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     5b0:	7478656e 	ldrbtvc	r6, [r8], #-1390	; 0xfffffa92
     5b4:	646c6f00 	strbtvs	r6, [ip], #-3840	; 0xfffff100
     5b8:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
     5bc:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     5c0:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     5c4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5c8:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     5cc:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     5d0:	756f6d00 	strbvc	r6, [pc, #-3328]!	; fffff8d8 <__bss_end+0xffff69c4>
     5d4:	6f50746e 	svcvs	0x0050746e
     5d8:	00746e69 	rsbseq	r6, r4, r9, ror #28
     5dc:	69447369 	stmdbvs	r4, {r0, r3, r5, r6, r8, r9, ip, sp, lr}^
     5e0:	74636572 	strbtvc	r6, [r3], #-1394	; 0xfffffa8e
     5e4:	0079726f 	rsbseq	r7, r9, pc, ror #4
     5e8:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     5ec:	6f72505f 	svcvs	0x0072505f
     5f0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     5f4:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     5f8:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     5fc:	74634100 	strbtvc	r4, [r3], #-256	; 0xffffff00
     600:	5f657669 	svcpl	0x00657669
     604:	636f7250 	cmnvs	pc, #80, 4
     608:	5f737365 	svcpl	0x00737365
     60c:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     610:	506d0074 	rsbpl	r0, sp, r4, ror r0
     614:	525f6e69 	subspl	r6, pc, #1680	; 0x690
     618:	72657365 	rsbvc	r7, r5, #-1811939327	; 0x94000001
     61c:	69746176 	ldmdbvs	r4!, {r1, r2, r4, r5, r6, r8, sp, lr}^
     620:	5f736e6f 	svcpl	0x00736e6f
     624:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     628:	61575400 	cmpvs	r7, r0, lsl #8
     62c:	6e697469 	cdpvs	4, 6, cr7, cr9, cr9, {3}
     630:	69465f67 	stmdbvs	r6, {r0, r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     634:	4300656c 	movwmi	r6, #1388	; 0x56c
     638:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
     63c:	72505f65 	subsvc	r5, r0, #404	; 0x194
     640:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     644:	476d0073 			; <UNDEFINED> instruction: 0x476d0073
     648:	004f4950 	subeq	r4, pc, r0, asr r9	; <UNPREDICTABLE>
     64c:	65726170 	ldrbvs	r6, [r2, #-368]!	; 0xfffffe90
     650:	4d00746e 	cfstrsmi	mvf7, [r0, #-440]	; 0xfffffe48
     654:	69467861 	stmdbvs	r6, {r0, r5, r6, fp, ip, sp, lr}^
     658:	616e656c 	cmnvs	lr, ip, ror #10
     65c:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     660:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     664:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     668:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     66c:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     670:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     674:	006f666e 	rsbeq	r6, pc, lr, ror #12
     678:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
     67c:	6b636f6c 	blvs	18dc434 <__bss_end+0x18d3520>
     680:	4400745f 	strmi	r7, [r0], #-1119	; 0xfffffba1
     684:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     688:	5f656e69 	svcpl	0x00656e69
     68c:	68636e55 	stmdavs	r3!, {r0, r2, r4, r6, r9, sl, fp, sp, lr}^
     690:	65676e61 	strbvs	r6, [r7, #-3681]!	; 0xfffff19f
     694:	50430064 	subpl	r0, r3, r4, rrx
     698:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     69c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 4d8 <shift+0x4d8>
     6a0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     6a4:	5f007265 	svcpl	0x00007265
     6a8:	31314e5a 	teqcc	r1, sl, asr lr
     6ac:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     6b0:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     6b4:	436d6574 	cmnmi	sp, #116, 10	; 0x1d000000
     6b8:	00764534 	rsbseq	r4, r6, r4, lsr r5
     6bc:	5f534654 	svcpl	0x00534654
     6c0:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     6c4:	5f007265 	svcpl	0x00007265
     6c8:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     6cc:	6f725043 	svcvs	0x00725043
     6d0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6d4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     6d8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     6dc:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     6e0:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     6e4:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     6e8:	5f72656c 	svcpl	0x0072656c
     6ec:	6f666e49 	svcvs	0x00666e49
     6f0:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     6f4:	5f746547 	svcpl	0x00746547
     6f8:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     6fc:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     700:	545f6f66 	ldrbpl	r6, [pc], #-3942	; 708 <shift+0x708>
     704:	50657079 	rsbpl	r7, r5, r9, ror r0
     708:	5a5f0076 	bpl	17c08e8 <__bss_end+0x17b79d4>
     70c:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     710:	4f495047 	svcmi	0x00495047
     714:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     718:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     71c:	6c433032 	mcrrvs	0, 3, r3, r3, cr2
     720:	5f726165 	svcpl	0x00726165
     724:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     728:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     72c:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     730:	6a45746e 	bvs	115d8f0 <__bss_end+0x11549dc>
     734:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     738:	50433631 	subpl	r3, r3, r1, lsr r6
     73c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     740:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 57c <shift+0x57c>
     744:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     748:	31327265 	teqcc	r2, r5, ror #4
     74c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     750:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     754:	73656c69 	cmnvc	r5, #26880	; 0x6900
     758:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     75c:	57535f6d 	ldrbpl	r5, [r3, -sp, ror #30]
     760:	33324549 	teqcc	r2, #306184192	; 0x12400000
     764:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     768:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     76c:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     770:	5f6d6574 	svcpl	0x006d6574
     774:	76726553 			; <UNDEFINED> instruction: 0x76726553
     778:	6a656369 	bvs	1959524 <__bss_end+0x1950610>
     77c:	31526a6a 	cmpcc	r2, sl, ror #20
     780:	57535431 	smmlarpl	r3, r1, r4, r5
     784:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     788:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     78c:	6c614600 	stclvs	6, cr4, [r1], #-0
     790:	676e696c 	strbvs	r6, [lr, -ip, ror #18]!
     794:	6764455f 			; <UNDEFINED> instruction: 0x6764455f
     798:	706f0065 	rsbvc	r0, pc, r5, rrx
     79c:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     7a0:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     7a4:	4e007365 	cdpmi	3, 0, cr7, cr0, cr5, {3}
     7a8:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     7ac:	6c6c4179 	stfvse	f4, [ip], #-484	; 0xfffffe1c
     7b0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     7b4:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     7b8:	5f4f4950 	svcpl	0x004f4950
     7bc:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     7c0:	3272656c 	rsbscc	r6, r2, #108, 10	; 0x1b000000
     7c4:	73694430 	cmnvc	r9, #48, 8	; 0x30000000
     7c8:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     7cc:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     7d0:	445f746e 	ldrbmi	r7, [pc], #-1134	; 7d8 <shift+0x7d8>
     7d4:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     7d8:	326a4574 	rsbcc	r4, sl, #116, 10	; 0x1d000000
     7dc:	50474e30 	subpl	r4, r7, r0, lsr lr
     7e0:	495f4f49 	ldmdbmi	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     7e4:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     7e8:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     7ec:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     7f0:	43540065 	cmpmi	r4, #101	; 0x65
     7f4:	435f5550 	cmpmi	pc, #80, 10	; 0x14000000
     7f8:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     7fc:	44007478 	strmi	r7, [r0], #-1144	; 0xfffffb88
     800:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     804:	00656e69 	rsbeq	r6, r5, r9, ror #28
     808:	72627474 	rsbvc	r7, r2, #116, 8	; 0x74000000
     80c:	5a5f0030 	bpl	17c08d4 <__bss_end+0x17b79c0>
     810:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     814:	636f7250 	cmnvs	pc, #80, 4
     818:	5f737365 	svcpl	0x00737365
     81c:	616e614d 	cmnvs	lr, sp, asr #2
     820:	31726567 	cmncc	r2, r7, ror #10
     824:	746f4e34 	strbtvc	r4, [pc], #-3636	; 82c <shift+0x82c>
     828:	5f796669 	svcpl	0x00796669
     82c:	636f7250 	cmnvs	pc, #80, 4
     830:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     834:	6547006a 	strbvs	r0, [r7, #-106]	; 0xffffff96
     838:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     83c:	53420044 	movtpl	r0, #8260	; 0x2044
     840:	425f3043 	subsmi	r3, pc, #67	; 0x43
     844:	00657361 	rsbeq	r7, r5, r1, ror #6
     848:	646e6946 	strbtvs	r6, [lr], #-2374	; 0xfffff6ba
     84c:	6968435f 	stmdbvs	r8!, {r0, r1, r2, r3, r4, r6, r8, r9, lr}^
     850:	6e00646c 	cdpvs	4, 0, cr6, cr0, cr12, {3}
     854:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     858:	5f646569 	svcpl	0x00646569
     85c:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     860:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     864:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
     868:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     86c:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
     870:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
     874:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
     878:	61425f72 	hvcvs	9714	; 0x25f2
     87c:	5f006573 	svcpl	0x00006573
     880:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     884:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     888:	61485f4f 	cmpvs	r8, pc, asr #30
     88c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     890:	72463872 	subvc	r3, r6, #7471104	; 0x720000
     894:	505f6565 	subspl	r6, pc, r5, ror #10
     898:	6a456e69 	bvs	115c244 <__bss_end+0x1153330>
     89c:	42006262 	andmi	r6, r0, #536870918	; 0x20000006
     8a0:	5f314353 	svcpl	0x00314353
     8a4:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     8a8:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     8ac:	6f72505f 	svcvs	0x0072505f
     8b0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     8b4:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     8b8:	5f64656e 	svcpl	0x0064656e
     8bc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     8c0:	5a5f0073 	bpl	17c0a94 <__bss_end+0x17b7b80>
     8c4:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     8c8:	636f7250 	cmnvs	pc, #80, 4
     8cc:	5f737365 	svcpl	0x00737365
     8d0:	616e614d 	cmnvs	lr, sp, asr #2
     8d4:	31726567 	cmncc	r2, r7, ror #10
     8d8:	6d6e5538 	cfstr64vs	mvdx5, [lr, #-224]!	; 0xffffff20
     8dc:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     8e0:	5f656c69 	svcpl	0x00656c69
     8e4:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     8e8:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
     8ec:	5254006a 	subspl	r0, r4, #106	; 0x6a
     8f0:	425f474e 	subsmi	r4, pc, #20447232	; 0x1380000
     8f4:	00657361 	rsbeq	r7, r5, r1, ror #6
     8f8:	68676948 	stmdavs	r7!, {r3, r6, r8, fp, sp, lr}^
     8fc:	53466700 	movtpl	r6, #26368	; 0x6700
     900:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
     904:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     908:	756f435f 	strbvc	r4, [pc, #-863]!	; 5b1 <shift+0x5b1>
     90c:	5f00746e 	svcpl	0x0000746e
     910:	314b4e5a 	cmpcc	fp, sl, asr lr
     914:	50474333 	subpl	r4, r7, r3, lsr r3
     918:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     91c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     920:	36327265 	ldrtcc	r7, [r2], -r5, ror #4
     924:	5f746547 	svcpl	0x00746547
     928:	495f5047 	ldmdbmi	pc, {r0, r1, r2, r6, ip, lr}^	; <UNPREDICTABLE>
     92c:	445f5152 	ldrbmi	r5, [pc], #-338	; 934 <shift+0x934>
     930:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     934:	6f4c5f74 	svcvs	0x004c5f74
     938:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     93c:	6a456e6f 	bvs	115c300 <__bss_end+0x11533ec>
     940:	474e3032 	smlaldxmi	r3, lr, r2, r0
     944:	5f4f4950 	svcpl	0x004f4950
     948:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     94c:	70757272 	rsbsvc	r7, r5, r2, ror r2
     950:	79545f74 	ldmdbvc	r4, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     954:	6a526570 	bvs	1499f1c <__bss_end+0x1491008>
     958:	005f3153 	subseq	r3, pc, r3, asr r1	; <UNPREDICTABLE>
     95c:	69736952 	ldmdbvs	r3!, {r1, r4, r6, r8, fp, sp, lr}^
     960:	455f676e 	ldrbmi	r6, [pc, #-1902]	; 1fa <shift+0x1fa>
     964:	00656764 	rsbeq	r6, r5, r4, ror #14
     968:	6f6f526d 	svcvs	0x006f526d
     96c:	79535f74 	ldmdbvc	r3, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     970:	55410073 	strbpl	r0, [r1, #-115]	; 0xffffff8d
     974:	61425f58 	cmpvs	r2, r8, asr pc
     978:	47006573 	smlsdxmi	r0, r3, r5, r6
     97c:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     980:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     984:	505f746e 	subspl	r7, pc, lr, ror #8
     988:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     98c:	4d007373 	stcmi	3, cr7, [r0, #-460]	; 0xfffffe34
     990:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     994:	5f656c69 	svcpl	0x00656c69
     998:	435f6f54 	cmpmi	pc, #84, 30	; 0x150
     99c:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     9a0:	5f00746e 	svcpl	0x0000746e
     9a4:	314b4e5a 	cmpcc	fp, sl, asr lr
     9a8:	50474333 	subpl	r4, r7, r3, lsr r3
     9ac:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     9b0:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     9b4:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     9b8:	5f746547 	svcpl	0x00746547
     9bc:	53465047 	movtpl	r5, #24647	; 0x6047
     9c0:	4c5f4c45 	mrrcmi	12, 4, r4, pc, cr5	; <UNPREDICTABLE>
     9c4:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     9c8:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     9cc:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     9d0:	4e005f30 	mcrmi	15, 0, r5, cr0, cr0, {1}
     9d4:	6c69466f 	stclvs	6, cr4, [r9], #-444	; 0xfffffe44
     9d8:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     9dc:	446d6574 	strbtmi	r6, [sp], #-1396	; 0xfffffa8c
     9e0:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     9e4:	65530072 	ldrbvs	r0, [r3, #-114]	; 0xffffff8e
     9e8:	61505f74 	cmpvs	r0, r4, ror pc
     9ec:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     9f0:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     9f4:	5f656c64 	svcpl	0x00656c64
     9f8:	636f7250 	cmnvs	pc, #80, 4
     9fc:	5f737365 	svcpl	0x00737365
     a00:	00495753 	subeq	r5, r9, r3, asr r7
     a04:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     a08:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
     a0c:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     a10:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
     a14:	5300746e 	movwpl	r7, #1134	; 0x46e
     a18:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     a1c:	5f656c75 	svcpl	0x00656c75
     a20:	00464445 	subeq	r4, r6, r5, asr #8
     a24:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     a28:	73694400 	cmnvc	r9, #0, 8
     a2c:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     a30:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     a34:	445f746e 	ldrbmi	r7, [pc], #-1134	; a3c <shift+0xa3c>
     a38:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     a3c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     a40:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     a44:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     a48:	5f4f4950 	svcpl	0x004f4950
     a4c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     a50:	3172656c 	cmncc	r2, ip, ror #10
     a54:	6e614830 	mcrvs	8, 3, r4, cr1, cr0, {1}
     a58:	5f656c64 	svcpl	0x00656c64
     a5c:	45515249 	ldrbmi	r5, [r1, #-585]	; 0xfffffdb7
     a60:	5a5f0076 	bpl	17c0c40 <__bss_end+0x17b7d2c>
     a64:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
     a68:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     a6c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     a70:	30316d65 	eorscc	r6, r1, r5, ror #26
     a74:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
     a78:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     a7c:	7645657a 			; <UNDEFINED> instruction: 0x7645657a
     a80:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     a84:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     a88:	65746365 	ldrbvs	r6, [r4, #-869]!	; 0xfffffc9b
     a8c:	76455f64 	strbvc	r5, [r5], -r4, ror #30
     a90:	5f746e65 	svcpl	0x00746e65
     a94:	006e6950 	rsbeq	r6, lr, r0, asr r9
     a98:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     a9c:	70757272 	rsbsvc	r7, r5, r2, ror r2
     aa0:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
     aa4:	6c535f65 	mrrcvs	15, 6, r5, r3, cr5
     aa8:	00706565 	rsbseq	r6, r0, r5, ror #10
     aac:	6f6f526d 	svcvs	0x006f526d
     ab0:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     ab4:	6f620076 	svcvs	0x00620076
     ab8:	41006c6f 	tstmi	r0, pc, ror #24
     abc:	315f746c 	cmpcc	pc, ip, ror #8
     ac0:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     ac4:	6d00325f 	sfmvs	f3, 4, [r0, #-380]	; 0xfffffe84
     ac8:	7473614c 	ldrbtvc	r6, [r3], #-332	; 0xfffffeb4
     acc:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     ad0:	6f6c4200 	svcvs	0x006c4200
     ad4:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     ad8:	65474e00 	strbvs	r4, [r7, #-3584]	; 0xfffff200
     adc:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     ae0:	5f646568 	svcpl	0x00646568
     ae4:	6f666e49 	svcvs	0x00666e49
     ae8:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     aec:	6c410065 	mcrrvs	0, 6, r0, r1, cr5
     af0:	00355f74 	eorseq	r5, r5, r4, ror pc
     af4:	314e5a5f 	cmpcc	lr, pc, asr sl
     af8:	50474333 	subpl	r4, r7, r3, lsr r3
     afc:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     b00:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     b04:	30317265 	eorscc	r7, r1, r5, ror #4
     b08:	5f746553 	svcpl	0x00746553
     b0c:	7074754f 	rsbsvc	r7, r4, pc, asr #10
     b10:	6a457475 	bvs	115dcec <__bss_end+0x1154dd8>
     b14:	75520062 	ldrbvc	r0, [r2, #-98]	; 0xffffff9e
     b18:	62616e6e 	rsbvs	r6, r1, #1760	; 0x6e0
     b1c:	4e00656c 	cfsh32mi	mvfx6, mvfx0, #60
     b20:	6b736154 	blvs	1cd9078 <__bss_end+0x1cd0164>
     b24:	6174535f 	cmnvs	r4, pc, asr r3
     b28:	73006574 	movwvc	r6, #1396	; 0x574
     b2c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     b30:	756f635f 	strbvc	r6, [pc, #-863]!	; 7d9 <shift+0x7d9>
     b34:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     b38:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     b3c:	735f6465 	cmpvc	pc, #1694498816	; 0x65000000
     b40:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     b44:	72705f63 	rsbsvc	r5, r0, #396	; 0x18c
     b48:	69726f69 	ldmdbvs	r2!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     b4c:	49007974 	stmdbmi	r0, {r2, r4, r5, r6, r8, fp, ip, sp, lr}
     b50:	6974696e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, fp, sp, lr}^
     b54:	7a696c61 	bvc	1a5bce0 <__bss_end+0x1a52dcc>
     b58:	682f0065 	stmdavs	pc!, {r0, r2, r5, r6}	; <UNPREDICTABLE>
     b5c:	2f656d6f 	svccs	0x00656d6f
     b60:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
     b64:	642f6b69 	strtvs	r6, [pc], #-2921	; b6c <shift+0xb6c>
     b68:	4b2f7665 	blmi	bde504 <__bss_end+0xbd55f0>
     b6c:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
     b70:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
     b74:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
     b78:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
     b7c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     b80:	752f7365 	strvc	r7, [pc, #-869]!	; 823 <shift+0x823>
     b84:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     b88:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     b8c:	6c69742f 	cfstrdvs	mvd7, [r9], #-188	; 0xffffff44
     b90:	61745f74 	cmnvs	r4, r4, ror pc
     b94:	6d2f6b73 	fstmdbxvs	pc!, {d6-d62}	;@ Deprecated
     b98:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
     b9c:	00707063 	rsbseq	r7, r0, r3, rrx
     ba0:	5f534667 	svcpl	0x00534667
     ba4:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     ba8:	00737265 	rsbseq	r7, r3, r5, ror #4
     bac:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     bb0:	646f635f 	strbtvs	r6, [pc], #-863	; bb8 <shift+0xbb8>
     bb4:	6e490065 	cdpvs	0, 4, cr0, cr9, cr5, {3}
     bb8:	696c6176 	stmdbvs	ip!, {r1, r2, r4, r5, r6, r8, sp, lr}^
     bbc:	69505f64 	ldmdbvs	r0, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     bc0:	6e45006e 	cdpvs	0, 4, cr0, cr5, cr14, {3}
     bc4:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     bc8:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     bcc:	445f746e 	ldrbmi	r7, [pc], #-1134	; bd4 <shift+0xbd4>
     bd0:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     bd4:	47730074 			; <UNDEFINED> instruction: 0x47730074
     bd8:	004f4950 	subeq	r4, pc, r0, asr r9	; <UNPREDICTABLE>
     bdc:	6863536d 	stmdavs	r3!, {r0, r2, r3, r5, r6, r8, r9, ip, lr}^
     be0:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     be4:	6e465f65 	cdpvs	15, 4, cr5, cr6, cr5, {3}
     be8:	50470063 	subpl	r0, r7, r3, rrx
     bec:	425f4f49 	subsmi	r4, pc, #292	; 0x124
     bf0:	00657361 	rsbeq	r7, r5, r1, ror #6
     bf4:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
     bf8:	69724453 	ldmdbvs	r2!, {r0, r1, r4, r6, sl, lr}^
     bfc:	4e726576 	mrcmi	5, 3, r6, cr2, cr6, {3}
     c00:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
     c04:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     c08:	6f4e0068 	svcvs	0x004e0068
     c0c:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     c10:	66654400 	strbtvs	r4, [r5], -r0, lsl #8
     c14:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
     c18:	6f6c435f 	svcvs	0x006c435f
     c1c:	525f6b63 	subspl	r6, pc, #101376	; 0x18c00
     c20:	00657461 	rsbeq	r7, r5, r1, ror #8
     c24:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     c28:	726f465f 	rsbvc	r4, pc, #99614720	; 0x5f00000
     c2c:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     c30:	5f00746e 	svcpl	0x0000746e
     c34:	314b4e5a 	cmpcc	fp, sl, asr lr
     c38:	50474333 	subpl	r4, r7, r3, lsr r3
     c3c:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     c40:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     c44:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     c48:	5f746547 	svcpl	0x00746547
     c4c:	4c435047 	mcrrmi	0, 4, r5, r3, cr7
     c50:	6f4c5f52 	svcvs	0x004c5f52
     c54:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     c58:	6a456e6f 	bvs	115c61c <__bss_end+0x1153708>
     c5c:	30536a52 	subscc	r6, r3, r2, asr sl
     c60:	6f4c005f 	svcvs	0x004c005f
     c64:	555f6b63 	ldrbpl	r6, [pc, #-2915]	; 109 <shift+0x109>
     c68:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     c6c:	0064656b 	rsbeq	r6, r4, fp, ror #10
     c70:	5f746547 	svcpl	0x00746547
     c74:	495f5047 	ldmdbmi	pc, {r0, r1, r2, r6, ip, lr}^	; <UNPREDICTABLE>
     c78:	445f5152 	ldrbmi	r5, [pc], #-338	; c80 <shift+0xc80>
     c7c:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     c80:	6f4c5f74 	svcvs	0x004c5f74
     c84:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     c88:	47006e6f 	strmi	r6, [r0, -pc, ror #28]
     c8c:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     c90:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
     c94:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     c98:	6f697461 	svcvs	0x00697461
     c9c:	6f4c006e 	svcvs	0x004c006e
     ca0:	4c5f6b63 	mrrcmi	11, 6, r6, pc, cr3	; <UNPREDICTABLE>
     ca4:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     ca8:	506d0064 	rsbpl	r0, sp, r4, rrx
     cac:	525f6e69 	subspl	r6, pc, #1680	; 0x690
     cb0:	72657365 	rsbvc	r7, r5, #-1811939327	; 0x94000001
     cb4:	69746176 	ldmdbvs	r4!, {r1, r2, r4, r5, r6, r8, sp, lr}^
     cb8:	5f736e6f 	svcpl	0x00736e6f
     cbc:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     cc0:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     cc4:	50475f74 	subpl	r5, r7, r4, ror pc
     cc8:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     ccc:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     cd0:	6f697461 	svcvs	0x00697461
     cd4:	6553006e 	ldrbvs	r0, [r3, #-110]	; 0xffffff92
     cd8:	754f5f74 	strbvc	r5, [pc, #-3956]	; fffffd6c <__bss_end+0xffff6e58>
     cdc:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
     ce0:	61655200 	cmnvs	r5, r0, lsl #4
     ce4:	72575f64 	subsvc	r5, r7, #100, 30	; 0x190
     ce8:	00657469 	rsbeq	r7, r5, r9, ror #8
     cec:	626d6f5a 	rsbvs	r6, sp, #360	; 0x168
     cf0:	5f006569 	svcpl	0x00006569
     cf4:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     cf8:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     cfc:	61485f4f 	cmpvs	r8, pc, asr #30
     d00:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     d04:	53373172 	teqpl	r7, #-2147483620	; 0x8000001c
     d08:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     d0c:	5f4f4950 	svcpl	0x004f4950
     d10:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     d14:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     d18:	34316a45 	ldrtcc	r6, [r1], #-2629	; 0xfffff5bb
     d1c:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     d20:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     d24:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     d28:	47006e6f 	strmi	r6, [r0, -pc, ror #28]
     d2c:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     d30:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     d34:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     d38:	5a5f006f 	bpl	17c0efc <__bss_end+0x17b7fe8>
     d3c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     d40:	636f7250 	cmnvs	pc, #80, 4
     d44:	5f737365 	svcpl	0x00737365
     d48:	616e614d 	cmnvs	lr, sp, asr #2
     d4c:	38726567 	ldmdacc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
     d50:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     d54:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     d58:	5f007645 	svcpl	0x00007645
     d5c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     d60:	6f725043 	svcvs	0x00725043
     d64:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     d68:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     d6c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     d70:	614d3931 	cmpvs	sp, r1, lsr r9
     d74:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     d78:	545f656c 	ldrbpl	r6, [pc], #-1388	; d80 <shift+0xd80>
     d7c:	75435f6f 	strbvc	r5, [r3, #-3951]	; 0xfffff091
     d80:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     d84:	35504574 	ldrbcc	r4, [r0, #-1396]	; 0xfffffa8c
     d88:	6c694649 	stclvs	6, cr4, [r9], #-292	; 0xfffffedc
     d8c:	69440065 	stmdbvs	r4, {r0, r2, r5, r6}^
     d90:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     d94:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     d98:	5f746e65 	svcpl	0x00746e65
     d9c:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     da0:	47007463 	strmi	r7, [r0, -r3, ror #8]
     da4:	505f7465 	subspl	r7, pc, r5, ror #8
     da8:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     dac:	68630073 	stmdavs	r3!, {r0, r1, r4, r5, r6}^
     db0:	72646c69 	rsbvc	r6, r4, #26880	; 0x6900
     db4:	4d006e65 	stcmi	14, cr6, [r0, #-404]	; 0xfffffe6c
     db8:	61507861 	cmpvs	r0, r1, ror #16
     dbc:	654c6874 	strbvs	r6, [ip, #-2164]	; 0xfffff78c
     dc0:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     dc4:	736e7500 	cmnvc	lr, #0, 10
     dc8:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     dcc:	68632064 	stmdavs	r3!, {r2, r5, r6, sp}^
     dd0:	5f007261 	svcpl	0x00007261
     dd4:	314b4e5a 	cmpcc	fp, sl, asr lr
     dd8:	50474333 	subpl	r4, r7, r3, lsr r3
     ddc:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     de0:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     de4:	32327265 	eorscc	r7, r2, #1342177286	; 0x50000006
     de8:	5f746547 	svcpl	0x00746547
     dec:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     df0:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     df4:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     df8:	505f746e 	subspl	r7, pc, lr, ror #8
     dfc:	76456e69 	strbvc	r6, [r5], -r9, ror #28
     e00:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     e04:	50433631 	subpl	r3, r3, r1, lsr r6
     e08:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     e0c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; c48 <shift+0xc48>
     e10:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     e14:	32317265 	eorscc	r7, r1, #1342177286	; 0x50000006
     e18:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     e1c:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     e20:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     e24:	43007645 	movwmi	r7, #1605	; 0x645
     e28:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     e2c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     e30:	47006d65 	strmi	r6, [r0, -r5, ror #26]
     e34:	5f4f4950 	svcpl	0x004f4950
     e38:	5f6e6950 	svcpl	0x006e6950
     e3c:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     e40:	68730074 	ldmdavs	r3!, {r2, r4, r5, r6}^
     e44:	2074726f 	rsbscs	r7, r4, pc, ror #4
     e48:	00746e69 	rsbseq	r6, r4, r9, ror #28
     e4c:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     e50:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 8ec <shift+0x8ec>
     e54:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     e58:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     e5c:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     e60:	5f006e6f 	svcpl	0x00006e6f
     e64:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     e68:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     e6c:	61485f4f 	cmpvs	r8, pc, asr #30
     e70:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     e74:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     e78:	6550006a 	ldrbvs	r0, [r0, #-106]	; 0xffffff96
     e7c:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     e80:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
     e84:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     e88:	526d0065 	rsbpl	r0, sp, #101	; 0x65
     e8c:	00746f6f 	rsbseq	r6, r4, pc, ror #30
     e90:	6c694673 	stclvs	6, cr4, [r9], #-460	; 0xfffffe34
     e94:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     e98:	006d6574 	rsbeq	r6, sp, r4, ror r5
     e9c:	636f4c6d 	cmnvs	pc, #27904	; 0x6d00
     ea0:	7552006b 	ldrbvc	r0, [r2, #-107]	; 0xffffff95
     ea4:	6e696e6e 	cdpvs	14, 6, cr6, cr9, cr14, {3}
     ea8:	5a5f0067 	bpl	17c104c <__bss_end+0x17b8138>
     eac:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     eb0:	4f495047 	svcmi	0x00495047
     eb4:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     eb8:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     ebc:	61573431 	cmpvs	r7, r1, lsr r4
     ec0:	465f7469 	ldrbmi	r7, [pc], -r9, ror #8
     ec4:	455f726f 	ldrbmi	r7, [pc, #-623]	; c5d <shift+0xc5d>
     ec8:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     ecc:	49355045 	ldmdbmi	r5!, {r0, r2, r6, ip, lr}
     ed0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     ed4:	6974006a 	ldmdbvs	r4!, {r1, r3, r5, r6}^
     ed8:	6573746c 	ldrbvs	r7, [r3, #-1132]!	; 0xfffffb94
     edc:	726f736e 	rsbvc	r7, pc, #-1207959551	; 0xb8000001
     ee0:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     ee4:	69750065 	ldmdbvs	r5!, {r0, r2, r5, r6}^
     ee8:	3233746e 	eorscc	r7, r3, #1845493760	; 0x6e000000
     eec:	5200745f 	andpl	r7, r0, #1593835520	; 0x5f000000
     ef0:	72657365 	rsbvc	r7, r5, #-1811939327	; 0x94000001
     ef4:	505f6576 	subspl	r6, pc, r6, ror r5	; <UNPREDICTABLE>
     ef8:	47006e69 	strmi	r6, [r0, -r9, ror #28]
     efc:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     f00:	5f4f4950 	svcpl	0x004f4950
     f04:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     f08:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     f0c:	6d695400 	cfstrdvs	mvd5, [r9, #-0]
     f10:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     f14:	00657361 	rsbeq	r7, r5, r1, ror #6
     f18:	7275436d 	rsbsvc	r4, r5, #-1275068415	; 0xb4000001
     f1c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     f20:	7361545f 	cmnvc	r1, #1593835520	; 0x5f000000
     f24:	6f4e5f6b 	svcvs	0x004e5f6b
     f28:	5f006564 	svcpl	0x00006564
     f2c:	31314e5a 	teqcc	r1, sl, asr lr
     f30:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     f34:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     f38:	346d6574 	strbtcc	r6, [sp], #-1396	; 0xfffffa8c
     f3c:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     f40:	634b5045 	movtvs	r5, #45125	; 0xb045
     f44:	464e3531 			; <UNDEFINED> instruction: 0x464e3531
     f48:	5f656c69 	svcpl	0x00656c69
     f4c:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     f50:	646f4d5f 	strbtvs	r4, [pc], #-3423	; f58 <shift+0xf58>
     f54:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     f58:	50475f74 	subpl	r5, r7, r4, ror pc
     f5c:	5f544553 	svcpl	0x00544553
     f60:	61636f4c 	cmnvs	r3, ip, asr #30
     f64:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     f68:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     f6c:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     f70:	4f495047 	svcmi	0x00495047
     f74:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     f78:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     f7c:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     f80:	50475f74 	subpl	r5, r7, r4, ror pc
     f84:	5f56454c 	svcpl	0x0056454c
     f88:	61636f4c 	cmnvs	r3, ip, asr #30
     f8c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     f90:	6a526a45 	bvs	149b8ac <__bss_end+0x1492998>
     f94:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     f98:	6961576d 	stmdbvs	r1!, {r0, r2, r3, r5, r6, r8, r9, sl, ip, lr}^
     f9c:	676e6974 			; <UNDEFINED> instruction: 0x676e6974
     fa0:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     fa4:	64007365 	strvs	r7, [r0], #-869	; 0xfffffc9b
     fa8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     fac:	64695f72 	strbtvs	r5, [r9], #-3954	; 0xfffff08e
     fb0:	65520078 	ldrbvs	r0, [r2, #-120]	; 0xffffff88
     fb4:	4f5f6461 	svcmi	0x005f6461
     fb8:	00796c6e 	rsbseq	r6, r9, lr, ror #24
     fbc:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
     fc0:	69745f70 	ldmdbvs	r4!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     fc4:	0072656d 	rsbseq	r6, r2, sp, ror #10
     fc8:	4b4e5a5f 	blmi	139794c <__bss_end+0x138ea38>
     fcc:	50433631 	subpl	r3, r3, r1, lsr r6
     fd0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     fd4:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; e10 <shift+0xe10>
     fd8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     fdc:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     fe0:	5f746547 	svcpl	0x00746547
     fe4:	636f7250 	cmnvs	pc, #80, 4
     fe8:	5f737365 	svcpl	0x00737365
     fec:	505f7942 	subspl	r7, pc, r2, asr #18
     ff0:	6a454449 	bvs	115211c <__bss_end+0x1149208>
     ff4:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     ff8:	5f656c64 	svcpl	0x00656c64
     ffc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1000:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    1004:	535f6d65 	cmppl	pc, #6464	; 0x1940
    1008:	5f004957 	svcpl	0x00004957
    100c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1010:	6f725043 	svcvs	0x00725043
    1014:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1018:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    101c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1020:	63533131 	cmpvs	r3, #1073741836	; 0x4000000c
    1024:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
    1028:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
    102c:	00764552 	rsbseq	r4, r6, r2, asr r5
    1030:	6b736174 	blvs	1cd9608 <__bss_end+0x1cd06f4>
    1034:	74726900 	ldrbtvc	r6, [r2], #-2304	; 0xfffff700
    1038:	00657079 	rsbeq	r7, r5, r9, ror r0
    103c:	5f746547 	svcpl	0x00746547
    1040:	75706e49 	ldrbvc	r6, [r0, #-3657]!	; 0xfffff1b7
    1044:	6f4e0074 	svcvs	0x004e0074
    1048:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
    104c:	6f72505f 	svcvs	0x0072505f
    1050:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1054:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
    1058:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
    105c:	50730065 	rsbspl	r0, r3, r5, rrx
    1060:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1064:	674d7373 	smlsldxvs	r7, sp, r3, r3
    1068:	5a5f0072 	bpl	17c1238 <__bss_end+0x17b8324>
    106c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    1070:	636f7250 	cmnvs	pc, #80, 4
    1074:	5f737365 	svcpl	0x00737365
    1078:	616e614d 	cmnvs	lr, sp, asr #2
    107c:	39726567 	ldmdbcc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
    1080:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
    1084:	545f6863 	ldrbpl	r6, [pc], #-2147	; 108c <shift+0x108c>
    1088:	3150456f 	cmpcc	r0, pc, ror #10
    108c:	72504338 	subsvc	r4, r0, #56, 6	; 0xe0000000
    1090:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1094:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1098:	4e5f7473 	mrcmi	4, 2, r7, cr15, cr3, {3}
    109c:	0065646f 	rsbeq	r6, r5, pc, ror #8
    10a0:	4b4e5a5f 	blmi	1397a24 <__bss_end+0x138eb10>
    10a4:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
    10a8:	5f4f4950 	svcpl	0x004f4950
    10ac:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    10b0:	3172656c 	cmncc	r2, ip, ror #10
    10b4:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
    10b8:	4550475f 	ldrbmi	r4, [r0, #-1887]	; 0xfffff8a1
    10bc:	4c5f5344 	mrrcmi	3, 4, r5, pc, cr4	; <UNPREDICTABLE>
    10c0:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
    10c4:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
    10c8:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
    10cc:	53005f30 	movwpl	r5, #3888	; 0xf30
    10d0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    10d4:	5f656c75 	svcpl	0x00656c75
    10d8:	47005252 	smlsdmi	r0, r2, r2, r5
    10dc:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
    10e0:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
    10e4:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
    10e8:	6f697461 	svcvs	0x00697461
    10ec:	5a5f006e 	bpl	17c12ac <__bss_end+0x17b8398>
    10f0:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    10f4:	636f7250 	cmnvs	pc, #80, 4
    10f8:	5f737365 	svcpl	0x00737365
    10fc:	616e614d 	cmnvs	lr, sp, asr #2
    1100:	31726567 	cmncc	r2, r7, ror #10
    1104:	6e614838 	mcrvs	8, 3, r4, cr1, cr8, {1}
    1108:	5f656c64 	svcpl	0x00656c64
    110c:	636f7250 	cmnvs	pc, #80, 4
    1110:	5f737365 	svcpl	0x00737365
    1114:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
    1118:	534e3032 	movtpl	r3, #57394	; 0xe032
    111c:	505f4957 	subspl	r4, pc, r7, asr r9	; <UNPREDICTABLE>
    1120:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1124:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
    1128:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    112c:	6a6a6563 	bvs	1a9a6c0 <__bss_end+0x1a917ac>
    1130:	3131526a 	teqcc	r1, sl, ror #4
    1134:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
    1138:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
    113c:	00746c75 	rsbseq	r6, r4, r5, ror ip
    1140:	76677261 	strbtvc	r7, [r7], -r1, ror #4
    1144:	4f494e00 	svcmi	0x00494e00
    1148:	5f6c7443 	svcpl	0x006c7443
    114c:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
    1150:	6f697461 	svcvs	0x00697461
    1154:	5a5f006e 	bpl	17c1314 <__bss_end+0x17b8400>
    1158:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    115c:	636f7250 	cmnvs	pc, #80, 4
    1160:	5f737365 	svcpl	0x00737365
    1164:	616e614d 	cmnvs	lr, sp, asr #2
    1168:	31726567 	cmncc	r2, r7, ror #10
    116c:	65724334 	ldrbvs	r4, [r2, #-820]!	; 0xfffffccc
    1170:	5f657461 	svcpl	0x00657461
    1174:	636f7250 	cmnvs	pc, #80, 4
    1178:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
    117c:	626a6850 	rsbvs	r6, sl, #80, 16	; 0x500000
    1180:	69775300 	ldmdbvs	r7!, {r8, r9, ip, lr}^
    1184:	5f686374 	svcpl	0x00686374
    1188:	4e006f54 	mcrmi	15, 0, r6, cr0, cr4, {2}
    118c:	5f495753 	svcpl	0x00495753
    1190:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1194:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    1198:	535f6d65 	cmppl	pc, #6464	; 0x1940
    119c:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    11a0:	5f006563 	svcpl	0x00006563
    11a4:	314b4e5a 	cmpcc	fp, sl, asr lr
    11a8:	50474333 	subpl	r4, r7, r3, lsr r3
    11ac:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
    11b0:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    11b4:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
    11b8:	5f746547 	svcpl	0x00746547
    11bc:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
    11c0:	6f4c5f54 	svcvs	0x004c5f54
    11c4:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
    11c8:	6a456e6f 	bvs	115cb8c <__bss_end+0x1153c78>
    11cc:	30536a52 	subscc	r6, r3, r2, asr sl
    11d0:	6c43005f 	mcrrvs	0, 5, r0, r3, cr15
    11d4:	5f726165 	svcpl	0x00726165
    11d8:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
    11dc:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
    11e0:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
    11e4:	4900746e 	stmdbmi	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
    11e8:	6c61766e 	stclvs	6, cr7, [r1], #-440	; 0xfffffe48
    11ec:	485f6469 	ldmdami	pc, {r0, r3, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
    11f0:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    11f4:	46540065 	ldrbmi	r0, [r4], -r5, rrx
    11f8:	72545f53 	subsvc	r5, r4, #332	; 0x14c
    11fc:	4e5f6565 	cdpmi	5, 5, cr6, cr15, cr5, {3}
    1200:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1204:	636f6c42 	cmnvs	pc, #16896	; 0x4200
    1208:	75435f6b 	strbvc	r5, [r3, #-3947]	; 0xfffff095
    120c:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
    1210:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
    1214:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1218:	69700073 	ldmdbvs	r0!, {r0, r1, r4, r5, r6}^
    121c:	64695f6e 	strbtvs	r5, [r9], #-3950	; 0xfffff092
    1220:	72460078 	subvc	r0, r6, #120	; 0x78
    1224:	505f6565 	subspl	r6, pc, r5, ror #10
    1228:	5f006e69 	svcpl	0x00006e69
    122c:	314b4e5a 	cmpcc	fp, sl, asr lr
    1230:	50474333 	subpl	r4, r7, r3, lsr r3
    1234:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
    1238:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    123c:	37317265 	ldrcc	r7, [r1, -r5, ror #4]!
    1240:	5f746547 	svcpl	0x00746547
    1244:	4f495047 	svcmi	0x00495047
    1248:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
    124c:	6f697463 	svcvs	0x00697463
    1250:	006a456e 	rsbeq	r4, sl, lr, ror #10
    1254:	736f6c43 	cmnvc	pc, #17152	; 0x4300
    1258:	72640065 	rsbvc	r0, r4, #101	; 0x65
    125c:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
    1260:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
    1264:	46490063 	strbmi	r0, [r9], -r3, rrx
    1268:	73656c69 	cmnvc	r5, #26880	; 0x6900
    126c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
    1270:	72445f6d 	subvc	r5, r4, #436	; 0x1b4
    1274:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
    1278:	50474300 	subpl	r4, r7, r0, lsl #6
    127c:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
    1280:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    1284:	55007265 	strpl	r7, [r0, #-613]	; 0xfffffd9b
    1288:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
    128c:	69666963 	stmdbvs	r6!, {r0, r1, r5, r6, r8, fp, sp, lr}^
    1290:	57006465 	strpl	r6, [r0, -r5, ror #8]
    1294:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    1298:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
    129c:	616d0079 	smcvs	53257	; 0xd009
    12a0:	59006e69 	stmdbpl	r0, {r0, r3, r5, r6, r9, sl, fp, sp, lr}
    12a4:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
    12a8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    12ac:	50433631 	subpl	r3, r3, r1, lsr r6
    12b0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    12b4:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 10f0 <shift+0x10f0>
    12b8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    12bc:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
    12c0:	6d007645 	stcvs	6, cr7, [r0, #-276]	; 0xfffffeec
    12c4:	746f6f52 	strbtvc	r6, [pc], #-3922	; 12cc <shift+0x12cc>
    12c8:	746e4d5f 	strbtvc	r4, [lr], #-3423	; 0xfffff2a1
    12cc:	75706300 	ldrbvc	r6, [r0, #-768]!	; 0xfffffd00
    12d0:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    12d4:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    12d8:	72655400 	rsbvc	r5, r5, #0, 8
    12dc:	616e696d 	cmnvs	lr, sp, ror #18
    12e0:	49006574 	stmdbmi	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
    12e4:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
    12e8:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
    12ec:	5f656c64 	svcpl	0x00656c64
    12f0:	00515249 	subseq	r5, r1, r9, asr #4
    12f4:	70676f6c 	rsbvc	r6, r7, ip, ror #30
    12f8:	00657069 	rsbeq	r7, r5, r9, rrx
    12fc:	736f6c63 	cmnvc	pc, #25344	; 0x6300
    1300:	65530065 	ldrbvs	r0, [r3, #-101]	; 0xffffff9b
    1304:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
    1308:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    130c:	47006576 	smlsdxmi	r0, r6, r5, r6
    1310:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    1314:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
    1318:	332e3820 			; <UNDEFINED> instruction: 0x332e3820
    131c:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    1320:	30393130 	eorscc	r3, r9, r0, lsr r1
    1324:	20333037 	eorscs	r3, r3, r7, lsr r0
    1328:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    132c:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    1330:	675b2029 	ldrbvs	r2, [fp, -r9, lsr #32]
    1334:	382d6363 	stmdacc	sp!, {r0, r1, r5, r6, r8, r9, sp, lr}
    1338:	6172622d 	cmnvs	r2, sp, lsr #4
    133c:	2068636e 	rsbcs	r6, r8, lr, ror #6
    1340:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1344:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
    1348:	33373220 	teqcc	r7, #32, 4
    134c:	5d373230 	lfmpl	f3, 4, [r7, #-192]!	; 0xffffff40
    1350:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1354:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1358:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    135c:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    1360:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    1364:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
    1368:	20706676 	rsbscs	r6, r0, r6, ror r6
    136c:	75746d2d 	ldrbvc	r6, [r4, #-3373]!	; 0xfffff2d3
    1370:	613d656e 	teqvs	sp, lr, ror #10
    1374:	31316d72 	teqcc	r1, r2, ror sp
    1378:	7a6a3637 	bvc	1a8ec5c <__bss_end+0x1a85d48>
    137c:	20732d66 	rsbscs	r2, r3, r6, ror #26
    1380:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1384:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1388:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    138c:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1390:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1394:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
    1398:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    139c:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
    13a0:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
    13a4:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    13a8:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
    13ac:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
    13b0:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    13b4:	616d2d20 	cmnvs	sp, r0, lsr #26
    13b8:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    13bc:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    13c0:	2b6b7a36 	blcs	1adfca0 <__bss_end+0x1ad6d8c>
    13c4:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    13c8:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    13cc:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    13d0:	20304f2d 	eorscs	r4, r0, sp, lsr #30
    13d4:	20304f2d 	eorscs	r4, r0, sp, lsr #30
    13d8:	6f6e662d 	svcvs	0x006e662d
    13dc:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
    13e0:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
    13e4:	20736e6f 	rsbscs	r6, r3, pc, ror #28
    13e8:	6f6e662d 	svcvs	0x006e662d
    13ec:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
    13f0:	65720069 	ldrbvs	r0, [r2, #-105]!	; 0xffffff97
    13f4:	6c617674 	stclvs	6, cr7, [r1], #-464	; 0xfffffe30
    13f8:	75636e00 	strbvc	r6, [r3, #-3584]!	; 0xfffff200
    13fc:	64720072 	ldrbtvs	r0, [r2], #-114	; 0xffffff8e
    1400:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1404:	31315a5f 	teqcc	r1, pc, asr sl
    1408:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    140c:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    1410:	76646c65 	strbtvc	r6, [r4], -r5, ror #24
    1414:	315a5f00 	cmpcc	sl, r0, lsl #30
    1418:	74657337 	strbtvc	r7, [r5], #-823	; 0xfffffcc9
    141c:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    1420:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
    1424:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    1428:	006a656e 	rsbeq	r6, sl, lr, ror #10
    142c:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
    1430:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1434:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1438:	6a6a7966 	bvs	1a9f9d8 <__bss_end+0x1a96ac4>
    143c:	395a5f00 	ldmdbcc	sl, {r8, r9, sl, fp, ip, lr}^
    1440:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
    1444:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
    1448:	2f006965 	svccs	0x00006965
    144c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1450:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
    1454:	2f6b6974 	svccs	0x006b6974
    1458:	2f766564 	svccs	0x00766564
    145c:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
    1460:	534f5452 	movtpl	r5, #62546	; 0xf452
    1464:	73616d2d 	cmnvc	r1, #2880	; 0xb40
    1468:	2f726574 	svccs	0x00726574
    146c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    1470:	2f736563 	svccs	0x00736563
    1474:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    1478:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    147c:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    1480:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
    1484:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
    1488:	46007070 			; <UNDEFINED> instruction: 0x46007070
    148c:	006c6961 	rsbeq	r6, ip, r1, ror #18
    1490:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
    1494:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
    1498:	325a5f00 	subscc	r5, sl, #0, 30
    149c:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
    14a0:	7463615f 	strbtvc	r6, [r3], #-351	; 0xfffffea1
    14a4:	5f657669 	svcpl	0x00657669
    14a8:	636f7270 	cmnvs	pc, #112, 4
    14ac:	5f737365 	svcpl	0x00737365
    14b0:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    14b4:	73007674 	movwvc	r7, #1652	; 0x674
    14b8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    14bc:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
    14c0:	7400646c 	strvc	r6, [r0], #-1132	; 0xfffffb94
    14c4:	5f6b6369 	svcpl	0x006b6369
    14c8:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    14cc:	65725f74 	ldrbvs	r5, [r2, #-3956]!	; 0xfffff08c
    14d0:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    14d4:	50006465 	andpl	r6, r0, r5, ror #8
    14d8:	5f657069 	svcpl	0x00657069
    14dc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    14e0:	6572505f 	ldrbvs	r5, [r2, #-95]!	; 0xffffffa1
    14e4:	00786966 	rsbseq	r6, r8, r6, ror #18
    14e8:	34315a5f 	ldrtcc	r5, [r1], #-2655	; 0xfffff5a1
    14ec:	5f746567 	svcpl	0x00746567
    14f0:	6b636974 	blvs	18dbac8 <__bss_end+0x18d2bb4>
    14f4:	756f635f 	strbvc	r6, [pc, #-863]!	; 119d <shift+0x119d>
    14f8:	0076746e 	rsbseq	r7, r6, lr, ror #8
    14fc:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
    1500:	682f0070 	stmdavs	pc!, {r4, r5, r6}	; <UNPREDICTABLE>
    1504:	2f656d6f 	svccs	0x00656d6f
    1508:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
    150c:	642f6b69 	strtvs	r6, [pc], #-2921	; 1514 <shift+0x1514>
    1510:	4b2f7665 	blmi	bdeeac <__bss_end+0xbd5f98>
    1514:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
    1518:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
    151c:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
    1520:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
    1524:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1528:	622f7365 	eorvs	r7, pc, #-1811939327	; 0x94000001
    152c:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1530:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
    1534:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    1538:	5f006e6f 	svcpl	0x00006e6f
    153c:	6c63355a 	cfstr64vs	mvdx3, [r3], #-360	; 0xfffffe98
    1540:	6a65736f 	bvs	195e304 <__bss_end+0x19553f0>
    1544:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1548:	70746567 	rsbsvc	r6, r4, r7, ror #10
    154c:	00766469 	rsbseq	r6, r6, r9, ror #8
    1550:	6d616e66 	stclvs	14, cr6, [r1, #-408]!	; 0xfffffe68
    1554:	6f6e0065 	svcvs	0x006e0065
    1558:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
    155c:	63697400 	cmnvs	r9, #0, 8
    1560:	6f00736b 	svcvs	0x0000736b
    1564:	006e6570 	rsbeq	r6, lr, r0, ror r5
    1568:	70345a5f 	eorsvc	r5, r4, pc, asr sl
    156c:	50657069 	rsbpl	r7, r5, r9, rrx
    1570:	006a634b 	rsbeq	r6, sl, fp, asr #6
    1574:	6165444e 	cmnvs	r5, lr, asr #8
    1578:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    157c:	75535f65 	ldrbvc	r5, [r3, #-3941]	; 0xfffff09b
    1580:	72657362 	rsbvc	r7, r5, #-2013265919	; 0x88000001
    1584:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
    1588:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    158c:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    1590:	6f635f6b 	svcvs	0x00635f6b
    1594:	00746e75 	rsbseq	r6, r4, r5, ror lr
    1598:	61726170 	cmnvs	r2, r0, ror r1
    159c:	5a5f006d 	bpl	17c1758 <__bss_end+0x17b8844>
    15a0:	69727735 	ldmdbvs	r2!, {r0, r2, r4, r5, r8, r9, sl, ip, sp, lr}^
    15a4:	506a6574 	rsbpl	r6, sl, r4, ror r5
    15a8:	006a634b 	rsbeq	r6, sl, fp, asr #6
    15ac:	5f746567 	svcpl	0x00746567
    15b0:	6b736174 	blvs	1cd9b88 <__bss_end+0x1cd0c74>
    15b4:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    15b8:	745f736b 	ldrbvc	r7, [pc], #-875	; 15c0 <shift+0x15c0>
    15bc:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
    15c0:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    15c4:	6200656e 	andvs	r6, r0, #461373440	; 0x1b800000
    15c8:	735f6675 	cmpvc	pc, #122683392	; 0x7500000
    15cc:	00657a69 	rsbeq	r7, r5, r9, ror #20
    15d0:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
    15d4:	65730065 	ldrbvs	r0, [r3, #-101]!	; 0xffffff9b
    15d8:	61745f74 	cmnvs	r4, r4, ror pc
    15dc:	645f6b73 	ldrbvs	r6, [pc], #-2931	; 15e4 <shift+0x15e4>
    15e0:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    15e4:	00656e69 	rsbeq	r6, r5, r9, ror #28
    15e8:	73355a5f 	teqvc	r5, #389120	; 0x5f000
    15ec:	7065656c 	rsbvc	r6, r5, ip, ror #10
    15f0:	47006a6a 	strmi	r6, [r0, -sl, ror #20]
    15f4:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
    15f8:	69616d65 	stmdbvs	r1!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}^
    15fc:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
    1600:	325a5f00 	subscc	r5, sl, #0, 30
    1604:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
    1608:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    160c:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    1610:	5f736b63 	svcpl	0x00736b63
    1614:	645f6f74 	ldrbvs	r6, [pc], #-3956	; 161c <shift+0x161c>
    1618:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    161c:	76656e69 	strbtvc	r6, [r5], -r9, ror #28
    1620:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
    1624:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
    1628:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
    162c:	646f435f 	strbtvs	r4, [pc], #-863	; 1634 <shift+0x1634>
    1630:	72770065 	rsbsvc	r0, r7, #101	; 0x65
    1634:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1638:	77345a5f 			; <UNDEFINED> instruction: 0x77345a5f
    163c:	6a746961 	bvs	1d1bbc8 <__bss_end+0x1d12cb4>
    1640:	5f006a6a 	svcpl	0x00006a6a
    1644:	6f69355a 	svcvs	0x0069355a
    1648:	6a6c7463 	bvs	1b1e7dc <__bss_end+0x1b158c8>
    164c:	494e3631 	stmdbmi	lr, {r0, r4, r5, r9, sl, ip, sp}^
    1650:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
    1654:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    1658:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    165c:	76506e6f 	ldrbvc	r6, [r0], -pc, ror #28
    1660:	636f6900 	cmnvs	pc, #0, 18
    1664:	72006c74 	andvc	r6, r0, #116, 24	; 0x7400
    1668:	6e637465 	cdpvs	4, 6, cr7, cr3, cr5, {3}
    166c:	65740074 	ldrbvs	r0, [r4, #-116]!	; 0xffffff8c
    1670:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
    1674:	00657461 	rsbeq	r7, r5, r1, ror #8
    1678:	65646f6d 	strbvs	r6, [r4, #-3949]!	; 0xfffff093
    167c:	66756200 	ldrbtvs	r6, [r5], -r0, lsl #4
    1680:	00726566 	rsbseq	r6, r2, r6, ror #10
    1684:	72345a5f 	eorsvc	r5, r4, #389120	; 0x5f000
    1688:	6a646165 	bvs	1919c24 <__bss_end+0x1910d10>
    168c:	006a6350 	rsbeq	r6, sl, r0, asr r3
    1690:	63746572 	cmnvs	r4, #478150656	; 0x1c800000
    1694:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1698:	5f746567 	svcpl	0x00746567
    169c:	69746361 	ldmdbvs	r4!, {r0, r5, r6, r8, r9, sp, lr}^
    16a0:	705f6576 	subsvc	r6, pc, r6, ror r5	; <UNPREDICTABLE>
    16a4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    16a8:	635f7373 	cmpvs	pc, #-872415231	; 0xcc000001
    16ac:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    16b0:	6c696600 	stclvs	6, cr6, [r9], #-0
    16b4:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
    16b8:	65720065 	ldrbvs	r0, [r2, #-101]!	; 0xffffff9b
    16bc:	67006461 	strvs	r6, [r0, -r1, ror #8]
    16c0:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
    16c4:	5a5f0064 	bpl	17c185c <__bss_end+0x17b8948>
    16c8:	65706f34 	ldrbvs	r6, [r0, #-3892]!	; 0xfffff0cc
    16cc:	634b506e 	movtvs	r5, #45166	; 0xb06e
    16d0:	464e3531 			; <UNDEFINED> instruction: 0x464e3531
    16d4:	5f656c69 	svcpl	0x00656c69
    16d8:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
    16dc:	646f4d5f 	strbtvs	r4, [pc], #-3423	; 16e4 <shift+0x16e4>
    16e0:	6e690065 	cdpvs	0, 6, cr0, cr9, cr5, {3}
    16e4:	00747570 	rsbseq	r7, r4, r0, ror r5
    16e8:	74736564 	ldrbtvc	r6, [r3], #-1380	; 0xfffffa9c
    16ec:	657a6200 	ldrbvs	r6, [sl, #-512]!	; 0xfffffe00
    16f0:	6c006f72 	stcvs	15, cr6, [r0], {114}	; 0x72
    16f4:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
    16f8:	5a5f0068 	bpl	17c18a0 <__bss_end+0x17b898c>
    16fc:	657a6235 	ldrbvs	r6, [sl, #-565]!	; 0xfffffdcb
    1700:	76506f72 	usub16vc	r6, r0, r2
    1704:	682f0069 	stmdavs	pc!, {r0, r3, r5, r6}	; <UNPREDICTABLE>
    1708:	2f656d6f 	svccs	0x00656d6f
    170c:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
    1710:	642f6b69 	strtvs	r6, [pc], #-2921	; 1718 <shift+0x1718>
    1714:	4b2f7665 	blmi	bdf0b0 <__bss_end+0xbd619c>
    1718:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
    171c:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
    1720:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
    1724:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
    1728:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    172c:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    1730:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    1734:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    1738:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    173c:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
    1740:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
    1744:	00707063 	rsbseq	r7, r0, r3, rrx
    1748:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    174c:	766e6f43 	strbtvc	r6, [lr], -r3, asr #30
    1750:	00727241 	rsbseq	r7, r2, r1, asr #4
    1754:	646d656d 	strbtvs	r6, [sp], #-1389	; 0xfffffa93
    1758:	6f007473 	svcvs	0x00007473
    175c:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
    1760:	5a5f0074 	bpl	17c1938 <__bss_end+0x17b8a24>
    1764:	6d656d36 	stclvs	13, cr6, [r5, #-216]!	; 0xffffff28
    1768:	50797063 	rsbspl	r7, r9, r3, rrx
    176c:	7650764b 	ldrbvc	r7, [r0], -fp, asr #12
    1770:	61620069 	cmnvs	r2, r9, rrx
    1774:	6d006573 	cfstr32vs	mvfx6, [r0, #-460]	; 0xfffffe34
    1778:	70636d65 	rsbvc	r6, r3, r5, ror #26
    177c:	74730079 	ldrbtvc	r0, [r3], #-121	; 0xffffff87
    1780:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
    1784:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
    1788:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    178c:	50706d63 	rsbspl	r6, r0, r3, ror #26
    1790:	3053634b 	subscc	r6, r3, fp, asr #6
    1794:	5f00695f 	svcpl	0x0000695f
    1798:	7473365a 	ldrbtvc	r3, [r3], #-1626	; 0xfffff9a6
    179c:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
    17a0:	00634b50 	rsbeq	r4, r3, r0, asr fp
    17a4:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    17a8:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    17ac:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    17b0:	00634b50 	rsbeq	r4, r3, r0, asr fp
    17b4:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    17b8:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    17bc:	63507970 	cmpvs	r0, #112, 18	; 0x1c0000
    17c0:	69634b50 	stmdbvs	r3!, {r4, r6, r8, r9, fp, lr}^
    17c4:	72747300 	rsbsvc	r7, r4, #0, 6
    17c8:	706d636e 	rsbvc	r6, sp, lr, ror #6
    17cc:	72747300 	rsbsvc	r7, r4, #0, 6
    17d0:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    17d4:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    17d8:	0079726f 	rsbseq	r7, r9, pc, ror #4
    17dc:	736d656d 	cmnvc	sp, #457179136	; 0x1b400000
    17e0:	69006372 	stmdbvs	r0, {r1, r4, r5, r6, r8, r9, sp, lr}
    17e4:	00616f74 	rsbeq	r6, r1, r4, ror pc
    17e8:	69345a5f 	ldmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    17ec:	6a616f74 	bvs	185d5c4 <__bss_end+0x18546b0>
    17f0:	006a6350 	rsbeq	r6, sl, r0, asr r3
    17f4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    17f8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    17fc:	2f2e2e2f 	svccs	0x002e2e2f
    1800:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1804:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1808:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    180c:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1810:	2f676966 	svccs	0x00676966
    1814:	2f6d7261 	svccs	0x006d7261
    1818:	3162696c 	cmncc	r2, ip, ror #18
    181c:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    1820:	00532e73 	subseq	r2, r3, r3, ror lr
    1824:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    1828:	672f646c 	strvs	r6, [pc, -ip, ror #8]!
    182c:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    1830:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1834:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1838:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    183c:	62537a2d 	subsvs	r7, r3, #184320	; 0x2d000
    1840:	2f6e6656 	svccs	0x006e6656
    1844:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    1848:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    184c:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1850:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1854:	2d382d69 	ldccs	13, cr2, [r8, #-420]!	; 0xfffffe5c
    1858:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    185c:	2f33712d 	svccs	0x0033712d
    1860:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1864:	72612f64 	rsbvc	r2, r1, #100, 30	; 0x190
    1868:	6f6e2d6d 	svcvs	0x006e2d6d
    186c:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1870:	2f696261 	svccs	0x00696261
    1874:	2f6d7261 	svccs	0x006d7261
    1878:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    187c:	7261682f 	rsbvc	r6, r1, #3080192	; 0x2f0000
    1880:	696c2f64 	stmdbvs	ip!, {r2, r5, r6, r8, r9, sl, fp, sp}^
    1884:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1888:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    188c:	20534120 	subscs	r4, r3, r0, lsr #2
    1890:	34332e32 	ldrtcc	r2, [r3], #-3634	; 0xfffff1ce
    1894:	52415400 	subpl	r5, r1, #0, 8
    1898:	5f544547 	svcpl	0x00544547
    189c:	5f555043 	svcpl	0x00555043
    18a0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    18a4:	31617865 	cmncc	r1, r5, ror #16
    18a8:	726f6337 	rsbvc	r6, pc, #-603979776	; 0xdc000000
    18ac:	61786574 	cmnvs	r8, r4, ror r5
    18b0:	73690037 	cmnvc	r9, #55	; 0x37
    18b4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    18b8:	70665f74 	rsbvc	r5, r6, r4, ror pc
    18bc:	6c62645f 	cfstrdvs	mvd6, [r2], #-380	; 0xfffffe84
    18c0:	52415400 	subpl	r5, r1, #0, 8
    18c4:	5f544547 	svcpl	0x00544547
    18c8:	5f555043 	svcpl	0x00555043
    18cc:	316d7261 	cmncc	sp, r1, ror #4
    18d0:	6a363331 	bvs	d8e59c <__bss_end+0xd85688>
    18d4:	72610073 	rsbvc	r0, r1, #115	; 0x73
    18d8:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    18dc:	695f6863 	ldmdbvs	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    18e0:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    18e4:	41540074 	cmpmi	r4, r4, ror r0
    18e8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    18ec:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    18f0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    18f4:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    18f8:	41003332 	tstmi	r0, r2, lsr r3
    18fc:	455f4d52 	ldrbmi	r4, [pc, #-3410]	; bb2 <shift+0xbb2>
    1900:	41540051 	cmpmi	r4, r1, asr r0
    1904:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1908:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    190c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1910:	36353131 			; <UNDEFINED> instruction: 0x36353131
    1914:	73663274 	cmnvc	r6, #116, 4	; 0x40000007
    1918:	61736900 	cmnvs	r3, r0, lsl #18
    191c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1920:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    1924:	5400626d 	strpl	r6, [r0], #-621	; 0xfffffd93
    1928:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    192c:	50435f54 	subpl	r5, r3, r4, asr pc
    1930:	6f635f55 	svcvs	0x00635f55
    1934:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1938:	63373561 	teqvs	r7, #406847488	; 0x18400000
    193c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1940:	33356178 	teqcc	r5, #120, 2
    1944:	53414200 	movtpl	r4, #4608	; 0x1200
    1948:	52415f45 	subpl	r5, r1, #276	; 0x114
    194c:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    1950:	41425f4d 	cmpmi	r2, sp, asr #30
    1954:	54004553 	strpl	r4, [r0], #-1363	; 0xfffffaad
    1958:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    195c:	50435f54 	subpl	r5, r3, r4, asr pc
    1960:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1964:	3031386d 	eorscc	r3, r1, sp, ror #16
    1968:	52415400 	subpl	r5, r1, #0, 8
    196c:	5f544547 	svcpl	0x00544547
    1970:	5f555043 	svcpl	0x00555043
    1974:	6e656778 	mcrvs	7, 3, r6, cr5, cr8, {3}
    1978:	41003165 	tstmi	r0, r5, ror #2
    197c:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1980:	415f5343 	cmpmi	pc, r3, asr #6
    1984:	53435041 	movtpl	r5, #12353	; 0x3041
    1988:	4d57495f 	vldrmi.16	s9, [r7, #-190]	; 0xffffff42	; <UNPREDICTABLE>
    198c:	0054584d 	subseq	r5, r4, sp, asr #16
    1990:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1994:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1998:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    199c:	64376d72 	ldrtvs	r6, [r7], #-3442	; 0xfffff28e
    19a0:	41420069 	cmpmi	r2, r9, rrx
    19a4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    19a8:	5f484352 	svcpl	0x00484352
    19ac:	41420032 	cmpmi	r2, r2, lsr r0
    19b0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    19b4:	5f484352 	svcpl	0x00484352
    19b8:	41540033 	cmpmi	r4, r3, lsr r0
    19bc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    19c0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    19c4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    19c8:	006d6437 	rsbeq	r6, sp, r7, lsr r4
    19cc:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    19d0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    19d4:	00355f48 	eorseq	r5, r5, r8, asr #30
    19d8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    19dc:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    19e0:	00365f48 	eorseq	r5, r6, r8, asr #30
    19e4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    19e8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    19ec:	00375f48 	eorseq	r5, r7, r8, asr #30
    19f0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    19f4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    19f8:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    19fc:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    1a00:	41540065 	cmpmi	r4, r5, rrx
    1a04:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a08:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a0c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1a10:	65363439 	ldrvs	r3, [r6, #-1081]!	; 0xfffffbc7
    1a14:	41540073 	cmpmi	r4, r3, ror r0
    1a18:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a1c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a20:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1a24:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1a28:	54003333 	strpl	r3, [r0], #-819	; 0xfffffccd
    1a2c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a30:	50435f54 	subpl	r5, r3, r4, asr pc
    1a34:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1a38:	6474376d 	ldrbtvs	r3, [r4], #-1901	; 0xfffff893
    1a3c:	6900696d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, fp, sp, lr}
    1a40:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    1a44:	7469626f 	strbtvc	r6, [r9], #-623	; 0xfffffd91
    1a48:	52415400 	subpl	r5, r1, #0, 8
    1a4c:	5f544547 	svcpl	0x00544547
    1a50:	5f555043 	svcpl	0x00555043
    1a54:	316d7261 	cmncc	sp, r1, ror #4
    1a58:	6a363731 	bvs	d8f724 <__bss_end+0xd86810>
    1a5c:	0073667a 	rsbseq	r6, r3, sl, ror r6
    1a60:	5f617369 	svcpl	0x00617369
    1a64:	5f746962 	svcpl	0x00746962
    1a68:	76706676 			; <UNDEFINED> instruction: 0x76706676
    1a6c:	52410032 	subpl	r0, r1, #50	; 0x32
    1a70:	43505f4d 	cmpmi	r0, #308	; 0x134
    1a74:	4e555f53 	mrcmi	15, 2, r5, cr5, cr3, {2}
    1a78:	574f4e4b 	strbpl	r4, [pc, -fp, asr #28]
    1a7c:	4154004e 	cmpmi	r4, lr, asr #32
    1a80:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a84:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a88:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1a8c:	42006539 	andmi	r6, r0, #239075328	; 0xe400000
    1a90:	5f455341 	svcpl	0x00455341
    1a94:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1a98:	4554355f 	ldrbmi	r3, [r4, #-1375]	; 0xfffffaa1
    1a9c:	7261004a 	rsbvc	r0, r1, #74	; 0x4a
    1aa0:	63635f6d 	cmnvs	r3, #436	; 0x1b4
    1aa4:	5f6d7366 	svcpl	0x006d7366
    1aa8:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
    1aac:	6e750065 	cdpvs	0, 7, cr0, cr5, cr5, {3}
    1ab0:	63657073 	cmnvs	r5, #115	; 0x73
    1ab4:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    1ab8:	73676e69 	cmnvc	r7, #1680	; 0x690
    1abc:	61736900 	cmnvs	r3, r0, lsl #18
    1ac0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1ac4:	6365735f 	cmnvs	r5, #2080374785	; 0x7c000001
    1ac8:	635f5f00 	cmpvs	pc, #0, 30
    1acc:	745f7a6c 	ldrbvc	r7, [pc], #-2668	; 1ad4 <shift+0x1ad4>
    1ad0:	41006261 	tstmi	r0, r1, ror #4
    1ad4:	565f4d52 			; <UNDEFINED> instruction: 0x565f4d52
    1ad8:	72610043 	rsbvc	r0, r1, #67	; 0x43
    1adc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1ae0:	785f6863 	ldmdavc	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    1ae4:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    1ae8:	52410065 	subpl	r0, r1, #101	; 0x65
    1aec:	454c5f4d 	strbmi	r5, [ip, #-3917]	; 0xfffff0b3
    1af0:	4d524100 	ldfmie	f4, [r2, #-0]
    1af4:	0053565f 	subseq	r5, r3, pc, asr r6
    1af8:	5f4d5241 	svcpl	0x004d5241
    1afc:	61004547 	tstvs	r0, r7, asr #10
    1b00:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1b08 <shift+0x1b08>
    1b04:	5f656e75 	svcpl	0x00656e75
    1b08:	6f727473 	svcvs	0x00727473
    1b0c:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    1b10:	6f63006d 	svcvs	0x0063006d
    1b14:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1b18:	6c662078 	stclvs	0, cr2, [r6], #-480	; 0xfffffe20
    1b1c:	0074616f 	rsbseq	r6, r4, pc, ror #2
    1b20:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b24:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b28:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1b2c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1b30:	35316178 	ldrcc	r6, [r1, #-376]!	; 0xfffffe88
    1b34:	52415400 	subpl	r5, r1, #0, 8
    1b38:	5f544547 	svcpl	0x00544547
    1b3c:	5f555043 	svcpl	0x00555043
    1b40:	32376166 	eorscc	r6, r7, #-2147483623	; 0x80000019
    1b44:	00657436 	rsbeq	r7, r5, r6, lsr r4
    1b48:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b4c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b50:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1b54:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1b58:	37316178 			; <UNDEFINED> instruction: 0x37316178
    1b5c:	4d524100 	ldfmie	f4, [r2, #-0]
    1b60:	0054475f 	subseq	r4, r4, pc, asr r7
    1b64:	5f4d5241 	svcpl	0x004d5241
    1b68:	2e00544c 	cdpcs	4, 0, cr5, cr0, cr12, {2}
    1b6c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1b70:	2f2e2e2f 	svccs	0x002e2e2f
    1b74:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1b78:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1b7c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1b80:	2f636367 	svccs	0x00636367
    1b84:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1b88:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    1b8c:	41540063 	cmpmi	r4, r3, rrx
    1b90:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b94:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b98:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1b9c:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    1ba0:	54006634 	strpl	r6, [r0], #-1588	; 0xfffff9cc
    1ba4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ba8:	50435f54 	subpl	r5, r3, r4, asr pc
    1bac:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1bb0:	3032396d 	eorscc	r3, r2, sp, ror #18
    1bb4:	53414200 	movtpl	r4, #4608	; 0x1200
    1bb8:	52415f45 	subpl	r5, r1, #276	; 0x114
    1bbc:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    1bc0:	54004d45 	strpl	r4, [r0], #-3397	; 0xfffff2bb
    1bc4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1bc8:	50435f54 	subpl	r5, r3, r4, asr pc
    1bcc:	6f635f55 	svcvs	0x00635f55
    1bd0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1bd4:	00323161 	eorseq	r3, r2, r1, ror #2
    1bd8:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    1bdc:	5f6c6176 	svcpl	0x006c6176
    1be0:	41420074 	hvcmi	8196	; 0x2004
    1be4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1be8:	5f484352 	svcpl	0x00484352
    1bec:	005a4b36 	subseq	r4, sl, r6, lsr fp
    1bf0:	5f617369 	svcpl	0x00617369
    1bf4:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1bf8:	6d726100 	ldfvse	f6, [r2, #-0]
    1bfc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1c00:	72615f68 	rsbvc	r5, r1, #104, 30	; 0x1a0
    1c04:	77685f6d 	strbvc	r5, [r8, -sp, ror #30]!
    1c08:	00766964 	rsbseq	r6, r6, r4, ror #18
    1c0c:	5f6d7261 	svcpl	0x006d7261
    1c10:	5f757066 	svcpl	0x00757066
    1c14:	63736564 	cmnvs	r3, #100, 10	; 0x19000000
    1c18:	61736900 	cmnvs	r3, r0, lsl #18
    1c1c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1c20:	3170665f 	cmncc	r0, pc, asr r6
    1c24:	52410036 	subpl	r0, r1, #54	; 0x36
    1c28:	49485f4d 	stmdbmi	r8, {r0, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
    1c2c:	52415400 	subpl	r5, r1, #0, 8
    1c30:	5f544547 	svcpl	0x00544547
    1c34:	5f555043 	svcpl	0x00555043
    1c38:	326d7261 	rsbcc	r7, sp, #268435462	; 0x10000006
    1c3c:	52415400 	subpl	r5, r1, #0, 8
    1c40:	5f544547 	svcpl	0x00544547
    1c44:	5f555043 	svcpl	0x00555043
    1c48:	336d7261 	cmncc	sp, #268435462	; 0x10000006
    1c4c:	52415400 	subpl	r5, r1, #0, 8
    1c50:	5f544547 	svcpl	0x00544547
    1c54:	5f555043 	svcpl	0x00555043
    1c58:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1c5c:	00303031 	eorseq	r3, r0, r1, lsr r0
    1c60:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c64:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c68:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1c6c:	00366d72 	eorseq	r6, r6, r2, ror sp
    1c70:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c74:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c78:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1c7c:	00376d72 	eorseq	r6, r7, r2, ror sp
    1c80:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c84:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c88:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1c8c:	00386d72 	eorseq	r6, r8, r2, ror sp
    1c90:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c94:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c98:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1c9c:	00396d72 	eorseq	r6, r9, r2, ror sp
    1ca0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ca4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ca8:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1cac:	36323661 	ldrtcc	r3, [r2], -r1, ror #12
    1cb0:	52415400 	subpl	r5, r1, #0, 8
    1cb4:	5f544547 	svcpl	0x00544547
    1cb8:	5f555043 	svcpl	0x00555043
    1cbc:	5f6d7261 	svcpl	0x006d7261
    1cc0:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1cc4:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    1cc8:	6f6c2067 	svcvs	0x006c2067
    1ccc:	7520676e 	strvc	r6, [r0, #-1902]!	; 0xfffff892
    1cd0:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
    1cd4:	2064656e 	rsbcs	r6, r4, lr, ror #10
    1cd8:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1cdc:	5f6d7261 	svcpl	0x006d7261
    1ce0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1ce4:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    1ce8:	41540065 	cmpmi	r4, r5, rrx
    1cec:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cf0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cf4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1cf8:	00303136 	eorseq	r3, r0, r6, lsr r1
    1cfc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d00:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d04:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1d08:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1d0c:	00346d78 	eorseq	r6, r4, r8, ror sp
    1d10:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d14:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d18:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1d1c:	30316d72 	eorscc	r6, r1, r2, ror sp
    1d20:	41540065 	cmpmi	r4, r5, rrx
    1d24:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d28:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d2c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1d30:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1d34:	41540037 	cmpmi	r4, r7, lsr r0
    1d38:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d3c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d40:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1d44:	30303537 	eorscc	r3, r0, r7, lsr r5
    1d48:	54006566 	strpl	r6, [r0], #-1382	; 0xfffffa9a
    1d4c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1d50:	50435f54 	subpl	r5, r3, r4, asr pc
    1d54:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1d58:	3031376d 	eorscc	r3, r1, sp, ror #14
    1d5c:	72610063 	rsbvc	r0, r1, #99	; 0x63
    1d60:	6f635f6d 	svcvs	0x00635f6d
    1d64:	635f646e 	cmpvs	pc, #1845493760	; 0x6e000000
    1d68:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1d6c:	5f4d5241 	svcpl	0x004d5241
    1d70:	5f534350 	svcpl	0x00534350
    1d74:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    1d78:	73690053 	cmnvc	r9, #83	; 0x53
    1d7c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1d80:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1d84:	5f38766d 	svcpl	0x0038766d
    1d88:	41420032 	cmpmi	r2, r2, lsr r0
    1d8c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1d90:	5f484352 	svcpl	0x00484352
    1d94:	54004d33 	strpl	r4, [r0], #-3379	; 0xfffff2cd
    1d98:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1d9c:	50435f54 	subpl	r5, r3, r4, asr pc
    1da0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1da4:	3031376d 	eorscc	r3, r1, sp, ror #14
    1da8:	72610074 	rsbvc	r0, r1, #116	; 0x74
    1dac:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1db0:	695f6863 	ldmdbvs	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    1db4:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1db8:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
    1dbc:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    1dc0:	625f6d75 	subsvs	r6, pc, #7488	; 0x1d40
    1dc4:	00737469 	rsbseq	r7, r3, r9, ror #8
    1dc8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1dcc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1dd0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1dd4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1dd8:	70306d78 	eorsvc	r6, r0, r8, ror sp
    1ddc:	7373756c 	cmnvc	r3, #108, 10	; 0x1b000000
    1de0:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    1de4:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    1de8:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    1dec:	52415400 	subpl	r5, r1, #0, 8
    1df0:	5f544547 	svcpl	0x00544547
    1df4:	5f555043 	svcpl	0x00555043
    1df8:	6e797865 	cdpvs	8, 7, cr7, cr9, cr5, {3}
    1dfc:	316d736f 	cmncc	sp, pc, ror #6
    1e00:	52415400 	subpl	r5, r1, #0, 8
    1e04:	5f544547 	svcpl	0x00544547
    1e08:	5f555043 	svcpl	0x00555043
    1e0c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1e10:	35727865 	ldrbcc	r7, [r2, #-2149]!	; 0xfffff79b
    1e14:	73690032 	cmnvc	r9, #50	; 0x32
    1e18:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1e1c:	64745f74 	ldrbtvs	r5, [r4], #-3956	; 0xfffff08c
    1e20:	70007669 	andvc	r7, r0, r9, ror #12
    1e24:	65666572 	strbvs	r6, [r6, #-1394]!	; 0xfffffa8e
    1e28:	656e5f72 	strbvs	r5, [lr, #-3954]!	; 0xfffff08e
    1e2c:	665f6e6f 	ldrbvs	r6, [pc], -pc, ror #28
    1e30:	365f726f 	ldrbcc	r7, [pc], -pc, ror #4
    1e34:	74696234 	strbtvc	r6, [r9], #-564	; 0xfffffdcc
    1e38:	73690073 	cmnvc	r9, #115	; 0x73
    1e3c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1e40:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1e44:	6d663631 	stclvs	6, cr3, [r6, #-196]!	; 0xffffff3c
    1e48:	4154006c 	cmpmi	r4, ip, rrx
    1e4c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e50:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e54:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1e58:	61786574 	cmnvs	r8, r4, ror r5
    1e5c:	54003233 	strpl	r3, [r0], #-563	; 0xfffffdcd
    1e60:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e64:	50435f54 	subpl	r5, r3, r4, asr pc
    1e68:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1e6c:	3032366d 	eorscc	r3, r2, sp, ror #12
    1e70:	61736900 	cmnvs	r3, r0, lsl #18
    1e74:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1e78:	3170665f 	cmncc	r0, pc, asr r6
    1e7c:	6e6f6336 	mcrvs	3, 3, r6, cr15, cr6, {1}
    1e80:	6e750076 	mrcvs	0, 3, r0, cr5, cr6, {3}
    1e84:	63657073 	cmnvs	r5, #115	; 0x73
    1e88:	74735f76 	ldrbtvc	r5, [r3], #-3958	; 0xfffff08a
    1e8c:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1e90:	41540073 	cmpmi	r4, r3, ror r0
    1e94:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e98:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e9c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1ea0:	36353131 			; <UNDEFINED> instruction: 0x36353131
    1ea4:	00733274 	rsbseq	r3, r3, r4, ror r2
    1ea8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1eac:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1eb0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1eb4:	30316d72 	eorscc	r6, r1, r2, ror sp
    1eb8:	6a653632 	bvs	194f788 <__bss_end+0x1946874>
    1ebc:	72610073 	rsbvc	r0, r1, #115	; 0x73
    1ec0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1ec4:	6d336863 	ldcvs	8, cr6, [r3, #-396]!	; 0xfffffe74
    1ec8:	52415400 	subpl	r5, r1, #0, 8
    1ecc:	5f544547 	svcpl	0x00544547
    1ed0:	5f555043 	svcpl	0x00555043
    1ed4:	30366166 	eorscc	r6, r6, r6, ror #2
    1ed8:	00657436 	rsbeq	r7, r5, r6, lsr r4
    1edc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ee0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ee4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1ee8:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    1eec:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    1ef0:	53414200 	movtpl	r4, #4608	; 0x1200
    1ef4:	52415f45 	subpl	r5, r1, #276	; 0x114
    1ef8:	345f4843 	ldrbcc	r4, [pc], #-2115	; 1f00 <shift+0x1f00>
    1efc:	73690054 	cmnvc	r9, #84	; 0x54
    1f00:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1f04:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    1f08:	6f747079 	svcvs	0x00747079
    1f0c:	6d726100 	ldfvse	f6, [r2, #-0]
    1f10:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    1f14:	6e695f73 	mcrvs	15, 3, r5, cr9, cr3, {3}
    1f18:	7165735f 	cmnvc	r5, pc, asr r3
    1f1c:	636e6575 	cmnvs	lr, #490733568	; 0x1d400000
    1f20:	41420065 	cmpmi	r2, r5, rrx
    1f24:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1f28:	5f484352 	svcpl	0x00484352
    1f2c:	00455435 	subeq	r5, r5, r5, lsr r4
    1f30:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f34:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f38:	655f5550 	ldrbvs	r5, [pc, #-1360]	; 19f0 <shift+0x19f0>
    1f3c:	31333970 	teqcc	r3, r0, ror r9
    1f40:	73690032 	cmnvc	r9, #50	; 0x32
    1f44:	65665f61 	strbvs	r5, [r6, #-3937]!	; 0xfffff09f
    1f48:	72757461 	rsbsvc	r7, r5, #1627389952	; 0x61000000
    1f4c:	73690065 	cmnvc	r9, #101	; 0x65
    1f50:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1f54:	6d735f74 	ldclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    1f58:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    1f5c:	61006c75 	tstvs	r0, r5, ror ip
    1f60:	6c5f6d72 	mrrcvs	13, 7, r6, pc, cr2	; <UNPREDICTABLE>
    1f64:	5f676e61 	svcpl	0x00676e61
    1f68:	7074756f 	rsbsvc	r7, r4, pc, ror #10
    1f6c:	6f5f7475 	svcvs	0x005f7475
    1f70:	63656a62 	cmnvs	r5, #401408	; 0x62000
    1f74:	74615f74 	strbtvc	r5, [r1], #-3956	; 0xfffff08c
    1f78:	62697274 	rsbvs	r7, r9, #116, 4	; 0x40000007
    1f7c:	73657475 	cmnvc	r5, #1962934272	; 0x75000000
    1f80:	6f6f685f 	svcvs	0x006f685f
    1f84:	7369006b 	cmnvc	r9, #107	; 0x6b
    1f88:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1f8c:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1f90:	3233645f 	eorscc	r6, r3, #1593835520	; 0x5f000000
    1f94:	4d524100 	ldfmie	f4, [r2, #-0]
    1f98:	00454e5f 	subeq	r4, r5, pc, asr lr
    1f9c:	5f617369 	svcpl	0x00617369
    1fa0:	5f746962 	svcpl	0x00746962
    1fa4:	00386562 	eorseq	r6, r8, r2, ror #10
    1fa8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1fac:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1fb0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1fb4:	31316d72 	teqcc	r1, r2, ror sp
    1fb8:	7a6a3637 	bvc	1a8f89c <__bss_end+0x1a86988>
    1fbc:	41420073 	hvcmi	8195	; 0x2003
    1fc0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1fc4:	5f484352 	svcpl	0x00484352
    1fc8:	69004535 	stmdbvs	r0, {r0, r2, r4, r5, r8, sl, lr}
    1fcc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1fd0:	615f7469 	cmpvs	pc, r9, ror #8
    1fd4:	00766964 	rsbseq	r6, r6, r4, ror #18
    1fd8:	636f7270 	cmnvs	pc, #112, 4
    1fdc:	6f737365 	svcvs	0x00737365
    1fe0:	79745f72 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1fe4:	61006570 	tstvs	r0, r0, ror r5
    1fe8:	665f6c6c 	ldrbvs	r6, [pc], -ip, ror #24
    1fec:	00737570 	rsbseq	r7, r3, r0, ror r5
    1ff0:	5f6d7261 	svcpl	0x006d7261
    1ff4:	00736370 	rsbseq	r6, r3, r0, ror r3
    1ff8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1ffc:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2000:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    2004:	6d726100 	ldfvse	f6, [r2, #-0]
    2008:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    200c:	00743468 	rsbseq	r3, r4, r8, ror #8
    2010:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2014:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2018:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    201c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2020:	35316178 	ldrcc	r6, [r1, #-376]!	; 0xfffffe88
    2024:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2028:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    202c:	6d726100 	ldfvse	f6, [r2, #-0]
    2030:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    2034:	62775f65 	rsbsvs	r5, r7, #404	; 0x194
    2038:	68006675 	stmdavs	r0, {r0, r2, r4, r5, r6, r9, sl, sp, lr}
    203c:	5f626174 	svcpl	0x00626174
    2040:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    2044:	61736900 	cmnvs	r3, r0, lsl #18
    2048:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    204c:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    2050:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    2054:	6f765f6f 	svcvs	0x00765f6f
    2058:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    205c:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    2060:	41540065 	cmpmi	r4, r5, rrx
    2064:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2068:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    206c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2070:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2074:	41540030 	cmpmi	r4, r0, lsr r0
    2078:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    207c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2080:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2084:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2088:	41540031 	cmpmi	r4, r1, lsr r0
    208c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2090:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2094:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2098:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    209c:	73690033 	cmnvc	r9, #51	; 0x33
    20a0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    20a4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    20a8:	5f38766d 	svcpl	0x0038766d
    20ac:	72610031 	rsbvc	r0, r1, #49	; 0x31
    20b0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    20b4:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    20b8:	00656d61 	rsbeq	r6, r5, r1, ror #26
    20bc:	5f617369 	svcpl	0x00617369
    20c0:	5f746962 	svcpl	0x00746962
    20c4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    20c8:	00335f38 	eorseq	r5, r3, r8, lsr pc
    20cc:	5f617369 	svcpl	0x00617369
    20d0:	5f746962 	svcpl	0x00746962
    20d4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    20d8:	00345f38 	eorseq	r5, r4, r8, lsr pc
    20dc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20e0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20e4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    20e8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    20ec:	33356178 	teqcc	r5, #120, 2
    20f0:	52415400 	subpl	r5, r1, #0, 8
    20f4:	5f544547 	svcpl	0x00544547
    20f8:	5f555043 	svcpl	0x00555043
    20fc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2100:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2104:	41540035 	cmpmi	r4, r5, lsr r0
    2108:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    210c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2110:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2114:	696d6437 	stmdbvs	sp!, {r0, r1, r2, r4, r5, sl, sp, lr}^
    2118:	52415400 	subpl	r5, r1, #0, 8
    211c:	5f544547 	svcpl	0x00544547
    2120:	5f555043 	svcpl	0x00555043
    2124:	6f63706d 	svcvs	0x0063706d
    2128:	69006572 	stmdbvs	r0, {r1, r4, r5, r6, r8, sl, sp, lr}
    212c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2130:	615f7469 	cmpvs	pc, r9, ror #8
    2134:	33766d72 	cmncc	r6, #7296	; 0x1c80
    2138:	7261006d 	rsbvc	r0, r1, #109	; 0x6d
    213c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2140:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    2144:	006d746f 	rsbeq	r7, sp, pc, ror #8
    2148:	5f6d7261 	svcpl	0x006d7261
    214c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2150:	54006535 	strpl	r6, [r0], #-1333	; 0xfffffacb
    2154:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2158:	50435f54 	subpl	r5, r3, r4, asr pc
    215c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2160:	3230316d 	eorscc	r3, r0, #1073741851	; 0x4000001b
    2164:	42006530 	andmi	r6, r0, #48, 10	; 0xc000000
    2168:	5f455341 	svcpl	0x00455341
    216c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2170:	004a365f 	subeq	r3, sl, pc, asr r6
    2174:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2178:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    217c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2180:	36396d72 			; <UNDEFINED> instruction: 0x36396d72
    2184:	00736538 	rsbseq	r6, r3, r8, lsr r5
    2188:	47524154 			; <UNDEFINED> instruction: 0x47524154
    218c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2190:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2194:	34376d72 	ldrtcc	r6, [r7], #-3442	; 0xfffff28e
    2198:	42007430 	andmi	r7, r0, #48, 8	; 0x30000000
    219c:	5f455341 	svcpl	0x00455341
    21a0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    21a4:	004d365f 	subeq	r3, sp, pc, asr r6
    21a8:	5f617369 	svcpl	0x00617369
    21ac:	5f746962 	svcpl	0x00746962
    21b0:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    21b4:	54007478 	strpl	r7, [r0], #-1144	; 0xfffffb88
    21b8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21bc:	50435f54 	subpl	r5, r3, r4, asr pc
    21c0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    21c4:	3030376d 	eorscc	r3, r0, sp, ror #14
    21c8:	52415400 	subpl	r5, r1, #0, 8
    21cc:	5f544547 	svcpl	0x00544547
    21d0:	5f555043 	svcpl	0x00555043
    21d4:	316d7261 	cmncc	sp, r1, ror #4
    21d8:	6a363331 	bvs	d8eea4 <__bss_end+0xd85f90>
    21dc:	41007366 	tstmi	r0, r6, ror #6
    21e0:	4c5f4d52 	mrrcmi	13, 5, r4, pc, cr2	; <UNPREDICTABLE>
    21e4:	41540053 	cmpmi	r4, r3, asr r0
    21e8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    21ec:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    21f0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    21f4:	30323031 	eorscc	r3, r2, r1, lsr r0
    21f8:	41420074 	hvcmi	8196	; 0x2004
    21fc:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2200:	5f484352 	svcpl	0x00484352
    2204:	54005a36 	strpl	r5, [r0], #-2614	; 0xfffff5ca
    2208:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    220c:	50435f54 	subpl	r5, r3, r4, asr pc
    2210:	6f635f55 	svcvs	0x00635f55
    2214:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2218:	63353761 	teqvs	r5, #25427968	; 0x1840000
    221c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2220:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    2224:	4d524100 	ldfmie	f4, [r2, #-0]
    2228:	5343505f 	movtpl	r5, #12383	; 0x305f
    222c:	5041415f 	subpl	r4, r1, pc, asr r1
    2230:	565f5343 	ldrbpl	r5, [pc], -r3, asr #6
    2234:	54005046 	strpl	r5, [r0], #-70	; 0xffffffba
    2238:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    223c:	50435f54 	subpl	r5, r3, r4, asr pc
    2240:	77695f55 			; <UNDEFINED> instruction: 0x77695f55
    2244:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    2248:	73690032 	cmnvc	r9, #50	; 0x32
    224c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2250:	656e5f74 	strbvs	r5, [lr, #-3956]!	; 0xfffff08c
    2254:	61006e6f 	tstvs	r0, pc, ror #28
    2258:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    225c:	615f7570 	cmpvs	pc, r0, ror r5	; <UNPREDICTABLE>
    2260:	00727474 	rsbseq	r7, r2, r4, ror r4
    2264:	5f617369 	svcpl	0x00617369
    2268:	5f746962 	svcpl	0x00746962
    226c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2270:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    2274:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2278:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    227c:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    2280:	36323661 	ldrtcc	r3, [r2], -r1, ror #12
    2284:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    2288:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    228c:	50435f54 	subpl	r5, r3, r4, asr pc
    2290:	616d5f55 	cmnvs	sp, r5, asr pc
    2294:	6c657672 	stclvs	6, cr7, [r5], #-456	; 0xfffffe38
    2298:	6a705f6c 	bvs	1c1a050 <__bss_end+0x1c1113c>
    229c:	74680034 	strbtvc	r0, [r8], #-52	; 0xffffffcc
    22a0:	685f6261 	ldmdavs	pc, {r0, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    22a4:	5f687361 	svcpl	0x00687361
    22a8:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    22ac:	00726574 	rsbseq	r6, r2, r4, ror r5
    22b0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    22b4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    22b8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    22bc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    22c0:	35336178 	ldrcc	r6, [r3, #-376]!	; 0xfffffe88
    22c4:	6d726100 	ldfvse	f6, [r2, #-0]
    22c8:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    22cc:	6f635f65 	svcvs	0x00635f65
    22d0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    22d4:	0039615f 	eorseq	r6, r9, pc, asr r1
    22d8:	5f617369 	svcpl	0x00617369
    22dc:	5f746962 	svcpl	0x00746962
    22e0:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    22e4:	00327478 	eorseq	r7, r2, r8, ror r4
    22e8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    22ec:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    22f0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    22f4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    22f8:	32376178 	eorscc	r6, r7, #120, 2
    22fc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2300:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2304:	73690033 	cmnvc	r9, #51	; 0x33
    2308:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    230c:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    2310:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
    2314:	53414200 	movtpl	r4, #4608	; 0x1200
    2318:	52415f45 	subpl	r5, r1, #276	; 0x114
    231c:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    2320:	73690041 	cmnvc	r9, #65	; 0x41
    2324:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2328:	6f645f74 	svcvs	0x00645f74
    232c:	6f727074 	svcvs	0x00727074
    2330:	41420064 	cmpmi	r2, r4, rrx
    2334:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2338:	5f484352 	svcpl	0x00484352
    233c:	72610030 	rsbvc	r0, r1, #48	; 0x30
    2340:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    2344:	745f3631 	ldrbvc	r3, [pc], #-1585	; 234c <shift+0x234c>
    2348:	5f657079 	svcpl	0x00657079
    234c:	65646f6e 	strbvs	r6, [r4, #-3950]!	; 0xfffff092
    2350:	4d524100 	ldfmie	f4, [r2, #-0]
    2354:	00494d5f 	subeq	r4, r9, pc, asr sp
    2358:	5f6d7261 	svcpl	0x006d7261
    235c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2360:	61006b36 	tstvs	r0, r6, lsr fp
    2364:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2368:	36686372 			; <UNDEFINED> instruction: 0x36686372
    236c:	4142006d 	cmpmi	r2, sp, rrx
    2370:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2374:	5f484352 	svcpl	0x00484352
    2378:	41420034 	cmpmi	r2, r4, lsr r0
    237c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2380:	5f484352 	svcpl	0x00484352
    2384:	5f005237 	svcpl	0x00005237
    2388:	706f705f 	rsbvc	r7, pc, pc, asr r0	; <UNPREDICTABLE>
    238c:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    2390:	61745f74 	cmnvs	r4, r4, ror pc
    2394:	73690062 	cmnvc	r9, #98	; 0x62
    2398:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    239c:	6d635f74 	stclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    23a0:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
    23a4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    23a8:	50435f54 	subpl	r5, r3, r4, asr pc
    23ac:	6f635f55 	svcvs	0x00635f55
    23b0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    23b4:	00333761 	eorseq	r3, r3, r1, ror #14
    23b8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    23bc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    23c0:	675f5550 			; <UNDEFINED> instruction: 0x675f5550
    23c4:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
    23c8:	37766369 	ldrbcc	r6, [r6, -r9, ror #6]!
    23cc:	73690061 	cmnvc	r9, #97	; 0x61
    23d0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    23d4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    23d8:	6535766d 	ldrvs	r7, [r5, #-1645]!	; 0xfffff993
    23dc:	6d726100 	ldfvse	f6, [r2, #-0]
    23e0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    23e4:	6f6e5f68 	svcvs	0x006e5f68
    23e8:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 2274 <shift+0x2274>
    23ec:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    23f0:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    23f4:	53414200 	movtpl	r4, #4608	; 0x1200
    23f8:	52415f45 	subpl	r5, r1, #276	; 0x114
    23fc:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    2400:	41540041 	cmpmi	r4, r1, asr #32
    2404:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2408:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    240c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2410:	32323031 	eorscc	r3, r2, #49	; 0x31
    2414:	41420065 	cmpmi	r2, r5, rrx
    2418:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    241c:	5f484352 	svcpl	0x00484352
    2420:	54005238 	strpl	r5, [r0], #-568	; 0xfffffdc8
    2424:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2428:	50435f54 	subpl	r5, r3, r4, asr pc
    242c:	6f635f55 	svcvs	0x00635f55
    2430:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2434:	63333761 	teqvs	r3, #25427968	; 0x1840000
    2438:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    243c:	35336178 	ldrcc	r6, [r3, #-376]!	; 0xfffffe88
    2440:	4d524100 	ldfmie	f4, [r2, #-0]
    2444:	00564e5f 	subseq	r4, r6, pc, asr lr
    2448:	5f6d7261 	svcpl	0x006d7261
    244c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2450:	72610034 	rsbvc	r0, r1, #52	; 0x34
    2454:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2458:	00356863 	eorseq	r6, r5, r3, ror #16
    245c:	5f6d7261 	svcpl	0x006d7261
    2460:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2464:	72610037 	rsbvc	r0, r1, #55	; 0x37
    2468:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    246c:	00386863 	eorseq	r6, r8, r3, ror #16
    2470:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    2474:	756f6420 	strbvc	r6, [pc, #-1056]!	; 205c <shift+0x205c>
    2478:	00656c62 	rsbeq	r6, r5, r2, ror #24
    247c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2480:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2484:	4b365f48 	blmi	d9a1ac <__bss_end+0xd91298>
    2488:	52415400 	subpl	r5, r1, #0, 8
    248c:	5f544547 	svcpl	0x00544547
    2490:	5f555043 	svcpl	0x00555043
    2494:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    2498:	00743034 	rsbseq	r3, r4, r4, lsr r0
    249c:	5f6d7261 	svcpl	0x006d7261
    24a0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    24a4:	72610036 	rsbvc	r0, r1, #54	; 0x36
    24a8:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    24ac:	785f656e 	ldmdavc	pc, {r1, r2, r3, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    24b0:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    24b4:	41540065 	cmpmi	r4, r5, rrx
    24b8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    24bc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    24c0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    24c4:	30303537 	eorscc	r3, r0, r7, lsr r5
    24c8:	6b616d00 	blvs	185d8d0 <__bss_end+0x18549bc>
    24cc:	5f676e69 	svcpl	0x00676e69
    24d0:	736e6f63 	cmnvc	lr, #396	; 0x18c
    24d4:	61745f74 	cmnvs	r4, r4, ror pc
    24d8:	00656c62 	rsbeq	r6, r5, r2, ror #24
    24dc:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    24e0:	61635f62 	cmnvs	r3, r2, ror #30
    24e4:	765f6c6c 	ldrbvc	r6, [pc], -ip, ror #24
    24e8:	6c5f6169 	ldfvse	f6, [pc], {105}	; 0x69
    24ec:	6c656261 	sfmvs	f6, 2, [r5], #-388	; 0xfffffe7c
    24f0:	61736900 	cmnvs	r3, r0, lsl #18
    24f4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    24f8:	7670665f 			; <UNDEFINED> instruction: 0x7670665f
    24fc:	41540035 	cmpmi	r4, r5, lsr r0
    2500:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2504:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2508:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    250c:	00303137 	eorseq	r3, r0, r7, lsr r1
    2510:	5f617369 	svcpl	0x00617369
    2514:	5f746962 	svcpl	0x00746962
    2518:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    251c:	54006b36 	strpl	r6, [r0], #-2870	; 0xfffff4ca
    2520:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2524:	50435f54 	subpl	r5, r3, r4, asr pc
    2528:	6f635f55 	svcvs	0x00635f55
    252c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2530:	54003761 	strpl	r3, [r0], #-1889	; 0xfffff89f
    2534:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2538:	50435f54 	subpl	r5, r3, r4, asr pc
    253c:	6f635f55 	svcvs	0x00635f55
    2540:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2544:	54003861 	strpl	r3, [r0], #-2145	; 0xfffff79f
    2548:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    254c:	50435f54 	subpl	r5, r3, r4, asr pc
    2550:	6f635f55 	svcvs	0x00635f55
    2554:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2558:	41003961 	tstmi	r0, r1, ror #18
    255c:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    2560:	415f5343 	cmpmi	pc, r3, asr #6
    2564:	00534350 	subseq	r4, r3, r0, asr r3
    2568:	5f4d5241 	svcpl	0x004d5241
    256c:	5f534350 	svcpl	0x00534350
    2570:	43505441 	cmpmi	r0, #1090519040	; 0x41000000
    2574:	41540053 	cmpmi	r4, r3, asr r0
    2578:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    257c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2580:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2584:	00303036 	eorseq	r3, r0, r6, lsr r0
    2588:	47524154 			; <UNDEFINED> instruction: 0x47524154
    258c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2590:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2594:	32376d72 	eorscc	r6, r7, #7296	; 0x1c80
    2598:	54007430 	strpl	r7, [r0], #-1072	; 0xfffffbd0
    259c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    25a0:	50435f54 	subpl	r5, r3, r4, asr pc
    25a4:	6f635f55 	svcvs	0x00635f55
    25a8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    25ac:	00373561 	eorseq	r3, r7, r1, ror #10
    25b0:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    25b4:	2078656c 	rsbscs	r6, r8, ip, ror #10
    25b8:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    25bc:	5400656c 	strpl	r6, [r0], #-1388	; 0xfffffa94
    25c0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    25c4:	50435f54 	subpl	r5, r3, r4, asr pc
    25c8:	6f635f55 	svcvs	0x00635f55
    25cc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    25d0:	63333761 	teqvs	r3, #25427968	; 0x1840000
    25d4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    25d8:	33356178 	teqcc	r5, #120, 2
    25dc:	52415400 	subpl	r5, r1, #0, 8
    25e0:	5f544547 	svcpl	0x00544547
    25e4:	5f555043 	svcpl	0x00555043
    25e8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    25ec:	306d7865 	rsbcc	r7, sp, r5, ror #16
    25f0:	73756c70 	cmnvc	r5, #112, 24	; 0x7000
    25f4:	6d726100 	ldfvse	f6, [r2, #-0]
    25f8:	0063635f 	rsbeq	r6, r3, pc, asr r3
    25fc:	5f617369 	svcpl	0x00617369
    2600:	5f746962 	svcpl	0x00746962
    2604:	65646f6d 	strbvs	r6, [r4, #-3949]!	; 0xfffff093
    2608:	69003632 	stmdbvs	r0, {r1, r4, r5, r9, sl, ip, sp}
    260c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2610:	785f7469 	ldmdavc	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    2614:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    2618:	41540065 	cmpmi	r4, r5, rrx
    261c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2620:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2624:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    2628:	61676e6f 	cmnvs	r7, pc, ror #28
    262c:	31316d72 	teqcc	r1, r2, ror sp
    2630:	54003030 	strpl	r3, [r0], #-48	; 0xffffffd0
    2634:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2638:	50435f54 	subpl	r5, r3, r4, asr pc
    263c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2640:	6474376d 	ldrbtvs	r3, [r4], #-1901	; 0xfffff893
    2644:	0073696d 	rsbseq	r6, r3, sp, ror #18
    2648:	6e6f645f 	mcrvs	4, 3, r6, cr15, cr15, {2}
    264c:	73755f74 	cmnvc	r5, #116, 30	; 0x1d0
    2650:	72745f65 	rsbsvc	r5, r4, #404	; 0x194
    2654:	685f6565 	ldmdavs	pc, {r0, r2, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    2658:	5f657265 	svcpl	0x00657265
    265c:	52415400 	subpl	r5, r1, #0, 8
    2660:	5f544547 	svcpl	0x00544547
    2664:	5f555043 	svcpl	0x00555043
    2668:	316d7261 	cmncc	sp, r1, ror #4
    266c:	6d647430 	cfstrdvs	mvd7, [r4, #-192]!	; 0xffffff40
    2670:	41540069 	cmpmi	r4, r9, rrx
    2674:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2678:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    267c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2680:	61786574 	cmnvs	r8, r4, ror r5
    2684:	61620035 	cmnvs	r2, r5, lsr r0
    2688:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    268c:	69686372 	stmdbvs	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2690:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    2694:	00657275 	rsbeq	r7, r5, r5, ror r2
    2698:	5f6d7261 	svcpl	0x006d7261
    269c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    26a0:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    26a4:	52415400 	subpl	r5, r1, #0, 8
    26a8:	5f544547 	svcpl	0x00544547
    26ac:	5f555043 	svcpl	0x00555043
    26b0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    26b4:	316d7865 	cmncc	sp, r5, ror #16
    26b8:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    26bc:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    26c0:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    26c4:	72610079 	rsbvc	r0, r1, #121	; 0x79
    26c8:	75635f6d 	strbvc	r5, [r3, #-3949]!	; 0xfffff093
    26cc:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
    26d0:	63635f74 	cmnvs	r3, #116, 30	; 0x1d0
    26d4:	6d726100 	ldfvse	f6, [r2, #-0]
    26d8:	7261745f 	rsbvc	r7, r1, #1593835520	; 0x5f000000
    26dc:	5f746567 	svcpl	0x00746567
    26e0:	6e736e69 	cdpvs	14, 7, cr6, cr3, cr9, {3}
    26e4:	61736900 	cmnvs	r3, r0, lsl #18
    26e8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    26ec:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    26f0:	41003233 	tstmi	r0, r3, lsr r2
    26f4:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    26f8:	7369004c 	cmnvc	r9, #76	; 0x4c
    26fc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2700:	66765f74 	uhsub16vs	r5, r6, r4
    2704:	00337670 	eorseq	r7, r3, r0, ror r6
    2708:	5f617369 	svcpl	0x00617369
    270c:	5f746962 	svcpl	0x00746962
    2710:	76706676 			; <UNDEFINED> instruction: 0x76706676
    2714:	41420034 	cmpmi	r2, r4, lsr r0
    2718:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    271c:	5f484352 	svcpl	0x00484352
    2720:	00325436 	eorseq	r5, r2, r6, lsr r4
    2724:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2728:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    272c:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    2730:	49414d5f 	stmdbmi	r1, {r0, r1, r2, r3, r4, r6, r8, sl, fp, lr}^
    2734:	4154004e 	cmpmi	r4, lr, asr #32
    2738:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    273c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2740:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2744:	6d647439 	cfstrdvs	mvd7, [r4, #-228]!	; 0xffffff1c
    2748:	52410069 	subpl	r0, r1, #105	; 0x69
    274c:	4c415f4d 	mcrrmi	15, 4, r5, r1, cr13
    2750:	61736900 	cmnvs	r3, r0, lsl #18
    2754:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2758:	646f6d5f 	strbtvs	r6, [pc], #-3423	; 2760 <shift+0x2760>
    275c:	00323365 	eorseq	r3, r2, r5, ror #6
    2760:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2764:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2768:	4d375f48 	ldcmi	15, cr5, [r7, #-288]!	; 0xfffffee0
    276c:	6d726100 	ldfvse	f6, [r2, #-0]
    2770:	7261745f 	rsbvc	r7, r1, #1593835520	; 0x5f000000
    2774:	5f746567 	svcpl	0x00746567
    2778:	6562616c 	strbvs	r6, [r2, #-364]!	; 0xfffffe94
    277c:	4154006c 	cmpmi	r4, ip, rrx
    2780:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2784:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2788:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    278c:	61676e6f 	cmnvs	r7, pc, ror #28
    2790:	31316d72 	teqcc	r1, r2, ror sp
    2794:	54003031 	strpl	r3, [r0], #-49	; 0xffffffcf
    2798:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    279c:	50435f54 	subpl	r5, r3, r4, asr pc
    27a0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    27a4:	3032376d 	eorscc	r3, r2, sp, ror #14
    27a8:	52415400 	subpl	r5, r1, #0, 8
    27ac:	5f544547 	svcpl	0x00544547
    27b0:	5f555043 	svcpl	0x00555043
    27b4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    27b8:	34727865 	ldrbtcc	r7, [r2], #-2149	; 0xfffff79b
    27bc:	52415400 	subpl	r5, r1, #0, 8
    27c0:	5f544547 	svcpl	0x00544547
    27c4:	5f555043 	svcpl	0x00555043
    27c8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    27cc:	35727865 	ldrbcc	r7, [r2, #-2149]!	; 0xfffff79b
    27d0:	52415400 	subpl	r5, r1, #0, 8
    27d4:	5f544547 	svcpl	0x00544547
    27d8:	5f555043 	svcpl	0x00555043
    27dc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    27e0:	37727865 	ldrbcc	r7, [r2, -r5, ror #16]!
    27e4:	52415400 	subpl	r5, r1, #0, 8
    27e8:	5f544547 	svcpl	0x00544547
    27ec:	5f555043 	svcpl	0x00555043
    27f0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    27f4:	38727865 	ldmdacc	r2!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    27f8:	61736900 	cmnvs	r3, r0, lsl #18
    27fc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2800:	61706c5f 	cmnvs	r0, pc, asr ip
    2804:	41540065 	cmpmi	r4, r5, rrx
    2808:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    280c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2810:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    2814:	61676e6f 	cmnvs	r7, pc, ror #28
    2818:	31316d72 	teqcc	r1, r2, ror sp
    281c:	73690030 	cmnvc	r9, #48	; 0x30
    2820:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2824:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    2828:	5f6b7269 	svcpl	0x006b7269
    282c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2830:	007a6b36 	rsbseq	r6, sl, r6, lsr fp
    2834:	5f617369 	svcpl	0x00617369
    2838:	5f746962 	svcpl	0x00746962
    283c:	6d746f6e 	ldclvs	15, cr6, [r4, #-440]!	; 0xfffffe48
    2840:	61736900 	cmnvs	r3, r0, lsl #18
    2844:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2848:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    284c:	69003476 	stmdbvs	r0, {r1, r2, r4, r5, r6, sl, ip, sp}
    2850:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2854:	615f7469 	cmpvs	pc, r9, ror #8
    2858:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    285c:	61736900 	cmnvs	r3, r0, lsl #18
    2860:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2864:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2868:	69003676 	stmdbvs	r0, {r1, r2, r4, r5, r6, r9, sl, ip, sp}
    286c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2870:	615f7469 	cmpvs	pc, r9, ror #8
    2874:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    2878:	61736900 	cmnvs	r3, r0, lsl #18
    287c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2880:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2884:	5f003876 	svcpl	0x00003876
    2888:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    288c:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    2890:	7874725f 	ldmdavc	r4!, {r0, r1, r2, r3, r4, r6, r9, ip, sp, lr}^
    2894:	7265685f 	rsbvc	r6, r5, #6225920	; 0x5f0000
    2898:	55005f65 	strpl	r5, [r0, #-3941]	; 0xfffff09b
    289c:	79744951 	ldmdbvc	r4!, {r0, r4, r6, r8, fp, lr}^
    28a0:	61006570 	tstvs	r0, r0, ror r5
    28a4:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 28ac <shift+0x28ac>
    28a8:	00656e75 	rsbeq	r6, r5, r5, ror lr
    28ac:	5f6d7261 	svcpl	0x006d7261
    28b0:	5f707063 	svcpl	0x00707063
    28b4:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    28b8:	726f7772 	rsbvc	r7, pc, #29884416	; 0x1c80000
    28bc:	7566006b 	strbvc	r0, [r6, #-107]!	; 0xffffff95
    28c0:	705f636e 	subsvc	r6, pc, lr, ror #6
    28c4:	54007274 	strpl	r7, [r0], #-628	; 0xfffffd8c
    28c8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    28cc:	50435f54 	subpl	r5, r3, r4, asr pc
    28d0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    28d4:	3032396d 	eorscc	r3, r2, sp, ror #18
    28d8:	74680074 	strbtvc	r0, [r8], #-116	; 0xffffff8c
    28dc:	655f6261 	ldrbvs	r6, [pc, #-609]	; 2683 <shift+0x2683>
    28e0:	41540071 	cmpmi	r4, r1, ror r0
    28e4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    28e8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    28ec:	3561665f 	strbcc	r6, [r1, #-1631]!	; 0xfffff9a1
    28f0:	61003632 	tstvs	r0, r2, lsr r6
    28f4:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    28f8:	5f686372 	svcpl	0x00686372
    28fc:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2900:	77685f62 	strbvc	r5, [r8, -r2, ror #30]!
    2904:	00766964 	rsbseq	r6, r6, r4, ror #18
    2908:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    290c:	5f71655f 	svcpl	0x0071655f
    2910:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    2914:	00726574 	rsbseq	r6, r2, r4, ror r5
    2918:	47524154 			; <UNDEFINED> instruction: 0x47524154
    291c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2920:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2924:	30366d72 	eorscc	r6, r6, r2, ror sp
    2928:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    292c:	37314320 	ldrcc	r4, [r1, -r0, lsr #6]!
    2930:	332e3820 			; <UNDEFINED> instruction: 0x332e3820
    2934:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    2938:	30393130 	eorscc	r3, r9, r0, lsr r1
    293c:	20333037 	eorscs	r3, r3, r7, lsr r0
    2940:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    2944:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    2948:	675b2029 	ldrbvs	r2, [fp, -r9, lsr #32]
    294c:	382d6363 	stmdacc	sp!, {r0, r1, r5, r6, r8, r9, sp, lr}
    2950:	6172622d 	cmnvs	r2, sp, lsr #4
    2954:	2068636e 	rsbcs	r6, r8, lr, ror #6
    2958:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    295c:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
    2960:	33373220 	teqcc	r7, #32, 4
    2964:	5d373230 	lfmpl	f3, 4, [r7, #-192]!	; 0xffffff40
    2968:	616d2d20 	cmnvs	sp, r0, lsr #26
    296c:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
    2970:	6f6c666d 	svcvs	0x006c666d
    2974:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    2978:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    297c:	20647261 	rsbcs	r7, r4, r1, ror #4
    2980:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    2984:	613d6863 	teqvs	sp, r3, ror #16
    2988:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    298c:	662b6574 			; <UNDEFINED> instruction: 0x662b6574
    2990:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
    2994:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    2998:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    299c:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    29a0:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    29a4:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    29a8:	69756266 	ldmdbvs	r5!, {r1, r2, r5, r6, r9, sp, lr}^
    29ac:	6e69646c 	cdpvs	4, 6, cr6, cr9, cr12, {3}
    29b0:	696c2d67 	stmdbvs	ip!, {r0, r1, r2, r5, r6, r8, sl, fp, sp}^
    29b4:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    29b8:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    29bc:	74732d6f 	ldrbtvc	r2, [r3], #-3439	; 0xfffff291
    29c0:	2d6b6361 	stclcs	3, cr6, [fp, #-388]!	; 0xfffffe7c
    29c4:	746f7270 	strbtvc	r7, [pc], #-624	; 29cc <shift+0x29cc>
    29c8:	6f746365 	svcvs	0x00746365
    29cc:	662d2072 			; <UNDEFINED> instruction: 0x662d2072
    29d0:	692d6f6e 	pushvs	{r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}
    29d4:	6e696c6e 	cdpvs	12, 6, cr6, cr9, cr14, {3}
    29d8:	662d2065 	strtvs	r2, [sp], -r5, rrx
    29dc:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    29e0:	696c6962 	stmdbvs	ip!, {r1, r5, r6, r8, fp, sp, lr}^
    29e4:	683d7974 	ldmdavs	sp!, {r2, r4, r5, r6, r8, fp, ip, sp, lr}
    29e8:	65646469 	strbvs	r6, [r4, #-1129]!	; 0xfffffb97
    29ec:	7261006e 	rsbvc	r0, r1, #110	; 0x6e
    29f0:	69705f6d 	ldmdbvs	r0!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    29f4:	65725f63 	ldrbvs	r5, [r2, #-3939]!	; 0xfffff09d
    29f8:	74736967 	ldrbtvc	r6, [r3], #-2407	; 0xfffff699
    29fc:	54007265 	strpl	r7, [r0], #-613	; 0xfffffd9b
    2a00:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2a04:	50435f54 	subpl	r5, r3, r4, asr pc
    2a08:	6f635f55 	svcvs	0x00635f55
    2a0c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2a10:	6d73306d 	ldclvs	0, cr3, [r3, #-436]!	; 0xfffffe4c
    2a14:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    2a18:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    2a1c:	00796c70 	rsbseq	r6, r9, r0, ror ip
    2a20:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2a24:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2a28:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2a2c:	36396d72 			; <UNDEFINED> instruction: 0x36396d72
    2a30:	00736536 	rsbseq	r6, r3, r6, lsr r5
    2a34:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2a38:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2a3c:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 2904 <shift+0x2904>
    2a40:	726f6370 	rsbvc	r6, pc, #112, 6	; 0xc0000001
    2a44:	766f6e65 	strbtvc	r6, [pc], -r5, ror #28
    2a48:	69007066 	stmdbvs	r0, {r1, r2, r5, r6, ip, sp, lr}
    2a4c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2a50:	715f7469 	cmpvc	pc, r9, ror #8
    2a54:	6b726975 	blvs	1c9d030 <__bss_end+0x1c9411c>
    2a58:	336d635f 	cmncc	sp, #2080374785	; 0x7c000001
    2a5c:	72646c5f 	rsbvc	r6, r4, #24320	; 0x5f00
    2a60:	41540064 	cmpmi	r4, r4, rrx
    2a64:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2a68:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2a6c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2a70:	69303037 	ldmdbvs	r0!, {r0, r1, r2, r4, r5, ip, sp}
    2a74:	4d524100 	ldfmie	f4, [r2, #-0]
    2a78:	0043435f 	subeq	r4, r3, pc, asr r3
    2a7c:	5f6d7261 	svcpl	0x006d7261
    2a80:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2a84:	00325f38 	eorseq	r5, r2, r8, lsr pc
    2a88:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2a8c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2a90:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    2a94:	3236706d 	eorscc	r7, r6, #109	; 0x6d
    2a98:	52410036 	subpl	r0, r1, #54	; 0x36
    2a9c:	53435f4d 	movtpl	r5, #16205	; 0x3f4d
    2aa0:	6d726100 	ldfvse	f6, [r2, #-0]
    2aa4:	3170665f 	cmncc	r0, pc, asr r6
    2aa8:	6e695f36 	mcrvs	15, 3, r5, cr9, cr6, {1}
    2aac:	61007473 	tstvs	r0, r3, ror r4
    2ab0:	625f6d72 	subsvs	r6, pc, #7296	; 0x1c80
    2ab4:	5f657361 	svcpl	0x00657361
    2ab8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2abc:	52415400 	subpl	r5, r1, #0, 8
    2ac0:	5f544547 	svcpl	0x00544547
    2ac4:	5f555043 	svcpl	0x00555043
    2ac8:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    2acc:	4154006d 	cmpmi	r4, sp, rrx
    2ad0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2ad4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2ad8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2adc:	54003037 	strpl	r3, [r0], #-55	; 0xffffffc9
    2ae0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2ae4:	50435f54 	subpl	r5, r3, r4, asr pc
    2ae8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2aec:	3035326d 	eorscc	r3, r5, sp, ror #4
    2af0:	6d726100 	ldfvse	f6, [r2, #-0]
    2af4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2af8:	6d653768 	stclvs	7, cr3, [r5, #-416]!	; 0xfffffe60
    2afc:	52415400 	subpl	r5, r1, #0, 8
    2b00:	5f544547 	svcpl	0x00544547
    2b04:	5f555043 	svcpl	0x00555043
    2b08:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2b0c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2b10:	72610032 	rsbvc	r0, r1, #50	; 0x32
    2b14:	63705f6d 	cmnvs	r0, #436	; 0x1b4
    2b18:	65645f73 	strbvs	r5, [r4, #-3955]!	; 0xfffff08d
    2b1c:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
    2b20:	52410074 	subpl	r0, r1, #116	; 0x74
    2b24:	43505f4d 	cmpmi	r0, #308	; 0x134
    2b28:	41415f53 	cmpmi	r1, r3, asr pc
    2b2c:	5f534350 	svcpl	0x00534350
    2b30:	41434f4c 	cmpmi	r3, ip, asr #30
    2b34:	4154004c 	cmpmi	r4, ip, asr #32
    2b38:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2b3c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2b40:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2b44:	61786574 	cmnvs	r8, r4, ror r5
    2b48:	54003537 	strpl	r3, [r0], #-1335	; 0xfffffac9
    2b4c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2b50:	50435f54 	subpl	r5, r3, r4, asr pc
    2b54:	74735f55 	ldrbtvc	r5, [r3], #-3925	; 0xfffff0ab
    2b58:	676e6f72 			; <UNDEFINED> instruction: 0x676e6f72
    2b5c:	006d7261 	rsbeq	r7, sp, r1, ror #4
    2b60:	5f6d7261 	svcpl	0x006d7261
    2b64:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2b68:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    2b6c:	0031626d 	eorseq	r6, r1, sp, ror #4
    2b70:	5f6d7261 	svcpl	0x006d7261
    2b74:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2b78:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    2b7c:	0032626d 	eorseq	r6, r2, sp, ror #4
    2b80:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2b84:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2b88:	695f5550 	ldmdbvs	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    2b8c:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    2b90:	41540074 	cmpmi	r4, r4, ror r0
    2b94:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2b98:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2b9c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2ba0:	74323239 	ldrtvc	r3, [r2], #-569	; 0xfffffdc7
    2ba4:	52415400 	subpl	r5, r1, #0, 8
    2ba8:	5f544547 	svcpl	0x00544547
    2bac:	5f555043 	svcpl	0x00555043
    2bb0:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    2bb4:	73690064 	cmnvc	r9, #100	; 0x64
    2bb8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2bbc:	706d5f74 	rsbvc	r5, sp, r4, ror pc
    2bc0:	6d726100 	ldfvse	f6, [r2, #-0]
    2bc4:	5f646c5f 	svcpl	0x00646c5f
    2bc8:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    2bcc:	72610064 	rsbvc	r0, r1, #100	; 0x64
    2bd0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2bd4:	5f386863 	svcpl	0x00386863
    2bd8:	Address 0x0000000000002bd8 is out of bounds.


Disassembly of section .debug_frame:

00000000 <.debug_frame>:
   0:	0000000c 	andeq	r0, r0, ip
   4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
   8:	7c020001 	stcvc	0, cr0, [r2], {1}
   c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  10:	0000001c 	andeq	r0, r0, ip, lsl r0
  14:	00000000 	andeq	r0, r0, r0
  18:	00008008 	andeq	r8, r0, r8
  1c:	00000064 	andeq	r0, r0, r4, rrx
  20:	8b040e42 	blhi	103930 <__bss_end+0xfaa1c>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x34791c>
  28:	420d0d66 	andmi	r0, sp, #6528	; 0x1980
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	0000806c 	andeq	r8, r0, ip, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1faa3c>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9d6c>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080ac 	andeq	r8, r0, ip, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfaa6c>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x34796c>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080e4 	andeq	r8, r0, r4, ror #1
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfaa8c>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x34798c>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008110 	andeq	r8, r0, r0, lsl r1
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfaaac>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x3479ac>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008130 	andeq	r8, r0, r0, lsr r1
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfaacc>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x3479cc>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008148 	andeq	r8, r0, r8, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfaaec>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x3479ec>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008160 	andeq	r8, r0, r0, ror #2
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfab0c>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x347a0c>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008178 	andeq	r8, r0, r8, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfab2c>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x347a2c>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	00008184 	andeq	r8, r0, r4, lsl #3
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1fab44>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081dc 	ldrdeq	r8, [r0], -ip
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1fab64>
 16c:	42018e02 	andmi	r8, r1, #2, 28
 170:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 174:	00080d0c 	andeq	r0, r8, ip, lsl #26
 178:	0000000c 	andeq	r0, r0, ip
 17c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 180:	7c020001 	stcvc	0, cr0, [r2], {1}
 184:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 188:	00000018 	andeq	r0, r0, r8, lsl r0
 18c:	00000178 	andeq	r0, r0, r8, ror r1
 190:	00008234 	andeq	r8, r0, r4, lsr r2
 194:	000000dc 	ldrdeq	r0, [r0], -ip
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1fab94>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	00008310 	andeq	r8, r0, r0, lsl r3
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfabc0>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x347ac0>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	0000833c 	andeq	r8, r0, ip, lsr r3
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfabe0>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x347ae0>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	00008368 	andeq	r8, r0, r8, ror #6
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfac00>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x347b00>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	00008384 	andeq	r8, r0, r4, lsl #7
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfac20>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x347b20>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	000083c8 	andeq	r8, r0, r8, asr #7
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfac40>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x347b40>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	00008418 	andeq	r8, r0, r8, lsl r4
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfac60>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x347b60>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	00008468 	andeq	r8, r0, r8, ror #8
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfac80>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347b80>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	00008494 	muleq	r0, r4, r4
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfaca0>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347ba0>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	000084e4 	andeq	r8, r0, r4, ror #9
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfacc0>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x347bc0>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	00008528 	andeq	r8, r0, r8, lsr #10
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xface0>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x347be0>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	00008578 	andeq	r8, r0, r8, ror r5
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfad00>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x347c00>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	000085cc 	andeq	r8, r0, ip, asr #11
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfad20>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x347c20>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	00008608 	andeq	r8, r0, r8, lsl #12
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfad40>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x347c40>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	00008644 	andeq	r8, r0, r4, asr #12
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfad60>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347c60>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	00008680 	andeq	r8, r0, r0, lsl #13
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfad80>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347c80>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	000086bc 			; <UNDEFINED> instruction: 0x000086bc
 3a0:	000000b4 	strheq	r0, [r0], -r4
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1fada0>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c52 	stmdaeq	sp, {r1, r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	00008770 	andeq	r8, r0, r0, ror r7
 3d0:	00000174 	andeq	r0, r0, r4, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fadd0>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	000088e4 	andeq	r8, r0, r4, ror #17
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfadf0>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x347cf0>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	00008980 	andeq	r8, r0, r0, lsl #19
 410:	000000c0 	andeq	r0, r0, r0, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfae10>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x347d10>
 41c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	00008a40 	andeq	r8, r0, r0, asr #20
 430:	000000ac 	andeq	r0, r0, ip, lsr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfae30>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x347d30>
 43c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008aec 	andeq	r8, r0, ip, ror #21
 450:	00000054 	andeq	r0, r0, r4, asr r0
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfae50>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347d50>
 45c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008b40 	andeq	r8, r0, r0, asr #22
 470:	00000068 	andeq	r0, r0, r8, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfae70>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347d70>
 47c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008ba8 	andeq	r8, r0, r8, lsr #23
 490:	00000080 	andeq	r0, r0, r0, lsl #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfae90>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347d90>
 49c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000000c 	andeq	r0, r0, ip
 4a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4ac:	7c010001 	stcvc	0, cr0, [r1], {1}
 4b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4b4:	0000000c 	andeq	r0, r0, ip
 4b8:	000004a4 	andeq	r0, r0, r4, lsr #9
 4bc:	00008c28 	andeq	r8, r0, r8, lsr #24
 4c0:	000001ec 	andeq	r0, r0, ip, ror #3
