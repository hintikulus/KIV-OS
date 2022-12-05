
./init_task:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/home/hintik/dev/final/src/sources/userspace/crt0.s:10
;@ startovaci symbol - vstupni bod z jadra OS do uzivatelskeho programu
;@ v podstate jen ihned zavola nejakou C funkci, nepotrebujeme nic tak kritickeho, abychom to vsechno museli psal v ASM
;@ jen _start vlastne ani neni funkce, takze by tento vstupni bod mel byt psany takto; rovnez je treba se ujistit, ze
;@ je tento symbol relokovany spravne na 0x8000 (tam OS ocekava, ze se nachazi vstupni bod)
_start:
    bl __crt0_run
    8000:	eb000016 	bl	8060 <__crt0_run>

00008004 <_hang>:
_hang():
/home/hintik/dev/final/src/sources/userspace/crt0.s:13
    ;@ z funkce __crt0_run by se nemel proces uz vratit, ale kdyby neco, tak se zacyklime
_hang:
    b _hang
    8004:	eafffffe 	b	8004 <_hang>

00008008 <__crt0_init_bss>:
__crt0_init_bss():
/home/hintik/dev/final/src/sources/userspace/crt0.c:10

extern unsigned int __bss_start;
extern unsigned int __bss_end;

void __crt0_init_bss()
{
    8008:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    800c:	e28db000 	add	fp, sp, #0
    8010:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/final/src/sources/userspace/crt0.c:11
    for (unsigned int* cur = &__bss_start; cur < &__bss_end; cur++)
    8014:	e59f303c 	ldr	r3, [pc, #60]	; 8058 <__crt0_init_bss+0x50>
    8018:	e50b3008 	str	r3, [fp, #-8]
    801c:	ea000005 	b	8038 <__crt0_init_bss+0x30>
/home/hintik/dev/final/src/sources/userspace/crt0.c:12 (discriminator 3)
        *cur = 0;
    8020:	e51b3008 	ldr	r3, [fp, #-8]
    8024:	e3a02000 	mov	r2, #0
    8028:	e5832000 	str	r2, [r3]
/home/hintik/dev/final/src/sources/userspace/crt0.c:11 (discriminator 3)
    for (unsigned int* cur = &__bss_start; cur < &__bss_end; cur++)
    802c:	e51b3008 	ldr	r3, [fp, #-8]
    8030:	e2833004 	add	r3, r3, #4
    8034:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/userspace/crt0.c:11 (discriminator 1)
    8038:	e51b3008 	ldr	r3, [fp, #-8]
    803c:	e59f2018 	ldr	r2, [pc, #24]	; 805c <__crt0_init_bss+0x54>
    8040:	e1530002 	cmp	r3, r2
    8044:	3afffff5 	bcc	8020 <__crt0_init_bss+0x18>
/home/hintik/dev/final/src/sources/userspace/crt0.c:13
}
    8048:	e320f000 	nop	{0}
    804c:	e28bd000 	add	sp, fp, #0
    8050:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8054:	e12fff1e 	bx	lr
    8058:	00009ce8 	andeq	r9, r0, r8, ror #25
    805c:	00009cf8 	strdeq	r9, [r0], -r8

00008060 <__crt0_run>:
__crt0_run():
/home/hintik/dev/final/src/sources/userspace/crt0.c:16

void __crt0_run()
{
    8060:	e92d4800 	push	{fp, lr}
    8064:	e28db004 	add	fp, sp, #4
    8068:	e24dd008 	sub	sp, sp, #8
/home/hintik/dev/final/src/sources/userspace/crt0.c:18
    // inicializace .bss sekce (vynulovani)
    __crt0_init_bss();
    806c:	ebffffe5 	bl	8008 <__crt0_init_bss>
/home/hintik/dev/final/src/sources/userspace/crt0.c:21

    // volani konstruktoru globalnich trid (C++)
    _cpp_startup();
    8070:	eb000040 	bl	8178 <_cpp_startup>
/home/hintik/dev/final/src/sources/userspace/crt0.c:26

    // volani funkce main
    // nebudeme se zde zabyvat predavanim parametru do funkce main
    // jinak by se mohly predavat napr. namapovane do virtualniho adr. prostoru a odkazem pres zasobnik (kam nam muze OS pushnout co chce)
    int result = main(0, 0);
    8074:	e3a01000 	mov	r1, #0
    8078:	e3a00000 	mov	r0, #0
    807c:	eb000069 	bl	8228 <main>
    8080:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/final/src/sources/userspace/crt0.c:29

    // volani destruktoru globalnich trid (C++)
    _cpp_shutdown();
    8084:	eb000051 	bl	81d0 <_cpp_shutdown>
/home/hintik/dev/final/src/sources/userspace/crt0.c:32

    // volani terminate() syscallu s navratovym kodem funkce main
    asm volatile("mov r0, %0" : : "r" (result));
    8088:	e51b3008 	ldr	r3, [fp, #-8]
    808c:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/userspace/crt0.c:33
    asm volatile("svc #1");
    8090:	ef000001 	svc	0x00000001
/home/hintik/dev/final/src/sources/userspace/crt0.c:34
}
    8094:	e320f000 	nop	{0}
    8098:	e24bd004 	sub	sp, fp, #4
    809c:	e8bd8800 	pop	{fp, pc}

000080a0 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:11
	extern "C" int __cxa_guard_acquire (__guard *);
	extern "C" void __cxa_guard_release (__guard *);
	extern "C" void __cxa_guard_abort (__guard *);

	extern "C" int __cxa_guard_acquire (__guard *g)
	{
    80a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80a4:	e28db000 	add	fp, sp, #0
    80a8:	e24dd00c 	sub	sp, sp, #12
    80ac:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:12
		return !*(char *)(g);
    80b0:	e51b3008 	ldr	r3, [fp, #-8]
    80b4:	e5d33000 	ldrb	r3, [r3]
    80b8:	e3530000 	cmp	r3, #0
    80bc:	03a03001 	moveq	r3, #1
    80c0:	13a03000 	movne	r3, #0
    80c4:	e6ef3073 	uxtb	r3, r3
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:13
	}
    80c8:	e1a00003 	mov	r0, r3
    80cc:	e28bd000 	add	sp, fp, #0
    80d0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80d4:	e12fff1e 	bx	lr

000080d8 <__cxa_guard_release>:
__cxa_guard_release():
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:16

	extern "C" void __cxa_guard_release (__guard *g)
	{
    80d8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80dc:	e28db000 	add	fp, sp, #0
    80e0:	e24dd00c 	sub	sp, sp, #12
    80e4:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:17
		*(char *)g = 1;
    80e8:	e51b3008 	ldr	r3, [fp, #-8]
    80ec:	e3a02001 	mov	r2, #1
    80f0:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:18
	}
    80f4:	e320f000 	nop	{0}
    80f8:	e28bd000 	add	sp, fp, #0
    80fc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8100:	e12fff1e 	bx	lr

00008104 <__cxa_guard_abort>:
__cxa_guard_abort():
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:21

	extern "C" void __cxa_guard_abort (__guard *)
	{
    8104:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8108:	e28db000 	add	fp, sp, #0
    810c:	e24dd00c 	sub	sp, sp, #12
    8110:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:23

	}
    8114:	e320f000 	nop	{0}
    8118:	e28bd000 	add	sp, fp, #0
    811c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8120:	e12fff1e 	bx	lr

00008124 <__dso_handle>:
__dso_handle():
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:27
}

extern "C" void __dso_handle()
{
    8124:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8128:	e28db000 	add	fp, sp, #0
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:29
    // ignore dtors for now
}
    812c:	e320f000 	nop	{0}
    8130:	e28bd000 	add	sp, fp, #0
    8134:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8138:	e12fff1e 	bx	lr

0000813c <__cxa_atexit>:
__cxa_atexit():
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:32

extern "C" void __cxa_atexit()
{
    813c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8140:	e28db000 	add	fp, sp, #0
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:34
    // ignore dtors for now
}
    8144:	e320f000 	nop	{0}
    8148:	e28bd000 	add	sp, fp, #0
    814c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8150:	e12fff1e 	bx	lr

00008154 <__cxa_pure_virtual>:
__cxa_pure_virtual():
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:37

extern "C" void __cxa_pure_virtual()
{
    8154:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8158:	e28db000 	add	fp, sp, #0
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:39
    // pure virtual method called
}
    815c:	e320f000 	nop	{0}
    8160:	e28bd000 	add	sp, fp, #0
    8164:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8168:	e12fff1e 	bx	lr

0000816c <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:42

extern "C" void __aeabi_unwind_cpp_pr1()
{
    816c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8170:	e28db000 	add	fp, sp, #0
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:43 (discriminator 1)
	while (true)
    8174:	eafffffe 	b	8174 <__aeabi_unwind_cpp_pr1+0x8>

00008178 <_cpp_startup>:
_cpp_startup():
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:61
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _cpp_startup(void)
{
    8178:	e92d4800 	push	{fp, lr}
    817c:	e28db004 	add	fp, sp, #4
    8180:	e24dd008 	sub	sp, sp, #8
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:66
	ctor_ptr* fnptr;
	
	// zavolame konstruktory globalnich C++ trid
	// v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8184:	e59f303c 	ldr	r3, [pc, #60]	; 81c8 <_cpp_startup+0x50>
    8188:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:66 (discriminator 3)
    818c:	e51b3008 	ldr	r3, [fp, #-8]
    8190:	e59f2034 	ldr	r2, [pc, #52]	; 81cc <_cpp_startup+0x54>
    8194:	e1530002 	cmp	r3, r2
    8198:	2a000006 	bcs	81b8 <_cpp_startup+0x40>
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:67 (discriminator 2)
		(*fnptr)();
    819c:	e51b3008 	ldr	r3, [fp, #-8]
    81a0:	e5933000 	ldr	r3, [r3]
    81a4:	e12fff33 	blx	r3
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:66 (discriminator 2)
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    81a8:	e51b3008 	ldr	r3, [fp, #-8]
    81ac:	e2833004 	add	r3, r3, #4
    81b0:	e50b3008 	str	r3, [fp, #-8]
    81b4:	eafffff4 	b	818c <_cpp_startup+0x14>
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:69
	
	return 0;
    81b8:	e3a03000 	mov	r3, #0
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:70
}
    81bc:	e1a00003 	mov	r0, r3
    81c0:	e24bd004 	sub	sp, fp, #4
    81c4:	e8bd8800 	pop	{fp, pc}
    81c8:	00009ce8 	andeq	r9, r0, r8, ror #25
    81cc:	00009ce8 	andeq	r9, r0, r8, ror #25

000081d0 <_cpp_shutdown>:
_cpp_shutdown():
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:73

extern "C" int _cpp_shutdown(void)
{
    81d0:	e92d4800 	push	{fp, lr}
    81d4:	e28db004 	add	fp, sp, #4
    81d8:	e24dd008 	sub	sp, sp, #8
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:77
	dtor_ptr* fnptr;
	
	// zavolame destruktory globalnich C++ trid
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    81dc:	e59f303c 	ldr	r3, [pc, #60]	; 8220 <_cpp_shutdown+0x50>
    81e0:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:77 (discriminator 3)
    81e4:	e51b3008 	ldr	r3, [fp, #-8]
    81e8:	e59f2034 	ldr	r2, [pc, #52]	; 8224 <_cpp_shutdown+0x54>
    81ec:	e1530002 	cmp	r3, r2
    81f0:	2a000006 	bcs	8210 <_cpp_shutdown+0x40>
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:78 (discriminator 2)
		(*fnptr)();
    81f4:	e51b3008 	ldr	r3, [fp, #-8]
    81f8:	e5933000 	ldr	r3, [r3]
    81fc:	e12fff33 	blx	r3
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:77 (discriminator 2)
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    8200:	e51b3008 	ldr	r3, [fp, #-8]
    8204:	e2833004 	add	r3, r3, #4
    8208:	e50b3008 	str	r3, [fp, #-8]
    820c:	eafffff4 	b	81e4 <_cpp_shutdown+0x14>
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:80
	
	return 0;
    8210:	e3a03000 	mov	r3, #0
/home/hintik/dev/final/src/sources/userspace/cxxabi.cpp:81
}
    8214:	e1a00003 	mov	r0, r3
    8218:	e24bd004 	sub	sp, fp, #4
    821c:	e8bd8800 	pop	{fp, pc}
    8220:	00009ce8 	andeq	r9, r0, r8, ror #25
    8224:	00009ce8 	andeq	r9, r0, r8, ror #25

00008228 <main>:
main():
/home/hintik/dev/final/src/sources/userspace/init_task/main.cpp:6
#include <stdfile.h>

#include <process/process_manager.h>

int main(int argc, char** argv)
{
    8228:	e92d4800 	push	{fp, lr}
    822c:	e28db004 	add	fp, sp, #4
    8230:	e24dd008 	sub	sp, sp, #8
    8234:	e50b0008 	str	r0, [fp, #-8]
    8238:	e50b100c 	str	r1, [fp, #-12]
/home/hintik/dev/final/src/sources/userspace/init_task/main.cpp:11
	// systemovy init task startuje jako prvni, a ma nejnizsi prioritu ze vsech - bude se tedy planovat v podstate jen tehdy,
	// kdy nic jineho nikdo nema na praci

	// nastavime deadline na "nekonecno" = vlastne snizime dynamickou prioritu na nejnizsi moznou
	set_task_deadline(Indefinite);
    823c:	e3e00000 	mvn	r0, #0
    8240:	eb0000e2 	bl	85d0 <_Z17set_task_deadlinej>
/home/hintik/dev/final/src/sources/userspace/init_task/main.cpp:17
	// TODO: tady budeme chtit nechat spoustet zbytek procesu, az budeme umet nacitat treba z eMMC a SD karty
	
	while (true)
	{
		// kdyz je planovany jen tento proces, pockame na udalost (preruseni, ...)
		if (get_active_process_count() == 1)
    8244:	eb0000c3 	bl	8558 <_Z24get_active_process_countv>
    8248:	e1a03000 	mov	r3, r0
    824c:	e3530001 	cmp	r3, #1
    8250:	03a03001 	moveq	r3, #1
    8254:	13a03000 	movne	r3, #0
    8258:	e6ef3073 	uxtb	r3, r3
    825c:	e3530000 	cmp	r3, #0
    8260:	0a000000 	beq	8268 <main+0x40>
/home/hintik/dev/final/src/sources/userspace/init_task/main.cpp:18
			asm volatile("wfe");
    8264:	e320f002 	wfe
/home/hintik/dev/final/src/sources/userspace/init_task/main.cpp:21

		// predame zbytek casoveho kvanta dalsimu procesu
		sched_yield();
    8268:	eb000021 	bl	82f4 <_Z11sched_yieldv>
/home/hintik/dev/final/src/sources/userspace/init_task/main.cpp:17
		if (get_active_process_count() == 1)
    826c:	eafffff4 	b	8244 <main+0x1c>

00008270 <_Z6getpidv>:
_Z6getpidv():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8270:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8274:	e28db000 	add	fp, sp, #0
    8278:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    827c:	ef000000 	svc	0x00000000
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8280:	e1a03000 	mov	r3, r0
    8284:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:11

    return pid;
    8288:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:12
}
    828c:	e1a00003 	mov	r0, r3
    8290:	e28bd000 	add	sp, fp, #0
    8294:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8298:	e12fff1e 	bx	lr

0000829c <_Z17get_random_numberv>:
_Z17get_random_numberv():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:15

uint32_t get_random_number()
{
    829c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82a0:	e28db000 	add	fp, sp, #0
    82a4:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:18
    uint32_t rng;

    asm volatile("swi 7");
    82a8:	ef000007 	svc	0x00000007
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:19
    asm volatile("mov %0, r0" : "=r" (rng));
    82ac:	e1a03000 	mov	r3, r0
    82b0:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:21

    return rng;
    82b4:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:22
}
    82b8:	e1a00003 	mov	r0, r3
    82bc:	e28bd000 	add	sp, fp, #0
    82c0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82c4:	e12fff1e 	bx	lr

000082c8 <_Z9terminatei>:
_Z9terminatei():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:25

void terminate(int exitcode)
{
    82c8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82cc:	e28db000 	add	fp, sp, #0
    82d0:	e24dd00c 	sub	sp, sp, #12
    82d4:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:26
    asm volatile("mov r0, %0" : : "r" (exitcode));
    82d8:	e51b3008 	ldr	r3, [fp, #-8]
    82dc:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:27
    asm volatile("swi 1");
    82e0:	ef000001 	svc	0x00000001
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:28
}
    82e4:	e320f000 	nop	{0}
    82e8:	e28bd000 	add	sp, fp, #0
    82ec:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82f0:	e12fff1e 	bx	lr

000082f4 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:31

void sched_yield()
{
    82f4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82f8:	e28db000 	add	fp, sp, #0
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:32
    asm volatile("swi 2");
    82fc:	ef000002 	svc	0x00000002
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:33
}
    8300:	e320f000 	nop	{0}
    8304:	e28bd000 	add	sp, fp, #0
    8308:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    830c:	e12fff1e 	bx	lr

00008310 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:36

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    8310:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8314:	e28db000 	add	fp, sp, #0
    8318:	e24dd014 	sub	sp, sp, #20
    831c:	e50b0010 	str	r0, [fp, #-16]
    8320:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:39
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    8324:	e51b3010 	ldr	r3, [fp, #-16]
    8328:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:40
    asm volatile("mov r1, %0" : : "r" (mode));
    832c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8330:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:41
    asm volatile("swi 64");
    8334:	ef000040 	svc	0x00000040
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov %0, r0" : "=r" (file));
    8338:	e1a03000 	mov	r3, r0
    833c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:44

    return file;
    8340:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:45
}
    8344:	e1a00003 	mov	r0, r3
    8348:	e28bd000 	add	sp, fp, #0
    834c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8350:	e12fff1e 	bx	lr

00008354 <_Z4readjPcj>:
_Z4readjPcj():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:48

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    8354:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8358:	e28db000 	add	fp, sp, #0
    835c:	e24dd01c 	sub	sp, sp, #28
    8360:	e50b0010 	str	r0, [fp, #-16]
    8364:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8368:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:51
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    836c:	e51b3010 	ldr	r3, [fp, #-16]
    8370:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:52
    asm volatile("mov r1, %0" : : "r" (buffer));
    8374:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8378:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:53
    asm volatile("mov r2, %0" : : "r" (size));
    837c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8380:	e1a02003 	mov	r2, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:54
    asm volatile("swi 65");
    8384:	ef000041 	svc	0x00000041
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov %0, r0" : "=r" (rdnum));
    8388:	e1a03000 	mov	r3, r0
    838c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:57

    return rdnum;
    8390:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:58
}
    8394:	e1a00003 	mov	r0, r3
    8398:	e28bd000 	add	sp, fp, #0
    839c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83a0:	e12fff1e 	bx	lr

000083a4 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:61

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    83a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83a8:	e28db000 	add	fp, sp, #0
    83ac:	e24dd01c 	sub	sp, sp, #28
    83b0:	e50b0010 	str	r0, [fp, #-16]
    83b4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    83b8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:64
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    83bc:	e51b3010 	ldr	r3, [fp, #-16]
    83c0:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r1, %0" : : "r" (buffer));
    83c4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83c8:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:66
    asm volatile("mov r2, %0" : : "r" (size));
    83cc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83d0:	e1a02003 	mov	r2, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:67
    asm volatile("swi 66");
    83d4:	ef000042 	svc	0x00000042
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:68
    asm volatile("mov %0, r0" : "=r" (wrnum));
    83d8:	e1a03000 	mov	r3, r0
    83dc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:70

    return wrnum;
    83e0:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:71
}
    83e4:	e1a00003 	mov	r0, r3
    83e8:	e28bd000 	add	sp, fp, #0
    83ec:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83f0:	e12fff1e 	bx	lr

000083f4 <_Z5closej>:
_Z5closej():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:74

void close(uint32_t file)
{
    83f4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83f8:	e28db000 	add	fp, sp, #0
    83fc:	e24dd00c 	sub	sp, sp, #12
    8400:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r0, %0" : : "r" (file));
    8404:	e51b3008 	ldr	r3, [fp, #-8]
    8408:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 67");
    840c:	ef000043 	svc	0x00000043
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:77
}
    8410:	e320f000 	nop	{0}
    8414:	e28bd000 	add	sp, fp, #0
    8418:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    841c:	e12fff1e 	bx	lr

00008420 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:80

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    8420:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8424:	e28db000 	add	fp, sp, #0
    8428:	e24dd01c 	sub	sp, sp, #28
    842c:	e50b0010 	str	r0, [fp, #-16]
    8430:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8434:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:83
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8438:	e51b3010 	ldr	r3, [fp, #-16]
    843c:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:84
    asm volatile("mov r1, %0" : : "r" (operation));
    8440:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8444:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:85
    asm volatile("mov r2, %0" : : "r" (param));
    8448:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    844c:	e1a02003 	mov	r2, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:86
    asm volatile("swi 68");
    8450:	ef000044 	svc	0x00000044
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov %0, r0" : "=r" (retcode));
    8454:	e1a03000 	mov	r3, r0
    8458:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:89

    return retcode;
    845c:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:90
}
    8460:	e1a00003 	mov	r0, r3
    8464:	e28bd000 	add	sp, fp, #0
    8468:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    846c:	e12fff1e 	bx	lr

00008470 <_Z6notifyjj>:
_Z6notifyjj():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:93

uint32_t notify(uint32_t file, uint32_t count)
{
    8470:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8474:	e28db000 	add	fp, sp, #0
    8478:	e24dd014 	sub	sp, sp, #20
    847c:	e50b0010 	str	r0, [fp, #-16]
    8480:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:96
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    8484:	e51b3010 	ldr	r3, [fp, #-16]
    8488:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:97
    asm volatile("mov r1, %0" : : "r" (count));
    848c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8490:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:98
    asm volatile("swi 69");
    8494:	ef000045 	svc	0x00000045
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov %0, r0" : "=r" (retcnt));
    8498:	e1a03000 	mov	r3, r0
    849c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:101

    return retcnt;
    84a0:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:102
}
    84a4:	e1a00003 	mov	r0, r3
    84a8:	e28bd000 	add	sp, fp, #0
    84ac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84b0:	e12fff1e 	bx	lr

000084b4 <_Z4waitjjj>:
_Z4waitjjj():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:105

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    84b4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84b8:	e28db000 	add	fp, sp, #0
    84bc:	e24dd01c 	sub	sp, sp, #28
    84c0:	e50b0010 	str	r0, [fp, #-16]
    84c4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84c8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:108
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    84cc:	e51b3010 	ldr	r3, [fp, #-16]
    84d0:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:109
    asm volatile("mov r1, %0" : : "r" (count));
    84d4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84d8:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:110
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    84dc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84e0:	e1a02003 	mov	r2, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:111
    asm volatile("swi 70");
    84e4:	ef000046 	svc	0x00000046
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov %0, r0" : "=r" (retcode));
    84e8:	e1a03000 	mov	r3, r0
    84ec:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:114

    return retcode;
    84f0:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:115
}
    84f4:	e1a00003 	mov	r0, r3
    84f8:	e28bd000 	add	sp, fp, #0
    84fc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8500:	e12fff1e 	bx	lr

00008504 <_Z5sleepjj>:
_Z5sleepjj():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:118

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    8504:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8508:	e28db000 	add	fp, sp, #0
    850c:	e24dd014 	sub	sp, sp, #20
    8510:	e50b0010 	str	r0, [fp, #-16]
    8514:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:121
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    8518:	e51b3010 	ldr	r3, [fp, #-16]
    851c:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:122
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    8520:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8524:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:123
    asm volatile("swi 3");
    8528:	ef000003 	svc	0x00000003
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:124
    asm volatile("mov %0, r0" : "=r" (retcode));
    852c:	e1a03000 	mov	r3, r0
    8530:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:126

    return retcode;
    8534:	e51b3008 	ldr	r3, [fp, #-8]
    8538:	e3530000 	cmp	r3, #0
    853c:	13a03001 	movne	r3, #1
    8540:	03a03000 	moveq	r3, #0
    8544:	e6ef3073 	uxtb	r3, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:127
}
    8548:	e1a00003 	mov	r0, r3
    854c:	e28bd000 	add	sp, fp, #0
    8550:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8554:	e12fff1e 	bx	lr

00008558 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:130

uint32_t get_active_process_count()
{
    8558:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    855c:	e28db000 	add	fp, sp, #0
    8560:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:131
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    8564:	e3a03000 	mov	r3, #0
    8568:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:134
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    856c:	e3a03000 	mov	r3, #0
    8570:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:135
    asm volatile("mov r1, %0" : : "r" (&retval));
    8574:	e24b300c 	sub	r3, fp, #12
    8578:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:136
    asm volatile("swi 4");
    857c:	ef000004 	svc	0x00000004
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:138

    return retval;
    8580:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:139
}
    8584:	e1a00003 	mov	r0, r3
    8588:	e28bd000 	add	sp, fp, #0
    858c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8590:	e12fff1e 	bx	lr

00008594 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:142

uint32_t get_tick_count()
{
    8594:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8598:	e28db000 	add	fp, sp, #0
    859c:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:143
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    85a0:	e3a03001 	mov	r3, #1
    85a4:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:146
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    85a8:	e3a03001 	mov	r3, #1
    85ac:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:147
    asm volatile("mov r1, %0" : : "r" (&retval));
    85b0:	e24b300c 	sub	r3, fp, #12
    85b4:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:148
    asm volatile("swi 4");
    85b8:	ef000004 	svc	0x00000004
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:150

    return retval;
    85bc:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:151
}
    85c0:	e1a00003 	mov	r0, r3
    85c4:	e28bd000 	add	sp, fp, #0
    85c8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85cc:	e12fff1e 	bx	lr

000085d0 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:154

void set_task_deadline(uint32_t tick_count_required)
{
    85d0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85d4:	e28db000 	add	fp, sp, #0
    85d8:	e24dd014 	sub	sp, sp, #20
    85dc:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:155
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    85e0:	e3a03000 	mov	r3, #0
    85e4:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:157

    asm volatile("mov r0, %0" : : "r" (req));
    85e8:	e3a03000 	mov	r3, #0
    85ec:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    85f0:	e24b3010 	sub	r3, fp, #16
    85f4:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    85f8:	ef000005 	svc	0x00000005
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:160
}
    85fc:	e320f000 	nop	{0}
    8600:	e28bd000 	add	sp, fp, #0
    8604:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8608:	e12fff1e 	bx	lr

0000860c <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:163

uint32_t get_task_ticks_to_deadline()
{
    860c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8610:	e28db000 	add	fp, sp, #0
    8614:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:164
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    8618:	e3a03001 	mov	r3, #1
    861c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:167
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    8620:	e3a03001 	mov	r3, #1
    8624:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:168
    asm volatile("mov r1, %0" : : "r" (&ticks));
    8628:	e24b300c 	sub	r3, fp, #12
    862c:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:169
    asm volatile("swi 5");
    8630:	ef000005 	svc	0x00000005
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:171

    return ticks;
    8634:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:172
}
    8638:	e1a00003 	mov	r0, r3
    863c:	e28bd000 	add	sp, fp, #0
    8640:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8644:	e12fff1e 	bx	lr

00008648 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:177

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    8648:	e92d4800 	push	{fp, lr}
    864c:	e28db004 	add	fp, sp, #4
    8650:	e24dd050 	sub	sp, sp, #80	; 0x50
    8654:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    8658:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:179
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    865c:	e24b3048 	sub	r3, fp, #72	; 0x48
    8660:	e3a0200a 	mov	r2, #10
    8664:	e59f108c 	ldr	r1, [pc, #140]	; 86f8 <_Z4pipePKcj+0xb0>
    8668:	e1a00003 	mov	r0, r3
    866c:	eb000236 	bl	8f4c <_Z7strncpyPcPKci>
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:180
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    8670:	e24b3048 	sub	r3, fp, #72	; 0x48
    8674:	e283300a 	add	r3, r3, #10
    8678:	e3a02035 	mov	r2, #53	; 0x35
    867c:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    8680:	e1a00003 	mov	r0, r3
    8684:	eb000230 	bl	8f4c <_Z7strncpyPcPKci>
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:182

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8688:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    868c:	eb000289 	bl	90b8 <_Z6strlenPKc>
    8690:	e1a03000 	mov	r3, r0
    8694:	e283300a 	add	r3, r3, #10
    8698:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:184

    fname[ncur++] = '#';
    869c:	e51b3008 	ldr	r3, [fp, #-8]
    86a0:	e2832001 	add	r2, r3, #1
    86a4:	e50b2008 	str	r2, [fp, #-8]
    86a8:	e24b2004 	sub	r2, fp, #4
    86ac:	e0823003 	add	r3, r2, r3
    86b0:	e3a02023 	mov	r2, #35	; 0x23
    86b4:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:186

    itoa(buf_size, &fname[ncur], 10);
    86b8:	e24b2048 	sub	r2, fp, #72	; 0x48
    86bc:	e51b3008 	ldr	r3, [fp, #-8]
    86c0:	e0823003 	add	r3, r2, r3
    86c4:	e3a0200a 	mov	r2, #10
    86c8:	e1a01003 	mov	r1, r3
    86cc:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    86d0:	eb000199 	bl	8d3c <_Z4itoajPcj>
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:188

    return open(fname, NFile_Open_Mode::Read_Write);
    86d4:	e24b3048 	sub	r3, fp, #72	; 0x48
    86d8:	e3a01002 	mov	r1, #2
    86dc:	e1a00003 	mov	r0, r3
    86e0:	ebffff0a 	bl	8310 <_Z4openPKc15NFile_Open_Mode>
    86e4:	e1a03000 	mov	r3, r0
    86e8:	e320f000 	nop	{0}
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:189
}
    86ec:	e1a00003 	mov	r0, r3
    86f0:	e24bd004 	sub	sp, fp, #4
    86f4:	e8bd8800 	pop	{fp, pc}
    86f8:	00009cc0 	andeq	r9, r0, r0, asr #25
    86fc:	00000000 	andeq	r0, r0, r0

00008700 <_Z4n_tuii>:
_Z4n_tuii():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:7

namespace {
    const char CharConvArr[] = "0123456789ABCDEF";
}

int n_tu(int number, int count) {
    8700:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8704:	e28db000 	add	fp, sp, #0
    8708:	e24dd014 	sub	sp, sp, #20
    870c:	e50b0010 	str	r0, [fp, #-16]
    8710:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:8
    int result = 1;
    8714:	e3a03001 	mov	r3, #1
    8718:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:9
    while (count-- > 0)
    871c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8720:	e2432001 	sub	r2, r3, #1
    8724:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8728:	e3530000 	cmp	r3, #0
    872c:	c3a03001 	movgt	r3, #1
    8730:	d3a03000 	movle	r3, #0
    8734:	e6ef3073 	uxtb	r3, r3
    8738:	e3530000 	cmp	r3, #0
    873c:	0a000004 	beq	8754 <_Z4n_tuii+0x54>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:10
        result *= number;
    8740:	e51b3008 	ldr	r3, [fp, #-8]
    8744:	e51b2010 	ldr	r2, [fp, #-16]
    8748:	e0030392 	mul	r3, r2, r3
    874c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:9
    while (count-- > 0)
    8750:	eafffff1 	b	871c <_Z4n_tuii+0x1c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:12

    return result;
    8754:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:13
}
    8758:	e1a00003 	mov	r0, r3
    875c:	e28bd000 	add	sp, fp, #0
    8760:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8764:	e12fff1e 	bx	lr

00008768 <_Z4ftoafPc>:
_Z4ftoafPc():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:15

void ftoa(float f, char *r) {
    8768:	e92d4bf0 	push	{r4, r5, r6, r7, r8, r9, fp, lr}
    876c:	e28db01c 	add	fp, sp, #28
    8770:	e24dd060 	sub	sp, sp, #96	; 0x60
    8774:	ed0b0a16 	vstr	s0, [fp, #-88]	; 0xffffffa8
    8778:	e50b005c 	str	r0, [fp, #-92]	; 0xffffffa4
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:19
    long long int length, length2, i, number, position, sign;
    float number2;

    sign = -1;   // -1 == positive number
    877c:	e3e02000 	mvn	r2, #0
    8780:	e3e03000 	mvn	r3, #0
    8784:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:20
    if (f < 0) {
    8788:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    878c:	eef57ac0 	vcmpe.f32	s15, #0.0
    8790:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8794:	5a000005 	bpl	87b0 <_Z4ftoafPc+0x48>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:21
        sign = '-';
    8798:	e3a0202d 	mov	r2, #45	; 0x2d
    879c:	e3a03000 	mov	r3, #0
    87a0:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:22
        f *= -1;
    87a4:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    87a8:	eef17a67 	vneg.f32	s15, s15
    87ac:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:25
    }

    number2 = f;
    87b0:	e51b3058 	ldr	r3, [fp, #-88]	; 0xffffffa8
    87b4:	e50b3040 	str	r3, [fp, #-64]	; 0xffffffc0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:26
    number = f;
    87b8:	e51b0058 	ldr	r0, [fp, #-88]	; 0xffffffa8
    87bc:	eb0004c3 	bl	9ad0 <__aeabi_f2lz>
    87c0:	e1a02000 	mov	r2, r0
    87c4:	e1a03001 	mov	r3, r1
    87c8:	e14b23f4 	strd	r2, [fp, #-52]	; 0xffffffcc
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:27
    length = 0;  // Size of decimal part
    87cc:	e3a02000 	mov	r2, #0
    87d0:	e3a03000 	mov	r3, #0
    87d4:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:28
    length2 = 0; // Size of tenth
    87d8:	e3a02000 	mov	r2, #0
    87dc:	e3a03000 	mov	r3, #0
    87e0:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:31

    /* Calculate length2 tenth part */
    while ((number2 - (float) number) != 0.0 && !((number2 - (float) number) < 0.0)) {
    87e4:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    87e8:	eb000464 	bl	9980 <__aeabi_l2f>
    87ec:	ee070a10 	vmov	s14, r0
    87f0:	ed5b7a10 	vldr	s15, [fp, #-64]	; 0xffffffc0
    87f4:	ee777ac7 	vsub.f32	s15, s15, s14
    87f8:	eef57a40 	vcmp.f32	s15, #0.0
    87fc:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8800:	0a00001b 	beq	8874 <_Z4ftoafPc+0x10c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:31 (discriminator 1)
    8804:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    8808:	eb00045c 	bl	9980 <__aeabi_l2f>
    880c:	ee070a10 	vmov	s14, r0
    8810:	ed5b7a10 	vldr	s15, [fp, #-64]	; 0xffffffc0
    8814:	ee777ac7 	vsub.f32	s15, s15, s14
    8818:	eef57ac0 	vcmpe.f32	s15, #0.0
    881c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8820:	4a000013 	bmi	8874 <_Z4ftoafPc+0x10c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:32
        number2 = f * (n_tu(10.0, length2 + 1));
    8824:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    8828:	e2833001 	add	r3, r3, #1
    882c:	e1a01003 	mov	r1, r3
    8830:	e3a0000a 	mov	r0, #10
    8834:	ebffffb1 	bl	8700 <_Z4n_tuii>
    8838:	ee070a90 	vmov	s15, r0
    883c:	eef87ae7 	vcvt.f32.s32	s15, s15
    8840:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    8844:	ee677a27 	vmul.f32	s15, s14, s15
    8848:	ed4b7a10 	vstr	s15, [fp, #-64]	; 0xffffffc0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:33
        number = number2;
    884c:	e51b0040 	ldr	r0, [fp, #-64]	; 0xffffffc0
    8850:	eb00049e 	bl	9ad0 <__aeabi_f2lz>
    8854:	e1a02000 	mov	r2, r0
    8858:	e1a03001 	mov	r3, r1
    885c:	e14b23f4 	strd	r2, [fp, #-52]	; 0xffffffcc
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:35

        length2++;
    8860:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    8864:	e2926001 	adds	r6, r2, #1
    8868:	e2a37000 	adc	r7, r3, #0
    886c:	e14b62f4 	strd	r6, [fp, #-36]	; 0xffffffdc
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:31
    while ((number2 - (float) number) != 0.0 && !((number2 - (float) number) < 0.0)) {
    8870:	eaffffdb 	b	87e4 <_Z4ftoafPc+0x7c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:39
    }

    /* Calculate length decimal part */
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    8874:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    8878:	ed9f7a80 	vldr	s14, [pc, #512]	; 8a80 <_Z4ftoafPc+0x318>
    887c:	eef47ac7 	vcmpe.f32	s15, s14
    8880:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8884:	c3a03001 	movgt	r3, #1
    8888:	d3a03000 	movle	r3, #0
    888c:	e6ef3073 	uxtb	r3, r3
    8890:	e2233001 	eor	r3, r3, #1
    8894:	e6ef3073 	uxtb	r3, r3
    8898:	e6ef2073 	uxtb	r2, r3
    889c:	e3a03000 	mov	r3, #0
    88a0:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:39 (discriminator 3)
    88a4:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    88a8:	ed9f7a74 	vldr	s14, [pc, #464]	; 8a80 <_Z4ftoafPc+0x318>
    88ac:	eef47ac7 	vcmpe.f32	s15, s14
    88b0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    88b4:	da00000b 	ble	88e8 <_Z4ftoafPc+0x180>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:40 (discriminator 2)
        f /= 10;
    88b8:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    88bc:	eddf6a70 	vldr	s13, [pc, #448]	; 8a84 <_Z4ftoafPc+0x31c>
    88c0:	eec77a26 	vdiv.f32	s15, s14, s13
    88c4:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:39 (discriminator 2)
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    88c8:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    88cc:	e2921001 	adds	r1, r2, #1
    88d0:	e50b1064 	str	r1, [fp, #-100]	; 0xffffff9c
    88d4:	e2a33000 	adc	r3, r3, #0
    88d8:	e50b3060 	str	r3, [fp, #-96]	; 0xffffffa0
    88dc:	e14b26d4 	ldrd	r2, [fp, #-100]	; 0xffffff9c
    88e0:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
    88e4:	eaffffee 	b	88a4 <_Z4ftoafPc+0x13c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:42

    position = length;
    88e8:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    88ec:	e14b25f4 	strd	r2, [fp, #-84]	; 0xffffffac
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:43
    length = length + 1 + length2;
    88f0:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    88f4:	e2924001 	adds	r4, r2, #1
    88f8:	e2a35000 	adc	r5, r3, #0
    88fc:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    8900:	e0941002 	adds	r1, r4, r2
    8904:	e50b106c 	str	r1, [fp, #-108]	; 0xffffff94
    8908:	e0a53003 	adc	r3, r5, r3
    890c:	e50b3068 	str	r3, [fp, #-104]	; 0xffffff98
    8910:	e14b26dc 	ldrd	r2, [fp, #-108]	; 0xffffff94
    8914:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:44
    number = number2;
    8918:	e51b0040 	ldr	r0, [fp, #-64]	; 0xffffffc0
    891c:	eb00046b 	bl	9ad0 <__aeabi_f2lz>
    8920:	e1a02000 	mov	r2, r0
    8924:	e1a03001 	mov	r3, r1
    8928:	e14b23f4 	strd	r2, [fp, #-52]	; 0xffffffcc
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:45
    if (sign == '-') {
    892c:	e14b23dc 	ldrd	r2, [fp, #-60]	; 0xffffffc4
    8930:	e3530000 	cmp	r3, #0
    8934:	0352002d 	cmpeq	r2, #45	; 0x2d
    8938:	1a00000d 	bne	8974 <_Z4ftoafPc+0x20c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:46
        length++;
    893c:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    8940:	e2921001 	adds	r1, r2, #1
    8944:	e50b1074 	str	r1, [fp, #-116]	; 0xffffff8c
    8948:	e2a33000 	adc	r3, r3, #0
    894c:	e50b3070 	str	r3, [fp, #-112]	; 0xffffff90
    8950:	e14b27d4 	ldrd	r2, [fp, #-116]	; 0xffffff8c
    8954:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:47
        position++;
    8958:	e14b25d4 	ldrd	r2, [fp, #-84]	; 0xffffffac
    895c:	e2921001 	adds	r1, r2, #1
    8960:	e50b107c 	str	r1, [fp, #-124]	; 0xffffff84
    8964:	e2a33000 	adc	r3, r3, #0
    8968:	e50b3078 	str	r3, [fp, #-120]	; 0xffffff88
    896c:	e14b27dc 	ldrd	r2, [fp, #-124]	; 0xffffff84
    8970:	e14b25f4 	strd	r2, [fp, #-84]	; 0xffffffac
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:50
    }

    for (i = length; i >= 0; i--) {
    8974:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    8978:	e14b22fc 	strd	r2, [fp, #-44]	; 0xffffffd4
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:50 (discriminator 1)
    897c:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    8980:	e3520000 	cmp	r2, #0
    8984:	e2d33000 	sbcs	r3, r3, #0
    8988:	ba000039 	blt	8a74 <_Z4ftoafPc+0x30c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:51
        if (i == (length))
    898c:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    8990:	e14b02dc 	ldrd	r0, [fp, #-44]	; 0xffffffd4
    8994:	e1510003 	cmp	r1, r3
    8998:	01500002 	cmpeq	r0, r2
    899c:	1a000005 	bne	89b8 <_Z4ftoafPc+0x250>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:52
            r[i] = '\0';
    89a0:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    89a4:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    89a8:	e0823003 	add	r3, r2, r3
    89ac:	e3a02000 	mov	r2, #0
    89b0:	e5c32000 	strb	r2, [r3]
    89b4:	ea000029 	b	8a60 <_Z4ftoafPc+0x2f8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:53
        else if (i == (position))
    89b8:	e14b25d4 	ldrd	r2, [fp, #-84]	; 0xffffffac
    89bc:	e14b02dc 	ldrd	r0, [fp, #-44]	; 0xffffffd4
    89c0:	e1510003 	cmp	r1, r3
    89c4:	01500002 	cmpeq	r0, r2
    89c8:	1a000005 	bne	89e4 <_Z4ftoafPc+0x27c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:54
            r[i] = '.';
    89cc:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    89d0:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    89d4:	e0823003 	add	r3, r2, r3
    89d8:	e3a0202e 	mov	r2, #46	; 0x2e
    89dc:	e5c32000 	strb	r2, [r3]
    89e0:	ea00001e 	b	8a60 <_Z4ftoafPc+0x2f8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:55
        else if (sign == '-' && i == 0)
    89e4:	e14b23dc 	ldrd	r2, [fp, #-60]	; 0xffffffc4
    89e8:	e3530000 	cmp	r3, #0
    89ec:	0352002d 	cmpeq	r2, #45	; 0x2d
    89f0:	1a000008 	bne	8a18 <_Z4ftoafPc+0x2b0>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:55 (discriminator 1)
    89f4:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    89f8:	e1923003 	orrs	r3, r2, r3
    89fc:	1a000005 	bne	8a18 <_Z4ftoafPc+0x2b0>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:56
            r[i] = '-';
    8a00:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    8a04:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    8a08:	e0823003 	add	r3, r2, r3
    8a0c:	e3a0202d 	mov	r2, #45	; 0x2d
    8a10:	e5c32000 	strb	r2, [r3]
    8a14:	ea000011 	b	8a60 <_Z4ftoafPc+0x2f8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:58
        else {
            r[i] = (number % 10) + '0';
    8a18:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    8a1c:	e3a0200a 	mov	r2, #10
    8a20:	e3a03000 	mov	r3, #0
    8a24:	eb0003f4 	bl	99fc <__aeabi_ldivmod>
    8a28:	e6ef2072 	uxtb	r2, r2
    8a2c:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    8a30:	e51b105c 	ldr	r1, [fp, #-92]	; 0xffffffa4
    8a34:	e0813003 	add	r3, r1, r3
    8a38:	e2822030 	add	r2, r2, #48	; 0x30
    8a3c:	e6ef2072 	uxtb	r2, r2
    8a40:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:59
            number /= 10;
    8a44:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    8a48:	e3a0200a 	mov	r2, #10
    8a4c:	e3a03000 	mov	r3, #0
    8a50:	eb0003e9 	bl	99fc <__aeabi_ldivmod>
    8a54:	e1a02000 	mov	r2, r0
    8a58:	e1a03001 	mov	r3, r1
    8a5c:	e14b23f4 	strd	r2, [fp, #-52]	; 0xffffffcc
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:50 (discriminator 2)
    for (i = length; i >= 0; i--) {
    8a60:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    8a64:	e2528001 	subs	r8, r2, #1
    8a68:	e2c39000 	sbc	r9, r3, #0
    8a6c:	e14b82fc 	strd	r8, [fp, #-44]	; 0xffffffd4
    8a70:	eaffffc1 	b	897c <_Z4ftoafPc+0x214>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:62
        }
    }
}
    8a74:	e320f000 	nop	{0}
    8a78:	e24bd01c 	sub	sp, fp, #28
    8a7c:	e8bd8bf0 	pop	{r4, r5, r6, r7, r8, r9, fp, pc}
    8a80:	3f800000 	svccc	0x00800000
    8a84:	41200000 			; <UNDEFINED> instruction: 0x41200000

00008a88 <_Z4atofPKc>:
_Z4atofPKc():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:66

#define isdigit(c) (c >= '0' && c <= '9')

float atof(const char *s) {
    8a88:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a8c:	e28db000 	add	fp, sp, #0
    8a90:	e24dd024 	sub	sp, sp, #36	; 0x24
    8a94:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:67
    float a = 0.0;
    8a98:	e3a03000 	mov	r3, #0
    8a9c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:68
    int e = 0;
    8aa0:	e3a03000 	mov	r3, #0
    8aa4:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:70
    int c;
    while ((c = *s++) != '\0' && isdigit(c)) {
    8aa8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8aac:	e2832001 	add	r2, r3, #1
    8ab0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8ab4:	e5d33000 	ldrb	r3, [r3]
    8ab8:	e50b3010 	str	r3, [fp, #-16]
    8abc:	e51b3010 	ldr	r3, [fp, #-16]
    8ac0:	e3530000 	cmp	r3, #0
    8ac4:	0a000007 	beq	8ae8 <_Z4atofPKc+0x60>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:70 (discriminator 1)
    8ac8:	e51b3010 	ldr	r3, [fp, #-16]
    8acc:	e353002f 	cmp	r3, #47	; 0x2f
    8ad0:	da000004 	ble	8ae8 <_Z4atofPKc+0x60>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:70 (discriminator 3)
    8ad4:	e51b3010 	ldr	r3, [fp, #-16]
    8ad8:	e3530039 	cmp	r3, #57	; 0x39
    8adc:	ca000001 	bgt	8ae8 <_Z4atofPKc+0x60>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:70 (discriminator 5)
    8ae0:	e3a03001 	mov	r3, #1
    8ae4:	ea000000 	b	8aec <_Z4atofPKc+0x64>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:70 (discriminator 6)
    8ae8:	e3a03000 	mov	r3, #0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:70 (discriminator 8)
    8aec:	e3530000 	cmp	r3, #0
    8af0:	0a00000b 	beq	8b24 <_Z4atofPKc+0x9c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:71
        a = a * 10.0 + (c - '0');
    8af4:	ed5b7a02 	vldr	s15, [fp, #-8]
    8af8:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8afc:	ed9f6b89 	vldr	d6, [pc, #548]	; 8d28 <_Z4atofPKc+0x2a0>
    8b00:	ee276b06 	vmul.f64	d6, d7, d6
    8b04:	e51b3010 	ldr	r3, [fp, #-16]
    8b08:	e2433030 	sub	r3, r3, #48	; 0x30
    8b0c:	ee073a90 	vmov	s15, r3
    8b10:	eeb87be7 	vcvt.f64.s32	d7, s15
    8b14:	ee367b07 	vadd.f64	d7, d6, d7
    8b18:	eef77bc7 	vcvt.f32.f64	s15, d7
    8b1c:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:70
    while ((c = *s++) != '\0' && isdigit(c)) {
    8b20:	eaffffe0 	b	8aa8 <_Z4atofPKc+0x20>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:73
    }
    if (c == '.') {
    8b24:	e51b3010 	ldr	r3, [fp, #-16]
    8b28:	e353002e 	cmp	r3, #46	; 0x2e
    8b2c:	1a000021 	bne	8bb8 <_Z4atofPKc+0x130>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:74
        while ((c = *s++) != '\0' && isdigit(c)) {
    8b30:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8b34:	e2832001 	add	r2, r3, #1
    8b38:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8b3c:	e5d33000 	ldrb	r3, [r3]
    8b40:	e50b3010 	str	r3, [fp, #-16]
    8b44:	e51b3010 	ldr	r3, [fp, #-16]
    8b48:	e3530000 	cmp	r3, #0
    8b4c:	0a000007 	beq	8b70 <_Z4atofPKc+0xe8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:74 (discriminator 1)
    8b50:	e51b3010 	ldr	r3, [fp, #-16]
    8b54:	e353002f 	cmp	r3, #47	; 0x2f
    8b58:	da000004 	ble	8b70 <_Z4atofPKc+0xe8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:74 (discriminator 3)
    8b5c:	e51b3010 	ldr	r3, [fp, #-16]
    8b60:	e3530039 	cmp	r3, #57	; 0x39
    8b64:	ca000001 	bgt	8b70 <_Z4atofPKc+0xe8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:74 (discriminator 5)
    8b68:	e3a03001 	mov	r3, #1
    8b6c:	ea000000 	b	8b74 <_Z4atofPKc+0xec>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:74 (discriminator 6)
    8b70:	e3a03000 	mov	r3, #0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:74 (discriminator 8)
    8b74:	e3530000 	cmp	r3, #0
    8b78:	0a00000e 	beq	8bb8 <_Z4atofPKc+0x130>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:75
            a = a * 10.0 + (c - '0');
    8b7c:	ed5b7a02 	vldr	s15, [fp, #-8]
    8b80:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8b84:	ed9f6b67 	vldr	d6, [pc, #412]	; 8d28 <_Z4atofPKc+0x2a0>
    8b88:	ee276b06 	vmul.f64	d6, d7, d6
    8b8c:	e51b3010 	ldr	r3, [fp, #-16]
    8b90:	e2433030 	sub	r3, r3, #48	; 0x30
    8b94:	ee073a90 	vmov	s15, r3
    8b98:	eeb87be7 	vcvt.f64.s32	d7, s15
    8b9c:	ee367b07 	vadd.f64	d7, d6, d7
    8ba0:	eef77bc7 	vcvt.f32.f64	s15, d7
    8ba4:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:76
            e = e - 1;
    8ba8:	e51b300c 	ldr	r3, [fp, #-12]
    8bac:	e2433001 	sub	r3, r3, #1
    8bb0:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:74
        while ((c = *s++) != '\0' && isdigit(c)) {
    8bb4:	eaffffdd 	b	8b30 <_Z4atofPKc+0xa8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:79
        }
    }
    if (c == 'e' || c == 'E') {
    8bb8:	e51b3010 	ldr	r3, [fp, #-16]
    8bbc:	e3530065 	cmp	r3, #101	; 0x65
    8bc0:	0a000002 	beq	8bd0 <_Z4atofPKc+0x148>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:79 (discriminator 1)
    8bc4:	e51b3010 	ldr	r3, [fp, #-16]
    8bc8:	e3530045 	cmp	r3, #69	; 0x45
    8bcc:	1a000037 	bne	8cb0 <_Z4atofPKc+0x228>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:80
        int sign = 1;
    8bd0:	e3a03001 	mov	r3, #1
    8bd4:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:81
        int i = 0;
    8bd8:	e3a03000 	mov	r3, #0
    8bdc:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:82
        c = *s++;
    8be0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8be4:	e2832001 	add	r2, r3, #1
    8be8:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8bec:	e5d33000 	ldrb	r3, [r3]
    8bf0:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:83
        if (c == '+')
    8bf4:	e51b3010 	ldr	r3, [fp, #-16]
    8bf8:	e353002b 	cmp	r3, #43	; 0x2b
    8bfc:	1a000005 	bne	8c18 <_Z4atofPKc+0x190>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:84
            c = *s++;
    8c00:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c04:	e2832001 	add	r2, r3, #1
    8c08:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8c0c:	e5d33000 	ldrb	r3, [r3]
    8c10:	e50b3010 	str	r3, [fp, #-16]
    8c14:	ea000009 	b	8c40 <_Z4atofPKc+0x1b8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:85
        else if (c == '-') {
    8c18:	e51b3010 	ldr	r3, [fp, #-16]
    8c1c:	e353002d 	cmp	r3, #45	; 0x2d
    8c20:	1a000006 	bne	8c40 <_Z4atofPKc+0x1b8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:86
            c = *s++;
    8c24:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c28:	e2832001 	add	r2, r3, #1
    8c2c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8c30:	e5d33000 	ldrb	r3, [r3]
    8c34:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:87
            sign = -1;
    8c38:	e3e03000 	mvn	r3, #0
    8c3c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:89
        }
        while (isdigit(c)) {
    8c40:	e51b3010 	ldr	r3, [fp, #-16]
    8c44:	e353002f 	cmp	r3, #47	; 0x2f
    8c48:	da000012 	ble	8c98 <_Z4atofPKc+0x210>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:89 (discriminator 1)
    8c4c:	e51b3010 	ldr	r3, [fp, #-16]
    8c50:	e3530039 	cmp	r3, #57	; 0x39
    8c54:	ca00000f 	bgt	8c98 <_Z4atofPKc+0x210>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:90
            i = i * 10 + (c - '0');
    8c58:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8c5c:	e1a03002 	mov	r3, r2
    8c60:	e1a03103 	lsl	r3, r3, #2
    8c64:	e0833002 	add	r3, r3, r2
    8c68:	e1a03083 	lsl	r3, r3, #1
    8c6c:	e1a02003 	mov	r2, r3
    8c70:	e51b3010 	ldr	r3, [fp, #-16]
    8c74:	e2433030 	sub	r3, r3, #48	; 0x30
    8c78:	e0823003 	add	r3, r2, r3
    8c7c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:91
            c = *s++;
    8c80:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c84:	e2832001 	add	r2, r3, #1
    8c88:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8c8c:	e5d33000 	ldrb	r3, [r3]
    8c90:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:89
        while (isdigit(c)) {
    8c94:	eaffffe9 	b	8c40 <_Z4atofPKc+0x1b8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:93
        }
        e += i * sign;
    8c98:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8c9c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8ca0:	e0030392 	mul	r3, r2, r3
    8ca4:	e51b200c 	ldr	r2, [fp, #-12]
    8ca8:	e0823003 	add	r3, r2, r3
    8cac:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:95
    }
    while (e > 0) {
    8cb0:	e51b300c 	ldr	r3, [fp, #-12]
    8cb4:	e3530000 	cmp	r3, #0
    8cb8:	da000007 	ble	8cdc <_Z4atofPKc+0x254>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:96
        a *= 10.0;
    8cbc:	ed5b7a02 	vldr	s15, [fp, #-8]
    8cc0:	ed9f7a1c 	vldr	s14, [pc, #112]	; 8d38 <_Z4atofPKc+0x2b0>
    8cc4:	ee677a87 	vmul.f32	s15, s15, s14
    8cc8:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:97
        e--;
    8ccc:	e51b300c 	ldr	r3, [fp, #-12]
    8cd0:	e2433001 	sub	r3, r3, #1
    8cd4:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:95
    while (e > 0) {
    8cd8:	eafffff4 	b	8cb0 <_Z4atofPKc+0x228>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:99
    }
    while (e < 0) {
    8cdc:	e51b300c 	ldr	r3, [fp, #-12]
    8ce0:	e3530000 	cmp	r3, #0
    8ce4:	aa000009 	bge	8d10 <_Z4atofPKc+0x288>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:100
        a *= 0.1;
    8ce8:	ed5b7a02 	vldr	s15, [fp, #-8]
    8cec:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8cf0:	ed9f6b0e 	vldr	d6, [pc, #56]	; 8d30 <_Z4atofPKc+0x2a8>
    8cf4:	ee277b06 	vmul.f64	d7, d7, d6
    8cf8:	eef77bc7 	vcvt.f32.f64	s15, d7
    8cfc:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:101
        e++;
    8d00:	e51b300c 	ldr	r3, [fp, #-12]
    8d04:	e2833001 	add	r3, r3, #1
    8d08:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:99
    while (e < 0) {
    8d0c:	eafffff2 	b	8cdc <_Z4atofPKc+0x254>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:103
    }
    return a;
    8d10:	e51b3008 	ldr	r3, [fp, #-8]
    8d14:	ee073a90 	vmov	s15, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:104
}
    8d18:	eeb00a67 	vmov.f32	s0, s15
    8d1c:	e28bd000 	add	sp, fp, #0
    8d20:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d24:	e12fff1e 	bx	lr
    8d28:	00000000 	andeq	r0, r0, r0
    8d2c:	40240000 	eormi	r0, r4, r0
    8d30:	9999999a 	ldmibls	r9, {r1, r3, r4, r7, r8, fp, ip, pc}
    8d34:	3fb99999 	svccc	0x00b99999
    8d38:	41200000 			; <UNDEFINED> instruction: 0x41200000

00008d3c <_Z4itoajPcj>:
_Z4itoajPcj():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:106

void itoa(unsigned int input, char *output, unsigned int base) {
    8d3c:	e92d4800 	push	{fp, lr}
    8d40:	e28db004 	add	fp, sp, #4
    8d44:	e24dd020 	sub	sp, sp, #32
    8d48:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8d4c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8d50:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:107
    int i = 0;
    8d54:	e3a03000 	mov	r3, #0
    8d58:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:109

    while (input > 0) {
    8d5c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8d60:	e3530000 	cmp	r3, #0
    8d64:	0a000014 	beq	8dbc <_Z4itoajPcj+0x80>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:110
        output[i] = CharConvArr[input % base];
    8d68:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8d6c:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8d70:	e1a00003 	mov	r0, r3
    8d74:	eb000283 	bl	9788 <__aeabi_uidivmod>
    8d78:	e1a03001 	mov	r3, r1
    8d7c:	e1a01003 	mov	r1, r3
    8d80:	e51b3008 	ldr	r3, [fp, #-8]
    8d84:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8d88:	e0823003 	add	r3, r2, r3
    8d8c:	e59f2118 	ldr	r2, [pc, #280]	; 8eac <_Z4itoajPcj+0x170>
    8d90:	e7d22001 	ldrb	r2, [r2, r1]
    8d94:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:111
        input /= base;
    8d98:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8d9c:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8da0:	eb0001fd 	bl	959c <__udivsi3>
    8da4:	e1a03000 	mov	r3, r0
    8da8:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:112
        i++;
    8dac:	e51b3008 	ldr	r3, [fp, #-8]
    8db0:	e2833001 	add	r3, r3, #1
    8db4:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:109
    while (input > 0) {
    8db8:	eaffffe7 	b	8d5c <_Z4itoajPcj+0x20>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:115
    }

    if (i == 0) {
    8dbc:	e51b3008 	ldr	r3, [fp, #-8]
    8dc0:	e3530000 	cmp	r3, #0
    8dc4:	1a000007 	bne	8de8 <_Z4itoajPcj+0xac>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:116
        output[i] = CharConvArr[0];
    8dc8:	e51b3008 	ldr	r3, [fp, #-8]
    8dcc:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8dd0:	e0823003 	add	r3, r2, r3
    8dd4:	e3a02030 	mov	r2, #48	; 0x30
    8dd8:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:117
        i++;
    8ddc:	e51b3008 	ldr	r3, [fp, #-8]
    8de0:	e2833001 	add	r3, r3, #1
    8de4:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:120
    }

    output[i] = '\0';
    8de8:	e51b3008 	ldr	r3, [fp, #-8]
    8dec:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8df0:	e0823003 	add	r3, r2, r3
    8df4:	e3a02000 	mov	r2, #0
    8df8:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:121
    i--;
    8dfc:	e51b3008 	ldr	r3, [fp, #-8]
    8e00:	e2433001 	sub	r3, r3, #1
    8e04:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:123

    for (int j = 0; j <= i / 2; j++) {
    8e08:	e3a03000 	mov	r3, #0
    8e0c:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:123 (discriminator 3)
    8e10:	e51b3008 	ldr	r3, [fp, #-8]
    8e14:	e1a02fa3 	lsr	r2, r3, #31
    8e18:	e0823003 	add	r3, r2, r3
    8e1c:	e1a030c3 	asr	r3, r3, #1
    8e20:	e1a02003 	mov	r2, r3
    8e24:	e51b300c 	ldr	r3, [fp, #-12]
    8e28:	e1530002 	cmp	r3, r2
    8e2c:	ca00001b 	bgt	8ea0 <_Z4itoajPcj+0x164>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:124 (discriminator 2)
        char c = output[i - j];
    8e30:	e51b2008 	ldr	r2, [fp, #-8]
    8e34:	e51b300c 	ldr	r3, [fp, #-12]
    8e38:	e0423003 	sub	r3, r2, r3
    8e3c:	e1a02003 	mov	r2, r3
    8e40:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e44:	e0833002 	add	r3, r3, r2
    8e48:	e5d33000 	ldrb	r3, [r3]
    8e4c:	e54b300d 	strb	r3, [fp, #-13]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:125 (discriminator 2)
        output[i - j] = output[j];
    8e50:	e51b300c 	ldr	r3, [fp, #-12]
    8e54:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8e58:	e0822003 	add	r2, r2, r3
    8e5c:	e51b1008 	ldr	r1, [fp, #-8]
    8e60:	e51b300c 	ldr	r3, [fp, #-12]
    8e64:	e0413003 	sub	r3, r1, r3
    8e68:	e1a01003 	mov	r1, r3
    8e6c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8e70:	e0833001 	add	r3, r3, r1
    8e74:	e5d22000 	ldrb	r2, [r2]
    8e78:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:126 (discriminator 2)
        output[j] = c;
    8e7c:	e51b300c 	ldr	r3, [fp, #-12]
    8e80:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8e84:	e0823003 	add	r3, r2, r3
    8e88:	e55b200d 	ldrb	r2, [fp, #-13]
    8e8c:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:123 (discriminator 2)
    for (int j = 0; j <= i / 2; j++) {
    8e90:	e51b300c 	ldr	r3, [fp, #-12]
    8e94:	e2833001 	add	r3, r3, #1
    8e98:	e50b300c 	str	r3, [fp, #-12]
    8e9c:	eaffffdb 	b	8e10 <_Z4itoajPcj+0xd4>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:128
    }
}
    8ea0:	e320f000 	nop	{0}
    8ea4:	e24bd004 	sub	sp, fp, #4
    8ea8:	e8bd8800 	pop	{fp, pc}
    8eac:	00009ccc 	andeq	r9, r0, ip, asr #25

00008eb0 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:130

int atoi(const char *input) {
    8eb0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8eb4:	e28db000 	add	fp, sp, #0
    8eb8:	e24dd014 	sub	sp, sp, #20
    8ebc:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:131
    int output = 0;
    8ec0:	e3a03000 	mov	r3, #0
    8ec4:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:133

    while (*input != '\0') {
    8ec8:	e51b3010 	ldr	r3, [fp, #-16]
    8ecc:	e5d33000 	ldrb	r3, [r3]
    8ed0:	e3530000 	cmp	r3, #0
    8ed4:	0a000017 	beq	8f38 <_Z4atoiPKc+0x88>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:134
        output *= 10;
    8ed8:	e51b2008 	ldr	r2, [fp, #-8]
    8edc:	e1a03002 	mov	r3, r2
    8ee0:	e1a03103 	lsl	r3, r3, #2
    8ee4:	e0833002 	add	r3, r3, r2
    8ee8:	e1a03083 	lsl	r3, r3, #1
    8eec:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:135
        if (*input > '9' || *input < '0')
    8ef0:	e51b3010 	ldr	r3, [fp, #-16]
    8ef4:	e5d33000 	ldrb	r3, [r3]
    8ef8:	e3530039 	cmp	r3, #57	; 0x39
    8efc:	8a00000d 	bhi	8f38 <_Z4atoiPKc+0x88>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:135 (discriminator 1)
    8f00:	e51b3010 	ldr	r3, [fp, #-16]
    8f04:	e5d33000 	ldrb	r3, [r3]
    8f08:	e353002f 	cmp	r3, #47	; 0x2f
    8f0c:	9a000009 	bls	8f38 <_Z4atoiPKc+0x88>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:138
            break;

        output += *input - '0';
    8f10:	e51b3010 	ldr	r3, [fp, #-16]
    8f14:	e5d33000 	ldrb	r3, [r3]
    8f18:	e2433030 	sub	r3, r3, #48	; 0x30
    8f1c:	e51b2008 	ldr	r2, [fp, #-8]
    8f20:	e0823003 	add	r3, r2, r3
    8f24:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:140

        input++;
    8f28:	e51b3010 	ldr	r3, [fp, #-16]
    8f2c:	e2833001 	add	r3, r3, #1
    8f30:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:133
    while (*input != '\0') {
    8f34:	eaffffe3 	b	8ec8 <_Z4atoiPKc+0x18>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:143
    }

    return output;
    8f38:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:144
}
    8f3c:	e1a00003 	mov	r0, r3
    8f40:	e28bd000 	add	sp, fp, #0
    8f44:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8f48:	e12fff1e 	bx	lr

00008f4c <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:146

char *strncpy(char *dest, const char *src, int num) {
    8f4c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8f50:	e28db000 	add	fp, sp, #0
    8f54:	e24dd01c 	sub	sp, sp, #28
    8f58:	e50b0010 	str	r0, [fp, #-16]
    8f5c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8f60:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:149
    int i;

    for (i = 0; i < num && src[i] != '\0'; i++)
    8f64:	e3a03000 	mov	r3, #0
    8f68:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:149 (discriminator 4)
    8f6c:	e51b2008 	ldr	r2, [fp, #-8]
    8f70:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8f74:	e1520003 	cmp	r2, r3
    8f78:	aa000011 	bge	8fc4 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:149 (discriminator 2)
    8f7c:	e51b3008 	ldr	r3, [fp, #-8]
    8f80:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8f84:	e0823003 	add	r3, r2, r3
    8f88:	e5d33000 	ldrb	r3, [r3]
    8f8c:	e3530000 	cmp	r3, #0
    8f90:	0a00000b 	beq	8fc4 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:150 (discriminator 3)
        dest[i] = src[i];
    8f94:	e51b3008 	ldr	r3, [fp, #-8]
    8f98:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8f9c:	e0822003 	add	r2, r2, r3
    8fa0:	e51b3008 	ldr	r3, [fp, #-8]
    8fa4:	e51b1010 	ldr	r1, [fp, #-16]
    8fa8:	e0813003 	add	r3, r1, r3
    8fac:	e5d22000 	ldrb	r2, [r2]
    8fb0:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:149 (discriminator 3)
    for (i = 0; i < num && src[i] != '\0'; i++)
    8fb4:	e51b3008 	ldr	r3, [fp, #-8]
    8fb8:	e2833001 	add	r3, r3, #1
    8fbc:	e50b3008 	str	r3, [fp, #-8]
    8fc0:	eaffffe9 	b	8f6c <_Z7strncpyPcPKci+0x20>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:151 (discriminator 2)
    for (; i < num; i++)
    8fc4:	e51b2008 	ldr	r2, [fp, #-8]
    8fc8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8fcc:	e1520003 	cmp	r2, r3
    8fd0:	aa000008 	bge	8ff8 <_Z7strncpyPcPKci+0xac>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:152 (discriminator 1)
        dest[i] = '\0';
    8fd4:	e51b3008 	ldr	r3, [fp, #-8]
    8fd8:	e51b2010 	ldr	r2, [fp, #-16]
    8fdc:	e0823003 	add	r3, r2, r3
    8fe0:	e3a02000 	mov	r2, #0
    8fe4:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:151 (discriminator 1)
    for (; i < num; i++)
    8fe8:	e51b3008 	ldr	r3, [fp, #-8]
    8fec:	e2833001 	add	r3, r3, #1
    8ff0:	e50b3008 	str	r3, [fp, #-8]
    8ff4:	eafffff2 	b	8fc4 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:154

    return dest;
    8ff8:	e51b3010 	ldr	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:155
}
    8ffc:	e1a00003 	mov	r0, r3
    9000:	e28bd000 	add	sp, fp, #0
    9004:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9008:	e12fff1e 	bx	lr

0000900c <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:157

int strncmp(const char *s1, const char *s2, int num) {
    900c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9010:	e28db000 	add	fp, sp, #0
    9014:	e24dd01c 	sub	sp, sp, #28
    9018:	e50b0010 	str	r0, [fp, #-16]
    901c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9020:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:159
    unsigned char u1, u2;
    while (num-- > 0) {
    9024:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9028:	e2432001 	sub	r2, r3, #1
    902c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    9030:	e3530000 	cmp	r3, #0
    9034:	c3a03001 	movgt	r3, #1
    9038:	d3a03000 	movle	r3, #0
    903c:	e6ef3073 	uxtb	r3, r3
    9040:	e3530000 	cmp	r3, #0
    9044:	0a000016 	beq	90a4 <_Z7strncmpPKcS0_i+0x98>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:160
        u1 = (unsigned char) *s1++;
    9048:	e51b3010 	ldr	r3, [fp, #-16]
    904c:	e2832001 	add	r2, r3, #1
    9050:	e50b2010 	str	r2, [fp, #-16]
    9054:	e5d33000 	ldrb	r3, [r3]
    9058:	e54b3005 	strb	r3, [fp, #-5]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:161
        u2 = (unsigned char) *s2++;
    905c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9060:	e2832001 	add	r2, r3, #1
    9064:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    9068:	e5d33000 	ldrb	r3, [r3]
    906c:	e54b3006 	strb	r3, [fp, #-6]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:162
        if (u1 != u2)
    9070:	e55b2005 	ldrb	r2, [fp, #-5]
    9074:	e55b3006 	ldrb	r3, [fp, #-6]
    9078:	e1520003 	cmp	r2, r3
    907c:	0a000003 	beq	9090 <_Z7strncmpPKcS0_i+0x84>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:163
            return u1 - u2;
    9080:	e55b2005 	ldrb	r2, [fp, #-5]
    9084:	e55b3006 	ldrb	r3, [fp, #-6]
    9088:	e0423003 	sub	r3, r2, r3
    908c:	ea000005 	b	90a8 <_Z7strncmpPKcS0_i+0x9c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:164
        if (u1 == '\0')
    9090:	e55b3005 	ldrb	r3, [fp, #-5]
    9094:	e3530000 	cmp	r3, #0
    9098:	1affffe1 	bne	9024 <_Z7strncmpPKcS0_i+0x18>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:165
            return 0;
    909c:	e3a03000 	mov	r3, #0
    90a0:	ea000000 	b	90a8 <_Z7strncmpPKcS0_i+0x9c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:168
    }

    return 0;
    90a4:	e3a03000 	mov	r3, #0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:169
}
    90a8:	e1a00003 	mov	r0, r3
    90ac:	e28bd000 	add	sp, fp, #0
    90b0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    90b4:	e12fff1e 	bx	lr

000090b8 <_Z6strlenPKc>:
_Z6strlenPKc():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:171

int strlen(const char *s) {
    90b8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    90bc:	e28db000 	add	fp, sp, #0
    90c0:	e24dd014 	sub	sp, sp, #20
    90c4:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:172
    int i = 0;
    90c8:	e3a03000 	mov	r3, #0
    90cc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:174

    while (s[i] != '\0')
    90d0:	e51b3008 	ldr	r3, [fp, #-8]
    90d4:	e51b2010 	ldr	r2, [fp, #-16]
    90d8:	e0823003 	add	r3, r2, r3
    90dc:	e5d33000 	ldrb	r3, [r3]
    90e0:	e3530000 	cmp	r3, #0
    90e4:	0a000003 	beq	90f8 <_Z6strlenPKc+0x40>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:175
        i++;
    90e8:	e51b3008 	ldr	r3, [fp, #-8]
    90ec:	e2833001 	add	r3, r3, #1
    90f0:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:174
    while (s[i] != '\0')
    90f4:	eafffff5 	b	90d0 <_Z6strlenPKc+0x18>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:177

    return i;
    90f8:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:178
}
    90fc:	e1a00003 	mov	r0, r3
    9100:	e28bd000 	add	sp, fp, #0
    9104:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9108:	e12fff1e 	bx	lr

0000910c <_Z9constainsPKcc>:
_Z9constainsPKcc():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:180

bool constains(const char *source, const char target) {
    910c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9110:	e28db000 	add	fp, sp, #0
    9114:	e24dd014 	sub	sp, sp, #20
    9118:	e50b0010 	str	r0, [fp, #-16]
    911c:	e1a03001 	mov	r3, r1
    9120:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:181
    int i = 0;
    9124:	e3a03000 	mov	r3, #0
    9128:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:183

    while (source[i] != '\0') {
    912c:	e51b3008 	ldr	r3, [fp, #-8]
    9130:	e51b2010 	ldr	r2, [fp, #-16]
    9134:	e0823003 	add	r3, r2, r3
    9138:	e5d33000 	ldrb	r3, [r3]
    913c:	e3530000 	cmp	r3, #0
    9140:	0a00000c 	beq	9178 <_Z9constainsPKcc+0x6c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:184
        if (source[i] == target)
    9144:	e51b3008 	ldr	r3, [fp, #-8]
    9148:	e51b2010 	ldr	r2, [fp, #-16]
    914c:	e0823003 	add	r3, r2, r3
    9150:	e5d33000 	ldrb	r3, [r3]
    9154:	e55b2011 	ldrb	r2, [fp, #-17]	; 0xffffffef
    9158:	e1520003 	cmp	r2, r3
    915c:	1a000001 	bne	9168 <_Z9constainsPKcc+0x5c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:185
            return true;
    9160:	e3a03001 	mov	r3, #1
    9164:	ea000004 	b	917c <_Z9constainsPKcc+0x70>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:186
        i++;
    9168:	e51b3008 	ldr	r3, [fp, #-8]
    916c:	e2833001 	add	r3, r3, #1
    9170:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:183
    while (source[i] != '\0') {
    9174:	eaffffec 	b	912c <_Z9constainsPKcc+0x20>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:188
    }
    return false;
    9178:	e3a03000 	mov	r3, #0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:189
}
    917c:	e1a00003 	mov	r0, r3
    9180:	e28bd000 	add	sp, fp, #0
    9184:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9188:	e12fff1e 	bx	lr

0000918c <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:191

void bzero(void *memory, int length) {
    918c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9190:	e28db000 	add	fp, sp, #0
    9194:	e24dd014 	sub	sp, sp, #20
    9198:	e50b0010 	str	r0, [fp, #-16]
    919c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:192
    char *mem = reinterpret_cast<char *>(memory);
    91a0:	e51b3010 	ldr	r3, [fp, #-16]
    91a4:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:194

    for (int i = 0; i < length; i++)
    91a8:	e3a03000 	mov	r3, #0
    91ac:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:194 (discriminator 3)
    91b0:	e51b2008 	ldr	r2, [fp, #-8]
    91b4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    91b8:	e1520003 	cmp	r2, r3
    91bc:	aa000008 	bge	91e4 <_Z5bzeroPvi+0x58>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:195 (discriminator 2)
        mem[i] = 0;
    91c0:	e51b3008 	ldr	r3, [fp, #-8]
    91c4:	e51b200c 	ldr	r2, [fp, #-12]
    91c8:	e0823003 	add	r3, r2, r3
    91cc:	e3a02000 	mov	r2, #0
    91d0:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:194 (discriminator 2)
    for (int i = 0; i < length; i++)
    91d4:	e51b3008 	ldr	r3, [fp, #-8]
    91d8:	e2833001 	add	r3, r3, #1
    91dc:	e50b3008 	str	r3, [fp, #-8]
    91e0:	eafffff2 	b	91b0 <_Z5bzeroPvi+0x24>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:196
}
    91e4:	e320f000 	nop	{0}
    91e8:	e28bd000 	add	sp, fp, #0
    91ec:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    91f0:	e12fff1e 	bx	lr

000091f4 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:198

void memcpy(const void *src, void *dst, int num) {
    91f4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    91f8:	e28db000 	add	fp, sp, #0
    91fc:	e24dd024 	sub	sp, sp, #36	; 0x24
    9200:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    9204:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    9208:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:199
    const char *memsrc = reinterpret_cast<const char *>(src);
    920c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9210:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:200
    char *memdst = reinterpret_cast<char *>(dst);
    9214:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9218:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:202

    for (int i = 0; i < num; i++)
    921c:	e3a03000 	mov	r3, #0
    9220:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:202 (discriminator 3)
    9224:	e51b2008 	ldr	r2, [fp, #-8]
    9228:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    922c:	e1520003 	cmp	r2, r3
    9230:	aa00000b 	bge	9264 <_Z6memcpyPKvPvi+0x70>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:203 (discriminator 2)
        memdst[i] = memsrc[i];
    9234:	e51b3008 	ldr	r3, [fp, #-8]
    9238:	e51b200c 	ldr	r2, [fp, #-12]
    923c:	e0822003 	add	r2, r2, r3
    9240:	e51b3008 	ldr	r3, [fp, #-8]
    9244:	e51b1010 	ldr	r1, [fp, #-16]
    9248:	e0813003 	add	r3, r1, r3
    924c:	e5d22000 	ldrb	r2, [r2]
    9250:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:202 (discriminator 2)
    for (int i = 0; i < num; i++)
    9254:	e51b3008 	ldr	r3, [fp, #-8]
    9258:	e2833001 	add	r3, r3, #1
    925c:	e50b3008 	str	r3, [fp, #-8]
    9260:	eaffffef 	b	9224 <_Z6memcpyPKvPvi+0x30>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:204
}
    9264:	e320f000 	nop	{0}
    9268:	e28bd000 	add	sp, fp, #0
    926c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9270:	e12fff1e 	bx	lr

00009274 <_Z8is_digitc>:
_Z8is_digitc():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:206

bool is_digit(char c) {
    9274:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9278:	e28db000 	add	fp, sp, #0
    927c:	e24dd00c 	sub	sp, sp, #12
    9280:	e1a03000 	mov	r3, r0
    9284:	e54b3005 	strb	r3, [fp, #-5]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:207
    return (c >= '0') && (c <= '9');
    9288:	e55b3005 	ldrb	r3, [fp, #-5]
    928c:	e353002f 	cmp	r3, #47	; 0x2f
    9290:	9a000004 	bls	92a8 <_Z8is_digitc+0x34>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:207 (discriminator 1)
    9294:	e55b3005 	ldrb	r3, [fp, #-5]
    9298:	e3530039 	cmp	r3, #57	; 0x39
    929c:	8a000001 	bhi	92a8 <_Z8is_digitc+0x34>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:207 (discriminator 3)
    92a0:	e3a03001 	mov	r3, #1
    92a4:	ea000000 	b	92ac <_Z8is_digitc+0x38>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:207 (discriminator 4)
    92a8:	e3a03000 	mov	r3, #0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:208 (discriminator 6)
}
    92ac:	e1a00003 	mov	r0, r3
    92b0:	e28bd000 	add	sp, fp, #0
    92b4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    92b8:	e12fff1e 	bx	lr

000092bc <_Z10is_decimalPKc>:
_Z10is_decimalPKc():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:210

bool is_decimal(const char *str) {
    92bc:	e92d4800 	push	{fp, lr}
    92c0:	e28db004 	add	fp, sp, #4
    92c4:	e24dd018 	sub	sp, sp, #24
    92c8:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:211
    char c = str[0];
    92cc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    92d0:	e5d33000 	ldrb	r3, [r3]
    92d4:	e54b300d 	strb	r3, [fp, #-13]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:212
    if (c == '\0') return false;
    92d8:	e55b300d 	ldrb	r3, [fp, #-13]
    92dc:	e3530000 	cmp	r3, #0
    92e0:	1a000001 	bne	92ec <_Z10is_decimalPKc+0x30>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:212 (discriminator 1)
    92e4:	e3a03000 	mov	r3, #0
    92e8:	ea000036 	b	93c8 <_Z10is_decimalPKc+0x10c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:214

    int size = 0;
    92ec:	e3a03000 	mov	r3, #0
    92f0:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:216

    if (!is_digit(c)) {
    92f4:	e55b300d 	ldrb	r3, [fp, #-13]
    92f8:	e1a00003 	mov	r0, r3
    92fc:	ebffffdc 	bl	9274 <_Z8is_digitc>
    9300:	e1a03000 	mov	r3, r0
    9304:	e2233001 	eor	r3, r3, #1
    9308:	e6ef3073 	uxtb	r3, r3
    930c:	e3530000 	cmp	r3, #0
    9310:	0a000007 	beq	9334 <_Z10is_decimalPKc+0x78>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:217
        if (c != '+' && c != '-') {
    9314:	e55b300d 	ldrb	r3, [fp, #-13]
    9318:	e353002b 	cmp	r3, #43	; 0x2b
    931c:	0a000007 	beq	9340 <_Z10is_decimalPKc+0x84>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:217 (discriminator 1)
    9320:	e55b300d 	ldrb	r3, [fp, #-13]
    9324:	e353002d 	cmp	r3, #45	; 0x2d
    9328:	0a000004 	beq	9340 <_Z10is_decimalPKc+0x84>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:218
            return false;
    932c:	e3a03000 	mov	r3, #0
    9330:	ea000024 	b	93c8 <_Z10is_decimalPKc+0x10c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:221
        }
    } else {
        size++;
    9334:	e51b3008 	ldr	r3, [fp, #-8]
    9338:	e2833001 	add	r3, r3, #1
    933c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:224
    }

    int i = 1;
    9340:	e3a03001 	mov	r3, #1
    9344:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:225
    while (str[i] != '\0') {
    9348:	e51b300c 	ldr	r3, [fp, #-12]
    934c:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9350:	e0823003 	add	r3, r2, r3
    9354:	e5d33000 	ldrb	r3, [r3]
    9358:	e3530000 	cmp	r3, #0
    935c:	0a000013 	beq	93b0 <_Z10is_decimalPKc+0xf4>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:226
        if (!is_digit(str[i])) {
    9360:	e51b300c 	ldr	r3, [fp, #-12]
    9364:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9368:	e0823003 	add	r3, r2, r3
    936c:	e5d33000 	ldrb	r3, [r3]
    9370:	e1a00003 	mov	r0, r3
    9374:	ebffffbe 	bl	9274 <_Z8is_digitc>
    9378:	e1a03000 	mov	r3, r0
    937c:	e2233001 	eor	r3, r3, #1
    9380:	e6ef3073 	uxtb	r3, r3
    9384:	e3530000 	cmp	r3, #0
    9388:	0a000001 	beq	9394 <_Z10is_decimalPKc+0xd8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:227
            return false;
    938c:	e3a03000 	mov	r3, #0
    9390:	ea00000c 	b	93c8 <_Z10is_decimalPKc+0x10c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:229
        }
        size++;
    9394:	e51b3008 	ldr	r3, [fp, #-8]
    9398:	e2833001 	add	r3, r3, #1
    939c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:230
        i++;
    93a0:	e51b300c 	ldr	r3, [fp, #-12]
    93a4:	e2833001 	add	r3, r3, #1
    93a8:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:225
    while (str[i] != '\0') {
    93ac:	eaffffe5 	b	9348 <_Z10is_decimalPKc+0x8c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:233
    }

    if (size == 0) {
    93b0:	e51b3008 	ldr	r3, [fp, #-8]
    93b4:	e3530000 	cmp	r3, #0
    93b8:	1a000001 	bne	93c4 <_Z10is_decimalPKc+0x108>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:234
        return false;
    93bc:	e3a03000 	mov	r3, #0
    93c0:	ea000000 	b	93c8 <_Z10is_decimalPKc+0x10c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:237
    }

    return true;
    93c4:	e3a03001 	mov	r3, #1
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:238
}
    93c8:	e1a00003 	mov	r0, r3
    93cc:	e24bd004 	sub	sp, fp, #4
    93d0:	e8bd8800 	pop	{fp, pc}

000093d4 <_Z8is_floatPKc>:
_Z8is_floatPKc():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:240

bool is_float(const char *str) {
    93d4:	e92d4800 	push	{fp, lr}
    93d8:	e28db004 	add	fp, sp, #4
    93dc:	e24dd020 	sub	sp, sp, #32
    93e0:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:241
    char c = str[0];
    93e4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    93e8:	e5d33000 	ldrb	r3, [r3]
    93ec:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:242
    bool point = false;
    93f0:	e3a03000 	mov	r3, #0
    93f4:	e54b3005 	strb	r3, [fp, #-5]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:243
    int after_point = 0;
    93f8:	e3a03000 	mov	r3, #0
    93fc:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:244
    int before_point = 0;
    9400:	e3a03000 	mov	r3, #0
    9404:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:246

    if (c == '\0') return false;
    9408:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    940c:	e3530000 	cmp	r3, #0
    9410:	1a000001 	bne	941c <_Z8is_floatPKc+0x48>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:246 (discriminator 1)
    9414:	e3a03000 	mov	r3, #0
    9418:	ea00005c 	b	9590 <_Z8is_floatPKc+0x1bc>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:248

    if (c != '+' && c != '-' && !is_digit(c)) return false;
    941c:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    9420:	e353002b 	cmp	r3, #43	; 0x2b
    9424:	0a00000c 	beq	945c <_Z8is_floatPKc+0x88>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:248 (discriminator 1)
    9428:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    942c:	e353002d 	cmp	r3, #45	; 0x2d
    9430:	0a000009 	beq	945c <_Z8is_floatPKc+0x88>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:248 (discriminator 3)
    9434:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    9438:	e1a00003 	mov	r0, r3
    943c:	ebffff8c 	bl	9274 <_Z8is_digitc>
    9440:	e1a03000 	mov	r3, r0
    9444:	e2233001 	eor	r3, r3, #1
    9448:	e6ef3073 	uxtb	r3, r3
    944c:	e3530000 	cmp	r3, #0
    9450:	0a000001 	beq	945c <_Z8is_floatPKc+0x88>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:248 (discriminator 5)
    9454:	e3a03001 	mov	r3, #1
    9458:	ea000000 	b	9460 <_Z8is_floatPKc+0x8c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:248 (discriminator 6)
    945c:	e3a03000 	mov	r3, #0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:248 (discriminator 8)
    9460:	e3530000 	cmp	r3, #0
    9464:	0a000001 	beq	9470 <_Z8is_floatPKc+0x9c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:248 (discriminator 9)
    9468:	e3a03000 	mov	r3, #0
    946c:	ea000047 	b	9590 <_Z8is_floatPKc+0x1bc>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:250

    if (is_digit(c)) {
    9470:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    9474:	e1a00003 	mov	r0, r3
    9478:	ebffff7d 	bl	9274 <_Z8is_digitc>
    947c:	e1a03000 	mov	r3, r0
    9480:	e3530000 	cmp	r3, #0
    9484:	0a000002 	beq	9494 <_Z8is_floatPKc+0xc0>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:251
        before_point++;
    9488:	e51b3010 	ldr	r3, [fp, #-16]
    948c:	e2833001 	add	r3, r3, #1
    9490:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:254
    }

    int i = 1;
    9494:	e3a03001 	mov	r3, #1
    9498:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:255
    while (str[i] != '\0') {
    949c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    94a0:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    94a4:	e0823003 	add	r3, r2, r3
    94a8:	e5d33000 	ldrb	r3, [r3]
    94ac:	e3530000 	cmp	r3, #0
    94b0:	0a000028 	beq	9558 <_Z8is_floatPKc+0x184>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:256
        if (!is_digit(str[i])) {
    94b4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    94b8:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    94bc:	e0823003 	add	r3, r2, r3
    94c0:	e5d33000 	ldrb	r3, [r3]
    94c4:	e1a00003 	mov	r0, r3
    94c8:	ebffff69 	bl	9274 <_Z8is_digitc>
    94cc:	e1a03000 	mov	r3, r0
    94d0:	e2233001 	eor	r3, r3, #1
    94d4:	e6ef3073 	uxtb	r3, r3
    94d8:	e3530000 	cmp	r3, #0
    94dc:	0a00000f 	beq	9520 <_Z8is_floatPKc+0x14c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:257
            if (str[i] == '.' && point == false) {
    94e0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    94e4:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    94e8:	e0823003 	add	r3, r2, r3
    94ec:	e5d33000 	ldrb	r3, [r3]
    94f0:	e353002e 	cmp	r3, #46	; 0x2e
    94f4:	1a000007 	bne	9518 <_Z8is_floatPKc+0x144>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:257 (discriminator 1)
    94f8:	e55b3005 	ldrb	r3, [fp, #-5]
    94fc:	e2233001 	eor	r3, r3, #1
    9500:	e6ef3073 	uxtb	r3, r3
    9504:	e3530000 	cmp	r3, #0
    9508:	0a000002 	beq	9518 <_Z8is_floatPKc+0x144>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:258
                point = true;
    950c:	e3a03001 	mov	r3, #1
    9510:	e54b3005 	strb	r3, [fp, #-5]
    9514:	ea00000b 	b	9548 <_Z8is_floatPKc+0x174>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:260
            } else {
                return false;
    9518:	e3a03000 	mov	r3, #0
    951c:	ea00001b 	b	9590 <_Z8is_floatPKc+0x1bc>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:263
            }
        } else {
            if (point == true) {
    9520:	e55b3005 	ldrb	r3, [fp, #-5]
    9524:	e3530000 	cmp	r3, #0
    9528:	0a000003 	beq	953c <_Z8is_floatPKc+0x168>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:264
                after_point++;
    952c:	e51b300c 	ldr	r3, [fp, #-12]
    9530:	e2833001 	add	r3, r3, #1
    9534:	e50b300c 	str	r3, [fp, #-12]
    9538:	ea000002 	b	9548 <_Z8is_floatPKc+0x174>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:266
            } else {
                before_point++;
    953c:	e51b3010 	ldr	r3, [fp, #-16]
    9540:	e2833001 	add	r3, r3, #1
    9544:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:269
            }
        }
        i++;
    9548:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    954c:	e2833001 	add	r3, r3, #1
    9550:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:255
    while (str[i] != '\0') {
    9554:	eaffffd0 	b	949c <_Z8is_floatPKc+0xc8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:272
    }

    if (before_point < 0) {
    9558:	e51b3010 	ldr	r3, [fp, #-16]
    955c:	e3530000 	cmp	r3, #0
    9560:	aa000001 	bge	956c <_Z8is_floatPKc+0x198>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:273
        return false;
    9564:	e3a03000 	mov	r3, #0
    9568:	ea000008 	b	9590 <_Z8is_floatPKc+0x1bc>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:276
    }

    if (point == true && after_point == 0) {
    956c:	e55b3005 	ldrb	r3, [fp, #-5]
    9570:	e3530000 	cmp	r3, #0
    9574:	0a000004 	beq	958c <_Z8is_floatPKc+0x1b8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:276 (discriminator 1)
    9578:	e51b300c 	ldr	r3, [fp, #-12]
    957c:	e3530000 	cmp	r3, #0
    9580:	1a000001 	bne	958c <_Z8is_floatPKc+0x1b8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:277
        return false;
    9584:	e3a03000 	mov	r3, #0
    9588:	ea000000 	b	9590 <_Z8is_floatPKc+0x1bc>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:280
    }

    return true;
    958c:	e3a03001 	mov	r3, #1
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:281
    9590:	e1a00003 	mov	r0, r3
    9594:	e24bd004 	sub	sp, fp, #4
    9598:	e8bd8800 	pop	{fp, pc}

0000959c <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1150
    959c:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1152
    95a0:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1153
    95a4:	3a000074 	bcc	977c <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1154
    95a8:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1155
    95ac:	9a00006b 	bls	9760 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    95b0:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    95b4:	0a00006c 	beq	976c <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    95b8:	e16f3f10 	clz	r3, r0
    95bc:	e16f2f11 	clz	r2, r1
    95c0:	e0423003 	sub	r3, r2, r3
    95c4:	e273301f 	rsbs	r3, r3, #31
    95c8:	10833083 	addne	r3, r3, r3, lsl #1
    95cc:	e3a02000 	mov	r2, #0
    95d0:	108ff103 	addne	pc, pc, r3, lsl #2
    95d4:	e1a00000 	nop			; (mov r0, r0)
    95d8:	e1500f81 	cmp	r0, r1, lsl #31
    95dc:	e0a22002 	adc	r2, r2, r2
    95e0:	20400f81 	subcs	r0, r0, r1, lsl #31
    95e4:	e1500f01 	cmp	r0, r1, lsl #30
    95e8:	e0a22002 	adc	r2, r2, r2
    95ec:	20400f01 	subcs	r0, r0, r1, lsl #30
    95f0:	e1500e81 	cmp	r0, r1, lsl #29
    95f4:	e0a22002 	adc	r2, r2, r2
    95f8:	20400e81 	subcs	r0, r0, r1, lsl #29
    95fc:	e1500e01 	cmp	r0, r1, lsl #28
    9600:	e0a22002 	adc	r2, r2, r2
    9604:	20400e01 	subcs	r0, r0, r1, lsl #28
    9608:	e1500d81 	cmp	r0, r1, lsl #27
    960c:	e0a22002 	adc	r2, r2, r2
    9610:	20400d81 	subcs	r0, r0, r1, lsl #27
    9614:	e1500d01 	cmp	r0, r1, lsl #26
    9618:	e0a22002 	adc	r2, r2, r2
    961c:	20400d01 	subcs	r0, r0, r1, lsl #26
    9620:	e1500c81 	cmp	r0, r1, lsl #25
    9624:	e0a22002 	adc	r2, r2, r2
    9628:	20400c81 	subcs	r0, r0, r1, lsl #25
    962c:	e1500c01 	cmp	r0, r1, lsl #24
    9630:	e0a22002 	adc	r2, r2, r2
    9634:	20400c01 	subcs	r0, r0, r1, lsl #24
    9638:	e1500b81 	cmp	r0, r1, lsl #23
    963c:	e0a22002 	adc	r2, r2, r2
    9640:	20400b81 	subcs	r0, r0, r1, lsl #23
    9644:	e1500b01 	cmp	r0, r1, lsl #22
    9648:	e0a22002 	adc	r2, r2, r2
    964c:	20400b01 	subcs	r0, r0, r1, lsl #22
    9650:	e1500a81 	cmp	r0, r1, lsl #21
    9654:	e0a22002 	adc	r2, r2, r2
    9658:	20400a81 	subcs	r0, r0, r1, lsl #21
    965c:	e1500a01 	cmp	r0, r1, lsl #20
    9660:	e0a22002 	adc	r2, r2, r2
    9664:	20400a01 	subcs	r0, r0, r1, lsl #20
    9668:	e1500981 	cmp	r0, r1, lsl #19
    966c:	e0a22002 	adc	r2, r2, r2
    9670:	20400981 	subcs	r0, r0, r1, lsl #19
    9674:	e1500901 	cmp	r0, r1, lsl #18
    9678:	e0a22002 	adc	r2, r2, r2
    967c:	20400901 	subcs	r0, r0, r1, lsl #18
    9680:	e1500881 	cmp	r0, r1, lsl #17
    9684:	e0a22002 	adc	r2, r2, r2
    9688:	20400881 	subcs	r0, r0, r1, lsl #17
    968c:	e1500801 	cmp	r0, r1, lsl #16
    9690:	e0a22002 	adc	r2, r2, r2
    9694:	20400801 	subcs	r0, r0, r1, lsl #16
    9698:	e1500781 	cmp	r0, r1, lsl #15
    969c:	e0a22002 	adc	r2, r2, r2
    96a0:	20400781 	subcs	r0, r0, r1, lsl #15
    96a4:	e1500701 	cmp	r0, r1, lsl #14
    96a8:	e0a22002 	adc	r2, r2, r2
    96ac:	20400701 	subcs	r0, r0, r1, lsl #14
    96b0:	e1500681 	cmp	r0, r1, lsl #13
    96b4:	e0a22002 	adc	r2, r2, r2
    96b8:	20400681 	subcs	r0, r0, r1, lsl #13
    96bc:	e1500601 	cmp	r0, r1, lsl #12
    96c0:	e0a22002 	adc	r2, r2, r2
    96c4:	20400601 	subcs	r0, r0, r1, lsl #12
    96c8:	e1500581 	cmp	r0, r1, lsl #11
    96cc:	e0a22002 	adc	r2, r2, r2
    96d0:	20400581 	subcs	r0, r0, r1, lsl #11
    96d4:	e1500501 	cmp	r0, r1, lsl #10
    96d8:	e0a22002 	adc	r2, r2, r2
    96dc:	20400501 	subcs	r0, r0, r1, lsl #10
    96e0:	e1500481 	cmp	r0, r1, lsl #9
    96e4:	e0a22002 	adc	r2, r2, r2
    96e8:	20400481 	subcs	r0, r0, r1, lsl #9
    96ec:	e1500401 	cmp	r0, r1, lsl #8
    96f0:	e0a22002 	adc	r2, r2, r2
    96f4:	20400401 	subcs	r0, r0, r1, lsl #8
    96f8:	e1500381 	cmp	r0, r1, lsl #7
    96fc:	e0a22002 	adc	r2, r2, r2
    9700:	20400381 	subcs	r0, r0, r1, lsl #7
    9704:	e1500301 	cmp	r0, r1, lsl #6
    9708:	e0a22002 	adc	r2, r2, r2
    970c:	20400301 	subcs	r0, r0, r1, lsl #6
    9710:	e1500281 	cmp	r0, r1, lsl #5
    9714:	e0a22002 	adc	r2, r2, r2
    9718:	20400281 	subcs	r0, r0, r1, lsl #5
    971c:	e1500201 	cmp	r0, r1, lsl #4
    9720:	e0a22002 	adc	r2, r2, r2
    9724:	20400201 	subcs	r0, r0, r1, lsl #4
    9728:	e1500181 	cmp	r0, r1, lsl #3
    972c:	e0a22002 	adc	r2, r2, r2
    9730:	20400181 	subcs	r0, r0, r1, lsl #3
    9734:	e1500101 	cmp	r0, r1, lsl #2
    9738:	e0a22002 	adc	r2, r2, r2
    973c:	20400101 	subcs	r0, r0, r1, lsl #2
    9740:	e1500081 	cmp	r0, r1, lsl #1
    9744:	e0a22002 	adc	r2, r2, r2
    9748:	20400081 	subcs	r0, r0, r1, lsl #1
    974c:	e1500001 	cmp	r0, r1
    9750:	e0a22002 	adc	r2, r2, r2
    9754:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    9758:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    975c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    9760:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    9764:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    9768:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1169
    976c:	e16f2f11 	clz	r2, r1
    9770:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1171
    9774:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1172
    9778:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1176
    977c:	e3500000 	cmp	r0, #0
    9780:	13e00000 	mvnne	r0, #0
    9784:	ea000007 	b	97a8 <__aeabi_idiv0>

00009788 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1207
    9788:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1208
    978c:	0afffffa 	beq	977c <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1209
    9790:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1210
    9794:	ebffff80 	bl	959c <__udivsi3>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1211
    9798:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1212
    979c:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1213
    97a0:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1214
    97a4:	e12fff1e 	bx	lr

000097a8 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1512
    97a8:	e12fff1e 	bx	lr

000097ac <__aeabi_frsub>:
__aeabi_frsub():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:59
    97ac:	e2200102 	eor	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:60
    97b0:	ea000000 	b	97b8 <__addsf3>

000097b4 <__aeabi_fsub>:
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:65
    97b4:	e2211102 	eor	r1, r1, #-2147483648	; 0x80000000

000097b8 <__addsf3>:
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:74
    97b8:	e1b02080 	lsls	r2, r0, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:76
    97bc:	11b03081 	lslsne	r3, r1, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:77
    97c0:	11320003 	teqne	r2, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:78
    97c4:	11f0cc42 	mvnsne	ip, r2, asr #24
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:79
    97c8:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:80
    97cc:	0a00003c 	beq	98c4 <__addsf3+0x10c>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:84
    97d0:	e1a02c22 	lsr	r2, r2, #24
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:85
    97d4:	e0723c23 	rsbs	r3, r2, r3, lsr #24
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:87
    97d8:	c0822003 	addgt	r2, r2, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:88
    97dc:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:89
    97e0:	c0210000 	eorgt	r0, r1, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:90
    97e4:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:92
    97e8:	b2633000 	rsblt	r3, r3, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:97
    97ec:	e3530019 	cmp	r3, #25
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:99
    97f0:	812fff1e 	bxhi	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:102
    97f4:	e3100102 	tst	r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:103
    97f8:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:104
    97fc:	e3c004ff 	bic	r0, r0, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:106
    9800:	12600000 	rsbne	r0, r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:107
    9804:	e3110102 	tst	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:108
    9808:	e3811502 	orr	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:109
    980c:	e3c114ff 	bic	r1, r1, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:111
    9810:	12611000 	rsbne	r1, r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:115
    9814:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:116
    9818:	0a000023 	beq	98ac <__addsf3+0xf4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:120
    981c:	e2422001 	sub	r2, r2, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:124
    9820:	e0900351 	adds	r0, r0, r1, asr r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:125
    9824:	e2633020 	rsb	r3, r3, #32
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:126
    9828:	e1a01311 	lsl	r1, r1, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:129
    982c:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:130
    9830:	5a000001 	bpl	983c <__addsf3+0x84>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:135
    9834:	e2711000 	rsbs	r1, r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:136
    9838:	e2e00000 	rsc	r0, r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:141
    983c:	e3500502 	cmp	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:142
    9840:	3a00000b 	bcc	9874 <__addsf3+0xbc>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:143
    9844:	e3500401 	cmp	r0, #16777216	; 0x1000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:144
    9848:	3a000004 	bcc	9860 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:147
    984c:	e1b000a0 	lsrs	r0, r0, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:148
    9850:	e1a01061 	rrx	r1, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:149
    9854:	e2822001 	add	r2, r2, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:152
    9858:	e35200fe 	cmp	r2, #254	; 0xfe
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:153
    985c:	2a00002d 	bcs	9918 <__addsf3+0x160>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:160
    9860:	e3510102 	cmp	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:161
    9864:	e0a00b82 	adc	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:163
    9868:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:164
    986c:	e1800003 	orr	r0, r0, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:165
    9870:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:169
    9874:	e1b01081 	lsls	r1, r1, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:170
    9878:	e0a00000 	adc	r0, r0, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:171
    987c:	e3100502 	tst	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:172
    9880:	e2422001 	sub	r2, r2, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:173
    9884:	1afffff5 	bne	9860 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:198
    9888:	e16fcf10 	clz	ip, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:199
    988c:	e24cc008 	sub	ip, ip, #8
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:200
    9890:	e052200c 	subs	r2, r2, ip
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:201
    9894:	e1a00c10 	lsl	r0, r0, ip
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:208
    9898:	a0800b82 	addge	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:209
    989c:	b2622000 	rsblt	r2, r2, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:210
    98a0:	a1800003 	orrge	r0, r0, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:216
    98a4:	b1830230 	orrlt	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:218
    98a8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:223
    98ac:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:224
    98b0:	e2211502 	eor	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:226
    98b4:	02200502 	eoreq	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:227
    98b8:	02822001 	addeq	r2, r2, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:228
    98bc:	12433001 	subne	r3, r3, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:229
    98c0:	eaffffd5 	b	981c <__addsf3+0x64>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:232
    98c4:	e1a03081 	lsl	r3, r1, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:234
    98c8:	e1f0cc42 	mvns	ip, r2, asr #24
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:236
    98cc:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:237
    98d0:	0a000013 	beq	9924 <__addsf3+0x16c>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:239
    98d4:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:240
    98d8:	0a000002 	beq	98e8 <__addsf3+0x130>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:243
    98dc:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:245
    98e0:	01a00001 	moveq	r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:246
    98e4:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:248
    98e8:	e1300001 	teq	r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:252
    98ec:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:253
    98f0:	112fff1e 	bxne	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:256
    98f4:	e31204ff 	tst	r2, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:257
    98f8:	1a000002 	bne	9908 <__addsf3+0x150>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:258
    98fc:	e1b00080 	lsls	r0, r0, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:260
    9900:	23800102 	orrcs	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:261
    9904:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:262
    9908:	e2922402 	adds	r2, r2, #33554432	; 0x2000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:264
    990c:	32800502 	addcc	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:265
    9910:	312fff1e 	bxcc	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:266
    9914:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:270
    9918:	e383047f 	orr	r0, r3, #2130706432	; 0x7f000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:271
    991c:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:272
    9920:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:281
    9924:	e1f02c42 	mvns	r2, r2, asr #24
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:283
    9928:	11a00001 	movne	r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:284
    992c:	01f03c43 	mvnseq	r3, r3, asr #24
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:285
    9930:	11a01000 	movne	r1, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:286
    9934:	e1b02480 	lsls	r2, r0, #9
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:288
    9938:	01b03481 	lslseq	r3, r1, #9
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:289
    993c:	01300001 	teqeq	r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:290
    9940:	13800501 	orrne	r0, r0, #4194304	; 0x400000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:291
    9944:	e12fff1e 	bx	lr

00009948 <__aeabi_ui2f>:
__aeabi_ui2f():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:304
    9948:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:305
    994c:	ea000001 	b	9958 <__aeabi_i2f+0x8>

00009950 <__aeabi_i2f>:
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:310
    9950:	e2103102 	ands	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:312
    9954:	42600000 	rsbmi	r0, r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:314
    9958:	e1b0c000 	movs	ip, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:316
    995c:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:319
    9960:	e383344b 	orr	r3, r3, #1258291200	; 0x4b000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:322
    9964:	e1a01000 	mov	r1, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:324
    9968:	e3a00000 	mov	r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:325
    996c:	ea00000f 	b	99b0 <__aeabi_l2f+0x30>

00009970 <__aeabi_ul2f>:
__floatundisf():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:337
    9970:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:339
    9974:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:341
    9978:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:342
    997c:	ea000005 	b	9998 <__aeabi_l2f+0x18>

00009980 <__aeabi_l2f>:
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:347
    9980:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:349
    9984:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:351
    9988:	e2113102 	ands	r3, r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:352
    998c:	5a000001 	bpl	9998 <__aeabi_l2f+0x18>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:357
    9990:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:358
    9994:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:361
    9998:	e1b0c001 	movs	ip, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:363
    999c:	01a0c000 	moveq	ip, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:364
    99a0:	01a01000 	moveq	r1, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:365
    99a4:	03a00000 	moveq	r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:368
    99a8:	e383345b 	orr	r3, r3, #1526726656	; 0x5b000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:370
    99ac:	02433201 	subeq	r3, r3, #268435456	; 0x10000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:371
    99b0:	e2433502 	sub	r3, r3, #8388608	; 0x800000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:396
    99b4:	e16f2f1c 	clz	r2, ip
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:397
    99b8:	e2522008 	subs	r2, r2, #8
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:401
    99bc:	e0433b82 	sub	r3, r3, r2, lsl #23
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:402
    99c0:	ba000006 	blt	99e0 <__aeabi_l2f+0x60>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:404
    99c4:	e0833211 	add	r3, r3, r1, lsl r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:405
    99c8:	e1a0c210 	lsl	ip, r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:406
    99cc:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:407
    99d0:	e35c0102 	cmp	ip, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:408
    99d4:	e0a30230 	adc	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:410
    99d8:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:411
    99dc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:413
    99e0:	e2822020 	add	r2, r2, #32
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:414
    99e4:	e1a0c211 	lsl	ip, r1, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:415
    99e8:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:416
    99ec:	e190008c 	orrs	r0, r0, ip, lsl #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:417
    99f0:	e0a30231 	adc	r0, r3, r1, lsr r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:419
    99f4:	01c00fac 	biceq	r0, r0, ip, lsr #31
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:420
    99f8:	e12fff1e 	bx	lr

000099fc <__aeabi_ldivmod>:
__aeabi_ldivmod():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:186
    99fc:	e3530000 	cmp	r3, #0
    9a00:	03520000 	cmpeq	r2, #0
    9a04:	1a000007 	bne	9a28 <__aeabi_ldivmod+0x2c>
    9a08:	e3510000 	cmp	r1, #0
    9a0c:	b3a01102 	movlt	r1, #-2147483648	; 0x80000000
    9a10:	b3a00000 	movlt	r0, #0
    9a14:	ba000002 	blt	9a24 <__aeabi_ldivmod+0x28>
    9a18:	03500000 	cmpeq	r0, #0
    9a1c:	13e01102 	mvnne	r1, #-2147483648	; 0x80000000
    9a20:	13e00000 	mvnne	r0, #0
    9a24:	eaffff5f 	b	97a8 <__aeabi_idiv0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:188
    9a28:	e24dd008 	sub	sp, sp, #8
    9a2c:	e92d6000 	push	{sp, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:189
    9a30:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:190
    9a34:	ba000006 	blt	9a54 <__aeabi_ldivmod+0x58>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:191
    9a38:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:192
    9a3c:	ba000011 	blt	9a88 <__aeabi_ldivmod+0x8c>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:194
    9a40:	eb00003e 	bl	9b40 <__udivmoddi4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:196
    9a44:	e59de004 	ldr	lr, [sp, #4]
    9a48:	e28dd008 	add	sp, sp, #8
    9a4c:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:197
    9a50:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:201
    9a54:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:202
    9a58:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:203
    9a5c:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:204
    9a60:	ba000011 	blt	9aac <__aeabi_ldivmod+0xb0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:206
    9a64:	eb000035 	bl	9b40 <__udivmoddi4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:208
    9a68:	e59de004 	ldr	lr, [sp, #4]
    9a6c:	e28dd008 	add	sp, sp, #8
    9a70:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:209
    9a74:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:210
    9a78:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:211
    9a7c:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:212
    9a80:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:213
    9a84:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:217
    9a88:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:218
    9a8c:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:220
    9a90:	eb00002a 	bl	9b40 <__udivmoddi4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:222
    9a94:	e59de004 	ldr	lr, [sp, #4]
    9a98:	e28dd008 	add	sp, sp, #8
    9a9c:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:223
    9aa0:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:224
    9aa4:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:225
    9aa8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:229
    9aac:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:230
    9ab0:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:232
    9ab4:	eb000021 	bl	9b40 <__udivmoddi4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:233
    9ab8:	e59de004 	ldr	lr, [sp, #4]
    9abc:	e28dd008 	add	sp, sp, #8
    9ac0:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:234
    9ac4:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:235
    9ac8:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:236
    9acc:	e12fff1e 	bx	lr

00009ad0 <__aeabi_f2lz>:
__fixsfdi():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    9ad0:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1531
    9ad4:	eef57ac0 	vcmpe.f32	s15, #0.0
    9ad8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    9adc:	4a000000 	bmi	9ae4 <__aeabi_f2lz+0x14>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1533
    9ae0:	ea000006 	b	9b00 <__aeabi_f2ulz>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    9ae4:	e92d4010 	push	{r4, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1532
    9ae8:	e2200102 	eor	r0, r0, #-2147483648	; 0x80000000
    9aec:	eb000003 	bl	9b00 <__aeabi_f2ulz>
    9af0:	e2700000 	rsbs	r0, r0, #0
    9af4:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1534
    9af8:	e8bd8010 	pop	{r4, pc}
__aeabi_f2lz():
    9afc:	00000000 	andeq	r0, r0, r0

00009b00 <__aeabi_f2ulz>:
__fixunssfdi():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    9b00:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    9b04:	ed9f5b09 	vldr	d5, [pc, #36]	; 9b30 <__aeabi_f2ulz+0x30>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    9b08:	eeb76ae7 	vcvt.f64.f32	d6, s15
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1476
    9b0c:	ed9f7b09 	vldr	d7, [pc, #36]	; 9b38 <__aeabi_f2ulz+0x38>
    9b10:	ee267b07 	vmul.f64	d7, d6, d7
    9b14:	eebc7bc7 	vcvt.u32.f64	s14, d7
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    9b18:	eeb84b47 	vcvt.f64.u32	d4, s14
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    9b1c:	ee171a10 	vmov	r1, s14
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    9b20:	ee046b45 	vmls.f64	d6, d4, d5
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    9b24:	eefc7bc6 	vcvt.u32.f64	s15, d6
    9b28:	ee170a90 	vmov	r0, s15
    9b2c:	e12fff1e 	bx	lr
    9b30:	00000000 	andeq	r0, r0, r0
    9b34:	41f00000 	mvnsmi	r0, r0
    9b38:	00000000 	andeq	r0, r0, r0
    9b3c:	3df00000 	ldclcc	0, cr0, [r0]

00009b40 <__udivmoddi4>:
__udivmoddi4():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    9b40:	e1510003 	cmp	r1, r3
    9b44:	01500002 	cmpeq	r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    9b48:	e92d4ff0 	push	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
    9b4c:	e1a04000 	mov	r4, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    9b50:	33a00000 	movcc	r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    9b54:	e1a05001 	mov	r5, r1
    9b58:	e59de024 	ldr	lr, [sp, #36]	; 0x24
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    9b5c:	31a01000 	movcc	r1, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    9b60:	3a00003d 	bcc	9c5c <__udivmoddi4+0x11c>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:962
    9b64:	e3530000 	cmp	r3, #0
    9b68:	016fcf12 	clzeq	ip, r2
    9b6c:	116fcf13 	clzne	ip, r3
    9b70:	028cc020 	addeq	ip, ip, #32
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:963
    9b74:	e3550000 	cmp	r5, #0
    9b78:	016f1f14 	clzeq	r1, r4
    9b7c:	02811020 	addeq	r1, r1, #32
    9b80:	116f1f15 	clzne	r1, r5
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:965
    9b84:	e04cc001 	sub	ip, ip, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:966
    9b88:	e1a09c13 	lsl	r9, r3, ip
    9b8c:	e24cb020 	sub	fp, ip, #32
    9b90:	e1899b12 	orr	r9, r9, r2, lsl fp
    9b94:	e26ca020 	rsb	sl, ip, #32
    9b98:	e1899a32 	orr	r9, r9, r2, lsr sl
    9b9c:	e1a08c12 	lsl	r8, r2, ip
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    9ba0:	e1550009 	cmp	r5, r9
    9ba4:	01540008 	cmpeq	r4, r8
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    9ba8:	33a00000 	movcc	r0, #0
    9bac:	31a01000 	movcc	r1, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    9bb0:	3a000005 	bcc	9bcc <__udivmoddi4+0x8c>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    9bb4:	e3a00001 	mov	r0, #1
    9bb8:	e1a01b10 	lsl	r1, r0, fp
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    9bbc:	e0544008 	subs	r4, r4, r8
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    9bc0:	e1811a30 	orr	r1, r1, r0, lsr sl
    9bc4:	e1a00c10 	lsl	r0, r0, ip
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    9bc8:	e0c55009 	sbc	r5, r5, r9
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:979
    9bcc:	e35c0000 	cmp	ip, #0
    9bd0:	0a000021 	beq	9c5c <__udivmoddi4+0x11c>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:981
    9bd4:	e1a060a8 	lsr	r6, r8, #1
    9bd8:	e1866f89 	orr	r6, r6, r9, lsl #31
    9bdc:	e1a070a9 	lsr	r7, r9, #1
    9be0:	e1a0200c 	mov	r2, ip
    9be4:	ea000007 	b	9c08 <__udivmoddi4+0xc8>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:989
    9be8:	e0543006 	subs	r3, r4, r6
    9bec:	e0c58007 	sbc	r8, r5, r7
    9bf0:	e0933003 	adds	r3, r3, r3
    9bf4:	e0a88008 	adc	r8, r8, r8
    9bf8:	e2934001 	adds	r4, r3, #1
    9bfc:	e2a85000 	adc	r5, r8, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    9c00:	e2522001 	subs	r2, r2, #1
    9c04:	0a000006 	beq	9c24 <__udivmoddi4+0xe4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:988
    9c08:	e1550007 	cmp	r5, r7
    9c0c:	01540006 	cmpeq	r4, r6
    9c10:	2afffff4 	bcs	9be8 <__udivmoddi4+0xa8>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:991
    9c14:	e0944004 	adds	r4, r4, r4
    9c18:	e0a55005 	adc	r5, r5, r5
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    9c1c:	e2522001 	subs	r2, r2, #1
    9c20:	1afffff8 	bne	9c08 <__udivmoddi4+0xc8>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    9c24:	e1a03c34 	lsr	r3, r4, ip
    9c28:	e1833a15 	orr	r3, r3, r5, lsl sl
    9c2c:	e1a02c35 	lsr	r2, r5, ip
    9c30:	e1833b35 	orr	r3, r3, r5, lsr fp
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    9c34:	e0900004 	adds	r0, r0, r4
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    9c38:	e1a04003 	mov	r4, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:999
    9c3c:	e1a03c12 	lsl	r3, r2, ip
    9c40:	e1833b14 	orr	r3, r3, r4, lsl fp
    9c44:	e1a0cc14 	lsl	ip, r4, ip
    9c48:	e1833a34 	orr	r3, r3, r4, lsr sl
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    9c4c:	e0a11005 	adc	r1, r1, r5
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:999
    9c50:	e050000c 	subs	r0, r0, ip
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    9c54:	e1a05002 	mov	r5, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:999
    9c58:	e0c11003 	sbc	r1, r1, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1003
    9c5c:	e35e0000 	cmp	lr, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1004
    9c60:	11ce40f0 	strdne	r4, [lr]
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1006
    9c64:	e8bd8ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, pc}

Disassembly of section .rodata:

00009c68 <_ZL13Lock_Unlocked>:
    9c68:	00000000 	andeq	r0, r0, r0

00009c6c <_ZL11Lock_Locked>:
    9c6c:	00000001 	andeq	r0, r0, r1

00009c70 <_ZL21MaxFSDriverNameLength>:
    9c70:	00000010 	andeq	r0, r0, r0, lsl r0

00009c74 <_ZL17MaxFilenameLength>:
    9c74:	00000010 	andeq	r0, r0, r0, lsl r0

00009c78 <_ZL13MaxPathLength>:
    9c78:	00000080 	andeq	r0, r0, r0, lsl #1

00009c7c <_ZL18NoFilesystemDriver>:
    9c7c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009c80 <_ZL9NotifyAll>:
    9c80:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009c84 <_ZL24Max_Process_Opened_Files>:
    9c84:	00000010 	andeq	r0, r0, r0, lsl r0

00009c88 <_ZL10Indefinite>:
    9c88:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009c8c <_ZL18Deadline_Unchanged>:
    9c8c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009c90 <_ZL14Invalid_Handle>:
    9c90:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009c94 <_ZL13Lock_Unlocked>:
    9c94:	00000000 	andeq	r0, r0, r0

00009c98 <_ZL11Lock_Locked>:
    9c98:	00000001 	andeq	r0, r0, r1

00009c9c <_ZL21MaxFSDriverNameLength>:
    9c9c:	00000010 	andeq	r0, r0, r0, lsl r0

00009ca0 <_ZL17MaxFilenameLength>:
    9ca0:	00000010 	andeq	r0, r0, r0, lsl r0

00009ca4 <_ZL13MaxPathLength>:
    9ca4:	00000080 	andeq	r0, r0, r0, lsl #1

00009ca8 <_ZL18NoFilesystemDriver>:
    9ca8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009cac <_ZL9NotifyAll>:
    9cac:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009cb0 <_ZL24Max_Process_Opened_Files>:
    9cb0:	00000010 	andeq	r0, r0, r0, lsl r0

00009cb4 <_ZL10Indefinite>:
    9cb4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009cb8 <_ZL18Deadline_Unchanged>:
    9cb8:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009cbc <_ZL14Invalid_Handle>:
    9cbc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009cc0 <_ZL16Pipe_File_Prefix>:
    9cc0:	3a535953 	bcc	14e0214 <__bss_end+0x14d651c>
    9cc4:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9cc8:	0000002f 	andeq	r0, r0, pc, lsr #32

00009ccc <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9ccc:	33323130 	teqcc	r2, #48, 2
    9cd0:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9cd4:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9cd8:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .ARM.exidx:

00009ce0 <__CTOR_LIST__-0x8>:
    9ce0:	7ffffe60 	svcvc	0x00fffe60
    9ce4:	00000001 	andeq	r0, r0, r1

Disassembly of section .bss:

00009ce8 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1683b34>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x3872c>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3c340>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c702c>
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
       0:	00000060 	andeq	r0, r0, r0, rrx
       4:	004a0003 	subeq	r0, sl, r3
       8:	01020000 	mrseq	r0, (UNDEF: 2)
       c:	000d0efb 	strdeq	r0, [sp], -fp
      10:	01010101 	tsteq	r1, r1, lsl #2
      14:	01000000 	mrseq	r0, (UNDEF: 0)
      18:	2f010000 	svccs	0x00010000
      1c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
      20:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
      24:	2f6b6974 	svccs	0x006b6974
      28:	2f766564 	svccs	0x00766564
      2c:	616e6966 	cmnvs	lr, r6, ror #18
      30:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
      34:	6f732f63 	svcvs	0x00732f63
      38:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
      3c:	73752f73 	cmnvc	r5, #460	; 0x1cc
      40:	70737265 	rsbsvc	r7, r3, r5, ror #4
      44:	00656361 	rsbeq	r6, r5, r1, ror #6
      48:	74726300 	ldrbtvc	r6, [r2], #-768	; 0xfffffd00
      4c:	00732e30 	rsbseq	r2, r3, r0, lsr lr
      50:	00000001 	andeq	r0, r0, r1
      54:	00020500 	andeq	r0, r2, r0, lsl #10
      58:	03000080 	movweq	r0, #128	; 0x80
      5c:	02310109 	eorseq	r0, r1, #1073741826	; 0x40000002
      60:	01010002 	tsteq	r1, r2
      64:	0000008f 	andeq	r0, r0, pc, lsl #1
      68:	004a0003 	subeq	r0, sl, r3
      6c:	01020000 	mrseq	r0, (UNDEF: 2)
      70:	000d0efb 	strdeq	r0, [sp], -fp
      74:	01010101 	tsteq	r1, r1, lsl #2
      78:	01000000 	mrseq	r0, (UNDEF: 0)
      7c:	2f010000 	svccs	0x00010000
      80:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
      84:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
      88:	2f6b6974 	svccs	0x006b6974
      8c:	2f766564 	svccs	0x00766564
      90:	616e6966 	cmnvs	lr, r6, ror #18
      94:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
      98:	6f732f63 	svcvs	0x00732f63
      9c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
      a0:	73752f73 	cmnvc	r5, #460	; 0x1cc
      a4:	70737265 	rsbsvc	r7, r3, r5, ror #4
      a8:	00656361 	rsbeq	r6, r5, r1, ror #6
      ac:	74726300 	ldrbtvc	r6, [r2], #-768	; 0xfffffd00
      b0:	00632e30 	rsbeq	r2, r3, r0, lsr lr
      b4:	00000001 	andeq	r0, r0, r1
      b8:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
      bc:	00800802 	addeq	r0, r0, r2, lsl #16
      c0:	01090300 	mrseq	r0, (UNDEF: 57)
      c4:	05671805 	strbeq	r1, [r7, #-2053]!	; 0xfffff7fb
      c8:	0e054a05 	vmlaeq.f32	s8, s10, s10
      cc:	03040200 	movweq	r0, #16896	; 0x4200
      d0:	0041052f 	subeq	r0, r1, pc, lsr #10
      d4:	65030402 	strvs	r0, [r3, #-1026]	; 0xfffffbfe
      d8:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
      dc:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
      e0:	05bd8401 	ldreq	r8, [sp, #1025]!	; 0x401
      e4:	05316805 	ldreq	r6, [r1, #-2053]!	; 0xfffff7fb
      e8:	05053312 	streq	r3, [r5, #-786]	; 0xfffffcee
      ec:	054b3185 	strbeq	r3, [fp, #-389]	; 0xfffffe7b
      f0:	06022f01 	streq	r2, [r2], -r1, lsl #30
      f4:	e8010100 	stmda	r1, {r8}
      f8:	03000000 	movweq	r0, #0
      fc:	00005c00 	andeq	r5, r0, r0, lsl #24
     100:	fb010200 	blx	4090a <__bss_end+0x36c12>
     104:	01000d0e 	tsteq	r0, lr, lsl #26
     108:	00010101 	andeq	r0, r1, r1, lsl #2
     10c:	00010000 	andeq	r0, r1, r0
     110:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     114:	2f656d6f 	svccs	0x00656d6f
     118:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
     11c:	642f6b69 	strtvs	r6, [pc], #-2921	; 124 <shift+0x124>
     120:	662f7665 	strtvs	r7, [pc], -r5, ror #12
     124:	6c616e69 	stclvs	14, cr6, [r1], #-420	; 0xfffffe5c
     128:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     12c:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe05 <__bss_end+0xffff610d>
     130:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     134:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     138:	61707372 	cmnvs	r0, r2, ror r3
     13c:	00006563 	andeq	r6, r0, r3, ror #10
     140:	61787863 	cmnvs	r8, r3, ror #16
     144:	632e6962 			; <UNDEFINED> instruction: 0x632e6962
     148:	01007070 	tsteq	r0, r0, ror r0
     14c:	623c0000 	eorsvs	r0, ip, #0
     150:	746c6975 	strbtvc	r6, [ip], #-2421	; 0xfffff68b
     154:	3e6e692d 	vmulcc.f16	s13, s28, s27	; <UNPREDICTABLE>
     158:	00000000 	andeq	r0, r0, r0
     15c:	00020500 	andeq	r0, r2, r0, lsl #10
     160:	80a00205 	adchi	r0, r0, r5, lsl #4
     164:	0a030000 	beq	c016c <__bss_end+0xb6474>
     168:	830c0501 	movwhi	r0, #50433	; 0xc501
     16c:	052e0b05 	streq	r0, [lr, #-2821]!	; 0xfffff4fb
     170:	02052e0a 	andeq	r2, r5, #10, 28	; 0xa0
     174:	0e058583 	cfsh32eq	mvfx8, mvfx5, #-61
     178:	67020583 	strvs	r0, [r2, -r3, lsl #11]
     17c:	01058485 	smlabbeq	r5, r5, r4, r8
     180:	4c854c86 	stcmi	12, cr4, [r5], {134}	; 0x86
     184:	05854c85 	streq	r4, [r5, #3205]	; 0xc85
     188:	04020002 	streq	r0, [r2], #-2
     18c:	01054b01 	tsteq	r5, r1, lsl #22
     190:	052e1203 	streq	r1, [lr, #-515]!	; 0xfffffdfd
     194:	24056b0d 	strcs	r6, [r5], #-2829	; 0xfffff4f3
     198:	03040200 	movweq	r0, #16896	; 0x4200
     19c:	0004054a 	andeq	r0, r4, sl, asr #10
     1a0:	83020402 	movwhi	r0, #9218	; 0x2402
     1a4:	02000b05 	andeq	r0, r0, #5120	; 0x1400
     1a8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     1ac:	04020002 	streq	r0, [r2], #-2
     1b0:	09052d02 	stmdbeq	r5, {r1, r8, sl, fp, sp}
     1b4:	2f010585 	svccs	0x00010585
     1b8:	6a0d05a1 	bvs	341844 <__bss_end+0x337b4c>
     1bc:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
     1c0:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     1c4:	04020004 	streq	r0, [r2], #-4
     1c8:	0b058302 	bleq	160dd8 <__bss_end+0x1570e0>
     1cc:	02040200 	andeq	r0, r4, #0, 4
     1d0:	0002054a 	andeq	r0, r2, sl, asr #10
     1d4:	2d020402 	cfstrscs	mvf0, [r2, #-8]
     1d8:	05850905 	streq	r0, [r5, #2309]	; 0x905
     1dc:	0a022f01 	beq	8bde8 <__bss_end+0x820f0>
     1e0:	ac010100 	stfges	f0, [r1], {-0}
     1e4:	03000001 	movweq	r0, #1
     1e8:	00018200 	andeq	r8, r1, r0, lsl #4
     1ec:	fb010200 	blx	409f6 <__bss_end+0x36cfe>
     1f0:	01000d0e 	tsteq	r0, lr, lsl #26
     1f4:	00010101 	andeq	r0, r1, r1, lsl #2
     1f8:	00010000 	andeq	r0, r1, r0
     1fc:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     200:	2f656d6f 	svccs	0x00656d6f
     204:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
     208:	642f6b69 	strtvs	r6, [pc], #-2921	; 210 <shift+0x210>
     20c:	662f7665 	strtvs	r7, [pc], -r5, ror #12
     210:	6c616e69 	stclvs	14, cr6, [r1], #-420	; 0xfffffe5c
     214:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     218:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffef1 <__bss_end+0xffff61f9>
     21c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     220:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     224:	61707372 	cmnvs	r0, r2, ror r3
     228:	692f6563 	stmdbvs	pc!, {r0, r1, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
     22c:	5f74696e 	svcpl	0x0074696e
     230:	6b736174 	blvs	1cd8808 <__bss_end+0x1cceb10>
     234:	6f682f00 	svcvs	0x00682f00
     238:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
     23c:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
     240:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
     244:	69662f76 	stmdbvs	r6!, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
     248:	2f6c616e 	svccs	0x006c616e
     24c:	2f637273 	svccs	0x00637273
     250:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     254:	2f736563 	svccs	0x00736563
     258:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     25c:	63617073 	cmnvs	r1, #115	; 0x73
     260:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     264:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     268:	2f6c656e 	svccs	0x006c656e
     26c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     270:	2f656475 	svccs	0x00656475
     274:	636f7270 	cmnvs	pc, #112, 4
     278:	00737365 	rsbseq	r7, r3, r5, ror #6
     27c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 1c8 <shift+0x1c8>
     280:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     284:	6b69746e 	blvs	1a5d444 <__bss_end+0x1a5374c>
     288:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
     28c:	6e69662f 	cdpvs	6, 6, cr6, cr9, cr15, {1}
     290:	732f6c61 			; <UNDEFINED> instruction: 0x732f6c61
     294:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
     298:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     29c:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff3f <__bss_end+0xffff6247>
     2a0:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     2a4:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     2a8:	2f2e2e2f 	svccs	0x002e2e2f
     2ac:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     2b0:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     2b4:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     2b8:	662f6564 	strtvs	r6, [pc], -r4, ror #10
     2bc:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     2c0:	2f656d6f 	svccs	0x00656d6f
     2c4:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
     2c8:	642f6b69 	strtvs	r6, [pc], #-2921	; 2d0 <shift+0x2d0>
     2cc:	662f7665 	strtvs	r7, [pc], -r5, ror #12
     2d0:	6c616e69 	stclvs	14, cr6, [r1], #-420	; 0xfffffe5c
     2d4:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     2d8:	756f732f 	strbvc	r7, [pc, #-815]!	; ffffffb1 <__bss_end+0xffff62b9>
     2dc:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     2e0:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     2e4:	61707372 	cmnvs	r0, r2, ror r3
     2e8:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
     2ec:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
     2f0:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     2f4:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     2f8:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     2fc:	616f622f 	cmnvs	pc, pc, lsr #4
     300:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
     304:	2f306970 	svccs	0x00306970
     308:	006c6168 	rsbeq	r6, ip, r8, ror #2
     30c:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
     310:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     314:	00010070 	andeq	r0, r1, r0, ror r0
     318:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
     31c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     320:	70730000 	rsbsvc	r0, r3, r0
     324:	6f6c6e69 	svcvs	0x006c6e69
     328:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
     32c:	00000200 	andeq	r0, r0, r0, lsl #4
     330:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     334:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     338:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
     33c:	00000300 	andeq	r0, r0, r0, lsl #6
     340:	636f7270 	cmnvs	pc, #112, 4
     344:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
     348:	00020068 	andeq	r0, r2, r8, rrx
     34c:	6f727000 	svcvs	0x00727000
     350:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     354:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
     358:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     35c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     360:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
     364:	66656474 			; <UNDEFINED> instruction: 0x66656474
     368:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
     36c:	05000000 	streq	r0, [r0, #-0]
     370:	02050001 	andeq	r0, r5, #1
     374:	00008228 	andeq	r8, r0, r8, lsr #4
     378:	a3130517 	tstge	r3, #96468992	; 0x5c00000
     37c:	05501f05 	ldrbeq	r1, [r0, #-3845]	; 0xfffff0fb
     380:	03054a22 	movweq	r4, #23074	; 0x5a22
     384:	4b170582 	blmi	5c1994 <__bss_end+0x5b7c9c>
     388:	05310e05 	ldreq	r0, [r1, #-3589]!	; 0xfffff1fb
     38c:	02022a03 	andeq	r2, r2, #12288	; 0x3000
     390:	98010100 	stmdals	r1, {r8}
     394:	03000002 	movweq	r0, #2
     398:	00015500 	andeq	r5, r1, r0, lsl #10
     39c:	fb010200 	blx	40ba6 <__bss_end+0x36eae>
     3a0:	01000d0e 	tsteq	r0, lr, lsl #26
     3a4:	00010101 	andeq	r0, r1, r1, lsl #2
     3a8:	00010000 	andeq	r0, r1, r0
     3ac:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     3b0:	2f656d6f 	svccs	0x00656d6f
     3b4:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
     3b8:	642f6b69 	strtvs	r6, [pc], #-2921	; 3c0 <shift+0x3c0>
     3bc:	662f7665 	strtvs	r7, [pc], -r5, ror #12
     3c0:	6c616e69 	stclvs	14, cr6, [r1], #-420	; 0xfffffe5c
     3c4:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     3c8:	756f732f 	strbvc	r7, [pc, #-815]!	; a1 <shift+0xa1>
     3cc:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     3d0:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     3d4:	2f62696c 	svccs	0x0062696c
     3d8:	00637273 	rsbeq	r7, r3, r3, ror r2
     3dc:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 328 <shift+0x328>
     3e0:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     3e4:	6b69746e 	blvs	1a5d5a4 <__bss_end+0x1a538ac>
     3e8:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
     3ec:	6e69662f 	cdpvs	6, 6, cr6, cr9, cr15, {1}
     3f0:	732f6c61 			; <UNDEFINED> instruction: 0x732f6c61
     3f4:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
     3f8:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     3fc:	6b2f7365 	blvs	bdd198 <__bss_end+0xbd34a0>
     400:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     404:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     408:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     40c:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
     410:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     414:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     418:	2f656d6f 	svccs	0x00656d6f
     41c:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
     420:	642f6b69 	strtvs	r6, [pc], #-2921	; 428 <shift+0x428>
     424:	662f7665 	strtvs	r7, [pc], -r5, ror #12
     428:	6c616e69 	stclvs	14, cr6, [r1], #-420	; 0xfffffe5c
     42c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     430:	756f732f 	strbvc	r7, [pc, #-815]!	; 109 <shift+0x109>
     434:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     438:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     43c:	2f6c656e 	svccs	0x006c656e
     440:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     444:	2f656475 	svccs	0x00656475
     448:	2f007366 	svccs	0x00007366
     44c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     450:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
     454:	2f6b6974 	svccs	0x006b6974
     458:	2f766564 	svccs	0x00766564
     45c:	616e6966 	cmnvs	lr, r6, ror #18
     460:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     464:	6f732f63 	svcvs	0x00732f63
     468:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     46c:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
     470:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     474:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     478:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     47c:	616f622f 	cmnvs	pc, pc, lsr #4
     480:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
     484:	2f306970 	svccs	0x00306970
     488:	006c6168 	rsbeq	r6, ip, r8, ror #2
     48c:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
     490:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     494:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     498:	00000100 	andeq	r0, r0, r0, lsl #2
     49c:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
     4a0:	00020068 	andeq	r0, r2, r8, rrx
     4a4:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
     4a8:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     4ac:	00682e6b 	rsbeq	r2, r8, fp, ror #28
     4b0:	66000002 	strvs	r0, [r0], -r2
     4b4:	73656c69 	cmnvc	r5, #26880	; 0x6900
     4b8:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     4bc:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     4c0:	70000003 	andvc	r0, r0, r3
     4c4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     4c8:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
     4cc:	00000200 	andeq	r0, r0, r0, lsl #4
     4d0:	636f7270 	cmnvs	pc, #112, 4
     4d4:	5f737365 	svcpl	0x00737365
     4d8:	616e616d 	cmnvs	lr, sp, ror #2
     4dc:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
     4e0:	00020068 	andeq	r0, r2, r8, rrx
     4e4:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     4e8:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
     4ec:	00040068 	andeq	r0, r4, r8, rrx
     4f0:	01050000 	mrseq	r0, (UNDEF: 5)
     4f4:	70020500 	andvc	r0, r2, r0, lsl #10
     4f8:	16000082 	strne	r0, [r0], -r2, lsl #1
     4fc:	05691a05 	strbeq	r1, [r9, #-2565]!	; 0xfffff5fb
     500:	0c052f2c 	stceq	15, cr2, [r5], {44}	; 0x2c
     504:	2f01054c 	svccs	0x0001054c
     508:	691a0585 	ldmdbvs	sl, {r0, r2, r7, r8, sl}
     50c:	052f2c05 	streq	r2, [pc, #-3077]!	; fffff90f <__bss_end+0xffff5c17>
     510:	01054c0c 	tsteq	r5, ip, lsl #24
     514:	3205852f 	andcc	r8, r5, #197132288	; 0xbc00000
     518:	4b1a0583 	blmi	681b2c <__bss_end+0x677e34>
     51c:	852f0105 	strhi	r0, [pc, #-261]!	; 41f <shift+0x41f>
     520:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
     524:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     528:	2e05a132 	mcrcs	1, 0, sl, cr5, cr2, {1}
     52c:	4b1b054b 	blmi	6c1a60 <__bss_end+0x6b7d68>
     530:	052f2d05 	streq	r2, [pc, #-3333]!	; fffff833 <__bss_end+0xffff5b3b>
     534:	01054c0c 	tsteq	r5, ip, lsl #24
     538:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
     53c:	4b3005bd 	blmi	c01c38 <__bss_end+0xbf7f40>
     540:	054b2e05 	strbeq	r2, [fp, #-3589]	; 0xfffff1fb
     544:	2e054b1b 	vmovcs.32	d5[0], r4
     548:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     54c:	852f0105 	strhi	r0, [pc, #-261]!	; 44f <shift+0x44f>
     550:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
     554:	2e054b30 	vmovcs.16	d5[0], r4
     558:	4b1b054b 	blmi	6c1a8c <__bss_end+0x6b7d94>
     55c:	052f2e05 	streq	r2, [pc, #-3589]!	; fffff75f <__bss_end+0xffff5a67>
     560:	01054c0c 	tsteq	r5, ip, lsl #24
     564:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
     568:	4b1b0583 	blmi	6c1b7c <__bss_end+0x6b7e84>
     56c:	852f0105 	strhi	r0, [pc, #-261]!	; 46f <shift+0x46f>
     570:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
     574:	2f054b33 	svccs	0x00054b33
     578:	4b1b054b 	blmi	6c1aac <__bss_end+0x6b7db4>
     57c:	052f3005 	streq	r3, [pc, #-5]!	; 57f <shift+0x57f>
     580:	01054c0c 	tsteq	r5, ip, lsl #24
     584:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
     588:	4b2f05a1 	blmi	bc1c14 <__bss_end+0xbb7f1c>
     58c:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
     590:	0c052f2f 	stceq	15, cr2, [r5], {47}	; 0x2f
     594:	2f01054c 	svccs	0x0001054c
     598:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
     59c:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
     5a0:	1b054b3b 	blne	153294 <__bss_end+0x14959c>
     5a4:	2f30054b 	svccs	0x0030054b
     5a8:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     5ac:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     5b0:	3b05a12f 	blcc	168a74 <__bss_end+0x15ed7c>
     5b4:	4b1a054b 	blmi	681ae8 <__bss_end+0x677df0>
     5b8:	052f3005 	streq	r3, [pc, #-5]!	; 5bb <shift+0x5bb>
     5bc:	01054c0c 	tsteq	r5, ip, lsl #24
     5c0:	2005859f 	mulcs	r5, pc, r5	; <UNPREDICTABLE>
     5c4:	4d2d0567 	cfstr32mi	mvfx0, [sp, #-412]!	; 0xfffffe64
     5c8:	054b3105 	strbeq	r3, [fp, #-261]	; 0xfffffefb
     5cc:	0c054b1a 			; <UNDEFINED> instruction: 0x0c054b1a
     5d0:	2f010530 	svccs	0x00010530
     5d4:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
     5d8:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
     5dc:	1a054b31 	bne	1532a8 <__bss_end+0x1495b0>
     5e0:	300c054b 	andcc	r0, ip, fp, asr #10
     5e4:	852f0105 	strhi	r0, [pc, #-261]!	; 4e7 <shift+0x4e7>
     5e8:	05832005 	streq	r2, [r3, #5]
     5ec:	3e054c2d 	cdpcc	12, 0, cr4, cr5, cr13, {1}
     5f0:	4b1a054b 	blmi	681b24 <__bss_end+0x677e2c>
     5f4:	852f0105 	strhi	r0, [pc, #-261]!	; 4f7 <shift+0x4f7>
     5f8:	05672005 	strbeq	r2, [r7, #-5]!
     5fc:	30054d2d 	andcc	r4, r5, sp, lsr #26
     600:	4b1a054b 	blmi	681b34 <__bss_end+0x677e3c>
     604:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
     608:	05872f01 	streq	r2, [r7, #3841]	; 0xf01
     60c:	059fa00c 	ldreq	sl, [pc, #12]	; 620 <shift+0x620>
     610:	2905bc31 	stmdbcs	r5, {r0, r4, r5, sl, fp, ip, sp, pc}
     614:	2e360566 	cdpcs	5, 3, cr0, cr6, cr6, {3}
     618:	05300f05 	ldreq	r0, [r0, #-3845]!	; 0xfffff0fb
     61c:	09056613 	stmdbeq	r5, {r0, r1, r4, r9, sl, sp, lr}
     620:	d8100584 	ldmdale	r0, {r2, r7, r8, sl}
     624:	059e3305 	ldreq	r3, [lr, #773]	; 0x305
     628:	08022f01 	stmdaeq	r2, {r0, r8, r9, sl, fp, sp}
     62c:	5d010100 	stfpls	f0, [r1, #-0]
     630:	03000005 	movweq	r0, #5
     634:	00005200 	andeq	r5, r0, r0, lsl #4
     638:	fb010200 	blx	40e42 <__bss_end+0x3714a>
     63c:	01000d0e 	tsteq	r0, lr, lsl #26
     640:	00010101 	andeq	r0, r1, r1, lsl #2
     644:	00010000 	andeq	r0, r1, r0
     648:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     64c:	2f656d6f 	svccs	0x00656d6f
     650:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
     654:	642f6b69 	strtvs	r6, [pc], #-2921	; 65c <shift+0x65c>
     658:	662f7665 	strtvs	r7, [pc], -r5, ror #12
     65c:	6c616e69 	stclvs	14, cr6, [r1], #-420	; 0xfffffe5c
     660:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     664:	756f732f 	strbvc	r7, [pc, #-815]!	; 33d <shift+0x33d>
     668:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     66c:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     670:	2f62696c 	svccs	0x0062696c
     674:	00637273 	rsbeq	r7, r3, r3, ror r2
     678:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
     67c:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
     680:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
     684:	01007070 	tsteq	r0, r0, ror r0
     688:	05000000 	streq	r0, [r0, #-0]
     68c:	02050021 	andeq	r0, r5, #33	; 0x21
     690:	00008700 	andeq	r8, r0, r0, lsl #14
     694:	9f090518 	svcls	0x00090518
     698:	054b1105 	strbeq	r1, [fp, #-261]	; 0xfffffefb
     69c:	10056614 	andne	r6, r5, r4, lsl r6
     6a0:	810505bb 			; <UNDEFINED> instruction: 0x810505bb
     6a4:	05310c05 	ldreq	r0, [r1, #-3077]!	; 0xfffff3fb
     6a8:	1d052f01 	stcne	15, cr2, [r5, #-4]
     6ac:	a20a0584 	andge	r0, sl, #132, 10	; 0x21000000
     6b0:	05670505 	strbeq	r0, [r7, #-1285]!	; 0xfffffafb
     6b4:	0b05830e 	bleq	1612f4 <__bss_end+0x1575fc>
     6b8:	690d0567 	stmdbvs	sp, {r0, r1, r2, r5, r6, r8, sl}
     6bc:	9f4b0c05 	svcls	0x004b0c05
     6c0:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
     6c4:	15056917 	strne	r6, [r5, #-2327]	; 0xfffff6e9
     6c8:	4a2e0566 	bmi	b81c68 <__bss_end+0xb77f70>
     6cc:	02003e05 	andeq	r3, r0, #5, 28	; 0x50
     6d0:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     6d4:	0402003c 	streq	r0, [r2], #-60	; 0xffffffc4
     6d8:	2e056601 	cfmadd32cs	mvax0, mvfx6, mvfx5, mvfx1
     6dc:	01040200 	mrseq	r0, R12_usr
     6e0:	672b054a 	strvs	r0, [fp, -sl, asr #10]!
     6e4:	054a1c05 	strbeq	r1, [sl, #-3077]	; 0xfffff3fb
     6e8:	11058215 	tstne	r5, r5, lsl r2
     6ec:	6710052e 	ldrvs	r0, [r0, -lr, lsr #10]
     6f0:	7e0505a0 	cfsh32vc	mvfx0, mvfx5, #-48
     6f4:	05361605 	ldreq	r1, [r6, #-1541]!	; 0xfffff9fb
     6f8:	1105d61b 	tstne	r5, fp, lsl r6
     6fc:	00260582 	eoreq	r0, r6, r2, lsl #11
     700:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
     704:	02000b05 	andeq	r0, r0, #5120	; 0x1400
     708:	059f0204 	ldreq	r0, [pc, #516]	; 914 <shift+0x914>
     70c:	04020005 	streq	r0, [r2], #-5
     710:	0e058102 	mvfeqs	f0, f2
     714:	4b1505f5 	blmi	541ef0 <__bss_end+0x5381f8>
     718:	05661905 	strbeq	r1, [r6, #-2309]!	; 0xfffff6fb
     71c:	054b9e0c 	strbeq	r9, [fp, #-3596]	; 0xfffff1f4
     720:	0f059f05 	svceq	0x00059f05
     724:	d7110583 	ldrle	r0, [r1, -r3, lsl #11]
     728:	05d90c05 	ldrbeq	r0, [r9, #3077]	; 0xc05
     72c:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
     730:	0f054a01 	svceq	0x00054a01
     734:	2e090583 	cfsh32cs	mvfx0, mvfx9, #-61
     738:	05831005 	streq	r1, [r3, #5]
     73c:	14056612 	strne	r6, [r5], #-1554	; 0xfffff9ee
     740:	2e0e0567 	cfsh32cs	mvfx0, mvfx14, #55
     744:	05831005 	streq	r1, [r3, #5]
     748:	0e056612 	mcreq	6, 0, r6, cr5, cr2, {0}
     74c:	001e0567 	andseq	r0, lr, r7, ror #10
     750:	82010402 	andhi	r0, r1, #33554432	; 0x2000000
     754:	05671005 	strbeq	r1, [r7, #-5]!
     758:	1c056612 	stcne	6, cr6, [r5], {18}
     75c:	82220568 	eorhi	r0, r2, #104, 10	; 0x1a000000
     760:	052e1005 	streq	r1, [lr, #-5]!
     764:	12056622 	andne	r6, r5, #35651584	; 0x2200000
     768:	2f14054a 	svccs	0x0014054a
     76c:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
     770:	77030204 	strvc	r0, [r3, -r4, lsl #4]
     774:	030105d6 	movweq	r0, #5590	; 0x15d6
     778:	1b059e0c 	blne	167fb0 <__bss_end+0x15e2b8>
     77c:	830b05a2 	movwhi	r0, #46498	; 0xb5a2
     780:	054b0905 	strbeq	r0, [fp, #-2309]	; 0xfffff6fb
     784:	11054c13 	tstne	r5, r3, lsl ip
     788:	2e0f0566 	cfsh32cs	mvfx0, mvfx15, #54
     78c:	002e1f05 	eoreq	r1, lr, r5, lsl #30
     790:	06010402 	streq	r0, [r1], -r2, lsl #8
     794:	00220566 	eoreq	r0, r2, r6, ror #10
     798:	06030402 	streq	r0, [r3], -r2, lsl #8
     79c:	001f0566 	andseq	r0, pc, r6, ror #10
     7a0:	66050402 	strvs	r0, [r5], -r2, lsl #8
     7a4:	06040200 	streq	r0, [r4], -r0, lsl #4
     7a8:	02004a06 	andeq	r4, r0, #24576	; 0x6000
     7ac:	052e0804 	streq	r0, [lr, #-2052]!	; 0xfffff7fc
     7b0:	054b060f 	strbeq	r0, [fp, #-1551]	; 0xfffff9f1
     7b4:	1605821b 			; <UNDEFINED> instruction: 0x1605821b
     7b8:	660b054a 	strvs	r0, [fp], -sl, asr #10
     7bc:	31490505 	cmpcc	r9, r5, lsl #10
     7c0:	05671705 	strbeq	r1, [r7, #-1797]!	; 0xfffff8fb
     7c4:	13056615 	movwne	r6, #22037	; 0x5615
     7c8:	2e23052e 	cfsh64cs	mvdx0, mvdx3, #30
     7cc:	01040200 	mrseq	r0, R12_usr
     7d0:	26056606 	strcs	r6, [r5], -r6, lsl #12
     7d4:	03040200 	movweq	r0, #16896	; 0x4200
     7d8:	23056606 	movwcs	r6, #22022	; 0x5606
     7dc:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
     7e0:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
     7e4:	004a0606 	subeq	r0, sl, r6, lsl #12
     7e8:	2e080402 	cdpcs	4, 0, cr0, cr8, cr2, {0}
     7ec:	4b061305 	blmi	185408 <__bss_end+0x17b710>
     7f0:	05821f05 	streq	r1, [r2, #3845]	; 0xf05
     7f4:	0f054a1a 	svceq	0x00054a1a
     7f8:	09054b66 	stmdbeq	r5, {r1, r2, r5, r6, r8, r9, fp, lr}
     7fc:	33050564 	movwcc	r0, #21860	; 0x5564
     800:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
     804:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     808:	054b670d 	strbeq	r6, [fp, #-1805]	; 0xfffff8f3
     80c:	0d054b0f 	vstreq	d4, [r5, #-60]	; 0xffffffc4
     810:	2e0b0566 	cfsh32cs	mvfx0, mvfx11, #54
     814:	052f0905 	streq	r0, [pc, #-2309]!	; ffffff17 <__bss_end+0xffff621f>
     818:	11056713 	tstne	r5, r3, lsl r7
     81c:	2e0f0566 	cfsh32cs	mvfx0, mvfx15, #54
     820:	054b0e05 	strbeq	r0, [fp, #-3589]	; 0xfffff1fb
     824:	11056713 	tstne	r5, r3, lsl r7
     828:	2e0f0566 	cfsh32cs	mvfx0, mvfx15, #54
     82c:	052f1205 	streq	r1, [pc, #-517]!	; 62f <shift+0x62f>
     830:	02004c10 	andeq	r4, r0, #16, 24	; 0x1000
     834:	66060104 	strvs	r0, [r6], -r4, lsl #2
     838:	67061305 	strvs	r1, [r6, -r5, lsl #6]
     83c:	05ba1d05 	ldreq	r1, [sl, #3333]!	; 0xd05
     840:	13054a0f 	movwne	r4, #23055	; 0x5a0f
     844:	6611054b 	ldrvs	r0, [r1], -fp, asr #10
     848:	052e0f05 	streq	r0, [lr, #-3845]!	; 0xfffff0fb
     84c:	10052c09 	andne	r2, r5, r9, lsl #24
     850:	660b0532 			; <UNDEFINED> instruction: 0x660b0532
     854:	05680e05 	strbeq	r0, [r8, #-3589]!	; 0xfffff1fb
     858:	0a05670b 	beq	15a48c <__bss_end+0x150794>
     85c:	64050583 	strvs	r0, [r5], #-1411	; 0xfffffa7d
     860:	05320e05 	ldreq	r0, [r2, #-3589]!	; 0xfffff1fb
     864:	0a05670b 	beq	15a498 <__bss_end+0x1507a0>
     868:	640505bb 	strvs	r0, [r5], #-1467	; 0xfffffa45
     86c:	05320c05 	ldreq	r0, [r2, #-3077]!	; 0xfffff3fb
     870:	40054b01 	andmi	r4, r5, r1, lsl #22
     874:	09052208 	stmdbeq	r5, {r3, r9, sp}
     878:	4c1205bb 	cfldr32mi	mvfx0, [r2], {187}	; 0xbb
     87c:	05672705 	strbeq	r2, [r7, #-1797]!	; 0xfffff8fb
     880:	2d05ba11 	vstrcs	s22, [r5, #-68]	; 0xffffffbc
     884:	4a130566 	bmi	4c1e24 <__bss_end+0x4b812c>
     888:	052f0f05 	streq	r0, [pc, #-3845]!	; fffff98b <__bss_end+0xffff5c93>
     88c:	05059f0a 	streq	r9, [r5, #-3850]	; 0xfffff0f6
     890:	11053463 	tstne	r5, r3, ror #8
     894:	66220567 	strtvs	r0, [r2], -r7, ror #10
     898:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
     89c:	0d052f0a 	stceq	15, cr2, [r5, #-40]	; 0xffffffd8
     8a0:	660f0569 	strvs	r0, [pc], -r9, ror #10
     8a4:	054b0605 	strbeq	r0, [fp, #-1541]	; 0xfffff9fb
     8a8:	1c05680e 	stcne	8, cr6, [r5], {14}
     8ac:	03040200 	movweq	r0, #16896	; 0x4200
     8b0:	0017054a 	andseq	r0, r7, sl, asr #10
     8b4:	9e030402 	cdpls	4, 0, cr0, cr3, cr2, {0}
     8b8:	02001b05 	andeq	r1, r0, #5120	; 0x1400
     8bc:	05670204 	strbeq	r0, [r7, #-516]!	; 0xfffffdfc
     8c0:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
     8c4:	0e058202 	cdpeq	2, 0, cr8, cr5, cr2, {0}
     8c8:	02040200 	andeq	r0, r4, #0, 4
     8cc:	0021054a 	eoreq	r0, r1, sl, asr #10
     8d0:	4b020402 	blmi	818e0 <__bss_end+0x77be8>
     8d4:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
     8d8:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
     8dc:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
     8e0:	21058202 	tstcs	r5, r2, lsl #4
     8e4:	02040200 	andeq	r0, r4, #0, 4
     8e8:	0017054a 	andseq	r0, r7, sl, asr #10
     8ec:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     8f0:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
     8f4:	052f0204 	streq	r0, [pc, #-516]!	; 6f8 <shift+0x6f8>
     8f8:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
     8fc:	05056602 	streq	r6, [r5, #-1538]	; 0xfffff9fe
     900:	02040200 	andeq	r0, r4, #0, 4
     904:	87010547 	strhi	r0, [r1, -r7, asr #10]
     908:	05841d05 	streq	r1, [r4, #3333]	; 0xd05
     90c:	0c058309 	stceq	3, cr8, [r5], {9}
     910:	4a13054c 	bmi	4c1e48 <__bss_end+0x4b8150>
     914:	054b1005 	strbeq	r1, [fp, #-5]
     918:	0905bb0d 	stmdbeq	r5, {r0, r2, r3, r8, r9, fp, ip, sp, pc}
     91c:	001d054a 	andseq	r0, sp, sl, asr #10
     920:	4a010402 	bmi	41930 <__bss_end+0x37c38>
     924:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     928:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
     92c:	1a054d13 	bne	153d80 <__bss_end+0x14a088>
     930:	2e10054a 	cfmac32cs	mvfx0, mvfx0, mvfx10
     934:	05680e05 	strbeq	r0, [r8, #-3589]!	; 0xfffff1fb
     938:	66790305 	ldrbtvs	r0, [r9], -r5, lsl #6
     93c:	0a030c05 	beq	c3958 <__bss_end+0xb9c60>
     940:	2f01052e 	svccs	0x0001052e
     944:	05843505 	streq	r3, [r4, #1285]	; 0x505
     948:	1905bd0c 	stmdbne	r5, {r2, r3, r8, sl, fp, ip, sp, pc}
     94c:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     950:	0021054a 	eoreq	r0, r1, sl, asr #10
     954:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
     958:	02001905 	andeq	r1, r0, #81920	; 0x14000
     95c:	05820204 	streq	r0, [r2, #516]	; 0x204
     960:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
     964:	0f054b03 	svceq	0x00054b03
     968:	03040200 	movweq	r0, #16896	; 0x4200
     96c:	00180566 	andseq	r0, r8, r6, ror #10
     970:	66030402 	strvs	r0, [r3], -r2, lsl #8
     974:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
     978:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
     97c:	04020005 	streq	r0, [r2], #-5
     980:	0e052d03 	cdpeq	13, 0, cr2, cr5, cr3, {0}
     984:	02040200 	andeq	r0, r4, #0, 4
     988:	000f0584 	andeq	r0, pc, r4, lsl #11
     98c:	83010402 	movwhi	r0, #5122	; 0x1402
     990:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
     994:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     998:	04020005 	streq	r0, [r2], #-5
     99c:	0c054901 			; <UNDEFINED> instruction: 0x0c054901
     9a0:	2f010585 	svccs	0x00010585
     9a4:	05843605 	streq	r3, [r4, #1541]	; 0x605
     9a8:	1205bc0f 	andne	fp, r5, #3840	; 0xf00
     9ac:	bb210566 	bllt	841f4c <__bss_end+0x838254>
     9b0:	05660c05 	strbeq	r0, [r6, #-3077]!	; 0xfffff3fb
     9b4:	0c054b21 			; <UNDEFINED> instruction: 0x0c054b21
     9b8:	4b090566 	blmi	241f58 <__bss_end+0x238260>
     9bc:	05831705 	streq	r1, [r3, #1797]	; 0x705
     9c0:	09054a19 	stmdbeq	r5, {r0, r3, r4, r9, fp, lr}
     9c4:	6714054b 	ldrvs	r0, [r4, -fp, asr #10]
     9c8:	054d0c05 	strbeq	r0, [sp, #-3077]	; 0xfffff3fb
     9cc:	1b052f01 	blne	14c5d8 <__bss_end+0x1428e0>
     9d0:	83090584 	movwhi	r0, #38276	; 0x9584
     9d4:	054c0f05 	strbeq	r0, [ip, #-3845]	; 0xfffff0fb
     9d8:	0a058211 	beq	161224 <__bss_end+0x15752c>
     9dc:	6505054b 	strvs	r0, [r5, #-1355]	; 0xfffffab5
     9e0:	05310c05 	ldreq	r0, [r1, #-3077]!	; 0xfffff3fb
     9e4:	37052f01 	strcc	r2, [r5, -r1, lsl #30]
     9e8:	bb090584 	bllt	242000 <__bss_end+0x238308>
     9ec:	054c1405 	strbeq	r1, [ip, #-1029]	; 0xfffffbfb
     9f0:	15058216 	strne	r8, [r5, #-534]	; 0xfffffdea
     9f4:	8209054b 	andhi	r0, r9, #314572800	; 0x12c00000
     9f8:	05671405 	strbeq	r1, [r7, #-1029]!	; 0xfffffbfb
     9fc:	05054b0a 	streq	r4, [r5, #-2826]	; 0xfffff4f6
     a00:	330c0563 	movwcc	r0, #50531	; 0xc563
     a04:	052f0105 	streq	r0, [pc, #-261]!	; 907 <shift+0x907>
     a08:	0b058426 	bleq	161aa8 <__bss_end+0x157db0>
     a0c:	4c0e059f 	cfstr32mi	mvfx0, [lr], {159}	; 0x9f
     a10:	02001705 	andeq	r1, r0, #1310720	; 0x140000
     a14:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     a18:	0402000e 	streq	r0, [r2], #-14
     a1c:	10058302 	andne	r8, r5, r2, lsl #6
     a20:	02040200 	andeq	r0, r4, #0, 4
     a24:	00050566 	andeq	r0, r5, r6, ror #10
     a28:	49020402 	stmdbmi	r2, {r1, sl}
     a2c:	05840105 	streq	r0, [r4, #261]	; 0x105
     a30:	11058432 	tstne	r5, r2, lsr r4
     a34:	4b0b05bb 	blmi	2c2128 <__bss_end+0x2b8430>
     a38:	054c0e05 	strbeq	r0, [ip, #-3589]	; 0xfffff1fb
     a3c:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
     a40:	1d054a03 	vstrne	s8, [r5, #-12]
     a44:	02040200 	andeq	r0, r4, #0, 4
     a48:	00110583 	andseq	r0, r1, r3, lsl #11
     a4c:	66020402 	strvs	r0, [r2], -r2, lsl #8
     a50:	02001d05 	andeq	r1, r0, #320	; 0x140
     a54:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
     a58:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
     a5c:	05052e02 	streq	r2, [r5, #-3586]	; 0xfffff1fe
     a60:	02040200 	andeq	r0, r4, #0, 4
     a64:	8401052d 	strhi	r0, [r1], #-1325	; 0xfffffad3
     a68:	9f841705 	svcls	0x00841705
     a6c:	01040200 	mrseq	r0, R12_usr
     a70:	02006606 	andeq	r6, r0, #6291456	; 0x600000
     a74:	00660304 	rsbeq	r0, r6, r4, lsl #6
     a78:	4a040402 	bmi	101a88 <__bss_end+0xf7d90>
     a7c:	02000105 	andeq	r0, r0, #1073741825	; 0x40000001
     a80:	2f060604 	svccs	0x00060604
     a84:	05842205 	streq	r2, [r4, #517]	; 0x205
     a88:	0505830a 	streq	r8, [r5, #-778]	; 0xfffffcf6
     a8c:	001b0567 	andseq	r0, fp, r7, ror #10
     a90:	66010402 	strvs	r0, [r1], -r2, lsl #8
     a94:	054c0905 	strbeq	r0, [ip, #-2309]	; 0xfffff6fb
     a98:	09054c12 	stmdbeq	r5, {r1, r4, sl, fp, lr}
     a9c:	4a050582 	bmi	1420ac <__bss_end+0x1383b4>
     aa0:	054b0905 	strbeq	r0, [fp, #-2309]	; 0xfffff6fb
     aa4:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
     aa8:	14056601 	strne	r6, [r5], #-1537	; 0xfffff9ff
     aac:	4d0d0567 	cfstr32mi	mvfx0, [sp, #-412]	; 0xfffffe64
     ab0:	05690905 	strbeq	r0, [r9, #-2309]!	; 0xfffff6fb
     ab4:	13054b11 	movwne	r4, #23313	; 0x5b11
     ab8:	4b1c0582 	blmi	7020c8 <__bss_end+0x6f83d0>
     abc:	05661605 	strbeq	r1, [r6, #-1541]!	; 0xfffff9fb
     ac0:	0905820d 	stmdbeq	r5, {r0, r2, r3, r9, pc}
     ac4:	4b14054a 	blmi	501ff4 <__bss_end+0x4f82fc>
     ac8:	054c0d05 	strbeq	r0, [ip, #-3333]	; 0xfffff2fb
     acc:	0505670a 	streq	r6, [r5, #-1802]	; 0xfffff8f6
     ad0:	10053661 	andne	r3, r5, r1, ror #12
     ad4:	4d0c0567 	cfstr32mi	mvfx0, [ip, #-412]	; 0xfffffe64
     ad8:	052f0105 	streq	r0, [pc, #-261]!	; 9db <shift+0x9db>
     adc:	0a056820 	beq	15ab64 <__bss_end+0x150e6c>
     ae0:	09056783 	stmdbeq	r5, {r0, r1, r7, r8, r9, sl, sp, lr}
     ae4:	05054b4b 	streq	r4, [r5, #-2891]	; 0xfffff4b5
     ae8:	001b054c 	andseq	r0, fp, ip, asr #10
     aec:	66010402 	strvs	r0, [r1], -r2, lsl #8
     af0:	054c1e05 	strbeq	r1, [ip, #-3589]	; 0xfffff1fb
     af4:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
     af8:	2a056601 	bcs	15a304 <__bss_end+0x15060c>
     afc:	03040200 	movweq	r0, #16896	; 0x4200
     b00:	00210566 	eoreq	r0, r1, r6, ror #10
     b04:	82030402 	andhi	r0, r3, #33554432	; 0x2000000
     b08:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
     b0c:	004a0304 	subeq	r0, sl, r4, lsl #6
     b10:	06050402 	streq	r0, [r5], -r2, lsl #8
     b14:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
     b18:	05054a06 	streq	r4, [r5, #-2566]	; 0xfffff5fa
     b1c:	08040200 	stmdaeq	r4, {r9}
     b20:	36052e06 	strcc	r2, [r5], -r6, lsl #28
     b24:	09040200 	stmdbeq	r4, {r9}
     b28:	4c11054a 	cfldr32mi	mvfx0, [r1], {74}	; 0x4a
     b2c:	05820505 	streq	r0, [r2, #1285]	; 0x505
     b30:	09054b15 	stmdbeq	r5, {r0, r2, r4, r8, r9, fp, lr}
     b34:	4b110569 	blmi	4420e0 <__bss_end+0x4383e8>
     b38:	05821305 	streq	r1, [r2, #773]	; 0x305
     b3c:	16054b1c 			; <UNDEFINED> instruction: 0x16054b1c
     b40:	820d0566 	andhi	r0, sp, #427819008	; 0x19800000
     b44:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
     b48:	0d054b16 	vstreq	d4, [r5, #-88]	; 0xffffffa8
     b4c:	00280582 	eoreq	r0, r8, r2, lsl #11
     b50:	4a010402 	bmi	41b60 <__bss_end+0x37e68>
     b54:	02001f05 	andeq	r1, r0, #5, 30
     b58:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     b5c:	18054b17 	stmdane	r5, {r0, r1, r2, r4, r8, r9, fp, lr}
     b60:	4d0d0568 	cfstr32mi	mvfx0, [sp, #-416]	; 0xfffffe60
     b64:	05671c05 	strbeq	r1, [r7, #-3077]!	; 0xfffff3fb
     b68:	0a05841d 	beq	161be4 <__bss_end+0x157eec>
     b6c:	03050569 	movweq	r0, #21865	; 0x5569
     b70:	11036672 	tstne	r3, r2, ror r6
     b74:	6710052e 	ldrvs	r0, [r0, -lr, lsr #10]
     b78:	054d0505 	strbeq	r0, [sp, #-1285]	; 0xfffffafb
     b7c:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
     b80:	10056601 	andne	r6, r5, r1, lsl #12
     b84:	4d0c0567 	cfstr32mi	mvfx0, [ip, #-412]	; 0xfffffe64
     b88:	022f0105 	eoreq	r0, pc, #1073741825	; 0x40000001
     b8c:	01010006 	tsteq	r1, r6
     b90:	00000079 	andeq	r0, r0, r9, ror r0
     b94:	00460003 	subeq	r0, r6, r3
     b98:	01020000 	mrseq	r0, (UNDEF: 2)
     b9c:	000d0efb 	strdeq	r0, [sp], -fp
     ba0:	01010101 	tsteq	r1, r1, lsl #2
     ba4:	01000000 	mrseq	r0, (UNDEF: 0)
     ba8:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
     bac:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     bb0:	2f2e2e2f 	svccs	0x002e2e2f
     bb4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     bb8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     bbc:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
     bc0:	2f636367 	svccs	0x00636367
     bc4:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
     bc8:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
     bcc:	00006d72 	andeq	r6, r0, r2, ror sp
     bd0:	3162696c 	cmncc	r2, ip, ror #18
     bd4:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
     bd8:	00532e73 	subseq	r2, r3, r3, ror lr
     bdc:	00000001 	andeq	r0, r0, r1
     be0:	9c020500 	cfstr32ls	mvfx0, [r2], {-0}
     be4:	03000095 	movweq	r0, #149	; 0x95
     be8:	300108fd 	strdcc	r0, [r1], -sp
     bec:	2f2f2f2f 	svccs	0x002f2f2f
     bf0:	d002302f 	andle	r3, r2, pc, lsr #32
     bf4:	312f1401 			; <UNDEFINED> instruction: 0x312f1401
     bf8:	4c302f2f 	ldcmi	15, cr2, [r0], #-188	; 0xffffff44
     bfc:	1f03322f 	svcne	0x0003322f
     c00:	2f2f2f66 	svccs	0x002f2f66
     c04:	2f2f2f2f 	svccs	0x002f2f2f
     c08:	01000202 	tsteq	r0, r2, lsl #4
     c0c:	00005c01 	andeq	r5, r0, r1, lsl #24
     c10:	46000300 	strmi	r0, [r0], -r0, lsl #6
     c14:	02000000 	andeq	r0, r0, #0
     c18:	0d0efb01 	vstreq	d15, [lr, #-4]
     c1c:	01010100 	mrseq	r0, (UNDEF: 17)
     c20:	00000001 	andeq	r0, r0, r1
     c24:	01000001 	tsteq	r0, r1
     c28:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     c2c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     c30:	2f2e2e2f 	svccs	0x002e2e2f
     c34:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     c38:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
     c3c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     c40:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
     c44:	2f676966 	svccs	0x00676966
     c48:	006d7261 	rsbeq	r7, sp, r1, ror #4
     c4c:	62696c00 	rsbvs	r6, r9, #0, 24
     c50:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
     c54:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
     c58:	00000100 	andeq	r0, r0, r0, lsl #2
     c5c:	02050000 	andeq	r0, r5, #0
     c60:	000097a8 	andeq	r9, r0, r8, lsr #15
     c64:	010be703 	tsteq	fp, r3, lsl #14
     c68:	01000202 	tsteq	r0, r2, lsl #4
     c6c:	0000fb01 	andeq	pc, r0, r1, lsl #22
     c70:	47000300 	strmi	r0, [r0, -r0, lsl #6]
     c74:	02000000 	andeq	r0, r0, #0
     c78:	0d0efb01 	vstreq	d15, [lr, #-4]
     c7c:	01010100 	mrseq	r0, (UNDEF: 17)
     c80:	00000001 	andeq	r0, r0, r1
     c84:	01000001 	tsteq	r0, r1
     c88:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     c8c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     c90:	2f2e2e2f 	svccs	0x002e2e2f
     c94:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     c98:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
     c9c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     ca0:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
     ca4:	2f676966 	svccs	0x00676966
     ca8:	006d7261 	rsbeq	r7, sp, r1, ror #4
     cac:	65656900 	strbvs	r6, [r5, #-2304]!	; 0xfffff700
     cb0:	34353765 	ldrtcc	r3, [r5], #-1893	; 0xfffff89b
     cb4:	2e66732d 	cdpcs	3, 6, cr7, cr6, cr13, {1}
     cb8:	00010053 	andeq	r0, r1, r3, asr r0
     cbc:	05000000 	streq	r0, [r0, #-0]
     cc0:	0097ac02 	addseq	sl, r7, r2, lsl #24
     cc4:	013a0300 	teqeq	sl, r0, lsl #6
     cc8:	0903332f 	stmdbeq	r3, {r0, r1, r2, r3, r5, r8, r9, ip, sp}
     ccc:	2f2f302e 	svccs	0x002f302e
     cd0:	2f322f2f 	svccs	0x00322f2f
     cd4:	2f2f2f30 	svccs	0x002f2f30
     cd8:	31303330 	teqcc	r0, r0, lsr r3
     cdc:	2f302f2f 	svccs	0x00302f2f
     ce0:	32302f2f 	eorscc	r2, r0, #47, 30	; 0xbc
     ce4:	2f32322f 	svccs	0x0032322f
     ce8:	332f312f 			; <UNDEFINED> instruction: 0x332f312f
     cec:	2f2f332f 	svccs	0x002f332f
     cf0:	2f2f312f 	svccs	0x002f312f
     cf4:	2f352f31 	svccs	0x00352f31
     cf8:	322f2f30 	eorcc	r2, pc, #48, 30	; 0xc0
     cfc:	2f2f2f2f 	svccs	0x002f2f2f
     d00:	2f2e1903 	svccs	0x002e1903
     d04:	2f352f2f 	svccs	0x00352f2f
     d08:	3330342f 	teqcc	r0, #788529152	; 0x2f000000
     d0c:	2f2f302f 	svccs	0x002f302f
     d10:	3030312f 	eorscc	r3, r0, pc, lsr #2
     d14:	312f302f 			; <UNDEFINED> instruction: 0x312f302f
     d18:	32302f30 	eorscc	r2, r0, #48, 30	; 0xc0
     d1c:	2f2f312f 	svccs	0x002f312f
     d20:	302f2f30 	eorcc	r2, pc, r0, lsr pc	; <UNPREDICTABLE>
     d24:	2f322f2f 	svccs	0x00322f2f
     d28:	2e09032f 	cdpcs	3, 0, cr0, cr9, cr15, {1}
     d2c:	2f2f2f30 	svccs	0x002f2f30
     d30:	2f2f2f30 	svccs	0x002f2f30
     d34:	2f2e0d03 	svccs	0x002e0d03
     d38:	30303033 	eorscc	r3, r0, r3, lsr r0
     d3c:	2f303131 	svccs	0x00303131
     d40:	302e0c03 	eorcc	r0, lr, r3, lsl #24
     d44:	30332f30 	eorscc	r2, r3, r0, lsr pc
     d48:	2f332f30 	svccs	0x00332f30
     d4c:	2f2f3031 	svccs	0x002f3031
     d50:	032f3031 			; <UNDEFINED> instruction: 0x032f3031
     d54:	322f2e19 	eorcc	r2, pc, #400	; 0x190
     d58:	2f2f302f 	svccs	0x002f302f
     d5c:	2f302f2f 	svccs	0x00302f2f
     d60:	2f2f2f30 	svccs	0x002f2f30
     d64:	022f302f 	eoreq	r3, pc, #47	; 0x2f
     d68:	01010002 	tsteq	r1, r2
     d6c:	0000007a 	andeq	r0, r0, sl, ror r0
     d70:	00420003 	subeq	r0, r2, r3
     d74:	01020000 	mrseq	r0, (UNDEF: 2)
     d78:	000d0efb 	strdeq	r0, [sp], -fp
     d7c:	01010101 	tsteq	r1, r1, lsl #2
     d80:	01000000 	mrseq	r0, (UNDEF: 0)
     d84:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
     d88:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     d8c:	2f2e2e2f 	svccs	0x002e2e2f
     d90:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     d94:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     d98:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
     d9c:	2f636367 	svccs	0x00636367
     da0:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
     da4:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
     da8:	00006d72 	andeq	r6, r0, r2, ror sp
     dac:	62617062 	rsbvs	r7, r1, #98	; 0x62
     db0:	00532e69 	subseq	r2, r3, r9, ror #28
     db4:	00000001 	andeq	r0, r0, r1
     db8:	fc020500 	stc2	5, cr0, [r2], {-0}
     dbc:	03000099 	movweq	r0, #153	; 0x99
     dc0:	080101b9 	stmdaeq	r1, {r0, r3, r4, r5, r7, r8}
     dc4:	2f2f4b5a 	svccs	0x002f4b5a
     dc8:	6730302f 	ldrvs	r3, [r0, -pc, lsr #32]!
     dcc:	2f2f2f32 	svccs	0x002f2f32
     dd0:	2f673030 	svccs	0x00673030
     dd4:	322f2f2f 	eorcc	r2, pc, #47, 30	; 0xbc
     dd8:	6730302f 	ldrvs	r3, [r0, -pc, lsr #32]!
     ddc:	2f322f2f 	svccs	0x00322f2f
     de0:	2f672f30 	svccs	0x00672f30
     de4:	0002022f 	andeq	r0, r2, pc, lsr #4
     de8:	01030101 	tsteq	r3, r1, lsl #2
     dec:	00030000 	andeq	r0, r3, r0
     df0:	000000fd 	strdeq	r0, [r0], -sp
     df4:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     df8:	0101000d 	tsteq	r1, sp
     dfc:	00000101 	andeq	r0, r0, r1, lsl #2
     e00:	00000100 	andeq	r0, r0, r0, lsl #2
     e04:	2f2e2e01 	svccs	0x002e2e01
     e08:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     e0c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     e10:	2f2e2e2f 	svccs	0x002e2e2f
     e14:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; d64 <shift+0xd64>
     e18:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     e1c:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
     e20:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     e24:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     e28:	2f2e2e00 	svccs	0x002e2e00
     e2c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     e30:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     e34:	2f2e2e2f 	svccs	0x002e2e2f
     e38:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
     e3c:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
     e40:	2f2e2e2f 	svccs	0x002e2e2f
     e44:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     e48:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     e4c:	2f2e2e2f 	svccs	0x002e2e2f
     e50:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     e54:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
     e58:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
     e5c:	6f632f63 	svcvs	0x00632f63
     e60:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
     e64:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
     e68:	2f2e2e00 	svccs	0x002e2e00
     e6c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     e70:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     e74:	2f2e2e2f 	svccs	0x002e2e2f
     e78:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; dc8 <shift+0xdc8>
     e7c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     e80:	68000063 	stmdavs	r0, {r0, r1, r5, r6}
     e84:	74687361 	strbtvc	r7, [r8], #-865	; 0xfffffc9f
     e88:	682e6261 	stmdavs	lr!, {r0, r5, r6, r9, sp, lr}
     e8c:	00000100 	andeq	r0, r0, r0, lsl #2
     e90:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
     e94:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
     e98:	00020068 	andeq	r0, r2, r8, rrx
     e9c:	6d726100 	ldfvse	f6, [r2, #-0]
     ea0:	7570632d 	ldrbvc	r6, [r0, #-813]!	; 0xfffffcd3
     ea4:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     ea8:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
     eac:	632d6e73 			; <UNDEFINED> instruction: 0x632d6e73
     eb0:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
     eb4:	73746e61 	cmnvc	r4, #1552	; 0x610
     eb8:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     ebc:	72610000 	rsbvc	r0, r1, #0
     ec0:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     ec4:	6c000003 	stcvs	0, cr0, [r0], {3}
     ec8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     ecc:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
     ed0:	00000400 	andeq	r0, r0, r0, lsl #8
     ed4:	2d6c6267 	sfmcs	f6, 2, [ip, #-412]!	; 0xfffffe64
     ed8:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
     edc:	00682e73 	rsbeq	r2, r8, r3, ror lr
     ee0:	6c000004 	stcvs	0, cr0, [r0], {4}
     ee4:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     ee8:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
     eec:	00000400 	andeq	r0, r0, r0, lsl #8
     ef0:	00012a00 	andeq	r2, r1, r0, lsl #20
     ef4:	ee000300 	cdp	3, 0, cr0, cr0, cr0, {0}
     ef8:	02000000 	andeq	r0, r0, #0
     efc:	0d0efb01 	vstreq	d15, [lr, #-4]
     f00:	01010100 	mrseq	r0, (UNDEF: 17)
     f04:	00000001 	andeq	r0, r0, r1
     f08:	01000001 	tsteq	r0, r1
     f0c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     f10:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     f14:	2f2e2e2f 	svccs	0x002e2e2f
     f18:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     f1c:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
     f20:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     f24:	2f2e2e00 	svccs	0x002e2e00
     f28:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     f2c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     f30:	2f2e2e2f 	svccs	0x002e2e2f
     f34:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; e84 <shift+0xe84>
     f38:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     f3c:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
     f40:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     f44:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     f48:	2f2e2e00 	svccs	0x002e2e00
     f4c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     f50:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     f54:	2f2e2e2f 	svccs	0x002e2e2f
     f58:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
     f5c:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
     f60:	2f2e2e2f 	svccs	0x002e2e2f
     f64:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
     f68:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
     f6c:	2f2e2e2f 	svccs	0x002e2e2f
     f70:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
     f74:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
     f78:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
     f7c:	6f632f63 	svcvs	0x00632f63
     f80:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
     f84:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
     f88:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
     f8c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
     f90:	00632e32 	rsbeq	r2, r3, r2, lsr lr
     f94:	68000001 	stmdavs	r0, {r0}
     f98:	74687361 	strbtvc	r7, [r8], #-865	; 0xfffffc9f
     f9c:	682e6261 	stmdavs	lr!, {r0, r5, r6, r9, sp, lr}
     fa0:	00000200 	andeq	r0, r0, r0, lsl #4
     fa4:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
     fa8:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
     fac:	00030068 	andeq	r0, r3, r8, rrx
     fb0:	6d726100 	ldfvse	f6, [r2, #-0]
     fb4:	7570632d 	ldrbvc	r6, [r0, #-813]!	; 0xfffffcd3
     fb8:	0300682e 	movweq	r6, #2094	; 0x82e
     fbc:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
     fc0:	632d6e73 			; <UNDEFINED> instruction: 0x632d6e73
     fc4:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
     fc8:	73746e61 	cmnvc	r4, #1552	; 0x610
     fcc:	0300682e 	movweq	r6, #2094	; 0x82e
     fd0:	72610000 	rsbvc	r0, r1, #0
     fd4:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     fd8:	6c000004 	stcvs	0, cr0, [r0], {4}
     fdc:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
     fe0:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
     fe4:	00000100 	andeq	r0, r0, r0, lsl #2
     fe8:	00010500 	andeq	r0, r1, r0, lsl #10
     fec:	9ad00205 	bls	ff401808 <__bss_end+0xff3f7b10>
     ff0:	f9030000 			; <UNDEFINED> instruction: 0xf9030000
     ff4:	0305010b 	movweq	r0, #20747	; 0x510b
     ff8:	06010513 			; <UNDEFINED> instruction: 0x06010513
     ffc:	2f060511 	svccs	0x00060511
    1000:	68060305 	stmdavs	r6, {r0, r2, r8, r9}
    1004:	01060a05 	tsteq	r6, r5, lsl #20
    1008:	2d060505 	cfstr32cs	mvfx0, [r6, #-20]	; 0xffffffec
    100c:	10060105 	andne	r0, r6, r5, lsl #2
    1010:	2e300e05 	cdpcs	14, 3, cr0, cr0, cr5, {0}
    1014:	052e0c05 	streq	r0, [lr, #-3077]!	; 0xfffff3fb
    1018:	02024c01 	andeq	r4, r2, #256	; 0x100
    101c:	3b010100 	blcc	41424 <__bss_end+0x3772c>
    1020:	03000001 	movweq	r0, #1
    1024:	0000ee00 	andeq	lr, r0, r0, lsl #28
    1028:	fb010200 	blx	41832 <__bss_end+0x37b3a>
    102c:	01000d0e 	tsteq	r0, lr, lsl #26
    1030:	00010101 	andeq	r0, r1, r1, lsl #2
    1034:	00010000 	andeq	r0, r1, r0
    1038:	2e2e0100 	sufcse	f0, f6, f0
    103c:	2f2e2e2f 	svccs	0x002e2e2f
    1040:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1044:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1048:	2f2e2e2f 	svccs	0x002e2e2f
    104c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1050:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
    1054:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1058:	2f2e2e2f 	svccs	0x002e2e2f
    105c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1060:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1064:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1068:	2f636367 	svccs	0x00636367
    106c:	692f2e2e 	stmdbvs	pc!, {r1, r2, r3, r5, r9, sl, fp, sp}	; <UNPREDICTABLE>
    1070:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    1074:	2e006564 	cfsh32cs	mvfx6, mvfx0, #52
    1078:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    107c:	2f2e2e2f 	svccs	0x002e2e2f
    1080:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1084:	2f2e2f2e 	svccs	0x002e2f2e
    1088:	00636367 	rsbeq	r6, r3, r7, ror #6
    108c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1090:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1094:	2f2e2e2f 	svccs	0x002e2e2f
    1098:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    109c:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    10a0:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    10a4:	2f2e2e2f 	svccs	0x002e2e2f
    10a8:	2f636367 	svccs	0x00636367
    10ac:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    10b0:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    10b4:	00006d72 	andeq	r6, r0, r2, ror sp
    10b8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    10bc:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    10c0:	00010063 	andeq	r0, r1, r3, rrx
    10c4:	73616800 	cmnvc	r1, #0, 16
    10c8:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    10cc:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    10d0:	72610000 	rsbvc	r0, r1, #0
    10d4:	73692d6d 	cmnvc	r9, #6976	; 0x1b40
    10d8:	00682e61 	rsbeq	r2, r8, r1, ror #28
    10dc:	61000003 	tstvs	r0, r3
    10e0:	632d6d72 			; <UNDEFINED> instruction: 0x632d6d72
    10e4:	682e7570 	stmdavs	lr!, {r4, r5, r6, r8, sl, ip, sp, lr}
    10e8:	00000300 	andeq	r0, r0, r0, lsl #6
    10ec:	6e736e69 	cdpvs	14, 7, cr6, cr3, cr9, {3}
    10f0:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    10f4:	6e617473 	mcrvs	4, 3, r7, cr1, cr3, {3}
    10f8:	682e7374 	stmdavs	lr!, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
    10fc:	00000300 	andeq	r0, r0, r0, lsl #6
    1100:	2e6d7261 	cdpcs	2, 6, cr7, cr13, cr1, {3}
    1104:	00040068 	andeq	r0, r4, r8, rrx
    1108:	62696c00 	rsbvs	r6, r9, #0, 24
    110c:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    1110:	0100682e 	tsteq	r0, lr, lsr #16
    1114:	05000000 	streq	r0, [r0, #-0]
    1118:	02050001 	andeq	r0, r5, #1
    111c:	00009b00 	andeq	r9, r0, r0, lsl #22
    1120:	010bb903 	tsteq	fp, r3, lsl #18
    1124:	05170305 	ldreq	r0, [r7, #-773]	; 0xfffffcfb
    1128:	05010610 	streq	r0, [r1, #-1552]	; 0xfffff9f0
    112c:	2e0a0327 	cdpcs	3, 0, cr0, cr10, cr7, {1}
    1130:	76031005 	strvc	r1, [r3], -r5
    1134:	0603052e 	streq	r0, [r3], -lr, lsr #10
    1138:	06190533 			; <UNDEFINED> instruction: 0x06190533
    113c:	4a100501 	bmi	402548 <__bss_end+0x3f8850>
    1140:	33060305 	movwcc	r0, #25349	; 0x6305
    1144:	061b0515 			; <UNDEFINED> instruction: 0x061b0515
    1148:	0301050f 	movweq	r0, #5391	; 0x150f
    114c:	19052e2b 	stmdbne	r5, {r0, r1, r3, r5, r9, sl, fp, sp}
    1150:	052e5503 	streq	r5, [lr, #-1283]!	; 0xfffffafd
    1154:	2e2b0301 	cdpcs	3, 2, cr0, cr11, cr1, {0}
    1158:	000a024a 	andeq	r0, sl, sl, asr #4
    115c:	01f60101 	mvnseq	r0, r1, lsl #2
    1160:	00030000 	andeq	r0, r3, r0
    1164:	000000ee 	andeq	r0, r0, lr, ror #1
    1168:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    116c:	0101000d 	tsteq	r1, sp
    1170:	00000101 	andeq	r0, r0, r1, lsl #2
    1174:	00000100 	andeq	r0, r0, r0, lsl #2
    1178:	2f2e2e01 	svccs	0x002e2e01
    117c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1180:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1184:	2f2e2e2f 	svccs	0x002e2e2f
    1188:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 10d8 <shift+0x10d8>
    118c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1190:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
    1194:	2f2e2e2f 	svccs	0x002e2e2f
    1198:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    119c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    11a0:	2f2e2e2f 	svccs	0x002e2e2f
    11a4:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    11a8:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
    11ac:	6e692f2e 	cdpvs	15, 6, cr2, cr9, cr14, {1}
    11b0:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    11b4:	2e2e0065 	cdpcs	0, 2, cr0, cr14, cr5, {3}
    11b8:	2f2e2e2f 	svccs	0x002e2e2f
    11bc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    11c0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    11c4:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
    11c8:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
    11cc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    11d0:	2f2e2e2f 	svccs	0x002e2e2f
    11d4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    11d8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    11dc:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    11e0:	2f636367 	svccs	0x00636367
    11e4:	672f2e2e 	strvs	r2, [pc, -lr, lsr #28]!
    11e8:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    11ec:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    11f0:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    11f4:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
    11f8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    11fc:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    1200:	00000100 	andeq	r0, r0, r0, lsl #2
    1204:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    1208:	2e626174 	mcrcs	1, 3, r6, cr2, cr4, {3}
    120c:	00020068 	andeq	r0, r2, r8, rrx
    1210:	6d726100 	ldfvse	f6, [r2, #-0]
    1214:	6173692d 	cmnvs	r3, sp, lsr #18
    1218:	0300682e 	movweq	r6, #2094	; 0x82e
    121c:	72610000 	rsbvc	r0, r1, #0
    1220:	70632d6d 	rsbvc	r2, r3, sp, ror #26
    1224:	00682e75 	rsbeq	r2, r8, r5, ror lr
    1228:	69000003 	stmdbvs	r0, {r0, r1}
    122c:	2d6e736e 	stclcs	3, cr7, [lr, #-440]!	; 0xfffffe48
    1230:	736e6f63 	cmnvc	lr, #396	; 0x18c
    1234:	746e6174 	strbtvc	r6, [lr], #-372	; 0xfffffe8c
    1238:	00682e73 	rsbeq	r2, r8, r3, ror lr
    123c:	61000003 	tstvs	r0, r3
    1240:	682e6d72 	stmdavs	lr!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}
    1244:	00000400 	andeq	r0, r0, r0, lsl #8
    1248:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    124c:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    1250:	00010068 	andeq	r0, r1, r8, rrx
    1254:	01050000 	mrseq	r0, (UNDEF: 5)
    1258:	40020500 	andmi	r0, r2, r0, lsl #10
    125c:	0300009b 	movweq	r0, #155	; 0x9b
    1260:	050107b3 	streq	r0, [r1, #-1971]	; 0xfffff84d
    1264:	06051303 	streq	r1, [r5], -r3, lsl #6
    1268:	010b0306 	tsteq	fp, r6, lsl #6
    126c:	74030105 	strvc	r0, [r3], #-261	; 0xfffffefb
    1270:	0b052e4a 	bleq	14cba0 <__bss_end+0x142ea8>
    1274:	2d01052f 	cfstr32cs	mvfx0, [r1, #-188]	; 0xffffff44
    1278:	30060305 	andcc	r0, r6, r5, lsl #6
    127c:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
    1280:	74030601 	strvc	r0, [r3], #-1537	; 0xfffff9ff
    1284:	2f0b0501 	svccs	0x000b0501
    1288:	0b030605 	bleq	c2aa4 <__bss_end+0xb8dac>
    128c:	0607052e 	streq	r0, [r7], -lr, lsr #10
    1290:	060d0530 			; <UNDEFINED> instruction: 0x060d0530
    1294:	06070501 	streq	r0, [r7], -r1, lsl #10
    1298:	060d0583 	streq	r0, [sp], -r3, lsl #11
    129c:	07052e01 	streq	r2, [r5, -r1, lsl #28]
    12a0:	09056806 	stmdbeq	r5, {r1, r2, fp, sp, lr}
    12a4:	07050106 	streq	r0, [r5, -r6, lsl #2]
    12a8:	09052f06 	stmdbeq	r5, {r1, r2, r8, r9, sl, fp, sp}
    12ac:	07050106 	streq	r0, [r5, -r6, lsl #2]
    12b0:	0a05c106 	beq	1716d0 <__bss_end+0x1679d8>
    12b4:	0b050106 	bleq	1416d4 <__bss_end+0x1379dc>
    12b8:	054a6803 	strbeq	r6, [sl, #-2051]	; 0xfffff7fd
    12bc:	4a18030a 	bmi	601eec <__bss_end+0x5f81f4>
    12c0:	30060405 	andcc	r0, r6, r5, lsl #8
    12c4:	13060605 	movwne	r0, #26117	; 0x6605
    12c8:	05492f49 	strbeq	r2, [r9, #-3913]	; 0xfffff0b7
    12cc:	052f0604 	streq	r0, [pc, #-1540]!	; cd0 <shift+0xcd0>
    12d0:	0a051507 	beq	1466f4 <__bss_end+0x13c9fc>
    12d4:	04050106 	streq	r0, [r5], #-262	; 0xfffffefa
    12d8:	06054c06 	streq	r4, [r5], -r6, lsl #24
    12dc:	04050106 	streq	r0, [r5], #-262	; 0xfffffefa
    12e0:	06056a06 	streq	r6, [r5], -r6, lsl #20
    12e4:	052e0e06 	streq	r0, [lr, #-3590]!	; 0xfffff1fa
    12e8:	1005360b 	andne	r3, r5, fp, lsl #12
    12ec:	4a05054a 	bmi	14281c <__bss_end+0x138b24>
    12f0:	0608052e 	streq	r0, [r8], -lr, lsr #10
    12f4:	06060531 			; <UNDEFINED> instruction: 0x06060531
    12f8:	04052e13 	streq	r2, [r5], #-3603	; 0xfffff1ed
    12fc:	2e790306 	cdpcs	3, 7, cr0, cr9, cr6, {0}
    1300:	05140805 	ldreq	r0, [r4, #-2053]	; 0xfffff7fb
    1304:	05141303 	ldreq	r1, [r4, #-771]	; 0xfffffcfd
    1308:	050f060b 	streq	r0, [pc, #-1547]	; d05 <shift+0xd05>
    130c:	052e6905 	streq	r6, [lr, #-2309]!	; 0xfffff6fb
    1310:	052f0608 	streq	r0, [pc, #-1544]!	; d10 <shift+0xd10>
    1314:	2e130606 	cfmsub32cs	mvax0, mvfx0, mvfx3, mvfx6
    1318:	32060405 	andcc	r0, r6, #83886080	; 0x5000000
    131c:	13060605 	movwne	r0, #26117	; 0x6605
    1320:	052f2d66 	streq	r2, [pc, #-3430]!	; 5c2 <shift+0x5c2>
    1324:	05662f0f 	strbeq	r2, [r6, #-3855]!	; 0xfffff0f1
    1328:	04052c06 	streq	r2, [r5], #-3078	; 0xfffff3fa
    132c:	06052f06 	streq	r2, [r5], -r6, lsl #30
    1330:	052d1306 	streq	r1, [sp, #-774]!	; 0xfffffcfa
    1334:	052f0604 	streq	r0, [pc, #-1540]!	; d38 <shift+0xd38>
    1338:	05010606 	streq	r0, [r1, #-1542]	; 0xfffff9fa
    133c:	05320603 	ldreq	r0, [r2, #-1539]!	; 0xfffff9fd
    1340:	05010606 	streq	r0, [r1, #-1542]	; 0xfffff9fa
    1344:	052f0605 	streq	r0, [pc, #-1541]!	; d47 <shift+0xd47>
    1348:	05010609 	streq	r0, [r1, #-1545]	; 0xfffff9f7
    134c:	052f0603 	streq	r0, [pc, #-1539]!	; d51 <shift+0xd51>
    1350:	02130601 	andseq	r0, r3, #1048576	; 0x100000
    1354:	01010002 	tsteq	r1, r2

Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	00000022 	andeq	r0, r0, r2, lsr #32
       4:	00000002 	andeq	r0, r0, r2
       8:	01040000 	mrseq	r0, (UNDEF: 4)
       c:	00000000 	andeq	r0, r0, r0
      10:	00008000 	andeq	r8, r0, r0
      14:	00008008 	andeq	r8, r0, r8
      18:	00000000 	andeq	r0, r0, r0
      1c:	00000034 	andeq	r0, r0, r4, lsr r0
      20:	00000067 	andeq	r0, r0, r7, rrx
      24:	00a48001 	adceq	r8, r4, r1
      28:	00040000 	andeq	r0, r4, r0
      2c:	00000014 	andeq	r0, r0, r4, lsl r0
      30:	00ca0104 	sbceq	r0, sl, r4, lsl #2
      34:	750c0000 	strvc	r0, [ip, #-0]
      38:	34000000 	strcc	r0, [r0], #-0
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	98000080 	stmdals	r0, {r7}
      44:	64000000 	strvs	r0, [r0], #-0
      48:	02000000 	andeq	r0, r0, #0
      4c:	0000018e 	andeq	r0, r0, lr, lsl #3
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	18050704 	stmdane	r5, {r2, r8, r9, sl}
      5c:	c0020000 	andgt	r0, r2, r0
      60:	01000000 	mrseq	r0, (UNDEF: 0)
      64:	00311507 	eorseq	r1, r1, r7, lsl #10
      68:	9a040000 	bls	100070 <__bss_end+0xf6378>
      6c:	01000001 	tsteq	r0, r1
      70:	8060060f 	rsbhi	r0, r0, pc, lsl #12
      74:	00400000 	subeq	r0, r0, r0
      78:	9c010000 	stcls	0, cr0, [r1], {-0}
      7c:	0000006a 	andeq	r0, r0, sl, rrx
      80:	0000b905 	andeq	fp, r0, r5, lsl #18
      84:	091a0100 	ldmdbeq	sl, {r8}
      88:	0000006a 	andeq	r0, r0, sl, rrx
      8c:	00749102 	rsbseq	r9, r4, r2, lsl #2
      90:	69050406 	stmdbvs	r5, {r1, r2, sl}
      94:	0700746e 	streq	r7, [r0, -lr, ror #8]
      98:	000000a9 	andeq	r0, r0, r9, lsr #1
      9c:	08060901 	stmdaeq	r6, {r0, r8, fp}
      a0:	58000080 	stmdapl	r0, {r7}
      a4:	01000000 	mrseq	r0, (UNDEF: 0)
      a8:	0000a19c 	muleq	r0, ip, r1
      ac:	80140800 	andshi	r0, r4, r0, lsl #16
      b0:	00340000 	eorseq	r0, r4, r0
      b4:	63090000 	movwvs	r0, #36864	; 0x9000
      b8:	01007275 	tsteq	r0, r5, ror r2
      bc:	00a1180b 	adceq	r1, r1, fp, lsl #16
      c0:	91020000 	mrsls	r0, (UNDEF: 2)
      c4:	0a000074 	beq	29c <shift+0x29c>
      c8:	00003104 	andeq	r3, r0, r4, lsl #2
      cc:	02020000 	andeq	r0, r2, #0
      d0:	00040000 	andeq	r0, r4, r0
      d4:	000000b9 	strheq	r0, [r0], -r9
      d8:	02850104 	addeq	r0, r5, #4, 2
      dc:	ad040000 	stcge	0, cr0, [r4, #-0]
      e0:	34000001 	strcc	r0, [r0], #-1
      e4:	a0000000 	andge	r0, r0, r0
      e8:	88000080 	stmdahi	r0, {r7}
      ec:	f7000001 			; <UNDEFINED> instruction: 0xf7000001
      f0:	02000000 	andeq	r0, r0, #0
      f4:	000003a8 	andeq	r0, r0, r8, lsr #7
      f8:	31202f01 			; <UNDEFINED> instruction: 0x31202f01
      fc:	03000000 	movweq	r0, #0
     100:	00003704 	andeq	r3, r0, r4, lsl #14
     104:	7c020400 	cfstrsvc	mvf0, [r2], {-0}
     108:	01000002 	tsteq	r0, r2
     10c:	00312030 	eorseq	r2, r1, r0, lsr r0
     110:	25050000 	strcs	r0, [r5, #-0]
     114:	57000000 	strpl	r0, [r0, -r0]
     118:	06000000 	streq	r0, [r0], -r0
     11c:	00000057 	andeq	r0, r0, r7, asr r0
     120:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
     124:	07040700 	streq	r0, [r4, -r0, lsl #14]
     128:	00001805 	andeq	r1, r0, r5, lsl #16
     12c:	00039a08 	andeq	r9, r3, r8, lsl #20
     130:	15330100 	ldrne	r0, [r3, #-256]!	; 0xffffff00
     134:	00000044 	andeq	r0, r0, r4, asr #32
     138:	00024208 	andeq	r4, r2, r8, lsl #4
     13c:	15350100 	ldrne	r0, [r5, #-256]!	; 0xffffff00
     140:	00000044 	andeq	r0, r0, r4, asr #32
     144:	00003805 	andeq	r3, r0, r5, lsl #16
     148:	00008900 	andeq	r8, r0, r0, lsl #18
     14c:	00570600 	subseq	r0, r7, r0, lsl #12
     150:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
     154:	0800ffff 	stmdaeq	r0, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, sp, lr, pc}
     158:	0000025c 	andeq	r0, r0, ip, asr r2
     15c:	76153801 	ldrvc	r3, [r5], -r1, lsl #16
     160:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     164:	00000365 	andeq	r0, r0, r5, ror #6
     168:	76153a01 	ldrvc	r3, [r5], -r1, lsl #20
     16c:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     170:	00000207 	andeq	r0, r0, r7, lsl #4
     174:	cb104801 	blgt	412180 <__bss_end+0x408488>
     178:	d0000000 	andle	r0, r0, r0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	02150a00 	andseq	r0, r5, #0, 20
     18c:	4a010000 	bmi	40194 <__bss_end+0x3649c>
     190:	0000d20c 	andeq	sp, r0, ip, lsl #4
     194:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     198:	05040b00 	streq	r0, [r4, #-2816]	; 0xfffff500
     19c:	00746e69 	rsbseq	r6, r4, r9, ror #28
     1a0:	00380403 	eorseq	r0, r8, r3, lsl #8
     1a4:	8d090000 	stchi	0, cr0, [r9, #-0]
     1a8:	01000003 	tsteq	r0, r3
     1ac:	00cb103c 	sbceq	r1, fp, ip, lsr r0
     1b0:	81780000 	cmnhi	r8, r0
     1b4:	00580000 	subseq	r0, r8, r0
     1b8:	9c010000 	stcls	0, cr0, [r1], {-0}
     1bc:	00000102 	andeq	r0, r0, r2, lsl #2
     1c0:	0002150a 	andeq	r1, r2, sl, lsl #10
     1c4:	0c3e0100 	ldfeqs	f0, [lr], #-0
     1c8:	00000102 	andeq	r0, r0, r2, lsl #2
     1cc:	00749102 	rsbseq	r9, r4, r2, lsl #2
     1d0:	00250403 	eoreq	r0, r5, r3, lsl #8
     1d4:	f00c0000 			; <UNDEFINED> instruction: 0xf00c0000
     1d8:	01000001 	tsteq	r0, r1
     1dc:	816c1129 	cmnhi	ip, r9, lsr #2
     1e0:	000c0000 	andeq	r0, ip, r0
     1e4:	9c010000 	stcls	0, cr0, [r1], {-0}
     1e8:	00021b0c 	andeq	r1, r2, ip, lsl #22
     1ec:	11240100 			; <UNDEFINED> instruction: 0x11240100
     1f0:	00008154 	andeq	r8, r0, r4, asr r1
     1f4:	00000018 	andeq	r0, r0, r8, lsl r0
     1f8:	720c9c01 	andvc	r9, ip, #256	; 0x100
     1fc:	01000003 	tsteq	r0, r3
     200:	813c111f 	teqhi	ip, pc, lsl r1
     204:	00180000 	andseq	r0, r8, r0
     208:	9c010000 	stcls	0, cr0, [r1], {-0}
     20c:	00024f0c 	andeq	r4, r2, ip, lsl #30
     210:	111a0100 	tstne	sl, r0, lsl #2
     214:	00008124 	andeq	r8, r0, r4, lsr #2
     218:	00000018 	andeq	r0, r0, r8, lsl r0
     21c:	e50d9c01 	str	r9, [sp, #-3073]	; 0xfffff3ff
     220:	02000001 	andeq	r0, r0, #1
     224:	00019e00 	andeq	r9, r1, r0, lsl #28
     228:	026a0e00 	rsbeq	r0, sl, #0, 28
     22c:	14010000 	strne	r0, [r1], #-0
     230:	00016d12 	andeq	r6, r1, r2, lsl sp
     234:	019e0f00 	orrseq	r0, lr, r0, lsl #30
     238:	02000000 	andeq	r0, r0, #0
     23c:	000001a5 	andeq	r0, r0, r5, lsr #3
     240:	a41c0401 	ldrge	r0, [ip], #-1025	; 0xfffffbff
     244:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
     248:	0000022e 	andeq	r0, r0, lr, lsr #4
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x47a160>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03b11000 			; <UNDEFINED> instruction: 0x03b11000
     25c:	0a010000 	beq	40264 <__bss_end+0x3656c>
     260:	0000cb11 	andeq	ip, r0, r1, lsl fp
     264:	019e0f00 	orrseq	r0, lr, r0, lsl #30
     268:	00000000 	andeq	r0, r0, r0
     26c:	016d0403 	cmneq	sp, r3, lsl #8
     270:	08070000 	stmdaeq	r7, {}	; <UNPREDICTABLE>
     274:	00037f05 	andeq	r7, r3, r5, lsl #30
     278:	015b1100 	cmpeq	fp, r0, lsl #2
     27c:	81040000 	mrshi	r0, (UNDEF: 4)
     280:	00200000 	eoreq	r0, r0, r0
     284:	9c010000 	stcls	0, cr0, [r1], {-0}
     288:	000001c7 	andeq	r0, r0, r7, asr #3
     28c:	00019e12 	andeq	r9, r1, r2, lsl lr
     290:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     294:	01791100 	cmneq	r9, r0, lsl #2
     298:	80d80000 	sbcshi	r0, r8, r0
     29c:	002c0000 	eoreq	r0, ip, r0
     2a0:	9c010000 	stcls	0, cr0, [r1], {-0}
     2a4:	000001e8 	andeq	r0, r0, r8, ror #3
     2a8:	01006713 	tsteq	r0, r3, lsl r7
     2ac:	019e300f 	orrseq	r3, lr, pc
     2b0:	91020000 	mrsls	r0, (UNDEF: 2)
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f6794>
     2b8:	a0000001 	andge	r0, r0, r1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	00000848 	andeq	r0, r0, r8, asr #16
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	00000285 	andeq	r0, r0, r5, lsl #5
     2e4:	0004dc04 	andeq	sp, r4, r4, lsl #24
     2e8:	00003400 	andeq	r3, r0, r0, lsl #8
     2ec:	00822800 	addeq	r2, r2, r0, lsl #16
     2f0:	00004800 	andeq	r4, r0, r0, lsl #16
     2f4:	0001e300 	andeq	lr, r1, r0, lsl #6
     2f8:	08010200 	stmdaeq	r1, {r9}
     2fc:	00000753 	andeq	r0, r0, r3, asr r7
     300:	00002503 	andeq	r2, r0, r3, lsl #10
     304:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     308:	00000452 	andeq	r0, r0, r2, asr r4
     30c:	69050404 	stmdbvs	r5, {r2, sl}
     310:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
     314:	074a0801 	strbeq	r0, [sl, -r1, lsl #16]
     318:	02020000 	andeq	r0, r2, #0
     31c:	00085407 	andeq	r5, r8, r7, lsl #8
     320:	07880500 	streq	r0, [r8, r0, lsl #10]
     324:	09070000 	stmdbeq	r7, {}	; <UNPREDICTABLE>
     328:	00005e1e 	andeq	r5, r0, lr, lsl lr
     32c:	004d0300 	subeq	r0, sp, r0, lsl #6
     330:	04020000 	streq	r0, [r2], #-0
     334:	00180507 	andseq	r0, r8, r7, lsl #10
     338:	0a320600 	beq	c81b40 <__bss_end+0xc77e48>
     33c:	02080000 	andeq	r0, r8, #0
     340:	008b0806 	addeq	r0, fp, r6, lsl #16
     344:	72070000 	andvc	r0, r7, #0
     348:	08020030 	stmdaeq	r2, {r4, r5}
     34c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     350:	72070000 	andvc	r0, r7, #0
     354:	09020031 	stmdbeq	r2, {r0, r4, r5}
     358:	00004d0e 	andeq	r4, r0, lr, lsl #26
     35c:	08000400 	stmdaeq	r0, {sl}
     360:	0000045c 	andeq	r0, r0, ip, asr r4
     364:	00380405 	eorseq	r0, r8, r5, lsl #8
     368:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
     36c:	0000d40c 	andeq	sp, r0, ip, lsl #8
     370:	04c30900 	strbeq	r0, [r3], #2304	; 0x900
     374:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     378:	00000b5d 	andeq	r0, r0, sp, asr fp
     37c:	03d20901 	bicseq	r0, r2, #16384	; 0x4000
     380:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
     384:	000006d9 	ldrdeq	r0, [r0], -r9
     388:	0b4e0903 	bleq	138279c <__bss_end+0x1378aa4>
     38c:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     390:	00000658 	andeq	r0, r0, r8, asr r6
     394:	07ec0905 	strbeq	r0, [ip, r5, lsl #18]!
     398:	09060000 	stmdbeq	r6, {}	; <UNPREDICTABLE>
     39c:	00000bd8 	ldrdeq	r0, [r0], -r8
     3a0:	07e70907 	strbeq	r0, [r7, r7, lsl #18]!
     3a4:	00080000 	andeq	r0, r8, r0
     3a8:	00042f08 	andeq	r2, r4, r8, lsl #30
     3ac:	38040500 	stmdacc	r4, {r8, sl}
     3b0:	02000000 	andeq	r0, r0, #0
     3b4:	01110c4a 	tsteq	r1, sl, asr #24
     3b8:	09090000 	stmdbeq	r9, {}	; <UNPREDICTABLE>
     3bc:	00000008 	andeq	r0, r0, r8
     3c0:	00078309 	andeq	r8, r7, r9, lsl #6
     3c4:	4f090100 	svcmi	0x00090100
     3c8:	0200000a 	andeq	r0, r0, #10
     3cc:	0009e009 	andeq	lr, r9, r9
     3d0:	82090300 	andhi	r0, r9, #0, 6
     3d4:	04000009 	streq	r0, [r0], #-9
     3d8:	000a6609 	andeq	r6, sl, r9, lsl #12
     3dc:	e2090500 	and	r0, r9, #0, 10
     3e0:	06000007 	streq	r0, [r0], -r7
     3e4:	067e0a00 	ldrbteq	r0, [lr], -r0, lsl #20
     3e8:	05030000 	streq	r0, [r3, #-0]
     3ec:	00005914 	andeq	r5, r0, r4, lsl r9
     3f0:	68030500 	stmdavs	r3, {r8, sl}
     3f4:	0a00009c 	beq	66c <shift+0x66c>
     3f8:	00000a3e 	andeq	r0, r0, lr, lsr sl
     3fc:	59140603 	ldmdbpl	r4, {r0, r1, r9, sl}
     400:	05000000 	streq	r0, [r0, #-0]
     404:	009c6c03 	addseq	r6, ip, r3, lsl #24
     408:	05e20a00 	strbeq	r0, [r2, #2560]!	; 0xa00
     40c:	07040000 	streq	r0, [r4, -r0]
     410:	0000591a 	andeq	r5, r0, sl, lsl r9
     414:	70030500 	andvc	r0, r3, r0, lsl #10
     418:	0a00009c 	beq	690 <shift+0x690>
     41c:	0000069a 	muleq	r0, sl, r6
     420:	591a0904 	ldmdbpl	sl, {r2, r8, fp}
     424:	05000000 	streq	r0, [r0, #-0]
     428:	009c7403 	addseq	r7, ip, r3, lsl #8
     42c:	08e80a00 	stmiaeq	r8!, {r9, fp}^
     430:	0b040000 	bleq	100438 <__bss_end+0xf6740>
     434:	0000591a 	andeq	r5, r0, sl, lsl r9
     438:	78030500 	stmdavc	r3, {r8, sl}
     43c:	0a00009c 	beq	6b4 <shift+0x6b4>
     440:	00000a6d 	andeq	r0, r0, sp, ror #20
     444:	591a0d04 	ldmdbpl	sl, {r2, r8, sl, fp}
     448:	05000000 	streq	r0, [r0, #-0]
     44c:	009c7c03 	addseq	r7, ip, r3, lsl #24
     450:	08710a00 	ldmdaeq	r1!, {r9, fp}^
     454:	0f040000 	svceq	0x00040000
     458:	0000591a 	andeq	r5, r0, sl, lsl r9
     45c:	80030500 	andhi	r0, r3, r0, lsl #10
     460:	0800009c 	stmdaeq	r0, {r2, r3, r4, r7}
     464:	000007ac 	andeq	r0, r0, ip, lsr #15
     468:	00380405 	eorseq	r0, r8, r5, lsl #8
     46c:	1b040000 	blne	100474 <__bss_end+0xf677c>
     470:	0001b40c 	andeq	fp, r1, ip, lsl #8
     474:	08830900 	stmeq	r3, {r8, fp}
     478:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     47c:	00000bf9 	strdeq	r0, [r0], -r9
     480:	0a4a0901 	beq	128288c <__bss_end+0x1278b94>
     484:	00020000 	andeq	r0, r2, r0
     488:	00083b0b 	andeq	r3, r8, fp, lsl #22
     48c:	06b60c00 	ldrteq	r0, [r6], r0, lsl #24
     490:	04900000 	ldreq	r0, [r0], #0
     494:	03270764 			; <UNDEFINED> instruction: 0x03270764
     498:	8c060000 	stchi	0, cr0, [r6], {-0}
     49c:	24000006 	strcs	r0, [r0], #-6
     4a0:	41106804 	tstmi	r0, r4, lsl #16
     4a4:	0d000002 	stceq	0, cr0, [r0, #-8]
     4a8:	00001bed 	andeq	r1, r0, sp, ror #23
     4ac:	27286a04 	strcs	r6, [r8, -r4, lsl #20]!
     4b0:	00000003 	andeq	r0, r0, r3
     4b4:	0005cc0d 	andeq	ip, r5, sp, lsl #24
     4b8:	206c0400 	rsbcs	r0, ip, r0, lsl #8
     4bc:	00000337 	andeq	r0, r0, r7, lsr r3
     4c0:	03e30d10 	mvneq	r0, #16, 26	; 0x400
     4c4:	6e040000 	cdpvs	0, 0, cr0, cr4, cr0, {0}
     4c8:	00004d23 	andeq	r4, r0, r3, lsr #26
     4cc:	770d1400 	strvc	r1, [sp, -r0, lsl #8]
     4d0:	04000006 	streq	r0, [r0], #-6
     4d4:	033e1c71 	teqeq	lr, #28928	; 0x7100
     4d8:	0d180000 	ldceq	0, cr0, [r8, #-0]
     4dc:	000006c2 	andeq	r0, r0, r2, asr #13
     4e0:	3e1c7304 	cdpcc	3, 1, cr7, cr12, cr4, {0}
     4e4:	1c000003 	stcne	0, cr0, [r0], {3}
     4e8:	000c040d 	andeq	r0, ip, sp, lsl #8
     4ec:	1c760400 	cfldrdne	mvd0, [r6], #-0
     4f0:	0000033e 	andeq	r0, r0, lr, lsr r3
     4f4:	07d20e20 	ldrbeq	r0, [r2, r0, lsr #28]
     4f8:	78040000 	stmdavc	r4, {}	; <UNPREDICTABLE>
     4fc:	000a801c 	andeq	r8, sl, ip, lsl r0
     500:	00033e00 	andeq	r3, r3, r0, lsl #28
     504:	00023500 	andeq	r3, r2, r0, lsl #10
     508:	033e0f00 	teqeq	lr, #0, 30
     50c:	44100000 	ldrmi	r0, [r0], #-0
     510:	00000003 	andeq	r0, r0, r3
     514:	07580600 	ldrbeq	r0, [r8, -r0, lsl #12]
     518:	04180000 	ldreq	r0, [r8], #-0
     51c:	0276107c 	rsbseq	r1, r6, #124	; 0x7c
     520:	ed0d0000 	stc	0, cr0, [sp, #-0]
     524:	0400001b 	streq	r0, [r0], #-27	; 0xffffffe5
     528:	03272c7f 			; <UNDEFINED> instruction: 0x03272c7f
     52c:	0d000000 	stceq	0, cr0, [r0, #-0]
     530:	00000447 	andeq	r0, r0, r7, asr #8
     534:	44198104 	ldrmi	r8, [r9], #-260	; 0xfffffefc
     538:	10000003 	andne	r0, r0, r3
     53c:	0008020d 	andeq	r0, r8, sp, lsl #4
     540:	21830400 	orrcs	r0, r3, r0, lsl #8
     544:	0000034f 	andeq	r0, r0, pc, asr #6
     548:	41030014 	tstmi	r3, r4, lsl r0
     54c:	11000002 	tstne	r0, r2
     550:	000004d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     554:	55218704 	strpl	r8, [r1, #-1796]!	; 0xfffff8fc
     558:	11000003 	tstne	r0, r3
     55c:	0000051c 	andeq	r0, r0, ip, lsl r5
     560:	591f8904 	ldmdbpl	pc, {r2, r8, fp, pc}	; <UNPREDICTABLE>
     564:	0d000000 	stceq	0, cr0, [r0, #-0]
     568:	00000988 	andeq	r0, r0, r8, lsl #19
     56c:	c6178c04 	ldrgt	r8, [r7], -r4, lsl #24
     570:	00000001 	andeq	r0, r0, r1
     574:	0003ee0d 	andeq	lr, r3, sp, lsl #28
     578:	178f0400 	strne	r0, [pc, r0, lsl #8]
     57c:	000001c6 	andeq	r0, r0, r6, asr #3
     580:	08670d24 	stmdaeq	r7!, {r2, r5, r8, sl, fp}^
     584:	90040000 	andls	r0, r4, r0
     588:	0001c617 	andeq	ip, r1, r7, lsl r6
     58c:	f80d4800 			; <UNDEFINED> instruction: 0xf80d4800
     590:	04000007 	streq	r0, [r0], #-7
     594:	01c61791 			; <UNDEFINED> instruction: 0x01c61791
     598:	126c0000 	rsbne	r0, ip, #0
     59c:	000006b6 			; <UNDEFINED> instruction: 0x000006b6
     5a0:	c3099404 	movwgt	r9, #37892	; 0x9404
     5a4:	6000000a 	andvs	r0, r0, sl
     5a8:	01000003 	tsteq	r0, r3
     5ac:	000002e0 	andeq	r0, r0, r0, ror #5
     5b0:	000002e6 	andeq	r0, r0, r6, ror #5
     5b4:	0003600f 	andeq	r6, r3, pc
     5b8:	b8130000 	ldmdalt	r3, {}	; <UNPREDICTABLE>
     5bc:	04000004 	streq	r0, [r0], #-4
     5c0:	0c650e97 	stcleq	14, cr0, [r5], #-604	; 0xfffffda4
     5c4:	fb010000 	blx	405ce <__bss_end+0x368d6>
     5c8:	01000002 	tsteq	r0, r2
     5cc:	0f000003 	svceq	0x00000003
     5d0:	00000360 	andeq	r0, r0, r0, ror #6
     5d4:	08091400 	stmdaeq	r9, {sl, ip}
     5d8:	9a040000 	bls	1005e0 <__bss_end+0xf68e8>
     5dc:	00079110 	andeq	r9, r7, r0, lsl r1
     5e0:	00036600 	andeq	r6, r3, r0, lsl #12
     5e4:	03160100 	tsteq	r6, #0, 2
     5e8:	600f0000 	andvs	r0, pc, r0
     5ec:	10000003 	andne	r0, r0, r3
     5f0:	00000344 	andeq	r0, r0, r4, asr #6
     5f4:	00018f10 	andeq	r8, r1, r0, lsl pc
     5f8:	15000000 	strne	r0, [r0, #-0]
     5fc:	00000025 	andeq	r0, r0, r5, lsr #32
     600:	00000337 	andeq	r0, r0, r7, lsr r3
     604:	00005e16 	andeq	r5, r0, r6, lsl lr
     608:	02000f00 	andeq	r0, r0, #0, 30
     60c:	06040201 	streq	r0, [r4], -r1, lsl #4
     610:	04170000 	ldreq	r0, [r7], #-0
     614:	000001c6 	andeq	r0, r0, r6, asr #3
     618:	002c0417 	eoreq	r0, ip, r7, lsl r4
     61c:	670b0000 	strvs	r0, [fp, -r0]
     620:	1700000b 	strne	r0, [r0, -fp]
     624:	00034a04 	andeq	r4, r3, r4, lsl #20
     628:	02761500 	rsbseq	r1, r6, #0, 10
     62c:	03600000 	cmneq	r0, #0
     630:	00180000 	andseq	r0, r8, r0
     634:	01b90417 			; <UNDEFINED> instruction: 0x01b90417
     638:	04170000 	ldreq	r0, [r7], #-0
     63c:	000001b4 			; <UNDEFINED> instruction: 0x000001b4
     640:	0005f819 	andeq	pc, r5, r9, lsl r8	; <UNPREDICTABLE>
     644:	149d0400 	ldrne	r0, [sp], #1024	; 0x400
     648:	000001b9 			; <UNDEFINED> instruction: 0x000001b9
     64c:	00049f0a 	andeq	r9, r4, sl, lsl #30
     650:	14040500 	strne	r0, [r4], #-1280	; 0xfffffb00
     654:	00000059 	andeq	r0, r0, r9, asr r0
     658:	9c840305 	stcls	3, cr0, [r4], {5}
     65c:	d80a0000 	stmdale	sl, {}	; <UNPREDICTABLE>
     660:	05000003 	streq	r0, [r0, #-3]
     664:	00591407 	subseq	r1, r9, r7, lsl #8
     668:	03050000 	movweq	r0, #20480	; 0x5000
     66c:	00009c88 	andeq	r9, r0, r8, lsl #25
     670:	000ab00a 	andeq	fp, sl, sl
     674:	140a0500 	strne	r0, [sl], #-1280	; 0xfffffb00
     678:	00000059 	andeq	r0, r0, r9, asr r0
     67c:	9c8c0305 	stcls	3, cr0, [ip], {5}
     680:	23080000 	movwcs	r0, #32768	; 0x8000
     684:	05000004 	streq	r0, [r0, #-4]
     688:	00003804 	andeq	r3, r0, r4, lsl #16
     68c:	0c0d0500 	cfstr32eq	mvfx0, [sp], {-0}
     690:	000003e5 	andeq	r0, r0, r5, ror #7
     694:	77654e1a 			; <UNDEFINED> instruction: 0x77654e1a
     698:	df090000 	svcle	0x00090000
     69c:	01000008 	tsteq	r0, r8
     6a0:	000b4609 	andeq	r4, fp, r9, lsl #12
     6a4:	7b090200 	blvc	240eac <__bss_end+0x2371b4>
     6a8:	03000008 	movweq	r0, #8
     6ac:	0006cb09 	andeq	ip, r6, r9, lsl #22
     6b0:	43090400 	movwmi	r0, #37888	; 0x9400
     6b4:	05000007 	streq	r0, [r0, #-7]
     6b8:	04160600 	ldreq	r0, [r6], #-1536	; 0xfffffa00
     6bc:	05100000 	ldreq	r0, [r0, #-0]
     6c0:	0424081b 	strteq	r0, [r4], #-2075	; 0xfffff7e5
     6c4:	6c070000 	stcvs	0, cr0, [r7], {-0}
     6c8:	1d050072 	stcne	0, cr0, [r5, #-456]	; 0xfffffe38
     6cc:	00042413 	andeq	r2, r4, r3, lsl r4
     6d0:	73070000 	movwvc	r0, #28672	; 0x7000
     6d4:	1e050070 	mcrne	0, 0, r0, cr5, cr0, {3}
     6d8:	00042413 	andeq	r2, r4, r3, lsl r4
     6dc:	70070400 	andvc	r0, r7, r0, lsl #8
     6e0:	1f050063 	svcne	0x00050063
     6e4:	00042413 	andeq	r2, r4, r3, lsl r4
     6e8:	c60d0800 	strgt	r0, [sp], -r0, lsl #16
     6ec:	05000005 	streq	r0, [r0, #-5]
     6f0:	04241320 	strteq	r1, [r4], #-800	; 0xfffffce0
     6f4:	000c0000 	andeq	r0, ip, r0
     6f8:	00070402 	andeq	r0, r7, r2, lsl #8
     6fc:	06000018 			; <UNDEFINED> instruction: 0x06000018
     700:	00000c58 	andeq	r0, r0, r8, asr ip
     704:	08280570 	stmdaeq	r8!, {r4, r5, r6, r8, sl}
     708:	000004bb 			; <UNDEFINED> instruction: 0x000004bb
     70c:	00063d0d 	andeq	r3, r6, sp, lsl #26
     710:	122a0500 	eorne	r0, sl, #0, 10
     714:	000003e5 	andeq	r0, r0, r5, ror #7
     718:	69700700 	ldmdbvs	r0!, {r8, r9, sl}^
     71c:	2b050064 	blcs	1408b4 <__bss_end+0x136bbc>
     720:	00005e12 	andeq	r5, r0, r2, lsl lr
     724:	de0d1000 	cdple	0, 0, cr1, cr13, cr0, {0}
     728:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
     72c:	03ae112c 			; <UNDEFINED> instruction: 0x03ae112c
     730:	0d140000 	ldceq	0, cr0, [r4, #-0]
     734:	00000bca 	andeq	r0, r0, sl, asr #23
     738:	5e122d05 	cdppl	13, 1, cr2, cr2, cr5, {0}
     73c:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     740:	0006610d 	andeq	r6, r6, sp, lsl #2
     744:	122e0500 	eorne	r0, lr, #0, 10
     748:	0000005e 	andeq	r0, r0, lr, asr r0
     74c:	03c50d1c 	biceq	r0, r5, #28, 26	; 0x700
     750:	2f050000 	svccs	0x00050000
     754:	0004bb31 	andeq	fp, r4, r1, lsr fp
     758:	ac0d2000 	stcge	0, cr2, [sp], {-0}
     75c:	05000006 	streq	r0, [r0, #-6]
     760:	00380930 	eorseq	r0, r8, r0, lsr r9
     764:	0d600000 	stcleq	0, cr0, [r0, #-0]
     768:	0000040a 	andeq	r0, r0, sl, lsl #8
     76c:	4d0e3105 	stfmis	f3, [lr, #-20]	; 0xffffffec
     770:	64000000 	strvs	r0, [r0], #-0
     774:	0004010d 	andeq	r0, r4, sp, lsl #2
     778:	0e330500 	cfabs32eq	mvfx0, mvfx3
     77c:	0000004d 	andeq	r0, r0, sp, asr #32
     780:	03f80d68 	mvnseq	r0, #104, 26	; 0x1a00
     784:	34050000 	strcc	r0, [r5], #-0
     788:	00004d0e 	andeq	r4, r0, lr, lsl #26
     78c:	15006c00 	strne	r6, [r0, #-3072]	; 0xfffff400
     790:	00000366 	andeq	r0, r0, r6, ror #6
     794:	000004cb 	andeq	r0, r0, fp, asr #9
     798:	00005e16 	andeq	r5, r0, r6, lsl lr
     79c:	0a000f00 	beq	43a4 <shift+0x43a4>
     7a0:	000005a4 	andeq	r0, r0, r4, lsr #11
     7a4:	59140a06 	ldmdbpl	r4, {r1, r2, r9, fp}
     7a8:	05000000 	streq	r0, [r0, #-0]
     7ac:	009c9003 	addseq	r9, ip, r3
     7b0:	09460800 	stmdbeq	r6, {fp}^
     7b4:	04050000 	streq	r0, [r5], #-0
     7b8:	00000038 	andeq	r0, r0, r8, lsr r0
     7bc:	fc0c0d06 	vdot.bf16	d0, d12, d6
     7c0:	09000004 	stmdbeq	r0, {r2}
     7c4:	00000b7f 	andeq	r0, r0, pc, ror fp
     7c8:	06e80900 	strbteq	r0, [r8], r0, lsl #18
     7cc:	00010000 	andeq	r0, r1, r0
     7d0:	000bb706 	andeq	fp, fp, r6, lsl #14
     7d4:	1b060c00 	blne	1837dc <__bss_end+0x179ae4>
     7d8:	00053108 	andeq	r3, r5, r8, lsl #2
     7dc:	0b7a0d00 	bleq	1e83be4 <__bss_end+0x1e79eec>
     7e0:	1d060000 	stcne	0, cr0, [r6, #-0]
     7e4:	00053119 	andeq	r3, r5, r9, lsl r1
     7e8:	040d0000 	streq	r0, [sp], #-0
     7ec:	0600000c 	streq	r0, [r0], -ip
     7f0:	0531191e 	ldreq	r1, [r1, #-2334]!	; 0xfffff6e2
     7f4:	0d040000 	stceq	0, cr0, [r4, #-0]
     7f8:	000007dd 	ldrdeq	r0, [r0], -sp
     7fc:	37131f06 	ldrcc	r1, [r3, -r6, lsl #30]
     800:	08000005 	stmdaeq	r0, {r0, r2}
     804:	fc041700 	stc2	7, cr1, [r4], {-0}
     808:	17000004 	strne	r0, [r0, -r4]
     80c:	00042b04 	andeq	r2, r4, r4, lsl #22
     810:	0a550c00 	beq	1543818 <__bss_end+0x1539b20>
     814:	06140000 	ldreq	r0, [r4], -r0
     818:	07bf0722 	ldreq	r0, [pc, r2, lsr #14]!
     81c:	090d0000 	stmdbeq	sp, {}	; <UNPREDICTABLE>
     820:	06000006 	streq	r0, [r0], -r6
     824:	004d1226 	subeq	r1, sp, r6, lsr #4
     828:	0d000000 	stceq	0, cr0, [r0, #-0]
     82c:	00000841 	andeq	r0, r0, r1, asr #16
     830:	311d2906 	tstcc	sp, r6, lsl #18
     834:	04000005 	streq	r0, [r0], #-5
     838:	0005b30d 	andeq	fp, r5, sp, lsl #6
     83c:	1d2c0600 	stcne	6, cr0, [ip, #-0]
     840:	00000531 	andeq	r0, r0, r1, lsr r5
     844:	05d81b08 	ldrbeq	r1, [r8, #2824]	; 0xb08
     848:	2f060000 	svccs	0x00060000
     84c:	000b940e 	andeq	r9, fp, lr, lsl #8
     850:	00058500 	andeq	r8, r5, r0, lsl #10
     854:	00059000 	andeq	r9, r5, r0
     858:	07c40f00 	strbeq	r0, [r4, r0, lsl #30]
     85c:	31100000 	tstcc	r0, r0
     860:	00000005 	andeq	r0, r0, r5
     864:	0006181c 	andeq	r1, r6, ip, lsl r8
     868:	0e310600 	cfmsuba32eq	mvax0, mvax0, mvfx1, mvfx0
     86c:	00000c2f 	andeq	r0, r0, pc, lsr #24
     870:	00000337 	andeq	r0, r0, r7, lsr r3
     874:	000005a8 	andeq	r0, r0, r8, lsr #11
     878:	000005b3 			; <UNDEFINED> instruction: 0x000005b3
     87c:	0007c40f 	andeq	ip, r7, pc, lsl #8
     880:	05371000 	ldreq	r1, [r7, #-0]!
     884:	12000000 	andne	r0, r0, #0
     888:	00000737 	andeq	r0, r0, r7, lsr r7
     88c:	ba1d3506 	blt	74dcac <__bss_end+0x743fb4>
     890:	31000008 	tstcc	r0, r8
     894:	02000005 	andeq	r0, r0, #5
     898:	000005cc 	andeq	r0, r0, ip, asr #11
     89c:	000005d2 	ldrdeq	r0, [r0], -r2
     8a0:	0007c40f 	andeq	ip, r7, pc, lsl #8
     8a4:	ec120000 	ldc	0, cr0, [r2], {-0}
     8a8:	0600000b 	streq	r0, [r0], -fp
     8ac:	0c091d37 	stceq	13, cr1, [r9], {55}	; 0x37
     8b0:	05310000 	ldreq	r0, [r1, #-0]!
     8b4:	eb020000 	bl	808bc <__bss_end+0x76bc4>
     8b8:	f1000005 	cps	#5
     8bc:	0f000005 	svceq	0x00000005
     8c0:	000007c4 	andeq	r0, r0, r4, asr #15
     8c4:	08f61d00 	ldmeq	r6!, {r8, sl, fp, ip}^
     8c8:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
     8cc:	0007dd44 	andeq	sp, r7, r4, asr #26
     8d0:	12020c00 	andne	r0, r2, #0, 24
     8d4:	00000a55 	andeq	r0, r0, r5, asr sl
     8d8:	8d093c06 	stchi	12, cr3, [r9, #-24]	; 0xffffffe8
     8dc:	c4000008 	strgt	r0, [r0], #-8
     8e0:	01000007 	tsteq	r0, r7
     8e4:	00000618 	andeq	r0, r0, r8, lsl r6
     8e8:	0000061e 	andeq	r0, r0, lr, lsl r6
     8ec:	0007c40f 	andeq	ip, r7, pc, lsl #8
     8f0:	49120000 	ldmdbmi	r2, {}	; <UNPREDICTABLE>
     8f4:	06000006 	streq	r0, [r0], -r6
     8f8:	0b1b123f 	bleq	6c51fc <__bss_end+0x6bb504>
     8fc:	004d0000 	subeq	r0, sp, r0
     900:	37010000 	strcc	r0, [r1, -r0]
     904:	4c000006 	stcmi	0, cr0, [r0], {6}
     908:	0f000006 	svceq	0x00000006
     90c:	000007c4 	andeq	r0, r0, r4, asr #15
     910:	0007e610 	andeq	lr, r7, r0, lsl r6
     914:	005e1000 	subseq	r1, lr, r0
     918:	37100000 	ldrcc	r0, [r0, -r0]
     91c:	00000003 	andeq	r0, r0, r3
     920:	0006df13 	andeq	sp, r6, r3, lsl pc
     924:	0e420600 	cdpeq	6, 4, cr0, cr2, cr0, {0}
     928:	0000055b 	andeq	r0, r0, fp, asr r5
     92c:	00066101 	andeq	r6, r6, r1, lsl #2
     930:	00066700 	andeq	r6, r6, r0, lsl #14
     934:	07c40f00 	strbeq	r0, [r4, r0, lsl #30]
     938:	12000000 	andne	r0, r0, #0
     93c:	00000763 	andeq	r0, r0, r3, ror #14
     940:	71174506 	tstvc	r7, r6, lsl #10
     944:	37000004 	strcc	r0, [r0, -r4]
     948:	01000005 	tsteq	r0, r5
     94c:	00000680 	andeq	r0, r0, r0, lsl #13
     950:	00000686 	andeq	r0, r0, r6, lsl #13
     954:	0007ec0f 	andeq	lr, r7, pc, lsl #24
     958:	5b120000 	blpl	480960 <__bss_end+0x476c68>
     95c:	06000009 	streq	r0, [r0], -r9
     960:	052e1748 	streq	r1, [lr, #-1864]!	; 0xfffff8b8
     964:	05370000 	ldreq	r0, [r7, #-0]!
     968:	9f010000 	svcls	0x00010000
     96c:	aa000006 	bge	98c <shift+0x98c>
     970:	0f000006 	svceq	0x00000006
     974:	000007ec 	andeq	r0, r0, ip, ror #15
     978:	00004d10 	andeq	r4, r0, r0, lsl sp
     97c:	bc130000 	ldclt	0, cr0, [r3], {-0}
     980:	06000007 	streq	r0, [r0], -r7
     984:	09040e4b 	stmdbeq	r4, {r0, r1, r3, r6, r9, sl, fp}
     988:	bf010000 	svclt	0x00010000
     98c:	c5000006 	strgt	r0, [r0, #-6]
     990:	0f000006 	svceq	0x00000006
     994:	000007c4 	andeq	r0, r0, r4, asr #15
     998:	06181200 	ldreq	r1, [r8], -r0, lsl #4
     99c:	4d060000 	stcmi	0, cr0, [r6, #-0]
     9a0:	00057c0e 	andeq	r7, r5, lr, lsl #24
     9a4:	00033700 	andeq	r3, r3, r0, lsl #14
     9a8:	06de0100 	ldrbeq	r0, [lr], r0, lsl #2
     9ac:	06e90000 	strbteq	r0, [r9], r0
     9b0:	c40f0000 	strgt	r0, [pc], #-0	; 9b8 <shift+0x9b8>
     9b4:	10000007 	andne	r0, r0, r7
     9b8:	0000004d 	andeq	r0, r0, sp, asr #32
     9bc:	096e1200 	stmdbeq	lr!, {r9, ip}^
     9c0:	50060000 	andpl	r0, r6, r0
     9c4:	00080e12 	andeq	r0, r8, r2, lsl lr
     9c8:	00004d00 	andeq	r4, r0, r0, lsl #26
     9cc:	07020100 	streq	r0, [r2, -r0, lsl #2]
     9d0:	070d0000 	streq	r0, [sp, -r0]
     9d4:	c40f0000 	strgt	r0, [pc], #-0	; 9dc <shift+0x9dc>
     9d8:	10000007 	andne	r0, r0, r7
     9dc:	00000366 	andeq	r0, r0, r6, ror #6
     9e0:	06f31200 	ldrbteq	r1, [r3], r0, lsl #4
     9e4:	53060000 	movwpl	r0, #24576	; 0x6000
     9e8:	00070b0e 	andeq	r0, r7, lr, lsl #22
     9ec:	00033700 	andeq	r3, r3, r0, lsl #14
     9f0:	07260100 	streq	r0, [r6, -r0, lsl #2]!
     9f4:	07310000 	ldreq	r0, [r1, -r0]!
     9f8:	c40f0000 	strgt	r0, [pc], #-0	; a00 <shift+0xa00>
     9fc:	10000007 	andne	r0, r0, r7
     a00:	0000004d 	andeq	r0, r0, sp, asr #32
     a04:	09331300 	ldmdbeq	r3!, {r8, r9, ip}
     a08:	56060000 	strpl	r0, [r6], -r0
     a0c:	00098e0e 	andeq	r8, r9, lr, lsl #28
     a10:	07460100 	strbeq	r0, [r6, -r0, lsl #2]
     a14:	07650000 	strbeq	r0, [r5, -r0]!
     a18:	c40f0000 	strgt	r0, [pc], #-0	; a20 <shift+0xa20>
     a1c:	10000007 	andne	r0, r0, r7
     a20:	0000008b 	andeq	r0, r0, fp, lsl #1
     a24:	00004d10 	andeq	r4, r0, r0, lsl sp
     a28:	004d1000 	subeq	r1, sp, r0
     a2c:	4d100000 	ldcmi	0, cr0, [r0, #-0]
     a30:	10000000 	andne	r0, r0, r0
     a34:	000007f2 	strdeq	r0, [r0], -r2
     a38:	06271300 	strteq	r1, [r7], -r0, lsl #6
     a3c:	58060000 	stmdapl	r6, {}	; <UNPREDICTABLE>
     a40:	0009e60e 	andeq	lr, r9, lr, lsl #12
     a44:	077a0100 	ldrbeq	r0, [sl, -r0, lsl #2]!
     a48:	07990000 	ldreq	r0, [r9, r0]
     a4c:	c40f0000 	strgt	r0, [pc], #-0	; a54 <shift+0xa54>
     a50:	10000007 	andne	r0, r0, r7
     a54:	000000d4 	ldrdeq	r0, [r0], -r4
     a58:	00004d10 	andeq	r4, r0, r0, lsl sp
     a5c:	004d1000 	subeq	r1, sp, r0
     a60:	4d100000 	ldcmi	0, cr0, [r0, #-0]
     a64:	10000000 	andne	r0, r0, r0
     a68:	000007f2 	strdeq	r0, [r0], -r2
     a6c:	08a71400 	stmiaeq	r7!, {sl, ip}
     a70:	5b060000 	blpl	180a78 <__bss_end+0x176d80>
     a74:	000ad80e 	andeq	sp, sl, lr, lsl #16
     a78:	00033700 	andeq	r3, r3, r0, lsl #14
     a7c:	07ae0100 	streq	r0, [lr, r0, lsl #2]!
     a80:	c40f0000 	strgt	r0, [pc], #-0	; a88 <shift+0xa88>
     a84:	10000007 	andne	r0, r0, r7
     a88:	000004dd 	ldrdeq	r0, [r0], -sp
     a8c:	0007f810 	andeq	pc, r7, r0, lsl r8	; <UNPREDICTABLE>
     a90:	03000000 	movweq	r0, #0
     a94:	0000053d 	andeq	r0, r0, sp, lsr r5
     a98:	053d0417 	ldreq	r0, [sp, #-1047]!	; 0xfffffbe9
     a9c:	311e0000 	tstcc	lr, r0
     aa0:	d7000005 	strle	r0, [r0, -r5]
     aa4:	dd000007 	stcle	0, cr0, [r0, #-28]	; 0xffffffe4
     aa8:	0f000007 	svceq	0x00000007
     aac:	000007c4 	andeq	r0, r0, r4, asr #15
     ab0:	053d1f00 	ldreq	r1, [sp, #-3840]!	; 0xfffff100
     ab4:	07ca0000 	strbeq	r0, [sl, r0]
     ab8:	04170000 	ldreq	r0, [r7], #-0
     abc:	0000003f 	andeq	r0, r0, pc, lsr r0
     ac0:	07bf0417 			; <UNDEFINED> instruction: 0x07bf0417
     ac4:	04200000 	strteq	r0, [r0], #-0
     ac8:	00000065 	andeq	r0, r0, r5, rrx
     acc:	77190421 	ldrvc	r0, [r9, -r1, lsr #8]
     ad0:	06000007 	streq	r0, [r0], -r7
     ad4:	053d195e 	ldreq	r1, [sp, #-2398]!	; 0xfffff6a2
     ad8:	cb220000 	blgt	880ae0 <__bss_end+0x876de8>
     adc:	01000004 	tsteq	r0, r4
     ae0:	00380505 	eorseq	r0, r8, r5, lsl #10
     ae4:	82280000 	eorhi	r0, r8, #0
     ae8:	00480000 	subeq	r0, r8, r0
     aec:	9c010000 	stcls	0, cr0, [r1], {-0}
     af0:	0000083f 	andeq	r0, r0, pc, lsr r8
     af4:	00061323 	andeq	r1, r6, r3, lsr #6
     af8:	0e050100 	adfeqs	f0, f5, f0
     afc:	00000038 	andeq	r0, r0, r8, lsr r0
     b00:	23749102 	cmncs	r4, #-2147483648	; 0x80000000
     b04:	00000706 	andeq	r0, r0, r6, lsl #14
     b08:	3f1b0501 	svccc	0x001b0501
     b0c:	02000008 	andeq	r0, r0, #8
     b10:	17007091 			; <UNDEFINED> instruction: 0x17007091
     b14:	00084504 	andeq	r4, r8, r4, lsl #10
     b18:	25041700 	strcs	r1, [r4, #-1792]	; 0xfffff900
     b1c:	00000000 	andeq	r0, r0, r0
     b20:	00000d17 	andeq	r0, r0, r7, lsl sp
     b24:	03f70004 	mvnseq	r0, #4
     b28:	01040000 	mrseq	r0, (UNDEF: 4)
     b2c:	00000c97 	muleq	r0, r7, ip
     b30:	00106604 	andseq	r6, r0, r4, lsl #12
     b34:	000e0400 	andeq	r0, lr, r0, lsl #8
     b38:	00827000 	addeq	r7, r2, r0
     b3c:	00048c00 	andeq	r8, r4, r0, lsl #24
     b40:	00039300 	andeq	r9, r3, r0, lsl #6
     b44:	08010200 	stmdaeq	r1, {r9}
     b48:	00000753 	andeq	r0, r0, r3, asr r7
     b4c:	00002503 	andeq	r2, r0, r3, lsl #10
     b50:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     b54:	00000452 	andeq	r0, r0, r2, asr r4
     b58:	69050404 	stmdbvs	r5, {r2, sl}
     b5c:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
     b60:	074a0801 	strbeq	r0, [sl, -r1, lsl #16]
     b64:	02020000 	andeq	r0, r2, #0
     b68:	00085407 	andeq	r5, r8, r7, lsl #8
     b6c:	07880500 	streq	r0, [r8, r0, lsl #10]
     b70:	09070000 	stmdbeq	r7, {}	; <UNPREDICTABLE>
     b74:	00005e1e 	andeq	r5, r0, lr, lsl lr
     b78:	004d0300 	subeq	r0, sp, r0, lsl #6
     b7c:	04020000 	streq	r0, [r2], #-0
     b80:	00180507 	andseq	r0, r8, r7, lsl #10
     b84:	0a320600 	beq	c8238c <__bss_end+0xc78694>
     b88:	02080000 	andeq	r0, r8, #0
     b8c:	008b0806 	addeq	r0, fp, r6, lsl #16
     b90:	72070000 	andvc	r0, r7, #0
     b94:	08020030 	stmdaeq	r2, {r4, r5}
     b98:	00004d0e 	andeq	r4, r0, lr, lsl #26
     b9c:	72070000 	andvc	r0, r7, #0
     ba0:	09020031 	stmdbeq	r2, {r0, r4, r5}
     ba4:	00004d0e 	andeq	r4, r0, lr, lsl #26
     ba8:	08000400 	stmdaeq	r0, {sl}
     bac:	00000ff7 	strdeq	r0, [r0], -r7
     bb0:	00380405 	eorseq	r0, r8, r5, lsl #8
     bb4:	0d020000 	stceq	0, cr0, [r2, #-0]
     bb8:	0000a90c 	andeq	sl, r0, ip, lsl #18
     bbc:	4b4f0900 	blmi	13c2fc4 <__bss_end+0x13b92cc>
     bc0:	d80a0000 	stmdale	sl, {}	; <UNPREDICTABLE>
     bc4:	0100000d 	tsteq	r0, sp
     bc8:	045c0800 	ldrbeq	r0, [ip], #-2048	; 0xfffff800
     bcc:	04050000 	streq	r0, [r5], #-0
     bd0:	00000038 	andeq	r0, r0, r8, lsr r0
     bd4:	f20c1e02 	vceq.f32	d1, d12, d2
     bd8:	0a000000 	beq	be0 <shift+0xbe0>
     bdc:	000004c3 	andeq	r0, r0, r3, asr #9
     be0:	0b5d0a00 	bleq	17433e8 <__bss_end+0x17396f0>
     be4:	0a010000 	beq	40bec <__bss_end+0x36ef4>
     be8:	000003d2 	ldrdeq	r0, [r0], -r2
     bec:	06d90a02 	ldrbeq	r0, [r9], r2, lsl #20
     bf0:	0a030000 	beq	c0bf8 <__bss_end+0xb6f00>
     bf4:	00000b4e 	andeq	r0, r0, lr, asr #22
     bf8:	06580a04 	ldrbeq	r0, [r8], -r4, lsl #20
     bfc:	0a050000 	beq	140c04 <__bss_end+0x136f0c>
     c00:	000007ec 	andeq	r0, r0, ip, ror #15
     c04:	0bd80a06 	bleq	ff603424 <__bss_end+0xff5f972c>
     c08:	0a070000 	beq	1c0c10 <__bss_end+0x1b6f18>
     c0c:	000007e7 	andeq	r0, r0, r7, ror #15
     c10:	2f080008 	svccs	0x00080008
     c14:	05000004 	streq	r0, [r0, #-4]
     c18:	00003804 	andeq	r3, r0, r4, lsl #16
     c1c:	0c4a0200 	sfmeq	f0, 2, [sl], {-0}
     c20:	0000012f 	andeq	r0, r0, pc, lsr #2
     c24:	0008090a 	andeq	r0, r8, sl, lsl #18
     c28:	830a0000 	movwhi	r0, #40960	; 0xa000
     c2c:	01000007 	tsteq	r0, r7
     c30:	000a4f0a 	andeq	r4, sl, sl, lsl #30
     c34:	e00a0200 	and	r0, sl, r0, lsl #4
     c38:	03000009 	movweq	r0, #9
     c3c:	0009820a 	andeq	r8, r9, sl, lsl #4
     c40:	660a0400 	strvs	r0, [sl], -r0, lsl #8
     c44:	0500000a 	streq	r0, [r0, #-10]
     c48:	0007e20a 	andeq	lr, r7, sl, lsl #4
     c4c:	08000600 	stmdaeq	r0, {r9, sl}
     c50:	000010a0 	andeq	r1, r0, r0, lsr #1
     c54:	00380405 	eorseq	r0, r8, r5, lsl #8
     c58:	71020000 	mrsvc	r0, (UNDEF: 2)
     c5c:	00015a0c 	andeq	r5, r1, ip, lsl #20
     c60:	0f970a00 	svceq	0x00970a00
     c64:	0a000000 	beq	c6c <shift+0xc6c>
     c68:	00000e5e 	andeq	r0, r0, lr, asr lr
     c6c:	0fc00a01 	svceq	0x00c00a01
     c70:	0a020000 	beq	80c78 <__bss_end+0x76f80>
     c74:	00000e83 	andeq	r0, r0, r3, lsl #29
     c78:	7e0b0003 	cdpvc	0, 0, cr0, cr11, cr3, {0}
     c7c:	03000006 	movweq	r0, #6
     c80:	00591405 	subseq	r1, r9, r5, lsl #8
     c84:	03050000 	movweq	r0, #20480	; 0x5000
     c88:	00009c94 	muleq	r0, r4, ip
     c8c:	000a3e0b 	andeq	r3, sl, fp, lsl #28
     c90:	14060300 	strne	r0, [r6], #-768	; 0xfffffd00
     c94:	00000059 	andeq	r0, r0, r9, asr r0
     c98:	9c980305 	ldcls	3, cr0, [r8], {5}
     c9c:	e20b0000 	and	r0, fp, #0
     ca0:	04000005 	streq	r0, [r0], #-5
     ca4:	00591a07 	subseq	r1, r9, r7, lsl #20
     ca8:	03050000 	movweq	r0, #20480	; 0x5000
     cac:	00009c9c 	muleq	r0, ip, ip
     cb0:	00069a0b 	andeq	r9, r6, fp, lsl #20
     cb4:	1a090400 	bne	241cbc <__bss_end+0x237fc4>
     cb8:	00000059 	andeq	r0, r0, r9, asr r0
     cbc:	9ca00305 	stcls	3, cr0, [r0], #20
     cc0:	e80b0000 	stmda	fp, {}	; <UNPREDICTABLE>
     cc4:	04000008 	streq	r0, [r0], #-8
     cc8:	00591a0b 	subseq	r1, r9, fp, lsl #20
     ccc:	03050000 	movweq	r0, #20480	; 0x5000
     cd0:	00009ca4 	andeq	r9, r0, r4, lsr #25
     cd4:	000a6d0b 	andeq	r6, sl, fp, lsl #26
     cd8:	1a0d0400 	bne	341ce0 <__bss_end+0x337fe8>
     cdc:	00000059 	andeq	r0, r0, r9, asr r0
     ce0:	9ca80305 	stcls	3, cr0, [r8], #20
     ce4:	710b0000 	mrsvc	r0, (UNDEF: 11)
     ce8:	04000008 	streq	r0, [r0], #-8
     cec:	00591a0f 	subseq	r1, r9, pc, lsl #20
     cf0:	03050000 	movweq	r0, #20480	; 0x5000
     cf4:	00009cac 	andeq	r9, r0, ip, lsr #25
     cf8:	0007ac08 	andeq	sl, r7, r8, lsl #24
     cfc:	38040500 	stmdacc	r4, {r8, sl}
     d00:	04000000 	streq	r0, [r0], #-0
     d04:	01fd0c1b 	mvnseq	r0, fp, lsl ip
     d08:	830a0000 	movwhi	r0, #40960	; 0xa000
     d0c:	00000008 	andeq	r0, r0, r8
     d10:	000bf90a 	andeq	pc, fp, sl, lsl #18
     d14:	4a0a0100 	bmi	28111c <__bss_end+0x277424>
     d18:	0200000a 	andeq	r0, r0, #10
     d1c:	083b0c00 	ldmdaeq	fp!, {sl, fp}
     d20:	b60d0000 	strlt	r0, [sp], -r0
     d24:	90000006 	andls	r0, r0, r6
     d28:	70076404 	andvc	r6, r7, r4, lsl #8
     d2c:	06000003 	streq	r0, [r0], -r3
     d30:	0000068c 	andeq	r0, r0, ip, lsl #13
     d34:	10680424 	rsbne	r0, r8, r4, lsr #8
     d38:	0000028a 	andeq	r0, r0, sl, lsl #5
     d3c:	001bed0e 	andseq	lr, fp, lr, lsl #26
     d40:	286a0400 	stmdacs	sl!, {sl}^
     d44:	00000370 	andeq	r0, r0, r0, ror r3
     d48:	05cc0e00 	strbeq	r0, [ip, #3584]	; 0xe00
     d4c:	6c040000 	stcvs	0, cr0, [r4], {-0}
     d50:	00038020 	andeq	r8, r3, r0, lsr #32
     d54:	e30e1000 	movw	r1, #57344	; 0xe000
     d58:	04000003 	streq	r0, [r0], #-3
     d5c:	004d236e 	subeq	r2, sp, lr, ror #6
     d60:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     d64:	00000677 	andeq	r0, r0, r7, ror r6
     d68:	871c7104 	ldrhi	r7, [ip, -r4, lsl #2]
     d6c:	18000003 	stmdane	r0, {r0, r1}
     d70:	0006c20e 	andeq	ip, r6, lr, lsl #4
     d74:	1c730400 	cfldrdne	mvd0, [r3], #-0
     d78:	00000387 	andeq	r0, r0, r7, lsl #7
     d7c:	0c040e1c 	stceq	14, cr0, [r4], {28}
     d80:	76040000 	strvc	r0, [r4], -r0
     d84:	0003871c 	andeq	r8, r3, ip, lsl r7
     d88:	d20f2000 	andle	r2, pc, #0
     d8c:	04000007 	streq	r0, [r0], #-7
     d90:	0a801c78 	beq	fe007f78 <__bss_end+0xfdffe280>
     d94:	03870000 	orreq	r0, r7, #0
     d98:	027e0000 	rsbseq	r0, lr, #0
     d9c:	87100000 	ldrhi	r0, [r0, -r0]
     da0:	11000003 	tstne	r0, r3
     da4:	0000038d 	andeq	r0, r0, sp, lsl #7
     da8:	58060000 	stmdapl	r6, {}	; <UNPREDICTABLE>
     dac:	18000007 	stmdane	r0, {r0, r1, r2}
     db0:	bf107c04 	svclt	0x00107c04
     db4:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
     db8:	00001bed 	andeq	r1, r0, sp, ror #23
     dbc:	702c7f04 	eorvc	r7, ip, r4, lsl #30
     dc0:	00000003 	andeq	r0, r0, r3
     dc4:	0004470e 	andeq	r4, r4, lr, lsl #14
     dc8:	19810400 	stmibne	r1, {sl}
     dcc:	0000038d 	andeq	r0, r0, sp, lsl #7
     dd0:	08020e10 	stmdaeq	r2, {r4, r9, sl, fp}
     dd4:	83040000 	movwhi	r0, #16384	; 0x4000
     dd8:	00039821 	andeq	r9, r3, r1, lsr #16
     ddc:	03001400 	movweq	r1, #1024	; 0x400
     de0:	0000028a 	andeq	r0, r0, sl, lsl #5
     de4:	0004d012 	andeq	sp, r4, r2, lsl r0
     de8:	21870400 	orrcs	r0, r7, r0, lsl #8
     dec:	0000039e 	muleq	r0, lr, r3
     df0:	00051c12 	andeq	r1, r5, r2, lsl ip
     df4:	1f890400 	svcne	0x00890400
     df8:	00000059 	andeq	r0, r0, r9, asr r0
     dfc:	0009880e 	andeq	r8, r9, lr, lsl #16
     e00:	178c0400 	strne	r0, [ip, r0, lsl #8]
     e04:	0000020f 	andeq	r0, r0, pc, lsl #4
     e08:	03ee0e00 	mvneq	r0, #0, 28
     e0c:	8f040000 	svchi	0x00040000
     e10:	00020f17 	andeq	r0, r2, r7, lsl pc
     e14:	670e2400 	strvs	r2, [lr, -r0, lsl #8]
     e18:	04000008 	streq	r0, [r0], #-8
     e1c:	020f1790 	andeq	r1, pc, #144, 14	; 0x2400000
     e20:	0e480000 	cdpeq	0, 4, cr0, cr8, cr0, {0}
     e24:	000007f8 	strdeq	r0, [r0], -r8
     e28:	0f179104 	svceq	0x00179104
     e2c:	6c000002 	stcvs	0, cr0, [r0], {2}
     e30:	0006b613 	andeq	fp, r6, r3, lsl r6
     e34:	09940400 	ldmibeq	r4, {sl}
     e38:	00000ac3 	andeq	r0, r0, r3, asr #21
     e3c:	000003a9 	andeq	r0, r0, r9, lsr #7
     e40:	00032901 	andeq	r2, r3, r1, lsl #18
     e44:	00032f00 	andeq	r2, r3, r0, lsl #30
     e48:	03a91000 			; <UNDEFINED> instruction: 0x03a91000
     e4c:	14000000 	strne	r0, [r0], #-0
     e50:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
     e54:	650e9704 	strvs	r9, [lr, #-1796]	; 0xfffff8fc
     e58:	0100000c 	tsteq	r0, ip
     e5c:	00000344 	andeq	r0, r0, r4, asr #6
     e60:	0000034a 	andeq	r0, r0, sl, asr #6
     e64:	0003a910 	andeq	sl, r3, r0, lsl r9
     e68:	09150000 	ldmdbeq	r5, {}	; <UNPREDICTABLE>
     e6c:	04000008 	streq	r0, [r0], #-8
     e70:	0791109a 			; <UNDEFINED> instruction: 0x0791109a
     e74:	03af0000 			; <UNDEFINED> instruction: 0x03af0000
     e78:	5f010000 	svcpl	0x00010000
     e7c:	10000003 	andne	r0, r0, r3
     e80:	000003a9 	andeq	r0, r0, r9, lsr #7
     e84:	00038d11 	andeq	r8, r3, r1, lsl sp
     e88:	01d81100 	bicseq	r1, r8, r0, lsl #2
     e8c:	00000000 	andeq	r0, r0, r0
     e90:	00002516 	andeq	r2, r0, r6, lsl r5
     e94:	00038000 	andeq	r8, r3, r0
     e98:	005e1700 	subseq	r1, lr, r0, lsl #14
     e9c:	000f0000 	andeq	r0, pc, r0
     ea0:	04020102 	streq	r0, [r2], #-258	; 0xfffffefe
     ea4:	18000006 	stmdane	r0, {r1, r2}
     ea8:	00020f04 	andeq	r0, r2, r4, lsl #30
     eac:	2c041800 	stccs	8, cr1, [r4], {-0}
     eb0:	0c000000 	stceq	0, cr0, [r0], {-0}
     eb4:	00000b67 	andeq	r0, r0, r7, ror #22
     eb8:	03930418 	orrseq	r0, r3, #24, 8	; 0x18000000
     ebc:	bf160000 	svclt	0x00160000
     ec0:	a9000002 	stmdbge	r0, {r1}
     ec4:	19000003 	stmdbne	r0, {r0, r1}
     ec8:	02041800 	andeq	r1, r4, #0, 16
     ecc:	18000002 	stmdane	r0, {r1}
     ed0:	0001fd04 	andeq	pc, r1, r4, lsl #26
     ed4:	05f81a00 	ldrbeq	r1, [r8, #2560]!	; 0xa00
     ed8:	9d040000 	stcls	0, cr0, [r4, #-0]
     edc:	00020214 	andeq	r0, r2, r4, lsl r2
     ee0:	049f0b00 	ldreq	r0, [pc], #2816	; ee8 <shift+0xee8>
     ee4:	04050000 	streq	r0, [r5], #-0
     ee8:	00005914 	andeq	r5, r0, r4, lsl r9
     eec:	b0030500 	andlt	r0, r3, r0, lsl #10
     ef0:	0b00009c 	bleq	1168 <shift+0x1168>
     ef4:	000003d8 	ldrdeq	r0, [r0], -r8
     ef8:	59140705 	ldmdbpl	r4, {r0, r2, r8, r9, sl}
     efc:	05000000 	streq	r0, [r0, #-0]
     f00:	009cb403 	addseq	fp, ip, r3, lsl #8
     f04:	0ab00b00 	beq	fec03b0c <__bss_end+0xfebf9e14>
     f08:	0a050000 	beq	140f10 <__bss_end+0x137218>
     f0c:	00005914 	andeq	r5, r0, r4, lsl r9
     f10:	b8030500 	stmdalt	r3, {r8, sl}
     f14:	0800009c 	stmdaeq	r0, {r2, r3, r4, r7}
     f18:	00000423 	andeq	r0, r0, r3, lsr #8
     f1c:	00380405 	eorseq	r0, r8, r5, lsl #8
     f20:	0d050000 	stceq	0, cr0, [r5, #-0]
     f24:	00042e0c 	andeq	r2, r4, ip, lsl #28
     f28:	654e0900 	strbvs	r0, [lr, #-2304]	; 0xfffff700
     f2c:	0a000077 	beq	1110 <shift+0x1110>
     f30:	000008df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     f34:	0b460a01 	bleq	1183740 <__bss_end+0x1179a48>
     f38:	0a020000 	beq	80f40 <__bss_end+0x77248>
     f3c:	0000087b 	andeq	r0, r0, fp, ror r8
     f40:	06cb0a03 	strbeq	r0, [fp], r3, lsl #20
     f44:	0a040000 	beq	100f4c <__bss_end+0xf7254>
     f48:	00000743 	andeq	r0, r0, r3, asr #14
     f4c:	16060005 	strne	r0, [r6], -r5
     f50:	10000004 	andne	r0, r0, r4
     f54:	6d081b05 	vstrvs	d1, [r8, #-20]	; 0xffffffec
     f58:	07000004 	streq	r0, [r0, -r4]
     f5c:	0500726c 	streq	r7, [r0, #-620]	; 0xfffffd94
     f60:	046d131d 	strbteq	r1, [sp], #-797	; 0xfffffce3
     f64:	07000000 	streq	r0, [r0, -r0]
     f68:	05007073 	streq	r7, [r0, #-115]	; 0xffffff8d
     f6c:	046d131e 	strbteq	r1, [sp], #-798	; 0xfffffce2
     f70:	07040000 	streq	r0, [r4, -r0]
     f74:	05006370 	streq	r6, [r0, #-880]	; 0xfffffc90
     f78:	046d131f 	strbteq	r1, [sp], #-799	; 0xfffffce1
     f7c:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
     f80:	000005c6 	andeq	r0, r0, r6, asr #11
     f84:	6d132005 	ldcvs	0, cr2, [r3, #-20]	; 0xffffffec
     f88:	0c000004 	stceq	0, cr0, [r0], {4}
     f8c:	07040200 	streq	r0, [r4, -r0, lsl #4]
     f90:	00001800 	andeq	r1, r0, r0, lsl #16
     f94:	000c5806 	andeq	r5, ip, r6, lsl #16
     f98:	28057000 	stmdacs	r5, {ip, sp, lr}
     f9c:	00050408 	andeq	r0, r5, r8, lsl #8
     fa0:	063d0e00 	ldrteq	r0, [sp], -r0, lsl #28
     fa4:	2a050000 	bcs	140fac <__bss_end+0x1372b4>
     fa8:	00042e12 	andeq	r2, r4, r2, lsl lr
     fac:	70070000 	andvc	r0, r7, r0
     fb0:	05006469 	streq	r6, [r0, #-1129]	; 0xfffffb97
     fb4:	005e122b 	subseq	r1, lr, fp, lsr #4
     fb8:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
     fbc:	000015de 	ldrdeq	r1, [r0], -lr
     fc0:	f7112c05 			; <UNDEFINED> instruction: 0xf7112c05
     fc4:	14000003 	strne	r0, [r0], #-3
     fc8:	000bca0e 	andeq	ip, fp, lr, lsl #20
     fcc:	122d0500 	eorne	r0, sp, #0, 10
     fd0:	0000005e 	andeq	r0, r0, lr, asr r0
     fd4:	06610e18 			; <UNDEFINED> instruction: 0x06610e18
     fd8:	2e050000 	cdpcs	0, 0, cr0, cr5, cr0, {0}
     fdc:	00005e12 	andeq	r5, r0, r2, lsl lr
     fe0:	c50e1c00 	strgt	r1, [lr, #-3072]	; 0xfffff400
     fe4:	05000003 	streq	r0, [r0, #-3]
     fe8:	0504312f 	streq	r3, [r4, #-303]	; 0xfffffed1
     fec:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
     ff0:	000006ac 	andeq	r0, r0, ip, lsr #13
     ff4:	38093005 	stmdacc	r9, {r0, r2, ip, sp}
     ff8:	60000000 	andvs	r0, r0, r0
     ffc:	00040a0e 	andeq	r0, r4, lr, lsl #20
    1000:	0e310500 	cfabs32eq	mvfx0, mvfx1
    1004:	0000004d 	andeq	r0, r0, sp, asr #32
    1008:	04010e64 	streq	r0, [r1], #-3684	; 0xfffff19c
    100c:	33050000 	movwcc	r0, #20480	; 0x5000
    1010:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1014:	f80e6800 			; <UNDEFINED> instruction: 0xf80e6800
    1018:	05000003 	streq	r0, [r0, #-3]
    101c:	004d0e34 	subeq	r0, sp, r4, lsr lr
    1020:	006c0000 	rsbeq	r0, ip, r0
    1024:	0003af16 	andeq	sl, r3, r6, lsl pc
    1028:	00051400 	andeq	r1, r5, r0, lsl #8
    102c:	005e1700 	subseq	r1, lr, r0, lsl #14
    1030:	000f0000 	andeq	r0, pc, r0
    1034:	0005a40b 	andeq	sl, r5, fp, lsl #8
    1038:	140a0600 	strne	r0, [sl], #-1536	; 0xfffffa00
    103c:	00000059 	andeq	r0, r0, r9, asr r0
    1040:	9cbc0305 	ldcls	3, cr0, [ip], #20
    1044:	46080000 	strmi	r0, [r8], -r0
    1048:	05000009 	streq	r0, [r0, #-9]
    104c:	00003804 	andeq	r3, r0, r4, lsl #16
    1050:	0c0d0600 	stceq	6, cr0, [sp], {-0}
    1054:	00000545 	andeq	r0, r0, r5, asr #10
    1058:	000b7f0a 	andeq	r7, fp, sl, lsl #30
    105c:	e80a0000 	stmda	sl, {}	; <UNPREDICTABLE>
    1060:	01000006 	tsteq	r0, r6
    1064:	05260300 	streq	r0, [r6, #-768]!	; 0xfffffd00
    1068:	f0080000 			; <UNDEFINED> instruction: 0xf0080000
    106c:	0500000e 	streq	r0, [r0, #-14]
    1070:	00003804 	andeq	r3, r0, r4, lsl #16
    1074:	0c140600 	ldceq	6, cr0, [r4], {-0}
    1078:	00000569 	andeq	r0, r0, r9, ror #10
    107c:	000c8a0a 	andeq	r8, ip, sl, lsl #20
    1080:	b20a0000 	andlt	r0, sl, #0
    1084:	0100000f 	tsteq	r0, pc
    1088:	054a0300 	strbeq	r0, [sl, #-768]	; 0xfffffd00
    108c:	b7060000 	strlt	r0, [r6, -r0]
    1090:	0c00000b 	stceq	0, cr0, [r0], {11}
    1094:	a3081b06 	movwge	r1, #35590	; 0x8b06
    1098:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
    109c:	00000b7a 	andeq	r0, r0, sl, ror fp
    10a0:	a3191d06 	tstge	r9, #384	; 0x180
    10a4:	00000005 	andeq	r0, r0, r5
    10a8:	000c040e 	andeq	r0, ip, lr, lsl #8
    10ac:	191e0600 	ldmdbne	lr, {r9, sl}
    10b0:	000005a3 	andeq	r0, r0, r3, lsr #11
    10b4:	07dd0e04 	ldrbeq	r0, [sp, r4, lsl #28]
    10b8:	1f060000 	svcne	0x00060000
    10bc:	0005a913 	andeq	sl, r5, r3, lsl r9
    10c0:	18000800 	stmdane	r0, {fp}
    10c4:	00056e04 	andeq	r6, r5, r4, lsl #28
    10c8:	74041800 	strvc	r1, [r4], #-2048	; 0xfffff800
    10cc:	0d000004 	stceq	0, cr0, [r0, #-16]
    10d0:	00000a55 	andeq	r0, r0, r5, asr sl
    10d4:	07220614 			; <UNDEFINED> instruction: 0x07220614
    10d8:	00000831 	andeq	r0, r0, r1, lsr r8
    10dc:	0006090e 	andeq	r0, r6, lr, lsl #18
    10e0:	12260600 	eorne	r0, r6, #0, 12
    10e4:	0000004d 	andeq	r0, r0, sp, asr #32
    10e8:	08410e00 	stmdaeq	r1, {r9, sl, fp}^
    10ec:	29060000 	stmdbcs	r6, {}	; <UNPREDICTABLE>
    10f0:	0005a31d 	andeq	sl, r5, sp, lsl r3
    10f4:	b30e0400 	movwlt	r0, #58368	; 0xe400
    10f8:	06000005 	streq	r0, [r0], -r5
    10fc:	05a31d2c 	streq	r1, [r3, #3372]!	; 0xd2c
    1100:	1b080000 	blne	201108 <__bss_end+0x1f7410>
    1104:	000005d8 	ldrdeq	r0, [r0], -r8
    1108:	940e2f06 	strls	r2, [lr], #-3846	; 0xfffff0fa
    110c:	f700000b 			; <UNDEFINED> instruction: 0xf700000b
    1110:	02000005 	andeq	r0, r0, #5
    1114:	10000006 	andne	r0, r0, r6
    1118:	00000836 	andeq	r0, r0, r6, lsr r8
    111c:	0005a311 	andeq	sl, r5, r1, lsl r3
    1120:	181c0000 	ldmdane	ip, {}	; <UNPREDICTABLE>
    1124:	06000006 	streq	r0, [r0], -r6
    1128:	0c2f0e31 	stceq	14, cr0, [pc], #-196	; 106c <shift+0x106c>
    112c:	03800000 	orreq	r0, r0, #0
    1130:	061a0000 	ldreq	r0, [sl], -r0
    1134:	06250000 	strteq	r0, [r5], -r0
    1138:	36100000 	ldrcc	r0, [r0], -r0
    113c:	11000008 	tstne	r0, r8
    1140:	000005a9 	andeq	r0, r0, r9, lsr #11
    1144:	07371300 	ldreq	r1, [r7, -r0, lsl #6]!
    1148:	35060000 	strcc	r0, [r6, #-0]
    114c:	0008ba1d 	andeq	fp, r8, sp, lsl sl
    1150:	0005a300 	andeq	sl, r5, r0, lsl #6
    1154:	063e0200 	ldrteq	r0, [lr], -r0, lsl #4
    1158:	06440000 	strbeq	r0, [r4], -r0
    115c:	36100000 	ldrcc	r0, [r0], -r0
    1160:	00000008 	andeq	r0, r0, r8
    1164:	000bec13 	andeq	lr, fp, r3, lsl ip
    1168:	1d370600 	ldcne	6, cr0, [r7, #-0]
    116c:	00000c09 	andeq	r0, r0, r9, lsl #24
    1170:	000005a3 	andeq	r0, r0, r3, lsr #11
    1174:	00065d02 	andeq	r5, r6, r2, lsl #26
    1178:	00066300 	andeq	r6, r6, r0, lsl #6
    117c:	08361000 	ldmdaeq	r6!, {ip}
    1180:	1d000000 	stcne	0, cr0, [r0, #-0]
    1184:	000008f6 	strdeq	r0, [r0], -r6
    1188:	4f443906 	svcmi	0x00443906
    118c:	0c000008 	stceq	0, cr0, [r0], {8}
    1190:	0a551302 	beq	1545da0 <__bss_end+0x153c0a8>
    1194:	3c060000 	stccc	0, cr0, [r6], {-0}
    1198:	00088d09 	andeq	r8, r8, r9, lsl #26
    119c:	00083600 	andeq	r3, r8, r0, lsl #12
    11a0:	068a0100 	streq	r0, [sl], r0, lsl #2
    11a4:	06900000 	ldreq	r0, [r0], r0
    11a8:	36100000 	ldrcc	r0, [r0], -r0
    11ac:	00000008 	andeq	r0, r0, r8
    11b0:	00064913 	andeq	r4, r6, r3, lsl r9
    11b4:	123f0600 	eorsne	r0, pc, #0, 12
    11b8:	00000b1b 	andeq	r0, r0, fp, lsl fp
    11bc:	0000004d 	andeq	r0, r0, sp, asr #32
    11c0:	0006a901 	andeq	sl, r6, r1, lsl #18
    11c4:	0006be00 	andeq	fp, r6, r0, lsl #28
    11c8:	08361000 	ldmdaeq	r6!, {ip}
    11cc:	58110000 	ldmdapl	r1, {}	; <UNPREDICTABLE>
    11d0:	11000008 	tstne	r0, r8
    11d4:	0000005e 	andeq	r0, r0, lr, asr r0
    11d8:	00038011 	andeq	r8, r3, r1, lsl r0
    11dc:	df140000 	svcle	0x00140000
    11e0:	06000006 	streq	r0, [r0], -r6
    11e4:	055b0e42 	ldrbeq	r0, [fp, #-3650]	; 0xfffff1be
    11e8:	d3010000 	movwle	r0, #4096	; 0x1000
    11ec:	d9000006 	stmdble	r0, {r1, r2}
    11f0:	10000006 	andne	r0, r0, r6
    11f4:	00000836 	andeq	r0, r0, r6, lsr r8
    11f8:	07631300 	strbeq	r1, [r3, -r0, lsl #6]!
    11fc:	45060000 	strmi	r0, [r6, #-0]
    1200:	00047117 	andeq	r7, r4, r7, lsl r1
    1204:	0005a900 	andeq	sl, r5, r0, lsl #18
    1208:	06f20100 	ldrbteq	r0, [r2], r0, lsl #2
    120c:	06f80000 	ldrbteq	r0, [r8], r0
    1210:	5e100000 	cdppl	0, 1, cr0, cr0, cr0, {0}
    1214:	00000008 	andeq	r0, r0, r8
    1218:	00095b13 	andeq	r5, r9, r3, lsl fp
    121c:	17480600 	strbne	r0, [r8, -r0, lsl #12]
    1220:	0000052e 	andeq	r0, r0, lr, lsr #10
    1224:	000005a9 	andeq	r0, r0, r9, lsr #11
    1228:	00071101 	andeq	r1, r7, r1, lsl #2
    122c:	00071c00 	andeq	r1, r7, r0, lsl #24
    1230:	085e1000 	ldmdaeq	lr, {ip}^
    1234:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1238:	00000000 	andeq	r0, r0, r0
    123c:	0007bc14 	andeq	fp, r7, r4, lsl ip
    1240:	0e4b0600 	cdpeq	6, 4, cr0, cr11, cr0, {0}
    1244:	00000904 	andeq	r0, r0, r4, lsl #18
    1248:	00073101 	andeq	r3, r7, r1, lsl #2
    124c:	00073700 	andeq	r3, r7, r0, lsl #14
    1250:	08361000 	ldmdaeq	r6!, {ip}
    1254:	13000000 	movwne	r0, #0
    1258:	00000618 	andeq	r0, r0, r8, lsl r6
    125c:	7c0e4d06 	stcvc	13, cr4, [lr], {6}
    1260:	80000005 	andhi	r0, r0, r5
    1264:	01000003 	tsteq	r0, r3
    1268:	00000750 	andeq	r0, r0, r0, asr r7
    126c:	0000075b 	andeq	r0, r0, fp, asr r7
    1270:	00083610 	andeq	r3, r8, r0, lsl r6
    1274:	004d1100 	subeq	r1, sp, r0, lsl #2
    1278:	13000000 	movwne	r0, #0
    127c:	0000096e 	andeq	r0, r0, lr, ror #18
    1280:	0e125006 	cdpeq	0, 1, cr5, cr2, cr6, {0}
    1284:	4d000008 	stcmi	0, cr0, [r0, #-32]	; 0xffffffe0
    1288:	01000000 	mrseq	r0, (UNDEF: 0)
    128c:	00000774 	andeq	r0, r0, r4, ror r7
    1290:	0000077f 	andeq	r0, r0, pc, ror r7
    1294:	00083610 	andeq	r3, r8, r0, lsl r6
    1298:	03af1100 			; <UNDEFINED> instruction: 0x03af1100
    129c:	13000000 	movwne	r0, #0
    12a0:	000006f3 	strdeq	r0, [r0], -r3
    12a4:	0b0e5306 	bleq	395ec4 <__bss_end+0x38c1cc>
    12a8:	80000007 	andhi	r0, r0, r7
    12ac:	01000003 	tsteq	r0, r3
    12b0:	00000798 	muleq	r0, r8, r7
    12b4:	000007a3 	andeq	r0, r0, r3, lsr #15
    12b8:	00083610 	andeq	r3, r8, r0, lsl r6
    12bc:	004d1100 	subeq	r1, sp, r0, lsl #2
    12c0:	14000000 	strne	r0, [r0], #-0
    12c4:	00000933 	andeq	r0, r0, r3, lsr r9
    12c8:	8e0e5606 	cfmadd32hi	mvax0, mvfx5, mvfx14, mvfx6
    12cc:	01000009 	tsteq	r0, r9
    12d0:	000007b8 			; <UNDEFINED> instruction: 0x000007b8
    12d4:	000007d7 	ldrdeq	r0, [r0], -r7
    12d8:	00083610 	andeq	r3, r8, r0, lsl r6
    12dc:	00a91100 	adceq	r1, r9, r0, lsl #2
    12e0:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    12e4:	11000000 	mrsne	r0, (UNDEF: 0)
    12e8:	0000004d 	andeq	r0, r0, sp, asr #32
    12ec:	00004d11 	andeq	r4, r0, r1, lsl sp
    12f0:	08641100 	stmdaeq	r4!, {r8, ip}^
    12f4:	14000000 	strne	r0, [r0], #-0
    12f8:	00000627 	andeq	r0, r0, r7, lsr #12
    12fc:	e60e5806 	str	r5, [lr], -r6, lsl #16
    1300:	01000009 	tsteq	r0, r9
    1304:	000007ec 	andeq	r0, r0, ip, ror #15
    1308:	0000080b 	andeq	r0, r0, fp, lsl #16
    130c:	00083610 	andeq	r3, r8, r0, lsl r6
    1310:	00f21100 	rscseq	r1, r2, r0, lsl #2
    1314:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1318:	11000000 	mrsne	r0, (UNDEF: 0)
    131c:	0000004d 	andeq	r0, r0, sp, asr #32
    1320:	00004d11 	andeq	r4, r0, r1, lsl sp
    1324:	08641100 	stmdaeq	r4!, {r8, ip}^
    1328:	15000000 	strne	r0, [r0, #-0]
    132c:	000008a7 	andeq	r0, r0, r7, lsr #17
    1330:	d80e5b06 	stmdale	lr, {r1, r2, r8, r9, fp, ip, lr}
    1334:	8000000a 	andhi	r0, r0, sl
    1338:	01000003 	tsteq	r0, r3
    133c:	00000820 	andeq	r0, r0, r0, lsr #16
    1340:	00083610 	andeq	r3, r8, r0, lsl r6
    1344:	05261100 	streq	r1, [r6, #-256]!	; 0xffffff00
    1348:	6a110000 	bvs	441350 <__bss_end+0x437658>
    134c:	00000008 	andeq	r0, r0, r8
    1350:	05af0300 	streq	r0, [pc, #768]!	; 1658 <shift+0x1658>
    1354:	04180000 	ldreq	r0, [r8], #-0
    1358:	000005af 	andeq	r0, r0, pc, lsr #11
    135c:	0005a31e 	andeq	sl, r5, lr, lsl r3
    1360:	00084900 	andeq	r4, r8, r0, lsl #18
    1364:	00084f00 	andeq	r4, r8, r0, lsl #30
    1368:	08361000 	ldmdaeq	r6!, {ip}
    136c:	1f000000 	svcne	0x00000000
    1370:	000005af 	andeq	r0, r0, pc, lsr #11
    1374:	0000083c 	andeq	r0, r0, ip, lsr r8
    1378:	003f0418 	eorseq	r0, pc, r8, lsl r4	; <UNPREDICTABLE>
    137c:	04180000 	ldreq	r0, [r8], #-0
    1380:	00000831 	andeq	r0, r0, r1, lsr r8
    1384:	00650420 	rsbeq	r0, r5, r0, lsr #8
    1388:	04210000 	strteq	r0, [r1], #-0
    138c:	0007771a 	andeq	r7, r7, sl, lsl r7
    1390:	195e0600 	ldmdbne	lr, {r9, sl}^
    1394:	000005af 	andeq	r0, r0, pc, lsr #11
    1398:	00002c16 	andeq	r2, r0, r6, lsl ip
    139c:	00088800 	andeq	r8, r8, r0, lsl #16
    13a0:	005e1700 	subseq	r1, lr, r0, lsl #14
    13a4:	00090000 	andeq	r0, r9, r0
    13a8:	00087803 	andeq	r7, r8, r3, lsl #16
    13ac:	0e4d2200 	cdpeq	2, 4, cr2, cr13, cr0, {0}
    13b0:	ae010000 	cdpge	0, 0, cr0, cr1, cr0, {0}
    13b4:	0008880c 	andeq	r8, r8, ip, lsl #16
    13b8:	c0030500 	andgt	r0, r3, r0, lsl #10
    13bc:	2300009c 	movwcs	r0, #156	; 0x9c
    13c0:	00000d86 	andeq	r0, r0, r6, lsl #27
    13c4:	e40ab001 	str	fp, [sl], #-1
    13c8:	4d00000e 	stcmi	0, cr0, [r0, #-56]	; 0xffffffc8
    13cc:	48000000 	stmdami	r0, {}	; <UNPREDICTABLE>
    13d0:	b4000086 	strlt	r0, [r0], #-134	; 0xffffff7a
    13d4:	01000000 	mrseq	r0, (UNDEF: 0)
    13d8:	0008fd9c 	muleq	r8, ip, sp
    13dc:	1bed2400 	blne	ffb4a3e4 <__bss_end+0xffb406ec>
    13e0:	b0010000 	andlt	r0, r1, r0
    13e4:	00038d1b 	andeq	r8, r3, fp, lsl sp
    13e8:	ac910300 	ldcge	3, cr0, [r1], {0}
    13ec:	0f43247f 	svceq	0x0043247f
    13f0:	b0010000 	andlt	r0, r1, r0
    13f4:	00004d2a 	andeq	r4, r0, sl, lsr #26
    13f8:	a8910300 	ldmge	r1, {r8, r9}
    13fc:	0eba227f 	mrceq	2, 5, r2, cr10, cr15, {3}
    1400:	b2010000 	andlt	r0, r1, #0
    1404:	0008fd0a 	andeq	pc, r8, sl, lsl #26
    1408:	b4910300 	ldrlt	r0, [r1], #768	; 0x300
    140c:	0d81227f 	sfmeq	f2, 4, [r1, #508]	; 0x1fc
    1410:	b6010000 	strlt	r0, [r1], -r0
    1414:	00003809 	andeq	r3, r0, r9, lsl #16
    1418:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    141c:	00251600 	eoreq	r1, r5, r0, lsl #12
    1420:	090d0000 	stmdbeq	sp, {}	; <UNPREDICTABLE>
    1424:	5e170000 	cdppl	0, 1, cr0, cr7, cr0, {0}
    1428:	3f000000 	svccc	0x00000000
    142c:	0f282500 	svceq	0x00282500
    1430:	a2010000 	andge	r0, r1, #0
    1434:	000fd70a 	andeq	sp, pc, sl, lsl #14
    1438:	00004d00 	andeq	r4, r0, r0, lsl #26
    143c:	00860c00 	addeq	r0, r6, r0, lsl #24
    1440:	00003c00 	andeq	r3, r0, r0, lsl #24
    1444:	4a9c0100 	bmi	fe70184c <__bss_end+0xfe6f7b54>
    1448:	26000009 	strcs	r0, [r0], -r9
    144c:	00716572 	rsbseq	r6, r1, r2, ror r5
    1450:	6920a401 	stmdbvs	r0!, {r0, sl, sp, pc}
    1454:	02000005 	andeq	r0, r0, #5
    1458:	d9227491 	stmdble	r2!, {r0, r4, r7, sl, ip, sp, lr}
    145c:	0100000e 	tsteq	r0, lr
    1460:	004d0ea5 	subeq	r0, sp, r5, lsr #29
    1464:	91020000 	mrsls	r0, (UNDEF: 2)
    1468:	85270070 	strhi	r0, [r7, #-112]!	; 0xffffff90
    146c:	0100000f 	tsteq	r0, pc
    1470:	0da20699 	stceq	6, cr0, [r2, #612]!	; 0x264
    1474:	85d00000 	ldrbhi	r0, [r0]
    1478:	003c0000 	eorseq	r0, ip, r0
    147c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1480:	00000983 	andeq	r0, r0, r3, lsl #19
    1484:	000e3924 	andeq	r3, lr, r4, lsr #18
    1488:	21990100 	orrscs	r0, r9, r0, lsl #2
    148c:	0000004d 	andeq	r0, r0, sp, asr #32
    1490:	266c9102 	strbtcs	r9, [ip], -r2, lsl #2
    1494:	00716572 	rsbseq	r6, r1, r2, ror r5
    1498:	69209b01 	stmdbvs	r0!, {r0, r8, r9, fp, ip, pc}
    149c:	02000005 	andeq	r0, r0, #5
    14a0:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    14a4:	00000f05 	andeq	r0, r0, r5, lsl #30
    14a8:	690a8d01 	stmdbvs	sl, {r0, r8, sl, fp, pc}
    14ac:	4d00000e 	stcmi	0, cr0, [r0, #-56]	; 0xffffffc8
    14b0:	94000000 	strls	r0, [r0], #-0
    14b4:	3c000085 	stccc	0, cr0, [r0], {133}	; 0x85
    14b8:	01000000 	mrseq	r0, (UNDEF: 0)
    14bc:	0009c09c 	muleq	r9, ip, r0
    14c0:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    14c4:	8f010071 	svchi	0x00010071
    14c8:	00054520 	andeq	r4, r5, r0, lsr #10
    14cc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    14d0:	000d7a22 	andeq	r7, sp, r2, lsr #20
    14d4:	0e900100 	fmleqs	f0, f0, f0
    14d8:	0000004d 	andeq	r0, r0, sp, asr #32
    14dc:	00709102 	rsbseq	r9, r0, r2, lsl #2
    14e0:	0010b925 	andseq	fp, r0, r5, lsr #18
    14e4:	0a810100 	beq	fe0418ec <__bss_end+0xfe037bf4>
    14e8:	00000de6 	andeq	r0, r0, r6, ror #27
    14ec:	0000004d 	andeq	r0, r0, sp, asr #32
    14f0:	00008558 	andeq	r8, r0, r8, asr r5
    14f4:	0000003c 	andeq	r0, r0, ip, lsr r0
    14f8:	09fd9c01 	ldmibeq	sp!, {r0, sl, fp, ip, pc}^
    14fc:	72260000 	eorvc	r0, r6, #0
    1500:	01007165 	tsteq	r0, r5, ror #2
    1504:	05452083 	strbeq	r2, [r5, #-131]	; 0xffffff7d
    1508:	91020000 	mrsls	r0, (UNDEF: 2)
    150c:	0d7a2274 	lfmeq	f2, 2, [sl, #-464]!	; 0xfffffe30
    1510:	84010000 	strhi	r0, [r1], #-0
    1514:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1518:	70910200 	addsvc	r0, r1, r0, lsl #4
    151c:	0e7d2500 	cdpeq	5, 7, cr2, cr13, cr0, {0}
    1520:	75010000 	strvc	r0, [r1, #-0]
    1524:	000fa206 	andeq	sl, pc, r6, lsl #4
    1528:	00038000 	andeq	r8, r3, r0
    152c:	00850400 	addeq	r0, r5, r0, lsl #8
    1530:	00005400 	andeq	r5, r0, r0, lsl #8
    1534:	499c0100 	ldmibmi	ip, {r8}
    1538:	2400000a 	strcs	r0, [r0], #-10
    153c:	00000ed9 	ldrdeq	r0, [r0], -r9
    1540:	4d157501 	cfldr32mi	mvfx7, [r5, #-4]
    1544:	02000000 	andeq	r0, r0, #0
    1548:	f8246c91 			; <UNDEFINED> instruction: 0xf8246c91
    154c:	01000003 	tsteq	r0, r3
    1550:	004d2575 	subeq	r2, sp, r5, ror r5
    1554:	91020000 	mrsls	r0, (UNDEF: 2)
    1558:	10b12268 	adcsne	r2, r1, r8, ror #4
    155c:	77010000 	strvc	r0, [r1, -r0]
    1560:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1564:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1568:	0db92500 	cfldr32eq	mvfx2, [r9]
    156c:	68010000 	stmdavs	r1, {}	; <UNPREDICTABLE>
    1570:	00100e12 	andseq	r0, r0, r2, lsl lr
    1574:	00008b00 	andeq	r8, r0, r0, lsl #22
    1578:	0084b400 	addeq	fp, r4, r0, lsl #8
    157c:	00005000 	andeq	r5, r0, r0
    1580:	a49c0100 	ldrge	r0, [ip], #256	; 0x100
    1584:	2400000a 	strcs	r0, [r0], #-10
    1588:	00000fad 	andeq	r0, r0, sp, lsr #31
    158c:	4d206801 	stcmi	8, cr6, [r0, #-4]!
    1590:	02000000 	andeq	r0, r0, #0
    1594:	0e246c91 	mcreq	12, 1, r6, cr4, cr1, {4}
    1598:	0100000f 	tsteq	r0, pc
    159c:	004d2f68 	subeq	r2, sp, r8, ror #30
    15a0:	91020000 	mrsls	r0, (UNDEF: 2)
    15a4:	03f82468 	mvnseq	r2, #104, 8	; 0x68000000
    15a8:	68010000 	stmdavs	r1, {}	; <UNPREDICTABLE>
    15ac:	00004d3f 	andeq	r4, r0, pc, lsr sp
    15b0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    15b4:	0010b122 	andseq	fp, r0, r2, lsr #2
    15b8:	166a0100 	strbtne	r0, [sl], -r0, lsl #2
    15bc:	0000008b 	andeq	r0, r0, fp, lsl #1
    15c0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    15c4:	000ed225 	andeq	sp, lr, r5, lsr #4
    15c8:	0a5c0100 	beq	17019d0 <__bss_end+0x16f7cd8>
    15cc:	00000dbe 			; <UNDEFINED> instruction: 0x00000dbe
    15d0:	0000004d 	andeq	r0, r0, sp, asr #32
    15d4:	00008470 	andeq	r8, r0, r0, ror r4
    15d8:	00000044 	andeq	r0, r0, r4, asr #32
    15dc:	0af09c01 	beq	ffc285e8 <__bss_end+0xffc1e8f0>
    15e0:	ad240000 	stcge	0, cr0, [r4, #-0]
    15e4:	0100000f 	tsteq	r0, pc
    15e8:	004d1a5c 	subeq	r1, sp, ip, asr sl
    15ec:	91020000 	mrsls	r0, (UNDEF: 2)
    15f0:	0f0e246c 	svceq	0x000e246c
    15f4:	5c010000 	stcpl	0, cr0, [r1], {-0}
    15f8:	00004d29 	andeq	r4, r0, r9, lsr #26
    15fc:	68910200 	ldmvs	r1, {r9}
    1600:	00103d22 	andseq	r3, r0, r2, lsr #26
    1604:	0e5e0100 	rdfeqe	f0, f6, f0
    1608:	0000004d 	andeq	r0, r0, sp, asr #32
    160c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1610:	00103725 	andseq	r3, r0, r5, lsr #14
    1614:	0a4f0100 	beq	13c1a1c <__bss_end+0x13b7d24>
    1618:	00001019 	andeq	r1, r0, r9, lsl r0
    161c:	0000004d 	andeq	r0, r0, sp, asr #32
    1620:	00008420 	andeq	r8, r0, r0, lsr #8
    1624:	00000050 	andeq	r0, r0, r0, asr r0
    1628:	0b4b9c01 	bleq	12e8634 <__bss_end+0x12de93c>
    162c:	ad240000 	stcge	0, cr0, [r4, #-0]
    1630:	0100000f 	tsteq	r0, pc
    1634:	004d194f 	subeq	r1, sp, pc, asr #18
    1638:	91020000 	mrsls	r0, (UNDEF: 2)
    163c:	0e9b246c 	cdpeq	4, 9, cr2, cr11, cr12, {3}
    1640:	4f010000 	svcmi	0x00010000
    1644:	00012f30 	andeq	r2, r1, r0, lsr pc
    1648:	68910200 	ldmvs	r1, {r9}
    164c:	000f1424 	andeq	r1, pc, r4, lsr #8
    1650:	414f0100 	mrsmi	r0, (UNDEF: 95)
    1654:	0000086a 	andeq	r0, r0, sl, ror #16
    1658:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    165c:	000010b1 	strheq	r1, [r0], -r1	; <UNPREDICTABLE>
    1660:	4d0e5101 	stfmis	f5, [lr, #-4]
    1664:	02000000 	andeq	r0, r0, #0
    1668:	27007491 			; <UNDEFINED> instruction: 0x27007491
    166c:	00000c84 	andeq	r0, r0, r4, lsl #25
    1670:	a5064901 	strge	r4, [r6, #-2305]	; 0xfffff6ff
    1674:	f400000e 	vst4.8	{d0-d3}, [r0], lr
    1678:	2c000083 	stccs	0, cr0, [r0], {131}	; 0x83
    167c:	01000000 	mrseq	r0, (UNDEF: 0)
    1680:	000b759c 	muleq	fp, ip, r5
    1684:	0fad2400 	svceq	0x00ad2400
    1688:	49010000 	stmdbmi	r1, {}	; <UNPREDICTABLE>
    168c:	00004d15 	andeq	r4, r0, r5, lsl sp
    1690:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1694:	0f7f2500 	svceq	0x007f2500
    1698:	3c010000 	stccc	0, cr0, [r1], {-0}
    169c:	000f1a0a 	andeq	r1, pc, sl, lsl #20
    16a0:	00004d00 	andeq	r4, r0, r0, lsl #26
    16a4:	0083a400 	addeq	sl, r3, r0, lsl #8
    16a8:	00005000 	andeq	r5, r0, r0
    16ac:	d09c0100 	addsle	r0, ip, r0, lsl #2
    16b0:	2400000b 	strcs	r0, [r0], #-11
    16b4:	00000fad 	andeq	r0, r0, sp, lsr #31
    16b8:	4d193c01 	ldcmi	12, cr3, [r9, #-4]
    16bc:	02000000 	andeq	r0, r0, #0
    16c0:	53246c91 			; <UNDEFINED> instruction: 0x53246c91
    16c4:	01000010 	tsteq	r0, r0, lsl r0
    16c8:	038d2b3c 	orreq	r2, sp, #60, 22	; 0xf000
    16cc:	91020000 	mrsls	r0, (UNDEF: 2)
    16d0:	0f472468 	svceq	0x00472468
    16d4:	3c010000 	stccc	0, cr0, [r1], {-0}
    16d8:	00004d3c 	andeq	r4, r0, ip, lsr sp
    16dc:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    16e0:	00100822 	andseq	r0, r0, r2, lsr #16
    16e4:	0e3e0100 	rsfeqe	f0, f6, f0
    16e8:	0000004d 	andeq	r0, r0, sp, asr #32
    16ec:	00749102 	rsbseq	r9, r4, r2, lsl #2
    16f0:	0010db25 	andseq	sp, r0, r5, lsr #22
    16f4:	0a2f0100 	beq	bc1afc <__bss_end+0xbb7e04>
    16f8:	0000105a 	andeq	r1, r0, sl, asr r0
    16fc:	0000004d 	andeq	r0, r0, sp, asr #32
    1700:	00008354 	andeq	r8, r0, r4, asr r3
    1704:	00000050 	andeq	r0, r0, r0, asr r0
    1708:	0c2b9c01 	stceq	12, cr9, [fp], #-4
    170c:	ad240000 	stcge	0, cr0, [r4, #-0]
    1710:	0100000f 	tsteq	r0, pc
    1714:	004d182f 	subeq	r1, sp, pc, lsr #16
    1718:	91020000 	mrsls	r0, (UNDEF: 2)
    171c:	1053246c 	subsne	r2, r3, ip, ror #8
    1720:	2f010000 	svccs	0x00010000
    1724:	000c312a 	andeq	r3, ip, sl, lsr #2
    1728:	68910200 	ldmvs	r1, {r9}
    172c:	000f4724 	andeq	r4, pc, r4, lsr #14
    1730:	3b2f0100 	blcc	bc1b38 <__bss_end+0xbb7e40>
    1734:	0000004d 	andeq	r0, r0, sp, asr #32
    1738:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    173c:	00000d8b 	andeq	r0, r0, fp, lsl #27
    1740:	4d0e3101 	stfmis	f3, [lr, #-4]
    1744:	02000000 	andeq	r0, r0, #0
    1748:	18007491 	stmdane	r0, {r0, r4, r7, sl, ip, sp, lr}
    174c:	00002504 	andeq	r2, r0, r4, lsl #10
    1750:	0c2b0300 	stceq	3, cr0, [fp], #-0
    1754:	df250000 	svcle	0x00250000
    1758:	0100000e 	tsteq	r0, lr
    175c:	0f630a23 	svceq	0x00630a23
    1760:	004d0000 	subeq	r0, sp, r0
    1764:	83100000 	tsthi	r0, #0
    1768:	00440000 	subeq	r0, r4, r0
    176c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1770:	00000c82 	andeq	r0, r0, r2, lsl #25
    1774:	0010d224 	andseq	sp, r0, r4, lsr #4
    1778:	1b230100 	blne	8c1b80 <__bss_end+0x8b7e88>
    177c:	0000038d 	andeq	r0, r0, sp, lsl #7
    1780:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1784:	0000104e 	andeq	r1, r0, lr, asr #32
    1788:	d8352301 	ldmdale	r5!, {r0, r8, r9, sp}
    178c:	02000001 	andeq	r0, r0, #1
    1790:	ad226891 	stcge	8, cr6, [r2, #-580]!	; 0xfffffdbc
    1794:	0100000f 	tsteq	r0, pc
    1798:	004d0e25 	subeq	r0, sp, r5, lsr #28
    179c:	91020000 	mrsls	r0, (UNDEF: 2)
    17a0:	2d280074 	stccs	0, cr0, [r8, #-464]!	; 0xfffffe30
    17a4:	0100000e 	tsteq	r0, lr
    17a8:	0d91061e 	ldceq	6, cr0, [r1, #120]	; 0x78
    17ac:	82f40000 	rscshi	r0, r4, #0
    17b0:	001c0000 	andseq	r0, ip, r0
    17b4:	9c010000 	stcls	0, cr0, [r1], {-0}
    17b8:	00104427 	andseq	r4, r0, r7, lsr #8
    17bc:	06180100 	ldreq	r0, [r8], -r0, lsl #2
    17c0:	00000dca 	andeq	r0, r0, sl, asr #27
    17c4:	000082c8 	andeq	r8, r0, r8, asr #5
    17c8:	0000002c 	andeq	r0, r0, ip, lsr #32
    17cc:	0cc29c01 	stcleq	12, cr9, [r2], {1}
    17d0:	dd240000 	stcle	0, cr0, [r4, #-0]
    17d4:	0100000d 	tsteq	r0, sp
    17d8:	00381418 	eorseq	r1, r8, r8, lsl r4
    17dc:	91020000 	mrsls	r0, (UNDEF: 2)
    17e0:	c0250074 	eorgt	r0, r5, r4, ror r0
    17e4:	0100000e 	tsteq	r0, lr
    17e8:	0f4c0a0e 	svceq	0x004c0a0e
    17ec:	004d0000 	subeq	r0, sp, r0
    17f0:	829c0000 	addshi	r0, ip, #0
    17f4:	002c0000 	eoreq	r0, ip, r0
    17f8:	9c010000 	stcls	0, cr0, [r1], {-0}
    17fc:	00000cf0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1800:	676e7226 	strbvs	r7, [lr, -r6, lsr #4]!
    1804:	0e100100 	mufeqs	f0, f0, f0
    1808:	0000004d 	andeq	r0, r0, sp, asr #32
    180c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1810:	0010e029 	andseq	lr, r0, r9, lsr #32
    1814:	0a040100 	beq	101c1c <__bss_end+0xf7f24>
    1818:	00000eaf 	andeq	r0, r0, pc, lsr #29
    181c:	0000004d 	andeq	r0, r0, sp, asr #32
    1820:	00008270 	andeq	r8, r0, r0, ror r2
    1824:	0000002c 	andeq	r0, r0, ip, lsr #32
    1828:	70269c01 	eorvc	r9, r6, r1, lsl #24
    182c:	01006469 	tsteq	r0, r9, ror #8
    1830:	004d0e06 	subeq	r0, sp, r6, lsl #28
    1834:	91020000 	mrsls	r0, (UNDEF: 2)
    1838:	eb000074 	bl	1a10 <shift+0x1a10>
    183c:	04000005 	streq	r0, [r0], #-5
    1840:	0006a200 	andeq	sl, r6, r0, lsl #4
    1844:	97010400 	strls	r0, [r1, -r0, lsl #8]
    1848:	0400000c 	streq	r0, [r0], #-12
    184c:	00001111 	andeq	r1, r0, r1, lsl r1
    1850:	00000e04 	andeq	r0, r0, r4, lsl #28
    1854:	00008700 	andeq	r8, r0, r0, lsl #14
    1858:	00000e9c 	muleq	r0, ip, lr
    185c:	0000062f 	andeq	r0, r0, pc, lsr #12
    1860:	00004902 	andeq	r4, r0, r2, lsl #18
    1864:	120a0300 	andne	r0, sl, #0, 6
    1868:	04010000 	streq	r0, [r1], #-0
    186c:	00006110 	andeq	r6, r0, r0, lsl r1
    1870:	31301100 	teqcc	r0, r0, lsl #2
    1874:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
    1878:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
    187c:	44434241 	strbmi	r4, [r3], #-577	; 0xfffffdbf
    1880:	00004645 	andeq	r4, r0, r5, asr #12
    1884:	01030104 	tsteq	r3, r4, lsl #2
    1888:	00000025 	andeq	r0, r0, r5, lsr #32
    188c:	00007405 	andeq	r7, r0, r5, lsl #8
    1890:	00006100 	andeq	r6, r0, r0, lsl #2
    1894:	00660600 	rsbeq	r0, r6, r0, lsl #12
    1898:	00100000 	andseq	r0, r0, r0
    189c:	00005107 	andeq	r5, r0, r7, lsl #2
    18a0:	07040800 	streq	r0, [r4, -r0, lsl #16]
    18a4:	00001805 	andeq	r1, r0, r5, lsl #16
    18a8:	53080108 	movwpl	r0, #33032	; 0x8108
    18ac:	07000007 	streq	r0, [r0, -r7]
    18b0:	0000006d 	andeq	r0, r0, sp, rrx
    18b4:	00002a09 	andeq	r2, r0, r9, lsl #20
    18b8:	115e0a00 	cmpne	lr, r0, lsl #20
    18bc:	f0010000 			; <UNDEFINED> instruction: 0xf0010000
    18c0:	00126a06 	andseq	r6, r2, r6, lsl #20
    18c4:	0000f300 	andeq	pc, r0, r0, lsl #6
    18c8:	0093d400 	addseq	sp, r3, r0, lsl #8
    18cc:	0001c800 	andeq	ip, r1, r0, lsl #16
    18d0:	f39c0100 	vaddw.u16	q0, q6, d0
    18d4:	0b000000 	bleq	18dc <shift+0x18dc>
    18d8:	00727473 	rsbseq	r7, r2, r3, ror r4
    18dc:	fa1bf001 	blx	6fd8e8 <__bss_end+0x6f3bf0>
    18e0:	02000000 	andeq	r0, r0, #0
    18e4:	630c5c91 	movwvs	r5, #52369	; 0xcc91
    18e8:	0af10100 	beq	ffc41cf0 <__bss_end+0xffc37ff8>
    18ec:	0000006d 	andeq	r0, r0, sp, rrx
    18f0:	0d679102 	stfeqp	f1, [r7, #-8]!
    18f4:	000010fb 	strdeq	r1, [r0], -fp
    18f8:	f30af201 	vhsub.u8	d15, d10, d1
    18fc:	02000000 	andeq	r0, r0, #0
    1900:	a60d7791 			; <UNDEFINED> instruction: 0xa60d7791
    1904:	01000011 	tsteq	r0, r1, lsl r0
    1908:	010009f3 	strdeq	r0, [r0, -r3]
    190c:	91020000 	mrsls	r0, (UNDEF: 2)
    1910:	10f40d70 	rscsne	r0, r4, r0, ror sp
    1914:	f4010000 	vst4.8	{d0-d3}, [r1], r0
    1918:	00010009 	andeq	r0, r1, r9
    191c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1920:	0100690c 	tsteq	r0, ip, lsl #18
    1924:	010009fe 	strdeq	r0, [r0, -lr]
    1928:	91020000 	mrsls	r0, (UNDEF: 2)
    192c:	01080068 	tsteq	r8, r8, rrx
    1930:	00060402 	andeq	r0, r6, r2, lsl #8
    1934:	74040e00 	strvc	r0, [r4], #-3584	; 0xfffff200
    1938:	0f000000 	svceq	0x00000000
    193c:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    1940:	e10a0074 	hlt	0xa004
    1944:	01000011 	tsteq	r0, r1, lsl r0
    1948:	125806d2 	subsne	r0, r8, #220200960	; 0xd200000
    194c:	00f30000 	rscseq	r0, r3, r0
    1950:	92bc0000 	adcsls	r0, ip, #0
    1954:	01180000 	tsteq	r8, r0
    1958:	9c010000 	stcls	0, cr0, [r1], {-0}
    195c:	0000015e 	andeq	r0, r0, lr, asr r1
    1960:	7274730b 	rsbsvc	r7, r4, #738197504	; 0x2c000000
    1964:	1dd20100 	ldfnee	f0, [r2]
    1968:	000000fa 	strdeq	r0, [r0], -sl
    196c:	0c649102 	stfeqp	f1, [r4], #-8
    1970:	d3010063 	movwle	r0, #4195	; 0x1063
    1974:	00006d0a 	andeq	r6, r0, sl, lsl #26
    1978:	6f910200 	svcvs	0x00910200
    197c:	000f470d 	andeq	r4, pc, sp, lsl #14
    1980:	09d60100 	ldmibeq	r6, {r8}^
    1984:	00000100 	andeq	r0, r0, r0, lsl #2
    1988:	0c749102 	ldfeqp	f1, [r4], #-8
    198c:	e0010069 	and	r0, r1, r9, rrx
    1990:	00010009 	andeq	r0, r1, r9
    1994:	70910200 	addsvc	r0, r1, r0, lsl #4
    1998:	11f51000 	mvnsne	r1, r0
    199c:	ce010000 	cdpgt	0, 0, cr0, cr1, cr0, {0}
    19a0:	0010e706 	andseq	lr, r0, r6, lsl #14
    19a4:	0000f300 	andeq	pc, r0, r0, lsl #6
    19a8:	00927400 	addseq	r7, r2, r0, lsl #8
    19ac:	00004800 	andeq	r4, r0, r0, lsl #16
    19b0:	8a9c0100 	bhi	fe701db8 <__bss_end+0xfe6f80c0>
    19b4:	0b000001 	bleq	19c0 <shift+0x19c0>
    19b8:	ce010063 	cdpgt	0, 0, cr0, cr1, cr3, {3}
    19bc:	00006d14 	andeq	r6, r0, r4, lsl sp
    19c0:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    19c4:	123a1100 	eorsne	r1, sl, #0, 2
    19c8:	c6010000 	strgt	r0, [r1], -r0
    19cc:	00110106 	andseq	r0, r1, r6, lsl #2
    19d0:	0091f400 	addseq	pc, r1, r0, lsl #8
    19d4:	00008000 	andeq	r8, r0, r0
    19d8:	079c0100 	ldreq	r0, [ip, r0, lsl #2]
    19dc:	0b000002 	bleq	19ec <shift+0x19ec>
    19e0:	00637273 	rsbeq	r7, r3, r3, ror r2
    19e4:	0719c601 	ldreq	ip, [r9, -r1, lsl #12]
    19e8:	02000002 	andeq	r0, r0, #2
    19ec:	640b6491 	strvs	r6, [fp], #-1169	; 0xfffffb6f
    19f0:	01007473 	tsteq	r0, r3, ror r4
    19f4:	020e24c6 	andeq	r2, lr, #-973078528	; 0xc6000000
    19f8:	91020000 	mrsls	r0, (UNDEF: 2)
    19fc:	756e0b60 	strbvc	r0, [lr, #-2912]!	; 0xfffff4a0
    1a00:	c601006d 	strgt	r0, [r1], -sp, rrx
    1a04:	0001002d 	andeq	r0, r1, sp, lsr #32
    1a08:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1a0c:	0012250d 	andseq	r2, r2, sp, lsl #10
    1a10:	11c70100 	bicne	r0, r7, r0, lsl #2
    1a14:	000000fa 	strdeq	r0, [r0], -sl
    1a18:	0d709102 	ldfeqp	f1, [r0, #-8]!
    1a1c:	00001203 	andeq	r1, r0, r3, lsl #4
    1a20:	100bc801 	andne	ip, fp, r1, lsl #16
    1a24:	02000002 	andeq	r0, r0, #2
    1a28:	1c126c91 	ldcne	12, cr6, [r2], {145}	; 0x91
    1a2c:	48000092 	stmdami	r0, {r1, r4, r7}
    1a30:	0c000000 	stceq	0, cr0, [r0], {-0}
    1a34:	ca010069 	bgt	41be0 <__bss_end+0x37ee8>
    1a38:	0001000e 	andeq	r0, r1, lr
    1a3c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1a40:	040e0000 	streq	r0, [lr], #-0
    1a44:	0000020d 	andeq	r0, r0, sp, lsl #4
    1a48:	0e041413 	cfmvdlreq	mvd4, r1
    1a4c:	00006d04 	andeq	r6, r0, r4, lsl #26
    1a50:	12341100 	eorsne	r1, r4, #0, 2
    1a54:	bf010000 	svclt	0x00010000
    1a58:	0011b206 	andseq	fp, r1, r6, lsl #4
    1a5c:	00918c00 	addseq	r8, r1, r0, lsl #24
    1a60:	00006800 	andeq	r6, r0, r0, lsl #16
    1a64:	759c0100 	ldrvc	r0, [ip, #256]	; 0x100
    1a68:	15000002 	strne	r0, [r0, #-2]
    1a6c:	000012bf 			; <UNDEFINED> instruction: 0x000012bf
    1a70:	0e12bf01 	cdpeq	15, 1, cr11, cr2, cr1, {0}
    1a74:	02000002 	andeq	r0, r0, #2
    1a78:	c6156c91 			; <UNDEFINED> instruction: 0xc6156c91
    1a7c:	01000012 	tsteq	r0, r2, lsl r0
    1a80:	01001ebf 			; <UNDEFINED> instruction: 0x01001ebf
    1a84:	91020000 	mrsls	r0, (UNDEF: 2)
    1a88:	656d0c68 	strbvs	r0, [sp, #-3176]!	; 0xfffff398
    1a8c:	c001006d 	andgt	r0, r1, sp, rrx
    1a90:	0002100b 	andeq	r1, r2, fp
    1a94:	70910200 	addsvc	r0, r1, r0, lsl #4
    1a98:	0091a812 	addseq	sl, r1, r2, lsl r8
    1a9c:	00003c00 	andeq	r3, r0, r0, lsl #24
    1aa0:	00690c00 	rsbeq	r0, r9, r0, lsl #24
    1aa4:	000ec201 	andeq	ip, lr, r1, lsl #4
    1aa8:	02000001 	andeq	r0, r0, #1
    1aac:	00007491 	muleq	r0, r1, r4
    1ab0:	00119c10 	andseq	r9, r1, r0, lsl ip
    1ab4:	06b40100 	ldrteq	r0, [r4], r0, lsl #2
    1ab8:	00001180 	andeq	r1, r0, r0, lsl #3
    1abc:	000000f3 	strdeq	r0, [r0], -r3
    1ac0:	0000910c 	andeq	r9, r0, ip, lsl #2
    1ac4:	00000080 	andeq	r0, r0, r0, lsl #1
    1ac8:	02bf9c01 	adcseq	r9, pc, #256	; 0x100
    1acc:	ad150000 	ldcge	0, cr0, [r5, #-0]
    1ad0:	01000012 	tsteq	r0, r2, lsl r0
    1ad4:	00fa1cb4 	ldrhteq	r1, [sl], #196	; 0xc4
    1ad8:	91020000 	mrsls	r0, (UNDEF: 2)
    1adc:	1167156c 	cmnne	r7, ip, ror #10
    1ae0:	b4010000 	strlt	r0, [r1], #-0
    1ae4:	0000742f 	andeq	r7, r0, pc, lsr #8
    1ae8:	6b910200 	blvs	fe4422f0 <__bss_end+0xfe4385f8>
    1aec:	0100690c 	tsteq	r0, ip, lsl #18
    1af0:	010009b5 			; <UNDEFINED> instruction: 0x010009b5
    1af4:	91020000 	mrsls	r0, (UNDEF: 2)
    1af8:	6e100074 	mrcvs	0, 0, r0, cr0, cr4, {3}
    1afc:	01000011 	tsteq	r0, r1, lsl r0
    1b00:	128305ab 	addne	r0, r3, #717225984	; 0x2ac00000
    1b04:	01000000 	mrseq	r0, (UNDEF: 0)
    1b08:	90b80000 	adcsls	r0, r8, r0
    1b0c:	00540000 	subseq	r0, r4, r0
    1b10:	9c010000 	stcls	0, cr0, [r1], {-0}
    1b14:	000002f8 	strdeq	r0, [r0], -r8
    1b18:	0100730b 	tsteq	r0, fp, lsl #6
    1b1c:	00fa18ab 	rscseq	r1, sl, fp, lsr #17
    1b20:	91020000 	mrsls	r0, (UNDEF: 2)
    1b24:	00690c6c 	rsbeq	r0, r9, ip, ror #24
    1b28:	0009ac01 	andeq	sl, r9, r1, lsl #24
    1b2c:	02000001 	andeq	r0, r0, #1
    1b30:	10007491 	mulne	r0, r1, r4
    1b34:	00001249 	andeq	r1, r0, r9, asr #4
    1b38:	90059d01 	andls	r9, r5, r1, lsl #26
    1b3c:	00000012 	andeq	r0, r0, r2, lsl r0
    1b40:	0c000001 	stceq	0, cr0, [r0], {1}
    1b44:	ac000090 	stcge	0, cr0, [r0], {144}	; 0x90
    1b48:	01000000 	mrseq	r0, (UNDEF: 0)
    1b4c:	00035e9c 	muleq	r3, ip, lr
    1b50:	31730b00 	cmncc	r3, r0, lsl #22
    1b54:	199d0100 	ldmibne	sp, {r8}
    1b58:	000000fa 	strdeq	r0, [r0], -sl
    1b5c:	0b6c9102 	bleq	1b25f6c <__bss_end+0x1b1c274>
    1b60:	01003273 	tsteq	r0, r3, ror r2
    1b64:	00fa299d 	smlalseq	r2, sl, sp, r9
    1b68:	91020000 	mrsls	r0, (UNDEF: 2)
    1b6c:	756e0b68 	strbvc	r0, [lr, #-2920]!	; 0xfffff498
    1b70:	9d01006d 	stcls	0, cr0, [r1, #-436]	; 0xfffffe4c
    1b74:	00010031 	andeq	r0, r1, r1, lsr r0
    1b78:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1b7c:	0031750c 	eorseq	r7, r1, ip, lsl #10
    1b80:	5e139e01 	cdppl	14, 1, cr9, cr3, cr1, {0}
    1b84:	02000003 	andeq	r0, r0, #3
    1b88:	750c7791 	strvc	r7, [ip, #-1937]	; 0xfffff86f
    1b8c:	9e010032 	mcrls	0, 0, r0, cr1, cr2, {1}
    1b90:	00035e17 	andeq	r5, r3, r7, lsl lr
    1b94:	76910200 	ldrvc	r0, [r1], r0, lsl #4
    1b98:	08010800 	stmdaeq	r1, {fp}
    1b9c:	0000074a 	andeq	r0, r0, sl, asr #14
    1ba0:	0011be10 	andseq	fp, r1, r0, lsl lr
    1ba4:	07920100 	ldreq	r0, [r2, r0, lsl #2]
    1ba8:	000011d0 	ldrdeq	r1, [r0], -r0
    1bac:	00000210 	andeq	r0, r0, r0, lsl r2
    1bb0:	00008f4c 	andeq	r8, r0, ip, asr #30
    1bb4:	000000c0 	andeq	r0, r0, r0, asr #1
    1bb8:	03be9c01 			; <UNDEFINED> instruction: 0x03be9c01
    1bbc:	cb150000 	blgt	541bc4 <__bss_end+0x537ecc>
    1bc0:	01000011 	tsteq	r0, r1, lsl r0
    1bc4:	02101592 	andseq	r1, r0, #612368384	; 0x24800000
    1bc8:	91020000 	mrsls	r0, (UNDEF: 2)
    1bcc:	72730b6c 	rsbsvc	r0, r3, #108, 22	; 0x1b000
    1bd0:	92010063 	andls	r0, r1, #99	; 0x63
    1bd4:	0000fa27 	andeq	pc, r0, r7, lsr #20
    1bd8:	68910200 	ldmvs	r1, {r9}
    1bdc:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    1be0:	30920100 	addscc	r0, r2, r0, lsl #2
    1be4:	00000100 	andeq	r0, r0, r0, lsl #2
    1be8:	0c649102 	stfeqp	f1, [r4], #-8
    1bec:	93010069 	movwls	r0, #4201	; 0x1069
    1bf0:	00010009 	andeq	r0, r1, r9
    1bf4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1bf8:	12161000 	andsne	r1, r6, #0
    1bfc:	82010000 	andhi	r0, r1, #0
    1c00:	0012a205 	andseq	sl, r2, r5, lsl #4
    1c04:	00010000 	andeq	r0, r1, r0
    1c08:	008eb000 	addeq	fp, lr, r0
    1c0c:	00009c00 	andeq	r9, r0, r0, lsl #24
    1c10:	fb9c0100 	blx	fe70201a <__bss_end+0xfe6f8322>
    1c14:	15000003 	strne	r0, [r0, #-3]
    1c18:	00001191 	muleq	r0, r1, r1
    1c1c:	fa168201 	blx	5a2428 <__bss_end+0x598730>
    1c20:	02000000 	andeq	r0, r0, #0
    1c24:	510d6c91 			; <UNDEFINED> instruction: 0x510d6c91
    1c28:	01000012 	tsteq	r0, r2, lsl r0
    1c2c:	01000983 	smlabbeq	r0, r3, r9, r0
    1c30:	91020000 	mrsls	r0, (UNDEF: 2)
    1c34:	c6160074 			; <UNDEFINED> instruction: 0xc6160074
    1c38:	01000011 	tsteq	r0, r1, lsl r0
    1c3c:	1152066a 	cmpne	r2, sl, ror #12
    1c40:	8d3c0000 	ldchi	0, cr0, [ip, #-0]
    1c44:	01740000 	cmneq	r4, r0
    1c48:	9c010000 	stcls	0, cr0, [r1], {-0}
    1c4c:	0000047e 	andeq	r0, r0, lr, ror r4
    1c50:	00119115 	andseq	r9, r1, r5, lsl r1
    1c54:	186a0100 	stmdane	sl!, {r8}^
    1c58:	00000066 	andeq	r0, r0, r6, rrx
    1c5c:	15649102 	strbne	r9, [r4, #-258]!	; 0xfffffefe
    1c60:	00001251 	andeq	r1, r0, r1, asr r2
    1c64:	10256a01 	eorne	r6, r5, r1, lsl #20
    1c68:	02000002 	andeq	r0, r0, #2
    1c6c:	97156091 			; <UNDEFINED> instruction: 0x97156091
    1c70:	01000011 	tsteq	r0, r1, lsl r0
    1c74:	00663a6a 	rsbeq	r3, r6, sl, ror #20
    1c78:	91020000 	mrsls	r0, (UNDEF: 2)
    1c7c:	00690c5c 	rsbeq	r0, r9, ip, asr ip
    1c80:	00096b01 	andeq	r6, r9, r1, lsl #22
    1c84:	02000001 	andeq	r0, r0, #1
    1c88:	08127491 	ldmdaeq	r2, {r0, r4, r7, sl, ip, sp, lr}
    1c8c:	9800008e 	stmdals	r0, {r1, r2, r3, r7}
    1c90:	0c000000 	stceq	0, cr0, [r0], {-0}
    1c94:	7b01006a 	blvc	41e44 <__bss_end+0x3814c>
    1c98:	0001000e 	andeq	r0, r1, lr
    1c9c:	70910200 	addsvc	r0, r1, r0, lsl #4
    1ca0:	008e3012 	addeq	r3, lr, r2, lsl r0
    1ca4:	00006000 	andeq	r6, r0, r0
    1ca8:	00630c00 	rsbeq	r0, r3, r0, lsl #24
    1cac:	6d0e7c01 	stcvs	12, cr7, [lr, #-4]
    1cb0:	02000000 	andeq	r0, r0, #0
    1cb4:	00006f91 	muleq	r0, r1, pc	; <UNPREDICTABLE>
    1cb8:	11fe1000 	mvnsne	r1, r0
    1cbc:	42010000 	andmi	r0, r1, #0
    1cc0:	00117507 	andseq	r7, r1, r7, lsl #10
    1cc4:	0004f700 	andeq	pc, r4, r0, lsl #14
    1cc8:	008a8800 	addeq	r8, sl, r0, lsl #16
    1ccc:	0002b400 	andeq	fp, r2, r0, lsl #8
    1cd0:	f79c0100 			; <UNDEFINED> instruction: 0xf79c0100
    1cd4:	0b000004 	bleq	1cec <shift+0x1cec>
    1cd8:	42010073 	andmi	r0, r1, #115	; 0x73
    1cdc:	0000fa18 	andeq	pc, r0, r8, lsl sl	; <UNPREDICTABLE>
    1ce0:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1ce4:	0100610c 	tsteq	r0, ip, lsl #2
    1ce8:	04f70b43 	ldrbteq	r0, [r7], #2883	; 0xb43
    1cec:	91020000 	mrsls	r0, (UNDEF: 2)
    1cf0:	00650c74 	rsbeq	r0, r5, r4, ror ip
    1cf4:	00094401 	andeq	r4, r9, r1, lsl #8
    1cf8:	02000001 	andeq	r0, r0, #1
    1cfc:	630c7091 	movwvs	r7, #49297	; 0xc091
    1d00:	09450100 	stmdbeq	r5, {r8}^
    1d04:	00000100 	andeq	r0, r0, r0, lsl #2
    1d08:	126c9102 	rsbne	r9, ip, #-2147483648	; 0x80000000
    1d0c:	00008bd0 	ldrdeq	r8, [r0], -r0
    1d10:	000000e0 	andeq	r0, r0, r0, ror #1
    1d14:	00127e0d 	andseq	r7, r2, sp, lsl #28
    1d18:	0d500100 	ldfeqe	f0, [r0, #-0]
    1d1c:	00000100 	andeq	r0, r0, r0, lsl #2
    1d20:	0c689102 	stfeqp	f1, [r8], #-8
    1d24:	51010069 	tstpl	r1, r9, rrx
    1d28:	0001000d 	andeq	r0, r1, sp
    1d2c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1d30:	04080000 	streq	r0, [r8], #-0
    1d34:	00165004 	andseq	r5, r6, r4
    1d38:	114d1600 	cmpne	sp, r0, lsl #12
    1d3c:	0f010000 	svceq	0x00010000
    1d40:	0012b406 	andseq	fp, r2, r6, lsl #8
    1d44:	00876800 	addeq	r6, r7, r0, lsl #16
    1d48:	00032000 	andeq	r2, r3, r0
    1d4c:	9f9c0100 	svcls	0x009c0100
    1d50:	0b000005 	bleq	1d6c <shift+0x1d6c>
    1d54:	0f010066 	svceq	0x00010066
    1d58:	0004f711 	andeq	pc, r4, r1, lsl r7	; <UNPREDICTABLE>
    1d5c:	a4910300 	ldrge	r0, [r1], #768	; 0x300
    1d60:	00720b7f 	rsbseq	r0, r2, pc, ror fp
    1d64:	101a0f01 	andsne	r0, sl, r1, lsl #30
    1d68:	03000002 	movweq	r0, #2
    1d6c:	0d7fa091 	ldcleq	0, cr10, [pc, #-580]!	; 1b30 <shift+0x1b30>
    1d70:	000012c6 	andeq	r1, r0, r6, asr #5
    1d74:	9f131001 	svcls	0x00131001
    1d78:	03000005 	movweq	r0, #5
    1d7c:	0d7fb091 	ldcleq	0, cr11, [pc, #-580]!	; 1b40 <shift+0x1b40>
    1d80:	00001241 	andeq	r1, r0, r1, asr #4
    1d84:	9f1b1001 	svcls	0x001b1001
    1d88:	02000005 	andeq	r0, r0, #5
    1d8c:	690c5891 	stmdbvs	ip, {r0, r4, r7, fp, ip, lr}
    1d90:	24100100 	ldrcs	r0, [r0], #-256	; 0xffffff00
    1d94:	0000059f 	muleq	r0, pc, r5	; <UNPREDICTABLE>
    1d98:	0d509102 	ldfeqp	f1, [r0, #-8]
    1d9c:	00000ecb 	andeq	r0, r0, fp, asr #29
    1da0:	9f271001 	svcls	0x00271001
    1da4:	02000005 	andeq	r0, r0, #5
    1da8:	ec0d4891 	stc	8, cr4, [sp], {145}	; 0x91
    1dac:	01000011 	tsteq	r0, r1, lsl r0
    1db0:	059f2f10 	ldreq	r2, [pc, #3856]	; 2cc8 <shift+0x2cc8>
    1db4:	91030000 	mrsls	r0, (UNDEF: 3)
    1db8:	7e0d7fa8 	cdpvc	15, 0, cr7, cr13, cr8, {5}
    1dbc:	01000012 	tsteq	r0, r2, lsl r0
    1dc0:	059f3910 	ldreq	r3, [pc, #2320]	; 26d8 <shift+0x26d8>
    1dc4:	91020000 	mrsls	r0, (UNDEF: 2)
    1dc8:	122c0d40 	eorne	r0, ip, #64, 26	; 0x1000
    1dcc:	11010000 	mrsne	r0, (UNDEF: 1)
    1dd0:	0004f70b 	andeq	pc, r4, fp, lsl #14
    1dd4:	bc910300 	ldclt	3, cr0, [r1], {0}
    1dd8:	0808007f 	stmdaeq	r8, {r0, r1, r2, r3, r4, r5, r6}
    1ddc:	00037f05 	andeq	r7, r3, r5, lsl #30
    1de0:	12791700 	rsbsne	r1, r9, #0, 14
    1de4:	07010000 	streq	r0, [r1, -r0]
    1de8:	00121b05 	andseq	r1, r2, r5, lsl #22
    1dec:	00010000 	andeq	r0, r1, r0
    1df0:	00870000 	addeq	r0, r7, r0
    1df4:	00006800 	andeq	r6, r0, r0, lsl #16
    1df8:	159c0100 	ldrne	r0, [ip, #256]	; 0x100
    1dfc:	00000ecb 	andeq	r0, r0, fp, asr #29
    1e00:	000e0701 	andeq	r0, lr, r1, lsl #14
    1e04:	02000001 	andeq	r0, r0, #1
    1e08:	0e156c91 	mrceq	12, 0, r6, cr5, cr1, {4}
    1e0c:	0100000f 	tsteq	r0, pc
    1e10:	01001a07 	tsteq	r0, r7, lsl #20
    1e14:	91020000 	mrsls	r0, (UNDEF: 2)
    1e18:	00b90d68 	adcseq	r0, r9, r8, ror #26
    1e1c:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1e20:	00010009 	andeq	r0, r1, r9
    1e24:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1e28:	00220000 	eoreq	r0, r2, r0
    1e2c:	00020000 	andeq	r0, r2, r0
    1e30:	00000805 	andeq	r0, r0, r5, lsl #16
    1e34:	0b900104 	bleq	fe40224c <__bss_end+0xfe3f8554>
    1e38:	959c0000 	ldrls	r0, [ip]
    1e3c:	97a80000 	strls	r0, [r8, r0]!
    1e40:	12cd0000 	sbcne	r0, sp, #0
    1e44:	12fd0000 	rscsne	r0, sp, #0
    1e48:	13620000 	cmnne	r2, #0
    1e4c:	80010000 	andhi	r0, r1, r0
    1e50:	00000022 	andeq	r0, r0, r2, lsr #32
    1e54:	08190002 	ldmdaeq	r9, {r1}
    1e58:	01040000 	mrseq	r0, (UNDEF: 4)
    1e5c:	00000c0d 	andeq	r0, r0, sp, lsl #24
    1e60:	000097a8 	andeq	r9, r0, r8, lsr #15
    1e64:	000097ac 	andeq	r9, r0, ip, lsr #15
    1e68:	000012cd 	andeq	r1, r0, sp, asr #5
    1e6c:	000012fd 	strdeq	r1, [r0], -sp
    1e70:	00001362 	andeq	r1, r0, r2, ror #6
    1e74:	00228001 	eoreq	r8, r2, r1
    1e78:	00020000 	andeq	r0, r2, r0
    1e7c:	0000082d 	andeq	r0, r0, sp, lsr #16
    1e80:	0c6d0104 	stfeqe	f0, [sp], #-16
    1e84:	97ac0000 	strls	r0, [ip, r0]!
    1e88:	99fc0000 	ldmibls	ip!, {}^	; <UNPREDICTABLE>
    1e8c:	136e0000 	cmnne	lr, #0
    1e90:	12fd0000 	rscsne	r0, sp, #0
    1e94:	13620000 	cmnne	r2, #0
    1e98:	80010000 	andhi	r0, r1, r0
    1e9c:	00000022 	andeq	r0, r0, r2, lsr #32
    1ea0:	08410002 	stmdaeq	r1, {r1}^
    1ea4:	01040000 	mrseq	r0, (UNDEF: 4)
    1ea8:	00000d6c 	andeq	r0, r0, ip, ror #26
    1eac:	000099fc 	strdeq	r9, [r0], -ip
    1eb0:	00009ad0 	ldrdeq	r9, [r0], -r0
    1eb4:	0000139f 	muleq	r0, pc, r3	; <UNPREDICTABLE>
    1eb8:	000012fd 	strdeq	r1, [r0], -sp
    1ebc:	00001362 	andeq	r1, r0, r2, ror #6
    1ec0:	0a098001 	beq	261ecc <__bss_end+0x2581d4>
    1ec4:	00040000 	andeq	r0, r4, r0
    1ec8:	00000855 	andeq	r0, r0, r5, asr r8
    1ecc:	245f0104 	ldrbcs	r0, [pc], #-260	; 1ed4 <shift+0x1ed4>
    1ed0:	a10c0000 	mrsge	r0, (UNDEF: 12)
    1ed4:	fd000016 	stc2	0, cr0, [r0, #-88]	; 0xffffffa8
    1ed8:	ea000012 	b	1f28 <shift+0x1f28>
    1edc:	0200000d 	andeq	r0, r0, #13
    1ee0:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    1ee4:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    1ee8:	00180507 	andseq	r0, r8, r7, lsl #10
    1eec:	05080300 	streq	r0, [r8, #-768]	; 0xfffffd00
    1ef0:	0000037f 	andeq	r0, r0, pc, ror r3
    1ef4:	a6040803 	strge	r0, [r4], -r3, lsl #16
    1ef8:	0400001f 	streq	r0, [r0], #-31	; 0xffffffe1
    1efc:	0000170e 	andeq	r1, r0, lr, lsl #14
    1f00:	24162a01 	ldrcs	r2, [r6], #-2561	; 0xfffff5ff
    1f04:	04000000 	streq	r0, [r0], #-0
    1f08:	00001b71 	andeq	r1, r0, r1, ror fp
    1f0c:	51152f01 	tstpl	r5, r1, lsl #30
    1f10:	05000000 	streq	r0, [r0, #-0]
    1f14:	00005704 	andeq	r5, r0, r4, lsl #14
    1f18:	00390600 	eorseq	r0, r9, r0, lsl #12
    1f1c:	00660000 	rsbeq	r0, r6, r0
    1f20:	66070000 	strvs	r0, [r7], -r0
    1f24:	00000000 	andeq	r0, r0, r0
    1f28:	006c0405 	rsbeq	r0, ip, r5, lsl #8
    1f2c:	04080000 	streq	r0, [r8], #-0
    1f30:	00002410 	andeq	r2, r0, r0, lsl r4
    1f34:	790f3601 	stmdbvc	pc, {r0, r9, sl, ip, sp}	; <UNPREDICTABLE>
    1f38:	05000000 	streq	r0, [r0, #-0]
    1f3c:	00007f04 	andeq	r7, r0, r4, lsl #30
    1f40:	001d0600 	andseq	r0, sp, r0, lsl #12
    1f44:	00930000 	addseq	r0, r3, r0
    1f48:	66070000 	strvs	r0, [r7], -r0
    1f4c:	07000000 	streq	r0, [r0, -r0]
    1f50:	00000066 	andeq	r0, r0, r6, rrx
    1f54:	08010300 	stmdaeq	r1, {r8, r9}
    1f58:	0000074a 	andeq	r0, r0, sl, asr #14
    1f5c:	001dd409 	andseq	sp, sp, r9, lsl #8
    1f60:	12bb0100 	adcsne	r0, fp, #0, 2
    1f64:	00000045 	andeq	r0, r0, r5, asr #32
    1f68:	00243e09 	eoreq	r3, r4, r9, lsl #28
    1f6c:	10be0100 	adcsne	r0, lr, r0, lsl #2
    1f70:	0000006d 	andeq	r0, r0, sp, rrx
    1f74:	4c060103 	stfmis	f0, [r6], {3}
    1f78:	0a000007 	beq	1f9c <shift+0x1f9c>
    1f7c:	00001a78 	andeq	r1, r0, r8, ror sl
    1f80:	00930107 	addseq	r0, r3, r7, lsl #2
    1f84:	17020000 	strne	r0, [r2, -r0]
    1f88:	0001e606 	andeq	lr, r1, r6, lsl #12
    1f8c:	15750b00 	ldrbne	r0, [r5, #-2816]!	; 0xfffff500
    1f90:	0b000000 	bleq	1f98 <shift+0x1f98>
    1f94:	00001970 	andeq	r1, r0, r0, ror r9
    1f98:	1ecc0b01 	vdivne.f64	d16, d12, d1
    1f9c:	0b020000 	bleq	81fa4 <__bss_end+0x782ac>
    1fa0:	00002354 	andeq	r2, r0, r4, asr r3
    1fa4:	1e580b03 	vnmlsne.f64	d16, d8, d3
    1fa8:	0b040000 	bleq	101fb0 <__bss_end+0xf82b8>
    1fac:	0000221b 	andeq	r2, r0, fp, lsl r2
    1fb0:	21410b05 	cmpcs	r1, r5, lsl #22
    1fb4:	0b060000 	bleq	181fbc <__bss_end+0x1782c4>
    1fb8:	00001596 	muleq	r0, r6, r5
    1fbc:	22300b07 	eorscs	r0, r0, #7168	; 0x1c00
    1fc0:	0b080000 	bleq	201fc8 <__bss_end+0x1f82d0>
    1fc4:	0000223e 	andeq	r2, r0, lr, lsr r2
    1fc8:	232f0b09 			; <UNDEFINED> instruction: 0x232f0b09
    1fcc:	0b0a0000 	bleq	281fd4 <__bss_end+0x2782dc>
    1fd0:	00001d9a 	muleq	r0, sl, sp
    1fd4:	174f0b0b 	strbne	r0, [pc, -fp, lsl #22]
    1fd8:	0b0c0000 	bleq	301fe0 <__bss_end+0x2f82e8>
    1fdc:	00001b01 	andeq	r1, r0, r1, lsl #22
    1fe0:	22870b0d 	addcs	r0, r7, #13312	; 0x3400
    1fe4:	0b0e0000 	bleq	381fec <__bss_end+0x3782f4>
    1fe8:	00001abc 			; <UNDEFINED> instruction: 0x00001abc
    1fec:	1ad20b0f 	bne	ff484c30 <__bss_end+0xff47af38>
    1ff0:	0b100000 	bleq	401ff8 <__bss_end+0x3f8300>
    1ff4:	000019a7 	andeq	r1, r0, r7, lsr #19
    1ff8:	1e3c0b11 	vmovne.32	r0, d12[1]
    1ffc:	0b120000 	bleq	482004 <__bss_end+0x47830c>
    2000:	00001a34 	andeq	r1, r0, r4, lsr sl
    2004:	26ec0b13 	usatcs	r0, #12, r3, lsl #22
    2008:	0b140000 	bleq	502010 <__bss_end+0x4f8318>
    200c:	00001f04 	andeq	r1, r0, r4, lsl #30
    2010:	1c610b15 			; <UNDEFINED> instruction: 0x1c610b15
    2014:	0b160000 	bleq	58201c <__bss_end+0x578324>
    2018:	000015f3 	strdeq	r1, [r0], -r3
    201c:	23770b17 	cmncs	r7, #23552	; 0x5c00
    2020:	0b180000 	bleq	602028 <__bss_end+0x5f8330>
    2024:	00002581 	andeq	r2, r0, r1, lsl #11
    2028:	23850b19 	orrcs	r0, r5, #25600	; 0x6400
    202c:	0b1a0000 	bleq	682034 <__bss_end+0x67833c>
    2030:	00001a84 	andeq	r1, r0, r4, lsl #21
    2034:	23930b1b 	orrscs	r0, r3, #27648	; 0x6c00
    2038:	0b1c0000 	bleq	702040 <__bss_end+0x6f8348>
    203c:	0000144f 	andeq	r1, r0, pc, asr #8
    2040:	23a10b1d 			; <UNDEFINED> instruction: 0x23a10b1d
    2044:	0b1e0000 	bleq	78204c <__bss_end+0x778354>
    2048:	000023af 	andeq	r2, r0, pc, lsr #7
    204c:	13e80b1f 	mvnne	r0, #31744	; 0x7c00
    2050:	0b200000 	bleq	802058 <__bss_end+0x7f8360>
    2054:	00002027 	andeq	r2, r0, r7, lsr #32
    2058:	1e0e0b21 	vmlane.f64	d0, d14, d17
    205c:	0b220000 	bleq	882064 <__bss_end+0x87836c>
    2060:	0000236a 	andeq	r2, r0, sl, ror #6
    2064:	1cde0b23 	fldmiaxne	lr, {d16-d32}	;@ Deprecated
    2068:	0b240000 	bleq	902070 <__bss_end+0x8f8378>
    206c:	00002132 	andeq	r2, r0, r2, lsr r1
    2070:	1bd40b25 	blne	ff504d0c <__bss_end+0xff4fb014>
    2074:	0b260000 	bleq	98207c <__bss_end+0x978384>
    2078:	000018b0 			; <UNDEFINED> instruction: 0x000018b0
    207c:	1bf20b27 	blne	ffc84d20 <__bss_end+0xffc7b028>
    2080:	0b280000 	bleq	a02088 <__bss_end+0x9f8390>
    2084:	0000194c 	andeq	r1, r0, ip, asr #18
    2088:	1c020b29 			; <UNDEFINED> instruction: 0x1c020b29
    208c:	0b2a0000 	bleq	a82094 <__bss_end+0xa7839c>
    2090:	00001d80 	andeq	r1, r0, r0, lsl #27
    2094:	1b7b0b2b 	blne	1ec4d48 <__bss_end+0x1ebb050>
    2098:	0b2c0000 	bleq	b020a0 <__bss_end+0xaf83a8>
    209c:	00002046 	andeq	r2, r0, r6, asr #32
    20a0:	18f10b2d 	ldmne	r1!, {r0, r2, r3, r5, r8, r9, fp}^
    20a4:	002e0000 	eoreq	r0, lr, r0
    20a8:	001b0e0a 	andseq	r0, fp, sl, lsl #28
    20ac:	93010700 	movwls	r0, #5888	; 0x1700
    20b0:	03000000 	movweq	r0, #0
    20b4:	049f0617 	ldreq	r0, [pc], #1559	; 20bc <shift+0x20bc>
    20b8:	630b0000 	movwvs	r0, #45056	; 0xb000
    20bc:	00000017 	andeq	r0, r0, r7, lsl r0
    20c0:	0026150b 	eoreq	r1, r6, fp, lsl #10
    20c4:	730b0100 	movwvc	r0, #45312	; 0xb100
    20c8:	02000017 	andeq	r0, r0, #23
    20cc:	0017960b 	andseq	r9, r7, fp, lsl #12
    20d0:	4e0b0300 	cdpmi	3, 0, cr0, cr11, cr0, {0}
    20d4:	04000024 	streq	r0, [r0], #-36	; 0xffffffdc
    20d8:	0020ac0b 	eoreq	sl, r0, fp, lsl #24
    20dc:	200b0500 	andcs	r0, fp, r0, lsl #10
    20e0:	06000018 			; <UNDEFINED> instruction: 0x06000018
    20e4:	0019950b 	andseq	r9, r9, fp, lsl #10
    20e8:	a60b0700 	strge	r0, [fp], -r0, lsl #14
    20ec:	08000017 	stmdaeq	r0, {r0, r1, r2, r4}
    20f0:	0026db0b 	eoreq	sp, r6, fp, lsl #22
    20f4:	c60b0900 	strgt	r0, [fp], -r0, lsl #18
    20f8:	0a000014 	beq	2150 <shift+0x2150>
    20fc:	0026040b 	eoreq	r0, r6, fp, lsl #8
    2100:	ed0b0b00 	vstr	d0, [fp, #-0]
    2104:	0c00001c 	stceq	0, cr0, [r0], {28}
    2108:	0025980b 	eoreq	r9, r5, fp, lsl #16
    210c:	340b0d00 	strcc	r0, [fp], #-3328	; 0xfffff300
    2110:	0e000020 	cdpeq	0, 0, cr0, cr0, cr0, {1}
    2114:	0022cd0b 	eoreq	ip, r2, fp, lsl #26
    2118:	810b0f00 	tsthi	fp, r0, lsl #30
    211c:	10000018 	andne	r0, r0, r8, lsl r0
    2120:	0017830b 	andseq	r8, r7, fp, lsl #6
    2124:	ec0b1100 	stfs	f1, [fp], {-0}
    2128:	1200001f 	andne	r0, r0, #31
    212c:	00186c0b 	andseq	r6, r8, fp, lsl #24
    2130:	f30b1300 	vcgt.u8	d1, d11, d0
    2134:	14000025 	strne	r0, [r0], #-37	; 0xffffffdb
    2138:	0014f00b 	andseq	pc, r4, fp
    213c:	3c0b1500 	cfstr32cc	mvfx1, [fp], {-0}
    2140:	1600001c 			; <UNDEFINED> instruction: 0x1600001c
    2144:	0017b60b 	andseq	fp, r7, fp, lsl #12
    2148:	8d0b1700 	stchi	7, cr1, [fp, #-0]
    214c:	18000014 	stmdane	r0, {r2, r4}
    2150:	0026810b 	eoreq	r8, r6, fp, lsl #2
    2154:	3c0b1900 			; <UNDEFINED> instruction: 0x3c0b1900
    2158:	1a000023 	bne	21ec <shift+0x21ec>
    215c:	0021500b 	eoreq	r5, r1, fp
    2160:	b40b1b00 	strlt	r1, [fp], #-2816	; 0xfffff500
    2164:	1c000022 	stcne	0, cr0, [r0], {34}	; 0x22
    2168:	0024180b 	eoreq	r1, r4, fp, lsl #16
    216c:	d60b1d00 	strle	r1, [fp], -r0, lsl #26
    2170:	1e000017 	mcrne	0, 0, r0, cr0, cr7, {0}
    2174:	0015610b 	andseq	r6, r5, fp, lsl #2
    2178:	690b1f00 	stmdbvs	fp, {r8, r9, sl, fp, ip}
    217c:	20000021 	andcs	r0, r0, r1, lsr #32
    2180:	0018cd0b 	andseq	ip, r8, fp, lsl #26
    2184:	be0b2100 	adflte	f2, f3, f0
    2188:	22000020 	andcs	r0, r0, #32
    218c:	001cbe0b 	andseq	fp, ip, fp, lsl #28
    2190:	c60b2300 	strgt	r2, [fp], -r0, lsl #6
    2194:	24000017 	strcs	r0, [r0], #-23	; 0xffffffe9
    2198:	00226c0b 	eoreq	r6, r2, fp, lsl #24
    219c:	d90b2500 	stmdble	fp, {r8, sl, sp}
    21a0:	26000016 			; <UNDEFINED> instruction: 0x26000016
    21a4:	0023fd0b 	eoreq	pc, r3, fp, lsl #26
    21a8:	c80b2700 	stmdagt	fp, {r8, r9, sl, sp}
    21ac:	28000026 	stmdacs	r0, {r1, r2, r5}
    21b0:	001fbf0b 	andseq	fp, pc, fp, lsl #30
    21b4:	660b2900 	strvs	r2, [fp], -r0, lsl #18
    21b8:	2a00001a 	bcs	2228 <shift+0x2228>
    21bc:	0021930b 	eoreq	r9, r1, fp, lsl #6
    21c0:	1c0b2b00 			; <UNDEFINED> instruction: 0x1c0b2b00
    21c4:	2c00001d 	stccs	0, cr0, [r0], {29}
    21c8:	0015b40b 	andseq	fp, r5, fp, lsl #8
    21cc:	380b2d00 	stmdacc	fp, {r8, sl, fp, sp}
    21d0:	2e000015 	mcrcs	0, 0, r0, cr0, cr5, {0}
    21d4:	0025560b 	eoreq	r5, r5, fp, lsl #12
    21d8:	aa0b2f00 	bge	2cdde0 <__bss_end+0x2c40e8>
    21dc:	3000001c 	andcc	r0, r0, ip, lsl r0
    21e0:	0018460b 	andseq	r4, r8, fp, lsl #12
    21e4:	890b3100 	stmdbhi	fp, {r8, ip, sp}
    21e8:	3200001c 	andcc	r0, r0, #28
    21ec:	001f380b 	andseq	r3, pc, fp, lsl #16
    21f0:	260b3300 	strcs	r3, [fp], -r0, lsl #6
    21f4:	34000015 	strcc	r0, [r0], #-21	; 0xffffffeb
    21f8:	0026b60b 	eoreq	fp, r6, fp, lsl #12
    21fc:	6d0b3500 	cfstr32vs	mvfx3, [fp, #-0]
    2200:	3600001d 			; <UNDEFINED> instruction: 0x3600001d
    2204:	0019ff0b 	andseq	pc, r9, fp, lsl #30
    2208:	aa0b3700 	bge	2cfe10 <__bss_end+0x2c6118>
    220c:	3800001d 	stmdacc	r0, {r0, r2, r3, r4}
    2210:	0025be0b 	eoreq	fp, r5, fp, lsl #28
    2214:	6b0b3900 	blvs	2d061c <__bss_end+0x2c6924>
    2218:	3a000016 	bcc	2278 <shift+0x2278>
    221c:	001a120b 	andseq	r1, sl, fp, lsl #4
    2220:	de0b3b00 	vmlale.f64	d3, d11, d0
    2224:	3c000019 	stccc	0, cr0, [r0], {25}
    2228:	0013f70b 	andseq	pc, r3, fp, lsl #14
    222c:	ff0b3d00 			; <UNDEFINED> instruction: 0xff0b3d00
    2230:	3e00001c 	mcrcc	0, 0, r0, cr0, cr12, {0}
    2234:	001ade0b 	andseq	sp, sl, fp, lsl #28
    2238:	7f0b3f00 	svcvc	0x000b3f00
    223c:	40000015 	andmi	r0, r0, r5, lsl r0
    2240:	00256a0b 	eoreq	r6, r5, fp, lsl #20
    2244:	4f0b4100 	svcmi	0x000b4100
    2248:	4200001c 	andmi	r0, r0, #28
    224c:	0019c80b 	andseq	ip, r9, fp, lsl #16
    2250:	380b4300 	stmdacc	fp, {r8, r9, lr}
    2254:	44000014 	strmi	r0, [r0], #-20	; 0xffffffec
    2258:	001bac0b 	andseq	sl, fp, fp, lsl #24
    225c:	980b4500 	stmdals	fp, {r8, sl, lr}
    2260:	4600001b 			; <UNDEFINED> instruction: 0x4600001b
    2264:	0021130b 	eoreq	r1, r1, fp, lsl #6
    2268:	db0b4700 	blle	2d3e70 <__bss_end+0x2ca178>
    226c:	48000021 	stmdami	r0, {r0, r5}
    2270:	0025350b 	eoreq	r3, r5, fp, lsl #10
    2274:	fe0b4900 	vseleq.f16	s8, s22, s0
    2278:	4a000018 	bmi	22e0 <shift+0x22e0>
    227c:	001eee0b 	andseq	lr, lr, fp, lsl #28
    2280:	a80b4b00 	stmdage	fp, {r8, r9, fp, lr}
    2284:	4c000021 	stcmi	0, cr0, [r0], {33}	; 0x21
    2288:	0020550b 	eoreq	r5, r0, fp, lsl #10
    228c:	690b4d00 	stmdbvs	fp, {r8, sl, fp, lr}
    2290:	4e000020 	cdpmi	0, 0, cr0, cr0, cr0, {1}
    2294:	00207d0b 	eoreq	r7, r0, fp, lsl #26
    2298:	f90b4f00 			; <UNDEFINED> instruction: 0xf90b4f00
    229c:	50000016 	andpl	r0, r0, r6, lsl r0
    22a0:	0016560b 	andseq	r5, r6, fp, lsl #12
    22a4:	7e0b5100 	adfvce	f5, f3, f0
    22a8:	52000016 	andpl	r0, r0, #22
    22ac:	0022df0b 	eoreq	sp, r2, fp, lsl #30
    22b0:	c40b5300 	strgt	r5, [fp], #-768	; 0xfffffd00
    22b4:	54000016 	strpl	r0, [r0], #-22	; 0xffffffea
    22b8:	0022f30b 	eoreq	pc, r2, fp, lsl #6
    22bc:	070b5500 	streq	r5, [fp, -r0, lsl #10]
    22c0:	56000023 	strpl	r0, [r0], -r3, lsr #32
    22c4:	00231b0b 	eoreq	r1, r3, fp, lsl #22
    22c8:	580b5700 	stmdapl	fp, {r8, r9, sl, ip, lr}
    22cc:	58000018 	stmdapl	r0, {r3, r4}
    22d0:	0018320b 	andseq	r3, r8, fp, lsl #4
    22d4:	c00b5900 	andgt	r5, fp, r0, lsl #18
    22d8:	5a00001b 	bpl	234c <shift+0x234c>
    22dc:	001dbd0b 	andseq	fp, sp, fp, lsl #26
    22e0:	460b5b00 	strmi	r5, [fp], -r0, lsl #22
    22e4:	5c00001b 	stcpl	0, cr0, [r0], {27}
    22e8:	0013cb0b 	andseq	ip, r3, fp, lsl #22
    22ec:	800b5d00 	andhi	r5, fp, r0, lsl #26
    22f0:	5e000019 	mcrpl	0, 0, r0, cr0, cr9, {0}
    22f4:	001de60b 	andseq	lr, sp, fp, lsl #12
    22f8:	120b5f00 	andne	r5, fp, #0, 30
    22fc:	6000001c 	andvs	r0, r0, ip, lsl r0
    2300:	0020d10b 	eoreq	sp, r0, fp, lsl #2
    2304:	330b6100 	movwcc	r6, #45312	; 0xb100
    2308:	62000026 	andvs	r0, r0, #38	; 0x26
    230c:	001ed90b 	andseq	sp, lr, fp, lsl #18
    2310:	230b6300 	movwcs	r6, #45824	; 0xb300
    2314:	64000019 	strvs	r0, [r0], #-25	; 0xffffffe7
    2318:	00149f0b 	andseq	r9, r4, fp, lsl #30
    231c:	5d0b6500 	cfstr32pl	mvfx6, [fp, #-0]
    2320:	66000014 			; <UNDEFINED> instruction: 0x66000014
    2324:	001e1e0b 	andseq	r1, lr, fp, lsl #28
    2328:	590b6700 	stmdbpl	fp, {r8, r9, sl, sp, lr}
    232c:	6800001f 	stmdavs	r0, {r0, r1, r2, r3, r4}
    2330:	0020f50b 	eoreq	pc, r0, fp, lsl #10
    2334:	270b6900 	strcs	r6, [fp, -r0, lsl #18]
    2338:	6a00001c 	bvs	23b0 <shift+0x23b0>
    233c:	00266c0b 	eoreq	r6, r6, fp, lsl #24
    2340:	3d0b6b00 	vstrcc	d6, [fp, #-0]
    2344:	6c00001d 	stcvs	0, cr0, [r0], {29}
    2348:	00141c0b 	andseq	r1, r4, fp, lsl #24
    234c:	4c0b6d00 	stcmi	13, cr6, [fp], {-0}
    2350:	6e000015 	mcrvs	0, 0, r0, cr0, cr5, {0}
    2354:	0019370b 	andseq	r3, r9, fp, lsl #14
    2358:	e70b6f00 	str	r6, [fp, -r0, lsl #30]
    235c:	70000017 	andvc	r0, r0, r7, lsl r0
    2360:	07020300 	streq	r0, [r2, -r0, lsl #6]
    2364:	00000854 	andeq	r0, r0, r4, asr r8
    2368:	0004bc0c 	andeq	fp, r4, ip, lsl #24
    236c:	0004b100 	andeq	fp, r4, r0, lsl #2
    2370:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    2374:	000004a6 	andeq	r0, r0, r6, lsr #9
    2378:	04c80405 	strbeq	r0, [r8], #1029	; 0x405
    237c:	b60e0000 	strlt	r0, [lr], -r0
    2380:	03000004 	movweq	r0, #4
    2384:	07530801 	ldrbeq	r0, [r3, -r1, lsl #16]
    2388:	c10e0000 	mrsgt	r0, (UNDEF: 14)
    238c:	0f000004 	svceq	0x00000004
    2390:	000015e4 	andeq	r1, r0, r4, ror #11
    2394:	1a014404 	bne	533ac <__bss_end+0x496b4>
    2398:	000004b1 			; <UNDEFINED> instruction: 0x000004b1
    239c:	0019b80f 	andseq	fp, r9, pc, lsl #16
    23a0:	01790400 	cmneq	r9, r0, lsl #8
    23a4:	0004b11a 	andeq	fp, r4, sl, lsl r1
    23a8:	04c10c00 	strbeq	r0, [r1], #3072	; 0xc00
    23ac:	04f20000 	ldrbteq	r0, [r2], #0
    23b0:	000d0000 	andeq	r0, sp, r0
    23b4:	001be409 	andseq	lr, fp, r9, lsl #8
    23b8:	0d2d0500 	cfstr32eq	mvfx0, [sp, #-0]
    23bc:	000004e7 	andeq	r0, r0, r7, ror #9
    23c0:	0023d909 	eoreq	sp, r3, r9, lsl #18
    23c4:	1c350500 	cfldr32ne	mvfx0, [r5], #-0
    23c8:	000001e6 	andeq	r0, r0, r6, ror #3
    23cc:	0018940a 	andseq	r9, r8, sl, lsl #8
    23d0:	93010700 	movwls	r0, #5888	; 0x1700
    23d4:	05000000 	streq	r0, [r0, #-0]
    23d8:	057d0e37 	ldrbeq	r0, [sp, #-3639]!	; 0xfffff1c9
    23dc:	310b0000 	mrscc	r0, (UNDEF: 11)
    23e0:	00000014 	andeq	r0, r0, r4, lsl r0
    23e4:	001acb0b 	andseq	ip, sl, fp, lsl #22
    23e8:	d00b0100 	andle	r0, fp, r0, lsl #2
    23ec:	02000025 	andeq	r0, r0, #37	; 0x25
    23f0:	0025ab0b 	eoreq	sl, r5, fp, lsl #22
    23f4:	870b0300 	strhi	r0, [fp, -r0, lsl #6]
    23f8:	0400001e 	streq	r0, [r0], #-30	; 0xffffffe2
    23fc:	0022290b 	eoreq	r2, r2, fp, lsl #18
    2400:	270b0500 	strcs	r0, [fp, -r0, lsl #10]
    2404:	06000016 			; <UNDEFINED> instruction: 0x06000016
    2408:	0016090b 	andseq	r0, r6, fp, lsl #18
    240c:	5c0b0700 	stcpl	7, cr0, [fp], {-0}
    2410:	08000017 	stmdaeq	r0, {r0, r1, r2, r4}
    2414:	001d150b 	andseq	r1, sp, fp, lsl #10
    2418:	2e0b0900 	vmlacs.f16	s0, s22, s0	; <UNPREDICTABLE>
    241c:	0a000016 	beq	247c <shift+0x247c>
    2420:	00169a0b 	andseq	r9, r6, fp, lsl #20
    2424:	930b0b00 	movwls	r0, #47872	; 0xbb00
    2428:	0c000016 	stceq	0, cr0, [r0], {22}
    242c:	0016200b 	andseq	r2, r6, fp
    2430:	800b0d00 	andhi	r0, fp, r0, lsl #26
    2434:	0e000022 	cdpeq	0, 0, cr0, cr0, cr2, {1}
    2438:	001f770b 	andseq	r7, pc, fp, lsl #14
    243c:	04000f00 	streq	r0, [r0], #-3840	; 0xfffff100
    2440:	0000212b 	andeq	r2, r0, fp, lsr #2
    2444:	0a013c05 	beq	51460 <__bss_end+0x47768>
    2448:	09000005 	stmdbeq	r0, {r0, r2}
    244c:	000021fc 	strdeq	r2, [r0], -ip
    2450:	7d0f3e05 	stcvc	14, cr3, [pc, #-20]	; 2444 <shift+0x2444>
    2454:	09000005 	stmdbeq	r0, {r0, r2}
    2458:	000022a3 	andeq	r2, r0, r3, lsr #5
    245c:	1d0c4705 	stcne	7, cr4, [ip, #-20]	; 0xffffffec
    2460:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2464:	000015d4 	ldrdeq	r1, [r0], -r4
    2468:	1d0c4805 	stcne	8, cr4, [ip, #-20]	; 0xffffffec
    246c:	10000000 	andne	r0, r0, r0
    2470:	000023bd 			; <UNDEFINED> instruction: 0x000023bd
    2474:	00220b09 	eoreq	r0, r2, r9, lsl #22
    2478:	14490500 	strbne	r0, [r9], #-1280	; 0xfffffb00
    247c:	000005be 			; <UNDEFINED> instruction: 0x000005be
    2480:	05ad0405 	streq	r0, [sp, #1029]!	; 0x405
    2484:	09110000 	ldmdbeq	r1, {}	; <UNPREDICTABLE>
    2488:	00001a95 	muleq	r0, r5, sl
    248c:	d10f4b05 	tstle	pc, r5, lsl #22
    2490:	05000005 	streq	r0, [r0, #-5]
    2494:	0005c404 	andeq	ip, r5, r4, lsl #8
    2498:	217e1200 	cmncs	lr, r0, lsl #4
    249c:	74090000 	strvc	r0, [r9], #-0
    24a0:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    24a4:	05e80d4f 	strbeq	r0, [r8, #3407]!	; 0xd4f
    24a8:	04050000 	streq	r0, [r5], #-0
    24ac:	000005d7 	ldrdeq	r0, [r0], -r7
    24b0:	00174213 	andseq	r4, r7, r3, lsl r2
    24b4:	58053400 	stmdapl	r5, {sl, ip, sp}
    24b8:	06191501 	ldreq	r1, [r9], -r1, lsl #10
    24bc:	ed140000 	ldc	0, cr0, [r4, #-0]
    24c0:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    24c4:	b60f015a 			; <UNDEFINED> instruction: 0xb60f015a
    24c8:	00000004 	andeq	r0, r0, r4
    24cc:	00172614 	andseq	r2, r7, r4, lsl r6
    24d0:	015b0500 	cmpeq	fp, r0, lsl #10
    24d4:	00061e14 	andeq	r1, r6, r4, lsl lr
    24d8:	0e000400 	cfcpyseq	mvf0, mvf0
    24dc:	000005ee 	andeq	r0, r0, lr, ror #11
    24e0:	0000b90c 	andeq	fp, r0, ip, lsl #18
    24e4:	00062e00 	andeq	r2, r6, r0, lsl #28
    24e8:	00241500 	eoreq	r1, r4, r0, lsl #10
    24ec:	002d0000 	eoreq	r0, sp, r0
    24f0:	0006190c 	andeq	r1, r6, ip, lsl #18
    24f4:	00063900 	andeq	r3, r6, r0, lsl #18
    24f8:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    24fc:	0000062e 	andeq	r0, r0, lr, lsr #12
    2500:	001b1d0f 	andseq	r1, fp, pc, lsl #26
    2504:	015c0500 	cmpeq	ip, r0, lsl #10
    2508:	00063903 	andeq	r3, r6, r3, lsl #18
    250c:	1d8d0f00 	stcne	15, cr0, [sp]
    2510:	5f050000 	svcpl	0x00050000
    2514:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2518:	bc160000 	ldclt	0, cr0, [r6], {-0}
    251c:	07000021 	streq	r0, [r0, -r1, lsr #32]
    2520:	00009301 	andeq	r9, r0, r1, lsl #6
    2524:	01720500 	cmneq	r2, r0, lsl #10
    2528:	00070e06 	andeq	r0, r7, r6, lsl #28
    252c:	1e680b00 	vmulne.f64	d16, d8, d0
    2530:	0b000000 	bleq	2538 <shift+0x2538>
    2534:	000014d8 	ldrdeq	r1, [r0], -r8
    2538:	14e40b02 	strbtne	r0, [r4], #2818	; 0xb02
    253c:	0b030000 	bleq	c2544 <__bss_end+0xb884c>
    2540:	000018c0 	andeq	r1, r0, r0, asr #17
    2544:	1ea40b03 	vfmane.f64	d0, d4, d3
    2548:	0b040000 	bleq	102550 <__bss_end+0xf8858>
    254c:	00001a27 	andeq	r1, r0, r7, lsr #20
    2550:	15020b04 	strne	r0, [r2, #-2820]	; 0xfffff4fc
    2554:	0b050000 	bleq	14255c <__bss_end+0x138864>
    2558:	00001af4 	strdeq	r1, [r0], -r4
    255c:	1b2e0b05 	blne	b85178 <__bss_end+0xb7b480>
    2560:	0b050000 	bleq	142568 <__bss_end+0x138870>
    2564:	00001a58 	andeq	r1, r0, r8, asr sl
    2568:	15c50b05 	strbne	r0, [r5, #2821]	; 0xb05
    256c:	0b050000 	bleq	142574 <__bss_end+0x13887c>
    2570:	0000150e 	andeq	r1, r0, lr, lsl #10
    2574:	1c9d0b06 	vldmiane	sp, {d0-d2}
    2578:	0b060000 	bleq	182580 <__bss_end+0x178888>
    257c:	00001718 	andeq	r1, r0, r8, lsl r7
    2580:	1fb20b06 	svcne	0x00b20b06
    2584:	0b060000 	bleq	18258c <__bss_end+0x178894>
    2588:	0000224c 	andeq	r2, r0, ip, asr #4
    258c:	1cd10b06 	vldmiane	r1, {d16-d18}
    2590:	0b060000 	bleq	182598 <__bss_end+0x1788a0>
    2594:	00001d30 	andeq	r1, r0, r0, lsr sp
    2598:	151a0b06 	ldrne	r0, [sl, #-2822]	; 0xfffff4fa
    259c:	0b070000 	bleq	1c25a4 <__bss_end+0x1b88ac>
    25a0:	00001e4b 	andeq	r1, r0, fp, asr #28
    25a4:	1eb00b07 	vmovne.f64	d0, #7	; 0x40380000  2.875
    25a8:	0b070000 	bleq	1c25b0 <__bss_end+0x1b88b8>
    25ac:	00002296 	muleq	r0, r6, r2
    25b0:	16eb0b07 	strbtne	r0, [fp], r7, lsl #22
    25b4:	0b070000 	bleq	1c25bc <__bss_end+0x1b88c4>
    25b8:	00001f2b 	andeq	r1, r0, fp, lsr #30
    25bc:	147b0b08 	ldrbtne	r0, [fp], #-2824	; 0xfffff4f8
    25c0:	0b080000 	bleq	2025c8 <__bss_end+0x1f88d0>
    25c4:	0000225a 	andeq	r2, r0, sl, asr r2
    25c8:	1f4c0b08 	svcne	0x004c0b08
    25cc:	00080000 	andeq	r0, r8, r0
    25d0:	0025e50f 	eoreq	lr, r5, pc, lsl #10
    25d4:	01920500 	orrseq	r0, r2, r0, lsl #10
    25d8:	0006581f 	andeq	r5, r6, pc, lsl r8
    25dc:	19f40f00 	ldmibne	r4!, {r8, r9, sl, fp}^
    25e0:	95050000 	strls	r0, [r5, #-0]
    25e4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    25e8:	7e0f0000 	cdpvc	0, 0, cr0, cr15, cr0, {0}
    25ec:	0500001f 	streq	r0, [r0, #-31]	; 0xffffffe1
    25f0:	1d0c0198 	stfnes	f0, [ip, #-608]	; 0xfffffda0
    25f4:	0f000000 	svceq	0x00000000
    25f8:	00001b3b 	andeq	r1, r0, fp, lsr fp
    25fc:	0c019b05 			; <UNDEFINED> instruction: 0x0c019b05
    2600:	0000001d 	andeq	r0, r0, sp, lsl r0
    2604:	001f880f 	andseq	r8, pc, pc, lsl #16
    2608:	019e0500 	orrseq	r0, lr, r0, lsl #10
    260c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2610:	1c7e0f00 	ldclne	15, cr0, [lr], #-0
    2614:	a1050000 	mrsge	r0, (UNDEF: 5)
    2618:	001d0c01 	andseq	r0, sp, r1, lsl #24
    261c:	d20f0000 	andle	r0, pc, #0
    2620:	0500001f 	streq	r0, [r0, #-31]	; 0xffffffe1
    2624:	1d0c01a4 	stfnes	f0, [ip, #-656]	; 0xfffffd70
    2628:	0f000000 	svceq	0x00000000
    262c:	00001e8e 	andeq	r1, r0, lr, lsl #29
    2630:	0c01a705 	stceq	7, cr10, [r1], {5}
    2634:	0000001d 	andeq	r0, r0, sp, lsl r0
    2638:	001e990f 	andseq	r9, lr, pc, lsl #18
    263c:	01aa0500 			; <UNDEFINED> instruction: 0x01aa0500
    2640:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2644:	1f920f00 	svcne	0x00920f00
    2648:	ad050000 	stcge	0, cr0, [r5, #-0]
    264c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2650:	700f0000 	andvc	r0, pc, r0
    2654:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    2658:	1d0c01b0 	stfnes	f0, [ip, #-704]	; 0xfffffd40
    265c:	0f000000 	svceq	0x00000000
    2660:	00002627 	andeq	r2, r0, r7, lsr #12
    2664:	0c01b305 	stceq	3, cr11, [r1], {5}
    2668:	0000001d 	andeq	r0, r0, sp, lsl r0
    266c:	001f9c0f 	andseq	r9, pc, pc, lsl #24
    2670:	01b60500 			; <UNDEFINED> instruction: 0x01b60500
    2674:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2678:	27040f00 	strcs	r0, [r4, -r0, lsl #30]
    267c:	b9050000 	stmdblt	r5, {}	; <UNPREDICTABLE>
    2680:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2684:	b20f0000 	andlt	r0, pc, #0
    2688:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    268c:	1d0c01bc 	stfnes	f0, [ip, #-752]	; 0xfffffd10
    2690:	0f000000 	svceq	0x00000000
    2694:	000025d7 	ldrdeq	r2, [r0], -r7
    2698:	0c01c005 	stceq	0, cr12, [r1], {5}
    269c:	0000001d 	andeq	r0, r0, sp, lsl r0
    26a0:	0026f70f 	eoreq	pc, r6, pc, lsl #14
    26a4:	01c30500 	biceq	r0, r3, r0, lsl #10
    26a8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    26ac:	16350f00 	ldrtne	r0, [r5], -r0, lsl #30
    26b0:	c6050000 	strgt	r0, [r5], -r0
    26b4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    26b8:	0c0f0000 	stceq	0, cr0, [pc], {-0}
    26bc:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    26c0:	1d0c01c9 	stfnes	f0, [ip, #-804]	; 0xfffffcdc
    26c4:	0f000000 	svceq	0x00000000
    26c8:	000018e0 	andeq	r1, r0, r0, ror #17
    26cc:	0c01cc05 	stceq	12, cr12, [r1], {5}
    26d0:	0000001d 	andeq	r0, r0, sp, lsl r0
    26d4:	0016100f 	andseq	r1, r6, pc
    26d8:	01cf0500 	biceq	r0, pc, r0, lsl #10
    26dc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    26e0:	1fdc0f00 	svcne	0x00dc0f00
    26e4:	d2050000 	andle	r0, r5, #0
    26e8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    26ec:	630f0000 	movwvs	r0, #61440	; 0xf000
    26f0:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    26f4:	1d0c01d5 	stfnes	f0, [ip, #-852]	; 0xfffffcac
    26f8:	0f000000 	svceq	0x00000000
    26fc:	00001dfb 	strdeq	r1, [r0], -fp
    2700:	0c01d805 	stceq	8, cr13, [r1], {5}
    2704:	0000001d 	andeq	r0, r0, sp, lsl r0
    2708:	0023e20f 	eoreq	lr, r3, pc, lsl #4
    270c:	01df0500 	bicseq	r0, pc, r0, lsl #10
    2710:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2714:	26960f00 	ldrcs	r0, [r6], r0, lsl #30
    2718:	e2050000 	and	r0, r5, #0
    271c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2720:	a60f0000 	strge	r0, [pc], -r0
    2724:	05000026 	streq	r0, [r0, #-38]	; 0xffffffda
    2728:	1d0c01e5 	stfnes	f0, [ip, #-916]	; 0xfffffc6c
    272c:	0f000000 	svceq	0x00000000
    2730:	0000172f 	andeq	r1, r0, pc, lsr #14
    2734:	0c01e805 	stceq	8, cr14, [r1], {5}
    2738:	0000001d 	andeq	r0, r0, sp, lsl r0
    273c:	0024290f 	eoreq	r2, r4, pc, lsl #18
    2740:	01eb0500 	mvneq	r0, r0, lsl #10
    2744:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2748:	1f130f00 	svcne	0x00130f00
    274c:	ee050000 	cdp	0, 0, cr0, cr5, cr0, {0}
    2750:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2754:	590f0000 	stmdbpl	pc, {}	; <UNPREDICTABLE>
    2758:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    275c:	1d0c01f2 	stfnes	f0, [ip, #-968]	; 0xfffffc38
    2760:	0f000000 	svceq	0x00000000
    2764:	000021ce 	andeq	r2, r0, lr, asr #3
    2768:	0c01fa05 			; <UNDEFINED> instruction: 0x0c01fa05
    276c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2770:	0018120f 	andseq	r1, r8, pc, lsl #4
    2774:	01fd0500 	mvnseq	r0, r0, lsl #10
    2778:	00001d0c 	andeq	r1, r0, ip, lsl #26
    277c:	001d0c00 	andseq	r0, sp, r0, lsl #24
    2780:	08c60000 	stmiaeq	r6, {}^	; <UNPREDICTABLE>
    2784:	000d0000 	andeq	r0, sp, r0
    2788:	001a430f 	andseq	r4, sl, pc, lsl #6
    278c:	03eb0500 	mvneq	r0, #0, 10
    2790:	0008bb0c 	andeq	fp, r8, ip, lsl #22
    2794:	05be0c00 	ldreq	r0, [lr, #3072]!	; 0xc00
    2798:	08e30000 	stmiaeq	r3!, {}^	; <UNPREDICTABLE>
    279c:	24150000 	ldrcs	r0, [r5], #-0
    27a0:	0d000000 	stceq	0, cr0, [r0, #-0]
    27a4:	20120f00 	andscs	r0, r2, r0, lsl #30
    27a8:	74050000 	strvc	r0, [r5], #-0
    27ac:	08d31405 	ldmeq	r3, {r0, r2, sl, ip}^
    27b0:	26160000 	ldrcs	r0, [r6], -r0
    27b4:	0700001b 	smladeq	r0, fp, r0, r0
    27b8:	00009301 	andeq	r9, r0, r1, lsl #6
    27bc:	057b0500 	ldrbeq	r0, [fp, #-1280]!	; 0xfffffb00
    27c0:	00092e06 	andeq	r2, r9, r6, lsl #28
    27c4:	18a20b00 	stmiane	r2!, {r8, r9, fp}
    27c8:	0b000000 	bleq	27d0 <shift+0x27d0>
    27cc:	00001d5b 	andeq	r1, r0, fp, asr sp
    27d0:	14b10b01 	ldrtne	r0, [r1], #2817	; 0xb01
    27d4:	0b020000 	bleq	827dc <__bss_end+0x78ae4>
    27d8:	00002658 	andeq	r2, r0, r8, asr r6
    27dc:	209e0b03 	addscs	r0, lr, r3, lsl #22
    27e0:	0b040000 	bleq	1027e8 <__bss_end+0xf8af0>
    27e4:	00002091 	muleq	r0, r1, r0
    27e8:	15a40b05 	strne	r0, [r4, #2821]!	; 0xb05
    27ec:	00060000 	andeq	r0, r6, r0
    27f0:	0026480f 	eoreq	r4, r6, pc, lsl #16
    27f4:	05880500 	streq	r0, [r8, #1280]	; 0x500
    27f8:	0008f015 	andeq	pc, r8, r5, lsl r0	; <UNPREDICTABLE>
    27fc:	25240f00 	strcs	r0, [r4, #-3840]!	; 0xfffff100
    2800:	89050000 	stmdbhi	r5, {}	; <UNPREDICTABLE>
    2804:	00241107 	eoreq	r1, r4, r7, lsl #2
    2808:	ff0f0000 			; <UNDEFINED> instruction: 0xff0f0000
    280c:	0500001f 	streq	r0, [r0, #-31]	; 0xffffffe1
    2810:	1d0c079e 	stcne	7, cr0, [ip, #-632]	; 0xfffffd88
    2814:	04000000 	streq	r0, [r0], #-0
    2818:	000023d1 	ldrdeq	r2, [r0], -r1
    281c:	93167b06 	tstls	r6, #6144	; 0x1800
    2820:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    2824:	00000955 	andeq	r0, r0, r5, asr r9
    2828:	52050203 	andpl	r0, r5, #805306368	; 0x30000000
    282c:	03000004 	movweq	r0, #4
    2830:	17fb0708 	ldrbne	r0, [fp, r8, lsl #14]!
    2834:	04030000 	streq	r0, [r3], #-0
    2838:	00165004 	andseq	r5, r6, r4
    283c:	03080300 	movweq	r0, #33536	; 0x8300
    2840:	00001648 	andeq	r1, r0, r8, asr #12
    2844:	ab040803 	blge	104858 <__bss_end+0xfab60>
    2848:	0300001f 	movweq	r0, #31
    284c:	20e60310 	rsccs	r0, r6, r0, lsl r3
    2850:	610c0000 	mrsvs	r0, (UNDEF: 12)
    2854:	a0000009 	andge	r0, r0, r9
    2858:	15000009 	strne	r0, [r0, #-9]
    285c:	00000024 	andeq	r0, r0, r4, lsr #32
    2860:	900e00ff 	strdls	r0, [lr], -pc	; <UNPREDICTABLE>
    2864:	0f000009 	svceq	0x00000009
    2868:	00001ebd 			; <UNDEFINED> instruction: 0x00001ebd
    286c:	1601fc06 	strne	pc, [r1], -r6, lsl #24
    2870:	000009a0 	andeq	r0, r0, r0, lsr #19
    2874:	0015ff0f 	andseq	pc, r5, pc, lsl #30
    2878:	02020600 	andeq	r0, r2, #0, 12
    287c:	0009a016 	andeq	sl, r9, r6, lsl r0
    2880:	23f40400 	mvnscs	r0, #0, 8
    2884:	2a070000 	bcs	1c288c <__bss_end+0x1b8b94>
    2888:	0005d110 	andeq	sp, r5, r0, lsl r1
    288c:	09bf0c00 	ldmibeq	pc!, {sl, fp}	; <UNPREDICTABLE>
    2890:	09d60000 	ldmibeq	r6, {}^	; <UNPREDICTABLE>
    2894:	000d0000 	andeq	r0, sp, r0
    2898:	00039a09 	andeq	r9, r3, r9, lsl #20
    289c:	112f0700 			; <UNDEFINED> instruction: 0x112f0700
    28a0:	000009cb 	andeq	r0, r0, fp, asr #19
    28a4:	00025c09 	andeq	r5, r2, r9, lsl #24
    28a8:	11300700 	teqne	r0, r0, lsl #14
    28ac:	000009cb 	andeq	r0, r0, fp, asr #19
    28b0:	0009d617 	andeq	sp, r9, r7, lsl r6
    28b4:	09360800 	ldmdbeq	r6!, {fp}
    28b8:	e803050a 	stmda	r3, {r1, r3, r8, sl}
    28bc:	1700009c 			; <UNDEFINED> instruction: 0x1700009c
    28c0:	000009e2 	andeq	r0, r0, r2, ror #19
    28c4:	0a093708 	beq	2504ec <__bss_end+0x2467f4>
    28c8:	9ce80305 	stclls	3, cr0, [r8], #20
    28cc:	42000000 	andmi	r0, r0, #0
    28d0:	0400000a 	streq	r0, [r0], #-10
    28d4:	00096b00 	andeq	r6, r9, r0, lsl #22
    28d8:	5f010400 	svcpl	0x00010400
    28dc:	0c000024 	stceq	0, cr0, [r0], {36}	; 0x24
    28e0:	000016a1 	andeq	r1, r0, r1, lsr #13
    28e4:	000012fd 	strdeq	r1, [r0], -sp
    28e8:	00009ad0 	ldrdeq	r9, [r0], -r0
    28ec:	0000002c 	andeq	r0, r0, ip, lsr #32
    28f0:	00000ef1 	strdeq	r0, [r0], -r1
    28f4:	50040402 	andpl	r0, r4, r2, lsl #8
    28f8:	03000016 	movweq	r0, #22
    28fc:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    2900:	04020074 	streq	r0, [r2], #-116	; 0xffffff8c
    2904:	00180507 	andseq	r0, r8, r7, lsl #10
    2908:	05080200 	streq	r0, [r8, #-512]	; 0xfffffe00
    290c:	0000037f 	andeq	r0, r0, pc, ror r3
    2910:	a6040802 	strge	r0, [r4], -r2, lsl #16
    2914:	0400001f 	streq	r0, [r0], #-31	; 0xffffffe1
    2918:	0000170e 	andeq	r1, r0, lr, lsl #14
    291c:	33162a02 	tstcc	r6, #8192	; 0x2000
    2920:	04000000 	streq	r0, [r0], #-0
    2924:	00001b71 	andeq	r1, r0, r1, ror fp
    2928:	60152f02 	andsvs	r2, r5, r2, lsl #30
    292c:	05000000 	streq	r0, [r0, #-0]
    2930:	00006604 	andeq	r6, r0, r4, lsl #12
    2934:	00480600 	subeq	r0, r8, r0, lsl #12
    2938:	00750000 	rsbseq	r0, r5, r0
    293c:	75070000 	strvc	r0, [r7, #-0]
    2940:	00000000 	andeq	r0, r0, r0
    2944:	007b0405 	rsbseq	r0, fp, r5, lsl #8
    2948:	04080000 	streq	r0, [r8], #-0
    294c:	00002410 	andeq	r2, r0, r0, lsl r4
    2950:	880f3602 	stmdahi	pc, {r1, r9, sl, ip, sp}	; <UNPREDICTABLE>
    2954:	05000000 	streq	r0, [r0, #-0]
    2958:	00008e04 	andeq	r8, r0, r4, lsl #28
    295c:	002c0600 	eoreq	r0, ip, r0, lsl #12
    2960:	00a20000 	adceq	r0, r2, r0
    2964:	75070000 	strvc	r0, [r7, #-0]
    2968:	07000000 	streq	r0, [r0, -r0]
    296c:	00000075 	andeq	r0, r0, r5, ror r0
    2970:	08010200 	stmdaeq	r1, {r9}
    2974:	0000074a 	andeq	r0, r0, sl, asr #14
    2978:	001dd409 	andseq	sp, sp, r9, lsl #8
    297c:	12bb0200 	adcsne	r0, fp, #0, 4
    2980:	00000054 	andeq	r0, r0, r4, asr r0
    2984:	00243e09 	eoreq	r3, r4, r9, lsl #28
    2988:	10be0200 	adcsne	r0, lr, r0, lsl #4
    298c:	0000007c 	andeq	r0, r0, ip, ror r0
    2990:	4c060102 	stfmis	f0, [r6], {2}
    2994:	0a000007 	beq	29b8 <shift+0x29b8>
    2998:	00001a78 	andeq	r1, r0, r8, ror sl
    299c:	00a20107 	adceq	r0, r2, r7, lsl #2
    29a0:	17030000 	strne	r0, [r3, -r0]
    29a4:	0001f506 	andeq	pc, r1, r6, lsl #10
    29a8:	15750b00 	ldrbne	r0, [r5, #-2816]!	; 0xfffff500
    29ac:	0b000000 	bleq	29b4 <shift+0x29b4>
    29b0:	00001970 	andeq	r1, r0, r0, ror r9
    29b4:	1ecc0b01 	vdivne.f64	d16, d12, d1
    29b8:	0b020000 	bleq	829c0 <__bss_end+0x78cc8>
    29bc:	00002354 	andeq	r2, r0, r4, asr r3
    29c0:	1e580b03 	vnmlsne.f64	d16, d8, d3
    29c4:	0b040000 	bleq	1029cc <__bss_end+0xf8cd4>
    29c8:	0000221b 	andeq	r2, r0, fp, lsl r2
    29cc:	21410b05 	cmpcs	r1, r5, lsl #22
    29d0:	0b060000 	bleq	1829d8 <__bss_end+0x178ce0>
    29d4:	00001596 	muleq	r0, r6, r5
    29d8:	22300b07 	eorscs	r0, r0, #7168	; 0x1c00
    29dc:	0b080000 	bleq	2029e4 <__bss_end+0x1f8cec>
    29e0:	0000223e 	andeq	r2, r0, lr, lsr r2
    29e4:	232f0b09 			; <UNDEFINED> instruction: 0x232f0b09
    29e8:	0b0a0000 	bleq	2829f0 <__bss_end+0x278cf8>
    29ec:	00001d9a 	muleq	r0, sl, sp
    29f0:	174f0b0b 	strbne	r0, [pc, -fp, lsl #22]
    29f4:	0b0c0000 	bleq	3029fc <__bss_end+0x2f8d04>
    29f8:	00001b01 	andeq	r1, r0, r1, lsl #22
    29fc:	22870b0d 	addcs	r0, r7, #13312	; 0x3400
    2a00:	0b0e0000 	bleq	382a08 <__bss_end+0x378d10>
    2a04:	00001abc 			; <UNDEFINED> instruction: 0x00001abc
    2a08:	1ad20b0f 	bne	ff48564c <__bss_end+0xff47b954>
    2a0c:	0b100000 	bleq	402a14 <__bss_end+0x3f8d1c>
    2a10:	000019a7 	andeq	r1, r0, r7, lsr #19
    2a14:	1e3c0b11 	vmovne.32	r0, d12[1]
    2a18:	0b120000 	bleq	482a20 <__bss_end+0x478d28>
    2a1c:	00001a34 	andeq	r1, r0, r4, lsr sl
    2a20:	26ec0b13 	usatcs	r0, #12, r3, lsl #22
    2a24:	0b140000 	bleq	502a2c <__bss_end+0x4f8d34>
    2a28:	00001f04 	andeq	r1, r0, r4, lsl #30
    2a2c:	1c610b15 			; <UNDEFINED> instruction: 0x1c610b15
    2a30:	0b160000 	bleq	582a38 <__bss_end+0x578d40>
    2a34:	000015f3 	strdeq	r1, [r0], -r3
    2a38:	23770b17 	cmncs	r7, #23552	; 0x5c00
    2a3c:	0b180000 	bleq	602a44 <__bss_end+0x5f8d4c>
    2a40:	00002581 	andeq	r2, r0, r1, lsl #11
    2a44:	23850b19 	orrcs	r0, r5, #25600	; 0x6400
    2a48:	0b1a0000 	bleq	682a50 <__bss_end+0x678d58>
    2a4c:	00001a84 	andeq	r1, r0, r4, lsl #21
    2a50:	23930b1b 	orrscs	r0, r3, #27648	; 0x6c00
    2a54:	0b1c0000 	bleq	702a5c <__bss_end+0x6f8d64>
    2a58:	0000144f 	andeq	r1, r0, pc, asr #8
    2a5c:	23a10b1d 			; <UNDEFINED> instruction: 0x23a10b1d
    2a60:	0b1e0000 	bleq	782a68 <__bss_end+0x778d70>
    2a64:	000023af 	andeq	r2, r0, pc, lsr #7
    2a68:	13e80b1f 	mvnne	r0, #31744	; 0x7c00
    2a6c:	0b200000 	bleq	802a74 <__bss_end+0x7f8d7c>
    2a70:	00002027 	andeq	r2, r0, r7, lsr #32
    2a74:	1e0e0b21 	vmlane.f64	d0, d14, d17
    2a78:	0b220000 	bleq	882a80 <__bss_end+0x878d88>
    2a7c:	0000236a 	andeq	r2, r0, sl, ror #6
    2a80:	1cde0b23 	fldmiaxne	lr, {d16-d32}	;@ Deprecated
    2a84:	0b240000 	bleq	902a8c <__bss_end+0x8f8d94>
    2a88:	00002132 	andeq	r2, r0, r2, lsr r1
    2a8c:	1bd40b25 	blne	ff505728 <__bss_end+0xff4fba30>
    2a90:	0b260000 	bleq	982a98 <__bss_end+0x978da0>
    2a94:	000018b0 			; <UNDEFINED> instruction: 0x000018b0
    2a98:	1bf20b27 	blne	ffc8573c <__bss_end+0xffc7ba44>
    2a9c:	0b280000 	bleq	a02aa4 <__bss_end+0x9f8dac>
    2aa0:	0000194c 	andeq	r1, r0, ip, asr #18
    2aa4:	1c020b29 			; <UNDEFINED> instruction: 0x1c020b29
    2aa8:	0b2a0000 	bleq	a82ab0 <__bss_end+0xa78db8>
    2aac:	00001d80 	andeq	r1, r0, r0, lsl #27
    2ab0:	1b7b0b2b 	blne	1ec5764 <__bss_end+0x1ebba6c>
    2ab4:	0b2c0000 	bleq	b02abc <__bss_end+0xaf8dc4>
    2ab8:	00002046 	andeq	r2, r0, r6, asr #32
    2abc:	18f10b2d 	ldmne	r1!, {r0, r2, r3, r5, r8, r9, fp}^
    2ac0:	002e0000 	eoreq	r0, lr, r0
    2ac4:	001b0e0a 	andseq	r0, fp, sl, lsl #28
    2ac8:	a2010700 	andge	r0, r1, #0, 14
    2acc:	04000000 	streq	r0, [r0], #-0
    2ad0:	04ae0617 	strteq	r0, [lr], #1559	; 0x617
    2ad4:	630b0000 	movwvs	r0, #45056	; 0xb000
    2ad8:	00000017 	andeq	r0, r0, r7, lsl r0
    2adc:	0026150b 	eoreq	r1, r6, fp, lsl #10
    2ae0:	730b0100 	movwvc	r0, #45312	; 0xb100
    2ae4:	02000017 	andeq	r0, r0, #23
    2ae8:	0017960b 	andseq	r9, r7, fp, lsl #12
    2aec:	4e0b0300 	cdpmi	3, 0, cr0, cr11, cr0, {0}
    2af0:	04000024 	streq	r0, [r0], #-36	; 0xffffffdc
    2af4:	0020ac0b 	eoreq	sl, r0, fp, lsl #24
    2af8:	200b0500 	andcs	r0, fp, r0, lsl #10
    2afc:	06000018 			; <UNDEFINED> instruction: 0x06000018
    2b00:	0019950b 	andseq	r9, r9, fp, lsl #10
    2b04:	a60b0700 	strge	r0, [fp], -r0, lsl #14
    2b08:	08000017 	stmdaeq	r0, {r0, r1, r2, r4}
    2b0c:	0026db0b 	eoreq	sp, r6, fp, lsl #22
    2b10:	c60b0900 	strgt	r0, [fp], -r0, lsl #18
    2b14:	0a000014 	beq	2b6c <shift+0x2b6c>
    2b18:	0026040b 	eoreq	r0, r6, fp, lsl #8
    2b1c:	ed0b0b00 	vstr	d0, [fp, #-0]
    2b20:	0c00001c 	stceq	0, cr0, [r0], {28}
    2b24:	0025980b 	eoreq	r9, r5, fp, lsl #16
    2b28:	340b0d00 	strcc	r0, [fp], #-3328	; 0xfffff300
    2b2c:	0e000020 	cdpeq	0, 0, cr0, cr0, cr0, {1}
    2b30:	0022cd0b 	eoreq	ip, r2, fp, lsl #26
    2b34:	810b0f00 	tsthi	fp, r0, lsl #30
    2b38:	10000018 	andne	r0, r0, r8, lsl r0
    2b3c:	0017830b 	andseq	r8, r7, fp, lsl #6
    2b40:	ec0b1100 	stfs	f1, [fp], {-0}
    2b44:	1200001f 	andne	r0, r0, #31
    2b48:	00186c0b 	andseq	r6, r8, fp, lsl #24
    2b4c:	f30b1300 	vcgt.u8	d1, d11, d0
    2b50:	14000025 	strne	r0, [r0], #-37	; 0xffffffdb
    2b54:	0014f00b 	andseq	pc, r4, fp
    2b58:	3c0b1500 	cfstr32cc	mvfx1, [fp], {-0}
    2b5c:	1600001c 			; <UNDEFINED> instruction: 0x1600001c
    2b60:	0017b60b 	andseq	fp, r7, fp, lsl #12
    2b64:	8d0b1700 	stchi	7, cr1, [fp, #-0]
    2b68:	18000014 	stmdane	r0, {r2, r4}
    2b6c:	0026810b 	eoreq	r8, r6, fp, lsl #2
    2b70:	3c0b1900 			; <UNDEFINED> instruction: 0x3c0b1900
    2b74:	1a000023 	bne	2c08 <shift+0x2c08>
    2b78:	0021500b 	eoreq	r5, r1, fp
    2b7c:	b40b1b00 	strlt	r1, [fp], #-2816	; 0xfffff500
    2b80:	1c000022 	stcne	0, cr0, [r0], {34}	; 0x22
    2b84:	0024180b 	eoreq	r1, r4, fp, lsl #16
    2b88:	d60b1d00 	strle	r1, [fp], -r0, lsl #26
    2b8c:	1e000017 	mcrne	0, 0, r0, cr0, cr7, {0}
    2b90:	0015610b 	andseq	r6, r5, fp, lsl #2
    2b94:	690b1f00 	stmdbvs	fp, {r8, r9, sl, fp, ip}
    2b98:	20000021 	andcs	r0, r0, r1, lsr #32
    2b9c:	0018cd0b 	andseq	ip, r8, fp, lsl #26
    2ba0:	be0b2100 	adflte	f2, f3, f0
    2ba4:	22000020 	andcs	r0, r0, #32
    2ba8:	001cbe0b 	andseq	fp, ip, fp, lsl #28
    2bac:	c60b2300 	strgt	r2, [fp], -r0, lsl #6
    2bb0:	24000017 	strcs	r0, [r0], #-23	; 0xffffffe9
    2bb4:	00226c0b 	eoreq	r6, r2, fp, lsl #24
    2bb8:	d90b2500 	stmdble	fp, {r8, sl, sp}
    2bbc:	26000016 			; <UNDEFINED> instruction: 0x26000016
    2bc0:	0023fd0b 	eoreq	pc, r3, fp, lsl #26
    2bc4:	c80b2700 	stmdagt	fp, {r8, r9, sl, sp}
    2bc8:	28000026 	stmdacs	r0, {r1, r2, r5}
    2bcc:	001fbf0b 	andseq	fp, pc, fp, lsl #30
    2bd0:	660b2900 	strvs	r2, [fp], -r0, lsl #18
    2bd4:	2a00001a 	bcs	2c44 <shift+0x2c44>
    2bd8:	0021930b 	eoreq	r9, r1, fp, lsl #6
    2bdc:	1c0b2b00 			; <UNDEFINED> instruction: 0x1c0b2b00
    2be0:	2c00001d 	stccs	0, cr0, [r0], {29}
    2be4:	0015b40b 	andseq	fp, r5, fp, lsl #8
    2be8:	380b2d00 	stmdacc	fp, {r8, sl, fp, sp}
    2bec:	2e000015 	mcrcs	0, 0, r0, cr0, cr5, {0}
    2bf0:	0025560b 	eoreq	r5, r5, fp, lsl #12
    2bf4:	aa0b2f00 	bge	2ce7fc <__bss_end+0x2c4b04>
    2bf8:	3000001c 	andcc	r0, r0, ip, lsl r0
    2bfc:	0018460b 	andseq	r4, r8, fp, lsl #12
    2c00:	890b3100 	stmdbhi	fp, {r8, ip, sp}
    2c04:	3200001c 	andcc	r0, r0, #28
    2c08:	001f380b 	andseq	r3, pc, fp, lsl #16
    2c0c:	260b3300 	strcs	r3, [fp], -r0, lsl #6
    2c10:	34000015 	strcc	r0, [r0], #-21	; 0xffffffeb
    2c14:	0026b60b 	eoreq	fp, r6, fp, lsl #12
    2c18:	6d0b3500 	cfstr32vs	mvfx3, [fp, #-0]
    2c1c:	3600001d 			; <UNDEFINED> instruction: 0x3600001d
    2c20:	0019ff0b 	andseq	pc, r9, fp, lsl #30
    2c24:	aa0b3700 	bge	2d082c <__bss_end+0x2c6b34>
    2c28:	3800001d 	stmdacc	r0, {r0, r2, r3, r4}
    2c2c:	0025be0b 	eoreq	fp, r5, fp, lsl #28
    2c30:	6b0b3900 	blvs	2d1038 <__bss_end+0x2c7340>
    2c34:	3a000016 	bcc	2c94 <shift+0x2c94>
    2c38:	001a120b 	andseq	r1, sl, fp, lsl #4
    2c3c:	de0b3b00 	vmlale.f64	d3, d11, d0
    2c40:	3c000019 	stccc	0, cr0, [r0], {25}
    2c44:	0013f70b 	andseq	pc, r3, fp, lsl #14
    2c48:	ff0b3d00 			; <UNDEFINED> instruction: 0xff0b3d00
    2c4c:	3e00001c 	mcrcc	0, 0, r0, cr0, cr12, {0}
    2c50:	001ade0b 	andseq	sp, sl, fp, lsl #28
    2c54:	7f0b3f00 	svcvc	0x000b3f00
    2c58:	40000015 	andmi	r0, r0, r5, lsl r0
    2c5c:	00256a0b 	eoreq	r6, r5, fp, lsl #20
    2c60:	4f0b4100 	svcmi	0x000b4100
    2c64:	4200001c 	andmi	r0, r0, #28
    2c68:	0019c80b 	andseq	ip, r9, fp, lsl #16
    2c6c:	380b4300 	stmdacc	fp, {r8, r9, lr}
    2c70:	44000014 	strmi	r0, [r0], #-20	; 0xffffffec
    2c74:	001bac0b 	andseq	sl, fp, fp, lsl #24
    2c78:	980b4500 	stmdals	fp, {r8, sl, lr}
    2c7c:	4600001b 			; <UNDEFINED> instruction: 0x4600001b
    2c80:	0021130b 	eoreq	r1, r1, fp, lsl #6
    2c84:	db0b4700 	blle	2d488c <__bss_end+0x2cab94>
    2c88:	48000021 	stmdami	r0, {r0, r5}
    2c8c:	0025350b 	eoreq	r3, r5, fp, lsl #10
    2c90:	fe0b4900 	vseleq.f16	s8, s22, s0
    2c94:	4a000018 	bmi	2cfc <shift+0x2cfc>
    2c98:	001eee0b 	andseq	lr, lr, fp, lsl #28
    2c9c:	a80b4b00 	stmdage	fp, {r8, r9, fp, lr}
    2ca0:	4c000021 	stcmi	0, cr0, [r0], {33}	; 0x21
    2ca4:	0020550b 	eoreq	r5, r0, fp, lsl #10
    2ca8:	690b4d00 	stmdbvs	fp, {r8, sl, fp, lr}
    2cac:	4e000020 	cdpmi	0, 0, cr0, cr0, cr0, {1}
    2cb0:	00207d0b 	eoreq	r7, r0, fp, lsl #26
    2cb4:	f90b4f00 			; <UNDEFINED> instruction: 0xf90b4f00
    2cb8:	50000016 	andpl	r0, r0, r6, lsl r0
    2cbc:	0016560b 	andseq	r5, r6, fp, lsl #12
    2cc0:	7e0b5100 	adfvce	f5, f3, f0
    2cc4:	52000016 	andpl	r0, r0, #22
    2cc8:	0022df0b 	eoreq	sp, r2, fp, lsl #30
    2ccc:	c40b5300 	strgt	r5, [fp], #-768	; 0xfffffd00
    2cd0:	54000016 	strpl	r0, [r0], #-22	; 0xffffffea
    2cd4:	0022f30b 	eoreq	pc, r2, fp, lsl #6
    2cd8:	070b5500 	streq	r5, [fp, -r0, lsl #10]
    2cdc:	56000023 	strpl	r0, [r0], -r3, lsr #32
    2ce0:	00231b0b 	eoreq	r1, r3, fp, lsl #22
    2ce4:	580b5700 	stmdapl	fp, {r8, r9, sl, ip, lr}
    2ce8:	58000018 	stmdapl	r0, {r3, r4}
    2cec:	0018320b 	andseq	r3, r8, fp, lsl #4
    2cf0:	c00b5900 	andgt	r5, fp, r0, lsl #18
    2cf4:	5a00001b 	bpl	2d68 <shift+0x2d68>
    2cf8:	001dbd0b 	andseq	fp, sp, fp, lsl #26
    2cfc:	460b5b00 	strmi	r5, [fp], -r0, lsl #22
    2d00:	5c00001b 	stcpl	0, cr0, [r0], {27}
    2d04:	0013cb0b 	andseq	ip, r3, fp, lsl #22
    2d08:	800b5d00 	andhi	r5, fp, r0, lsl #26
    2d0c:	5e000019 	mcrpl	0, 0, r0, cr0, cr9, {0}
    2d10:	001de60b 	andseq	lr, sp, fp, lsl #12
    2d14:	120b5f00 	andne	r5, fp, #0, 30
    2d18:	6000001c 	andvs	r0, r0, ip, lsl r0
    2d1c:	0020d10b 	eoreq	sp, r0, fp, lsl #2
    2d20:	330b6100 	movwcc	r6, #45312	; 0xb100
    2d24:	62000026 	andvs	r0, r0, #38	; 0x26
    2d28:	001ed90b 	andseq	sp, lr, fp, lsl #18
    2d2c:	230b6300 	movwcs	r6, #45824	; 0xb300
    2d30:	64000019 	strvs	r0, [r0], #-25	; 0xffffffe7
    2d34:	00149f0b 	andseq	r9, r4, fp, lsl #30
    2d38:	5d0b6500 	cfstr32pl	mvfx6, [fp, #-0]
    2d3c:	66000014 			; <UNDEFINED> instruction: 0x66000014
    2d40:	001e1e0b 	andseq	r1, lr, fp, lsl #28
    2d44:	590b6700 	stmdbpl	fp, {r8, r9, sl, sp, lr}
    2d48:	6800001f 	stmdavs	r0, {r0, r1, r2, r3, r4}
    2d4c:	0020f50b 	eoreq	pc, r0, fp, lsl #10
    2d50:	270b6900 	strcs	r6, [fp, -r0, lsl #18]
    2d54:	6a00001c 	bvs	2dcc <shift+0x2dcc>
    2d58:	00266c0b 	eoreq	r6, r6, fp, lsl #24
    2d5c:	3d0b6b00 	vstrcc	d6, [fp, #-0]
    2d60:	6c00001d 	stcvs	0, cr0, [r0], {29}
    2d64:	00141c0b 	andseq	r1, r4, fp, lsl #24
    2d68:	4c0b6d00 	stcmi	13, cr6, [fp], {-0}
    2d6c:	6e000015 	mcrvs	0, 0, r0, cr0, cr5, {0}
    2d70:	0019370b 	andseq	r3, r9, fp, lsl #14
    2d74:	e70b6f00 	str	r6, [fp, -r0, lsl #30]
    2d78:	70000017 	andvc	r0, r0, r7, lsl r0
    2d7c:	07020200 	streq	r0, [r2, -r0, lsl #4]
    2d80:	00000854 	andeq	r0, r0, r4, asr r8
    2d84:	0004cb0c 	andeq	ip, r4, ip, lsl #22
    2d88:	0004c000 	andeq	ip, r4, r0
    2d8c:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    2d90:	000004b5 			; <UNDEFINED> instruction: 0x000004b5
    2d94:	04d70405 	ldrbeq	r0, [r7], #1029	; 0x405
    2d98:	c50e0000 	strgt	r0, [lr, #-0]
    2d9c:	02000004 	andeq	r0, r0, #4
    2da0:	07530801 	ldrbeq	r0, [r3, -r1, lsl #16]
    2da4:	d00e0000 	andle	r0, lr, r0
    2da8:	0f000004 	svceq	0x00000004
    2dac:	000015e4 	andeq	r1, r0, r4, ror #11
    2db0:	1a014405 	bne	53dcc <__bss_end+0x4a0d4>
    2db4:	000004c0 	andeq	r0, r0, r0, asr #9
    2db8:	0019b80f 	andseq	fp, r9, pc, lsl #16
    2dbc:	01790500 	cmneq	r9, r0, lsl #10
    2dc0:	0004c01a 	andeq	ip, r4, sl, lsl r0
    2dc4:	04d00c00 	ldrbeq	r0, [r0], #3072	; 0xc00
    2dc8:	05010000 	streq	r0, [r1, #-0]
    2dcc:	000d0000 	andeq	r0, sp, r0
    2dd0:	001be409 	andseq	lr, fp, r9, lsl #8
    2dd4:	0d2d0600 	stceq	6, cr0, [sp, #-0]
    2dd8:	000004f6 	strdeq	r0, [r0], -r6
    2ddc:	0023d909 	eoreq	sp, r3, r9, lsl #18
    2de0:	1c350600 	ldcne	6, cr0, [r5], #-0
    2de4:	000001f5 	strdeq	r0, [r0], -r5
    2de8:	0018940a 	andseq	r9, r8, sl, lsl #8
    2dec:	a2010700 	andge	r0, r1, #0, 14
    2df0:	06000000 	streq	r0, [r0], -r0
    2df4:	058c0e37 	streq	r0, [ip, #3639]	; 0xe37
    2df8:	310b0000 	mrscc	r0, (UNDEF: 11)
    2dfc:	00000014 	andeq	r0, r0, r4, lsl r0
    2e00:	001acb0b 	andseq	ip, sl, fp, lsl #22
    2e04:	d00b0100 	andle	r0, fp, r0, lsl #2
    2e08:	02000025 	andeq	r0, r0, #37	; 0x25
    2e0c:	0025ab0b 	eoreq	sl, r5, fp, lsl #22
    2e10:	870b0300 	strhi	r0, [fp, -r0, lsl #6]
    2e14:	0400001e 	streq	r0, [r0], #-30	; 0xffffffe2
    2e18:	0022290b 	eoreq	r2, r2, fp, lsl #18
    2e1c:	270b0500 	strcs	r0, [fp, -r0, lsl #10]
    2e20:	06000016 			; <UNDEFINED> instruction: 0x06000016
    2e24:	0016090b 	andseq	r0, r6, fp, lsl #18
    2e28:	5c0b0700 	stcpl	7, cr0, [fp], {-0}
    2e2c:	08000017 	stmdaeq	r0, {r0, r1, r2, r4}
    2e30:	001d150b 	andseq	r1, sp, fp, lsl #10
    2e34:	2e0b0900 	vmlacs.f16	s0, s22, s0	; <UNPREDICTABLE>
    2e38:	0a000016 	beq	2e98 <shift+0x2e98>
    2e3c:	00169a0b 	andseq	r9, r6, fp, lsl #20
    2e40:	930b0b00 	movwls	r0, #47872	; 0xbb00
    2e44:	0c000016 	stceq	0, cr0, [r0], {22}
    2e48:	0016200b 	andseq	r2, r6, fp
    2e4c:	800b0d00 	andhi	r0, fp, r0, lsl #26
    2e50:	0e000022 	cdpeq	0, 0, cr0, cr0, cr2, {1}
    2e54:	001f770b 	andseq	r7, pc, fp, lsl #14
    2e58:	04000f00 	streq	r0, [r0], #-3840	; 0xfffff100
    2e5c:	0000212b 	andeq	r2, r0, fp, lsr #2
    2e60:	19013c06 	stmdbne	r1, {r1, r2, sl, fp, ip, sp}
    2e64:	09000005 	stmdbeq	r0, {r0, r2}
    2e68:	000021fc 	strdeq	r2, [r0], -ip
    2e6c:	8c0f3e06 	stchi	14, cr3, [pc], {6}
    2e70:	09000005 	stmdbeq	r0, {r0, r2}
    2e74:	000022a3 	andeq	r2, r0, r3, lsr #5
    2e78:	2c0c4706 	stccs	7, cr4, [ip], {6}
    2e7c:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2e80:	000015d4 	ldrdeq	r1, [r0], -r4
    2e84:	2c0c4806 	stccs	8, cr4, [ip], {6}
    2e88:	10000000 	andne	r0, r0, r0
    2e8c:	000023bd 			; <UNDEFINED> instruction: 0x000023bd
    2e90:	00220b09 	eoreq	r0, r2, r9, lsl #22
    2e94:	14490600 	strbne	r0, [r9], #-1536	; 0xfffffa00
    2e98:	000005cd 	andeq	r0, r0, sp, asr #11
    2e9c:	05bc0405 	ldreq	r0, [ip, #1029]!	; 0x405
    2ea0:	09110000 	ldmdbeq	r1, {}	; <UNPREDICTABLE>
    2ea4:	00001a95 	muleq	r0, r5, sl
    2ea8:	e00f4b06 	and	r4, pc, r6, lsl #22
    2eac:	05000005 	streq	r0, [r0, #-5]
    2eb0:	0005d304 	andeq	sp, r5, r4, lsl #6
    2eb4:	217e1200 	cmncs	lr, r0, lsl #4
    2eb8:	74090000 	strvc	r0, [r9], #-0
    2ebc:	0600001e 			; <UNDEFINED> instruction: 0x0600001e
    2ec0:	05f70d4f 	ldrbeq	r0, [r7, #3407]!	; 0xd4f
    2ec4:	04050000 	streq	r0, [r5], #-0
    2ec8:	000005e6 	andeq	r0, r0, r6, ror #11
    2ecc:	00174213 	andseq	r4, r7, r3, lsl r2
    2ed0:	58063400 	stmdapl	r6, {sl, ip, sp}
    2ed4:	06281501 	strteq	r1, [r8], -r1, lsl #10
    2ed8:	ed140000 	ldc	0, cr0, [r4, #-0]
    2edc:	0600001b 			; <UNDEFINED> instruction: 0x0600001b
    2ee0:	c50f015a 	strgt	r0, [pc, #-346]	; 2d8e <shift+0x2d8e>
    2ee4:	00000004 	andeq	r0, r0, r4
    2ee8:	00172614 	andseq	r2, r7, r4, lsl r6
    2eec:	015b0600 	cmpeq	fp, r0, lsl #12
    2ef0:	00062d14 	andeq	r2, r6, r4, lsl sp
    2ef4:	0e000400 	cfcpyseq	mvf0, mvf0
    2ef8:	000005fd 	strdeq	r0, [r0], -sp
    2efc:	0000c80c 	andeq	ip, r0, ip, lsl #16
    2f00:	00063d00 	andeq	r3, r6, r0, lsl #26
    2f04:	00331500 	eorseq	r1, r3, r0, lsl #10
    2f08:	002d0000 	eoreq	r0, sp, r0
    2f0c:	0006280c 	andeq	r2, r6, ip, lsl #16
    2f10:	00064800 	andeq	r4, r6, r0, lsl #16
    2f14:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    2f18:	0000063d 	andeq	r0, r0, sp, lsr r6
    2f1c:	001b1d0f 	andseq	r1, fp, pc, lsl #26
    2f20:	015c0600 	cmpeq	ip, r0, lsl #12
    2f24:	00064803 	andeq	r4, r6, r3, lsl #16
    2f28:	1d8d0f00 	stcne	15, cr0, [sp]
    2f2c:	5f060000 	svcpl	0x00060000
    2f30:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    2f34:	bc160000 	ldclt	0, cr0, [r6], {-0}
    2f38:	07000021 	streq	r0, [r0, -r1, lsr #32]
    2f3c:	0000a201 	andeq	sl, r0, r1, lsl #4
    2f40:	01720600 	cmneq	r2, r0, lsl #12
    2f44:	00071d06 	andeq	r1, r7, r6, lsl #26
    2f48:	1e680b00 	vmulne.f64	d16, d8, d0
    2f4c:	0b000000 	bleq	2f54 <shift+0x2f54>
    2f50:	000014d8 	ldrdeq	r1, [r0], -r8
    2f54:	14e40b02 	strbtne	r0, [r4], #2818	; 0xb02
    2f58:	0b030000 	bleq	c2f60 <__bss_end+0xb9268>
    2f5c:	000018c0 	andeq	r1, r0, r0, asr #17
    2f60:	1ea40b03 	vfmane.f64	d0, d4, d3
    2f64:	0b040000 	bleq	102f6c <__bss_end+0xf9274>
    2f68:	00001a27 	andeq	r1, r0, r7, lsr #20
    2f6c:	15020b04 	strne	r0, [r2, #-2820]	; 0xfffff4fc
    2f70:	0b050000 	bleq	142f78 <__bss_end+0x139280>
    2f74:	00001af4 	strdeq	r1, [r0], -r4
    2f78:	1b2e0b05 	blne	b85b94 <__bss_end+0xb7be9c>
    2f7c:	0b050000 	bleq	142f84 <__bss_end+0x13928c>
    2f80:	00001a58 	andeq	r1, r0, r8, asr sl
    2f84:	15c50b05 	strbne	r0, [r5, #2821]	; 0xb05
    2f88:	0b050000 	bleq	142f90 <__bss_end+0x139298>
    2f8c:	0000150e 	andeq	r1, r0, lr, lsl #10
    2f90:	1c9d0b06 	vldmiane	sp, {d0-d2}
    2f94:	0b060000 	bleq	182f9c <__bss_end+0x1792a4>
    2f98:	00001718 	andeq	r1, r0, r8, lsl r7
    2f9c:	1fb20b06 	svcne	0x00b20b06
    2fa0:	0b060000 	bleq	182fa8 <__bss_end+0x1792b0>
    2fa4:	0000224c 	andeq	r2, r0, ip, asr #4
    2fa8:	1cd10b06 	vldmiane	r1, {d16-d18}
    2fac:	0b060000 	bleq	182fb4 <__bss_end+0x1792bc>
    2fb0:	00001d30 	andeq	r1, r0, r0, lsr sp
    2fb4:	151a0b06 	ldrne	r0, [sl, #-2822]	; 0xfffff4fa
    2fb8:	0b070000 	bleq	1c2fc0 <__bss_end+0x1b92c8>
    2fbc:	00001e4b 	andeq	r1, r0, fp, asr #28
    2fc0:	1eb00b07 	vmovne.f64	d0, #7	; 0x40380000  2.875
    2fc4:	0b070000 	bleq	1c2fcc <__bss_end+0x1b92d4>
    2fc8:	00002296 	muleq	r0, r6, r2
    2fcc:	16eb0b07 	strbtne	r0, [fp], r7, lsl #22
    2fd0:	0b070000 	bleq	1c2fd8 <__bss_end+0x1b92e0>
    2fd4:	00001f2b 	andeq	r1, r0, fp, lsr #30
    2fd8:	147b0b08 	ldrbtne	r0, [fp], #-2824	; 0xfffff4f8
    2fdc:	0b080000 	bleq	202fe4 <__bss_end+0x1f92ec>
    2fe0:	0000225a 	andeq	r2, r0, sl, asr r2
    2fe4:	1f4c0b08 	svcne	0x004c0b08
    2fe8:	00080000 	andeq	r0, r8, r0
    2fec:	0025e50f 	eoreq	lr, r5, pc, lsl #10
    2ff0:	01920600 	orrseq	r0, r2, r0, lsl #12
    2ff4:	0006671f 	andeq	r6, r6, pc, lsl r7
    2ff8:	19f40f00 	ldmibne	r4!, {r8, r9, sl, fp}^
    2ffc:	95060000 	strls	r0, [r6, #-0]
    3000:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    3004:	7e0f0000 	cdpvc	0, 0, cr0, cr15, cr0, {0}
    3008:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
    300c:	2c0c0198 	stfcss	f0, [ip], {152}	; 0x98
    3010:	0f000000 	svceq	0x00000000
    3014:	00001b3b 	andeq	r1, r0, fp, lsr fp
    3018:	0c019b06 			; <UNDEFINED> instruction: 0x0c019b06
    301c:	0000002c 	andeq	r0, r0, ip, lsr #32
    3020:	001f880f 	andseq	r8, pc, pc, lsl #16
    3024:	019e0600 	orrseq	r0, lr, r0, lsl #12
    3028:	00002c0c 	andeq	r2, r0, ip, lsl #24
    302c:	1c7e0f00 	ldclne	15, cr0, [lr], #-0
    3030:	a1060000 	mrsge	r0, (UNDEF: 6)
    3034:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    3038:	d20f0000 	andle	r0, pc, #0
    303c:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
    3040:	2c0c01a4 	stfcss	f0, [ip], {164}	; 0xa4
    3044:	0f000000 	svceq	0x00000000
    3048:	00001e8e 	andeq	r1, r0, lr, lsl #29
    304c:	0c01a706 	stceq	7, cr10, [r1], {6}
    3050:	0000002c 	andeq	r0, r0, ip, lsr #32
    3054:	001e990f 	andseq	r9, lr, pc, lsl #18
    3058:	01aa0600 			; <UNDEFINED> instruction: 0x01aa0600
    305c:	00002c0c 	andeq	r2, r0, ip, lsl #24
    3060:	1f920f00 	svcne	0x00920f00
    3064:	ad060000 	stcge	0, cr0, [r6, #-0]
    3068:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    306c:	700f0000 	andvc	r0, pc, r0
    3070:	0600001c 			; <UNDEFINED> instruction: 0x0600001c
    3074:	2c0c01b0 	stfcss	f0, [ip], {176}	; 0xb0
    3078:	0f000000 	svceq	0x00000000
    307c:	00002627 	andeq	r2, r0, r7, lsr #12
    3080:	0c01b306 	stceq	3, cr11, [r1], {6}
    3084:	0000002c 	andeq	r0, r0, ip, lsr #32
    3088:	001f9c0f 	andseq	r9, pc, pc, lsl #24
    308c:	01b60600 			; <UNDEFINED> instruction: 0x01b60600
    3090:	00002c0c 	andeq	r2, r0, ip, lsl #24
    3094:	27040f00 	strcs	r0, [r4, -r0, lsl #30]
    3098:	b9060000 	stmdblt	r6, {}	; <UNPREDICTABLE>
    309c:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    30a0:	b20f0000 	andlt	r0, pc, #0
    30a4:	06000025 	streq	r0, [r0], -r5, lsr #32
    30a8:	2c0c01bc 	stfcss	f0, [ip], {188}	; 0xbc
    30ac:	0f000000 	svceq	0x00000000
    30b0:	000025d7 	ldrdeq	r2, [r0], -r7
    30b4:	0c01c006 	stceq	0, cr12, [r1], {6}
    30b8:	0000002c 	andeq	r0, r0, ip, lsr #32
    30bc:	0026f70f 	eoreq	pc, r6, pc, lsl #14
    30c0:	01c30600 	biceq	r0, r3, r0, lsl #12
    30c4:	00002c0c 	andeq	r2, r0, ip, lsl #24
    30c8:	16350f00 	ldrtne	r0, [r5], -r0, lsl #30
    30cc:	c6060000 	strgt	r0, [r6], -r0
    30d0:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    30d4:	0c0f0000 	stceq	0, cr0, [pc], {-0}
    30d8:	06000014 			; <UNDEFINED> instruction: 0x06000014
    30dc:	2c0c01c9 	stfcss	f0, [ip], {201}	; 0xc9
    30e0:	0f000000 	svceq	0x00000000
    30e4:	000018e0 	andeq	r1, r0, r0, ror #17
    30e8:	0c01cc06 	stceq	12, cr12, [r1], {6}
    30ec:	0000002c 	andeq	r0, r0, ip, lsr #32
    30f0:	0016100f 	andseq	r1, r6, pc
    30f4:	01cf0600 	biceq	r0, pc, r0, lsl #12
    30f8:	00002c0c 	andeq	r2, r0, ip, lsl #24
    30fc:	1fdc0f00 	svcne	0x00dc0f00
    3100:	d2060000 	andle	r0, r6, #0
    3104:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    3108:	630f0000 	movwvs	r0, #61440	; 0xf000
    310c:	0600001b 			; <UNDEFINED> instruction: 0x0600001b
    3110:	2c0c01d5 	stfcss	f0, [ip], {213}	; 0xd5
    3114:	0f000000 	svceq	0x00000000
    3118:	00001dfb 	strdeq	r1, [r0], -fp
    311c:	0c01d806 	stceq	8, cr13, [r1], {6}
    3120:	0000002c 	andeq	r0, r0, ip, lsr #32
    3124:	0023e20f 	eoreq	lr, r3, pc, lsl #4
    3128:	01df0600 	bicseq	r0, pc, r0, lsl #12
    312c:	00002c0c 	andeq	r2, r0, ip, lsl #24
    3130:	26960f00 	ldrcs	r0, [r6], r0, lsl #30
    3134:	e2060000 	and	r0, r6, #0
    3138:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    313c:	a60f0000 	strge	r0, [pc], -r0
    3140:	06000026 	streq	r0, [r0], -r6, lsr #32
    3144:	2c0c01e5 	stfcss	f0, [ip], {229}	; 0xe5
    3148:	0f000000 	svceq	0x00000000
    314c:	0000172f 	andeq	r1, r0, pc, lsr #14
    3150:	0c01e806 	stceq	8, cr14, [r1], {6}
    3154:	0000002c 	andeq	r0, r0, ip, lsr #32
    3158:	0024290f 	eoreq	r2, r4, pc, lsl #18
    315c:	01eb0600 	mvneq	r0, r0, lsl #12
    3160:	00002c0c 	andeq	r2, r0, ip, lsl #24
    3164:	1f130f00 	svcne	0x00130f00
    3168:	ee060000 	cdp	0, 0, cr0, cr6, cr0, {0}
    316c:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    3170:	590f0000 	stmdbpl	pc, {}	; <UNPREDICTABLE>
    3174:	06000019 			; <UNDEFINED> instruction: 0x06000019
    3178:	2c0c01f2 	stfcss	f0, [ip], {242}	; 0xf2
    317c:	0f000000 	svceq	0x00000000
    3180:	000021ce 	andeq	r2, r0, lr, asr #3
    3184:	0c01fa06 			; <UNDEFINED> instruction: 0x0c01fa06
    3188:	0000002c 	andeq	r0, r0, ip, lsr #32
    318c:	0018120f 	andseq	r1, r8, pc, lsl #4
    3190:	01fd0600 	mvnseq	r0, r0, lsl #12
    3194:	00002c0c 	andeq	r2, r0, ip, lsl #24
    3198:	002c0c00 	eoreq	r0, ip, r0, lsl #24
    319c:	08d50000 	ldmeq	r5, {}^	; <UNPREDICTABLE>
    31a0:	000d0000 	andeq	r0, sp, r0
    31a4:	001a430f 	andseq	r4, sl, pc, lsl #6
    31a8:	03eb0600 	mvneq	r0, #0, 12
    31ac:	0008ca0c 	andeq	ip, r8, ip, lsl #20
    31b0:	05cd0c00 	strbeq	r0, [sp, #3072]	; 0xc00
    31b4:	08f20000 	ldmeq	r2!, {}^	; <UNPREDICTABLE>
    31b8:	33150000 	tstcc	r5, #0
    31bc:	0d000000 	stceq	0, cr0, [r0, #-0]
    31c0:	20120f00 	andscs	r0, r2, r0, lsl #30
    31c4:	74060000 	strvc	r0, [r6], #-0
    31c8:	08e21405 	stmiaeq	r2!, {r0, r2, sl, ip}^
    31cc:	26160000 	ldrcs	r0, [r6], -r0
    31d0:	0700001b 	smladeq	r0, fp, r0, r0
    31d4:	0000a201 	andeq	sl, r0, r1, lsl #4
    31d8:	057b0600 	ldrbeq	r0, [fp, #-1536]!	; 0xfffffa00
    31dc:	00093d06 	andeq	r3, r9, r6, lsl #26
    31e0:	18a20b00 	stmiane	r2!, {r8, r9, fp}
    31e4:	0b000000 	bleq	31ec <shift+0x31ec>
    31e8:	00001d5b 	andeq	r1, r0, fp, asr sp
    31ec:	14b10b01 	ldrtne	r0, [r1], #2817	; 0xb01
    31f0:	0b020000 	bleq	831f8 <__bss_end+0x79500>
    31f4:	00002658 	andeq	r2, r0, r8, asr r6
    31f8:	209e0b03 	addscs	r0, lr, r3, lsl #22
    31fc:	0b040000 	bleq	103204 <__bss_end+0xf950c>
    3200:	00002091 	muleq	r0, r1, r0
    3204:	15a40b05 	strne	r0, [r4, #2821]!	; 0xb05
    3208:	00060000 	andeq	r0, r6, r0
    320c:	0026480f 	eoreq	r4, r6, pc, lsl #16
    3210:	05880600 	streq	r0, [r8, #1536]	; 0x600
    3214:	0008ff15 	andeq	pc, r8, r5, lsl pc	; <UNPREDICTABLE>
    3218:	25240f00 	strcs	r0, [r4, #-3840]!	; 0xfffff100
    321c:	89060000 	stmdbhi	r6, {}	; <UNPREDICTABLE>
    3220:	00331107 	eorseq	r1, r3, r7, lsl #2
    3224:	ff0f0000 			; <UNDEFINED> instruction: 0xff0f0000
    3228:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
    322c:	2c0c079e 	stccs	7, cr0, [ip], {158}	; 0x9e
    3230:	04000000 	streq	r0, [r0], #-0
    3234:	000023d1 	ldrdeq	r2, [r0], -r1
    3238:	a2167b07 	andsge	r7, r6, #7168	; 0x1c00
    323c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    3240:	00000964 	andeq	r0, r0, r4, ror #18
    3244:	52050202 	andpl	r0, r5, #536870912	; 0x20000000
    3248:	04000004 	streq	r0, [r0], #-4
    324c:	0000273d 	andeq	r2, r0, sp, lsr r7
    3250:	3a0f8407 	bcc	3e4274 <__bss_end+0x3da57c>
    3254:	02000000 	andeq	r0, r0, #0
    3258:	17fb0708 	ldrbne	r0, [fp, r8, lsl #14]!
    325c:	2b040000 	blcs	103264 <__bss_end+0xf956c>
    3260:	07000027 	streq	r0, [r0, -r7, lsr #32]
    3264:	00251093 	mlaeq	r5, r3, r0, r1
    3268:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    326c:	00164803 	andseq	r4, r6, r3, lsl #16
    3270:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    3274:	00001fab 	andeq	r1, r0, fp, lsr #31
    3278:	e6031002 	str	r1, [r3], -r2
    327c:	0c000020 	stceq	0, cr0, [r0], {32}
    3280:	00000970 	andeq	r0, r0, r0, ror r9
    3284:	000009c0 	andeq	r0, r0, r0, asr #19
    3288:	00003315 	andeq	r3, r0, r5, lsl r3
    328c:	0e00ff00 	cdpeq	15, 0, cr15, cr0, cr0, {0}
    3290:	000009b0 			; <UNDEFINED> instruction: 0x000009b0
    3294:	001ebd0f 	andseq	fp, lr, pc, lsl #26
    3298:	01fc0700 	mvnseq	r0, r0, lsl #14
    329c:	0009c016 	andeq	ip, r9, r6, lsl r0
    32a0:	15ff0f00 	ldrbne	r0, [pc, #3840]!	; 41a8 <shift+0x41a8>
    32a4:	02070000 	andeq	r0, r7, #0
    32a8:	09c01602 	stmibeq	r0, {r1, r9, sl, ip}^
    32ac:	32170000 	andscc	r0, r7, #0
    32b0:	01000027 	tsteq	r0, r7, lsr #32
    32b4:	7c0105f9 	cfstr32vc	mvfx0, [r1], {249}	; 0xf9
    32b8:	d0000009 	andle	r0, r0, r9
    32bc:	2c00009a 	stccs	0, cr0, [r0], {154}	; 0x9a
    32c0:	01000000 	mrseq	r0, (UNDEF: 0)
    32c4:	000a399c 	muleq	sl, ip, r9
    32c8:	00611800 	rsbeq	r1, r1, r0, lsl #16
    32cc:	1305f901 	movwne	pc, #22785	; 0x5901	; <UNPREDICTABLE>
    32d0:	0000098f 	andeq	r0, r0, pc, lsl #19
    32d4:	0000000a 	andeq	r0, r0, sl
    32d8:	00000000 	andeq	r0, r0, r0
    32dc:	009ae419 	addseq	lr, sl, r9, lsl r4
    32e0:	000a3900 	andeq	r3, sl, r0, lsl #18
    32e4:	000a2400 	andeq	r2, sl, r0, lsl #8
    32e8:	50011a00 	andpl	r1, r1, r0, lsl #20
    32ec:	f503f305 			; <UNDEFINED> instruction: 0xf503f305
    32f0:	1b002500 	blne	c6f8 <__bss_end+0x2a00>
    32f4:	00009af0 	strdeq	r9, [r0], -r0
    32f8:	00000a39 	andeq	r0, r0, r9, lsr sl
    32fc:	0650011a 			; <UNDEFINED> instruction: 0x0650011a
    3300:	00f503f3 	ldrshteq	r0, [r5], #51	; 0x33
    3304:	00001f25 	andeq	r1, r0, r5, lsr #30
    3308:	00271d1c 	eoreq	r1, r7, ip, lsl sp
    330c:	00271000 	eoreq	r1, r7, r0
    3310:	033b0100 	teqeq	fp, #0, 2
    3314:	000a6600 	andeq	r6, sl, r0, lsl #12
    3318:	e2000400 	and	r0, r0, #0, 8
    331c:	0400000a 	streq	r0, [r0], #-10
    3320:	00245f01 	eoreq	r5, r4, r1, lsl #30
    3324:	16a10c00 	strtne	r0, [r1], r0, lsl #24
    3328:	12fd0000 	rscsne	r0, sp, #0
    332c:	9b000000 	blls	3334 <shift+0x3334>
    3330:	00400000 	subeq	r0, r0, r0
    3334:	101f0000 	andsne	r0, pc, r0
    3338:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    333c:	001fab04 	andseq	sl, pc, r4, lsl #22
    3340:	07040200 	streq	r0, [r4, -r0, lsl #4]
    3344:	00001805 	andeq	r1, r0, r5, lsl #16
    3348:	50040402 	andpl	r0, r4, r2, lsl #8
    334c:	03000016 	movweq	r0, #22
    3350:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    3354:	08020074 	stmdaeq	r2, {r2, r4, r5, r6}
    3358:	00037f05 	andeq	r7, r3, r5, lsl #30
    335c:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    3360:	00001fa6 	andeq	r1, r0, r6, lsr #31
    3364:	00170e04 	andseq	r0, r7, r4, lsl #28
    3368:	162a0200 	strtne	r0, [sl], -r0, lsl #4
    336c:	0000002c 	andeq	r0, r0, ip, lsr #32
    3370:	001b7104 	andseq	r7, fp, r4, lsl #2
    3374:	152f0200 	strne	r0, [pc, #-512]!	; 317c <shift+0x317c>
    3378:	00000067 	andeq	r0, r0, r7, rrx
    337c:	006d0405 	rsbeq	r0, sp, r5, lsl #8
    3380:	4f060000 	svcmi	0x00060000
    3384:	7c000000 	stcvc	0, cr0, [r0], {-0}
    3388:	07000000 	streq	r0, [r0, -r0]
    338c:	0000007c 	andeq	r0, r0, ip, ror r0
    3390:	82040500 	andhi	r0, r4, #0, 10
    3394:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    3398:	00241004 	eoreq	r1, r4, r4
    339c:	0f360200 	svceq	0x00360200
    33a0:	0000008f 	andeq	r0, r0, pc, lsl #1
    33a4:	00950405 	addseq	r0, r5, r5, lsl #8
    33a8:	3a060000 	bcc	1833b0 <__bss_end+0x1796b8>
    33ac:	a9000000 	stmdbge	r0, {}	; <UNPREDICTABLE>
    33b0:	07000000 	streq	r0, [r0, -r0]
    33b4:	0000007c 	andeq	r0, r0, ip, ror r0
    33b8:	00007c07 	andeq	r7, r0, r7, lsl #24
    33bc:	01020000 	mrseq	r0, (UNDEF: 2)
    33c0:	00074a08 	andeq	r4, r7, r8, lsl #20
    33c4:	1dd40900 	vldrne.16	s1, [r4]	; <UNPREDICTABLE>
    33c8:	bb020000 	bllt	833d0 <__bss_end+0x796d8>
    33cc:	00005b12 	andeq	r5, r0, r2, lsl fp
    33d0:	243e0900 	ldrtcs	r0, [lr], #-2304	; 0xfffff700
    33d4:	be020000 	cdplt	0, 0, cr0, cr2, cr0, {0}
    33d8:	00008310 	andeq	r8, r0, r0, lsl r3
    33dc:	06010200 	streq	r0, [r1], -r0, lsl #4
    33e0:	0000074c 	andeq	r0, r0, ip, asr #14
    33e4:	001a780a 	andseq	r7, sl, sl, lsl #16
    33e8:	a9010700 	stmdbge	r1, {r8, r9, sl}
    33ec:	03000000 	movweq	r0, #0
    33f0:	01fc0617 	mvnseq	r0, r7, lsl r6
    33f4:	750b0000 	strvc	r0, [fp, #-0]
    33f8:	00000015 	andeq	r0, r0, r5, lsl r0
    33fc:	0019700b 	andseq	r7, r9, fp
    3400:	cc0b0100 	stfgts	f0, [fp], {-0}
    3404:	0200001e 	andeq	r0, r0, #30
    3408:	0023540b 	eoreq	r5, r3, fp, lsl #8
    340c:	580b0300 	stmdapl	fp, {r8, r9}
    3410:	0400001e 	streq	r0, [r0], #-30	; 0xffffffe2
    3414:	00221b0b 	eoreq	r1, r2, fp, lsl #22
    3418:	410b0500 	tstmi	fp, r0, lsl #10
    341c:	06000021 	streq	r0, [r0], -r1, lsr #32
    3420:	0015960b 	andseq	r9, r5, fp, lsl #12
    3424:	300b0700 	andcc	r0, fp, r0, lsl #14
    3428:	08000022 	stmdaeq	r0, {r1, r5}
    342c:	00223e0b 	eoreq	r3, r2, fp, lsl #28
    3430:	2f0b0900 	svccs	0x000b0900
    3434:	0a000023 	beq	34c8 <shift+0x34c8>
    3438:	001d9a0b 	andseq	r9, sp, fp, lsl #20
    343c:	4f0b0b00 	svcmi	0x000b0b00
    3440:	0c000017 	stceq	0, cr0, [r0], {23}
    3444:	001b010b 	andseq	r0, fp, fp, lsl #2
    3448:	870b0d00 	strhi	r0, [fp, -r0, lsl #26]
    344c:	0e000022 	cdpeq	0, 0, cr0, cr0, cr2, {1}
    3450:	001abc0b 	andseq	fp, sl, fp, lsl #24
    3454:	d20b0f00 	andle	r0, fp, #0, 30
    3458:	1000001a 	andne	r0, r0, sl, lsl r0
    345c:	0019a70b 	andseq	sl, r9, fp, lsl #14
    3460:	3c0b1100 	stfccs	f1, [fp], {-0}
    3464:	1200001e 	andne	r0, r0, #30
    3468:	001a340b 	andseq	r3, sl, fp, lsl #8
    346c:	ec0b1300 	stc	3, cr1, [fp], {-0}
    3470:	14000026 	strne	r0, [r0], #-38	; 0xffffffda
    3474:	001f040b 	andseq	r0, pc, fp, lsl #8
    3478:	610b1500 	tstvs	fp, r0, lsl #10
    347c:	1600001c 			; <UNDEFINED> instruction: 0x1600001c
    3480:	0015f30b 	andseq	pc, r5, fp, lsl #6
    3484:	770b1700 	strvc	r1, [fp, -r0, lsl #14]
    3488:	18000023 	stmdane	r0, {r0, r1, r5}
    348c:	0025810b 	eoreq	r8, r5, fp, lsl #2
    3490:	850b1900 	strhi	r1, [fp, #-2304]	; 0xfffff700
    3494:	1a000023 	bne	3528 <shift+0x3528>
    3498:	001a840b 	andseq	r8, sl, fp, lsl #8
    349c:	930b1b00 	movwls	r1, #47872	; 0xbb00
    34a0:	1c000023 	stcne	0, cr0, [r0], {35}	; 0x23
    34a4:	00144f0b 	andseq	r4, r4, fp, lsl #30
    34a8:	a10b1d00 	tstge	fp, r0, lsl #26
    34ac:	1e000023 	cdpne	0, 0, cr0, cr0, cr3, {1}
    34b0:	0023af0b 	eoreq	sl, r3, fp, lsl #30
    34b4:	e80b1f00 	stmda	fp, {r8, r9, sl, fp, ip}
    34b8:	20000013 	andcs	r0, r0, r3, lsl r0
    34bc:	0020270b 	eoreq	r2, r0, fp, lsl #14
    34c0:	0e0b2100 	adfeqe	f2, f3, f0
    34c4:	2200001e 	andcs	r0, r0, #30
    34c8:	00236a0b 	eoreq	r6, r3, fp, lsl #20
    34cc:	de0b2300 	cdple	3, 0, cr2, cr11, cr0, {0}
    34d0:	2400001c 	strcs	r0, [r0], #-28	; 0xffffffe4
    34d4:	0021320b 	eoreq	r3, r1, fp, lsl #4
    34d8:	d40b2500 	strle	r2, [fp], #-1280	; 0xfffffb00
    34dc:	2600001b 			; <UNDEFINED> instruction: 0x2600001b
    34e0:	0018b00b 	andseq	fp, r8, fp
    34e4:	f20b2700 	vabd.s8	d2, d11, d0
    34e8:	2800001b 	stmdacs	r0, {r0, r1, r3, r4}
    34ec:	00194c0b 	andseq	r4, r9, fp, lsl #24
    34f0:	020b2900 	andeq	r2, fp, #0, 18
    34f4:	2a00001c 	bcs	356c <shift+0x356c>
    34f8:	001d800b 	andseq	r8, sp, fp
    34fc:	7b0b2b00 	blvc	2ce104 <__bss_end+0x2c440c>
    3500:	2c00001b 	stccs	0, cr0, [r0], {27}
    3504:	0020460b 	eoreq	r4, r0, fp, lsl #12
    3508:	f10b2d00 			; <UNDEFINED> instruction: 0xf10b2d00
    350c:	2e000018 	mcrcs	0, 0, r0, cr0, cr8, {0}
    3510:	1b0e0a00 	blne	385d18 <__bss_end+0x37c020>
    3514:	01070000 	mrseq	r0, (UNDEF: 7)
    3518:	000000a9 	andeq	r0, r0, r9, lsr #1
    351c:	b5061704 	strlt	r1, [r6, #-1796]	; 0xfffff8fc
    3520:	0b000004 	bleq	3538 <shift+0x3538>
    3524:	00001763 	andeq	r1, r0, r3, ror #14
    3528:	26150b00 	ldrcs	r0, [r5], -r0, lsl #22
    352c:	0b010000 	bleq	43534 <__bss_end+0x3983c>
    3530:	00001773 	andeq	r1, r0, r3, ror r7
    3534:	17960b02 	ldrne	r0, [r6, r2, lsl #22]
    3538:	0b030000 	bleq	c3540 <__bss_end+0xb9848>
    353c:	0000244e 	andeq	r2, r0, lr, asr #8
    3540:	20ac0b04 	adccs	r0, ip, r4, lsl #22
    3544:	0b050000 	bleq	14354c <__bss_end+0x139854>
    3548:	00001820 	andeq	r1, r0, r0, lsr #16
    354c:	19950b06 	ldmibne	r5, {r1, r2, r8, r9, fp}
    3550:	0b070000 	bleq	1c3558 <__bss_end+0x1b9860>
    3554:	000017a6 	andeq	r1, r0, r6, lsr #15
    3558:	26db0b08 	ldrbcs	r0, [fp], r8, lsl #22
    355c:	0b090000 	bleq	243564 <__bss_end+0x23986c>
    3560:	000014c6 	andeq	r1, r0, r6, asr #9
    3564:	26040b0a 	strcs	r0, [r4], -sl, lsl #22
    3568:	0b0b0000 	bleq	2c3570 <__bss_end+0x2b9878>
    356c:	00001ced 	andeq	r1, r0, sp, ror #25
    3570:	25980b0c 	ldrcs	r0, [r8, #2828]	; 0xb0c
    3574:	0b0d0000 	bleq	34357c <__bss_end+0x339884>
    3578:	00002034 	andeq	r2, r0, r4, lsr r0
    357c:	22cd0b0e 	sbccs	r0, sp, #14336	; 0x3800
    3580:	0b0f0000 	bleq	3c3588 <__bss_end+0x3b9890>
    3584:	00001881 	andeq	r1, r0, r1, lsl #17
    3588:	17830b10 	usada8ne	r3, r0, fp, r0
    358c:	0b110000 	bleq	443594 <__bss_end+0x43989c>
    3590:	00001fec 	andeq	r1, r0, ip, ror #31
    3594:	186c0b12 	stmdane	ip!, {r1, r4, r8, r9, fp}^
    3598:	0b130000 	bleq	4c35a0 <__bss_end+0x4b98a8>
    359c:	000025f3 	strdeq	r2, [r0], -r3
    35a0:	14f00b14 	ldrbtne	r0, [r0], #2836	; 0xb14
    35a4:	0b150000 	bleq	5435ac <__bss_end+0x5398b4>
    35a8:	00001c3c 	andeq	r1, r0, ip, lsr ip
    35ac:	17b60b16 			; <UNDEFINED> instruction: 0x17b60b16
    35b0:	0b170000 	bleq	5c35b8 <__bss_end+0x5b98c0>
    35b4:	0000148d 	andeq	r1, r0, sp, lsl #9
    35b8:	26810b18 	pkhbtcs	r0, r1, r8, lsl #22
    35bc:	0b190000 	bleq	6435c4 <__bss_end+0x6398cc>
    35c0:	0000233c 	andeq	r2, r0, ip, lsr r3
    35c4:	21500b1a 	cmpcs	r0, sl, lsl fp
    35c8:	0b1b0000 	bleq	6c35d0 <__bss_end+0x6b98d8>
    35cc:	000022b4 			; <UNDEFINED> instruction: 0x000022b4
    35d0:	24180b1c 	ldrcs	r0, [r8], #-2844	; 0xfffff4e4
    35d4:	0b1d0000 	bleq	7435dc <__bss_end+0x7398e4>
    35d8:	000017d6 	ldrdeq	r1, [r0], -r6
    35dc:	15610b1e 	strbne	r0, [r1, #-2846]!	; 0xfffff4e2
    35e0:	0b1f0000 	bleq	7c35e8 <__bss_end+0x7b98f0>
    35e4:	00002169 	andeq	r2, r0, r9, ror #2
    35e8:	18cd0b20 	stmiane	sp, {r5, r8, r9, fp}^
    35ec:	0b210000 	bleq	8435f4 <__bss_end+0x8398fc>
    35f0:	000020be 	strheq	r2, [r0], -lr
    35f4:	1cbe0b22 	vldmiane	lr!, {d0-d16}
    35f8:	0b230000 	bleq	8c3600 <__bss_end+0x8b9908>
    35fc:	000017c6 	andeq	r1, r0, r6, asr #15
    3600:	226c0b24 	rsbcs	r0, ip, #36, 22	; 0x9000
    3604:	0b250000 	bleq	94360c <__bss_end+0x939914>
    3608:	000016d9 	ldrdeq	r1, [r0], -r9
    360c:	23fd0b26 	mvnscs	r0, #38912	; 0x9800
    3610:	0b270000 	bleq	9c3618 <__bss_end+0x9b9920>
    3614:	000026c8 	andeq	r2, r0, r8, asr #13
    3618:	1fbf0b28 	svcne	0x00bf0b28
    361c:	0b290000 	bleq	a43624 <__bss_end+0xa3992c>
    3620:	00001a66 	andeq	r1, r0, r6, ror #20
    3624:	21930b2a 	orrscs	r0, r3, sl, lsr #22
    3628:	0b2b0000 	bleq	ac3630 <__bss_end+0xab9938>
    362c:	00001d1c 	andeq	r1, r0, ip, lsl sp
    3630:	15b40b2c 	ldrne	r0, [r4, #2860]!	; 0xb2c
    3634:	0b2d0000 	bleq	b4363c <__bss_end+0xb39944>
    3638:	00001538 	andeq	r1, r0, r8, lsr r5
    363c:	25560b2e 	ldrbcs	r0, [r6, #-2862]	; 0xfffff4d2
    3640:	0b2f0000 	bleq	bc3648 <__bss_end+0xbb9950>
    3644:	00001caa 	andeq	r1, r0, sl, lsr #25
    3648:	18460b30 	stmdane	r6, {r4, r5, r8, r9, fp}^
    364c:	0b310000 	bleq	c43654 <__bss_end+0xc3995c>
    3650:	00001c89 	andeq	r1, r0, r9, lsl #25
    3654:	1f380b32 	svcne	0x00380b32
    3658:	0b330000 	bleq	cc3660 <__bss_end+0xcb9968>
    365c:	00001526 	andeq	r1, r0, r6, lsr #10
    3660:	26b60b34 			; <UNDEFINED> instruction: 0x26b60b34
    3664:	0b350000 	bleq	d4366c <__bss_end+0xd39974>
    3668:	00001d6d 	andeq	r1, r0, sp, ror #26
    366c:	19ff0b36 	ldmibne	pc!, {r1, r2, r4, r5, r8, r9, fp}^	; <UNPREDICTABLE>
    3670:	0b370000 	bleq	dc3678 <__bss_end+0xdb9980>
    3674:	00001daa 	andeq	r1, r0, sl, lsr #27
    3678:	25be0b38 	ldrcs	r0, [lr, #2872]!	; 0xb38
    367c:	0b390000 	bleq	e43684 <__bss_end+0xe3998c>
    3680:	0000166b 	andeq	r1, r0, fp, ror #12
    3684:	1a120b3a 	bne	486374 <__bss_end+0x47c67c>
    3688:	0b3b0000 	bleq	ec3690 <__bss_end+0xeb9998>
    368c:	000019de 	ldrdeq	r1, [r0], -lr
    3690:	13f70b3c 	mvnsne	r0, #60, 22	; 0xf000
    3694:	0b3d0000 	bleq	f4369c <__bss_end+0xf399a4>
    3698:	00001cff 	strdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    369c:	1ade0b3e 	bne	ff78639c <__bss_end+0xff77c6a4>
    36a0:	0b3f0000 	bleq	fc36a8 <__bss_end+0xfb99b0>
    36a4:	0000157f 	andeq	r1, r0, pc, ror r5
    36a8:	256a0b40 	strbcs	r0, [sl, #-2880]!	; 0xfffff4c0
    36ac:	0b410000 	bleq	10436b4 <__bss_end+0x10399bc>
    36b0:	00001c4f 	andeq	r1, r0, pc, asr #24
    36b4:	19c80b42 	stmibne	r8, {r1, r6, r8, r9, fp}^
    36b8:	0b430000 	bleq	10c36c0 <__bss_end+0x10b99c8>
    36bc:	00001438 	andeq	r1, r0, r8, lsr r4
    36c0:	1bac0b44 	blne	feb063d8 <__bss_end+0xfeafc6e0>
    36c4:	0b450000 	bleq	11436cc <__bss_end+0x11399d4>
    36c8:	00001b98 	muleq	r0, r8, fp
    36cc:	21130b46 	tstcs	r3, r6, asr #22
    36d0:	0b470000 	bleq	11c36d8 <__bss_end+0x11b99e0>
    36d4:	000021db 	ldrdeq	r2, [r0], -fp
    36d8:	25350b48 	ldrcs	r0, [r5, #-2888]!	; 0xfffff4b8
    36dc:	0b490000 	bleq	12436e4 <__bss_end+0x12399ec>
    36e0:	000018fe 	strdeq	r1, [r0], -lr
    36e4:	1eee0b4a 	vfmsne.f64	d16, d14, d10
    36e8:	0b4b0000 	bleq	12c36f0 <__bss_end+0x12b99f8>
    36ec:	000021a8 	andeq	r2, r0, r8, lsr #3
    36f0:	20550b4c 	subscs	r0, r5, ip, asr #22
    36f4:	0b4d0000 	bleq	13436fc <__bss_end+0x1339a04>
    36f8:	00002069 	andeq	r2, r0, r9, rrx
    36fc:	207d0b4e 	rsbscs	r0, sp, lr, asr #22
    3700:	0b4f0000 	bleq	13c3708 <__bss_end+0x13b9a10>
    3704:	000016f9 	strdeq	r1, [r0], -r9
    3708:	16560b50 			; <UNDEFINED> instruction: 0x16560b50
    370c:	0b510000 	bleq	1443714 <__bss_end+0x1439a1c>
    3710:	0000167e 	andeq	r1, r0, lr, ror r6
    3714:	22df0b52 	sbcscs	r0, pc, #83968	; 0x14800
    3718:	0b530000 	bleq	14c3720 <__bss_end+0x14b9a28>
    371c:	000016c4 	andeq	r1, r0, r4, asr #13
    3720:	22f30b54 	rscscs	r0, r3, #84, 22	; 0x15000
    3724:	0b550000 	bleq	154372c <__bss_end+0x1539a34>
    3728:	00002307 	andeq	r2, r0, r7, lsl #6
    372c:	231b0b56 	tstcs	fp, #88064	; 0x15800
    3730:	0b570000 	bleq	15c3738 <__bss_end+0x15b9a40>
    3734:	00001858 	andeq	r1, r0, r8, asr r8
    3738:	18320b58 	ldmdane	r2!, {r3, r4, r6, r8, r9, fp}
    373c:	0b590000 	bleq	1643744 <__bss_end+0x1639a4c>
    3740:	00001bc0 	andeq	r1, r0, r0, asr #23
    3744:	1dbd0b5a 			; <UNDEFINED> instruction: 0x1dbd0b5a
    3748:	0b5b0000 	bleq	16c3750 <__bss_end+0x16b9a58>
    374c:	00001b46 	andeq	r1, r0, r6, asr #22
    3750:	13cb0b5c 	bicne	r0, fp, #92, 22	; 0x17000
    3754:	0b5d0000 	bleq	174375c <__bss_end+0x1739a64>
    3758:	00001980 	andeq	r1, r0, r0, lsl #19
    375c:	1de60b5e 			; <UNDEFINED> instruction: 0x1de60b5e
    3760:	0b5f0000 	bleq	17c3768 <__bss_end+0x17b9a70>
    3764:	00001c12 	andeq	r1, r0, r2, lsl ip
    3768:	20d10b60 	sbcscs	r0, r1, r0, ror #22
    376c:	0b610000 	bleq	1843774 <__bss_end+0x1839a7c>
    3770:	00002633 	andeq	r2, r0, r3, lsr r6
    3774:	1ed90b62 	vfnmane.f64	d16, d9, d18
    3778:	0b630000 	bleq	18c3780 <__bss_end+0x18b9a88>
    377c:	00001923 	andeq	r1, r0, r3, lsr #18
    3780:	149f0b64 	ldrne	r0, [pc], #2916	; 3788 <shift+0x3788>
    3784:	0b650000 	bleq	194378c <__bss_end+0x1939a94>
    3788:	0000145d 	andeq	r1, r0, sp, asr r4
    378c:	1e1e0b66 	vnmlane.f64	d0, d14, d22
    3790:	0b670000 	bleq	19c3798 <__bss_end+0x19b9aa0>
    3794:	00001f59 	andeq	r1, r0, r9, asr pc
    3798:	20f50b68 	rscscs	r0, r5, r8, ror #22
    379c:	0b690000 	bleq	1a437a4 <__bss_end+0x1a39aac>
    37a0:	00001c27 	andeq	r1, r0, r7, lsr #24
    37a4:	266c0b6a 	strbtcs	r0, [ip], -sl, ror #22
    37a8:	0b6b0000 	bleq	1ac37b0 <__bss_end+0x1ab9ab8>
    37ac:	00001d3d 	andeq	r1, r0, sp, lsr sp
    37b0:	141c0b6c 	ldrne	r0, [ip], #-2924	; 0xfffff494
    37b4:	0b6d0000 	bleq	1b437bc <__bss_end+0x1b39ac4>
    37b8:	0000154c 	andeq	r1, r0, ip, asr #10
    37bc:	19370b6e 	ldmdbne	r7!, {r1, r2, r3, r5, r6, r8, r9, fp}
    37c0:	0b6f0000 	bleq	1bc37c8 <__bss_end+0x1bb9ad0>
    37c4:	000017e7 	andeq	r1, r0, r7, ror #15
    37c8:	02020070 	andeq	r0, r2, #112	; 0x70
    37cc:	00085407 	andeq	r5, r8, r7, lsl #8
    37d0:	04d20c00 	ldrbeq	r0, [r2], #3072	; 0xc00
    37d4:	04c70000 	strbeq	r0, [r7], #0
    37d8:	000d0000 	andeq	r0, sp, r0
    37dc:	0004bc0e 	andeq	fp, r4, lr, lsl #24
    37e0:	de040500 	cfsh32le	mvfx0, mvfx4, #0
    37e4:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
    37e8:	000004cc 	andeq	r0, r0, ip, asr #9
    37ec:	53080102 	movwpl	r0, #33026	; 0x8102
    37f0:	0e000007 	cdpeq	0, 0, cr0, cr0, cr7, {0}
    37f4:	000004d7 	ldrdeq	r0, [r0], -r7
    37f8:	0015e40f 	andseq	lr, r5, pc, lsl #8
    37fc:	01440500 	cmpeq	r4, r0, lsl #10
    3800:	0004c71a 	andeq	ip, r4, sl, lsl r7
    3804:	19b80f00 	ldmibne	r8!, {r8, r9, sl, fp}
    3808:	79050000 	stmdbvc	r5, {}	; <UNPREDICTABLE>
    380c:	04c71a01 	strbeq	r1, [r7], #2561	; 0xa01
    3810:	d70c0000 	strle	r0, [ip, -r0]
    3814:	08000004 	stmdaeq	r0, {r2}
    3818:	0d000005 	stceq	0, cr0, [r0, #-20]	; 0xffffffec
    381c:	1be40900 	blne	ff905c24 <__bss_end+0xff8fbf2c>
    3820:	2d060000 	stccs	0, cr0, [r6, #-0]
    3824:	0004fd0d 	andeq	pc, r4, sp, lsl #26
    3828:	23d90900 	bicscs	r0, r9, #0, 18
    382c:	35060000 	strcc	r0, [r6, #-0]
    3830:	0001fc1c 	andeq	pc, r1, ip, lsl ip	; <UNPREDICTABLE>
    3834:	18940a00 	ldmne	r4, {r9, fp}
    3838:	01070000 	mrseq	r0, (UNDEF: 7)
    383c:	000000a9 	andeq	r0, r0, r9, lsr #1
    3840:	930e3706 	movwls	r3, #59142	; 0xe706
    3844:	0b000005 	bleq	3860 <shift+0x3860>
    3848:	00001431 	andeq	r1, r0, r1, lsr r4
    384c:	1acb0b00 	bne	ff2c6454 <__bss_end+0xff2bc75c>
    3850:	0b010000 	bleq	43858 <__bss_end+0x39b60>
    3854:	000025d0 	ldrdeq	r2, [r0], -r0
    3858:	25ab0b02 	strcs	r0, [fp, #2818]!	; 0xb02
    385c:	0b030000 	bleq	c3864 <__bss_end+0xb9b6c>
    3860:	00001e87 	andeq	r1, r0, r7, lsl #29
    3864:	22290b04 	eorcs	r0, r9, #4, 22	; 0x1000
    3868:	0b050000 	bleq	143870 <__bss_end+0x139b78>
    386c:	00001627 	andeq	r1, r0, r7, lsr #12
    3870:	16090b06 	strne	r0, [r9], -r6, lsl #22
    3874:	0b070000 	bleq	1c387c <__bss_end+0x1b9b84>
    3878:	0000175c 	andeq	r1, r0, ip, asr r7
    387c:	1d150b08 	vldrne	d0, [r5, #-32]	; 0xffffffe0
    3880:	0b090000 	bleq	243888 <__bss_end+0x239b90>
    3884:	0000162e 	andeq	r1, r0, lr, lsr #12
    3888:	169a0b0a 	ldrne	r0, [sl], sl, lsl #22
    388c:	0b0b0000 	bleq	2c3894 <__bss_end+0x2b9b9c>
    3890:	00001693 	muleq	r0, r3, r6
    3894:	16200b0c 	strtne	r0, [r0], -ip, lsl #22
    3898:	0b0d0000 	bleq	3438a0 <__bss_end+0x339ba8>
    389c:	00002280 	andeq	r2, r0, r0, lsl #5
    38a0:	1f770b0e 	svcne	0x00770b0e
    38a4:	000f0000 	andeq	r0, pc, r0
    38a8:	00212b04 	eoreq	r2, r1, r4, lsl #22
    38ac:	013c0600 	teqeq	ip, r0, lsl #12
    38b0:	00000520 	andeq	r0, r0, r0, lsr #10
    38b4:	0021fc09 	eoreq	pc, r1, r9, lsl #24
    38b8:	0f3e0600 	svceq	0x003e0600
    38bc:	00000593 	muleq	r0, r3, r5
    38c0:	0022a309 	eoreq	sl, r2, r9, lsl #6
    38c4:	0c470600 	mcrreq	6, 0, r0, r7, cr0
    38c8:	0000003a 	andeq	r0, r0, sl, lsr r0
    38cc:	0015d409 	andseq	sp, r5, r9, lsl #8
    38d0:	0c480600 	mcrreq	6, 0, r0, r8, cr0
    38d4:	0000003a 	andeq	r0, r0, sl, lsr r0
    38d8:	0023bd10 	eoreq	fp, r3, r0, lsl sp
    38dc:	220b0900 	andcs	r0, fp, #0, 18
    38e0:	49060000 	stmdbmi	r6, {}	; <UNPREDICTABLE>
    38e4:	0005d414 	andeq	sp, r5, r4, lsl r4
    38e8:	c3040500 	movwgt	r0, #17664	; 0x4500
    38ec:	11000005 	tstne	r0, r5
    38f0:	001a9509 	andseq	r9, sl, r9, lsl #10
    38f4:	0f4b0600 	svceq	0x004b0600
    38f8:	000005e7 	andeq	r0, r0, r7, ror #11
    38fc:	05da0405 	ldrbeq	r0, [sl, #1029]	; 0x405
    3900:	7e120000 	cdpvc	0, 1, cr0, cr2, cr0, {0}
    3904:	09000021 	stmdbeq	r0, {r0, r5}
    3908:	00001e74 	andeq	r1, r0, r4, ror lr
    390c:	fe0d4f06 	cdp2	15, 0, cr4, cr13, cr6, {0}
    3910:	05000005 	streq	r0, [r0, #-5]
    3914:	0005ed04 	andeq	lr, r5, r4, lsl #26
    3918:	17421300 	strbne	r1, [r2, -r0, lsl #6]
    391c:	06340000 	ldrteq	r0, [r4], -r0
    3920:	2f150158 	svccs	0x00150158
    3924:	14000006 	strne	r0, [r0], #-6
    3928:	00001bed 	andeq	r1, r0, sp, ror #23
    392c:	0f015a06 	svceq	0x00015a06
    3930:	000004cc 	andeq	r0, r0, ip, asr #9
    3934:	17261400 	strne	r1, [r6, -r0, lsl #8]!
    3938:	5b060000 	blpl	183940 <__bss_end+0x179c48>
    393c:	06341401 	ldrteq	r1, [r4], -r1, lsl #8
    3940:	00040000 	andeq	r0, r4, r0
    3944:	0006040e 	andeq	r0, r6, lr, lsl #8
    3948:	00cf0c00 	sbceq	r0, pc, r0, lsl #24
    394c:	06440000 	strbeq	r0, [r4], -r0
    3950:	2c150000 	ldccs	0, cr0, [r5], {-0}
    3954:	2d000000 	stccs	0, cr0, [r0, #-0]
    3958:	062f0c00 	strteq	r0, [pc], -r0, lsl #24
    395c:	064f0000 	strbeq	r0, [pc], -r0
    3960:	000d0000 	andeq	r0, sp, r0
    3964:	0006440e 	andeq	r4, r6, lr, lsl #8
    3968:	1b1d0f00 	blne	747570 <__bss_end+0x73d878>
    396c:	5c060000 	stcpl	0, cr0, [r6], {-0}
    3970:	064f0301 	strbeq	r0, [pc], -r1, lsl #6
    3974:	8d0f0000 	stchi	0, cr0, [pc, #-0]	; 397c <shift+0x397c>
    3978:	0600001d 			; <UNDEFINED> instruction: 0x0600001d
    397c:	3a0c015f 	bcc	303f00 <__bss_end+0x2fa208>
    3980:	16000000 	strne	r0, [r0], -r0
    3984:	000021bc 			; <UNDEFINED> instruction: 0x000021bc
    3988:	00a90107 	adceq	r0, r9, r7, lsl #2
    398c:	72060000 	andvc	r0, r6, #0
    3990:	07240601 	streq	r0, [r4, -r1, lsl #12]!
    3994:	680b0000 	stmdavs	fp, {}	; <UNPREDICTABLE>
    3998:	0000001e 	andeq	r0, r0, lr, lsl r0
    399c:	0014d80b 	andseq	sp, r4, fp, lsl #16
    39a0:	e40b0200 	str	r0, [fp], #-512	; 0xfffffe00
    39a4:	03000014 	movweq	r0, #20
    39a8:	0018c00b 	andseq	ip, r8, fp
    39ac:	a40b0300 	strge	r0, [fp], #-768	; 0xfffffd00
    39b0:	0400001e 	streq	r0, [r0], #-30	; 0xffffffe2
    39b4:	001a270b 	andseq	r2, sl, fp, lsl #14
    39b8:	020b0400 	andeq	r0, fp, #0, 8
    39bc:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    39c0:	001af40b 	andseq	pc, sl, fp, lsl #8
    39c4:	2e0b0500 	cfsh32cs	mvfx0, mvfx11, #0
    39c8:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    39cc:	001a580b 	andseq	r5, sl, fp, lsl #16
    39d0:	c50b0500 	strgt	r0, [fp, #-1280]	; 0xfffffb00
    39d4:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    39d8:	00150e0b 	andseq	r0, r5, fp, lsl #28
    39dc:	9d0b0600 	stcls	6, cr0, [fp, #-0]
    39e0:	0600001c 			; <UNDEFINED> instruction: 0x0600001c
    39e4:	0017180b 	andseq	r1, r7, fp, lsl #16
    39e8:	b20b0600 	andlt	r0, fp, #0, 12
    39ec:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
    39f0:	00224c0b 	eoreq	r4, r2, fp, lsl #24
    39f4:	d10b0600 	tstle	fp, r0, lsl #12
    39f8:	0600001c 			; <UNDEFINED> instruction: 0x0600001c
    39fc:	001d300b 	andseq	r3, sp, fp
    3a00:	1a0b0600 	bne	2c5208 <__bss_end+0x2bb510>
    3a04:	07000015 	smladeq	r0, r5, r0, r0
    3a08:	001e4b0b 	andseq	r4, lr, fp, lsl #22
    3a0c:	b00b0700 	andlt	r0, fp, r0, lsl #14
    3a10:	0700001e 	smladeq	r0, lr, r0, r0
    3a14:	0022960b 	eoreq	r9, r2, fp, lsl #12
    3a18:	eb0b0700 	bl	2c5620 <__bss_end+0x2bb928>
    3a1c:	07000016 	smladeq	r0, r6, r0, r0
    3a20:	001f2b0b 	andseq	r2, pc, fp, lsl #22
    3a24:	7b0b0800 	blvc	2c5a2c <__bss_end+0x2bbd34>
    3a28:	08000014 	stmdaeq	r0, {r2, r4}
    3a2c:	00225a0b 	eoreq	r5, r2, fp, lsl #20
    3a30:	4c0b0800 	stcmi	8, cr0, [fp], {-0}
    3a34:	0800001f 	stmdaeq	r0, {r0, r1, r2, r3, r4}
    3a38:	25e50f00 	strbcs	r0, [r5, #3840]!	; 0xf00
    3a3c:	92060000 	andls	r0, r6, #0
    3a40:	066e1f01 	strbteq	r1, [lr], -r1, lsl #30
    3a44:	f40f0000 	vst4.8	{d0-d3}, [pc], r0
    3a48:	06000019 			; <UNDEFINED> instruction: 0x06000019
    3a4c:	3a0c0195 	bcc	3040a8 <__bss_end+0x2fa3b0>
    3a50:	0f000000 	svceq	0x00000000
    3a54:	00001f7e 	andeq	r1, r0, lr, ror pc
    3a58:	0c019806 	stceq	8, cr9, [r1], {6}
    3a5c:	0000003a 	andeq	r0, r0, sl, lsr r0
    3a60:	001b3b0f 	andseq	r3, fp, pc, lsl #22
    3a64:	019b0600 	orrseq	r0, fp, r0, lsl #12
    3a68:	00003a0c 	andeq	r3, r0, ip, lsl #20
    3a6c:	1f880f00 	svcne	0x00880f00
    3a70:	9e060000 	cdpls	0, 0, cr0, cr6, cr0, {0}
    3a74:	003a0c01 	eorseq	r0, sl, r1, lsl #24
    3a78:	7e0f0000 	cdpvc	0, 0, cr0, cr15, cr0, {0}
    3a7c:	0600001c 			; <UNDEFINED> instruction: 0x0600001c
    3a80:	3a0c01a1 	bcc	30410c <__bss_end+0x2fa414>
    3a84:	0f000000 	svceq	0x00000000
    3a88:	00001fd2 	ldrdeq	r1, [r0], -r2
    3a8c:	0c01a406 	cfstrseq	mvf10, [r1], {6}
    3a90:	0000003a 	andeq	r0, r0, sl, lsr r0
    3a94:	001e8e0f 	andseq	r8, lr, pc, lsl #28
    3a98:	01a70600 			; <UNDEFINED> instruction: 0x01a70600
    3a9c:	00003a0c 	andeq	r3, r0, ip, lsl #20
    3aa0:	1e990f00 	cdpne	15, 9, cr0, cr9, cr0, {0}
    3aa4:	aa060000 	bge	183aac <__bss_end+0x179db4>
    3aa8:	003a0c01 	eorseq	r0, sl, r1, lsl #24
    3aac:	920f0000 	andls	r0, pc, #0
    3ab0:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
    3ab4:	3a0c01ad 	bcc	304170 <__bss_end+0x2fa478>
    3ab8:	0f000000 	svceq	0x00000000
    3abc:	00001c70 	andeq	r1, r0, r0, ror ip
    3ac0:	0c01b006 	stceq	0, cr11, [r1], {6}
    3ac4:	0000003a 	andeq	r0, r0, sl, lsr r0
    3ac8:	0026270f 	eoreq	r2, r6, pc, lsl #14
    3acc:	01b30600 			; <UNDEFINED> instruction: 0x01b30600
    3ad0:	00003a0c 	andeq	r3, r0, ip, lsl #20
    3ad4:	1f9c0f00 	svcne	0x009c0f00
    3ad8:	b6060000 	strlt	r0, [r6], -r0
    3adc:	003a0c01 	eorseq	r0, sl, r1, lsl #24
    3ae0:	040f0000 	streq	r0, [pc], #-0	; 3ae8 <shift+0x3ae8>
    3ae4:	06000027 	streq	r0, [r0], -r7, lsr #32
    3ae8:	3a0c01b9 	bcc	3041d4 <__bss_end+0x2fa4dc>
    3aec:	0f000000 	svceq	0x00000000
    3af0:	000025b2 			; <UNDEFINED> instruction: 0x000025b2
    3af4:	0c01bc06 	stceq	12, cr11, [r1], {6}
    3af8:	0000003a 	andeq	r0, r0, sl, lsr r0
    3afc:	0025d70f 	eoreq	sp, r5, pc, lsl #14
    3b00:	01c00600 	biceq	r0, r0, r0, lsl #12
    3b04:	00003a0c 	andeq	r3, r0, ip, lsl #20
    3b08:	26f70f00 	ldrbtcs	r0, [r7], r0, lsl #30
    3b0c:	c3060000 	movwgt	r0, #24576	; 0x6000
    3b10:	003a0c01 	eorseq	r0, sl, r1, lsl #24
    3b14:	350f0000 	strcc	r0, [pc, #-0]	; 3b1c <shift+0x3b1c>
    3b18:	06000016 			; <UNDEFINED> instruction: 0x06000016
    3b1c:	3a0c01c6 	bcc	30423c <__bss_end+0x2fa544>
    3b20:	0f000000 	svceq	0x00000000
    3b24:	0000140c 	andeq	r1, r0, ip, lsl #8
    3b28:	0c01c906 			; <UNDEFINED> instruction: 0x0c01c906
    3b2c:	0000003a 	andeq	r0, r0, sl, lsr r0
    3b30:	0018e00f 	andseq	lr, r8, pc
    3b34:	01cc0600 	biceq	r0, ip, r0, lsl #12
    3b38:	00003a0c 	andeq	r3, r0, ip, lsl #20
    3b3c:	16100f00 	ldrne	r0, [r0], -r0, lsl #30
    3b40:	cf060000 	svcgt	0x00060000
    3b44:	003a0c01 	eorseq	r0, sl, r1, lsl #24
    3b48:	dc0f0000 	stcle	0, cr0, [pc], {-0}
    3b4c:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
    3b50:	3a0c01d2 	bcc	3042a0 <__bss_end+0x2fa5a8>
    3b54:	0f000000 	svceq	0x00000000
    3b58:	00001b63 	andeq	r1, r0, r3, ror #22
    3b5c:	0c01d506 	cfstr32eq	mvfx13, [r1], {6}
    3b60:	0000003a 	andeq	r0, r0, sl, lsr r0
    3b64:	001dfb0f 	andseq	pc, sp, pc, lsl #22
    3b68:	01d80600 	bicseq	r0, r8, r0, lsl #12
    3b6c:	00003a0c 	andeq	r3, r0, ip, lsl #20
    3b70:	23e20f00 	mvncs	r0, #0, 30
    3b74:	df060000 	svcle	0x00060000
    3b78:	003a0c01 	eorseq	r0, sl, r1, lsl #24
    3b7c:	960f0000 	strls	r0, [pc], -r0
    3b80:	06000026 	streq	r0, [r0], -r6, lsr #32
    3b84:	3a0c01e2 	bcc	304314 <__bss_end+0x2fa61c>
    3b88:	0f000000 	svceq	0x00000000
    3b8c:	000026a6 	andeq	r2, r0, r6, lsr #13
    3b90:	0c01e506 	cfstr32eq	mvfx14, [r1], {6}
    3b94:	0000003a 	andeq	r0, r0, sl, lsr r0
    3b98:	00172f0f 	andseq	r2, r7, pc, lsl #30
    3b9c:	01e80600 	mvneq	r0, r0, lsl #12
    3ba0:	00003a0c 	andeq	r3, r0, ip, lsl #20
    3ba4:	24290f00 	strtcs	r0, [r9], #-3840	; 0xfffff100
    3ba8:	eb060000 	bl	183bb0 <__bss_end+0x179eb8>
    3bac:	003a0c01 	eorseq	r0, sl, r1, lsl #24
    3bb0:	130f0000 	movwne	r0, #61440	; 0xf000
    3bb4:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
    3bb8:	3a0c01ee 	bcc	304378 <__bss_end+0x2fa680>
    3bbc:	0f000000 	svceq	0x00000000
    3bc0:	00001959 	andeq	r1, r0, r9, asr r9
    3bc4:	0c01f206 	sfmeq	f7, 1, [r1], {6}
    3bc8:	0000003a 	andeq	r0, r0, sl, lsr r0
    3bcc:	0021ce0f 	eoreq	ip, r1, pc, lsl #28
    3bd0:	01fa0600 	mvnseq	r0, r0, lsl #12
    3bd4:	00003a0c 	andeq	r3, r0, ip, lsl #20
    3bd8:	18120f00 	ldmdane	r2, {r8, r9, sl, fp}
    3bdc:	fd060000 	stc2	0, cr0, [r6, #-0]
    3be0:	003a0c01 	eorseq	r0, sl, r1, lsl #24
    3be4:	3a0c0000 	bcc	303bec <__bss_end+0x2f9ef4>
    3be8:	dc000000 	stcle	0, cr0, [r0], {-0}
    3bec:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
    3bf0:	1a430f00 	bne	10c77f8 <__bss_end+0x10bdb00>
    3bf4:	eb060000 	bl	183bfc <__bss_end+0x179f04>
    3bf8:	08d10c03 	ldmeq	r1, {r0, r1, sl, fp}^
    3bfc:	d40c0000 	strle	r0, [ip], #-0
    3c00:	f9000005 			; <UNDEFINED> instruction: 0xf9000005
    3c04:	15000008 	strne	r0, [r0, #-8]
    3c08:	0000002c 	andeq	r0, r0, ip, lsr #32
    3c0c:	120f000d 	andne	r0, pc, #13
    3c10:	06000020 	streq	r0, [r0], -r0, lsr #32
    3c14:	e9140574 	ldmdb	r4, {r2, r4, r5, r6, r8, sl}
    3c18:	16000008 	strne	r0, [r0], -r8
    3c1c:	00001b26 	andeq	r1, r0, r6, lsr #22
    3c20:	00a90107 	adceq	r0, r9, r7, lsl #2
    3c24:	7b060000 	blvc	183c2c <__bss_end+0x179f34>
    3c28:	09440605 	stmdbeq	r4, {r0, r2, r9, sl}^
    3c2c:	a20b0000 	andge	r0, fp, #0
    3c30:	00000018 	andeq	r0, r0, r8, lsl r0
    3c34:	001d5b0b 	andseq	r5, sp, fp, lsl #22
    3c38:	b10b0100 	mrslt	r0, (UNDEF: 27)
    3c3c:	02000014 	andeq	r0, r0, #20
    3c40:	0026580b 	eoreq	r5, r6, fp, lsl #16
    3c44:	9e0b0300 	cdpls	3, 0, cr0, cr11, cr0, {0}
    3c48:	04000020 	streq	r0, [r0], #-32	; 0xffffffe0
    3c4c:	0020910b 	eoreq	r9, r0, fp, lsl #2
    3c50:	a40b0500 	strge	r0, [fp], #-1280	; 0xfffffb00
    3c54:	06000015 			; <UNDEFINED> instruction: 0x06000015
    3c58:	26480f00 	strbcs	r0, [r8], -r0, lsl #30
    3c5c:	88060000 	stmdahi	r6, {}	; <UNPREDICTABLE>
    3c60:	09061505 	stmdbeq	r6, {r0, r2, r8, sl, ip}
    3c64:	240f0000 	strcs	r0, [pc], #-0	; 3c6c <shift+0x3c6c>
    3c68:	06000025 	streq	r0, [r0], -r5, lsr #32
    3c6c:	2c110789 	ldccs	7, cr0, [r1], {137}	; 0x89
    3c70:	0f000000 	svceq	0x00000000
    3c74:	00001fff 	strdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    3c78:	0c079e06 	stceq	14, cr9, [r7], {6}
    3c7c:	0000003a 	andeq	r0, r0, sl, lsr r0
    3c80:	0023d104 	eoreq	sp, r3, r4, lsl #2
    3c84:	167b0700 	ldrbtne	r0, [fp], -r0, lsl #14
    3c88:	000000a9 	andeq	r0, r0, r9, lsr #1
    3c8c:	00096b0e 	andeq	r6, r9, lr, lsl #22
    3c90:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    3c94:	00000452 	andeq	r0, r0, r2, asr r4
    3c98:	00274404 	eoreq	r4, r7, r4, lsl #8
    3c9c:	16810700 	strne	r0, [r1], r0, lsl #14
    3ca0:	0000002c 	andeq	r0, r0, ip, lsr #32
    3ca4:	0009830e 	andeq	r8, r9, lr, lsl #6
    3ca8:	273c0400 	ldrcs	r0, [ip, -r0, lsl #8]!
    3cac:	85070000 	strhi	r0, [r7, #-0]
    3cb0:	0009a016 	andeq	sl, r9, r6, lsl r0
    3cb4:	07080200 	streq	r0, [r8, -r0, lsl #4]
    3cb8:	000017fb 	strdeq	r1, [r0], -fp
    3cbc:	00272b04 	eoreq	r2, r7, r4, lsl #22
    3cc0:	10930700 	addsne	r0, r3, r0, lsl #14
    3cc4:	00000033 	andeq	r0, r0, r3, lsr r0
    3cc8:	48030802 	stmdami	r3, {r1, fp}
    3ccc:	04000016 	streq	r0, [r0], #-22	; 0xffffffea
    3cd0:	0000274c 	andeq	r2, r0, ip, asr #14
    3cd4:	25109707 	ldrcs	r9, [r0, #-1799]	; 0xfffff8f9
    3cd8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    3cdc:	000009ba 			; <UNDEFINED> instruction: 0x000009ba
    3ce0:	e6031002 	str	r1, [r3], -r2
    3ce4:	0c000020 	stceq	0, cr0, [r0], {32}
    3ce8:	00000977 	andeq	r0, r0, r7, ror r9
    3cec:	000009e2 	andeq	r0, r0, r2, ror #19
    3cf0:	00002c15 	andeq	r2, r0, r5, lsl ip
    3cf4:	0e00ff00 	cdpeq	15, 0, cr15, cr0, cr0, {0}
    3cf8:	000009d2 	ldrdeq	r0, [r0], -r2
    3cfc:	001ebd0f 	andseq	fp, lr, pc, lsl #26
    3d00:	01fc0700 	mvnseq	r0, r0, lsl #14
    3d04:	0009e216 	andeq	lr, r9, r6, lsl r2
    3d08:	15ff0f00 	ldrbne	r0, [pc, #3840]!	; 4c10 <shift+0x4c10>
    3d0c:	02070000 	andeq	r0, r7, #0
    3d10:	09e21602 	stmibeq	r2!, {r1, r9, sl, ip}^
    3d14:	10170000 	andsne	r0, r7, r0
    3d18:	01000027 	tsteq	r0, r7, lsr #32
    3d1c:	940105b9 	strls	r0, [r1], #-1465	; 0xfffffa47
    3d20:	00000009 	andeq	r0, r0, r9
    3d24:	4000009b 	mulmi	r0, fp, r0
    3d28:	01000000 	mrseq	r0, (UNDEF: 0)
    3d2c:	0061189c 	mlseq	r1, ip, r8, r1
    3d30:	1605b901 	strne	fp, [r5], -r1, lsl #18
    3d34:	000009a7 	andeq	r0, r0, r7, lsr #19
    3d38:	00000058 	andeq	r0, r0, r8, asr r0
    3d3c:	00000054 	andeq	r0, r0, r4, asr r0
    3d40:	61666419 	cmnvs	r6, r9, lsl r4
    3d44:	05bf0100 	ldreq	r0, [pc, #256]!	; 3e4c <shift+0x3e4c>
    3d48:	0009c610 	andeq	ip, r9, r0, lsl r6
    3d4c:	00008100 	andeq	r8, r0, r0, lsl #2
    3d50:	00007b00 	andeq	r7, r0, r0, lsl #22
    3d54:	69681900 	stmdbvs	r8!, {r8, fp, ip}^
    3d58:	05c40100 	strbeq	r0, [r4, #256]	; 0x100
    3d5c:	00098f10 	andeq	r8, r9, r0, lsl pc
    3d60:	0000bf00 	andeq	fp, r0, r0, lsl #30
    3d64:	0000bd00 	andeq	fp, r0, r0, lsl #26
    3d68:	6f6c1900 	svcvs	0x006c1900
    3d6c:	05c90100 	strbeq	r0, [r9, #256]	; 0x100
    3d70:	00098f10 	andeq	r8, r9, r0, lsl pc
    3d74:	0000d900 	andeq	sp, r0, r0, lsl #18
    3d78:	0000d300 	andeq	sp, r0, r0, lsl #6
    3d7c:	b4000000 	strlt	r0, [r0], #-0
    3d80:	0400000a 	streq	r0, [r0], #-10
    3d84:	000c3100 	andeq	r3, ip, r0, lsl #2
    3d88:	60010400 	andvs	r0, r1, r0, lsl #8
    3d8c:	0c000027 	stceq	0, cr0, [r0], {39}	; 0x27
    3d90:	000016a1 	andeq	r1, r0, r1, lsr #13
    3d94:	000012fd 	strdeq	r1, [r0], -sp
    3d98:	00009b40 	andeq	r9, r0, r0, asr #22
    3d9c:	00000128 	andeq	r0, r0, r8, lsr #2
    3da0:	0000115e 	andeq	r1, r0, lr, asr r1
    3da4:	fb070802 	blx	1c5db6 <__bss_end+0x1bc0be>
    3da8:	03000017 	movweq	r0, #23
    3dac:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    3db0:	04020074 	streq	r0, [r2], #-116	; 0xffffff8c
    3db4:	00180507 	andseq	r0, r8, r7, lsl #10
    3db8:	05080200 	streq	r0, [r8, #-512]	; 0xfffffe00
    3dbc:	0000037f 	andeq	r0, r0, pc, ror r3
    3dc0:	a6040802 	strge	r0, [r4], -r2, lsl #16
    3dc4:	0400001f 	streq	r0, [r0], #-31	; 0xffffffe1
    3dc8:	0000170e 	andeq	r1, r0, lr, lsl #14
    3dcc:	33162a02 	tstcc	r6, #8192	; 0x2000
    3dd0:	04000000 	streq	r0, [r0], #-0
    3dd4:	00001b71 	andeq	r1, r0, r1, ror fp
    3dd8:	60152f02 	andsvs	r2, r5, r2, lsl #30
    3ddc:	05000000 	streq	r0, [r0, #-0]
    3de0:	00006604 	andeq	r6, r0, r4, lsl #12
    3de4:	00480600 	subeq	r0, r8, r0, lsl #12
    3de8:	00750000 	rsbseq	r0, r5, r0
    3dec:	75070000 	strvc	r0, [r7, #-0]
    3df0:	00000000 	andeq	r0, r0, r0
    3df4:	007b0405 	rsbseq	r0, fp, r5, lsl #8
    3df8:	04080000 	streq	r0, [r8], #-0
    3dfc:	00002410 	andeq	r2, r0, r0, lsl r4
    3e00:	880f3602 	stmdahi	pc, {r1, r9, sl, ip, sp}	; <UNPREDICTABLE>
    3e04:	05000000 	streq	r0, [r0, #-0]
    3e08:	00008e04 	andeq	r8, r0, r4, lsl #28
    3e0c:	002c0600 	eoreq	r0, ip, r0, lsl #12
    3e10:	00a20000 	adceq	r0, r2, r0
    3e14:	75070000 	strvc	r0, [r7, #-0]
    3e18:	07000000 	streq	r0, [r0, -r0]
    3e1c:	00000075 	andeq	r0, r0, r5, ror r0
    3e20:	08010200 	stmdaeq	r1, {r9}
    3e24:	0000074a 	andeq	r0, r0, sl, asr #14
    3e28:	001dd409 	andseq	sp, sp, r9, lsl #8
    3e2c:	12bb0200 	adcsne	r0, fp, #0, 4
    3e30:	00000054 	andeq	r0, r0, r4, asr r0
    3e34:	00243e09 	eoreq	r3, r4, r9, lsl #28
    3e38:	10be0200 	adcsne	r0, lr, r0, lsl #4
    3e3c:	0000007c 	andeq	r0, r0, ip, ror r0
    3e40:	4c060102 	stfmis	f0, [r6], {2}
    3e44:	0a000007 	beq	3e68 <shift+0x3e68>
    3e48:	00001a78 	andeq	r1, r0, r8, ror sl
    3e4c:	00a20107 	adceq	r0, r2, r7, lsl #2
    3e50:	17030000 	strne	r0, [r3, -r0]
    3e54:	0001f506 	andeq	pc, r1, r6, lsl #10
    3e58:	15750b00 	ldrbne	r0, [r5, #-2816]!	; 0xfffff500
    3e5c:	0b000000 	bleq	3e64 <shift+0x3e64>
    3e60:	00001970 	andeq	r1, r0, r0, ror r9
    3e64:	1ecc0b01 	vdivne.f64	d16, d12, d1
    3e68:	0b020000 	bleq	83e70 <__bss_end+0x7a178>
    3e6c:	00002354 	andeq	r2, r0, r4, asr r3
    3e70:	1e580b03 	vnmlsne.f64	d16, d8, d3
    3e74:	0b040000 	bleq	103e7c <__bss_end+0xfa184>
    3e78:	0000221b 	andeq	r2, r0, fp, lsl r2
    3e7c:	21410b05 	cmpcs	r1, r5, lsl #22
    3e80:	0b060000 	bleq	183e88 <__bss_end+0x17a190>
    3e84:	00001596 	muleq	r0, r6, r5
    3e88:	22300b07 	eorscs	r0, r0, #7168	; 0x1c00
    3e8c:	0b080000 	bleq	203e94 <__bss_end+0x1fa19c>
    3e90:	0000223e 	andeq	r2, r0, lr, lsr r2
    3e94:	232f0b09 			; <UNDEFINED> instruction: 0x232f0b09
    3e98:	0b0a0000 	bleq	283ea0 <__bss_end+0x27a1a8>
    3e9c:	00001d9a 	muleq	r0, sl, sp
    3ea0:	174f0b0b 	strbne	r0, [pc, -fp, lsl #22]
    3ea4:	0b0c0000 	bleq	303eac <__bss_end+0x2fa1b4>
    3ea8:	00001b01 	andeq	r1, r0, r1, lsl #22
    3eac:	22870b0d 	addcs	r0, r7, #13312	; 0x3400
    3eb0:	0b0e0000 	bleq	383eb8 <__bss_end+0x37a1c0>
    3eb4:	00001abc 			; <UNDEFINED> instruction: 0x00001abc
    3eb8:	1ad20b0f 	bne	ff486afc <__bss_end+0xff47ce04>
    3ebc:	0b100000 	bleq	403ec4 <__bss_end+0x3fa1cc>
    3ec0:	000019a7 	andeq	r1, r0, r7, lsr #19
    3ec4:	1e3c0b11 	vmovne.32	r0, d12[1]
    3ec8:	0b120000 	bleq	483ed0 <__bss_end+0x47a1d8>
    3ecc:	00001a34 	andeq	r1, r0, r4, lsr sl
    3ed0:	26ec0b13 	usatcs	r0, #12, r3, lsl #22
    3ed4:	0b140000 	bleq	503edc <__bss_end+0x4fa1e4>
    3ed8:	00001f04 	andeq	r1, r0, r4, lsl #30
    3edc:	1c610b15 			; <UNDEFINED> instruction: 0x1c610b15
    3ee0:	0b160000 	bleq	583ee8 <__bss_end+0x57a1f0>
    3ee4:	000015f3 	strdeq	r1, [r0], -r3
    3ee8:	23770b17 	cmncs	r7, #23552	; 0x5c00
    3eec:	0b180000 	bleq	603ef4 <__bss_end+0x5fa1fc>
    3ef0:	00002581 	andeq	r2, r0, r1, lsl #11
    3ef4:	23850b19 	orrcs	r0, r5, #25600	; 0x6400
    3ef8:	0b1a0000 	bleq	683f00 <__bss_end+0x67a208>
    3efc:	00001a84 	andeq	r1, r0, r4, lsl #21
    3f00:	23930b1b 	orrscs	r0, r3, #27648	; 0x6c00
    3f04:	0b1c0000 	bleq	703f0c <__bss_end+0x6fa214>
    3f08:	0000144f 	andeq	r1, r0, pc, asr #8
    3f0c:	23a10b1d 			; <UNDEFINED> instruction: 0x23a10b1d
    3f10:	0b1e0000 	bleq	783f18 <__bss_end+0x77a220>
    3f14:	000023af 	andeq	r2, r0, pc, lsr #7
    3f18:	13e80b1f 	mvnne	r0, #31744	; 0x7c00
    3f1c:	0b200000 	bleq	803f24 <__bss_end+0x7fa22c>
    3f20:	00002027 	andeq	r2, r0, r7, lsr #32
    3f24:	1e0e0b21 	vmlane.f64	d0, d14, d17
    3f28:	0b220000 	bleq	883f30 <__bss_end+0x87a238>
    3f2c:	0000236a 	andeq	r2, r0, sl, ror #6
    3f30:	1cde0b23 	fldmiaxne	lr, {d16-d32}	;@ Deprecated
    3f34:	0b240000 	bleq	903f3c <__bss_end+0x8fa244>
    3f38:	00002132 	andeq	r2, r0, r2, lsr r1
    3f3c:	1bd40b25 	blne	ff506bd8 <__bss_end+0xff4fcee0>
    3f40:	0b260000 	bleq	983f48 <__bss_end+0x97a250>
    3f44:	000018b0 			; <UNDEFINED> instruction: 0x000018b0
    3f48:	1bf20b27 	blne	ffc86bec <__bss_end+0xffc7cef4>
    3f4c:	0b280000 	bleq	a03f54 <__bss_end+0x9fa25c>
    3f50:	0000194c 	andeq	r1, r0, ip, asr #18
    3f54:	1c020b29 			; <UNDEFINED> instruction: 0x1c020b29
    3f58:	0b2a0000 	bleq	a83f60 <__bss_end+0xa7a268>
    3f5c:	00001d80 	andeq	r1, r0, r0, lsl #27
    3f60:	1b7b0b2b 	blne	1ec6c14 <__bss_end+0x1ebcf1c>
    3f64:	0b2c0000 	bleq	b03f6c <__bss_end+0xafa274>
    3f68:	00002046 	andeq	r2, r0, r6, asr #32
    3f6c:	18f10b2d 	ldmne	r1!, {r0, r2, r3, r5, r8, r9, fp}^
    3f70:	002e0000 	eoreq	r0, lr, r0
    3f74:	001b0e0a 	andseq	r0, fp, sl, lsl #28
    3f78:	a2010700 	andge	r0, r1, #0, 14
    3f7c:	04000000 	streq	r0, [r0], #-0
    3f80:	04ae0617 	strteq	r0, [lr], #1559	; 0x617
    3f84:	630b0000 	movwvs	r0, #45056	; 0xb000
    3f88:	00000017 	andeq	r0, r0, r7, lsl r0
    3f8c:	0026150b 	eoreq	r1, r6, fp, lsl #10
    3f90:	730b0100 	movwvc	r0, #45312	; 0xb100
    3f94:	02000017 	andeq	r0, r0, #23
    3f98:	0017960b 	andseq	r9, r7, fp, lsl #12
    3f9c:	4e0b0300 	cdpmi	3, 0, cr0, cr11, cr0, {0}
    3fa0:	04000024 	streq	r0, [r0], #-36	; 0xffffffdc
    3fa4:	0020ac0b 	eoreq	sl, r0, fp, lsl #24
    3fa8:	200b0500 	andcs	r0, fp, r0, lsl #10
    3fac:	06000018 			; <UNDEFINED> instruction: 0x06000018
    3fb0:	0019950b 	andseq	r9, r9, fp, lsl #10
    3fb4:	a60b0700 	strge	r0, [fp], -r0, lsl #14
    3fb8:	08000017 	stmdaeq	r0, {r0, r1, r2, r4}
    3fbc:	0026db0b 	eoreq	sp, r6, fp, lsl #22
    3fc0:	c60b0900 	strgt	r0, [fp], -r0, lsl #18
    3fc4:	0a000014 	beq	401c <shift+0x401c>
    3fc8:	0026040b 	eoreq	r0, r6, fp, lsl #8
    3fcc:	ed0b0b00 	vstr	d0, [fp, #-0]
    3fd0:	0c00001c 	stceq	0, cr0, [r0], {28}
    3fd4:	0025980b 	eoreq	r9, r5, fp, lsl #16
    3fd8:	340b0d00 	strcc	r0, [fp], #-3328	; 0xfffff300
    3fdc:	0e000020 	cdpeq	0, 0, cr0, cr0, cr0, {1}
    3fe0:	0022cd0b 	eoreq	ip, r2, fp, lsl #26
    3fe4:	810b0f00 	tsthi	fp, r0, lsl #30
    3fe8:	10000018 	andne	r0, r0, r8, lsl r0
    3fec:	0017830b 	andseq	r8, r7, fp, lsl #6
    3ff0:	ec0b1100 	stfs	f1, [fp], {-0}
    3ff4:	1200001f 	andne	r0, r0, #31
    3ff8:	00186c0b 	andseq	r6, r8, fp, lsl #24
    3ffc:	f30b1300 	vcgt.u8	d1, d11, d0
    4000:	14000025 	strne	r0, [r0], #-37	; 0xffffffdb
    4004:	0014f00b 	andseq	pc, r4, fp
    4008:	3c0b1500 	cfstr32cc	mvfx1, [fp], {-0}
    400c:	1600001c 			; <UNDEFINED> instruction: 0x1600001c
    4010:	0017b60b 	andseq	fp, r7, fp, lsl #12
    4014:	8d0b1700 	stchi	7, cr1, [fp, #-0]
    4018:	18000014 	stmdane	r0, {r2, r4}
    401c:	0026810b 	eoreq	r8, r6, fp, lsl #2
    4020:	3c0b1900 			; <UNDEFINED> instruction: 0x3c0b1900
    4024:	1a000023 	bne	40b8 <shift+0x40b8>
    4028:	0021500b 	eoreq	r5, r1, fp
    402c:	b40b1b00 	strlt	r1, [fp], #-2816	; 0xfffff500
    4030:	1c000022 	stcne	0, cr0, [r0], {34}	; 0x22
    4034:	0024180b 	eoreq	r1, r4, fp, lsl #16
    4038:	d60b1d00 	strle	r1, [fp], -r0, lsl #26
    403c:	1e000017 	mcrne	0, 0, r0, cr0, cr7, {0}
    4040:	0015610b 	andseq	r6, r5, fp, lsl #2
    4044:	690b1f00 	stmdbvs	fp, {r8, r9, sl, fp, ip}
    4048:	20000021 	andcs	r0, r0, r1, lsr #32
    404c:	0018cd0b 	andseq	ip, r8, fp, lsl #26
    4050:	be0b2100 	adflte	f2, f3, f0
    4054:	22000020 	andcs	r0, r0, #32
    4058:	001cbe0b 	andseq	fp, ip, fp, lsl #28
    405c:	c60b2300 	strgt	r2, [fp], -r0, lsl #6
    4060:	24000017 	strcs	r0, [r0], #-23	; 0xffffffe9
    4064:	00226c0b 	eoreq	r6, r2, fp, lsl #24
    4068:	d90b2500 	stmdble	fp, {r8, sl, sp}
    406c:	26000016 			; <UNDEFINED> instruction: 0x26000016
    4070:	0023fd0b 	eoreq	pc, r3, fp, lsl #26
    4074:	c80b2700 	stmdagt	fp, {r8, r9, sl, sp}
    4078:	28000026 	stmdacs	r0, {r1, r2, r5}
    407c:	001fbf0b 	andseq	fp, pc, fp, lsl #30
    4080:	660b2900 	strvs	r2, [fp], -r0, lsl #18
    4084:	2a00001a 	bcs	40f4 <shift+0x40f4>
    4088:	0021930b 	eoreq	r9, r1, fp, lsl #6
    408c:	1c0b2b00 			; <UNDEFINED> instruction: 0x1c0b2b00
    4090:	2c00001d 	stccs	0, cr0, [r0], {29}
    4094:	0015b40b 	andseq	fp, r5, fp, lsl #8
    4098:	380b2d00 	stmdacc	fp, {r8, sl, fp, sp}
    409c:	2e000015 	mcrcs	0, 0, r0, cr0, cr5, {0}
    40a0:	0025560b 	eoreq	r5, r5, fp, lsl #12
    40a4:	aa0b2f00 	bge	2cfcac <__bss_end+0x2c5fb4>
    40a8:	3000001c 	andcc	r0, r0, ip, lsl r0
    40ac:	0018460b 	andseq	r4, r8, fp, lsl #12
    40b0:	890b3100 	stmdbhi	fp, {r8, ip, sp}
    40b4:	3200001c 	andcc	r0, r0, #28
    40b8:	001f380b 	andseq	r3, pc, fp, lsl #16
    40bc:	260b3300 	strcs	r3, [fp], -r0, lsl #6
    40c0:	34000015 	strcc	r0, [r0], #-21	; 0xffffffeb
    40c4:	0026b60b 	eoreq	fp, r6, fp, lsl #12
    40c8:	6d0b3500 	cfstr32vs	mvfx3, [fp, #-0]
    40cc:	3600001d 			; <UNDEFINED> instruction: 0x3600001d
    40d0:	0019ff0b 	andseq	pc, r9, fp, lsl #30
    40d4:	aa0b3700 	bge	2d1cdc <__bss_end+0x2c7fe4>
    40d8:	3800001d 	stmdacc	r0, {r0, r2, r3, r4}
    40dc:	0025be0b 	eoreq	fp, r5, fp, lsl #28
    40e0:	6b0b3900 	blvs	2d24e8 <__bss_end+0x2c87f0>
    40e4:	3a000016 	bcc	4144 <shift+0x4144>
    40e8:	001a120b 	andseq	r1, sl, fp, lsl #4
    40ec:	de0b3b00 	vmlale.f64	d3, d11, d0
    40f0:	3c000019 	stccc	0, cr0, [r0], {25}
    40f4:	0013f70b 	andseq	pc, r3, fp, lsl #14
    40f8:	ff0b3d00 			; <UNDEFINED> instruction: 0xff0b3d00
    40fc:	3e00001c 	mcrcc	0, 0, r0, cr0, cr12, {0}
    4100:	001ade0b 	andseq	sp, sl, fp, lsl #28
    4104:	7f0b3f00 	svcvc	0x000b3f00
    4108:	40000015 	andmi	r0, r0, r5, lsl r0
    410c:	00256a0b 	eoreq	r6, r5, fp, lsl #20
    4110:	4f0b4100 	svcmi	0x000b4100
    4114:	4200001c 	andmi	r0, r0, #28
    4118:	0019c80b 	andseq	ip, r9, fp, lsl #16
    411c:	380b4300 	stmdacc	fp, {r8, r9, lr}
    4120:	44000014 	strmi	r0, [r0], #-20	; 0xffffffec
    4124:	001bac0b 	andseq	sl, fp, fp, lsl #24
    4128:	980b4500 	stmdals	fp, {r8, sl, lr}
    412c:	4600001b 			; <UNDEFINED> instruction: 0x4600001b
    4130:	0021130b 	eoreq	r1, r1, fp, lsl #6
    4134:	db0b4700 	blle	2d5d3c <__bss_end+0x2cc044>
    4138:	48000021 	stmdami	r0, {r0, r5}
    413c:	0025350b 	eoreq	r3, r5, fp, lsl #10
    4140:	fe0b4900 	vseleq.f16	s8, s22, s0
    4144:	4a000018 	bmi	41ac <shift+0x41ac>
    4148:	001eee0b 	andseq	lr, lr, fp, lsl #28
    414c:	a80b4b00 	stmdage	fp, {r8, r9, fp, lr}
    4150:	4c000021 	stcmi	0, cr0, [r0], {33}	; 0x21
    4154:	0020550b 	eoreq	r5, r0, fp, lsl #10
    4158:	690b4d00 	stmdbvs	fp, {r8, sl, fp, lr}
    415c:	4e000020 	cdpmi	0, 0, cr0, cr0, cr0, {1}
    4160:	00207d0b 	eoreq	r7, r0, fp, lsl #26
    4164:	f90b4f00 			; <UNDEFINED> instruction: 0xf90b4f00
    4168:	50000016 	andpl	r0, r0, r6, lsl r0
    416c:	0016560b 	andseq	r5, r6, fp, lsl #12
    4170:	7e0b5100 	adfvce	f5, f3, f0
    4174:	52000016 	andpl	r0, r0, #22
    4178:	0022df0b 	eoreq	sp, r2, fp, lsl #30
    417c:	c40b5300 	strgt	r5, [fp], #-768	; 0xfffffd00
    4180:	54000016 	strpl	r0, [r0], #-22	; 0xffffffea
    4184:	0022f30b 	eoreq	pc, r2, fp, lsl #6
    4188:	070b5500 	streq	r5, [fp, -r0, lsl #10]
    418c:	56000023 	strpl	r0, [r0], -r3, lsr #32
    4190:	00231b0b 	eoreq	r1, r3, fp, lsl #22
    4194:	580b5700 	stmdapl	fp, {r8, r9, sl, ip, lr}
    4198:	58000018 	stmdapl	r0, {r3, r4}
    419c:	0018320b 	andseq	r3, r8, fp, lsl #4
    41a0:	c00b5900 	andgt	r5, fp, r0, lsl #18
    41a4:	5a00001b 	bpl	4218 <shift+0x4218>
    41a8:	001dbd0b 	andseq	fp, sp, fp, lsl #26
    41ac:	460b5b00 	strmi	r5, [fp], -r0, lsl #22
    41b0:	5c00001b 	stcpl	0, cr0, [r0], {27}
    41b4:	0013cb0b 	andseq	ip, r3, fp, lsl #22
    41b8:	800b5d00 	andhi	r5, fp, r0, lsl #26
    41bc:	5e000019 	mcrpl	0, 0, r0, cr0, cr9, {0}
    41c0:	001de60b 	andseq	lr, sp, fp, lsl #12
    41c4:	120b5f00 	andne	r5, fp, #0, 30
    41c8:	6000001c 	andvs	r0, r0, ip, lsl r0
    41cc:	0020d10b 	eoreq	sp, r0, fp, lsl #2
    41d0:	330b6100 	movwcc	r6, #45312	; 0xb100
    41d4:	62000026 	andvs	r0, r0, #38	; 0x26
    41d8:	001ed90b 	andseq	sp, lr, fp, lsl #18
    41dc:	230b6300 	movwcs	r6, #45824	; 0xb300
    41e0:	64000019 	strvs	r0, [r0], #-25	; 0xffffffe7
    41e4:	00149f0b 	andseq	r9, r4, fp, lsl #30
    41e8:	5d0b6500 	cfstr32pl	mvfx6, [fp, #-0]
    41ec:	66000014 			; <UNDEFINED> instruction: 0x66000014
    41f0:	001e1e0b 	andseq	r1, lr, fp, lsl #28
    41f4:	590b6700 	stmdbpl	fp, {r8, r9, sl, sp, lr}
    41f8:	6800001f 	stmdavs	r0, {r0, r1, r2, r3, r4}
    41fc:	0020f50b 	eoreq	pc, r0, fp, lsl #10
    4200:	270b6900 	strcs	r6, [fp, -r0, lsl #18]
    4204:	6a00001c 	bvs	427c <shift+0x427c>
    4208:	00266c0b 	eoreq	r6, r6, fp, lsl #24
    420c:	3d0b6b00 	vstrcc	d6, [fp, #-0]
    4210:	6c00001d 	stcvs	0, cr0, [r0], {29}
    4214:	00141c0b 	andseq	r1, r4, fp, lsl #24
    4218:	4c0b6d00 	stcmi	13, cr6, [fp], {-0}
    421c:	6e000015 	mcrvs	0, 0, r0, cr0, cr5, {0}
    4220:	0019370b 	andseq	r3, r9, fp, lsl #14
    4224:	e70b6f00 	str	r6, [fp, -r0, lsl #30]
    4228:	70000017 	andvc	r0, r0, r7, lsl r0
    422c:	07020200 	streq	r0, [r2, -r0, lsl #4]
    4230:	00000854 	andeq	r0, r0, r4, asr r8
    4234:	0004cb0c 	andeq	ip, r4, ip, lsl #22
    4238:	0004c000 	andeq	ip, r4, r0
    423c:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    4240:	000004b5 			; <UNDEFINED> instruction: 0x000004b5
    4244:	04d70405 	ldrbeq	r0, [r7], #1029	; 0x405
    4248:	c50e0000 	strgt	r0, [lr, #-0]
    424c:	02000004 	andeq	r0, r0, #4
    4250:	07530801 	ldrbeq	r0, [r3, -r1, lsl #16]
    4254:	d00e0000 	andle	r0, lr, r0
    4258:	0f000004 	svceq	0x00000004
    425c:	000015e4 	andeq	r1, r0, r4, ror #11
    4260:	1a014405 	bne	5527c <__bss_end+0x4b584>
    4264:	000004c0 	andeq	r0, r0, r0, asr #9
    4268:	0019b80f 	andseq	fp, r9, pc, lsl #16
    426c:	01790500 	cmneq	r9, r0, lsl #10
    4270:	0004c01a 	andeq	ip, r4, sl, lsl r0
    4274:	04d00c00 	ldrbeq	r0, [r0], #3072	; 0xc00
    4278:	05010000 	streq	r0, [r1, #-0]
    427c:	000d0000 	andeq	r0, sp, r0
    4280:	001be409 	andseq	lr, fp, r9, lsl #8
    4284:	0d2d0600 	stceq	6, cr0, [sp, #-0]
    4288:	000004f6 	strdeq	r0, [r0], -r6
    428c:	0023d909 	eoreq	sp, r3, r9, lsl #18
    4290:	1c350600 	ldcne	6, cr0, [r5], #-0
    4294:	000001f5 	strdeq	r0, [r0], -r5
    4298:	0018940a 	andseq	r9, r8, sl, lsl #8
    429c:	a2010700 	andge	r0, r1, #0, 14
    42a0:	06000000 	streq	r0, [r0], -r0
    42a4:	058c0e37 	streq	r0, [ip, #3639]	; 0xe37
    42a8:	310b0000 	mrscc	r0, (UNDEF: 11)
    42ac:	00000014 	andeq	r0, r0, r4, lsl r0
    42b0:	001acb0b 	andseq	ip, sl, fp, lsl #22
    42b4:	d00b0100 	andle	r0, fp, r0, lsl #2
    42b8:	02000025 	andeq	r0, r0, #37	; 0x25
    42bc:	0025ab0b 	eoreq	sl, r5, fp, lsl #22
    42c0:	870b0300 	strhi	r0, [fp, -r0, lsl #6]
    42c4:	0400001e 	streq	r0, [r0], #-30	; 0xffffffe2
    42c8:	0022290b 	eoreq	r2, r2, fp, lsl #18
    42cc:	270b0500 	strcs	r0, [fp, -r0, lsl #10]
    42d0:	06000016 			; <UNDEFINED> instruction: 0x06000016
    42d4:	0016090b 	andseq	r0, r6, fp, lsl #18
    42d8:	5c0b0700 	stcpl	7, cr0, [fp], {-0}
    42dc:	08000017 	stmdaeq	r0, {r0, r1, r2, r4}
    42e0:	001d150b 	andseq	r1, sp, fp, lsl #10
    42e4:	2e0b0900 	vmlacs.f16	s0, s22, s0	; <UNPREDICTABLE>
    42e8:	0a000016 	beq	4348 <shift+0x4348>
    42ec:	00169a0b 	andseq	r9, r6, fp, lsl #20
    42f0:	930b0b00 	movwls	r0, #47872	; 0xbb00
    42f4:	0c000016 	stceq	0, cr0, [r0], {22}
    42f8:	0016200b 	andseq	r2, r6, fp
    42fc:	800b0d00 	andhi	r0, fp, r0, lsl #26
    4300:	0e000022 	cdpeq	0, 0, cr0, cr0, cr2, {1}
    4304:	001f770b 	andseq	r7, pc, fp, lsl #14
    4308:	04000f00 	streq	r0, [r0], #-3840	; 0xfffff100
    430c:	0000212b 	andeq	r2, r0, fp, lsr #2
    4310:	19013c06 	stmdbne	r1, {r1, r2, sl, fp, ip, sp}
    4314:	09000005 	stmdbeq	r0, {r0, r2}
    4318:	000021fc 	strdeq	r2, [r0], -ip
    431c:	8c0f3e06 	stchi	14, cr3, [pc], {6}
    4320:	09000005 	stmdbeq	r0, {r0, r2}
    4324:	000022a3 	andeq	r2, r0, r3, lsr #5
    4328:	2c0c4706 	stccs	7, cr4, [ip], {6}
    432c:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    4330:	000015d4 	ldrdeq	r1, [r0], -r4
    4334:	2c0c4806 	stccs	8, cr4, [ip], {6}
    4338:	10000000 	andne	r0, r0, r0
    433c:	000023bd 			; <UNDEFINED> instruction: 0x000023bd
    4340:	00220b09 	eoreq	r0, r2, r9, lsl #22
    4344:	14490600 	strbne	r0, [r9], #-1536	; 0xfffffa00
    4348:	000005cd 	andeq	r0, r0, sp, asr #11
    434c:	05bc0405 	ldreq	r0, [ip, #1029]!	; 0x405
    4350:	09110000 	ldmdbeq	r1, {}	; <UNPREDICTABLE>
    4354:	00001a95 	muleq	r0, r5, sl
    4358:	e00f4b06 	and	r4, pc, r6, lsl #22
    435c:	05000005 	streq	r0, [r0, #-5]
    4360:	0005d304 	andeq	sp, r5, r4, lsl #6
    4364:	217e1200 	cmncs	lr, r0, lsl #4
    4368:	74090000 	strvc	r0, [r9], #-0
    436c:	0600001e 			; <UNDEFINED> instruction: 0x0600001e
    4370:	05f70d4f 	ldrbeq	r0, [r7, #3407]!	; 0xd4f
    4374:	04050000 	streq	r0, [r5], #-0
    4378:	000005e6 	andeq	r0, r0, r6, ror #11
    437c:	00174213 	andseq	r4, r7, r3, lsl r2
    4380:	58063400 	stmdapl	r6, {sl, ip, sp}
    4384:	06281501 	strteq	r1, [r8], -r1, lsl #10
    4388:	ed140000 	ldc	0, cr0, [r4, #-0]
    438c:	0600001b 			; <UNDEFINED> instruction: 0x0600001b
    4390:	c50f015a 	strgt	r0, [pc, #-346]	; 423e <shift+0x423e>
    4394:	00000004 	andeq	r0, r0, r4
    4398:	00172614 	andseq	r2, r7, r4, lsl r6
    439c:	015b0600 	cmpeq	fp, r0, lsl #12
    43a0:	00062d14 	andeq	r2, r6, r4, lsl sp
    43a4:	0e000400 	cfcpyseq	mvf0, mvf0
    43a8:	000005fd 	strdeq	r0, [r0], -sp
    43ac:	0000c80c 	andeq	ip, r0, ip, lsl #16
    43b0:	00063d00 	andeq	r3, r6, r0, lsl #26
    43b4:	00331500 	eorseq	r1, r3, r0, lsl #10
    43b8:	002d0000 	eoreq	r0, sp, r0
    43bc:	0006280c 	andeq	r2, r6, ip, lsl #16
    43c0:	00064800 	andeq	r4, r6, r0, lsl #16
    43c4:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    43c8:	0000063d 	andeq	r0, r0, sp, lsr r6
    43cc:	001b1d0f 	andseq	r1, fp, pc, lsl #26
    43d0:	015c0600 	cmpeq	ip, r0, lsl #12
    43d4:	00064803 	andeq	r4, r6, r3, lsl #16
    43d8:	1d8d0f00 	stcne	15, cr0, [sp]
    43dc:	5f060000 	svcpl	0x00060000
    43e0:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    43e4:	bc160000 	ldclt	0, cr0, [r6], {-0}
    43e8:	07000021 	streq	r0, [r0, -r1, lsr #32]
    43ec:	0000a201 	andeq	sl, r0, r1, lsl #4
    43f0:	01720600 	cmneq	r2, r0, lsl #12
    43f4:	00071d06 	andeq	r1, r7, r6, lsl #26
    43f8:	1e680b00 	vmulne.f64	d16, d8, d0
    43fc:	0b000000 	bleq	4404 <shift+0x4404>
    4400:	000014d8 	ldrdeq	r1, [r0], -r8
    4404:	14e40b02 	strbtne	r0, [r4], #2818	; 0xb02
    4408:	0b030000 	bleq	c4410 <__bss_end+0xba718>
    440c:	000018c0 	andeq	r1, r0, r0, asr #17
    4410:	1ea40b03 	vfmane.f64	d0, d4, d3
    4414:	0b040000 	bleq	10441c <__bss_end+0xfa724>
    4418:	00001a27 	andeq	r1, r0, r7, lsr #20
    441c:	15020b04 	strne	r0, [r2, #-2820]	; 0xfffff4fc
    4420:	0b050000 	bleq	144428 <__bss_end+0x13a730>
    4424:	00001af4 	strdeq	r1, [r0], -r4
    4428:	1b2e0b05 	blne	b87044 <__bss_end+0xb7d34c>
    442c:	0b050000 	bleq	144434 <__bss_end+0x13a73c>
    4430:	00001a58 	andeq	r1, r0, r8, asr sl
    4434:	15c50b05 	strbne	r0, [r5, #2821]	; 0xb05
    4438:	0b050000 	bleq	144440 <__bss_end+0x13a748>
    443c:	0000150e 	andeq	r1, r0, lr, lsl #10
    4440:	1c9d0b06 	vldmiane	sp, {d0-d2}
    4444:	0b060000 	bleq	18444c <__bss_end+0x17a754>
    4448:	00001718 	andeq	r1, r0, r8, lsl r7
    444c:	1fb20b06 	svcne	0x00b20b06
    4450:	0b060000 	bleq	184458 <__bss_end+0x17a760>
    4454:	0000224c 	andeq	r2, r0, ip, asr #4
    4458:	1cd10b06 	vldmiane	r1, {d16-d18}
    445c:	0b060000 	bleq	184464 <__bss_end+0x17a76c>
    4460:	00001d30 	andeq	r1, r0, r0, lsr sp
    4464:	151a0b06 	ldrne	r0, [sl, #-2822]	; 0xfffff4fa
    4468:	0b070000 	bleq	1c4470 <__bss_end+0x1ba778>
    446c:	00001e4b 	andeq	r1, r0, fp, asr #28
    4470:	1eb00b07 	vmovne.f64	d0, #7	; 0x40380000  2.875
    4474:	0b070000 	bleq	1c447c <__bss_end+0x1ba784>
    4478:	00002296 	muleq	r0, r6, r2
    447c:	16eb0b07 	strbtne	r0, [fp], r7, lsl #22
    4480:	0b070000 	bleq	1c4488 <__bss_end+0x1ba790>
    4484:	00001f2b 	andeq	r1, r0, fp, lsr #30
    4488:	147b0b08 	ldrbtne	r0, [fp], #-2824	; 0xfffff4f8
    448c:	0b080000 	bleq	204494 <__bss_end+0x1fa79c>
    4490:	0000225a 	andeq	r2, r0, sl, asr r2
    4494:	1f4c0b08 	svcne	0x004c0b08
    4498:	00080000 	andeq	r0, r8, r0
    449c:	0025e50f 	eoreq	lr, r5, pc, lsl #10
    44a0:	01920600 	orrseq	r0, r2, r0, lsl #12
    44a4:	0006671f 	andeq	r6, r6, pc, lsl r7
    44a8:	19f40f00 	ldmibne	r4!, {r8, r9, sl, fp}^
    44ac:	95060000 	strls	r0, [r6, #-0]
    44b0:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    44b4:	7e0f0000 	cdpvc	0, 0, cr0, cr15, cr0, {0}
    44b8:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
    44bc:	2c0c0198 	stfcss	f0, [ip], {152}	; 0x98
    44c0:	0f000000 	svceq	0x00000000
    44c4:	00001b3b 	andeq	r1, r0, fp, lsr fp
    44c8:	0c019b06 			; <UNDEFINED> instruction: 0x0c019b06
    44cc:	0000002c 	andeq	r0, r0, ip, lsr #32
    44d0:	001f880f 	andseq	r8, pc, pc, lsl #16
    44d4:	019e0600 	orrseq	r0, lr, r0, lsl #12
    44d8:	00002c0c 	andeq	r2, r0, ip, lsl #24
    44dc:	1c7e0f00 	ldclne	15, cr0, [lr], #-0
    44e0:	a1060000 	mrsge	r0, (UNDEF: 6)
    44e4:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    44e8:	d20f0000 	andle	r0, pc, #0
    44ec:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
    44f0:	2c0c01a4 	stfcss	f0, [ip], {164}	; 0xa4
    44f4:	0f000000 	svceq	0x00000000
    44f8:	00001e8e 	andeq	r1, r0, lr, lsl #29
    44fc:	0c01a706 	stceq	7, cr10, [r1], {6}
    4500:	0000002c 	andeq	r0, r0, ip, lsr #32
    4504:	001e990f 	andseq	r9, lr, pc, lsl #18
    4508:	01aa0600 			; <UNDEFINED> instruction: 0x01aa0600
    450c:	00002c0c 	andeq	r2, r0, ip, lsl #24
    4510:	1f920f00 	svcne	0x00920f00
    4514:	ad060000 	stcge	0, cr0, [r6, #-0]
    4518:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    451c:	700f0000 	andvc	r0, pc, r0
    4520:	0600001c 			; <UNDEFINED> instruction: 0x0600001c
    4524:	2c0c01b0 	stfcss	f0, [ip], {176}	; 0xb0
    4528:	0f000000 	svceq	0x00000000
    452c:	00002627 	andeq	r2, r0, r7, lsr #12
    4530:	0c01b306 	stceq	3, cr11, [r1], {6}
    4534:	0000002c 	andeq	r0, r0, ip, lsr #32
    4538:	001f9c0f 	andseq	r9, pc, pc, lsl #24
    453c:	01b60600 			; <UNDEFINED> instruction: 0x01b60600
    4540:	00002c0c 	andeq	r2, r0, ip, lsl #24
    4544:	27040f00 	strcs	r0, [r4, -r0, lsl #30]
    4548:	b9060000 	stmdblt	r6, {}	; <UNPREDICTABLE>
    454c:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    4550:	b20f0000 	andlt	r0, pc, #0
    4554:	06000025 	streq	r0, [r0], -r5, lsr #32
    4558:	2c0c01bc 	stfcss	f0, [ip], {188}	; 0xbc
    455c:	0f000000 	svceq	0x00000000
    4560:	000025d7 	ldrdeq	r2, [r0], -r7
    4564:	0c01c006 	stceq	0, cr12, [r1], {6}
    4568:	0000002c 	andeq	r0, r0, ip, lsr #32
    456c:	0026f70f 	eoreq	pc, r6, pc, lsl #14
    4570:	01c30600 	biceq	r0, r3, r0, lsl #12
    4574:	00002c0c 	andeq	r2, r0, ip, lsl #24
    4578:	16350f00 	ldrtne	r0, [r5], -r0, lsl #30
    457c:	c6060000 	strgt	r0, [r6], -r0
    4580:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    4584:	0c0f0000 	stceq	0, cr0, [pc], {-0}
    4588:	06000014 			; <UNDEFINED> instruction: 0x06000014
    458c:	2c0c01c9 	stfcss	f0, [ip], {201}	; 0xc9
    4590:	0f000000 	svceq	0x00000000
    4594:	000018e0 	andeq	r1, r0, r0, ror #17
    4598:	0c01cc06 	stceq	12, cr12, [r1], {6}
    459c:	0000002c 	andeq	r0, r0, ip, lsr #32
    45a0:	0016100f 	andseq	r1, r6, pc
    45a4:	01cf0600 	biceq	r0, pc, r0, lsl #12
    45a8:	00002c0c 	andeq	r2, r0, ip, lsl #24
    45ac:	1fdc0f00 	svcne	0x00dc0f00
    45b0:	d2060000 	andle	r0, r6, #0
    45b4:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    45b8:	630f0000 	movwvs	r0, #61440	; 0xf000
    45bc:	0600001b 			; <UNDEFINED> instruction: 0x0600001b
    45c0:	2c0c01d5 	stfcss	f0, [ip], {213}	; 0xd5
    45c4:	0f000000 	svceq	0x00000000
    45c8:	00001dfb 	strdeq	r1, [r0], -fp
    45cc:	0c01d806 	stceq	8, cr13, [r1], {6}
    45d0:	0000002c 	andeq	r0, r0, ip, lsr #32
    45d4:	0023e20f 	eoreq	lr, r3, pc, lsl #4
    45d8:	01df0600 	bicseq	r0, pc, r0, lsl #12
    45dc:	00002c0c 	andeq	r2, r0, ip, lsl #24
    45e0:	26960f00 	ldrcs	r0, [r6], r0, lsl #30
    45e4:	e2060000 	and	r0, r6, #0
    45e8:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    45ec:	a60f0000 	strge	r0, [pc], -r0
    45f0:	06000026 	streq	r0, [r0], -r6, lsr #32
    45f4:	2c0c01e5 	stfcss	f0, [ip], {229}	; 0xe5
    45f8:	0f000000 	svceq	0x00000000
    45fc:	0000172f 	andeq	r1, r0, pc, lsr #14
    4600:	0c01e806 	stceq	8, cr14, [r1], {6}
    4604:	0000002c 	andeq	r0, r0, ip, lsr #32
    4608:	0024290f 	eoreq	r2, r4, pc, lsl #18
    460c:	01eb0600 	mvneq	r0, r0, lsl #12
    4610:	00002c0c 	andeq	r2, r0, ip, lsl #24
    4614:	1f130f00 	svcne	0x00130f00
    4618:	ee060000 	cdp	0, 0, cr0, cr6, cr0, {0}
    461c:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    4620:	590f0000 	stmdbpl	pc, {}	; <UNPREDICTABLE>
    4624:	06000019 			; <UNDEFINED> instruction: 0x06000019
    4628:	2c0c01f2 	stfcss	f0, [ip], {242}	; 0xf2
    462c:	0f000000 	svceq	0x00000000
    4630:	000021ce 	andeq	r2, r0, lr, asr #3
    4634:	0c01fa06 			; <UNDEFINED> instruction: 0x0c01fa06
    4638:	0000002c 	andeq	r0, r0, ip, lsr #32
    463c:	0018120f 	andseq	r1, r8, pc, lsl #4
    4640:	01fd0600 	mvnseq	r0, r0, lsl #12
    4644:	00002c0c 	andeq	r2, r0, ip, lsl #24
    4648:	002c0c00 	eoreq	r0, ip, r0, lsl #24
    464c:	08d50000 	ldmeq	r5, {}^	; <UNPREDICTABLE>
    4650:	000d0000 	andeq	r0, sp, r0
    4654:	001a430f 	andseq	r4, sl, pc, lsl #6
    4658:	03eb0600 	mvneq	r0, #0, 12
    465c:	0008ca0c 	andeq	ip, r8, ip, lsl #20
    4660:	05cd0c00 	strbeq	r0, [sp, #3072]	; 0xc00
    4664:	08f20000 	ldmeq	r2!, {}^	; <UNPREDICTABLE>
    4668:	33150000 	tstcc	r5, #0
    466c:	0d000000 	stceq	0, cr0, [r0, #-0]
    4670:	20120f00 	andscs	r0, r2, r0, lsl #30
    4674:	74060000 	strvc	r0, [r6], #-0
    4678:	08e21405 	stmiaeq	r2!, {r0, r2, sl, ip}^
    467c:	26160000 	ldrcs	r0, [r6], -r0
    4680:	0700001b 	smladeq	r0, fp, r0, r0
    4684:	0000a201 	andeq	sl, r0, r1, lsl #4
    4688:	057b0600 	ldrbeq	r0, [fp, #-1536]!	; 0xfffffa00
    468c:	00093d06 	andeq	r3, r9, r6, lsl #26
    4690:	18a20b00 	stmiane	r2!, {r8, r9, fp}
    4694:	0b000000 	bleq	469c <shift+0x469c>
    4698:	00001d5b 	andeq	r1, r0, fp, asr sp
    469c:	14b10b01 	ldrtne	r0, [r1], #2817	; 0xb01
    46a0:	0b020000 	bleq	846a8 <__bss_end+0x7a9b0>
    46a4:	00002658 	andeq	r2, r0, r8, asr r6
    46a8:	209e0b03 	addscs	r0, lr, r3, lsl #22
    46ac:	0b040000 	bleq	1046b4 <__bss_end+0xfa9bc>
    46b0:	00002091 	muleq	r0, r1, r0
    46b4:	15a40b05 	strne	r0, [r4, #2821]!	; 0xb05
    46b8:	00060000 	andeq	r0, r6, r0
    46bc:	0026480f 	eoreq	r4, r6, pc, lsl #16
    46c0:	05880600 	streq	r0, [r8, #1536]	; 0x600
    46c4:	0008ff15 	andeq	pc, r8, r5, lsl pc	; <UNPREDICTABLE>
    46c8:	25240f00 	strcs	r0, [r4, #-3840]!	; 0xfffff100
    46cc:	89060000 	stmdbhi	r6, {}	; <UNPREDICTABLE>
    46d0:	00331107 	eorseq	r1, r3, r7, lsl #2
    46d4:	ff0f0000 			; <UNDEFINED> instruction: 0xff0f0000
    46d8:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
    46dc:	2c0c079e 	stccs	7, cr0, [ip], {158}	; 0x9e
    46e0:	04000000 	streq	r0, [r0], #-0
    46e4:	000023d1 	ldrdeq	r2, [r0], -r1
    46e8:	a2167b07 	andsge	r7, r6, #7168	; 0x1c00
    46ec:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    46f0:	00000964 	andeq	r0, r0, r4, ror #18
    46f4:	52050202 	andpl	r0, r5, #536870912	; 0x20000000
    46f8:	04000004 	streq	r0, [r0], #-4
    46fc:	00002744 	andeq	r2, r0, r4, asr #14
    4700:	33168107 	tstcc	r6, #-1073741823	; 0xc0000001
    4704:	04000000 	streq	r0, [r0], #-0
    4708:	0000273c 	andeq	r2, r0, ip, lsr r7
    470c:	25168507 	ldrcs	r8, [r6, #-1287]	; 0xfffffaf9
    4710:	02000000 	andeq	r0, r0, #0
    4714:	16500404 	ldrbne	r0, [r0], -r4, lsl #8
    4718:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    471c:	00164803 	andseq	r4, r6, r3, lsl #16
    4720:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    4724:	00001fab 	andeq	r1, r0, fp, lsr #31
    4728:	e6031002 	str	r1, [r3], -r2
    472c:	0c000020 	stceq	0, cr0, [r0], {32}
    4730:	00000970 	andeq	r0, r0, r0, ror r9
    4734:	000009c0 	andeq	r0, r0, r0, asr #19
    4738:	00003315 	andeq	r3, r0, r5, lsl r3
    473c:	0e00ff00 	cdpeq	15, 0, cr15, cr0, cr0, {0}
    4740:	000009b0 			; <UNDEFINED> instruction: 0x000009b0
    4744:	001ebd0f 	andseq	fp, lr, pc, lsl #26
    4748:	01fc0700 	mvnseq	r0, r0, lsl #14
    474c:	0009c016 	andeq	ip, r9, r6, lsl r0
    4750:	15ff0f00 	ldrbne	r0, [pc, #3840]!	; 5658 <shift+0x5658>
    4754:	02070000 	andeq	r0, r7, #0
    4758:	09c01602 	stmibeq	r0, {r1, r9, sl, ip}^
    475c:	53170000 	tstpl	r7, #0
    4760:	01000027 	tsteq	r0, r7, lsr #32
    4764:	880103b3 	stmdahi	r1, {r0, r1, r4, r5, r7, r8, r9}
    4768:	40000009 	andmi	r0, r0, r9
    476c:	2800009b 	stmdacs	r0, {r0, r1, r3, r4, r7}
    4770:	01000001 	tsteq	r0, r1
    4774:	000ab19c 	muleq	sl, ip, r1
    4778:	006e1800 	rsbeq	r1, lr, r0, lsl #16
    477c:	1703b301 	strne	fp, [r3, -r1, lsl #6]
    4780:	00000988 	andeq	r0, r0, r8, lsl #19
    4784:	00000157 	andeq	r0, r0, r7, asr r1
    4788:	00000153 	andeq	r0, r0, r3, asr r1
    478c:	01006418 	tsteq	r0, r8, lsl r4
    4790:	882203b3 	stmdahi	r2!, {r0, r1, r4, r5, r7, r8, r9}
    4794:	83000009 	movwhi	r0, #9
    4798:	7f000001 	svcvc	0x00000001
    479c:	19000001 	stmdbne	r0, {r0}
    47a0:	01007072 	tsteq	r0, r2, ror r0
    47a4:	b12e03b3 			; <UNDEFINED> instruction: 0xb12e03b3
    47a8:	0200000a 	andeq	r0, r0, #10
    47ac:	711a0091 			; <UNDEFINED> instruction: 0x711a0091
    47b0:	03b50100 			; <UNDEFINED> instruction: 0x03b50100
    47b4:	0009880b 	andeq	r8, r9, fp, lsl #16
    47b8:	0001b300 	andeq	fp, r1, r0, lsl #6
    47bc:	0001ab00 	andeq	sl, r1, r0, lsl #22
    47c0:	00721a00 	rsbseq	r1, r2, r0, lsl #20
    47c4:	1203b501 	andne	fp, r3, #4194304	; 0x400000
    47c8:	00000988 	andeq	r0, r0, r8, lsl #19
    47cc:	00000209 	andeq	r0, r0, r9, lsl #4
    47d0:	000001ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    47d4:	0100791a 	tsteq	r0, sl, lsl r9
    47d8:	881903b5 	ldmdahi	r9, {r0, r2, r4, r5, r7, r8, r9}
    47dc:	67000009 	strvs	r0, [r0, -r9]
    47e0:	61000002 	tstvs	r0, r2
    47e4:	1b000002 	blne	47f4 <shift+0x47f4>
    47e8:	00317a6c 	eorseq	r7, r1, ip, ror #20
    47ec:	0a03b601 	beq	f1ff8 <__bss_end+0xe8300>
    47f0:	0000097c 	andeq	r0, r0, ip, ror r9
    47f4:	327a6c1a 	rsbscc	r6, sl, #6656	; 0x1a00
    47f8:	03b60100 			; <UNDEFINED> instruction: 0x03b60100
    47fc:	00097c0f 	andeq	r7, r9, pc, lsl #24
    4800:	0002a100 	andeq	sl, r2, r0, lsl #2
    4804:	00029f00 	andeq	r9, r2, r0, lsl #30
    4808:	00691a00 	rsbeq	r1, r9, r0, lsl #20
    480c:	1403b601 	strne	fp, [r3], #-1537	; 0xfffff9ff
    4810:	0000097c 	andeq	r0, r0, ip, ror r9
    4814:	000002c0 	andeq	r0, r0, r0, asr #5
    4818:	000002b4 			; <UNDEFINED> instruction: 0x000002b4
    481c:	01006b1a 	tsteq	r0, sl, lsl fp
    4820:	7c1703b6 	ldcvc	3, cr0, [r7], {182}	; 0xb6
    4824:	12000009 	andne	r0, r0, #9
    4828:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    482c:	00000003 	andeq	r0, r0, r3
    4830:	09880405 	stmibeq	r8, {r0, r2, sl}
    4834:	Address 0x0000000000004834 is out of bounds.


Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x376f1c>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb9024>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9044>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb905c>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z7strncmpPKcS0_i+0x84>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe79b9c>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39080>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f6fb0>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b63fc>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b9c60>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c4c18>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b6428>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b649c>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x377018>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9118>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe79c54>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe39138>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb9150>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe79c88>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c4cc4>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x377108>
 198:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 19c:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 1a0:	11000019 	tstne	r0, r9, lsl r0
 1a4:	1347012e 	movtne	r0, #28974	; 0x712e
 1a8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 1ac:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 1b0:	00130119 	andseq	r0, r3, r9, lsl r1
 1b4:	00051200 	andeq	r1, r5, r0, lsl #4
 1b8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 1bc:	05130000 	ldreq	r0, [r3, #-0]
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f70d0>
 1c4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 1c8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 1cc:	14000018 	strne	r0, [r0], #-24	; 0xffffffe8
 1d0:	1347012e 	movtne	r0, #28974	; 0x712e
 1d4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 1d8:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 1dc:	00000019 	andeq	r0, r0, r9, lsl r0
 1e0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 1e4:	030b130e 	movweq	r1, #45838	; 0xb30e
 1e8:	110e1b0e 	tstne	lr, lr, lsl #22
 1ec:	10061201 	andne	r1, r6, r1, lsl #4
 1f0:	02000017 	andeq	r0, r0, #23
 1f4:	0b0b0024 	bleq	2c028c <__bss_end+0x2b6594>
 1f8:	0e030b3e 	vmoveq.16	d3[0], r0
 1fc:	26030000 	strcs	r0, [r3], -r0
 200:	00134900 	andseq	r4, r3, r0, lsl #18
 204:	00240400 	eoreq	r0, r4, r0, lsl #8
 208:	0b3e0b0b 	bleq	f82e3c <__bss_end+0xf79144>
 20c:	00000803 	andeq	r0, r0, r3, lsl #16
 210:	03001605 	movweq	r1, #1541	; 0x605
 214:	3b0b3a0e 	blcc	2cea54 <__bss_end+0x2c4d5c>
 218:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 21c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 220:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 224:	0b3a0b0b 	bleq	e82e58 <__bss_end+0xe79160>
 228:	0b390b3b 	bleq	e42f1c <__bss_end+0xe39224>
 22c:	00001301 	andeq	r1, r0, r1, lsl #6
 230:	03000d07 	movweq	r0, #3335	; 0xd07
 234:	3b0b3a08 	blcc	2cea5c <__bss_end+0x2c4d64>
 238:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 23c:	000b3813 	andeq	r3, fp, r3, lsl r8
 240:	01040800 	tsteq	r4, r0, lsl #16
 244:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 248:	0b0b0b3e 	bleq	2c2f48 <__bss_end+0x2b9250>
 24c:	0b3a1349 	bleq	e84f78 <__bss_end+0xe7b280>
 250:	0b390b3b 	bleq	e42f44 <__bss_end+0xe3924c>
 254:	00001301 	andeq	r1, r0, r1, lsl #6
 258:	03002809 	movweq	r2, #2057	; 0x809
 25c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 260:	00340a00 	eorseq	r0, r4, r0, lsl #20
 264:	0b3a0e03 	bleq	e83a78 <__bss_end+0xe79d80>
 268:	0b390b3b 	bleq	e42f5c <__bss_end+0xe39264>
 26c:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 270:	00001802 	andeq	r1, r0, r2, lsl #16
 274:	0300020b 	movweq	r0, #523	; 0x20b
 278:	00193c0e 	andseq	r3, r9, lr, lsl #24
 27c:	01020c00 	tsteq	r2, r0, lsl #24
 280:	0b0b0e03 	bleq	2c3a94 <__bss_end+0x2b9d9c>
 284:	0b3b0b3a 	bleq	ec2f74 <__bss_end+0xeb927c>
 288:	13010b39 	movwne	r0, #6969	; 0x1b39
 28c:	0d0d0000 	stceq	0, cr0, [sp, #-0]
 290:	3a0e0300 	bcc	380e98 <__bss_end+0x3771a0>
 294:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 298:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 29c:	0e00000b 	cdpeq	0, 0, cr0, cr0, cr11, {0}
 2a0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 2a4:	0b3a0e03 	bleq	e83ab8 <__bss_end+0xe79dc0>
 2a8:	0b390b3b 	bleq	e42f9c <__bss_end+0xe392a4>
 2ac:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 2b0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 2b4:	050f0000 	streq	r0, [pc, #-0]	; 2bc <shift+0x2bc>
 2b8:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 2bc:	10000019 	andne	r0, r0, r9, lsl r0
 2c0:	13490005 	movtne	r0, #36869	; 0x9005
 2c4:	0d110000 	ldceq	0, cr0, [r1, #-0]
 2c8:	3a0e0300 	bcc	380ed0 <__bss_end+0x3771d8>
 2cc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2d0:	3f13490b 	svccc	0x0013490b
 2d4:	00193c19 	andseq	r3, r9, r9, lsl ip
 2d8:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
 2dc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2e0:	0b3b0b3a 	bleq	ec2fd0 <__bss_end+0xeb92d8>
 2e4:	0e6e0b39 	vmoveq.8	d14[5], r0
 2e8:	0b321349 	bleq	c85014 <__bss_end+0xc7b31c>
 2ec:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 2f0:	00001301 	andeq	r1, r0, r1, lsl #6
 2f4:	3f012e13 	svccc	0x00012e13
 2f8:	3a0e0319 	bcc	380f64 <__bss_end+0x37726c>
 2fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 300:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 304:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 308:	00130113 	andseq	r0, r3, r3, lsl r1
 30c:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 310:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 314:	0b3b0b3a 	bleq	ec3004 <__bss_end+0xeb930c>
 318:	0e6e0b39 	vmoveq.8	d14[5], r0
 31c:	0b321349 	bleq	c85048 <__bss_end+0xc7b350>
 320:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 324:	01150000 	tsteq	r5, r0
 328:	01134901 	tsteq	r3, r1, lsl #18
 32c:	16000013 			; <UNDEFINED> instruction: 0x16000013
 330:	13490021 	movtne	r0, #36897	; 0x9021
 334:	00000b2f 	andeq	r0, r0, pc, lsr #22
 338:	0b000f17 	bleq	3f9c <shift+0x3f9c>
 33c:	0013490b 	andseq	r4, r3, fp, lsl #18
 340:	00211800 	eoreq	r1, r1, r0, lsl #16
 344:	34190000 	ldrcc	r0, [r9], #-0
 348:	3a0e0300 	bcc	380f50 <__bss_end+0x377258>
 34c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 350:	3f13490b 	svccc	0x0013490b
 354:	00193c19 	andseq	r3, r9, r9, lsl ip
 358:	00281a00 	eoreq	r1, r8, r0, lsl #20
 35c:	0b1c0803 	bleq	702370 <__bss_end+0x6f8678>
 360:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
 364:	03193f01 	tsteq	r9, #1, 30
 368:	3b0b3a0e 	blcc	2ceba8 <__bss_end+0x2c4eb0>
 36c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 370:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
 374:	00130113 	andseq	r0, r3, r3, lsl r1
 378:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 37c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 380:	0b3b0b3a 	bleq	ec3070 <__bss_end+0xeb9378>
 384:	0e6e0b39 	vmoveq.8	d14[5], r0
 388:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 38c:	13011364 	movwne	r1, #4964	; 0x1364
 390:	0d1d0000 	ldceq	0, cr0, [sp, #-0]
 394:	3a0e0300 	bcc	380f9c <__bss_end+0x3772a4>
 398:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 39c:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 3a0:	000b320b 	andeq	r3, fp, fp, lsl #4
 3a4:	01151e00 	tsteq	r5, r0, lsl #28
 3a8:	13641349 	cmnne	r4, #603979777	; 0x24000001
 3ac:	00001301 	andeq	r1, r0, r1, lsl #6
 3b0:	1d001f1f 	stcne	15, cr1, [r0, #-124]	; 0xffffff84
 3b4:	00134913 	andseq	r4, r3, r3, lsl r9
 3b8:	00102000 	andseq	r2, r0, r0
 3bc:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 3c0:	0f210000 	svceq	0x00210000
 3c4:	000b0b00 	andeq	r0, fp, r0, lsl #22
 3c8:	012e2200 			; <UNDEFINED> instruction: 0x012e2200
 3cc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 3d0:	0b3b0b3a 	bleq	ec30c0 <__bss_end+0xeb93c8>
 3d4:	13490b39 	movtne	r0, #39737	; 0x9b39
 3d8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 3dc:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 3e0:	00130119 	andseq	r0, r3, r9, lsl r1
 3e4:	00052300 	andeq	r2, r5, r0, lsl #6
 3e8:	0b3a0e03 	bleq	e83bfc <__bss_end+0xe79f04>
 3ec:	0b390b3b 	bleq	e430e0 <__bss_end+0xe393e8>
 3f0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 3f4:	01000000 	mrseq	r0, (UNDEF: 0)
 3f8:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 3fc:	0e030b13 	vmoveq.32	d3[0], r0
 400:	01110e1b 	tsteq	r1, fp, lsl lr
 404:	17100612 			; <UNDEFINED> instruction: 0x17100612
 408:	24020000 	strcs	r0, [r2], #-0
 40c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 410:	000e030b 	andeq	r0, lr, fp, lsl #6
 414:	00260300 	eoreq	r0, r6, r0, lsl #6
 418:	00001349 	andeq	r1, r0, r9, asr #6
 41c:	0b002404 	bleq	9434 <_Z8is_floatPKc+0x60>
 420:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 424:	05000008 	streq	r0, [r0, #-8]
 428:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 42c:	0b3b0b3a 	bleq	ec311c <__bss_end+0xeb9424>
 430:	13490b39 	movtne	r0, #39737	; 0x9b39
 434:	13060000 	movwne	r0, #24576	; 0x6000
 438:	0b0e0301 	bleq	381044 <__bss_end+0x37734c>
 43c:	3b0b3a0b 	blcc	2cec70 <__bss_end+0x2c4f78>
 440:	010b390b 	tsteq	fp, fp, lsl #18
 444:	07000013 	smladeq	r0, r3, r0, r0
 448:	0803000d 	stmdaeq	r3, {r0, r2, r3}
 44c:	0b3b0b3a 	bleq	ec313c <__bss_end+0xeb9444>
 450:	13490b39 	movtne	r0, #39737	; 0x9b39
 454:	00000b38 	andeq	r0, r0, r8, lsr fp
 458:	03010408 	movweq	r0, #5128	; 0x1408
 45c:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 460:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 464:	3b0b3a13 	blcc	2cecb8 <__bss_end+0x2c4fc0>
 468:	010b390b 	tsteq	fp, fp, lsl #18
 46c:	09000013 	stmdbeq	r0, {r0, r1, r4}
 470:	08030028 	stmdaeq	r3, {r3, r5}
 474:	00000b1c 	andeq	r0, r0, ip, lsl fp
 478:	0300280a 	movweq	r2, #2058	; 0x80a
 47c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 480:	00340b00 	eorseq	r0, r4, r0, lsl #22
 484:	0b3a0e03 	bleq	e83c98 <__bss_end+0xe79fa0>
 488:	0b390b3b 	bleq	e4317c <__bss_end+0xe39484>
 48c:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 490:	00001802 	andeq	r1, r0, r2, lsl #16
 494:	0300020c 	movweq	r0, #524	; 0x20c
 498:	00193c0e 	andseq	r3, r9, lr, lsl #24
 49c:	01020d00 	tsteq	r2, r0, lsl #26
 4a0:	0b0b0e03 	bleq	2c3cb4 <__bss_end+0x2b9fbc>
 4a4:	0b3b0b3a 	bleq	ec3194 <__bss_end+0xeb949c>
 4a8:	13010b39 	movwne	r0, #6969	; 0x1b39
 4ac:	0d0e0000 	stceq	0, cr0, [lr, #-0]
 4b0:	3a0e0300 	bcc	3810b8 <__bss_end+0x3773c0>
 4b4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4b8:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 4bc:	0f00000b 	svceq	0x0000000b
 4c0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 4c4:	0b3a0e03 	bleq	e83cd8 <__bss_end+0xe79fe0>
 4c8:	0b390b3b 	bleq	e431bc <__bss_end+0xe394c4>
 4cc:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 4d0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 4d4:	05100000 	ldreq	r0, [r0, #-0]
 4d8:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 4dc:	11000019 	tstne	r0, r9, lsl r0
 4e0:	13490005 	movtne	r0, #36869	; 0x9005
 4e4:	0d120000 	ldceq	0, cr0, [r2, #-0]
 4e8:	3a0e0300 	bcc	3810f0 <__bss_end+0x3773f8>
 4ec:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4f0:	3f13490b 	svccc	0x0013490b
 4f4:	00193c19 	andseq	r3, r9, r9, lsl ip
 4f8:	012e1300 			; <UNDEFINED> instruction: 0x012e1300
 4fc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 500:	0b3b0b3a 	bleq	ec31f0 <__bss_end+0xeb94f8>
 504:	0e6e0b39 	vmoveq.8	d14[5], r0
 508:	0b321349 	bleq	c85234 <__bss_end+0xc7b53c>
 50c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 510:	00001301 	andeq	r1, r0, r1, lsl #6
 514:	3f012e14 	svccc	0x00012e14
 518:	3a0e0319 	bcc	381184 <__bss_end+0x37748c>
 51c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 520:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 524:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 528:	00130113 	andseq	r0, r3, r3, lsl r1
 52c:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
 530:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 534:	0b3b0b3a 	bleq	ec3224 <__bss_end+0xeb952c>
 538:	0e6e0b39 	vmoveq.8	d14[5], r0
 53c:	0b321349 	bleq	c85268 <__bss_end+0xc7b570>
 540:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 544:	01160000 	tsteq	r6, r0
 548:	01134901 	tsteq	r3, r1, lsl #18
 54c:	17000013 	smladne	r0, r3, r0, r0
 550:	13490021 	movtne	r0, #36897	; 0x9021
 554:	00000b2f 	andeq	r0, r0, pc, lsr #22
 558:	0b000f18 	bleq	41c0 <shift+0x41c0>
 55c:	0013490b 	andseq	r4, r3, fp, lsl #18
 560:	00211900 	eoreq	r1, r1, r0, lsl #18
 564:	341a0000 	ldrcc	r0, [sl], #-0
 568:	3a0e0300 	bcc	381170 <__bss_end+0x377478>
 56c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 570:	3f13490b 	svccc	0x0013490b
 574:	00193c19 	andseq	r3, r9, r9, lsl ip
 578:	012e1b00 			; <UNDEFINED> instruction: 0x012e1b00
 57c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 580:	0b3b0b3a 	bleq	ec3270 <__bss_end+0xeb9578>
 584:	0e6e0b39 	vmoveq.8	d14[5], r0
 588:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 58c:	00001301 	andeq	r1, r0, r1, lsl #6
 590:	3f012e1c 	svccc	0x00012e1c
 594:	3a0e0319 	bcc	381200 <__bss_end+0x377508>
 598:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 59c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 5a0:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 5a4:	00130113 	andseq	r0, r3, r3, lsl r1
 5a8:	000d1d00 	andeq	r1, sp, r0, lsl #26
 5ac:	0b3a0e03 	bleq	e83dc0 <__bss_end+0xe7a0c8>
 5b0:	0b390b3b 	bleq	e432a4 <__bss_end+0xe395ac>
 5b4:	0b381349 	bleq	e052e0 <__bss_end+0xdfb5e8>
 5b8:	00000b32 	andeq	r0, r0, r2, lsr fp
 5bc:	4901151e 	stmdbmi	r1, {r1, r2, r3, r4, r8, sl, ip}
 5c0:	01136413 	tsteq	r3, r3, lsl r4
 5c4:	1f000013 	svcne	0x00000013
 5c8:	131d001f 	tstne	sp, #31
 5cc:	00001349 	andeq	r1, r0, r9, asr #6
 5d0:	0b001020 	bleq	4658 <shift+0x4658>
 5d4:	0013490b 	andseq	r4, r3, fp, lsl #18
 5d8:	000f2100 	andeq	r2, pc, r0, lsl #2
 5dc:	00000b0b 	andeq	r0, r0, fp, lsl #22
 5e0:	03003422 	movweq	r3, #1058	; 0x422
 5e4:	3b0b3a0e 	blcc	2cee24 <__bss_end+0x2c512c>
 5e8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 5ec:	00180213 	andseq	r0, r8, r3, lsl r2
 5f0:	012e2300 			; <UNDEFINED> instruction: 0x012e2300
 5f4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5f8:	0b3b0b3a 	bleq	ec32e8 <__bss_end+0xeb95f0>
 5fc:	0e6e0b39 	vmoveq.8	d14[5], r0
 600:	01111349 	tsteq	r1, r9, asr #6
 604:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 608:	01194296 			; <UNDEFINED> instruction: 0x01194296
 60c:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 610:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 614:	0b3b0b3a 	bleq	ec3304 <__bss_end+0xeb960c>
 618:	13490b39 	movtne	r0, #39737	; 0x9b39
 61c:	00001802 	andeq	r1, r0, r2, lsl #16
 620:	3f012e25 	svccc	0x00012e25
 624:	3a0e0319 	bcc	381290 <__bss_end+0x377598>
 628:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 62c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 630:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 634:	97184006 	ldrls	r4, [r8, -r6]
 638:	13011942 	movwne	r1, #6466	; 0x1942
 63c:	34260000 	strtcc	r0, [r6], #-0
 640:	3a080300 	bcc	201248 <__bss_end+0x1f7550>
 644:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 648:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 64c:	27000018 	smladcs	r0, r8, r0, r0
 650:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 654:	0b3a0e03 	bleq	e83e68 <__bss_end+0xe7a170>
 658:	0b390b3b 	bleq	e4334c <__bss_end+0xe39654>
 65c:	01110e6e 	tsteq	r1, lr, ror #28
 660:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 664:	01194297 			; <UNDEFINED> instruction: 0x01194297
 668:	28000013 	stmdacs	r0, {r0, r1, r4}
 66c:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 670:	0b3a0e03 	bleq	e83e84 <__bss_end+0xe7a18c>
 674:	0b390b3b 	bleq	e43368 <__bss_end+0xe39670>
 678:	01110e6e 	tsteq	r1, lr, ror #28
 67c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 680:	00194297 	mulseq	r9, r7, r2
 684:	012e2900 			; <UNDEFINED> instruction: 0x012e2900
 688:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 68c:	0b3b0b3a 	bleq	ec337c <__bss_end+0xeb9684>
 690:	0e6e0b39 	vmoveq.8	d14[5], r0
 694:	01111349 	tsteq	r1, r9, asr #6
 698:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 69c:	00194297 	mulseq	r9, r7, r2
 6a0:	11010000 	mrsne	r0, (UNDEF: 1)
 6a4:	130e2501 	movwne	r2, #58625	; 0xe501
 6a8:	1b0e030b 	blne	3812dc <__bss_end+0x3775e4>
 6ac:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 6b0:	00171006 	andseq	r1, r7, r6
 6b4:	01390200 	teqeq	r9, r0, lsl #4
 6b8:	00001301 	andeq	r1, r0, r1, lsl #6
 6bc:	03003403 	movweq	r3, #1027	; 0x403
 6c0:	3b0b3a0e 	blcc	2cef00 <__bss_end+0x2c5208>
 6c4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 6c8:	1c193c13 	ldcne	12, cr3, [r9], {19}
 6cc:	0400000a 	streq	r0, [r0], #-10
 6d0:	0b3a003a 	bleq	e807c0 <__bss_end+0xe76ac8>
 6d4:	0b390b3b 	bleq	e433c8 <__bss_end+0xe396d0>
 6d8:	00001318 	andeq	r1, r0, r8, lsl r3
 6dc:	49010105 	stmdbmi	r1, {r0, r2, r8}
 6e0:	00130113 	andseq	r0, r3, r3, lsl r1
 6e4:	00210600 	eoreq	r0, r1, r0, lsl #12
 6e8:	0b2f1349 	bleq	bc5414 <__bss_end+0xbbb71c>
 6ec:	26070000 	strcs	r0, [r7], -r0
 6f0:	00134900 	andseq	r4, r3, r0, lsl #18
 6f4:	00240800 	eoreq	r0, r4, r0, lsl #16
 6f8:	0b3e0b0b 	bleq	f8332c <__bss_end+0xf79634>
 6fc:	00000e03 	andeq	r0, r0, r3, lsl #28
 700:	47003409 	strmi	r3, [r0, -r9, lsl #8]
 704:	0a000013 	beq	758 <shift+0x758>
 708:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 70c:	0b3a0e03 	bleq	e83f20 <__bss_end+0xe7a228>
 710:	0b390b3b 	bleq	e43404 <__bss_end+0xe3970c>
 714:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 718:	06120111 			; <UNDEFINED> instruction: 0x06120111
 71c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 720:	00130119 	andseq	r0, r3, r9, lsl r1
 724:	00050b00 	andeq	r0, r5, r0, lsl #22
 728:	0b3a0803 	bleq	e8273c <__bss_end+0xe78a44>
 72c:	0b390b3b 	bleq	e43420 <__bss_end+0xe39728>
 730:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 734:	340c0000 	strcc	r0, [ip], #-0
 738:	3a080300 	bcc	201340 <__bss_end+0x1f7648>
 73c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 740:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 744:	0d000018 	stceq	0, cr0, [r0, #-96]	; 0xffffffa0
 748:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 74c:	0b3b0b3a 	bleq	ec343c <__bss_end+0xeb9744>
 750:	13490b39 	movtne	r0, #39737	; 0x9b39
 754:	00001802 	andeq	r1, r0, r2, lsl #16
 758:	0b000f0e 	bleq	4398 <shift+0x4398>
 75c:	0013490b 	andseq	r4, r3, fp, lsl #18
 760:	00240f00 	eoreq	r0, r4, r0, lsl #30
 764:	0b3e0b0b 	bleq	f83398 <__bss_end+0xf796a0>
 768:	00000803 	andeq	r0, r0, r3, lsl #16
 76c:	3f012e10 	svccc	0x00012e10
 770:	3a0e0319 	bcc	3813dc <__bss_end+0x3776e4>
 774:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 778:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 77c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 780:	97184006 	ldrls	r4, [r8, -r6]
 784:	13011942 	movwne	r1, #6466	; 0x1942
 788:	2e110000 	cdpcs	0, 1, cr0, cr1, cr0, {0}
 78c:	03193f01 	tsteq	r9, #1, 30
 790:	3b0b3a0e 	blcc	2cefd0 <__bss_end+0x2c52d8>
 794:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 798:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 79c:	97184006 	ldrls	r4, [r8, -r6]
 7a0:	13011942 	movwne	r1, #6466	; 0x1942
 7a4:	0b120000 	bleq	4807ac <__bss_end+0x476ab4>
 7a8:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 7ac:	13000006 	movwne	r0, #6
 7b0:	00000026 	andeq	r0, r0, r6, lsr #32
 7b4:	0b000f14 	bleq	440c <shift+0x440c>
 7b8:	1500000b 	strne	r0, [r0, #-11]
 7bc:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 7c0:	0b3b0b3a 	bleq	ec34b0 <__bss_end+0xeb97b8>
 7c4:	13490b39 	movtne	r0, #39737	; 0x9b39
 7c8:	00001802 	andeq	r1, r0, r2, lsl #16
 7cc:	3f012e16 	svccc	0x00012e16
 7d0:	3a0e0319 	bcc	38143c <__bss_end+0x377744>
 7d4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7d8:	110e6e0b 	tstne	lr, fp, lsl #28
 7dc:	40061201 	andmi	r1, r6, r1, lsl #4
 7e0:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 7e4:	00001301 	andeq	r1, r0, r1, lsl #6
 7e8:	3f012e17 	svccc	0x00012e17
 7ec:	3a0e0319 	bcc	381458 <__bss_end+0x377760>
 7f0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7f4:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 7f8:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 7fc:	97184006 	ldrls	r4, [r8, -r6]
 800:	00001942 	andeq	r1, r0, r2, asr #18
 804:	00110100 	andseq	r0, r1, r0, lsl #2
 808:	01110610 	tsteq	r1, r0, lsl r6
 80c:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
 810:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
 814:	00000513 	andeq	r0, r0, r3, lsl r5
 818:	00110100 	andseq	r0, r1, r0, lsl #2
 81c:	01110610 	tsteq	r1, r0, lsl r6
 820:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
 824:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
 828:	00000513 	andeq	r0, r0, r3, lsl r5
 82c:	00110100 	andseq	r0, r1, r0, lsl #2
 830:	01110610 	tsteq	r1, r0, lsl r6
 834:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
 838:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
 83c:	00000513 	andeq	r0, r0, r3, lsl r5
 840:	00110100 	andseq	r0, r1, r0, lsl #2
 844:	01110610 	tsteq	r1, r0, lsl r6
 848:	0e030112 	mcreq	1, 0, r0, cr3, cr2, {0}
 84c:	0e250e1b 	mcreq	14, 1, r0, cr5, cr11, {0}
 850:	00000513 	andeq	r0, r0, r3, lsl r5
 854:	01110100 	tsteq	r1, r0, lsl #2
 858:	0b130e25 	bleq	4c40f4 <__bss_end+0x4ba3fc>
 85c:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 860:	00001710 	andeq	r1, r0, r0, lsl r7
 864:	0b002402 	bleq	9874 <__addsf3+0xbc>
 868:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 86c:	03000008 	movweq	r0, #8
 870:	0b0b0024 	bleq	2c0908 <__bss_end+0x2b6c10>
 874:	0e030b3e 	vmoveq.16	d3[0], r0
 878:	16040000 	strne	r0, [r4], -r0
 87c:	3a0e0300 	bcc	381484 <__bss_end+0x37778c>
 880:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 884:	0013490b 	andseq	r4, r3, fp, lsl #18
 888:	000f0500 	andeq	r0, pc, r0, lsl #10
 88c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 890:	15060000 	strne	r0, [r6, #-0]
 894:	49192701 	ldmdbmi	r9, {r0, r8, r9, sl, sp}
 898:	00130113 	andseq	r0, r3, r3, lsl r1
 89c:	00050700 	andeq	r0, r5, r0, lsl #14
 8a0:	00001349 	andeq	r1, r0, r9, asr #6
 8a4:	00002608 	andeq	r2, r0, r8, lsl #12
 8a8:	00340900 	eorseq	r0, r4, r0, lsl #18
 8ac:	0b3a0e03 	bleq	e840c0 <__bss_end+0xe7a3c8>
 8b0:	0b390b3b 	bleq	e435a4 <__bss_end+0xe398ac>
 8b4:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 8b8:	0000193c 	andeq	r1, r0, ip, lsr r9
 8bc:	0301040a 	movweq	r0, #5130	; 0x140a
 8c0:	0b0b3e0e 	bleq	2d0100 <__bss_end+0x2c6408>
 8c4:	3a13490b 	bcc	4d2cf8 <__bss_end+0x4c9000>
 8c8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8cc:	0013010b 	andseq	r0, r3, fp, lsl #2
 8d0:	00280b00 	eoreq	r0, r8, r0, lsl #22
 8d4:	0b1c0e03 	bleq	7040e8 <__bss_end+0x6fa3f0>
 8d8:	010c0000 	mrseq	r0, (UNDEF: 12)
 8dc:	01134901 	tsteq	r3, r1, lsl #18
 8e0:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
 8e4:	00000021 	andeq	r0, r0, r1, lsr #32
 8e8:	4900260e 	stmdbmi	r0, {r1, r2, r3, r9, sl, sp}
 8ec:	0f000013 	svceq	0x00000013
 8f0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 8f4:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 8f8:	13490b39 	movtne	r0, #39737	; 0x9b39
 8fc:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 900:	13100000 	tstne	r0, #0
 904:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 908:	11000019 	tstne	r0, r9, lsl r0
 90c:	19270015 	stmdbne	r7!, {r0, r2, r4}
 910:	17120000 	ldrne	r0, [r2, -r0]
 914:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 918:	13000019 	movwne	r0, #25
 91c:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 920:	0b3a0b0b 	bleq	e83554 <__bss_end+0xe7985c>
 924:	0b39053b 	bleq	e41e18 <__bss_end+0xe38120>
 928:	00001301 	andeq	r1, r0, r1, lsl #6
 92c:	03000d14 	movweq	r0, #3348	; 0xd14
 930:	3b0b3a0e 	blcc	2cf170 <__bss_end+0x2c5478>
 934:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 938:	000b3813 	andeq	r3, fp, r3, lsl r8
 93c:	00211500 	eoreq	r1, r1, r0, lsl #10
 940:	0b2f1349 	bleq	bc566c <__bss_end+0xbbb974>
 944:	04160000 	ldreq	r0, [r6], #-0
 948:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 94c:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 950:	3b0b3a13 	blcc	2cf1a4 <__bss_end+0x2c54ac>
 954:	010b3905 	tsteq	fp, r5, lsl #18
 958:	17000013 	smladne	r0, r3, r0, r0
 95c:	13470034 	movtne	r0, #28724	; 0x7034
 960:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 964:	18020b39 	stmdane	r2, {r0, r3, r4, r5, r8, r9, fp}
 968:	01000000 	mrseq	r0, (UNDEF: 0)
 96c:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 970:	0e030b13 	vmoveq.32	d3[0], r0
 974:	01110e1b 	tsteq	r1, fp, lsl lr
 978:	17100612 			; <UNDEFINED> instruction: 0x17100612
 97c:	24020000 	strcs	r0, [r2], #-0
 980:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 984:	000e030b 	andeq	r0, lr, fp, lsl #6
 988:	00240300 	eoreq	r0, r4, r0, lsl #6
 98c:	0b3e0b0b 	bleq	f835c0 <__bss_end+0xf798c8>
 990:	00000803 	andeq	r0, r0, r3, lsl #16
 994:	03001604 	movweq	r1, #1540	; 0x604
 998:	3b0b3a0e 	blcc	2cf1d8 <__bss_end+0x2c54e0>
 99c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 9a0:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 9a4:	0b0b000f 	bleq	2c09e8 <__bss_end+0x2b6cf0>
 9a8:	00001349 	andeq	r1, r0, r9, asr #6
 9ac:	27011506 	strcs	r1, [r1, -r6, lsl #10]
 9b0:	01134919 	tsteq	r3, r9, lsl r9
 9b4:	07000013 	smladeq	r0, r3, r0, r0
 9b8:	13490005 	movtne	r0, #36869	; 0x9005
 9bc:	26080000 	strcs	r0, [r8], -r0
 9c0:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
 9c4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 9c8:	0b3b0b3a 	bleq	ec36b8 <__bss_end+0xeb99c0>
 9cc:	13490b39 	movtne	r0, #39737	; 0x9b39
 9d0:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 9d4:	040a0000 	streq	r0, [sl], #-0
 9d8:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 9dc:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 9e0:	3b0b3a13 	blcc	2cf234 <__bss_end+0x2c553c>
 9e4:	010b390b 	tsteq	fp, fp, lsl #18
 9e8:	0b000013 	bleq	a3c <shift+0xa3c>
 9ec:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 9f0:	00000b1c 	andeq	r0, r0, ip, lsl fp
 9f4:	4901010c 	stmdbmi	r1, {r2, r3, r8}
 9f8:	00130113 	andseq	r0, r3, r3, lsl r1
 9fc:	00210d00 	eoreq	r0, r1, r0, lsl #26
 a00:	260e0000 	strcs	r0, [lr], -r0
 a04:	00134900 	andseq	r4, r3, r0, lsl #18
 a08:	00340f00 	eorseq	r0, r4, r0, lsl #30
 a0c:	0b3a0e03 	bleq	e84220 <__bss_end+0xe7a528>
 a10:	0b39053b 	bleq	e41f04 <__bss_end+0xe3820c>
 a14:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 a18:	0000193c 	andeq	r1, r0, ip, lsr r9
 a1c:	03001310 	movweq	r1, #784	; 0x310
 a20:	00193c0e 	andseq	r3, r9, lr, lsl #24
 a24:	00151100 	andseq	r1, r5, r0, lsl #2
 a28:	00001927 	andeq	r1, r0, r7, lsr #18
 a2c:	03001712 	movweq	r1, #1810	; 0x712
 a30:	00193c0e 	andseq	r3, r9, lr, lsl #24
 a34:	01131300 	tsteq	r3, r0, lsl #6
 a38:	0b0b0e03 	bleq	2c424c <__bss_end+0x2ba554>
 a3c:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 a40:	13010b39 	movwne	r0, #6969	; 0x1b39
 a44:	0d140000 	ldceq	0, cr0, [r4, #-0]
 a48:	3a0e0300 	bcc	381650 <__bss_end+0x377958>
 a4c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 a50:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 a54:	1500000b 	strne	r0, [r0, #-11]
 a58:	13490021 	movtne	r0, #36897	; 0x9021
 a5c:	00000b2f 	andeq	r0, r0, pc, lsr #22
 a60:	03010416 	movweq	r0, #5142	; 0x1416
 a64:	0b0b3e0e 	bleq	2d02a4 <__bss_end+0x2c65ac>
 a68:	3a13490b 	bcc	4d2e9c <__bss_end+0x4c91a4>
 a6c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 a70:	0013010b 	andseq	r0, r3, fp, lsl #2
 a74:	012e1700 			; <UNDEFINED> instruction: 0x012e1700
 a78:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 a7c:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 a80:	19270b39 	stmdbne	r7!, {r0, r3, r4, r5, r8, r9, fp}
 a84:	01111349 	tsteq	r1, r9, asr #6
 a88:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 a8c:	01194297 			; <UNDEFINED> instruction: 0x01194297
 a90:	18000013 	stmdane	r0, {r0, r1, r4}
 a94:	08030005 	stmdaeq	r3, {r0, r2}
 a98:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 a9c:	13490b39 	movtne	r0, #39737	; 0x9b39
 aa0:	42b71702 	adcsmi	r1, r7, #524288	; 0x80000
 aa4:	19000017 	stmdbne	r0, {r0, r1, r2, r4}
 aa8:	01018289 	smlabbeq	r1, r9, r2, r8
 aac:	42950111 	addsmi	r0, r5, #1073741828	; 0x40000004
 ab0:	01133119 	tsteq	r3, r9, lsl r1
 ab4:	1a000013 	bne	b08 <shift+0xb08>
 ab8:	0001828a 	andeq	r8, r1, sl, lsl #5
 abc:	42911802 	addsmi	r1, r1, #131072	; 0x20000
 ac0:	1b000018 	blne	b28 <shift+0xb28>
 ac4:	01018289 	smlabbeq	r1, r9, r2, r8
 ac8:	13310111 	teqne	r1, #1073741828	; 0x40000004
 acc:	2e1c0000 	cdpcs	0, 1, cr0, cr12, cr0, {0}
 ad0:	3c193f00 	ldccc	15, cr3, [r9], {-0}
 ad4:	030e6e19 	movweq	r6, #60953	; 0xee19
 ad8:	3b0b3a0e 	blcc	2cf318 <__bss_end+0x2c5620>
 adc:	000b390b 	andeq	r3, fp, fp, lsl #18
 ae0:	11010000 	mrsne	r0, (UNDEF: 1)
 ae4:	130e2501 	movwne	r2, #58625	; 0xe501
 ae8:	1b0e030b 	blne	38171c <__bss_end+0x377a24>
 aec:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 af0:	00171006 	andseq	r1, r7, r6
 af4:	00240200 	eoreq	r0, r4, r0, lsl #4
 af8:	0b3e0b0b 	bleq	f8372c <__bss_end+0xf79a34>
 afc:	00000e03 	andeq	r0, r0, r3, lsl #28
 b00:	0b002403 	bleq	9b14 <__aeabi_f2ulz+0x14>
 b04:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 b08:	04000008 	streq	r0, [r0], #-8
 b0c:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 b10:	0b3b0b3a 	bleq	ec3800 <__bss_end+0xeb9b08>
 b14:	13490b39 	movtne	r0, #39737	; 0x9b39
 b18:	0f050000 	svceq	0x00050000
 b1c:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 b20:	06000013 			; <UNDEFINED> instruction: 0x06000013
 b24:	19270115 	stmdbne	r7!, {r0, r2, r4, r8}
 b28:	13011349 	movwne	r1, #4937	; 0x1349
 b2c:	05070000 	streq	r0, [r7, #-0]
 b30:	00134900 	andseq	r4, r3, r0, lsl #18
 b34:	00260800 	eoreq	r0, r6, r0, lsl #16
 b38:	34090000 	strcc	r0, [r9], #-0
 b3c:	3a0e0300 	bcc	381744 <__bss_end+0x377a4c>
 b40:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 b44:	3f13490b 	svccc	0x0013490b
 b48:	00193c19 	andseq	r3, r9, r9, lsl ip
 b4c:	01040a00 	tsteq	r4, r0, lsl #20
 b50:	0b3e0e03 	bleq	f84364 <__bss_end+0xf7a66c>
 b54:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 b58:	0b3b0b3a 	bleq	ec3848 <__bss_end+0xeb9b50>
 b5c:	13010b39 	movwne	r0, #6969	; 0x1b39
 b60:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
 b64:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 b68:	0c00000b 	stceq	0, cr0, [r0], {11}
 b6c:	13490101 	movtne	r0, #37121	; 0x9101
 b70:	00001301 	andeq	r1, r0, r1, lsl #6
 b74:	0000210d 	andeq	r2, r0, sp, lsl #2
 b78:	00260e00 	eoreq	r0, r6, r0, lsl #28
 b7c:	00001349 	andeq	r1, r0, r9, asr #6
 b80:	0300340f 	movweq	r3, #1039	; 0x40f
 b84:	3b0b3a0e 	blcc	2cf3c4 <__bss_end+0x2c56cc>
 b88:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 b8c:	3c193f13 	ldccc	15, cr3, [r9], {19}
 b90:	10000019 	andne	r0, r0, r9, lsl r0
 b94:	0e030013 	mcreq	0, 0, r0, cr3, cr3, {0}
 b98:	0000193c 	andeq	r1, r0, ip, lsr r9
 b9c:	27001511 	smladcs	r0, r1, r5, r1
 ba0:	12000019 	andne	r0, r0, #25
 ba4:	0e030017 	mcreq	0, 0, r0, cr3, cr7, {0}
 ba8:	0000193c 	andeq	r1, r0, ip, lsr r9
 bac:	03011313 	movweq	r1, #4883	; 0x1313
 bb0:	3a0b0b0e 	bcc	2c37f0 <__bss_end+0x2b9af8>
 bb4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 bb8:	0013010b 	andseq	r0, r3, fp, lsl #2
 bbc:	000d1400 	andeq	r1, sp, r0, lsl #8
 bc0:	0b3a0e03 	bleq	e843d4 <__bss_end+0xe7a6dc>
 bc4:	0b39053b 	bleq	e420b8 <__bss_end+0xe383c0>
 bc8:	0b381349 	bleq	e058f4 <__bss_end+0xdfbbfc>
 bcc:	21150000 	tstcs	r5, r0
 bd0:	2f134900 	svccs	0x00134900
 bd4:	1600000b 	strne	r0, [r0], -fp
 bd8:	0e030104 	adfeqs	f0, f3, f4
 bdc:	0b0b0b3e 	bleq	2c38dc <__bss_end+0x2b9be4>
 be0:	0b3a1349 	bleq	e8590c <__bss_end+0xe7bc14>
 be4:	0b39053b 	bleq	e420d8 <__bss_end+0xe383e0>
 be8:	00001301 	andeq	r1, r0, r1, lsl #6
 bec:	3f012e17 	svccc	0x00012e17
 bf0:	3a0e0319 	bcc	38185c <__bss_end+0x377b64>
 bf4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 bf8:	4919270b 	ldmdbmi	r9, {r0, r1, r3, r8, r9, sl, sp}
 bfc:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 c00:	97184006 	ldrls	r4, [r8, -r6]
 c04:	00001942 	andeq	r1, r0, r2, asr #18
 c08:	03000518 	movweq	r0, #1304	; 0x518
 c0c:	3b0b3a08 	blcc	2cf434 <__bss_end+0x2c573c>
 c10:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 c14:	b7170213 			; <UNDEFINED> instruction: 0xb7170213
 c18:	00001742 	andeq	r1, r0, r2, asr #14
 c1c:	03003419 	movweq	r3, #1049	; 0x419
 c20:	3b0b3a08 	blcc	2cf448 <__bss_end+0x2c5750>
 c24:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 c28:	b7170213 			; <UNDEFINED> instruction: 0xb7170213
 c2c:	00001742 	andeq	r1, r0, r2, asr #14
 c30:	01110100 	tsteq	r1, r0, lsl #2
 c34:	0b130e25 	bleq	4c44d0 <__bss_end+0x4ba7d8>
 c38:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 c3c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 c40:	00001710 	andeq	r1, r0, r0, lsl r7
 c44:	0b002402 	bleq	9c54 <__udivmoddi4+0x114>
 c48:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 c4c:	0300000e 	movweq	r0, #14
 c50:	0b0b0024 	bleq	2c0ce8 <__bss_end+0x2b6ff0>
 c54:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 c58:	16040000 	strne	r0, [r4], -r0
 c5c:	3a0e0300 	bcc	381864 <__bss_end+0x377b6c>
 c60:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 c64:	0013490b 	andseq	r4, r3, fp, lsl #18
 c68:	000f0500 	andeq	r0, pc, r0, lsl #10
 c6c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 c70:	15060000 	strne	r0, [r6, #-0]
 c74:	49192701 	ldmdbmi	r9, {r0, r8, r9, sl, sp}
 c78:	00130113 	andseq	r0, r3, r3, lsl r1
 c7c:	00050700 	andeq	r0, r5, r0, lsl #14
 c80:	00001349 	andeq	r1, r0, r9, asr #6
 c84:	00002608 	andeq	r2, r0, r8, lsl #12
 c88:	00340900 	eorseq	r0, r4, r0, lsl #18
 c8c:	0b3a0e03 	bleq	e844a0 <__bss_end+0xe7a7a8>
 c90:	0b390b3b 	bleq	e43984 <__bss_end+0xe39c8c>
 c94:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 c98:	0000193c 	andeq	r1, r0, ip, lsr r9
 c9c:	0301040a 	movweq	r0, #5130	; 0x140a
 ca0:	0b0b3e0e 	bleq	2d04e0 <__bss_end+0x2c67e8>
 ca4:	3a13490b 	bcc	4d30d8 <__bss_end+0x4c93e0>
 ca8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 cac:	0013010b 	andseq	r0, r3, fp, lsl #2
 cb0:	00280b00 	eoreq	r0, r8, r0, lsl #22
 cb4:	0b1c0e03 	bleq	7044c8 <__bss_end+0x6fa7d0>
 cb8:	010c0000 	mrseq	r0, (UNDEF: 12)
 cbc:	01134901 	tsteq	r3, r1, lsl #18
 cc0:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
 cc4:	00000021 	andeq	r0, r0, r1, lsr #32
 cc8:	4900260e 	stmdbmi	r0, {r1, r2, r3, r9, sl, sp}
 ccc:	0f000013 	svceq	0x00000013
 cd0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 cd4:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 cd8:	13490b39 	movtne	r0, #39737	; 0x9b39
 cdc:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 ce0:	13100000 	tstne	r0, #0
 ce4:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 ce8:	11000019 	tstne	r0, r9, lsl r0
 cec:	19270015 	stmdbne	r7!, {r0, r2, r4}
 cf0:	17120000 	ldrne	r0, [r2, -r0]
 cf4:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 cf8:	13000019 	movwne	r0, #25
 cfc:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 d00:	0b3a0b0b 	bleq	e83934 <__bss_end+0xe79c3c>
 d04:	0b39053b 	bleq	e421f8 <__bss_end+0xe38500>
 d08:	00001301 	andeq	r1, r0, r1, lsl #6
 d0c:	03000d14 	movweq	r0, #3348	; 0xd14
 d10:	3b0b3a0e 	blcc	2cf550 <__bss_end+0x2c5858>
 d14:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 d18:	000b3813 	andeq	r3, fp, r3, lsl r8
 d1c:	00211500 	eoreq	r1, r1, r0, lsl #10
 d20:	0b2f1349 	bleq	bc5a4c <__bss_end+0xbbbd54>
 d24:	04160000 	ldreq	r0, [r6], #-0
 d28:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 d2c:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 d30:	3b0b3a13 	blcc	2cf584 <__bss_end+0x2c588c>
 d34:	010b3905 	tsteq	fp, r5, lsl #18
 d38:	17000013 	smladne	r0, r3, r0, r0
 d3c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 d40:	0b3a0e03 	bleq	e84554 <__bss_end+0xe7a85c>
 d44:	0b39053b 	bleq	e42238 <__bss_end+0xe38540>
 d48:	13491927 	movtne	r1, #39207	; 0x9927
 d4c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 d50:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 d54:	00130119 	andseq	r0, r3, r9, lsl r1
 d58:	00051800 	andeq	r1, r5, r0, lsl #16
 d5c:	0b3a0803 	bleq	e82d70 <__bss_end+0xe79078>
 d60:	0b39053b 	bleq	e42254 <__bss_end+0xe3855c>
 d64:	17021349 	strne	r1, [r2, -r9, asr #6]
 d68:	001742b7 			; <UNDEFINED> instruction: 0x001742b7
 d6c:	00051900 	andeq	r1, r5, r0, lsl #18
 d70:	0b3a0803 	bleq	e82d84 <__bss_end+0xe7908c>
 d74:	0b39053b 	bleq	e42268 <__bss_end+0xe38570>
 d78:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 d7c:	341a0000 	ldrcc	r0, [sl], #-0
 d80:	3a080300 	bcc	201988 <__bss_end+0x1f7c90>
 d84:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 d88:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 d8c:	1742b717 	smlaldne	fp, r2, r7, r7
 d90:	341b0000 	ldrcc	r0, [fp], #-0
 d94:	3a080300 	bcc	20199c <__bss_end+0x1f7ca4>
 d98:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 d9c:	0013490b 	andseq	r4, r3, fp, lsl #18
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
  34:	00000098 	muleq	r0, r8, r0
	...
  40:	0000001c 	andeq	r0, r0, ip, lsl r0
  44:	00ce0002 	sbceq	r0, lr, r2
  48:	00040000 	andeq	r0, r4, r0
  4c:	00000000 	andeq	r0, r0, r0
  50:	000080a0 	andeq	r8, r0, r0, lsr #1
  54:	00000188 	andeq	r0, r0, r8, lsl #3
	...
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	02d40002 	sbcseq	r0, r4, #2
  68:	00040000 	andeq	r0, r4, r0
  6c:	00000000 	andeq	r0, r0, r0
  70:	00008228 	andeq	r8, r0, r8, lsr #4
  74:	00000048 	andeq	r0, r0, r8, asr #32
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	0b200002 	bleq	800094 <__bss_end+0x7f639c>
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008270 	andeq	r8, r0, r0, ror r2
  94:	0000048c 	andeq	r0, r0, ip, lsl #9
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	183b0002 	ldmdane	fp!, {r1}
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008700 	andeq	r8, r0, r0, lsl #14
  b4:	00000e9c 	muleq	r0, ip, lr
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	1e2a0002 	cdpne	0, 2, cr0, cr10, cr2, {0}
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	0000959c 	muleq	r0, ip, r5
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	1e500002 	cdpne	0, 5, cr0, cr0, cr2, {0}
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	000097a8 	andeq	r9, r0, r8, lsr #15
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	1e760002 	cdpne	0, 7, cr0, cr6, cr2, {0}
 108:	00040000 	andeq	r0, r4, r0
 10c:	00000000 	andeq	r0, r0, r0
 110:	000097ac 	andeq	r9, r0, ip, lsr #15
 114:	00000250 	andeq	r0, r0, r0, asr r2
	...
 120:	0000001c 	andeq	r0, r0, ip, lsl r0
 124:	1e9c0002 	cdpne	0, 9, cr0, cr12, cr2, {0}
 128:	00040000 	andeq	r0, r4, r0
 12c:	00000000 	andeq	r0, r0, r0
 130:	000099fc 	strdeq	r9, [r0], -ip
 134:	000000d4 	ldrdeq	r0, [r0], -r4
	...
 140:	00000014 	andeq	r0, r0, r4, lsl r0
 144:	1ec20002 	cdpne	0, 12, cr0, cr2, cr2, {0}
 148:	00040000 	andeq	r0, r4, r0
	...
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	28cf0002 	stmiacs	pc, {r1}^	; <UNPREDICTABLE>
 160:	00040000 	andeq	r0, r4, r0
 164:	00000000 	andeq	r0, r0, r0
 168:	00009ad0 	ldrdeq	r9, [r0], -r0
 16c:	0000002c 	andeq	r0, r0, ip, lsr #32
	...
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	33150002 	tstcc	r5, #2
 180:	00040000 	andeq	r0, r4, r0
 184:	00000000 	andeq	r0, r0, r0
 188:	00009b00 	andeq	r9, r0, r0, lsl #22
 18c:	00000040 	andeq	r0, r0, r0, asr #32
	...
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	3d7f0002 	ldclcc	0, cr0, [pc, #-8]!	; 19c <shift+0x19c>
 1a0:	00040000 	andeq	r0, r4, r0
 1a4:	00000000 	andeq	r0, r0, r0
 1a8:	00009b40 	andeq	r9, r0, r0, asr #22
 1ac:	00000128 	andeq	r0, r0, r8, lsr #2
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff6254>
       4:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
       8:	6b69746e 	blvs	1a5d1c8 <__bss_end+0x1a534d0>
       c:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
      10:	6e69662f 	cdpvs	6, 6, cr6, cr9, cr15, {1}
      14:	732f6c61 			; <UNDEFINED> instruction: 0x732f6c61
      18:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
      1c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
      20:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcc3 <__bss_end+0xffff5fcb>
      24:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
      28:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
      2c:	7472632f 	ldrbtvc	r6, [r2], #-815	; 0xfffffcd1
      30:	00732e30 	rsbseq	r2, r3, r0, lsr lr
      34:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff80 <__bss_end+0xffff6288>
      38:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
      3c:	6b69746e 	blvs	1a5d1fc <__bss_end+0x1a53504>
      40:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
      44:	6e69662f 	cdpvs	6, 6, cr6, cr9, cr15, {1}
      48:	732f6c61 			; <UNDEFINED> instruction: 0x732f6c61
      4c:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
      50:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
      54:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcf7 <__bss_end+0xffff5fff>
      58:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
      5c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
      60:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
      64:	4700646c 	strmi	r6, [r0, -ip, ror #8]
      68:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
      6c:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
      70:	322e3533 	eorcc	r3, lr, #213909504	; 0xcc00000
      74:	6f682f00 	svcvs	0x00682f00
      78:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
      7c:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
      80:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
      84:	69662f76 	stmdbvs	r6!, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
      88:	2f6c616e 	svccs	0x006c616e
      8c:	2f637273 	svccs	0x00637273
      90:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
      94:	2f736563 	svccs	0x00736563
      98:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
      9c:	63617073 	cmnvs	r1, #115	; 0x73
      a0:	72632f65 	rsbvc	r2, r3, #404	; 0x194
      a4:	632e3074 			; <UNDEFINED> instruction: 0x632e3074
      a8:	635f5f00 	cmpvs	pc, #0, 30
      ac:	5f307472 	svcpl	0x00307472
      b0:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
      b4:	7373625f 	cmnvc	r3, #-268435451	; 0xf0000005
      b8:	73657200 	cmnvc	r5, #0, 4
      bc:	00746c75 	rsbseq	r6, r4, r5, ror ip
      c0:	73625f5f 	cmnvc	r2, #380	; 0x17c
      c4:	6e655f73 	mcrvs	15, 3, r5, cr5, cr3, {3}
      c8:	4e470064 	cdpmi	0, 4, cr0, cr7, cr4, {3}
      cc:	31432055 	qdaddcc	r2, r5, r3
      d0:	2e382037 	mrccs	0, 1, r2, cr8, cr7, {1}
      d4:	20312e33 	eorscs	r2, r1, r3, lsr lr
      d8:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
      dc:	33303730 	teqcc	r0, #48, 14	; 0xc00000
      e0:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
      e4:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
      e8:	5b202965 	blpl	80a684 <__bss_end+0x80098c>
      ec:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
      f0:	72622d38 	rsbvc	r2, r2, #56, 26	; 0xe00
      f4:	68636e61 	stmdavs	r3!, {r0, r5, r6, r9, sl, fp, sp, lr}^
      f8:	76657220 	strbtvc	r7, [r5], -r0, lsr #4
      fc:	6f697369 	svcvs	0x00697369
     100:	3732206e 	ldrcc	r2, [r2, -lr, rrx]!
     104:	37323033 			; <UNDEFINED> instruction: 0x37323033
     108:	6d2d205d 	stcvs	0, cr2, [sp, #-372]!	; 0xfffffe8c
     10c:	616f6c66 	cmnvs	pc, r6, ror #24
     110:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
     114:	61683d69 	cmnvs	r8, r9, ror #26
     118:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
     11c:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
     120:	7066763d 	rsbvc	r7, r6, sp, lsr r6
     124:	746d2d20 	strbtvc	r2, [sp], #-3360	; 0xfffff2e0
     128:	3d656e75 	stclcc	14, cr6, [r5, #-468]!	; 0xfffffe2c
     12c:	316d7261 	cmncc	sp, r1, ror #4
     130:	6a363731 	bvs	d8ddfc <__bss_end+0xd84104>
     134:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     138:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     13c:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     140:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
     144:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
     148:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
     14c:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
     150:	20706676 	rsbscs	r6, r0, r6, ror r6
     154:	75746d2d 	ldrbvc	r6, [r4, #-3373]!	; 0xfffff2d3
     158:	613d656e 	teqvs	sp, lr, ror #10
     15c:	31316d72 	teqcc	r1, r2, ror sp
     160:	7a6a3637 	bvc	1a8da44 <__bss_end+0x1a83d4c>
     164:	20732d66 	rsbscs	r2, r3, r6, ror #26
     168:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     16c:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
     170:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     174:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     178:	6b7a3676 	blvs	1e8db58 <__bss_end+0x1e83e60>
     17c:	2070662b 	rsbscs	r6, r0, fp, lsr #12
     180:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     184:	4f2d2067 	svcmi	0x002d2067
     188:	4f2d2030 	svcmi	0x002d2030
     18c:	5f5f0030 	svcpl	0x005f0030
     190:	5f737362 	svcpl	0x00737362
     194:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
     198:	5f5f0074 	svcpl	0x005f0074
     19c:	30747263 	rsbscc	r7, r4, r3, ror #4
     1a0:	6e75725f 	mrcvs	2, 3, r7, cr5, cr15, {2}
     1a4:	675f5f00 	ldrbvs	r5, [pc, -r0, lsl #30]
     1a8:	64726175 	ldrbtvs	r6, [r2], #-373	; 0xfffffe8b
     1ac:	6f682f00 	svcvs	0x00682f00
     1b0:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
     1b4:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
     1b8:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
     1bc:	69662f76 	stmdbvs	r6!, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
     1c0:	2f6c616e 	svccs	0x006c616e
     1c4:	2f637273 	svccs	0x00637273
     1c8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     1cc:	2f736563 	svccs	0x00736563
     1d0:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     1d4:	63617073 	cmnvs	r1, #115	; 0x73
     1d8:	78632f65 	stmdavc	r3!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     1dc:	69626178 	stmdbvs	r2!, {r3, r4, r5, r6, r8, sp, lr}^
     1e0:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     1e4:	635f5f00 	cmpvs	pc, #0, 30
     1e8:	62617878 	rsbvs	r7, r1, #120, 16	; 0x780000
     1ec:	00317669 	eorseq	r7, r1, r9, ror #12
     1f0:	65615f5f 	strbvs	r5, [r1, #-3935]!	; 0xfffff0a1
     1f4:	5f696261 	svcpl	0x00696261
     1f8:	69776e75 	ldmdbvs	r7!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     1fc:	635f646e 	cmpvs	pc, #1845493760	; 0x6e000000
     200:	705f7070 	subsvc	r7, pc, r0, ror r0	; <UNPREDICTABLE>
     204:	5f003172 	svcpl	0x00003172
     208:	5f707063 	svcpl	0x00707063
     20c:	74756873 	ldrbtvc	r6, [r5], #-2163	; 0xfffff78d
     210:	6e776f64 	cdpvs	15, 7, cr6, cr7, cr4, {3}
     214:	706e6600 	rsbvc	r6, lr, r0, lsl #12
     218:	5f007274 	svcpl	0x00007274
     21c:	6178635f 	cmnvs	r8, pc, asr r3
     220:	7275705f 	rsbsvc	r7, r5, #95	; 0x5f
     224:	69765f65 	ldmdbvs	r6!, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     228:	61757472 	cmnvs	r5, r2, ror r4
     22c:	5f5f006c 	svcpl	0x005f006c
     230:	5f617863 	svcpl	0x00617863
     234:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
     238:	65725f64 	ldrbvs	r5, [r2, #-3940]!	; 0xfffff09c
     23c:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
     240:	5f5f0065 	svcpl	0x005f0065
     244:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
     248:	444e455f 	strbmi	r4, [lr], #-1375	; 0xfffffaa1
     24c:	5f005f5f 	svcpl	0x00005f5f
     250:	6f73645f 	svcvs	0x0073645f
     254:	6e61685f 	mcrvs	8, 3, r6, cr1, cr15, {2}
     258:	00656c64 	rsbeq	r6, r5, r4, ror #24
     25c:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
     260:	4c5f524f 	lfmmi	f5, 2, [pc], {79}	; 0x4f
     264:	5f545349 	svcpl	0x00545349
     268:	5f5f005f 	svcpl	0x005f005f
     26c:	5f617863 	svcpl	0x00617863
     270:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
     274:	62615f64 	rsbvs	r5, r1, #100, 30	; 0x190
     278:	0074726f 	rsbseq	r7, r4, pc, ror #4
     27c:	726f7464 	rsbvc	r7, pc, #100, 8	; 0x64000000
     280:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
     284:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
     288:	2b2b4320 	blcs	ad0f10 <__bss_end+0xac7218>
     28c:	38203431 	stmdacc	r0!, {r0, r4, r5, sl, ip, sp}
     290:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
     294:	31303220 	teqcc	r0, r0, lsr #4
     298:	30373039 	eorscc	r3, r7, r9, lsr r0
     29c:	72282033 	eorvc	r2, r8, #51	; 0x33
     2a0:	61656c65 	cmnvs	r5, r5, ror #24
     2a4:	20296573 	eorcs	r6, r9, r3, ror r5
     2a8:	6363675b 	cmnvs	r3, #23855104	; 0x16c0000
     2ac:	622d382d 	eorvs	r3, sp, #2949120	; 0x2d0000
     2b0:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
     2b4:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
     2b8:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
     2bc:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
     2c0:	32303337 	eorscc	r3, r0, #-603979776	; 0xdc000000
     2c4:	2d205d37 	stccs	13, cr5, [r0, #-220]!	; 0xffffff24
     2c8:	6f6c666d 	svcvs	0x006c666d
     2cc:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
     2d0:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
     2d4:	20647261 	rsbcs	r7, r4, r1, ror #4
     2d8:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
     2dc:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
     2e0:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
     2e4:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
     2e8:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     2ec:	36373131 			; <UNDEFINED> instruction: 0x36373131
     2f0:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
     2f4:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
     2f8:	616f6c66 	cmnvs	pc, r6, ror #24
     2fc:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
     300:	61683d69 	cmnvs	r8, r9, ror #26
     304:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
     308:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
     30c:	7066763d 	rsbvc	r7, r6, sp, lsr r6
     310:	746d2d20 	strbtvc	r2, [sp], #-3360	; 0xfffff2e0
     314:	3d656e75 	stclcc	14, cr6, [r5, #-468]!	; 0xfffffe2c
     318:	316d7261 	cmncc	sp, r1, ror #4
     31c:	6a363731 	bvs	d8dfe8 <__bss_end+0xd842f0>
     320:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     324:	616d2d20 	cmnvs	sp, r0, lsr #26
     328:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     32c:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     330:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     334:	7a36766d 	bvc	d9dcf0 <__bss_end+0xd93ff8>
     338:	70662b6b 	rsbvc	r2, r6, fp, ror #22
     33c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     340:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     344:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
     348:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
     34c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1bc <shift+0x1bc>
     350:	65637865 	strbvs	r7, [r3, #-2149]!	; 0xfffff79b
     354:	6f697470 	svcvs	0x00697470
     358:	2d20736e 	stccs	3, cr7, [r0, #-440]!	; 0xfffffe48
     35c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1cc <shift+0x1cc>
     360:	69747472 	ldmdbvs	r4!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     364:	445f5f00 	ldrbmi	r5, [pc], #-3840	; 36c <shift+0x36c>
     368:	5f524f54 	svcpl	0x00524f54
     36c:	5f444e45 	svcpl	0x00444e45
     370:	5f5f005f 	svcpl	0x005f005f
     374:	5f617863 	svcpl	0x00617863
     378:	78657461 	stmdavc	r5!, {r0, r5, r6, sl, ip, sp, lr}^
     37c:	6c007469 	cfstrsvs	mvf7, [r0], {105}	; 0x69
     380:	20676e6f 	rsbcs	r6, r7, pc, ror #28
     384:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
     388:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     38c:	70635f00 	rsbvc	r5, r3, r0, lsl #30
     390:	74735f70 	ldrbtvc	r5, [r3], #-3952	; 0xfffff090
     394:	75747261 	ldrbvc	r7, [r4, #-609]!	; 0xfffffd9f
     398:	5f5f0070 	svcpl	0x005f0070
     39c:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
     3a0:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
     3a4:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
     3a8:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
     3ac:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
     3b0:	635f5f00 	cmpvs	pc, #0, 30
     3b4:	675f6178 			; <UNDEFINED> instruction: 0x675f6178
     3b8:	64726175 	ldrbtvs	r6, [r2], #-373	; 0xfffffe8b
     3bc:	7163615f 	cmnvc	r3, pc, asr r1
     3c0:	65726975 	ldrbvs	r6, [r2, #-2421]!	; 0xfffff68b
     3c4:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     3c8:	5f64656e 	svcpl	0x0064656e
     3cc:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     3d0:	69590073 	ldmdbvs	r9, {r0, r1, r4, r5, r6}^
     3d4:	00646c65 	rsbeq	r6, r4, r5, ror #24
     3d8:	65646e49 	strbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     3dc:	696e6966 	stmdbvs	lr!, {r1, r2, r5, r6, r8, fp, sp, lr}^
     3e0:	64006574 	strvs	r6, [r0], #-1396	; 0xfffffa8c
     3e4:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     3e8:	64695f72 	strbtvs	r5, [r9], #-3954	; 0xfffff08e
     3ec:	526d0078 	rsbpl	r0, sp, #120	; 0x78
     3f0:	5f746f6f 	svcpl	0x00746f6f
     3f4:	00766544 	rsbseq	r6, r6, r4, asr #10
     3f8:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     3fc:	64656966 	strbtvs	r6, [r5], #-2406	; 0xfffff69a
     400:	6165645f 	cmnvs	r5, pc, asr r4
     404:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     408:	6c730065 	ldclvs	0, cr0, [r3], #-404	; 0xfffffe6c
     40c:	5f706565 	svcpl	0x00706565
     410:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     414:	43540072 	cmpmi	r4, #114	; 0x72
     418:	435f5550 	cmpmi	pc, #80, 10	; 0x14000000
     41c:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     420:	4e007478 	mcrmi	4, 0, r7, cr0, cr8, {3}
     424:	6b736154 	blvs	1cd897c <__bss_end+0x1ccec84>
     428:	6174535f 	cmnvs	r4, pc, asr r3
     42c:	4e006574 	cfrshl64mi	mvdx0, mvdx4, r6
     430:	5f495753 	svcpl	0x00495753
     434:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     438:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     43c:	535f6d65 	cmppl	pc, #6464	; 0x1940
     440:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     444:	6d006563 	cfstr32vs	mvfx6, [r0, #-396]	; 0xfffffe74
     448:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     44c:	6e696f50 	mcrvs	15, 3, r6, cr9, cr0, {2}
     450:	68730074 	ldmdavs	r3!, {r2, r4, r5, r6}^
     454:	2074726f 	rsbscs	r7, r4, pc, ror #4
     458:	00746e69 	rsbseq	r6, r4, r9, ror #28
     45c:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     460:	6f72505f 	svcvs	0x0072505f
     464:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     468:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     46c:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     470:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     474:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     478:	636f7250 	cmnvs	pc, #80, 4
     47c:	5f737365 	svcpl	0x00737365
     480:	616e614d 	cmnvs	lr, sp, asr #2
     484:	31726567 	cmncc	r2, r7, ror #10
     488:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     48c:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     490:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     494:	6f72505f 	svcvs	0x0072505f
     498:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     49c:	4d007645 	stcmi	6, cr7, [r0, #-276]	; 0xfffffeec
     4a0:	505f7861 	subspl	r7, pc, r1, ror #16
     4a4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     4a8:	4f5f7373 	svcmi	0x005f7373
     4ac:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     4b0:	69465f64 	stmdbvs	r6, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     4b4:	0073656c 	rsbseq	r6, r3, ip, ror #10
     4b8:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
     4bc:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     4c0:	4700657a 	smlsdxmi	r0, sl, r5, r6
     4c4:	505f7465 	subspl	r7, pc, r5, ror #8
     4c8:	6d004449 	cfstrsvs	mvf4, [r0, #-292]	; 0xfffffedc
     4cc:	006e6961 	rsbeq	r6, lr, r1, ror #18
     4d0:	5f534667 	svcpl	0x00534667
     4d4:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     4d8:	00737265 	rsbseq	r7, r3, r5, ror #4
     4dc:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 428 <shift+0x428>
     4e0:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     4e4:	6b69746e 	blvs	1a5d6a4 <__bss_end+0x1a539ac>
     4e8:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
     4ec:	6e69662f 	cdpvs	6, 6, cr6, cr9, cr15, {1}
     4f0:	732f6c61 			; <UNDEFINED> instruction: 0x732f6c61
     4f4:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
     4f8:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     4fc:	752f7365 	strvc	r7, [pc, #-869]!	; 19f <shift+0x19f>
     500:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     504:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     508:	696e692f 	stmdbvs	lr!, {r0, r1, r2, r3, r5, r8, fp, sp, lr}^
     50c:	61745f74 	cmnvs	r4, r4, ror pc
     510:	6d2f6b73 	fstmdbxvs	pc!, {d6-d62}	;@ Deprecated
     514:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
     518:	00707063 	rsbseq	r7, r0, r3, rrx
     51c:	5f534667 	svcpl	0x00534667
     520:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     524:	5f737265 	svcpl	0x00737265
     528:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     52c:	5a5f0074 	bpl	17c0704 <__bss_end+0x17b6a0c>
     530:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
     534:	6f725043 	svcvs	0x00725043
     538:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     53c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     540:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     544:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     548:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     54c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     550:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     554:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     558:	5f006a45 	svcpl	0x00006a45
     55c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     560:	6f725043 	svcvs	0x00725043
     564:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     568:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     56c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     570:	68635338 	stmdavs	r3!, {r3, r4, r5, r8, r9, ip, lr}^
     574:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     578:	00764565 	rsbseq	r4, r6, r5, ror #10
     57c:	314e5a5f 	cmpcc	lr, pc, asr sl
     580:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     584:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     588:	614d5f73 	hvcvs	54771	; 0xd5f3
     58c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     590:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     594:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     598:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     59c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5a0:	006a4573 	rsbeq	r4, sl, r3, ror r5
     5a4:	61766e49 	cmnvs	r6, r9, asr #28
     5a8:	5f64696c 	svcpl	0x0064696c
     5ac:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     5b0:	6d00656c 	cfstr32vs	mvfx6, [r0, #-432]	; 0xfffffe50
     5b4:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     5b8:	5f746e65 	svcpl	0x00746e65
     5bc:	6b736154 	blvs	1cd8b14 <__bss_end+0x1ccee1c>
     5c0:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 5c8 <shift+0x5c8>
     5c4:	74740065 	ldrbtvc	r0, [r4], #-101	; 0xffffff9b
     5c8:	00307262 	eorseq	r7, r0, r2, ror #4
     5cc:	69447369 	stmdbvs	r4, {r0, r3, r5, r6, r8, r9, ip, sp, lr}^
     5d0:	74636572 	strbtvc	r6, [r3], #-1394	; 0xfffffa8e
     5d4:	0079726f 	rsbseq	r7, r9, pc, ror #4
     5d8:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
     5dc:	545f6863 	ldrbpl	r6, [pc], #-2147	; 5e4 <shift+0x5e4>
     5e0:	614d006f 	cmpvs	sp, pc, rrx
     5e4:	44534678 	ldrbmi	r4, [r3], #-1656	; 0xfffff988
     5e8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     5ec:	6d614e72 	stclvs	14, cr4, [r1, #-456]!	; 0xfffffe38
     5f0:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     5f4:	00687467 	rsbeq	r7, r8, r7, ror #8
     5f8:	6c694673 	stclvs	6, cr4, [r9], #-460	; 0xfffffe34
     5fc:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     600:	006d6574 	rsbeq	r6, sp, r4, ror r5
     604:	6c6f6f62 	stclvs	15, cr6, [pc], #-392	; 484 <shift+0x484>
     608:	614c6d00 	cmpvs	ip, r0, lsl #26
     60c:	505f7473 	subspl	r7, pc, r3, ror r4	; <UNPREDICTABLE>
     610:	61004449 	tstvs	r0, r9, asr #8
     614:	00636772 	rsbeq	r6, r3, r2, ror r7
     618:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     61c:	505f7966 	subspl	r7, pc, r6, ror #18
     620:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     624:	48007373 	stmdami	r0, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
     628:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     62c:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     630:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     634:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     638:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     63c:	75706300 	ldrbvc	r6, [r0, #-768]!	; 0xfffffd00
     640:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
     644:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     648:	65724300 	ldrbvs	r4, [r2, #-768]!	; 0xfffffd00
     64c:	5f657461 	svcpl	0x00657461
     650:	636f7250 	cmnvs	pc, #80, 4
     654:	00737365 	rsbseq	r7, r3, r5, ror #6
     658:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     65c:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     660:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     664:	735f6465 	cmpvc	pc, #1694498816	; 0x65000000
     668:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     66c:	72705f63 	rsbsvc	r5, r0, #396	; 0x18c
     670:	69726f69 	ldmdbvs	r2!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     674:	70007974 	andvc	r7, r0, r4, ror r9
     678:	6e657261 	cdpvs	2, 6, cr7, cr5, cr1, {3}
     67c:	6f4c0074 	svcvs	0x004c0074
     680:	555f6b63 	ldrbpl	r6, [pc, #-2915]	; fffffb25 <__bss_end+0xffff5e2d>
     684:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     688:	0064656b 	rsbeq	r6, r4, fp, ror #10
     68c:	5f534654 	svcpl	0x00534654
     690:	65657254 	strbvs	r7, [r5, #-596]!	; 0xfffffdac
     694:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 69c <shift+0x69c>
     698:	614d0065 	cmpvs	sp, r5, rrx
     69c:	6c694678 	stclvs	6, cr4, [r9], #-480	; 0xfffffe20
     6a0:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
     6a4:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     6a8:	00687467 	rsbeq	r7, r8, r7, ror #8
     6ac:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     6b0:	646f635f 	strbtvs	r6, [pc], #-863	; 6b8 <shift+0x6b8>
     6b4:	46430065 	strbmi	r0, [r3], -r5, rrx
     6b8:	73656c69 	cmnvc	r5, #26880	; 0x6900
     6bc:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     6c0:	6863006d 	stmdavs	r3!, {r0, r2, r3, r5, r6}^
     6c4:	72646c69 	rsbvc	r6, r4, #26880	; 0x6900
     6c8:	49006e65 	stmdbmi	r0, {r0, r2, r5, r6, r9, sl, fp, sp, lr}
     6cc:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     6d0:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     6d4:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     6d8:	656c535f 	strbvs	r5, [ip, #-863]!	; 0xfffffca1
     6dc:	53007065 	movwpl	r7, #101	; 0x65
     6e0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     6e4:	00656c75 	rsbeq	r6, r5, r5, ror ip
     6e8:	6b636954 	blvs	18dac40 <__bss_end+0x18d0f48>
     6ec:	756f435f 	strbvc	r4, [pc, #-863]!	; 395 <shift+0x395>
     6f0:	5500746e 	strpl	r7, [r0, #-1134]	; 0xfffffb92
     6f4:	70616d6e 	rsbvc	r6, r1, lr, ror #26
     6f8:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     6fc:	75435f65 	strbvc	r5, [r3, #-3941]	; 0xfffff09b
     700:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     704:	72610074 	rsbvc	r0, r1, #116	; 0x74
     708:	5f007667 	svcpl	0x00007667
     70c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     710:	6f725043 	svcvs	0x00725043
     714:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     718:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     71c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     720:	6e553831 	mrcvs	8, 2, r3, cr5, cr1, {1}
     724:	5f70616d 	svcpl	0x0070616d
     728:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     72c:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     730:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     734:	53006a45 	movwpl	r6, #2629	; 0xa45
     738:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     73c:	5f656c75 	svcpl	0x00656c75
     740:	5a005252 	bpl	15090 <__bss_end+0xb398>
     744:	69626d6f 	stmdbvs	r2!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp, lr}^
     748:	6e750065 	cdpvs	0, 7, cr0, cr5, cr5, {3}
     74c:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     750:	63206465 			; <UNDEFINED> instruction: 0x63206465
     754:	00726168 	rsbseq	r6, r2, r8, ror #2
     758:	5f534654 	svcpl	0x00534654
     75c:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     760:	47007265 	strmi	r7, [r0, -r5, ror #4]
     764:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     768:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     76c:	505f746e 	subspl	r7, pc, lr, ror #8
     770:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     774:	73007373 	movwvc	r7, #883	; 0x373
     778:	636f7250 	cmnvs	pc, #80, 4
     77c:	4d737365 	ldclmi	3, cr7, [r3, #-404]!	; 0xfffffe6c
     780:	52007267 	andpl	r7, r0, #1879048198	; 0x70000006
     784:	00646165 	rsbeq	r6, r4, r5, ror #2
     788:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     78c:	745f3233 	ldrbvc	r3, [pc], #-563	; 794 <shift+0x794>
     790:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     794:	46433131 			; <UNDEFINED> instruction: 0x46433131
     798:	73656c69 	cmnvc	r5, #26880	; 0x6900
     79c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     7a0:	704f346d 	subvc	r3, pc, sp, ror #8
     7a4:	50456e65 	subpl	r6, r5, r5, ror #28
     7a8:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
     7ac:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
     7b0:	704f5f65 	subvc	r5, pc, r5, ror #30
     7b4:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; 628 <shift+0x628>
     7b8:	0065646f 	rsbeq	r6, r5, pc, ror #8
     7bc:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     7c0:	75435f6b 	strbvc	r5, [r3, #-3947]	; 0xfffff095
     7c4:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     7c8:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     7cc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     7d0:	69460073 	stmdbvs	r6, {r0, r1, r4, r5, r6}^
     7d4:	435f646e 	cmpmi	pc, #1845493760	; 0x6e000000
     7d8:	646c6968 	strbtvs	r6, [ip], #-2408	; 0xfffff698
     7dc:	73617400 	cmnvc	r1, #0, 8
     7e0:	6157006b 	cmpvs	r7, fp, rrx
     7e4:	46007469 	strmi	r7, [r0], -r9, ror #8
     7e8:	74737269 	ldrbtvc	r7, [r3], #-617	; 0xfffffd97
     7ec:	65676150 	strbvs	r6, [r7, #-336]!	; 0xfffffeb0
     7f0:	75716552 	ldrbvc	r6, [r1, #-1362]!	; 0xfffffaae
     7f4:	00747365 	rsbseq	r7, r4, r5, ror #6
     7f8:	6f6f526d 	svcvs	0x006f526d
     7fc:	6e4d5f74 	mcrvs	15, 2, r5, cr13, cr4, {3}
     800:	72640074 	rsbvc	r0, r4, #116	; 0x74
     804:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     808:	65704f00 	ldrbvs	r4, [r0, #-3840]!	; 0xfffff100
     80c:	5a5f006e 	bpl	17c09cc <__bss_end+0x17b6cd4>
     810:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     814:	636f7250 	cmnvs	pc, #80, 4
     818:	5f737365 	svcpl	0x00737365
     81c:	616e614d 	cmnvs	lr, sp, asr #2
     820:	31726567 	cmncc	r2, r7, ror #10
     824:	70614d39 	rsbvc	r4, r1, r9, lsr sp
     828:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     82c:	6f545f65 	svcvs	0x00545f65
     830:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     834:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     838:	49355045 	ldmdbmi	r5!, {r0, r2, r6, ip, lr}
     83c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     840:	72506d00 	subsvc	r6, r0, #0, 26
     844:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     848:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     84c:	485f7473 	ldmdami	pc, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     850:	00646165 	rsbeq	r6, r4, r5, ror #2
     854:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     858:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
     85c:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     860:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
     864:	6d00746e 	cfstrsvs	mvf7, [r0, #-440]	; 0xfffffe48
     868:	746f6f52 	strbtvc	r6, [pc], #-3922	; 870 <shift+0x870>
     86c:	7379535f 	cmnvc	r9, #2080374785	; 0x7c000001
     870:	746f4e00 	strbtvc	r4, [pc], #-3584	; 878 <shift+0x878>
     874:	41796669 	cmnmi	r9, r9, ror #12
     878:	42006c6c 	andmi	r6, r0, #108, 24	; 0x6c00
     87c:	6b636f6c 	blvs	18dc634 <__bss_end+0x18d293c>
     880:	52006465 	andpl	r6, r0, #1694498816	; 0x65000000
     884:	5f646165 	svcpl	0x00646165
     888:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
     88c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     890:	50433631 	subpl	r3, r3, r1, lsr r6
     894:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     898:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 6d4 <shift+0x6d4>
     89c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     8a0:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
     8a4:	47007645 	strmi	r7, [r0, -r5, asr #12]
     8a8:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     8ac:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     8b0:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
     8b4:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     8b8:	5a5f006f 	bpl	17c0a7c <__bss_end+0x17b6d84>
     8bc:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     8c0:	636f7250 	cmnvs	pc, #80, 4
     8c4:	5f737365 	svcpl	0x00737365
     8c8:	616e614d 	cmnvs	lr, sp, asr #2
     8cc:	31726567 	cmncc	r2, r7, ror #10
     8d0:	68635331 	stmdavs	r3!, {r0, r4, r5, r8, r9, ip, lr}^
     8d4:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     8d8:	52525f65 	subspl	r5, r2, #404	; 0x194
     8dc:	52007645 	andpl	r7, r0, #72351744	; 0x4500000
     8e0:	616e6e75 	smcvs	59109	; 0xe6e5
     8e4:	00656c62 	rsbeq	r6, r5, r2, ror #24
     8e8:	5078614d 	rsbspl	r6, r8, sp, asr #2
     8ec:	4c687461 	cfstrdmi	mvd7, [r8], #-388	; 0xfffffe7c
     8f0:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     8f4:	536d0068 	cmnpl	sp, #104	; 0x68
     8f8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     8fc:	5f656c75 	svcpl	0x00656c75
     900:	00636e46 	rsbeq	r6, r3, r6, asr #28
     904:	314e5a5f 	cmpcc	lr, pc, asr sl
     908:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     90c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     910:	614d5f73 	hvcvs	54771	; 0xd5f3
     914:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     918:	42313272 	eorsmi	r3, r1, #536870919	; 0x20000007
     91c:	6b636f6c 	blvs	18dc6d4 <__bss_end+0x18d29dc>
     920:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     924:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     928:	6f72505f 	svcvs	0x0072505f
     92c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     930:	48007645 	stmdami	r0, {r0, r2, r6, r9, sl, ip, sp, lr}
     934:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     938:	72505f65 	subsvc	r5, r0, #404	; 0x194
     93c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     940:	57535f73 			; <UNDEFINED> instruction: 0x57535f73
     944:	474e0049 	strbmi	r0, [lr, -r9, asr #32]
     948:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     94c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     950:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     954:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     958:	47006570 	smlsdxmi	r0, r0, r5, r6
     95c:	505f7465 	subspl	r7, pc, r5, ror #8
     960:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     964:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
     968:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     96c:	614d0044 	cmpvs	sp, r4, asr #32
     970:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     974:	545f656c 	ldrbpl	r6, [pc], #-1388	; 97c <shift+0x97c>
     978:	75435f6f 	strbvc	r5, [r3, #-3951]	; 0xfffff091
     97c:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     980:	4f490074 	svcmi	0x00490074
     984:	006c7443 	rsbeq	r7, ip, r3, asr #8
     988:	6f6f526d 	svcvs	0x006f526d
     98c:	5a5f0074 	bpl	17c0b64 <__bss_end+0x17b6e6c>
     990:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     994:	636f7250 	cmnvs	pc, #80, 4
     998:	5f737365 	svcpl	0x00737365
     99c:	616e614d 	cmnvs	lr, sp, asr #2
     9a0:	31726567 	cmncc	r2, r7, ror #10
     9a4:	6e614838 	mcrvs	8, 3, r4, cr1, cr8, {1}
     9a8:	5f656c64 	svcpl	0x00656c64
     9ac:	636f7250 	cmnvs	pc, #80, 4
     9b0:	5f737365 	svcpl	0x00737365
     9b4:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
     9b8:	534e3032 	movtpl	r3, #57394	; 0xe032
     9bc:	505f4957 	subspl	r4, pc, r7, asr r9	; <UNPREDICTABLE>
     9c0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     9c4:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     9c8:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     9cc:	6a6a6563 	bvs	1a99f60 <__bss_end+0x1a90268>
     9d0:	3131526a 	teqcc	r1, sl, ror #4
     9d4:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
     9d8:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     9dc:	00746c75 	rsbseq	r6, r4, r5, ror ip
     9e0:	736f6c43 	cmnvc	pc, #17152	; 0x4300
     9e4:	5a5f0065 	bpl	17c0b80 <__bss_end+0x17b6e88>
     9e8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     9ec:	636f7250 	cmnvs	pc, #80, 4
     9f0:	5f737365 	svcpl	0x00737365
     9f4:	616e614d 	cmnvs	lr, sp, asr #2
     9f8:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
     9fc:	6e614831 	mcrvs	8, 3, r4, cr1, cr1, {1}
     a00:	5f656c64 	svcpl	0x00656c64
     a04:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     a08:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     a0c:	535f6d65 	cmppl	pc, #6464	; 0x1940
     a10:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
     a14:	57534e33 	smmlarpl	r3, r3, lr, r4
     a18:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
     a1c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     a20:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     a24:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     a28:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     a2c:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
     a30:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
     a34:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
     a38:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     a3c:	6f4c0074 	svcvs	0x004c0074
     a40:	4c5f6b63 	mrrcmi	11, 6, r6, pc, cr3	; <UNPREDICTABLE>
     a44:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     a48:	65520064 	ldrbvs	r0, [r2, #-100]	; 0xffffff9c
     a4c:	575f6461 	ldrbpl	r6, [pc, -r1, ror #8]
     a50:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     a54:	72504300 	subsvc	r4, r0, #0, 6
     a58:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     a5c:	614d5f73 	hvcvs	54771	; 0xd5f3
     a60:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     a64:	6f4e0072 	svcvs	0x004e0072
     a68:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     a6c:	466f4e00 	strbtmi	r4, [pc], -r0, lsl #28
     a70:	73656c69 	cmnvc	r5, #26880	; 0x6900
     a74:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     a78:	6972446d 	ldmdbvs	r2!, {r0, r2, r3, r5, r6, sl, lr}^
     a7c:	00726576 	rsbseq	r6, r2, r6, ror r5
     a80:	314e5a5f 	cmpcc	lr, pc, asr sl
     a84:	69464331 	stmdbvs	r6, {r0, r4, r5, r8, r9, lr}^
     a88:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     a8c:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     a90:	46543331 			; <UNDEFINED> instruction: 0x46543331
     a94:	72545f53 	subsvc	r5, r4, #332	; 0x14c
     a98:	4e5f6565 	cdpmi	5, 5, cr6, cr15, cr5, {3}
     a9c:	3165646f 	cmncc	r5, pc, ror #8
     aa0:	6e694630 	mcrvs	6, 3, r4, cr9, cr0, {1}
     aa4:	68435f64 	stmdavs	r3, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     aa8:	45646c69 	strbmi	r6, [r4, #-3177]!	; 0xfffff397
     aac:	00634b50 	rsbeq	r4, r3, r0, asr fp
     ab0:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     ab4:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     ab8:	636e555f 	cmnvs	lr, #398458880	; 0x17c00000
     abc:	676e6168 	strbvs	r6, [lr, -r8, ror #2]!
     ac0:	5f006465 	svcpl	0x00006465
     ac4:	31314e5a 	teqcc	r1, sl, asr lr
     ac8:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     acc:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     ad0:	436d6574 	cmnmi	sp, #116, 10	; 0x1d000000
     ad4:	00764534 	rsbseq	r4, r6, r4, lsr r5
     ad8:	314e5a5f 	cmpcc	lr, pc, asr sl
     adc:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     ae0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     ae4:	614d5f73 	hvcvs	54771	; 0xd5f3
     ae8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     aec:	47383172 			; <UNDEFINED> instruction: 0x47383172
     af0:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     af4:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     af8:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
     afc:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     b00:	3032456f 	eorscc	r4, r2, pc, ror #10
     b04:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     b08:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     b0c:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     b10:	5f6f666e 	svcpl	0x006f666e
     b14:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     b18:	5f007650 	svcpl	0x00007650
     b1c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     b20:	6f725043 	svcvs	0x00725043
     b24:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b28:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     b2c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     b30:	72433431 	subvc	r3, r3, #822083584	; 0x31000000
     b34:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     b38:	6f72505f 	svcvs	0x0072505f
     b3c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b40:	6a685045 	bvs	1a14c5c <__bss_end+0x1a0af64>
     b44:	75520062 	ldrbvc	r0, [r2, #-98]	; 0xffffff9e
     b48:	6e696e6e 	cdpvs	14, 6, cr6, cr9, cr14, {3}
     b4c:	65470067 	strbvs	r0, [r7, #-103]	; 0xffffff99
     b50:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     b54:	5f646568 	svcpl	0x00646568
     b58:	6f666e49 	svcvs	0x00666e49
     b5c:	72655400 	rsbvc	r5, r5, #0, 8
     b60:	616e696d 	cmnvs	lr, sp, ror #18
     b64:	49006574 	stmdbmi	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
     b68:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     b6c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     b70:	445f6d65 	ldrbmi	r6, [pc], #-3429	; b78 <shift+0xb78>
     b74:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     b78:	72700072 	rsbsvc	r0, r0, #114	; 0x72
     b7c:	41007665 	tstmi	r0, r5, ror #12
     b80:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     b84:	72505f65 	subsvc	r5, r0, #404	; 0x194
     b88:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     b8c:	6f435f73 	svcvs	0x00435f73
     b90:	00746e75 	rsbseq	r6, r4, r5, ror lr
     b94:	314e5a5f 	cmpcc	lr, pc, asr sl
     b98:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     b9c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     ba0:	614d5f73 	hvcvs	54771	; 0xd5f3
     ba4:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     ba8:	77533972 			; <UNDEFINED> instruction: 0x77533972
     bac:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     bb0:	456f545f 	strbmi	r5, [pc, #-1119]!	; 759 <shift+0x759>
     bb4:	43383150 	teqmi	r8, #80, 2
     bb8:	636f7250 	cmnvs	pc, #80, 4
     bbc:	5f737365 	svcpl	0x00737365
     bc0:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
     bc4:	646f4e5f 	strbtvs	r4, [pc], #-3679	; bcc <shift+0xbcc>
     bc8:	63730065 	cmnvs	r3, #101	; 0x65
     bcc:	5f646568 	svcpl	0x00646568
     bd0:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     bd4:	00726574 	rsbseq	r6, r2, r4, ror r5
     bd8:	646e6152 	strbtvs	r6, [lr], #-338	; 0xfffffeae
     bdc:	754e6d6f 	strbvc	r6, [lr, #-3439]	; 0xfffff291
     be0:	7265626d 	rsbvc	r6, r5, #-805306362	; 0xd0000006
     be4:	75716552 	ldrbvc	r6, [r1, #-1362]!	; 0xfffffaae
     be8:	00747365 	rsbseq	r7, r4, r5, ror #6
     bec:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     bf0:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     bf4:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     bf8:	69725700 	ldmdbvs	r2!, {r8, r9, sl, ip, lr}^
     bfc:	4f5f6574 	svcmi	0x005f6574
     c00:	00796c6e 	rsbseq	r6, r9, lr, ror #24
     c04:	7478656e 	ldrbtvc	r6, [r8], #-1390	; 0xfffffa92
     c08:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     c0c:	50433631 	subpl	r3, r3, r1, lsr r6
     c10:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     c14:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; a50 <shift+0xa50>
     c18:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     c1c:	32317265 	eorscc	r7, r1, #1342177286	; 0x50000006
     c20:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     c24:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     c28:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     c2c:	5f007645 	svcpl	0x00007645
     c30:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     c34:	6f725043 	svcvs	0x00725043
     c38:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     c3c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     c40:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     c44:	6f4e3431 	svcvs	0x004e3431
     c48:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     c4c:	6f72505f 	svcvs	0x0072505f
     c50:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     c54:	32315045 	eorscc	r5, r1, #69	; 0x45
     c58:	73615454 	cmnvc	r1, #84, 8	; 0x54000000
     c5c:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     c60:	74637572 	strbtvc	r7, [r3], #-1394	; 0xfffffa8e
     c64:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     c68:	46433131 			; <UNDEFINED> instruction: 0x46433131
     c6c:	73656c69 	cmnvc	r5, #26880	; 0x6900
     c70:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     c74:	4930316d 	ldmdbmi	r0!, {r0, r2, r3, r5, r6, r8, ip, sp}
     c78:	6974696e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, fp, sp, lr}^
     c7c:	7a696c61 	bvc	1a5be08 <__bss_end+0x1a52110>
     c80:	00764565 	rsbseq	r4, r6, r5, ror #10
     c84:	736f6c63 	cmnvc	pc, #25344	; 0x6300
     c88:	65530065 	ldrbvs	r0, [r3, #-101]	; 0xffffff9b
     c8c:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
     c90:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
     c94:	47006576 	smlsdxmi	r0, r6, r5, r6
     c98:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
     c9c:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
     ca0:	332e3820 			; <UNDEFINED> instruction: 0x332e3820
     ca4:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
     ca8:	30393130 	eorscc	r3, r9, r0, lsr r1
     cac:	20333037 	eorscs	r3, r3, r7, lsr r0
     cb0:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
     cb4:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
     cb8:	675b2029 	ldrbvs	r2, [fp, -r9, lsr #32]
     cbc:	382d6363 	stmdacc	sp!, {r0, r1, r5, r6, r8, r9, sp, lr}
     cc0:	6172622d 	cmnvs	r2, sp, lsr #4
     cc4:	2068636e 	rsbcs	r6, r8, lr, ror #6
     cc8:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     ccc:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
     cd0:	33373220 	teqcc	r7, #32, 4
     cd4:	5d373230 	lfmpl	f3, 4, [r7, #-192]!	; 0xffffff40
     cd8:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     cdc:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     ce0:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
     ce4:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
     ce8:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
     cec:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
     cf0:	20706676 	rsbscs	r6, r0, r6, ror r6
     cf4:	75746d2d 	ldrbvc	r6, [r4, #-3373]!	; 0xfffff2d3
     cf8:	613d656e 	teqvs	sp, lr, ror #10
     cfc:	31316d72 	teqcc	r1, r2, ror sp
     d00:	7a6a3637 	bvc	1a8e5e4 <__bss_end+0x1a848ec>
     d04:	20732d66 	rsbscs	r2, r3, r6, ror #26
     d08:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
     d0c:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
     d10:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     d14:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     d18:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     d1c:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
     d20:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     d24:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
     d28:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
     d2c:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
     d30:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
     d34:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
     d38:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
     d3c:	616d2d20 	cmnvs	sp, r0, lsr #26
     d40:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
     d44:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
     d48:	2b6b7a36 	blcs	1adf628 <__bss_end+0x1ad5930>
     d4c:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     d50:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     d54:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     d58:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     d5c:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     d60:	6f6e662d 	svcvs	0x006e662d
     d64:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
     d68:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
     d6c:	20736e6f 	rsbscs	r6, r3, pc, ror #28
     d70:	6f6e662d 	svcvs	0x006e662d
     d74:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
     d78:	65720069 	ldrbvs	r0, [r2, #-105]!	; 0xffffff97
     d7c:	6c617674 	stclvs	6, cr7, [r1], #-464	; 0xfffffe30
     d80:	75636e00 	strbvc	r6, [r3, #-3584]!	; 0xfffff200
     d84:	69700072 	ldmdbvs	r0!, {r1, r4, r5, r6}^
     d88:	72006570 	andvc	r6, r0, #112, 10	; 0x1c000000
     d8c:	6d756e64 	ldclvs	14, cr6, [r5, #-400]!	; 0xfffffe70
     d90:	315a5f00 	cmpcc	sl, r0, lsl #30
     d94:	68637331 	stmdavs	r3!, {r0, r4, r5, r8, r9, ip, sp, lr}^
     d98:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     d9c:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
     da0:	5a5f0076 	bpl	17c0f80 <__bss_end+0x17b7288>
     da4:	65733731 	ldrbvs	r3, [r3, #-1841]!	; 0xfffff8cf
     da8:	61745f74 	cmnvs	r4, r4, ror pc
     dac:	645f6b73 	ldrbvs	r6, [pc], #-2931	; db4 <shift+0xdb4>
     db0:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     db4:	6a656e69 	bvs	195c760 <__bss_end+0x1952a68>
     db8:	69617700 	stmdbvs	r1!, {r8, r9, sl, ip, sp, lr}^
     dbc:	5a5f0074 	bpl	17c0f94 <__bss_end+0x17b729c>
     dc0:	746f6e36 	strbtvc	r6, [pc], #-3638	; dc8 <shift+0xdc8>
     dc4:	6a796669 	bvs	1e5a770 <__bss_end+0x1e50a78>
     dc8:	5a5f006a 	bpl	17c0f78 <__bss_end+0x17b7280>
     dcc:	72657439 	rsbvc	r7, r5, #956301312	; 0x39000000
     dd0:	616e696d 	cmnvs	lr, sp, ror #18
     dd4:	00696574 	rsbeq	r6, r9, r4, ror r5
     dd8:	6c696146 	stfvse	f6, [r9], #-280	; 0xfffffee8
     ddc:	69786500 	ldmdbvs	r8!, {r8, sl, sp, lr}^
     de0:	646f6374 	strbtvs	r6, [pc], #-884	; de8 <shift+0xde8>
     de4:	5a5f0065 	bpl	17c0f80 <__bss_end+0x17b7288>
     de8:	65673432 	strbvs	r3, [r7, #-1074]!	; 0xfffffbce
     dec:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
     df0:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     df4:	6f72705f 	svcvs	0x0072705f
     df8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     dfc:	756f635f 	strbvc	r6, [pc, #-863]!	; aa5 <shift+0xaa5>
     e00:	0076746e 	rsbseq	r7, r6, lr, ror #8
     e04:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; d50 <shift+0xd50>
     e08:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     e0c:	6b69746e 	blvs	1a5dfcc <__bss_end+0x1a542d4>
     e10:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
     e14:	6e69662f 	cdpvs	6, 6, cr6, cr9, cr15, {1}
     e18:	732f6c61 			; <UNDEFINED> instruction: 0x732f6c61
     e1c:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
     e20:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     e24:	622f7365 	eorvs	r7, pc, #-1811939327	; 0x94000001
     e28:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
     e2c:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     e30:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     e34:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
     e38:	63697400 	cmnvs	r9, #0, 8
     e3c:	6f635f6b 	svcvs	0x00635f6b
     e40:	5f746e75 	svcpl	0x00746e75
     e44:	75716572 	ldrbvc	r6, [r1, #-1394]!	; 0xfffffa8e
     e48:	64657269 	strbtvs	r7, [r5], #-617	; 0xfffffd97
     e4c:	70695000 	rsbvc	r5, r9, r0
     e50:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     e54:	505f656c 	subspl	r6, pc, ip, ror #10
     e58:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     e5c:	65530078 	ldrbvs	r0, [r3, #-120]	; 0xffffff88
     e60:	61505f74 	cmpvs	r0, r4, ror pc
     e64:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     e68:	315a5f00 	cmpcc	sl, r0, lsl #30
     e6c:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
     e70:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     e74:	6f635f6b 	svcvs	0x00635f6b
     e78:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
     e7c:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     e80:	44007065 	strmi	r7, [r0], #-101	; 0xffffff9b
     e84:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     e88:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 924 <shift+0x924>
     e8c:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     e90:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     e94:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     e98:	6f006e6f 	svcvs	0x00006e6f
     e9c:	61726570 	cmnvs	r2, r0, ror r5
     ea0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     ea4:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     ea8:	736f6c63 	cmnvc	pc, #25344	; 0x6300
     eac:	5f006a65 	svcpl	0x00006a65
     eb0:	6567365a 	strbvs	r3, [r7, #-1626]!	; 0xfffff9a6
     eb4:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
     eb8:	6e660076 	mcrvs	0, 3, r0, cr6, cr6, {3}
     ebc:	00656d61 	rsbeq	r6, r5, r1, ror #26
     ec0:	5f746567 	svcpl	0x00746567
     ec4:	646e6172 	strbtvs	r6, [lr], #-370	; 0xfffffe8e
     ec8:	6e5f6d6f 	cdpvs	13, 5, cr6, cr15, cr15, {3}
     ecc:	65626d75 	strbvs	r6, [r2, #-3445]!	; 0xfffff28b
     ed0:	6f6e0072 	svcvs	0x006e0072
     ed4:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     ed8:	63697400 	cmnvs	r9, #0, 8
     edc:	6f00736b 	svcvs	0x0000736b
     ee0:	006e6570 	rsbeq	r6, lr, r0, ror r5
     ee4:	70345a5f 	eorsvc	r5, r4, pc, asr sl
     ee8:	50657069 	rsbpl	r7, r5, r9, rrx
     eec:	006a634b 	rsbeq	r6, sl, fp, asr #6
     ef0:	6165444e 	cmnvs	r5, lr, asr #8
     ef4:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     ef8:	75535f65 	ldrbvc	r5, [r3, #-3941]	; 0xfffff09b
     efc:	72657362 	rsbvc	r7, r5, #-2013265919	; 0x88000001
     f00:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     f04:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     f08:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     f0c:	6f635f6b 	svcvs	0x00635f6b
     f10:	00746e75 	rsbseq	r6, r4, r5, ror lr
     f14:	61726170 	cmnvs	r2, r0, ror r1
     f18:	5a5f006d 	bpl	17c10d4 <__bss_end+0x17b73dc>
     f1c:	69727735 	ldmdbvs	r2!, {r0, r2, r4, r5, r8, r9, sl, ip, sp, lr}^
     f20:	506a6574 	rsbpl	r6, sl, r4, ror r5
     f24:	006a634b 	rsbeq	r6, sl, fp, asr #6
     f28:	5f746567 	svcpl	0x00746567
     f2c:	6b736174 	blvs	1cd9504 <__bss_end+0x1ccf80c>
     f30:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     f34:	745f736b 	ldrbvc	r7, [pc], #-875	; f3c <shift+0xf3c>
     f38:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
     f3c:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     f40:	6200656e 	andvs	r6, r0, #461373440	; 0x1b800000
     f44:	735f6675 	cmpvc	pc, #122683392	; 0x7500000
     f48:	00657a69 	rsbeq	r7, r5, r9, ror #20
     f4c:	37315a5f 			; <UNDEFINED> instruction: 0x37315a5f
     f50:	5f746567 	svcpl	0x00746567
     f54:	646e6172 	strbtvs	r6, [lr], #-370	; 0xfffffe8e
     f58:	6e5f6d6f 	cdpvs	13, 5, cr6, cr15, cr15, {3}
     f5c:	65626d75 	strbvs	r6, [r2, #-3445]!	; 0xfffff28b
     f60:	5f007672 	svcpl	0x00007672
     f64:	706f345a 	rsbvc	r3, pc, sl, asr r4	; <UNPREDICTABLE>
     f68:	4b506e65 	blmi	141c904 <__bss_end+0x1412c0c>
     f6c:	4e353163 	rsfmisz	f3, f5, f3
     f70:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     f74:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     f78:	6f4d5f6e 	svcvs	0x004d5f6e
     f7c:	77006564 	strvc	r6, [r0, -r4, ror #10]
     f80:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     f84:	74657300 	strbtvc	r7, [r5], #-768	; 0xfffffd00
     f88:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     f8c:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
     f90:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     f94:	4700656e 	strmi	r6, [r0, -lr, ror #10]
     f98:	505f7465 	subspl	r7, pc, r5, ror #8
     f9c:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     fa0:	5a5f0073 	bpl	17c1174 <__bss_end+0x17b747c>
     fa4:	656c7335 	strbvs	r7, [ip, #-821]!	; 0xfffffccb
     fa8:	6a6a7065 	bvs	1a9d144 <__bss_end+0x1a9344c>
     fac:	6c696600 	stclvs	6, cr6, [r9], #-0
     fb0:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     fb4:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
     fb8:	6e69616d 	powvsez	f6, f1, #5.0
     fbc:	00676e69 	rsbeq	r6, r7, r9, ror #28
     fc0:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     fc4:	455f656c 	ldrbmi	r6, [pc, #-1388]	; a60 <shift+0xa60>
     fc8:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     fcc:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     fd0:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     fd4:	5f006e6f 	svcpl	0x00006e6f
     fd8:	6736325a 			; <UNDEFINED> instruction: 0x6736325a
     fdc:	745f7465 	ldrbvc	r7, [pc], #-1125	; fe4 <shift+0xfe4>
     fe0:	5f6b7361 	svcpl	0x006b7361
     fe4:	6b636974 	blvs	18db5bc <__bss_end+0x18d18c4>
     fe8:	6f745f73 	svcvs	0x00745f73
     fec:	6165645f 	cmnvs	r5, pc, asr r4
     ff0:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     ff4:	4e007665 	cfmadd32mi	mvax3, mvfx7, mvfx0, mvfx5
     ff8:	5f495753 	svcpl	0x00495753
     ffc:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
    1000:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
    1004:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1008:	756e7277 	strbvc	r7, [lr, #-631]!	; 0xfffffd89
    100c:	5a5f006d 	bpl	17c11c8 <__bss_end+0x17b74d0>
    1010:	69617734 	stmdbvs	r1!, {r2, r4, r5, r8, r9, sl, ip, sp, lr}^
    1014:	6a6a6a74 	bvs	1a9b9ec <__bss_end+0x1a91cf4>
    1018:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    101c:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
    1020:	36316a6c 	ldrtcc	r6, [r1], -ip, ror #20
    1024:	434f494e 	movtmi	r4, #63822	; 0xf94e
    1028:	4f5f6c74 	svcmi	0x005f6c74
    102c:	61726570 	cmnvs	r2, r0, ror r5
    1030:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1034:	69007650 	stmdbvs	r0, {r4, r6, r9, sl, ip, sp, lr}
    1038:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
    103c:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
    1040:	00746e63 	rsbseq	r6, r4, r3, ror #28
    1044:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
    1048:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
    104c:	6f6d0065 	svcvs	0x006d0065
    1050:	62006564 	andvs	r6, r0, #100, 10	; 0x19000000
    1054:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
    1058:	5a5f0072 	bpl	17c1228 <__bss_end+0x17b7530>
    105c:	61657234 	cmnvs	r5, r4, lsr r2
    1060:	63506a64 	cmpvs	r0, #100, 20	; 0x64000
    1064:	682f006a 	stmdavs	pc!, {r1, r3, r5, r6}	; <UNPREDICTABLE>
    1068:	2f656d6f 	svccs	0x00656d6f
    106c:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
    1070:	642f6b69 	strtvs	r6, [pc], #-2921	; 1078 <shift+0x1078>
    1074:	662f7665 	strtvs	r7, [pc], -r5, ror #12
    1078:	6c616e69 	stclvs	14, cr6, [r1], #-420	; 0xfffffe5c
    107c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    1080:	756f732f 	strbvc	r7, [pc, #-815]!	; d59 <shift+0xd59>
    1084:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    1088:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    108c:	2f62696c 	svccs	0x0062696c
    1090:	2f637273 	svccs	0x00637273
    1094:	66647473 			; <UNDEFINED> instruction: 0x66647473
    1098:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
    109c:	00707063 	rsbseq	r7, r0, r3, rrx
    10a0:	434f494e 	movtmi	r4, #63822	; 0xf94e
    10a4:	4f5f6c74 	svcmi	0x005f6c74
    10a8:	61726570 	cmnvs	r2, r0, ror r5
    10ac:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    10b0:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
    10b4:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
    10b8:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    10bc:	7463615f 	strbtvc	r6, [r3], #-351	; 0xfffffea1
    10c0:	5f657669 	svcpl	0x00657669
    10c4:	636f7270 	cmnvs	pc, #112, 4
    10c8:	5f737365 	svcpl	0x00737365
    10cc:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    10d0:	69660074 	stmdbvs	r6!, {r2, r4, r5, r6}^
    10d4:	616e656c 	cmnvs	lr, ip, ror #10
    10d8:	7200656d 	andvc	r6, r0, #457179136	; 0x1b400000
    10dc:	00646165 	rsbeq	r6, r4, r5, ror #2
    10e0:	70746567 	rsbsvc	r6, r4, r7, ror #10
    10e4:	5f006469 	svcpl	0x00006469
    10e8:	7369385a 	cmnvc	r9, #5898240	; 0x5a0000
    10ec:	6769645f 			; <UNDEFINED> instruction: 0x6769645f
    10f0:	00637469 	rsbeq	r7, r3, r9, ror #8
    10f4:	6f666562 	svcvs	0x00666562
    10f8:	705f6572 	subsvc	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    10fc:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    1100:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1104:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    1108:	4b507970 	blmi	141f6d0 <__bss_end+0x14159d8>
    110c:	69765076 	ldmdbvs	r6!, {r1, r2, r4, r5, r6, ip, lr}^
    1110:	6f682f00 	svcvs	0x00682f00
    1114:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    1118:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    111c:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
    1120:	69662f76 	stmdbvs	r6!, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
    1124:	2f6c616e 	svccs	0x006c616e
    1128:	2f637273 	svccs	0x00637273
    112c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    1130:	2f736563 	svccs	0x00736563
    1134:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    1138:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    113c:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    1140:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
    1144:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1148:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    114c:	6f746600 	svcvs	0x00746600
    1150:	5a5f0061 	bpl	17c12dc <__bss_end+0x17b75e4>
    1154:	6f746934 	svcvs	0x00746934
    1158:	63506a61 	cmpvs	r0, #397312	; 0x61000
    115c:	7369006a 	cmnvc	r9, #106	; 0x6a
    1160:	6f6c665f 	svcvs	0x006c665f
    1164:	74007461 	strvc	r7, [r0], #-1121	; 0xfffffb9f
    1168:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    116c:	74730074 	ldrbtvc	r0, [r3], #-116	; 0xffffff8c
    1170:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
    1174:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1178:	666f7461 	strbtvs	r7, [pc], -r1, ror #8
    117c:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1180:	63395a5f 	teqvs	r9, #389120	; 0x5f000
    1184:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
    1188:	736e6961 	cmnvc	lr, #1589248	; 0x184000
    118c:	63634b50 	cmnvs	r3, #80, 22	; 0x14000
    1190:	706e6900 	rsbvc	r6, lr, r0, lsl #18
    1194:	62007475 	andvs	r7, r0, #1962934272	; 0x75000000
    1198:	00657361 	rsbeq	r7, r5, r1, ror #6
    119c:	736e6f63 	cmnvc	lr, #396	; 0x18c
    11a0:	6e696174 	mcrvs	1, 3, r6, cr9, cr4, {3}
    11a4:	66610073 			; <UNDEFINED> instruction: 0x66610073
    11a8:	5f726574 	svcpl	0x00726574
    11ac:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    11b0:	5a5f0074 	bpl	17c1388 <__bss_end+0x17b7690>
    11b4:	657a6235 	ldrbvs	r6, [sl, #-565]!	; 0xfffffdcb
    11b8:	76506f72 	usub16vc	r6, r0, r2
    11bc:	74730069 	ldrbtvc	r0, [r3], #-105	; 0xffffff97
    11c0:	70636e72 	rsbvc	r6, r3, r2, ror lr
    11c4:	74690079 	strbtvc	r0, [r9], #-121	; 0xffffff87
    11c8:	6400616f 	strvs	r6, [r0], #-367	; 0xfffffe91
    11cc:	00747365 	rsbseq	r7, r4, r5, ror #6
    11d0:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    11d4:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    11d8:	63507970 	cmpvs	r0, #112, 18	; 0x1c0000
    11dc:	69634b50 	stmdbvs	r3!, {r4, r6, r8, r9, fp, lr}^
    11e0:	5f736900 	svcpl	0x00736900
    11e4:	69636564 	stmdbvs	r3!, {r2, r5, r6, r8, sl, sp, lr}^
    11e8:	006c616d 	rsbeq	r6, ip, sp, ror #2
    11ec:	69736f70 	ldmdbvs	r3!, {r4, r5, r6, r8, r9, sl, fp, sp, lr}^
    11f0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    11f4:	5f736900 	svcpl	0x00736900
    11f8:	69676964 	stmdbvs	r7!, {r2, r5, r6, r8, fp, sp, lr}^
    11fc:	74610074 	strbtvc	r0, [r1], #-116	; 0xffffff8c
    1200:	6d00666f 	stcvs	6, cr6, [r0, #-444]	; 0xfffffe44
    1204:	73646d65 	cmnvc	r4, #6464	; 0x1940
    1208:	68430074 	stmdavs	r3, {r2, r4, r5, r6}^
    120c:	6f437261 	svcvs	0x00437261
    1210:	7241766e 	subvc	r7, r1, #115343360	; 0x6e00000
    1214:	74610072 	strbtvc	r0, [r1], #-114	; 0xffffff8e
    1218:	5f00696f 	svcpl	0x0000696f
    121c:	5f6e345a 	svcpl	0x006e345a
    1220:	69697574 	stmdbvs	r9!, {r2, r4, r5, r6, r8, sl, ip, sp, lr}^
    1224:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    1228:	00637273 	rsbeq	r7, r3, r3, ror r2
    122c:	626d756e 	rsbvs	r7, sp, #461373440	; 0x1b800000
    1230:	00327265 	eorseq	r7, r2, r5, ror #4
    1234:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    1238:	656d006f 	strbvs	r0, [sp, #-111]!	; 0xffffff91
    123c:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    1240:	6e656c00 	cdpvs	12, 6, cr6, cr5, cr0, {0}
    1244:	32687467 	rsbcc	r7, r8, #1728053248	; 0x67000000
    1248:	72747300 	rsbsvc	r7, r4, #0, 6
    124c:	706d636e 	rsbvc	r6, sp, lr, ror #6
    1250:	74756f00 	ldrbtvc	r6, [r5], #-3840	; 0xfffff100
    1254:	00747570 	rsbseq	r7, r4, r0, ror r5
    1258:	30315a5f 	eorscc	r5, r1, pc, asr sl
    125c:	645f7369 	ldrbvs	r7, [pc], #-873	; 1264 <shift+0x1264>
    1260:	6d696365 	stclvs	3, cr6, [r9, #-404]!	; 0xfffffe6c
    1264:	4b506c61 	blmi	141c3f0 <__bss_end+0x14126f8>
    1268:	5a5f0063 	bpl	17c13fc <__bss_end+0x17b7704>
    126c:	5f736938 	svcpl	0x00736938
    1270:	616f6c66 	cmnvs	pc, r6, ror #24
    1274:	634b5074 	movtvs	r5, #45172	; 0xb074
    1278:	745f6e00 	ldrbvc	r6, [pc], #-3584	; 1280 <shift+0x1280>
    127c:	69730075 	ldmdbvs	r3!, {r0, r2, r4, r5, r6}^
    1280:	5f006e67 	svcpl	0x00006e67
    1284:	7473365a 	ldrbtvc	r3, [r3], #-1626	; 0xfffff9a6
    1288:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
    128c:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1290:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    1294:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1298:	4b50706d 	blmi	141d454 <__bss_end+0x141375c>
    129c:	5f305363 	svcpl	0x00305363
    12a0:	5a5f0069 	bpl	17c144c <__bss_end+0x17b7754>
    12a4:	6f746134 	svcvs	0x00746134
    12a8:	634b5069 	movtvs	r5, #45161	; 0xb069
    12ac:	756f7300 	strbvc	r7, [pc, #-768]!	; fb4 <shift+0xfb4>
    12b0:	00656372 	rsbeq	r6, r5, r2, ror r3
    12b4:	66345a5f 			; <UNDEFINED> instruction: 0x66345a5f
    12b8:	66616f74 	uqsub16vs	r6, r1, r4
    12bc:	6d006350 	stcvs	3, cr6, [r0, #-320]	; 0xfffffec0
    12c0:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    12c4:	656c0079 	strbvs	r0, [ip, #-121]!	; 0xffffff87
    12c8:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
    12cc:	2f2e2e00 	svccs	0x002e2e00
    12d0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    12d4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    12d8:	2f2e2e2f 	svccs	0x002e2e2f
    12dc:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 122c <shift+0x122c>
    12e0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    12e4:	6f632f63 	svcvs	0x00632f63
    12e8:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    12ec:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    12f0:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    12f4:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
    12f8:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
    12fc:	75622f00 	strbvc	r2, [r2, #-3840]!	; 0xfffff100
    1300:	2f646c69 	svccs	0x00646c69
    1304:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    1308:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    130c:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1310:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1314:	537a2d69 	cmnpl	sl, #6720	; 0x1a40
    1318:	6e665662 	cdpvs	6, 6, cr5, cr6, cr2, {3}
    131c:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    1320:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    1324:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    1328:	61652d65 	cmnvs	r5, r5, ror #26
    132c:	382d6962 	stmdacc	sp!, {r1, r5, r6, r8, fp, sp, lr}
    1330:	3130322d 	teqcc	r0, sp, lsr #4
    1334:	33712d39 	cmncc	r1, #3648	; 0xe40
    1338:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    133c:	612f646c 			; <UNDEFINED> instruction: 0x612f646c
    1340:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1344:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1348:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    134c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1350:	7435762f 	ldrtvc	r7, [r5], #-1583	; 0xfffff9d1
    1354:	61682f65 	cmnvs	r8, r5, ror #30
    1358:	6c2f6472 	cfstrsvs	mvf6, [pc], #-456	; 1198 <shift+0x1198>
    135c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1360:	4e470063 	cdpmi	0, 4, cr0, cr7, cr3, {3}
    1364:	53412055 	movtpl	r2, #4181	; 0x1055
    1368:	332e3220 			; <UNDEFINED> instruction: 0x332e3220
    136c:	2e2e0034 	mcrcs	0, 1, r0, cr14, cr4, {1}
    1370:	2f2e2e2f 	svccs	0x002e2e2f
    1374:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1378:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    137c:	2f2e2e2f 	svccs	0x002e2e2f
    1380:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1384:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    1388:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    138c:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    1390:	65692f6d 	strbvs	r2, [r9, #-3949]!	; 0xfffff093
    1394:	35376565 	ldrcc	r6, [r7, #-1381]!	; 0xfffffa9b
    1398:	66732d34 			; <UNDEFINED> instruction: 0x66732d34
    139c:	2e00532e 	cdpcs	3, 0, cr5, cr0, cr14, {1}
    13a0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    13a4:	2f2e2e2f 	svccs	0x002e2e2f
    13a8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    13ac:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    13b0:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    13b4:	2f636367 	svccs	0x00636367
    13b8:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    13bc:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    13c0:	622f6d72 	eorvs	r6, pc, #7296	; 0x1c80
    13c4:	69626170 	stmdbvs	r2!, {r4, r5, r6, r8, sp, lr}^
    13c8:	5400532e 	strpl	r5, [r0], #-814	; 0xfffffcd2
    13cc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    13d0:	50435f54 	subpl	r5, r3, r4, asr pc
    13d4:	6f635f55 	svcvs	0x00635f55
    13d8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    13dc:	63373161 	teqvs	r7, #1073741848	; 0x40000018
    13e0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    13e4:	00376178 	eorseq	r6, r7, r8, ror r1
    13e8:	5f617369 	svcpl	0x00617369
    13ec:	5f746962 	svcpl	0x00746962
    13f0:	645f7066 	ldrbvs	r7, [pc], #-102	; 13f8 <shift+0x13f8>
    13f4:	54006c62 	strpl	r6, [r0], #-3170	; 0xfffff39e
    13f8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    13fc:	50435f54 	subpl	r5, r3, r4, asr pc
    1400:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1404:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    1408:	00736a36 	rsbseq	r6, r3, r6, lsr sl
    140c:	5f6d7261 	svcpl	0x006d7261
    1410:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1414:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1418:	0074786d 	rsbseq	r7, r4, sp, ror #16
    141c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1420:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1424:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1428:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    142c:	33326d78 	teqcc	r2, #120, 26	; 0x1e00
    1430:	4d524100 	ldfmie	f4, [r2, #-0]
    1434:	0051455f 	subseq	r4, r1, pc, asr r5
    1438:	47524154 			; <UNDEFINED> instruction: 0x47524154
    143c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1440:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1444:	31316d72 	teqcc	r1, r2, ror sp
    1448:	32743635 	rsbscc	r3, r4, #55574528	; 0x3500000
    144c:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1450:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1454:	745f7469 	ldrbvc	r7, [pc], #-1129	; 145c <shift+0x145c>
    1458:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    145c:	52415400 	subpl	r5, r1, #0, 8
    1460:	5f544547 	svcpl	0x00544547
    1464:	5f555043 	svcpl	0x00555043
    1468:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    146c:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1470:	726f6337 	rsbvc	r6, pc, #-603979776	; 0xdc000000
    1474:	61786574 	cmnvs	r8, r4, ror r5
    1478:	42003335 	andmi	r3, r0, #-738197504	; 0xd4000000
    147c:	5f455341 	svcpl	0x00455341
    1480:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1484:	5f4d385f 	svcpl	0x004d385f
    1488:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    148c:	52415400 	subpl	r5, r1, #0, 8
    1490:	5f544547 	svcpl	0x00544547
    1494:	5f555043 	svcpl	0x00555043
    1498:	386d7261 	stmdacc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    149c:	54003031 	strpl	r3, [r0], #-49	; 0xffffffcf
    14a0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    14a4:	50435f54 	subpl	r5, r3, r4, asr pc
    14a8:	67785f55 			; <UNDEFINED> instruction: 0x67785f55
    14ac:	31656e65 	cmncc	r5, r5, ror #28
    14b0:	4d524100 	ldfmie	f4, [r2, #-0]
    14b4:	5343505f 	movtpl	r5, #12383	; 0x305f
    14b8:	5041415f 	subpl	r4, r1, pc, asr r1
    14bc:	495f5343 	ldmdbmi	pc, {r0, r1, r6, r8, r9, ip, lr}^	; <UNPREDICTABLE>
    14c0:	584d4d57 	stmdapl	sp, {r0, r1, r2, r4, r6, r8, sl, fp, lr}^
    14c4:	41540054 	cmpmi	r4, r4, asr r0
    14c8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    14cc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    14d0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    14d4:	00696437 	rsbeq	r6, r9, r7, lsr r4
    14d8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    14dc:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    14e0:	00325f48 	eorseq	r5, r2, r8, asr #30
    14e4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    14e8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    14ec:	00335f48 	eorseq	r5, r3, r8, asr #30
    14f0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    14f4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    14f8:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    14fc:	64376d72 	ldrtvs	r6, [r7], #-3442	; 0xfffff28e
    1500:	4142006d 	cmpmi	r2, sp, rrx
    1504:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1508:	5f484352 	svcpl	0x00484352
    150c:	41420035 	cmpmi	r2, r5, lsr r0
    1510:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1514:	5f484352 	svcpl	0x00484352
    1518:	41420036 	cmpmi	r2, r6, lsr r0
    151c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1520:	5f484352 	svcpl	0x00484352
    1524:	41540037 	cmpmi	r4, r7, lsr r0
    1528:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    152c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1530:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    1534:	00656c61 	rsbeq	r6, r5, r1, ror #24
    1538:	47524154 			; <UNDEFINED> instruction: 0x47524154
    153c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1540:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1544:	34396d72 	ldrtcc	r6, [r9], #-3442	; 0xfffff28e
    1548:	00736536 	rsbseq	r6, r3, r6, lsr r5
    154c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1550:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1554:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1558:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    155c:	33336d78 	teqcc	r3, #120, 26	; 0x1e00
    1560:	52415400 	subpl	r5, r1, #0, 8
    1564:	5f544547 	svcpl	0x00544547
    1568:	5f555043 	svcpl	0x00555043
    156c:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1570:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    1574:	61736900 	cmnvs	r3, r0, lsl #18
    1578:	626f6e5f 	rsbvs	r6, pc, #1520	; 0x5f0
    157c:	54007469 	strpl	r7, [r0], #-1129	; 0xfffffb97
    1580:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1584:	50435f54 	subpl	r5, r3, r4, asr pc
    1588:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    158c:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    1590:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
    1594:	73690073 	cmnvc	r9, #115	; 0x73
    1598:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    159c:	66765f74 	uhsub16vs	r5, r6, r4
    15a0:	00327670 	eorseq	r7, r2, r0, ror r6
    15a4:	5f4d5241 	svcpl	0x004d5241
    15a8:	5f534350 	svcpl	0x00534350
    15ac:	4e4b4e55 	mcrmi	14, 2, r4, cr11, cr5, {2}
    15b0:	004e574f 	subeq	r5, lr, pc, asr #14
    15b4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    15b8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    15bc:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    15c0:	65396d72 	ldrvs	r6, [r9, #-3442]!	; 0xfffff28e
    15c4:	53414200 	movtpl	r4, #4608	; 0x1200
    15c8:	52415f45 	subpl	r5, r1, #276	; 0x114
    15cc:	355f4843 	ldrbcc	r4, [pc, #-2115]	; d91 <shift+0xd91>
    15d0:	004a4554 	subeq	r4, sl, r4, asr r5
    15d4:	5f6d7261 	svcpl	0x006d7261
    15d8:	73666363 	cmnvc	r6, #-1946157055	; 0x8c000001
    15dc:	74735f6d 	ldrbtvc	r5, [r3], #-3949	; 0xfffff093
    15e0:	00657461 	rsbeq	r7, r5, r1, ror #8
    15e4:	70736e75 	rsbsvc	r6, r3, r5, ror lr
    15e8:	735f6365 	cmpvc	pc, #-1811939327	; 0x94000001
    15ec:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    15f0:	69007367 	stmdbvs	r0, {r0, r1, r2, r5, r6, r8, r9, ip, sp, lr}
    15f4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    15f8:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    15fc:	5f006365 	svcpl	0x00006365
    1600:	7a6c635f 	bvc	1b1a384 <__bss_end+0x1b1068c>
    1604:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    1608:	4d524100 	ldfmie	f4, [r2, #-0]
    160c:	0043565f 	subeq	r5, r3, pc, asr r6
    1610:	5f6d7261 	svcpl	0x006d7261
    1614:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1618:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    161c:	00656c61 	rsbeq	r6, r5, r1, ror #24
    1620:	5f4d5241 	svcpl	0x004d5241
    1624:	4100454c 	tstmi	r0, ip, asr #10
    1628:	565f4d52 			; <UNDEFINED> instruction: 0x565f4d52
    162c:	52410053 	subpl	r0, r1, #83	; 0x53
    1630:	45475f4d 	strbmi	r5, [r7, #-3917]	; 0xfffff0b3
    1634:	6d726100 	ldfvse	f6, [r2, #-0]
    1638:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    163c:	74735f65 	ldrbtvc	r5, [r3], #-3941	; 0xfffff09b
    1640:	676e6f72 			; <UNDEFINED> instruction: 0x676e6f72
    1644:	006d7261 	rsbeq	r7, sp, r1, ror #4
    1648:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    164c:	2078656c 	rsbscs	r6, r8, ip, ror #10
    1650:	616f6c66 	cmnvs	pc, r6, ror #24
    1654:	41540074 	cmpmi	r4, r4, ror r0
    1658:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    165c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1660:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1664:	61786574 	cmnvs	r8, r4, ror r5
    1668:	54003531 	strpl	r3, [r0], #-1329	; 0xfffffacf
    166c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1670:	50435f54 	subpl	r5, r3, r4, asr pc
    1674:	61665f55 	cmnvs	r6, r5, asr pc
    1678:	74363237 	ldrtvc	r3, [r6], #-567	; 0xfffffdc9
    167c:	41540065 	cmpmi	r4, r5, rrx
    1680:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1684:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1688:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    168c:	61786574 	cmnvs	r8, r4, ror r5
    1690:	41003731 	tstmi	r0, r1, lsr r7
    1694:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    1698:	52410054 	subpl	r0, r1, #84	; 0x54
    169c:	544c5f4d 	strbpl	r5, [ip], #-3917	; 0xfffff0b3
    16a0:	2f2e2e00 	svccs	0x002e2e00
    16a4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    16a8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    16ac:	2f2e2e2f 	svccs	0x002e2e2f
    16b0:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1600 <shift+0x1600>
    16b4:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    16b8:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    16bc:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    16c0:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    16c4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    16c8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    16cc:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    16d0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    16d4:	66347278 			; <UNDEFINED> instruction: 0x66347278
    16d8:	52415400 	subpl	r5, r1, #0, 8
    16dc:	5f544547 	svcpl	0x00544547
    16e0:	5f555043 	svcpl	0x00555043
    16e4:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    16e8:	42003032 	andmi	r3, r0, #50	; 0x32
    16ec:	5f455341 	svcpl	0x00455341
    16f0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    16f4:	4d45375f 	stclmi	7, cr3, [r5, #-380]	; 0xfffffe84
    16f8:	52415400 	subpl	r5, r1, #0, 8
    16fc:	5f544547 	svcpl	0x00544547
    1700:	5f555043 	svcpl	0x00555043
    1704:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1708:	31617865 	cmncc	r1, r5, ror #16
    170c:	61680032 	cmnvs	r8, r2, lsr r0
    1710:	61766873 	cmnvs	r6, r3, ror r8
    1714:	00745f6c 	rsbseq	r5, r4, ip, ror #30
    1718:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    171c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1720:	4b365f48 	blmi	d99448 <__bss_end+0xd8f750>
    1724:	7369005a 	cmnvc	r9, #90	; 0x5a
    1728:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    172c:	61007374 	tstvs	r0, r4, ror r3
    1730:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1734:	5f686372 	svcpl	0x00686372
    1738:	5f6d7261 	svcpl	0x006d7261
    173c:	69647768 	stmdbvs	r4!, {r3, r5, r6, r8, r9, sl, ip, sp, lr}^
    1740:	72610076 	rsbvc	r0, r1, #118	; 0x76
    1744:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    1748:	65645f75 	strbvs	r5, [r4, #-3957]!	; 0xfffff08b
    174c:	69006373 	stmdbvs	r0, {r0, r1, r4, r5, r6, r8, r9, sp, lr}
    1750:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1754:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1758:	00363170 	eorseq	r3, r6, r0, ror r1
    175c:	5f4d5241 	svcpl	0x004d5241
    1760:	54004948 	strpl	r4, [r0], #-2376	; 0xfffff6b8
    1764:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1768:	50435f54 	subpl	r5, r3, r4, asr pc
    176c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1770:	5400326d 	strpl	r3, [r0], #-621	; 0xfffffd93
    1774:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1778:	50435f54 	subpl	r5, r3, r4, asr pc
    177c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1780:	5400336d 	strpl	r3, [r0], #-877	; 0xfffffc93
    1784:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1788:	50435f54 	subpl	r5, r3, r4, asr pc
    178c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1790:	3031376d 	eorscc	r3, r1, sp, ror #14
    1794:	41540030 	cmpmi	r4, r0, lsr r0
    1798:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    179c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    17a0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    17a4:	41540036 	cmpmi	r4, r6, lsr r0
    17a8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    17ac:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    17b0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    17b4:	41540037 	cmpmi	r4, r7, lsr r0
    17b8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    17bc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    17c0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    17c4:	41540038 	cmpmi	r4, r8, lsr r0
    17c8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    17cc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    17d0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    17d4:	41540039 	cmpmi	r4, r9, lsr r0
    17d8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    17dc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    17e0:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    17e4:	54003632 	strpl	r3, [r0], #-1586	; 0xfffff9ce
    17e8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    17ec:	50435f54 	subpl	r5, r3, r4, asr pc
    17f0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    17f4:	6f6e5f6d 	svcvs	0x006e5f6d
    17f8:	6c00656e 	cfstr32vs	mvfx6, [r0], {110}	; 0x6e
    17fc:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    1800:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    1804:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
    1808:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
    180c:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
    1810:	72610074 	rsbvc	r0, r1, #116	; 0x74
    1814:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1818:	635f6863 	cmpvs	pc, #6488064	; 0x630000
    181c:	0065736d 	rsbeq	r7, r5, sp, ror #6
    1820:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1824:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1828:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    182c:	31366d72 	teqcc	r6, r2, ror sp
    1830:	41540030 	cmpmi	r4, r0, lsr r0
    1834:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1838:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    183c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1840:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1844:	41540034 	cmpmi	r4, r4, lsr r0
    1848:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    184c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1850:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1854:	00653031 	rsbeq	r3, r5, r1, lsr r0
    1858:	47524154 			; <UNDEFINED> instruction: 0x47524154
    185c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1860:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1864:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1868:	00376d78 	eorseq	r6, r7, r8, ror sp
    186c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1870:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1874:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1878:	35376d72 	ldrcc	r6, [r7, #-3442]!	; 0xfffff28e
    187c:	65663030 	strbvs	r3, [r6, #-48]!	; 0xffffffd0
    1880:	52415400 	subpl	r5, r1, #0, 8
    1884:	5f544547 	svcpl	0x00544547
    1888:	5f555043 	svcpl	0x00555043
    188c:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1890:	00633031 	rsbeq	r3, r3, r1, lsr r0
    1894:	5f6d7261 	svcpl	0x006d7261
    1898:	646e6f63 	strbtvs	r6, [lr], #-3939	; 0xfffff09d
    189c:	646f635f 	strbtvs	r6, [pc], #-863	; 18a4 <shift+0x18a4>
    18a0:	52410065 	subpl	r0, r1, #101	; 0x65
    18a4:	43505f4d 	cmpmi	r0, #308	; 0x134
    18a8:	41415f53 	cmpmi	r1, r3, asr pc
    18ac:	00534350 	subseq	r4, r3, r0, asr r3
    18b0:	5f617369 	svcpl	0x00617369
    18b4:	5f746962 	svcpl	0x00746962
    18b8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    18bc:	00325f38 	eorseq	r5, r2, r8, lsr pc
    18c0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    18c4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    18c8:	4d335f48 	ldcmi	15, cr5, [r3, #-288]!	; 0xfffffee0
    18cc:	52415400 	subpl	r5, r1, #0, 8
    18d0:	5f544547 	svcpl	0x00544547
    18d4:	5f555043 	svcpl	0x00555043
    18d8:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    18dc:	00743031 	rsbseq	r3, r4, r1, lsr r0
    18e0:	5f6d7261 	svcpl	0x006d7261
    18e4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    18e8:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    18ec:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    18f0:	61736900 	cmnvs	r3, r0, lsl #18
    18f4:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
    18f8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    18fc:	41540073 	cmpmi	r4, r3, ror r0
    1900:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1904:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1908:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    190c:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1910:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    1914:	616d7373 	smcvs	55091	; 0xd733
    1918:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    191c:	7069746c 	rsbvc	r7, r9, ip, ror #8
    1920:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    1924:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1928:	50435f54 	subpl	r5, r3, r4, asr pc
    192c:	78655f55 	stmdavc	r5!, {r0, r2, r4, r6, r8, r9, sl, fp, ip, lr}^
    1930:	736f6e79 	cmnvc	pc, #1936	; 0x790
    1934:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    1938:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    193c:	50435f54 	subpl	r5, r3, r4, asr pc
    1940:	6f635f55 	svcvs	0x00635f55
    1944:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1948:	00323572 	eorseq	r3, r2, r2, ror r5
    194c:	5f617369 	svcpl	0x00617369
    1950:	5f746962 	svcpl	0x00746962
    1954:	76696474 			; <UNDEFINED> instruction: 0x76696474
    1958:	65727000 	ldrbvs	r7, [r2, #-0]!
    195c:	5f726566 	svcpl	0x00726566
    1960:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    1964:	726f665f 	rsbvc	r6, pc, #99614720	; 0x5f00000
    1968:	6234365f 	eorsvs	r3, r4, #99614720	; 0x5f00000
    196c:	00737469 	rsbseq	r7, r3, r9, ror #8
    1970:	5f617369 	svcpl	0x00617369
    1974:	5f746962 	svcpl	0x00746962
    1978:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    197c:	006c6d66 	rsbeq	r6, ip, r6, ror #26
    1980:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1984:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1988:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    198c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1990:	32336178 	eorscc	r6, r3, #120, 2
    1994:	52415400 	subpl	r5, r1, #0, 8
    1998:	5f544547 	svcpl	0x00544547
    199c:	5f555043 	svcpl	0x00555043
    19a0:	366d7261 	strbtcc	r7, [sp], -r1, ror #4
    19a4:	69003032 	stmdbvs	r0, {r1, r4, r5, ip, sp}
    19a8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    19ac:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    19b0:	63363170 	teqvs	r6, #112, 2
    19b4:	00766e6f 	rsbseq	r6, r6, pc, ror #28
    19b8:	70736e75 	rsbsvc	r6, r3, r5, ror lr
    19bc:	5f766365 	svcpl	0x00766365
    19c0:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    19c4:	0073676e 	rsbseq	r6, r3, lr, ror #14
    19c8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    19cc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    19d0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    19d4:	31316d72 	teqcc	r1, r2, ror sp
    19d8:	32743635 	rsbscc	r3, r4, #55574528	; 0x3500000
    19dc:	41540073 	cmpmi	r4, r3, ror r0
    19e0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    19e4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    19e8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    19ec:	36323031 			; <UNDEFINED> instruction: 0x36323031
    19f0:	00736a65 	rsbseq	r6, r3, r5, ror #20
    19f4:	5f6d7261 	svcpl	0x006d7261
    19f8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    19fc:	54006d33 	strpl	r6, [r0], #-3379	; 0xfffff2cd
    1a00:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a04:	50435f54 	subpl	r5, r3, r4, asr pc
    1a08:	61665f55 	cmnvs	r6, r5, asr pc
    1a0c:	74363036 	ldrtvc	r3, [r6], #-54	; 0xffffffca
    1a10:	41540065 	cmpmi	r4, r5, rrx
    1a14:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a18:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a1c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1a20:	65363239 	ldrvs	r3, [r6, #-569]!	; 0xfffffdc7
    1a24:	4200736a 	andmi	r7, r0, #-1476395007	; 0xa8000001
    1a28:	5f455341 	svcpl	0x00455341
    1a2c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1a30:	0054345f 	subseq	r3, r4, pc, asr r4
    1a34:	5f617369 	svcpl	0x00617369
    1a38:	5f746962 	svcpl	0x00746962
    1a3c:	70797263 	rsbsvc	r7, r9, r3, ror #4
    1a40:	61006f74 	tstvs	r0, r4, ror pc
    1a44:	725f6d72 	subsvc	r6, pc, #7296	; 0x1c80
    1a48:	5f736765 	svcpl	0x00736765
    1a4c:	735f6e69 	cmpvc	pc, #1680	; 0x690
    1a50:	65757165 	ldrbvs	r7, [r5, #-357]!	; 0xfffffe9b
    1a54:	0065636e 	rsbeq	r6, r5, lr, ror #6
    1a58:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1a5c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1a60:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    1a64:	41540045 	cmpmi	r4, r5, asr #32
    1a68:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a6c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a70:	3970655f 	ldmdbcc	r0!, {r0, r1, r2, r3, r4, r6, r8, sl, sp, lr}^
    1a74:	00323133 	eorseq	r3, r2, r3, lsr r1
    1a78:	5f617369 	svcpl	0x00617369
    1a7c:	74616566 	strbtvc	r6, [r1], #-1382	; 0xfffffa9a
    1a80:	00657275 	rsbeq	r7, r5, r5, ror r2
    1a84:	5f617369 	svcpl	0x00617369
    1a88:	5f746962 	svcpl	0x00746962
    1a8c:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    1a90:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    1a94:	6d726100 	ldfvse	f6, [r2, #-0]
    1a98:	6e616c5f 	mcrvs	12, 3, r6, cr1, cr15, {2}
    1a9c:	756f5f67 	strbvc	r5, [pc, #-3943]!	; b3d <shift+0xb3d>
    1aa0:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    1aa4:	6a626f5f 	bvs	189d828 <__bss_end+0x1893b30>
    1aa8:	5f746365 	svcpl	0x00746365
    1aac:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    1ab0:	74756269 	ldrbtvc	r6, [r5], #-617	; 0xfffffd97
    1ab4:	685f7365 	ldmdavs	pc, {r0, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    1ab8:	006b6f6f 	rsbeq	r6, fp, pc, ror #30
    1abc:	5f617369 	svcpl	0x00617369
    1ac0:	5f746962 	svcpl	0x00746962
    1ac4:	645f7066 	ldrbvs	r7, [pc], #-102	; 1acc <shift+0x1acc>
    1ac8:	41003233 	tstmi	r0, r3, lsr r2
    1acc:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    1ad0:	73690045 	cmnvc	r9, #69	; 0x45
    1ad4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ad8:	65625f74 	strbvs	r5, [r2, #-3956]!	; 0xfffff08c
    1adc:	41540038 	cmpmi	r4, r8, lsr r0
    1ae0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ae4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ae8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1aec:	36373131 			; <UNDEFINED> instruction: 0x36373131
    1af0:	00737a6a 	rsbseq	r7, r3, sl, ror #20
    1af4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1af8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1afc:	45355f48 	ldrmi	r5, [r5, #-3912]!	; 0xfffff0b8
    1b00:	61736900 	cmnvs	r3, r0, lsl #18
    1b04:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1b08:	6964615f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sp, lr}^
    1b0c:	72700076 	rsbsvc	r0, r0, #118	; 0x76
    1b10:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1b14:	5f726f73 	svcpl	0x00726f73
    1b18:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    1b1c:	6c6c6100 	stfvse	f6, [ip], #-0
    1b20:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    1b24:	72610073 	rsbvc	r0, r1, #115	; 0x73
    1b28:	63705f6d 	cmnvs	r0, #436	; 0x1b4
    1b2c:	41420073 	hvcmi	8195	; 0x2003
    1b30:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1b34:	5f484352 	svcpl	0x00484352
    1b38:	61005435 	tstvs	r0, r5, lsr r4
    1b3c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1b40:	34686372 	strbtcc	r6, [r8], #-882	; 0xfffffc8e
    1b44:	41540074 	cmpmi	r4, r4, ror r0
    1b48:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b4c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b50:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1b54:	61786574 	cmnvs	r8, r4, ror r5
    1b58:	6f633531 	svcvs	0x00633531
    1b5c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1b60:	61003761 	tstvs	r0, r1, ror #14
    1b64:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1b6c <shift+0x1b6c>
    1b68:	5f656e75 	svcpl	0x00656e75
    1b6c:	66756277 			; <UNDEFINED> instruction: 0x66756277
    1b70:	61746800 	cmnvs	r4, r0, lsl #16
    1b74:	61685f62 	cmnvs	r8, r2, ror #30
    1b78:	69006873 	stmdbvs	r0, {r0, r1, r4, r5, r6, fp, sp, lr}
    1b7c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1b80:	715f7469 	cmpvc	pc, r9, ror #8
    1b84:	6b726975 	blvs	1c9c160 <__bss_end+0x1c92468>
    1b88:	5f6f6e5f 	svcpl	0x006f6e5f
    1b8c:	616c6f76 	smcvs	50934	; 0xc6f6
    1b90:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    1b94:	0065635f 	rsbeq	r6, r5, pc, asr r3
    1b98:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b9c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ba0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1ba4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1ba8:	00306d78 	eorseq	r6, r0, r8, ror sp
    1bac:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1bb0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1bb4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1bb8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1bbc:	00316d78 	eorseq	r6, r1, r8, ror sp
    1bc0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1bc4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1bc8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1bcc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1bd0:	00336d78 	eorseq	r6, r3, r8, ror sp
    1bd4:	5f617369 	svcpl	0x00617369
    1bd8:	5f746962 	svcpl	0x00746962
    1bdc:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1be0:	00315f38 	eorseq	r5, r1, r8, lsr pc
    1be4:	5f6d7261 	svcpl	0x006d7261
    1be8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1bec:	6d616e5f 	stclvs	14, cr6, [r1, #-380]!	; 0xfffffe84
    1bf0:	73690065 	cmnvc	r9, #101	; 0x65
    1bf4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1bf8:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1bfc:	5f38766d 	svcpl	0x0038766d
    1c00:	73690033 	cmnvc	r9, #51	; 0x33
    1c04:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1c08:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1c0c:	5f38766d 	svcpl	0x0038766d
    1c10:	41540034 	cmpmi	r4, r4, lsr r0
    1c14:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c18:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c1c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1c20:	61786574 	cmnvs	r8, r4, ror r5
    1c24:	54003335 	strpl	r3, [r0], #-821	; 0xfffffccb
    1c28:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c2c:	50435f54 	subpl	r5, r3, r4, asr pc
    1c30:	6f635f55 	svcvs	0x00635f55
    1c34:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1c38:	00353561 	eorseq	r3, r5, r1, ror #10
    1c3c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c40:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c44:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1c48:	64376d72 	ldrtvs	r6, [r7], #-3442	; 0xfffff28e
    1c4c:	5400696d 	strpl	r6, [r0], #-2413	; 0xfffff693
    1c50:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c54:	50435f54 	subpl	r5, r3, r4, asr pc
    1c58:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    1c5c:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    1c60:	61736900 	cmnvs	r3, r0, lsl #18
    1c64:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1c68:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1c6c:	006d3376 	rsbeq	r3, sp, r6, ror r3
    1c70:	5f6d7261 	svcpl	0x006d7261
    1c74:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1c78:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 1c80 <shift+0x1c80>
    1c7c:	7261006d 	rsbvc	r0, r1, #109	; 0x6d
    1c80:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1c84:	65356863 	ldrvs	r6, [r5, #-2147]!	; 0xfffff79d
    1c88:	52415400 	subpl	r5, r1, #0, 8
    1c8c:	5f544547 	svcpl	0x00544547
    1c90:	5f555043 	svcpl	0x00555043
    1c94:	316d7261 	cmncc	sp, r1, ror #4
    1c98:	65303230 	ldrvs	r3, [r0, #-560]!	; 0xfffffdd0
    1c9c:	53414200 	movtpl	r4, #4608	; 0x1200
    1ca0:	52415f45 	subpl	r5, r1, #276	; 0x114
    1ca4:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1ca8:	4154004a 	cmpmi	r4, sl, asr #32
    1cac:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cb0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cb4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1cb8:	65383639 	ldrvs	r3, [r8, #-1593]!	; 0xfffff9c7
    1cbc:	41540073 	cmpmi	r4, r3, ror r0
    1cc0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cc4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cc8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1ccc:	74303437 	ldrtvc	r3, [r0], #-1079	; 0xfffffbc9
    1cd0:	53414200 	movtpl	r4, #4608	; 0x1200
    1cd4:	52415f45 	subpl	r5, r1, #276	; 0x114
    1cd8:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1cdc:	7369004d 	cmnvc	r9, #77	; 0x4d
    1ce0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ce4:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    1ce8:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1cec:	52415400 	subpl	r5, r1, #0, 8
    1cf0:	5f544547 	svcpl	0x00544547
    1cf4:	5f555043 	svcpl	0x00555043
    1cf8:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1cfc:	54003030 	strpl	r3, [r0], #-48	; 0xffffffd0
    1d00:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1d04:	50435f54 	subpl	r5, r3, r4, asr pc
    1d08:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1d0c:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    1d10:	73666a36 	cmnvc	r6, #221184	; 0x36000
    1d14:	4d524100 	ldfmie	f4, [r2, #-0]
    1d18:	00534c5f 	subseq	r4, r3, pc, asr ip
    1d1c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d20:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d24:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1d28:	30316d72 	eorscc	r6, r1, r2, ror sp
    1d2c:	00743032 	rsbseq	r3, r4, r2, lsr r0
    1d30:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1d34:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1d38:	5a365f48 	bpl	d99a60 <__bss_end+0xd8fd68>
    1d3c:	52415400 	subpl	r5, r1, #0, 8
    1d40:	5f544547 	svcpl	0x00544547
    1d44:	5f555043 	svcpl	0x00555043
    1d48:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1d4c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1d50:	726f6335 	rsbvc	r6, pc, #-738197504	; 0xd4000000
    1d54:	61786574 	cmnvs	r8, r4, ror r5
    1d58:	41003535 	tstmi	r0, r5, lsr r5
    1d5c:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1d60:	415f5343 	cmpmi	pc, r3, asr #6
    1d64:	53435041 	movtpl	r5, #12353	; 0x3041
    1d68:	5046565f 	subpl	r5, r6, pc, asr r6
    1d6c:	52415400 	subpl	r5, r1, #0, 8
    1d70:	5f544547 	svcpl	0x00544547
    1d74:	5f555043 	svcpl	0x00555043
    1d78:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1d7c:	00327478 	eorseq	r7, r2, r8, ror r4
    1d80:	5f617369 	svcpl	0x00617369
    1d84:	5f746962 	svcpl	0x00746962
    1d88:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    1d8c:	6d726100 	ldfvse	f6, [r2, #-0]
    1d90:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    1d94:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    1d98:	73690072 	cmnvc	r9, #114	; 0x72
    1d9c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1da0:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1da4:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
    1da8:	4154006d 	cmpmi	r4, sp, rrx
    1dac:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1db0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1db4:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    1db8:	65743632 	ldrbvs	r3, [r4, #-1586]!	; 0xfffff9ce
    1dbc:	52415400 	subpl	r5, r1, #0, 8
    1dc0:	5f544547 	svcpl	0x00544547
    1dc4:	5f555043 	svcpl	0x00555043
    1dc8:	7672616d 	ldrbtvc	r6, [r2], -sp, ror #2
    1dcc:	5f6c6c65 	svcpl	0x006c6c65
    1dd0:	00346a70 	eorseq	r6, r4, r0, ror sl
    1dd4:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    1dd8:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    1ddc:	6f705f68 	svcvs	0x00705f68
    1de0:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    1de4:	41540072 	cmpmi	r4, r2, ror r0
    1de8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1dec:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1df0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1df4:	61786574 	cmnvs	r8, r4, ror r5
    1df8:	61003533 	tstvs	r0, r3, lsr r5
    1dfc:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1e04 <shift+0x1e04>
    1e00:	5f656e75 	svcpl	0x00656e75
    1e04:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1e08:	615f7865 	cmpvs	pc, r5, ror #16
    1e0c:	73690039 	cmnvc	r9, #57	; 0x39
    1e10:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1e14:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    1e18:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1e1c:	41540032 	cmpmi	r4, r2, lsr r0
    1e20:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e24:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e28:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1e2c:	61786574 	cmnvs	r8, r4, ror r5
    1e30:	6f633237 	svcvs	0x00633237
    1e34:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1e38:	00333561 	eorseq	r3, r3, r1, ror #10
    1e3c:	5f617369 	svcpl	0x00617369
    1e40:	5f746962 	svcpl	0x00746962
    1e44:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    1e48:	42003262 	andmi	r3, r0, #536870918	; 0x20000006
    1e4c:	5f455341 	svcpl	0x00455341
    1e50:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1e54:	0041375f 	subeq	r3, r1, pc, asr r7
    1e58:	5f617369 	svcpl	0x00617369
    1e5c:	5f746962 	svcpl	0x00746962
    1e60:	70746f64 	rsbsvc	r6, r4, r4, ror #30
    1e64:	00646f72 	rsbeq	r6, r4, r2, ror pc
    1e68:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1e6c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1e70:	00305f48 	eorseq	r5, r0, r8, asr #30
    1e74:	5f6d7261 	svcpl	0x006d7261
    1e78:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1e7c:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    1e80:	6f6e5f65 	svcvs	0x006e5f65
    1e84:	41006564 	tstmi	r0, r4, ror #10
    1e88:	4d5f4d52 	ldclmi	13, cr4, [pc, #-328]	; 1d48 <shift+0x1d48>
    1e8c:	72610049 	rsbvc	r0, r1, #73	; 0x49
    1e90:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1e94:	6b366863 	blvs	d9c028 <__bss_end+0xd92330>
    1e98:	6d726100 	ldfvse	f6, [r2, #-0]
    1e9c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1ea0:	006d3668 	rsbeq	r3, sp, r8, ror #12
    1ea4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1ea8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1eac:	00345f48 	eorseq	r5, r4, r8, asr #30
    1eb0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1eb4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1eb8:	52375f48 	eorspl	r5, r7, #72, 30	; 0x120
    1ebc:	705f5f00 	subsvc	r5, pc, r0, lsl #30
    1ec0:	6f63706f 	svcvs	0x0063706f
    1ec4:	5f746e75 	svcpl	0x00746e75
    1ec8:	00626174 	rsbeq	r6, r2, r4, ror r1
    1ecc:	5f617369 	svcpl	0x00617369
    1ed0:	5f746962 	svcpl	0x00746962
    1ed4:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    1ed8:	52415400 	subpl	r5, r1, #0, 8
    1edc:	5f544547 	svcpl	0x00544547
    1ee0:	5f555043 	svcpl	0x00555043
    1ee4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1ee8:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1eec:	41540033 	cmpmi	r4, r3, lsr r0
    1ef0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ef4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ef8:	6e65675f 	mcrvs	7, 3, r6, cr5, cr15, {2}
    1efc:	63697265 	cmnvs	r9, #1342177286	; 0x50000006
    1f00:	00613776 	rsbeq	r3, r1, r6, ror r7
    1f04:	5f617369 	svcpl	0x00617369
    1f08:	5f746962 	svcpl	0x00746962
    1f0c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1f10:	61006535 	tstvs	r0, r5, lsr r5
    1f14:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1f18:	5f686372 	svcpl	0x00686372
    1f1c:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    1f20:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    1f24:	5f656c69 	svcpl	0x00656c69
    1f28:	42006563 	andmi	r6, r0, #415236096	; 0x18c00000
    1f2c:	5f455341 	svcpl	0x00455341
    1f30:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1f34:	0041385f 	subeq	r3, r1, pc, asr r8
    1f38:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f3c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f40:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1f44:	30316d72 	eorscc	r6, r1, r2, ror sp
    1f48:	00653232 	rsbeq	r3, r5, r2, lsr r2
    1f4c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1f50:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1f54:	52385f48 	eorspl	r5, r8, #72, 30	; 0x120
    1f58:	52415400 	subpl	r5, r1, #0, 8
    1f5c:	5f544547 	svcpl	0x00544547
    1f60:	5f555043 	svcpl	0x00555043
    1f64:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1f68:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1f6c:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    1f70:	61786574 	cmnvs	r8, r4, ror r5
    1f74:	41003533 	tstmi	r0, r3, lsr r5
    1f78:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    1f7c:	72610056 	rsbvc	r0, r1, #86	; 0x56
    1f80:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1f84:	00346863 	eorseq	r6, r4, r3, ror #16
    1f88:	5f6d7261 	svcpl	0x006d7261
    1f8c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1f90:	72610035 	rsbvc	r0, r1, #53	; 0x35
    1f94:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1f98:	00376863 	eorseq	r6, r7, r3, ror #16
    1f9c:	5f6d7261 	svcpl	0x006d7261
    1fa0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1fa4:	6f6c0038 	svcvs	0x006c0038
    1fa8:	6420676e 	strtvs	r6, [r0], #-1902	; 0xfffff892
    1fac:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    1fb0:	41420065 	cmpmi	r2, r5, rrx
    1fb4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1fb8:	5f484352 	svcpl	0x00484352
    1fbc:	54004b36 	strpl	r4, [r0], #-2870	; 0xfffff4ca
    1fc0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1fc4:	50435f54 	subpl	r5, r3, r4, asr pc
    1fc8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1fcc:	3034396d 	eorscc	r3, r4, sp, ror #18
    1fd0:	72610074 	rsbvc	r0, r1, #116	; 0x74
    1fd4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1fd8:	00366863 	eorseq	r6, r6, r3, ror #16
    1fdc:	5f6d7261 	svcpl	0x006d7261
    1fe0:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    1fe4:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    1fe8:	00656c61 	rsbeq	r6, r5, r1, ror #24
    1fec:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ff0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ff4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1ff8:	35376d72 	ldrcc	r6, [r7, #-3442]!	; 0xfffff28e
    1ffc:	6d003030 	stcvs	0, cr3, [r0, #-192]	; 0xffffff40
    2000:	6e696b61 	vnmulvs.f64	d22, d9, d17
    2004:	6f635f67 	svcvs	0x00635f67
    2008:	5f74736e 	svcpl	0x0074736e
    200c:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
    2010:	68740065 	ldmdavs	r4!, {r0, r2, r5, r6}^
    2014:	5f626d75 	svcpl	0x00626d75
    2018:	6c6c6163 	stfvse	f6, [ip], #-396	; 0xfffffe74
    201c:	6169765f 	cmnvs	r9, pc, asr r6
    2020:	62616c5f 	rsbvs	r6, r1, #24320	; 0x5f00
    2024:	69006c65 	stmdbvs	r0, {r0, r2, r5, r6, sl, fp, sp, lr}
    2028:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    202c:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    2030:	00357670 	eorseq	r7, r5, r0, ror r6
    2034:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2038:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    203c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2040:	31376d72 	teqcc	r7, r2, ror sp
    2044:	73690030 	cmnvc	r9, #48	; 0x30
    2048:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    204c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2050:	6b36766d 	blvs	d9fa0c <__bss_end+0xd95d14>
    2054:	52415400 	subpl	r5, r1, #0, 8
    2058:	5f544547 	svcpl	0x00544547
    205c:	5f555043 	svcpl	0x00555043
    2060:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2064:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2068:	52415400 	subpl	r5, r1, #0, 8
    206c:	5f544547 	svcpl	0x00544547
    2070:	5f555043 	svcpl	0x00555043
    2074:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2078:	38617865 	stmdacc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    207c:	52415400 	subpl	r5, r1, #0, 8
    2080:	5f544547 	svcpl	0x00544547
    2084:	5f555043 	svcpl	0x00555043
    2088:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    208c:	39617865 	stmdbcc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    2090:	4d524100 	ldfmie	f4, [r2, #-0]
    2094:	5343505f 	movtpl	r5, #12383	; 0x305f
    2098:	4350415f 	cmpmi	r0, #-1073741801	; 0xc0000017
    209c:	52410053 	subpl	r0, r1, #83	; 0x53
    20a0:	43505f4d 	cmpmi	r0, #308	; 0x134
    20a4:	54415f53 	strbpl	r5, [r1], #-3923	; 0xfffff0ad
    20a8:	00534350 	subseq	r4, r3, r0, asr r3
    20ac:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20b0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20b4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    20b8:	30366d72 	eorscc	r6, r6, r2, ror sp
    20bc:	41540030 	cmpmi	r4, r0, lsr r0
    20c0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    20c4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    20c8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    20cc:	74303237 	ldrtvc	r3, [r0], #-567	; 0xfffffdc9
    20d0:	52415400 	subpl	r5, r1, #0, 8
    20d4:	5f544547 	svcpl	0x00544547
    20d8:	5f555043 	svcpl	0x00555043
    20dc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    20e0:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    20e4:	6f630037 	svcvs	0x00630037
    20e8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    20ec:	6f642078 	svcvs	0x00642078
    20f0:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    20f4:	52415400 	subpl	r5, r1, #0, 8
    20f8:	5f544547 	svcpl	0x00544547
    20fc:	5f555043 	svcpl	0x00555043
    2100:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2104:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2108:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    210c:	61786574 	cmnvs	r8, r4, ror r5
    2110:	54003335 	strpl	r3, [r0], #-821	; 0xfffffccb
    2114:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2118:	50435f54 	subpl	r5, r3, r4, asr pc
    211c:	6f635f55 	svcvs	0x00635f55
    2120:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2124:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    2128:	61007375 	tstvs	r0, r5, ror r3
    212c:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    2130:	73690063 	cmnvc	r9, #99	; 0x63
    2134:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2138:	6f6d5f74 	svcvs	0x006d5f74
    213c:	36326564 	ldrtcc	r6, [r2], -r4, ror #10
    2140:	61736900 	cmnvs	r3, r0, lsl #18
    2144:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2148:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    214c:	00656c61 	rsbeq	r6, r5, r1, ror #24
    2150:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2154:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2158:	735f5550 	cmpvc	pc, #80, 10	; 0x14000000
    215c:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    2160:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    2164:	30303131 	eorscc	r3, r0, r1, lsr r1
    2168:	52415400 	subpl	r5, r1, #0, 8
    216c:	5f544547 	svcpl	0x00544547
    2170:	5f555043 	svcpl	0x00555043
    2174:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    2178:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    217c:	645f0073 	ldrbvs	r0, [pc], #-115	; 2184 <shift+0x2184>
    2180:	5f746e6f 	svcpl	0x00746e6f
    2184:	5f657375 	svcpl	0x00657375
    2188:	65657274 	strbvs	r7, [r5, #-628]!	; 0xfffffd8c
    218c:	7265685f 	rsbvc	r6, r5, #6225920	; 0x5f0000
    2190:	54005f65 	strpl	r5, [r0], #-3941	; 0xfffff09b
    2194:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2198:	50435f54 	subpl	r5, r3, r4, asr pc
    219c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    21a0:	7430316d 	ldrtvc	r3, [r0], #-365	; 0xfffffe93
    21a4:	00696d64 	rsbeq	r6, r9, r4, ror #26
    21a8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    21ac:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    21b0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    21b4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    21b8:	00356178 	eorseq	r6, r5, r8, ror r1
    21bc:	65736162 	ldrbvs	r6, [r3, #-354]!	; 0xfffffe9e
    21c0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    21c4:	65746968 	ldrbvs	r6, [r4, #-2408]!	; 0xfffff698
    21c8:	72757463 	rsbsvc	r7, r5, #1660944384	; 0x63000000
    21cc:	72610065 	rsbvc	r0, r1, #101	; 0x65
    21d0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    21d4:	635f6863 	cmpvs	pc, #6488064	; 0x630000
    21d8:	54006372 	strpl	r6, [r0], #-882	; 0xfffffc8e
    21dc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21e0:	50435f54 	subpl	r5, r3, r4, asr pc
    21e4:	6f635f55 	svcvs	0x00635f55
    21e8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    21ec:	6d73316d 	ldfvse	f3, [r3, #-436]!	; 0xfffffe4c
    21f0:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    21f4:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    21f8:	00796c70 	rsbseq	r6, r9, r0, ror ip
    21fc:	5f6d7261 	svcpl	0x006d7261
    2200:	72727563 	rsbsvc	r7, r2, #415236096	; 0x18c00000
    2204:	5f746e65 	svcpl	0x00746e65
    2208:	61006363 	tstvs	r0, r3, ror #6
    220c:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 2214 <shift+0x2214>
    2210:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    2214:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
    2218:	69006e73 	stmdbvs	r0, {r0, r1, r4, r5, r6, r9, sl, fp, sp, lr}
    221c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2220:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    2224:	32336372 	eorscc	r6, r3, #-939524095	; 0xc8000001
    2228:	4d524100 	ldfmie	f4, [r2, #-0]
    222c:	004c505f 	subeq	r5, ip, pc, asr r0
    2230:	5f617369 	svcpl	0x00617369
    2234:	5f746962 	svcpl	0x00746962
    2238:	76706676 			; <UNDEFINED> instruction: 0x76706676
    223c:	73690033 	cmnvc	r9, #51	; 0x33
    2240:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2244:	66765f74 	uhsub16vs	r5, r6, r4
    2248:	00347670 	eorseq	r7, r4, r0, ror r6
    224c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2250:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2254:	54365f48 	ldrtpl	r5, [r6], #-3912	; 0xfffff0b8
    2258:	41420032 	cmpmi	r2, r2, lsr r0
    225c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2260:	5f484352 	svcpl	0x00484352
    2264:	4d5f4d38 	ldclmi	13, cr4, [pc, #-224]	; 218c <shift+0x218c>
    2268:	004e4941 	subeq	r4, lr, r1, asr #18
    226c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2270:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2274:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2278:	74396d72 	ldrtvc	r6, [r9], #-3442	; 0xfffff28e
    227c:	00696d64 	rsbeq	r6, r9, r4, ror #26
    2280:	5f4d5241 	svcpl	0x004d5241
    2284:	69004c41 	stmdbvs	r0, {r0, r6, sl, fp, lr}
    2288:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    228c:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 20f0 <shift+0x20f0>
    2290:	3365646f 	cmncc	r5, #1862270976	; 0x6f000000
    2294:	41420032 	cmpmi	r2, r2, lsr r0
    2298:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    229c:	5f484352 	svcpl	0x00484352
    22a0:	61004d37 	tstvs	r0, r7, lsr sp
    22a4:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 22ac <shift+0x22ac>
    22a8:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    22ac:	616c5f74 	smcvs	50676	; 0xc5f4
    22b0:	006c6562 	rsbeq	r6, ip, r2, ror #10
    22b4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    22b8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    22bc:	735f5550 	cmpvc	pc, #80, 10	; 0x14000000
    22c0:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    22c4:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    22c8:	30313131 	eorscc	r3, r1, r1, lsr r1
    22cc:	52415400 	subpl	r5, r1, #0, 8
    22d0:	5f544547 	svcpl	0x00544547
    22d4:	5f555043 	svcpl	0x00555043
    22d8:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    22dc:	54003032 	strpl	r3, [r0], #-50	; 0xffffffce
    22e0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    22e4:	50435f54 	subpl	r5, r3, r4, asr pc
    22e8:	6f635f55 	svcvs	0x00635f55
    22ec:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    22f0:	54003472 	strpl	r3, [r0], #-1138	; 0xfffffb8e
    22f4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    22f8:	50435f54 	subpl	r5, r3, r4, asr pc
    22fc:	6f635f55 	svcvs	0x00635f55
    2300:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2304:	54003572 	strpl	r3, [r0], #-1394	; 0xfffffa8e
    2308:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    230c:	50435f54 	subpl	r5, r3, r4, asr pc
    2310:	6f635f55 	svcvs	0x00635f55
    2314:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2318:	54003772 	strpl	r3, [r0], #-1906	; 0xfffff88e
    231c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2320:	50435f54 	subpl	r5, r3, r4, asr pc
    2324:	6f635f55 	svcvs	0x00635f55
    2328:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    232c:	69003872 	stmdbvs	r0, {r1, r4, r5, r6, fp, ip, sp}
    2330:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2334:	6c5f7469 	cfldrdvs	mvd7, [pc], {105}	; 0x69
    2338:	00656170 	rsbeq	r6, r5, r0, ror r1
    233c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2340:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2344:	735f5550 	cmpvc	pc, #80, 10	; 0x14000000
    2348:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    234c:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    2350:	00303131 	eorseq	r3, r0, r1, lsr r1
    2354:	5f617369 	svcpl	0x00617369
    2358:	5f746962 	svcpl	0x00746962
    235c:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    2360:	72615f6b 	rsbvc	r5, r1, #428	; 0x1ac
    2364:	6b36766d 	blvs	d9fd20 <__bss_end+0xd96028>
    2368:	7369007a 	cmnvc	r9, #122	; 0x7a
    236c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2370:	6f6e5f74 	svcvs	0x006e5f74
    2374:	69006d74 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, fp, sp, lr}
    2378:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    237c:	615f7469 	cmpvs	pc, r9, ror #8
    2380:	34766d72 	ldrbtcc	r6, [r6], #-3442	; 0xfffff28e
    2384:	61736900 	cmnvs	r3, r0, lsl #18
    2388:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    238c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2390:	69003576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, ip, sp}
    2394:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2398:	615f7469 	cmpvs	pc, r9, ror #8
    239c:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    23a0:	61736900 	cmnvs	r3, r0, lsl #18
    23a4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    23a8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    23ac:	69003776 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, sl, ip, sp}
    23b0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    23b4:	615f7469 	cmpvs	pc, r9, ror #8
    23b8:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    23bc:	6f645f00 	svcvs	0x00645f00
    23c0:	755f746e 	ldrbvc	r7, [pc, #-1134]	; 1f5a <shift+0x1f5a>
    23c4:	725f6573 	subsvc	r6, pc, #482344960	; 0x1cc00000
    23c8:	685f7874 	ldmdavs	pc, {r2, r4, r5, r6, fp, ip, sp, lr}^	; <UNPREDICTABLE>
    23cc:	5f657265 	svcpl	0x00657265
    23d0:	49515500 	ldmdbmi	r1, {r8, sl, ip, lr}^
    23d4:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    23d8:	6d726100 	ldfvse	f6, [r2, #-0]
    23dc:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    23e0:	72610065 	rsbvc	r0, r1, #101	; 0x65
    23e4:	70635f6d 	rsbvc	r5, r3, sp, ror #30
    23e8:	6e695f70 	mcrvs	15, 3, r5, cr9, cr0, {3}
    23ec:	77726574 			; <UNDEFINED> instruction: 0x77726574
    23f0:	006b726f 	rsbeq	r7, fp, pc, ror #4
    23f4:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    23f8:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
    23fc:	52415400 	subpl	r5, r1, #0, 8
    2400:	5f544547 	svcpl	0x00544547
    2404:	5f555043 	svcpl	0x00555043
    2408:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    240c:	00743032 	rsbseq	r3, r4, r2, lsr r0
    2410:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    2414:	0071655f 	rsbseq	r6, r1, pc, asr r5
    2418:	47524154 			; <UNDEFINED> instruction: 0x47524154
    241c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2420:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    2424:	36323561 	ldrtcc	r3, [r2], -r1, ror #10
    2428:	6d726100 	ldfvse	f6, [r2, #-0]
    242c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2430:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    2434:	5f626d75 	svcpl	0x00626d75
    2438:	69647768 	stmdbvs	r4!, {r3, r5, r6, r8, r9, sl, ip, sp, lr}^
    243c:	74680076 	strbtvc	r0, [r8], #-118	; 0xffffff8a
    2440:	655f6261 	ldrbvs	r6, [pc, #-609]	; 21e7 <shift+0x21e7>
    2444:	6f705f71 	svcvs	0x00705f71
    2448:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    244c:	41540072 	cmpmi	r4, r2, ror r0
    2450:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2454:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2458:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    245c:	47003036 	smladxmi	r0, r6, r0, r3
    2460:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    2464:	38203731 	stmdacc	r0!, {r0, r4, r5, r8, r9, sl, ip, sp}
    2468:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
    246c:	31303220 	teqcc	r0, r0, lsr #4
    2470:	30373039 	eorscc	r3, r7, r9, lsr r0
    2474:	72282033 	eorvc	r2, r8, #51	; 0x33
    2478:	61656c65 	cmnvs	r5, r5, ror #24
    247c:	20296573 	eorcs	r6, r9, r3, ror r5
    2480:	6363675b 	cmnvs	r3, #23855104	; 0x16c0000
    2484:	622d382d 	eorvs	r3, sp, #2949120	; 0x2d0000
    2488:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
    248c:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
    2490:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    2494:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
    2498:	32303337 	eorscc	r3, r0, #-603979776	; 0xdc000000
    249c:	2d205d37 	stccs	13, cr5, [r0, #-220]!	; 0xffffff24
    24a0:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    24a4:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    24a8:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    24ac:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    24b0:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    24b4:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    24b8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    24bc:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    24c0:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    24c4:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    24c8:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    24cc:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    24d0:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    24d4:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    24d8:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    24dc:	62662d20 	rsbvs	r2, r6, #32, 26	; 0x800
    24e0:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    24e4:	2d676e69 	stclcs	14, cr6, [r7, #-420]!	; 0xfffffe5c
    24e8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    24ec:	2d206363 	stccs	3, cr6, [r0, #-396]!	; 0xfffffe74
    24f0:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 2360 <shift+0x2360>
    24f4:	63617473 	cmnvs	r1, #1929379840	; 0x73000000
    24f8:	72702d6b 	rsbsvc	r2, r0, #6848	; 0x1ac0
    24fc:	6365746f 	cmnvs	r5, #1862270976	; 0x6f000000
    2500:	20726f74 	rsbscs	r6, r2, r4, ror pc
    2504:	6f6e662d 	svcvs	0x006e662d
    2508:	6c6e692d 			; <UNDEFINED> instruction: 0x6c6e692d
    250c:	20656e69 	rsbcs	r6, r5, r9, ror #28
    2510:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
    2514:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    2518:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
    251c:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
    2520:	006e6564 	rsbeq	r6, lr, r4, ror #10
    2524:	5f6d7261 	svcpl	0x006d7261
    2528:	5f636970 	svcpl	0x00636970
    252c:	69676572 	stmdbvs	r7!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    2530:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
    2534:	52415400 	subpl	r5, r1, #0, 8
    2538:	5f544547 	svcpl	0x00544547
    253c:	5f555043 	svcpl	0x00555043
    2540:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2544:	306d7865 	rsbcc	r7, sp, r5, ror #16
    2548:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    254c:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    2550:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    2554:	41540079 	cmpmi	r4, r9, ror r0
    2558:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    255c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2560:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2564:	65363639 	ldrvs	r3, [r6, #-1593]!	; 0xfffff9c7
    2568:	41540073 	cmpmi	r4, r3, ror r0
    256c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2570:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2574:	63706d5f 	cmnvs	r0, #6080	; 0x17c0
    2578:	6e65726f 	cdpvs	2, 6, cr7, cr5, cr15, {3}
    257c:	7066766f 	rsbvc	r7, r6, pc, ror #12
    2580:	61736900 	cmnvs	r3, r0, lsl #18
    2584:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2588:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    258c:	635f6b72 	cmpvs	pc, #116736	; 0x1c800
    2590:	6c5f336d 	mrrcvs	3, 6, r3, pc, cr13	; <UNPREDICTABLE>
    2594:	00647264 	rsbeq	r7, r4, r4, ror #4
    2598:	47524154 			; <UNDEFINED> instruction: 0x47524154
    259c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    25a0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    25a4:	30376d72 	eorscc	r6, r7, r2, ror sp
    25a8:	41006930 	tstmi	r0, r0, lsr r9
    25ac:	435f4d52 	cmpmi	pc, #5248	; 0x1480
    25b0:	72610043 	rsbvc	r0, r1, #67	; 0x43
    25b4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    25b8:	5f386863 	svcpl	0x00386863
    25bc:	41540032 	cmpmi	r4, r2, lsr r0
    25c0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25c4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    25c8:	706d665f 	rsbvc	r6, sp, pc, asr r6
    25cc:	00363236 	eorseq	r3, r6, r6, lsr r2
    25d0:	5f4d5241 	svcpl	0x004d5241
    25d4:	61005343 	tstvs	r0, r3, asr #6
    25d8:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    25dc:	5f363170 	svcpl	0x00363170
    25e0:	74736e69 	ldrbtvc	r6, [r3], #-3689	; 0xfffff197
    25e4:	6d726100 	ldfvse	f6, [r2, #-0]
    25e8:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
    25ec:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    25f0:	54006863 	strpl	r6, [r0], #-2147	; 0xfffff79d
    25f4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    25f8:	50435f54 	subpl	r5, r3, r4, asr pc
    25fc:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2600:	006d376d 	rsbeq	r3, sp, sp, ror #14
    2604:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2608:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    260c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2610:	30376d72 	eorscc	r6, r7, r2, ror sp
    2614:	52415400 	subpl	r5, r1, #0, 8
    2618:	5f544547 	svcpl	0x00544547
    261c:	5f555043 	svcpl	0x00555043
    2620:	326d7261 	rsbcc	r7, sp, #268435462	; 0x10000006
    2624:	61003035 	tstvs	r0, r5, lsr r0
    2628:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    262c:	37686372 			; <UNDEFINED> instruction: 0x37686372
    2630:	54006d65 	strpl	r6, [r0], #-3429	; 0xfffff29b
    2634:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2638:	50435f54 	subpl	r5, r3, r4, asr pc
    263c:	6f635f55 	svcvs	0x00635f55
    2640:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2644:	00323761 	eorseq	r3, r2, r1, ror #14
    2648:	5f6d7261 	svcpl	0x006d7261
    264c:	5f736370 	svcpl	0x00736370
    2650:	61666564 	cmnvs	r6, r4, ror #10
    2654:	00746c75 	rsbseq	r6, r4, r5, ror ip
    2658:	5f4d5241 	svcpl	0x004d5241
    265c:	5f534350 	svcpl	0x00534350
    2660:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    2664:	4f4c5f53 	svcmi	0x004c5f53
    2668:	004c4143 	subeq	r4, ip, r3, asr #2
    266c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2670:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2674:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2678:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    267c:	35376178 	ldrcc	r6, [r7, #-376]!	; 0xfffffe88
    2680:	52415400 	subpl	r5, r1, #0, 8
    2684:	5f544547 	svcpl	0x00544547
    2688:	5f555043 	svcpl	0x00555043
    268c:	6f727473 	svcvs	0x00727473
    2690:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    2694:	7261006d 	rsbvc	r0, r1, #109	; 0x6d
    2698:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    269c:	745f6863 	ldrbvc	r6, [pc], #-2147	; 26a4 <shift+0x26a4>
    26a0:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    26a4:	72610031 	rsbvc	r0, r1, #49	; 0x31
    26a8:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    26ac:	745f6863 	ldrbvc	r6, [pc], #-2147	; 26b4 <shift+0x26b4>
    26b0:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    26b4:	41540032 	cmpmi	r4, r2, lsr r0
    26b8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    26bc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    26c0:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    26c4:	0074786d 	rsbseq	r7, r4, sp, ror #16
    26c8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    26cc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    26d0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    26d4:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    26d8:	54007432 	strpl	r7, [r0], #-1074	; 0xfffffbce
    26dc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    26e0:	50435f54 	subpl	r5, r3, r4, asr pc
    26e4:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    26e8:	0064376d 	rsbeq	r3, r4, sp, ror #14
    26ec:	5f617369 	svcpl	0x00617369
    26f0:	5f746962 	svcpl	0x00746962
    26f4:	6100706d 	tstvs	r0, sp, rrx
    26f8:	6c5f6d72 	mrrcvs	13, 7, r6, pc, cr2	; <UNPREDICTABLE>
    26fc:	63735f64 	cmnvs	r3, #100, 30	; 0x190
    2700:	00646568 	rsbeq	r6, r4, r8, ror #10
    2704:	5f6d7261 	svcpl	0x006d7261
    2708:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    270c:	00315f38 	eorseq	r5, r1, r8, lsr pc
    2710:	69665f5f 	stmdbvs	r6!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
    2714:	736e7578 	cmnvc	lr, #120, 10	; 0x1e000000
    2718:	69646673 	stmdbvs	r4!, {r0, r1, r4, r5, r6, r9, sl, sp, lr}^
    271c:	615f5f00 	cmpvs	pc, r0, lsl #30
    2720:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    2724:	7532665f 	ldrvc	r6, [r2, #-1631]!	; 0xfffff9a1
    2728:	53007a6c 	movwpl	r7, #2668	; 0xa6c
    272c:	70797446 	rsbsvc	r7, r9, r6, asr #8
    2730:	5f5f0065 	svcpl	0x005f0065
    2734:	73786966 	cmnvc	r8, #1671168	; 0x198000
    2738:	00696466 	rsbeq	r6, r9, r6, ror #8
    273c:	74494455 	strbvc	r4, [r9], #-1109	; 0xfffffbab
    2740:	00657079 	rsbeq	r7, r5, r9, ror r0
    2744:	74495355 	strbvc	r5, [r9], #-853	; 0xfffffcab
    2748:	00657079 	rsbeq	r7, r5, r9, ror r0
    274c:	79744644 	ldmdbvc	r4!, {r2, r6, r9, sl, lr}^
    2750:	5f006570 	svcpl	0x00006570
    2754:	6964755f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sl, ip, sp, lr}^
    2758:	646f6d76 	strbtvs	r6, [pc], #-3446	; 2760 <shift+0x2760>
    275c:	00346964 	eorseq	r6, r4, r4, ror #18
    2760:	20554e47 	subscs	r4, r5, r7, asr #28
    2764:	20373143 	eorscs	r3, r7, r3, asr #2
    2768:	2e332e38 	mrccs	14, 1, r2, cr3, cr8, {1}
    276c:	30322031 	eorscc	r2, r2, r1, lsr r0
    2770:	37303931 			; <UNDEFINED> instruction: 0x37303931
    2774:	28203330 	stmdacs	r0!, {r4, r5, r8, r9, ip, sp}
    2778:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    277c:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    2780:	63675b20 	cmnvs	r7, #32, 22	; 0x8000
    2784:	2d382d63 	ldccs	13, cr2, [r8, #-396]!	; 0xfffffe74
    2788:	6e617262 	cdpvs	2, 6, cr7, cr1, cr2, {3}
    278c:	72206863 	eorvc	r6, r0, #6488064	; 0x630000
    2790:	73697665 	cmnvc	r9, #105906176	; 0x6500000
    2794:	206e6f69 	rsbcs	r6, lr, r9, ror #30
    2798:	30333732 	eorscc	r3, r3, r2, lsr r7
    279c:	205d3732 	subscs	r3, sp, r2, lsr r7
    27a0:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    27a4:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
    27a8:	616f6c66 	cmnvs	pc, r6, ror #24
    27ac:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    27b0:	61683d69 	cmnvs	r8, r9, ror #26
    27b4:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    27b8:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
    27bc:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
    27c0:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    27c4:	70662b65 	rsbvc	r2, r6, r5, ror #22
    27c8:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    27cc:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    27d0:	4f2d2067 	svcmi	0x002d2067
    27d4:	4f2d2032 	svcmi	0x002d2032
    27d8:	4f2d2032 	svcmi	0x002d2032
    27dc:	662d2032 			; <UNDEFINED> instruction: 0x662d2032
    27e0:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    27e4:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
    27e8:	62696c2d 	rsbvs	r6, r9, #11520	; 0x2d00
    27ec:	20636367 	rsbcs	r6, r3, r7, ror #6
    27f0:	6f6e662d 	svcvs	0x006e662d
    27f4:	6174732d 	cmnvs	r4, sp, lsr #6
    27f8:	702d6b63 	eorvc	r6, sp, r3, ror #22
    27fc:	65746f72 	ldrbvs	r6, [r4, #-3954]!	; 0xfffff08e
    2800:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    2804:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    2808:	6e692d6f 	cdpvs	13, 6, cr2, cr9, cr15, {3}
    280c:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    2810:	65662d20 	strbvs	r2, [r6, #-3360]!	; 0xfffff2e0
    2814:	70656378 	rsbvc	r6, r5, r8, ror r3
    2818:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    281c:	662d2073 			; <UNDEFINED> instruction: 0x662d2073
    2820:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    2824:	696c6962 	stmdbvs	ip!, {r1, r5, r6, r8, fp, sp, lr}^
    2828:	683d7974 	ldmdavs	sp!, {r2, r4, r5, r6, r8, fp, ip, sp, lr}
    282c:	65646469 	strbvs	r6, [r4, #-1129]!	; 0xfffffb97
    2830:	Address 0x0000000000002830 is out of bounds.


Disassembly of section .debug_frame:

00000000 <.debug_frame>:
   0:	0000000c 	andeq	r0, r0, ip
   4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
   8:	7c020001 	stcvc	0, cr0, [r2], {1}
   c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  10:	0000001c 	andeq	r0, r0, ip, lsl r0
  14:	00000000 	andeq	r0, r0, r0
  18:	00008008 	andeq	r8, r0, r8
  1c:	00000058 	andeq	r0, r0, r8, asr r0
  20:	8b040e42 	blhi	103930 <__bss_end+0xf9c38>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x346b38>
  28:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008060 	andeq	r8, r0, r0, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f9c58>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf8f88>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a0 	andeq	r8, r0, r0, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf9c88>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x346b88>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf9ca8>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x346ba8>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008104 	andeq	r8, r0, r4, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf9cc8>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x346bc8>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008124 	andeq	r8, r0, r4, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf9ce8>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x346be8>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	0000813c 	andeq	r8, r0, ip, lsr r1
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf9d08>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x346c08>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008154 	andeq	r8, r0, r4, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf9d28>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x346c28>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	0000816c 	andeq	r8, r0, ip, ror #2
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf9d48>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x346c48>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	00008178 	andeq	r8, r0, r8, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f9d60>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d0 	ldrdeq	r8, [r0], -r0
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f9d80>
 16c:	42018e02 	andmi	r8, r1, #2, 28
 170:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 174:	00080d0c 	andeq	r0, r8, ip, lsl #26
 178:	0000000c 	andeq	r0, r0, ip
 17c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 180:	7c020001 	stcvc	0, cr0, [r2], {1}
 184:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 188:	00000018 	andeq	r0, r0, r8, lsl r0
 18c:	00000178 	andeq	r0, r0, r8, ror r1
 190:	00008228 	andeq	r8, r0, r8, lsr #4
 194:	00000048 	andeq	r0, r0, r8, asr #32
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1f9db0>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	00008270 	andeq	r8, r0, r0, ror r2
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xf9ddc>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x346cdc>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	0000829c 	muleq	r0, ip, r2
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xf9dfc>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x346cfc>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	000082c8 	andeq	r8, r0, r8, asr #5
 200:	0000002c 	andeq	r0, r0, ip, lsr #32
 204:	8b040e42 	blhi	103b14 <__bss_end+0xf9e1c>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x346d1c>
 20c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	000082f4 	strdeq	r8, [r0], -r4
 220:	0000001c 	andeq	r0, r0, ip, lsl r0
 224:	8b040e42 	blhi	103b34 <__bss_end+0xf9e3c>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x346d3c>
 22c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	00008310 	andeq	r8, r0, r0, lsl r3
 240:	00000044 	andeq	r0, r0, r4, asr #32
 244:	8b040e42 	blhi	103b54 <__bss_end+0xf9e5c>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x346d5c>
 24c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	00008354 	andeq	r8, r0, r4, asr r3
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xf9e7c>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x346d7c>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	000083a4 	andeq	r8, r0, r4, lsr #7
 280:	00000050 	andeq	r0, r0, r0, asr r0
 284:	8b040e42 	blhi	103b94 <__bss_end+0xf9e9c>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x346d9c>
 28c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	000083f4 	strdeq	r8, [r0], -r4
 2a0:	0000002c 	andeq	r0, r0, ip, lsr #32
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xf9ebc>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x346dbc>
 2ac:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	00008420 	andeq	r8, r0, r0, lsr #8
 2c0:	00000050 	andeq	r0, r0, r0, asr r0
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xf9edc>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x346ddc>
 2cc:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	00008470 	andeq	r8, r0, r0, ror r4
 2e0:	00000044 	andeq	r0, r0, r4, asr #32
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xf9efc>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x346dfc>
 2ec:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	000084b4 			; <UNDEFINED> instruction: 0x000084b4
 300:	00000050 	andeq	r0, r0, r0, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xf9f1c>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x346e1c>
 30c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	00008504 	andeq	r8, r0, r4, lsl #10
 320:	00000054 	andeq	r0, r0, r4, asr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xf9f3c>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x346e3c>
 32c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	00008558 	andeq	r8, r0, r8, asr r5
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xf9f5c>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x346e5c>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	00008594 	muleq	r0, r4, r5
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xf9f7c>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x346e7c>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	000085d0 	ldrdeq	r8, [r0], -r0
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xf9f9c>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x346e9c>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	0000860c 	andeq	r8, r0, ip, lsl #12
 3a0:	0000003c 	andeq	r0, r0, ip, lsr r0
 3a4:	8b040e42 	blhi	103cb4 <__bss_end+0xf9fbc>
 3a8:	0b0d4201 	bleq	350bb4 <__bss_end+0x346ebc>
 3ac:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 3b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 3b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 3bc:	00008648 	andeq	r8, r0, r8, asr #12
 3c0:	000000b4 	strheq	r0, [r0], -r4
 3c4:	8b080e42 	blhi	203cd4 <__bss_end+0x1f9fdc>
 3c8:	42018e02 	andmi	r8, r1, #2, 28
 3cc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3d0:	080d0c52 	stmdaeq	sp, {r1, r4, r6, sl, fp}
 3d4:	0000000c 	andeq	r0, r0, ip
 3d8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3dc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3e0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003d4 	ldrdeq	r0, [r0], -r4
 3ec:	00008700 	andeq	r8, r0, r0, lsl #14
 3f0:	00000068 	andeq	r0, r0, r8, rrx
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfa00c>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x346f0c>
 3fc:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 400:	00000ecb 	andeq	r0, r0, fp, asr #29
 404:	0000002c 	andeq	r0, r0, ip, lsr #32
 408:	000003d4 	ldrdeq	r0, [r0], -r4
 40c:	00008768 	andeq	r8, r0, r8, ror #14
 410:	00000320 	andeq	r0, r0, r0, lsr #6
 414:	84200e42 	strthi	r0, [r0], #-3650	; 0xfffff1be
 418:	86078508 	strhi	r8, [r7], -r8, lsl #10
 41c:	88058706 	stmdahi	r5, {r1, r2, r8, r9, sl, pc}
 420:	8b038904 	blhi	e2838 <__bss_end+0xd8b40>
 424:	42018e02 	andmi	r8, r1, #2, 28
 428:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 42c:	0d0c0186 	stfeqs	f0, [ip, #-536]	; 0xfffffde8
 430:	00000020 	andeq	r0, r0, r0, lsr #32
 434:	00000020 	andeq	r0, r0, r0, lsr #32
 438:	000003d4 	ldrdeq	r0, [r0], -r4
 43c:	00008a88 	andeq	r8, r0, r8, lsl #21
 440:	000002b4 			; <UNDEFINED> instruction: 0x000002b4
 444:	8b040e42 	blhi	103d54 <__bss_end+0xfa05c>
 448:	0b0d4201 	bleq	350c54 <__bss_end+0x346f5c>
 44c:	0d014803 	stceq	8, cr4, [r1, #-12]
 450:	0ecb420d 	cdpeq	2, 12, cr4, cr11, cr13, {0}
 454:	00000000 	andeq	r0, r0, r0
 458:	0000001c 	andeq	r0, r0, ip, lsl r0
 45c:	000003d4 	ldrdeq	r0, [r0], -r4
 460:	00008d3c 	andeq	r8, r0, ip, lsr sp
 464:	00000174 	andeq	r0, r0, r4, ror r1
 468:	8b080e42 	blhi	203d78 <__bss_end+0x1fa080>
 46c:	42018e02 	andmi	r8, r1, #2, 28
 470:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 474:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 478:	0000001c 	andeq	r0, r0, ip, lsl r0
 47c:	000003d4 	ldrdeq	r0, [r0], -r4
 480:	00008eb0 			; <UNDEFINED> instruction: 0x00008eb0
 484:	0000009c 	muleq	r0, ip, r0
 488:	8b040e42 	blhi	103d98 <__bss_end+0xfa0a0>
 48c:	0b0d4201 	bleq	350c98 <__bss_end+0x346fa0>
 490:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 494:	000ecb42 	andeq	ip, lr, r2, asr #22
 498:	0000001c 	andeq	r0, r0, ip, lsl r0
 49c:	000003d4 	ldrdeq	r0, [r0], -r4
 4a0:	00008f4c 	andeq	r8, r0, ip, asr #30
 4a4:	000000c0 	andeq	r0, r0, r0, asr #1
 4a8:	8b040e42 	blhi	103db8 <__bss_end+0xfa0c0>
 4ac:	0b0d4201 	bleq	350cb8 <__bss_end+0x346fc0>
 4b0:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 4b4:	000ecb42 	andeq	ip, lr, r2, asr #22
 4b8:	0000001c 	andeq	r0, r0, ip, lsl r0
 4bc:	000003d4 	ldrdeq	r0, [r0], -r4
 4c0:	0000900c 	andeq	r9, r0, ip
 4c4:	000000ac 	andeq	r0, r0, ip, lsr #1
 4c8:	8b040e42 	blhi	103dd8 <__bss_end+0xfa0e0>
 4cc:	0b0d4201 	bleq	350cd8 <__bss_end+0x346fe0>
 4d0:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 4d4:	000ecb42 	andeq	ip, lr, r2, asr #22
 4d8:	0000001c 	andeq	r0, r0, ip, lsl r0
 4dc:	000003d4 	ldrdeq	r0, [r0], -r4
 4e0:	000090b8 	strheq	r9, [r0], -r8
 4e4:	00000054 	andeq	r0, r0, r4, asr r0
 4e8:	8b040e42 	blhi	103df8 <__bss_end+0xfa100>
 4ec:	0b0d4201 	bleq	350cf8 <__bss_end+0x347000>
 4f0:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 4f4:	00000ecb 	andeq	r0, r0, fp, asr #29
 4f8:	0000001c 	andeq	r0, r0, ip, lsl r0
 4fc:	000003d4 	ldrdeq	r0, [r0], -r4
 500:	0000910c 	andeq	r9, r0, ip, lsl #2
 504:	00000080 	andeq	r0, r0, r0, lsl #1
 508:	8b040e42 	blhi	103e18 <__bss_end+0xfa120>
 50c:	0b0d4201 	bleq	350d18 <__bss_end+0x347020>
 510:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 514:	00000ecb 	andeq	r0, r0, fp, asr #29
 518:	0000001c 	andeq	r0, r0, ip, lsl r0
 51c:	000003d4 	ldrdeq	r0, [r0], -r4
 520:	0000918c 	andeq	r9, r0, ip, lsl #3
 524:	00000068 	andeq	r0, r0, r8, rrx
 528:	8b040e42 	blhi	103e38 <__bss_end+0xfa140>
 52c:	0b0d4201 	bleq	350d38 <__bss_end+0x347040>
 530:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 534:	00000ecb 	andeq	r0, r0, fp, asr #29
 538:	0000001c 	andeq	r0, r0, ip, lsl r0
 53c:	000003d4 	ldrdeq	r0, [r0], -r4
 540:	000091f4 	strdeq	r9, [r0], -r4
 544:	00000080 	andeq	r0, r0, r0, lsl #1
 548:	8b040e42 	blhi	103e58 <__bss_end+0xfa160>
 54c:	0b0d4201 	bleq	350d58 <__bss_end+0x347060>
 550:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 554:	00000ecb 	andeq	r0, r0, fp, asr #29
 558:	0000001c 	andeq	r0, r0, ip, lsl r0
 55c:	000003d4 	ldrdeq	r0, [r0], -r4
 560:	00009274 	andeq	r9, r0, r4, ror r2
 564:	00000048 	andeq	r0, r0, r8, asr #32
 568:	8b040e42 	blhi	103e78 <__bss_end+0xfa180>
 56c:	0b0d4201 	bleq	350d78 <__bss_end+0x347080>
 570:	420d0d5c 	andmi	r0, sp, #92, 26	; 0x1700
 574:	00000ecb 	andeq	r0, r0, fp, asr #29
 578:	0000001c 	andeq	r0, r0, ip, lsl r0
 57c:	000003d4 	ldrdeq	r0, [r0], -r4
 580:	000092bc 			; <UNDEFINED> instruction: 0x000092bc
 584:	00000118 	andeq	r0, r0, r8, lsl r1
 588:	8b080e42 	blhi	203e98 <__bss_end+0x1fa1a0>
 58c:	42018e02 	andmi	r8, r1, #2, 28
 590:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 594:	080d0c86 	stmdaeq	sp, {r1, r2, r7, sl, fp}
 598:	0000001c 	andeq	r0, r0, ip, lsl r0
 59c:	000003d4 	ldrdeq	r0, [r0], -r4
 5a0:	000093d4 	ldrdeq	r9, [r0], -r4
 5a4:	000001c8 	andeq	r0, r0, r8, asr #3
 5a8:	8b080e42 	blhi	203eb8 <__bss_end+0x1fa1c0>
 5ac:	42018e02 	andmi	r8, r1, #2, 28
 5b0:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 5b4:	080d0cde 	stmdaeq	sp, {r1, r2, r3, r4, r6, r7, sl, fp}
 5b8:	0000000c 	andeq	r0, r0, ip
 5bc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5c0:	7c010001 	stcvc	0, cr0, [r1], {1}
 5c4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5c8:	0000000c 	andeq	r0, r0, ip
 5cc:	000005b8 			; <UNDEFINED> instruction: 0x000005b8
 5d0:	0000959c 	muleq	r0, ip, r5
 5d4:	000001ec 	andeq	r0, r0, ip, ror #3
 5d8:	0000000c 	andeq	r0, r0, ip
 5dc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5e0:	7c020001 	stcvc	0, cr0, [r2], {1}
 5e4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5e8:	00000010 	andeq	r0, r0, r0, lsl r0
 5ec:	000005d8 	ldrdeq	r0, [r0], -r8
 5f0:	000097ac 	andeq	r9, r0, ip, lsr #15
 5f4:	0000019c 	muleq	r0, ip, r1
 5f8:	0bce020a 	bleq	ff380e28 <__bss_end+0xff377130>
 5fc:	00000010 	andeq	r0, r0, r0, lsl r0
 600:	000005d8 	ldrdeq	r0, [r0], -r8
 604:	00009948 	andeq	r9, r0, r8, asr #18
 608:	00000028 	andeq	r0, r0, r8, lsr #32
 60c:	000b540a 	andeq	r5, fp, sl, lsl #8
 610:	00000010 	andeq	r0, r0, r0, lsl r0
 614:	000005d8 	ldrdeq	r0, [r0], -r8
 618:	00009970 	andeq	r9, r0, r0, ror r9
 61c:	0000008c 	andeq	r0, r0, ip, lsl #1
 620:	0b46020a 	bleq	1180e50 <__bss_end+0x1177158>
 624:	0000000c 	andeq	r0, r0, ip
 628:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 62c:	7c020001 	stcvc	0, cr0, [r2], {1}
 630:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 634:	00000030 	andeq	r0, r0, r0, lsr r0
 638:	00000624 	andeq	r0, r0, r4, lsr #12
 63c:	000099fc 	strdeq	r9, [r0], -ip
 640:	000000d4 	ldrdeq	r0, [r0], -r4
 644:	8e100e5a 	mrchi	14, 0, r0, cr0, cr10, {2}
 648:	460a4a03 	strmi	r4, [sl], -r3, lsl #20
 64c:	42100ece 	andsmi	r0, r0, #3296	; 0xce0
 650:	460a4a0b 	strmi	r4, [sl], -fp, lsl #20
 654:	4a100ece 	bmi	404194 <__bss_end+0x3fa49c>
 658:	460a460b 	strmi	r4, [sl], -fp, lsl #12
 65c:	46100ece 	ldrmi	r0, [r0], -lr, asr #29
 660:	0ece4c0b 	cdpeq	12, 12, cr4, cr14, cr11, {0}
 664:	00000010 	andeq	r0, r0, r0, lsl r0
 668:	0000000c 	andeq	r0, r0, ip
 66c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 670:	7c020001 	stcvc	0, cr0, [r2], {1}
 674:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 678:	00000014 	andeq	r0, r0, r4, lsl r0
 67c:	00000668 	andeq	r0, r0, r8, ror #12
 680:	00009ad0 	ldrdeq	r9, [r0], -r0
 684:	0000002c 	andeq	r0, r0, ip, lsr #32
 688:	84080e4c 	strhi	r0, [r8], #-3660	; 0xfffff1b4
 68c:	00018e02 	andeq	r8, r1, r2, lsl #28
 690:	0000000c 	andeq	r0, r0, ip
 694:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 698:	7c020001 	stcvc	0, cr0, [r2], {1}
 69c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 6a0:	0000000c 	andeq	r0, r0, ip
 6a4:	00000690 	muleq	r0, r0, r6
 6a8:	00009b00 	andeq	r9, r0, r0, lsl #22
 6ac:	00000040 	andeq	r0, r0, r0, asr #32
 6b0:	0000000c 	andeq	r0, r0, ip
 6b4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 6b8:	7c020001 	stcvc	0, cr0, [r2], {1}
 6bc:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 6c0:	00000024 	andeq	r0, r0, r4, lsr #32
 6c4:	000006b0 			; <UNDEFINED> instruction: 0x000006b0
 6c8:	00009b40 	andeq	r9, r0, r0, asr #22
 6cc:	00000128 	andeq	r0, r0, r8, lsr #2
 6d0:	84240e46 	strthi	r0, [r4], #-3654	; 0xfffff1ba
 6d4:	86088509 	strhi	r8, [r8], -r9, lsl #10
 6d8:	88068707 	stmdahi	r6, {r0, r1, r2, r8, r9, sl, pc}
 6dc:	8a048905 	bhi	122af8 <__bss_end+0x118e00>
 6e0:	8e028b03 	vmlahi.f64	d8, d2, d3
 6e4:	00000001 	andeq	r0, r0, r1

Disassembly of section .debug_loc:

00000000 <.debug_loc>:
	...
   c:	00130000 	andseq	r0, r3, r0
  10:	00010000 	andeq	r0, r1, r0
  14:	00001350 	andeq	r1, r0, r0, asr r3
  18:	00001400 	andeq	r1, r0, r0, lsl #8
  1c:	f3000600 	vmax.u8	d0, d0, d0
  20:	2500f503 	strcs	pc, [r0, #-1283]	; 0xfffffafd
  24:	0000149f 	muleq	r0, pc, r4	; <UNPREDICTABLE>
  28:	00001c00 	andeq	r1, r0, r0, lsl #24
  2c:	50000100 	andpl	r0, r0, r0, lsl #2
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	0000001f 	andeq	r0, r0, pc, lsl r0
  38:	4f900002 	svcmi	0x00900002
  3c:	0000001f 	andeq	r0, r0, pc, lsl r0
  40:	0000002c 	andeq	r0, r0, ip, lsr #32
  44:	03f30006 	mvnseq	r0, #6
  48:	9f2500f5 	svcls	0x002500f5
	...
  5c:	0000002c 	andeq	r0, r0, ip, lsr #32
  60:	2c500001 	mrrccs	0, 0, r0, r0, cr1	; <UNPREDICTABLE>
  64:	40000000 	andmi	r0, r0, r0
  68:	06000000 	streq	r0, [r0], -r0
  6c:	f503f300 			; <UNDEFINED> instruction: 0xf503f300
  70:	009f3300 	addseq	r3, pc, r0, lsl #6
	...
  80:	00000c00 	andeq	r0, r0, r0, lsl #24
  84:	00002400 	andeq	r2, r0, r0, lsl #8
  88:	90000800 	andls	r0, r0, r0, lsl #16
  8c:	9004934c 	andls	r9, r4, ip, asr #6
  90:	2404934d 	strcs	r9, [r4], #-845	; 0xfffffcb3
  94:	2c000000 	stccs	0, cr0, [r0], {-0}
  98:	06000000 	streq	r0, [r0], -r0
  9c:	3300f500 	movwcc	pc, #1280	; 0x500	; <UNPREDICTABLE>
  a0:	2c9f25f7 	cfldr32cs	mvfx2, [pc], {247}	; 0xf7
  a4:	40000000 	andmi	r0, r0, r0
  a8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
  ac:	f503f300 			; <UNDEFINED> instruction: 0xf503f300
  b0:	25f73300 	ldrbcs	r3, [r7, #768]!	; 0x300
  b4:	0000009f 	muleq	r0, pc, r0	; <UNPREDICTABLE>
  b8:	00000000 	andeq	r0, r0, r0
  bc:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
  c0:	40000000 	andmi	r0, r0, r0
  c4:	02000000 	andeq	r0, r0, #0
  c8:	004e9000 	subeq	r9, lr, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	01000000 	mrseq	r0, (UNDEF: 0)
  d4:	00000000 	andeq	r0, r0, r0
  d8:	00001800 	andeq	r1, r0, r0, lsl #16
  dc:	00002400 	andeq	r2, r0, r0, lsl #8
  e0:	f5001a00 			; <UNDEFINED> instruction: 0xf5001a00
  e4:	4e92254c 	cdpmi	5, 9, cr2, cr2, cr12, {2}
  e8:	f72cf700 			; <UNDEFINED> instruction: 0xf72cf700
  ec:	0825f425 	stmdaeq	r5!, {r0, r2, r5, sl, ip, sp, lr, pc}
  f0:	00000000 	andeq	r0, r0, r0
  f4:	41f00000 	mvnsmi	r0, r0
  f8:	2cf71c1e 	ldclcs	12, cr1, [r7], #120	; 0x78
  fc:	0000249f 	muleq	r0, pc, r4	; <UNPREDICTABLE>
 100:	00002c00 	andeq	r2, r0, r0, lsl #24
 104:	f5001c00 			; <UNDEFINED> instruction: 0xf5001c00
 108:	25f73300 	ldrbcs	r3, [r7, #768]!	; 0x300
 10c:	f7004e92 			; <UNDEFINED> instruction: 0xf7004e92
 110:	f425f72c 	vld1.8	{d15}, [r5 :128], ip
 114:	00000825 	andeq	r0, r0, r5, lsr #16
 118:	00000000 	andeq	r0, r0, r0
 11c:	1c1e41f0 	ldfnes	f4, [lr], {240}	; 0xf0
 120:	2c9f2cf7 	ldccs	12, cr2, [pc], {247}	; 0xf7
 124:	40000000 	andmi	r0, r0, r0
 128:	1e000000 	cdpne	0, 0, cr0, cr0, cr0, {0}
 12c:	f503f300 			; <UNDEFINED> instruction: 0xf503f300
 130:	25f73300 	ldrbcs	r3, [r7, #768]!	; 0x300
 134:	f7004e92 			; <UNDEFINED> instruction: 0xf7004e92
 138:	f425f72c 	vld1.8	{d15}, [r5 :128], ip
 13c:	00000825 	andeq	r0, r0, r5, lsr #16
 140:	00000000 	andeq	r0, r0, r0
 144:	1c1e41f0 	ldfnes	f4, [lr], {240}	; 0xf0
 148:	009f2cf7 			; <UNDEFINED> instruction: 0x009f2cf7
	...
 158:	14000000 	strne	r0, [r0], #-0
 15c:	06000000 	streq	r0, [r0], -r0
 160:	04935000 	ldreq	r5, [r3], #0
 164:	14049351 	strne	r9, [r4], #-849	; 0xfffffcaf
 168:	28000000 	stmdacs	r0, {}	; <UNPREDICTABLE>
 16c:	06000001 	streq	r0, [r0], -r1
 170:	f503f300 			; <UNDEFINED> instruction: 0xf503f300
 174:	009f2500 	addseq	r2, pc, r0, lsl #10
	...
 184:	a4000000 	strge	r0, [r0], #-0
 188:	06000000 	streq	r0, [r0], -r0
 18c:	04935200 	ldreq	r5, [r3], #512	; 0x200
 190:	a4049353 	strge	r9, [r4], #-851	; 0xfffffcad
 194:	28000000 	stmdacs	r0, {}	; <UNPREDICTABLE>
 198:	06000001 	streq	r0, [r0], -r1
 19c:	f503f300 			; <UNDEFINED> instruction: 0xf503f300
 1a0:	009f2502 	addseq	r2, pc, r2, lsl #10
 1a4:	00000000 	andeq	r0, r0, r0
 1a8:	02000000 	andeq	r0, r0, #0
 1ac:	00000101 	andeq	r0, r0, r1, lsl #2
 1b0:	00000000 	andeq	r0, r0, r0
 1b4:	8c000000 	stchi	0, cr0, [r0], {-0}
 1b8:	0a000000 	beq	1c0 <shift+0x1c0>
 1bc:	00089e00 	andeq	r9, r8, r0, lsl #28
 1c0:	00000000 	andeq	r0, r0, r0
 1c4:	8c000000 	stchi	0, cr0, [r0], {-0}
 1c8:	f8000000 			; <UNDEFINED> instruction: 0xf8000000
 1cc:	06000000 	streq	r0, [r0], -r0
 1d0:	04935000 	ldreq	r5, [r3], #0
 1d4:	10049351 	andne	r9, r4, r1, asr r3
 1d8:	14000001 	strne	r0, [r0], #-1
 1dc:	06000001 	streq	r0, [r0], -r1
 1e0:	04935000 	ldreq	r5, [r3], #0
 1e4:	1c049351 	stcne	3, cr9, [r4], {81}	; 0x51
 1e8:	28000001 	stmdacs	r0, {r0}
 1ec:	06000001 	streq	r0, [r0], -r1
 1f0:	04935000 	ldreq	r5, [r3], #0
 1f4:	00049351 	andeq	r9, r4, r1, asr r3
	...
 208:	00001800 	andeq	r1, r0, r0, lsl #16
 20c:	00008000 	andeq	r8, r0, r0
 210:	54000600 	strpl	r0, [r0], #-1536	; 0xfffffa00
 214:	93550493 	cmpls	r5, #-1828716544	; 0x93000000
 218:	00008c04 	andeq	r8, r0, r4, lsl #24
 21c:	0000bc00 	andeq	fp, r0, r0, lsl #24
 220:	54000600 	strpl	r0, [r0], #-1536	; 0xfffffa00
 224:	93550493 	cmpls	r5, #-1828716544	; 0x93000000
 228:	0000c004 	andeq	ip, r0, r4
 22c:	0000d800 	andeq	sp, r0, r0, lsl #16
 230:	54000600 	strpl	r0, [r0], #-1536	; 0xfffffa00
 234:	93550493 	cmpls	r5, #-1828716544	; 0x93000000
 238:	0000dc04 	andeq	sp, r0, r4, lsl #24
 23c:	0000fc00 	andeq	pc, r0, r0, lsl #24
 240:	54000600 	strpl	r0, [r0], #-1536	; 0xfffffa00
 244:	93550493 	cmpls	r5, #-1828716544	; 0x93000000
 248:	00011804 	andeq	r1, r1, r4, lsl #16
 24c:	00012800 	andeq	r2, r1, r0, lsl #16
 250:	54000600 	strpl	r0, [r0], #-1536	; 0xfffffa00
 254:	93550493 	cmpls	r5, #-1828716544	; 0x93000000
 258:	00000004 	andeq	r0, r0, r4
	...
 264:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
 268:	60000000 	andvs	r0, r0, r0
 26c:	06000000 	streq	r0, [r0], -r0
 270:	04935200 	ldreq	r5, [r3], #512	; 0x200
 274:	60049353 	andvs	r9, r4, r3, asr r3
 278:	a0000000 	andge	r0, r0, r0
 27c:	06000000 	streq	r0, [r0], -r0
 280:	04935800 	ldreq	r5, [r3], #2048	; 0x800
 284:	a0049359 	andge	r9, r4, r9, asr r3
 288:	1c000000 	stcne	0, cr0, [r0], {-0}
 28c:	06000001 	streq	r0, [r0], -r1
 290:	04935600 	ldreq	r5, [r3], #1536	; 0x600
 294:	00049357 	andeq	r9, r4, r7, asr r3
	...
 2a0:	00004400 	andeq	r4, r0, r0, lsl #8
 2a4:	00007000 	andeq	r7, r0, r0
 2a8:	51000100 	mrspl	r0, (UNDEF: 16)
	...
 2b4:	01000001 	tsteq	r0, r1
 2b8:	01000001 	tsteq	r0, r1
 2bc:	00000001 	andeq	r0, r0, r1
 2c0:	000000a0 	andeq	r0, r0, r0, lsr #1
 2c4:	000000a8 	andeq	r0, r0, r8, lsr #1
 2c8:	a85c0001 	ldmdage	ip, {r0}^
 2cc:	c0000000 	andgt	r0, r0, r0
 2d0:	01000000 	mrseq	r0, (UNDEF: 0)
 2d4:	00c05200 	sbceq	r5, r0, r0, lsl #4
 2d8:	00c40000 	sbceq	r0, r4, r0
 2dc:	00030000 	andeq	r0, r3, r0
 2e0:	c49f7f72 	ldrgt	r7, [pc], #3954	; 2e8 <shift+0x2e8>
 2e4:	dc000000 	stcle	0, cr0, [r0], {-0}
 2e8:	01000000 	mrseq	r0, (UNDEF: 0)
 2ec:	00dc5200 	sbcseq	r5, ip, r0, lsl #4
 2f0:	00e00000 	rsceq	r0, r0, r0
 2f4:	00030000 	andeq	r0, r3, r0
 2f8:	e09f7f72 	adds	r7, pc, r2, ror pc	; <UNPREDICTABLE>
 2fc:	f0000000 			; <UNDEFINED> instruction: 0xf0000000
 300:	01000000 	mrseq	r0, (UNDEF: 0)
 304:	00005200 	andeq	r5, r0, r0, lsl #4
	...
 310:	00480000 	subeq	r0, r8, r0
 314:	01080000 	mrseq	r0, (UNDEF: 8)
 318:	00010000 	andeq	r0, r1, r0
 31c:	0001085c 	andeq	r0, r1, ip, asr r8
 320:	00011c00 	andeq	r1, r1, r0, lsl #24
 324:	7b000300 	blvc	f2c <shift+0xf2c>
 328:	00009f20 	andeq	r9, r0, r0, lsr #30
 32c:	00000000 	andeq	r0, r0, r0
	...
