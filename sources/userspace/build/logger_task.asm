
./logger_task:     file format elf32-littlearm


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
    8064:	00008f0c 	andeq	r8, r0, ip, lsl #30
    8068:	00008f1c 	andeq	r8, r0, ip, lsl pc

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
    8088:	eb000086 	bl	82a8 <main>
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
    81d4:	00008f09 	andeq	r8, r0, r9, lsl #30
    81d8:	00008f09 	andeq	r8, r0, r9, lsl #30

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
    822c:	00008f09 	andeq	r8, r0, r9, lsl #30
    8230:	00008f09 	andeq	r8, r0, r9, lsl #30

00008234 <_ZL5fputsjPKc>:
_ZL5fputsjPKc():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp:14
 * 
 * Prijima vsechny udalosti od ostatnich tasku a oznamuje je skrz UART hostiteli
 **/

static void fputs(uint32_t file, const char* string)
{
    8234:	e92d4800 	push	{fp, lr}
    8238:	e28db004 	add	fp, sp, #4
    823c:	e24dd008 	sub	sp, sp, #8
    8240:	e50b0008 	str	r0, [fp, #-8]
    8244:	e50b100c 	str	r1, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp:15
	write(file, string, strlen(string));
    8248:	e51b000c 	ldr	r0, [fp, #-12]
    824c:	eb000234 	bl	8b24 <_Z6strlenPKc>
    8250:	e1a03000 	mov	r3, r0
    8254:	e1a02003 	mov	r2, r3
    8258:	e51b100c 	ldr	r1, [fp, #-12]
    825c:	e51b0008 	ldr	r0, [fp, #-8]
    8260:	eb00007a 	bl	8450 <_Z5writejPKcj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp:16
}
    8264:	e320f000 	nop	{0}
    8268:	e24bd004 	sub	sp, fp, #4
    826c:	e8bd8800 	pop	{fp, pc}

00008270 <_ZL5fgetsjPci>:
_ZL5fgetsjPci():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp:18

static void fgets(uint32_t file, char *buf, int size) {
    8270:	e92d4800 	push	{fp, lr}
    8274:	e28db004 	add	fp, sp, #4
    8278:	e24dd010 	sub	sp, sp, #16
    827c:	e50b0008 	str	r0, [fp, #-8]
    8280:	e50b100c 	str	r1, [fp, #-12]
    8284:	e50b2010 	str	r2, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp:19
    read(file, buf, size);
    8288:	e51b3010 	ldr	r3, [fp, #-16]
    828c:	e1a02003 	mov	r2, r3
    8290:	e51b100c 	ldr	r1, [fp, #-12]
    8294:	e51b0008 	ldr	r0, [fp, #-8]
    8298:	eb000058 	bl	8400 <_Z4readjPcj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp:20
}
    829c:	e320f000 	nop	{0}
    82a0:	e24bd004 	sub	sp, fp, #4
    82a4:	e8bd8800 	pop	{fp, pc}

000082a8 <main>:
main():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp:23

int main(int argc, char** argv)
{
    82a8:	e92d4800 	push	{fp, lr}
    82ac:	e28db004 	add	fp, sp, #4
    82b0:	e24ddf46 	sub	sp, sp, #280	; 0x118
    82b4:	e50b0118 	str	r0, [fp, #-280]	; 0xfffffee8
    82b8:	e50b111c 	str	r1, [fp, #-284]	; 0xfffffee4
/home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp:24
	uint32_t uart_file = open("DEV:uart/0", NFile_Open_Mode::Write_Only);
    82bc:	e3a01001 	mov	r1, #1
    82c0:	e59f0074 	ldr	r0, [pc, #116]	; 833c <main+0x94>
    82c4:	eb00003c 	bl	83bc <_Z4openPKc15NFile_Open_Mode>
    82c8:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp:27

	TUART_IOCtl_Params params;
	params.baud_rate = NUART_Baud_Rate::BR_115200;
    82cc:	e59f306c 	ldr	r3, [pc, #108]	; 8340 <main+0x98>
    82d0:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp:28
	params.char_length = NUART_Char_Length::Char_8;
    82d4:	e3a03001 	mov	r3, #1
    82d8:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp:29
	ioctl(uart_file, NIOCtl_Operation::Set_Params, &params);
    82dc:	e24b3010 	sub	r3, fp, #16
    82e0:	e1a02003 	mov	r2, r3
    82e4:	e3a01001 	mov	r1, #1
    82e8:	e51b0008 	ldr	r0, [fp, #-8]
    82ec:	eb000076 	bl	84cc <_Z5ioctlj16NIOCtl_OperationPv>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp:31

    fputs(uart_file, "UART task starting!\n");
    82f0:	e59f104c 	ldr	r1, [pc, #76]	; 8344 <main+0x9c>
    82f4:	e51b0008 	ldr	r0, [fp, #-8]
    82f8:	ebffffcd 	bl	8234 <_ZL5fputsjPKc>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp:33
    char str[256];
    fgets(uart_file, str, 256);
    82fc:	e24b3e11 	sub	r3, fp, #272	; 0x110
    8300:	e3a02c01 	mov	r2, #256	; 0x100
    8304:	e1a01003 	mov	r1, r3
    8308:	e51b0008 	ldr	r0, [fp, #-8]
    830c:	ebffffd7 	bl	8270 <_ZL5fgetsjPci>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp:35

    fputs(uart_file, "UART task starting!\n");
    8310:	e59f102c 	ldr	r1, [pc, #44]	; 8344 <main+0x9c>
    8314:	e51b0008 	ldr	r0, [fp, #-8]
    8318:	ebffffc5 	bl	8234 <_ZL5fputsjPKc>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp:37

    fputs(uart_file, str);
    831c:	e24b3e11 	sub	r3, fp, #272	; 0x110
    8320:	e1a01003 	mov	r1, r3
    8324:	e51b0008 	ldr	r0, [fp, #-8]
    8328:	ebffffc1 	bl	8234 <_ZL5fputsjPKc>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp:39

    return 0;
    832c:	e3a03000 	mov	r3, #0
/home/hintik/dev/KIV-RTOS-master/sources/userspace/logger_task/main.cpp:40
}
    8330:	e1a00003 	mov	r0, r3
    8334:	e24bd004 	sub	sp, fp, #4
    8338:	e8bd8800 	pop	{fp, pc}
    833c:	00008e9c 	muleq	r0, ip, lr
    8340:	0001c200 	andeq	ip, r1, r0, lsl #4
    8344:	00008ea8 	andeq	r8, r0, r8, lsr #29

00008348 <_Z6getpidv>:
_Z6getpidv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8348:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    834c:	e28db000 	add	fp, sp, #0
    8350:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8354:	ef000000 	svc	0x00000000
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8358:	e1a03000 	mov	r3, r0
    835c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:11

    return pid;
    8360:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:12
}
    8364:	e1a00003 	mov	r0, r3
    8368:	e28bd000 	add	sp, fp, #0
    836c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8370:	e12fff1e 	bx	lr

00008374 <_Z9terminatei>:
_Z9terminatei():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    8374:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8378:	e28db000 	add	fp, sp, #0
    837c:	e24dd00c 	sub	sp, sp, #12
    8380:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    8384:	e51b3008 	ldr	r3, [fp, #-8]
    8388:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    838c:	ef000001 	svc	0x00000001
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:18
}
    8390:	e320f000 	nop	{0}
    8394:	e28bd000 	add	sp, fp, #0
    8398:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    839c:	e12fff1e 	bx	lr

000083a0 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    83a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83a4:	e28db000 	add	fp, sp, #0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    83a8:	ef000002 	svc	0x00000002
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:23
}
    83ac:	e320f000 	nop	{0}
    83b0:	e28bd000 	add	sp, fp, #0
    83b4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83b8:	e12fff1e 	bx	lr

000083bc <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    83bc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83c0:	e28db000 	add	fp, sp, #0
    83c4:	e24dd014 	sub	sp, sp, #20
    83c8:	e50b0010 	str	r0, [fp, #-16]
    83cc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    83d0:	e51b3010 	ldr	r3, [fp, #-16]
    83d4:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    83d8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83dc:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    83e0:	ef000040 	svc	0x00000040
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    83e4:	e1a03000 	mov	r3, r0
    83e8:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:34

    return file;
    83ec:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:35
}
    83f0:	e1a00003 	mov	r0, r3
    83f4:	e28bd000 	add	sp, fp, #0
    83f8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83fc:	e12fff1e 	bx	lr

00008400 <_Z4readjPcj>:
_Z4readjPcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    8400:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8404:	e28db000 	add	fp, sp, #0
    8408:	e24dd01c 	sub	sp, sp, #28
    840c:	e50b0010 	str	r0, [fp, #-16]
    8410:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8414:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8418:	e51b3010 	ldr	r3, [fp, #-16]
    841c:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    8420:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8424:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    8428:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    842c:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    8430:	ef000041 	svc	0x00000041
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    8434:	e1a03000 	mov	r3, r0
    8438:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    843c:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:48
}
    8440:	e1a00003 	mov	r0, r3
    8444:	e28bd000 	add	sp, fp, #0
    8448:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    844c:	e12fff1e 	bx	lr

00008450 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    8450:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8454:	e28db000 	add	fp, sp, #0
    8458:	e24dd01c 	sub	sp, sp, #28
    845c:	e50b0010 	str	r0, [fp, #-16]
    8460:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8464:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8468:	e51b3010 	ldr	r3, [fp, #-16]
    846c:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    8470:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8474:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    8478:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    847c:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    8480:	ef000042 	svc	0x00000042
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    8484:	e1a03000 	mov	r3, r0
    8488:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    848c:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:61
}
    8490:	e1a00003 	mov	r0, r3
    8494:	e28bd000 	add	sp, fp, #0
    8498:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    849c:	e12fff1e 	bx	lr

000084a0 <_Z5closej>:
_Z5closej():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    84a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84a4:	e28db000 	add	fp, sp, #0
    84a8:	e24dd00c 	sub	sp, sp, #12
    84ac:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    84b0:	e51b3008 	ldr	r3, [fp, #-8]
    84b4:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    84b8:	ef000043 	svc	0x00000043
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:67
}
    84bc:	e320f000 	nop	{0}
    84c0:	e28bd000 	add	sp, fp, #0
    84c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84c8:	e12fff1e 	bx	lr

000084cc <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    84cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84d0:	e28db000 	add	fp, sp, #0
    84d4:	e24dd01c 	sub	sp, sp, #28
    84d8:	e50b0010 	str	r0, [fp, #-16]
    84dc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84e0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    84e4:	e51b3010 	ldr	r3, [fp, #-16]
    84e8:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    84ec:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84f0:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    84f4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84f8:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    84fc:	ef000044 	svc	0x00000044
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    8500:	e1a03000 	mov	r3, r0
    8504:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    8508:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:80
}
    850c:	e1a00003 	mov	r0, r3
    8510:	e28bd000 	add	sp, fp, #0
    8514:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8518:	e12fff1e 	bx	lr

0000851c <_Z6notifyjj>:
_Z6notifyjj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    851c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8520:	e28db000 	add	fp, sp, #0
    8524:	e24dd014 	sub	sp, sp, #20
    8528:	e50b0010 	str	r0, [fp, #-16]
    852c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    8530:	e51b3010 	ldr	r3, [fp, #-16]
    8534:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    8538:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    853c:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    8540:	ef000045 	svc	0x00000045
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    8544:	e1a03000 	mov	r3, r0
    8548:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    854c:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:92
}
    8550:	e1a00003 	mov	r0, r3
    8554:	e28bd000 	add	sp, fp, #0
    8558:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    855c:	e12fff1e 	bx	lr

00008560 <_Z4waitjjj>:
_Z4waitjjj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    8560:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8564:	e28db000 	add	fp, sp, #0
    8568:	e24dd01c 	sub	sp, sp, #28
    856c:	e50b0010 	str	r0, [fp, #-16]
    8570:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8574:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8578:	e51b3010 	ldr	r3, [fp, #-16]
    857c:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    8580:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8584:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    8588:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    858c:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    8590:	ef000046 	svc	0x00000046
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    8594:	e1a03000 	mov	r3, r0
    8598:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    859c:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:105
}
    85a0:	e1a00003 	mov	r0, r3
    85a4:	e28bd000 	add	sp, fp, #0
    85a8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85ac:	e12fff1e 	bx	lr

000085b0 <_Z5sleepjj>:
_Z5sleepjj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    85b0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85b4:	e28db000 	add	fp, sp, #0
    85b8:	e24dd014 	sub	sp, sp, #20
    85bc:	e50b0010 	str	r0, [fp, #-16]
    85c0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    85c4:	e51b3010 	ldr	r3, [fp, #-16]
    85c8:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    85cc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85d0:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    85d4:	ef000003 	svc	0x00000003
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    85d8:	e1a03000 	mov	r3, r0
    85dc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    85e0:	e51b3008 	ldr	r3, [fp, #-8]
    85e4:	e3530000 	cmp	r3, #0
    85e8:	13a03001 	movne	r3, #1
    85ec:	03a03000 	moveq	r3, #0
    85f0:	e6ef3073 	uxtb	r3, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:117
}
    85f4:	e1a00003 	mov	r0, r3
    85f8:	e28bd000 	add	sp, fp, #0
    85fc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8600:	e12fff1e 	bx	lr

00008604 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    8604:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8608:	e28db000 	add	fp, sp, #0
    860c:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    8610:	e3a03000 	mov	r3, #0
    8614:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8618:	e3a03000 	mov	r3, #0
    861c:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    8620:	e24b300c 	sub	r3, fp, #12
    8624:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    8628:	ef000004 	svc	0x00000004
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:128

    return retval;
    862c:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:129
}
    8630:	e1a00003 	mov	r0, r3
    8634:	e28bd000 	add	sp, fp, #0
    8638:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    863c:	e12fff1e 	bx	lr

00008640 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    8640:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8644:	e28db000 	add	fp, sp, #0
    8648:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    864c:	e3a03001 	mov	r3, #1
    8650:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8654:	e3a03001 	mov	r3, #1
    8658:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    865c:	e24b300c 	sub	r3, fp, #12
    8660:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    8664:	ef000004 	svc	0x00000004
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:140

    return retval;
    8668:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:141
}
    866c:	e1a00003 	mov	r0, r3
    8670:	e28bd000 	add	sp, fp, #0
    8674:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8678:	e12fff1e 	bx	lr

0000867c <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    867c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8680:	e28db000 	add	fp, sp, #0
    8684:	e24dd014 	sub	sp, sp, #20
    8688:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    868c:	e3a03000 	mov	r3, #0
    8690:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    8694:	e3a03000 	mov	r3, #0
    8698:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    869c:	e24b3010 	sub	r3, fp, #16
    86a0:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    86a4:	ef000005 	svc	0x00000005
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:150
}
    86a8:	e320f000 	nop	{0}
    86ac:	e28bd000 	add	sp, fp, #0
    86b0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86b4:	e12fff1e 	bx	lr

000086b8 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    86b8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86bc:	e28db000 	add	fp, sp, #0
    86c0:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    86c4:	e3a03001 	mov	r3, #1
    86c8:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    86cc:	e3a03001 	mov	r3, #1
    86d0:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    86d4:	e24b300c 	sub	r3, fp, #12
    86d8:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    86dc:	ef000005 	svc	0x00000005
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    86e0:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:162
}
    86e4:	e1a00003 	mov	r0, r3
    86e8:	e28bd000 	add	sp, fp, #0
    86ec:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86f0:	e12fff1e 	bx	lr

000086f4 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    86f4:	e92d4800 	push	{fp, lr}
    86f8:	e28db004 	add	fp, sp, #4
    86fc:	e24dd050 	sub	sp, sp, #80	; 0x50
    8700:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    8704:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    8708:	e24b3048 	sub	r3, fp, #72	; 0x48
    870c:	e3a0200a 	mov	r2, #10
    8710:	e59f108c 	ldr	r1, [pc, #140]	; 87a4 <_Z4pipePKcj+0xb0>
    8714:	e1a00003 	mov	r0, r3
    8718:	eb0000a6 	bl	89b8 <_Z7strncpyPcPKci>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    871c:	e24b3048 	sub	r3, fp, #72	; 0x48
    8720:	e283300a 	add	r3, r3, #10
    8724:	e3a02035 	mov	r2, #53	; 0x35
    8728:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    872c:	e1a00003 	mov	r0, r3
    8730:	eb0000a0 	bl	89b8 <_Z7strncpyPcPKci>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8734:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    8738:	eb0000f9 	bl	8b24 <_Z6strlenPKc>
    873c:	e1a03000 	mov	r3, r0
    8740:	e283300a 	add	r3, r3, #10
    8744:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    8748:	e51b3008 	ldr	r3, [fp, #-8]
    874c:	e2832001 	add	r2, r3, #1
    8750:	e50b2008 	str	r2, [fp, #-8]
    8754:	e24b2004 	sub	r2, fp, #4
    8758:	e0823003 	add	r3, r2, r3
    875c:	e3a02023 	mov	r2, #35	; 0x23
    8760:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    8764:	e24b2048 	sub	r2, fp, #72	; 0x48
    8768:	e51b3008 	ldr	r3, [fp, #-8]
    876c:	e0823003 	add	r3, r2, r3
    8770:	e3a0200a 	mov	r2, #10
    8774:	e1a01003 	mov	r1, r3
    8778:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    877c:	eb000009 	bl	87a8 <_Z4itoajPcj>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    8780:	e24b3048 	sub	r3, fp, #72	; 0x48
    8784:	e3a01002 	mov	r1, #2
    8788:	e1a00003 	mov	r0, r3
    878c:	ebffff0a 	bl	83bc <_Z4openPKc15NFile_Open_Mode>
    8790:	e1a03000 	mov	r3, r0
    8794:	e320f000 	nop	{0}
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:179
}
    8798:	e1a00003 	mov	r0, r3
    879c:	e24bd004 	sub	sp, fp, #4
    87a0:	e8bd8800 	pop	{fp, pc}
    87a4:	00008eec 	andeq	r8, r0, ip, ror #29

000087a8 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    87a8:	e92d4800 	push	{fp, lr}
    87ac:	e28db004 	add	fp, sp, #4
    87b0:	e24dd020 	sub	sp, sp, #32
    87b4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    87b8:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    87bc:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:10
	int i = 0;
    87c0:	e3a03000 	mov	r3, #0
    87c4:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:12

	while (input > 0)
    87c8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    87cc:	e3530000 	cmp	r3, #0
    87d0:	0a000014 	beq	8828 <_Z4itoajPcj+0x80>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    87d4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    87d8:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    87dc:	e1a00003 	mov	r0, r3
    87e0:	eb000199 	bl	8e4c <__aeabi_uidivmod>
    87e4:	e1a03001 	mov	r3, r1
    87e8:	e1a01003 	mov	r1, r3
    87ec:	e51b3008 	ldr	r3, [fp, #-8]
    87f0:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87f4:	e0823003 	add	r3, r2, r3
    87f8:	e59f2118 	ldr	r2, [pc, #280]	; 8918 <_Z4itoajPcj+0x170>
    87fc:	e7d22001 	ldrb	r2, [r2, r1]
    8800:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:15
		input /= base;
    8804:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8808:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    880c:	eb000113 	bl	8c60 <__udivsi3>
    8810:	e1a03000 	mov	r3, r0
    8814:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:16
		i++;
    8818:	e51b3008 	ldr	r3, [fp, #-8]
    881c:	e2833001 	add	r3, r3, #1
    8820:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:12
	while (input > 0)
    8824:	eaffffe7 	b	87c8 <_Z4itoajPcj+0x20>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    8828:	e51b3008 	ldr	r3, [fp, #-8]
    882c:	e3530000 	cmp	r3, #0
    8830:	1a000007 	bne	8854 <_Z4itoajPcj+0xac>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    8834:	e51b3008 	ldr	r3, [fp, #-8]
    8838:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    883c:	e0823003 	add	r3, r2, r3
    8840:	e3a02030 	mov	r2, #48	; 0x30
    8844:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:22
        i++;
    8848:	e51b3008 	ldr	r3, [fp, #-8]
    884c:	e2833001 	add	r3, r3, #1
    8850:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    8854:	e51b3008 	ldr	r3, [fp, #-8]
    8858:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    885c:	e0823003 	add	r3, r2, r3
    8860:	e3a02000 	mov	r2, #0
    8864:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:26
	i--;
    8868:	e51b3008 	ldr	r3, [fp, #-8]
    886c:	e2433001 	sub	r3, r3, #1
    8870:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    8874:	e3a03000 	mov	r3, #0
    8878:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:28 (discriminator 3)
    887c:	e51b3008 	ldr	r3, [fp, #-8]
    8880:	e1a02fa3 	lsr	r2, r3, #31
    8884:	e0823003 	add	r3, r2, r3
    8888:	e1a030c3 	asr	r3, r3, #1
    888c:	e1a02003 	mov	r2, r3
    8890:	e51b300c 	ldr	r3, [fp, #-12]
    8894:	e1530002 	cmp	r3, r2
    8898:	ca00001b 	bgt	890c <_Z4itoajPcj+0x164>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    889c:	e51b2008 	ldr	r2, [fp, #-8]
    88a0:	e51b300c 	ldr	r3, [fp, #-12]
    88a4:	e0423003 	sub	r3, r2, r3
    88a8:	e1a02003 	mov	r2, r3
    88ac:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    88b0:	e0833002 	add	r3, r3, r2
    88b4:	e5d33000 	ldrb	r3, [r3]
    88b8:	e54b300d 	strb	r3, [fp, #-13]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    88bc:	e51b300c 	ldr	r3, [fp, #-12]
    88c0:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88c4:	e0822003 	add	r2, r2, r3
    88c8:	e51b1008 	ldr	r1, [fp, #-8]
    88cc:	e51b300c 	ldr	r3, [fp, #-12]
    88d0:	e0413003 	sub	r3, r1, r3
    88d4:	e1a01003 	mov	r1, r3
    88d8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    88dc:	e0833001 	add	r3, r3, r1
    88e0:	e5d22000 	ldrb	r2, [r2]
    88e4:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    88e8:	e51b300c 	ldr	r3, [fp, #-12]
    88ec:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88f0:	e0823003 	add	r3, r2, r3
    88f4:	e55b200d 	ldrb	r2, [fp, #-13]
    88f8:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    88fc:	e51b300c 	ldr	r3, [fp, #-12]
    8900:	e2833001 	add	r3, r3, #1
    8904:	e50b300c 	str	r3, [fp, #-12]
    8908:	eaffffdb 	b	887c <_Z4itoajPcj+0xd4>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:34
	}
}
    890c:	e320f000 	nop	{0}
    8910:	e24bd004 	sub	sp, fp, #4
    8914:	e8bd8800 	pop	{fp, pc}
    8918:	00008ef8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>

0000891c <_Z4atoiPKc>:
_Z4atoiPKc():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    891c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8920:	e28db000 	add	fp, sp, #0
    8924:	e24dd014 	sub	sp, sp, #20
    8928:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:38
	int output = 0;
    892c:	e3a03000 	mov	r3, #0
    8930:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    8934:	e51b3010 	ldr	r3, [fp, #-16]
    8938:	e5d33000 	ldrb	r3, [r3]
    893c:	e3530000 	cmp	r3, #0
    8940:	0a000017 	beq	89a4 <_Z4atoiPKc+0x88>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    8944:	e51b2008 	ldr	r2, [fp, #-8]
    8948:	e1a03002 	mov	r3, r2
    894c:	e1a03103 	lsl	r3, r3, #2
    8950:	e0833002 	add	r3, r3, r2
    8954:	e1a03083 	lsl	r3, r3, #1
    8958:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    895c:	e51b3010 	ldr	r3, [fp, #-16]
    8960:	e5d33000 	ldrb	r3, [r3]
    8964:	e3530039 	cmp	r3, #57	; 0x39
    8968:	8a00000d 	bhi	89a4 <_Z4atoiPKc+0x88>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:43 (discriminator 1)
    896c:	e51b3010 	ldr	r3, [fp, #-16]
    8970:	e5d33000 	ldrb	r3, [r3]
    8974:	e353002f 	cmp	r3, #47	; 0x2f
    8978:	9a000009 	bls	89a4 <_Z4atoiPKc+0x88>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    897c:	e51b3010 	ldr	r3, [fp, #-16]
    8980:	e5d33000 	ldrb	r3, [r3]
    8984:	e2433030 	sub	r3, r3, #48	; 0x30
    8988:	e51b2008 	ldr	r2, [fp, #-8]
    898c:	e0823003 	add	r3, r2, r3
    8990:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:48

		input++;
    8994:	e51b3010 	ldr	r3, [fp, #-16]
    8998:	e2833001 	add	r3, r3, #1
    899c:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    89a0:	eaffffe3 	b	8934 <_Z4atoiPKc+0x18>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:51
	}

	return output;
    89a4:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:52
}
    89a8:	e1a00003 	mov	r0, r3
    89ac:	e28bd000 	add	sp, fp, #0
    89b0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    89b4:	e12fff1e 	bx	lr

000089b8 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    89b8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89bc:	e28db000 	add	fp, sp, #0
    89c0:	e24dd01c 	sub	sp, sp, #28
    89c4:	e50b0010 	str	r0, [fp, #-16]
    89c8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    89cc:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    89d0:	e3a03000 	mov	r3, #0
    89d4:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58 (discriminator 4)
    89d8:	e51b2008 	ldr	r2, [fp, #-8]
    89dc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    89e0:	e1520003 	cmp	r2, r3
    89e4:	aa000011 	bge	8a30 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58 (discriminator 2)
    89e8:	e51b3008 	ldr	r3, [fp, #-8]
    89ec:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    89f0:	e0823003 	add	r3, r2, r3
    89f4:	e5d33000 	ldrb	r3, [r3]
    89f8:	e3530000 	cmp	r3, #0
    89fc:	0a00000b 	beq	8a30 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    8a00:	e51b3008 	ldr	r3, [fp, #-8]
    8a04:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8a08:	e0822003 	add	r2, r2, r3
    8a0c:	e51b3008 	ldr	r3, [fp, #-8]
    8a10:	e51b1010 	ldr	r1, [fp, #-16]
    8a14:	e0813003 	add	r3, r1, r3
    8a18:	e5d22000 	ldrb	r2, [r2]
    8a1c:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8a20:	e51b3008 	ldr	r3, [fp, #-8]
    8a24:	e2833001 	add	r3, r3, #1
    8a28:	e50b3008 	str	r3, [fp, #-8]
    8a2c:	eaffffe9 	b	89d8 <_Z7strncpyPcPKci+0x20>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    8a30:	e51b2008 	ldr	r2, [fp, #-8]
    8a34:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a38:	e1520003 	cmp	r2, r3
    8a3c:	aa000008 	bge	8a64 <_Z7strncpyPcPKci+0xac>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8a40:	e51b3008 	ldr	r3, [fp, #-8]
    8a44:	e51b2010 	ldr	r2, [fp, #-16]
    8a48:	e0823003 	add	r3, r2, r3
    8a4c:	e3a02000 	mov	r2, #0
    8a50:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8a54:	e51b3008 	ldr	r3, [fp, #-8]
    8a58:	e2833001 	add	r3, r3, #1
    8a5c:	e50b3008 	str	r3, [fp, #-8]
    8a60:	eafffff2 	b	8a30 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:63

   return dest;
    8a64:	e51b3010 	ldr	r3, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:64
}
    8a68:	e1a00003 	mov	r0, r3
    8a6c:	e28bd000 	add	sp, fp, #0
    8a70:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a74:	e12fff1e 	bx	lr

00008a78 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    8a78:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a7c:	e28db000 	add	fp, sp, #0
    8a80:	e24dd01c 	sub	sp, sp, #28
    8a84:	e50b0010 	str	r0, [fp, #-16]
    8a88:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8a8c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    8a90:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a94:	e2432001 	sub	r2, r3, #1
    8a98:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8a9c:	e3530000 	cmp	r3, #0
    8aa0:	c3a03001 	movgt	r3, #1
    8aa4:	d3a03000 	movle	r3, #0
    8aa8:	e6ef3073 	uxtb	r3, r3
    8aac:	e3530000 	cmp	r3, #0
    8ab0:	0a000016 	beq	8b10 <_Z7strncmpPKcS0_i+0x98>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    8ab4:	e51b3010 	ldr	r3, [fp, #-16]
    8ab8:	e2832001 	add	r2, r3, #1
    8abc:	e50b2010 	str	r2, [fp, #-16]
    8ac0:	e5d33000 	ldrb	r3, [r3]
    8ac4:	e54b3005 	strb	r3, [fp, #-5]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    8ac8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8acc:	e2832001 	add	r2, r3, #1
    8ad0:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8ad4:	e5d33000 	ldrb	r3, [r3]
    8ad8:	e54b3006 	strb	r3, [fp, #-6]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    8adc:	e55b2005 	ldrb	r2, [fp, #-5]
    8ae0:	e55b3006 	ldrb	r3, [fp, #-6]
    8ae4:	e1520003 	cmp	r2, r3
    8ae8:	0a000003 	beq	8afc <_Z7strncmpPKcS0_i+0x84>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    8aec:	e55b2005 	ldrb	r2, [fp, #-5]
    8af0:	e55b3006 	ldrb	r3, [fp, #-6]
    8af4:	e0423003 	sub	r3, r2, r3
    8af8:	ea000005 	b	8b14 <_Z7strncmpPKcS0_i+0x9c>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    8afc:	e55b3005 	ldrb	r3, [fp, #-5]
    8b00:	e3530000 	cmp	r3, #0
    8b04:	1affffe1 	bne	8a90 <_Z7strncmpPKcS0_i+0x18>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:76
        	return 0;
    8b08:	e3a03000 	mov	r3, #0
    8b0c:	ea000000 	b	8b14 <_Z7strncmpPKcS0_i+0x9c>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8b10:	e3a03000 	mov	r3, #0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:80
}
    8b14:	e1a00003 	mov	r0, r3
    8b18:	e28bd000 	add	sp, fp, #0
    8b1c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b20:	e12fff1e 	bx	lr

00008b24 <_Z6strlenPKc>:
_Z6strlenPKc():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8b24:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b28:	e28db000 	add	fp, sp, #0
    8b2c:	e24dd014 	sub	sp, sp, #20
    8b30:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:84
	int i = 0;
    8b34:	e3a03000 	mov	r3, #0
    8b38:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8b3c:	e51b3008 	ldr	r3, [fp, #-8]
    8b40:	e51b2010 	ldr	r2, [fp, #-16]
    8b44:	e0823003 	add	r3, r2, r3
    8b48:	e5d33000 	ldrb	r3, [r3]
    8b4c:	e3530000 	cmp	r3, #0
    8b50:	0a000003 	beq	8b64 <_Z6strlenPKc+0x40>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:87
		i++;
    8b54:	e51b3008 	ldr	r3, [fp, #-8]
    8b58:	e2833001 	add	r3, r3, #1
    8b5c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8b60:	eafffff5 	b	8b3c <_Z6strlenPKc+0x18>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:89

	return i;
    8b64:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:90
}
    8b68:	e1a00003 	mov	r0, r3
    8b6c:	e28bd000 	add	sp, fp, #0
    8b70:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b74:	e12fff1e 	bx	lr

00008b78 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8b78:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b7c:	e28db000 	add	fp, sp, #0
    8b80:	e24dd014 	sub	sp, sp, #20
    8b84:	e50b0010 	str	r0, [fp, #-16]
    8b88:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8b8c:	e51b3010 	ldr	r3, [fp, #-16]
    8b90:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8b94:	e3a03000 	mov	r3, #0
    8b98:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8b9c:	e51b2008 	ldr	r2, [fp, #-8]
    8ba0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8ba4:	e1520003 	cmp	r2, r3
    8ba8:	aa000008 	bge	8bd0 <_Z5bzeroPvi+0x58>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8bac:	e51b3008 	ldr	r3, [fp, #-8]
    8bb0:	e51b200c 	ldr	r2, [fp, #-12]
    8bb4:	e0823003 	add	r3, r2, r3
    8bb8:	e3a02000 	mov	r2, #0
    8bbc:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8bc0:	e51b3008 	ldr	r3, [fp, #-8]
    8bc4:	e2833001 	add	r3, r3, #1
    8bc8:	e50b3008 	str	r3, [fp, #-8]
    8bcc:	eafffff2 	b	8b9c <_Z5bzeroPvi+0x24>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:98
}
    8bd0:	e320f000 	nop	{0}
    8bd4:	e28bd000 	add	sp, fp, #0
    8bd8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8bdc:	e12fff1e 	bx	lr

00008be0 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8be0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8be4:	e28db000 	add	fp, sp, #0
    8be8:	e24dd024 	sub	sp, sp, #36	; 0x24
    8bec:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8bf0:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8bf4:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8bf8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8bfc:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8c00:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8c04:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8c08:	e3a03000 	mov	r3, #0
    8c0c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8c10:	e51b2008 	ldr	r2, [fp, #-8]
    8c14:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c18:	e1520003 	cmp	r2, r3
    8c1c:	aa00000b 	bge	8c50 <_Z6memcpyPKvPvi+0x70>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8c20:	e51b3008 	ldr	r3, [fp, #-8]
    8c24:	e51b200c 	ldr	r2, [fp, #-12]
    8c28:	e0822003 	add	r2, r2, r3
    8c2c:	e51b3008 	ldr	r3, [fp, #-8]
    8c30:	e51b1010 	ldr	r1, [fp, #-16]
    8c34:	e0813003 	add	r3, r1, r3
    8c38:	e5d22000 	ldrb	r2, [r2]
    8c3c:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8c40:	e51b3008 	ldr	r3, [fp, #-8]
    8c44:	e2833001 	add	r3, r3, #1
    8c48:	e50b3008 	str	r3, [fp, #-8]
    8c4c:	eaffffef 	b	8c10 <_Z6memcpyPKvPvi+0x30>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:107
}
    8c50:	e320f000 	nop	{0}
    8c54:	e28bd000 	add	sp, fp, #0
    8c58:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c5c:	e12fff1e 	bx	lr

00008c60 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1150
    8c60:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1152
    8c64:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1153
    8c68:	3a000074 	bcc	8e40 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1154
    8c6c:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1155
    8c70:	9a00006b 	bls	8e24 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    8c74:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    8c78:	0a00006c 	beq	8e30 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    8c7c:	e16f3f10 	clz	r3, r0
    8c80:	e16f2f11 	clz	r2, r1
    8c84:	e0423003 	sub	r3, r2, r3
    8c88:	e273301f 	rsbs	r3, r3, #31
    8c8c:	10833083 	addne	r3, r3, r3, lsl #1
    8c90:	e3a02000 	mov	r2, #0
    8c94:	108ff103 	addne	pc, pc, r3, lsl #2
    8c98:	e1a00000 	nop			; (mov r0, r0)
    8c9c:	e1500f81 	cmp	r0, r1, lsl #31
    8ca0:	e0a22002 	adc	r2, r2, r2
    8ca4:	20400f81 	subcs	r0, r0, r1, lsl #31
    8ca8:	e1500f01 	cmp	r0, r1, lsl #30
    8cac:	e0a22002 	adc	r2, r2, r2
    8cb0:	20400f01 	subcs	r0, r0, r1, lsl #30
    8cb4:	e1500e81 	cmp	r0, r1, lsl #29
    8cb8:	e0a22002 	adc	r2, r2, r2
    8cbc:	20400e81 	subcs	r0, r0, r1, lsl #29
    8cc0:	e1500e01 	cmp	r0, r1, lsl #28
    8cc4:	e0a22002 	adc	r2, r2, r2
    8cc8:	20400e01 	subcs	r0, r0, r1, lsl #28
    8ccc:	e1500d81 	cmp	r0, r1, lsl #27
    8cd0:	e0a22002 	adc	r2, r2, r2
    8cd4:	20400d81 	subcs	r0, r0, r1, lsl #27
    8cd8:	e1500d01 	cmp	r0, r1, lsl #26
    8cdc:	e0a22002 	adc	r2, r2, r2
    8ce0:	20400d01 	subcs	r0, r0, r1, lsl #26
    8ce4:	e1500c81 	cmp	r0, r1, lsl #25
    8ce8:	e0a22002 	adc	r2, r2, r2
    8cec:	20400c81 	subcs	r0, r0, r1, lsl #25
    8cf0:	e1500c01 	cmp	r0, r1, lsl #24
    8cf4:	e0a22002 	adc	r2, r2, r2
    8cf8:	20400c01 	subcs	r0, r0, r1, lsl #24
    8cfc:	e1500b81 	cmp	r0, r1, lsl #23
    8d00:	e0a22002 	adc	r2, r2, r2
    8d04:	20400b81 	subcs	r0, r0, r1, lsl #23
    8d08:	e1500b01 	cmp	r0, r1, lsl #22
    8d0c:	e0a22002 	adc	r2, r2, r2
    8d10:	20400b01 	subcs	r0, r0, r1, lsl #22
    8d14:	e1500a81 	cmp	r0, r1, lsl #21
    8d18:	e0a22002 	adc	r2, r2, r2
    8d1c:	20400a81 	subcs	r0, r0, r1, lsl #21
    8d20:	e1500a01 	cmp	r0, r1, lsl #20
    8d24:	e0a22002 	adc	r2, r2, r2
    8d28:	20400a01 	subcs	r0, r0, r1, lsl #20
    8d2c:	e1500981 	cmp	r0, r1, lsl #19
    8d30:	e0a22002 	adc	r2, r2, r2
    8d34:	20400981 	subcs	r0, r0, r1, lsl #19
    8d38:	e1500901 	cmp	r0, r1, lsl #18
    8d3c:	e0a22002 	adc	r2, r2, r2
    8d40:	20400901 	subcs	r0, r0, r1, lsl #18
    8d44:	e1500881 	cmp	r0, r1, lsl #17
    8d48:	e0a22002 	adc	r2, r2, r2
    8d4c:	20400881 	subcs	r0, r0, r1, lsl #17
    8d50:	e1500801 	cmp	r0, r1, lsl #16
    8d54:	e0a22002 	adc	r2, r2, r2
    8d58:	20400801 	subcs	r0, r0, r1, lsl #16
    8d5c:	e1500781 	cmp	r0, r1, lsl #15
    8d60:	e0a22002 	adc	r2, r2, r2
    8d64:	20400781 	subcs	r0, r0, r1, lsl #15
    8d68:	e1500701 	cmp	r0, r1, lsl #14
    8d6c:	e0a22002 	adc	r2, r2, r2
    8d70:	20400701 	subcs	r0, r0, r1, lsl #14
    8d74:	e1500681 	cmp	r0, r1, lsl #13
    8d78:	e0a22002 	adc	r2, r2, r2
    8d7c:	20400681 	subcs	r0, r0, r1, lsl #13
    8d80:	e1500601 	cmp	r0, r1, lsl #12
    8d84:	e0a22002 	adc	r2, r2, r2
    8d88:	20400601 	subcs	r0, r0, r1, lsl #12
    8d8c:	e1500581 	cmp	r0, r1, lsl #11
    8d90:	e0a22002 	adc	r2, r2, r2
    8d94:	20400581 	subcs	r0, r0, r1, lsl #11
    8d98:	e1500501 	cmp	r0, r1, lsl #10
    8d9c:	e0a22002 	adc	r2, r2, r2
    8da0:	20400501 	subcs	r0, r0, r1, lsl #10
    8da4:	e1500481 	cmp	r0, r1, lsl #9
    8da8:	e0a22002 	adc	r2, r2, r2
    8dac:	20400481 	subcs	r0, r0, r1, lsl #9
    8db0:	e1500401 	cmp	r0, r1, lsl #8
    8db4:	e0a22002 	adc	r2, r2, r2
    8db8:	20400401 	subcs	r0, r0, r1, lsl #8
    8dbc:	e1500381 	cmp	r0, r1, lsl #7
    8dc0:	e0a22002 	adc	r2, r2, r2
    8dc4:	20400381 	subcs	r0, r0, r1, lsl #7
    8dc8:	e1500301 	cmp	r0, r1, lsl #6
    8dcc:	e0a22002 	adc	r2, r2, r2
    8dd0:	20400301 	subcs	r0, r0, r1, lsl #6
    8dd4:	e1500281 	cmp	r0, r1, lsl #5
    8dd8:	e0a22002 	adc	r2, r2, r2
    8ddc:	20400281 	subcs	r0, r0, r1, lsl #5
    8de0:	e1500201 	cmp	r0, r1, lsl #4
    8de4:	e0a22002 	adc	r2, r2, r2
    8de8:	20400201 	subcs	r0, r0, r1, lsl #4
    8dec:	e1500181 	cmp	r0, r1, lsl #3
    8df0:	e0a22002 	adc	r2, r2, r2
    8df4:	20400181 	subcs	r0, r0, r1, lsl #3
    8df8:	e1500101 	cmp	r0, r1, lsl #2
    8dfc:	e0a22002 	adc	r2, r2, r2
    8e00:	20400101 	subcs	r0, r0, r1, lsl #2
    8e04:	e1500081 	cmp	r0, r1, lsl #1
    8e08:	e0a22002 	adc	r2, r2, r2
    8e0c:	20400081 	subcs	r0, r0, r1, lsl #1
    8e10:	e1500001 	cmp	r0, r1
    8e14:	e0a22002 	adc	r2, r2, r2
    8e18:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    8e1c:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    8e20:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    8e24:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    8e28:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    8e2c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1169
    8e30:	e16f2f11 	clz	r2, r1
    8e34:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1171
    8e38:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1172
    8e3c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1176
    8e40:	e3500000 	cmp	r0, #0
    8e44:	13e00000 	mvnne	r0, #0
    8e48:	ea000007 	b	8e6c <__aeabi_idiv0>

00008e4c <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1207
    8e4c:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1208
    8e50:	0afffffa 	beq	8e40 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1209
    8e54:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1210
    8e58:	ebffff80 	bl	8c60 <__udivsi3>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1211
    8e5c:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1212
    8e60:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1213
    8e64:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1214
    8e68:	e12fff1e 	bx	lr

00008e6c <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1512
    8e6c:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00008e70 <_ZL13Lock_Unlocked>:
    8e70:	00000000 	andeq	r0, r0, r0

00008e74 <_ZL11Lock_Locked>:
    8e74:	00000001 	andeq	r0, r0, r1

00008e78 <_ZL21MaxFSDriverNameLength>:
    8e78:	00000010 	andeq	r0, r0, r0, lsl r0

00008e7c <_ZL17MaxFilenameLength>:
    8e7c:	00000010 	andeq	r0, r0, r0, lsl r0

00008e80 <_ZL13MaxPathLength>:
    8e80:	00000080 	andeq	r0, r0, r0, lsl #1

00008e84 <_ZL18NoFilesystemDriver>:
    8e84:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008e88 <_ZL9NotifyAll>:
    8e88:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008e8c <_ZL24Max_Process_Opened_Files>:
    8e8c:	00000010 	andeq	r0, r0, r0, lsl r0

00008e90 <_ZL10Indefinite>:
    8e90:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008e94 <_ZL18Deadline_Unchanged>:
    8e94:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008e98 <_ZL14Invalid_Handle>:
    8e98:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    8e9c:	3a564544 	bcc	159a3b4 <__bss_end+0x1591498>
    8ea0:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
    8ea4:	0000302f 	andeq	r3, r0, pc, lsr #32
    8ea8:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
    8eac:	73617420 	cmnvc	r1, #32, 8	; 0x20000000
    8eb0:	7473206b 	ldrbtvc	r2, [r3], #-107	; 0xffffff95
    8eb4:	69747261 	ldmdbvs	r4!, {r0, r5, r6, r9, ip, sp, lr}^
    8eb8:	0a21676e 	beq	862c78 <__bss_end+0x859d5c>
    8ebc:	00000000 	andeq	r0, r0, r0

00008ec0 <_ZL13Lock_Unlocked>:
    8ec0:	00000000 	andeq	r0, r0, r0

00008ec4 <_ZL11Lock_Locked>:
    8ec4:	00000001 	andeq	r0, r0, r1

00008ec8 <_ZL21MaxFSDriverNameLength>:
    8ec8:	00000010 	andeq	r0, r0, r0, lsl r0

00008ecc <_ZL17MaxFilenameLength>:
    8ecc:	00000010 	andeq	r0, r0, r0, lsl r0

00008ed0 <_ZL13MaxPathLength>:
    8ed0:	00000080 	andeq	r0, r0, r0, lsl #1

00008ed4 <_ZL18NoFilesystemDriver>:
    8ed4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ed8 <_ZL9NotifyAll>:
    8ed8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008edc <_ZL24Max_Process_Opened_Files>:
    8edc:	00000010 	andeq	r0, r0, r0, lsl r0

00008ee0 <_ZL10Indefinite>:
    8ee0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ee4 <_ZL18Deadline_Unchanged>:
    8ee4:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008ee8 <_ZL14Invalid_Handle>:
    8ee8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008eec <_ZL16Pipe_File_Prefix>:
    8eec:	3a535953 	bcc	14df440 <__bss_end+0x14d6524>
    8ef0:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    8ef4:	0000002f 	andeq	r0, r0, pc, lsr #32

00008ef8 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    8ef8:	33323130 	teqcc	r2, #48, 2
    8efc:	37363534 			; <UNDEFINED> instruction: 0x37363534
    8f00:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    8f04:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00008f0c <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1684910>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x39508>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3d11c>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c7e08>
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
 130:	6b69746e 	blvs	1a5d2f0 <__bss_end+0x1a543d4>
 134:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
 138:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 13c:	4f54522d 	svcmi	0x0054522d
 140:	616d2d53 	cmnvs	sp, r3, asr sp
 144:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 148:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe21 <__bss_end+0xffff6f05>
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
 180:	0a030000 	beq	c0188 <__bss_end+0xb726c>
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
 1d4:	6a0d05a1 	bvs	341860 <__bss_end+0x338944>
 1d8:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
 1dc:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 1e0:	04020004 	streq	r0, [r2], #-4
 1e4:	0b058302 	bleq	160df4 <__bss_end+0x157ed8>
 1e8:	02040200 	andeq	r0, r4, #0, 4
 1ec:	0002054a 	andeq	r0, r2, sl, asr #10
 1f0:	2d020402 	cfstrscs	mvf0, [r2, #-8]
 1f4:	05850905 	streq	r0, [r5, #2309]	; 0x905
 1f8:	0a022f01 	beq	8be04 <__bss_end+0x82ee8>
 1fc:	42010100 	andmi	r0, r1, #0, 2
 200:	03000002 	movweq	r0, #2
 204:	00020000 	andeq	r0, r2, r0
 208:	fb010200 	blx	40a12 <__bss_end+0x37af6>
 20c:	01000d0e 	tsteq	r0, lr, lsl #26
 210:	00010101 	andeq	r0, r1, r1, lsl #2
 214:	00010000 	andeq	r0, r1, r0
 218:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 21c:	2f656d6f 	svccs	0x00656d6f
 220:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
 224:	642f6b69 	strtvs	r6, [pc], #-2921	; 22c <shift+0x22c>
 228:	4b2f7665 	blmi	bddbc4 <__bss_end+0xbd4ca8>
 22c:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 230:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
 234:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
 238:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
 23c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 240:	752f7365 	strvc	r7, [pc, #-869]!	; fffffee3 <__bss_end+0xffff6fc7>
 244:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 248:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 24c:	676f6c2f 	strbvs	r6, [pc, -pc, lsr #24]!
 250:	5f726567 	svcpl	0x00726567
 254:	6b736174 	blvs	1cd882c <__bss_end+0x1ccf910>
 258:	6f682f00 	svcvs	0x00682f00
 25c:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
 260:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
 264:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
 268:	494b2f76 	stmdbmi	fp, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
 26c:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
 270:	6d2d534f 	stcvs	3, cr5, [sp, #-316]!	; 0xfffffec4
 274:	65747361 	ldrbvs	r7, [r4, #-865]!	; 0xfffffc9f
 278:	6f732f72 	svcvs	0x00732f72
 27c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 280:	73752f73 	cmnvc	r5, #460	; 0x1cc
 284:	70737265 	rsbsvc	r7, r3, r5, ror #4
 288:	2f656361 	svccs	0x00656361
 28c:	6b2f2e2e 	blvs	bcbb4c <__bss_end+0xbc2c30>
 290:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 294:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 298:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 29c:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
 2a0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 2a4:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 2a8:	2f656d6f 	svccs	0x00656d6f
 2ac:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
 2b0:	642f6b69 	strtvs	r6, [pc], #-2921	; 2b8 <shift+0x2b8>
 2b4:	4b2f7665 	blmi	bddc50 <__bss_end+0xbd4d34>
 2b8:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 2bc:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
 2c0:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
 2c4:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
 2c8:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 2cc:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff6f <__bss_end+0xffff7053>
 2d0:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 2d4:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 2d8:	2f2e2e2f 	svccs	0x002e2e2f
 2dc:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 2e0:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 2e4:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 2e8:	662f6564 	strtvs	r6, [pc], -r4, ror #10
 2ec:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 2f0:	2f656d6f 	svccs	0x00656d6f
 2f4:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
 2f8:	642f6b69 	strtvs	r6, [pc], #-2921	; 300 <shift+0x300>
 2fc:	4b2f7665 	blmi	bddc98 <__bss_end+0xbd4d7c>
 300:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 304:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
 308:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
 30c:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
 310:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 314:	752f7365 	strvc	r7, [pc, #-869]!	; ffffffb7 <__bss_end+0xffff709b>
 318:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 31c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 320:	2f2e2e2f 	svccs	0x002e2e2f
 324:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 328:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 32c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 330:	642f6564 	strtvs	r6, [pc], #-1380	; 338 <shift+0x338>
 334:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
 338:	622f7372 	eorvs	r7, pc, #-939524095	; 0xc8000001
 33c:	67646972 			; <UNDEFINED> instruction: 0x67646972
 340:	2f007365 	svccs	0x00007365
 344:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 348:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 34c:	2f6b6974 	svccs	0x006b6974
 350:	2f766564 	svccs	0x00766564
 354:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 358:	534f5452 	movtpl	r5, #62546	; 0xf452
 35c:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 360:	2f726574 	svccs	0x00726574
 364:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 368:	2f736563 	svccs	0x00736563
 36c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 370:	63617073 	cmnvs	r1, #115	; 0x73
 374:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 378:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 37c:	2f6c656e 	svccs	0x006c656e
 380:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 384:	2f656475 	svccs	0x00656475
 388:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 38c:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 390:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 394:	00006c61 	andeq	r6, r0, r1, ror #24
 398:	6e69616d 	powvsez	f6, f1, #5.0
 39c:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 3a0:	00000100 	andeq	r0, r0, r0, lsl #2
 3a4:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
 3a8:	00020068 	andeq	r0, r2, r8, rrx
 3ac:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
 3b0:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
 3b4:	00682e6b 	rsbeq	r2, r8, fp, ror #28
 3b8:	66000002 	strvs	r0, [r0], -r2
 3bc:	73656c69 	cmnvc	r5, #26880	; 0x6900
 3c0:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 3c4:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 3c8:	70000003 	andvc	r0, r0, r3
 3cc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 3d0:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
 3d4:	00000200 	andeq	r0, r0, r0, lsl #4
 3d8:	636f7270 	cmnvs	pc, #112, 4
 3dc:	5f737365 	svcpl	0x00737365
 3e0:	616e616d 	cmnvs	lr, sp, ror #2
 3e4:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
 3e8:	00020068 	andeq	r0, r2, r8, rrx
 3ec:	72617500 	rsbvc	r7, r1, #0, 10
 3f0:	65645f74 	strbvs	r5, [r4, #-3956]!	; 0xfffff08c
 3f4:	682e7366 	stmdavs	lr!, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
 3f8:	00000400 	andeq	r0, r0, r0, lsl #8
 3fc:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 400:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 404:	00000500 	andeq	r0, r0, r0, lsl #10
 408:	00010500 	andeq	r0, r1, r0, lsl #10
 40c:	82340205 	eorshi	r0, r4, #1342177280	; 0x50000000
 410:	0d030000 	stceq	0, cr0, [r3, #-0]
 414:	9f1c0501 	svcls	0x001c0501
 418:	05660705 	strbeq	r0, [r6, #-1797]!	; 0xfffff8fb
 41c:	37058301 	strcc	r8, [r5, -r1, lsl #6]
 420:	bb090568 	bllt	2419c8 <__bss_end+0x238aac>
 424:	699f0105 	ldmibvs	pc, {r0, r2, r8}	; <UNPREDICTABLE>
 428:	059f1b05 	ldreq	r1, [pc, #2821]	; f35 <shift+0xf35>
 42c:	15058513 	strne	r8, [r5, #-1299]	; 0xfffffaed
 430:	4b07054b 	blmi	1c1964 <__bss_end+0x1b8a48>
 434:	68a00a05 	stmiavs	r0!, {r0, r2, r9, fp}
 438:	0c0568a0 	stceq	8, cr6, [r5], {160}	; 0xa0
 43c:	2f010584 	svccs	0x00010584
 440:	01000c02 	tsteq	r0, r2, lsl #24
 444:	0002a301 	andeq	sl, r2, r1, lsl #6
 448:	6d000300 	stcvs	3, cr0, [r0, #-0]
 44c:	02000001 	andeq	r0, r0, #1
 450:	0d0efb01 	vstreq	d15, [lr, #-4]
 454:	01010100 	mrseq	r0, (UNDEF: 17)
 458:	00000001 	andeq	r0, r0, r1
 45c:	01000001 	tsteq	r0, r1
 460:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 3ac <shift+0x3ac>
 464:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 468:	6b69746e 	blvs	1a5d628 <__bss_end+0x1a5470c>
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
 49c:	6b69746e 	blvs	1a5d65c <__bss_end+0x1a54740>
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
 4dc:	6b69746e 	blvs	1a5d69c <__bss_end+0x1a54780>
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
 5c0:	00834802 	addeq	r4, r3, r2, lsl #16
 5c4:	1a051600 	bne	145dcc <__bss_end+0x13ceb0>
 5c8:	2f2c0569 	svccs	0x002c0569
 5cc:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 5d0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 5d4:	1a058332 	bne	1612a4 <__bss_end+0x158388>
 5d8:	2f01054b 	svccs	0x0001054b
 5dc:	4b1a0585 	blmi	681bf8 <__bss_end+0x678cdc>
 5e0:	852f0105 	strhi	r0, [pc, #-261]!	; 4e3 <shift+0x4e3>
 5e4:	05a13205 	streq	r3, [r1, #517]!	; 0x205
 5e8:	1b054b2e 	blne	1532a8 <__bss_end+0x14a38c>
 5ec:	2f2d054b 	svccs	0x002d054b
 5f0:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 5f4:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 5f8:	3005bd2e 	andcc	fp, r5, lr, lsr #26
 5fc:	4b2e054b 	blmi	b81b30 <__bss_end+0xb78c14>
 600:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 604:	0c052f2e 	stceq	15, cr2, [r5], {46}	; 0x2e
 608:	2f01054c 	svccs	0x0001054c
 60c:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 610:	054b3005 	strbeq	r3, [fp, #-5]
 614:	1b054b2e 	blne	1532d4 <__bss_end+0x14a3b8>
 618:	2f2e054b 	svccs	0x002e054b
 61c:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 620:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 624:	1b05832e 	blne	1612e4 <__bss_end+0x1583c8>
 628:	2f01054b 	svccs	0x0001054b
 62c:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 630:	054b3305 	strbeq	r3, [fp, #-773]	; 0xfffffcfb
 634:	1b054b2f 	blne	1532f8 <__bss_end+0x14a3dc>
 638:	2f30054b 	svccs	0x0030054b
 63c:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 640:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 644:	2f05a12e 	svccs	0x0005a12e
 648:	4b1b054b 	blmi	6c1b7c <__bss_end+0x6b8c60>
 64c:	052f2f05 	streq	r2, [pc, #-3845]!	; fffff74f <__bss_end+0xffff6833>
 650:	01054c0c 	tsteq	r5, ip, lsl #24
 654:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 658:	4b2f05bd 	blmi	bc1d54 <__bss_end+0xbb8e38>
 65c:	054b3b05 	strbeq	r3, [fp, #-2821]	; 0xfffff4fb
 660:	30054b1b 	andcc	r4, r5, fp, lsl fp
 664:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 668:	852f0105 	strhi	r0, [pc, #-261]!	; 56b <shift+0x56b>
 66c:	05a12f05 	streq	r2, [r1, #3845]!	; 0xf05
 670:	1a054b3b 	bne	153364 <__bss_end+0x14a448>
 674:	2f30054b 	svccs	0x0030054b
 678:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 67c:	05859f01 	streq	r9, [r5, #3841]	; 0xf01
 680:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
 684:	4b31054d 	blmi	c41bc0 <__bss_end+0xc38ca4>
 688:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 68c:	0105300c 	tsteq	r5, ip
 690:	2005852f 	andcs	r8, r5, pc, lsr #10
 694:	4d2d0567 	cfstr32mi	mvfx0, [sp, #-412]!	; 0xfffffe64
 698:	054b3105 	strbeq	r3, [fp, #-261]	; 0xfffffefb
 69c:	0c054b1a 			; <UNDEFINED> instruction: 0x0c054b1a
 6a0:	2f010530 	svccs	0x00010530
 6a4:	83200585 			; <UNDEFINED> instruction: 0x83200585
 6a8:	054c2d05 	strbeq	r2, [ip, #-3333]	; 0xfffff2fb
 6ac:	1a054b3e 	bne	1533ac <__bss_end+0x14a490>
 6b0:	2f01054b 	svccs	0x0001054b
 6b4:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 6b8:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
 6bc:	1a054b30 	bne	153384 <__bss_end+0x14a468>
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
 750:	a8020500 	stmdage	r2, {r8, sl}
 754:	1a000087 	bne	978 <shift+0x978>
 758:	05bb0605 	ldreq	r0, [fp, #1541]!	; 0x605
 75c:	21054c0f 	tstcs	r5, pc, lsl #24
 760:	ba0b0568 	blt	2c1d08 <__bss_end+0x2b8dec>
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
 7d0:	0b052e02 	bleq	14bfe0 <__bss_end+0x1430c4>
 7d4:	02040200 	andeq	r0, r4, #0, 4
 7d8:	000d052f 	andeq	r0, sp, pc, lsr #10
 7dc:	66020402 	strvs	r0, [r2], -r2, lsl #8
 7e0:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 7e4:	05460204 	strbeq	r0, [r6, #-516]	; 0xfffffdfc
 7e8:	05858801 	streq	r8, [r5, #2049]	; 0x801
 7ec:	09058306 	stmdbeq	r5, {r1, r2, r8, r9, pc}
 7f0:	4a10054c 	bmi	401d28 <__bss_end+0x3f8e0c>
 7f4:	054c0a05 	strbeq	r0, [ip, #-2565]	; 0xfffff5fb
 7f8:	0305bb07 	movweq	fp, #23303	; 0x5b07
 7fc:	0017054a 	andseq	r0, r7, sl, asr #10
 800:	4a010402 	bmi	41810 <__bss_end+0x388f4>
 804:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 808:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 80c:	14054d0d 	strne	r4, [r5], #-3341	; 0xfffff2f3
 810:	2e0a054a 	cfsh32cs	mvfx0, mvfx10, #42
 814:	05680805 	strbeq	r0, [r8, #-2053]!	; 0xfffff7fb
 818:	66780302 	ldrbtvs	r0, [r8], -r2, lsl #6
 81c:	0b030905 	bleq	c2c38 <__bss_end+0xb9d1c>
 820:	2f01052e 	svccs	0x0001052e
 824:	bd090585 	cfstr32lt	mvfx0, [r9, #-532]	; 0xfffffdec
 828:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 82c:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
 830:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
 834:	16058202 	strne	r8, [r5], -r2, lsl #4
 838:	02040200 	andeq	r0, r4, #0, 4
 83c:	00120582 	andseq	r0, r2, r2, lsl #11
 840:	4b030402 	blmi	c1850 <__bss_end+0xb8934>
 844:	02000905 	andeq	r0, r0, #81920	; 0x14000
 848:	05660304 	strbeq	r0, [r6, #-772]!	; 0xfffffcfc
 84c:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 850:	0b056603 	bleq	15a064 <__bss_end+0x151148>
 854:	03040200 	movweq	r0, #16896	; 0x4200
 858:	0002052e 	andeq	r0, r2, lr, lsr #10
 85c:	2d030402 	cfstrscs	mvf0, [r3, #-8]
 860:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 864:	05840204 	streq	r0, [r4, #516]	; 0x204
 868:	04020009 	streq	r0, [r2], #-9
 86c:	0b058301 	bleq	161478 <__bss_end+0x15855c>
 870:	01040200 	mrseq	r0, R12_usr
 874:	00020566 	andeq	r0, r2, r6, ror #10
 878:	49010402 	stmdbmi	r1, {r1, sl}
 87c:	05850b05 	streq	r0, [r5, #2821]	; 0xb05
 880:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 884:	1105bc0e 	tstne	r5, lr, lsl #24
 888:	bc200566 	cfstr32lt	mvfx0, [r0], #-408	; 0xfffffe68
 88c:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
 890:	0a054b1f 	beq	153514 <__bss_end+0x14a5f8>
 894:	4b080566 	blmi	201e34 <__bss_end+0x1f8f18>
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
 8fc:	0b058302 	bleq	16150c <__bss_end+0x1585f0>
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
 974:	008c6002 	addeq	r6, ip, r2
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
 9a8:	fb010200 	blx	411b2 <__bss_end+0x38296>
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
 9f0:	8e6c0205 	cdphi	2, 6, cr0, cr12, cr5, {0}
 9f4:	e7030000 	str	r0, [r3, -r0]
 9f8:	0202010b 	andeq	r0, r2, #-1073741822	; 0xc0000002
 9fc:	03010100 	movweq	r0, #4352	; 0x1100
 a00:	03000001 	movweq	r0, #1
 a04:	0000fd00 	andeq	pc, r0, r0, lsl #26
 a08:	fb010200 	blx	41212 <__bss_end+0x382f6>
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
      58:	176e0704 	strbne	r0, [lr, -r4, lsl #14]!
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
      b0:	0b010000 	bleq	400b8 <__bss_end+0x3719c>
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
     11c:	176e0704 	strbne	r0, [lr, -r4, lsl #14]!
     120:	7a080000 	bvc	200128 <__bss_end+0x1f720c>
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
     15c:	3a010000 	bcc	40164 <__bss_end+0x37248>
     160:	00007615 	andeq	r7, r0, r5, lsl r6
     164:	01dc0900 	bicseq	r0, ip, r0, lsl #18
     168:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
     16c:	0000cb10 	andeq	ip, r0, r0, lsl fp
     170:	0081dc00 	addeq	sp, r1, r0, lsl #24
     174:	00005800 	andeq	r5, r0, r0, lsl #16
     178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f7664>
     17c:	0a000000 	beq	184 <shift+0x184>
     180:	000001ea 	andeq	r0, r0, sl, ror #3
     184:	d20c4a01 	andle	r4, ip, #4096	; 0x1000
     188:	02000000 	andeq	r0, r0, #0
     18c:	0b007491 	bleq	1d3d8 <__bss_end+0x144bc>
     190:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     194:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
     198:	00000038 	andeq	r0, r0, r8, lsr r0
     19c:	00036d09 	andeq	r6, r3, r9, lsl #26
     1a0:	103c0100 	eorsne	r0, ip, r0, lsl #2
     1a4:	000000cb 	andeq	r0, r0, fp, asr #1
     1a8:	00008184 	andeq	r8, r0, r4, lsl #3
     1ac:	00000058 	andeq	r0, r0, r8, asr r0
     1b0:	01029c01 	tsteq	r2, r1, lsl #24
     1b4:	ea0a0000 	b	2801bc <__bss_end+0x2772a0>
     1b8:	01000001 	tsteq	r0, r1
     1bc:	01020c3e 	tsteq	r2, lr, lsr ip
     1c0:	91020000 	mrsls	r0, (UNDEF: 2)
     1c4:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
     1c8:	00000025 	andeq	r0, r0, r5, lsr #32
     1cc:	0001c50c 	andeq	ip, r1, ip, lsl #10
     1d0:	11290100 			; <UNDEFINED> instruction: 0x11290100
     1d4:	00008178 	andeq	r8, r0, r8, ror r1
     1d8:	0000000c 	andeq	r0, r0, ip
     1dc:	fb0c9c01 	blx	3271ea <__bss_end+0x31e2ce>
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
     254:	cb110a01 	blgt	442a60 <__bss_end+0x439b44>
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
     2bc:	0a010067 	beq	40460 <__bss_end+0x37544>
     2c0:	00019e2f 	andeq	r9, r1, pc, lsr #28
     2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     2c8:	09aa0000 	stmibeq	sl!, {}	; <UNPREDICTABLE>
     2cc:	00040000 	andeq	r0, r4, r0
     2d0:	000001c6 	andeq	r0, r0, r6, asr #3
     2d4:	02650104 	rsbeq	r0, r5, #4, 2
     2d8:	48040000 	stmdami	r4, {}	; <UNPREDICTABLE>
     2dc:	3a000004 	bcc	2f4 <shift+0x2f4>
     2e0:	34000000 	strcc	r0, [r0], #-0
     2e4:	14000082 	strne	r0, [r0], #-130	; 0xffffff7e
     2e8:	ff000001 			; <UNDEFINED> instruction: 0xff000001
     2ec:	02000001 	andeq	r0, r0, #1
     2f0:	0a570801 	beq	15c22fc <__bss_end+0x15b93e0>
     2f4:	25030000 	strcs	r0, [r3, #-0]
     2f8:	02000000 	andeq	r0, r0, #0
     2fc:	0a8e0502 	beq	fe38170c <__bss_end+0xfe3787f0>
     300:	04040000 	streq	r0, [r4], #-0
     304:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     308:	08010200 	stmdaeq	r1, {r9}
     30c:	00000a4e 	andeq	r0, r0, lr, asr #20
     310:	40070202 	andmi	r0, r7, r2, lsl #4
     314:	05000008 	streq	r0, [r0, #-8]
     318:	00000ad3 	ldrdeq	r0, [r0], -r3
     31c:	5e1e0908 	vnmlspl.f16	s0, s28, s16	; <UNPREDICTABLE>
     320:	03000000 	movweq	r0, #0
     324:	0000004d 	andeq	r0, r0, sp, asr #32
     328:	6e070402 	cdpvs	4, 0, cr0, cr7, cr2, {0}
     32c:	06000017 			; <UNDEFINED> instruction: 0x06000017
     330:	000006dc 	ldrdeq	r0, [r0], -ip
     334:	08060208 	stmdaeq	r6, {r3, r9}
     338:	0000008b 	andeq	r0, r0, fp, lsl #1
     33c:	00307207 	eorseq	r7, r0, r7, lsl #4
     340:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
     344:	00000000 	andeq	r0, r0, r0
     348:	00317207 	eorseq	r7, r1, r7, lsl #4
     34c:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
     350:	04000000 	streq	r0, [r0], #-0
     354:	059f0800 	ldreq	r0, [pc, #2048]	; b5c <shift+0xb5c>
     358:	04050000 	streq	r0, [r5], #-0
     35c:	00000038 	andeq	r0, r0, r8, lsr r0
     360:	c20c1e02 	andgt	r1, ip, #2, 28
     364:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     368:	00000743 	andeq	r0, r0, r3, asr #14
     36c:	0d8d0900 	vstreq.16	s0, [sp]	; <UNPREDICTABLE>
     370:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     374:	00000d57 	andeq	r0, r0, r7, asr sp
     378:	08aa0902 	stmiaeq	sl!, {r1, r8, fp}
     37c:	09030000 	stmdbeq	r3, {}	; <UNPREDICTABLE>
     380:	000009c9 	andeq	r0, r0, r9, asr #19
     384:	070c0904 	streq	r0, [ip, -r4, lsl #18]
     388:	00050000 	andeq	r0, r5, r0
     38c:	000cc708 	andeq	ip, ip, r8, lsl #14
     390:	38040500 	stmdacc	r4, {r8, sl}
     394:	02000000 	andeq	r0, r0, #0
     398:	00ff0c3f 	rscseq	r0, pc, pc, lsr ip	; <UNPREDICTABLE>
     39c:	02090000 	andeq	r0, r9, #0
     3a0:	00000004 	andeq	r0, r0, r4
     3a4:	0005b409 	andeq	fp, r5, r9, lsl #8
     3a8:	bc090100 	stflts	f0, [r9], {-0}
     3ac:	02000009 	andeq	r0, r0, #9
     3b0:	000d2209 	andeq	r2, sp, r9, lsl #4
     3b4:	97090300 	strls	r0, [r9, -r0, lsl #6]
     3b8:	0400000d 	streq	r0, [r0], #-13
     3bc:	00097d09 	andeq	r7, r9, r9, lsl #26
     3c0:	60090500 	andvs	r0, r9, r0, lsl #10
     3c4:	06000008 	streq	r0, [r0], -r8
     3c8:	0c810800 	stceq	8, cr0, [r1], {0}
     3cc:	04050000 	streq	r0, [r5], #-0
     3d0:	00000038 	andeq	r0, r0, r8, lsr r0
     3d4:	2a0c6602 	bcs	319be4 <__bss_end+0x310cc8>
     3d8:	09000001 	stmdbeq	r0, {r0}
     3dc:	00000a2c 	andeq	r0, r0, ip, lsr #20
     3e0:	08220900 	stmdaeq	r2!, {r8, fp}
     3e4:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     3e8:	00000aa2 	andeq	r0, r0, r2, lsr #21
     3ec:	08650902 	stmdaeq	r5!, {r1, r8, fp}^
     3f0:	00030000 	andeq	r0, r3, r0
     3f4:	0009840a 	andeq	r8, r9, sl, lsl #8
     3f8:	14050300 	strne	r0, [r5], #-768	; 0xfffffd00
     3fc:	00000059 	andeq	r0, r0, r9, asr r0
     400:	8e700305 	cdphi	3, 7, cr0, cr0, cr5, {0}
     404:	980a0000 	stmdals	sl, {}	; <UNPREDICTABLE>
     408:	03000009 	movweq	r0, #9
     40c:	00591406 	subseq	r1, r9, r6, lsl #8
     410:	03050000 	movweq	r0, #20480	; 0x5000
     414:	00008e74 	andeq	r8, r0, r4, ror lr
     418:	0009670a 	andeq	r6, r9, sl, lsl #14
     41c:	1a070400 	bne	1c1424 <__bss_end+0x1b8508>
     420:	00000059 	andeq	r0, r0, r9, asr r0
     424:	8e780305 	cdphi	3, 7, cr0, cr8, cr5, {0}
     428:	e40a0000 	str	r0, [sl], #-0
     42c:	04000005 	streq	r0, [r0], #-5
     430:	00591a09 	subseq	r1, r9, r9, lsl #20
     434:	03050000 	movweq	r0, #20480	; 0x5000
     438:	00008e7c 	andeq	r8, r0, ip, ror lr
     43c:	000a400a 	andeq	r4, sl, sl
     440:	1a0b0400 	bne	2c1448 <__bss_end+0x2b852c>
     444:	00000059 	andeq	r0, r0, r9, asr r0
     448:	8e800305 	cdphi	3, 8, cr0, cr0, cr5, {0}
     44c:	0f0a0000 	svceq	0x000a0000
     450:	04000008 	streq	r0, [r0], #-8
     454:	00591a0d 	subseq	r1, r9, sp, lsl #20
     458:	03050000 	movweq	r0, #20480	; 0x5000
     45c:	00008e84 	andeq	r8, r0, r4, lsl #29
     460:	0006f50a 	andeq	pc, r6, sl, lsl #10
     464:	1a0f0400 	bne	3c146c <__bss_end+0x3b8550>
     468:	00000059 	andeq	r0, r0, r9, asr r0
     46c:	8e880305 	cdphi	3, 8, cr0, cr8, cr5, {0}
     470:	0a080000 	beq	200478 <__bss_end+0x1f755c>
     474:	0500000b 	streq	r0, [r0, #-11]
     478:	00003804 	andeq	r3, r0, r4, lsl #16
     47c:	0c1b0400 	cfldrseq	mvf0, [fp], {-0}
     480:	000001cd 	andeq	r0, r0, sp, asr #3
     484:	000b3809 	andeq	r3, fp, r9, lsl #16
     488:	47090000 	strmi	r0, [r9, -r0]
     48c:	0100000d 	tsteq	r0, sp
     490:	0009b709 	andeq	fp, r9, r9, lsl #14
     494:	0b000200 	bleq	c9c <shift+0xc9c>
     498:	00000a26 	andeq	r0, r0, r6, lsr #20
     49c:	000a820c 	andeq	r8, sl, ip, lsl #4
     4a0:	63049000 	movwvs	r9, #16384	; 0x4000
     4a4:	00034007 	andeq	r4, r3, r7
     4a8:	0cf60600 	ldcleq	6, cr0, [r6]
     4ac:	04240000 	strteq	r0, [r4], #-0
     4b0:	025a1067 	subseq	r1, sl, #103	; 0x67
     4b4:	560d0000 	strpl	r0, [sp], -r0
     4b8:	0400001b 	streq	r0, [r0], #-27	; 0xffffffe5
     4bc:	03402869 	movteq	r2, #2153	; 0x869
     4c0:	0d000000 	stceq	0, cr0, [r0, #-0]
     4c4:	00000593 	muleq	r0, r3, r5
     4c8:	50206b04 	eorpl	r6, r0, r4, lsl #22
     4cc:	10000003 	andne	r0, r0, r3
     4d0:	000b2d0d 	andeq	r2, fp, sp, lsl #26
     4d4:	236d0400 	cmncs	sp, #0, 8
     4d8:	0000004d 	andeq	r0, r0, sp, asr #32
     4dc:	05dd0d14 	ldrbeq	r0, [sp, #3348]	; 0xd14
     4e0:	70040000 	andvc	r0, r4, r0
     4e4:	0003571c 	andeq	r5, r3, ip, lsl r7
     4e8:	370d1800 	strcc	r1, [sp, -r0, lsl #16]
     4ec:	0400000a 	streq	r0, [r0], #-10
     4f0:	03571c72 	cmpeq	r7, #29184	; 0x7200
     4f4:	0d1c0000 	ldceq	0, cr0, [ip, #-0]
     4f8:	00000570 	andeq	r0, r0, r0, ror r5
     4fc:	571c7504 	ldrpl	r7, [ip, -r4, lsl #10]
     500:	20000003 	andcs	r0, r0, r3
     504:	00074b0e 	andeq	r4, r7, lr, lsl #22
     508:	1c770400 	cfldrdne	mvd0, [r7], #-0
     50c:	000004da 	ldrdeq	r0, [r0], -sl
     510:	00000357 	andeq	r0, r0, r7, asr r3
     514:	0000024e 	andeq	r0, r0, lr, asr #4
     518:	0003570f 	andeq	r5, r3, pc, lsl #14
     51c:	035d1000 	cmpeq	sp, #0
     520:	00000000 	andeq	r0, r0, r0
     524:	00064206 	andeq	r4, r6, r6, lsl #4
     528:	7b041800 	blvc	106530 <__bss_end+0xfd614>
     52c:	00028f10 	andeq	r8, r2, r0, lsl pc
     530:	1b560d00 	blne	1583938 <__bss_end+0x157aa1c>
     534:	7e040000 	cdpvc	0, 0, cr0, cr4, cr0, {0}
     538:	0003402c 	andeq	r4, r3, ip, lsr #32
     53c:	880d0000 	stmdahi	sp, {}	; <UNPREDICTABLE>
     540:	04000005 	streq	r0, [r0], #-5
     544:	035d1980 	cmpeq	sp, #128, 18	; 0x200000
     548:	0d100000 	ldceq	0, cr0, [r0, #-0]
     54c:	00000d28 	andeq	r0, r0, r8, lsr #26
     550:	68218204 	stmdavs	r1!, {r2, r9, pc}
     554:	14000003 	strne	r0, [r0], #-3
     558:	025a0300 	subseq	r0, sl, #0, 6
     55c:	33110000 	tstcc	r1, #0
     560:	04000009 	streq	r0, [r0], #-9
     564:	036e2186 	cmneq	lr, #-2147483615	; 0x80000021
     568:	cb110000 	blgt	440570 <__bss_end+0x437654>
     56c:	04000007 	streq	r0, [r0], #-7
     570:	00591f88 	subseq	r1, r9, r8, lsl #31
     574:	b90d0000 	stmdblt	sp, {}	; <UNPREDICTABLE>
     578:	0400000a 	streq	r0, [r0], #-10
     57c:	01df178b 	bicseq	r1, pc, fp, lsl #15
     580:	0d000000 	stceq	0, cr0, [r0, #-0]
     584:	000008b0 			; <UNDEFINED> instruction: 0x000008b0
     588:	df178e04 	svcle	0x00178e04
     58c:	24000001 	strcs	r0, [r0], #-1
     590:	0007dd0d 	andeq	sp, r7, sp, lsl #26
     594:	178f0400 	strne	r0, [pc, r0, lsl #8]
     598:	000001df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     59c:	0d770d48 	ldcleq	13, cr0, [r7, #-288]!	; 0xfffffee0
     5a0:	90040000 	andls	r0, r4, r0
     5a4:	0001df17 	andeq	sp, r1, r7, lsl pc
     5a8:	82126c00 	andshi	r6, r2, #0, 24
     5ac:	0400000a 	streq	r0, [r0], #-10
     5b0:	062d0993 			; <UNDEFINED> instruction: 0x062d0993
     5b4:	03790000 	cmneq	r9, #0
     5b8:	f9010000 			; <UNDEFINED> instruction: 0xf9010000
     5bc:	ff000002 			; <UNDEFINED> instruction: 0xff000002
     5c0:	0f000002 	svceq	0x00000002
     5c4:	00000379 	andeq	r0, r0, r9, ror r3
     5c8:	09281300 	stmdbeq	r8!, {r8, r9, ip}
     5cc:	96040000 	strls	r0, [r4], -r0
     5d0:	00087d0e 	andeq	r7, r8, lr, lsl #26
     5d4:	03140100 	tsteq	r4, #0, 2
     5d8:	031a0000 	tsteq	sl, #0
     5dc:	790f0000 	stmdbvc	pc, {}	; <UNPREDICTABLE>
     5e0:	00000003 	andeq	r0, r0, r3
     5e4:	00040214 	andeq	r0, r4, r4, lsl r2
     5e8:	10990400 	addsne	r0, r9, r0, lsl #8
     5ec:	00000aef 	andeq	r0, r0, pc, ror #21
     5f0:	0000037f 	andeq	r0, r0, pc, ror r3
     5f4:	00032f01 	andeq	r2, r3, r1, lsl #30
     5f8:	03790f00 	cmneq	r9, #0, 30
     5fc:	5d100000 	ldcpl	0, cr0, [r0, #-0]
     600:	10000003 	andne	r0, r0, r3
     604:	000001a8 	andeq	r0, r0, r8, lsr #3
     608:	25150000 	ldrcs	r0, [r5, #-0]
     60c:	50000000 	andpl	r0, r0, r0
     610:	16000003 	strne	r0, [r0], -r3
     614:	0000005e 	andeq	r0, r0, lr, asr r0
     618:	0102000f 	tsteq	r2, pc
     61c:	0008ba02 	andeq	fp, r8, r2, lsl #20
     620:	df041700 	svcle	0x00041700
     624:	17000001 	strne	r0, [r0, -r1]
     628:	00002c04 	andeq	r2, r0, r4, lsl #24
     62c:	0d340b00 	vldmdbeq	r4!, {d0-d-1}
     630:	04170000 	ldreq	r0, [r7], #-0
     634:	00000363 	andeq	r0, r0, r3, ror #6
     638:	00028f15 	andeq	r8, r2, r5, lsl pc
     63c:	00037900 	andeq	r7, r3, r0, lsl #18
     640:	17001800 	strne	r1, [r0, -r0, lsl #16]
     644:	0001d204 	andeq	sp, r1, r4, lsl #4
     648:	cd041700 	stcgt	7, cr1, [r4, #-0]
     64c:	19000001 	stmdbne	r0, {r0}
     650:	00000abf 			; <UNDEFINED> instruction: 0x00000abf
     654:	d2149c04 	andsle	r9, r4, #4, 24	; 0x400
     658:	0a000001 	beq	664 <shift+0x664>
     65c:	00000786 	andeq	r0, r0, r6, lsl #15
     660:	59140405 	ldmdbpl	r4, {r0, r2, sl}
     664:	05000000 	streq	r0, [r0, #-0]
     668:	008e8c03 	addeq	r8, lr, r3, lsl #24
     66c:	03f70a00 	mvnseq	r0, #0, 20
     670:	07050000 	streq	r0, [r5, -r0]
     674:	00005914 	andeq	r5, r0, r4, lsl r9
     678:	90030500 	andls	r0, r3, r0, lsl #10
     67c:	0a00008e 	beq	8bc <shift+0x8bc>
     680:	00000609 	andeq	r0, r0, r9, lsl #12
     684:	59140a05 	ldmdbpl	r4, {r0, r2, r9, fp}
     688:	05000000 	streq	r0, [r0, #-0]
     68c:	008e9403 	addeq	r9, lr, r3, lsl #8
     690:	08ef0800 	stmiaeq	pc!, {fp}^	; <UNPREDICTABLE>
     694:	04050000 	streq	r0, [r5], #-0
     698:	00000038 	andeq	r0, r0, r8, lsr r0
     69c:	fe0c0d05 	vdot.bf16	d0, d12, d5[0]
     6a0:	1a000003 	bne	6b4 <shift+0x6b4>
     6a4:	0077654e 	rsbseq	r6, r7, lr, asr #10
     6a8:	08e60900 	stmiaeq	r6!, {r8, fp}^
     6ac:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     6b0:	00000acb 	andeq	r0, r0, fp, asr #21
     6b4:	08c90902 	stmiaeq	r9, {r1, r8, fp}^
     6b8:	09030000 	stmdbeq	r3, {}	; <UNPREDICTABLE>
     6bc:	0000089c 	muleq	r0, ip, r8
     6c0:	09c20904 	stmibeq	r2, {r2, r8, fp}^
     6c4:	00050000 	andeq	r0, r5, r0
     6c8:	0006ff06 	andeq	pc, r6, r6, lsl #30
     6cc:	1b051000 	blne	1446d4 <__bss_end+0x13b7b8>
     6d0:	00043d08 	andeq	r3, r4, r8, lsl #26
     6d4:	726c0700 	rsbvc	r0, ip, #0, 14
     6d8:	131d0500 	tstne	sp, #0, 10
     6dc:	0000043d 	andeq	r0, r0, sp, lsr r4
     6e0:	70730700 	rsbsvc	r0, r3, r0, lsl #14
     6e4:	131e0500 	tstne	lr, #0, 10
     6e8:	0000043d 	andeq	r0, r0, sp, lsr r4
     6ec:	63700704 	cmnvs	r0, #4, 14	; 0x100000
     6f0:	131f0500 	tstne	pc, #0, 10
     6f4:	0000043d 	andeq	r0, r0, sp, lsr r4
     6f8:	07150d08 	ldreq	r0, [r5, -r8, lsl #26]
     6fc:	20050000 	andcs	r0, r5, r0
     700:	00043d13 	andeq	r3, r4, r3, lsl sp
     704:	02000c00 	andeq	r0, r0, #0, 24
     708:	17690704 	strbne	r0, [r9, -r4, lsl #14]!
     70c:	cd060000 	stcgt	0, cr0, [r6, #-0]
     710:	70000004 	andvc	r0, r0, r4
     714:	d4082805 	strle	r2, [r8], #-2053	; 0xfffff7fb
     718:	0d000004 	stceq	0, cr0, [r0, #-16]
     71c:	00000d81 	andeq	r0, r0, r1, lsl #27
     720:	fe122a05 	vselvs.f32	s4, s4, s10
     724:	00000003 	andeq	r0, r0, r3
     728:	64697007 	strbtvs	r7, [r9], #-7
     72c:	122b0500 	eorne	r0, fp, #0, 10
     730:	0000005e 	andeq	r0, r0, lr, asr r0
     734:	15470d10 	strbne	r0, [r7, #-3344]	; 0xfffff2f0
     738:	2c050000 	stccs	0, cr0, [r5], {-0}
     73c:	0003c711 	andeq	ip, r3, r1, lsl r7
     740:	040d1400 	streq	r1, [sp], #-1024	; 0xfffffc00
     744:	05000009 	streq	r0, [r0, #-9]
     748:	005e122d 	subseq	r1, lr, sp, lsr #4
     74c:	0d180000 	ldceq	0, cr0, [r8, #-0]
     750:	00000912 	andeq	r0, r0, r2, lsl r9
     754:	5e122e05 	cdppl	14, 1, cr2, cr2, cr5, {0}
     758:	1c000000 	stcne	0, cr0, [r0], {-0}
     75c:	0006e80d 	andeq	lr, r6, sp, lsl #16
     760:	312f0500 			; <UNDEFINED> instruction: 0x312f0500
     764:	000004d4 	ldrdeq	r0, [r0], -r4
     768:	093f0d20 	ldmdbeq	pc!, {r5, r8, sl, fp}	; <UNPREDICTABLE>
     76c:	30050000 	andcc	r0, r5, r0
     770:	00003809 	andeq	r3, r0, r9, lsl #16
     774:	420d6000 	andmi	r6, sp, #0
     778:	0500000b 	streq	r0, [r0, #-11]
     77c:	004d0e31 	subeq	r0, sp, r1, lsr lr
     780:	0d640000 	stcleq	0, cr0, [r4, #-0]
     784:	0000075f 	andeq	r0, r0, pc, asr r7
     788:	4d0e3305 	stcmi	3, cr3, [lr, #-20]	; 0xffffffec
     78c:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
     790:	0007560d 	andeq	r5, r7, sp, lsl #12
     794:	0e340500 	cfabs32eq	mvfx0, mvfx4
     798:	0000004d 	andeq	r0, r0, sp, asr #32
     79c:	7f15006c 	svcvc	0x0015006c
     7a0:	e4000003 	str	r0, [r0], #-3
     7a4:	16000004 	strne	r0, [r0], -r4
     7a8:	0000005e 	andeq	r0, r0, lr, asr r0
     7ac:	e70a000f 	str	r0, [sl, -pc]
     7b0:	0600000c 	streq	r0, [r0], -ip
     7b4:	0059140a 	subseq	r1, r9, sl, lsl #8
     7b8:	03050000 	movweq	r0, #20480	; 0x5000
     7bc:	00008e98 	muleq	r0, r8, lr
     7c0:	0008d108 	andeq	sp, r8, r8, lsl #2
     7c4:	38040500 	stmdacc	r4, {r8, sl}
     7c8:	06000000 	streq	r0, [r0], -r0
     7cc:	05150c0d 	ldreq	r0, [r5, #-3085]	; 0xfffff3f3
     7d0:	b9090000 	stmdblt	r9, {}	; <UNPREDICTABLE>
     7d4:	00000005 	andeq	r0, r0, r5
     7d8:	0003ec09 	andeq	lr, r3, r9, lsl #24
     7dc:	06000100 	streq	r0, [r0], -r0, lsl #2
     7e0:	00000c0b 	andeq	r0, r0, fp, lsl #24
     7e4:	081b060c 	ldmdaeq	fp, {r2, r3, r9, sl}
     7e8:	0000054a 	andeq	r0, r0, sl, asr #10
     7ec:	00049f0d 	andeq	r9, r4, sp, lsl #30
     7f0:	191d0600 	ldmdbne	sp, {r9, sl}
     7f4:	0000054a 	andeq	r0, r0, sl, asr #10
     7f8:	05700d00 	ldrbeq	r0, [r0, #-3328]!	; 0xfffff300
     7fc:	1e060000 	cdpne	0, 0, cr0, cr6, cr0, {0}
     800:	00054a19 	andeq	r4, r5, r9, lsl sl
     804:	b60d0400 	strlt	r0, [sp], -r0, lsl #8
     808:	0600000b 	streq	r0, [r0], -fp
     80c:	0550131f 	ldrbeq	r1, [r0, #-799]	; 0xfffffce1
     810:	00080000 	andeq	r0, r8, r0
     814:	05150417 	ldreq	r0, [r5, #-1047]	; 0xfffffbe9
     818:	04170000 	ldreq	r0, [r7], #-0
     81c:	00000444 	andeq	r0, r0, r4, asr #8
     820:	00061c0c 	andeq	r1, r6, ip, lsl #24
     824:	22061400 	andcs	r1, r6, #0, 8
     828:	0007d807 	andeq	sp, r7, r7, lsl #16
     82c:	08bf0d00 	ldmeq	pc!, {r8, sl, fp}	; <UNPREDICTABLE>
     830:	26060000 	strcs	r0, [r6], -r0
     834:	00004d12 	andeq	r4, r0, r2, lsl sp
     838:	1d0d0000 	stcne	0, cr0, [sp, #-0]
     83c:	06000005 	streq	r0, [r0], -r5
     840:	054a1d29 	strbeq	r1, [sl, #-3369]	; 0xfffff2d7
     844:	0d040000 	stceq	0, cr0, [r4, #-0]
     848:	00000adc 	ldrdeq	r0, [r0], -ip
     84c:	4a1d2c06 	bmi	74b86c <__bss_end+0x742950>
     850:	08000005 	stmdaeq	r0, {r0, r2}
     854:	000cbd1b 	andeq	fp, ip, fp, lsl sp
     858:	0e2f0600 	cfmadda32eq	mvax0, mvax0, mvfx15, mvfx0
     85c:	00000be8 	andeq	r0, r0, r8, ror #23
     860:	0000059e 	muleq	r0, lr, r5
     864:	000005a9 	andeq	r0, r0, r9, lsr #11
     868:	0007dd0f 	andeq	sp, r7, pc, lsl #26
     86c:	054a1000 	strbeq	r1, [sl, #-0]
     870:	1c000000 	stcne	0, cr0, [r0], {-0}
     874:	00000bc4 	andeq	r0, r0, r4, asr #23
     878:	a40e3106 	strge	r3, [lr], #-262	; 0xfffffefa
     87c:	50000004 	andpl	r0, r0, r4
     880:	c1000003 	tstgt	r0, r3
     884:	cc000005 	stcgt	0, cr0, [r0], {5}
     888:	0f000005 	svceq	0x00000005
     88c:	000007dd 	ldrdeq	r0, [r0], -sp
     890:	00055010 	andeq	r5, r5, r0, lsl r0
     894:	1e120000 	cdpne	0, 1, cr0, cr2, cr0, {0}
     898:	0600000c 	streq	r0, [r0], -ip
     89c:	0b911d35 	bleq	fe447d78 <__bss_end+0xfe43ee5c>
     8a0:	054a0000 	strbeq	r0, [sl, #-0]
     8a4:	e5020000 	str	r0, [r2, #-0]
     8a8:	eb000005 	bl	8c4 <shift+0x8c4>
     8ac:	0f000005 	svceq	0x00000005
     8b0:	000007dd 	ldrdeq	r0, [r0], -sp
     8b4:	08531200 	ldmdaeq	r3, {r9, ip}^
     8b8:	37060000 	strcc	r0, [r6, -r0]
     8bc:	000a5c1d 	andeq	r5, sl, sp, lsl ip
     8c0:	00054a00 	andeq	r4, r5, r0, lsl #20
     8c4:	06040200 	streq	r0, [r4], -r0, lsl #4
     8c8:	060a0000 	streq	r0, [sl], -r0
     8cc:	dd0f0000 	stcle	0, cr0, [pc, #-0]	; 8d4 <shift+0x8d4>
     8d0:	00000007 	andeq	r0, r0, r7
     8d4:	0009591d 	andeq	r5, r9, sp, lsl r9
     8d8:	44390600 	ldrtmi	r0, [r9], #-1536	; 0xfffffa00
     8dc:	000007f6 	strdeq	r0, [r0], -r6
     8e0:	1c12020c 	lfmne	f0, 4, [r2], {12}
     8e4:	06000006 	streq	r0, [r0], -r6
     8e8:	0d5d093c 	vldreq.16	s1, [sp, #-120]	; 0xffffff88	; <UNPREDICTABLE>
     8ec:	07dd0000 	ldrbeq	r0, [sp, r0]
     8f0:	31010000 	mrscc	r0, (UNDEF: 1)
     8f4:	37000006 	strcc	r0, [r0, -r6]
     8f8:	0f000006 	svceq	0x00000006
     8fc:	000007dd 	ldrdeq	r0, [r0], -sp
     900:	05ce1200 	strbeq	r1, [lr, #512]	; 0x200
     904:	3f060000 	svccc	0x00060000
     908:	000c9212 	andeq	r9, ip, r2, lsl r2
     90c:	00004d00 	andeq	r4, r0, r0, lsl #26
     910:	06500100 	ldrbeq	r0, [r0], -r0, lsl #2
     914:	06650000 	strbteq	r0, [r5], -r0
     918:	dd0f0000 	stcle	0, cr0, [pc, #-0]	; 920 <shift+0x920>
     91c:	10000007 	andne	r0, r0, r7
     920:	000007ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     924:	00005e10 	andeq	r5, r0, r0, lsl lr
     928:	03501000 	cmpeq	r0, #0
     92c:	13000000 	movwne	r0, #0
     930:	00000bd3 	ldrdeq	r0, [r0], -r3
     934:	d80e4206 	stmdale	lr, {r1, r2, r9, lr}
     938:	01000009 	tsteq	r0, r9
     93c:	0000067a 	andeq	r0, r0, sl, ror r6
     940:	00000680 	andeq	r0, r0, r0, lsl #13
     944:	0007dd0f 	andeq	sp, r7, pc, lsl #26
     948:	e7120000 	ldr	r0, [r2, -r0]
     94c:	06000007 	streq	r0, [r0], -r7
     950:	053a1745 	ldreq	r1, [sl, #-1861]!	; 0xfffff8bb
     954:	05500000 	ldrbeq	r0, [r0, #-0]
     958:	99010000 	stmdbls	r1, {}	; <UNPREDICTABLE>
     95c:	9f000006 	svcls	0x00000006
     960:	0f000006 	svceq	0x00000006
     964:	00000805 	andeq	r0, r0, r5, lsl #16
     968:	05751200 	ldrbeq	r1, [r5, #-512]!	; 0xfffffe00
     96c:	48060000 	stmdami	r6, {}	; <UNPREDICTABLE>
     970:	000b4e17 	andeq	r4, fp, r7, lsl lr
     974:	00055000 	andeq	r5, r5, r0
     978:	06b80100 	ldrteq	r0, [r8], r0, lsl #2
     97c:	06c30000 	strbeq	r0, [r3], r0
     980:	050f0000 	streq	r0, [pc, #-0]	; 988 <shift+0x988>
     984:	10000008 	andne	r0, r0, r8
     988:	0000004d 	andeq	r0, r0, sp, asr #32
     98c:	0d041300 	stceq	3, cr1, [r4, #-0]
     990:	4b060000 	blmi	180998 <__bss_end+0x177a7c>
     994:	0004070e 	andeq	r0, r4, lr, lsl #14
     998:	06d80100 	ldrbeq	r0, [r8], r0, lsl #2
     99c:	06de0000 	ldrbeq	r0, [lr], r0
     9a0:	dd0f0000 	stcle	0, cr0, [pc, #-0]	; 9a8 <shift+0x9a8>
     9a4:	00000007 	andeq	r0, r0, r7
     9a8:	000bc412 	andeq	ip, fp, r2, lsl r4
     9ac:	0e4d0600 	cdpeq	6, 4, cr0, cr13, cr0, {0}
     9b0:	0000071b 	andeq	r0, r0, fp, lsl r7
     9b4:	00000350 	andeq	r0, r0, r0, asr r3
     9b8:	0006f701 	andeq	pc, r6, r1, lsl #14
     9bc:	00070200 	andeq	r0, r7, r0, lsl #4
     9c0:	07dd0f00 	ldrbeq	r0, [sp, r0, lsl #30]
     9c4:	4d100000 	ldcmi	0, cr0, [r0, #-0]
     9c8:	00000000 	andeq	r0, r0, r0
     9cc:	0007fb12 	andeq	pc, r7, r2, lsl fp	; <UNPREDICTABLE>
     9d0:	12500600 	subsne	r0, r0, #0, 12
     9d4:	000009f9 	strdeq	r0, [r0], -r9
     9d8:	0000004d 	andeq	r0, r0, sp, asr #32
     9dc:	00071b01 	andeq	r1, r7, r1, lsl #22
     9e0:	00072600 	andeq	r2, r7, r0, lsl #12
     9e4:	07dd0f00 	ldrbeq	r0, [sp, r0, lsl #30]
     9e8:	7f100000 	svcvc	0x00100000
     9ec:	00000003 	andeq	r0, r0, r3
     9f0:	00050a12 	andeq	r0, r5, r2, lsl sl
     9f4:	0e530600 	cdpeq	6, 5, cr0, cr3, cr0, {0}
     9f8:	0000079f 	muleq	r0, pc, r7	; <UNPREDICTABLE>
     9fc:	00000350 	andeq	r0, r0, r0, asr r3
     a00:	00073f01 	andeq	r3, r7, r1, lsl #30
     a04:	00074a00 	andeq	r4, r7, r0, lsl #20
     a08:	07dd0f00 	ldrbeq	r0, [sp, r0, lsl #30]
     a0c:	4d100000 	ldcmi	0, cr0, [r0, #-0]
     a10:	00000000 	andeq	r0, r0, r0
     a14:	00082d13 	andeq	r2, r8, r3, lsl sp
     a18:	0e560600 	cdpeq	6, 5, cr0, cr6, cr0, {0}
     a1c:	00000c2a 	andeq	r0, r0, sl, lsr #24
     a20:	00075f01 	andeq	r5, r7, r1, lsl #30
     a24:	00077e00 	andeq	r7, r7, r0, lsl #28
     a28:	07dd0f00 	ldrbeq	r0, [sp, r0, lsl #30]
     a2c:	8b100000 	blhi	400a34 <__bss_end+0x3f7b18>
     a30:	10000000 	andne	r0, r0, r0
     a34:	0000004d 	andeq	r0, r0, sp, asr #32
     a38:	00004d10 	andeq	r4, r0, r0, lsl sp
     a3c:	004d1000 	subeq	r1, sp, r0
     a40:	0b100000 	bleq	400a48 <__bss_end+0x3f7b2c>
     a44:	00000008 	andeq	r0, r0, r8
     a48:	000b7b13 	andeq	r7, fp, r3, lsl fp
     a4c:	0e580600 	cdpeq	6, 5, cr0, cr8, cr0, {0}
     a50:	00000690 	muleq	r0, r0, r6
     a54:	00079301 	andeq	r9, r7, r1, lsl #6
     a58:	0007b200 	andeq	fp, r7, r0, lsl #4
     a5c:	07dd0f00 	ldrbeq	r0, [sp, r0, lsl #30]
     a60:	c2100000 	andsgt	r0, r0, #0
     a64:	10000000 	andne	r0, r0, r0
     a68:	0000004d 	andeq	r0, r0, sp, asr #32
     a6c:	00004d10 	andeq	r4, r0, r0, lsl sp
     a70:	004d1000 	subeq	r1, sp, r0
     a74:	0b100000 	bleq	400a7c <__bss_end+0x3f7b60>
     a78:	00000008 	andeq	r0, r0, r8
     a7c:	0005f614 	andeq	pc, r5, r4, lsl r6	; <UNPREDICTABLE>
     a80:	0e5b0600 	cdpeq	6, 5, cr0, cr11, cr0, {0}
     a84:	0000064d 	andeq	r0, r0, sp, asr #12
     a88:	00000350 	andeq	r0, r0, r0, asr r3
     a8c:	0007c701 	andeq	ip, r7, r1, lsl #14
     a90:	07dd0f00 	ldrbeq	r0, [sp, r0, lsl #30]
     a94:	f6100000 			; <UNDEFINED> instruction: 0xf6100000
     a98:	10000004 	andne	r0, r0, r4
     a9c:	00000811 	andeq	r0, r0, r1, lsl r8
     aa0:	56030000 	strpl	r0, [r3], -r0
     aa4:	17000005 	strne	r0, [r0, -r5]
     aa8:	00055604 	andeq	r5, r5, r4, lsl #12
     aac:	054a1e00 	strbeq	r1, [sl, #-3584]	; 0xfffff200
     ab0:	07f00000 	ldrbeq	r0, [r0, r0]!
     ab4:	07f60000 	ldrbeq	r0, [r6, r0]!
     ab8:	dd0f0000 	stcle	0, cr0, [pc, #-0]	; ac0 <shift+0xac0>
     abc:	00000007 	andeq	r0, r0, r7
     ac0:	0005561f 	andeq	r5, r5, pc, lsl r6
     ac4:	0007e300 	andeq	lr, r7, r0, lsl #6
     ac8:	3f041700 	svccc	0x00041700
     acc:	17000000 	strne	r0, [r0, -r0]
     ad0:	0007d804 	andeq	sp, r7, r4, lsl #16
     ad4:	65042000 	strvs	r2, [r4, #-0]
     ad8:	21000000 	mrscs	r0, (UNDEF: 0)
     adc:	0bdc1904 	bleq	ff706ef4 <__bss_end+0xff6fdfd8>
     ae0:	5e060000 	cdppl	0, 0, cr0, cr6, cr0, {0}
     ae4:	00055619 	andeq	r5, r5, r9, lsl r6
     ae8:	04360800 	ldrteq	r0, [r6], #-2048	; 0xfffff800
     aec:	04050000 	streq	r0, [r5], #-0
     af0:	00000038 	andeq	r0, r0, r8, lsr r0
     af4:	3e0c0307 	cdpcc	3, 0, cr0, cr12, cr7, {0}
     af8:	09000008 	stmdbeq	r0, {r3}
     afc:	00000778 	andeq	r0, r0, r8, ror r7
     b00:	077f0900 	ldrbeq	r0, [pc, -r0, lsl #18]!
     b04:	00010000 	andeq	r0, r1, r0
     b08:	00076808 	andeq	r6, r7, r8, lsl #16
     b0c:	38040500 	stmdacc	r4, {r8, sl}
     b10:	07000000 	streq	r0, [r0, -r0]
     b14:	088b0c09 	stmeq	fp, {r0, r3, sl, fp}
     b18:	df220000 	svcle	0x00220000
     b1c:	b000000c 	andlt	r0, r0, ip
     b20:	04972204 	ldreq	r2, [r7], #516	; 0x204
     b24:	09600000 	stmdbeq	r0!, {}^	; <UNPREDICTABLE>
     b28:	00056822 	andeq	r6, r5, r2, lsr #16
     b2c:	2212c000 	andscs	ip, r2, #0
     b30:	00000d1a 	andeq	r0, r0, sl, lsl sp
     b34:	bb222580 	bllt	88a13c <__bss_end+0x881220>
     b38:	0000000b 	andeq	r0, r0, fp
     b3c:	08fb224b 	ldmeq	fp!, {r0, r1, r3, r6, r9, sp}^
     b40:	96000000 	strls	r0, [r0], -r0
     b44:	0003e322 	andeq	lr, r3, r2, lsr #6
     b48:	23e10000 	mvncs	r0, #0
     b4c:	0000094f 	andeq	r0, r0, pc, asr #18
     b50:	0001c200 	andeq	ip, r1, r0, lsl #4
     b54:	09a40600 	stmibeq	r4!, {r9, sl}
     b58:	07080000 	streq	r0, [r8, -r0]
     b5c:	08b30816 	ldmeq	r3!, {r1, r2, r4, fp}
     b60:	1a0d0000 	bne	340b68 <__bss_end+0x337c4c>
     b64:	0700000b 	streq	r0, [r0, -fp]
     b68:	081f1718 	ldmdaeq	pc, {r3, r4, r8, r9, sl, ip}	; <UNPREDICTABLE>
     b6c:	0d000000 	stceq	0, cr0, [r0, #-0]
     b70:	00000530 	andeq	r0, r0, r0, lsr r5
     b74:	3e151907 	vnmlscc.f16	s2, s10, s14	; <UNPREDICTABLE>
     b78:	04000008 	streq	r0, [r0], #-8
     b7c:	0d522400 	cfldrdeq	mvd2, [r2, #-0]
     b80:	16010000 	strne	r0, [r1], -r0
     b84:	00003805 	andeq	r3, r0, r5, lsl #16
     b88:	0082a800 	addeq	sl, r2, r0, lsl #16
     b8c:	0000a000 	andeq	sl, r0, r0
     b90:	1c9c0100 	ldfnes	f0, [ip], {0}
     b94:	25000009 	strcs	r0, [r0, #-9]
     b98:	00000d2f 	andeq	r0, r0, pc, lsr #26
     b9c:	380e1601 	stmdacc	lr, {r0, r9, sl, ip}
     ba0:	03000000 	movweq	r0, #0
     ba4:	257de491 	ldrbcs	lr, [sp, #-1169]!	; 0xfffffb6f
     ba8:	00000c7c 	andeq	r0, r0, ip, ror ip
     bac:	1c1b1601 	ldcne	6, cr1, [fp], {1}
     bb0:	03000009 	movweq	r0, #9
     bb4:	267de091 			; <UNDEFINED> instruction: 0x267de091
     bb8:	00000a98 	muleq	r0, r8, sl
     bbc:	4d0b1801 	stcmi	8, cr1, [fp, #-4]
     bc0:	02000000 	andeq	r0, r0, #0
     bc4:	26267491 			; <UNDEFINED> instruction: 0x26267491
     bc8:	0100000b 	tsteq	r0, fp
     bcc:	088b151a 	stmeq	fp, {r1, r3, r4, r8, sl, ip}
     bd0:	91020000 	mrsls	r0, (UNDEF: 2)
     bd4:	7473276c 	ldrbtvc	r2, [r3], #-1900	; 0xfffff894
     bd8:	20010072 	andcs	r0, r1, r2, ror r0
     bdc:	0009280a 	andeq	r2, r9, sl, lsl #16
     be0:	ec910300 	ldc	3, cr0, [r1], {0}
     be4:	0417007d 	ldreq	r0, [r7], #-125	; 0xffffff83
     be8:	00000922 	andeq	r0, r0, r2, lsr #18
     bec:	00250417 	eoreq	r0, r5, r7, lsl r4
     bf0:	25150000 	ldrcs	r0, [r5, #-0]
     bf4:	38000000 	stmdacc	r0, {}	; <UNPREDICTABLE>
     bf8:	16000009 	strne	r0, [r0], -r9
     bfc:	0000005e 	andeq	r0, r0, lr, asr r0
     c00:	492800ff 	stmdbmi	r8!, {r0, r1, r2, r3, r4, r5, r6, r7}
     c04:	01000009 	tsteq	r0, r9
     c08:	82700d12 	rsbshi	r0, r0, #1152	; 0x480
     c0c:	00380000 	eorseq	r0, r8, r0
     c10:	9c010000 	stcls	0, cr0, [r1], {-0}
     c14:	0000097c 	andeq	r0, r0, ip, ror r9
     c18:	000a9d25 	andeq	r9, sl, r5, lsr #26
     c1c:	1c120100 	ldfnes	f0, [r2], {-0}
     c20:	0000004d 	andeq	r0, r0, sp, asr #32
     c24:	29749102 	ldmdbcs	r4!, {r1, r8, ip, pc}^
     c28:	00667562 	rsbeq	r7, r6, r2, ror #10
     c2c:	22281201 	eorcs	r1, r8, #268435456	; 0x10000000
     c30:	02000009 	andeq	r0, r0, #9
     c34:	71257091 			; <UNDEFINED> instruction: 0x71257091
     c38:	01000010 	tsteq	r0, r0, lsl r0
     c3c:	00383112 	eorseq	r3, r8, r2, lsl r1
     c40:	91020000 	mrsls	r0, (UNDEF: 2)
     c44:	922a006c 	eorls	r0, sl, #108	; 0x6c
     c48:	01000009 	tsteq	r0, r9
     c4c:	82340d0d 	eorshi	r0, r4, #832	; 0x340
     c50:	003c0000 	eorseq	r0, ip, r0
     c54:	9c010000 	stcls	0, cr0, [r1], {-0}
     c58:	000a9d25 	andeq	r9, sl, r5, lsr #26
     c5c:	1c0d0100 	stfnes	f0, [sp], {-0}
     c60:	0000004d 	andeq	r0, r0, sp, asr #32
     c64:	25749102 	ldrbcs	r9, [r4, #-258]!	; 0xfffffefe
     c68:	00000490 	muleq	r0, r0, r4
     c6c:	5d2e0d01 	stcpl	13, cr0, [lr, #-4]!
     c70:	02000003 	andeq	r0, r0, #3
     c74:	00007091 	muleq	r0, r1, r0
     c78:	00000cd7 	ldrdeq	r0, [r0], -r7
     c7c:	04500004 	ldrbeq	r0, [r0], #-4
     c80:	01040000 	mrseq	r0, (UNDEF: 4)
     c84:	00000db0 			; <UNDEFINED> instruction: 0x00000db0
     c88:	000ef104 	andeq	pc, lr, r4, lsl #2
     c8c:	000fa800 	andeq	sl, pc, r0, lsl #16
     c90:	00834800 	addeq	r4, r3, r0, lsl #16
     c94:	00046000 	andeq	r6, r4, r0
     c98:	00044500 	andeq	r4, r4, r0, lsl #10
     c9c:	08010200 	stmdaeq	r1, {r9}
     ca0:	00000a57 	andeq	r0, r0, r7, asr sl
     ca4:	00002503 	andeq	r2, r0, r3, lsl #10
     ca8:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     cac:	00000a8e 	andeq	r0, r0, lr, lsl #21
     cb0:	69050404 	stmdbvs	r5, {r2, sl}
     cb4:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
     cb8:	0a4e0801 	beq	1382cc4 <__bss_end+0x1379da8>
     cbc:	02020000 	andeq	r0, r2, #0
     cc0:	00084007 	andeq	r4, r8, r7
     cc4:	0ad30500 	beq	ff4c20cc <__bss_end+0xff4b91b0>
     cc8:	09070000 	stmdbeq	r7, {}	; <UNPREDICTABLE>
     ccc:	00005e1e 	andeq	r5, r0, lr, lsl lr
     cd0:	004d0300 	subeq	r0, sp, r0, lsl #6
     cd4:	04020000 	streq	r0, [r2], #-0
     cd8:	00176e07 	andseq	r6, r7, r7, lsl #28
     cdc:	06dc0600 	ldrbeq	r0, [ip], r0, lsl #12
     ce0:	02080000 	andeq	r0, r8, #0
     ce4:	008b0806 	addeq	r0, fp, r6, lsl #16
     ce8:	72070000 	andvc	r0, r7, #0
     cec:	08020030 	stmdaeq	r2, {r4, r5}
     cf0:	00004d0e 	andeq	r4, r0, lr, lsl #26
     cf4:	72070000 	andvc	r0, r7, #0
     cf8:	09020031 	stmdbeq	r2, {r0, r4, r5}
     cfc:	00004d0e 	andeq	r4, r0, lr, lsl #26
     d00:	08000400 	stmdaeq	r0, {sl}
     d04:	000010c7 	andeq	r1, r0, r7, asr #1
     d08:	00380405 	eorseq	r0, r8, r5, lsl #8
     d0c:	0d020000 	stceq	0, cr0, [r2, #-0]
     d10:	0000a90c 	andeq	sl, r0, ip, lsl #18
     d14:	4b4f0900 	blmi	13c311c <__bss_end+0x13ba200>
     d18:	310a0000 	mrscc	r0, (UNDEF: 10)
     d1c:	0100000f 	tsteq	r0, pc
     d20:	059f0800 	ldreq	r0, [pc, #2048]	; 1528 <shift+0x1528>
     d24:	04050000 	streq	r0, [r5], #-0
     d28:	00000038 	andeq	r0, r0, r8, lsr r0
     d2c:	e00c1e02 	and	r1, ip, r2, lsl #28
     d30:	0a000000 	beq	d38 <shift+0xd38>
     d34:	00000743 	andeq	r0, r0, r3, asr #14
     d38:	0d8d0a00 	vstreq	s0, [sp]
     d3c:	0a010000 	beq	40d44 <__bss_end+0x37e28>
     d40:	00000d57 	andeq	r0, r0, r7, asr sp
     d44:	08aa0a02 	stmiaeq	sl!, {r1, r9, fp}
     d48:	0a030000 	beq	c0d50 <__bss_end+0xb7e34>
     d4c:	000009c9 	andeq	r0, r0, r9, asr #19
     d50:	070c0a04 	streq	r0, [ip, -r4, lsl #20]
     d54:	00050000 	andeq	r0, r5, r0
     d58:	000cc708 	andeq	ip, ip, r8, lsl #14
     d5c:	38040500 	stmdacc	r4, {r8, sl}
     d60:	02000000 	andeq	r0, r0, #0
     d64:	011d0c3f 	tsteq	sp, pc, lsr ip
     d68:	020a0000 	andeq	r0, sl, #0
     d6c:	00000004 	andeq	r0, r0, r4
     d70:	0005b40a 	andeq	fp, r5, sl, lsl #8
     d74:	bc0a0100 	stflts	f0, [sl], {-0}
     d78:	02000009 	andeq	r0, r0, #9
     d7c:	000d220a 	andeq	r2, sp, sl, lsl #4
     d80:	970a0300 	strls	r0, [sl, -r0, lsl #6]
     d84:	0400000d 	streq	r0, [r0], #-13
     d88:	00097d0a 	andeq	r7, r9, sl, lsl #26
     d8c:	600a0500 	andvs	r0, sl, r0, lsl #10
     d90:	06000008 	streq	r0, [r0], -r8
     d94:	0c810800 	stceq	8, cr0, [r1], {0}
     d98:	04050000 	streq	r0, [r5], #-0
     d9c:	00000038 	andeq	r0, r0, r8, lsr r0
     da0:	480c6602 	stmdami	ip, {r1, r9, sl, sp, lr}
     da4:	0a000001 	beq	db0 <shift+0xdb0>
     da8:	00000a2c 	andeq	r0, r0, ip, lsr #20
     dac:	08220a00 	stmdaeq	r2!, {r9, fp}
     db0:	0a010000 	beq	40db8 <__bss_end+0x37e9c>
     db4:	00000aa2 	andeq	r0, r0, r2, lsr #21
     db8:	08650a02 	stmdaeq	r5!, {r1, r9, fp}^
     dbc:	00030000 	andeq	r0, r3, r0
     dc0:	0009840b 	andeq	r8, r9, fp, lsl #8
     dc4:	14050300 	strne	r0, [r5], #-768	; 0xfffffd00
     dc8:	00000059 	andeq	r0, r0, r9, asr r0
     dcc:	8ec00305 	cdphi	3, 12, cr0, cr0, cr5, {0}
     dd0:	980b0000 	stmdals	fp, {}	; <UNPREDICTABLE>
     dd4:	03000009 	movweq	r0, #9
     dd8:	00591406 	subseq	r1, r9, r6, lsl #8
     ddc:	03050000 	movweq	r0, #20480	; 0x5000
     de0:	00008ec4 	andeq	r8, r0, r4, asr #29
     de4:	0009670b 	andeq	r6, r9, fp, lsl #14
     de8:	1a070400 	bne	1c1df0 <__bss_end+0x1b8ed4>
     dec:	00000059 	andeq	r0, r0, r9, asr r0
     df0:	8ec80305 	cdphi	3, 12, cr0, cr8, cr5, {0}
     df4:	e40b0000 	str	r0, [fp], #-0
     df8:	04000005 	streq	r0, [r0], #-5
     dfc:	00591a09 	subseq	r1, r9, r9, lsl #20
     e00:	03050000 	movweq	r0, #20480	; 0x5000
     e04:	00008ecc 	andeq	r8, r0, ip, asr #29
     e08:	000a400b 	andeq	r4, sl, fp
     e0c:	1a0b0400 	bne	2c1e14 <__bss_end+0x2b8ef8>
     e10:	00000059 	andeq	r0, r0, r9, asr r0
     e14:	8ed00305 	cdphi	3, 13, cr0, cr0, cr5, {0}
     e18:	0f0b0000 	svceq	0x000b0000
     e1c:	04000008 	streq	r0, [r0], #-8
     e20:	00591a0d 	subseq	r1, r9, sp, lsl #20
     e24:	03050000 	movweq	r0, #20480	; 0x5000
     e28:	00008ed4 	ldrdeq	r8, [r0], -r4
     e2c:	0006f50b 	andeq	pc, r6, fp, lsl #10
     e30:	1a0f0400 	bne	3c1e38 <__bss_end+0x3b8f1c>
     e34:	00000059 	andeq	r0, r0, r9, asr r0
     e38:	8ed80305 	cdphi	3, 13, cr0, cr8, cr5, {0}
     e3c:	0a080000 	beq	200e44 <__bss_end+0x1f7f28>
     e40:	0500000b 	streq	r0, [r0, #-11]
     e44:	00003804 	andeq	r3, r0, r4, lsl #16
     e48:	0c1b0400 	cfldrseq	mvf0, [fp], {-0}
     e4c:	000001eb 	andeq	r0, r0, fp, ror #3
     e50:	000b380a 	andeq	r3, fp, sl, lsl #16
     e54:	470a0000 	strmi	r0, [sl, -r0]
     e58:	0100000d 	tsteq	r0, sp
     e5c:	0009b70a 	andeq	fp, r9, sl, lsl #14
     e60:	0c000200 	sfmeq	f0, 4, [r0], {-0}
     e64:	00000a26 	andeq	r0, r0, r6, lsr #20
     e68:	000a820d 	andeq	r8, sl, sp, lsl #4
     e6c:	63049000 	movwvs	r9, #16384	; 0x4000
     e70:	00035e07 	andeq	r5, r3, r7, lsl #28
     e74:	0cf60600 	ldcleq	6, cr0, [r6]
     e78:	04240000 	strteq	r0, [r4], #-0
     e7c:	02781067 	rsbseq	r1, r8, #103	; 0x67
     e80:	560e0000 	strpl	r0, [lr], -r0
     e84:	0400001b 	streq	r0, [r0], #-27	; 0xffffffe5
     e88:	035e2869 	cmpeq	lr, #6881280	; 0x690000
     e8c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     e90:	00000593 	muleq	r0, r3, r5
     e94:	6e206b04 	vmulvs.f64	d6, d0, d4
     e98:	10000003 	andne	r0, r0, r3
     e9c:	000b2d0e 	andeq	r2, fp, lr, lsl #26
     ea0:	236d0400 	cmncs	sp, #0, 8
     ea4:	0000004d 	andeq	r0, r0, sp, asr #32
     ea8:	05dd0e14 	ldrbeq	r0, [sp, #3604]	; 0xe14
     eac:	70040000 	andvc	r0, r4, r0
     eb0:	0003751c 	andeq	r7, r3, ip, lsl r5
     eb4:	370e1800 	strcc	r1, [lr, -r0, lsl #16]
     eb8:	0400000a 	streq	r0, [r0], #-10
     ebc:	03751c72 	cmneq	r5, #29184	; 0x7200
     ec0:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
     ec4:	00000570 	andeq	r0, r0, r0, ror r5
     ec8:	751c7504 	ldrvc	r7, [ip, #-1284]	; 0xfffffafc
     ecc:	20000003 	andcs	r0, r0, r3
     ed0:	00074b0f 	andeq	r4, r7, pc, lsl #22
     ed4:	1c770400 	cfldrdne	mvd0, [r7], #-0
     ed8:	000004da 	ldrdeq	r0, [r0], -sl
     edc:	00000375 	andeq	r0, r0, r5, ror r3
     ee0:	0000026c 	andeq	r0, r0, ip, ror #4
     ee4:	00037510 	andeq	r7, r3, r0, lsl r5
     ee8:	037b1100 	cmneq	fp, #0, 2
     eec:	00000000 	andeq	r0, r0, r0
     ef0:	00064206 	andeq	r4, r6, r6, lsl #4
     ef4:	7b041800 	blvc	106efc <__bss_end+0xfdfe0>
     ef8:	0002ad10 	andeq	sl, r2, r0, lsl sp
     efc:	1b560e00 	blne	1584704 <__bss_end+0x157b7e8>
     f00:	7e040000 	cdpvc	0, 0, cr0, cr4, cr0, {0}
     f04:	00035e2c 	andeq	r5, r3, ip, lsr #28
     f08:	880e0000 	stmdahi	lr, {}	; <UNPREDICTABLE>
     f0c:	04000005 	streq	r0, [r0], #-5
     f10:	037b1980 	cmneq	fp, #128, 18	; 0x200000
     f14:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
     f18:	00000d28 	andeq	r0, r0, r8, lsr #26
     f1c:	86218204 	strthi	r8, [r1], -r4, lsl #4
     f20:	14000003 	strne	r0, [r0], #-3
     f24:	02780300 	rsbseq	r0, r8, #0, 6
     f28:	33120000 	tstcc	r2, #0
     f2c:	04000009 	streq	r0, [r0], #-9
     f30:	038c2186 	orreq	r2, ip, #-2147483615	; 0x80000021
     f34:	cb120000 	blgt	480f3c <__bss_end+0x478020>
     f38:	04000007 	streq	r0, [r0], #-7
     f3c:	00591f88 	subseq	r1, r9, r8, lsl #31
     f40:	b90e0000 	stmdblt	lr, {}	; <UNPREDICTABLE>
     f44:	0400000a 	streq	r0, [r0], #-10
     f48:	01fd178b 	mvnseq	r1, fp, lsl #15
     f4c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     f50:	000008b0 			; <UNDEFINED> instruction: 0x000008b0
     f54:	fd178e04 	ldc2	14, cr8, [r7, #-16]
     f58:	24000001 	strcs	r0, [r0], #-1
     f5c:	0007dd0e 	andeq	sp, r7, lr, lsl #26
     f60:	178f0400 	strne	r0, [pc, r0, lsl #8]
     f64:	000001fd 	strdeq	r0, [r0], -sp
     f68:	0d770e48 	ldcleq	14, cr0, [r7, #-288]!	; 0xfffffee0
     f6c:	90040000 	andls	r0, r4, r0
     f70:	0001fd17 	andeq	pc, r1, r7, lsl sp	; <UNPREDICTABLE>
     f74:	82136c00 	andshi	r6, r3, #0, 24
     f78:	0400000a 	streq	r0, [r0], #-10
     f7c:	062d0993 			; <UNDEFINED> instruction: 0x062d0993
     f80:	03970000 	orrseq	r0, r7, #0
     f84:	17010000 	strne	r0, [r1, -r0]
     f88:	1d000003 	stcne	0, cr0, [r0, #-12]
     f8c:	10000003 	andne	r0, r0, r3
     f90:	00000397 	muleq	r0, r7, r3
     f94:	09281400 	stmdbeq	r8!, {sl, ip}
     f98:	96040000 	strls	r0, [r4], -r0
     f9c:	00087d0e 	andeq	r7, r8, lr, lsl #26
     fa0:	03320100 	teqeq	r2, #0, 2
     fa4:	03380000 	teqeq	r8, #0
     fa8:	97100000 	ldrls	r0, [r0, -r0]
     fac:	00000003 	andeq	r0, r0, r3
     fb0:	00040215 	andeq	r0, r4, r5, lsl r2
     fb4:	10990400 	addsne	r0, r9, r0, lsl #8
     fb8:	00000aef 	andeq	r0, r0, pc, ror #21
     fbc:	0000039d 	muleq	r0, sp, r3
     fc0:	00034d01 	andeq	r4, r3, r1, lsl #26
     fc4:	03971000 	orrseq	r1, r7, #0
     fc8:	7b110000 	blvc	440fd0 <__bss_end+0x4380b4>
     fcc:	11000003 	tstne	r0, r3
     fd0:	000001c6 	andeq	r0, r0, r6, asr #3
     fd4:	25160000 	ldrcs	r0, [r6, #-0]
     fd8:	6e000000 	cdpvs	0, 0, cr0, cr0, cr0, {0}
     fdc:	17000003 	strne	r0, [r0, -r3]
     fe0:	0000005e 	andeq	r0, r0, lr, asr r0
     fe4:	0102000f 	tsteq	r2, pc
     fe8:	0008ba02 	andeq	fp, r8, r2, lsl #20
     fec:	fd041800 	stc2	8, cr1, [r4, #-0]
     ff0:	18000001 	stmdane	r0, {r0}
     ff4:	00002c04 	andeq	r2, r0, r4, lsl #24
     ff8:	0d340c00 	ldceq	12, cr0, [r4, #-0]
     ffc:	04180000 	ldreq	r0, [r8], #-0
    1000:	00000381 	andeq	r0, r0, r1, lsl #7
    1004:	0002ad16 	andeq	sl, r2, r6, lsl sp
    1008:	00039700 	andeq	r9, r3, r0, lsl #14
    100c:	18001900 	stmdane	r0, {r8, fp, ip}
    1010:	0001f004 	andeq	pc, r1, r4
    1014:	eb041800 	bl	10701c <__bss_end+0xfe100>
    1018:	1a000001 	bne	1024 <shift+0x1024>
    101c:	00000abf 			; <UNDEFINED> instruction: 0x00000abf
    1020:	f0149c04 			; <UNDEFINED> instruction: 0xf0149c04
    1024:	0b000001 	bleq	1030 <shift+0x1030>
    1028:	00000786 	andeq	r0, r0, r6, lsl #15
    102c:	59140405 	ldmdbpl	r4, {r0, r2, sl}
    1030:	05000000 	streq	r0, [r0, #-0]
    1034:	008edc03 	addeq	sp, lr, r3, lsl #24
    1038:	03f70b00 	mvnseq	r0, #0, 22
    103c:	07050000 	streq	r0, [r5, -r0]
    1040:	00005914 	andeq	r5, r0, r4, lsl r9
    1044:	e0030500 	and	r0, r3, r0, lsl #10
    1048:	0b00008e 	bleq	1288 <shift+0x1288>
    104c:	00000609 	andeq	r0, r0, r9, lsl #12
    1050:	59140a05 	ldmdbpl	r4, {r0, r2, r9, fp}
    1054:	05000000 	streq	r0, [r0, #-0]
    1058:	008ee403 	addeq	lr, lr, r3, lsl #8
    105c:	08ef0800 	stmiaeq	pc!, {fp}^	; <UNPREDICTABLE>
    1060:	04050000 	streq	r0, [r5], #-0
    1064:	00000038 	andeq	r0, r0, r8, lsr r0
    1068:	1c0c0d05 	stcne	13, cr0, [ip], {5}
    106c:	09000004 	stmdbeq	r0, {r2}
    1070:	0077654e 	rsbseq	r6, r7, lr, asr #10
    1074:	08e60a00 	stmiaeq	r6!, {r9, fp}^
    1078:	0a010000 	beq	41080 <__bss_end+0x38164>
    107c:	00000acb 	andeq	r0, r0, fp, asr #21
    1080:	08c90a02 	stmiaeq	r9, {r1, r9, fp}^
    1084:	0a030000 	beq	c108c <__bss_end+0xb8170>
    1088:	0000089c 	muleq	r0, ip, r8
    108c:	09c20a04 	stmibeq	r2, {r2, r9, fp}^
    1090:	00050000 	andeq	r0, r5, r0
    1094:	0006ff06 	andeq	pc, r6, r6, lsl #30
    1098:	1b051000 	blne	1450a0 <__bss_end+0x13c184>
    109c:	00045b08 	andeq	r5, r4, r8, lsl #22
    10a0:	726c0700 	rsbvc	r0, ip, #0, 14
    10a4:	131d0500 	tstne	sp, #0, 10
    10a8:	0000045b 	andeq	r0, r0, fp, asr r4
    10ac:	70730700 	rsbsvc	r0, r3, r0, lsl #14
    10b0:	131e0500 	tstne	lr, #0, 10
    10b4:	0000045b 	andeq	r0, r0, fp, asr r4
    10b8:	63700704 	cmnvs	r0, #4, 14	; 0x100000
    10bc:	131f0500 	tstne	pc, #0, 10
    10c0:	0000045b 	andeq	r0, r0, fp, asr r4
    10c4:	07150e08 	ldreq	r0, [r5, -r8, lsl #28]
    10c8:	20050000 	andcs	r0, r5, r0
    10cc:	00045b13 	andeq	r5, r4, r3, lsl fp
    10d0:	02000c00 	andeq	r0, r0, #0, 24
    10d4:	17690704 	strbne	r0, [r9, -r4, lsl #14]!
    10d8:	cd060000 	stcgt	0, cr0, [r6, #-0]
    10dc:	70000004 	andvc	r0, r0, r4
    10e0:	f2082805 	vadd.i8	d2, d8, d5
    10e4:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
    10e8:	00000d81 	andeq	r0, r0, r1, lsl #27
    10ec:	1c122a05 			; <UNDEFINED> instruction: 0x1c122a05
    10f0:	00000004 	andeq	r0, r0, r4
    10f4:	64697007 	strbtvs	r7, [r9], #-7
    10f8:	122b0500 	eorne	r0, fp, #0, 10
    10fc:	0000005e 	andeq	r0, r0, lr, asr r0
    1100:	15470e10 	strbne	r0, [r7, #-3600]	; 0xfffff1f0
    1104:	2c050000 	stccs	0, cr0, [r5], {-0}
    1108:	0003e511 	andeq	lr, r3, r1, lsl r5
    110c:	040e1400 	streq	r1, [lr], #-1024	; 0xfffffc00
    1110:	05000009 	streq	r0, [r0, #-9]
    1114:	005e122d 	subseq	r1, lr, sp, lsr #4
    1118:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
    111c:	00000912 	andeq	r0, r0, r2, lsl r9
    1120:	5e122e05 	cdppl	14, 1, cr2, cr2, cr5, {0}
    1124:	1c000000 	stcne	0, cr0, [r0], {-0}
    1128:	0006e80e 	andeq	lr, r6, lr, lsl #16
    112c:	312f0500 			; <UNDEFINED> instruction: 0x312f0500
    1130:	000004f2 	strdeq	r0, [r0], -r2
    1134:	093f0e20 	ldmdbeq	pc!, {r5, r9, sl, fp}	; <UNPREDICTABLE>
    1138:	30050000 	andcc	r0, r5, r0
    113c:	00003809 	andeq	r3, r0, r9, lsl #16
    1140:	420e6000 	andmi	r6, lr, #0
    1144:	0500000b 	streq	r0, [r0, #-11]
    1148:	004d0e31 	subeq	r0, sp, r1, lsr lr
    114c:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
    1150:	0000075f 	andeq	r0, r0, pc, asr r7
    1154:	4d0e3305 	stcmi	3, cr3, [lr, #-20]	; 0xffffffec
    1158:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
    115c:	0007560e 	andeq	r5, r7, lr, lsl #12
    1160:	0e340500 	cfabs32eq	mvfx0, mvfx4
    1164:	0000004d 	andeq	r0, r0, sp, asr #32
    1168:	9d16006c 	ldcls	0, cr0, [r6, #-432]	; 0xfffffe50
    116c:	02000003 	andeq	r0, r0, #3
    1170:	17000005 	strne	r0, [r0, -r5]
    1174:	0000005e 	andeq	r0, r0, lr, asr r0
    1178:	e70b000f 	str	r0, [fp, -pc]
    117c:	0600000c 	streq	r0, [r0], -ip
    1180:	0059140a 	subseq	r1, r9, sl, lsl #8
    1184:	03050000 	movweq	r0, #20480	; 0x5000
    1188:	00008ee8 	andeq	r8, r0, r8, ror #29
    118c:	0008d108 	andeq	sp, r8, r8, lsl #2
    1190:	38040500 	stmdacc	r4, {r8, sl}
    1194:	06000000 	streq	r0, [r0], -r0
    1198:	05330c0d 	ldreq	r0, [r3, #-3085]!	; 0xfffff3f3
    119c:	b90a0000 	stmdblt	sl, {}	; <UNPREDICTABLE>
    11a0:	00000005 	andeq	r0, r0, r5
    11a4:	0003ec0a 	andeq	lr, r3, sl, lsl #24
    11a8:	03000100 	movweq	r0, #256	; 0x100
    11ac:	00000514 	andeq	r0, r0, r4, lsl r5
    11b0:	00101a08 	andseq	r1, r0, r8, lsl #20
    11b4:	38040500 	stmdacc	r4, {r8, sl}
    11b8:	06000000 	streq	r0, [r0], -r0
    11bc:	05570c14 	ldrbeq	r0, [r7, #-3092]	; 0xfffff3ec
    11c0:	a30a0000 	movwge	r0, #40960	; 0xa000
    11c4:	0000000d 	andeq	r0, r0, sp
    11c8:	0010990a 	andseq	r9, r0, sl, lsl #18
    11cc:	03000100 	movweq	r0, #256	; 0x100
    11d0:	00000538 	andeq	r0, r0, r8, lsr r5
    11d4:	000c0b06 	andeq	r0, ip, r6, lsl #22
    11d8:	1b060c00 	blne	1841e0 <__bss_end+0x17b2c4>
    11dc:	00059108 	andeq	r9, r5, r8, lsl #2
    11e0:	049f0e00 	ldreq	r0, [pc], #3584	; 11e8 <shift+0x11e8>
    11e4:	1d060000 	stcne	0, cr0, [r6, #-0]
    11e8:	00059119 	andeq	r9, r5, r9, lsl r1
    11ec:	700e0000 	andvc	r0, lr, r0
    11f0:	06000005 	streq	r0, [r0], -r5
    11f4:	0591191e 	ldreq	r1, [r1, #2334]	; 0x91e
    11f8:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
    11fc:	00000bb6 			; <UNDEFINED> instruction: 0x00000bb6
    1200:	97131f06 	ldrls	r1, [r3, -r6, lsl #30]
    1204:	08000005 	stmdaeq	r0, {r0, r2}
    1208:	5c041800 	stcpl	8, cr1, [r4], {-0}
    120c:	18000005 	stmdane	r0, {r0, r2}
    1210:	00046204 	andeq	r6, r4, r4, lsl #4
    1214:	061c0d00 	ldreq	r0, [ip], -r0, lsl #26
    1218:	06140000 	ldreq	r0, [r4], -r0
    121c:	081f0722 	ldmdaeq	pc, {r1, r5, r8, r9, sl}	; <UNPREDICTABLE>
    1220:	bf0e0000 	svclt	0x000e0000
    1224:	06000008 	streq	r0, [r0], -r8
    1228:	004d1226 	subeq	r1, sp, r6, lsr #4
    122c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1230:	0000051d 	andeq	r0, r0, sp, lsl r5
    1234:	911d2906 	tstls	sp, r6, lsl #18
    1238:	04000005 	streq	r0, [r0], #-5
    123c:	000adc0e 	andeq	sp, sl, lr, lsl #24
    1240:	1d2c0600 	stcne	6, cr0, [ip, #-0]
    1244:	00000591 	muleq	r0, r1, r5
    1248:	0cbd1b08 	vpopeq	{d1-d4}
    124c:	2f060000 	svccs	0x00060000
    1250:	000be80e 	andeq	lr, fp, lr, lsl #16
    1254:	0005e500 	andeq	lr, r5, r0, lsl #10
    1258:	0005f000 	andeq	pc, r5, r0
    125c:	08241000 	stmdaeq	r4!, {ip}
    1260:	91110000 	tstls	r1, r0
    1264:	00000005 	andeq	r0, r0, r5
    1268:	000bc41c 	andeq	ip, fp, ip, lsl r4
    126c:	0e310600 	cfmsuba32eq	mvax0, mvax0, mvfx1, mvfx0
    1270:	000004a4 	andeq	r0, r0, r4, lsr #9
    1274:	0000036e 	andeq	r0, r0, lr, ror #6
    1278:	00000608 	andeq	r0, r0, r8, lsl #12
    127c:	00000613 	andeq	r0, r0, r3, lsl r6
    1280:	00082410 	andeq	r2, r8, r0, lsl r4
    1284:	05971100 	ldreq	r1, [r7, #256]	; 0x100
    1288:	13000000 	movwne	r0, #0
    128c:	00000c1e 	andeq	r0, r0, lr, lsl ip
    1290:	911d3506 	tstls	sp, r6, lsl #10
    1294:	9100000b 	tstls	r0, fp
    1298:	02000005 	andeq	r0, r0, #5
    129c:	0000062c 	andeq	r0, r0, ip, lsr #12
    12a0:	00000632 	andeq	r0, r0, r2, lsr r6
    12a4:	00082410 	andeq	r2, r8, r0, lsl r4
    12a8:	53130000 	tstpl	r3, #0
    12ac:	06000008 	streq	r0, [r0], -r8
    12b0:	0a5c1d37 	beq	1708794 <__bss_end+0x16ff878>
    12b4:	05910000 	ldreq	r0, [r1]
    12b8:	4b020000 	blmi	812c0 <__bss_end+0x783a4>
    12bc:	51000006 	tstpl	r0, r6
    12c0:	10000006 	andne	r0, r0, r6
    12c4:	00000824 	andeq	r0, r0, r4, lsr #16
    12c8:	09591d00 	ldmdbeq	r9, {r8, sl, fp, ip}^
    12cc:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
    12d0:	00083d44 	andeq	r3, r8, r4, asr #26
    12d4:	13020c00 	movwne	r0, #11264	; 0x2c00
    12d8:	0000061c 	andeq	r0, r0, ip, lsl r6
    12dc:	5d093c06 	stcpl	12, cr3, [r9, #-24]	; 0xffffffe8
    12e0:	2400000d 	strcs	r0, [r0], #-13
    12e4:	01000008 	tsteq	r0, r8
    12e8:	00000678 	andeq	r0, r0, r8, ror r6
    12ec:	0000067e 	andeq	r0, r0, lr, ror r6
    12f0:	00082410 	andeq	r2, r8, r0, lsl r4
    12f4:	ce130000 	cdpgt	0, 1, cr0, cr3, cr0, {0}
    12f8:	06000005 	streq	r0, [r0], -r5
    12fc:	0c92123f 	lfmeq	f1, 4, [r2], {63}	; 0x3f
    1300:	004d0000 	subeq	r0, sp, r0
    1304:	97010000 	strls	r0, [r1, -r0]
    1308:	ac000006 	stcge	0, cr0, [r0], {6}
    130c:	10000006 	andne	r0, r0, r6
    1310:	00000824 	andeq	r0, r0, r4, lsr #16
    1314:	00084611 	andeq	r4, r8, r1, lsl r6
    1318:	005e1100 	subseq	r1, lr, r0, lsl #2
    131c:	6e110000 	cdpvs	0, 1, cr0, cr1, cr0, {0}
    1320:	00000003 	andeq	r0, r0, r3
    1324:	000bd314 	andeq	sp, fp, r4, lsl r3
    1328:	0e420600 	cdpeq	6, 4, cr0, cr2, cr0, {0}
    132c:	000009d8 	ldrdeq	r0, [r0], -r8
    1330:	0006c101 	andeq	ip, r6, r1, lsl #2
    1334:	0006c700 	andeq	ip, r6, r0, lsl #14
    1338:	08241000 	stmdaeq	r4!, {ip}
    133c:	13000000 	movwne	r0, #0
    1340:	000007e7 	andeq	r0, r0, r7, ror #15
    1344:	3a174506 	bcc	5d2764 <__bss_end+0x5c9848>
    1348:	97000005 	strls	r0, [r0, -r5]
    134c:	01000005 	tsteq	r0, r5
    1350:	000006e0 	andeq	r0, r0, r0, ror #13
    1354:	000006e6 	andeq	r0, r0, r6, ror #13
    1358:	00084c10 	andeq	r4, r8, r0, lsl ip
    135c:	75130000 	ldrvc	r0, [r3, #-0]
    1360:	06000005 	streq	r0, [r0], -r5
    1364:	0b4e1748 	bleq	138708c <__bss_end+0x137e170>
    1368:	05970000 	ldreq	r0, [r7]
    136c:	ff010000 			; <UNDEFINED> instruction: 0xff010000
    1370:	0a000006 	beq	1390 <shift+0x1390>
    1374:	10000007 	andne	r0, r0, r7
    1378:	0000084c 	andeq	r0, r0, ip, asr #16
    137c:	00004d11 	andeq	r4, r0, r1, lsl sp
    1380:	04140000 	ldreq	r0, [r4], #-0
    1384:	0600000d 	streq	r0, [r0], -sp
    1388:	04070e4b 	streq	r0, [r7], #-3659	; 0xfffff1b5
    138c:	1f010000 	svcne	0x00010000
    1390:	25000007 	strcs	r0, [r0, #-7]
    1394:	10000007 	andne	r0, r0, r7
    1398:	00000824 	andeq	r0, r0, r4, lsr #16
    139c:	0bc41300 	bleq	ff105fa4 <__bss_end+0xff0fd088>
    13a0:	4d060000 	stcmi	0, cr0, [r6, #-0]
    13a4:	00071b0e 	andeq	r1, r7, lr, lsl #22
    13a8:	00036e00 	andeq	r6, r3, r0, lsl #28
    13ac:	073e0100 	ldreq	r0, [lr, -r0, lsl #2]!
    13b0:	07490000 	strbeq	r0, [r9, -r0]
    13b4:	24100000 	ldrcs	r0, [r0], #-0
    13b8:	11000008 	tstne	r0, r8
    13bc:	0000004d 	andeq	r0, r0, sp, asr #32
    13c0:	07fb1300 	ldrbeq	r1, [fp, r0, lsl #6]!
    13c4:	50060000 	andpl	r0, r6, r0
    13c8:	0009f912 	andeq	pc, r9, r2, lsl r9	; <UNPREDICTABLE>
    13cc:	00004d00 	andeq	r4, r0, r0, lsl #26
    13d0:	07620100 	strbeq	r0, [r2, -r0, lsl #2]!
    13d4:	076d0000 	strbeq	r0, [sp, -r0]!
    13d8:	24100000 	ldrcs	r0, [r0], #-0
    13dc:	11000008 	tstne	r0, r8
    13e0:	0000039d 	muleq	r0, sp, r3
    13e4:	050a1300 	streq	r1, [sl, #-768]	; 0xfffffd00
    13e8:	53060000 	movwpl	r0, #24576	; 0x6000
    13ec:	00079f0e 	andeq	r9, r7, lr, lsl #30
    13f0:	00036e00 	andeq	r6, r3, r0, lsl #28
    13f4:	07860100 	streq	r0, [r6, r0, lsl #2]
    13f8:	07910000 	ldreq	r0, [r1, r0]
    13fc:	24100000 	ldrcs	r0, [r0], #-0
    1400:	11000008 	tstne	r0, r8
    1404:	0000004d 	andeq	r0, r0, sp, asr #32
    1408:	082d1400 	stmdaeq	sp!, {sl, ip}
    140c:	56060000 	strpl	r0, [r6], -r0
    1410:	000c2a0e 	andeq	r2, ip, lr, lsl #20
    1414:	07a60100 	streq	r0, [r6, r0, lsl #2]!
    1418:	07c50000 	strbeq	r0, [r5, r0]
    141c:	24100000 	ldrcs	r0, [r0], #-0
    1420:	11000008 	tstne	r0, r8
    1424:	000000a9 	andeq	r0, r0, r9, lsr #1
    1428:	00004d11 	andeq	r4, r0, r1, lsl sp
    142c:	004d1100 	subeq	r1, sp, r0, lsl #2
    1430:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1434:	11000000 	mrsne	r0, (UNDEF: 0)
    1438:	00000852 	andeq	r0, r0, r2, asr r8
    143c:	0b7b1400 	bleq	1ec6444 <__bss_end+0x1ebd528>
    1440:	58060000 	stmdapl	r6, {}	; <UNPREDICTABLE>
    1444:	0006900e 	andeq	r9, r6, lr
    1448:	07da0100 	ldrbeq	r0, [sl, r0, lsl #2]
    144c:	07f90000 	ldrbeq	r0, [r9, r0]!
    1450:	24100000 	ldrcs	r0, [r0], #-0
    1454:	11000008 	tstne	r0, r8
    1458:	000000e0 	andeq	r0, r0, r0, ror #1
    145c:	00004d11 	andeq	r4, r0, r1, lsl sp
    1460:	004d1100 	subeq	r1, sp, r0, lsl #2
    1464:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1468:	11000000 	mrsne	r0, (UNDEF: 0)
    146c:	00000852 	andeq	r0, r0, r2, asr r8
    1470:	05f61500 	ldrbeq	r1, [r6, #1280]!	; 0x500
    1474:	5b060000 	blpl	18147c <__bss_end+0x178560>
    1478:	00064d0e 	andeq	r4, r6, lr, lsl #26
    147c:	00036e00 	andeq	r6, r3, r0, lsl #28
    1480:	080e0100 	stmdaeq	lr, {r8}
    1484:	24100000 	ldrcs	r0, [r0], #-0
    1488:	11000008 	tstne	r0, r8
    148c:	00000514 	andeq	r0, r0, r4, lsl r5
    1490:	00085811 	andeq	r5, r8, r1, lsl r8
    1494:	03000000 	movweq	r0, #0
    1498:	0000059d 	muleq	r0, sp, r5
    149c:	059d0418 	ldreq	r0, [sp, #1048]	; 0x418
    14a0:	911e0000 	tstls	lr, r0
    14a4:	37000005 	strcc	r0, [r0, -r5]
    14a8:	3d000008 	stccc	0, cr0, [r0, #-32]	; 0xffffffe0
    14ac:	10000008 	andne	r0, r0, r8
    14b0:	00000824 	andeq	r0, r0, r4, lsr #16
    14b4:	059d1f00 	ldreq	r1, [sp, #3840]	; 0xf00
    14b8:	082a0000 	stmdaeq	sl!, {}	; <UNPREDICTABLE>
    14bc:	04180000 	ldreq	r0, [r8], #-0
    14c0:	0000003f 	andeq	r0, r0, pc, lsr r0
    14c4:	081f0418 	ldmdaeq	pc, {r3, r4, sl}	; <UNPREDICTABLE>
    14c8:	04200000 	strteq	r0, [r0], #-0
    14cc:	00000065 	andeq	r0, r0, r5, rrx
    14d0:	dc1a0421 	cfldrsle	mvf0, [sl], {33}	; 0x21
    14d4:	0600000b 	streq	r0, [r0], -fp
    14d8:	059d195e 	ldreq	r1, [sp, #2398]	; 0x95e
    14dc:	2c160000 	ldccs	0, cr0, [r6], {-0}
    14e0:	76000000 	strvc	r0, [r0], -r0
    14e4:	17000008 	strne	r0, [r0, -r8]
    14e8:	0000005e 	andeq	r0, r0, lr, asr r0
    14ec:	66030009 	strvs	r0, [r3], -r9
    14f0:	22000008 	andcs	r0, r0, #8
    14f4:	00000f7d 	andeq	r0, r0, sp, ror pc
    14f8:	760ca401 	strvc	sl, [ip], -r1, lsl #8
    14fc:	05000008 	streq	r0, [r0, #-8]
    1500:	008eec03 	addeq	lr, lr, r3, lsl #24
    1504:	0e9f2300 	cdpeq	3, 9, cr2, cr15, cr0, {0}
    1508:	a6010000 	strge	r0, [r1], -r0
    150c:	00100e0a 	andseq	r0, r0, sl, lsl #28
    1510:	00004d00 	andeq	r4, r0, r0, lsl #26
    1514:	0086f400 	addeq	pc, r6, r0, lsl #8
    1518:	0000b400 	andeq	fp, r0, r0, lsl #8
    151c:	eb9c0100 	bl	fe701924 <__bss_end+0xfe6f8a08>
    1520:	24000008 	strcs	r0, [r0], #-8
    1524:	00001b56 	andeq	r1, r0, r6, asr fp
    1528:	7b1ba601 	blvc	6ead34 <__bss_end+0x6e1e18>
    152c:	03000003 	movweq	r0, #3
    1530:	247fac91 	ldrbtcs	sl, [pc], #-3217	; 1538 <shift+0x1538>
    1534:	0000106d 	andeq	r1, r0, sp, rrx
    1538:	4d2aa601 	stcmi	6, cr10, [sl, #-4]!
    153c:	03000000 	movweq	r0, #0
    1540:	227fa891 	rsbscs	sl, pc, #9502720	; 0x910000
    1544:	00000ff6 	strdeq	r0, [r0], -r6
    1548:	eb0aa801 	bl	2ab554 <__bss_end+0x2a2638>
    154c:	03000008 	movweq	r0, #8
    1550:	227fb491 	rsbscs	fp, pc, #-1862270976	; 0x91000000
    1554:	00000e9a 	muleq	r0, sl, lr
    1558:	3809ac01 	stmdacc	r9, {r0, sl, fp, sp, pc}
    155c:	02000000 	andeq	r0, r0, #0
    1560:	16007491 			; <UNDEFINED> instruction: 0x16007491
    1564:	00000025 	andeq	r0, r0, r5, lsr #32
    1568:	000008fb 	strdeq	r0, [r0], -fp
    156c:	00005e17 	andeq	r5, r0, r7, lsl lr
    1570:	25003f00 	strcs	r3, [r0, #-3840]	; 0xfffff100
    1574:	00001052 	andeq	r1, r0, r2, asr r0
    1578:	a70a9801 	strge	r9, [sl, -r1, lsl #16]
    157c:	4d000010 	stcmi	0, cr0, [r0, #-64]	; 0xffffffc0
    1580:	b8000000 	stmdalt	r0, {}	; <UNPREDICTABLE>
    1584:	3c000086 	stccc	0, cr0, [r0], {134}	; 0x86
    1588:	01000000 	mrseq	r0, (UNDEF: 0)
    158c:	0009389c 	muleq	r9, ip, r8
    1590:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1594:	9a010071 	bls	41760 <__bss_end+0x38844>
    1598:	00055720 	andeq	r5, r5, r0, lsr #14
    159c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    15a0:	00100322 	andseq	r0, r0, r2, lsr #6
    15a4:	0e9b0100 	fmleqe	f0, f3, f0
    15a8:	0000004d 	andeq	r0, r0, sp, asr #32
    15ac:	00709102 	rsbseq	r9, r0, r2, lsl #2
    15b0:	00107c27 	andseq	r7, r0, r7, lsr #24
    15b4:	068f0100 	streq	r0, [pc], r0, lsl #2
    15b8:	00000ebb 			; <UNDEFINED> instruction: 0x00000ebb
    15bc:	0000867c 	andeq	r8, r0, ip, ror r6
    15c0:	0000003c 	andeq	r0, r0, ip, lsr r0
    15c4:	09719c01 	ldmdbeq	r1!, {r0, sl, fp, ip, pc}^
    15c8:	69240000 	stmdbvs	r4!, {}	; <UNPREDICTABLE>
    15cc:	0100000f 	tsteq	r0, pc
    15d0:	004d218f 	subeq	r2, sp, pc, lsl #3
    15d4:	91020000 	mrsls	r0, (UNDEF: 2)
    15d8:	6572266c 	ldrbvs	r2, [r2, #-1644]!	; 0xfffff994
    15dc:	91010071 	tstls	r1, r1, ror r0
    15e0:	00055720 	andeq	r5, r5, r0, lsr #14
    15e4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    15e8:	102f2500 	eorne	r2, pc, r0, lsl #10
    15ec:	83010000 	movwhi	r0, #4096	; 0x1000
    15f0:	000f8e0a 	andeq	r8, pc, sl, lsl #28
    15f4:	00004d00 	andeq	r4, r0, r0, lsl #26
    15f8:	00864000 	addeq	r4, r6, r0
    15fc:	00003c00 	andeq	r3, r0, r0, lsl #24
    1600:	ae9c0100 	fmlgee	f0, f4, f0
    1604:	26000009 	strcs	r0, [r0], -r9
    1608:	00716572 	rsbseq	r6, r1, r2, ror r5
    160c:	33208501 			; <UNDEFINED> instruction: 0x33208501
    1610:	02000005 	andeq	r0, r0, #5
    1614:	93227491 			; <UNDEFINED> instruction: 0x93227491
    1618:	0100000e 	tsteq	r0, lr
    161c:	004d0e86 	subeq	r0, sp, r6, lsl #29
    1620:	91020000 	mrsls	r0, (UNDEF: 2)
    1624:	3e250070 	mcrcc	0, 1, r0, cr5, cr0, {3}
    1628:	01000011 	tsteq	r0, r1, lsl r0
    162c:	0f3f0a77 	svceq	0x003f0a77
    1630:	004d0000 	subeq	r0, sp, r0
    1634:	86040000 	strhi	r0, [r4], -r0
    1638:	003c0000 	eorseq	r0, ip, r0
    163c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1640:	000009eb 	andeq	r0, r0, fp, ror #19
    1644:	71657226 	cmnvc	r5, r6, lsr #4
    1648:	20790100 	rsbscs	r0, r9, r0, lsl #2
    164c:	00000533 	andeq	r0, r0, r3, lsr r5
    1650:	22749102 	rsbscs	r9, r4, #-2147483648	; 0x80000000
    1654:	00000e93 	muleq	r0, r3, lr
    1658:	4d0e7a01 	vstrmi	s14, [lr, #-4]
    165c:	02000000 	andeq	r0, r0, #0
    1660:	25007091 	strcs	r7, [r0, #-145]	; 0xffffff6f
    1664:	00000fa2 	andeq	r0, r0, r2, lsr #31
    1668:	8e066b01 	vmlahi.f64	d6, d6, d1
    166c:	6e000010 	mcrvs	0, 0, r0, cr0, cr0, {0}
    1670:	b0000003 	andlt	r0, r0, r3
    1674:	54000085 	strpl	r0, [r0], #-133	; 0xffffff7b
    1678:	01000000 	mrseq	r0, (UNDEF: 0)
    167c:	000a379c 	muleq	sl, ip, r7
    1680:	10032400 	andne	r2, r3, r0, lsl #8
    1684:	6b010000 	blvs	4168c <__bss_end+0x38770>
    1688:	00004d15 	andeq	r4, r0, r5, lsl sp
    168c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1690:	00075624 	andeq	r5, r7, r4, lsr #12
    1694:	256b0100 	strbcs	r0, [fp, #-256]!	; 0xffffff00
    1698:	0000004d 	andeq	r0, r0, sp, asr #32
    169c:	22689102 	rsbcs	r9, r8, #-2147483648	; 0x80000000
    16a0:	00001136 	andeq	r1, r0, r6, lsr r1
    16a4:	4d0e6d01 	stcmi	13, cr6, [lr, #-4]
    16a8:	02000000 	andeq	r0, r0, #0
    16ac:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    16b0:	00000ed2 	ldrdeq	r0, [r0], -r2
    16b4:	de125e01 	cdple	14, 1, cr5, cr2, cr1, {0}
    16b8:	8b000010 	blhi	1700 <shift+0x1700>
    16bc:	60000000 	andvs	r0, r0, r0
    16c0:	50000085 	andpl	r0, r0, r5, lsl #1
    16c4:	01000000 	mrseq	r0, (UNDEF: 0)
    16c8:	000a929c 	muleq	sl, ip, r2
    16cc:	0a9d2400 	beq	fe74a6d4 <__bss_end+0xfe7417b8>
    16d0:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    16d4:	00004d20 	andeq	r4, r0, r0, lsr #26
    16d8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    16dc:	00103824 	andseq	r3, r0, r4, lsr #16
    16e0:	2f5e0100 	svccs	0x005e0100
    16e4:	0000004d 	andeq	r0, r0, sp, asr #32
    16e8:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    16ec:	00000756 	andeq	r0, r0, r6, asr r7
    16f0:	4d3f5e01 	ldcmi	14, cr5, [pc, #-4]!	; 16f4 <shift+0x16f4>
    16f4:	02000000 	andeq	r0, r0, #0
    16f8:	36226491 			; <UNDEFINED> instruction: 0x36226491
    16fc:	01000011 	tsteq	r0, r1, lsl r0
    1700:	008b1660 	addeq	r1, fp, r0, ror #12
    1704:	91020000 	mrsls	r0, (UNDEF: 2)
    1708:	fc250074 	stc2	0, cr0, [r5], #-464	; 0xfffffe30
    170c:	0100000f 	tsteq	r0, pc
    1710:	0ed70a52 			; <UNDEFINED> instruction: 0x0ed70a52
    1714:	004d0000 	subeq	r0, sp, r0
    1718:	851c0000 	ldrhi	r0, [ip, #-0]
    171c:	00440000 	subeq	r0, r4, r0
    1720:	9c010000 	stcls	0, cr0, [r1], {-0}
    1724:	00000ade 	ldrdeq	r0, [r0], -lr
    1728:	000a9d24 	andeq	r9, sl, r4, lsr #26
    172c:	1a520100 	bne	1481b34 <__bss_end+0x1478c18>
    1730:	0000004d 	andeq	r0, r0, sp, asr #32
    1734:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1738:	00001038 	andeq	r1, r0, r8, lsr r0
    173c:	4d295201 	sfmmi	f5, 4, [r9, #-4]!
    1740:	02000000 	andeq	r0, r0, #0
    1744:	0d226891 	stceq	8, cr6, [r2, #-580]!	; 0xfffffdbc
    1748:	01000011 	tsteq	r0, r1, lsl r0
    174c:	004d0e54 	subeq	r0, sp, r4, asr lr
    1750:	91020000 	mrsls	r0, (UNDEF: 2)
    1754:	07250074 			; <UNDEFINED> instruction: 0x07250074
    1758:	01000011 	tsteq	r0, r1, lsl r0
    175c:	10e90a45 	rscne	r0, r9, r5, asr #20
    1760:	004d0000 	subeq	r0, sp, r0
    1764:	84cc0000 	strbhi	r0, [ip], #0
    1768:	00500000 	subseq	r0, r0, r0
    176c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1770:	00000b39 	andeq	r0, r0, r9, lsr fp
    1774:	000a9d24 	andeq	r9, sl, r4, lsr #26
    1778:	19450100 	stmdbne	r5, {r8}^
    177c:	0000004d 	andeq	r0, r0, sp, asr #32
    1780:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1784:	00000fd7 	ldrdeq	r0, [r0], -r7
    1788:	1d304501 	cfldr32ne	mvfx4, [r0, #-4]!
    178c:	02000001 	andeq	r0, r0, #1
    1790:	3e246891 	mcrcc	8, 1, r6, cr4, cr1, {4}
    1794:	01000010 	tsteq	r0, r0, lsl r0
    1798:	08584145 	ldmdaeq	r8, {r0, r2, r6, r8, lr}^
    179c:	91020000 	mrsls	r0, (UNDEF: 2)
    17a0:	11362264 	teqne	r6, r4, ror #4
    17a4:	47010000 	strmi	r0, [r1, -r0]
    17a8:	00004d0e 	andeq	r4, r0, lr, lsl #26
    17ac:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    17b0:	0d9d2700 	ldceq	7, cr2, [sp]
    17b4:	3f010000 	svccc	0x00010000
    17b8:	000fe106 	andeq	lr, pc, r6, lsl #2
    17bc:	0084a000 	addeq	sl, r4, r0
    17c0:	00002c00 	andeq	r2, r0, r0, lsl #24
    17c4:	639c0100 	orrsvs	r0, ip, #0, 2
    17c8:	2400000b 	strcs	r0, [r0], #-11
    17cc:	00000a9d 	muleq	r0, sp, sl
    17d0:	4d153f01 	ldcmi	15, cr3, [r5, #-4]
    17d4:	02000000 	andeq	r0, r0, #0
    17d8:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    17dc:	00001076 	andeq	r1, r0, r6, ror r0
    17e0:	440a3201 	strmi	r3, [sl], #-513	; 0xfffffdff
    17e4:	4d000010 	stcmi	0, cr0, [r0, #-64]	; 0xffffffc0
    17e8:	50000000 	andpl	r0, r0, r0
    17ec:	50000084 	andpl	r0, r0, r4, lsl #1
    17f0:	01000000 	mrseq	r0, (UNDEF: 0)
    17f4:	000bbe9c 	muleq	fp, ip, lr
    17f8:	0a9d2400 	beq	fe74a800 <__bss_end+0xfe7418e4>
    17fc:	32010000 	andcc	r0, r1, #0
    1800:	00004d19 	andeq	r4, r0, r9, lsl sp
    1804:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1808:	00112324 	andseq	r2, r1, r4, lsr #6
    180c:	2b320100 	blcs	c81c14 <__bss_end+0xc78cf8>
    1810:	0000037b 	andeq	r0, r0, fp, ror r3
    1814:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1818:	00001071 	andeq	r1, r0, r1, ror r0
    181c:	4d3c3201 	lfmmi	f3, 4, [ip, #-4]!
    1820:	02000000 	andeq	r0, r0, #0
    1824:	d8226491 	stmdale	r2!, {r0, r4, r7, sl, sp, lr}
    1828:	01000010 	tsteq	r0, r0, lsl r0
    182c:	004d0e34 	subeq	r0, sp, r4, lsr lr
    1830:	91020000 	mrsls	r0, (UNDEF: 2)
    1834:	60250074 	eorvs	r0, r5, r4, ror r0
    1838:	01000011 	tsteq	r0, r1, lsl r0
    183c:	112a0a25 			; <UNDEFINED> instruction: 0x112a0a25
    1840:	004d0000 	subeq	r0, sp, r0
    1844:	84000000 	strhi	r0, [r0], #-0
    1848:	00500000 	subseq	r0, r0, r0
    184c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1850:	00000c19 	andeq	r0, r0, r9, lsl ip
    1854:	000a9d24 	andeq	r9, sl, r4, lsr #26
    1858:	18250100 	stmdane	r5!, {r8}
    185c:	0000004d 	andeq	r0, r0, sp, asr #32
    1860:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1864:	00001123 	andeq	r1, r0, r3, lsr #2
    1868:	1f2a2501 	svcne	0x002a2501
    186c:	0200000c 	andeq	r0, r0, #12
    1870:	71246891 			; <UNDEFINED> instruction: 0x71246891
    1874:	01000010 	tsteq	r0, r0, lsl r0
    1878:	004d3b25 	subeq	r3, sp, r5, lsr #22
    187c:	91020000 	mrsls	r0, (UNDEF: 2)
    1880:	0ea42264 	cdpeq	2, 10, cr2, cr4, cr4, {3}
    1884:	27010000 	strcs	r0, [r1, -r0]
    1888:	00004d0e 	andeq	r4, r0, lr, lsl #26
    188c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1890:	25041800 	strcs	r1, [r4, #-2048]	; 0xfffff800
    1894:	03000000 	movweq	r0, #0
    1898:	00000c19 	andeq	r0, r0, r9, lsl ip
    189c:	00100925 	andseq	r0, r0, r5, lsr #18
    18a0:	0a190100 	beq	641ca8 <__bss_end+0x638d8c>
    18a4:	0000116c 	andeq	r1, r0, ip, ror #2
    18a8:	0000004d 	andeq	r0, r0, sp, asr #32
    18ac:	000083bc 			; <UNDEFINED> instruction: 0x000083bc
    18b0:	00000044 	andeq	r0, r0, r4, asr #32
    18b4:	0c709c01 	ldcleq	12, cr9, [r0], #-4
    18b8:	57240000 	strpl	r0, [r4, -r0]!
    18bc:	01000011 	tsteq	r0, r1, lsl r0
    18c0:	037b1b19 	cmneq	fp, #25600	; 0x6400
    18c4:	91020000 	mrsls	r0, (UNDEF: 2)
    18c8:	111e246c 	tstne	lr, ip, ror #8
    18cc:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    18d0:	0001c635 	andeq	ip, r1, r5, lsr r6
    18d4:	68910200 	ldmvs	r1, {r9}
    18d8:	000a9d22 	andeq	r9, sl, r2, lsr #26
    18dc:	0e1b0100 	mufeqe	f0, f3, f0
    18e0:	0000004d 	andeq	r0, r0, sp, asr #32
    18e4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    18e8:	000f5d28 	andeq	r5, pc, r8, lsr #26
    18ec:	06140100 	ldreq	r0, [r4], -r0, lsl #2
    18f0:	00000eaa 	andeq	r0, r0, sl, lsr #29
    18f4:	000083a0 	andeq	r8, r0, r0, lsr #7
    18f8:	0000001c 	andeq	r0, r0, ip, lsl r0
    18fc:	14279c01 	strtne	r9, [r7], #-3073	; 0xfffff3ff
    1900:	01000011 	tsteq	r0, r1, lsl r0
    1904:	0ee3060e 	cdpeq	6, 14, cr0, cr3, cr14, {0}
    1908:	83740000 	cmnhi	r4, #0
    190c:	002c0000 	eoreq	r0, ip, r0
    1910:	9c010000 	stcls	0, cr0, [r1], {-0}
    1914:	00000cb0 			; <UNDEFINED> instruction: 0x00000cb0
    1918:	000f3624 	andeq	r3, pc, r4, lsr #12
    191c:	140e0100 	strne	r0, [lr], #-256	; 0xffffff00
    1920:	00000038 	andeq	r0, r0, r8, lsr r0
    1924:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1928:	00116529 	andseq	r6, r1, r9, lsr #10
    192c:	0a040100 	beq	101d34 <__bss_end+0xf8e18>
    1930:	00000feb 	andeq	r0, r0, fp, ror #31
    1934:	0000004d 	andeq	r0, r0, sp, asr #32
    1938:	00008348 	andeq	r8, r0, r8, asr #6
    193c:	0000002c 	andeq	r0, r0, ip, lsr #32
    1940:	70269c01 	eorvc	r9, r6, r1, lsl #24
    1944:	01006469 	tsteq	r0, r9, ror #8
    1948:	004d0e06 	subeq	r0, sp, r6, lsl #28
    194c:	91020000 	mrsls	r0, (UNDEF: 2)
    1950:	2e000074 	mcrcs	0, 0, r0, cr0, cr4, {3}
    1954:	04000003 	streq	r0, [r0], #-3
    1958:	0006fb00 	andeq	pc, r6, r0, lsl #22
    195c:	b0010400 	andlt	r0, r1, r0, lsl #8
    1960:	0400000d 	streq	r0, [r0], #-13
    1964:	000011a5 	andeq	r1, r0, r5, lsr #3
    1968:	00000fa8 	andeq	r0, r0, r8, lsr #31
    196c:	000087a8 	andeq	r8, r0, r8, lsr #15
    1970:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
    1974:	000006ec 	andeq	r0, r0, ip, ror #13
    1978:	00004902 	andeq	r4, r0, r2, lsl #18
    197c:	11e70300 	mvnne	r0, r0, lsl #6
    1980:	05010000 	streq	r0, [r1, #-0]
    1984:	00006110 	andeq	r6, r0, r0, lsl r1
    1988:	31301100 	teqcc	r0, r0, lsl #2
    198c:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
    1990:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
    1994:	44434241 	strbmi	r4, [r3], #-577	; 0xfffffdbf
    1998:	00004645 	andeq	r4, r0, r5, asr #12
    199c:	01030104 	tsteq	r3, r4, lsl #2
    19a0:	00000025 	andeq	r0, r0, r5, lsr #32
    19a4:	00007405 	andeq	r7, r0, r5, lsl #8
    19a8:	00006100 	andeq	r6, r0, r0, lsl #2
    19ac:	00660600 	rsbeq	r0, r6, r0, lsl #12
    19b0:	00100000 	andseq	r0, r0, r0
    19b4:	00005107 	andeq	r5, r0, r7, lsl #2
    19b8:	07040800 	streq	r0, [r4, -r0, lsl #16]
    19bc:	0000176e 	andeq	r1, r0, lr, ror #14
    19c0:	57080108 	strpl	r0, [r8, -r8, lsl #2]
    19c4:	0700000a 	streq	r0, [r0, -sl]
    19c8:	0000006d 	andeq	r0, r0, sp, rrx
    19cc:	00002a09 	andeq	r2, r0, r9, lsl #20
    19d0:	12160a00 	andsne	r0, r6, #0, 20
    19d4:	64010000 	strvs	r0, [r1], #-0
    19d8:	00120106 	andseq	r0, r2, r6, lsl #2
    19dc:	008be000 	addeq	lr, fp, r0
    19e0:	00008000 	andeq	r8, r0, r0
    19e4:	fb9c0100 	blx	fe701dee <__bss_end+0xfe6f8ed2>
    19e8:	0b000000 	bleq	19f0 <shift+0x19f0>
    19ec:	00637273 	rsbeq	r7, r3, r3, ror r2
    19f0:	fb196401 	blx	65a9fe <__bss_end+0x651ae2>
    19f4:	02000000 	andeq	r0, r0, #0
    19f8:	640b6491 	strvs	r6, [fp], #-1169	; 0xfffffb6f
    19fc:	01007473 	tsteq	r0, r3, ror r4
    1a00:	01022464 	tsteq	r2, r4, ror #8
    1a04:	91020000 	mrsls	r0, (UNDEF: 2)
    1a08:	756e0b60 	strbvc	r0, [lr, #-2912]!	; 0xfffff4a0
    1a0c:	6401006d 	strvs	r0, [r1], #-109	; 0xffffff93
    1a10:	0001042d 	andeq	r0, r1, sp, lsr #8
    1a14:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1a18:	00127b0c 	andseq	r7, r2, ip, lsl #22
    1a1c:	0e660100 	poweqs	f0, f6, f0
    1a20:	0000010b 	andeq	r0, r0, fp, lsl #2
    1a24:	0c709102 	ldfeqp	f1, [r0], #-8
    1a28:	000011f3 	strdeq	r1, [r0], -r3
    1a2c:	11086701 	tstne	r8, r1, lsl #14
    1a30:	02000001 	andeq	r0, r0, #1
    1a34:	080d6c91 	stmdaeq	sp, {r0, r4, r7, sl, fp, sp, lr}
    1a38:	4800008c 	stmdami	r0, {r2, r3, r7}
    1a3c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1a40:	69010069 	stmdbvs	r1, {r0, r3, r5, r6}
    1a44:	0001040b 	andeq	r0, r1, fp, lsl #8
    1a48:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1a4c:	040f0000 	streq	r0, [pc], #-0	; 1a54 <shift+0x1a54>
    1a50:	00000101 	andeq	r0, r0, r1, lsl #2
    1a54:	12041110 	andne	r1, r4, #16, 2
    1a58:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    1a5c:	040f0074 	streq	r0, [pc], #-116	; 1a64 <shift+0x1a64>
    1a60:	00000074 	andeq	r0, r0, r4, ror r0
    1a64:	006d040f 	rsbeq	r0, sp, pc, lsl #8
    1a68:	930a0000 	movwls	r0, #40960	; 0xa000
    1a6c:	01000011 	tsteq	r0, r1, lsl r0
    1a70:	1199065c 	orrsne	r0, r9, ip, asr r6
    1a74:	8b780000 	blhi	1e01a7c <__bss_end+0x1df8b60>
    1a78:	00680000 	rsbeq	r0, r8, r0
    1a7c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1a80:	00000176 	andeq	r0, r0, r6, ror r1
    1a84:	00127413 	andseq	r7, r2, r3, lsl r4
    1a88:	125c0100 	subsne	r0, ip, #0, 2
    1a8c:	00000102 	andeq	r0, r0, r2, lsl #2
    1a90:	136c9102 	cmnne	ip, #-2147483648	; 0x80000000
    1a94:	00000b1f 	andeq	r0, r0, pc, lsl fp
    1a98:	041e5c01 	ldreq	r5, [lr], #-3073	; 0xfffff3ff
    1a9c:	02000001 	andeq	r0, r0, #1
    1aa0:	6d0e6891 	stcvs	8, cr6, [lr, #-580]	; 0xfffffdbc
    1aa4:	01006d65 	tsteq	r0, r5, ror #26
    1aa8:	0111085e 	tsteq	r1, lr, asr r8
    1aac:	91020000 	mrsls	r0, (UNDEF: 2)
    1ab0:	8b940d70 	blhi	fe505078 <__bss_end+0xfe4fc15c>
    1ab4:	003c0000 	eorseq	r0, ip, r0
    1ab8:	690e0000 	stmdbvs	lr, {}	; <UNPREDICTABLE>
    1abc:	0b600100 	bleq	1801ec4 <__bss_end+0x17f8fa8>
    1ac0:	00000104 	andeq	r0, r0, r4, lsl #2
    1ac4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1ac8:	121d1400 	andsne	r1, sp, #0, 8
    1acc:	52010000 	andpl	r0, r1, #0
    1ad0:	00123605 	andseq	r3, r2, r5, lsl #12
    1ad4:	00010400 	andeq	r0, r1, r0, lsl #8
    1ad8:	008b2400 	addeq	r2, fp, r0, lsl #8
    1adc:	00005400 	andeq	r5, r0, r0, lsl #8
    1ae0:	af9c0100 	svcge	0x009c0100
    1ae4:	0b000001 	bleq	1af0 <shift+0x1af0>
    1ae8:	52010073 	andpl	r0, r1, #115	; 0x73
    1aec:	00010b18 	andeq	r0, r1, r8, lsl fp
    1af0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1af4:	0100690e 	tsteq	r0, lr, lsl #18
    1af8:	01040654 	tsteq	r4, r4, asr r6
    1afc:	91020000 	mrsls	r0, (UNDEF: 2)
    1b00:	64140074 	ldrvs	r0, [r4], #-116	; 0xffffff8c
    1b04:	01000012 	tsteq	r0, r2, lsl r0
    1b08:	12240542 	eorne	r0, r4, #276824064	; 0x10800000
    1b0c:	01040000 	mrseq	r0, (UNDEF: 4)
    1b10:	8a780000 	bhi	1e01b18 <__bss_end+0x1df8bfc>
    1b14:	00ac0000 	adceq	r0, ip, r0
    1b18:	9c010000 	stcls	0, cr0, [r1], {-0}
    1b1c:	00000215 	andeq	r0, r0, r5, lsl r2
    1b20:	0031730b 	eorseq	r7, r1, fp, lsl #6
    1b24:	0b194201 	bleq	652330 <__bss_end+0x649414>
    1b28:	02000001 	andeq	r0, r0, #1
    1b2c:	730b6c91 	movwvc	r6, #48273	; 0xbc91
    1b30:	42010032 	andmi	r0, r1, #50	; 0x32
    1b34:	00010b29 	andeq	r0, r1, r9, lsr #22
    1b38:	68910200 	ldmvs	r1, {r9}
    1b3c:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    1b40:	31420100 	mrscc	r0, (UNDEF: 82)
    1b44:	00000104 	andeq	r0, r0, r4, lsl #2
    1b48:	0e649102 	lgneqs	f1, f2
    1b4c:	01003175 	tsteq	r0, r5, ror r1
    1b50:	02151044 	andseq	r1, r5, #68	; 0x44
    1b54:	91020000 	mrsls	r0, (UNDEF: 2)
    1b58:	32750e77 	rsbscc	r0, r5, #1904	; 0x770
    1b5c:	14440100 	strbne	r0, [r4], #-256	; 0xffffff00
    1b60:	00000215 	andeq	r0, r0, r5, lsl r2
    1b64:	00769102 	rsbseq	r9, r6, r2, lsl #2
    1b68:	4e080108 	adfmie	f0, f0, #0.0
    1b6c:	1400000a 	strne	r0, [r0], #-10
    1b70:	0000126c 	andeq	r1, r0, ip, ror #4
    1b74:	53073601 	movwpl	r3, #30209	; 0x7601
    1b78:	11000012 	tstne	r0, r2, lsl r0
    1b7c:	b8000001 	stmdalt	r0, {r0}
    1b80:	c0000089 	andgt	r0, r0, r9, lsl #1
    1b84:	01000000 	mrseq	r0, (UNDEF: 0)
    1b88:	0002759c 	muleq	r2, ip, r5
    1b8c:	118e1300 	orrne	r1, lr, r0, lsl #6
    1b90:	36010000 	strcc	r0, [r1], -r0
    1b94:	00011115 	andeq	r1, r1, r5, lsl r1
    1b98:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1b9c:	6372730b 	cmnvs	r2, #738197504	; 0x2c000000
    1ba0:	27360100 	ldrcs	r0, [r6, -r0, lsl #2]!
    1ba4:	0000010b 	andeq	r0, r0, fp, lsl #2
    1ba8:	0b689102 	bleq	1a25fb8 <__bss_end+0x1a1d09c>
    1bac:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1bb0:	04303601 	ldrteq	r3, [r0], #-1537	; 0xfffff9ff
    1bb4:	02000001 	andeq	r0, r0, #1
    1bb8:	690e6491 	stmdbvs	lr, {r0, r4, r7, sl, sp, lr}
    1bbc:	06380100 	ldrteq	r0, [r8], -r0, lsl #2
    1bc0:	00000104 	andeq	r0, r0, r4, lsl #2
    1bc4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1bc8:	00124314 	andseq	r4, r2, r4, lsl r3
    1bcc:	05240100 	streq	r0, [r4, #-256]!	; 0xffffff00
    1bd0:	00001248 	andeq	r1, r0, r8, asr #4
    1bd4:	00000104 	andeq	r0, r0, r4, lsl #2
    1bd8:	0000891c 	andeq	r8, r0, ip, lsl r9
    1bdc:	0000009c 	muleq	r0, ip, r0
    1be0:	02b29c01 	adcseq	r9, r2, #256	; 0x100
    1be4:	88130000 	ldmdahi	r3, {}	; <UNPREDICTABLE>
    1be8:	01000011 	tsteq	r0, r1, lsl r0
    1bec:	010b1624 	tsteq	fp, r4, lsr #12
    1bf0:	91020000 	mrsls	r0, (UNDEF: 2)
    1bf4:	11fa0c6c 	mvnsne	r0, ip, ror #24
    1bf8:	26010000 	strcs	r0, [r1], -r0
    1bfc:	00010406 	andeq	r0, r1, r6, lsl #8
    1c00:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1c04:	12821500 	addne	r1, r2, #0, 10
    1c08:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1c0c:	00128706 	andseq	r8, r2, r6, lsl #14
    1c10:	0087a800 	addeq	sl, r7, r0, lsl #16
    1c14:	00017400 	andeq	r7, r1, r0, lsl #8
    1c18:	139c0100 	orrsne	r0, ip, #0, 2
    1c1c:	00001188 	andeq	r1, r0, r8, lsl #3
    1c20:	66180801 	ldrvs	r0, [r8], -r1, lsl #16
    1c24:	02000000 	andeq	r0, r0, #0
    1c28:	fa136491 	blx	4dae74 <__bss_end+0x4d1f58>
    1c2c:	01000011 	tsteq	r0, r1, lsl r0
    1c30:	01112508 	tsteq	r1, r8, lsl #10
    1c34:	91020000 	mrsls	r0, (UNDEF: 2)
    1c38:	12111360 	andsne	r1, r1, #96, 6	; 0x80000001
    1c3c:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1c40:	0000663a 	andeq	r6, r0, sl, lsr r6
    1c44:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1c48:	0100690e 	tsteq	r0, lr, lsl #18
    1c4c:	0104060a 	tsteq	r4, sl, lsl #12
    1c50:	91020000 	mrsls	r0, (UNDEF: 2)
    1c54:	88740d74 	ldmdahi	r4!, {r2, r4, r5, r6, r8, sl, fp}^
    1c58:	00980000 	addseq	r0, r8, r0
    1c5c:	6a0e0000 	bvs	381c64 <__bss_end+0x378d48>
    1c60:	0b1c0100 	bleq	702068 <__bss_end+0x6f914c>
    1c64:	00000104 	andeq	r0, r0, r4, lsl #2
    1c68:	0d709102 	ldfeqp	f1, [r0, #-8]!
    1c6c:	0000889c 	muleq	r0, ip, r8
    1c70:	00000060 	andeq	r0, r0, r0, rrx
    1c74:	0100630e 	tsteq	r0, lr, lsl #6
    1c78:	006d081e 	rsbeq	r0, sp, lr, lsl r8
    1c7c:	91020000 	mrsls	r0, (UNDEF: 2)
    1c80:	0000006f 	andeq	r0, r0, pc, rrx
    1c84:	00002200 	andeq	r2, r0, r0, lsl #4
    1c88:	22000200 	andcs	r0, r0, #0, 4
    1c8c:	04000008 	streq	r0, [r0], #-8
    1c90:	00092201 	andeq	r2, r9, r1, lsl #4
    1c94:	008c6000 	addeq	r6, ip, r0
    1c98:	008e6c00 	addeq	r6, lr, r0, lsl #24
    1c9c:	00129300 	andseq	r9, r2, r0, lsl #6
    1ca0:	0012c300 	andseq	ip, r2, r0, lsl #6
    1ca4:	00132800 	andseq	r2, r3, r0, lsl #16
    1ca8:	22800100 	addcs	r0, r0, #0, 2
    1cac:	02000000 	andeq	r0, r0, #0
    1cb0:	00083600 	andeq	r3, r8, r0, lsl #12
    1cb4:	9f010400 	svcls	0x00010400
    1cb8:	6c000009 	stcvs	0, cr0, [r0], {9}
    1cbc:	7000008e 	andvc	r0, r0, lr, lsl #1
    1cc0:	9300008e 	movwls	r0, #142	; 0x8e
    1cc4:	c3000012 	movwgt	r0, #18
    1cc8:	28000012 	stmdacs	r0, {r1, r4}
    1ccc:	01000013 	tsteq	r0, r3, lsl r0
    1cd0:	000a0980 	andeq	r0, sl, r0, lsl #19
    1cd4:	4a000400 	bmi	2cdc <shift+0x2cdc>
    1cd8:	04000008 	streq	r0, [r0], #-8
    1cdc:	0023c801 	eoreq	ip, r3, r1, lsl #16
    1ce0:	160a0c00 	strne	r0, [sl], -r0, lsl #24
    1ce4:	12c30000 	sbcne	r0, r3, #0
    1ce8:	09ff0000 	ldmibeq	pc!, {}^	; <UNPREDICTABLE>
    1cec:	04020000 	streq	r0, [r2], #-0
    1cf0:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1cf4:	07040300 	streq	r0, [r4, -r0, lsl #6]
    1cf8:	0000176e 	andeq	r1, r0, lr, ror #14
    1cfc:	5f050803 	svcpl	0x00050803
    1d00:	03000003 	movweq	r0, #3
    1d04:	1f0f0408 	svcne	0x000f0408
    1d08:	77040000 	strvc	r0, [r4, -r0]
    1d0c:	01000016 	tsteq	r0, r6, lsl r0
    1d10:	0024162a 	eoreq	r1, r4, sl, lsr #12
    1d14:	da040000 	ble	101d1c <__bss_end+0xf8e00>
    1d18:	0100001a 	tsteq	r0, sl, lsl r0
    1d1c:	0051152f 	subseq	r1, r1, pc, lsr #10
    1d20:	04050000 	streq	r0, [r5], #-0
    1d24:	00000057 	andeq	r0, r0, r7, asr r0
    1d28:	00003906 	andeq	r3, r0, r6, lsl #18
    1d2c:	00006600 	andeq	r6, r0, r0, lsl #12
    1d30:	00660700 	rsbeq	r0, r6, r0, lsl #14
    1d34:	05000000 	streq	r0, [r0, #-0]
    1d38:	00006c04 	andeq	r6, r0, r4, lsl #24
    1d3c:	79040800 	stmdbvc	r4, {fp}
    1d40:	01000023 	tsteq	r0, r3, lsr #32
    1d44:	00790f36 	rsbseq	r0, r9, r6, lsr pc
    1d48:	04050000 	streq	r0, [r5], #-0
    1d4c:	0000007f 	andeq	r0, r0, pc, ror r0
    1d50:	00001d06 	andeq	r1, r0, r6, lsl #26
    1d54:	00009300 	andeq	r9, r0, r0, lsl #6
    1d58:	00660700 	rsbeq	r0, r6, r0, lsl #14
    1d5c:	66070000 	strvs	r0, [r7], -r0
    1d60:	00000000 	andeq	r0, r0, r0
    1d64:	4e080103 	adfmie	f0, f0, f3
    1d68:	0900000a 	stmdbeq	r0, {r1, r3}
    1d6c:	00001d3d 	andeq	r1, r0, sp, lsr sp
    1d70:	4512bb01 	ldrmi	fp, [r2, #-2817]	; 0xfffff4ff
    1d74:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    1d78:	000023a7 	andeq	r2, r0, r7, lsr #7
    1d7c:	6d10be01 	ldcvs	14, cr11, [r0, #-4]
    1d80:	03000000 	movweq	r0, #0
    1d84:	0a500601 	beq	1403590 <__bss_end+0x13fa674>
    1d88:	e10a0000 	mrs	r0, (UNDEF: 10)
    1d8c:	07000019 	smladeq	r0, r9, r0, r0
    1d90:	00009301 	andeq	r9, r0, r1, lsl #6
    1d94:	06170200 	ldreq	r0, [r7], -r0, lsl #4
    1d98:	000001e6 	andeq	r0, r0, r6, ror #3
    1d9c:	0014de0b 	andseq	sp, r4, fp, lsl #28
    1da0:	d90b0000 	stmdble	fp, {}	; <UNPREDICTABLE>
    1da4:	01000018 	tsteq	r0, r8, lsl r0
    1da8:	001e350b 	andseq	r3, lr, fp, lsl #10
    1dac:	bd0b0200 	sfmlt	f0, 4, [fp, #-0]
    1db0:	03000022 	movweq	r0, #34	; 0x22
    1db4:	001dc10b 	andseq	ip, sp, fp, lsl #2
    1db8:	840b0400 	strhi	r0, [fp], #-1024	; 0xfffffc00
    1dbc:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    1dc0:	0020aa0b 	eoreq	sl, r0, fp, lsl #20
    1dc4:	ff0b0600 			; <UNDEFINED> instruction: 0xff0b0600
    1dc8:	07000014 	smladeq	r0, r4, r0, r0
    1dcc:	0021990b 	eoreq	r9, r1, fp, lsl #18
    1dd0:	a70b0800 	strge	r0, [fp, -r0, lsl #16]
    1dd4:	09000021 	stmdbeq	r0, {r0, r5}
    1dd8:	0022980b 	eoreq	r9, r2, fp, lsl #16
    1ddc:	030b0a00 	movweq	r0, #47616	; 0xba00
    1de0:	0b00001d 	bleq	1e5c <shift+0x1e5c>
    1de4:	0016b80b 	andseq	fp, r6, fp, lsl #16
    1de8:	6a0b0c00 	bvs	2c4df0 <__bss_end+0x2bbed4>
    1dec:	0d00001a 	stceq	0, cr0, [r0, #-104]	; 0xffffff98
    1df0:	0021f00b 	eoreq	pc, r1, fp
    1df4:	250b0e00 	strcs	r0, [fp, #-3584]	; 0xfffff200
    1df8:	0f00001a 	svceq	0x0000001a
    1dfc:	001a3b0b 	andseq	r3, sl, fp, lsl #22
    1e00:	100b1000 	andne	r1, fp, r0
    1e04:	11000019 	tstne	r0, r9, lsl r0
    1e08:	001da50b 	andseq	sl, sp, fp, lsl #10
    1e0c:	9d0b1200 	sfmls	f1, 4, [fp, #-0]
    1e10:	13000019 	movwne	r0, #25
    1e14:	0026550b 	eoreq	r5, r6, fp, lsl #10
    1e18:	6d0b1400 	cfstrsvs	mvf1, [fp, #-0]
    1e1c:	1500001e 	strne	r0, [r0, #-30]	; 0xffffffe2
    1e20:	001bca0b 	andseq	ip, fp, fp, lsl #20
    1e24:	5c0b1600 	stcpl	6, cr1, [fp], {-0}
    1e28:	17000015 	smladne	r0, r5, r0, r0
    1e2c:	0022e00b 	eoreq	lr, r2, fp
    1e30:	ea0b1800 	b	2c7e38 <__bss_end+0x2bef1c>
    1e34:	19000024 	stmdbne	r0, {r2, r5}
    1e38:	0022ee0b 	eoreq	lr, r2, fp, lsl #28
    1e3c:	ed0b1a00 	vstr	s2, [fp, #-0]
    1e40:	1b000019 	blne	1eac <shift+0x1eac>
    1e44:	0022fc0b 	eoreq	pc, r2, fp, lsl #24
    1e48:	b80b1c00 	stmdalt	fp, {sl, fp, ip}
    1e4c:	1d000013 	stcne	0, cr0, [r0, #-76]	; 0xffffffb4
    1e50:	00230a0b 	eoreq	r0, r3, fp, lsl #20
    1e54:	180b1e00 	stmdane	fp, {r9, sl, fp, ip}
    1e58:	1f000023 	svcne	0x00000023
    1e5c:	0013510b 	andseq	r5, r3, fp, lsl #2
    1e60:	900b2000 	andls	r2, fp, r0
    1e64:	2100001f 	tstcs	r0, pc, lsl r0
    1e68:	001d770b 	andseq	r7, sp, fp, lsl #14
    1e6c:	d30b2200 	movwle	r2, #45568	; 0xb200
    1e70:	23000022 	movwcs	r0, #34	; 0x22
    1e74:	001c470b 	andseq	r4, ip, fp, lsl #14
    1e78:	9b0b2400 	blls	2cae80 <__bss_end+0x2c1f64>
    1e7c:	25000020 	strcs	r0, [r0, #-32]	; 0xffffffe0
    1e80:	001b3d0b 	andseq	r3, fp, fp, lsl #26
    1e84:	190b2600 	stmdbne	fp, {r9, sl, sp}
    1e88:	27000018 	smladcs	r0, r8, r0, r0
    1e8c:	001b5b0b 	andseq	r5, fp, fp, lsl #22
    1e90:	b50b2800 	strlt	r2, [fp, #-2048]	; 0xfffff800
    1e94:	29000018 	stmdbcs	r0, {r3, r4}
    1e98:	001b6b0b 	andseq	r6, fp, fp, lsl #22
    1e9c:	e90b2a00 	stmdb	fp, {r9, fp, sp}
    1ea0:	2b00001c 	blcs	1f18 <shift+0x1f18>
    1ea4:	001ae40b 	andseq	lr, sl, fp, lsl #8
    1ea8:	af0b2c00 	svcge	0x000b2c00
    1eac:	2d00001f 	stccs	0, cr0, [r0, #-124]	; 0xffffff84
    1eb0:	00185a0b 	andseq	r5, r8, fp, lsl #20
    1eb4:	0a002e00 	beq	d6bc <__bss_end+0x47a0>
    1eb8:	00001a77 	andeq	r1, r0, r7, ror sl
    1ebc:	00930107 	addseq	r0, r3, r7, lsl #2
    1ec0:	17030000 	strne	r0, [r3, -r0]
    1ec4:	00049f06 	andeq	r9, r4, r6, lsl #30
    1ec8:	16cc0b00 	strbne	r0, [ip], r0, lsl #22
    1ecc:	0b000000 	bleq	1ed4 <shift+0x1ed4>
    1ed0:	0000257e 	andeq	r2, r0, lr, ror r5
    1ed4:	16dc0b01 	ldrbne	r0, [ip], r1, lsl #22
    1ed8:	0b020000 	bleq	81ee0 <__bss_end+0x78fc4>
    1edc:	000016ff 	strdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    1ee0:	23b70b03 			; <UNDEFINED> instruction: 0x23b70b03
    1ee4:	0b040000 	bleq	101eec <__bss_end+0xf8fd0>
    1ee8:	00002015 	andeq	r2, r0, r5, lsl r0
    1eec:	17890b05 	strne	r0, [r9, r5, lsl #22]
    1ef0:	0b060000 	bleq	181ef8 <__bss_end+0x178fdc>
    1ef4:	000018fe 	strdeq	r1, [r0], -lr
    1ef8:	170f0b07 	strne	r0, [pc, -r7, lsl #22]
    1efc:	0b080000 	bleq	201f04 <__bss_end+0x1f8fe8>
    1f00:	00002644 	andeq	r2, r0, r4, asr #12
    1f04:	142f0b09 	strtne	r0, [pc], #-2825	; 1f0c <shift+0x1f0c>
    1f08:	0b0a0000 	bleq	281f10 <__bss_end+0x278ff4>
    1f0c:	0000256d 	andeq	r2, r0, sp, ror #10
    1f10:	1c560b0b 	mrrcne	11, 0, r0, r6, cr11
    1f14:	0b0c0000 	bleq	301f1c <__bss_end+0x2f9000>
    1f18:	00002501 	andeq	r2, r0, r1, lsl #10
    1f1c:	1f9d0b0d 	svcne	0x009d0b0d
    1f20:	0b0e0000 	bleq	381f28 <__bss_end+0x37900c>
    1f24:	00002236 	andeq	r2, r0, r6, lsr r2
    1f28:	17ea0b0f 	strbne	r0, [sl, pc, lsl #22]!
    1f2c:	0b100000 	bleq	401f34 <__bss_end+0x3f9018>
    1f30:	000016ec 	andeq	r1, r0, ip, ror #13
    1f34:	1f550b11 	svcne	0x00550b11
    1f38:	0b120000 	bleq	481f40 <__bss_end+0x479024>
    1f3c:	000017d5 	ldrdeq	r1, [r0], -r5
    1f40:	255c0b13 	ldrbcs	r0, [ip, #-2835]	; 0xfffff4ed
    1f44:	0b140000 	bleq	501f4c <__bss_end+0x4f9030>
    1f48:	00001459 	andeq	r1, r0, r9, asr r4
    1f4c:	1ba50b15 	blne	fe944ba8 <__bss_end+0xfe93bc8c>
    1f50:	0b160000 	bleq	581f58 <__bss_end+0x57903c>
    1f54:	0000171f 	andeq	r1, r0, pc, lsl r7
    1f58:	13f60b17 	mvnsne	r0, #23552	; 0x5c00
    1f5c:	0b180000 	bleq	601f64 <__bss_end+0x5f9048>
    1f60:	000025ea 	andeq	r2, r0, sl, ror #11
    1f64:	22a50b19 	adccs	r0, r5, #25600	; 0x6400
    1f68:	0b1a0000 	bleq	681f70 <__bss_end+0x679054>
    1f6c:	000020b9 	strheq	r2, [r0], -r9
    1f70:	221d0b1b 	andscs	r0, sp, #27648	; 0x6c00
    1f74:	0b1c0000 	bleq	701f7c <__bss_end+0x6f9060>
    1f78:	00002381 	andeq	r2, r0, r1, lsl #7
    1f7c:	173f0b1d 			; <UNDEFINED> instruction: 0x173f0b1d
    1f80:	0b1e0000 	bleq	781f88 <__bss_end+0x77906c>
    1f84:	000014ca 	andeq	r1, r0, sl, asr #9
    1f88:	20d20b1f 	sbcscs	r0, r2, pc, lsl fp
    1f8c:	0b200000 	bleq	801f94 <__bss_end+0x7f9078>
    1f90:	00001836 	andeq	r1, r0, r6, lsr r8
    1f94:	20270b21 	eorcs	r0, r7, r1, lsr #22
    1f98:	0b220000 	bleq	881fa0 <__bss_end+0x879084>
    1f9c:	00001c27 	andeq	r1, r0, r7, lsr #24
    1fa0:	172f0b23 	strne	r0, [pc, -r3, lsr #22]!
    1fa4:	0b240000 	bleq	901fac <__bss_end+0x8f9090>
    1fa8:	000021d5 	ldrdeq	r2, [r0], -r5
    1fac:	16420b25 	strbne	r0, [r2], -r5, lsr #22
    1fb0:	0b260000 	bleq	981fb8 <__bss_end+0x97909c>
    1fb4:	00002366 	andeq	r2, r0, r6, ror #6
    1fb8:	26310b27 	ldrtcs	r0, [r1], -r7, lsr #22
    1fbc:	0b280000 	bleq	a01fc4 <__bss_end+0x9f90a8>
    1fc0:	00001f28 	andeq	r1, r0, r8, lsr #30
    1fc4:	19cf0b29 	stmibne	pc, {r0, r3, r5, r8, r9, fp}^	; <UNPREDICTABLE>
    1fc8:	0b2a0000 	bleq	a81fd0 <__bss_end+0xa790b4>
    1fcc:	000020fc 	strdeq	r2, [r0], -ip
    1fd0:	1c850b2b 	fstmiaxne	r5, {d0-d20}	;@ Deprecated
    1fd4:	0b2c0000 	bleq	b01fdc <__bss_end+0xaf90c0>
    1fd8:	0000151d 	andeq	r1, r0, sp, lsl r5
    1fdc:	14a10b2d 	strtne	r0, [r1], #2861	; 0xb2d
    1fe0:	0b2e0000 	bleq	b81fe8 <__bss_end+0xb790cc>
    1fe4:	000024bf 			; <UNDEFINED> instruction: 0x000024bf
    1fe8:	1c130b2f 			; <UNDEFINED> instruction: 0x1c130b2f
    1fec:	0b300000 	bleq	c01ff4 <__bss_end+0xbf90d8>
    1ff0:	000017af 	andeq	r1, r0, pc, lsr #15
    1ff4:	1bf20b31 	blne	ffc84cc0 <__bss_end+0xffc7bda4>
    1ff8:	0b320000 	bleq	c82000 <__bss_end+0xc790e4>
    1ffc:	00001ea1 	andeq	r1, r0, r1, lsr #29
    2000:	148f0b33 	strne	r0, [pc], #2867	; 2008 <shift+0x2008>
    2004:	0b340000 	bleq	d0200c <__bss_end+0xcf90f0>
    2008:	0000261f 	andeq	r2, r0, pc, lsl r6
    200c:	1cd60b35 	fldmiaxne	r6, {d16-d41}	;@ Deprecated
    2010:	0b360000 	bleq	d82018 <__bss_end+0xd790fc>
    2014:	00001968 	andeq	r1, r0, r8, ror #18
    2018:	1d130b37 	vldrne	d0, [r3, #-220]	; 0xffffff24
    201c:	0b380000 	bleq	e02024 <__bss_end+0xdf9108>
    2020:	00002527 	andeq	r2, r0, r7, lsr #10
    2024:	15d40b39 	ldrbne	r0, [r4, #2873]	; 0xb39
    2028:	0b3a0000 	bleq	e82030 <__bss_end+0xe79114>
    202c:	0000197b 	andeq	r1, r0, fp, ror r9
    2030:	19470b3b 	stmdbne	r7, {r0, r1, r3, r4, r5, r8, r9, fp}^
    2034:	0b3c0000 	bleq	f0203c <__bss_end+0xef9120>
    2038:	00001360 	andeq	r1, r0, r0, ror #6
    203c:	1c680b3d 			; <UNDEFINED> instruction: 0x1c680b3d
    2040:	0b3e0000 	bleq	f82048 <__bss_end+0xf7912c>
    2044:	00001a47 	andeq	r1, r0, r7, asr #20
    2048:	14e80b3f 	strbtne	r0, [r8], #2879	; 0xb3f
    204c:	0b400000 	bleq	1002054 <__bss_end+0xff9138>
    2050:	000024d3 	ldrdeq	r2, [r0], -r3
    2054:	1bb80b41 	blne	fee04d60 <__bss_end+0xfedfbe44>
    2058:	0b420000 	bleq	1082060 <__bss_end+0x1079144>
    205c:	00001931 	andeq	r1, r0, r1, lsr r9
    2060:	13a10b43 			; <UNDEFINED> instruction: 0x13a10b43
    2064:	0b440000 	bleq	110206c <__bss_end+0x10f9150>
    2068:	00001b15 	andeq	r1, r0, r5, lsl fp
    206c:	1b010b45 	blne	44d88 <__bss_end+0x3be6c>
    2070:	0b460000 	bleq	1182078 <__bss_end+0x117915c>
    2074:	0000207c 	andeq	r2, r0, ip, ror r0
    2078:	21440b47 	cmpcs	r4, r7, asr #22
    207c:	0b480000 	bleq	1202084 <__bss_end+0x11f9168>
    2080:	0000249e 	muleq	r0, lr, r4
    2084:	18670b49 	stmdane	r7!, {r0, r3, r6, r8, r9, fp}^
    2088:	0b4a0000 	bleq	1282090 <__bss_end+0x1279174>
    208c:	00001e57 	andeq	r1, r0, r7, asr lr
    2090:	21110b4b 	tstcs	r1, fp, asr #22
    2094:	0b4c0000 	bleq	130209c <__bss_end+0x12f9180>
    2098:	00001fbe 			; <UNDEFINED> instruction: 0x00001fbe
    209c:	1fd20b4d 	svcne	0x00d20b4d
    20a0:	0b4e0000 	bleq	13820a8 <__bss_end+0x137918c>
    20a4:	00001fe6 	andeq	r1, r0, r6, ror #31
    20a8:	16620b4f 	strbtne	r0, [r2], -pc, asr #22
    20ac:	0b500000 	bleq	14020b4 <__bss_end+0x13f9198>
    20b0:	000015bf 			; <UNDEFINED> instruction: 0x000015bf
    20b4:	15e70b51 	strbne	r0, [r7, #2897]!	; 0xb51
    20b8:	0b520000 	bleq	14820c0 <__bss_end+0x14791a4>
    20bc:	00002248 	andeq	r2, r0, r8, asr #4
    20c0:	162d0b53 			; <UNDEFINED> instruction: 0x162d0b53
    20c4:	0b540000 	bleq	15020cc <__bss_end+0x14f91b0>
    20c8:	0000225c 	andeq	r2, r0, ip, asr r2
    20cc:	22700b55 	rsbscs	r0, r0, #87040	; 0x15400
    20d0:	0b560000 	bleq	15820d8 <__bss_end+0x15791bc>
    20d4:	00002284 	andeq	r2, r0, r4, lsl #5
    20d8:	17c10b57 			; <UNDEFINED> instruction: 0x17c10b57
    20dc:	0b580000 	bleq	16020e4 <__bss_end+0x15f91c8>
    20e0:	0000179b 	muleq	r0, fp, r7
    20e4:	1b290b59 	blne	a44e50 <__bss_end+0xa3bf34>
    20e8:	0b5a0000 	bleq	16820f0 <__bss_end+0x16791d4>
    20ec:	00001d26 	andeq	r1, r0, r6, lsr #26
    20f0:	1aaf0b5b 	bne	febc4e64 <__bss_end+0xfebbbf48>
    20f4:	0b5c0000 	bleq	17020fc <__bss_end+0x16f91e0>
    20f8:	00001334 	andeq	r1, r0, r4, lsr r3
    20fc:	18e90b5d 	stmiane	r9!, {r0, r2, r3, r4, r6, r8, r9, fp}^
    2100:	0b5e0000 	bleq	1782108 <__bss_end+0x17791ec>
    2104:	00001d4f 	andeq	r1, r0, pc, asr #26
    2108:	1b7b0b5f 	blne	1ec4e8c <__bss_end+0x1ebbf70>
    210c:	0b600000 	bleq	1802114 <__bss_end+0x17f91f8>
    2110:	0000203a 	andeq	r2, r0, sl, lsr r0
    2114:	259c0b61 	ldrcs	r0, [ip, #2913]	; 0xb61
    2118:	0b620000 	bleq	1882120 <__bss_end+0x1879204>
    211c:	00001e42 	andeq	r1, r0, r2, asr #28
    2120:	188c0b63 	stmne	ip, {r0, r1, r5, r6, r8, r9, fp}
    2124:	0b640000 	bleq	190212c <__bss_end+0x18f9210>
    2128:	00001408 	andeq	r1, r0, r8, lsl #8
    212c:	13c60b65 	bicne	r0, r6, #103424	; 0x19400
    2130:	0b660000 	bleq	1982138 <__bss_end+0x197921c>
    2134:	00001d87 	andeq	r1, r0, r7, lsl #27
    2138:	1ec20b67 			; <UNDEFINED> instruction: 0x1ec20b67
    213c:	0b680000 	bleq	1a02144 <__bss_end+0x19f9228>
    2140:	0000205e 	andeq	r2, r0, lr, asr r0
    2144:	1b900b69 	blne	fe404ef0 <__bss_end+0xfe3fbfd4>
    2148:	0b6a0000 	bleq	1a82150 <__bss_end+0x1a79234>
    214c:	000025d5 	ldrdeq	r2, [r0], -r5
    2150:	1ca60b6b 	fstmiaxne	r6!, {d0-d52}	;@ Deprecated
    2154:	0b6c0000 	bleq	1b0215c <__bss_end+0x1af9240>
    2158:	00001385 	andeq	r1, r0, r5, lsl #7
    215c:	14b50b6d 	ldrtne	r0, [r5], #2925	; 0xb6d
    2160:	0b6e0000 	bleq	1b82168 <__bss_end+0x1b7924c>
    2164:	000018a0 	andeq	r1, r0, r0, lsr #17
    2168:	17500b6f 	ldrbne	r0, [r0, -pc, ror #22]
    216c:	00700000 	rsbseq	r0, r0, r0
    2170:	40070203 	andmi	r0, r7, r3, lsl #4
    2174:	0c000008 	stceq	0, cr0, [r0], {8}
    2178:	000004bc 			; <UNDEFINED> instruction: 0x000004bc
    217c:	000004b1 			; <UNDEFINED> instruction: 0x000004b1
    2180:	a60e000d 	strge	r0, [lr], -sp
    2184:	05000004 	streq	r0, [r0, #-4]
    2188:	0004c804 	andeq	ip, r4, r4, lsl #16
    218c:	04b60e00 	ldrteq	r0, [r6], #3584	; 0xe00
    2190:	01030000 	mrseq	r0, (UNDEF: 3)
    2194:	000a5708 	andeq	r5, sl, r8, lsl #14
    2198:	04c10e00 	strbeq	r0, [r1], #3584	; 0xe00
    219c:	4d0f0000 	stcmi	0, cr0, [pc, #-0]	; 21a4 <shift+0x21a4>
    21a0:	04000015 	streq	r0, [r0], #-21	; 0xffffffeb
    21a4:	b11a0144 	tstlt	sl, r4, asr #2
    21a8:	0f000004 	svceq	0x00000004
    21ac:	00001921 	andeq	r1, r0, r1, lsr #18
    21b0:	1a017904 	bne	605c8 <__bss_end+0x576ac>
    21b4:	000004b1 			; <UNDEFINED> instruction: 0x000004b1
    21b8:	0004c10c 	andeq	ip, r4, ip, lsl #2
    21bc:	0004f200 	andeq	pc, r4, r0, lsl #4
    21c0:	09000d00 	stmdbeq	r0, {r8, sl, fp}
    21c4:	00001b4d 	andeq	r1, r0, sp, asr #22
    21c8:	e70d2d05 	str	r2, [sp, -r5, lsl #26]
    21cc:	09000004 	stmdbeq	r0, {r2}
    21d0:	00002342 	andeq	r2, r0, r2, asr #6
    21d4:	e61c3505 	ldr	r3, [ip], -r5, lsl #10
    21d8:	0a000001 	beq	21e4 <shift+0x21e4>
    21dc:	000017fd 	strdeq	r1, [r0], -sp
    21e0:	00930107 	addseq	r0, r3, r7, lsl #2
    21e4:	37050000 	strcc	r0, [r5, -r0]
    21e8:	00057d0e 	andeq	r7, r5, lr, lsl #26
    21ec:	139a0b00 	orrsne	r0, sl, #0, 22
    21f0:	0b000000 	bleq	21f8 <shift+0x21f8>
    21f4:	00001a34 	andeq	r1, r0, r4, lsr sl
    21f8:	25390b01 	ldrcs	r0, [r9, #-2817]!	; 0xfffff4ff
    21fc:	0b020000 	bleq	82204 <__bss_end+0x792e8>
    2200:	00002514 	andeq	r2, r0, r4, lsl r5
    2204:	1df00b03 			; <UNDEFINED> instruction: 0x1df00b03
    2208:	0b040000 	bleq	102210 <__bss_end+0xf92f4>
    220c:	00002192 	muleq	r0, r2, r1
    2210:	15900b05 	ldrne	r0, [r0, #2821]	; 0xb05
    2214:	0b060000 	bleq	18221c <__bss_end+0x179300>
    2218:	00001572 	andeq	r1, r0, r2, ror r5
    221c:	16c50b07 	strbne	r0, [r5], r7, lsl #22
    2220:	0b080000 	bleq	202228 <__bss_end+0x1f930c>
    2224:	00001c7e 	andeq	r1, r0, lr, ror ip
    2228:	15970b09 	ldrne	r0, [r7, #2825]	; 0xb09
    222c:	0b0a0000 	bleq	282234 <__bss_end+0x279318>
    2230:	00001603 	andeq	r1, r0, r3, lsl #12
    2234:	15fc0b0b 	ldrbne	r0, [ip, #2827]!	; 0xb0b
    2238:	0b0c0000 	bleq	302240 <__bss_end+0x2f9324>
    223c:	00001589 	andeq	r1, r0, r9, lsl #11
    2240:	21e90b0d 	mvncs	r0, sp, lsl #22
    2244:	0b0e0000 	bleq	38224c <__bss_end+0x379330>
    2248:	00001ee0 	andeq	r1, r0, r0, ror #29
    224c:	9404000f 	strls	r0, [r4], #-15
    2250:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    2254:	050a013c 	streq	r0, [sl, #-316]	; 0xfffffec4
    2258:	65090000 	strvs	r0, [r9, #-0]
    225c:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    2260:	057d0f3e 	ldrbeq	r0, [sp, #-3902]!	; 0xfffff0c2
    2264:	0c090000 	stceq	0, cr0, [r9], {-0}
    2268:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    226c:	001d0c47 	andseq	r0, sp, r7, asr #24
    2270:	3d090000 	stccc	0, cr0, [r9, #-0]
    2274:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    2278:	001d0c48 	andseq	r0, sp, r8, asr #24
    227c:	26100000 	ldrcs	r0, [r0], -r0
    2280:	09000023 	stmdbeq	r0, {r0, r1, r5}
    2284:	00002174 	andeq	r2, r0, r4, ror r1
    2288:	be144905 	vnmlslt.f16	s8, s8, s10	; <UNPREDICTABLE>
    228c:	05000005 	streq	r0, [r0, #-5]
    2290:	0005ad04 	andeq	sl, r5, r4, lsl #26
    2294:	fe091100 	cdp2	1, 0, cr1, cr9, cr0, {0}
    2298:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    229c:	05d10f4b 	ldrbeq	r0, [r1, #3915]	; 0xf4b
    22a0:	04050000 	streq	r0, [r5], #-0
    22a4:	000005c4 	andeq	r0, r0, r4, asr #11
    22a8:	0020e712 	eoreq	lr, r0, r2, lsl r7
    22ac:	1ddd0900 	vldrne.16	s1, [sp]	; <UNPREDICTABLE>
    22b0:	4f050000 	svcmi	0x00050000
    22b4:	0005e80d 	andeq	lr, r5, sp, lsl #16
    22b8:	d7040500 	strle	r0, [r4, -r0, lsl #10]
    22bc:	13000005 	movwne	r0, #5
    22c0:	000016ab 	andeq	r1, r0, fp, lsr #13
    22c4:	01580534 	cmpeq	r8, r4, lsr r5
    22c8:	00061915 	andeq	r1, r6, r5, lsl r9
    22cc:	1b561400 	blne	15872d4 <__bss_end+0x157e3b8>
    22d0:	5a050000 	bpl	1422d8 <__bss_end+0x1393bc>
    22d4:	04b60f01 	ldrteq	r0, [r6], #3841	; 0xf01
    22d8:	14000000 	strne	r0, [r0], #-0
    22dc:	0000168f 	andeq	r1, r0, pc, lsl #13
    22e0:	14015b05 	strne	r5, [r1], #-2821	; 0xfffff4fb
    22e4:	0000061e 	andeq	r0, r0, lr, lsl r6
    22e8:	ee0e0004 	cdp	0, 0, cr0, cr14, cr4, {0}
    22ec:	0c000005 	stceq	0, cr0, [r0], {5}
    22f0:	000000b9 	strheq	r0, [r0], -r9
    22f4:	0000062e 	andeq	r0, r0, lr, lsr #12
    22f8:	00002415 	andeq	r2, r0, r5, lsl r4
    22fc:	0c002d00 	stceq	13, cr2, [r0], {-0}
    2300:	00000619 	andeq	r0, r0, r9, lsl r6
    2304:	00000639 	andeq	r0, r0, r9, lsr r6
    2308:	2e0e000d 	cdpcs	0, 0, cr0, cr14, cr13, {0}
    230c:	0f000006 	svceq	0x00000006
    2310:	00001a86 	andeq	r1, r0, r6, lsl #21
    2314:	03015c05 	movweq	r5, #7173	; 0x1c05
    2318:	00000639 	andeq	r0, r0, r9, lsr r6
    231c:	001cf60f 	andseq	pc, ip, pc, lsl #12
    2320:	015f0500 	cmpeq	pc, r0, lsl #10
    2324:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2328:	21251600 			; <UNDEFINED> instruction: 0x21251600
    232c:	01070000 	mrseq	r0, (UNDEF: 7)
    2330:	00000093 	muleq	r0, r3, r0
    2334:	06017205 	streq	r7, [r1], -r5, lsl #4
    2338:	0000070e 	andeq	r0, r0, lr, lsl #14
    233c:	001dd10b 	andseq	sp, sp, fp, lsl #2
    2340:	410b0000 	mrsmi	r0, (UNDEF: 11)
    2344:	02000014 	andeq	r0, r0, #20
    2348:	00144d0b 	andseq	r4, r4, fp, lsl #26
    234c:	290b0300 	stmdbcs	fp, {r8, r9}
    2350:	03000018 	movweq	r0, #24
    2354:	001e0d0b 	andseq	r0, lr, fp, lsl #26
    2358:	900b0400 	andls	r0, fp, r0, lsl #8
    235c:	04000019 	streq	r0, [r0], #-25	; 0xffffffe7
    2360:	00146b0b 	andseq	r6, r4, fp, lsl #22
    2364:	5d0b0500 	cfstr32pl	mvfx0, [fp, #-0]
    2368:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    236c:	001a970b 	andseq	r9, sl, fp, lsl #14
    2370:	c10b0500 	tstgt	fp, r0, lsl #10
    2374:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    2378:	00152e0b 	andseq	r2, r5, fp, lsl #28
    237c:	770b0500 	strvc	r0, [fp, -r0, lsl #10]
    2380:	06000014 			; <UNDEFINED> instruction: 0x06000014
    2384:	001c060b 	andseq	r0, ip, fp, lsl #12
    2388:	810b0600 	tsthi	fp, r0, lsl #12
    238c:	06000016 			; <UNDEFINED> instruction: 0x06000016
    2390:	001f1b0b 	andseq	r1, pc, fp, lsl #22
    2394:	b50b0600 	strlt	r0, [fp, #-1536]	; 0xfffffa00
    2398:	06000021 	streq	r0, [r0], -r1, lsr #32
    239c:	001c3a0b 	andseq	r3, ip, fp, lsl #20
    23a0:	990b0600 	stmdbls	fp, {r9, sl}
    23a4:	0600001c 			; <UNDEFINED> instruction: 0x0600001c
    23a8:	0014830b 	andseq	r8, r4, fp, lsl #6
    23ac:	b40b0700 	strlt	r0, [fp], #-1792	; 0xfffff900
    23b0:	0700001d 	smladeq	r0, sp, r0, r0
    23b4:	001e190b 	andseq	r1, lr, fp, lsl #18
    23b8:	ff0b0700 			; <UNDEFINED> instruction: 0xff0b0700
    23bc:	07000021 	streq	r0, [r0, -r1, lsr #32]
    23c0:	0016540b 	andseq	r5, r6, fp, lsl #8
    23c4:	940b0700 	strls	r0, [fp], #-1792	; 0xfffff900
    23c8:	0800001e 	stmdaeq	r0, {r1, r2, r3, r4}
    23cc:	0013e40b 	andseq	lr, r3, fp, lsl #8
    23d0:	c30b0800 	movwgt	r0, #47104	; 0xb800
    23d4:	08000021 	stmdaeq	r0, {r0, r5}
    23d8:	001eb50b 	andseq	fp, lr, fp, lsl #10
    23dc:	0f000800 	svceq	0x00000800
    23e0:	0000254e 	andeq	r2, r0, lr, asr #10
    23e4:	1f019205 	svcne	0x00019205
    23e8:	00000658 	andeq	r0, r0, r8, asr r6
    23ec:	00195d0f 	andseq	r5, r9, pc, lsl #26
    23f0:	01950500 	orrseq	r0, r5, r0, lsl #10
    23f4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    23f8:	1ee70f00 	cdpne	15, 14, cr0, cr7, cr0, {0}
    23fc:	98050000 	stmdals	r5, {}	; <UNPREDICTABLE>
    2400:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2404:	a40f0000 	strge	r0, [pc], #-0	; 240c <shift+0x240c>
    2408:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    240c:	1d0c019b 	stfnes	f0, [ip, #-620]	; 0xfffffd94
    2410:	0f000000 	svceq	0x00000000
    2414:	00001ef1 	strdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    2418:	0c019e05 	stceq	14, cr9, [r1], {5}
    241c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2420:	001be70f 	andseq	lr, fp, pc, lsl #14
    2424:	01a10500 			; <UNDEFINED> instruction: 0x01a10500
    2428:	00001d0c 	andeq	r1, r0, ip, lsl #26
    242c:	1f3b0f00 	svcne	0x003b0f00
    2430:	a4050000 	strge	r0, [r5], #-0
    2434:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2438:	f70f0000 			; <UNDEFINED> instruction: 0xf70f0000
    243c:	0500001d 	streq	r0, [r0, #-29]	; 0xffffffe3
    2440:	1d0c01a7 	stfnes	f0, [ip, #-668]	; 0xfffffd64
    2444:	0f000000 	svceq	0x00000000
    2448:	00001e02 	andeq	r1, r0, r2, lsl #28
    244c:	0c01aa05 			; <UNDEFINED> instruction: 0x0c01aa05
    2450:	0000001d 	andeq	r0, r0, sp, lsl r0
    2454:	001efb0f 	andseq	pc, lr, pc, lsl #22
    2458:	01ad0500 			; <UNDEFINED> instruction: 0x01ad0500
    245c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2460:	1bd90f00 	blne	ff646068 <__bss_end+0xff63d14c>
    2464:	b0050000 	andlt	r0, r5, r0
    2468:	001d0c01 	andseq	r0, sp, r1, lsl #24
    246c:	900f0000 	andls	r0, pc, r0
    2470:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    2474:	1d0c01b3 	stfnes	f0, [ip, #-716]	; 0xfffffd34
    2478:	0f000000 	svceq	0x00000000
    247c:	00001f05 	andeq	r1, r0, r5, lsl #30
    2480:	0c01b605 	stceq	6, cr11, [r1], {5}
    2484:	0000001d 	andeq	r0, r0, sp, lsl r0
    2488:	00266d0f 	eoreq	r6, r6, pc, lsl #26
    248c:	01b90500 			; <UNDEFINED> instruction: 0x01b90500
    2490:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2494:	251b0f00 	ldrcs	r0, [fp, #-3840]	; 0xfffff100
    2498:	bc050000 	stclt	0, cr0, [r5], {-0}
    249c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    24a0:	400f0000 	andmi	r0, pc, r0
    24a4:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    24a8:	1d0c01c0 	stfnes	f0, [ip, #-768]	; 0xfffffd00
    24ac:	0f000000 	svceq	0x00000000
    24b0:	00002660 	andeq	r2, r0, r0, ror #12
    24b4:	0c01c305 	stceq	3, cr12, [r1], {5}
    24b8:	0000001d 	andeq	r0, r0, sp, lsl r0
    24bc:	00159e0f 	andseq	r9, r5, pc, lsl #28
    24c0:	01c60500 	biceq	r0, r6, r0, lsl #10
    24c4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    24c8:	13750f00 	cmnne	r5, #0, 30
    24cc:	c9050000 	stmdbgt	r5, {}	; <UNPREDICTABLE>
    24d0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    24d4:	490f0000 	stmdbmi	pc, {}	; <UNPREDICTABLE>
    24d8:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    24dc:	1d0c01cc 	stfnes	f0, [ip, #-816]	; 0xfffffcd0
    24e0:	0f000000 	svceq	0x00000000
    24e4:	00001579 	andeq	r1, r0, r9, ror r5
    24e8:	0c01cf05 	stceq	15, cr12, [r1], {5}
    24ec:	0000001d 	andeq	r0, r0, sp, lsl r0
    24f0:	001f450f 	andseq	r4, pc, pc, lsl #10
    24f4:	01d20500 	bicseq	r0, r2, r0, lsl #10
    24f8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    24fc:	1acc0f00 	bne	ff306104 <__bss_end+0xff2fd1e8>
    2500:	d5050000 	strle	r0, [r5, #-0]
    2504:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2508:	640f0000 	strvs	r0, [pc], #-0	; 2510 <shift+0x2510>
    250c:	0500001d 	streq	r0, [r0, #-29]	; 0xffffffe3
    2510:	1d0c01d8 	stfnes	f0, [ip, #-864]	; 0xfffffca0
    2514:	0f000000 	svceq	0x00000000
    2518:	0000234b 	andeq	r2, r0, fp, asr #6
    251c:	0c01df05 	stceq	15, cr13, [r1], {5}
    2520:	0000001d 	andeq	r0, r0, sp, lsl r0
    2524:	0025ff0f 	eoreq	pc, r5, pc, lsl #30
    2528:	01e20500 	mvneq	r0, r0, lsl #10
    252c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2530:	260f0f00 	strcs	r0, [pc], -r0, lsl #30
    2534:	e5050000 	str	r0, [r5, #-0]
    2538:	001d0c01 	andseq	r0, sp, r1, lsl #24
    253c:	980f0000 	stmdals	pc, {}	; <UNPREDICTABLE>
    2540:	05000016 	streq	r0, [r0, #-22]	; 0xffffffea
    2544:	1d0c01e8 	stfnes	f0, [ip, #-928]	; 0xfffffc60
    2548:	0f000000 	svceq	0x00000000
    254c:	00002392 	muleq	r0, r2, r3
    2550:	0c01eb05 			; <UNDEFINED> instruction: 0x0c01eb05
    2554:	0000001d 	andeq	r0, r0, sp, lsl r0
    2558:	001e7c0f 	andseq	r7, lr, pc, lsl #24
    255c:	01ee0500 	mvneq	r0, r0, lsl #10
    2560:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2564:	18c20f00 	stmiane	r2, {r8, r9, sl, fp}^
    2568:	f2050000 	vhadd.s8	d0, d5, d0
    256c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2570:	370f0000 	strcc	r0, [pc, -r0]
    2574:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    2578:	1d0c01fa 	stfnes	f0, [ip, #-1000]	; 0xfffffc18
    257c:	0f000000 	svceq	0x00000000
    2580:	0000177b 	andeq	r1, r0, fp, ror r7
    2584:	0c01fd05 	stceq	13, cr15, [r1], {5}
    2588:	0000001d 	andeq	r0, r0, sp, lsl r0
    258c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2590:	0008c600 	andeq	ip, r8, r0, lsl #12
    2594:	0f000d00 	svceq	0x00000d00
    2598:	000019ac 	andeq	r1, r0, ip, lsr #19
    259c:	0c03eb05 			; <UNDEFINED> instruction: 0x0c03eb05
    25a0:	000008bb 			; <UNDEFINED> instruction: 0x000008bb
    25a4:	0005be0c 	andeq	fp, r5, ip, lsl #28
    25a8:	0008e300 	andeq	lr, r8, r0, lsl #6
    25ac:	00241500 	eoreq	r1, r4, r0, lsl #10
    25b0:	000d0000 	andeq	r0, sp, r0
    25b4:	001f7b0f 	andseq	r7, pc, pc, lsl #22
    25b8:	05740500 	ldrbeq	r0, [r4, #-1280]!	; 0xfffffb00
    25bc:	0008d314 	andeq	sp, r8, r4, lsl r3
    25c0:	1a8f1600 	bne	fe3c7dc8 <__bss_end+0xfe3beeac>
    25c4:	01070000 	mrseq	r0, (UNDEF: 7)
    25c8:	00000093 	muleq	r0, r3, r0
    25cc:	06057b05 	streq	r7, [r5], -r5, lsl #22
    25d0:	0000092e 	andeq	r0, r0, lr, lsr #18
    25d4:	00180b0b 	andseq	r0, r8, fp, lsl #22
    25d8:	c40b0000 	strgt	r0, [fp], #-0
    25dc:	0100001c 	tsteq	r0, ip, lsl r0
    25e0:	00141a0b 	andseq	r1, r4, fp, lsl #20
    25e4:	c10b0200 	mrsgt	r0, R11_fiq
    25e8:	03000025 	movweq	r0, #37	; 0x25
    25ec:	0020070b 	eoreq	r0, r0, fp, lsl #14
    25f0:	fa0b0400 	blx	2c35f8 <__bss_end+0x2ba6dc>
    25f4:	0500001f 	streq	r0, [r0, #-31]	; 0xffffffe1
    25f8:	00150d0b 	andseq	r0, r5, fp, lsl #26
    25fc:	0f000600 	svceq	0x00000600
    2600:	000025b1 			; <UNDEFINED> instruction: 0x000025b1
    2604:	15058805 	strne	r8, [r5, #-2053]	; 0xfffff7fb
    2608:	000008f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    260c:	00248d0f 	eoreq	r8, r4, pc, lsl #26
    2610:	07890500 	streq	r0, [r9, r0, lsl #10]
    2614:	00002411 	andeq	r2, r0, r1, lsl r4
    2618:	1f680f00 	svcne	0x00680f00
    261c:	9e050000 	cdpls	0, 0, cr0, cr5, cr0, {0}
    2620:	001d0c07 	andseq	r0, sp, r7, lsl #24
    2624:	3a040000 	bcc	10262c <__bss_end+0xf9710>
    2628:	06000023 	streq	r0, [r0], -r3, lsr #32
    262c:	0093167b 	addseq	r1, r3, fp, ror r6
    2630:	550e0000 	strpl	r0, [lr, #-0]
    2634:	03000009 	movweq	r0, #9
    2638:	0a8e0502 	beq	fe383a48 <__bss_end+0xfe37ab2c>
    263c:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2640:	00176407 	andseq	r6, r7, r7, lsl #8
    2644:	04040300 	streq	r0, [r4], #-768	; 0xfffffd00
    2648:	000015b9 			; <UNDEFINED> instruction: 0x000015b9
    264c:	b1030803 	tstlt	r3, r3, lsl #16
    2650:	03000015 	movweq	r0, #21
    2654:	1f140408 	svcne	0x00140408
    2658:	10030000 	andne	r0, r3, r0
    265c:	00204f03 	eoreq	r4, r0, r3, lsl #30
    2660:	09610c00 	stmdbeq	r1!, {sl, fp}^
    2664:	09a00000 	stmibeq	r0!, {}	; <UNPREDICTABLE>
    2668:	24150000 	ldrcs	r0, [r5], #-0
    266c:	ff000000 			; <UNDEFINED> instruction: 0xff000000
    2670:	09900e00 	ldmibeq	r0, {r9, sl, fp}
    2674:	260f0000 	strcs	r0, [pc], -r0
    2678:	0600001e 			; <UNDEFINED> instruction: 0x0600001e
    267c:	a01601fc 			; <UNDEFINED> instruction: 0xa01601fc
    2680:	0f000009 	svceq	0x00000009
    2684:	00001568 	andeq	r1, r0, r8, ror #10
    2688:	16020206 	strne	r0, [r2], -r6, lsl #4
    268c:	000009a0 	andeq	r0, r0, r0, lsr #19
    2690:	00235d04 	eoreq	r5, r3, r4, lsl #26
    2694:	102a0700 	eorne	r0, sl, r0, lsl #14
    2698:	000005d1 	ldrdeq	r0, [r0], -r1
    269c:	0009bf0c 	andeq	fp, r9, ip, lsl #30
    26a0:	0009d600 	andeq	sp, r9, r0, lsl #12
    26a4:	09000d00 	stmdbeq	r0, {r8, sl, fp}
    26a8:	0000037a 	andeq	r0, r0, sl, ror r3
    26ac:	cb112f07 	blgt	44e2d0 <__bss_end+0x4453b4>
    26b0:	09000009 	stmdbeq	r0, {r0, r3}
    26b4:	0000023c 	andeq	r0, r0, ip, lsr r2
    26b8:	cb113007 	blgt	44e6dc <__bss_end+0x4457c0>
    26bc:	17000009 	strne	r0, [r0, -r9]
    26c0:	000009d6 	ldrdeq	r0, [r0], -r6
    26c4:	0a093608 	beq	24feec <__bss_end+0x246fd0>
    26c8:	8f090305 	svchi	0x00090305
    26cc:	e2170000 	ands	r0, r7, #0
    26d0:	08000009 	stmdaeq	r0, {r0, r3}
    26d4:	050a0937 	streq	r0, [sl, #-2359]	; 0xfffff6c9
    26d8:	008f0903 	addeq	r0, pc, r3, lsl #18
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x377cf8>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb9e00>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9e20>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9e38>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <__bss_end+0x174>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7a978>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39e5c>
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
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x377da0>
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
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf79dfc>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c5a14>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7a9fc>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe39ee0>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <shift+0x16c>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9ef4>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__bss_end+0x244>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7aa34>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe39f18>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeb9f28>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x377eb0>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c5aa0>
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
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c5ab4>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x377ee4>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf79ef4>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 1e8:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 1ec:	0b0b0024 	bleq	2c0284 <__bss_end+0x2b7368>
 1f0:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 1f4:	16050000 	strne	r0, [r5], -r0
 1f8:	3a0e0300 	bcc	380e00 <__bss_end+0x377ee4>
 1fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 200:	0013490b 	andseq	r4, r3, fp, lsl #18
 204:	01130600 	tsteq	r3, r0, lsl #12
 208:	0b0b0e03 	bleq	2c3a1c <__bss_end+0x2bab00>
 20c:	0b3b0b3a 	bleq	ec2efc <__bss_end+0xeb9fe0>
 210:	13010b39 	movwne	r0, #6969	; 0x1b39
 214:	0d070000 	stceq	0, cr0, [r7, #-0]
 218:	3a080300 	bcc	200e20 <__bss_end+0x1f7f04>
 21c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 220:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 224:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 228:	0e030104 	adfeqs	f0, f3, f4
 22c:	0b3e196d 	bleq	f867e8 <__bss_end+0xf7d8cc>
 230:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 234:	0b3b0b3a 	bleq	ec2f24 <__bss_end+0xeba008>
 238:	13010b39 	movwne	r0, #6969	; 0x1b39
 23c:	28090000 	stmdacs	r9, {}	; <UNPREDICTABLE>
 240:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 244:	0a00000b 	beq	278 <shift+0x278>
 248:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 24c:	0b3b0b3a 	bleq	ec2f3c <__bss_end+0xeba020>
 250:	13490b39 	movtne	r0, #39737	; 0x9b39
 254:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 258:	020b0000 	andeq	r0, fp, #0
 25c:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 260:	0c000019 	stceq	0, cr0, [r0], {25}
 264:	0e030102 	adfeqs	f0, f3, f2
 268:	0b3a0b0b 	bleq	e82e9c <__bss_end+0xe79f80>
 26c:	0b390b3b 	bleq	e42f60 <__bss_end+0xe3a044>
 270:	00001301 	andeq	r1, r0, r1, lsl #6
 274:	03000d0d 	movweq	r0, #3341	; 0xd0d
 278:	3b0b3a0e 	blcc	2ceab8 <__bss_end+0x2c5b9c>
 27c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 280:	000b3813 	andeq	r3, fp, r3, lsl r8
 284:	012e0e00 			; <UNDEFINED> instruction: 0x012e0e00
 288:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 28c:	0b3b0b3a 	bleq	ec2f7c <__bss_end+0xeba060>
 290:	0e6e0b39 	vmoveq.8	d14[5], r0
 294:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 298:	00001364 	andeq	r1, r0, r4, ror #6
 29c:	4900050f 	stmdbmi	r0, {r0, r1, r2, r3, r8, sl}
 2a0:	00193413 	andseq	r3, r9, r3, lsl r4
 2a4:	00051000 	andeq	r1, r5, r0
 2a8:	00001349 	andeq	r1, r0, r9, asr #6
 2ac:	03000d11 	movweq	r0, #3345	; 0xd11
 2b0:	3b0b3a0e 	blcc	2ceaf0 <__bss_end+0x2c5bd4>
 2b4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 2b8:	3c193f13 	ldccc	15, cr3, [r9], {19}
 2bc:	12000019 	andne	r0, r0, #25
 2c0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 2c4:	0b3a0e03 	bleq	e83ad8 <__bss_end+0xe7abbc>
 2c8:	0b390b3b 	bleq	e42fbc <__bss_end+0xe3a0a0>
 2cc:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 2d0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 2d4:	13011364 	movwne	r1, #4964	; 0x1364
 2d8:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 2dc:	03193f01 	tsteq	r9, #1, 30
 2e0:	3b0b3a0e 	blcc	2ceb20 <__bss_end+0x2c5c04>
 2e4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2e8:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 2ec:	01136419 	tsteq	r3, r9, lsl r4
 2f0:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 2f4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 2f8:	0b3a0e03 	bleq	e83b0c <__bss_end+0xe7abf0>
 2fc:	0b390b3b 	bleq	e42ff0 <__bss_end+0xe3a0d4>
 300:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 304:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 308:	00001364 	andeq	r1, r0, r4, ror #6
 30c:	49010115 	stmdbmi	r1, {r0, r2, r4, r8}
 310:	00130113 	andseq	r0, r3, r3, lsl r1
 314:	00211600 	eoreq	r1, r1, r0, lsl #12
 318:	0b2f1349 	bleq	bc5044 <__bss_end+0xbbc128>
 31c:	0f170000 	svceq	0x00170000
 320:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 324:	18000013 	stmdane	r0, {r0, r1, r4}
 328:	00000021 	andeq	r0, r0, r1, lsr #32
 32c:	03003419 	movweq	r3, #1049	; 0x419
 330:	3b0b3a0e 	blcc	2ceb70 <__bss_end+0x2c5c54>
 334:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 338:	3c193f13 	ldccc	15, cr3, [r9], {19}
 33c:	1a000019 	bne	3a8 <shift+0x3a8>
 340:	08030028 	stmdaeq	r3, {r3, r5}
 344:	00000b1c 	andeq	r0, r0, ip, lsl fp
 348:	3f012e1b 	svccc	0x00012e1b
 34c:	3a0e0319 	bcc	380fb8 <__bss_end+0x37809c>
 350:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 354:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
 358:	01136419 	tsteq	r3, r9, lsl r4
 35c:	1c000013 	stcne	0, cr0, [r0], {19}
 360:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 364:	0b3a0e03 	bleq	e83b78 <__bss_end+0xe7ac5c>
 368:	0b390b3b 	bleq	e4305c <__bss_end+0xe3a140>
 36c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 370:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 374:	00001301 	andeq	r1, r0, r1, lsl #6
 378:	03000d1d 	movweq	r0, #3357	; 0xd1d
 37c:	3b0b3a0e 	blcc	2cebbc <__bss_end+0x2c5ca0>
 380:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 384:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
 388:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
 38c:	13490115 	movtne	r0, #37141	; 0x9115
 390:	13011364 	movwne	r1, #4964	; 0x1364
 394:	1f1f0000 	svcne	0x001f0000
 398:	49131d00 	ldmdbmi	r3, {r8, sl, fp, ip}
 39c:	20000013 	andcs	r0, r0, r3, lsl r0
 3a0:	0b0b0010 	bleq	2c03e8 <__bss_end+0x2b74cc>
 3a4:	00001349 	andeq	r1, r0, r9, asr #6
 3a8:	0b000f21 	bleq	4034 <shift+0x4034>
 3ac:	2200000b 	andcs	r0, r0, #11
 3b0:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 3b4:	0000051c 	andeq	r0, r0, ip, lsl r5
 3b8:	03002823 	movweq	r2, #2083	; 0x823
 3bc:	00061c0e 	andeq	r1, r6, lr, lsl #24
 3c0:	012e2400 			; <UNDEFINED> instruction: 0x012e2400
 3c4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 3c8:	0b3b0b3a 	bleq	ec30b8 <__bss_end+0xeba19c>
 3cc:	13490b39 	movtne	r0, #39737	; 0x9b39
 3d0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 3d4:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 3d8:	00130119 	andseq	r0, r3, r9, lsl r1
 3dc:	00052500 	andeq	r2, r5, r0, lsl #10
 3e0:	0b3a0e03 	bleq	e83bf4 <__bss_end+0xe7acd8>
 3e4:	0b390b3b 	bleq	e430d8 <__bss_end+0xe3a1bc>
 3e8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 3ec:	34260000 	strtcc	r0, [r6], #-0
 3f0:	3a0e0300 	bcc	380ff8 <__bss_end+0x3780dc>
 3f4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3f8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 3fc:	27000018 	smladcs	r0, r8, r0, r0
 400:	08030034 	stmdaeq	r3, {r2, r4, r5}
 404:	0b3b0b3a 	bleq	ec30f4 <__bss_end+0xeba1d8>
 408:	13490b39 	movtne	r0, #39737	; 0x9b39
 40c:	00001802 	andeq	r1, r0, r2, lsl #16
 410:	03012e28 	movweq	r2, #7720	; 0x1e28
 414:	3b0b3a0e 	blcc	2cec54 <__bss_end+0x2c5d38>
 418:	110b390b 	tstne	fp, fp, lsl #18
 41c:	40061201 	andmi	r1, r6, r1, lsl #4
 420:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 424:	00001301 	andeq	r1, r0, r1, lsl #6
 428:	03000529 	movweq	r0, #1321	; 0x529
 42c:	3b0b3a08 	blcc	2cec54 <__bss_end+0x2c5d38>
 430:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 434:	00180213 	andseq	r0, r8, r3, lsl r2
 438:	012e2a00 			; <UNDEFINED> instruction: 0x012e2a00
 43c:	0b3a0e03 	bleq	e83c50 <__bss_end+0xe7ad34>
 440:	0b390b3b 	bleq	e43134 <__bss_end+0xe3a218>
 444:	06120111 			; <UNDEFINED> instruction: 0x06120111
 448:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 44c:	00000019 	andeq	r0, r0, r9, lsl r0
 450:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 454:	030b130e 	movweq	r1, #45838	; 0xb30e
 458:	110e1b0e 	tstne	lr, lr, lsl #22
 45c:	10061201 	andne	r1, r6, r1, lsl #4
 460:	02000017 	andeq	r0, r0, #23
 464:	0b0b0024 	bleq	2c04fc <__bss_end+0x2b75e0>
 468:	0e030b3e 	vmoveq.16	d3[0], r0
 46c:	26030000 	strcs	r0, [r3], -r0
 470:	00134900 	andseq	r4, r3, r0, lsl #18
 474:	00240400 	eoreq	r0, r4, r0, lsl #8
 478:	0b3e0b0b 	bleq	f830ac <__bss_end+0xf7a190>
 47c:	00000803 	andeq	r0, r0, r3, lsl #16
 480:	03001605 	movweq	r1, #1541	; 0x605
 484:	3b0b3a0e 	blcc	2cecc4 <__bss_end+0x2c5da8>
 488:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 48c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 490:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 494:	0b3a0b0b 	bleq	e830c8 <__bss_end+0xe7a1ac>
 498:	0b390b3b 	bleq	e4318c <__bss_end+0xe3a270>
 49c:	00001301 	andeq	r1, r0, r1, lsl #6
 4a0:	03000d07 	movweq	r0, #3335	; 0xd07
 4a4:	3b0b3a08 	blcc	2ceccc <__bss_end+0x2c5db0>
 4a8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4ac:	000b3813 	andeq	r3, fp, r3, lsl r8
 4b0:	01040800 	tsteq	r4, r0, lsl #16
 4b4:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 4b8:	0b0b0b3e 	bleq	2c31b8 <__bss_end+0x2ba29c>
 4bc:	0b3a1349 	bleq	e851e8 <__bss_end+0xe7c2cc>
 4c0:	0b390b3b 	bleq	e431b4 <__bss_end+0xe3a298>
 4c4:	00001301 	andeq	r1, r0, r1, lsl #6
 4c8:	03002809 	movweq	r2, #2057	; 0x809
 4cc:	000b1c08 	andeq	r1, fp, r8, lsl #24
 4d0:	00280a00 	eoreq	r0, r8, r0, lsl #20
 4d4:	0b1c0e03 	bleq	703ce8 <__bss_end+0x6fadcc>
 4d8:	340b0000 	strcc	r0, [fp], #-0
 4dc:	3a0e0300 	bcc	3810e4 <__bss_end+0x3781c8>
 4e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4e4:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 4e8:	00180219 	andseq	r0, r8, r9, lsl r2
 4ec:	00020c00 	andeq	r0, r2, r0, lsl #24
 4f0:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 4f4:	020d0000 	andeq	r0, sp, #0
 4f8:	0b0e0301 	bleq	381104 <__bss_end+0x3781e8>
 4fc:	3b0b3a0b 	blcc	2ced30 <__bss_end+0x2c5e14>
 500:	010b390b 	tsteq	fp, fp, lsl #18
 504:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 508:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 50c:	0b3b0b3a 	bleq	ec31fc <__bss_end+0xeba2e0>
 510:	13490b39 	movtne	r0, #39737	; 0x9b39
 514:	00000b38 	andeq	r0, r0, r8, lsr fp
 518:	3f012e0f 	svccc	0x00012e0f
 51c:	3a0e0319 	bcc	381188 <__bss_end+0x37826c>
 520:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 524:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 528:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 52c:	10000013 	andne	r0, r0, r3, lsl r0
 530:	13490005 	movtne	r0, #36869	; 0x9005
 534:	00001934 	andeq	r1, r0, r4, lsr r9
 538:	49000511 	stmdbmi	r0, {r0, r4, r8, sl}
 53c:	12000013 	andne	r0, r0, #19
 540:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 544:	0b3b0b3a 	bleq	ec3234 <__bss_end+0xeba318>
 548:	13490b39 	movtne	r0, #39737	; 0x9b39
 54c:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 550:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 554:	03193f01 	tsteq	r9, #1, 30
 558:	3b0b3a0e 	blcc	2ced98 <__bss_end+0x2c5e7c>
 55c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 560:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 564:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 568:	00130113 	andseq	r0, r3, r3, lsl r1
 56c:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 570:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 574:	0b3b0b3a 	bleq	ec3264 <__bss_end+0xeba348>
 578:	0e6e0b39 	vmoveq.8	d14[5], r0
 57c:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 580:	13011364 	movwne	r1, #4964	; 0x1364
 584:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 588:	03193f01 	tsteq	r9, #1, 30
 58c:	3b0b3a0e 	blcc	2cedcc <__bss_end+0x2c5eb0>
 590:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 594:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 598:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 59c:	16000013 			; <UNDEFINED> instruction: 0x16000013
 5a0:	13490101 	movtne	r0, #37121	; 0x9101
 5a4:	00001301 	andeq	r1, r0, r1, lsl #6
 5a8:	49002117 	stmdbmi	r0, {r0, r1, r2, r4, r8, sp}
 5ac:	000b2f13 	andeq	r2, fp, r3, lsl pc
 5b0:	000f1800 	andeq	r1, pc, r0, lsl #16
 5b4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 5b8:	21190000 	tstcs	r9, r0
 5bc:	1a000000 	bne	5c4 <shift+0x5c4>
 5c0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 5c4:	0b3b0b3a 	bleq	ec32b4 <__bss_end+0xeba398>
 5c8:	13490b39 	movtne	r0, #39737	; 0x9b39
 5cc:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 5d0:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
 5d4:	03193f01 	tsteq	r9, #1, 30
 5d8:	3b0b3a0e 	blcc	2cee18 <__bss_end+0x2c5efc>
 5dc:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 5e0:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
 5e4:	00130113 	andseq	r0, r3, r3, lsl r1
 5e8:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 5ec:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5f0:	0b3b0b3a 	bleq	ec32e0 <__bss_end+0xeba3c4>
 5f4:	0e6e0b39 	vmoveq.8	d14[5], r0
 5f8:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 5fc:	13011364 	movwne	r1, #4964	; 0x1364
 600:	0d1d0000 	ldceq	0, cr0, [sp, #-0]
 604:	3a0e0300 	bcc	38120c <__bss_end+0x3782f0>
 608:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 60c:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 610:	000b320b 	andeq	r3, fp, fp, lsl #4
 614:	01151e00 	tsteq	r5, r0, lsl #28
 618:	13641349 	cmnne	r4, #603979777	; 0x24000001
 61c:	00001301 	andeq	r1, r0, r1, lsl #6
 620:	1d001f1f 	stcne	15, cr1, [r0, #-124]	; 0xffffff84
 624:	00134913 	andseq	r4, r3, r3, lsl r9
 628:	00102000 	andseq	r2, r0, r0
 62c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 630:	0f210000 	svceq	0x00210000
 634:	000b0b00 	andeq	r0, fp, r0, lsl #22
 638:	00342200 	eorseq	r2, r4, r0, lsl #4
 63c:	0b3a0e03 	bleq	e83e50 <__bss_end+0xe7af34>
 640:	0b390b3b 	bleq	e43334 <__bss_end+0xe3a418>
 644:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 648:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
 64c:	03193f01 	tsteq	r9, #1, 30
 650:	3b0b3a0e 	blcc	2cee90 <__bss_end+0x2c5f74>
 654:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 658:	1113490e 	tstne	r3, lr, lsl #18
 65c:	40061201 	andmi	r1, r6, r1, lsl #4
 660:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 664:	00001301 	andeq	r1, r0, r1, lsl #6
 668:	03000524 	movweq	r0, #1316	; 0x524
 66c:	3b0b3a0e 	blcc	2ceeac <__bss_end+0x2c5f90>
 670:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 674:	00180213 	andseq	r0, r8, r3, lsl r2
 678:	012e2500 			; <UNDEFINED> instruction: 0x012e2500
 67c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 680:	0b3b0b3a 	bleq	ec3370 <__bss_end+0xeba454>
 684:	0e6e0b39 	vmoveq.8	d14[5], r0
 688:	01111349 	tsteq	r1, r9, asr #6
 68c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 690:	01194297 			; <UNDEFINED> instruction: 0x01194297
 694:	26000013 			; <UNDEFINED> instruction: 0x26000013
 698:	08030034 	stmdaeq	r3, {r2, r4, r5}
 69c:	0b3b0b3a 	bleq	ec338c <__bss_end+0xeba470>
 6a0:	13490b39 	movtne	r0, #39737	; 0x9b39
 6a4:	00001802 	andeq	r1, r0, r2, lsl #16
 6a8:	3f012e27 	svccc	0x00012e27
 6ac:	3a0e0319 	bcc	381318 <__bss_end+0x3783fc>
 6b0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6b4:	110e6e0b 	tstne	lr, fp, lsl #28
 6b8:	40061201 	andmi	r1, r6, r1, lsl #4
 6bc:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6c0:	00001301 	andeq	r1, r0, r1, lsl #6
 6c4:	3f002e28 	svccc	0x00002e28
 6c8:	3a0e0319 	bcc	381334 <__bss_end+0x378418>
 6cc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6d0:	110e6e0b 	tstne	lr, fp, lsl #28
 6d4:	40061201 	andmi	r1, r6, r1, lsl #4
 6d8:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6dc:	2e290000 	cdpcs	0, 2, cr0, cr9, cr0, {0}
 6e0:	03193f01 	tsteq	r9, #1, 30
 6e4:	3b0b3a0e 	blcc	2cef24 <__bss_end+0x2c6008>
 6e8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6ec:	1113490e 	tstne	r3, lr, lsl #18
 6f0:	40061201 	andmi	r1, r6, r1, lsl #4
 6f4:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6f8:	01000000 	mrseq	r0, (UNDEF: 0)
 6fc:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 700:	0e030b13 	vmoveq.32	d3[0], r0
 704:	01110e1b 	tsteq	r1, fp, lsl lr
 708:	17100612 			; <UNDEFINED> instruction: 0x17100612
 70c:	39020000 	stmdbcc	r2, {}	; <UNPREDICTABLE>
 710:	00130101 	andseq	r0, r3, r1, lsl #2
 714:	00340300 	eorseq	r0, r4, r0, lsl #6
 718:	0b3a0e03 	bleq	e83f2c <__bss_end+0xe7b010>
 71c:	0b390b3b 	bleq	e43410 <__bss_end+0xe3a4f4>
 720:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 724:	00000a1c 	andeq	r0, r0, ip, lsl sl
 728:	3a003a04 	bcc	ef40 <__bss_end+0x6024>
 72c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 730:	0013180b 	andseq	r1, r3, fp, lsl #16
 734:	01010500 	tsteq	r1, r0, lsl #10
 738:	13011349 	movwne	r1, #4937	; 0x1349
 73c:	21060000 	mrscs	r0, (UNDEF: 6)
 740:	2f134900 	svccs	0x00134900
 744:	0700000b 	streq	r0, [r0, -fp]
 748:	13490026 	movtne	r0, #36902	; 0x9026
 74c:	24080000 	strcs	r0, [r8], #-0
 750:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 754:	000e030b 	andeq	r0, lr, fp, lsl #6
 758:	00340900 	eorseq	r0, r4, r0, lsl #18
 75c:	00001347 	andeq	r1, r0, r7, asr #6
 760:	3f012e0a 	svccc	0x00012e0a
 764:	3a0e0319 	bcc	3813d0 <__bss_end+0x3784b4>
 768:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 76c:	110e6e0b 	tstne	lr, fp, lsl #28
 770:	40061201 	andmi	r1, r6, r1, lsl #4
 774:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 778:	00001301 	andeq	r1, r0, r1, lsl #6
 77c:	0300050b 	movweq	r0, #1291	; 0x50b
 780:	3b0b3a08 	blcc	2cefa8 <__bss_end+0x2c608c>
 784:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 788:	00180213 	andseq	r0, r8, r3, lsl r2
 78c:	00340c00 	eorseq	r0, r4, r0, lsl #24
 790:	0b3a0e03 	bleq	e83fa4 <__bss_end+0xe7b088>
 794:	0b390b3b 	bleq	e43488 <__bss_end+0xe3a56c>
 798:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 79c:	0b0d0000 	bleq	3407a4 <__bss_end+0x337888>
 7a0:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 7a4:	0e000006 	cdpeq	0, 0, cr0, cr0, cr6, {0}
 7a8:	08030034 	stmdaeq	r3, {r2, r4, r5}
 7ac:	0b3b0b3a 	bleq	ec349c <__bss_end+0xeba580>
 7b0:	13490b39 	movtne	r0, #39737	; 0x9b39
 7b4:	00001802 	andeq	r1, r0, r2, lsl #16
 7b8:	0b000f0f 	bleq	43fc <shift+0x43fc>
 7bc:	0013490b 	andseq	r4, r3, fp, lsl #18
 7c0:	00261000 	eoreq	r1, r6, r0
 7c4:	0f110000 	svceq	0x00110000
 7c8:	000b0b00 	andeq	r0, fp, r0, lsl #22
 7cc:	00241200 	eoreq	r1, r4, r0, lsl #4
 7d0:	0b3e0b0b 	bleq	f83404 <__bss_end+0xf7a4e8>
 7d4:	00000803 	andeq	r0, r0, r3, lsl #16
 7d8:	03000513 	movweq	r0, #1299	; 0x513
 7dc:	3b0b3a0e 	blcc	2cf01c <__bss_end+0x2c6100>
 7e0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 7e4:	00180213 	andseq	r0, r8, r3, lsl r2
 7e8:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 7ec:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 7f0:	0b3b0b3a 	bleq	ec34e0 <__bss_end+0xeba5c4>
 7f4:	0e6e0b39 	vmoveq.8	d14[5], r0
 7f8:	01111349 	tsteq	r1, r9, asr #6
 7fc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 800:	01194297 			; <UNDEFINED> instruction: 0x01194297
 804:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 808:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 80c:	0b3a0e03 	bleq	e84020 <__bss_end+0xe7b104>
 810:	0b390b3b 	bleq	e43504 <__bss_end+0xe3a5e8>
 814:	01110e6e 	tsteq	r1, lr, ror #28
 818:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 81c:	00194296 	mulseq	r9, r6, r2
 820:	11010000 	mrsne	r0, (UNDEF: 1)
 824:	11061000 	mrsne	r1, (UNDEF: 6)
 828:	03011201 	movweq	r1, #4609	; 0x1201
 82c:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 830:	0005130e 	andeq	r1, r5, lr, lsl #6
 834:	11010000 	mrsne	r0, (UNDEF: 1)
 838:	11061000 	mrsne	r1, (UNDEF: 6)
 83c:	03011201 	movweq	r1, #4609	; 0x1201
 840:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 844:	0005130e 	andeq	r1, r5, lr, lsl #6
 848:	11010000 	mrsne	r0, (UNDEF: 1)
 84c:	130e2501 	movwne	r2, #58625	; 0xe501
 850:	1b0e030b 	blne	381484 <__bss_end+0x378568>
 854:	0017100e 	andseq	r1, r7, lr
 858:	00240200 	eoreq	r0, r4, r0, lsl #4
 85c:	0b3e0b0b 	bleq	f83490 <__bss_end+0xf7a574>
 860:	00000803 	andeq	r0, r0, r3, lsl #16
 864:	0b002403 	bleq	9878 <__bss_end+0x95c>
 868:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 86c:	0400000e 	streq	r0, [r0], #-14
 870:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 874:	0b3b0b3a 	bleq	ec3564 <__bss_end+0xeba648>
 878:	13490b39 	movtne	r0, #39737	; 0x9b39
 87c:	0f050000 	svceq	0x00050000
 880:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 884:	06000013 			; <UNDEFINED> instruction: 0x06000013
 888:	19270115 	stmdbne	r7!, {r0, r2, r4, r8}
 88c:	13011349 	movwne	r1, #4937	; 0x1349
 890:	05070000 	streq	r0, [r7, #-0]
 894:	00134900 	andseq	r4, r3, r0, lsl #18
 898:	00260800 	eoreq	r0, r6, r0, lsl #16
 89c:	34090000 	strcc	r0, [r9], #-0
 8a0:	3a0e0300 	bcc	3814a8 <__bss_end+0x37858c>
 8a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8a8:	3f13490b 	svccc	0x0013490b
 8ac:	00193c19 	andseq	r3, r9, r9, lsl ip
 8b0:	01040a00 	tsteq	r4, r0, lsl #20
 8b4:	0b3e0e03 	bleq	f840c8 <__bss_end+0xf7b1ac>
 8b8:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 8bc:	0b3b0b3a 	bleq	ec35ac <__bss_end+0xeba690>
 8c0:	13010b39 	movwne	r0, #6969	; 0x1b39
 8c4:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
 8c8:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 8cc:	0c00000b 	stceq	0, cr0, [r0], {11}
 8d0:	13490101 	movtne	r0, #37121	; 0x9101
 8d4:	00001301 	andeq	r1, r0, r1, lsl #6
 8d8:	0000210d 	andeq	r2, r0, sp, lsl #2
 8dc:	00260e00 	eoreq	r0, r6, r0, lsl #28
 8e0:	00001349 	andeq	r1, r0, r9, asr #6
 8e4:	0300340f 	movweq	r3, #1039	; 0x40f
 8e8:	3b0b3a0e 	blcc	2cf128 <__bss_end+0x2c620c>
 8ec:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 8f0:	3c193f13 	ldccc	15, cr3, [r9], {19}
 8f4:	10000019 	andne	r0, r0, r9, lsl r0
 8f8:	0e030013 	mcreq	0, 0, r0, cr3, cr3, {0}
 8fc:	0000193c 	andeq	r1, r0, ip, lsr r9
 900:	27001511 	smladcs	r0, r1, r5, r1
 904:	12000019 	andne	r0, r0, #25
 908:	0e030017 	mcreq	0, 0, r0, cr3, cr7, {0}
 90c:	0000193c 	andeq	r1, r0, ip, lsr r9
 910:	03011313 	movweq	r1, #4883	; 0x1313
 914:	3a0b0b0e 	bcc	2c3554 <__bss_end+0x2ba638>
 918:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 91c:	0013010b 	andseq	r0, r3, fp, lsl #2
 920:	000d1400 	andeq	r1, sp, r0, lsl #8
 924:	0b3a0e03 	bleq	e84138 <__bss_end+0xe7b21c>
 928:	0b39053b 	bleq	e41e1c <__bss_end+0xe38f00>
 92c:	0b381349 	bleq	e05658 <__bss_end+0xdfc73c>
 930:	21150000 	tstcs	r5, r0
 934:	2f134900 	svccs	0x00134900
 938:	1600000b 	strne	r0, [r0], -fp
 93c:	0e030104 	adfeqs	f0, f3, f4
 940:	0b0b0b3e 	bleq	2c3640 <__bss_end+0x2ba724>
 944:	0b3a1349 	bleq	e85670 <__bss_end+0xe7c754>
 948:	0b39053b 	bleq	e41e3c <__bss_end+0xe38f20>
 94c:	00001301 	andeq	r1, r0, r1, lsl #6
 950:	47003417 	smladmi	r0, r7, r4, r3
 954:	3b0b3a13 	blcc	2cf1a8 <__bss_end+0x2c628c>
 958:	020b3905 	andeq	r3, fp, #81920	; 0x14000
 95c:	00000018 	andeq	r0, r0, r8, lsl r0

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
  74:	00000114 	andeq	r0, r0, r4, lsl r1
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	0c780002 	ldcleq	0, cr0, [r8], #-8
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008348 	andeq	r8, r0, r8, asr #6
  94:	00000460 	andeq	r0, r0, r0, ror #8
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	19530002 	ldmdbne	r3, {r1}^
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	000087a8 	andeq	r8, r0, r8, lsr #15
  b4:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	1c850002 	stcne	0, cr0, [r5], {2}
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00008c60 	andeq	r8, r0, r0, ror #24
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	1cab0002 	stcne	0, cr0, [fp], #8
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00008e6c 	andeq	r8, r0, ip, ror #28
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	1cd10002 	ldclne	0, cr0, [r1], {2}
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff7030>
       4:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
       8:	6b69746e 	blvs	1a5d1c8 <__bss_end+0x1a542ac>
       c:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
      10:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
      14:	4f54522d 	svcmi	0x0054522d
      18:	616d2d53 	cmnvs	sp, r3, asr sp
      1c:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
      20:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffcf9 <__bss_end+0xffff6ddd>
      24:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
      28:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
      2c:	61707372 	cmnvs	r0, r2, ror r3
      30:	632f6563 			; <UNDEFINED> instruction: 0x632f6563
      34:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
      38:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
      3c:	2f656d6f 	svccs	0x00656d6f
      40:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
      44:	642f6b69 	strtvs	r6, [pc], #-2921	; 4c <shift+0x4c>
      48:	4b2f7665 	blmi	bdd9e4 <__bss_end+0xbd4ac8>
      4c:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
      50:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
      54:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
      58:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
      5c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
      60:	752f7365 	strvc	r7, [pc, #-869]!	; fffffd03 <__bss_end+0xffff6de7>
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
     268:	2b2b4320 	blcs	ad0ef0 <__bss_end+0xac7fd4>
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
     2fc:	6a363731 	bvs	d8dfc8 <__bss_end+0xd850ac>
     300:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     304:	616d2d20 	cmnvs	sp, r0, lsr #26
     308:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     30c:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     310:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     314:	7a36766d 	bvc	d9dcd0 <__bss_end+0xd94db4>
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
     3e0:	42007070 	andmi	r7, r0, #112	; 0x70
     3e4:	37355f52 			; <UNDEFINED> instruction: 0x37355f52
     3e8:	00303036 	eorseq	r3, r0, r6, lsr r0
     3ec:	6b636954 	blvs	18da944 <__bss_end+0x18d1a28>
     3f0:	756f435f 	strbvc	r4, [pc, #-863]!	; 99 <shift+0x99>
     3f4:	4900746e 	stmdbmi	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
     3f8:	6665646e 	strbtvs	r6, [r5], -lr, ror #8
     3fc:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     400:	704f0065 	subvc	r0, pc, r5, rrx
     404:	5f006e65 	svcpl	0x00006e65
     408:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     40c:	6f725043 	svcvs	0x00725043
     410:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     414:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     418:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     41c:	6c423132 	stfvse	f3, [r2], {50}	; 0x32
     420:	5f6b636f 	svcpl	0x006b636f
     424:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     428:	5f746e65 	svcpl	0x00746e65
     42c:	636f7250 	cmnvs	pc, #80, 4
     430:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     434:	554e0076 	strbpl	r0, [lr, #-118]	; 0xffffff8a
     438:	5f545241 	svcpl	0x00545241
     43c:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
     440:	6e654c5f 	mcrvs	12, 3, r4, cr5, cr15, {2}
     444:	00687467 	rsbeq	r7, r8, r7, ror #8
     448:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 394 <shift+0x394>
     44c:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     450:	6b69746e 	blvs	1a5d610 <__bss_end+0x1a546f4>
     454:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
     458:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
     45c:	4f54522d 	svcmi	0x0054522d
     460:	616d2d53 	cmnvs	sp, r3, asr sp
     464:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
     468:	756f732f 	strbvc	r7, [pc, #-815]!	; 141 <shift+0x141>
     46c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     470:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     474:	61707372 	cmnvs	r0, r2, ror r3
     478:	6c2f6563 	cfstr32vs	mvfx6, [pc], #-396	; 2f4 <shift+0x2f4>
     47c:	6567676f 	strbvs	r6, [r7, #-1903]!	; 0xfffff891
     480:	61745f72 	cmnvs	r4, r2, ror pc
     484:	6d2f6b73 	fstmdbxvs	pc!, {d6-d62}	;@ Deprecated
     488:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
     48c:	00707063 	rsbseq	r7, r0, r3, rrx
     490:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
     494:	4200676e 	andmi	r6, r0, #28835840	; 0x1b80000
     498:	34325f52 	ldrtcc	r5, [r2], #-3922	; 0xfffff0ae
     49c:	70003030 	andvc	r3, r0, r0, lsr r0
     4a0:	00766572 	rsbseq	r6, r6, r2, ror r5
     4a4:	314e5a5f 	cmpcc	lr, pc, asr sl
     4a8:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     4ac:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4b0:	614d5f73 	hvcvs	54771	; 0xd5f3
     4b4:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     4b8:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     4bc:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     4c0:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     4c4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4c8:	31504573 	cmpcc	r0, r3, ror r5
     4cc:	61545432 	cmpvs	r4, r2, lsr r4
     4d0:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
     4d4:	63757274 	cmnvs	r5, #116, 4	; 0x40000007
     4d8:	5a5f0074 	bpl	17c06b0 <__bss_end+0x17b7794>
     4dc:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
     4e0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     4e4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     4e8:	33316d65 	teqcc	r1, #6464	; 0x1940
     4ec:	5f534654 	svcpl	0x00534654
     4f0:	65657254 	strbvs	r7, [r5, #-596]!	; 0xfffffdac
     4f4:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 4fc <shift+0x4fc>
     4f8:	46303165 	ldrtmi	r3, [r0], -r5, ror #2
     4fc:	5f646e69 	svcpl	0x00646e69
     500:	6c696843 	stclvs	8, cr6, [r9], #-268	; 0xfffffef4
     504:	4b504564 	blmi	1411a9c <__bss_end+0x1408b80>
     508:	6e550063 	cdpvs	0, 5, cr0, cr5, cr3, {3}
     50c:	5f70616d 	svcpl	0x0070616d
     510:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     514:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     518:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     51c:	72506d00 	subsvc	r6, r0, #0, 26
     520:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     524:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     528:	485f7473 	ldmdami	pc, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     52c:	00646165 	rsbeq	r6, r4, r5, ror #2
     530:	64756162 	ldrbtvs	r6, [r5], #-354	; 0xfffffe9e
     534:	7461725f 	strbtvc	r7, [r1], #-607	; 0xfffffda1
     538:	5a5f0065 	bpl	17c06d4 <__bss_end+0x17b77b8>
     53c:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
     540:	6f725043 	svcvs	0x00725043
     544:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     548:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     54c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     550:	65473931 	strbvs	r3, [r7, #-2353]	; 0xfffff6cf
     554:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     558:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     55c:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     560:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     564:	00764573 	rsbseq	r4, r6, r3, ror r5
     568:	345f5242 	ldrbcc	r5, [pc], #-578	; 570 <shift+0x570>
     56c:	00303038 	eorseq	r3, r0, r8, lsr r0
     570:	7478656e 	ldrbtvc	r6, [r8], #-1390	; 0xfffffa92
     574:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     578:	6f72505f 	svcvs	0x0072505f
     57c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     580:	5f79425f 	svcpl	0x0079425f
     584:	00444950 	subeq	r4, r4, r0, asr r9
     588:	6e756f6d 	cdpvs	15, 7, cr6, cr5, cr13, {3}
     58c:	696f5074 	stmdbvs	pc!, {r2, r4, r5, r6, ip, lr}^	; <UNPREDICTABLE>
     590:	6900746e 	stmdbvs	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
     594:	72694473 	rsbvc	r4, r9, #1929379840	; 0x73000000
     598:	6f746365 	svcvs	0x00746365
     59c:	4e007972 			; <UNDEFINED> instruction: 0x4e007972
     5a0:	5f495753 	svcpl	0x00495753
     5a4:	636f7250 	cmnvs	pc, #80, 4
     5a8:	5f737365 	svcpl	0x00737365
     5ac:	76726553 			; <UNDEFINED> instruction: 0x76726553
     5b0:	00656369 	rsbeq	r6, r5, r9, ror #6
     5b4:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     5b8:	74634100 	strbtvc	r4, [r3], #-256	; 0xffffff00
     5bc:	5f657669 	svcpl	0x00657669
     5c0:	636f7250 	cmnvs	pc, #80, 4
     5c4:	5f737365 	svcpl	0x00737365
     5c8:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     5cc:	72430074 	subvc	r0, r3, #116	; 0x74
     5d0:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     5d4:	6f72505f 	svcvs	0x0072505f
     5d8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     5dc:	72617000 	rsbvc	r7, r1, #0
     5e0:	00746e65 	rsbseq	r6, r4, r5, ror #28
     5e4:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
     5e8:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
     5ec:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
     5f0:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     5f4:	65470068 	strbvs	r0, [r7, #-104]	; 0xffffff98
     5f8:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     5fc:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     600:	5f72656c 	svcpl	0x0072656c
     604:	6f666e49 	svcvs	0x00666e49
     608:	61654400 	cmnvs	r5, r0, lsl #8
     60c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     610:	6e555f65 	cdpvs	15, 5, cr5, cr5, cr5, {3}
     614:	6e616863 	cdpvs	8, 6, cr6, cr1, cr3, {3}
     618:	00646567 	rsbeq	r6, r4, r7, ror #10
     61c:	6f725043 	svcvs	0x00725043
     620:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     624:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     628:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     62c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     630:	46433131 			; <UNDEFINED> instruction: 0x46433131
     634:	73656c69 	cmnvc	r5, #26880	; 0x6900
     638:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     63c:	4534436d 	ldrmi	r4, [r4, #-877]!	; 0xfffffc93
     640:	46540076 			; <UNDEFINED> instruction: 0x46540076
     644:	72445f53 	subvc	r5, r4, #332	; 0x14c
     648:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     64c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     650:	50433631 	subpl	r3, r3, r1, lsr r6
     654:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     658:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 494 <shift+0x494>
     65c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     660:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     664:	5f746547 	svcpl	0x00746547
     668:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     66c:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     670:	6e495f72 	mcrvs	15, 2, r5, cr9, cr2, {3}
     674:	32456f66 	subcc	r6, r5, #408	; 0x198
     678:	65474e30 	strbvs	r4, [r7, #-3632]	; 0xfffff1d0
     67c:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     680:	5f646568 	svcpl	0x00646568
     684:	6f666e49 	svcvs	0x00666e49
     688:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     68c:	00765065 	rsbseq	r5, r6, r5, rrx
     690:	314e5a5f 	cmpcc	lr, pc, asr sl
     694:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     698:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     69c:	614d5f73 	hvcvs	54771	; 0xd5f3
     6a0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     6a4:	48313272 	ldmdami	r1!, {r1, r4, r5, r6, r9, ip, sp}
     6a8:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     6ac:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     6b0:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     6b4:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     6b8:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     6bc:	4e333245 	cdpmi	2, 3, cr3, cr3, cr5, {2}
     6c0:	5f495753 	svcpl	0x00495753
     6c4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     6c8:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     6cc:	535f6d65 	cmppl	pc, #6464	; 0x1940
     6d0:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     6d4:	6a6a6563 	bvs	1a99c68 <__bss_end+0x1a90d4c>
     6d8:	3131526a 	teqcc	r1, sl, ror #4
     6dc:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
     6e0:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     6e4:	00746c75 	rsbseq	r6, r4, r5, ror ip
     6e8:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
     6ec:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
     6f0:	73656c69 	cmnvc	r5, #26880	; 0x6900
     6f4:	746f4e00 	strbtvc	r4, [pc], #-3584	; 6fc <shift+0x6fc>
     6f8:	41796669 	cmnmi	r9, r9, ror #12
     6fc:	54006c6c 	strpl	r6, [r0], #-3180	; 0xfffff394
     700:	5f555043 	svcpl	0x00555043
     704:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     708:	00747865 	rsbseq	r7, r4, r5, ror #16
     70c:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     710:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     714:	62747400 	rsbsvs	r7, r4, #0, 8
     718:	5f003072 	svcpl	0x00003072
     71c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     720:	6f725043 	svcvs	0x00725043
     724:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     728:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     72c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     730:	6f4e3431 	svcvs	0x004e3431
     734:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     738:	6f72505f 	svcvs	0x0072505f
     73c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     740:	47006a45 	strmi	r6, [r0, -r5, asr #20]
     744:	505f7465 	subspl	r7, pc, r5, ror #8
     748:	46004449 	strmi	r4, [r0], -r9, asr #8
     74c:	5f646e69 	svcpl	0x00646e69
     750:	6c696843 	stclvs	8, cr6, [r9], #-268	; 0xfffffef4
     754:	6f6e0064 	svcvs	0x006e0064
     758:	69666974 	stmdbvs	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     75c:	645f6465 	ldrbvs	r6, [pc], #-1125	; 764 <shift+0x764>
     760:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     764:	00656e69 	rsbeq	r6, r5, r9, ror #28
     768:	5241554e 	subpl	r5, r1, #327155712	; 0x13800000
     76c:	61425f54 	cmpvs	r2, r4, asr pc
     770:	525f6475 	subspl	r6, pc, #1962934272	; 0x75000000
     774:	00657461 	rsbeq	r7, r5, r1, ror #8
     778:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
     77c:	4300375f 	movwmi	r3, #1887	; 0x75f
     780:	5f726168 	svcpl	0x00726168
     784:	614d0038 	cmpvs	sp, r8, lsr r0
     788:	72505f78 	subsvc	r5, r0, #120, 30	; 0x1e0
     78c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     790:	704f5f73 	subvc	r5, pc, r3, ror pc	; <UNPREDICTABLE>
     794:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     798:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     79c:	5f007365 	svcpl	0x00007365
     7a0:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     7a4:	6f725043 	svcvs	0x00725043
     7a8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     7ac:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     7b0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     7b4:	6e553831 	mrcvs	8, 2, r3, cr5, cr1, {1}
     7b8:	5f70616d 	svcpl	0x0070616d
     7bc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     7c0:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     7c4:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     7c8:	67006a45 	strvs	r6, [r0, -r5, asr #20]
     7cc:	445f5346 	ldrbmi	r5, [pc], #-838	; 7d4 <shift+0x7d4>
     7d0:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     7d4:	435f7372 	cmpmi	pc, #-939524095	; 0xc8000001
     7d8:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     7dc:	6f526d00 	svcvs	0x00526d00
     7e0:	535f746f 	cmppl	pc, #1862270976	; 0x6f000000
     7e4:	47007379 	smlsdxmi	r0, r9, r3, r7
     7e8:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     7ec:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     7f0:	505f746e 	subspl	r7, pc, lr, ror #8
     7f4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     7f8:	4d007373 	stcmi	3, cr7, [r0, #-460]	; 0xfffffe34
     7fc:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     800:	5f656c69 	svcpl	0x00656c69
     804:	435f6f54 	cmpmi	pc, #84, 30	; 0x150
     808:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     80c:	4e00746e 	cdpmi	4, 0, cr7, cr0, cr14, {3}
     810:	6c69466f 	stclvs	6, cr4, [r9], #-444	; 0xfffffe44
     814:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     818:	446d6574 	strbtmi	r6, [sp], #-1396	; 0xfffffa8c
     81c:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     820:	65530072 	ldrbvs	r0, [r3, #-114]	; 0xffffff8e
     824:	61505f74 	cmpvs	r0, r4, ror pc
     828:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     82c:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     830:	5f656c64 	svcpl	0x00656c64
     834:	636f7250 	cmnvs	pc, #80, 4
     838:	5f737365 	svcpl	0x00737365
     83c:	00495753 	subeq	r5, r9, r3, asr r7
     840:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     844:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
     848:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     84c:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
     850:	5300746e 	movwpl	r7, #1134	; 0x46e
     854:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     858:	5f656c75 	svcpl	0x00656c75
     85c:	00464445 	subeq	r4, r6, r5, asr #8
     860:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     864:	73694400 	cmnvc	r9, #0, 8
     868:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     86c:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     870:	445f746e 	ldrbmi	r7, [pc], #-1134	; 878 <shift+0x878>
     874:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     878:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     87c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     880:	46433131 			; <UNDEFINED> instruction: 0x46433131
     884:	73656c69 	cmnvc	r5, #26880	; 0x6900
     888:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     88c:	4930316d 	ldmdbmi	r0!, {r0, r2, r3, r5, r6, r8, ip, sp}
     890:	6974696e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, fp, sp, lr}^
     894:	7a696c61 	bvc	1a5ba20 <__bss_end+0x1a52b04>
     898:	00764565 	rsbseq	r4, r6, r5, ror #10
     89c:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     8a0:	70757272 	rsbsvc	r7, r5, r2, ror r2
     8a4:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
     8a8:	6c535f65 	mrrcvs	15, 6, r5, r3, cr5
     8ac:	00706565 	rsbseq	r6, r0, r5, ror #10
     8b0:	6f6f526d 	svcvs	0x006f526d
     8b4:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     8b8:	6f620076 	svcvs	0x00620076
     8bc:	6d006c6f 	stcvs	12, cr6, [r0, #-444]	; 0xfffffe44
     8c0:	7473614c 	ldrbtvc	r6, [r3], #-332	; 0xfffffeb4
     8c4:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     8c8:	6f6c4200 	svcvs	0x006c4200
     8cc:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     8d0:	65474e00 	strbvs	r4, [r7, #-3584]	; 0xfffff200
     8d4:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     8d8:	5f646568 	svcpl	0x00646568
     8dc:	6f666e49 	svcvs	0x00666e49
     8e0:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     8e4:	75520065 	ldrbvc	r0, [r2, #-101]	; 0xffffff9b
     8e8:	62616e6e 	rsbvs	r6, r1, #1760	; 0x6e0
     8ec:	4e00656c 	cfsh32mi	mvfx6, mvfx0, #60
     8f0:	6b736154 	blvs	1cd8e48 <__bss_end+0x1ccff2c>
     8f4:	6174535f 	cmnvs	r4, pc, asr r3
     8f8:	42006574 	andmi	r6, r0, #116, 10	; 0x1d000000
     8fc:	38335f52 	ldmdacc	r3!, {r1, r4, r6, r8, r9, sl, fp, ip, lr}
     900:	00303034 	eorseq	r3, r0, r4, lsr r0
     904:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     908:	6f635f64 	svcvs	0x00635f64
     90c:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
     910:	63730072 	cmnvs	r3, #114	; 0x72
     914:	5f646568 	svcpl	0x00646568
     918:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
     91c:	705f6369 	subsvc	r6, pc, r9, ror #6
     920:	726f6972 	rsbvc	r6, pc, #1867776	; 0x1c8000
     924:	00797469 	rsbseq	r7, r9, r9, ror #8
     928:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
     92c:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     930:	6700657a 	smlsdxvs	r0, sl, r5, r6
     934:	445f5346 	ldrbmi	r5, [pc], #-838	; 93c <shift+0x93c>
     938:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     93c:	65007372 	strvs	r7, [r0, #-882]	; 0xfffffc8e
     940:	5f746978 	svcpl	0x00746978
     944:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     948:	65676600 	strbvs	r6, [r7, #-1536]!	; 0xfffffa00
     94c:	42007374 	andmi	r7, r0, #116, 6	; 0xd0000001
     950:	31315f52 	teqcc	r1, r2, asr pc
     954:	30303235 	eorscc	r3, r0, r5, lsr r2
     958:	63536d00 	cmpvs	r3, #0, 26
     95c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     960:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     964:	4d00636e 	stcmi	3, cr6, [r0, #-440]	; 0xfffffe48
     968:	53467861 	movtpl	r7, #26721	; 0x6861
     96c:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     970:	614e7265 	cmpvs	lr, r5, ror #4
     974:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     978:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     97c:	746f4e00 	strbtvc	r4, [pc], #-3584	; 984 <shift+0x984>
     980:	00796669 	rsbseq	r6, r9, r9, ror #12
     984:	6b636f4c 	blvs	18dc6bc <__bss_end+0x18d37a0>
     988:	6c6e555f 	cfstr64vs	mvdx5, [lr], #-380	; 0xfffffe84
     98c:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     990:	70660064 	rsbvc	r0, r6, r4, rrx
     994:	00737475 	rsbseq	r7, r3, r5, ror r4
     998:	6b636f4c 	blvs	18dc6d0 <__bss_end+0x18d37b4>
     99c:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     9a0:	0064656b 	rsbeq	r6, r4, fp, ror #10
     9a4:	52415554 	subpl	r5, r1, #84, 10	; 0x15000000
     9a8:	4f495f54 	svcmi	0x00495f54
     9ac:	5f6c7443 	svcpl	0x006c7443
     9b0:	61726150 	cmnvs	r2, r0, asr r1
     9b4:	5200736d 	andpl	r7, r0, #-1275068415	; 0xb4000001
     9b8:	5f646165 	svcpl	0x00646165
     9bc:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     9c0:	6f5a0065 	svcvs	0x005a0065
     9c4:	6569626d 	strbvs	r6, [r9, #-621]!	; 0xfffffd93
     9c8:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     9cc:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     9d0:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     9d4:	006f666e 	rsbeq	r6, pc, lr, ror #12
     9d8:	314e5a5f 	cmpcc	lr, pc, asr sl
     9dc:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     9e0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     9e4:	614d5f73 	hvcvs	54771	; 0xd5f3
     9e8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     9ec:	63533872 	cmpvs	r3, #7471104	; 0x720000
     9f0:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     9f4:	7645656c 	strbvc	r6, [r5], -ip, ror #10
     9f8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     9fc:	50433631 	subpl	r3, r3, r1, lsr r6
     a00:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     a04:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 840 <shift+0x840>
     a08:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     a0c:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     a10:	5f70614d 	svcpl	0x0070614d
     a14:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     a18:	5f6f545f 	svcpl	0x006f545f
     a1c:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     a20:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
     a24:	46493550 			; <UNDEFINED> instruction: 0x46493550
     a28:	00656c69 	rsbeq	r6, r5, r9, ror #24
     a2c:	5f746547 	svcpl	0x00746547
     a30:	61726150 	cmnvs	r2, r0, asr r1
     a34:	6300736d 	movwvs	r7, #877	; 0x36d
     a38:	646c6968 	strbtvs	r6, [ip], #-2408	; 0xfffff698
     a3c:	006e6572 	rsbeq	r6, lr, r2, ror r5
     a40:	5078614d 	rsbspl	r6, r8, sp, asr #2
     a44:	4c687461 	cfstrdmi	mvd7, [r8], #-388	; 0xfffffe7c
     a48:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     a4c:	6e750068 	cdpvs	0, 7, cr0, cr5, cr8, {3}
     a50:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     a54:	63206465 			; <UNDEFINED> instruction: 0x63206465
     a58:	00726168 	rsbseq	r6, r2, r8, ror #2
     a5c:	314e5a5f 	cmpcc	lr, pc, asr sl
     a60:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     a64:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     a68:	614d5f73 	hvcvs	54771	; 0xd5f3
     a6c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     a70:	53323172 	teqpl	r2, #-2147483620	; 0x8000001c
     a74:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     a78:	5f656c75 	svcpl	0x00656c75
     a7c:	45464445 	strbmi	r4, [r6, #-1093]	; 0xfffffbbb
     a80:	46430076 			; <UNDEFINED> instruction: 0x46430076
     a84:	73656c69 	cmnvc	r5, #26880	; 0x6900
     a88:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     a8c:	6873006d 	ldmdavs	r3!, {r0, r2, r3, r5, r6}^
     a90:	2074726f 	rsbscs	r7, r4, pc, ror #4
     a94:	00746e69 	rsbseq	r6, r4, r9, ror #28
     a98:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
     a9c:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     aa0:	6e450065 	cdpvs	0, 4, cr0, cr5, cr5, {3}
     aa4:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     aa8:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     aac:	445f746e 	ldrbmi	r7, [pc], #-1134	; ab4 <shift+0xab4>
     ab0:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     ab4:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     ab8:	6f526d00 	svcvs	0x00526d00
     abc:	7300746f 	movwvc	r7, #1135	; 0x46f
     ac0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     ac4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     ac8:	52006d65 	andpl	r6, r0, #6464	; 0x1940
     acc:	696e6e75 	stmdbvs	lr!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     ad0:	7500676e 	strvc	r6, [r0, #-1902]	; 0xfffff892
     ad4:	33746e69 	cmncc	r4, #1680	; 0x690
     ad8:	00745f32 	rsbseq	r5, r4, r2, lsr pc
     adc:	7275436d 	rsbsvc	r4, r5, #-1275068415	; 0xb4000001
     ae0:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     ae4:	7361545f 	cmnvc	r1, #1593835520	; 0x5f000000
     ae8:	6f4e5f6b 	svcvs	0x004e5f6b
     aec:	5f006564 	svcpl	0x00006564
     af0:	31314e5a 	teqcc	r1, sl, asr lr
     af4:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     af8:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     afc:	346d6574 	strbtcc	r6, [sp], #-1396	; 0xfffffa8c
     b00:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     b04:	634b5045 	movtvs	r5, #45125	; 0xb045
     b08:	464e3531 			; <UNDEFINED> instruction: 0x464e3531
     b0c:	5f656c69 	svcpl	0x00656c69
     b10:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     b14:	646f4d5f 	strbtvs	r4, [pc], #-3423	; b1c <shift+0xb1c>
     b18:	68630065 	stmdavs	r3!, {r0, r2, r5, r6}^
     b1c:	6c5f7261 	lfmvs	f7, 2, [pc], {97}	; 0x61
     b20:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     b24:	61700068 	cmnvs	r0, r8, rrx
     b28:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     b2c:	69726400 	ldmdbvs	r2!, {sl, sp, lr}^
     b30:	5f726576 	svcpl	0x00726576
     b34:	00786469 	rsbseq	r6, r8, r9, ror #8
     b38:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     b3c:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
     b40:	6c730079 	ldclvs	0, cr0, [r3], #-484	; 0xfffffe1c
     b44:	5f706565 	svcpl	0x00706565
     b48:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     b4c:	5a5f0072 	bpl	17c0d1c <__bss_end+0x17b7e00>
     b50:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
     b54:	6f725043 	svcvs	0x00725043
     b58:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b5c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     b60:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     b64:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     b68:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     b6c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     b70:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     b74:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     b78:	48006a45 	stmdami	r0, {r0, r2, r6, r9, fp, sp, lr}
     b7c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     b80:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     b84:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     b88:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     b8c:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     b90:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     b94:	50433631 	subpl	r3, r3, r1, lsr r6
     b98:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     b9c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 9d8 <shift+0x9d8>
     ba0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     ba4:	31317265 	teqcc	r1, r5, ror #4
     ba8:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     bac:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     bb0:	4552525f 	ldrbmi	r5, [r2, #-607]	; 0xfffffda1
     bb4:	61740076 	cmnvs	r4, r6, ror r0
     bb8:	42006b73 	andmi	r6, r0, #117760	; 0x1cc00
     bbc:	39315f52 	ldmdbcc	r1!, {r1, r4, r6, r8, r9, sl, fp, ip, lr}
     bc0:	00303032 	eorseq	r3, r0, r2, lsr r0
     bc4:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     bc8:	505f7966 	subspl	r7, pc, r6, ror #18
     bcc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     bd0:	53007373 	movwpl	r7, #883	; 0x373
     bd4:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     bd8:	00656c75 	rsbeq	r6, r5, r5, ror ip
     bdc:	6f725073 	svcvs	0x00725073
     be0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     be4:	0072674d 	rsbseq	r6, r2, sp, asr #14
     be8:	314e5a5f 	cmpcc	lr, pc, asr sl
     bec:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     bf0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     bf4:	614d5f73 	hvcvs	54771	; 0xd5f3
     bf8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     bfc:	77533972 			; <UNDEFINED> instruction: 0x77533972
     c00:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     c04:	456f545f 	strbmi	r5, [pc, #-1119]!	; 7ad <shift+0x7ad>
     c08:	43383150 	teqmi	r8, #80, 2
     c0c:	636f7250 	cmnvs	pc, #80, 4
     c10:	5f737365 	svcpl	0x00737365
     c14:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
     c18:	646f4e5f 	strbtvs	r4, [pc], #-3679	; c20 <shift+0xc20>
     c1c:	63530065 	cmpvs	r3, #101	; 0x65
     c20:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     c24:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
     c28:	5a5f0052 	bpl	17c0d78 <__bss_end+0x17b7e5c>
     c2c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     c30:	636f7250 	cmnvs	pc, #80, 4
     c34:	5f737365 	svcpl	0x00737365
     c38:	616e614d 	cmnvs	lr, sp, asr #2
     c3c:	31726567 	cmncc	r2, r7, ror #10
     c40:	6e614838 	mcrvs	8, 3, r4, cr1, cr8, {1}
     c44:	5f656c64 	svcpl	0x00656c64
     c48:	636f7250 	cmnvs	pc, #80, 4
     c4c:	5f737365 	svcpl	0x00737365
     c50:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
     c54:	534e3032 	movtpl	r3, #57394	; 0xe032
     c58:	505f4957 	subspl	r4, pc, r7, asr r9	; <UNPREDICTABLE>
     c5c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     c60:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     c64:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     c68:	6a6a6563 	bvs	1a9a1fc <__bss_end+0x1a912e0>
     c6c:	3131526a 	teqcc	r1, sl, ror #4
     c70:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
     c74:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     c78:	00746c75 	rsbseq	r6, r4, r5, ror ip
     c7c:	76677261 	strbtvc	r7, [r7], -r1, ror #4
     c80:	4f494e00 	svcmi	0x00494e00
     c84:	5f6c7443 	svcpl	0x006c7443
     c88:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
     c8c:	6f697461 	svcvs	0x00697461
     c90:	5a5f006e 	bpl	17c0e50 <__bss_end+0x17b7f34>
     c94:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     c98:	636f7250 	cmnvs	pc, #80, 4
     c9c:	5f737365 	svcpl	0x00737365
     ca0:	616e614d 	cmnvs	lr, sp, asr #2
     ca4:	31726567 	cmncc	r2, r7, ror #10
     ca8:	65724334 	ldrbvs	r4, [r2, #-820]!	; 0xfffffccc
     cac:	5f657461 	svcpl	0x00657461
     cb0:	636f7250 	cmnvs	pc, #80, 4
     cb4:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     cb8:	626a6850 	rsbvs	r6, sl, #80, 16	; 0x500000
     cbc:	69775300 	ldmdbvs	r7!, {r8, r9, ip, lr}^
     cc0:	5f686374 	svcpl	0x00686374
     cc4:	4e006f54 	mcrmi	15, 0, r6, cr0, cr4, {2}
     cc8:	5f495753 	svcpl	0x00495753
     ccc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     cd0:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     cd4:	535f6d65 	cmppl	pc, #6464	; 0x1940
     cd8:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     cdc:	42006563 	andmi	r6, r0, #415236096	; 0x18c00000
     ce0:	32315f52 	eorscc	r5, r1, #328	; 0x148
     ce4:	49003030 	stmdbmi	r0, {r4, r5, ip, sp}
     ce8:	6c61766e 	stclvs	6, cr7, [r1], #-440	; 0xfffffe48
     cec:	485f6469 	ldmdami	pc, {r0, r3, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     cf0:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     cf4:	46540065 	ldrbmi	r0, [r4], -r5, rrx
     cf8:	72545f53 	subsvc	r5, r4, #332	; 0x14c
     cfc:	4e5f6565 	cdpmi	5, 5, cr6, cr15, cr5, {3}
     d00:	0065646f 	rsbeq	r6, r5, pc, ror #8
     d04:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     d08:	75435f6b 	strbvc	r5, [r3, #-3947]	; 0xfffff095
     d0c:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     d10:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     d14:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     d18:	52420073 	subpl	r0, r2, #115	; 0x73
     d1c:	3036395f 	eorscc	r3, r6, pc, asr r9
     d20:	6c430030 	mcrrvs	0, 3, r0, r3, cr0
     d24:	0065736f 	rsbeq	r7, r5, pc, ror #6
     d28:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     d2c:	61007265 	tstvs	r0, r5, ror #4
     d30:	00636772 	rsbeq	r6, r3, r2, ror r7
     d34:	6c694649 	stclvs	6, cr4, [r9], #-292	; 0xfffffedc
     d38:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     d3c:	5f6d6574 	svcpl	0x006d6574
     d40:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     d44:	57007265 	strpl	r7, [r0, -r5, ror #4]
     d48:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     d4c:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
     d50:	616d0079 	smcvs	53257	; 0xd009
     d54:	59006e69 	stmdbpl	r0, {r0, r3, r5, r6, r9, sl, fp, sp, lr}
     d58:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
     d5c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     d60:	50433631 	subpl	r3, r3, r1, lsr r6
     d64:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     d68:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; ba4 <shift+0xba4>
     d6c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     d70:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
     d74:	6d007645 	stcvs	6, cr7, [r0, #-276]	; 0xfffffeec
     d78:	746f6f52 	strbtvc	r6, [pc], #-3922	; d80 <shift+0xd80>
     d7c:	746e4d5f 	strbtvc	r4, [lr], #-3423	; 0xfffff2a1
     d80:	75706300 	ldrbvc	r6, [r0, #-768]!	; 0xfffffd00
     d84:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
     d88:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     d8c:	72655400 	rsbvc	r5, r5, #0, 8
     d90:	616e696d 	cmnvs	lr, sp, ror #18
     d94:	49006574 	stmdbmi	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
     d98:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     d9c:	6f6c6300 	svcvs	0x006c6300
     da0:	53006573 	movwpl	r6, #1395	; 0x573
     da4:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
     da8:	74616c65 	strbtvc	r6, [r1], #-3173	; 0xfffff39b
     dac:	00657669 	rsbeq	r7, r5, r9, ror #12
     db0:	20554e47 	subscs	r4, r5, r7, asr #28
     db4:	312b2b43 			; <UNDEFINED> instruction: 0x312b2b43
     db8:	2e382034 	mrccs	0, 1, r2, cr8, cr4, {1}
     dbc:	20312e33 	eorscs	r2, r1, r3, lsr lr
     dc0:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
     dc4:	33303730 	teqcc	r0, #48, 14	; 0xc00000
     dc8:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
     dcc:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
     dd0:	5b202965 	blpl	80b36c <__bss_end+0x802450>
     dd4:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
     dd8:	72622d38 	rsbvc	r2, r2, #56, 26	; 0xe00
     ddc:	68636e61 	stmdavs	r3!, {r0, r5, r6, r9, sl, fp, sp, lr}^
     de0:	76657220 	strbtvc	r7, [r5], -r0, lsr #4
     de4:	6f697369 	svcvs	0x00697369
     de8:	3732206e 	ldrcc	r2, [r2, -lr, rrx]!
     dec:	37323033 			; <UNDEFINED> instruction: 0x37323033
     df0:	6d2d205d 	stcvs	0, cr2, [sp, #-372]!	; 0xfffffe8c
     df4:	616f6c66 	cmnvs	pc, r6, ror #24
     df8:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
     dfc:	61683d69 	cmnvs	r8, r9, ror #26
     e00:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
     e04:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
     e08:	7066763d 	rsbvc	r7, r6, sp, lsr r6
     e0c:	746d2d20 	strbtvc	r2, [sp], #-3360	; 0xfffff2e0
     e10:	3d656e75 	stclcc	14, cr6, [r5, #-468]!	; 0xfffffe2c
     e14:	316d7261 	cmncc	sp, r1, ror #4
     e18:	6a363731 	bvs	d8eae4 <__bss_end+0xd85bc8>
     e1c:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     e20:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     e24:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     e28:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
     e2c:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
     e30:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
     e34:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
     e38:	20706676 	rsbscs	r6, r0, r6, ror r6
     e3c:	75746d2d 	ldrbvc	r6, [r4, #-3373]!	; 0xfffff2d3
     e40:	613d656e 	teqvs	sp, lr, ror #10
     e44:	31316d72 	teqcc	r1, r2, ror sp
     e48:	7a6a3637 	bvc	1a8e72c <__bss_end+0x1a85810>
     e4c:	20732d66 	rsbscs	r2, r3, r6, ror #26
     e50:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     e54:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
     e58:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     e5c:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     e60:	6b7a3676 	blvs	1e8e840 <__bss_end+0x1e85924>
     e64:	2070662b 	rsbscs	r6, r0, fp, lsr #12
     e68:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     e6c:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     e70:	304f2d20 	subcc	r2, pc, r0, lsr #26
     e74:	304f2d20 	subcc	r2, pc, r0, lsr #26
     e78:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
     e7c:	78652d6f 	stmdavc	r5!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp}^
     e80:	74706563 	ldrbtvc	r6, [r0], #-1379	; 0xfffffa9d
     e84:	736e6f69 	cmnvc	lr, #420	; 0x1a4
     e88:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
     e8c:	74722d6f 	ldrbtvc	r2, [r2], #-3439	; 0xfffff291
     e90:	72006974 	andvc	r6, r0, #116, 18	; 0x1d0000
     e94:	61767465 	cmnvs	r6, r5, ror #8
     e98:	636e006c 	cmnvs	lr, #108	; 0x6c
     e9c:	70007275 	andvc	r7, r0, r5, ror r2
     ea0:	00657069 	rsbeq	r7, r5, r9, rrx
     ea4:	756e6472 	strbvc	r6, [lr, #-1138]!	; 0xfffffb8e
     ea8:	5a5f006d 	bpl	17c1064 <__bss_end+0x17b8148>
     eac:	63733131 	cmnvs	r3, #1073741836	; 0x4000000c
     eb0:	5f646568 	svcpl	0x00646568
     eb4:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
     eb8:	5f007664 	svcpl	0x00007664
     ebc:	7337315a 	teqvc	r7, #-2147483626	; 0x80000016
     ec0:	745f7465 	ldrbvc	r7, [pc], #-1125	; ec8 <shift+0xec8>
     ec4:	5f6b7361 	svcpl	0x006b7361
     ec8:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     ecc:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     ed0:	6177006a 	cmnvs	r7, sl, rrx
     ed4:	5f007469 	svcpl	0x00007469
     ed8:	6f6e365a 	svcvs	0x006e365a
     edc:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     ee0:	5f006a6a 	svcpl	0x00006a6a
     ee4:	6574395a 	ldrbvs	r3, [r4, #-2394]!	; 0xfffff6a6
     ee8:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
     eec:	69657461 	stmdbvs	r5!, {r0, r5, r6, sl, ip, sp, lr}^
     ef0:	6f682f00 	svcvs	0x00682f00
     ef4:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
     ef8:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
     efc:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
     f00:	494b2f76 	stmdbmi	fp, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
     f04:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
     f08:	6d2d534f 	stcvs	3, cr5, [sp, #-316]!	; 0xfffffec4
     f0c:	65747361 	ldrbvs	r7, [r4, #-865]!	; 0xfffffc9f
     f10:	6f732f72 	svcvs	0x00732f72
     f14:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     f18:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
     f1c:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     f20:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     f24:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     f28:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     f2c:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     f30:	69614600 	stmdbvs	r1!, {r9, sl, lr}^
     f34:	7865006c 	stmdavc	r5!, {r2, r3, r5, r6}^
     f38:	6f637469 	svcvs	0x00637469
     f3c:	5f006564 	svcpl	0x00006564
     f40:	6734325a 			; <UNDEFINED> instruction: 0x6734325a
     f44:	615f7465 	cmpvs	pc, r5, ror #8
     f48:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     f4c:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
     f50:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     f54:	6f635f73 	svcvs	0x00635f73
     f58:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
     f5c:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     f60:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     f64:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
     f68:	63697400 	cmnvs	r9, #0, 8
     f6c:	6f635f6b 	svcvs	0x00635f6b
     f70:	5f746e75 	svcpl	0x00746e75
     f74:	75716572 	ldrbvc	r6, [r1, #-1394]!	; 0xfffffa8e
     f78:	64657269 	strbtvs	r7, [r5], #-617	; 0xfffffd97
     f7c:	70695000 	rsbvc	r5, r9, r0
     f80:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     f84:	505f656c 	subspl	r6, pc, ip, ror #10
     f88:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     f8c:	5a5f0078 	bpl	17c1174 <__bss_end+0x17b8258>
     f90:	65673431 	strbvs	r3, [r7, #-1073]!	; 0xfffffbcf
     f94:	69745f74 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     f98:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
     f9c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     fa0:	6c730076 	ldclvs	0, cr0, [r3], #-472	; 0xfffffe28
     fa4:	00706565 	rsbseq	r6, r0, r5, ror #10
     fa8:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ef4 <shift+0xef4>
     fac:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     fb0:	6b69746e 	blvs	1a5e170 <__bss_end+0x1a55254>
     fb4:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
     fb8:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
     fbc:	4f54522d 	svcmi	0x0054522d
     fc0:	616d2d53 	cmnvs	sp, r3, asr sp
     fc4:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
     fc8:	756f732f 	strbvc	r7, [pc, #-815]!	; ca1 <shift+0xca1>
     fcc:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     fd0:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
     fd4:	6f00646c 	svcvs	0x0000646c
     fd8:	61726570 	cmnvs	r2, r0, ror r5
     fdc:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     fe0:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     fe4:	736f6c63 	cmnvc	pc, #25344	; 0x6300
     fe8:	5f006a65 	svcpl	0x00006a65
     fec:	6567365a 	strbvs	r3, [r7, #-1626]!	; 0xfffff9a6
     ff0:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
     ff4:	6e660076 	mcrvs	0, 3, r0, cr6, cr6, {3}
     ff8:	00656d61 	rsbeq	r6, r5, r1, ror #26
     ffc:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1000:	74007966 	strvc	r7, [r0], #-2406	; 0xfffff69a
    1004:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
    1008:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
    100c:	5a5f006e 	bpl	17c11cc <__bss_end+0x17b82b0>
    1010:	70697034 	rsbvc	r7, r9, r4, lsr r0
    1014:	634b5065 	movtvs	r5, #45157	; 0xb065
    1018:	444e006a 	strbmi	r0, [lr], #-106	; 0xffffff96
    101c:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    1020:	5f656e69 	svcpl	0x00656e69
    1024:	73627553 	cmnvc	r2, #348127232	; 0x14c00000
    1028:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    102c:	67006563 	strvs	r6, [r0, -r3, ror #10]
    1030:	745f7465 	ldrbvc	r7, [pc], #-1125	; 1038 <shift+0x1038>
    1034:	5f6b6369 	svcpl	0x006b6369
    1038:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    103c:	61700074 	cmnvs	r0, r4, ror r0
    1040:	006d6172 	rsbeq	r6, sp, r2, ror r1
    1044:	77355a5f 			; <UNDEFINED> instruction: 0x77355a5f
    1048:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    104c:	634b506a 	movtvs	r5, #45162	; 0xb06a
    1050:	6567006a 	strbvs	r0, [r7, #-106]!	; 0xffffff96
    1054:	61745f74 	cmnvs	r4, r4, ror pc
    1058:	745f6b73 	ldrbvc	r6, [pc], #-2931	; 1060 <shift+0x1060>
    105c:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
    1060:	5f6f745f 	svcpl	0x006f745f
    1064:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
    1068:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    106c:	66756200 	ldrbtvs	r6, [r5], -r0, lsl #4
    1070:	7a69735f 	bvc	1a5ddf4 <__bss_end+0x1a54ed8>
    1074:	72770065 	rsbsvc	r0, r7, #101	; 0x65
    1078:	00657469 	rsbeq	r7, r5, r9, ror #8
    107c:	5f746573 	svcpl	0x00746573
    1080:	6b736174 	blvs	1cd9658 <__bss_end+0x1cd073c>
    1084:	6165645f 	cmnvs	r5, pc, asr r4
    1088:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    108c:	5a5f0065 	bpl	17c1228 <__bss_end+0x17b830c>
    1090:	656c7335 	strbvs	r7, [ip, #-821]!	; 0xfffffccb
    1094:	6a6a7065 	bvs	1a9d230 <__bss_end+0x1a94314>
    1098:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    109c:	6d65525f 	sfmvs	f5, 2, [r5, #-380]!	; 0xfffffe84
    10a0:	696e6961 	stmdbvs	lr!, {r0, r5, r6, r8, fp, sp, lr}^
    10a4:	5f00676e 	svcpl	0x0000676e
    10a8:	6736325a 			; <UNDEFINED> instruction: 0x6736325a
    10ac:	745f7465 	ldrbvc	r7, [pc], #-1125	; 10b4 <shift+0x10b4>
    10b0:	5f6b7361 	svcpl	0x006b7361
    10b4:	6b636974 	blvs	18db68c <__bss_end+0x18d2770>
    10b8:	6f745f73 	svcvs	0x00745f73
    10bc:	6165645f 	cmnvs	r5, pc, asr r4
    10c0:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    10c4:	4e007665 	cfmadd32mi	mvax3, mvfx7, mvfx0, mvfx5
    10c8:	5f495753 	svcpl	0x00495753
    10cc:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
    10d0:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
    10d4:	0065646f 	rsbeq	r6, r5, pc, ror #8
    10d8:	756e7277 	strbvc	r7, [lr, #-631]!	; 0xfffffd89
    10dc:	5a5f006d 	bpl	17c1298 <__bss_end+0x17b837c>
    10e0:	69617734 	stmdbvs	r1!, {r2, r4, r5, r8, r9, sl, ip, sp, lr}^
    10e4:	6a6a6a74 	bvs	1a9babc <__bss_end+0x1a92ba0>
    10e8:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    10ec:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
    10f0:	36316a6c 	ldrtcc	r6, [r1], -ip, ror #20
    10f4:	434f494e 	movtmi	r4, #63822	; 0xf94e
    10f8:	4f5f6c74 	svcmi	0x005f6c74
    10fc:	61726570 	cmnvs	r2, r0, ror r5
    1100:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1104:	69007650 	stmdbvs	r0, {r4, r6, r9, sl, ip, sp, lr}
    1108:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
    110c:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
    1110:	00746e63 	rsbseq	r6, r4, r3, ror #28
    1114:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
    1118:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
    111c:	6f6d0065 	svcvs	0x006d0065
    1120:	62006564 	andvs	r6, r0, #100, 10	; 0x19000000
    1124:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
    1128:	5a5f0072 	bpl	17c12f8 <__bss_end+0x17b83dc>
    112c:	61657234 	cmnvs	r5, r4, lsr r2
    1130:	63506a64 	cmpvs	r0, #100, 20	; 0x64000
    1134:	6572006a 	ldrbvs	r0, [r2, #-106]!	; 0xffffff96
    1138:	646f6374 	strbtvs	r6, [pc], #-884	; 1140 <shift+0x1140>
    113c:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
    1140:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
    1144:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    1148:	6f72705f 	svcvs	0x0072705f
    114c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1150:	756f635f 	strbvc	r6, [pc, #-863]!	; df9 <shift+0xdf9>
    1154:	6600746e 	strvs	r7, [r0], -lr, ror #8
    1158:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
    115c:	00656d61 	rsbeq	r6, r5, r1, ror #26
    1160:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    1164:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    1168:	00646970 	rsbeq	r6, r4, r0, ror r9
    116c:	6f345a5f 	svcvs	0x00345a5f
    1170:	506e6570 	rsbpl	r6, lr, r0, ror r5
    1174:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
    1178:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
    117c:	704f5f65 	subvc	r5, pc, r5, ror #30
    1180:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; ff4 <shift+0xff4>
    1184:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1188:	75706e69 	ldrbvc	r6, [r0, #-3689]!	; 0xfffff197
    118c:	65640074 	strbvs	r0, [r4, #-116]!	; 0xffffff8c
    1190:	62007473 	andvs	r7, r0, #1929379840	; 0x73000000
    1194:	6f72657a 	svcvs	0x0072657a
    1198:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    119c:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    11a0:	6976506f 	ldmdbvs	r6!, {r0, r1, r2, r3, r5, r6, ip, lr}^
    11a4:	6f682f00 	svcvs	0x00682f00
    11a8:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    11ac:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    11b0:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
    11b4:	494b2f76 	stmdbmi	fp, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
    11b8:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
    11bc:	6d2d534f 	stcvs	3, cr5, [sp, #-316]!	; 0xfffffec4
    11c0:	65747361 	ldrbvs	r7, [r4, #-865]!	; 0xfffffc9f
    11c4:	6f732f72 	svcvs	0x00732f72
    11c8:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    11cc:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    11d0:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    11d4:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    11d8:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    11dc:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    11e0:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
    11e4:	43007070 	movwmi	r7, #112	; 0x70
    11e8:	43726168 	cmnmi	r2, #104, 2
    11ec:	41766e6f 	cmnmi	r6, pc, ror #28
    11f0:	6d007272 	sfmvs	f7, 4, [r0, #-456]	; 0xfffffe38
    11f4:	73646d65 	cmnvc	r4, #6464	; 0x1940
    11f8:	756f0074 	strbvc	r0, [pc, #-116]!	; 118c <shift+0x118c>
    11fc:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    1200:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1204:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    1208:	4b507970 	blmi	141f7d0 <__bss_end+0x14168b4>
    120c:	69765076 	ldmdbvs	r6!, {r1, r2, r4, r5, r6, ip, lr}^
    1210:	73616200 	cmnvc	r1, #0, 4
    1214:	656d0065 	strbvs	r0, [sp, #-101]!	; 0xffffff9b
    1218:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    121c:	72747300 	rsbsvc	r7, r4, #0, 6
    1220:	006e656c 	rsbeq	r6, lr, ip, ror #10
    1224:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    1228:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    122c:	4b50706d 	blmi	141d3e8 <__bss_end+0x14144cc>
    1230:	5f305363 	svcpl	0x00305363
    1234:	5a5f0069 	bpl	17c13e0 <__bss_end+0x17b84c4>
    1238:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
    123c:	506e656c 	rsbpl	r6, lr, ip, ror #10
    1240:	6100634b 	tstvs	r0, fp, asr #6
    1244:	00696f74 	rsbeq	r6, r9, r4, ror pc
    1248:	61345a5f 	teqvs	r4, pc, asr sl
    124c:	50696f74 	rsbpl	r6, r9, r4, ror pc
    1250:	5f00634b 	svcpl	0x0000634b
    1254:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    1258:	70636e72 	rsbvc	r6, r3, r2, ror lr
    125c:	50635079 	rsbpl	r5, r3, r9, ror r0
    1260:	0069634b 	rsbeq	r6, r9, fp, asr #6
    1264:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1268:	00706d63 	rsbseq	r6, r0, r3, ror #26
    126c:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1270:	00797063 	rsbseq	r7, r9, r3, rrx
    1274:	6f6d656d 	svcvs	0x006d656d
    1278:	6d007972 	vstrvs.16	s14, [r0, #-228]	; 0xffffff1c	; <UNPREDICTABLE>
    127c:	72736d65 	rsbsvc	r6, r3, #6464	; 0x1940
    1280:	74690063 	strbtvc	r0, [r9], #-99	; 0xffffff9d
    1284:	5f00616f 	svcpl	0x0000616f
    1288:	7469345a 	strbtvc	r3, [r9], #-1114	; 0xfffffba6
    128c:	506a616f 	rsbpl	r6, sl, pc, ror #2
    1290:	2e006a63 	vmlscs.f32	s12, s0, s7
    1294:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1298:	2f2e2e2f 	svccs	0x002e2e2f
    129c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    12a0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    12a4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    12a8:	2f636367 	svccs	0x00636367
    12ac:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    12b0:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    12b4:	6c2f6d72 	stcvs	13, cr6, [pc], #-456	; 10f4 <shift+0x10f4>
    12b8:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
    12bc:	73636e75 	cmnvc	r3, #1872	; 0x750
    12c0:	2f00532e 	svccs	0x0000532e
    12c4:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    12c8:	63672f64 	cmnvs	r7, #100, 30	; 0x190
    12cc:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    12d0:	6f6e2d6d 	svcvs	0x006e2d6d
    12d4:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    12d8:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    12dc:	5662537a 			; <UNDEFINED> instruction: 0x5662537a
    12e0:	672f6e66 	strvs	r6, [pc, -r6, ror #28]!
    12e4:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    12e8:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    12ec:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    12f0:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    12f4:	322d382d 	eorcc	r3, sp, #2949120	; 0x2d0000
    12f8:	2d393130 	ldfcss	f3, [r9, #-192]!	; 0xffffff40
    12fc:	622f3371 	eorvs	r3, pc, #-1006632959	; 0xc4000001
    1300:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1304:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1308:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    130c:	61652d65 	cmnvs	r5, r5, ror #26
    1310:	612f6962 			; <UNDEFINED> instruction: 0x612f6962
    1314:	762f6d72 			; <UNDEFINED> instruction: 0x762f6d72
    1318:	2f657435 	svccs	0x00657435
    131c:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1320:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1324:	00636367 	rsbeq	r6, r3, r7, ror #6
    1328:	20554e47 	subscs	r4, r5, r7, asr #28
    132c:	32205341 	eorcc	r5, r0, #67108865	; 0x4000001
    1330:	0034332e 	eorseq	r3, r4, lr, lsr #6
    1334:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1338:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    133c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1340:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1344:	37316178 			; <UNDEFINED> instruction: 0x37316178
    1348:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    134c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1350:	61736900 	cmnvs	r3, r0, lsl #18
    1354:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1358:	5f70665f 	svcpl	0x0070665f
    135c:	006c6264 	rsbeq	r6, ip, r4, ror #4
    1360:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1364:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1368:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    136c:	31316d72 	teqcc	r1, r2, ror sp
    1370:	736a3633 	cmnvc	sl, #53477376	; 0x3300000
    1374:	6d726100 	ldfvse	f6, [r2, #-0]
    1378:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    137c:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    1380:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1384:	52415400 	subpl	r5, r1, #0, 8
    1388:	5f544547 	svcpl	0x00544547
    138c:	5f555043 	svcpl	0x00555043
    1390:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1394:	326d7865 	rsbcc	r7, sp, #6619136	; 0x650000
    1398:	52410033 	subpl	r0, r1, #51	; 0x33
    139c:	51455f4d 	cmppl	r5, sp, asr #30
    13a0:	52415400 	subpl	r5, r1, #0, 8
    13a4:	5f544547 	svcpl	0x00544547
    13a8:	5f555043 	svcpl	0x00555043
    13ac:	316d7261 	cmncc	sp, r1, ror #4
    13b0:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    13b4:	00736632 	rsbseq	r6, r3, r2, lsr r6
    13b8:	5f617369 	svcpl	0x00617369
    13bc:	5f746962 	svcpl	0x00746962
    13c0:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    13c4:	41540062 	cmpmi	r4, r2, rrx
    13c8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    13cc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    13d0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    13d4:	61786574 	cmnvs	r8, r4, ror r5
    13d8:	6f633735 	svcvs	0x00633735
    13dc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    13e0:	00333561 	eorseq	r3, r3, r1, ror #10
    13e4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    13e8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    13ec:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    13f0:	5341425f 	movtpl	r4, #4703	; 0x125f
    13f4:	41540045 	cmpmi	r4, r5, asr #32
    13f8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    13fc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1400:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1404:	00303138 	eorseq	r3, r0, r8, lsr r1
    1408:	47524154 			; <UNDEFINED> instruction: 0x47524154
    140c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1410:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1414:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    1418:	52410031 	subpl	r0, r1, #49	; 0x31
    141c:	43505f4d 	cmpmi	r0, #308	; 0x134
    1420:	41415f53 	cmpmi	r1, r3, asr pc
    1424:	5f534350 	svcpl	0x00534350
    1428:	4d4d5749 	stclmi	7, cr5, [sp, #-292]	; 0xfffffedc
    142c:	54005458 	strpl	r5, [r0], #-1112	; 0xfffffba8
    1430:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1434:	50435f54 	subpl	r5, r3, r4, asr pc
    1438:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    143c:	6964376d 	stmdbvs	r4!, {r0, r2, r3, r5, r6, r8, r9, sl, ip, sp}^
    1440:	53414200 	movtpl	r4, #4608	; 0x1200
    1444:	52415f45 	subpl	r5, r1, #276	; 0x114
    1448:	325f4843 	subscc	r4, pc, #4390912	; 0x430000
    144c:	53414200 	movtpl	r4, #4608	; 0x1200
    1450:	52415f45 	subpl	r5, r1, #276	; 0x114
    1454:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    1458:	52415400 	subpl	r5, r1, #0, 8
    145c:	5f544547 	svcpl	0x00544547
    1460:	5f555043 	svcpl	0x00555043
    1464:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1468:	42006d64 	andmi	r6, r0, #100, 26	; 0x1900
    146c:	5f455341 	svcpl	0x00455341
    1470:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1474:	4200355f 	andmi	r3, r0, #398458880	; 0x17c00000
    1478:	5f455341 	svcpl	0x00455341
    147c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1480:	4200365f 	andmi	r3, r0, #99614720	; 0x5f00000
    1484:	5f455341 	svcpl	0x00455341
    1488:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    148c:	5400375f 	strpl	r3, [r0], #-1887	; 0xfffff8a1
    1490:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1494:	50435f54 	subpl	r5, r3, r4, asr pc
    1498:	73785f55 	cmnvc	r8, #340	; 0x154
    149c:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    14a0:	52415400 	subpl	r5, r1, #0, 8
    14a4:	5f544547 	svcpl	0x00544547
    14a8:	5f555043 	svcpl	0x00555043
    14ac:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    14b0:	73653634 	cmnvc	r5, #52, 12	; 0x3400000
    14b4:	52415400 	subpl	r5, r1, #0, 8
    14b8:	5f544547 	svcpl	0x00544547
    14bc:	5f555043 	svcpl	0x00555043
    14c0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    14c4:	336d7865 	cmncc	sp, #6619136	; 0x650000
    14c8:	41540033 	cmpmi	r4, r3, lsr r0
    14cc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    14d0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    14d4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    14d8:	6d647437 	cfstrdvs	mvd7, [r4, #-220]!	; 0xffffff24
    14dc:	73690069 	cmnvc	r9, #105	; 0x69
    14e0:	6f6e5f61 	svcvs	0x006e5f61
    14e4:	00746962 	rsbseq	r6, r4, r2, ror #18
    14e8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    14ec:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    14f0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    14f4:	31316d72 	teqcc	r1, r2, ror sp
    14f8:	7a6a3637 	bvc	1a8eddc <__bss_end+0x1a85ec0>
    14fc:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1500:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1504:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1508:	32767066 	rsbscc	r7, r6, #102	; 0x66
    150c:	4d524100 	ldfmie	f4, [r2, #-0]
    1510:	5343505f 	movtpl	r5, #12383	; 0x305f
    1514:	4b4e555f 	blmi	1396a98 <__bss_end+0x138db7c>
    1518:	4e574f4e 	cdpmi	15, 5, cr4, cr7, cr14, {2}
    151c:	52415400 	subpl	r5, r1, #0, 8
    1520:	5f544547 	svcpl	0x00544547
    1524:	5f555043 	svcpl	0x00555043
    1528:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    152c:	41420065 	cmpmi	r2, r5, rrx
    1530:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1534:	5f484352 	svcpl	0x00484352
    1538:	4a455435 	bmi	1156614 <__bss_end+0x114d6f8>
    153c:	6d726100 	ldfvse	f6, [r2, #-0]
    1540:	6663635f 			; <UNDEFINED> instruction: 0x6663635f
    1544:	735f6d73 	cmpvc	pc, #7360	; 0x1cc0
    1548:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
    154c:	736e7500 	cmnvc	lr, #0, 10
    1550:	5f636570 	svcpl	0x00636570
    1554:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1558:	0073676e 	rsbseq	r6, r3, lr, ror #14
    155c:	5f617369 	svcpl	0x00617369
    1560:	5f746962 	svcpl	0x00746962
    1564:	00636573 	rsbeq	r6, r3, r3, ror r5
    1568:	6c635f5f 	stclvs	15, cr5, [r3], #-380	; 0xfffffe84
    156c:	61745f7a 	cmnvs	r4, sl, ror pc
    1570:	52410062 	subpl	r0, r1, #98	; 0x62
    1574:	43565f4d 	cmpmi	r6, #308	; 0x134
    1578:	6d726100 	ldfvse	f6, [r2, #-0]
    157c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1580:	73785f68 	cmnvc	r8, #104, 30	; 0x1a0
    1584:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1588:	4d524100 	ldfmie	f4, [r2, #-0]
    158c:	00454c5f 	subeq	r4, r5, pc, asr ip
    1590:	5f4d5241 	svcpl	0x004d5241
    1594:	41005356 	tstmi	r0, r6, asr r3
    1598:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    159c:	72610045 	rsbvc	r0, r1, #69	; 0x45
    15a0:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    15a4:	735f656e 	cmpvc	pc, #461373440	; 0x1b800000
    15a8:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    15ac:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    15b0:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 15b8 <shift+0x15b8>
    15b4:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    15b8:	6f6c6620 	svcvs	0x006c6620
    15bc:	54007461 	strpl	r7, [r0], #-1121	; 0xfffffb9f
    15c0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    15c4:	50435f54 	subpl	r5, r3, r4, asr pc
    15c8:	6f635f55 	svcvs	0x00635f55
    15cc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    15d0:	00353161 	eorseq	r3, r5, r1, ror #2
    15d4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    15d8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    15dc:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    15e0:	36323761 	ldrtcc	r3, [r2], -r1, ror #14
    15e4:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    15e8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    15ec:	50435f54 	subpl	r5, r3, r4, asr pc
    15f0:	6f635f55 	svcvs	0x00635f55
    15f4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    15f8:	00373161 	eorseq	r3, r7, r1, ror #2
    15fc:	5f4d5241 	svcpl	0x004d5241
    1600:	41005447 	tstmi	r0, r7, asr #8
    1604:	4c5f4d52 	mrrcmi	13, 5, r4, pc, cr2	; <UNPREDICTABLE>
    1608:	2e2e0054 	mcrcs	0, 1, r0, cr14, cr4, {2}
    160c:	2f2e2e2f 	svccs	0x002e2e2f
    1610:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1614:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1618:	2f2e2e2f 	svccs	0x002e2e2f
    161c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1620:	6c2f6363 	stcvs	3, cr6, [pc], #-396	; 149c <shift+0x149c>
    1624:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1628:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    162c:	52415400 	subpl	r5, r1, #0, 8
    1630:	5f544547 	svcpl	0x00544547
    1634:	5f555043 	svcpl	0x00555043
    1638:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    163c:	34727865 	ldrbtcc	r7, [r2], #-2149	; 0xfffff79b
    1640:	41540066 	cmpmi	r4, r6, rrx
    1644:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1648:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    164c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1650:	00303239 	eorseq	r3, r0, r9, lsr r2
    1654:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1658:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    165c:	45375f48 	ldrmi	r5, [r7, #-3912]!	; 0xfffff0b8
    1660:	4154004d 	cmpmi	r4, sp, asr #32
    1664:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1668:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    166c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1670:	61786574 	cmnvs	r8, r4, ror r5
    1674:	68003231 	stmdavs	r0, {r0, r4, r5, r9, ip, sp}
    1678:	76687361 	strbtvc	r7, [r8], -r1, ror #6
    167c:	745f6c61 	ldrbvc	r6, [pc], #-3169	; 1684 <shift+0x1684>
    1680:	53414200 	movtpl	r4, #4608	; 0x1200
    1684:	52415f45 	subpl	r5, r1, #276	; 0x114
    1688:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    168c:	69005a4b 	stmdbvs	r0, {r0, r1, r3, r6, r9, fp, ip, lr}
    1690:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1694:	00737469 	rsbseq	r7, r3, r9, ror #8
    1698:	5f6d7261 	svcpl	0x006d7261
    169c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    16a0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    16a4:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
    16a8:	61007669 	tstvs	r0, r9, ror #12
    16ac:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    16b0:	645f7570 	ldrbvs	r7, [pc], #-1392	; 16b8 <shift+0x16b8>
    16b4:	00637365 	rsbeq	r7, r3, r5, ror #6
    16b8:	5f617369 	svcpl	0x00617369
    16bc:	5f746962 	svcpl	0x00746962
    16c0:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    16c4:	4d524100 	ldfmie	f4, [r2, #-0]
    16c8:	0049485f 	subeq	r4, r9, pc, asr r8
    16cc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    16d0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    16d4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    16d8:	00326d72 	eorseq	r6, r2, r2, ror sp
    16dc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    16e0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    16e4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    16e8:	00336d72 	eorseq	r6, r3, r2, ror sp
    16ec:	47524154 			; <UNDEFINED> instruction: 0x47524154
    16f0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    16f4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    16f8:	31376d72 	teqcc	r7, r2, ror sp
    16fc:	54003030 	strpl	r3, [r0], #-48	; 0xffffffd0
    1700:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1704:	50435f54 	subpl	r5, r3, r4, asr pc
    1708:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    170c:	5400366d 	strpl	r3, [r0], #-1645	; 0xfffff993
    1710:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1714:	50435f54 	subpl	r5, r3, r4, asr pc
    1718:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    171c:	5400376d 	strpl	r3, [r0], #-1901	; 0xfffff893
    1720:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1724:	50435f54 	subpl	r5, r3, r4, asr pc
    1728:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    172c:	5400386d 	strpl	r3, [r0], #-2157	; 0xfffff793
    1730:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1734:	50435f54 	subpl	r5, r3, r4, asr pc
    1738:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    173c:	5400396d 	strpl	r3, [r0], #-2413	; 0xfffff693
    1740:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1744:	50435f54 	subpl	r5, r3, r4, asr pc
    1748:	61665f55 	cmnvs	r6, r5, asr pc
    174c:	00363236 	eorseq	r3, r6, r6, lsr r2
    1750:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1754:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1758:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    175c:	6e5f6d72 	mrcvs	13, 2, r6, cr15, cr2, {3}
    1760:	00656e6f 	rsbeq	r6, r5, pc, ror #28
    1764:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    1768:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
    176c:	6e752067 	cdpvs	0, 7, cr2, cr5, cr7, {3}
    1770:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    1774:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
    1778:	6100746e 	tstvs	r0, lr, ror #8
    177c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1780:	5f686372 	svcpl	0x00686372
    1784:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    1788:	52415400 	subpl	r5, r1, #0, 8
    178c:	5f544547 	svcpl	0x00544547
    1790:	5f555043 	svcpl	0x00555043
    1794:	366d7261 	strbtcc	r7, [sp], -r1, ror #4
    1798:	54003031 	strpl	r3, [r0], #-49	; 0xffffffcf
    179c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    17a0:	50435f54 	subpl	r5, r3, r4, asr pc
    17a4:	6f635f55 	svcvs	0x00635f55
    17a8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    17ac:	5400346d 	strpl	r3, [r0], #-1133	; 0xfffffb93
    17b0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    17b4:	50435f54 	subpl	r5, r3, r4, asr pc
    17b8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    17bc:	6530316d 	ldrvs	r3, [r0, #-365]!	; 0xfffffe93
    17c0:	52415400 	subpl	r5, r1, #0, 8
    17c4:	5f544547 	svcpl	0x00544547
    17c8:	5f555043 	svcpl	0x00555043
    17cc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    17d0:	376d7865 	strbcc	r7, [sp, -r5, ror #16]!
    17d4:	52415400 	subpl	r5, r1, #0, 8
    17d8:	5f544547 	svcpl	0x00544547
    17dc:	5f555043 	svcpl	0x00555043
    17e0:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    17e4:	66303035 			; <UNDEFINED> instruction: 0x66303035
    17e8:	41540065 	cmpmi	r4, r5, rrx
    17ec:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    17f0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    17f4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    17f8:	63303137 	teqvs	r0, #-1073741811	; 0xc000000d
    17fc:	6d726100 	ldfvse	f6, [r2, #-0]
    1800:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    1804:	6f635f64 	svcvs	0x00635f64
    1808:	41006564 	tstmi	r0, r4, ror #10
    180c:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1810:	415f5343 	cmpmi	pc, r3, asr #6
    1814:	53435041 	movtpl	r5, #12353	; 0x3041
    1818:	61736900 	cmnvs	r3, r0, lsl #18
    181c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1820:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1824:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
    1828:	53414200 	movtpl	r4, #4608	; 0x1200
    182c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1830:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    1834:	4154004d 	cmpmi	r4, sp, asr #32
    1838:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    183c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1840:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1844:	74303137 	ldrtvc	r3, [r0], #-311	; 0xfffffec9
    1848:	6d726100 	ldfvse	f6, [r2, #-0]
    184c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1850:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    1854:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1858:	73690032 	cmnvc	r9, #50	; 0x32
    185c:	756e5f61 	strbvc	r5, [lr, #-3937]!	; 0xfffff09f
    1860:	69625f6d 	stmdbvs	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    1864:	54007374 	strpl	r7, [r0], #-884	; 0xfffffc8c
    1868:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    186c:	50435f54 	subpl	r5, r3, r4, asr pc
    1870:	6f635f55 	svcvs	0x00635f55
    1874:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1878:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    187c:	6d737375 	ldclvs	3, cr7, [r3, #-468]!	; 0xfffffe2c
    1880:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    1884:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    1888:	00796c70 	rsbseq	r6, r9, r0, ror ip
    188c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1890:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1894:	655f5550 	ldrbvs	r5, [pc, #-1360]	; 134c <shift+0x134c>
    1898:	6f6e7978 	svcvs	0x006e7978
    189c:	00316d73 	eorseq	r6, r1, r3, ror sp
    18a0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    18a4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    18a8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    18ac:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    18b0:	32357278 	eorscc	r7, r5, #120, 4	; 0x80000007
    18b4:	61736900 	cmnvs	r3, r0, lsl #18
    18b8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    18bc:	6964745f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
    18c0:	72700076 	rsbsvc	r0, r0, #118	; 0x76
    18c4:	72656665 	rsbvc	r6, r5, #105906176	; 0x6500000
    18c8:	6f656e5f 	svcvs	0x00656e5f
    18cc:	6f665f6e 	svcvs	0x00665f6e
    18d0:	34365f72 	ldrtcc	r5, [r6], #-3954	; 0xfffff08e
    18d4:	73746962 	cmnvc	r4, #1605632	; 0x188000
    18d8:	61736900 	cmnvs	r3, r0, lsl #18
    18dc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    18e0:	3170665f 	cmncc	r0, pc, asr r6
    18e4:	6c6d6636 	stclvs	6, cr6, [sp], #-216	; 0xffffff28
    18e8:	52415400 	subpl	r5, r1, #0, 8
    18ec:	5f544547 	svcpl	0x00544547
    18f0:	5f555043 	svcpl	0x00555043
    18f4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    18f8:	33617865 	cmncc	r1, #6619136	; 0x650000
    18fc:	41540032 	cmpmi	r4, r2, lsr r0
    1900:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1904:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1908:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    190c:	00303236 	eorseq	r3, r0, r6, lsr r2
    1910:	5f617369 	svcpl	0x00617369
    1914:	5f746962 	svcpl	0x00746962
    1918:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    191c:	766e6f63 	strbtvc	r6, [lr], -r3, ror #30
    1920:	736e7500 	cmnvc	lr, #0, 10
    1924:	76636570 			; <UNDEFINED> instruction: 0x76636570
    1928:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    192c:	73676e69 	cmnvc	r7, #1680	; 0x690
    1930:	52415400 	subpl	r5, r1, #0, 8
    1934:	5f544547 	svcpl	0x00544547
    1938:	5f555043 	svcpl	0x00555043
    193c:	316d7261 	cmncc	sp, r1, ror #4
    1940:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    1944:	54007332 	strpl	r7, [r0], #-818	; 0xfffffcce
    1948:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    194c:	50435f54 	subpl	r5, r3, r4, asr pc
    1950:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1954:	3230316d 	eorscc	r3, r0, #1073741851	; 0x4000001b
    1958:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    195c:	6d726100 	ldfvse	f6, [r2, #-0]
    1960:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1964:	006d3368 	rsbeq	r3, sp, r8, ror #6
    1968:	47524154 			; <UNDEFINED> instruction: 0x47524154
    196c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1970:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1974:	36303661 	ldrtcc	r3, [r0], -r1, ror #12
    1978:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    197c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1980:	50435f54 	subpl	r5, r3, r4, asr pc
    1984:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1988:	3632396d 	ldrtcc	r3, [r2], -sp, ror #18
    198c:	00736a65 	rsbseq	r6, r3, r5, ror #20
    1990:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1994:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1998:	54345f48 	ldrtpl	r5, [r4], #-3912	; 0xfffff0b8
    199c:	61736900 	cmnvs	r3, r0, lsl #18
    19a0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    19a4:	7972635f 	ldmdbvc	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
    19a8:	006f7470 	rsbeq	r7, pc, r0, ror r4	; <UNPREDICTABLE>
    19ac:	5f6d7261 	svcpl	0x006d7261
    19b0:	73676572 	cmnvc	r7, #478150656	; 0x1c800000
    19b4:	5f6e695f 	svcpl	0x006e695f
    19b8:	75716573 	ldrbvc	r6, [r1, #-1395]!	; 0xfffffa8d
    19bc:	65636e65 	strbvs	r6, [r3, #-3685]!	; 0xfffff19b
    19c0:	53414200 	movtpl	r4, #4608	; 0x1200
    19c4:	52415f45 	subpl	r5, r1, #276	; 0x114
    19c8:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 118d <shift+0x118d>
    19cc:	54004554 	strpl	r4, [r0], #-1364	; 0xfffffaac
    19d0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    19d4:	50435f54 	subpl	r5, r3, r4, asr pc
    19d8:	70655f55 	rsbvc	r5, r5, r5, asr pc
    19dc:	32313339 	eorscc	r3, r1, #-469762048	; 0xe4000000
    19e0:	61736900 	cmnvs	r3, r0, lsl #18
    19e4:	6165665f 	cmnvs	r5, pc, asr r6
    19e8:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    19ec:	61736900 	cmnvs	r3, r0, lsl #18
    19f0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    19f4:	616d735f 	cmnvs	sp, pc, asr r3
    19f8:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    19fc:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    1a00:	616c5f6d 	cmnvs	ip, sp, ror #30
    1a04:	6f5f676e 	svcvs	0x005f676e
    1a08:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
    1a0c:	626f5f74 	rsbvs	r5, pc, #116, 30	; 0x1d0
    1a10:	7463656a 	strbtvc	r6, [r3], #-1386	; 0xfffffa96
    1a14:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    1a18:	75626972 	strbvc	r6, [r2, #-2418]!	; 0xfffff68e
    1a1c:	5f736574 	svcpl	0x00736574
    1a20:	6b6f6f68 	blvs	1bdd7c8 <__bss_end+0x1bd48ac>
    1a24:	61736900 	cmnvs	r3, r0, lsl #18
    1a28:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1a2c:	5f70665f 	svcpl	0x0070665f
    1a30:	00323364 	eorseq	r3, r2, r4, ror #6
    1a34:	5f4d5241 	svcpl	0x004d5241
    1a38:	6900454e 	stmdbvs	r0, {r1, r2, r3, r6, r8, sl, lr}
    1a3c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1a40:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
    1a44:	54003865 	strpl	r3, [r0], #-2149	; 0xfffff79b
    1a48:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a4c:	50435f54 	subpl	r5, r3, r4, asr pc
    1a50:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1a54:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    1a58:	737a6a36 	cmnvc	sl, #221184	; 0x36000
    1a5c:	53414200 	movtpl	r4, #4608	; 0x1200
    1a60:	52415f45 	subpl	r5, r1, #276	; 0x114
    1a64:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 1229 <shift+0x1229>
    1a68:	73690045 	cmnvc	r9, #69	; 0x45
    1a6c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1a70:	64615f74 	strbtvs	r5, [r1], #-3956	; 0xfffff08c
    1a74:	70007669 	andvc	r7, r0, r9, ror #12
    1a78:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1a7c:	726f7373 	rsbvc	r7, pc, #-872415231	; 0xcc000001
    1a80:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    1a84:	6c610065 	stclvs	0, cr0, [r1], #-404	; 0xfffffe6c
    1a88:	70665f6c 	rsbvc	r5, r6, ip, ror #30
    1a8c:	61007375 	tstvs	r0, r5, ror r3
    1a90:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    1a94:	42007363 	andmi	r7, r0, #-1946157055	; 0x8c000001
    1a98:	5f455341 	svcpl	0x00455341
    1a9c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1aa0:	0054355f 	subseq	r3, r4, pc, asr r5
    1aa4:	5f6d7261 	svcpl	0x006d7261
    1aa8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1aac:	54007434 	strpl	r7, [r0], #-1076	; 0xfffffbcc
    1ab0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ab4:	50435f54 	subpl	r5, r3, r4, asr pc
    1ab8:	6f635f55 	svcvs	0x00635f55
    1abc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ac0:	63353161 	teqvs	r5, #1073741848	; 0x40000018
    1ac4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1ac8:	00376178 	eorseq	r6, r7, r8, ror r1
    1acc:	5f6d7261 	svcpl	0x006d7261
    1ad0:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    1ad4:	7562775f 	strbvc	r7, [r2, #-1887]!	; 0xfffff8a1
    1ad8:	74680066 	strbtvc	r0, [r8], #-102	; 0xffffff9a
    1adc:	685f6261 	ldmdavs	pc, {r0, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    1ae0:	00687361 	rsbeq	r7, r8, r1, ror #6
    1ae4:	5f617369 	svcpl	0x00617369
    1ae8:	5f746962 	svcpl	0x00746962
    1aec:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    1af0:	6f6e5f6b 	svcvs	0x006e5f6b
    1af4:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 1980 <shift+0x1980>
    1af8:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    1afc:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    1b00:	52415400 	subpl	r5, r1, #0, 8
    1b04:	5f544547 	svcpl	0x00544547
    1b08:	5f555043 	svcpl	0x00555043
    1b0c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1b10:	306d7865 	rsbcc	r7, sp, r5, ror #16
    1b14:	52415400 	subpl	r5, r1, #0, 8
    1b18:	5f544547 	svcpl	0x00544547
    1b1c:	5f555043 	svcpl	0x00555043
    1b20:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1b24:	316d7865 	cmncc	sp, r5, ror #16
    1b28:	52415400 	subpl	r5, r1, #0, 8
    1b2c:	5f544547 	svcpl	0x00544547
    1b30:	5f555043 	svcpl	0x00555043
    1b34:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1b38:	336d7865 	cmncc	sp, #6619136	; 0x650000
    1b3c:	61736900 	cmnvs	r3, r0, lsl #18
    1b40:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1b44:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1b48:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    1b4c:	6d726100 	ldfvse	f6, [r2, #-0]
    1b50:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1b54:	616e5f68 	cmnvs	lr, r8, ror #30
    1b58:	6900656d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, sl, sp, lr}
    1b5c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1b60:	615f7469 	cmpvs	pc, r9, ror #8
    1b64:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1b68:	6900335f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp}
    1b6c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1b70:	615f7469 	cmpvs	pc, r9, ror #8
    1b74:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1b78:	5400345f 	strpl	r3, [r0], #-1119	; 0xfffffba1
    1b7c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b80:	50435f54 	subpl	r5, r3, r4, asr pc
    1b84:	6f635f55 	svcvs	0x00635f55
    1b88:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1b8c:	00333561 	eorseq	r3, r3, r1, ror #10
    1b90:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b94:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b98:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1b9c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1ba0:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    1ba4:	52415400 	subpl	r5, r1, #0, 8
    1ba8:	5f544547 	svcpl	0x00544547
    1bac:	5f555043 	svcpl	0x00555043
    1bb0:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1bb4:	00696d64 	rsbeq	r6, r9, r4, ror #26
    1bb8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1bbc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1bc0:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 1a88 <shift+0x1a88>
    1bc4:	726f6370 	rsbvc	r6, pc, #112, 6	; 0xc0000001
    1bc8:	73690065 	cmnvc	r9, #101	; 0x65
    1bcc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1bd0:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1bd4:	6d33766d 	ldcvs	6, cr7, [r3, #-436]!	; 0xfffffe4c
    1bd8:	6d726100 	ldfvse	f6, [r2, #-0]
    1bdc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1be0:	6f6e5f68 	svcvs	0x006e5f68
    1be4:	61006d74 	tstvs	r0, r4, ror sp
    1be8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1bec:	35686372 	strbcc	r6, [r8, #-882]!	; 0xfffffc8e
    1bf0:	41540065 	cmpmi	r4, r5, rrx
    1bf4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1bf8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1bfc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1c00:	30323031 	eorscc	r3, r2, r1, lsr r0
    1c04:	41420065 	cmpmi	r2, r5, rrx
    1c08:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1c0c:	5f484352 	svcpl	0x00484352
    1c10:	54004a36 	strpl	r4, [r0], #-2614	; 0xfffff5ca
    1c14:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c18:	50435f54 	subpl	r5, r3, r4, asr pc
    1c1c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1c20:	3836396d 	ldmdacc	r6!, {r0, r2, r3, r5, r6, r8, fp, ip, sp}
    1c24:	54007365 	strpl	r7, [r0], #-869	; 0xfffffc9b
    1c28:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c2c:	50435f54 	subpl	r5, r3, r4, asr pc
    1c30:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1c34:	3034376d 	eorscc	r3, r4, sp, ror #14
    1c38:	41420074 	hvcmi	8196	; 0x2004
    1c3c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1c40:	5f484352 	svcpl	0x00484352
    1c44:	69004d36 	stmdbvs	r0, {r1, r2, r4, r5, r8, sl, fp, lr}
    1c48:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1c4c:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1c50:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1c54:	41540074 	cmpmi	r4, r4, ror r0
    1c58:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c5c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c60:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1c64:	00303037 	eorseq	r3, r0, r7, lsr r0
    1c68:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c6c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c70:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1c74:	31316d72 	teqcc	r1, r2, ror sp
    1c78:	666a3633 			; <UNDEFINED> instruction: 0x666a3633
    1c7c:	52410073 	subpl	r0, r1, #115	; 0x73
    1c80:	534c5f4d 	movtpl	r5, #53069	; 0xcf4d
    1c84:	52415400 	subpl	r5, r1, #0, 8
    1c88:	5f544547 	svcpl	0x00544547
    1c8c:	5f555043 	svcpl	0x00555043
    1c90:	316d7261 	cmncc	sp, r1, ror #4
    1c94:	74303230 	ldrtvc	r3, [r0], #-560	; 0xfffffdd0
    1c98:	53414200 	movtpl	r4, #4608	; 0x1200
    1c9c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1ca0:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1ca4:	4154005a 	cmpmi	r4, sl, asr r0
    1ca8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cac:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cb0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1cb4:	61786574 	cmnvs	r8, r4, ror r5
    1cb8:	6f633537 	svcvs	0x00633537
    1cbc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1cc0:	00353561 	eorseq	r3, r5, r1, ror #10
    1cc4:	5f4d5241 	svcpl	0x004d5241
    1cc8:	5f534350 	svcpl	0x00534350
    1ccc:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    1cd0:	46565f53 	usaxmi	r5, r6, r3
    1cd4:	41540050 	cmpmi	r4, r0, asr r0
    1cd8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cdc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ce0:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1ce4:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    1ce8:	61736900 	cmnvs	r3, r0, lsl #18
    1cec:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1cf0:	6f656e5f 	svcvs	0x00656e5f
    1cf4:	7261006e 	rsbvc	r0, r1, #110	; 0x6e
    1cf8:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    1cfc:	74615f75 	strbtvc	r5, [r1], #-3957	; 0xfffff08b
    1d00:	69007274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp, lr}
    1d04:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1d08:	615f7469 	cmpvs	pc, r9, ror #8
    1d0c:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    1d10:	54006d65 	strpl	r6, [r0], #-3429	; 0xfffff29b
    1d14:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1d18:	50435f54 	subpl	r5, r3, r4, asr pc
    1d1c:	61665f55 	cmnvs	r6, r5, asr pc
    1d20:	74363236 	ldrtvc	r3, [r6], #-566	; 0xfffffdca
    1d24:	41540065 	cmpmi	r4, r5, rrx
    1d28:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d2c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d30:	72616d5f 	rsbvc	r6, r1, #6080	; 0x17c0
    1d34:	6c6c6576 	cfstr64vs	mvdx6, [ip], #-472	; 0xfffffe28
    1d38:	346a705f 	strbtcc	r7, [sl], #-95	; 0xffffffa1
    1d3c:	61746800 	cmnvs	r4, r0, lsl #16
    1d40:	61685f62 	cmnvs	r8, r2, ror #30
    1d44:	705f6873 	subsvc	r6, pc, r3, ror r8	; <UNPREDICTABLE>
    1d48:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    1d4c:	54007265 	strpl	r7, [r0], #-613	; 0xfffffd9b
    1d50:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1d54:	50435f54 	subpl	r5, r3, r4, asr pc
    1d58:	6f635f55 	svcvs	0x00635f55
    1d5c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1d60:	00353361 	eorseq	r3, r5, r1, ror #6
    1d64:	5f6d7261 	svcpl	0x006d7261
    1d68:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    1d6c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1d70:	5f786574 	svcpl	0x00786574
    1d74:	69003961 	stmdbvs	r0, {r0, r5, r6, r8, fp, ip, sp}
    1d78:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1d7c:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1d80:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1d84:	54003274 	strpl	r3, [r0], #-628	; 0xfffffd8c
    1d88:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1d8c:	50435f54 	subpl	r5, r3, r4, asr pc
    1d90:	6f635f55 	svcvs	0x00635f55
    1d94:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1d98:	63323761 	teqvs	r2, #25427968	; 0x1840000
    1d9c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1da0:	33356178 	teqcc	r5, #120, 2
    1da4:	61736900 	cmnvs	r3, r0, lsl #18
    1da8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1dac:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    1db0:	0032626d 	eorseq	r6, r2, sp, ror #4
    1db4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1db8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1dbc:	41375f48 	teqmi	r7, r8, asr #30
    1dc0:	61736900 	cmnvs	r3, r0, lsl #18
    1dc4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1dc8:	746f645f 	strbtvc	r6, [pc], #-1119	; 1dd0 <shift+0x1dd0>
    1dcc:	646f7270 	strbtvs	r7, [pc], #-624	; 1dd4 <shift+0x1dd4>
    1dd0:	53414200 	movtpl	r4, #4608	; 0x1200
    1dd4:	52415f45 	subpl	r5, r1, #276	; 0x114
    1dd8:	305f4843 	subscc	r4, pc, r3, asr #16
    1ddc:	6d726100 	ldfvse	f6, [r2, #-0]
    1de0:	3170665f 	cmncc	r0, pc, asr r6
    1de4:	79745f36 	ldmdbvc	r4!, {r1, r2, r4, r5, r8, r9, sl, fp, ip, lr}^
    1de8:	6e5f6570 	mrcvs	5, 2, r6, cr15, cr0, {3}
    1dec:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1df0:	5f4d5241 	svcpl	0x004d5241
    1df4:	6100494d 	tstvs	r0, sp, asr #18
    1df8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1dfc:	36686372 			; <UNDEFINED> instruction: 0x36686372
    1e00:	7261006b 	rsbvc	r0, r1, #107	; 0x6b
    1e04:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1e08:	6d366863 	ldcvs	8, cr6, [r6, #-396]!	; 0xfffffe74
    1e0c:	53414200 	movtpl	r4, #4608	; 0x1200
    1e10:	52415f45 	subpl	r5, r1, #276	; 0x114
    1e14:	345f4843 	ldrbcc	r4, [pc], #-2115	; 1e1c <shift+0x1e1c>
    1e18:	53414200 	movtpl	r4, #4608	; 0x1200
    1e1c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1e20:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    1e24:	5f5f0052 	svcpl	0x005f0052
    1e28:	63706f70 	cmnvs	r0, #112, 30	; 0x1c0
    1e2c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1e30:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    1e34:	61736900 	cmnvs	r3, r0, lsl #18
    1e38:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1e3c:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    1e40:	41540065 	cmpmi	r4, r5, rrx
    1e44:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e48:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e4c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1e50:	61786574 	cmnvs	r8, r4, ror r5
    1e54:	54003337 	strpl	r3, [r0], #-823	; 0xfffffcc9
    1e58:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e5c:	50435f54 	subpl	r5, r3, r4, asr pc
    1e60:	65675f55 	strbvs	r5, [r7, #-3925]!	; 0xfffff0ab
    1e64:	6972656e 	ldmdbvs	r2!, {r1, r2, r3, r5, r6, r8, sl, sp, lr}^
    1e68:	61377663 	teqvs	r7, r3, ror #12
    1e6c:	61736900 	cmnvs	r3, r0, lsl #18
    1e70:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1e74:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1e78:	00653576 	rsbeq	r3, r5, r6, ror r5
    1e7c:	5f6d7261 	svcpl	0x006d7261
    1e80:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1e84:	5f6f6e5f 	svcpl	0x006f6e5f
    1e88:	616c6f76 	smcvs	50934	; 0xc6f6
    1e8c:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    1e90:	0065635f 	rsbeq	r6, r5, pc, asr r3
    1e94:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1e98:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1e9c:	41385f48 	teqmi	r8, r8, asr #30
    1ea0:	52415400 	subpl	r5, r1, #0, 8
    1ea4:	5f544547 	svcpl	0x00544547
    1ea8:	5f555043 	svcpl	0x00555043
    1eac:	316d7261 	cmncc	sp, r1, ror #4
    1eb0:	65323230 	ldrvs	r3, [r2, #-560]!	; 0xfffffdd0
    1eb4:	53414200 	movtpl	r4, #4608	; 0x1200
    1eb8:	52415f45 	subpl	r5, r1, #276	; 0x114
    1ebc:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    1ec0:	41540052 	cmpmi	r4, r2, asr r0
    1ec4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ec8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ecc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1ed0:	61786574 	cmnvs	r8, r4, ror r5
    1ed4:	6f633337 	svcvs	0x00633337
    1ed8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1edc:	00353361 	eorseq	r3, r5, r1, ror #6
    1ee0:	5f4d5241 	svcpl	0x004d5241
    1ee4:	6100564e 	tstvs	r0, lr, asr #12
    1ee8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1eec:	34686372 	strbtcc	r6, [r8], #-882	; 0xfffffc8e
    1ef0:	6d726100 	ldfvse	f6, [r2, #-0]
    1ef4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1ef8:	61003568 	tstvs	r0, r8, ror #10
    1efc:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1f00:	37686372 			; <UNDEFINED> instruction: 0x37686372
    1f04:	6d726100 	ldfvse	f6, [r2, #-0]
    1f08:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1f0c:	6c003868 	stcvs	8, cr3, [r0], {104}	; 0x68
    1f10:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    1f14:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    1f18:	4200656c 	andmi	r6, r0, #108, 10	; 0x1b000000
    1f1c:	5f455341 	svcpl	0x00455341
    1f20:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1f24:	004b365f 	subeq	r3, fp, pc, asr r6
    1f28:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f2c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f30:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1f34:	34396d72 	ldrtcc	r6, [r9], #-3442	; 0xfffff28e
    1f38:	61007430 	tstvs	r0, r0, lsr r4
    1f3c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1f40:	36686372 			; <UNDEFINED> instruction: 0x36686372
    1f44:	6d726100 	ldfvse	f6, [r2, #-0]
    1f48:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    1f4c:	73785f65 	cmnvc	r8, #404	; 0x194
    1f50:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1f54:	52415400 	subpl	r5, r1, #0, 8
    1f58:	5f544547 	svcpl	0x00544547
    1f5c:	5f555043 	svcpl	0x00555043
    1f60:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1f64:	00303035 	eorseq	r3, r0, r5, lsr r0
    1f68:	696b616d 	stmdbvs	fp!, {r0, r2, r3, r5, r6, r8, sp, lr}^
    1f6c:	635f676e 	cmpvs	pc, #28835840	; 0x1b80000
    1f70:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
    1f74:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    1f78:	7400656c 	strvc	r6, [r0], #-1388	; 0xfffffa94
    1f7c:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    1f80:	6c61635f 	stclvs	3, cr6, [r1], #-380	; 0xfffffe84
    1f84:	69765f6c 	ldmdbvs	r6!, {r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    1f88:	616c5f61 	cmnvs	ip, r1, ror #30
    1f8c:	006c6562 	rsbeq	r6, ip, r2, ror #10
    1f90:	5f617369 	svcpl	0x00617369
    1f94:	5f746962 	svcpl	0x00746962
    1f98:	35767066 	ldrbcc	r7, [r6, #-102]!	; 0xffffff9a
    1f9c:	52415400 	subpl	r5, r1, #0, 8
    1fa0:	5f544547 	svcpl	0x00544547
    1fa4:	5f555043 	svcpl	0x00555043
    1fa8:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1fac:	69003031 	stmdbvs	r0, {r0, r4, r5, ip, sp}
    1fb0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1fb4:	615f7469 	cmpvs	pc, r9, ror #8
    1fb8:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1fbc:	4154006b 	cmpmi	r4, fp, rrx
    1fc0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1fc4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1fc8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1fcc:	61786574 	cmnvs	r8, r4, ror r5
    1fd0:	41540037 	cmpmi	r4, r7, lsr r0
    1fd4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1fd8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1fdc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1fe0:	61786574 	cmnvs	r8, r4, ror r5
    1fe4:	41540038 	cmpmi	r4, r8, lsr r0
    1fe8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1fec:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ff0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1ff4:	61786574 	cmnvs	r8, r4, ror r5
    1ff8:	52410039 	subpl	r0, r1, #57	; 0x39
    1ffc:	43505f4d 	cmpmi	r0, #308	; 0x134
    2000:	50415f53 	subpl	r5, r1, r3, asr pc
    2004:	41005343 	tstmi	r0, r3, asr #6
    2008:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    200c:	415f5343 	cmpmi	pc, r3, asr #6
    2010:	53435054 	movtpl	r5, #12372	; 0x3054
    2014:	52415400 	subpl	r5, r1, #0, 8
    2018:	5f544547 	svcpl	0x00544547
    201c:	5f555043 	svcpl	0x00555043
    2020:	366d7261 	strbtcc	r7, [sp], -r1, ror #4
    2024:	54003030 	strpl	r3, [r0], #-48	; 0xffffffd0
    2028:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    202c:	50435f54 	subpl	r5, r3, r4, asr pc
    2030:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2034:	3032376d 	eorscc	r3, r2, sp, ror #14
    2038:	41540074 	cmpmi	r4, r4, ror r0
    203c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2040:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2044:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2048:	61786574 	cmnvs	r8, r4, ror r5
    204c:	63003735 	movwvs	r3, #1845	; 0x735
    2050:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    2054:	64207865 	strtvs	r7, [r0], #-2149	; 0xfffff79b
    2058:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    205c:	41540065 	cmpmi	r4, r5, rrx
    2060:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2064:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2068:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    206c:	61786574 	cmnvs	r8, r4, ror r5
    2070:	6f633337 	svcvs	0x00633337
    2074:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2078:	00333561 	eorseq	r3, r3, r1, ror #10
    207c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2080:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2084:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2088:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    208c:	70306d78 	eorsvc	r6, r0, r8, ror sp
    2090:	0073756c 	rsbseq	r7, r3, ip, ror #10
    2094:	5f6d7261 	svcpl	0x006d7261
    2098:	69006363 	stmdbvs	r0, {r0, r1, r5, r6, r8, r9, sp, lr}
    209c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    20a0:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 1f04 <shift+0x1f04>
    20a4:	3265646f 	rsbcc	r6, r5, #1862270976	; 0x6f000000
    20a8:	73690036 	cmnvc	r9, #54	; 0x36
    20ac:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    20b0:	73785f74 	cmnvc	r8, #116, 30	; 0x1d0
    20b4:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    20b8:	52415400 	subpl	r5, r1, #0, 8
    20bc:	5f544547 	svcpl	0x00544547
    20c0:	5f555043 	svcpl	0x00555043
    20c4:	6f727473 	svcvs	0x00727473
    20c8:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    20cc:	3031316d 	eorscc	r3, r1, sp, ror #2
    20d0:	41540030 	cmpmi	r4, r0, lsr r0
    20d4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    20d8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    20dc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    20e0:	6d647437 	cfstrdvs	mvd7, [r4, #-220]!	; 0xffffff24
    20e4:	5f007369 	svcpl	0x00007369
    20e8:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    20ec:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    20f0:	6572745f 	ldrbvs	r7, [r2, #-1119]!	; 0xfffffba1
    20f4:	65685f65 	strbvs	r5, [r8, #-3941]!	; 0xfffff09b
    20f8:	005f6572 	subseq	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    20fc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2100:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2104:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2108:	30316d72 	eorscc	r6, r1, r2, ror sp
    210c:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    2110:	52415400 	subpl	r5, r1, #0, 8
    2114:	5f544547 	svcpl	0x00544547
    2118:	5f555043 	svcpl	0x00555043
    211c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2120:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2124:	73616200 	cmnvc	r1, #0, 4
    2128:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    212c:	74696863 	strbtvc	r6, [r9], #-2147	; 0xfffff79d
    2130:	75746365 	ldrbvc	r6, [r4, #-869]!	; 0xfffffc9b
    2134:	61006572 	tstvs	r0, r2, ror r5
    2138:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    213c:	5f686372 	svcpl	0x00686372
    2140:	00637263 	rsbeq	r7, r3, r3, ror #4
    2144:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2148:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    214c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2150:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2154:	73316d78 	teqvc	r1, #120, 26	; 0x1e00
    2158:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    215c:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    2160:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    2164:	6d726100 	ldfvse	f6, [r2, #-0]
    2168:	7275635f 	rsbsvc	r6, r5, #2080374785	; 0x7c000001
    216c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    2170:	0063635f 	rsbeq	r6, r3, pc, asr r3
    2174:	5f6d7261 	svcpl	0x006d7261
    2178:	67726174 			; <UNDEFINED> instruction: 0x67726174
    217c:	695f7465 	ldmdbvs	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    2180:	006e736e 	rsbeq	r7, lr, lr, ror #6
    2184:	5f617369 	svcpl	0x00617369
    2188:	5f746962 	svcpl	0x00746962
    218c:	33637263 	cmncc	r3, #805306374	; 0x30000006
    2190:	52410032 	subpl	r0, r1, #50	; 0x32
    2194:	4c505f4d 	mrrcmi	15, 4, r5, r0, cr13
    2198:	61736900 	cmnvs	r3, r0, lsl #18
    219c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    21a0:	7066765f 	rsbvc	r7, r6, pc, asr r6
    21a4:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
    21a8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    21ac:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    21b0:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
    21b4:	53414200 	movtpl	r4, #4608	; 0x1200
    21b8:	52415f45 	subpl	r5, r1, #276	; 0x114
    21bc:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    21c0:	42003254 	andmi	r3, r0, #84, 4	; 0x40000005
    21c4:	5f455341 	svcpl	0x00455341
    21c8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    21cc:	5f4d385f 	svcpl	0x004d385f
    21d0:	4e49414d 	dvfmiem	f4, f1, #5.0
    21d4:	52415400 	subpl	r5, r1, #0, 8
    21d8:	5f544547 	svcpl	0x00544547
    21dc:	5f555043 	svcpl	0x00555043
    21e0:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    21e4:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    21e8:	4d524100 	ldfmie	f4, [r2, #-0]
    21ec:	004c415f 	subeq	r4, ip, pc, asr r1
    21f0:	5f617369 	svcpl	0x00617369
    21f4:	5f746962 	svcpl	0x00746962
    21f8:	65646f6d 	strbvs	r6, [r4, #-3949]!	; 0xfffff093
    21fc:	42003233 	andmi	r3, r0, #805306371	; 0x30000003
    2200:	5f455341 	svcpl	0x00455341
    2204:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2208:	004d375f 	subeq	r3, sp, pc, asr r7
    220c:	5f6d7261 	svcpl	0x006d7261
    2210:	67726174 			; <UNDEFINED> instruction: 0x67726174
    2214:	6c5f7465 	cfldrdvs	mvd7, [pc], {101}	; 0x65
    2218:	6c656261 	sfmvs	f6, 2, [r5], #-388	; 0xfffffe7c
    221c:	52415400 	subpl	r5, r1, #0, 8
    2220:	5f544547 	svcpl	0x00544547
    2224:	5f555043 	svcpl	0x00555043
    2228:	6f727473 	svcvs	0x00727473
    222c:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    2230:	3131316d 	teqcc	r1, sp, ror #2
    2234:	41540030 	cmpmi	r4, r0, lsr r0
    2238:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    223c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2240:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2244:	00303237 	eorseq	r3, r0, r7, lsr r2
    2248:	47524154 			; <UNDEFINED> instruction: 0x47524154
    224c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2250:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2254:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2258:	00347278 	eorseq	r7, r4, r8, ror r2
    225c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2260:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2264:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2268:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    226c:	00357278 	eorseq	r7, r5, r8, ror r2
    2270:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2274:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2278:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    227c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2280:	00377278 	eorseq	r7, r7, r8, ror r2
    2284:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2288:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    228c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2290:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2294:	00387278 	eorseq	r7, r8, r8, ror r2
    2298:	5f617369 	svcpl	0x00617369
    229c:	5f746962 	svcpl	0x00746962
    22a0:	6561706c 	strbvs	r7, [r1, #-108]!	; 0xffffff94
    22a4:	52415400 	subpl	r5, r1, #0, 8
    22a8:	5f544547 	svcpl	0x00544547
    22ac:	5f555043 	svcpl	0x00555043
    22b0:	6f727473 	svcvs	0x00727473
    22b4:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    22b8:	3031316d 	eorscc	r3, r1, sp, ror #2
    22bc:	61736900 	cmnvs	r3, r0, lsl #18
    22c0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    22c4:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    22c8:	615f6b72 	cmpvs	pc, r2, ror fp	; <UNPREDICTABLE>
    22cc:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    22d0:	69007a6b 	stmdbvs	r0, {r0, r1, r3, r5, r6, r9, fp, ip, sp, lr}
    22d4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    22d8:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    22dc:	006d746f 	rsbeq	r7, sp, pc, ror #8
    22e0:	5f617369 	svcpl	0x00617369
    22e4:	5f746962 	svcpl	0x00746962
    22e8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    22ec:	73690034 	cmnvc	r9, #52	; 0x34
    22f0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    22f4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    22f8:	0035766d 	eorseq	r7, r5, sp, ror #12
    22fc:	5f617369 	svcpl	0x00617369
    2300:	5f746962 	svcpl	0x00746962
    2304:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2308:	73690036 	cmnvc	r9, #54	; 0x36
    230c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2310:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2314:	0037766d 	eorseq	r7, r7, sp, ror #12
    2318:	5f617369 	svcpl	0x00617369
    231c:	5f746962 	svcpl	0x00746962
    2320:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2324:	645f0038 	ldrbvs	r0, [pc], #-56	; 232c <shift+0x232c>
    2328:	5f746e6f 	svcpl	0x00746e6f
    232c:	5f657375 	svcpl	0x00657375
    2330:	5f787472 	svcpl	0x00787472
    2334:	65726568 	ldrbvs	r6, [r2, #-1384]!	; 0xfffffa98
    2338:	5155005f 	cmppl	r5, pc, asr r0
    233c:	70797449 	rsbsvc	r7, r9, r9, asr #8
    2340:	72610065 	rsbvc	r0, r1, #101	; 0x65
    2344:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    2348:	6100656e 	tstvs	r0, lr, ror #10
    234c:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    2350:	695f7070 	ldmdbvs	pc, {r4, r5, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    2354:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    2358:	6b726f77 	blvs	1c9e13c <__bss_end+0x1c95220>
    235c:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
    2360:	74705f63 	ldrbtvc	r5, [r0], #-3939	; 0xfffff09d
    2364:	41540072 	cmpmi	r4, r2, ror r0
    2368:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    236c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2370:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2374:	74303239 	ldrtvc	r3, [r0], #-569	; 0xfffffdc7
    2378:	61746800 	cmnvs	r4, r0, lsl #16
    237c:	71655f62 	cmnvc	r5, r2, ror #30
    2380:	52415400 	subpl	r5, r1, #0, 8
    2384:	5f544547 	svcpl	0x00544547
    2388:	5f555043 	svcpl	0x00555043
    238c:	32356166 	eorscc	r6, r5, #-2147483623	; 0x80000019
    2390:	72610036 	rsbvc	r0, r1, #54	; 0x36
    2394:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2398:	745f6863 	ldrbvc	r6, [pc], #-2147	; 23a0 <shift+0x23a0>
    239c:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    23a0:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
    23a4:	68007669 	stmdavs	r0, {r0, r3, r5, r6, r9, sl, ip, sp, lr}
    23a8:	5f626174 	svcpl	0x00626174
    23ac:	705f7165 	subsvc	r7, pc, r5, ror #2
    23b0:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    23b4:	54007265 	strpl	r7, [r0], #-613	; 0xfffffd9b
    23b8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    23bc:	50435f54 	subpl	r5, r3, r4, asr pc
    23c0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    23c4:	0030366d 	eorseq	r3, r0, sp, ror #12
    23c8:	20554e47 	subscs	r4, r5, r7, asr #28
    23cc:	20373143 	eorscs	r3, r7, r3, asr #2
    23d0:	2e332e38 	mrccs	14, 1, r2, cr3, cr8, {1}
    23d4:	30322031 	eorscc	r2, r2, r1, lsr r0
    23d8:	37303931 			; <UNDEFINED> instruction: 0x37303931
    23dc:	28203330 	stmdacs	r0!, {r4, r5, r8, r9, ip, sp}
    23e0:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    23e4:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    23e8:	63675b20 	cmnvs	r7, #32, 22	; 0x8000
    23ec:	2d382d63 	ldccs	13, cr2, [r8, #-396]!	; 0xfffffe74
    23f0:	6e617262 	cdpvs	2, 6, cr7, cr1, cr2, {3}
    23f4:	72206863 	eorvc	r6, r0, #6488064	; 0x630000
    23f8:	73697665 	cmnvc	r9, #105906176	; 0x6500000
    23fc:	206e6f69 	rsbcs	r6, lr, r9, ror #30
    2400:	30333732 	eorscc	r3, r3, r2, lsr r7
    2404:	205d3732 	subscs	r3, sp, r2, lsr r7
    2408:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    240c:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
    2410:	616f6c66 	cmnvs	pc, r6, ror #24
    2414:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    2418:	61683d69 	cmnvs	r8, r9, ror #26
    241c:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    2420:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
    2424:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
    2428:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    242c:	70662b65 	rsbvc	r2, r6, r5, ror #22
    2430:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    2434:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    2438:	4f2d2067 	svcmi	0x002d2067
    243c:	4f2d2032 	svcmi	0x002d2032
    2440:	4f2d2032 	svcmi	0x002d2032
    2444:	662d2032 			; <UNDEFINED> instruction: 0x662d2032
    2448:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    244c:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
    2450:	62696c2d 	rsbvs	r6, r9, #11520	; 0x2d00
    2454:	20636367 	rsbcs	r6, r3, r7, ror #6
    2458:	6f6e662d 	svcvs	0x006e662d
    245c:	6174732d 	cmnvs	r4, sp, lsr #6
    2460:	702d6b63 	eorvc	r6, sp, r3, ror #22
    2464:	65746f72 	ldrbvs	r6, [r4, #-3954]!	; 0xfffff08e
    2468:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    246c:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    2470:	6e692d6f 	cdpvs	13, 6, cr2, cr9, cr15, {3}
    2474:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    2478:	76662d20 	strbtvc	r2, [r6], -r0, lsr #26
    247c:	62697369 	rsbvs	r7, r9, #-1543503871	; 0xa4000001
    2480:	74696c69 	strbtvc	r6, [r9], #-3177	; 0xfffff397
    2484:	69683d79 	stmdbvs	r8!, {r0, r3, r4, r5, r6, r8, sl, fp, ip, sp}^
    2488:	6e656464 	cdpvs	4, 6, cr6, cr5, cr4, {3}
    248c:	6d726100 	ldfvse	f6, [r2, #-0]
    2490:	6369705f 	cmnvs	r9, #95	; 0x5f
    2494:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    2498:	65747369 	ldrbvs	r7, [r4, #-873]!	; 0xfffffc97
    249c:	41540072 	cmpmi	r4, r2, ror r0
    24a0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    24a4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    24a8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    24ac:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    24b0:	616d7330 	cmnvs	sp, r0, lsr r3
    24b4:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    24b8:	7069746c 	rsbvc	r7, r9, ip, ror #8
    24bc:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    24c0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    24c4:	50435f54 	subpl	r5, r3, r4, asr pc
    24c8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    24cc:	3636396d 	ldrtcc	r3, [r6], -sp, ror #18
    24d0:	54007365 	strpl	r7, [r0], #-869	; 0xfffffc9b
    24d4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    24d8:	50435f54 	subpl	r5, r3, r4, asr pc
    24dc:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    24e0:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    24e4:	66766f6e 	ldrbtvs	r6, [r6], -lr, ror #30
    24e8:	73690070 	cmnvc	r9, #112	; 0x70
    24ec:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    24f0:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    24f4:	5f6b7269 	svcpl	0x006b7269
    24f8:	5f336d63 	svcpl	0x00336d63
    24fc:	6472646c 	ldrbtvs	r6, [r2], #-1132	; 0xfffffb94
    2500:	52415400 	subpl	r5, r1, #0, 8
    2504:	5f544547 	svcpl	0x00544547
    2508:	5f555043 	svcpl	0x00555043
    250c:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    2510:	00693030 	rsbeq	r3, r9, r0, lsr r0
    2514:	5f4d5241 	svcpl	0x004d5241
    2518:	61004343 	tstvs	r0, r3, asr #6
    251c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2520:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2524:	5400325f 	strpl	r3, [r0], #-607	; 0xfffffda1
    2528:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    252c:	50435f54 	subpl	r5, r3, r4, asr pc
    2530:	6d665f55 	stclvs	15, cr5, [r6, #-340]!	; 0xfffffeac
    2534:	36323670 			; <UNDEFINED> instruction: 0x36323670
    2538:	4d524100 	ldfmie	f4, [r2, #-0]
    253c:	0053435f 	subseq	r4, r3, pc, asr r3
    2540:	5f6d7261 	svcpl	0x006d7261
    2544:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    2548:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    254c:	72610074 	rsbvc	r0, r1, #116	; 0x74
    2550:	61625f6d 	cmnvs	r2, sp, ror #30
    2554:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    2558:	00686372 	rsbeq	r6, r8, r2, ror r3
    255c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2560:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2564:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2568:	6d376d72 	ldcvs	13, cr6, [r7, #-456]!	; 0xfffffe38
    256c:	52415400 	subpl	r5, r1, #0, 8
    2570:	5f544547 	svcpl	0x00544547
    2574:	5f555043 	svcpl	0x00555043
    2578:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    257c:	41540030 	cmpmi	r4, r0, lsr r0
    2580:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2584:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2588:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    258c:	00303532 	eorseq	r3, r0, r2, lsr r5
    2590:	5f6d7261 	svcpl	0x006d7261
    2594:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2598:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    259c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    25a0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    25a4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    25a8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    25ac:	32376178 	eorscc	r6, r7, #120, 2
    25b0:	6d726100 	ldfvse	f6, [r2, #-0]
    25b4:	7363705f 	cmnvc	r3, #95	; 0x5f
    25b8:	6665645f 			; <UNDEFINED> instruction: 0x6665645f
    25bc:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
    25c0:	4d524100 	ldfmie	f4, [r2, #-0]
    25c4:	5343505f 	movtpl	r5, #12383	; 0x305f
    25c8:	5041415f 	subpl	r4, r1, pc, asr r1
    25cc:	4c5f5343 	mrrcmi	3, 4, r5, pc, cr3	; <UNPREDICTABLE>
    25d0:	4c41434f 	mcrrmi	3, 4, r4, r1, cr15
    25d4:	52415400 	subpl	r5, r1, #0, 8
    25d8:	5f544547 	svcpl	0x00544547
    25dc:	5f555043 	svcpl	0x00555043
    25e0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    25e4:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    25e8:	41540035 	cmpmi	r4, r5, lsr r0
    25ec:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25f0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    25f4:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    25f8:	61676e6f 	cmnvs	r7, pc, ror #28
    25fc:	61006d72 	tstvs	r0, r2, ror sp
    2600:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2604:	5f686372 	svcpl	0x00686372
    2608:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    260c:	61003162 	tstvs	r0, r2, ror #2
    2610:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2614:	5f686372 	svcpl	0x00686372
    2618:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    261c:	54003262 	strpl	r3, [r0], #-610	; 0xfffffd9e
    2620:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2624:	50435f54 	subpl	r5, r3, r4, asr pc
    2628:	77695f55 			; <UNDEFINED> instruction: 0x77695f55
    262c:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    2630:	52415400 	subpl	r5, r1, #0, 8
    2634:	5f544547 	svcpl	0x00544547
    2638:	5f555043 	svcpl	0x00555043
    263c:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    2640:	00743232 	rsbseq	r3, r4, r2, lsr r2
    2644:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2648:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    264c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2650:	64376d72 	ldrtvs	r6, [r7], #-3442	; 0xfffff28e
    2654:	61736900 	cmnvs	r3, r0, lsl #18
    2658:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    265c:	00706d5f 	rsbseq	r6, r0, pc, asr sp
    2660:	5f6d7261 	svcpl	0x006d7261
    2664:	735f646c 	cmpvc	pc, #108, 8	; 0x6c000000
    2668:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    266c:	6d726100 	ldfvse	f6, [r2, #-0]
    2670:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2674:	315f3868 	cmpcc	pc, r8, ror #16
	...

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
  20:	8b040e42 	blhi	103930 <__bss_end+0xfaa14>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x347914>
  28:	420d0d66 	andmi	r0, sp, #6528	; 0x1980
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	0000806c 	andeq	r8, r0, ip, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1faa34>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9d64>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080ac 	andeq	r8, r0, ip, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfaa64>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x347964>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080e4 	andeq	r8, r0, r4, ror #1
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfaa84>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x347984>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008110 	andeq	r8, r0, r0, lsl r1
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfaaa4>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x3479a4>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008130 	andeq	r8, r0, r0, lsr r1
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfaac4>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x3479c4>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008148 	andeq	r8, r0, r8, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfaae4>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x3479e4>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008160 	andeq	r8, r0, r0, ror #2
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfab04>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x347a04>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008178 	andeq	r8, r0, r8, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfab24>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x347a24>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	00008184 	andeq	r8, r0, r4, lsl #3
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1fab3c>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081dc 	ldrdeq	r8, [r0], -ip
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1fab5c>
 16c:	42018e02 	andmi	r8, r1, #2, 28
 170:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 174:	00080d0c 	andeq	r0, r8, ip, lsl #26
 178:	0000000c 	andeq	r0, r0, ip
 17c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 180:	7c020001 	stcvc	0, cr0, [r2], {1}
 184:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 188:	0000001c 	andeq	r0, r0, ip, lsl r0
 18c:	00000178 	andeq	r0, r0, r8, ror r1
 190:	00008234 	andeq	r8, r0, r4, lsr r2
 194:	0000003c 	andeq	r0, r0, ip, lsr r0
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1fab8c>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	58040b0c 	stmdapl	r4, {r2, r3, r8, r9, fp}
 1a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1ac:	00000178 	andeq	r0, r0, r8, ror r1
 1b0:	00008270 	andeq	r8, r0, r0, ror r2
 1b4:	00000038 	andeq	r0, r0, r8, lsr r0
 1b8:	8b080e42 	blhi	203ac8 <__bss_end+0x1fabac>
 1bc:	42018e02 	andmi	r8, r1, #2, 28
 1c0:	56040b0c 	strpl	r0, [r4], -ip, lsl #22
 1c4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1c8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1cc:	00000178 	andeq	r0, r0, r8, ror r1
 1d0:	000082a8 	andeq	r8, r0, r8, lsr #5
 1d4:	000000a0 	andeq	r0, r0, r0, lsr #1
 1d8:	8b080e42 	blhi	203ae8 <__bss_end+0x1fabcc>
 1dc:	42018e02 	andmi	r8, r1, #2, 28
 1e0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 1e4:	080d0c44 	stmdaeq	sp, {r2, r6, sl, fp}
 1e8:	0000000c 	andeq	r0, r0, ip
 1ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1f0:	7c020001 	stcvc	0, cr0, [r2], {1}
 1f4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1f8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1fc:	000001e8 	andeq	r0, r0, r8, ror #3
 200:	00008348 	andeq	r8, r0, r8, asr #6
 204:	0000002c 	andeq	r0, r0, ip, lsr #32
 208:	8b040e42 	blhi	103b18 <__bss_end+0xfabfc>
 20c:	0b0d4201 	bleq	350a18 <__bss_end+0x347afc>
 210:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 214:	00000ecb 	andeq	r0, r0, fp, asr #29
 218:	0000001c 	andeq	r0, r0, ip, lsl r0
 21c:	000001e8 	andeq	r0, r0, r8, ror #3
 220:	00008374 	andeq	r8, r0, r4, ror r3
 224:	0000002c 	andeq	r0, r0, ip, lsr #32
 228:	8b040e42 	blhi	103b38 <__bss_end+0xfac1c>
 22c:	0b0d4201 	bleq	350a38 <__bss_end+0x347b1c>
 230:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 234:	00000ecb 	andeq	r0, r0, fp, asr #29
 238:	0000001c 	andeq	r0, r0, ip, lsl r0
 23c:	000001e8 	andeq	r0, r0, r8, ror #3
 240:	000083a0 	andeq	r8, r0, r0, lsr #7
 244:	0000001c 	andeq	r0, r0, ip, lsl r0
 248:	8b040e42 	blhi	103b58 <__bss_end+0xfac3c>
 24c:	0b0d4201 	bleq	350a58 <__bss_end+0x347b3c>
 250:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 254:	00000ecb 	andeq	r0, r0, fp, asr #29
 258:	0000001c 	andeq	r0, r0, ip, lsl r0
 25c:	000001e8 	andeq	r0, r0, r8, ror #3
 260:	000083bc 			; <UNDEFINED> instruction: 0x000083bc
 264:	00000044 	andeq	r0, r0, r4, asr #32
 268:	8b040e42 	blhi	103b78 <__bss_end+0xfac5c>
 26c:	0b0d4201 	bleq	350a78 <__bss_end+0x347b5c>
 270:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 274:	00000ecb 	andeq	r0, r0, fp, asr #29
 278:	0000001c 	andeq	r0, r0, ip, lsl r0
 27c:	000001e8 	andeq	r0, r0, r8, ror #3
 280:	00008400 	andeq	r8, r0, r0, lsl #8
 284:	00000050 	andeq	r0, r0, r0, asr r0
 288:	8b040e42 	blhi	103b98 <__bss_end+0xfac7c>
 28c:	0b0d4201 	bleq	350a98 <__bss_end+0x347b7c>
 290:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 294:	00000ecb 	andeq	r0, r0, fp, asr #29
 298:	0000001c 	andeq	r0, r0, ip, lsl r0
 29c:	000001e8 	andeq	r0, r0, r8, ror #3
 2a0:	00008450 	andeq	r8, r0, r0, asr r4
 2a4:	00000050 	andeq	r0, r0, r0, asr r0
 2a8:	8b040e42 	blhi	103bb8 <__bss_end+0xfac9c>
 2ac:	0b0d4201 	bleq	350ab8 <__bss_end+0x347b9c>
 2b0:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b4:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b8:	0000001c 	andeq	r0, r0, ip, lsl r0
 2bc:	000001e8 	andeq	r0, r0, r8, ror #3
 2c0:	000084a0 	andeq	r8, r0, r0, lsr #9
 2c4:	0000002c 	andeq	r0, r0, ip, lsr #32
 2c8:	8b040e42 	blhi	103bd8 <__bss_end+0xfacbc>
 2cc:	0b0d4201 	bleq	350ad8 <__bss_end+0x347bbc>
 2d0:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 2d4:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d8:	0000001c 	andeq	r0, r0, ip, lsl r0
 2dc:	000001e8 	andeq	r0, r0, r8, ror #3
 2e0:	000084cc 	andeq	r8, r0, ip, asr #9
 2e4:	00000050 	andeq	r0, r0, r0, asr r0
 2e8:	8b040e42 	blhi	103bf8 <__bss_end+0xfacdc>
 2ec:	0b0d4201 	bleq	350af8 <__bss_end+0x347bdc>
 2f0:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f4:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f8:	0000001c 	andeq	r0, r0, ip, lsl r0
 2fc:	000001e8 	andeq	r0, r0, r8, ror #3
 300:	0000851c 	andeq	r8, r0, ip, lsl r5
 304:	00000044 	andeq	r0, r0, r4, asr #32
 308:	8b040e42 	blhi	103c18 <__bss_end+0xfacfc>
 30c:	0b0d4201 	bleq	350b18 <__bss_end+0x347bfc>
 310:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 314:	00000ecb 	andeq	r0, r0, fp, asr #29
 318:	0000001c 	andeq	r0, r0, ip, lsl r0
 31c:	000001e8 	andeq	r0, r0, r8, ror #3
 320:	00008560 	andeq	r8, r0, r0, ror #10
 324:	00000050 	andeq	r0, r0, r0, asr r0
 328:	8b040e42 	blhi	103c38 <__bss_end+0xfad1c>
 32c:	0b0d4201 	bleq	350b38 <__bss_end+0x347c1c>
 330:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 334:	00000ecb 	andeq	r0, r0, fp, asr #29
 338:	0000001c 	andeq	r0, r0, ip, lsl r0
 33c:	000001e8 	andeq	r0, r0, r8, ror #3
 340:	000085b0 			; <UNDEFINED> instruction: 0x000085b0
 344:	00000054 	andeq	r0, r0, r4, asr r0
 348:	8b040e42 	blhi	103c58 <__bss_end+0xfad3c>
 34c:	0b0d4201 	bleq	350b58 <__bss_end+0x347c3c>
 350:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 354:	00000ecb 	andeq	r0, r0, fp, asr #29
 358:	0000001c 	andeq	r0, r0, ip, lsl r0
 35c:	000001e8 	andeq	r0, r0, r8, ror #3
 360:	00008604 	andeq	r8, r0, r4, lsl #12
 364:	0000003c 	andeq	r0, r0, ip, lsr r0
 368:	8b040e42 	blhi	103c78 <__bss_end+0xfad5c>
 36c:	0b0d4201 	bleq	350b78 <__bss_end+0x347c5c>
 370:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 374:	00000ecb 	andeq	r0, r0, fp, asr #29
 378:	0000001c 	andeq	r0, r0, ip, lsl r0
 37c:	000001e8 	andeq	r0, r0, r8, ror #3
 380:	00008640 	andeq	r8, r0, r0, asr #12
 384:	0000003c 	andeq	r0, r0, ip, lsr r0
 388:	8b040e42 	blhi	103c98 <__bss_end+0xfad7c>
 38c:	0b0d4201 	bleq	350b98 <__bss_end+0x347c7c>
 390:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 394:	00000ecb 	andeq	r0, r0, fp, asr #29
 398:	0000001c 	andeq	r0, r0, ip, lsl r0
 39c:	000001e8 	andeq	r0, r0, r8, ror #3
 3a0:	0000867c 	andeq	r8, r0, ip, ror r6
 3a4:	0000003c 	andeq	r0, r0, ip, lsr r0
 3a8:	8b040e42 	blhi	103cb8 <__bss_end+0xfad9c>
 3ac:	0b0d4201 	bleq	350bb8 <__bss_end+0x347c9c>
 3b0:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 3b4:	00000ecb 	andeq	r0, r0, fp, asr #29
 3b8:	0000001c 	andeq	r0, r0, ip, lsl r0
 3bc:	000001e8 	andeq	r0, r0, r8, ror #3
 3c0:	000086b8 			; <UNDEFINED> instruction: 0x000086b8
 3c4:	0000003c 	andeq	r0, r0, ip, lsr r0
 3c8:	8b040e42 	blhi	103cd8 <__bss_end+0xfadbc>
 3cc:	0b0d4201 	bleq	350bd8 <__bss_end+0x347cbc>
 3d0:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 3d4:	00000ecb 	andeq	r0, r0, fp, asr #29
 3d8:	0000001c 	andeq	r0, r0, ip, lsl r0
 3dc:	000001e8 	andeq	r0, r0, r8, ror #3
 3e0:	000086f4 	strdeq	r8, [r0], -r4
 3e4:	000000b4 	strheq	r0, [r0], -r4
 3e8:	8b080e42 	blhi	203cf8 <__bss_end+0x1faddc>
 3ec:	42018e02 	andmi	r8, r1, #2, 28
 3f0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3f4:	080d0c52 	stmdaeq	sp, {r1, r4, r6, sl, fp}
 3f8:	0000000c 	andeq	r0, r0, ip
 3fc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 400:	7c020001 	stcvc	0, cr0, [r2], {1}
 404:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 408:	0000001c 	andeq	r0, r0, ip, lsl r0
 40c:	000003f8 	strdeq	r0, [r0], -r8
 410:	000087a8 	andeq	r8, r0, r8, lsr #15
 414:	00000174 	andeq	r0, r0, r4, ror r1
 418:	8b080e42 	blhi	203d28 <__bss_end+0x1fae0c>
 41c:	42018e02 	andmi	r8, r1, #2, 28
 420:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 424:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 428:	0000001c 	andeq	r0, r0, ip, lsl r0
 42c:	000003f8 	strdeq	r0, [r0], -r8
 430:	0000891c 	andeq	r8, r0, ip, lsl r9
 434:	0000009c 	muleq	r0, ip, r0
 438:	8b040e42 	blhi	103d48 <__bss_end+0xfae2c>
 43c:	0b0d4201 	bleq	350c48 <__bss_end+0x347d2c>
 440:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 444:	000ecb42 	andeq	ip, lr, r2, asr #22
 448:	0000001c 	andeq	r0, r0, ip, lsl r0
 44c:	000003f8 	strdeq	r0, [r0], -r8
 450:	000089b8 			; <UNDEFINED> instruction: 0x000089b8
 454:	000000c0 	andeq	r0, r0, r0, asr #1
 458:	8b040e42 	blhi	103d68 <__bss_end+0xfae4c>
 45c:	0b0d4201 	bleq	350c68 <__bss_end+0x347d4c>
 460:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 464:	000ecb42 	andeq	ip, lr, r2, asr #22
 468:	0000001c 	andeq	r0, r0, ip, lsl r0
 46c:	000003f8 	strdeq	r0, [r0], -r8
 470:	00008a78 	andeq	r8, r0, r8, ror sl
 474:	000000ac 	andeq	r0, r0, ip, lsr #1
 478:	8b040e42 	blhi	103d88 <__bss_end+0xfae6c>
 47c:	0b0d4201 	bleq	350c88 <__bss_end+0x347d6c>
 480:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 484:	000ecb42 	andeq	ip, lr, r2, asr #22
 488:	0000001c 	andeq	r0, r0, ip, lsl r0
 48c:	000003f8 	strdeq	r0, [r0], -r8
 490:	00008b24 	andeq	r8, r0, r4, lsr #22
 494:	00000054 	andeq	r0, r0, r4, asr r0
 498:	8b040e42 	blhi	103da8 <__bss_end+0xfae8c>
 49c:	0b0d4201 	bleq	350ca8 <__bss_end+0x347d8c>
 4a0:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 4a4:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 4ac:	000003f8 	strdeq	r0, [r0], -r8
 4b0:	00008b78 	andeq	r8, r0, r8, ror fp
 4b4:	00000068 	andeq	r0, r0, r8, rrx
 4b8:	8b040e42 	blhi	103dc8 <__bss_end+0xfaeac>
 4bc:	0b0d4201 	bleq	350cc8 <__bss_end+0x347dac>
 4c0:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 4c4:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c8:	0000001c 	andeq	r0, r0, ip, lsl r0
 4cc:	000003f8 	strdeq	r0, [r0], -r8
 4d0:	00008be0 	andeq	r8, r0, r0, ror #23
 4d4:	00000080 	andeq	r0, r0, r0, lsl #1
 4d8:	8b040e42 	blhi	103de8 <__bss_end+0xfaecc>
 4dc:	0b0d4201 	bleq	350ce8 <__bss_end+0x347dcc>
 4e0:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4e4:	00000ecb 	andeq	r0, r0, fp, asr #29
 4e8:	0000000c 	andeq	r0, r0, ip
 4ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4f0:	7c010001 	stcvc	0, cr0, [r1], {1}
 4f4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4f8:	0000000c 	andeq	r0, r0, ip
 4fc:	000004e8 	andeq	r0, r0, r8, ror #9
 500:	00008c60 	andeq	r8, r0, r0, ror #24
 504:	000001ec 	andeq	r0, r0, ip, ror #3
