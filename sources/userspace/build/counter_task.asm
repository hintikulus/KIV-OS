
./counter_task:     file format elf32-littlearm


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
    8064:	00008fbc 			; <UNDEFINED> instruction: 0x00008fbc
    8068:	00008fcc 	andeq	r8, r0, ip, asr #31

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
    81d4:	00008fb9 			; <UNDEFINED> instruction: 0x00008fb9
    81d8:	00008fb9 			; <UNDEFINED> instruction: 0x00008fb9

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
    822c:	00008fb9 			; <UNDEFINED> instruction: 0x00008fb9
    8230:	00008fb9 			; <UNDEFINED> instruction: 0x00008fb9

00008234 <main>:
main():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:17
 *  - vzestupne pokud je prepinac 1 v poloze "zapnuto", jinak sestupne
 *  - rychle pokud je prepinac 2 v poloze "zapnuto", jinak pomalu
 **/

int main(int argc, char** argv)
{
    8234:	e92d4800 	push	{fp, lr}
    8238:	e28db004 	add	fp, sp, #4
    823c:	e24dd020 	sub	sp, sp, #32
    8240:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    8244:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:18
	uint32_t display_file = open("DEV:segd", NFile_Open_Mode::Write_Only);
    8248:	e3a01001 	mov	r1, #1
    824c:	e59f0164 	ldr	r0, [pc, #356]	; 83b8 <main+0x184>
    8250:	eb000079 	bl	843c <_Z4openPKc15NFile_Open_Mode>
    8254:	e50b000c 	str	r0, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:19
	uint32_t switch1_file = open("DEV:gpio/4", NFile_Open_Mode::Read_Only);
    8258:	e3a01000 	mov	r1, #0
    825c:	e59f0158 	ldr	r0, [pc, #344]	; 83bc <main+0x188>
    8260:	eb000075 	bl	843c <_Z4openPKc15NFile_Open_Mode>
    8264:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:20
	uint32_t switch2_file = open("DEV:gpio/17", NFile_Open_Mode::Read_Only);
    8268:	e3a01000 	mov	r1, #0
    826c:	e59f014c 	ldr	r0, [pc, #332]	; 83c0 <main+0x18c>
    8270:	eb000071 	bl	843c <_Z4openPKc15NFile_Open_Mode>
    8274:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:22

	unsigned int counter = 0;
    8278:	e3a03000 	mov	r3, #0
    827c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:23
	bool fast = false;
    8280:	e3a03000 	mov	r3, #0
    8284:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:24
	bool ascending = true;
    8288:	e3a03001 	mov	r3, #1
    828c:	e54b3016 	strb	r3, [fp, #-22]	; 0xffffffea
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:26

	set_task_deadline(fast ? 0x1000 : 0x2800);
    8290:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8294:	e3530000 	cmp	r3, #0
    8298:	0a000001 	beq	82a4 <main+0x70>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:26 (discriminator 1)
    829c:	e3a03a01 	mov	r3, #4096	; 0x1000
    82a0:	ea000000 	b	82a8 <main+0x74>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:26 (discriminator 2)
    82a4:	e3a03b0a 	mov	r3, #10240	; 0x2800
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:26 (discriminator 4)
    82a8:	e1a00003 	mov	r0, r3
    82ac:	eb000112 	bl	86fc <_Z17set_task_deadlinej>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:30

	while (true)
	{
		char tmp = '0';
    82b0:	e3a03030 	mov	r3, #48	; 0x30
    82b4:	e54b3017 	strb	r3, [fp, #-23]	; 0xffffffe9
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:32

		read(switch1_file, &tmp, 1);
    82b8:	e24b3017 	sub	r3, fp, #23
    82bc:	e3a02001 	mov	r2, #1
    82c0:	e1a01003 	mov	r1, r3
    82c4:	e51b0010 	ldr	r0, [fp, #-16]
    82c8:	eb00006c 	bl	8480 <_Z4readjPcj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:33
		ascending = (tmp == '1');
    82cc:	e55b3017 	ldrb	r3, [fp, #-23]	; 0xffffffe9
    82d0:	e3530031 	cmp	r3, #49	; 0x31
    82d4:	03a03001 	moveq	r3, #1
    82d8:	13a03000 	movne	r3, #0
    82dc:	e54b3016 	strb	r3, [fp, #-22]	; 0xffffffea
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:35

		read(switch2_file, &tmp, 1);
    82e0:	e24b3017 	sub	r3, fp, #23
    82e4:	e3a02001 	mov	r2, #1
    82e8:	e1a01003 	mov	r1, r3
    82ec:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    82f0:	eb000062 	bl	8480 <_Z4readjPcj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:36
		fast = (tmp == '1');
    82f4:	e55b3017 	ldrb	r3, [fp, #-23]	; 0xffffffe9
    82f8:	e3530031 	cmp	r3, #49	; 0x31
    82fc:	03a03001 	moveq	r3, #1
    8300:	13a03000 	movne	r3, #0
    8304:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:38

		if (ascending)
    8308:	e55b3016 	ldrb	r3, [fp, #-22]	; 0xffffffea
    830c:	e3530000 	cmp	r3, #0
    8310:	0a000003 	beq	8324 <main+0xf0>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:39
			counter++;
    8314:	e51b3008 	ldr	r3, [fp, #-8]
    8318:	e2833001 	add	r3, r3, #1
    831c:	e50b3008 	str	r3, [fp, #-8]
    8320:	ea000002 	b	8330 <main+0xfc>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:41
		else
			counter--;
    8324:	e51b3008 	ldr	r3, [fp, #-8]
    8328:	e2433001 	sub	r3, r3, #1
    832c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:43

		tmp = '0' + (counter % 10);
    8330:	e51b1008 	ldr	r1, [fp, #-8]
    8334:	e59f3088 	ldr	r3, [pc, #136]	; 83c4 <main+0x190>
    8338:	e0832193 	umull	r2, r3, r3, r1
    833c:	e1a021a3 	lsr	r2, r3, #3
    8340:	e1a03002 	mov	r3, r2
    8344:	e1a03103 	lsl	r3, r3, #2
    8348:	e0833002 	add	r3, r3, r2
    834c:	e1a03083 	lsl	r3, r3, #1
    8350:	e0412003 	sub	r2, r1, r3
    8354:	e6ef3072 	uxtb	r3, r2
    8358:	e2833030 	add	r3, r3, #48	; 0x30
    835c:	e6ef3073 	uxtb	r3, r3
    8360:	e54b3017 	strb	r3, [fp, #-23]	; 0xffffffe9
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:44
		write(display_file, &tmp, 1);
    8364:	e24b3017 	sub	r3, fp, #23
    8368:	e3a02001 	mov	r2, #1
    836c:	e1a01003 	mov	r1, r3
    8370:	e51b000c 	ldr	r0, [fp, #-12]
    8374:	eb000055 	bl	84d0 <_Z5writejPKcj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:46

		sleep(fast ? 0x400 : 0x600, fast ? 0x1000 : 0x2800);
    8378:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    837c:	e3530000 	cmp	r3, #0
    8380:	0a000001 	beq	838c <main+0x158>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:46 (discriminator 1)
    8384:	e3a02b01 	mov	r2, #1024	; 0x400
    8388:	ea000000 	b	8390 <main+0x15c>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:46 (discriminator 2)
    838c:	e3a02c06 	mov	r2, #1536	; 0x600
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:46 (discriminator 4)
    8390:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8394:	e3530000 	cmp	r3, #0
    8398:	0a000001 	beq	83a4 <main+0x170>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:46 (discriminator 5)
    839c:	e3a03a01 	mov	r3, #4096	; 0x1000
    83a0:	ea000000 	b	83a8 <main+0x174>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:46 (discriminator 6)
    83a4:	e3a03b0a 	mov	r3, #10240	; 0x2800
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:46 (discriminator 8)
    83a8:	e1a01003 	mov	r1, r3
    83ac:	e1a00002 	mov	r0, r2
    83b0:	eb00009e 	bl	8630 <_Z5sleepjj>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/counter_task/main.cpp:47 (discriminator 8)
	}
    83b4:	eaffffbd 	b	82b0 <main+0x7c>
    83b8:	00008f4c 	andeq	r8, r0, ip, asr #30
    83bc:	00008f58 	andeq	r8, r0, r8, asr pc
    83c0:	00008f64 	andeq	r8, r0, r4, ror #30
    83c4:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

000083c8 <_Z6getpidv>:
_Z6getpidv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    83c8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83cc:	e28db000 	add	fp, sp, #0
    83d0:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    83d4:	ef000000 	svc	0x00000000
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    83d8:	e1a03000 	mov	r3, r0
    83dc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:11

    return pid;
    83e0:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:12
}
    83e4:	e1a00003 	mov	r0, r3
    83e8:	e28bd000 	add	sp, fp, #0
    83ec:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83f0:	e12fff1e 	bx	lr

000083f4 <_Z9terminatei>:
_Z9terminatei():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    83f4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83f8:	e28db000 	add	fp, sp, #0
    83fc:	e24dd00c 	sub	sp, sp, #12
    8400:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    8404:	e51b3008 	ldr	r3, [fp, #-8]
    8408:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    840c:	ef000001 	svc	0x00000001
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:18
}
    8410:	e320f000 	nop	{0}
    8414:	e28bd000 	add	sp, fp, #0
    8418:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    841c:	e12fff1e 	bx	lr

00008420 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    8420:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8424:	e28db000 	add	fp, sp, #0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    8428:	ef000002 	svc	0x00000002
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:23
}
    842c:	e320f000 	nop	{0}
    8430:	e28bd000 	add	sp, fp, #0
    8434:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8438:	e12fff1e 	bx	lr

0000843c <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    843c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8440:	e28db000 	add	fp, sp, #0
    8444:	e24dd014 	sub	sp, sp, #20
    8448:	e50b0010 	str	r0, [fp, #-16]
    844c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    8450:	e51b3010 	ldr	r3, [fp, #-16]
    8454:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    8458:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    845c:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    8460:	ef000040 	svc	0x00000040
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    8464:	e1a03000 	mov	r3, r0
    8468:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:34

    return file;
    846c:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:35
}
    8470:	e1a00003 	mov	r0, r3
    8474:	e28bd000 	add	sp, fp, #0
    8478:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    847c:	e12fff1e 	bx	lr

00008480 <_Z4readjPcj>:
_Z4readjPcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    8480:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8484:	e28db000 	add	fp, sp, #0
    8488:	e24dd01c 	sub	sp, sp, #28
    848c:	e50b0010 	str	r0, [fp, #-16]
    8490:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8494:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8498:	e51b3010 	ldr	r3, [fp, #-16]
    849c:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    84a0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84a4:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    84a8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84ac:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    84b0:	ef000041 	svc	0x00000041
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    84b4:	e1a03000 	mov	r3, r0
    84b8:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    84bc:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:48
}
    84c0:	e1a00003 	mov	r0, r3
    84c4:	e28bd000 	add	sp, fp, #0
    84c8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84cc:	e12fff1e 	bx	lr

000084d0 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    84d0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84d4:	e28db000 	add	fp, sp, #0
    84d8:	e24dd01c 	sub	sp, sp, #28
    84dc:	e50b0010 	str	r0, [fp, #-16]
    84e0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84e4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    84e8:	e51b3010 	ldr	r3, [fp, #-16]
    84ec:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    84f0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84f4:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    84f8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84fc:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    8500:	ef000042 	svc	0x00000042
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    8504:	e1a03000 	mov	r3, r0
    8508:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    850c:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:61
}
    8510:	e1a00003 	mov	r0, r3
    8514:	e28bd000 	add	sp, fp, #0
    8518:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    851c:	e12fff1e 	bx	lr

00008520 <_Z5closej>:
_Z5closej():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    8520:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8524:	e28db000 	add	fp, sp, #0
    8528:	e24dd00c 	sub	sp, sp, #12
    852c:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    8530:	e51b3008 	ldr	r3, [fp, #-8]
    8534:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    8538:	ef000043 	svc	0x00000043
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:67
}
    853c:	e320f000 	nop	{0}
    8540:	e28bd000 	add	sp, fp, #0
    8544:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8548:	e12fff1e 	bx	lr

0000854c <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    854c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8550:	e28db000 	add	fp, sp, #0
    8554:	e24dd01c 	sub	sp, sp, #28
    8558:	e50b0010 	str	r0, [fp, #-16]
    855c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8560:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8564:	e51b3010 	ldr	r3, [fp, #-16]
    8568:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    856c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8570:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    8574:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8578:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    857c:	ef000044 	svc	0x00000044
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    8580:	e1a03000 	mov	r3, r0
    8584:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    8588:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:80
}
    858c:	e1a00003 	mov	r0, r3
    8590:	e28bd000 	add	sp, fp, #0
    8594:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8598:	e12fff1e 	bx	lr

0000859c <_Z6notifyjj>:
_Z6notifyjj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    859c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85a0:	e28db000 	add	fp, sp, #0
    85a4:	e24dd014 	sub	sp, sp, #20
    85a8:	e50b0010 	str	r0, [fp, #-16]
    85ac:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    85b0:	e51b3010 	ldr	r3, [fp, #-16]
    85b4:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    85b8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85bc:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    85c0:	ef000045 	svc	0x00000045
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    85c4:	e1a03000 	mov	r3, r0
    85c8:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    85cc:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:92
}
    85d0:	e1a00003 	mov	r0, r3
    85d4:	e28bd000 	add	sp, fp, #0
    85d8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85dc:	e12fff1e 	bx	lr

000085e0 <_Z4waitjjj>:
_Z4waitjjj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    85e0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85e4:	e28db000 	add	fp, sp, #0
    85e8:	e24dd01c 	sub	sp, sp, #28
    85ec:	e50b0010 	str	r0, [fp, #-16]
    85f0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    85f4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    85f8:	e51b3010 	ldr	r3, [fp, #-16]
    85fc:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    8600:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8604:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    8608:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    860c:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    8610:	ef000046 	svc	0x00000046
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    8614:	e1a03000 	mov	r3, r0
    8618:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    861c:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:105
}
    8620:	e1a00003 	mov	r0, r3
    8624:	e28bd000 	add	sp, fp, #0
    8628:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    862c:	e12fff1e 	bx	lr

00008630 <_Z5sleepjj>:
_Z5sleepjj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    8630:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8634:	e28db000 	add	fp, sp, #0
    8638:	e24dd014 	sub	sp, sp, #20
    863c:	e50b0010 	str	r0, [fp, #-16]
    8640:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    8644:	e51b3010 	ldr	r3, [fp, #-16]
    8648:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    864c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8650:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    8654:	ef000003 	svc	0x00000003
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    8658:	e1a03000 	mov	r3, r0
    865c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    8660:	e51b3008 	ldr	r3, [fp, #-8]
    8664:	e3530000 	cmp	r3, #0
    8668:	13a03001 	movne	r3, #1
    866c:	03a03000 	moveq	r3, #0
    8670:	e6ef3073 	uxtb	r3, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:117
}
    8674:	e1a00003 	mov	r0, r3
    8678:	e28bd000 	add	sp, fp, #0
    867c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8680:	e12fff1e 	bx	lr

00008684 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    8684:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8688:	e28db000 	add	fp, sp, #0
    868c:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    8690:	e3a03000 	mov	r3, #0
    8694:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8698:	e3a03000 	mov	r3, #0
    869c:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    86a0:	e24b300c 	sub	r3, fp, #12
    86a4:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    86a8:	ef000004 	svc	0x00000004
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:128

    return retval;
    86ac:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:129
}
    86b0:	e1a00003 	mov	r0, r3
    86b4:	e28bd000 	add	sp, fp, #0
    86b8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86bc:	e12fff1e 	bx	lr

000086c0 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    86c0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86c4:	e28db000 	add	fp, sp, #0
    86c8:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    86cc:	e3a03001 	mov	r3, #1
    86d0:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    86d4:	e3a03001 	mov	r3, #1
    86d8:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    86dc:	e24b300c 	sub	r3, fp, #12
    86e0:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    86e4:	ef000004 	svc	0x00000004
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:140

    return retval;
    86e8:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:141
}
    86ec:	e1a00003 	mov	r0, r3
    86f0:	e28bd000 	add	sp, fp, #0
    86f4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86f8:	e12fff1e 	bx	lr

000086fc <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    86fc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8700:	e28db000 	add	fp, sp, #0
    8704:	e24dd014 	sub	sp, sp, #20
    8708:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    870c:	e3a03000 	mov	r3, #0
    8710:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    8714:	e3a03000 	mov	r3, #0
    8718:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    871c:	e24b3010 	sub	r3, fp, #16
    8720:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    8724:	ef000005 	svc	0x00000005
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:150
}
    8728:	e320f000 	nop	{0}
    872c:	e28bd000 	add	sp, fp, #0
    8730:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8734:	e12fff1e 	bx	lr

00008738 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    8738:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    873c:	e28db000 	add	fp, sp, #0
    8740:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    8744:	e3a03001 	mov	r3, #1
    8748:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    874c:	e3a03001 	mov	r3, #1
    8750:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    8754:	e24b300c 	sub	r3, fp, #12
    8758:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    875c:	ef000005 	svc	0x00000005
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    8760:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:162
}
    8764:	e1a00003 	mov	r0, r3
    8768:	e28bd000 	add	sp, fp, #0
    876c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8770:	e12fff1e 	bx	lr

00008774 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    8774:	e92d4800 	push	{fp, lr}
    8778:	e28db004 	add	fp, sp, #4
    877c:	e24dd050 	sub	sp, sp, #80	; 0x50
    8780:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    8784:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    8788:	e24b3048 	sub	r3, fp, #72	; 0x48
    878c:	e3a0200a 	mov	r2, #10
    8790:	e59f108c 	ldr	r1, [pc, #140]	; 8824 <_Z4pipePKcj+0xb0>
    8794:	e1a00003 	mov	r0, r3
    8798:	eb0000a6 	bl	8a38 <_Z7strncpyPcPKci>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    879c:	e24b3048 	sub	r3, fp, #72	; 0x48
    87a0:	e283300a 	add	r3, r3, #10
    87a4:	e3a02035 	mov	r2, #53	; 0x35
    87a8:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    87ac:	e1a00003 	mov	r0, r3
    87b0:	eb0000a0 	bl	8a38 <_Z7strncpyPcPKci>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    87b4:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    87b8:	eb0000f9 	bl	8ba4 <_Z6strlenPKc>
    87bc:	e1a03000 	mov	r3, r0
    87c0:	e283300a 	add	r3, r3, #10
    87c4:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    87c8:	e51b3008 	ldr	r3, [fp, #-8]
    87cc:	e2832001 	add	r2, r3, #1
    87d0:	e50b2008 	str	r2, [fp, #-8]
    87d4:	e24b2004 	sub	r2, fp, #4
    87d8:	e0823003 	add	r3, r2, r3
    87dc:	e3a02023 	mov	r2, #35	; 0x23
    87e0:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    87e4:	e24b2048 	sub	r2, fp, #72	; 0x48
    87e8:	e51b3008 	ldr	r3, [fp, #-8]
    87ec:	e0823003 	add	r3, r2, r3
    87f0:	e3a0200a 	mov	r2, #10
    87f4:	e1a01003 	mov	r1, r3
    87f8:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    87fc:	eb000009 	bl	8828 <_Z4itoajPcj>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    8800:	e24b3048 	sub	r3, fp, #72	; 0x48
    8804:	e3a01002 	mov	r1, #2
    8808:	e1a00003 	mov	r0, r3
    880c:	ebffff0a 	bl	843c <_Z4openPKc15NFile_Open_Mode>
    8810:	e1a03000 	mov	r3, r0
    8814:	e320f000 	nop	{0}
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:179
}
    8818:	e1a00003 	mov	r0, r3
    881c:	e24bd004 	sub	sp, fp, #4
    8820:	e8bd8800 	pop	{fp, pc}
    8824:	00008f9c 	muleq	r0, ip, pc	; <UNPREDICTABLE>

00008828 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    8828:	e92d4800 	push	{fp, lr}
    882c:	e28db004 	add	fp, sp, #4
    8830:	e24dd020 	sub	sp, sp, #32
    8834:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8838:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    883c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:10
	int i = 0;
    8840:	e3a03000 	mov	r3, #0
    8844:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:12

	while (input > 0)
    8848:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    884c:	e3530000 	cmp	r3, #0
    8850:	0a000014 	beq	88a8 <_Z4itoajPcj+0x80>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    8854:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8858:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    885c:	e1a00003 	mov	r0, r3
    8860:	eb000199 	bl	8ecc <__aeabi_uidivmod>
    8864:	e1a03001 	mov	r3, r1
    8868:	e1a01003 	mov	r1, r3
    886c:	e51b3008 	ldr	r3, [fp, #-8]
    8870:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8874:	e0823003 	add	r3, r2, r3
    8878:	e59f2118 	ldr	r2, [pc, #280]	; 8998 <_Z4itoajPcj+0x170>
    887c:	e7d22001 	ldrb	r2, [r2, r1]
    8880:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:15
		input /= base;
    8884:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8888:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    888c:	eb000113 	bl	8ce0 <__udivsi3>
    8890:	e1a03000 	mov	r3, r0
    8894:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:16
		i++;
    8898:	e51b3008 	ldr	r3, [fp, #-8]
    889c:	e2833001 	add	r3, r3, #1
    88a0:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:12
	while (input > 0)
    88a4:	eaffffe7 	b	8848 <_Z4itoajPcj+0x20>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    88a8:	e51b3008 	ldr	r3, [fp, #-8]
    88ac:	e3530000 	cmp	r3, #0
    88b0:	1a000007 	bne	88d4 <_Z4itoajPcj+0xac>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    88b4:	e51b3008 	ldr	r3, [fp, #-8]
    88b8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88bc:	e0823003 	add	r3, r2, r3
    88c0:	e3a02030 	mov	r2, #48	; 0x30
    88c4:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:22
        i++;
    88c8:	e51b3008 	ldr	r3, [fp, #-8]
    88cc:	e2833001 	add	r3, r3, #1
    88d0:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    88d4:	e51b3008 	ldr	r3, [fp, #-8]
    88d8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88dc:	e0823003 	add	r3, r2, r3
    88e0:	e3a02000 	mov	r2, #0
    88e4:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:26
	i--;
    88e8:	e51b3008 	ldr	r3, [fp, #-8]
    88ec:	e2433001 	sub	r3, r3, #1
    88f0:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    88f4:	e3a03000 	mov	r3, #0
    88f8:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:28 (discriminator 3)
    88fc:	e51b3008 	ldr	r3, [fp, #-8]
    8900:	e1a02fa3 	lsr	r2, r3, #31
    8904:	e0823003 	add	r3, r2, r3
    8908:	e1a030c3 	asr	r3, r3, #1
    890c:	e1a02003 	mov	r2, r3
    8910:	e51b300c 	ldr	r3, [fp, #-12]
    8914:	e1530002 	cmp	r3, r2
    8918:	ca00001b 	bgt	898c <_Z4itoajPcj+0x164>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    891c:	e51b2008 	ldr	r2, [fp, #-8]
    8920:	e51b300c 	ldr	r3, [fp, #-12]
    8924:	e0423003 	sub	r3, r2, r3
    8928:	e1a02003 	mov	r2, r3
    892c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8930:	e0833002 	add	r3, r3, r2
    8934:	e5d33000 	ldrb	r3, [r3]
    8938:	e54b300d 	strb	r3, [fp, #-13]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    893c:	e51b300c 	ldr	r3, [fp, #-12]
    8940:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8944:	e0822003 	add	r2, r2, r3
    8948:	e51b1008 	ldr	r1, [fp, #-8]
    894c:	e51b300c 	ldr	r3, [fp, #-12]
    8950:	e0413003 	sub	r3, r1, r3
    8954:	e1a01003 	mov	r1, r3
    8958:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    895c:	e0833001 	add	r3, r3, r1
    8960:	e5d22000 	ldrb	r2, [r2]
    8964:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    8968:	e51b300c 	ldr	r3, [fp, #-12]
    896c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8970:	e0823003 	add	r3, r2, r3
    8974:	e55b200d 	ldrb	r2, [fp, #-13]
    8978:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    897c:	e51b300c 	ldr	r3, [fp, #-12]
    8980:	e2833001 	add	r3, r3, #1
    8984:	e50b300c 	str	r3, [fp, #-12]
    8988:	eaffffdb 	b	88fc <_Z4itoajPcj+0xd4>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:34
	}
}
    898c:	e320f000 	nop	{0}
    8990:	e24bd004 	sub	sp, fp, #4
    8994:	e8bd8800 	pop	{fp, pc}
    8998:	00008fa8 	andeq	r8, r0, r8, lsr #31

0000899c <_Z4atoiPKc>:
_Z4atoiPKc():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    899c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89a0:	e28db000 	add	fp, sp, #0
    89a4:	e24dd014 	sub	sp, sp, #20
    89a8:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:38
	int output = 0;
    89ac:	e3a03000 	mov	r3, #0
    89b0:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    89b4:	e51b3010 	ldr	r3, [fp, #-16]
    89b8:	e5d33000 	ldrb	r3, [r3]
    89bc:	e3530000 	cmp	r3, #0
    89c0:	0a000017 	beq	8a24 <_Z4atoiPKc+0x88>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    89c4:	e51b2008 	ldr	r2, [fp, #-8]
    89c8:	e1a03002 	mov	r3, r2
    89cc:	e1a03103 	lsl	r3, r3, #2
    89d0:	e0833002 	add	r3, r3, r2
    89d4:	e1a03083 	lsl	r3, r3, #1
    89d8:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    89dc:	e51b3010 	ldr	r3, [fp, #-16]
    89e0:	e5d33000 	ldrb	r3, [r3]
    89e4:	e3530039 	cmp	r3, #57	; 0x39
    89e8:	8a00000d 	bhi	8a24 <_Z4atoiPKc+0x88>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:43 (discriminator 1)
    89ec:	e51b3010 	ldr	r3, [fp, #-16]
    89f0:	e5d33000 	ldrb	r3, [r3]
    89f4:	e353002f 	cmp	r3, #47	; 0x2f
    89f8:	9a000009 	bls	8a24 <_Z4atoiPKc+0x88>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    89fc:	e51b3010 	ldr	r3, [fp, #-16]
    8a00:	e5d33000 	ldrb	r3, [r3]
    8a04:	e2433030 	sub	r3, r3, #48	; 0x30
    8a08:	e51b2008 	ldr	r2, [fp, #-8]
    8a0c:	e0823003 	add	r3, r2, r3
    8a10:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:48

		input++;
    8a14:	e51b3010 	ldr	r3, [fp, #-16]
    8a18:	e2833001 	add	r3, r3, #1
    8a1c:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    8a20:	eaffffe3 	b	89b4 <_Z4atoiPKc+0x18>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:51
	}

	return output;
    8a24:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:52
}
    8a28:	e1a00003 	mov	r0, r3
    8a2c:	e28bd000 	add	sp, fp, #0
    8a30:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a34:	e12fff1e 	bx	lr

00008a38 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    8a38:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a3c:	e28db000 	add	fp, sp, #0
    8a40:	e24dd01c 	sub	sp, sp, #28
    8a44:	e50b0010 	str	r0, [fp, #-16]
    8a48:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8a4c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8a50:	e3a03000 	mov	r3, #0
    8a54:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58 (discriminator 4)
    8a58:	e51b2008 	ldr	r2, [fp, #-8]
    8a5c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a60:	e1520003 	cmp	r2, r3
    8a64:	aa000011 	bge	8ab0 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58 (discriminator 2)
    8a68:	e51b3008 	ldr	r3, [fp, #-8]
    8a6c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8a70:	e0823003 	add	r3, r2, r3
    8a74:	e5d33000 	ldrb	r3, [r3]
    8a78:	e3530000 	cmp	r3, #0
    8a7c:	0a00000b 	beq	8ab0 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    8a80:	e51b3008 	ldr	r3, [fp, #-8]
    8a84:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8a88:	e0822003 	add	r2, r2, r3
    8a8c:	e51b3008 	ldr	r3, [fp, #-8]
    8a90:	e51b1010 	ldr	r1, [fp, #-16]
    8a94:	e0813003 	add	r3, r1, r3
    8a98:	e5d22000 	ldrb	r2, [r2]
    8a9c:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8aa0:	e51b3008 	ldr	r3, [fp, #-8]
    8aa4:	e2833001 	add	r3, r3, #1
    8aa8:	e50b3008 	str	r3, [fp, #-8]
    8aac:	eaffffe9 	b	8a58 <_Z7strncpyPcPKci+0x20>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    8ab0:	e51b2008 	ldr	r2, [fp, #-8]
    8ab4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8ab8:	e1520003 	cmp	r2, r3
    8abc:	aa000008 	bge	8ae4 <_Z7strncpyPcPKci+0xac>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8ac0:	e51b3008 	ldr	r3, [fp, #-8]
    8ac4:	e51b2010 	ldr	r2, [fp, #-16]
    8ac8:	e0823003 	add	r3, r2, r3
    8acc:	e3a02000 	mov	r2, #0
    8ad0:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8ad4:	e51b3008 	ldr	r3, [fp, #-8]
    8ad8:	e2833001 	add	r3, r3, #1
    8adc:	e50b3008 	str	r3, [fp, #-8]
    8ae0:	eafffff2 	b	8ab0 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:63

   return dest;
    8ae4:	e51b3010 	ldr	r3, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:64
}
    8ae8:	e1a00003 	mov	r0, r3
    8aec:	e28bd000 	add	sp, fp, #0
    8af0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8af4:	e12fff1e 	bx	lr

00008af8 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    8af8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8afc:	e28db000 	add	fp, sp, #0
    8b00:	e24dd01c 	sub	sp, sp, #28
    8b04:	e50b0010 	str	r0, [fp, #-16]
    8b08:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8b0c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    8b10:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b14:	e2432001 	sub	r2, r3, #1
    8b18:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8b1c:	e3530000 	cmp	r3, #0
    8b20:	c3a03001 	movgt	r3, #1
    8b24:	d3a03000 	movle	r3, #0
    8b28:	e6ef3073 	uxtb	r3, r3
    8b2c:	e3530000 	cmp	r3, #0
    8b30:	0a000016 	beq	8b90 <_Z7strncmpPKcS0_i+0x98>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    8b34:	e51b3010 	ldr	r3, [fp, #-16]
    8b38:	e2832001 	add	r2, r3, #1
    8b3c:	e50b2010 	str	r2, [fp, #-16]
    8b40:	e5d33000 	ldrb	r3, [r3]
    8b44:	e54b3005 	strb	r3, [fp, #-5]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    8b48:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8b4c:	e2832001 	add	r2, r3, #1
    8b50:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8b54:	e5d33000 	ldrb	r3, [r3]
    8b58:	e54b3006 	strb	r3, [fp, #-6]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    8b5c:	e55b2005 	ldrb	r2, [fp, #-5]
    8b60:	e55b3006 	ldrb	r3, [fp, #-6]
    8b64:	e1520003 	cmp	r2, r3
    8b68:	0a000003 	beq	8b7c <_Z7strncmpPKcS0_i+0x84>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    8b6c:	e55b2005 	ldrb	r2, [fp, #-5]
    8b70:	e55b3006 	ldrb	r3, [fp, #-6]
    8b74:	e0423003 	sub	r3, r2, r3
    8b78:	ea000005 	b	8b94 <_Z7strncmpPKcS0_i+0x9c>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    8b7c:	e55b3005 	ldrb	r3, [fp, #-5]
    8b80:	e3530000 	cmp	r3, #0
    8b84:	1affffe1 	bne	8b10 <_Z7strncmpPKcS0_i+0x18>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:76
        	return 0;
    8b88:	e3a03000 	mov	r3, #0
    8b8c:	ea000000 	b	8b94 <_Z7strncmpPKcS0_i+0x9c>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8b90:	e3a03000 	mov	r3, #0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:80
}
    8b94:	e1a00003 	mov	r0, r3
    8b98:	e28bd000 	add	sp, fp, #0
    8b9c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ba0:	e12fff1e 	bx	lr

00008ba4 <_Z6strlenPKc>:
_Z6strlenPKc():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8ba4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ba8:	e28db000 	add	fp, sp, #0
    8bac:	e24dd014 	sub	sp, sp, #20
    8bb0:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:84
	int i = 0;
    8bb4:	e3a03000 	mov	r3, #0
    8bb8:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8bbc:	e51b3008 	ldr	r3, [fp, #-8]
    8bc0:	e51b2010 	ldr	r2, [fp, #-16]
    8bc4:	e0823003 	add	r3, r2, r3
    8bc8:	e5d33000 	ldrb	r3, [r3]
    8bcc:	e3530000 	cmp	r3, #0
    8bd0:	0a000003 	beq	8be4 <_Z6strlenPKc+0x40>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:87
		i++;
    8bd4:	e51b3008 	ldr	r3, [fp, #-8]
    8bd8:	e2833001 	add	r3, r3, #1
    8bdc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8be0:	eafffff5 	b	8bbc <_Z6strlenPKc+0x18>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:89

	return i;
    8be4:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:90
}
    8be8:	e1a00003 	mov	r0, r3
    8bec:	e28bd000 	add	sp, fp, #0
    8bf0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8bf4:	e12fff1e 	bx	lr

00008bf8 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8bf8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8bfc:	e28db000 	add	fp, sp, #0
    8c00:	e24dd014 	sub	sp, sp, #20
    8c04:	e50b0010 	str	r0, [fp, #-16]
    8c08:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8c0c:	e51b3010 	ldr	r3, [fp, #-16]
    8c10:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8c14:	e3a03000 	mov	r3, #0
    8c18:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8c1c:	e51b2008 	ldr	r2, [fp, #-8]
    8c20:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8c24:	e1520003 	cmp	r2, r3
    8c28:	aa000008 	bge	8c50 <_Z5bzeroPvi+0x58>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8c2c:	e51b3008 	ldr	r3, [fp, #-8]
    8c30:	e51b200c 	ldr	r2, [fp, #-12]
    8c34:	e0823003 	add	r3, r2, r3
    8c38:	e3a02000 	mov	r2, #0
    8c3c:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8c40:	e51b3008 	ldr	r3, [fp, #-8]
    8c44:	e2833001 	add	r3, r3, #1
    8c48:	e50b3008 	str	r3, [fp, #-8]
    8c4c:	eafffff2 	b	8c1c <_Z5bzeroPvi+0x24>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:98
}
    8c50:	e320f000 	nop	{0}
    8c54:	e28bd000 	add	sp, fp, #0
    8c58:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c5c:	e12fff1e 	bx	lr

00008c60 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8c60:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c64:	e28db000 	add	fp, sp, #0
    8c68:	e24dd024 	sub	sp, sp, #36	; 0x24
    8c6c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8c70:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8c74:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8c78:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8c7c:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8c80:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8c84:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8c88:	e3a03000 	mov	r3, #0
    8c8c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8c90:	e51b2008 	ldr	r2, [fp, #-8]
    8c94:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c98:	e1520003 	cmp	r2, r3
    8c9c:	aa00000b 	bge	8cd0 <_Z6memcpyPKvPvi+0x70>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8ca0:	e51b3008 	ldr	r3, [fp, #-8]
    8ca4:	e51b200c 	ldr	r2, [fp, #-12]
    8ca8:	e0822003 	add	r2, r2, r3
    8cac:	e51b3008 	ldr	r3, [fp, #-8]
    8cb0:	e51b1010 	ldr	r1, [fp, #-16]
    8cb4:	e0813003 	add	r3, r1, r3
    8cb8:	e5d22000 	ldrb	r2, [r2]
    8cbc:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8cc0:	e51b3008 	ldr	r3, [fp, #-8]
    8cc4:	e2833001 	add	r3, r3, #1
    8cc8:	e50b3008 	str	r3, [fp, #-8]
    8ccc:	eaffffef 	b	8c90 <_Z6memcpyPKvPvi+0x30>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:107
}
    8cd0:	e320f000 	nop	{0}
    8cd4:	e28bd000 	add	sp, fp, #0
    8cd8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8cdc:	e12fff1e 	bx	lr

00008ce0 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1150
    8ce0:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1152
    8ce4:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1153
    8ce8:	3a000074 	bcc	8ec0 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1154
    8cec:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1155
    8cf0:	9a00006b 	bls	8ea4 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    8cf4:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    8cf8:	0a00006c 	beq	8eb0 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    8cfc:	e16f3f10 	clz	r3, r0
    8d00:	e16f2f11 	clz	r2, r1
    8d04:	e0423003 	sub	r3, r2, r3
    8d08:	e273301f 	rsbs	r3, r3, #31
    8d0c:	10833083 	addne	r3, r3, r3, lsl #1
    8d10:	e3a02000 	mov	r2, #0
    8d14:	108ff103 	addne	pc, pc, r3, lsl #2
    8d18:	e1a00000 	nop			; (mov r0, r0)
    8d1c:	e1500f81 	cmp	r0, r1, lsl #31
    8d20:	e0a22002 	adc	r2, r2, r2
    8d24:	20400f81 	subcs	r0, r0, r1, lsl #31
    8d28:	e1500f01 	cmp	r0, r1, lsl #30
    8d2c:	e0a22002 	adc	r2, r2, r2
    8d30:	20400f01 	subcs	r0, r0, r1, lsl #30
    8d34:	e1500e81 	cmp	r0, r1, lsl #29
    8d38:	e0a22002 	adc	r2, r2, r2
    8d3c:	20400e81 	subcs	r0, r0, r1, lsl #29
    8d40:	e1500e01 	cmp	r0, r1, lsl #28
    8d44:	e0a22002 	adc	r2, r2, r2
    8d48:	20400e01 	subcs	r0, r0, r1, lsl #28
    8d4c:	e1500d81 	cmp	r0, r1, lsl #27
    8d50:	e0a22002 	adc	r2, r2, r2
    8d54:	20400d81 	subcs	r0, r0, r1, lsl #27
    8d58:	e1500d01 	cmp	r0, r1, lsl #26
    8d5c:	e0a22002 	adc	r2, r2, r2
    8d60:	20400d01 	subcs	r0, r0, r1, lsl #26
    8d64:	e1500c81 	cmp	r0, r1, lsl #25
    8d68:	e0a22002 	adc	r2, r2, r2
    8d6c:	20400c81 	subcs	r0, r0, r1, lsl #25
    8d70:	e1500c01 	cmp	r0, r1, lsl #24
    8d74:	e0a22002 	adc	r2, r2, r2
    8d78:	20400c01 	subcs	r0, r0, r1, lsl #24
    8d7c:	e1500b81 	cmp	r0, r1, lsl #23
    8d80:	e0a22002 	adc	r2, r2, r2
    8d84:	20400b81 	subcs	r0, r0, r1, lsl #23
    8d88:	e1500b01 	cmp	r0, r1, lsl #22
    8d8c:	e0a22002 	adc	r2, r2, r2
    8d90:	20400b01 	subcs	r0, r0, r1, lsl #22
    8d94:	e1500a81 	cmp	r0, r1, lsl #21
    8d98:	e0a22002 	adc	r2, r2, r2
    8d9c:	20400a81 	subcs	r0, r0, r1, lsl #21
    8da0:	e1500a01 	cmp	r0, r1, lsl #20
    8da4:	e0a22002 	adc	r2, r2, r2
    8da8:	20400a01 	subcs	r0, r0, r1, lsl #20
    8dac:	e1500981 	cmp	r0, r1, lsl #19
    8db0:	e0a22002 	adc	r2, r2, r2
    8db4:	20400981 	subcs	r0, r0, r1, lsl #19
    8db8:	e1500901 	cmp	r0, r1, lsl #18
    8dbc:	e0a22002 	adc	r2, r2, r2
    8dc0:	20400901 	subcs	r0, r0, r1, lsl #18
    8dc4:	e1500881 	cmp	r0, r1, lsl #17
    8dc8:	e0a22002 	adc	r2, r2, r2
    8dcc:	20400881 	subcs	r0, r0, r1, lsl #17
    8dd0:	e1500801 	cmp	r0, r1, lsl #16
    8dd4:	e0a22002 	adc	r2, r2, r2
    8dd8:	20400801 	subcs	r0, r0, r1, lsl #16
    8ddc:	e1500781 	cmp	r0, r1, lsl #15
    8de0:	e0a22002 	adc	r2, r2, r2
    8de4:	20400781 	subcs	r0, r0, r1, lsl #15
    8de8:	e1500701 	cmp	r0, r1, lsl #14
    8dec:	e0a22002 	adc	r2, r2, r2
    8df0:	20400701 	subcs	r0, r0, r1, lsl #14
    8df4:	e1500681 	cmp	r0, r1, lsl #13
    8df8:	e0a22002 	adc	r2, r2, r2
    8dfc:	20400681 	subcs	r0, r0, r1, lsl #13
    8e00:	e1500601 	cmp	r0, r1, lsl #12
    8e04:	e0a22002 	adc	r2, r2, r2
    8e08:	20400601 	subcs	r0, r0, r1, lsl #12
    8e0c:	e1500581 	cmp	r0, r1, lsl #11
    8e10:	e0a22002 	adc	r2, r2, r2
    8e14:	20400581 	subcs	r0, r0, r1, lsl #11
    8e18:	e1500501 	cmp	r0, r1, lsl #10
    8e1c:	e0a22002 	adc	r2, r2, r2
    8e20:	20400501 	subcs	r0, r0, r1, lsl #10
    8e24:	e1500481 	cmp	r0, r1, lsl #9
    8e28:	e0a22002 	adc	r2, r2, r2
    8e2c:	20400481 	subcs	r0, r0, r1, lsl #9
    8e30:	e1500401 	cmp	r0, r1, lsl #8
    8e34:	e0a22002 	adc	r2, r2, r2
    8e38:	20400401 	subcs	r0, r0, r1, lsl #8
    8e3c:	e1500381 	cmp	r0, r1, lsl #7
    8e40:	e0a22002 	adc	r2, r2, r2
    8e44:	20400381 	subcs	r0, r0, r1, lsl #7
    8e48:	e1500301 	cmp	r0, r1, lsl #6
    8e4c:	e0a22002 	adc	r2, r2, r2
    8e50:	20400301 	subcs	r0, r0, r1, lsl #6
    8e54:	e1500281 	cmp	r0, r1, lsl #5
    8e58:	e0a22002 	adc	r2, r2, r2
    8e5c:	20400281 	subcs	r0, r0, r1, lsl #5
    8e60:	e1500201 	cmp	r0, r1, lsl #4
    8e64:	e0a22002 	adc	r2, r2, r2
    8e68:	20400201 	subcs	r0, r0, r1, lsl #4
    8e6c:	e1500181 	cmp	r0, r1, lsl #3
    8e70:	e0a22002 	adc	r2, r2, r2
    8e74:	20400181 	subcs	r0, r0, r1, lsl #3
    8e78:	e1500101 	cmp	r0, r1, lsl #2
    8e7c:	e0a22002 	adc	r2, r2, r2
    8e80:	20400101 	subcs	r0, r0, r1, lsl #2
    8e84:	e1500081 	cmp	r0, r1, lsl #1
    8e88:	e0a22002 	adc	r2, r2, r2
    8e8c:	20400081 	subcs	r0, r0, r1, lsl #1
    8e90:	e1500001 	cmp	r0, r1
    8e94:	e0a22002 	adc	r2, r2, r2
    8e98:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    8e9c:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    8ea0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    8ea4:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    8ea8:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    8eac:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1169
    8eb0:	e16f2f11 	clz	r2, r1
    8eb4:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1171
    8eb8:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1172
    8ebc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1176
    8ec0:	e3500000 	cmp	r0, #0
    8ec4:	13e00000 	mvnne	r0, #0
    8ec8:	ea000007 	b	8eec <__aeabi_idiv0>

00008ecc <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1207
    8ecc:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1208
    8ed0:	0afffffa 	beq	8ec0 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1209
    8ed4:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1210
    8ed8:	ebffff80 	bl	8ce0 <__udivsi3>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1211
    8edc:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1212
    8ee0:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1213
    8ee4:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1214
    8ee8:	e12fff1e 	bx	lr

00008eec <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1512
    8eec:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00008ef0 <_ZL13Lock_Unlocked>:
    8ef0:	00000000 	andeq	r0, r0, r0

00008ef4 <_ZL11Lock_Locked>:
    8ef4:	00000001 	andeq	r0, r0, r1

00008ef8 <_ZL21MaxFSDriverNameLength>:
    8ef8:	00000010 	andeq	r0, r0, r0, lsl r0

00008efc <_ZL17MaxFilenameLength>:
    8efc:	00000010 	andeq	r0, r0, r0, lsl r0

00008f00 <_ZL13MaxPathLength>:
    8f00:	00000080 	andeq	r0, r0, r0, lsl #1

00008f04 <_ZL18NoFilesystemDriver>:
    8f04:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f08 <_ZL9NotifyAll>:
    8f08:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f0c <_ZL24Max_Process_Opened_Files>:
    8f0c:	00000010 	andeq	r0, r0, r0, lsl r0

00008f10 <_ZL10Indefinite>:
    8f10:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f14 <_ZL18Deadline_Unchanged>:
    8f14:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008f18 <_ZL14Invalid_Handle>:
    8f18:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f1c <_ZN3halL18Default_Clock_RateE>:
    8f1c:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00008f20 <_ZN3halL15Peripheral_BaseE>:
    8f20:	20000000 	andcs	r0, r0, r0

00008f24 <_ZN3halL9GPIO_BaseE>:
    8f24:	20200000 	eorcs	r0, r0, r0

00008f28 <_ZN3halL14GPIO_Pin_CountE>:
    8f28:	00000036 	andeq	r0, r0, r6, lsr r0

00008f2c <_ZN3halL8AUX_BaseE>:
    8f2c:	20215000 	eorcs	r5, r1, r0

00008f30 <_ZN3halL25Interrupt_Controller_BaseE>:
    8f30:	2000b200 	andcs	fp, r0, r0, lsl #4

00008f34 <_ZN3halL10Timer_BaseE>:
    8f34:	2000b400 	andcs	fp, r0, r0, lsl #8

00008f38 <_ZN3halL9TRNG_BaseE>:
    8f38:	20104000 	andscs	r4, r0, r0

00008f3c <_ZN3halL9BSC0_BaseE>:
    8f3c:	20205000 	eorcs	r5, r0, r0

00008f40 <_ZN3halL9BSC1_BaseE>:
    8f40:	20804000 	addcs	r4, r0, r0

00008f44 <_ZN3halL9BSC2_BaseE>:
    8f44:	20805000 	addcs	r5, r0, r0

00008f48 <_ZL11Invalid_Pin>:
    8f48:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    8f4c:	3a564544 	bcc	159a464 <__bss_end+0x1591498>
    8f50:	64676573 	strbtvs	r6, [r7], #-1395	; 0xfffffa8d
    8f54:	00000000 	andeq	r0, r0, r0
    8f58:	3a564544 	bcc	159a470 <__bss_end+0x15914a4>
    8f5c:	6f697067 	svcvs	0x00697067
    8f60:	0000342f 	andeq	r3, r0, pc, lsr #8
    8f64:	3a564544 	bcc	159a47c <__bss_end+0x15914b0>
    8f68:	6f697067 	svcvs	0x00697067
    8f6c:	0037312f 	eorseq	r3, r7, pc, lsr #2

00008f70 <_ZL13Lock_Unlocked>:
    8f70:	00000000 	andeq	r0, r0, r0

00008f74 <_ZL11Lock_Locked>:
    8f74:	00000001 	andeq	r0, r0, r1

00008f78 <_ZL21MaxFSDriverNameLength>:
    8f78:	00000010 	andeq	r0, r0, r0, lsl r0

00008f7c <_ZL17MaxFilenameLength>:
    8f7c:	00000010 	andeq	r0, r0, r0, lsl r0

00008f80 <_ZL13MaxPathLength>:
    8f80:	00000080 	andeq	r0, r0, r0, lsl #1

00008f84 <_ZL18NoFilesystemDriver>:
    8f84:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f88 <_ZL9NotifyAll>:
    8f88:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f8c <_ZL24Max_Process_Opened_Files>:
    8f8c:	00000010 	andeq	r0, r0, r0, lsl r0

00008f90 <_ZL10Indefinite>:
    8f90:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f94 <_ZL18Deadline_Unchanged>:
    8f94:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008f98 <_ZL14Invalid_Handle>:
    8f98:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f9c <_ZL16Pipe_File_Prefix>:
    8f9c:	3a535953 	bcc	14df4f0 <__bss_end+0x14d6524>
    8fa0:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    8fa4:	0000002f 	andeq	r0, r0, pc, lsr #32

00008fa8 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    8fa8:	33323130 	teqcc	r2, #48, 2
    8fac:	37363534 			; <UNDEFINED> instruction: 0x37363534
    8fb0:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    8fb4:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00008fbc <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1684860>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x39458>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3d06c>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c7d58>
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
 130:	6b69746e 	blvs	1a5d2f0 <__bss_end+0x1a54324>
 134:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
 138:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 13c:	4f54522d 	svcmi	0x0054522d
 140:	616d2d53 	cmnvs	sp, r3, asr sp
 144:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 148:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe21 <__bss_end+0xffff6e55>
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
 180:	0a030000 	beq	c0188 <__bss_end+0xb71bc>
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
 1d4:	6a0d05a1 	bvs	341860 <__bss_end+0x338894>
 1d8:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
 1dc:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 1e0:	04020004 	streq	r0, [r2], #-4
 1e4:	0b058302 	bleq	160df4 <__bss_end+0x157e28>
 1e8:	02040200 	andeq	r0, r4, #0, 4
 1ec:	0002054a 	andeq	r0, r2, sl, asr #10
 1f0:	2d020402 	cfstrscs	mvf0, [r2, #-8]
 1f4:	05850905 	streq	r0, [r5, #2309]	; 0x905
 1f8:	0a022f01 	beq	8be04 <__bss_end+0x82e38>
 1fc:	8d010100 	stfhis	f0, [r1, #-0]
 200:	03000002 	movweq	r0, #2
 204:	00020500 	andeq	r0, r2, r0, lsl #10
 208:	fb010200 	blx	40a12 <__bss_end+0x37a46>
 20c:	01000d0e 	tsteq	r0, lr, lsl #26
 210:	00010101 	andeq	r0, r1, r1, lsl #2
 214:	00010000 	andeq	r0, r1, r0
 218:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 21c:	2f656d6f 	svccs	0x00656d6f
 220:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
 224:	642f6b69 	strtvs	r6, [pc], #-2921	; 22c <shift+0x22c>
 228:	4b2f7665 	blmi	bddbc4 <__bss_end+0xbd4bf8>
 22c:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 230:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
 234:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
 238:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
 23c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 240:	752f7365 	strvc	r7, [pc, #-869]!	; fffffee3 <__bss_end+0xffff6f17>
 244:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 248:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 24c:	756f632f 	strbvc	r6, [pc, #-815]!	; ffffff25 <__bss_end+0xffff6f59>
 250:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
 254:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
 258:	682f006b 	stmdavs	pc!, {r0, r1, r3, r5, r6}	; <UNPREDICTABLE>
 25c:	2f656d6f 	svccs	0x00656d6f
 260:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
 264:	642f6b69 	strtvs	r6, [pc], #-2921	; 26c <shift+0x26c>
 268:	4b2f7665 	blmi	bddc04 <__bss_end+0xbd4c38>
 26c:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 270:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
 274:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
 278:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
 27c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 280:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff23 <__bss_end+0xffff6f57>
 284:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 288:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 28c:	2f2e2e2f 	svccs	0x002e2e2f
 290:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 294:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 298:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 29c:	702f6564 	eorvc	r6, pc, r4, ror #10
 2a0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 2a4:	2f007373 	svccs	0x00007373
 2a8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 2ac:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 2b0:	2f6b6974 	svccs	0x006b6974
 2b4:	2f766564 	svccs	0x00766564
 2b8:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 2bc:	534f5452 	movtpl	r5, #62546	; 0xf452
 2c0:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 2c4:	2f726574 	svccs	0x00726574
 2c8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 2cc:	2f736563 	svccs	0x00736563
 2d0:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 2d4:	63617073 	cmnvs	r1, #115	; 0x73
 2d8:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 2dc:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 2e0:	2f6c656e 	svccs	0x006c656e
 2e4:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 2e8:	2f656475 	svccs	0x00656475
 2ec:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 2f0:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 2f4:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 2f8:	2f006c61 	svccs	0x00006c61
 2fc:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 300:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 304:	2f6b6974 	svccs	0x006b6974
 308:	2f766564 	svccs	0x00766564
 30c:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 310:	534f5452 	movtpl	r5, #62546	; 0xf452
 314:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 318:	2f726574 	svccs	0x00726574
 31c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 320:	2f736563 	svccs	0x00736563
 324:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 328:	63617073 	cmnvs	r1, #115	; 0x73
 32c:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 330:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 334:	2f6c656e 	svccs	0x006c656e
 338:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 33c:	2f656475 	svccs	0x00656475
 340:	2f007366 	svccs	0x00007366
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
 388:	76697264 	strbtvc	r7, [r9], -r4, ror #4
 38c:	00737265 	rsbseq	r7, r3, r5, ror #4
 390:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
 394:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 398:	00010070 	andeq	r0, r1, r0, ror r0
 39c:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 3a0:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 3a4:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 3a8:	66656474 			; <UNDEFINED> instruction: 0x66656474
 3ac:	0300682e 	movweq	r6, #2094	; 0x82e
 3b0:	70730000 	rsbsvc	r0, r3, r0
 3b4:	6f6c6e69 	svcvs	0x006c6e69
 3b8:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 3bc:	00000200 	andeq	r0, r0, r0, lsl #4
 3c0:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 3c4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 3c8:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 3cc:	00000400 	andeq	r0, r0, r0, lsl #8
 3d0:	636f7270 	cmnvs	pc, #112, 4
 3d4:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 3d8:	00020068 	andeq	r0, r2, r8, rrx
 3dc:	6f727000 	svcvs	0x00727000
 3e0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 3e4:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 3e8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 3ec:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 3f0:	65700000 	ldrbvs	r0, [r0, #-0]!
 3f4:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
 3f8:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
 3fc:	00682e73 	rsbeq	r2, r8, r3, ror lr
 400:	67000003 	strvs	r0, [r0, -r3]
 404:	2e6f6970 			; <UNDEFINED> instruction: 0x2e6f6970
 408:	00050068 	andeq	r0, r5, r8, rrx
 40c:	01050000 	mrseq	r0, (UNDEF: 5)
 410:	34020500 	strcc	r0, [r2], #-1280	; 0xfffffb00
 414:	03000082 	movweq	r0, #130	; 0x82
 418:	1e050110 	fltnes	f5, r0
 41c:	0583839f 	streq	r8, [r3, #927]	; 0x39f
 420:	0705840f 	streq	r8, [r5, -pc, lsl #8]
 424:	13054b4b 	movwne	r4, #23371	; 0x5b4b
 428:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
 42c:	00660601 	rsbeq	r0, r6, r1, lsl #12
 430:	4a020402 	bmi	81440 <__bss_end+0x78474>
 434:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 438:	0608052e 	streq	r0, [r8], -lr, lsr #10
 43c:	4c07054e 	cfstr32mi	mvfx0, [r7], {78}	; 0x4e
 440:	059f1405 	ldreq	r1, [pc, #1029]	; 84d <shift+0x84d>
 444:	07052e0d 	streq	r2, [r5, -sp, lsl #28]
 448:	9f0f0584 	svcls	0x000f0584
 44c:	052e0805 	streq	r0, [lr, #-2053]!	; 0xfffff7fb
 450:	0b058403 	bleq	161464 <__bss_end+0x158498>
 454:	18058467 	stmdane	r5, {r0, r1, r2, r5, r6, sl, pc}
 458:	080d0568 	stmdaeq	sp, {r3, r5, r6, r8, sl}
 45c:	66070520 	strvs	r0, [r7], -r0, lsr #10
 460:	a02f0805 	eorge	r0, pc, r5, lsl #16
 464:	01040200 	mrseq	r0, R12_usr
 468:	02006606 	andeq	r6, r0, #6291456	; 0x600000
 46c:	004a0204 	subeq	r0, sl, r4, lsl #4
 470:	2e040402 	cdpcs	4, 0, cr0, cr4, cr2, {0}
 474:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
 478:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 47c:	02004a06 	andeq	r4, r0, #24576	; 0x6000
 480:	052e0804 	streq	r0, [lr, #-2052]!	; 0xfffff7fc
 484:	04020002 	streq	r0, [r2], #-2
 488:	02670608 	rsbeq	r0, r7, #8, 12	; 0x800000
 48c:	0101000a 	tsteq	r1, sl
 490:	000002a3 	andeq	r0, r0, r3, lsr #5
 494:	016d0003 	cmneq	sp, r3
 498:	01020000 	mrseq	r0, (UNDEF: 2)
 49c:	000d0efb 	strdeq	r0, [sp], -fp
 4a0:	01010101 	tsteq	r1, r1, lsl #2
 4a4:	01000000 	mrseq	r0, (UNDEF: 0)
 4a8:	2f010000 	svccs	0x00010000
 4ac:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 4b0:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 4b4:	2f6b6974 	svccs	0x006b6974
 4b8:	2f766564 	svccs	0x00766564
 4bc:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 4c0:	534f5452 	movtpl	r5, #62546	; 0xf452
 4c4:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 4c8:	2f726574 	svccs	0x00726574
 4cc:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 4d0:	2f736563 	svccs	0x00736563
 4d4:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
 4d8:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
 4dc:	2f006372 	svccs	0x00006372
 4e0:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 4e4:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 4e8:	2f6b6974 	svccs	0x006b6974
 4ec:	2f766564 	svccs	0x00766564
 4f0:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 4f4:	534f5452 	movtpl	r5, #62546	; 0xf452
 4f8:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 4fc:	2f726574 	svccs	0x00726574
 500:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 504:	2f736563 	svccs	0x00736563
 508:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 50c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 510:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 514:	702f6564 	eorvc	r6, pc, r4, ror #10
 518:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 51c:	2f007373 	svccs	0x00007373
 520:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 524:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
 528:	2f6b6974 	svccs	0x006b6974
 52c:	2f766564 	svccs	0x00766564
 530:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
 534:	534f5452 	movtpl	r5, #62546	; 0xf452
 538:	73616d2d 	cmnvc	r1, #2880	; 0xb40
 53c:	2f726574 	svccs	0x00726574
 540:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 544:	2f736563 	svccs	0x00736563
 548:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 54c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 550:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 554:	662f6564 	strtvs	r6, [pc], -r4, ror #10
 558:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 55c:	2f656d6f 	svccs	0x00656d6f
 560:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
 564:	642f6b69 	strtvs	r6, [pc], #-2921	; 56c <shift+0x56c>
 568:	4b2f7665 	blmi	bddf04 <__bss_end+0xbd4f38>
 56c:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 570:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
 574:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
 578:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
 57c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 580:	6b2f7365 	blvs	bdd31c <__bss_end+0xbd4350>
 584:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 588:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 58c:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 590:	6f622f65 	svcvs	0x00622f65
 594:	2f647261 	svccs	0x00647261
 598:	30697072 	rsbcc	r7, r9, r2, ror r0
 59c:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 5a0:	74730000 	ldrbtvc	r0, [r3], #-0
 5a4:	6c696664 	stclvs	6, cr6, [r9], #-400	; 0xfffffe70
 5a8:	70632e65 	rsbvc	r2, r3, r5, ror #28
 5ac:	00010070 	andeq	r0, r1, r0, ror r0
 5b0:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 5b4:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 5b8:	70730000 	rsbsvc	r0, r3, r0
 5bc:	6f6c6e69 	svcvs	0x006c6e69
 5c0:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 5c4:	00000200 	andeq	r0, r0, r0, lsl #4
 5c8:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 5cc:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 5d0:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 5d4:	00000300 	andeq	r0, r0, r0, lsl #6
 5d8:	636f7270 	cmnvs	pc, #112, 4
 5dc:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 5e0:	00020068 	andeq	r0, r2, r8, rrx
 5e4:	6f727000 	svcvs	0x00727000
 5e8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 5ec:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 5f0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 5f4:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 5f8:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 5fc:	66656474 			; <UNDEFINED> instruction: 0x66656474
 600:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 604:	05000000 	streq	r0, [r0, #-0]
 608:	02050001 	andeq	r0, r5, #1
 60c:	000083c8 	andeq	r8, r0, r8, asr #7
 610:	691a0516 	ldmdbvs	sl, {r1, r2, r4, r8, sl}
 614:	052f2c05 	streq	r2, [pc, #-3077]!	; fffffa17 <__bss_end+0xffff6a4b>
 618:	01054c0c 	tsteq	r5, ip, lsl #24
 61c:	3205852f 	andcc	r8, r5, #197132288	; 0xbc00000
 620:	4b1a0583 	blmi	681c34 <__bss_end+0x678c68>
 624:	852f0105 	strhi	r0, [pc, #-261]!	; 527 <shift+0x527>
 628:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 62c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 630:	2e05a132 	mcrcs	1, 0, sl, cr5, cr2, {1}
 634:	4b1b054b 	blmi	6c1b68 <__bss_end+0x6b8b9c>
 638:	052f2d05 	streq	r2, [pc, #-3333]!	; fffff93b <__bss_end+0xffff696f>
 63c:	01054c0c 	tsteq	r5, ip, lsl #24
 640:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 644:	4b3005bd 	blmi	c01d40 <__bss_end+0xbf8d74>
 648:	054b2e05 	strbeq	r2, [fp, #-3589]	; 0xfffff1fb
 64c:	2e054b1b 	vmovcs.32	d5[0], r4
 650:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 654:	852f0105 	strhi	r0, [pc, #-261]!	; 557 <shift+0x557>
 658:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
 65c:	2e054b30 	vmovcs.16	d5[0], r4
 660:	4b1b054b 	blmi	6c1b94 <__bss_end+0x6b8bc8>
 664:	052f2e05 	streq	r2, [pc, #-3589]!	; fffff867 <__bss_end+0xffff689b>
 668:	01054c0c 	tsteq	r5, ip, lsl #24
 66c:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 670:	4b1b0583 	blmi	6c1c84 <__bss_end+0x6b8cb8>
 674:	852f0105 	strhi	r0, [pc, #-261]!	; 577 <shift+0x577>
 678:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
 67c:	2f054b33 	svccs	0x00054b33
 680:	4b1b054b 	blmi	6c1bb4 <__bss_end+0x6b8be8>
 684:	052f3005 	streq	r3, [pc, #-5]!	; 687 <shift+0x687>
 688:	01054c0c 	tsteq	r5, ip, lsl #24
 68c:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 690:	4b2f05a1 	blmi	bc1d1c <__bss_end+0xbb8d50>
 694:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 698:	0c052f2f 	stceq	15, cr2, [r5], {47}	; 0x2f
 69c:	2f01054c 	svccs	0x0001054c
 6a0:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 6a4:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
 6a8:	1b054b3b 	blne	15339c <__bss_end+0x14a3d0>
 6ac:	2f30054b 	svccs	0x0030054b
 6b0:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 6b4:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6b8:	3b05a12f 	blcc	168b7c <__bss_end+0x15fbb0>
 6bc:	4b1a054b 	blmi	681bf0 <__bss_end+0x678c24>
 6c0:	052f3005 	streq	r3, [pc, #-5]!	; 6c3 <shift+0x6c3>
 6c4:	01054c0c 	tsteq	r5, ip, lsl #24
 6c8:	2005859f 	mulcs	r5, pc, r5	; <UNPREDICTABLE>
 6cc:	4d2d0567 	cfstr32mi	mvfx0, [sp, #-412]!	; 0xfffffe64
 6d0:	054b3105 	strbeq	r3, [fp, #-261]	; 0xfffffefb
 6d4:	0c054b1a 			; <UNDEFINED> instruction: 0x0c054b1a
 6d8:	2f010530 	svccs	0x00010530
 6dc:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 6e0:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
 6e4:	1a054b31 	bne	1533b0 <__bss_end+0x14a3e4>
 6e8:	300c054b 	andcc	r0, ip, fp, asr #10
 6ec:	852f0105 	strhi	r0, [pc, #-261]!	; 5ef <shift+0x5ef>
 6f0:	05832005 	streq	r2, [r3, #5]
 6f4:	3e054c2d 	cdpcc	12, 0, cr4, cr5, cr13, {1}
 6f8:	4b1a054b 	blmi	681c2c <__bss_end+0x678c60>
 6fc:	852f0105 	strhi	r0, [pc, #-261]!	; 5ff <shift+0x5ff>
 700:	05672005 	strbeq	r2, [r7, #-5]!
 704:	30054d2d 	andcc	r4, r5, sp, lsr #26
 708:	4b1a054b 	blmi	681c3c <__bss_end+0x678c70>
 70c:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 710:	05872f01 	streq	r2, [r7, #3841]	; 0xf01
 714:	059fa00c 	ldreq	sl, [pc, #12]	; 728 <shift+0x728>
 718:	2905bc31 	stmdbcs	r5, {r0, r4, r5, sl, fp, ip, sp, pc}
 71c:	2e360566 	cdpcs	5, 3, cr0, cr6, cr6, {3}
 720:	05300f05 	ldreq	r0, [r0, #-3845]!	; 0xfffff0fb
 724:	09056613 	stmdbeq	r5, {r0, r1, r4, r9, sl, sp, lr}
 728:	d8100584 	ldmdale	r0, {r2, r7, r8, sl}
 72c:	059e3305 	ldreq	r3, [lr, #773]	; 0x305
 730:	08022f01 	stmdaeq	r2, {r0, r8, r9, sl, fp, sp}
 734:	32010100 	andcc	r0, r1, #0, 2
 738:	03000002 	movweq	r0, #2
 73c:	00005800 	andeq	r5, r0, r0, lsl #16
 740:	fb010200 	blx	40f4a <__bss_end+0x37f7e>
 744:	01000d0e 	tsteq	r0, lr, lsl #26
 748:	00010101 	andeq	r0, r1, r1, lsl #2
 74c:	00010000 	andeq	r0, r1, r0
 750:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 754:	2f656d6f 	svccs	0x00656d6f
 758:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
 75c:	642f6b69 	strtvs	r6, [pc], #-2921	; 764 <shift+0x764>
 760:	4b2f7665 	blmi	bde0fc <__bss_end+0xbd5130>
 764:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 768:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
 76c:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
 770:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
 774:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 778:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
 77c:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 780:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
 784:	73000063 	movwvc	r0, #99	; 0x63
 788:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
 78c:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
 790:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 794:	00000100 	andeq	r0, r0, r0, lsl #2
 798:	00010500 	andeq	r0, r1, r0, lsl #10
 79c:	88280205 	stmdahi	r8!, {r0, r2, r9}
 7a0:	051a0000 	ldreq	r0, [sl, #-0]
 7a4:	0f05bb06 	svceq	0x0005bb06
 7a8:	6821054c 	stmdavs	r1!, {r2, r3, r6, r8, sl}
 7ac:	05ba0b05 	ldreq	r0, [sl, #2821]!	; 0xb05
 7b0:	0d056627 	stceq	6, cr6, [r5, #-156]	; 0xffffff64
 7b4:	2f09054a 	svccs	0x0009054a
 7b8:	059f0405 	ldreq	r0, [pc, #1029]	; bc5 <shift+0xbc5>
 7bc:	05056202 	streq	r6, [r5, #-514]	; 0xfffffdfe
 7c0:	68110535 	ldmdavs	r1, {r0, r2, r4, r5, r8, sl}
 7c4:	05662205 	strbeq	r2, [r6, #-517]!	; 0xfffffdfb
 7c8:	0a052e13 	beq	14c01c <__bss_end+0x143050>
 7cc:	0c05692f 			; <UNDEFINED> instruction: 0x0c05692f
 7d0:	4b030566 	blmi	c1d70 <__bss_end+0xb8da4>
 7d4:	05680b05 	strbeq	r0, [r8, #-2821]!	; 0xfffff4fb
 7d8:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 7dc:	14054a03 	strne	r4, [r5], #-2563	; 0xfffff5fd
 7e0:	03040200 	movweq	r0, #16896	; 0x4200
 7e4:	0015059e 	mulseq	r5, lr, r5
 7e8:	68020402 	stmdavs	r2, {r1, sl}
 7ec:	02001805 	andeq	r1, r0, #327680	; 0x50000
 7f0:	05820204 	streq	r0, [r2, #516]	; 0x204
 7f4:	04020008 	streq	r0, [r2], #-8
 7f8:	1b054a02 	blne	153008 <__bss_end+0x14a03c>
 7fc:	02040200 	andeq	r0, r4, #0, 4
 800:	000c054b 	andeq	r0, ip, fp, asr #10
 804:	66020402 	strvs	r0, [r2], -r2, lsl #8
 808:	02000f05 	andeq	r0, r0, #5, 30
 80c:	05820204 	streq	r0, [r2, #516]	; 0x204
 810:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
 814:	11054a02 	tstne	r5, r2, lsl #20
 818:	02040200 	andeq	r0, r4, #0, 4
 81c:	000b052e 	andeq	r0, fp, lr, lsr #10
 820:	2f020402 	svccs	0x00020402
 824:	02000d05 	andeq	r0, r0, #320	; 0x140
 828:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 82c:	04020002 	streq	r0, [r2], #-2
 830:	01054602 	tsteq	r5, r2, lsl #12
 834:	06058588 	streq	r8, [r5], -r8, lsl #11
 838:	4c090583 	cfstr32mi	mvfx0, [r9], {131}	; 0x83
 83c:	054a1005 	strbeq	r1, [sl, #-5]
 840:	07054c0a 	streq	r4, [r5, -sl, lsl #24]
 844:	4a0305bb 	bmi	c1f38 <__bss_end+0xb8f6c>
 848:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 84c:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 850:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 854:	0d054a01 	vstreq	s8, [r5, #-4]
 858:	4a14054d 	bmi	501d94 <__bss_end+0x4f8dc8>
 85c:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
 860:	02056808 	andeq	r6, r5, #8, 16	; 0x80000
 864:	05667803 	strbeq	r7, [r6, #-2051]!	; 0xfffff7fd
 868:	2e0b0309 	cdpcs	3, 0, cr0, cr11, cr9, {0}
 86c:	852f0105 	strhi	r0, [pc, #-261]!	; 76f <shift+0x76f>
 870:	05bd0905 	ldreq	r0, [sp, #2309]!	; 0x905
 874:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
 878:	1e054a04 	vmlane.f32	s8, s10, s8
 87c:	02040200 	andeq	r0, r4, #0, 4
 880:	00160582 	andseq	r0, r6, r2, lsl #11
 884:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 888:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
 88c:	054b0304 	strbeq	r0, [fp, #-772]	; 0xfffffcfc
 890:	04020009 	streq	r0, [r2], #-9
 894:	12056603 	andne	r6, r5, #3145728	; 0x300000
 898:	03040200 	movweq	r0, #16896	; 0x4200
 89c:	000b0566 	andeq	r0, fp, r6, ror #10
 8a0:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 8a4:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 8a8:	052d0304 	streq	r0, [sp, #-772]!	; 0xfffffcfc
 8ac:	0402000b 	streq	r0, [r2], #-11
 8b0:	09058402 	stmdbeq	r5, {r1, sl, pc}
 8b4:	01040200 	mrseq	r0, R12_usr
 8b8:	000b0583 	andeq	r0, fp, r3, lsl #11
 8bc:	66010402 	strvs	r0, [r1], -r2, lsl #8
 8c0:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 8c4:	05490104 	strbeq	r0, [r9, #-260]	; 0xfffffefc
 8c8:	0105850b 	tsteq	r5, fp, lsl #10
 8cc:	0e05852f 	cfsh32eq	mvfx8, mvfx5, #31
 8d0:	661105bc 			; <UNDEFINED> instruction: 0x661105bc
 8d4:	05bc2005 	ldreq	r2, [ip, #5]!
 8d8:	1f05660b 	svcne	0x0005660b
 8dc:	660a054b 	strvs	r0, [sl], -fp, asr #10
 8e0:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
 8e4:	16058314 			; <UNDEFINED> instruction: 0x16058314
 8e8:	4b08054a 	blmi	201e18 <__bss_end+0x1f8e4c>
 8ec:	05671105 	strbeq	r1, [r7, #-261]!	; 0xfffffefb
 8f0:	01054d0b 	tsteq	r5, fp, lsl #26
 8f4:	0605852f 	streq	r8, [r5], -pc, lsr #10
 8f8:	4c0c0583 	cfstr32mi	mvfx0, [ip], {131}	; 0x83
 8fc:	05820e05 	streq	r0, [r2, #3589]	; 0xe05
 900:	02054b04 	andeq	r4, r5, #4, 22	; 0x1000
 904:	31090565 	tstcc	r9, r5, ror #10
 908:	852f0105 	strhi	r0, [pc, #-261]!	; 80b <shift+0x80b>
 90c:	059f0805 	ldreq	r0, [pc, #2053]	; 1119 <shift+0x1119>
 910:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
 914:	03040200 	movweq	r0, #16896	; 0x4200
 918:	0008054a 	andeq	r0, r8, sl, asr #10
 91c:	83020402 	movwhi	r0, #9218	; 0x2402
 920:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 924:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 928:	04020002 	streq	r0, [r2], #-2
 92c:	01054902 	tsteq	r5, r2, lsl #18
 930:	0e058584 	cfsh32eq	mvfx8, mvfx5, #-60
 934:	4b0805bb 	blmi	202028 <__bss_end+0x1f905c>
 938:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
 93c:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 940:	17054a03 	strne	r4, [r5, -r3, lsl #20]
 944:	02040200 	andeq	r0, r4, #0, 4
 948:	000b0583 	andeq	r0, fp, r3, lsl #11
 94c:	66020402 	strvs	r0, [r2], -r2, lsl #8
 950:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 954:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 958:	0402000d 	streq	r0, [r2], #-13
 95c:	02052e02 	andeq	r2, r5, #2, 28
 960:	02040200 	andeq	r0, r4, #0, 4
 964:	8401052d 	strhi	r0, [r1], #-1325	; 0xfffffad3
 968:	01000802 	tsteq	r0, r2, lsl #16
 96c:	00007901 	andeq	r7, r0, r1, lsl #18
 970:	46000300 	strmi	r0, [r0], -r0, lsl #6
 974:	02000000 	andeq	r0, r0, #0
 978:	0d0efb01 	vstreq	d15, [lr, #-4]
 97c:	01010100 	mrseq	r0, (UNDEF: 17)
 980:	00000001 	andeq	r0, r0, r1
 984:	01000001 	tsteq	r0, r1
 988:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 98c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 990:	2f2e2e2f 	svccs	0x002e2e2f
 994:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 998:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 99c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 9a0:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
 9a4:	2f676966 	svccs	0x00676966
 9a8:	006d7261 	rsbeq	r7, sp, r1, ror #4
 9ac:	62696c00 	rsbvs	r6, r9, #0, 24
 9b0:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
 9b4:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
 9b8:	00000100 	andeq	r0, r0, r0, lsl #2
 9bc:	02050000 	andeq	r0, r5, #0
 9c0:	00008ce0 	andeq	r8, r0, r0, ror #25
 9c4:	0108fd03 	tsteq	r8, r3, lsl #26	; <UNPREDICTABLE>
 9c8:	2f2f2f30 	svccs	0x002f2f30
 9cc:	02302f2f 	eorseq	r2, r0, #47, 30	; 0xbc
 9d0:	2f1401d0 	svccs	0x001401d0
 9d4:	302f2f31 	eorcc	r2, pc, r1, lsr pc	; <UNPREDICTABLE>
 9d8:	03322f4c 	teqeq	r2, #76, 30	; 0x130
 9dc:	2f2f661f 	svccs	0x002f661f
 9e0:	2f2f2f2f 	svccs	0x002f2f2f
 9e4:	0002022f 	andeq	r0, r2, pc, lsr #4
 9e8:	005c0101 	subseq	r0, ip, r1, lsl #2
 9ec:	00030000 	andeq	r0, r3, r0
 9f0:	00000046 	andeq	r0, r0, r6, asr #32
 9f4:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 9f8:	0101000d 	tsteq	r1, sp
 9fc:	00000101 	andeq	r0, r0, r1, lsl #2
 a00:	00000100 	andeq	r0, r0, r0, lsl #2
 a04:	2f2e2e01 	svccs	0x002e2e01
 a08:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a0c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a10:	2f2e2e2f 	svccs	0x002e2e2f
 a14:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 964 <shift+0x964>
 a18:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 a1c:	6f632f63 	svcvs	0x00632f63
 a20:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 a24:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 a28:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 a2c:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
 a30:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
 a34:	00010053 	andeq	r0, r1, r3, asr r0
 a38:	05000000 	streq	r0, [r0, #-0]
 a3c:	008eec02 	addeq	lr, lr, r2, lsl #24
 a40:	0be70300 	bleq	ff9c1648 <__bss_end+0xff9b867c>
 a44:	00020201 	andeq	r0, r2, r1, lsl #4
 a48:	01030101 	tsteq	r3, r1, lsl #2
 a4c:	00030000 	andeq	r0, r3, r0
 a50:	000000fd 	strdeq	r0, [r0], -sp
 a54:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 a58:	0101000d 	tsteq	r1, sp
 a5c:	00000101 	andeq	r0, r0, r1, lsl #2
 a60:	00000100 	andeq	r0, r0, r0, lsl #2
 a64:	2f2e2e01 	svccs	0x002e2e01
 a68:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a6c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a70:	2f2e2e2f 	svccs	0x002e2e2f
 a74:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 9c4 <shift+0x9c4>
 a78:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 a7c:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
 a80:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 a84:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 a88:	2f2e2e00 	svccs	0x002e2e00
 a8c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a90:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a94:	2f2e2e2f 	svccs	0x002e2e2f
 a98:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
 a9c:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
 aa0:	2f2e2e2f 	svccs	0x002e2e2f
 aa4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 aa8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 aac:	2f2e2e2f 	svccs	0x002e2e2f
 ab0:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 ab4:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
 ab8:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
 abc:	6f632f63 	svcvs	0x00632f63
 ac0:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 ac4:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 ac8:	2f2e2e00 	svccs	0x002e2e00
 acc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 ad0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 ad4:	2f2e2e2f 	svccs	0x002e2e2f
 ad8:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; a28 <shift+0xa28>
 adc:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 ae0:	68000063 	stmdavs	r0, {r0, r1, r5, r6}
 ae4:	74687361 	strbtvc	r7, [r8], #-865	; 0xfffffc9f
 ae8:	682e6261 	stmdavs	lr!, {r0, r5, r6, r9, sp, lr}
 aec:	00000100 	andeq	r0, r0, r0, lsl #2
 af0:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 af4:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
 af8:	00020068 	andeq	r0, r2, r8, rrx
 afc:	6d726100 	ldfvse	f6, [r2, #-0]
 b00:	7570632d 	ldrbvc	r6, [r0, #-813]!	; 0xfffffcd3
 b04:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 b08:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 b0c:	632d6e73 			; <UNDEFINED> instruction: 0x632d6e73
 b10:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
 b14:	73746e61 	cmnvc	r4, #1552	; 0x610
 b18:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 b1c:	72610000 	rsbvc	r0, r1, #0
 b20:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 b24:	6c000003 	stcvs	0, cr0, [r0], {3}
 b28:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 b2c:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
 b30:	00000400 	andeq	r0, r0, r0, lsl #8
 b34:	2d6c6267 	sfmcs	f6, 2, [ip, #-412]!	; 0xfffffe64
 b38:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
 b3c:	00682e73 	rsbeq	r2, r8, r3, ror lr
 b40:	6c000004 	stcvs	0, cr0, [r0], {4}
 b44:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 b48:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
 b4c:	00000400 	andeq	r0, r0, r0, lsl #8
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
      58:	1ce50704 	stclne	7, cr0, [r5], #16
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
      b0:	0b010000 	bleq	400b8 <__bss_end+0x370ec>
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
     11c:	1ce50704 	stclne	7, cr0, [r5], #16
     120:	7a080000 	bvc	200128 <__bss_end+0x1f715c>
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
     15c:	3a010000 	bcc	40164 <__bss_end+0x37198>
     160:	00007615 	andeq	r7, r0, r5, lsl r6
     164:	01dc0900 	bicseq	r0, ip, r0, lsl #18
     168:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
     16c:	0000cb10 	andeq	ip, r0, r0, lsl fp
     170:	0081dc00 	addeq	sp, r1, r0, lsl #24
     174:	00005800 	andeq	r5, r0, r0, lsl #16
     178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f75b4>
     17c:	0a000000 	beq	184 <shift+0x184>
     180:	000001ea 	andeq	r0, r0, sl, ror #3
     184:	d20c4a01 	andle	r4, ip, #4096	; 0x1000
     188:	02000000 	andeq	r0, r0, #0
     18c:	0b007491 	bleq	1d3d8 <__bss_end+0x1440c>
     190:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     194:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
     198:	00000038 	andeq	r0, r0, r8, lsr r0
     19c:	00036d09 	andeq	r6, r3, r9, lsl #26
     1a0:	103c0100 	eorsne	r0, ip, r0, lsl #2
     1a4:	000000cb 	andeq	r0, r0, fp, asr #1
     1a8:	00008184 	andeq	r8, r0, r4, lsl #3
     1ac:	00000058 	andeq	r0, r0, r8, asr r0
     1b0:	01029c01 	tsteq	r2, r1, lsl #24
     1b4:	ea0a0000 	b	2801bc <__bss_end+0x2771f0>
     1b8:	01000001 	tsteq	r0, r1
     1bc:	01020c3e 	tsteq	r2, lr, lsr ip
     1c0:	91020000 	mrsls	r0, (UNDEF: 2)
     1c4:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
     1c8:	00000025 	andeq	r0, r0, r5, lsr #32
     1cc:	0001c50c 	andeq	ip, r1, ip, lsl #10
     1d0:	11290100 			; <UNDEFINED> instruction: 0x11290100
     1d4:	00008178 	andeq	r8, r0, r8, ror r1
     1d8:	0000000c 	andeq	r0, r0, ip
     1dc:	fb0c9c01 	blx	3271ea <__bss_end+0x31e21e>
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
     254:	cb110a01 	blgt	442a60 <__bss_end+0x439a94>
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
     2bc:	0a010067 	beq	40460 <__bss_end+0x37494>
     2c0:	00019e2f 	andeq	r9, r1, pc, lsr #28
     2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     2c8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     2cc:	00040000 	andeq	r0, r4, r0
     2d0:	000001c6 	andeq	r0, r0, r6, asr #3
     2d4:	02650104 	rsbeq	r0, r5, #4, 2
     2d8:	37040000 	strcc	r0, [r4, -r0]
     2dc:	3a00000e 	bcc	31c <shift+0x31c>
     2e0:	34000000 	strcc	r0, [r0], #-0
     2e4:	94000082 	strls	r0, [r0], #-130	; 0xffffff7e
     2e8:	ff000001 			; <UNDEFINED> instruction: 0xff000001
     2ec:	02000001 	andeq	r0, r0, #1
     2f0:	0d6f0801 	stcleq	8, cr0, [pc, #-4]!	; 2f4 <shift+0x2f4>
     2f4:	25030000 	strcs	r0, [r3, #-0]
     2f8:	02000000 	andeq	r0, r0, #0
     2fc:	0de30502 	cfstr64eq	mvdx0, [r3, #8]!
     300:	04040000 	streq	r0, [r4], #-0
     304:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     308:	08010200 	stmdaeq	r1, {r9}
     30c:	00000d66 	andeq	r0, r0, r6, ror #26
     310:	01070202 	tsteq	r7, r2, lsl #4
     314:	0500000a 	streq	r0, [r0, #-10]
     318:	00000eac 	andeq	r0, r0, ip, lsr #29
     31c:	5e1e0903 	vnmlspl.f16	s0, s28, s6	; <UNPREDICTABLE>
     320:	03000000 	movweq	r0, #0
     324:	0000004d 	andeq	r0, r0, sp, asr #32
     328:	e5070402 	str	r0, [r7, #-1026]	; 0xfffffbfe
     32c:	0300001c 	movweq	r0, #28
     330:	0000005e 	andeq	r0, r0, lr, asr r0
     334:	00005e06 	andeq	r5, r0, r6, lsl #28
     338:	077c0700 	ldrbeq	r0, [ip, -r0, lsl #14]!
     33c:	02080000 	andeq	r0, r8, #0
     340:	00950806 	addseq	r0, r5, r6, lsl #16
     344:	72080000 	andvc	r0, r8, #0
     348:	08020030 	stmdaeq	r2, {r4, r5}
     34c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     350:	72080000 	andvc	r0, r8, #0
     354:	09020031 	stmdbeq	r2, {r0, r4, r5}
     358:	00004d0e 	andeq	r4, r0, lr, lsl #26
     35c:	09000400 	stmdbeq	r0, {sl}
     360:	000005e4 	andeq	r0, r0, r4, ror #11
     364:	00380405 	eorseq	r0, r8, r5, lsl #8
     368:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
     36c:	0000cc0c 	andeq	ip, r0, ip, lsl #24
     370:	08310a00 	ldmdaeq	r1!, {r9, fp}
     374:	0a000000 	beq	37c <shift+0x37c>
     378:	00001294 	muleq	r0, r4, r2
     37c:	125e0a01 	subsne	r0, lr, #4096	; 0x1000
     380:	0a020000 	beq	80388 <__bss_end+0x773bc>
     384:	00000a8b 	andeq	r0, r0, fp, lsl #21
     388:	0cd70a03 	vldmiaeq	r7, {s1-s3}
     38c:	0a040000 	beq	100394 <__bss_end+0xf73c8>
     390:	000007fa 	strdeq	r0, [r0], -sl
     394:	39090005 	stmdbcc	r9, {r0, r2}
     398:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
     39c:	00003804 	andeq	r3, r0, r4, lsl #16
     3a0:	0c3f0200 	lfmeq	f0, 4, [pc], #-0	; 3a8 <shift+0x3a8>
     3a4:	00000109 	andeq	r0, r0, r9, lsl #2
     3a8:	0004630a 	andeq	r6, r4, sl, lsl #6
     3ac:	200a0000 	andcs	r0, sl, r0
     3b0:	01000006 	tsteq	r0, r6
     3b4:	000c920a 	andeq	r9, ip, sl, lsl #4
     3b8:	020a0200 	andeq	r0, sl, #0, 4
     3bc:	03000012 	movweq	r0, #18
     3c0:	00129e0a 	andseq	r9, r2, sl, lsl #28
     3c4:	b60a0400 	strlt	r0, [sl], -r0, lsl #8
     3c8:	0500000b 	streq	r0, [r0, #-11]
     3cc:	000a210a 	andeq	r2, sl, sl, lsl #2
     3d0:	05000600 	streq	r0, [r0, #-1536]	; 0xfffffa00
     3d4:	00000674 	andeq	r0, r0, r4, ror r6
     3d8:	38170304 	ldmdacc	r7, {r2, r8, r9}
     3dc:	0b000000 	bleq	3e4 <shift+0x3e4>
     3e0:	00000c0e 	andeq	r0, r0, lr, lsl #24
     3e4:	59140504 	ldmdbpl	r4, {r2, r8, sl}
     3e8:	05000000 	streq	r0, [r0, #-0]
     3ec:	008ef003 	addeq	pc, lr, r3
     3f0:	0c4a0b00 	mcrreq	11, 0, r0, sl, cr0
     3f4:	06040000 	streq	r0, [r4], -r0
     3f8:	00005914 	andeq	r5, r0, r4, lsl r9
     3fc:	f4030500 	vst3.8	{d0,d2,d4}, [r3], r0
     400:	0b00008e 	bleq	640 <shift+0x640>
     404:	00000ba0 	andeq	r0, r0, r0, lsr #23
     408:	591a0705 	ldmdbpl	sl, {r0, r2, r8, r9, sl}
     40c:	05000000 	streq	r0, [r0, #-0]
     410:	008ef803 	addeq	pc, lr, r3, lsl #16
     414:	064f0b00 	strbeq	r0, [pc], -r0, lsl #22
     418:	09050000 	stmdbeq	r5, {}	; <UNPREDICTABLE>
     41c:	0000591a 	andeq	r5, r0, sl, lsl r9
     420:	fc030500 	stc2	5, cr0, [r3], {-0}
     424:	0b00008e 	bleq	664 <shift+0x664>
     428:	00000d58 	andeq	r0, r0, r8, asr sp
     42c:	591a0b05 	ldmdbpl	sl, {r0, r2, r8, r9, fp}
     430:	05000000 	streq	r0, [r0, #-0]
     434:	008f0003 	addeq	r0, pc, r3
     438:	09db0b00 	ldmibeq	fp, {r8, r9, fp}^
     43c:	0d050000 	stceq	0, cr0, [r5, #-0]
     440:	0000591a 	andeq	r5, r0, sl, lsl r9
     444:	04030500 	streq	r0, [r3], #-1280	; 0xfffffb00
     448:	0b00008f 	bleq	68c <shift+0x68c>
     44c:	000007a2 	andeq	r0, r0, r2, lsr #15
     450:	591a0f05 	ldmdbpl	sl, {r0, r2, r8, r9, sl, fp}
     454:	05000000 	streq	r0, [r0, #-0]
     458:	008f0803 	addeq	r0, pc, r3, lsl #16
     45c:	0f0c0900 	svceq	0x000c0900
     460:	04050000 	streq	r0, [r5], #-0
     464:	00000038 	andeq	r0, r0, r8, lsr r0
     468:	b80c1b05 	stmdalt	ip, {r0, r2, r8, r9, fp, ip}
     46c:	0a000001 	beq	478 <shift+0x478>
     470:	00000f78 	andeq	r0, r0, r8, ror pc
     474:	124e0a00 	subne	r0, lr, #0, 20
     478:	0a010000 	beq	40480 <__bss_end+0x374b4>
     47c:	00000c8d 	andeq	r0, r0, sp, lsl #25
     480:	340c0002 	strcc	r0, [ip], #-2
     484:	0d00000d 	stceq	0, cr0, [r0, #-52]	; 0xffffffcc
     488:	00000dc8 	andeq	r0, r0, r8, asr #27
     48c:	07630590 			; <UNDEFINED> instruction: 0x07630590
     490:	0000032b 	andeq	r0, r0, fp, lsr #6
     494:	0011a407 	andseq	sl, r1, r7, lsl #8
     498:	67052400 	strvs	r2, [r5, -r0, lsl #8]
     49c:	00024510 	andeq	r4, r2, r0, lsl r5
     4a0:	20cd0e00 	sbccs	r0, sp, r0, lsl #28
     4a4:	69050000 	stmdbvs	r5, {}	; <UNPREDICTABLE>
     4a8:	00032b28 	andeq	r2, r3, r8, lsr #22
     4ac:	d80e0000 	stmdale	lr, {}	; <UNPREDICTABLE>
     4b0:	05000005 	streq	r0, [r0, #-5]
     4b4:	033b206b 	teqeq	fp, #107	; 0x6b
     4b8:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
     4bc:	00000f6d 	andeq	r0, r0, sp, ror #30
     4c0:	4d236d05 	stcmi	13, cr6, [r3, #-20]!	; 0xffffffec
     4c4:	14000000 	strne	r0, [r0], #-0
     4c8:	0006480e 	andeq	r4, r6, lr, lsl #16
     4cc:	1c700500 	cfldr64ne	mvdx0, [r0], #-0
     4d0:	00000342 	andeq	r0, r0, r2, asr #6
     4d4:	0d4f0e18 	stcleq	14, cr0, [pc, #-96]	; 47c <shift+0x47c>
     4d8:	72050000 	andvc	r0, r5, #0
     4dc:	0003421c 	andeq	r4, r3, ip, lsl r2
     4e0:	b50e1c00 	strlt	r1, [lr, #-3072]	; 0xfffff400
     4e4:	05000005 	streq	r0, [r0, #-5]
     4e8:	03421c75 	movteq	r1, #11381	; 0x2c75
     4ec:	0f200000 	svceq	0x00200000
     4f0:	00000843 	andeq	r0, r0, r3, asr #16
     4f4:	de1c7705 	cdple	7, 1, cr7, cr12, cr5, {0}
     4f8:	42000004 	andmi	r0, r0, #4
     4fc:	39000003 	stmdbcc	r0, {r0, r1}
     500:	10000002 	andne	r0, r0, r2
     504:	00000342 	andeq	r0, r0, r2, asr #6
     508:	00034811 	andeq	r4, r3, r1, lsl r8
     50c:	07000000 	streq	r0, [r0, -r0]
     510:	00000ded 	andeq	r0, r0, sp, ror #27
     514:	107b0518 	rsbsne	r0, fp, r8, lsl r5
     518:	0000027a 	andeq	r0, r0, sl, ror r2
     51c:	0020cd0e 	eoreq	ip, r0, lr, lsl #26
     520:	2c7e0500 	cfldr64cs	mvdx0, [lr], #-0
     524:	0000032b 	andeq	r0, r0, fp, lsr #6
     528:	05cd0e00 	strbeq	r0, [sp, #3584]	; 0xe00
     52c:	80050000 	andhi	r0, r5, r0
     530:	00034819 	andeq	r4, r3, r9, lsl r8
     534:	080e1000 	stmdaeq	lr, {ip}
     538:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
     53c:	03532182 	cmpeq	r3, #-2147483616	; 0x80000020
     540:	00140000 	andseq	r0, r4, r0
     544:	00024503 	andeq	r4, r2, r3, lsl #10
     548:	0b4c1200 	bleq	1304d50 <__bss_end+0x12fbd84>
     54c:	86050000 	strhi	r0, [r5], -r0
     550:	00035921 	andeq	r5, r3, r1, lsr #18
     554:	08f81200 	ldmeq	r8!, {r9, ip}^
     558:	88050000 	stmdahi	r5, {}	; <UNPREDICTABLE>
     55c:	0000591f 	andeq	r5, r0, pc, lsl r9
     560:	0e1f0e00 	cdpeq	14, 1, cr0, cr15, cr0, {0}
     564:	8b050000 	blhi	14056c <__bss_end+0x1375a0>
     568:	0001ca17 	andeq	ip, r1, r7, lsl sl
     56c:	910e0000 	mrsls	r0, (UNDEF: 14)
     570:	0500000a 	streq	r0, [r0, #-10]
     574:	01ca178e 	biceq	r1, sl, lr, lsl #15
     578:	0e240000 	cdpeq	0, 2, cr0, cr4, cr0, {0}
     57c:	00000963 	andeq	r0, r0, r3, ror #18
     580:	ca178f05 	bgt	5e419c <__bss_end+0x5db1d0>
     584:	48000001 	stmdami	r0, {r0}
     588:	00127e0e 	andseq	r7, r2, lr, lsl #28
     58c:	17900500 	ldrne	r0, [r0, r0, lsl #10]
     590:	000001ca 	andeq	r0, r0, sl, asr #3
     594:	0dc8136c 	stcleq	3, cr1, [r8, #432]	; 0x1b0
     598:	93050000 	movwls	r0, #20480	; 0x5000
     59c:	0006ad09 	andeq	sl, r6, r9, lsl #26
     5a0:	00036400 	andeq	r6, r3, r0, lsl #8
     5a4:	02e40100 	rsceq	r0, r4, #0, 2
     5a8:	02ea0000 	rsceq	r0, sl, #0
     5ac:	64100000 	ldrvs	r0, [r0], #-0
     5b0:	00000003 	andeq	r0, r0, r3
     5b4:	000b4114 	andeq	r4, fp, r4, lsl r1
     5b8:	0e960500 	cdpeq	5, 9, cr0, cr6, cr0, {0}
     5bc:	00000a47 	andeq	r0, r0, r7, asr #20
     5c0:	0002ff01 	andeq	pc, r2, r1, lsl #30
     5c4:	00030500 	andeq	r0, r3, r0, lsl #10
     5c8:	03641000 	cmneq	r4, #0
     5cc:	15000000 	strne	r0, [r0, #-0]
     5d0:	00000463 	andeq	r0, r0, r3, ror #8
     5d4:	f1109905 			; <UNDEFINED> instruction: 0xf1109905
     5d8:	6a00000e 	bvs	618 <shift+0x618>
     5dc:	01000003 	tsteq	r0, r3
     5e0:	0000031a 	andeq	r0, r0, sl, lsl r3
     5e4:	00036410 	andeq	r6, r3, r0, lsl r4
     5e8:	03481100 	movteq	r1, #33024	; 0x8100
     5ec:	93110000 	tstls	r1, #0
     5f0:	00000001 	andeq	r0, r0, r1
     5f4:	00251600 	eoreq	r1, r5, r0, lsl #12
     5f8:	033b0000 	teqeq	fp, #0
     5fc:	5e170000 	cdppl	0, 1, cr0, cr7, cr0, {0}
     600:	0f000000 	svceq	0x00000000
     604:	02010200 	andeq	r0, r1, #0, 4
     608:	00000aa8 	andeq	r0, r0, r8, lsr #21
     60c:	01ca0418 	biceq	r0, sl, r8, lsl r4
     610:	04180000 	ldreq	r0, [r8], #-0
     614:	0000002c 	andeq	r0, r0, ip, lsr #32
     618:	0012140c 	andseq	r1, r2, ip, lsl #8
     61c:	4e041800 	cdpmi	8, 0, cr1, cr4, cr0, {0}
     620:	16000003 	strne	r0, [r0], -r3
     624:	0000027a 	andeq	r0, r0, sl, ror r2
     628:	00000364 	andeq	r0, r0, r4, ror #6
     62c:	04180019 	ldreq	r0, [r8], #-25	; 0xffffffe7
     630:	000001bd 			; <UNDEFINED> instruction: 0x000001bd
     634:	01b80418 			; <UNDEFINED> instruction: 0x01b80418
     638:	251a0000 	ldrcs	r0, [sl, #-0]
     63c:	0500000e 	streq	r0, [r0, #-14]
     640:	01bd149c 			; <UNDEFINED> instruction: 0x01bd149c
     644:	a40b0000 	strge	r0, [fp], #-0
     648:	06000008 	streq	r0, [r0], -r8
     64c:	00591404 	subseq	r1, r9, r4, lsl #8
     650:	03050000 	movweq	r0, #20480	; 0x5000
     654:	00008f0c 	andeq	r8, r0, ip, lsl #30
     658:	0003ee0b 	andeq	lr, r3, fp, lsl #28
     65c:	14070600 	strne	r0, [r7], #-1536	; 0xfffffa00
     660:	00000059 	andeq	r0, r0, r9, asr r0
     664:	8f100305 	svchi	0x00100305
     668:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
     66c:	06000006 	streq	r0, [r0], -r6
     670:	0059140a 	subseq	r1, r9, sl, lsl #8
     674:	03050000 	movweq	r0, #20480	; 0x5000
     678:	00008f14 	andeq	r8, r0, r4, lsl pc
     67c:	000b1109 	andeq	r1, fp, r9, lsl #2
     680:	38040500 	stmdacc	r4, {r8, sl}
     684:	06000000 	streq	r0, [r0], -r0
     688:	03e90c0d 	mvneq	r0, #3328	; 0xd00
     68c:	4e1b0000 	cdpmi	0, 1, cr0, cr11, cr0, {0}
     690:	00007765 	andeq	r7, r0, r5, ror #14
     694:	000b080a 	andeq	r0, fp, sl, lsl #16
     698:	af0a0100 	svcge	0x000a0100
     69c:	02000012 	andeq	r0, r0, #18
     6a0:	000ac30a 	andeq	ip, sl, sl, lsl #6
     6a4:	7d0a0300 	stcvc	3, cr0, [sl, #-0]
     6a8:	0400000a 	streq	r0, [r0], #-10
     6ac:	000c980a 	andeq	r9, ip, sl, lsl #16
     6b0:	07000500 	streq	r0, [r0, -r0, lsl #10]
     6b4:	000007ed 	andeq	r0, r0, sp, ror #15
     6b8:	081b0610 	ldmdaeq	fp, {r4, r9, sl}
     6bc:	00000428 	andeq	r0, r0, r8, lsr #8
     6c0:	00726c08 	rsbseq	r6, r2, r8, lsl #24
     6c4:	28131d06 	ldmdacs	r3, {r1, r2, r8, sl, fp, ip}
     6c8:	00000004 	andeq	r0, r0, r4
     6cc:	00707308 	rsbseq	r7, r0, r8, lsl #6
     6d0:	28131e06 	ldmdacs	r3, {r1, r2, r9, sl, fp, ip}
     6d4:	04000004 	streq	r0, [r0], #-4
     6d8:	00637008 	rsbeq	r7, r3, r8
     6dc:	28131f06 	ldmdacs	r3, {r1, r2, r8, r9, sl, fp, ip}
     6e0:	08000004 	stmdaeq	r0, {r2}
     6e4:	0008030e 	andeq	r0, r8, lr, lsl #6
     6e8:	13200600 	nopne	{0}	; <UNPREDICTABLE>
     6ec:	00000428 	andeq	r0, r0, r8, lsr #8
     6f0:	0402000c 	streq	r0, [r2], #-12
     6f4:	001ce007 	andseq	lr, ip, r7
     6f8:	04280300 	strteq	r0, [r8], #-768	; 0xfffffd00
     6fc:	d1070000 	mrsle	r0, (UNDEF: 7)
     700:	70000004 	andvc	r0, r0, r4
     704:	c4082806 	strgt	r2, [r8], #-2054	; 0xfffff7fa
     708:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
     70c:	00001288 	andeq	r1, r0, r8, lsl #5
     710:	e9122a06 	ldmdb	r2, {r1, r2, r9, fp, sp}
     714:	00000003 	andeq	r0, r0, r3
     718:	64697008 	strbtvs	r7, [r9], #-8
     71c:	122b0600 	eorne	r0, fp, #0, 12
     720:	0000005e 	andeq	r0, r0, lr, asr r0
     724:	1abe0e10 	bne	fef83f6c <__bss_end+0xfef7afa0>
     728:	2c060000 	stccs	0, cr0, [r6], {-0}
     72c:	0003b211 	andeq	fp, r3, r1, lsl r2
     730:	1d0e1400 	cfstrsne	mvf1, [lr, #-0]
     734:	0600000b 	streq	r0, [r0], -fp
     738:	005e122d 	subseq	r1, lr, sp, lsr #4
     73c:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
     740:	00000b2b 	andeq	r0, r0, fp, lsr #22
     744:	5e122e06 	cdppl	14, 1, cr2, cr2, cr6, {0}
     748:	1c000000 	stcne	0, cr0, [r0], {-0}
     74c:	0007950e 	andeq	r9, r7, lr, lsl #10
     750:	312f0600 			; <UNDEFINED> instruction: 0x312f0600
     754:	000004c4 	andeq	r0, r0, r4, asr #9
     758:	0b580e20 	bleq	1603fe0 <__bss_end+0x15fb014>
     75c:	30060000 	andcc	r0, r6, r0
     760:	00003809 	andeq	r3, r0, r9, lsl #16
     764:	820e6000 	andhi	r6, lr, #0
     768:	0600000f 	streq	r0, [r0], -pc
     76c:	004d0e31 	subeq	r0, sp, r1, lsr lr
     770:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
     774:	00000857 	andeq	r0, r0, r7, asr r8
     778:	4d0e3306 	stcmi	3, cr3, [lr, #-24]	; 0xffffffe8
     77c:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
     780:	00084e0e 	andeq	r4, r8, lr, lsl #28
     784:	0e340600 	cfmsuba32eq	mvax0, mvax0, mvfx4, mvfx0
     788:	0000004d 	andeq	r0, r0, sp, asr #32
     78c:	6a16006c 	bvs	580944 <__bss_end+0x577978>
     790:	d4000003 	strle	r0, [r0], #-3
     794:	17000004 	strne	r0, [r0, -r4]
     798:	0000005e 	andeq	r0, r0, lr, asr r0
     79c:	950b000f 	strls	r0, [fp, #-15]
     7a0:	07000011 	smladeq	r0, r1, r0, r0
     7a4:	0059140a 	subseq	r1, r9, sl, lsl #8
     7a8:	03050000 	movweq	r0, #20480	; 0x5000
     7ac:	00008f18 	andeq	r8, r0, r8, lsl pc
     7b0:	000acb09 	andeq	ip, sl, r9, lsl #22
     7b4:	38040500 	stmdacc	r4, {r8, sl}
     7b8:	07000000 	streq	r0, [r0, -r0]
     7bc:	05050c0d 	streq	r0, [r5, #-3085]	; 0xfffff3f3
     7c0:	f90a0000 			; <UNDEFINED> instruction: 0xf90a0000
     7c4:	00000005 	andeq	r0, r0, r5
     7c8:	0003e30a 	andeq	lr, r3, sl, lsl #6
     7cc:	07000100 	streq	r0, [r0, -r0, lsl #2]
     7d0:	0000104c 	andeq	r1, r0, ip, asr #32
     7d4:	081b070c 	ldmdaeq	fp, {r2, r3, r8, r9, sl}
     7d8:	0000053a 	andeq	r0, r0, sl, lsr r5
     7dc:	0004a30e 	andeq	sl, r4, lr, lsl #6
     7e0:	191d0700 	ldmdbne	sp, {r8, r9, sl}
     7e4:	0000053a 	andeq	r0, r0, sl, lsr r5
     7e8:	05b50e00 	ldreq	r0, [r5, #3584]!	; 0xe00
     7ec:	1e070000 	cdpne	0, 0, cr0, cr7, cr0, {0}
     7f0:	00053a19 	andeq	r3, r5, r9, lsl sl
     7f4:	f60e0400 			; <UNDEFINED> instruction: 0xf60e0400
     7f8:	0700000f 	streq	r0, [r0, -pc]
     7fc:	0540131f 	strbeq	r1, [r0, #-799]	; 0xfffffce1
     800:	00080000 	andeq	r0, r8, r0
     804:	05050418 	streq	r0, [r5, #-1048]	; 0xfffffbe8
     808:	04180000 	ldreq	r0, [r8], #-0
     80c:	00000434 	andeq	r0, r0, r4, lsr r4
     810:	00069c0d 	andeq	r9, r6, sp, lsl #24
     814:	22071400 	andcs	r1, r7, #0, 8
     818:	0007c807 	andeq	ip, r7, r7, lsl #16
     81c:	0ab90e00 	beq	fee44024 <__bss_end+0xfee3b058>
     820:	26070000 	strcs	r0, [r7], -r0
     824:	00004d12 	andeq	r4, r0, r2, lsl sp
     828:	4f0e0000 	svcmi	0x000e0000
     82c:	07000005 	streq	r0, [r0, -r5]
     830:	053a1d29 	ldreq	r1, [sl, #-3369]!	; 0xfffff2d7
     834:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     838:	00000ede 	ldrdeq	r0, [r0], -lr
     83c:	3a1d2c07 	bcc	74b860 <__bss_end+0x742894>
     840:	08000005 	stmdaeq	r0, {r0, r2}
     844:	00112f1c 	andseq	r2, r1, ip, lsl pc
     848:	0e2f0700 	cdpeq	7, 2, cr0, cr15, cr0, {0}
     84c:	00001029 	andeq	r1, r0, r9, lsr #32
     850:	0000058e 	andeq	r0, r0, lr, lsl #11
     854:	00000599 	muleq	r0, r9, r5
     858:	0007cd10 	andeq	ip, r7, r0, lsl sp
     85c:	053a1100 	ldreq	r1, [sl, #-256]!	; 0xffffff00
     860:	1d000000 	stcne	0, cr0, [r0, #-0]
     864:	00001005 	andeq	r1, r0, r5
     868:	a80e3107 	stmdage	lr, {r0, r1, r2, r8, ip, sp}
     86c:	3b000004 	blcc	884 <shift+0x884>
     870:	b1000003 	tstlt	r0, r3
     874:	bc000005 	stclt	0, cr0, [r0], {5}
     878:	10000005 	andne	r0, r0, r5
     87c:	000007cd 	andeq	r0, r0, sp, asr #15
     880:	00054011 	andeq	r4, r5, r1, lsl r0
     884:	8e130000 	cdphi	0, 1, cr0, cr3, cr0, {0}
     888:	07000010 	smladeq	r0, r0, r0, r0
     88c:	0fd11d35 	svceq	0x00d11d35
     890:	053a0000 	ldreq	r0, [sl, #-0]!
     894:	d5020000 	strle	r0, [r2, #-0]
     898:	db000005 	blle	8b4 <shift+0x8b4>
     89c:	10000005 	andne	r0, r0, r5
     8a0:	000007cd 	andeq	r0, r0, sp, asr #15
     8a4:	0a141300 	beq	5054ac <__bss_end+0x4fc4e0>
     8a8:	37070000 	strcc	r0, [r7, -r0]
     8ac:	000da21d 	andeq	sl, sp, sp, lsl r2
     8b0:	00053a00 	andeq	r3, r5, r0, lsl #20
     8b4:	05f40200 	ldrbeq	r0, [r4, #512]!	; 0x200
     8b8:	05fa0000 	ldrbeq	r0, [sl, #0]!
     8bc:	cd100000 	ldcgt	0, cr0, [r0, #-0]
     8c0:	00000007 	andeq	r0, r0, r7
     8c4:	000b881e 	andeq	r8, fp, lr, lsl r8
     8c8:	44390700 	ldrtmi	r0, [r9], #-1792	; 0xfffff900
     8cc:	000007e6 	andeq	r0, r0, r6, ror #15
     8d0:	9c13020c 	lfmls	f0, 4, [r3], {12}
     8d4:	07000006 	streq	r0, [r0, -r6]
     8d8:	1264093c 	rsbne	r0, r4, #60, 18	; 0xf0000
     8dc:	07cd0000 	strbeq	r0, [sp, r0]
     8e0:	21010000 	mrscs	r0, (UNDEF: 1)
     8e4:	27000006 	strcs	r0, [r0, -r6]
     8e8:	10000006 	andne	r0, r0, r6
     8ec:	000007cd 	andeq	r0, r0, sp, asr #15
     8f0:	06331300 	ldrteq	r1, [r3], -r0, lsl #6
     8f4:	3f070000 	svccc	0x00070000
     8f8:	00110412 	andseq	r0, r1, r2, lsl r4
     8fc:	00004d00 	andeq	r4, r0, r0, lsl #26
     900:	06400100 	strbeq	r0, [r0], -r0, lsl #2
     904:	06550000 	ldrbeq	r0, [r5], -r0
     908:	cd100000 	ldcgt	0, cr0, [r0, #-0]
     90c:	11000007 	tstne	r0, r7
     910:	000007ef 	andeq	r0, r0, pc, ror #15
     914:	00005e11 	andeq	r5, r0, r1, lsl lr
     918:	033b1100 	teqeq	fp, #0, 2
     91c:	14000000 	strne	r0, [r0], #-0
     920:	00001014 	andeq	r1, r0, r4, lsl r0
     924:	e60e4207 	str	r4, [lr], -r7, lsl #4
     928:	0100000c 	tsteq	r0, ip
     92c:	0000066a 	andeq	r0, r0, sl, ror #12
     930:	00000670 	andeq	r0, r0, r0, ror r6
     934:	0007cd10 	andeq	ip, r7, r0, lsl sp
     938:	76130000 	ldrvc	r0, [r3], -r0
     93c:	07000009 	streq	r0, [r0, -r9]
     940:	05741745 	ldrbeq	r1, [r4, #-1861]!	; 0xfffff8bb
     944:	05400000 	strbeq	r0, [r0, #-0]
     948:	89010000 	stmdbhi	r1, {}	; <UNPREDICTABLE>
     94c:	8f000006 	svchi	0x00000006
     950:	10000006 	andne	r0, r0, r6
     954:	000007f5 	strdeq	r0, [r0], -r5
     958:	05ba1300 	ldreq	r1, [sl, #768]!	; 0x300
     95c:	48070000 	stmdami	r7, {}	; <UNPREDICTABLE>
     960:	000f8e17 	andeq	r8, pc, r7, lsl lr	; <UNPREDICTABLE>
     964:	00054000 	andeq	r4, r5, r0
     968:	06a80100 	strteq	r0, [r8], r0, lsl #2
     96c:	06b30000 	ldrteq	r0, [r3], r0
     970:	f5100000 			; <UNDEFINED> instruction: 0xf5100000
     974:	11000007 	tstne	r0, r7
     978:	0000004d 	andeq	r0, r0, sp, asr #32
     97c:	11b21400 			; <UNDEFINED> instruction: 0x11b21400
     980:	4b070000 	blmi	1c0988 <__bss_end+0x1b79bc>
     984:	0004680e 	andeq	r6, r4, lr, lsl #16
     988:	06c80100 	strbeq	r0, [r8], r0, lsl #2
     98c:	06ce0000 	strbeq	r0, [lr], r0
     990:	cd100000 	ldcgt	0, cr0, [r0, #-0]
     994:	00000007 	andeq	r0, r0, r7
     998:	00100513 	andseq	r0, r0, r3, lsl r5
     99c:	0e4d0700 	cdpeq	7, 4, cr0, cr13, cr0, {0}
     9a0:	00000809 	andeq	r0, r0, r9, lsl #16
     9a4:	0000033b 	andeq	r0, r0, fp, lsr r3
     9a8:	0006e701 	andeq	lr, r6, r1, lsl #14
     9ac:	0006f200 	andeq	pc, r6, r0, lsl #4
     9b0:	07cd1000 	strbeq	r1, [sp, r0]
     9b4:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     9b8:	00000000 	andeq	r0, r0, r0
     9bc:	00098a13 	andeq	r8, r9, r3, lsl sl
     9c0:	12500700 	subsne	r0, r0, #0, 14
     9c4:	00000d07 	andeq	r0, r0, r7, lsl #26
     9c8:	0000004d 	andeq	r0, r0, sp, asr #32
     9cc:	00070b01 	andeq	r0, r7, r1, lsl #22
     9d0:	00071600 	andeq	r1, r7, r0, lsl #12
     9d4:	07cd1000 	strbeq	r1, [sp, r0]
     9d8:	6a110000 	bvs	4409e0 <__bss_end+0x437a14>
     9dc:	00000003 	andeq	r0, r0, r3
     9e0:	00051313 	andeq	r1, r5, r3, lsl r3
     9e4:	0e530700 	cdpeq	7, 5, cr0, cr3, cr0, {0}
     9e8:	000008bd 			; <UNDEFINED> instruction: 0x000008bd
     9ec:	0000033b 	andeq	r0, r0, fp, lsr r3
     9f0:	00072f01 	andeq	r2, r7, r1, lsl #30
     9f4:	00073a00 	andeq	r3, r7, r0, lsl #20
     9f8:	07cd1000 	strbeq	r1, [sp, r0]
     9fc:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     a00:	00000000 	andeq	r0, r0, r0
     a04:	0009ee14 	andeq	lr, r9, r4, lsl lr
     a08:	0e560700 	cdpeq	7, 5, cr0, cr6, cr0, {0}
     a0c:	000010ad 	andeq	r1, r0, sp, lsr #1
     a10:	00074f01 	andeq	r4, r7, r1, lsl #30
     a14:	00076e00 	andeq	r6, r7, r0, lsl #28
     a18:	07cd1000 	strbeq	r1, [sp, r0]
     a1c:	95110000 	ldrls	r0, [r1, #-0]
     a20:	11000000 	mrsne	r0, (UNDEF: 0)
     a24:	0000004d 	andeq	r0, r0, sp, asr #32
     a28:	00004d11 	andeq	r4, r0, r1, lsl sp
     a2c:	004d1100 	subeq	r1, sp, r0, lsl #2
     a30:	fb110000 	blx	440a3a <__bss_end+0x437a6e>
     a34:	00000007 	andeq	r0, r0, r7
     a38:	000fbb14 	andeq	fp, pc, r4, lsl fp	; <UNPREDICTABLE>
     a3c:	0e580700 	cdpeq	7, 5, cr0, cr8, cr0, {0}
     a40:	00000730 	andeq	r0, r0, r0, lsr r7
     a44:	00078301 	andeq	r8, r7, r1, lsl #6
     a48:	0007a200 	andeq	sl, r7, r0, lsl #4
     a4c:	07cd1000 	strbeq	r1, [sp, r0]
     a50:	cc110000 	ldcgt	0, cr0, [r1], {-0}
     a54:	11000000 	mrsne	r0, (UNDEF: 0)
     a58:	0000004d 	andeq	r0, r0, sp, asr #32
     a5c:	00004d11 	andeq	r4, r0, r1, lsl sp
     a60:	004d1100 	subeq	r1, sp, r0, lsl #2
     a64:	fb110000 	blx	440a6e <__bss_end+0x437aa2>
     a68:	00000007 	andeq	r0, r0, r7
     a6c:	00066115 	andeq	r6, r6, r5, lsl r1
     a70:	0e5b0700 	cdpeq	7, 5, cr0, cr11, cr0, {0}
     a74:	000006c2 	andeq	r0, r0, r2, asr #13
     a78:	0000033b 	andeq	r0, r0, fp, lsr r3
     a7c:	0007b701 	andeq	fp, r7, r1, lsl #14
     a80:	07cd1000 	strbeq	r1, [sp, r0]
     a84:	e6110000 	ldr	r0, [r1], -r0
     a88:	11000004 	tstne	r0, r4
     a8c:	00000801 	andeq	r0, r0, r1, lsl #16
     a90:	46030000 	strmi	r0, [r3], -r0
     a94:	18000005 	stmdane	r0, {r0, r2}
     a98:	00054604 	andeq	r4, r5, r4, lsl #12
     a9c:	053a1f00 	ldreq	r1, [sl, #-3840]!	; 0xfffff100
     aa0:	07e00000 	strbeq	r0, [r0, r0]!
     aa4:	07e60000 	strbeq	r0, [r6, r0]!
     aa8:	cd100000 	ldcgt	0, cr0, [r0, #-0]
     aac:	00000007 	andeq	r0, r0, r7
     ab0:	00054620 	andeq	r4, r5, r0, lsr #12
     ab4:	0007d300 	andeq	sp, r7, r0, lsl #6
     ab8:	3f041800 	svccc	0x00041800
     abc:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     ac0:	0007c804 	andeq	ip, r7, r4, lsl #16
     ac4:	6f042100 	svcvs	0x00042100
     ac8:	22000000 	andcs	r0, r0, #0
     acc:	101d1a04 	andsne	r1, sp, r4, lsl #20
     ad0:	5e070000 	cdppl	0, 0, cr0, cr7, cr0, {0}
     ad4:	00054619 	andeq	r4, r5, r9, lsl r6
     ad8:	61682300 	cmnvs	r8, r0, lsl #6
     adc:	0508006c 	streq	r0, [r8, #-108]	; 0xffffff94
     ae0:	0008c90b 	andeq	ip, r8, fp, lsl #18
     ae4:	0bbd2400 	bleq	fef49aec <__bss_end+0xfef40b20>
     ae8:	07080000 	streq	r0, [r8, -r0]
     aec:	00006519 	andeq	r6, r0, r9, lsl r5
     af0:	e6b28000 	ldrt	r8, [r2], r0
     af4:	0e0f240e 	cdpeq	4, 0, cr2, cr15, cr14, {0}
     af8:	0a080000 	beq	200b00 <__bss_end+0x1f7b34>
     afc:	00042f1a 	andeq	r2, r4, sl, lsl pc
     b00:	00000000 	andeq	r0, r0, r0
     b04:	0b962420 	bleq	fe589b8c <__bss_end+0xfe580bc0>
     b08:	0d080000 	stceq	0, cr0, [r8, #-0]
     b0c:	00042f1a 	andeq	r2, r4, sl, lsl pc
     b10:	20000000 	andcs	r0, r0, r0
     b14:	0dd42520 	cfldr64eq	mvdx2, [r4, #128]	; 0x80
     b18:	10080000 	andne	r0, r8, r0
     b1c:	00005915 	andeq	r5, r0, r5, lsl r9
     b20:	6d243600 	stcvs	6, cr3, [r4, #-0]
     b24:	08000009 	stmdaeq	r0, {r0, r3}
     b28:	042f1a42 	strteq	r1, [pc], #-2626	; b30 <shift+0xb30>
     b2c:	50000000 	andpl	r0, r0, r0
     b30:	60242021 	eorvs	r2, r4, r1, lsr #32
     b34:	08000008 	stmdaeq	r0, {r3}
     b38:	042f1a71 	strteq	r1, [pc], #-2673	; b40 <shift+0xb40>
     b3c:	b2000000 	andlt	r0, r0, #0
     b40:	d3242000 			; <UNDEFINED> instruction: 0xd3242000
     b44:	0800000e 	stmdaeq	r0, {r1, r2, r3}
     b48:	042f1aa4 	strteq	r1, [pc], #-2724	; b50 <shift+0xb50>
     b4c:	b4000000 	strlt	r0, [r0], #-0
     b50:	e9242000 	stmdb	r4!, {sp}
     b54:	08000008 	stmdaeq	r0, {r3}
     b58:	042f1ab3 	strteq	r1, [pc], #-2739	; b60 <shift+0xb60>
     b5c:	40000000 	andmi	r0, r0, r0
     b60:	39242010 	stmdbcc	r4!, {r4, sp}
     b64:	08000008 	stmdaeq	r0, {r3}
     b68:	042f1abe 	strteq	r1, [pc], #-2750	; b70 <shift+0xb70>
     b6c:	50000000 	andpl	r0, r0, r0
     b70:	9a242020 	bls	908bf8 <__bss_end+0x8ffc2c>
     b74:	08000008 	stmdaeq	r0, {r3}
     b78:	042f1abf 	strteq	r1, [pc], #-2751	; b80 <shift+0xb80>
     b7c:	40000000 	andmi	r0, r0, r0
     b80:	45242080 	strmi	r2, [r4, #-128]!	; 0xffffff80
     b84:	08000005 	stmdaeq	r0, {r0, r2}
     b88:	042f1ac0 	strteq	r1, [pc], #-2752	; b90 <shift+0xb90>
     b8c:	50000000 	andpl	r0, r0, r0
     b90:	26002080 	strcs	r2, [r0], -r0, lsl #1
     b94:	0000081b 	andeq	r0, r0, fp, lsl r8
     b98:	00082b26 	andeq	r2, r8, r6, lsr #22
     b9c:	083b2600 	ldmdaeq	fp!, {r9, sl, sp}
     ba0:	4b260000 	blmi	980ba8 <__bss_end+0x977bdc>
     ba4:	26000008 	strcs	r0, [r0], -r8
     ba8:	00000858 	andeq	r0, r0, r8, asr r8
     bac:	00086826 	andeq	r6, r8, r6, lsr #16
     bb0:	08782600 	ldmdaeq	r8!, {r9, sl, sp}^
     bb4:	88260000 	stmdahi	r6!, {}	; <UNPREDICTABLE>
     bb8:	26000008 	strcs	r0, [r0], -r8
     bbc:	00000898 	muleq	r0, r8, r8
     bc0:	0008a826 	andeq	sl, r8, r6, lsr #16
     bc4:	08b82600 	ldmeq	r8!, {r9, sl, sp}
     bc8:	620b0000 	andvs	r0, fp, #0
     bcc:	0900000b 	stmdbeq	r0, {r0, r1, r3}
     bd0:	00591408 	subseq	r1, r9, r8, lsl #8
     bd4:	03050000 	movweq	r0, #20480	; 0x5000
     bd8:	00008f48 	andeq	r8, r0, r8, asr #30
     bdc:	000cc809 	andeq	ip, ip, r9, lsl #16
     be0:	5e040700 	cdppl	7, 0, cr0, cr4, cr0, {0}
     be4:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     be8:	095b0c0b 	ldmdbeq	fp, {r0, r1, r3, sl, fp}^
     bec:	ff0a0000 			; <UNDEFINED> instruction: 0xff0a0000
     bf0:	0000000f 	andeq	r0, r0, pc
     bf4:	000c860a 	andeq	r8, ip, sl, lsl #12
     bf8:	e00a0100 	and	r0, sl, r0, lsl #2
     bfc:	0200000a 	andeq	r0, r0, #10
     c00:	00049d0a 	andeq	r9, r4, sl, lsl #26
     c04:	5d0a0300 	stcpl	3, cr0, [sl, #-0]
     c08:	04000004 	streq	r0, [r0], #-4
     c0c:	000aad0a 	andeq	sl, sl, sl, lsl #26
     c10:	b30a0500 	movwlt	r0, #42240	; 0xa500
     c14:	0600000a 	streq	r0, [r0], -sl
     c18:	0004970a 	andeq	r9, r4, sl, lsl #14
     c1c:	420a0700 	andmi	r0, sl, #0, 14
     c20:	08000012 	stmdaeq	r0, {r1, r4}
     c24:	04240900 	strteq	r0, [r4], #-2304	; 0xfffff700
     c28:	04050000 	streq	r0, [r5], #-0
     c2c:	00000038 	andeq	r0, r0, r8, lsr r0
     c30:	860c1d09 	strhi	r1, [ip], -r9, lsl #26
     c34:	0a000009 	beq	c60 <shift+0xc60>
     c38:	00000957 	andeq	r0, r0, r7, asr r9
     c3c:	07880a00 	streq	r0, [r8, r0, lsl #20]
     c40:	0a010000 	beq	40c48 <__bss_end+0x37c7c>
     c44:	000008f3 	strdeq	r0, [r0], -r3
     c48:	6f4c1b02 	svcvs	0x004c1b02
     c4c:	00030077 	andeq	r0, r3, r7, ror r0
     c50:	0012340d 	andseq	r3, r2, sp, lsl #8
     c54:	28091c00 	stmdacs	r9, {sl, fp, ip}
     c58:	000d0707 	andeq	r0, sp, r7, lsl #14
     c5c:	06250700 	strteq	r0, [r5], -r0, lsl #14
     c60:	09100000 	ldmdbeq	r0, {}	; <UNPREDICTABLE>
     c64:	09d50a33 	ldmibeq	r5, {r0, r1, r4, r5, r9, fp}^
     c68:	2f0e0000 	svccs	0x000e0000
     c6c:	09000012 	stmdbeq	r0, {r1, r4}
     c70:	036a0b35 	cmneq	sl, #54272	; 0xd400
     c74:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     c78:	000011c8 	andeq	r1, r0, r8, asr #3
     c7c:	4d0d3609 	stcmi	6, cr3, [sp, #-36]	; 0xffffffdc
     c80:	04000000 	streq	r0, [r0], #-0
     c84:	0004a30e 	andeq	sl, r4, lr, lsl #6
     c88:	13370900 	teqne	r7, #0, 18
     c8c:	00000d0c 	andeq	r0, r0, ip, lsl #26
     c90:	05b50e08 	ldreq	r0, [r5, #3592]!	; 0xe08
     c94:	38090000 	stmdacc	r9, {}	; <UNPREDICTABLE>
     c98:	000d0c13 	andeq	r0, sp, r3, lsl ip
     c9c:	0e000c00 	cdpeq	12, 0, cr0, cr0, cr0, {0}
     ca0:	00000642 	andeq	r0, r0, r2, asr #12
     ca4:	18202c09 	stmdane	r0!, {r0, r3, sl, fp, sp}
     ca8:	0000000d 	andeq	r0, r0, sp
     cac:	00060e0e 	andeq	r0, r6, lr, lsl #28
     cb0:	412f0900 			; <UNDEFINED> instruction: 0x412f0900
     cb4:	00000d1d 	andeq	r0, r0, sp, lsl sp
     cb8:	0c560e04 	mrrceq	14, 0, r0, r6, cr4
     cbc:	31090000 	mrscc	r0, (UNDEF: 9)
     cc0:	000d1d42 	andeq	r1, sp, r2, asr #26
     cc4:	5e0e0c00 	cdppl	12, 0, cr0, cr14, cr0, {0}
     cc8:	0900000f 	stmdbeq	r0, {r0, r1, r2, r3}
     ccc:	0d0c123b 	sfmeq	f1, 4, [ip, #-236]	; 0xffffff14
     cd0:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     cd4:	00000e31 	andeq	r0, r0, r1, lsr lr
     cd8:	090e3d09 	stmdbeq	lr, {r0, r3, r8, sl, fp, ip, sp}
     cdc:	18000001 	stmdane	r0, {r0}
     ce0:	000c6e13 	andeq	r6, ip, r3, lsl lr
     ce4:	08410900 	stmdaeq	r1, {r8, fp}^
     ce8:	0000099e 	muleq	r0, lr, r9
     cec:	0000033b 	andeq	r0, r0, fp, lsr r3
     cf0:	000a2f02 	andeq	r2, sl, r2, lsl #30
     cf4:	000a4400 	andeq	r4, sl, r0, lsl #8
     cf8:	0d2d1000 	stceq	0, cr1, [sp, #-0]
     cfc:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     d00:	11000000 	mrsne	r0, (UNDEF: 0)
     d04:	00000d33 	andeq	r0, r0, r3, lsr sp
     d08:	000d3311 	andeq	r3, sp, r1, lsl r3
     d0c:	37130000 	ldrcc	r0, [r3, -r0]
     d10:	0900000c 	stmdbeq	r0, {r2, r3}
     d14:	0bdf0843 	bleq	ff7c2e28 <__bss_end+0xff7b9e5c>
     d18:	033b0000 	teqeq	fp, #0
     d1c:	5d020000 	stcpl	0, cr0, [r2, #-0]
     d20:	7200000a 	andvc	r0, r0, #10
     d24:	1000000a 	andne	r0, r0, sl
     d28:	00000d2d 	andeq	r0, r0, sp, lsr #26
     d2c:	00004d11 	andeq	r4, r0, r1, lsl sp
     d30:	0d331100 	ldfeqs	f1, [r3, #-0]
     d34:	33110000 	tstcc	r1, #0
     d38:	0000000d 	andeq	r0, r0, sp
     d3c:	000f1c13 	andeq	r1, pc, r3, lsl ip	; <UNPREDICTABLE>
     d40:	08450900 	stmdaeq	r5, {r8, fp}^
     d44:	00001151 	andeq	r1, r0, r1, asr r1
     d48:	0000033b 	andeq	r0, r0, fp, lsr r3
     d4c:	000a8b02 	andeq	r8, sl, r2, lsl #22
     d50:	000aa000 	andeq	sl, sl, r0
     d54:	0d2d1000 	stceq	0, cr1, [sp, #-0]
     d58:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     d5c:	11000000 	mrsne	r0, (UNDEF: 0)
     d60:	00000d33 	andeq	r0, r0, r3, lsr sp
     d64:	000d3311 	andeq	r3, sp, r1, lsl r3
     d68:	9a130000 	bls	4c0d70 <__bss_end+0x4b7da4>
     d6c:	09000010 	stmdbeq	r0, {r4}
     d70:	0f2f0847 	svceq	0x002f0847
     d74:	033b0000 	teqeq	fp, #0
     d78:	b9020000 	stmdblt	r2, {}	; <UNPREDICTABLE>
     d7c:	ce00000a 	cdpgt	0, 0, cr0, cr0, cr10, {0}
     d80:	1000000a 	andne	r0, r0, sl
     d84:	00000d2d 	andeq	r0, r0, sp, lsr #26
     d88:	00004d11 	andeq	r4, r0, r1, lsl sp
     d8c:	0d331100 	ldfeqs	f1, [r3, #-0]
     d90:	33110000 	tstcc	r1, #0
     d94:	0000000d 	andeq	r0, r0, sp
     d98:	0005a213 	andeq	sl, r5, r3, lsl r2
     d9c:	08490900 	stmdaeq	r9, {r8, fp}^
     da0:	0000105f 	andeq	r1, r0, pc, asr r0
     da4:	0000033b 	andeq	r0, r0, fp, lsr r3
     da8:	000ae702 	andeq	lr, sl, r2, lsl #14
     dac:	000afc00 	andeq	pc, sl, r0, lsl #24
     db0:	0d2d1000 	stceq	0, cr1, [sp, #-0]
     db4:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     db8:	11000000 	mrsne	r0, (UNDEF: 0)
     dbc:	00000d33 	andeq	r0, r0, r3, lsr sp
     dc0:	000d3311 	andeq	r3, sp, r1, lsl r3
     dc4:	1c130000 	ldcne	0, cr0, [r3], {-0}
     dc8:	0900000c 	stmdbeq	r0, {r2, r3}
     dcc:	090a084b 	stmdbeq	sl, {r0, r1, r3, r6, fp}
     dd0:	033b0000 	teqeq	fp, #0
     dd4:	15020000 	strne	r0, [r2, #-0]
     dd8:	2f00000b 	svccs	0x0000000b
     ddc:	1000000b 	andne	r0, r0, fp
     de0:	00000d2d 	andeq	r0, r0, sp, lsr #26
     de4:	00004d11 	andeq	r4, r0, r1, lsl sp
     de8:	095b1100 	ldmdbeq	fp, {r8, ip}^
     dec:	33110000 	tstcc	r1, #0
     df0:	1100000d 	tstne	r0, sp
     df4:	00000d33 	andeq	r0, r0, r3, lsr sp
     df8:	0a661300 	beq	1985a00 <__bss_end+0x197ca34>
     dfc:	4f090000 	svcmi	0x00090000
     e00:	000d740c 	andeq	r7, sp, ip, lsl #8
     e04:	00004d00 	andeq	r4, r0, r0, lsl #26
     e08:	0b480200 	bleq	1201610 <__bss_end+0x11f8644>
     e0c:	0b4e0000 	bleq	1380e14 <__bss_end+0x1377e48>
     e10:	2d100000 	ldccs	0, cr0, [r0, #-0]
     e14:	0000000d 	andeq	r0, r0, sp
     e18:	00118014 	andseq	r8, r1, r4, lsl r0
     e1c:	08510900 	ldmdaeq	r1, {r8, fp}^
     e20:	00000705 	andeq	r0, r0, r5, lsl #14
     e24:	000b6302 	andeq	r6, fp, r2, lsl #6
     e28:	000b6e00 	andeq	r6, fp, r0, lsl #28
     e2c:	0d391000 	ldceq	0, cr1, [r9, #-0]
     e30:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     e34:	00000000 	andeq	r0, r0, r0
     e38:	00123413 	andseq	r3, r2, r3, lsl r4
     e3c:	03540900 	cmpeq	r4, #0, 18
     e40:	00000df8 	strdeq	r0, [r0], -r8
     e44:	00000d39 	andeq	r0, r0, r9, lsr sp
     e48:	000b8701 	andeq	r8, fp, r1, lsl #14
     e4c:	000b9200 	andeq	r9, fp, r0, lsl #4
     e50:	0d391000 	ldceq	0, cr1, [r9, #-0]
     e54:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
     e58:	00000000 	andeq	r0, r0, r0
     e5c:	00056214 	andeq	r6, r5, r4, lsl r2
     e60:	08570900 	ldmdaeq	r7, {r8, fp}^
     e64:	00000c9f 	muleq	r0, pc, ip	; <UNPREDICTABLE>
     e68:	000ba701 	andeq	sl, fp, r1, lsl #14
     e6c:	000bb700 	andeq	fp, fp, r0, lsl #14
     e70:	0d391000 	ldceq	0, cr1, [r9, #-0]
     e74:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     e78:	11000000 	mrsne	r0, (UNDEF: 0)
     e7c:	00000912 	andeq	r0, r0, r2, lsl r9
     e80:	0ec11300 	cdpeq	3, 12, cr1, cr1, cr0, {0}
     e84:	59090000 	stmdbpl	r9, {}	; <UNPREDICTABLE>
     e88:	0011d912 	andseq	sp, r1, r2, lsl r9
     e8c:	00091200 	andeq	r1, r9, r0, lsl #4
     e90:	0bd00100 	bleq	ff401298 <__bss_end+0xff3f82cc>
     e94:	0bdb0000 	bleq	ff6c0e9c <__bss_end+0xff6b7ed0>
     e98:	2d100000 	ldccs	0, cr0, [r0, #-0]
     e9c:	1100000d 	tstne	r0, sp
     ea0:	0000004d 	andeq	r0, r0, sp, asr #32
     ea4:	0c821400 	cfstrseq	mvf1, [r2], {0}
     ea8:	5c090000 	stcpl	0, cr0, [r9], {-0}
     eac:	000ae608 	andeq	lr, sl, r8, lsl #12
     eb0:	0bf00100 	bleq	ffc012b8 <__bss_end+0xffbf82ec>
     eb4:	0c000000 	stceq	0, cr0, [r0], {-0}
     eb8:	39100000 	ldmdbcc	r0, {}	; <UNPREDICTABLE>
     ebc:	1100000d 	tstne	r0, sp
     ec0:	0000004d 	andeq	r0, r0, sp, asr #32
     ec4:	00033b11 	andeq	r3, r3, r1, lsl fp
     ec8:	fb130000 	blx	4c0ed2 <__bss_end+0x4b7f06>
     ecc:	0900000f 	stmdbeq	r0, {r0, r1, r2, r3}
     ed0:	0526085f 	streq	r0, [r6, #-2143]!	; 0xfffff7a1
     ed4:	033b0000 	teqeq	fp, #0
     ed8:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
     edc:	2400000c 	strcs	r0, [r0], #-12
     ee0:	1000000c 	andne	r0, r0, ip
     ee4:	00000d39 	andeq	r0, r0, r9, lsr sp
     ee8:	00004d11 	andeq	r4, r0, r1, lsl sp
     eec:	b5130000 	ldrlt	r0, [r3, #-0]
     ef0:	0900000e 	stmdbeq	r0, {r1, r2, r3}
     ef4:	04390862 	ldrteq	r0, [r9], #-2146	; 0xfffff79e
     ef8:	033b0000 	teqeq	fp, #0
     efc:	3d010000 	stccc	0, cr0, [r1, #-0]
     f00:	5200000c 	andpl	r0, r0, #12
     f04:	1000000c 	andne	r0, r0, ip
     f08:	00000d39 	andeq	r0, r0, r9, lsr sp
     f0c:	00004d11 	andeq	r4, r0, r1, lsl sp
     f10:	033b1100 	teqeq	fp, #0, 2
     f14:	3b110000 	blcc	440f1c <__bss_end+0x437f50>
     f18:	00000003 	andeq	r0, r0, r3
     f1c:	0011d013 	andseq	sp, r1, r3, lsl r0
     f20:	08640900 	stmdaeq	r4!, {r8, fp}^
     f24:	0000087a 	andeq	r0, r0, sl, ror r8
     f28:	0000033b 	andeq	r0, r0, fp, lsr r3
     f2c:	000c6b01 	andeq	r6, ip, r1, lsl #22
     f30:	000c8000 	andeq	r8, ip, r0
     f34:	0d391000 	ldceq	0, cr1, [r9, #-0]
     f38:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     f3c:	11000000 	mrsne	r0, (UNDEF: 0)
     f40:	0000033b 	andeq	r0, r0, fp, lsr r3
     f44:	00033b11 	andeq	r3, r3, r1, lsl fp
     f48:	6e140000 	cdpvs	0, 1, cr0, cr4, cr0, {0}
     f4c:	0900000b 	stmdbeq	r0, {r0, r1, r3}
     f50:	03f90867 	mvnseq	r0, #6750208	; 0x670000
     f54:	95010000 	strls	r0, [r1, #-0]
     f58:	a500000c 	strge	r0, [r0, #-12]
     f5c:	1000000c 	andne	r0, r0, ip
     f60:	00000d39 	andeq	r0, r0, r9, lsr sp
     f64:	00004d11 	andeq	r4, r0, r1, lsl sp
     f68:	095b1100 	ldmdbeq	fp, {r8, ip}^
     f6c:	14000000 	strne	r0, [r0], #-0
     f70:	00000d3a 	andeq	r0, r0, sl, lsr sp
     f74:	ac086909 			; <UNDEFINED> instruction: 0xac086909
     f78:	01000007 	tsteq	r0, r7
     f7c:	00000cba 			; <UNDEFINED> instruction: 0x00000cba
     f80:	00000cca 	andeq	r0, r0, sl, asr #25
     f84:	000d3910 	andeq	r3, sp, r0, lsl r9
     f88:	004d1100 	subeq	r1, sp, r0, lsl #2
     f8c:	5b110000 	blpl	440f94 <__bss_end+0x437fc8>
     f90:	00000009 	andeq	r0, r0, r9
     f94:	0012a414 	andseq	sl, r2, r4, lsl r4
     f98:	086c0900 	stmdaeq	ip!, {r8, fp}^
     f9c:	00000a26 	andeq	r0, r0, r6, lsr #20
     fa0:	000cdf01 	andeq	sp, ip, r1, lsl #30
     fa4:	000ce500 	andeq	lr, ip, r0, lsl #10
     fa8:	0d391000 	ldceq	0, cr1, [r9, #-0]
     fac:	27000000 	strcs	r0, [r0, -r0]
     fb0:	00000bd0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     fb4:	80086f09 	andhi	r6, r8, r9, lsl #30
     fb8:	0100000e 	tsteq	r0, lr
     fbc:	00000cf6 	strdeq	r0, [r0], -r6
     fc0:	000d3910 	andeq	r3, sp, r0, lsl r9
     fc4:	036a1100 	cmneq	sl, #0, 2
     fc8:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     fcc:	00000000 	andeq	r0, r0, r0
     fd0:	09860300 	stmibeq	r6, {r8, r9}
     fd4:	04180000 	ldreq	r0, [r8], #-0
     fd8:	00000993 	muleq	r0, r3, r9
     fdc:	006a0418 	rsbeq	r0, sl, r8, lsl r4
     fe0:	12030000 	andne	r0, r3, #0
     fe4:	1600000d 	strne	r0, [r0], -sp
     fe8:	0000004d 	andeq	r0, r0, sp, asr #32
     fec:	00000d2d 	andeq	r0, r0, sp, lsr #26
     ff0:	00005e17 	andeq	r5, r0, r7, lsl lr
     ff4:	18000100 	stmdane	r0, {r8}
     ff8:	000d0704 	andeq	r0, sp, r4, lsl #14
     ffc:	4d042100 	stfmis	f2, [r4, #-0]
    1000:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    1004:	00098604 	andeq	r8, r9, r4, lsl #12
    1008:	0b821a00 	bleq	fe087810 <__bss_end+0xfe07e844>
    100c:	73090000 	movwvc	r0, #36864	; 0x9000
    1010:	00098616 	andeq	r8, r9, r6, lsl r6
    1014:	12592800 	subsne	r2, r9, #0, 16
    1018:	10010000 	andne	r0, r1, r0
    101c:	00003805 	andeq	r3, r0, r5, lsl #16
    1020:	00823400 	addeq	r3, r2, r0, lsl #8
    1024:	00019400 	andeq	r9, r1, r0, lsl #8
    1028:	f79c0100 			; <UNDEFINED> instruction: 0xf79c0100
    102c:	2900000d 	stmdbcs	r0, {r0, r2, r3}
    1030:	0000120f 	andeq	r1, r0, pc, lsl #4
    1034:	380e1001 	stmdacc	lr, {r0, ip}
    1038:	02000000 	andeq	r0, r0, #0
    103c:	ff295c91 			; <UNDEFINED> instruction: 0xff295c91
    1040:	01000010 	tsteq	r0, r0, lsl r0
    1044:	0df71b10 			; <UNDEFINED> instruction: 0x0df71b10
    1048:	91020000 	mrsls	r0, (UNDEF: 2)
    104c:	0a9b2a58 	beq	fe6cb9b4 <__bss_end+0xfe6c29e8>
    1050:	12010000 	andne	r0, r1, #0
    1054:	00004d0b 	andeq	r4, r0, fp, lsl #26
    1058:	70910200 	addsvc	r0, r1, r0, lsl #4
    105c:	0012272a 	andseq	r2, r2, sl, lsr #14
    1060:	0b130100 	bleq	4c1468 <__bss_end+0x4b849c>
    1064:	0000004d 	andeq	r0, r0, sp, asr #32
    1068:	2a6c9102 	bcs	1b25478 <__bss_end+0x1b1c4ac>
    106c:	000009ce 	andeq	r0, r0, lr, asr #19
    1070:	4d0b1401 	cfstrsmi	mvf1, [fp, #-4]
    1074:	02000000 	andeq	r0, r0, #0
    1078:	232a6891 			; <UNDEFINED> instruction: 0x232a6891
    107c:	0100000b 	tsteq	r0, fp
    1080:	005e0f16 	subseq	r0, lr, r6, lsl pc
    1084:	91020000 	mrsls	r0, (UNDEF: 2)
    1088:	050e2a74 	streq	r2, [lr, #-2676]	; 0xfffff58c
    108c:	17010000 	strne	r0, [r1, -r0]
    1090:	00033b07 	andeq	r3, r3, r7, lsl #22
    1094:	67910200 	ldrvs	r0, [r1, r0, lsl #4]
    1098:	00067f2a 	andeq	r7, r6, sl, lsr #30
    109c:	07180100 	ldreq	r0, [r8, -r0, lsl #2]
    10a0:	0000033b 	andeq	r0, r0, fp, lsr r3
    10a4:	2b669102 	blcs	19a54b4 <__bss_end+0x199c4e8>
    10a8:	000082b0 			; <UNDEFINED> instruction: 0x000082b0
    10ac:	00000104 	andeq	r0, r0, r4, lsl #2
    10b0:	706d742c 	rsbvc	r7, sp, ip, lsr #8
    10b4:	081e0100 	ldmdaeq	lr, {r8}
    10b8:	00000025 	andeq	r0, r0, r5, lsr #32
    10bc:	00659102 	rsbeq	r9, r5, r2, lsl #2
    10c0:	fd041800 	stc2	8, cr1, [r4, #-0]
    10c4:	1800000d 	stmdane	r0, {r0, r2, r3}
    10c8:	00002504 	andeq	r2, r0, r4, lsl #10
    10cc:	0cd70000 	ldcleq	0, cr0, [r7], {0}
    10d0:	00040000 	andeq	r0, r4, r0
    10d4:	00000466 	andeq	r0, r0, r6, ror #8
    10d8:	12ca0104 	sbcne	r0, sl, #4, 2
    10dc:	0b040000 	bleq	1010e4 <__bss_end+0xf8118>
    10e0:	cd000014 	stcgt	0, cr0, [r0, #-80]	; 0xffffffb0
    10e4:	c8000014 	stmdagt	r0, {r2, r4}
    10e8:	60000083 	andvs	r0, r0, r3, lsl #1
    10ec:	90000004 	andls	r0, r0, r4
    10f0:	02000004 	andeq	r0, r0, #4
    10f4:	0d6f0801 	stcleq	8, cr0, [pc, #-4]!	; 10f8 <shift+0x10f8>
    10f8:	25030000 	strcs	r0, [r3, #-0]
    10fc:	02000000 	andeq	r0, r0, #0
    1100:	0de30502 	cfstr64eq	mvdx0, [r3, #8]!
    1104:	04040000 	streq	r0, [r4], #-0
    1108:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    110c:	08010200 	stmdaeq	r1, {r9}
    1110:	00000d66 	andeq	r0, r0, r6, ror #26
    1114:	01070202 	tsteq	r7, r2, lsl #4
    1118:	0500000a 	streq	r0, [r0, #-10]
    111c:	00000eac 	andeq	r0, r0, ip, lsr #29
    1120:	5e1e0907 	vnmlspl.f16	s0, s28, s14	; <UNPREDICTABLE>
    1124:	03000000 	movweq	r0, #0
    1128:	0000004d 	andeq	r0, r0, sp, asr #32
    112c:	e5070402 	str	r0, [r7, #-1026]	; 0xfffffbfe
    1130:	0600001c 			; <UNDEFINED> instruction: 0x0600001c
    1134:	0000077c 	andeq	r0, r0, ip, ror r7
    1138:	08060208 	stmdaeq	r6, {r3, r9}
    113c:	0000008b 	andeq	r0, r0, fp, lsl #1
    1140:	00307207 	eorseq	r7, r0, r7, lsl #4
    1144:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
    1148:	00000000 	andeq	r0, r0, r0
    114c:	00317207 	eorseq	r7, r1, r7, lsl #4
    1150:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
    1154:	04000000 	streq	r0, [r0], #-0
    1158:	16260800 	strtne	r0, [r6], -r0, lsl #16
    115c:	04050000 	streq	r0, [r5], #-0
    1160:	00000038 	andeq	r0, r0, r8, lsr r0
    1164:	a90c0d02 	stmdbge	ip, {r1, r8, sl, fp}
    1168:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    116c:	00004b4f 	andeq	r4, r0, pc, asr #22
    1170:	00144b0a 	andseq	r4, r4, sl, lsl #22
    1174:	08000100 	stmdaeq	r0, {r8}
    1178:	000005e4 	andeq	r0, r0, r4, ror #11
    117c:	00380405 	eorseq	r0, r8, r5, lsl #8
    1180:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
    1184:	0000e00c 	andeq	lr, r0, ip
    1188:	08310a00 	ldmdaeq	r1!, {r9, fp}
    118c:	0a000000 	beq	1194 <shift+0x1194>
    1190:	00001294 	muleq	r0, r4, r2
    1194:	125e0a01 	subsne	r0, lr, #4096	; 0x1000
    1198:	0a020000 	beq	811a0 <__bss_end+0x781d4>
    119c:	00000a8b 	andeq	r0, r0, fp, lsl #21
    11a0:	0cd70a03 	vldmiaeq	r7, {s1-s3}
    11a4:	0a040000 	beq	1011ac <__bss_end+0xf81e0>
    11a8:	000007fa 	strdeq	r0, [r0], -sl
    11ac:	39080005 	stmdbcc	r8, {r0, r2}
    11b0:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
    11b4:	00003804 	andeq	r3, r0, r4, lsl #16
    11b8:	0c3f0200 	lfmeq	f0, 4, [pc], #-0	; 11c0 <shift+0x11c0>
    11bc:	0000011d 	andeq	r0, r0, sp, lsl r1
    11c0:	0004630a 	andeq	r6, r4, sl, lsl #6
    11c4:	200a0000 	andcs	r0, sl, r0
    11c8:	01000006 	tsteq	r0, r6
    11cc:	000c920a 	andeq	r9, ip, sl, lsl #4
    11d0:	020a0200 	andeq	r0, sl, #0, 4
    11d4:	03000012 	movweq	r0, #18
    11d8:	00129e0a 	andseq	r9, r2, sl, lsl #28
    11dc:	b60a0400 	strlt	r0, [sl], -r0, lsl #8
    11e0:	0500000b 	streq	r0, [r0, #-11]
    11e4:	000a210a 	andeq	r2, sl, sl, lsl #2
    11e8:	08000600 	stmdaeq	r0, {r9, sl}
    11ec:	00001695 	muleq	r0, r5, r6
    11f0:	00380405 	eorseq	r0, r8, r5, lsl #8
    11f4:	66020000 	strvs	r0, [r2], -r0
    11f8:	0001480c 	andeq	r4, r1, ip, lsl #16
    11fc:	15cb0a00 	strbne	r0, [fp, #2560]	; 0xa00
    1200:	0a000000 	beq	1208 <shift+0x1208>
    1204:	000014a8 	andeq	r1, r0, r8, lsr #9
    1208:	15ef0a01 	strbne	r0, [pc, #2561]!	; 1c11 <shift+0x1c11>
    120c:	0a020000 	beq	81214 <__bss_end+0x78248>
    1210:	000014fc 	strdeq	r1, [r0], -ip
    1214:	0e0b0003 	cdpeq	0, 0, cr0, cr11, cr3, {0}
    1218:	0300000c 	movweq	r0, #12
    121c:	00591405 	subseq	r1, r9, r5, lsl #8
    1220:	03050000 	movweq	r0, #20480	; 0x5000
    1224:	00008f70 	andeq	r8, r0, r0, ror pc
    1228:	000c4a0b 	andeq	r4, ip, fp, lsl #20
    122c:	14060300 	strne	r0, [r6], #-768	; 0xfffffd00
    1230:	00000059 	andeq	r0, r0, r9, asr r0
    1234:	8f740305 	svchi	0x00740305
    1238:	a00b0000 	andge	r0, fp, r0
    123c:	0400000b 	streq	r0, [r0], #-11
    1240:	00591a07 	subseq	r1, r9, r7, lsl #20
    1244:	03050000 	movweq	r0, #20480	; 0x5000
    1248:	00008f78 	andeq	r8, r0, r8, ror pc
    124c:	00064f0b 	andeq	r4, r6, fp, lsl #30
    1250:	1a090400 	bne	242258 <__bss_end+0x23928c>
    1254:	00000059 	andeq	r0, r0, r9, asr r0
    1258:	8f7c0305 	svchi	0x007c0305
    125c:	580b0000 	stmdapl	fp, {}	; <UNPREDICTABLE>
    1260:	0400000d 	streq	r0, [r0], #-13
    1264:	00591a0b 	subseq	r1, r9, fp, lsl #20
    1268:	03050000 	movweq	r0, #20480	; 0x5000
    126c:	00008f80 	andeq	r8, r0, r0, lsl #31
    1270:	0009db0b 	andeq	sp, r9, fp, lsl #22
    1274:	1a0d0400 	bne	34227c <__bss_end+0x3392b0>
    1278:	00000059 	andeq	r0, r0, r9, asr r0
    127c:	8f840305 	svchi	0x00840305
    1280:	a20b0000 	andge	r0, fp, #0
    1284:	04000007 	streq	r0, [r0], #-7
    1288:	00591a0f 	subseq	r1, r9, pc, lsl #20
    128c:	03050000 	movweq	r0, #20480	; 0x5000
    1290:	00008f88 	andeq	r8, r0, r8, lsl #31
    1294:	000f0c08 	andeq	r0, pc, r8, lsl #24
    1298:	38040500 	stmdacc	r4, {r8, sl}
    129c:	04000000 	streq	r0, [r0], #-0
    12a0:	01eb0c1b 	mvneq	r0, fp, lsl ip
    12a4:	780a0000 	stmdavc	sl, {}	; <UNPREDICTABLE>
    12a8:	0000000f 	andeq	r0, r0, pc
    12ac:	00124e0a 	andseq	r4, r2, sl, lsl #28
    12b0:	8d0a0100 	stfhis	f0, [sl, #-0]
    12b4:	0200000c 	andeq	r0, r0, #12
    12b8:	0d340c00 	ldceq	12, cr0, [r4, #-0]
    12bc:	c80d0000 	stmdagt	sp, {}	; <UNPREDICTABLE>
    12c0:	9000000d 	andls	r0, r0, sp
    12c4:	5e076304 	cdppl	3, 0, cr6, cr7, cr4, {0}
    12c8:	06000003 	streq	r0, [r0], -r3
    12cc:	000011a4 	andeq	r1, r0, r4, lsr #3
    12d0:	10670424 	rsbne	r0, r7, r4, lsr #8
    12d4:	00000278 	andeq	r0, r0, r8, ror r2
    12d8:	0020cd0e 	eoreq	ip, r0, lr, lsl #26
    12dc:	28690400 	stmdacs	r9!, {sl}^
    12e0:	0000035e 	andeq	r0, r0, lr, asr r3
    12e4:	05d80e00 	ldrbeq	r0, [r8, #3584]	; 0xe00
    12e8:	6b040000 	blvs	1012f0 <__bss_end+0xf8324>
    12ec:	00036e20 	andeq	r6, r3, r0, lsr #28
    12f0:	6d0e1000 	stcvs	0, cr1, [lr, #-0]
    12f4:	0400000f 	streq	r0, [r0], #-15
    12f8:	004d236d 	subeq	r2, sp, sp, ror #6
    12fc:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
    1300:	00000648 	andeq	r0, r0, r8, asr #12
    1304:	751c7004 	ldrvc	r7, [ip, #-4]
    1308:	18000003 	stmdane	r0, {r0, r1}
    130c:	000d4f0e 	andeq	r4, sp, lr, lsl #30
    1310:	1c720400 	cfldrdne	mvd0, [r2], #-0
    1314:	00000375 	andeq	r0, r0, r5, ror r3
    1318:	05b50e1c 	ldreq	r0, [r5, #3612]!	; 0xe1c
    131c:	75040000 	strvc	r0, [r4, #-0]
    1320:	0003751c 	andeq	r7, r3, ip, lsl r5
    1324:	430f2000 	movwmi	r2, #61440	; 0xf000
    1328:	04000008 	streq	r0, [r0], #-8
    132c:	04de1c77 	ldrbeq	r1, [lr], #3191	; 0xc77
    1330:	03750000 	cmneq	r5, #0
    1334:	026c0000 	rsbeq	r0, ip, #0
    1338:	75100000 	ldrvc	r0, [r0, #-0]
    133c:	11000003 	tstne	r0, r3
    1340:	0000037b 	andeq	r0, r0, fp, ror r3
    1344:	ed060000 	stc	0, cr0, [r6, #-0]
    1348:	1800000d 	stmdane	r0, {r0, r2, r3}
    134c:	ad107b04 	vldrge	d7, [r0, #-16]
    1350:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
    1354:	000020cd 	andeq	r2, r0, sp, asr #1
    1358:	5e2c7e04 	cdppl	14, 2, cr7, cr12, cr4, {0}
    135c:	00000003 	andeq	r0, r0, r3
    1360:	0005cd0e 	andeq	ip, r5, lr, lsl #26
    1364:	19800400 	stmibne	r0, {sl}
    1368:	0000037b 	andeq	r0, r0, fp, ror r3
    136c:	12080e10 	andne	r0, r8, #16, 28	; 0x100
    1370:	82040000 	andhi	r0, r4, #0
    1374:	00038621 	andeq	r8, r3, r1, lsr #12
    1378:	03001400 	movweq	r1, #1024	; 0x400
    137c:	00000278 	andeq	r0, r0, r8, ror r2
    1380:	000b4c12 	andeq	r4, fp, r2, lsl ip
    1384:	21860400 	orrcs	r0, r6, r0, lsl #8
    1388:	0000038c 	andeq	r0, r0, ip, lsl #7
    138c:	0008f812 	andeq	pc, r8, r2, lsl r8	; <UNPREDICTABLE>
    1390:	1f880400 	svcne	0x00880400
    1394:	00000059 	andeq	r0, r0, r9, asr r0
    1398:	000e1f0e 	andeq	r1, lr, lr, lsl #30
    139c:	178b0400 	strne	r0, [fp, r0, lsl #8]
    13a0:	000001fd 	strdeq	r0, [r0], -sp
    13a4:	0a910e00 	beq	fe444bac <__bss_end+0xfe43bbe0>
    13a8:	8e040000 	cdphi	0, 0, cr0, cr4, cr0, {0}
    13ac:	0001fd17 	andeq	pc, r1, r7, lsl sp	; <UNPREDICTABLE>
    13b0:	630e2400 	movwvs	r2, #58368	; 0xe400
    13b4:	04000009 	streq	r0, [r0], #-9
    13b8:	01fd178f 	mvnseq	r1, pc, lsl #15
    13bc:	0e480000 	cdpeq	0, 4, cr0, cr8, cr0, {0}
    13c0:	0000127e 	andeq	r1, r0, lr, ror r2
    13c4:	fd179004 	ldc2	0, cr9, [r7, #-16]
    13c8:	6c000001 	stcvs	0, cr0, [r0], {1}
    13cc:	000dc813 	andeq	ip, sp, r3, lsl r8
    13d0:	09930400 	ldmibeq	r3, {sl}
    13d4:	000006ad 	andeq	r0, r0, sp, lsr #13
    13d8:	00000397 	muleq	r0, r7, r3
    13dc:	00031701 	andeq	r1, r3, r1, lsl #14
    13e0:	00031d00 	andeq	r1, r3, r0, lsl #26
    13e4:	03971000 	orrseq	r1, r7, #0
    13e8:	14000000 	strne	r0, [r0], #-0
    13ec:	00000b41 	andeq	r0, r0, r1, asr #22
    13f0:	470e9604 	strmi	r9, [lr, -r4, lsl #12]
    13f4:	0100000a 	tsteq	r0, sl
    13f8:	00000332 	andeq	r0, r0, r2, lsr r3
    13fc:	00000338 	andeq	r0, r0, r8, lsr r3
    1400:	00039710 	andeq	r9, r3, r0, lsl r7
    1404:	63150000 	tstvs	r5, #0
    1408:	04000004 	streq	r0, [r0], #-4
    140c:	0ef11099 	mrceq	0, 7, r1, cr1, cr9, {4}
    1410:	039d0000 	orrseq	r0, sp, #0
    1414:	4d010000 	stcmi	0, cr0, [r1, #-0]
    1418:	10000003 	andne	r0, r0, r3
    141c:	00000397 	muleq	r0, r7, r3
    1420:	00037b11 	andeq	r7, r3, r1, lsl fp
    1424:	01c61100 	biceq	r1, r6, r0, lsl #2
    1428:	00000000 	andeq	r0, r0, r0
    142c:	00002516 	andeq	r2, r0, r6, lsl r5
    1430:	00036e00 	andeq	r6, r3, r0, lsl #28
    1434:	005e1700 	subseq	r1, lr, r0, lsl #14
    1438:	000f0000 	andeq	r0, pc, r0
    143c:	a8020102 	stmdage	r2, {r1, r8}
    1440:	1800000a 	stmdane	r0, {r1, r3}
    1444:	0001fd04 	andeq	pc, r1, r4, lsl #26
    1448:	2c041800 	stccs	8, cr1, [r4], {-0}
    144c:	0c000000 	stceq	0, cr0, [r0], {-0}
    1450:	00001214 	andeq	r1, r0, r4, lsl r2
    1454:	03810418 	orreq	r0, r1, #24, 8	; 0x18000000
    1458:	ad160000 	ldcge	0, cr0, [r6, #-0]
    145c:	97000002 	strls	r0, [r0, -r2]
    1460:	19000003 	stmdbne	r0, {r0, r1}
    1464:	f0041800 			; <UNDEFINED> instruction: 0xf0041800
    1468:	18000001 	stmdane	r0, {r0}
    146c:	0001eb04 	andeq	lr, r1, r4, lsl #22
    1470:	0e251a00 	vmuleq.f32	s2, s10, s0
    1474:	9c040000 	stcls	0, cr0, [r4], {-0}
    1478:	0001f014 	andeq	pc, r1, r4, lsl r0	; <UNPREDICTABLE>
    147c:	08a40b00 	stmiaeq	r4!, {r8, r9, fp}
    1480:	04050000 	streq	r0, [r5], #-0
    1484:	00005914 	andeq	r5, r0, r4, lsl r9
    1488:	8c030500 	cfstr32hi	mvfx0, [r3], {-0}
    148c:	0b00008f 	bleq	16d0 <shift+0x16d0>
    1490:	000003ee 	andeq	r0, r0, lr, ror #7
    1494:	59140705 	ldmdbpl	r4, {r0, r2, r8, r9, sl}
    1498:	05000000 	streq	r0, [r0, #-0]
    149c:	008f9003 	addeq	r9, pc, r3
    14a0:	06890b00 	streq	r0, [r9], r0, lsl #22
    14a4:	0a050000 	beq	1414ac <__bss_end+0x1384e0>
    14a8:	00005914 	andeq	r5, r0, r4, lsl r9
    14ac:	94030500 	strls	r0, [r3], #-1280	; 0xfffffb00
    14b0:	0800008f 	stmdaeq	r0, {r0, r1, r2, r3, r7}
    14b4:	00000b11 	andeq	r0, r0, r1, lsl fp
    14b8:	00380405 	eorseq	r0, r8, r5, lsl #8
    14bc:	0d050000 	stceq	0, cr0, [r5, #-0]
    14c0:	00041c0c 	andeq	r1, r4, ip, lsl #24
    14c4:	654e0900 	strbvs	r0, [lr, #-2304]	; 0xfffff700
    14c8:	0a000077 	beq	16ac <shift+0x16ac>
    14cc:	00000b08 	andeq	r0, r0, r8, lsl #22
    14d0:	12af0a01 	adcne	r0, pc, #4096	; 0x1000
    14d4:	0a020000 	beq	814dc <__bss_end+0x78510>
    14d8:	00000ac3 	andeq	r0, r0, r3, asr #21
    14dc:	0a7d0a03 	beq	1f43cf0 <__bss_end+0x1f3ad24>
    14e0:	0a040000 	beq	1014e8 <__bss_end+0xf851c>
    14e4:	00000c98 	muleq	r0, r8, ip
    14e8:	ed060005 	stc	0, cr0, [r6, #-20]	; 0xffffffec
    14ec:	10000007 	andne	r0, r0, r7
    14f0:	5b081b05 	blpl	20810c <__bss_end+0x1ff140>
    14f4:	07000004 	streq	r0, [r0, -r4]
    14f8:	0500726c 	streq	r7, [r0, #-620]	; 0xfffffd94
    14fc:	045b131d 	ldrbeq	r1, [fp], #-797	; 0xfffffce3
    1500:	07000000 	streq	r0, [r0, -r0]
    1504:	05007073 	streq	r7, [r0, #-115]	; 0xffffff8d
    1508:	045b131e 	ldrbeq	r1, [fp], #-798	; 0xfffffce2
    150c:	07040000 	streq	r0, [r4, -r0]
    1510:	05006370 	streq	r6, [r0, #-880]	; 0xfffffc90
    1514:	045b131f 	ldrbeq	r1, [fp], #-799	; 0xfffffce1
    1518:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
    151c:	00000803 	andeq	r0, r0, r3, lsl #16
    1520:	5b132005 	blpl	4c953c <__bss_end+0x4c0570>
    1524:	0c000004 	stceq	0, cr0, [r0], {4}
    1528:	07040200 	streq	r0, [r4, -r0, lsl #4]
    152c:	00001ce0 	andeq	r1, r0, r0, ror #25
    1530:	0004d106 	andeq	sp, r4, r6, lsl #2
    1534:	28057000 	stmdacs	r5, {ip, sp, lr}
    1538:	0004f208 	andeq	pc, r4, r8, lsl #4
    153c:	12880e00 	addne	r0, r8, #0, 28
    1540:	2a050000 	bcs	141548 <__bss_end+0x13857c>
    1544:	00041c12 	andeq	r1, r4, r2, lsl ip
    1548:	70070000 	andvc	r0, r7, r0
    154c:	05006469 	streq	r6, [r0, #-1129]	; 0xfffffb97
    1550:	005e122b 	subseq	r1, lr, fp, lsr #4
    1554:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
    1558:	00001abe 			; <UNDEFINED> instruction: 0x00001abe
    155c:	e5112c05 	ldr	r2, [r1, #-3077]	; 0xfffff3fb
    1560:	14000003 	strne	r0, [r0], #-3
    1564:	000b1d0e 	andeq	r1, fp, lr, lsl #26
    1568:	122d0500 	eorne	r0, sp, #0, 10
    156c:	0000005e 	andeq	r0, r0, lr, asr r0
    1570:	0b2b0e18 	bleq	ac4dd8 <__bss_end+0xabbe0c>
    1574:	2e050000 	cdpcs	0, 0, cr0, cr5, cr0, {0}
    1578:	00005e12 	andeq	r5, r0, r2, lsl lr
    157c:	950e1c00 	strls	r1, [lr, #-3072]	; 0xfffff400
    1580:	05000007 	streq	r0, [r0, #-7]
    1584:	04f2312f 	ldrbteq	r3, [r2], #303	; 0x12f
    1588:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
    158c:	00000b58 	andeq	r0, r0, r8, asr fp
    1590:	38093005 	stmdacc	r9, {r0, r2, ip, sp}
    1594:	60000000 	andvs	r0, r0, r0
    1598:	000f820e 	andeq	r8, pc, lr, lsl #4
    159c:	0e310500 	cfabs32eq	mvfx0, mvfx1
    15a0:	0000004d 	andeq	r0, r0, sp, asr #32
    15a4:	08570e64 	ldmdaeq	r7, {r2, r5, r6, r9, sl, fp}^
    15a8:	33050000 	movwcc	r0, #20480	; 0x5000
    15ac:	00004d0e 	andeq	r4, r0, lr, lsl #26
    15b0:	4e0e6800 	cdpmi	8, 0, cr6, cr14, cr0, {0}
    15b4:	05000008 	streq	r0, [r0, #-8]
    15b8:	004d0e34 	subeq	r0, sp, r4, lsr lr
    15bc:	006c0000 	rsbeq	r0, ip, r0
    15c0:	00039d16 	andeq	r9, r3, r6, lsl sp
    15c4:	00050200 	andeq	r0, r5, r0, lsl #4
    15c8:	005e1700 	subseq	r1, lr, r0, lsl #14
    15cc:	000f0000 	andeq	r0, pc, r0
    15d0:	0011950b 	andseq	r9, r1, fp, lsl #10
    15d4:	140a0600 	strne	r0, [sl], #-1536	; 0xfffffa00
    15d8:	00000059 	andeq	r0, r0, r9, asr r0
    15dc:	8f980305 	svchi	0x00980305
    15e0:	cb080000 	blgt	2015e8 <__bss_end+0x1f861c>
    15e4:	0500000a 	streq	r0, [r0, #-10]
    15e8:	00003804 	andeq	r3, r0, r4, lsl #16
    15ec:	0c0d0600 	stceq	6, cr0, [sp], {-0}
    15f0:	00000533 	andeq	r0, r0, r3, lsr r5
    15f4:	0005f90a 	andeq	pc, r5, sl, lsl #18
    15f8:	e30a0000 	movw	r0, #40960	; 0xa000
    15fc:	01000003 	tsteq	r0, r3
    1600:	05140300 	ldreq	r0, [r4, #-768]	; 0xfffffd00
    1604:	57080000 	strpl	r0, [r8, -r0]
    1608:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    160c:	00003804 	andeq	r3, r0, r4, lsl #16
    1610:	0c140600 	ldceq	6, cr0, [r4], {-0}
    1614:	00000557 	andeq	r0, r0, r7, asr r5
    1618:	0012bd0a 	andseq	fp, r2, sl, lsl #26
    161c:	e10a0000 	mrs	r0, (UNDEF: 10)
    1620:	01000015 	tsteq	r0, r5, lsl r0
    1624:	05380300 	ldreq	r0, [r8, #-768]!	; 0xfffffd00
    1628:	4c060000 	stcmi	0, cr0, [r6], {-0}
    162c:	0c000010 	stceq	0, cr0, [r0], {16}
    1630:	91081b06 	tstls	r8, r6, lsl #22
    1634:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
    1638:	000004a3 	andeq	r0, r0, r3, lsr #9
    163c:	91191d06 	tstls	r9, r6, lsl #26
    1640:	00000005 	andeq	r0, r0, r5
    1644:	0005b50e 	andeq	fp, r5, lr, lsl #10
    1648:	191e0600 	ldmdbne	lr, {r9, sl}
    164c:	00000591 	muleq	r0, r1, r5
    1650:	0ff60e04 	svceq	0x00f60e04
    1654:	1f060000 	svcne	0x00060000
    1658:	00059713 	andeq	r9, r5, r3, lsl r7
    165c:	18000800 	stmdane	r0, {fp}
    1660:	00055c04 	andeq	r5, r5, r4, lsl #24
    1664:	62041800 	andvs	r1, r4, #0, 16
    1668:	0d000004 	stceq	0, cr0, [r0, #-16]
    166c:	0000069c 	muleq	r0, ip, r6
    1670:	07220614 			; <UNDEFINED> instruction: 0x07220614
    1674:	0000081f 	andeq	r0, r0, pc, lsl r8
    1678:	000ab90e 	andeq	fp, sl, lr, lsl #18
    167c:	12260600 	eorne	r0, r6, #0, 12
    1680:	0000004d 	andeq	r0, r0, sp, asr #32
    1684:	054f0e00 	strbeq	r0, [pc, #-3584]	; 88c <shift+0x88c>
    1688:	29060000 	stmdbcs	r6, {}	; <UNPREDICTABLE>
    168c:	0005911d 	andeq	r9, r5, sp, lsl r1
    1690:	de0e0400 	cfcpysle	mvf0, mvf14
    1694:	0600000e 	streq	r0, [r0], -lr
    1698:	05911d2c 	ldreq	r1, [r1, #3372]	; 0xd2c
    169c:	1b080000 	blne	2016a4 <__bss_end+0x1f86d8>
    16a0:	0000112f 	andeq	r1, r0, pc, lsr #2
    16a4:	290e2f06 	stmdbcs	lr, {r1, r2, r8, r9, sl, fp, sp}
    16a8:	e5000010 	str	r0, [r0, #-16]
    16ac:	f0000005 			; <UNDEFINED> instruction: 0xf0000005
    16b0:	10000005 	andne	r0, r0, r5
    16b4:	00000824 	andeq	r0, r0, r4, lsr #16
    16b8:	00059111 	andeq	r9, r5, r1, lsl r1
    16bc:	051c0000 	ldreq	r0, [ip, #-0]
    16c0:	06000010 			; <UNDEFINED> instruction: 0x06000010
    16c4:	04a80e31 	strteq	r0, [r8], #3633	; 0xe31
    16c8:	036e0000 	cmneq	lr, #0
    16cc:	06080000 	streq	r0, [r8], -r0
    16d0:	06130000 	ldreq	r0, [r3], -r0
    16d4:	24100000 	ldrcs	r0, [r0], #-0
    16d8:	11000008 	tstne	r0, r8
    16dc:	00000597 	muleq	r0, r7, r5
    16e0:	108e1300 	addne	r1, lr, r0, lsl #6
    16e4:	35060000 	strcc	r0, [r6, #-0]
    16e8:	000fd11d 	andeq	sp, pc, sp, lsl r1	; <UNPREDICTABLE>
    16ec:	00059100 	andeq	r9, r5, r0, lsl #2
    16f0:	062c0200 	strteq	r0, [ip], -r0, lsl #4
    16f4:	06320000 	ldrteq	r0, [r2], -r0
    16f8:	24100000 	ldrcs	r0, [r0], #-0
    16fc:	00000008 	andeq	r0, r0, r8
    1700:	000a1413 	andeq	r1, sl, r3, lsl r4
    1704:	1d370600 	ldcne	6, cr0, [r7, #-0]
    1708:	00000da2 	andeq	r0, r0, r2, lsr #27
    170c:	00000591 	muleq	r0, r1, r5
    1710:	00064b02 	andeq	r4, r6, r2, lsl #22
    1714:	00065100 	andeq	r5, r6, r0, lsl #2
    1718:	08241000 	stmdaeq	r4!, {ip}
    171c:	1d000000 	stcne	0, cr0, [r0, #-0]
    1720:	00000b88 	andeq	r0, r0, r8, lsl #23
    1724:	3d443906 	vstrcc.16	s7, [r4, #-12]	; <UNPREDICTABLE>
    1728:	0c000008 	stceq	0, cr0, [r0], {8}
    172c:	069c1302 	ldreq	r1, [ip], r2, lsl #6
    1730:	3c060000 	stccc	0, cr0, [r6], {-0}
    1734:	00126409 	andseq	r6, r2, r9, lsl #8
    1738:	00082400 	andeq	r2, r8, r0, lsl #8
    173c:	06780100 	ldrbteq	r0, [r8], -r0, lsl #2
    1740:	067e0000 	ldrbteq	r0, [lr], -r0
    1744:	24100000 	ldrcs	r0, [r0], #-0
    1748:	00000008 	andeq	r0, r0, r8
    174c:	00063313 	andeq	r3, r6, r3, lsl r3
    1750:	123f0600 	eorsne	r0, pc, #0, 12
    1754:	00001104 	andeq	r1, r0, r4, lsl #2
    1758:	0000004d 	andeq	r0, r0, sp, asr #32
    175c:	00069701 	andeq	r9, r6, r1, lsl #14
    1760:	0006ac00 	andeq	sl, r6, r0, lsl #24
    1764:	08241000 	stmdaeq	r4!, {ip}
    1768:	46110000 	ldrmi	r0, [r1], -r0
    176c:	11000008 	tstne	r0, r8
    1770:	0000005e 	andeq	r0, r0, lr, asr r0
    1774:	00036e11 	andeq	r6, r3, r1, lsl lr
    1778:	14140000 	ldrne	r0, [r4], #-0
    177c:	06000010 			; <UNDEFINED> instruction: 0x06000010
    1780:	0ce60e42 	stcleq	14, cr0, [r6], #264	; 0x108
    1784:	c1010000 	mrsgt	r0, (UNDEF: 1)
    1788:	c7000006 	strgt	r0, [r0, -r6]
    178c:	10000006 	andne	r0, r0, r6
    1790:	00000824 	andeq	r0, r0, r4, lsr #16
    1794:	09761300 	ldmdbeq	r6!, {r8, r9, ip}^
    1798:	45060000 	strmi	r0, [r6, #-0]
    179c:	00057417 	andeq	r7, r5, r7, lsl r4
    17a0:	00059700 	andeq	r9, r5, r0, lsl #14
    17a4:	06e00100 	strbteq	r0, [r0], r0, lsl #2
    17a8:	06e60000 	strbteq	r0, [r6], r0
    17ac:	4c100000 	ldcmi	0, cr0, [r0], {-0}
    17b0:	00000008 	andeq	r0, r0, r8
    17b4:	0005ba13 	andeq	fp, r5, r3, lsl sl
    17b8:	17480600 	strbne	r0, [r8, -r0, lsl #12]
    17bc:	00000f8e 	andeq	r0, r0, lr, lsl #31
    17c0:	00000597 	muleq	r0, r7, r5
    17c4:	0006ff01 	andeq	pc, r6, r1, lsl #30
    17c8:	00070a00 	andeq	r0, r7, r0, lsl #20
    17cc:	084c1000 	stmdaeq	ip, {ip}^
    17d0:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    17d4:	00000000 	andeq	r0, r0, r0
    17d8:	0011b214 	andseq	fp, r1, r4, lsl r2
    17dc:	0e4b0600 	cdpeq	6, 4, cr0, cr11, cr0, {0}
    17e0:	00000468 	andeq	r0, r0, r8, ror #8
    17e4:	00071f01 	andeq	r1, r7, r1, lsl #30
    17e8:	00072500 	andeq	r2, r7, r0, lsl #10
    17ec:	08241000 	stmdaeq	r4!, {ip}
    17f0:	13000000 	movwne	r0, #0
    17f4:	00001005 	andeq	r1, r0, r5
    17f8:	090e4d06 	stmdbeq	lr, {r1, r2, r8, sl, fp, lr}
    17fc:	6e000008 	cdpvs	0, 0, cr0, cr0, cr8, {0}
    1800:	01000003 	tsteq	r0, r3
    1804:	0000073e 	andeq	r0, r0, lr, lsr r7
    1808:	00000749 	andeq	r0, r0, r9, asr #14
    180c:	00082410 	andeq	r2, r8, r0, lsl r4
    1810:	004d1100 	subeq	r1, sp, r0, lsl #2
    1814:	13000000 	movwne	r0, #0
    1818:	0000098a 	andeq	r0, r0, sl, lsl #19
    181c:	07125006 	ldreq	r5, [r2, -r6]
    1820:	4d00000d 	stcmi	0, cr0, [r0, #-52]	; 0xffffffcc
    1824:	01000000 	mrseq	r0, (UNDEF: 0)
    1828:	00000762 	andeq	r0, r0, r2, ror #14
    182c:	0000076d 	andeq	r0, r0, sp, ror #14
    1830:	00082410 	andeq	r2, r8, r0, lsl r4
    1834:	039d1100 	orrseq	r1, sp, #0, 2
    1838:	13000000 	movwne	r0, #0
    183c:	00000513 	andeq	r0, r0, r3, lsl r5
    1840:	bd0e5306 	stclt	3, cr5, [lr, #-24]	; 0xffffffe8
    1844:	6e000008 	cdpvs	0, 0, cr0, cr0, cr8, {0}
    1848:	01000003 	tsteq	r0, r3
    184c:	00000786 	andeq	r0, r0, r6, lsl #15
    1850:	00000791 	muleq	r0, r1, r7
    1854:	00082410 	andeq	r2, r8, r0, lsl r4
    1858:	004d1100 	subeq	r1, sp, r0, lsl #2
    185c:	14000000 	strne	r0, [r0], #-0
    1860:	000009ee 	andeq	r0, r0, lr, ror #19
    1864:	ad0e5606 	stcge	6, cr5, [lr, #-24]	; 0xffffffe8
    1868:	01000010 	tsteq	r0, r0, lsl r0
    186c:	000007a6 	andeq	r0, r0, r6, lsr #15
    1870:	000007c5 	andeq	r0, r0, r5, asr #15
    1874:	00082410 	andeq	r2, r8, r0, lsl r4
    1878:	00a91100 	adceq	r1, r9, r0, lsl #2
    187c:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1880:	11000000 	mrsne	r0, (UNDEF: 0)
    1884:	0000004d 	andeq	r0, r0, sp, asr #32
    1888:	00004d11 	andeq	r4, r0, r1, lsl sp
    188c:	08521100 	ldmdaeq	r2, {r8, ip}^
    1890:	14000000 	strne	r0, [r0], #-0
    1894:	00000fbb 			; <UNDEFINED> instruction: 0x00000fbb
    1898:	300e5806 	andcc	r5, lr, r6, lsl #16
    189c:	01000007 	tsteq	r0, r7
    18a0:	000007da 	ldrdeq	r0, [r0], -sl
    18a4:	000007f9 	strdeq	r0, [r0], -r9
    18a8:	00082410 	andeq	r2, r8, r0, lsl r4
    18ac:	00e01100 	rsceq	r1, r0, r0, lsl #2
    18b0:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    18b4:	11000000 	mrsne	r0, (UNDEF: 0)
    18b8:	0000004d 	andeq	r0, r0, sp, asr #32
    18bc:	00004d11 	andeq	r4, r0, r1, lsl sp
    18c0:	08521100 	ldmdaeq	r2, {r8, ip}^
    18c4:	15000000 	strne	r0, [r0, #-0]
    18c8:	00000661 	andeq	r0, r0, r1, ror #12
    18cc:	c20e5b06 	andgt	r5, lr, #6144	; 0x1800
    18d0:	6e000006 	cdpvs	0, 0, cr0, cr0, cr6, {0}
    18d4:	01000003 	tsteq	r0, r3
    18d8:	0000080e 	andeq	r0, r0, lr, lsl #16
    18dc:	00082410 	andeq	r2, r8, r0, lsl r4
    18e0:	05141100 	ldreq	r1, [r4, #-256]	; 0xffffff00
    18e4:	58110000 	ldmdapl	r1, {}	; <UNPREDICTABLE>
    18e8:	00000008 	andeq	r0, r0, r8
    18ec:	059d0300 	ldreq	r0, [sp, #768]	; 0x300
    18f0:	04180000 	ldreq	r0, [r8], #-0
    18f4:	0000059d 	muleq	r0, sp, r5
    18f8:	0005911e 	andeq	r9, r5, lr, lsl r1
    18fc:	00083700 	andeq	r3, r8, r0, lsl #14
    1900:	00083d00 	andeq	r3, r8, r0, lsl #26
    1904:	08241000 	stmdaeq	r4!, {ip}
    1908:	1f000000 	svcne	0x00000000
    190c:	0000059d 	muleq	r0, sp, r5
    1910:	0000082a 	andeq	r0, r0, sl, lsr #16
    1914:	003f0418 	eorseq	r0, pc, r8, lsl r4	; <UNPREDICTABLE>
    1918:	04180000 	ldreq	r0, [r8], #-0
    191c:	0000081f 	andeq	r0, r0, pc, lsl r8
    1920:	00650420 	rsbeq	r0, r5, r0, lsr #8
    1924:	04210000 	strteq	r0, [r1], #-0
    1928:	00101d1a 	andseq	r1, r0, sl, lsl sp
    192c:	195e0600 	ldmdbne	lr, {r9, sl}^
    1930:	0000059d 	muleq	r0, sp, r5
    1934:	00002c16 	andeq	r2, r0, r6, lsl ip
    1938:	00087600 	andeq	r7, r8, r0, lsl #12
    193c:	005e1700 	subseq	r1, lr, r0, lsl #14
    1940:	00090000 	andeq	r0, r9, r0
    1944:	00086603 	andeq	r6, r8, r3, lsl #12
    1948:	14972200 	ldrne	r2, [r7], #512	; 0x200
    194c:	a4010000 	strge	r0, [r1], #-0
    1950:	0008760c 	andeq	r7, r8, ip, lsl #12
    1954:	9c030500 	cfstr32ls	mvfx0, [r3], {-0}
    1958:	2300008f 	movwcs	r0, #143	; 0x8f
    195c:	000013b9 			; <UNDEFINED> instruction: 0x000013b9
    1960:	4b0aa601 	blmi	2ab16c <__bss_end+0x2a21a0>
    1964:	4d000015 	stcmi	0, cr0, [r0, #-84]	; 0xffffffac
    1968:	74000000 	strvc	r0, [r0], #-0
    196c:	b4000087 	strlt	r0, [r0], #-135	; 0xffffff79
    1970:	01000000 	mrseq	r0, (UNDEF: 0)
    1974:	0008eb9c 	muleq	r8, ip, fp
    1978:	20cd2400 	sbccs	r2, sp, r0, lsl #8
    197c:	a6010000 	strge	r0, [r1], -r0
    1980:	00037b1b 	andeq	r7, r3, fp, lsl fp
    1984:	ac910300 	ldcge	3, cr0, [r1], {0}
    1988:	15aa247f 	strne	r2, [sl, #1151]!	; 0x47f
    198c:	a6010000 	strge	r0, [r1], -r0
    1990:	00004d2a 	andeq	r4, r0, sl, lsr #26
    1994:	a8910300 	ldmge	r1, {r8, r9}
    1998:	1533227f 	ldrne	r2, [r3, #-639]!	; 0xfffffd81
    199c:	a8010000 	stmdage	r1, {}	; <UNPREDICTABLE>
    19a0:	0008eb0a 	andeq	lr, r8, sl, lsl #22
    19a4:	b4910300 	ldrlt	r0, [r1], #768	; 0x300
    19a8:	13b4227f 			; <UNDEFINED> instruction: 0x13b4227f
    19ac:	ac010000 	stcge	0, cr0, [r1], {-0}
    19b0:	00003809 	andeq	r3, r0, r9, lsl #16
    19b4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    19b8:	00251600 	eoreq	r1, r5, r0, lsl #12
    19bc:	08fb0000 	ldmeq	fp!, {}^	; <UNPREDICTABLE>
    19c0:	5e170000 	cdppl	0, 1, cr0, cr7, cr0, {0}
    19c4:	3f000000 	svccc	0x00000000
    19c8:	158f2500 	strne	r2, [pc, #1280]	; 1ed0 <shift+0x1ed0>
    19cc:	98010000 	stmdals	r1, {}	; <UNPREDICTABLE>
    19d0:	0016060a 	andseq	r0, r6, sl, lsl #12
    19d4:	00004d00 	andeq	r4, r0, r0, lsl #26
    19d8:	00873800 	addeq	r3, r7, r0, lsl #16
    19dc:	00003c00 	andeq	r3, r0, r0, lsl #24
    19e0:	389c0100 	ldmcc	ip, {r8}
    19e4:	26000009 	strcs	r0, [r0], -r9
    19e8:	00716572 	rsbseq	r6, r1, r2, ror r5
    19ec:	57209a01 	strpl	r9, [r0, -r1, lsl #20]!
    19f0:	02000005 	andeq	r0, r0, #5
    19f4:	40227491 	mlami	r2, r1, r4, r7
    19f8:	01000015 	tsteq	r0, r5, lsl r0
    19fc:	004d0e9b 	umaaleq	r0, sp, fp, lr
    1a00:	91020000 	mrsls	r0, (UNDEF: 2)
    1a04:	b9270070 	stmdblt	r7!, {r4, r5, r6}
    1a08:	01000015 	tsteq	r0, r5, lsl r0
    1a0c:	13d5068f 	bicsne	r0, r5, #149946368	; 0x8f00000
    1a10:	86fc0000 	ldrbthi	r0, [ip], r0
    1a14:	003c0000 	eorseq	r0, ip, r0
    1a18:	9c010000 	stcls	0, cr0, [r1], {-0}
    1a1c:	00000971 	andeq	r0, r0, r1, ror r9
    1a20:	00148324 	andseq	r8, r4, r4, lsr #6
    1a24:	218f0100 	orrcs	r0, pc, r0, lsl #2
    1a28:	0000004d 	andeq	r0, r0, sp, asr #32
    1a2c:	266c9102 	strbtcs	r9, [ip], -r2, lsl #2
    1a30:	00716572 	rsbseq	r6, r1, r2, ror r5
    1a34:	57209101 	strpl	r9, [r0, -r1, lsl #2]!
    1a38:	02000005 	andeq	r0, r0, #5
    1a3c:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1a40:	0000156c 	andeq	r1, r0, ip, ror #10
    1a44:	b30a8301 	movwlt	r8, #41729	; 0xa301
    1a48:	4d000014 	stcmi	0, cr0, [r0, #-80]	; 0xffffffb0
    1a4c:	c0000000 	andgt	r0, r0, r0
    1a50:	3c000086 	stccc	0, cr0, [r0], {134}	; 0x86
    1a54:	01000000 	mrseq	r0, (UNDEF: 0)
    1a58:	0009ae9c 	muleq	r9, ip, lr
    1a5c:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1a60:	85010071 	strhi	r0, [r1, #-113]	; 0xffffff8f
    1a64:	00053320 	andeq	r3, r5, r0, lsr #6
    1a68:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1a6c:	0013ad22 	andseq	sl, r3, r2, lsr #26
    1a70:	0e860100 	rmfeqs	f0, f6, f0
    1a74:	0000004d 	andeq	r0, r0, sp, asr #32
    1a78:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1a7c:	0016ae25 	andseq	sl, r6, r5, lsr #28
    1a80:	0a770100 	beq	1dc1e88 <__bss_end+0x1db8ebc>
    1a84:	00001459 	andeq	r1, r0, r9, asr r4
    1a88:	0000004d 	andeq	r0, r0, sp, asr #32
    1a8c:	00008684 	andeq	r8, r0, r4, lsl #13
    1a90:	0000003c 	andeq	r0, r0, ip, lsr r0
    1a94:	09eb9c01 	stmibeq	fp!, {r0, sl, fp, ip, pc}^
    1a98:	72260000 	eorvc	r0, r6, #0
    1a9c:	01007165 	tsteq	r0, r5, ror #2
    1aa0:	05332079 	ldreq	r2, [r3, #-121]!	; 0xffffff87
    1aa4:	91020000 	mrsls	r0, (UNDEF: 2)
    1aa8:	13ad2274 			; <UNDEFINED> instruction: 0x13ad2274
    1aac:	7a010000 	bvc	41ab4 <__bss_end+0x38ae8>
    1ab0:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1ab4:	70910200 	addsvc	r0, r1, r0, lsl #4
    1ab8:	14c72500 	strbne	r2, [r7], #1280	; 0x500
    1abc:	6b010000 	blvs	41ac4 <__bss_end+0x38af8>
    1ac0:	0015d606 	andseq	sp, r5, r6, lsl #12
    1ac4:	00036e00 	andeq	r6, r3, r0, lsl #28
    1ac8:	00863000 	addeq	r3, r6, r0
    1acc:	00005400 	andeq	r5, r0, r0, lsl #8
    1ad0:	379c0100 	ldrcc	r0, [ip, r0, lsl #2]
    1ad4:	2400000a 	strcs	r0, [r0], #-10
    1ad8:	00001540 	andeq	r1, r0, r0, asr #10
    1adc:	4d156b01 	vldrmi	d6, [r5, #-4]
    1ae0:	02000000 	andeq	r0, r0, #0
    1ae4:	4e246c91 	mcrmi	12, 1, r6, cr4, cr1, {4}
    1ae8:	01000008 	tsteq	r0, r8
    1aec:	004d256b 	subeq	r2, sp, fp, ror #10
    1af0:	91020000 	mrsls	r0, (UNDEF: 2)
    1af4:	16a62268 	strtne	r2, [r6], r8, ror #4
    1af8:	6d010000 	stcvs	0, cr0, [r1, #-0]
    1afc:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1b00:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1b04:	13ec2500 	mvnne	r2, #0, 10
    1b08:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1b0c:	00163d12 	andseq	r3, r6, r2, lsl sp
    1b10:	00008b00 	andeq	r8, r0, r0, lsl #22
    1b14:	0085e000 	addeq	lr, r5, r0
    1b18:	00005000 	andeq	r5, r0, r0
    1b1c:	929c0100 	addsls	r0, ip, #0, 2
    1b20:	2400000a 	strcs	r0, [r0], #-10
    1b24:	0000122f 	andeq	r1, r0, pc, lsr #4
    1b28:	4d205e01 	stcmi	14, cr5, [r0, #-4]!
    1b2c:	02000000 	andeq	r0, r0, #0
    1b30:	75246c91 	strvc	r6, [r4, #-3217]!	; 0xfffff36f
    1b34:	01000015 	tsteq	r0, r5, lsl r0
    1b38:	004d2f5e 	subeq	r2, sp, lr, asr pc
    1b3c:	91020000 	mrsls	r0, (UNDEF: 2)
    1b40:	084e2468 	stmdaeq	lr, {r3, r5, r6, sl, sp}^
    1b44:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1b48:	00004d3f 	andeq	r4, r0, pc, lsr sp
    1b4c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1b50:	0016a622 	andseq	sl, r6, r2, lsr #12
    1b54:	16600100 	strbtne	r0, [r0], -r0, lsl #2
    1b58:	0000008b 	andeq	r0, r0, fp, lsl #1
    1b5c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1b60:	00153925 	andseq	r3, r5, r5, lsr #18
    1b64:	0a520100 	beq	1481f6c <__bss_end+0x1478fa0>
    1b68:	000013f1 	strdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    1b6c:	0000004d 	andeq	r0, r0, sp, asr #32
    1b70:	0000859c 	muleq	r0, ip, r5
    1b74:	00000044 	andeq	r0, r0, r4, asr #32
    1b78:	0ade9c01 	beq	ff7a8b84 <__bss_end+0xff79fbb8>
    1b7c:	2f240000 	svccs	0x00240000
    1b80:	01000012 	tsteq	r0, r2, lsl r0
    1b84:	004d1a52 	subeq	r1, sp, r2, asr sl
    1b88:	91020000 	mrsls	r0, (UNDEF: 2)
    1b8c:	1575246c 	ldrbne	r2, [r5, #-1132]!	; 0xfffffb94
    1b90:	52010000 	andpl	r0, r1, #0
    1b94:	00004d29 	andeq	r4, r0, r9, lsr #26
    1b98:	68910200 	ldmvs	r1, {r9}
    1b9c:	00166c22 	andseq	r6, r6, r2, lsr #24
    1ba0:	0e540100 	rdfeqs	f0, f4, f0
    1ba4:	0000004d 	andeq	r0, r0, sp, asr #32
    1ba8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1bac:	00166625 	andseq	r6, r6, r5, lsr #12
    1bb0:	0a450100 	beq	1141fb8 <__bss_end+0x1138fec>
    1bb4:	00001648 	andeq	r1, r0, r8, asr #12
    1bb8:	0000004d 	andeq	r0, r0, sp, asr #32
    1bbc:	0000854c 	andeq	r8, r0, ip, asr #10
    1bc0:	00000050 	andeq	r0, r0, r0, asr r0
    1bc4:	0b399c01 	bleq	e68bd0 <__bss_end+0xe5fc04>
    1bc8:	2f240000 	svccs	0x00240000
    1bcc:	01000012 	tsteq	r0, r2, lsl r0
    1bd0:	004d1945 	subeq	r1, sp, r5, asr #18
    1bd4:	91020000 	mrsls	r0, (UNDEF: 2)
    1bd8:	1514246c 	ldrne	r2, [r4, #-1132]	; 0xfffffb94
    1bdc:	45010000 	strmi	r0, [r1, #-0]
    1be0:	00011d30 	andeq	r1, r1, r0, lsr sp
    1be4:	68910200 	ldmvs	r1, {r9}
    1be8:	00157b24 	andseq	r7, r5, r4, lsr #22
    1bec:	41450100 	mrsmi	r0, (UNDEF: 85)
    1bf0:	00000858 	andeq	r0, r0, r8, asr r8
    1bf4:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1bf8:	000016a6 	andeq	r1, r0, r6, lsr #13
    1bfc:	4d0e4701 	stcmi	7, cr4, [lr, #-4]
    1c00:	02000000 	andeq	r0, r0, #0
    1c04:	27007491 			; <UNDEFINED> instruction: 0x27007491
    1c08:	000012b7 			; <UNDEFINED> instruction: 0x000012b7
    1c0c:	1e063f01 	cdpne	15, 0, cr3, cr6, cr1, {0}
    1c10:	20000015 	andcs	r0, r0, r5, lsl r0
    1c14:	2c000085 	stccs	0, cr0, [r0], {133}	; 0x85
    1c18:	01000000 	mrseq	r0, (UNDEF: 0)
    1c1c:	000b639c 	muleq	fp, ip, r3
    1c20:	122f2400 	eorne	r2, pc, #0, 8
    1c24:	3f010000 	svccc	0x00010000
    1c28:	00004d15 	andeq	r4, r0, r5, lsl sp
    1c2c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1c30:	15b32500 	ldrne	r2, [r3, #1280]!	; 0x500
    1c34:	32010000 	andcc	r0, r1, #0
    1c38:	0015810a 	andseq	r8, r5, sl, lsl #2
    1c3c:	00004d00 	andeq	r4, r0, r0, lsl #26
    1c40:	0084d000 	addeq	sp, r4, r0
    1c44:	00005000 	andeq	r5, r0, r0
    1c48:	be9c0100 	fmllte	f0, f4, f0
    1c4c:	2400000b 	strcs	r0, [r0], #-11
    1c50:	0000122f 	andeq	r1, r0, pc, lsr #4
    1c54:	4d193201 	lfmmi	f3, 4, [r9, #-4]
    1c58:	02000000 	andeq	r0, r0, #0
    1c5c:	82246c91 	eorhi	r6, r4, #37120	; 0x9100
    1c60:	01000016 	tsteq	r0, r6, lsl r0
    1c64:	037b2b32 	cmneq	fp, #51200	; 0xc800
    1c68:	91020000 	mrsls	r0, (UNDEF: 2)
    1c6c:	15ae2468 	strne	r2, [lr, #1128]!	; 0x468
    1c70:	32010000 	andcc	r0, r1, #0
    1c74:	00004d3c 	andeq	r4, r0, ip, lsr sp
    1c78:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1c7c:	00163722 	andseq	r3, r6, r2, lsr #14
    1c80:	0e340100 	rsfeqs	f0, f4, f0
    1c84:	0000004d 	andeq	r0, r0, sp, asr #32
    1c88:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1c8c:	0016d025 	andseq	sp, r6, r5, lsr #32
    1c90:	0a250100 	beq	942098 <__bss_end+0x9390cc>
    1c94:	00001689 	andeq	r1, r0, r9, lsl #13
    1c98:	0000004d 	andeq	r0, r0, sp, asr #32
    1c9c:	00008480 	andeq	r8, r0, r0, lsl #9
    1ca0:	00000050 	andeq	r0, r0, r0, asr r0
    1ca4:	0c199c01 	ldceq	12, cr9, [r9], {1}
    1ca8:	2f240000 	svccs	0x00240000
    1cac:	01000012 	tsteq	r0, r2, lsl r0
    1cb0:	004d1825 	subeq	r1, sp, r5, lsr #16
    1cb4:	91020000 	mrsls	r0, (UNDEF: 2)
    1cb8:	1682246c 	strne	r2, [r2], ip, ror #8
    1cbc:	25010000 	strcs	r0, [r1, #-0]
    1cc0:	000c1f2a 	andeq	r1, ip, sl, lsr #30
    1cc4:	68910200 	ldmvs	r1, {r9}
    1cc8:	0015ae24 	andseq	sl, r5, r4, lsr #28
    1ccc:	3b250100 	blcc	9420d4 <__bss_end+0x939108>
    1cd0:	0000004d 	andeq	r0, r0, sp, asr #32
    1cd4:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1cd8:	000013be 			; <UNDEFINED> instruction: 0x000013be
    1cdc:	4d0e2701 	stcmi	7, cr2, [lr, #-4]
    1ce0:	02000000 	andeq	r0, r0, #0
    1ce4:	18007491 	stmdane	r0, {r0, r4, r7, sl, ip, sp, lr}
    1ce8:	00002504 	andeq	r2, r0, r4, lsl #10
    1cec:	0c190300 	ldceq	3, cr0, [r9], {-0}
    1cf0:	46250000 	strtmi	r0, [r5], -r0
    1cf4:	01000015 	tsteq	r0, r5, lsl r0
    1cf8:	16dc0a19 			; <UNDEFINED> instruction: 0x16dc0a19
    1cfc:	004d0000 	subeq	r0, sp, r0
    1d00:	843c0000 	ldrthi	r0, [ip], #-0
    1d04:	00440000 	subeq	r0, r4, r0
    1d08:	9c010000 	stcls	0, cr0, [r1], {-0}
    1d0c:	00000c70 	andeq	r0, r0, r0, ror ip
    1d10:	0016c724 	andseq	ip, r6, r4, lsr #14
    1d14:	1b190100 	blne	64211c <__bss_end+0x639150>
    1d18:	0000037b 	andeq	r0, r0, fp, ror r3
    1d1c:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1d20:	0000167d 	andeq	r1, r0, sp, ror r6
    1d24:	c6351901 	ldrtgt	r1, [r5], -r1, lsl #18
    1d28:	02000001 	andeq	r0, r0, #1
    1d2c:	2f226891 	svccs	0x00226891
    1d30:	01000012 	tsteq	r0, r2, lsl r0
    1d34:	004d0e1b 	subeq	r0, sp, fp, lsl lr
    1d38:	91020000 	mrsls	r0, (UNDEF: 2)
    1d3c:	77280074 			; <UNDEFINED> instruction: 0x77280074
    1d40:	01000014 	tsteq	r0, r4, lsl r0
    1d44:	13c40614 	bicne	r0, r4, #20, 12	; 0x1400000
    1d48:	84200000 	strthi	r0, [r0], #-0
    1d4c:	001c0000 	andseq	r0, ip, r0
    1d50:	9c010000 	stcls	0, cr0, [r1], {-0}
    1d54:	00167327 	andseq	r7, r6, r7, lsr #6
    1d58:	060e0100 	streq	r0, [lr], -r0, lsl #2
    1d5c:	000013fd 	strdeq	r1, [r0], -sp
    1d60:	000083f4 	strdeq	r8, [r0], -r4
    1d64:	0000002c 	andeq	r0, r0, ip, lsr #32
    1d68:	0cb09c01 	ldceq	12, cr9, [r0], #4
    1d6c:	50240000 	eorpl	r0, r4, r0
    1d70:	01000014 	tsteq	r0, r4, lsl r0
    1d74:	0038140e 	eorseq	r1, r8, lr, lsl #8
    1d78:	91020000 	mrsls	r0, (UNDEF: 2)
    1d7c:	d5290074 	strle	r0, [r9, #-116]!	; 0xffffff8c
    1d80:	01000016 	tsteq	r0, r6, lsl r0
    1d84:	15280a04 	strne	r0, [r8, #-2564]!	; 0xfffff5fc
    1d88:	004d0000 	subeq	r0, sp, r0
    1d8c:	83c80000 	bichi	r0, r8, #0
    1d90:	002c0000 	eoreq	r0, ip, r0
    1d94:	9c010000 	stcls	0, cr0, [r1], {-0}
    1d98:	64697026 	strbtvs	r7, [r9], #-38	; 0xffffffda
    1d9c:	0e060100 	adfeqs	f0, f6, f0
    1da0:	0000004d 	andeq	r0, r0, sp, asr #32
    1da4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1da8:	00032e00 	andeq	r2, r3, r0, lsl #28
    1dac:	11000400 	tstne	r0, r0, lsl #8
    1db0:	04000007 	streq	r0, [r0], #-7
    1db4:	0012ca01 	andseq	ip, r2, r1, lsl #20
    1db8:	171c0400 	ldrne	r0, [ip, -r0, lsl #8]
    1dbc:	14cd0000 	strbne	r0, [sp], #0
    1dc0:	88280000 	stmdahi	r8!, {}	; <UNPREDICTABLE>
    1dc4:	04b80000 	ldrteq	r0, [r8], #0
    1dc8:	07370000 	ldreq	r0, [r7, -r0]!
    1dcc:	49020000 	stmdbmi	r2, {}	; <UNPREDICTABLE>
    1dd0:	03000000 	movweq	r0, #0
    1dd4:	0000175e 	andeq	r1, r0, lr, asr r7
    1dd8:	61100501 	tstvs	r0, r1, lsl #10
    1ddc:	11000000 	mrsne	r0, (UNDEF: 0)
    1de0:	33323130 	teqcc	r2, #48, 2
    1de4:	37363534 			; <UNDEFINED> instruction: 0x37363534
    1de8:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    1dec:	46454443 	strbmi	r4, [r5], -r3, asr #8
    1df0:	01040000 	mrseq	r0, (UNDEF: 4)
    1df4:	00250103 	eoreq	r0, r5, r3, lsl #2
    1df8:	74050000 	strvc	r0, [r5], #-0
    1dfc:	61000000 	mrsvs	r0, (UNDEF: 0)
    1e00:	06000000 	streq	r0, [r0], -r0
    1e04:	00000066 	andeq	r0, r0, r6, rrx
    1e08:	51070010 	tstpl	r7, r0, lsl r0
    1e0c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1e10:	1ce50704 	stclne	7, cr0, [r5], #16
    1e14:	01080000 	mrseq	r0, (UNDEF: 8)
    1e18:	000d6f08 	andeq	r6, sp, r8, lsl #30
    1e1c:	006d0700 	rsbeq	r0, sp, r0, lsl #14
    1e20:	2a090000 	bcs	241e28 <__bss_end+0x238e5c>
    1e24:	0a000000 	beq	1e2c <shift+0x1e2c>
    1e28:	0000178d 	andeq	r1, r0, sp, lsl #15
    1e2c:	78066401 	stmdavc	r6, {r0, sl, sp, lr}
    1e30:	60000017 	andvs	r0, r0, r7, lsl r0
    1e34:	8000008c 	andhi	r0, r0, ip, lsl #1
    1e38:	01000000 	mrseq	r0, (UNDEF: 0)
    1e3c:	0000fb9c 	muleq	r0, ip, fp
    1e40:	72730b00 	rsbsvc	r0, r3, #0, 22
    1e44:	64010063 	strvs	r0, [r1], #-99	; 0xffffff9d
    1e48:	0000fb19 	andeq	pc, r0, r9, lsl fp	; <UNPREDICTABLE>
    1e4c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1e50:	7473640b 	ldrbtvc	r6, [r3], #-1035	; 0xfffffbf5
    1e54:	24640100 	strbtcs	r0, [r4], #-256	; 0xffffff00
    1e58:	00000102 	andeq	r0, r0, r2, lsl #2
    1e5c:	0b609102 	bleq	182626c <__bss_end+0x181d2a0>
    1e60:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1e64:	042d6401 	strteq	r6, [sp], #-1025	; 0xfffffbff
    1e68:	02000001 	andeq	r0, r0, #1
    1e6c:	f20c5c91 	vfma.f32	d5, d28, d1
    1e70:	01000017 	tsteq	r0, r7, lsl r0
    1e74:	010b0e66 	tsteq	fp, r6, ror #28
    1e78:	91020000 	mrsls	r0, (UNDEF: 2)
    1e7c:	176a0c70 			; <UNDEFINED> instruction: 0x176a0c70
    1e80:	67010000 	strvs	r0, [r1, -r0]
    1e84:	00011108 	andeq	r1, r1, r8, lsl #2
    1e88:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1e8c:	008c880d 	addeq	r8, ip, sp, lsl #16
    1e90:	00004800 	andeq	r4, r0, r0, lsl #16
    1e94:	00690e00 	rsbeq	r0, r9, r0, lsl #28
    1e98:	040b6901 	streq	r6, [fp], #-2305	; 0xfffff6ff
    1e9c:	02000001 	andeq	r0, r0, #1
    1ea0:	00007491 	muleq	r0, r1, r4
    1ea4:	0101040f 	tsteq	r1, pc, lsl #8
    1ea8:	11100000 	tstne	r0, r0
    1eac:	05041204 	streq	r1, [r4, #-516]	; 0xfffffdfc
    1eb0:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1eb4:	0074040f 	rsbseq	r0, r4, pc, lsl #8
    1eb8:	040f0000 	streq	r0, [pc], #-0	; 1ec0 <shift+0x1ec0>
    1ebc:	0000006d 	andeq	r0, r0, sp, rrx
    1ec0:	0017030a 	andseq	r0, r7, sl, lsl #6
    1ec4:	065c0100 	ldrbeq	r0, [ip], -r0, lsl #2
    1ec8:	00001710 	andeq	r1, r0, r0, lsl r7
    1ecc:	00008bf8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    1ed0:	00000068 	andeq	r0, r0, r8, rrx
    1ed4:	01769c01 	cmneq	r6, r1, lsl #24
    1ed8:	eb130000 	bl	4c1ee0 <__bss_end+0x4b8f14>
    1edc:	01000017 	tsteq	r0, r7, lsl r0
    1ee0:	0102125c 	tsteq	r2, ip, asr r2
    1ee4:	91020000 	mrsls	r0, (UNDEF: 2)
    1ee8:	1709136c 	strne	r1, [r9, -ip, ror #6]
    1eec:	5c010000 	stcpl	0, cr0, [r1], {-0}
    1ef0:	0001041e 	andeq	r0, r1, lr, lsl r4
    1ef4:	68910200 	ldmvs	r1, {r9}
    1ef8:	6d656d0e 	stclvs	13, cr6, [r5, #-56]!	; 0xffffffc8
    1efc:	085e0100 	ldmdaeq	lr, {r8}^
    1f00:	00000111 	andeq	r0, r0, r1, lsl r1
    1f04:	0d709102 	ldfeqp	f1, [r0, #-8]!
    1f08:	00008c14 	andeq	r8, r0, r4, lsl ip
    1f0c:	0000003c 	andeq	r0, r0, ip, lsr r0
    1f10:	0100690e 	tsteq	r0, lr, lsl #18
    1f14:	01040b60 	tsteq	r4, r0, ror #22
    1f18:	91020000 	mrsls	r0, (UNDEF: 2)
    1f1c:	14000074 	strne	r0, [r0], #-116	; 0xffffff8c
    1f20:	00001794 	muleq	r0, r4, r7
    1f24:	ad055201 	sfmge	f5, 4, [r5, #-4]
    1f28:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    1f2c:	a4000001 	strge	r0, [r0], #-1
    1f30:	5400008b 	strpl	r0, [r0], #-139	; 0xffffff75
    1f34:	01000000 	mrseq	r0, (UNDEF: 0)
    1f38:	0001af9c 	muleq	r1, ip, pc	; <UNPREDICTABLE>
    1f3c:	00730b00 	rsbseq	r0, r3, r0, lsl #22
    1f40:	0b185201 	bleq	61674c <__bss_end+0x60d780>
    1f44:	02000001 	andeq	r0, r0, #1
    1f48:	690e6c91 	stmdbvs	lr, {r0, r4, r7, sl, fp, sp, lr}
    1f4c:	06540100 	ldrbeq	r0, [r4], -r0, lsl #2
    1f50:	00000104 	andeq	r0, r0, r4, lsl #2
    1f54:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1f58:	0017db14 	andseq	sp, r7, r4, lsl fp
    1f5c:	05420100 	strbeq	r0, [r2, #-256]	; 0xffffff00
    1f60:	0000179b 	muleq	r0, fp, r7
    1f64:	00000104 	andeq	r0, r0, r4, lsl #2
    1f68:	00008af8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    1f6c:	000000ac 	andeq	r0, r0, ip, lsr #1
    1f70:	02159c01 	andseq	r9, r5, #256	; 0x100
    1f74:	730b0000 	movwvc	r0, #45056	; 0xb000
    1f78:	42010031 	andmi	r0, r1, #49	; 0x31
    1f7c:	00010b19 	andeq	r0, r1, r9, lsl fp
    1f80:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1f84:	0032730b 	eorseq	r7, r2, fp, lsl #6
    1f88:	0b294201 	bleq	a52794 <__bss_end+0xa497c8>
    1f8c:	02000001 	andeq	r0, r0, #1
    1f90:	6e0b6891 	mcrvs	8, 0, r6, cr11, cr1, {4}
    1f94:	01006d75 	tsteq	r0, r5, ror sp
    1f98:	01043142 	tsteq	r4, r2, asr #2
    1f9c:	91020000 	mrsls	r0, (UNDEF: 2)
    1fa0:	31750e64 	cmncc	r5, r4, ror #28
    1fa4:	10440100 	subne	r0, r4, r0, lsl #2
    1fa8:	00000215 	andeq	r0, r0, r5, lsl r2
    1fac:	0e779102 	expeqs	f1, f2
    1fb0:	01003275 	tsteq	r0, r5, ror r2
    1fb4:	02151444 	andseq	r1, r5, #68, 8	; 0x44000000
    1fb8:	91020000 	mrsls	r0, (UNDEF: 2)
    1fbc:	01080076 	tsteq	r8, r6, ror r0
    1fc0:	000d6608 	andeq	r6, sp, r8, lsl #12
    1fc4:	17e31400 	strbne	r1, [r3, r0, lsl #8]!
    1fc8:	36010000 	strcc	r0, [r1], -r0
    1fcc:	0017ca07 	andseq	ip, r7, r7, lsl #20
    1fd0:	00011100 	andeq	r1, r1, r0, lsl #2
    1fd4:	008a3800 	addeq	r3, sl, r0, lsl #16
    1fd8:	0000c000 	andeq	ip, r0, r0
    1fdc:	759c0100 	ldrvc	r0, [ip, #256]	; 0x100
    1fe0:	13000002 	movwne	r0, #2
    1fe4:	000016fe 	strdeq	r1, [r0], -lr
    1fe8:	11153601 	tstne	r5, r1, lsl #12
    1fec:	02000001 	andeq	r0, r0, #1
    1ff0:	730b6c91 	movwvc	r6, #48273	; 0xbc91
    1ff4:	01006372 	tsteq	r0, r2, ror r3
    1ff8:	010b2736 	tsteq	fp, r6, lsr r7
    1ffc:	91020000 	mrsls	r0, (UNDEF: 2)
    2000:	756e0b68 	strbvc	r0, [lr, #-2920]!	; 0xfffff498
    2004:	3601006d 	strcc	r0, [r1], -sp, rrx
    2008:	00010430 	andeq	r0, r1, r0, lsr r4
    200c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2010:	0100690e 	tsteq	r0, lr, lsl #18
    2014:	01040638 	tsteq	r4, r8, lsr r6
    2018:	91020000 	mrsls	r0, (UNDEF: 2)
    201c:	ba140074 	blt	5021f4 <__bss_end+0x4f9228>
    2020:	01000017 	tsteq	r0, r7, lsl r0
    2024:	17bf0524 	ldrne	r0, [pc, r4, lsr #10]!
    2028:	01040000 	mrseq	r0, (UNDEF: 4)
    202c:	899c0000 	ldmibhi	ip, {}	; <UNPREDICTABLE>
    2030:	009c0000 	addseq	r0, ip, r0
    2034:	9c010000 	stcls	0, cr0, [r1], {-0}
    2038:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
    203c:	0016f813 	andseq	pc, r6, r3, lsl r8	; <UNPREDICTABLE>
    2040:	16240100 	strtne	r0, [r4], -r0, lsl #2
    2044:	0000010b 	andeq	r0, r0, fp, lsl #2
    2048:	0c6c9102 	stfeqp	f1, [ip], #-8
    204c:	00001771 	andeq	r1, r0, r1, ror r7
    2050:	04062601 	streq	r2, [r6], #-1537	; 0xfffff9ff
    2054:	02000001 	andeq	r0, r0, #1
    2058:	15007491 	strne	r7, [r0, #-1169]	; 0xfffffb6f
    205c:	000017f9 	strdeq	r1, [r0], -r9
    2060:	fe060801 	vcmla.f16	d0, d6, d1[0], #0
    2064:	28000017 	stmdacs	r0, {r0, r1, r2, r4}
    2068:	74000088 	strvc	r0, [r0], #-136	; 0xffffff78
    206c:	01000001 	tsteq	r0, r1
    2070:	16f8139c 	usatne	r1, #24, ip, lsl #7
    2074:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    2078:	00006618 	andeq	r6, r0, r8, lsl r6
    207c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2080:	00177113 	andseq	r7, r7, r3, lsl r1
    2084:	25080100 	strcs	r0, [r8, #-256]	; 0xffffff00
    2088:	00000111 	andeq	r0, r0, r1, lsl r1
    208c:	13609102 	cmnne	r0, #-2147483648	; 0x80000000
    2090:	00001788 	andeq	r1, r0, r8, lsl #15
    2094:	663a0801 	ldrtvs	r0, [sl], -r1, lsl #16
    2098:	02000000 	andeq	r0, r0, #0
    209c:	690e5c91 	stmdbvs	lr, {r0, r4, r7, sl, fp, ip, lr}
    20a0:	060a0100 	streq	r0, [sl], -r0, lsl #2
    20a4:	00000104 	andeq	r0, r0, r4, lsl #2
    20a8:	0d749102 	ldfeqp	f1, [r4, #-8]!
    20ac:	000088f4 	strdeq	r8, [r0], -r4
    20b0:	00000098 	muleq	r0, r8, r0
    20b4:	01006a0e 	tsteq	r0, lr, lsl #20
    20b8:	01040b1c 	tsteq	r4, ip, lsl fp
    20bc:	91020000 	mrsls	r0, (UNDEF: 2)
    20c0:	891c0d70 	ldmdbhi	ip, {r4, r5, r6, r8, sl, fp}
    20c4:	00600000 	rsbeq	r0, r0, r0
    20c8:	630e0000 	movwvs	r0, #57344	; 0xe000
    20cc:	081e0100 	ldmdaeq	lr, {r8}
    20d0:	0000006d 	andeq	r0, r0, sp, rrx
    20d4:	006f9102 	rsbeq	r9, pc, r2, lsl #2
    20d8:	22000000 	andcs	r0, r0, #0
    20dc:	02000000 	andeq	r0, r0, #0
    20e0:	00083800 	andeq	r3, r8, r0, lsl #16
    20e4:	6d010400 	cfstrsvs	mvf0, [r1, #-0]
    20e8:	e0000009 	and	r0, r0, r9
    20ec:	ec00008c 	stc	0, cr0, [r0], {140}	; 0x8c
    20f0:	0a00008e 	beq	2330 <shift+0x2330>
    20f4:	3a000018 	bcc	215c <shift+0x215c>
    20f8:	9f000018 	svcls	0x00000018
    20fc:	01000018 	tsteq	r0, r8, lsl r0
    2100:	00002280 	andeq	r2, r0, r0, lsl #5
    2104:	4c000200 	sfmmi	f0, 4, [r0], {-0}
    2108:	04000008 	streq	r0, [r0], #-8
    210c:	0009ea01 	andeq	lr, r9, r1, lsl #20
    2110:	008eec00 	addeq	lr, lr, r0, lsl #24
    2114:	008ef000 	addeq	pc, lr, r0
    2118:	00180a00 	andseq	r0, r8, r0, lsl #20
    211c:	00183a00 	andseq	r3, r8, r0, lsl #20
    2120:	00189f00 	andseq	r9, r8, r0, lsl #30
    2124:	09800100 	stmibeq	r0, {r8}
    2128:	0400000a 	streq	r0, [r0], #-10
    212c:	00086000 	andeq	r6, r8, r0
    2130:	3f010400 	svccc	0x00010400
    2134:	0c000029 	stceq	0, cr0, [r0], {41}	; 0x29
    2138:	00001b81 	andeq	r1, r0, r1, lsl #23
    213c:	0000183a 	andeq	r1, r0, sl, lsr r8
    2140:	00000a4a 	andeq	r0, r0, sl, asr #20
    2144:	69050402 	stmdbvs	r5, {r1, sl}
    2148:	0300746e 	movweq	r7, #1134	; 0x46e
    214c:	1ce50704 	stclne	7, cr0, [r5], #16
    2150:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2154:	00035f05 	andeq	r5, r3, r5, lsl #30
    2158:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    215c:	00002486 	andeq	r2, r0, r6, lsl #9
    2160:	001bee04 	andseq	lr, fp, r4, lsl #28
    2164:	162a0100 	strtne	r0, [sl], -r0, lsl #2
    2168:	00000024 	andeq	r0, r0, r4, lsr #32
    216c:	00205104 	eoreq	r5, r0, r4, lsl #2
    2170:	152f0100 	strne	r0, [pc, #-256]!	; 2078 <shift+0x2078>
    2174:	00000051 	andeq	r0, r0, r1, asr r0
    2178:	00570405 	subseq	r0, r7, r5, lsl #8
    217c:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
    2180:	66000000 	strvs	r0, [r0], -r0
    2184:	07000000 	streq	r0, [r0, -r0]
    2188:	00000066 	andeq	r0, r0, r6, rrx
    218c:	6c040500 	cfstr32vs	mvfx0, [r4], {-0}
    2190:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2194:	0028f004 	eoreq	pc, r8, r4
    2198:	0f360100 	svceq	0x00360100
    219c:	00000079 	andeq	r0, r0, r9, ror r0
    21a0:	007f0405 	rsbseq	r0, pc, r5, lsl #8
    21a4:	1d060000 	stcne	0, cr0, [r6, #-0]
    21a8:	93000000 	movwls	r0, #0
    21ac:	07000000 	streq	r0, [r0, -r0]
    21b0:	00000066 	andeq	r0, r0, r6, rrx
    21b4:	00006607 	andeq	r6, r0, r7, lsl #12
    21b8:	01030000 	mrseq	r0, (UNDEF: 3)
    21bc:	000d6608 	andeq	r6, sp, r8, lsl #12
    21c0:	22b40900 	adcscs	r0, r4, #0, 18
    21c4:	bb010000 	bllt	421cc <__bss_end+0x39200>
    21c8:	00004512 	andeq	r4, r0, r2, lsl r5
    21cc:	291e0900 	ldmdbcs	lr, {r8, fp}
    21d0:	be010000 	cdplt	0, 0, cr0, cr1, cr0, {0}
    21d4:	00006d10 	andeq	r6, r0, r0, lsl sp
    21d8:	06010300 	streq	r0, [r1], -r0, lsl #6
    21dc:	00000d68 	andeq	r0, r0, r8, ror #26
    21e0:	001f580a 	andseq	r5, pc, sl, lsl #16
    21e4:	93010700 	movwls	r0, #5888	; 0x1700
    21e8:	02000000 	andeq	r0, r0, #0
    21ec:	01e60617 	mvneq	r0, r7, lsl r6
    21f0:	550b0000 	strpl	r0, [fp, #-0]
    21f4:	0000001a 	andeq	r0, r0, sl, lsl r0
    21f8:	001e500b 	andseq	r5, lr, fp
    21fc:	ac0b0100 	stfges	f0, [fp], {-0}
    2200:	02000023 	andeq	r0, r0, #35	; 0x23
    2204:	0028340b 	eoreq	r3, r8, fp, lsl #8
    2208:	380b0300 	stmdacc	fp, {r8, r9}
    220c:	04000023 	streq	r0, [r0], #-35	; 0xffffffdd
    2210:	0026fb0b 	eoreq	pc, r6, fp, lsl #22
    2214:	210b0500 	tstcs	fp, r0, lsl #10
    2218:	06000026 	streq	r0, [r0], -r6, lsr #32
    221c:	001a760b 	andseq	r7, sl, fp, lsl #12
    2220:	100b0700 	andne	r0, fp, r0, lsl #14
    2224:	08000027 	stmdaeq	r0, {r0, r1, r2, r5}
    2228:	00271e0b 	eoreq	r1, r7, fp, lsl #28
    222c:	0f0b0900 	svceq	0x000b0900
    2230:	0a000028 	beq	22d8 <shift+0x22d8>
    2234:	00227a0b 	eoreq	r7, r2, fp, lsl #20
    2238:	2f0b0b00 	svccs	0x000b0b00
    223c:	0c00001c 	stceq	0, cr0, [r0], {28}
    2240:	001fe10b 	andseq	lr, pc, fp, lsl #2
    2244:	670b0d00 	strvs	r0, [fp, -r0, lsl #26]
    2248:	0e000027 	cdpeq	0, 0, cr0, cr0, cr7, {1}
    224c:	001f9c0b 	andseq	r9, pc, fp, lsl #24
    2250:	b20b0f00 	andlt	r0, fp, #0, 30
    2254:	1000001f 	andne	r0, r0, pc, lsl r0
    2258:	001e870b 	andseq	r8, lr, fp, lsl #14
    225c:	1c0b1100 	stfnes	f1, [fp], {-0}
    2260:	12000023 	andne	r0, r0, #35	; 0x23
    2264:	001f140b 	andseq	r1, pc, fp, lsl #8
    2268:	cc0b1300 	stcgt	3, cr1, [fp], {-0}
    226c:	1400002b 	strne	r0, [r0], #-43	; 0xffffffd5
    2270:	0023e40b 	eoreq	lr, r3, fp, lsl #8
    2274:	410b1500 	tstmi	fp, r0, lsl #10
    2278:	16000021 	strne	r0, [r0], -r1, lsr #32
    227c:	001ad30b 	andseq	sp, sl, fp, lsl #6
    2280:	570b1700 	strpl	r1, [fp, -r0, lsl #14]
    2284:	18000028 	stmdane	r0, {r3, r5}
    2288:	002a610b 	eoreq	r6, sl, fp, lsl #2
    228c:	650b1900 	strvs	r1, [fp, #-2304]	; 0xfffff700
    2290:	1a000028 	bne	2338 <shift+0x2338>
    2294:	001f640b 	andseq	r6, pc, fp, lsl #8
    2298:	730b1b00 	movwvc	r1, #47872	; 0xbb00
    229c:	1c000028 	stcne	0, cr0, [r0], {40}	; 0x28
    22a0:	00192f0b 	andseq	r2, r9, fp, lsl #30
    22a4:	810b1d00 	tsthi	fp, r0, lsl #26
    22a8:	1e000028 	cdpne	0, 0, cr0, cr0, cr8, {1}
    22ac:	00288f0b 	eoreq	r8, r8, fp, lsl #30
    22b0:	c80b1f00 	stmdagt	fp, {r8, r9, sl, fp, ip}
    22b4:	20000018 	andcs	r0, r0, r8, lsl r0
    22b8:	0025070b 	eoreq	r0, r5, fp, lsl #14
    22bc:	ee0b2100 	adfe	f2, f3, f0
    22c0:	22000022 	andcs	r0, r0, #34	; 0x22
    22c4:	00284a0b 	eoreq	r4, r8, fp, lsl #20
    22c8:	be0b2300 	cdplt	3, 0, cr2, cr11, cr0, {0}
    22cc:	24000021 	strcs	r0, [r0], #-33	; 0xffffffdf
    22d0:	0026120b 	eoreq	r1, r6, fp, lsl #4
    22d4:	b40b2500 	strlt	r2, [fp], #-1280	; 0xfffffb00
    22d8:	26000020 	strcs	r0, [r0], -r0, lsr #32
    22dc:	001d900b 	andseq	r9, sp, fp
    22e0:	d20b2700 	andle	r2, fp, #0, 14
    22e4:	28000020 	stmdacs	r0, {r5}
    22e8:	001e2c0b 	andseq	r2, lr, fp, lsl #24
    22ec:	e20b2900 	and	r2, fp, #0, 18
    22f0:	2a000020 	bcs	2378 <shift+0x2378>
    22f4:	0022600b 	eoreq	r6, r2, fp
    22f8:	5b0b2b00 	blpl	2ccf00 <__bss_end+0x2c3f34>
    22fc:	2c000020 	stccs	0, cr0, [r0], {32}
    2300:	0025260b 	eoreq	r2, r5, fp, lsl #12
    2304:	d10b2d00 	tstle	fp, r0, lsl #26
    2308:	2e00001d 	mcrcs	0, 0, r0, cr0, cr13, {0}
    230c:	1fee0a00 	svcne	0x00ee0a00
    2310:	01070000 	mrseq	r0, (UNDEF: 7)
    2314:	00000093 	muleq	r0, r3, r0
    2318:	9f061703 	svcls	0x00061703
    231c:	0b000004 	bleq	2334 <shift+0x2334>
    2320:	00001c43 	andeq	r1, r0, r3, asr #24
    2324:	2af50b00 	bcs	ffd44f2c <__bss_end+0xffd3bf60>
    2328:	0b010000 	bleq	42330 <__bss_end+0x39364>
    232c:	00001c53 	andeq	r1, r0, r3, asr ip
    2330:	1c760b02 			; <UNDEFINED> instruction: 0x1c760b02
    2334:	0b030000 	bleq	c233c <__bss_end+0xb9370>
    2338:	0000292e 	andeq	r2, r0, lr, lsr #18
    233c:	258c0b04 	strcs	r0, [ip, #2820]	; 0xb04
    2340:	0b050000 	bleq	142348 <__bss_end+0x13937c>
    2344:	00001d00 	andeq	r1, r0, r0, lsl #26
    2348:	1e750b06 	vaddne.f64	d16, d5, d6
    234c:	0b070000 	bleq	1c2354 <__bss_end+0x1b9388>
    2350:	00001c86 	andeq	r1, r0, r6, lsl #25
    2354:	2bbb0b08 	blcs	feec4f7c <__bss_end+0xfeebbfb0>
    2358:	0b090000 	bleq	242360 <__bss_end+0x239394>
    235c:	000019a6 	andeq	r1, r0, r6, lsr #19
    2360:	2ae40b0a 	bcs	ff904f90 <__bss_end+0xff8fbfc4>
    2364:	0b0b0000 	bleq	2c236c <__bss_end+0x2b93a0>
    2368:	000021cd 	andeq	r2, r0, sp, asr #3
    236c:	2a780b0c 	bcs	1e04fa4 <__bss_end+0x1dfbfd8>
    2370:	0b0d0000 	bleq	342378 <__bss_end+0x3393ac>
    2374:	00002514 	andeq	r2, r0, r4, lsl r5
    2378:	27ad0b0e 	strcs	r0, [sp, lr, lsl #22]!
    237c:	0b0f0000 	bleq	3c2384 <__bss_end+0x3b93b8>
    2380:	00001d61 	andeq	r1, r0, r1, ror #26
    2384:	1c630b10 			; <UNDEFINED> instruction: 0x1c630b10
    2388:	0b110000 	bleq	442390 <__bss_end+0x4393c4>
    238c:	000024cc 	andeq	r2, r0, ip, asr #9
    2390:	1d4c0b12 	vstrne	d16, [ip, #-72]	; 0xffffffb8
    2394:	0b130000 	bleq	4c239c <__bss_end+0x4b93d0>
    2398:	00002ad3 	ldrdeq	r2, [r0], -r3
    239c:	19d00b14 	ldmibne	r0, {r2, r4, r8, r9, fp}^
    23a0:	0b150000 	bleq	5423a8 <__bss_end+0x5393dc>
    23a4:	0000211c 	andeq	r2, r0, ip, lsl r1
    23a8:	1c960b16 	vldmiane	r6, {d0-d10}
    23ac:	0b170000 	bleq	5c23b4 <__bss_end+0x5b93e8>
    23b0:	0000196d 	andeq	r1, r0, sp, ror #18
    23b4:	2b610b18 	blcs	184501c <__bss_end+0x183c050>
    23b8:	0b190000 	bleq	6423c0 <__bss_end+0x6393f4>
    23bc:	0000281c 	andeq	r2, r0, ip, lsl r8
    23c0:	26300b1a 			; <UNDEFINED> instruction: 0x26300b1a
    23c4:	0b1b0000 	bleq	6c23cc <__bss_end+0x6b9400>
    23c8:	00002794 	muleq	r0, r4, r7
    23cc:	28f80b1c 	ldmcs	r8!, {r2, r3, r4, r8, r9, fp}^
    23d0:	0b1d0000 	bleq	7423d8 <__bss_end+0x73940c>
    23d4:	00001cb6 			; <UNDEFINED> instruction: 0x00001cb6
    23d8:	1a410b1e 	bne	1045058 <__bss_end+0x103c08c>
    23dc:	0b1f0000 	bleq	7c23e4 <__bss_end+0x7b9418>
    23e0:	00002649 	andeq	r2, r0, r9, asr #12
    23e4:	1dad0b20 			; <UNDEFINED> instruction: 0x1dad0b20
    23e8:	0b210000 	bleq	8423f0 <__bss_end+0x839424>
    23ec:	0000259e 	muleq	r0, lr, r5
    23f0:	219e0b22 	orrscs	r0, lr, r2, lsr #22
    23f4:	0b230000 	bleq	8c23fc <__bss_end+0x8b9430>
    23f8:	00001ca6 	andeq	r1, r0, r6, lsr #25
    23fc:	274c0b24 	strbcs	r0, [ip, -r4, lsr #22]
    2400:	0b250000 	bleq	942408 <__bss_end+0x93943c>
    2404:	00001bb9 			; <UNDEFINED> instruction: 0x00001bb9
    2408:	28dd0b26 	ldmcs	sp, {r1, r2, r5, r8, r9, fp}^
    240c:	0b270000 	bleq	9c2414 <__bss_end+0x9b9448>
    2410:	00002ba8 	andeq	r2, r0, r8, lsr #23
    2414:	249f0b28 	ldrcs	r0, [pc], #2856	; 241c <shift+0x241c>
    2418:	0b290000 	bleq	a42420 <__bss_end+0xa39454>
    241c:	00001f46 	andeq	r1, r0, r6, asr #30
    2420:	26730b2a 	ldrbtcs	r0, [r3], -sl, lsr #22
    2424:	0b2b0000 	bleq	ac242c <__bss_end+0xab9460>
    2428:	000021fc 	strdeq	r2, [r0], -ip
    242c:	1a940b2c 	bne	fe5050e4 <__bss_end+0xfe4fc118>
    2430:	0b2d0000 	bleq	b42438 <__bss_end+0xb3946c>
    2434:	00001a18 	andeq	r1, r0, r8, lsl sl
    2438:	2a360b2e 	bcs	d850f8 <__bss_end+0xd7c12c>
    243c:	0b2f0000 	bleq	bc2444 <__bss_end+0xbb9478>
    2440:	0000218a 	andeq	r2, r0, sl, lsl #3
    2444:	1d260b30 	vstmdbne	r6!, {d0-d23}
    2448:	0b310000 	bleq	c42450 <__bss_end+0xc39484>
    244c:	00002169 	andeq	r2, r0, r9, ror #2
    2450:	24180b32 	ldrcs	r0, [r8], #-2866	; 0xfffff4ce
    2454:	0b330000 	bleq	cc245c <__bss_end+0xcb9490>
    2458:	00001a06 	andeq	r1, r0, r6, lsl #20
    245c:	2b960b34 	blcs	fe585134 <__bss_end+0xfe57c168>
    2460:	0b350000 	bleq	d42468 <__bss_end+0xd3949c>
    2464:	0000224d 	andeq	r2, r0, sp, asr #4
    2468:	1edf0b36 	vmovne.u8	r0, d15[1]
    246c:	0b370000 	bleq	dc2474 <__bss_end+0xdb94a8>
    2470:	0000228a 	andeq	r2, r0, sl, lsl #5
    2474:	2a9e0b38 	bcs	fe78515c <__bss_end+0xfe77c190>
    2478:	0b390000 	bleq	e42480 <__bss_end+0xe394b4>
    247c:	00001b4b 	andeq	r1, r0, fp, asr #22
    2480:	1ef20b3a 	vmovne.u8	r0, d2[5]
    2484:	0b3b0000 	bleq	ec248c <__bss_end+0xeb94c0>
    2488:	00001ebe 			; <UNDEFINED> instruction: 0x00001ebe
    248c:	18d70b3c 	ldmne	r7, {r2, r3, r4, r5, r8, r9, fp}^
    2490:	0b3d0000 	bleq	f42498 <__bss_end+0xf394cc>
    2494:	000021df 	ldrdeq	r2, [r0], -pc	; <UNPREDICTABLE>
    2498:	1fbe0b3e 	svcne	0x00be0b3e
    249c:	0b3f0000 	bleq	fc24a4 <__bss_end+0xfb94d8>
    24a0:	00001a5f 	andeq	r1, r0, pc, asr sl
    24a4:	2a4a0b40 	bcs	12851ac <__bss_end+0x127c1e0>
    24a8:	0b410000 	bleq	10424b0 <__bss_end+0x10394e4>
    24ac:	0000212f 	andeq	r2, r0, pc, lsr #2
    24b0:	1ea80b42 	vfmsne.f64	d0, d8, d2
    24b4:	0b430000 	bleq	10c24bc <__bss_end+0x10b94f0>
    24b8:	00001918 	andeq	r1, r0, r8, lsl r9
    24bc:	208c0b44 	addcs	r0, ip, r4, asr #22
    24c0:	0b450000 	bleq	11424c8 <__bss_end+0x11394fc>
    24c4:	00002078 	andeq	r2, r0, r8, ror r0
    24c8:	25f30b46 	ldrbcs	r0, [r3, #2886]!	; 0xb46
    24cc:	0b470000 	bleq	11c24d4 <__bss_end+0x11b9508>
    24d0:	000026bb 			; <UNDEFINED> instruction: 0x000026bb
    24d4:	2a150b48 	bcs	5451fc <__bss_end+0x53c230>
    24d8:	0b490000 	bleq	12424e0 <__bss_end+0x1239514>
    24dc:	00001dde 	ldrdeq	r1, [r0], -lr
    24e0:	23ce0b4a 	biccs	r0, lr, #75776	; 0x12800
    24e4:	0b4b0000 	bleq	12c24ec <__bss_end+0x12b9520>
    24e8:	00002688 	andeq	r2, r0, r8, lsl #13
    24ec:	25350b4c 	ldrcs	r0, [r5, #-2892]!	; 0xfffff4b4
    24f0:	0b4d0000 	bleq	13424f8 <__bss_end+0x133952c>
    24f4:	00002549 	andeq	r2, r0, r9, asr #10
    24f8:	255d0b4e 	ldrbcs	r0, [sp, #-2894]	; 0xfffff4b2
    24fc:	0b4f0000 	bleq	13c2504 <__bss_end+0x13b9538>
    2500:	00001bd9 	ldrdeq	r1, [r0], -r9
    2504:	1b360b50 	blne	d8524c <__bss_end+0xd7c280>
    2508:	0b510000 	bleq	1442510 <__bss_end+0x1439544>
    250c:	00001b5e 	andeq	r1, r0, lr, asr fp
    2510:	27bf0b52 	sbfxcs	r0, r2, #22, #32
    2514:	0b530000 	bleq	14c251c <__bss_end+0x14b9550>
    2518:	00001ba4 	andeq	r1, r0, r4, lsr #23
    251c:	27d30b54 			; <UNDEFINED> instruction: 0x27d30b54
    2520:	0b550000 	bleq	1542528 <__bss_end+0x153955c>
    2524:	000027e7 	andeq	r2, r0, r7, ror #15
    2528:	27fb0b56 	ubfxcs	r0, r6, #22, #28
    252c:	0b570000 	bleq	15c2534 <__bss_end+0x15b9568>
    2530:	00001d38 	andeq	r1, r0, r8, lsr sp
    2534:	1d120b58 	vldrne	d0, [r2, #-352]	; 0xfffffea0
    2538:	0b590000 	bleq	1642540 <__bss_end+0x1639574>
    253c:	000020a0 	andeq	r2, r0, r0, lsr #1
    2540:	229d0b5a 	addscs	r0, sp, #92160	; 0x16800
    2544:	0b5b0000 	bleq	16c254c <__bss_end+0x16b9580>
    2548:	00002026 	andeq	r2, r0, r6, lsr #32
    254c:	18ab0b5c 	stmiane	fp!, {r2, r3, r4, r6, r8, r9, fp}
    2550:	0b5d0000 	bleq	1742558 <__bss_end+0x173958c>
    2554:	00001e60 	andeq	r1, r0, r0, ror #28
    2558:	22c60b5e 	sbccs	r0, r6, #96256	; 0x17800
    255c:	0b5f0000 	bleq	17c2564 <__bss_end+0x17b9598>
    2560:	000020f2 	strdeq	r2, [r0], -r2	; <UNPREDICTABLE>
    2564:	25b10b60 	ldrcs	r0, [r1, #2912]!	; 0xb60
    2568:	0b610000 	bleq	1842570 <__bss_end+0x18395a4>
    256c:	00002b13 	andeq	r2, r0, r3, lsl fp
    2570:	23b90b62 			; <UNDEFINED> instruction: 0x23b90b62
    2574:	0b630000 	bleq	18c257c <__bss_end+0x18b95b0>
    2578:	00001e03 	andeq	r1, r0, r3, lsl #28
    257c:	197f0b64 	ldmdbne	pc!, {r2, r5, r6, r8, r9, fp}^	; <UNPREDICTABLE>
    2580:	0b650000 	bleq	1942588 <__bss_end+0x19395bc>
    2584:	0000193d 	andeq	r1, r0, sp, lsr r9
    2588:	22fe0b66 	rscscs	r0, lr, #104448	; 0x19800
    258c:	0b670000 	bleq	19c2594 <__bss_end+0x19b95c8>
    2590:	00002439 	andeq	r2, r0, r9, lsr r4
    2594:	25d50b68 	ldrbcs	r0, [r5, #2920]	; 0xb68
    2598:	0b690000 	bleq	1a425a0 <__bss_end+0x1a395d4>
    259c:	00002107 	andeq	r2, r0, r7, lsl #2
    25a0:	2b4c0b6a 	blcs	1305350 <__bss_end+0x12fc384>
    25a4:	0b6b0000 	bleq	1ac25ac <__bss_end+0x1ab95e0>
    25a8:	0000221d 	andeq	r2, r0, sp, lsl r2
    25ac:	18fc0b6c 	ldmne	ip!, {r2, r3, r5, r6, r8, r9, fp}^
    25b0:	0b6d0000 	bleq	1b425b8 <__bss_end+0x1b395ec>
    25b4:	00001a2c 	andeq	r1, r0, ip, lsr #20
    25b8:	1e170b6e 	vnmlane.f64	d0, d7, d30
    25bc:	0b6f0000 	bleq	1bc25c4 <__bss_end+0x1bb95f8>
    25c0:	00001cc7 	andeq	r1, r0, r7, asr #25
    25c4:	02030070 	andeq	r0, r3, #112	; 0x70
    25c8:	000a0107 	andeq	r0, sl, r7, lsl #2
    25cc:	04bc0c00 	ldrteq	r0, [ip], #3072	; 0xc00
    25d0:	04b10000 	ldrteq	r0, [r1], #0
    25d4:	000d0000 	andeq	r0, sp, r0
    25d8:	0004a60e 	andeq	sl, r4, lr, lsl #12
    25dc:	c8040500 	stmdagt	r4, {r8, sl}
    25e0:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
    25e4:	000004b6 			; <UNDEFINED> instruction: 0x000004b6
    25e8:	6f080103 	svcvs	0x00080103
    25ec:	0e00000d 	cdpeq	0, 0, cr0, cr0, cr13, {0}
    25f0:	000004c1 	andeq	r0, r0, r1, asr #9
    25f4:	001ac40f 	andseq	ip, sl, pc, lsl #8
    25f8:	01440400 	cmpeq	r4, r0, lsl #8
    25fc:	0004b11a 	andeq	fp, r4, sl, lsl r1
    2600:	1e980f00 	cdpne	15, 9, cr0, cr8, cr0, {0}
    2604:	79040000 	stmdbvc	r4, {}	; <UNPREDICTABLE>
    2608:	04b11a01 	ldrteq	r1, [r1], #2561	; 0xa01
    260c:	c10c0000 	mrsgt	r0, (UNDEF: 12)
    2610:	f2000004 	vhadd.s8	d0, d0, d4
    2614:	0d000004 	stceq	0, cr0, [r0, #-16]
    2618:	20c40900 	sbccs	r0, r4, r0, lsl #18
    261c:	2d050000 	stccs	0, cr0, [r5, #-0]
    2620:	0004e70d 	andeq	lr, r4, sp, lsl #14
    2624:	28b90900 	ldmcs	r9!, {r8, fp}
    2628:	35050000 	strcc	r0, [r5, #-0]
    262c:	0001e61c 	andeq	lr, r1, ip, lsl r6
    2630:	1d740a00 	vldmdbne	r4!, {s1-s0}
    2634:	01070000 	mrseq	r0, (UNDEF: 7)
    2638:	00000093 	muleq	r0, r3, r0
    263c:	7d0e3705 	stcvc	7, cr3, [lr, #-20]	; 0xffffffec
    2640:	0b000005 	bleq	265c <shift+0x265c>
    2644:	00001911 	andeq	r1, r0, r1, lsl r9
    2648:	1fab0b00 	svcne	0x00ab0b00
    264c:	0b010000 	bleq	42654 <__bss_end+0x39688>
    2650:	00002ab0 			; <UNDEFINED> instruction: 0x00002ab0
    2654:	2a8b0b02 	bcs	fe2c5264 <__bss_end+0xfe2bc298>
    2658:	0b030000 	bleq	c2660 <__bss_end+0xb9694>
    265c:	00002367 	andeq	r2, r0, r7, ror #6
    2660:	27090b04 	strcs	r0, [r9, -r4, lsl #22]
    2664:	0b050000 	bleq	14266c <__bss_end+0x1396a0>
    2668:	00001b07 	andeq	r1, r0, r7, lsl #22
    266c:	1ae90b06 	bne	ffa4528c <__bss_end+0xffa3c2c0>
    2670:	0b070000 	bleq	1c2678 <__bss_end+0x1b96ac>
    2674:	00001c3c 	andeq	r1, r0, ip, lsr ip
    2678:	21f50b08 	mvnscs	r0, r8, lsl #22
    267c:	0b090000 	bleq	242684 <__bss_end+0x2396b8>
    2680:	00001b0e 	andeq	r1, r0, lr, lsl #22
    2684:	1b7a0b0a 	blne	1e852b4 <__bss_end+0x1e7c2e8>
    2688:	0b0b0000 	bleq	2c2690 <__bss_end+0x2b96c4>
    268c:	00001b73 	andeq	r1, r0, r3, ror fp
    2690:	1b000b0c 	blne	52c8 <shift+0x52c8>
    2694:	0b0d0000 	bleq	34269c <__bss_end+0x3396d0>
    2698:	00002760 	andeq	r2, r0, r0, ror #14
    269c:	24570b0e 	ldrbcs	r0, [r7], #-2830	; 0xfffff4f2
    26a0:	000f0000 	andeq	r0, pc, r0
    26a4:	00260b04 	eoreq	r0, r6, r4, lsl #22
    26a8:	013c0500 	teqeq	ip, r0, lsl #10
    26ac:	0000050a 	andeq	r0, r0, sl, lsl #10
    26b0:	0026dc09 	eoreq	sp, r6, r9, lsl #24
    26b4:	0f3e0500 	svceq	0x003e0500
    26b8:	0000057d 	andeq	r0, r0, sp, ror r5
    26bc:	00278309 	eoreq	r8, r7, r9, lsl #6
    26c0:	0c470500 	cfstr64eq	mvdx0, [r7], {-0}
    26c4:	0000001d 	andeq	r0, r0, sp, lsl r0
    26c8:	001ab409 	andseq	fp, sl, r9, lsl #8
    26cc:	0c480500 	cfstr64eq	mvdx0, [r8], {-0}
    26d0:	0000001d 	andeq	r0, r0, sp, lsl r0
    26d4:	00289d10 	eoreq	r9, r8, r0, lsl sp
    26d8:	26eb0900 	strbtcs	r0, [fp], r0, lsl #18
    26dc:	49050000 	stmdbmi	r5, {}	; <UNPREDICTABLE>
    26e0:	0005be14 	andeq	fp, r5, r4, lsl lr
    26e4:	ad040500 	cfstr32ge	mvfx0, [r4, #-0]
    26e8:	11000005 	tstne	r0, r5
    26ec:	001f7509 	andseq	r7, pc, r9, lsl #10
    26f0:	0f4b0500 	svceq	0x004b0500
    26f4:	000005d1 	ldrdeq	r0, [r0], -r1
    26f8:	05c40405 	strbeq	r0, [r4, #1029]	; 0x405
    26fc:	5e120000 	cdppl	0, 1, cr0, cr2, cr0, {0}
    2700:	09000026 	stmdbeq	r0, {r1, r2, r5}
    2704:	00002354 	andeq	r2, r0, r4, asr r3
    2708:	e80d4f05 	stmda	sp, {r0, r2, r8, r9, sl, fp, lr}
    270c:	05000005 	streq	r0, [r0, #-5]
    2710:	0005d704 	andeq	sp, r5, r4, lsl #14
    2714:	1c221300 	stcne	3, cr1, [r2], #-0
    2718:	05340000 	ldreq	r0, [r4, #-0]!
    271c:	19150158 	ldmdbne	r5, {r3, r4, r6, r8}
    2720:	14000006 	strne	r0, [r0], #-6
    2724:	000020cd 	andeq	r2, r0, sp, asr #1
    2728:	0f015a05 	svceq	0x00015a05
    272c:	000004b6 			; <UNDEFINED> instruction: 0x000004b6
    2730:	1c061400 	cfstrsne	mvf1, [r6], {-0}
    2734:	5b050000 	blpl	14273c <__bss_end+0x139770>
    2738:	061e1401 	ldreq	r1, [lr], -r1, lsl #8
    273c:	00040000 	andeq	r0, r4, r0
    2740:	0005ee0e 	andeq	lr, r5, lr, lsl #28
    2744:	00b90c00 	adcseq	r0, r9, r0, lsl #24
    2748:	062e0000 	strteq	r0, [lr], -r0
    274c:	24150000 	ldrcs	r0, [r5], #-0
    2750:	2d000000 	stccs	0, cr0, [r0, #-0]
    2754:	06190c00 	ldreq	r0, [r9], -r0, lsl #24
    2758:	06390000 	ldrteq	r0, [r9], -r0
    275c:	000d0000 	andeq	r0, sp, r0
    2760:	00062e0e 	andeq	r2, r6, lr, lsl #28
    2764:	1ffd0f00 	svcne	0x00fd0f00
    2768:	5c050000 	stcpl	0, cr0, [r5], {-0}
    276c:	06390301 	ldrteq	r0, [r9], -r1, lsl #6
    2770:	6d0f0000 	stcvs	0, cr0, [pc, #-0]	; 2778 <shift+0x2778>
    2774:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    2778:	1d0c015f 	stfnes	f0, [ip, #-380]	; 0xfffffe84
    277c:	16000000 	strne	r0, [r0], -r0
    2780:	0000269c 	muleq	r0, ip, r6
    2784:	00930107 	addseq	r0, r3, r7, lsl #2
    2788:	72050000 	andvc	r0, r5, #0
    278c:	070e0601 	streq	r0, [lr, -r1, lsl #12]
    2790:	480b0000 	stmdami	fp, {}	; <UNPREDICTABLE>
    2794:	00000023 	andeq	r0, r0, r3, lsr #32
    2798:	0019b80b 	andseq	fp, r9, fp, lsl #16
    279c:	c40b0200 	strgt	r0, [fp], #-512	; 0xfffffe00
    27a0:	03000019 	movweq	r0, #25
    27a4:	001da00b 	andseq	sl, sp, fp
    27a8:	840b0300 	strhi	r0, [fp], #-768	; 0xfffffd00
    27ac:	04000023 	streq	r0, [r0], #-35	; 0xffffffdd
    27b0:	001f070b 	andseq	r0, pc, fp, lsl #14
    27b4:	e20b0400 	and	r0, fp, #0, 8
    27b8:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    27bc:	001fd40b 	andseq	sp, pc, fp, lsl #8
    27c0:	0e0b0500 	cfsh32eq	mvfx0, mvfx11, #0
    27c4:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    27c8:	001f380b 	andseq	r3, pc, fp, lsl #16
    27cc:	a50b0500 	strge	r0, [fp, #-1280]	; 0xfffffb00
    27d0:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    27d4:	0019ee0b 	andseq	lr, r9, fp, lsl #28
    27d8:	7d0b0600 	stcvc	6, cr0, [fp, #-0]
    27dc:	06000021 	streq	r0, [r0], -r1, lsr #32
    27e0:	001bf80b 	andseq	pc, fp, fp, lsl #16
    27e4:	920b0600 	andls	r0, fp, #0, 12
    27e8:	06000024 	streq	r0, [r0], -r4, lsr #32
    27ec:	00272c0b 	eoreq	r2, r7, fp, lsl #24
    27f0:	b10b0600 	tstlt	fp, r0, lsl #12
    27f4:	06000021 	streq	r0, [r0], -r1, lsr #32
    27f8:	0022100b 	eoreq	r1, r2, fp
    27fc:	fa0b0600 	blx	2c4004 <__bss_end+0x2bb038>
    2800:	07000019 	smladeq	r0, r9, r0, r0
    2804:	00232b0b 	eoreq	r2, r3, fp, lsl #22
    2808:	900b0700 	andls	r0, fp, r0, lsl #14
    280c:	07000023 	streq	r0, [r0, -r3, lsr #32]
    2810:	0027760b 	eoreq	r7, r7, fp, lsl #12
    2814:	cb0b0700 	blgt	2c441c <__bss_end+0x2bb450>
    2818:	0700001b 	smladeq	r0, fp, r0, r0
    281c:	00240b0b 	eoreq	r0, r4, fp, lsl #22
    2820:	5b0b0800 	blpl	2c4828 <__bss_end+0x2bb85c>
    2824:	08000019 	stmdaeq	r0, {r0, r3, r4}
    2828:	00273a0b 	eoreq	r3, r7, fp, lsl #20
    282c:	2c0b0800 	stccs	8, cr0, [fp], {-0}
    2830:	08000024 	stmdaeq	r0, {r2, r5}
    2834:	2ac50f00 	bcs	ff14643c <__bss_end+0xff13d470>
    2838:	92050000 	andls	r0, r5, #0
    283c:	06581f01 	ldrbeq	r1, [r8], -r1, lsl #30
    2840:	d40f0000 	strle	r0, [pc], #-0	; 2848 <shift+0x2848>
    2844:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    2848:	1d0c0195 	stfnes	f0, [ip, #-596]	; 0xfffffdac
    284c:	0f000000 	svceq	0x00000000
    2850:	0000245e 	andeq	r2, r0, lr, asr r4
    2854:	0c019805 	stceq	8, cr9, [r1], {5}
    2858:	0000001d 	andeq	r0, r0, sp, lsl r0
    285c:	00201b0f 	eoreq	r1, r0, pc, lsl #22
    2860:	019b0500 	orrseq	r0, fp, r0, lsl #10
    2864:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2868:	24680f00 	strbtcs	r0, [r8], #-3840	; 0xfffff100
    286c:	9e050000 	cdpls	0, 0, cr0, cr5, cr0, {0}
    2870:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2874:	5e0f0000 	cdppl	0, 0, cr0, cr15, cr0, {0}
    2878:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    287c:	1d0c01a1 	stfnes	f0, [ip, #-644]	; 0xfffffd7c
    2880:	0f000000 	svceq	0x00000000
    2884:	000024b2 			; <UNDEFINED> instruction: 0x000024b2
    2888:	0c01a405 	cfstrseq	mvf10, [r1], {5}
    288c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2890:	00236e0f 	eoreq	r6, r3, pc, lsl #28
    2894:	01a70500 			; <UNDEFINED> instruction: 0x01a70500
    2898:	00001d0c 	andeq	r1, r0, ip, lsl #26
    289c:	23790f00 	cmncs	r9, #0, 30
    28a0:	aa050000 	bge	1428a8 <__bss_end+0x1398dc>
    28a4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    28a8:	720f0000 	andvc	r0, pc, #0
    28ac:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    28b0:	1d0c01ad 	stfnes	f0, [ip, #-692]	; 0xfffffd4c
    28b4:	0f000000 	svceq	0x00000000
    28b8:	00002150 	andeq	r2, r0, r0, asr r1
    28bc:	0c01b005 	stceq	0, cr11, [r1], {5}
    28c0:	0000001d 	andeq	r0, r0, sp, lsl r0
    28c4:	002b070f 	eoreq	r0, fp, pc, lsl #14
    28c8:	01b30500 			; <UNDEFINED> instruction: 0x01b30500
    28cc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    28d0:	247c0f00 	ldrbtcs	r0, [ip], #-3840	; 0xfffff100
    28d4:	b6050000 	strlt	r0, [r5], -r0
    28d8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    28dc:	e40f0000 	str	r0, [pc], #-0	; 28e4 <shift+0x28e4>
    28e0:	0500002b 	streq	r0, [r0, #-43]	; 0xffffffd5
    28e4:	1d0c01b9 	stfnes	f0, [ip, #-740]	; 0xfffffd1c
    28e8:	0f000000 	svceq	0x00000000
    28ec:	00002a92 	muleq	r0, r2, sl
    28f0:	0c01bc05 	stceq	12, cr11, [r1], {5}
    28f4:	0000001d 	andeq	r0, r0, sp, lsl r0
    28f8:	002ab70f 	eoreq	fp, sl, pc, lsl #14
    28fc:	01c00500 	biceq	r0, r0, r0, lsl #10
    2900:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2904:	2bd70f00 	blcs	ff5c650c <__bss_end+0xff5bd540>
    2908:	c3050000 	movwgt	r0, #20480	; 0x5000
    290c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2910:	150f0000 	strne	r0, [pc, #-0]	; 2918 <shift+0x2918>
    2914:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    2918:	1d0c01c6 	stfnes	f0, [ip, #-792]	; 0xfffffce8
    291c:	0f000000 	svceq	0x00000000
    2920:	000018ec 	andeq	r1, r0, ip, ror #17
    2924:	0c01c905 			; <UNDEFINED> instruction: 0x0c01c905
    2928:	0000001d 	andeq	r0, r0, sp, lsl r0
    292c:	001dc00f 	andseq	ip, sp, pc
    2930:	01cc0500 	biceq	r0, ip, r0, lsl #10
    2934:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2938:	1af00f00 	bne	ffc06540 <__bss_end+0xffbfd574>
    293c:	cf050000 	svcgt	0x00050000
    2940:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2944:	bc0f0000 	stclt	0, cr0, [pc], {-0}
    2948:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    294c:	1d0c01d2 	stfnes	f0, [ip, #-840]	; 0xfffffcb8
    2950:	0f000000 	svceq	0x00000000
    2954:	00002043 	andeq	r2, r0, r3, asr #32
    2958:	0c01d505 	cfstr32eq	mvfx13, [r1], {5}
    295c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2960:	0022db0f 	eoreq	sp, r2, pc, lsl #22
    2964:	01d80500 	bicseq	r0, r8, r0, lsl #10
    2968:	00001d0c 	andeq	r1, r0, ip, lsl #26
    296c:	28c20f00 	stmiacs	r2, {r8, r9, sl, fp}^
    2970:	df050000 	svcle	0x00050000
    2974:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2978:	760f0000 	strvc	r0, [pc], -r0
    297c:	0500002b 	streq	r0, [r0, #-43]	; 0xffffffd5
    2980:	1d0c01e2 	stfnes	f0, [ip, #-904]	; 0xfffffc78
    2984:	0f000000 	svceq	0x00000000
    2988:	00002b86 	andeq	r2, r0, r6, lsl #23
    298c:	0c01e505 	cfstr32eq	mvfx14, [r1], {5}
    2990:	0000001d 	andeq	r0, r0, sp, lsl r0
    2994:	001c0f0f 	andseq	r0, ip, pc, lsl #30
    2998:	01e80500 	mvneq	r0, r0, lsl #10
    299c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    29a0:	29090f00 	stmdbcs	r9, {r8, r9, sl, fp}
    29a4:	eb050000 	bl	1429ac <__bss_end+0x1399e0>
    29a8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    29ac:	f30f0000 	vhadd.u8	d0, d15, d0
    29b0:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    29b4:	1d0c01ee 	stfnes	f0, [ip, #-952]	; 0xfffffc48
    29b8:	0f000000 	svceq	0x00000000
    29bc:	00001e39 	andeq	r1, r0, r9, lsr lr
    29c0:	0c01f205 	sfmeq	f7, 1, [r1], {5}
    29c4:	0000001d 	andeq	r0, r0, sp, lsl r0
    29c8:	0026ae0f 	eoreq	sl, r6, pc, lsl #28
    29cc:	01fa0500 	mvnseq	r0, r0, lsl #10
    29d0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    29d4:	1cf20f00 	ldclne	15, cr0, [r2]
    29d8:	fd050000 	stc2	0, cr0, [r5, #-0]
    29dc:	001d0c01 	andseq	r0, sp, r1, lsl #24
    29e0:	1d0c0000 	stcne	0, cr0, [ip, #-0]
    29e4:	c6000000 	strgt	r0, [r0], -r0
    29e8:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
    29ec:	1f230f00 	svcne	0x00230f00
    29f0:	eb050000 	bl	1429f8 <__bss_end+0x139a2c>
    29f4:	08bb0c03 	ldmeq	fp!, {r0, r1, sl, fp}
    29f8:	be0c0000 	cdplt	0, 0, cr0, cr12, cr0, {0}
    29fc:	e3000005 	movw	r0, #5
    2a00:	15000008 	strne	r0, [r0, #-8]
    2a04:	00000024 	andeq	r0, r0, r4, lsr #32
    2a08:	f20f000d 	vhadd.s8	d0, d15, d13
    2a0c:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    2a10:	d3140574 	tstle	r4, #116, 10	; 0x1d000000
    2a14:	16000008 	strne	r0, [r0], -r8
    2a18:	00002006 	andeq	r2, r0, r6
    2a1c:	00930107 	addseq	r0, r3, r7, lsl #2
    2a20:	7b050000 	blvc	142a28 <__bss_end+0x139a5c>
    2a24:	092e0605 	stmdbeq	lr!, {r0, r2, r9, sl}
    2a28:	820b0000 	andhi	r0, fp, #0
    2a2c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2a30:	00223b0b 	eoreq	r3, r2, fp, lsl #22
    2a34:	910b0100 	mrsls	r0, (UNDEF: 27)
    2a38:	02000019 	andeq	r0, r0, #25
    2a3c:	002b380b 	eoreq	r3, fp, fp, lsl #16
    2a40:	7e0b0300 	cdpvc	3, 0, cr0, cr11, cr0, {0}
    2a44:	04000025 	streq	r0, [r0], #-37	; 0xffffffdb
    2a48:	0025710b 	eoreq	r7, r5, fp, lsl #2
    2a4c:	840b0500 	strhi	r0, [fp], #-1280	; 0xfffffb00
    2a50:	0600001a 			; <UNDEFINED> instruction: 0x0600001a
    2a54:	2b280f00 	blcs	a0665c <__bss_end+0x9fd690>
    2a58:	88050000 	stmdahi	r5, {}	; <UNPREDICTABLE>
    2a5c:	08f01505 	ldmeq	r0!, {r0, r2, r8, sl, ip}^
    2a60:	040f0000 	streq	r0, [pc], #-0	; 2a68 <shift+0x2a68>
    2a64:	0500002a 	streq	r0, [r0, #-42]	; 0xffffffd6
    2a68:	24110789 	ldrcs	r0, [r1], #-1929	; 0xfffff877
    2a6c:	0f000000 	svceq	0x00000000
    2a70:	000024df 	ldrdeq	r2, [r0], -pc	; <UNPREDICTABLE>
    2a74:	0c079e05 	stceq	14, cr9, [r7], {5}
    2a78:	0000001d 	andeq	r0, r0, sp, lsl r0
    2a7c:	0028b104 	eoreq	fp, r8, r4, lsl #2
    2a80:	167b0600 	ldrbtne	r0, [fp], -r0, lsl #12
    2a84:	00000093 	muleq	r0, r3, r0
    2a88:	0009550e 	andeq	r5, r9, lr, lsl #10
    2a8c:	05020300 	streq	r0, [r2, #-768]	; 0xfffffd00
    2a90:	00000de3 	andeq	r0, r0, r3, ror #27
    2a94:	db070803 	blle	1c4aa8 <__bss_end+0x1bbadc>
    2a98:	0300001c 	movweq	r0, #28
    2a9c:	1b300404 	blne	c03ab4 <__bss_end+0xbfaae8>
    2aa0:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2aa4:	001b2803 	andseq	r2, fp, r3, lsl #16
    2aa8:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    2aac:	0000248b 	andeq	r2, r0, fp, lsl #9
    2ab0:	c6031003 	strgt	r1, [r3], -r3
    2ab4:	0c000025 	stceq	0, cr0, [r0], {37}	; 0x25
    2ab8:	00000961 	andeq	r0, r0, r1, ror #18
    2abc:	000009a0 	andeq	r0, r0, r0, lsr #19
    2ac0:	00002415 	andeq	r2, r0, r5, lsl r4
    2ac4:	0e00ff00 	cdpeq	15, 0, cr15, cr0, cr0, {0}
    2ac8:	00000990 	muleq	r0, r0, r9
    2acc:	00239d0f 	eoreq	r9, r3, pc, lsl #26
    2ad0:	01fc0600 	mvnseq	r0, r0, lsl #12
    2ad4:	0009a016 	andeq	sl, r9, r6, lsl r0
    2ad8:	1adf0f00 	bne	ff7c66e0 <__bss_end+0xff7bd714>
    2adc:	02060000 	andeq	r0, r6, #0
    2ae0:	09a01602 	stmibeq	r0!, {r1, r9, sl, ip}
    2ae4:	d4040000 	strle	r0, [r4], #-0
    2ae8:	07000028 	streq	r0, [r0, -r8, lsr #32]
    2aec:	05d1102a 	ldrbeq	r1, [r1, #42]	; 0x2a
    2af0:	bf0c0000 	svclt	0x000c0000
    2af4:	d6000009 	strle	r0, [r0], -r9
    2af8:	0d000009 	stceq	0, cr0, [r0, #-36]	; 0xffffffdc
    2afc:	037a0900 	cmneq	sl, #0, 18
    2b00:	2f070000 	svccs	0x00070000
    2b04:	0009cb11 	andeq	ip, r9, r1, lsl fp
    2b08:	023c0900 	eorseq	r0, ip, #0, 18
    2b0c:	30070000 	andcc	r0, r7, r0
    2b10:	0009cb11 	andeq	ip, r9, r1, lsl fp
    2b14:	09d61700 	ldmibeq	r6, {r8, r9, sl, ip}^
    2b18:	36080000 	strcc	r0, [r8], -r0
    2b1c:	03050a09 	movweq	r0, #23049	; 0x5a09
    2b20:	00008fb9 			; <UNDEFINED> instruction: 0x00008fb9
    2b24:	0009e217 	andeq	lr, r9, r7, lsl r2
    2b28:	09370800 	ldmdbeq	r7!, {fp}
    2b2c:	b903050a 	stmdblt	r3, {r1, r3, r8, sl}
    2b30:	0000008f 	andeq	r0, r0, pc, lsl #1

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x377c48>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb9d50>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9d70>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9d88>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <__bss_end+0xc4>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7a8c8>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39dac>
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
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x377cf0>
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
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf79d4c>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c5964>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7a94c>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe39e30>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <shift+0x16c>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9e44>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__bss_end+0x194>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7a984>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe39e68>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeb9e78>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x377e00>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c59f0>
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
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c5a04>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x377e34>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf79e44>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 1e8:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 1ec:	0b0b0024 	bleq	2c0284 <__bss_end+0x2b72b8>
 1f0:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 1f4:	16050000 	strne	r0, [r5], -r0
 1f8:	3a0e0300 	bcc	380e00 <__bss_end+0x377e34>
 1fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 200:	0013490b 	andseq	r4, r3, fp, lsl #18
 204:	00350600 	eorseq	r0, r5, r0, lsl #12
 208:	00001349 	andeq	r1, r0, r9, asr #6
 20c:	03011307 	movweq	r1, #4871	; 0x1307
 210:	3a0b0b0e 	bcc	2c2e50 <__bss_end+0x2b9e84>
 214:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 218:	0013010b 	andseq	r0, r3, fp, lsl #2
 21c:	000d0800 	andeq	r0, sp, r0, lsl #16
 220:	0b3a0803 	bleq	e82234 <__bss_end+0xe79268>
 224:	0b390b3b 	bleq	e42f18 <__bss_end+0xe39f4c>
 228:	0b381349 	bleq	e04f54 <__bss_end+0xdfbf88>
 22c:	04090000 	streq	r0, [r9], #-0
 230:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 234:	0b0b3e19 	bleq	2cfaa0 <__bss_end+0x2c6ad4>
 238:	3a13490b 	bcc	4d266c <__bss_end+0x4c96a0>
 23c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 240:	0013010b 	andseq	r0, r3, fp, lsl #2
 244:	00280a00 	eoreq	r0, r8, r0, lsl #20
 248:	0b1c0e03 	bleq	703a5c <__bss_end+0x6faa90>
 24c:	340b0000 	strcc	r0, [fp], #-0
 250:	3a0e0300 	bcc	380e58 <__bss_end+0x377e8c>
 254:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 258:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 25c:	00180219 	andseq	r0, r8, r9, lsl r2
 260:	00020c00 	andeq	r0, r2, r0, lsl #24
 264:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 268:	020d0000 	andeq	r0, sp, #0
 26c:	0b0e0301 	bleq	380e78 <__bss_end+0x377eac>
 270:	3b0b3a0b 	blcc	2ceaa4 <__bss_end+0x2c5ad8>
 274:	010b390b 	tsteq	fp, fp, lsl #18
 278:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 27c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 280:	0b3b0b3a 	bleq	ec2f70 <__bss_end+0xeb9fa4>
 284:	13490b39 	movtne	r0, #39737	; 0x9b39
 288:	00000b38 	andeq	r0, r0, r8, lsr fp
 28c:	3f012e0f 	svccc	0x00012e0f
 290:	3a0e0319 	bcc	380efc <__bss_end+0x377f30>
 294:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 298:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 29c:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 2a0:	10000013 	andne	r0, r0, r3, lsl r0
 2a4:	13490005 	movtne	r0, #36869	; 0x9005
 2a8:	00001934 	andeq	r1, r0, r4, lsr r9
 2ac:	49000511 	stmdbmi	r0, {r0, r4, r8, sl}
 2b0:	12000013 	andne	r0, r0, #19
 2b4:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 2b8:	0b3b0b3a 	bleq	ec2fa8 <__bss_end+0xeb9fdc>
 2bc:	13490b39 	movtne	r0, #39737	; 0x9b39
 2c0:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 2c4:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 2c8:	03193f01 	tsteq	r9, #1, 30
 2cc:	3b0b3a0e 	blcc	2ceb0c <__bss_end+0x2c5b40>
 2d0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2d4:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 2d8:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 2dc:	00130113 	andseq	r0, r3, r3, lsl r1
 2e0:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 2e4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2e8:	0b3b0b3a 	bleq	ec2fd8 <__bss_end+0xeba00c>
 2ec:	0e6e0b39 	vmoveq.8	d14[5], r0
 2f0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 2f4:	13011364 	movwne	r1, #4964	; 0x1364
 2f8:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 2fc:	03193f01 	tsteq	r9, #1, 30
 300:	3b0b3a0e 	blcc	2ceb40 <__bss_end+0x2c5b74>
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
 338:	0b3b0b3a 	bleq	ec3028 <__bss_end+0xeba05c>
 33c:	13490b39 	movtne	r0, #39737	; 0x9b39
 340:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 344:	281b0000 	ldmdacs	fp, {}	; <UNPREDICTABLE>
 348:	1c080300 	stcne	3, cr0, [r8], {-0}
 34c:	1c00000b 	stcne	0, cr0, [r0], {11}
 350:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 354:	0b3a0e03 	bleq	e83b68 <__bss_end+0xe7ab9c>
 358:	0b390b3b 	bleq	e4304c <__bss_end+0xe3a080>
 35c:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 360:	13011364 	movwne	r1, #4964	; 0x1364
 364:	2e1d0000 	cdpcs	0, 1, cr0, cr13, cr0, {0}
 368:	03193f01 	tsteq	r9, #1, 30
 36c:	3b0b3a0e 	blcc	2cebac <__bss_end+0x2c5be0>
 370:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 374:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 378:	01136419 	tsteq	r3, r9, lsl r4
 37c:	1e000013 	mcrne	0, 0, r0, cr0, cr3, {0}
 380:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 384:	0b3b0b3a 	bleq	ec3074 <__bss_end+0xeba0a8>
 388:	13490b39 	movtne	r0, #39737	; 0x9b39
 38c:	0b320b38 	bleq	c83074 <__bss_end+0xc7a0a8>
 390:	151f0000 	ldrne	r0, [pc, #-0]	; 398 <shift+0x398>
 394:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
 398:	00130113 	andseq	r0, r3, r3, lsl r1
 39c:	001f2000 	andseq	r2, pc, r0
 3a0:	1349131d 	movtne	r1, #37661	; 0x931d
 3a4:	10210000 	eorne	r0, r1, r0
 3a8:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 3ac:	22000013 	andcs	r0, r0, #19
 3b0:	0b0b000f 	bleq	2c03f4 <__bss_end+0x2b7428>
 3b4:	39230000 	stmdbcc	r3!, {}	; <UNPREDICTABLE>
 3b8:	3a080301 	bcc	200fc4 <__bss_end+0x1f7ff8>
 3bc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3c0:	0013010b 	andseq	r0, r3, fp, lsl #2
 3c4:	00342400 	eorseq	r2, r4, r0, lsl #8
 3c8:	0b3a0e03 	bleq	e83bdc <__bss_end+0xe7ac10>
 3cc:	0b390b3b 	bleq	e430c0 <__bss_end+0xe3a0f4>
 3d0:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 3d4:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
 3d8:	34250000 	strtcc	r0, [r5], #-0
 3dc:	3a0e0300 	bcc	380fe4 <__bss_end+0x378018>
 3e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3e4:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 3e8:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 3ec:	26000019 			; <UNDEFINED> instruction: 0x26000019
 3f0:	13470034 	movtne	r0, #28724	; 0x7034
 3f4:	2e270000 	cdpcs	0, 2, cr0, cr7, cr0, {0}
 3f8:	03193f01 	tsteq	r9, #1, 30
 3fc:	3b0b3a0e 	blcc	2cec3c <__bss_end+0x2c5c70>
 400:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 404:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 408:	00136419 	andseq	r6, r3, r9, lsl r4
 40c:	012e2800 			; <UNDEFINED> instruction: 0x012e2800
 410:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 414:	0b3b0b3a 	bleq	ec3104 <__bss_end+0xeba138>
 418:	13490b39 	movtne	r0, #39737	; 0x9b39
 41c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 420:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 424:	00130119 	andseq	r0, r3, r9, lsl r1
 428:	00052900 	andeq	r2, r5, r0, lsl #18
 42c:	0b3a0e03 	bleq	e83c40 <__bss_end+0xe7ac74>
 430:	0b390b3b 	bleq	e43124 <__bss_end+0xe3a158>
 434:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 438:	342a0000 	strtcc	r0, [sl], #-0
 43c:	3a0e0300 	bcc	381044 <__bss_end+0x378078>
 440:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 444:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 448:	2b000018 	blcs	4b0 <shift+0x4b0>
 44c:	0111010b 	tsteq	r1, fp, lsl #2
 450:	00000612 	andeq	r0, r0, r2, lsl r6
 454:	0300342c 	movweq	r3, #1068	; 0x42c
 458:	3b0b3a08 	blcc	2cec80 <__bss_end+0x2c5cb4>
 45c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 460:	00180213 	andseq	r0, r8, r3, lsl r2
 464:	11010000 	mrsne	r0, (UNDEF: 1)
 468:	130e2501 	movwne	r2, #58625	; 0xe501
 46c:	1b0e030b 	blne	3810a0 <__bss_end+0x3780d4>
 470:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 474:	00171006 	andseq	r1, r7, r6
 478:	00240200 	eoreq	r0, r4, r0, lsl #4
 47c:	0b3e0b0b 	bleq	f830b0 <__bss_end+0xf7a0e4>
 480:	00000e03 	andeq	r0, r0, r3, lsl #28
 484:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 488:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 48c:	0b0b0024 	bleq	2c0524 <__bss_end+0x2b7558>
 490:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 494:	16050000 	strne	r0, [r5], -r0
 498:	3a0e0300 	bcc	3810a0 <__bss_end+0x3780d4>
 49c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4a0:	0013490b 	andseq	r4, r3, fp, lsl #18
 4a4:	01130600 	tsteq	r3, r0, lsl #12
 4a8:	0b0b0e03 	bleq	2c3cbc <__bss_end+0x2bacf0>
 4ac:	0b3b0b3a 	bleq	ec319c <__bss_end+0xeba1d0>
 4b0:	13010b39 	movwne	r0, #6969	; 0x1b39
 4b4:	0d070000 	stceq	0, cr0, [r7, #-0]
 4b8:	3a080300 	bcc	2010c0 <__bss_end+0x1f80f4>
 4bc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4c0:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 4c4:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 4c8:	0e030104 	adfeqs	f0, f3, f4
 4cc:	0b3e196d 	bleq	f86a88 <__bss_end+0xf7dabc>
 4d0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 4d4:	0b3b0b3a 	bleq	ec31c4 <__bss_end+0xeba1f8>
 4d8:	13010b39 	movwne	r0, #6969	; 0x1b39
 4dc:	28090000 	stmdacs	r9, {}	; <UNPREDICTABLE>
 4e0:	1c080300 	stcne	3, cr0, [r8], {-0}
 4e4:	0a00000b 	beq	518 <shift+0x518>
 4e8:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 4ec:	00000b1c 	andeq	r0, r0, ip, lsl fp
 4f0:	0300340b 	movweq	r3, #1035	; 0x40b
 4f4:	3b0b3a0e 	blcc	2ced34 <__bss_end+0x2c5d68>
 4f8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4fc:	02196c13 	andseq	r6, r9, #4864	; 0x1300
 500:	0c000018 	stceq	0, cr0, [r0], {24}
 504:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
 508:	0000193c 	andeq	r1, r0, ip, lsr r9
 50c:	0301020d 	movweq	r0, #4621	; 0x120d
 510:	3a0b0b0e 	bcc	2c3150 <__bss_end+0x2ba184>
 514:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 518:	0013010b 	andseq	r0, r3, fp, lsl #2
 51c:	000d0e00 	andeq	r0, sp, r0, lsl #28
 520:	0b3a0e03 	bleq	e83d34 <__bss_end+0xe7ad68>
 524:	0b390b3b 	bleq	e43218 <__bss_end+0xe3a24c>
 528:	0b381349 	bleq	e05254 <__bss_end+0xdfc288>
 52c:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 530:	03193f01 	tsteq	r9, #1, 30
 534:	3b0b3a0e 	blcc	2ced74 <__bss_end+0x2c5da8>
 538:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 53c:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 540:	00136419 	andseq	r6, r3, r9, lsl r4
 544:	00051000 	andeq	r1, r5, r0
 548:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 54c:	05110000 	ldreq	r0, [r1, #-0]
 550:	00134900 	andseq	r4, r3, r0, lsl #18
 554:	000d1200 	andeq	r1, sp, r0, lsl #4
 558:	0b3a0e03 	bleq	e83d6c <__bss_end+0xe7ada0>
 55c:	0b390b3b 	bleq	e43250 <__bss_end+0xe3a284>
 560:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 564:	0000193c 	andeq	r1, r0, ip, lsr r9
 568:	3f012e13 	svccc	0x00012e13
 56c:	3a0e0319 	bcc	3811d8 <__bss_end+0x37820c>
 570:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 574:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 578:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 57c:	01136419 	tsteq	r3, r9, lsl r4
 580:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 584:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 588:	0b3a0e03 	bleq	e83d9c <__bss_end+0xe7add0>
 58c:	0b390b3b 	bleq	e43280 <__bss_end+0xe3a2b4>
 590:	0b320e6e 	bleq	c83f50 <__bss_end+0xc7af84>
 594:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 598:	00001301 	andeq	r1, r0, r1, lsl #6
 59c:	3f012e15 	svccc	0x00012e15
 5a0:	3a0e0319 	bcc	38120c <__bss_end+0x378240>
 5a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5a8:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 5ac:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 5b0:	00136419 	andseq	r6, r3, r9, lsl r4
 5b4:	01011600 	tsteq	r1, r0, lsl #12
 5b8:	13011349 	movwne	r1, #4937	; 0x1349
 5bc:	21170000 	tstcs	r7, r0
 5c0:	2f134900 	svccs	0x00134900
 5c4:	1800000b 	stmdane	r0, {r0, r1, r3}
 5c8:	0b0b000f 	bleq	2c060c <__bss_end+0x2b7640>
 5cc:	00001349 	andeq	r1, r0, r9, asr #6
 5d0:	00002119 	andeq	r2, r0, r9, lsl r1
 5d4:	00341a00 	eorseq	r1, r4, r0, lsl #20
 5d8:	0b3a0e03 	bleq	e83dec <__bss_end+0xe7ae20>
 5dc:	0b390b3b 	bleq	e432d0 <__bss_end+0xe3a304>
 5e0:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 5e4:	0000193c 	andeq	r1, r0, ip, lsr r9
 5e8:	3f012e1b 	svccc	0x00012e1b
 5ec:	3a0e0319 	bcc	381258 <__bss_end+0x37828c>
 5f0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5f4:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
 5f8:	01136419 	tsteq	r3, r9, lsl r4
 5fc:	1c000013 	stcne	0, cr0, [r0], {19}
 600:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 604:	0b3a0e03 	bleq	e83e18 <__bss_end+0xe7ae4c>
 608:	0b390b3b 	bleq	e432fc <__bss_end+0xe3a330>
 60c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 610:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 614:	00001301 	andeq	r1, r0, r1, lsl #6
 618:	03000d1d 	movweq	r0, #3357	; 0xd1d
 61c:	3b0b3a0e 	blcc	2cee5c <__bss_end+0x2c5e90>
 620:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 624:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
 628:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
 62c:	13490115 	movtne	r0, #37141	; 0x9115
 630:	13011364 	movwne	r1, #4964	; 0x1364
 634:	1f1f0000 	svcne	0x001f0000
 638:	49131d00 	ldmdbmi	r3, {r8, sl, fp, ip}
 63c:	20000013 	andcs	r0, r0, r3, lsl r0
 640:	0b0b0010 	bleq	2c0688 <__bss_end+0x2b76bc>
 644:	00001349 	andeq	r1, r0, r9, asr #6
 648:	0b000f21 	bleq	42d4 <shift+0x42d4>
 64c:	2200000b 	andcs	r0, r0, #11
 650:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 654:	0b3b0b3a 	bleq	ec3344 <__bss_end+0xeba378>
 658:	13490b39 	movtne	r0, #39737	; 0x9b39
 65c:	00001802 	andeq	r1, r0, r2, lsl #16
 660:	3f012e23 	svccc	0x00012e23
 664:	3a0e0319 	bcc	3812d0 <__bss_end+0x378304>
 668:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 66c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 670:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 674:	96184006 	ldrls	r4, [r8], -r6
 678:	13011942 	movwne	r1, #6466	; 0x1942
 67c:	05240000 	streq	r0, [r4, #-0]!
 680:	3a0e0300 	bcc	381288 <__bss_end+0x3782bc>
 684:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 688:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 68c:	25000018 	strcs	r0, [r0, #-24]	; 0xffffffe8
 690:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 694:	0b3a0e03 	bleq	e83ea8 <__bss_end+0xe7aedc>
 698:	0b390b3b 	bleq	e4338c <__bss_end+0xe3a3c0>
 69c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 6a0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 6a4:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 6a8:	00130119 	andseq	r0, r3, r9, lsl r1
 6ac:	00342600 	eorseq	r2, r4, r0, lsl #12
 6b0:	0b3a0803 	bleq	e826c4 <__bss_end+0xe796f8>
 6b4:	0b390b3b 	bleq	e433a8 <__bss_end+0xe3a3dc>
 6b8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 6bc:	2e270000 	cdpcs	0, 2, cr0, cr7, cr0, {0}
 6c0:	03193f01 	tsteq	r9, #1, 30
 6c4:	3b0b3a0e 	blcc	2cef04 <__bss_end+0x2c5f38>
 6c8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6cc:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 6d0:	97184006 	ldrls	r4, [r8, -r6]
 6d4:	13011942 	movwne	r1, #6466	; 0x1942
 6d8:	2e280000 	cdpcs	0, 2, cr0, cr8, cr0, {0}
 6dc:	03193f00 	tsteq	r9, #0, 30
 6e0:	3b0b3a0e 	blcc	2cef20 <__bss_end+0x2c5f54>
 6e4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6e8:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 6ec:	97184006 	ldrls	r4, [r8, -r6]
 6f0:	00001942 	andeq	r1, r0, r2, asr #18
 6f4:	3f012e29 	svccc	0x00012e29
 6f8:	3a0e0319 	bcc	381364 <__bss_end+0x378398>
 6fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 700:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 704:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 708:	97184006 	ldrls	r4, [r8, -r6]
 70c:	00001942 	andeq	r1, r0, r2, asr #18
 710:	01110100 	tsteq	r1, r0, lsl #2
 714:	0b130e25 	bleq	4c3fb0 <__bss_end+0x4bafe4>
 718:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 71c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 720:	00001710 	andeq	r1, r0, r0, lsl r7
 724:	01013902 	tsteq	r1, r2, lsl #18
 728:	03000013 	movweq	r0, #19
 72c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 730:	0b3b0b3a 	bleq	ec3420 <__bss_end+0xeba454>
 734:	13490b39 	movtne	r0, #39737	; 0x9b39
 738:	0a1c193c 	beq	706c30 <__bss_end+0x6fdc64>
 73c:	3a040000 	bcc	100744 <__bss_end+0xf7778>
 740:	3b0b3a00 	blcc	2cef48 <__bss_end+0x2c5f7c>
 744:	180b390b 	stmdane	fp, {r0, r1, r3, r8, fp, ip, sp}
 748:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 74c:	13490101 	movtne	r0, #37121	; 0x9101
 750:	00001301 	andeq	r1, r0, r1, lsl #6
 754:	49002106 	stmdbmi	r0, {r1, r2, r8, sp}
 758:	000b2f13 	andeq	r2, fp, r3, lsl pc
 75c:	00260700 	eoreq	r0, r6, r0, lsl #14
 760:	00001349 	andeq	r1, r0, r9, asr #6
 764:	0b002408 	bleq	978c <__bss_end+0x7c0>
 768:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 76c:	0900000e 	stmdbeq	r0, {r1, r2, r3}
 770:	13470034 	movtne	r0, #28724	; 0x7034
 774:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
 778:	03193f01 	tsteq	r9, #1, 30
 77c:	3b0b3a0e 	blcc	2cefbc <__bss_end+0x2c5ff0>
 780:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 784:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 788:	97184006 	ldrls	r4, [r8, -r6]
 78c:	13011942 	movwne	r1, #6466	; 0x1942
 790:	050b0000 	streq	r0, [fp, #-0]
 794:	3a080300 	bcc	20139c <__bss_end+0x1f83d0>
 798:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 79c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 7a0:	0c000018 	stceq	0, cr0, [r0], {24}
 7a4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 7a8:	0b3b0b3a 	bleq	ec3498 <__bss_end+0xeba4cc>
 7ac:	13490b39 	movtne	r0, #39737	; 0x9b39
 7b0:	00001802 	andeq	r1, r0, r2, lsl #16
 7b4:	11010b0d 	tstne	r1, sp, lsl #22
 7b8:	00061201 	andeq	r1, r6, r1, lsl #4
 7bc:	00340e00 	eorseq	r0, r4, r0, lsl #28
 7c0:	0b3a0803 	bleq	e827d4 <__bss_end+0xe79808>
 7c4:	0b390b3b 	bleq	e434b8 <__bss_end+0xe3a4ec>
 7c8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 7cc:	0f0f0000 	svceq	0x000f0000
 7d0:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 7d4:	10000013 	andne	r0, r0, r3, lsl r0
 7d8:	00000026 	andeq	r0, r0, r6, lsr #32
 7dc:	0b000f11 	bleq	4428 <shift+0x4428>
 7e0:	1200000b 	andne	r0, r0, #11
 7e4:	0b0b0024 	bleq	2c087c <__bss_end+0x2b78b0>
 7e8:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 7ec:	05130000 	ldreq	r0, [r3, #-0]
 7f0:	3a0e0300 	bcc	3813f8 <__bss_end+0x37842c>
 7f4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7f8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 7fc:	14000018 	strne	r0, [r0], #-24	; 0xffffffe8
 800:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 804:	0b3a0e03 	bleq	e84018 <__bss_end+0xe7b04c>
 808:	0b390b3b 	bleq	e434fc <__bss_end+0xe3a530>
 80c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 810:	06120111 			; <UNDEFINED> instruction: 0x06120111
 814:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 818:	00130119 	andseq	r0, r3, r9, lsl r1
 81c:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
 820:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 824:	0b3b0b3a 	bleq	ec3514 <__bss_end+0xeba548>
 828:	0e6e0b39 	vmoveq.8	d14[5], r0
 82c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 830:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 834:	00000019 	andeq	r0, r0, r9, lsl r0
 838:	10001101 	andne	r1, r0, r1, lsl #2
 83c:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 840:	1b0e0301 	blne	38144c <__bss_end+0x378480>
 844:	130e250e 	movwne	r2, #58638	; 0xe50e
 848:	00000005 	andeq	r0, r0, r5
 84c:	10001101 	andne	r1, r0, r1, lsl #2
 850:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 854:	1b0e0301 	blne	381460 <__bss_end+0x378494>
 858:	130e250e 	movwne	r2, #58638	; 0xe50e
 85c:	00000005 	andeq	r0, r0, r5
 860:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 864:	030b130e 	movweq	r1, #45838	; 0xb30e
 868:	100e1b0e 	andne	r1, lr, lr, lsl #22
 86c:	02000017 	andeq	r0, r0, #23
 870:	0b0b0024 	bleq	2c0908 <__bss_end+0x2b793c>
 874:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 878:	24030000 	strcs	r0, [r3], #-0
 87c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 880:	000e030b 	andeq	r0, lr, fp, lsl #6
 884:	00160400 	andseq	r0, r6, r0, lsl #8
 888:	0b3a0e03 	bleq	e8409c <__bss_end+0xe7b0d0>
 88c:	0b390b3b 	bleq	e43580 <__bss_end+0xe3a5b4>
 890:	00001349 	andeq	r1, r0, r9, asr #6
 894:	0b000f05 	bleq	44b0 <shift+0x44b0>
 898:	0013490b 	andseq	r4, r3, fp, lsl #18
 89c:	01150600 	tsteq	r5, r0, lsl #12
 8a0:	13491927 	movtne	r1, #39207	; 0x9927
 8a4:	00001301 	andeq	r1, r0, r1, lsl #6
 8a8:	49000507 	stmdbmi	r0, {r0, r1, r2, r8, sl}
 8ac:	08000013 	stmdaeq	r0, {r0, r1, r4}
 8b0:	00000026 	andeq	r0, r0, r6, lsr #32
 8b4:	03003409 	movweq	r3, #1033	; 0x409
 8b8:	3b0b3a0e 	blcc	2cf0f8 <__bss_end+0x2c612c>
 8bc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 8c0:	3c193f13 	ldccc	15, cr3, [r9], {19}
 8c4:	0a000019 	beq	930 <shift+0x930>
 8c8:	0e030104 	adfeqs	f0, f3, f4
 8cc:	0b0b0b3e 	bleq	2c35cc <__bss_end+0x2ba600>
 8d0:	0b3a1349 	bleq	e855fc <__bss_end+0xe7c630>
 8d4:	0b390b3b 	bleq	e435c8 <__bss_end+0xe3a5fc>
 8d8:	00001301 	andeq	r1, r0, r1, lsl #6
 8dc:	0300280b 	movweq	r2, #2059	; 0x80b
 8e0:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 8e4:	01010c00 	tsteq	r1, r0, lsl #24
 8e8:	13011349 	movwne	r1, #4937	; 0x1349
 8ec:	210d0000 	mrscs	r0, (UNDEF: 13)
 8f0:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
 8f4:	13490026 	movtne	r0, #36902	; 0x9026
 8f8:	340f0000 	strcc	r0, [pc], #-0	; 900 <shift+0x900>
 8fc:	3a0e0300 	bcc	381504 <__bss_end+0x378538>
 900:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 904:	3f13490b 	svccc	0x0013490b
 908:	00193c19 	andseq	r3, r9, r9, lsl ip
 90c:	00131000 	andseq	r1, r3, r0
 910:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 914:	15110000 	ldrne	r0, [r1, #-0]
 918:	00192700 	andseq	r2, r9, r0, lsl #14
 91c:	00171200 	andseq	r1, r7, r0, lsl #4
 920:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 924:	13130000 	tstne	r3, #0
 928:	0b0e0301 	bleq	381534 <__bss_end+0x378568>
 92c:	3b0b3a0b 	blcc	2cf160 <__bss_end+0x2c6194>
 930:	010b3905 	tsteq	fp, r5, lsl #18
 934:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 938:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 93c:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 940:	13490b39 	movtne	r0, #39737	; 0x9b39
 944:	00000b38 	andeq	r0, r0, r8, lsr fp
 948:	49002115 	stmdbmi	r0, {r0, r2, r4, r8, sp}
 94c:	000b2f13 	andeq	r2, fp, r3, lsl pc
 950:	01041600 	tsteq	r4, r0, lsl #12
 954:	0b3e0e03 	bleq	f84168 <__bss_end+0xf7b19c>
 958:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 95c:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 960:	13010b39 	movwne	r0, #6969	; 0x1b39
 964:	34170000 	ldrcc	r0, [r7], #-0
 968:	3a134700 	bcc	4d2570 <__bss_end+0x4c95a4>
 96c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 970:	0018020b 	andseq	r0, r8, fp, lsl #4
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
  74:	00000194 	muleq	r0, r4, r1
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	10ce0002 	sbcne	r0, lr, r2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	000083c8 	andeq	r8, r0, r8, asr #7
  94:	00000460 	andeq	r0, r0, r0, ror #8
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	1da90002 	stcne	0, cr0, [r9, #8]!
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008828 	andeq	r8, r0, r8, lsr #16
  b4:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	20db0002 	sbcscs	r0, fp, r2
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00008ce0 	andeq	r8, r0, r0, ror #25
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	21010002 	tstcs	r1, r2
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00008eec 	andeq	r8, r0, ip, ror #29
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	21270002 			; <UNDEFINED> instruction: 0x21270002
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff6f80>
       4:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
       8:	6b69746e 	blvs	1a5d1c8 <__bss_end+0x1a541fc>
       c:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
      10:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
      14:	4f54522d 	svcmi	0x0054522d
      18:	616d2d53 	cmnvs	sp, r3, asr sp
      1c:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
      20:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffcf9 <__bss_end+0xffff6d2d>
      24:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
      28:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
      2c:	61707372 	cmnvs	r0, r2, ror r3
      30:	632f6563 			; <UNDEFINED> instruction: 0x632f6563
      34:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
      38:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
      3c:	2f656d6f 	svccs	0x00656d6f
      40:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
      44:	642f6b69 	strtvs	r6, [pc], #-2921	; 4c <shift+0x4c>
      48:	4b2f7665 	blmi	bdd9e4 <__bss_end+0xbd4a18>
      4c:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
      50:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
      54:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
      58:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
      5c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
      60:	752f7365 	strvc	r7, [pc, #-869]!	; fffffd03 <__bss_end+0xffff6d37>
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
     268:	2b2b4320 	blcs	ad0ef0 <__bss_end+0xac7f24>
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
     2fc:	6a363731 	bvs	d8dfc8 <__bss_end+0xd84ffc>
     300:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     304:	616d2d20 	cmnvs	sp, r0, lsr #26
     308:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     30c:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     310:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     314:	7a36766d 	bvc	d9dcd0 <__bss_end+0xd94d04>
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
     480:	6b636f6c 	blvs	18dc238 <__bss_end+0x18d326c>
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
     4dc:	5a5f0074 	bpl	17c06b4 <__bss_end+0x17b76e8>
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
     508:	4b504564 	blmi	1411aa0 <__bss_end+0x1408ad4>
     50c:	61660063 	cmnvs	r6, r3, rrx
     510:	55007473 	strpl	r7, [r0, #-1139]	; 0xfffffb8d
     514:	70616d6e 	rsbvc	r6, r1, lr, ror #26
     518:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     51c:	75435f65 	strbvc	r5, [r3, #-3941]	; 0xfffff09b
     520:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     524:	5a5f0074 	bpl	17c06fc <__bss_end+0x17b7730>
     528:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     52c:	4f495047 	svcmi	0x00495047
     530:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     534:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     538:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     53c:	706e495f 	rsbvc	r4, lr, pc, asr r9
     540:	6a457475 	bvs	115d71c <__bss_end+0x1154750>
     544:	43534200 	cmpmi	r3, #0, 4
     548:	61425f32 	cmpvs	r2, r2, lsr pc
     54c:	6d006573 	cfstr32vs	mvfx6, [r0, #-460]	; 0xfffffe34
     550:	636f7250 	cmnvs	pc, #80, 4
     554:	5f737365 	svcpl	0x00737365
     558:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
     55c:	6165485f 	cmnvs	r5, pc, asr r8
     560:	65530064 	ldrbvs	r0, [r3, #-100]	; 0xffffff9c
     564:	50475f74 	subpl	r5, r7, r4, ror pc
     568:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     56c:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     570:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     574:	4b4e5a5f 	blmi	1396ef8 <__bss_end+0x138df2c>
     578:	50433631 	subpl	r3, r3, r1, lsr r6
     57c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     580:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 3bc <shift+0x3bc>
     584:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     588:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     58c:	5f746547 	svcpl	0x00746547
     590:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     594:	5f746e65 	svcpl	0x00746e65
     598:	636f7250 	cmnvs	pc, #80, 4
     59c:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     5a0:	65470076 	strbvs	r0, [r7, #-118]	; 0xffffff8a
     5a4:	50475f74 	subpl	r5, r7, r4, ror pc
     5a8:	5f534445 	svcpl	0x00534445
     5ac:	61636f4c 	cmnvs	r3, ip, asr #30
     5b0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     5b4:	78656e00 	stmdavc	r5!, {r9, sl, fp, sp, lr}^
     5b8:	65470074 	strbvs	r0, [r7, #-116]	; 0xffffff8c
     5bc:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     5c0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5c4:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     5c8:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     5cc:	756f6d00 	strbvc	r6, [pc, #-3328]!	; fffff8d4 <__bss_end+0xffff6908>
     5d0:	6f50746e 	svcvs	0x0050746e
     5d4:	00746e69 	rsbseq	r6, r4, r9, ror #28
     5d8:	69447369 	stmdbvs	r4, {r0, r3, r5, r6, r8, r9, ip, sp, lr}^
     5dc:	74636572 	strbtvc	r6, [r3], #-1394	; 0xfffffa8e
     5e0:	0079726f 	rsbseq	r7, r9, pc, ror #4
     5e4:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     5e8:	6f72505f 	svcvs	0x0072505f
     5ec:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     5f0:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     5f4:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     5f8:	74634100 	strbtvc	r4, [r3], #-256	; 0xffffff00
     5fc:	5f657669 	svcpl	0x00657669
     600:	636f7250 	cmnvs	pc, #80, 4
     604:	5f737365 	svcpl	0x00737365
     608:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     60c:	506d0074 	rsbpl	r0, sp, r4, ror r0
     610:	525f6e69 	subspl	r6, pc, #1680	; 0x690
     614:	72657365 	rsbvc	r7, r5, #-1811939327	; 0x94000001
     618:	69746176 	ldmdbvs	r4!, {r1, r2, r4, r5, r6, r8, sp, lr}^
     61c:	5f736e6f 	svcpl	0x00736e6f
     620:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     624:	61575400 	cmpvs	r7, r0, lsl #8
     628:	6e697469 	cdpvs	4, 6, cr7, cr9, cr9, {3}
     62c:	69465f67 	stmdbvs	r6, {r0, r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     630:	4300656c 	movwmi	r6, #1388	; 0x56c
     634:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
     638:	72505f65 	subsvc	r5, r0, #404	; 0x194
     63c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     640:	476d0073 			; <UNDEFINED> instruction: 0x476d0073
     644:	004f4950 	subeq	r4, pc, r0, asr r9	; <UNPREDICTABLE>
     648:	65726170 	ldrbvs	r6, [r2, #-368]!	; 0xfffffe90
     64c:	4d00746e 	cfstrsmi	mvf7, [r0, #-440]	; 0xfffffe48
     650:	69467861 	stmdbvs	r6, {r0, r5, r6, fp, ip, sp, lr}^
     654:	616e656c 	cmnvs	lr, ip, ror #10
     658:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     65c:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     660:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     664:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     668:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     66c:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     670:	006f666e 	rsbeq	r6, pc, lr, ror #12
     674:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
     678:	6b636f6c 	blvs	18dc430 <__bss_end+0x18d3464>
     67c:	6100745f 	tstvs	r0, pc, asr r4
     680:	6e656373 	mcrvs	3, 3, r6, cr5, cr3, {3}
     684:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
     688:	61654400 	cmnvs	r5, r0, lsl #8
     68c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     690:	6e555f65 	cdpvs	15, 5, cr5, cr5, cr5, {3}
     694:	6e616863 	cdpvs	8, 6, cr6, cr1, cr3, {3}
     698:	00646567 	rsbeq	r6, r4, r7, ror #10
     69c:	6f725043 	svcvs	0x00725043
     6a0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6a4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     6a8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     6ac:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     6b0:	46433131 			; <UNDEFINED> instruction: 0x46433131
     6b4:	73656c69 	cmnvc	r5, #26880	; 0x6900
     6b8:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     6bc:	4534436d 	ldrmi	r4, [r4, #-877]!	; 0xfffffc93
     6c0:	5a5f0076 	bpl	17c08a0 <__bss_end+0x17b78d4>
     6c4:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     6c8:	636f7250 	cmnvs	pc, #80, 4
     6cc:	5f737365 	svcpl	0x00737365
     6d0:	616e614d 	cmnvs	lr, sp, asr #2
     6d4:	31726567 	cmncc	r2, r7, ror #10
     6d8:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     6dc:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     6e0:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     6e4:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     6e8:	456f666e 	strbmi	r6, [pc, #-1646]!	; 82 <shift+0x82>
     6ec:	474e3032 	smlaldxmi	r3, lr, r2, r0
     6f0:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     6f4:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     6f8:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     6fc:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     700:	76506570 			; <UNDEFINED> instruction: 0x76506570
     704:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     708:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     70c:	5f4f4950 	svcpl	0x004f4950
     710:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     714:	3272656c 	rsbscc	r6, r2, #108, 10	; 0x1b000000
     718:	656c4330 	strbvs	r4, [ip, #-816]!	; 0xfffffcd0
     71c:	445f7261 	ldrbmi	r7, [pc], #-609	; 724 <shift+0x724>
     720:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     724:	5f646574 	svcpl	0x00646574
     728:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     72c:	006a4574 	rsbeq	r4, sl, r4, ror r5
     730:	314e5a5f 	cmpcc	lr, pc, asr sl
     734:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     738:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     73c:	614d5f73 	hvcvs	54771	; 0xd5f3
     740:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     744:	48313272 	ldmdami	r1!, {r1, r4, r5, r6, r9, ip, sp}
     748:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     74c:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     750:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     754:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     758:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     75c:	4e333245 	cdpmi	2, 3, cr3, cr3, cr5, {2}
     760:	5f495753 	svcpl	0x00495753
     764:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     768:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     76c:	535f6d65 	cmppl	pc, #6464	; 0x1940
     770:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     774:	6a6a6563 	bvs	1a99d08 <__bss_end+0x1a90d3c>
     778:	3131526a 	teqcc	r1, sl, ror #4
     77c:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
     780:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     784:	00746c75 	rsbseq	r6, r4, r5, ror ip
     788:	6c6c6146 	stfvse	f6, [ip], #-280	; 0xfffffee8
     78c:	5f676e69 	svcpl	0x00676e69
     790:	65676445 	strbvs	r6, [r7, #-1093]!	; 0xfffffbbb
     794:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     798:	5f64656e 	svcpl	0x0064656e
     79c:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     7a0:	6f4e0073 	svcvs	0x004e0073
     7a4:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     7a8:	006c6c41 	rsbeq	r6, ip, r1, asr #24
     7ac:	314e5a5f 	cmpcc	lr, pc, asr sl
     7b0:	50474333 	subpl	r4, r7, r3, lsr r3
     7b4:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     7b8:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     7bc:	30327265 	eorscc	r7, r2, r5, ror #4
     7c0:	61736944 	cmnvs	r3, r4, asr #18
     7c4:	5f656c62 	svcpl	0x00656c62
     7c8:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     7cc:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     7d0:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     7d4:	30326a45 	eorscc	r6, r2, r5, asr #20
     7d8:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     7dc:	6e495f4f 	cdpvs	15, 4, cr5, cr9, cr15, {2}
     7e0:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     7e4:	5f747075 	svcpl	0x00747075
     7e8:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     7ec:	50435400 	subpl	r5, r3, r0, lsl #8
     7f0:	6f435f55 	svcvs	0x00435f55
     7f4:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     7f8:	65440074 	strbvs	r0, [r4, #-116]	; 0xffffff8c
     7fc:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     800:	7400656e 	strvc	r6, [r0], #-1390	; 0xfffffa92
     804:	30726274 	rsbscc	r6, r2, r4, ror r2
     808:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     80c:	50433631 	subpl	r3, r3, r1, lsr r6
     810:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     814:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 650 <shift+0x650>
     818:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     81c:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     820:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     824:	505f7966 	subspl	r7, pc, r6, ror #18
     828:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     82c:	6a457373 	bvs	115d600 <__bss_end+0x1154634>
     830:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     834:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     838:	43534200 	cmpmi	r3, #0, 4
     83c:	61425f30 	cmpvs	r2, r0, lsr pc
     840:	46006573 			; <UNDEFINED> instruction: 0x46006573
     844:	5f646e69 	svcpl	0x00646e69
     848:	6c696843 	stclvs	8, cr6, [r9], #-268	; 0xfffffef4
     84c:	6f6e0064 	svcvs	0x006e0064
     850:	69666974 	stmdbvs	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     854:	645f6465 	ldrbvs	r6, [pc], #-1125	; 85c <shift+0x85c>
     858:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     85c:	00656e69 	rsbeq	r6, r5, r9, ror #28
     860:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     864:	70757272 	rsbsvc	r7, r5, r2, ror r2
     868:	6f435f74 	svcvs	0x00435f74
     86c:	6f72746e 	svcvs	0x0072746e
     870:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
     874:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     878:	5a5f0065 	bpl	17c0a14 <__bss_end+0x17b7a48>
     87c:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     880:	4f495047 	svcmi	0x00495047
     884:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     888:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     88c:	65724638 	ldrbvs	r4, [r2, #-1592]!	; 0xfffff9c8
     890:	69505f65 	ldmdbvs	r0, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     894:	626a456e 	rsbvs	r4, sl, #461373440	; 0x1b800000
     898:	53420062 	movtpl	r0, #8290	; 0x2062
     89c:	425f3143 	subsmi	r3, pc, #-1073741808	; 0xc0000010
     8a0:	00657361 	rsbeq	r7, r5, r1, ror #6
     8a4:	5f78614d 	svcpl	0x0078614d
     8a8:	636f7250 	cmnvs	pc, #80, 4
     8ac:	5f737365 	svcpl	0x00737365
     8b0:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     8b4:	465f6465 	ldrbmi	r6, [pc], -r5, ror #8
     8b8:	73656c69 	cmnvc	r5, #26880	; 0x6900
     8bc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     8c0:	50433631 	subpl	r3, r3, r1, lsr r6
     8c4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     8c8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 704 <shift+0x704>
     8cc:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     8d0:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     8d4:	616d6e55 	cmnvs	sp, r5, asr lr
     8d8:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     8dc:	435f656c 	cmpmi	pc, #108, 10	; 0x1b000000
     8e0:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     8e4:	6a45746e 	bvs	115daa4 <__bss_end+0x1154ad8>
     8e8:	4e525400 	cdpmi	4, 5, cr5, cr2, cr0, {0}
     8ec:	61425f47 	cmpvs	r2, r7, asr #30
     8f0:	48006573 	stmdami	r0, {r0, r1, r4, r5, r6, r8, sl, sp, lr}
     8f4:	00686769 	rsbeq	r6, r8, r9, ror #14
     8f8:	5f534667 	svcpl	0x00534667
     8fc:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     900:	5f737265 	svcpl	0x00737265
     904:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     908:	5a5f0074 	bpl	17c0ae0 <__bss_end+0x17b7b14>
     90c:	33314b4e 	teqcc	r1, #79872	; 0x13800
     910:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     914:	61485f4f 	cmpvs	r8, pc, asr #30
     918:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     91c:	47363272 			; <UNDEFINED> instruction: 0x47363272
     920:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     924:	52495f50 	subpl	r5, r9, #80, 30	; 0x140
     928:	65445f51 	strbvs	r5, [r4, #-3921]	; 0xfffff0af
     92c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     930:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     934:	6f697461 	svcvs	0x00697461
     938:	326a456e 	rsbcc	r4, sl, #461373440	; 0x1b800000
     93c:	50474e30 	subpl	r4, r7, r0, lsr lr
     940:	495f4f49 	ldmdbmi	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     944:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     948:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     94c:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     950:	536a5265 	cmnpl	sl, #1342177286	; 0x50000006
     954:	52005f31 	andpl	r5, r0, #49, 30	; 0xc4
     958:	6e697369 	cdpvs	3, 6, cr7, cr9, cr9, {3}
     95c:	64455f67 	strbvs	r5, [r5], #-3943	; 0xfffff099
     960:	6d006567 	cfstr32vs	mvfx6, [r0, #-412]	; 0xfffffe64
     964:	746f6f52 	strbtvc	r6, [pc], #-3922	; 96c <shift+0x96c>
     968:	7379535f 	cmnvc	r9, #2080374785	; 0x7c000001
     96c:	58554100 	ldmdapl	r5, {r8, lr}^
     970:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     974:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     978:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     97c:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     980:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     984:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     988:	614d0073 	hvcvs	53251	; 0xd003
     98c:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     990:	545f656c 	ldrbpl	r6, [pc], #-1388	; 998 <shift+0x998>
     994:	75435f6f 	strbvc	r5, [r3, #-3951]	; 0xfffff091
     998:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     99c:	5a5f0074 	bpl	17c0b74 <__bss_end+0x17b7ba8>
     9a0:	33314b4e 	teqcc	r1, #79872	; 0x13800
     9a4:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     9a8:	61485f4f 	cmpvs	r8, pc, asr #30
     9ac:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     9b0:	47393172 			; <UNDEFINED> instruction: 0x47393172
     9b4:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     9b8:	45534650 	ldrbmi	r4, [r3, #-1616]	; 0xfffff9b0
     9bc:	6f4c5f4c 	svcvs	0x004c5f4c
     9c0:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     9c4:	6a456e6f 	bvs	115c388 <__bss_end+0x11533bc>
     9c8:	30536a52 	subscc	r6, r3, r2, asr sl
     9cc:	7773005f 			; <UNDEFINED> instruction: 0x7773005f
     9d0:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     9d4:	69665f32 	stmdbvs	r6!, {r1, r4, r5, r8, r9, sl, fp, ip, lr}^
     9d8:	4e00656c 	cfsh32mi	mvfx6, mvfx0, #60
     9dc:	6c69466f 	stclvs	6, cr4, [r9], #-444	; 0xfffffe44
     9e0:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     9e4:	446d6574 	strbtmi	r6, [sp], #-1396	; 0xfffffa8c
     9e8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     9ec:	61480072 	hvcvs	32770	; 0x8002
     9f0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     9f4:	6f72505f 	svcvs	0x0072505f
     9f8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     9fc:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     a00:	6f687300 	svcvs	0x00687300
     a04:	75207472 	strvc	r7, [r0, #-1138]!	; 0xfffffb8e
     a08:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     a0c:	2064656e 	rsbcs	r6, r4, lr, ror #10
     a10:	00746e69 	rsbseq	r6, r4, r9, ror #28
     a14:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     a18:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     a1c:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     a20:	69615700 	stmdbvs	r1!, {r8, r9, sl, ip, lr}^
     a24:	5a5f0074 	bpl	17c0bfc <__bss_end+0x17b7c30>
     a28:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     a2c:	4f495047 	svcmi	0x00495047
     a30:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     a34:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     a38:	61483031 	cmpvs	r8, r1, lsr r0
     a3c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     a40:	5152495f 	cmppl	r2, pc, asr r9
     a44:	5f007645 	svcpl	0x00007645
     a48:	31314e5a 	teqcc	r1, sl, asr lr
     a4c:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     a50:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     a54:	316d6574 	smccc	54868	; 0xd654
     a58:	696e4930 	stmdbvs	lr!, {r4, r5, r8, fp, lr}^
     a5c:	6c616974 			; <UNDEFINED> instruction: 0x6c616974
     a60:	45657a69 	strbmi	r7, [r5, #-2665]!	; 0xfffff597
     a64:	65470076 	strbvs	r0, [r7, #-118]	; 0xffffff8a
     a68:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     a6c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     a70:	455f6465 	ldrbmi	r6, [pc, #-1125]	; 613 <shift+0x613>
     a74:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     a78:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     a7c:	746e4900 	strbtvc	r4, [lr], #-2304	; 0xfffff700
     a80:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     a84:	62617470 	rsbvs	r7, r1, #112, 8	; 0x70000000
     a88:	535f656c 	cmppl	pc, #108, 10	; 0x1b000000
     a8c:	7065656c 	rsbvc	r6, r5, ip, ror #10
     a90:	6f526d00 	svcvs	0x00526d00
     a94:	445f746f 	ldrbmi	r7, [pc], #-1135	; a9c <shift+0xa9c>
     a98:	64007665 	strvs	r7, [r0], #-1637	; 0xfffff99b
     a9c:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
     aa0:	665f7961 	ldrbvs	r7, [pc], -r1, ror #18
     aa4:	00656c69 	rsbeq	r6, r5, r9, ror #24
     aa8:	6c6f6f62 	stclvs	15, cr6, [pc], #-392	; 928 <shift+0x928>
     aac:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     ab0:	4100315f 	tstmi	r0, pc, asr r1
     ab4:	325f746c 	subscc	r7, pc, #108, 8	; 0x6c000000
     ab8:	614c6d00 	cmpvs	ip, r0, lsl #26
     abc:	505f7473 	subspl	r7, pc, r3, ror r4	; <UNPREDICTABLE>
     ac0:	42004449 	andmi	r4, r0, #1224736768	; 0x49000000
     ac4:	6b636f6c 	blvs	18dc87c <__bss_end+0x18d38b0>
     ac8:	4e006465 	cdpmi	4, 0, cr6, cr0, cr5, {3}
     acc:	5f746547 	svcpl	0x00746547
     ad0:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     ad4:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     ad8:	545f6f66 	ldrbpl	r6, [pc], #-3942	; ae0 <shift+0xae0>
     adc:	00657079 	rsbeq	r7, r5, r9, ror r0
     ae0:	5f746c41 	svcpl	0x00746c41
     ae4:	5a5f0035 	bpl	17c0bc0 <__bss_end+0x17b7bf4>
     ae8:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     aec:	4f495047 	svcmi	0x00495047
     af0:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     af4:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     af8:	65533031 	ldrbvs	r3, [r3, #-49]	; 0xffffffcf
     afc:	754f5f74 	strbvc	r5, [pc, #-3956]	; fffffb90 <__bss_end+0xffff6bc4>
     b00:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
     b04:	00626a45 	rsbeq	r6, r2, r5, asr #20
     b08:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     b0c:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     b10:	61544e00 	cmpvs	r4, r0, lsl #28
     b14:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
     b18:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
     b1c:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     b20:	635f6465 	cmpvs	pc, #1694498816	; 0x65000000
     b24:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     b28:	73007265 	movwvc	r7, #613	; 0x265
     b2c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     b30:	6174735f 	cmnvs	r4, pc, asr r3
     b34:	5f636974 	svcpl	0x00636974
     b38:	6f697270 	svcvs	0x00697270
     b3c:	79746972 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     b40:	696e4900 	stmdbvs	lr!, {r8, fp, lr}^
     b44:	6c616974 			; <UNDEFINED> instruction: 0x6c616974
     b48:	00657a69 	rsbeq	r7, r5, r9, ror #20
     b4c:	5f534667 	svcpl	0x00534667
     b50:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     b54:	00737265 	rsbseq	r7, r3, r5, ror #4
     b58:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     b5c:	646f635f 	strbtvs	r6, [pc], #-863	; b64 <shift+0xb64>
     b60:	6e490065 	cdpvs	0, 4, cr0, cr9, cr5, {3}
     b64:	696c6176 	stmdbvs	ip!, {r1, r2, r4, r5, r6, r8, sp, lr}^
     b68:	69505f64 	ldmdbvs	r0, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     b6c:	6e45006e 	cdpvs	0, 4, cr0, cr5, cr14, {3}
     b70:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     b74:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     b78:	445f746e 	ldrbmi	r7, [pc], #-1134	; b80 <shift+0xb80>
     b7c:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     b80:	47730074 			; <UNDEFINED> instruction: 0x47730074
     b84:	004f4950 	subeq	r4, pc, r0, asr r9	; <UNPREDICTABLE>
     b88:	6863536d 	stmdavs	r3!, {r0, r2, r3, r5, r6, r8, r9, ip, lr}^
     b8c:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     b90:	6e465f65 	cdpvs	15, 4, cr5, cr6, cr5, {3}
     b94:	50470063 	subpl	r0, r7, r3, rrx
     b98:	425f4f49 	subsmi	r4, pc, #292	; 0x124
     b9c:	00657361 	rsbeq	r7, r5, r1, ror #6
     ba0:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
     ba4:	69724453 	ldmdbvs	r2!, {r0, r1, r4, r6, sl, lr}^
     ba8:	4e726576 	mrcmi	5, 3, r6, cr2, cr6, {3}
     bac:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
     bb0:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     bb4:	6f4e0068 	svcvs	0x004e0068
     bb8:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     bbc:	66654400 	strbtvs	r4, [r5], -r0, lsl #8
     bc0:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
     bc4:	6f6c435f 	svcvs	0x006c435f
     bc8:	525f6b63 	subspl	r6, pc, #101376	; 0x18c00
     bcc:	00657461 	rsbeq	r7, r5, r1, ror #8
     bd0:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     bd4:	726f465f 	rsbvc	r4, pc, #99614720	; 0x5f00000
     bd8:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     bdc:	5f00746e 	svcpl	0x0000746e
     be0:	314b4e5a 	cmpcc	fp, sl, asr lr
     be4:	50474333 	subpl	r4, r7, r3, lsr r3
     be8:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     bec:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     bf0:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     bf4:	5f746547 	svcpl	0x00746547
     bf8:	4c435047 	mcrrmi	0, 4, r5, r3, cr7
     bfc:	6f4c5f52 	svcvs	0x004c5f52
     c00:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     c04:	6a456e6f 	bvs	115c5c8 <__bss_end+0x11535fc>
     c08:	30536a52 	subscc	r6, r3, r2, asr sl
     c0c:	6f4c005f 	svcvs	0x004c005f
     c10:	555f6b63 	ldrbpl	r6, [pc, #-2915]	; b5 <shift+0xb5>
     c14:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     c18:	0064656b 	rsbeq	r6, r4, fp, ror #10
     c1c:	5f746547 	svcpl	0x00746547
     c20:	495f5047 	ldmdbmi	pc, {r0, r1, r2, r6, ip, lr}^	; <UNPREDICTABLE>
     c24:	445f5152 	ldrbmi	r5, [pc], #-338	; c2c <shift+0xc2c>
     c28:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     c2c:	6f4c5f74 	svcvs	0x004c5f74
     c30:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     c34:	47006e6f 	strmi	r6, [r0, -pc, ror #28]
     c38:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     c3c:	524c4350 	subpl	r4, ip, #80, 6	; 0x40000001
     c40:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     c44:	6f697461 	svcvs	0x00697461
     c48:	6f4c006e 	svcvs	0x004c006e
     c4c:	4c5f6b63 	mrrcmi	11, 6, r6, pc, cr3	; <UNPREDICTABLE>
     c50:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     c54:	506d0064 	rsbpl	r0, sp, r4, rrx
     c58:	525f6e69 	subspl	r6, pc, #1680	; 0x690
     c5c:	72657365 	rsbvc	r7, r5, #-1811939327	; 0x94000001
     c60:	69746176 	ldmdbvs	r4!, {r1, r2, r4, r5, r6, r8, sp, lr}^
     c64:	5f736e6f 	svcpl	0x00736e6f
     c68:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     c6c:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     c70:	50475f74 	subpl	r5, r7, r4, ror pc
     c74:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     c78:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     c7c:	6f697461 	svcvs	0x00697461
     c80:	6553006e 	ldrbvs	r0, [r3, #-110]	; 0xffffff92
     c84:	754f5f74 	strbvc	r5, [pc, #-3956]	; fffffd18 <__bss_end+0xffff6d4c>
     c88:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
     c8c:	61655200 	cmnvs	r5, r0, lsl #4
     c90:	72575f64 	subsvc	r5, r7, #100, 30	; 0x190
     c94:	00657469 	rsbeq	r7, r5, r9, ror #8
     c98:	626d6f5a 	rsbvs	r6, sp, #360	; 0x168
     c9c:	5f006569 	svcpl	0x00006569
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
     cd8:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     cdc:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     ce0:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     ce4:	5a5f006f 	bpl	17c0ea8 <__bss_end+0x17b7edc>
     ce8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     cec:	636f7250 	cmnvs	pc, #80, 4
     cf0:	5f737365 	svcpl	0x00737365
     cf4:	616e614d 	cmnvs	lr, sp, asr #2
     cf8:	38726567 	ldmdacc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
     cfc:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     d00:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     d04:	5f007645 	svcpl	0x00007645
     d08:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     d0c:	6f725043 	svcvs	0x00725043
     d10:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     d14:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     d18:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     d1c:	614d3931 	cmpvs	sp, r1, lsr r9
     d20:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     d24:	545f656c 	ldrbpl	r6, [pc], #-1388	; d2c <shift+0xd2c>
     d28:	75435f6f 	strbvc	r5, [r3, #-3951]	; 0xfffff091
     d2c:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     d30:	35504574 	ldrbcc	r4, [r0, #-1396]	; 0xfffffa8c
     d34:	6c694649 	stclvs	6, cr4, [r9], #-292	; 0xfffffedc
     d38:	69440065 	stmdbvs	r4, {r0, r2, r5, r6}^
     d3c:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     d40:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     d44:	5f746e65 	svcpl	0x00746e65
     d48:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     d4c:	63007463 	movwvs	r7, #1123	; 0x463
     d50:	646c6968 	strbtvs	r6, [ip], #-2408	; 0xfffff698
     d54:	006e6572 	rsbeq	r6, lr, r2, ror r5
     d58:	5078614d 	rsbspl	r6, r8, sp, asr #2
     d5c:	4c687461 	cfstrdmi	mvd7, [r8], #-388	; 0xfffffe7c
     d60:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     d64:	6e750068 	cdpvs	0, 7, cr0, cr5, cr8, {3}
     d68:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     d6c:	63206465 			; <UNDEFINED> instruction: 0x63206465
     d70:	00726168 	rsbseq	r6, r2, r8, ror #2
     d74:	4b4e5a5f 	blmi	13976f8 <__bss_end+0x138e72c>
     d78:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     d7c:	5f4f4950 	svcpl	0x004f4950
     d80:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     d84:	3272656c 	rsbscc	r6, r2, #108, 10	; 0x1b000000
     d88:	74654732 	strbtvc	r4, [r5], #-1842	; 0xfffff8ce
     d8c:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     d90:	65746365 	ldrbvs	r6, [r4, #-869]!	; 0xfffffc9b
     d94:	76455f64 	strbvc	r5, [r5], -r4, ror #30
     d98:	5f746e65 	svcpl	0x00746e65
     d9c:	456e6950 	strbmi	r6, [lr, #-2384]!	; 0xfffff6b0
     da0:	5a5f0076 	bpl	17c0f80 <__bss_end+0x17b7fb4>
     da4:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     da8:	636f7250 	cmnvs	pc, #80, 4
     dac:	5f737365 	svcpl	0x00737365
     db0:	616e614d 	cmnvs	lr, sp, asr #2
     db4:	31726567 	cmncc	r2, r7, ror #10
     db8:	68635332 	stmdavs	r3!, {r1, r4, r5, r8, r9, ip, lr}^
     dbc:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     dc0:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     dc4:	00764546 	rsbseq	r4, r6, r6, asr #10
     dc8:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     dcc:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     dd0:	006d6574 	rsbeq	r6, sp, r4, ror r5
     dd4:	4f495047 	svcmi	0x00495047
     dd8:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     ddc:	756f435f 	strbvc	r4, [pc, #-863]!	; a85 <shift+0xa85>
     de0:	7300746e 	movwvc	r7, #1134	; 0x46e
     de4:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     de8:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     dec:	53465400 	movtpl	r5, #25600	; 0x6400
     df0:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
     df4:	00726576 	rsbseq	r6, r2, r6, ror r5
     df8:	314e5a5f 	cmpcc	lr, pc, asr sl
     dfc:	50474333 	subpl	r4, r7, r3, lsr r3
     e00:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     e04:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     e08:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
     e0c:	50006a45 	andpl	r6, r0, r5, asr #20
     e10:	70697265 	rsbvc	r7, r9, r5, ror #4
     e14:	61726568 	cmnvs	r2, r8, ror #10
     e18:	61425f6c 	cmpvs	r2, ip, ror #30
     e1c:	6d006573 	cfstr32vs	mvfx6, [r0, #-460]	; 0xfffffe34
     e20:	746f6f52 	strbtvc	r6, [pc], #-3922	; e28 <shift+0xe28>
     e24:	69467300 	stmdbvs	r6, {r8, r9, ip, sp, lr}^
     e28:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     e2c:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     e30:	6f4c6d00 	svcvs	0x004c6d00
     e34:	2f006b63 	svccs	0x00006b63
     e38:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     e3c:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
     e40:	2f6b6974 	svccs	0x006b6974
     e44:	2f766564 	svccs	0x00766564
     e48:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
     e4c:	534f5452 	movtpl	r5, #62546	; 0xf452
     e50:	73616d2d 	cmnvc	r1, #2880	; 0xb40
     e54:	2f726574 	svccs	0x00726574
     e58:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     e5c:	2f736563 	svccs	0x00736563
     e60:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     e64:	63617073 	cmnvs	r1, #115	; 0x73
     e68:	6f632f65 	svcvs	0x00632f65
     e6c:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
     e70:	61745f72 	cmnvs	r4, r2, ror pc
     e74:	6d2f6b73 	fstmdbxvs	pc!, {d6-d62}	;@ Deprecated
     e78:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
     e7c:	00707063 	rsbseq	r7, r0, r3, rrx
     e80:	314e5a5f 	cmpcc	lr, pc, asr sl
     e84:	50474333 	subpl	r4, r7, r3, lsr r3
     e88:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     e8c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     e90:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     e94:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     e98:	726f465f 	rsbvc	r4, pc, #99614720	; 0x5f00000
     e9c:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     ea0:	5045746e 	subpl	r7, r5, lr, ror #8
     ea4:	69464935 	stmdbvs	r6, {r0, r2, r4, r5, r8, fp, lr}^
     ea8:	006a656c 	rsbeq	r6, sl, ip, ror #10
     eac:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     eb0:	745f3233 	ldrbvc	r3, [pc], #-563	; eb8 <shift+0xeb8>
     eb4:	73655200 	cmnvc	r5, #0, 4
     eb8:	65767265 	ldrbvs	r7, [r6, #-613]!	; 0xfffffd9b
     ebc:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     ec0:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     ec4:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     ec8:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     ecc:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     ed0:	54006e6f 	strpl	r6, [r0], #-3695	; 0xfffff191
     ed4:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     ed8:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     edc:	436d0065 	cmnmi	sp, #101	; 0x65
     ee0:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     ee4:	545f746e 	ldrbpl	r7, [pc], #-1134	; eec <shift+0xeec>
     ee8:	5f6b7361 	svcpl	0x006b7361
     eec:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     ef0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     ef4:	46433131 			; <UNDEFINED> instruction: 0x46433131
     ef8:	73656c69 	cmnvc	r5, #26880	; 0x6900
     efc:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     f00:	704f346d 	subvc	r3, pc, sp, ror #8
     f04:	50456e65 	subpl	r6, r5, r5, ror #28
     f08:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
     f0c:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
     f10:	704f5f65 	subvc	r5, pc, r5, ror #30
     f14:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; d88 <shift+0xd88>
     f18:	0065646f 	rsbeq	r6, r5, pc, ror #8
     f1c:	5f746547 	svcpl	0x00746547
     f20:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
     f24:	6f4c5f54 	svcvs	0x004c5f54
     f28:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     f2c:	5f006e6f 	svcpl	0x00006e6f
     f30:	314b4e5a 	cmpcc	fp, sl, asr lr
     f34:	50474333 	subpl	r4, r7, r3, lsr r3
     f38:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     f3c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     f40:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     f44:	5f746547 	svcpl	0x00746547
     f48:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
     f4c:	6f4c5f56 	svcvs	0x004c5f56
     f50:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     f54:	6a456e6f 	bvs	115c918 <__bss_end+0x115394c>
     f58:	30536a52 	subscc	r6, r3, r2, asr sl
     f5c:	576d005f 			; <UNDEFINED> instruction: 0x576d005f
     f60:	69746961 	ldmdbvs	r4!, {r0, r5, r6, r8, fp, sp, lr}^
     f64:	465f676e 	ldrbmi	r6, [pc], -lr, ror #14
     f68:	73656c69 	cmnvc	r5, #26880	; 0x6900
     f6c:	69726400 	ldmdbvs	r2!, {sl, sp, lr}^
     f70:	5f726576 	svcpl	0x00726576
     f74:	00786469 	rsbseq	r6, r8, r9, ror #8
     f78:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     f7c:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
     f80:	6c730079 	ldclvs	0, cr0, [r3], #-484	; 0xfffffe1c
     f84:	5f706565 	svcpl	0x00706565
     f88:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     f8c:	5a5f0072 	bpl	17c115c <__bss_end+0x17b8190>
     f90:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
     f94:	6f725043 	svcvs	0x00725043
     f98:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     f9c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     fa0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     fa4:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     fa8:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     fac:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     fb0:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     fb4:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     fb8:	48006a45 	stmdami	r0, {r0, r2, r6, r9, fp, sp, lr}
     fbc:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     fc0:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     fc4:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     fc8:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     fcc:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     fd0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     fd4:	50433631 	subpl	r3, r3, r1, lsr r6
     fd8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     fdc:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; e18 <shift+0xe18>
     fe0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     fe4:	31317265 	teqcc	r1, r5, ror #4
     fe8:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     fec:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     ff0:	4552525f 	ldrbmi	r5, [r2, #-607]	; 0xfffffda1
     ff4:	61740076 	cmnvs	r4, r6, ror r0
     ff8:	47006b73 	smlsdxmi	r0, r3, fp, r6
     ffc:	495f7465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1000:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
    1004:	746f4e00 	strbtvc	r4, [pc], #-3584	; 100c <shift+0x100c>
    1008:	5f796669 	svcpl	0x00796669
    100c:	636f7250 	cmnvs	pc, #80, 4
    1010:	00737365 	rsbseq	r7, r3, r5, ror #6
    1014:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
    1018:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
    101c:	72507300 	subsvc	r7, r0, #0, 6
    1020:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1024:	72674d73 	rsbvc	r4, r7, #7360	; 0x1cc0
    1028:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    102c:	50433631 	subpl	r3, r3, r1, lsr r6
    1030:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1034:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; e70 <shift+0xe70>
    1038:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    103c:	53397265 	teqpl	r9, #1342177286	; 0x50000006
    1040:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
    1044:	6f545f68 	svcvs	0x00545f68
    1048:	38315045 	ldmdacc	r1!, {r0, r2, r6, ip, lr}
    104c:	6f725043 	svcvs	0x00725043
    1050:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1054:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
    1058:	6f4e5f74 	svcvs	0x004e5f74
    105c:	5f006564 	svcpl	0x00006564
    1060:	314b4e5a 	cmpcc	fp, sl, asr lr
    1064:	50474333 	subpl	r4, r7, r3, lsr r3
    1068:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
    106c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    1070:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
    1074:	5f746547 	svcpl	0x00746547
    1078:	44455047 	strbmi	r5, [r5], #-71	; 0xffffffb9
    107c:	6f4c5f53 	svcvs	0x004c5f53
    1080:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
    1084:	6a456e6f 	bvs	115ca48 <__bss_end+0x1153a7c>
    1088:	30536a52 	subscc	r6, r3, r2, asr sl
    108c:	6353005f 	cmpvs	r3, #95	; 0x5f
    1090:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
    1094:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
    1098:	65470052 	strbvs	r0, [r7, #-82]	; 0xffffffae
    109c:	50475f74 	subpl	r5, r7, r4, ror pc
    10a0:	5f56454c 	svcpl	0x0056454c
    10a4:	61636f4c 	cmnvs	r3, ip, asr #30
    10a8:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    10ac:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    10b0:	50433631 	subpl	r3, r3, r1, lsr r6
    10b4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    10b8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; ef4 <shift+0xef4>
    10bc:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    10c0:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
    10c4:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    10c8:	505f656c 	subspl	r6, pc, ip, ror #10
    10cc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    10d0:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
    10d4:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
    10d8:	57534e30 	smmlarpl	r3, r0, lr, r4
    10dc:	72505f49 	subsvc	r5, r0, #292	; 0x124
    10e0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    10e4:	65535f73 	ldrbvs	r5, [r3, #-3955]	; 0xfffff08d
    10e8:	63697672 	cmnvs	r9, #119537664	; 0x7200000
    10ec:	6a6a6a65 	bvs	1a9ba88 <__bss_end+0x1a92abc>
    10f0:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
    10f4:	5f495753 	svcpl	0x00495753
    10f8:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
    10fc:	6100746c 	tstvs	r0, ip, ror #8
    1100:	00766772 	rsbseq	r6, r6, r2, ror r7
    1104:	314e5a5f 	cmpcc	lr, pc, asr sl
    1108:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    110c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1110:	614d5f73 	hvcvs	54771	; 0xd5f3
    1114:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1118:	43343172 	teqmi	r4, #-2147483620	; 0x8000001c
    111c:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
    1120:	72505f65 	subsvc	r5, r0, #404	; 0x194
    1124:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1128:	68504573 	ldmdavs	r0, {r0, r1, r4, r5, r6, r8, sl, lr}^
    112c:	5300626a 	movwpl	r6, #618	; 0x26a
    1130:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
    1134:	6f545f68 	svcvs	0x00545f68
    1138:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
    113c:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
    1140:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    1144:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    1148:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
    114c:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
    1150:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1154:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
    1158:	4f495047 	svcmi	0x00495047
    115c:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
    1160:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
    1164:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
    1168:	50475f74 	subpl	r5, r7, r4, ror pc
    116c:	5f544553 	svcpl	0x00544553
    1170:	61636f4c 	cmnvs	r3, ip, asr #30
    1174:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1178:	6a526a45 	bvs	149ba94 <__bss_end+0x1492ac8>
    117c:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
    1180:	61656c43 	cmnvs	r5, r3, asr #24
    1184:	65445f72 	strbvs	r5, [r4, #-3954]	; 0xfffff08e
    1188:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    118c:	455f6465 	ldrbmi	r6, [pc, #-1125]	; d2f <shift+0xd2f>
    1190:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
    1194:	766e4900 	strbtvc	r4, [lr], -r0, lsl #18
    1198:	64696c61 	strbtvs	r6, [r9], #-3169	; 0xfffff39f
    119c:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
    11a0:	00656c64 	rsbeq	r6, r5, r4, ror #24
    11a4:	5f534654 	svcpl	0x00534654
    11a8:	65657254 	strbvs	r7, [r5, #-596]!	; 0xfffffdac
    11ac:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 11b4 <shift+0x11b4>
    11b0:	6c420065 	mcrrvs	0, 6, r0, r2, cr5
    11b4:	5f6b636f 	svcpl	0x006b636f
    11b8:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
    11bc:	5f746e65 	svcpl	0x00746e65
    11c0:	636f7250 	cmnvs	pc, #80, 4
    11c4:	00737365 	rsbseq	r7, r3, r5, ror #6
    11c8:	5f6e6970 	svcpl	0x006e6970
    11cc:	00786469 	rsbseq	r6, r8, r9, ror #8
    11d0:	65657246 	strbvs	r7, [r5, #-582]!	; 0xfffffdba
    11d4:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
    11d8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    11dc:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
    11e0:	4f495047 	svcmi	0x00495047
    11e4:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
    11e8:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
    11ec:	65473731 	strbvs	r3, [r7, #-1841]	; 0xfffff8cf
    11f0:	50475f74 	subpl	r5, r7, r4, ror pc
    11f4:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
    11f8:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
    11fc:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
    1200:	6c43006a 	mcrrvs	0, 6, r0, r3, cr10
    1204:	0065736f 	rsbeq	r7, r5, pc, ror #6
    1208:	76697264 	strbtvc	r7, [r9], -r4, ror #4
    120c:	61007265 	tstvs	r0, r5, ror #4
    1210:	00636772 	rsbeq	r6, r3, r2, ror r7
    1214:	6c694649 	stclvs	6, cr4, [r9], #-292	; 0xfffffedc
    1218:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    121c:	5f6d6574 	svcpl	0x006d6574
    1220:	76697244 	strbtvc	r7, [r9], -r4, asr #4
    1224:	73007265 	movwvc	r7, #613	; 0x265
    1228:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
    122c:	665f3168 	ldrbvs	r3, [pc], -r8, ror #2
    1230:	00656c69 	rsbeq	r6, r5, r9, ror #24
    1234:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
    1238:	61485f4f 	cmpvs	r8, pc, asr #30
    123c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    1240:	6e550072 	mrcvs	0, 2, r0, cr5, cr2, {3}
    1244:	63657073 	cmnvs	r5, #115	; 0x73
    1248:	65696669 	strbvs	r6, [r9, #-1641]!	; 0xfffff997
    124c:	72570064 	subsvc	r0, r7, #100	; 0x64
    1250:	5f657469 	svcpl	0x00657469
    1254:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
    1258:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
    125c:	6959006e 	ldmdbvs	r9, {r1, r2, r3, r5, r6}^
    1260:	00646c65 	rsbeq	r6, r4, r5, ror #24
    1264:	314e5a5f 	cmpcc	lr, pc, asr sl
    1268:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    126c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1270:	614d5f73 	hvcvs	54771	; 0xd5f3
    1274:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1278:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
    127c:	526d0076 	rsbpl	r0, sp, #118	; 0x76
    1280:	5f746f6f 	svcpl	0x00746f6f
    1284:	00746e4d 	rsbseq	r6, r4, sp, asr #28
    1288:	5f757063 	svcpl	0x00757063
    128c:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
    1290:	00747865 	rsbseq	r7, r4, r5, ror #16
    1294:	6d726554 	cfldr64vs	mvdx6, [r2, #-336]!	; 0xfffffeb0
    1298:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
    129c:	4f490065 	svcmi	0x00490065
    12a0:	006c7443 	rsbeq	r7, ip, r3, asr #8
    12a4:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    12a8:	495f656c 	ldmdbmi	pc, {r2, r3, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    12ac:	52005152 	andpl	r5, r0, #-2147483628	; 0x80000014
    12b0:	696e6e75 	stmdbvs	lr!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
    12b4:	6300676e 	movwvs	r6, #1902	; 0x76e
    12b8:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
    12bc:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
    12c0:	6c65525f 	sfmvs	f5, 2, [r5], #-380	; 0xfffffe84
    12c4:	76697461 	strbtvc	r7, [r9], -r1, ror #8
    12c8:	4e470065 	cdpmi	0, 4, cr0, cr7, cr5, {3}
    12cc:	2b432055 	blcs	10c9428 <__bss_end+0x10c045c>
    12d0:	2034312b 	eorscs	r3, r4, fp, lsr #2
    12d4:	2e332e38 	mrccs	14, 1, r2, cr3, cr8, {1}
    12d8:	30322031 	eorscc	r2, r2, r1, lsr r0
    12dc:	37303931 			; <UNDEFINED> instruction: 0x37303931
    12e0:	28203330 	stmdacs	r0!, {r4, r5, r8, r9, ip, sp}
    12e4:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    12e8:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    12ec:	63675b20 	cmnvs	r7, #32, 22	; 0x8000
    12f0:	2d382d63 	ldccs	13, cr2, [r8, #-396]!	; 0xfffffe74
    12f4:	6e617262 	cdpvs	2, 6, cr7, cr1, cr2, {3}
    12f8:	72206863 	eorvc	r6, r0, #6488064	; 0x630000
    12fc:	73697665 	cmnvc	r9, #105906176	; 0x6500000
    1300:	206e6f69 	rsbcs	r6, lr, r9, ror #30
    1304:	30333732 	eorscc	r3, r3, r2, lsr r7
    1308:	205d3732 	subscs	r3, sp, r2, lsr r7
    130c:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1310:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1314:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1318:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    131c:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1320:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
    1324:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1328:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
    132c:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
    1330:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    1334:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
    1338:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
    133c:	6f6c666d 	svcvs	0x006c666d
    1340:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    1344:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    1348:	20647261 	rsbcs	r7, r4, r1, ror #4
    134c:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
    1350:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
    1354:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
    1358:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    135c:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    1360:	36373131 			; <UNDEFINED> instruction: 0x36373131
    1364:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
    1368:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
    136c:	206d7261 	rsbcs	r7, sp, r1, ror #4
    1370:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1374:	613d6863 	teqvs	sp, r3, ror #16
    1378:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    137c:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
    1380:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
    1384:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1388:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    138c:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
    1390:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
    1394:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1204 <shift+0x1204>
    1398:	65637865 	strbvs	r7, [r3, #-2149]!	; 0xfffff79b
    139c:	6f697470 	svcvs	0x00697470
    13a0:	2d20736e 	stccs	3, cr7, [r0, #-440]!	; 0xfffffe48
    13a4:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1214 <shift+0x1214>
    13a8:	69747472 	ldmdbvs	r4!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    13ac:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
    13b0:	006c6176 	rsbeq	r6, ip, r6, ror r1
    13b4:	7275636e 	rsbsvc	r6, r5, #-1207959551	; 0xb8000001
    13b8:	70697000 	rsbvc	r7, r9, r0
    13bc:	64720065 	ldrbtvs	r0, [r2], #-101	; 0xffffff9b
    13c0:	006d756e 	rsbeq	r7, sp, lr, ror #10
    13c4:	31315a5f 	teqcc	r1, pc, asr sl
    13c8:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    13cc:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    13d0:	76646c65 	strbtvc	r6, [r4], -r5, ror #24
    13d4:	315a5f00 	cmpcc	sl, r0, lsl #30
    13d8:	74657337 	strbtvc	r7, [r5], #-823	; 0xfffffcc9
    13dc:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    13e0:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
    13e4:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    13e8:	006a656e 	rsbeq	r6, sl, lr, ror #10
    13ec:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
    13f0:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    13f4:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    13f8:	6a6a7966 	bvs	1a9f998 <__bss_end+0x1a969cc>
    13fc:	395a5f00 	ldmdbcc	sl, {r8, r9, sl, fp, ip, lr}^
    1400:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
    1404:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
    1408:	2f006965 	svccs	0x00006965
    140c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1410:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
    1414:	2f6b6974 	svccs	0x006b6974
    1418:	2f766564 	svccs	0x00766564
    141c:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
    1420:	534f5452 	movtpl	r5, #62546	; 0xf452
    1424:	73616d2d 	cmnvc	r1, #2880	; 0xb40
    1428:	2f726574 	svccs	0x00726574
    142c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    1430:	2f736563 	svccs	0x00736563
    1434:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    1438:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    143c:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    1440:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
    1444:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
    1448:	46007070 			; <UNDEFINED> instruction: 0x46007070
    144c:	006c6961 	rsbeq	r6, ip, r1, ror #18
    1450:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
    1454:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
    1458:	325a5f00 	subscc	r5, sl, #0, 30
    145c:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
    1460:	7463615f 	strbtvc	r6, [r3], #-351	; 0xfffffea1
    1464:	5f657669 	svcpl	0x00657669
    1468:	636f7270 	cmnvs	pc, #112, 4
    146c:	5f737365 	svcpl	0x00737365
    1470:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    1474:	73007674 	movwvc	r7, #1652	; 0x674
    1478:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    147c:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
    1480:	7400646c 	strvc	r6, [r0], #-1132	; 0xfffffb94
    1484:	5f6b6369 	svcpl	0x006b6369
    1488:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    148c:	65725f74 	ldrbvs	r5, [r2, #-3956]!	; 0xfffff08c
    1490:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    1494:	50006465 	andpl	r6, r0, r5, ror #8
    1498:	5f657069 	svcpl	0x00657069
    149c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    14a0:	6572505f 	ldrbvs	r5, [r2, #-95]!	; 0xffffffa1
    14a4:	00786966 	rsbseq	r6, r8, r6, ror #18
    14a8:	5f746553 	svcpl	0x00746553
    14ac:	61726150 	cmnvs	r2, r0, asr r1
    14b0:	5f00736d 	svcpl	0x0000736d
    14b4:	6734315a 			; <UNDEFINED> instruction: 0x6734315a
    14b8:	745f7465 	ldrbvc	r7, [pc], #-1125	; 14c0 <shift+0x14c0>
    14bc:	5f6b6369 	svcpl	0x006b6369
    14c0:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    14c4:	73007674 	movwvc	r7, #1652	; 0x674
    14c8:	7065656c 	rsbvc	r6, r5, ip, ror #10
    14cc:	6f682f00 	svcvs	0x00682f00
    14d0:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    14d4:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    14d8:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
    14dc:	494b2f76 	stmdbmi	fp, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
    14e0:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
    14e4:	6d2d534f 	stcvs	3, cr5, [sp, #-316]!	; 0xfffffec4
    14e8:	65747361 	ldrbvs	r7, [r4, #-865]!	; 0xfffffc9f
    14ec:	6f732f72 	svcvs	0x00732f72
    14f0:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    14f4:	75622f73 	strbvc	r2, [r2, #-3955]!	; 0xfffff08d
    14f8:	00646c69 	rsbeq	r6, r4, r9, ror #24
    14fc:	61736944 	cmnvs	r3, r4, asr #18
    1500:	5f656c62 	svcpl	0x00656c62
    1504:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
    1508:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
    150c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1510:	006e6f69 	rsbeq	r6, lr, r9, ror #30
    1514:	7265706f 	rsbvc	r7, r5, #111	; 0x6f
    1518:	6f697461 	svcvs	0x00697461
    151c:	5a5f006e 	bpl	17c16dc <__bss_end+0x17b8710>
    1520:	6f6c6335 	svcvs	0x006c6335
    1524:	006a6573 	rsbeq	r6, sl, r3, ror r5
    1528:	67365a5f 			; <UNDEFINED> instruction: 0x67365a5f
    152c:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
    1530:	66007664 	strvs	r7, [r0], -r4, ror #12
    1534:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    1538:	746f6e00 	strbtvc	r6, [pc], #-3584	; 1540 <shift+0x1540>
    153c:	00796669 	rsbseq	r6, r9, r9, ror #12
    1540:	6b636974 	blvs	18dbb18 <__bss_end+0x18d2b4c>
    1544:	706f0073 	rsbvc	r0, pc, r3, ror r0	; <UNPREDICTABLE>
    1548:	5f006e65 	svcpl	0x00006e65
    154c:	6970345a 	ldmdbvs	r0!, {r1, r3, r4, r6, sl, ip, sp}^
    1550:	4b506570 	blmi	141ab18 <__bss_end+0x1411b4c>
    1554:	4e006a63 	vmlsmi.f32	s12, s0, s7
    1558:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
    155c:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    1560:	6275535f 	rsbsvs	r5, r5, #2080374785	; 0x7c000001
    1564:	76726573 			; <UNDEFINED> instruction: 0x76726573
    1568:	00656369 	rsbeq	r6, r5, r9, ror #6
    156c:	5f746567 	svcpl	0x00746567
    1570:	6b636974 	blvs	18dbb48 <__bss_end+0x18d2b7c>
    1574:	756f635f 	strbvc	r6, [pc, #-863]!	; 121d <shift+0x121d>
    1578:	7000746e 	andvc	r7, r0, lr, ror #8
    157c:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
    1580:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1584:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
    1588:	4b506a65 	blmi	141bf24 <__bss_end+0x1412f58>
    158c:	67006a63 	strvs	r6, [r0, -r3, ror #20]
    1590:	745f7465 	ldrbvc	r7, [pc], #-1125	; 1598 <shift+0x1598>
    1594:	5f6b7361 	svcpl	0x006b7361
    1598:	6b636974 	blvs	18dbb70 <__bss_end+0x18d2ba4>
    159c:	6f745f73 	svcvs	0x00745f73
    15a0:	6165645f 	cmnvs	r5, pc, asr r4
    15a4:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    15a8:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
    15ac:	69735f66 	ldmdbvs	r3!, {r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    15b0:	7700657a 	smlsdxvc	r0, sl, r5, r6
    15b4:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    15b8:	74657300 	strbtvc	r7, [r5], #-768	; 0xfffffd00
    15bc:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    15c0:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
    15c4:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    15c8:	4700656e 	strmi	r6, [r0, -lr, ror #10]
    15cc:	505f7465 	subspl	r7, pc, r5, ror #8
    15d0:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
    15d4:	5a5f0073 	bpl	17c17a8 <__bss_end+0x17b87dc>
    15d8:	656c7335 	strbvs	r7, [ip, #-821]!	; 0xfffffccb
    15dc:	6a6a7065 	bvs	1a9d778 <__bss_end+0x1a947ac>
    15e0:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    15e4:	6d65525f 	sfmvs	f5, 2, [r5, #-380]!	; 0xfffffe84
    15e8:	696e6961 	stmdbvs	lr!, {r0, r5, r6, r8, fp, sp, lr}^
    15ec:	4500676e 	strmi	r6, [r0, #-1902]	; 0xfffff892
    15f0:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
    15f4:	76455f65 	strbvc	r5, [r5], -r5, ror #30
    15f8:	5f746e65 	svcpl	0x00746e65
    15fc:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
    1600:	6f697463 	svcvs	0x00697463
    1604:	5a5f006e 	bpl	17c17c4 <__bss_end+0x17b87f8>
    1608:	65673632 	strbvs	r3, [r7, #-1586]!	; 0xfffff9ce
    160c:	61745f74 	cmnvs	r4, r4, ror pc
    1610:	745f6b73 	ldrbvc	r6, [pc], #-2931	; 1618 <shift+0x1618>
    1614:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
    1618:	5f6f745f 	svcpl	0x006f745f
    161c:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
    1620:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    1624:	534e0076 	movtpl	r0, #57462	; 0xe076
    1628:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
    162c:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
    1630:	6f435f74 	svcvs	0x00435f74
    1634:	77006564 	strvc	r6, [r0, -r4, ror #10]
    1638:	6d756e72 	ldclvs	14, cr6, [r5, #-456]!	; 0xfffffe38
    163c:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1640:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
    1644:	006a6a6a 	rsbeq	r6, sl, sl, ror #20
    1648:	69355a5f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    164c:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
    1650:	4e36316a 	rsfmisz	f3, f6, #2.0
    1654:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
    1658:	704f5f6c 	subvc	r5, pc, ip, ror #30
    165c:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
    1660:	506e6f69 	rsbpl	r6, lr, r9, ror #30
    1664:	6f690076 	svcvs	0x00690076
    1668:	006c7463 	rsbeq	r7, ip, r3, ror #8
    166c:	63746572 	cmnvs	r4, #478150656	; 0x1c800000
    1670:	7400746e 	strvc	r7, [r0], #-1134	; 0xfffffb92
    1674:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    1678:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
    167c:	646f6d00 	strbtvs	r6, [pc], #-3328	; 1684 <shift+0x1684>
    1680:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
    1684:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
    1688:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    168c:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    1690:	6a63506a 	bvs	18d5840 <__bss_end+0x18cc874>
    1694:	4f494e00 	svcmi	0x00494e00
    1698:	5f6c7443 	svcpl	0x006c7443
    169c:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
    16a0:	6f697461 	svcvs	0x00697461
    16a4:	6572006e 	ldrbvs	r0, [r2, #-110]!	; 0xffffff92
    16a8:	646f6374 	strbtvs	r6, [pc], #-884	; 16b0 <shift+0x16b0>
    16ac:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
    16b0:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
    16b4:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    16b8:	6f72705f 	svcvs	0x0072705f
    16bc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    16c0:	756f635f 	strbvc	r6, [pc, #-863]!	; 1369 <shift+0x1369>
    16c4:	6600746e 	strvs	r7, [r0], -lr, ror #8
    16c8:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
    16cc:	00656d61 	rsbeq	r6, r5, r1, ror #26
    16d0:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    16d4:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    16d8:	00646970 	rsbeq	r6, r4, r0, ror r9
    16dc:	6f345a5f 	svcvs	0x00345a5f
    16e0:	506e6570 	rsbpl	r6, lr, r0, ror r5
    16e4:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
    16e8:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
    16ec:	704f5f65 	subvc	r5, pc, r5, ror #30
    16f0:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; 1564 <shift+0x1564>
    16f4:	0065646f 	rsbeq	r6, r5, pc, ror #8
    16f8:	75706e69 	ldrbvc	r6, [r0, #-3689]!	; 0xfffff197
    16fc:	65640074 	strbvs	r0, [r4, #-116]!	; 0xffffff8c
    1700:	62007473 	andvs	r7, r0, #1929379840	; 0x73000000
    1704:	6f72657a 	svcvs	0x0072657a
    1708:	6e656c00 	cdpvs	12, 6, cr6, cr5, cr0, {0}
    170c:	00687467 	rsbeq	r7, r8, r7, ror #8
    1710:	62355a5f 	eorsvs	r5, r5, #389120	; 0x5f000
    1714:	6f72657a 	svcvs	0x0072657a
    1718:	00697650 	rsbeq	r7, r9, r0, asr r6
    171c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 1668 <shift+0x1668>
    1720:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1724:	6b69746e 	blvs	1a5e8e4 <__bss_end+0x1a55918>
    1728:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
    172c:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
    1730:	4f54522d 	svcmi	0x0054522d
    1734:	616d2d53 	cmnvs	sp, r3, asr sp
    1738:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
    173c:	756f732f 	strbvc	r7, [pc, #-815]!	; 1415 <shift+0x1415>
    1740:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    1744:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1748:	2f62696c 	svccs	0x0062696c
    174c:	2f637273 	svccs	0x00637273
    1750:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
    1754:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    1758:	70632e67 	rsbvc	r2, r3, r7, ror #28
    175c:	68430070 	stmdavs	r3, {r4, r5, r6}^
    1760:	6f437261 	svcvs	0x00437261
    1764:	7241766e 	subvc	r7, r1, #115343360	; 0x6e00000
    1768:	656d0072 	strbvs	r0, [sp, #-114]!	; 0xffffff8e
    176c:	7473646d 	ldrbtvc	r6, [r3], #-1133	; 0xfffffb93
    1770:	74756f00 	ldrbtvc	r6, [r5], #-3840	; 0xfffff100
    1774:	00747570 	rsbseq	r7, r4, r0, ror r5
    1778:	6d365a5f 	vldmdbvs	r6!, {s10-s104}
    177c:	70636d65 	rsbvc	r6, r3, r5, ror #26
    1780:	764b5079 			; <UNDEFINED> instruction: 0x764b5079
    1784:	00697650 	rsbeq	r7, r9, r0, asr r6
    1788:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    178c:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    1790:	00797063 	rsbseq	r7, r9, r3, rrx
    1794:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    1798:	5f006e65 	svcpl	0x00006e65
    179c:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    17a0:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
    17a4:	634b5070 	movtvs	r5, #45168	; 0xb070
    17a8:	695f3053 	ldmdbvs	pc, {r0, r1, r4, r6, ip, sp}^	; <UNPREDICTABLE>
    17ac:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    17b0:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    17b4:	4b506e65 	blmi	141d150 <__bss_end+0x1414184>
    17b8:	74610063 	strbtvc	r0, [r1], #-99	; 0xffffff9d
    17bc:	5f00696f 	svcpl	0x0000696f
    17c0:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    17c4:	4b50696f 	blmi	141bd88 <__bss_end+0x1412dbc>
    17c8:	5a5f0063 	bpl	17c195c <__bss_end+0x17b8990>
    17cc:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    17d0:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    17d4:	4b506350 	blmi	141a51c <__bss_end+0x1411550>
    17d8:	73006963 	movwvc	r6, #2403	; 0x963
    17dc:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    17e0:	7300706d 	movwvc	r7, #109	; 0x6d
    17e4:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    17e8:	6d007970 	vstrvs.16	s14, [r0, #-224]	; 0xffffff20	; <UNPREDICTABLE>
    17ec:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    17f0:	656d0079 	strbvs	r0, [sp, #-121]!	; 0xffffff87
    17f4:	6372736d 	cmnvs	r2, #-1275068415	; 0xb4000001
    17f8:	6f746900 	svcvs	0x00746900
    17fc:	5a5f0061 	bpl	17c1988 <__bss_end+0x17b89bc>
    1800:	6f746934 	svcvs	0x00746934
    1804:	63506a61 	cmpvs	r0, #397312	; 0x61000
    1808:	2e2e006a 	cdpcs	0, 2, cr0, cr14, cr10, {3}
    180c:	2f2e2e2f 	svccs	0x002e2e2f
    1810:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1814:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1818:	2f2e2e2f 	svccs	0x002e2e2f
    181c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1820:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    1824:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    1828:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    182c:	696c2f6d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp}^
    1830:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
    1834:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
    1838:	622f0053 	eorvs	r0, pc, #83	; 0x53
    183c:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1840:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    1844:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    1848:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    184c:	61652d65 	cmnvs	r5, r5, ror #26
    1850:	7a2d6962 	bvc	b5bde0 <__bss_end+0xb52e14>
    1854:	66566253 			; <UNDEFINED> instruction: 0x66566253
    1858:	63672f6e 	cmnvs	r7, #440	; 0x1b8
    185c:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    1860:	6f6e2d6d 	svcvs	0x006e2d6d
    1864:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1868:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    186c:	30322d38 	eorscc	r2, r2, r8, lsr sp
    1870:	712d3931 			; <UNDEFINED> instruction: 0x712d3931
    1874:	75622f33 	strbvc	r2, [r2, #-3891]!	; 0xfffff0cd
    1878:	2f646c69 	svccs	0x00646c69
    187c:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1880:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1884:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1888:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
    188c:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
    1890:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    1894:	2f647261 	svccs	0x00647261
    1898:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    189c:	47006363 	strmi	r6, [r0, -r3, ror #6]
    18a0:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
    18a4:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
    18a8:	54003433 	strpl	r3, [r0], #-1075	; 0xfffffbcd
    18ac:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    18b0:	50435f54 	subpl	r5, r3, r4, asr pc
    18b4:	6f635f55 	svcvs	0x00635f55
    18b8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    18bc:	63373161 	teqvs	r7, #1073741848	; 0x40000018
    18c0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    18c4:	00376178 	eorseq	r6, r7, r8, ror r1
    18c8:	5f617369 	svcpl	0x00617369
    18cc:	5f746962 	svcpl	0x00746962
    18d0:	645f7066 	ldrbvs	r7, [pc], #-102	; 18d8 <shift+0x18d8>
    18d4:	54006c62 	strpl	r6, [r0], #-3170	; 0xfffff39e
    18d8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    18dc:	50435f54 	subpl	r5, r3, r4, asr pc
    18e0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    18e4:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    18e8:	00736a36 	rsbseq	r6, r3, r6, lsr sl
    18ec:	5f6d7261 	svcpl	0x006d7261
    18f0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    18f4:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    18f8:	0074786d 	rsbseq	r7, r4, sp, ror #16
    18fc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1900:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1904:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1908:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    190c:	33326d78 	teqcc	r2, #120, 26	; 0x1e00
    1910:	4d524100 	ldfmie	f4, [r2, #-0]
    1914:	0051455f 	subseq	r4, r1, pc, asr r5
    1918:	47524154 			; <UNDEFINED> instruction: 0x47524154
    191c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1920:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1924:	31316d72 	teqcc	r1, r2, ror sp
    1928:	32743635 	rsbscc	r3, r4, #55574528	; 0x3500000
    192c:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1930:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1934:	745f7469 	ldrbvc	r7, [pc], #-1129	; 193c <shift+0x193c>
    1938:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    193c:	52415400 	subpl	r5, r1, #0, 8
    1940:	5f544547 	svcpl	0x00544547
    1944:	5f555043 	svcpl	0x00555043
    1948:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    194c:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1950:	726f6337 	rsbvc	r6, pc, #-603979776	; 0xdc000000
    1954:	61786574 	cmnvs	r8, r4, ror r5
    1958:	42003335 	andmi	r3, r0, #-738197504	; 0xd4000000
    195c:	5f455341 	svcpl	0x00455341
    1960:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1964:	5f4d385f 	svcpl	0x004d385f
    1968:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    196c:	52415400 	subpl	r5, r1, #0, 8
    1970:	5f544547 	svcpl	0x00544547
    1974:	5f555043 	svcpl	0x00555043
    1978:	386d7261 	stmdacc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    197c:	54003031 	strpl	r3, [r0], #-49	; 0xffffffcf
    1980:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1984:	50435f54 	subpl	r5, r3, r4, asr pc
    1988:	67785f55 			; <UNDEFINED> instruction: 0x67785f55
    198c:	31656e65 	cmncc	r5, r5, ror #28
    1990:	4d524100 	ldfmie	f4, [r2, #-0]
    1994:	5343505f 	movtpl	r5, #12383	; 0x305f
    1998:	5041415f 	subpl	r4, r1, pc, asr r1
    199c:	495f5343 	ldmdbmi	pc, {r0, r1, r6, r8, r9, ip, lr}^	; <UNPREDICTABLE>
    19a0:	584d4d57 	stmdapl	sp, {r0, r1, r2, r4, r6, r8, sl, fp, lr}^
    19a4:	41540054 	cmpmi	r4, r4, asr r0
    19a8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    19ac:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    19b0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    19b4:	00696437 	rsbeq	r6, r9, r7, lsr r4
    19b8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    19bc:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    19c0:	00325f48 	eorseq	r5, r2, r8, asr #30
    19c4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    19c8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    19cc:	00335f48 	eorseq	r5, r3, r8, asr #30
    19d0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    19d4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    19d8:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    19dc:	64376d72 	ldrtvs	r6, [r7], #-3442	; 0xfffff28e
    19e0:	4142006d 	cmpmi	r2, sp, rrx
    19e4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    19e8:	5f484352 	svcpl	0x00484352
    19ec:	41420035 	cmpmi	r2, r5, lsr r0
    19f0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    19f4:	5f484352 	svcpl	0x00484352
    19f8:	41420036 	cmpmi	r2, r6, lsr r0
    19fc:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1a00:	5f484352 	svcpl	0x00484352
    1a04:	41540037 	cmpmi	r4, r7, lsr r0
    1a08:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a0c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a10:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    1a14:	00656c61 	rsbeq	r6, r5, r1, ror #24
    1a18:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1a1c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1a20:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1a24:	34396d72 	ldrtcc	r6, [r9], #-3442	; 0xfffff28e
    1a28:	00736536 	rsbseq	r6, r3, r6, lsr r5
    1a2c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1a30:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1a34:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1a38:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1a3c:	33336d78 	teqcc	r3, #120, 26	; 0x1e00
    1a40:	52415400 	subpl	r5, r1, #0, 8
    1a44:	5f544547 	svcpl	0x00544547
    1a48:	5f555043 	svcpl	0x00555043
    1a4c:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1a50:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    1a54:	61736900 	cmnvs	r3, r0, lsl #18
    1a58:	626f6e5f 	rsbvs	r6, pc, #1520	; 0x5f0
    1a5c:	54007469 	strpl	r7, [r0], #-1129	; 0xfffffb97
    1a60:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a64:	50435f54 	subpl	r5, r3, r4, asr pc
    1a68:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1a6c:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    1a70:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
    1a74:	73690073 	cmnvc	r9, #115	; 0x73
    1a78:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1a7c:	66765f74 	uhsub16vs	r5, r6, r4
    1a80:	00327670 	eorseq	r7, r2, r0, ror r6
    1a84:	5f4d5241 	svcpl	0x004d5241
    1a88:	5f534350 	svcpl	0x00534350
    1a8c:	4e4b4e55 	mcrmi	14, 2, r4, cr11, cr5, {2}
    1a90:	004e574f 	subeq	r5, lr, pc, asr #14
    1a94:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1a98:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1a9c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1aa0:	65396d72 	ldrvs	r6, [r9, #-3442]!	; 0xfffff28e
    1aa4:	53414200 	movtpl	r4, #4608	; 0x1200
    1aa8:	52415f45 	subpl	r5, r1, #276	; 0x114
    1aac:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 1271 <shift+0x1271>
    1ab0:	004a4554 	subeq	r4, sl, r4, asr r5
    1ab4:	5f6d7261 	svcpl	0x006d7261
    1ab8:	73666363 	cmnvc	r6, #-1946157055	; 0x8c000001
    1abc:	74735f6d 	ldrbtvc	r5, [r3], #-3949	; 0xfffff093
    1ac0:	00657461 	rsbeq	r7, r5, r1, ror #8
    1ac4:	70736e75 	rsbsvc	r6, r3, r5, ror lr
    1ac8:	735f6365 	cmpvc	pc, #-1811939327	; 0x94000001
    1acc:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    1ad0:	69007367 	stmdbvs	r0, {r0, r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1ad4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ad8:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    1adc:	5f006365 	svcpl	0x00006365
    1ae0:	7a6c635f 	bvc	1b1a864 <__bss_end+0x1b11898>
    1ae4:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    1ae8:	4d524100 	ldfmie	f4, [r2, #-0]
    1aec:	0043565f 	subeq	r5, r3, pc, asr r6
    1af0:	5f6d7261 	svcpl	0x006d7261
    1af4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1af8:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    1afc:	00656c61 	rsbeq	r6, r5, r1, ror #24
    1b00:	5f4d5241 	svcpl	0x004d5241
    1b04:	4100454c 	tstmi	r0, ip, asr #10
    1b08:	565f4d52 			; <UNDEFINED> instruction: 0x565f4d52
    1b0c:	52410053 	subpl	r0, r1, #83	; 0x53
    1b10:	45475f4d 	strbmi	r5, [r7, #-3917]	; 0xfffff0b3
    1b14:	6d726100 	ldfvse	f6, [r2, #-0]
    1b18:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    1b1c:	74735f65 	ldrbtvc	r5, [r3], #-3941	; 0xfffff09b
    1b20:	676e6f72 			; <UNDEFINED> instruction: 0x676e6f72
    1b24:	006d7261 	rsbeq	r7, sp, r1, ror #4
    1b28:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    1b2c:	2078656c 	rsbscs	r6, r8, ip, ror #10
    1b30:	616f6c66 	cmnvs	pc, r6, ror #24
    1b34:	41540074 	cmpmi	r4, r4, ror r0
    1b38:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b3c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b40:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1b44:	61786574 	cmnvs	r8, r4, ror r5
    1b48:	54003531 	strpl	r3, [r0], #-1329	; 0xfffffacf
    1b4c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b50:	50435f54 	subpl	r5, r3, r4, asr pc
    1b54:	61665f55 	cmnvs	r6, r5, asr pc
    1b58:	74363237 	ldrtvc	r3, [r6], #-567	; 0xfffffdc9
    1b5c:	41540065 	cmpmi	r4, r5, rrx
    1b60:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b64:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b68:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1b6c:	61786574 	cmnvs	r8, r4, ror r5
    1b70:	41003731 	tstmi	r0, r1, lsr r7
    1b74:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    1b78:	52410054 	subpl	r0, r1, #84	; 0x54
    1b7c:	544c5f4d 	strbpl	r5, [ip], #-3917	; 0xfffff0b3
    1b80:	2f2e2e00 	svccs	0x002e2e00
    1b84:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1b88:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1b8c:	2f2e2e2f 	svccs	0x002e2e2f
    1b90:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1ae0 <shift+0x1ae0>
    1b94:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1b98:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    1b9c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1ba0:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    1ba4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ba8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1bac:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1bb0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1bb4:	66347278 			; <UNDEFINED> instruction: 0x66347278
    1bb8:	52415400 	subpl	r5, r1, #0, 8
    1bbc:	5f544547 	svcpl	0x00544547
    1bc0:	5f555043 	svcpl	0x00555043
    1bc4:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1bc8:	42003032 	andmi	r3, r0, #50	; 0x32
    1bcc:	5f455341 	svcpl	0x00455341
    1bd0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1bd4:	4d45375f 	stclmi	7, cr3, [r5, #-380]	; 0xfffffe84
    1bd8:	52415400 	subpl	r5, r1, #0, 8
    1bdc:	5f544547 	svcpl	0x00544547
    1be0:	5f555043 	svcpl	0x00555043
    1be4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1be8:	31617865 	cmncc	r1, r5, ror #16
    1bec:	61680032 	cmnvs	r8, r2, lsr r0
    1bf0:	61766873 	cmnvs	r6, r3, ror r8
    1bf4:	00745f6c 	rsbseq	r5, r4, ip, ror #30
    1bf8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1bfc:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1c00:	4b365f48 	blmi	d99928 <__bss_end+0xd9095c>
    1c04:	7369005a 	cmnvc	r9, #90	; 0x5a
    1c08:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1c0c:	61007374 	tstvs	r0, r4, ror r3
    1c10:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1c14:	5f686372 	svcpl	0x00686372
    1c18:	5f6d7261 	svcpl	0x006d7261
    1c1c:	69647768 	stmdbvs	r4!, {r3, r5, r6, r8, r9, sl, ip, sp, lr}^
    1c20:	72610076 	rsbvc	r0, r1, #118	; 0x76
    1c24:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    1c28:	65645f75 	strbvs	r5, [r4, #-3957]!	; 0xfffff08b
    1c2c:	69006373 	stmdbvs	r0, {r0, r1, r4, r5, r6, r8, r9, sp, lr}
    1c30:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1c34:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1c38:	00363170 	eorseq	r3, r6, r0, ror r1
    1c3c:	5f4d5241 	svcpl	0x004d5241
    1c40:	54004948 	strpl	r4, [r0], #-2376	; 0xfffff6b8
    1c44:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c48:	50435f54 	subpl	r5, r3, r4, asr pc
    1c4c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1c50:	5400326d 	strpl	r3, [r0], #-621	; 0xfffffd93
    1c54:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c58:	50435f54 	subpl	r5, r3, r4, asr pc
    1c5c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1c60:	5400336d 	strpl	r3, [r0], #-877	; 0xfffffc93
    1c64:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c68:	50435f54 	subpl	r5, r3, r4, asr pc
    1c6c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1c70:	3031376d 	eorscc	r3, r1, sp, ror #14
    1c74:	41540030 	cmpmi	r4, r0, lsr r0
    1c78:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c7c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c80:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1c84:	41540036 	cmpmi	r4, r6, lsr r0
    1c88:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c8c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c90:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1c94:	41540037 	cmpmi	r4, r7, lsr r0
    1c98:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c9c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ca0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1ca4:	41540038 	cmpmi	r4, r8, lsr r0
    1ca8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cac:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cb0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1cb4:	41540039 	cmpmi	r4, r9, lsr r0
    1cb8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cbc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cc0:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    1cc4:	54003632 	strpl	r3, [r0], #-1586	; 0xfffff9ce
    1cc8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ccc:	50435f54 	subpl	r5, r3, r4, asr pc
    1cd0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1cd4:	6f6e5f6d 	svcvs	0x006e5f6d
    1cd8:	6c00656e 	cfstr32vs	mvfx6, [r0], {110}	; 0x6e
    1cdc:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    1ce0:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    1ce4:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
    1ce8:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
    1cec:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
    1cf0:	72610074 	rsbvc	r0, r1, #116	; 0x74
    1cf4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1cf8:	635f6863 	cmpvs	pc, #6488064	; 0x630000
    1cfc:	0065736d 	rsbeq	r7, r5, sp, ror #6
    1d00:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d04:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d08:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1d0c:	31366d72 	teqcc	r6, r2, ror sp
    1d10:	41540030 	cmpmi	r4, r0, lsr r0
    1d14:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d18:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d1c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1d20:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1d24:	41540034 	cmpmi	r4, r4, lsr r0
    1d28:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d2c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d30:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1d34:	00653031 	rsbeq	r3, r5, r1, lsr r0
    1d38:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d3c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d40:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1d44:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1d48:	00376d78 	eorseq	r6, r7, r8, ror sp
    1d4c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d50:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d54:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1d58:	35376d72 	ldrcc	r6, [r7, #-3442]!	; 0xfffff28e
    1d5c:	65663030 	strbvs	r3, [r6, #-48]!	; 0xffffffd0
    1d60:	52415400 	subpl	r5, r1, #0, 8
    1d64:	5f544547 	svcpl	0x00544547
    1d68:	5f555043 	svcpl	0x00555043
    1d6c:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1d70:	00633031 	rsbeq	r3, r3, r1, lsr r0
    1d74:	5f6d7261 	svcpl	0x006d7261
    1d78:	646e6f63 	strbtvs	r6, [lr], #-3939	; 0xfffff09d
    1d7c:	646f635f 	strbtvs	r6, [pc], #-863	; 1d84 <shift+0x1d84>
    1d80:	52410065 	subpl	r0, r1, #101	; 0x65
    1d84:	43505f4d 	cmpmi	r0, #308	; 0x134
    1d88:	41415f53 	cmpmi	r1, r3, asr pc
    1d8c:	00534350 	subseq	r4, r3, r0, asr r3
    1d90:	5f617369 	svcpl	0x00617369
    1d94:	5f746962 	svcpl	0x00746962
    1d98:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1d9c:	00325f38 	eorseq	r5, r2, r8, lsr pc
    1da0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1da4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1da8:	4d335f48 	ldcmi	15, cr5, [r3, #-288]!	; 0xfffffee0
    1dac:	52415400 	subpl	r5, r1, #0, 8
    1db0:	5f544547 	svcpl	0x00544547
    1db4:	5f555043 	svcpl	0x00555043
    1db8:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1dbc:	00743031 	rsbseq	r3, r4, r1, lsr r0
    1dc0:	5f6d7261 	svcpl	0x006d7261
    1dc4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1dc8:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1dcc:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    1dd0:	61736900 	cmnvs	r3, r0, lsl #18
    1dd4:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
    1dd8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1ddc:	41540073 	cmpmi	r4, r3, ror r0
    1de0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1de4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1de8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1dec:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1df0:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    1df4:	616d7373 	smcvs	55091	; 0xd733
    1df8:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    1dfc:	7069746c 	rsbvc	r7, r9, ip, ror #8
    1e00:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    1e04:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e08:	50435f54 	subpl	r5, r3, r4, asr pc
    1e0c:	78655f55 	stmdavc	r5!, {r0, r2, r4, r6, r8, r9, sl, fp, ip, lr}^
    1e10:	736f6e79 	cmnvc	pc, #1936	; 0x790
    1e14:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    1e18:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e1c:	50435f54 	subpl	r5, r3, r4, asr pc
    1e20:	6f635f55 	svcvs	0x00635f55
    1e24:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1e28:	00323572 	eorseq	r3, r2, r2, ror r5
    1e2c:	5f617369 	svcpl	0x00617369
    1e30:	5f746962 	svcpl	0x00746962
    1e34:	76696474 			; <UNDEFINED> instruction: 0x76696474
    1e38:	65727000 	ldrbvs	r7, [r2, #-0]!
    1e3c:	5f726566 	svcpl	0x00726566
    1e40:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    1e44:	726f665f 	rsbvc	r6, pc, #99614720	; 0x5f00000
    1e48:	6234365f 	eorsvs	r3, r4, #99614720	; 0x5f00000
    1e4c:	00737469 	rsbseq	r7, r3, r9, ror #8
    1e50:	5f617369 	svcpl	0x00617369
    1e54:	5f746962 	svcpl	0x00746962
    1e58:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1e5c:	006c6d66 	rsbeq	r6, ip, r6, ror #26
    1e60:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1e64:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1e68:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1e6c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1e70:	32336178 	eorscc	r6, r3, #120, 2
    1e74:	52415400 	subpl	r5, r1, #0, 8
    1e78:	5f544547 	svcpl	0x00544547
    1e7c:	5f555043 	svcpl	0x00555043
    1e80:	366d7261 	strbtcc	r7, [sp], -r1, ror #4
    1e84:	69003032 	stmdbvs	r0, {r1, r4, r5, ip, sp}
    1e88:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1e8c:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1e90:	63363170 	teqvs	r6, #112, 2
    1e94:	00766e6f 	rsbseq	r6, r6, pc, ror #28
    1e98:	70736e75 	rsbsvc	r6, r3, r5, ror lr
    1e9c:	5f766365 	svcpl	0x00766365
    1ea0:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1ea4:	0073676e 	rsbseq	r6, r3, lr, ror #14
    1ea8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1eac:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1eb0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1eb4:	31316d72 	teqcc	r1, r2, ror sp
    1eb8:	32743635 	rsbscc	r3, r4, #55574528	; 0x3500000
    1ebc:	41540073 	cmpmi	r4, r3, ror r0
    1ec0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ec4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ec8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1ecc:	36323031 			; <UNDEFINED> instruction: 0x36323031
    1ed0:	00736a65 	rsbseq	r6, r3, r5, ror #20
    1ed4:	5f6d7261 	svcpl	0x006d7261
    1ed8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1edc:	54006d33 	strpl	r6, [r0], #-3379	; 0xfffff2cd
    1ee0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ee4:	50435f54 	subpl	r5, r3, r4, asr pc
    1ee8:	61665f55 	cmnvs	r6, r5, asr pc
    1eec:	74363036 	ldrtvc	r3, [r6], #-54	; 0xffffffca
    1ef0:	41540065 	cmpmi	r4, r5, rrx
    1ef4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ef8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1efc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1f00:	65363239 	ldrvs	r3, [r6, #-569]!	; 0xfffffdc7
    1f04:	4200736a 	andmi	r7, r0, #-1476395007	; 0xa8000001
    1f08:	5f455341 	svcpl	0x00455341
    1f0c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1f10:	0054345f 	subseq	r3, r4, pc, asr r4
    1f14:	5f617369 	svcpl	0x00617369
    1f18:	5f746962 	svcpl	0x00746962
    1f1c:	70797263 	rsbsvc	r7, r9, r3, ror #4
    1f20:	61006f74 	tstvs	r0, r4, ror pc
    1f24:	725f6d72 	subsvc	r6, pc, #7296	; 0x1c80
    1f28:	5f736765 	svcpl	0x00736765
    1f2c:	735f6e69 	cmpvc	pc, #1680	; 0x690
    1f30:	65757165 	ldrbvs	r7, [r5, #-357]!	; 0xfffffe9b
    1f34:	0065636e 	rsbeq	r6, r5, lr, ror #6
    1f38:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1f3c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1f40:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    1f44:	41540045 	cmpmi	r4, r5, asr #32
    1f48:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f4c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f50:	3970655f 	ldmdbcc	r0!, {r0, r1, r2, r3, r4, r6, r8, sl, sp, lr}^
    1f54:	00323133 	eorseq	r3, r2, r3, lsr r1
    1f58:	5f617369 	svcpl	0x00617369
    1f5c:	74616566 	strbtvc	r6, [r1], #-1382	; 0xfffffa9a
    1f60:	00657275 	rsbeq	r7, r5, r5, ror r2
    1f64:	5f617369 	svcpl	0x00617369
    1f68:	5f746962 	svcpl	0x00746962
    1f6c:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    1f70:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    1f74:	6d726100 	ldfvse	f6, [r2, #-0]
    1f78:	6e616c5f 	mcrvs	12, 3, r6, cr1, cr15, {2}
    1f7c:	756f5f67 	strbvc	r5, [pc, #-3943]!	; 101d <shift+0x101d>
    1f80:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    1f84:	6a626f5f 	bvs	189dd08 <__bss_end+0x1894d3c>
    1f88:	5f746365 	svcpl	0x00746365
    1f8c:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    1f90:	74756269 	ldrbtvc	r6, [r5], #-617	; 0xfffffd97
    1f94:	685f7365 	ldmdavs	pc, {r0, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    1f98:	006b6f6f 	rsbeq	r6, fp, pc, ror #30
    1f9c:	5f617369 	svcpl	0x00617369
    1fa0:	5f746962 	svcpl	0x00746962
    1fa4:	645f7066 	ldrbvs	r7, [pc], #-102	; 1fac <shift+0x1fac>
    1fa8:	41003233 	tstmi	r0, r3, lsr r2
    1fac:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    1fb0:	73690045 	cmnvc	r9, #69	; 0x45
    1fb4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1fb8:	65625f74 	strbvs	r5, [r2, #-3956]!	; 0xfffff08c
    1fbc:	41540038 	cmpmi	r4, r8, lsr r0
    1fc0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1fc4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1fc8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1fcc:	36373131 			; <UNDEFINED> instruction: 0x36373131
    1fd0:	00737a6a 	rsbseq	r7, r3, sl, ror #20
    1fd4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1fd8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1fdc:	45355f48 	ldrmi	r5, [r5, #-3912]!	; 0xfffff0b8
    1fe0:	61736900 	cmnvs	r3, r0, lsl #18
    1fe4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1fe8:	6964615f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sp, lr}^
    1fec:	72700076 	rsbsvc	r0, r0, #118	; 0x76
    1ff0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1ff4:	5f726f73 	svcpl	0x00726f73
    1ff8:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    1ffc:	6c6c6100 	stfvse	f6, [ip], #-0
    2000:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    2004:	72610073 	rsbvc	r0, r1, #115	; 0x73
    2008:	63705f6d 	cmnvs	r0, #436	; 0x1b4
    200c:	41420073 	hvcmi	8195	; 0x2003
    2010:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2014:	5f484352 	svcpl	0x00484352
    2018:	61005435 	tstvs	r0, r5, lsr r4
    201c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2020:	34686372 	strbtcc	r6, [r8], #-882	; 0xfffffc8e
    2024:	41540074 	cmpmi	r4, r4, ror r0
    2028:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    202c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2030:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2034:	61786574 	cmnvs	r8, r4, ror r5
    2038:	6f633531 	svcvs	0x00633531
    203c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2040:	61003761 	tstvs	r0, r1, ror #14
    2044:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 204c <shift+0x204c>
    2048:	5f656e75 	svcpl	0x00656e75
    204c:	66756277 			; <UNDEFINED> instruction: 0x66756277
    2050:	61746800 	cmnvs	r4, r0, lsl #16
    2054:	61685f62 	cmnvs	r8, r2, ror #30
    2058:	69006873 	stmdbvs	r0, {r0, r1, r4, r5, r6, fp, sp, lr}
    205c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2060:	715f7469 	cmpvc	pc, r9, ror #8
    2064:	6b726975 	blvs	1c9c640 <__bss_end+0x1c93674>
    2068:	5f6f6e5f 	svcpl	0x006f6e5f
    206c:	616c6f76 	smcvs	50934	; 0xc6f6
    2070:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    2074:	0065635f 	rsbeq	r6, r5, pc, asr r3
    2078:	47524154 			; <UNDEFINED> instruction: 0x47524154
    207c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2080:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2084:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2088:	00306d78 	eorseq	r6, r0, r8, ror sp
    208c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2090:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2094:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2098:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    209c:	00316d78 	eorseq	r6, r1, r8, ror sp
    20a0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20a4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20a8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    20ac:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    20b0:	00336d78 	eorseq	r6, r3, r8, ror sp
    20b4:	5f617369 	svcpl	0x00617369
    20b8:	5f746962 	svcpl	0x00746962
    20bc:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    20c0:	00315f38 	eorseq	r5, r1, r8, lsr pc
    20c4:	5f6d7261 	svcpl	0x006d7261
    20c8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    20cc:	6d616e5f 	stclvs	14, cr6, [r1, #-380]!	; 0xfffffe84
    20d0:	73690065 	cmnvc	r9, #101	; 0x65
    20d4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    20d8:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    20dc:	5f38766d 	svcpl	0x0038766d
    20e0:	73690033 	cmnvc	r9, #51	; 0x33
    20e4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    20e8:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    20ec:	5f38766d 	svcpl	0x0038766d
    20f0:	41540034 	cmpmi	r4, r4, lsr r0
    20f4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    20f8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    20fc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2100:	61786574 	cmnvs	r8, r4, ror r5
    2104:	54003335 	strpl	r3, [r0], #-821	; 0xfffffccb
    2108:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    210c:	50435f54 	subpl	r5, r3, r4, asr pc
    2110:	6f635f55 	svcvs	0x00635f55
    2114:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2118:	00353561 	eorseq	r3, r5, r1, ror #10
    211c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2120:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2124:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2128:	64376d72 	ldrtvs	r6, [r7], #-3442	; 0xfffff28e
    212c:	5400696d 	strpl	r6, [r0], #-2413	; 0xfffff693
    2130:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2134:	50435f54 	subpl	r5, r3, r4, asr pc
    2138:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    213c:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    2140:	61736900 	cmnvs	r3, r0, lsl #18
    2144:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2148:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    214c:	006d3376 	rsbeq	r3, sp, r6, ror r3
    2150:	5f6d7261 	svcpl	0x006d7261
    2154:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2158:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 2160 <shift+0x2160>
    215c:	7261006d 	rsbvc	r0, r1, #109	; 0x6d
    2160:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2164:	65356863 	ldrvs	r6, [r5, #-2147]!	; 0xfffff79d
    2168:	52415400 	subpl	r5, r1, #0, 8
    216c:	5f544547 	svcpl	0x00544547
    2170:	5f555043 	svcpl	0x00555043
    2174:	316d7261 	cmncc	sp, r1, ror #4
    2178:	65303230 	ldrvs	r3, [r0, #-560]!	; 0xfffffdd0
    217c:	53414200 	movtpl	r4, #4608	; 0x1200
    2180:	52415f45 	subpl	r5, r1, #276	; 0x114
    2184:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    2188:	4154004a 	cmpmi	r4, sl, asr #32
    218c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2190:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2194:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2198:	65383639 	ldrvs	r3, [r8, #-1593]!	; 0xfffff9c7
    219c:	41540073 	cmpmi	r4, r3, ror r0
    21a0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    21a4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    21a8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    21ac:	74303437 	ldrtvc	r3, [r0], #-1079	; 0xfffffbc9
    21b0:	53414200 	movtpl	r4, #4608	; 0x1200
    21b4:	52415f45 	subpl	r5, r1, #276	; 0x114
    21b8:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    21bc:	7369004d 	cmnvc	r9, #77	; 0x4d
    21c0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    21c4:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    21c8:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    21cc:	52415400 	subpl	r5, r1, #0, 8
    21d0:	5f544547 	svcpl	0x00544547
    21d4:	5f555043 	svcpl	0x00555043
    21d8:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    21dc:	54003030 	strpl	r3, [r0], #-48	; 0xffffffd0
    21e0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21e4:	50435f54 	subpl	r5, r3, r4, asr pc
    21e8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    21ec:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    21f0:	73666a36 	cmnvc	r6, #221184	; 0x36000
    21f4:	4d524100 	ldfmie	f4, [r2, #-0]
    21f8:	00534c5f 	subseq	r4, r3, pc, asr ip
    21fc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2200:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2204:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2208:	30316d72 	eorscc	r6, r1, r2, ror sp
    220c:	00743032 	rsbseq	r3, r4, r2, lsr r0
    2210:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2214:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2218:	5a365f48 	bpl	d99f40 <__bss_end+0xd90f74>
    221c:	52415400 	subpl	r5, r1, #0, 8
    2220:	5f544547 	svcpl	0x00544547
    2224:	5f555043 	svcpl	0x00555043
    2228:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    222c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2230:	726f6335 	rsbvc	r6, pc, #-738197504	; 0xd4000000
    2234:	61786574 	cmnvs	r8, r4, ror r5
    2238:	41003535 	tstmi	r0, r5, lsr r5
    223c:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    2240:	415f5343 	cmpmi	pc, r3, asr #6
    2244:	53435041 	movtpl	r5, #12353	; 0x3041
    2248:	5046565f 	subpl	r5, r6, pc, asr r6
    224c:	52415400 	subpl	r5, r1, #0, 8
    2250:	5f544547 	svcpl	0x00544547
    2254:	5f555043 	svcpl	0x00555043
    2258:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    225c:	00327478 	eorseq	r7, r2, r8, ror r4
    2260:	5f617369 	svcpl	0x00617369
    2264:	5f746962 	svcpl	0x00746962
    2268:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    226c:	6d726100 	ldfvse	f6, [r2, #-0]
    2270:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    2274:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    2278:	73690072 	cmnvc	r9, #114	; 0x72
    227c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2280:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2284:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
    2288:	4154006d 	cmpmi	r4, sp, rrx
    228c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2290:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2294:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    2298:	65743632 	ldrbvs	r3, [r4, #-1586]!	; 0xfffff9ce
    229c:	52415400 	subpl	r5, r1, #0, 8
    22a0:	5f544547 	svcpl	0x00544547
    22a4:	5f555043 	svcpl	0x00555043
    22a8:	7672616d 	ldrbtvc	r6, [r2], -sp, ror #2
    22ac:	5f6c6c65 	svcpl	0x006c6c65
    22b0:	00346a70 	eorseq	r6, r4, r0, ror sl
    22b4:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    22b8:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    22bc:	6f705f68 	svcvs	0x00705f68
    22c0:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    22c4:	41540072 	cmpmi	r4, r2, ror r0
    22c8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    22cc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    22d0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    22d4:	61786574 	cmnvs	r8, r4, ror r5
    22d8:	61003533 	tstvs	r0, r3, lsr r5
    22dc:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 22e4 <shift+0x22e4>
    22e0:	5f656e75 	svcpl	0x00656e75
    22e4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    22e8:	615f7865 	cmpvs	pc, r5, ror #16
    22ec:	73690039 	cmnvc	r9, #57	; 0x39
    22f0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    22f4:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    22f8:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    22fc:	41540032 	cmpmi	r4, r2, lsr r0
    2300:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2304:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2308:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    230c:	61786574 	cmnvs	r8, r4, ror r5
    2310:	6f633237 	svcvs	0x00633237
    2314:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2318:	00333561 	eorseq	r3, r3, r1, ror #10
    231c:	5f617369 	svcpl	0x00617369
    2320:	5f746962 	svcpl	0x00746962
    2324:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2328:	42003262 	andmi	r3, r0, #536870918	; 0x20000006
    232c:	5f455341 	svcpl	0x00455341
    2330:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2334:	0041375f 	subeq	r3, r1, pc, asr r7
    2338:	5f617369 	svcpl	0x00617369
    233c:	5f746962 	svcpl	0x00746962
    2340:	70746f64 	rsbsvc	r6, r4, r4, ror #30
    2344:	00646f72 	rsbeq	r6, r4, r2, ror pc
    2348:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    234c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2350:	00305f48 	eorseq	r5, r0, r8, asr #30
    2354:	5f6d7261 	svcpl	0x006d7261
    2358:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    235c:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    2360:	6f6e5f65 	svcvs	0x006e5f65
    2364:	41006564 	tstmi	r0, r4, ror #10
    2368:	4d5f4d52 	ldclmi	13, cr4, [pc, #-328]	; 2228 <shift+0x2228>
    236c:	72610049 	rsbvc	r0, r1, #73	; 0x49
    2370:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2374:	6b366863 	blvs	d9c508 <__bss_end+0xd9353c>
    2378:	6d726100 	ldfvse	f6, [r2, #-0]
    237c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2380:	006d3668 	rsbeq	r3, sp, r8, ror #12
    2384:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2388:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    238c:	00345f48 	eorseq	r5, r4, r8, asr #30
    2390:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2394:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2398:	52375f48 	eorspl	r5, r7, #72, 30	; 0x120
    239c:	705f5f00 	subsvc	r5, pc, r0, lsl #30
    23a0:	6f63706f 	svcvs	0x0063706f
    23a4:	5f746e75 	svcpl	0x00746e75
    23a8:	00626174 	rsbeq	r6, r2, r4, ror r1
    23ac:	5f617369 	svcpl	0x00617369
    23b0:	5f746962 	svcpl	0x00746962
    23b4:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    23b8:	52415400 	subpl	r5, r1, #0, 8
    23bc:	5f544547 	svcpl	0x00544547
    23c0:	5f555043 	svcpl	0x00555043
    23c4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    23c8:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    23cc:	41540033 	cmpmi	r4, r3, lsr r0
    23d0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    23d4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    23d8:	6e65675f 	mcrvs	7, 3, r6, cr5, cr15, {2}
    23dc:	63697265 	cmnvs	r9, #1342177286	; 0x50000006
    23e0:	00613776 	rsbeq	r3, r1, r6, ror r7
    23e4:	5f617369 	svcpl	0x00617369
    23e8:	5f746962 	svcpl	0x00746962
    23ec:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    23f0:	61006535 	tstvs	r0, r5, lsr r5
    23f4:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    23f8:	5f686372 	svcpl	0x00686372
    23fc:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    2400:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    2404:	5f656c69 	svcpl	0x00656c69
    2408:	42006563 	andmi	r6, r0, #415236096	; 0x18c00000
    240c:	5f455341 	svcpl	0x00455341
    2410:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2414:	0041385f 	subeq	r3, r1, pc, asr r8
    2418:	47524154 			; <UNDEFINED> instruction: 0x47524154
    241c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2420:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2424:	30316d72 	eorscc	r6, r1, r2, ror sp
    2428:	00653232 	rsbeq	r3, r5, r2, lsr r2
    242c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2430:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2434:	52385f48 	eorspl	r5, r8, #72, 30	; 0x120
    2438:	52415400 	subpl	r5, r1, #0, 8
    243c:	5f544547 	svcpl	0x00544547
    2440:	5f555043 	svcpl	0x00555043
    2444:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2448:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    244c:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    2450:	61786574 	cmnvs	r8, r4, ror r5
    2454:	41003533 	tstmi	r0, r3, lsr r5
    2458:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    245c:	72610056 	rsbvc	r0, r1, #86	; 0x56
    2460:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2464:	00346863 	eorseq	r6, r4, r3, ror #16
    2468:	5f6d7261 	svcpl	0x006d7261
    246c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2470:	72610035 	rsbvc	r0, r1, #53	; 0x35
    2474:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2478:	00376863 	eorseq	r6, r7, r3, ror #16
    247c:	5f6d7261 	svcpl	0x006d7261
    2480:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2484:	6f6c0038 	svcvs	0x006c0038
    2488:	6420676e 	strtvs	r6, [r0], #-1902	; 0xfffff892
    248c:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    2490:	41420065 	cmpmi	r2, r5, rrx
    2494:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2498:	5f484352 	svcpl	0x00484352
    249c:	54004b36 	strpl	r4, [r0], #-2870	; 0xfffff4ca
    24a0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    24a4:	50435f54 	subpl	r5, r3, r4, asr pc
    24a8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    24ac:	3034396d 	eorscc	r3, r4, sp, ror #18
    24b0:	72610074 	rsbvc	r0, r1, #116	; 0x74
    24b4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    24b8:	00366863 	eorseq	r6, r6, r3, ror #16
    24bc:	5f6d7261 	svcpl	0x006d7261
    24c0:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    24c4:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    24c8:	00656c61 	rsbeq	r6, r5, r1, ror #24
    24cc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    24d0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    24d4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    24d8:	35376d72 	ldrcc	r6, [r7, #-3442]!	; 0xfffff28e
    24dc:	6d003030 	stcvs	0, cr3, [r0, #-192]	; 0xffffff40
    24e0:	6e696b61 	vnmulvs.f64	d22, d9, d17
    24e4:	6f635f67 	svcvs	0x00635f67
    24e8:	5f74736e 	svcpl	0x0074736e
    24ec:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
    24f0:	68740065 	ldmdavs	r4!, {r0, r2, r5, r6}^
    24f4:	5f626d75 	svcpl	0x00626d75
    24f8:	6c6c6163 	stfvse	f6, [ip], #-396	; 0xfffffe74
    24fc:	6169765f 	cmnvs	r9, pc, asr r6
    2500:	62616c5f 	rsbvs	r6, r1, #24320	; 0x5f00
    2504:	69006c65 	stmdbvs	r0, {r0, r2, r5, r6, sl, fp, sp, lr}
    2508:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    250c:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    2510:	00357670 	eorseq	r7, r5, r0, ror r6
    2514:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2518:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    251c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2520:	31376d72 	teqcc	r7, r2, ror sp
    2524:	73690030 	cmnvc	r9, #48	; 0x30
    2528:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    252c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2530:	6b36766d 	blvs	d9feec <__bss_end+0xd96f20>
    2534:	52415400 	subpl	r5, r1, #0, 8
    2538:	5f544547 	svcpl	0x00544547
    253c:	5f555043 	svcpl	0x00555043
    2540:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2544:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2548:	52415400 	subpl	r5, r1, #0, 8
    254c:	5f544547 	svcpl	0x00544547
    2550:	5f555043 	svcpl	0x00555043
    2554:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2558:	38617865 	stmdacc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    255c:	52415400 	subpl	r5, r1, #0, 8
    2560:	5f544547 	svcpl	0x00544547
    2564:	5f555043 	svcpl	0x00555043
    2568:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    256c:	39617865 	stmdbcc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    2570:	4d524100 	ldfmie	f4, [r2, #-0]
    2574:	5343505f 	movtpl	r5, #12383	; 0x305f
    2578:	4350415f 	cmpmi	r0, #-1073741801	; 0xc0000017
    257c:	52410053 	subpl	r0, r1, #83	; 0x53
    2580:	43505f4d 	cmpmi	r0, #308	; 0x134
    2584:	54415f53 	strbpl	r5, [r1], #-3923	; 0xfffff0ad
    2588:	00534350 	subseq	r4, r3, r0, asr r3
    258c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2590:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2594:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2598:	30366d72 	eorscc	r6, r6, r2, ror sp
    259c:	41540030 	cmpmi	r4, r0, lsr r0
    25a0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25a4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    25a8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    25ac:	74303237 	ldrtvc	r3, [r0], #-567	; 0xfffffdc9
    25b0:	52415400 	subpl	r5, r1, #0, 8
    25b4:	5f544547 	svcpl	0x00544547
    25b8:	5f555043 	svcpl	0x00555043
    25bc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    25c0:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    25c4:	6f630037 	svcvs	0x00630037
    25c8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    25cc:	6f642078 	svcvs	0x00642078
    25d0:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    25d4:	52415400 	subpl	r5, r1, #0, 8
    25d8:	5f544547 	svcpl	0x00544547
    25dc:	5f555043 	svcpl	0x00555043
    25e0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    25e4:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    25e8:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    25ec:	61786574 	cmnvs	r8, r4, ror r5
    25f0:	54003335 	strpl	r3, [r0], #-821	; 0xfffffccb
    25f4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    25f8:	50435f54 	subpl	r5, r3, r4, asr pc
    25fc:	6f635f55 	svcvs	0x00635f55
    2600:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2604:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    2608:	61007375 	tstvs	r0, r5, ror r3
    260c:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    2610:	73690063 	cmnvc	r9, #99	; 0x63
    2614:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2618:	6f6d5f74 	svcvs	0x006d5f74
    261c:	36326564 	ldrtcc	r6, [r2], -r4, ror #10
    2620:	61736900 	cmnvs	r3, r0, lsl #18
    2624:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2628:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    262c:	00656c61 	rsbeq	r6, r5, r1, ror #24
    2630:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2634:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2638:	735f5550 	cmpvc	pc, #80, 10	; 0x14000000
    263c:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    2640:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    2644:	30303131 	eorscc	r3, r0, r1, lsr r1
    2648:	52415400 	subpl	r5, r1, #0, 8
    264c:	5f544547 	svcpl	0x00544547
    2650:	5f555043 	svcpl	0x00555043
    2654:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    2658:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    265c:	645f0073 	ldrbvs	r0, [pc], #-115	; 2664 <shift+0x2664>
    2660:	5f746e6f 	svcpl	0x00746e6f
    2664:	5f657375 	svcpl	0x00657375
    2668:	65657274 	strbvs	r7, [r5, #-628]!	; 0xfffffd8c
    266c:	7265685f 	rsbvc	r6, r5, #6225920	; 0x5f0000
    2670:	54005f65 	strpl	r5, [r0], #-3941	; 0xfffff09b
    2674:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2678:	50435f54 	subpl	r5, r3, r4, asr pc
    267c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2680:	7430316d 	ldrtvc	r3, [r0], #-365	; 0xfffffe93
    2684:	00696d64 	rsbeq	r6, r9, r4, ror #26
    2688:	47524154 			; <UNDEFINED> instruction: 0x47524154
    268c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2690:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2694:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2698:	00356178 	eorseq	r6, r5, r8, ror r1
    269c:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    26a0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    26a4:	65746968 	ldrbvs	r6, [r4, #-2408]!	; 0xfffff698
    26a8:	72757463 	rsbsvc	r7, r5, #1660944384	; 0x63000000
    26ac:	72610065 	rsbvc	r0, r1, #101	; 0x65
    26b0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    26b4:	635f6863 	cmpvs	pc, #6488064	; 0x630000
    26b8:	54006372 	strpl	r6, [r0], #-882	; 0xfffffc8e
    26bc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    26c0:	50435f54 	subpl	r5, r3, r4, asr pc
    26c4:	6f635f55 	svcvs	0x00635f55
    26c8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    26cc:	6d73316d 	ldfvse	f3, [r3, #-436]!	; 0xfffffe4c
    26d0:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    26d4:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    26d8:	00796c70 	rsbseq	r6, r9, r0, ror ip
    26dc:	5f6d7261 	svcpl	0x006d7261
    26e0:	72727563 	rsbsvc	r7, r2, #415236096	; 0x18c00000
    26e4:	5f746e65 	svcpl	0x00746e65
    26e8:	61006363 	tstvs	r0, r3, ror #6
    26ec:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 26f4 <shift+0x26f4>
    26f0:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    26f4:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
    26f8:	69006e73 	stmdbvs	r0, {r0, r1, r4, r5, r6, r9, sl, fp, sp, lr}
    26fc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2700:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    2704:	32336372 	eorscc	r6, r3, #-939524095	; 0xc8000001
    2708:	4d524100 	ldfmie	f4, [r2, #-0]
    270c:	004c505f 	subeq	r5, ip, pc, asr r0
    2710:	5f617369 	svcpl	0x00617369
    2714:	5f746962 	svcpl	0x00746962
    2718:	76706676 			; <UNDEFINED> instruction: 0x76706676
    271c:	73690033 	cmnvc	r9, #51	; 0x33
    2720:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2724:	66765f74 	uhsub16vs	r5, r6, r4
    2728:	00347670 	eorseq	r7, r4, r0, ror r6
    272c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2730:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2734:	54365f48 	ldrtpl	r5, [r6], #-3912	; 0xfffff0b8
    2738:	41420032 	cmpmi	r2, r2, lsr r0
    273c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2740:	5f484352 	svcpl	0x00484352
    2744:	4d5f4d38 	ldclmi	13, cr4, [pc, #-224]	; 266c <shift+0x266c>
    2748:	004e4941 	subeq	r4, lr, r1, asr #18
    274c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2750:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2754:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2758:	74396d72 	ldrtvc	r6, [r9], #-3442	; 0xfffff28e
    275c:	00696d64 	rsbeq	r6, r9, r4, ror #26
    2760:	5f4d5241 	svcpl	0x004d5241
    2764:	69004c41 	stmdbvs	r0, {r0, r6, sl, fp, lr}
    2768:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    276c:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 25d0 <shift+0x25d0>
    2770:	3365646f 	cmncc	r5, #1862270976	; 0x6f000000
    2774:	41420032 	cmpmi	r2, r2, lsr r0
    2778:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    277c:	5f484352 	svcpl	0x00484352
    2780:	61004d37 	tstvs	r0, r7, lsr sp
    2784:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 278c <shift+0x278c>
    2788:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    278c:	616c5f74 	smcvs	50676	; 0xc5f4
    2790:	006c6562 	rsbeq	r6, ip, r2, ror #10
    2794:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2798:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    279c:	735f5550 	cmpvc	pc, #80, 10	; 0x14000000
    27a0:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    27a4:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    27a8:	30313131 	eorscc	r3, r1, r1, lsr r1
    27ac:	52415400 	subpl	r5, r1, #0, 8
    27b0:	5f544547 	svcpl	0x00544547
    27b4:	5f555043 	svcpl	0x00555043
    27b8:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    27bc:	54003032 	strpl	r3, [r0], #-50	; 0xffffffce
    27c0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    27c4:	50435f54 	subpl	r5, r3, r4, asr pc
    27c8:	6f635f55 	svcvs	0x00635f55
    27cc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    27d0:	54003472 	strpl	r3, [r0], #-1138	; 0xfffffb8e
    27d4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    27d8:	50435f54 	subpl	r5, r3, r4, asr pc
    27dc:	6f635f55 	svcvs	0x00635f55
    27e0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    27e4:	54003572 	strpl	r3, [r0], #-1394	; 0xfffffa8e
    27e8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    27ec:	50435f54 	subpl	r5, r3, r4, asr pc
    27f0:	6f635f55 	svcvs	0x00635f55
    27f4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    27f8:	54003772 	strpl	r3, [r0], #-1906	; 0xfffff88e
    27fc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2800:	50435f54 	subpl	r5, r3, r4, asr pc
    2804:	6f635f55 	svcvs	0x00635f55
    2808:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    280c:	69003872 	stmdbvs	r0, {r1, r4, r5, r6, fp, ip, sp}
    2810:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2814:	6c5f7469 	cfldrdvs	mvd7, [pc], {105}	; 0x69
    2818:	00656170 	rsbeq	r6, r5, r0, ror r1
    281c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2820:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2824:	735f5550 	cmpvc	pc, #80, 10	; 0x14000000
    2828:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    282c:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    2830:	00303131 	eorseq	r3, r0, r1, lsr r1
    2834:	5f617369 	svcpl	0x00617369
    2838:	5f746962 	svcpl	0x00746962
    283c:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    2840:	72615f6b 	rsbvc	r5, r1, #428	; 0x1ac
    2844:	6b36766d 	blvs	da0200 <__bss_end+0xd97234>
    2848:	7369007a 	cmnvc	r9, #122	; 0x7a
    284c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2850:	6f6e5f74 	svcvs	0x006e5f74
    2854:	69006d74 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, fp, sp, lr}
    2858:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    285c:	615f7469 	cmpvs	pc, r9, ror #8
    2860:	34766d72 	ldrbtcc	r6, [r6], #-3442	; 0xfffff28e
    2864:	61736900 	cmnvs	r3, r0, lsl #18
    2868:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    286c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2870:	69003576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, ip, sp}
    2874:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2878:	615f7469 	cmpvs	pc, r9, ror #8
    287c:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    2880:	61736900 	cmnvs	r3, r0, lsl #18
    2884:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2888:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    288c:	69003776 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, sl, ip, sp}
    2890:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2894:	615f7469 	cmpvs	pc, r9, ror #8
    2898:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    289c:	6f645f00 	svcvs	0x00645f00
    28a0:	755f746e 	ldrbvc	r7, [pc, #-1134]	; 243a <shift+0x243a>
    28a4:	725f6573 	subsvc	r6, pc, #482344960	; 0x1cc00000
    28a8:	685f7874 	ldmdavs	pc, {r2, r4, r5, r6, fp, ip, sp, lr}^	; <UNPREDICTABLE>
    28ac:	5f657265 	svcpl	0x00657265
    28b0:	49515500 	ldmdbmi	r1, {r8, sl, ip, lr}^
    28b4:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    28b8:	6d726100 	ldfvse	f6, [r2, #-0]
    28bc:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    28c0:	72610065 	rsbvc	r0, r1, #101	; 0x65
    28c4:	70635f6d 	rsbvc	r5, r3, sp, ror #30
    28c8:	6e695f70 	mcrvs	15, 3, r5, cr9, cr0, {3}
    28cc:	77726574 			; <UNDEFINED> instruction: 0x77726574
    28d0:	006b726f 	rsbeq	r7, fp, pc, ror #4
    28d4:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    28d8:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
    28dc:	52415400 	subpl	r5, r1, #0, 8
    28e0:	5f544547 	svcpl	0x00544547
    28e4:	5f555043 	svcpl	0x00555043
    28e8:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    28ec:	00743032 	rsbseq	r3, r4, r2, lsr r0
    28f0:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    28f4:	0071655f 	rsbseq	r6, r1, pc, asr r5
    28f8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    28fc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2900:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    2904:	36323561 	ldrtcc	r3, [r2], -r1, ror #10
    2908:	6d726100 	ldfvse	f6, [r2, #-0]
    290c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2910:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    2914:	5f626d75 	svcpl	0x00626d75
    2918:	69647768 	stmdbvs	r4!, {r3, r5, r6, r8, r9, sl, ip, sp, lr}^
    291c:	74680076 	strbtvc	r0, [r8], #-118	; 0xffffff8a
    2920:	655f6261 	ldrbvs	r6, [pc, #-609]	; 26c7 <shift+0x26c7>
    2924:	6f705f71 	svcvs	0x00705f71
    2928:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    292c:	41540072 	cmpmi	r4, r2, ror r0
    2930:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2934:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2938:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    293c:	47003036 	smladxmi	r0, r6, r0, r3
    2940:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    2944:	38203731 	stmdacc	r0!, {r0, r4, r5, r8, r9, sl, ip, sp}
    2948:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
    294c:	31303220 	teqcc	r0, r0, lsr #4
    2950:	30373039 	eorscc	r3, r7, r9, lsr r0
    2954:	72282033 	eorvc	r2, r8, #51	; 0x33
    2958:	61656c65 	cmnvs	r5, r5, ror #24
    295c:	20296573 	eorcs	r6, r9, r3, ror r5
    2960:	6363675b 	cmnvs	r3, #23855104	; 0x16c0000
    2964:	622d382d 	eorvs	r3, sp, #2949120	; 0x2d0000
    2968:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
    296c:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
    2970:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    2974:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
    2978:	32303337 	eorscc	r3, r0, #-603979776	; 0xdc000000
    297c:	2d205d37 	stccs	13, cr5, [r0, #-220]!	; 0xffffff24
    2980:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    2984:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    2988:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    298c:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    2990:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    2994:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    2998:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    299c:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    29a0:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    29a4:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    29a8:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    29ac:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    29b0:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    29b4:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    29b8:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    29bc:	62662d20 	rsbvs	r2, r6, #32, 26	; 0x800
    29c0:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    29c4:	2d676e69 	stclcs	14, cr6, [r7, #-420]!	; 0xfffffe5c
    29c8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    29cc:	2d206363 	stccs	3, cr6, [r0, #-396]!	; 0xfffffe74
    29d0:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 2840 <shift+0x2840>
    29d4:	63617473 	cmnvs	r1, #1929379840	; 0x73000000
    29d8:	72702d6b 	rsbsvc	r2, r0, #6848	; 0x1ac0
    29dc:	6365746f 	cmnvs	r5, #1862270976	; 0x6f000000
    29e0:	20726f74 	rsbscs	r6, r2, r4, ror pc
    29e4:	6f6e662d 	svcvs	0x006e662d
    29e8:	6c6e692d 			; <UNDEFINED> instruction: 0x6c6e692d
    29ec:	20656e69 	rsbcs	r6, r5, r9, ror #28
    29f0:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
    29f4:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    29f8:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
    29fc:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
    2a00:	006e6564 	rsbeq	r6, lr, r4, ror #10
    2a04:	5f6d7261 	svcpl	0x006d7261
    2a08:	5f636970 	svcpl	0x00636970
    2a0c:	69676572 	stmdbvs	r7!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    2a10:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
    2a14:	52415400 	subpl	r5, r1, #0, 8
    2a18:	5f544547 	svcpl	0x00544547
    2a1c:	5f555043 	svcpl	0x00555043
    2a20:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2a24:	306d7865 	rsbcc	r7, sp, r5, ror #16
    2a28:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    2a2c:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    2a30:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    2a34:	41540079 	cmpmi	r4, r9, ror r0
    2a38:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2a3c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2a40:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2a44:	65363639 	ldrvs	r3, [r6, #-1593]!	; 0xfffff9c7
    2a48:	41540073 	cmpmi	r4, r3, ror r0
    2a4c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2a50:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2a54:	63706d5f 	cmnvs	r0, #6080	; 0x17c0
    2a58:	6e65726f 	cdpvs	2, 6, cr7, cr5, cr15, {3}
    2a5c:	7066766f 	rsbvc	r7, r6, pc, ror #12
    2a60:	61736900 	cmnvs	r3, r0, lsl #18
    2a64:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2a68:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    2a6c:	635f6b72 	cmpvs	pc, #116736	; 0x1c800
    2a70:	6c5f336d 	mrrcvs	3, 6, r3, pc, cr13	; <UNPREDICTABLE>
    2a74:	00647264 	rsbeq	r7, r4, r4, ror #4
    2a78:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2a7c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2a80:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2a84:	30376d72 	eorscc	r6, r7, r2, ror sp
    2a88:	41006930 	tstmi	r0, r0, lsr r9
    2a8c:	435f4d52 	cmpmi	pc, #5248	; 0x1480
    2a90:	72610043 	rsbvc	r0, r1, #67	; 0x43
    2a94:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2a98:	5f386863 	svcpl	0x00386863
    2a9c:	41540032 	cmpmi	r4, r2, lsr r0
    2aa0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2aa4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2aa8:	706d665f 	rsbvc	r6, sp, pc, asr r6
    2aac:	00363236 	eorseq	r3, r6, r6, lsr r2
    2ab0:	5f4d5241 	svcpl	0x004d5241
    2ab4:	61005343 	tstvs	r0, r3, asr #6
    2ab8:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    2abc:	5f363170 	svcpl	0x00363170
    2ac0:	74736e69 	ldrbtvc	r6, [r3], #-3689	; 0xfffff197
    2ac4:	6d726100 	ldfvse	f6, [r2, #-0]
    2ac8:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
    2acc:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    2ad0:	54006863 	strpl	r6, [r0], #-2147	; 0xfffff79d
    2ad4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2ad8:	50435f54 	subpl	r5, r3, r4, asr pc
    2adc:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2ae0:	006d376d 	rsbeq	r3, sp, sp, ror #14
    2ae4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2ae8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2aec:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2af0:	30376d72 	eorscc	r6, r7, r2, ror sp
    2af4:	52415400 	subpl	r5, r1, #0, 8
    2af8:	5f544547 	svcpl	0x00544547
    2afc:	5f555043 	svcpl	0x00555043
    2b00:	326d7261 	rsbcc	r7, sp, #268435462	; 0x10000006
    2b04:	61003035 	tstvs	r0, r5, lsr r0
    2b08:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2b0c:	37686372 			; <UNDEFINED> instruction: 0x37686372
    2b10:	54006d65 	strpl	r6, [r0], #-3429	; 0xfffff29b
    2b14:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2b18:	50435f54 	subpl	r5, r3, r4, asr pc
    2b1c:	6f635f55 	svcvs	0x00635f55
    2b20:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2b24:	00323761 	eorseq	r3, r2, r1, ror #14
    2b28:	5f6d7261 	svcpl	0x006d7261
    2b2c:	5f736370 	svcpl	0x00736370
    2b30:	61666564 	cmnvs	r6, r4, ror #10
    2b34:	00746c75 	rsbseq	r6, r4, r5, ror ip
    2b38:	5f4d5241 	svcpl	0x004d5241
    2b3c:	5f534350 	svcpl	0x00534350
    2b40:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    2b44:	4f4c5f53 	svcmi	0x004c5f53
    2b48:	004c4143 	subeq	r4, ip, r3, asr #2
    2b4c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2b50:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2b54:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2b58:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2b5c:	35376178 	ldrcc	r6, [r7, #-376]!	; 0xfffffe88
    2b60:	52415400 	subpl	r5, r1, #0, 8
    2b64:	5f544547 	svcpl	0x00544547
    2b68:	5f555043 	svcpl	0x00555043
    2b6c:	6f727473 	svcvs	0x00727473
    2b70:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    2b74:	7261006d 	rsbvc	r0, r1, #109	; 0x6d
    2b78:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2b7c:	745f6863 	ldrbvc	r6, [pc], #-2147	; 2b84 <shift+0x2b84>
    2b80:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    2b84:	72610031 	rsbvc	r0, r1, #49	; 0x31
    2b88:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2b8c:	745f6863 	ldrbvc	r6, [pc], #-2147	; 2b94 <shift+0x2b94>
    2b90:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    2b94:	41540032 	cmpmi	r4, r2, lsr r0
    2b98:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2b9c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2ba0:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    2ba4:	0074786d 	rsbseq	r7, r4, sp, ror #16
    2ba8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2bac:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2bb0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2bb4:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    2bb8:	54007432 	strpl	r7, [r0], #-1074	; 0xfffffbce
    2bbc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2bc0:	50435f54 	subpl	r5, r3, r4, asr pc
    2bc4:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2bc8:	0064376d 	rsbeq	r3, r4, sp, ror #14
    2bcc:	5f617369 	svcpl	0x00617369
    2bd0:	5f746962 	svcpl	0x00746962
    2bd4:	6100706d 	tstvs	r0, sp, rrx
    2bd8:	6c5f6d72 	mrrcvs	13, 7, r6, pc, cr2	; <UNPREDICTABLE>
    2bdc:	63735f64 	cmnvs	r3, #100, 30	; 0x190
    2be0:	00646568 	rsbeq	r6, r4, r8, ror #10
    2be4:	5f6d7261 	svcpl	0x006d7261
    2be8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2bec:	00315f38 	eorseq	r5, r1, r8, lsr pc

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
  20:	8b040e42 	blhi	103930 <__bss_end+0xfa964>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x347864>
  28:	420d0d66 	andmi	r0, sp, #6528	; 0x1980
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	0000806c 	andeq	r8, r0, ip, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1fa984>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9cb4>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080ac 	andeq	r8, r0, ip, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfa9b4>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x3478b4>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080e4 	andeq	r8, r0, r4, ror #1
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfa9d4>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x3478d4>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008110 	andeq	r8, r0, r0, lsl r1
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfa9f4>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x3478f4>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008130 	andeq	r8, r0, r0, lsr r1
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfaa14>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x347914>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008148 	andeq	r8, r0, r8, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfaa34>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x347934>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008160 	andeq	r8, r0, r0, ror #2
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfaa54>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x347954>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008178 	andeq	r8, r0, r8, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfaa74>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x347974>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	00008184 	andeq	r8, r0, r4, lsl #3
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1faa8c>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081dc 	ldrdeq	r8, [r0], -ip
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1faaac>
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
 194:	00000194 	muleq	r0, r4, r1
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1faadc>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	000083c8 	andeq	r8, r0, r8, asr #7
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfab08>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x347a08>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	000083f4 	strdeq	r8, [r0], -r4
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfab28>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x347a28>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	00008420 	andeq	r8, r0, r0, lsr #8
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfab48>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x347a48>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	0000843c 	andeq	r8, r0, ip, lsr r4
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfab68>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x347a68>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	00008480 	andeq	r8, r0, r0, lsl #9
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfab88>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x347a88>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	000084d0 	ldrdeq	r8, [r0], -r0
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfaba8>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x347aa8>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	00008520 	andeq	r8, r0, r0, lsr #10
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfabc8>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347ac8>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	0000854c 	andeq	r8, r0, ip, asr #10
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfabe8>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347ae8>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	0000859c 	muleq	r0, ip, r5
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfac08>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x347b08>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	000085e0 	andeq	r8, r0, r0, ror #11
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfac28>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x347b28>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	00008630 	andeq	r8, r0, r0, lsr r6
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfac48>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x347b48>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	00008684 	andeq	r8, r0, r4, lsl #13
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfac68>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x347b68>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	000086c0 	andeq	r8, r0, r0, asr #13
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfac88>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x347b88>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	000086fc 	strdeq	r8, [r0], -ip
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfaca8>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347ba8>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	00008738 	andeq	r8, r0, r8, lsr r7
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfacc8>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347bc8>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	00008774 	andeq	r8, r0, r4, ror r7
 3a0:	000000b4 	strheq	r0, [r0], -r4
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1face8>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c52 	stmdaeq	sp, {r1, r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	00008828 	andeq	r8, r0, r8, lsr #16
 3d0:	00000174 	andeq	r0, r0, r4, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fad18>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	0000899c 	muleq	r0, ip, r9
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfad38>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x347c38>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	00008a38 	andeq	r8, r0, r8, lsr sl
 410:	000000c0 	andeq	r0, r0, r0, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfad58>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x347c58>
 41c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	00008af8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 430:	000000ac 	andeq	r0, r0, ip, lsr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfad78>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x347c78>
 43c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008ba4 	andeq	r8, r0, r4, lsr #23
 450:	00000054 	andeq	r0, r0, r4, asr r0
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfad98>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347c98>
 45c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008bf8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 470:	00000068 	andeq	r0, r0, r8, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfadb8>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347cb8>
 47c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008c60 	andeq	r8, r0, r0, ror #24
 490:	00000080 	andeq	r0, r0, r0, lsl #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfadd8>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347cd8>
 49c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000000c 	andeq	r0, r0, ip
 4a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4ac:	7c010001 	stcvc	0, cr0, [r1], {1}
 4b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4b4:	0000000c 	andeq	r0, r0, ip
 4b8:	000004a4 	andeq	r0, r0, r4, lsr #9
 4bc:	00008ce0 	andeq	r8, r0, r0, ror #25
 4c0:	000001ec 	andeq	r0, r0, ip, ror #3
