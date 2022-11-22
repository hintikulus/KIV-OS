
./sos_task:     file format elf32-littlearm


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
    8064:	00009024 	andeq	r9, r0, r4, lsr #32
    8068:	0000903c 	andeq	r9, r0, ip, lsr r0

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
    8088:	eb000089 	bl	82b4 <main>
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
    81d4:	00009021 	andeq	r9, r0, r1, lsr #32
    81d8:	00009021 	andeq	r9, r0, r1, lsr #32

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
    822c:	00009021 	andeq	r9, r0, r1, lsr #32
    8230:	00009021 	andeq	r9, r0, r1, lsr #32

00008234 <_Z5blinkb>:
_Z5blinkb():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:23

uint32_t sos_led;
uint32_t button;

void blink(bool short_blink)
{
    8234:	e92d4800 	push	{fp, lr}
    8238:	e28db004 	add	fp, sp, #4
    823c:	e24dd008 	sub	sp, sp, #8
    8240:	e1a03000 	mov	r3, r0
    8244:	e54b3005 	strb	r3, [fp, #-5]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:24
	write(sos_led, "1", 1);
    8248:	e59f3058 	ldr	r3, [pc, #88]	; 82a8 <_Z5blinkb+0x74>
    824c:	e5933000 	ldr	r3, [r3]
    8250:	e3a02001 	mov	r2, #1
    8254:	e59f1050 	ldr	r1, [pc, #80]	; 82ac <_Z5blinkb+0x78>
    8258:	e1a00003 	mov	r0, r3
    825c:	eb0000b1 	bl	8528 <_Z5writejPKcj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:25
	sleep(short_blink ? 0x800 : 0x1000);
    8260:	e55b3005 	ldrb	r3, [fp, #-5]
    8264:	e3530000 	cmp	r3, #0
    8268:	0a000001 	beq	8274 <_Z5blinkb+0x40>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:25 (discriminator 1)
    826c:	e3a03b02 	mov	r3, #2048	; 0x800
    8270:	ea000000 	b	8278 <_Z5blinkb+0x44>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:25 (discriminator 2)
    8274:	e3a03a01 	mov	r3, #4096	; 0x1000
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:25 (discriminator 4)
    8278:	e3e01001 	mvn	r1, #1
    827c:	e1a00003 	mov	r0, r3
    8280:	eb000100 	bl	8688 <_Z5sleepjj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:26 (discriminator 4)
	write(sos_led, "0", 1);
    8284:	e59f301c 	ldr	r3, [pc, #28]	; 82a8 <_Z5blinkb+0x74>
    8288:	e5933000 	ldr	r3, [r3]
    828c:	e3a02001 	mov	r2, #1
    8290:	e59f1018 	ldr	r1, [pc, #24]	; 82b0 <_Z5blinkb+0x7c>
    8294:	e1a00003 	mov	r0, r3
    8298:	eb0000a2 	bl	8528 <_Z5writejPKcj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:27 (discriminator 4)
}
    829c:	e320f000 	nop	{0}
    82a0:	e24bd004 	sub	sp, fp, #4
    82a4:	e8bd8800 	pop	{fp, pc}
    82a8:	00009024 	andeq	r9, r0, r4, lsr #32
    82ac:	00008fac 	andeq	r8, r0, ip, lsr #31
    82b0:	00008fb0 			; <UNDEFINED> instruction: 0x00008fb0

000082b4 <main>:
main():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:30

int main(int argc, char** argv)
{
    82b4:	e92d4800 	push	{fp, lr}
    82b8:	e28db004 	add	fp, sp, #4
    82bc:	e24dd010 	sub	sp, sp, #16
    82c0:	e50b0010 	str	r0, [fp, #-16]
    82c4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:31
	sos_led = open("DEV:gpio/18", NFile_Open_Mode::Write_Only);
    82c8:	e3a01001 	mov	r1, #1
    82cc:	e59f0134 	ldr	r0, [pc, #308]	; 8408 <main+0x154>
    82d0:	eb00006f 	bl	8494 <_Z4openPKc15NFile_Open_Mode>
    82d4:	e1a02000 	mov	r2, r0
    82d8:	e59f312c 	ldr	r3, [pc, #300]	; 840c <main+0x158>
    82dc:	e5832000 	str	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:32
	button = open("DEV:gpio/16", NFile_Open_Mode::Read_Only);
    82e0:	e3a01000 	mov	r1, #0
    82e4:	e59f0124 	ldr	r0, [pc, #292]	; 8410 <main+0x15c>
    82e8:	eb000069 	bl	8494 <_Z4openPKc15NFile_Open_Mode>
    82ec:	e1a02000 	mov	r2, r0
    82f0:	e59f311c 	ldr	r3, [pc, #284]	; 8414 <main+0x160>
    82f4:	e5832000 	str	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:34

	NGPIO_Interrupt_Type irtype = NGPIO_Interrupt_Type::Rising_Edge;
    82f8:	e3a03000 	mov	r3, #0
    82fc:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:35
	ioctl(button, NIOCtl_Operation::Enable_Event_Detection, &irtype);
    8300:	e59f310c 	ldr	r3, [pc, #268]	; 8414 <main+0x160>
    8304:	e5933000 	ldr	r3, [r3]
    8308:	e24b200c 	sub	r2, fp, #12
    830c:	e3a01002 	mov	r1, #2
    8310:	e1a00003 	mov	r0, r3
    8314:	eb0000a2 	bl	85a4 <_Z5ioctlj16NIOCtl_OperationPv>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:37

	uint32_t logpipe = pipe("log", 32);
    8318:	e3a01020 	mov	r1, #32
    831c:	e59f00f4 	ldr	r0, [pc, #244]	; 8418 <main+0x164>
    8320:	eb000129 	bl	87cc <_Z4pipePKcj>
    8324:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:42 (discriminator 1)

	while (true)
	{
		// pockame na stisk klavesy
		wait(button, 1, 0x300);
    8328:	e59f30e4 	ldr	r3, [pc, #228]	; 8414 <main+0x160>
    832c:	e5933000 	ldr	r3, [r3]
    8330:	e3a02c03 	mov	r2, #768	; 0x300
    8334:	e3a01001 	mov	r1, #1
    8338:	e1a00003 	mov	r0, r3
    833c:	eb0000bd 	bl	8638 <_Z4waitjjj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:51 (discriminator 1)
		// 2) my mame deadline 0x300
		// 3) log task ma deadline 0x1000
		// 4) jiny task ma deadline 0x500
		// jiny task dostane prednost pred log taskem, a pokud nesplni v kratkem case svou ulohu, tento task prekroci deadline
		// TODO: inverzi priorit bychom docasne zvysili prioritu (zkratili deadline) log tasku, aby vyprazdnil pipe a my se mohli odblokovat co nejdrive
		write(logpipe, "SOS!", 5);
    8340:	e3a02005 	mov	r2, #5
    8344:	e59f10d0 	ldr	r1, [pc, #208]	; 841c <main+0x168>
    8348:	e51b0008 	ldr	r0, [fp, #-8]
    834c:	eb000075 	bl	8528 <_Z5writejPKcj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:53 (discriminator 1)

		blink(true);
    8350:	e3a00001 	mov	r0, #1
    8354:	ebffffb6 	bl	8234 <_Z5blinkb>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:54 (discriminator 1)
		sleep(symbol_tick_delay);
    8358:	e3e01001 	mvn	r1, #1
    835c:	e3a00b01 	mov	r0, #1024	; 0x400
    8360:	eb0000c8 	bl	8688 <_Z5sleepjj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:55 (discriminator 1)
		blink(true);
    8364:	e3a00001 	mov	r0, #1
    8368:	ebffffb1 	bl	8234 <_Z5blinkb>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:56 (discriminator 1)
		sleep(symbol_tick_delay);
    836c:	e3e01001 	mvn	r1, #1
    8370:	e3a00b01 	mov	r0, #1024	; 0x400
    8374:	eb0000c3 	bl	8688 <_Z5sleepjj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:57 (discriminator 1)
		blink(true);
    8378:	e3a00001 	mov	r0, #1
    837c:	ebffffac 	bl	8234 <_Z5blinkb>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:59 (discriminator 1)

		sleep(char_tick_delay);
    8380:	e3e01001 	mvn	r1, #1
    8384:	e3a00a01 	mov	r0, #4096	; 0x1000
    8388:	eb0000be 	bl	8688 <_Z5sleepjj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:61 (discriminator 1)

		blink(false);
    838c:	e3a00000 	mov	r0, #0
    8390:	ebffffa7 	bl	8234 <_Z5blinkb>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:62 (discriminator 1)
		sleep(symbol_tick_delay);
    8394:	e3e01001 	mvn	r1, #1
    8398:	e3a00b01 	mov	r0, #1024	; 0x400
    839c:	eb0000b9 	bl	8688 <_Z5sleepjj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:63 (discriminator 1)
		blink(false);
    83a0:	e3a00000 	mov	r0, #0
    83a4:	ebffffa2 	bl	8234 <_Z5blinkb>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:64 (discriminator 1)
		sleep(symbol_tick_delay);
    83a8:	e3e01001 	mvn	r1, #1
    83ac:	e3a00b01 	mov	r0, #1024	; 0x400
    83b0:	eb0000b4 	bl	8688 <_Z5sleepjj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:65 (discriminator 1)
		blink(false);
    83b4:	e3a00000 	mov	r0, #0
    83b8:	ebffff9d 	bl	8234 <_Z5blinkb>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:66 (discriminator 1)
		sleep(symbol_tick_delay);
    83bc:	e3e01001 	mvn	r1, #1
    83c0:	e3a00b01 	mov	r0, #1024	; 0x400
    83c4:	eb0000af 	bl	8688 <_Z5sleepjj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:68 (discriminator 1)

		sleep(char_tick_delay);
    83c8:	e3e01001 	mvn	r1, #1
    83cc:	e3a00a01 	mov	r0, #4096	; 0x1000
    83d0:	eb0000ac 	bl	8688 <_Z5sleepjj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:70 (discriminator 1)

		blink(true);
    83d4:	e3a00001 	mov	r0, #1
    83d8:	ebffff95 	bl	8234 <_Z5blinkb>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:71 (discriminator 1)
		sleep(symbol_tick_delay);
    83dc:	e3e01001 	mvn	r1, #1
    83e0:	e3a00b01 	mov	r0, #1024	; 0x400
    83e4:	eb0000a7 	bl	8688 <_Z5sleepjj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:72 (discriminator 1)
		blink(true);
    83e8:	e3a00001 	mov	r0, #1
    83ec:	ebffff90 	bl	8234 <_Z5blinkb>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:73 (discriminator 1)
		sleep(symbol_tick_delay);
    83f0:	e3e01001 	mvn	r1, #1
    83f4:	e3a00b01 	mov	r0, #1024	; 0x400
    83f8:	eb0000a2 	bl	8688 <_Z5sleepjj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:74 (discriminator 1)
		blink(true);
    83fc:	e3a00001 	mov	r0, #1
    8400:	ebffff8b 	bl	8234 <_Z5blinkb>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/sos_task/main.cpp:42 (discriminator 1)
		wait(button, 1, 0x300);
    8404:	eaffffc7 	b	8328 <main+0x74>
    8408:	00008fb4 			; <UNDEFINED> instruction: 0x00008fb4
    840c:	00009024 	andeq	r9, r0, r4, lsr #32
    8410:	00008fc0 	andeq	r8, r0, r0, asr #31
    8414:	00009028 	andeq	r9, r0, r8, lsr #32
    8418:	00008fcc 	andeq	r8, r0, ip, asr #31
    841c:	00008fd0 	ldrdeq	r8, [r0], -r0

00008420 <_Z6getpidv>:
_Z6getpidv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8420:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8424:	e28db000 	add	fp, sp, #0
    8428:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    842c:	ef000000 	svc	0x00000000
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8430:	e1a03000 	mov	r3, r0
    8434:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:11

    return pid;
    8438:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:12
}
    843c:	e1a00003 	mov	r0, r3
    8440:	e28bd000 	add	sp, fp, #0
    8444:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8448:	e12fff1e 	bx	lr

0000844c <_Z9terminatei>:
_Z9terminatei():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    844c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8450:	e28db000 	add	fp, sp, #0
    8454:	e24dd00c 	sub	sp, sp, #12
    8458:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    845c:	e51b3008 	ldr	r3, [fp, #-8]
    8460:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    8464:	ef000001 	svc	0x00000001
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:18
}
    8468:	e320f000 	nop	{0}
    846c:	e28bd000 	add	sp, fp, #0
    8470:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8474:	e12fff1e 	bx	lr

00008478 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    8478:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    847c:	e28db000 	add	fp, sp, #0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    8480:	ef000002 	svc	0x00000002
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:23
}
    8484:	e320f000 	nop	{0}
    8488:	e28bd000 	add	sp, fp, #0
    848c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8490:	e12fff1e 	bx	lr

00008494 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    8494:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8498:	e28db000 	add	fp, sp, #0
    849c:	e24dd014 	sub	sp, sp, #20
    84a0:	e50b0010 	str	r0, [fp, #-16]
    84a4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    84a8:	e51b3010 	ldr	r3, [fp, #-16]
    84ac:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    84b0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84b4:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    84b8:	ef000040 	svc	0x00000040
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    84bc:	e1a03000 	mov	r3, r0
    84c0:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:34

    return file;
    84c4:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:35
}
    84c8:	e1a00003 	mov	r0, r3
    84cc:	e28bd000 	add	sp, fp, #0
    84d0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84d4:	e12fff1e 	bx	lr

000084d8 <_Z4readjPcj>:
_Z4readjPcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    84d8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84dc:	e28db000 	add	fp, sp, #0
    84e0:	e24dd01c 	sub	sp, sp, #28
    84e4:	e50b0010 	str	r0, [fp, #-16]
    84e8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84ec:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    84f0:	e51b3010 	ldr	r3, [fp, #-16]
    84f4:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    84f8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84fc:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    8500:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8504:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    8508:	ef000041 	svc	0x00000041
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    850c:	e1a03000 	mov	r3, r0
    8510:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    8514:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:48
}
    8518:	e1a00003 	mov	r0, r3
    851c:	e28bd000 	add	sp, fp, #0
    8520:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8524:	e12fff1e 	bx	lr

00008528 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    8528:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    852c:	e28db000 	add	fp, sp, #0
    8530:	e24dd01c 	sub	sp, sp, #28
    8534:	e50b0010 	str	r0, [fp, #-16]
    8538:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    853c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8540:	e51b3010 	ldr	r3, [fp, #-16]
    8544:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    8548:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    854c:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    8550:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8554:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    8558:	ef000042 	svc	0x00000042
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    855c:	e1a03000 	mov	r3, r0
    8560:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    8564:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:61
}
    8568:	e1a00003 	mov	r0, r3
    856c:	e28bd000 	add	sp, fp, #0
    8570:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8574:	e12fff1e 	bx	lr

00008578 <_Z5closej>:
_Z5closej():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    8578:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    857c:	e28db000 	add	fp, sp, #0
    8580:	e24dd00c 	sub	sp, sp, #12
    8584:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    8588:	e51b3008 	ldr	r3, [fp, #-8]
    858c:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    8590:	ef000043 	svc	0x00000043
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:67
}
    8594:	e320f000 	nop	{0}
    8598:	e28bd000 	add	sp, fp, #0
    859c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85a0:	e12fff1e 	bx	lr

000085a4 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    85a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85a8:	e28db000 	add	fp, sp, #0
    85ac:	e24dd01c 	sub	sp, sp, #28
    85b0:	e50b0010 	str	r0, [fp, #-16]
    85b4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    85b8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    85bc:	e51b3010 	ldr	r3, [fp, #-16]
    85c0:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    85c4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85c8:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    85cc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    85d0:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    85d4:	ef000044 	svc	0x00000044
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    85d8:	e1a03000 	mov	r3, r0
    85dc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    85e0:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:80
}
    85e4:	e1a00003 	mov	r0, r3
    85e8:	e28bd000 	add	sp, fp, #0
    85ec:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85f0:	e12fff1e 	bx	lr

000085f4 <_Z6notifyjj>:
_Z6notifyjj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    85f4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85f8:	e28db000 	add	fp, sp, #0
    85fc:	e24dd014 	sub	sp, sp, #20
    8600:	e50b0010 	str	r0, [fp, #-16]
    8604:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    8608:	e51b3010 	ldr	r3, [fp, #-16]
    860c:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    8610:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8614:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    8618:	ef000045 	svc	0x00000045
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    861c:	e1a03000 	mov	r3, r0
    8620:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    8624:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:92
}
    8628:	e1a00003 	mov	r0, r3
    862c:	e28bd000 	add	sp, fp, #0
    8630:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8634:	e12fff1e 	bx	lr

00008638 <_Z4waitjjj>:
_Z4waitjjj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    8638:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    863c:	e28db000 	add	fp, sp, #0
    8640:	e24dd01c 	sub	sp, sp, #28
    8644:	e50b0010 	str	r0, [fp, #-16]
    8648:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    864c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8650:	e51b3010 	ldr	r3, [fp, #-16]
    8654:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    8658:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    865c:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    8660:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8664:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    8668:	ef000046 	svc	0x00000046
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    866c:	e1a03000 	mov	r3, r0
    8670:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    8674:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:105
}
    8678:	e1a00003 	mov	r0, r3
    867c:	e28bd000 	add	sp, fp, #0
    8680:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8684:	e12fff1e 	bx	lr

00008688 <_Z5sleepjj>:
_Z5sleepjj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    8688:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    868c:	e28db000 	add	fp, sp, #0
    8690:	e24dd014 	sub	sp, sp, #20
    8694:	e50b0010 	str	r0, [fp, #-16]
    8698:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    869c:	e51b3010 	ldr	r3, [fp, #-16]
    86a0:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    86a4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    86a8:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    86ac:	ef000003 	svc	0x00000003
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    86b0:	e1a03000 	mov	r3, r0
    86b4:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    86b8:	e51b3008 	ldr	r3, [fp, #-8]
    86bc:	e3530000 	cmp	r3, #0
    86c0:	13a03001 	movne	r3, #1
    86c4:	03a03000 	moveq	r3, #0
    86c8:	e6ef3073 	uxtb	r3, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:117
}
    86cc:	e1a00003 	mov	r0, r3
    86d0:	e28bd000 	add	sp, fp, #0
    86d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86d8:	e12fff1e 	bx	lr

000086dc <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    86dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86e0:	e28db000 	add	fp, sp, #0
    86e4:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    86e8:	e3a03000 	mov	r3, #0
    86ec:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    86f0:	e3a03000 	mov	r3, #0
    86f4:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    86f8:	e24b300c 	sub	r3, fp, #12
    86fc:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    8700:	ef000004 	svc	0x00000004
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:128

    return retval;
    8704:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:129
}
    8708:	e1a00003 	mov	r0, r3
    870c:	e28bd000 	add	sp, fp, #0
    8710:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8714:	e12fff1e 	bx	lr

00008718 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    8718:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    871c:	e28db000 	add	fp, sp, #0
    8720:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    8724:	e3a03001 	mov	r3, #1
    8728:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    872c:	e3a03001 	mov	r3, #1
    8730:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    8734:	e24b300c 	sub	r3, fp, #12
    8738:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    873c:	ef000004 	svc	0x00000004
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:140

    return retval;
    8740:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:141
}
    8744:	e1a00003 	mov	r0, r3
    8748:	e28bd000 	add	sp, fp, #0
    874c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8750:	e12fff1e 	bx	lr

00008754 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    8754:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8758:	e28db000 	add	fp, sp, #0
    875c:	e24dd014 	sub	sp, sp, #20
    8760:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    8764:	e3a03000 	mov	r3, #0
    8768:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    876c:	e3a03000 	mov	r3, #0
    8770:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    8774:	e24b3010 	sub	r3, fp, #16
    8778:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    877c:	ef000005 	svc	0x00000005
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:150
}
    8780:	e320f000 	nop	{0}
    8784:	e28bd000 	add	sp, fp, #0
    8788:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    878c:	e12fff1e 	bx	lr

00008790 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    8790:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8794:	e28db000 	add	fp, sp, #0
    8798:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    879c:	e3a03001 	mov	r3, #1
    87a0:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    87a4:	e3a03001 	mov	r3, #1
    87a8:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    87ac:	e24b300c 	sub	r3, fp, #12
    87b0:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    87b4:	ef000005 	svc	0x00000005
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    87b8:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:162
}
    87bc:	e1a00003 	mov	r0, r3
    87c0:	e28bd000 	add	sp, fp, #0
    87c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    87c8:	e12fff1e 	bx	lr

000087cc <_Z4pipePKcj>:
_Z4pipePKcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    87cc:	e92d4800 	push	{fp, lr}
    87d0:	e28db004 	add	fp, sp, #4
    87d4:	e24dd050 	sub	sp, sp, #80	; 0x50
    87d8:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    87dc:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    87e0:	e24b3048 	sub	r3, fp, #72	; 0x48
    87e4:	e3a0200a 	mov	r2, #10
    87e8:	e59f108c 	ldr	r1, [pc, #140]	; 887c <_Z4pipePKcj+0xb0>
    87ec:	e1a00003 	mov	r0, r3
    87f0:	eb0000a6 	bl	8a90 <_Z7strncpyPcPKci>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    87f4:	e24b3048 	sub	r3, fp, #72	; 0x48
    87f8:	e283300a 	add	r3, r3, #10
    87fc:	e3a02035 	mov	r2, #53	; 0x35
    8800:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    8804:	e1a00003 	mov	r0, r3
    8808:	eb0000a0 	bl	8a90 <_Z7strncpyPcPKci>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    880c:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    8810:	eb0000f9 	bl	8bfc <_Z6strlenPKc>
    8814:	e1a03000 	mov	r3, r0
    8818:	e283300a 	add	r3, r3, #10
    881c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    8820:	e51b3008 	ldr	r3, [fp, #-8]
    8824:	e2832001 	add	r2, r3, #1
    8828:	e50b2008 	str	r2, [fp, #-8]
    882c:	e24b2004 	sub	r2, fp, #4
    8830:	e0823003 	add	r3, r2, r3
    8834:	e3a02023 	mov	r2, #35	; 0x23
    8838:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    883c:	e24b2048 	sub	r2, fp, #72	; 0x48
    8840:	e51b3008 	ldr	r3, [fp, #-8]
    8844:	e0823003 	add	r3, r2, r3
    8848:	e3a0200a 	mov	r2, #10
    884c:	e1a01003 	mov	r1, r3
    8850:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    8854:	eb000009 	bl	8880 <_Z4itoajPcj>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    8858:	e24b3048 	sub	r3, fp, #72	; 0x48
    885c:	e3a01002 	mov	r1, #2
    8860:	e1a00003 	mov	r0, r3
    8864:	ebffff0a 	bl	8494 <_Z4openPKc15NFile_Open_Mode>
    8868:	e1a03000 	mov	r3, r0
    886c:	e320f000 	nop	{0}
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:179
}
    8870:	e1a00003 	mov	r0, r3
    8874:	e24bd004 	sub	sp, fp, #4
    8878:	e8bd8800 	pop	{fp, pc}
    887c:	00009004 	andeq	r9, r0, r4

00008880 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    8880:	e92d4800 	push	{fp, lr}
    8884:	e28db004 	add	fp, sp, #4
    8888:	e24dd020 	sub	sp, sp, #32
    888c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8890:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8894:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:10
	int i = 0;
    8898:	e3a03000 	mov	r3, #0
    889c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:12

	while (input > 0)
    88a0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    88a4:	e3530000 	cmp	r3, #0
    88a8:	0a000014 	beq	8900 <_Z4itoajPcj+0x80>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    88ac:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    88b0:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    88b4:	e1a00003 	mov	r0, r3
    88b8:	eb000199 	bl	8f24 <__aeabi_uidivmod>
    88bc:	e1a03001 	mov	r3, r1
    88c0:	e1a01003 	mov	r1, r3
    88c4:	e51b3008 	ldr	r3, [fp, #-8]
    88c8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88cc:	e0823003 	add	r3, r2, r3
    88d0:	e59f2118 	ldr	r2, [pc, #280]	; 89f0 <_Z4itoajPcj+0x170>
    88d4:	e7d22001 	ldrb	r2, [r2, r1]
    88d8:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:15
		input /= base;
    88dc:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    88e0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    88e4:	eb000113 	bl	8d38 <__udivsi3>
    88e8:	e1a03000 	mov	r3, r0
    88ec:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:16
		i++;
    88f0:	e51b3008 	ldr	r3, [fp, #-8]
    88f4:	e2833001 	add	r3, r3, #1
    88f8:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:12
	while (input > 0)
    88fc:	eaffffe7 	b	88a0 <_Z4itoajPcj+0x20>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    8900:	e51b3008 	ldr	r3, [fp, #-8]
    8904:	e3530000 	cmp	r3, #0
    8908:	1a000007 	bne	892c <_Z4itoajPcj+0xac>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    890c:	e51b3008 	ldr	r3, [fp, #-8]
    8910:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8914:	e0823003 	add	r3, r2, r3
    8918:	e3a02030 	mov	r2, #48	; 0x30
    891c:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:22
        i++;
    8920:	e51b3008 	ldr	r3, [fp, #-8]
    8924:	e2833001 	add	r3, r3, #1
    8928:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    892c:	e51b3008 	ldr	r3, [fp, #-8]
    8930:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8934:	e0823003 	add	r3, r2, r3
    8938:	e3a02000 	mov	r2, #0
    893c:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:26
	i--;
    8940:	e51b3008 	ldr	r3, [fp, #-8]
    8944:	e2433001 	sub	r3, r3, #1
    8948:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    894c:	e3a03000 	mov	r3, #0
    8950:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:28 (discriminator 3)
    8954:	e51b3008 	ldr	r3, [fp, #-8]
    8958:	e1a02fa3 	lsr	r2, r3, #31
    895c:	e0823003 	add	r3, r2, r3
    8960:	e1a030c3 	asr	r3, r3, #1
    8964:	e1a02003 	mov	r2, r3
    8968:	e51b300c 	ldr	r3, [fp, #-12]
    896c:	e1530002 	cmp	r3, r2
    8970:	ca00001b 	bgt	89e4 <_Z4itoajPcj+0x164>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    8974:	e51b2008 	ldr	r2, [fp, #-8]
    8978:	e51b300c 	ldr	r3, [fp, #-12]
    897c:	e0423003 	sub	r3, r2, r3
    8980:	e1a02003 	mov	r2, r3
    8984:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8988:	e0833002 	add	r3, r3, r2
    898c:	e5d33000 	ldrb	r3, [r3]
    8990:	e54b300d 	strb	r3, [fp, #-13]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    8994:	e51b300c 	ldr	r3, [fp, #-12]
    8998:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    899c:	e0822003 	add	r2, r2, r3
    89a0:	e51b1008 	ldr	r1, [fp, #-8]
    89a4:	e51b300c 	ldr	r3, [fp, #-12]
    89a8:	e0413003 	sub	r3, r1, r3
    89ac:	e1a01003 	mov	r1, r3
    89b0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    89b4:	e0833001 	add	r3, r3, r1
    89b8:	e5d22000 	ldrb	r2, [r2]
    89bc:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    89c0:	e51b300c 	ldr	r3, [fp, #-12]
    89c4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    89c8:	e0823003 	add	r3, r2, r3
    89cc:	e55b200d 	ldrb	r2, [fp, #-13]
    89d0:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    89d4:	e51b300c 	ldr	r3, [fp, #-12]
    89d8:	e2833001 	add	r3, r3, #1
    89dc:	e50b300c 	str	r3, [fp, #-12]
    89e0:	eaffffdb 	b	8954 <_Z4itoajPcj+0xd4>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:34
	}
}
    89e4:	e320f000 	nop	{0}
    89e8:	e24bd004 	sub	sp, fp, #4
    89ec:	e8bd8800 	pop	{fp, pc}
    89f0:	00009010 	andeq	r9, r0, r0, lsl r0

000089f4 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    89f4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89f8:	e28db000 	add	fp, sp, #0
    89fc:	e24dd014 	sub	sp, sp, #20
    8a00:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:38
	int output = 0;
    8a04:	e3a03000 	mov	r3, #0
    8a08:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    8a0c:	e51b3010 	ldr	r3, [fp, #-16]
    8a10:	e5d33000 	ldrb	r3, [r3]
    8a14:	e3530000 	cmp	r3, #0
    8a18:	0a000017 	beq	8a7c <_Z4atoiPKc+0x88>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    8a1c:	e51b2008 	ldr	r2, [fp, #-8]
    8a20:	e1a03002 	mov	r3, r2
    8a24:	e1a03103 	lsl	r3, r3, #2
    8a28:	e0833002 	add	r3, r3, r2
    8a2c:	e1a03083 	lsl	r3, r3, #1
    8a30:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    8a34:	e51b3010 	ldr	r3, [fp, #-16]
    8a38:	e5d33000 	ldrb	r3, [r3]
    8a3c:	e3530039 	cmp	r3, #57	; 0x39
    8a40:	8a00000d 	bhi	8a7c <_Z4atoiPKc+0x88>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:43 (discriminator 1)
    8a44:	e51b3010 	ldr	r3, [fp, #-16]
    8a48:	e5d33000 	ldrb	r3, [r3]
    8a4c:	e353002f 	cmp	r3, #47	; 0x2f
    8a50:	9a000009 	bls	8a7c <_Z4atoiPKc+0x88>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    8a54:	e51b3010 	ldr	r3, [fp, #-16]
    8a58:	e5d33000 	ldrb	r3, [r3]
    8a5c:	e2433030 	sub	r3, r3, #48	; 0x30
    8a60:	e51b2008 	ldr	r2, [fp, #-8]
    8a64:	e0823003 	add	r3, r2, r3
    8a68:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:48

		input++;
    8a6c:	e51b3010 	ldr	r3, [fp, #-16]
    8a70:	e2833001 	add	r3, r3, #1
    8a74:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    8a78:	eaffffe3 	b	8a0c <_Z4atoiPKc+0x18>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:51
	}

	return output;
    8a7c:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:52
}
    8a80:	e1a00003 	mov	r0, r3
    8a84:	e28bd000 	add	sp, fp, #0
    8a88:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a8c:	e12fff1e 	bx	lr

00008a90 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    8a90:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a94:	e28db000 	add	fp, sp, #0
    8a98:	e24dd01c 	sub	sp, sp, #28
    8a9c:	e50b0010 	str	r0, [fp, #-16]
    8aa0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8aa4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8aa8:	e3a03000 	mov	r3, #0
    8aac:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58 (discriminator 4)
    8ab0:	e51b2008 	ldr	r2, [fp, #-8]
    8ab4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8ab8:	e1520003 	cmp	r2, r3
    8abc:	aa000011 	bge	8b08 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58 (discriminator 2)
    8ac0:	e51b3008 	ldr	r3, [fp, #-8]
    8ac4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8ac8:	e0823003 	add	r3, r2, r3
    8acc:	e5d33000 	ldrb	r3, [r3]
    8ad0:	e3530000 	cmp	r3, #0
    8ad4:	0a00000b 	beq	8b08 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    8ad8:	e51b3008 	ldr	r3, [fp, #-8]
    8adc:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8ae0:	e0822003 	add	r2, r2, r3
    8ae4:	e51b3008 	ldr	r3, [fp, #-8]
    8ae8:	e51b1010 	ldr	r1, [fp, #-16]
    8aec:	e0813003 	add	r3, r1, r3
    8af0:	e5d22000 	ldrb	r2, [r2]
    8af4:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8af8:	e51b3008 	ldr	r3, [fp, #-8]
    8afc:	e2833001 	add	r3, r3, #1
    8b00:	e50b3008 	str	r3, [fp, #-8]
    8b04:	eaffffe9 	b	8ab0 <_Z7strncpyPcPKci+0x20>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    8b08:	e51b2008 	ldr	r2, [fp, #-8]
    8b0c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b10:	e1520003 	cmp	r2, r3
    8b14:	aa000008 	bge	8b3c <_Z7strncpyPcPKci+0xac>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8b18:	e51b3008 	ldr	r3, [fp, #-8]
    8b1c:	e51b2010 	ldr	r2, [fp, #-16]
    8b20:	e0823003 	add	r3, r2, r3
    8b24:	e3a02000 	mov	r2, #0
    8b28:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8b2c:	e51b3008 	ldr	r3, [fp, #-8]
    8b30:	e2833001 	add	r3, r3, #1
    8b34:	e50b3008 	str	r3, [fp, #-8]
    8b38:	eafffff2 	b	8b08 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:63

   return dest;
    8b3c:	e51b3010 	ldr	r3, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:64
}
    8b40:	e1a00003 	mov	r0, r3
    8b44:	e28bd000 	add	sp, fp, #0
    8b48:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b4c:	e12fff1e 	bx	lr

00008b50 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    8b50:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b54:	e28db000 	add	fp, sp, #0
    8b58:	e24dd01c 	sub	sp, sp, #28
    8b5c:	e50b0010 	str	r0, [fp, #-16]
    8b60:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8b64:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    8b68:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b6c:	e2432001 	sub	r2, r3, #1
    8b70:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8b74:	e3530000 	cmp	r3, #0
    8b78:	c3a03001 	movgt	r3, #1
    8b7c:	d3a03000 	movle	r3, #0
    8b80:	e6ef3073 	uxtb	r3, r3
    8b84:	e3530000 	cmp	r3, #0
    8b88:	0a000016 	beq	8be8 <_Z7strncmpPKcS0_i+0x98>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    8b8c:	e51b3010 	ldr	r3, [fp, #-16]
    8b90:	e2832001 	add	r2, r3, #1
    8b94:	e50b2010 	str	r2, [fp, #-16]
    8b98:	e5d33000 	ldrb	r3, [r3]
    8b9c:	e54b3005 	strb	r3, [fp, #-5]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    8ba0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8ba4:	e2832001 	add	r2, r3, #1
    8ba8:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8bac:	e5d33000 	ldrb	r3, [r3]
    8bb0:	e54b3006 	strb	r3, [fp, #-6]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    8bb4:	e55b2005 	ldrb	r2, [fp, #-5]
    8bb8:	e55b3006 	ldrb	r3, [fp, #-6]
    8bbc:	e1520003 	cmp	r2, r3
    8bc0:	0a000003 	beq	8bd4 <_Z7strncmpPKcS0_i+0x84>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    8bc4:	e55b2005 	ldrb	r2, [fp, #-5]
    8bc8:	e55b3006 	ldrb	r3, [fp, #-6]
    8bcc:	e0423003 	sub	r3, r2, r3
    8bd0:	ea000005 	b	8bec <_Z7strncmpPKcS0_i+0x9c>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    8bd4:	e55b3005 	ldrb	r3, [fp, #-5]
    8bd8:	e3530000 	cmp	r3, #0
    8bdc:	1affffe1 	bne	8b68 <_Z7strncmpPKcS0_i+0x18>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:76
        	return 0;
    8be0:	e3a03000 	mov	r3, #0
    8be4:	ea000000 	b	8bec <_Z7strncmpPKcS0_i+0x9c>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8be8:	e3a03000 	mov	r3, #0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:80
}
    8bec:	e1a00003 	mov	r0, r3
    8bf0:	e28bd000 	add	sp, fp, #0
    8bf4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8bf8:	e12fff1e 	bx	lr

00008bfc <_Z6strlenPKc>:
_Z6strlenPKc():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8bfc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c00:	e28db000 	add	fp, sp, #0
    8c04:	e24dd014 	sub	sp, sp, #20
    8c08:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:84
	int i = 0;
    8c0c:	e3a03000 	mov	r3, #0
    8c10:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8c14:	e51b3008 	ldr	r3, [fp, #-8]
    8c18:	e51b2010 	ldr	r2, [fp, #-16]
    8c1c:	e0823003 	add	r3, r2, r3
    8c20:	e5d33000 	ldrb	r3, [r3]
    8c24:	e3530000 	cmp	r3, #0
    8c28:	0a000003 	beq	8c3c <_Z6strlenPKc+0x40>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:87
		i++;
    8c2c:	e51b3008 	ldr	r3, [fp, #-8]
    8c30:	e2833001 	add	r3, r3, #1
    8c34:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8c38:	eafffff5 	b	8c14 <_Z6strlenPKc+0x18>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:89

	return i;
    8c3c:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:90
}
    8c40:	e1a00003 	mov	r0, r3
    8c44:	e28bd000 	add	sp, fp, #0
    8c48:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c4c:	e12fff1e 	bx	lr

00008c50 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8c50:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c54:	e28db000 	add	fp, sp, #0
    8c58:	e24dd014 	sub	sp, sp, #20
    8c5c:	e50b0010 	str	r0, [fp, #-16]
    8c60:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8c64:	e51b3010 	ldr	r3, [fp, #-16]
    8c68:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8c6c:	e3a03000 	mov	r3, #0
    8c70:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8c74:	e51b2008 	ldr	r2, [fp, #-8]
    8c78:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8c7c:	e1520003 	cmp	r2, r3
    8c80:	aa000008 	bge	8ca8 <_Z5bzeroPvi+0x58>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8c84:	e51b3008 	ldr	r3, [fp, #-8]
    8c88:	e51b200c 	ldr	r2, [fp, #-12]
    8c8c:	e0823003 	add	r3, r2, r3
    8c90:	e3a02000 	mov	r2, #0
    8c94:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8c98:	e51b3008 	ldr	r3, [fp, #-8]
    8c9c:	e2833001 	add	r3, r3, #1
    8ca0:	e50b3008 	str	r3, [fp, #-8]
    8ca4:	eafffff2 	b	8c74 <_Z5bzeroPvi+0x24>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:98
}
    8ca8:	e320f000 	nop	{0}
    8cac:	e28bd000 	add	sp, fp, #0
    8cb0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8cb4:	e12fff1e 	bx	lr

00008cb8 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8cb8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8cbc:	e28db000 	add	fp, sp, #0
    8cc0:	e24dd024 	sub	sp, sp, #36	; 0x24
    8cc4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8cc8:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8ccc:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8cd0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8cd4:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8cd8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8cdc:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8ce0:	e3a03000 	mov	r3, #0
    8ce4:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8ce8:	e51b2008 	ldr	r2, [fp, #-8]
    8cec:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8cf0:	e1520003 	cmp	r2, r3
    8cf4:	aa00000b 	bge	8d28 <_Z6memcpyPKvPvi+0x70>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8cf8:	e51b3008 	ldr	r3, [fp, #-8]
    8cfc:	e51b200c 	ldr	r2, [fp, #-12]
    8d00:	e0822003 	add	r2, r2, r3
    8d04:	e51b3008 	ldr	r3, [fp, #-8]
    8d08:	e51b1010 	ldr	r1, [fp, #-16]
    8d0c:	e0813003 	add	r3, r1, r3
    8d10:	e5d22000 	ldrb	r2, [r2]
    8d14:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8d18:	e51b3008 	ldr	r3, [fp, #-8]
    8d1c:	e2833001 	add	r3, r3, #1
    8d20:	e50b3008 	str	r3, [fp, #-8]
    8d24:	eaffffef 	b	8ce8 <_Z6memcpyPKvPvi+0x30>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:107
}
    8d28:	e320f000 	nop	{0}
    8d2c:	e28bd000 	add	sp, fp, #0
    8d30:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d34:	e12fff1e 	bx	lr

00008d38 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1150
    8d38:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1152
    8d3c:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1153
    8d40:	3a000074 	bcc	8f18 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1154
    8d44:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1155
    8d48:	9a00006b 	bls	8efc <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    8d4c:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    8d50:	0a00006c 	beq	8f08 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    8d54:	e16f3f10 	clz	r3, r0
    8d58:	e16f2f11 	clz	r2, r1
    8d5c:	e0423003 	sub	r3, r2, r3
    8d60:	e273301f 	rsbs	r3, r3, #31
    8d64:	10833083 	addne	r3, r3, r3, lsl #1
    8d68:	e3a02000 	mov	r2, #0
    8d6c:	108ff103 	addne	pc, pc, r3, lsl #2
    8d70:	e1a00000 	nop			; (mov r0, r0)
    8d74:	e1500f81 	cmp	r0, r1, lsl #31
    8d78:	e0a22002 	adc	r2, r2, r2
    8d7c:	20400f81 	subcs	r0, r0, r1, lsl #31
    8d80:	e1500f01 	cmp	r0, r1, lsl #30
    8d84:	e0a22002 	adc	r2, r2, r2
    8d88:	20400f01 	subcs	r0, r0, r1, lsl #30
    8d8c:	e1500e81 	cmp	r0, r1, lsl #29
    8d90:	e0a22002 	adc	r2, r2, r2
    8d94:	20400e81 	subcs	r0, r0, r1, lsl #29
    8d98:	e1500e01 	cmp	r0, r1, lsl #28
    8d9c:	e0a22002 	adc	r2, r2, r2
    8da0:	20400e01 	subcs	r0, r0, r1, lsl #28
    8da4:	e1500d81 	cmp	r0, r1, lsl #27
    8da8:	e0a22002 	adc	r2, r2, r2
    8dac:	20400d81 	subcs	r0, r0, r1, lsl #27
    8db0:	e1500d01 	cmp	r0, r1, lsl #26
    8db4:	e0a22002 	adc	r2, r2, r2
    8db8:	20400d01 	subcs	r0, r0, r1, lsl #26
    8dbc:	e1500c81 	cmp	r0, r1, lsl #25
    8dc0:	e0a22002 	adc	r2, r2, r2
    8dc4:	20400c81 	subcs	r0, r0, r1, lsl #25
    8dc8:	e1500c01 	cmp	r0, r1, lsl #24
    8dcc:	e0a22002 	adc	r2, r2, r2
    8dd0:	20400c01 	subcs	r0, r0, r1, lsl #24
    8dd4:	e1500b81 	cmp	r0, r1, lsl #23
    8dd8:	e0a22002 	adc	r2, r2, r2
    8ddc:	20400b81 	subcs	r0, r0, r1, lsl #23
    8de0:	e1500b01 	cmp	r0, r1, lsl #22
    8de4:	e0a22002 	adc	r2, r2, r2
    8de8:	20400b01 	subcs	r0, r0, r1, lsl #22
    8dec:	e1500a81 	cmp	r0, r1, lsl #21
    8df0:	e0a22002 	adc	r2, r2, r2
    8df4:	20400a81 	subcs	r0, r0, r1, lsl #21
    8df8:	e1500a01 	cmp	r0, r1, lsl #20
    8dfc:	e0a22002 	adc	r2, r2, r2
    8e00:	20400a01 	subcs	r0, r0, r1, lsl #20
    8e04:	e1500981 	cmp	r0, r1, lsl #19
    8e08:	e0a22002 	adc	r2, r2, r2
    8e0c:	20400981 	subcs	r0, r0, r1, lsl #19
    8e10:	e1500901 	cmp	r0, r1, lsl #18
    8e14:	e0a22002 	adc	r2, r2, r2
    8e18:	20400901 	subcs	r0, r0, r1, lsl #18
    8e1c:	e1500881 	cmp	r0, r1, lsl #17
    8e20:	e0a22002 	adc	r2, r2, r2
    8e24:	20400881 	subcs	r0, r0, r1, lsl #17
    8e28:	e1500801 	cmp	r0, r1, lsl #16
    8e2c:	e0a22002 	adc	r2, r2, r2
    8e30:	20400801 	subcs	r0, r0, r1, lsl #16
    8e34:	e1500781 	cmp	r0, r1, lsl #15
    8e38:	e0a22002 	adc	r2, r2, r2
    8e3c:	20400781 	subcs	r0, r0, r1, lsl #15
    8e40:	e1500701 	cmp	r0, r1, lsl #14
    8e44:	e0a22002 	adc	r2, r2, r2
    8e48:	20400701 	subcs	r0, r0, r1, lsl #14
    8e4c:	e1500681 	cmp	r0, r1, lsl #13
    8e50:	e0a22002 	adc	r2, r2, r2
    8e54:	20400681 	subcs	r0, r0, r1, lsl #13
    8e58:	e1500601 	cmp	r0, r1, lsl #12
    8e5c:	e0a22002 	adc	r2, r2, r2
    8e60:	20400601 	subcs	r0, r0, r1, lsl #12
    8e64:	e1500581 	cmp	r0, r1, lsl #11
    8e68:	e0a22002 	adc	r2, r2, r2
    8e6c:	20400581 	subcs	r0, r0, r1, lsl #11
    8e70:	e1500501 	cmp	r0, r1, lsl #10
    8e74:	e0a22002 	adc	r2, r2, r2
    8e78:	20400501 	subcs	r0, r0, r1, lsl #10
    8e7c:	e1500481 	cmp	r0, r1, lsl #9
    8e80:	e0a22002 	adc	r2, r2, r2
    8e84:	20400481 	subcs	r0, r0, r1, lsl #9
    8e88:	e1500401 	cmp	r0, r1, lsl #8
    8e8c:	e0a22002 	adc	r2, r2, r2
    8e90:	20400401 	subcs	r0, r0, r1, lsl #8
    8e94:	e1500381 	cmp	r0, r1, lsl #7
    8e98:	e0a22002 	adc	r2, r2, r2
    8e9c:	20400381 	subcs	r0, r0, r1, lsl #7
    8ea0:	e1500301 	cmp	r0, r1, lsl #6
    8ea4:	e0a22002 	adc	r2, r2, r2
    8ea8:	20400301 	subcs	r0, r0, r1, lsl #6
    8eac:	e1500281 	cmp	r0, r1, lsl #5
    8eb0:	e0a22002 	adc	r2, r2, r2
    8eb4:	20400281 	subcs	r0, r0, r1, lsl #5
    8eb8:	e1500201 	cmp	r0, r1, lsl #4
    8ebc:	e0a22002 	adc	r2, r2, r2
    8ec0:	20400201 	subcs	r0, r0, r1, lsl #4
    8ec4:	e1500181 	cmp	r0, r1, lsl #3
    8ec8:	e0a22002 	adc	r2, r2, r2
    8ecc:	20400181 	subcs	r0, r0, r1, lsl #3
    8ed0:	e1500101 	cmp	r0, r1, lsl #2
    8ed4:	e0a22002 	adc	r2, r2, r2
    8ed8:	20400101 	subcs	r0, r0, r1, lsl #2
    8edc:	e1500081 	cmp	r0, r1, lsl #1
    8ee0:	e0a22002 	adc	r2, r2, r2
    8ee4:	20400081 	subcs	r0, r0, r1, lsl #1
    8ee8:	e1500001 	cmp	r0, r1
    8eec:	e0a22002 	adc	r2, r2, r2
    8ef0:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    8ef4:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    8ef8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    8efc:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    8f00:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    8f04:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1169
    8f08:	e16f2f11 	clz	r2, r1
    8f0c:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1171
    8f10:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1172
    8f14:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1176
    8f18:	e3500000 	cmp	r0, #0
    8f1c:	13e00000 	mvnne	r0, #0
    8f20:	ea000007 	b	8f44 <__aeabi_idiv0>

00008f24 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1207
    8f24:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1208
    8f28:	0afffffa 	beq	8f18 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1209
    8f2c:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1210
    8f30:	ebffff80 	bl	8d38 <__udivsi3>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1211
    8f34:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1212
    8f38:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1213
    8f3c:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1214
    8f40:	e12fff1e 	bx	lr

00008f44 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1512
    8f44:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00008f48 <_ZL13Lock_Unlocked>:
    8f48:	00000000 	andeq	r0, r0, r0

00008f4c <_ZL11Lock_Locked>:
    8f4c:	00000001 	andeq	r0, r0, r1

00008f50 <_ZL21MaxFSDriverNameLength>:
    8f50:	00000010 	andeq	r0, r0, r0, lsl r0

00008f54 <_ZL17MaxFilenameLength>:
    8f54:	00000010 	andeq	r0, r0, r0, lsl r0

00008f58 <_ZL13MaxPathLength>:
    8f58:	00000080 	andeq	r0, r0, r0, lsl #1

00008f5c <_ZL18NoFilesystemDriver>:
    8f5c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f60 <_ZL9NotifyAll>:
    8f60:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f64 <_ZL24Max_Process_Opened_Files>:
    8f64:	00000010 	andeq	r0, r0, r0, lsl r0

00008f68 <_ZL10Indefinite>:
    8f68:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f6c <_ZL18Deadline_Unchanged>:
    8f6c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008f70 <_ZL14Invalid_Handle>:
    8f70:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f74 <_ZN3halL18Default_Clock_RateE>:
    8f74:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00008f78 <_ZN3halL15Peripheral_BaseE>:
    8f78:	20000000 	andcs	r0, r0, r0

00008f7c <_ZN3halL9GPIO_BaseE>:
    8f7c:	20200000 	eorcs	r0, r0, r0

00008f80 <_ZN3halL14GPIO_Pin_CountE>:
    8f80:	00000036 	andeq	r0, r0, r6, lsr r0

00008f84 <_ZN3halL8AUX_BaseE>:
    8f84:	20215000 	eorcs	r5, r1, r0

00008f88 <_ZN3halL25Interrupt_Controller_BaseE>:
    8f88:	2000b200 	andcs	fp, r0, r0, lsl #4

00008f8c <_ZN3halL10Timer_BaseE>:
    8f8c:	2000b400 	andcs	fp, r0, r0, lsl #8

00008f90 <_ZN3halL9TRNG_BaseE>:
    8f90:	20104000 	andscs	r4, r0, r0

00008f94 <_ZN3halL9BSC0_BaseE>:
    8f94:	20205000 	eorcs	r5, r0, r0

00008f98 <_ZN3halL9BSC1_BaseE>:
    8f98:	20804000 	addcs	r4, r0, r0

00008f9c <_ZN3halL9BSC2_BaseE>:
    8f9c:	20805000 	addcs	r5, r0, r0

00008fa0 <_ZL11Invalid_Pin>:
    8fa0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008fa4 <_ZL17symbol_tick_delay>:
    8fa4:	00000400 	andeq	r0, r0, r0, lsl #8

00008fa8 <_ZL15char_tick_delay>:
    8fa8:	00001000 	andeq	r1, r0, r0
    8fac:	00000031 	andeq	r0, r0, r1, lsr r0
    8fb0:	00000030 	andeq	r0, r0, r0, lsr r0
    8fb4:	3a564544 	bcc	159a4cc <__bss_end+0x1591490>
    8fb8:	6f697067 	svcvs	0x00697067
    8fbc:	0038312f 	eorseq	r3, r8, pc, lsr #2
    8fc0:	3a564544 	bcc	159a4d8 <__bss_end+0x159149c>
    8fc4:	6f697067 	svcvs	0x00697067
    8fc8:	0036312f 	eorseq	r3, r6, pc, lsr #2
    8fcc:	00676f6c 	rsbeq	r6, r7, ip, ror #30
    8fd0:	21534f53 	cmpcs	r3, r3, asr pc
    8fd4:	00000000 	andeq	r0, r0, r0

00008fd8 <_ZL13Lock_Unlocked>:
    8fd8:	00000000 	andeq	r0, r0, r0

00008fdc <_ZL11Lock_Locked>:
    8fdc:	00000001 	andeq	r0, r0, r1

00008fe0 <_ZL21MaxFSDriverNameLength>:
    8fe0:	00000010 	andeq	r0, r0, r0, lsl r0

00008fe4 <_ZL17MaxFilenameLength>:
    8fe4:	00000010 	andeq	r0, r0, r0, lsl r0

00008fe8 <_ZL13MaxPathLength>:
    8fe8:	00000080 	andeq	r0, r0, r0, lsl #1

00008fec <_ZL18NoFilesystemDriver>:
    8fec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ff0 <_ZL9NotifyAll>:
    8ff0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ff4 <_ZL24Max_Process_Opened_Files>:
    8ff4:	00000010 	andeq	r0, r0, r0, lsl r0

00008ff8 <_ZL10Indefinite>:
    8ff8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ffc <_ZL18Deadline_Unchanged>:
    8ffc:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009000 <_ZL14Invalid_Handle>:
    9000:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009004 <_ZL16Pipe_File_Prefix>:
    9004:	3a535953 	bcc	14df558 <__bss_end+0x14d651c>
    9008:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    900c:	0000002f 	andeq	r0, r0, pc, lsr #32

00009010 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9010:	33323130 	teqcc	r2, #48, 2
    9014:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9018:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    901c:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00009024 <sos_led>:
__bss_start():
    9024:	00000000 	andeq	r0, r0, r0

00009028 <button>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x16847f0>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x393e8>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3cffc>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c7ce8>
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
 130:	6b69746e 	blvs	1a5d2f0 <__bss_end+0x1a542b4>
 134:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
 138:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 13c:	4f54522d 	svcmi	0x0054522d
 140:	616d2d53 	cmnvs	sp, r3, asr sp
 144:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 148:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe21 <__bss_end+0xffff6de5>
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
 180:	0a030000 	beq	c0188 <__bss_end+0xb714c>
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
 1d4:	6a0d05a1 	bvs	341860 <__bss_end+0x338824>
 1d8:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
 1dc:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 1e0:	04020004 	streq	r0, [r2], #-4
 1e4:	0b058302 	bleq	160df4 <__bss_end+0x157db8>
 1e8:	02040200 	andeq	r0, r4, #0, 4
 1ec:	0002054a 	andeq	r0, r2, sl, asr #10
 1f0:	2d020402 	cfstrscs	mvf0, [r2, #-8]
 1f4:	05850905 	streq	r0, [r5, #2309]	; 0x905
 1f8:	0a022f01 	beq	8be04 <__bss_end+0x82dc8>
 1fc:	c2010100 	andgt	r0, r1, #0, 2
 200:	03000002 	movweq	r0, #2
 204:	00020100 	andeq	r0, r2, r0, lsl #2
 208:	fb010200 	blx	40a12 <__bss_end+0x379d6>
 20c:	01000d0e 	tsteq	r0, lr, lsl #26
 210:	00010101 	andeq	r0, r1, r1, lsl #2
 214:	00010000 	andeq	r0, r1, r0
 218:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 21c:	2f656d6f 	svccs	0x00656d6f
 220:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
 224:	642f6b69 	strtvs	r6, [pc], #-2921	; 22c <shift+0x22c>
 228:	4b2f7665 	blmi	bddbc4 <__bss_end+0xbd4b88>
 22c:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 230:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
 234:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
 238:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
 23c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 240:	752f7365 	strvc	r7, [pc, #-869]!	; fffffee3 <__bss_end+0xffff6ea7>
 244:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 248:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 24c:	736f732f 	cmnvc	pc, #-1140850688	; 0xbc000000
 250:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
 254:	682f006b 	stmdavs	pc!, {r0, r1, r3, r5, r6}	; <UNPREDICTABLE>
 258:	2f656d6f 	svccs	0x00656d6f
 25c:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
 260:	642f6b69 	strtvs	r6, [pc], #-2921	; 268 <shift+0x268>
 264:	4b2f7665 	blmi	bddc00 <__bss_end+0xbd4bc4>
 268:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 26c:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
 270:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
 274:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
 278:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 27c:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff1f <__bss_end+0xffff6ee3>
 280:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 284:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 288:	2f2e2e2f 	svccs	0x002e2e2f
 28c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 290:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 294:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 298:	702f6564 	eorvc	r6, pc, r4, ror #10
 29c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 2a0:	2f007373 	svccs	0x00007373
 2a4:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 2a8:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 2ac:	2f6b6974 	svccs	0x006b6974
 2b0:	2f766564 	svccs	0x00766564
 2b4:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 2b8:	534f5452 	movtpl	r5, #62546	; 0xf452
 2bc:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 2c0:	2f726574 	svccs	0x00726574
 2c4:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 2c8:	2f736563 	svccs	0x00736563
 2cc:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 2d0:	63617073 	cmnvs	r1, #115	; 0x73
 2d4:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 2d8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 2dc:	2f6c656e 	svccs	0x006c656e
 2e0:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 2e4:	2f656475 	svccs	0x00656475
 2e8:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 2ec:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 2f0:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 2f4:	2f006c61 	svccs	0x00006c61
 2f8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 2fc:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 300:	2f6b6974 	svccs	0x006b6974
 304:	2f766564 	svccs	0x00766564
 308:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 30c:	534f5452 	movtpl	r5, #62546	; 0xf452
 310:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 314:	2f726574 	svccs	0x00726574
 318:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 31c:	2f736563 	svccs	0x00736563
 320:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 324:	63617073 	cmnvs	r1, #115	; 0x73
 328:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 32c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 330:	2f6c656e 	svccs	0x006c656e
 334:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 338:	2f656475 	svccs	0x00656475
 33c:	2f007366 	svccs	0x00007366
 340:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 344:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 348:	2f6b6974 	svccs	0x006b6974
 34c:	2f766564 	svccs	0x00766564
 350:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 354:	534f5452 	movtpl	r5, #62546	; 0xf452
 358:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 35c:	2f726574 	svccs	0x00726574
 360:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 364:	2f736563 	svccs	0x00736563
 368:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 36c:	63617073 	cmnvs	r1, #115	; 0x73
 370:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 374:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 378:	2f6c656e 	svccs	0x006c656e
 37c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 380:	2f656475 	svccs	0x00656475
 384:	76697264 	strbtvc	r7, [r9], -r4, ror #4
 388:	00737265 	rsbseq	r7, r3, r5, ror #4
 38c:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
 390:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 394:	00010070 	andeq	r0, r1, r0, ror r0
 398:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 39c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 3a0:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 3a4:	66656474 			; <UNDEFINED> instruction: 0x66656474
 3a8:	0300682e 	movweq	r6, #2094	; 0x82e
 3ac:	70730000 	rsbsvc	r0, r3, r0
 3b0:	6f6c6e69 	svcvs	0x006c6e69
 3b4:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 3b8:	00000200 	andeq	r0, r0, r0, lsl #4
 3bc:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 3c0:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 3c4:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 3c8:	00000400 	andeq	r0, r0, r0, lsl #8
 3cc:	636f7270 	cmnvs	pc, #112, 4
 3d0:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 3d4:	00020068 	andeq	r0, r2, r8, rrx
 3d8:	6f727000 	svcvs	0x00727000
 3dc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 3e0:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 3e4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 3e8:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 3ec:	65700000 	ldrbvs	r0, [r0, #-0]!
 3f0:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
 3f4:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
 3f8:	00682e73 	rsbeq	r2, r8, r3, ror lr
 3fc:	67000003 	strvs	r0, [r0, -r3]
 400:	2e6f6970 			; <UNDEFINED> instruction: 0x2e6f6970
 404:	00050068 	andeq	r0, r5, r8, rrx
 408:	01050000 	mrseq	r0, (UNDEF: 5)
 40c:	34020500 	strcc	r0, [r2], #-1280	; 0xfffffb00
 410:	03000082 	movweq	r0, #130	; 0x82
 414:	07050116 	smladeq	r5, r6, r1, r0
 418:	0200bb9f 	andeq	fp, r0, #162816	; 0x27c00
 41c:	66060104 	strvs	r0, [r6], -r4, lsl #2
 420:	02040200 	andeq	r0, r4, #0, 4
 424:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
 428:	02002e04 	andeq	r2, r0, #4, 28	; 0x40
 42c:	67060404 	strvs	r0, [r6, -r4, lsl #8]
 430:	02000105 	andeq	r0, r0, #1073741825	; 0x40000001
 434:	bdbb0404 	cfldrslt	mvf0, [fp, #16]!
 438:	059f1005 	ldreq	r1, [pc, #5]	; 445 <shift+0x445>
 43c:	0f05820a 	svceq	0x0005820a
 440:	8209054b 	andhi	r0, r9, #314572800	; 0x12c00000
 444:	054c1705 	strbeq	r1, [ip, #-1797]	; 0xfffff8fb
 448:	19054b07 	stmdbne	r5, {r0, r1, r2, r8, r9, fp, lr}
 44c:	000705bc 			; <UNDEFINED> instruction: 0x000705bc
 450:	87010402 	strhi	r0, [r1, -r2, lsl #8]
 454:	02000805 	andeq	r0, r0, #327680	; 0x50000
 458:	09030104 	stmdbeq	r3, {r2, r8}
 45c:	040200ba 	streq	r0, [r2], #-186	; 0xffffff46
 460:	02008401 	andeq	r8, r0, #16777216	; 0x1000000
 464:	004b0104 	subeq	r0, fp, r4, lsl #2
 468:	67010402 	strvs	r0, [r1, -r2, lsl #8]
 46c:	01040200 	mrseq	r0, R12_usr
 470:	0402004b 	streq	r0, [r2], #-75	; 0xffffffb5
 474:	02006701 	andeq	r6, r0, #262144	; 0x40000
 478:	004c0104 	subeq	r0, ip, r4, lsl #2
 47c:	68010402 	stmdavs	r1, {r1, sl}
 480:	01040200 	mrseq	r0, R12_usr
 484:	0402004b 	streq	r0, [r2], #-75	; 0xffffffb5
 488:	02006701 	andeq	r6, r0, #262144	; 0x40000
 48c:	004b0104 	subeq	r0, fp, r4, lsl #2
 490:	67010402 	strvs	r0, [r1, -r2, lsl #8]
 494:	01040200 	mrseq	r0, R12_usr
 498:	0402004b 	streq	r0, [r2], #-75	; 0xffffffb5
 49c:	02006801 	andeq	r6, r0, #65536	; 0x10000
 4a0:	00680104 	rsbeq	r0, r8, r4, lsl #2
 4a4:	4b010402 	blmi	414b4 <__bss_end+0x38478>
 4a8:	01040200 	mrseq	r0, R12_usr
 4ac:	04020067 	streq	r0, [r2], #-103	; 0xffffff99
 4b0:	02004b01 	andeq	r4, r0, #1024	; 0x400
 4b4:	05670104 	strbeq	r0, [r7, #-260]!	; 0xfffffefc
 4b8:	04020007 	streq	r0, [r2], #-7
 4bc:	4a600301 	bmi	18010c8 <__bss_end+0x17f808c>
 4c0:	01000e02 	tsteq	r0, r2, lsl #28
 4c4:	0002a301 	andeq	sl, r2, r1, lsl #6
 4c8:	6d000300 	stcvs	3, cr0, [r0, #-0]
 4cc:	02000001 	andeq	r0, r0, #1
 4d0:	0d0efb01 	vstreq	d15, [lr, #-4]
 4d4:	01010100 	mrseq	r0, (UNDEF: 17)
 4d8:	00000001 	andeq	r0, r0, r1
 4dc:	01000001 	tsteq	r0, r1
 4e0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 42c <shift+0x42c>
 4e4:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 4e8:	6b69746e 	blvs	1a5d6a8 <__bss_end+0x1a5466c>
 4ec:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
 4f0:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 4f4:	4f54522d 	svcmi	0x0054522d
 4f8:	616d2d53 	cmnvs	sp, r3, asr sp
 4fc:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 500:	756f732f 	strbvc	r7, [pc, #-815]!	; 1d9 <shift+0x1d9>
 504:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 508:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 50c:	2f62696c 	svccs	0x0062696c
 510:	00637273 	rsbeq	r7, r3, r3, ror r2
 514:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 460 <shift+0x460>
 518:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 51c:	6b69746e 	blvs	1a5d6dc <__bss_end+0x1a546a0>
 520:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
 524:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 528:	4f54522d 	svcmi	0x0054522d
 52c:	616d2d53 	cmnvs	sp, r3, asr sp
 530:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 534:	756f732f 	strbvc	r7, [pc, #-815]!	; 20d <shift+0x20d>
 538:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 53c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 540:	2f6c656e 	svccs	0x006c656e
 544:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 548:	2f656475 	svccs	0x00656475
 54c:	636f7270 	cmnvs	pc, #112, 4
 550:	00737365 	rsbseq	r7, r3, r5, ror #6
 554:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 4a0 <shift+0x4a0>
 558:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 55c:	6b69746e 	blvs	1a5d71c <__bss_end+0x1a546e0>
 560:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
 564:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 568:	4f54522d 	svcmi	0x0054522d
 56c:	616d2d53 	cmnvs	sp, r3, asr sp
 570:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 574:	756f732f 	strbvc	r7, [pc, #-815]!	; 24d <shift+0x24d>
 578:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 57c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 580:	2f6c656e 	svccs	0x006c656e
 584:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 588:	2f656475 	svccs	0x00656475
 58c:	2f007366 	svccs	0x00007366
 590:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 594:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 598:	2f6b6974 	svccs	0x006b6974
 59c:	2f766564 	svccs	0x00766564
 5a0:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 5a4:	534f5452 	movtpl	r5, #62546	; 0xf452
 5a8:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 5ac:	2f726574 	svccs	0x00726574
 5b0:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 5b4:	2f736563 	svccs	0x00736563
 5b8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 5bc:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 5c0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 5c4:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 5c8:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 5cc:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 5d0:	61682f30 	cmnvs	r8, r0, lsr pc
 5d4:	7300006c 	movwvc	r0, #108	; 0x6c
 5d8:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
 5dc:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
 5e0:	01007070 	tsteq	r0, r0, ror r0
 5e4:	77730000 	ldrbvc	r0, [r3, -r0]!
 5e8:	00682e69 	rsbeq	r2, r8, r9, ror #28
 5ec:	73000002 	movwvc	r0, #2
 5f0:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
 5f4:	2e6b636f 	cdpcs	3, 6, cr6, cr11, cr15, {3}
 5f8:	00020068 	andeq	r0, r2, r8, rrx
 5fc:	6c696600 	stclvs	6, cr6, [r9], #-0
 600:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
 604:	2e6d6574 	mcrcs	5, 3, r6, cr13, cr4, {3}
 608:	00030068 	andeq	r0, r3, r8, rrx
 60c:	6f727000 	svcvs	0x00727000
 610:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 614:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 618:	72700000 	rsbsvc	r0, r0, #0
 61c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 620:	616d5f73 	smcvs	54771	; 0xd5f3
 624:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
 628:	00682e72 	rsbeq	r2, r8, r2, ror lr
 62c:	69000002 	stmdbvs	r0, {r1}
 630:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
 634:	00682e66 	rsbeq	r2, r8, r6, ror #28
 638:	00000004 	andeq	r0, r0, r4
 63c:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 640:	00842002 	addeq	r2, r4, r2
 644:	1a051600 	bne	145e4c <__bss_end+0x13ce10>
 648:	2f2c0569 	svccs	0x002c0569
 64c:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 650:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 654:	1a058332 	bne	161324 <__bss_end+0x1582e8>
 658:	2f01054b 	svccs	0x0001054b
 65c:	4b1a0585 	blmi	681c78 <__bss_end+0x678c3c>
 660:	852f0105 	strhi	r0, [pc, #-261]!	; 563 <shift+0x563>
 664:	05a13205 	streq	r3, [r1, #517]!	; 0x205
 668:	1b054b2e 	blne	153328 <__bss_end+0x14a2ec>
 66c:	2f2d054b 	svccs	0x002d054b
 670:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 674:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 678:	3005bd2e 	andcc	fp, r5, lr, lsr #26
 67c:	4b2e054b 	blmi	b81bb0 <__bss_end+0xb78b74>
 680:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 684:	0c052f2e 	stceq	15, cr2, [r5], {46}	; 0x2e
 688:	2f01054c 	svccs	0x0001054c
 68c:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 690:	054b3005 	strbeq	r3, [fp, #-5]
 694:	1b054b2e 	blne	153354 <__bss_end+0x14a318>
 698:	2f2e054b 	svccs	0x002e054b
 69c:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 6a0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6a4:	1b05832e 	blne	161364 <__bss_end+0x158328>
 6a8:	2f01054b 	svccs	0x0001054b
 6ac:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 6b0:	054b3305 	strbeq	r3, [fp, #-773]	; 0xfffffcfb
 6b4:	1b054b2f 	blne	153378 <__bss_end+0x14a33c>
 6b8:	2f30054b 	svccs	0x0030054b
 6bc:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 6c0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6c4:	2f05a12e 	svccs	0x0005a12e
 6c8:	4b1b054b 	blmi	6c1bfc <__bss_end+0x6b8bc0>
 6cc:	052f2f05 	streq	r2, [pc, #-3845]!	; fffff7cf <__bss_end+0xffff6793>
 6d0:	01054c0c 	tsteq	r5, ip, lsl #24
 6d4:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 6d8:	4b2f05bd 	blmi	bc1dd4 <__bss_end+0xbb8d98>
 6dc:	054b3b05 	strbeq	r3, [fp, #-2821]	; 0xfffff4fb
 6e0:	30054b1b 	andcc	r4, r5, fp, lsl fp
 6e4:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 6e8:	852f0105 	strhi	r0, [pc, #-261]!	; 5eb <shift+0x5eb>
 6ec:	05a12f05 	streq	r2, [r1, #3845]!	; 0xf05
 6f0:	1a054b3b 	bne	1533e4 <__bss_end+0x14a3a8>
 6f4:	2f30054b 	svccs	0x0030054b
 6f8:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 6fc:	05859f01 	streq	r9, [r5, #3841]	; 0xf01
 700:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
 704:	4b31054d 	blmi	c41c40 <__bss_end+0xc38c04>
 708:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 70c:	0105300c 	tsteq	r5, ip
 710:	2005852f 	andcs	r8, r5, pc, lsr #10
 714:	4d2d0567 	cfstr32mi	mvfx0, [sp, #-412]!	; 0xfffffe64
 718:	054b3105 	strbeq	r3, [fp, #-261]	; 0xfffffefb
 71c:	0c054b1a 			; <UNDEFINED> instruction: 0x0c054b1a
 720:	2f010530 	svccs	0x00010530
 724:	83200585 			; <UNDEFINED> instruction: 0x83200585
 728:	054c2d05 	strbeq	r2, [ip, #-3333]	; 0xfffff2fb
 72c:	1a054b3e 	bne	15342c <__bss_end+0x14a3f0>
 730:	2f01054b 	svccs	0x0001054b
 734:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 738:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
 73c:	1a054b30 	bne	153404 <__bss_end+0x14a3c8>
 740:	300c054b 	andcc	r0, ip, fp, asr #10
 744:	872f0105 	strhi	r0, [pc, -r5, lsl #2]!
 748:	9fa00c05 	svcls	0x00a00c05
 74c:	05bc3105 	ldreq	r3, [ip, #261]!	; 0x105
 750:	36056629 	strcc	r6, [r5], -r9, lsr #12
 754:	300f052e 	andcc	r0, pc, lr, lsr #10
 758:	05661305 	strbeq	r1, [r6, #-773]!	; 0xfffffcfb
 75c:	10058409 	andne	r8, r5, r9, lsl #8
 760:	9e3305d8 	mrcls	5, 1, r0, cr3, cr8, {6}
 764:	022f0105 	eoreq	r0, pc, #1073741825	; 0x40000001
 768:	01010008 	tsteq	r1, r8
 76c:	00000232 	andeq	r0, r0, r2, lsr r2
 770:	00580003 	subseq	r0, r8, r3
 774:	01020000 	mrseq	r0, (UNDEF: 2)
 778:	000d0efb 	strdeq	r0, [sp], -fp
 77c:	01010101 	tsteq	r1, r1, lsl #2
 780:	01000000 	mrseq	r0, (UNDEF: 0)
 784:	2f010000 	svccs	0x00010000
 788:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 78c:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 790:	2f6b6974 	svccs	0x006b6974
 794:	2f766564 	svccs	0x00766564
 798:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 79c:	534f5452 	movtpl	r5, #62546	; 0xf452
 7a0:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 7a4:	2f726574 	svccs	0x00726574
 7a8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 7ac:	2f736563 	svccs	0x00736563
 7b0:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
 7b4:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
 7b8:	00006372 	andeq	r6, r0, r2, ror r3
 7bc:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
 7c0:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
 7c4:	70632e67 	rsbvc	r2, r3, r7, ror #28
 7c8:	00010070 	andeq	r0, r1, r0, ror r0
 7cc:	01050000 	mrseq	r0, (UNDEF: 5)
 7d0:	80020500 	andhi	r0, r2, r0, lsl #10
 7d4:	1a000088 	bne	9fc <shift+0x9fc>
 7d8:	05bb0605 	ldreq	r0, [fp, #1541]!	; 0x605
 7dc:	21054c0f 	tstcs	r5, pc, lsl #24
 7e0:	ba0b0568 	blt	2c1d88 <__bss_end+0x2b8d4c>
 7e4:	05662705 	strbeq	r2, [r6, #-1797]!	; 0xfffff8fb
 7e8:	09054a0d 	stmdbeq	r5, {r0, r2, r3, r9, fp, lr}
 7ec:	9f04052f 	svcls	0x0004052f
 7f0:	05620205 	strbeq	r0, [r2, #-517]!	; 0xfffffdfb
 7f4:	11053505 	tstne	r5, r5, lsl #10
 7f8:	66220568 	strtvs	r0, [r2], -r8, ror #10
 7fc:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
 800:	05692f0a 	strbeq	r2, [r9, #-3850]!	; 0xfffff0f6
 804:	0305660c 	movweq	r6, #22028	; 0x560c
 808:	680b054b 	stmdavs	fp, {r0, r1, r3, r6, r8, sl}
 80c:	02001805 	andeq	r1, r0, #327680	; 0x50000
 810:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 814:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 818:	15059e03 	strne	r9, [r5, #-3587]	; 0xfffff1fd
 81c:	02040200 	andeq	r0, r4, #0, 4
 820:	00180568 	andseq	r0, r8, r8, ror #10
 824:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 828:	02000805 	andeq	r0, r0, #327680	; 0x50000
 82c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 830:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
 834:	0c054b02 			; <UNDEFINED> instruction: 0x0c054b02
 838:	02040200 	andeq	r0, r4, #0, 4
 83c:	000f0566 	andeq	r0, pc, r6, ror #10
 840:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 844:	02001b05 	andeq	r1, r0, #5120	; 0x1400
 848:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 84c:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 850:	0b052e02 	bleq	14c060 <__bss_end+0x143024>
 854:	02040200 	andeq	r0, r4, #0, 4
 858:	000d052f 	andeq	r0, sp, pc, lsr #10
 85c:	66020402 	strvs	r0, [r2], -r2, lsl #8
 860:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 864:	05460204 	strbeq	r0, [r6, #-516]	; 0xfffffdfc
 868:	05858801 	streq	r8, [r5, #2049]	; 0x801
 86c:	09058306 	stmdbeq	r5, {r1, r2, r8, r9, pc}
 870:	4a10054c 	bmi	401da8 <__bss_end+0x3f8d6c>
 874:	054c0a05 	strbeq	r0, [ip, #-2565]	; 0xfffff5fb
 878:	0305bb07 	movweq	fp, #23303	; 0x5b07
 87c:	0017054a 	andseq	r0, r7, sl, asr #10
 880:	4a010402 	bmi	41890 <__bss_end+0x38854>
 884:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 888:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 88c:	14054d0d 	strne	r4, [r5], #-3341	; 0xfffff2f3
 890:	2e0a054a 	cfsh32cs	mvfx0, mvfx10, #42
 894:	05680805 	strbeq	r0, [r8, #-2053]!	; 0xfffff7fb
 898:	66780302 	ldrbtvs	r0, [r8], -r2, lsl #6
 89c:	0b030905 	bleq	c2cb8 <__bss_end+0xb9c7c>
 8a0:	2f01052e 	svccs	0x0001052e
 8a4:	bd090585 	cfstr32lt	mvfx0, [r9, #-532]	; 0xfffffdec
 8a8:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 8ac:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
 8b0:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
 8b4:	16058202 	strne	r8, [r5], -r2, lsl #4
 8b8:	02040200 	andeq	r0, r4, #0, 4
 8bc:	00120582 	andseq	r0, r2, r2, lsl #11
 8c0:	4b030402 	blmi	c18d0 <__bss_end+0xb8894>
 8c4:	02000905 	andeq	r0, r0, #81920	; 0x14000
 8c8:	05660304 	strbeq	r0, [r6, #-772]!	; 0xfffffcfc
 8cc:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 8d0:	0b056603 	bleq	15a0e4 <__bss_end+0x1510a8>
 8d4:	03040200 	movweq	r0, #16896	; 0x4200
 8d8:	0002052e 	andeq	r0, r2, lr, lsr #10
 8dc:	2d030402 	cfstrscs	mvf0, [r3, #-8]
 8e0:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 8e4:	05840204 	streq	r0, [r4, #516]	; 0x204
 8e8:	04020009 	streq	r0, [r2], #-9
 8ec:	0b058301 	bleq	1614f8 <__bss_end+0x1584bc>
 8f0:	01040200 	mrseq	r0, R12_usr
 8f4:	00020566 	andeq	r0, r2, r6, ror #10
 8f8:	49010402 	stmdbmi	r1, {r1, sl}
 8fc:	05850b05 	streq	r0, [r5, #2821]	; 0xb05
 900:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 904:	1105bc0e 	tstne	r5, lr, lsl #24
 908:	bc200566 	cfstr32lt	mvfx0, [r0], #-408	; 0xfffffe68
 90c:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
 910:	0a054b1f 	beq	153594 <__bss_end+0x14a558>
 914:	4b080566 	blmi	201eb4 <__bss_end+0x1f8e78>
 918:	05831405 	streq	r1, [r3, #1029]	; 0x405
 91c:	08054a16 	stmdaeq	r5, {r1, r2, r4, r9, fp, lr}
 920:	6711054b 	ldrvs	r0, [r1, -fp, asr #10]
 924:	054d0b05 	strbeq	r0, [sp, #-2821]	; 0xfffff4fb
 928:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 92c:	0c058306 	stceq	3, cr8, [r5], {6}
 930:	820e054c 	andhi	r0, lr, #76, 10	; 0x13000000
 934:	054b0405 	strbeq	r0, [fp, #-1029]	; 0xfffffbfb
 938:	09056502 	stmdbeq	r5, {r1, r8, sl, sp, lr}
 93c:	2f010531 	svccs	0x00010531
 940:	9f080585 	svcls	0x00080585
 944:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
 948:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 94c:	08054a03 	stmdaeq	r5, {r0, r1, r9, fp, lr}
 950:	02040200 	andeq	r0, r4, #0, 4
 954:	000a0583 	andeq	r0, sl, r3, lsl #11
 958:	66020402 	strvs	r0, [r2], -r2, lsl #8
 95c:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 960:	05490204 	strbeq	r0, [r9, #-516]	; 0xfffffdfc
 964:	05858401 	streq	r8, [r5, #1025]	; 0x401
 968:	0805bb0e 	stmdaeq	r5, {r1, r2, r3, r8, r9, fp, ip, sp, pc}
 96c:	4c0b054b 	cfstr32mi	mvfx0, [fp], {75}	; 0x4b
 970:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 974:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 978:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 97c:	0b058302 	bleq	16158c <__bss_end+0x158550>
 980:	02040200 	andeq	r0, r4, #0, 4
 984:	00170566 	andseq	r0, r7, r6, ror #10
 988:	66020402 	strvs	r0, [r2], -r2, lsl #8
 98c:	02000d05 	andeq	r0, r0, #320	; 0x140
 990:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 994:	04020002 	streq	r0, [r2], #-2
 998:	01052d02 	tsteq	r5, r2, lsl #26
 99c:	00080284 	andeq	r0, r8, r4, lsl #5
 9a0:	00790101 	rsbseq	r0, r9, r1, lsl #2
 9a4:	00030000 	andeq	r0, r3, r0
 9a8:	00000046 	andeq	r0, r0, r6, asr #32
 9ac:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 9b0:	0101000d 	tsteq	r1, sp
 9b4:	00000101 	andeq	r0, r0, r1, lsl #2
 9b8:	00000100 	andeq	r0, r0, r0, lsl #2
 9bc:	2f2e2e01 	svccs	0x002e2e01
 9c0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 9c4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 9c8:	2f2e2e2f 	svccs	0x002e2e2f
 9cc:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 91c <shift+0x91c>
 9d0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 9d4:	6f632f63 	svcvs	0x00632f63
 9d8:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 9dc:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 9e0:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 9e4:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
 9e8:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
 9ec:	00010053 	andeq	r0, r1, r3, asr r0
 9f0:	05000000 	streq	r0, [r0, #-0]
 9f4:	008d3802 	addeq	r3, sp, r2, lsl #16
 9f8:	08fd0300 	ldmeq	sp!, {r8, r9}^
 9fc:	2f2f3001 	svccs	0x002f3001
 a00:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
 a04:	1401d002 	strne	sp, [r1], #-2
 a08:	2f2f312f 	svccs	0x002f312f
 a0c:	322f4c30 	eorcc	r4, pc, #48, 24	; 0x3000
 a10:	2f661f03 	svccs	0x00661f03
 a14:	2f2f2f2f 	svccs	0x002f2f2f
 a18:	02022f2f 	andeq	r2, r2, #47, 30	; 0xbc
 a1c:	5c010100 	stfpls	f0, [r1], {-0}
 a20:	03000000 	movweq	r0, #0
 a24:	00004600 	andeq	r4, r0, r0, lsl #12
 a28:	fb010200 	blx	41232 <__bss_end+0x381f6>
 a2c:	01000d0e 	tsteq	r0, lr, lsl #26
 a30:	00010101 	andeq	r0, r1, r1, lsl #2
 a34:	00010000 	andeq	r0, r1, r0
 a38:	2e2e0100 	sufcse	f0, f6, f0
 a3c:	2f2e2e2f 	svccs	0x002e2e2f
 a40:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a44:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a48:	2f2e2e2f 	svccs	0x002e2e2f
 a4c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 a50:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 a54:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 a58:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 a5c:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
 a60:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
 a64:	73636e75 	cmnvc	r3, #1872	; 0x750
 a68:	0100532e 	tsteq	r0, lr, lsr #6
 a6c:	00000000 	andeq	r0, r0, r0
 a70:	8f440205 	svchi	0x00440205
 a74:	e7030000 	str	r0, [r3, -r0]
 a78:	0202010b 	andeq	r0, r2, #-1073741822	; 0xc0000002
 a7c:	03010100 	movweq	r0, #4352	; 0x1100
 a80:	03000001 	movweq	r0, #1
 a84:	0000fd00 	andeq	pc, r0, r0, lsl #26
 a88:	fb010200 	blx	41292 <__bss_end+0x38256>
 a8c:	01000d0e 	tsteq	r0, lr, lsl #26
 a90:	00010101 	andeq	r0, r1, r1, lsl #2
 a94:	00010000 	andeq	r0, r1, r0
 a98:	2e2e0100 	sufcse	f0, f6, f0
 a9c:	2f2e2e2f 	svccs	0x002e2e2f
 aa0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 aa4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 aa8:	2f2e2e2f 	svccs	0x002e2e2f
 aac:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 ab0:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
 ab4:	6e692f2e 	cdpvs	15, 6, cr2, cr9, cr14, {1}
 ab8:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 abc:	2e2e0065 	cdpcs	0, 2, cr0, cr14, cr5, {3}
 ac0:	2f2e2e2f 	svccs	0x002e2e2f
 ac4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 ac8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 acc:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
 ad0:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
 ad4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 ad8:	2f2e2e2f 	svccs	0x002e2e2f
 adc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 ae0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 ae4:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 ae8:	2f636367 	svccs	0x00636367
 aec:	672f2e2e 	strvs	r2, [pc, -lr, lsr #28]!
 af0:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 af4:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 af8:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 afc:	2e2e006d 	cdpcs	0, 2, cr0, cr14, cr13, {3}
 b00:	2f2e2e2f 	svccs	0x002e2e2f
 b04:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 b08:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 b0c:	2f2e2e2f 	svccs	0x002e2e2f
 b10:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 b14:	00006363 	andeq	r6, r0, r3, ror #6
 b18:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
 b1c:	2e626174 	mcrcs	1, 3, r6, cr2, cr4, {3}
 b20:	00010068 	andeq	r0, r1, r8, rrx
 b24:	6d726100 	ldfvse	f6, [r2, #-0]
 b28:	6173692d 	cmnvs	r3, sp, lsr #18
 b2c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 b30:	72610000 	rsbvc	r0, r1, #0
 b34:	70632d6d 	rsbvc	r2, r3, sp, ror #26
 b38:	00682e75 	rsbeq	r2, r8, r5, ror lr
 b3c:	69000002 	stmdbvs	r0, {r1}
 b40:	2d6e736e 	stclcs	3, cr7, [lr, #-440]!	; 0xfffffe48
 b44:	736e6f63 	cmnvc	lr, #396	; 0x18c
 b48:	746e6174 	strbtvc	r6, [lr], #-372	; 0xfffffe8c
 b4c:	00682e73 	rsbeq	r2, r8, r3, ror lr
 b50:	61000002 	tstvs	r0, r2
 b54:	682e6d72 	stmdavs	lr!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}
 b58:	00000300 	andeq	r0, r0, r0, lsl #6
 b5c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 b60:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
 b64:	00040068 	andeq	r0, r4, r8, rrx
 b68:	6c626700 	stclvs	7, cr6, [r2], #-0
 b6c:	6f74632d 	svcvs	0x0074632d
 b70:	682e7372 	stmdavs	lr!, {r1, r4, r5, r6, r8, r9, ip, sp, lr}
 b74:	00000400 	andeq	r0, r0, r0, lsl #8
 b78:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 b7c:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
 b80:	00040063 	andeq	r0, r4, r3, rrx
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
      58:	1d010704 	stcne	7, cr0, [r1, #-16]
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
      b0:	0b010000 	bleq	400b8 <__bss_end+0x3707c>
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
     11c:	1d010704 	stcne	7, cr0, [r1, #-16]
     120:	7a080000 	bvc	200128 <__bss_end+0x1f70ec>
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
     15c:	3a010000 	bcc	40164 <__bss_end+0x37128>
     160:	00007615 	andeq	r7, r0, r5, lsl r6
     164:	01dc0900 	bicseq	r0, ip, r0, lsl #18
     168:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
     16c:	0000cb10 	andeq	ip, r0, r0, lsl fp
     170:	0081dc00 	addeq	sp, r1, r0, lsl #24
     174:	00005800 	andeq	r5, r0, r0, lsl #16
     178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f7544>
     17c:	0a000000 	beq	184 <shift+0x184>
     180:	000001ea 	andeq	r0, r0, sl, ror #3
     184:	d20c4a01 	andle	r4, ip, #4096	; 0x1000
     188:	02000000 	andeq	r0, r0, #0
     18c:	0b007491 	bleq	1d3d8 <__bss_end+0x1439c>
     190:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     194:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
     198:	00000038 	andeq	r0, r0, r8, lsr r0
     19c:	00036d09 	andeq	r6, r3, r9, lsl #26
     1a0:	103c0100 	eorsne	r0, ip, r0, lsl #2
     1a4:	000000cb 	andeq	r0, r0, fp, asr #1
     1a8:	00008184 	andeq	r8, r0, r4, lsl #3
     1ac:	00000058 	andeq	r0, r0, r8, asr r0
     1b0:	01029c01 	tsteq	r2, r1, lsl #24
     1b4:	ea0a0000 	b	2801bc <__bss_end+0x277180>
     1b8:	01000001 	tsteq	r0, r1
     1bc:	01020c3e 	tsteq	r2, lr, lsr ip
     1c0:	91020000 	mrsls	r0, (UNDEF: 2)
     1c4:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
     1c8:	00000025 	andeq	r0, r0, r5, lsr #32
     1cc:	0001c50c 	andeq	ip, r1, ip, lsl #10
     1d0:	11290100 			; <UNDEFINED> instruction: 0x11290100
     1d4:	00008178 	andeq	r8, r0, r8, ror r1
     1d8:	0000000c 	andeq	r0, r0, ip
     1dc:	fb0c9c01 	blx	3271ea <__bss_end+0x31e1ae>
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
     254:	cb110a01 	blgt	442a60 <__bss_end+0x439a24>
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
     2bc:	0a010067 	beq	40460 <__bss_end+0x37424>
     2c0:	00019e2f 	andeq	r9, r1, pc, lsr #28
     2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     2c8:	0e440000 	cdpeq	0, 4, cr0, cr4, cr0, {0}
     2cc:	00040000 	andeq	r0, r4, r0
     2d0:	000001c6 	andeq	r0, r0, r6, asr #3
     2d4:	02650104 	rsbeq	r0, r5, #4, 2
     2d8:	05040000 	streq	r0, [r4, #-0]
     2dc:	3a00000d 	bcc	318 <shift+0x318>
     2e0:	34000000 	strcc	r0, [r0], #-0
     2e4:	ec000082 	stc	0, cr0, [r0], {130}	; 0x82
     2e8:	ff000001 			; <UNDEFINED> instruction: 0xff000001
     2ec:	02000001 	andeq	r0, r0, #1
     2f0:	10840801 	addne	r0, r4, r1, lsl #16
     2f4:	25030000 	strcs	r0, [r3, #-0]
     2f8:	02000000 	andeq	r0, r0, #0
     2fc:	0e140502 	cfmul32eq	mvfx0, mvfx4, mvfx2
     300:	04040000 	streq	r0, [r4], #-0
     304:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     308:	08010200 	stmdaeq	r1, {r9}
     30c:	0000107b 	andeq	r1, r0, fp, ror r0
     310:	15070202 	strne	r0, [r7, #-514]	; 0xfffffdfe
     314:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
     318:	0000070e 	andeq	r0, r0, lr, lsl #14
     31c:	5e1e0903 	vnmlspl.f16	s0, s28, s6	; <UNPREDICTABLE>
     320:	03000000 	movweq	r0, #0
     324:	0000004d 	andeq	r0, r0, sp, asr #32
     328:	01070402 	tsteq	r7, r2, lsl #8
     32c:	0300001d 	movweq	r0, #29
     330:	0000005e 	andeq	r0, r0, lr, asr r0
     334:	00005e06 	andeq	r5, r0, r6, lsl #28
     338:	130e0700 	movwne	r0, #59136	; 0xe700
     33c:	02080000 	andeq	r0, r8, #0
     340:	00950806 	addseq	r0, r5, r6, lsl #16
     344:	72080000 	andvc	r0, r8, #0
     348:	08020030 	stmdaeq	r2, {r4, r5}
     34c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     350:	72080000 	andvc	r0, r8, #0
     354:	09020031 	stmdbeq	r2, {r0, r4, r5}
     358:	00004d0e 	andeq	r4, r0, lr, lsl #26
     35c:	09000400 	stmdbeq	r0, {sl}
     360:	00000ecb 	andeq	r0, r0, fp, asr #29
     364:	00380405 	eorseq	r0, r8, r5, lsl #8
     368:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
     36c:	0000cc0c 	andeq	ip, r0, ip, lsl #24
     370:	07060a00 	streq	r0, [r6, -r0, lsl #20]
     374:	0a000000 	beq	37c <shift+0x37c>
     378:	00000934 	andeq	r0, r0, r4, lsr r9
     37c:	0eed0a01 	vfmaeq.f32	s1, s26, s2
     380:	0a020000 	beq	80388 <__bss_end+0x7734c>
     384:	00001097 	muleq	r0, r7, r0
     388:	091a0a03 	ldmdbeq	sl, {r0, r1, r9, fp}
     38c:	0a040000 	beq	100394 <__bss_end+0xf7358>
     390:	00000dec 	andeq	r0, r0, ip, ror #27
     394:	ab090005 	blge	2403b0 <__bss_end+0x237374>
     398:	0500000e 	streq	r0, [r0, #-14]
     39c:	00003804 	andeq	r3, r0, r4, lsl #16
     3a0:	0c3f0200 	lfmeq	f0, 4, [pc], #-0	; 3a8 <shift+0x3a8>
     3a4:	00000109 	andeq	r0, r0, r9, lsl #2
     3a8:	0008710a 	andeq	r7, r8, sl, lsl #2
     3ac:	d40a0000 	strle	r0, [sl], #-0
     3b0:	0100000f 	tsteq	r0, pc
     3b4:	0012950a 	andseq	r9, r2, sl, lsl #10
     3b8:	ab0a0200 	blge	280bc0 <__bss_end+0x277b84>
     3bc:	0300000c 	movweq	r0, #12
     3c0:	00092e0a 	andeq	r2, r9, sl, lsl #28
     3c4:	1d0a0400 	cfstrsne	mvf0, [sl, #-0]
     3c8:	0500000a 	streq	r0, [r0, #-10]
     3cc:	0007730a 	andeq	r7, r7, sl, lsl #6
     3d0:	09000600 	stmdbeq	r0, {r9, sl}
     3d4:	00000758 	andeq	r0, r0, r8, asr r7
     3d8:	00380405 	eorseq	r0, r8, r5, lsl #8
     3dc:	66020000 	strvs	r0, [r2], -r0
     3e0:	0001340c 	andeq	r3, r1, ip, lsl #8
     3e4:	10700a00 	rsbsne	r0, r0, r0, lsl #20
     3e8:	0a000000 	beq	3f0 <shift+0x3f0>
     3ec:	000005da 	ldrdeq	r0, [r0], -sl
     3f0:	0f110a01 	svceq	0x00110a01
     3f4:	0a020000 	beq	803fc <__bss_end+0x773c0>
     3f8:	00000dfc 	strdeq	r0, [r0], -ip
     3fc:	ca050003 	bgt	140410 <__bss_end+0x1373d4>
     400:	0400000d 	streq	r0, [r0], #-13
     404:	00381703 	eorseq	r1, r8, r3, lsl #14
     408:	120b0000 	andne	r0, fp, #0
     40c:	0400000c 	streq	r0, [r0], #-12
     410:	00591405 	subseq	r1, r9, r5, lsl #8
     414:	03050000 	movweq	r0, #20480	; 0x5000
     418:	00008f48 	andeq	r8, r0, r8, asr #30
     41c:	000fd90b 	andeq	sp, pc, fp, lsl #18
     420:	14060400 	strne	r0, [r6], #-1024	; 0xfffffc00
     424:	00000059 	andeq	r0, r0, r9, asr r0
     428:	8f4c0305 	svchi	0x004c0305
     42c:	880b0000 	stmdahi	fp, {}	; <UNPREDICTABLE>
     430:	0500000a 	streq	r0, [r0, #-10]
     434:	00591a07 	subseq	r1, r9, r7, lsl #20
     438:	03050000 	movweq	r0, #20480	; 0x5000
     43c:	00008f50 	andeq	r8, r0, r0, asr pc
     440:	000e250b 	andeq	r2, lr, fp, lsl #10
     444:	1a090500 	bne	24184c <__bss_end+0x238810>
     448:	00000059 	andeq	r0, r0, r9, asr r0
     44c:	8f540305 	svchi	0x00540305
     450:	4b0b0000 	blmi	2c0458 <__bss_end+0x2b741c>
     454:	0500000a 	streq	r0, [r0, #-10]
     458:	00591a0b 	subseq	r1, r9, fp, lsl #20
     45c:	03050000 	movweq	r0, #20480	; 0x5000
     460:	00008f58 	andeq	r8, r0, r8, asr pc
     464:	000db70b 	andeq	fp, sp, fp, lsl #14
     468:	1a0d0500 	bne	341870 <__bss_end+0x338834>
     46c:	00000059 	andeq	r0, r0, r9, asr r0
     470:	8f5c0305 	svchi	0x005c0305
     474:	e60b0000 	str	r0, [fp], -r0
     478:	05000006 	streq	r0, [r0, #-6]
     47c:	00591a0f 	subseq	r1, r9, pc, lsl #20
     480:	03050000 	movweq	r0, #20480	; 0x5000
     484:	00008f60 	andeq	r8, r0, r0, ror #30
     488:	000c9109 	andeq	r9, ip, r9, lsl #2
     48c:	38040500 	stmdacc	r4, {r8, sl}
     490:	05000000 	streq	r0, [r0, #-0]
     494:	01e30c1b 	mvneq	r0, fp, lsl ip
     498:	890a0000 	stmdbhi	sl, {}	; <UNPREDICTABLE>
     49c:	00000006 	andeq	r0, r0, r6
     4a0:	0011030a 	andseq	r0, r1, sl, lsl #6
     4a4:	900a0100 	andls	r0, sl, r0, lsl #2
     4a8:	02000012 	andeq	r0, r0, #18
     4ac:	04610c00 	strbteq	r0, [r1], #-3072	; 0xfffff400
     4b0:	290d0000 	stmdbcs	sp, {}	; <UNPREDICTABLE>
     4b4:	90000005 	andls	r0, r0, r5
     4b8:	56076305 	strpl	r6, [r7], -r5, lsl #6
     4bc:	07000003 	streq	r0, [r0, -r3]
     4c0:	00000665 	andeq	r0, r0, r5, ror #12
     4c4:	10670524 	rsbne	r0, r7, r4, lsr #10
     4c8:	00000270 	andeq	r0, r0, r0, ror r2
     4cc:	0020e90e 	eoreq	lr, r0, lr, lsl #18
     4d0:	28690500 	stmdacs	r9!, {r8, sl}^
     4d4:	00000356 	andeq	r0, r0, r6, asr r3
     4d8:	08760e00 	ldmdaeq	r6!, {r9, sl, fp}^
     4dc:	6b050000 	blvs	1404e4 <__bss_end+0x1374a8>
     4e0:	00036620 	andeq	r6, r3, r0, lsr #12
     4e4:	7e0e1000 	cdpvc	0, 0, cr1, cr14, cr0, {0}
     4e8:	05000006 	streq	r0, [r0, #-6]
     4ec:	004d236d 	subeq	r2, sp, sp, ror #6
     4f0:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     4f4:	00000df5 	strdeq	r0, [r0], -r5
     4f8:	6d1c7005 	ldcvs	0, cr7, [ip, #-20]	; 0xffffffec
     4fc:	18000003 	stmdane	r0, {r0, r1}
     500:	00124d0e 	andseq	r4, r2, lr, lsl #26
     504:	1c720500 	cfldr64ne	mvdx0, [r2], #-0
     508:	0000036d 	andeq	r0, r0, sp, ror #6
     50c:	05240e1c 	streq	r0, [r4, #-3612]!	; 0xfffff1e4
     510:	75050000 	strvc	r0, [r5, #-0]
     514:	00036d1c 	andeq	r6, r3, ip, lsl sp
     518:	9a0f2000 	bls	3c8520 <__bss_end+0x3bf4e4>
     51c:	0500000e 	streq	r0, [r0, #-14]
     520:	11a01c77 	rorne	r1, r7, ip
     524:	036d0000 	cmneq	sp, #0
     528:	02640000 	rsbeq	r0, r4, #0
     52c:	6d100000 	ldcvs	0, cr0, [r0, #-0]
     530:	11000003 	tstne	r0, r3
     534:	00000373 	andeq	r0, r0, r3, ror r3
     538:	85070000 	strhi	r0, [r7, #-0]
     53c:	18000012 	stmdane	r0, {r1, r4}
     540:	a5107b05 	ldrge	r7, [r0, #-2821]	; 0xfffff4fb
     544:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
     548:	000020e9 	andeq	r2, r0, r9, ror #1
     54c:	562c7e05 	strtpl	r7, [ip], -r5, lsl #28
     550:	00000003 	andeq	r0, r0, r3
     554:	0005860e 	andeq	r8, r5, lr, lsl #12
     558:	19800500 	stmibne	r0, {r8, sl}
     55c:	00000373 	andeq	r0, r0, r3, ror r3
     560:	0a240e10 	beq	903da8 <__bss_end+0x8fad6c>
     564:	82050000 	andhi	r0, r5, #0
     568:	00037e21 	andeq	r7, r3, r1, lsr #28
     56c:	03001400 	movweq	r1, #1024	; 0x400
     570:	00000270 	andeq	r0, r0, r0, ror r2
     574:	0004d712 	andeq	sp, r4, r2, lsl r7
     578:	21860500 	orrcs	r0, r6, r0, lsl #10
     57c:	00000384 	andeq	r0, r0, r4, lsl #7
     580:	0008a012 	andeq	sl, r8, r2, lsl r0
     584:	1f880500 	svcne	0x00880500
     588:	00000059 	andeq	r0, r0, r9, asr r0
     58c:	000e370e 	andeq	r3, lr, lr, lsl #14
     590:	178b0500 	strne	r0, [fp, r0, lsl #10]
     594:	000001f5 	strdeq	r0, [r0], -r5
     598:	07d80e00 	ldrbeq	r0, [r8, r0, lsl #28]
     59c:	8e050000 	cdphi	0, 0, cr0, cr5, cr0, {0}
     5a0:	0001f517 	andeq	pc, r1, r7, lsl r5	; <UNPREDICTABLE>
     5a4:	960e2400 	strls	r2, [lr], -r0, lsl #8
     5a8:	0500000b 	streq	r0, [r0, #-11]
     5ac:	01f5178f 	mvnseq	r1, pc, lsl #15
     5b0:	0e480000 	cdpeq	0, 4, cr0, cr8, cr0, {0}
     5b4:	000009a5 	andeq	r0, r0, r5, lsr #19
     5b8:	f5179005 			; <UNDEFINED> instruction: 0xf5179005
     5bc:	6c000001 	stcvs	0, cr0, [r0], {1}
     5c0:	00052913 	andeq	r2, r5, r3, lsl r9
     5c4:	09930500 	ldmibeq	r3, {r8, sl}
     5c8:	00000d7a 	andeq	r0, r0, sl, ror sp
     5cc:	0000038f 	andeq	r0, r0, pc, lsl #7
     5d0:	00030f01 	andeq	r0, r3, r1, lsl #30
     5d4:	00031500 	andeq	r1, r3, r0, lsl #10
     5d8:	038f1000 	orreq	r1, pc, #0
     5dc:	14000000 	strne	r0, [r0], #-0
     5e0:	00000e8f 	andeq	r0, r0, pc, lsl #29
     5e4:	670e9605 	strvs	r9, [lr, -r5, lsl #12]
     5e8:	01000005 	tsteq	r0, r5
     5ec:	0000032a 	andeq	r0, r0, sl, lsr #6
     5f0:	00000330 	andeq	r0, r0, r0, lsr r3
     5f4:	00038f10 	andeq	r8, r3, r0, lsl pc
     5f8:	71150000 	tstvc	r5, r0
     5fc:	05000008 	streq	r0, [r0, #-8]
     600:	0c761099 	ldcleq	0, cr1, [r6], #-612	; 0xfffffd9c
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
     630:	31020102 	tstcc	r2, r2, lsl #2
     634:	1800000b 	stmdane	r0, {r0, r1, r3}
     638:	0001f504 	andeq	pc, r1, r4, lsl #10
     63c:	2c041800 	stccs	8, cr1, [r4], {-0}
     640:	0c000000 	stceq	0, cr0, [r0], {-0}
     644:	00001175 	andeq	r1, r0, r5, ror r1
     648:	03790418 	cmneq	r9, #24, 8	; 0x18000000
     64c:	a5160000 	ldrge	r0, [r6, #-0]
     650:	8f000002 	svchi	0x00000002
     654:	19000003 	stmdbne	r0, {r0, r1}
     658:	e8041800 	stmda	r4, {fp, ip}
     65c:	18000001 	stmdane	r0, {r0}
     660:	0001e304 	andeq	lr, r1, r4, lsl #6
     664:	0e831a00 	vdiveq.f32	s2, s6, s0
     668:	9c050000 	stcls	0, cr0, [r5], {-0}
     66c:	0001e814 	andeq	lr, r1, r4, lsl r8
     670:	069f0b00 	ldreq	r0, [pc], r0, lsl #22
     674:	04060000 	streq	r0, [r6], #-0
     678:	00005914 	andeq	r5, r0, r4, lsl r9
     67c:	64030500 	strvs	r0, [r3], #-1280	; 0xfffffb00
     680:	0b00008f 	bleq	8c4 <shift+0x8c4>
     684:	00000ef3 	strdeq	r0, [r0], -r3
     688:	59140706 	ldmdbpl	r4, {r1, r2, r8, r9, sl}
     68c:	05000000 	streq	r0, [r0, #-0]
     690:	008f6803 	addeq	r6, pc, r3, lsl #16
     694:	05540b00 	ldrbeq	r0, [r4, #-2816]	; 0xfffff500
     698:	0a060000 	beq	1806a0 <__bss_end+0x177664>
     69c:	00005914 	andeq	r5, r0, r4, lsl r9
     6a0:	6c030500 	cfstr32vs	mvfx0, [r3], {-0}
     6a4:	0900008f 	stmdbeq	r0, {r0, r1, r2, r3, r7}
     6a8:	00000778 	andeq	r0, r0, r8, ror r7
     6ac:	00380405 	eorseq	r0, r8, r5, lsl #8
     6b0:	0d060000 	stceq	0, cr0, [r6, #-0]
     6b4:	0004140c 	andeq	r1, r4, ip, lsl #8
     6b8:	654e1b00 	strbvs	r1, [lr, #-2816]	; 0xfffff500
     6bc:	0a000077 	beq	8a0 <shift+0x8a0>
     6c0:	0000093e 	andeq	r0, r0, lr, lsr r9
     6c4:	054c0a01 	strbeq	r0, [ip, #-2561]	; 0xfffff5ff
     6c8:	0a020000 	beq	806d0 <__bss_end+0x77694>
     6cc:	00000796 	muleq	r0, r6, r7
     6d0:	10890a03 	addne	r0, r9, r3, lsl #20
     6d4:	0a040000 	beq	1006dc <__bss_end+0xf76a0>
     6d8:	0000051d 	andeq	r0, r0, sp, lsl r5
     6dc:	b8070005 	stmdalt	r7, {r0, r2}
     6e0:	10000006 	andne	r0, r0, r6
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
     710:	00000ea5 	andeq	r0, r0, r5, lsr #29
     714:	53132006 	tstpl	r3, #6
     718:	0c000004 	stceq	0, cr0, [r0], {4}
     71c:	07040200 	streq	r0, [r4, -r0, lsl #4]
     720:	00001cfc 	strdeq	r1, [r0], -ip
     724:	00045303 	andeq	r5, r4, r3, lsl #6
     728:	090d0700 	stmdbeq	sp, {r8, r9, sl}
     72c:	06700000 	ldrbteq	r0, [r0], -r0
     730:	04ef0828 	strbteq	r0, [pc], #2088	; 738 <shift+0x738>
     734:	200e0000 	andcs	r0, lr, r0
     738:	06000008 	streq	r0, [r0], -r8
     73c:	0414122a 	ldreq	r1, [r4], #-554	; 0xfffffdd6
     740:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     744:	00646970 	rsbeq	r6, r4, r0, ror r9
     748:	5e122b06 	vnmlspl.f64	d2, d2, d6
     74c:	10000000 	andne	r0, r0, r0
     750:	001ada0e 	andseq	sp, sl, lr, lsl #20
     754:	112c0600 			; <UNDEFINED> instruction: 0x112c0600
     758:	000003dd 	ldrdeq	r0, [r0], -sp
     75c:	10620e14 	rsbne	r0, r2, r4, lsl lr
     760:	2d060000 	stccs	0, cr0, [r6, #-0]
     764:	00005e12 	andeq	r5, r0, r2, lsl lr
     768:	f10e1800 			; <UNDEFINED> instruction: 0xf10e1800
     76c:	06000003 	streq	r0, [r0], -r3
     770:	005e122e 	subseq	r1, lr, lr, lsr #4
     774:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
     778:	00000ee0 	andeq	r0, r0, r0, ror #29
     77c:	ef312f06 	svc	0x00312f06
     780:	20000004 	andcs	r0, r0, r4
     784:	0004cd0e 	andeq	ip, r4, lr, lsl #26
     788:	09300600 	ldmdbeq	r0!, {r9, sl}
     78c:	00000038 	andeq	r0, r0, r8, lsr r0
     790:	0af00e60 	beq	ffc04118 <__bss_end+0xffbfb0dc>
     794:	31060000 	mrscc	r0, (UNDEF: 6)
     798:	00004d0e 	andeq	r4, r0, lr, lsl #26
     79c:	640e6400 	strvs	r6, [lr], #-1024	; 0xfffffc00
     7a0:	0600000d 	streq	r0, [r0], -sp
     7a4:	004d0e33 	subeq	r0, sp, r3, lsr lr
     7a8:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
     7ac:	00000d5b 	andeq	r0, r0, fp, asr sp
     7b0:	4d0e3406 	cfstrsmi	mvf3, [lr, #-24]	; 0xffffffe8
     7b4:	6c000000 	stcvs	0, cr0, [r0], {-0}
     7b8:	03951600 	orrseq	r1, r5, #0, 12
     7bc:	04ff0000 	ldrbteq	r0, [pc], #0	; 7c4 <shift+0x7c4>
     7c0:	5e170000 	cdppl	0, 1, cr0, cr7, cr0, {0}
     7c4:	0f000000 	svceq	0x00000000
     7c8:	053d0b00 	ldreq	r0, [sp, #-2816]!	; 0xfffff500
     7cc:	0a070000 	beq	1c07d4 <__bss_end+0x1b7798>
     7d0:	00005914 	andeq	r5, r0, r4, lsl r9
     7d4:	70030500 	andvc	r0, r3, r0, lsl #10
     7d8:	0900008f 	stmdbeq	r0, {r0, r1, r2, r3, r7}
     7dc:	00000adb 	ldrdeq	r0, [r0], -fp
     7e0:	00380405 	eorseq	r0, r8, r5, lsl #8
     7e4:	0d070000 	stceq	0, cr0, [r7, #-0]
     7e8:	0005300c 	andeq	r3, r5, ip
     7ec:	129b0a00 	addsne	r0, fp, #0, 20
     7f0:	0a000000 	beq	7f8 <shift+0x7f8>
     7f4:	00001138 	andeq	r1, r0, r8, lsr r1
     7f8:	05070001 	streq	r0, [r7, #-1]
     7fc:	0c000008 	stceq	0, cr0, [r0], {8}
     800:	65081b07 	strvs	r1, [r8, #-2823]	; 0xfffff4f9
     804:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
     808:	000005e5 	andeq	r0, r0, r5, ror #11
     80c:	65191d07 	ldrvs	r1, [r9, #-3335]	; 0xfffff2f9
     810:	00000005 	andeq	r0, r0, r5
     814:	0005240e 	andeq	r2, r5, lr, lsl #8
     818:	191e0700 	ldmdbne	lr, {r8, r9, sl}
     81c:	00000565 	andeq	r0, r0, r5, ror #10
     820:	0b0b0e04 	bleq	2c4038 <__bss_end+0x2baffc>
     824:	1f070000 	svcne	0x00070000
     828:	00056b13 	andeq	r6, r5, r3, lsl fp
     82c:	18000800 	stmdane	r0, {fp}
     830:	00053004 	andeq	r3, r5, r4
     834:	5f041800 	svcpl	0x00041800
     838:	0d000004 	stceq	0, cr0, [r0, #-16]
     83c:	00000e46 	andeq	r0, r0, r6, asr #28
     840:	07220714 			; <UNDEFINED> instruction: 0x07220714
     844:	000007f3 	strdeq	r0, [r0], -r3
     848:	000c200e 	andeq	r2, ip, lr
     84c:	12260700 	eorne	r0, r6, #0, 14
     850:	0000004d 	andeq	r0, r0, sp, asr #32
     854:	0bb30e00 	bleq	fecc405c <__bss_end+0xfecbb020>
     858:	29070000 	stmdbcs	r7, {}	; <UNPREDICTABLE>
     85c:	0005651d 	andeq	r6, r5, sp, lsl r5
     860:	9e0e0400 	cfcpysls	mvf0, mvf14
     864:	07000007 	streq	r0, [r0, -r7]
     868:	05651d2c 	strbeq	r1, [r5, #-3372]!	; 0xfffff2d4
     86c:	1c080000 	stcne	0, cr0, [r8], {-0}
     870:	00000ca1 	andeq	r0, r0, r1, lsr #25
     874:	e20e2f07 	and	r2, lr, #7, 30
     878:	b9000007 	stmdblt	r0, {r0, r1, r2}
     87c:	c4000005 	strgt	r0, [r0], #-5
     880:	10000005 	andne	r0, r0, r5
     884:	000007f8 	strdeq	r0, [r0], -r8
     888:	00056511 	andeq	r6, r5, r1, lsl r5
     88c:	471d0000 	ldrmi	r0, [sp, -r0]
     890:	07000009 	streq	r0, [r0, -r9]
     894:	08e40e31 	stmiaeq	r4!, {r0, r4, r5, r9, sl, fp}^
     898:	03660000 	cmneq	r6, #0
     89c:	05dc0000 	ldrbeq	r0, [ip]
     8a0:	05e70000 	strbeq	r0, [r7, #0]!
     8a4:	f8100000 			; <UNDEFINED> instruction: 0xf8100000
     8a8:	11000007 	tstne	r0, r7
     8ac:	0000056b 	andeq	r0, r0, fp, ror #10
     8b0:	10e41300 	rscne	r1, r4, r0, lsl #6
     8b4:	35070000 	strcc	r0, [r7, #-0]
     8b8:	000ab61d 	andeq	fp, sl, sp, lsl r6
     8bc:	00056500 	andeq	r6, r5, r0, lsl #10
     8c0:	06000200 	streq	r0, [r0], -r0, lsl #4
     8c4:	06060000 	streq	r0, [r6], -r0
     8c8:	f8100000 			; <UNDEFINED> instruction: 0xf8100000
     8cc:	00000007 	andeq	r0, r0, r7
     8d0:	00078913 	andeq	r8, r7, r3, lsl r9
     8d4:	1d370700 	ldcne	7, cr0, [r7, #-0]
     8d8:	00000cb1 			; <UNDEFINED> instruction: 0x00000cb1
     8dc:	00000565 	andeq	r0, r0, r5, ror #10
     8e0:	00061f02 	andeq	r1, r6, r2, lsl #30
     8e4:	00062500 	andeq	r2, r6, r0, lsl #10
     8e8:	07f81000 	ldrbeq	r1, [r8, r0]!
     8ec:	1e000000 	cdpne	0, 0, cr0, cr0, cr0, {0}
     8f0:	00000bc6 	andeq	r0, r0, r6, asr #23
     8f4:	11443907 	cmpne	r4, r7, lsl #18
     8f8:	0c000008 	stceq	0, cr0, [r0], {8}
     8fc:	0e461302 	cdpeq	3, 4, cr1, cr6, cr2, {0}
     900:	3c070000 	stccc	0, cr0, [r7], {-0}
     904:	00095609 	andeq	r5, r9, r9, lsl #12
     908:	0007f800 	andeq	pc, r7, r0, lsl #16
     90c:	064c0100 	strbeq	r0, [ip], -r0, lsl #2
     910:	06520000 	ldrbeq	r0, [r2], -r0
     914:	f8100000 			; <UNDEFINED> instruction: 0xf8100000
     918:	00000007 	andeq	r0, r0, r7
     91c:	00083213 	andeq	r3, r8, r3, lsl r2
     920:	123f0700 	eorsne	r0, pc, #0, 14
     924:	000005af 	andeq	r0, r0, pc, lsr #11
     928:	0000004d 	andeq	r0, r0, sp, asr #32
     92c:	00066b01 	andeq	r6, r6, r1, lsl #22
     930:	00068000 	andeq	r8, r6, r0
     934:	07f81000 	ldrbeq	r1, [r8, r0]!
     938:	1a110000 	bne	440940 <__bss_end+0x437904>
     93c:	11000008 	tstne	r0, r8
     940:	0000005e 	andeq	r0, r0, lr, asr r0
     944:	00036611 	andeq	r6, r3, r1, lsl r6
     948:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     94c:	07000011 	smladeq	r0, r1, r0, r0
     950:	06c50e42 	strbeq	r0, [r5], r2, asr #28
     954:	95010000 	strls	r0, [r1, #-0]
     958:	9b000006 	blls	978 <shift+0x978>
     95c:	10000006 	andne	r0, r0, r6
     960:	000007f8 	strdeq	r0, [r0], -r8
     964:	05911300 	ldreq	r1, [r1, #768]	; 0x300
     968:	45070000 	strmi	r0, [r7, #-0]
     96c:	00063717 	andeq	r3, r6, r7, lsl r7
     970:	00056b00 	andeq	r6, r5, r0, lsl #22
     974:	06b40100 	ldrteq	r0, [r4], r0, lsl #2
     978:	06ba0000 	ldrteq	r0, [sl], r0
     97c:	20100000 	andscs	r0, r0, r0
     980:	00000008 	andeq	r0, r0, r8
     984:	000efe13 	andeq	pc, lr, r3, lsl lr	; <UNPREDICTABLE>
     988:	17480700 	strbne	r0, [r8, -r0, lsl #14]
     98c:	00000407 	andeq	r0, r0, r7, lsl #8
     990:	0000056b 	andeq	r0, r0, fp, ror #10
     994:	0006d301 	andeq	sp, r6, r1, lsl #6
     998:	0006de00 	andeq	sp, r6, r0, lsl #28
     99c:	08201000 	stmdaeq	r0!, {ip}
     9a0:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     9a4:	00000000 	andeq	r0, r0, r0
     9a8:	0006f014 	andeq	pc, r6, r4, lsl r0	; <UNPREDICTABLE>
     9ac:	0e4b0700 	cdpeq	7, 4, cr0, cr11, cr0, {0}
     9b0:	00000bd4 	ldrdeq	r0, [r0], -r4
     9b4:	0006f301 	andeq	pc, r6, r1, lsl #6
     9b8:	0006f900 	andeq	pc, r6, r0, lsl #18
     9bc:	07f81000 	ldrbeq	r1, [r8, r0]!
     9c0:	13000000 	movwne	r0, #0
     9c4:	00000947 	andeq	r0, r0, r7, asr #18
     9c8:	8f0e4d07 	svchi	0x000e4d07
     9cc:	6600000d 	strvs	r0, [r0], -sp
     9d0:	01000003 	tsteq	r0, r3
     9d4:	00000712 	andeq	r0, r0, r2, lsl r7
     9d8:	0000071d 	andeq	r0, r0, sp, lsl r7
     9dc:	0007f810 	andeq	pc, r7, r0, lsl r8	; <UNPREDICTABLE>
     9e0:	004d1100 	subeq	r1, sp, r0, lsl #2
     9e4:	13000000 	movwne	r0, #0
     9e8:	00000509 	andeq	r0, r0, r9, lsl #10
     9ec:	34125007 	ldrcc	r5, [r2], #-7
     9f0:	4d000004 	stcmi	0, cr0, [r0, #-16]
     9f4:	01000000 	mrseq	r0, (UNDEF: 0)
     9f8:	00000736 	andeq	r0, r0, r6, lsr r7
     9fc:	00000741 	andeq	r0, r0, r1, asr #14
     a00:	0007f810 	andeq	pc, r7, r0, lsl r8	; <UNPREDICTABLE>
     a04:	03951100 	orrseq	r1, r5, #0, 2
     a08:	13000000 	movwne	r0, #0
     a0c:	00000467 	andeq	r0, r0, r7, ror #8
     a10:	430e5307 	movwmi	r5, #58119	; 0xe307
     a14:	66000011 			; <UNDEFINED> instruction: 0x66000011
     a18:	01000003 	tsteq	r0, r3
     a1c:	0000075a 	andeq	r0, r0, sl, asr r7
     a20:	00000765 	andeq	r0, r0, r5, ror #14
     a24:	0007f810 	andeq	pc, r7, r0, lsl r8	; <UNPREDICTABLE>
     a28:	004d1100 	subeq	r1, sp, r0, lsl #2
     a2c:	14000000 	strne	r0, [r0], #-0
     a30:	000004e3 	andeq	r0, r0, r3, ror #9
     a34:	e50e5607 	str	r5, [lr, #-1543]	; 0xfffff9f9
     a38:	0100000f 	tsteq	r0, pc
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
     a64:	000011d0 	ldrdeq	r1, [r0], -r0
     a68:	c20e5807 	andgt	r5, lr, #458752	; 0x70000
     a6c:	01000012 	tsteq	r0, r2, lsl r0
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
     a98:	000004f6 	strdeq	r0, [r0], -r6
     a9c:	360e5b07 	strcc	r5, [lr], -r7, lsl #22
     aa0:	6600000b 	strvs	r0, [r0], -fp
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
     af8:	00122d1a 	andseq	r2, r2, sl, lsl sp
     afc:	195e0700 	ldmdbne	lr, {r8, r9, sl}^
     b00:	00000571 	andeq	r0, r0, r1, ror r5
     b04:	6c616823 	stclvs	8, cr6, [r1], #-140	; 0xffffff74
     b08:	0b050800 	bleq	142b10 <__bss_end+0x139ad4>
     b0c:	000008f4 	strdeq	r0, [r0], -r4
     b10:	000b8324 	andeq	r8, fp, r4, lsr #6
     b14:	19070800 	stmdbne	r7, {fp}
     b18:	00000065 	andeq	r0, r0, r5, rrx
     b1c:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
     b20:	000f2824 	andeq	r2, pc, r4, lsr #16
     b24:	1a0a0800 	bne	282b2c <__bss_end+0x279af0>
     b28:	0000045a 	andeq	r0, r0, sl, asr r4
     b2c:	20000000 	andcs	r0, r0, r0
     b30:	0005a524 	andeq	sl, r5, r4, lsr #10
     b34:	1a0d0800 	bne	342b3c <__bss_end+0x339b00>
     b38:	0000045a 	andeq	r0, r0, sl, asr r4
     b3c:	20200000 	eorcs	r0, r0, r0
     b40:	000afc25 	andeq	pc, sl, r5, lsr #24
     b44:	15100800 	ldrne	r0, [r0, #-2048]	; 0xfffff800
     b48:	00000059 	andeq	r0, r0, r9, asr r0
     b4c:	10f02436 	rscsne	r2, r0, r6, lsr r4
     b50:	42080000 	andmi	r0, r8, #0
     b54:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b58:	21500000 	cmpcs	r0, r0
     b5c:	126b2420 	rsbne	r2, fp, #32, 8	; 0x20000000
     b60:	71080000 	mrsvc	r0, (UNDEF: 8)
     b64:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b68:	00b20000 	adcseq	r0, r2, r0
     b6c:	08952420 	ldmeq	r5, {r5, sl, sp}
     b70:	a4080000 	strge	r0, [r8], #-0
     b74:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b78:	00b40000 	adcseq	r0, r4, r0
     b7c:	0b792420 	bleq	1e49c04 <__bss_end+0x1e40bc8>
     b80:	b3080000 	movwlt	r0, #32768	; 0x8000
     b84:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b88:	10400000 	subne	r0, r0, r0
     b8c:	0cea2420 	cfstrdeq	mvd2, [sl], #128	; 0x80
     b90:	be080000 	cdplt	0, 0, cr0, cr8, cr0, {0}
     b94:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b98:	20500000 	subscs	r0, r0, r0
     b9c:	07692420 	strbeq	r2, [r9, -r0, lsr #8]!
     ba0:	bf080000 	svclt	0x00080000
     ba4:	00045a1a 	andeq	r5, r4, sl, lsl sl
     ba8:	80400000 	subhi	r0, r0, r0
     bac:	10f92420 	rscsne	r2, r9, r0, lsr #8
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
     bf4:	0f750b00 	svceq	0x00750b00
     bf8:	08090000 	stmdaeq	r9, {}	; <UNPREDICTABLE>
     bfc:	00005914 	andeq	r5, r0, r4, lsl r9
     c00:	a0030500 	andge	r0, r3, r0, lsl #10
     c04:	0900008f 	stmdbeq	r0, {r0, r1, r2, r3, r7}
     c08:	00000c53 	andeq	r0, r0, r3, asr ip
     c0c:	005e0407 	subseq	r0, lr, r7, lsl #8
     c10:	0b090000 	bleq	240c18 <__bss_end+0x237bdc>
     c14:	0009860c 	andeq	r8, r9, ip, lsl #12
     c18:	0c660a00 			; <UNDEFINED> instruction: 0x0c660a00
     c1c:	0a000000 	beq	c24 <shift+0xc24>
     c20:	00000677 	andeq	r0, r0, r7, ror r6
     c24:	119a0a01 	orrsne	r0, sl, r1, lsl #20
     c28:	0a020000 	beq	80c30 <__bss_end+0x77bf4>
     c2c:	00001194 	muleq	r0, r4, r1
     c30:	116f0a03 	cmnne	pc, r3, lsl #20
     c34:	0a040000 	beq	100c3c <__bss_end+0xf7c00>
     c38:	00001247 	andeq	r1, r0, r7, asr #4
     c3c:	11880a05 	orrne	r0, r8, r5, lsl #20
     c40:	0a060000 	beq	180c48 <__bss_end+0x177c0c>
     c44:	0000118e 	andeq	r1, r0, lr, lsl #3
     c48:	0e570a07 	vnmlseq.f32	s1, s14, s14
     c4c:	00080000 	andeq	r0, r8, r0
     c50:	000a0809 	andeq	r0, sl, r9, lsl #16
     c54:	38040500 	stmdacc	r4, {r8, sl}
     c58:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     c5c:	09b10c1d 	ldmibeq	r1!, {r0, r2, r3, r4, sl, fp}
     c60:	f40a0000 	vst4.8	{d0-d3}, [sl], r0
     c64:	0000000c 	andeq	r0, r0, ip
     c68:	000d6d0a 	andeq	r6, sp, sl, lsl #26
     c6c:	560a0100 	strpl	r0, [sl], -r0, lsl #2
     c70:	0200000d 	andeq	r0, r0, #13
     c74:	776f4c1b 			; <UNDEFINED> instruction: 0x776f4c1b
     c78:	0d000300 	stceq	3, cr0, [r0, #-0]
     c7c:	00001239 	andeq	r1, r0, r9, lsr r2
     c80:	0728091c 			; <UNDEFINED> instruction: 0x0728091c
     c84:	00000d32 	andeq	r0, r0, r2, lsr sp
     c88:	0003e307 	andeq	lr, r3, r7, lsl #6
     c8c:	33091000 	movwcc	r1, #36864	; 0x9000
     c90:	000a000a 	andeq	r0, sl, sl
     c94:	07840e00 	streq	r0, [r4, r0, lsl #28]
     c98:	35090000 	strcc	r0, [r9, #-0]
     c9c:	0003950b 	andeq	r9, r3, fp, lsl #10
     ca0:	180e0000 	stmdane	lr, {}	; <UNPREDICTABLE>
     ca4:	09000008 	stmdbeq	r0, {r3}
     ca8:	004d0d36 	subeq	r0, sp, r6, lsr sp
     cac:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     cb0:	000005e5 	andeq	r0, r0, r5, ror #11
     cb4:	37133709 	ldrcc	r3, [r3, -r9, lsl #14]
     cb8:	0800000d 	stmdaeq	r0, {r0, r2, r3}
     cbc:	0005240e 	andeq	r2, r5, lr, lsl #8
     cc0:	13380900 	teqne	r8, #0, 18
     cc4:	00000d37 	andeq	r0, r0, r7, lsr sp
     cc8:	2c0e000c 	stccs	0, cr0, [lr], {12}
     ccc:	09000008 	stmdbeq	r0, {r3}
     cd0:	0d43202c 	stcleq	0, cr2, [r3, #-176]	; 0xffffff50
     cd4:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     cd8:	00000fc2 	andeq	r0, r0, r2, asr #31
     cdc:	48412f09 	stmdami	r1, {r0, r3, r8, r9, sl, fp, sp}^
     ce0:	0400000d 	streq	r0, [r0], #-13
     ce4:	000a9e0e 	andeq	r9, sl, lr, lsl #28
     ce8:	42310900 	eorsmi	r0, r1, #0, 18
     cec:	00000d48 	andeq	r0, r0, r8, asr #26
     cf0:	0c030e0c 	stceq	14, cr0, [r3], {12}
     cf4:	3b090000 	blcc	240cfc <__bss_end+0x237cc0>
     cf8:	000d3712 	andeq	r3, sp, r2, lsl r7
     cfc:	9f0e1400 	svcls	0x000e1400
     d00:	09000009 	stmdbeq	r0, {r0, r3}
     d04:	01340e3d 	teqeq	r4, sp, lsr lr
     d08:	13180000 	tstne	r8, #0
     d0c:	00000f38 	andeq	r0, r0, r8, lsr pc
     d10:	41084109 	tstmi	r8, r9, lsl #2
     d14:	66000008 	strvs	r0, [r0], -r8
     d18:	02000003 	andeq	r0, r0, #3
     d1c:	00000a5a 	andeq	r0, r0, sl, asr sl
     d20:	00000a6f 	andeq	r0, r0, pc, ror #20
     d24:	000d5810 	andeq	r5, sp, r0, lsl r8
     d28:	004d1100 	subeq	r1, sp, r0, lsl #2
     d2c:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
     d30:	1100000d 	tstne	r0, sp
     d34:	00000d5e 	andeq	r0, r0, lr, asr sp
     d38:	08821300 	stmeq	r2, {r8, r9, ip}
     d3c:	43090000 	movwmi	r0, #36864	; 0x9000
     d40:	0011e608 	andseq	lr, r1, r8, lsl #12
     d44:	00036600 	andeq	r6, r3, r0, lsl #12
     d48:	0a880200 	beq	fe201550 <__bss_end+0xfe1f8514>
     d4c:	0a9d0000 	beq	fe740d54 <__bss_end+0xfe737d18>
     d50:	58100000 	ldmdapl	r0, {}	; <UNPREDICTABLE>
     d54:	1100000d 	tstne	r0, sp
     d58:	0000004d 	andeq	r0, r0, sp, asr #32
     d5c:	000d5e11 	andeq	r5, sp, r1, lsl lr
     d60:	0d5e1100 	ldfeqe	f1, [lr, #-0]
     d64:	13000000 	movwne	r0, #0
     d68:	00000ba0 	andeq	r0, r0, r0, lsr #23
     d6c:	70084509 	andvc	r4, r8, r9, lsl #10
     d70:	66000009 	strvs	r0, [r0], -r9
     d74:	02000003 	andeq	r0, r0, #3
     d78:	00000ab6 			; <UNDEFINED> instruction: 0x00000ab6
     d7c:	00000acb 	andeq	r0, r0, fp, asr #21
     d80:	000d5810 	andeq	r5, sp, r0, lsl r8
     d84:	004d1100 	subeq	r1, sp, r0, lsl #2
     d88:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
     d8c:	1100000d 	tstne	r0, sp
     d90:	00000d5e 	andeq	r0, r0, lr, asr sp
     d94:	0cd71300 	ldcleq	3, cr1, [r7], {0}
     d98:	47090000 	strmi	r0, [r9, -r0]
     d9c:	00047a08 	andeq	r7, r4, r8, lsl #20
     da0:	00036600 	andeq	r6, r3, r0, lsl #12
     da4:	0ae40200 	beq	ff9015ac <__bss_end+0xff8f8570>
     da8:	0af90000 	beq	ffe40db0 <__bss_end+0xffe37d74>
     dac:	58100000 	ldmdapl	r0, {}	; <UNPREDICTABLE>
     db0:	1100000d 	tstne	r0, sp
     db4:	0000004d 	andeq	r0, r0, sp, asr #32
     db8:	000d5e11 	andeq	r5, sp, r1, lsl lr
     dbc:	0d5e1100 	ldfeqe	f1, [lr, #-0]
     dc0:	13000000 	movwne	r0, #0
     dc4:	000008b8 			; <UNDEFINED> instruction: 0x000008b8
     dc8:	59084909 	stmdbpl	r8, {r0, r3, r8, fp, lr}
     dcc:	6600000a 	strvs	r0, [r0], -sl
     dd0:	02000003 	andeq	r0, r0, #3
     dd4:	00000b12 	andeq	r0, r0, r2, lsl fp
     dd8:	00000b27 	andeq	r0, r0, r7, lsr #22
     ddc:	000d5810 	andeq	r5, sp, r0, lsl r8
     de0:	004d1100 	subeq	r1, sp, r0, lsl #2
     de4:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
     de8:	1100000d 	tstne	r0, sp
     dec:	00000d5e 	andeq	r0, r0, lr, asr sp
     df0:	109d1300 	addsne	r1, sp, r0, lsl #6
     df4:	4b090000 	blmi	240dfc <__bss_end+0x237dc0>
     df8:	0005ea08 	andeq	lr, r5, r8, lsl #20
     dfc:	00036600 	andeq	r6, r3, r0, lsl #12
     e00:	0b400200 	bleq	1001608 <__bss_end+0xff85cc>
     e04:	0b5a0000 	bleq	1680e0c <__bss_end+0x1677dd0>
     e08:	58100000 	ldmdapl	r0, {}	; <UNPREDICTABLE>
     e0c:	1100000d 	tstne	r0, sp
     e10:	0000004d 	andeq	r0, r0, sp, asr #32
     e14:	00098611 	andeq	r8, r9, r1, lsl r6
     e18:	0d5e1100 	ldfeqe	f1, [lr, #-0]
     e1c:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
     e20:	0000000d 	andeq	r0, r0, sp
     e24:	000dd513 	andeq	sp, sp, r3, lsl r5
     e28:	0c4f0900 	mcrreq	9, 0, r0, pc, cr0	; <UNPREDICTABLE>
     e2c:	000009af 	andeq	r0, r0, pc, lsr #19
     e30:	0000004d 	andeq	r0, r0, sp, asr #32
     e34:	000b7302 	andeq	r7, fp, r2, lsl #6
     e38:	000b7900 	andeq	r7, fp, r0, lsl #18
     e3c:	0d581000 	ldcleq	0, cr1, [r8, #-0]
     e40:	14000000 	strne	r0, [r0], #-0
     e44:	00000a2b 	andeq	r0, r0, fp, lsr #20
     e48:	37085109 	strcc	r5, [r8, -r9, lsl #2]
     e4c:	02000010 	andeq	r0, r0, #16
     e50:	00000b8e 	andeq	r0, r0, lr, lsl #23
     e54:	00000b99 	muleq	r0, r9, fp
     e58:	000d6410 	andeq	r6, sp, r0, lsl r4
     e5c:	004d1100 	subeq	r1, sp, r0, lsl #2
     e60:	13000000 	movwne	r0, #0
     e64:	00001239 	andeq	r1, r0, r9, lsr r2
     e68:	b1035409 	tstlt	r3, r9, lsl #8
     e6c:	64000007 	strvs	r0, [r0], #-7
     e70:	0100000d 	tsteq	r0, sp
     e74:	00000bb2 			; <UNDEFINED> instruction: 0x00000bb2
     e78:	00000bbd 			; <UNDEFINED> instruction: 0x00000bbd
     e7c:	000d6410 	andeq	r6, sp, r0, lsl r4
     e80:	005e1100 	subseq	r1, lr, r0, lsl #2
     e84:	14000000 	strne	r0, [r0], #-0
     e88:	000008d2 	ldrdeq	r0, [r0], -r2
     e8c:	2a085709 	bcs	216ab8 <__bss_end+0x20da7c>
     e90:	0100000c 	tsteq	r0, ip
     e94:	00000bd2 	ldrdeq	r0, [r0], -r2
     e98:	00000be2 	andeq	r0, r0, r2, ror #23
     e9c:	000d6410 	andeq	r6, sp, r0, lsl r4
     ea0:	004d1100 	subeq	r1, sp, r0, lsl #2
     ea4:	3d110000 	ldccc	0, cr0, [r1, #-0]
     ea8:	00000009 	andeq	r0, r0, r9
     eac:	000b1f13 	andeq	r1, fp, r3, lsl pc
     eb0:	12590900 	subsne	r0, r9, #0, 18
     eb4:	00000f4c 	andeq	r0, r0, ip, asr #30
     eb8:	0000093d 	andeq	r0, r0, sp, lsr r9
     ebc:	000bfb01 	andeq	pc, fp, r1, lsl #22
     ec0:	000c0600 	andeq	r0, ip, r0, lsl #12
     ec4:	0d581000 	ldcleq	0, cr1, [r8, #-0]
     ec8:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     ecc:	00000000 	andeq	r0, r0, r0
     ed0:	00067314 	andeq	r7, r6, r4, lsl r3
     ed4:	085c0900 	ldmdaeq	ip, {r8, fp}^
     ed8:	00000736 	andeq	r0, r0, r6, lsr r7
     edc:	000c1b01 	andeq	r1, ip, r1, lsl #22
     ee0:	000c2b00 	andeq	r2, ip, r0, lsl #22
     ee4:	0d641000 	stcleq	0, cr1, [r4, #-0]
     ee8:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     eec:	11000000 	mrsne	r0, (UNDEF: 0)
     ef0:	00000366 	andeq	r0, r0, r6, ror #6
     ef4:	0c621300 	stcleq	3, cr1, [r2], #-0
     ef8:	5f090000 	svcpl	0x00090000
     efc:	00071708 	andeq	r1, r7, r8, lsl #14
     f00:	00036600 	andeq	r6, r3, r0, lsl #12
     f04:	0c440100 	stfeqe	f0, [r4], {-0}
     f08:	0c4f0000 	mareq	acc0, r0, pc
     f0c:	64100000 	ldrvs	r0, [r0], #-0
     f10:	1100000d 	tstne	r0, sp
     f14:	0000004d 	andeq	r0, r0, sp, asr #32
     f18:	0d4a1300 	stcleq	3, cr1, [sl, #-0]
     f1c:	62090000 	andvs	r0, r9, #0
     f20:	0004a908 	andeq	sl, r4, r8, lsl #18
     f24:	00036600 	andeq	r6, r3, r0, lsl #12
     f28:	0c680100 	stfeqe	f0, [r8], #-0
     f2c:	0c7d0000 	ldcleq	0, cr0, [sp], #-0
     f30:	64100000 	ldrvs	r0, [r0], #-0
     f34:	1100000d 	tstne	r0, sp
     f38:	0000004d 	andeq	r0, r0, sp, asr #32
     f3c:	00036611 	andeq	r6, r3, r1, lsl r6
     f40:	03661100 	cmneq	r6, #0, 2
     f44:	13000000 	movwne	r0, #0
     f48:	00000e3d 	andeq	r0, r0, sp, lsr lr
     f4c:	63086409 	movwvs	r6, #33801	; 0x8409
     f50:	6600000e 	strvs	r0, [r0], -lr
     f54:	01000003 	tsteq	r0, r3
     f58:	00000c96 	muleq	r0, r6, ip
     f5c:	00000cab 	andeq	r0, r0, fp, lsr #25
     f60:	000d6410 	andeq	r6, sp, r0, lsl r4
     f64:	004d1100 	subeq	r1, sp, r0, lsl #2
     f68:	66110000 	ldrvs	r0, [r1], -r0
     f6c:	11000003 	tstne	r0, r3
     f70:	00000366 	andeq	r0, r0, r6, ror #6
     f74:	131a1400 	tstne	sl, #0, 8
     f78:	67090000 	strvs	r0, [r9, -r0]
     f7c:	0009dd08 	andeq	sp, r9, r8, lsl #26
     f80:	0cc00100 	stfeqe	f0, [r0], {0}
     f84:	0cd00000 	ldcleq	0, cr0, [r0], {0}
     f88:	64100000 	ldrvs	r0, [r0], #-0
     f8c:	1100000d 	tstne	r0, sp
     f90:	0000004d 	andeq	r0, r0, sp, asr #32
     f94:	00098611 	andeq	r8, r9, r1, lsl r6
     f98:	56140000 	ldrpl	r0, [r4], -r0
     f9c:	09000012 	stmdbeq	r0, {r1, r4}
     fa0:	0f810869 	svceq	0x00810869
     fa4:	e5010000 	str	r0, [r1, #-0]
     fa8:	f500000c 			; <UNDEFINED> instruction: 0xf500000c
     fac:	1000000c 	andne	r0, r0, ip
     fb0:	00000d64 	andeq	r0, r0, r4, ror #26
     fb4:	00004d11 	andeq	r4, r0, r1, lsl sp
     fb8:	09861100 	stmibeq	r6, {r8, ip}
     fbc:	14000000 	strne	r0, [r0], #-0
     fc0:	00000a40 	andeq	r0, r0, r0, asr #20
     fc4:	17086c09 	strne	r6, [r8, -r9, lsl #24]
     fc8:	01000011 	tsteq	r0, r1, lsl r0
     fcc:	00000d0a 	andeq	r0, r0, sl, lsl #26
     fd0:	00000d10 	andeq	r0, r0, r0, lsl sp
     fd4:	000d6410 	andeq	r6, sp, r0, lsl r4
     fd8:	10270000 	eorne	r0, r7, r0
     fdc:	0900000b 	stmdbeq	r0, {r0, r1, r3}
     fe0:	10b8086f 	adcsne	r0, r8, pc, ror #16
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
    1034:	0008b21a 	andeq	fp, r8, sl, lsl r2
    1038:	16730900 	ldrbtne	r0, [r3], -r0, lsl #18
    103c:	000009b1 			; <UNDEFINED> instruction: 0x000009b1
    1040:	0012b00b 	andseq	fp, r2, fp
    1044:	14100100 	ldrne	r0, [r0], #-256	; 0xffffff00
    1048:	00000059 	andeq	r0, r0, r9, asr r0
    104c:	8fa40305 	svchi	0x00a40305
    1050:	c80b0000 	stmdagt	fp, {}	; <UNPREDICTABLE>
    1054:	01000007 	tsteq	r0, r7
    1058:	00591411 	subseq	r1, r9, r1, lsl r4
    105c:	03050000 	movweq	r0, #20480	; 0x5000
    1060:	00008fa8 	andeq	r8, r0, r8, lsr #31
    1064:	00053528 	andeq	r3, r5, r8, lsr #10
    1068:	0a130100 	beq	4c1470 <__bss_end+0x4b8434>
    106c:	0000004d 	andeq	r0, r0, sp, asr #32
    1070:	90240305 	eorls	r0, r4, r5, lsl #6
    1074:	cb280000 	blgt	a0107c <__bss_end+0x9f8040>
    1078:	01000008 	tsteq	r0, r8
    107c:	004d0a14 	subeq	r0, sp, r4, lsl sl
    1080:	03050000 	movweq	r0, #20480	; 0x5000
    1084:	00009028 	andeq	r9, r0, r8, lsr #32
    1088:	00122829 	andseq	r2, r2, r9, lsr #16
    108c:	051d0100 	ldreq	r0, [sp, #-256]	; 0xffffff00
    1090:	00000038 	andeq	r0, r0, r8, lsr r0
    1094:	000082b4 			; <UNDEFINED> instruction: 0x000082b4
    1098:	0000016c 	andeq	r0, r0, ip, ror #2
    109c:	0e159c01 	cdpeq	12, 1, cr9, cr5, cr1, {0}
    10a0:	002a0000 	eoreq	r0, sl, r0
    10a4:	0100000d 	tsteq	r0, sp
    10a8:	00380e1d 	eorseq	r0, r8, sp, lsl lr
    10ac:	91020000 	mrsls	r0, (UNDEF: 2)
    10b0:	09292a6c 	stmdbeq	r9!, {r2, r3, r5, r6, r9, fp, sp}
    10b4:	1d010000 	stcne	0, cr0, [r1, #-0]
    10b8:	000e151b 	andeq	r1, lr, fp, lsl r5
    10bc:	68910200 	ldmvs	r1, {r9}
    10c0:	000e1e2b 	andeq	r1, lr, fp, lsr #28
    10c4:	17220100 	strne	r0, [r2, -r0, lsl #2]!
    10c8:	00000986 	andeq	r0, r0, r6, lsl #19
    10cc:	2b709102 	blcs	1c254dc <__bss_end+0x1c1c4a0>
    10d0:	00000ec3 	andeq	r0, r0, r3, asr #29
    10d4:	4d0b2501 	cfstr32mi	mvfx2, [fp, #-4]
    10d8:	02000000 	andeq	r0, r0, #0
    10dc:	18007491 	stmdane	r0, {r0, r4, r7, sl, ip, sp, lr}
    10e0:	000e1b04 	andeq	r1, lr, r4, lsl #22
    10e4:	25041800 	strcs	r1, [r4, #-2048]	; 0xfffff800
    10e8:	2c000000 	stccs	0, cr0, [r0], {-0}
    10ec:	00000699 	muleq	r0, r9, r6
    10f0:	6c061601 	stcvs	6, cr1, [r6], {1}
    10f4:	3400000c 	strcc	r0, [r0], #-12
    10f8:	80000082 	andhi	r0, r0, r2, lsl #1
    10fc:	01000000 	mrseq	r0, (UNDEF: 0)
    1100:	06932a9c 			; <UNDEFINED> instruction: 0x06932a9c
    1104:	16010000 	strne	r0, [r1], -r0
    1108:	00036611 	andeq	r6, r3, r1, lsl r6
    110c:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    1110:	0cd70000 	ldcleq	0, cr0, [r7], {0}
    1114:	00040000 	andeq	r0, r4, r0
    1118:	00000479 	andeq	r0, r0, r9, ror r4
    111c:	13410104 	movtne	r0, #4356	; 0x1104
    1120:	7d040000 	stcvc	0, cr0, [r4, #-0]
    1124:	34000014 	strcc	r0, [r0], #-20	; 0xffffffec
    1128:	20000015 	andcs	r0, r0, r5, lsl r0
    112c:	60000084 	andvs	r0, r0, r4, lsl #1
    1130:	c5000004 	strgt	r0, [r0, #-4]
    1134:	02000004 	andeq	r0, r0, #4
    1138:	10840801 	addne	r0, r4, r1, lsl #16
    113c:	25030000 	strcs	r0, [r3, #-0]
    1140:	02000000 	andeq	r0, r0, #0
    1144:	0e140502 	cfmul32eq	mvfx0, mvfx4, mvfx2
    1148:	04040000 	streq	r0, [r4], #-0
    114c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1150:	08010200 	stmdaeq	r1, {r9}
    1154:	0000107b 	andeq	r1, r0, fp, ror r0
    1158:	15070202 	strne	r0, [r7, #-514]	; 0xfffffdfe
    115c:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    1160:	0000070e 	andeq	r0, r0, lr, lsl #14
    1164:	5e1e0907 	vnmlspl.f16	s0, s28, s14	; <UNPREDICTABLE>
    1168:	03000000 	movweq	r0, #0
    116c:	0000004d 	andeq	r0, r0, sp, asr #32
    1170:	01070402 	tsteq	r7, r2, lsl #8
    1174:	0600001d 			; <UNDEFINED> instruction: 0x0600001d
    1178:	0000130e 	andeq	r1, r0, lr, lsl #6
    117c:	08060208 	stmdaeq	r6, {r3, r9}
    1180:	0000008b 	andeq	r0, r0, fp, lsl #1
    1184:	00307207 	eorseq	r7, r0, r7, lsl #4
    1188:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
    118c:	00000000 	andeq	r0, r0, r0
    1190:	00317207 	eorseq	r7, r1, r7, lsl #4
    1194:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
    1198:	04000000 	streq	r0, [r0], #-0
    119c:	16530800 	ldrbne	r0, [r3], -r0, lsl #16
    11a0:	04050000 	streq	r0, [r5], #-0
    11a4:	00000038 	andeq	r0, r0, r8, lsr r0
    11a8:	a90c0d02 	stmdbge	ip, {r1, r8, sl, fp}
    11ac:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    11b0:	00004b4f 	andeq	r4, r0, pc, asr #22
    11b4:	0014bd0a 	andseq	fp, r4, sl, lsl #26
    11b8:	08000100 	stmdaeq	r0, {r8}
    11bc:	00000ecb 	andeq	r0, r0, fp, asr #29
    11c0:	00380405 	eorseq	r0, r8, r5, lsl #8
    11c4:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
    11c8:	0000e00c 	andeq	lr, r0, ip
    11cc:	07060a00 	streq	r0, [r6, -r0, lsl #20]
    11d0:	0a000000 	beq	11d8 <shift+0x11d8>
    11d4:	00000934 	andeq	r0, r0, r4, lsr r9
    11d8:	0eed0a01 	vfmaeq.f32	s1, s26, s2
    11dc:	0a020000 	beq	811e4 <__bss_end+0x781a8>
    11e0:	00001097 	muleq	r0, r7, r0
    11e4:	091a0a03 	ldmdbeq	sl, {r0, r1, r9, fp}
    11e8:	0a040000 	beq	1011f0 <__bss_end+0xf81b4>
    11ec:	00000dec 	andeq	r0, r0, ip, ror #27
    11f0:	ab080005 	blge	20120c <__bss_end+0x1f81d0>
    11f4:	0500000e 	streq	r0, [r0, #-14]
    11f8:	00003804 	andeq	r3, r0, r4, lsl #16
    11fc:	0c3f0200 	lfmeq	f0, 4, [pc], #-0	; 1204 <shift+0x1204>
    1200:	0000011d 	andeq	r0, r0, sp, lsl r1
    1204:	0008710a 	andeq	r7, r8, sl, lsl #2
    1208:	d40a0000 	strle	r0, [sl], #-0
    120c:	0100000f 	tsteq	r0, pc
    1210:	0012950a 	andseq	r9, r2, sl, lsl #10
    1214:	ab0a0200 	blge	281a1c <__bss_end+0x2789e0>
    1218:	0300000c 	movweq	r0, #12
    121c:	00092e0a 	andeq	r2, r9, sl, lsl #28
    1220:	1d0a0400 	cfstrsne	mvf0, [sl, #-0]
    1224:	0500000a 	streq	r0, [r0, #-10]
    1228:	0007730a 	andeq	r7, r7, sl, lsl #6
    122c:	08000600 	stmdaeq	r0, {r9, sl}
    1230:	00000758 	andeq	r0, r0, r8, asr r7
    1234:	00380405 	eorseq	r0, r8, r5, lsl #8
    1238:	66020000 	strvs	r0, [r2], -r0
    123c:	0001480c 	andeq	r4, r1, ip, lsl #16
    1240:	10700a00 	rsbsne	r0, r0, r0, lsl #20
    1244:	0a000000 	beq	124c <shift+0x124c>
    1248:	000005da 	ldrdeq	r0, [r0], -sl
    124c:	0f110a01 	svceq	0x00110a01
    1250:	0a020000 	beq	81258 <__bss_end+0x7821c>
    1254:	00000dfc 	strdeq	r0, [r0], -ip
    1258:	120b0003 	andne	r0, fp, #3
    125c:	0300000c 	movweq	r0, #12
    1260:	00591405 	subseq	r1, r9, r5, lsl #8
    1264:	03050000 	movweq	r0, #20480	; 0x5000
    1268:	00008fd8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    126c:	000fd90b 	andeq	sp, pc, fp, lsl #18
    1270:	14060300 	strne	r0, [r6], #-768	; 0xfffffd00
    1274:	00000059 	andeq	r0, r0, r9, asr r0
    1278:	8fdc0305 	svchi	0x00dc0305
    127c:	880b0000 	stmdahi	fp, {}	; <UNPREDICTABLE>
    1280:	0400000a 	streq	r0, [r0], #-10
    1284:	00591a07 	subseq	r1, r9, r7, lsl #20
    1288:	03050000 	movweq	r0, #20480	; 0x5000
    128c:	00008fe0 	andeq	r8, r0, r0, ror #31
    1290:	000e250b 	andeq	r2, lr, fp, lsl #10
    1294:	1a090400 	bne	24229c <__bss_end+0x239260>
    1298:	00000059 	andeq	r0, r0, r9, asr r0
    129c:	8fe40305 	svchi	0x00e40305
    12a0:	4b0b0000 	blmi	2c12a8 <__bss_end+0x2b826c>
    12a4:	0400000a 	streq	r0, [r0], #-10
    12a8:	00591a0b 	subseq	r1, r9, fp, lsl #20
    12ac:	03050000 	movweq	r0, #20480	; 0x5000
    12b0:	00008fe8 	andeq	r8, r0, r8, ror #31
    12b4:	000db70b 	andeq	fp, sp, fp, lsl #14
    12b8:	1a0d0400 	bne	3422c0 <__bss_end+0x339284>
    12bc:	00000059 	andeq	r0, r0, r9, asr r0
    12c0:	8fec0305 	svchi	0x00ec0305
    12c4:	e60b0000 	str	r0, [fp], -r0
    12c8:	04000006 	streq	r0, [r0], #-6
    12cc:	00591a0f 	subseq	r1, r9, pc, lsl #20
    12d0:	03050000 	movweq	r0, #20480	; 0x5000
    12d4:	00008ff0 	strdeq	r8, [r0], -r0
    12d8:	000c9108 	andeq	r9, ip, r8, lsl #2
    12dc:	38040500 	stmdacc	r4, {r8, sl}
    12e0:	04000000 	streq	r0, [r0], #-0
    12e4:	01eb0c1b 	mvneq	r0, fp, lsl ip
    12e8:	890a0000 	stmdbhi	sl, {}	; <UNPREDICTABLE>
    12ec:	00000006 	andeq	r0, r0, r6
    12f0:	0011030a 	andseq	r0, r1, sl, lsl #6
    12f4:	900a0100 	andls	r0, sl, r0, lsl #2
    12f8:	02000012 	andeq	r0, r0, #18
    12fc:	04610c00 	strbteq	r0, [r1], #-3072	; 0xfffff400
    1300:	290d0000 	stmdbcs	sp, {}	; <UNPREDICTABLE>
    1304:	90000005 	andls	r0, r0, r5
    1308:	5e076304 	cdppl	3, 0, cr6, cr7, cr4, {0}
    130c:	06000003 	streq	r0, [r0], -r3
    1310:	00000665 	andeq	r0, r0, r5, ror #12
    1314:	10670424 	rsbne	r0, r7, r4, lsr #8
    1318:	00000278 	andeq	r0, r0, r8, ror r2
    131c:	0020e90e 	eoreq	lr, r0, lr, lsl #18
    1320:	28690400 	stmdacs	r9!, {sl}^
    1324:	0000035e 	andeq	r0, r0, lr, asr r3
    1328:	08760e00 	ldmdaeq	r6!, {r9, sl, fp}^
    132c:	6b040000 	blvs	101334 <__bss_end+0xf82f8>
    1330:	00036e20 	andeq	r6, r3, r0, lsr #28
    1334:	7e0e1000 	cdpvc	0, 0, cr1, cr14, cr0, {0}
    1338:	04000006 	streq	r0, [r0], #-6
    133c:	004d236d 	subeq	r2, sp, sp, ror #6
    1340:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
    1344:	00000df5 	strdeq	r0, [r0], -r5
    1348:	751c7004 	ldrvc	r7, [ip, #-4]
    134c:	18000003 	stmdane	r0, {r0, r1}
    1350:	00124d0e 	andseq	r4, r2, lr, lsl #26
    1354:	1c720400 	cfldrdne	mvd0, [r2], #-0
    1358:	00000375 	andeq	r0, r0, r5, ror r3
    135c:	05240e1c 	streq	r0, [r4, #-3612]!	; 0xfffff1e4
    1360:	75040000 	strvc	r0, [r4, #-0]
    1364:	0003751c 	andeq	r7, r3, ip, lsl r5
    1368:	9a0f2000 	bls	3c9370 <__bss_end+0x3c0334>
    136c:	0400000e 	streq	r0, [r0], #-14
    1370:	11a01c77 	rorne	r1, r7, ip
    1374:	03750000 	cmneq	r5, #0
    1378:	026c0000 	rsbeq	r0, ip, #0
    137c:	75100000 	ldrvc	r0, [r0, #-0]
    1380:	11000003 	tstne	r0, r3
    1384:	0000037b 	andeq	r0, r0, fp, ror r3
    1388:	85060000 	strhi	r0, [r6, #-0]
    138c:	18000012 	stmdane	r0, {r1, r4}
    1390:	ad107b04 	vldrge	d7, [r0, #-16]
    1394:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
    1398:	000020e9 	andeq	r2, r0, r9, ror #1
    139c:	5e2c7e04 	cdppl	14, 2, cr7, cr12, cr4, {0}
    13a0:	00000003 	andeq	r0, r0, r3
    13a4:	0005860e 	andeq	r8, r5, lr, lsl #12
    13a8:	19800400 	stmibne	r0, {sl}
    13ac:	0000037b 	andeq	r0, r0, fp, ror r3
    13b0:	0a240e10 	beq	904bf8 <__bss_end+0x8fbbbc>
    13b4:	82040000 	andhi	r0, r4, #0
    13b8:	00038621 	andeq	r8, r3, r1, lsr #12
    13bc:	03001400 	movweq	r1, #1024	; 0x400
    13c0:	00000278 	andeq	r0, r0, r8, ror r2
    13c4:	0004d712 	andeq	sp, r4, r2, lsl r7
    13c8:	21860400 	orrcs	r0, r6, r0, lsl #8
    13cc:	0000038c 	andeq	r0, r0, ip, lsl #7
    13d0:	0008a012 	andeq	sl, r8, r2, lsl r0
    13d4:	1f880400 	svcne	0x00880400
    13d8:	00000059 	andeq	r0, r0, r9, asr r0
    13dc:	000e370e 	andeq	r3, lr, lr, lsl #14
    13e0:	178b0400 	strne	r0, [fp, r0, lsl #8]
    13e4:	000001fd 	strdeq	r0, [r0], -sp
    13e8:	07d80e00 	ldrbeq	r0, [r8, r0, lsl #28]
    13ec:	8e040000 	cdphi	0, 0, cr0, cr4, cr0, {0}
    13f0:	0001fd17 	andeq	pc, r1, r7, lsl sp	; <UNPREDICTABLE>
    13f4:	960e2400 	strls	r2, [lr], -r0, lsl #8
    13f8:	0400000b 	streq	r0, [r0], #-11
    13fc:	01fd178f 	mvnseq	r1, pc, lsl #15
    1400:	0e480000 	cdpeq	0, 4, cr0, cr8, cr0, {0}
    1404:	000009a5 	andeq	r0, r0, r5, lsr #19
    1408:	fd179004 	ldc2	0, cr9, [r7, #-16]
    140c:	6c000001 	stcvs	0, cr0, [r0], {1}
    1410:	00052913 	andeq	r2, r5, r3, lsl r9
    1414:	09930400 	ldmibeq	r3, {sl}
    1418:	00000d7a 	andeq	r0, r0, sl, ror sp
    141c:	00000397 	muleq	r0, r7, r3
    1420:	00031701 	andeq	r1, r3, r1, lsl #14
    1424:	00031d00 	andeq	r1, r3, r0, lsl #26
    1428:	03971000 	orrseq	r1, r7, #0
    142c:	14000000 	strne	r0, [r0], #-0
    1430:	00000e8f 	andeq	r0, r0, pc, lsl #29
    1434:	670e9604 	strvs	r9, [lr, -r4, lsl #12]
    1438:	01000005 	tsteq	r0, r5
    143c:	00000332 	andeq	r0, r0, r2, lsr r3
    1440:	00000338 	andeq	r0, r0, r8, lsr r3
    1444:	00039710 	andeq	r9, r3, r0, lsl r7
    1448:	71150000 	tstvc	r5, r0
    144c:	04000008 	streq	r0, [r0], #-8
    1450:	0c761099 	ldcleq	0, cr1, [r6], #-612	; 0xfffffd9c
    1454:	039d0000 	orrseq	r0, sp, #0
    1458:	4d010000 	stcmi	0, cr0, [r1, #-0]
    145c:	10000003 	andne	r0, r0, r3
    1460:	00000397 	muleq	r0, r7, r3
    1464:	00037b11 	andeq	r7, r3, r1, lsl fp
    1468:	01c61100 	biceq	r1, r6, r0, lsl #2
    146c:	00000000 	andeq	r0, r0, r0
    1470:	00002516 	andeq	r2, r0, r6, lsl r5
    1474:	00036e00 	andeq	r6, r3, r0, lsl #28
    1478:	005e1700 	subseq	r1, lr, r0, lsl #14
    147c:	000f0000 	andeq	r0, pc, r0
    1480:	31020102 	tstcc	r2, r2, lsl #2
    1484:	1800000b 	stmdane	r0, {r0, r1, r3}
    1488:	0001fd04 	andeq	pc, r1, r4, lsl #26
    148c:	2c041800 	stccs	8, cr1, [r4], {-0}
    1490:	0c000000 	stceq	0, cr0, [r0], {-0}
    1494:	00001175 	andeq	r1, r0, r5, ror r1
    1498:	03810418 	orreq	r0, r1, #24, 8	; 0x18000000
    149c:	ad160000 	ldcge	0, cr0, [r6, #-0]
    14a0:	97000002 	strls	r0, [r0, -r2]
    14a4:	19000003 	stmdbne	r0, {r0, r1}
    14a8:	f0041800 			; <UNDEFINED> instruction: 0xf0041800
    14ac:	18000001 	stmdane	r0, {r0}
    14b0:	0001eb04 	andeq	lr, r1, r4, lsl #22
    14b4:	0e831a00 	vdiveq.f32	s2, s6, s0
    14b8:	9c040000 	stcls	0, cr0, [r4], {-0}
    14bc:	0001f014 	andeq	pc, r1, r4, lsl r0	; <UNPREDICTABLE>
    14c0:	069f0b00 	ldreq	r0, [pc], r0, lsl #22
    14c4:	04050000 	streq	r0, [r5], #-0
    14c8:	00005914 	andeq	r5, r0, r4, lsl r9
    14cc:	f4030500 	vst3.8	{d0,d2,d4}, [r3], r0
    14d0:	0b00008f 	bleq	1714 <shift+0x1714>
    14d4:	00000ef3 	strdeq	r0, [r0], -r3
    14d8:	59140705 	ldmdbpl	r4, {r0, r2, r8, r9, sl}
    14dc:	05000000 	streq	r0, [r0, #-0]
    14e0:	008ff803 	addeq	pc, pc, r3, lsl #16
    14e4:	05540b00 	ldrbeq	r0, [r4, #-2816]	; 0xfffff500
    14e8:	0a050000 	beq	1414f0 <__bss_end+0x1384b4>
    14ec:	00005914 	andeq	r5, r0, r4, lsl r9
    14f0:	fc030500 	stc2	5, cr0, [r3], {-0}
    14f4:	0800008f 	stmdaeq	r0, {r0, r1, r2, r3, r7}
    14f8:	00000778 	andeq	r0, r0, r8, ror r7
    14fc:	00380405 	eorseq	r0, r8, r5, lsl #8
    1500:	0d050000 	stceq	0, cr0, [r5, #-0]
    1504:	00041c0c 	andeq	r1, r4, ip, lsl #24
    1508:	654e0900 	strbvs	r0, [lr, #-2304]	; 0xfffff700
    150c:	0a000077 	beq	16f0 <shift+0x16f0>
    1510:	0000093e 	andeq	r0, r0, lr, lsr r9
    1514:	054c0a01 	strbeq	r0, [ip, #-2561]	; 0xfffff5ff
    1518:	0a020000 	beq	81520 <__bss_end+0x784e4>
    151c:	00000796 	muleq	r0, r6, r7
    1520:	10890a03 	addne	r0, r9, r3, lsl #20
    1524:	0a040000 	beq	10152c <__bss_end+0xf84f0>
    1528:	0000051d 	andeq	r0, r0, sp, lsl r5
    152c:	b8060005 	stmdalt	r6, {r0, r2}
    1530:	10000006 	andne	r0, r0, r6
    1534:	5b081b05 	blpl	208150 <__bss_end+0x1ff114>
    1538:	07000004 	streq	r0, [r0, -r4]
    153c:	0500726c 	streq	r7, [r0, #-620]	; 0xfffffd94
    1540:	045b131d 	ldrbeq	r1, [fp], #-797	; 0xfffffce3
    1544:	07000000 	streq	r0, [r0, -r0]
    1548:	05007073 	streq	r7, [r0, #-115]	; 0xffffff8d
    154c:	045b131e 	ldrbeq	r1, [fp], #-798	; 0xfffffce2
    1550:	07040000 	streq	r0, [r4, -r0]
    1554:	05006370 	streq	r6, [r0, #-880]	; 0xfffffc90
    1558:	045b131f 	ldrbeq	r1, [fp], #-799	; 0xfffffce1
    155c:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
    1560:	00000ea5 	andeq	r0, r0, r5, lsr #29
    1564:	5b132005 	blpl	4c9580 <__bss_end+0x4c0544>
    1568:	0c000004 	stceq	0, cr0, [r0], {4}
    156c:	07040200 	streq	r0, [r4, -r0, lsl #4]
    1570:	00001cfc 	strdeq	r1, [r0], -ip
    1574:	00090d06 	andeq	r0, r9, r6, lsl #26
    1578:	28057000 	stmdacs	r5, {ip, sp, lr}
    157c:	0004f208 	andeq	pc, r4, r8, lsl #4
    1580:	08200e00 	stmdaeq	r0!, {r9, sl, fp}
    1584:	2a050000 	bcs	14158c <__bss_end+0x138550>
    1588:	00041c12 	andeq	r1, r4, r2, lsl ip
    158c:	70070000 	andvc	r0, r7, r0
    1590:	05006469 	streq	r6, [r0, #-1129]	; 0xfffffb97
    1594:	005e122b 	subseq	r1, lr, fp, lsr #4
    1598:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
    159c:	00001ada 	ldrdeq	r1, [r0], -sl
    15a0:	e5112c05 	ldr	r2, [r1, #-3077]	; 0xfffff3fb
    15a4:	14000003 	strne	r0, [r0], #-3
    15a8:	0010620e 	andseq	r6, r0, lr, lsl #4
    15ac:	122d0500 	eorne	r0, sp, #0, 10
    15b0:	0000005e 	andeq	r0, r0, lr, asr r0
    15b4:	03f10e18 	mvnseq	r0, #24, 28	; 0x180
    15b8:	2e050000 	cdpcs	0, 0, cr0, cr5, cr0, {0}
    15bc:	00005e12 	andeq	r5, r0, r2, lsl lr
    15c0:	e00e1c00 	and	r1, lr, r0, lsl #24
    15c4:	0500000e 	streq	r0, [r0, #-14]
    15c8:	04f2312f 	ldrbteq	r3, [r2], #303	; 0x12f
    15cc:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
    15d0:	000004cd 	andeq	r0, r0, sp, asr #9
    15d4:	38093005 	stmdacc	r9, {r0, r2, ip, sp}
    15d8:	60000000 	andvs	r0, r0, r0
    15dc:	000af00e 	andeq	pc, sl, lr
    15e0:	0e310500 	cfabs32eq	mvfx0, mvfx1
    15e4:	0000004d 	andeq	r0, r0, sp, asr #32
    15e8:	0d640e64 	stcleq	14, cr0, [r4, #-400]!	; 0xfffffe70
    15ec:	33050000 	movwcc	r0, #20480	; 0x5000
    15f0:	00004d0e 	andeq	r4, r0, lr, lsl #26
    15f4:	5b0e6800 	blpl	39b5fc <__bss_end+0x3925c0>
    15f8:	0500000d 	streq	r0, [r0, #-13]
    15fc:	004d0e34 	subeq	r0, sp, r4, lsr lr
    1600:	006c0000 	rsbeq	r0, ip, r0
    1604:	00039d16 	andeq	r9, r3, r6, lsl sp
    1608:	00050200 	andeq	r0, r5, r0, lsl #4
    160c:	005e1700 	subseq	r1, lr, r0, lsl #14
    1610:	000f0000 	andeq	r0, pc, r0
    1614:	00053d0b 	andeq	r3, r5, fp, lsl #26
    1618:	140a0600 	strne	r0, [sl], #-1536	; 0xfffffa00
    161c:	00000059 	andeq	r0, r0, r9, asr r0
    1620:	90000305 	andls	r0, r0, r5, lsl #6
    1624:	db080000 	blle	20162c <__bss_end+0x1f85f0>
    1628:	0500000a 	streq	r0, [r0, #-10]
    162c:	00003804 	andeq	r3, r0, r4, lsl #16
    1630:	0c0d0600 	stceq	6, cr0, [sp], {-0}
    1634:	00000533 	andeq	r0, r0, r3, lsr r5
    1638:	00129b0a 	andseq	r9, r2, sl, lsl #22
    163c:	380a0000 	stmdacc	sl, {}	; <UNPREDICTABLE>
    1640:	01000011 	tsteq	r0, r1, lsl r0
    1644:	05140300 	ldreq	r0, [r4, #-768]	; 0xfffffd00
    1648:	a6080000 	strge	r0, [r8], -r0
    164c:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    1650:	00003804 	andeq	r3, r0, r4, lsl #16
    1654:	0c140600 	ldceq	6, cr0, [r4], {-0}
    1658:	00000557 	andeq	r0, r0, r7, asr r5
    165c:	0013340a 	andseq	r3, r3, sl, lsl #8
    1660:	250a0000 	strcs	r0, [sl, #-0]
    1664:	01000016 	tsteq	r0, r6, lsl r0
    1668:	05380300 	ldreq	r0, [r8, #-768]!	; 0xfffffd00
    166c:	05060000 	streq	r0, [r6, #-0]
    1670:	0c000008 	stceq	0, cr0, [r0], {8}
    1674:	91081b06 	tstls	r8, r6, lsl #22
    1678:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
    167c:	000005e5 	andeq	r0, r0, r5, ror #11
    1680:	91191d06 	tstls	r9, r6, lsl #26
    1684:	00000005 	andeq	r0, r0, r5
    1688:	0005240e 	andeq	r2, r5, lr, lsl #8
    168c:	191e0600 	ldmdbne	lr, {r9, sl}
    1690:	00000591 	muleq	r0, r1, r5
    1694:	0b0b0e04 	bleq	2c4eac <__bss_end+0x2bbe70>
    1698:	1f060000 	svcne	0x00060000
    169c:	00059713 	andeq	r9, r5, r3, lsl r7
    16a0:	18000800 	stmdane	r0, {fp}
    16a4:	00055c04 	andeq	r5, r5, r4, lsl #24
    16a8:	62041800 	andvs	r1, r4, #0, 16
    16ac:	0d000004 	stceq	0, cr0, [r0, #-16]
    16b0:	00000e46 	andeq	r0, r0, r6, asr #28
    16b4:	07220614 			; <UNDEFINED> instruction: 0x07220614
    16b8:	0000081f 	andeq	r0, r0, pc, lsl r8
    16bc:	000c200e 	andeq	r2, ip, lr
    16c0:	12260600 	eorne	r0, r6, #0, 12
    16c4:	0000004d 	andeq	r0, r0, sp, asr #32
    16c8:	0bb30e00 	bleq	fecc4ed0 <__bss_end+0xfecbbe94>
    16cc:	29060000 	stmdbcs	r6, {}	; <UNPREDICTABLE>
    16d0:	0005911d 	andeq	r9, r5, sp, lsl r1
    16d4:	9e0e0400 	cfcpysls	mvf0, mvf14
    16d8:	06000007 	streq	r0, [r0], -r7
    16dc:	05911d2c 	ldreq	r1, [r1, #3372]	; 0xd2c
    16e0:	1b080000 	blne	2016e8 <__bss_end+0x1f86ac>
    16e4:	00000ca1 	andeq	r0, r0, r1, lsr #25
    16e8:	e20e2f06 	and	r2, lr, #6, 30
    16ec:	e5000007 	str	r0, [r0, #-7]
    16f0:	f0000005 			; <UNDEFINED> instruction: 0xf0000005
    16f4:	10000005 	andne	r0, r0, r5
    16f8:	00000824 	andeq	r0, r0, r4, lsr #16
    16fc:	00059111 	andeq	r9, r5, r1, lsl r1
    1700:	471c0000 	ldrmi	r0, [ip, -r0]
    1704:	06000009 	streq	r0, [r0], -r9
    1708:	08e40e31 	stmiaeq	r4!, {r0, r4, r5, r9, sl, fp}^
    170c:	036e0000 	cmneq	lr, #0
    1710:	06080000 	streq	r0, [r8], -r0
    1714:	06130000 	ldreq	r0, [r3], -r0
    1718:	24100000 	ldrcs	r0, [r0], #-0
    171c:	11000008 	tstne	r0, r8
    1720:	00000597 	muleq	r0, r7, r5
    1724:	10e41300 	rscne	r1, r4, r0, lsl #6
    1728:	35060000 	strcc	r0, [r6, #-0]
    172c:	000ab61d 	andeq	fp, sl, sp, lsl r6
    1730:	00059100 	andeq	r9, r5, r0, lsl #2
    1734:	062c0200 	strteq	r0, [ip], -r0, lsl #4
    1738:	06320000 	ldrteq	r0, [r2], -r0
    173c:	24100000 	ldrcs	r0, [r0], #-0
    1740:	00000008 	andeq	r0, r0, r8
    1744:	00078913 	andeq	r8, r7, r3, lsl r9
    1748:	1d370600 	ldcne	6, cr0, [r7, #-0]
    174c:	00000cb1 			; <UNDEFINED> instruction: 0x00000cb1
    1750:	00000591 	muleq	r0, r1, r5
    1754:	00064b02 	andeq	r4, r6, r2, lsl #22
    1758:	00065100 	andeq	r5, r6, r0, lsl #2
    175c:	08241000 	stmdaeq	r4!, {ip}
    1760:	1d000000 	stcne	0, cr0, [r0, #-0]
    1764:	00000bc6 	andeq	r0, r0, r6, asr #23
    1768:	3d443906 	vstrcc.16	s7, [r4, #-12]	; <UNPREDICTABLE>
    176c:	0c000008 	stceq	0, cr0, [r0], {8}
    1770:	0e461302 	cdpeq	3, 4, cr1, cr6, cr2, {0}
    1774:	3c060000 	stccc	0, cr0, [r6], {-0}
    1778:	00095609 	andeq	r5, r9, r9, lsl #12
    177c:	00082400 	andeq	r2, r8, r0, lsl #8
    1780:	06780100 	ldrbteq	r0, [r8], -r0, lsl #2
    1784:	067e0000 	ldrbteq	r0, [lr], -r0
    1788:	24100000 	ldrcs	r0, [r0], #-0
    178c:	00000008 	andeq	r0, r0, r8
    1790:	00083213 	andeq	r3, r8, r3, lsl r2
    1794:	123f0600 	eorsne	r0, pc, #0, 12
    1798:	000005af 	andeq	r0, r0, pc, lsr #11
    179c:	0000004d 	andeq	r0, r0, sp, asr #32
    17a0:	00069701 	andeq	r9, r6, r1, lsl #14
    17a4:	0006ac00 	andeq	sl, r6, r0, lsl #24
    17a8:	08241000 	stmdaeq	r4!, {ip}
    17ac:	46110000 	ldrmi	r0, [r1], -r0
    17b0:	11000008 	tstne	r0, r8
    17b4:	0000005e 	andeq	r0, r0, lr, asr r0
    17b8:	00036e11 	andeq	r6, r3, r1, lsl lr
    17bc:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
    17c0:	06000011 			; <UNDEFINED> instruction: 0x06000011
    17c4:	06c50e42 	strbeq	r0, [r5], r2, asr #28
    17c8:	c1010000 	mrsgt	r0, (UNDEF: 1)
    17cc:	c7000006 	strgt	r0, [r0, -r6]
    17d0:	10000006 	andne	r0, r0, r6
    17d4:	00000824 	andeq	r0, r0, r4, lsr #16
    17d8:	05911300 	ldreq	r1, [r1, #768]	; 0x300
    17dc:	45060000 	strmi	r0, [r6, #-0]
    17e0:	00063717 	andeq	r3, r6, r7, lsl r7
    17e4:	00059700 	andeq	r9, r5, r0, lsl #14
    17e8:	06e00100 	strbteq	r0, [r0], r0, lsl #2
    17ec:	06e60000 	strbteq	r0, [r6], r0
    17f0:	4c100000 	ldcmi	0, cr0, [r0], {-0}
    17f4:	00000008 	andeq	r0, r0, r8
    17f8:	000efe13 	andeq	pc, lr, r3, lsl lr	; <UNPREDICTABLE>
    17fc:	17480600 	strbne	r0, [r8, -r0, lsl #12]
    1800:	00000407 	andeq	r0, r0, r7, lsl #8
    1804:	00000597 	muleq	r0, r7, r5
    1808:	0006ff01 	andeq	pc, r6, r1, lsl #30
    180c:	00070a00 	andeq	r0, r7, r0, lsl #20
    1810:	084c1000 	stmdaeq	ip, {ip}^
    1814:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1818:	00000000 	andeq	r0, r0, r0
    181c:	0006f014 	andeq	pc, r6, r4, lsl r0	; <UNPREDICTABLE>
    1820:	0e4b0600 	cdpeq	6, 4, cr0, cr11, cr0, {0}
    1824:	00000bd4 	ldrdeq	r0, [r0], -r4
    1828:	00071f01 	andeq	r1, r7, r1, lsl #30
    182c:	00072500 	andeq	r2, r7, r0, lsl #10
    1830:	08241000 	stmdaeq	r4!, {ip}
    1834:	13000000 	movwne	r0, #0
    1838:	00000947 	andeq	r0, r0, r7, asr #18
    183c:	8f0e4d06 	svchi	0x000e4d06
    1840:	6e00000d 	cdpvs	0, 0, cr0, cr0, cr13, {0}
    1844:	01000003 	tsteq	r0, r3
    1848:	0000073e 	andeq	r0, r0, lr, lsr r7
    184c:	00000749 	andeq	r0, r0, r9, asr #14
    1850:	00082410 	andeq	r2, r8, r0, lsl r4
    1854:	004d1100 	subeq	r1, sp, r0, lsl #2
    1858:	13000000 	movwne	r0, #0
    185c:	00000509 	andeq	r0, r0, r9, lsl #10
    1860:	34125006 	ldrcc	r5, [r2], #-6
    1864:	4d000004 	stcmi	0, cr0, [r0, #-16]
    1868:	01000000 	mrseq	r0, (UNDEF: 0)
    186c:	00000762 	andeq	r0, r0, r2, ror #14
    1870:	0000076d 	andeq	r0, r0, sp, ror #14
    1874:	00082410 	andeq	r2, r8, r0, lsl r4
    1878:	039d1100 	orrseq	r1, sp, #0, 2
    187c:	13000000 	movwne	r0, #0
    1880:	00000467 	andeq	r0, r0, r7, ror #8
    1884:	430e5306 	movwmi	r5, #58118	; 0xe306
    1888:	6e000011 	mcrvs	0, 0, r0, cr0, cr1, {0}
    188c:	01000003 	tsteq	r0, r3
    1890:	00000786 	andeq	r0, r0, r6, lsl #15
    1894:	00000791 	muleq	r0, r1, r7
    1898:	00082410 	andeq	r2, r8, r0, lsl r4
    189c:	004d1100 	subeq	r1, sp, r0, lsl #2
    18a0:	14000000 	strne	r0, [r0], #-0
    18a4:	000004e3 	andeq	r0, r0, r3, ror #9
    18a8:	e50e5606 	str	r5, [lr, #-1542]	; 0xfffff9fa
    18ac:	0100000f 	tsteq	r0, pc
    18b0:	000007a6 	andeq	r0, r0, r6, lsr #15
    18b4:	000007c5 	andeq	r0, r0, r5, asr #15
    18b8:	00082410 	andeq	r2, r8, r0, lsl r4
    18bc:	00a91100 	adceq	r1, r9, r0, lsl #2
    18c0:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    18c4:	11000000 	mrsne	r0, (UNDEF: 0)
    18c8:	0000004d 	andeq	r0, r0, sp, asr #32
    18cc:	00004d11 	andeq	r4, r0, r1, lsl sp
    18d0:	08521100 	ldmdaeq	r2, {r8, ip}^
    18d4:	14000000 	strne	r0, [r0], #-0
    18d8:	000011d0 	ldrdeq	r1, [r0], -r0
    18dc:	c20e5806 	andgt	r5, lr, #393216	; 0x60000
    18e0:	01000012 	tsteq	r0, r2, lsl r0
    18e4:	000007da 	ldrdeq	r0, [r0], -sl
    18e8:	000007f9 	strdeq	r0, [r0], -r9
    18ec:	00082410 	andeq	r2, r8, r0, lsl r4
    18f0:	00e01100 	rsceq	r1, r0, r0, lsl #2
    18f4:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    18f8:	11000000 	mrsne	r0, (UNDEF: 0)
    18fc:	0000004d 	andeq	r0, r0, sp, asr #32
    1900:	00004d11 	andeq	r4, r0, r1, lsl sp
    1904:	08521100 	ldmdaeq	r2, {r8, ip}^
    1908:	15000000 	strne	r0, [r0, #-0]
    190c:	000004f6 	strdeq	r0, [r0], -r6
    1910:	360e5b06 	strcc	r5, [lr], -r6, lsl #22
    1914:	6e00000b 	cdpvs	0, 0, cr0, cr0, cr11, {0}
    1918:	01000003 	tsteq	r0, r3
    191c:	0000080e 	andeq	r0, r0, lr, lsl #16
    1920:	00082410 	andeq	r2, r8, r0, lsl r4
    1924:	05141100 	ldreq	r1, [r4, #-256]	; 0xffffff00
    1928:	58110000 	ldmdapl	r1, {}	; <UNPREDICTABLE>
    192c:	00000008 	andeq	r0, r0, r8
    1930:	059d0300 	ldreq	r0, [sp, #768]	; 0x300
    1934:	04180000 	ldreq	r0, [r8], #-0
    1938:	0000059d 	muleq	r0, sp, r5
    193c:	0005911e 	andeq	r9, r5, lr, lsl r1
    1940:	00083700 	andeq	r3, r8, r0, lsl #14
    1944:	00083d00 	andeq	r3, r8, r0, lsl #26
    1948:	08241000 	stmdaeq	r4!, {ip}
    194c:	1f000000 	svcne	0x00000000
    1950:	0000059d 	muleq	r0, sp, r5
    1954:	0000082a 	andeq	r0, r0, sl, lsr #16
    1958:	003f0418 	eorseq	r0, pc, r8, lsl r4	; <UNPREDICTABLE>
    195c:	04180000 	ldreq	r0, [r8], #-0
    1960:	0000081f 	andeq	r0, r0, pc, lsl r8
    1964:	00650420 	rsbeq	r0, r5, r0, lsr #8
    1968:	04210000 	strteq	r0, [r1], #-0
    196c:	00122d1a 	andseq	r2, r2, sl, lsl sp
    1970:	195e0600 	ldmdbne	lr, {r9, sl}^
    1974:	0000059d 	muleq	r0, sp, r5
    1978:	00002c16 	andeq	r2, r0, r6, lsl ip
    197c:	00087600 	andeq	r7, r8, r0, lsl #12
    1980:	005e1700 	subseq	r1, lr, r0, lsl #14
    1984:	00090000 	andeq	r0, r9, r0
    1988:	00086603 	andeq	r6, r8, r3, lsl #12
    198c:	15092200 	strne	r2, [r9, #-512]	; 0xfffffe00
    1990:	a4010000 	strge	r0, [r1], #-0
    1994:	0008760c 	andeq	r7, r8, ip, lsl #12
    1998:	04030500 	streq	r0, [r3], #-1280	; 0xfffffb00
    199c:	23000090 	movwcs	r0, #144	; 0x90
    19a0:	00000ec6 	andeq	r0, r0, r6, asr #29
    19a4:	9a0aa601 	bls	2ab1b0 <__bss_end+0x2a2174>
    19a8:	4d000015 	stcmi	0, cr0, [r0, #-84]	; 0xffffffac
    19ac:	cc000000 	stcgt	0, cr0, [r0], {-0}
    19b0:	b4000087 	strlt	r0, [r0], #-135	; 0xffffff79
    19b4:	01000000 	mrseq	r0, (UNDEF: 0)
    19b8:	0008eb9c 	muleq	r8, ip, fp
    19bc:	20e92400 	rsccs	r2, r9, r0, lsl #8
    19c0:	a6010000 	strge	r0, [r1], -r0
    19c4:	00037b1b 	andeq	r7, r3, fp, lsl fp
    19c8:	ac910300 	ldcge	3, cr0, [r1], {0}
    19cc:	15f9247f 	ldrbne	r2, [r9, #1151]!	; 0x47f
    19d0:	a6010000 	strge	r0, [r1], -r0
    19d4:	00004d2a 	andeq	r4, r0, sl, lsr #26
    19d8:	a8910300 	ldmge	r1, {r8, r9}
    19dc:	1582227f 	strne	r2, [r2, #639]	; 0x27f
    19e0:	a8010000 	stmdage	r1, {}	; <UNPREDICTABLE>
    19e4:	0008eb0a 	andeq	lr, r8, sl, lsl #22
    19e8:	b4910300 	ldrlt	r0, [r1], #768	; 0x300
    19ec:	142b227f 	strtne	r2, [fp], #-639	; 0xfffffd81
    19f0:	ac010000 	stcge	0, cr0, [r1], {-0}
    19f4:	00003809 	andeq	r3, r0, r9, lsl #16
    19f8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    19fc:	00251600 	eoreq	r1, r5, r0, lsl #12
    1a00:	08fb0000 	ldmeq	fp!, {}^	; <UNPREDICTABLE>
    1a04:	5e170000 	cdppl	0, 1, cr0, cr7, cr0, {0}
    1a08:	3f000000 	svccc	0x00000000
    1a0c:	15de2500 	ldrbne	r2, [lr, #1280]	; 0x500
    1a10:	98010000 	stmdals	r1, {}	; <UNPREDICTABLE>
    1a14:	0016330a 	andseq	r3, r6, sl, lsl #6
    1a18:	00004d00 	andeq	r4, r0, r0, lsl #26
    1a1c:	00879000 	addeq	r9, r7, r0
    1a20:	00003c00 	andeq	r3, r0, r0, lsl #24
    1a24:	389c0100 	ldmcc	ip, {r8}
    1a28:	26000009 	strcs	r0, [r0], -r9
    1a2c:	00716572 	rsbseq	r6, r1, r2, ror r5
    1a30:	57209a01 	strpl	r9, [r0, -r1, lsl #20]!
    1a34:	02000005 	andeq	r0, r0, #5
    1a38:	8f227491 	svchi	0x00227491
    1a3c:	01000015 	tsteq	r0, r5, lsl r0
    1a40:	004d0e9b 	umaaleq	r0, sp, fp, lr
    1a44:	91020000 	mrsls	r0, (UNDEF: 2)
    1a48:	08270070 	stmdaeq	r7!, {r4, r5, r6}
    1a4c:	01000016 	tsteq	r0, r6, lsl r0
    1a50:	1447068f 	strbne	r0, [r7], #-1679	; 0xfffff971
    1a54:	87540000 	ldrbhi	r0, [r4, -r0]
    1a58:	003c0000 	eorseq	r0, ip, r0
    1a5c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1a60:	00000971 	andeq	r0, r0, r1, ror r9
    1a64:	0014f524 	andseq	pc, r4, r4, lsr #10
    1a68:	218f0100 	orrcs	r0, pc, r0, lsl #2
    1a6c:	0000004d 	andeq	r0, r0, sp, asr #32
    1a70:	266c9102 	strbtcs	r9, [ip], -r2, lsl #2
    1a74:	00716572 	rsbseq	r6, r1, r2, ror r5
    1a78:	57209101 	strpl	r9, [r0, -r1, lsl #2]!
    1a7c:	02000005 	andeq	r0, r0, #5
    1a80:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1a84:	000015bb 			; <UNDEFINED> instruction: 0x000015bb
    1a88:	1a0a8301 	bne	2a2694 <__bss_end+0x299658>
    1a8c:	4d000015 	stcmi	0, cr0, [r0, #-84]	; 0xffffffac
    1a90:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    1a94:	3c000087 	stccc	0, cr0, [r0], {135}	; 0x87
    1a98:	01000000 	mrseq	r0, (UNDEF: 0)
    1a9c:	0009ae9c 	muleq	r9, ip, lr
    1aa0:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1aa4:	85010071 	strhi	r0, [r1, #-113]	; 0xffffff8f
    1aa8:	00053320 	andeq	r3, r5, r0, lsr #6
    1aac:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1ab0:	00142422 	andseq	r2, r4, r2, lsr #8
    1ab4:	0e860100 	rmfeqs	f0, f6, f0
    1ab8:	0000004d 	andeq	r0, r0, sp, asr #32
    1abc:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1ac0:	0016ca25 	andseq	ip, r6, r5, lsr #20
    1ac4:	0a770100 	beq	1dc1ecc <__bss_end+0x1db8e90>
    1ac8:	000014cb 	andeq	r1, r0, fp, asr #9
    1acc:	0000004d 	andeq	r0, r0, sp, asr #32
    1ad0:	000086dc 	ldrdeq	r8, [r0], -ip
    1ad4:	0000003c 	andeq	r0, r0, ip, lsr r0
    1ad8:	09eb9c01 	stmibeq	fp!, {r0, sl, fp, ip, pc}^
    1adc:	72260000 	eorvc	r0, r6, #0
    1ae0:	01007165 	tsteq	r0, r5, ror #2
    1ae4:	05332079 	ldreq	r2, [r3, #-121]!	; 0xffffff87
    1ae8:	91020000 	mrsls	r0, (UNDEF: 2)
    1aec:	14242274 	strtne	r2, [r4], #-628	; 0xfffffd8c
    1af0:	7a010000 	bvc	41af8 <__bss_end+0x38abc>
    1af4:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1af8:	70910200 	addsvc	r0, r1, r0, lsl #4
    1afc:	152e2500 	strne	r2, [lr, #-1280]!	; 0xfffffb00
    1b00:	6b010000 	blvs	41b08 <__bss_end+0x38acc>
    1b04:	00161a06 	andseq	r1, r6, r6, lsl #20
    1b08:	00036e00 	andeq	r6, r3, r0, lsl #28
    1b0c:	00868800 	addeq	r8, r6, r0, lsl #16
    1b10:	00005400 	andeq	r5, r0, r0, lsl #8
    1b14:	379c0100 	ldrcc	r0, [ip, r0, lsl #2]
    1b18:	2400000a 	strcs	r0, [r0], #-10
    1b1c:	0000158f 	andeq	r1, r0, pc, lsl #11
    1b20:	4d156b01 	vldrmi	d6, [r5, #-4]
    1b24:	02000000 	andeq	r0, r0, #0
    1b28:	5b246c91 	blpl	91cd74 <__bss_end+0x913d38>
    1b2c:	0100000d 	tsteq	r0, sp
    1b30:	004d256b 	subeq	r2, sp, fp, ror #10
    1b34:	91020000 	mrsls	r0, (UNDEF: 2)
    1b38:	16c22268 	strbne	r2, [r2], r8, ror #4
    1b3c:	6d010000 	stcvs	0, cr0, [r1, #-0]
    1b40:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1b44:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1b48:	145e2500 	ldrbne	r2, [lr], #-1280	; 0xfffffb00
    1b4c:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1b50:	00166a12 	andseq	r6, r6, r2, lsl sl
    1b54:	00008b00 	andeq	r8, r0, r0, lsl #22
    1b58:	00863800 	addeq	r3, r6, r0, lsl #16
    1b5c:	00005000 	andeq	r5, r0, r0
    1b60:	929c0100 	addsls	r0, ip, #0, 2
    1b64:	2400000a 	strcs	r0, [r0], #-10
    1b68:	00000784 	andeq	r0, r0, r4, lsl #15
    1b6c:	4d205e01 	stcmi	14, cr5, [r0, #-4]!
    1b70:	02000000 	andeq	r0, r0, #0
    1b74:	c4246c91 	strtgt	r6, [r4], #-3217	; 0xfffff36f
    1b78:	01000015 	tsteq	r0, r5, lsl r0
    1b7c:	004d2f5e 	subeq	r2, sp, lr, asr pc
    1b80:	91020000 	mrsls	r0, (UNDEF: 2)
    1b84:	0d5b2468 	cfldrdeq	mvd2, [fp, #-416]	; 0xfffffe60
    1b88:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1b8c:	00004d3f 	andeq	r4, r0, pc, lsr sp
    1b90:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1b94:	0016c222 	andseq	ip, r6, r2, lsr #4
    1b98:	16600100 	strbtne	r0, [r0], -r0, lsl #2
    1b9c:	0000008b 	andeq	r0, r0, fp, lsl #1
    1ba0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1ba4:	00158825 	andseq	r8, r5, r5, lsr #16
    1ba8:	0a520100 	beq	1481fb0 <__bss_end+0x1478f74>
    1bac:	00001463 	andeq	r1, r0, r3, ror #8
    1bb0:	0000004d 	andeq	r0, r0, sp, asr #32
    1bb4:	000085f4 	strdeq	r8, [r0], -r4
    1bb8:	00000044 	andeq	r0, r0, r4, asr #32
    1bbc:	0ade9c01 	beq	ff7a8bc8 <__bss_end+0xff79fb8c>
    1bc0:	84240000 	strthi	r0, [r4], #-0
    1bc4:	01000007 	tsteq	r0, r7
    1bc8:	004d1a52 	subeq	r1, sp, r2, asr sl
    1bcc:	91020000 	mrsls	r0, (UNDEF: 2)
    1bd0:	15c4246c 	strbne	r2, [r4, #1132]	; 0x46c
    1bd4:	52010000 	andpl	r0, r1, #0
    1bd8:	00004d29 	andeq	r4, r0, r9, lsr #26
    1bdc:	68910200 	ldmvs	r1, {r9}
    1be0:	00169922 	andseq	r9, r6, r2, lsr #18
    1be4:	0e540100 	rdfeqs	f0, f4, f0
    1be8:	0000004d 	andeq	r0, r0, sp, asr #32
    1bec:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1bf0:	00169325 	andseq	r9, r6, r5, lsr #6
    1bf4:	0a450100 	beq	1141ffc <__bss_end+0x1138fc0>
    1bf8:	00001675 	andeq	r1, r0, r5, ror r6
    1bfc:	0000004d 	andeq	r0, r0, sp, asr #32
    1c00:	000085a4 	andeq	r8, r0, r4, lsr #11
    1c04:	00000050 	andeq	r0, r0, r0, asr r0
    1c08:	0b399c01 	bleq	e68c14 <__bss_end+0xe5fbd8>
    1c0c:	84240000 	strthi	r0, [r4], #-0
    1c10:	01000007 	tsteq	r0, r7
    1c14:	004d1945 	subeq	r1, sp, r5, asr #18
    1c18:	91020000 	mrsls	r0, (UNDEF: 2)
    1c1c:	1563246c 	strbne	r2, [r3, #-1132]!	; 0xfffffb94
    1c20:	45010000 	strmi	r0, [r1, #-0]
    1c24:	00011d30 	andeq	r1, r1, r0, lsr sp
    1c28:	68910200 	ldmvs	r1, {r9}
    1c2c:	0015ca24 	andseq	ip, r5, r4, lsr #20
    1c30:	41450100 	mrsmi	r0, (UNDEF: 85)
    1c34:	00000858 	andeq	r0, r0, r8, asr r8
    1c38:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1c3c:	000016c2 	andeq	r1, r0, r2, asr #13
    1c40:	4d0e4701 	stcmi	7, cr4, [lr, #-4]
    1c44:	02000000 	andeq	r0, r0, #0
    1c48:	27007491 			; <UNDEFINED> instruction: 0x27007491
    1c4c:	0000132e 	andeq	r1, r0, lr, lsr #6
    1c50:	6d063f01 	stcvs	15, cr3, [r6, #-4]
    1c54:	78000015 	stmdavc	r0, {r0, r2, r4}
    1c58:	2c000085 	stccs	0, cr0, [r0], {133}	; 0x85
    1c5c:	01000000 	mrseq	r0, (UNDEF: 0)
    1c60:	000b639c 	muleq	fp, ip, r3
    1c64:	07842400 	streq	r2, [r4, r0, lsl #8]
    1c68:	3f010000 	svccc	0x00010000
    1c6c:	00004d15 	andeq	r4, r0, r5, lsl sp
    1c70:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1c74:	16022500 	strne	r2, [r2], -r0, lsl #10
    1c78:	32010000 	andcc	r0, r1, #0
    1c7c:	0015d00a 	andseq	sp, r5, sl
    1c80:	00004d00 	andeq	r4, r0, r0, lsl #26
    1c84:	00852800 	addeq	r2, r5, r0, lsl #16
    1c88:	00005000 	andeq	r5, r0, r0
    1c8c:	be9c0100 	fmllte	f0, f4, f0
    1c90:	2400000b 	strcs	r0, [r0], #-11
    1c94:	00000784 	andeq	r0, r0, r4, lsl #15
    1c98:	4d193201 	lfmmi	f3, 4, [r9, #-4]
    1c9c:	02000000 	andeq	r0, r0, #0
    1ca0:	af246c91 	svcge	0x00246c91
    1ca4:	01000016 	tsteq	r0, r6, lsl r0
    1ca8:	037b2b32 	cmneq	fp, #51200	; 0xc800
    1cac:	91020000 	mrsls	r0, (UNDEF: 2)
    1cb0:	15fd2468 	ldrbne	r2, [sp, #1128]!	; 0x468
    1cb4:	32010000 	andcc	r0, r1, #0
    1cb8:	00004d3c 	andeq	r4, r0, ip, lsr sp
    1cbc:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1cc0:	00166422 	andseq	r6, r6, r2, lsr #8
    1cc4:	0e340100 	rsfeqs	f0, f4, f0
    1cc8:	0000004d 	andeq	r0, r0, sp, asr #32
    1ccc:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1cd0:	0016ec25 	andseq	lr, r6, r5, lsr #24
    1cd4:	0a250100 	beq	9420dc <__bss_end+0x9390a0>
    1cd8:	000016b6 			; <UNDEFINED> instruction: 0x000016b6
    1cdc:	0000004d 	andeq	r0, r0, sp, asr #32
    1ce0:	000084d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    1ce4:	00000050 	andeq	r0, r0, r0, asr r0
    1ce8:	0c199c01 	ldceq	12, cr9, [r9], {1}
    1cec:	84240000 	strthi	r0, [r4], #-0
    1cf0:	01000007 	tsteq	r0, r7
    1cf4:	004d1825 	subeq	r1, sp, r5, lsr #16
    1cf8:	91020000 	mrsls	r0, (UNDEF: 2)
    1cfc:	16af246c 	strtne	r2, [pc], ip, ror #8
    1d00:	25010000 	strcs	r0, [r1, #-0]
    1d04:	000c1f2a 	andeq	r1, ip, sl, lsr #30
    1d08:	68910200 	ldmvs	r1, {r9}
    1d0c:	0015fd24 	andseq	pc, r5, r4, lsr #26
    1d10:	3b250100 	blcc	942118 <__bss_end+0x9390dc>
    1d14:	0000004d 	andeq	r0, r0, sp, asr #32
    1d18:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1d1c:	00001430 	andeq	r1, r0, r0, lsr r4
    1d20:	4d0e2701 	stcmi	7, cr2, [lr, #-4]
    1d24:	02000000 	andeq	r0, r0, #0
    1d28:	18007491 	stmdane	r0, {r0, r4, r7, sl, ip, sp, lr}
    1d2c:	00002504 	andeq	r2, r0, r4, lsl #10
    1d30:	0c190300 	ldceq	3, cr0, [r9], {-0}
    1d34:	95250000 	strls	r0, [r5, #-0]!
    1d38:	01000015 	tsteq	r0, r5, lsl r0
    1d3c:	16f80a19 	usatne	r0, #24, r9, lsl #20
    1d40:	004d0000 	subeq	r0, sp, r0
    1d44:	84940000 	ldrhi	r0, [r4], #0
    1d48:	00440000 	subeq	r0, r4, r0
    1d4c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1d50:	00000c70 	andeq	r0, r0, r0, ror ip
    1d54:	0016e324 	andseq	lr, r6, r4, lsr #6
    1d58:	1b190100 	blne	642160 <__bss_end+0x639124>
    1d5c:	0000037b 	andeq	r0, r0, fp, ror r3
    1d60:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1d64:	000016aa 	andeq	r1, r0, sl, lsr #13
    1d68:	c6351901 	ldrtgt	r1, [r5], -r1, lsl #18
    1d6c:	02000001 	andeq	r0, r0, #1
    1d70:	84226891 	strthi	r6, [r2], #-2193	; 0xfffff76f
    1d74:	01000007 	tsteq	r0, r7
    1d78:	004d0e1b 	subeq	r0, sp, fp, lsl lr
    1d7c:	91020000 	mrsls	r0, (UNDEF: 2)
    1d80:	e9280074 	stmdb	r8!, {r2, r4, r5, r6}
    1d84:	01000014 	tsteq	r0, r4, lsl r0
    1d88:	14360614 	ldrtne	r0, [r6], #-1556	; 0xfffff9ec
    1d8c:	84780000 	ldrbthi	r0, [r8], #-0
    1d90:	001c0000 	andseq	r0, ip, r0
    1d94:	9c010000 	stcls	0, cr0, [r1], {-0}
    1d98:	0016a027 	andseq	sl, r6, r7, lsr #32
    1d9c:	060e0100 	streq	r0, [lr], -r0, lsl #2
    1da0:	0000146f 	andeq	r1, r0, pc, ror #8
    1da4:	0000844c 	andeq	r8, r0, ip, asr #8
    1da8:	0000002c 	andeq	r0, r0, ip, lsr #32
    1dac:	0cb09c01 	ldceq	12, cr9, [r0], #4
    1db0:	c2240000 	eorgt	r0, r4, #0
    1db4:	01000014 	tsteq	r0, r4, lsl r0
    1db8:	0038140e 	eorseq	r1, r8, lr, lsl #8
    1dbc:	91020000 	mrsls	r0, (UNDEF: 2)
    1dc0:	f1290074 			; <UNDEFINED> instruction: 0xf1290074
    1dc4:	01000016 	tsteq	r0, r6, lsl r0
    1dc8:	15770a04 	ldrbne	r0, [r7, #-2564]!	; 0xfffff5fc
    1dcc:	004d0000 	subeq	r0, sp, r0
    1dd0:	84200000 	strthi	r0, [r0], #-0
    1dd4:	002c0000 	eoreq	r0, ip, r0
    1dd8:	9c010000 	stcls	0, cr0, [r1], {-0}
    1ddc:	64697026 	strbtvs	r7, [r9], #-38	; 0xffffffda
    1de0:	0e060100 	adfeqs	f0, f6, f0
    1de4:	0000004d 	andeq	r0, r0, sp, asr #32
    1de8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1dec:	00032e00 	andeq	r2, r3, r0, lsl #28
    1df0:	24000400 	strcs	r0, [r0], #-1024	; 0xfffffc00
    1df4:	04000007 	streq	r0, [r0], #-7
    1df8:	00134101 	andseq	r4, r3, r1, lsl #2
    1dfc:	17380400 	ldrne	r0, [r8, -r0, lsl #8]!
    1e00:	15340000 	ldrne	r0, [r4, #-0]!
    1e04:	88800000 	stmhi	r0, {}	; <UNPREDICTABLE>
    1e08:	04b80000 	ldrteq	r0, [r8], #0
    1e0c:	076c0000 	strbeq	r0, [ip, -r0]!
    1e10:	49020000 	stmdbmi	r2, {}	; <UNPREDICTABLE>
    1e14:	03000000 	movweq	r0, #0
    1e18:	0000177a 	andeq	r1, r0, sl, ror r7
    1e1c:	61100501 	tstvs	r0, r1, lsl #10
    1e20:	11000000 	mrsne	r0, (UNDEF: 0)
    1e24:	33323130 	teqcc	r2, #48, 2
    1e28:	37363534 			; <UNDEFINED> instruction: 0x37363534
    1e2c:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    1e30:	46454443 	strbmi	r4, [r5], -r3, asr #8
    1e34:	01040000 	mrseq	r0, (UNDEF: 4)
    1e38:	00250103 	eoreq	r0, r5, r3, lsl #2
    1e3c:	74050000 	strvc	r0, [r5], #-0
    1e40:	61000000 	mrsvs	r0, (UNDEF: 0)
    1e44:	06000000 	streq	r0, [r0], -r0
    1e48:	00000066 	andeq	r0, r0, r6, rrx
    1e4c:	51070010 	tstpl	r7, r0, lsl r0
    1e50:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1e54:	1d010704 	stcne	7, cr0, [r1, #-16]
    1e58:	01080000 	mrseq	r0, (UNDEF: 8)
    1e5c:	00108408 	andseq	r8, r0, r8, lsl #8
    1e60:	006d0700 	rsbeq	r0, sp, r0, lsl #14
    1e64:	2a090000 	bcs	241e6c <__bss_end+0x238e30>
    1e68:	0a000000 	beq	1e70 <shift+0x1e70>
    1e6c:	000017a9 	andeq	r1, r0, r9, lsr #15
    1e70:	94066401 	strls	r6, [r6], #-1025	; 0xfffffbff
    1e74:	b8000017 	stmdalt	r0, {r0, r1, r2, r4}
    1e78:	8000008c 	andhi	r0, r0, ip, lsl #1
    1e7c:	01000000 	mrseq	r0, (UNDEF: 0)
    1e80:	0000fb9c 	muleq	r0, ip, fp
    1e84:	72730b00 	rsbsvc	r0, r3, #0, 22
    1e88:	64010063 	strvs	r0, [r1], #-99	; 0xffffff9d
    1e8c:	0000fb19 	andeq	pc, r0, r9, lsl fp	; <UNPREDICTABLE>
    1e90:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1e94:	7473640b 	ldrbtvc	r6, [r3], #-1035	; 0xfffffbf5
    1e98:	24640100 	strbtcs	r0, [r4], #-256	; 0xffffff00
    1e9c:	00000102 	andeq	r0, r0, r2, lsl #2
    1ea0:	0b609102 	bleq	18262b0 <__bss_end+0x181d274>
    1ea4:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1ea8:	042d6401 	strteq	r6, [sp], #-1025	; 0xfffffbff
    1eac:	02000001 	andeq	r0, r0, #1
    1eb0:	0e0c5c91 	mcreq	12, 0, r5, cr12, cr1, {4}
    1eb4:	01000018 	tsteq	r0, r8, lsl r0
    1eb8:	010b0e66 	tsteq	fp, r6, ror #28
    1ebc:	91020000 	mrsls	r0, (UNDEF: 2)
    1ec0:	17860c70 			; <UNDEFINED> instruction: 0x17860c70
    1ec4:	67010000 	strvs	r0, [r1, -r0]
    1ec8:	00011108 	andeq	r1, r1, r8, lsl #2
    1ecc:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1ed0:	008ce00d 	addeq	lr, ip, sp
    1ed4:	00004800 	andeq	r4, r0, r0, lsl #16
    1ed8:	00690e00 	rsbeq	r0, r9, r0, lsl #28
    1edc:	040b6901 	streq	r6, [fp], #-2305	; 0xfffff6ff
    1ee0:	02000001 	andeq	r0, r0, #1
    1ee4:	00007491 	muleq	r0, r1, r4
    1ee8:	0101040f 	tsteq	r1, pc, lsl #8
    1eec:	11100000 	tstne	r0, r0
    1ef0:	05041204 	streq	r1, [r4, #-516]	; 0xfffffdfc
    1ef4:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1ef8:	0074040f 	rsbseq	r0, r4, pc, lsl #8
    1efc:	040f0000 	streq	r0, [pc], #-0	; 1f04 <shift+0x1f04>
    1f00:	0000006d 	andeq	r0, r0, sp, rrx
    1f04:	00171f0a 	andseq	r1, r7, sl, lsl #30
    1f08:	065c0100 	ldrbeq	r0, [ip], -r0, lsl #2
    1f0c:	0000172c 	andeq	r1, r0, ip, lsr #14
    1f10:	00008c50 	andeq	r8, r0, r0, asr ip
    1f14:	00000068 	andeq	r0, r0, r8, rrx
    1f18:	01769c01 	cmneq	r6, r1, lsl #24
    1f1c:	07130000 	ldreq	r0, [r3, -r0]
    1f20:	01000018 	tsteq	r0, r8, lsl r0
    1f24:	0102125c 	tsteq	r2, ip, asr r2
    1f28:	91020000 	mrsls	r0, (UNDEF: 2)
    1f2c:	1725136c 	strne	r1, [r5, -ip, ror #6]!
    1f30:	5c010000 	stcpl	0, cr0, [r1], {-0}
    1f34:	0001041e 	andeq	r0, r1, lr, lsl r4
    1f38:	68910200 	ldmvs	r1, {r9}
    1f3c:	6d656d0e 	stclvs	13, cr6, [r5, #-56]!	; 0xffffffc8
    1f40:	085e0100 	ldmdaeq	lr, {r8}^
    1f44:	00000111 	andeq	r0, r0, r1, lsl r1
    1f48:	0d709102 	ldfeqp	f1, [r0, #-8]!
    1f4c:	00008c6c 	andeq	r8, r0, ip, ror #24
    1f50:	0000003c 	andeq	r0, r0, ip, lsr r0
    1f54:	0100690e 	tsteq	r0, lr, lsl #18
    1f58:	01040b60 	tsteq	r4, r0, ror #22
    1f5c:	91020000 	mrsls	r0, (UNDEF: 2)
    1f60:	14000074 	strne	r0, [r0], #-116	; 0xffffff8c
    1f64:	000017b0 			; <UNDEFINED> instruction: 0x000017b0
    1f68:	c9055201 	stmdbgt	r5, {r0, r9, ip, lr}
    1f6c:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    1f70:	fc000001 	stc2	0, cr0, [r0], {1}
    1f74:	5400008b 	strpl	r0, [r0], #-139	; 0xffffff75
    1f78:	01000000 	mrseq	r0, (UNDEF: 0)
    1f7c:	0001af9c 	muleq	r1, ip, pc	; <UNPREDICTABLE>
    1f80:	00730b00 	rsbseq	r0, r3, r0, lsl #22
    1f84:	0b185201 	bleq	616790 <__bss_end+0x60d754>
    1f88:	02000001 	andeq	r0, r0, #1
    1f8c:	690e6c91 	stmdbvs	lr, {r0, r4, r7, sl, fp, sp, lr}
    1f90:	06540100 	ldrbeq	r0, [r4], -r0, lsl #2
    1f94:	00000104 	andeq	r0, r0, r4, lsl #2
    1f98:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1f9c:	0017f714 	andseq	pc, r7, r4, lsl r7	; <UNPREDICTABLE>
    1fa0:	05420100 	strbeq	r0, [r2, #-256]	; 0xffffff00
    1fa4:	000017b7 			; <UNDEFINED> instruction: 0x000017b7
    1fa8:	00000104 	andeq	r0, r0, r4, lsl #2
    1fac:	00008b50 	andeq	r8, r0, r0, asr fp
    1fb0:	000000ac 	andeq	r0, r0, ip, lsr #1
    1fb4:	02159c01 	andseq	r9, r5, #256	; 0x100
    1fb8:	730b0000 	movwvc	r0, #45056	; 0xb000
    1fbc:	42010031 	andmi	r0, r1, #49	; 0x31
    1fc0:	00010b19 	andeq	r0, r1, r9, lsl fp
    1fc4:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1fc8:	0032730b 	eorseq	r7, r2, fp, lsl #6
    1fcc:	0b294201 	bleq	a527d8 <__bss_end+0xa4979c>
    1fd0:	02000001 	andeq	r0, r0, #1
    1fd4:	6e0b6891 	mcrvs	8, 0, r6, cr11, cr1, {4}
    1fd8:	01006d75 	tsteq	r0, r5, ror sp
    1fdc:	01043142 	tsteq	r4, r2, asr #2
    1fe0:	91020000 	mrsls	r0, (UNDEF: 2)
    1fe4:	31750e64 	cmncc	r5, r4, ror #28
    1fe8:	10440100 	subne	r0, r4, r0, lsl #2
    1fec:	00000215 	andeq	r0, r0, r5, lsl r2
    1ff0:	0e779102 	expeqs	f1, f2
    1ff4:	01003275 	tsteq	r0, r5, ror r2
    1ff8:	02151444 	andseq	r1, r5, #68, 8	; 0x44000000
    1ffc:	91020000 	mrsls	r0, (UNDEF: 2)
    2000:	01080076 	tsteq	r8, r6, ror r0
    2004:	00107b08 	andseq	r7, r0, r8, lsl #22
    2008:	17ff1400 	ldrbne	r1, [pc, r0, lsl #8]!
    200c:	36010000 	strcc	r0, [r1], -r0
    2010:	0017e607 	andseq	lr, r7, r7, lsl #12
    2014:	00011100 	andeq	r1, r1, r0, lsl #2
    2018:	008a9000 	addeq	r9, sl, r0
    201c:	0000c000 	andeq	ip, r0, r0
    2020:	759c0100 	ldrvc	r0, [ip, #256]	; 0x100
    2024:	13000002 	movwne	r0, #2
    2028:	0000171a 	andeq	r1, r0, sl, lsl r7
    202c:	11153601 	tstne	r5, r1, lsl #12
    2030:	02000001 	andeq	r0, r0, #1
    2034:	730b6c91 	movwvc	r6, #48273	; 0xbc91
    2038:	01006372 	tsteq	r0, r2, ror r3
    203c:	010b2736 	tsteq	fp, r6, lsr r7
    2040:	91020000 	mrsls	r0, (UNDEF: 2)
    2044:	756e0b68 	strbvc	r0, [lr, #-2920]!	; 0xfffff498
    2048:	3601006d 	strcc	r0, [r1], -sp, rrx
    204c:	00010430 	andeq	r0, r1, r0, lsr r4
    2050:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2054:	0100690e 	tsteq	r0, lr, lsl #18
    2058:	01040638 	tsteq	r4, r8, lsr r6
    205c:	91020000 	mrsls	r0, (UNDEF: 2)
    2060:	d6140074 			; <UNDEFINED> instruction: 0xd6140074
    2064:	01000017 	tsteq	r0, r7, lsl r0
    2068:	17db0524 	ldrbne	r0, [fp, r4, lsr #10]
    206c:	01040000 	mrseq	r0, (UNDEF: 4)
    2070:	89f40000 	ldmibhi	r4!, {}^	; <UNPREDICTABLE>
    2074:	009c0000 	addseq	r0, ip, r0
    2078:	9c010000 	stcls	0, cr0, [r1], {-0}
    207c:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
    2080:	00171413 	andseq	r1, r7, r3, lsl r4
    2084:	16240100 	strtne	r0, [r4], -r0, lsl #2
    2088:	0000010b 	andeq	r0, r0, fp, lsl #2
    208c:	0c6c9102 	stfeqp	f1, [ip], #-8
    2090:	0000178d 	andeq	r1, r0, sp, lsl #15
    2094:	04062601 	streq	r2, [r6], #-1537	; 0xfffff9ff
    2098:	02000001 	andeq	r0, r0, #1
    209c:	15007491 	strne	r7, [r0, #-1169]	; 0xfffffb6f
    20a0:	00001815 	andeq	r1, r0, r5, lsl r8
    20a4:	1a060801 	bne	1840b0 <__bss_end+0x17b074>
    20a8:	80000018 	andhi	r0, r0, r8, lsl r0
    20ac:	74000088 	strvc	r0, [r0], #-136	; 0xffffff78
    20b0:	01000001 	tsteq	r0, r1
    20b4:	1714139c 			; <UNDEFINED> instruction: 0x1714139c
    20b8:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    20bc:	00006618 	andeq	r6, r0, r8, lsl r6
    20c0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    20c4:	00178d13 	andseq	r8, r7, r3, lsl sp
    20c8:	25080100 	strcs	r0, [r8, #-256]	; 0xffffff00
    20cc:	00000111 	andeq	r0, r0, r1, lsl r1
    20d0:	13609102 	cmnne	r0, #-2147483648	; 0x80000000
    20d4:	000017a4 	andeq	r1, r0, r4, lsr #15
    20d8:	663a0801 	ldrtvs	r0, [sl], -r1, lsl #16
    20dc:	02000000 	andeq	r0, r0, #0
    20e0:	690e5c91 	stmdbvs	lr, {r0, r4, r7, sl, fp, ip, lr}
    20e4:	060a0100 	streq	r0, [sl], -r0, lsl #2
    20e8:	00000104 	andeq	r0, r0, r4, lsl #2
    20ec:	0d749102 	ldfeqp	f1, [r4, #-8]!
    20f0:	0000894c 	andeq	r8, r0, ip, asr #18
    20f4:	00000098 	muleq	r0, r8, r0
    20f8:	01006a0e 	tsteq	r0, lr, lsl #20
    20fc:	01040b1c 	tsteq	r4, ip, lsl fp
    2100:	91020000 	mrsls	r0, (UNDEF: 2)
    2104:	89740d70 	ldmdbhi	r4!, {r4, r5, r6, r8, sl, fp}^
    2108:	00600000 	rsbeq	r0, r0, r0
    210c:	630e0000 	movwvs	r0, #57344	; 0xe000
    2110:	081e0100 	ldmdaeq	lr, {r8}
    2114:	0000006d 	andeq	r0, r0, sp, rrx
    2118:	006f9102 	rsbeq	r9, pc, r2, lsl #2
    211c:	22000000 	andcs	r0, r0, #0
    2120:	02000000 	andeq	r0, r0, #0
    2124:	00084b00 	andeq	r4, r8, r0, lsl #22
    2128:	a2010400 	andge	r0, r1, #0, 8
    212c:	38000009 	stmdacc	r0, {r0, r3}
    2130:	4400008d 	strmi	r0, [r0], #-141	; 0xffffff73
    2134:	2600008f 	strcs	r0, [r0], -pc, lsl #1
    2138:	56000018 			; <UNDEFINED> instruction: 0x56000018
    213c:	bb000018 	bllt	21a4 <shift+0x21a4>
    2140:	01000018 	tsteq	r0, r8, lsl r0
    2144:	00002280 	andeq	r2, r0, r0, lsl #5
    2148:	5f000200 	svcpl	0x00000200
    214c:	04000008 	streq	r0, [r0], #-8
    2150:	000a1f01 	andeq	r1, sl, r1, lsl #30
    2154:	008f4400 	addeq	r4, pc, r0, lsl #8
    2158:	008f4800 	addeq	r4, pc, r0, lsl #16
    215c:	00182600 	andseq	r2, r8, r0, lsl #12
    2160:	00185600 	andseq	r5, r8, r0, lsl #12
    2164:	0018bb00 	andseq	fp, r8, r0, lsl #22
    2168:	09800100 	stmibeq	r0, {r8}
    216c:	0400000a 	streq	r0, [r0], #-10
    2170:	00087300 	andeq	r7, r8, r0, lsl #6
    2174:	5b010400 	blpl	4317c <__bss_end+0x3a140>
    2178:	0c000029 	stceq	0, cr0, [r0], {41}	; 0x29
    217c:	00001b9d 	muleq	r0, sp, fp
    2180:	00001856 	andeq	r1, r0, r6, asr r8
    2184:	00000a7f 	andeq	r0, r0, pc, ror sl
    2188:	69050402 	stmdbvs	r5, {r1, sl}
    218c:	0300746e 	movweq	r7, #1134	; 0x46e
    2190:	1d010704 	stcne	7, cr0, [r1, #-16]
    2194:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2198:	00035f05 	andeq	r5, r3, r5, lsl #30
    219c:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    21a0:	000024a2 	andeq	r2, r0, r2, lsr #9
    21a4:	001c0a04 	andseq	r0, ip, r4, lsl #20
    21a8:	162a0100 	strtne	r0, [sl], -r0, lsl #2
    21ac:	00000024 	andeq	r0, r0, r4, lsr #32
    21b0:	00206d04 	eoreq	r6, r0, r4, lsl #26
    21b4:	152f0100 	strne	r0, [pc, #-256]!	; 20bc <shift+0x20bc>
    21b8:	00000051 	andeq	r0, r0, r1, asr r0
    21bc:	00570405 	subseq	r0, r7, r5, lsl #8
    21c0:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
    21c4:	66000000 	strvs	r0, [r0], -r0
    21c8:	07000000 	streq	r0, [r0, -r0]
    21cc:	00000066 	andeq	r0, r0, r6, rrx
    21d0:	6c040500 	cfstr32vs	mvfx0, [r4], {-0}
    21d4:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    21d8:	00290c04 	eoreq	r0, r9, r4, lsl #24
    21dc:	0f360100 	svceq	0x00360100
    21e0:	00000079 	andeq	r0, r0, r9, ror r0
    21e4:	007f0405 	rsbseq	r0, pc, r5, lsl #8
    21e8:	1d060000 	stcne	0, cr0, [r6, #-0]
    21ec:	93000000 	movwls	r0, #0
    21f0:	07000000 	streq	r0, [r0, -r0]
    21f4:	00000066 	andeq	r0, r0, r6, rrx
    21f8:	00006607 	andeq	r6, r0, r7, lsl #12
    21fc:	01030000 	mrseq	r0, (UNDEF: 3)
    2200:	00107b08 	andseq	r7, r0, r8, lsl #22
    2204:	22d00900 	sbcscs	r0, r0, #0, 18
    2208:	bb010000 	bllt	42210 <__bss_end+0x391d4>
    220c:	00004512 	andeq	r4, r0, r2, lsl r5
    2210:	293a0900 	ldmdbcs	sl!, {r8, fp}
    2214:	be010000 	cdplt	0, 0, cr0, cr1, cr0, {0}
    2218:	00006d10 	andeq	r6, r0, r0, lsl sp
    221c:	06010300 	streq	r0, [r1], -r0, lsl #6
    2220:	0000107d 	andeq	r1, r0, sp, ror r0
    2224:	001f740a 	andseq	r7, pc, sl, lsl #8
    2228:	93010700 	movwls	r0, #5888	; 0x1700
    222c:	02000000 	andeq	r0, r0, #0
    2230:	01e60617 	mvneq	r0, r7, lsl r6
    2234:	710b0000 	mrsvc	r0, (UNDEF: 11)
    2238:	0000001a 	andeq	r0, r0, sl, lsl r0
    223c:	001e6c0b 	andseq	r6, lr, fp, lsl #24
    2240:	c80b0100 	stmdagt	fp, {r8}
    2244:	02000023 	andeq	r0, r0, #35	; 0x23
    2248:	0028500b 	eoreq	r5, r8, fp
    224c:	540b0300 	strpl	r0, [fp], #-768	; 0xfffffd00
    2250:	04000023 	streq	r0, [r0], #-35	; 0xffffffdd
    2254:	0027170b 	eoreq	r1, r7, fp, lsl #14
    2258:	3d0b0500 	cfstr32cc	mvfx0, [fp, #-0]
    225c:	06000026 	streq	r0, [r0], -r6, lsr #32
    2260:	001a920b 	andseq	r9, sl, fp, lsl #4
    2264:	2c0b0700 	stccs	7, cr0, [fp], {-0}
    2268:	08000027 	stmdaeq	r0, {r0, r1, r2, r5}
    226c:	00273a0b 	eoreq	r3, r7, fp, lsl #20
    2270:	2b0b0900 	blcs	2c4678 <__bss_end+0x2bb63c>
    2274:	0a000028 	beq	231c <shift+0x231c>
    2278:	0022960b 	eoreq	r9, r2, fp, lsl #12
    227c:	4b0b0b00 	blmi	2c4e84 <__bss_end+0x2bbe48>
    2280:	0c00001c 	stceq	0, cr0, [r0], {28}
    2284:	001ffd0b 	andseq	pc, pc, fp, lsl #26
    2288:	830b0d00 	movwhi	r0, #48384	; 0xbd00
    228c:	0e000027 	cdpeq	0, 0, cr0, cr0, cr7, {1}
    2290:	001fb80b 	andseq	fp, pc, fp, lsl #16
    2294:	ce0b0f00 	cdpgt	15, 0, cr0, cr11, cr0, {0}
    2298:	1000001f 	andne	r0, r0, pc, lsl r0
    229c:	001ea30b 	andseq	sl, lr, fp, lsl #6
    22a0:	380b1100 	stmdacc	fp, {r8, ip}
    22a4:	12000023 	andne	r0, r0, #35	; 0x23
    22a8:	001f300b 	andseq	r3, pc, fp
    22ac:	e80b1300 	stmda	fp, {r8, r9, ip}
    22b0:	1400002b 	strne	r0, [r0], #-43	; 0xffffffd5
    22b4:	0024000b 	eoreq	r0, r4, fp
    22b8:	5d0b1500 	cfstr32pl	mvfx1, [fp, #-0]
    22bc:	16000021 	strne	r0, [r0], -r1, lsr #32
    22c0:	001aef0b 	andseq	lr, sl, fp, lsl #30
    22c4:	730b1700 	movwvc	r1, #46848	; 0xb700
    22c8:	18000028 	stmdane	r0, {r3, r5}
    22cc:	002a7d0b 	eoreq	r7, sl, fp, lsl #26
    22d0:	810b1900 	tsthi	fp, r0, lsl #18
    22d4:	1a000028 	bne	237c <shift+0x237c>
    22d8:	001f800b 	andseq	r8, pc, fp
    22dc:	8f0b1b00 	svchi	0x000b1b00
    22e0:	1c000028 	stcne	0, cr0, [r0], {40}	; 0x28
    22e4:	00194b0b 	andseq	r4, r9, fp, lsl #22
    22e8:	9d0b1d00 	stcls	13, cr1, [fp, #-0]
    22ec:	1e000028 	cdpne	0, 0, cr0, cr0, cr8, {1}
    22f0:	0028ab0b 	eoreq	sl, r8, fp, lsl #22
    22f4:	e40b1f00 	str	r1, [fp], #-3840	; 0xfffff100
    22f8:	20000018 	andcs	r0, r0, r8, lsl r0
    22fc:	0025230b 	eoreq	r2, r5, fp, lsl #6
    2300:	0a0b2100 	beq	2ca708 <__bss_end+0x2c16cc>
    2304:	22000023 	andcs	r0, r0, #35	; 0x23
    2308:	0028660b 	eoreq	r6, r8, fp, lsl #12
    230c:	da0b2300 	ble	2caf14 <__bss_end+0x2c1ed8>
    2310:	24000021 	strcs	r0, [r0], #-33	; 0xffffffdf
    2314:	00262e0b 	eoreq	r2, r6, fp, lsl #28
    2318:	d00b2500 	andle	r2, fp, r0, lsl #10
    231c:	26000020 	strcs	r0, [r0], -r0, lsr #32
    2320:	001dac0b 	andseq	sl, sp, fp, lsl #24
    2324:	ee0b2700 	cdp	7, 0, cr2, cr11, cr0, {0}
    2328:	28000020 	stmdacs	r0, {r5}
    232c:	001e480b 	andseq	r4, lr, fp, lsl #16
    2330:	fe0b2900 	vseleq.f16	s4, s22, s0
    2334:	2a000020 	bcs	23bc <shift+0x23bc>
    2338:	00227c0b 	eoreq	r7, r2, fp, lsl #24
    233c:	770b2b00 	strvc	r2, [fp, -r0, lsl #22]
    2340:	2c000020 	stccs	0, cr0, [r0], {32}
    2344:	0025420b 	eoreq	r4, r5, fp, lsl #4
    2348:	ed0b2d00 	stc	13, cr2, [fp, #-0]
    234c:	2e00001d 	mcrcs	0, 0, r0, cr0, cr13, {0}
    2350:	200a0a00 	andcs	r0, sl, r0, lsl #20
    2354:	01070000 	mrseq	r0, (UNDEF: 7)
    2358:	00000093 	muleq	r0, r3, r0
    235c:	9f061703 	svcls	0x00061703
    2360:	0b000004 	bleq	2378 <shift+0x2378>
    2364:	00001c5f 	andeq	r1, r0, pc, asr ip
    2368:	2b110b00 	blcs	444f70 <__bss_end+0x43bf34>
    236c:	0b010000 	bleq	42374 <__bss_end+0x39338>
    2370:	00001c6f 	andeq	r1, r0, pc, ror #24
    2374:	1c920b02 	vldmiane	r2, {d0}
    2378:	0b030000 	bleq	c2380 <__bss_end+0xb9344>
    237c:	0000294a 	andeq	r2, r0, sl, asr #18
    2380:	25a80b04 	strcs	r0, [r8, #2820]!	; 0xb04
    2384:	0b050000 	bleq	14238c <__bss_end+0x139350>
    2388:	00001d1c 	andeq	r1, r0, ip, lsl sp
    238c:	1e910b06 	vfnmsne.f64	d0, d1, d6
    2390:	0b070000 	bleq	1c2398 <__bss_end+0x1b935c>
    2394:	00001ca2 	andeq	r1, r0, r2, lsr #25
    2398:	2bd70b08 	blcs	ff5c4fc0 <__bss_end+0xff5bbf84>
    239c:	0b090000 	bleq	2423a4 <__bss_end+0x239368>
    23a0:	000019c2 	andeq	r1, r0, r2, asr #19
    23a4:	2b000b0a 	blcs	4fd4 <shift+0x4fd4>
    23a8:	0b0b0000 	bleq	2c23b0 <__bss_end+0x2b9374>
    23ac:	000021e9 	andeq	r2, r0, r9, ror #3
    23b0:	2a940b0c 	bcs	fe504fe8 <__bss_end+0xfe4fbfac>
    23b4:	0b0d0000 	bleq	3423bc <__bss_end+0x339380>
    23b8:	00002530 	andeq	r2, r0, r0, lsr r5
    23bc:	27c90b0e 	strbcs	r0, [r9, lr, lsl #22]
    23c0:	0b0f0000 	bleq	3c23c8 <__bss_end+0x3b938c>
    23c4:	00001d7d 	andeq	r1, r0, sp, ror sp
    23c8:	1c7f0b10 			; <UNDEFINED> instruction: 0x1c7f0b10
    23cc:	0b110000 	bleq	4423d4 <__bss_end+0x439398>
    23d0:	000024e8 	andeq	r2, r0, r8, ror #9
    23d4:	1d680b12 	vstmdbne	r8!, {d16-d24}
    23d8:	0b130000 	bleq	4c23e0 <__bss_end+0x4b93a4>
    23dc:	00002aef 	andeq	r2, r0, pc, ror #21
    23e0:	19ec0b14 	stmibne	ip!, {r2, r4, r8, r9, fp}^
    23e4:	0b150000 	bleq	5423ec <__bss_end+0x5393b0>
    23e8:	00002138 	andeq	r2, r0, r8, lsr r1
    23ec:	1cb20b16 	vldmiane	r2!, {d0-d10}
    23f0:	0b170000 	bleq	5c23f8 <__bss_end+0x5b93bc>
    23f4:	00001989 	andeq	r1, r0, r9, lsl #19
    23f8:	2b7d0b18 	blcs	1f45060 <__bss_end+0x1f3c024>
    23fc:	0b190000 	bleq	642404 <__bss_end+0x6393c8>
    2400:	00002838 	andeq	r2, r0, r8, lsr r8
    2404:	264c0b1a 			; <UNDEFINED> instruction: 0x264c0b1a
    2408:	0b1b0000 	bleq	6c2410 <__bss_end+0x6b93d4>
    240c:	000027b0 			; <UNDEFINED> instruction: 0x000027b0
    2410:	29140b1c 	ldmdbcs	r4, {r2, r3, r4, r8, r9, fp}
    2414:	0b1d0000 	bleq	74241c <__bss_end+0x7393e0>
    2418:	00001cd2 	ldrdeq	r1, [r0], -r2
    241c:	1a5d0b1e 	bne	174509c <__bss_end+0x173c060>
    2420:	0b1f0000 	bleq	7c2428 <__bss_end+0x7b93ec>
    2424:	00002665 	andeq	r2, r0, r5, ror #12
    2428:	1dc90b20 	vstrne	d16, [r9, #128]	; 0x80
    242c:	0b210000 	bleq	842434 <__bss_end+0x8393f8>
    2430:	000025ba 			; <UNDEFINED> instruction: 0x000025ba
    2434:	21ba0b22 			; <UNDEFINED> instruction: 0x21ba0b22
    2438:	0b230000 	bleq	8c2440 <__bss_end+0x8b9404>
    243c:	00001cc2 	andeq	r1, r0, r2, asr #25
    2440:	27680b24 	strbcs	r0, [r8, -r4, lsr #22]!
    2444:	0b250000 	bleq	94244c <__bss_end+0x939410>
    2448:	00001bd5 	ldrdeq	r1, [r0], -r5
    244c:	28f90b26 	ldmcs	r9!, {r1, r2, r5, r8, r9, fp}^
    2450:	0b270000 	bleq	9c2458 <__bss_end+0x9b941c>
    2454:	00002bc4 	andeq	r2, r0, r4, asr #23
    2458:	24bb0b28 	ldrtcs	r0, [fp], #2856	; 0xb28
    245c:	0b290000 	bleq	a42464 <__bss_end+0xa39428>
    2460:	00001f62 	andeq	r1, r0, r2, ror #30
    2464:	268f0b2a 	strcs	r0, [pc], sl, lsr #22
    2468:	0b2b0000 	bleq	ac2470 <__bss_end+0xab9434>
    246c:	00002218 	andeq	r2, r0, r8, lsl r2
    2470:	1ab00b2c 	bne	fec05128 <__bss_end+0xfebfc0ec>
    2474:	0b2d0000 	bleq	b4247c <__bss_end+0xb39440>
    2478:	00001a34 	andeq	r1, r0, r4, lsr sl
    247c:	2a520b2e 	bcs	148513c <__bss_end+0x147c100>
    2480:	0b2f0000 	bleq	bc2488 <__bss_end+0xbb944c>
    2484:	000021a6 	andeq	r2, r0, r6, lsr #3
    2488:	1d420b30 	vstrne	d16, [r2, #-192]	; 0xffffff40
    248c:	0b310000 	bleq	c42494 <__bss_end+0xc39458>
    2490:	00002185 	andeq	r2, r0, r5, lsl #3
    2494:	24340b32 	ldrtcs	r0, [r4], #-2866	; 0xfffff4ce
    2498:	0b330000 	bleq	cc24a0 <__bss_end+0xcb9464>
    249c:	00001a22 	andeq	r1, r0, r2, lsr #20
    24a0:	2bb20b34 	blcs	fec85178 <__bss_end+0xfec7c13c>
    24a4:	0b350000 	bleq	d424ac <__bss_end+0xd39470>
    24a8:	00002269 	andeq	r2, r0, r9, ror #4
    24ac:	1efb0b36 	vmovne.u8	r0, d11[5]
    24b0:	0b370000 	bleq	dc24b8 <__bss_end+0xdb947c>
    24b4:	000022a6 	andeq	r2, r0, r6, lsr #5
    24b8:	2aba0b38 	bcs	fee851a0 <__bss_end+0xfee7c164>
    24bc:	0b390000 	bleq	e424c4 <__bss_end+0xe39488>
    24c0:	00001b67 	andeq	r1, r0, r7, ror #22
    24c4:	1f0e0b3a 	svcne	0x000e0b3a
    24c8:	0b3b0000 	bleq	ec24d0 <__bss_end+0xeb9494>
    24cc:	00001eda 	ldrdeq	r1, [r0], -sl
    24d0:	18f30b3c 	ldmne	r3!, {r2, r3, r4, r5, r8, r9, fp}^
    24d4:	0b3d0000 	bleq	f424dc <__bss_end+0xf394a0>
    24d8:	000021fb 	strdeq	r2, [r0], -fp
    24dc:	1fda0b3e 	svcne	0x00da0b3e
    24e0:	0b3f0000 	bleq	fc24e8 <__bss_end+0xfb94ac>
    24e4:	00001a7b 	andeq	r1, r0, fp, ror sl
    24e8:	2a660b40 	bcs	19851f0 <__bss_end+0x197c1b4>
    24ec:	0b410000 	bleq	10424f4 <__bss_end+0x10394b8>
    24f0:	0000214b 	andeq	r2, r0, fp, asr #2
    24f4:	1ec40b42 			; <UNDEFINED> instruction: 0x1ec40b42
    24f8:	0b430000 	bleq	10c2500 <__bss_end+0x10b94c4>
    24fc:	00001934 	andeq	r1, r0, r4, lsr r9
    2500:	20a80b44 	adccs	r0, r8, r4, asr #22
    2504:	0b450000 	bleq	114250c <__bss_end+0x11394d0>
    2508:	00002094 	muleq	r0, r4, r0
    250c:	260f0b46 	strcs	r0, [pc], -r6, asr #22
    2510:	0b470000 	bleq	11c2518 <__bss_end+0x11b94dc>
    2514:	000026d7 	ldrdeq	r2, [r0], -r7
    2518:	2a310b48 	bcs	c45240 <__bss_end+0xc3c204>
    251c:	0b490000 	bleq	1242524 <__bss_end+0x12394e8>
    2520:	00001dfa 	strdeq	r1, [r0], -sl
    2524:	23ea0b4a 	mvncs	r0, #75776	; 0x12800
    2528:	0b4b0000 	bleq	12c2530 <__bss_end+0x12b94f4>
    252c:	000026a4 	andeq	r2, r0, r4, lsr #13
    2530:	25510b4c 	ldrbcs	r0, [r1, #-2892]	; 0xfffff4b4
    2534:	0b4d0000 	bleq	134253c <__bss_end+0x1339500>
    2538:	00002565 	andeq	r2, r0, r5, ror #10
    253c:	25790b4e 	ldrbcs	r0, [r9, #-2894]!	; 0xfffff4b2
    2540:	0b4f0000 	bleq	13c2548 <__bss_end+0x13b950c>
    2544:	00001bf5 	strdeq	r1, [r0], -r5
    2548:	1b520b50 	blne	1485290 <__bss_end+0x147c254>
    254c:	0b510000 	bleq	1442554 <__bss_end+0x1439518>
    2550:	00001b7a 	andeq	r1, r0, sl, ror fp
    2554:	27db0b52 			; <UNDEFINED> instruction: 0x27db0b52
    2558:	0b530000 	bleq	14c2560 <__bss_end+0x14b9524>
    255c:	00001bc0 	andeq	r1, r0, r0, asr #23
    2560:	27ef0b54 	ubfxcs	r0, r4, #22, #16
    2564:	0b550000 	bleq	154256c <__bss_end+0x1539530>
    2568:	00002803 	andeq	r2, r0, r3, lsl #16
    256c:	28170b56 	ldmdacs	r7, {r1, r2, r4, r6, r8, r9, fp}
    2570:	0b570000 	bleq	15c2578 <__bss_end+0x15b953c>
    2574:	00001d54 	andeq	r1, r0, r4, asr sp
    2578:	1d2e0b58 	vstmdbne	lr!, {d0-<overflow reg d43>}
    257c:	0b590000 	bleq	1642584 <__bss_end+0x1639548>
    2580:	000020bc 	strheq	r2, [r0], -ip
    2584:	22b90b5a 	adcscs	r0, r9, #92160	; 0x16800
    2588:	0b5b0000 	bleq	16c2590 <__bss_end+0x16b9554>
    258c:	00002042 	andeq	r2, r0, r2, asr #32
    2590:	18c70b5c 	stmiane	r7, {r2, r3, r4, r6, r8, r9, fp}^
    2594:	0b5d0000 	bleq	174259c <__bss_end+0x1739560>
    2598:	00001e7c 	andeq	r1, r0, ip, ror lr
    259c:	22e20b5e 	rsccs	r0, r2, #96256	; 0x17800
    25a0:	0b5f0000 	bleq	17c25a8 <__bss_end+0x17b956c>
    25a4:	0000210e 	andeq	r2, r0, lr, lsl #2
    25a8:	25cd0b60 	strbcs	r0, [sp, #2912]	; 0xb60
    25ac:	0b610000 	bleq	18425b4 <__bss_end+0x1839578>
    25b0:	00002b2f 	andeq	r2, r0, pc, lsr #22
    25b4:	23d50b62 	bicscs	r0, r5, #100352	; 0x18800
    25b8:	0b630000 	bleq	18c25c0 <__bss_end+0x18b9584>
    25bc:	00001e1f 	andeq	r1, r0, pc, lsl lr
    25c0:	199b0b64 	ldmibne	fp, {r2, r5, r6, r8, r9, fp}
    25c4:	0b650000 	bleq	19425cc <__bss_end+0x1939590>
    25c8:	00001959 	andeq	r1, r0, r9, asr r9
    25cc:	231a0b66 	tstcs	sl, #104448	; 0x19800
    25d0:	0b670000 	bleq	19c25d8 <__bss_end+0x19b959c>
    25d4:	00002455 	andeq	r2, r0, r5, asr r4
    25d8:	25f10b68 	ldrbcs	r0, [r1, #2920]!	; 0xb68
    25dc:	0b690000 	bleq	1a425e4 <__bss_end+0x1a395a8>
    25e0:	00002123 	andeq	r2, r0, r3, lsr #2
    25e4:	2b680b6a 	blcs	1a05394 <__bss_end+0x19fc358>
    25e8:	0b6b0000 	bleq	1ac25f0 <__bss_end+0x1ab95b4>
    25ec:	00002239 	andeq	r2, r0, r9, lsr r2
    25f0:	19180b6c 	ldmdbne	r8, {r2, r3, r5, r6, r8, r9, fp}
    25f4:	0b6d0000 	bleq	1b425fc <__bss_end+0x1b395c0>
    25f8:	00001a48 	andeq	r1, r0, r8, asr #20
    25fc:	1e330b6e 	vsubne.f64	d0, d3, d30
    2600:	0b6f0000 	bleq	1bc2608 <__bss_end+0x1bb95cc>
    2604:	00001ce3 	andeq	r1, r0, r3, ror #25
    2608:	02030070 	andeq	r0, r3, #112	; 0x70
    260c:	00121507 	andseq	r1, r2, r7, lsl #10
    2610:	04bc0c00 	ldrteq	r0, [ip], #3072	; 0xc00
    2614:	04b10000 	ldrteq	r0, [r1], #0
    2618:	000d0000 	andeq	r0, sp, r0
    261c:	0004a60e 	andeq	sl, r4, lr, lsl #12
    2620:	c8040500 	stmdagt	r4, {r8, sl}
    2624:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
    2628:	000004b6 			; <UNDEFINED> instruction: 0x000004b6
    262c:	84080103 	strhi	r0, [r8], #-259	; 0xfffffefd
    2630:	0e000010 	mcreq	0, 0, r0, cr0, cr0, {0}
    2634:	000004c1 	andeq	r0, r0, r1, asr #9
    2638:	001ae00f 	andseq	lr, sl, pc
    263c:	01440400 	cmpeq	r4, r0, lsl #8
    2640:	0004b11a 	andeq	fp, r4, sl, lsl r1
    2644:	1eb40f00 	cdpne	15, 11, cr0, cr4, cr0, {0}
    2648:	79040000 	stmdbvc	r4, {}	; <UNPREDICTABLE>
    264c:	04b11a01 	ldrteq	r1, [r1], #2561	; 0xa01
    2650:	c10c0000 	mrsgt	r0, (UNDEF: 12)
    2654:	f2000004 	vhadd.s8	d0, d0, d4
    2658:	0d000004 	stceq	0, cr0, [r0, #-16]
    265c:	20e00900 	rsccs	r0, r0, r0, lsl #18
    2660:	2d050000 	stccs	0, cr0, [r5, #-0]
    2664:	0004e70d 	andeq	lr, r4, sp, lsl #14
    2668:	28d50900 	ldmcs	r5, {r8, fp}^
    266c:	35050000 	strcc	r0, [r5, #-0]
    2670:	0001e61c 	andeq	lr, r1, ip, lsl r6
    2674:	1d900a00 	vldrne	s0, [r0]
    2678:	01070000 	mrseq	r0, (UNDEF: 7)
    267c:	00000093 	muleq	r0, r3, r0
    2680:	7d0e3705 	stcvc	7, cr3, [lr, #-20]	; 0xffffffec
    2684:	0b000005 	bleq	26a0 <shift+0x26a0>
    2688:	0000192d 	andeq	r1, r0, sp, lsr #18
    268c:	1fc70b00 	svcne	0x00c70b00
    2690:	0b010000 	bleq	42698 <__bss_end+0x3965c>
    2694:	00002acc 	andeq	r2, r0, ip, asr #21
    2698:	2aa70b02 	bcs	fe9c52a8 <__bss_end+0xfe9bc26c>
    269c:	0b030000 	bleq	c26a4 <__bss_end+0xb9668>
    26a0:	00002383 	andeq	r2, r0, r3, lsl #7
    26a4:	27250b04 	strcs	r0, [r5, -r4, lsl #22]!
    26a8:	0b050000 	bleq	1426b0 <__bss_end+0x139674>
    26ac:	00001b23 	andeq	r1, r0, r3, lsr #22
    26b0:	1b050b06 	blne	1452d0 <__bss_end+0x13c294>
    26b4:	0b070000 	bleq	1c26bc <__bss_end+0x1b9680>
    26b8:	00001c58 	andeq	r1, r0, r8, asr ip
    26bc:	22110b08 	andscs	r0, r1, #8, 22	; 0x2000
    26c0:	0b090000 	bleq	2426c8 <__bss_end+0x23968c>
    26c4:	00001b2a 	andeq	r1, r0, sl, lsr #22
    26c8:	1b960b0a 	blne	fe5852f8 <__bss_end+0xfe57c2bc>
    26cc:	0b0b0000 	bleq	2c26d4 <__bss_end+0x2b9698>
    26d0:	00001b8f 	andeq	r1, r0, pc, lsl #23
    26d4:	1b1c0b0c 	blne	70530c <__bss_end+0x6fc2d0>
    26d8:	0b0d0000 	bleq	3426e0 <__bss_end+0x3396a4>
    26dc:	0000277c 	andeq	r2, r0, ip, ror r7
    26e0:	24730b0e 	ldrbtcs	r0, [r3], #-2830	; 0xfffff4f2
    26e4:	000f0000 	andeq	r0, pc, r0
    26e8:	00262704 	eoreq	r2, r6, r4, lsl #14
    26ec:	013c0500 	teqeq	ip, r0, lsl #10
    26f0:	0000050a 	andeq	r0, r0, sl, lsl #10
    26f4:	0026f809 	eoreq	pc, r6, r9, lsl #16
    26f8:	0f3e0500 	svceq	0x003e0500
    26fc:	0000057d 	andeq	r0, r0, sp, ror r5
    2700:	00279f09 	eoreq	r9, r7, r9, lsl #30
    2704:	0c470500 	cfstr64eq	mvdx0, [r7], {-0}
    2708:	0000001d 	andeq	r0, r0, sp, lsl r0
    270c:	001ad009 	andseq	sp, sl, r9
    2710:	0c480500 	cfstr64eq	mvdx0, [r8], {-0}
    2714:	0000001d 	andeq	r0, r0, sp, lsl r0
    2718:	0028b910 	eoreq	fp, r8, r0, lsl r9
    271c:	27070900 	strcs	r0, [r7, -r0, lsl #18]
    2720:	49050000 	stmdbmi	r5, {}	; <UNPREDICTABLE>
    2724:	0005be14 	andeq	fp, r5, r4, lsl lr
    2728:	ad040500 	cfstr32ge	mvfx0, [r4, #-0]
    272c:	11000005 	tstne	r0, r5
    2730:	001f9109 	andseq	r9, pc, r9, lsl #2
    2734:	0f4b0500 	svceq	0x004b0500
    2738:	000005d1 	ldrdeq	r0, [r0], -r1
    273c:	05c40405 	strbeq	r0, [r4, #1029]	; 0x405
    2740:	7a120000 	bvc	482748 <__bss_end+0x47970c>
    2744:	09000026 	stmdbeq	r0, {r1, r2, r5}
    2748:	00002370 	andeq	r2, r0, r0, ror r3
    274c:	e80d4f05 	stmda	sp, {r0, r2, r8, r9, sl, fp, lr}
    2750:	05000005 	streq	r0, [r0, #-5]
    2754:	0005d704 	andeq	sp, r5, r4, lsl #14
    2758:	1c3e1300 	ldcne	3, cr1, [lr], #-0
    275c:	05340000 	ldreq	r0, [r4, #-0]!
    2760:	19150158 	ldmdbne	r5, {r3, r4, r6, r8}
    2764:	14000006 	strne	r0, [r0], #-6
    2768:	000020e9 	andeq	r2, r0, r9, ror #1
    276c:	0f015a05 	svceq	0x00015a05
    2770:	000004b6 			; <UNDEFINED> instruction: 0x000004b6
    2774:	1c221400 	cfstrsne	mvf1, [r2], #-0
    2778:	5b050000 	blpl	142780 <__bss_end+0x139744>
    277c:	061e1401 	ldreq	r1, [lr], -r1, lsl #8
    2780:	00040000 	andeq	r0, r4, r0
    2784:	0005ee0e 	andeq	lr, r5, lr, lsl #28
    2788:	00b90c00 	adcseq	r0, r9, r0, lsl #24
    278c:	062e0000 	strteq	r0, [lr], -r0
    2790:	24150000 	ldrcs	r0, [r5], #-0
    2794:	2d000000 	stccs	0, cr0, [r0, #-0]
    2798:	06190c00 	ldreq	r0, [r9], -r0, lsl #24
    279c:	06390000 	ldrteq	r0, [r9], -r0
    27a0:	000d0000 	andeq	r0, sp, r0
    27a4:	00062e0e 	andeq	r2, r6, lr, lsl #28
    27a8:	20190f00 	andscs	r0, r9, r0, lsl #30
    27ac:	5c050000 	stcpl	0, cr0, [r5], {-0}
    27b0:	06390301 	ldrteq	r0, [r9], -r1, lsl #6
    27b4:	890f0000 	stmdbhi	pc, {}	; <UNPREDICTABLE>
    27b8:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    27bc:	1d0c015f 	stfnes	f0, [ip, #-380]	; 0xfffffe84
    27c0:	16000000 	strne	r0, [r0], -r0
    27c4:	000026b8 			; <UNDEFINED> instruction: 0x000026b8
    27c8:	00930107 	addseq	r0, r3, r7, lsl #2
    27cc:	72050000 	andvc	r0, r5, #0
    27d0:	070e0601 	streq	r0, [lr, -r1, lsl #12]
    27d4:	640b0000 	strvs	r0, [fp], #-0
    27d8:	00000023 	andeq	r0, r0, r3, lsr #32
    27dc:	0019d40b 	andseq	sp, r9, fp, lsl #8
    27e0:	e00b0200 	and	r0, fp, r0, lsl #4
    27e4:	03000019 	movweq	r0, #25
    27e8:	001dbc0b 	andseq	fp, sp, fp, lsl #24
    27ec:	a00b0300 	andge	r0, fp, r0, lsl #6
    27f0:	04000023 	streq	r0, [r0], #-35	; 0xffffffdd
    27f4:	001f230b 	andseq	r2, pc, fp, lsl #6
    27f8:	fe0b0400 	cdp2	4, 0, cr0, cr11, cr0, {0}
    27fc:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    2800:	001ff00b 	andseq	pc, pc, fp
    2804:	2a0b0500 	bcs	2c3c0c <__bss_end+0x2babd0>
    2808:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    280c:	001f540b 	andseq	r5, pc, fp, lsl #8
    2810:	c10b0500 	tstgt	fp, r0, lsl #10
    2814:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    2818:	001a0a0b 	andseq	r0, sl, fp, lsl #20
    281c:	990b0600 	stmdbls	fp, {r9, sl}
    2820:	06000021 	streq	r0, [r0], -r1, lsr #32
    2824:	001c140b 	andseq	r1, ip, fp, lsl #8
    2828:	ae0b0600 	cfmadd32ge	mvax0, mvfx0, mvfx11, mvfx0
    282c:	06000024 	streq	r0, [r0], -r4, lsr #32
    2830:	0027480b 	eoreq	r4, r7, fp, lsl #16
    2834:	cd0b0600 	stcgt	6, cr0, [fp, #-0]
    2838:	06000021 	streq	r0, [r0], -r1, lsr #32
    283c:	00222c0b 	eoreq	r2, r2, fp, lsl #24
    2840:	160b0600 	strne	r0, [fp], -r0, lsl #12
    2844:	0700001a 	smladeq	r0, sl, r0, r0
    2848:	0023470b 	eoreq	r4, r3, fp, lsl #14
    284c:	ac0b0700 	stcge	7, cr0, [fp], {-0}
    2850:	07000023 	streq	r0, [r0, -r3, lsr #32]
    2854:	0027920b 	eoreq	r9, r7, fp, lsl #4
    2858:	e70b0700 	str	r0, [fp, -r0, lsl #14]
    285c:	0700001b 	smladeq	r0, fp, r0, r0
    2860:	0024270b 	eoreq	r2, r4, fp, lsl #14
    2864:	770b0800 	strvc	r0, [fp, -r0, lsl #16]
    2868:	08000019 	stmdaeq	r0, {r0, r3, r4}
    286c:	0027560b 	eoreq	r5, r7, fp, lsl #12
    2870:	480b0800 	stmdami	fp, {fp}
    2874:	08000024 	stmdaeq	r0, {r2, r5}
    2878:	2ae10f00 	bcs	ff846480 <__bss_end+0xff83d444>
    287c:	92050000 	andls	r0, r5, #0
    2880:	06581f01 	ldrbeq	r1, [r8], -r1, lsl #30
    2884:	f00f0000 			; <UNDEFINED> instruction: 0xf00f0000
    2888:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    288c:	1d0c0195 	stfnes	f0, [ip, #-596]	; 0xfffffdac
    2890:	0f000000 	svceq	0x00000000
    2894:	0000247a 	andeq	r2, r0, sl, ror r4
    2898:	0c019805 	stceq	8, cr9, [r1], {5}
    289c:	0000001d 	andeq	r0, r0, sp, lsl r0
    28a0:	0020370f 	eoreq	r3, r0, pc, lsl #14
    28a4:	019b0500 	orrseq	r0, fp, r0, lsl #10
    28a8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    28ac:	24840f00 	strcs	r0, [r4], #3840	; 0xf00
    28b0:	9e050000 	cdpls	0, 0, cr0, cr5, cr0, {0}
    28b4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    28b8:	7a0f0000 	bvc	3c28c0 <__bss_end+0x3b9884>
    28bc:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    28c0:	1d0c01a1 	stfnes	f0, [ip, #-644]	; 0xfffffd7c
    28c4:	0f000000 	svceq	0x00000000
    28c8:	000024ce 	andeq	r2, r0, lr, asr #9
    28cc:	0c01a405 	cfstrseq	mvf10, [r1], {5}
    28d0:	0000001d 	andeq	r0, r0, sp, lsl r0
    28d4:	00238a0f 	eoreq	r8, r3, pc, lsl #20
    28d8:	01a70500 			; <UNDEFINED> instruction: 0x01a70500
    28dc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    28e0:	23950f00 	orrscs	r0, r5, #0, 30
    28e4:	aa050000 	bge	1428ec <__bss_end+0x1398b0>
    28e8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    28ec:	8e0f0000 	cdphi	0, 0, cr0, cr15, cr0, {0}
    28f0:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    28f4:	1d0c01ad 	stfnes	f0, [ip, #-692]	; 0xfffffd4c
    28f8:	0f000000 	svceq	0x00000000
    28fc:	0000216c 	andeq	r2, r0, ip, ror #2
    2900:	0c01b005 	stceq	0, cr11, [r1], {5}
    2904:	0000001d 	andeq	r0, r0, sp, lsl r0
    2908:	002b230f 	eoreq	r2, fp, pc, lsl #6
    290c:	01b30500 			; <UNDEFINED> instruction: 0x01b30500
    2910:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2914:	24980f00 	ldrcs	r0, [r8], #3840	; 0xf00
    2918:	b6050000 	strlt	r0, [r5], -r0
    291c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2920:	000f0000 	andeq	r0, pc, r0
    2924:	0500002c 	streq	r0, [r0, #-44]	; 0xffffffd4
    2928:	1d0c01b9 	stfnes	f0, [ip, #-740]	; 0xfffffd1c
    292c:	0f000000 	svceq	0x00000000
    2930:	00002aae 	andeq	r2, r0, lr, lsr #21
    2934:	0c01bc05 	stceq	12, cr11, [r1], {5}
    2938:	0000001d 	andeq	r0, r0, sp, lsl r0
    293c:	002ad30f 	eoreq	sp, sl, pc, lsl #6
    2940:	01c00500 	biceq	r0, r0, r0, lsl #10
    2944:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2948:	2bf30f00 	blcs	ffcc6550 <__bss_end+0xffcbd514>
    294c:	c3050000 	movwgt	r0, #20480	; 0x5000
    2950:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2954:	310f0000 	mrscc	r0, CPSR
    2958:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    295c:	1d0c01c6 	stfnes	f0, [ip, #-792]	; 0xfffffce8
    2960:	0f000000 	svceq	0x00000000
    2964:	00001908 	andeq	r1, r0, r8, lsl #18
    2968:	0c01c905 			; <UNDEFINED> instruction: 0x0c01c905
    296c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2970:	001ddc0f 	andseq	sp, sp, pc, lsl #24
    2974:	01cc0500 	biceq	r0, ip, r0, lsl #10
    2978:	00001d0c 	andeq	r1, r0, ip, lsl #26
    297c:	1b0c0f00 	blne	306584 <__bss_end+0x2fd548>
    2980:	cf050000 	svcgt	0x00050000
    2984:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2988:	d80f0000 	stmdale	pc, {}	; <UNPREDICTABLE>
    298c:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    2990:	1d0c01d2 	stfnes	f0, [ip, #-840]	; 0xfffffcb8
    2994:	0f000000 	svceq	0x00000000
    2998:	0000205f 	andeq	r2, r0, pc, asr r0
    299c:	0c01d505 	cfstr32eq	mvfx13, [r1], {5}
    29a0:	0000001d 	andeq	r0, r0, sp, lsl r0
    29a4:	0022f70f 	eoreq	pc, r2, pc, lsl #14
    29a8:	01d80500 	bicseq	r0, r8, r0, lsl #10
    29ac:	00001d0c 	andeq	r1, r0, ip, lsl #26
    29b0:	28de0f00 	ldmcs	lr, {r8, r9, sl, fp}^
    29b4:	df050000 	svcle	0x00050000
    29b8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    29bc:	920f0000 	andls	r0, pc, #0
    29c0:	0500002b 	streq	r0, [r0, #-43]	; 0xffffffd5
    29c4:	1d0c01e2 	stfnes	f0, [ip, #-904]	; 0xfffffc78
    29c8:	0f000000 	svceq	0x00000000
    29cc:	00002ba2 	andeq	r2, r0, r2, lsr #23
    29d0:	0c01e505 	cfstr32eq	mvfx14, [r1], {5}
    29d4:	0000001d 	andeq	r0, r0, sp, lsl r0
    29d8:	001c2b0f 	andseq	r2, ip, pc, lsl #22
    29dc:	01e80500 	mvneq	r0, r0, lsl #10
    29e0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    29e4:	29250f00 	stmdbcs	r5!, {r8, r9, sl, fp}
    29e8:	eb050000 	bl	1429f0 <__bss_end+0x1399b4>
    29ec:	001d0c01 	andseq	r0, sp, r1, lsl #24
    29f0:	0f0f0000 	svceq	0x000f0000
    29f4:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    29f8:	1d0c01ee 	stfnes	f0, [ip, #-952]	; 0xfffffc48
    29fc:	0f000000 	svceq	0x00000000
    2a00:	00001e55 	andeq	r1, r0, r5, asr lr
    2a04:	0c01f205 	sfmeq	f7, 1, [r1], {5}
    2a08:	0000001d 	andeq	r0, r0, sp, lsl r0
    2a0c:	0026ca0f 	eoreq	ip, r6, pc, lsl #20
    2a10:	01fa0500 	mvnseq	r0, r0, lsl #10
    2a14:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2a18:	1d0e0f00 	stcne	15, cr0, [lr, #-0]
    2a1c:	fd050000 	stc2	0, cr0, [r5, #-0]
    2a20:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2a24:	1d0c0000 	stcne	0, cr0, [ip, #-0]
    2a28:	c6000000 	strgt	r0, [r0], -r0
    2a2c:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
    2a30:	1f3f0f00 	svcne	0x003f0f00
    2a34:	eb050000 	bl	142a3c <__bss_end+0x139a00>
    2a38:	08bb0c03 	ldmeq	fp!, {r0, r1, sl, fp}
    2a3c:	be0c0000 	cdplt	0, 0, cr0, cr12, cr0, {0}
    2a40:	e3000005 	movw	r0, #5
    2a44:	15000008 	strne	r0, [r0, #-8]
    2a48:	00000024 	andeq	r0, r0, r4, lsr #32
    2a4c:	0e0f000d 	cdpeq	0, 0, cr0, cr15, cr13, {0}
    2a50:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    2a54:	d3140574 	tstle	r4, #116, 10	; 0x1d000000
    2a58:	16000008 	strne	r0, [r0], -r8
    2a5c:	00002022 	andeq	r2, r0, r2, lsr #32
    2a60:	00930107 	addseq	r0, r3, r7, lsl #2
    2a64:	7b050000 	blvc	142a6c <__bss_end+0x139a30>
    2a68:	092e0605 	stmdbeq	lr!, {r0, r2, r9, sl}
    2a6c:	9e0b0000 	cdpls	0, 0, cr0, cr11, cr0, {0}
    2a70:	0000001d 	andeq	r0, r0, sp, lsl r0
    2a74:	0022570b 	eoreq	r5, r2, fp, lsl #14
    2a78:	ad0b0100 	stfges	f0, [fp, #-0]
    2a7c:	02000019 	andeq	r0, r0, #25
    2a80:	002b540b 	eoreq	r5, fp, fp, lsl #8
    2a84:	9a0b0300 	bls	2c368c <__bss_end+0x2ba650>
    2a88:	04000025 	streq	r0, [r0], #-37	; 0xffffffdb
    2a8c:	00258d0b 	eoreq	r8, r5, fp, lsl #26
    2a90:	a00b0500 	andge	r0, fp, r0, lsl #10
    2a94:	0600001a 			; <UNDEFINED> instruction: 0x0600001a
    2a98:	2b440f00 	blcs	11066a0 <__bss_end+0x10fd664>
    2a9c:	88050000 	stmdahi	r5, {}	; <UNPREDICTABLE>
    2aa0:	08f01505 	ldmeq	r0!, {r0, r2, r8, sl, ip}^
    2aa4:	200f0000 	andcs	r0, pc, r0
    2aa8:	0500002a 	streq	r0, [r0, #-42]	; 0xffffffd6
    2aac:	24110789 	ldrcs	r0, [r1], #-1929	; 0xfffff877
    2ab0:	0f000000 	svceq	0x00000000
    2ab4:	000024fb 	strdeq	r2, [r0], -fp
    2ab8:	0c079e05 	stceq	14, cr9, [r7], {5}
    2abc:	0000001d 	andeq	r0, r0, sp, lsl r0
    2ac0:	0028cd04 	eoreq	ip, r8, r4, lsl #26
    2ac4:	167b0600 	ldrbtne	r0, [fp], -r0, lsl #12
    2ac8:	00000093 	muleq	r0, r3, r0
    2acc:	0009550e 	andeq	r5, r9, lr, lsl #10
    2ad0:	05020300 	streq	r0, [r2, #-768]	; 0xfffffd00
    2ad4:	00000e14 	andeq	r0, r0, r4, lsl lr
    2ad8:	f7070803 			; <UNDEFINED> instruction: 0xf7070803
    2adc:	0300001c 	movweq	r0, #28
    2ae0:	1b4c0404 	blne	1303af8 <__bss_end+0x12faabc>
    2ae4:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2ae8:	001b4403 	andseq	r4, fp, r3, lsl #8
    2aec:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    2af0:	000024a7 	andeq	r2, r0, r7, lsr #9
    2af4:	e2031003 	and	r1, r3, #3
    2af8:	0c000025 	stceq	0, cr0, [r0], {37}	; 0x25
    2afc:	00000961 	andeq	r0, r0, r1, ror #18
    2b00:	000009a0 	andeq	r0, r0, r0, lsr #19
    2b04:	00002415 	andeq	r2, r0, r5, lsl r4
    2b08:	0e00ff00 	cdpeq	15, 0, cr15, cr0, cr0, {0}
    2b0c:	00000990 	muleq	r0, r0, r9
    2b10:	0023b90f 	eoreq	fp, r3, pc, lsl #18
    2b14:	01fc0600 	mvnseq	r0, r0, lsl #12
    2b18:	0009a016 	andeq	sl, r9, r6, lsl r0
    2b1c:	1afb0f00 	bne	ffec6724 <__bss_end+0xffebd6e8>
    2b20:	02060000 	andeq	r0, r6, #0
    2b24:	09a01602 	stmibeq	r0!, {r1, r9, sl, ip}
    2b28:	f0040000 			; <UNDEFINED> instruction: 0xf0040000
    2b2c:	07000028 	streq	r0, [r0, -r8, lsr #32]
    2b30:	05d1102a 	ldrbeq	r1, [r1, #42]	; 0x2a
    2b34:	bf0c0000 	svclt	0x000c0000
    2b38:	d6000009 	strle	r0, [r0], -r9
    2b3c:	0d000009 	stceq	0, cr0, [r0, #-36]	; 0xffffffdc
    2b40:	037a0900 	cmneq	sl, #0, 18
    2b44:	2f070000 	svccs	0x00070000
    2b48:	0009cb11 	andeq	ip, r9, r1, lsl fp
    2b4c:	023c0900 	eorseq	r0, ip, #0, 18
    2b50:	30070000 	andcc	r0, r7, r0
    2b54:	0009cb11 	andeq	ip, r9, r1, lsl fp
    2b58:	09d61700 	ldmibeq	r6, {r8, r9, sl, ip}^
    2b5c:	36080000 	strcc	r0, [r8], -r0
    2b60:	03050a09 	movweq	r0, #23049	; 0x5a09
    2b64:	00009021 	andeq	r9, r0, r1, lsr #32
    2b68:	0009e217 	andeq	lr, r9, r7, lsl r2
    2b6c:	09370800 	ldmdbeq	r7!, {fp}
    2b70:	2103050a 	tstcs	r3, sl, lsl #10
    2b74:	00000090 	muleq	r0, r0, r0

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x377bd8>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb9ce0>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9d00>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9d18>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <__bss_end+0x54>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7a858>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39d3c>
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
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x377c80>
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
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf79cdc>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c58f4>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7a8dc>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe39dc0>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <shift+0x16c>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9dd4>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__bss_end+0x124>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7a914>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe39df8>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeb9e08>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x377d90>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c5980>
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
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c5994>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x377dc4>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf79dd4>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 1e8:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 1ec:	0b0b0024 	bleq	2c0284 <__bss_end+0x2b7248>
 1f0:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 1f4:	16050000 	strne	r0, [r5], -r0
 1f8:	3a0e0300 	bcc	380e00 <__bss_end+0x377dc4>
 1fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 200:	0013490b 	andseq	r4, r3, fp, lsl #18
 204:	00350600 	eorseq	r0, r5, r0, lsl #12
 208:	00001349 	andeq	r1, r0, r9, asr #6
 20c:	03011307 	movweq	r1, #4871	; 0x1307
 210:	3a0b0b0e 	bcc	2c2e50 <__bss_end+0x2b9e14>
 214:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 218:	0013010b 	andseq	r0, r3, fp, lsl #2
 21c:	000d0800 	andeq	r0, sp, r0, lsl #16
 220:	0b3a0803 	bleq	e82234 <__bss_end+0xe791f8>
 224:	0b390b3b 	bleq	e42f18 <__bss_end+0xe39edc>
 228:	0b381349 	bleq	e04f54 <__bss_end+0xdfbf18>
 22c:	04090000 	streq	r0, [r9], #-0
 230:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 234:	0b0b3e19 	bleq	2cfaa0 <__bss_end+0x2c6a64>
 238:	3a13490b 	bcc	4d266c <__bss_end+0x4c9630>
 23c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 240:	0013010b 	andseq	r0, r3, fp, lsl #2
 244:	00280a00 	eoreq	r0, r8, r0, lsl #20
 248:	0b1c0e03 	bleq	703a5c <__bss_end+0x6faa20>
 24c:	340b0000 	strcc	r0, [fp], #-0
 250:	3a0e0300 	bcc	380e58 <__bss_end+0x377e1c>
 254:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 258:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 25c:	00180219 	andseq	r0, r8, r9, lsl r2
 260:	00020c00 	andeq	r0, r2, r0, lsl #24
 264:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 268:	020d0000 	andeq	r0, sp, #0
 26c:	0b0e0301 	bleq	380e78 <__bss_end+0x377e3c>
 270:	3b0b3a0b 	blcc	2ceaa4 <__bss_end+0x2c5a68>
 274:	010b390b 	tsteq	fp, fp, lsl #18
 278:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 27c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 280:	0b3b0b3a 	bleq	ec2f70 <__bss_end+0xeb9f34>
 284:	13490b39 	movtne	r0, #39737	; 0x9b39
 288:	00000b38 	andeq	r0, r0, r8, lsr fp
 28c:	3f012e0f 	svccc	0x00012e0f
 290:	3a0e0319 	bcc	380efc <__bss_end+0x377ec0>
 294:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 298:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 29c:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 2a0:	10000013 	andne	r0, r0, r3, lsl r0
 2a4:	13490005 	movtne	r0, #36869	; 0x9005
 2a8:	00001934 	andeq	r1, r0, r4, lsr r9
 2ac:	49000511 	stmdbmi	r0, {r0, r4, r8, sl}
 2b0:	12000013 	andne	r0, r0, #19
 2b4:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 2b8:	0b3b0b3a 	bleq	ec2fa8 <__bss_end+0xeb9f6c>
 2bc:	13490b39 	movtne	r0, #39737	; 0x9b39
 2c0:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 2c4:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 2c8:	03193f01 	tsteq	r9, #1, 30
 2cc:	3b0b3a0e 	blcc	2ceb0c <__bss_end+0x2c5ad0>
 2d0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2d4:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 2d8:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 2dc:	00130113 	andseq	r0, r3, r3, lsl r1
 2e0:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 2e4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2e8:	0b3b0b3a 	bleq	ec2fd8 <__bss_end+0xeb9f9c>
 2ec:	0e6e0b39 	vmoveq.8	d14[5], r0
 2f0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 2f4:	13011364 	movwne	r1, #4964	; 0x1364
 2f8:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 2fc:	03193f01 	tsteq	r9, #1, 30
 300:	3b0b3a0e 	blcc	2ceb40 <__bss_end+0x2c5b04>
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
 338:	0b3b0b3a 	bleq	ec3028 <__bss_end+0xeb9fec>
 33c:	13490b39 	movtne	r0, #39737	; 0x9b39
 340:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 344:	281b0000 	ldmdacs	fp, {}	; <UNPREDICTABLE>
 348:	1c080300 	stcne	3, cr0, [r8], {-0}
 34c:	1c00000b 	stcne	0, cr0, [r0], {11}
 350:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 354:	0b3a0e03 	bleq	e83b68 <__bss_end+0xe7ab2c>
 358:	0b390b3b 	bleq	e4304c <__bss_end+0xe3a010>
 35c:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 360:	13011364 	movwne	r1, #4964	; 0x1364
 364:	2e1d0000 	cdpcs	0, 1, cr0, cr13, cr0, {0}
 368:	03193f01 	tsteq	r9, #1, 30
 36c:	3b0b3a0e 	blcc	2cebac <__bss_end+0x2c5b70>
 370:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 374:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 378:	01136419 	tsteq	r3, r9, lsl r4
 37c:	1e000013 	mcrne	0, 0, r0, cr0, cr3, {0}
 380:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 384:	0b3b0b3a 	bleq	ec3074 <__bss_end+0xeba038>
 388:	13490b39 	movtne	r0, #39737	; 0x9b39
 38c:	0b320b38 	bleq	c83074 <__bss_end+0xc7a038>
 390:	151f0000 	ldrne	r0, [pc, #-0]	; 398 <shift+0x398>
 394:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
 398:	00130113 	andseq	r0, r3, r3, lsl r1
 39c:	001f2000 	andseq	r2, pc, r0
 3a0:	1349131d 	movtne	r1, #37661	; 0x931d
 3a4:	10210000 	eorne	r0, r1, r0
 3a8:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 3ac:	22000013 	andcs	r0, r0, #19
 3b0:	0b0b000f 	bleq	2c03f4 <__bss_end+0x2b73b8>
 3b4:	39230000 	stmdbcc	r3!, {}	; <UNPREDICTABLE>
 3b8:	3a080301 	bcc	200fc4 <__bss_end+0x1f7f88>
 3bc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3c0:	0013010b 	andseq	r0, r3, fp, lsl #2
 3c4:	00342400 	eorseq	r2, r4, r0, lsl #8
 3c8:	0b3a0e03 	bleq	e83bdc <__bss_end+0xe7aba0>
 3cc:	0b390b3b 	bleq	e430c0 <__bss_end+0xe3a084>
 3d0:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 3d4:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
 3d8:	34250000 	strtcc	r0, [r5], #-0
 3dc:	3a0e0300 	bcc	380fe4 <__bss_end+0x377fa8>
 3e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3e4:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 3e8:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 3ec:	26000019 			; <UNDEFINED> instruction: 0x26000019
 3f0:	13470034 	movtne	r0, #28724	; 0x7034
 3f4:	2e270000 	cdpcs	0, 2, cr0, cr7, cr0, {0}
 3f8:	03193f01 	tsteq	r9, #1, 30
 3fc:	3b0b3a0e 	blcc	2cec3c <__bss_end+0x2c5c00>
 400:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 404:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 408:	00136419 	andseq	r6, r3, r9, lsl r4
 40c:	00342800 	eorseq	r2, r4, r0, lsl #16
 410:	0b3a0e03 	bleq	e83c24 <__bss_end+0xe7abe8>
 414:	0b390b3b 	bleq	e43108 <__bss_end+0xe3a0cc>
 418:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 41c:	00001802 	andeq	r1, r0, r2, lsl #16
 420:	3f012e29 	svccc	0x00012e29
 424:	3a0e0319 	bcc	381090 <__bss_end+0x378054>
 428:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 42c:	1113490b 	tstne	r3, fp, lsl #18
 430:	40061201 	andmi	r1, r6, r1, lsl #4
 434:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 438:	00001301 	andeq	r1, r0, r1, lsl #6
 43c:	0300052a 	movweq	r0, #1322	; 0x52a
 440:	3b0b3a0e 	blcc	2cec80 <__bss_end+0x2c5c44>
 444:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 448:	00180213 	andseq	r0, r8, r3, lsl r2
 44c:	00342b00 	eorseq	r2, r4, r0, lsl #22
 450:	0b3a0e03 	bleq	e83c64 <__bss_end+0xe7ac28>
 454:	0b390b3b 	bleq	e43148 <__bss_end+0xe3a10c>
 458:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 45c:	2e2c0000 	cdpcs	0, 2, cr0, cr12, cr0, {0}
 460:	03193f01 	tsteq	r9, #1, 30
 464:	3b0b3a0e 	blcc	2ceca4 <__bss_end+0x2c5c68>
 468:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 46c:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 470:	96184006 	ldrls	r4, [r8], -r6
 474:	00001942 	andeq	r1, r0, r2, asr #18
 478:	01110100 	tsteq	r1, r0, lsl #2
 47c:	0b130e25 	bleq	4c3d18 <__bss_end+0x4bacdc>
 480:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 484:	06120111 			; <UNDEFINED> instruction: 0x06120111
 488:	00001710 	andeq	r1, r0, r0, lsl r7
 48c:	0b002402 	bleq	949c <__bss_end+0x460>
 490:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 494:	0300000e 	movweq	r0, #14
 498:	13490026 	movtne	r0, #36902	; 0x9026
 49c:	24040000 	strcs	r0, [r4], #-0
 4a0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 4a4:	0008030b 	andeq	r0, r8, fp, lsl #6
 4a8:	00160500 	andseq	r0, r6, r0, lsl #10
 4ac:	0b3a0e03 	bleq	e83cc0 <__bss_end+0xe7ac84>
 4b0:	0b390b3b 	bleq	e431a4 <__bss_end+0xe3a168>
 4b4:	00001349 	andeq	r1, r0, r9, asr #6
 4b8:	03011306 	movweq	r1, #4870	; 0x1306
 4bc:	3a0b0b0e 	bcc	2c30fc <__bss_end+0x2ba0c0>
 4c0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4c4:	0013010b 	andseq	r0, r3, fp, lsl #2
 4c8:	000d0700 	andeq	r0, sp, r0, lsl #14
 4cc:	0b3a0803 	bleq	e824e0 <__bss_end+0xe794a4>
 4d0:	0b390b3b 	bleq	e431c4 <__bss_end+0xe3a188>
 4d4:	0b381349 	bleq	e05200 <__bss_end+0xdfc1c4>
 4d8:	04080000 	streq	r0, [r8], #-0
 4dc:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 4e0:	0b0b3e19 	bleq	2cfd4c <__bss_end+0x2c6d10>
 4e4:	3a13490b 	bcc	4d2918 <__bss_end+0x4c98dc>
 4e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4ec:	0013010b 	andseq	r0, r3, fp, lsl #2
 4f0:	00280900 	eoreq	r0, r8, r0, lsl #18
 4f4:	0b1c0803 	bleq	702508 <__bss_end+0x6f94cc>
 4f8:	280a0000 	stmdacs	sl, {}	; <UNPREDICTABLE>
 4fc:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 500:	0b00000b 	bleq	534 <shift+0x534>
 504:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 508:	0b3b0b3a 	bleq	ec31f8 <__bss_end+0xeba1bc>
 50c:	13490b39 	movtne	r0, #39737	; 0x9b39
 510:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 514:	020c0000 	andeq	r0, ip, #0
 518:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 51c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 520:	0e030102 	adfeqs	f0, f3, f2
 524:	0b3a0b0b 	bleq	e83158 <__bss_end+0xe7a11c>
 528:	0b390b3b 	bleq	e4321c <__bss_end+0xe3a1e0>
 52c:	00001301 	andeq	r1, r0, r1, lsl #6
 530:	03000d0e 	movweq	r0, #3342	; 0xd0e
 534:	3b0b3a0e 	blcc	2ced74 <__bss_end+0x2c5d38>
 538:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 53c:	000b3813 	andeq	r3, fp, r3, lsl r8
 540:	012e0f00 			; <UNDEFINED> instruction: 0x012e0f00
 544:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 548:	0b3b0b3a 	bleq	ec3238 <__bss_end+0xeba1fc>
 54c:	0e6e0b39 	vmoveq.8	d14[5], r0
 550:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 554:	00001364 	andeq	r1, r0, r4, ror #6
 558:	49000510 	stmdbmi	r0, {r4, r8, sl}
 55c:	00193413 	andseq	r3, r9, r3, lsl r4
 560:	00051100 	andeq	r1, r5, r0, lsl #2
 564:	00001349 	andeq	r1, r0, r9, asr #6
 568:	03000d12 	movweq	r0, #3346	; 0xd12
 56c:	3b0b3a0e 	blcc	2cedac <__bss_end+0x2c5d70>
 570:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 574:	3c193f13 	ldccc	15, cr3, [r9], {19}
 578:	13000019 	movwne	r0, #25
 57c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 580:	0b3a0e03 	bleq	e83d94 <__bss_end+0xe7ad58>
 584:	0b390b3b 	bleq	e43278 <__bss_end+0xe3a23c>
 588:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 58c:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 590:	13011364 	movwne	r1, #4964	; 0x1364
 594:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 598:	03193f01 	tsteq	r9, #1, 30
 59c:	3b0b3a0e 	blcc	2ceddc <__bss_end+0x2c5da0>
 5a0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 5a4:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 5a8:	01136419 	tsteq	r3, r9, lsl r4
 5ac:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 5b0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 5b4:	0b3a0e03 	bleq	e83dc8 <__bss_end+0xe7ad8c>
 5b8:	0b390b3b 	bleq	e432ac <__bss_end+0xe3a270>
 5bc:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 5c0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 5c4:	00001364 	andeq	r1, r0, r4, ror #6
 5c8:	49010116 	stmdbmi	r1, {r1, r2, r4, r8}
 5cc:	00130113 	andseq	r0, r3, r3, lsl r1
 5d0:	00211700 	eoreq	r1, r1, r0, lsl #14
 5d4:	0b2f1349 	bleq	bc5300 <__bss_end+0xbbc2c4>
 5d8:	0f180000 	svceq	0x00180000
 5dc:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 5e0:	19000013 	stmdbne	r0, {r0, r1, r4}
 5e4:	00000021 	andeq	r0, r0, r1, lsr #32
 5e8:	0300341a 	movweq	r3, #1050	; 0x41a
 5ec:	3b0b3a0e 	blcc	2cee2c <__bss_end+0x2c5df0>
 5f0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 5f4:	3c193f13 	ldccc	15, cr3, [r9], {19}
 5f8:	1b000019 	blne	664 <shift+0x664>
 5fc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 600:	0b3a0e03 	bleq	e83e14 <__bss_end+0xe7add8>
 604:	0b390b3b 	bleq	e432f8 <__bss_end+0xe3a2bc>
 608:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 60c:	13011364 	movwne	r1, #4964	; 0x1364
 610:	2e1c0000 	cdpcs	0, 1, cr0, cr12, cr0, {0}
 614:	03193f01 	tsteq	r9, #1, 30
 618:	3b0b3a0e 	blcc	2cee58 <__bss_end+0x2c5e1c>
 61c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 620:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 624:	01136419 	tsteq	r3, r9, lsl r4
 628:	1d000013 	stcne	0, cr0, [r0, #-76]	; 0xffffffb4
 62c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 630:	0b3b0b3a 	bleq	ec3320 <__bss_end+0xeba2e4>
 634:	13490b39 	movtne	r0, #39737	; 0x9b39
 638:	0b320b38 	bleq	c83320 <__bss_end+0xc7a2e4>
 63c:	151e0000 	ldrne	r0, [lr, #-0]
 640:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
 644:	00130113 	andseq	r0, r3, r3, lsl r1
 648:	001f1f00 	andseq	r1, pc, r0, lsl #30
 64c:	1349131d 	movtne	r1, #37661	; 0x931d
 650:	10200000 	eorne	r0, r0, r0
 654:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 658:	21000013 	tstcs	r0, r3, lsl r0
 65c:	0b0b000f 	bleq	2c06a0 <__bss_end+0x2b7664>
 660:	34220000 	strtcc	r0, [r2], #-0
 664:	3a0e0300 	bcc	38126c <__bss_end+0x378230>
 668:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 66c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 670:	23000018 	movwcs	r0, #24
 674:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 678:	0b3a0e03 	bleq	e83e8c <__bss_end+0xe7ae50>
 67c:	0b390b3b 	bleq	e43370 <__bss_end+0xe3a334>
 680:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 684:	06120111 			; <UNDEFINED> instruction: 0x06120111
 688:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 68c:	00130119 	andseq	r0, r3, r9, lsl r1
 690:	00052400 	andeq	r2, r5, r0, lsl #8
 694:	0b3a0e03 	bleq	e83ea8 <__bss_end+0xe7ae6c>
 698:	0b390b3b 	bleq	e4338c <__bss_end+0xe3a350>
 69c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 6a0:	2e250000 	cdpcs	0, 2, cr0, cr5, cr0, {0}
 6a4:	03193f01 	tsteq	r9, #1, 30
 6a8:	3b0b3a0e 	blcc	2ceee8 <__bss_end+0x2c5eac>
 6ac:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6b0:	1113490e 	tstne	r3, lr, lsl #18
 6b4:	40061201 	andmi	r1, r6, r1, lsl #4
 6b8:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6bc:	00001301 	andeq	r1, r0, r1, lsl #6
 6c0:	03003426 	movweq	r3, #1062	; 0x426
 6c4:	3b0b3a08 	blcc	2ceeec <__bss_end+0x2c5eb0>
 6c8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 6cc:	00180213 	andseq	r0, r8, r3, lsl r2
 6d0:	012e2700 			; <UNDEFINED> instruction: 0x012e2700
 6d4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 6d8:	0b3b0b3a 	bleq	ec33c8 <__bss_end+0xeba38c>
 6dc:	0e6e0b39 	vmoveq.8	d14[5], r0
 6e0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 6e4:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 6e8:	00130119 	andseq	r0, r3, r9, lsl r1
 6ec:	002e2800 	eoreq	r2, lr, r0, lsl #16
 6f0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 6f4:	0b3b0b3a 	bleq	ec33e4 <__bss_end+0xeba3a8>
 6f8:	0e6e0b39 	vmoveq.8	d14[5], r0
 6fc:	06120111 			; <UNDEFINED> instruction: 0x06120111
 700:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 704:	29000019 	stmdbcs	r0, {r0, r3, r4}
 708:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 70c:	0b3a0e03 	bleq	e83f20 <__bss_end+0xe7aee4>
 710:	0b390b3b 	bleq	e43404 <__bss_end+0xe3a3c8>
 714:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 718:	06120111 			; <UNDEFINED> instruction: 0x06120111
 71c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 720:	00000019 	andeq	r0, r0, r9, lsl r0
 724:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 728:	030b130e 	movweq	r1, #45838	; 0xb30e
 72c:	110e1b0e 	tstne	lr, lr, lsl #22
 730:	10061201 	andne	r1, r6, r1, lsl #4
 734:	02000017 	andeq	r0, r0, #23
 738:	13010139 	movwne	r0, #4409	; 0x1139
 73c:	34030000 	strcc	r0, [r3], #-0
 740:	3a0e0300 	bcc	381348 <__bss_end+0x37830c>
 744:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 748:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 74c:	000a1c19 	andeq	r1, sl, r9, lsl ip
 750:	003a0400 	eorseq	r0, sl, r0, lsl #8
 754:	0b3b0b3a 	bleq	ec3444 <__bss_end+0xeba408>
 758:	13180b39 	tstne	r8, #58368	; 0xe400
 75c:	01050000 	mrseq	r0, (UNDEF: 5)
 760:	01134901 	tsteq	r3, r1, lsl #18
 764:	06000013 			; <UNDEFINED> instruction: 0x06000013
 768:	13490021 	movtne	r0, #36897	; 0x9021
 76c:	00000b2f 	andeq	r0, r0, pc, lsr #22
 770:	49002607 	stmdbmi	r0, {r0, r1, r2, r9, sl, sp}
 774:	08000013 	stmdaeq	r0, {r0, r1, r4}
 778:	0b0b0024 	bleq	2c0810 <__bss_end+0x2b77d4>
 77c:	0e030b3e 	vmoveq.16	d3[0], r0
 780:	34090000 	strcc	r0, [r9], #-0
 784:	00134700 	andseq	r4, r3, r0, lsl #14
 788:	012e0a00 			; <UNDEFINED> instruction: 0x012e0a00
 78c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 790:	0b3b0b3a 	bleq	ec3480 <__bss_end+0xeba444>
 794:	0e6e0b39 	vmoveq.8	d14[5], r0
 798:	06120111 			; <UNDEFINED> instruction: 0x06120111
 79c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 7a0:	00130119 	andseq	r0, r3, r9, lsl r1
 7a4:	00050b00 	andeq	r0, r5, r0, lsl #22
 7a8:	0b3a0803 	bleq	e827bc <__bss_end+0xe79780>
 7ac:	0b390b3b 	bleq	e434a0 <__bss_end+0xe3a464>
 7b0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 7b4:	340c0000 	strcc	r0, [ip], #-0
 7b8:	3a0e0300 	bcc	3813c0 <__bss_end+0x378384>
 7bc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7c0:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 7c4:	0d000018 	stceq	0, cr0, [r0, #-96]	; 0xffffffa0
 7c8:	0111010b 	tsteq	r1, fp, lsl #2
 7cc:	00000612 	andeq	r0, r0, r2, lsl r6
 7d0:	0300340e 	movweq	r3, #1038	; 0x40e
 7d4:	3b0b3a08 	blcc	2ceffc <__bss_end+0x2c5fc0>
 7d8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 7dc:	00180213 	andseq	r0, r8, r3, lsl r2
 7e0:	000f0f00 	andeq	r0, pc, r0, lsl #30
 7e4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 7e8:	26100000 	ldrcs	r0, [r0], -r0
 7ec:	11000000 	mrsne	r0, (UNDEF: 0)
 7f0:	0b0b000f 	bleq	2c0834 <__bss_end+0x2b77f8>
 7f4:	24120000 	ldrcs	r0, [r2], #-0
 7f8:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 7fc:	0008030b 	andeq	r0, r8, fp, lsl #6
 800:	00051300 	andeq	r1, r5, r0, lsl #6
 804:	0b3a0e03 	bleq	e84018 <__bss_end+0xe7afdc>
 808:	0b390b3b 	bleq	e434fc <__bss_end+0xe3a4c0>
 80c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 810:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 814:	03193f01 	tsteq	r9, #1, 30
 818:	3b0b3a0e 	blcc	2cf058 <__bss_end+0x2c601c>
 81c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 820:	1113490e 	tstne	r3, lr, lsl #18
 824:	40061201 	andmi	r1, r6, r1, lsl #4
 828:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 82c:	00001301 	andeq	r1, r0, r1, lsl #6
 830:	3f012e15 	svccc	0x00012e15
 834:	3a0e0319 	bcc	3814a0 <__bss_end+0x378464>
 838:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 83c:	110e6e0b 	tstne	lr, fp, lsl #28
 840:	40061201 	andmi	r1, r6, r1, lsl #4
 844:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 848:	01000000 	mrseq	r0, (UNDEF: 0)
 84c:	06100011 			; <UNDEFINED> instruction: 0x06100011
 850:	01120111 	tsteq	r2, r1, lsl r1
 854:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 858:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 85c:	01000000 	mrseq	r0, (UNDEF: 0)
 860:	06100011 			; <UNDEFINED> instruction: 0x06100011
 864:	01120111 	tsteq	r2, r1, lsl r1
 868:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 86c:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 870:	01000000 	mrseq	r0, (UNDEF: 0)
 874:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 878:	0e030b13 	vmoveq.32	d3[0], r0
 87c:	17100e1b 			; <UNDEFINED> instruction: 0x17100e1b
 880:	24020000 	strcs	r0, [r2], #-0
 884:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 888:	0008030b 	andeq	r0, r8, fp, lsl #6
 88c:	00240300 	eoreq	r0, r4, r0, lsl #6
 890:	0b3e0b0b 	bleq	f834c4 <__bss_end+0xf7a488>
 894:	00000e03 	andeq	r0, r0, r3, lsl #28
 898:	03001604 	movweq	r1, #1540	; 0x604
 89c:	3b0b3a0e 	blcc	2cf0dc <__bss_end+0x2c60a0>
 8a0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 8a4:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 8a8:	0b0b000f 	bleq	2c08ec <__bss_end+0x2b78b0>
 8ac:	00001349 	andeq	r1, r0, r9, asr #6
 8b0:	27011506 	strcs	r1, [r1, -r6, lsl #10]
 8b4:	01134919 	tsteq	r3, r9, lsl r9
 8b8:	07000013 	smladeq	r0, r3, r0, r0
 8bc:	13490005 	movtne	r0, #36869	; 0x9005
 8c0:	26080000 	strcs	r0, [r8], -r0
 8c4:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
 8c8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 8cc:	0b3b0b3a 	bleq	ec35bc <__bss_end+0xeba580>
 8d0:	13490b39 	movtne	r0, #39737	; 0x9b39
 8d4:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 8d8:	040a0000 	streq	r0, [sl], #-0
 8dc:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 8e0:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 8e4:	3b0b3a13 	blcc	2cf138 <__bss_end+0x2c60fc>
 8e8:	010b390b 	tsteq	fp, fp, lsl #18
 8ec:	0b000013 	bleq	940 <shift+0x940>
 8f0:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 8f4:	00000b1c 	andeq	r0, r0, ip, lsl fp
 8f8:	4901010c 	stmdbmi	r1, {r2, r3, r8}
 8fc:	00130113 	andseq	r0, r3, r3, lsl r1
 900:	00210d00 	eoreq	r0, r1, r0, lsl #26
 904:	260e0000 	strcs	r0, [lr], -r0
 908:	00134900 	andseq	r4, r3, r0, lsl #18
 90c:	00340f00 	eorseq	r0, r4, r0, lsl #30
 910:	0b3a0e03 	bleq	e84124 <__bss_end+0xe7b0e8>
 914:	0b39053b 	bleq	e41e08 <__bss_end+0xe38dcc>
 918:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 91c:	0000193c 	andeq	r1, r0, ip, lsr r9
 920:	03001310 	movweq	r1, #784	; 0x310
 924:	00193c0e 	andseq	r3, r9, lr, lsl #24
 928:	00151100 	andseq	r1, r5, r0, lsl #2
 92c:	00001927 	andeq	r1, r0, r7, lsr #18
 930:	03001712 	movweq	r1, #1810	; 0x712
 934:	00193c0e 	andseq	r3, r9, lr, lsl #24
 938:	01131300 	tsteq	r3, r0, lsl #6
 93c:	0b0b0e03 	bleq	2c4150 <__bss_end+0x2bb114>
 940:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 944:	13010b39 	movwne	r0, #6969	; 0x1b39
 948:	0d140000 	ldceq	0, cr0, [r4, #-0]
 94c:	3a0e0300 	bcc	381554 <__bss_end+0x378518>
 950:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 954:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 958:	1500000b 	strne	r0, [r0, #-11]
 95c:	13490021 	movtne	r0, #36897	; 0x9021
 960:	00000b2f 	andeq	r0, r0, pc, lsr #22
 964:	03010416 	movweq	r0, #5142	; 0x1416
 968:	0b0b3e0e 	bleq	2d01a8 <__bss_end+0x2c716c>
 96c:	3a13490b 	bcc	4d2da0 <__bss_end+0x4c9d64>
 970:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 974:	0013010b 	andseq	r0, r3, fp, lsl #2
 978:	00341700 	eorseq	r1, r4, r0, lsl #14
 97c:	0b3a1347 	bleq	e856a0 <__bss_end+0xe7c664>
 980:	0b39053b 	bleq	e41e74 <__bss_end+0xe38e38>
 984:	00001802 	andeq	r1, r0, r2, lsl #16
	...

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
  74:	000001ec 	andeq	r0, r0, ip, ror #3
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	11120002 	tstne	r2, r2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008420 	andeq	r8, r0, r0, lsr #8
  94:	00000460 	andeq	r0, r0, r0, ror #8
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	1ded0002 	stclne	0, cr0, [sp, #8]!
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008880 	andeq	r8, r0, r0, lsl #17
  b4:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	211f0002 	tstcs	pc, r2
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00008d38 	andeq	r8, r0, r8, lsr sp
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	21450002 	cmpcs	r5, r2
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00008f44 	andeq	r8, r0, r4, asr #30
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	216b0002 	cmncs	fp, r2
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff6f10>
       4:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
       8:	6b69746e 	blvs	1a5d1c8 <__bss_end+0x1a5418c>
       c:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
      10:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
      14:	4f54522d 	svcmi	0x0054522d
      18:	616d2d53 	cmnvs	sp, r3, asr sp
      1c:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
      20:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffcf9 <__bss_end+0xffff6cbd>
      24:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
      28:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
      2c:	61707372 	cmnvs	r0, r2, ror r3
      30:	632f6563 			; <UNDEFINED> instruction: 0x632f6563
      34:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
      38:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
      3c:	2f656d6f 	svccs	0x00656d6f
      40:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
      44:	642f6b69 	strtvs	r6, [pc], #-2921	; 4c <shift+0x4c>
      48:	4b2f7665 	blmi	bdd9e4 <__bss_end+0xbd49a8>
      4c:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
      50:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
      54:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
      58:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
      5c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
      60:	752f7365 	strvc	r7, [pc, #-869]!	; fffffd03 <__bss_end+0xffff6cc7>
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
     268:	2b2b4320 	blcs	ad0ef0 <__bss_end+0xac7eb4>
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
     2fc:	6a363731 	bvs	d8dfc8 <__bss_end+0xd84f8c>
     300:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     304:	616d2d20 	cmnvs	sp, r0, lsr #26
     308:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     30c:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     310:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     314:	7a36766d 	bvc	d9dcd0 <__bss_end+0xd94c94>
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
     3e4:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     3e8:	5f676e69 	svcpl	0x00676e69
     3ec:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     3f0:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     3f4:	735f6465 	cmpvc	pc, #1694498816	; 0x65000000
     3f8:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     3fc:	72705f63 	rsbsvc	r5, r0, #396	; 0x18c
     400:	69726f69 	ldmdbvs	r2!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     404:	5f007974 	svcpl	0x00007974
     408:	314b4e5a 	cmpcc	fp, sl, asr lr
     40c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     410:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     414:	614d5f73 	hvcvs	54771	; 0xd5f3
     418:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     41c:	47383172 			; <UNDEFINED> instruction: 0x47383172
     420:	505f7465 	subspl	r7, pc, r5, ror #8
     424:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     428:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
     42c:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     430:	006a4544 	rsbeq	r4, sl, r4, asr #10
     434:	314e5a5f 	cmpcc	lr, pc, asr sl
     438:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     43c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     440:	614d5f73 	hvcvs	54771	; 0xd5f3
     444:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     448:	4d393172 	ldfmis	f3, [r9, #-456]!	; 0xfffffe38
     44c:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     450:	5f656c69 	svcpl	0x00656c69
     454:	435f6f54 	cmpmi	pc, #84, 30	; 0x150
     458:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     45c:	5045746e 	subpl	r7, r5, lr, ror #8
     460:	69464935 	stmdbvs	r6, {r0, r2, r4, r5, r8, fp, lr}^
     464:	5500656c 	strpl	r6, [r0, #-1388]	; 0xfffffa94
     468:	70616d6e 	rsbvc	r6, r1, lr, ror #26
     46c:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     470:	75435f65 	strbvc	r5, [r3, #-3941]	; 0xfffff09b
     474:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     478:	5a5f0074 	bpl	17c0650 <__bss_end+0x17b7614>
     47c:	33314b4e 	teqcc	r1, #79872	; 0x13800
     480:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     484:	61485f4f 	cmpvs	r8, pc, asr #30
     488:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     48c:	47383172 			; <UNDEFINED> instruction: 0x47383172
     490:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     494:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
     498:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     49c:	6f697461 	svcvs	0x00697461
     4a0:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     4a4:	5f30536a 	svcpl	0x0030536a
     4a8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     4ac:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     4b0:	5f4f4950 	svcpl	0x004f4950
     4b4:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     4b8:	3172656c 	cmncc	r2, ip, ror #10
     4bc:	73655231 	cmnvc	r5, #268435459	; 0x10000003
     4c0:	65767265 	ldrbvs	r7, [r6, #-613]!	; 0xfffffd9b
     4c4:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     4c8:	62626a45 	rsbvs	r6, r2, #282624	; 0x45000
     4cc:	69786500 	ldmdbvs	r8!, {r8, sl, sp, lr}^
     4d0:	6f635f74 	svcvs	0x00635f74
     4d4:	67006564 	strvs	r6, [r0, -r4, ror #10]
     4d8:	445f5346 	ldrbmi	r5, [pc], #-838	; 4e0 <shift+0x4e0>
     4dc:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     4e0:	48007372 	stmdami	r0, {r1, r4, r5, r6, r8, r9, ip, sp, lr}
     4e4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     4e8:	72505f65 	subsvc	r5, r0, #404	; 0x194
     4ec:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4f0:	57535f73 			; <UNDEFINED> instruction: 0x57535f73
     4f4:	65470049 	strbvs	r0, [r7, #-73]	; 0xffffffb7
     4f8:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     4fc:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     500:	5f72656c 	svcpl	0x0072656c
     504:	6f666e49 	svcvs	0x00666e49
     508:	70614d00 	rsbvc	r4, r1, r0, lsl #26
     50c:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     510:	6f545f65 	svcvs	0x00545f65
     514:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     518:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     51c:	6d6f5a00 	vstmdbvs	pc!, {s11-s10}
     520:	00656962 	rsbeq	r6, r5, r2, ror #18
     524:	7478656e 	ldrbtvc	r6, [r8], #-1390	; 0xfffffa92
     528:	69464300 	stmdbvs	r6, {r8, r9, lr}^
     52c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     530:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     534:	736f7300 	cmnvc	pc, #0, 6
     538:	64656c5f 	strbtvs	r6, [r5], #-3167	; 0xfffff3a1
     53c:	766e4900 	strbtvc	r4, [lr], -r0, lsl #18
     540:	64696c61 	strbtvs	r6, [r9], #-3169	; 0xfffff39f
     544:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     548:	00656c64 	rsbeq	r6, r5, r4, ror #24
     54c:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     550:	00676e69 	rsbeq	r6, r7, r9, ror #28
     554:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     558:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     55c:	636e555f 	cmnvs	lr, #398458880	; 0x17c00000
     560:	676e6168 	strbvs	r6, [lr, -r8, ror #2]!
     564:	5f006465 	svcpl	0x00006465
     568:	31314e5a 	teqcc	r1, sl, asr lr
     56c:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     570:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     574:	316d6574 	smccc	54868	; 0xd654
     578:	696e4930 	stmdbvs	lr!, {r4, r5, r8, fp, lr}^
     57c:	6c616974 			; <UNDEFINED> instruction: 0x6c616974
     580:	45657a69 	strbmi	r7, [r5, #-2665]!	; 0xfffff597
     584:	6f6d0076 	svcvs	0x006d0076
     588:	50746e75 	rsbspl	r6, r4, r5, ror lr
     58c:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
     590:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     594:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     598:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     59c:	6f72505f 	svcvs	0x0072505f
     5a0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     5a4:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     5a8:	61425f4f 	cmpvs	r2, pc, asr #30
     5ac:	5f006573 	svcpl	0x00006573
     5b0:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     5b4:	6f725043 	svcvs	0x00725043
     5b8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     5bc:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     5c0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     5c4:	72433431 	subvc	r3, r3, #822083584	; 0x31000000
     5c8:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     5cc:	6f72505f 	svcvs	0x0072505f
     5d0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     5d4:	6a685045 	bvs	1a146f0 <__bss_end+0x1a0b6b4>
     5d8:	65530062 	ldrbvs	r0, [r3, #-98]	; 0xffffff9e
     5dc:	61505f74 	cmpvs	r0, r4, ror pc
     5e0:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     5e4:	65727000 	ldrbvs	r7, [r2, #-0]!
     5e8:	5a5f0076 	bpl	17c07c8 <__bss_end+0x17b778c>
     5ec:	33314b4e 	teqcc	r1, #79872	; 0x13800
     5f0:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     5f4:	61485f4f 	cmpvs	r8, pc, asr #30
     5f8:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     5fc:	47363272 			; <UNDEFINED> instruction: 0x47363272
     600:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     604:	52495f50 	subpl	r5, r9, #80, 30	; 0x140
     608:	65445f51 	strbvs	r5, [r4, #-3921]	; 0xfffff0af
     60c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     610:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     614:	6f697461 	svcvs	0x00697461
     618:	326a456e 	rsbcc	r4, sl, #461373440	; 0x1b800000
     61c:	50474e30 	subpl	r4, r7, r0, lsr lr
     620:	495f4f49 	ldmdbmi	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     624:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     628:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     62c:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     630:	536a5265 	cmnpl	sl, #1342177286	; 0x50000006
     634:	5f005f31 	svcpl	0x00005f31
     638:	314b4e5a 	cmpcc	fp, sl, asr lr
     63c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     640:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     644:	614d5f73 	hvcvs	54771	; 0xd5f3
     648:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     64c:	47393172 			; <UNDEFINED> instruction: 0x47393172
     650:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     654:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     658:	505f746e 	subspl	r7, pc, lr, ror #8
     65c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     660:	76457373 			; <UNDEFINED> instruction: 0x76457373
     664:	53465400 	movtpl	r5, #25600	; 0x6400
     668:	6572545f 	ldrbvs	r5, [r2, #-1119]!	; 0xfffffba1
     66c:	6f4e5f65 	svcvs	0x004e5f65
     670:	53006564 	movwpl	r6, #1380	; 0x564
     674:	4f5f7465 	svcmi	0x005f7465
     678:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
     67c:	72640074 	rsbvc	r0, r4, #116	; 0x74
     680:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     684:	7864695f 	stmdavc	r4!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
     688:	61655200 	cmnvs	r5, r0, lsl #4
     68c:	6e4f5f64 	cdpvs	15, 4, cr5, cr15, cr4, {3}
     690:	7300796c 	movwvc	r7, #2412	; 0x96c
     694:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     698:	696c625f 	stmdbvs	ip!, {r0, r1, r2, r3, r4, r6, r9, sp, lr}^
     69c:	4d006b6e 	vstrmi	d6, [r0, #-440]	; 0xfffffe48
     6a0:	505f7861 	subspl	r7, pc, r1, ror #16
     6a4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     6a8:	4f5f7373 	svcmi	0x005f7373
     6ac:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     6b0:	69465f64 	stmdbvs	r6, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     6b4:	0073656c 	rsbseq	r6, r3, ip, ror #10
     6b8:	55504354 	ldrbpl	r4, [r0, #-852]	; 0xfffffcac
     6bc:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     6c0:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     6c4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     6c8:	50433631 	subpl	r3, r3, r1, lsr r6
     6cc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     6d0:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 50c <shift+0x50c>
     6d4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     6d8:	53387265 	teqpl	r8, #1342177286	; 0x50000006
     6dc:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     6e0:	45656c75 	strbmi	r6, [r5, #-3189]!	; 0xfffff38b
     6e4:	6f4e0076 	svcvs	0x004e0076
     6e8:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     6ec:	006c6c41 	rsbeq	r6, ip, r1, asr #24
     6f0:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     6f4:	75435f6b 	strbvc	r5, [r3, #-3947]	; 0xfffff095
     6f8:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     6fc:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     700:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     704:	65470073 	strbvs	r0, [r7, #-115]	; 0xffffff8d
     708:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     70c:	69750044 	ldmdbvs	r5!, {r2, r6}^
     710:	3233746e 	eorscc	r7, r3, #1845493760	; 0x6e000000
     714:	5f00745f 	svcpl	0x0000745f
     718:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     71c:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     720:	61485f4f 	cmpvs	r8, pc, asr #30
     724:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     728:	65473972 	strbvs	r3, [r7, #-2418]	; 0xfffff68e
     72c:	6e495f74 	mcrvs	15, 2, r5, cr9, cr4, {3}
     730:	45747570 	ldrbmi	r7, [r4, #-1392]!	; 0xfffffa90
     734:	5a5f006a 	bpl	17c08e4 <__bss_end+0x17b78a8>
     738:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     73c:	4f495047 	svcmi	0x00495047
     740:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     744:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     748:	65533031 	ldrbvs	r3, [r3, #-49]	; 0xffffffcf
     74c:	754f5f74 	strbvc	r5, [pc, #-3956]	; fffff7e0 <__bss_end+0xffff67a4>
     750:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
     754:	00626a45 	rsbeq	r6, r2, r5, asr #20
     758:	434f494e 	movtmi	r4, #63822	; 0xf94e
     75c:	4f5f6c74 	svcmi	0x005f6c74
     760:	61726570 	cmnvs	r2, r0, ror r5
     764:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     768:	43534200 	cmpmi	r3, #0, 4
     76c:	61425f31 	cmpvs	r2, r1, lsr pc
     770:	57006573 	smlsdxpl	r0, r3, r5, r6
     774:	00746961 	rsbseq	r6, r4, r1, ror #18
     778:	7361544e 	cmnvc	r1, #1308622848	; 0x4e000000
     77c:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     780:	00657461 	rsbeq	r7, r5, r1, ror #8
     784:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     788:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     78c:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     790:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     794:	6c420046 	mcrrvs	0, 4, r0, r2, cr6
     798:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     79c:	436d0064 	cmnmi	sp, #100	; 0x64
     7a0:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     7a4:	545f746e 	ldrbpl	r7, [pc], #-1134	; 7ac <shift+0x7ac>
     7a8:	5f6b7361 	svcpl	0x006b7361
     7ac:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     7b0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     7b4:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     7b8:	5f4f4950 	svcpl	0x004f4950
     7bc:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     7c0:	4372656c 	cmnmi	r2, #108, 10	; 0x1b000000
     7c4:	006a4534 	rsbeq	r4, sl, r4, lsr r5
     7c8:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
     7cc:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     7d0:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
     7d4:	0079616c 	rsbseq	r6, r9, ip, ror #2
     7d8:	6f6f526d 	svcvs	0x006f526d
     7dc:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     7e0:	5a5f0076 	bpl	17c09c0 <__bss_end+0x17b7984>
     7e4:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     7e8:	636f7250 	cmnvs	pc, #80, 4
     7ec:	5f737365 	svcpl	0x00737365
     7f0:	616e614d 	cmnvs	lr, sp, asr #2
     7f4:	39726567 	ldmdbcc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
     7f8:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
     7fc:	545f6863 	ldrbpl	r6, [pc], #-2147	; 804 <shift+0x804>
     800:	3150456f 	cmpcc	r0, pc, ror #10
     804:	72504338 	subsvc	r4, r0, #56, 6	; 0xe0000000
     808:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     80c:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     810:	4e5f7473 	mrcmi	4, 2, r7, cr15, cr3, {3}
     814:	0065646f 	rsbeq	r6, r5, pc, ror #8
     818:	5f6e6970 	svcpl	0x006e6970
     81c:	00786469 	rsbseq	r6, r8, r9, ror #8
     820:	5f757063 	svcpl	0x00757063
     824:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     828:	00747865 	rsbseq	r7, r4, r5, ror #16
     82c:	4950476d 	ldmdbmi	r0, {r0, r2, r3, r5, r6, r8, r9, sl, lr}^
     830:	7243004f 	subvc	r0, r3, #79	; 0x4f
     834:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     838:	6f72505f 	svcvs	0x0072505f
     83c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     840:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     844:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     848:	4f495047 	svcmi	0x00495047
     84c:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     850:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     854:	65473931 	strbvs	r3, [r7, #-2353]	; 0xfffff6cf
     858:	50475f74 	subpl	r5, r7, r4, ror pc
     85c:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     860:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     864:	6f697461 	svcvs	0x00697461
     868:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     86c:	5f30536a 	svcpl	0x0030536a
     870:	65704f00 	ldrbvs	r4, [r0, #-3840]!	; 0xfffff100
     874:	7369006e 	cmnvc	r9, #110	; 0x6e
     878:	65726944 	ldrbvs	r6, [r2, #-2372]!	; 0xfffff6bc
     87c:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
     880:	65470079 	strbvs	r0, [r7, #-121]	; 0xffffff87
     884:	50475f74 	subpl	r5, r7, r4, ror pc
     888:	5f524c43 	svcpl	0x00524c43
     88c:	61636f4c 	cmnvs	r3, ip, asr #30
     890:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     894:	6d695400 	cfstrdvs	mvd5, [r9, #-0]
     898:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     89c:	00657361 	rsbeq	r7, r5, r1, ror #6
     8a0:	5f534667 	svcpl	0x00534667
     8a4:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     8a8:	5f737265 	svcpl	0x00737265
     8ac:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     8b0:	47730074 			; <UNDEFINED> instruction: 0x47730074
     8b4:	004f4950 	subeq	r4, pc, r0, asr r9	; <UNPREDICTABLE>
     8b8:	5f746547 	svcpl	0x00746547
     8bc:	44455047 	strbmi	r5, [r5], #-71	; 0xffffffb9
     8c0:	6f4c5f53 	svcvs	0x004c5f53
     8c4:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     8c8:	62006e6f 	andvs	r6, r0, #1776	; 0x6f0
     8cc:	6f747475 	svcvs	0x00747475
     8d0:	6553006e 	ldrbvs	r0, [r3, #-110]	; 0xffffff92
     8d4:	50475f74 	subpl	r5, r7, r4, ror pc
     8d8:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     8dc:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     8e0:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     8e4:	314e5a5f 	cmpcc	lr, pc, asr sl
     8e8:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     8ec:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     8f0:	614d5f73 	hvcvs	54771	; 0xd5f3
     8f4:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     8f8:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     8fc:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     900:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     904:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     908:	31504573 	cmpcc	r0, r3, ror r5
     90c:	61545432 	cmpvs	r4, r2, lsr r4
     910:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
     914:	63757274 	cmnvs	r5, #116, 4	; 0x40000007
     918:	65470074 	strbvs	r0, [r7, #-116]	; 0xffffff8c
     91c:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     920:	5f646568 	svcpl	0x00646568
     924:	6f666e49 	svcvs	0x00666e49
     928:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     92c:	4f490076 	svcmi	0x00490076
     930:	006c7443 	rsbeq	r7, ip, r3, asr #8
     934:	6d726554 	cfldr64vs	mvdx6, [r2, #-336]!	; 0xfffffeb0
     938:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
     93c:	75520065 	ldrbvc	r0, [r2, #-101]	; 0xffffff9b
     940:	62616e6e 	rsbvs	r6, r1, #1760	; 0x6e0
     944:	4e00656c 	cfsh32mi	mvfx6, mvfx0, #60
     948:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     94c:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     950:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     954:	5a5f0073 	bpl	17c0b28 <__bss_end+0x17b7aec>
     958:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     95c:	636f7250 	cmnvs	pc, #80, 4
     960:	5f737365 	svcpl	0x00737365
     964:	616e614d 	cmnvs	lr, sp, asr #2
     968:	43726567 	cmnmi	r2, #432013312	; 0x19c00000
     96c:	00764534 	rsbseq	r4, r6, r4, lsr r5
     970:	4b4e5a5f 	blmi	13972f4 <__bss_end+0x138e2b8>
     974:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     978:	5f4f4950 	svcpl	0x004f4950
     97c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     980:	3172656c 	cmncc	r2, ip, ror #10
     984:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     988:	5350475f 	cmppl	r0, #24903680	; 0x17c0000
     98c:	4c5f5445 	cfldrdmi	mvd5, [pc], {69}	; 0x45
     990:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     994:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     998:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     99c:	6d005f30 	stcvs	15, cr5, [r0, #-192]	; 0xffffff40
     9a0:	6b636f4c 	blvs	18dc6d8 <__bss_end+0x18d369c>
     9a4:	6f526d00 	svcvs	0x00526d00
     9a8:	4d5f746f 	cfldrdmi	mvd7, [pc, #-444]	; 7f4 <shift+0x7f4>
     9ac:	5f00746e 	svcpl	0x0000746e
     9b0:	314b4e5a 	cmpcc	fp, sl, asr lr
     9b4:	50474333 	subpl	r4, r7, r3, lsr r3
     9b8:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     9bc:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     9c0:	32327265 	eorscc	r7, r2, #1342177286	; 0x50000006
     9c4:	5f746547 	svcpl	0x00746547
     9c8:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     9cc:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     9d0:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     9d4:	505f746e 	subspl	r7, pc, lr, ror #8
     9d8:	76456e69 	strbvc	r6, [r5], -r9, ror #28
     9dc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     9e0:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     9e4:	5f4f4950 	svcpl	0x004f4950
     9e8:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     9ec:	3172656c 	cmncc	r2, ip, ror #10
     9f0:	616e4539 	cmnvs	lr, r9, lsr r5
     9f4:	5f656c62 	svcpl	0x00656c62
     9f8:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     9fc:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     a00:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     a04:	30326a45 	eorscc	r6, r2, r5, asr #20
     a08:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     a0c:	6e495f4f 	cdpvs	15, 4, cr5, cr9, cr15, {2}
     a10:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     a14:	5f747075 	svcpl	0x00747075
     a18:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     a1c:	746f4e00 	strbtvc	r4, [pc], #-3584	; a24 <shift+0xa24>
     a20:	00796669 	rsbseq	r6, r9, r9, ror #12
     a24:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     a28:	43007265 	movwmi	r7, #613	; 0x265
     a2c:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
     a30:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     a34:	65746365 	ldrbvs	r6, [r4, #-869]!	; 0xfffffc9b
     a38:	76455f64 	strbvc	r5, [r5], -r4, ror #30
     a3c:	00746e65 	rsbseq	r6, r4, r5, ror #28
     a40:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     a44:	495f656c 	ldmdbmi	pc, {r2, r3, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
     a48:	4d005152 	stfmis	f5, [r0, #-328]	; 0xfffffeb8
     a4c:	61507861 	cmpvs	r0, r1, ror #16
     a50:	654c6874 	strbvs	r6, [ip, #-2164]	; 0xfffff78c
     a54:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     a58:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     a5c:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     a60:	4f495047 	svcmi	0x00495047
     a64:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     a68:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     a6c:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     a70:	50475f74 	subpl	r5, r7, r4, ror pc
     a74:	5f534445 	svcpl	0x00534445
     a78:	61636f4c 	cmnvs	r3, ip, asr #30
     a7c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     a80:	6a526a45 	bvs	149b39c <__bss_end+0x1492360>
     a84:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     a88:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
     a8c:	69724453 	ldmdbvs	r2!, {r0, r1, r4, r6, sl, lr}^
     a90:	4e726576 	mrcmi	5, 3, r6, cr2, cr6, {3}
     a94:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
     a98:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     a9c:	506d0068 	rsbpl	r0, sp, r8, rrx
     aa0:	525f6e69 	subspl	r6, pc, #1680	; 0x690
     aa4:	72657365 	rsbvc	r7, r5, #-1811939327	; 0x94000001
     aa8:	69746176 	ldmdbvs	r4!, {r1, r2, r4, r5, r6, r8, sp, lr}^
     aac:	5f736e6f 	svcpl	0x00736e6f
     ab0:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     ab4:	5a5f0065 	bpl	17c0c50 <__bss_end+0x17b7c14>
     ab8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     abc:	636f7250 	cmnvs	pc, #80, 4
     ac0:	5f737365 	svcpl	0x00737365
     ac4:	616e614d 	cmnvs	lr, sp, asr #2
     ac8:	31726567 	cmncc	r2, r7, ror #10
     acc:	68635331 	stmdavs	r3!, {r0, r4, r5, r8, r9, ip, lr}^
     ad0:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     ad4:	52525f65 	subspl	r5, r2, #404	; 0x194
     ad8:	4e007645 	cfmadd32mi	mvax2, mvfx7, mvfx0, mvfx5
     adc:	5f746547 	svcpl	0x00746547
     ae0:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     ae4:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     ae8:	545f6f66 	ldrbpl	r6, [pc], #-3942	; af0 <shift+0xaf0>
     aec:	00657079 	rsbeq	r7, r5, r9, ror r0
     af0:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
     af4:	69745f70 	ldmdbvs	r4!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     af8:	0072656d 	rsbseq	r6, r2, sp, ror #10
     afc:	4f495047 	svcmi	0x00495047
     b00:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     b04:	756f435f 	strbvc	r4, [pc, #-863]!	; 7ad <shift+0x7ad>
     b08:	7400746e 	strvc	r7, [r0], #-1134	; 0xfffffb92
     b0c:	006b7361 	rsbeq	r7, fp, r1, ror #6
     b10:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     b14:	726f465f 	rsbvc	r4, pc, #99614720	; 0x5f00000
     b18:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     b1c:	4700746e 	strmi	r7, [r0, -lr, ror #8]
     b20:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     b24:	5f4f4950 	svcpl	0x004f4950
     b28:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     b2c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     b30:	6f6f6200 	svcvs	0x006f6200
     b34:	5a5f006c 	bpl	17c0cec <__bss_end+0x17b7cb0>
     b38:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     b3c:	636f7250 	cmnvs	pc, #80, 4
     b40:	5f737365 	svcpl	0x00737365
     b44:	616e614d 	cmnvs	lr, sp, asr #2
     b48:	31726567 	cmncc	r2, r7, ror #10
     b4c:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     b50:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     b54:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     b58:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     b5c:	456f666e 	strbmi	r6, [pc, #-1646]!	; 4f6 <shift+0x4f6>
     b60:	474e3032 	smlaldxmi	r3, lr, r2, r0
     b64:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     b68:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     b6c:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     b70:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     b74:	76506570 			; <UNDEFINED> instruction: 0x76506570
     b78:	4e525400 	cdpmi	4, 5, cr5, cr2, cr0, {0}
     b7c:	61425f47 	cmpvs	r2, r7, asr #30
     b80:	44006573 	strmi	r6, [r0], #-1395	; 0xfffffa8d
     b84:	75616665 	strbvc	r6, [r1, #-1637]!	; 0xfffff99b
     b88:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
     b8c:	6b636f6c 	blvs	18dc944 <__bss_end+0x18d3908>
     b90:	7461525f 	strbtvc	r5, [r1], #-607	; 0xfffffda1
     b94:	526d0065 	rsbpl	r0, sp, #101	; 0x65
     b98:	5f746f6f 	svcpl	0x00746f6f
     b9c:	00737953 	rsbseq	r7, r3, r3, asr r9
     ba0:	5f746547 	svcpl	0x00746547
     ba4:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
     ba8:	6f4c5f54 	svcvs	0x004c5f54
     bac:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     bb0:	6d006e6f 	stcvs	14, cr6, [r0, #-444]	; 0xfffffe44
     bb4:	636f7250 	cmnvs	pc, #80, 4
     bb8:	5f737365 	svcpl	0x00737365
     bbc:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
     bc0:	6165485f 	cmnvs	r5, pc, asr r8
     bc4:	536d0064 	cmnpl	sp, #100	; 0x64
     bc8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     bcc:	5f656c75 	svcpl	0x00656c75
     bd0:	00636e46 	rsbeq	r6, r3, r6, asr #28
     bd4:	314e5a5f 	cmpcc	lr, pc, asr sl
     bd8:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     bdc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     be0:	614d5f73 	hvcvs	54771	; 0xd5f3
     be4:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     be8:	42313272 	eorsmi	r3, r1, #536870919	; 0x20000007
     bec:	6b636f6c 	blvs	18dc9a4 <__bss_end+0x18d3968>
     bf0:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     bf4:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     bf8:	6f72505f 	svcvs	0x0072505f
     bfc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     c00:	6d007645 	stcvs	6, cr7, [r0, #-276]	; 0xfffffeec
     c04:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     c08:	5f676e69 	svcpl	0x00676e69
     c0c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     c10:	6f4c0073 	svcvs	0x004c0073
     c14:	555f6b63 	ldrbpl	r6, [pc, #-2915]	; b9 <shift+0xb9>
     c18:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     c1c:	0064656b 	rsbeq	r6, r4, fp, ror #10
     c20:	73614c6d 	cmnvc	r1, #27904	; 0x6d00
     c24:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     c28:	5a5f0044 	bpl	17c0d40 <__bss_end+0x17b7d04>
     c2c:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     c30:	4f495047 	svcmi	0x00495047
     c34:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     c38:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     c3c:	65533731 	ldrbvs	r3, [r3, #-1841]	; 0xfffff8cf
     c40:	50475f74 	subpl	r5, r7, r4, ror pc
     c44:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     c48:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     c4c:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     c50:	4e34316a 	rsfmisz	f3, f4, #2.0
     c54:	4f495047 	svcmi	0x00495047
     c58:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     c5c:	6f697463 	svcvs	0x00697463
     c60:	6547006e 	strbvs	r0, [r7, #-110]	; 0xffffff92
     c64:	6e495f74 	mcrvs	15, 2, r5, cr9, cr4, {3}
     c68:	00747570 	rsbseq	r7, r4, r0, ror r5
     c6c:	62355a5f 	eorsvs	r5, r5, #389120	; 0x5f000
     c70:	6b6e696c 	blvs	1b9b228 <__bss_end+0x1b921ec>
     c74:	5a5f0062 	bpl	17c0e04 <__bss_end+0x17b7dc8>
     c78:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
     c7c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     c80:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     c84:	4f346d65 	svcmi	0x00346d65
     c88:	456e6570 	strbmi	r6, [lr, #-1392]!	; 0xfffffa90
     c8c:	31634b50 	cmncc	r3, r0, asr fp
     c90:	69464e35 	stmdbvs	r6, {r0, r2, r4, r5, r9, sl, fp, lr}^
     c94:	4f5f656c 	svcmi	0x005f656c
     c98:	5f6e6570 	svcpl	0x006e6570
     c9c:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     ca0:	69775300 	ldmdbvs	r7!, {r8, r9, ip, lr}^
     ca4:	5f686374 	svcpl	0x00686374
     ca8:	43006f54 	movwmi	r6, #3924	; 0xf54
     cac:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
     cb0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     cb4:	50433631 	subpl	r3, r3, r1, lsr r6
     cb8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     cbc:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; af8 <shift+0xaf8>
     cc0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     cc4:	32317265 	eorscc	r7, r1, #1342177286	; 0x50000006
     cc8:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     ccc:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     cd0:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     cd4:	47007645 	strmi	r7, [r0, -r5, asr #12]
     cd8:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     cdc:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
     ce0:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     ce4:	6f697461 	svcvs	0x00697461
     ce8:	5342006e 	movtpl	r0, #8302	; 0x206e
     cec:	425f3043 	subsmi	r3, pc, #67	; 0x43
     cf0:	00657361 	rsbeq	r7, r5, r1, ror #6
     cf4:	69736952 	ldmdbvs	r3!, {r1, r4, r6, r8, fp, sp, lr}^
     cf8:	455f676e 	ldrbmi	r6, [pc, #-1902]	; 592 <shift+0x592>
     cfc:	00656764 	rsbeq	r6, r5, r4, ror #14
     d00:	63677261 	cmnvs	r7, #268435462	; 0x10000006
     d04:	6f682f00 	svcvs	0x00682f00
     d08:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
     d0c:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
     d10:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
     d14:	494b2f76 	stmdbmi	fp, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
     d18:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
     d1c:	6d2d534f 	stcvs	3, cr5, [sp, #-316]!	; 0xfffffec4
     d20:	65747361 	ldrbvs	r7, [r4, #-865]!	; 0xfffffc9f
     d24:	6f732f72 	svcvs	0x00732f72
     d28:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     d2c:	73752f73 	cmnvc	r5, #460	; 0x1cc
     d30:	70737265 	rsbsvc	r7, r3, r5, ror #4
     d34:	2f656361 	svccs	0x00656361
     d38:	5f736f73 	svcpl	0x00736f73
     d3c:	6b736174 	blvs	1cd9314 <__bss_end+0x1cd02d8>
     d40:	69616d2f 	stmdbvs	r1!, {r0, r1, r2, r3, r5, r8, sl, fp, sp, lr}^
     d44:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     d48:	65520070 	ldrbvs	r0, [r2, #-112]	; 0xffffff90
     d4c:	76726573 			; <UNDEFINED> instruction: 0x76726573
     d50:	69505f65 	ldmdbvs	r0, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     d54:	6948006e 	stmdbvs	r8, {r1, r2, r3, r5, r6}^
     d58:	6e006867 	cdpvs	8, 0, cr6, cr0, cr7, {3}
     d5c:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     d60:	5f646569 	svcpl	0x00646569
     d64:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     d68:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     d6c:	6c614600 	stclvs	6, cr4, [r1], #-0
     d70:	676e696c 	strbvs	r6, [lr, -ip, ror #18]!
     d74:	6764455f 			; <UNDEFINED> instruction: 0x6764455f
     d78:	5a5f0065 	bpl	17c0f14 <__bss_end+0x17b7ed8>
     d7c:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
     d80:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     d84:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     d88:	34436d65 	strbcc	r6, [r3], #-3429	; 0xfffff29b
     d8c:	5f007645 	svcpl	0x00007645
     d90:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     d94:	6f725043 	svcvs	0x00725043
     d98:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     d9c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     da0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     da4:	6f4e3431 	svcvs	0x004e3431
     da8:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     dac:	6f72505f 	svcvs	0x0072505f
     db0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     db4:	4e006a45 	vmlsmi.f32	s12, s0, s10
     db8:	6c69466f 	stclvs	6, cr4, [r9], #-444	; 0xfffffe44
     dbc:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     dc0:	446d6574 	strbtmi	r6, [sp], #-1396	; 0xfffffa8c
     dc4:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     dc8:	70730072 	rsbsvc	r0, r3, r2, ror r0
     dcc:	6f6c6e69 	svcvs	0x006c6e69
     dd0:	745f6b63 	ldrbvc	r6, [pc], #-2915	; dd8 <shift+0xdd8>
     dd4:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     dd8:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     ddc:	65746365 	ldrbvs	r6, [r4, #-869]!	; 0xfffffc9b
     de0:	76455f64 	strbvc	r5, [r5], -r4, ror #30
     de4:	5f746e65 	svcpl	0x00746e65
     de8:	006e6950 	rsbeq	r6, lr, r0, asr r9
     dec:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     df0:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     df4:	72617000 	rsbvc	r7, r1, #0
     df8:	00746e65 	rsbseq	r6, r4, r5, ror #28
     dfc:	61736944 	cmnvs	r3, r4, asr #18
     e00:	5f656c62 	svcpl	0x00656c62
     e04:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     e08:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     e0c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     e10:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     e14:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     e18:	6e692074 	mcrvs	0, 3, r2, cr9, cr4, {3}
     e1c:	72690074 	rsbvc	r0, r9, #116	; 0x74
     e20:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
     e24:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     e28:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     e2c:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     e30:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     e34:	6d006874 	stcvs	8, cr6, [r0, #-464]	; 0xfffffe30
     e38:	746f6f52 	strbtvc	r6, [pc], #-3922	; e40 <shift+0xe40>
     e3c:	65724600 	ldrbvs	r4, [r2, #-1536]!	; 0xfffffa00
     e40:	69505f65 	ldmdbvs	r0, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     e44:	5043006e 	subpl	r0, r3, lr, rrx
     e48:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     e4c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; c88 <shift+0xc88>
     e50:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     e54:	55007265 	strpl	r7, [r0, #-613]	; 0xfffffd9b
     e58:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
     e5c:	69666963 	stmdbvs	r6!, {r0, r1, r5, r6, r8, fp, sp, lr}^
     e60:	5f006465 	svcpl	0x00006465
     e64:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     e68:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     e6c:	61485f4f 	cmpvs	r8, pc, asr #30
     e70:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     e74:	72463872 	subvc	r3, r6, #7471104	; 0x720000
     e78:	505f6565 	subspl	r6, pc, r5, ror #10
     e7c:	6a456e69 	bvs	115c828 <__bss_end+0x11537ec>
     e80:	73006262 	movwvc	r6, #610	; 0x262
     e84:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     e88:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     e8c:	49006d65 	stmdbmi	r0, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
     e90:	6974696e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, fp, sp, lr}^
     e94:	7a696c61 	bvc	1a5c020 <__bss_end+0x1a52fe4>
     e98:	69460065 	stmdbvs	r6, {r0, r2, r5, r6}^
     e9c:	435f646e 	cmpmi	pc, #1845493760	; 0x6e000000
     ea0:	646c6968 	strbtvs	r6, [ip], #-2408	; 0xfffff698
     ea4:	62747400 	rsbsvs	r7, r4, #0, 8
     ea8:	4e003072 	mcrmi	0, 0, r3, cr0, cr2, {3}
     eac:	5f495753 	svcpl	0x00495753
     eb0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     eb4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     eb8:	535f6d65 	cmppl	pc, #6464	; 0x1940
     ebc:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     ec0:	6c006563 	cfstr32vs	mvfx6, [r0], {99}	; 0x63
     ec4:	6970676f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     ec8:	4e006570 	cfrshl64mi	mvdx0, mvdx0, r6
     ecc:	5f495753 	svcpl	0x00495753
     ed0:	636f7250 	cmnvs	pc, #80, 4
     ed4:	5f737365 	svcpl	0x00737365
     ed8:	76726553 			; <UNDEFINED> instruction: 0x76726553
     edc:	00656369 	rsbeq	r6, r5, r9, ror #6
     ee0:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
     ee4:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
     ee8:	73656c69 	cmnvc	r5, #26880	; 0x6900
     eec:	65695900 	strbvs	r5, [r9, #-2304]!	; 0xfffff700
     ef0:	4900646c 	stmdbmi	r0, {r2, r3, r5, r6, sl, sp, lr}
     ef4:	6665646e 	strbtvs	r6, [r5], -lr, ror #8
     ef8:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     efc:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     f00:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     f04:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     f08:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     f0c:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     f10:	616e4500 	cmnvs	lr, r0, lsl #10
     f14:	5f656c62 	svcpl	0x00656c62
     f18:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     f1c:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     f20:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     f24:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     f28:	69726550 	ldmdbvs	r2!, {r4, r6, r8, sl, sp, lr}^
     f2c:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
     f30:	425f6c61 	subsmi	r6, pc, #24832	; 0x6100
     f34:	00657361 	rsbeq	r7, r5, r1, ror #6
     f38:	5f746547 	svcpl	0x00746547
     f3c:	53465047 	movtpl	r5, #24647	; 0x6047
     f40:	4c5f4c45 	mrrcmi	12, 4, r4, pc, cr5	; <UNPREDICTABLE>
     f44:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     f48:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     f4c:	4b4e5a5f 	blmi	13978d0 <__bss_end+0x138e894>
     f50:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     f54:	5f4f4950 	svcpl	0x004f4950
     f58:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     f5c:	3172656c 	cmncc	r2, ip, ror #10
     f60:	74654737 	strbtvc	r4, [r5], #-1847	; 0xfffff8c9
     f64:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     f68:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     f6c:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     f70:	6a456e6f 	bvs	115c934 <__bss_end+0x11538f8>
     f74:	766e4900 	strbtvc	r4, [lr], -r0, lsl #18
     f78:	64696c61 	strbtvs	r6, [r9], #-3169	; 0xfffff39f
     f7c:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     f80:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     f84:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     f88:	5f4f4950 	svcpl	0x004f4950
     f8c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     f90:	3272656c 	rsbscc	r6, r2, #108, 10	; 0x1b000000
     f94:	73694430 	cmnvc	r9, #48, 8	; 0x30000000
     f98:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     f9c:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     fa0:	445f746e 	ldrbmi	r7, [pc], #-1134	; fa8 <shift+0xfa8>
     fa4:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     fa8:	326a4574 	rsbcc	r4, sl, #116, 10	; 0x1d000000
     fac:	50474e30 	subpl	r4, r7, r0, lsr lr
     fb0:	495f4f49 	ldmdbmi	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     fb4:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     fb8:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     fbc:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     fc0:	506d0065 	rsbpl	r0, sp, r5, rrx
     fc4:	525f6e69 	subspl	r6, pc, #1680	; 0x690
     fc8:	72657365 	rsbvc	r7, r5, #-1811939327	; 0x94000001
     fcc:	69746176 	ldmdbvs	r4!, {r1, r2, r4, r5, r6, r8, sp, lr}^
     fd0:	5f736e6f 	svcpl	0x00736e6f
     fd4:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     fd8:	636f4c00 	cmnvs	pc, #0, 24
     fdc:	6f4c5f6b 	svcvs	0x004c5f6b
     fe0:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     fe4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     fe8:	50433631 	subpl	r3, r3, r1, lsr r6
     fec:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     ff0:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; e2c <shift+0xe2c>
     ff4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     ff8:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     ffc:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    1000:	505f656c 	subspl	r6, pc, ip, ror #10
    1004:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1008:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
    100c:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
    1010:	57534e30 	smmlarpl	r3, r0, lr, r4
    1014:	72505f49 	subsvc	r5, r0, #292	; 0x124
    1018:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    101c:	65535f73 	ldrbvs	r5, [r3, #-3955]	; 0xfffff08d
    1020:	63697672 	cmnvs	r9, #119537664	; 0x7200000
    1024:	6a6a6a65 	bvs	1a9b9c0 <__bss_end+0x1a92984>
    1028:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
    102c:	5f495753 	svcpl	0x00495753
    1030:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
    1034:	5f00746c 	svcpl	0x0000746c
    1038:	33314e5a 	teqcc	r1, #1440	; 0x5a0
    103c:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
    1040:	61485f4f 	cmpvs	r8, pc, asr #30
    1044:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    1048:	43303272 	teqmi	r0, #536870919	; 0x20000007
    104c:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
    1050:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
    1054:	65746365 	ldrbvs	r6, [r4, #-869]!	; 0xfffffc9b
    1058:	76455f64 	strbvc	r5, [r5], -r4, ror #30
    105c:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
    1060:	6373006a 	cmnvs	r3, #106	; 0x6a
    1064:	5f646568 	svcpl	0x00646568
    1068:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    106c:	00726574 	rsbseq	r6, r2, r4, ror r5
    1070:	5f746547 	svcpl	0x00746547
    1074:	61726150 	cmnvs	r2, r0, asr r1
    1078:	7500736d 	strvc	r7, [r0, #-877]	; 0xfffffc93
    107c:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
    1080:	2064656e 	rsbcs	r6, r4, lr, ror #10
    1084:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
    1088:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
    108c:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
    1090:	62617470 	rsbvs	r7, r1, #112, 8	; 0x70000000
    1094:	535f656c 	cmppl	pc, #108, 10	; 0x1b000000
    1098:	7065656c 	rsbvc	r6, r5, ip, ror #10
    109c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    10a0:	5f50475f 	svcpl	0x0050475f
    10a4:	5f515249 	svcpl	0x00515249
    10a8:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
    10ac:	4c5f7463 	cfldrdmi	mvd7, [pc], {99}	; 0x63
    10b0:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
    10b4:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    10b8:	314e5a5f 	cmpcc	lr, pc, asr sl
    10bc:	50474333 	subpl	r4, r7, r3, lsr r3
    10c0:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
    10c4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    10c8:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
    10cc:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
    10d0:	726f465f 	rsbvc	r4, pc, #99614720	; 0x5f00000
    10d4:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
    10d8:	5045746e 	subpl	r7, r5, lr, ror #8
    10dc:	69464935 	stmdbvs	r6, {r0, r2, r4, r5, r8, fp, lr}^
    10e0:	006a656c 	rsbeq	r6, sl, ip, ror #10
    10e4:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
    10e8:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
    10ec:	0052525f 	subseq	r5, r2, pc, asr r2
    10f0:	5f585541 	svcpl	0x00585541
    10f4:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
    10f8:	43534200 	cmpmi	r3, #0, 4
    10fc:	61425f32 	cmpvs	r2, r2, lsr pc
    1100:	57006573 	smlsdxpl	r0, r3, r5, r6
    1104:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    1108:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
    110c:	63530079 	cmpvs	r3, #121	; 0x79
    1110:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
    1114:	5f00656c 	svcpl	0x0000656c
    1118:	33314e5a 	teqcc	r1, #1440	; 0x5a0
    111c:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
    1120:	61485f4f 	cmpvs	r8, pc, asr #30
    1124:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    1128:	48303172 	ldmdami	r0!, {r1, r4, r5, r6, r8, ip, sp}
    112c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    1130:	52495f65 	subpl	r5, r9, #404	; 0x194
    1134:	00764551 	rsbseq	r4, r6, r1, asr r5
    1138:	6b636954 	blvs	18db690 <__bss_end+0x18d2654>
    113c:	756f435f 	strbvc	r4, [pc, #-863]!	; de5 <shift+0xde5>
    1140:	5f00746e 	svcpl	0x0000746e
    1144:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1148:	6f725043 	svcvs	0x00725043
    114c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1150:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1154:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1158:	6e553831 	mrcvs	8, 2, r3, cr5, cr1, {1}
    115c:	5f70616d 	svcpl	0x0070616d
    1160:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1164:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
    1168:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    116c:	41006a45 	tstmi	r0, r5, asr #20
    1170:	305f746c 	subscc	r7, pc, ip, ror #8
    1174:	69464900 	stmdbvs	r6, {r8, fp, lr}^
    1178:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    117c:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    1180:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
    1184:	00726576 	rsbseq	r6, r2, r6, ror r5
    1188:	5f746c41 	svcpl	0x00746c41
    118c:	6c410032 	mcrrvs	0, 3, r0, r1, cr2
    1190:	00335f74 	eorseq	r5, r3, r4, ror pc
    1194:	5f746c41 	svcpl	0x00746c41
    1198:	6c410034 	mcrrvs	0, 3, r0, r1, cr4
    119c:	00355f74 	eorseq	r5, r5, r4, ror pc
    11a0:	314e5a5f 	cmpcc	lr, pc, asr sl
    11a4:	69464331 	stmdbvs	r6, {r0, r4, r5, r8, r9, lr}^
    11a8:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    11ac:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    11b0:	46543331 			; <UNDEFINED> instruction: 0x46543331
    11b4:	72545f53 	subsvc	r5, r4, #332	; 0x14c
    11b8:	4e5f6565 	cdpmi	5, 5, cr6, cr15, cr5, {3}
    11bc:	3165646f 	cmncc	r5, pc, ror #8
    11c0:	6e694630 	mcrvs	6, 3, r4, cr9, cr0, {1}
    11c4:	68435f64 	stmdavs	r3, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    11c8:	45646c69 	strbmi	r6, [r4, #-3177]!	; 0xfffff397
    11cc:	00634b50 	rsbeq	r4, r3, r0, asr fp
    11d0:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    11d4:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
    11d8:	73656c69 	cmnvc	r5, #26880	; 0x6900
    11dc:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
    11e0:	57535f6d 	ldrbpl	r5, [r3, -sp, ror #30]
    11e4:	5a5f0049 	bpl	17c1310 <__bss_end+0x17b82d4>
    11e8:	33314b4e 	teqcc	r1, #79872	; 0x13800
    11ec:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
    11f0:	61485f4f 	cmpvs	r8, pc, asr #30
    11f4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    11f8:	47383172 			; <UNDEFINED> instruction: 0x47383172
    11fc:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
    1200:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
    1204:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
    1208:	6f697461 	svcvs	0x00697461
    120c:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
    1210:	5f30536a 	svcpl	0x0030536a
    1214:	6f687300 	svcvs	0x00687300
    1218:	75207472 	strvc	r7, [r0, #-1138]!	; 0xfffffb8e
    121c:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
    1220:	2064656e 	rsbcs	r6, r4, lr, ror #10
    1224:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1228:	6e69616d 	powvsez	f6, f1, #5.0
    122c:	72507300 	subsvc	r7, r0, #0, 6
    1230:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1234:	72674d73 	rsbvc	r4, r7, #7360	; 0x1cc0
    1238:	50474300 	subpl	r4, r7, r0, lsl #6
    123c:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
    1240:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    1244:	41007265 	tstmi	r0, r5, ror #4
    1248:	315f746c 	cmpcc	pc, ip, ror #8
    124c:	69686300 	stmdbvs	r8!, {r8, r9, sp, lr}^
    1250:	6572646c 	ldrbvs	r6, [r2, #-1132]!	; 0xfffffb94
    1254:	6944006e 	stmdbvs	r4, {r1, r2, r3, r5, r6}^
    1258:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
    125c:	76455f65 	strbvc	r5, [r5], -r5, ror #30
    1260:	5f746e65 	svcpl	0x00746e65
    1264:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
    1268:	49007463 	stmdbmi	r0, {r0, r1, r5, r6, sl, ip, sp, lr}
    126c:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    1270:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
    1274:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
    1278:	6c6f7274 	sfmvs	f7, 2, [pc], #-464	; 10b0 <shift+0x10b0>
    127c:	5f72656c 	svcpl	0x0072656c
    1280:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
    1284:	53465400 	movtpl	r5, #25600	; 0x6400
    1288:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
    128c:	00726576 	rsbseq	r6, r2, r6, ror r5
    1290:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
    1294:	6972575f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, ip, lr}^
    1298:	41006574 	tstmi	r0, r4, ror r5
    129c:	76697463 	strbtvc	r7, [r9], -r3, ror #8
    12a0:	72505f65 	subsvc	r5, r0, #404	; 0x194
    12a4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    12a8:	6f435f73 	svcvs	0x00435f73
    12ac:	00746e75 	rsbseq	r6, r4, r5, ror lr
    12b0:	626d7973 	rsbvs	r7, sp, #1884160	; 0x1cc000
    12b4:	745f6c6f 	ldrbvc	r6, [pc], #-3183	; 12bc <shift+0x12bc>
    12b8:	5f6b6369 	svcpl	0x006b6369
    12bc:	616c6564 	cmnvs	ip, r4, ror #10
    12c0:	5a5f0079 	bpl	17c14ac <__bss_end+0x17b8470>
    12c4:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    12c8:	636f7250 	cmnvs	pc, #80, 4
    12cc:	5f737365 	svcpl	0x00737365
    12d0:	616e614d 	cmnvs	lr, sp, asr #2
    12d4:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
    12d8:	6e614831 	mcrvs	8, 3, r4, cr1, cr1, {1}
    12dc:	5f656c64 	svcpl	0x00656c64
    12e0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    12e4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    12e8:	535f6d65 	cmppl	pc, #6464	; 0x1940
    12ec:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
    12f0:	57534e33 	smmlarpl	r3, r3, lr, r4
    12f4:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
    12f8:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    12fc:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    1300:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
    1304:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
    1308:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
    130c:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
    1310:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
    1314:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
    1318:	6e450074 	mcrvs	0, 2, r0, cr5, cr4, {3}
    131c:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    1320:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
    1324:	445f746e 	ldrbmi	r7, [pc], #-1134	; 132c <shift+0x132c>
    1328:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
    132c:	6c630074 	stclvs	0, cr0, [r3], #-464	; 0xfffffe30
    1330:	0065736f 	rsbeq	r7, r5, pc, ror #6
    1334:	5f746553 	svcpl	0x00746553
    1338:	616c6552 	cmnvs	ip, r2, asr r5
    133c:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    1340:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    1344:	2b2b4320 	blcs	ad1fcc <__bss_end+0xac8f90>
    1348:	38203431 	stmdacc	r0!, {r0, r4, r5, sl, ip, sp}
    134c:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
    1350:	31303220 	teqcc	r0, r0, lsr #4
    1354:	30373039 	eorscc	r3, r7, r9, lsr r0
    1358:	72282033 	eorvc	r2, r8, #51	; 0x33
    135c:	61656c65 	cmnvs	r5, r5, ror #24
    1360:	20296573 	eorcs	r6, r9, r3, ror r5
    1364:	6363675b 	cmnvs	r3, #23855104	; 0x16c0000
    1368:	622d382d 	eorvs	r3, sp, #2949120	; 0x2d0000
    136c:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
    1370:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
    1374:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    1378:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
    137c:	32303337 	eorscc	r3, r0, #-603979776	; 0xdc000000
    1380:	2d205d37 	stccs	13, cr5, [r0, #-220]!	; 0xffffff24
    1384:	6f6c666d 	svcvs	0x006c666d
    1388:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    138c:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    1390:	20647261 	rsbcs	r7, r4, r1, ror #4
    1394:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
    1398:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
    139c:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
    13a0:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    13a4:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    13a8:	36373131 			; <UNDEFINED> instruction: 0x36373131
    13ac:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
    13b0:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
    13b4:	616f6c66 	cmnvs	pc, r6, ror #24
    13b8:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    13bc:	61683d69 	cmnvs	r8, r9, ror #26
    13c0:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    13c4:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
    13c8:	7066763d 	rsbvc	r7, r6, sp, lsr r6
    13cc:	746d2d20 	strbtvc	r2, [sp], #-3360	; 0xfffff2e0
    13d0:	3d656e75 	stclcc	14, cr6, [r5, #-468]!	; 0xfffffe2c
    13d4:	316d7261 	cmncc	sp, r1, ror #4
    13d8:	6a363731 	bvs	d8f0a4 <__bss_end+0xd86068>
    13dc:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
    13e0:	616d2d20 	cmnvs	sp, r0, lsr #26
    13e4:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
    13e8:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
    13ec:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
    13f0:	7a36766d 	bvc	d9edac <__bss_end+0xd95d70>
    13f4:	70662b6b 	rsbvc	r2, r6, fp, ror #22
    13f8:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    13fc:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1400:	4f2d2067 	svcmi	0x002d2067
    1404:	4f2d2030 	svcmi	0x002d2030
    1408:	662d2030 			; <UNDEFINED> instruction: 0x662d2030
    140c:	652d6f6e 	strvs	r6, [sp, #-3950]!	; 0xfffff092
    1410:	70656378 	rsbvc	r6, r5, r8, ror r3
    1414:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1418:	662d2073 			; <UNDEFINED> instruction: 0x662d2073
    141c:	722d6f6e 	eorvc	r6, sp, #440	; 0x1b8
    1420:	00697474 	rsbeq	r7, r9, r4, ror r4
    1424:	76746572 			; <UNDEFINED> instruction: 0x76746572
    1428:	6e006c61 	cdpvs	12, 0, cr6, cr0, cr1, {3}
    142c:	00727563 	rsbseq	r7, r2, r3, ror #10
    1430:	756e6472 	strbvc	r6, [lr, #-1138]!	; 0xfffffb8e
    1434:	5a5f006d 	bpl	17c15f0 <__bss_end+0x17b85b4>
    1438:	63733131 	cmnvs	r3, #1073741836	; 0x4000000c
    143c:	5f646568 	svcpl	0x00646568
    1440:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
    1444:	5f007664 	svcpl	0x00007664
    1448:	7337315a 	teqvc	r7, #-2147483626	; 0x80000016
    144c:	745f7465 	ldrbvc	r7, [pc], #-1125	; 1454 <shift+0x1454>
    1450:	5f6b7361 	svcpl	0x006b7361
    1454:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
    1458:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    145c:	6177006a 	cmnvs	r7, sl, rrx
    1460:	5f007469 	svcpl	0x00007469
    1464:	6f6e365a 	svcvs	0x006e365a
    1468:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
    146c:	5f006a6a 	svcpl	0x00006a6a
    1470:	6574395a 	ldrbvs	r3, [r4, #-2394]!	; 0xfffff6a6
    1474:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
    1478:	69657461 	stmdbvs	r5!, {r0, r5, r6, sl, ip, sp, lr}^
    147c:	6f682f00 	svcvs	0x00682f00
    1480:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    1484:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    1488:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
    148c:	494b2f76 	stmdbmi	fp, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
    1490:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
    1494:	6d2d534f 	stcvs	3, cr5, [sp, #-316]!	; 0xfffffec4
    1498:	65747361 	ldrbvs	r7, [r4, #-865]!	; 0xfffffc9f
    149c:	6f732f72 	svcvs	0x00732f72
    14a0:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    14a4:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    14a8:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    14ac:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    14b0:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    14b4:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    14b8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    14bc:	69614600 	stmdbvs	r1!, {r9, sl, lr}^
    14c0:	7865006c 	stmdavc	r5!, {r2, r3, r5, r6}^
    14c4:	6f637469 	svcvs	0x00637469
    14c8:	5f006564 	svcpl	0x00006564
    14cc:	6734325a 			; <UNDEFINED> instruction: 0x6734325a
    14d0:	615f7465 	cmpvs	pc, r5, ror #8
    14d4:	76697463 	strbtvc	r7, [r9], -r3, ror #8
    14d8:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
    14dc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    14e0:	6f635f73 	svcvs	0x00635f73
    14e4:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
    14e8:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
    14ec:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
    14f0:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
    14f4:	63697400 	cmnvs	r9, #0, 8
    14f8:	6f635f6b 	svcvs	0x00635f6b
    14fc:	5f746e75 	svcpl	0x00746e75
    1500:	75716572 	ldrbvc	r6, [r1, #-1394]!	; 0xfffffa8e
    1504:	64657269 	strbtvs	r7, [r5], #-617	; 0xfffffd97
    1508:	70695000 	rsbvc	r5, r9, r0
    150c:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    1510:	505f656c 	subspl	r6, pc, ip, ror #10
    1514:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1518:	5a5f0078 	bpl	17c1700 <__bss_end+0x17b86c4>
    151c:	65673431 	strbvs	r3, [r7, #-1073]!	; 0xfffffbcf
    1520:	69745f74 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1524:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
    1528:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    152c:	6c730076 	ldclvs	0, cr0, [r3], #-472	; 0xfffffe28
    1530:	00706565 	rsbseq	r6, r0, r5, ror #10
    1534:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 1480 <shift+0x1480>
    1538:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    153c:	6b69746e 	blvs	1a5e6fc <__bss_end+0x1a556c0>
    1540:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
    1544:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
    1548:	4f54522d 	svcmi	0x0054522d
    154c:	616d2d53 	cmnvs	sp, r3, asr sp
    1550:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
    1554:	756f732f 	strbvc	r7, [pc, #-815]!	; 122d <shift+0x122d>
    1558:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    155c:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    1560:	6f00646c 	svcvs	0x0000646c
    1564:	61726570 	cmnvs	r2, r0, ror r5
    1568:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    156c:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1570:	736f6c63 	cmnvc	pc, #25344	; 0x6300
    1574:	5f006a65 	svcpl	0x00006a65
    1578:	6567365a 	strbvs	r3, [r7, #-1626]!	; 0xfffff9a6
    157c:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
    1580:	6e660076 	mcrvs	0, 3, r0, cr6, cr6, {3}
    1584:	00656d61 	rsbeq	r6, r5, r1, ror #26
    1588:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    158c:	74007966 	strvc	r7, [r0], #-2406	; 0xfffff69a
    1590:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
    1594:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
    1598:	5a5f006e 	bpl	17c1758 <__bss_end+0x17b871c>
    159c:	70697034 	rsbvc	r7, r9, r4, lsr r0
    15a0:	634b5065 	movtvs	r5, #45157	; 0xb065
    15a4:	444e006a 	strbmi	r0, [lr], #-106	; 0xffffff96
    15a8:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    15ac:	5f656e69 	svcpl	0x00656e69
    15b0:	73627553 	cmnvc	r2, #348127232	; 0x14c00000
    15b4:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    15b8:	67006563 	strvs	r6, [r0, -r3, ror #10]
    15bc:	745f7465 	ldrbvc	r7, [pc], #-1125	; 15c4 <shift+0x15c4>
    15c0:	5f6b6369 	svcpl	0x006b6369
    15c4:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    15c8:	61700074 	cmnvs	r0, r4, ror r0
    15cc:	006d6172 	rsbeq	r6, sp, r2, ror r1
    15d0:	77355a5f 			; <UNDEFINED> instruction: 0x77355a5f
    15d4:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    15d8:	634b506a 	movtvs	r5, #45162	; 0xb06a
    15dc:	6567006a 	strbvs	r0, [r7, #-106]!	; 0xffffff96
    15e0:	61745f74 	cmnvs	r4, r4, ror pc
    15e4:	745f6b73 	ldrbvc	r6, [pc], #-2931	; 15ec <shift+0x15ec>
    15e8:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
    15ec:	5f6f745f 	svcpl	0x006f745f
    15f0:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
    15f4:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    15f8:	66756200 	ldrbtvs	r6, [r5], -r0, lsl #4
    15fc:	7a69735f 	bvc	1a5e380 <__bss_end+0x1a55344>
    1600:	72770065 	rsbsvc	r0, r7, #101	; 0x65
    1604:	00657469 	rsbeq	r7, r5, r9, ror #8
    1608:	5f746573 	svcpl	0x00746573
    160c:	6b736174 	blvs	1cd9be4 <__bss_end+0x1cd0ba8>
    1610:	6165645f 	cmnvs	r5, pc, asr r4
    1614:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    1618:	5a5f0065 	bpl	17c17b4 <__bss_end+0x17b8778>
    161c:	656c7335 	strbvs	r7, [ip, #-821]!	; 0xfffffccb
    1620:	6a6a7065 	bvs	1a9d7bc <__bss_end+0x1a94780>
    1624:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    1628:	6d65525f 	sfmvs	f5, 2, [r5, #-380]!	; 0xfffffe84
    162c:	696e6961 	stmdbvs	lr!, {r0, r5, r6, r8, fp, sp, lr}^
    1630:	5f00676e 	svcpl	0x0000676e
    1634:	6736325a 			; <UNDEFINED> instruction: 0x6736325a
    1638:	745f7465 	ldrbvc	r7, [pc], #-1125	; 1640 <shift+0x1640>
    163c:	5f6b7361 	svcpl	0x006b7361
    1640:	6b636974 	blvs	18dbc18 <__bss_end+0x18d2bdc>
    1644:	6f745f73 	svcvs	0x00745f73
    1648:	6165645f 	cmnvs	r5, pc, asr r4
    164c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    1650:	4e007665 	cfmadd32mi	mvax3, mvfx7, mvfx0, mvfx5
    1654:	5f495753 	svcpl	0x00495753
    1658:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
    165c:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
    1660:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1664:	756e7277 	strbvc	r7, [lr, #-631]!	; 0xfffffd89
    1668:	5a5f006d 	bpl	17c1824 <__bss_end+0x17b87e8>
    166c:	69617734 	stmdbvs	r1!, {r2, r4, r5, r8, r9, sl, ip, sp, lr}^
    1670:	6a6a6a74 	bvs	1a9c048 <__bss_end+0x1a9300c>
    1674:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1678:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
    167c:	36316a6c 	ldrtcc	r6, [r1], -ip, ror #20
    1680:	434f494e 	movtmi	r4, #63822	; 0xf94e
    1684:	4f5f6c74 	svcmi	0x005f6c74
    1688:	61726570 	cmnvs	r2, r0, ror r5
    168c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1690:	69007650 	stmdbvs	r0, {r4, r6, r9, sl, ip, sp, lr}
    1694:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
    1698:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
    169c:	00746e63 	rsbseq	r6, r4, r3, ror #28
    16a0:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
    16a4:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
    16a8:	6f6d0065 	svcvs	0x006d0065
    16ac:	62006564 	andvs	r6, r0, #100, 10	; 0x19000000
    16b0:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
    16b4:	5a5f0072 	bpl	17c1884 <__bss_end+0x17b8848>
    16b8:	61657234 	cmnvs	r5, r4, lsr r2
    16bc:	63506a64 	cmpvs	r0, #100, 20	; 0x64000
    16c0:	6572006a 	ldrbvs	r0, [r2, #-106]!	; 0xffffff96
    16c4:	646f6374 	strbtvs	r6, [pc], #-884	; 16cc <shift+0x16cc>
    16c8:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
    16cc:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
    16d0:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    16d4:	6f72705f 	svcvs	0x0072705f
    16d8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    16dc:	756f635f 	strbvc	r6, [pc, #-863]!	; 1385 <shift+0x1385>
    16e0:	6600746e 	strvs	r7, [r0], -lr, ror #8
    16e4:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
    16e8:	00656d61 	rsbeq	r6, r5, r1, ror #26
    16ec:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    16f0:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    16f4:	00646970 	rsbeq	r6, r4, r0, ror r9
    16f8:	6f345a5f 	svcvs	0x00345a5f
    16fc:	506e6570 	rsbpl	r6, lr, r0, ror r5
    1700:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
    1704:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
    1708:	704f5f65 	subvc	r5, pc, r5, ror #30
    170c:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; 1580 <shift+0x1580>
    1710:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1714:	75706e69 	ldrbvc	r6, [r0, #-3689]!	; 0xfffff197
    1718:	65640074 	strbvs	r0, [r4, #-116]!	; 0xffffff8c
    171c:	62007473 	andvs	r7, r0, #1929379840	; 0x73000000
    1720:	6f72657a 	svcvs	0x0072657a
    1724:	6e656c00 	cdpvs	12, 6, cr6, cr5, cr0, {0}
    1728:	00687467 	rsbeq	r7, r8, r7, ror #8
    172c:	62355a5f 	eorsvs	r5, r5, #389120	; 0x5f000
    1730:	6f72657a 	svcvs	0x0072657a
    1734:	00697650 	rsbeq	r7, r9, r0, asr r6
    1738:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 1684 <shift+0x1684>
    173c:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1740:	6b69746e 	blvs	1a5e900 <__bss_end+0x1a558c4>
    1744:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
    1748:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
    174c:	4f54522d 	svcmi	0x0054522d
    1750:	616d2d53 	cmnvs	sp, r3, asr sp
    1754:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
    1758:	756f732f 	strbvc	r7, [pc, #-815]!	; 1431 <shift+0x1431>
    175c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    1760:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1764:	2f62696c 	svccs	0x0062696c
    1768:	2f637273 	svccs	0x00637273
    176c:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
    1770:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    1774:	70632e67 	rsbvc	r2, r3, r7, ror #28
    1778:	68430070 	stmdavs	r3, {r4, r5, r6}^
    177c:	6f437261 	svcvs	0x00437261
    1780:	7241766e 	subvc	r7, r1, #115343360	; 0x6e00000
    1784:	656d0072 	strbvs	r0, [sp, #-114]!	; 0xffffff8e
    1788:	7473646d 	ldrbtvc	r6, [r3], #-1133	; 0xfffffb93
    178c:	74756f00 	ldrbtvc	r6, [r5], #-3840	; 0xfffff100
    1790:	00747570 	rsbseq	r7, r4, r0, ror r5
    1794:	6d365a5f 	vldmdbvs	r6!, {s10-s104}
    1798:	70636d65 	rsbvc	r6, r3, r5, ror #26
    179c:	764b5079 			; <UNDEFINED> instruction: 0x764b5079
    17a0:	00697650 	rsbeq	r7, r9, r0, asr r6
    17a4:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    17a8:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    17ac:	00797063 	rsbseq	r7, r9, r3, rrx
    17b0:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    17b4:	5f006e65 	svcpl	0x00006e65
    17b8:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    17bc:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
    17c0:	634b5070 	movtvs	r5, #45168	; 0xb070
    17c4:	695f3053 	ldmdbvs	pc, {r0, r1, r4, r6, ip, sp}^	; <UNPREDICTABLE>
    17c8:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    17cc:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    17d0:	4b506e65 	blmi	141d16c <__bss_end+0x1414130>
    17d4:	74610063 	strbtvc	r0, [r1], #-99	; 0xffffff9d
    17d8:	5f00696f 	svcpl	0x0000696f
    17dc:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    17e0:	4b50696f 	blmi	141bda4 <__bss_end+0x1412d68>
    17e4:	5a5f0063 	bpl	17c1978 <__bss_end+0x17b893c>
    17e8:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    17ec:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    17f0:	4b506350 	blmi	141a538 <__bss_end+0x14114fc>
    17f4:	73006963 	movwvc	r6, #2403	; 0x963
    17f8:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    17fc:	7300706d 	movwvc	r7, #109	; 0x6d
    1800:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1804:	6d007970 	vstrvs.16	s14, [r0, #-224]	; 0xffffff20	; <UNPREDICTABLE>
    1808:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    180c:	656d0079 	strbvs	r0, [sp, #-121]!	; 0xffffff87
    1810:	6372736d 	cmnvs	r2, #-1275068415	; 0xb4000001
    1814:	6f746900 	svcvs	0x00746900
    1818:	5a5f0061 	bpl	17c19a4 <__bss_end+0x17b8968>
    181c:	6f746934 	svcvs	0x00746934
    1820:	63506a61 	cmpvs	r0, #397312	; 0x61000
    1824:	2e2e006a 	cdpcs	0, 2, cr0, cr14, cr10, {3}
    1828:	2f2e2e2f 	svccs	0x002e2e2f
    182c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1830:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1834:	2f2e2e2f 	svccs	0x002e2e2f
    1838:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    183c:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    1840:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    1844:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    1848:	696c2f6d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp}^
    184c:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
    1850:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
    1854:	622f0053 	eorvs	r0, pc, #83	; 0x53
    1858:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    185c:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    1860:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    1864:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    1868:	61652d65 	cmnvs	r5, r5, ror #26
    186c:	7a2d6962 	bvc	b5bdfc <__bss_end+0xb52dc0>
    1870:	66566253 			; <UNDEFINED> instruction: 0x66566253
    1874:	63672f6e 	cmnvs	r7, #440	; 0x1b8
    1878:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    187c:	6f6e2d6d 	svcvs	0x006e2d6d
    1880:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1884:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1888:	30322d38 	eorscc	r2, r2, r8, lsr sp
    188c:	712d3931 			; <UNDEFINED> instruction: 0x712d3931
    1890:	75622f33 	strbvc	r2, [r2, #-3891]!	; 0xfffff0cd
    1894:	2f646c69 	svccs	0x00646c69
    1898:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    189c:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    18a0:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    18a4:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
    18a8:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
    18ac:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    18b0:	2f647261 	svccs	0x00647261
    18b4:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    18b8:	47006363 	strmi	r6, [r0, -r3, ror #6]
    18bc:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
    18c0:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
    18c4:	54003433 	strpl	r3, [r0], #-1075	; 0xfffffbcd
    18c8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    18cc:	50435f54 	subpl	r5, r3, r4, asr pc
    18d0:	6f635f55 	svcvs	0x00635f55
    18d4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    18d8:	63373161 	teqvs	r7, #1073741848	; 0x40000018
    18dc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    18e0:	00376178 	eorseq	r6, r7, r8, ror r1
    18e4:	5f617369 	svcpl	0x00617369
    18e8:	5f746962 	svcpl	0x00746962
    18ec:	645f7066 	ldrbvs	r7, [pc], #-102	; 18f4 <shift+0x18f4>
    18f0:	54006c62 	strpl	r6, [r0], #-3170	; 0xfffff39e
    18f4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    18f8:	50435f54 	subpl	r5, r3, r4, asr pc
    18fc:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1900:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    1904:	00736a36 	rsbseq	r6, r3, r6, lsr sl
    1908:	5f6d7261 	svcpl	0x006d7261
    190c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1910:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1914:	0074786d 	rsbseq	r7, r4, sp, ror #16
    1918:	47524154 			; <UNDEFINED> instruction: 0x47524154
    191c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1920:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1924:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1928:	33326d78 	teqcc	r2, #120, 26	; 0x1e00
    192c:	4d524100 	ldfmie	f4, [r2, #-0]
    1930:	0051455f 	subseq	r4, r1, pc, asr r5
    1934:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1938:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    193c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1940:	31316d72 	teqcc	r1, r2, ror sp
    1944:	32743635 	rsbscc	r3, r4, #55574528	; 0x3500000
    1948:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    194c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1950:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1958 <shift+0x1958>
    1954:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    1958:	52415400 	subpl	r5, r1, #0, 8
    195c:	5f544547 	svcpl	0x00544547
    1960:	5f555043 	svcpl	0x00555043
    1964:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1968:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    196c:	726f6337 	rsbvc	r6, pc, #-603979776	; 0xdc000000
    1970:	61786574 	cmnvs	r8, r4, ror r5
    1974:	42003335 	andmi	r3, r0, #-738197504	; 0xd4000000
    1978:	5f455341 	svcpl	0x00455341
    197c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1980:	5f4d385f 	svcpl	0x004d385f
    1984:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1988:	52415400 	subpl	r5, r1, #0, 8
    198c:	5f544547 	svcpl	0x00544547
    1990:	5f555043 	svcpl	0x00555043
    1994:	386d7261 	stmdacc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1998:	54003031 	strpl	r3, [r0], #-49	; 0xffffffcf
    199c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    19a0:	50435f54 	subpl	r5, r3, r4, asr pc
    19a4:	67785f55 			; <UNDEFINED> instruction: 0x67785f55
    19a8:	31656e65 	cmncc	r5, r5, ror #28
    19ac:	4d524100 	ldfmie	f4, [r2, #-0]
    19b0:	5343505f 	movtpl	r5, #12383	; 0x305f
    19b4:	5041415f 	subpl	r4, r1, pc, asr r1
    19b8:	495f5343 	ldmdbmi	pc, {r0, r1, r6, r8, r9, ip, lr}^	; <UNPREDICTABLE>
    19bc:	584d4d57 	stmdapl	sp, {r0, r1, r2, r4, r6, r8, sl, fp, lr}^
    19c0:	41540054 	cmpmi	r4, r4, asr r0
    19c4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    19c8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    19cc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    19d0:	00696437 	rsbeq	r6, r9, r7, lsr r4
    19d4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    19d8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    19dc:	00325f48 	eorseq	r5, r2, r8, asr #30
    19e0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    19e4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    19e8:	00335f48 	eorseq	r5, r3, r8, asr #30
    19ec:	47524154 			; <UNDEFINED> instruction: 0x47524154
    19f0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    19f4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    19f8:	64376d72 	ldrtvs	r6, [r7], #-3442	; 0xfffff28e
    19fc:	4142006d 	cmpmi	r2, sp, rrx
    1a00:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1a04:	5f484352 	svcpl	0x00484352
    1a08:	41420035 	cmpmi	r2, r5, lsr r0
    1a0c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1a10:	5f484352 	svcpl	0x00484352
    1a14:	41420036 	cmpmi	r2, r6, lsr r0
    1a18:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1a1c:	5f484352 	svcpl	0x00484352
    1a20:	41540037 	cmpmi	r4, r7, lsr r0
    1a24:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a28:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a2c:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    1a30:	00656c61 	rsbeq	r6, r5, r1, ror #24
    1a34:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1a38:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1a3c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1a40:	34396d72 	ldrtcc	r6, [r9], #-3442	; 0xfffff28e
    1a44:	00736536 	rsbseq	r6, r3, r6, lsr r5
    1a48:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1a4c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1a50:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1a54:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1a58:	33336d78 	teqcc	r3, #120, 26	; 0x1e00
    1a5c:	52415400 	subpl	r5, r1, #0, 8
    1a60:	5f544547 	svcpl	0x00544547
    1a64:	5f555043 	svcpl	0x00555043
    1a68:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1a6c:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    1a70:	61736900 	cmnvs	r3, r0, lsl #18
    1a74:	626f6e5f 	rsbvs	r6, pc, #1520	; 0x5f0
    1a78:	54007469 	strpl	r7, [r0], #-1129	; 0xfffffb97
    1a7c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a80:	50435f54 	subpl	r5, r3, r4, asr pc
    1a84:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1a88:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    1a8c:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
    1a90:	73690073 	cmnvc	r9, #115	; 0x73
    1a94:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1a98:	66765f74 	uhsub16vs	r5, r6, r4
    1a9c:	00327670 	eorseq	r7, r2, r0, ror r6
    1aa0:	5f4d5241 	svcpl	0x004d5241
    1aa4:	5f534350 	svcpl	0x00534350
    1aa8:	4e4b4e55 	mcrmi	14, 2, r4, cr11, cr5, {2}
    1aac:	004e574f 	subeq	r5, lr, pc, asr #14
    1ab0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ab4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ab8:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1abc:	65396d72 	ldrvs	r6, [r9, #-3442]!	; 0xfffff28e
    1ac0:	53414200 	movtpl	r4, #4608	; 0x1200
    1ac4:	52415f45 	subpl	r5, r1, #276	; 0x114
    1ac8:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 128d <shift+0x128d>
    1acc:	004a4554 	subeq	r4, sl, r4, asr r5
    1ad0:	5f6d7261 	svcpl	0x006d7261
    1ad4:	73666363 	cmnvc	r6, #-1946157055	; 0x8c000001
    1ad8:	74735f6d 	ldrbtvc	r5, [r3], #-3949	; 0xfffff093
    1adc:	00657461 	rsbeq	r7, r5, r1, ror #8
    1ae0:	70736e75 	rsbsvc	r6, r3, r5, ror lr
    1ae4:	735f6365 	cmpvc	pc, #-1811939327	; 0x94000001
    1ae8:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    1aec:	69007367 	stmdbvs	r0, {r0, r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1af0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1af4:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    1af8:	5f006365 	svcpl	0x00006365
    1afc:	7a6c635f 	bvc	1b1a880 <__bss_end+0x1b11844>
    1b00:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    1b04:	4d524100 	ldfmie	f4, [r2, #-0]
    1b08:	0043565f 	subeq	r5, r3, pc, asr r6
    1b0c:	5f6d7261 	svcpl	0x006d7261
    1b10:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1b14:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    1b18:	00656c61 	rsbeq	r6, r5, r1, ror #24
    1b1c:	5f4d5241 	svcpl	0x004d5241
    1b20:	4100454c 	tstmi	r0, ip, asr #10
    1b24:	565f4d52 			; <UNDEFINED> instruction: 0x565f4d52
    1b28:	52410053 	subpl	r0, r1, #83	; 0x53
    1b2c:	45475f4d 	strbmi	r5, [r7, #-3917]	; 0xfffff0b3
    1b30:	6d726100 	ldfvse	f6, [r2, #-0]
    1b34:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    1b38:	74735f65 	ldrbtvc	r5, [r3], #-3941	; 0xfffff09b
    1b3c:	676e6f72 			; <UNDEFINED> instruction: 0x676e6f72
    1b40:	006d7261 	rsbeq	r7, sp, r1, ror #4
    1b44:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    1b48:	2078656c 	rsbscs	r6, r8, ip, ror #10
    1b4c:	616f6c66 	cmnvs	pc, r6, ror #24
    1b50:	41540074 	cmpmi	r4, r4, ror r0
    1b54:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b58:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b5c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1b60:	61786574 	cmnvs	r8, r4, ror r5
    1b64:	54003531 	strpl	r3, [r0], #-1329	; 0xfffffacf
    1b68:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b6c:	50435f54 	subpl	r5, r3, r4, asr pc
    1b70:	61665f55 	cmnvs	r6, r5, asr pc
    1b74:	74363237 	ldrtvc	r3, [r6], #-567	; 0xfffffdc9
    1b78:	41540065 	cmpmi	r4, r5, rrx
    1b7c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b80:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b84:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1b88:	61786574 	cmnvs	r8, r4, ror r5
    1b8c:	41003731 	tstmi	r0, r1, lsr r7
    1b90:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    1b94:	52410054 	subpl	r0, r1, #84	; 0x54
    1b98:	544c5f4d 	strbpl	r5, [ip], #-3917	; 0xfffff0b3
    1b9c:	2f2e2e00 	svccs	0x002e2e00
    1ba0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1ba4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1ba8:	2f2e2e2f 	svccs	0x002e2e2f
    1bac:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1afc <shift+0x1afc>
    1bb0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1bb4:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    1bb8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1bbc:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    1bc0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1bc4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1bc8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1bcc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1bd0:	66347278 			; <UNDEFINED> instruction: 0x66347278
    1bd4:	52415400 	subpl	r5, r1, #0, 8
    1bd8:	5f544547 	svcpl	0x00544547
    1bdc:	5f555043 	svcpl	0x00555043
    1be0:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1be4:	42003032 	andmi	r3, r0, #50	; 0x32
    1be8:	5f455341 	svcpl	0x00455341
    1bec:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1bf0:	4d45375f 	stclmi	7, cr3, [r5, #-380]	; 0xfffffe84
    1bf4:	52415400 	subpl	r5, r1, #0, 8
    1bf8:	5f544547 	svcpl	0x00544547
    1bfc:	5f555043 	svcpl	0x00555043
    1c00:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1c04:	31617865 	cmncc	r1, r5, ror #16
    1c08:	61680032 	cmnvs	r8, r2, lsr r0
    1c0c:	61766873 	cmnvs	r6, r3, ror r8
    1c10:	00745f6c 	rsbseq	r5, r4, ip, ror #30
    1c14:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1c18:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1c1c:	4b365f48 	blmi	d99944 <__bss_end+0xd90908>
    1c20:	7369005a 	cmnvc	r9, #90	; 0x5a
    1c24:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1c28:	61007374 	tstvs	r0, r4, ror r3
    1c2c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1c30:	5f686372 	svcpl	0x00686372
    1c34:	5f6d7261 	svcpl	0x006d7261
    1c38:	69647768 	stmdbvs	r4!, {r3, r5, r6, r8, r9, sl, ip, sp, lr}^
    1c3c:	72610076 	rsbvc	r0, r1, #118	; 0x76
    1c40:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    1c44:	65645f75 	strbvs	r5, [r4, #-3957]!	; 0xfffff08b
    1c48:	69006373 	stmdbvs	r0, {r0, r1, r4, r5, r6, r8, r9, sp, lr}
    1c4c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1c50:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1c54:	00363170 	eorseq	r3, r6, r0, ror r1
    1c58:	5f4d5241 	svcpl	0x004d5241
    1c5c:	54004948 	strpl	r4, [r0], #-2376	; 0xfffff6b8
    1c60:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c64:	50435f54 	subpl	r5, r3, r4, asr pc
    1c68:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1c6c:	5400326d 	strpl	r3, [r0], #-621	; 0xfffffd93
    1c70:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c74:	50435f54 	subpl	r5, r3, r4, asr pc
    1c78:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1c7c:	5400336d 	strpl	r3, [r0], #-877	; 0xfffffc93
    1c80:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c84:	50435f54 	subpl	r5, r3, r4, asr pc
    1c88:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1c8c:	3031376d 	eorscc	r3, r1, sp, ror #14
    1c90:	41540030 	cmpmi	r4, r0, lsr r0
    1c94:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c98:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c9c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1ca0:	41540036 	cmpmi	r4, r6, lsr r0
    1ca4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ca8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cac:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1cb0:	41540037 	cmpmi	r4, r7, lsr r0
    1cb4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cb8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cbc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1cc0:	41540038 	cmpmi	r4, r8, lsr r0
    1cc4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cc8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ccc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1cd0:	41540039 	cmpmi	r4, r9, lsr r0
    1cd4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cd8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cdc:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    1ce0:	54003632 	strpl	r3, [r0], #-1586	; 0xfffff9ce
    1ce4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ce8:	50435f54 	subpl	r5, r3, r4, asr pc
    1cec:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1cf0:	6f6e5f6d 	svcvs	0x006e5f6d
    1cf4:	6c00656e 	cfstr32vs	mvfx6, [r0], {110}	; 0x6e
    1cf8:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    1cfc:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    1d00:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
    1d04:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
    1d08:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
    1d0c:	72610074 	rsbvc	r0, r1, #116	; 0x74
    1d10:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1d14:	635f6863 	cmpvs	pc, #6488064	; 0x630000
    1d18:	0065736d 	rsbeq	r7, r5, sp, ror #6
    1d1c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d20:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d24:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1d28:	31366d72 	teqcc	r6, r2, ror sp
    1d2c:	41540030 	cmpmi	r4, r0, lsr r0
    1d30:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d34:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d38:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1d3c:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1d40:	41540034 	cmpmi	r4, r4, lsr r0
    1d44:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d48:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d4c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1d50:	00653031 	rsbeq	r3, r5, r1, lsr r0
    1d54:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d58:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d5c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1d60:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1d64:	00376d78 	eorseq	r6, r7, r8, ror sp
    1d68:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d6c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d70:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1d74:	35376d72 	ldrcc	r6, [r7, #-3442]!	; 0xfffff28e
    1d78:	65663030 	strbvs	r3, [r6, #-48]!	; 0xffffffd0
    1d7c:	52415400 	subpl	r5, r1, #0, 8
    1d80:	5f544547 	svcpl	0x00544547
    1d84:	5f555043 	svcpl	0x00555043
    1d88:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1d8c:	00633031 	rsbeq	r3, r3, r1, lsr r0
    1d90:	5f6d7261 	svcpl	0x006d7261
    1d94:	646e6f63 	strbtvs	r6, [lr], #-3939	; 0xfffff09d
    1d98:	646f635f 	strbtvs	r6, [pc], #-863	; 1da0 <shift+0x1da0>
    1d9c:	52410065 	subpl	r0, r1, #101	; 0x65
    1da0:	43505f4d 	cmpmi	r0, #308	; 0x134
    1da4:	41415f53 	cmpmi	r1, r3, asr pc
    1da8:	00534350 	subseq	r4, r3, r0, asr r3
    1dac:	5f617369 	svcpl	0x00617369
    1db0:	5f746962 	svcpl	0x00746962
    1db4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1db8:	00325f38 	eorseq	r5, r2, r8, lsr pc
    1dbc:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1dc0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1dc4:	4d335f48 	ldcmi	15, cr5, [r3, #-288]!	; 0xfffffee0
    1dc8:	52415400 	subpl	r5, r1, #0, 8
    1dcc:	5f544547 	svcpl	0x00544547
    1dd0:	5f555043 	svcpl	0x00555043
    1dd4:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1dd8:	00743031 	rsbseq	r3, r4, r1, lsr r0
    1ddc:	5f6d7261 	svcpl	0x006d7261
    1de0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1de4:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1de8:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    1dec:	61736900 	cmnvs	r3, r0, lsl #18
    1df0:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
    1df4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1df8:	41540073 	cmpmi	r4, r3, ror r0
    1dfc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e00:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e04:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1e08:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1e0c:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    1e10:	616d7373 	smcvs	55091	; 0xd733
    1e14:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    1e18:	7069746c 	rsbvc	r7, r9, ip, ror #8
    1e1c:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    1e20:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e24:	50435f54 	subpl	r5, r3, r4, asr pc
    1e28:	78655f55 	stmdavc	r5!, {r0, r2, r4, r6, r8, r9, sl, fp, ip, lr}^
    1e2c:	736f6e79 	cmnvc	pc, #1936	; 0x790
    1e30:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    1e34:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e38:	50435f54 	subpl	r5, r3, r4, asr pc
    1e3c:	6f635f55 	svcvs	0x00635f55
    1e40:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1e44:	00323572 	eorseq	r3, r2, r2, ror r5
    1e48:	5f617369 	svcpl	0x00617369
    1e4c:	5f746962 	svcpl	0x00746962
    1e50:	76696474 			; <UNDEFINED> instruction: 0x76696474
    1e54:	65727000 	ldrbvs	r7, [r2, #-0]!
    1e58:	5f726566 	svcpl	0x00726566
    1e5c:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    1e60:	726f665f 	rsbvc	r6, pc, #99614720	; 0x5f00000
    1e64:	6234365f 	eorsvs	r3, r4, #99614720	; 0x5f00000
    1e68:	00737469 	rsbseq	r7, r3, r9, ror #8
    1e6c:	5f617369 	svcpl	0x00617369
    1e70:	5f746962 	svcpl	0x00746962
    1e74:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1e78:	006c6d66 	rsbeq	r6, ip, r6, ror #26
    1e7c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1e80:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1e84:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1e88:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1e8c:	32336178 	eorscc	r6, r3, #120, 2
    1e90:	52415400 	subpl	r5, r1, #0, 8
    1e94:	5f544547 	svcpl	0x00544547
    1e98:	5f555043 	svcpl	0x00555043
    1e9c:	366d7261 	strbtcc	r7, [sp], -r1, ror #4
    1ea0:	69003032 	stmdbvs	r0, {r1, r4, r5, ip, sp}
    1ea4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ea8:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1eac:	63363170 	teqvs	r6, #112, 2
    1eb0:	00766e6f 	rsbseq	r6, r6, pc, ror #28
    1eb4:	70736e75 	rsbsvc	r6, r3, r5, ror lr
    1eb8:	5f766365 	svcpl	0x00766365
    1ebc:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1ec0:	0073676e 	rsbseq	r6, r3, lr, ror #14
    1ec4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ec8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ecc:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1ed0:	31316d72 	teqcc	r1, r2, ror sp
    1ed4:	32743635 	rsbscc	r3, r4, #55574528	; 0x3500000
    1ed8:	41540073 	cmpmi	r4, r3, ror r0
    1edc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ee0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ee4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1ee8:	36323031 			; <UNDEFINED> instruction: 0x36323031
    1eec:	00736a65 	rsbseq	r6, r3, r5, ror #20
    1ef0:	5f6d7261 	svcpl	0x006d7261
    1ef4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1ef8:	54006d33 	strpl	r6, [r0], #-3379	; 0xfffff2cd
    1efc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f00:	50435f54 	subpl	r5, r3, r4, asr pc
    1f04:	61665f55 	cmnvs	r6, r5, asr pc
    1f08:	74363036 	ldrtvc	r3, [r6], #-54	; 0xffffffca
    1f0c:	41540065 	cmpmi	r4, r5, rrx
    1f10:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f14:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f18:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1f1c:	65363239 	ldrvs	r3, [r6, #-569]!	; 0xfffffdc7
    1f20:	4200736a 	andmi	r7, r0, #-1476395007	; 0xa8000001
    1f24:	5f455341 	svcpl	0x00455341
    1f28:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1f2c:	0054345f 	subseq	r3, r4, pc, asr r4
    1f30:	5f617369 	svcpl	0x00617369
    1f34:	5f746962 	svcpl	0x00746962
    1f38:	70797263 	rsbsvc	r7, r9, r3, ror #4
    1f3c:	61006f74 	tstvs	r0, r4, ror pc
    1f40:	725f6d72 	subsvc	r6, pc, #7296	; 0x1c80
    1f44:	5f736765 	svcpl	0x00736765
    1f48:	735f6e69 	cmpvc	pc, #1680	; 0x690
    1f4c:	65757165 	ldrbvs	r7, [r5, #-357]!	; 0xfffffe9b
    1f50:	0065636e 	rsbeq	r6, r5, lr, ror #6
    1f54:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1f58:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1f5c:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    1f60:	41540045 	cmpmi	r4, r5, asr #32
    1f64:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f68:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f6c:	3970655f 	ldmdbcc	r0!, {r0, r1, r2, r3, r4, r6, r8, sl, sp, lr}^
    1f70:	00323133 	eorseq	r3, r2, r3, lsr r1
    1f74:	5f617369 	svcpl	0x00617369
    1f78:	74616566 	strbtvc	r6, [r1], #-1382	; 0xfffffa9a
    1f7c:	00657275 	rsbeq	r7, r5, r5, ror r2
    1f80:	5f617369 	svcpl	0x00617369
    1f84:	5f746962 	svcpl	0x00746962
    1f88:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    1f8c:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    1f90:	6d726100 	ldfvse	f6, [r2, #-0]
    1f94:	6e616c5f 	mcrvs	12, 3, r6, cr1, cr15, {2}
    1f98:	756f5f67 	strbvc	r5, [pc, #-3943]!	; 1039 <shift+0x1039>
    1f9c:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    1fa0:	6a626f5f 	bvs	189dd24 <__bss_end+0x1894ce8>
    1fa4:	5f746365 	svcpl	0x00746365
    1fa8:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    1fac:	74756269 	ldrbtvc	r6, [r5], #-617	; 0xfffffd97
    1fb0:	685f7365 	ldmdavs	pc, {r0, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    1fb4:	006b6f6f 	rsbeq	r6, fp, pc, ror #30
    1fb8:	5f617369 	svcpl	0x00617369
    1fbc:	5f746962 	svcpl	0x00746962
    1fc0:	645f7066 	ldrbvs	r7, [pc], #-102	; 1fc8 <shift+0x1fc8>
    1fc4:	41003233 	tstmi	r0, r3, lsr r2
    1fc8:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    1fcc:	73690045 	cmnvc	r9, #69	; 0x45
    1fd0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1fd4:	65625f74 	strbvs	r5, [r2, #-3956]!	; 0xfffff08c
    1fd8:	41540038 	cmpmi	r4, r8, lsr r0
    1fdc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1fe0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1fe4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1fe8:	36373131 			; <UNDEFINED> instruction: 0x36373131
    1fec:	00737a6a 	rsbseq	r7, r3, sl, ror #20
    1ff0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1ff4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1ff8:	45355f48 	ldrmi	r5, [r5, #-3912]!	; 0xfffff0b8
    1ffc:	61736900 	cmnvs	r3, r0, lsl #18
    2000:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2004:	6964615f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sp, lr}^
    2008:	72700076 	rsbsvc	r0, r0, #118	; 0x76
    200c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    2010:	5f726f73 	svcpl	0x00726f73
    2014:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    2018:	6c6c6100 	stfvse	f6, [ip], #-0
    201c:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    2020:	72610073 	rsbvc	r0, r1, #115	; 0x73
    2024:	63705f6d 	cmnvs	r0, #436	; 0x1b4
    2028:	41420073 	hvcmi	8195	; 0x2003
    202c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2030:	5f484352 	svcpl	0x00484352
    2034:	61005435 	tstvs	r0, r5, lsr r4
    2038:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    203c:	34686372 	strbtcc	r6, [r8], #-882	; 0xfffffc8e
    2040:	41540074 	cmpmi	r4, r4, ror r0
    2044:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2048:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    204c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2050:	61786574 	cmnvs	r8, r4, ror r5
    2054:	6f633531 	svcvs	0x00633531
    2058:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    205c:	61003761 	tstvs	r0, r1, ror #14
    2060:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 2068 <shift+0x2068>
    2064:	5f656e75 	svcpl	0x00656e75
    2068:	66756277 			; <UNDEFINED> instruction: 0x66756277
    206c:	61746800 	cmnvs	r4, r0, lsl #16
    2070:	61685f62 	cmnvs	r8, r2, ror #30
    2074:	69006873 	stmdbvs	r0, {r0, r1, r4, r5, r6, fp, sp, lr}
    2078:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    207c:	715f7469 	cmpvc	pc, r9, ror #8
    2080:	6b726975 	blvs	1c9c65c <__bss_end+0x1c93620>
    2084:	5f6f6e5f 	svcpl	0x006f6e5f
    2088:	616c6f76 	smcvs	50934	; 0xc6f6
    208c:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    2090:	0065635f 	rsbeq	r6, r5, pc, asr r3
    2094:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2098:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    209c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    20a0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    20a4:	00306d78 	eorseq	r6, r0, r8, ror sp
    20a8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20ac:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20b0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    20b4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    20b8:	00316d78 	eorseq	r6, r1, r8, ror sp
    20bc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20c0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20c4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    20c8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    20cc:	00336d78 	eorseq	r6, r3, r8, ror sp
    20d0:	5f617369 	svcpl	0x00617369
    20d4:	5f746962 	svcpl	0x00746962
    20d8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    20dc:	00315f38 	eorseq	r5, r1, r8, lsr pc
    20e0:	5f6d7261 	svcpl	0x006d7261
    20e4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    20e8:	6d616e5f 	stclvs	14, cr6, [r1, #-380]!	; 0xfffffe84
    20ec:	73690065 	cmnvc	r9, #101	; 0x65
    20f0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    20f4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    20f8:	5f38766d 	svcpl	0x0038766d
    20fc:	73690033 	cmnvc	r9, #51	; 0x33
    2100:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2104:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2108:	5f38766d 	svcpl	0x0038766d
    210c:	41540034 	cmpmi	r4, r4, lsr r0
    2110:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2114:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2118:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    211c:	61786574 	cmnvs	r8, r4, ror r5
    2120:	54003335 	strpl	r3, [r0], #-821	; 0xfffffccb
    2124:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2128:	50435f54 	subpl	r5, r3, r4, asr pc
    212c:	6f635f55 	svcvs	0x00635f55
    2130:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2134:	00353561 	eorseq	r3, r5, r1, ror #10
    2138:	47524154 			; <UNDEFINED> instruction: 0x47524154
    213c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2140:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2144:	64376d72 	ldrtvs	r6, [r7], #-3442	; 0xfffff28e
    2148:	5400696d 	strpl	r6, [r0], #-2413	; 0xfffff693
    214c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2150:	50435f54 	subpl	r5, r3, r4, asr pc
    2154:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    2158:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    215c:	61736900 	cmnvs	r3, r0, lsl #18
    2160:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2164:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2168:	006d3376 	rsbeq	r3, sp, r6, ror r3
    216c:	5f6d7261 	svcpl	0x006d7261
    2170:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2174:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 217c <shift+0x217c>
    2178:	7261006d 	rsbvc	r0, r1, #109	; 0x6d
    217c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2180:	65356863 	ldrvs	r6, [r5, #-2147]!	; 0xfffff79d
    2184:	52415400 	subpl	r5, r1, #0, 8
    2188:	5f544547 	svcpl	0x00544547
    218c:	5f555043 	svcpl	0x00555043
    2190:	316d7261 	cmncc	sp, r1, ror #4
    2194:	65303230 	ldrvs	r3, [r0, #-560]!	; 0xfffffdd0
    2198:	53414200 	movtpl	r4, #4608	; 0x1200
    219c:	52415f45 	subpl	r5, r1, #276	; 0x114
    21a0:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    21a4:	4154004a 	cmpmi	r4, sl, asr #32
    21a8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    21ac:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    21b0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    21b4:	65383639 	ldrvs	r3, [r8, #-1593]!	; 0xfffff9c7
    21b8:	41540073 	cmpmi	r4, r3, ror r0
    21bc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    21c0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    21c4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    21c8:	74303437 	ldrtvc	r3, [r0], #-1079	; 0xfffffbc9
    21cc:	53414200 	movtpl	r4, #4608	; 0x1200
    21d0:	52415f45 	subpl	r5, r1, #276	; 0x114
    21d4:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    21d8:	7369004d 	cmnvc	r9, #77	; 0x4d
    21dc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    21e0:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    21e4:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    21e8:	52415400 	subpl	r5, r1, #0, 8
    21ec:	5f544547 	svcpl	0x00544547
    21f0:	5f555043 	svcpl	0x00555043
    21f4:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    21f8:	54003030 	strpl	r3, [r0], #-48	; 0xffffffd0
    21fc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2200:	50435f54 	subpl	r5, r3, r4, asr pc
    2204:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2208:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    220c:	73666a36 	cmnvc	r6, #221184	; 0x36000
    2210:	4d524100 	ldfmie	f4, [r2, #-0]
    2214:	00534c5f 	subseq	r4, r3, pc, asr ip
    2218:	47524154 			; <UNDEFINED> instruction: 0x47524154
    221c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2220:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2224:	30316d72 	eorscc	r6, r1, r2, ror sp
    2228:	00743032 	rsbseq	r3, r4, r2, lsr r0
    222c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2230:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2234:	5a365f48 	bpl	d99f5c <__bss_end+0xd90f20>
    2238:	52415400 	subpl	r5, r1, #0, 8
    223c:	5f544547 	svcpl	0x00544547
    2240:	5f555043 	svcpl	0x00555043
    2244:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2248:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    224c:	726f6335 	rsbvc	r6, pc, #-738197504	; 0xd4000000
    2250:	61786574 	cmnvs	r8, r4, ror r5
    2254:	41003535 	tstmi	r0, r5, lsr r5
    2258:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    225c:	415f5343 	cmpmi	pc, r3, asr #6
    2260:	53435041 	movtpl	r5, #12353	; 0x3041
    2264:	5046565f 	subpl	r5, r6, pc, asr r6
    2268:	52415400 	subpl	r5, r1, #0, 8
    226c:	5f544547 	svcpl	0x00544547
    2270:	5f555043 	svcpl	0x00555043
    2274:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    2278:	00327478 	eorseq	r7, r2, r8, ror r4
    227c:	5f617369 	svcpl	0x00617369
    2280:	5f746962 	svcpl	0x00746962
    2284:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    2288:	6d726100 	ldfvse	f6, [r2, #-0]
    228c:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    2290:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    2294:	73690072 	cmnvc	r9, #114	; 0x72
    2298:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    229c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    22a0:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
    22a4:	4154006d 	cmpmi	r4, sp, rrx
    22a8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    22ac:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    22b0:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    22b4:	65743632 	ldrbvs	r3, [r4, #-1586]!	; 0xfffff9ce
    22b8:	52415400 	subpl	r5, r1, #0, 8
    22bc:	5f544547 	svcpl	0x00544547
    22c0:	5f555043 	svcpl	0x00555043
    22c4:	7672616d 	ldrbtvc	r6, [r2], -sp, ror #2
    22c8:	5f6c6c65 	svcpl	0x006c6c65
    22cc:	00346a70 	eorseq	r6, r4, r0, ror sl
    22d0:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    22d4:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    22d8:	6f705f68 	svcvs	0x00705f68
    22dc:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    22e0:	41540072 	cmpmi	r4, r2, ror r0
    22e4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    22e8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    22ec:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    22f0:	61786574 	cmnvs	r8, r4, ror r5
    22f4:	61003533 	tstvs	r0, r3, lsr r5
    22f8:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 2300 <shift+0x2300>
    22fc:	5f656e75 	svcpl	0x00656e75
    2300:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2304:	615f7865 	cmpvs	pc, r5, ror #16
    2308:	73690039 	cmnvc	r9, #57	; 0x39
    230c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2310:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    2314:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    2318:	41540032 	cmpmi	r4, r2, lsr r0
    231c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2320:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2324:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2328:	61786574 	cmnvs	r8, r4, ror r5
    232c:	6f633237 	svcvs	0x00633237
    2330:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2334:	00333561 	eorseq	r3, r3, r1, ror #10
    2338:	5f617369 	svcpl	0x00617369
    233c:	5f746962 	svcpl	0x00746962
    2340:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2344:	42003262 	andmi	r3, r0, #536870918	; 0x20000006
    2348:	5f455341 	svcpl	0x00455341
    234c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2350:	0041375f 	subeq	r3, r1, pc, asr r7
    2354:	5f617369 	svcpl	0x00617369
    2358:	5f746962 	svcpl	0x00746962
    235c:	70746f64 	rsbsvc	r6, r4, r4, ror #30
    2360:	00646f72 	rsbeq	r6, r4, r2, ror pc
    2364:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2368:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    236c:	00305f48 	eorseq	r5, r0, r8, asr #30
    2370:	5f6d7261 	svcpl	0x006d7261
    2374:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    2378:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    237c:	6f6e5f65 	svcvs	0x006e5f65
    2380:	41006564 	tstmi	r0, r4, ror #10
    2384:	4d5f4d52 	ldclmi	13, cr4, [pc, #-328]	; 2244 <shift+0x2244>
    2388:	72610049 	rsbvc	r0, r1, #73	; 0x49
    238c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2390:	6b366863 	blvs	d9c524 <__bss_end+0xd934e8>
    2394:	6d726100 	ldfvse	f6, [r2, #-0]
    2398:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    239c:	006d3668 	rsbeq	r3, sp, r8, ror #12
    23a0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    23a4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    23a8:	00345f48 	eorseq	r5, r4, r8, asr #30
    23ac:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    23b0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    23b4:	52375f48 	eorspl	r5, r7, #72, 30	; 0x120
    23b8:	705f5f00 	subsvc	r5, pc, r0, lsl #30
    23bc:	6f63706f 	svcvs	0x0063706f
    23c0:	5f746e75 	svcpl	0x00746e75
    23c4:	00626174 	rsbeq	r6, r2, r4, ror r1
    23c8:	5f617369 	svcpl	0x00617369
    23cc:	5f746962 	svcpl	0x00746962
    23d0:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    23d4:	52415400 	subpl	r5, r1, #0, 8
    23d8:	5f544547 	svcpl	0x00544547
    23dc:	5f555043 	svcpl	0x00555043
    23e0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    23e4:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    23e8:	41540033 	cmpmi	r4, r3, lsr r0
    23ec:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    23f0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    23f4:	6e65675f 	mcrvs	7, 3, r6, cr5, cr15, {2}
    23f8:	63697265 	cmnvs	r9, #1342177286	; 0x50000006
    23fc:	00613776 	rsbeq	r3, r1, r6, ror r7
    2400:	5f617369 	svcpl	0x00617369
    2404:	5f746962 	svcpl	0x00746962
    2408:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    240c:	61006535 	tstvs	r0, r5, lsr r5
    2410:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2414:	5f686372 	svcpl	0x00686372
    2418:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    241c:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    2420:	5f656c69 	svcpl	0x00656c69
    2424:	42006563 	andmi	r6, r0, #415236096	; 0x18c00000
    2428:	5f455341 	svcpl	0x00455341
    242c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2430:	0041385f 	subeq	r3, r1, pc, asr r8
    2434:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2438:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    243c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2440:	30316d72 	eorscc	r6, r1, r2, ror sp
    2444:	00653232 	rsbeq	r3, r5, r2, lsr r2
    2448:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    244c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2450:	52385f48 	eorspl	r5, r8, #72, 30	; 0x120
    2454:	52415400 	subpl	r5, r1, #0, 8
    2458:	5f544547 	svcpl	0x00544547
    245c:	5f555043 	svcpl	0x00555043
    2460:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2464:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2468:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    246c:	61786574 	cmnvs	r8, r4, ror r5
    2470:	41003533 	tstmi	r0, r3, lsr r5
    2474:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    2478:	72610056 	rsbvc	r0, r1, #86	; 0x56
    247c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2480:	00346863 	eorseq	r6, r4, r3, ror #16
    2484:	5f6d7261 	svcpl	0x006d7261
    2488:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    248c:	72610035 	rsbvc	r0, r1, #53	; 0x35
    2490:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2494:	00376863 	eorseq	r6, r7, r3, ror #16
    2498:	5f6d7261 	svcpl	0x006d7261
    249c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    24a0:	6f6c0038 	svcvs	0x006c0038
    24a4:	6420676e 	strtvs	r6, [r0], #-1902	; 0xfffff892
    24a8:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    24ac:	41420065 	cmpmi	r2, r5, rrx
    24b0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    24b4:	5f484352 	svcpl	0x00484352
    24b8:	54004b36 	strpl	r4, [r0], #-2870	; 0xfffff4ca
    24bc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    24c0:	50435f54 	subpl	r5, r3, r4, asr pc
    24c4:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    24c8:	3034396d 	eorscc	r3, r4, sp, ror #18
    24cc:	72610074 	rsbvc	r0, r1, #116	; 0x74
    24d0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    24d4:	00366863 	eorseq	r6, r6, r3, ror #16
    24d8:	5f6d7261 	svcpl	0x006d7261
    24dc:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    24e0:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    24e4:	00656c61 	rsbeq	r6, r5, r1, ror #24
    24e8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    24ec:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    24f0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    24f4:	35376d72 	ldrcc	r6, [r7, #-3442]!	; 0xfffff28e
    24f8:	6d003030 	stcvs	0, cr3, [r0, #-192]	; 0xffffff40
    24fc:	6e696b61 	vnmulvs.f64	d22, d9, d17
    2500:	6f635f67 	svcvs	0x00635f67
    2504:	5f74736e 	svcpl	0x0074736e
    2508:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
    250c:	68740065 	ldmdavs	r4!, {r0, r2, r5, r6}^
    2510:	5f626d75 	svcpl	0x00626d75
    2514:	6c6c6163 	stfvse	f6, [ip], #-396	; 0xfffffe74
    2518:	6169765f 	cmnvs	r9, pc, asr r6
    251c:	62616c5f 	rsbvs	r6, r1, #24320	; 0x5f00
    2520:	69006c65 	stmdbvs	r0, {r0, r2, r5, r6, sl, fp, sp, lr}
    2524:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2528:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    252c:	00357670 	eorseq	r7, r5, r0, ror r6
    2530:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2534:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2538:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    253c:	31376d72 	teqcc	r7, r2, ror sp
    2540:	73690030 	cmnvc	r9, #48	; 0x30
    2544:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2548:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    254c:	6b36766d 	blvs	d9ff08 <__bss_end+0xd96ecc>
    2550:	52415400 	subpl	r5, r1, #0, 8
    2554:	5f544547 	svcpl	0x00544547
    2558:	5f555043 	svcpl	0x00555043
    255c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2560:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2564:	52415400 	subpl	r5, r1, #0, 8
    2568:	5f544547 	svcpl	0x00544547
    256c:	5f555043 	svcpl	0x00555043
    2570:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2574:	38617865 	stmdacc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    2578:	52415400 	subpl	r5, r1, #0, 8
    257c:	5f544547 	svcpl	0x00544547
    2580:	5f555043 	svcpl	0x00555043
    2584:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2588:	39617865 	stmdbcc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    258c:	4d524100 	ldfmie	f4, [r2, #-0]
    2590:	5343505f 	movtpl	r5, #12383	; 0x305f
    2594:	4350415f 	cmpmi	r0, #-1073741801	; 0xc0000017
    2598:	52410053 	subpl	r0, r1, #83	; 0x53
    259c:	43505f4d 	cmpmi	r0, #308	; 0x134
    25a0:	54415f53 	strbpl	r5, [r1], #-3923	; 0xfffff0ad
    25a4:	00534350 	subseq	r4, r3, r0, asr r3
    25a8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    25ac:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    25b0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    25b4:	30366d72 	eorscc	r6, r6, r2, ror sp
    25b8:	41540030 	cmpmi	r4, r0, lsr r0
    25bc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25c0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    25c4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    25c8:	74303237 	ldrtvc	r3, [r0], #-567	; 0xfffffdc9
    25cc:	52415400 	subpl	r5, r1, #0, 8
    25d0:	5f544547 	svcpl	0x00544547
    25d4:	5f555043 	svcpl	0x00555043
    25d8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    25dc:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    25e0:	6f630037 	svcvs	0x00630037
    25e4:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    25e8:	6f642078 	svcvs	0x00642078
    25ec:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    25f0:	52415400 	subpl	r5, r1, #0, 8
    25f4:	5f544547 	svcpl	0x00544547
    25f8:	5f555043 	svcpl	0x00555043
    25fc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2600:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2604:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    2608:	61786574 	cmnvs	r8, r4, ror r5
    260c:	54003335 	strpl	r3, [r0], #-821	; 0xfffffccb
    2610:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2614:	50435f54 	subpl	r5, r3, r4, asr pc
    2618:	6f635f55 	svcvs	0x00635f55
    261c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2620:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    2624:	61007375 	tstvs	r0, r5, ror r3
    2628:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    262c:	73690063 	cmnvc	r9, #99	; 0x63
    2630:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2634:	6f6d5f74 	svcvs	0x006d5f74
    2638:	36326564 	ldrtcc	r6, [r2], -r4, ror #10
    263c:	61736900 	cmnvs	r3, r0, lsl #18
    2640:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2644:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    2648:	00656c61 	rsbeq	r6, r5, r1, ror #24
    264c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2650:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2654:	735f5550 	cmpvc	pc, #80, 10	; 0x14000000
    2658:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    265c:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    2660:	30303131 	eorscc	r3, r0, r1, lsr r1
    2664:	52415400 	subpl	r5, r1, #0, 8
    2668:	5f544547 	svcpl	0x00544547
    266c:	5f555043 	svcpl	0x00555043
    2670:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    2674:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    2678:	645f0073 	ldrbvs	r0, [pc], #-115	; 2680 <shift+0x2680>
    267c:	5f746e6f 	svcpl	0x00746e6f
    2680:	5f657375 	svcpl	0x00657375
    2684:	65657274 	strbvs	r7, [r5, #-628]!	; 0xfffffd8c
    2688:	7265685f 	rsbvc	r6, r5, #6225920	; 0x5f0000
    268c:	54005f65 	strpl	r5, [r0], #-3941	; 0xfffff09b
    2690:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2694:	50435f54 	subpl	r5, r3, r4, asr pc
    2698:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    269c:	7430316d 	ldrtvc	r3, [r0], #-365	; 0xfffffe93
    26a0:	00696d64 	rsbeq	r6, r9, r4, ror #26
    26a4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    26a8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    26ac:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    26b0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    26b4:	00356178 	eorseq	r6, r5, r8, ror r1
    26b8:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    26bc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    26c0:	65746968 	ldrbvs	r6, [r4, #-2408]!	; 0xfffff698
    26c4:	72757463 	rsbsvc	r7, r5, #1660944384	; 0x63000000
    26c8:	72610065 	rsbvc	r0, r1, #101	; 0x65
    26cc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    26d0:	635f6863 	cmpvs	pc, #6488064	; 0x630000
    26d4:	54006372 	strpl	r6, [r0], #-882	; 0xfffffc8e
    26d8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    26dc:	50435f54 	subpl	r5, r3, r4, asr pc
    26e0:	6f635f55 	svcvs	0x00635f55
    26e4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    26e8:	6d73316d 	ldfvse	f3, [r3, #-436]!	; 0xfffffe4c
    26ec:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    26f0:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    26f4:	00796c70 	rsbseq	r6, r9, r0, ror ip
    26f8:	5f6d7261 	svcpl	0x006d7261
    26fc:	72727563 	rsbsvc	r7, r2, #415236096	; 0x18c00000
    2700:	5f746e65 	svcpl	0x00746e65
    2704:	61006363 	tstvs	r0, r3, ror #6
    2708:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 2710 <shift+0x2710>
    270c:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    2710:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
    2714:	69006e73 	stmdbvs	r0, {r0, r1, r4, r5, r6, r9, sl, fp, sp, lr}
    2718:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    271c:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    2720:	32336372 	eorscc	r6, r3, #-939524095	; 0xc8000001
    2724:	4d524100 	ldfmie	f4, [r2, #-0]
    2728:	004c505f 	subeq	r5, ip, pc, asr r0
    272c:	5f617369 	svcpl	0x00617369
    2730:	5f746962 	svcpl	0x00746962
    2734:	76706676 			; <UNDEFINED> instruction: 0x76706676
    2738:	73690033 	cmnvc	r9, #51	; 0x33
    273c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2740:	66765f74 	uhsub16vs	r5, r6, r4
    2744:	00347670 	eorseq	r7, r4, r0, ror r6
    2748:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    274c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2750:	54365f48 	ldrtpl	r5, [r6], #-3912	; 0xfffff0b8
    2754:	41420032 	cmpmi	r2, r2, lsr r0
    2758:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    275c:	5f484352 	svcpl	0x00484352
    2760:	4d5f4d38 	ldclmi	13, cr4, [pc, #-224]	; 2688 <shift+0x2688>
    2764:	004e4941 	subeq	r4, lr, r1, asr #18
    2768:	47524154 			; <UNDEFINED> instruction: 0x47524154
    276c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2770:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2774:	74396d72 	ldrtvc	r6, [r9], #-3442	; 0xfffff28e
    2778:	00696d64 	rsbeq	r6, r9, r4, ror #26
    277c:	5f4d5241 	svcpl	0x004d5241
    2780:	69004c41 	stmdbvs	r0, {r0, r6, sl, fp, lr}
    2784:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2788:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 25ec <shift+0x25ec>
    278c:	3365646f 	cmncc	r5, #1862270976	; 0x6f000000
    2790:	41420032 	cmpmi	r2, r2, lsr r0
    2794:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2798:	5f484352 	svcpl	0x00484352
    279c:	61004d37 	tstvs	r0, r7, lsr sp
    27a0:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 27a8 <shift+0x27a8>
    27a4:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    27a8:	616c5f74 	smcvs	50676	; 0xc5f4
    27ac:	006c6562 	rsbeq	r6, ip, r2, ror #10
    27b0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    27b4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    27b8:	735f5550 	cmpvc	pc, #80, 10	; 0x14000000
    27bc:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    27c0:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    27c4:	30313131 	eorscc	r3, r1, r1, lsr r1
    27c8:	52415400 	subpl	r5, r1, #0, 8
    27cc:	5f544547 	svcpl	0x00544547
    27d0:	5f555043 	svcpl	0x00555043
    27d4:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    27d8:	54003032 	strpl	r3, [r0], #-50	; 0xffffffce
    27dc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    27e0:	50435f54 	subpl	r5, r3, r4, asr pc
    27e4:	6f635f55 	svcvs	0x00635f55
    27e8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    27ec:	54003472 	strpl	r3, [r0], #-1138	; 0xfffffb8e
    27f0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    27f4:	50435f54 	subpl	r5, r3, r4, asr pc
    27f8:	6f635f55 	svcvs	0x00635f55
    27fc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2800:	54003572 	strpl	r3, [r0], #-1394	; 0xfffffa8e
    2804:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2808:	50435f54 	subpl	r5, r3, r4, asr pc
    280c:	6f635f55 	svcvs	0x00635f55
    2810:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2814:	54003772 	strpl	r3, [r0], #-1906	; 0xfffff88e
    2818:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    281c:	50435f54 	subpl	r5, r3, r4, asr pc
    2820:	6f635f55 	svcvs	0x00635f55
    2824:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2828:	69003872 	stmdbvs	r0, {r1, r4, r5, r6, fp, ip, sp}
    282c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2830:	6c5f7469 	cfldrdvs	mvd7, [pc], {105}	; 0x69
    2834:	00656170 	rsbeq	r6, r5, r0, ror r1
    2838:	47524154 			; <UNDEFINED> instruction: 0x47524154
    283c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2840:	735f5550 	cmpvc	pc, #80, 10	; 0x14000000
    2844:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    2848:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    284c:	00303131 	eorseq	r3, r0, r1, lsr r1
    2850:	5f617369 	svcpl	0x00617369
    2854:	5f746962 	svcpl	0x00746962
    2858:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    285c:	72615f6b 	rsbvc	r5, r1, #428	; 0x1ac
    2860:	6b36766d 	blvs	da021c <__bss_end+0xd971e0>
    2864:	7369007a 	cmnvc	r9, #122	; 0x7a
    2868:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    286c:	6f6e5f74 	svcvs	0x006e5f74
    2870:	69006d74 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, fp, sp, lr}
    2874:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2878:	615f7469 	cmpvs	pc, r9, ror #8
    287c:	34766d72 	ldrbtcc	r6, [r6], #-3442	; 0xfffff28e
    2880:	61736900 	cmnvs	r3, r0, lsl #18
    2884:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2888:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    288c:	69003576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, ip, sp}
    2890:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2894:	615f7469 	cmpvs	pc, r9, ror #8
    2898:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    289c:	61736900 	cmnvs	r3, r0, lsl #18
    28a0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    28a4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    28a8:	69003776 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, sl, ip, sp}
    28ac:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    28b0:	615f7469 	cmpvs	pc, r9, ror #8
    28b4:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    28b8:	6f645f00 	svcvs	0x00645f00
    28bc:	755f746e 	ldrbvc	r7, [pc, #-1134]	; 2456 <shift+0x2456>
    28c0:	725f6573 	subsvc	r6, pc, #482344960	; 0x1cc00000
    28c4:	685f7874 	ldmdavs	pc, {r2, r4, r5, r6, fp, ip, sp, lr}^	; <UNPREDICTABLE>
    28c8:	5f657265 	svcpl	0x00657265
    28cc:	49515500 	ldmdbmi	r1, {r8, sl, ip, lr}^
    28d0:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    28d4:	6d726100 	ldfvse	f6, [r2, #-0]
    28d8:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    28dc:	72610065 	rsbvc	r0, r1, #101	; 0x65
    28e0:	70635f6d 	rsbvc	r5, r3, sp, ror #30
    28e4:	6e695f70 	mcrvs	15, 3, r5, cr9, cr0, {3}
    28e8:	77726574 			; <UNDEFINED> instruction: 0x77726574
    28ec:	006b726f 	rsbeq	r7, fp, pc, ror #4
    28f0:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    28f4:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
    28f8:	52415400 	subpl	r5, r1, #0, 8
    28fc:	5f544547 	svcpl	0x00544547
    2900:	5f555043 	svcpl	0x00555043
    2904:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    2908:	00743032 	rsbseq	r3, r4, r2, lsr r0
    290c:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    2910:	0071655f 	rsbseq	r6, r1, pc, asr r5
    2914:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2918:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    291c:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    2920:	36323561 	ldrtcc	r3, [r2], -r1, ror #10
    2924:	6d726100 	ldfvse	f6, [r2, #-0]
    2928:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    292c:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    2930:	5f626d75 	svcpl	0x00626d75
    2934:	69647768 	stmdbvs	r4!, {r3, r5, r6, r8, r9, sl, ip, sp, lr}^
    2938:	74680076 	strbtvc	r0, [r8], #-118	; 0xffffff8a
    293c:	655f6261 	ldrbvs	r6, [pc, #-609]	; 26e3 <shift+0x26e3>
    2940:	6f705f71 	svcvs	0x00705f71
    2944:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    2948:	41540072 	cmpmi	r4, r2, ror r0
    294c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2950:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2954:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2958:	47003036 	smladxmi	r0, r6, r0, r3
    295c:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    2960:	38203731 	stmdacc	r0!, {r0, r4, r5, r8, r9, sl, ip, sp}
    2964:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
    2968:	31303220 	teqcc	r0, r0, lsr #4
    296c:	30373039 	eorscc	r3, r7, r9, lsr r0
    2970:	72282033 	eorvc	r2, r8, #51	; 0x33
    2974:	61656c65 	cmnvs	r5, r5, ror #24
    2978:	20296573 	eorcs	r6, r9, r3, ror r5
    297c:	6363675b 	cmnvs	r3, #23855104	; 0x16c0000
    2980:	622d382d 	eorvs	r3, sp, #2949120	; 0x2d0000
    2984:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
    2988:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
    298c:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    2990:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
    2994:	32303337 	eorscc	r3, r0, #-603979776	; 0xdc000000
    2998:	2d205d37 	stccs	13, cr5, [r0, #-220]!	; 0xffffff24
    299c:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    29a0:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    29a4:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    29a8:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    29ac:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    29b0:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    29b4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    29b8:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    29bc:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    29c0:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    29c4:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    29c8:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    29cc:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    29d0:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    29d4:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    29d8:	62662d20 	rsbvs	r2, r6, #32, 26	; 0x800
    29dc:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    29e0:	2d676e69 	stclcs	14, cr6, [r7, #-420]!	; 0xfffffe5c
    29e4:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    29e8:	2d206363 	stccs	3, cr6, [r0, #-396]!	; 0xfffffe74
    29ec:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 285c <shift+0x285c>
    29f0:	63617473 	cmnvs	r1, #1929379840	; 0x73000000
    29f4:	72702d6b 	rsbsvc	r2, r0, #6848	; 0x1ac0
    29f8:	6365746f 	cmnvs	r5, #1862270976	; 0x6f000000
    29fc:	20726f74 	rsbscs	r6, r2, r4, ror pc
    2a00:	6f6e662d 	svcvs	0x006e662d
    2a04:	6c6e692d 			; <UNDEFINED> instruction: 0x6c6e692d
    2a08:	20656e69 	rsbcs	r6, r5, r9, ror #28
    2a0c:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
    2a10:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    2a14:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
    2a18:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
    2a1c:	006e6564 	rsbeq	r6, lr, r4, ror #10
    2a20:	5f6d7261 	svcpl	0x006d7261
    2a24:	5f636970 	svcpl	0x00636970
    2a28:	69676572 	stmdbvs	r7!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    2a2c:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
    2a30:	52415400 	subpl	r5, r1, #0, 8
    2a34:	5f544547 	svcpl	0x00544547
    2a38:	5f555043 	svcpl	0x00555043
    2a3c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2a40:	306d7865 	rsbcc	r7, sp, r5, ror #16
    2a44:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    2a48:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    2a4c:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    2a50:	41540079 	cmpmi	r4, r9, ror r0
    2a54:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2a58:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2a5c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2a60:	65363639 	ldrvs	r3, [r6, #-1593]!	; 0xfffff9c7
    2a64:	41540073 	cmpmi	r4, r3, ror r0
    2a68:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2a6c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2a70:	63706d5f 	cmnvs	r0, #6080	; 0x17c0
    2a74:	6e65726f 	cdpvs	2, 6, cr7, cr5, cr15, {3}
    2a78:	7066766f 	rsbvc	r7, r6, pc, ror #12
    2a7c:	61736900 	cmnvs	r3, r0, lsl #18
    2a80:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2a84:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    2a88:	635f6b72 	cmpvs	pc, #116736	; 0x1c800
    2a8c:	6c5f336d 	mrrcvs	3, 6, r3, pc, cr13	; <UNPREDICTABLE>
    2a90:	00647264 	rsbeq	r7, r4, r4, ror #4
    2a94:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2a98:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2a9c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2aa0:	30376d72 	eorscc	r6, r7, r2, ror sp
    2aa4:	41006930 	tstmi	r0, r0, lsr r9
    2aa8:	435f4d52 	cmpmi	pc, #5248	; 0x1480
    2aac:	72610043 	rsbvc	r0, r1, #67	; 0x43
    2ab0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2ab4:	5f386863 	svcpl	0x00386863
    2ab8:	41540032 	cmpmi	r4, r2, lsr r0
    2abc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2ac0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2ac4:	706d665f 	rsbvc	r6, sp, pc, asr r6
    2ac8:	00363236 	eorseq	r3, r6, r6, lsr r2
    2acc:	5f4d5241 	svcpl	0x004d5241
    2ad0:	61005343 	tstvs	r0, r3, asr #6
    2ad4:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    2ad8:	5f363170 	svcpl	0x00363170
    2adc:	74736e69 	ldrbtvc	r6, [r3], #-3689	; 0xfffff197
    2ae0:	6d726100 	ldfvse	f6, [r2, #-0]
    2ae4:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
    2ae8:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    2aec:	54006863 	strpl	r6, [r0], #-2147	; 0xfffff79d
    2af0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2af4:	50435f54 	subpl	r5, r3, r4, asr pc
    2af8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2afc:	006d376d 	rsbeq	r3, sp, sp, ror #14
    2b00:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2b04:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2b08:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2b0c:	30376d72 	eorscc	r6, r7, r2, ror sp
    2b10:	52415400 	subpl	r5, r1, #0, 8
    2b14:	5f544547 	svcpl	0x00544547
    2b18:	5f555043 	svcpl	0x00555043
    2b1c:	326d7261 	rsbcc	r7, sp, #268435462	; 0x10000006
    2b20:	61003035 	tstvs	r0, r5, lsr r0
    2b24:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2b28:	37686372 			; <UNDEFINED> instruction: 0x37686372
    2b2c:	54006d65 	strpl	r6, [r0], #-3429	; 0xfffff29b
    2b30:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2b34:	50435f54 	subpl	r5, r3, r4, asr pc
    2b38:	6f635f55 	svcvs	0x00635f55
    2b3c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2b40:	00323761 	eorseq	r3, r2, r1, ror #14
    2b44:	5f6d7261 	svcpl	0x006d7261
    2b48:	5f736370 	svcpl	0x00736370
    2b4c:	61666564 	cmnvs	r6, r4, ror #10
    2b50:	00746c75 	rsbseq	r6, r4, r5, ror ip
    2b54:	5f4d5241 	svcpl	0x004d5241
    2b58:	5f534350 	svcpl	0x00534350
    2b5c:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    2b60:	4f4c5f53 	svcmi	0x004c5f53
    2b64:	004c4143 	subeq	r4, ip, r3, asr #2
    2b68:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2b6c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2b70:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2b74:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2b78:	35376178 	ldrcc	r6, [r7, #-376]!	; 0xfffffe88
    2b7c:	52415400 	subpl	r5, r1, #0, 8
    2b80:	5f544547 	svcpl	0x00544547
    2b84:	5f555043 	svcpl	0x00555043
    2b88:	6f727473 	svcvs	0x00727473
    2b8c:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    2b90:	7261006d 	rsbvc	r0, r1, #109	; 0x6d
    2b94:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2b98:	745f6863 	ldrbvc	r6, [pc], #-2147	; 2ba0 <shift+0x2ba0>
    2b9c:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    2ba0:	72610031 	rsbvc	r0, r1, #49	; 0x31
    2ba4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2ba8:	745f6863 	ldrbvc	r6, [pc], #-2147	; 2bb0 <shift+0x2bb0>
    2bac:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    2bb0:	41540032 	cmpmi	r4, r2, lsr r0
    2bb4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2bb8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2bbc:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    2bc0:	0074786d 	rsbseq	r7, r4, sp, ror #16
    2bc4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2bc8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2bcc:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2bd0:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    2bd4:	54007432 	strpl	r7, [r0], #-1074	; 0xfffffbce
    2bd8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2bdc:	50435f54 	subpl	r5, r3, r4, asr pc
    2be0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2be4:	0064376d 	rsbeq	r3, r4, sp, ror #14
    2be8:	5f617369 	svcpl	0x00617369
    2bec:	5f746962 	svcpl	0x00746962
    2bf0:	6100706d 	tstvs	r0, sp, rrx
    2bf4:	6c5f6d72 	mrrcvs	13, 7, r6, pc, cr2	; <UNPREDICTABLE>
    2bf8:	63735f64 	cmnvs	r3, #100, 30	; 0x190
    2bfc:	00646568 	rsbeq	r6, r4, r8, ror #10
    2c00:	5f6d7261 	svcpl	0x006d7261
    2c04:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2c08:	00315f38 	eorseq	r5, r1, r8, lsr pc

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
  20:	8b040e42 	blhi	103930 <__bss_end+0xfa8f4>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x3477f4>
  28:	420d0d66 	andmi	r0, sp, #6528	; 0x1980
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	0000806c 	andeq	r8, r0, ip, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1fa914>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9c44>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080ac 	andeq	r8, r0, ip, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfa944>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x347844>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080e4 	andeq	r8, r0, r4, ror #1
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfa964>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x347864>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008110 	andeq	r8, r0, r0, lsl r1
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfa984>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x347884>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008130 	andeq	r8, r0, r0, lsr r1
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfa9a4>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x3478a4>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008148 	andeq	r8, r0, r8, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfa9c4>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x3478c4>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008160 	andeq	r8, r0, r0, ror #2
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfa9e4>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x3478e4>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008178 	andeq	r8, r0, r8, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfaa04>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x347904>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	00008184 	andeq	r8, r0, r4, lsl #3
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1faa1c>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081dc 	ldrdeq	r8, [r0], -ip
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1faa3c>
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
 194:	00000080 	andeq	r0, r0, r0, lsl #1
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1faa6c>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 1a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1a8:	00000018 	andeq	r0, r0, r8, lsl r0
 1ac:	00000178 	andeq	r0, r0, r8, ror r1
 1b0:	000082b4 			; <UNDEFINED> instruction: 0x000082b4
 1b4:	0000016c 	andeq	r0, r0, ip, ror #2
 1b8:	8b080e42 	blhi	203ac8 <__bss_end+0x1faa8c>
 1bc:	42018e02 	andmi	r8, r1, #2, 28
 1c0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1c4:	0000000c 	andeq	r0, r0, ip
 1c8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1cc:	7c020001 	stcvc	0, cr0, [r2], {1}
 1d0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001c4 	andeq	r0, r0, r4, asr #3
 1dc:	00008420 	andeq	r8, r0, r0, lsr #8
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfaab8>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x3479b8>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001c4 	andeq	r0, r0, r4, asr #3
 1fc:	0000844c 	andeq	r8, r0, ip, asr #8
 200:	0000002c 	andeq	r0, r0, ip, lsr #32
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfaad8>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x3479d8>
 20c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001c4 	andeq	r0, r0, r4, asr #3
 21c:	00008478 	andeq	r8, r0, r8, ror r4
 220:	0000001c 	andeq	r0, r0, ip, lsl r0
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfaaf8>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x3479f8>
 22c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001c4 	andeq	r0, r0, r4, asr #3
 23c:	00008494 	muleq	r0, r4, r4
 240:	00000044 	andeq	r0, r0, r4, asr #32
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfab18>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x347a18>
 24c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001c4 	andeq	r0, r0, r4, asr #3
 25c:	000084d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfab38>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x347a38>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001c4 	andeq	r0, r0, r4, asr #3
 27c:	00008528 	andeq	r8, r0, r8, lsr #10
 280:	00000050 	andeq	r0, r0, r0, asr r0
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfab58>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347a58>
 28c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001c4 	andeq	r0, r0, r4, asr #3
 29c:	00008578 	andeq	r8, r0, r8, ror r5
 2a0:	0000002c 	andeq	r0, r0, ip, lsr #32
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfab78>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347a78>
 2ac:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001c4 	andeq	r0, r0, r4, asr #3
 2bc:	000085a4 	andeq	r8, r0, r4, lsr #11
 2c0:	00000050 	andeq	r0, r0, r0, asr r0
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfab98>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x347a98>
 2cc:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001c4 	andeq	r0, r0, r4, asr #3
 2dc:	000085f4 	strdeq	r8, [r0], -r4
 2e0:	00000044 	andeq	r0, r0, r4, asr #32
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfabb8>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x347ab8>
 2ec:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001c4 	andeq	r0, r0, r4, asr #3
 2fc:	00008638 	andeq	r8, r0, r8, lsr r6
 300:	00000050 	andeq	r0, r0, r0, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfabd8>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x347ad8>
 30c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001c4 	andeq	r0, r0, r4, asr #3
 31c:	00008688 	andeq	r8, r0, r8, lsl #13
 320:	00000054 	andeq	r0, r0, r4, asr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfabf8>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x347af8>
 32c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001c4 	andeq	r0, r0, r4, asr #3
 33c:	000086dc 	ldrdeq	r8, [r0], -ip
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfac18>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x347b18>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001c4 	andeq	r0, r0, r4, asr #3
 35c:	00008718 	andeq	r8, r0, r8, lsl r7
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfac38>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347b38>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001c4 	andeq	r0, r0, r4, asr #3
 37c:	00008754 	andeq	r8, r0, r4, asr r7
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfac58>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347b58>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001c4 	andeq	r0, r0, r4, asr #3
 39c:	00008790 	muleq	r0, r0, r7
 3a0:	0000003c 	andeq	r0, r0, ip, lsr r0
 3a4:	8b040e42 	blhi	103cb4 <__bss_end+0xfac78>
 3a8:	0b0d4201 	bleq	350bb4 <__bss_end+0x347b78>
 3ac:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 3b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 3b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3b8:	000001c4 	andeq	r0, r0, r4, asr #3
 3bc:	000087cc 	andeq	r8, r0, ip, asr #15
 3c0:	000000b4 	strheq	r0, [r0], -r4
 3c4:	8b080e42 	blhi	203cd4 <__bss_end+0x1fac98>
 3c8:	42018e02 	andmi	r8, r1, #2, 28
 3cc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3d0:	080d0c52 	stmdaeq	sp, {r1, r4, r6, sl, fp}
 3d4:	0000000c 	andeq	r0, r0, ip
 3d8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3dc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3e0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003d4 	ldrdeq	r0, [r0], -r4
 3ec:	00008880 	andeq	r8, r0, r0, lsl #17
 3f0:	00000174 	andeq	r0, r0, r4, ror r1
 3f4:	8b080e42 	blhi	203d04 <__bss_end+0x1facc8>
 3f8:	42018e02 	andmi	r8, r1, #2, 28
 3fc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 400:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003d4 	ldrdeq	r0, [r0], -r4
 40c:	000089f4 	strdeq	r8, [r0], -r4
 410:	0000009c 	muleq	r0, ip, r0
 414:	8b040e42 	blhi	103d24 <__bss_end+0xface8>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x347be8>
 41c:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003d4 	ldrdeq	r0, [r0], -r4
 42c:	00008a90 	muleq	r0, r0, sl
 430:	000000c0 	andeq	r0, r0, r0, asr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfad08>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x347c08>
 43c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003d4 	ldrdeq	r0, [r0], -r4
 44c:	00008b50 	andeq	r8, r0, r0, asr fp
 450:	000000ac 	andeq	r0, r0, ip, lsr #1
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfad28>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347c28>
 45c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 460:	000ecb42 	andeq	ip, lr, r2, asr #22
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003d4 	ldrdeq	r0, [r0], -r4
 46c:	00008bfc 	strdeq	r8, [r0], -ip
 470:	00000054 	andeq	r0, r0, r4, asr r0
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfad48>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347c48>
 47c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003d4 	ldrdeq	r0, [r0], -r4
 48c:	00008c50 	andeq	r8, r0, r0, asr ip
 490:	00000068 	andeq	r0, r0, r8, rrx
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfad68>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347c68>
 49c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003d4 	ldrdeq	r0, [r0], -r4
 4ac:	00008cb8 			; <UNDEFINED> instruction: 0x00008cb8
 4b0:	00000080 	andeq	r0, r0, r0, lsl #1
 4b4:	8b040e42 	blhi	103dc4 <__bss_end+0xfad88>
 4b8:	0b0d4201 	bleq	350cc4 <__bss_end+0x347c88>
 4bc:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c4:	0000000c 	andeq	r0, r0, ip
 4c8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4cc:	7c010001 	stcvc	0, cr0, [r1], {1}
 4d0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4d4:	0000000c 	andeq	r0, r0, ip
 4d8:	000004c4 	andeq	r0, r0, r4, asr #9
 4dc:	00008d38 	andeq	r8, r0, r8, lsr sp
 4e0:	000001ec 	andeq	r0, r0, ip, ror #3
