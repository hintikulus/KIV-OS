
./oled_task:     file format elf32-littlearm


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
    8064:	00009734 	andeq	r9, r0, r4, lsr r7
    8068:	00009744 	andeq	r9, r0, r4, asr #14

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
    81d4:	00009720 	andeq	r9, r0, r0, lsr #14
    81d8:	00009720 	andeq	r9, r0, r0, lsr #14

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
    822c:	00009720 	andeq	r9, r0, r0, lsr #14
    8230:	00009720 	andeq	r9, r0, r0, lsr #14

00008234 <main>:
main():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/oled_task/main.cpp:27
	"My favourite sport is ARM wrestling",
	"Old MacDonald had a farm, EIGRP",
};

int main(int argc, char** argv)
{
    8234:	e92d4800 	push	{fp, lr}
    8238:	e28db004 	add	fp, sp, #4
    823c:	e24dd020 	sub	sp, sp, #32
    8240:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    8244:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
/home/hintik/dev/KIV-RTOS-master/sources/userspace/oled_task/main.cpp:28
	COLED_Display disp("DEV:oled");
    8248:	e24b3014 	sub	r3, fp, #20
    824c:	e59f10d8 	ldr	r1, [pc, #216]	; 832c <main+0xf8>
    8250:	e1a00003 	mov	r0, r3
    8254:	eb00027f 	bl	8c58 <_ZN13COLED_DisplayC1EPKc>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/oled_task/main.cpp:29
	disp.Clear(false);
    8258:	e24b3014 	sub	r3, fp, #20
    825c:	e3a01000 	mov	r1, #0
    8260:	e1a00003 	mov	r0, r3
    8264:	eb0002b2 	bl	8d34 <_ZN13COLED_Display5ClearEb>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/oled_task/main.cpp:30
	disp.Put_String(10, 10, "KIV-RTOS init...");
    8268:	e24b0014 	sub	r0, fp, #20
    826c:	e59f30bc 	ldr	r3, [pc, #188]	; 8330 <main+0xfc>
    8270:	e3a0200a 	mov	r2, #10
    8274:	e3a0100a 	mov	r1, #10
    8278:	eb000377 	bl	905c <_ZN13COLED_Display10Put_StringEttPKc>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/oled_task/main.cpp:31
	disp.Flip();
    827c:	e24b3014 	sub	r3, fp, #20
    8280:	e1a00003 	mov	r0, r3
    8284:	eb00035e 	bl	9004 <_ZN13COLED_Display4FlipEv>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/oled_task/main.cpp:33

	uint32_t trng_file = open("DEV:trng", NFile_Open_Mode::Read_Only);
    8288:	e3a01000 	mov	r1, #0
    828c:	e59f00a0 	ldr	r0, [pc, #160]	; 8334 <main+0x100>
    8290:	eb000047 	bl	83b4 <_Z4openPKc15NFile_Open_Mode>
    8294:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/oled_task/main.cpp:34
	uint32_t num = 0;
    8298:	e3a03000 	mov	r3, #0
    829c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/userspace/oled_task/main.cpp:36

	sleep(0x800, 0x800);
    82a0:	e3a01b02 	mov	r1, #2048	; 0x800
    82a4:	e3a00b02 	mov	r0, #2048	; 0x800
    82a8:	eb0000be 	bl	85a8 <_Z5sleepjj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/oled_task/main.cpp:41 (discriminator 1)

	while (true)
	{
		// ziskame si nahodne cislo a vybereme podle toho zpravu
		read(trng_file, reinterpret_cast<char*>(&num), sizeof(num));
    82ac:	e24b3018 	sub	r3, fp, #24
    82b0:	e3a02004 	mov	r2, #4
    82b4:	e1a01003 	mov	r1, r3
    82b8:	e51b0008 	ldr	r0, [fp, #-8]
    82bc:	eb00004d 	bl	83f8 <_Z4readjPcj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/oled_task/main.cpp:42 (discriminator 1)
		const char* msg = messages[num % (sizeof(messages) / sizeof(const char*))];
    82c0:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    82c4:	e59f306c 	ldr	r3, [pc, #108]	; 8338 <main+0x104>
    82c8:	e0832193 	umull	r2, r3, r3, r1
    82cc:	e1a02123 	lsr	r2, r3, #2
    82d0:	e1a03002 	mov	r3, r2
    82d4:	e1a03103 	lsl	r3, r3, #2
    82d8:	e0833002 	add	r3, r3, r2
    82dc:	e0412003 	sub	r2, r1, r3
    82e0:	e59f3054 	ldr	r3, [pc, #84]	; 833c <main+0x108>
    82e4:	e7933102 	ldr	r3, [r3, r2, lsl #2]
    82e8:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/oled_task/main.cpp:44 (discriminator 1)

		disp.Clear(false);
    82ec:	e24b3014 	sub	r3, fp, #20
    82f0:	e3a01000 	mov	r1, #0
    82f4:	e1a00003 	mov	r0, r3
    82f8:	eb00028d 	bl	8d34 <_ZN13COLED_Display5ClearEb>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/oled_task/main.cpp:45 (discriminator 1)
		disp.Put_String(0, 0, msg);
    82fc:	e24b0014 	sub	r0, fp, #20
    8300:	e51b300c 	ldr	r3, [fp, #-12]
    8304:	e3a02000 	mov	r2, #0
    8308:	e3a01000 	mov	r1, #0
    830c:	eb000352 	bl	905c <_ZN13COLED_Display10Put_StringEttPKc>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/oled_task/main.cpp:46 (discriminator 1)
		disp.Flip();
    8310:	e24b3014 	sub	r3, fp, #20
    8314:	e1a00003 	mov	r0, r3
    8318:	eb000339 	bl	9004 <_ZN13COLED_Display4FlipEv>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/oled_task/main.cpp:48 (discriminator 1)

		sleep(0x4000, 0x800); // TODO: z tohohle bude casem cekani na podminkove promenne (na eventu) s timeoutem
    831c:	e3a01b02 	mov	r1, #2048	; 0x800
    8320:	e3a00901 	mov	r0, #16384	; 0x4000
    8324:	eb00009f 	bl	85a8 <_Z5sleepjj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/oled_task/main.cpp:49 (discriminator 1)
	}
    8328:	eaffffdf 	b	82ac <main+0x78>
    832c:	00009404 	andeq	r9, r0, r4, lsl #8
    8330:	00009410 	andeq	r9, r0, r0, lsl r4
    8334:	00009424 	andeq	r9, r0, r4, lsr #8
    8338:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd
    833c:	00009720 	andeq	r9, r0, r0, lsr #14

00008340 <_Z6getpidv>:
_Z6getpidv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8340:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8344:	e28db000 	add	fp, sp, #0
    8348:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    834c:	ef000000 	svc	0x00000000
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8350:	e1a03000 	mov	r3, r0
    8354:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:11

    return pid;
    8358:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:12
}
    835c:	e1a00003 	mov	r0, r3
    8360:	e28bd000 	add	sp, fp, #0
    8364:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8368:	e12fff1e 	bx	lr

0000836c <_Z9terminatei>:
_Z9terminatei():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    836c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8370:	e28db000 	add	fp, sp, #0
    8374:	e24dd00c 	sub	sp, sp, #12
    8378:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    837c:	e51b3008 	ldr	r3, [fp, #-8]
    8380:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    8384:	ef000001 	svc	0x00000001
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:18
}
    8388:	e320f000 	nop	{0}
    838c:	e28bd000 	add	sp, fp, #0
    8390:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8394:	e12fff1e 	bx	lr

00008398 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    8398:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    839c:	e28db000 	add	fp, sp, #0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    83a0:	ef000002 	svc	0x00000002
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:23
}
    83a4:	e320f000 	nop	{0}
    83a8:	e28bd000 	add	sp, fp, #0
    83ac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83b0:	e12fff1e 	bx	lr

000083b4 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    83b4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83b8:	e28db000 	add	fp, sp, #0
    83bc:	e24dd014 	sub	sp, sp, #20
    83c0:	e50b0010 	str	r0, [fp, #-16]
    83c4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    83c8:	e51b3010 	ldr	r3, [fp, #-16]
    83cc:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    83d0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83d4:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    83d8:	ef000040 	svc	0x00000040
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    83dc:	e1a03000 	mov	r3, r0
    83e0:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:34

    return file;
    83e4:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:35
}
    83e8:	e1a00003 	mov	r0, r3
    83ec:	e28bd000 	add	sp, fp, #0
    83f0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83f4:	e12fff1e 	bx	lr

000083f8 <_Z4readjPcj>:
_Z4readjPcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    83f8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83fc:	e28db000 	add	fp, sp, #0
    8400:	e24dd01c 	sub	sp, sp, #28
    8404:	e50b0010 	str	r0, [fp, #-16]
    8408:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    840c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8410:	e51b3010 	ldr	r3, [fp, #-16]
    8414:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    8418:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    841c:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    8420:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8424:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    8428:	ef000041 	svc	0x00000041
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    842c:	e1a03000 	mov	r3, r0
    8430:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    8434:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:48
}
    8438:	e1a00003 	mov	r0, r3
    843c:	e28bd000 	add	sp, fp, #0
    8440:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8444:	e12fff1e 	bx	lr

00008448 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    8448:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    844c:	e28db000 	add	fp, sp, #0
    8450:	e24dd01c 	sub	sp, sp, #28
    8454:	e50b0010 	str	r0, [fp, #-16]
    8458:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    845c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8460:	e51b3010 	ldr	r3, [fp, #-16]
    8464:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    8468:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    846c:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    8470:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8474:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    8478:	ef000042 	svc	0x00000042
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    847c:	e1a03000 	mov	r3, r0
    8480:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    8484:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:61
}
    8488:	e1a00003 	mov	r0, r3
    848c:	e28bd000 	add	sp, fp, #0
    8490:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8494:	e12fff1e 	bx	lr

00008498 <_Z5closej>:
_Z5closej():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    8498:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    849c:	e28db000 	add	fp, sp, #0
    84a0:	e24dd00c 	sub	sp, sp, #12
    84a4:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    84a8:	e51b3008 	ldr	r3, [fp, #-8]
    84ac:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    84b0:	ef000043 	svc	0x00000043
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:67
}
    84b4:	e320f000 	nop	{0}
    84b8:	e28bd000 	add	sp, fp, #0
    84bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84c0:	e12fff1e 	bx	lr

000084c4 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    84c4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84c8:	e28db000 	add	fp, sp, #0
    84cc:	e24dd01c 	sub	sp, sp, #28
    84d0:	e50b0010 	str	r0, [fp, #-16]
    84d4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84d8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    84dc:	e51b3010 	ldr	r3, [fp, #-16]
    84e0:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    84e4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84e8:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    84ec:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84f0:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    84f4:	ef000044 	svc	0x00000044
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    84f8:	e1a03000 	mov	r3, r0
    84fc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    8500:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:80
}
    8504:	e1a00003 	mov	r0, r3
    8508:	e28bd000 	add	sp, fp, #0
    850c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8510:	e12fff1e 	bx	lr

00008514 <_Z6notifyjj>:
_Z6notifyjj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    8514:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8518:	e28db000 	add	fp, sp, #0
    851c:	e24dd014 	sub	sp, sp, #20
    8520:	e50b0010 	str	r0, [fp, #-16]
    8524:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    8528:	e51b3010 	ldr	r3, [fp, #-16]
    852c:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    8530:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8534:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    8538:	ef000045 	svc	0x00000045
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    853c:	e1a03000 	mov	r3, r0
    8540:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    8544:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:92
}
    8548:	e1a00003 	mov	r0, r3
    854c:	e28bd000 	add	sp, fp, #0
    8550:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8554:	e12fff1e 	bx	lr

00008558 <_Z4waitjjj>:
_Z4waitjjj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    8558:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    855c:	e28db000 	add	fp, sp, #0
    8560:	e24dd01c 	sub	sp, sp, #28
    8564:	e50b0010 	str	r0, [fp, #-16]
    8568:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    856c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8570:	e51b3010 	ldr	r3, [fp, #-16]
    8574:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    8578:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    857c:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    8580:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8584:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    8588:	ef000046 	svc	0x00000046
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    858c:	e1a03000 	mov	r3, r0
    8590:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    8594:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:105
}
    8598:	e1a00003 	mov	r0, r3
    859c:	e28bd000 	add	sp, fp, #0
    85a0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85a4:	e12fff1e 	bx	lr

000085a8 <_Z5sleepjj>:
_Z5sleepjj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    85a8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85ac:	e28db000 	add	fp, sp, #0
    85b0:	e24dd014 	sub	sp, sp, #20
    85b4:	e50b0010 	str	r0, [fp, #-16]
    85b8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    85bc:	e51b3010 	ldr	r3, [fp, #-16]
    85c0:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    85c4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85c8:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    85cc:	ef000003 	svc	0x00000003
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    85d0:	e1a03000 	mov	r3, r0
    85d4:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    85d8:	e51b3008 	ldr	r3, [fp, #-8]
    85dc:	e3530000 	cmp	r3, #0
    85e0:	13a03001 	movne	r3, #1
    85e4:	03a03000 	moveq	r3, #0
    85e8:	e6ef3073 	uxtb	r3, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:117
}
    85ec:	e1a00003 	mov	r0, r3
    85f0:	e28bd000 	add	sp, fp, #0
    85f4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85f8:	e12fff1e 	bx	lr

000085fc <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    85fc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8600:	e28db000 	add	fp, sp, #0
    8604:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    8608:	e3a03000 	mov	r3, #0
    860c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8610:	e3a03000 	mov	r3, #0
    8614:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    8618:	e24b300c 	sub	r3, fp, #12
    861c:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    8620:	ef000004 	svc	0x00000004
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:128

    return retval;
    8624:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:129
}
    8628:	e1a00003 	mov	r0, r3
    862c:	e28bd000 	add	sp, fp, #0
    8630:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8634:	e12fff1e 	bx	lr

00008638 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    8638:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    863c:	e28db000 	add	fp, sp, #0
    8640:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    8644:	e3a03001 	mov	r3, #1
    8648:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    864c:	e3a03001 	mov	r3, #1
    8650:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    8654:	e24b300c 	sub	r3, fp, #12
    8658:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    865c:	ef000004 	svc	0x00000004
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:140

    return retval;
    8660:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:141
}
    8664:	e1a00003 	mov	r0, r3
    8668:	e28bd000 	add	sp, fp, #0
    866c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8670:	e12fff1e 	bx	lr

00008674 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    8674:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8678:	e28db000 	add	fp, sp, #0
    867c:	e24dd014 	sub	sp, sp, #20
    8680:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    8684:	e3a03000 	mov	r3, #0
    8688:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    868c:	e3a03000 	mov	r3, #0
    8690:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    8694:	e24b3010 	sub	r3, fp, #16
    8698:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    869c:	ef000005 	svc	0x00000005
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:150
}
    86a0:	e320f000 	nop	{0}
    86a4:	e28bd000 	add	sp, fp, #0
    86a8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86ac:	e12fff1e 	bx	lr

000086b0 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    86b0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86b4:	e28db000 	add	fp, sp, #0
    86b8:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    86bc:	e3a03001 	mov	r3, #1
    86c0:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    86c4:	e3a03001 	mov	r3, #1
    86c8:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    86cc:	e24b300c 	sub	r3, fp, #12
    86d0:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    86d4:	ef000005 	svc	0x00000005
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    86d8:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:162
}
    86dc:	e1a00003 	mov	r0, r3
    86e0:	e28bd000 	add	sp, fp, #0
    86e4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86e8:	e12fff1e 	bx	lr

000086ec <_Z4pipePKcj>:
_Z4pipePKcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    86ec:	e92d4800 	push	{fp, lr}
    86f0:	e28db004 	add	fp, sp, #4
    86f4:	e24dd050 	sub	sp, sp, #80	; 0x50
    86f8:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    86fc:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    8700:	e24b3048 	sub	r3, fp, #72	; 0x48
    8704:	e3a0200a 	mov	r2, #10
    8708:	e59f108c 	ldr	r1, [pc, #140]	; 879c <_Z4pipePKcj+0xb0>
    870c:	e1a00003 	mov	r0, r3
    8710:	eb0000a6 	bl	89b0 <_Z7strncpyPcPKci>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    8714:	e24b3048 	sub	r3, fp, #72	; 0x48
    8718:	e283300a 	add	r3, r3, #10
    871c:	e3a02035 	mov	r2, #53	; 0x35
    8720:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    8724:	e1a00003 	mov	r0, r3
    8728:	eb0000a0 	bl	89b0 <_Z7strncpyPcPKci>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    872c:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    8730:	eb0000f9 	bl	8b1c <_Z6strlenPKc>
    8734:	e1a03000 	mov	r3, r0
    8738:	e283300a 	add	r3, r3, #10
    873c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    8740:	e51b3008 	ldr	r3, [fp, #-8]
    8744:	e2832001 	add	r2, r3, #1
    8748:	e50b2008 	str	r2, [fp, #-8]
    874c:	e24b2004 	sub	r2, fp, #4
    8750:	e0823003 	add	r3, r2, r3
    8754:	e3a02023 	mov	r2, #35	; 0x23
    8758:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    875c:	e24b2048 	sub	r2, fp, #72	; 0x48
    8760:	e51b3008 	ldr	r3, [fp, #-8]
    8764:	e0823003 	add	r3, r2, r3
    8768:	e3a0200a 	mov	r2, #10
    876c:	e1a01003 	mov	r1, r3
    8770:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    8774:	eb000009 	bl	87a0 <_Z4itoajPcj>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    8778:	e24b3048 	sub	r3, fp, #72	; 0x48
    877c:	e3a01002 	mov	r1, #2
    8780:	e1a00003 	mov	r0, r3
    8784:	ebffff0a 	bl	83b4 <_Z4openPKc15NFile_Open_Mode>
    8788:	e1a03000 	mov	r3, r0
    878c:	e320f000 	nop	{0}
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:179
}
    8790:	e1a00003 	mov	r0, r3
    8794:	e24bd004 	sub	sp, fp, #4
    8798:	e8bd8800 	pop	{fp, pc}
    879c:	0000945c 	andeq	r9, r0, ip, asr r4

000087a0 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    87a0:	e92d4800 	push	{fp, lr}
    87a4:	e28db004 	add	fp, sp, #4
    87a8:	e24dd020 	sub	sp, sp, #32
    87ac:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    87b0:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    87b4:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:10
	int i = 0;
    87b8:	e3a03000 	mov	r3, #0
    87bc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:12

	while (input > 0)
    87c0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    87c4:	e3530000 	cmp	r3, #0
    87c8:	0a000014 	beq	8820 <_Z4itoajPcj+0x80>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    87cc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    87d0:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    87d4:	e1a00003 	mov	r0, r3
    87d8:	eb0002c6 	bl	92f8 <__aeabi_uidivmod>
    87dc:	e1a03001 	mov	r3, r1
    87e0:	e1a01003 	mov	r1, r3
    87e4:	e51b3008 	ldr	r3, [fp, #-8]
    87e8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87ec:	e0823003 	add	r3, r2, r3
    87f0:	e59f2118 	ldr	r2, [pc, #280]	; 8910 <_Z4itoajPcj+0x170>
    87f4:	e7d22001 	ldrb	r2, [r2, r1]
    87f8:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:15
		input /= base;
    87fc:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8800:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8804:	eb000240 	bl	910c <__udivsi3>
    8808:	e1a03000 	mov	r3, r0
    880c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:16
		i++;
    8810:	e51b3008 	ldr	r3, [fp, #-8]
    8814:	e2833001 	add	r3, r3, #1
    8818:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:12
	while (input > 0)
    881c:	eaffffe7 	b	87c0 <_Z4itoajPcj+0x20>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    8820:	e51b3008 	ldr	r3, [fp, #-8]
    8824:	e3530000 	cmp	r3, #0
    8828:	1a000007 	bne	884c <_Z4itoajPcj+0xac>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    882c:	e51b3008 	ldr	r3, [fp, #-8]
    8830:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8834:	e0823003 	add	r3, r2, r3
    8838:	e3a02030 	mov	r2, #48	; 0x30
    883c:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:22
        i++;
    8840:	e51b3008 	ldr	r3, [fp, #-8]
    8844:	e2833001 	add	r3, r3, #1
    8848:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    884c:	e51b3008 	ldr	r3, [fp, #-8]
    8850:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8854:	e0823003 	add	r3, r2, r3
    8858:	e3a02000 	mov	r2, #0
    885c:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:26
	i--;
    8860:	e51b3008 	ldr	r3, [fp, #-8]
    8864:	e2433001 	sub	r3, r3, #1
    8868:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    886c:	e3a03000 	mov	r3, #0
    8870:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:28 (discriminator 3)
    8874:	e51b3008 	ldr	r3, [fp, #-8]
    8878:	e1a02fa3 	lsr	r2, r3, #31
    887c:	e0823003 	add	r3, r2, r3
    8880:	e1a030c3 	asr	r3, r3, #1
    8884:	e1a02003 	mov	r2, r3
    8888:	e51b300c 	ldr	r3, [fp, #-12]
    888c:	e1530002 	cmp	r3, r2
    8890:	ca00001b 	bgt	8904 <_Z4itoajPcj+0x164>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    8894:	e51b2008 	ldr	r2, [fp, #-8]
    8898:	e51b300c 	ldr	r3, [fp, #-12]
    889c:	e0423003 	sub	r3, r2, r3
    88a0:	e1a02003 	mov	r2, r3
    88a4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    88a8:	e0833002 	add	r3, r3, r2
    88ac:	e5d33000 	ldrb	r3, [r3]
    88b0:	e54b300d 	strb	r3, [fp, #-13]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    88b4:	e51b300c 	ldr	r3, [fp, #-12]
    88b8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88bc:	e0822003 	add	r2, r2, r3
    88c0:	e51b1008 	ldr	r1, [fp, #-8]
    88c4:	e51b300c 	ldr	r3, [fp, #-12]
    88c8:	e0413003 	sub	r3, r1, r3
    88cc:	e1a01003 	mov	r1, r3
    88d0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    88d4:	e0833001 	add	r3, r3, r1
    88d8:	e5d22000 	ldrb	r2, [r2]
    88dc:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    88e0:	e51b300c 	ldr	r3, [fp, #-12]
    88e4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88e8:	e0823003 	add	r3, r2, r3
    88ec:	e55b200d 	ldrb	r2, [fp, #-13]
    88f0:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    88f4:	e51b300c 	ldr	r3, [fp, #-12]
    88f8:	e2833001 	add	r3, r3, #1
    88fc:	e50b300c 	str	r3, [fp, #-12]
    8900:	eaffffdb 	b	8874 <_Z4itoajPcj+0xd4>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:34
	}
}
    8904:	e320f000 	nop	{0}
    8908:	e24bd004 	sub	sp, fp, #4
    890c:	e8bd8800 	pop	{fp, pc}
    8910:	00009468 	andeq	r9, r0, r8, ror #8

00008914 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    8914:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8918:	e28db000 	add	fp, sp, #0
    891c:	e24dd014 	sub	sp, sp, #20
    8920:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:38
	int output = 0;
    8924:	e3a03000 	mov	r3, #0
    8928:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    892c:	e51b3010 	ldr	r3, [fp, #-16]
    8930:	e5d33000 	ldrb	r3, [r3]
    8934:	e3530000 	cmp	r3, #0
    8938:	0a000017 	beq	899c <_Z4atoiPKc+0x88>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    893c:	e51b2008 	ldr	r2, [fp, #-8]
    8940:	e1a03002 	mov	r3, r2
    8944:	e1a03103 	lsl	r3, r3, #2
    8948:	e0833002 	add	r3, r3, r2
    894c:	e1a03083 	lsl	r3, r3, #1
    8950:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    8954:	e51b3010 	ldr	r3, [fp, #-16]
    8958:	e5d33000 	ldrb	r3, [r3]
    895c:	e3530039 	cmp	r3, #57	; 0x39
    8960:	8a00000d 	bhi	899c <_Z4atoiPKc+0x88>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:43 (discriminator 1)
    8964:	e51b3010 	ldr	r3, [fp, #-16]
    8968:	e5d33000 	ldrb	r3, [r3]
    896c:	e353002f 	cmp	r3, #47	; 0x2f
    8970:	9a000009 	bls	899c <_Z4atoiPKc+0x88>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    8974:	e51b3010 	ldr	r3, [fp, #-16]
    8978:	e5d33000 	ldrb	r3, [r3]
    897c:	e2433030 	sub	r3, r3, #48	; 0x30
    8980:	e51b2008 	ldr	r2, [fp, #-8]
    8984:	e0823003 	add	r3, r2, r3
    8988:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:48

		input++;
    898c:	e51b3010 	ldr	r3, [fp, #-16]
    8990:	e2833001 	add	r3, r3, #1
    8994:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    8998:	eaffffe3 	b	892c <_Z4atoiPKc+0x18>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:51
	}

	return output;
    899c:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:52
}
    89a0:	e1a00003 	mov	r0, r3
    89a4:	e28bd000 	add	sp, fp, #0
    89a8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    89ac:	e12fff1e 	bx	lr

000089b0 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    89b0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89b4:	e28db000 	add	fp, sp, #0
    89b8:	e24dd01c 	sub	sp, sp, #28
    89bc:	e50b0010 	str	r0, [fp, #-16]
    89c0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    89c4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    89c8:	e3a03000 	mov	r3, #0
    89cc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58 (discriminator 4)
    89d0:	e51b2008 	ldr	r2, [fp, #-8]
    89d4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    89d8:	e1520003 	cmp	r2, r3
    89dc:	aa000011 	bge	8a28 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58 (discriminator 2)
    89e0:	e51b3008 	ldr	r3, [fp, #-8]
    89e4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    89e8:	e0823003 	add	r3, r2, r3
    89ec:	e5d33000 	ldrb	r3, [r3]
    89f0:	e3530000 	cmp	r3, #0
    89f4:	0a00000b 	beq	8a28 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    89f8:	e51b3008 	ldr	r3, [fp, #-8]
    89fc:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8a00:	e0822003 	add	r2, r2, r3
    8a04:	e51b3008 	ldr	r3, [fp, #-8]
    8a08:	e51b1010 	ldr	r1, [fp, #-16]
    8a0c:	e0813003 	add	r3, r1, r3
    8a10:	e5d22000 	ldrb	r2, [r2]
    8a14:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8a18:	e51b3008 	ldr	r3, [fp, #-8]
    8a1c:	e2833001 	add	r3, r3, #1
    8a20:	e50b3008 	str	r3, [fp, #-8]
    8a24:	eaffffe9 	b	89d0 <_Z7strncpyPcPKci+0x20>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    8a28:	e51b2008 	ldr	r2, [fp, #-8]
    8a2c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a30:	e1520003 	cmp	r2, r3
    8a34:	aa000008 	bge	8a5c <_Z7strncpyPcPKci+0xac>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8a38:	e51b3008 	ldr	r3, [fp, #-8]
    8a3c:	e51b2010 	ldr	r2, [fp, #-16]
    8a40:	e0823003 	add	r3, r2, r3
    8a44:	e3a02000 	mov	r2, #0
    8a48:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8a4c:	e51b3008 	ldr	r3, [fp, #-8]
    8a50:	e2833001 	add	r3, r3, #1
    8a54:	e50b3008 	str	r3, [fp, #-8]
    8a58:	eafffff2 	b	8a28 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:63

   return dest;
    8a5c:	e51b3010 	ldr	r3, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:64
}
    8a60:	e1a00003 	mov	r0, r3
    8a64:	e28bd000 	add	sp, fp, #0
    8a68:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a6c:	e12fff1e 	bx	lr

00008a70 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    8a70:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a74:	e28db000 	add	fp, sp, #0
    8a78:	e24dd01c 	sub	sp, sp, #28
    8a7c:	e50b0010 	str	r0, [fp, #-16]
    8a80:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8a84:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    8a88:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a8c:	e2432001 	sub	r2, r3, #1
    8a90:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8a94:	e3530000 	cmp	r3, #0
    8a98:	c3a03001 	movgt	r3, #1
    8a9c:	d3a03000 	movle	r3, #0
    8aa0:	e6ef3073 	uxtb	r3, r3
    8aa4:	e3530000 	cmp	r3, #0
    8aa8:	0a000016 	beq	8b08 <_Z7strncmpPKcS0_i+0x98>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    8aac:	e51b3010 	ldr	r3, [fp, #-16]
    8ab0:	e2832001 	add	r2, r3, #1
    8ab4:	e50b2010 	str	r2, [fp, #-16]
    8ab8:	e5d33000 	ldrb	r3, [r3]
    8abc:	e54b3005 	strb	r3, [fp, #-5]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    8ac0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8ac4:	e2832001 	add	r2, r3, #1
    8ac8:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8acc:	e5d33000 	ldrb	r3, [r3]
    8ad0:	e54b3006 	strb	r3, [fp, #-6]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    8ad4:	e55b2005 	ldrb	r2, [fp, #-5]
    8ad8:	e55b3006 	ldrb	r3, [fp, #-6]
    8adc:	e1520003 	cmp	r2, r3
    8ae0:	0a000003 	beq	8af4 <_Z7strncmpPKcS0_i+0x84>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    8ae4:	e55b2005 	ldrb	r2, [fp, #-5]
    8ae8:	e55b3006 	ldrb	r3, [fp, #-6]
    8aec:	e0423003 	sub	r3, r2, r3
    8af0:	ea000005 	b	8b0c <_Z7strncmpPKcS0_i+0x9c>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    8af4:	e55b3005 	ldrb	r3, [fp, #-5]
    8af8:	e3530000 	cmp	r3, #0
    8afc:	1affffe1 	bne	8a88 <_Z7strncmpPKcS0_i+0x18>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:76
        	return 0;
    8b00:	e3a03000 	mov	r3, #0
    8b04:	ea000000 	b	8b0c <_Z7strncmpPKcS0_i+0x9c>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8b08:	e3a03000 	mov	r3, #0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:80
}
    8b0c:	e1a00003 	mov	r0, r3
    8b10:	e28bd000 	add	sp, fp, #0
    8b14:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b18:	e12fff1e 	bx	lr

00008b1c <_Z6strlenPKc>:
_Z6strlenPKc():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8b1c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b20:	e28db000 	add	fp, sp, #0
    8b24:	e24dd014 	sub	sp, sp, #20
    8b28:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:84
	int i = 0;
    8b2c:	e3a03000 	mov	r3, #0
    8b30:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8b34:	e51b3008 	ldr	r3, [fp, #-8]
    8b38:	e51b2010 	ldr	r2, [fp, #-16]
    8b3c:	e0823003 	add	r3, r2, r3
    8b40:	e5d33000 	ldrb	r3, [r3]
    8b44:	e3530000 	cmp	r3, #0
    8b48:	0a000003 	beq	8b5c <_Z6strlenPKc+0x40>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:87
		i++;
    8b4c:	e51b3008 	ldr	r3, [fp, #-8]
    8b50:	e2833001 	add	r3, r3, #1
    8b54:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8b58:	eafffff5 	b	8b34 <_Z6strlenPKc+0x18>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:89

	return i;
    8b5c:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:90
}
    8b60:	e1a00003 	mov	r0, r3
    8b64:	e28bd000 	add	sp, fp, #0
    8b68:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b6c:	e12fff1e 	bx	lr

00008b70 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8b70:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b74:	e28db000 	add	fp, sp, #0
    8b78:	e24dd014 	sub	sp, sp, #20
    8b7c:	e50b0010 	str	r0, [fp, #-16]
    8b80:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8b84:	e51b3010 	ldr	r3, [fp, #-16]
    8b88:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8b8c:	e3a03000 	mov	r3, #0
    8b90:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8b94:	e51b2008 	ldr	r2, [fp, #-8]
    8b98:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8b9c:	e1520003 	cmp	r2, r3
    8ba0:	aa000008 	bge	8bc8 <_Z5bzeroPvi+0x58>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8ba4:	e51b3008 	ldr	r3, [fp, #-8]
    8ba8:	e51b200c 	ldr	r2, [fp, #-12]
    8bac:	e0823003 	add	r3, r2, r3
    8bb0:	e3a02000 	mov	r2, #0
    8bb4:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8bb8:	e51b3008 	ldr	r3, [fp, #-8]
    8bbc:	e2833001 	add	r3, r3, #1
    8bc0:	e50b3008 	str	r3, [fp, #-8]
    8bc4:	eafffff2 	b	8b94 <_Z5bzeroPvi+0x24>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:98
}
    8bc8:	e320f000 	nop	{0}
    8bcc:	e28bd000 	add	sp, fp, #0
    8bd0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8bd4:	e12fff1e 	bx	lr

00008bd8 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8bd8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8bdc:	e28db000 	add	fp, sp, #0
    8be0:	e24dd024 	sub	sp, sp, #36	; 0x24
    8be4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8be8:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8bec:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8bf0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8bf4:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8bf8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8bfc:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8c00:	e3a03000 	mov	r3, #0
    8c04:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8c08:	e51b2008 	ldr	r2, [fp, #-8]
    8c0c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c10:	e1520003 	cmp	r2, r3
    8c14:	aa00000b 	bge	8c48 <_Z6memcpyPKvPvi+0x70>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8c18:	e51b3008 	ldr	r3, [fp, #-8]
    8c1c:	e51b200c 	ldr	r2, [fp, #-12]
    8c20:	e0822003 	add	r2, r2, r3
    8c24:	e51b3008 	ldr	r3, [fp, #-8]
    8c28:	e51b1010 	ldr	r1, [fp, #-16]
    8c2c:	e0813003 	add	r3, r1, r3
    8c30:	e5d22000 	ldrb	r2, [r2]
    8c34:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8c38:	e51b3008 	ldr	r3, [fp, #-8]
    8c3c:	e2833001 	add	r3, r3, #1
    8c40:	e50b3008 	str	r3, [fp, #-8]
    8c44:	eaffffef 	b	8c08 <_Z6memcpyPKvPvi+0x30>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:107
}
    8c48:	e320f000 	nop	{0}
    8c4c:	e28bd000 	add	sp, fp, #0
    8c50:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c54:	e12fff1e 	bx	lr

00008c58 <_ZN13COLED_DisplayC1EPKc>:
_ZN13COLED_DisplayC2EPKc():
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:10
#include <drivers/bridges/display_protocol.h>

// tento soubor includujeme jen odtud
#include "oled_font.h"

COLED_Display::COLED_Display(const char* path)
    8c58:	e92d4800 	push	{fp, lr}
    8c5c:	e28db004 	add	fp, sp, #4
    8c60:	e24dd008 	sub	sp, sp, #8
    8c64:	e50b0008 	str	r0, [fp, #-8]
    8c68:	e50b100c 	str	r1, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:11
    : mHandle{ open(path, NFile_Open_Mode::Write_Only) }, mOpened(false)
    8c6c:	e3a01001 	mov	r1, #1
    8c70:	e51b000c 	ldr	r0, [fp, #-12]
    8c74:	ebfffdce 	bl	83b4 <_Z4openPKc15NFile_Open_Mode>
    8c78:	e1a02000 	mov	r2, r0
    8c7c:	e51b3008 	ldr	r3, [fp, #-8]
    8c80:	e5832000 	str	r2, [r3]
    8c84:	e51b3008 	ldr	r3, [fp, #-8]
    8c88:	e3a02000 	mov	r2, #0
    8c8c:	e5c32004 	strb	r2, [r3, #4]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:14
{
    // nastavime priznak dle toho, co vrati open
    mOpened = (mHandle != static_cast<uint32_t>(-1));
    8c90:	e51b3008 	ldr	r3, [fp, #-8]
    8c94:	e5933000 	ldr	r3, [r3]
    8c98:	e3730001 	cmn	r3, #1
    8c9c:	13a03001 	movne	r3, #1
    8ca0:	03a03000 	moveq	r3, #0
    8ca4:	e6ef2073 	uxtb	r2, r3
    8ca8:	e51b3008 	ldr	r3, [fp, #-8]
    8cac:	e5c32004 	strb	r2, [r3, #4]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:15
}
    8cb0:	e51b3008 	ldr	r3, [fp, #-8]
    8cb4:	e1a00003 	mov	r0, r3
    8cb8:	e24bd004 	sub	sp, fp, #4
    8cbc:	e8bd8800 	pop	{fp, pc}

00008cc0 <_ZN13COLED_DisplayD1Ev>:
_ZN13COLED_DisplayD2Ev():
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:17

COLED_Display::~COLED_Display()
    8cc0:	e92d4800 	push	{fp, lr}
    8cc4:	e28db004 	add	fp, sp, #4
    8cc8:	e24dd008 	sub	sp, sp, #8
    8ccc:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:20
{
    // pokud byl displej otevreny, zavreme
    if (mOpened)
    8cd0:	e51b3008 	ldr	r3, [fp, #-8]
    8cd4:	e5d33004 	ldrb	r3, [r3, #4]
    8cd8:	e3530000 	cmp	r3, #0
    8cdc:	0a000006 	beq	8cfc <_ZN13COLED_DisplayD1Ev+0x3c>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:22
    {
        mOpened = false;
    8ce0:	e51b3008 	ldr	r3, [fp, #-8]
    8ce4:	e3a02000 	mov	r2, #0
    8ce8:	e5c32004 	strb	r2, [r3, #4]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:23
        close(mHandle);
    8cec:	e51b3008 	ldr	r3, [fp, #-8]
    8cf0:	e5933000 	ldr	r3, [r3]
    8cf4:	e1a00003 	mov	r0, r3
    8cf8:	ebfffde6 	bl	8498 <_Z5closej>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:25
    }
}
    8cfc:	e51b3008 	ldr	r3, [fp, #-8]
    8d00:	e1a00003 	mov	r0, r3
    8d04:	e24bd004 	sub	sp, fp, #4
    8d08:	e8bd8800 	pop	{fp, pc}

00008d0c <_ZNK13COLED_Display9Is_OpenedEv>:
_ZNK13COLED_Display9Is_OpenedEv():
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:28

bool COLED_Display::Is_Opened() const
{
    8d0c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8d10:	e28db000 	add	fp, sp, #0
    8d14:	e24dd00c 	sub	sp, sp, #12
    8d18:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:29
    return mOpened;
    8d1c:	e51b3008 	ldr	r3, [fp, #-8]
    8d20:	e5d33004 	ldrb	r3, [r3, #4]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:30
}
    8d24:	e1a00003 	mov	r0, r3
    8d28:	e28bd000 	add	sp, fp, #0
    8d2c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d30:	e12fff1e 	bx	lr

00008d34 <_ZN13COLED_Display5ClearEb>:
_ZN13COLED_Display5ClearEb():
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:33

void COLED_Display::Clear(bool clearSet)
{
    8d34:	e92d4800 	push	{fp, lr}
    8d38:	e28db004 	add	fp, sp, #4
    8d3c:	e24dd010 	sub	sp, sp, #16
    8d40:	e50b0010 	str	r0, [fp, #-16]
    8d44:	e1a03001 	mov	r3, r1
    8d48:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:34
    if (!mOpened)
    8d4c:	e51b3010 	ldr	r3, [fp, #-16]
    8d50:	e5d33004 	ldrb	r3, [r3, #4]
    8d54:	e2233001 	eor	r3, r3, #1
    8d58:	e6ef3073 	uxtb	r3, r3
    8d5c:	e3530000 	cmp	r3, #0
    8d60:	1a00000f 	bne	8da4 <_ZN13COLED_Display5ClearEb+0x70>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:38
        return;

    TDisplay_Clear_Packet pkt;
	pkt.header.cmd = NDisplay_Command::Clear;
    8d64:	e3a03002 	mov	r3, #2
    8d68:	e54b3008 	strb	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:39
	pkt.clearSet = clearSet ? 1 : 0;
    8d6c:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    8d70:	e3530000 	cmp	r3, #0
    8d74:	0a000001 	beq	8d80 <_ZN13COLED_Display5ClearEb+0x4c>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:39 (discriminator 1)
    8d78:	e3a03001 	mov	r3, #1
    8d7c:	ea000000 	b	8d84 <_ZN13COLED_Display5ClearEb+0x50>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:39 (discriminator 2)
    8d80:	e3a03000 	mov	r3, #0
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:39 (discriminator 4)
    8d84:	e54b3007 	strb	r3, [fp, #-7]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:40 (discriminator 4)
	write(mHandle, reinterpret_cast<char*>(&pkt), sizeof(pkt));
    8d88:	e51b3010 	ldr	r3, [fp, #-16]
    8d8c:	e5933000 	ldr	r3, [r3]
    8d90:	e24b1008 	sub	r1, fp, #8
    8d94:	e3a02002 	mov	r2, #2
    8d98:	e1a00003 	mov	r0, r3
    8d9c:	ebfffda9 	bl	8448 <_Z5writejPKcj>
    8da0:	ea000000 	b	8da8 <_ZN13COLED_Display5ClearEb+0x74>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:35
        return;
    8da4:	e320f000 	nop	{0}
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:41
}
    8da8:	e24bd004 	sub	sp, fp, #4
    8dac:	e8bd8800 	pop	{fp, pc}

00008db0 <_ZN13COLED_Display9Set_PixelEttb>:
_ZN13COLED_Display9Set_PixelEttb():
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:44

void COLED_Display::Set_Pixel(uint16_t x, uint16_t y, bool set)
{
    8db0:	e92d4800 	push	{fp, lr}
    8db4:	e28db004 	add	fp, sp, #4
    8db8:	e24dd018 	sub	sp, sp, #24
    8dbc:	e50b0010 	str	r0, [fp, #-16]
    8dc0:	e1a00001 	mov	r0, r1
    8dc4:	e1a01002 	mov	r1, r2
    8dc8:	e1a02003 	mov	r2, r3
    8dcc:	e1a03000 	mov	r3, r0
    8dd0:	e14b31b2 	strh	r3, [fp, #-18]	; 0xffffffee
    8dd4:	e1a03001 	mov	r3, r1
    8dd8:	e14b31b4 	strh	r3, [fp, #-20]	; 0xffffffec
    8ddc:	e1a03002 	mov	r3, r2
    8de0:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:45
    if (!mOpened)
    8de4:	e51b3010 	ldr	r3, [fp, #-16]
    8de8:	e5d33004 	ldrb	r3, [r3, #4]
    8dec:	e2233001 	eor	r3, r3, #1
    8df0:	e6ef3073 	uxtb	r3, r3
    8df4:	e3530000 	cmp	r3, #0
    8df8:	1a000024 	bne	8e90 <_ZN13COLED_Display9Set_PixelEttb+0xe0>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:50
        return;

    // nehospodarny zpusob, jak nastavit pixely, ale pro ted staci
    TDisplay_Draw_Pixel_Array_Packet pkt;
    pkt.header.cmd = NDisplay_Command::Draw_Pixel_Array;
    8dfc:	e3a03003 	mov	r3, #3
    8e00:	e54b300c 	strb	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:51
    pkt.count = 1;
    8e04:	e3a03000 	mov	r3, #0
    8e08:	e3833001 	orr	r3, r3, #1
    8e0c:	e54b300b 	strb	r3, [fp, #-11]
    8e10:	e3a03000 	mov	r3, #0
    8e14:	e54b300a 	strb	r3, [fp, #-10]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:52
    pkt.first.x = x;
    8e18:	e55b3012 	ldrb	r3, [fp, #-18]	; 0xffffffee
    8e1c:	e3a02000 	mov	r2, #0
    8e20:	e1823003 	orr	r3, r2, r3
    8e24:	e54b3009 	strb	r3, [fp, #-9]
    8e28:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    8e2c:	e3a02000 	mov	r2, #0
    8e30:	e1823003 	orr	r3, r2, r3
    8e34:	e54b3008 	strb	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:53
    pkt.first.y = y;
    8e38:	e55b3014 	ldrb	r3, [fp, #-20]	; 0xffffffec
    8e3c:	e3a02000 	mov	r2, #0
    8e40:	e1823003 	orr	r3, r2, r3
    8e44:	e54b3007 	strb	r3, [fp, #-7]
    8e48:	e55b3013 	ldrb	r3, [fp, #-19]	; 0xffffffed
    8e4c:	e3a02000 	mov	r2, #0
    8e50:	e1823003 	orr	r3, r2, r3
    8e54:	e54b3006 	strb	r3, [fp, #-6]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:54
    pkt.first.set = set ? 1 : 0;
    8e58:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8e5c:	e3530000 	cmp	r3, #0
    8e60:	0a000001 	beq	8e6c <_ZN13COLED_Display9Set_PixelEttb+0xbc>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:54 (discriminator 1)
    8e64:	e3a03001 	mov	r3, #1
    8e68:	ea000000 	b	8e70 <_ZN13COLED_Display9Set_PixelEttb+0xc0>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:54 (discriminator 2)
    8e6c:	e3a03000 	mov	r3, #0
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:54 (discriminator 4)
    8e70:	e54b3005 	strb	r3, [fp, #-5]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:55 (discriminator 4)
    write(mHandle, reinterpret_cast<char*>(&pkt), sizeof(pkt));
    8e74:	e51b3010 	ldr	r3, [fp, #-16]
    8e78:	e5933000 	ldr	r3, [r3]
    8e7c:	e24b100c 	sub	r1, fp, #12
    8e80:	e3a02008 	mov	r2, #8
    8e84:	e1a00003 	mov	r0, r3
    8e88:	ebfffd6e 	bl	8448 <_Z5writejPKcj>
    8e8c:	ea000000 	b	8e94 <_ZN13COLED_Display9Set_PixelEttb+0xe4>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:46
        return;
    8e90:	e320f000 	nop	{0}
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:56
}
    8e94:	e24bd004 	sub	sp, fp, #4
    8e98:	e8bd8800 	pop	{fp, pc}

00008e9c <_ZN13COLED_Display8Put_CharEttc>:
_ZN13COLED_Display8Put_CharEttc():
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:59

void COLED_Display::Put_Char(uint16_t x, uint16_t y, char c)
{
    8e9c:	e92d4800 	push	{fp, lr}
    8ea0:	e28db004 	add	fp, sp, #4
    8ea4:	e24dd028 	sub	sp, sp, #40	; 0x28
    8ea8:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    8eac:	e1a00001 	mov	r0, r1
    8eb0:	e1a01002 	mov	r1, r2
    8eb4:	e1a02003 	mov	r2, r3
    8eb8:	e1a03000 	mov	r3, r0
    8ebc:	e14b32b2 	strh	r3, [fp, #-34]	; 0xffffffde
    8ec0:	e1a03001 	mov	r3, r1
    8ec4:	e14b32b4 	strh	r3, [fp, #-36]	; 0xffffffdc
    8ec8:	e1a03002 	mov	r3, r2
    8ecc:	e54b3025 	strb	r3, [fp, #-37]	; 0xffffffdb
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:60
    if (!mOpened)
    8ed0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8ed4:	e5d33004 	ldrb	r3, [r3, #4]
    8ed8:	e2233001 	eor	r3, r3, #1
    8edc:	e6ef3073 	uxtb	r3, r3
    8ee0:	e3530000 	cmp	r3, #0
    8ee4:	1a000040 	bne	8fec <_ZN13COLED_Display8Put_CharEttc+0x150>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:64
        return;

    // umime jen nektere znaky
    if (c < OLED_Font::Char_Begin || c >= OLED_Font::Char_End)
    8ee8:	e55b3025 	ldrb	r3, [fp, #-37]	; 0xffffffdb
    8eec:	e353001f 	cmp	r3, #31
    8ef0:	9a00003f 	bls	8ff4 <_ZN13COLED_Display8Put_CharEttc+0x158>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:64 (discriminator 1)
    8ef4:	e15b32d5 	ldrsb	r3, [fp, #-37]	; 0xffffffdb
    8ef8:	e3530000 	cmp	r3, #0
    8efc:	ba00003c 	blt	8ff4 <_ZN13COLED_Display8Put_CharEttc+0x158>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:69
        return;

    char buf[sizeof(TDisplay_Pixels_To_Rect) + OLED_Font::Char_Width];

    TDisplay_Pixels_To_Rect* ptr = reinterpret_cast<TDisplay_Pixels_To_Rect*>(buf);
    8f00:	e24b301c 	sub	r3, fp, #28
    8f04:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:70
    ptr->header.cmd = NDisplay_Command::Draw_Pixel_Array_To_Rect;
    8f08:	e51b3008 	ldr	r3, [fp, #-8]
    8f0c:	e3a02004 	mov	r2, #4
    8f10:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:71
    ptr->w = OLED_Font::Char_Width;
    8f14:	e51b3008 	ldr	r3, [fp, #-8]
    8f18:	e3a02000 	mov	r2, #0
    8f1c:	e3822006 	orr	r2, r2, #6
    8f20:	e5c32005 	strb	r2, [r3, #5]
    8f24:	e3a02000 	mov	r2, #0
    8f28:	e5c32006 	strb	r2, [r3, #6]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:72
    ptr->h = OLED_Font::Char_Height;
    8f2c:	e51b3008 	ldr	r3, [fp, #-8]
    8f30:	e3a02000 	mov	r2, #0
    8f34:	e3822008 	orr	r2, r2, #8
    8f38:	e5c32007 	strb	r2, [r3, #7]
    8f3c:	e3a02000 	mov	r2, #0
    8f40:	e5c32008 	strb	r2, [r3, #8]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:73
    ptr->x1 = x;
    8f44:	e51b3008 	ldr	r3, [fp, #-8]
    8f48:	e55b2022 	ldrb	r2, [fp, #-34]	; 0xffffffde
    8f4c:	e3a01000 	mov	r1, #0
    8f50:	e1812002 	orr	r2, r1, r2
    8f54:	e5c32001 	strb	r2, [r3, #1]
    8f58:	e55b2021 	ldrb	r2, [fp, #-33]	; 0xffffffdf
    8f5c:	e3a01000 	mov	r1, #0
    8f60:	e1812002 	orr	r2, r1, r2
    8f64:	e5c32002 	strb	r2, [r3, #2]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:74
    ptr->y1 = y;
    8f68:	e51b3008 	ldr	r3, [fp, #-8]
    8f6c:	e55b2024 	ldrb	r2, [fp, #-36]	; 0xffffffdc
    8f70:	e3a01000 	mov	r1, #0
    8f74:	e1812002 	orr	r2, r1, r2
    8f78:	e5c32003 	strb	r2, [r3, #3]
    8f7c:	e55b2023 	ldrb	r2, [fp, #-35]	; 0xffffffdd
    8f80:	e3a01000 	mov	r1, #0
    8f84:	e1812002 	orr	r2, r1, r2
    8f88:	e5c32004 	strb	r2, [r3, #4]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:75
    ptr->vflip = OLED_Font::Flip_Chars ? 1 : 0;
    8f8c:	e51b3008 	ldr	r3, [fp, #-8]
    8f90:	e3a02001 	mov	r2, #1
    8f94:	e5c32009 	strb	r2, [r3, #9]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:77
    
    memcpy(&OLED_Font::OLED_Font_Default[OLED_Font::Char_Width * (((uint16_t)c) - OLED_Font::Char_Begin)], &ptr->first, OLED_Font::Char_Width);
    8f98:	e55b3025 	ldrb	r3, [fp, #-37]	; 0xffffffdb
    8f9c:	e2432020 	sub	r2, r3, #32
    8fa0:	e1a03002 	mov	r3, r2
    8fa4:	e1a03083 	lsl	r3, r3, #1
    8fa8:	e0833002 	add	r3, r3, r2
    8fac:	e1a03083 	lsl	r3, r3, #1
    8fb0:	e1a02003 	mov	r2, r3
    8fb4:	e59f3044 	ldr	r3, [pc, #68]	; 9000 <_ZN13COLED_Display8Put_CharEttc+0x164>
    8fb8:	e0820003 	add	r0, r2, r3
    8fbc:	e51b3008 	ldr	r3, [fp, #-8]
    8fc0:	e283300a 	add	r3, r3, #10
    8fc4:	e3a02006 	mov	r2, #6
    8fc8:	e1a01003 	mov	r1, r3
    8fcc:	ebffff01 	bl	8bd8 <_Z6memcpyPKvPvi>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:79

    write(mHandle, buf, sizeof(buf));
    8fd0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8fd4:	e5933000 	ldr	r3, [r3]
    8fd8:	e24b101c 	sub	r1, fp, #28
    8fdc:	e3a02011 	mov	r2, #17
    8fe0:	e1a00003 	mov	r0, r3
    8fe4:	ebfffd17 	bl	8448 <_Z5writejPKcj>
    8fe8:	ea000002 	b	8ff8 <_ZN13COLED_Display8Put_CharEttc+0x15c>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:61
        return;
    8fec:	e320f000 	nop	{0}
    8ff0:	ea000000 	b	8ff8 <_ZN13COLED_Display8Put_CharEttc+0x15c>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:65
        return;
    8ff4:	e320f000 	nop	{0}
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:80
}
    8ff8:	e24bd004 	sub	sp, fp, #4
    8ffc:	e8bd8800 	pop	{fp, pc}
    9000:	000094e0 	andeq	r9, r0, r0, ror #9

00009004 <_ZN13COLED_Display4FlipEv>:
_ZN13COLED_Display4FlipEv():
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:83

void COLED_Display::Flip()
{
    9004:	e92d4800 	push	{fp, lr}
    9008:	e28db004 	add	fp, sp, #4
    900c:	e24dd010 	sub	sp, sp, #16
    9010:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:84
    if (!mOpened)
    9014:	e51b3010 	ldr	r3, [fp, #-16]
    9018:	e5d33004 	ldrb	r3, [r3, #4]
    901c:	e2233001 	eor	r3, r3, #1
    9020:	e6ef3073 	uxtb	r3, r3
    9024:	e3530000 	cmp	r3, #0
    9028:	1a000008 	bne	9050 <_ZN13COLED_Display4FlipEv+0x4c>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:88
        return;

    TDisplay_NonParametric_Packet pkt;
    pkt.header.cmd = NDisplay_Command::Flip;
    902c:	e3a03001 	mov	r3, #1
    9030:	e54b3008 	strb	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:90

    write(mHandle, reinterpret_cast<char*>(&pkt), sizeof(pkt));
    9034:	e51b3010 	ldr	r3, [fp, #-16]
    9038:	e5933000 	ldr	r3, [r3]
    903c:	e24b1008 	sub	r1, fp, #8
    9040:	e3a02001 	mov	r2, #1
    9044:	e1a00003 	mov	r0, r3
    9048:	ebfffcfe 	bl	8448 <_Z5writejPKcj>
    904c:	ea000000 	b	9054 <_ZN13COLED_Display4FlipEv+0x50>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:85
        return;
    9050:	e320f000 	nop	{0}
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:91
}
    9054:	e24bd004 	sub	sp, fp, #4
    9058:	e8bd8800 	pop	{fp, pc}

0000905c <_ZN13COLED_Display10Put_StringEttPKc>:
_ZN13COLED_Display10Put_StringEttPKc():
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:94

void COLED_Display::Put_String(uint16_t x, uint16_t y, const char* str)
{
    905c:	e92d4800 	push	{fp, lr}
    9060:	e28db004 	add	fp, sp, #4
    9064:	e24dd018 	sub	sp, sp, #24
    9068:	e50b0010 	str	r0, [fp, #-16]
    906c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
    9070:	e1a03001 	mov	r3, r1
    9074:	e14b31b2 	strh	r3, [fp, #-18]	; 0xffffffee
    9078:	e1a03002 	mov	r3, r2
    907c:	e14b31b4 	strh	r3, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:95
    if (!mOpened)
    9080:	e51b3010 	ldr	r3, [fp, #-16]
    9084:	e5d33004 	ldrb	r3, [r3, #4]
    9088:	e2233001 	eor	r3, r3, #1
    908c:	e6ef3073 	uxtb	r3, r3
    9090:	e3530000 	cmp	r3, #0
    9094:	1a000019 	bne	9100 <_ZN13COLED_Display10Put_StringEttPKc+0xa4>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:98
        return;

    uint16_t xi = x;
    9098:	e15b31b2 	ldrh	r3, [fp, #-18]	; 0xffffffee
    909c:	e14b30b6 	strh	r3, [fp, #-6]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:99
    const char* ptr = str;
    90a0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    90a4:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:101
    // dokud nedojdeme na konec retezce nebo dokud nejsme 64 znaku daleko (limit, kdyby nahodou se neco pokazilo)
    while (*ptr != '\0' && ptr - str < 64)
    90a8:	e51b300c 	ldr	r3, [fp, #-12]
    90ac:	e5d33000 	ldrb	r3, [r3]
    90b0:	e3530000 	cmp	r3, #0
    90b4:	0a000012 	beq	9104 <_ZN13COLED_Display10Put_StringEttPKc+0xa8>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:101 (discriminator 1)
    90b8:	e51b200c 	ldr	r2, [fp, #-12]
    90bc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    90c0:	e0423003 	sub	r3, r2, r3
    90c4:	e353003f 	cmp	r3, #63	; 0x3f
    90c8:	ca00000d 	bgt	9104 <_ZN13COLED_Display10Put_StringEttPKc+0xa8>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:103
    {
        Put_Char(xi, y, *ptr);
    90cc:	e51b300c 	ldr	r3, [fp, #-12]
    90d0:	e5d33000 	ldrb	r3, [r3]
    90d4:	e15b21b4 	ldrh	r2, [fp, #-20]	; 0xffffffec
    90d8:	e15b10b6 	ldrh	r1, [fp, #-6]
    90dc:	e51b0010 	ldr	r0, [fp, #-16]
    90e0:	ebffff6d 	bl	8e9c <_ZN13COLED_Display8Put_CharEttc>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:104
        xi += OLED_Font::Char_Width;
    90e4:	e15b30b6 	ldrh	r3, [fp, #-6]
    90e8:	e2833006 	add	r3, r3, #6
    90ec:	e14b30b6 	strh	r3, [fp, #-6]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:105
        ptr++;
    90f0:	e51b300c 	ldr	r3, [fp, #-12]
    90f4:	e2833001 	add	r3, r3, #1
    90f8:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:101
    while (*ptr != '\0' && ptr - str < 64)
    90fc:	eaffffe9 	b	90a8 <_ZN13COLED_Display10Put_StringEttPKc+0x4c>
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:96
        return;
    9100:	e320f000 	nop	{0}
/home/hintik/dev/KIV-RTOS-master/sources/stdutils/src/oled.cpp:107
    }
}
    9104:	e24bd004 	sub	sp, fp, #4
    9108:	e8bd8800 	pop	{fp, pc}

0000910c <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1150
    910c:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1152
    9110:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1153
    9114:	3a000074 	bcc	92ec <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1154
    9118:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1155
    911c:	9a00006b 	bls	92d0 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    9120:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    9124:	0a00006c 	beq	92dc <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    9128:	e16f3f10 	clz	r3, r0
    912c:	e16f2f11 	clz	r2, r1
    9130:	e0423003 	sub	r3, r2, r3
    9134:	e273301f 	rsbs	r3, r3, #31
    9138:	10833083 	addne	r3, r3, r3, lsl #1
    913c:	e3a02000 	mov	r2, #0
    9140:	108ff103 	addne	pc, pc, r3, lsl #2
    9144:	e1a00000 	nop			; (mov r0, r0)
    9148:	e1500f81 	cmp	r0, r1, lsl #31
    914c:	e0a22002 	adc	r2, r2, r2
    9150:	20400f81 	subcs	r0, r0, r1, lsl #31
    9154:	e1500f01 	cmp	r0, r1, lsl #30
    9158:	e0a22002 	adc	r2, r2, r2
    915c:	20400f01 	subcs	r0, r0, r1, lsl #30
    9160:	e1500e81 	cmp	r0, r1, lsl #29
    9164:	e0a22002 	adc	r2, r2, r2
    9168:	20400e81 	subcs	r0, r0, r1, lsl #29
    916c:	e1500e01 	cmp	r0, r1, lsl #28
    9170:	e0a22002 	adc	r2, r2, r2
    9174:	20400e01 	subcs	r0, r0, r1, lsl #28
    9178:	e1500d81 	cmp	r0, r1, lsl #27
    917c:	e0a22002 	adc	r2, r2, r2
    9180:	20400d81 	subcs	r0, r0, r1, lsl #27
    9184:	e1500d01 	cmp	r0, r1, lsl #26
    9188:	e0a22002 	adc	r2, r2, r2
    918c:	20400d01 	subcs	r0, r0, r1, lsl #26
    9190:	e1500c81 	cmp	r0, r1, lsl #25
    9194:	e0a22002 	adc	r2, r2, r2
    9198:	20400c81 	subcs	r0, r0, r1, lsl #25
    919c:	e1500c01 	cmp	r0, r1, lsl #24
    91a0:	e0a22002 	adc	r2, r2, r2
    91a4:	20400c01 	subcs	r0, r0, r1, lsl #24
    91a8:	e1500b81 	cmp	r0, r1, lsl #23
    91ac:	e0a22002 	adc	r2, r2, r2
    91b0:	20400b81 	subcs	r0, r0, r1, lsl #23
    91b4:	e1500b01 	cmp	r0, r1, lsl #22
    91b8:	e0a22002 	adc	r2, r2, r2
    91bc:	20400b01 	subcs	r0, r0, r1, lsl #22
    91c0:	e1500a81 	cmp	r0, r1, lsl #21
    91c4:	e0a22002 	adc	r2, r2, r2
    91c8:	20400a81 	subcs	r0, r0, r1, lsl #21
    91cc:	e1500a01 	cmp	r0, r1, lsl #20
    91d0:	e0a22002 	adc	r2, r2, r2
    91d4:	20400a01 	subcs	r0, r0, r1, lsl #20
    91d8:	e1500981 	cmp	r0, r1, lsl #19
    91dc:	e0a22002 	adc	r2, r2, r2
    91e0:	20400981 	subcs	r0, r0, r1, lsl #19
    91e4:	e1500901 	cmp	r0, r1, lsl #18
    91e8:	e0a22002 	adc	r2, r2, r2
    91ec:	20400901 	subcs	r0, r0, r1, lsl #18
    91f0:	e1500881 	cmp	r0, r1, lsl #17
    91f4:	e0a22002 	adc	r2, r2, r2
    91f8:	20400881 	subcs	r0, r0, r1, lsl #17
    91fc:	e1500801 	cmp	r0, r1, lsl #16
    9200:	e0a22002 	adc	r2, r2, r2
    9204:	20400801 	subcs	r0, r0, r1, lsl #16
    9208:	e1500781 	cmp	r0, r1, lsl #15
    920c:	e0a22002 	adc	r2, r2, r2
    9210:	20400781 	subcs	r0, r0, r1, lsl #15
    9214:	e1500701 	cmp	r0, r1, lsl #14
    9218:	e0a22002 	adc	r2, r2, r2
    921c:	20400701 	subcs	r0, r0, r1, lsl #14
    9220:	e1500681 	cmp	r0, r1, lsl #13
    9224:	e0a22002 	adc	r2, r2, r2
    9228:	20400681 	subcs	r0, r0, r1, lsl #13
    922c:	e1500601 	cmp	r0, r1, lsl #12
    9230:	e0a22002 	adc	r2, r2, r2
    9234:	20400601 	subcs	r0, r0, r1, lsl #12
    9238:	e1500581 	cmp	r0, r1, lsl #11
    923c:	e0a22002 	adc	r2, r2, r2
    9240:	20400581 	subcs	r0, r0, r1, lsl #11
    9244:	e1500501 	cmp	r0, r1, lsl #10
    9248:	e0a22002 	adc	r2, r2, r2
    924c:	20400501 	subcs	r0, r0, r1, lsl #10
    9250:	e1500481 	cmp	r0, r1, lsl #9
    9254:	e0a22002 	adc	r2, r2, r2
    9258:	20400481 	subcs	r0, r0, r1, lsl #9
    925c:	e1500401 	cmp	r0, r1, lsl #8
    9260:	e0a22002 	adc	r2, r2, r2
    9264:	20400401 	subcs	r0, r0, r1, lsl #8
    9268:	e1500381 	cmp	r0, r1, lsl #7
    926c:	e0a22002 	adc	r2, r2, r2
    9270:	20400381 	subcs	r0, r0, r1, lsl #7
    9274:	e1500301 	cmp	r0, r1, lsl #6
    9278:	e0a22002 	adc	r2, r2, r2
    927c:	20400301 	subcs	r0, r0, r1, lsl #6
    9280:	e1500281 	cmp	r0, r1, lsl #5
    9284:	e0a22002 	adc	r2, r2, r2
    9288:	20400281 	subcs	r0, r0, r1, lsl #5
    928c:	e1500201 	cmp	r0, r1, lsl #4
    9290:	e0a22002 	adc	r2, r2, r2
    9294:	20400201 	subcs	r0, r0, r1, lsl #4
    9298:	e1500181 	cmp	r0, r1, lsl #3
    929c:	e0a22002 	adc	r2, r2, r2
    92a0:	20400181 	subcs	r0, r0, r1, lsl #3
    92a4:	e1500101 	cmp	r0, r1, lsl #2
    92a8:	e0a22002 	adc	r2, r2, r2
    92ac:	20400101 	subcs	r0, r0, r1, lsl #2
    92b0:	e1500081 	cmp	r0, r1, lsl #1
    92b4:	e0a22002 	adc	r2, r2, r2
    92b8:	20400081 	subcs	r0, r0, r1, lsl #1
    92bc:	e1500001 	cmp	r0, r1
    92c0:	e0a22002 	adc	r2, r2, r2
    92c4:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    92c8:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    92cc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    92d0:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    92d4:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    92d8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1169
    92dc:	e16f2f11 	clz	r2, r1
    92e0:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1171
    92e4:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1172
    92e8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1176
    92ec:	e3500000 	cmp	r0, #0
    92f0:	13e00000 	mvnne	r0, #0
    92f4:	ea000007 	b	9318 <__aeabi_idiv0>

000092f8 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1207
    92f8:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1208
    92fc:	0afffffa 	beq	92ec <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1209
    9300:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1210
    9304:	ebffff80 	bl	910c <__udivsi3>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1211
    9308:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1212
    930c:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1213
    9310:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1214
    9314:	e12fff1e 	bx	lr

00009318 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1512
    9318:	e12fff1e 	bx	lr

Disassembly of section .rodata:

0000931c <_ZL13Lock_Unlocked>:
    931c:	00000000 	andeq	r0, r0, r0

00009320 <_ZL11Lock_Locked>:
    9320:	00000001 	andeq	r0, r0, r1

00009324 <_ZL21MaxFSDriverNameLength>:
    9324:	00000010 	andeq	r0, r0, r0, lsl r0

00009328 <_ZL17MaxFilenameLength>:
    9328:	00000010 	andeq	r0, r0, r0, lsl r0

0000932c <_ZL13MaxPathLength>:
    932c:	00000080 	andeq	r0, r0, r0, lsl #1

00009330 <_ZL18NoFilesystemDriver>:
    9330:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009334 <_ZL9NotifyAll>:
    9334:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009338 <_ZL24Max_Process_Opened_Files>:
    9338:	00000010 	andeq	r0, r0, r0, lsl r0

0000933c <_ZL10Indefinite>:
    933c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009340 <_ZL18Deadline_Unchanged>:
    9340:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009344 <_ZL14Invalid_Handle>:
    9344:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009348 <_ZN3halL18Default_Clock_RateE>:
    9348:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000934c <_ZN3halL15Peripheral_BaseE>:
    934c:	20000000 	andcs	r0, r0, r0

00009350 <_ZN3halL9GPIO_BaseE>:
    9350:	20200000 	eorcs	r0, r0, r0

00009354 <_ZN3halL14GPIO_Pin_CountE>:
    9354:	00000036 	andeq	r0, r0, r6, lsr r0

00009358 <_ZN3halL8AUX_BaseE>:
    9358:	20215000 	eorcs	r5, r1, r0

0000935c <_ZN3halL25Interrupt_Controller_BaseE>:
    935c:	2000b200 	andcs	fp, r0, r0, lsl #4

00009360 <_ZN3halL10Timer_BaseE>:
    9360:	2000b400 	andcs	fp, r0, r0, lsl #8

00009364 <_ZN3halL9TRNG_BaseE>:
    9364:	20104000 	andscs	r4, r0, r0

00009368 <_ZN3halL9BSC0_BaseE>:
    9368:	20205000 	eorcs	r5, r0, r0

0000936c <_ZN3halL9BSC1_BaseE>:
    936c:	20804000 	addcs	r4, r0, r0

00009370 <_ZN3halL9BSC2_BaseE>:
    9370:	20805000 	addcs	r5, r0, r0

00009374 <_ZL11Invalid_Pin>:
    9374:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    9378:	6c622049 	stclvs	0, cr2, [r2], #-292	; 0xfffffedc
    937c:	2c6b6e69 	stclcs	14, cr6, [fp], #-420	; 0xfffffe5c
    9380:	65687420 	strbvs	r7, [r8, #-1056]!	; 0xfffffbe0
    9384:	6f666572 	svcvs	0x00666572
    9388:	49206572 	stmdbmi	r0!, {r1, r4, r5, r6, r8, sl, sp, lr}
    938c:	2e6d6120 	powcsep	f6, f5, f0
    9390:	00000000 	andeq	r0, r0, r0
    9394:	65732049 	ldrbvs	r2, [r3, #-73]!	; 0xffffffb7
    9398:	65642065 	strbvs	r2, [r4, #-101]!	; 0xffffff9b
    939c:	70206461 	eorvc	r6, r0, r1, ror #8
    93a0:	6c657869 	stclvs	8, cr7, [r5], #-420	; 0xfffffe5c
    93a4:	00002e73 	andeq	r2, r0, r3, ror lr
    93a8:	20656e4f 	rsbcs	r6, r5, pc, asr #28
    93ac:	20555043 	subscs	r5, r5, r3, asr #32
    93b0:	656c7572 	strbvs	r7, [ip, #-1394]!	; 0xfffffa8e
    93b4:	68742073 	ldmdavs	r4!, {r0, r1, r4, r5, r6, sp}^
    93b8:	61206d65 			; <UNDEFINED> instruction: 0x61206d65
    93bc:	002e6c6c 	eoreq	r6, lr, ip, ror #24
    93c0:	6620794d 	strtvs	r7, [r0], -sp, asr #18
    93c4:	756f7661 	strbvc	r7, [pc, #-1633]!	; 8d6b <_ZN13COLED_Display5ClearEb+0x37>
    93c8:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    93cc:	6f707320 	svcvs	0x00707320
    93d0:	69207472 	stmdbvs	r0!, {r1, r4, r5, r6, sl, ip, sp, lr}
    93d4:	52412073 	subpl	r2, r1, #115	; 0x73
    93d8:	7277204d 	rsbsvc	r2, r7, #77	; 0x4d
    93dc:	6c747365 	ldclvs	3, cr7, [r4], #-404	; 0xfffffe6c
    93e0:	00676e69 	rsbeq	r6, r7, r9, ror #28
    93e4:	20646c4f 	rsbcs	r6, r4, pc, asr #24
    93e8:	4463614d 	strbtmi	r6, [r3], #-333	; 0xfffffeb3
    93ec:	6c616e6f 	stclvs	14, cr6, [r1], #-444	; 0xfffffe44
    93f0:	61682064 	cmnvs	r8, r4, rrx
    93f4:	20612064 	rsbcs	r2, r1, r4, rrx
    93f8:	6d726166 	ldfvse	f6, [r2, #-408]!	; 0xfffffe68
    93fc:	4945202c 	stmdbmi	r5, {r2, r3, r5, sp}^
    9400:	00505247 	subseq	r5, r0, r7, asr #4
    9404:	3a564544 	bcc	159a91c <__bss_end+0x15911d8>
    9408:	64656c6f 	strbtvs	r6, [r5], #-3183	; 0xfffff391
    940c:	00000000 	andeq	r0, r0, r0
    9410:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
    9414:	534f5452 	movtpl	r5, #62546	; 0xf452
    9418:	696e6920 	stmdbvs	lr!, {r5, r8, fp, sp, lr}^
    941c:	2e2e2e74 	mcrcs	14, 1, r2, cr14, cr4, {3}
    9420:	00000000 	andeq	r0, r0, r0
    9424:	3a564544 	bcc	159a93c <__bss_end+0x15911f8>
    9428:	676e7274 			; <UNDEFINED> instruction: 0x676e7274
    942c:	00000000 	andeq	r0, r0, r0

00009430 <_ZL13Lock_Unlocked>:
    9430:	00000000 	andeq	r0, r0, r0

00009434 <_ZL11Lock_Locked>:
    9434:	00000001 	andeq	r0, r0, r1

00009438 <_ZL21MaxFSDriverNameLength>:
    9438:	00000010 	andeq	r0, r0, r0, lsl r0

0000943c <_ZL17MaxFilenameLength>:
    943c:	00000010 	andeq	r0, r0, r0, lsl r0

00009440 <_ZL13MaxPathLength>:
    9440:	00000080 	andeq	r0, r0, r0, lsl #1

00009444 <_ZL18NoFilesystemDriver>:
    9444:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009448 <_ZL9NotifyAll>:
    9448:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000944c <_ZL24Max_Process_Opened_Files>:
    944c:	00000010 	andeq	r0, r0, r0, lsl r0

00009450 <_ZL10Indefinite>:
    9450:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009454 <_ZL18Deadline_Unchanged>:
    9454:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009458 <_ZL14Invalid_Handle>:
    9458:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000945c <_ZL16Pipe_File_Prefix>:
    945c:	3a535953 	bcc	14df9b0 <__bss_end+0x14d626c>
    9460:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9464:	0000002f 	andeq	r0, r0, pc, lsr #32

00009468 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9468:	33323130 	teqcc	r2, #48, 2
    946c:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9470:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9474:	46454443 	strbmi	r4, [r5], -r3, asr #8
    9478:	00000000 	andeq	r0, r0, r0

0000947c <_ZL13Lock_Unlocked>:
    947c:	00000000 	andeq	r0, r0, r0

00009480 <_ZL11Lock_Locked>:
    9480:	00000001 	andeq	r0, r0, r1

00009484 <_ZL21MaxFSDriverNameLength>:
    9484:	00000010 	andeq	r0, r0, r0, lsl r0

00009488 <_ZL17MaxFilenameLength>:
    9488:	00000010 	andeq	r0, r0, r0, lsl r0

0000948c <_ZL13MaxPathLength>:
    948c:	00000080 	andeq	r0, r0, r0, lsl #1

00009490 <_ZL18NoFilesystemDriver>:
    9490:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009494 <_ZL9NotifyAll>:
    9494:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009498 <_ZL24Max_Process_Opened_Files>:
    9498:	00000010 	andeq	r0, r0, r0, lsl r0

0000949c <_ZL10Indefinite>:
    949c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000094a0 <_ZL18Deadline_Unchanged>:
    94a0:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

000094a4 <_ZL14Invalid_Handle>:
    94a4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000094a8 <_ZN3halL18Default_Clock_RateE>:
    94a8:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

000094ac <_ZN3halL15Peripheral_BaseE>:
    94ac:	20000000 	andcs	r0, r0, r0

000094b0 <_ZN3halL9GPIO_BaseE>:
    94b0:	20200000 	eorcs	r0, r0, r0

000094b4 <_ZN3halL14GPIO_Pin_CountE>:
    94b4:	00000036 	andeq	r0, r0, r6, lsr r0

000094b8 <_ZN3halL8AUX_BaseE>:
    94b8:	20215000 	eorcs	r5, r1, r0

000094bc <_ZN3halL25Interrupt_Controller_BaseE>:
    94bc:	2000b200 	andcs	fp, r0, r0, lsl #4

000094c0 <_ZN3halL10Timer_BaseE>:
    94c0:	2000b400 	andcs	fp, r0, r0, lsl #8

000094c4 <_ZN3halL9TRNG_BaseE>:
    94c4:	20104000 	andscs	r4, r0, r0

000094c8 <_ZN3halL9BSC0_BaseE>:
    94c8:	20205000 	eorcs	r5, r0, r0

000094cc <_ZN3halL9BSC1_BaseE>:
    94cc:	20804000 	addcs	r4, r0, r0

000094d0 <_ZN3halL9BSC2_BaseE>:
    94d0:	20805000 	addcs	r5, r0, r0

000094d4 <_ZN9OLED_FontL10Char_WidthE>:
    94d4:	 	andeq	r0, r8, r6

000094d6 <_ZN9OLED_FontL11Char_HeightE>:
    94d6:	 	eoreq	r0, r0, r8

000094d8 <_ZN9OLED_FontL10Char_BeginE>:
    94d8:	 	addeq	r0, r0, r0, lsr #32

000094da <_ZN9OLED_FontL8Char_EndE>:
    94da:	 	andeq	r0, r1, r0, lsl #1

000094dc <_ZN9OLED_FontL10Flip_CharsE>:
    94dc:	00000001 	andeq	r0, r0, r1

000094e0 <_ZN9OLED_FontL17OLED_Font_DefaultE>:
	...
    94e8:	00002f00 	andeq	r2, r0, r0, lsl #30
    94ec:	00070000 	andeq	r0, r7, r0
    94f0:	14000007 	strne	r0, [r0], #-7
    94f4:	147f147f 	ldrbtne	r1, [pc], #-1151	; 94fc <_ZN9OLED_FontL17OLED_Font_DefaultE+0x1c>
    94f8:	7f2a2400 	svcvc	0x002a2400
    94fc:	2300122a 	movwcs	r1, #554	; 0x22a
    9500:	62640813 	rsbvs	r0, r4, #1245184	; 0x130000
    9504:	55493600 	strbpl	r3, [r9, #-1536]	; 0xfffffa00
    9508:	00005022 	andeq	r5, r0, r2, lsr #32
    950c:	00000305 	andeq	r0, r0, r5, lsl #6
    9510:	221c0000 	andscs	r0, ip, #0
    9514:	00000041 	andeq	r0, r0, r1, asr #32
    9518:	001c2241 	andseq	r2, ip, r1, asr #4
    951c:	3e081400 	cfcpyscc	mvf1, mvf8
    9520:	08001408 	stmdaeq	r0, {r3, sl, ip}
    9524:	08083e08 	stmdaeq	r8, {r3, r9, sl, fp, ip, sp}
    9528:	a0000000 	andge	r0, r0, r0
    952c:	08000060 	stmdaeq	r0, {r5, r6}
    9530:	08080808 	stmdaeq	r8, {r3, fp}
    9534:	60600000 	rsbvs	r0, r0, r0
    9538:	20000000 	andcs	r0, r0, r0
    953c:	02040810 	andeq	r0, r4, #16, 16	; 0x100000
    9540:	49513e00 	ldmdbmi	r1, {r9, sl, fp, ip, sp}^
    9544:	00003e45 	andeq	r3, r0, r5, asr #28
    9548:	00407f42 	subeq	r7, r0, r2, asr #30
    954c:	51614200 	cmnpl	r1, r0, lsl #4
    9550:	21004649 	tstcs	r0, r9, asr #12
    9554:	314b4541 	cmpcc	fp, r1, asr #10
    9558:	12141800 	andsne	r1, r4, #0, 16
    955c:	2700107f 	smlsdxcs	r0, pc, r0, r1	; <UNPREDICTABLE>
    9560:	39454545 	stmdbcc	r5, {r0, r2, r6, r8, sl, lr}^
    9564:	494a3c00 	stmdbmi	sl, {sl, fp, ip, sp}^
    9568:	01003049 	tsteq	r0, r9, asr #32
    956c:	03050971 	movweq	r0, #22897	; 0x5971
    9570:	49493600 	stmdbmi	r9, {r9, sl, ip, sp}^
    9574:	06003649 	streq	r3, [r0], -r9, asr #12
    9578:	1e294949 	vnmulne.f16	s8, s18, s18	; <UNPREDICTABLE>
    957c:	36360000 	ldrtcc	r0, [r6], -r0
    9580:	00000000 	andeq	r0, r0, r0
    9584:	00003656 	andeq	r3, r0, r6, asr r6
    9588:	22140800 	andscs	r0, r4, #0, 16
    958c:	14000041 	strne	r0, [r0], #-65	; 0xffffffbf
    9590:	14141414 	ldrne	r1, [r4], #-1044	; 0xfffffbec
    9594:	22410000 	subcs	r0, r1, #0
    9598:	02000814 	andeq	r0, r0, #20, 16	; 0x140000
    959c:	06095101 	streq	r5, [r9], -r1, lsl #2
    95a0:	59493200 	stmdbpl	r9, {r9, ip, sp}^
    95a4:	7c003e51 	stcvc	14, cr3, [r0], {81}	; 0x51
    95a8:	7c121112 	ldfvcs	f1, [r2], {18}
    95ac:	49497f00 	stmdbmi	r9, {r8, r9, sl, fp, ip, sp, lr}^
    95b0:	3e003649 	cfmadd32cc	mvax2, mvfx3, mvfx0, mvfx9
    95b4:	22414141 	subcs	r4, r1, #1073741840	; 0x40000010
    95b8:	41417f00 	cmpmi	r1, r0, lsl #30
    95bc:	7f001c22 	svcvc	0x00001c22
    95c0:	41494949 	cmpmi	r9, r9, asr #18
    95c4:	09097f00 	stmdbeq	r9, {r8, r9, sl, fp, ip, sp, lr}
    95c8:	3e000109 	adfccs	f0, f0, #1.0
    95cc:	7a494941 	bvc	125bad8 <__bss_end+0x1252394>
    95d0:	08087f00 	stmdaeq	r8, {r8, r9, sl, fp, ip, sp, lr}
    95d4:	00007f08 	andeq	r7, r0, r8, lsl #30
    95d8:	00417f41 	subeq	r7, r1, r1, asr #30
    95dc:	41402000 	mrsmi	r2, (UNDEF: 64)
    95e0:	7f00013f 	svcvc	0x0000013f
    95e4:	41221408 			; <UNDEFINED> instruction: 0x41221408
    95e8:	40407f00 	submi	r7, r0, r0, lsl #30
    95ec:	7f004040 	svcvc	0x00004040
    95f0:	7f020c02 	svcvc	0x00020c02
    95f4:	08047f00 	stmdaeq	r4, {r8, r9, sl, fp, ip, sp, lr}
    95f8:	3e007f10 	mcrcc	15, 0, r7, cr0, cr0, {0}
    95fc:	3e414141 	dvfccsm	f4, f1, f1
    9600:	09097f00 	stmdbeq	r9, {r8, r9, sl, fp, ip, sp, lr}
    9604:	3e000609 	cfmadd32cc	mvax0, mvfx0, mvfx0, mvfx9
    9608:	5e215141 	sufplsm	f5, f1, f1
    960c:	19097f00 	stmdbne	r9, {r8, r9, sl, fp, ip, sp, lr}
    9610:	46004629 	strmi	r4, [r0], -r9, lsr #12
    9614:	31494949 	cmpcc	r9, r9, asr #18
    9618:	7f010100 	svcvc	0x00010100
    961c:	3f000101 	svccc	0x00000101
    9620:	3f404040 	svccc	0x00404040
    9624:	40201f00 	eormi	r1, r0, r0, lsl #30
    9628:	3f001f20 	svccc	0x00001f20
    962c:	3f403840 	svccc	0x00403840
    9630:	08146300 	ldmdaeq	r4, {r8, r9, sp, lr}
    9634:	07006314 	smladeq	r0, r4, r3, r6
    9638:	07087008 	streq	r7, [r8, -r8]
    963c:	49516100 	ldmdbmi	r1, {r8, sp, lr}^
    9640:	00004345 	andeq	r4, r0, r5, asr #6
    9644:	0041417f 	subeq	r4, r1, pc, ror r1
    9648:	552a5500 	strpl	r5, [sl, #-1280]!	; 0xfffffb00
    964c:	0000552a 	andeq	r5, r0, sl, lsr #10
    9650:	007f4141 	rsbseq	r4, pc, r1, asr #2
    9654:	01020400 	tsteq	r2, r0, lsl #8
    9658:	40000402 	andmi	r0, r0, r2, lsl #8
    965c:	40404040 	submi	r4, r0, r0, asr #32
    9660:	02010000 	andeq	r0, r1, #0
    9664:	20000004 	andcs	r0, r0, r4
    9668:	78545454 	ldmdavc	r4, {r2, r4, r6, sl, ip, lr}^
    966c:	44487f00 	strbmi	r7, [r8], #-3840	; 0xfffff100
    9670:	38003844 	stmdacc	r0, {r2, r6, fp, ip, sp}
    9674:	20444444 	subcs	r4, r4, r4, asr #8
    9678:	44443800 	strbmi	r3, [r4], #-2048	; 0xfffff800
    967c:	38007f48 	stmdacc	r0, {r3, r6, r8, r9, sl, fp, ip, sp, lr}
    9680:	18545454 	ldmdane	r4, {r2, r4, r6, sl, ip, lr}^
    9684:	097e0800 	ldmdbeq	lr!, {fp}^
    9688:	18000201 	stmdane	r0, {r0, r9}
    968c:	7ca4a4a4 	cfstrsvc	mvf10, [r4], #656	; 0x290
    9690:	04087f00 	streq	r7, [r8], #-3840	; 0xfffff100
    9694:	00007804 	andeq	r7, r0, r4, lsl #16
    9698:	00407d44 	subeq	r7, r0, r4, asr #26
    969c:	84804000 	strhi	r4, [r0], #0
    96a0:	7f00007d 	svcvc	0x0000007d
    96a4:	00442810 	subeq	r2, r4, r0, lsl r8
    96a8:	7f410000 	svcvc	0x00410000
    96ac:	7c000040 	stcvc	0, cr0, [r0], {64}	; 0x40
    96b0:	78041804 	stmdavc	r4, {r2, fp, ip}
    96b4:	04087c00 	streq	r7, [r8], #-3072	; 0xfffff400
    96b8:	38007804 	stmdacc	r0, {r2, fp, ip, sp, lr}
    96bc:	38444444 	stmdacc	r4, {r2, r6, sl, lr}^
    96c0:	2424fc00 	strtcs	pc, [r4], #-3072	; 0xfffff400
    96c4:	18001824 	stmdane	r0, {r2, r5, fp, ip}
    96c8:	fc182424 	ldc2	4, cr2, [r8], {36}	; 0x24
    96cc:	04087c00 	streq	r7, [r8], #-3072	; 0xfffff400
    96d0:	48000804 	stmdami	r0, {r2, fp}
    96d4:	20545454 	subscs	r5, r4, r4, asr r4
    96d8:	443f0400 	ldrtmi	r0, [pc], #-1024	; 96e0 <_ZN9OLED_FontL17OLED_Font_DefaultE+0x200>
    96dc:	3c002040 	stccc	0, cr2, [r0], {64}	; 0x40
    96e0:	7c204040 	stcvc	0, cr4, [r0], #-256	; 0xffffff00
    96e4:	40201c00 	eormi	r1, r0, r0, lsl #24
    96e8:	3c001c20 	stccc	12, cr1, [r0], {32}
    96ec:	3c403040 	mcrrcc	0, 4, r3, r0, cr0
    96f0:	10284400 	eorne	r4, r8, r0, lsl #8
    96f4:	1c004428 	cfstrsne	mvf4, [r0], {40}	; 0x28
    96f8:	7ca0a0a0 	stcvc	0, cr10, [r0], #640	; 0x280
    96fc:	54644400 	strbtpl	r4, [r4], #-1024	; 0xfffffc00
    9700:	0000444c 	andeq	r4, r0, ip, asr #8
    9704:	00007708 	andeq	r7, r0, r8, lsl #14
    9708:	7f000000 	svcvc	0x00000000
    970c:	00000000 	andeq	r0, r0, r0
    9710:	00000877 	andeq	r0, r0, r7, ror r8
    9714:	10081000 	andne	r1, r8, r0
    9718:	00000008 	andeq	r0, r0, r8
    971c:	00000000 	andeq	r0, r0, r0

Disassembly of section .data:

00009720 <messages>:
__DTOR_END__():
    9720:	00009378 	andeq	r9, r0, r8, ror r3
    9724:	00009394 	muleq	r0, r4, r3
    9728:	000093a8 	andeq	r9, r0, r8, lsr #7
    972c:	000093c0 	andeq	r9, r0, r0, asr #7
    9730:	000093e4 	andeq	r9, r0, r4, ror #7

Disassembly of section .bss:

00009734 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x16840e8>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x38ce0>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3c8f4>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c75e0>
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
 130:	6b69746e 	blvs	1a5d2f0 <__bss_end+0x1a53bac>
 134:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
 138:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 13c:	4f54522d 	svcmi	0x0054522d
 140:	616d2d53 	cmnvs	sp, r3, asr sp
 144:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 148:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe21 <__bss_end+0xffff66dd>
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
 180:	0a030000 	beq	c0188 <__bss_end+0xb6a44>
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
 1d4:	6a0d05a1 	bvs	341860 <__bss_end+0x33811c>
 1d8:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
 1dc:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 1e0:	04020004 	streq	r0, [r2], #-4
 1e4:	0b058302 	bleq	160df4 <__bss_end+0x1576b0>
 1e8:	02040200 	andeq	r0, r4, #0, 4
 1ec:	0002054a 	andeq	r0, r2, sl, asr #10
 1f0:	2d020402 	cfstrscs	mvf0, [r2, #-8]
 1f4:	05850905 	streq	r0, [r5, #2309]	; 0x905
 1f8:	0a022f01 	beq	8be04 <__bss_end+0x826c0>
 1fc:	b5010100 	strlt	r0, [r1, #-256]	; 0xffffff00
 200:	03000002 	movweq	r0, #2
 204:	00025300 	andeq	r5, r2, r0, lsl #6
 208:	fb010200 	blx	40a12 <__bss_end+0x372ce>
 20c:	01000d0e 	tsteq	r0, lr, lsl #26
 210:	00010101 	andeq	r0, r1, r1, lsl #2
 214:	00010000 	andeq	r0, r1, r0
 218:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 21c:	2f656d6f 	svccs	0x00656d6f
 220:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
 224:	642f6b69 	strtvs	r6, [pc], #-2921	; 22c <shift+0x22c>
 228:	4b2f7665 	blmi	bddbc4 <__bss_end+0xbd4480>
 22c:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 230:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
 234:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
 238:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
 23c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 240:	752f7365 	strvc	r7, [pc, #-869]!	; fffffee3 <__bss_end+0xffff679f>
 244:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 248:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 24c:	656c6f2f 	strbvs	r6, [ip, #-3887]!	; 0xfffff0d1
 250:	61745f64 	cmnvs	r4, r4, ror #30
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
 29c:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 2a0:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 2a4:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 2a8:	2f006c61 	svccs	0x00006c61
 2ac:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 2b0:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 2b4:	2f6b6974 	svccs	0x006b6974
 2b8:	2f766564 	svccs	0x00766564
 2bc:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 2c0:	534f5452 	movtpl	r5, #62546	; 0xf452
 2c4:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 2c8:	2f726574 	svccs	0x00726574
 2cc:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 2d0:	2f736563 	svccs	0x00736563
 2d4:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 2d8:	63617073 	cmnvs	r1, #115	; 0x73
 2dc:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 2e0:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 2e4:	2f6c656e 	svccs	0x006c656e
 2e8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 2ec:	2f656475 	svccs	0x00656475
 2f0:	636f7270 	cmnvs	pc, #112, 4
 2f4:	00737365 	rsbseq	r7, r3, r5, ror #6
 2f8:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 244 <shift+0x244>
 2fc:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 300:	6b69746e 	blvs	1a5d4c0 <__bss_end+0x1a53d7c>
 304:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
 308:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 30c:	4f54522d 	svcmi	0x0054522d
 310:	616d2d53 	cmnvs	sp, r3, asr sp
 314:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 318:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffff1 <__bss_end+0xffff68ad>
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
 348:	6b69746e 	blvs	1a5d508 <__bss_end+0x1a53dc4>
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
 374:	74732f2e 	ldrbtvc	r2, [r3], #-3886	; 0xfffff0d2
 378:	69747564 	ldmdbvs	r4!, {r2, r5, r6, r8, sl, ip, sp, lr}^
 37c:	692f736c 	stmdbvs	pc!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}	; <UNPREDICTABLE>
 380:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 384:	2f006564 	svccs	0x00006564
 388:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 38c:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 390:	2f6b6974 	svccs	0x006b6974
 394:	2f766564 	svccs	0x00766564
 398:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 39c:	534f5452 	movtpl	r5, #62546	; 0xf452
 3a0:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 3a4:	2f726574 	svccs	0x00726574
 3a8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 3ac:	2f736563 	svccs	0x00736563
 3b0:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 3b4:	63617073 	cmnvs	r1, #115	; 0x73
 3b8:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 3bc:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 3c0:	2f6c656e 	svccs	0x006c656e
 3c4:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 3c8:	2f656475 	svccs	0x00656475
 3cc:	76697264 	strbtvc	r7, [r9], -r4, ror #4
 3d0:	00737265 	rsbseq	r7, r3, r5, ror #4
 3d4:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
 3d8:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 3dc:	00010070 	andeq	r0, r1, r0, ror r0
 3e0:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 3e4:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 3e8:	00020068 	andeq	r0, r2, r8, rrx
 3ec:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 3f0:	0300682e 	movweq	r6, #2094	; 0x82e
 3f4:	70730000 	rsbsvc	r0, r3, r0
 3f8:	6f6c6e69 	svcvs	0x006c6e69
 3fc:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 400:	00000300 	andeq	r0, r0, r0, lsl #6
 404:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 408:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 40c:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 410:	00000400 	andeq	r0, r0, r0, lsl #8
 414:	636f7270 	cmnvs	pc, #112, 4
 418:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 41c:	00030068 	andeq	r0, r3, r8, rrx
 420:	6f727000 	svcvs	0x00727000
 424:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 428:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 42c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 430:	0300682e 	movweq	r6, #2094	; 0x82e
 434:	6c6f0000 	stclvs	0, cr0, [pc], #-0	; 43c <shift+0x43c>
 438:	682e6465 	stmdavs	lr!, {r0, r2, r5, r6, sl, sp, lr}
 43c:	00000500 	andeq	r0, r0, r0, lsl #10
 440:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
 444:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
 448:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
 44c:	00020068 	andeq	r0, r2, r8, rrx
 450:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
 454:	00682e6f 	rsbeq	r2, r8, pc, ror #28
 458:	00000006 	andeq	r0, r0, r6
 45c:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 460:	00823402 	addeq	r3, r2, r2, lsl #8
 464:	011a0300 	tsteq	sl, r0, lsl #6
 468:	059f1f05 	ldreq	r1, [pc, #3845]	; 1375 <shift+0x1375>
 46c:	1105830c 	tstne	r5, ip, lsl #6
 470:	9f0b0583 	svcls	0x000b0583
 474:	05681b05 	strbeq	r1, [r8, #-2821]!	; 0xfffff4fb
 478:	0705830b 	streq	r8, [r5, -fp, lsl #6]
 47c:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
 480:	22056b01 	andcs	r6, r5, #1024	; 0x400
 484:	01040200 	mrseq	r0, R12_usr
 488:	000f059f 	muleq	pc, pc, r5	; <UNPREDICTABLE>
 48c:	f2010402 	vshl.s8	d0, d2, d1
 490:	02000d05 	andeq	r0, r0, #320	; 0x140
 494:	05680104 	strbeq	r0, [r8, #-260]!	; 0xfffffefc
 498:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 49c:	0c058301 	stceq	3, cr8, [r5], {1}
 4a0:	01040200 	mrseq	r0, R12_usr
 4a4:	0008059f 	muleq	r8, pc, r5	; <UNPREDICTABLE>
 4a8:	68010402 	stmdavs	r1, {r1, sl}
 4ac:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 4b0:	02670104 	rsbeq	r0, r7, #4, 2
 4b4:	0101000c 	tsteq	r1, ip
 4b8:	000002a3 	andeq	r0, r0, r3, lsr #5
 4bc:	016d0003 	cmneq	sp, r3
 4c0:	01020000 	mrseq	r0, (UNDEF: 2)
 4c4:	000d0efb 	strdeq	r0, [sp], -fp
 4c8:	01010101 	tsteq	r1, r1, lsl #2
 4cc:	01000000 	mrseq	r0, (UNDEF: 0)
 4d0:	2f010000 	svccs	0x00010000
 4d4:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 4d8:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 4dc:	2f6b6974 	svccs	0x006b6974
 4e0:	2f766564 	svccs	0x00766564
 4e4:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 4e8:	534f5452 	movtpl	r5, #62546	; 0xf452
 4ec:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 4f0:	2f726574 	svccs	0x00726574
 4f4:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 4f8:	2f736563 	svccs	0x00736563
 4fc:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
 500:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
 504:	2f006372 	svccs	0x00006372
 508:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 50c:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 510:	2f6b6974 	svccs	0x006b6974
 514:	2f766564 	svccs	0x00766564
 518:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 51c:	534f5452 	movtpl	r5, #62546	; 0xf452
 520:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 524:	2f726574 	svccs	0x00726574
 528:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 52c:	2f736563 	svccs	0x00736563
 530:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 534:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 538:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 53c:	702f6564 	eorvc	r6, pc, r4, ror #10
 540:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 544:	2f007373 	svccs	0x00007373
 548:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 54c:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 550:	2f6b6974 	svccs	0x006b6974
 554:	2f766564 	svccs	0x00766564
 558:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 55c:	534f5452 	movtpl	r5, #62546	; 0xf452
 560:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 564:	2f726574 	svccs	0x00726574
 568:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 56c:	2f736563 	svccs	0x00736563
 570:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 574:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 578:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 57c:	662f6564 	strtvs	r6, [pc], -r4, ror #10
 580:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 584:	2f656d6f 	svccs	0x00656d6f
 588:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
 58c:	642f6b69 	strtvs	r6, [pc], #-2921	; 594 <shift+0x594>
 590:	4b2f7665 	blmi	bddf2c <__bss_end+0xbd47e8>
 594:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 598:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
 59c:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
 5a0:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
 5a4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 5a8:	6b2f7365 	blvs	bdd344 <__bss_end+0xbd3c00>
 5ac:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 5b0:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 5b4:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 5b8:	6f622f65 	svcvs	0x00622f65
 5bc:	2f647261 	svccs	0x00647261
 5c0:	30697072 	rsbcc	r7, r9, r2, ror r0
 5c4:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 5c8:	74730000 	ldrbtvc	r0, [r3], #-0
 5cc:	6c696664 	stclvs	6, cr6, [r9], #-400	; 0xfffffe70
 5d0:	70632e65 	rsbvc	r2, r3, r5, ror #28
 5d4:	00010070 	andeq	r0, r1, r0, ror r0
 5d8:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 5dc:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 5e0:	70730000 	rsbsvc	r0, r3, r0
 5e4:	6f6c6e69 	svcvs	0x006c6e69
 5e8:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 5ec:	00000200 	andeq	r0, r0, r0, lsl #4
 5f0:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 5f4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 5f8:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 5fc:	00000300 	andeq	r0, r0, r0, lsl #6
 600:	636f7270 	cmnvs	pc, #112, 4
 604:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 608:	00020068 	andeq	r0, r2, r8, rrx
 60c:	6f727000 	svcvs	0x00727000
 610:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 614:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 618:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 61c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 620:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 624:	66656474 			; <UNDEFINED> instruction: 0x66656474
 628:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 62c:	05000000 	streq	r0, [r0, #-0]
 630:	02050001 	andeq	r0, r5, #1
 634:	00008340 	andeq	r8, r0, r0, asr #6
 638:	691a0516 	ldmdbvs	sl, {r1, r2, r4, r8, sl}
 63c:	052f2c05 	streq	r2, [pc, #-3077]!	; fffffa3f <__bss_end+0xffff62fb>
 640:	01054c0c 	tsteq	r5, ip, lsl #24
 644:	3205852f 	andcc	r8, r5, #197132288	; 0xbc00000
 648:	4b1a0583 	blmi	681c5c <__bss_end+0x678518>
 64c:	852f0105 	strhi	r0, [pc, #-261]!	; 54f <shift+0x54f>
 650:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 654:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 658:	2e05a132 	mcrcs	1, 0, sl, cr5, cr2, {1}
 65c:	4b1b054b 	blmi	6c1b90 <__bss_end+0x6b844c>
 660:	052f2d05 	streq	r2, [pc, #-3333]!	; fffff963 <__bss_end+0xffff621f>
 664:	01054c0c 	tsteq	r5, ip, lsl #24
 668:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 66c:	4b3005bd 	blmi	c01d68 <__bss_end+0xbf8624>
 670:	054b2e05 	strbeq	r2, [fp, #-3589]	; 0xfffff1fb
 674:	2e054b1b 	vmovcs.32	d5[0], r4
 678:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 67c:	852f0105 	strhi	r0, [pc, #-261]!	; 57f <shift+0x57f>
 680:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
 684:	2e054b30 	vmovcs.16	d5[0], r4
 688:	4b1b054b 	blmi	6c1bbc <__bss_end+0x6b8478>
 68c:	052f2e05 	streq	r2, [pc, #-3589]!	; fffff88f <__bss_end+0xffff614b>
 690:	01054c0c 	tsteq	r5, ip, lsl #24
 694:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 698:	4b1b0583 	blmi	6c1cac <__bss_end+0x6b8568>
 69c:	852f0105 	strhi	r0, [pc, #-261]!	; 59f <shift+0x59f>
 6a0:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
 6a4:	2f054b33 	svccs	0x00054b33
 6a8:	4b1b054b 	blmi	6c1bdc <__bss_end+0x6b8498>
 6ac:	052f3005 	streq	r3, [pc, #-5]!	; 6af <shift+0x6af>
 6b0:	01054c0c 	tsteq	r5, ip, lsl #24
 6b4:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 6b8:	4b2f05a1 	blmi	bc1d44 <__bss_end+0xbb8600>
 6bc:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 6c0:	0c052f2f 	stceq	15, cr2, [r5], {47}	; 0x2f
 6c4:	2f01054c 	svccs	0x0001054c
 6c8:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 6cc:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
 6d0:	1b054b3b 	blne	1533c4 <__bss_end+0x149c80>
 6d4:	2f30054b 	svccs	0x0030054b
 6d8:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 6dc:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6e0:	3b05a12f 	blcc	168ba4 <__bss_end+0x15f460>
 6e4:	4b1a054b 	blmi	681c18 <__bss_end+0x6784d4>
 6e8:	052f3005 	streq	r3, [pc, #-5]!	; 6eb <shift+0x6eb>
 6ec:	01054c0c 	tsteq	r5, ip, lsl #24
 6f0:	2005859f 	mulcs	r5, pc, r5	; <UNPREDICTABLE>
 6f4:	4d2d0567 	cfstr32mi	mvfx0, [sp, #-412]!	; 0xfffffe64
 6f8:	054b3105 	strbeq	r3, [fp, #-261]	; 0xfffffefb
 6fc:	0c054b1a 			; <UNDEFINED> instruction: 0x0c054b1a
 700:	2f010530 	svccs	0x00010530
 704:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 708:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
 70c:	1a054b31 	bne	1533d8 <__bss_end+0x149c94>
 710:	300c054b 	andcc	r0, ip, fp, asr #10
 714:	852f0105 	strhi	r0, [pc, #-261]!	; 617 <shift+0x617>
 718:	05832005 	streq	r2, [r3, #5]
 71c:	3e054c2d 	cdpcc	12, 0, cr4, cr5, cr13, {1}
 720:	4b1a054b 	blmi	681c54 <__bss_end+0x678510>
 724:	852f0105 	strhi	r0, [pc, #-261]!	; 627 <shift+0x627>
 728:	05672005 	strbeq	r2, [r7, #-5]!
 72c:	30054d2d 	andcc	r4, r5, sp, lsr #26
 730:	4b1a054b 	blmi	681c64 <__bss_end+0x678520>
 734:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 738:	05872f01 	streq	r2, [r7, #3841]	; 0xf01
 73c:	059fa00c 	ldreq	sl, [pc, #12]	; 750 <shift+0x750>
 740:	2905bc31 	stmdbcs	r5, {r0, r4, r5, sl, fp, ip, sp, pc}
 744:	2e360566 	cdpcs	5, 3, cr0, cr6, cr6, {3}
 748:	05300f05 	ldreq	r0, [r0, #-3845]!	; 0xfffff0fb
 74c:	09056613 	stmdbeq	r5, {r0, r1, r4, r9, sl, sp, lr}
 750:	d8100584 	ldmdale	r0, {r2, r7, r8, sl}
 754:	059e3305 	ldreq	r3, [lr, #773]	; 0x305
 758:	08022f01 	stmdaeq	r2, {r0, r8, r9, sl, fp, sp}
 75c:	32010100 	andcc	r0, r1, #0, 2
 760:	03000002 	movweq	r0, #2
 764:	00005800 	andeq	r5, r0, r0, lsl #16
 768:	fb010200 	blx	40f72 <__bss_end+0x3782e>
 76c:	01000d0e 	tsteq	r0, lr, lsl #26
 770:	00010101 	andeq	r0, r1, r1, lsl #2
 774:	00010000 	andeq	r0, r1, r0
 778:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 77c:	2f656d6f 	svccs	0x00656d6f
 780:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
 784:	642f6b69 	strtvs	r6, [pc], #-2921	; 78c <shift+0x78c>
 788:	4b2f7665 	blmi	bde124 <__bss_end+0xbd49e0>
 78c:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 790:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
 794:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
 798:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
 79c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 7a0:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
 7a4:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 7a8:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
 7ac:	73000063 	movwvc	r0, #99	; 0x63
 7b0:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
 7b4:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
 7b8:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 7bc:	00000100 	andeq	r0, r0, r0, lsl #2
 7c0:	00010500 	andeq	r0, r1, r0, lsl #10
 7c4:	87a00205 	strhi	r0, [r0, r5, lsl #4]!
 7c8:	051a0000 	ldreq	r0, [sl, #-0]
 7cc:	0f05bb06 	svceq	0x0005bb06
 7d0:	6821054c 	stmdavs	r1!, {r2, r3, r6, r8, sl}
 7d4:	05ba0b05 	ldreq	r0, [sl, #2821]!	; 0xb05
 7d8:	0d056627 	stceq	6, cr6, [r5, #-156]	; 0xffffff64
 7dc:	2f09054a 	svccs	0x0009054a
 7e0:	059f0405 	ldreq	r0, [pc, #1029]	; bed <shift+0xbed>
 7e4:	05056202 	streq	r6, [r5, #-514]	; 0xfffffdfe
 7e8:	68110535 	ldmdavs	r1, {r0, r2, r4, r5, r8, sl}
 7ec:	05662205 	strbeq	r2, [r6, #-517]!	; 0xfffffdfb
 7f0:	0a052e13 	beq	14c044 <__bss_end+0x142900>
 7f4:	0c05692f 			; <UNDEFINED> instruction: 0x0c05692f
 7f8:	4b030566 	blmi	c1d98 <__bss_end+0xb8654>
 7fc:	05680b05 	strbeq	r0, [r8, #-2821]!	; 0xfffff4fb
 800:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 804:	14054a03 	strne	r4, [r5], #-2563	; 0xfffff5fd
 808:	03040200 	movweq	r0, #16896	; 0x4200
 80c:	0015059e 	mulseq	r5, lr, r5
 810:	68020402 	stmdavs	r2, {r1, sl}
 814:	02001805 	andeq	r1, r0, #327680	; 0x50000
 818:	05820204 	streq	r0, [r2, #516]	; 0x204
 81c:	04020008 	streq	r0, [r2], #-8
 820:	1b054a02 	blne	153030 <__bss_end+0x1498ec>
 824:	02040200 	andeq	r0, r4, #0, 4
 828:	000c054b 	andeq	r0, ip, fp, asr #10
 82c:	66020402 	strvs	r0, [r2], -r2, lsl #8
 830:	02000f05 	andeq	r0, r0, #5, 30
 834:	05820204 	streq	r0, [r2, #516]	; 0x204
 838:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
 83c:	11054a02 	tstne	r5, r2, lsl #20
 840:	02040200 	andeq	r0, r4, #0, 4
 844:	000b052e 	andeq	r0, fp, lr, lsr #10
 848:	2f020402 	svccs	0x00020402
 84c:	02000d05 	andeq	r0, r0, #320	; 0x140
 850:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 854:	04020002 	streq	r0, [r2], #-2
 858:	01054602 	tsteq	r5, r2, lsl #12
 85c:	06058588 	streq	r8, [r5], -r8, lsl #11
 860:	4c090583 	cfstr32mi	mvfx0, [r9], {131}	; 0x83
 864:	054a1005 	strbeq	r1, [sl, #-5]
 868:	07054c0a 	streq	r4, [r5, -sl, lsl #24]
 86c:	4a0305bb 	bmi	c1f60 <__bss_end+0xb881c>
 870:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 874:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 878:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 87c:	0d054a01 	vstreq	s8, [r5, #-4]
 880:	4a14054d 	bmi	501dbc <__bss_end+0x4f8678>
 884:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
 888:	02056808 	andeq	r6, r5, #8, 16	; 0x80000
 88c:	05667803 	strbeq	r7, [r6, #-2051]!	; 0xfffff7fd
 890:	2e0b0309 	cdpcs	3, 0, cr0, cr11, cr9, {0}
 894:	852f0105 	strhi	r0, [pc, #-261]!	; 797 <shift+0x797>
 898:	05bd0905 	ldreq	r0, [sp, #2309]!	; 0x905
 89c:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
 8a0:	1e054a04 	vmlane.f32	s8, s10, s8
 8a4:	02040200 	andeq	r0, r4, #0, 4
 8a8:	00160582 	andseq	r0, r6, r2, lsl #11
 8ac:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 8b0:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
 8b4:	054b0304 	strbeq	r0, [fp, #-772]	; 0xfffffcfc
 8b8:	04020009 	streq	r0, [r2], #-9
 8bc:	12056603 	andne	r6, r5, #3145728	; 0x300000
 8c0:	03040200 	movweq	r0, #16896	; 0x4200
 8c4:	000b0566 	andeq	r0, fp, r6, ror #10
 8c8:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 8cc:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 8d0:	052d0304 	streq	r0, [sp, #-772]!	; 0xfffffcfc
 8d4:	0402000b 	streq	r0, [r2], #-11
 8d8:	09058402 	stmdbeq	r5, {r1, sl, pc}
 8dc:	01040200 	mrseq	r0, R12_usr
 8e0:	000b0583 	andeq	r0, fp, r3, lsl #11
 8e4:	66010402 	strvs	r0, [r1], -r2, lsl #8
 8e8:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 8ec:	05490104 	strbeq	r0, [r9, #-260]	; 0xfffffefc
 8f0:	0105850b 	tsteq	r5, fp, lsl #10
 8f4:	0e05852f 	cfsh32eq	mvfx8, mvfx5, #31
 8f8:	661105bc 			; <UNDEFINED> instruction: 0x661105bc
 8fc:	05bc2005 	ldreq	r2, [ip, #5]!
 900:	1f05660b 	svcne	0x0005660b
 904:	660a054b 	strvs	r0, [sl], -fp, asr #10
 908:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
 90c:	16058314 			; <UNDEFINED> instruction: 0x16058314
 910:	4b08054a 	blmi	201e40 <__bss_end+0x1f86fc>
 914:	05671105 	strbeq	r1, [r7, #-261]!	; 0xfffffefb
 918:	01054d0b 	tsteq	r5, fp, lsl #26
 91c:	0605852f 	streq	r8, [r5], -pc, lsr #10
 920:	4c0c0583 	cfstr32mi	mvfx0, [ip], {131}	; 0x83
 924:	05820e05 	streq	r0, [r2, #3589]	; 0xe05
 928:	02054b04 	andeq	r4, r5, #4, 22	; 0x1000
 92c:	31090565 	tstcc	r9, r5, ror #10
 930:	852f0105 	strhi	r0, [pc, #-261]!	; 833 <shift+0x833>
 934:	059f0805 	ldreq	r0, [pc, #2053]	; 1141 <shift+0x1141>
 938:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
 93c:	03040200 	movweq	r0, #16896	; 0x4200
 940:	0008054a 	andeq	r0, r8, sl, asr #10
 944:	83020402 	movwhi	r0, #9218	; 0x2402
 948:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 94c:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 950:	04020002 	streq	r0, [r2], #-2
 954:	01054902 	tsteq	r5, r2, lsl #18
 958:	0e058584 	cfsh32eq	mvfx8, mvfx5, #-60
 95c:	4b0805bb 	blmi	202050 <__bss_end+0x1f890c>
 960:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
 964:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 968:	17054a03 	strne	r4, [r5, -r3, lsl #20]
 96c:	02040200 	andeq	r0, r4, #0, 4
 970:	000b0583 	andeq	r0, fp, r3, lsl #11
 974:	66020402 	strvs	r0, [r2], -r2, lsl #8
 978:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 97c:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 980:	0402000d 	streq	r0, [r2], #-13
 984:	02052e02 	andeq	r2, r5, #2, 28
 988:	02040200 	andeq	r0, r4, #0, 4
 98c:	8401052d 	strhi	r0, [r1], #-1325	; 0xfffffad3
 990:	01000802 	tsteq	r0, r2, lsl #16
 994:	00037001 	andeq	r7, r3, r1
 998:	2e000300 	cdpcs	3, 0, cr0, cr0, cr0, {0}
 99c:	02000002 	andeq	r0, r0, #2
 9a0:	0d0efb01 	vstreq	d15, [lr, #-4]
 9a4:	01010100 	mrseq	r0, (UNDEF: 17)
 9a8:	00000001 	andeq	r0, r0, r1
 9ac:	01000001 	tsteq	r0, r1
 9b0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 8fc <shift+0x8fc>
 9b4:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 9b8:	6b69746e 	blvs	1a5db78 <__bss_end+0x1a54434>
 9bc:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
 9c0:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 9c4:	4f54522d 	svcmi	0x0054522d
 9c8:	616d2d53 	cmnvs	sp, r3, asr sp
 9cc:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 9d0:	756f732f 	strbvc	r7, [pc, #-815]!	; 6a9 <shift+0x6a9>
 9d4:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 9d8:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 9dc:	6c697475 	cfstrdvs	mvd7, [r9], #-468	; 0xfffffe2c
 9e0:	72732f73 	rsbsvc	r2, r3, #460	; 0x1cc
 9e4:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
 9e8:	2f656d6f 	svccs	0x00656d6f
 9ec:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
 9f0:	642f6b69 	strtvs	r6, [pc], #-2921	; 9f8 <shift+0x9f8>
 9f4:	4b2f7665 	blmi	bde390 <__bss_end+0xbd4c4c>
 9f8:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 9fc:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
 a00:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
 a04:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
 a08:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 a0c:	6b2f7365 	blvs	bdd7a8 <__bss_end+0xbd4064>
 a10:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 a14:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 a18:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 a1c:	6f622f65 	svcvs	0x00622f65
 a20:	2f647261 	svccs	0x00647261
 a24:	30697072 	rsbcc	r7, r9, r2, ror r0
 a28:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 a2c:	6f682f00 	svcvs	0x00682f00
 a30:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
 a34:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
 a38:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
 a3c:	494b2f76 	stmdbmi	fp, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
 a40:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
 a44:	6d2d534f 	stcvs	3, cr5, [sp, #-316]!	; 0xfffffec4
 a48:	65747361 	ldrbvs	r7, [r4, #-865]!	; 0xfffffc9f
 a4c:	6f732f72 	svcvs	0x00732f72
 a50:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 a54:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
 a58:	69747564 	ldmdbvs	r4!, {r2, r5, r6, r8, sl, ip, sp, lr}^
 a5c:	692f736c 	stmdbvs	pc!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}	; <UNPREDICTABLE>
 a60:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 a64:	2f006564 	svccs	0x00006564
 a68:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 a6c:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 a70:	2f6b6974 	svccs	0x006b6974
 a74:	2f766564 	svccs	0x00766564
 a78:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 a7c:	534f5452 	movtpl	r5, #62546	; 0xf452
 a80:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 a84:	2f726574 	svccs	0x00726574
 a88:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 a8c:	2f736563 	svccs	0x00736563
 a90:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 a94:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 a98:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 a9c:	702f6564 	eorvc	r6, pc, r4, ror #10
 aa0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 aa4:	2f007373 	svccs	0x00007373
 aa8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 aac:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 ab0:	2f6b6974 	svccs	0x006b6974
 ab4:	2f766564 	svccs	0x00766564
 ab8:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 abc:	534f5452 	movtpl	r5, #62546	; 0xf452
 ac0:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 ac4:	2f726574 	svccs	0x00726574
 ac8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 acc:	2f736563 	svccs	0x00736563
 ad0:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 ad4:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 ad8:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 adc:	662f6564 	strtvs	r6, [pc], -r4, ror #10
 ae0:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 ae4:	2f656d6f 	svccs	0x00656d6f
 ae8:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
 aec:	642f6b69 	strtvs	r6, [pc], #-2921	; af4 <shift+0xaf4>
 af0:	4b2f7665 	blmi	bde48c <__bss_end+0xbd4d48>
 af4:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 af8:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
 afc:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
 b00:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
 b04:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 b08:	6b2f7365 	blvs	bdd8a4 <__bss_end+0xbd4160>
 b0c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 b10:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 b14:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 b18:	72642f65 	rsbvc	r2, r4, #404	; 0x194
 b1c:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
 b20:	72622f73 	rsbvc	r2, r2, #460	; 0x1cc
 b24:	65676469 	strbvs	r6, [r7, #-1129]!	; 0xfffffb97
 b28:	6f000073 	svcvs	0x00000073
 b2c:	2e64656c 	cdpcs	5, 6, cr6, cr4, cr12, {3}
 b30:	00707063 	rsbseq	r7, r0, r3, rrx
 b34:	69000001 	stmdbvs	r0, {r0}
 b38:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
 b3c:	00682e66 	rsbeq	r2, r8, r6, ror #28
 b40:	6f000002 	svcvs	0x00000002
 b44:	2e64656c 	cdpcs	5, 6, cr6, cr4, cr12, {3}
 b48:	00030068 	andeq	r0, r3, r8, rrx
 b4c:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 b50:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 b54:	70730000 	rsbsvc	r0, r3, r0
 b58:	6f6c6e69 	svcvs	0x006c6e69
 b5c:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 b60:	00000400 	andeq	r0, r0, r0, lsl #8
 b64:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 b68:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 b6c:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 b70:	00000500 	andeq	r0, r0, r0, lsl #10
 b74:	636f7270 	cmnvs	pc, #112, 4
 b78:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 b7c:	00040068 	andeq	r0, r4, r8, rrx
 b80:	6f727000 	svcvs	0x00727000
 b84:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 b88:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 b8c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 b90:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 b94:	69640000 	stmdbvs	r4!, {}^	; <UNPREDICTABLE>
 b98:	616c7073 	smcvs	50947	; 0xc703
 b9c:	72705f79 	rsbsvc	r5, r0, #484	; 0x1e4
 ba0:	636f746f 	cmnvs	pc, #1862270976	; 0x6f000000
 ba4:	682e6c6f 	stmdavs	lr!, {r0, r1, r2, r3, r5, r6, sl, fp, sp, lr}
 ba8:	00000600 	andeq	r0, r0, r0, lsl #12
 bac:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
 bb0:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
 bb4:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
 bb8:	00020068 	andeq	r0, r2, r8, rrx
 bbc:	656c6f00 	strbvs	r6, [ip, #-3840]!	; 0xfffff100
 bc0:	6f665f64 	svcvs	0x00665f64
 bc4:	682e746e 	stmdavs	lr!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
 bc8:	00000100 	andeq	r0, r0, r0, lsl #2
 bcc:	00010500 	andeq	r0, r1, r0, lsl #10
 bd0:	8c580205 	lfmhi	f0, 2, [r8], {5}
 bd4:	09030000 	stmdbeq	r3, {}	; <UNPREDICTABLE>
 bd8:	9f140501 	svcls	0x00140501
 bdc:	05824805 	streq	r4, [r2, #2053]	; 0x805
 be0:	1805a110 	stmdane	r5, {r4, r8, sp, pc}
 be4:	820d054a 	andhi	r0, sp, #310378496	; 0x12800000
 be8:	844b0105 	strbhi	r0, [fp], #-261	; 0xfffffefb
 bec:	05850905 	streq	r0, [r5, #2309]	; 0x905
 bf0:	11054a05 	tstne	r5, r5, lsl #20
 bf4:	670e054c 	strvs	r0, [lr, -ip, asr #10]
 bf8:	85840105 	strhi	r0, [r4, #261]	; 0x105
 bfc:	05830c05 	streq	r0, [r3, #3077]	; 0xc05
 c00:	05854b01 	streq	r4, [r5, #2817]	; 0xb01
 c04:	0905bb0a 	stmdbeq	r5, {r1, r3, r8, r9, fp, ip, sp, pc}
 c08:	4a05054a 	bmi	142138 <__bss_end+0x1389f4>
 c0c:	054e1105 	strbeq	r1, [lr, #-261]	; 0xfffffefb
 c10:	02004b0f 	andeq	r4, r0, #15360	; 0x3c00
 c14:	66060104 	strvs	r0, [r6], -r4, lsl #2
 c18:	02040200 	andeq	r0, r4, #0, 4
 c1c:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
 c20:	07052e04 	streq	r2, [r5, -r4, lsl #28]
 c24:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 c28:	09052f06 	stmdbeq	r5, {r1, r2, r8, r9, sl, fp, sp}
 c2c:	340105d1 	strcc	r0, [r1], #-1489	; 0xfffffa2f
 c30:	080a054d 	stmdaeq	sl, {r0, r2, r3, r6, r8, sl}
 c34:	4a090591 	bmi	242280 <__bss_end+0x238b3c>
 c38:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
 c3c:	0f054f14 	svceq	0x00054f14
 c40:	9f11054b 	svcls	0x0011054b
 c44:	f31305f3 	vqrshl.u16	q0, <illegal reg q9.5>, <illegal reg q9.5>
 c48:	01040200 	mrseq	r0, R12_usr
 c4c:	02006606 	andeq	r6, r0, #6291456	; 0x600000
 c50:	004a0204 	subeq	r0, sl, r4, lsl #4
 c54:	2e040402 	cdpcs	4, 0, cr0, cr4, cr2, {0}
 c58:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 c5c:	2f060404 	svccs	0x00060404
 c60:	77030905 	strvc	r0, [r3, -r5, lsl #18]
 c64:	030105d6 	movweq	r0, #5590	; 0x15d6
 c68:	054d2e0a 	strbeq	r2, [sp, #-3594]	; 0xfffff1f6
 c6c:	0591080a 	ldreq	r0, [r1, #2058]	; 0x80a
 c70:	05054a09 	streq	r4, [r5, #-2569]	; 0xfffff5f7
 c74:	28054e4a 	stmdacs	r5, {r1, r3, r6, r9, sl, fp, lr}
 c78:	01040200 	mrseq	r0, R12_usr
 c7c:	00230566 	eoreq	r0, r3, r6, ror #10
 c80:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
 c84:	054f1e05 	strbeq	r1, [pc, #-3589]	; fffffe87 <__bss_end+0xffff6743>
 c88:	0c054b15 			; <UNDEFINED> instruction: 0x0c054b15
 c8c:	0d05bb67 	vstreq	d11, [r5, #-412]	; 0xfffffe64
 c90:	052108bb 	streq	r0, [r1, #-2235]!	; 0xfffff745
 c94:	05210810 	streq	r0, [r1, #-2064]!	; 0xfffff7f0
 c98:	51056844 	tstpl	r5, r4, asr #16
 c9c:	2e40052e 	cdpcs	5, 4, cr0, cr0, cr14, {1}
 ca0:	059e0c05 	ldreq	r0, [lr, #3077]	; 0xc05
 ca4:	0b054a6c 	bleq	15365c <__bss_end+0x149f18>
 ca8:	680a054a 	stmdavs	sl, {r1, r3, r6, r8, sl}
 cac:	6e030905 	vmlavs.f16	s0, s6, s10	; <UNPREDICTABLE>
 cb0:	01054ed6 	ldrdeq	r4, [r5, -r6]
 cb4:	692e0f03 	stmdbvs	lr!, {r0, r1, r8, r9, sl, fp}
 cb8:	05830a05 	streq	r0, [r3, #2565]	; 0xa05
 cbc:	05054a09 	streq	r4, [r5, #-2569]	; 0xfffff5f7
 cc0:	4e14054a 	cfmac32mi	mvfx0, mvfx4, mvfx10
 cc4:	054c0a05 	strbeq	r0, [ip, #-2565]	; 0xfffff5fb
 cc8:	0105d109 	tsteq	r5, r9, lsl #2
 ccc:	0a054d34 	beq	1541a4 <__bss_end+0x14aa60>
 cd0:	09052108 	stmdbeq	r5, {r3, r8, sp}
 cd4:	4a05054a 	bmi	142204 <__bss_end+0x138ac0>
 cd8:	054d0e05 	strbeq	r0, [sp, #-3589]	; 0xfffff1fb
 cdc:	0c054b11 			; <UNDEFINED> instruction: 0x0c054b11
 ce0:	4a19054c 	bmi	642218 <__bss_end+0x638ad4>
 ce4:	02002005 	andeq	r2, r0, #5
 ce8:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 cec:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
 cf0:	11056601 	tstne	r5, r1, lsl #12
 cf4:	bb0c054c 	bllt	30222c <__bss_end+0x2f8ae8>
 cf8:	62050567 	andvs	r0, r5, #432013312	; 0x19c00000
 cfc:	05290905 	streq	r0, [r9, #-2309]!	; 0xfffff6fb
 d00:	2e0b0301 	cdpcs	3, 0, cr0, cr11, cr1, {0}
 d04:	01000402 	tsteq	r0, r2, lsl #8
 d08:	00007901 	andeq	r7, r0, r1, lsl #18
 d0c:	46000300 	strmi	r0, [r0], -r0, lsl #6
 d10:	02000000 	andeq	r0, r0, #0
 d14:	0d0efb01 	vstreq	d15, [lr, #-4]
 d18:	01010100 	mrseq	r0, (UNDEF: 17)
 d1c:	00000001 	andeq	r0, r0, r1
 d20:	01000001 	tsteq	r0, r1
 d24:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 d28:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 d2c:	2f2e2e2f 	svccs	0x002e2e2f
 d30:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 d34:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 d38:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 d3c:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
 d40:	2f676966 	svccs	0x00676966
 d44:	006d7261 	rsbeq	r7, sp, r1, ror #4
 d48:	62696c00 	rsbvs	r6, r9, #0, 24
 d4c:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
 d50:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
 d54:	00000100 	andeq	r0, r0, r0, lsl #2
 d58:	02050000 	andeq	r0, r5, #0
 d5c:	0000910c 	andeq	r9, r0, ip, lsl #2
 d60:	0108fd03 	tsteq	r8, r3, lsl #26	; <UNPREDICTABLE>
 d64:	2f2f2f30 	svccs	0x002f2f30
 d68:	02302f2f 	eorseq	r2, r0, #47, 30	; 0xbc
 d6c:	2f1401d0 	svccs	0x001401d0
 d70:	302f2f31 	eorcc	r2, pc, r1, lsr pc	; <UNPREDICTABLE>
 d74:	03322f4c 	teqeq	r2, #76, 30	; 0x130
 d78:	2f2f661f 	svccs	0x002f661f
 d7c:	2f2f2f2f 	svccs	0x002f2f2f
 d80:	0002022f 	andeq	r0, r2, pc, lsr #4
 d84:	005c0101 	subseq	r0, ip, r1, lsl #2
 d88:	00030000 	andeq	r0, r3, r0
 d8c:	00000046 	andeq	r0, r0, r6, asr #32
 d90:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 d94:	0101000d 	tsteq	r1, sp
 d98:	00000101 	andeq	r0, r0, r1, lsl #2
 d9c:	00000100 	andeq	r0, r0, r0, lsl #2
 da0:	2f2e2e01 	svccs	0x002e2e01
 da4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 da8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 dac:	2f2e2e2f 	svccs	0x002e2e2f
 db0:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; d00 <shift+0xd00>
 db4:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 db8:	6f632f63 	svcvs	0x00632f63
 dbc:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 dc0:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 dc4:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 dc8:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
 dcc:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
 dd0:	00010053 	andeq	r0, r1, r3, asr r0
 dd4:	05000000 	streq	r0, [r0, #-0]
 dd8:	00931802 	addseq	r1, r3, r2, lsl #16
 ddc:	0be70300 	bleq	ff9c19e4 <__bss_end+0xff9b82a0>
 de0:	00020201 	andeq	r0, r2, r1, lsl #4
 de4:	01030101 	tsteq	r3, r1, lsl #2
 de8:	00030000 	andeq	r0, r3, r0
 dec:	000000fd 	strdeq	r0, [r0], -sp
 df0:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 df4:	0101000d 	tsteq	r1, sp
 df8:	00000101 	andeq	r0, r0, r1, lsl #2
 dfc:	00000100 	andeq	r0, r0, r0, lsl #2
 e00:	2f2e2e01 	svccs	0x002e2e01
 e04:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 e08:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 e0c:	2f2e2e2f 	svccs	0x002e2e2f
 e10:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; d60 <shift+0xd60>
 e14:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 e18:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
 e1c:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 e20:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 e24:	2f2e2e00 	svccs	0x002e2e00
 e28:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 e2c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 e30:	2f2e2e2f 	svccs	0x002e2e2f
 e34:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
 e38:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
 e3c:	2f2e2e2f 	svccs	0x002e2e2f
 e40:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 e44:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 e48:	2f2e2e2f 	svccs	0x002e2e2f
 e4c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 e50:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
 e54:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
 e58:	6f632f63 	svcvs	0x00632f63
 e5c:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 e60:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 e64:	2f2e2e00 	svccs	0x002e2e00
 e68:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 e6c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 e70:	2f2e2e2f 	svccs	0x002e2e2f
 e74:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; dc4 <shift+0xdc4>
 e78:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 e7c:	68000063 	stmdavs	r0, {r0, r1, r5, r6}
 e80:	74687361 	strbtvc	r7, [r8], #-865	; 0xfffffc9f
 e84:	682e6261 	stmdavs	lr!, {r0, r5, r6, r9, sp, lr}
 e88:	00000100 	andeq	r0, r0, r0, lsl #2
 e8c:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 e90:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
 e94:	00020068 	andeq	r0, r2, r8, rrx
 e98:	6d726100 	ldfvse	f6, [r2, #-0]
 e9c:	7570632d 	ldrbvc	r6, [r0, #-813]!	; 0xfffffcd3
 ea0:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 ea4:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 ea8:	632d6e73 			; <UNDEFINED> instruction: 0x632d6e73
 eac:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
 eb0:	73746e61 	cmnvc	r4, #1552	; 0x610
 eb4:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 eb8:	72610000 	rsbvc	r0, r1, #0
 ebc:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 ec0:	6c000003 	stcvs	0, cr0, [r0], {3}
 ec4:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 ec8:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
 ecc:	00000400 	andeq	r0, r0, r0, lsl #8
 ed0:	2d6c6267 	sfmcs	f6, 2, [ip, #-412]!	; 0xfffffe64
 ed4:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
 ed8:	00682e73 	rsbeq	r2, r8, r3, ror lr
 edc:	6c000004 	stcvs	0, cr0, [r0], {4}
 ee0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 ee4:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
 ee8:	00000400 	andeq	r0, r0, r0, lsl #8
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
      58:	1fd60704 	svcne	0x00d60704
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
      b0:	0b010000 	bleq	400b8 <__bss_end+0x36974>
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
     11c:	1fd60704 	svcne	0x00d60704
     120:	7a080000 	bvc	200128 <__bss_end+0x1f69e4>
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
     15c:	3a010000 	bcc	40164 <__bss_end+0x36a20>
     160:	00007615 	andeq	r7, r0, r5, lsl r6
     164:	01dc0900 	bicseq	r0, ip, r0, lsl #18
     168:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
     16c:	0000cb10 	andeq	ip, r0, r0, lsl fp
     170:	0081dc00 	addeq	sp, r1, r0, lsl #24
     174:	00005800 	andeq	r5, r0, r0, lsl #16
     178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f6e3c>
     17c:	0a000000 	beq	184 <shift+0x184>
     180:	000001ea 	andeq	r0, r0, sl, ror #3
     184:	d20c4a01 	andle	r4, ip, #4096	; 0x1000
     188:	02000000 	andeq	r0, r0, #0
     18c:	0b007491 	bleq	1d3d8 <__bss_end+0x13c94>
     190:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     194:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
     198:	00000038 	andeq	r0, r0, r8, lsr r0
     19c:	00036d09 	andeq	r6, r3, r9, lsl #26
     1a0:	103c0100 	eorsne	r0, ip, r0, lsl #2
     1a4:	000000cb 	andeq	r0, r0, fp, asr #1
     1a8:	00008184 	andeq	r8, r0, r4, lsl #3
     1ac:	00000058 	andeq	r0, r0, r8, asr r0
     1b0:	01029c01 	tsteq	r2, r1, lsl #24
     1b4:	ea0a0000 	b	2801bc <__bss_end+0x276a78>
     1b8:	01000001 	tsteq	r0, r1
     1bc:	01020c3e 	tsteq	r2, lr, lsr ip
     1c0:	91020000 	mrsls	r0, (UNDEF: 2)
     1c4:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
     1c8:	00000025 	andeq	r0, r0, r5, lsr #32
     1cc:	0001c50c 	andeq	ip, r1, ip, lsl #10
     1d0:	11290100 			; <UNDEFINED> instruction: 0x11290100
     1d4:	00008178 	andeq	r8, r0, r8, ror r1
     1d8:	0000000c 	andeq	r0, r0, ip
     1dc:	fb0c9c01 	blx	3271ea <__bss_end+0x31daa6>
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
     254:	cb110a01 	blgt	442a60 <__bss_end+0x43931c>
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
     2bc:	0a010067 	beq	40460 <__bss_end+0x36d1c>
     2c0:	00019e2f 	andeq	r9, r1, pc, lsr #28
     2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     2c8:	0f560000 	svceq	0x00560000
     2cc:	00040000 	andeq	r0, r4, r0
     2d0:	000001c6 	andeq	r0, r0, r6, asr #3
     2d4:	02650104 	rsbeq	r0, r5, #4, 2
     2d8:	7b040000 	blvc	1002e0 <__bss_end+0xf6b9c>
     2dc:	3a00000e 	bcc	31c <shift+0x31c>
     2e0:	34000000 	strcc	r0, [r0], #-0
     2e4:	0c000082 	stceq	0, cr0, [r0], {130}	; 0x82
     2e8:	ff000001 			; <UNDEFINED> instruction: 0xff000001
     2ec:	02000001 	andeq	r0, r0, #1
     2f0:	11090801 	tstne	r9, r1, lsl #16
     2f4:	25030000 	strcs	r0, [r3, #-0]
     2f8:	02000000 	andeq	r0, r0, #0
     2fc:	0e4a0502 	cdpeq	5, 4, cr0, cr10, cr2, {0}
     300:	04040000 	streq	r0, [r4], #-0
     304:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     308:	08010200 	stmdaeq	r1, {r9}
     30c:	00001100 	andeq	r1, r0, r0, lsl #2
     310:	000d9305 	andeq	r9, sp, r5, lsl #6
     314:	20080200 	andcs	r0, r8, r0, lsl #4
     318:	00000052 	andeq	r0, r0, r2, asr r0
     31c:	bb070202 	bllt	1c0b2c <__bss_end+0x1b73e8>
     320:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
     324:	0000073b 	andeq	r0, r0, fp, lsr r7
     328:	6a1e0902 	bvs	782738 <__bss_end+0x778ff4>
     32c:	03000000 	movweq	r0, #0
     330:	00000059 	andeq	r0, r0, r9, asr r0
     334:	d6070402 	strle	r0, [r7], -r2, lsl #8
     338:	0300001f 	movweq	r0, #31
     33c:	0000006a 	andeq	r0, r0, sl, rrx
     340:	00006a06 	andeq	r6, r0, r6, lsl #20
     344:	13b20700 			; <UNDEFINED> instruction: 0x13b20700
     348:	03080000 	movweq	r0, #32768	; 0x8000
     34c:	00a10806 	adceq	r0, r1, r6, lsl #16
     350:	72080000 	andvc	r0, r8, #0
     354:	08030030 	stmdaeq	r3, {r4, r5}
     358:	0000590e 	andeq	r5, r0, lr, lsl #18
     35c:	72080000 	andvc	r0, r8, #0
     360:	09030031 	stmdbeq	r3, {r0, r4, r5}
     364:	0000590e 	andeq	r5, r0, lr, lsl #18
     368:	09000400 	stmdbeq	r0, {sl}
     36c:	00000f3e 	andeq	r0, r0, lr, lsr pc
     370:	00380405 	eorseq	r0, r8, r5, lsl #8
     374:	1e030000 	cdpne	0, 0, cr0, cr3, cr0, {0}
     378:	0000d80c 	andeq	sp, r0, ip, lsl #16
     37c:	07330a00 	ldreq	r0, [r3, -r0, lsl #20]!
     380:	0a000000 	beq	388 <shift+0x388>
     384:	0000097a 	andeq	r0, r0, sl, ror r9
     388:	0f600a01 	svceq	0x00600a01
     38c:	0a020000 	beq	80394 <__bss_end+0x76c50>
     390:	0000111c 	andeq	r1, r0, ip, lsl r1
     394:	09580a03 	ldmdbeq	r8, {r0, r1, r9, fp}^
     398:	0a040000 	beq	1003a0 <__bss_end+0xf6c5c>
     39c:	00000e3a 	andeq	r0, r0, sl, lsr lr
     3a0:	26090005 	strcs	r0, [r9], -r5
     3a4:	0500000f 	streq	r0, [r0, #-15]
     3a8:	00003804 	andeq	r3, r0, r4, lsl #16
     3ac:	0c3f0300 	ldceq	3, cr0, [pc], #-0	; 3b4 <shift+0x3b4>
     3b0:	00000115 	andeq	r0, r0, r5, lsl r1
     3b4:	00089c0a 	andeq	r9, r8, sl, lsl #24
     3b8:	5a0a0000 	bpl	2803c0 <__bss_end+0x276c7c>
     3bc:	01000010 	tsteq	r0, r0, lsl r0
     3c0:	00134b0a 	andseq	r4, r3, sl, lsl #22
     3c4:	160a0200 	strne	r0, [sl], -r0, lsl #4
     3c8:	0300000d 	movweq	r0, #13
     3cc:	00096c0a 	andeq	r6, r9, sl, lsl #24
     3d0:	920a0400 	andls	r0, sl, #0, 8
     3d4:	0500000a 	streq	r0, [r0, #-10]
     3d8:	0007b30a 	andeq	fp, r7, sl, lsl #6
     3dc:	05000600 	streq	r0, [r0, #-1536]	; 0xfffffa00
     3e0:	00000e01 	andeq	r0, r0, r1, lsl #28
     3e4:	38170304 	ldmdacc	r7, {r2, r8, r9}
     3e8:	0b000000 	bleq	3f0 <shift+0x3f0>
     3ec:	00000c87 	andeq	r0, r0, r7, lsl #25
     3f0:	65140504 	ldrvs	r0, [r4, #-1284]	; 0xfffffafc
     3f4:	05000000 	streq	r0, [r0, #-0]
     3f8:	00931c03 	addseq	r1, r3, r3, lsl #24
     3fc:	105f0b00 	subsne	r0, pc, r0, lsl #22
     400:	06040000 	streq	r0, [r4], -r0
     404:	00006514 	andeq	r6, r0, r4, lsl r5
     408:	20030500 	andcs	r0, r3, r0, lsl #10
     40c:	0b000093 	bleq	660 <shift+0x660>
     410:	00000afd 	strdeq	r0, [r0], -sp
     414:	651a0705 	ldrvs	r0, [sl, #-1797]	; 0xfffff8fb
     418:	05000000 	streq	r0, [r0, #-0]
     41c:	00932403 	addseq	r2, r3, r3, lsl #8
     420:	0e630b00 	vmuleq.f64	d16, d3, d0
     424:	09050000 	stmdbeq	r5, {}	; <UNPREDICTABLE>
     428:	0000651a 	andeq	r6, r0, sl, lsl r5
     42c:	28030500 	stmdacs	r3, {r8, sl}
     430:	0b000093 	bleq	684 <shift+0x684>
     434:	00000ac0 	andeq	r0, r0, r0, asr #21
     438:	651a0b05 	ldrvs	r0, [sl, #-2821]	; 0xfffff4fb
     43c:	05000000 	streq	r0, [r0, #-0]
     440:	00932c03 	addseq	r2, r3, r3, lsl #24
     444:	0dee0b00 			; <UNDEFINED> instruction: 0x0dee0b00
     448:	0d050000 	stceq	0, cr0, [r5, #-0]
     44c:	0000651a 	andeq	r6, r0, sl, lsl r5
     450:	30030500 	andcc	r0, r3, r0, lsl #10
     454:	0b000093 	bleq	6a8 <shift+0x6a8>
     458:	00000713 	andeq	r0, r0, r3, lsl r7
     45c:	651a0f05 	ldrvs	r0, [sl, #-3845]	; 0xfffff0fb
     460:	05000000 	streq	r0, [r0, #-0]
     464:	00933403 	addseq	r3, r3, r3, lsl #8
     468:	0cfc0900 			; <UNDEFINED> instruction: 0x0cfc0900
     46c:	04050000 	streq	r0, [r5], #-0
     470:	00000038 	andeq	r0, r0, r8, lsr r0
     474:	c40c1b05 	strgt	r1, [ip], #-2821	; 0xfffff4fb
     478:	0a000001 	beq	484 <shift+0x484>
     47c:	0000069f 	muleq	r0, pc, r6	; <UNPREDICTABLE>
     480:	11880a00 	orrne	r0, r8, r0, lsl #20
     484:	0a010000 	beq	4048c <__bss_end+0x36d48>
     488:	00001346 	andeq	r1, r0, r6, asr #6
     48c:	610c0002 	tstvs	ip, r2
     490:	0d000004 	stceq	0, cr0, [r0, #-16]
     494:	00000529 	andeq	r0, r0, r9, lsr #10
     498:	07630590 			; <UNDEFINED> instruction: 0x07630590
     49c:	00000337 	andeq	r0, r0, r7, lsr r3
     4a0:	00067b07 	andeq	r7, r6, r7, lsl #22
     4a4:	67052400 	strvs	r2, [r5, -r0, lsl #8]
     4a8:	00025110 	andeq	r5, r2, r0, lsl r1
     4ac:	23be0e00 			; <UNDEFINED> instruction: 0x23be0e00
     4b0:	69050000 	stmdbvs	r5, {}	; <UNPREDICTABLE>
     4b4:	00033728 	andeq	r3, r3, r8, lsr #14
     4b8:	a10e0000 	mrsge	r0, (UNDEF: 14)
     4bc:	05000008 	streq	r0, [r0, #-8]
     4c0:	0347206b 	movteq	r2, #28779	; 0x706b
     4c4:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
     4c8:	00000694 	muleq	r0, r4, r6
     4cc:	59236d05 	stmdbpl	r3!, {r0, r2, r8, sl, fp, sp, lr}
     4d0:	14000000 	strne	r0, [r0], #-0
     4d4:	000e430e 	andeq	r4, lr, lr, lsl #6
     4d8:	1c700500 	cfldr64ne	mvdx0, [r0], #-0
     4dc:	0000034e 	andeq	r0, r0, lr, asr #6
     4e0:	13030e18 	movwne	r0, #15896	; 0x3e18
     4e4:	72050000 	andvc	r0, r5, #0
     4e8:	00034e1c 	andeq	r4, r3, ip, lsl lr
     4ec:	240e1c00 	strcs	r1, [lr], #-3072	; 0xfffff400
     4f0:	05000005 	streq	r0, [r0, #-5]
     4f4:	034e1c75 	movteq	r1, #60533	; 0xec75
     4f8:	0f200000 	svceq	0x00200000
     4fc:	00000f15 	andeq	r0, r0, r5, lsl pc
     500:	461c7705 	ldrmi	r7, [ip], -r5, lsl #14
     504:	4e000012 	mcrmi	0, 0, r0, cr0, cr2, {0}
     508:	45000003 	strmi	r0, [r0, #-3]
     50c:	10000002 	andne	r0, r0, r2
     510:	0000034e 	andeq	r0, r0, lr, asr #6
     514:	00035411 	andeq	r5, r3, r1, lsl r4
     518:	07000000 	streq	r0, [r0, -r0]
     51c:	0000133b 	andeq	r1, r0, fp, lsr r3
     520:	107b0518 	rsbsne	r0, fp, r8, lsl r5
     524:	00000286 	andeq	r0, r0, r6, lsl #5
     528:	0023be0e 	eoreq	fp, r3, lr, lsl #28
     52c:	2c7e0500 	cfldr64cs	mvdx0, [lr], #-0
     530:	00000337 	andeq	r0, r0, r7, lsr r3
     534:	05870e00 	streq	r0, [r7, #3584]	; 0xe00
     538:	80050000 	andhi	r0, r5, r0
     53c:	00035419 	andeq	r5, r3, r9, lsl r4
     540:	990e1000 	stmdbls	lr, {ip}
     544:	0500000a 	streq	r0, [r0, #-10]
     548:	035f2182 	cmpeq	pc, #-2147483616	; 0x80000020
     54c:	00140000 	andseq	r0, r4, r0
     550:	00025103 	andeq	r5, r2, r3, lsl #2
     554:	04d71200 	ldrbeq	r1, [r7], #512	; 0x200
     558:	86050000 	strhi	r0, [r5], -r0
     55c:	00036521 	andeq	r6, r3, r1, lsr #10
     560:	08cb1200 	stmiaeq	fp, {r9, ip}^
     564:	88050000 	stmdahi	r5, {}	; <UNPREDICTABLE>
     568:	0000651f 	andeq	r6, r0, pc, lsl r5
     56c:	0e750e00 	cdpeq	14, 7, cr0, cr5, cr0, {0}
     570:	8b050000 	blhi	140578 <__bss_end+0x136e34>
     574:	0001d617 	andeq	sp, r1, r7, lsl r6
     578:	030e0000 	movweq	r0, #57344	; 0xe000
     57c:	05000008 	streq	r0, [r0, #-8]
     580:	01d6178e 	bicseq	r1, r6, lr, lsl #15
     584:	0e240000 	cdpeq	0, 2, cr0, cr4, cr0, {0}
     588:	00000c0b 	andeq	r0, r0, fp, lsl #24
     58c:	d6178f05 	ldrle	r8, [r7], -r5, lsl #30
     590:	48000001 	stmdami	r0, {r0}
     594:	0009f40e 	andeq	pc, r9, lr, lsl #8
     598:	17900500 	ldrne	r0, [r0, r0, lsl #10]
     59c:	000001d6 	ldrdeq	r0, [r0], -r6
     5a0:	0529136c 	streq	r1, [r9, #-876]!	; 0xfffffc94
     5a4:	93050000 	movwls	r0, #20480	; 0x5000
     5a8:	000db109 	andeq	fp, sp, r9, lsl #2
     5ac:	00037000 	andeq	r7, r3, r0
     5b0:	02f00100 	rscseq	r0, r0, #0, 2
     5b4:	02f60000 	rscseq	r0, r6, #0
     5b8:	70100000 	andsvc	r0, r0, r0
     5bc:	00000003 	andeq	r0, r0, r3
     5c0:	000f0a14 	andeq	r0, pc, r4, lsl sl	; <UNPREDICTABLE>
     5c4:	0e960500 	cdpeq	5, 9, cr0, cr6, cr0, {0}
     5c8:	00000568 	andeq	r0, r0, r8, ror #10
     5cc:	00030b01 	andeq	r0, r3, r1, lsl #22
     5d0:	00031100 	andeq	r1, r3, r0, lsl #2
     5d4:	03701000 	cmneq	r0, #0
     5d8:	15000000 	strne	r0, [r0, #-0]
     5dc:	0000089c 	muleq	r0, ip, r8
     5e0:	e1109905 	tst	r0, r5, lsl #18
     5e4:	7600000c 	strvc	r0, [r0], -ip
     5e8:	01000003 	tsteq	r0, r3
     5ec:	00000326 	andeq	r0, r0, r6, lsr #6
     5f0:	00037010 	andeq	r7, r3, r0, lsl r0
     5f4:	03541100 	cmpeq	r4, #0, 2
     5f8:	9f110000 	svcls	0x00110000
     5fc:	00000001 	andeq	r0, r0, r1
     600:	00251600 	eoreq	r1, r5, r0, lsl #12
     604:	03470000 	movteq	r0, #28672	; 0x7000
     608:	6a170000 	bvs	5c0610 <__bss_end+0x5b6ecc>
     60c:	0f000000 	svceq	0x00000000
     610:	02010200 	andeq	r0, r1, #0, 4
     614:	00000ba6 	andeq	r0, r0, r6, lsr #23
     618:	01d60418 	bicseq	r0, r6, r8, lsl r4
     61c:	04180000 	ldreq	r0, [r8], #-0
     620:	0000002c 	andeq	r0, r0, ip, lsr #32
     624:	00121b0c 	andseq	r1, r2, ip, lsl #22
     628:	5a041800 	bpl	106630 <__bss_end+0xfceec>
     62c:	16000003 	strne	r0, [r0], -r3
     630:	00000286 	andeq	r0, r0, r6, lsl #5
     634:	00000370 	andeq	r0, r0, r0, ror r3
     638:	04180019 	ldreq	r0, [r8], #-25	; 0xffffffe7
     63c:	000001c9 	andeq	r0, r0, r9, asr #3
     640:	01c40418 	biceq	r0, r4, r8, lsl r4
     644:	fe1a0000 	cdp2	0, 1, cr0, cr10, cr0, {0}
     648:	0500000e 	streq	r0, [r0, #-14]
     64c:	01c9149c 			; <UNDEFINED> instruction: 0x01c9149c
     650:	a90b0000 	stmdbge	fp, {}	; <UNPREDICTABLE>
     654:	06000006 	streq	r0, [r0], -r6
     658:	00651404 	rsbeq	r1, r5, r4, lsl #8
     65c:	03050000 	movweq	r0, #20480	; 0x5000
     660:	00009338 	andeq	r9, r0, r8, lsr r3
     664:	000f660b 	andeq	r6, pc, fp, lsl #12
     668:	14070600 	strne	r0, [r7], #-1536	; 0xfffffa00
     66c:	00000065 	andeq	r0, r0, r5, rrx
     670:	933c0305 	teqls	ip, #335544320	; 0x14000000
     674:	550b0000 	strpl	r0, [fp, #-0]
     678:	06000005 	streq	r0, [r0], -r5
     67c:	0065140a 	rsbeq	r1, r5, sl, lsl #8
     680:	03050000 	movweq	r0, #20480	; 0x5000
     684:	00009340 	andeq	r9, r0, r0, asr #6
     688:	0007b809 	andeq	fp, r7, r9, lsl #16
     68c:	38040500 	stmdacc	r4, {r8, sl}
     690:	06000000 	streq	r0, [r0], -r0
     694:	03f50c0d 	mvnseq	r0, #3328	; 0xd00
     698:	4e1b0000 	cdpmi	0, 1, cr0, cr11, cr0, {0}
     69c:	00007765 	andeq	r7, r0, r5, ror #14
     6a0:	0009840a 	andeq	r8, r9, sl, lsl #8
     6a4:	4d0a0100 	stfmis	f0, [sl, #-0]
     6a8:	02000005 	andeq	r0, r0, #5
     6ac:	0007d10a 	andeq	sp, r7, sl, lsl #2
     6b0:	0e0a0300 	cdpeq	3, 0, cr0, cr10, cr0, {0}
     6b4:	04000011 	streq	r0, [r0], #-17	; 0xffffffef
     6b8:	00051d0a 	andeq	r1, r5, sl, lsl #26
     6bc:	07000500 	streq	r0, [r0, -r0, lsl #10]
     6c0:	000006c2 	andeq	r0, r0, r2, asr #13
     6c4:	081b0610 	ldmdaeq	fp, {r4, r9, sl}
     6c8:	00000434 	andeq	r0, r0, r4, lsr r4
     6cc:	00726c08 	rsbseq	r6, r2, r8, lsl #24
     6d0:	34131d06 	ldrcc	r1, [r3], #-3334	; 0xfffff2fa
     6d4:	00000004 	andeq	r0, r0, r4
     6d8:	00707308 	rsbseq	r7, r0, r8, lsl #6
     6dc:	34131e06 	ldrcc	r1, [r3], #-3590	; 0xfffff1fa
     6e0:	04000004 	streq	r0, [r0], #-4
     6e4:	00637008 	rsbeq	r7, r3, r8
     6e8:	34131f06 	ldrcc	r1, [r3], #-3846	; 0xfffff0fa
     6ec:	08000004 	stmdaeq	r0, {r2}
     6f0:	000f200e 	andeq	r2, pc, lr
     6f4:	13200600 	nopne	{0}	; <UNPREDICTABLE>
     6f8:	00000434 	andeq	r0, r0, r4, lsr r4
     6fc:	0402000c 	streq	r0, [r2], #-12
     700:	001fd107 	andseq	sp, pc, r7, lsl #2
     704:	04340300 	ldrteq	r0, [r4], #-768	; 0xfffffd00
     708:	4b070000 	blmi	1c0710 <__bss_end+0x1b6fcc>
     70c:	70000009 	andvc	r0, r0, r9
     710:	d0082806 	andle	r2, r8, r6, lsl #16
     714:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
     718:	0000084b 	andeq	r0, r0, fp, asr #16
     71c:	f5122a06 			; <UNDEFINED> instruction: 0xf5122a06
     720:	00000003 	andeq	r0, r0, r3
     724:	64697008 	strbtvs	r7, [r9], #-8
     728:	122b0600 	eorne	r0, fp, #0, 12
     72c:	0000006a 	andeq	r0, r0, sl, rrx
     730:	1daf0e10 	stcne	14, cr0, [pc, #64]!	; 778 <shift+0x778>
     734:	2c060000 	stccs	0, cr0, [r6], {-0}
     738:	0003be11 	andeq	fp, r3, r1, lsl lr
     73c:	f20e1400 	vshl.s8	d1, d0, d14
     740:	06000010 			; <UNDEFINED> instruction: 0x06000010
     744:	006a122d 	rsbeq	r1, sl, sp, lsr #4
     748:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
     74c:	000003f1 	strdeq	r0, [r0], -r1
     750:	6a122e06 	bvs	48bf70 <__bss_end+0x48282c>
     754:	1c000000 	stcne	0, cr0, [r0], {-0}
     758:	000f530e 	andeq	r5, pc, lr, lsl #6
     75c:	312f0600 			; <UNDEFINED> instruction: 0x312f0600
     760:	000004d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     764:	04cd0e20 	strbeq	r0, [sp], #3616	; 0xe20
     768:	30060000 	andcc	r0, r6, r0
     76c:	00003809 	andeq	r3, r0, r9, lsl #16
     770:	650e6000 	strvs	r6, [lr, #-0]
     774:	0600000b 	streq	r0, [r0], -fp
     778:	00590e31 	subseq	r0, r9, r1, lsr lr
     77c:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
     780:	00000d8a 	andeq	r0, r0, sl, lsl #27
     784:	590e3306 	stmdbpl	lr, {r1, r2, r8, r9, ip, sp}
     788:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
     78c:	000d810e 	andeq	r8, sp, lr, lsl #2
     790:	0e340600 	cfmsuba32eq	mvax0, mvax0, mvfx4, mvfx0
     794:	00000059 	andeq	r0, r0, r9, asr r0
     798:	7616006c 	ldrvc	r0, [r6], -ip, rrx
     79c:	e0000003 	and	r0, r0, r3
     7a0:	17000004 	strne	r0, [r0, -r4]
     7a4:	0000006a 	andeq	r0, r0, sl, rrx
     7a8:	350b000f 	strcc	r0, [fp, #-15]
     7ac:	07000005 	streq	r0, [r0, -r5]
     7b0:	0065140a 	rsbeq	r1, r5, sl, lsl #8
     7b4:	03050000 	movweq	r0, #20480	; 0x5000
     7b8:	00009344 	andeq	r9, r0, r4, asr #6
     7bc:	000b5009 	andeq	r5, fp, r9
     7c0:	38040500 	stmdacc	r4, {r8, sl}
     7c4:	07000000 	streq	r0, [r0, -r0]
     7c8:	05110c0d 	ldreq	r0, [r1, #-3085]	; 0xfffff3f3
     7cc:	510a0000 	mrspl	r0, (UNDEF: 10)
     7d0:	00000013 	andeq	r0, r0, r3, lsl r0
     7d4:	0011bd0a 	andseq	fp, r1, sl, lsl #26
     7d8:	07000100 	streq	r0, [r0, -r0, lsl #2]
     7dc:	00000830 	andeq	r0, r0, r0, lsr r8
     7e0:	081b070c 	ldmdaeq	fp, {r2, r3, r8, r9, sl}
     7e4:	00000546 	andeq	r0, r0, r6, asr #10
     7e8:	0005db0e 	andeq	sp, r5, lr, lsl #22
     7ec:	191d0700 	ldmdbne	sp, {r8, r9, sl}
     7f0:	00000546 	andeq	r0, r0, r6, asr #10
     7f4:	05240e00 	streq	r0, [r4, #-3584]!	; 0xfffff200
     7f8:	1e070000 	cdpne	0, 0, cr0, cr7, cr0, {0}
     7fc:	00054619 	andeq	r4, r5, r9, lsl r6
     800:	800e0400 	andhi	r0, lr, r0, lsl #8
     804:	0700000b 	streq	r0, [r0, -fp]
     808:	054c131f 	strbeq	r1, [ip, #-799]	; 0xfffffce1
     80c:	00080000 	andeq	r0, r8, r0
     810:	05110418 	ldreq	r0, [r1, #-1048]	; 0xfffffbe8
     814:	04180000 	ldreq	r0, [r8], #-0
     818:	00000440 	andeq	r0, r0, r0, asr #8
     81c:	000ec10d 	andeq	ip, lr, sp, lsl #2
     820:	22071400 	andcs	r1, r7, #0, 8
     824:	0007d407 	andeq	sp, r7, r7, lsl #8
     828:	0c950e00 	ldceq	14, cr0, [r5], {0}
     82c:	26070000 	strcs	r0, [r7], -r0
     830:	00005912 	andeq	r5, r0, r2, lsl r9
     834:	280e0000 	stmdacs	lr, {}	; <UNPREDICTABLE>
     838:	0700000c 	streq	r0, [r0, -ip]
     83c:	05461d29 	strbeq	r1, [r6, #-3369]	; 0xfffff2d7
     840:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     844:	000007d9 	ldrdeq	r0, [r0], -r9
     848:	461d2c07 	ldrmi	r2, [sp], -r7, lsl #24
     84c:	08000005 	stmdaeq	r0, {r0, r2}
     850:	000d0c1c 	andeq	r0, sp, ip, lsl ip
     854:	0e2f0700 	cdpeq	7, 2, cr0, cr15, cr0, {0}
     858:	0000080d 	andeq	r0, r0, sp, lsl #16
     85c:	0000059a 	muleq	r0, sl, r5
     860:	000005a5 	andeq	r0, r0, r5, lsr #11
     864:	0007d910 	andeq	sp, r7, r0, lsl r9
     868:	05461100 	strbeq	r1, [r6, #-256]	; 0xffffff00
     86c:	1d000000 	stcne	0, cr0, [r0, #-0]
     870:	0000098d 	andeq	r0, r0, sp, lsl #19
     874:	220e3107 	andcs	r3, lr, #-1073741823	; 0xc0000001
     878:	47000009 	strmi	r0, [r0, -r9]
     87c:	bd000003 	stclt	0, cr0, [r0, #-12]
     880:	c8000005 	stmdagt	r0, {r0, r2}
     884:	10000005 	andne	r0, r0, r5
     888:	000007d9 	ldrdeq	r0, [r0], -r9
     88c:	00054c11 	andeq	r4, r5, r1, lsl ip
     890:	69130000 	ldmdbvs	r3, {}	; <UNPREDICTABLE>
     894:	07000011 	smladeq	r0, r1, r0, r0
     898:	0b2b1d35 	bleq	ac7d74 <__bss_end+0xabe630>
     89c:	05460000 	strbeq	r0, [r6, #-0]
     8a0:	e1020000 	mrs	r0, (UNDEF: 2)
     8a4:	e7000005 	str	r0, [r0, -r5]
     8a8:	10000005 	andne	r0, r0, r5
     8ac:	000007d9 	ldrdeq	r0, [r0], -r9
     8b0:	07c41300 	strbeq	r1, [r4, r0, lsl #6]
     8b4:	37070000 	strcc	r0, [r7, -r0]
     8b8:	000d1c1d 	andeq	r1, sp, sp, lsl ip
     8bc:	00054600 	andeq	r4, r5, r0, lsl #12
     8c0:	06000200 	streq	r0, [r0], -r0, lsl #4
     8c4:	06060000 	streq	r0, [r6], -r0
     8c8:	d9100000 	ldmdble	r0, {}	; <UNPREDICTABLE>
     8cc:	00000007 	andeq	r0, r0, r7
     8d0:	000c3b1e 	andeq	r3, ip, lr, lsl fp
     8d4:	44390700 	ldrtmi	r0, [r9], #-1792	; 0xfffff900
     8d8:	000007f2 	strdeq	r0, [r0], -r2
     8dc:	c113020c 	tstgt	r3, ip, lsl #4
     8e0:	0700000e 	streq	r0, [r0, -lr]
     8e4:	099c093c 	ldmibeq	ip, {r2, r3, r4, r5, r8, fp}
     8e8:	07d90000 	ldrbeq	r0, [r9, r0]
     8ec:	2d010000 	stccs	0, cr0, [r1, #-0]
     8f0:	33000006 	movwcc	r0, #6
     8f4:	10000006 	andne	r0, r0, r6
     8f8:	000007d9 	ldrdeq	r0, [r0], -r9
     8fc:	085d1300 	ldmdaeq	sp, {r8, r9, ip}^
     900:	3f070000 	svccc	0x00070000
     904:	0005b012 	andeq	fp, r5, r2, lsl r0
     908:	00005900 	andeq	r5, r0, r0, lsl #18
     90c:	064c0100 	strbeq	r0, [ip], -r0, lsl #2
     910:	06610000 	strbteq	r0, [r1], -r0
     914:	d9100000 	ldmdble	r0, {}	; <UNPREDICTABLE>
     918:	11000007 	tstne	r0, r7
     91c:	000007fb 	strdeq	r0, [r0], -fp
     920:	00006a11 	andeq	r6, r0, r1, lsl sl
     924:	03471100 	movteq	r1, #28928	; 0x7100
     928:	14000000 	strne	r0, [r0], #-0
     92c:	00001193 	muleq	r0, r3, r1
     930:	cf0e4207 	svcgt	0x000e4207
     934:	01000006 	tsteq	r0, r6
     938:	00000676 	andeq	r0, r0, r6, ror r6
     93c:	0000067c 	andeq	r0, r0, ip, ror r6
     940:	0007d910 	andeq	sp, r7, r0, lsl r9
     944:	92130000 	andsls	r0, r3, #0
     948:	07000005 	streq	r0, [r0, -r5]
     94c:	064d1745 	strbeq	r1, [sp], -r5, asr #14
     950:	054c0000 	strbeq	r0, [ip, #-0]
     954:	95010000 	strls	r0, [r1, #-0]
     958:	9b000006 	blls	978 <shift+0x978>
     95c:	10000006 	andne	r0, r0, r6
     960:	00000801 	andeq	r0, r0, r1, lsl #16
     964:	0f711300 	svceq	0x00711300
     968:	48070000 	stmdami	r7, {}	; <UNPREDICTABLE>
     96c:	00040717 	andeq	r0, r4, r7, lsl r7
     970:	00054c00 	andeq	r4, r5, r0, lsl #24
     974:	06b40100 	ldrteq	r0, [r4], r0, lsl #2
     978:	06bf0000 	ldrteq	r0, [pc], r0
     97c:	01100000 	tsteq	r0, r0
     980:	11000008 	tstne	r0, r8
     984:	00000059 	andeq	r0, r0, r9, asr r0
     988:	071d1400 	ldreq	r1, [sp, -r0, lsl #8]
     98c:	4b070000 	blmi	1c0994 <__bss_end+0x1b7250>
     990:	000c490e 	andeq	r4, ip, lr, lsl #18
     994:	06d40100 	ldrbeq	r0, [r4], r0, lsl #2
     998:	06da0000 	ldrbeq	r0, [sl], r0
     99c:	d9100000 	ldmdble	r0, {}	; <UNPREDICTABLE>
     9a0:	00000007 	andeq	r0, r0, r7
     9a4:	00098d13 	andeq	r8, r9, r3, lsl sp
     9a8:	0e4d0700 	cdpeq	7, 4, cr0, cr13, cr0, {0}
     9ac:	00000dc6 	andeq	r0, r0, r6, asr #27
     9b0:	00000347 	andeq	r0, r0, r7, asr #6
     9b4:	0006f301 	andeq	pc, r6, r1, lsl #6
     9b8:	0006fe00 	andeq	pc, r6, r0, lsl #28
     9bc:	07d91000 	ldrbeq	r1, [r9, r0]
     9c0:	59110000 	ldmdbpl	r1, {}	; <UNPREDICTABLE>
     9c4:	00000000 	andeq	r0, r0, r0
     9c8:	00050913 	andeq	r0, r5, r3, lsl r9
     9cc:	12500700 	subsne	r0, r0, #0, 14
     9d0:	00000434 	andeq	r0, r0, r4, lsr r4
     9d4:	00000059 	andeq	r0, r0, r9, asr r0
     9d8:	00071701 	andeq	r1, r7, r1, lsl #14
     9dc:	00072200 	andeq	r2, r7, r0, lsl #4
     9e0:	07d91000 	ldrbeq	r1, [r9, r0]
     9e4:	76110000 	ldrvc	r0, [r1], -r0
     9e8:	00000003 	andeq	r0, r0, r3
     9ec:	00046713 	andeq	r6, r4, r3, lsl r7
     9f0:	0e530700 	cdpeq	7, 5, cr0, cr3, cr0, {0}
     9f4:	000011e9 	andeq	r1, r0, r9, ror #3
     9f8:	00000347 	andeq	r0, r0, r7, asr #6
     9fc:	00073b01 	andeq	r3, r7, r1, lsl #22
     a00:	00074600 	andeq	r4, r7, r0, lsl #12
     a04:	07d91000 	ldrbeq	r1, [r9, r0]
     a08:	59110000 	ldmdbpl	r1, {}	; <UNPREDICTABLE>
     a0c:	00000000 	andeq	r0, r0, r0
     a10:	0004e314 	andeq	lr, r4, r4, lsl r3
     a14:	0e560700 	cdpeq	7, 5, cr0, cr6, cr0, {0}
     a18:	0000106b 	andeq	r1, r0, fp, rrx
     a1c:	00075b01 	andeq	r5, r7, r1, lsl #22
     a20:	00077a00 	andeq	r7, r7, r0, lsl #20
     a24:	07d91000 	ldrbeq	r1, [r9, r0]
     a28:	a1110000 	tstge	r1, r0
     a2c:	11000000 	mrsne	r0, (UNDEF: 0)
     a30:	00000059 	andeq	r0, r0, r9, asr r0
     a34:	00005911 	andeq	r5, r0, r1, lsl r9
     a38:	00591100 	subseq	r1, r9, r0, lsl #2
     a3c:	07110000 	ldreq	r0, [r1, -r0]
     a40:	00000008 	andeq	r0, r0, r8
     a44:	00127614 	andseq	r7, r2, r4, lsl r6
     a48:	0e580700 	cdpeq	7, 5, cr0, cr8, cr0, {0}
     a4c:	00001366 	andeq	r1, r0, r6, ror #6
     a50:	00078f01 	andeq	r8, r7, r1, lsl #30
     a54:	0007ae00 	andeq	sl, r7, r0, lsl #28
     a58:	07d91000 	ldrbeq	r1, [r9, r0]
     a5c:	d8110000 	ldmdale	r1, {}	; <UNPREDICTABLE>
     a60:	11000000 	mrsne	r0, (UNDEF: 0)
     a64:	00000059 	andeq	r0, r0, r9, asr r0
     a68:	00005911 	andeq	r5, r0, r1, lsl r9
     a6c:	00591100 	subseq	r1, r9, r0, lsl #2
     a70:	07110000 	ldreq	r0, [r1, -r0]
     a74:	00000008 	andeq	r0, r0, r8
     a78:	0004f615 	andeq	pc, r4, r5, lsl r6	; <UNPREDICTABLE>
     a7c:	0e5b0700 	cdpeq	7, 5, cr0, cr11, cr0, {0}
     a80:	00000bab 	andeq	r0, r0, fp, lsr #23
     a84:	00000347 	andeq	r0, r0, r7, asr #6
     a88:	0007c301 	andeq	ip, r7, r1, lsl #6
     a8c:	07d91000 	ldrbeq	r1, [r9, r0]
     a90:	f2110000 	vhadd.s16	d0, d1, d0
     a94:	11000004 	tstne	r0, r4
     a98:	0000080d 	andeq	r0, r0, sp, lsl #16
     a9c:	52030000 	andpl	r0, r3, #0
     aa0:	18000005 	stmdane	r0, {r0, r2}
     aa4:	00055204 	andeq	r5, r5, r4, lsl #4
     aa8:	05461f00 	strbeq	r1, [r6, #-3840]	; 0xfffff100
     aac:	07ec0000 	strbeq	r0, [ip, r0]!
     ab0:	07f20000 	ldrbeq	r0, [r2, r0]!
     ab4:	d9100000 	ldmdble	r0, {}	; <UNPREDICTABLE>
     ab8:	00000007 	andeq	r0, r0, r7
     abc:	00055220 	andeq	r5, r5, r0, lsr #4
     ac0:	0007df00 	andeq	sp, r7, r0, lsl #30
     ac4:	3f041800 	svccc	0x00041800
     ac8:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     acc:	0007d404 	andeq	sp, r7, r4, lsl #8
     ad0:	7b042100 	blvc	108ed8 <__bss_end+0xff794>
     ad4:	22000000 	andcs	r0, r0, #0
     ad8:	12d81a04 	sbcsne	r1, r8, #4, 20	; 0x4000
     adc:	5e070000 	cdppl	0, 0, cr0, cr7, cr0, {0}
     ae0:	00055219 	andeq	r5, r5, r9, lsl r2
     ae4:	0e550d00 	cdpeq	13, 5, cr0, cr5, cr0, {0}
     ae8:	08080000 	stmdaeq	r8, {}	; <UNPREDICTABLE>
     aec:	095f0706 	ldmdbeq	pc, {r1, r2, r8, r9, sl}^	; <UNPREDICTABLE>
     af0:	720e0000 	andvc	r0, lr, #0
     af4:	08000009 	stmdaeq	r0, {r0, r3}
     af8:	0059120a 	subseq	r1, r9, sl, lsl #4
     afc:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     b00:	00000da9 	andeq	r0, r0, r9, lsr #27
     b04:	470e0c08 	strmi	r0, [lr, -r8, lsl #24]
     b08:	04000003 	streq	r0, [r0], #-3
     b0c:	000e5513 	andeq	r5, lr, r3, lsl r5
     b10:	09100800 	ldmdbeq	r0, {fp}
     b14:	000006f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     b18:	00000964 	andeq	r0, r0, r4, ror #18
     b1c:	00085b01 	andeq	r5, r8, r1, lsl #22
     b20:	00086600 	andeq	r6, r8, r0, lsl #12
     b24:	09641000 	stmdbeq	r4!, {ip}^
     b28:	54110000 	ldrpl	r0, [r1], #-0
     b2c:	00000003 	andeq	r0, r0, r3
     b30:	000e5413 	andeq	r5, lr, r3, lsl r4
     b34:	15120800 	ldrne	r0, [r2, #-2048]	; 0xfffff800
     b38:	00000e0c 	andeq	r0, r0, ip, lsl #28
     b3c:	0000080d 	andeq	r0, r0, sp, lsl #16
     b40:	00087f01 	andeq	r7, r8, r1, lsl #30
     b44:	00088a00 	andeq	r8, r8, r0, lsl #20
     b48:	09641000 	stmdbeq	r4!, {ip}^
     b4c:	38100000 	ldmdacc	r0, {}	; <UNPREDICTABLE>
     b50:	00000000 	andeq	r0, r0, r0
     b54:	00070913 	andeq	r0, r7, r3, lsl r9
     b58:	0e150800 	cdpeq	8, 1, cr0, cr5, cr0, {0}
     b5c:	00000a32 	andeq	r0, r0, r2, lsr sl
     b60:	00000347 	andeq	r0, r0, r7, asr #6
     b64:	0008a301 	andeq	sl, r8, r1, lsl #6
     b68:	0008a900 	andeq	sl, r8, r0, lsl #18
     b6c:	096a1000 	stmdbeq	sl!, {ip}^
     b70:	14000000 	strne	r0, [r0], #-0
     b74:	00000ff6 	strdeq	r0, [r0], -r6
     b78:	080e1808 	stmdaeq	lr, {r3, fp, ip}
     b7c:	01000009 	tsteq	r0, r9
     b80:	000008be 			; <UNDEFINED> instruction: 0x000008be
     b84:	000008c4 	andeq	r0, r0, r4, asr #17
     b88:	00096410 	andeq	r6, r9, r0, lsl r4
     b8c:	2c140000 	ldccs	0, cr0, [r4], {-0}
     b90:	0800000a 	stmdaeq	r0, {r1, r3}
     b94:	07850e1b 	usada8eq	r5, fp, lr, r0
     b98:	d9010000 	stmdble	r1, {}	; <UNPREDICTABLE>
     b9c:	e4000008 	str	r0, [r0], #-8
     ba0:	10000008 	andne	r0, r0, r8
     ba4:	00000964 	andeq	r0, r0, r4, ror #18
     ba8:	00034711 	andeq	r4, r3, r1, lsl r7
     bac:	e8140000 	ldmda	r4, {}	; <UNPREDICTABLE>
     bb0:	08000010 	stmdaeq	r0, {r4}
     bb4:	11c80e1d 	bicne	r0, r8, sp, lsl lr
     bb8:	f9010000 			; <UNDEFINED> instruction: 0xf9010000
     bbc:	0e000008 	cdpeq	0, 0, cr0, cr0, cr8, {0}
     bc0:	10000009 	andne	r0, r0, r9
     bc4:	00000964 	andeq	r0, r0, r4, ror #18
     bc8:	00004611 	andeq	r4, r0, r1, lsl r6
     bcc:	00461100 	subeq	r1, r6, r0, lsl #2
     bd0:	47110000 	ldrmi	r0, [r1, -r0]
     bd4:	00000003 	andeq	r0, r0, r3
     bd8:	0007aa14 	andeq	sl, r7, r4, lsl sl
     bdc:	0e1f0800 	cdpeq	8, 1, cr0, cr15, cr0, {0}
     be0:	000005e0 	andeq	r0, r0, r0, ror #11
     be4:	00092301 	andeq	r2, r9, r1, lsl #6
     be8:	00093800 	andeq	r3, r9, r0, lsl #16
     bec:	09641000 	stmdbeq	r4!, {ip}^
     bf0:	46110000 	ldrmi	r0, [r1], -r0
     bf4:	11000000 	mrsne	r0, (UNDEF: 0)
     bf8:	00000046 	andeq	r0, r0, r6, asr #32
     bfc:	00002511 	andeq	r2, r0, r1, lsl r5
     c00:	e4230000 	strt	r0, [r3], #-0
     c04:	08000012 	stmdaeq	r0, {r1, r4}
     c08:	0fa80e21 	svceq	0x00a80e21
     c0c:	49010000 	stmdbmi	r1, {}	; <UNPREDICTABLE>
     c10:	10000009 	andne	r0, r0, r9
     c14:	00000964 	andeq	r0, r0, r4, ror #18
     c18:	00004611 	andeq	r4, r0, r1, lsl r6
     c1c:	00461100 	subeq	r1, r6, r0, lsl #2
     c20:	54110000 	ldrpl	r0, [r1], #-0
     c24:	00000003 	andeq	r0, r0, r3
     c28:	081b0300 	ldmdaeq	fp, {r8, r9}
     c2c:	04180000 	ldreq	r0, [r8], #-0
     c30:	0000081b 	andeq	r0, r0, fp, lsl r8
     c34:	095f0418 	ldmdbeq	pc, {r3, r4, sl}^	; <UNPREDICTABLE>
     c38:	68240000 	stmdavs	r4!, {}	; <UNPREDICTABLE>
     c3c:	09006c61 	stmdbeq	r0, {r0, r5, r6, sl, fp, sp, lr}
     c40:	0a2a0b05 	beq	a8385c <__bss_end+0xa7a118>
     c44:	f8250000 			; <UNDEFINED> instruction: 0xf8250000
     c48:	0900000b 	stmdbeq	r0, {r0, r1, r3}
     c4c:	00711907 	rsbseq	r1, r1, r7, lsl #18
     c50:	b2800000 	addlt	r0, r0, #0
     c54:	84250ee6 	strthi	r0, [r5], #-3814	; 0xfffff11a
     c58:	0900000f 	stmdbeq	r0, {r0, r1, r2, r3}
     c5c:	043b1a0a 	ldrteq	r1, [fp], #-2570	; 0xfffff5f6
     c60:	00000000 	andeq	r0, r0, r0
     c64:	a6252000 	strtge	r2, [r5], -r0
     c68:	09000005 	stmdbeq	r0, {r0, r2}
     c6c:	043b1a0d 	ldrteq	r1, [fp], #-2573	; 0xfffff5f3
     c70:	00000000 	andeq	r0, r0, r0
     c74:	71262020 			; <UNDEFINED> instruction: 0x71262020
     c78:	0900000b 	stmdbeq	r0, {r0, r1, r3}
     c7c:	00651510 	rsbeq	r1, r5, r0, lsl r5
     c80:	25360000 	ldrcs	r0, [r6, #-0]!
     c84:	00001175 	andeq	r1, r0, r5, ror r1
     c88:	3b1a4209 	blcc	6914b4 <__bss_end+0x687d70>
     c8c:	00000004 	andeq	r0, r0, r4
     c90:	25202150 	strcs	r2, [r0, #-336]!	; 0xfffffeb0
     c94:	00001321 	andeq	r1, r0, r1, lsr #6
     c98:	3b1a7109 	blcc	69d0c4 <__bss_end+0x693980>
     c9c:	00000004 	andeq	r0, r0, r4
     ca0:	252000b2 	strcs	r0, [r0, #-178]!	; 0xffffff4e
     ca4:	000008c0 	andeq	r0, r0, r0, asr #17
     ca8:	3b1aa409 	blcc	6a9cd4 <__bss_end+0x6a0590>
     cac:	00000004 	andeq	r0, r0, r4
     cb0:	252000b4 	strcs	r0, [r0, #-180]!	; 0xffffff4c
     cb4:	00000bee 	andeq	r0, r0, lr, ror #23
     cb8:	3b1ab309 	blcc	6ad8e4 <__bss_end+0x6a41a0>
     cbc:	00000004 	andeq	r0, r0, r4
     cc0:	25201040 	strcs	r1, [r0, #-64]!	; 0xffffffc0
     cc4:	00000d55 	andeq	r0, r0, r5, asr sp
     cc8:	3b1abe09 	blcc	6b04f4 <__bss_end+0x6a6db0>
     ccc:	00000004 	andeq	r0, r0, r4
     cd0:	25202050 	strcs	r2, [r0, #-80]!	; 0xffffffb0
     cd4:	000007a0 	andeq	r0, r0, r0, lsr #15
     cd8:	3b1abf09 	blcc	6b0904 <__bss_end+0x6a71c0>
     cdc:	00000004 	andeq	r0, r0, r4
     ce0:	25208040 	strcs	r8, [r0, #-64]!	; 0xffffffc0
     ce4:	0000117e 	andeq	r1, r0, lr, ror r1
     ce8:	3b1ac009 	blcc	6b0d14 <__bss_end+0x6a75d0>
     cec:	00000004 	andeq	r0, r0, r4
     cf0:	00208050 	eoreq	r8, r0, r0, asr r0
     cf4:	00097c27 	andeq	r7, r9, r7, lsr #24
     cf8:	098c2700 	stmibeq	ip, {r8, r9, sl, sp}
     cfc:	9c270000 	stcls	0, cr0, [r7], #-0
     d00:	27000009 	strcs	r0, [r0, -r9]
     d04:	000009ac 	andeq	r0, r0, ip, lsr #19
     d08:	0009b927 	andeq	fp, r9, r7, lsr #18
     d0c:	09c92700 	stmibeq	r9, {r8, r9, sl, sp}^
     d10:	d9270000 	stmdble	r7!, {}	; <UNPREDICTABLE>
     d14:	27000009 	strcs	r0, [r0, -r9]
     d18:	000009e9 	andeq	r0, r0, r9, ror #19
     d1c:	0009f927 	andeq	pc, r9, r7, lsr #18
     d20:	0a092700 	beq	24a928 <__bss_end+0x2411e4>
     d24:	19270000 	stmdbne	r7!, {}	; <UNPREDICTABLE>
     d28:	0b00000a 	bleq	d58 <shift+0xd58>
     d2c:	00000ffb 	strdeq	r0, [r0], -fp
     d30:	6514080a 	ldrvs	r0, [r4, #-2058]	; 0xfffff7f6
     d34:	05000000 	streq	r0, [r0, #-0]
     d38:	00937403 	addseq	r7, r3, r3, lsl #8
     d3c:	0cc80900 			; <UNDEFINED> instruction: 0x0cc80900
     d40:	04070000 	streq	r0, [r7], #-0
     d44:	0000006a 	andeq	r0, r0, sl, rrx
     d48:	bc0c0b0a 			; <UNDEFINED> instruction: 0xbc0c0b0a
     d4c:	0a00000a 	beq	d7c <shift+0xd7c>
     d50:	00000cdb 	ldrdeq	r0, [r0], -fp
     d54:	068d0a00 	streq	r0, [sp], r0, lsl #20
     d58:	0a010000 	beq	40d60 <__bss_end+0x3761c>
     d5c:	00001240 	andeq	r1, r0, r0, asr #4
     d60:	123a0a02 	eorsne	r0, sl, #8192	; 0x2000
     d64:	0a030000 	beq	c0d6c <__bss_end+0xb7628>
     d68:	00001215 	andeq	r1, r0, r5, lsl r2
     d6c:	12fd0a04 	rscsne	r0, sp, #4, 20	; 0x4000
     d70:	0a050000 	beq	140d78 <__bss_end+0x137634>
     d74:	0000122e 	andeq	r1, r0, lr, lsr #4
     d78:	12340a06 	eorsne	r0, r4, #24576	; 0x6000
     d7c:	0a070000 	beq	1c0d84 <__bss_end+0x1b7640>
     d80:	00000ed2 	ldrdeq	r0, [r0], -r2
     d84:	7d090008 	stcvc	0, cr0, [r9, #-32]	; 0xffffffe0
     d88:	0500000a 	streq	r0, [r0, #-10]
     d8c:	00003804 	andeq	r3, r0, r4, lsl #16
     d90:	0c1d0a00 			; <UNDEFINED> instruction: 0x0c1d0a00
     d94:	00000ae7 	andeq	r0, r0, r7, ror #21
     d98:	000d5f0a 	andeq	r5, sp, sl, lsl #30
     d9c:	9c0a0000 	stcls	0, cr0, [sl], {-0}
     da0:	0100000d 	tsteq	r0, sp
     da4:	000d7c0a 	andeq	r7, sp, sl, lsl #24
     da8:	4c1b0200 	lfmmi	f0, 4, [fp], {-0}
     dac:	0300776f 	movweq	r7, #1903	; 0x76f
     db0:	12ef0d00 	rscne	r0, pc, #0, 26
     db4:	0a1c0000 	beq	700dbc <__bss_end+0x6f7678>
     db8:	0e680728 	cdpeq	7, 6, cr0, cr8, cr8, {1}
     dbc:	e3070000 	movw	r0, #28672	; 0x7000
     dc0:	10000003 	andne	r0, r0, r3
     dc4:	360a330a 	strcc	r3, [sl], -sl, lsl #6
     dc8:	0e00000b 	cdpeq	0, 0, cr0, cr0, cr11, {0}
     dcc:	000013d7 	ldrdeq	r1, [r0], -r7
     dd0:	760b350a 	strvc	r3, [fp], -sl, lsl #10
     dd4:	00000003 	andeq	r0, r0, r3
     dd8:	0008430e 	andeq	r4, r8, lr, lsl #6
     ddc:	0d360a00 	vldmdbeq	r6!, {s0-s-1}
     de0:	00000059 	andeq	r0, r0, r9, asr r0
     de4:	05db0e04 	ldrbeq	r0, [fp, #3588]	; 0xe04
     de8:	370a0000 	strcc	r0, [sl, -r0]
     dec:	000e6d13 	andeq	r6, lr, r3, lsl sp
     df0:	240e0800 	strcs	r0, [lr], #-2048	; 0xfffff800
     df4:	0a000005 	beq	e10 <shift+0xe10>
     df8:	0e6d1338 	mcreq	3, 3, r1, cr13, cr8, {1}
     dfc:	000c0000 	andeq	r0, ip, r0
     e00:	0008570e 	andeq	r5, r8, lr, lsl #14
     e04:	202c0a00 	eorcs	r0, ip, r0, lsl #20
     e08:	00000e79 	andeq	r0, r0, r9, ror lr
     e0c:	10480e00 	subne	r0, r8, r0, lsl #28
     e10:	2f0a0000 	svccs	0x000a0000
     e14:	000e7e41 	andeq	r7, lr, r1, asr #28
     e18:	130e0400 	movwne	r0, #58368	; 0xe400
     e1c:	0a00000b 	beq	e50 <shift+0xe50>
     e20:	0e7e4231 	mrceq	2, 3, r4, cr14, cr1, {1}
     e24:	0e0c0000 	cdpeq	0, 0, cr0, cr12, cr0, {0}
     e28:	00000c78 	andeq	r0, r0, r8, ror ip
     e2c:	6d123b0a 	vldrvs	d3, [r2, #-40]	; 0xffffffd8
     e30:	1400000e 	strne	r0, [r0], #-14
     e34:	0009ee0e 	andeq	lr, r9, lr, lsl #28
     e38:	0e3d0a00 	vaddeq.f32	s0, s26, s0
     e3c:	00000115 	andeq	r0, r0, r5, lsl r1
     e40:	0f941318 	svceq	0x00941318
     e44:	410a0000 	mrsmi	r0, (UNDEF: 10)
     e48:	00086c08 	andeq	r6, r8, r8, lsl #24
     e4c:	00034700 	andeq	r4, r3, r0, lsl #14
     e50:	0b900200 	bleq	fe401658 <__bss_end+0xfe3f7f14>
     e54:	0ba50000 	bleq	fe940e5c <__bss_end+0xfe937718>
     e58:	8e100000 	cdphi	0, 1, cr0, cr0, cr0, {0}
     e5c:	1100000e 	tstne	r0, lr
     e60:	00000059 	andeq	r0, r0, r9, asr r0
     e64:	000e9411 	andeq	r9, lr, r1, lsl r4
     e68:	0e941100 	fmleqs	f1, f4, f0
     e6c:	13000000 	movwne	r0, #0
     e70:	000008ad 	andeq	r0, r0, sp, lsr #17
     e74:	8c08430a 	stchi	3, cr4, [r8], {10}
     e78:	47000012 	smladmi	r0, r2, r0, r0
     e7c:	02000003 	andeq	r0, r0, #3
     e80:	00000bbe 			; <UNDEFINED> instruction: 0x00000bbe
     e84:	00000bd3 	ldrdeq	r0, [r0], -r3
     e88:	000e8e10 	andeq	r8, lr, r0, lsl lr
     e8c:	00591100 	subseq	r1, r9, r0, lsl #2
     e90:	94110000 	ldrls	r0, [r1], #-0
     e94:	1100000e 	tstne	r0, lr
     e98:	00000e94 	muleq	r0, r4, lr
     e9c:	0c151300 	ldceq	3, cr1, [r5], {-0}
     ea0:	450a0000 	strmi	r0, [sl, #-0]
     ea4:	0009b608 	andeq	fp, r9, r8, lsl #12
     ea8:	00034700 	andeq	r4, r3, r0, lsl #14
     eac:	0bec0200 	bleq	ffb016b4 <__bss_end+0xffaf7f70>
     eb0:	0c010000 	stceq	0, cr0, [r1], {-0}
     eb4:	8e100000 	cdphi	0, 1, cr0, cr0, cr0, {0}
     eb8:	1100000e 	tstne	r0, lr
     ebc:	00000059 	andeq	r0, r0, r9, asr r0
     ec0:	000e9411 	andeq	r9, lr, r1, lsl r4
     ec4:	0e941100 	fmleqs	f1, f4, f0
     ec8:	13000000 	movwne	r0, #0
     ecc:	00000d42 	andeq	r0, r0, r2, asr #26
     ed0:	7a08470a 	bvc	212b00 <__bss_end+0x2093bc>
     ed4:	47000004 	strmi	r0, [r0, -r4]
     ed8:	02000003 	andeq	r0, r0, #3
     edc:	00000c1a 	andeq	r0, r0, sl, lsl ip
     ee0:	00000c2f 	andeq	r0, r0, pc, lsr #24
     ee4:	000e8e10 	andeq	r8, lr, r0, lsl lr
     ee8:	00591100 	subseq	r1, r9, r0, lsl #2
     eec:	94110000 	ldrls	r0, [r1], #-0
     ef0:	1100000e 	tstne	r0, lr
     ef4:	00000e94 	muleq	r0, r4, lr
     ef8:	08e31300 	stmiaeq	r3!, {r8, r9, ip}^
     efc:	490a0000 	stmdbmi	sl, {}	; <UNPREDICTABLE>
     f00:	000ace08 	andeq	ip, sl, r8, lsl #28
     f04:	00034700 	andeq	r4, r3, r0, lsl #14
     f08:	0c480200 	sfmeq	f0, 2, [r8], {-0}
     f0c:	0c5d0000 	mraeq	r0, sp, acc0
     f10:	8e100000 	cdphi	0, 1, cr0, cr0, cr0, {0}
     f14:	1100000e 	tstne	r0, lr
     f18:	00000059 	andeq	r0, r0, r9, asr r0
     f1c:	000e9411 	andeq	r9, lr, r1, lsl r4
     f20:	0e941100 	fmleqs	f1, f4, f0
     f24:	13000000 	movwne	r0, #0
     f28:	00001122 	andeq	r1, r0, r2, lsr #2
     f2c:	00084b0a 	andeq	r4, r8, sl, lsl #22
     f30:	47000006 	strmi	r0, [r0, -r6]
     f34:	02000003 	andeq	r0, r0, #3
     f38:	00000c76 	andeq	r0, r0, r6, ror ip
     f3c:	00000c90 	muleq	r0, r0, ip
     f40:	000e8e10 	andeq	r8, lr, r0, lsl lr
     f44:	00591100 	subseq	r1, r9, r0, lsl #2
     f48:	bc110000 	ldclt	0, cr0, [r1], {-0}
     f4c:	1100000a 	tstne	r0, sl
     f50:	00000e94 	muleq	r0, r4, lr
     f54:	000e9411 	andeq	r9, lr, r1, lsl r4
     f58:	23130000 	tstcs	r3, #0
     f5c:	0a00000e 	beq	f9c <shift+0xf9c>
     f60:	09fe0c4f 	ldmibeq	lr!, {r0, r1, r2, r3, r6, sl, fp}^
     f64:	00590000 	subseq	r0, r9, r0
     f68:	a9020000 	stmdbge	r2, {}	; <UNPREDICTABLE>
     f6c:	af00000c 	svcge	0x0000000c
     f70:	1000000c 	andne	r0, r0, ip
     f74:	00000e8e 	andeq	r0, r0, lr, lsl #29
     f78:	0aa01400 	beq	fe805f80 <__bss_end+0xfe7fc83c>
     f7c:	510a0000 	mrspl	r0, (UNDEF: 10)
     f80:	0010bd08 	andseq	fp, r0, r8, lsl #26
     f84:	0cc40200 	sfmeq	f0, 2, [r4], {0}
     f88:	0ccf0000 	stcleq	0, cr0, [pc], {0}
     f8c:	9a100000 	bls	400f94 <__bss_end+0x3f7850>
     f90:	1100000e 	tstne	r0, lr
     f94:	00000059 	andeq	r0, r0, r9, asr r0
     f98:	12ef1300 	rscne	r1, pc, #0, 6
     f9c:	540a0000 	strpl	r0, [sl], #-0
     fa0:	0007ec03 	andeq	lr, r7, r3, lsl #24
     fa4:	000e9a00 	andeq	r9, lr, r0, lsl #20
     fa8:	0ce80100 	stfeqe	f0, [r8]
     fac:	0cf30000 	ldcleq	0, cr0, [r3]
     fb0:	9a100000 	bls	400fb8 <__bss_end+0x3f7874>
     fb4:	1100000e 	tstne	r0, lr
     fb8:	0000006a 	andeq	r0, r0, sl, rrx
     fbc:	08f61400 	ldmeq	r6!, {sl, ip}^
     fc0:	570a0000 	strpl	r0, [sl, -r0]
     fc4:	000c9f08 	andeq	r9, ip, r8, lsl #30
     fc8:	0d080100 	stfeqs	f0, [r8, #-0]
     fcc:	0d180000 	ldceq	0, cr0, [r8, #-0]
     fd0:	9a100000 	bls	400fd8 <__bss_end+0x3f7894>
     fd4:	1100000e 	tstne	r0, lr
     fd8:	00000059 	andeq	r0, r0, r9, asr r0
     fdc:	000a7311 	andeq	r7, sl, r1, lsl r3
     fe0:	94130000 	ldrls	r0, [r3], #-0
     fe4:	0a00000b 	beq	1018 <shift+0x1018>
     fe8:	0fcd1259 	svceq	0x00cd1259
     fec:	0a730000 	beq	1cc0ff4 <__bss_end+0x1cb78b0>
     ff0:	31010000 	mrscc	r0, (UNDEF: 1)
     ff4:	3c00000d 	stccc	0, cr0, [r0], {13}
     ff8:	1000000d 	andne	r0, r0, sp
     ffc:	00000e8e 	andeq	r0, r0, lr, lsl #29
    1000:	00005911 	andeq	r5, r0, r1, lsl r9
    1004:	89140000 	ldmdbhi	r4, {}	; <UNPREDICTABLE>
    1008:	0a000006 	beq	1028 <shift+0x1028>
    100c:	0763085c 			; <UNDEFINED> instruction: 0x0763085c
    1010:	51010000 	mrspl	r0, (UNDEF: 1)
    1014:	6100000d 	tstvs	r0, sp
    1018:	1000000d 	andne	r0, r0, sp
    101c:	00000e9a 	muleq	r0, sl, lr
    1020:	00005911 	andeq	r5, r0, r1, lsl r9
    1024:	03471100 	movteq	r1, #28928	; 0x7100
    1028:	13000000 	movwne	r0, #0
    102c:	00000cd7 	ldrdeq	r0, [r0], -r7
    1030:	44085f0a 	strmi	r5, [r8], #-3850	; 0xfffff0f6
    1034:	47000007 	strmi	r0, [r0, -r7]
    1038:	01000003 	tsteq	r0, r3
    103c:	00000d7a 	andeq	r0, r0, sl, ror sp
    1040:	00000d85 	andeq	r0, r0, r5, lsl #27
    1044:	000e9a10 	andeq	r9, lr, r0, lsl sl
    1048:	00591100 	subseq	r1, r9, r0, lsl #2
    104c:	13000000 	movwne	r0, #0
    1050:	00000d70 	andeq	r0, r0, r0, ror sp
    1054:	a908620a 	stmdbge	r8, {r1, r3, r9, sp, lr}
    1058:	47000004 	strmi	r0, [r0, -r4]
    105c:	01000003 	tsteq	r0, r3
    1060:	00000d9e 	muleq	r0, lr, sp
    1064:	00000db3 			; <UNDEFINED> instruction: 0x00000db3
    1068:	000e9a10 	andeq	r9, lr, r0, lsl sl
    106c:	00591100 	subseq	r1, r9, r0, lsl #2
    1070:	47110000 	ldrmi	r0, [r1, -r0]
    1074:	11000003 	tstne	r0, r3
    1078:	00000347 	andeq	r0, r0, r7, asr #6
    107c:	05441300 	strbeq	r1, [r4, #-768]	; 0xfffffd00
    1080:	640a0000 	strvs	r0, [sl], #-0
    1084:	000ede08 	andeq	sp, lr, r8, lsl #28
    1088:	00034700 	andeq	r4, r3, r0, lsl #14
    108c:	0dcc0100 	stfeqe	f0, [ip]
    1090:	0de10000 	stcleq	0, cr0, [r1]
    1094:	9a100000 	bls	40109c <__bss_end+0x3f7958>
    1098:	1100000e 	tstne	r0, lr
    109c:	00000059 	andeq	r0, r0, r9, asr r0
    10a0:	00034711 	andeq	r4, r3, r1, lsl r7
    10a4:	03471100 	movteq	r1, #28928	; 0x7100
    10a8:	14000000 	strne	r0, [r0], #-0
    10ac:	000013be 			; <UNDEFINED> instruction: 0x000013be
    10b0:	5208670a 	andpl	r6, r8, #2621440	; 0x280000
    10b4:	0100000a 	tsteq	r0, sl
    10b8:	00000df6 	strdeq	r0, [r0], -r6
    10bc:	00000e06 	andeq	r0, r0, r6, lsl #28
    10c0:	000e9a10 	andeq	r9, lr, r0, lsl sl
    10c4:	00591100 	subseq	r1, r9, r0, lsl #2
    10c8:	bc110000 	ldclt	0, cr0, [r1], {-0}
    10cc:	0000000a 	andeq	r0, r0, sl
    10d0:	00130c14 	andseq	r0, r3, r4, lsl ip
    10d4:	08690a00 	stmdaeq	r9!, {r9, fp}^
    10d8:	00001007 	andeq	r1, r0, r7
    10dc:	000e1b01 	andeq	r1, lr, r1, lsl #22
    10e0:	000e2b00 	andeq	r2, lr, r0, lsl #22
    10e4:	0e9a1000 	cdpeq	0, 9, cr1, cr10, cr0, {0}
    10e8:	59110000 	ldmdbpl	r1, {}	; <UNPREDICTABLE>
    10ec:	11000000 	mrsne	r0, (UNDEF: 0)
    10f0:	00000abc 			; <UNDEFINED> instruction: 0x00000abc
    10f4:	0ab51400 	beq	fed460fc <__bss_end+0xfed3c9b8>
    10f8:	6c0a0000 	stcvs	0, cr0, [sl], {-0}
    10fc:	00119c08 	andseq	r9, r1, r8, lsl #24
    1100:	0e400100 	dvfeqs	f0, f0, f0
    1104:	0e460000 	cdpeq	0, 4, cr0, cr6, cr0, {0}
    1108:	9a100000 	bls	401110 <__bss_end+0x3f79cc>
    110c:	0000000e 	andeq	r0, r0, lr
    1110:	000b8523 	andeq	r8, fp, r3, lsr #10
    1114:	086f0a00 	stmdaeq	pc!, {r9, fp}^	; <UNPREDICTABLE>
    1118:	0000113d 	andeq	r1, r0, sp, lsr r1
    111c:	000e5701 	andeq	r5, lr, r1, lsl #14
    1120:	0e9a1000 	cdpeq	0, 9, cr1, cr10, cr0, {0}
    1124:	76110000 	ldrvc	r0, [r1], -r0
    1128:	11000003 	tstne	r0, r3
    112c:	00000059 	andeq	r0, r0, r9, asr r0
    1130:	e7030000 	str	r0, [r3, -r0]
    1134:	1800000a 	stmdane	r0, {r1, r3}
    1138:	000af404 	andeq	pc, sl, r4, lsl #8
    113c:	76041800 	strvc	r1, [r4], -r0, lsl #16
    1140:	03000000 	movweq	r0, #0
    1144:	00000e73 	andeq	r0, r0, r3, ror lr
    1148:	00005916 	andeq	r5, r0, r6, lsl r9
    114c:	000e8e00 	andeq	r8, lr, r0, lsl #28
    1150:	006a1700 	rsbeq	r1, sl, r0, lsl #14
    1154:	00010000 	andeq	r0, r1, r0
    1158:	0e680418 	mcreq	4, 3, r0, cr8, cr8, {0}
    115c:	04210000 	strteq	r0, [r1], #-0
    1160:	00000059 	andeq	r0, r0, r9, asr r0
    1164:	0ae70418 	beq	ff9c21cc <__bss_end+0xff9b8a88>
    1168:	dd1a0000 	ldcle	0, cr0, [sl, #-0]
    116c:	0a000008 	beq	1194 <shift+0x1194>
    1170:	0ae71673 	beq	ff9c6b44 <__bss_end+0xff9bd400>
    1174:	54160000 	ldrpl	r0, [r6], #-0
    1178:	bc000003 	stclt	0, cr0, [r0], {3}
    117c:	1700000e 	strne	r0, [r0, -lr]
    1180:	0000006a 	andeq	r0, r0, sl, rrx
    1184:	e5280004 	str	r0, [r8, #-4]!
    1188:	01000009 	tsteq	r0, r9
    118c:	0eac0d12 	mcreq	13, 5, r0, cr12, cr2, {0}
    1190:	03050000 	movweq	r0, #20480	; 0x5000
    1194:	00009720 	andeq	r9, r0, r0, lsr #14
    1198:	0012ce29 	andseq	ip, r2, r9, lsr #28
    119c:	051a0100 	ldreq	r0, [sl, #-256]	; 0xffffff00
    11a0:	00000038 	andeq	r0, r0, r8, lsr r0
    11a4:	00008234 	andeq	r8, r0, r4, lsr r2
    11a8:	0000010c 	andeq	r0, r0, ip, lsl #2
    11ac:	0f4d9c01 	svceq	0x004d9c01
    11b0:	6b2a0000 	blvs	a811b8 <__bss_end+0xa77a74>
    11b4:	0100000d 	tsteq	r0, sp
    11b8:	00380e1a 	eorseq	r0, r8, sl, lsl lr
    11bc:	91020000 	mrsls	r0, (UNDEF: 2)
    11c0:	09672a5c 	stmdbeq	r7!, {r2, r3, r4, r6, r9, fp, sp}^
    11c4:	1a010000 	bne	411cc <__bss_end+0x37a88>
    11c8:	000f4d1b 	andeq	r4, pc, fp, lsl sp	; <UNPREDICTABLE>
    11cc:	58910200 	ldmpl	r1, {r9}
    11d0:	0012d32b 	andseq	sp, r2, fp, lsr #6
    11d4:	101c0100 	andsne	r0, ip, r0, lsl #2
    11d8:	0000081b 	andeq	r0, r0, fp, lsl r8
    11dc:	2b689102 	blcs	1a255ec <__bss_end+0x1a1bea8>
    11e0:	000013d2 	ldrdeq	r1, [r0], -r2
    11e4:	590b2101 	stmdbpl	fp, {r0, r8, sp}
    11e8:	02000000 	andeq	r0, r0, #0
    11ec:	6e2c7491 	mcrvs	4, 1, r7, cr12, cr1, {4}
    11f0:	01006d75 	tsteq	r0, r5, ror sp
    11f4:	00590b22 	subseq	r0, r9, r2, lsr #22
    11f8:	91020000 	mrsls	r0, (UNDEF: 2)
    11fc:	82ac2d64 	adchi	r2, ip, #100, 26	; 0x1900
    1200:	007c0000 	rsbseq	r0, ip, r0
    1204:	6d2c0000 	stcvs	0, cr0, [ip, #-0]
    1208:	01006773 	tsteq	r0, r3, ror r7
    120c:	03540f2a 	cmpeq	r4, #42, 30	; 0xa8
    1210:	91020000 	mrsls	r0, (UNDEF: 2)
    1214:	18000070 	stmdane	r0, {r4, r5, r6}
    1218:	000f5304 	andeq	r5, pc, r4, lsl #6
    121c:	25041800 	strcs	r1, [r4, #-2048]	; 0xfffff800
    1220:	00000000 	andeq	r0, r0, r0
    1224:	00000cd7 	ldrdeq	r0, [r0], -r7
    1228:	04790004 	ldrbteq	r0, [r9], #-4
    122c:	01040000 	mrseq	r0, (UNDEF: 4)
    1230:	000013ef 	andeq	r1, r0, pc, ror #7
    1234:	00153004 	andseq	r3, r5, r4
    1238:	0015f200 	andseq	pc, r5, r0, lsl #4
    123c:	00834000 	addeq	r4, r3, r0
    1240:	00046000 	andeq	r6, r4, r0
    1244:	0004b800 	andeq	fp, r4, r0, lsl #16
    1248:	08010200 	stmdaeq	r1, {r9}
    124c:	00001109 	andeq	r1, r0, r9, lsl #2
    1250:	00002503 	andeq	r2, r0, r3, lsl #10
    1254:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    1258:	00000e4a 	andeq	r0, r0, sl, asr #28
    125c:	69050404 	stmdbvs	r5, {r2, sl}
    1260:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    1264:	11000801 	tstne	r0, r1, lsl #16
    1268:	02020000 	andeq	r0, r2, #0
    126c:	0012bb07 	andseq	fp, r2, r7, lsl #22
    1270:	073b0500 	ldreq	r0, [fp, -r0, lsl #10]!
    1274:	09070000 	stmdbeq	r7, {}	; <UNPREDICTABLE>
    1278:	00005e1e 	andeq	r5, r0, lr, lsl lr
    127c:	004d0300 	subeq	r0, sp, r0, lsl #6
    1280:	04020000 	streq	r0, [r2], #-0
    1284:	001fd607 	andseq	sp, pc, r7, lsl #12
    1288:	13b20600 			; <UNDEFINED> instruction: 0x13b20600
    128c:	02080000 	andeq	r0, r8, #0
    1290:	008b0806 	addeq	r0, fp, r6, lsl #16
    1294:	72070000 	andvc	r0, r7, #0
    1298:	08020030 	stmdaeq	r2, {r4, r5}
    129c:	00004d0e 	andeq	r4, r0, lr, lsl #26
    12a0:	72070000 	andvc	r0, r7, #0
    12a4:	09020031 	stmdbeq	r2, {r0, r4, r5}
    12a8:	00004d0e 	andeq	r4, r0, lr, lsl #26
    12ac:	08000400 	stmdaeq	r0, {sl}
    12b0:	0000174b 	andeq	r1, r0, fp, asr #14
    12b4:	00380405 	eorseq	r0, r8, r5, lsl #8
    12b8:	0d020000 	stceq	0, cr0, [r2, #-0]
    12bc:	0000a90c 	andeq	sl, r0, ip, lsl #18
    12c0:	4b4f0900 	blmi	13c36c8 <__bss_end+0x13b9f84>
    12c4:	700a0000 	andvc	r0, sl, r0
    12c8:	01000015 	tsteq	r0, r5, lsl r0
    12cc:	0f3e0800 	svceq	0x003e0800
    12d0:	04050000 	streq	r0, [r5], #-0
    12d4:	00000038 	andeq	r0, r0, r8, lsr r0
    12d8:	e00c1e02 	and	r1, ip, r2, lsl #28
    12dc:	0a000000 	beq	12e4 <shift+0x12e4>
    12e0:	00000733 	andeq	r0, r0, r3, lsr r7
    12e4:	097a0a00 	ldmdbeq	sl!, {r9, fp}^
    12e8:	0a010000 	beq	412f0 <__bss_end+0x37bac>
    12ec:	00000f60 	andeq	r0, r0, r0, ror #30
    12f0:	111c0a02 	tstne	ip, r2, lsl #20
    12f4:	0a030000 	beq	c12fc <__bss_end+0xb7bb8>
    12f8:	00000958 	andeq	r0, r0, r8, asr r9
    12fc:	0e3a0a04 	vaddeq.f32	s0, s20, s8
    1300:	00050000 	andeq	r0, r5, r0
    1304:	000f2608 	andeq	r2, pc, r8, lsl #12
    1308:	38040500 	stmdacc	r4, {r8, sl}
    130c:	02000000 	andeq	r0, r0, #0
    1310:	011d0c3f 	tsteq	sp, pc, lsr ip
    1314:	9c0a0000 	stcls	0, cr0, [sl], {-0}
    1318:	00000008 	andeq	r0, r0, r8
    131c:	00105a0a 	andseq	r5, r0, sl, lsl #20
    1320:	4b0a0100 	blmi	281728 <__bss_end+0x277fe4>
    1324:	02000013 	andeq	r0, r0, #19
    1328:	000d160a 	andeq	r1, sp, sl, lsl #12
    132c:	6c0a0300 	stcvs	3, cr0, [sl], {-0}
    1330:	04000009 	streq	r0, [r0], #-9
    1334:	000a920a 	andeq	r9, sl, sl, lsl #4
    1338:	b30a0500 	movwlt	r0, #42240	; 0xa500
    133c:	06000007 	streq	r0, [r0], -r7
    1340:	17ba0800 	ldrne	r0, [sl, r0, lsl #16]!
    1344:	04050000 	streq	r0, [r5], #-0
    1348:	00000038 	andeq	r0, r0, r8, lsr r0
    134c:	480c6602 	stmdami	ip, {r1, r9, sl, sp, lr}
    1350:	0a000001 	beq	135c <shift+0x135c>
    1354:	000016f0 	strdeq	r1, [r0], -r0
    1358:	15cd0a00 	strbne	r0, [sp, #2560]	; 0xa00
    135c:	0a010000 	beq	41364 <__bss_end+0x37c20>
    1360:	00001714 	andeq	r1, r0, r4, lsl r7
    1364:	16210a02 	strtne	r0, [r1], -r2, lsl #20
    1368:	00030000 	andeq	r0, r3, r0
    136c:	000c870b 	andeq	r8, ip, fp, lsl #14
    1370:	14050300 	strne	r0, [r5], #-768	; 0xfffffd00
    1374:	00000059 	andeq	r0, r0, r9, asr r0
    1378:	94300305 	ldrtls	r0, [r0], #-773	; 0xfffffcfb
    137c:	5f0b0000 	svcpl	0x000b0000
    1380:	03000010 	movweq	r0, #16
    1384:	00591406 	subseq	r1, r9, r6, lsl #8
    1388:	03050000 	movweq	r0, #20480	; 0x5000
    138c:	00009434 	andeq	r9, r0, r4, lsr r4
    1390:	000afd0b 	andeq	pc, sl, fp, lsl #26
    1394:	1a070400 	bne	1c239c <__bss_end+0x1b8c58>
    1398:	00000059 	andeq	r0, r0, r9, asr r0
    139c:	94380305 	ldrtls	r0, [r8], #-773	; 0xfffffcfb
    13a0:	630b0000 	movwvs	r0, #45056	; 0xb000
    13a4:	0400000e 	streq	r0, [r0], #-14
    13a8:	00591a09 	subseq	r1, r9, r9, lsl #20
    13ac:	03050000 	movweq	r0, #20480	; 0x5000
    13b0:	0000943c 	andeq	r9, r0, ip, lsr r4
    13b4:	000ac00b 	andeq	ip, sl, fp
    13b8:	1a0b0400 	bne	2c23c0 <__bss_end+0x2b8c7c>
    13bc:	00000059 	andeq	r0, r0, r9, asr r0
    13c0:	94400305 	strbls	r0, [r0], #-773	; 0xfffffcfb
    13c4:	ee0b0000 	cdp	0, 0, cr0, cr11, cr0, {0}
    13c8:	0400000d 	streq	r0, [r0], #-13
    13cc:	00591a0d 	subseq	r1, r9, sp, lsl #20
    13d0:	03050000 	movweq	r0, #20480	; 0x5000
    13d4:	00009444 	andeq	r9, r0, r4, asr #8
    13d8:	0007130b 	andeq	r1, r7, fp, lsl #6
    13dc:	1a0f0400 	bne	3c23e4 <__bss_end+0x3b8ca0>
    13e0:	00000059 	andeq	r0, r0, r9, asr r0
    13e4:	94480305 	strbls	r0, [r8], #-773	; 0xfffffcfb
    13e8:	fc080000 	stc2	0, cr0, [r8], {-0}
    13ec:	0500000c 	streq	r0, [r0, #-12]
    13f0:	00003804 	andeq	r3, r0, r4, lsl #16
    13f4:	0c1b0400 	cfldrseq	mvf0, [fp], {-0}
    13f8:	000001eb 	andeq	r0, r0, fp, ror #3
    13fc:	00069f0a 	andeq	r9, r6, sl, lsl #30
    1400:	880a0000 	stmdahi	sl, {}	; <UNPREDICTABLE>
    1404:	01000011 	tsteq	r0, r1, lsl r0
    1408:	0013460a 	andseq	r4, r3, sl, lsl #12
    140c:	0c000200 	sfmeq	f0, 4, [r0], {-0}
    1410:	00000461 	andeq	r0, r0, r1, ror #8
    1414:	0005290d 	andeq	r2, r5, sp, lsl #18
    1418:	63049000 	movwvs	r9, #16384	; 0x4000
    141c:	00035e07 	andeq	r5, r3, r7, lsl #28
    1420:	067b0600 	ldrbteq	r0, [fp], -r0, lsl #12
    1424:	04240000 	strteq	r0, [r4], #-0
    1428:	02781067 	rsbseq	r1, r8, #103	; 0x67
    142c:	be0e0000 	cdplt	0, 0, cr0, cr14, cr0, {0}
    1430:	04000023 	streq	r0, [r0], #-35	; 0xffffffdd
    1434:	035e2869 	cmpeq	lr, #6881280	; 0x690000
    1438:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    143c:	000008a1 	andeq	r0, r0, r1, lsr #17
    1440:	6e206b04 	vmulvs.f64	d6, d0, d4
    1444:	10000003 	andne	r0, r0, r3
    1448:	0006940e 	andeq	r9, r6, lr, lsl #8
    144c:	236d0400 	cmncs	sp, #0, 8
    1450:	0000004d 	andeq	r0, r0, sp, asr #32
    1454:	0e430e14 	mcreq	14, 2, r0, cr3, cr4, {0}
    1458:	70040000 	andvc	r0, r4, r0
    145c:	0003751c 	andeq	r7, r3, ip, lsl r5
    1460:	030e1800 	movweq	r1, #59392	; 0xe800
    1464:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
    1468:	03751c72 	cmneq	r5, #29184	; 0x7200
    146c:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
    1470:	00000524 	andeq	r0, r0, r4, lsr #10
    1474:	751c7504 	ldrvc	r7, [ip, #-1284]	; 0xfffffafc
    1478:	20000003 	andcs	r0, r0, r3
    147c:	000f150f 	andeq	r1, pc, pc, lsl #10
    1480:	1c770400 	cfldrdne	mvd0, [r7], #-0
    1484:	00001246 	andeq	r1, r0, r6, asr #4
    1488:	00000375 	andeq	r0, r0, r5, ror r3
    148c:	0000026c 	andeq	r0, r0, ip, ror #4
    1490:	00037510 	andeq	r7, r3, r0, lsl r5
    1494:	037b1100 	cmneq	fp, #0, 2
    1498:	00000000 	andeq	r0, r0, r0
    149c:	00133b06 	andseq	r3, r3, r6, lsl #22
    14a0:	7b041800 	blvc	1074a8 <__bss_end+0xfdd64>
    14a4:	0002ad10 	andeq	sl, r2, r0, lsl sp
    14a8:	23be0e00 			; <UNDEFINED> instruction: 0x23be0e00
    14ac:	7e040000 	cdpvc	0, 0, cr0, cr4, cr0, {0}
    14b0:	00035e2c 	andeq	r5, r3, ip, lsr #28
    14b4:	870e0000 	strhi	r0, [lr, -r0]
    14b8:	04000005 	streq	r0, [r0], #-5
    14bc:	037b1980 	cmneq	fp, #128, 18	; 0x200000
    14c0:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
    14c4:	00000a99 	muleq	r0, r9, sl
    14c8:	86218204 	strthi	r8, [r1], -r4, lsl #4
    14cc:	14000003 	strne	r0, [r0], #-3
    14d0:	02780300 	rsbseq	r0, r8, #0, 6
    14d4:	d7120000 	ldrle	r0, [r2, -r0]
    14d8:	04000004 	streq	r0, [r0], #-4
    14dc:	038c2186 	orreq	r2, ip, #-2147483615	; 0x80000021
    14e0:	cb120000 	blgt	4814e8 <__bss_end+0x477da4>
    14e4:	04000008 	streq	r0, [r0], #-8
    14e8:	00591f88 	subseq	r1, r9, r8, lsl #31
    14ec:	750e0000 	strvc	r0, [lr, #-0]
    14f0:	0400000e 	streq	r0, [r0], #-14
    14f4:	01fd178b 	mvnseq	r1, fp, lsl #15
    14f8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    14fc:	00000803 	andeq	r0, r0, r3, lsl #16
    1500:	fd178e04 	ldc2	14, cr8, [r7, #-16]
    1504:	24000001 	strcs	r0, [r0], #-1
    1508:	000c0b0e 	andeq	r0, ip, lr, lsl #22
    150c:	178f0400 	strne	r0, [pc, r0, lsl #8]
    1510:	000001fd 	strdeq	r0, [r0], -sp
    1514:	09f40e48 	ldmibeq	r4!, {r3, r6, r9, sl, fp}^
    1518:	90040000 	andls	r0, r4, r0
    151c:	0001fd17 	andeq	pc, r1, r7, lsl sp	; <UNPREDICTABLE>
    1520:	29136c00 	ldmdbcs	r3, {sl, fp, sp, lr}
    1524:	04000005 	streq	r0, [r0], #-5
    1528:	0db10993 			; <UNDEFINED> instruction: 0x0db10993
    152c:	03970000 	orrseq	r0, r7, #0
    1530:	17010000 	strne	r0, [r1, -r0]
    1534:	1d000003 	stcne	0, cr0, [r0, #-12]
    1538:	10000003 	andne	r0, r0, r3
    153c:	00000397 	muleq	r0, r7, r3
    1540:	0f0a1400 	svceq	0x000a1400
    1544:	96040000 	strls	r0, [r4], -r0
    1548:	0005680e 	andeq	r6, r5, lr, lsl #16
    154c:	03320100 	teqeq	r2, #0, 2
    1550:	03380000 	teqeq	r8, #0
    1554:	97100000 	ldrls	r0, [r0, -r0]
    1558:	00000003 	andeq	r0, r0, r3
    155c:	00089c15 	andeq	r9, r8, r5, lsl ip
    1560:	10990400 	addsne	r0, r9, r0, lsl #8
    1564:	00000ce1 	andeq	r0, r0, r1, ror #25
    1568:	0000039d 	muleq	r0, sp, r3
    156c:	00034d01 	andeq	r4, r3, r1, lsl #26
    1570:	03971000 	orrseq	r1, r7, #0
    1574:	7b110000 	blvc	44157c <__bss_end+0x437e38>
    1578:	11000003 	tstne	r0, r3
    157c:	000001c6 	andeq	r0, r0, r6, asr #3
    1580:	25160000 	ldrcs	r0, [r6, #-0]
    1584:	6e000000 	cdpvs	0, 0, cr0, cr0, cr0, {0}
    1588:	17000003 	strne	r0, [r0, -r3]
    158c:	0000005e 	andeq	r0, r0, lr, asr r0
    1590:	0102000f 	tsteq	r2, pc
    1594:	000ba602 	andeq	sl, fp, r2, lsl #12
    1598:	fd041800 	stc2	8, cr1, [r4, #-0]
    159c:	18000001 	stmdane	r0, {r0}
    15a0:	00002c04 	andeq	r2, r0, r4, lsl #24
    15a4:	121b0c00 	andsne	r0, fp, #0, 24
    15a8:	04180000 	ldreq	r0, [r8], #-0
    15ac:	00000381 	andeq	r0, r0, r1, lsl #7
    15b0:	0002ad16 	andeq	sl, r2, r6, lsl sp
    15b4:	00039700 	andeq	r9, r3, r0, lsl #14
    15b8:	18001900 	stmdane	r0, {r8, fp, ip}
    15bc:	0001f004 	andeq	pc, r1, r4
    15c0:	eb041800 	bl	1075c8 <__bss_end+0xfde84>
    15c4:	1a000001 	bne	15d0 <shift+0x15d0>
    15c8:	00000efe 	strdeq	r0, [r0], -lr
    15cc:	f0149c04 			; <UNDEFINED> instruction: 0xf0149c04
    15d0:	0b000001 	bleq	15dc <shift+0x15dc>
    15d4:	000006a9 	andeq	r0, r0, r9, lsr #13
    15d8:	59140405 	ldmdbpl	r4, {r0, r2, sl}
    15dc:	05000000 	streq	r0, [r0, #-0]
    15e0:	00944c03 	addseq	r4, r4, r3, lsl #24
    15e4:	0f660b00 	svceq	0x00660b00
    15e8:	07050000 	streq	r0, [r5, -r0]
    15ec:	00005914 	andeq	r5, r0, r4, lsl r9
    15f0:	50030500 	andpl	r0, r3, r0, lsl #10
    15f4:	0b000094 	bleq	184c <shift+0x184c>
    15f8:	00000555 	andeq	r0, r0, r5, asr r5
    15fc:	59140a05 	ldmdbpl	r4, {r0, r2, r9, fp}
    1600:	05000000 	streq	r0, [r0, #-0]
    1604:	00945403 	addseq	r5, r4, r3, lsl #8
    1608:	07b80800 	ldreq	r0, [r8, r0, lsl #16]!
    160c:	04050000 	streq	r0, [r5], #-0
    1610:	00000038 	andeq	r0, r0, r8, lsr r0
    1614:	1c0c0d05 	stcne	13, cr0, [ip], {5}
    1618:	09000004 	stmdbeq	r0, {r2}
    161c:	0077654e 	rsbseq	r6, r7, lr, asr #10
    1620:	09840a00 	stmibeq	r4, {r9, fp}
    1624:	0a010000 	beq	4162c <__bss_end+0x37ee8>
    1628:	0000054d 	andeq	r0, r0, sp, asr #10
    162c:	07d10a02 	ldrbeq	r0, [r1, r2, lsl #20]
    1630:	0a030000 	beq	c1638 <__bss_end+0xb7ef4>
    1634:	0000110e 	andeq	r1, r0, lr, lsl #2
    1638:	051d0a04 	ldreq	r0, [sp, #-2564]	; 0xfffff5fc
    163c:	00050000 	andeq	r0, r5, r0
    1640:	0006c206 	andeq	ip, r6, r6, lsl #4
    1644:	1b051000 	blne	14564c <__bss_end+0x13bf08>
    1648:	00045b08 	andeq	r5, r4, r8, lsl #22
    164c:	726c0700 	rsbvc	r0, ip, #0, 14
    1650:	131d0500 	tstne	sp, #0, 10
    1654:	0000045b 	andeq	r0, r0, fp, asr r4
    1658:	70730700 	rsbsvc	r0, r3, r0, lsl #14
    165c:	131e0500 	tstne	lr, #0, 10
    1660:	0000045b 	andeq	r0, r0, fp, asr r4
    1664:	63700704 	cmnvs	r0, #4, 14	; 0x100000
    1668:	131f0500 	tstne	pc, #0, 10
    166c:	0000045b 	andeq	r0, r0, fp, asr r4
    1670:	0f200e08 	svceq	0x00200e08
    1674:	20050000 	andcs	r0, r5, r0
    1678:	00045b13 	andeq	r5, r4, r3, lsl fp
    167c:	02000c00 	andeq	r0, r0, #0, 24
    1680:	1fd10704 	svcne	0x00d10704
    1684:	4b060000 	blmi	18168c <__bss_end+0x177f48>
    1688:	70000009 	andvc	r0, r0, r9
    168c:	f2082805 	vadd.i8	d2, d8, d5
    1690:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
    1694:	0000084b 	andeq	r0, r0, fp, asr #16
    1698:	1c122a05 			; <UNDEFINED> instruction: 0x1c122a05
    169c:	00000004 	andeq	r0, r0, r4
    16a0:	64697007 	strbtvs	r7, [r9], #-7
    16a4:	122b0500 	eorne	r0, fp, #0, 10
    16a8:	0000005e 	andeq	r0, r0, lr, asr r0
    16ac:	1daf0e10 	stcne	14, cr0, [pc, #64]!	; 16f4 <shift+0x16f4>
    16b0:	2c050000 	stccs	0, cr0, [r5], {-0}
    16b4:	0003e511 	andeq	lr, r3, r1, lsl r5
    16b8:	f20e1400 	vshl.s8	d1, d0, d14
    16bc:	05000010 	streq	r0, [r0, #-16]
    16c0:	005e122d 	subseq	r1, lr, sp, lsr #4
    16c4:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
    16c8:	000003f1 	strdeq	r0, [r0], -r1
    16cc:	5e122e05 	cdppl	14, 1, cr2, cr2, cr5, {0}
    16d0:	1c000000 	stcne	0, cr0, [r0], {-0}
    16d4:	000f530e 	andeq	r5, pc, lr, lsl #6
    16d8:	312f0500 			; <UNDEFINED> instruction: 0x312f0500
    16dc:	000004f2 	strdeq	r0, [r0], -r2
    16e0:	04cd0e20 	strbeq	r0, [sp], #3616	; 0xe20
    16e4:	30050000 	andcc	r0, r5, r0
    16e8:	00003809 	andeq	r3, r0, r9, lsl #16
    16ec:	650e6000 	strvs	r6, [lr, #-0]
    16f0:	0500000b 	streq	r0, [r0, #-11]
    16f4:	004d0e31 	subeq	r0, sp, r1, lsr lr
    16f8:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
    16fc:	00000d8a 	andeq	r0, r0, sl, lsl #27
    1700:	4d0e3305 	stcmi	3, cr3, [lr, #-20]	; 0xffffffec
    1704:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
    1708:	000d810e 	andeq	r8, sp, lr, lsl #2
    170c:	0e340500 	cfabs32eq	mvfx0, mvfx4
    1710:	0000004d 	andeq	r0, r0, sp, asr #32
    1714:	9d16006c 	ldcls	0, cr0, [r6, #-432]	; 0xfffffe50
    1718:	02000003 	andeq	r0, r0, #3
    171c:	17000005 	strne	r0, [r0, -r5]
    1720:	0000005e 	andeq	r0, r0, lr, asr r0
    1724:	350b000f 	strcc	r0, [fp, #-15]
    1728:	06000005 	streq	r0, [r0], -r5
    172c:	0059140a 	subseq	r1, r9, sl, lsl #8
    1730:	03050000 	movweq	r0, #20480	; 0x5000
    1734:	00009458 	andeq	r9, r0, r8, asr r4
    1738:	000b5008 	andeq	r5, fp, r8
    173c:	38040500 	stmdacc	r4, {r8, sl}
    1740:	06000000 	streq	r0, [r0], -r0
    1744:	05330c0d 	ldreq	r0, [r3, #-3085]!	; 0xfffff3f3
    1748:	510a0000 	mrspl	r0, (UNDEF: 10)
    174c:	00000013 	andeq	r0, r0, r3, lsl r0
    1750:	0011bd0a 	andseq	fp, r1, sl, lsl #26
    1754:	03000100 	movweq	r0, #256	; 0x100
    1758:	00000514 	andeq	r0, r0, r4, lsl r5
    175c:	00167c08 	andseq	r7, r6, r8, lsl #24
    1760:	38040500 	stmdacc	r4, {r8, sl}
    1764:	06000000 	streq	r0, [r0], -r0
    1768:	05570c14 	ldrbeq	r0, [r7, #-3092]	; 0xfffff3ec
    176c:	e20a0000 	and	r0, sl, #0
    1770:	00000013 	andeq	r0, r0, r3, lsl r0
    1774:	0017060a 	andseq	r0, r7, sl, lsl #12
    1778:	03000100 	movweq	r0, #256	; 0x100
    177c:	00000538 	andeq	r0, r0, r8, lsr r5
    1780:	00083006 	andeq	r3, r8, r6
    1784:	1b060c00 	blne	18478c <__bss_end+0x17b048>
    1788:	00059108 	andeq	r9, r5, r8, lsl #2
    178c:	05db0e00 	ldrbeq	r0, [fp, #3584]	; 0xe00
    1790:	1d060000 	stcne	0, cr0, [r6, #-0]
    1794:	00059119 	andeq	r9, r5, r9, lsl r1
    1798:	240e0000 	strcs	r0, [lr], #-0
    179c:	06000005 	streq	r0, [r0], -r5
    17a0:	0591191e 	ldreq	r1, [r1, #2334]	; 0x91e
    17a4:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
    17a8:	00000b80 	andeq	r0, r0, r0, lsl #23
    17ac:	97131f06 	ldrls	r1, [r3, -r6, lsl #30]
    17b0:	08000005 	stmdaeq	r0, {r0, r2}
    17b4:	5c041800 	stcpl	8, cr1, [r4], {-0}
    17b8:	18000005 	stmdane	r0, {r0, r2}
    17bc:	00046204 	andeq	r6, r4, r4, lsl #4
    17c0:	0ec10d00 	cdpeq	13, 12, cr0, cr1, cr0, {0}
    17c4:	06140000 	ldreq	r0, [r4], -r0
    17c8:	081f0722 	ldmdaeq	pc, {r1, r5, r8, r9, sl}	; <UNPREDICTABLE>
    17cc:	950e0000 	strls	r0, [lr, #-0]
    17d0:	0600000c 	streq	r0, [r0], -ip
    17d4:	004d1226 	subeq	r1, sp, r6, lsr #4
    17d8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    17dc:	00000c28 	andeq	r0, r0, r8, lsr #24
    17e0:	911d2906 	tstls	sp, r6, lsl #18
    17e4:	04000005 	streq	r0, [r0], #-5
    17e8:	0007d90e 	andeq	sp, r7, lr, lsl #18
    17ec:	1d2c0600 	stcne	6, cr0, [ip, #-0]
    17f0:	00000591 	muleq	r0, r1, r5
    17f4:	0d0c1b08 	vstreq	d1, [ip, #-32]	; 0xffffffe0
    17f8:	2f060000 	svccs	0x00060000
    17fc:	00080d0e 	andeq	r0, r8, lr, lsl #26
    1800:	0005e500 	andeq	lr, r5, r0, lsl #10
    1804:	0005f000 	andeq	pc, r5, r0
    1808:	08241000 	stmdaeq	r4!, {ip}
    180c:	91110000 	tstls	r1, r0
    1810:	00000005 	andeq	r0, r0, r5
    1814:	00098d1c 	andeq	r8, r9, ip, lsl sp
    1818:	0e310600 	cfmsuba32eq	mvax0, mvax0, mvfx1, mvfx0
    181c:	00000922 	andeq	r0, r0, r2, lsr #18
    1820:	0000036e 	andeq	r0, r0, lr, ror #6
    1824:	00000608 	andeq	r0, r0, r8, lsl #12
    1828:	00000613 	andeq	r0, r0, r3, lsl r6
    182c:	00082410 	andeq	r2, r8, r0, lsl r4
    1830:	05971100 	ldreq	r1, [r7, #256]	; 0x100
    1834:	13000000 	movwne	r0, #0
    1838:	00001169 	andeq	r1, r0, r9, ror #2
    183c:	2b1d3506 	blcs	74ec5c <__bss_end+0x745518>
    1840:	9100000b 	tstls	r0, fp
    1844:	02000005 	andeq	r0, r0, #5
    1848:	0000062c 	andeq	r0, r0, ip, lsr #12
    184c:	00000632 	andeq	r0, r0, r2, lsr r6
    1850:	00082410 	andeq	r2, r8, r0, lsl r4
    1854:	c4130000 	ldrgt	r0, [r3], #-0
    1858:	06000007 	streq	r0, [r0], -r7
    185c:	0d1c1d37 	ldceq	13, cr1, [ip, #-220]	; 0xffffff24
    1860:	05910000 	ldreq	r0, [r1]
    1864:	4b020000 	blmi	8186c <__bss_end+0x78128>
    1868:	51000006 	tstpl	r0, r6
    186c:	10000006 	andne	r0, r0, r6
    1870:	00000824 	andeq	r0, r0, r4, lsr #16
    1874:	0c3b1d00 	ldceq	13, cr1, [fp], #-0
    1878:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
    187c:	00083d44 	andeq	r3, r8, r4, asr #26
    1880:	13020c00 	movwne	r0, #11264	; 0x2c00
    1884:	00000ec1 	andeq	r0, r0, r1, asr #29
    1888:	9c093c06 	stcls	12, cr3, [r9], {6}
    188c:	24000009 	strcs	r0, [r0], #-9
    1890:	01000008 	tsteq	r0, r8
    1894:	00000678 	andeq	r0, r0, r8, ror r6
    1898:	0000067e 	andeq	r0, r0, lr, ror r6
    189c:	00082410 	andeq	r2, r8, r0, lsl r4
    18a0:	5d130000 	ldcpl	0, cr0, [r3, #-0]
    18a4:	06000008 	streq	r0, [r0], -r8
    18a8:	05b0123f 	ldreq	r1, [r0, #575]!	; 0x23f
    18ac:	004d0000 	subeq	r0, sp, r0
    18b0:	97010000 	strls	r0, [r1, -r0]
    18b4:	ac000006 	stcge	0, cr0, [r0], {6}
    18b8:	10000006 	andne	r0, r0, r6
    18bc:	00000824 	andeq	r0, r0, r4, lsr #16
    18c0:	00084611 	andeq	r4, r8, r1, lsl r6
    18c4:	005e1100 	subseq	r1, lr, r0, lsl #2
    18c8:	6e110000 	cdpvs	0, 1, cr0, cr1, cr0, {0}
    18cc:	00000003 	andeq	r0, r0, r3
    18d0:	00119314 	andseq	r9, r1, r4, lsl r3
    18d4:	0e420600 	cdpeq	6, 4, cr0, cr2, cr0, {0}
    18d8:	000006cf 	andeq	r0, r0, pc, asr #13
    18dc:	0006c101 	andeq	ip, r6, r1, lsl #2
    18e0:	0006c700 	andeq	ip, r6, r0, lsl #14
    18e4:	08241000 	stmdaeq	r4!, {ip}
    18e8:	13000000 	movwne	r0, #0
    18ec:	00000592 	muleq	r0, r2, r5
    18f0:	4d174506 	cfldr32mi	mvfx4, [r7, #-24]	; 0xffffffe8
    18f4:	97000006 	strls	r0, [r0, -r6]
    18f8:	01000005 	tsteq	r0, r5
    18fc:	000006e0 	andeq	r0, r0, r0, ror #13
    1900:	000006e6 	andeq	r0, r0, r6, ror #13
    1904:	00084c10 	andeq	r4, r8, r0, lsl ip
    1908:	71130000 	tstvc	r3, r0
    190c:	0600000f 	streq	r0, [r0], -pc
    1910:	04071748 	streq	r1, [r7], #-1864	; 0xfffff8b8
    1914:	05970000 	ldreq	r0, [r7]
    1918:	ff010000 			; <UNDEFINED> instruction: 0xff010000
    191c:	0a000006 	beq	193c <shift+0x193c>
    1920:	10000007 	andne	r0, r0, r7
    1924:	0000084c 	andeq	r0, r0, ip, asr #16
    1928:	00004d11 	andeq	r4, r0, r1, lsl sp
    192c:	1d140000 	ldcne	0, cr0, [r4, #-0]
    1930:	06000007 	streq	r0, [r0], -r7
    1934:	0c490e4b 	mcrreq	14, 4, r0, r9, cr11
    1938:	1f010000 	svcne	0x00010000
    193c:	25000007 	strcs	r0, [r0, #-7]
    1940:	10000007 	andne	r0, r0, r7
    1944:	00000824 	andeq	r0, r0, r4, lsr #16
    1948:	098d1300 	stmibeq	sp, {r8, r9, ip}
    194c:	4d060000 	stcmi	0, cr0, [r6, #-0]
    1950:	000dc60e 	andeq	ip, sp, lr, lsl #12
    1954:	00036e00 	andeq	r6, r3, r0, lsl #28
    1958:	073e0100 	ldreq	r0, [lr, -r0, lsl #2]!
    195c:	07490000 	strbeq	r0, [r9, -r0]
    1960:	24100000 	ldrcs	r0, [r0], #-0
    1964:	11000008 	tstne	r0, r8
    1968:	0000004d 	andeq	r0, r0, sp, asr #32
    196c:	05091300 	streq	r1, [r9, #-768]	; 0xfffffd00
    1970:	50060000 	andpl	r0, r6, r0
    1974:	00043412 	andeq	r3, r4, r2, lsl r4
    1978:	00004d00 	andeq	r4, r0, r0, lsl #26
    197c:	07620100 	strbeq	r0, [r2, -r0, lsl #2]!
    1980:	076d0000 	strbeq	r0, [sp, -r0]!
    1984:	24100000 	ldrcs	r0, [r0], #-0
    1988:	11000008 	tstne	r0, r8
    198c:	0000039d 	muleq	r0, sp, r3
    1990:	04671300 	strbteq	r1, [r7], #-768	; 0xfffffd00
    1994:	53060000 	movwpl	r0, #24576	; 0x6000
    1998:	0011e90e 	andseq	lr, r1, lr, lsl #18
    199c:	00036e00 	andeq	r6, r3, r0, lsl #28
    19a0:	07860100 	streq	r0, [r6, r0, lsl #2]
    19a4:	07910000 	ldreq	r0, [r1, r0]
    19a8:	24100000 	ldrcs	r0, [r0], #-0
    19ac:	11000008 	tstne	r0, r8
    19b0:	0000004d 	andeq	r0, r0, sp, asr #32
    19b4:	04e31400 	strbteq	r1, [r3], #1024	; 0x400
    19b8:	56060000 	strpl	r0, [r6], -r0
    19bc:	00106b0e 	andseq	r6, r0, lr, lsl #22
    19c0:	07a60100 	streq	r0, [r6, r0, lsl #2]!
    19c4:	07c50000 	strbeq	r0, [r5, r0]
    19c8:	24100000 	ldrcs	r0, [r0], #-0
    19cc:	11000008 	tstne	r0, r8
    19d0:	000000a9 	andeq	r0, r0, r9, lsr #1
    19d4:	00004d11 	andeq	r4, r0, r1, lsl sp
    19d8:	004d1100 	subeq	r1, sp, r0, lsl #2
    19dc:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    19e0:	11000000 	mrsne	r0, (UNDEF: 0)
    19e4:	00000852 	andeq	r0, r0, r2, asr r8
    19e8:	12761400 	rsbsne	r1, r6, #0, 8
    19ec:	58060000 	stmdapl	r6, {}	; <UNPREDICTABLE>
    19f0:	0013660e 	andseq	r6, r3, lr, lsl #12
    19f4:	07da0100 	ldrbeq	r0, [sl, r0, lsl #2]
    19f8:	07f90000 	ldrbeq	r0, [r9, r0]!
    19fc:	24100000 	ldrcs	r0, [r0], #-0
    1a00:	11000008 	tstne	r0, r8
    1a04:	000000e0 	andeq	r0, r0, r0, ror #1
    1a08:	00004d11 	andeq	r4, r0, r1, lsl sp
    1a0c:	004d1100 	subeq	r1, sp, r0, lsl #2
    1a10:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1a14:	11000000 	mrsne	r0, (UNDEF: 0)
    1a18:	00000852 	andeq	r0, r0, r2, asr r8
    1a1c:	04f61500 	ldrbteq	r1, [r6], #1280	; 0x500
    1a20:	5b060000 	blpl	181a28 <__bss_end+0x1782e4>
    1a24:	000bab0e 	andeq	sl, fp, lr, lsl #22
    1a28:	00036e00 	andeq	r6, r3, r0, lsl #28
    1a2c:	080e0100 	stmdaeq	lr, {r8}
    1a30:	24100000 	ldrcs	r0, [r0], #-0
    1a34:	11000008 	tstne	r0, r8
    1a38:	00000514 	andeq	r0, r0, r4, lsl r5
    1a3c:	00085811 	andeq	r5, r8, r1, lsl r8
    1a40:	03000000 	movweq	r0, #0
    1a44:	0000059d 	muleq	r0, sp, r5
    1a48:	059d0418 	ldreq	r0, [sp, #1048]	; 0x418
    1a4c:	911e0000 	tstls	lr, r0
    1a50:	37000005 	strcc	r0, [r0, -r5]
    1a54:	3d000008 	stccc	0, cr0, [r0, #-32]	; 0xffffffe0
    1a58:	10000008 	andne	r0, r0, r8
    1a5c:	00000824 	andeq	r0, r0, r4, lsr #16
    1a60:	059d1f00 	ldreq	r1, [sp, #3840]	; 0xf00
    1a64:	082a0000 	stmdaeq	sl!, {}	; <UNPREDICTABLE>
    1a68:	04180000 	ldreq	r0, [r8], #-0
    1a6c:	0000003f 	andeq	r0, r0, pc, lsr r0
    1a70:	081f0418 	ldmdaeq	pc, {r3, r4, sl}	; <UNPREDICTABLE>
    1a74:	04200000 	strteq	r0, [r0], #-0
    1a78:	00000065 	andeq	r0, r0, r5, rrx
    1a7c:	d81a0421 	ldmdale	sl, {r0, r5, sl}
    1a80:	06000012 			; <UNDEFINED> instruction: 0x06000012
    1a84:	059d195e 	ldreq	r1, [sp, #2398]	; 0x95e
    1a88:	2c160000 	ldccs	0, cr0, [r6], {-0}
    1a8c:	76000000 	strvc	r0, [r0], -r0
    1a90:	17000008 	strne	r0, [r0, -r8]
    1a94:	0000005e 	andeq	r0, r0, lr, asr r0
    1a98:	66030009 	strvs	r0, [r3], -r9
    1a9c:	22000008 	andcs	r0, r0, #8
    1aa0:	000015bc 			; <UNDEFINED> instruction: 0x000015bc
    1aa4:	760ca401 	strvc	sl, [ip], -r1, lsl #8
    1aa8:	05000008 	streq	r0, [r0, #-8]
    1aac:	00945c03 	addseq	r5, r4, r3, lsl #24
    1ab0:	14de2300 	ldrbne	r2, [lr], #768	; 0x300
    1ab4:	a6010000 	strge	r0, [r1], -r0
    1ab8:	0016700a 	andseq	r7, r6, sl
    1abc:	00004d00 	andeq	r4, r0, r0, lsl #26
    1ac0:	0086ec00 	addeq	lr, r6, r0, lsl #24
    1ac4:	0000b400 	andeq	fp, r0, r0, lsl #8
    1ac8:	eb9c0100 	bl	fe701ed0 <__bss_end+0xfe6f878c>
    1acc:	24000008 	strcs	r0, [r0], #-8
    1ad0:	000023be 			; <UNDEFINED> instruction: 0x000023be
    1ad4:	7b1ba601 	blvc	6eb2e0 <__bss_end+0x6e1b9c>
    1ad8:	03000003 	movweq	r0, #3
    1adc:	247fac91 	ldrbtcs	sl, [pc], #-3217	; 1ae4 <shift+0x1ae4>
    1ae0:	000016cf 	andeq	r1, r0, pc, asr #13
    1ae4:	4d2aa601 	stcmi	6, cr10, [sl, #-4]!
    1ae8:	03000000 	movweq	r0, #0
    1aec:	227fa891 	rsbscs	sl, pc, #9502720	; 0x910000
    1af0:	00001658 	andeq	r1, r0, r8, asr r6
    1af4:	eb0aa801 	bl	2abb00 <__bss_end+0x2a23bc>
    1af8:	03000008 	movweq	r0, #8
    1afc:	227fb491 	rsbscs	fp, pc, #-1862270976	; 0x91000000
    1b00:	000014d9 	ldrdeq	r1, [r0], -r9
    1b04:	3809ac01 	stmdacc	r9, {r0, sl, fp, sp, pc}
    1b08:	02000000 	andeq	r0, r0, #0
    1b0c:	16007491 			; <UNDEFINED> instruction: 0x16007491
    1b10:	00000025 	andeq	r0, r0, r5, lsr #32
    1b14:	000008fb 	strdeq	r0, [r0], -fp
    1b18:	00005e17 	andeq	r5, r0, r7, lsl lr
    1b1c:	25003f00 	strcs	r3, [r0, #-3840]	; 0xfffff100
    1b20:	000016b4 			; <UNDEFINED> instruction: 0x000016b4
    1b24:	2b0a9801 	blcs	2a7b30 <__bss_end+0x29e3ec>
    1b28:	4d000017 	stcmi	0, cr0, [r0, #-92]	; 0xffffffa4
    1b2c:	b0000000 	andlt	r0, r0, r0
    1b30:	3c000086 	stccc	0, cr0, [r0], {134}	; 0x86
    1b34:	01000000 	mrseq	r0, (UNDEF: 0)
    1b38:	0009389c 	muleq	r9, ip, r8
    1b3c:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1b40:	9a010071 	bls	41d0c <__bss_end+0x385c8>
    1b44:	00055720 	andeq	r5, r5, r0, lsr #14
    1b48:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1b4c:	00166522 	andseq	r6, r6, r2, lsr #10
    1b50:	0e9b0100 	fmleqe	f0, f3, f0
    1b54:	0000004d 	andeq	r0, r0, sp, asr #32
    1b58:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1b5c:	0016de27 	andseq	sp, r6, r7, lsr #28
    1b60:	068f0100 	streq	r0, [pc], r0, lsl #2
    1b64:	000014fa 	strdeq	r1, [r0], -sl
    1b68:	00008674 	andeq	r8, r0, r4, ror r6
    1b6c:	0000003c 	andeq	r0, r0, ip, lsr r0
    1b70:	09719c01 	ldmdbeq	r1!, {r0, sl, fp, ip, pc}^
    1b74:	a8240000 	stmdage	r4!, {}	; <UNPREDICTABLE>
    1b78:	01000015 	tsteq	r0, r5, lsl r0
    1b7c:	004d218f 	subeq	r2, sp, pc, lsl #3
    1b80:	91020000 	mrsls	r0, (UNDEF: 2)
    1b84:	6572266c 	ldrbvs	r2, [r2, #-1644]!	; 0xfffff994
    1b88:	91010071 	tstls	r1, r1, ror r0
    1b8c:	00055720 	andeq	r5, r5, r0, lsr #14
    1b90:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1b94:	16912500 	ldrne	r2, [r1], r0, lsl #10
    1b98:	83010000 	movwhi	r0, #4096	; 0x1000
    1b9c:	0015d80a 	andseq	sp, r5, sl, lsl #16
    1ba0:	00004d00 	andeq	r4, r0, r0, lsl #26
    1ba4:	00863800 	addeq	r3, r6, r0, lsl #16
    1ba8:	00003c00 	andeq	r3, r0, r0, lsl #24
    1bac:	ae9c0100 	fmlgee	f0, f4, f0
    1bb0:	26000009 	strcs	r0, [r0], -r9
    1bb4:	00716572 	rsbseq	r6, r1, r2, ror r5
    1bb8:	33208501 			; <UNDEFINED> instruction: 0x33208501
    1bbc:	02000005 	andeq	r0, r0, #5
    1bc0:	d2227491 	eorle	r7, r2, #-1862270976	; 0x91000000
    1bc4:	01000014 	tsteq	r0, r4, lsl r0
    1bc8:	004d0e86 	subeq	r0, sp, r6, lsl #29
    1bcc:	91020000 	mrsls	r0, (UNDEF: 2)
    1bd0:	d3250070 			; <UNDEFINED> instruction: 0xd3250070
    1bd4:	01000017 	tsteq	r0, r7, lsl r0
    1bd8:	157e0a77 	ldrbne	r0, [lr, #-2679]!	; 0xfffff589
    1bdc:	004d0000 	subeq	r0, sp, r0
    1be0:	85fc0000 	ldrbhi	r0, [ip, #0]!
    1be4:	003c0000 	eorseq	r0, ip, r0
    1be8:	9c010000 	stcls	0, cr0, [r1], {-0}
    1bec:	000009eb 	andeq	r0, r0, fp, ror #19
    1bf0:	71657226 	cmnvc	r5, r6, lsr #4
    1bf4:	20790100 	rsbscs	r0, r9, r0, lsl #2
    1bf8:	00000533 	andeq	r0, r0, r3, lsr r5
    1bfc:	22749102 	rsbscs	r9, r4, #-2147483648	; 0x80000000
    1c00:	000014d2 	ldrdeq	r1, [r0], -r2
    1c04:	4d0e7a01 	vstrmi	s14, [lr, #-4]
    1c08:	02000000 	andeq	r0, r0, #0
    1c0c:	25007091 	strcs	r7, [r0, #-145]	; 0xffffff6f
    1c10:	000015ec 	andeq	r1, r0, ip, ror #11
    1c14:	fb066b01 	blx	19c822 <__bss_end+0x1930de>
    1c18:	6e000016 	mcrvs	0, 0, r0, cr0, cr6, {0}
    1c1c:	a8000003 	stmdage	r0, {r0, r1}
    1c20:	54000085 	strpl	r0, [r0], #-133	; 0xffffff7b
    1c24:	01000000 	mrseq	r0, (UNDEF: 0)
    1c28:	000a379c 	muleq	sl, ip, r7
    1c2c:	16652400 	strbtne	r2, [r5], -r0, lsl #8
    1c30:	6b010000 	blvs	41c38 <__bss_end+0x384f4>
    1c34:	00004d15 	andeq	r4, r0, r5, lsl sp
    1c38:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1c3c:	000d8124 	andeq	r8, sp, r4, lsr #2
    1c40:	256b0100 	strbcs	r0, [fp, #-256]!	; 0xffffff00
    1c44:	0000004d 	andeq	r0, r0, sp, asr #32
    1c48:	22689102 	rsbcs	r9, r8, #-2147483648	; 0x80000000
    1c4c:	000017cb 	andeq	r1, r0, fp, asr #15
    1c50:	4d0e6d01 	stcmi	13, cr6, [lr, #-4]
    1c54:	02000000 	andeq	r0, r0, #0
    1c58:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1c5c:	00001511 	andeq	r1, r0, r1, lsl r5
    1c60:	62125e01 	andsvs	r5, r2, #1, 28
    1c64:	8b000017 	blhi	1cc8 <shift+0x1cc8>
    1c68:	58000000 	stmdapl	r0, {}	; <UNPREDICTABLE>
    1c6c:	50000085 	andpl	r0, r0, r5, lsl #1
    1c70:	01000000 	mrseq	r0, (UNDEF: 0)
    1c74:	000a929c 	muleq	sl, ip, r2
    1c78:	13d72400 	bicsne	r2, r7, #0, 8
    1c7c:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1c80:	00004d20 	andeq	r4, r0, r0, lsr #26
    1c84:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1c88:	00169a24 	andseq	r9, r6, r4, lsr #20
    1c8c:	2f5e0100 	svccs	0x005e0100
    1c90:	0000004d 	andeq	r0, r0, sp, asr #32
    1c94:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1c98:	00000d81 	andeq	r0, r0, r1, lsl #27
    1c9c:	4d3f5e01 	ldcmi	14, cr5, [pc, #-4]!	; 1ca0 <shift+0x1ca0>
    1ca0:	02000000 	andeq	r0, r0, #0
    1ca4:	cb226491 	blgt	89aef0 <__bss_end+0x8917ac>
    1ca8:	01000017 	tsteq	r0, r7, lsl r0
    1cac:	008b1660 	addeq	r1, fp, r0, ror #12
    1cb0:	91020000 	mrsls	r0, (UNDEF: 2)
    1cb4:	5e250074 	mcrpl	0, 1, r0, cr5, cr4, {3}
    1cb8:	01000016 	tsteq	r0, r6, lsl r0
    1cbc:	15160a52 	ldrne	r0, [r6, #-2642]	; 0xfffff5ae
    1cc0:	004d0000 	subeq	r0, sp, r0
    1cc4:	85140000 	ldrhi	r0, [r4, #-0]
    1cc8:	00440000 	subeq	r0, r4, r0
    1ccc:	9c010000 	stcls	0, cr0, [r1], {-0}
    1cd0:	00000ade 	ldrdeq	r0, [r0], -lr
    1cd4:	0013d724 	andseq	sp, r3, r4, lsr #14
    1cd8:	1a520100 	bne	14820e0 <__bss_end+0x147899c>
    1cdc:	0000004d 	andeq	r0, r0, sp, asr #32
    1ce0:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1ce4:	0000169a 	muleq	r0, sl, r6
    1ce8:	4d295201 	sfmmi	f5, 4, [r9, #-4]!
    1cec:	02000000 	andeq	r0, r0, #0
    1cf0:	91226891 			; <UNDEFINED> instruction: 0x91226891
    1cf4:	01000017 	tsteq	r0, r7, lsl r0
    1cf8:	004d0e54 	subeq	r0, sp, r4, asr lr
    1cfc:	91020000 	mrsls	r0, (UNDEF: 2)
    1d00:	8b250074 	blhi	941ed8 <__bss_end+0x938794>
    1d04:	01000017 	tsteq	r0, r7, lsl r0
    1d08:	176d0a45 	strbne	r0, [sp, -r5, asr #20]!
    1d0c:	004d0000 	subeq	r0, sp, r0
    1d10:	84c40000 	strbhi	r0, [r4], #0
    1d14:	00500000 	subseq	r0, r0, r0
    1d18:	9c010000 	stcls	0, cr0, [r1], {-0}
    1d1c:	00000b39 	andeq	r0, r0, r9, lsr fp
    1d20:	0013d724 	andseq	sp, r3, r4, lsr #14
    1d24:	19450100 	stmdbne	r5, {r8}^
    1d28:	0000004d 	andeq	r0, r0, sp, asr #32
    1d2c:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1d30:	00001639 	andeq	r1, r0, r9, lsr r6
    1d34:	1d304501 	cfldr32ne	mvfx4, [r0, #-4]!
    1d38:	02000001 	andeq	r0, r0, #1
    1d3c:	a0246891 	mlage	r4, r1, r8, r6
    1d40:	01000016 	tsteq	r0, r6, lsl r0
    1d44:	08584145 	ldmdaeq	r8, {r0, r2, r6, r8, lr}^
    1d48:	91020000 	mrsls	r0, (UNDEF: 2)
    1d4c:	17cb2264 	strbne	r2, [fp, r4, ror #4]
    1d50:	47010000 	strmi	r0, [r1, -r0]
    1d54:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1d58:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1d5c:	13dc2700 	bicsne	r2, ip, #0, 14
    1d60:	3f010000 	svccc	0x00010000
    1d64:	00164306 	andseq	r4, r6, r6, lsl #6
    1d68:	00849800 	addeq	r9, r4, r0, lsl #16
    1d6c:	00002c00 	andeq	r2, r0, r0, lsl #24
    1d70:	639c0100 	orrsvs	r0, ip, #0, 2
    1d74:	2400000b 	strcs	r0, [r0], #-11
    1d78:	000013d7 	ldrdeq	r1, [r0], -r7
    1d7c:	4d153f01 	ldcmi	15, cr3, [r5, #-4]
    1d80:	02000000 	andeq	r0, r0, #0
    1d84:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1d88:	000016d8 	ldrdeq	r1, [r0], -r8
    1d8c:	a60a3201 	strge	r3, [sl], -r1, lsl #4
    1d90:	4d000016 	stcmi	0, cr0, [r0, #-88]	; 0xffffffa8
    1d94:	48000000 	stmdami	r0, {}	; <UNPREDICTABLE>
    1d98:	50000084 	andpl	r0, r0, r4, lsl #1
    1d9c:	01000000 	mrseq	r0, (UNDEF: 0)
    1da0:	000bbe9c 	muleq	fp, ip, lr
    1da4:	13d72400 	bicsne	r2, r7, #0, 8
    1da8:	32010000 	andcc	r0, r1, #0
    1dac:	00004d19 	andeq	r4, r0, r9, lsl sp
    1db0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1db4:	0017a724 	andseq	sl, r7, r4, lsr #14
    1db8:	2b320100 	blcs	c821c0 <__bss_end+0xc78a7c>
    1dbc:	0000037b 	andeq	r0, r0, fp, ror r3
    1dc0:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1dc4:	000016d3 	ldrdeq	r1, [r0], -r3
    1dc8:	4d3c3201 	lfmmi	f3, 4, [ip, #-4]!
    1dcc:	02000000 	andeq	r0, r0, #0
    1dd0:	5c226491 	cfstrspl	mvf6, [r2], #-580	; 0xfffffdbc
    1dd4:	01000017 	tsteq	r0, r7, lsl r0
    1dd8:	004d0e34 	subeq	r0, sp, r4, lsr lr
    1ddc:	91020000 	mrsls	r0, (UNDEF: 2)
    1de0:	f5250074 			; <UNDEFINED> instruction: 0xf5250074
    1de4:	01000017 	tsteq	r0, r7, lsl r0
    1de8:	17ae0a25 	strne	r0, [lr, r5, lsr #20]!
    1dec:	004d0000 	subeq	r0, sp, r0
    1df0:	83f80000 	mvnshi	r0, #0
    1df4:	00500000 	subseq	r0, r0, r0
    1df8:	9c010000 	stcls	0, cr0, [r1], {-0}
    1dfc:	00000c19 	andeq	r0, r0, r9, lsl ip
    1e00:	0013d724 	andseq	sp, r3, r4, lsr #14
    1e04:	18250100 	stmdane	r5!, {r8}
    1e08:	0000004d 	andeq	r0, r0, sp, asr #32
    1e0c:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1e10:	000017a7 	andeq	r1, r0, r7, lsr #15
    1e14:	1f2a2501 	svcne	0x002a2501
    1e18:	0200000c 	andeq	r0, r0, #12
    1e1c:	d3246891 			; <UNDEFINED> instruction: 0xd3246891
    1e20:	01000016 	tsteq	r0, r6, lsl r0
    1e24:	004d3b25 	subeq	r3, sp, r5, lsr #22
    1e28:	91020000 	mrsls	r0, (UNDEF: 2)
    1e2c:	14e32264 	strbtne	r2, [r3], #612	; 0x264
    1e30:	27010000 	strcs	r0, [r1, -r0]
    1e34:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1e38:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1e3c:	25041800 	strcs	r1, [r4, #-2048]	; 0xfffff800
    1e40:	03000000 	movweq	r0, #0
    1e44:	00000c19 	andeq	r0, r0, r9, lsl ip
    1e48:	00166b25 	andseq	r6, r6, r5, lsr #22
    1e4c:	0a190100 	beq	642254 <__bss_end+0x638b10>
    1e50:	00001801 	andeq	r1, r0, r1, lsl #16
    1e54:	0000004d 	andeq	r0, r0, sp, asr #32
    1e58:	000083b4 			; <UNDEFINED> instruction: 0x000083b4
    1e5c:	00000044 	andeq	r0, r0, r4, asr #32
    1e60:	0c709c01 	ldcleq	12, cr9, [r0], #-4
    1e64:	ec240000 	stc	0, cr0, [r4], #-0
    1e68:	01000017 	tsteq	r0, r7, lsl r0
    1e6c:	037b1b19 	cmneq	fp, #25600	; 0x6400
    1e70:	91020000 	mrsls	r0, (UNDEF: 2)
    1e74:	17a2246c 	strne	r2, [r2, ip, ror #8]!
    1e78:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    1e7c:	0001c635 	andeq	ip, r1, r5, lsr r6
    1e80:	68910200 	ldmvs	r1, {r9}
    1e84:	0013d722 	andseq	sp, r3, r2, lsr #14
    1e88:	0e1b0100 	mufeqe	f0, f3, f0
    1e8c:	0000004d 	andeq	r0, r0, sp, asr #32
    1e90:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1e94:	00159c28 	andseq	r9, r5, r8, lsr #24
    1e98:	06140100 	ldreq	r0, [r4], -r0, lsl #2
    1e9c:	000014e9 	andeq	r1, r0, r9, ror #9
    1ea0:	00008398 	muleq	r0, r8, r3
    1ea4:	0000001c 	andeq	r0, r0, ip, lsl r0
    1ea8:	98279c01 	stmdals	r7!, {r0, sl, fp, ip, pc}
    1eac:	01000017 	tsteq	r0, r7, lsl r0
    1eb0:	1522060e 	strne	r0, [r2, #-1550]!	; 0xfffff9f2
    1eb4:	836c0000 	cmnhi	ip, #0
    1eb8:	002c0000 	eoreq	r0, ip, r0
    1ebc:	9c010000 	stcls	0, cr0, [r1], {-0}
    1ec0:	00000cb0 			; <UNDEFINED> instruction: 0x00000cb0
    1ec4:	00157524 	andseq	r7, r5, r4, lsr #10
    1ec8:	140e0100 	strne	r0, [lr], #-256	; 0xffffff00
    1ecc:	00000038 	andeq	r0, r0, r8, lsr r0
    1ed0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1ed4:	0017fa29 	andseq	pc, r7, r9, lsr #20
    1ed8:	0a040100 	beq	1022e0 <__bss_end+0xf8b9c>
    1edc:	0000164d 	andeq	r1, r0, sp, asr #12
    1ee0:	0000004d 	andeq	r0, r0, sp, asr #32
    1ee4:	00008340 	andeq	r8, r0, r0, asr #6
    1ee8:	0000002c 	andeq	r0, r0, ip, lsr #32
    1eec:	70269c01 	eorvc	r9, r6, r1, lsl #24
    1ef0:	01006469 	tsteq	r0, r9, ror #8
    1ef4:	004d0e06 	subeq	r0, sp, r6, lsl #28
    1ef8:	91020000 	mrsls	r0, (UNDEF: 2)
    1efc:	2e000074 	mcrcs	0, 0, r0, cr0, cr4, {3}
    1f00:	04000003 	streq	r0, [r0], #-3
    1f04:	00072400 	andeq	r2, r7, r0, lsl #8
    1f08:	ef010400 	svc	0x00010400
    1f0c:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
    1f10:	00001841 	andeq	r1, r0, r1, asr #16
    1f14:	000015f2 	strdeq	r1, [r0], -r2
    1f18:	000087a0 	andeq	r8, r0, r0, lsr #15
    1f1c:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
    1f20:	0000075f 	andeq	r0, r0, pc, asr r7
    1f24:	00004902 	andeq	r4, r0, r2, lsl #18
    1f28:	18830300 	stmne	r3, {r8, r9}
    1f2c:	05010000 	streq	r0, [r1, #-0]
    1f30:	00006110 	andeq	r6, r0, r0, lsl r1
    1f34:	31301100 	teqcc	r0, r0, lsl #2
    1f38:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
    1f3c:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
    1f40:	44434241 	strbmi	r4, [r3], #-577	; 0xfffffdbf
    1f44:	00004645 	andeq	r4, r0, r5, asr #12
    1f48:	01030104 	tsteq	r3, r4, lsl #2
    1f4c:	00000025 	andeq	r0, r0, r5, lsr #32
    1f50:	00007405 	andeq	r7, r0, r5, lsl #8
    1f54:	00006100 	andeq	r6, r0, r0, lsl #2
    1f58:	00660600 	rsbeq	r0, r6, r0, lsl #12
    1f5c:	00100000 	andseq	r0, r0, r0
    1f60:	00005107 	andeq	r5, r0, r7, lsl #2
    1f64:	07040800 	streq	r0, [r4, -r0, lsl #16]
    1f68:	00001fd6 	ldrdeq	r1, [r0], -r6
    1f6c:	09080108 	stmdbeq	r8, {r3, r8}
    1f70:	07000011 	smladeq	r0, r1, r0, r0
    1f74:	0000006d 	andeq	r0, r0, sp, rrx
    1f78:	00002a09 	andeq	r2, r0, r9, lsl #20
    1f7c:	18b20a00 	ldmne	r2!, {r9, fp}
    1f80:	64010000 	strvs	r0, [r1], #-0
    1f84:	00189d06 	andseq	r9, r8, r6, lsl #26
    1f88:	008bd800 	addeq	sp, fp, r0, lsl #16
    1f8c:	00008000 	andeq	r8, r0, r0
    1f90:	fb9c0100 	blx	fe70239a <__bss_end+0xfe6f8c56>
    1f94:	0b000000 	bleq	1f9c <shift+0x1f9c>
    1f98:	00637273 	rsbeq	r7, r3, r3, ror r2
    1f9c:	fb196401 	blx	65afaa <__bss_end+0x651866>
    1fa0:	02000000 	andeq	r0, r0, #0
    1fa4:	640b6491 	strvs	r6, [fp], #-1169	; 0xfffffb6f
    1fa8:	01007473 	tsteq	r0, r3, ror r4
    1fac:	01022464 	tsteq	r2, r4, ror #8
    1fb0:	91020000 	mrsls	r0, (UNDEF: 2)
    1fb4:	756e0b60 	strbvc	r0, [lr, #-2912]!	; 0xfffff4a0
    1fb8:	6401006d 	strvs	r0, [r1], #-109	; 0xffffff93
    1fbc:	0001042d 	andeq	r0, r1, sp, lsr #8
    1fc0:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1fc4:	0019170c 	andseq	r1, r9, ip, lsl #14
    1fc8:	0e660100 	poweqs	f0, f6, f0
    1fcc:	0000010b 	andeq	r0, r0, fp, lsl #2
    1fd0:	0c709102 	ldfeqp	f1, [r0], #-8
    1fd4:	0000188f 	andeq	r1, r0, pc, lsl #17
    1fd8:	11086701 	tstne	r8, r1, lsl #14
    1fdc:	02000001 	andeq	r0, r0, #1
    1fe0:	000d6c91 	muleq	sp, r1, ip
    1fe4:	4800008c 	stmdami	r0, {r2, r3, r7}
    1fe8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1fec:	69010069 	stmdbvs	r1, {r0, r3, r5, r6}
    1ff0:	0001040b 	andeq	r0, r1, fp, lsl #8
    1ff4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1ff8:	040f0000 	streq	r0, [pc], #-0	; 2000 <shift+0x2000>
    1ffc:	00000101 	andeq	r0, r0, r1, lsl #2
    2000:	12041110 	andne	r1, r4, #16, 2
    2004:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    2008:	040f0074 	streq	r0, [pc], #-116	; 2010 <shift+0x2010>
    200c:	00000074 	andeq	r0, r0, r4, ror r0
    2010:	006d040f 	rsbeq	r0, sp, pc, lsl #8
    2014:	280a0000 	stmdacs	sl, {}	; <UNPREDICTABLE>
    2018:	01000018 	tsteq	r0, r8, lsl r0
    201c:	1835065c 	ldmdane	r5!, {r2, r3, r4, r6, r9, sl}
    2020:	8b700000 	blhi	1c02028 <__bss_end+0x1bf88e4>
    2024:	00680000 	rsbeq	r0, r8, r0
    2028:	9c010000 	stcls	0, cr0, [r1], {-0}
    202c:	00000176 	andeq	r0, r0, r6, ror r1
    2030:	00191013 	andseq	r1, r9, r3, lsl r0
    2034:	125c0100 	subsne	r0, ip, #0, 2
    2038:	00000102 	andeq	r0, r0, r2, lsl #2
    203c:	136c9102 	cmnne	ip, #-2147483648	; 0x80000000
    2040:	0000182e 	andeq	r1, r0, lr, lsr #16
    2044:	041e5c01 	ldreq	r5, [lr], #-3073	; 0xfffff3ff
    2048:	02000001 	andeq	r0, r0, #1
    204c:	6d0e6891 	stcvs	8, cr6, [lr, #-580]	; 0xfffffdbc
    2050:	01006d65 	tsteq	r0, r5, ror #26
    2054:	0111085e 	tsteq	r1, lr, asr r8
    2058:	91020000 	mrsls	r0, (UNDEF: 2)
    205c:	8b8c0d70 	blhi	fe305624 <__bss_end+0xfe2fbee0>
    2060:	003c0000 	eorseq	r0, ip, r0
    2064:	690e0000 	stmdbvs	lr, {}	; <UNPREDICTABLE>
    2068:	0b600100 	bleq	1802470 <__bss_end+0x17f8d2c>
    206c:	00000104 	andeq	r0, r0, r4, lsl #2
    2070:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2074:	18b91400 	ldmne	r9!, {sl, ip}
    2078:	52010000 	andpl	r0, r1, #0
    207c:	0018d205 	andseq	sp, r8, r5, lsl #4
    2080:	00010400 	andeq	r0, r1, r0, lsl #8
    2084:	008b1c00 	addeq	r1, fp, r0, lsl #24
    2088:	00005400 	andeq	r5, r0, r0, lsl #8
    208c:	af9c0100 	svcge	0x009c0100
    2090:	0b000001 	bleq	209c <shift+0x209c>
    2094:	52010073 	andpl	r0, r1, #115	; 0x73
    2098:	00010b18 	andeq	r0, r1, r8, lsl fp
    209c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    20a0:	0100690e 	tsteq	r0, lr, lsl #18
    20a4:	01040654 	tsteq	r4, r4, asr r6
    20a8:	91020000 	mrsls	r0, (UNDEF: 2)
    20ac:	00140074 	andseq	r0, r4, r4, ror r0
    20b0:	01000019 	tsteq	r0, r9, lsl r0
    20b4:	18c00542 	stmiane	r0, {r1, r6, r8, sl}^
    20b8:	01040000 	mrseq	r0, (UNDEF: 4)
    20bc:	8a700000 	bhi	1c020c4 <__bss_end+0x1bf8980>
    20c0:	00ac0000 	adceq	r0, ip, r0
    20c4:	9c010000 	stcls	0, cr0, [r1], {-0}
    20c8:	00000215 	andeq	r0, r0, r5, lsl r2
    20cc:	0031730b 	eorseq	r7, r1, fp, lsl #6
    20d0:	0b194201 	bleq	6528dc <__bss_end+0x649198>
    20d4:	02000001 	andeq	r0, r0, #1
    20d8:	730b6c91 	movwvc	r6, #48273	; 0xbc91
    20dc:	42010032 	andmi	r0, r1, #50	; 0x32
    20e0:	00010b29 	andeq	r0, r1, r9, lsr #22
    20e4:	68910200 	ldmvs	r1, {r9}
    20e8:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    20ec:	31420100 	mrscc	r0, (UNDEF: 82)
    20f0:	00000104 	andeq	r0, r0, r4, lsl #2
    20f4:	0e649102 	lgneqs	f1, f2
    20f8:	01003175 	tsteq	r0, r5, ror r1
    20fc:	02151044 	andseq	r1, r5, #68	; 0x44
    2100:	91020000 	mrsls	r0, (UNDEF: 2)
    2104:	32750e77 	rsbscc	r0, r5, #1904	; 0x770
    2108:	14440100 	strbne	r0, [r4], #-256	; 0xffffff00
    210c:	00000215 	andeq	r0, r0, r5, lsl r2
    2110:	00769102 	rsbseq	r9, r6, r2, lsl #2
    2114:	00080108 	andeq	r0, r8, r8, lsl #2
    2118:	14000011 	strne	r0, [r0], #-17	; 0xffffffef
    211c:	00001908 	andeq	r1, r0, r8, lsl #18
    2120:	ef073601 	svc	0x00073601
    2124:	11000018 	tstne	r0, r8, lsl r0
    2128:	b0000001 	andlt	r0, r0, r1
    212c:	c0000089 	andgt	r0, r0, r9, lsl #1
    2130:	01000000 	mrseq	r0, (UNDEF: 0)
    2134:	0002759c 	muleq	r2, ip, r5
    2138:	18231300 	stmdane	r3!, {r8, r9, ip}
    213c:	36010000 	strcc	r0, [r1], -r0
    2140:	00011115 	andeq	r1, r1, r5, lsl r1
    2144:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2148:	6372730b 	cmnvs	r2, #738197504	; 0x2c000000
    214c:	27360100 	ldrcs	r0, [r6, -r0, lsl #2]!
    2150:	0000010b 	andeq	r0, r0, fp, lsl #2
    2154:	0b689102 	bleq	1a26564 <__bss_end+0x1a1ce20>
    2158:	006d756e 	rsbeq	r7, sp, lr, ror #10
    215c:	04303601 	ldrteq	r3, [r0], #-1537	; 0xfffff9ff
    2160:	02000001 	andeq	r0, r0, #1
    2164:	690e6491 	stmdbvs	lr, {r0, r4, r7, sl, sp, lr}
    2168:	06380100 	ldrteq	r0, [r8], -r0, lsl #2
    216c:	00000104 	andeq	r0, r0, r4, lsl #2
    2170:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2174:	0018df14 	andseq	sp, r8, r4, lsl pc
    2178:	05240100 	streq	r0, [r4, #-256]!	; 0xffffff00
    217c:	000018e4 	andeq	r1, r0, r4, ror #17
    2180:	00000104 	andeq	r0, r0, r4, lsl #2
    2184:	00008914 	andeq	r8, r0, r4, lsl r9
    2188:	0000009c 	muleq	r0, ip, r0
    218c:	02b29c01 	adcseq	r9, r2, #256	; 0x100
    2190:	1d130000 	ldcne	0, cr0, [r3, #-0]
    2194:	01000018 	tsteq	r0, r8, lsl r0
    2198:	010b1624 	tsteq	fp, r4, lsr #12
    219c:	91020000 	mrsls	r0, (UNDEF: 2)
    21a0:	18960c6c 	ldmne	r6, {r2, r3, r5, r6, sl, fp}
    21a4:	26010000 	strcs	r0, [r1], -r0
    21a8:	00010406 	andeq	r0, r1, r6, lsl #8
    21ac:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    21b0:	191e1500 	ldmdbne	lr, {r8, sl, ip}
    21b4:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    21b8:	00192306 	andseq	r2, r9, r6, lsl #6
    21bc:	0087a000 	addeq	sl, r7, r0
    21c0:	00017400 	andeq	r7, r1, r0, lsl #8
    21c4:	139c0100 	orrsne	r0, ip, #0, 2
    21c8:	0000181d 	andeq	r1, r0, sp, lsl r8
    21cc:	66180801 	ldrvs	r0, [r8], -r1, lsl #16
    21d0:	02000000 	andeq	r0, r0, #0
    21d4:	96136491 			; <UNDEFINED> instruction: 0x96136491
    21d8:	01000018 	tsteq	r0, r8, lsl r0
    21dc:	01112508 	tsteq	r1, r8, lsl #10
    21e0:	91020000 	mrsls	r0, (UNDEF: 2)
    21e4:	18ad1360 	stmiane	sp!, {r5, r6, r8, r9, ip}
    21e8:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    21ec:	0000663a 	andeq	r6, r0, sl, lsr r6
    21f0:	5c910200 	lfmpl	f0, 4, [r1], {0}
    21f4:	0100690e 	tsteq	r0, lr, lsl #18
    21f8:	0104060a 	tsteq	r4, sl, lsl #12
    21fc:	91020000 	mrsls	r0, (UNDEF: 2)
    2200:	886c0d74 	stmdahi	ip!, {r2, r4, r5, r6, r8, sl, fp}^
    2204:	00980000 	addseq	r0, r8, r0
    2208:	6a0e0000 	bvs	382210 <__bss_end+0x378acc>
    220c:	0b1c0100 	bleq	702614 <__bss_end+0x6f8ed0>
    2210:	00000104 	andeq	r0, r0, r4, lsl #2
    2214:	0d709102 	ldfeqp	f1, [r0, #-8]!
    2218:	00008894 	muleq	r0, r4, r8
    221c:	00000060 	andeq	r0, r0, r0, rrx
    2220:	0100630e 	tsteq	r0, lr, lsl #6
    2224:	006d081e 	rsbeq	r0, sp, lr, lsl r8
    2228:	91020000 	mrsls	r0, (UNDEF: 2)
    222c:	0000006f 	andeq	r0, r0, pc, rrx
    2230:	00112600 	andseq	r2, r1, r0, lsl #12
    2234:	4b000400 	blmi	323c <shift+0x323c>
    2238:	04000008 	streq	r0, [r0], #-8
    223c:	0013ef01 	andseq	lr, r3, r1, lsl #30
    2240:	1a0a0400 	bne	283248 <__bss_end+0x279b04>
    2244:	15f20000 	ldrbne	r0, [r2, #0]!
    2248:	8c580000 	mrahi	r0, r8, acc0
    224c:	04b40000 	ldrteq	r0, [r4], #0
    2250:	09950000 	ldmibeq	r5, {}	; <UNPREDICTABLE>
    2254:	01020000 	mrseq	r0, (UNDEF: 2)
    2258:	00110908 	andseq	r0, r1, r8, lsl #18
    225c:	00250300 	eoreq	r0, r5, r0, lsl #6
    2260:	02020000 	andeq	r0, r2, #0
    2264:	000e4a05 	andeq	r4, lr, r5, lsl #20
    2268:	05040400 	streq	r0, [r4, #-1024]	; 0xfffffc00
    226c:	00746e69 	rsbseq	r6, r4, r9, ror #28
    2270:	00003803 	andeq	r3, r0, r3, lsl #16
    2274:	1abe0500 	bne	fef8367c <__bss_end+0xfef79f38>
    2278:	07020000 	streq	r0, [r2, -r0]
    227c:	0000551e 	andeq	r5, r0, lr, lsl r5
    2280:	00440300 	subeq	r0, r4, r0, lsl #6
    2284:	01020000 	mrseq	r0, (UNDEF: 2)
    2288:	00110008 	andseq	r0, r1, r8
    228c:	0d930500 	cfldr32eq	mvfx0, [r3]
    2290:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    2294:	00006d20 	andeq	r6, r0, r0, lsr #26
    2298:	005c0300 	subseq	r0, ip, r0, lsl #6
    229c:	02020000 	andeq	r0, r2, #0
    22a0:	0012bb07 	andseq	fp, r2, r7, lsl #22
    22a4:	073b0500 	ldreq	r0, [fp, -r0, lsl #10]!
    22a8:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
    22ac:	0000851e 	andeq	r8, r0, lr, lsl r5
    22b0:	00740300 	rsbseq	r0, r4, r0, lsl #6
    22b4:	04020000 	streq	r0, [r2], #-0
    22b8:	001fd607 	andseq	sp, pc, r7, lsl #12
    22bc:	00850300 	addeq	r0, r5, r0, lsl #6
    22c0:	55060000 	strpl	r0, [r6, #-0]
    22c4:	0800000e 	stmdaeq	r0, {r1, r2, r3}
    22c8:	d5070603 	strle	r0, [r7, #-1539]	; 0xfffff9fd
    22cc:	07000001 	streq	r0, [r0, -r1]
    22d0:	00000972 	andeq	r0, r0, r2, ror r9
    22d4:	74120a03 	ldrvc	r0, [r2], #-2563	; 0xfffff5fd
    22d8:	00000000 	andeq	r0, r0, r0
    22dc:	000da907 	andeq	sl, sp, r7, lsl #18
    22e0:	0e0c0300 	cdpeq	3, 0, cr0, cr12, cr0, {0}
    22e4:	000001da 	ldrdeq	r0, [r0], -sl
    22e8:	0e550804 	cdpeq	8, 5, cr0, cr5, cr4, {0}
    22ec:	10030000 	andne	r0, r3, r0
    22f0:	0006f009 	andeq	pc, r6, r9
    22f4:	0001e600 	andeq	lr, r1, r0, lsl #12
    22f8:	00d10100 	sbcseq	r0, r1, r0, lsl #2
    22fc:	00dc0000 	sbcseq	r0, ip, r0
    2300:	e6090000 	str	r0, [r9], -r0
    2304:	0a000001 	beq	2310 <shift+0x2310>
    2308:	000001f1 	strdeq	r0, [r0], -r1
    230c:	0e540800 	cdpeq	8, 5, cr0, cr4, cr0, {0}
    2310:	12030000 	andne	r0, r3, #0
    2314:	000e0c15 	andeq	r0, lr, r5, lsl ip
    2318:	0001f700 	andeq	pc, r1, r0, lsl #14
    231c:	00f50100 	rscseq	r0, r5, r0, lsl #2
    2320:	01000000 	mrseq	r0, (UNDEF: 0)
    2324:	e6090000 	str	r0, [r9], -r0
    2328:	09000001 	stmdbeq	r0, {r0}
    232c:	00000038 	andeq	r0, r0, r8, lsr r0
    2330:	07090800 	streq	r0, [r9, -r0, lsl #16]
    2334:	15030000 	strne	r0, [r3, #-0]
    2338:	000a320e 	andeq	r3, sl, lr, lsl #4
    233c:	0001da00 	andeq	sp, r1, r0, lsl #20
    2340:	01190100 	tsteq	r9, r0, lsl #2
    2344:	011f0000 	tsteq	pc, r0
    2348:	f9090000 			; <UNDEFINED> instruction: 0xf9090000
    234c:	00000001 	andeq	r0, r0, r1
    2350:	000ff60b 	andeq	pc, pc, fp, lsl #12
    2354:	0e180300 	cdpeq	3, 1, cr0, cr8, cr0, {0}
    2358:	00000908 	andeq	r0, r0, r8, lsl #18
    235c:	00013401 	andeq	r3, r1, r1, lsl #8
    2360:	00013a00 	andeq	r3, r1, r0, lsl #20
    2364:	01e60900 	mvneq	r0, r0, lsl #18
    2368:	0b000000 	bleq	2370 <shift+0x2370>
    236c:	00000a2c 	andeq	r0, r0, ip, lsr #20
    2370:	850e1b03 	strhi	r1, [lr, #-2819]	; 0xfffff4fd
    2374:	01000007 	tsteq	r0, r7
    2378:	0000014f 	andeq	r0, r0, pc, asr #2
    237c:	0000015a 	andeq	r0, r0, sl, asr r1
    2380:	0001e609 	andeq	lr, r1, r9, lsl #12
    2384:	01da0a00 	bicseq	r0, sl, r0, lsl #20
    2388:	0b000000 	bleq	2390 <shift+0x2390>
    238c:	000010e8 	andeq	r1, r0, r8, ror #1
    2390:	c80e1d03 	stmdagt	lr, {r0, r1, r8, sl, fp, ip}
    2394:	01000011 	tsteq	r0, r1, lsl r0
    2398:	0000016f 	andeq	r0, r0, pc, ror #2
    239c:	00000184 	andeq	r0, r0, r4, lsl #3
    23a0:	0001e609 	andeq	lr, r1, r9, lsl #12
    23a4:	005c0a00 	subseq	r0, ip, r0, lsl #20
    23a8:	5c0a0000 	stcpl	0, cr0, [sl], {-0}
    23ac:	0a000000 	beq	23b4 <shift+0x23b4>
    23b0:	000001da 	ldrdeq	r0, [r0], -sl
    23b4:	07aa0b00 	streq	r0, [sl, r0, lsl #22]!
    23b8:	1f030000 	svcne	0x00030000
    23bc:	0005e00e 	andeq	lr, r5, lr
    23c0:	01990100 	orrseq	r0, r9, r0, lsl #2
    23c4:	01ae0000 			; <UNDEFINED> instruction: 0x01ae0000
    23c8:	e6090000 	str	r0, [r9], -r0
    23cc:	0a000001 	beq	23d8 <shift+0x23d8>
    23d0:	0000005c 	andeq	r0, r0, ip, asr r0
    23d4:	00005c0a 	andeq	r5, r0, sl, lsl #24
    23d8:	00250a00 	eoreq	r0, r5, r0, lsl #20
    23dc:	0c000000 	stceq	0, cr0, [r0], {-0}
    23e0:	000012e4 	andeq	r1, r0, r4, ror #5
    23e4:	a80e2103 	stmdage	lr, {r0, r1, r8, sp}
    23e8:	0100000f 	tsteq	r0, pc
    23ec:	000001bf 			; <UNDEFINED> instruction: 0x000001bf
    23f0:	0001e609 	andeq	lr, r1, r9, lsl #12
    23f4:	005c0a00 	subseq	r0, ip, r0, lsl #20
    23f8:	5c0a0000 	stcpl	0, cr0, [sl], {-0}
    23fc:	0a000000 	beq	2404 <shift+0x2404>
    2400:	000001f1 	strdeq	r0, [r0], -r1
    2404:	91030000 	mrsls	r0, (UNDEF: 3)
    2408:	02000000 	andeq	r0, r0, #0
    240c:	0ba60201 	bleq	fe982c18 <__bss_end+0xfe9794d4>
    2410:	da030000 	ble	c2418 <__bss_end+0xb8cd4>
    2414:	0d000001 	stceq	0, cr0, [r0, #-4]
    2418:	00009104 	andeq	r9, r0, r4, lsl #2
    241c:	01e60300 	mvneq	r0, r0, lsl #6
    2420:	040d0000 	streq	r0, [sp], #-0
    2424:	0000002c 	andeq	r0, r0, ip, lsr #32
    2428:	040d040e 	streq	r0, [sp], #-1038	; 0xfffffbf2
    242c:	000001d5 	ldrdeq	r0, [r0], -r5
    2430:	0001f903 	andeq	pc, r1, r3, lsl #18
    2434:	13b20f00 			; <UNDEFINED> instruction: 0x13b20f00
    2438:	04080000 	streq	r0, [r8], #-0
    243c:	022a0806 	eoreq	r0, sl, #393216	; 0x60000
    2440:	72100000 	andsvc	r0, r0, #0
    2444:	08040030 	stmdaeq	r4, {r4, r5}
    2448:	0000740e 	andeq	r7, r0, lr, lsl #8
    244c:	72100000 	andsvc	r0, r0, #0
    2450:	09040031 	stmdbeq	r4, {r0, r4, r5}
    2454:	0000740e 	andeq	r7, r0, lr, lsl #8
    2458:	11000400 	tstne	r0, r0, lsl #8
    245c:	00000f3e 	andeq	r0, r0, lr, lsr pc
    2460:	00380405 	eorseq	r0, r8, r5, lsl #8
    2464:	1e040000 	cdpne	0, 0, cr0, cr4, cr0, {0}
    2468:	0002610c 	andeq	r6, r2, ip, lsl #2
    246c:	07331200 	ldreq	r1, [r3, -r0, lsl #4]!
    2470:	12000000 	andne	r0, r0, #0
    2474:	0000097a 	andeq	r0, r0, sl, ror r9
    2478:	0f601201 	svceq	0x00601201
    247c:	12020000 	andne	r0, r2, #0
    2480:	0000111c 	andeq	r1, r0, ip, lsl r1
    2484:	09581203 	ldmdbeq	r8, {r0, r1, r9, ip}^
    2488:	12040000 	andne	r0, r4, #0
    248c:	00000e3a 	andeq	r0, r0, sl, lsr lr
    2490:	26110005 	ldrcs	r0, [r1], -r5
    2494:	0500000f 	streq	r0, [r0, #-15]
    2498:	00003804 	andeq	r3, r0, r4, lsl #16
    249c:	0c3f0400 	cfldrseq	mvf0, [pc], #-0	; 24a4 <shift+0x24a4>
    24a0:	0000029e 	muleq	r0, lr, r2
    24a4:	00089c12 	andeq	r9, r8, r2, lsl ip
    24a8:	5a120000 	bpl	4824b0 <__bss_end+0x478d6c>
    24ac:	01000010 	tsteq	r0, r0, lsl r0
    24b0:	00134b12 	andseq	r4, r3, r2, lsl fp
    24b4:	16120200 	ldrne	r0, [r2], -r0, lsl #4
    24b8:	0300000d 	movweq	r0, #13
    24bc:	00096c12 	andeq	r6, r9, r2, lsl ip
    24c0:	92120400 	andsls	r0, r2, #0, 8
    24c4:	0500000a 	streq	r0, [r0, #-10]
    24c8:	0007b312 	andeq	fp, r7, r2, lsl r3
    24cc:	13000600 	movwne	r0, #1536	; 0x600
    24d0:	00000c87 	andeq	r0, r0, r7, lsl #25
    24d4:	80140505 	andshi	r0, r4, r5, lsl #10
    24d8:	05000000 	streq	r0, [r0, #-0]
    24dc:	00947c03 	addseq	r7, r4, r3, lsl #24
    24e0:	105f1300 	subsne	r1, pc, r0, lsl #6
    24e4:	06050000 	streq	r0, [r5], -r0
    24e8:	00008014 	andeq	r8, r0, r4, lsl r0
    24ec:	80030500 	andhi	r0, r3, r0, lsl #10
    24f0:	13000094 	movwne	r0, #148	; 0x94
    24f4:	00000afd 	strdeq	r0, [r0], -sp
    24f8:	801a0706 	andshi	r0, sl, r6, lsl #14
    24fc:	05000000 	streq	r0, [r0, #-0]
    2500:	00948403 	addseq	r8, r4, r3, lsl #8
    2504:	0e631300 	cdpeq	3, 6, cr1, cr3, cr0, {0}
    2508:	09060000 	stmdbeq	r6, {}	; <UNPREDICTABLE>
    250c:	0000801a 	andeq	r8, r0, sl, lsl r0
    2510:	88030500 	stmdahi	r3, {r8, sl}
    2514:	13000094 	movwne	r0, #148	; 0x94
    2518:	00000ac0 	andeq	r0, r0, r0, asr #21
    251c:	801a0b06 	andshi	r0, sl, r6, lsl #22
    2520:	05000000 	streq	r0, [r0, #-0]
    2524:	00948c03 	addseq	r8, r4, r3, lsl #24
    2528:	0dee1300 	stcleq	3, cr1, [lr]
    252c:	0d060000 	stceq	0, cr0, [r6, #-0]
    2530:	0000801a 	andeq	r8, r0, sl, lsl r0
    2534:	90030500 	andls	r0, r3, r0, lsl #10
    2538:	13000094 	movwne	r0, #148	; 0x94
    253c:	00000713 	andeq	r0, r0, r3, lsl r7
    2540:	801a0f06 	andshi	r0, sl, r6, lsl #30
    2544:	05000000 	streq	r0, [r0, #-0]
    2548:	00949403 	addseq	r9, r4, r3, lsl #8
    254c:	0cfc1100 	ldfeqe	f1, [ip]
    2550:	04050000 	streq	r0, [r5], #-0
    2554:	00000038 	andeq	r0, r0, r8, lsr r0
    2558:	410c1b06 	tstmi	ip, r6, lsl #22
    255c:	12000003 	andne	r0, r0, #3
    2560:	0000069f 	muleq	r0, pc, r6	; <UNPREDICTABLE>
    2564:	11881200 	orrne	r1, r8, r0, lsl #4
    2568:	12010000 	andne	r0, r1, #0
    256c:	00001346 	andeq	r1, r0, r6, asr #6
    2570:	61140002 	tstvs	r4, r2
    2574:	06000004 	streq	r0, [r0], -r4
    2578:	00000529 	andeq	r0, r0, r9, lsr #10
    257c:	07630690 			; <UNDEFINED> instruction: 0x07630690
    2580:	000004b4 			; <UNDEFINED> instruction: 0x000004b4
    2584:	00067b0f 	andeq	r7, r6, pc, lsl #22
    2588:	67062400 	strvs	r2, [r6, -r0, lsl #8]
    258c:	0003ce10 	andeq	ip, r3, r0, lsl lr
    2590:	23be0700 			; <UNDEFINED> instruction: 0x23be0700
    2594:	69060000 	stmdbvs	r6, {}	; <UNPREDICTABLE>
    2598:	0004b428 	andeq	fp, r4, r8, lsr #8
    259c:	a1070000 	mrsge	r0, (UNDEF: 7)
    25a0:	06000008 	streq	r0, [r0], -r8
    25a4:	01da206b 	bicseq	r2, sl, fp, rrx
    25a8:	07100000 	ldreq	r0, [r0, -r0]
    25ac:	00000694 	muleq	r0, r4, r6
    25b0:	74236d06 	strtvc	r6, [r3], #-3334	; 0xfffff2fa
    25b4:	14000000 	strne	r0, [r0], #-0
    25b8:	000e4307 	andeq	r4, lr, r7, lsl #6
    25bc:	1c700600 	ldclne	6, cr0, [r0], #-0
    25c0:	000004c4 	andeq	r0, r0, r4, asr #9
    25c4:	13030718 	movwne	r0, #14104	; 0x3718
    25c8:	72060000 	andvc	r0, r6, #0
    25cc:	0004c41c 	andeq	ip, r4, ip, lsl r4
    25d0:	24071c00 	strcs	r1, [r7], #-3072	; 0xfffff400
    25d4:	06000005 	streq	r0, [r0], -r5
    25d8:	04c41c75 	strbeq	r1, [r4], #3189	; 0xc75
    25dc:	15200000 	strne	r0, [r0, #-0]!
    25e0:	00000f15 	andeq	r0, r0, r5, lsl pc
    25e4:	461c7706 	ldrmi	r7, [ip], -r6, lsl #14
    25e8:	c4000012 	strgt	r0, [r0], #-18	; 0xffffffee
    25ec:	c2000004 	andgt	r0, r0, #4
    25f0:	09000003 	stmdbeq	r0, {r0, r1}
    25f4:	000004c4 	andeq	r0, r0, r4, asr #9
    25f8:	0001f10a 	andeq	pc, r1, sl, lsl #2
    25fc:	0f000000 	svceq	0x00000000
    2600:	0000133b 	andeq	r1, r0, fp, lsr r3
    2604:	107b0618 	rsbsne	r0, fp, r8, lsl r6
    2608:	00000403 	andeq	r0, r0, r3, lsl #8
    260c:	0023be07 	eoreq	fp, r3, r7, lsl #28
    2610:	2c7e0600 	ldclcs	6, cr0, [lr], #-0
    2614:	000004b4 			; <UNDEFINED> instruction: 0x000004b4
    2618:	05870700 	streq	r0, [r7, #1792]	; 0x700
    261c:	80060000 	andhi	r0, r6, r0
    2620:	0001f119 	andeq	pc, r1, r9, lsl r1	; <UNPREDICTABLE>
    2624:	99071000 	stmdbls	r7, {ip}
    2628:	0600000a 	streq	r0, [r0], -sl
    262c:	04cf2182 	strbeq	r2, [pc], #386	; 2634 <shift+0x2634>
    2630:	00140000 	andseq	r0, r4, r0
    2634:	0003ce03 	andeq	ip, r3, r3, lsl #28
    2638:	04d71600 	ldrbeq	r1, [r7], #1536	; 0x600
    263c:	86060000 	strhi	r0, [r6], -r0
    2640:	0004d521 	andeq	sp, r4, r1, lsr #10
    2644:	08cb1600 	stmiaeq	fp, {r9, sl, ip}^
    2648:	88060000 	stmdahi	r6, {}	; <UNPREDICTABLE>
    264c:	0000801f 	andeq	r8, r0, pc, lsl r0
    2650:	0e750700 	cdpeq	7, 7, cr0, cr5, cr0, {0}
    2654:	8b060000 	blhi	18265c <__bss_end+0x178f18>
    2658:	00035317 	andeq	r5, r3, r7, lsl r3
    265c:	03070000 	movweq	r0, #28672	; 0x7000
    2660:	06000008 	streq	r0, [r0], -r8
    2664:	0353178e 	cmpeq	r3, #37224448	; 0x2380000
    2668:	07240000 	streq	r0, [r4, -r0]!
    266c:	00000c0b 	andeq	r0, r0, fp, lsl #24
    2670:	53178f06 	tstpl	r7, #6, 30
    2674:	48000003 	stmdami	r0, {r0, r1}
    2678:	0009f407 	andeq	pc, r9, r7, lsl #8
    267c:	17900600 	ldrne	r0, [r0, r0, lsl #12]
    2680:	00000353 	andeq	r0, r0, r3, asr r3
    2684:	0529086c 	streq	r0, [r9, #-2156]!	; 0xfffff794
    2688:	93060000 	movwls	r0, #24576	; 0x6000
    268c:	000db109 	andeq	fp, sp, r9, lsl #2
    2690:	0004e000 	andeq	lr, r4, r0
    2694:	046d0100 	strbteq	r0, [sp], #-256	; 0xffffff00
    2698:	04730000 	ldrbteq	r0, [r3], #-0
    269c:	e0090000 	and	r0, r9, r0
    26a0:	00000004 	andeq	r0, r0, r4
    26a4:	000f0a0b 	andeq	r0, pc, fp, lsl #20
    26a8:	0e960600 	cdpeq	6, 9, cr0, cr6, cr0, {0}
    26ac:	00000568 	andeq	r0, r0, r8, ror #10
    26b0:	00048801 	andeq	r8, r4, r1, lsl #16
    26b4:	00048e00 	andeq	r8, r4, r0, lsl #28
    26b8:	04e00900 	strbteq	r0, [r0], #2304	; 0x900
    26bc:	17000000 	strne	r0, [r0, -r0]
    26c0:	0000089c 	muleq	r0, ip, r8
    26c4:	e1109906 	tst	r0, r6, lsl #18
    26c8:	e600000c 	str	r0, [r0], -ip
    26cc:	01000004 	tsteq	r0, r4
    26d0:	000004a3 	andeq	r0, r0, r3, lsr #9
    26d4:	0004e009 	andeq	lr, r4, r9
    26d8:	01f10a00 	mvnseq	r0, r0, lsl #20
    26dc:	1c0a0000 	stcne	0, cr0, [sl], {-0}
    26e0:	00000003 	andeq	r0, r0, r3
    26e4:	00251800 	eoreq	r1, r5, r0, lsl #16
    26e8:	04c40000 	strbeq	r0, [r4], #0
    26ec:	85190000 	ldrhi	r0, [r9, #-0]
    26f0:	0f000000 	svceq	0x00000000
    26f4:	53040d00 	movwpl	r0, #19712	; 0x4d00
    26f8:	14000003 	strne	r0, [r0], #-3
    26fc:	0000121b 	andeq	r1, r0, fp, lsl r2
    2700:	04ca040d 	strbeq	r0, [sl], #1037	; 0x40d
    2704:	03180000 	tsteq	r8, #0
    2708:	e0000004 	and	r0, r0, r4
    270c:	1a000004 	bne	2724 <shift+0x2724>
    2710:	46040d00 	strmi	r0, [r4], -r0, lsl #26
    2714:	0d000003 	stceq	0, cr0, [r0, #-12]
    2718:	00034104 	andeq	r4, r3, r4, lsl #2
    271c:	0efe1b00 	vmoveq.f64	d17, #224	; 0xbf000000 -0.5
    2720:	9c060000 	stcls	0, cr0, [r6], {-0}
    2724:	00034614 	andeq	r4, r3, r4, lsl r6
    2728:	06a91300 	strteq	r1, [r9], r0, lsl #6
    272c:	04070000 	streq	r0, [r7], #-0
    2730:	00008014 	andeq	r8, r0, r4, lsl r0
    2734:	98030500 	stmdals	r3, {r8, sl}
    2738:	13000094 	movwne	r0, #148	; 0x94
    273c:	00000f66 	andeq	r0, r0, r6, ror #30
    2740:	80140707 	andshi	r0, r4, r7, lsl #14
    2744:	05000000 	streq	r0, [r0, #-0]
    2748:	00949c03 	addseq	r9, r4, r3, lsl #24
    274c:	05551300 	ldrbeq	r1, [r5, #-768]	; 0xfffffd00
    2750:	0a070000 	beq	1c2758 <__bss_end+0x1b9014>
    2754:	00008014 	andeq	r8, r0, r4, lsl r0
    2758:	a0030500 	andge	r0, r3, r0, lsl #10
    275c:	11000094 	swpne	r0, r4, [r0]	; <UNPREDICTABLE>
    2760:	000007b8 			; <UNDEFINED> instruction: 0x000007b8
    2764:	00380405 	eorseq	r0, r8, r5, lsl #8
    2768:	0d070000 	stceq	0, cr0, [r7, #-0]
    276c:	0005650c 	andeq	r6, r5, ip, lsl #10
    2770:	654e1c00 	strbvs	r1, [lr, #-3072]	; 0xfffff400
    2774:	12000077 	andne	r0, r0, #119	; 0x77
    2778:	00000984 	andeq	r0, r0, r4, lsl #19
    277c:	054d1201 	strbeq	r1, [sp, #-513]	; 0xfffffdff
    2780:	12020000 	andne	r0, r2, #0
    2784:	000007d1 	ldrdeq	r0, [r0], -r1
    2788:	110e1203 	tstne	lr, r3, lsl #4
    278c:	12040000 	andne	r0, r4, #0
    2790:	0000051d 	andeq	r0, r0, sp, lsl r5
    2794:	c20f0005 	andgt	r0, pc, #5
    2798:	10000006 	andne	r0, r0, r6
    279c:	a4081b07 	strge	r1, [r8], #-2823	; 0xfffff4f9
    27a0:	10000005 	andne	r0, r0, r5
    27a4:	0700726c 	streq	r7, [r0, -ip, ror #4]
    27a8:	05a4131d 	streq	r1, [r4, #797]!	; 0x31d
    27ac:	10000000 	andne	r0, r0, r0
    27b0:	07007073 	smlsdxeq	r0, r3, r0, r7
    27b4:	05a4131e 	streq	r1, [r4, #798]!	; 0x31e
    27b8:	10040000 	andne	r0, r4, r0
    27bc:	07006370 	smlsdxeq	r0, r0, r3, r6
    27c0:	05a4131f 	streq	r1, [r4, #799]!	; 0x31f
    27c4:	07080000 	streq	r0, [r8, -r0]
    27c8:	00000f20 	andeq	r0, r0, r0, lsr #30
    27cc:	a4132007 	ldrge	r2, [r3], #-7
    27d0:	0c000005 	stceq	0, cr0, [r0], {5}
    27d4:	07040200 	streq	r0, [r4, -r0, lsl #4]
    27d8:	00001fd1 	ldrdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    27dc:	0005a403 	andeq	sl, r5, r3, lsl #8
    27e0:	094b0f00 	stmdbeq	fp, {r8, r9, sl, fp}^
    27e4:	07700000 	ldrbeq	r0, [r0, -r0]!
    27e8:	06400828 	strbeq	r0, [r0], -r8, lsr #16
    27ec:	4b070000 	blmi	1c27f4 <__bss_end+0x1b90b0>
    27f0:	07000008 	streq	r0, [r0, -r8]
    27f4:	0565122a 	strbeq	r1, [r5, #-554]!	; 0xfffffdd6
    27f8:	10000000 	andne	r0, r0, r0
    27fc:	00646970 	rsbeq	r6, r4, r0, ror r9
    2800:	85122b07 	ldrhi	r2, [r2, #-2823]	; 0xfffff4f9
    2804:	10000000 	andne	r0, r0, r0
    2808:	001daf07 	andseq	sl, sp, r7, lsl #30
    280c:	112c0700 			; <UNDEFINED> instruction: 0x112c0700
    2810:	0000052e 	andeq	r0, r0, lr, lsr #10
    2814:	10f20714 	rscsne	r0, r2, r4, lsl r7
    2818:	2d070000 	stccs	0, cr0, [r7, #-0]
    281c:	00008512 	andeq	r8, r0, r2, lsl r5
    2820:	f1071800 			; <UNDEFINED> instruction: 0xf1071800
    2824:	07000003 	streq	r0, [r0, -r3]
    2828:	0085122e 	addeq	r1, r5, lr, lsr #4
    282c:	071c0000 	ldreq	r0, [ip, -r0]
    2830:	00000f53 	andeq	r0, r0, r3, asr pc
    2834:	40312f07 	eorsmi	r2, r1, r7, lsl #30
    2838:	20000006 	andcs	r0, r0, r6
    283c:	0004cd07 	andeq	ip, r4, r7, lsl #26
    2840:	09300700 	ldmdbeq	r0!, {r8, r9, sl}
    2844:	00000038 	andeq	r0, r0, r8, lsr r0
    2848:	0b650760 	bleq	19445d0 <__bss_end+0x193ae8c>
    284c:	31070000 	mrscc	r0, (UNDEF: 7)
    2850:	0000740e 	andeq	r7, r0, lr, lsl #8
    2854:	8a076400 	bhi	1db85c <__bss_end+0x1d2118>
    2858:	0700000d 	streq	r0, [r0, -sp]
    285c:	00740e33 	rsbseq	r0, r4, r3, lsr lr
    2860:	07680000 	strbeq	r0, [r8, -r0]!
    2864:	00000d81 	andeq	r0, r0, r1, lsl #27
    2868:	740e3407 	strvc	r3, [lr], #-1031	; 0xfffffbf9
    286c:	6c000000 	stcvs	0, cr0, [r0], {-0}
    2870:	04e61800 	strbteq	r1, [r6], #2048	; 0x800
    2874:	06500000 	ldrbeq	r0, [r0], -r0
    2878:	85190000 	ldrhi	r0, [r9, #-0]
    287c:	0f000000 	svceq	0x00000000
    2880:	05351300 	ldreq	r1, [r5, #-768]!	; 0xfffffd00
    2884:	0a080000 	beq	20288c <__bss_end+0x1f9148>
    2888:	00008014 	andeq	r8, r0, r4, lsl r0
    288c:	a4030500 	strge	r0, [r3], #-1280	; 0xfffffb00
    2890:	11000094 	swpne	r0, r4, [r0]	; <UNPREDICTABLE>
    2894:	00000b50 	andeq	r0, r0, r0, asr fp
    2898:	00380405 	eorseq	r0, r8, r5, lsl #8
    289c:	0d080000 	stceq	0, cr0, [r8, #-0]
    28a0:	0006810c 	andeq	r8, r6, ip, lsl #2
    28a4:	13511200 	cmpne	r1, #0, 4
    28a8:	12000000 	andne	r0, r0, #0
    28ac:	000011bd 			; <UNDEFINED> instruction: 0x000011bd
    28b0:	300f0001 	andcc	r0, pc, r1
    28b4:	0c000008 	stceq	0, cr0, [r0], {8}
    28b8:	b6081b08 	strlt	r1, [r8], -r8, lsl #22
    28bc:	07000006 	streq	r0, [r0, -r6]
    28c0:	000005db 	ldrdeq	r0, [r0], -fp
    28c4:	b6191d08 	ldrlt	r1, [r9], -r8, lsl #26
    28c8:	00000006 	andeq	r0, r0, r6
    28cc:	00052407 	andeq	r2, r5, r7, lsl #8
    28d0:	191e0800 	ldmdbne	lr, {fp}
    28d4:	000006b6 			; <UNDEFINED> instruction: 0x000006b6
    28d8:	0b800704 	bleq	fe0044f0 <__bss_end+0xfdffadac>
    28dc:	1f080000 	svcne	0x00080000
    28e0:	0006bc13 	andeq	fp, r6, r3, lsl ip
    28e4:	0d000800 	stceq	8, cr0, [r0, #-0]
    28e8:	00068104 	andeq	r8, r6, r4, lsl #2
    28ec:	b0040d00 	andlt	r0, r4, r0, lsl #26
    28f0:	06000005 	streq	r0, [r0], -r5
    28f4:	00000ec1 	andeq	r0, r0, r1, asr #29
    28f8:	07220814 			; <UNDEFINED> instruction: 0x07220814
    28fc:	00000944 	andeq	r0, r0, r4, asr #18
    2900:	000c9507 	andeq	r9, ip, r7, lsl #10
    2904:	12260800 	eorne	r0, r6, #0, 16
    2908:	00000074 	andeq	r0, r0, r4, ror r0
    290c:	0c280700 	stceq	7, cr0, [r8], #-0
    2910:	29080000 	stmdbcs	r8, {}	; <UNPREDICTABLE>
    2914:	0006b61d 	andeq	fp, r6, sp, lsl r6
    2918:	d9070400 	stmdble	r7, {sl}
    291c:	08000007 	stmdaeq	r0, {r0, r1, r2}
    2920:	06b61d2c 	ldrteq	r1, [r6], ip, lsr #26
    2924:	1d080000 	stcne	0, cr0, [r8, #-0]
    2928:	00000d0c 	andeq	r0, r0, ip, lsl #26
    292c:	0d0e2f08 	stceq	15, cr2, [lr, #-32]	; 0xffffffe0
    2930:	0a000008 	beq	2958 <shift+0x2958>
    2934:	15000007 	strne	r0, [r0, #-7]
    2938:	09000007 	stmdbeq	r0, {r0, r1, r2}
    293c:	00000949 	andeq	r0, r0, r9, asr #18
    2940:	0006b60a 	andeq	fp, r6, sl, lsl #12
    2944:	8d1e0000 	ldchi	0, cr0, [lr, #-0]
    2948:	08000009 	stmdaeq	r0, {r0, r3}
    294c:	09220e31 	stmdbeq	r2!, {r0, r4, r5, r9, sl, fp}
    2950:	01da0000 	bicseq	r0, sl, r0
    2954:	072d0000 	streq	r0, [sp, -r0]!
    2958:	07380000 	ldreq	r0, [r8, -r0]!
    295c:	49090000 	stmdbmi	r9, {}	; <UNPREDICTABLE>
    2960:	0a000009 	beq	298c <shift+0x298c>
    2964:	000006bc 			; <UNDEFINED> instruction: 0x000006bc
    2968:	11690800 	cmnne	r9, r0, lsl #16
    296c:	35080000 	strcc	r0, [r8, #-0]
    2970:	000b2b1d 	andeq	r2, fp, sp, lsl fp
    2974:	0006b600 	andeq	fp, r6, r0, lsl #12
    2978:	07510200 	ldrbeq	r0, [r1, -r0, lsl #4]
    297c:	07570000 	ldrbeq	r0, [r7, -r0]
    2980:	49090000 	stmdbmi	r9, {}	; <UNPREDICTABLE>
    2984:	00000009 	andeq	r0, r0, r9
    2988:	0007c408 	andeq	ip, r7, r8, lsl #8
    298c:	1d370800 	ldcne	8, cr0, [r7, #-0]
    2990:	00000d1c 	andeq	r0, r0, ip, lsl sp
    2994:	000006b6 			; <UNDEFINED> instruction: 0x000006b6
    2998:	00077002 	andeq	r7, r7, r2
    299c:	00077600 	andeq	r7, r7, r0, lsl #12
    29a0:	09490900 	stmdbeq	r9, {r8, fp}^
    29a4:	1f000000 	svcne	0x00000000
    29a8:	00000c3b 	andeq	r0, r0, fp, lsr ip
    29ac:	62443908 	subvs	r3, r4, #8, 18	; 0x20000
    29b0:	0c000009 	stceq	0, cr0, [r0], {9}
    29b4:	0ec10802 	cdpeq	8, 12, cr0, cr1, cr2, {0}
    29b8:	3c080000 	stccc	0, cr0, [r8], {-0}
    29bc:	00099c09 	andeq	r9, r9, r9, lsl #24
    29c0:	00094900 	andeq	r4, r9, r0, lsl #18
    29c4:	079d0100 	ldreq	r0, [sp, r0, lsl #2]
    29c8:	07a30000 	streq	r0, [r3, r0]!
    29cc:	49090000 	stmdbmi	r9, {}	; <UNPREDICTABLE>
    29d0:	00000009 	andeq	r0, r0, r9
    29d4:	00085d08 	andeq	r5, r8, r8, lsl #26
    29d8:	123f0800 	eorsne	r0, pc, #0, 16
    29dc:	000005b0 			; <UNDEFINED> instruction: 0x000005b0
    29e0:	00000074 	andeq	r0, r0, r4, ror r0
    29e4:	0007bc01 	andeq	fp, r7, r1, lsl #24
    29e8:	0007d100 	andeq	sp, r7, r0, lsl #2
    29ec:	09490900 	stmdbeq	r9, {r8, fp}^
    29f0:	6b0a0000 	blvs	2829f8 <__bss_end+0x2792b4>
    29f4:	0a000009 	beq	2a20 <shift+0x2a20>
    29f8:	00000085 	andeq	r0, r0, r5, lsl #1
    29fc:	0001da0a 	andeq	sp, r1, sl, lsl #20
    2a00:	930b0000 	movwls	r0, #45056	; 0xb000
    2a04:	08000011 	stmdaeq	r0, {r0, r4}
    2a08:	06cf0e42 	strbeq	r0, [pc], r2, asr #28
    2a0c:	e6010000 	str	r0, [r1], -r0
    2a10:	ec000007 	stc	0, cr0, [r0], {7}
    2a14:	09000007 	stmdbeq	r0, {r0, r1, r2}
    2a18:	00000949 	andeq	r0, r0, r9, asr #18
    2a1c:	05920800 	ldreq	r0, [r2, #2048]	; 0x800
    2a20:	45080000 	strmi	r0, [r8, #-0]
    2a24:	00064d17 	andeq	r4, r6, r7, lsl sp
    2a28:	0006bc00 	andeq	fp, r6, r0, lsl #24
    2a2c:	08050100 	stmdaeq	r5, {r8}
    2a30:	080b0000 	stmdaeq	fp, {}	; <UNPREDICTABLE>
    2a34:	71090000 	mrsvc	r0, (UNDEF: 9)
    2a38:	00000009 	andeq	r0, r0, r9
    2a3c:	000f7108 	andeq	r7, pc, r8, lsl #2
    2a40:	17480800 	strbne	r0, [r8, -r0, lsl #16]
    2a44:	00000407 	andeq	r0, r0, r7, lsl #8
    2a48:	000006bc 			; <UNDEFINED> instruction: 0x000006bc
    2a4c:	00082401 	andeq	r2, r8, r1, lsl #8
    2a50:	00082f00 	andeq	r2, r8, r0, lsl #30
    2a54:	09710900 	ldmdbeq	r1!, {r8, fp}^
    2a58:	740a0000 	strvc	r0, [sl], #-0
    2a5c:	00000000 	andeq	r0, r0, r0
    2a60:	00071d0b 	andeq	r1, r7, fp, lsl #26
    2a64:	0e4b0800 	cdpeq	8, 4, cr0, cr11, cr0, {0}
    2a68:	00000c49 	andeq	r0, r0, r9, asr #24
    2a6c:	00084401 	andeq	r4, r8, r1, lsl #8
    2a70:	00084a00 	andeq	r4, r8, r0, lsl #20
    2a74:	09490900 	stmdbeq	r9, {r8, fp}^
    2a78:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2a7c:	0000098d 	andeq	r0, r0, sp, lsl #19
    2a80:	c60e4d08 	strgt	r4, [lr], -r8, lsl #26
    2a84:	da00000d 	ble	2ac0 <shift+0x2ac0>
    2a88:	01000001 	tsteq	r0, r1
    2a8c:	00000863 	andeq	r0, r0, r3, ror #16
    2a90:	0000086e 	andeq	r0, r0, lr, ror #16
    2a94:	00094909 	andeq	r4, r9, r9, lsl #18
    2a98:	00740a00 	rsbseq	r0, r4, r0, lsl #20
    2a9c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2aa0:	00000509 	andeq	r0, r0, r9, lsl #10
    2aa4:	34125008 	ldrcc	r5, [r2], #-8
    2aa8:	74000004 	strvc	r0, [r0], #-4
    2aac:	01000000 	mrseq	r0, (UNDEF: 0)
    2ab0:	00000887 	andeq	r0, r0, r7, lsl #17
    2ab4:	00000892 	muleq	r0, r2, r8
    2ab8:	00094909 	andeq	r4, r9, r9, lsl #18
    2abc:	04e60a00 	strbteq	r0, [r6], #2560	; 0xa00
    2ac0:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2ac4:	00000467 	andeq	r0, r0, r7, ror #8
    2ac8:	e90e5308 	stmdb	lr, {r3, r8, r9, ip, lr}
    2acc:	da000011 	ble	2b18 <shift+0x2b18>
    2ad0:	01000001 	tsteq	r0, r1
    2ad4:	000008ab 	andeq	r0, r0, fp, lsr #17
    2ad8:	000008b6 			; <UNDEFINED> instruction: 0x000008b6
    2adc:	00094909 	andeq	r4, r9, r9, lsl #18
    2ae0:	00740a00 	rsbseq	r0, r4, r0, lsl #20
    2ae4:	0b000000 	bleq	2aec <shift+0x2aec>
    2ae8:	000004e3 	andeq	r0, r0, r3, ror #9
    2aec:	6b0e5608 	blvs	398314 <__bss_end+0x38ebd0>
    2af0:	01000010 	tsteq	r0, r0, lsl r0
    2af4:	000008cb 	andeq	r0, r0, fp, asr #17
    2af8:	000008ea 	andeq	r0, r0, sl, ror #17
    2afc:	00094909 	andeq	r4, r9, r9, lsl #18
    2b00:	022a0a00 	eoreq	r0, sl, #0, 20
    2b04:	740a0000 	strvc	r0, [sl], #-0
    2b08:	0a000000 	beq	2b10 <shift+0x2b10>
    2b0c:	00000074 	andeq	r0, r0, r4, ror r0
    2b10:	0000740a 	andeq	r7, r0, sl, lsl #8
    2b14:	09770a00 	ldmdbeq	r7!, {r9, fp}^
    2b18:	0b000000 	bleq	2b20 <shift+0x2b20>
    2b1c:	00001276 	andeq	r1, r0, r6, ror r2
    2b20:	660e5808 	strvs	r5, [lr], -r8, lsl #16
    2b24:	01000013 	tsteq	r0, r3, lsl r0
    2b28:	000008ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2b2c:	0000091e 	andeq	r0, r0, lr, lsl r9
    2b30:	00094909 	andeq	r4, r9, r9, lsl #18
    2b34:	02610a00 	rsbeq	r0, r1, #0, 20
    2b38:	740a0000 	strvc	r0, [sl], #-0
    2b3c:	0a000000 	beq	2b44 <shift+0x2b44>
    2b40:	00000074 	andeq	r0, r0, r4, ror r0
    2b44:	0000740a 	andeq	r7, r0, sl, lsl #8
    2b48:	09770a00 	ldmdbeq	r7!, {r9, fp}^
    2b4c:	17000000 	strne	r0, [r0, -r0]
    2b50:	000004f6 	strdeq	r0, [r0], -r6
    2b54:	ab0e5b08 	blge	39977c <__bss_end+0x390038>
    2b58:	da00000b 	ble	2b8c <shift+0x2b8c>
    2b5c:	01000001 	tsteq	r0, r1
    2b60:	00000933 	andeq	r0, r0, r3, lsr r9
    2b64:	00094909 	andeq	r4, r9, r9, lsl #18
    2b68:	06620a00 	strbteq	r0, [r2], -r0, lsl #20
    2b6c:	f70a0000 			; <UNDEFINED> instruction: 0xf70a0000
    2b70:	00000001 	andeq	r0, r0, r1
    2b74:	06c20300 	strbeq	r0, [r2], r0, lsl #6
    2b78:	040d0000 	streq	r0, [sp], #-0
    2b7c:	000006c2 	andeq	r0, r0, r2, asr #13
    2b80:	0006b620 	andeq	fp, r6, r0, lsr #12
    2b84:	00095c00 	andeq	r5, r9, r0, lsl #24
    2b88:	00096200 	andeq	r6, r9, r0, lsl #4
    2b8c:	09490900 	stmdbeq	r9, {r8, fp}^
    2b90:	21000000 	mrscs	r0, (UNDEF: 0)
    2b94:	000006c2 	andeq	r0, r0, r2, asr #13
    2b98:	0000094f 	andeq	r0, r0, pc, asr #18
    2b9c:	0055040d 	subseq	r0, r5, sp, lsl #8
    2ba0:	040d0000 	streq	r0, [sp], #-0
    2ba4:	00000944 	andeq	r0, r0, r4, asr #18
    2ba8:	02040422 	andeq	r0, r4, #570425344	; 0x22000000
    2bac:	d81b0000 	ldmdale	fp, {}	; <UNPREDICTABLE>
    2bb0:	08000012 	stmdaeq	r0, {r1, r4}
    2bb4:	06c2195e 			; <UNDEFINED> instruction: 0x06c2195e
    2bb8:	74110000 	ldrvc	r0, [r1], #-0
    2bbc:	0700001a 	smladeq	r0, sl, r0, r0
    2bc0:	00004401 	andeq	r4, r0, r1, lsl #8
    2bc4:	0c060900 			; <UNDEFINED> instruction: 0x0c060900
    2bc8:	000009ba 			; <UNDEFINED> instruction: 0x000009ba
    2bcc:	706f4e1c 	rsbvc	r4, pc, ip, lsl lr	; <UNPREDICTABLE>
    2bd0:	f6120000 			; <UNDEFINED> instruction: 0xf6120000
    2bd4:	0100000f 	tsteq	r0, pc
    2bd8:	000a2c12 	andeq	r2, sl, r2, lsl ip
    2bdc:	8b120200 	blhi	4833e4 <__bss_end+0x479ca0>
    2be0:	0300001a 	movweq	r0, #26
    2be4:	0019ac12 	andseq	sl, r9, r2, lsl ip
    2be8:	0f000400 	svceq	0x00000400
    2bec:	000019c5 	andeq	r1, r0, r5, asr #19
    2bf0:	08220905 	stmdaeq	r2!, {r0, r2, r8, fp}
    2bf4:	000009eb 	andeq	r0, r0, fp, ror #19
    2bf8:	09007810 	stmdbeq	r0, {r4, fp, ip, sp, lr}
    2bfc:	005c0e24 	subseq	r0, ip, r4, lsr #28
    2c00:	10000000 	andne	r0, r0, r0
    2c04:	25090079 	strcs	r0, [r9, #-121]	; 0xffffff87
    2c08:	00005c0e 	andeq	r5, r0, lr, lsl #24
    2c0c:	73100200 	tstvc	r0, #0, 4
    2c10:	09007465 	stmdbeq	r0, {r0, r2, r5, r6, sl, ip, sp, lr}
    2c14:	00440d26 	subeq	r0, r4, r6, lsr #26
    2c18:	00040000 	andeq	r0, r4, r0
    2c1c:	0019390f 	andseq	r3, r9, pc, lsl #18
    2c20:	2a090100 	bcs	243028 <__bss_end+0x2398e4>
    2c24:	000a0608 	andeq	r0, sl, r8, lsl #12
    2c28:	6d631000 	stclvs	0, cr1, [r3, #-0]
    2c2c:	2c090064 	stccs	0, cr0, [r9], {100}	; 0x64
    2c30:	00098916 	andeq	r8, r9, r6, lsl r9
    2c34:	0f000000 	svceq	0x00000000
    2c38:	00001950 	andeq	r1, r0, r0, asr r9
    2c3c:	08300901 	ldmdaeq	r0!, {r0, r8, fp}
    2c40:	00000a21 	andeq	r0, r0, r1, lsr #20
    2c44:	001ad207 	andseq	sp, sl, r7, lsl #4
    2c48:	1c320900 			; <UNDEFINED> instruction: 0x1c320900
    2c4c:	000009eb 	andeq	r0, r0, fp, ror #19
    2c50:	490f0000 	stmdbmi	pc, {}	; <UNPREDICTABLE>
    2c54:	0200001a 	andeq	r0, r0, #26
    2c58:	49083609 	stmdbmi	r8, {r0, r3, r9, sl, ip, sp}
    2c5c:	0700000a 	streq	r0, [r0, -sl]
    2c60:	00001ad2 	ldrdeq	r1, [r0], -r2
    2c64:	eb1c3809 	bl	710c90 <__bss_end+0x70754c>
    2c68:	00000009 	andeq	r0, r0, r9
    2c6c:	001a9c07 	andseq	r9, sl, r7, lsl #24
    2c70:	0d390900 			; <UNDEFINED> instruction: 0x0d390900
    2c74:	00000044 	andeq	r0, r0, r4, asr #32
    2c78:	8b0f0001 	blhi	3c2c84 <__bss_end+0x3b9540>
    2c7c:	08000019 	stmdaeq	r0, {r0, r3, r4}
    2c80:	7e083d09 	cdpvc	13, 0, cr3, cr8, cr9, {0}
    2c84:	0700000a 	streq	r0, [r0, -sl]
    2c88:	00001ad2 	ldrdeq	r1, [r0], -r2
    2c8c:	eb1c3f09 	bl	7128b8 <__bss_end+0x709174>
    2c90:	00000009 	andeq	r0, r0, r9
    2c94:	00169a07 	andseq	r9, r6, r7, lsl #20
    2c98:	0e400900 	vmlaeq.f16	s1, s0, s0	; <UNPREDICTABLE>
    2c9c:	0000005c 	andeq	r0, r0, ip, asr r0
    2ca0:	1a850701 	bne	fe1448ac <__bss_end+0xfe13b168>
    2ca4:	42090000 	andmi	r0, r9, #0
    2ca8:	0009ba19 	andeq	fp, r9, r9, lsl sl
    2cac:	0f000300 	svceq	0x00000300
    2cb0:	000019de 	ldrdeq	r1, [r0], -lr
    2cb4:	0846090b 	stmdaeq	r6, {r0, r1, r3, r8, fp}^
    2cb8:	00000ae1 	andeq	r0, r0, r1, ror #21
    2cbc:	001ad207 	andseq	sp, sl, r7, lsl #4
    2cc0:	1c480900 	mcrrne	9, 0, r0, r8, cr0	; <UNPREDICTABLE>
    2cc4:	000009eb 	andeq	r0, r0, fp, ror #19
    2cc8:	31781000 	cmncc	r8, r0
    2ccc:	0e490900 	vmlaeq.f16	s1, s18, s0	; <UNPREDICTABLE>
    2cd0:	0000005c 	andeq	r0, r0, ip, asr r0
    2cd4:	31791001 	cmncc	r9, r1
    2cd8:	12490900 	subne	r0, r9, #0, 18
    2cdc:	0000005c 	andeq	r0, r0, ip, asr r0
    2ce0:	00771003 	rsbseq	r1, r7, r3
    2ce4:	5c0e4a09 			; <UNDEFINED> instruction: 0x5c0e4a09
    2ce8:	05000000 	streq	r0, [r0, #-0]
    2cec:	09006810 	stmdbeq	r0, {r4, fp, sp, lr}
    2cf0:	005c114a 	subseq	r1, ip, sl, asr #2
    2cf4:	07070000 	streq	r0, [r7, -r0]
    2cf8:	00001985 	andeq	r1, r0, r5, lsl #19
    2cfc:	440d4b09 	strmi	r4, [sp], #-2825	; 0xfffff4f7
    2d00:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2d04:	001a8507 	andseq	r8, sl, r7, lsl #10
    2d08:	0d4d0900 	vstreq.16	s1, [sp, #-0]	; <UNPREDICTABLE>
    2d0c:	00000044 	andeq	r0, r0, r4, asr #32
    2d10:	6823000a 	stmdavs	r3!, {r1, r3}
    2d14:	0a006c61 	beq	1dea0 <__bss_end+0x1475c>
    2d18:	0b9b0b05 	bleq	fe6c5934 <__bss_end+0xfe6bc1f0>
    2d1c:	f8240000 			; <UNDEFINED> instruction: 0xf8240000
    2d20:	0a00000b 	beq	2d54 <shift+0x2d54>
    2d24:	008c1907 	addeq	r1, ip, r7, lsl #18
    2d28:	b2800000 	addlt	r0, r0, #0
    2d2c:	84240ee6 	strthi	r0, [r4], #-3814	; 0xfffff11a
    2d30:	0a00000f 	beq	2d74 <shift+0x2d74>
    2d34:	05ab1a0a 	streq	r1, [fp, #2570]!	; 0xa0a
    2d38:	00000000 	andeq	r0, r0, r0
    2d3c:	a6242000 	strtge	r2, [r4], -r0
    2d40:	0a000005 	beq	2d5c <shift+0x2d5c>
    2d44:	05ab1a0d 	streq	r1, [fp, #2573]!	; 0xa0d
    2d48:	00000000 	andeq	r0, r0, r0
    2d4c:	71252020 			; <UNDEFINED> instruction: 0x71252020
    2d50:	0a00000b 	beq	2d84 <shift+0x2d84>
    2d54:	00801510 	addeq	r1, r0, r0, lsl r5
    2d58:	24360000 	ldrtcs	r0, [r6], #-0
    2d5c:	00001175 	andeq	r1, r0, r5, ror r1
    2d60:	ab1a420a 	blge	693590 <__bss_end+0x689e4c>
    2d64:	00000005 	andeq	r0, r0, r5
    2d68:	24202150 	strtcs	r2, [r0], #-336	; 0xfffffeb0
    2d6c:	00001321 	andeq	r1, r0, r1, lsr #6
    2d70:	ab1a710a 	blge	69f1a0 <__bss_end+0x695a5c>
    2d74:	00000005 	andeq	r0, r0, r5
    2d78:	242000b2 	strtcs	r0, [r0], #-178	; 0xffffff4e
    2d7c:	000008c0 	andeq	r0, r0, r0, asr #17
    2d80:	ab1aa40a 	blge	6abdb0 <__bss_end+0x6a266c>
    2d84:	00000005 	andeq	r0, r0, r5
    2d88:	242000b4 	strtcs	r0, [r0], #-180	; 0xffffff4c
    2d8c:	00000bee 	andeq	r0, r0, lr, ror #23
    2d90:	ab1ab30a 	blge	6af9c0 <__bss_end+0x6a627c>
    2d94:	00000005 	andeq	r0, r0, r5
    2d98:	24201040 	strtcs	r1, [r0], #-64	; 0xffffffc0
    2d9c:	00000d55 	andeq	r0, r0, r5, asr sp
    2da0:	ab1abe0a 	blge	6b25d0 <__bss_end+0x6a8e8c>
    2da4:	00000005 	andeq	r0, r0, r5
    2da8:	24202050 	strtcs	r2, [r0], #-80	; 0xffffffb0
    2dac:	000007a0 	andeq	r0, r0, r0, lsr #15
    2db0:	ab1abf0a 	blge	6b29e0 <__bss_end+0x6a929c>
    2db4:	00000005 	andeq	r0, r0, r5
    2db8:	24208040 	strtcs	r8, [r0], #-64	; 0xffffffc0
    2dbc:	0000117e 	andeq	r1, r0, lr, ror r1
    2dc0:	ab1ac00a 	blge	6b2df0 <__bss_end+0x6a96ac>
    2dc4:	00000005 	andeq	r0, r0, r5
    2dc8:	00208050 	eoreq	r8, r0, r0, asr r0
    2dcc:	000aed26 	andeq	lr, sl, r6, lsr #26
    2dd0:	0afd2600 	beq	fff4c5d8 <__bss_end+0xfff42e94>
    2dd4:	0d260000 	stceq	0, cr0, [r6, #-0]
    2dd8:	2600000b 	strcs	r0, [r0], -fp
    2ddc:	00000b1d 	andeq	r0, r0, sp, lsl fp
    2de0:	000b2a26 	andeq	r2, fp, r6, lsr #20
    2de4:	0b3a2600 	bleq	e8c5ec <__bss_end+0xe82ea8>
    2de8:	4a260000 	bmi	982df0 <__bss_end+0x9796ac>
    2dec:	2600000b 	strcs	r0, [r0], -fp
    2df0:	00000b5a 	andeq	r0, r0, sl, asr fp
    2df4:	000b6a26 	andeq	r6, fp, r6, lsr #20
    2df8:	0b7a2600 	bleq	1e8c600 <__bss_end+0x1e82ebc>
    2dfc:	8a260000 	bhi	982e04 <__bss_end+0x9796c0>
    2e00:	2700000b 	strcs	r0, [r0, -fp]
    2e04:	00001a6a 	andeq	r1, r0, sl, ror #20
    2e08:	6e0b040b 	cdpvs	4, 0, cr0, cr11, cr11, {0}
    2e0c:	2500000e 	strcs	r0, [r0, #-14]
    2e10:	00001a5f 	andeq	r1, r0, pc, asr sl
    2e14:	6818070b 	ldmdavs	r8, {r0, r1, r3, r8, r9, sl}
    2e18:	06000000 	streq	r0, [r0], -r0
    2e1c:	001ac625 	andseq	ip, sl, r5, lsr #12
    2e20:	18090b00 	stmdane	r9, {r8, r9, fp}
    2e24:	00000068 	andeq	r0, r0, r8, rrx
    2e28:	1ad92508 	bne	ff64c250 <__bss_end+0xff642b0c>
    2e2c:	0c0b0000 	stceq	0, cr0, [fp], {-0}
    2e30:	00006818 	andeq	r6, r0, r8, lsl r8
    2e34:	f6252000 			; <UNDEFINED> instruction: 0xf6252000
    2e38:	0b000019 	bleq	2ea4 <shift+0x2ea4>
    2e3c:	0068180e 	rsbeq	r1, r8, lr, lsl #16
    2e40:	25800000 	strcs	r0, [r0]
    2e44:	000019ff 	strdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    2e48:	e114110b 	tst	r4, fp, lsl #2
    2e4c:	01000001 	tsteq	r0, r1
    2e50:	00197328 	andseq	r7, r9, r8, lsr #6
    2e54:	13140b00 	tstne	r4, #0, 22
    2e58:	00000e98 	muleq	r0, r8, lr
    2e5c:	00000240 	andeq	r0, r0, r0, asr #4
    2e60:	00000000 	andeq	r0, r0, r0
    2e64:	2f000000 	svccs	0x00000000
    2e68:	00000000 	andeq	r0, r0, r0
    2e6c:	00070007 	andeq	r0, r7, r7
    2e70:	147f1400 	ldrbtne	r1, [pc], #-1024	; 2e78 <shift+0x2e78>
    2e74:	2400147f 	strcs	r1, [r0], #-1151	; 0xfffffb81
    2e78:	122a7f2a 	eorne	r7, sl, #42, 30	; 0xa8
    2e7c:	08132300 	ldmdaeq	r3, {r8, r9, sp}
    2e80:	36006264 	strcc	r6, [r0], -r4, ror #4
    2e84:	50225549 	eorpl	r5, r2, r9, asr #10
    2e88:	03050000 	movweq	r0, #20480	; 0x5000
    2e8c:	00000000 	andeq	r0, r0, r0
    2e90:	0041221c 	subeq	r2, r1, ip, lsl r2
    2e94:	22410000 	subcs	r0, r1, #0
    2e98:	1400001c 	strne	r0, [r0], #-28	; 0xffffffe4
    2e9c:	14083e08 	strne	r3, [r8], #-3592	; 0xfffff1f8
    2ea0:	3e080800 	cdpcc	8, 0, cr0, cr8, cr0, {0}
    2ea4:	00000808 	andeq	r0, r0, r8, lsl #16
    2ea8:	0060a000 	rsbeq	sl, r0, r0
    2eac:	08080800 	stmdaeq	r8, {fp}
    2eb0:	00000808 	andeq	r0, r0, r8, lsl #16
    2eb4:	00006060 	andeq	r6, r0, r0, rrx
    2eb8:	08102000 	ldmdaeq	r0, {sp}
    2ebc:	3e000204 	cdpcc	2, 0, cr0, cr0, cr4, {0}
    2ec0:	3e454951 			; <UNDEFINED> instruction: 0x3e454951
    2ec4:	7f420000 	svcvc	0x00420000
    2ec8:	42000040 	andmi	r0, r0, #64	; 0x40
    2ecc:	46495161 	strbmi	r5, [r9], -r1, ror #2
    2ed0:	45412100 	strbmi	r2, [r1, #-256]	; 0xffffff00
    2ed4:	1800314b 	stmdane	r0, {r0, r1, r3, r6, r8, ip, sp}
    2ed8:	107f1214 	rsbsne	r1, pc, r4, lsl r2	; <UNPREDICTABLE>
    2edc:	45452700 	strbmi	r2, [r5, #-1792]	; 0xfffff900
    2ee0:	3c003945 			; <UNDEFINED> instruction: 0x3c003945
    2ee4:	3049494a 	subcc	r4, r9, sl, asr #18
    2ee8:	09710100 	ldmdbeq	r1!, {r8}^
    2eec:	36000305 	strcc	r0, [r0], -r5, lsl #6
    2ef0:	36494949 	strbcc	r4, [r9], -r9, asr #18
    2ef4:	49490600 	stmdbmi	r9, {r9, sl}^
    2ef8:	00001e29 	andeq	r1, r0, r9, lsr #28
    2efc:	00003636 	andeq	r3, r0, r6, lsr r6
    2f00:	36560000 	ldrbcc	r0, [r6], -r0
    2f04:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2f08:	00412214 	subeq	r2, r1, r4, lsl r2
    2f0c:	14141400 	ldrne	r1, [r4], #-1024	; 0xfffffc00
    2f10:	00001414 	andeq	r1, r0, r4, lsl r4
    2f14:	08142241 	ldmdaeq	r4, {r0, r6, r9, sp}
    2f18:	51010200 	mrspl	r0, R9_usr
    2f1c:	32000609 	andcc	r0, r0, #9437184	; 0x900000
    2f20:	3e515949 	vnmlacc.f16	s11, s2, s18	; <UNPREDICTABLE>
    2f24:	11127c00 	tstne	r2, r0, lsl #24
    2f28:	7f007c12 	svcvc	0x00007c12
    2f2c:	36494949 	strbcc	r4, [r9], -r9, asr #18
    2f30:	41413e00 	cmpmi	r1, r0, lsl #28
    2f34:	7f002241 	svcvc	0x00002241
    2f38:	1c224141 	stfnes	f4, [r2], #-260	; 0xfffffefc
    2f3c:	49497f00 	stmdbmi	r9, {r8, r9, sl, fp, ip, sp, lr}^
    2f40:	7f004149 	svcvc	0x00004149
    2f44:	01090909 	tsteq	r9, r9, lsl #18
    2f48:	49413e00 	stmdbmi	r1, {r9, sl, fp, ip, sp}^
    2f4c:	7f007a49 	svcvc	0x00007a49
    2f50:	7f080808 	svcvc	0x00080808
    2f54:	7f410000 	svcvc	0x00410000
    2f58:	20000041 	andcs	r0, r0, r1, asr #32
    2f5c:	013f4140 	teqeq	pc, r0, asr #2
    2f60:	14087f00 	strne	r7, [r8], #-3840	; 0xfffff100
    2f64:	7f004122 	svcvc	0x00004122
    2f68:	40404040 	submi	r4, r0, r0, asr #32
    2f6c:	0c027f00 	stceq	15, cr7, [r2], {-0}
    2f70:	7f007f02 	svcvc	0x00007f02
    2f74:	7f100804 	svcvc	0x00100804
    2f78:	41413e00 	cmpmi	r1, r0, lsl #28
    2f7c:	7f003e41 	svcvc	0x00003e41
    2f80:	06090909 	streq	r0, [r9], -r9, lsl #18
    2f84:	51413e00 	cmppl	r1, r0, lsl #28
    2f88:	7f005e21 	svcvc	0x00005e21
    2f8c:	46291909 	strtmi	r1, [r9], -r9, lsl #18
    2f90:	49494600 	stmdbmi	r9, {r9, sl, lr}^
    2f94:	01003149 	tsteq	r0, r9, asr #2
    2f98:	01017f01 	tsteq	r1, r1, lsl #30
    2f9c:	40403f00 	submi	r3, r0, r0, lsl #30
    2fa0:	1f003f40 	svcne	0x00003f40
    2fa4:	1f204020 	svcne	0x00204020
    2fa8:	38403f00 	stmdacc	r0, {r8, r9, sl, fp, ip, sp}^
    2fac:	63003f40 	movwvs	r3, #3904	; 0xf40
    2fb0:	63140814 	tstvs	r4, #20, 16	; 0x140000
    2fb4:	70080700 	andvc	r0, r8, r0, lsl #14
    2fb8:	61000708 	tstvs	r0, r8, lsl #14
    2fbc:	43454951 	movtmi	r4, #22865	; 0x5951
    2fc0:	417f0000 	cmnmi	pc, r0
    2fc4:	55000041 	strpl	r0, [r0, #-65]	; 0xffffffbf
    2fc8:	552a552a 	strpl	r5, [sl, #-1322]!	; 0xfffffad6
    2fcc:	41410000 	mrsmi	r0, (UNDEF: 65)
    2fd0:	0400007f 	streq	r0, [r0], #-127	; 0xffffff81
    2fd4:	04020102 	streq	r0, [r2], #-258	; 0xfffffefe
    2fd8:	40404000 	submi	r4, r0, r0
    2fdc:	00004040 	andeq	r4, r0, r0, asr #32
    2fe0:	00040201 	andeq	r0, r4, r1, lsl #4
    2fe4:	54542000 	ldrbpl	r2, [r4], #-0
    2fe8:	7f007854 	svcvc	0x00007854
    2fec:	38444448 	stmdacc	r4, {r3, r6, sl, lr}^
    2ff0:	44443800 	strbmi	r3, [r4], #-2048	; 0xfffff800
    2ff4:	38002044 	stmdacc	r0, {r2, r6, sp}
    2ff8:	7f484444 	svcvc	0x00484444
    2ffc:	54543800 	ldrbpl	r3, [r4], #-2048	; 0xfffff800
    3000:	08001854 	stmdaeq	r0, {r2, r4, r6, fp, ip}
    3004:	0201097e 	andeq	r0, r1, #2064384	; 0x1f8000
    3008:	a4a41800 	strtge	r1, [r4], #2048	; 0x800
    300c:	7f007ca4 	svcvc	0x00007ca4
    3010:	78040408 	stmdavc	r4, {r3, sl}
    3014:	7d440000 	stclvc	0, cr0, [r4, #-0]
    3018:	40000040 	andmi	r0, r0, r0, asr #32
    301c:	007d8480 	rsbseq	r8, sp, r0, lsl #9
    3020:	28107f00 	ldmdacs	r0, {r8, r9, sl, fp, ip, sp, lr}
    3024:	00000044 	andeq	r0, r0, r4, asr #32
    3028:	00407f41 	subeq	r7, r0, r1, asr #30
    302c:	18047c00 	stmdane	r4, {sl, fp, ip, sp, lr}
    3030:	7c007804 	stcvc	8, cr7, [r0], {4}
    3034:	78040408 	stmdavc	r4, {r3, sl}
    3038:	44443800 	strbmi	r3, [r4], #-2048	; 0xfffff800
    303c:	fc003844 	stc2	8, cr3, [r0], {68}	; 0x44
    3040:	18242424 	stmdane	r4!, {r2, r5, sl, sp}
    3044:	24241800 	strtcs	r1, [r4], #-2048	; 0xfffff800
    3048:	7c00fc18 	stcvc	12, cr15, [r0], {24}
    304c:	08040408 	stmdaeq	r4, {r3, sl}
    3050:	54544800 	ldrbpl	r4, [r4], #-2048	; 0xfffff800
    3054:	04002054 	streq	r2, [r0], #-84	; 0xffffffac
    3058:	2040443f 	subcs	r4, r0, pc, lsr r4
    305c:	40403c00 	submi	r3, r0, r0, lsl #24
    3060:	1c007c20 	stcne	12, cr7, [r0], {32}
    3064:	1c204020 	stcne	0, cr4, [r0], #-128	; 0xffffff80
    3068:	30403c00 	subcc	r3, r0, r0, lsl #24
    306c:	44003c40 	strmi	r3, [r0], #-3136	; 0xfffff3c0
    3070:	44281028 	strtmi	r1, [r8], #-40	; 0xffffffd8
    3074:	a0a01c00 	adcge	r1, r0, r0, lsl #24
    3078:	44007ca0 	strmi	r7, [r0], #-3232	; 0xfffff360
    307c:	444c5464 	strbmi	r5, [ip], #-1124	; 0xfffffb9c
    3080:	77080000 	strvc	r0, [r8, -r0]
    3084:	00000000 	andeq	r0, r0, r0
    3088:	00007f00 	andeq	r7, r0, r0, lsl #30
    308c:	08770000 	ldmdaeq	r7!, {}^	; <UNPREDICTABLE>
    3090:	10000000 	andne	r0, r0, r0
    3094:	00081008 	andeq	r1, r8, r8
    3098:	00000000 	andeq	r0, r0, r0
    309c:	26000000 	strcs	r0, [r0], -r0
    30a0:	00000bde 	ldrdeq	r0, [r0], -lr
    30a4:	000beb26 	andeq	lr, fp, r6, lsr #22
    30a8:	0bf82600 	bleq	ffe0c8b0 <__bss_end+0xffe0316c>
    30ac:	05260000 	streq	r0, [r6, #-0]!
    30b0:	2600000c 	strcs	r0, [r0], -ip
    30b4:	00000c12 	andeq	r0, r0, r2, lsl ip
    30b8:	00005018 	andeq	r5, r0, r8, lsl r0
    30bc:	000e9800 	andeq	r9, lr, r0, lsl #16
    30c0:	00852900 	addeq	r2, r5, r0, lsl #18
    30c4:	023f0000 	eorseq	r0, pc, #0
    30c8:	0e870300 	cdpeq	3, 8, cr0, cr7, cr0, {0}
    30cc:	1f260000 	svcne	0x00260000
    30d0:	2a00000c 	bcs	3108 <shift+0x3108>
    30d4:	000001ae 	andeq	r0, r0, lr, lsr #3
    30d8:	bc065d01 	stclt	13, cr5, [r6], {1}
    30dc:	5c00000e 	stcpl	0, cr0, [r0], {14}
    30e0:	b0000090 	mullt	r0, r0, r0
    30e4:	01000000 	mrseq	r0, (UNDEF: 0)
    30e8:	000f0f9c 	muleq	pc, ip, pc	; <UNPREDICTABLE>
    30ec:	196e2b00 	stmdbne	lr!, {r8, r9, fp, sp}^
    30f0:	01ec0000 	mvneq	r0, r0
    30f4:	91020000 	mrsls	r0, (UNDEF: 2)
    30f8:	00782c6c 	rsbseq	r2, r8, ip, ror #24
    30fc:	5c295d01 	stcpl	13, cr5, [r9], #-4
    3100:	02000000 	andeq	r0, r0, #0
    3104:	792c6a91 	stmdbvc	ip!, {r0, r4, r7, r9, fp, sp, lr}
    3108:	355d0100 	ldrbcc	r0, [sp, #-256]	; 0xffffff00
    310c:	0000005c 	andeq	r0, r0, ip, asr r0
    3110:	2c689102 	stfcsp	f1, [r8], #-8
    3114:	00727473 	rsbseq	r7, r2, r3, ror r4
    3118:	f1445d01 			; <UNDEFINED> instruction: 0xf1445d01
    311c:	02000001 	andeq	r0, r0, #1
    3120:	782d6491 	stmdavc	sp!, {r0, r4, r7, sl, sp, lr}
    3124:	62010069 	andvs	r0, r1, #105	; 0x69
    3128:	00005c0e 	andeq	r5, r0, lr, lsl #24
    312c:	76910200 	ldrvc	r0, [r1], r0, lsl #4
    3130:	7274702d 	rsbsvc	r7, r4, #45	; 0x2d
    3134:	11630100 	cmnne	r3, r0, lsl #2
    3138:	000001f1 	strdeq	r0, [r0], -r1
    313c:	00709102 	rsbseq	r9, r0, r2, lsl #2
    3140:	00011f2a 	andeq	r1, r1, sl, lsr #30
    3144:	06520100 	ldrbeq	r0, [r2], -r0, lsl #2
    3148:	00000f29 	andeq	r0, r0, r9, lsr #30
    314c:	00009004 	andeq	r9, r0, r4
    3150:	00000058 	andeq	r0, r0, r8, asr r0
    3154:	0f459c01 	svceq	0x00459c01
    3158:	6e2b0000 	cdpvs	0, 2, cr0, cr11, cr0, {0}
    315c:	ec000019 	stc	0, cr0, [r0], {25}
    3160:	02000001 	andeq	r0, r0, #1
    3164:	702d6c91 	mlavc	sp, r1, ip, r6
    3168:	0100746b 	tsteq	r0, fp, ror #8
    316c:	0a062357 	beq	18bed0 <__bss_end+0x18278c>
    3170:	91020000 	mrsls	r0, (UNDEF: 2)
    3174:	842a0074 	strthi	r0, [sl], #-116	; 0xffffff8c
    3178:	01000001 	tsteq	r0, r1
    317c:	0f5f063a 	svceq	0x005f063a
    3180:	8e9c0000 	cdphi	0, 9, cr0, cr12, cr0, {0}
    3184:	01680000 	cmneq	r8, r0
    3188:	9c010000 	stcls	0, cr0, [r1], {-0}
    318c:	00000fb1 			; <UNDEFINED> instruction: 0x00000fb1
    3190:	00196e2b 	andseq	r6, r9, fp, lsr #28
    3194:	0001ec00 	andeq	lr, r1, r0, lsl #24
    3198:	5c910200 	lfmpl	f0, 4, [r1], {0}
    319c:	0100782c 	tsteq	r0, ip, lsr #16
    31a0:	005c273a 	subseq	r2, ip, sl, lsr r7
    31a4:	91020000 	mrsls	r0, (UNDEF: 2)
    31a8:	00792c5a 	rsbseq	r2, r9, sl, asr ip
    31ac:	5c333a01 			; <UNDEFINED> instruction: 0x5c333a01
    31b0:	02000000 	andeq	r0, r0, #0
    31b4:	632c5891 			; <UNDEFINED> instruction: 0x632c5891
    31b8:	3b3a0100 	blcc	e835c0 <__bss_end+0xe79e7c>
    31bc:	00000025 	andeq	r0, r0, r5, lsr #32
    31c0:	2d579102 	ldfcsp	f1, [r7, #-8]
    31c4:	00667562 	rsbeq	r7, r6, r2, ror #10
    31c8:	b10a4301 	tstlt	sl, r1, lsl #6
    31cc:	0200000f 	andeq	r0, r0, #15
    31d0:	702d6091 	mlavc	sp, r1, r0, r6
    31d4:	01007274 	tsteq	r0, r4, ror r2
    31d8:	0fc11e45 	svceq	0x00c11e45
    31dc:	91020000 	mrsls	r0, (UNDEF: 2)
    31e0:	25180074 	ldrcs	r0, [r8, #-116]	; 0xffffff8c
    31e4:	c1000000 	mrsgt	r0, (UNDEF: 0)
    31e8:	1900000f 	stmdbne	r0, {r0, r1, r2, r3}
    31ec:	00000085 	andeq	r0, r0, r5, lsl #1
    31f0:	040d0010 	streq	r0, [sp], #-16
    31f4:	00000a7e 	andeq	r0, r0, lr, ror sl
    31f8:	00015a2a 	andeq	r5, r1, sl, lsr #20
    31fc:	062b0100 	strteq	r0, [fp], -r0, lsl #2
    3200:	00000fe1 	andeq	r0, r0, r1, ror #31
    3204:	00008db0 			; <UNDEFINED> instruction: 0x00008db0
    3208:	000000ec 	andeq	r0, r0, ip, ror #1
    320c:	10269c01 	eorne	r9, r6, r1, lsl #24
    3210:	6e2b0000 	cdpvs	0, 2, cr0, cr11, cr0, {0}
    3214:	ec000019 	stc	0, cr0, [r0], {25}
    3218:	02000001 	andeq	r0, r0, #1
    321c:	782c6c91 	stmdavc	ip!, {r0, r4, r7, sl, fp, sp, lr}
    3220:	282b0100 	stmdacs	fp!, {r8}
    3224:	0000005c 	andeq	r0, r0, ip, asr r0
    3228:	2c6a9102 	stfcsp	f1, [sl], #-8
    322c:	2b010079 	blcs	43418 <__bss_end+0x39cd4>
    3230:	00005c34 	andeq	r5, r0, r4, lsr ip
    3234:	68910200 	ldmvs	r1, {r9}
    3238:	7465732c 	strbtvc	r7, [r5], #-812	; 0xfffffcd4
    323c:	3c2b0100 	stfccs	f0, [fp], #-0
    3240:	000001da 	ldrdeq	r0, [r0], -sl
    3244:	2d679102 	stfcsp	f1, [r7, #-8]!
    3248:	00746b70 	rsbseq	r6, r4, r0, ror fp
    324c:	49263101 	stmdbmi	r6!, {r0, r8, ip, sp}
    3250:	0200000a 	andeq	r0, r0, #10
    3254:	2a007091 	bcs	1f4a0 <__bss_end+0x15d5c>
    3258:	0000013a 	andeq	r0, r0, sl, lsr r1
    325c:	40062001 	andmi	r2, r6, r1
    3260:	34000010 	strcc	r0, [r0], #-16
    3264:	7c00008d 	stcvc	0, cr0, [r0], {141}	; 0x8d
    3268:	01000000 	mrseq	r0, (UNDEF: 0)
    326c:	00106b9c 	mulseq	r0, ip, fp
    3270:	196e2b00 	stmdbne	lr!, {r8, r9, fp, sp}^
    3274:	01ec0000 	mvneq	r0, r0
    3278:	91020000 	mrsls	r0, (UNDEF: 2)
    327c:	1a9c2e6c 	bne	fe70ec34 <__bss_end+0xfe7054f0>
    3280:	20010000 	andcs	r0, r1, r0
    3284:	0001da20 	andeq	sp, r1, r0, lsr #20
    3288:	6b910200 	blvs	fe443a90 <__bss_end+0xfe43a34c>
    328c:	746b702d 	strbtvc	r7, [fp], #-45	; 0xffffffd3
    3290:	1b250100 	blne	943698 <__bss_end+0x939f54>
    3294:	00000a21 	andeq	r0, r0, r1, lsr #20
    3298:	00749102 	rsbseq	r9, r4, r2, lsl #2
    329c:	0001002f 	andeq	r0, r1, pc, lsr #32
    32a0:	061b0100 	ldreq	r0, [fp], -r0, lsl #2
    32a4:	00001085 	andeq	r1, r0, r5, lsl #1
    32a8:	00008d0c 	andeq	r8, r0, ip, lsl #26
    32ac:	00000028 	andeq	r0, r0, r8, lsr #32
    32b0:	10929c01 	addsne	r9, r2, r1, lsl #24
    32b4:	6e2b0000 	cdpvs	0, 2, cr0, cr11, cr0, {0}
    32b8:	ff000019 			; <UNDEFINED> instruction: 0xff000019
    32bc:	02000001 	andeq	r0, r0, #1
    32c0:	30007491 	mulcc	r0, r1, r4
    32c4:	000000dc 	ldrdeq	r0, [r0], -ip
    32c8:	a3011101 	movwge	r1, #4353	; 0x1101
    32cc:	00000010 	andeq	r0, r0, r0, lsl r0
    32d0:	000010b6 	strheq	r1, [r0], -r6
    32d4:	00196e31 	andseq	r6, r9, r1, lsr lr
    32d8:	0001ec00 	andeq	lr, r1, r0, lsl #24
    32dc:	192f3100 	stmdbne	pc!, {r8, ip, sp}	; <UNPREDICTABLE>
    32e0:	003f0000 	eorseq	r0, pc, r0
    32e4:	32000000 	andcc	r0, r0, #0
    32e8:	00001092 	muleq	r0, r2, r0
    32ec:	00001ae4 	andeq	r1, r0, r4, ror #21
    32f0:	000010d1 	ldrdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    32f4:	00008cc0 	andeq	r8, r0, r0, asr #25
    32f8:	0000004c 	andeq	r0, r0, ip, asr #32
    32fc:	10da9c01 	sbcsne	r9, sl, r1, lsl #24
    3300:	a3330000 	teqge	r3, #0
    3304:	02000010 	andeq	r0, r0, #16
    3308:	30007491 	mulcc	r0, r1, r4
    330c:	000000b8 	strheq	r0, [r0], -r8
    3310:	eb010a01 	bl	45b1c <__bss_end+0x3c3d8>
    3314:	00000010 	andeq	r0, r0, r0, lsl r0
    3318:	00001101 	andeq	r1, r0, r1, lsl #2
    331c:	00196e31 	andseq	r6, r9, r1, lsr lr
    3320:	0001ec00 	andeq	lr, r1, r0, lsl #24
    3324:	19d93400 	ldmibne	r9, {sl, ip, sp}^
    3328:	0a010000 	beq	43330 <__bss_end+0x39bec>
    332c:	0001f12a 	andeq	pc, r1, sl, lsr #2
    3330:	da350000 	ble	d43338 <__bss_end+0xd39bf4>
    3334:	a5000010 	strge	r0, [r0, #-16]
    3338:	1800001a 	stmdane	r0, {r1, r3, r4}
    333c:	58000011 	stmdapl	r0, {r0, r4}
    3340:	6800008c 	stmdavs	r0, {r2, r3, r7}
    3344:	01000000 	mrseq	r0, (UNDEF: 0)
    3348:	10eb339c 	smlalne	r3, fp, ip, r3
    334c:	91020000 	mrsls	r0, (UNDEF: 2)
    3350:	10f43374 	rscsne	r3, r4, r4, ror r3
    3354:	91020000 	mrsls	r0, (UNDEF: 2)
    3358:	22000070 	andcs	r0, r0, #112	; 0x70
    335c:	02000000 	andeq	r0, r0, #0
    3360:	000b8b00 	andeq	r8, fp, r0, lsl #22
    3364:	09010400 	stmdbeq	r1, {sl}
    3368:	0c00000d 	stceq	0, cr0, [r0], {13}
    336c:	18000091 	stmdane	r0, {r0, r4, r7}
    3370:	fb000093 	blx	35c6 <shift+0x35c6>
    3374:	2b00001a 	blcs	33e4 <shift+0x33e4>
    3378:	9000001b 	andls	r0, r0, fp, lsl r0
    337c:	0100001b 	tsteq	r0, fp, lsl r0
    3380:	00002280 	andeq	r2, r0, r0, lsl #5
    3384:	9f000200 	svcls	0x00000200
    3388:	0400000b 	streq	r0, [r0], #-11
    338c:	000d8601 	andeq	r8, sp, r1, lsl #12
    3390:	00931800 	addseq	r1, r3, r0, lsl #16
    3394:	00931c00 	addseq	r1, r3, r0, lsl #24
    3398:	001afb00 	andseq	pc, sl, r0, lsl #22
    339c:	001b2b00 	andseq	r2, fp, r0, lsl #22
    33a0:	001b9000 	andseq	r9, fp, r0
    33a4:	09800100 	stmibeq	r0, {r8}
    33a8:	0400000a 	streq	r0, [r0], #-10
    33ac:	000bb300 	andeq	fp, fp, r0, lsl #6
    33b0:	30010400 	andcc	r0, r1, r0, lsl #8
    33b4:	0c00002c 	stceq	0, cr0, [r0], {44}	; 0x2c
    33b8:	00001e72 	andeq	r1, r0, r2, ror lr
    33bc:	00001b2b 	andeq	r1, r0, fp, lsr #22
    33c0:	00000de6 	andeq	r0, r0, r6, ror #27
    33c4:	69050402 	stmdbvs	r5, {r1, sl}
    33c8:	0300746e 	movweq	r7, #1134	; 0x46e
    33cc:	1fd60704 	svcne	0x00d60704
    33d0:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    33d4:	00035f05 	andeq	r5, r3, r5, lsl #30
    33d8:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    33dc:	00002777 	andeq	r2, r0, r7, ror r7
    33e0:	001edf04 	andseq	sp, lr, r4, lsl #30
    33e4:	162a0100 	strtne	r0, [sl], -r0, lsl #2
    33e8:	00000024 	andeq	r0, r0, r4, lsr #32
    33ec:	00234204 	eoreq	r4, r3, r4, lsl #4
    33f0:	152f0100 	strne	r0, [pc, #-256]!	; 32f8 <shift+0x32f8>
    33f4:	00000051 	andeq	r0, r0, r1, asr r0
    33f8:	00570405 	subseq	r0, r7, r5, lsl #8
    33fc:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
    3400:	66000000 	strvs	r0, [r0], -r0
    3404:	07000000 	streq	r0, [r0, -r0]
    3408:	00000066 	andeq	r0, r0, r6, rrx
    340c:	6c040500 	cfstr32vs	mvfx0, [r4], {-0}
    3410:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    3414:	002be104 	eoreq	lr, fp, r4, lsl #2
    3418:	0f360100 	svceq	0x00360100
    341c:	00000079 	andeq	r0, r0, r9, ror r0
    3420:	007f0405 	rsbseq	r0, pc, r5, lsl #8
    3424:	1d060000 	stcne	0, cr0, [r6, #-0]
    3428:	93000000 	movwls	r0, #0
    342c:	07000000 	streq	r0, [r0, -r0]
    3430:	00000066 	andeq	r0, r0, r6, rrx
    3434:	00006607 	andeq	r6, r0, r7, lsl #12
    3438:	01030000 	mrseq	r0, (UNDEF: 3)
    343c:	00110008 	andseq	r0, r1, r8
    3440:	25a50900 	strcs	r0, [r5, #2304]!	; 0x900
    3444:	bb010000 	bllt	4344c <__bss_end+0x39d08>
    3448:	00004512 	andeq	r4, r0, r2, lsl r5
    344c:	2c0f0900 			; <UNDEFINED> instruction: 0x2c0f0900
    3450:	be010000 	cdplt	0, 0, cr0, cr1, cr0, {0}
    3454:	00006d10 	andeq	r6, r0, r0, lsl sp
    3458:	06010300 	streq	r0, [r1], -r0, lsl #6
    345c:	00001102 	andeq	r1, r0, r2, lsl #2
    3460:	0022490a 	eoreq	r4, r2, sl, lsl #18
    3464:	93010700 	movwls	r0, #5888	; 0x1700
    3468:	02000000 	andeq	r0, r0, #0
    346c:	01e60617 	mvneq	r0, r7, lsl r6
    3470:	460b0000 	strmi	r0, [fp], -r0
    3474:	0000001d 	andeq	r0, r0, sp, lsl r0
    3478:	0021410b 	eoreq	r4, r1, fp, lsl #2
    347c:	9d0b0100 	stflss	f0, [fp, #-0]
    3480:	02000026 	andeq	r0, r0, #38	; 0x26
    3484:	002b250b 	eoreq	r2, fp, fp, lsl #10
    3488:	290b0300 	stmdbcs	fp, {r8, r9}
    348c:	04000026 	streq	r0, [r0], #-38	; 0xffffffda
    3490:	0029ec0b 	eoreq	lr, r9, fp, lsl #24
    3494:	120b0500 	andne	r0, fp, #0, 10
    3498:	06000029 	streq	r0, [r0], -r9, lsr #32
    349c:	001d670b 	andseq	r6, sp, fp, lsl #14
    34a0:	010b0700 	tsteq	fp, r0, lsl #14
    34a4:	0800002a 	stmdaeq	r0, {r1, r3, r5}
    34a8:	002a0f0b 	eoreq	r0, sl, fp, lsl #30
    34ac:	000b0900 	andeq	r0, fp, r0, lsl #18
    34b0:	0a00002b 	beq	3564 <shift+0x3564>
    34b4:	00256b0b 	eoreq	r6, r5, fp, lsl #22
    34b8:	200b0b00 	andcs	r0, fp, r0, lsl #22
    34bc:	0c00001f 	stceq	0, cr0, [r0], {31}
    34c0:	0022d20b 	eoreq	sp, r2, fp, lsl #4
    34c4:	580b0d00 	stmdapl	fp, {r8, sl, fp}
    34c8:	0e00002a 	cdpeq	0, 0, cr0, cr0, cr10, {1}
    34cc:	00228d0b 	eoreq	r8, r2, fp, lsl #26
    34d0:	a30b0f00 	movwge	r0, #48896	; 0xbf00
    34d4:	10000022 	andne	r0, r0, r2, lsr #32
    34d8:	0021780b 	eoreq	r7, r1, fp, lsl #16
    34dc:	0d0b1100 	stfeqs	f1, [fp, #-0]
    34e0:	12000026 	andne	r0, r0, #38	; 0x26
    34e4:	0022050b 	eoreq	r0, r2, fp, lsl #10
    34e8:	bd0b1300 	stclt	3, cr1, [fp, #-0]
    34ec:	1400002e 	strne	r0, [r0], #-46	; 0xffffffd2
    34f0:	0026d50b 	eoreq	sp, r6, fp, lsl #10
    34f4:	320b1500 	andcc	r1, fp, #0, 10
    34f8:	16000024 	strne	r0, [r0], -r4, lsr #32
    34fc:	001dc40b 	andseq	ip, sp, fp, lsl #8
    3500:	480b1700 	stmdami	fp, {r8, r9, sl, ip}
    3504:	1800002b 	stmdane	r0, {r0, r1, r3, r5}
    3508:	002d520b 	eoreq	r5, sp, fp, lsl #4
    350c:	560b1900 	strpl	r1, [fp], -r0, lsl #18
    3510:	1a00002b 	bne	35c4 <shift+0x35c4>
    3514:	0022550b 	eoreq	r5, r2, fp, lsl #10
    3518:	640b1b00 	strvs	r1, [fp], #-2816	; 0xfffff500
    351c:	1c00002b 	stcne	0, cr0, [r0], {43}	; 0x2b
    3520:	001c200b 	andseq	r2, ip, fp
    3524:	720b1d00 	andvc	r1, fp, #0, 26
    3528:	1e00002b 	cdpne	0, 0, cr0, cr0, cr11, {1}
    352c:	002b800b 	eoreq	r8, fp, fp
    3530:	b90b1f00 	stmdblt	fp, {r8, r9, sl, fp, ip}
    3534:	2000001b 	andcs	r0, r0, fp, lsl r0
    3538:	0027f80b 	eoreq	pc, r7, fp, lsl #16
    353c:	df0b2100 	svcle	0x000b2100
    3540:	22000025 	andcs	r0, r0, #37	; 0x25
    3544:	002b3b0b 	eoreq	r3, fp, fp, lsl #22
    3548:	af0b2300 	svcge	0x000b2300
    354c:	24000024 	strcs	r0, [r0], #-36	; 0xffffffdc
    3550:	0029030b 	eoreq	r0, r9, fp, lsl #6
    3554:	a50b2500 	strge	r2, [fp, #-1280]	; 0xfffffb00
    3558:	26000023 	strcs	r0, [r0], -r3, lsr #32
    355c:	0020810b 	eoreq	r8, r0, fp, lsl #2
    3560:	c30b2700 	movwgt	r2, #46848	; 0xb700
    3564:	28000023 	stmdacs	r0, {r0, r1, r5}
    3568:	00211d0b 	eoreq	r1, r1, fp, lsl #26
    356c:	d30b2900 	movwle	r2, #47360	; 0xb900
    3570:	2a000023 	bcs	3604 <shift+0x3604>
    3574:	0025510b 	eoreq	r5, r5, fp, lsl #2
    3578:	4c0b2b00 			; <UNDEFINED> instruction: 0x4c0b2b00
    357c:	2c000023 	stccs	0, cr0, [r0], {35}	; 0x23
    3580:	0028170b 	eoreq	r1, r8, fp, lsl #14
    3584:	c20b2d00 	andgt	r2, fp, #0, 26
    3588:	2e000020 	cdpcs	0, 0, cr0, cr0, cr0, {1}
    358c:	22df0a00 	sbcscs	r0, pc, #0, 20
    3590:	01070000 	mrseq	r0, (UNDEF: 7)
    3594:	00000093 	muleq	r0, r3, r0
    3598:	9f061703 	svcls	0x00061703
    359c:	0b000004 	bleq	35b4 <shift+0x35b4>
    35a0:	00001f34 	andeq	r1, r0, r4, lsr pc
    35a4:	2de60b00 			; <UNDEFINED> instruction: 0x2de60b00
    35a8:	0b010000 	bleq	435b0 <__bss_end+0x39e6c>
    35ac:	00001f44 	andeq	r1, r0, r4, asr #30
    35b0:	1f670b02 	svcne	0x00670b02
    35b4:	0b030000 	bleq	c35bc <__bss_end+0xb9e78>
    35b8:	00002c1f 	andeq	r2, r0, pc, lsl ip
    35bc:	287d0b04 	ldmdacs	sp!, {r2, r8, r9, fp}^
    35c0:	0b050000 	bleq	1435c8 <__bss_end+0x139e84>
    35c4:	00001ff1 	strdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    35c8:	21660b06 	cmncs	r6, r6, lsl #22
    35cc:	0b070000 	bleq	1c35d4 <__bss_end+0x1b9e90>
    35d0:	00001f77 	andeq	r1, r0, r7, ror pc
    35d4:	2eac0b08 	vfmacs.f64	d0, d12, d8
    35d8:	0b090000 	bleq	2435e0 <__bss_end+0x239e9c>
    35dc:	00001c97 	muleq	r0, r7, ip
    35e0:	2dd50b0a 	vldrcs	d16, [r5, #40]	; 0x28
    35e4:	0b0b0000 	bleq	2c35ec <__bss_end+0x2b9ea8>
    35e8:	000024be 			; <UNDEFINED> instruction: 0x000024be
    35ec:	2d690b0c 	vstmdbcs	r9!, {d16-d21}
    35f0:	0b0d0000 	bleq	3435f8 <__bss_end+0x339eb4>
    35f4:	00002805 	andeq	r2, r0, r5, lsl #16
    35f8:	2a9e0b0e 	bcs	fe786238 <__bss_end+0xfe77caf4>
    35fc:	0b0f0000 	bleq	3c3604 <__bss_end+0x3b9ec0>
    3600:	00002052 	andeq	r2, r0, r2, asr r0
    3604:	1f540b10 	svcne	0x00540b10
    3608:	0b110000 	bleq	443610 <__bss_end+0x439ecc>
    360c:	000027bd 			; <UNDEFINED> instruction: 0x000027bd
    3610:	203d0b12 	eorscs	r0, sp, r2, lsl fp
    3614:	0b130000 	bleq	4c361c <__bss_end+0x4b9ed8>
    3618:	00002dc4 	andeq	r2, r0, r4, asr #27
    361c:	1cc10b14 	vstmiane	r1, {d16-d25}
    3620:	0b150000 	bleq	543628 <__bss_end+0x539ee4>
    3624:	0000240d 	andeq	r2, r0, sp, lsl #8
    3628:	1f870b16 	svcne	0x00870b16
    362c:	0b170000 	bleq	5c3634 <__bss_end+0x5b9ef0>
    3630:	00001c5e 	andeq	r1, r0, lr, asr ip
    3634:	2e520b18 	vmovcs.s8	r0, d2[0]
    3638:	0b190000 	bleq	643640 <__bss_end+0x639efc>
    363c:	00002b0d 	andeq	r2, r0, sp, lsl #22
    3640:	29210b1a 	stmdbcs	r1!, {r1, r3, r4, r8, r9, fp}
    3644:	0b1b0000 	bleq	6c364c <__bss_end+0x6b9f08>
    3648:	00002a85 	andeq	r2, r0, r5, lsl #21
    364c:	2be90b1c 	blcs	ffa462c4 <__bss_end+0xffa3cb80>
    3650:	0b1d0000 	bleq	743658 <__bss_end+0x739f14>
    3654:	00001fa7 	andeq	r1, r0, r7, lsr #31
    3658:	1d320b1e 	vldmdbne	r2!, {d0-d14}
    365c:	0b1f0000 	bleq	7c3664 <__bss_end+0x7b9f20>
    3660:	0000293a 	andeq	r2, r0, sl, lsr r9
    3664:	209e0b20 	addscs	r0, lr, r0, lsr #22
    3668:	0b210000 	bleq	843670 <__bss_end+0x839f2c>
    366c:	0000288f 	andeq	r2, r0, pc, lsl #17
    3670:	248f0b22 	strcs	r0, [pc], #2850	; 3678 <shift+0x3678>
    3674:	0b230000 	bleq	8c367c <__bss_end+0x8b9f38>
    3678:	00001f97 	muleq	r0, r7, pc	; <UNPREDICTABLE>
    367c:	2a3d0b24 	bcs	f46314 <__bss_end+0xf3cbd0>
    3680:	0b250000 	bleq	943688 <__bss_end+0x939f44>
    3684:	00001eaa 	andeq	r1, r0, sl, lsr #29
    3688:	2bce0b26 	blcs	ff386328 <__bss_end+0xff37cbe4>
    368c:	0b270000 	bleq	9c3694 <__bss_end+0x9b9f50>
    3690:	00002e99 	muleq	r0, r9, lr
    3694:	27900b28 	ldrcs	r0, [r0, r8, lsr #22]
    3698:	0b290000 	bleq	a436a0 <__bss_end+0xa39f5c>
    369c:	00002237 	andeq	r2, r0, r7, lsr r2
    36a0:	29640b2a 	stmdbcs	r4!, {r1, r3, r5, r8, r9, fp}^
    36a4:	0b2b0000 	bleq	ac36ac <__bss_end+0xab9f68>
    36a8:	000024ed 	andeq	r2, r0, sp, ror #9
    36ac:	1d850b2c 	vstrne	d0, [r5, #176]	; 0xb0
    36b0:	0b2d0000 	bleq	b436b8 <__bss_end+0xb39f74>
    36b4:	00001d09 	andeq	r1, r0, r9, lsl #26
    36b8:	2d270b2e 	vstmdbcs	r7!, {d0-d22}
    36bc:	0b2f0000 	bleq	bc36c4 <__bss_end+0xbb9f80>
    36c0:	0000247b 	andeq	r2, r0, fp, ror r4
    36c4:	20170b30 	andscs	r0, r7, r0, lsr fp
    36c8:	0b310000 	bleq	c436d0 <__bss_end+0xc39f8c>
    36cc:	0000245a 	andeq	r2, r0, sl, asr r4
    36d0:	27090b32 	smladxcs	r9, r2, fp, r0
    36d4:	0b330000 	bleq	cc36dc <__bss_end+0xcb9f98>
    36d8:	00001cf7 	strdeq	r1, [r0], -r7
    36dc:	2e870b34 	vdupcs.16	d7, r0
    36e0:	0b350000 	bleq	d436e8 <__bss_end+0xd39fa4>
    36e4:	0000253e 	andeq	r2, r0, lr, lsr r5
    36e8:	21d00b36 	bicscs	r0, r0, r6, lsr fp
    36ec:	0b370000 	bleq	dc36f4 <__bss_end+0xdb9fb0>
    36f0:	0000257b 	andeq	r2, r0, fp, ror r5
    36f4:	2d8f0b38 	vstrcs	d0, [pc, #224]	; 37dc <shift+0x37dc>
    36f8:	0b390000 	bleq	e43700 <__bss_end+0xe39fbc>
    36fc:	00001e3c 	andeq	r1, r0, ip, lsr lr
    3700:	21e30b3a 	mvncs	r0, sl, lsr fp
    3704:	0b3b0000 	bleq	ec370c <__bss_end+0xeb9fc8>
    3708:	000021af 	andeq	r2, r0, pc, lsr #3
    370c:	1bc80b3c 	blne	ff206404 <__bss_end+0xff1fccc0>
    3710:	0b3d0000 	bleq	f43718 <__bss_end+0xf39fd4>
    3714:	000024d0 	ldrdeq	r2, [r0], -r0
    3718:	22af0b3e 	adccs	r0, pc, #63488	; 0xf800
    371c:	0b3f0000 	bleq	fc3724 <__bss_end+0xfb9fe0>
    3720:	00001d50 	andeq	r1, r0, r0, asr sp
    3724:	2d3b0b40 	vldmdbcs	fp!, {d0-d31}
    3728:	0b410000 	bleq	1043730 <__bss_end+0x1039fec>
    372c:	00002420 	andeq	r2, r0, r0, lsr #8
    3730:	21990b42 	orrscs	r0, r9, r2, asr #22
    3734:	0b430000 	bleq	10c373c <__bss_end+0x10b9ff8>
    3738:	00001c09 	andeq	r1, r0, r9, lsl #24
    373c:	237d0b44 	cmncs	sp, #68, 22	; 0x11000
    3740:	0b450000 	bleq	1143748 <__bss_end+0x113a004>
    3744:	00002369 	andeq	r2, r0, r9, ror #6
    3748:	28e40b46 	stmiacs	r4!, {r1, r2, r6, r8, r9, fp}^
    374c:	0b470000 	bleq	11c3754 <__bss_end+0x11ba010>
    3750:	000029ac 	andeq	r2, r0, ip, lsr #19
    3754:	2d060b48 	vstrcs	d0, [r6, #-288]	; 0xfffffee0
    3758:	0b490000 	bleq	1243760 <__bss_end+0x123a01c>
    375c:	000020cf 	andeq	r2, r0, pc, asr #1
    3760:	26bf0b4a 	ldrtcs	r0, [pc], sl, asr #22
    3764:	0b4b0000 	bleq	12c376c <__bss_end+0x12ba028>
    3768:	00002979 	andeq	r2, r0, r9, ror r9
    376c:	28260b4c 	stmdacs	r6!, {r2, r3, r6, r8, r9, fp}
    3770:	0b4d0000 	bleq	1343778 <__bss_end+0x133a034>
    3774:	0000283a 	andeq	r2, r0, sl, lsr r8
    3778:	284e0b4e 	stmdacs	lr, {r1, r2, r3, r6, r8, r9, fp}^
    377c:	0b4f0000 	bleq	13c3784 <__bss_end+0x13ba040>
    3780:	00001eca 	andeq	r1, r0, sl, asr #29
    3784:	1e270b50 			; <UNDEFINED> instruction: 0x1e270b50
    3788:	0b510000 	bleq	1443790 <__bss_end+0x143a04c>
    378c:	00001e4f 	andeq	r1, r0, pc, asr #28
    3790:	2ab00b52 	bcs	fec064e0 <__bss_end+0xfebfcd9c>
    3794:	0b530000 	bleq	14c379c <__bss_end+0x14ba058>
    3798:	00001e95 	muleq	r0, r5, lr
    379c:	2ac40b54 	bcs	ff1064f4 <__bss_end+0xff0fcdb0>
    37a0:	0b550000 	bleq	15437a8 <__bss_end+0x153a064>
    37a4:	00002ad8 	ldrdeq	r2, [r0], -r8
    37a8:	2aec0b56 	bcs	ffb06508 <__bss_end+0xffafcdc4>
    37ac:	0b570000 	bleq	15c37b4 <__bss_end+0x15ba070>
    37b0:	00002029 	andeq	r2, r0, r9, lsr #32
    37b4:	20030b58 	andcs	r0, r3, r8, asr fp
    37b8:	0b590000 	bleq	16437c0 <__bss_end+0x163a07c>
    37bc:	00002391 	muleq	r0, r1, r3
    37c0:	258e0b5a 	strcs	r0, [lr, #2906]	; 0xb5a
    37c4:	0b5b0000 	bleq	16c37cc <__bss_end+0x16ba088>
    37c8:	00002317 	andeq	r2, r0, r7, lsl r3
    37cc:	1b9c0b5c 	blne	fe706544 <__bss_end+0xfe6fce00>
    37d0:	0b5d0000 	bleq	17437d8 <__bss_end+0x173a094>
    37d4:	00002151 	andeq	r2, r0, r1, asr r1
    37d8:	25b70b5e 	ldrcs	r0, [r7, #2910]!	; 0xb5e
    37dc:	0b5f0000 	bleq	17c37e4 <__bss_end+0x17ba0a0>
    37e0:	000023e3 	andeq	r2, r0, r3, ror #7
    37e4:	28a20b60 	stmiacs	r2!, {r5, r6, r8, r9, fp}
    37e8:	0b610000 	bleq	18437f0 <__bss_end+0x183a0ac>
    37ec:	00002e04 	andeq	r2, r0, r4, lsl #28
    37f0:	26aa0b62 	strtcs	r0, [sl], r2, ror #22
    37f4:	0b630000 	bleq	18c37fc <__bss_end+0x18ba0b8>
    37f8:	000020f4 	strdeq	r2, [r0], -r4
    37fc:	1c700b64 			; <UNDEFINED> instruction: 0x1c700b64
    3800:	0b650000 	bleq	1943808 <__bss_end+0x193a0c4>
    3804:	00001c2e 	andeq	r1, r0, lr, lsr #24
    3808:	25ef0b66 	strbcs	r0, [pc, #2918]!	; 4376 <shift+0x4376>
    380c:	0b670000 	bleq	19c3814 <__bss_end+0x19ba0d0>
    3810:	0000272a 	andeq	r2, r0, sl, lsr #14
    3814:	28c60b68 	stmiacs	r6, {r3, r5, r6, r8, r9, fp}^
    3818:	0b690000 	bleq	1a43820 <__bss_end+0x1a3a0dc>
    381c:	000023f8 	strdeq	r2, [r0], -r8
    3820:	2e3d0b6a 	vsubcs.f64	d0, d13, d26
    3824:	0b6b0000 	bleq	1ac382c <__bss_end+0x1aba0e8>
    3828:	0000250e 	andeq	r2, r0, lr, lsl #10
    382c:	1bed0b6c 	blne	ffb465e4 <__bss_end+0xffb3cea0>
    3830:	0b6d0000 	bleq	1b43838 <__bss_end+0x1b3a0f4>
    3834:	00001d1d 	andeq	r1, r0, sp, lsl sp
    3838:	21080b6e 	tstcs	r8, lr, ror #22
    383c:	0b6f0000 	bleq	1bc3844 <__bss_end+0x1bba100>
    3840:	00001fb8 			; <UNDEFINED> instruction: 0x00001fb8
    3844:	02030070 	andeq	r0, r3, #112	; 0x70
    3848:	0012bb07 	andseq	fp, r2, r7, lsl #22
    384c:	04bc0c00 	ldrteq	r0, [ip], #3072	; 0xc00
    3850:	04b10000 	ldrteq	r0, [r1], #0
    3854:	000d0000 	andeq	r0, sp, r0
    3858:	0004a60e 	andeq	sl, r4, lr, lsl #12
    385c:	c8040500 	stmdagt	r4, {r8, sl}
    3860:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
    3864:	000004b6 			; <UNDEFINED> instruction: 0x000004b6
    3868:	09080103 	stmdbeq	r8, {r0, r1, r8}
    386c:	0e000011 	mcreq	0, 0, r0, cr0, cr1, {0}
    3870:	000004c1 	andeq	r0, r0, r1, asr #9
    3874:	001db50f 	andseq	fp, sp, pc, lsl #10
    3878:	01440400 	cmpeq	r4, r0, lsl #8
    387c:	0004b11a 	andeq	fp, r4, sl, lsl r1
    3880:	21890f00 	orrcs	r0, r9, r0, lsl #30
    3884:	79040000 	stmdbvc	r4, {}	; <UNPREDICTABLE>
    3888:	04b11a01 	ldrteq	r1, [r1], #2561	; 0xa01
    388c:	c10c0000 	mrsgt	r0, (UNDEF: 12)
    3890:	f2000004 	vhadd.s8	d0, d0, d4
    3894:	0d000004 	stceq	0, cr0, [r0, #-16]
    3898:	23b50900 			; <UNDEFINED> instruction: 0x23b50900
    389c:	2d050000 	stccs	0, cr0, [r5, #-0]
    38a0:	0004e70d 	andeq	lr, r4, sp, lsl #14
    38a4:	2baa0900 	blcs	fea85cac <__bss_end+0xfea7c568>
    38a8:	35050000 	strcc	r0, [r5, #-0]
    38ac:	0001e61c 	andeq	lr, r1, ip, lsl r6
    38b0:	20650a00 	rsbcs	r0, r5, r0, lsl #20
    38b4:	01070000 	mrseq	r0, (UNDEF: 7)
    38b8:	00000093 	muleq	r0, r3, r0
    38bc:	7d0e3705 	stcvc	7, cr3, [lr, #-20]	; 0xffffffec
    38c0:	0b000005 	bleq	38dc <shift+0x38dc>
    38c4:	00001c02 	andeq	r1, r0, r2, lsl #24
    38c8:	229c0b00 	addscs	r0, ip, #0, 22
    38cc:	0b010000 	bleq	438d4 <__bss_end+0x3a190>
    38d0:	00002da1 	andeq	r2, r0, r1, lsr #27
    38d4:	2d7c0b02 	vldmdbcs	ip!, {d16}
    38d8:	0b030000 	bleq	c38e0 <__bss_end+0xba19c>
    38dc:	00002658 	andeq	r2, r0, r8, asr r6
    38e0:	29fa0b04 	ldmibcs	sl!, {r2, r8, r9, fp}^
    38e4:	0b050000 	bleq	1438ec <__bss_end+0x13a1a8>
    38e8:	00001df8 	strdeq	r1, [r0], -r8
    38ec:	1dda0b06 	vldrne	d16, [sl, #24]
    38f0:	0b070000 	bleq	1c38f8 <__bss_end+0x1ba1b4>
    38f4:	00001f2d 	andeq	r1, r0, sp, lsr #30
    38f8:	24e60b08 	strbtcs	r0, [r6], #2824	; 0xb08
    38fc:	0b090000 	bleq	243904 <__bss_end+0x23a1c0>
    3900:	00001dff 	strdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    3904:	1e6b0b0a 	vmulne.f64	d16, d11, d10
    3908:	0b0b0000 	bleq	2c3910 <__bss_end+0x2ba1cc>
    390c:	00001e64 	andeq	r1, r0, r4, ror #28
    3910:	1df10b0c 			; <UNDEFINED> instruction: 0x1df10b0c
    3914:	0b0d0000 	bleq	34391c <__bss_end+0x33a1d8>
    3918:	00002a51 	andeq	r2, r0, r1, asr sl
    391c:	27480b0e 	strbcs	r0, [r8, -lr, lsl #22]
    3920:	000f0000 	andeq	r0, pc, r0
    3924:	0028fc04 	eoreq	pc, r8, r4, lsl #24
    3928:	013c0500 	teqeq	ip, r0, lsl #10
    392c:	0000050a 	andeq	r0, r0, sl, lsl #10
    3930:	0029cd09 	eoreq	ip, r9, r9, lsl #26
    3934:	0f3e0500 	svceq	0x003e0500
    3938:	0000057d 	andeq	r0, r0, sp, ror r5
    393c:	002a7409 	eoreq	r7, sl, r9, lsl #8
    3940:	0c470500 	cfstr64eq	mvdx0, [r7], {-0}
    3944:	0000001d 	andeq	r0, r0, sp, lsl r0
    3948:	001da509 	andseq	sl, sp, r9, lsl #10
    394c:	0c480500 	cfstr64eq	mvdx0, [r8], {-0}
    3950:	0000001d 	andeq	r0, r0, sp, lsl r0
    3954:	002b8e10 	eoreq	r8, fp, r0, lsl lr
    3958:	29dc0900 	ldmibcs	ip, {r8, fp}^
    395c:	49050000 	stmdbmi	r5, {}	; <UNPREDICTABLE>
    3960:	0005be14 	andeq	fp, r5, r4, lsl lr
    3964:	ad040500 	cfstr32ge	mvfx0, [r4, #-0]
    3968:	11000005 	tstne	r0, r5
    396c:	00226609 	eoreq	r6, r2, r9, lsl #12
    3970:	0f4b0500 	svceq	0x004b0500
    3974:	000005d1 	ldrdeq	r0, [r0], -r1
    3978:	05c40405 	strbeq	r0, [r4, #1029]	; 0x405
    397c:	4f120000 	svcmi	0x00120000
    3980:	09000029 	stmdbeq	r0, {r0, r3, r5}
    3984:	00002645 	andeq	r2, r0, r5, asr #12
    3988:	e80d4f05 	stmda	sp, {r0, r2, r8, r9, sl, fp, lr}
    398c:	05000005 	streq	r0, [r0, #-5]
    3990:	0005d704 	andeq	sp, r5, r4, lsl #14
    3994:	1f131300 	svcne	0x00131300
    3998:	05340000 	ldreq	r0, [r4, #-0]!
    399c:	19150158 	ldmdbne	r5, {r3, r4, r6, r8}
    39a0:	14000006 	strne	r0, [r0], #-6
    39a4:	000023be 			; <UNDEFINED> instruction: 0x000023be
    39a8:	0f015a05 	svceq	0x00015a05
    39ac:	000004b6 			; <UNDEFINED> instruction: 0x000004b6
    39b0:	1ef71400 	cdpne	4, 15, cr1, cr7, cr0, {0}
    39b4:	5b050000 	blpl	1439bc <__bss_end+0x13a278>
    39b8:	061e1401 	ldreq	r1, [lr], -r1, lsl #8
    39bc:	00040000 	andeq	r0, r4, r0
    39c0:	0005ee0e 	andeq	lr, r5, lr, lsl #28
    39c4:	00b90c00 	adcseq	r0, r9, r0, lsl #24
    39c8:	062e0000 	strteq	r0, [lr], -r0
    39cc:	24150000 	ldrcs	r0, [r5], #-0
    39d0:	2d000000 	stccs	0, cr0, [r0, #-0]
    39d4:	06190c00 	ldreq	r0, [r9], -r0, lsl #24
    39d8:	06390000 	ldrteq	r0, [r9], -r0
    39dc:	000d0000 	andeq	r0, sp, r0
    39e0:	00062e0e 	andeq	r2, r6, lr, lsl #28
    39e4:	22ee0f00 	rsccs	r0, lr, #0, 30
    39e8:	5c050000 	stcpl	0, cr0, [r5], {-0}
    39ec:	06390301 	ldrteq	r0, [r9], -r1, lsl #6
    39f0:	5e0f0000 	cdppl	0, 0, cr0, cr15, cr0, {0}
    39f4:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    39f8:	1d0c015f 	stfnes	f0, [ip, #-380]	; 0xfffffe84
    39fc:	16000000 	strne	r0, [r0], -r0
    3a00:	0000298d 	andeq	r2, r0, sp, lsl #19
    3a04:	00930107 	addseq	r0, r3, r7, lsl #2
    3a08:	72050000 	andvc	r0, r5, #0
    3a0c:	070e0601 	streq	r0, [lr, -r1, lsl #12]
    3a10:	390b0000 	stmdbcc	fp, {}	; <UNPREDICTABLE>
    3a14:	00000026 	andeq	r0, r0, r6, lsr #32
    3a18:	001ca90b 	andseq	sl, ip, fp, lsl #18
    3a1c:	b50b0200 	strlt	r0, [fp, #-512]	; 0xfffffe00
    3a20:	0300001c 	movweq	r0, #28
    3a24:	0020910b 	eoreq	r9, r0, fp, lsl #2
    3a28:	750b0300 	strvc	r0, [fp, #-768]	; 0xfffffd00
    3a2c:	04000026 	streq	r0, [r0], #-38	; 0xffffffda
    3a30:	0021f80b 	eoreq	pc, r1, fp, lsl #16
    3a34:	d30b0400 	movwle	r0, #46080	; 0xb400
    3a38:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    3a3c:	0022c50b 	eoreq	ip, r2, fp, lsl #10
    3a40:	ff0b0500 			; <UNDEFINED> instruction: 0xff0b0500
    3a44:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    3a48:	0022290b 	eoreq	r2, r2, fp, lsl #18
    3a4c:	960b0500 	strls	r0, [fp], -r0, lsl #10
    3a50:	0500001d 	streq	r0, [r0, #-29]	; 0xffffffe3
    3a54:	001cdf0b 	andseq	sp, ip, fp, lsl #30
    3a58:	6e0b0600 	cfmadd32vs	mvax0, mvfx0, mvfx11, mvfx0
    3a5c:	06000024 	streq	r0, [r0], -r4, lsr #32
    3a60:	001ee90b 	andseq	lr, lr, fp, lsl #18
    3a64:	830b0600 	movwhi	r0, #46592	; 0xb600
    3a68:	06000027 	streq	r0, [r0], -r7, lsr #32
    3a6c:	002a1d0b 	eoreq	r1, sl, fp, lsl #26
    3a70:	a20b0600 	andge	r0, fp, #0, 12
    3a74:	06000024 	streq	r0, [r0], -r4, lsr #32
    3a78:	0025010b 	eoreq	r0, r5, fp, lsl #2
    3a7c:	eb0b0600 	bl	2c5284 <__bss_end+0x2bbb40>
    3a80:	0700001c 	smladeq	r0, ip, r0, r0
    3a84:	00261c0b 	eoreq	r1, r6, fp, lsl #24
    3a88:	810b0700 	tsthi	fp, r0, lsl #14
    3a8c:	07000026 	streq	r0, [r0, -r6, lsr #32]
    3a90:	002a670b 	eoreq	r6, sl, fp, lsl #14
    3a94:	bc0b0700 	stclt	7, cr0, [fp], {-0}
    3a98:	0700001e 	smladeq	r0, lr, r0, r0
    3a9c:	0026fc0b 	eoreq	pc, r6, fp, lsl #24
    3aa0:	4c0b0800 	stcmi	8, cr0, [fp], {-0}
    3aa4:	0800001c 	stmdaeq	r0, {r2, r3, r4}
    3aa8:	002a2b0b 	eoreq	r2, sl, fp, lsl #22
    3aac:	1d0b0800 	stcne	8, cr0, [fp, #-0]
    3ab0:	08000027 	stmdaeq	r0, {r0, r1, r2, r5}
    3ab4:	2db60f00 	ldccs	15, cr0, [r6]
    3ab8:	92050000 	andls	r0, r5, #0
    3abc:	06581f01 	ldrbeq	r1, [r8], -r1, lsl #30
    3ac0:	c50f0000 	strgt	r0, [pc, #-0]	; 3ac8 <shift+0x3ac8>
    3ac4:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    3ac8:	1d0c0195 	stfnes	f0, [ip, #-596]	; 0xfffffdac
    3acc:	0f000000 	svceq	0x00000000
    3ad0:	0000274f 	andeq	r2, r0, pc, asr #14
    3ad4:	0c019805 	stceq	8, cr9, [r1], {5}
    3ad8:	0000001d 	andeq	r0, r0, sp, lsl r0
    3adc:	00230c0f 	eoreq	r0, r3, pc, lsl #24
    3ae0:	019b0500 	orrseq	r0, fp, r0, lsl #10
    3ae4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3ae8:	27590f00 	ldrbcs	r0, [r9, -r0, lsl #30]
    3aec:	9e050000 	cdpls	0, 0, cr0, cr5, cr0, {0}
    3af0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3af4:	4f0f0000 	svcmi	0x000f0000
    3af8:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    3afc:	1d0c01a1 	stfnes	f0, [ip, #-644]	; 0xfffffd7c
    3b00:	0f000000 	svceq	0x00000000
    3b04:	000027a3 	andeq	r2, r0, r3, lsr #15
    3b08:	0c01a405 	cfstrseq	mvf10, [r1], {5}
    3b0c:	0000001d 	andeq	r0, r0, sp, lsl r0
    3b10:	00265f0f 	eoreq	r5, r6, pc, lsl #30
    3b14:	01a70500 			; <UNDEFINED> instruction: 0x01a70500
    3b18:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3b1c:	266a0f00 	strbtcs	r0, [sl], -r0, lsl #30
    3b20:	aa050000 	bge	143b28 <__bss_end+0x13a3e4>
    3b24:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3b28:	630f0000 	movwvs	r0, #61440	; 0xf000
    3b2c:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    3b30:	1d0c01ad 	stfnes	f0, [ip, #-692]	; 0xfffffd4c
    3b34:	0f000000 	svceq	0x00000000
    3b38:	00002441 	andeq	r2, r0, r1, asr #8
    3b3c:	0c01b005 	stceq	0, cr11, [r1], {5}
    3b40:	0000001d 	andeq	r0, r0, sp, lsl r0
    3b44:	002df80f 	eoreq	pc, sp, pc, lsl #16
    3b48:	01b30500 			; <UNDEFINED> instruction: 0x01b30500
    3b4c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3b50:	276d0f00 	strbcs	r0, [sp, -r0, lsl #30]!
    3b54:	b6050000 	strlt	r0, [r5], -r0
    3b58:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3b5c:	d50f0000 	strle	r0, [pc, #-0]	; 3b64 <shift+0x3b64>
    3b60:	0500002e 	streq	r0, [r0, #-46]	; 0xffffffd2
    3b64:	1d0c01b9 	stfnes	f0, [ip, #-740]	; 0xfffffd1c
    3b68:	0f000000 	svceq	0x00000000
    3b6c:	00002d83 	andeq	r2, r0, r3, lsl #27
    3b70:	0c01bc05 	stceq	12, cr11, [r1], {5}
    3b74:	0000001d 	andeq	r0, r0, sp, lsl r0
    3b78:	002da80f 	eoreq	sl, sp, pc, lsl #16
    3b7c:	01c00500 	biceq	r0, r0, r0, lsl #10
    3b80:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3b84:	2ec80f00 	cdpcs	15, 12, cr0, cr8, cr0, {0}
    3b88:	c3050000 	movwgt	r0, #20480	; 0x5000
    3b8c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3b90:	060f0000 	streq	r0, [pc], -r0
    3b94:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    3b98:	1d0c01c6 	stfnes	f0, [ip, #-792]	; 0xfffffce8
    3b9c:	0f000000 	svceq	0x00000000
    3ba0:	00001bdd 	ldrdeq	r1, [r0], -sp
    3ba4:	0c01c905 			; <UNDEFINED> instruction: 0x0c01c905
    3ba8:	0000001d 	andeq	r0, r0, sp, lsl r0
    3bac:	0020b10f 	eoreq	fp, r0, pc, lsl #2
    3bb0:	01cc0500 	biceq	r0, ip, r0, lsl #10
    3bb4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3bb8:	1de10f00 	stclne	15, cr0, [r1]
    3bbc:	cf050000 	svcgt	0x00050000
    3bc0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3bc4:	ad0f0000 	stcge	0, cr0, [pc, #-0]	; 3bcc <shift+0x3bcc>
    3bc8:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    3bcc:	1d0c01d2 	stfnes	f0, [ip, #-840]	; 0xfffffcb8
    3bd0:	0f000000 	svceq	0x00000000
    3bd4:	00002334 	andeq	r2, r0, r4, lsr r3
    3bd8:	0c01d505 	cfstr32eq	mvfx13, [r1], {5}
    3bdc:	0000001d 	andeq	r0, r0, sp, lsl r0
    3be0:	0025cc0f 	eoreq	ip, r5, pc, lsl #24
    3be4:	01d80500 	bicseq	r0, r8, r0, lsl #10
    3be8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3bec:	2bb30f00 	blcs	fecc77f4 <__bss_end+0xfecbe0b0>
    3bf0:	df050000 	svcle	0x00050000
    3bf4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3bf8:	670f0000 	strvs	r0, [pc, -r0]
    3bfc:	0500002e 	streq	r0, [r0, #-46]	; 0xffffffd2
    3c00:	1d0c01e2 	stfnes	f0, [ip, #-904]	; 0xfffffc78
    3c04:	0f000000 	svceq	0x00000000
    3c08:	00002e77 	andeq	r2, r0, r7, ror lr
    3c0c:	0c01e505 	cfstr32eq	mvfx14, [r1], {5}
    3c10:	0000001d 	andeq	r0, r0, sp, lsl r0
    3c14:	001f000f 	andseq	r0, pc, pc
    3c18:	01e80500 	mvneq	r0, r0, lsl #10
    3c1c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3c20:	2bfa0f00 	blcs	ffe87828 <__bss_end+0xffe7e0e4>
    3c24:	eb050000 	bl	143c2c <__bss_end+0x13a4e8>
    3c28:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3c2c:	e40f0000 	str	r0, [pc], #-0	; 3c34 <shift+0x3c34>
    3c30:	05000026 	streq	r0, [r0, #-38]	; 0xffffffda
    3c34:	1d0c01ee 	stfnes	f0, [ip, #-952]	; 0xfffffc48
    3c38:	0f000000 	svceq	0x00000000
    3c3c:	0000212a 	andeq	r2, r0, sl, lsr #2
    3c40:	0c01f205 	sfmeq	f7, 1, [r1], {5}
    3c44:	0000001d 	andeq	r0, r0, sp, lsl r0
    3c48:	00299f0f 	eoreq	r9, r9, pc, lsl #30
    3c4c:	01fa0500 	mvnseq	r0, r0, lsl #10
    3c50:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3c54:	1fe30f00 	svcne	0x00e30f00
    3c58:	fd050000 	stc2	0, cr0, [r5, #-0]
    3c5c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3c60:	1d0c0000 	stcne	0, cr0, [ip, #-0]
    3c64:	c6000000 	strgt	r0, [r0], -r0
    3c68:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
    3c6c:	22140f00 	andscs	r0, r4, #0, 30
    3c70:	eb050000 	bl	143c78 <__bss_end+0x13a534>
    3c74:	08bb0c03 	ldmeq	fp!, {r0, r1, sl, fp}
    3c78:	be0c0000 	cdplt	0, 0, cr0, cr12, cr0, {0}
    3c7c:	e3000005 	movw	r0, #5
    3c80:	15000008 	strne	r0, [r0, #-8]
    3c84:	00000024 	andeq	r0, r0, r4, lsr #32
    3c88:	e30f000d 	movw	r0, #61453	; 0xf00d
    3c8c:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    3c90:	d3140574 	tstle	r4, #116, 10	; 0x1d000000
    3c94:	16000008 	strne	r0, [r0], -r8
    3c98:	000022f7 	strdeq	r2, [r0], -r7
    3c9c:	00930107 	addseq	r0, r3, r7, lsl #2
    3ca0:	7b050000 	blvc	143ca8 <__bss_end+0x13a564>
    3ca4:	092e0605 	stmdbeq	lr!, {r0, r2, r9, sl}
    3ca8:	730b0000 	movwvc	r0, #45056	; 0xb000
    3cac:	00000020 	andeq	r0, r0, r0, lsr #32
    3cb0:	00252c0b 	eoreq	r2, r5, fp, lsl #24
    3cb4:	820b0100 	andhi	r0, fp, #0, 2
    3cb8:	0200001c 	andeq	r0, r0, #28
    3cbc:	002e290b 	eoreq	r2, lr, fp, lsl #18
    3cc0:	6f0b0300 	svcvs	0x000b0300
    3cc4:	04000028 	streq	r0, [r0], #-40	; 0xffffffd8
    3cc8:	0028620b 	eoreq	r6, r8, fp, lsl #4
    3ccc:	750b0500 	strvc	r0, [fp, #-1280]	; 0xfffffb00
    3cd0:	0600001d 			; <UNDEFINED> instruction: 0x0600001d
    3cd4:	2e190f00 	cdpcs	15, 1, cr0, cr9, cr0, {0}
    3cd8:	88050000 	stmdahi	r5, {}	; <UNPREDICTABLE>
    3cdc:	08f01505 	ldmeq	r0!, {r0, r2, r8, sl, ip}^
    3ce0:	f50f0000 			; <UNDEFINED> instruction: 0xf50f0000
    3ce4:	0500002c 	streq	r0, [r0, #-44]	; 0xffffffd4
    3ce8:	24110789 	ldrcs	r0, [r1], #-1929	; 0xfffff877
    3cec:	0f000000 	svceq	0x00000000
    3cf0:	000027d0 	ldrdeq	r2, [r0], -r0
    3cf4:	0c079e05 	stceq	14, cr9, [r7], {5}
    3cf8:	0000001d 	andeq	r0, r0, sp, lsl r0
    3cfc:	002ba204 	eoreq	sl, fp, r4, lsl #4
    3d00:	167b0600 	ldrbtne	r0, [fp], -r0, lsl #12
    3d04:	00000093 	muleq	r0, r3, r0
    3d08:	0009550e 	andeq	r5, r9, lr, lsl #10
    3d0c:	05020300 	streq	r0, [r2, #-768]	; 0xfffffd00
    3d10:	00000e4a 	andeq	r0, r0, sl, asr #28
    3d14:	cc070803 	stcgt	8, cr0, [r7], {3}
    3d18:	0300001f 	movweq	r0, #31
    3d1c:	1e210404 	cdpne	4, 2, cr0, cr1, cr4, {0}
    3d20:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    3d24:	001e1903 	andseq	r1, lr, r3, lsl #18
    3d28:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    3d2c:	0000277c 	andeq	r2, r0, ip, ror r7
    3d30:	b7031003 	strlt	r1, [r3, -r3]
    3d34:	0c000028 	stceq	0, cr0, [r0], {40}	; 0x28
    3d38:	00000961 	andeq	r0, r0, r1, ror #18
    3d3c:	000009a0 	andeq	r0, r0, r0, lsr #19
    3d40:	00002415 	andeq	r2, r0, r5, lsl r4
    3d44:	0e00ff00 	cdpeq	15, 0, cr15, cr0, cr0, {0}
    3d48:	00000990 	muleq	r0, r0, r9
    3d4c:	00268e0f 	eoreq	r8, r6, pc, lsl #28
    3d50:	01fc0600 	mvnseq	r0, r0, lsl #12
    3d54:	0009a016 	andeq	sl, r9, r6, lsl r0
    3d58:	1dd00f00 	ldclne	15, cr0, [r0]
    3d5c:	02060000 	andeq	r0, r6, #0
    3d60:	09a01602 	stmibeq	r0!, {r1, r9, sl, ip}
    3d64:	c5040000 	strgt	r0, [r4, #-0]
    3d68:	0700002b 	streq	r0, [r0, -fp, lsr #32]
    3d6c:	05d1102a 	ldrbeq	r1, [r1, #42]	; 0x2a
    3d70:	bf0c0000 	svclt	0x000c0000
    3d74:	d6000009 	strle	r0, [r0], -r9
    3d78:	0d000009 	stceq	0, cr0, [r0, #-36]	; 0xffffffdc
    3d7c:	037a0900 	cmneq	sl, #0, 18
    3d80:	2f070000 	svccs	0x00070000
    3d84:	0009cb11 	andeq	ip, r9, r1, lsl fp
    3d88:	023c0900 	eorseq	r0, ip, #0, 18
    3d8c:	30070000 	andcc	r0, r7, r0
    3d90:	0009cb11 	andeq	ip, r9, r1, lsl fp
    3d94:	09d61700 	ldmibeq	r6, {r8, r9, sl, ip}^
    3d98:	36080000 	strcc	r0, [r8], -r0
    3d9c:	03050a09 	movweq	r0, #23049	; 0x5a09
    3da0:	00009720 	andeq	r9, r0, r0, lsr #14
    3da4:	0009e217 	andeq	lr, r9, r7, lsl r2
    3da8:	09370800 	ldmdbeq	r7!, {fp}
    3dac:	2003050a 	andcs	r0, r3, sl, lsl #10
    3db0:	00000097 	muleq	r0, r7, r0

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x3774d0>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb95d8>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb95f8>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9610>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_ZN13COLED_Display10Put_StringEttPKc+0x34>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7a150>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39634>
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
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x377578>
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
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf795d4>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c51ec>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7a1d4>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe396b8>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <shift+0x16c>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb96cc>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__udivsi3+0x54>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7a20c>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe396f0>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeb9700>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x377688>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c5278>
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
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c528c>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x3776bc>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf796cc>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 1e8:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 1ec:	0b0b0024 	bleq	2c0284 <__bss_end+0x2b6b40>
 1f0:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 1f4:	16050000 	strne	r0, [r5], -r0
 1f8:	3a0e0300 	bcc	380e00 <__bss_end+0x3776bc>
 1fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 200:	0013490b 	andseq	r4, r3, fp, lsl #18
 204:	00350600 	eorseq	r0, r5, r0, lsl #12
 208:	00001349 	andeq	r1, r0, r9, asr #6
 20c:	03011307 	movweq	r1, #4871	; 0x1307
 210:	3a0b0b0e 	bcc	2c2e50 <__bss_end+0x2b970c>
 214:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 218:	0013010b 	andseq	r0, r3, fp, lsl #2
 21c:	000d0800 	andeq	r0, sp, r0, lsl #16
 220:	0b3a0803 	bleq	e82234 <__bss_end+0xe78af0>
 224:	0b390b3b 	bleq	e42f18 <__bss_end+0xe397d4>
 228:	0b381349 	bleq	e04f54 <__bss_end+0xdfb810>
 22c:	04090000 	streq	r0, [r9], #-0
 230:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 234:	0b0b3e19 	bleq	2cfaa0 <__bss_end+0x2c635c>
 238:	3a13490b 	bcc	4d266c <__bss_end+0x4c8f28>
 23c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 240:	0013010b 	andseq	r0, r3, fp, lsl #2
 244:	00280a00 	eoreq	r0, r8, r0, lsl #20
 248:	0b1c0e03 	bleq	703a5c <__bss_end+0x6fa318>
 24c:	340b0000 	strcc	r0, [fp], #-0
 250:	3a0e0300 	bcc	380e58 <__bss_end+0x377714>
 254:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 258:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 25c:	00180219 	andseq	r0, r8, r9, lsl r2
 260:	00020c00 	andeq	r0, r2, r0, lsl #24
 264:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 268:	020d0000 	andeq	r0, sp, #0
 26c:	0b0e0301 	bleq	380e78 <__bss_end+0x377734>
 270:	3b0b3a0b 	blcc	2ceaa4 <__bss_end+0x2c5360>
 274:	010b390b 	tsteq	fp, fp, lsl #18
 278:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 27c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 280:	0b3b0b3a 	bleq	ec2f70 <__bss_end+0xeb982c>
 284:	13490b39 	movtne	r0, #39737	; 0x9b39
 288:	00000b38 	andeq	r0, r0, r8, lsr fp
 28c:	3f012e0f 	svccc	0x00012e0f
 290:	3a0e0319 	bcc	380efc <__bss_end+0x3777b8>
 294:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 298:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 29c:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 2a0:	10000013 	andne	r0, r0, r3, lsl r0
 2a4:	13490005 	movtne	r0, #36869	; 0x9005
 2a8:	00001934 	andeq	r1, r0, r4, lsr r9
 2ac:	49000511 	stmdbmi	r0, {r0, r4, r8, sl}
 2b0:	12000013 	andne	r0, r0, #19
 2b4:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 2b8:	0b3b0b3a 	bleq	ec2fa8 <__bss_end+0xeb9864>
 2bc:	13490b39 	movtne	r0, #39737	; 0x9b39
 2c0:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 2c4:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 2c8:	03193f01 	tsteq	r9, #1, 30
 2cc:	3b0b3a0e 	blcc	2ceb0c <__bss_end+0x2c53c8>
 2d0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2d4:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 2d8:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 2dc:	00130113 	andseq	r0, r3, r3, lsl r1
 2e0:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 2e4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2e8:	0b3b0b3a 	bleq	ec2fd8 <__bss_end+0xeb9894>
 2ec:	0e6e0b39 	vmoveq.8	d14[5], r0
 2f0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 2f4:	13011364 	movwne	r1, #4964	; 0x1364
 2f8:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 2fc:	03193f01 	tsteq	r9, #1, 30
 300:	3b0b3a0e 	blcc	2ceb40 <__bss_end+0x2c53fc>
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
 338:	0b3b0b3a 	bleq	ec3028 <__bss_end+0xeb98e4>
 33c:	13490b39 	movtne	r0, #39737	; 0x9b39
 340:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 344:	281b0000 	ldmdacs	fp, {}	; <UNPREDICTABLE>
 348:	1c080300 	stcne	3, cr0, [r8], {-0}
 34c:	1c00000b 	stcne	0, cr0, [r0], {11}
 350:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 354:	0b3a0e03 	bleq	e83b68 <__bss_end+0xe7a424>
 358:	0b390b3b 	bleq	e4304c <__bss_end+0xe39908>
 35c:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 360:	13011364 	movwne	r1, #4964	; 0x1364
 364:	2e1d0000 	cdpcs	0, 1, cr0, cr13, cr0, {0}
 368:	03193f01 	tsteq	r9, #1, 30
 36c:	3b0b3a0e 	blcc	2cebac <__bss_end+0x2c5468>
 370:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 374:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 378:	01136419 	tsteq	r3, r9, lsl r4
 37c:	1e000013 	mcrne	0, 0, r0, cr0, cr3, {0}
 380:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 384:	0b3b0b3a 	bleq	ec3074 <__bss_end+0xeb9930>
 388:	13490b39 	movtne	r0, #39737	; 0x9b39
 38c:	0b320b38 	bleq	c83074 <__bss_end+0xc79930>
 390:	151f0000 	ldrne	r0, [pc, #-0]	; 398 <shift+0x398>
 394:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
 398:	00130113 	andseq	r0, r3, r3, lsl r1
 39c:	001f2000 	andseq	r2, pc, r0
 3a0:	1349131d 	movtne	r1, #37661	; 0x931d
 3a4:	10210000 	eorne	r0, r1, r0
 3a8:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 3ac:	22000013 	andcs	r0, r0, #19
 3b0:	0b0b000f 	bleq	2c03f4 <__bss_end+0x2b6cb0>
 3b4:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
 3b8:	03193f01 	tsteq	r9, #1, 30
 3bc:	3b0b3a0e 	blcc	2cebfc <__bss_end+0x2c54b8>
 3c0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 3c4:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 3c8:	00136419 	andseq	r6, r3, r9, lsl r4
 3cc:	01392400 	teqeq	r9, r0, lsl #8
 3d0:	0b3a0803 	bleq	e823e4 <__bss_end+0xe78ca0>
 3d4:	0b390b3b 	bleq	e430c8 <__bss_end+0xe39984>
 3d8:	00001301 	andeq	r1, r0, r1, lsl #6
 3dc:	03003425 	movweq	r3, #1061	; 0x425
 3e0:	3b0b3a0e 	blcc	2cec20 <__bss_end+0x2c54dc>
 3e4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 3e8:	1c193c13 	ldcne	12, cr3, [r9], {19}
 3ec:	00196c06 	andseq	r6, r9, r6, lsl #24
 3f0:	00342600 	eorseq	r2, r4, r0, lsl #12
 3f4:	0b3a0e03 	bleq	e83c08 <__bss_end+0xe7a4c4>
 3f8:	0b390b3b 	bleq	e430ec <__bss_end+0xe399a8>
 3fc:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 400:	196c0b1c 	stmdbne	ip!, {r2, r3, r4, r8, r9, fp}^
 404:	34270000 	strtcc	r0, [r7], #-0
 408:	00134700 	andseq	r4, r3, r0, lsl #14
 40c:	00342800 	eorseq	r2, r4, r0, lsl #16
 410:	0b3a0e03 	bleq	e83c24 <__bss_end+0xe7a4e0>
 414:	0b390b3b 	bleq	e43108 <__bss_end+0xe399c4>
 418:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 41c:	00001802 	andeq	r1, r0, r2, lsl #16
 420:	3f012e29 	svccc	0x00012e29
 424:	3a0e0319 	bcc	381090 <__bss_end+0x37794c>
 428:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 42c:	1113490b 	tstne	r3, fp, lsl #18
 430:	40061201 	andmi	r1, r6, r1, lsl #4
 434:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 438:	00001301 	andeq	r1, r0, r1, lsl #6
 43c:	0300052a 	movweq	r0, #1322	; 0x52a
 440:	3b0b3a0e 	blcc	2cec80 <__bss_end+0x2c553c>
 444:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 448:	00180213 	andseq	r0, r8, r3, lsl r2
 44c:	00342b00 	eorseq	r2, r4, r0, lsl #22
 450:	0b3a0e03 	bleq	e83c64 <__bss_end+0xe7a520>
 454:	0b390b3b 	bleq	e43148 <__bss_end+0xe39a04>
 458:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 45c:	342c0000 	strtcc	r0, [ip], #-0
 460:	3a080300 	bcc	201068 <__bss_end+0x1f7924>
 464:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 468:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 46c:	2d000018 	stccs	0, cr0, [r0, #-96]	; 0xffffffa0
 470:	0111010b 	tsteq	r1, fp, lsl #2
 474:	00000612 	andeq	r0, r0, r2, lsl r6
 478:	01110100 	tsteq	r1, r0, lsl #2
 47c:	0b130e25 	bleq	4c3d18 <__bss_end+0x4ba5d4>
 480:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 484:	06120111 			; <UNDEFINED> instruction: 0x06120111
 488:	00001710 	andeq	r1, r0, r0, lsl r7
 48c:	0b002402 	bleq	949c <_ZL10Indefinite>
 490:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 494:	0300000e 	movweq	r0, #14
 498:	13490026 	movtne	r0, #36902	; 0x9026
 49c:	24040000 	strcs	r0, [r4], #-0
 4a0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 4a4:	0008030b 	andeq	r0, r8, fp, lsl #6
 4a8:	00160500 	andseq	r0, r6, r0, lsl #10
 4ac:	0b3a0e03 	bleq	e83cc0 <__bss_end+0xe7a57c>
 4b0:	0b390b3b 	bleq	e431a4 <__bss_end+0xe39a60>
 4b4:	00001349 	andeq	r1, r0, r9, asr #6
 4b8:	03011306 	movweq	r1, #4870	; 0x1306
 4bc:	3a0b0b0e 	bcc	2c30fc <__bss_end+0x2b99b8>
 4c0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4c4:	0013010b 	andseq	r0, r3, fp, lsl #2
 4c8:	000d0700 	andeq	r0, sp, r0, lsl #14
 4cc:	0b3a0803 	bleq	e824e0 <__bss_end+0xe78d9c>
 4d0:	0b390b3b 	bleq	e431c4 <__bss_end+0xe39a80>
 4d4:	0b381349 	bleq	e05200 <__bss_end+0xdfbabc>
 4d8:	04080000 	streq	r0, [r8], #-0
 4dc:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 4e0:	0b0b3e19 	bleq	2cfd4c <__bss_end+0x2c6608>
 4e4:	3a13490b 	bcc	4d2918 <__bss_end+0x4c91d4>
 4e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4ec:	0013010b 	andseq	r0, r3, fp, lsl #2
 4f0:	00280900 	eoreq	r0, r8, r0, lsl #18
 4f4:	0b1c0803 	bleq	702508 <__bss_end+0x6f8dc4>
 4f8:	280a0000 	stmdacs	sl, {}	; <UNPREDICTABLE>
 4fc:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 500:	0b00000b 	bleq	534 <shift+0x534>
 504:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 508:	0b3b0b3a 	bleq	ec31f8 <__bss_end+0xeb9ab4>
 50c:	13490b39 	movtne	r0, #39737	; 0x9b39
 510:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 514:	020c0000 	andeq	r0, ip, #0
 518:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 51c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 520:	0e030102 	adfeqs	f0, f3, f2
 524:	0b3a0b0b 	bleq	e83158 <__bss_end+0xe79a14>
 528:	0b390b3b 	bleq	e4321c <__bss_end+0xe39ad8>
 52c:	00001301 	andeq	r1, r0, r1, lsl #6
 530:	03000d0e 	movweq	r0, #3342	; 0xd0e
 534:	3b0b3a0e 	blcc	2ced74 <__bss_end+0x2c5630>
 538:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 53c:	000b3813 	andeq	r3, fp, r3, lsl r8
 540:	012e0f00 			; <UNDEFINED> instruction: 0x012e0f00
 544:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 548:	0b3b0b3a 	bleq	ec3238 <__bss_end+0xeb9af4>
 54c:	0e6e0b39 	vmoveq.8	d14[5], r0
 550:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 554:	00001364 	andeq	r1, r0, r4, ror #6
 558:	49000510 	stmdbmi	r0, {r4, r8, sl}
 55c:	00193413 	andseq	r3, r9, r3, lsl r4
 560:	00051100 	andeq	r1, r5, r0, lsl #2
 564:	00001349 	andeq	r1, r0, r9, asr #6
 568:	03000d12 	movweq	r0, #3346	; 0xd12
 56c:	3b0b3a0e 	blcc	2cedac <__bss_end+0x2c5668>
 570:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 574:	3c193f13 	ldccc	15, cr3, [r9], {19}
 578:	13000019 	movwne	r0, #25
 57c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 580:	0b3a0e03 	bleq	e83d94 <__bss_end+0xe7a650>
 584:	0b390b3b 	bleq	e43278 <__bss_end+0xe39b34>
 588:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 58c:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 590:	13011364 	movwne	r1, #4964	; 0x1364
 594:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 598:	03193f01 	tsteq	r9, #1, 30
 59c:	3b0b3a0e 	blcc	2ceddc <__bss_end+0x2c5698>
 5a0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 5a4:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 5a8:	01136419 	tsteq	r3, r9, lsl r4
 5ac:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 5b0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 5b4:	0b3a0e03 	bleq	e83dc8 <__bss_end+0xe7a684>
 5b8:	0b390b3b 	bleq	e432ac <__bss_end+0xe39b68>
 5bc:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 5c0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 5c4:	00001364 	andeq	r1, r0, r4, ror #6
 5c8:	49010116 	stmdbmi	r1, {r1, r2, r4, r8}
 5cc:	00130113 	andseq	r0, r3, r3, lsl r1
 5d0:	00211700 	eoreq	r1, r1, r0, lsl #14
 5d4:	0b2f1349 	bleq	bc5300 <__bss_end+0xbbbbbc>
 5d8:	0f180000 	svceq	0x00180000
 5dc:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 5e0:	19000013 	stmdbne	r0, {r0, r1, r4}
 5e4:	00000021 	andeq	r0, r0, r1, lsr #32
 5e8:	0300341a 	movweq	r3, #1050	; 0x41a
 5ec:	3b0b3a0e 	blcc	2cee2c <__bss_end+0x2c56e8>
 5f0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 5f4:	3c193f13 	ldccc	15, cr3, [r9], {19}
 5f8:	1b000019 	blne	664 <shift+0x664>
 5fc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 600:	0b3a0e03 	bleq	e83e14 <__bss_end+0xe7a6d0>
 604:	0b390b3b 	bleq	e432f8 <__bss_end+0xe39bb4>
 608:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 60c:	13011364 	movwne	r1, #4964	; 0x1364
 610:	2e1c0000 	cdpcs	0, 1, cr0, cr12, cr0, {0}
 614:	03193f01 	tsteq	r9, #1, 30
 618:	3b0b3a0e 	blcc	2cee58 <__bss_end+0x2c5714>
 61c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 620:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 624:	01136419 	tsteq	r3, r9, lsl r4
 628:	1d000013 	stcne	0, cr0, [r0, #-76]	; 0xffffffb4
 62c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 630:	0b3b0b3a 	bleq	ec3320 <__bss_end+0xeb9bdc>
 634:	13490b39 	movtne	r0, #39737	; 0x9b39
 638:	0b320b38 	bleq	c83320 <__bss_end+0xc79bdc>
 63c:	151e0000 	ldrne	r0, [lr, #-0]
 640:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
 644:	00130113 	andseq	r0, r3, r3, lsl r1
 648:	001f1f00 	andseq	r1, pc, r0, lsl #30
 64c:	1349131d 	movtne	r1, #37661	; 0x931d
 650:	10200000 	eorne	r0, r0, r0
 654:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 658:	21000013 	tstcs	r0, r3, lsl r0
 65c:	0b0b000f 	bleq	2c06a0 <__bss_end+0x2b6f5c>
 660:	34220000 	strtcc	r0, [r2], #-0
 664:	3a0e0300 	bcc	38126c <__bss_end+0x377b28>
 668:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 66c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 670:	23000018 	movwcs	r0, #24
 674:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 678:	0b3a0e03 	bleq	e83e8c <__bss_end+0xe7a748>
 67c:	0b390b3b 	bleq	e43370 <__bss_end+0xe39c2c>
 680:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 684:	06120111 			; <UNDEFINED> instruction: 0x06120111
 688:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 68c:	00130119 	andseq	r0, r3, r9, lsl r1
 690:	00052400 	andeq	r2, r5, r0, lsl #8
 694:	0b3a0e03 	bleq	e83ea8 <__bss_end+0xe7a764>
 698:	0b390b3b 	bleq	e4338c <__bss_end+0xe39c48>
 69c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 6a0:	2e250000 	cdpcs	0, 2, cr0, cr5, cr0, {0}
 6a4:	03193f01 	tsteq	r9, #1, 30
 6a8:	3b0b3a0e 	blcc	2ceee8 <__bss_end+0x2c57a4>
 6ac:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6b0:	1113490e 	tstne	r3, lr, lsl #18
 6b4:	40061201 	andmi	r1, r6, r1, lsl #4
 6b8:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6bc:	00001301 	andeq	r1, r0, r1, lsl #6
 6c0:	03003426 	movweq	r3, #1062	; 0x426
 6c4:	3b0b3a08 	blcc	2ceeec <__bss_end+0x2c57a8>
 6c8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 6cc:	00180213 	andseq	r0, r8, r3, lsl r2
 6d0:	012e2700 			; <UNDEFINED> instruction: 0x012e2700
 6d4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 6d8:	0b3b0b3a 	bleq	ec33c8 <__bss_end+0xeb9c84>
 6dc:	0e6e0b39 	vmoveq.8	d14[5], r0
 6e0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 6e4:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 6e8:	00130119 	andseq	r0, r3, r9, lsl r1
 6ec:	002e2800 	eoreq	r2, lr, r0, lsl #16
 6f0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 6f4:	0b3b0b3a 	bleq	ec33e4 <__bss_end+0xeb9ca0>
 6f8:	0e6e0b39 	vmoveq.8	d14[5], r0
 6fc:	06120111 			; <UNDEFINED> instruction: 0x06120111
 700:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 704:	29000019 	stmdbcs	r0, {r0, r3, r4}
 708:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 70c:	0b3a0e03 	bleq	e83f20 <__bss_end+0xe7a7dc>
 710:	0b390b3b 	bleq	e43404 <__bss_end+0xe39cc0>
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
 740:	3a0e0300 	bcc	381348 <__bss_end+0x377c04>
 744:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 748:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 74c:	000a1c19 	andeq	r1, sl, r9, lsl ip
 750:	003a0400 	eorseq	r0, sl, r0, lsl #8
 754:	0b3b0b3a 	bleq	ec3444 <__bss_end+0xeb9d00>
 758:	13180b39 	tstne	r8, #58368	; 0xe400
 75c:	01050000 	mrseq	r0, (UNDEF: 5)
 760:	01134901 	tsteq	r3, r1, lsl #18
 764:	06000013 			; <UNDEFINED> instruction: 0x06000013
 768:	13490021 	movtne	r0, #36897	; 0x9021
 76c:	00000b2f 	andeq	r0, r0, pc, lsr #22
 770:	49002607 	stmdbmi	r0, {r0, r1, r2, r9, sl, sp}
 774:	08000013 	stmdaeq	r0, {r0, r1, r4}
 778:	0b0b0024 	bleq	2c0810 <__bss_end+0x2b70cc>
 77c:	0e030b3e 	vmoveq.16	d3[0], r0
 780:	34090000 	strcc	r0, [r9], #-0
 784:	00134700 	andseq	r4, r3, r0, lsl #14
 788:	012e0a00 			; <UNDEFINED> instruction: 0x012e0a00
 78c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 790:	0b3b0b3a 	bleq	ec3480 <__bss_end+0xeb9d3c>
 794:	0e6e0b39 	vmoveq.8	d14[5], r0
 798:	06120111 			; <UNDEFINED> instruction: 0x06120111
 79c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 7a0:	00130119 	andseq	r0, r3, r9, lsl r1
 7a4:	00050b00 	andeq	r0, r5, r0, lsl #22
 7a8:	0b3a0803 	bleq	e827bc <__bss_end+0xe79078>
 7ac:	0b390b3b 	bleq	e434a0 <__bss_end+0xe39d5c>
 7b0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 7b4:	340c0000 	strcc	r0, [ip], #-0
 7b8:	3a0e0300 	bcc	3813c0 <__bss_end+0x377c7c>
 7bc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7c0:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 7c4:	0d000018 	stceq	0, cr0, [r0, #-96]	; 0xffffffa0
 7c8:	0111010b 	tsteq	r1, fp, lsl #2
 7cc:	00000612 	andeq	r0, r0, r2, lsl r6
 7d0:	0300340e 	movweq	r3, #1038	; 0x40e
 7d4:	3b0b3a08 	blcc	2ceffc <__bss_end+0x2c58b8>
 7d8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 7dc:	00180213 	andseq	r0, r8, r3, lsl r2
 7e0:	000f0f00 	andeq	r0, pc, r0, lsl #30
 7e4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 7e8:	26100000 	ldrcs	r0, [r0], -r0
 7ec:	11000000 	mrsne	r0, (UNDEF: 0)
 7f0:	0b0b000f 	bleq	2c0834 <__bss_end+0x2b70f0>
 7f4:	24120000 	ldrcs	r0, [r2], #-0
 7f8:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 7fc:	0008030b 	andeq	r0, r8, fp, lsl #6
 800:	00051300 	andeq	r1, r5, r0, lsl #6
 804:	0b3a0e03 	bleq	e84018 <__bss_end+0xe7a8d4>
 808:	0b390b3b 	bleq	e434fc <__bss_end+0xe39db8>
 80c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 810:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 814:	03193f01 	tsteq	r9, #1, 30
 818:	3b0b3a0e 	blcc	2cf058 <__bss_end+0x2c5914>
 81c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 820:	1113490e 	tstne	r3, lr, lsl #18
 824:	40061201 	andmi	r1, r6, r1, lsl #4
 828:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 82c:	00001301 	andeq	r1, r0, r1, lsl #6
 830:	3f012e15 	svccc	0x00012e15
 834:	3a0e0319 	bcc	3814a0 <__bss_end+0x377d5c>
 838:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 83c:	110e6e0b 	tstne	lr, fp, lsl #28
 840:	40061201 	andmi	r1, r6, r1, lsl #4
 844:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 848:	01000000 	mrseq	r0, (UNDEF: 0)
 84c:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 850:	0e030b13 	vmoveq.32	d3[0], r0
 854:	01110e1b 	tsteq	r1, fp, lsl lr
 858:	17100612 			; <UNDEFINED> instruction: 0x17100612
 85c:	24020000 	strcs	r0, [r2], #-0
 860:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 864:	000e030b 	andeq	r0, lr, fp, lsl #6
 868:	00260300 	eoreq	r0, r6, r0, lsl #6
 86c:	00001349 	andeq	r1, r0, r9, asr #6
 870:	0b002404 	bleq	9888 <__bss_end+0x144>
 874:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 878:	05000008 	streq	r0, [r0, #-8]
 87c:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 880:	0b3b0b3a 	bleq	ec3570 <__bss_end+0xeb9e2c>
 884:	13490b39 	movtne	r0, #39737	; 0x9b39
 888:	02060000 	andeq	r0, r6, #0
 88c:	0b0e0301 	bleq	381498 <__bss_end+0x377d54>
 890:	3b0b3a0b 	blcc	2cf0c4 <__bss_end+0x2c5980>
 894:	010b390b 	tsteq	fp, fp, lsl #18
 898:	07000013 	smladeq	r0, r3, r0, r0
 89c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 8a0:	0b3b0b3a 	bleq	ec3590 <__bss_end+0xeb9e4c>
 8a4:	13490b39 	movtne	r0, #39737	; 0x9b39
 8a8:	00000b38 	andeq	r0, r0, r8, lsr fp
 8ac:	3f012e08 	svccc	0x00012e08
 8b0:	3a0e0319 	bcc	38151c <__bss_end+0x377dd8>
 8b4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8b8:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 8bc:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 8c0:	01136419 	tsteq	r3, r9, lsl r4
 8c4:	09000013 	stmdbeq	r0, {r0, r1, r4}
 8c8:	13490005 	movtne	r0, #36869	; 0x9005
 8cc:	00001934 	andeq	r1, r0, r4, lsr r9
 8d0:	4900050a 	stmdbmi	r0, {r1, r3, r8, sl}
 8d4:	0b000013 	bleq	928 <shift+0x928>
 8d8:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 8dc:	0b3a0e03 	bleq	e840f0 <__bss_end+0xe7a9ac>
 8e0:	0b390b3b 	bleq	e435d4 <__bss_end+0xe39e90>
 8e4:	0b320e6e 	bleq	c842a4 <__bss_end+0xc7ab60>
 8e8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 8ec:	00001301 	andeq	r1, r0, r1, lsl #6
 8f0:	3f012e0c 	svccc	0x00012e0c
 8f4:	3a0e0319 	bcc	381560 <__bss_end+0x377e1c>
 8f8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8fc:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 900:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 904:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
 908:	0b0b000f 	bleq	2c094c <__bss_end+0x2b7208>
 90c:	00001349 	andeq	r1, r0, r9, asr #6
 910:	0b000f0e 	bleq	4550 <shift+0x4550>
 914:	0f00000b 	svceq	0x0000000b
 918:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 91c:	0b3a0b0b 	bleq	e83550 <__bss_end+0xe79e0c>
 920:	0b390b3b 	bleq	e43614 <__bss_end+0xe39ed0>
 924:	00001301 	andeq	r1, r0, r1, lsl #6
 928:	03000d10 	movweq	r0, #3344	; 0xd10
 92c:	3b0b3a08 	blcc	2cf154 <__bss_end+0x2c5a10>
 930:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 934:	000b3813 	andeq	r3, fp, r3, lsl r8
 938:	01041100 	mrseq	r1, (UNDEF: 20)
 93c:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 940:	0b0b0b3e 	bleq	2c3640 <__bss_end+0x2b9efc>
 944:	0b3a1349 	bleq	e85670 <__bss_end+0xe7bf2c>
 948:	0b390b3b 	bleq	e4363c <__bss_end+0xe39ef8>
 94c:	00001301 	andeq	r1, r0, r1, lsl #6
 950:	03002812 	movweq	r2, #2066	; 0x812
 954:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 958:	00341300 	eorseq	r1, r4, r0, lsl #6
 95c:	0b3a0e03 	bleq	e84170 <__bss_end+0xe7aa2c>
 960:	0b390b3b 	bleq	e43654 <__bss_end+0xe39f10>
 964:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 968:	00001802 	andeq	r1, r0, r2, lsl #16
 96c:	03000214 	movweq	r0, #532	; 0x214
 970:	00193c0e 	andseq	r3, r9, lr, lsl #24
 974:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
 978:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 97c:	0b3b0b3a 	bleq	ec366c <__bss_end+0xeb9f28>
 980:	0e6e0b39 	vmoveq.8	d14[5], r0
 984:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 988:	00001364 	andeq	r1, r0, r4, ror #6
 98c:	03000d16 	movweq	r0, #3350	; 0xd16
 990:	3b0b3a0e 	blcc	2cf1d0 <__bss_end+0x2c5a8c>
 994:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 998:	3c193f13 	ldccc	15, cr3, [r9], {19}
 99c:	17000019 	smladne	r0, r9, r0, r0
 9a0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 9a4:	0b3a0e03 	bleq	e841b8 <__bss_end+0xe7aa74>
 9a8:	0b390b3b 	bleq	e4369c <__bss_end+0xe39f58>
 9ac:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 9b0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 9b4:	00001364 	andeq	r1, r0, r4, ror #6
 9b8:	49010118 	stmdbmi	r1, {r3, r4, r8}
 9bc:	00130113 	andseq	r0, r3, r3, lsl r1
 9c0:	00211900 	eoreq	r1, r1, r0, lsl #18
 9c4:	0b2f1349 	bleq	bc56f0 <__bss_end+0xbbbfac>
 9c8:	211a0000 	tstcs	sl, r0
 9cc:	1b000000 	blne	9d4 <shift+0x9d4>
 9d0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 9d4:	0b3b0b3a 	bleq	ec36c4 <__bss_end+0xeb9f80>
 9d8:	13490b39 	movtne	r0, #39737	; 0x9b39
 9dc:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 9e0:	281c0000 	ldmdacs	ip, {}	; <UNPREDICTABLE>
 9e4:	1c080300 	stcne	3, cr0, [r8], {-0}
 9e8:	1d00000b 	stcne	0, cr0, [r0, #-44]	; 0xffffffd4
 9ec:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 9f0:	0b3a0e03 	bleq	e84204 <__bss_end+0xe7aac0>
 9f4:	0b390b3b 	bleq	e436e8 <__bss_end+0xe39fa4>
 9f8:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 9fc:	13011364 	movwne	r1, #4964	; 0x1364
 a00:	2e1e0000 	cdpcs	0, 1, cr0, cr14, cr0, {0}
 a04:	03193f01 	tsteq	r9, #1, 30
 a08:	3b0b3a0e 	blcc	2cf248 <__bss_end+0x2c5b04>
 a0c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 a10:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 a14:	01136419 	tsteq	r3, r9, lsl r4
 a18:	1f000013 	svcne	0x00000013
 a1c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 a20:	0b3b0b3a 	bleq	ec3710 <__bss_end+0xeb9fcc>
 a24:	13490b39 	movtne	r0, #39737	; 0x9b39
 a28:	0b320b38 	bleq	c83710 <__bss_end+0xc79fcc>
 a2c:	15200000 	strne	r0, [r0, #-0]!
 a30:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
 a34:	00130113 	andseq	r0, r3, r3, lsl r1
 a38:	001f2100 	andseq	r2, pc, r0, lsl #2
 a3c:	1349131d 	movtne	r1, #37661	; 0x931d
 a40:	10220000 	eorne	r0, r2, r0
 a44:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 a48:	23000013 	movwcs	r0, #19
 a4c:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
 a50:	0b3b0b3a 	bleq	ec3740 <__bss_end+0xeb9ffc>
 a54:	13010b39 	movwne	r0, #6969	; 0x1b39
 a58:	34240000 	strtcc	r0, [r4], #-0
 a5c:	3a0e0300 	bcc	381664 <__bss_end+0x377f20>
 a60:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 a64:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 a68:	6c061c19 	stcvs	12, cr1, [r6], {25}
 a6c:	25000019 	strcs	r0, [r0, #-25]	; 0xffffffe7
 a70:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 a74:	0b3b0b3a 	bleq	ec3764 <__bss_end+0xeba020>
 a78:	13490b39 	movtne	r0, #39737	; 0x9b39
 a7c:	0b1c193c 	bleq	706f74 <__bss_end+0x6fd830>
 a80:	0000196c 	andeq	r1, r0, ip, ror #18
 a84:	47003426 	strmi	r3, [r0, -r6, lsr #8]
 a88:	27000013 	smladcs	r0, r3, r0, r0
 a8c:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 a90:	0b3b0b3a 	bleq	ec3780 <__bss_end+0xeba03c>
 a94:	13010b39 	movwne	r0, #6969	; 0x1b39
 a98:	34280000 	strtcc	r0, [r8], #-0
 a9c:	3a0e0300 	bcc	3816a4 <__bss_end+0x377f60>
 aa0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 aa4:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 aa8:	00031c19 	andeq	r1, r3, r9, lsl ip
 aac:	00212900 	eoreq	r2, r1, r0, lsl #18
 ab0:	052f1349 	streq	r1, [pc, #-841]!	; 76f <shift+0x76f>
 ab4:	2e2a0000 	cdpcs	0, 2, cr0, cr10, cr0, {0}
 ab8:	3a134701 	bcc	4d26c4 <__bss_end+0x4c8f80>
 abc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 ac0:	1113640b 	tstne	r3, fp, lsl #8
 ac4:	40061201 	andmi	r1, r6, r1, lsl #4
 ac8:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 acc:	00001301 	andeq	r1, r0, r1, lsl #6
 ad0:	0300052b 	movweq	r0, #1323	; 0x52b
 ad4:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
 ad8:	00180219 	andseq	r0, r8, r9, lsl r2
 adc:	00052c00 	andeq	r2, r5, r0, lsl #24
 ae0:	0b3a0803 	bleq	e82af4 <__bss_end+0xe793b0>
 ae4:	0b390b3b 	bleq	e437d8 <__bss_end+0xe3a094>
 ae8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 aec:	342d0000 	strtcc	r0, [sp], #-0
 af0:	3a080300 	bcc	2016f8 <__bss_end+0x1f7fb4>
 af4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 af8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 afc:	2e000018 	mcrcs	0, 0, r0, cr0, cr8, {0}
 b00:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 b04:	0b3b0b3a 	bleq	ec37f4 <__bss_end+0xeba0b0>
 b08:	13490b39 	movtne	r0, #39737	; 0x9b39
 b0c:	00001802 	andeq	r1, r0, r2, lsl #16
 b10:	47012e2f 	strmi	r2, [r1, -pc, lsr #28]
 b14:	3b0b3a13 	blcc	2cf368 <__bss_end+0x2c5c24>
 b18:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 b1c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 b20:	97184006 	ldrls	r4, [r8, -r6]
 b24:	13011942 	movwne	r1, #6466	; 0x1942
 b28:	2e300000 	cdpcs	0, 3, cr0, cr0, cr0, {0}
 b2c:	3a134701 	bcc	4d2738 <__bss_end+0x4c8ff4>
 b30:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 b34:	2013640b 	andscs	r6, r3, fp, lsl #8
 b38:	0013010b 	andseq	r0, r3, fp, lsl #2
 b3c:	00053100 	andeq	r3, r5, r0, lsl #2
 b40:	13490e03 	movtne	r0, #40451	; 0x9e03
 b44:	00001934 	andeq	r1, r0, r4, lsr r9
 b48:	31012e32 	tstcc	r1, r2, lsr lr
 b4c:	640e6e13 	strvs	r6, [lr], #-3603	; 0xfffff1ed
 b50:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 b54:	96184006 	ldrls	r4, [r8], -r6
 b58:	13011942 	movwne	r1, #6466	; 0x1942
 b5c:	05330000 	ldreq	r0, [r3, #-0]!
 b60:	02133100 	andseq	r3, r3, #0, 2
 b64:	34000018 	strcc	r0, [r0], #-24	; 0xffffffe8
 b68:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 b6c:	0b3b0b3a 	bleq	ec385c <__bss_end+0xeba118>
 b70:	13490b39 	movtne	r0, #39737	; 0x9b39
 b74:	2e350000 	cdpcs	0, 3, cr0, cr5, cr0, {0}
 b78:	6e133101 	mufvss	f3, f3, f1
 b7c:	1113640e 	tstne	r3, lr, lsl #8
 b80:	40061201 	andmi	r1, r6, r1, lsl #4
 b84:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 b88:	01000000 	mrseq	r0, (UNDEF: 0)
 b8c:	06100011 			; <UNDEFINED> instruction: 0x06100011
 b90:	01120111 	tsteq	r2, r1, lsl r1
 b94:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 b98:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 b9c:	01000000 	mrseq	r0, (UNDEF: 0)
 ba0:	06100011 			; <UNDEFINED> instruction: 0x06100011
 ba4:	01120111 	tsteq	r2, r1, lsl r1
 ba8:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 bac:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 bb0:	01000000 	mrseq	r0, (UNDEF: 0)
 bb4:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 bb8:	0e030b13 	vmoveq.32	d3[0], r0
 bbc:	17100e1b 			; <UNDEFINED> instruction: 0x17100e1b
 bc0:	24020000 	strcs	r0, [r2], #-0
 bc4:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 bc8:	0008030b 	andeq	r0, r8, fp, lsl #6
 bcc:	00240300 	eoreq	r0, r4, r0, lsl #6
 bd0:	0b3e0b0b 	bleq	f83804 <__bss_end+0xf7a0c0>
 bd4:	00000e03 	andeq	r0, r0, r3, lsl #28
 bd8:	03001604 	movweq	r1, #1540	; 0x604
 bdc:	3b0b3a0e 	blcc	2cf41c <__bss_end+0x2c5cd8>
 be0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 be4:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 be8:	0b0b000f 	bleq	2c0c2c <__bss_end+0x2b74e8>
 bec:	00001349 	andeq	r1, r0, r9, asr #6
 bf0:	27011506 	strcs	r1, [r1, -r6, lsl #10]
 bf4:	01134919 	tsteq	r3, r9, lsl r9
 bf8:	07000013 	smladeq	r0, r3, r0, r0
 bfc:	13490005 	movtne	r0, #36869	; 0x9005
 c00:	26080000 	strcs	r0, [r8], -r0
 c04:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
 c08:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 c0c:	0b3b0b3a 	bleq	ec38fc <__bss_end+0xeba1b8>
 c10:	13490b39 	movtne	r0, #39737	; 0x9b39
 c14:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 c18:	040a0000 	streq	r0, [sl], #-0
 c1c:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 c20:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 c24:	3b0b3a13 	blcc	2cf478 <__bss_end+0x2c5d34>
 c28:	010b390b 	tsteq	fp, fp, lsl #18
 c2c:	0b000013 	bleq	c80 <shift+0xc80>
 c30:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 c34:	00000b1c 	andeq	r0, r0, ip, lsl fp
 c38:	4901010c 	stmdbmi	r1, {r2, r3, r8}
 c3c:	00130113 	andseq	r0, r3, r3, lsl r1
 c40:	00210d00 	eoreq	r0, r1, r0, lsl #26
 c44:	260e0000 	strcs	r0, [lr], -r0
 c48:	00134900 	andseq	r4, r3, r0, lsl #18
 c4c:	00340f00 	eorseq	r0, r4, r0, lsl #30
 c50:	0b3a0e03 	bleq	e84464 <__bss_end+0xe7ad20>
 c54:	0b39053b 	bleq	e42148 <__bss_end+0xe38a04>
 c58:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 c5c:	0000193c 	andeq	r1, r0, ip, lsr r9
 c60:	03001310 	movweq	r1, #784	; 0x310
 c64:	00193c0e 	andseq	r3, r9, lr, lsl #24
 c68:	00151100 	andseq	r1, r5, r0, lsl #2
 c6c:	00001927 	andeq	r1, r0, r7, lsr #18
 c70:	03001712 	movweq	r1, #1810	; 0x712
 c74:	00193c0e 	andseq	r3, r9, lr, lsl #24
 c78:	01131300 	tsteq	r3, r0, lsl #6
 c7c:	0b0b0e03 	bleq	2c4490 <__bss_end+0x2bad4c>
 c80:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 c84:	13010b39 	movwne	r0, #6969	; 0x1b39
 c88:	0d140000 	ldceq	0, cr0, [r4, #-0]
 c8c:	3a0e0300 	bcc	381894 <__bss_end+0x378150>
 c90:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 c94:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 c98:	1500000b 	strne	r0, [r0, #-11]
 c9c:	13490021 	movtne	r0, #36897	; 0x9021
 ca0:	00000b2f 	andeq	r0, r0, pc, lsr #22
 ca4:	03010416 	movweq	r0, #5142	; 0x1416
 ca8:	0b0b3e0e 	bleq	2d04e8 <__bss_end+0x2c6da4>
 cac:	3a13490b 	bcc	4d30e0 <__bss_end+0x4c999c>
 cb0:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 cb4:	0013010b 	andseq	r0, r3, fp, lsl #2
 cb8:	00341700 	eorseq	r1, r4, r0, lsl #14
 cbc:	0b3a1347 	bleq	e859e0 <__bss_end+0xe7c29c>
 cc0:	0b39053b 	bleq	e421b4 <__bss_end+0xe38a70>
 cc4:	00001802 	andeq	r1, r0, r2, lsl #16
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
  74:	0000010c 	andeq	r0, r0, ip, lsl #2
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	12240002 	eorne	r0, r4, #2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008340 	andeq	r8, r0, r0, asr #6
  94:	00000460 	andeq	r0, r0, r0, ror #8
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	1eff0002 	cdpne	0, 15, cr0, cr15, cr2, {0}
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	000087a0 	andeq	r8, r0, r0, lsr #15
  b4:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	22310002 	eorscs	r0, r1, #2
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00008c58 	andeq	r8, r0, r8, asr ip
  d4:	000004b4 			; <UNDEFINED> instruction: 0x000004b4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	335b0002 	cmpcc	fp, #2
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	0000910c 	andeq	r9, r0, ip, lsl #2
  f4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	33810002 	orrcc	r0, r1, #2
 108:	00040000 	andeq	r0, r4, r0
 10c:	00000000 	andeq	r0, r0, r0
 110:	00009318 	andeq	r9, r0, r8, lsl r3
 114:	00000004 	andeq	r0, r0, r4
	...
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	33a70002 			; <UNDEFINED> instruction: 0x33a70002
 128:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff6808>
       4:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
       8:	6b69746e 	blvs	1a5d1c8 <__bss_end+0x1a53a84>
       c:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
      10:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
      14:	4f54522d 	svcmi	0x0054522d
      18:	616d2d53 	cmnvs	sp, r3, asr sp
      1c:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
      20:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffcf9 <__bss_end+0xffff65b5>
      24:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
      28:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
      2c:	61707372 	cmnvs	r0, r2, ror r3
      30:	632f6563 			; <UNDEFINED> instruction: 0x632f6563
      34:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
      38:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
      3c:	2f656d6f 	svccs	0x00656d6f
      40:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
      44:	642f6b69 	strtvs	r6, [pc], #-2921	; 4c <shift+0x4c>
      48:	4b2f7665 	blmi	bdd9e4 <__bss_end+0xbd42a0>
      4c:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
      50:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
      54:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
      58:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
      5c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
      60:	752f7365 	strvc	r7, [pc, #-869]!	; fffffd03 <__bss_end+0xffff65bf>
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
     268:	2b2b4320 	blcs	ad0ef0 <__bss_end+0xac77ac>
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
     2fc:	6a363731 	bvs	d8dfc8 <__bss_end+0xd84884>
     300:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     304:	616d2d20 	cmnvs	sp, r0, lsr #26
     308:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     30c:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     310:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     314:	7a36766d 	bvc	d9dcd0 <__bss_end+0xd9458c>
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
     478:	5a5f0074 	bpl	17c0650 <__bss_end+0x17b6f0c>
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
     534:	766e4900 	strbtvc	r4, [lr], -r0, lsl #18
     538:	64696c61 	strbtvs	r6, [r9], #-3169	; 0xfffff39f
     53c:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     540:	00656c64 	rsbeq	r6, r5, r4, ror #24
     544:	65657246 	strbvs	r7, [r5, #-582]!	; 0xfffffdba
     548:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     54c:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
     550:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
     554:	61654400 	cmnvs	r5, r0, lsl #8
     558:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     55c:	6e555f65 	cdpvs	15, 5, cr5, cr5, cr5, {3}
     560:	6e616863 	cdpvs	8, 6, cr6, cr1, cr3, {3}
     564:	00646567 	rsbeq	r6, r4, r7, ror #10
     568:	314e5a5f 	cmpcc	lr, pc, asr sl
     56c:	69464331 	stmdbvs	r6, {r0, r4, r5, r8, r9, lr}^
     570:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     574:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     578:	6e493031 	mcrvs	0, 2, r3, cr9, cr1, {1}
     57c:	61697469 	cmnvs	r9, r9, ror #8
     580:	657a696c 	ldrbvs	r6, [sl, #-2412]!	; 0xfffff694
     584:	6d007645 	stcvs	6, cr7, [r0, #-276]	; 0xfffffeec
     588:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     58c:	6e696f50 	mcrvs	15, 3, r6, cr9, cr0, {2}
     590:	65470074 	strbvs	r0, [r7, #-116]	; 0xffffff8c
     594:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     598:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     59c:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     5a0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5a4:	50470073 	subpl	r0, r7, r3, ror r0
     5a8:	425f4f49 	subsmi	r4, pc, #292	; 0x124
     5ac:	00657361 	rsbeq	r7, r5, r1, ror #6
     5b0:	314e5a5f 	cmpcc	lr, pc, asr sl
     5b4:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     5b8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5bc:	614d5f73 	hvcvs	54771	; 0xd5f3
     5c0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     5c4:	43343172 	teqmi	r4, #-2147483620	; 0x8000001c
     5c8:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
     5cc:	72505f65 	subsvc	r5, r0, #404	; 0x194
     5d0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5d4:	68504573 	ldmdavs	r0, {r0, r1, r4, r5, r6, r8, sl, lr}^
     5d8:	7000626a 	andvc	r6, r0, sl, ror #4
     5dc:	00766572 	rsbseq	r6, r6, r2, ror r5
     5e0:	314e5a5f 	cmpcc	lr, pc, asr sl
     5e4:	4c4f4333 	mcrrmi	3, 3, r4, pc, cr3
     5e8:	445f4445 	ldrbmi	r4, [pc], #-1093	; 5f0 <shift+0x5f0>
     5ec:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
     5f0:	50387961 	eorspl	r7, r8, r1, ror #18
     5f4:	435f7475 	cmpmi	pc, #1962934272	; 0x75000000
     5f8:	45726168 	ldrbmi	r6, [r2, #-360]!	; 0xfffffe98
     5fc:	00637474 	rsbeq	r7, r3, r4, ror r4
     600:	4b4e5a5f 	blmi	1396f84 <__bss_end+0x138d840>
     604:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     608:	5f4f4950 	svcpl	0x004f4950
     60c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     610:	3272656c 	rsbscc	r6, r2, #108, 10	; 0x1b000000
     614:	74654736 	strbtvc	r4, [r5], #-1846	; 0xfffff8ca
     618:	5f50475f 	svcpl	0x0050475f
     61c:	5f515249 	svcpl	0x00515249
     620:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     624:	4c5f7463 	cfldrdmi	mvd7, [pc], {99}	; 0x63
     628:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     62c:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     630:	4e30326a 	cdpmi	2, 3, cr3, cr0, cr10, {3}
     634:	4f495047 	svcmi	0x00495047
     638:	746e495f 	strbtvc	r4, [lr], #-2399	; 0xfffff6a1
     63c:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     640:	545f7470 	ldrbpl	r7, [pc], #-1136	; 648 <shift+0x648>
     644:	52657079 	rsbpl	r7, r5, #121	; 0x79
     648:	5f31536a 	svcpl	0x0031536a
     64c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     650:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     654:	636f7250 	cmnvs	pc, #80, 4
     658:	5f737365 	svcpl	0x00737365
     65c:	616e614d 	cmnvs	lr, sp, asr #2
     660:	31726567 	cmncc	r2, r7, ror #10
     664:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     668:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     66c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     670:	6f72505f 	svcvs	0x0072505f
     674:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     678:	54007645 	strpl	r7, [r0], #-1605	; 0xfffff9bb
     67c:	545f5346 	ldrbpl	r5, [pc], #-838	; 684 <shift+0x684>
     680:	5f656572 	svcpl	0x00656572
     684:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     688:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     68c:	74754f5f 	ldrbtvc	r4, [r5], #-3935	; 0xfffff0a1
     690:	00747570 	rsbseq	r7, r4, r0, ror r5
     694:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     698:	695f7265 	ldmdbvs	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     69c:	52007864 	andpl	r7, r0, #100, 16	; 0x640000
     6a0:	5f646165 	svcpl	0x00646165
     6a4:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
     6a8:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     6ac:	6f72505f 	svcvs	0x0072505f
     6b0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6b4:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     6b8:	5f64656e 	svcpl	0x0064656e
     6bc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     6c0:	43540073 	cmpmi	r4, #115	; 0x73
     6c4:	435f5550 	cmpmi	pc, #80, 10	; 0x14000000
     6c8:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     6cc:	5f007478 	svcpl	0x00007478
     6d0:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     6d4:	6f725043 	svcvs	0x00725043
     6d8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6dc:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     6e0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     6e4:	68635338 	stmdavs	r3!, {r3, r4, r5, r8, r9, ip, lr}^
     6e8:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     6ec:	00764565 	rsbseq	r4, r6, r5, ror #10
     6f0:	314e5a5f 	cmpcc	lr, pc, asr sl
     6f4:	4c4f4333 	mcrrmi	3, 3, r4, pc, cr3
     6f8:	445f4445 	ldrbmi	r4, [pc], #-1093	; 700 <shift+0x700>
     6fc:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
     700:	34437961 	strbcc	r7, [r3], #-2401	; 0xfffff69f
     704:	634b5045 	movtvs	r5, #45125	; 0xb045
     708:	5f734900 	svcpl	0x00734900
     70c:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     710:	4e006465 	cdpmi	4, 0, cr6, cr0, cr5, {3}
     714:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     718:	6c6c4179 	stfvse	f4, [ip], #-484	; 0xfffffe1c
     71c:	6f6c4200 	svcvs	0x006c4200
     720:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     724:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     728:	505f746e 	subspl	r7, pc, lr, ror #8
     72c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     730:	47007373 	smlsdxmi	r0, r3, r3, r7
     734:	505f7465 	subspl	r7, pc, r5, ror #8
     738:	75004449 	strvc	r4, [r0, #-1097]	; 0xfffffbb7
     73c:	33746e69 	cmncc	r4, #1680	; 0x690
     740:	00745f32 	rsbseq	r5, r4, r2, lsr pc
     744:	314e5a5f 	cmpcc	lr, pc, asr sl
     748:	50474333 	subpl	r4, r7, r3, lsr r3
     74c:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     750:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     754:	47397265 	ldrmi	r7, [r9, -r5, ror #4]!
     758:	495f7465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     75c:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
     760:	5f006a45 	svcpl	0x00006a45
     764:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     768:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     76c:	61485f4f 	cmpvs	r8, pc, asr #30
     770:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     774:	53303172 	teqpl	r0, #-2147483620	; 0x8000001c
     778:	4f5f7465 	svcmi	0x005f7465
     77c:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
     780:	626a4574 	rsbvs	r4, sl, #116, 10	; 0x1d000000
     784:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     788:	4f433331 	svcmi	0x00433331
     78c:	5f44454c 	svcpl	0x0044454c
     790:	70736944 	rsbsvc	r6, r3, r4, asr #18
     794:	3579616c 	ldrbcc	r6, [r9, #-364]!	; 0xfffffe94
     798:	61656c43 	cmnvs	r5, r3, asr #24
     79c:	00624572 	rsbeq	r4, r2, r2, ror r5
     7a0:	31435342 	cmpcc	r3, r2, asr #6
     7a4:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     7a8:	75500065 	ldrbvc	r0, [r0, #-101]	; 0xffffff9b
     7ac:	68435f74 	stmdavs	r3, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     7b0:	57007261 	strpl	r7, [r0, -r1, ror #4]
     7b4:	00746961 	rsbseq	r6, r4, r1, ror #18
     7b8:	7361544e 	cmnvc	r1, #1308622848	; 0x4e000000
     7bc:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     7c0:	00657461 	rsbeq	r7, r5, r1, ror #8
     7c4:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     7c8:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     7cc:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     7d0:	6f6c4200 	svcvs	0x006c4200
     7d4:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     7d8:	75436d00 	strbvc	r6, [r3, #-3328]	; 0xfffff300
     7dc:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     7e0:	61545f74 	cmpvs	r4, r4, ror pc
     7e4:	4e5f6b73 	vmovmi.s8	r6, d15[3]
     7e8:	0065646f 	rsbeq	r6, r5, pc, ror #8
     7ec:	314e5a5f 	cmpcc	lr, pc, asr sl
     7f0:	50474333 	subpl	r4, r7, r3, lsr r3
     7f4:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     7f8:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     7fc:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
     800:	6d006a45 	vstrvs	s12, [r0, #-276]	; 0xfffffeec
     804:	746f6f52 	strbtvc	r6, [pc], #-3922	; 80c <shift+0x80c>
     808:	7665445f 			; <UNDEFINED> instruction: 0x7665445f
     80c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     810:	50433631 	subpl	r3, r3, r1, lsr r6
     814:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     818:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 654 <shift+0x654>
     81c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     820:	53397265 	teqpl	r9, #1342177286	; 0x50000006
     824:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     828:	6f545f68 	svcvs	0x00545f68
     82c:	38315045 	ldmdacc	r1!, {r0, r2, r6, ip, lr}
     830:	6f725043 	svcvs	0x00725043
     834:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     838:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     83c:	6f4e5f74 	svcvs	0x004e5f74
     840:	70006564 	andvc	r6, r0, r4, ror #10
     844:	695f6e69 	ldmdbvs	pc, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^	; <UNPREDICTABLE>
     848:	63007864 	movwvs	r7, #2148	; 0x864
     84c:	635f7570 	cmpvs	pc, #112, 10	; 0x1c000000
     850:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     854:	6d007478 	cfstrsvs	mvf7, [r0, #-480]	; 0xfffffe20
     858:	4f495047 	svcmi	0x00495047
     85c:	65724300 	ldrbvs	r4, [r2, #-768]!	; 0xfffffd00
     860:	5f657461 	svcpl	0x00657461
     864:	636f7250 	cmnvs	pc, #80, 4
     868:	00737365 	rsbseq	r7, r3, r5, ror #6
     86c:	4b4e5a5f 	blmi	13971f0 <__bss_end+0x138daac>
     870:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     874:	5f4f4950 	svcpl	0x004f4950
     878:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     87c:	3172656c 	cmncc	r2, ip, ror #10
     880:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     884:	4650475f 			; <UNDEFINED> instruction: 0x4650475f
     888:	5f4c4553 	svcpl	0x004c4553
     88c:	61636f4c 	cmnvs	r3, ip, asr #30
     890:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     894:	6a526a45 	bvs	149b1b0 <__bss_end+0x1491a6c>
     898:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     89c:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     8a0:	44736900 	ldrbtmi	r6, [r3], #-2304	; 0xfffff700
     8a4:	63657269 	cmnvs	r5, #-1879048186	; 0x90000006
     8a8:	79726f74 	ldmdbvc	r2!, {r2, r4, r5, r6, r8, r9, sl, fp, sp, lr}^
     8ac:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     8b0:	4350475f 	cmpmi	r0, #24903680	; 0x17c0000
     8b4:	4c5f524c 	lfmmi	f5, 2, [pc], {76}	; 0x4c
     8b8:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     8bc:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     8c0:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     8c4:	61425f72 	hvcvs	9714	; 0x25f2
     8c8:	67006573 	smlsdxvs	r0, r3, r5, r6
     8cc:	445f5346 	ldrbmi	r5, [pc], #-838	; 8d4 <shift+0x8d4>
     8d0:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     8d4:	435f7372 	cmpmi	pc, #-939524095	; 0xc8000001
     8d8:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     8dc:	50477300 	subpl	r7, r7, r0, lsl #6
     8e0:	47004f49 	strmi	r4, [r0, -r9, asr #30]
     8e4:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     8e8:	53444550 	movtpl	r4, #17744	; 0x4550
     8ec:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     8f0:	6f697461 	svcvs	0x00697461
     8f4:	6553006e 	ldrbvs	r0, [r3, #-110]	; 0xffffff92
     8f8:	50475f74 	subpl	r5, r7, r4, ror pc
     8fc:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     900:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     904:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     908:	314e5a5f 	cmpcc	lr, pc, asr sl
     90c:	4c4f4333 	mcrrmi	3, 3, r4, pc, cr3
     910:	445f4445 	ldrbmi	r4, [pc], #-1093	; 918 <shift+0x918>
     914:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
     918:	46347961 	ldrtmi	r7, [r4], -r1, ror #18
     91c:	4570696c 	ldrbmi	r6, [r0, #-2412]!	; 0xfffff694
     920:	5a5f0076 	bpl	17c0b00 <__bss_end+0x17b73bc>
     924:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     928:	636f7250 	cmnvs	pc, #80, 4
     92c:	5f737365 	svcpl	0x00737365
     930:	616e614d 	cmnvs	lr, sp, asr #2
     934:	31726567 	cmncc	r2, r7, ror #10
     938:	746f4e34 	strbtvc	r4, [pc], #-3636	; 940 <shift+0x940>
     93c:	5f796669 	svcpl	0x00796669
     940:	636f7250 	cmnvs	pc, #80, 4
     944:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     948:	54323150 	ldrtpl	r3, [r2], #-336	; 0xfffffeb0
     94c:	6b736154 	blvs	1cd8ea4 <__bss_end+0x1ccf760>
     950:	7274535f 	rsbsvc	r5, r4, #2080374785	; 0x7c000001
     954:	00746375 	rsbseq	r6, r4, r5, ror r3
     958:	5f746547 	svcpl	0x00746547
     95c:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     960:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     964:	61006f66 	tstvs	r0, r6, ror #30
     968:	00766772 	rsbseq	r6, r6, r2, ror r7
     96c:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
     970:	486d006c 	stmdami	sp!, {r2, r3, r5, r6}^
     974:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     978:	65540065 	ldrbvs	r0, [r4, #-101]	; 0xffffff9b
     97c:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
     980:	00657461 	rsbeq	r7, r5, r1, ror #8
     984:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     988:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     98c:	746f4e00 	strbtvc	r4, [pc], #-3584	; 994 <shift+0x994>
     990:	5f796669 	svcpl	0x00796669
     994:	636f7250 	cmnvs	pc, #80, 4
     998:	00737365 	rsbseq	r7, r3, r5, ror #6
     99c:	314e5a5f 	cmpcc	lr, pc, asr sl
     9a0:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     9a4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     9a8:	614d5f73 	hvcvs	54771	; 0xd5f3
     9ac:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     9b0:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     9b4:	5a5f0076 	bpl	17c0b94 <__bss_end+0x17b7450>
     9b8:	33314b4e 	teqcc	r1, #79872	; 0x13800
     9bc:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     9c0:	61485f4f 	cmpvs	r8, pc, asr #30
     9c4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     9c8:	47383172 			; <UNDEFINED> instruction: 0x47383172
     9cc:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     9d0:	54455350 	strbpl	r5, [r5], #-848	; 0xfffffcb0
     9d4:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     9d8:	6f697461 	svcvs	0x00697461
     9dc:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     9e0:	5f30536a 	svcpl	0x0030536a
     9e4:	73656d00 	cmnvc	r5, #0, 26
     9e8:	65676173 	strbvs	r6, [r7, #-371]!	; 0xfffffe8d
     9ec:	4c6d0073 	stclmi	0, cr0, [sp], #-460	; 0xfffffe34
     9f0:	006b636f 	rsbeq	r6, fp, pc, ror #6
     9f4:	6f6f526d 	svcvs	0x006f526d
     9f8:	6e4d5f74 	mcrvs	15, 2, r5, cr13, cr4, {3}
     9fc:	5a5f0074 	bpl	17c0bd4 <__bss_end+0x17b7490>
     a00:	33314b4e 	teqcc	r1, #79872	; 0x13800
     a04:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     a08:	61485f4f 	cmpvs	r8, pc, asr #30
     a0c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     a10:	47323272 			; <UNDEFINED> instruction: 0x47323272
     a14:	445f7465 	ldrbmi	r7, [pc], #-1125	; a1c <shift+0xa1c>
     a18:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     a1c:	5f646574 	svcpl	0x00646574
     a20:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     a24:	69505f74 	ldmdbvs	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     a28:	0076456e 	rsbseq	r4, r6, lr, ror #10
     a2c:	61656c43 	cmnvs	r5, r3, asr #24
     a30:	5a5f0072 	bpl	17c0c00 <__bss_end+0x17b74bc>
     a34:	33314b4e 	teqcc	r1, #79872	; 0x13800
     a38:	454c4f43 	strbmi	r4, [ip, #-3907]	; 0xfffff0bd
     a3c:	69445f44 	stmdbvs	r4, {r2, r6, r8, r9, sl, fp, ip, lr}^
     a40:	616c7073 	smcvs	50947	; 0xc703
     a44:	73493979 	movtvc	r3, #39289	; 0x9979
     a48:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     a4c:	4564656e 	strbmi	r6, [r4, #-1390]!	; 0xfffffa92
     a50:	5a5f0076 	bpl	17c0c30 <__bss_end+0x17b74ec>
     a54:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     a58:	4f495047 	svcmi	0x00495047
     a5c:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     a60:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     a64:	6e453931 			; <UNDEFINED> instruction: 0x6e453931
     a68:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     a6c:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     a70:	445f746e 	ldrbmi	r7, [pc], #-1134	; a78 <shift+0xa78>
     a74:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     a78:	326a4574 	rsbcc	r4, sl, #116, 10	; 0x1d000000
     a7c:	50474e30 	subpl	r4, r7, r0, lsr lr
     a80:	495f4f49 	ldmdbmi	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     a84:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     a88:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     a8c:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     a90:	6f4e0065 	svcvs	0x004e0065
     a94:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     a98:	69726400 	ldmdbvs	r2!, {sl, sp, lr}^
     a9c:	00726576 	rsbseq	r6, r2, r6, ror r5
     aa0:	61656c43 	cmnvs	r5, r3, asr #24
     aa4:	65445f72 	strbvs	r5, [r4, #-3954]	; 0xfffff08e
     aa8:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     aac:	455f6465 	ldrbmi	r6, [pc, #-1125]	; 64f <shift+0x64f>
     ab0:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     ab4:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     ab8:	5f656c64 	svcpl	0x00656c64
     abc:	00515249 	subseq	r5, r1, r9, asr #4
     ac0:	5078614d 	rsbspl	r6, r8, sp, asr #2
     ac4:	4c687461 	cfstrdmi	mvd7, [r8], #-388	; 0xfffffe7c
     ac8:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     acc:	5a5f0068 	bpl	17c0c74 <__bss_end+0x17b7530>
     ad0:	33314b4e 	teqcc	r1, #79872	; 0x13800
     ad4:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     ad8:	61485f4f 	cmpvs	r8, pc, asr #30
     adc:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     ae0:	47383172 			; <UNDEFINED> instruction: 0x47383172
     ae4:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     ae8:	53444550 	movtpl	r4, #17744	; 0x4550
     aec:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     af0:	6f697461 	svcvs	0x00697461
     af4:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     af8:	5f30536a 	svcpl	0x0030536a
     afc:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     b00:	72445346 	subvc	r5, r4, #402653185	; 0x18000001
     b04:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     b08:	656d614e 	strbvs	r6, [sp, #-334]!	; 0xfffffeb2
     b0c:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     b10:	6d006874 	stcvs	8, cr6, [r0, #-464]	; 0xfffffe30
     b14:	5f6e6950 	svcpl	0x006e6950
     b18:	65736552 	ldrbvs	r6, [r3, #-1362]!	; 0xfffffaae
     b1c:	74617672 	strbtvc	r7, [r1], #-1650	; 0xfffff98e
     b20:	736e6f69 	cmnvc	lr, #420	; 0x1a4
     b24:	6972575f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, ip, lr}^
     b28:	5f006574 	svcpl	0x00006574
     b2c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     b30:	6f725043 	svcvs	0x00725043
     b34:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b38:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     b3c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     b40:	63533131 	cmpvs	r3, #1073741836	; 0x4000000c
     b44:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     b48:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
     b4c:	00764552 	rsbseq	r4, r6, r2, asr r5
     b50:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     b54:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     b58:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     b5c:	5f6f666e 	svcpl	0x006f666e
     b60:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     b64:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     b68:	745f7065 	ldrbvc	r7, [pc], #-101	; b70 <shift+0xb70>
     b6c:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     b70:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     b74:	69505f4f 	ldmdbvs	r0, {r0, r1, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
     b78:	6f435f6e 	svcvs	0x00435f6e
     b7c:	00746e75 	rsbseq	r6, r4, r5, ror lr
     b80:	6b736174 	blvs	1cd9158 <__bss_end+0x1ccfa14>
     b84:	69615700 	stmdbvs	r1!, {r8, r9, sl, ip, lr}^
     b88:	6f465f74 	svcvs	0x00465f74
     b8c:	76455f72 			; <UNDEFINED> instruction: 0x76455f72
     b90:	00746e65 	rsbseq	r6, r4, r5, ror #28
     b94:	5f746547 	svcpl	0x00746547
     b98:	4f495047 	svcmi	0x00495047
     b9c:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     ba0:	6f697463 	svcvs	0x00697463
     ba4:	6f62006e 	svcvs	0x0062006e
     ba8:	5f006c6f 	svcpl	0x00006c6f
     bac:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     bb0:	6f725043 	svcvs	0x00725043
     bb4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     bb8:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     bbc:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     bc0:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     bc4:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     bc8:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     bcc:	5f72656c 	svcpl	0x0072656c
     bd0:	6f666e49 	svcvs	0x00666e49
     bd4:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     bd8:	5f746547 	svcpl	0x00746547
     bdc:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     be0:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     be4:	545f6f66 	ldrbpl	r6, [pc], #-3942	; bec <shift+0xbec>
     be8:	50657079 	rsbpl	r7, r5, r9, ror r0
     bec:	52540076 	subspl	r0, r4, #118	; 0x76
     bf0:	425f474e 	subsmi	r4, pc, #20447232	; 0x1380000
     bf4:	00657361 	rsbeq	r7, r5, r1, ror #6
     bf8:	61666544 	cmnvs	r6, r4, asr #10
     bfc:	5f746c75 	svcpl	0x00746c75
     c00:	636f6c43 	cmnvs	pc, #17152	; 0x4300
     c04:	61525f6b 	cmpvs	r2, fp, ror #30
     c08:	6d006574 	cfstr32vs	mvfx6, [r0, #-464]	; 0xfffffe30
     c0c:	746f6f52 	strbtvc	r6, [pc], #-3922	; c14 <shift+0xc14>
     c10:	7379535f 	cmnvc	r9, #2080374785	; 0x7c000001
     c14:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     c18:	5350475f 	cmppl	r0, #24903680	; 0x17c0000
     c1c:	4c5f5445 	cfldrdmi	mvd5, [pc], {69}	; 0x45
     c20:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     c24:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     c28:	6f72506d 	svcvs	0x0072506d
     c2c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     c30:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     c34:	65485f74 	strbvs	r5, [r8, #-3956]	; 0xfffff08c
     c38:	6d006461 	cfstrsvs	mvf6, [r0, #-388]	; 0xfffffe7c
     c3c:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     c40:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     c44:	636e465f 	cmnvs	lr, #99614720	; 0x5f00000
     c48:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     c4c:	50433631 	subpl	r3, r3, r1, lsr r6
     c50:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     c54:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; a90 <shift+0xa90>
     c58:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     c5c:	31327265 	teqcc	r2, r5, ror #4
     c60:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     c64:	75435f6b 	strbvc	r5, [r3, #-3947]	; 0xfffff095
     c68:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     c6c:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     c70:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     c74:	00764573 	rsbseq	r4, r6, r3, ror r5
     c78:	6961576d 	stmdbvs	r1!, {r0, r2, r3, r5, r6, r8, r9, sl, ip, lr}^
     c7c:	676e6974 			; <UNDEFINED> instruction: 0x676e6974
     c80:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     c84:	4c007365 	stcmi	3, cr7, [r0], {101}	; 0x65
     c88:	5f6b636f 	svcpl	0x006b636f
     c8c:	6f6c6e55 	svcvs	0x006c6e55
     c90:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     c94:	614c6d00 	cmpvs	ip, r0, lsl #26
     c98:	505f7473 	subspl	r7, pc, r3, ror r4	; <UNPREDICTABLE>
     c9c:	5f004449 	svcpl	0x00004449
     ca0:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     ca4:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     ca8:	61485f4f 	cmpvs	r8, pc, asr #30
     cac:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     cb0:	53373172 	teqpl	r7, #-2147483620	; 0x8000001c
     cb4:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     cb8:	5f4f4950 	svcpl	0x004f4950
     cbc:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     cc0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     cc4:	34316a45 	ldrtcc	r6, [r1], #-2629	; 0xfffff5bb
     cc8:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     ccc:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     cd0:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     cd4:	47006e6f 	strmi	r6, [r0, -pc, ror #28]
     cd8:	495f7465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     cdc:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
     ce0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     ce4:	46433131 			; <UNDEFINED> instruction: 0x46433131
     ce8:	73656c69 	cmnvc	r5, #26880	; 0x6900
     cec:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     cf0:	704f346d 	subvc	r3, pc, sp, ror #8
     cf4:	50456e65 	subpl	r6, r5, r5, ror #28
     cf8:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
     cfc:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
     d00:	704f5f65 	subvc	r5, pc, r5, ror #30
     d04:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; b78 <shift+0xb78>
     d08:	0065646f 	rsbeq	r6, r5, pc, ror #8
     d0c:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
     d10:	545f6863 	ldrbpl	r6, [pc], #-2147	; d18 <shift+0xd18>
     d14:	6c43006f 	mcrrvs	0, 6, r0, r3, cr15
     d18:	0065736f 	rsbeq	r7, r5, pc, ror #6
     d1c:	314e5a5f 	cmpcc	lr, pc, asr sl
     d20:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     d24:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     d28:	614d5f73 	hvcvs	54771	; 0xd5f3
     d2c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     d30:	53323172 	teqpl	r2, #-2147483620	; 0x8000001c
     d34:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     d38:	5f656c75 	svcpl	0x00656c75
     d3c:	45464445 	strbmi	r4, [r6, #-1093]	; 0xfffffbbb
     d40:	65470076 	strbvs	r0, [r7, #-118]	; 0xffffff8a
     d44:	50475f74 	subpl	r5, r7, r4, ror pc
     d48:	5f56454c 	svcpl	0x0056454c
     d4c:	61636f4c 	cmnvs	r3, ip, asr #30
     d50:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     d54:	43534200 	cmpmi	r3, #0, 4
     d58:	61425f30 	cmpvs	r2, r0, lsr pc
     d5c:	52006573 	andpl	r6, r0, #482344960	; 0x1cc00000
     d60:	6e697369 	cdpvs	3, 6, cr7, cr9, cr9, {3}
     d64:	64455f67 	strbvs	r5, [r5], #-3943	; 0xfffff099
     d68:	61006567 	tstvs	r0, r7, ror #10
     d6c:	00636772 	rsbeq	r6, r3, r2, ror r7
     d70:	65736552 	ldrbvs	r6, [r3, #-1362]!	; 0xfffffaae
     d74:	5f657672 	svcpl	0x00657672
     d78:	006e6950 	rsbeq	r6, lr, r0, asr r9
     d7c:	68676948 	stmdavs	r7!, {r3, r6, r8, fp, sp, lr}^
     d80:	746f6e00 	strbtvc	r6, [pc], #-3584	; d88 <shift+0xd88>
     d84:	65696669 	strbvs	r6, [r9, #-1641]!	; 0xfffff997
     d88:	65645f64 	strbvs	r5, [r4, #-3940]!	; 0xfffff09c
     d8c:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     d90:	7500656e 	strvc	r6, [r0, #-1390]	; 0xfffffa92
     d94:	31746e69 	cmncc	r4, r9, ror #28
     d98:	00745f36 	rsbseq	r5, r4, r6, lsr pc
     d9c:	6c6c6146 	stfvse	f6, [ip], #-280	; 0xfffffee8
     da0:	5f676e69 	svcpl	0x00676e69
     da4:	65676445 	strbvs	r6, [r7, #-1093]!	; 0xfffffbbb
     da8:	704f6d00 	subvc	r6, pc, r0, lsl #26
     dac:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     db0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     db4:	46433131 			; <UNDEFINED> instruction: 0x46433131
     db8:	73656c69 	cmnvc	r5, #26880	; 0x6900
     dbc:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     dc0:	4534436d 	ldrmi	r4, [r4, #-877]!	; 0xfffffc93
     dc4:	5a5f0076 	bpl	17c0fa4 <__bss_end+0x17b7860>
     dc8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     dcc:	636f7250 	cmnvs	pc, #80, 4
     dd0:	5f737365 	svcpl	0x00737365
     dd4:	616e614d 	cmnvs	lr, sp, asr #2
     dd8:	31726567 	cmncc	r2, r7, ror #10
     ddc:	746f4e34 	strbtvc	r4, [pc], #-3636	; de4 <shift+0xde4>
     de0:	5f796669 	svcpl	0x00796669
     de4:	636f7250 	cmnvs	pc, #80, 4
     de8:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     dec:	6f4e006a 	svcvs	0x004e006a
     df0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     df4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     df8:	72446d65 	subvc	r6, r4, #6464	; 0x1940
     dfc:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     e00:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
     e04:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     e08:	00745f6b 	rsbseq	r5, r4, fp, ror #30
     e0c:	314e5a5f 	cmpcc	lr, pc, asr sl
     e10:	4c4f4333 	mcrrmi	3, 3, r4, pc, cr3
     e14:	445f4445 	ldrbmi	r4, [pc], #-1093	; e1c <shift+0xe1c>
     e18:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
     e1c:	34447961 	strbcc	r7, [r4], #-2401	; 0xfffff69f
     e20:	47007645 	strmi	r7, [r0, -r5, asr #12]
     e24:	445f7465 	ldrbmi	r7, [pc], #-1125	; e2c <shift+0xe2c>
     e28:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     e2c:	5f646574 	svcpl	0x00646574
     e30:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     e34:	69505f74 	ldmdbvs	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     e38:	6544006e 	strbvs	r0, [r4, #-110]	; 0xffffff92
     e3c:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     e40:	7000656e 	andvc	r6, r0, lr, ror #10
     e44:	6e657261 	cdpvs	2, 6, cr7, cr5, cr1, {3}
     e48:	68730074 	ldmdavs	r3!, {r2, r4, r5, r6}^
     e4c:	2074726f 	rsbscs	r7, r4, pc, ror #4
     e50:	00746e69 	rsbseq	r6, r4, r9, ror #28
     e54:	4c4f437e 	mcrrmi	3, 7, r4, pc, cr14
     e58:	445f4445 	ldrbmi	r4, [pc], #-1093	; e60 <shift+0xe60>
     e5c:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
     e60:	4d007961 	vstrmi.16	s14, [r0, #-194]	; 0xffffff3e	; <UNPREDICTABLE>
     e64:	69467861 	stmdbvs	r6, {r0, r5, r6, fp, ip, sp, lr}^
     e68:	616e656c 	cmnvs	lr, ip, ror #10
     e6c:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     e70:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     e74:	6f526d00 	svcvs	0x00526d00
     e78:	2f00746f 	svccs	0x0000746f
     e7c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     e80:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
     e84:	2f6b6974 	svccs	0x006b6974
     e88:	2f766564 	svccs	0x00766564
     e8c:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
     e90:	534f5452 	movtpl	r5, #62546	; 0xf452
     e94:	73616d2d 	cmnvc	r1, #2880	; 0xb40
     e98:	2f726574 	svccs	0x00726574
     e9c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     ea0:	2f736563 	svccs	0x00736563
     ea4:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     ea8:	63617073 	cmnvs	r1, #115	; 0x73
     eac:	6c6f2f65 	stclvs	15, cr2, [pc], #-404	; d20 <shift+0xd20>
     eb0:	745f6465 	ldrbvc	r6, [pc], #-1125	; eb8 <shift+0xeb8>
     eb4:	2f6b7361 	svccs	0x006b7361
     eb8:	6e69616d 	powvsez	f6, f1, #5.0
     ebc:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     ec0:	72504300 	subsvc	r4, r0, #0, 6
     ec4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     ec8:	614d5f73 	hvcvs	54771	; 0xd5f3
     ecc:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     ed0:	6e550072 	mrcvs	0, 2, r0, cr5, cr2, {3}
     ed4:	63657073 	cmnvs	r5, #115	; 0x73
     ed8:	65696669 	strbvs	r6, [r9, #-1641]!	; 0xfffff997
     edc:	5a5f0064 	bpl	17c1074 <__bss_end+0x17b7930>
     ee0:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     ee4:	4f495047 	svcmi	0x00495047
     ee8:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     eec:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     ef0:	65724638 	ldrbvs	r4, [r2, #-1592]!	; 0xfffff9c8
     ef4:	69505f65 	ldmdbvs	r0, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     ef8:	626a456e 	rsbvs	r4, sl, #461373440	; 0x1b800000
     efc:	46730062 	ldrbtmi	r0, [r3], -r2, rrx
     f00:	73656c69 	cmnvc	r5, #26880	; 0x6900
     f04:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     f08:	6e49006d 	cdpvs	0, 4, cr0, cr9, cr13, {3}
     f0c:	61697469 	cmnvs	r9, r9, ror #8
     f10:	657a696c 	ldrbvs	r6, [sl, #-2412]!	; 0xfffff694
     f14:	6e694600 	cdpvs	6, 6, cr4, cr9, cr0, {0}
     f18:	68435f64 	stmdavs	r3, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     f1c:	00646c69 	rsbeq	r6, r4, r9, ror #24
     f20:	72627474 	rsbvc	r7, r2, #116, 8	; 0x74000000
     f24:	534e0030 	movtpl	r0, #57392	; 0xe030
     f28:	465f4957 			; <UNDEFINED> instruction: 0x465f4957
     f2c:	73656c69 	cmnvc	r5, #26880	; 0x6900
     f30:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     f34:	65535f6d 	ldrbvs	r5, [r3, #-3949]	; 0xfffff093
     f38:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     f3c:	534e0065 	movtpl	r0, #57445	; 0xe065
     f40:	505f4957 	subspl	r4, pc, r7, asr r9	; <UNPREDICTABLE>
     f44:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     f48:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     f4c:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     f50:	6f006563 	svcvs	0x00006563
     f54:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     f58:	69665f64 	stmdbvs	r6!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     f5c:	0073656c 	rsbseq	r6, r3, ip, ror #10
     f60:	6c656959 			; <UNDEFINED> instruction: 0x6c656959
     f64:	6e490064 	cdpvs	0, 4, cr0, cr9, cr4, {3}
     f68:	69666564 	stmdbvs	r6!, {r2, r5, r6, r8, sl, sp, lr}^
     f6c:	6574696e 	ldrbvs	r6, [r4, #-2414]!	; 0xfffff692
     f70:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     f74:	6f72505f 	svcvs	0x0072505f
     f78:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     f7c:	5f79425f 	svcpl	0x0079425f
     f80:	00444950 	subeq	r4, r4, r0, asr r9
     f84:	69726550 	ldmdbvs	r2!, {r4, r6, r8, sl, sp, lr}^
     f88:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
     f8c:	425f6c61 	subsmi	r6, pc, #24832	; 0x6100
     f90:	00657361 	rsbeq	r7, r5, r1, ror #6
     f94:	5f746547 	svcpl	0x00746547
     f98:	53465047 	movtpl	r5, #24647	; 0x6047
     f9c:	4c5f4c45 	mrrcmi	12, 4, r4, pc, cr5	; <UNPREDICTABLE>
     fa0:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     fa4:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     fa8:	314e5a5f 	cmpcc	lr, pc, asr sl
     fac:	4c4f4333 	mcrrmi	3, 3, r4, pc, cr3
     fb0:	445f4445 	ldrbmi	r4, [pc], #-1093	; fb8 <shift+0xfb8>
     fb4:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
     fb8:	30317961 	eorscc	r7, r1, r1, ror #18
     fbc:	5f747550 	svcpl	0x00747550
     fc0:	69727453 	ldmdbvs	r2!, {r0, r1, r4, r6, sl, ip, sp, lr}^
     fc4:	7445676e 	strbvc	r6, [r5], #-1902	; 0xfffff892
     fc8:	634b5074 	movtvs	r5, #45172	; 0xb074
     fcc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     fd0:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     fd4:	4f495047 	svcmi	0x00495047
     fd8:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     fdc:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     fe0:	65473731 	strbvs	r3, [r7, #-1841]	; 0xfffff8cf
     fe4:	50475f74 	subpl	r5, r7, r4, ror pc
     fe8:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     fec:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     ff0:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     ff4:	6c46006a 	mcrrvs	0, 6, r0, r6, cr10
     ff8:	49007069 	stmdbmi	r0, {r0, r3, r5, r6, ip, sp, lr}
     ffc:	6c61766e 	stclvs	6, cr7, [r1], #-440	; 0xfffffe48
    1000:	505f6469 	subspl	r6, pc, r9, ror #8
    1004:	5f006e69 	svcpl	0x00006e69
    1008:	33314e5a 	teqcc	r1, #1440	; 0x5a0
    100c:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
    1010:	61485f4f 	cmpvs	r8, pc, asr #30
    1014:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    1018:	44303272 	ldrtmi	r3, [r0], #-626	; 0xfffffd8e
    101c:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
    1020:	455f656c 	ldrbmi	r6, [pc, #-1388]	; abc <shift+0xabc>
    1024:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
    1028:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
    102c:	45746365 	ldrbmi	r6, [r4, #-869]!	; 0xfffffc9b
    1030:	4e30326a 	cdpmi	2, 3, cr3, cr0, cr10, {3}
    1034:	4f495047 	svcmi	0x00495047
    1038:	746e495f 	strbtvc	r4, [lr], #-2399	; 0xfffff6a1
    103c:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
    1040:	545f7470 	ldrbpl	r7, [pc], #-1136	; 1048 <shift+0x1048>
    1044:	00657079 	rsbeq	r7, r5, r9, ror r0
    1048:	6e69506d 	cdpvs	0, 6, cr5, cr9, cr13, {3}
    104c:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
    1050:	61767265 	cmnvs	r6, r5, ror #4
    1054:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1058:	65525f73 	ldrbvs	r5, [r2, #-3955]	; 0xfffff08d
    105c:	4c006461 	cfstrsmi	mvf6, [r0], {97}	; 0x61
    1060:	5f6b636f 	svcpl	0x006b636f
    1064:	6b636f4c 	blvs	18dcd9c <__bss_end+0x18d3658>
    1068:	5f006465 	svcpl	0x00006465
    106c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1070:	6f725043 	svcvs	0x00725043
    1074:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1078:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    107c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1080:	61483831 	cmpvs	r8, r1, lsr r8
    1084:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    1088:	6f72505f 	svcvs	0x0072505f
    108c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1090:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
    1094:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
    1098:	5f495753 	svcpl	0x00495753
    109c:	636f7250 	cmnvs	pc, #80, 4
    10a0:	5f737365 	svcpl	0x00737365
    10a4:	76726553 			; <UNDEFINED> instruction: 0x76726553
    10a8:	6a656369 	bvs	1959e54 <__bss_end+0x1950710>
    10ac:	31526a6a 	cmpcc	r2, sl, ror #20
    10b0:	57535431 	smmlarpl	r3, r1, r4, r5
    10b4:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
    10b8:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
    10bc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    10c0:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
    10c4:	5f4f4950 	svcpl	0x004f4950
    10c8:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    10cc:	3272656c 	rsbscc	r6, r2, #108, 10	; 0x1b000000
    10d0:	656c4330 	strbvs	r4, [ip, #-816]!	; 0xfffffcd0
    10d4:	445f7261 	ldrbmi	r7, [pc], #-609	; 10dc <shift+0x10dc>
    10d8:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
    10dc:	5f646574 	svcpl	0x00646574
    10e0:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
    10e4:	006a4574 	rsbeq	r4, sl, r4, ror r5
    10e8:	5f746553 	svcpl	0x00746553
    10ec:	65786950 	ldrbvs	r6, [r8, #-2384]!	; 0xfffff6b0
    10f0:	6373006c 	cmnvs	r3, #108	; 0x6c
    10f4:	5f646568 	svcpl	0x00646568
    10f8:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    10fc:	00726574 	rsbseq	r6, r2, r4, ror r5
    1100:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
    1104:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
    1108:	61686320 	cmnvs	r8, r0, lsr #6
    110c:	6e490072 	mcrvs	0, 2, r0, cr9, cr2, {3}
    1110:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
    1114:	61747075 	cmnvs	r4, r5, ror r0
    1118:	5f656c62 	svcpl	0x00656c62
    111c:	65656c53 	strbvs	r6, [r5, #-3155]!	; 0xfffff3ad
    1120:	65470070 	strbvs	r0, [r7, #-112]	; 0xffffff90
    1124:	50475f74 	subpl	r5, r7, r4, ror pc
    1128:	5152495f 	cmppl	r2, pc, asr r9
    112c:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
    1130:	5f746365 	svcpl	0x00746365
    1134:	61636f4c 	cmnvs	r3, ip, asr #30
    1138:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    113c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1140:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
    1144:	5f4f4950 	svcpl	0x004f4950
    1148:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    114c:	3172656c 	cmncc	r2, ip, ror #10
    1150:	69615734 	stmdbvs	r1!, {r2, r4, r5, r8, r9, sl, ip, lr}^
    1154:	6f465f74 	svcvs	0x00465f74
    1158:	76455f72 			; <UNDEFINED> instruction: 0x76455f72
    115c:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
    1160:	46493550 			; <UNDEFINED> instruction: 0x46493550
    1164:	6a656c69 	bvs	195c310 <__bss_end+0x1952bcc>
    1168:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
    116c:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
    1170:	52525f65 	subspl	r5, r2, #404	; 0x194
    1174:	58554100 	ldmdapl	r5, {r8, lr}^
    1178:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
    117c:	53420065 	movtpl	r0, #8293	; 0x2065
    1180:	425f3243 	subsmi	r3, pc, #805306372	; 0x30000004
    1184:	00657361 	rsbeq	r7, r5, r1, ror #6
    1188:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
    118c:	6e4f5f65 	cdpvs	15, 4, cr5, cr15, cr5, {3}
    1190:	5300796c 	movwpl	r7, #2412	; 0x96c
    1194:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    1198:	00656c75 	rsbeq	r6, r5, r5, ror ip
    119c:	314e5a5f 	cmpcc	lr, pc, asr sl
    11a0:	50474333 	subpl	r4, r7, r3, lsr r3
    11a4:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
    11a8:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    11ac:	30317265 	eorscc	r7, r1, r5, ror #4
    11b0:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    11b4:	495f656c 	ldmdbmi	pc, {r2, r3, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    11b8:	76455152 			; <UNDEFINED> instruction: 0x76455152
    11bc:	63695400 	cmnvs	r9, #0, 8
    11c0:	6f435f6b 	svcvs	0x00435f6b
    11c4:	00746e75 	rsbseq	r6, r4, r5, ror lr
    11c8:	314e5a5f 	cmpcc	lr, pc, asr sl
    11cc:	4c4f4333 	mcrrmi	3, 3, r4, pc, cr3
    11d0:	445f4445 	ldrbmi	r4, [pc], #-1093	; 11d8 <shift+0x11d8>
    11d4:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
    11d8:	53397961 	teqpl	r9, #1589248	; 0x184000
    11dc:	505f7465 	subspl	r7, pc, r5, ror #8
    11e0:	6c657869 	stclvs	8, cr7, [r5], #-420	; 0xfffffe5c
    11e4:	62747445 	rsbsvs	r7, r4, #1157627904	; 0x45000000
    11e8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    11ec:	50433631 	subpl	r3, r3, r1, lsr r6
    11f0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    11f4:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 1030 <shift+0x1030>
    11f8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    11fc:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
    1200:	616d6e55 	cmnvs	sp, r5, asr lr
    1204:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1208:	435f656c 	cmpmi	pc, #108, 10	; 0x1b000000
    120c:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
    1210:	6a45746e 	bvs	115e3d0 <__bss_end+0x1154c8c>
    1214:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
    1218:	4900305f 	stmdbmi	r0, {r0, r1, r2, r3, r4, r6, ip, sp}
    121c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1220:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    1224:	445f6d65 	ldrbmi	r6, [pc], #-3429	; 122c <shift+0x122c>
    1228:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
    122c:	6c410072 	mcrrvs	0, 7, r0, r1, cr2
    1230:	00325f74 	eorseq	r5, r2, r4, ror pc
    1234:	5f746c41 	svcpl	0x00746c41
    1238:	6c410033 	mcrrvs	0, 3, r0, r1, cr3
    123c:	00345f74 	eorseq	r5, r4, r4, ror pc
    1240:	5f746c41 	svcpl	0x00746c41
    1244:	5a5f0035 	bpl	17c1320 <__bss_end+0x17b7bdc>
    1248:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
    124c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1250:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    1254:	33316d65 	teqcc	r1, #6464	; 0x1940
    1258:	5f534654 	svcpl	0x00534654
    125c:	65657254 	strbvs	r7, [r5, #-596]!	; 0xfffffdac
    1260:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 1268 <shift+0x1268>
    1264:	46303165 	ldrtmi	r3, [r0], -r5, ror #2
    1268:	5f646e69 	svcpl	0x00646e69
    126c:	6c696843 	stclvs	8, cr6, [r9], #-268	; 0xfffffef4
    1270:	4b504564 	blmi	1412808 <__bss_end+0x14090c4>
    1274:	61480063 	cmpvs	r8, r3, rrx
    1278:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    127c:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
    1280:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    1284:	5f6d6574 	svcpl	0x006d6574
    1288:	00495753 	subeq	r5, r9, r3, asr r7
    128c:	4b4e5a5f 	blmi	1397c10 <__bss_end+0x138e4cc>
    1290:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
    1294:	5f4f4950 	svcpl	0x004f4950
    1298:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    129c:	3172656c 	cmncc	r2, ip, ror #10
    12a0:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
    12a4:	4350475f 	cmpmi	r0, #24903680	; 0x17c0000
    12a8:	4c5f524c 	lfmmi	f5, 2, [pc], {76}	; 0x4c
    12ac:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
    12b0:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
    12b4:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
    12b8:	73005f30 	movwvc	r5, #3888	; 0xf30
    12bc:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
    12c0:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
    12c4:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
    12c8:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
    12cc:	616d0074 	smcvs	53252	; 0xd004
    12d0:	64006e69 	strvs	r6, [r0], #-3689	; 0xfffff197
    12d4:	00707369 	rsbseq	r7, r0, r9, ror #6
    12d8:	6f725073 	svcvs	0x00725073
    12dc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    12e0:	0072674d 	rsbseq	r6, r2, sp, asr #14
    12e4:	5f747550 	svcpl	0x00747550
    12e8:	69727453 	ldmdbvs	r2!, {r0, r1, r4, r6, sl, ip, sp, lr}^
    12ec:	4300676e 	movwmi	r6, #1902	; 0x76e
    12f0:	4f495047 	svcmi	0x00495047
    12f4:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
    12f8:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
    12fc:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
    1300:	6300315f 	movwvs	r3, #351	; 0x15f
    1304:	646c6968 	strbtvs	r6, [ip], #-2408	; 0xfffff698
    1308:	006e6572 	rsbeq	r6, lr, r2, ror r5
    130c:	61736944 	cmnvs	r3, r4, asr #18
    1310:	5f656c62 	svcpl	0x00656c62
    1314:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
    1318:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
    131c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1320:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
    1324:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
    1328:	435f7470 	cmpmi	pc, #112, 8	; 0x70000000
    132c:	72746e6f 	rsbsvc	r6, r4, #1776	; 0x6f0
    1330:	656c6c6f 	strbvs	r6, [ip, #-3183]!	; 0xfffff391
    1334:	61425f72 	hvcvs	9714	; 0x25f2
    1338:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
    133c:	445f5346 	ldrbmi	r5, [pc], #-838	; 1344 <shift+0x1344>
    1340:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
    1344:	65520072 	ldrbvs	r0, [r2, #-114]	; 0xffffff8e
    1348:	575f6461 	ldrbpl	r6, [pc, -r1, ror #8]
    134c:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    1350:	74634100 	strbtvc	r4, [r3], #-256	; 0xffffff00
    1354:	5f657669 	svcpl	0x00657669
    1358:	636f7250 	cmnvs	pc, #80, 4
    135c:	5f737365 	svcpl	0x00737365
    1360:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
    1364:	5a5f0074 	bpl	17c153c <__bss_end+0x17b7df8>
    1368:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    136c:	636f7250 	cmnvs	pc, #80, 4
    1370:	5f737365 	svcpl	0x00737365
    1374:	616e614d 	cmnvs	lr, sp, asr #2
    1378:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
    137c:	6e614831 	mcrvs	8, 3, r4, cr1, cr1, {1}
    1380:	5f656c64 	svcpl	0x00656c64
    1384:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1388:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    138c:	535f6d65 	cmppl	pc, #6464	; 0x1940
    1390:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
    1394:	57534e33 	smmlarpl	r3, r3, lr, r4
    1398:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
    139c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    13a0:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    13a4:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
    13a8:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
    13ac:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
    13b0:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
    13b4:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
    13b8:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
    13bc:	6e450074 	mcrvs	0, 2, r0, cr5, cr4, {3}
    13c0:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    13c4:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
    13c8:	445f746e 	ldrbmi	r7, [pc], #-1134	; 13d0 <shift+0x13d0>
    13cc:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
    13d0:	72740074 	rsbsvc	r0, r4, #116	; 0x74
    13d4:	665f676e 	ldrbvs	r6, [pc], -lr, ror #14
    13d8:	00656c69 	rsbeq	r6, r5, r9, ror #24
    13dc:	736f6c63 	cmnvc	pc, #25344	; 0x6300
    13e0:	65530065 	ldrbvs	r0, [r3, #-101]	; 0xffffff9b
    13e4:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
    13e8:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    13ec:	47006576 	smlsdxmi	r0, r6, r5, r6
    13f0:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    13f4:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
    13f8:	332e3820 			; <UNDEFINED> instruction: 0x332e3820
    13fc:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    1400:	30393130 	eorscc	r3, r9, r0, lsr r1
    1404:	20333037 	eorscs	r3, r3, r7, lsr r0
    1408:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    140c:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    1410:	675b2029 	ldrbvs	r2, [fp, -r9, lsr #32]
    1414:	382d6363 	stmdacc	sp!, {r0, r1, r5, r6, r8, r9, sp, lr}
    1418:	6172622d 	cmnvs	r2, sp, lsr #4
    141c:	2068636e 	rsbcs	r6, r8, lr, ror #6
    1420:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1424:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
    1428:	33373220 	teqcc	r7, #32, 4
    142c:	5d373230 	lfmpl	f3, 4, [r7, #-192]!	; 0xffffff40
    1430:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1434:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1438:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    143c:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    1440:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    1444:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
    1448:	20706676 	rsbscs	r6, r0, r6, ror r6
    144c:	75746d2d 	ldrbvc	r6, [r4, #-3373]!	; 0xfffff2d3
    1450:	613d656e 	teqvs	sp, lr, ror #10
    1454:	31316d72 	teqcc	r1, r2, ror sp
    1458:	7a6a3637 	bvc	1a8ed3c <__bss_end+0x1a855f8>
    145c:	20732d66 	rsbscs	r2, r3, r6, ror #26
    1460:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1464:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1468:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    146c:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1470:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1474:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
    1478:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    147c:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
    1480:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
    1484:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    1488:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
    148c:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
    1490:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    1494:	616d2d20 	cmnvs	sp, r0, lsr #26
    1498:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    149c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    14a0:	2b6b7a36 	blcs	1adfd80 <__bss_end+0x1ad663c>
    14a4:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    14a8:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    14ac:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    14b0:	20304f2d 	eorscs	r4, r0, sp, lsr #30
    14b4:	20304f2d 	eorscs	r4, r0, sp, lsr #30
    14b8:	6f6e662d 	svcvs	0x006e662d
    14bc:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
    14c0:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
    14c4:	20736e6f 	rsbscs	r6, r3, pc, ror #28
    14c8:	6f6e662d 	svcvs	0x006e662d
    14cc:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
    14d0:	65720069 	ldrbvs	r0, [r2, #-105]!	; 0xffffff97
    14d4:	6c617674 	stclvs	6, cr7, [r1], #-464	; 0xfffffe30
    14d8:	75636e00 	strbvc	r6, [r3, #-3584]!	; 0xfffff200
    14dc:	69700072 	ldmdbvs	r0!, {r1, r4, r5, r6}^
    14e0:	72006570 	andvc	r6, r0, #112, 10	; 0x1c000000
    14e4:	6d756e64 	ldclvs	14, cr6, [r5, #-400]!	; 0xfffffe70
    14e8:	315a5f00 	cmpcc	sl, r0, lsl #30
    14ec:	68637331 	stmdavs	r3!, {r0, r4, r5, r8, r9, ip, sp, lr}^
    14f0:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
    14f4:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
    14f8:	5a5f0076 	bpl	17c16d8 <__bss_end+0x17b7f94>
    14fc:	65733731 	ldrbvs	r3, [r3, #-1841]!	; 0xfffff8cf
    1500:	61745f74 	cmnvs	r4, r4, ror pc
    1504:	645f6b73 	ldrbvs	r6, [pc], #-2931	; 150c <shift+0x150c>
    1508:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    150c:	6a656e69 	bvs	195ceb8 <__bss_end+0x1953774>
    1510:	69617700 	stmdbvs	r1!, {r8, r9, sl, ip, sp, lr}^
    1514:	5a5f0074 	bpl	17c16ec <__bss_end+0x17b7fa8>
    1518:	746f6e36 	strbtvc	r6, [pc], #-3638	; 1520 <shift+0x1520>
    151c:	6a796669 	bvs	1e5aec8 <__bss_end+0x1e51784>
    1520:	5a5f006a 	bpl	17c16d0 <__bss_end+0x17b7f8c>
    1524:	72657439 	rsbvc	r7, r5, #956301312	; 0x39000000
    1528:	616e696d 	cmnvs	lr, sp, ror #18
    152c:	00696574 	rsbeq	r6, r9, r4, ror r5
    1530:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 147c <shift+0x147c>
    1534:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1538:	6b69746e 	blvs	1a5e6f8 <__bss_end+0x1a54fb4>
    153c:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
    1540:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
    1544:	4f54522d 	svcmi	0x0054522d
    1548:	616d2d53 	cmnvs	sp, r3, asr sp
    154c:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
    1550:	756f732f 	strbvc	r7, [pc, #-815]!	; 1229 <shift+0x1229>
    1554:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    1558:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    155c:	2f62696c 	svccs	0x0062696c
    1560:	2f637273 	svccs	0x00637273
    1564:	66647473 			; <UNDEFINED> instruction: 0x66647473
    1568:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
    156c:	00707063 	rsbseq	r7, r0, r3, rrx
    1570:	6c696146 	stfvse	f6, [r9], #-280	; 0xfffffee8
    1574:	69786500 	ldmdbvs	r8!, {r8, sl, sp, lr}^
    1578:	646f6374 	strbtvs	r6, [pc], #-884	; 1580 <shift+0x1580>
    157c:	5a5f0065 	bpl	17c1718 <__bss_end+0x17b7fd4>
    1580:	65673432 	strbvs	r3, [r7, #-1074]!	; 0xfffffbce
    1584:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
    1588:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    158c:	6f72705f 	svcvs	0x0072705f
    1590:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1594:	756f635f 	strbvc	r6, [pc, #-863]!	; 123d <shift+0x123d>
    1598:	0076746e 	rsbseq	r7, r6, lr, ror #8
    159c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    15a0:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    15a4:	00646c65 	rsbeq	r6, r4, r5, ror #24
    15a8:	6b636974 	blvs	18dbb80 <__bss_end+0x18d243c>
    15ac:	756f635f 	strbvc	r6, [pc, #-863]!	; 1255 <shift+0x1255>
    15b0:	725f746e 	subsvc	r7, pc, #1845493760	; 0x6e000000
    15b4:	69757165 	ldmdbvs	r5!, {r0, r2, r5, r6, r8, ip, sp, lr}^
    15b8:	00646572 	rsbeq	r6, r4, r2, ror r5
    15bc:	65706950 	ldrbvs	r6, [r0, #-2384]!	; 0xfffff6b0
    15c0:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
    15c4:	72505f65 	subsvc	r5, r0, #404	; 0x194
    15c8:	78696665 	stmdavc	r9!, {r0, r2, r5, r6, r9, sl, sp, lr}^
    15cc:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
    15d0:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
    15d4:	00736d61 	rsbseq	r6, r3, r1, ror #26
    15d8:	34315a5f 	ldrtcc	r5, [r1], #-2655	; 0xfffff5a1
    15dc:	5f746567 	svcpl	0x00746567
    15e0:	6b636974 	blvs	18dbbb8 <__bss_end+0x18d2474>
    15e4:	756f635f 	strbvc	r6, [pc, #-863]!	; 128d <shift+0x128d>
    15e8:	0076746e 	rsbseq	r7, r6, lr, ror #8
    15ec:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
    15f0:	682f0070 	stmdavs	pc!, {r4, r5, r6}	; <UNPREDICTABLE>
    15f4:	2f656d6f 	svccs	0x00656d6f
    15f8:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
    15fc:	642f6b69 	strtvs	r6, [pc], #-2921	; 1604 <shift+0x1604>
    1600:	4b2f7665 	blmi	bdef9c <__bss_end+0xbd5858>
    1604:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
    1608:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
    160c:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
    1610:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
    1614:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1618:	622f7365 	eorvs	r7, pc, #-1811939327	; 0x94000001
    161c:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1620:	73694400 	cmnvc	r9, #0, 8
    1624:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    1628:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
    162c:	445f746e 	ldrbmi	r7, [pc], #-1134	; 1634 <shift+0x1634>
    1630:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
    1634:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1638:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
    163c:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    1640:	5f006e6f 	svcpl	0x00006e6f
    1644:	6c63355a 	cfstr64vs	mvdx3, [r3], #-360	; 0xfffffe98
    1648:	6a65736f 	bvs	195e40c <__bss_end+0x1954cc8>
    164c:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1650:	70746567 	rsbsvc	r6, r4, r7, ror #10
    1654:	00766469 	rsbseq	r6, r6, r9, ror #8
    1658:	6d616e66 	stclvs	14, cr6, [r1, #-408]!	; 0xfffffe68
    165c:	6f6e0065 	svcvs	0x006e0065
    1660:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
    1664:	63697400 	cmnvs	r9, #0, 8
    1668:	6f00736b 	svcvs	0x0000736b
    166c:	006e6570 	rsbeq	r6, lr, r0, ror r5
    1670:	70345a5f 	eorsvc	r5, r4, pc, asr sl
    1674:	50657069 	rsbpl	r7, r5, r9, rrx
    1678:	006a634b 	rsbeq	r6, sl, fp, asr #6
    167c:	6165444e 	cmnvs	r5, lr, asr #8
    1680:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    1684:	75535f65 	ldrbvc	r5, [r3, #-3941]	; 0xfffff09b
    1688:	72657362 	rsbvc	r7, r5, #-2013265919	; 0x88000001
    168c:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
    1690:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    1694:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    1698:	6f635f6b 	svcvs	0x00635f6b
    169c:	00746e75 	rsbseq	r6, r4, r5, ror lr
    16a0:	61726170 	cmnvs	r2, r0, ror r1
    16a4:	5a5f006d 	bpl	17c1860 <__bss_end+0x17b811c>
    16a8:	69727735 	ldmdbvs	r2!, {r0, r2, r4, r5, r8, r9, sl, ip, sp, lr}^
    16ac:	506a6574 	rsbpl	r6, sl, r4, ror r5
    16b0:	006a634b 	rsbeq	r6, sl, fp, asr #6
    16b4:	5f746567 	svcpl	0x00746567
    16b8:	6b736174 	blvs	1cd9c90 <__bss_end+0x1cd054c>
    16bc:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    16c0:	745f736b 	ldrbvc	r7, [pc], #-875	; 16c8 <shift+0x16c8>
    16c4:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
    16c8:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    16cc:	6200656e 	andvs	r6, r0, #461373440	; 0x1b800000
    16d0:	735f6675 	cmpvc	pc, #122683392	; 0x7500000
    16d4:	00657a69 	rsbeq	r7, r5, r9, ror #20
    16d8:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
    16dc:	65730065 	ldrbvs	r0, [r3, #-101]!	; 0xffffff9b
    16e0:	61745f74 	cmnvs	r4, r4, ror pc
    16e4:	645f6b73 	ldrbvs	r6, [pc], #-2931	; 16ec <shift+0x16ec>
    16e8:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    16ec:	00656e69 	rsbeq	r6, r5, r9, ror #28
    16f0:	5f746547 	svcpl	0x00746547
    16f4:	61726150 	cmnvs	r2, r0, asr r1
    16f8:	5f00736d 	svcpl	0x0000736d
    16fc:	6c73355a 	cfldr64vs	mvdx3, [r3], #-360	; 0xfffffe98
    1700:	6a706565 	bvs	1c1ac9c <__bss_end+0x1c11558>
    1704:	6547006a 	strbvs	r0, [r7, #-106]	; 0xffffff96
    1708:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
    170c:	6e69616d 	powvsez	f6, f1, #5.0
    1710:	00676e69 	rsbeq	r6, r7, r9, ror #28
    1714:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
    1718:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 11b4 <shift+0x11b4>
    171c:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
    1720:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
    1724:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
    1728:	5f006e6f 	svcpl	0x00006e6f
    172c:	6736325a 			; <UNDEFINED> instruction: 0x6736325a
    1730:	745f7465 	ldrbvc	r7, [pc], #-1125	; 1738 <shift+0x1738>
    1734:	5f6b7361 	svcpl	0x006b7361
    1738:	6b636974 	blvs	18dbd10 <__bss_end+0x18d25cc>
    173c:	6f745f73 	svcvs	0x00745f73
    1740:	6165645f 	cmnvs	r5, pc, asr r4
    1744:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    1748:	4e007665 	cfmadd32mi	mvax3, mvfx7, mvfx0, mvfx5
    174c:	5f495753 	svcpl	0x00495753
    1750:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
    1754:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
    1758:	0065646f 	rsbeq	r6, r5, pc, ror #8
    175c:	756e7277 	strbvc	r7, [lr, #-631]!	; 0xfffffd89
    1760:	5a5f006d 	bpl	17c191c <__bss_end+0x17b81d8>
    1764:	69617734 	stmdbvs	r1!, {r2, r4, r5, r8, r9, sl, ip, sp, lr}^
    1768:	6a6a6a74 	bvs	1a9c140 <__bss_end+0x1a929fc>
    176c:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1770:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
    1774:	36316a6c 	ldrtcc	r6, [r1], -ip, ror #20
    1778:	434f494e 	movtmi	r4, #63822	; 0xf94e
    177c:	4f5f6c74 	svcmi	0x005f6c74
    1780:	61726570 	cmnvs	r2, r0, ror r5
    1784:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1788:	69007650 	stmdbvs	r0, {r4, r6, r9, sl, ip, sp, lr}
    178c:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
    1790:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
    1794:	00746e63 	rsbseq	r6, r4, r3, ror #28
    1798:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
    179c:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
    17a0:	6f6d0065 	svcvs	0x006d0065
    17a4:	62006564 	andvs	r6, r0, #100, 10	; 0x19000000
    17a8:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
    17ac:	5a5f0072 	bpl	17c197c <__bss_end+0x17b8238>
    17b0:	61657234 	cmnvs	r5, r4, lsr r2
    17b4:	63506a64 	cmpvs	r0, #100, 20	; 0x64000
    17b8:	494e006a 	stmdbmi	lr, {r1, r3, r5, r6}^
    17bc:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
    17c0:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    17c4:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    17c8:	72006e6f 	andvc	r6, r0, #1776	; 0x6f0
    17cc:	6f637465 	svcvs	0x00637465
    17d0:	67006564 	strvs	r6, [r0, -r4, ror #10]
    17d4:	615f7465 	cmpvs	pc, r5, ror #8
    17d8:	76697463 	strbtvc	r7, [r9], -r3, ror #8
    17dc:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
    17e0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    17e4:	6f635f73 	svcvs	0x00635f73
    17e8:	00746e75 	rsbseq	r6, r4, r5, ror lr
    17ec:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    17f0:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    17f4:	61657200 	cmnvs	r5, r0, lsl #4
    17f8:	65670064 	strbvs	r0, [r7, #-100]!	; 0xffffff9c
    17fc:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
    1800:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1804:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
    1808:	31634b50 	cmncc	r3, r0, asr fp
    180c:	69464e35 	stmdbvs	r6, {r0, r2, r4, r5, r9, sl, fp, lr}^
    1810:	4f5f656c 	svcmi	0x005f656c
    1814:	5f6e6570 	svcpl	0x006e6570
    1818:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
    181c:	706e6900 	rsbvc	r6, lr, r0, lsl #18
    1820:	64007475 	strvs	r7, [r0], #-1141	; 0xfffffb8b
    1824:	00747365 	rsbseq	r7, r4, r5, ror #6
    1828:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    182c:	656c006f 	strbvs	r0, [ip, #-111]!	; 0xffffff91
    1830:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
    1834:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1838:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    183c:	6976506f 	ldmdbvs	r6!, {r0, r1, r2, r3, r5, r6, ip, lr}^
    1840:	6f682f00 	svcvs	0x00682f00
    1844:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    1848:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    184c:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
    1850:	494b2f76 	stmdbmi	fp, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
    1854:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
    1858:	6d2d534f 	stcvs	3, cr5, [sp, #-316]!	; 0xfffffec4
    185c:	65747361 	ldrbvs	r7, [r4, #-865]!	; 0xfffffc9f
    1860:	6f732f72 	svcvs	0x00732f72
    1864:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1868:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    186c:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    1870:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    1874:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1878:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    187c:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
    1880:	43007070 	movwmi	r7, #112	; 0x70
    1884:	43726168 	cmnmi	r2, #104, 2
    1888:	41766e6f 	cmnmi	r6, pc, ror #28
    188c:	6d007272 	sfmvs	f7, 4, [r0, #-456]	; 0xfffffe38
    1890:	73646d65 	cmnvc	r4, #6464	; 0x1940
    1894:	756f0074 	strbvc	r0, [pc, #-116]!	; 1828 <shift+0x1828>
    1898:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    189c:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    18a0:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    18a4:	4b507970 	blmi	141fe6c <__bss_end+0x1416728>
    18a8:	69765076 	ldmdbvs	r6!, {r1, r2, r4, r5, r6, ip, lr}^
    18ac:	73616200 	cmnvc	r1, #0, 4
    18b0:	656d0065 	strbvs	r0, [sp, #-101]!	; 0xffffff9b
    18b4:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    18b8:	72747300 	rsbsvc	r7, r4, #0, 6
    18bc:	006e656c 	rsbeq	r6, lr, ip, ror #10
    18c0:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    18c4:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    18c8:	4b50706d 	blmi	141da84 <__bss_end+0x1414340>
    18cc:	5f305363 	svcpl	0x00305363
    18d0:	5a5f0069 	bpl	17c1a7c <__bss_end+0x17b8338>
    18d4:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
    18d8:	506e656c 	rsbpl	r6, lr, ip, ror #10
    18dc:	6100634b 	tstvs	r0, fp, asr #6
    18e0:	00696f74 	rsbeq	r6, r9, r4, ror pc
    18e4:	61345a5f 	teqvs	r4, pc, asr sl
    18e8:	50696f74 	rsbpl	r6, r9, r4, ror pc
    18ec:	5f00634b 	svcpl	0x0000634b
    18f0:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    18f4:	70636e72 	rsbvc	r6, r3, r2, ror lr
    18f8:	50635079 	rsbpl	r5, r3, r9, ror r0
    18fc:	0069634b 	rsbeq	r6, r9, fp, asr #6
    1900:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1904:	00706d63 	rsbseq	r6, r0, r3, ror #26
    1908:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    190c:	00797063 	rsbseq	r7, r9, r3, rrx
    1910:	6f6d656d 	svcvs	0x006d656d
    1914:	6d007972 	vstrvs.16	s14, [r0, #-228]	; 0xffffff1c	; <UNPREDICTABLE>
    1918:	72736d65 	rsbsvc	r6, r3, #6464	; 0x1940
    191c:	74690063 	strbtvc	r0, [r9], #-99	; 0xffffff9d
    1920:	5f00616f 	svcpl	0x0000616f
    1924:	7469345a 	strbtvc	r3, [r9], #-1114	; 0xfffffba6
    1928:	506a616f 	rsbpl	r6, sl, pc, ror #2
    192c:	5f006a63 	svcpl	0x00006a63
    1930:	5f6e695f 	svcpl	0x006e695f
    1934:	67726863 	ldrbvs	r6, [r2, -r3, ror #16]!
    1938:	69445400 	stmdbvs	r4, {sl, ip, lr}^
    193c:	616c7073 	smcvs	50947	; 0xc703
    1940:	61505f79 	cmpvs	r0, r9, ror pc
    1944:	74656b63 	strbtvc	r6, [r5], #-2915	; 0xfffff49d
    1948:	6165485f 	cmnvs	r5, pc, asr r8
    194c:	00726564 	rsbseq	r6, r2, r4, ror #10
    1950:	73694454 	cmnvc	r9, #84, 8	; 0x54000000
    1954:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
    1958:	6e6f4e5f 	mcrvs	14, 3, r4, cr15, cr15, {2}
    195c:	61726150 	cmnvs	r2, r0, asr r1
    1960:	7274656d 	rsbsvc	r6, r4, #457179136	; 0x1b400000
    1964:	505f6369 	subspl	r6, pc, r9, ror #6
    1968:	656b6361 	strbvs	r6, [fp, #-865]!	; 0xfffffc9f
    196c:	68740074 	ldmdavs	r4!, {r2, r4, r5, r6}^
    1970:	4f007369 	svcmi	0x00007369
    1974:	5f44454c 	svcpl	0x0044454c
    1978:	746e6f46 	strbtvc	r6, [lr], #-3910	; 0xfffff0ba
    197c:	6665445f 			; <UNDEFINED> instruction: 0x6665445f
    1980:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
    1984:	6c667600 	stclvs	6, cr7, [r6], #-0
    1988:	54007069 	strpl	r7, [r0], #-105	; 0xffffff97
    198c:	70736944 	rsbsvc	r6, r3, r4, asr #18
    1990:	5f79616c 	svcpl	0x0079616c
    1994:	77617244 	strbvc	r7, [r1, -r4, asr #4]!
    1998:	7869505f 	stmdavc	r9!, {r0, r1, r2, r3, r4, r6, ip, lr}^
    199c:	415f6c65 	cmpmi	pc, r5, ror #24
    19a0:	79617272 	stmdbvc	r1!, {r1, r4, r5, r6, r9, ip, sp, lr}^
    19a4:	6361505f 	cmnvs	r1, #95	; 0x5f
    19a8:	0074656b 	rsbseq	r6, r4, fp, ror #10
    19ac:	77617244 	strbvc	r7, [r1, -r4, asr #4]!
    19b0:	7869505f 	stmdavc	r9!, {r0, r1, r2, r3, r4, r6, ip, lr}^
    19b4:	415f6c65 	cmpmi	pc, r5, ror #24
    19b8:	79617272 	stmdbvc	r1!, {r1, r4, r5, r6, r9, ip, sp, lr}^
    19bc:	5f6f545f 	svcpl	0x006f545f
    19c0:	74636552 	strbtvc	r6, [r3], #-1362	; 0xfffffaae
    19c4:	69445400 	stmdbvs	r4, {sl, ip, lr}^
    19c8:	616c7073 	smcvs	50947	; 0xc703
    19cc:	69505f79 	ldmdbvs	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    19d0:	5f6c6578 	svcpl	0x006c6578
    19d4:	63657053 	cmnvs	r5, #83	; 0x53
    19d8:	74617000 	strbtvc	r7, [r1], #-0
    19dc:	44540068 	ldrbmi	r0, [r4], #-104	; 0xffffff98
    19e0:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
    19e4:	505f7961 	subspl	r7, pc, r1, ror #18
    19e8:	6c657869 	stclvs	8, cr7, [r5], #-420	; 0xfffffe5c
    19ec:	6f545f73 	svcvs	0x00545f73
    19f0:	6365525f 	cmnvs	r5, #-268435451	; 0xf0000005
    19f4:	68430074 	stmdavs	r3, {r2, r4, r5, r6}^
    19f8:	455f7261 	ldrbmi	r7, [pc, #-609]	; 179f <shift+0x179f>
    19fc:	4600646e 	strmi	r6, [r0], -lr, ror #8
    1a00:	5f70696c 	svcpl	0x0070696c
    1a04:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    1a08:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
    1a0c:	2f656d6f 	svccs	0x00656d6f
    1a10:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
    1a14:	642f6b69 	strtvs	r6, [pc], #-2921	; 1a1c <shift+0x1a1c>
    1a18:	4b2f7665 	blmi	bdf3b4 <__bss_end+0xbd5c70>
    1a1c:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
    1a20:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
    1a24:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
    1a28:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
    1a2c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1a30:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    1a34:	74756474 	ldrbtvc	r6, [r5], #-1140	; 0xfffffb8c
    1a38:	2f736c69 	svccs	0x00736c69
    1a3c:	2f637273 	svccs	0x00637273
    1a40:	64656c6f 	strbtvs	r6, [r5], #-3183	; 0xfffff391
    1a44:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    1a48:	69445400 	stmdbvs	r4, {sl, ip, lr}^
    1a4c:	616c7073 	smcvs	50947	; 0xc703
    1a50:	6c435f79 	mcrrvs	15, 7, r5, r3, cr9
    1a54:	5f726165 	svcpl	0x00726165
    1a58:	6b636150 	blvs	18d9fa0 <__bss_end+0x18d085c>
    1a5c:	43007465 	movwmi	r7, #1125	; 0x465
    1a60:	5f726168 	svcpl	0x00726168
    1a64:	74646957 	strbtvc	r6, [r4], #-2391	; 0xfffff6a9
    1a68:	4c4f0068 	mcrrmi	0, 6, r0, pc, cr8
    1a6c:	465f4445 	ldrbmi	r4, [pc], -r5, asr #8
    1a70:	00746e6f 	rsbseq	r6, r4, pc, ror #28
    1a74:	7369444e 	cmnvc	r9, #1308622848	; 0x4e000000
    1a78:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
    1a7c:	6d6f435f 	stclvs	3, cr4, [pc, #-380]!	; 1908 <shift+0x1908>
    1a80:	646e616d 	strbtvs	r6, [lr], #-365	; 0xfffffe93
    1a84:	72696600 	rsbvc	r6, r9, #0, 12
    1a88:	44007473 	strmi	r7, [r0], #-1139	; 0xfffffb8d
    1a8c:	5f776172 	svcpl	0x00776172
    1a90:	65786950 	ldrbvs	r6, [r8, #-2384]!	; 0xfffff6b0
    1a94:	72415f6c 	subvc	r5, r1, #108, 30	; 0x1b0
    1a98:	00796172 	rsbseq	r6, r9, r2, ror r1
    1a9c:	61656c63 	cmnvs	r5, r3, ror #24
    1aa0:	74655372 	strbtvc	r5, [r5], #-882	; 0xfffffc8e
    1aa4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1aa8:	4f433331 	svcmi	0x00433331
    1aac:	5f44454c 	svcpl	0x0044454c
    1ab0:	70736944 	rsbsvc	r6, r3, r4, asr #18
    1ab4:	4379616c 	cmnmi	r9, #108, 2
    1ab8:	4b504532 	blmi	1412f88 <__bss_end+0x1409844>
    1abc:	69750063 	ldmdbvs	r5!, {r0, r1, r5, r6}^
    1ac0:	5f38746e 	svcpl	0x0038746e
    1ac4:	68430074 	stmdavs	r3, {r2, r4, r5, r6}^
    1ac8:	485f7261 	ldmdami	pc, {r0, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    1acc:	68676965 	stmdavs	r7!, {r0, r2, r5, r6, r8, fp, sp, lr}^
    1ad0:	65680074 	strbvs	r0, [r8, #-116]!	; 0xffffff8c
    1ad4:	72656461 	rsbvc	r6, r5, #1627389952	; 0x61000000
    1ad8:	61684300 	cmnvs	r8, r0, lsl #6
    1adc:	65425f72 	strbvs	r5, [r2, #-3954]	; 0xfffff08e
    1ae0:	006e6967 	rsbeq	r6, lr, r7, ror #18
    1ae4:	314e5a5f 	cmpcc	lr, pc, asr sl
    1ae8:	4c4f4333 	mcrrmi	3, 3, r4, pc, cr3
    1aec:	445f4445 	ldrbmi	r4, [pc], #-1093	; 1af4 <shift+0x1af4>
    1af0:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
    1af4:	32447961 	subcc	r7, r4, #1589248	; 0x184000
    1af8:	2e007645 	cfmadd32cs	mvax2, mvfx7, mvfx0, mvfx5
    1afc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1b00:	2f2e2e2f 	svccs	0x002e2e2f
    1b04:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1b08:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1b0c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1b10:	2f636367 	svccs	0x00636367
    1b14:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    1b18:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1b1c:	6c2f6d72 	stcvs	13, cr6, [pc], #-456	; 195c <shift+0x195c>
    1b20:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
    1b24:	73636e75 	cmnvc	r3, #1872	; 0x750
    1b28:	2f00532e 	svccs	0x0000532e
    1b2c:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1b30:	63672f64 	cmnvs	r7, #100, 30	; 0x190
    1b34:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    1b38:	6f6e2d6d 	svcvs	0x006e2d6d
    1b3c:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1b40:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1b44:	5662537a 			; <UNDEFINED> instruction: 0x5662537a
    1b48:	672f6e66 	strvs	r6, [pc, -r6, ror #28]!
    1b4c:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    1b50:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1b54:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1b58:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1b5c:	322d382d 	eorcc	r3, sp, #2949120	; 0x2d0000
    1b60:	2d393130 	ldfcss	f3, [r9, #-192]!	; 0xffffff40
    1b64:	622f3371 	eorvs	r3, pc, #-1006632959	; 0xc4000001
    1b68:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1b6c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1b70:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    1b74:	61652d65 	cmnvs	r5, r5, ror #26
    1b78:	612f6962 			; <UNDEFINED> instruction: 0x612f6962
    1b7c:	762f6d72 			; <UNDEFINED> instruction: 0x762f6d72
    1b80:	2f657435 	svccs	0x00657435
    1b84:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1b88:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1b8c:	00636367 	rsbeq	r6, r3, r7, ror #6
    1b90:	20554e47 	subscs	r4, r5, r7, asr #28
    1b94:	32205341 	eorcc	r5, r0, #67108865	; 0x4000001
    1b98:	0034332e 	eorseq	r3, r4, lr, lsr #6
    1b9c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ba0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ba4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1ba8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1bac:	37316178 			; <UNDEFINED> instruction: 0x37316178
    1bb0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1bb4:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1bb8:	61736900 	cmnvs	r3, r0, lsl #18
    1bbc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1bc0:	5f70665f 	svcpl	0x0070665f
    1bc4:	006c6264 	rsbeq	r6, ip, r4, ror #4
    1bc8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1bcc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1bd0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1bd4:	31316d72 	teqcc	r1, r2, ror sp
    1bd8:	736a3633 	cmnvc	sl, #53477376	; 0x3300000
    1bdc:	6d726100 	ldfvse	f6, [r2, #-0]
    1be0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1be4:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    1be8:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1bec:	52415400 	subpl	r5, r1, #0, 8
    1bf0:	5f544547 	svcpl	0x00544547
    1bf4:	5f555043 	svcpl	0x00555043
    1bf8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1bfc:	326d7865 	rsbcc	r7, sp, #6619136	; 0x650000
    1c00:	52410033 	subpl	r0, r1, #51	; 0x33
    1c04:	51455f4d 	cmppl	r5, sp, asr #30
    1c08:	52415400 	subpl	r5, r1, #0, 8
    1c0c:	5f544547 	svcpl	0x00544547
    1c10:	5f555043 	svcpl	0x00555043
    1c14:	316d7261 	cmncc	sp, r1, ror #4
    1c18:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    1c1c:	00736632 	rsbseq	r6, r3, r2, lsr r6
    1c20:	5f617369 	svcpl	0x00617369
    1c24:	5f746962 	svcpl	0x00746962
    1c28:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    1c2c:	41540062 	cmpmi	r4, r2, rrx
    1c30:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c34:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c38:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1c3c:	61786574 	cmnvs	r8, r4, ror r5
    1c40:	6f633735 	svcvs	0x00633735
    1c44:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1c48:	00333561 	eorseq	r3, r3, r1, ror #10
    1c4c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1c50:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1c54:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    1c58:	5341425f 	movtpl	r4, #4703	; 0x125f
    1c5c:	41540045 	cmpmi	r4, r5, asr #32
    1c60:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c64:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c68:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1c6c:	00303138 	eorseq	r3, r0, r8, lsr r1
    1c70:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c74:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c78:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1c7c:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    1c80:	52410031 	subpl	r0, r1, #49	; 0x31
    1c84:	43505f4d 	cmpmi	r0, #308	; 0x134
    1c88:	41415f53 	cmpmi	r1, r3, asr pc
    1c8c:	5f534350 	svcpl	0x00534350
    1c90:	4d4d5749 	stclmi	7, cr5, [sp, #-292]	; 0xfffffedc
    1c94:	54005458 	strpl	r5, [r0], #-1112	; 0xfffffba8
    1c98:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c9c:	50435f54 	subpl	r5, r3, r4, asr pc
    1ca0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1ca4:	6964376d 	stmdbvs	r4!, {r0, r2, r3, r5, r6, r8, r9, sl, ip, sp}^
    1ca8:	53414200 	movtpl	r4, #4608	; 0x1200
    1cac:	52415f45 	subpl	r5, r1, #276	; 0x114
    1cb0:	325f4843 	subscc	r4, pc, #4390912	; 0x430000
    1cb4:	53414200 	movtpl	r4, #4608	; 0x1200
    1cb8:	52415f45 	subpl	r5, r1, #276	; 0x114
    1cbc:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    1cc0:	52415400 	subpl	r5, r1, #0, 8
    1cc4:	5f544547 	svcpl	0x00544547
    1cc8:	5f555043 	svcpl	0x00555043
    1ccc:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1cd0:	42006d64 	andmi	r6, r0, #100, 26	; 0x1900
    1cd4:	5f455341 	svcpl	0x00455341
    1cd8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1cdc:	4200355f 	andmi	r3, r0, #398458880	; 0x17c00000
    1ce0:	5f455341 	svcpl	0x00455341
    1ce4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1ce8:	4200365f 	andmi	r3, r0, #99614720	; 0x5f00000
    1cec:	5f455341 	svcpl	0x00455341
    1cf0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1cf4:	5400375f 	strpl	r3, [r0], #-1887	; 0xfffff8a1
    1cf8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1cfc:	50435f54 	subpl	r5, r3, r4, asr pc
    1d00:	73785f55 	cmnvc	r8, #340	; 0x154
    1d04:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1d08:	52415400 	subpl	r5, r1, #0, 8
    1d0c:	5f544547 	svcpl	0x00544547
    1d10:	5f555043 	svcpl	0x00555043
    1d14:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1d18:	73653634 	cmnvc	r5, #52, 12	; 0x3400000
    1d1c:	52415400 	subpl	r5, r1, #0, 8
    1d20:	5f544547 	svcpl	0x00544547
    1d24:	5f555043 	svcpl	0x00555043
    1d28:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1d2c:	336d7865 	cmncc	sp, #6619136	; 0x650000
    1d30:	41540033 	cmpmi	r4, r3, lsr r0
    1d34:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d38:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d3c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1d40:	6d647437 	cfstrdvs	mvd7, [r4, #-220]!	; 0xffffff24
    1d44:	73690069 	cmnvc	r9, #105	; 0x69
    1d48:	6f6e5f61 	svcvs	0x006e5f61
    1d4c:	00746962 	rsbseq	r6, r4, r2, ror #18
    1d50:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d54:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d58:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1d5c:	31316d72 	teqcc	r1, r2, ror sp
    1d60:	7a6a3637 	bvc	1a8f644 <__bss_end+0x1a85f00>
    1d64:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1d68:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1d6c:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1d70:	32767066 	rsbscc	r7, r6, #102	; 0x66
    1d74:	4d524100 	ldfmie	f4, [r2, #-0]
    1d78:	5343505f 	movtpl	r5, #12383	; 0x305f
    1d7c:	4b4e555f 	blmi	1397300 <__bss_end+0x138dbbc>
    1d80:	4e574f4e 	cdpmi	15, 5, cr4, cr7, cr14, {2}
    1d84:	52415400 	subpl	r5, r1, #0, 8
    1d88:	5f544547 	svcpl	0x00544547
    1d8c:	5f555043 	svcpl	0x00555043
    1d90:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1d94:	41420065 	cmpmi	r2, r5, rrx
    1d98:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1d9c:	5f484352 	svcpl	0x00484352
    1da0:	4a455435 	bmi	1156e7c <__bss_end+0x114d738>
    1da4:	6d726100 	ldfvse	f6, [r2, #-0]
    1da8:	6663635f 			; <UNDEFINED> instruction: 0x6663635f
    1dac:	735f6d73 	cmpvc	pc, #7360	; 0x1cc0
    1db0:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
    1db4:	736e7500 	cmnvc	lr, #0, 10
    1db8:	5f636570 	svcpl	0x00636570
    1dbc:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1dc0:	0073676e 	rsbseq	r6, r3, lr, ror #14
    1dc4:	5f617369 	svcpl	0x00617369
    1dc8:	5f746962 	svcpl	0x00746962
    1dcc:	00636573 	rsbeq	r6, r3, r3, ror r5
    1dd0:	6c635f5f 	stclvs	15, cr5, [r3], #-380	; 0xfffffe84
    1dd4:	61745f7a 	cmnvs	r4, sl, ror pc
    1dd8:	52410062 	subpl	r0, r1, #98	; 0x62
    1ddc:	43565f4d 	cmpmi	r6, #308	; 0x134
    1de0:	6d726100 	ldfvse	f6, [r2, #-0]
    1de4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1de8:	73785f68 	cmnvc	r8, #104, 30	; 0x1a0
    1dec:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1df0:	4d524100 	ldfmie	f4, [r2, #-0]
    1df4:	00454c5f 	subeq	r4, r5, pc, asr ip
    1df8:	5f4d5241 	svcpl	0x004d5241
    1dfc:	41005356 	tstmi	r0, r6, asr r3
    1e00:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    1e04:	72610045 	rsbvc	r0, r1, #69	; 0x45
    1e08:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1e0c:	735f656e 	cmpvc	pc, #461373440	; 0x1b800000
    1e10:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    1e14:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    1e18:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 1e20 <shift+0x1e20>
    1e1c:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    1e20:	6f6c6620 	svcvs	0x006c6620
    1e24:	54007461 	strpl	r7, [r0], #-1121	; 0xfffffb9f
    1e28:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e2c:	50435f54 	subpl	r5, r3, r4, asr pc
    1e30:	6f635f55 	svcvs	0x00635f55
    1e34:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1e38:	00353161 	eorseq	r3, r5, r1, ror #2
    1e3c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1e40:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1e44:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1e48:	36323761 	ldrtcc	r3, [r2], -r1, ror #14
    1e4c:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    1e50:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e54:	50435f54 	subpl	r5, r3, r4, asr pc
    1e58:	6f635f55 	svcvs	0x00635f55
    1e5c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1e60:	00373161 	eorseq	r3, r7, r1, ror #2
    1e64:	5f4d5241 	svcpl	0x004d5241
    1e68:	41005447 	tstmi	r0, r7, asr #8
    1e6c:	4c5f4d52 	mrrcmi	13, 5, r4, pc, cr2	; <UNPREDICTABLE>
    1e70:	2e2e0054 	mcrcs	0, 1, r0, cr14, cr4, {2}
    1e74:	2f2e2e2f 	svccs	0x002e2e2f
    1e78:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1e7c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1e80:	2f2e2e2f 	svccs	0x002e2e2f
    1e84:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1e88:	6c2f6363 	stcvs	3, cr6, [pc], #-396	; 1d04 <shift+0x1d04>
    1e8c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1e90:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    1e94:	52415400 	subpl	r5, r1, #0, 8
    1e98:	5f544547 	svcpl	0x00544547
    1e9c:	5f555043 	svcpl	0x00555043
    1ea0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1ea4:	34727865 	ldrbtcc	r7, [r2], #-2149	; 0xfffff79b
    1ea8:	41540066 	cmpmi	r4, r6, rrx
    1eac:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1eb0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1eb4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1eb8:	00303239 	eorseq	r3, r0, r9, lsr r2
    1ebc:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1ec0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1ec4:	45375f48 	ldrmi	r5, [r7, #-3912]!	; 0xfffff0b8
    1ec8:	4154004d 	cmpmi	r4, sp, asr #32
    1ecc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ed0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ed4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1ed8:	61786574 	cmnvs	r8, r4, ror r5
    1edc:	68003231 	stmdavs	r0, {r0, r4, r5, r9, ip, sp}
    1ee0:	76687361 	strbtvc	r7, [r8], -r1, ror #6
    1ee4:	745f6c61 	ldrbvc	r6, [pc], #-3169	; 1eec <shift+0x1eec>
    1ee8:	53414200 	movtpl	r4, #4608	; 0x1200
    1eec:	52415f45 	subpl	r5, r1, #276	; 0x114
    1ef0:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1ef4:	69005a4b 	stmdbvs	r0, {r0, r1, r3, r6, r9, fp, ip, lr}
    1ef8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1efc:	00737469 	rsbseq	r7, r3, r9, ror #8
    1f00:	5f6d7261 	svcpl	0x006d7261
    1f04:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1f08:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1f0c:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
    1f10:	61007669 	tstvs	r0, r9, ror #12
    1f14:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    1f18:	645f7570 	ldrbvs	r7, [pc], #-1392	; 1f20 <shift+0x1f20>
    1f1c:	00637365 	rsbeq	r7, r3, r5, ror #6
    1f20:	5f617369 	svcpl	0x00617369
    1f24:	5f746962 	svcpl	0x00746962
    1f28:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1f2c:	4d524100 	ldfmie	f4, [r2, #-0]
    1f30:	0049485f 	subeq	r4, r9, pc, asr r8
    1f34:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f38:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f3c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1f40:	00326d72 	eorseq	r6, r2, r2, ror sp
    1f44:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f48:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f4c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1f50:	00336d72 	eorseq	r6, r3, r2, ror sp
    1f54:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f58:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f5c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1f60:	31376d72 	teqcc	r7, r2, ror sp
    1f64:	54003030 	strpl	r3, [r0], #-48	; 0xffffffd0
    1f68:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f6c:	50435f54 	subpl	r5, r3, r4, asr pc
    1f70:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1f74:	5400366d 	strpl	r3, [r0], #-1645	; 0xfffff993
    1f78:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f7c:	50435f54 	subpl	r5, r3, r4, asr pc
    1f80:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1f84:	5400376d 	strpl	r3, [r0], #-1901	; 0xfffff893
    1f88:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f8c:	50435f54 	subpl	r5, r3, r4, asr pc
    1f90:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1f94:	5400386d 	strpl	r3, [r0], #-2157	; 0xfffff793
    1f98:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f9c:	50435f54 	subpl	r5, r3, r4, asr pc
    1fa0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1fa4:	5400396d 	strpl	r3, [r0], #-2413	; 0xfffff693
    1fa8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1fac:	50435f54 	subpl	r5, r3, r4, asr pc
    1fb0:	61665f55 	cmnvs	r6, r5, asr pc
    1fb4:	00363236 	eorseq	r3, r6, r6, lsr r2
    1fb8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1fbc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1fc0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1fc4:	6e5f6d72 	mrcvs	13, 2, r6, cr15, cr2, {3}
    1fc8:	00656e6f 	rsbeq	r6, r5, pc, ror #28
    1fcc:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    1fd0:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
    1fd4:	6e752067 	cdpvs	0, 7, cr2, cr5, cr7, {3}
    1fd8:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    1fdc:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
    1fe0:	6100746e 	tstvs	r0, lr, ror #8
    1fe4:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1fe8:	5f686372 	svcpl	0x00686372
    1fec:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    1ff0:	52415400 	subpl	r5, r1, #0, 8
    1ff4:	5f544547 	svcpl	0x00544547
    1ff8:	5f555043 	svcpl	0x00555043
    1ffc:	366d7261 	strbtcc	r7, [sp], -r1, ror #4
    2000:	54003031 	strpl	r3, [r0], #-49	; 0xffffffcf
    2004:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2008:	50435f54 	subpl	r5, r3, r4, asr pc
    200c:	6f635f55 	svcvs	0x00635f55
    2010:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2014:	5400346d 	strpl	r3, [r0], #-1133	; 0xfffffb93
    2018:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    201c:	50435f54 	subpl	r5, r3, r4, asr pc
    2020:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2024:	6530316d 	ldrvs	r3, [r0, #-365]!	; 0xfffffe93
    2028:	52415400 	subpl	r5, r1, #0, 8
    202c:	5f544547 	svcpl	0x00544547
    2030:	5f555043 	svcpl	0x00555043
    2034:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2038:	376d7865 	strbcc	r7, [sp, -r5, ror #16]!
    203c:	52415400 	subpl	r5, r1, #0, 8
    2040:	5f544547 	svcpl	0x00544547
    2044:	5f555043 	svcpl	0x00555043
    2048:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    204c:	66303035 			; <UNDEFINED> instruction: 0x66303035
    2050:	41540065 	cmpmi	r4, r5, rrx
    2054:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2058:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    205c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2060:	63303137 	teqvs	r0, #-1073741811	; 0xc000000d
    2064:	6d726100 	ldfvse	f6, [r2, #-0]
    2068:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    206c:	6f635f64 	svcvs	0x00635f64
    2070:	41006564 	tstmi	r0, r4, ror #10
    2074:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    2078:	415f5343 	cmpmi	pc, r3, asr #6
    207c:	53435041 	movtpl	r5, #12353	; 0x3041
    2080:	61736900 	cmnvs	r3, r0, lsl #18
    2084:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2088:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    208c:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
    2090:	53414200 	movtpl	r4, #4608	; 0x1200
    2094:	52415f45 	subpl	r5, r1, #276	; 0x114
    2098:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    209c:	4154004d 	cmpmi	r4, sp, asr #32
    20a0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    20a4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    20a8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    20ac:	74303137 	ldrtvc	r3, [r0], #-311	; 0xfffffec9
    20b0:	6d726100 	ldfvse	f6, [r2, #-0]
    20b4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    20b8:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    20bc:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    20c0:	73690032 	cmnvc	r9, #50	; 0x32
    20c4:	756e5f61 	strbvc	r5, [lr, #-3937]!	; 0xfffff09f
    20c8:	69625f6d 	stmdbvs	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    20cc:	54007374 	strpl	r7, [r0], #-884	; 0xfffffc8c
    20d0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    20d4:	50435f54 	subpl	r5, r3, r4, asr pc
    20d8:	6f635f55 	svcvs	0x00635f55
    20dc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    20e0:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    20e4:	6d737375 	ldclvs	3, cr7, [r3, #-468]!	; 0xfffffe2c
    20e8:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    20ec:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    20f0:	00796c70 	rsbseq	r6, r9, r0, ror ip
    20f4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20f8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20fc:	655f5550 	ldrbvs	r5, [pc, #-1360]	; 1bb4 <shift+0x1bb4>
    2100:	6f6e7978 	svcvs	0x006e7978
    2104:	00316d73 	eorseq	r6, r1, r3, ror sp
    2108:	47524154 			; <UNDEFINED> instruction: 0x47524154
    210c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2110:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2114:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2118:	32357278 	eorscc	r7, r5, #120, 4	; 0x80000007
    211c:	61736900 	cmnvs	r3, r0, lsl #18
    2120:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2124:	6964745f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
    2128:	72700076 	rsbsvc	r0, r0, #118	; 0x76
    212c:	72656665 	rsbvc	r6, r5, #105906176	; 0x6500000
    2130:	6f656e5f 	svcvs	0x00656e5f
    2134:	6f665f6e 	svcvs	0x00665f6e
    2138:	34365f72 	ldrtcc	r5, [r6], #-3954	; 0xfffff08e
    213c:	73746962 	cmnvc	r4, #1605632	; 0x188000
    2140:	61736900 	cmnvs	r3, r0, lsl #18
    2144:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2148:	3170665f 	cmncc	r0, pc, asr r6
    214c:	6c6d6636 	stclvs	6, cr6, [sp], #-216	; 0xffffff28
    2150:	52415400 	subpl	r5, r1, #0, 8
    2154:	5f544547 	svcpl	0x00544547
    2158:	5f555043 	svcpl	0x00555043
    215c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2160:	33617865 	cmncc	r1, #6619136	; 0x650000
    2164:	41540032 	cmpmi	r4, r2, lsr r0
    2168:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    216c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2170:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2174:	00303236 	eorseq	r3, r0, r6, lsr r2
    2178:	5f617369 	svcpl	0x00617369
    217c:	5f746962 	svcpl	0x00746962
    2180:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    2184:	766e6f63 	strbtvc	r6, [lr], -r3, ror #30
    2188:	736e7500 	cmnvc	lr, #0, 10
    218c:	76636570 			; <UNDEFINED> instruction: 0x76636570
    2190:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    2194:	73676e69 	cmnvc	r7, #1680	; 0x690
    2198:	52415400 	subpl	r5, r1, #0, 8
    219c:	5f544547 	svcpl	0x00544547
    21a0:	5f555043 	svcpl	0x00555043
    21a4:	316d7261 	cmncc	sp, r1, ror #4
    21a8:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    21ac:	54007332 	strpl	r7, [r0], #-818	; 0xfffffcce
    21b0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21b4:	50435f54 	subpl	r5, r3, r4, asr pc
    21b8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    21bc:	3230316d 	eorscc	r3, r0, #1073741851	; 0x4000001b
    21c0:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    21c4:	6d726100 	ldfvse	f6, [r2, #-0]
    21c8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    21cc:	006d3368 	rsbeq	r3, sp, r8, ror #6
    21d0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    21d4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    21d8:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    21dc:	36303661 	ldrtcc	r3, [r0], -r1, ror #12
    21e0:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    21e4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21e8:	50435f54 	subpl	r5, r3, r4, asr pc
    21ec:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    21f0:	3632396d 	ldrtcc	r3, [r2], -sp, ror #18
    21f4:	00736a65 	rsbseq	r6, r3, r5, ror #20
    21f8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    21fc:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2200:	54345f48 	ldrtpl	r5, [r4], #-3912	; 0xfffff0b8
    2204:	61736900 	cmnvs	r3, r0, lsl #18
    2208:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    220c:	7972635f 	ldmdbvc	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
    2210:	006f7470 	rsbeq	r7, pc, r0, ror r4	; <UNPREDICTABLE>
    2214:	5f6d7261 	svcpl	0x006d7261
    2218:	73676572 	cmnvc	r7, #478150656	; 0x1c800000
    221c:	5f6e695f 	svcpl	0x006e695f
    2220:	75716573 	ldrbvc	r6, [r1, #-1395]!	; 0xfffffa8d
    2224:	65636e65 	strbvs	r6, [r3, #-3685]!	; 0xfffff19b
    2228:	53414200 	movtpl	r4, #4608	; 0x1200
    222c:	52415f45 	subpl	r5, r1, #276	; 0x114
    2230:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 19f5 <shift+0x19f5>
    2234:	54004554 	strpl	r4, [r0], #-1364	; 0xfffffaac
    2238:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    223c:	50435f54 	subpl	r5, r3, r4, asr pc
    2240:	70655f55 	rsbvc	r5, r5, r5, asr pc
    2244:	32313339 	eorscc	r3, r1, #-469762048	; 0xe4000000
    2248:	61736900 	cmnvs	r3, r0, lsl #18
    224c:	6165665f 	cmnvs	r5, pc, asr r6
    2250:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    2254:	61736900 	cmnvs	r3, r0, lsl #18
    2258:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    225c:	616d735f 	cmnvs	sp, pc, asr r3
    2260:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    2264:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    2268:	616c5f6d 	cmnvs	ip, sp, ror #30
    226c:	6f5f676e 	svcvs	0x005f676e
    2270:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
    2274:	626f5f74 	rsbvs	r5, pc, #116, 30	; 0x1d0
    2278:	7463656a 	strbtvc	r6, [r3], #-1386	; 0xfffffa96
    227c:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    2280:	75626972 	strbvc	r6, [r2, #-2418]!	; 0xfffff68e
    2284:	5f736574 	svcpl	0x00736574
    2288:	6b6f6f68 	blvs	1bde030 <__bss_end+0x1bd48ec>
    228c:	61736900 	cmnvs	r3, r0, lsl #18
    2290:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2294:	5f70665f 	svcpl	0x0070665f
    2298:	00323364 	eorseq	r3, r2, r4, ror #6
    229c:	5f4d5241 	svcpl	0x004d5241
    22a0:	6900454e 	stmdbvs	r0, {r1, r2, r3, r6, r8, sl, lr}
    22a4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    22a8:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
    22ac:	54003865 	strpl	r3, [r0], #-2149	; 0xfffff79b
    22b0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    22b4:	50435f54 	subpl	r5, r3, r4, asr pc
    22b8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    22bc:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    22c0:	737a6a36 	cmnvc	sl, #221184	; 0x36000
    22c4:	53414200 	movtpl	r4, #4608	; 0x1200
    22c8:	52415f45 	subpl	r5, r1, #276	; 0x114
    22cc:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 1a91 <shift+0x1a91>
    22d0:	73690045 	cmnvc	r9, #69	; 0x45
    22d4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    22d8:	64615f74 	strbtvs	r5, [r1], #-3956	; 0xfffff08c
    22dc:	70007669 	andvc	r7, r0, r9, ror #12
    22e0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    22e4:	726f7373 	rsbvc	r7, pc, #-872415231	; 0xcc000001
    22e8:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    22ec:	6c610065 	stclvs	0, cr0, [r1], #-404	; 0xfffffe6c
    22f0:	70665f6c 	rsbvc	r5, r6, ip, ror #30
    22f4:	61007375 	tstvs	r0, r5, ror r3
    22f8:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    22fc:	42007363 	andmi	r7, r0, #-1946157055	; 0x8c000001
    2300:	5f455341 	svcpl	0x00455341
    2304:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2308:	0054355f 	subseq	r3, r4, pc, asr r5
    230c:	5f6d7261 	svcpl	0x006d7261
    2310:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2314:	54007434 	strpl	r7, [r0], #-1076	; 0xfffffbcc
    2318:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    231c:	50435f54 	subpl	r5, r3, r4, asr pc
    2320:	6f635f55 	svcvs	0x00635f55
    2324:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2328:	63353161 	teqvs	r5, #1073741848	; 0x40000018
    232c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2330:	00376178 	eorseq	r6, r7, r8, ror r1
    2334:	5f6d7261 	svcpl	0x006d7261
    2338:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    233c:	7562775f 	strbvc	r7, [r2, #-1887]!	; 0xfffff8a1
    2340:	74680066 	strbtvc	r0, [r8], #-102	; 0xffffff9a
    2344:	685f6261 	ldmdavs	pc, {r0, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    2348:	00687361 	rsbeq	r7, r8, r1, ror #6
    234c:	5f617369 	svcpl	0x00617369
    2350:	5f746962 	svcpl	0x00746962
    2354:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    2358:	6f6e5f6b 	svcvs	0x006e5f6b
    235c:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 21e8 <shift+0x21e8>
    2360:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    2364:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    2368:	52415400 	subpl	r5, r1, #0, 8
    236c:	5f544547 	svcpl	0x00544547
    2370:	5f555043 	svcpl	0x00555043
    2374:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2378:	306d7865 	rsbcc	r7, sp, r5, ror #16
    237c:	52415400 	subpl	r5, r1, #0, 8
    2380:	5f544547 	svcpl	0x00544547
    2384:	5f555043 	svcpl	0x00555043
    2388:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    238c:	316d7865 	cmncc	sp, r5, ror #16
    2390:	52415400 	subpl	r5, r1, #0, 8
    2394:	5f544547 	svcpl	0x00544547
    2398:	5f555043 	svcpl	0x00555043
    239c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    23a0:	336d7865 	cmncc	sp, #6619136	; 0x650000
    23a4:	61736900 	cmnvs	r3, r0, lsl #18
    23a8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    23ac:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    23b0:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    23b4:	6d726100 	ldfvse	f6, [r2, #-0]
    23b8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    23bc:	616e5f68 	cmnvs	lr, r8, ror #30
    23c0:	6900656d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, sl, sp, lr}
    23c4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    23c8:	615f7469 	cmpvs	pc, r9, ror #8
    23cc:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    23d0:	6900335f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp}
    23d4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    23d8:	615f7469 	cmpvs	pc, r9, ror #8
    23dc:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    23e0:	5400345f 	strpl	r3, [r0], #-1119	; 0xfffffba1
    23e4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    23e8:	50435f54 	subpl	r5, r3, r4, asr pc
    23ec:	6f635f55 	svcvs	0x00635f55
    23f0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    23f4:	00333561 	eorseq	r3, r3, r1, ror #10
    23f8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    23fc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2400:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2404:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2408:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    240c:	52415400 	subpl	r5, r1, #0, 8
    2410:	5f544547 	svcpl	0x00544547
    2414:	5f555043 	svcpl	0x00555043
    2418:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    241c:	00696d64 	rsbeq	r6, r9, r4, ror #26
    2420:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2424:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2428:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 22f0 <shift+0x22f0>
    242c:	726f6370 	rsbvc	r6, pc, #112, 6	; 0xc0000001
    2430:	73690065 	cmnvc	r9, #101	; 0x65
    2434:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2438:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    243c:	6d33766d 	ldcvs	6, cr7, [r3, #-436]!	; 0xfffffe4c
    2440:	6d726100 	ldfvse	f6, [r2, #-0]
    2444:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2448:	6f6e5f68 	svcvs	0x006e5f68
    244c:	61006d74 	tstvs	r0, r4, ror sp
    2450:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2454:	35686372 	strbcc	r6, [r8, #-882]!	; 0xfffffc8e
    2458:	41540065 	cmpmi	r4, r5, rrx
    245c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2460:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2464:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2468:	30323031 	eorscc	r3, r2, r1, lsr r0
    246c:	41420065 	cmpmi	r2, r5, rrx
    2470:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2474:	5f484352 	svcpl	0x00484352
    2478:	54004a36 	strpl	r4, [r0], #-2614	; 0xfffff5ca
    247c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2480:	50435f54 	subpl	r5, r3, r4, asr pc
    2484:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2488:	3836396d 	ldmdacc	r6!, {r0, r2, r3, r5, r6, r8, fp, ip, sp}
    248c:	54007365 	strpl	r7, [r0], #-869	; 0xfffffc9b
    2490:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2494:	50435f54 	subpl	r5, r3, r4, asr pc
    2498:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    249c:	3034376d 	eorscc	r3, r4, sp, ror #14
    24a0:	41420074 	hvcmi	8196	; 0x2004
    24a4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    24a8:	5f484352 	svcpl	0x00484352
    24ac:	69004d36 	stmdbvs	r0, {r1, r2, r4, r5, r8, sl, fp, lr}
    24b0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    24b4:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    24b8:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    24bc:	41540074 	cmpmi	r4, r4, ror r0
    24c0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    24c4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    24c8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    24cc:	00303037 	eorseq	r3, r0, r7, lsr r0
    24d0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    24d4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    24d8:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    24dc:	31316d72 	teqcc	r1, r2, ror sp
    24e0:	666a3633 			; <UNDEFINED> instruction: 0x666a3633
    24e4:	52410073 	subpl	r0, r1, #115	; 0x73
    24e8:	534c5f4d 	movtpl	r5, #53069	; 0xcf4d
    24ec:	52415400 	subpl	r5, r1, #0, 8
    24f0:	5f544547 	svcpl	0x00544547
    24f4:	5f555043 	svcpl	0x00555043
    24f8:	316d7261 	cmncc	sp, r1, ror #4
    24fc:	74303230 	ldrtvc	r3, [r0], #-560	; 0xfffffdd0
    2500:	53414200 	movtpl	r4, #4608	; 0x1200
    2504:	52415f45 	subpl	r5, r1, #276	; 0x114
    2508:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    250c:	4154005a 	cmpmi	r4, sl, asr r0
    2510:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2514:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2518:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    251c:	61786574 	cmnvs	r8, r4, ror r5
    2520:	6f633537 	svcvs	0x00633537
    2524:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2528:	00353561 	eorseq	r3, r5, r1, ror #10
    252c:	5f4d5241 	svcpl	0x004d5241
    2530:	5f534350 	svcpl	0x00534350
    2534:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    2538:	46565f53 	usaxmi	r5, r6, r3
    253c:	41540050 	cmpmi	r4, r0, asr r0
    2540:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2544:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2548:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    254c:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    2550:	61736900 	cmnvs	r3, r0, lsl #18
    2554:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2558:	6f656e5f 	svcvs	0x00656e5f
    255c:	7261006e 	rsbvc	r0, r1, #110	; 0x6e
    2560:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    2564:	74615f75 	strbtvc	r5, [r1], #-3957	; 0xfffff08b
    2568:	69007274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp, lr}
    256c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2570:	615f7469 	cmpvs	pc, r9, ror #8
    2574:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    2578:	54006d65 	strpl	r6, [r0], #-3429	; 0xfffff29b
    257c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2580:	50435f54 	subpl	r5, r3, r4, asr pc
    2584:	61665f55 	cmnvs	r6, r5, asr pc
    2588:	74363236 	ldrtvc	r3, [r6], #-566	; 0xfffffdca
    258c:	41540065 	cmpmi	r4, r5, rrx
    2590:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2594:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2598:	72616d5f 	rsbvc	r6, r1, #6080	; 0x17c0
    259c:	6c6c6576 	cfstr64vs	mvdx6, [ip], #-472	; 0xfffffe28
    25a0:	346a705f 	strbtcc	r7, [sl], #-95	; 0xffffffa1
    25a4:	61746800 	cmnvs	r4, r0, lsl #16
    25a8:	61685f62 	cmnvs	r8, r2, ror #30
    25ac:	705f6873 	subsvc	r6, pc, r3, ror r8	; <UNPREDICTABLE>
    25b0:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    25b4:	54007265 	strpl	r7, [r0], #-613	; 0xfffffd9b
    25b8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    25bc:	50435f54 	subpl	r5, r3, r4, asr pc
    25c0:	6f635f55 	svcvs	0x00635f55
    25c4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    25c8:	00353361 	eorseq	r3, r5, r1, ror #6
    25cc:	5f6d7261 	svcpl	0x006d7261
    25d0:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    25d4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    25d8:	5f786574 	svcpl	0x00786574
    25dc:	69003961 	stmdbvs	r0, {r0, r5, r6, r8, fp, ip, sp}
    25e0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    25e4:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    25e8:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    25ec:	54003274 	strpl	r3, [r0], #-628	; 0xfffffd8c
    25f0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    25f4:	50435f54 	subpl	r5, r3, r4, asr pc
    25f8:	6f635f55 	svcvs	0x00635f55
    25fc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2600:	63323761 	teqvs	r2, #25427968	; 0x1840000
    2604:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2608:	33356178 	teqcc	r5, #120, 2
    260c:	61736900 	cmnvs	r3, r0, lsl #18
    2610:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2614:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    2618:	0032626d 	eorseq	r6, r2, sp, ror #4
    261c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2620:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2624:	41375f48 	teqmi	r7, r8, asr #30
    2628:	61736900 	cmnvs	r3, r0, lsl #18
    262c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2630:	746f645f 	strbtvc	r6, [pc], #-1119	; 2638 <shift+0x2638>
    2634:	646f7270 	strbtvs	r7, [pc], #-624	; 263c <shift+0x263c>
    2638:	53414200 	movtpl	r4, #4608	; 0x1200
    263c:	52415f45 	subpl	r5, r1, #276	; 0x114
    2640:	305f4843 	subscc	r4, pc, r3, asr #16
    2644:	6d726100 	ldfvse	f6, [r2, #-0]
    2648:	3170665f 	cmncc	r0, pc, asr r6
    264c:	79745f36 	ldmdbvc	r4!, {r1, r2, r4, r5, r8, r9, sl, fp, ip, lr}^
    2650:	6e5f6570 	mrcvs	5, 2, r6, cr15, cr0, {3}
    2654:	0065646f 	rsbeq	r6, r5, pc, ror #8
    2658:	5f4d5241 	svcpl	0x004d5241
    265c:	6100494d 	tstvs	r0, sp, asr #18
    2660:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2664:	36686372 			; <UNDEFINED> instruction: 0x36686372
    2668:	7261006b 	rsbvc	r0, r1, #107	; 0x6b
    266c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2670:	6d366863 	ldcvs	8, cr6, [r6, #-396]!	; 0xfffffe74
    2674:	53414200 	movtpl	r4, #4608	; 0x1200
    2678:	52415f45 	subpl	r5, r1, #276	; 0x114
    267c:	345f4843 	ldrbcc	r4, [pc], #-2115	; 2684 <shift+0x2684>
    2680:	53414200 	movtpl	r4, #4608	; 0x1200
    2684:	52415f45 	subpl	r5, r1, #276	; 0x114
    2688:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    268c:	5f5f0052 	svcpl	0x005f0052
    2690:	63706f70 	cmnvs	r0, #112, 30	; 0x1c0
    2694:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    2698:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    269c:	61736900 	cmnvs	r3, r0, lsl #18
    26a0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    26a4:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    26a8:	41540065 	cmpmi	r4, r5, rrx
    26ac:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    26b0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    26b4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    26b8:	61786574 	cmnvs	r8, r4, ror r5
    26bc:	54003337 	strpl	r3, [r0], #-823	; 0xfffffcc9
    26c0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    26c4:	50435f54 	subpl	r5, r3, r4, asr pc
    26c8:	65675f55 	strbvs	r5, [r7, #-3925]!	; 0xfffff0ab
    26cc:	6972656e 	ldmdbvs	r2!, {r1, r2, r3, r5, r6, r8, sl, sp, lr}^
    26d0:	61377663 	teqvs	r7, r3, ror #12
    26d4:	61736900 	cmnvs	r3, r0, lsl #18
    26d8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    26dc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    26e0:	00653576 	rsbeq	r3, r5, r6, ror r5
    26e4:	5f6d7261 	svcpl	0x006d7261
    26e8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    26ec:	5f6f6e5f 	svcpl	0x006f6e5f
    26f0:	616c6f76 	smcvs	50934	; 0xc6f6
    26f4:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    26f8:	0065635f 	rsbeq	r6, r5, pc, asr r3
    26fc:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2700:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2704:	41385f48 	teqmi	r8, r8, asr #30
    2708:	52415400 	subpl	r5, r1, #0, 8
    270c:	5f544547 	svcpl	0x00544547
    2710:	5f555043 	svcpl	0x00555043
    2714:	316d7261 	cmncc	sp, r1, ror #4
    2718:	65323230 	ldrvs	r3, [r2, #-560]!	; 0xfffffdd0
    271c:	53414200 	movtpl	r4, #4608	; 0x1200
    2720:	52415f45 	subpl	r5, r1, #276	; 0x114
    2724:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    2728:	41540052 	cmpmi	r4, r2, asr r0
    272c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2730:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2734:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2738:	61786574 	cmnvs	r8, r4, ror r5
    273c:	6f633337 	svcvs	0x00633337
    2740:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2744:	00353361 	eorseq	r3, r5, r1, ror #6
    2748:	5f4d5241 	svcpl	0x004d5241
    274c:	6100564e 	tstvs	r0, lr, asr #12
    2750:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2754:	34686372 	strbtcc	r6, [r8], #-882	; 0xfffffc8e
    2758:	6d726100 	ldfvse	f6, [r2, #-0]
    275c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2760:	61003568 	tstvs	r0, r8, ror #10
    2764:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2768:	37686372 			; <UNDEFINED> instruction: 0x37686372
    276c:	6d726100 	ldfvse	f6, [r2, #-0]
    2770:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2774:	6c003868 	stcvs	8, cr3, [r0], {104}	; 0x68
    2778:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    277c:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    2780:	4200656c 	andmi	r6, r0, #108, 10	; 0x1b000000
    2784:	5f455341 	svcpl	0x00455341
    2788:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    278c:	004b365f 	subeq	r3, fp, pc, asr r6
    2790:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2794:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2798:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    279c:	34396d72 	ldrtcc	r6, [r9], #-3442	; 0xfffff28e
    27a0:	61007430 	tstvs	r0, r0, lsr r4
    27a4:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    27a8:	36686372 			; <UNDEFINED> instruction: 0x36686372
    27ac:	6d726100 	ldfvse	f6, [r2, #-0]
    27b0:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    27b4:	73785f65 	cmnvc	r8, #404	; 0x194
    27b8:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    27bc:	52415400 	subpl	r5, r1, #0, 8
    27c0:	5f544547 	svcpl	0x00544547
    27c4:	5f555043 	svcpl	0x00555043
    27c8:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    27cc:	00303035 	eorseq	r3, r0, r5, lsr r0
    27d0:	696b616d 	stmdbvs	fp!, {r0, r2, r3, r5, r6, r8, sp, lr}^
    27d4:	635f676e 	cmpvs	pc, #28835840	; 0x1b80000
    27d8:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
    27dc:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    27e0:	7400656c 	strvc	r6, [r0], #-1388	; 0xfffffa94
    27e4:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    27e8:	6c61635f 	stclvs	3, cr6, [r1], #-380	; 0xfffffe84
    27ec:	69765f6c 	ldmdbvs	r6!, {r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    27f0:	616c5f61 	cmnvs	ip, r1, ror #30
    27f4:	006c6562 	rsbeq	r6, ip, r2, ror #10
    27f8:	5f617369 	svcpl	0x00617369
    27fc:	5f746962 	svcpl	0x00746962
    2800:	35767066 	ldrbcc	r7, [r6, #-102]!	; 0xffffff9a
    2804:	52415400 	subpl	r5, r1, #0, 8
    2808:	5f544547 	svcpl	0x00544547
    280c:	5f555043 	svcpl	0x00555043
    2810:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    2814:	69003031 	stmdbvs	r0, {r0, r4, r5, ip, sp}
    2818:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    281c:	615f7469 	cmpvs	pc, r9, ror #8
    2820:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    2824:	4154006b 	cmpmi	r4, fp, rrx
    2828:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    282c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2830:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2834:	61786574 	cmnvs	r8, r4, ror r5
    2838:	41540037 	cmpmi	r4, r7, lsr r0
    283c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2840:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2844:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2848:	61786574 	cmnvs	r8, r4, ror r5
    284c:	41540038 	cmpmi	r4, r8, lsr r0
    2850:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2854:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2858:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    285c:	61786574 	cmnvs	r8, r4, ror r5
    2860:	52410039 	subpl	r0, r1, #57	; 0x39
    2864:	43505f4d 	cmpmi	r0, #308	; 0x134
    2868:	50415f53 	subpl	r5, r1, r3, asr pc
    286c:	41005343 	tstmi	r0, r3, asr #6
    2870:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    2874:	415f5343 	cmpmi	pc, r3, asr #6
    2878:	53435054 	movtpl	r5, #12372	; 0x3054
    287c:	52415400 	subpl	r5, r1, #0, 8
    2880:	5f544547 	svcpl	0x00544547
    2884:	5f555043 	svcpl	0x00555043
    2888:	366d7261 	strbtcc	r7, [sp], -r1, ror #4
    288c:	54003030 	strpl	r3, [r0], #-48	; 0xffffffd0
    2890:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2894:	50435f54 	subpl	r5, r3, r4, asr pc
    2898:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    289c:	3032376d 	eorscc	r3, r2, sp, ror #14
    28a0:	41540074 	cmpmi	r4, r4, ror r0
    28a4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    28a8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    28ac:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    28b0:	61786574 	cmnvs	r8, r4, ror r5
    28b4:	63003735 	movwvs	r3, #1845	; 0x735
    28b8:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    28bc:	64207865 	strtvs	r7, [r0], #-2149	; 0xfffff79b
    28c0:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    28c4:	41540065 	cmpmi	r4, r5, rrx
    28c8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    28cc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    28d0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    28d4:	61786574 	cmnvs	r8, r4, ror r5
    28d8:	6f633337 	svcvs	0x00633337
    28dc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    28e0:	00333561 	eorseq	r3, r3, r1, ror #10
    28e4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    28e8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    28ec:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    28f0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    28f4:	70306d78 	eorsvc	r6, r0, r8, ror sp
    28f8:	0073756c 	rsbseq	r7, r3, ip, ror #10
    28fc:	5f6d7261 	svcpl	0x006d7261
    2900:	69006363 	stmdbvs	r0, {r0, r1, r5, r6, r8, r9, sp, lr}
    2904:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2908:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 276c <shift+0x276c>
    290c:	3265646f 	rsbcc	r6, r5, #1862270976	; 0x6f000000
    2910:	73690036 	cmnvc	r9, #54	; 0x36
    2914:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2918:	73785f74 	cmnvc	r8, #116, 30	; 0x1d0
    291c:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    2920:	52415400 	subpl	r5, r1, #0, 8
    2924:	5f544547 	svcpl	0x00544547
    2928:	5f555043 	svcpl	0x00555043
    292c:	6f727473 	svcvs	0x00727473
    2930:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    2934:	3031316d 	eorscc	r3, r1, sp, ror #2
    2938:	41540030 	cmpmi	r4, r0, lsr r0
    293c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2940:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2944:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2948:	6d647437 	cfstrdvs	mvd7, [r4, #-220]!	; 0xffffff24
    294c:	5f007369 	svcpl	0x00007369
    2950:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    2954:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    2958:	6572745f 	ldrbvs	r7, [r2, #-1119]!	; 0xfffffba1
    295c:	65685f65 	strbvs	r5, [r8, #-3941]!	; 0xfffff09b
    2960:	005f6572 	subseq	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    2964:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2968:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    296c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2970:	30316d72 	eorscc	r6, r1, r2, ror sp
    2974:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    2978:	52415400 	subpl	r5, r1, #0, 8
    297c:	5f544547 	svcpl	0x00544547
    2980:	5f555043 	svcpl	0x00555043
    2984:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2988:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    298c:	73616200 	cmnvc	r1, #0, 4
    2990:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    2994:	74696863 	strbtvc	r6, [r9], #-2147	; 0xfffff79d
    2998:	75746365 	ldrbvc	r6, [r4, #-869]!	; 0xfffffc9b
    299c:	61006572 	tstvs	r0, r2, ror r5
    29a0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    29a4:	5f686372 	svcpl	0x00686372
    29a8:	00637263 	rsbeq	r7, r3, r3, ror #4
    29ac:	47524154 			; <UNDEFINED> instruction: 0x47524154
    29b0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    29b4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    29b8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    29bc:	73316d78 	teqvc	r1, #120, 26	; 0x1e00
    29c0:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    29c4:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    29c8:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    29cc:	6d726100 	ldfvse	f6, [r2, #-0]
    29d0:	7275635f 	rsbsvc	r6, r5, #2080374785	; 0x7c000001
    29d4:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    29d8:	0063635f 	rsbeq	r6, r3, pc, asr r3
    29dc:	5f6d7261 	svcpl	0x006d7261
    29e0:	67726174 			; <UNDEFINED> instruction: 0x67726174
    29e4:	695f7465 	ldmdbvs	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    29e8:	006e736e 	rsbeq	r7, lr, lr, ror #6
    29ec:	5f617369 	svcpl	0x00617369
    29f0:	5f746962 	svcpl	0x00746962
    29f4:	33637263 	cmncc	r3, #805306374	; 0x30000006
    29f8:	52410032 	subpl	r0, r1, #50	; 0x32
    29fc:	4c505f4d 	mrrcmi	15, 4, r5, r0, cr13
    2a00:	61736900 	cmnvs	r3, r0, lsl #18
    2a04:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2a08:	7066765f 	rsbvc	r7, r6, pc, asr r6
    2a0c:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
    2a10:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2a14:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    2a18:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
    2a1c:	53414200 	movtpl	r4, #4608	; 0x1200
    2a20:	52415f45 	subpl	r5, r1, #276	; 0x114
    2a24:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    2a28:	42003254 	andmi	r3, r0, #84, 4	; 0x40000005
    2a2c:	5f455341 	svcpl	0x00455341
    2a30:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2a34:	5f4d385f 	svcpl	0x004d385f
    2a38:	4e49414d 	dvfmiem	f4, f1, #5.0
    2a3c:	52415400 	subpl	r5, r1, #0, 8
    2a40:	5f544547 	svcpl	0x00544547
    2a44:	5f555043 	svcpl	0x00555043
    2a48:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    2a4c:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    2a50:	4d524100 	ldfmie	f4, [r2, #-0]
    2a54:	004c415f 	subeq	r4, ip, pc, asr r1
    2a58:	5f617369 	svcpl	0x00617369
    2a5c:	5f746962 	svcpl	0x00746962
    2a60:	65646f6d 	strbvs	r6, [r4, #-3949]!	; 0xfffff093
    2a64:	42003233 	andmi	r3, r0, #805306371	; 0x30000003
    2a68:	5f455341 	svcpl	0x00455341
    2a6c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2a70:	004d375f 	subeq	r3, sp, pc, asr r7
    2a74:	5f6d7261 	svcpl	0x006d7261
    2a78:	67726174 			; <UNDEFINED> instruction: 0x67726174
    2a7c:	6c5f7465 	cfldrdvs	mvd7, [pc], {101}	; 0x65
    2a80:	6c656261 	sfmvs	f6, 2, [r5], #-388	; 0xfffffe7c
    2a84:	52415400 	subpl	r5, r1, #0, 8
    2a88:	5f544547 	svcpl	0x00544547
    2a8c:	5f555043 	svcpl	0x00555043
    2a90:	6f727473 	svcvs	0x00727473
    2a94:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    2a98:	3131316d 	teqcc	r1, sp, ror #2
    2a9c:	41540030 	cmpmi	r4, r0, lsr r0
    2aa0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2aa4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2aa8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2aac:	00303237 	eorseq	r3, r0, r7, lsr r2
    2ab0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2ab4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2ab8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2abc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2ac0:	00347278 	eorseq	r7, r4, r8, ror r2
    2ac4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2ac8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2acc:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2ad0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2ad4:	00357278 	eorseq	r7, r5, r8, ror r2
    2ad8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2adc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2ae0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2ae4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2ae8:	00377278 	eorseq	r7, r7, r8, ror r2
    2aec:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2af0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2af4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2af8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2afc:	00387278 	eorseq	r7, r8, r8, ror r2
    2b00:	5f617369 	svcpl	0x00617369
    2b04:	5f746962 	svcpl	0x00746962
    2b08:	6561706c 	strbvs	r7, [r1, #-108]!	; 0xffffff94
    2b0c:	52415400 	subpl	r5, r1, #0, 8
    2b10:	5f544547 	svcpl	0x00544547
    2b14:	5f555043 	svcpl	0x00555043
    2b18:	6f727473 	svcvs	0x00727473
    2b1c:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    2b20:	3031316d 	eorscc	r3, r1, sp, ror #2
    2b24:	61736900 	cmnvs	r3, r0, lsl #18
    2b28:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2b2c:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    2b30:	615f6b72 	cmpvs	pc, r2, ror fp	; <UNPREDICTABLE>
    2b34:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    2b38:	69007a6b 	stmdbvs	r0, {r0, r1, r3, r5, r6, r9, fp, ip, sp, lr}
    2b3c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2b40:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    2b44:	006d746f 	rsbeq	r7, sp, pc, ror #8
    2b48:	5f617369 	svcpl	0x00617369
    2b4c:	5f746962 	svcpl	0x00746962
    2b50:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2b54:	73690034 	cmnvc	r9, #52	; 0x34
    2b58:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2b5c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2b60:	0035766d 	eorseq	r7, r5, sp, ror #12
    2b64:	5f617369 	svcpl	0x00617369
    2b68:	5f746962 	svcpl	0x00746962
    2b6c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2b70:	73690036 	cmnvc	r9, #54	; 0x36
    2b74:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2b78:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2b7c:	0037766d 	eorseq	r7, r7, sp, ror #12
    2b80:	5f617369 	svcpl	0x00617369
    2b84:	5f746962 	svcpl	0x00746962
    2b88:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2b8c:	645f0038 	ldrbvs	r0, [pc], #-56	; 2b94 <shift+0x2b94>
    2b90:	5f746e6f 	svcpl	0x00746e6f
    2b94:	5f657375 	svcpl	0x00657375
    2b98:	5f787472 	svcpl	0x00787472
    2b9c:	65726568 	ldrbvs	r6, [r2, #-1384]!	; 0xfffffa98
    2ba0:	5155005f 	cmppl	r5, pc, asr r0
    2ba4:	70797449 	rsbsvc	r7, r9, r9, asr #8
    2ba8:	72610065 	rsbvc	r0, r1, #101	; 0x65
    2bac:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    2bb0:	6100656e 	tstvs	r0, lr, ror #10
    2bb4:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    2bb8:	695f7070 	ldmdbvs	pc, {r4, r5, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    2bbc:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    2bc0:	6b726f77 	blvs	1c9e9a4 <__bss_end+0x1c95260>
    2bc4:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
    2bc8:	74705f63 	ldrbtvc	r5, [r0], #-3939	; 0xfffff09d
    2bcc:	41540072 	cmpmi	r4, r2, ror r0
    2bd0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2bd4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2bd8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2bdc:	74303239 	ldrtvc	r3, [r0], #-569	; 0xfffffdc7
    2be0:	61746800 	cmnvs	r4, r0, lsl #16
    2be4:	71655f62 	cmnvc	r5, r2, ror #30
    2be8:	52415400 	subpl	r5, r1, #0, 8
    2bec:	5f544547 	svcpl	0x00544547
    2bf0:	5f555043 	svcpl	0x00555043
    2bf4:	32356166 	eorscc	r6, r5, #-2147483623	; 0x80000019
    2bf8:	72610036 	rsbvc	r0, r1, #54	; 0x36
    2bfc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2c00:	745f6863 	ldrbvc	r6, [pc], #-2147	; 2c08 <shift+0x2c08>
    2c04:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    2c08:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
    2c0c:	68007669 	stmdavs	r0, {r0, r3, r5, r6, r9, sl, ip, sp, lr}
    2c10:	5f626174 	svcpl	0x00626174
    2c14:	705f7165 	subsvc	r7, pc, r5, ror #2
    2c18:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    2c1c:	54007265 	strpl	r7, [r0], #-613	; 0xfffffd9b
    2c20:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2c24:	50435f54 	subpl	r5, r3, r4, asr pc
    2c28:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2c2c:	0030366d 	eorseq	r3, r0, sp, ror #12
    2c30:	20554e47 	subscs	r4, r5, r7, asr #28
    2c34:	20373143 	eorscs	r3, r7, r3, asr #2
    2c38:	2e332e38 	mrccs	14, 1, r2, cr3, cr8, {1}
    2c3c:	30322031 	eorscc	r2, r2, r1, lsr r0
    2c40:	37303931 			; <UNDEFINED> instruction: 0x37303931
    2c44:	28203330 	stmdacs	r0!, {r4, r5, r8, r9, ip, sp}
    2c48:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    2c4c:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    2c50:	63675b20 	cmnvs	r7, #32, 22	; 0x8000
    2c54:	2d382d63 	ldccs	13, cr2, [r8, #-396]!	; 0xfffffe74
    2c58:	6e617262 	cdpvs	2, 6, cr7, cr1, cr2, {3}
    2c5c:	72206863 	eorvc	r6, r0, #6488064	; 0x630000
    2c60:	73697665 	cmnvc	r9, #105906176	; 0x6500000
    2c64:	206e6f69 	rsbcs	r6, lr, r9, ror #30
    2c68:	30333732 	eorscc	r3, r3, r2, lsr r7
    2c6c:	205d3732 	subscs	r3, sp, r2, lsr r7
    2c70:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    2c74:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
    2c78:	616f6c66 	cmnvs	pc, r6, ror #24
    2c7c:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    2c80:	61683d69 	cmnvs	r8, r9, ror #26
    2c84:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    2c88:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
    2c8c:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
    2c90:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    2c94:	70662b65 	rsbvc	r2, r6, r5, ror #22
    2c98:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    2c9c:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    2ca0:	4f2d2067 	svcmi	0x002d2067
    2ca4:	4f2d2032 	svcmi	0x002d2032
    2ca8:	4f2d2032 	svcmi	0x002d2032
    2cac:	662d2032 			; <UNDEFINED> instruction: 0x662d2032
    2cb0:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    2cb4:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
    2cb8:	62696c2d 	rsbvs	r6, r9, #11520	; 0x2d00
    2cbc:	20636367 	rsbcs	r6, r3, r7, ror #6
    2cc0:	6f6e662d 	svcvs	0x006e662d
    2cc4:	6174732d 	cmnvs	r4, sp, lsr #6
    2cc8:	702d6b63 	eorvc	r6, sp, r3, ror #22
    2ccc:	65746f72 	ldrbvs	r6, [r4, #-3954]!	; 0xfffff08e
    2cd0:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    2cd4:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    2cd8:	6e692d6f 	cdpvs	13, 6, cr2, cr9, cr15, {3}
    2cdc:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    2ce0:	76662d20 	strbtvc	r2, [r6], -r0, lsr #26
    2ce4:	62697369 	rsbvs	r7, r9, #-1543503871	; 0xa4000001
    2ce8:	74696c69 	strbtvc	r6, [r9], #-3177	; 0xfffff397
    2cec:	69683d79 	stmdbvs	r8!, {r0, r3, r4, r5, r6, r8, sl, fp, ip, sp}^
    2cf0:	6e656464 	cdpvs	4, 6, cr6, cr5, cr4, {3}
    2cf4:	6d726100 	ldfvse	f6, [r2, #-0]
    2cf8:	6369705f 	cmnvs	r9, #95	; 0x5f
    2cfc:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    2d00:	65747369 	ldrbvs	r7, [r4, #-873]!	; 0xfffffc97
    2d04:	41540072 	cmpmi	r4, r2, ror r0
    2d08:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2d0c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2d10:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2d14:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2d18:	616d7330 	cmnvs	sp, r0, lsr r3
    2d1c:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    2d20:	7069746c 	rsbvc	r7, r9, ip, ror #8
    2d24:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    2d28:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2d2c:	50435f54 	subpl	r5, r3, r4, asr pc
    2d30:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2d34:	3636396d 	ldrtcc	r3, [r6], -sp, ror #18
    2d38:	54007365 	strpl	r7, [r0], #-869	; 0xfffffc9b
    2d3c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2d40:	50435f54 	subpl	r5, r3, r4, asr pc
    2d44:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    2d48:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    2d4c:	66766f6e 	ldrbtvs	r6, [r6], -lr, ror #30
    2d50:	73690070 	cmnvc	r9, #112	; 0x70
    2d54:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2d58:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    2d5c:	5f6b7269 	svcpl	0x006b7269
    2d60:	5f336d63 	svcpl	0x00336d63
    2d64:	6472646c 	ldrbtvs	r6, [r2], #-1132	; 0xfffffb94
    2d68:	52415400 	subpl	r5, r1, #0, 8
    2d6c:	5f544547 	svcpl	0x00544547
    2d70:	5f555043 	svcpl	0x00555043
    2d74:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    2d78:	00693030 	rsbeq	r3, r9, r0, lsr r0
    2d7c:	5f4d5241 	svcpl	0x004d5241
    2d80:	61004343 	tstvs	r0, r3, asr #6
    2d84:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2d88:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2d8c:	5400325f 	strpl	r3, [r0], #-607	; 0xfffffda1
    2d90:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2d94:	50435f54 	subpl	r5, r3, r4, asr pc
    2d98:	6d665f55 	stclvs	15, cr5, [r6, #-340]!	; 0xfffffeac
    2d9c:	36323670 			; <UNDEFINED> instruction: 0x36323670
    2da0:	4d524100 	ldfmie	f4, [r2, #-0]
    2da4:	0053435f 	subseq	r4, r3, pc, asr r3
    2da8:	5f6d7261 	svcpl	0x006d7261
    2dac:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    2db0:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    2db4:	72610074 	rsbvc	r0, r1, #116	; 0x74
    2db8:	61625f6d 	cmnvs	r2, sp, ror #30
    2dbc:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    2dc0:	00686372 	rsbeq	r6, r8, r2, ror r3
    2dc4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2dc8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2dcc:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2dd0:	6d376d72 	ldcvs	13, cr6, [r7, #-456]!	; 0xfffffe38
    2dd4:	52415400 	subpl	r5, r1, #0, 8
    2dd8:	5f544547 	svcpl	0x00544547
    2ddc:	5f555043 	svcpl	0x00555043
    2de0:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    2de4:	41540030 	cmpmi	r4, r0, lsr r0
    2de8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2dec:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2df0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2df4:	00303532 	eorseq	r3, r0, r2, lsr r5
    2df8:	5f6d7261 	svcpl	0x006d7261
    2dfc:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2e00:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    2e04:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2e08:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2e0c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2e10:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2e14:	32376178 	eorscc	r6, r7, #120, 2
    2e18:	6d726100 	ldfvse	f6, [r2, #-0]
    2e1c:	7363705f 	cmnvc	r3, #95	; 0x5f
    2e20:	6665645f 			; <UNDEFINED> instruction: 0x6665645f
    2e24:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
    2e28:	4d524100 	ldfmie	f4, [r2, #-0]
    2e2c:	5343505f 	movtpl	r5, #12383	; 0x305f
    2e30:	5041415f 	subpl	r4, r1, pc, asr r1
    2e34:	4c5f5343 	mrrcmi	3, 4, r5, pc, cr3	; <UNPREDICTABLE>
    2e38:	4c41434f 	mcrrmi	3, 4, r4, r1, cr15
    2e3c:	52415400 	subpl	r5, r1, #0, 8
    2e40:	5f544547 	svcpl	0x00544547
    2e44:	5f555043 	svcpl	0x00555043
    2e48:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2e4c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2e50:	41540035 	cmpmi	r4, r5, lsr r0
    2e54:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2e58:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2e5c:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    2e60:	61676e6f 	cmnvs	r7, pc, ror #28
    2e64:	61006d72 	tstvs	r0, r2, ror sp
    2e68:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2e6c:	5f686372 	svcpl	0x00686372
    2e70:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2e74:	61003162 	tstvs	r0, r2, ror #2
    2e78:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2e7c:	5f686372 	svcpl	0x00686372
    2e80:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2e84:	54003262 	strpl	r3, [r0], #-610	; 0xfffffd9e
    2e88:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2e8c:	50435f54 	subpl	r5, r3, r4, asr pc
    2e90:	77695f55 			; <UNDEFINED> instruction: 0x77695f55
    2e94:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    2e98:	52415400 	subpl	r5, r1, #0, 8
    2e9c:	5f544547 	svcpl	0x00544547
    2ea0:	5f555043 	svcpl	0x00555043
    2ea4:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    2ea8:	00743232 	rsbseq	r3, r4, r2, lsr r2
    2eac:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2eb0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2eb4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2eb8:	64376d72 	ldrtvs	r6, [r7], #-3442	; 0xfffff28e
    2ebc:	61736900 	cmnvs	r3, r0, lsl #18
    2ec0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2ec4:	00706d5f 	rsbseq	r6, r0, pc, asr sp
    2ec8:	5f6d7261 	svcpl	0x006d7261
    2ecc:	735f646c 	cmpvc	pc, #108, 8	; 0x6c000000
    2ed0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    2ed4:	6d726100 	ldfvse	f6, [r2, #-0]
    2ed8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2edc:	315f3868 	cmpcc	pc, r8, ror #16
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
  20:	8b040e42 	blhi	103930 <__bss_end+0xfa1ec>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x3470ec>
  28:	420d0d66 	andmi	r0, sp, #6528	; 0x1980
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	0000806c 	andeq	r8, r0, ip, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1fa20c>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf953c>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080ac 	andeq	r8, r0, ip, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfa23c>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x34713c>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080e4 	andeq	r8, r0, r4, ror #1
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfa25c>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x34715c>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008110 	andeq	r8, r0, r0, lsl r1
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfa27c>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x34717c>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008130 	andeq	r8, r0, r0, lsr r1
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfa29c>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x34719c>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008148 	andeq	r8, r0, r8, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfa2bc>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x3471bc>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008160 	andeq	r8, r0, r0, ror #2
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfa2dc>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x3471dc>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008178 	andeq	r8, r0, r8, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfa2fc>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x3471fc>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	00008184 	andeq	r8, r0, r4, lsl #3
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1fa314>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081dc 	ldrdeq	r8, [r0], -ip
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1fa334>
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
 194:	0000010c 	andeq	r0, r0, ip, lsl #2
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1fa364>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	00008340 	andeq	r8, r0, r0, asr #6
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfa390>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x347290>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	0000836c 	andeq	r8, r0, ip, ror #6
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfa3b0>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x3472b0>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	00008398 	muleq	r0, r8, r3
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfa3d0>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x3472d0>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	000083b4 			; <UNDEFINED> instruction: 0x000083b4
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfa3f0>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x3472f0>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	000083f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfa410>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x347310>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	00008448 	andeq	r8, r0, r8, asr #8
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfa430>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x347330>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	00008498 	muleq	r0, r8, r4
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfa450>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347350>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	000084c4 	andeq	r8, r0, r4, asr #9
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfa470>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347370>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	00008514 	andeq	r8, r0, r4, lsl r5
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfa490>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x347390>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	00008558 	andeq	r8, r0, r8, asr r5
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfa4b0>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x3473b0>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	000085a8 	andeq	r8, r0, r8, lsr #11
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfa4d0>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x3473d0>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	000085fc 	strdeq	r8, [r0], -ip
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfa4f0>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x3473f0>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	00008638 	andeq	r8, r0, r8, lsr r6
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfa510>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x347410>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	00008674 	andeq	r8, r0, r4, ror r6
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfa530>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347430>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	000086b0 			; <UNDEFINED> instruction: 0x000086b0
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfa550>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347450>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	000086ec 	andeq	r8, r0, ip, ror #13
 3a0:	000000b4 	strheq	r0, [r0], -r4
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1fa570>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c52 	stmdaeq	sp, {r1, r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	000087a0 	andeq	r8, r0, r0, lsr #15
 3d0:	00000174 	andeq	r0, r0, r4, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fa5a0>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	00008914 	andeq	r8, r0, r4, lsl r9
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfa5c0>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x3474c0>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	000089b0 			; <UNDEFINED> instruction: 0x000089b0
 410:	000000c0 	andeq	r0, r0, r0, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfa5e0>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x3474e0>
 41c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	00008a70 	andeq	r8, r0, r0, ror sl
 430:	000000ac 	andeq	r0, r0, ip, lsr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfa600>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x347500>
 43c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008b1c 	andeq	r8, r0, ip, lsl fp
 450:	00000054 	andeq	r0, r0, r4, asr r0
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfa620>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347520>
 45c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008b70 	andeq	r8, r0, r0, ror fp
 470:	00000068 	andeq	r0, r0, r8, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfa640>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347540>
 47c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008bd8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 490:	00000080 	andeq	r0, r0, r0, lsl #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfa660>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347560>
 49c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000000c 	andeq	r0, r0, ip
 4a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 4b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4b8:	000004a4 	andeq	r0, r0, r4, lsr #9
 4bc:	00008c58 	andeq	r8, r0, r8, asr ip
 4c0:	00000068 	andeq	r0, r0, r8, rrx
 4c4:	8b080e42 	blhi	203dd4 <__bss_end+0x1fa690>
 4c8:	42018e02 	andmi	r8, r1, #2, 28
 4cc:	6e040b0c 	vmlavs.f64	d0, d4, d12
 4d0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 4d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4d8:	000004a4 	andeq	r0, r0, r4, lsr #9
 4dc:	00008cc0 	andeq	r8, r0, r0, asr #25
 4e0:	0000004c 	andeq	r0, r0, ip, asr #32
 4e4:	8b080e42 	blhi	203df4 <__bss_end+0x1fa6b0>
 4e8:	42018e02 	andmi	r8, r1, #2, 28
 4ec:	60040b0c 	andvs	r0, r4, ip, lsl #22
 4f0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 4f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4f8:	000004a4 	andeq	r0, r0, r4, lsr #9
 4fc:	00008d0c 	andeq	r8, r0, ip, lsl #26
 500:	00000028 	andeq	r0, r0, r8, lsr #32
 504:	8b040e42 	blhi	103e14 <__bss_end+0xfa6d0>
 508:	0b0d4201 	bleq	350d14 <__bss_end+0x3475d0>
 50c:	420d0d4c 	andmi	r0, sp, #76, 26	; 0x1300
 510:	00000ecb 	andeq	r0, r0, fp, asr #29
 514:	0000001c 	andeq	r0, r0, ip, lsl r0
 518:	000004a4 	andeq	r0, r0, r4, lsr #9
 51c:	00008d34 	andeq	r8, r0, r4, lsr sp
 520:	0000007c 	andeq	r0, r0, ip, ror r0
 524:	8b080e42 	blhi	203e34 <__bss_end+0x1fa6f0>
 528:	42018e02 	andmi	r8, r1, #2, 28
 52c:	78040b0c 	stmdavc	r4, {r2, r3, r8, r9, fp}
 530:	00080d0c 	andeq	r0, r8, ip, lsl #26
 534:	0000001c 	andeq	r0, r0, ip, lsl r0
 538:	000004a4 	andeq	r0, r0, r4, lsr #9
 53c:	00008db0 			; <UNDEFINED> instruction: 0x00008db0
 540:	000000ec 	andeq	r0, r0, ip, ror #1
 544:	8b080e42 	blhi	203e54 <__bss_end+0x1fa710>
 548:	42018e02 	andmi	r8, r1, #2, 28
 54c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 550:	080d0c70 	stmdaeq	sp, {r4, r5, r6, sl, fp}
 554:	0000001c 	andeq	r0, r0, ip, lsl r0
 558:	000004a4 	andeq	r0, r0, r4, lsr #9
 55c:	00008e9c 	muleq	r0, ip, lr
 560:	00000168 	andeq	r0, r0, r8, ror #2
 564:	8b080e42 	blhi	203e74 <__bss_end+0x1fa730>
 568:	42018e02 	andmi	r8, r1, #2, 28
 56c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 570:	080d0cac 	stmdaeq	sp, {r2, r3, r5, r7, sl, fp}
 574:	0000001c 	andeq	r0, r0, ip, lsl r0
 578:	000004a4 	andeq	r0, r0, r4, lsr #9
 57c:	00009004 	andeq	r9, r0, r4
 580:	00000058 	andeq	r0, r0, r8, asr r0
 584:	8b080e42 	blhi	203e94 <__bss_end+0x1fa750>
 588:	42018e02 	andmi	r8, r1, #2, 28
 58c:	66040b0c 	strvs	r0, [r4], -ip, lsl #22
 590:	00080d0c 	andeq	r0, r8, ip, lsl #26
 594:	0000001c 	andeq	r0, r0, ip, lsl r0
 598:	000004a4 	andeq	r0, r0, r4, lsr #9
 59c:	0000905c 	andeq	r9, r0, ip, asr r0
 5a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 5a4:	8b080e42 	blhi	203eb4 <__bss_end+0x1fa770>
 5a8:	42018e02 	andmi	r8, r1, #2, 28
 5ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 5b0:	080d0c52 	stmdaeq	sp, {r1, r4, r6, sl, fp}
 5b4:	0000000c 	andeq	r0, r0, ip
 5b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5bc:	7c010001 	stcvc	0, cr0, [r1], {1}
 5c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5c4:	0000000c 	andeq	r0, r0, ip
 5c8:	000005b4 			; <UNDEFINED> instruction: 0x000005b4
 5cc:	0000910c 	andeq	r9, r0, ip, lsl #2
 5d0:	000001ec 	andeq	r0, r0, ip, ror #3
