
./init_task:     file format elf32-littlearm


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
    8064:	00008e1c 	andeq	r8, r0, ip, lsl lr
    8068:	00008e2c 	andeq	r8, r0, ip, lsr #28

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
    81d4:	00008e19 	andeq	r8, r0, r9, lsl lr
    81d8:	00008e19 	andeq	r8, r0, r9, lsl lr

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
    822c:	00008e19 	andeq	r8, r0, r9, lsl lr
    8230:	00008e19 	andeq	r8, r0, r9, lsl lr

00008234 <main>:
main():
/home/hintik/dev/KIV-RTOS-master/sources/userspace/init_task/main.cpp:6
#include <stdfile.h>

#include <process/process_manager.h>

int main(int argc, char** argv)
{
    8234:	e92d4800 	push	{fp, lr}
    8238:	e28db004 	add	fp, sp, #4
    823c:	e24dd008 	sub	sp, sp, #8
    8240:	e50b0008 	str	r0, [fp, #-8]
    8244:	e50b100c 	str	r1, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/userspace/init_task/main.cpp:11
	// systemovy init task startuje jako prvni, a ma nejnizsi prioritu ze vsech - bude se tedy planovat v podstate jen tehdy,
	// kdy nic jineho nikdo nema na praci

	// nastavime deadline na "nekonecno" = vlastne snizime dynamickou prioritu na nejnizsi moznou
	set_task_deadline(Indefinite);
    8248:	e3e00000 	mvn	r0, #0
    824c:	eb0000d7 	bl	85b0 <_Z17set_task_deadlinej>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/init_task/main.cpp:18
	// TODO: tady budeme chtit nechat spoustet zbytek procesu, az budeme umet nacitat treba z eMMC a SD karty
	
	while (true)
	{
		// kdyz je planovany jen tento proces, pockame na udalost (preruseni, ...)
		if (get_active_process_count() == 1)
    8250:	eb0000b8 	bl	8538 <_Z24get_active_process_countv>
    8254:	e1a03000 	mov	r3, r0
    8258:	e3530001 	cmp	r3, #1
    825c:	03a03001 	moveq	r3, #1
    8260:	13a03000 	movne	r3, #0
    8264:	e6ef3073 	uxtb	r3, r3
    8268:	e3530000 	cmp	r3, #0
    826c:	0a000000 	beq	8274 <main+0x40>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/init_task/main.cpp:19
			asm volatile("wfe");
    8270:	e320f002 	wfe
/home/hintik/dev/KIV-RTOS-master/sources/userspace/init_task/main.cpp:22

		// predame zbytek casoveho kvanta dalsimu procesu
		sched_yield();
    8274:	eb000016 	bl	82d4 <_Z11sched_yieldv>
/home/hintik/dev/KIV-RTOS-master/sources/userspace/init_task/main.cpp:18
		if (get_active_process_count() == 1)
    8278:	eafffff4 	b	8250 <main+0x1c>

0000827c <_Z6getpidv>:
_Z6getpidv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    827c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8280:	e28db000 	add	fp, sp, #0
    8284:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8288:	ef000000 	svc	0x00000000
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    828c:	e1a03000 	mov	r3, r0
    8290:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:11

    return pid;
    8294:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:12
}
    8298:	e1a00003 	mov	r0, r3
    829c:	e28bd000 	add	sp, fp, #0
    82a0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82a4:	e12fff1e 	bx	lr

000082a8 <_Z9terminatei>:
_Z9terminatei():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    82a8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82ac:	e28db000 	add	fp, sp, #0
    82b0:	e24dd00c 	sub	sp, sp, #12
    82b4:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    82b8:	e51b3008 	ldr	r3, [fp, #-8]
    82bc:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    82c0:	ef000001 	svc	0x00000001
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:18
}
    82c4:	e320f000 	nop	{0}
    82c8:	e28bd000 	add	sp, fp, #0
    82cc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82d0:	e12fff1e 	bx	lr

000082d4 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    82d4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82d8:	e28db000 	add	fp, sp, #0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    82dc:	ef000002 	svc	0x00000002
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:23
}
    82e0:	e320f000 	nop	{0}
    82e4:	e28bd000 	add	sp, fp, #0
    82e8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82ec:	e12fff1e 	bx	lr

000082f0 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    82f0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82f4:	e28db000 	add	fp, sp, #0
    82f8:	e24dd014 	sub	sp, sp, #20
    82fc:	e50b0010 	str	r0, [fp, #-16]
    8300:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    8304:	e51b3010 	ldr	r3, [fp, #-16]
    8308:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    830c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8310:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    8314:	ef000040 	svc	0x00000040
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    8318:	e1a03000 	mov	r3, r0
    831c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:34

    return file;
    8320:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:35
}
    8324:	e1a00003 	mov	r0, r3
    8328:	e28bd000 	add	sp, fp, #0
    832c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8330:	e12fff1e 	bx	lr

00008334 <_Z4readjPcj>:
_Z4readjPcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    8334:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8338:	e28db000 	add	fp, sp, #0
    833c:	e24dd01c 	sub	sp, sp, #28
    8340:	e50b0010 	str	r0, [fp, #-16]
    8344:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8348:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    834c:	e51b3010 	ldr	r3, [fp, #-16]
    8350:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    8354:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8358:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    835c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8360:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    8364:	ef000041 	svc	0x00000041
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    8368:	e1a03000 	mov	r3, r0
    836c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    8370:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:48
}
    8374:	e1a00003 	mov	r0, r3
    8378:	e28bd000 	add	sp, fp, #0
    837c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8380:	e12fff1e 	bx	lr

00008384 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    8384:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8388:	e28db000 	add	fp, sp, #0
    838c:	e24dd01c 	sub	sp, sp, #28
    8390:	e50b0010 	str	r0, [fp, #-16]
    8394:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8398:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    839c:	e51b3010 	ldr	r3, [fp, #-16]
    83a0:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    83a4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83a8:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    83ac:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83b0:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    83b4:	ef000042 	svc	0x00000042
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    83b8:	e1a03000 	mov	r3, r0
    83bc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    83c0:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:61
}
    83c4:	e1a00003 	mov	r0, r3
    83c8:	e28bd000 	add	sp, fp, #0
    83cc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83d0:	e12fff1e 	bx	lr

000083d4 <_Z5closej>:
_Z5closej():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    83d4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83d8:	e28db000 	add	fp, sp, #0
    83dc:	e24dd00c 	sub	sp, sp, #12
    83e0:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    83e4:	e51b3008 	ldr	r3, [fp, #-8]
    83e8:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    83ec:	ef000043 	svc	0x00000043
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:67
}
    83f0:	e320f000 	nop	{0}
    83f4:	e28bd000 	add	sp, fp, #0
    83f8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83fc:	e12fff1e 	bx	lr

00008400 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    8400:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8404:	e28db000 	add	fp, sp, #0
    8408:	e24dd01c 	sub	sp, sp, #28
    840c:	e50b0010 	str	r0, [fp, #-16]
    8410:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8414:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8418:	e51b3010 	ldr	r3, [fp, #-16]
    841c:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    8420:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8424:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    8428:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    842c:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    8430:	ef000044 	svc	0x00000044
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    8434:	e1a03000 	mov	r3, r0
    8438:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    843c:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:80
}
    8440:	e1a00003 	mov	r0, r3
    8444:	e28bd000 	add	sp, fp, #0
    8448:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    844c:	e12fff1e 	bx	lr

00008450 <_Z6notifyjj>:
_Z6notifyjj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    8450:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8454:	e28db000 	add	fp, sp, #0
    8458:	e24dd014 	sub	sp, sp, #20
    845c:	e50b0010 	str	r0, [fp, #-16]
    8460:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    8464:	e51b3010 	ldr	r3, [fp, #-16]
    8468:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    846c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8470:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    8474:	ef000045 	svc	0x00000045
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    8478:	e1a03000 	mov	r3, r0
    847c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    8480:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:92
}
    8484:	e1a00003 	mov	r0, r3
    8488:	e28bd000 	add	sp, fp, #0
    848c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8490:	e12fff1e 	bx	lr

00008494 <_Z4waitjjj>:
_Z4waitjjj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    8494:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8498:	e28db000 	add	fp, sp, #0
    849c:	e24dd01c 	sub	sp, sp, #28
    84a0:	e50b0010 	str	r0, [fp, #-16]
    84a4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84a8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    84ac:	e51b3010 	ldr	r3, [fp, #-16]
    84b0:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    84b4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84b8:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    84bc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84c0:	e1a02003 	mov	r2, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    84c4:	ef000046 	svc	0x00000046
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    84c8:	e1a03000 	mov	r3, r0
    84cc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    84d0:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:105
}
    84d4:	e1a00003 	mov	r0, r3
    84d8:	e28bd000 	add	sp, fp, #0
    84dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84e0:	e12fff1e 	bx	lr

000084e4 <_Z5sleepjj>:
_Z5sleepjj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    84e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84e8:	e28db000 	add	fp, sp, #0
    84ec:	e24dd014 	sub	sp, sp, #20
    84f0:	e50b0010 	str	r0, [fp, #-16]
    84f4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    84f8:	e51b3010 	ldr	r3, [fp, #-16]
    84fc:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    8500:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8504:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    8508:	ef000003 	svc	0x00000003
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    850c:	e1a03000 	mov	r3, r0
    8510:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    8514:	e51b3008 	ldr	r3, [fp, #-8]
    8518:	e3530000 	cmp	r3, #0
    851c:	13a03001 	movne	r3, #1
    8520:	03a03000 	moveq	r3, #0
    8524:	e6ef3073 	uxtb	r3, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:117
}
    8528:	e1a00003 	mov	r0, r3
    852c:	e28bd000 	add	sp, fp, #0
    8530:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8534:	e12fff1e 	bx	lr

00008538 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    8538:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    853c:	e28db000 	add	fp, sp, #0
    8540:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    8544:	e3a03000 	mov	r3, #0
    8548:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    854c:	e3a03000 	mov	r3, #0
    8550:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    8554:	e24b300c 	sub	r3, fp, #12
    8558:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    855c:	ef000004 	svc	0x00000004
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:128

    return retval;
    8560:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:129
}
    8564:	e1a00003 	mov	r0, r3
    8568:	e28bd000 	add	sp, fp, #0
    856c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8570:	e12fff1e 	bx	lr

00008574 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    8574:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8578:	e28db000 	add	fp, sp, #0
    857c:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    8580:	e3a03001 	mov	r3, #1
    8584:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8588:	e3a03001 	mov	r3, #1
    858c:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    8590:	e24b300c 	sub	r3, fp, #12
    8594:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    8598:	ef000004 	svc	0x00000004
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:140

    return retval;
    859c:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:141
}
    85a0:	e1a00003 	mov	r0, r3
    85a4:	e28bd000 	add	sp, fp, #0
    85a8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85ac:	e12fff1e 	bx	lr

000085b0 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    85b0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85b4:	e28db000 	add	fp, sp, #0
    85b8:	e24dd014 	sub	sp, sp, #20
    85bc:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    85c0:	e3a03000 	mov	r3, #0
    85c4:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    85c8:	e3a03000 	mov	r3, #0
    85cc:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    85d0:	e24b3010 	sub	r3, fp, #16
    85d4:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    85d8:	ef000005 	svc	0x00000005
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:150
}
    85dc:	e320f000 	nop	{0}
    85e0:	e28bd000 	add	sp, fp, #0
    85e4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85e8:	e12fff1e 	bx	lr

000085ec <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    85ec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85f0:	e28db000 	add	fp, sp, #0
    85f4:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    85f8:	e3a03001 	mov	r3, #1
    85fc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    8600:	e3a03001 	mov	r3, #1
    8604:	e1a00003 	mov	r0, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    8608:	e24b300c 	sub	r3, fp, #12
    860c:	e1a01003 	mov	r1, r3
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    8610:	ef000005 	svc	0x00000005
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    8614:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:162
}
    8618:	e1a00003 	mov	r0, r3
    861c:	e28bd000 	add	sp, fp, #0
    8620:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8624:	e12fff1e 	bx	lr

00008628 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    8628:	e92d4800 	push	{fp, lr}
    862c:	e28db004 	add	fp, sp, #4
    8630:	e24dd050 	sub	sp, sp, #80	; 0x50
    8634:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    8638:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    863c:	e24b3048 	sub	r3, fp, #72	; 0x48
    8640:	e3a0200a 	mov	r2, #10
    8644:	e59f108c 	ldr	r1, [pc, #140]	; 86d8 <_Z4pipePKcj+0xb0>
    8648:	e1a00003 	mov	r0, r3
    864c:	eb0000a6 	bl	88ec <_Z7strncpyPcPKci>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    8650:	e24b3048 	sub	r3, fp, #72	; 0x48
    8654:	e283300a 	add	r3, r3, #10
    8658:	e3a02035 	mov	r2, #53	; 0x35
    865c:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    8660:	e1a00003 	mov	r0, r3
    8664:	eb0000a0 	bl	88ec <_Z7strncpyPcPKci>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8668:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    866c:	eb0000f9 	bl	8a58 <_Z6strlenPKc>
    8670:	e1a03000 	mov	r3, r0
    8674:	e283300a 	add	r3, r3, #10
    8678:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    867c:	e51b3008 	ldr	r3, [fp, #-8]
    8680:	e2832001 	add	r2, r3, #1
    8684:	e50b2008 	str	r2, [fp, #-8]
    8688:	e24b2004 	sub	r2, fp, #4
    868c:	e0823003 	add	r3, r2, r3
    8690:	e3a02023 	mov	r2, #35	; 0x23
    8694:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    8698:	e24b2048 	sub	r2, fp, #72	; 0x48
    869c:	e51b3008 	ldr	r3, [fp, #-8]
    86a0:	e0823003 	add	r3, r2, r3
    86a4:	e3a0200a 	mov	r2, #10
    86a8:	e1a01003 	mov	r1, r3
    86ac:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    86b0:	eb000009 	bl	86dc <_Z4itoajPcj>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    86b4:	e24b3048 	sub	r3, fp, #72	; 0x48
    86b8:	e3a01002 	mov	r1, #2
    86bc:	e1a00003 	mov	r0, r3
    86c0:	ebffff0a 	bl	82f0 <_Z4openPKc15NFile_Open_Mode>
    86c4:	e1a03000 	mov	r3, r0
    86c8:	e320f000 	nop	{0}
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdfile.cpp:179
}
    86cc:	e1a00003 	mov	r0, r3
    86d0:	e24bd004 	sub	sp, fp, #4
    86d4:	e8bd8800 	pop	{fp, pc}
    86d8:	00008dfc 	strdeq	r8, [r0], -ip

000086dc <_Z4itoajPcj>:
_Z4itoajPcj():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    86dc:	e92d4800 	push	{fp, lr}
    86e0:	e28db004 	add	fp, sp, #4
    86e4:	e24dd020 	sub	sp, sp, #32
    86e8:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    86ec:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    86f0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:10
	int i = 0;
    86f4:	e3a03000 	mov	r3, #0
    86f8:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:12

	while (input > 0)
    86fc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8700:	e3530000 	cmp	r3, #0
    8704:	0a000014 	beq	875c <_Z4itoajPcj+0x80>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    8708:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    870c:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8710:	e1a00003 	mov	r0, r3
    8714:	eb000199 	bl	8d80 <__aeabi_uidivmod>
    8718:	e1a03001 	mov	r3, r1
    871c:	e1a01003 	mov	r1, r3
    8720:	e51b3008 	ldr	r3, [fp, #-8]
    8724:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8728:	e0823003 	add	r3, r2, r3
    872c:	e59f2118 	ldr	r2, [pc, #280]	; 884c <_Z4itoajPcj+0x170>
    8730:	e7d22001 	ldrb	r2, [r2, r1]
    8734:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:15
		input /= base;
    8738:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    873c:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8740:	eb000113 	bl	8b94 <__udivsi3>
    8744:	e1a03000 	mov	r3, r0
    8748:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:16
		i++;
    874c:	e51b3008 	ldr	r3, [fp, #-8]
    8750:	e2833001 	add	r3, r3, #1
    8754:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:12
	while (input > 0)
    8758:	eaffffe7 	b	86fc <_Z4itoajPcj+0x20>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    875c:	e51b3008 	ldr	r3, [fp, #-8]
    8760:	e3530000 	cmp	r3, #0
    8764:	1a000007 	bne	8788 <_Z4itoajPcj+0xac>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    8768:	e51b3008 	ldr	r3, [fp, #-8]
    876c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8770:	e0823003 	add	r3, r2, r3
    8774:	e3a02030 	mov	r2, #48	; 0x30
    8778:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:22
        i++;
    877c:	e51b3008 	ldr	r3, [fp, #-8]
    8780:	e2833001 	add	r3, r3, #1
    8784:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    8788:	e51b3008 	ldr	r3, [fp, #-8]
    878c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8790:	e0823003 	add	r3, r2, r3
    8794:	e3a02000 	mov	r2, #0
    8798:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:26
	i--;
    879c:	e51b3008 	ldr	r3, [fp, #-8]
    87a0:	e2433001 	sub	r3, r3, #1
    87a4:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    87a8:	e3a03000 	mov	r3, #0
    87ac:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:28 (discriminator 3)
    87b0:	e51b3008 	ldr	r3, [fp, #-8]
    87b4:	e1a02fa3 	lsr	r2, r3, #31
    87b8:	e0823003 	add	r3, r2, r3
    87bc:	e1a030c3 	asr	r3, r3, #1
    87c0:	e1a02003 	mov	r2, r3
    87c4:	e51b300c 	ldr	r3, [fp, #-12]
    87c8:	e1530002 	cmp	r3, r2
    87cc:	ca00001b 	bgt	8840 <_Z4itoajPcj+0x164>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    87d0:	e51b2008 	ldr	r2, [fp, #-8]
    87d4:	e51b300c 	ldr	r3, [fp, #-12]
    87d8:	e0423003 	sub	r3, r2, r3
    87dc:	e1a02003 	mov	r2, r3
    87e0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    87e4:	e0833002 	add	r3, r3, r2
    87e8:	e5d33000 	ldrb	r3, [r3]
    87ec:	e54b300d 	strb	r3, [fp, #-13]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    87f0:	e51b300c 	ldr	r3, [fp, #-12]
    87f4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87f8:	e0822003 	add	r2, r2, r3
    87fc:	e51b1008 	ldr	r1, [fp, #-8]
    8800:	e51b300c 	ldr	r3, [fp, #-12]
    8804:	e0413003 	sub	r3, r1, r3
    8808:	e1a01003 	mov	r1, r3
    880c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8810:	e0833001 	add	r3, r3, r1
    8814:	e5d22000 	ldrb	r2, [r2]
    8818:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    881c:	e51b300c 	ldr	r3, [fp, #-12]
    8820:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8824:	e0823003 	add	r3, r2, r3
    8828:	e55b200d 	ldrb	r2, [fp, #-13]
    882c:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    8830:	e51b300c 	ldr	r3, [fp, #-12]
    8834:	e2833001 	add	r3, r3, #1
    8838:	e50b300c 	str	r3, [fp, #-12]
    883c:	eaffffdb 	b	87b0 <_Z4itoajPcj+0xd4>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:34
	}
}
    8840:	e320f000 	nop	{0}
    8844:	e24bd004 	sub	sp, fp, #4
    8848:	e8bd8800 	pop	{fp, pc}
    884c:	00008e08 	andeq	r8, r0, r8, lsl #28

00008850 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    8850:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8854:	e28db000 	add	fp, sp, #0
    8858:	e24dd014 	sub	sp, sp, #20
    885c:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:38
	int output = 0;
    8860:	e3a03000 	mov	r3, #0
    8864:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    8868:	e51b3010 	ldr	r3, [fp, #-16]
    886c:	e5d33000 	ldrb	r3, [r3]
    8870:	e3530000 	cmp	r3, #0
    8874:	0a000017 	beq	88d8 <_Z4atoiPKc+0x88>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    8878:	e51b2008 	ldr	r2, [fp, #-8]
    887c:	e1a03002 	mov	r3, r2
    8880:	e1a03103 	lsl	r3, r3, #2
    8884:	e0833002 	add	r3, r3, r2
    8888:	e1a03083 	lsl	r3, r3, #1
    888c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    8890:	e51b3010 	ldr	r3, [fp, #-16]
    8894:	e5d33000 	ldrb	r3, [r3]
    8898:	e3530039 	cmp	r3, #57	; 0x39
    889c:	8a00000d 	bhi	88d8 <_Z4atoiPKc+0x88>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:43 (discriminator 1)
    88a0:	e51b3010 	ldr	r3, [fp, #-16]
    88a4:	e5d33000 	ldrb	r3, [r3]
    88a8:	e353002f 	cmp	r3, #47	; 0x2f
    88ac:	9a000009 	bls	88d8 <_Z4atoiPKc+0x88>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    88b0:	e51b3010 	ldr	r3, [fp, #-16]
    88b4:	e5d33000 	ldrb	r3, [r3]
    88b8:	e2433030 	sub	r3, r3, #48	; 0x30
    88bc:	e51b2008 	ldr	r2, [fp, #-8]
    88c0:	e0823003 	add	r3, r2, r3
    88c4:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:48

		input++;
    88c8:	e51b3010 	ldr	r3, [fp, #-16]
    88cc:	e2833001 	add	r3, r3, #1
    88d0:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    88d4:	eaffffe3 	b	8868 <_Z4atoiPKc+0x18>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:51
	}

	return output;
    88d8:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:52
}
    88dc:	e1a00003 	mov	r0, r3
    88e0:	e28bd000 	add	sp, fp, #0
    88e4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    88e8:	e12fff1e 	bx	lr

000088ec <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    88ec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    88f0:	e28db000 	add	fp, sp, #0
    88f4:	e24dd01c 	sub	sp, sp, #28
    88f8:	e50b0010 	str	r0, [fp, #-16]
    88fc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8900:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8904:	e3a03000 	mov	r3, #0
    8908:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58 (discriminator 4)
    890c:	e51b2008 	ldr	r2, [fp, #-8]
    8910:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8914:	e1520003 	cmp	r2, r3
    8918:	aa000011 	bge	8964 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58 (discriminator 2)
    891c:	e51b3008 	ldr	r3, [fp, #-8]
    8920:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8924:	e0823003 	add	r3, r2, r3
    8928:	e5d33000 	ldrb	r3, [r3]
    892c:	e3530000 	cmp	r3, #0
    8930:	0a00000b 	beq	8964 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    8934:	e51b3008 	ldr	r3, [fp, #-8]
    8938:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    893c:	e0822003 	add	r2, r2, r3
    8940:	e51b3008 	ldr	r3, [fp, #-8]
    8944:	e51b1010 	ldr	r1, [fp, #-16]
    8948:	e0813003 	add	r3, r1, r3
    894c:	e5d22000 	ldrb	r2, [r2]
    8950:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8954:	e51b3008 	ldr	r3, [fp, #-8]
    8958:	e2833001 	add	r3, r3, #1
    895c:	e50b3008 	str	r3, [fp, #-8]
    8960:	eaffffe9 	b	890c <_Z7strncpyPcPKci+0x20>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    8964:	e51b2008 	ldr	r2, [fp, #-8]
    8968:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    896c:	e1520003 	cmp	r2, r3
    8970:	aa000008 	bge	8998 <_Z7strncpyPcPKci+0xac>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8974:	e51b3008 	ldr	r3, [fp, #-8]
    8978:	e51b2010 	ldr	r2, [fp, #-16]
    897c:	e0823003 	add	r3, r2, r3
    8980:	e3a02000 	mov	r2, #0
    8984:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8988:	e51b3008 	ldr	r3, [fp, #-8]
    898c:	e2833001 	add	r3, r3, #1
    8990:	e50b3008 	str	r3, [fp, #-8]
    8994:	eafffff2 	b	8964 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:63

   return dest;
    8998:	e51b3010 	ldr	r3, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:64
}
    899c:	e1a00003 	mov	r0, r3
    89a0:	e28bd000 	add	sp, fp, #0
    89a4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    89a8:	e12fff1e 	bx	lr

000089ac <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    89ac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89b0:	e28db000 	add	fp, sp, #0
    89b4:	e24dd01c 	sub	sp, sp, #28
    89b8:	e50b0010 	str	r0, [fp, #-16]
    89bc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    89c0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    89c4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    89c8:	e2432001 	sub	r2, r3, #1
    89cc:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    89d0:	e3530000 	cmp	r3, #0
    89d4:	c3a03001 	movgt	r3, #1
    89d8:	d3a03000 	movle	r3, #0
    89dc:	e6ef3073 	uxtb	r3, r3
    89e0:	e3530000 	cmp	r3, #0
    89e4:	0a000016 	beq	8a44 <_Z7strncmpPKcS0_i+0x98>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    89e8:	e51b3010 	ldr	r3, [fp, #-16]
    89ec:	e2832001 	add	r2, r3, #1
    89f0:	e50b2010 	str	r2, [fp, #-16]
    89f4:	e5d33000 	ldrb	r3, [r3]
    89f8:	e54b3005 	strb	r3, [fp, #-5]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    89fc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8a00:	e2832001 	add	r2, r3, #1
    8a04:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8a08:	e5d33000 	ldrb	r3, [r3]
    8a0c:	e54b3006 	strb	r3, [fp, #-6]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    8a10:	e55b2005 	ldrb	r2, [fp, #-5]
    8a14:	e55b3006 	ldrb	r3, [fp, #-6]
    8a18:	e1520003 	cmp	r2, r3
    8a1c:	0a000003 	beq	8a30 <_Z7strncmpPKcS0_i+0x84>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    8a20:	e55b2005 	ldrb	r2, [fp, #-5]
    8a24:	e55b3006 	ldrb	r3, [fp, #-6]
    8a28:	e0423003 	sub	r3, r2, r3
    8a2c:	ea000005 	b	8a48 <_Z7strncmpPKcS0_i+0x9c>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    8a30:	e55b3005 	ldrb	r3, [fp, #-5]
    8a34:	e3530000 	cmp	r3, #0
    8a38:	1affffe1 	bne	89c4 <_Z7strncmpPKcS0_i+0x18>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:76
        	return 0;
    8a3c:	e3a03000 	mov	r3, #0
    8a40:	ea000000 	b	8a48 <_Z7strncmpPKcS0_i+0x9c>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8a44:	e3a03000 	mov	r3, #0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:80
}
    8a48:	e1a00003 	mov	r0, r3
    8a4c:	e28bd000 	add	sp, fp, #0
    8a50:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a54:	e12fff1e 	bx	lr

00008a58 <_Z6strlenPKc>:
_Z6strlenPKc():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8a58:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a5c:	e28db000 	add	fp, sp, #0
    8a60:	e24dd014 	sub	sp, sp, #20
    8a64:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:84
	int i = 0;
    8a68:	e3a03000 	mov	r3, #0
    8a6c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8a70:	e51b3008 	ldr	r3, [fp, #-8]
    8a74:	e51b2010 	ldr	r2, [fp, #-16]
    8a78:	e0823003 	add	r3, r2, r3
    8a7c:	e5d33000 	ldrb	r3, [r3]
    8a80:	e3530000 	cmp	r3, #0
    8a84:	0a000003 	beq	8a98 <_Z6strlenPKc+0x40>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:87
		i++;
    8a88:	e51b3008 	ldr	r3, [fp, #-8]
    8a8c:	e2833001 	add	r3, r3, #1
    8a90:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8a94:	eafffff5 	b	8a70 <_Z6strlenPKc+0x18>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:89

	return i;
    8a98:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:90
}
    8a9c:	e1a00003 	mov	r0, r3
    8aa0:	e28bd000 	add	sp, fp, #0
    8aa4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8aa8:	e12fff1e 	bx	lr

00008aac <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8aac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ab0:	e28db000 	add	fp, sp, #0
    8ab4:	e24dd014 	sub	sp, sp, #20
    8ab8:	e50b0010 	str	r0, [fp, #-16]
    8abc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8ac0:	e51b3010 	ldr	r3, [fp, #-16]
    8ac4:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8ac8:	e3a03000 	mov	r3, #0
    8acc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8ad0:	e51b2008 	ldr	r2, [fp, #-8]
    8ad4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8ad8:	e1520003 	cmp	r2, r3
    8adc:	aa000008 	bge	8b04 <_Z5bzeroPvi+0x58>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8ae0:	e51b3008 	ldr	r3, [fp, #-8]
    8ae4:	e51b200c 	ldr	r2, [fp, #-12]
    8ae8:	e0823003 	add	r3, r2, r3
    8aec:	e3a02000 	mov	r2, #0
    8af0:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8af4:	e51b3008 	ldr	r3, [fp, #-8]
    8af8:	e2833001 	add	r3, r3, #1
    8afc:	e50b3008 	str	r3, [fp, #-8]
    8b00:	eafffff2 	b	8ad0 <_Z5bzeroPvi+0x24>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:98
}
    8b04:	e320f000 	nop	{0}
    8b08:	e28bd000 	add	sp, fp, #0
    8b0c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b10:	e12fff1e 	bx	lr

00008b14 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8b14:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b18:	e28db000 	add	fp, sp, #0
    8b1c:	e24dd024 	sub	sp, sp, #36	; 0x24
    8b20:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8b24:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8b28:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8b2c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b30:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8b34:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8b38:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8b3c:	e3a03000 	mov	r3, #0
    8b40:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8b44:	e51b2008 	ldr	r2, [fp, #-8]
    8b48:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8b4c:	e1520003 	cmp	r2, r3
    8b50:	aa00000b 	bge	8b84 <_Z6memcpyPKvPvi+0x70>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8b54:	e51b3008 	ldr	r3, [fp, #-8]
    8b58:	e51b200c 	ldr	r2, [fp, #-12]
    8b5c:	e0822003 	add	r2, r2, r3
    8b60:	e51b3008 	ldr	r3, [fp, #-8]
    8b64:	e51b1010 	ldr	r1, [fp, #-16]
    8b68:	e0813003 	add	r3, r1, r3
    8b6c:	e5d22000 	ldrb	r2, [r2]
    8b70:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8b74:	e51b3008 	ldr	r3, [fp, #-8]
    8b78:	e2833001 	add	r3, r3, #1
    8b7c:	e50b3008 	str	r3, [fp, #-8]
    8b80:	eaffffef 	b	8b44 <_Z6memcpyPKvPvi+0x30>
/home/hintik/dev/KIV-RTOS-master/sources/stdlib/src/stdstring.cpp:107
}
    8b84:	e320f000 	nop	{0}
    8b88:	e28bd000 	add	sp, fp, #0
    8b8c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b90:	e12fff1e 	bx	lr

00008b94 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1150
    8b94:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1152
    8b98:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1153
    8b9c:	3a000074 	bcc	8d74 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1154
    8ba0:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1155
    8ba4:	9a00006b 	bls	8d58 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    8ba8:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    8bac:	0a00006c 	beq	8d64 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    8bb0:	e16f3f10 	clz	r3, r0
    8bb4:	e16f2f11 	clz	r2, r1
    8bb8:	e0423003 	sub	r3, r2, r3
    8bbc:	e273301f 	rsbs	r3, r3, #31
    8bc0:	10833083 	addne	r3, r3, r3, lsl #1
    8bc4:	e3a02000 	mov	r2, #0
    8bc8:	108ff103 	addne	pc, pc, r3, lsl #2
    8bcc:	e1a00000 	nop			; (mov r0, r0)
    8bd0:	e1500f81 	cmp	r0, r1, lsl #31
    8bd4:	e0a22002 	adc	r2, r2, r2
    8bd8:	20400f81 	subcs	r0, r0, r1, lsl #31
    8bdc:	e1500f01 	cmp	r0, r1, lsl #30
    8be0:	e0a22002 	adc	r2, r2, r2
    8be4:	20400f01 	subcs	r0, r0, r1, lsl #30
    8be8:	e1500e81 	cmp	r0, r1, lsl #29
    8bec:	e0a22002 	adc	r2, r2, r2
    8bf0:	20400e81 	subcs	r0, r0, r1, lsl #29
    8bf4:	e1500e01 	cmp	r0, r1, lsl #28
    8bf8:	e0a22002 	adc	r2, r2, r2
    8bfc:	20400e01 	subcs	r0, r0, r1, lsl #28
    8c00:	e1500d81 	cmp	r0, r1, lsl #27
    8c04:	e0a22002 	adc	r2, r2, r2
    8c08:	20400d81 	subcs	r0, r0, r1, lsl #27
    8c0c:	e1500d01 	cmp	r0, r1, lsl #26
    8c10:	e0a22002 	adc	r2, r2, r2
    8c14:	20400d01 	subcs	r0, r0, r1, lsl #26
    8c18:	e1500c81 	cmp	r0, r1, lsl #25
    8c1c:	e0a22002 	adc	r2, r2, r2
    8c20:	20400c81 	subcs	r0, r0, r1, lsl #25
    8c24:	e1500c01 	cmp	r0, r1, lsl #24
    8c28:	e0a22002 	adc	r2, r2, r2
    8c2c:	20400c01 	subcs	r0, r0, r1, lsl #24
    8c30:	e1500b81 	cmp	r0, r1, lsl #23
    8c34:	e0a22002 	adc	r2, r2, r2
    8c38:	20400b81 	subcs	r0, r0, r1, lsl #23
    8c3c:	e1500b01 	cmp	r0, r1, lsl #22
    8c40:	e0a22002 	adc	r2, r2, r2
    8c44:	20400b01 	subcs	r0, r0, r1, lsl #22
    8c48:	e1500a81 	cmp	r0, r1, lsl #21
    8c4c:	e0a22002 	adc	r2, r2, r2
    8c50:	20400a81 	subcs	r0, r0, r1, lsl #21
    8c54:	e1500a01 	cmp	r0, r1, lsl #20
    8c58:	e0a22002 	adc	r2, r2, r2
    8c5c:	20400a01 	subcs	r0, r0, r1, lsl #20
    8c60:	e1500981 	cmp	r0, r1, lsl #19
    8c64:	e0a22002 	adc	r2, r2, r2
    8c68:	20400981 	subcs	r0, r0, r1, lsl #19
    8c6c:	e1500901 	cmp	r0, r1, lsl #18
    8c70:	e0a22002 	adc	r2, r2, r2
    8c74:	20400901 	subcs	r0, r0, r1, lsl #18
    8c78:	e1500881 	cmp	r0, r1, lsl #17
    8c7c:	e0a22002 	adc	r2, r2, r2
    8c80:	20400881 	subcs	r0, r0, r1, lsl #17
    8c84:	e1500801 	cmp	r0, r1, lsl #16
    8c88:	e0a22002 	adc	r2, r2, r2
    8c8c:	20400801 	subcs	r0, r0, r1, lsl #16
    8c90:	e1500781 	cmp	r0, r1, lsl #15
    8c94:	e0a22002 	adc	r2, r2, r2
    8c98:	20400781 	subcs	r0, r0, r1, lsl #15
    8c9c:	e1500701 	cmp	r0, r1, lsl #14
    8ca0:	e0a22002 	adc	r2, r2, r2
    8ca4:	20400701 	subcs	r0, r0, r1, lsl #14
    8ca8:	e1500681 	cmp	r0, r1, lsl #13
    8cac:	e0a22002 	adc	r2, r2, r2
    8cb0:	20400681 	subcs	r0, r0, r1, lsl #13
    8cb4:	e1500601 	cmp	r0, r1, lsl #12
    8cb8:	e0a22002 	adc	r2, r2, r2
    8cbc:	20400601 	subcs	r0, r0, r1, lsl #12
    8cc0:	e1500581 	cmp	r0, r1, lsl #11
    8cc4:	e0a22002 	adc	r2, r2, r2
    8cc8:	20400581 	subcs	r0, r0, r1, lsl #11
    8ccc:	e1500501 	cmp	r0, r1, lsl #10
    8cd0:	e0a22002 	adc	r2, r2, r2
    8cd4:	20400501 	subcs	r0, r0, r1, lsl #10
    8cd8:	e1500481 	cmp	r0, r1, lsl #9
    8cdc:	e0a22002 	adc	r2, r2, r2
    8ce0:	20400481 	subcs	r0, r0, r1, lsl #9
    8ce4:	e1500401 	cmp	r0, r1, lsl #8
    8ce8:	e0a22002 	adc	r2, r2, r2
    8cec:	20400401 	subcs	r0, r0, r1, lsl #8
    8cf0:	e1500381 	cmp	r0, r1, lsl #7
    8cf4:	e0a22002 	adc	r2, r2, r2
    8cf8:	20400381 	subcs	r0, r0, r1, lsl #7
    8cfc:	e1500301 	cmp	r0, r1, lsl #6
    8d00:	e0a22002 	adc	r2, r2, r2
    8d04:	20400301 	subcs	r0, r0, r1, lsl #6
    8d08:	e1500281 	cmp	r0, r1, lsl #5
    8d0c:	e0a22002 	adc	r2, r2, r2
    8d10:	20400281 	subcs	r0, r0, r1, lsl #5
    8d14:	e1500201 	cmp	r0, r1, lsl #4
    8d18:	e0a22002 	adc	r2, r2, r2
    8d1c:	20400201 	subcs	r0, r0, r1, lsl #4
    8d20:	e1500181 	cmp	r0, r1, lsl #3
    8d24:	e0a22002 	adc	r2, r2, r2
    8d28:	20400181 	subcs	r0, r0, r1, lsl #3
    8d2c:	e1500101 	cmp	r0, r1, lsl #2
    8d30:	e0a22002 	adc	r2, r2, r2
    8d34:	20400101 	subcs	r0, r0, r1, lsl #2
    8d38:	e1500081 	cmp	r0, r1, lsl #1
    8d3c:	e0a22002 	adc	r2, r2, r2
    8d40:	20400081 	subcs	r0, r0, r1, lsl #1
    8d44:	e1500001 	cmp	r0, r1
    8d48:	e0a22002 	adc	r2, r2, r2
    8d4c:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    8d50:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    8d54:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    8d58:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    8d5c:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    8d60:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1169
    8d64:	e16f2f11 	clz	r2, r1
    8d68:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1171
    8d6c:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1172
    8d70:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1176
    8d74:	e3500000 	cmp	r0, #0
    8d78:	13e00000 	mvnne	r0, #0
    8d7c:	ea000007 	b	8da0 <__aeabi_idiv0>

00008d80 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1207
    8d80:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1208
    8d84:	0afffffa 	beq	8d74 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1209
    8d88:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1210
    8d8c:	ebffff80 	bl	8b94 <__udivsi3>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1211
    8d90:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1212
    8d94:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1213
    8d98:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1214
    8d9c:	e12fff1e 	bx	lr

00008da0 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1512
    8da0:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00008da4 <_ZL13Lock_Unlocked>:
    8da4:	00000000 	andeq	r0, r0, r0

00008da8 <_ZL11Lock_Locked>:
    8da8:	00000001 	andeq	r0, r0, r1

00008dac <_ZL21MaxFSDriverNameLength>:
    8dac:	00000010 	andeq	r0, r0, r0, lsl r0

00008db0 <_ZL17MaxFilenameLength>:
    8db0:	00000010 	andeq	r0, r0, r0, lsl r0

00008db4 <_ZL13MaxPathLength>:
    8db4:	00000080 	andeq	r0, r0, r0, lsl #1

00008db8 <_ZL18NoFilesystemDriver>:
    8db8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008dbc <_ZL9NotifyAll>:
    8dbc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008dc0 <_ZL24Max_Process_Opened_Files>:
    8dc0:	00000010 	andeq	r0, r0, r0, lsl r0

00008dc4 <_ZL10Indefinite>:
    8dc4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008dc8 <_ZL18Deadline_Unchanged>:
    8dc8:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008dcc <_ZL14Invalid_Handle>:
    8dcc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008dd0 <_ZL13Lock_Unlocked>:
    8dd0:	00000000 	andeq	r0, r0, r0

00008dd4 <_ZL11Lock_Locked>:
    8dd4:	00000001 	andeq	r0, r0, r1

00008dd8 <_ZL21MaxFSDriverNameLength>:
    8dd8:	00000010 	andeq	r0, r0, r0, lsl r0

00008ddc <_ZL17MaxFilenameLength>:
    8ddc:	00000010 	andeq	r0, r0, r0, lsl r0

00008de0 <_ZL13MaxPathLength>:
    8de0:	00000080 	andeq	r0, r0, r0, lsl #1

00008de4 <_ZL18NoFilesystemDriver>:
    8de4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008de8 <_ZL9NotifyAll>:
    8de8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008dec <_ZL24Max_Process_Opened_Files>:
    8dec:	00000010 	andeq	r0, r0, r0, lsl r0

00008df0 <_ZL10Indefinite>:
    8df0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008df4 <_ZL18Deadline_Unchanged>:
    8df4:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008df8 <_ZL14Invalid_Handle>:
    8df8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008dfc <_ZL16Pipe_File_Prefix>:
    8dfc:	3a535953 	bcc	14df350 <__bss_end+0x14d6524>
    8e00:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    8e04:	0000002f 	andeq	r0, r0, pc, lsr #32

00008e08 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    8e08:	33323130 	teqcc	r2, #48, 2
    8e0c:	37363534 			; <UNDEFINED> instruction: 0x37363534
    8e10:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    8e14:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00008e1c <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1684a00>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x395f8>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3d20c>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c7ef8>
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
 130:	6b69746e 	blvs	1a5d2f0 <__bss_end+0x1a544c4>
 134:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
 138:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 13c:	4f54522d 	svcmi	0x0054522d
 140:	616d2d53 	cmnvs	sp, r3, asr sp
 144:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 148:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe21 <__bss_end+0xffff6ff5>
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
 180:	0a030000 	beq	c0188 <__bss_end+0xb735c>
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
 1d4:	6a0d05a1 	bvs	341860 <__bss_end+0x338a34>
 1d8:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
 1dc:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 1e0:	04020004 	streq	r0, [r2], #-4
 1e4:	0b058302 	bleq	160df4 <__bss_end+0x157fc8>
 1e8:	02040200 	andeq	r0, r4, #0, 4
 1ec:	0002054a 	andeq	r0, r2, sl, asr #10
 1f0:	2d020402 	cfstrscs	mvf0, [r2, #-8]
 1f4:	05850905 	streq	r0, [r5, #2309]	; 0x905
 1f8:	0a022f01 	beq	8be04 <__bss_end+0x82fd8>
 1fc:	c4010100 	strgt	r0, [r1], #-256	; 0xffffff00
 200:	03000001 	movweq	r0, #1
 204:	00019a00 	andeq	r9, r1, r0, lsl #20
 208:	fb010200 	blx	40a12 <__bss_end+0x37be6>
 20c:	01000d0e 	tsteq	r0, lr, lsl #26
 210:	00010101 	andeq	r0, r1, r1, lsl #2
 214:	00010000 	andeq	r0, r1, r0
 218:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 21c:	2f656d6f 	svccs	0x00656d6f
 220:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
 224:	642f6b69 	strtvs	r6, [pc], #-2921	; 22c <shift+0x22c>
 228:	4b2f7665 	blmi	bddbc4 <__bss_end+0xbd4d98>
 22c:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 230:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
 234:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
 238:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
 23c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 240:	752f7365 	strvc	r7, [pc, #-869]!	; fffffee3 <__bss_end+0xffff70b7>
 244:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 248:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 24c:	696e692f 	stmdbvs	lr!, {r0, r1, r2, r3, r5, r8, fp, sp, lr}^
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
 2ac:	6b69746e 	blvs	1a5d46c <__bss_end+0x1a54640>
 2b0:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
 2b4:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 2b8:	4f54522d 	svcmi	0x0054522d
 2bc:	616d2d53 	cmnvs	sp, r3, asr sp
 2c0:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 2c4:	756f732f 	strbvc	r7, [pc, #-815]!	; ffffff9d <__bss_end+0xffff7171>
 2c8:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 2cc:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 2d0:	61707372 	cmnvs	r0, r2, ror r3
 2d4:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
 2d8:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
 2dc:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 2e0:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 2e4:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 2e8:	0073662f 	rsbseq	r6, r3, pc, lsr #12
 2ec:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 238 <shift+0x238>
 2f0:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 2f4:	6b69746e 	blvs	1a5d4b4 <__bss_end+0x1a54688>
 2f8:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
 2fc:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
 300:	4f54522d 	svcmi	0x0054522d
 304:	616d2d53 	cmnvs	sp, r3, asr sp
 308:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
 30c:	756f732f 	strbvc	r7, [pc, #-815]!	; ffffffe5 <__bss_end+0xffff71b9>
 310:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 314:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 318:	61707372 	cmnvs	r0, r2, ror r3
 31c:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
 320:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
 324:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 328:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 32c:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 330:	616f622f 	cmnvs	pc, pc, lsr #4
 334:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
 338:	2f306970 	svccs	0x00306970
 33c:	006c6168 	rsbeq	r6, ip, r8, ror #2
 340:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
 344:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 348:	00010070 	andeq	r0, r1, r0, ror r0
 34c:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 350:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 354:	70730000 	rsbsvc	r0, r3, r0
 358:	6f6c6e69 	svcvs	0x006c6e69
 35c:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 360:	00000200 	andeq	r0, r0, r0, lsl #4
 364:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 368:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 36c:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 370:	00000300 	andeq	r0, r0, r0, lsl #6
 374:	636f7270 	cmnvs	pc, #112, 4
 378:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 37c:	00020068 	andeq	r0, r2, r8, rrx
 380:	6f727000 	svcvs	0x00727000
 384:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 388:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 38c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 390:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 394:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 398:	66656474 			; <UNDEFINED> instruction: 0x66656474
 39c:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 3a0:	05000000 	streq	r0, [r0, #-0]
 3a4:	02050001 	andeq	r0, r5, #1
 3a8:	00008234 	andeq	r8, r0, r4, lsr r2
 3ac:	a3130517 	tstge	r3, #96468992	; 0x5c00000
 3b0:	05511f05 	ldrbeq	r1, [r1, #-3845]	; 0xfffff0fb
 3b4:	03054a22 	movweq	r4, #23074	; 0x5a22
 3b8:	4b170582 	blmi	5c19c8 <__bss_end+0x5b8b9c>
 3bc:	05310e05 	ldreq	r0, [r1, #-3589]!	; 0xfffff1fb
 3c0:	02022a03 	andeq	r2, r2, #12288	; 0x3000
 3c4:	a3010100 	movwge	r0, #4352	; 0x1100
 3c8:	03000002 	movweq	r0, #2
 3cc:	00016d00 	andeq	r6, r1, r0, lsl #26
 3d0:	fb010200 	blx	40bda <__bss_end+0x37dae>
 3d4:	01000d0e 	tsteq	r0, lr, lsl #26
 3d8:	00010101 	andeq	r0, r1, r1, lsl #2
 3dc:	00010000 	andeq	r0, r1, r0
 3e0:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 3e4:	2f656d6f 	svccs	0x00656d6f
 3e8:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
 3ec:	642f6b69 	strtvs	r6, [pc], #-2921	; 3f4 <shift+0x3f4>
 3f0:	4b2f7665 	blmi	bddd8c <__bss_end+0xbd4f60>
 3f4:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 3f8:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
 3fc:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
 400:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
 404:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 408:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
 40c:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 410:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
 414:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
 418:	2f656d6f 	svccs	0x00656d6f
 41c:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
 420:	642f6b69 	strtvs	r6, [pc], #-2921	; 428 <shift+0x428>
 424:	4b2f7665 	blmi	bdddc0 <__bss_end+0xbd4f94>
 428:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 42c:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
 430:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
 434:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
 438:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 43c:	6b2f7365 	blvs	bdd1d8 <__bss_end+0xbd43ac>
 440:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 444:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 448:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 44c:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
 450:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 454:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 458:	2f656d6f 	svccs	0x00656d6f
 45c:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
 460:	642f6b69 	strtvs	r6, [pc], #-2921	; 468 <shift+0x468>
 464:	4b2f7665 	blmi	bdde00 <__bss_end+0xbd4fd4>
 468:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
 46c:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
 470:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
 474:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
 478:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 47c:	6b2f7365 	blvs	bdd218 <__bss_end+0xbd43ec>
 480:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 484:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 488:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 48c:	73662f65 	cmnvc	r6, #404	; 0x194
 490:	6f682f00 	svcvs	0x00682f00
 494:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
 498:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
 49c:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
 4a0:	494b2f76 	stmdbmi	fp, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
 4a4:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
 4a8:	6d2d534f 	stcvs	3, cr5, [sp, #-316]!	; 0xfffffec4
 4ac:	65747361 	ldrbvs	r7, [r4, #-865]!	; 0xfffffc9f
 4b0:	6f732f72 	svcvs	0x00732f72
 4b4:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 4b8:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
 4bc:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 4c0:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 4c4:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 4c8:	616f622f 	cmnvs	pc, pc, lsr #4
 4cc:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
 4d0:	2f306970 	svccs	0x00306970
 4d4:	006c6168 	rsbeq	r6, ip, r8, ror #2
 4d8:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 4dc:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 4e0:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 4e4:	00000100 	andeq	r0, r0, r0, lsl #2
 4e8:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
 4ec:	00020068 	andeq	r0, r2, r8, rrx
 4f0:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
 4f4:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
 4f8:	00682e6b 	rsbeq	r2, r8, fp, ror #28
 4fc:	66000002 	strvs	r0, [r0], -r2
 500:	73656c69 	cmnvc	r5, #26880	; 0x6900
 504:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 508:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 50c:	70000003 	andvc	r0, r0, r3
 510:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 514:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
 518:	00000200 	andeq	r0, r0, r0, lsl #4
 51c:	636f7270 	cmnvs	pc, #112, 4
 520:	5f737365 	svcpl	0x00737365
 524:	616e616d 	cmnvs	lr, sp, ror #2
 528:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
 52c:	00020068 	andeq	r0, r2, r8, rrx
 530:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 534:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 538:	00040068 	andeq	r0, r4, r8, rrx
 53c:	01050000 	mrseq	r0, (UNDEF: 5)
 540:	7c020500 	cfstr32vc	mvfx0, [r2], {-0}
 544:	16000082 	strne	r0, [r0], -r2, lsl #1
 548:	05691a05 	strbeq	r1, [r9, #-2565]!	; 0xfffff5fb
 54c:	0c052f2c 	stceq	15, cr2, [r5], {44}	; 0x2c
 550:	2f01054c 	svccs	0x0001054c
 554:	83320585 	teqhi	r2, #557842432	; 0x21400000
 558:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 55c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 560:	01054b1a 	tsteq	r5, sl, lsl fp
 564:	3205852f 	andcc	r8, r5, #197132288	; 0xbc00000
 568:	4b2e05a1 	blmi	b81bf4 <__bss_end+0xb78dc8>
 56c:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 570:	0c052f2d 	stceq	15, cr2, [r5], {45}	; 0x2d
 574:	2f01054c 	svccs	0x0001054c
 578:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 57c:	054b3005 	strbeq	r3, [fp, #-5]
 580:	1b054b2e 	blne	153240 <__bss_end+0x14a414>
 584:	2f2e054b 	svccs	0x002e054b
 588:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 58c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 590:	3005bd2e 	andcc	fp, r5, lr, lsr #26
 594:	4b2e054b 	blmi	b81ac8 <__bss_end+0xb78c9c>
 598:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 59c:	0c052f2e 	stceq	15, cr2, [r5], {46}	; 0x2e
 5a0:	2f01054c 	svccs	0x0001054c
 5a4:	832e0585 			; <UNDEFINED> instruction: 0x832e0585
 5a8:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 5ac:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 5b0:	3305bd2e 	movwcc	fp, #23854	; 0x5d2e
 5b4:	4b2f054b 	blmi	bc1ae8 <__bss_end+0xbb8cbc>
 5b8:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 5bc:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
 5c0:	2f01054c 	svccs	0x0001054c
 5c4:	a12e0585 	smlawbge	lr, r5, r5, r0
 5c8:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
 5cc:	2f054b1b 	svccs	0x00054b1b
 5d0:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 5d4:	852f0105 	strhi	r0, [pc, #-261]!	; 4d7 <shift+0x4d7>
 5d8:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
 5dc:	3b054b2f 	blcc	1532a0 <__bss_end+0x14a474>
 5e0:	4b1b054b 	blmi	6c1b14 <__bss_end+0x6b8ce8>
 5e4:	052f3005 	streq	r3, [pc, #-5]!	; 5e7 <shift+0x5e7>
 5e8:	01054c0c 	tsteq	r5, ip, lsl #24
 5ec:	2f05852f 	svccs	0x0005852f
 5f0:	4b3b05a1 	blmi	ec1c7c <__bss_end+0xeb8e50>
 5f4:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 5f8:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
 5fc:	9f01054c 	svcls	0x0001054c
 600:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 604:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
 608:	1a054b31 	bne	1532d4 <__bss_end+0x14a4a8>
 60c:	300c054b 	andcc	r0, ip, fp, asr #10
 610:	852f0105 	strhi	r0, [pc, #-261]!	; 513 <shift+0x513>
 614:	05672005 	strbeq	r2, [r7, #-5]!
 618:	31054d2d 	tstcc	r5, sp, lsr #26
 61c:	4b1a054b 	blmi	681b50 <__bss_end+0x678d24>
 620:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 624:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 628:	2d058320 	stccs	3, cr8, [r5, #-128]	; 0xffffff80
 62c:	4b3e054c 	blmi	f81b64 <__bss_end+0xf78d38>
 630:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 634:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 638:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
 63c:	4b30054d 	blmi	c01b78 <__bss_end+0xbf8d4c>
 640:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 644:	0105300c 	tsteq	r5, ip
 648:	0c05872f 	stceq	7, cr8, [r5], {47}	; 0x2f
 64c:	31059fa0 	smlatbcc	r5, r0, pc, r9	; <UNPREDICTABLE>
 650:	662905bc 			; <UNDEFINED> instruction: 0x662905bc
 654:	052e3605 	streq	r3, [lr, #-1541]!	; 0xfffff9fb
 658:	1305300f 	movwne	r3, #20495	; 0x500f
 65c:	84090566 	strhi	r0, [r9], #-1382	; 0xfffffa9a
 660:	05d81005 	ldrbeq	r1, [r8, #5]
 664:	01059e33 	tsteq	r5, r3, lsr lr
 668:	0008022f 	andeq	r0, r8, pc, lsr #4
 66c:	02320101 	eorseq	r0, r2, #1073741824	; 0x40000000
 670:	00030000 	andeq	r0, r3, r0
 674:	00000058 	andeq	r0, r0, r8, asr r0
 678:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 67c:	0101000d 	tsteq	r1, sp
 680:	00000101 	andeq	r0, r0, r1, lsl #2
 684:	00000100 	andeq	r0, r0, r0, lsl #2
 688:	6f682f01 	svcvs	0x00682f01
 68c:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
 690:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
 694:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
 698:	494b2f76 	stmdbmi	fp, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
 69c:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
 6a0:	6d2d534f 	stcvs	3, cr5, [sp, #-316]!	; 0xfffffec4
 6a4:	65747361 	ldrbvs	r7, [r4, #-865]!	; 0xfffffc9f
 6a8:	6f732f72 	svcvs	0x00732f72
 6ac:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 6b0:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
 6b4:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
 6b8:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 6bc:	74730000 	ldrbtvc	r0, [r3], #-0
 6c0:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
 6c4:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
 6c8:	00707063 	rsbseq	r7, r0, r3, rrx
 6cc:	00000001 	andeq	r0, r0, r1
 6d0:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 6d4:	0086dc02 	addeq	sp, r6, r2, lsl #24
 6d8:	06051a00 	streq	r1, [r5], -r0, lsl #20
 6dc:	4c0f05bb 	cfstr32mi	mvfx0, [pc], {187}	; 0xbb
 6e0:	05682105 	strbeq	r2, [r8, #-261]!	; 0xfffffefb
 6e4:	2705ba0b 	strcs	fp, [r5, -fp, lsl #20]
 6e8:	4a0d0566 	bmi	341c88 <__bss_end+0x338e5c>
 6ec:	052f0905 	streq	r0, [pc, #-2309]!	; fffffdef <__bss_end+0xffff6fc3>
 6f0:	02059f04 	andeq	r9, r5, #4, 30
 6f4:	35050562 	strcc	r0, [r5, #-1378]	; 0xfffffa9e
 6f8:	05681105 	strbeq	r1, [r8, #-261]!	; 0xfffffefb
 6fc:	13056622 	movwne	r6, #22050	; 0x5622
 700:	2f0a052e 	svccs	0x000a052e
 704:	660c0569 	strvs	r0, [ip], -r9, ror #10
 708:	054b0305 	strbeq	r0, [fp, #-773]	; 0xfffffcfb
 70c:	1805680b 	stmdane	r5, {r0, r1, r3, fp, sp, lr}
 710:	03040200 	movweq	r0, #16896	; 0x4200
 714:	0014054a 	andseq	r0, r4, sl, asr #10
 718:	9e030402 	cdpls	4, 0, cr0, cr3, cr2, {0}
 71c:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
 720:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
 724:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 728:	08058202 	stmdaeq	r5, {r1, r9, pc}
 72c:	02040200 	andeq	r0, r4, #0, 4
 730:	001b054a 	andseq	r0, fp, sl, asr #10
 734:	4b020402 	blmi	81744 <__bss_end+0x78918>
 738:	02000c05 	andeq	r0, r0, #1280	; 0x500
 73c:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 740:	0402000f 	streq	r0, [r2], #-15
 744:	1b058202 	blne	160f54 <__bss_end+0x158128>
 748:	02040200 	andeq	r0, r4, #0, 4
 74c:	0011054a 	andseq	r0, r1, sl, asr #10
 750:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 754:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 758:	052f0204 	streq	r0, [pc, #-516]!	; 55c <shift+0x55c>
 75c:	0402000d 	streq	r0, [r2], #-13
 760:	02056602 	andeq	r6, r5, #2097152	; 0x200000
 764:	02040200 	andeq	r0, r4, #0, 4
 768:	88010546 	stmdahi	r1, {r1, r2, r6, r8, sl}
 76c:	83060585 	movwhi	r0, #25989	; 0x6585
 770:	054c0905 	strbeq	r0, [ip, #-2309]	; 0xfffff6fb
 774:	0a054a10 	beq	152fbc <__bss_end+0x14a190>
 778:	bb07054c 	bllt	1c1cb0 <__bss_end+0x1b8e84>
 77c:	054a0305 	strbeq	r0, [sl, #-773]	; 0xfffffcfb
 780:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 784:	14054a01 	strne	r4, [r5], #-2561	; 0xfffff5ff
 788:	01040200 	mrseq	r0, R12_usr
 78c:	4d0d054a 	cfstr32mi	mvfx0, [sp, #-296]	; 0xfffffed8
 790:	054a1405 	strbeq	r1, [sl, #-1029]	; 0xfffffbfb
 794:	08052e0a 	stmdaeq	r5, {r1, r3, r9, sl, fp, sp}
 798:	03020568 	movweq	r0, #9576	; 0x2568
 79c:	09056678 	stmdbeq	r5, {r3, r4, r5, r6, r9, sl, sp, lr}
 7a0:	052e0b03 	streq	r0, [lr, #-2819]!	; 0xfffff4fd
 7a4:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 7a8:	1605bd09 	strne	fp, [r5], -r9, lsl #26
 7ac:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 7b0:	001e054a 	andseq	r0, lr, sl, asr #10
 7b4:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 7b8:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 7bc:	05820204 	streq	r0, [r2, #516]	; 0x204
 7c0:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 7c4:	09054b03 	stmdbeq	r5, {r0, r1, r8, r9, fp, lr}
 7c8:	03040200 	movweq	r0, #16896	; 0x4200
 7cc:	00120566 	andseq	r0, r2, r6, ror #10
 7d0:	66030402 	strvs	r0, [r3], -r2, lsl #8
 7d4:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 7d8:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 7dc:	04020002 	streq	r0, [r2], #-2
 7e0:	0b052d03 	bleq	14bbf4 <__bss_end+0x142dc8>
 7e4:	02040200 	andeq	r0, r4, #0, 4
 7e8:	00090584 	andeq	r0, r9, r4, lsl #11
 7ec:	83010402 	movwhi	r0, #5122	; 0x1402
 7f0:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 7f4:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
 7f8:	04020002 	streq	r0, [r2], #-2
 7fc:	0b054901 	bleq	152c08 <__bss_end+0x149ddc>
 800:	2f010585 	svccs	0x00010585
 804:	bc0e0585 	cfstr32lt	mvfx0, [lr], {133}	; 0x85
 808:	05661105 	strbeq	r1, [r6, #-261]!	; 0xfffffefb
 80c:	0b05bc20 	bleq	16f894 <__bss_end+0x166a68>
 810:	4b1f0566 	blmi	7c1db0 <__bss_end+0x7b8f84>
 814:	05660a05 	strbeq	r0, [r6, #-2565]!	; 0xfffff5fb
 818:	14054b08 	strne	r4, [r5], #-2824	; 0xfffff4f8
 81c:	4a160583 	bmi	581e30 <__bss_end+0x579004>
 820:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
 824:	0b056711 	bleq	15a470 <__bss_end+0x151644>
 828:	2f01054d 	svccs	0x0001054d
 82c:	83060585 	movwhi	r0, #25989	; 0x6585
 830:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 834:	0405820e 	streq	r8, [r5], #-526	; 0xfffffdf2
 838:	6502054b 	strvs	r0, [r2, #-1355]	; 0xfffffab5
 83c:	05310905 	ldreq	r0, [r1, #-2309]!	; 0xfffff6fb
 840:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 844:	0b059f08 	bleq	16846c <__bss_end+0x15f640>
 848:	0014054c 	andseq	r0, r4, ip, asr #10
 84c:	4a030402 	bmi	c185c <__bss_end+0xb8a30>
 850:	02000805 	andeq	r0, r0, #327680	; 0x50000
 854:	05830204 	streq	r0, [r3, #516]	; 0x204
 858:	0402000a 	streq	r0, [r2], #-10
 85c:	02056602 	andeq	r6, r5, #2097152	; 0x200000
 860:	02040200 	andeq	r0, r4, #0, 4
 864:	84010549 	strhi	r0, [r1], #-1353	; 0xfffffab7
 868:	bb0e0585 	bllt	381e84 <__bss_end+0x379058>
 86c:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
 870:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
 874:	03040200 	movweq	r0, #16896	; 0x4200
 878:	0017054a 	andseq	r0, r7, sl, asr #10
 87c:	83020402 	movwhi	r0, #9218	; 0x2402
 880:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 884:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 888:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 88c:	0d056602 	stceq	6, cr6, [r5, #-8]
 890:	02040200 	andeq	r0, r4, #0, 4
 894:	0002052e 	andeq	r0, r2, lr, lsr #10
 898:	2d020402 	cfstrscs	mvf0, [r2, #-8]
 89c:	02840105 	addeq	r0, r4, #1073741825	; 0x40000001
 8a0:	01010008 	tsteq	r1, r8
 8a4:	00000079 	andeq	r0, r0, r9, ror r0
 8a8:	00460003 	subeq	r0, r6, r3
 8ac:	01020000 	mrseq	r0, (UNDEF: 2)
 8b0:	000d0efb 	strdeq	r0, [sp], -fp
 8b4:	01010101 	tsteq	r1, r1, lsl #2
 8b8:	01000000 	mrseq	r0, (UNDEF: 0)
 8bc:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 8c0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 8c4:	2f2e2e2f 	svccs	0x002e2e2f
 8c8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 8cc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 8d0:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 8d4:	2f636367 	svccs	0x00636367
 8d8:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 8dc:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 8e0:	00006d72 	andeq	r6, r0, r2, ror sp
 8e4:	3162696c 	cmncc	r2, ip, ror #18
 8e8:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
 8ec:	00532e73 	subseq	r2, r3, r3, ror lr
 8f0:	00000001 	andeq	r0, r0, r1
 8f4:	94020500 	strls	r0, [r2], #-1280	; 0xfffffb00
 8f8:	0300008b 	movweq	r0, #139	; 0x8b
 8fc:	300108fd 	strdcc	r0, [r1], -sp
 900:	2f2f2f2f 	svccs	0x002f2f2f
 904:	d002302f 	andle	r3, r2, pc, lsr #32
 908:	312f1401 			; <UNDEFINED> instruction: 0x312f1401
 90c:	4c302f2f 	ldcmi	15, cr2, [r0], #-188	; 0xffffff44
 910:	1f03322f 	svcne	0x0003322f
 914:	2f2f2f66 	svccs	0x002f2f66
 918:	2f2f2f2f 	svccs	0x002f2f2f
 91c:	01000202 	tsteq	r0, r2, lsl #4
 920:	00005c01 	andeq	r5, r0, r1, lsl #24
 924:	46000300 	strmi	r0, [r0], -r0, lsl #6
 928:	02000000 	andeq	r0, r0, #0
 92c:	0d0efb01 	vstreq	d15, [lr, #-4]
 930:	01010100 	mrseq	r0, (UNDEF: 17)
 934:	00000001 	andeq	r0, r0, r1
 938:	01000001 	tsteq	r0, r1
 93c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 940:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 944:	2f2e2e2f 	svccs	0x002e2e2f
 948:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 94c:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 950:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 954:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
 958:	2f676966 	svccs	0x00676966
 95c:	006d7261 	rsbeq	r7, sp, r1, ror #4
 960:	62696c00 	rsbvs	r6, r9, #0, 24
 964:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
 968:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
 96c:	00000100 	andeq	r0, r0, r0, lsl #2
 970:	02050000 	andeq	r0, r5, #0
 974:	00008da0 	andeq	r8, r0, r0, lsr #27
 978:	010be703 	tsteq	fp, r3, lsl #14
 97c:	01000202 	tsteq	r0, r2, lsl #4
 980:	00010301 	andeq	r0, r1, r1, lsl #6
 984:	fd000300 	stc2	3, cr0, [r0, #-0]
 988:	02000000 	andeq	r0, r0, #0
 98c:	0d0efb01 	vstreq	d15, [lr, #-4]
 990:	01010100 	mrseq	r0, (UNDEF: 17)
 994:	00000001 	andeq	r0, r0, r1
 998:	01000001 	tsteq	r0, r1
 99c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 9a0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 9a4:	2f2e2e2f 	svccs	0x002e2e2f
 9a8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 9ac:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 9b0:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 9b4:	2f2e2e2f 	svccs	0x002e2e2f
 9b8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 9bc:	00656475 	rsbeq	r6, r5, r5, ror r4
 9c0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 9c4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 9c8:	2f2e2e2f 	svccs	0x002e2e2f
 9cc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 9d0:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
 9d4:	2f2e2e00 	svccs	0x002e2e00
 9d8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 9dc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 9e0:	2f2e2e2f 	svccs	0x002e2e2f
 9e4:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 934 <shift+0x934>
 9e8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 9ec:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
 9f0:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
 9f4:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
 9f8:	2f676966 	svccs	0x00676966
 9fc:	006d7261 	rsbeq	r7, sp, r1, ror #4
 a00:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a04:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a08:	2f2e2e2f 	svccs	0x002e2e2f
 a0c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a10:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 a14:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 a18:	61680000 	cmnvs	r8, r0
 a1c:	61746873 	cmnvs	r4, r3, ror r8
 a20:	00682e62 	rsbeq	r2, r8, r2, ror #28
 a24:	61000001 	tstvs	r0, r1
 a28:	692d6d72 	pushvs	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
 a2c:	682e6173 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, sp, lr}
 a30:	00000200 	andeq	r0, r0, r0, lsl #4
 a34:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 a38:	2e757063 	cdpcs	0, 7, cr7, cr5, cr3, {3}
 a3c:	00020068 	andeq	r0, r2, r8, rrx
 a40:	736e6900 	cmnvc	lr, #0, 18
 a44:	6f632d6e 	svcvs	0x00632d6e
 a48:	6174736e 	cmnvs	r4, lr, ror #6
 a4c:	2e73746e 	cdpcs	4, 7, cr7, cr3, cr14, {3}
 a50:	00020068 	andeq	r0, r2, r8, rrx
 a54:	6d726100 	ldfvse	f6, [r2, #-0]
 a58:	0300682e 	movweq	r6, #2094	; 0x82e
 a5c:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 a60:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 a64:	00682e32 	rsbeq	r2, r8, r2, lsr lr
 a68:	67000004 	strvs	r0, [r0, -r4]
 a6c:	632d6c62 			; <UNDEFINED> instruction: 0x632d6c62
 a70:	73726f74 	cmnvc	r2, #116, 30	; 0x1d0
 a74:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 a78:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 a7c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 a80:	00632e32 	rsbeq	r2, r3, r2, lsr lr
 a84:	00000004 	andeq	r0, r0, r4

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
      58:	16b60704 	ldrtne	r0, [r6], r4, lsl #14
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
      b0:	0b010000 	bleq	400b8 <__bss_end+0x3728c>
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
     11c:	16b60704 	ldrtne	r0, [r6], r4, lsl #14
     120:	7a080000 	bvc	200128 <__bss_end+0x1f72fc>
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
     15c:	3a010000 	bcc	40164 <__bss_end+0x37338>
     160:	00007615 	andeq	r7, r0, r5, lsl r6
     164:	01dc0900 	bicseq	r0, ip, r0, lsl #18
     168:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
     16c:	0000cb10 	andeq	ip, r0, r0, lsl fp
     170:	0081dc00 	addeq	sp, r1, r0, lsl #24
     174:	00005800 	andeq	r5, r0, r0, lsl #16
     178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f7754>
     17c:	0a000000 	beq	184 <shift+0x184>
     180:	000001ea 	andeq	r0, r0, sl, ror #3
     184:	d20c4a01 	andle	r4, ip, #4096	; 0x1000
     188:	02000000 	andeq	r0, r0, #0
     18c:	0b007491 	bleq	1d3d8 <__bss_end+0x145ac>
     190:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     194:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
     198:	00000038 	andeq	r0, r0, r8, lsr r0
     19c:	00036d09 	andeq	r6, r3, r9, lsl #26
     1a0:	103c0100 	eorsne	r0, ip, r0, lsl #2
     1a4:	000000cb 	andeq	r0, r0, fp, asr #1
     1a8:	00008184 	andeq	r8, r0, r4, lsl #3
     1ac:	00000058 	andeq	r0, r0, r8, asr r0
     1b0:	01029c01 	tsteq	r2, r1, lsl #24
     1b4:	ea0a0000 	b	2801bc <__bss_end+0x277390>
     1b8:	01000001 	tsteq	r0, r1
     1bc:	01020c3e 	tsteq	r2, lr, lsr ip
     1c0:	91020000 	mrsls	r0, (UNDEF: 2)
     1c4:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
     1c8:	00000025 	andeq	r0, r0, r5, lsr #32
     1cc:	0001c50c 	andeq	ip, r1, ip, lsl #10
     1d0:	11290100 			; <UNDEFINED> instruction: 0x11290100
     1d4:	00008178 	andeq	r8, r0, r8, ror r1
     1d8:	0000000c 	andeq	r0, r0, ip
     1dc:	fb0c9c01 	blx	3271ea <__bss_end+0x31e3be>
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
     254:	cb110a01 	blgt	442a60 <__bss_end+0x439c34>
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
     2bc:	0a010067 	beq	40460 <__bss_end+0x37634>
     2c0:	00019e2f 	andeq	r9, r1, pc, lsr #28
     2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     2c8:	08360000 	ldmdaeq	r6!, {}	; <UNPREDICTABLE>
     2cc:	00040000 	andeq	r0, r4, r0
     2d0:	000001c6 	andeq	r0, r0, r6, asr #3
     2d4:	02650104 	rsbeq	r0, r5, #4, 2
     2d8:	8f040000 	svchi	0x00040000
     2dc:	3a000004 	bcc	2f4 <shift+0x2f4>
     2e0:	34000000 	strcc	r0, [r0], #-0
     2e4:	48000082 	stmdami	r0, {r1, r7}
     2e8:	ff000000 			; <UNDEFINED> instruction: 0xff000000
     2ec:	02000001 	andeq	r0, r0, #1
     2f0:	07a10801 	streq	r0, [r1, r1, lsl #16]!
     2f4:	25030000 	strcs	r0, [r3, #-0]
     2f8:	02000000 	andeq	r0, r0, #0
     2fc:	04700502 	ldrbteq	r0, [r0], #-1282	; 0xfffffafe
     300:	04040000 	streq	r0, [r4], #-0
     304:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     308:	08010200 	stmdaeq	r1, {r9}
     30c:	00000798 	muleq	r0, r8, r7
     310:	9d070202 	sfmls	f0, 4, [r7, #-8]
     314:	05000008 	streq	r0, [r0, #-8]
     318:	000007e1 	andeq	r0, r0, r1, ror #15
     31c:	5e1e0907 	vnmlspl.f16	s0, s28, s14	; <UNPREDICTABLE>
     320:	03000000 	movweq	r0, #0
     324:	0000004d 	andeq	r0, r0, sp, asr #32
     328:	b6070402 	strlt	r0, [r7], -r2, lsl #8
     32c:	06000016 			; <UNDEFINED> instruction: 0x06000016
     330:	00000a7b 	andeq	r0, r0, fp, ror sl
     334:	08060208 	stmdaeq	r6, {r3, r9}
     338:	0000008b 	andeq	r0, r0, fp, lsl #1
     33c:	00307207 	eorseq	r7, r0, r7, lsl #4
     340:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
     344:	00000000 	andeq	r0, r0, r0
     348:	00317207 	eorseq	r7, r1, r7, lsl #4
     34c:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
     350:	04000000 	streq	r0, [r0], #-0
     354:	047a0800 	ldrbteq	r0, [sl], #-2048	; 0xfffff800
     358:	04050000 	streq	r0, [r5], #-0
     35c:	00000038 	andeq	r0, r0, r8, lsr r0
     360:	c20c1e02 	andgt	r1, ip, #2, 28
     364:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     368:	00000527 	andeq	r0, r0, r7, lsr #10
     36c:	0b700900 	bleq	1c02774 <__bss_end+0x1bf9948>
     370:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     374:	000003f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     378:	07020902 	streq	r0, [r2, -r2, lsl #18]
     37c:	09030000 	stmdbeq	r3, {}	; <UNPREDICTABLE>
     380:	00000b61 	andeq	r0, r0, r1, ror #22
     384:	06810904 	streq	r0, [r1], r4, lsl #18
     388:	00050000 	andeq	r0, r5, r0
     38c:	00044d08 	andeq	r4, r4, r8, lsl #26
     390:	38040500 	stmdacc	r4, {r8, sl}
     394:	02000000 	andeq	r0, r0, #0
     398:	00ff0c3f 	rscseq	r0, pc, pc, lsr ip	; <UNPREDICTABLE>
     39c:	52090000 	andpl	r0, r9, #0
     3a0:	00000008 	andeq	r0, r0, r8
     3a4:	0007dc09 	andeq	sp, r7, r9, lsl #24
     3a8:	ca090100 	bgt	2407b0 <__bss_end+0x237984>
     3ac:	02000007 	andeq	r0, r0, #7
     3b0:	000a2909 	andeq	r2, sl, r9, lsl #18
     3b4:	cb090300 	blgt	240fbc <__bss_end+0x238190>
     3b8:	04000009 	streq	r0, [r0], #-9
     3bc:	000aa409 	andeq	sl, sl, r9, lsl #8
     3c0:	93090500 	movwls	r0, #38144	; 0x9500
     3c4:	06000007 	streq	r0, [r0], -r7
     3c8:	06a70a00 	strteq	r0, [r7], r0, lsl #20
     3cc:	05030000 	streq	r0, [r3, #-0]
     3d0:	00005914 	andeq	r5, r0, r4, lsl r9
     3d4:	a4030500 	strge	r0, [r3], #-1280	; 0xfffffb00
     3d8:	0a00008d 	beq	614 <shift+0x614>
     3dc:	00000a87 	andeq	r0, r0, r7, lsl #21
     3e0:	59140603 	ldmdbpl	r4, {r0, r1, r9, sl}
     3e4:	05000000 	streq	r0, [r0, #-0]
     3e8:	008da803 	addeq	sl, sp, r3, lsl #16
     3ec:	060b0a00 	streq	r0, [fp], -r0, lsl #20
     3f0:	07040000 	streq	r0, [r4, -r0]
     3f4:	0000591a 	andeq	r5, r0, sl, lsl r9
     3f8:	ac030500 	cfstr32ge	mvfx0, [r3], {-0}
     3fc:	0a00008d 	beq	638 <shift+0x638>
     400:	000006c3 	andeq	r0, r0, r3, asr #13
     404:	591a0904 	ldmdbpl	sl, {r2, r8, fp}
     408:	05000000 	streq	r0, [r0, #-0]
     40c:	008db003 	addeq	fp, sp, r3
     410:	09310a00 	ldmdbeq	r1!, {r9, fp}
     414:	0b040000 	bleq	10041c <__bss_end+0xf75f0>
     418:	0000591a 	andeq	r5, r0, sl, lsl r9
     41c:	b4030500 	strlt	r0, [r3], #-1280	; 0xfffffb00
     420:	0a00008d 	beq	65c <shift+0x65c>
     424:	00000aab 	andeq	r0, r0, fp, lsr #21
     428:	591a0d04 	ldmdbpl	sl, {r2, r8, sl, fp}
     42c:	05000000 	streq	r0, [r0, #-0]
     430:	008db803 	addeq	fp, sp, r3, lsl #16
     434:	08ba0a00 	ldmeq	sl!, {r9, fp}
     438:	0f040000 	svceq	0x00040000
     43c:	0000591a 	andeq	r5, r0, sl, lsl r9
     440:	bc030500 	cfstr32lt	mvfx0, [r3], {-0}
     444:	0800008d 	stmdaeq	r0, {r0, r2, r3, r7}
     448:	00000805 	andeq	r0, r0, r5, lsl #16
     44c:	00380405 	eorseq	r0, r8, r5, lsl #8
     450:	1b040000 	blne	100458 <__bss_end+0xf762c>
     454:	0001a20c 	andeq	sl, r1, ip, lsl #4
     458:	08cc0900 	stmiaeq	ip, {r8, fp}^
     45c:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     460:	00000bf8 	strdeq	r0, [r0], -r8
     464:	07c50901 	strbeq	r0, [r5, r1, lsl #18]
     468:	00020000 	andeq	r0, r2, r0
     46c:	0008840b 	andeq	r8, r8, fp, lsl #8
     470:	06df0c00 	ldrbeq	r0, [pc], r0, lsl #24
     474:	04900000 	ldreq	r0, [r0], #0
     478:	03150763 	tsteq	r5, #25952256	; 0x18c0000
     47c:	b5060000 	strlt	r0, [r6, #-0]
     480:	24000006 	strcs	r0, [r0], #-6
     484:	2f106704 	svccs	0x00106704
     488:	0d000002 	stceq	0, cr0, [r0, #-8]
     48c:	00001a9e 	muleq	r0, lr, sl
     490:	15286904 	strne	r6, [r8, #-2308]!	; 0xfffff6fc
     494:	00000003 	andeq	r0, r0, r3
     498:	0005f50d 	andeq	pc, r5, sp, lsl #10
     49c:	206b0400 	rsbcs	r0, fp, r0, lsl #8
     4a0:	00000325 	andeq	r0, r0, r5, lsr #6
     4a4:	04010d10 	streq	r0, [r1], #-3344	; 0xfffff2f0
     4a8:	6d040000 	stcvs	0, cr0, [r4, #-0]
     4ac:	00004d23 	andeq	r4, r0, r3, lsr #26
     4b0:	a00d1400 	andge	r1, sp, r0, lsl #8
     4b4:	04000006 	streq	r0, [r0], #-6
     4b8:	032c1c70 			; <UNDEFINED> instruction: 0x032c1c70
     4bc:	0d180000 	ldceq	0, cr0, [r8, #-0]
     4c0:	000006eb 	andeq	r0, r0, fp, ror #13
     4c4:	2c1c7204 	lfmcs	f7, 4, [ip], {4}
     4c8:	1c000003 	stcne	0, cr0, [r0], {3}
     4cc:	000c030d 	andeq	r0, ip, sp, lsl #6
     4d0:	1c750400 	cfldrdne	mvd0, [r5], #-0
     4d4:	0000032c 	andeq	r0, r0, ip, lsr #6
     4d8:	082b0e20 	stmdaeq	fp!, {r5, r9, sl, fp}
     4dc:	77040000 	strvc	r0, [r4, -r0]
     4e0:	000abe1c 	andeq	fp, sl, ip, lsl lr
     4e4:	00032c00 	andeq	r2, r3, r0, lsl #24
     4e8:	00022300 	andeq	r2, r2, r0, lsl #6
     4ec:	032c0f00 			; <UNDEFINED> instruction: 0x032c0f00
     4f0:	32100000 	andscc	r0, r0, #0
     4f4:	00000003 	andeq	r0, r0, r3
     4f8:	07a60600 	streq	r0, [r6, r0, lsl #12]!
     4fc:	04180000 	ldreq	r0, [r8], #-0
     500:	0264107b 	rsbeq	r1, r4, #123	; 0x7b
     504:	9e0d0000 	cdpls	0, 0, cr0, cr13, cr0, {0}
     508:	0400001a 	streq	r0, [r0], #-26	; 0xffffffe6
     50c:	03152c7e 	tsteq	r5, #32256	; 0x7e00
     510:	0d000000 	stceq	0, cr0, [r0, #-0]
     514:	00000465 	andeq	r0, r0, r5, ror #8
     518:	32198004 	andscc	r8, r9, #4
     51c:	10000003 	andne	r0, r0, r3
     520:	00084b0d 	andeq	r4, r8, sp, lsl #22
     524:	21820400 	orrcs	r0, r2, r0, lsl #8
     528:	0000033d 	andeq	r0, r0, sp, lsr r3
     52c:	2f030014 	svccs	0x00030014
     530:	11000002 	tstne	r0, r2
     534:	00000534 	andeq	r0, r0, r4, lsr r5
     538:	43218604 			; <UNDEFINED> instruction: 0x43218604
     53c:	11000003 	tstne	r0, r3
     540:	00000540 	andeq	r0, r0, r0, asr #10
     544:	591f8804 	ldmdbpl	pc, {r2, fp, pc}	; <UNPREDICTABLE>
     548:	0d000000 	stceq	0, cr0, [r0, #-0]
     54c:	000009d1 	ldrdeq	r0, [r0], -r1
     550:	b4178b04 	ldrlt	r8, [r7], #-2820	; 0xfffff4fc
     554:	00000001 	andeq	r0, r0, r1
     558:	00040c0d 	andeq	r0, r4, sp, lsl #24
     55c:	178e0400 	strne	r0, [lr, r0, lsl #8]
     560:	000001b4 			; <UNDEFINED> instruction: 0x000001b4
     564:	08b00d24 	ldmeq	r0!, {r2, r5, r8, sl, fp}
     568:	8f040000 	svchi	0x00040000
     56c:	0001b417 	andeq	fp, r1, r7, lsl r4
     570:	410d4800 	tstmi	sp, r0, lsl #16
     574:	04000008 	streq	r0, [r0], #-8
     578:	01b41790 			; <UNDEFINED> instruction: 0x01b41790
     57c:	126c0000 	rsbne	r0, ip, #0
     580:	000006df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     584:	01099304 	tsteq	r9, r4, lsl #6
     588:	4e00000b 	cdpmi	0, 0, cr0, cr0, cr11, {0}
     58c:	01000003 	tsteq	r0, r3
     590:	000002ce 	andeq	r0, r0, lr, asr #5
     594:	000002d4 	ldrdeq	r0, [r0], -r4
     598:	00034e0f 	andeq	r4, r3, pc, lsl #28
     59c:	1c130000 	ldcne	0, cr0, [r3], {-0}
     5a0:	04000005 	streq	r0, [r0], #-5
     5a4:	0c640e96 	stcleq	14, cr0, [r4], #-600	; 0xfffffda8
     5a8:	e9010000 	stmdb	r1, {}	; <UNPREDICTABLE>
     5ac:	ef000002 	svc	0x00000002
     5b0:	0f000002 	svceq	0x00000002
     5b4:	0000034e 	andeq	r0, r0, lr, asr #6
     5b8:	08521400 	ldmdaeq	r2, {sl, ip}^
     5bc:	99040000 	stmdbls	r4, {}	; <UNPREDICTABLE>
     5c0:	0007ea10 	andeq	lr, r7, r0, lsl sl
     5c4:	00035400 	andeq	r5, r3, r0, lsl #8
     5c8:	03040100 	movweq	r0, #16640	; 0x4100
     5cc:	4e0f0000 	cdpmi	0, 0, cr0, cr15, cr0, {0}
     5d0:	10000003 	andne	r0, r0, r3
     5d4:	00000332 	andeq	r0, r0, r2, lsr r3
     5d8:	00017d10 	andeq	r7, r1, r0, lsl sp
     5dc:	15000000 	strne	r0, [r0, #-0]
     5e0:	00000025 	andeq	r0, r0, r5, lsr #32
     5e4:	00000325 	andeq	r0, r0, r5, lsr #6
     5e8:	00005e16 	andeq	r5, r0, r6, lsl lr
     5ec:	02000f00 	andeq	r0, r0, #0, 30
     5f0:	062d0201 	strteq	r0, [sp], -r1, lsl #4
     5f4:	04170000 	ldreq	r0, [r7], #-0
     5f8:	000001b4 			; <UNDEFINED> instruction: 0x000001b4
     5fc:	002c0417 	eoreq	r0, ip, r7, lsl r4
     600:	7a0b0000 	bvc	2c0608 <__bss_end+0x2b77dc>
     604:	1700000b 	strne	r0, [r0, -fp]
     608:	00033804 	andeq	r3, r3, r4, lsl #16
     60c:	02641500 	rsbeq	r1, r4, #0, 10
     610:	034e0000 	movteq	r0, #57344	; 0xe000
     614:	00180000 	andseq	r0, r8, r0
     618:	01a70417 			; <UNDEFINED> instruction: 0x01a70417
     61c:	04170000 	ldreq	r0, [r7], #-0
     620:	000001a2 	andeq	r0, r0, r2, lsr #3
     624:	00062119 	andeq	r2, r6, r9, lsl r1
     628:	149c0400 	ldrne	r0, [ip], #1024	; 0x400
     62c:	000001a7 	andeq	r0, r0, r7, lsr #3
     630:	0005030a 	andeq	r0, r5, sl, lsl #6
     634:	14040500 	strne	r0, [r4], #-1280	; 0xfffffb00
     638:	00000059 	andeq	r0, r0, r9, asr r0
     63c:	8dc00305 	stclhi	3, cr0, [r0, #20]
     640:	f60a0000 			; <UNDEFINED> instruction: 0xf60a0000
     644:	05000003 	streq	r0, [r0, #-3]
     648:	00591407 	subseq	r1, r9, r7, lsl #8
     64c:	03050000 	movweq	r0, #20480	; 0x5000
     650:	00008dc4 	andeq	r8, r0, r4, asr #27
     654:	000aee0a 	andeq	lr, sl, sl, lsl #28
     658:	140a0500 	strne	r0, [sl], #-1280	; 0xfffffb00
     65c:	00000059 	andeq	r0, r0, r9, asr r0
     660:	8dc80305 	stclhi	3, cr0, [r8, #20]
     664:	41080000 	mrsmi	r0, (UNDEF: 8)
     668:	05000004 	streq	r0, [r0, #-4]
     66c:	00003804 	andeq	r3, r0, r4, lsl #16
     670:	0c0d0500 	cfstr32eq	mvfx0, [sp], {-0}
     674:	000003d3 	ldrdeq	r0, [r0], -r3
     678:	77654e1a 			; <UNDEFINED> instruction: 0x77654e1a
     67c:	28090000 	stmdacs	r9, {}	; <UNPREDICTABLE>
     680:	01000009 	tsteq	r0, r9
     684:	000b5909 	andeq	r5, fp, r9, lsl #18
     688:	c4090200 	strgt	r0, [r9], #-512	; 0xfffffe00
     68c:	03000008 	movweq	r0, #8
     690:	0006f409 	andeq	pc, r6, r9, lsl #8
     694:	8c090400 	cfstrshi	mvf0, [r9], {-0}
     698:	05000007 	streq	r0, [r0, #-7]
     69c:	04340600 	ldrteq	r0, [r4], #-1536	; 0xfffffa00
     6a0:	05100000 	ldreq	r0, [r0, #-0]
     6a4:	0412081b 	ldreq	r0, [r2], #-2075	; 0xfffff7e5
     6a8:	6c070000 	stcvs	0, cr0, [r7], {-0}
     6ac:	1d050072 	stcne	0, cr0, [r5, #-456]	; 0xfffffe38
     6b0:	00041213 	andeq	r1, r4, r3, lsl r2
     6b4:	73070000 	movwvc	r0, #28672	; 0x7000
     6b8:	1e050070 	mcrne	0, 0, r0, cr5, cr0, {3}
     6bc:	00041213 	andeq	r1, r4, r3, lsl r2
     6c0:	70070400 	andvc	r0, r7, r0, lsl #8
     6c4:	1f050063 	svcne	0x00050063
     6c8:	00041213 	andeq	r1, r4, r3, lsl r2
     6cc:	3b0d0800 	blcc	3426d4 <__bss_end+0x3398a8>
     6d0:	05000008 	streq	r0, [r0, #-8]
     6d4:	04121320 	ldreq	r1, [r2], #-800	; 0xfffffce0
     6d8:	000c0000 	andeq	r0, ip, r0
     6dc:	b1070402 	tstlt	r7, r2, lsl #8
     6e0:	06000016 			; <UNDEFINED> instruction: 0x06000016
     6e4:	00000c57 	andeq	r0, r0, r7, asr ip
     6e8:	08280570 	stmdaeq	r8!, {r4, r5, r6, r8, sl}
     6ec:	000004a9 	andeq	r0, r0, r9, lsr #9
     6f0:	0006660d 	andeq	r6, r6, sp, lsl #12
     6f4:	122a0500 	eorne	r0, sl, #0, 10
     6f8:	000003d3 	ldrdeq	r0, [r0], -r3
     6fc:	69700700 	ldmdbvs	r0!, {r8, r9, sl}^
     700:	2b050064 	blcs	140898 <__bss_end+0x137a6c>
     704:	00005e12 	andeq	r5, r0, r2, lsl lr
     708:	8f0d1000 	svchi	0x000d1000
     70c:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
     710:	039c112c 	orrseq	r1, ip, #44, 2
     714:	0d140000 	ldceq	0, cr0, [r4, #-0]
     718:	00000bdd 	ldrdeq	r0, [r0], -sp
     71c:	5e122d05 	cdppl	13, 1, cr2, cr2, cr5, {0}
     720:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     724:	00068a0d 	andeq	r8, r6, sp, lsl #20
     728:	122e0500 	eorne	r0, lr, #0, 10
     72c:	0000005e 	andeq	r0, r0, lr, asr r0
     730:	03e30d1c 	mvneq	r0, #28, 26	; 0x700
     734:	2f050000 	svccs	0x00050000
     738:	0004a931 	andeq	sl, r4, r1, lsr r9
     73c:	d50d2000 	strle	r2, [sp, #-0]
     740:	05000006 	streq	r0, [r0, #-6]
     744:	00380930 	eorseq	r0, r8, r0, lsr r9
     748:	0d600000 	stcleq	0, cr0, [r0, #-0]
     74c:	00000428 	andeq	r0, r0, r8, lsr #8
     750:	4d0e3105 	stfmis	f3, [lr, #-20]	; 0xffffffec
     754:	64000000 	strvs	r0, [r0], #-0
     758:	00041f0d 	andeq	r1, r4, sp, lsl #30
     75c:	0e330500 	cfabs32eq	mvfx0, mvfx3
     760:	0000004d 	andeq	r0, r0, sp, asr #32
     764:	04160d68 	ldreq	r0, [r6], #-3432	; 0xfffff298
     768:	34050000 	strcc	r0, [r5], #-0
     76c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     770:	15006c00 	strne	r6, [r0, #-3072]	; 0xfffff400
     774:	00000354 	andeq	r0, r0, r4, asr r3
     778:	000004b9 			; <UNDEFINED> instruction: 0x000004b9
     77c:	00005e16 	andeq	r5, r0, r6, lsl lr
     780:	0a000f00 	beq	4388 <shift+0x4388>
     784:	000005c8 	andeq	r0, r0, r8, asr #11
     788:	59140a06 	ldmdbpl	r4, {r1, r2, r9, fp}
     78c:	05000000 	streq	r0, [r0, #-0]
     790:	008dcc03 	addeq	ip, sp, r3, lsl #24
     794:	098f0800 	stmibeq	pc, {fp}	; <UNPREDICTABLE>
     798:	04050000 	streq	r0, [r5], #-0
     79c:	00000038 	andeq	r0, r0, r8, lsr r0
     7a0:	ea0c0d06 	b	303bc0 <__bss_end+0x2fad94>
     7a4:	09000004 	stmdbeq	r0, {r2}
     7a8:	00000b92 	muleq	r0, r2, fp
     7ac:	05ea0900 	strbeq	r0, [sl, #2304]!	; 0x900
     7b0:	00010000 	andeq	r0, r1, r0
     7b4:	000bca06 	andeq	ip, fp, r6, lsl #20
     7b8:	1b060c00 	blne	1837c0 <__bss_end+0x17a994>
     7bc:	00051f08 	andeq	r1, r5, r8, lsl #30
     7c0:	0b8d0d00 	bleq	fe343bc8 <__bss_end+0xfe33ad9c>
     7c4:	1d060000 	stcne	0, cr0, [r6, #-0]
     7c8:	00051f19 	andeq	r1, r5, r9, lsl pc
     7cc:	030d0000 	movweq	r0, #53248	; 0xd000
     7d0:	0600000c 	streq	r0, [r0], -ip
     7d4:	051f191e 	ldreq	r1, [pc, #-2334]	; fffffebe <__bss_end+0xffff7092>
     7d8:	0d040000 	stceq	0, cr0, [r4, #-0]
     7dc:	00000836 	andeq	r0, r0, r6, lsr r8
     7e0:	25131f06 	ldrcs	r1, [r3, #-3846]	; 0xfffff0fa
     7e4:	08000005 	stmdaeq	r0, {r0, r2}
     7e8:	ea041700 	b	1063f0 <__bss_end+0xfd5c4>
     7ec:	17000004 	strne	r0, [r0, -r4]
     7f0:	00041904 	andeq	r1, r4, r4, lsl #18
     7f4:	0a930c00 	beq	fe4c37fc <__bss_end+0xfe4ba9d0>
     7f8:	06140000 	ldreq	r0, [r4], -r0
     7fc:	07ad0722 	streq	r0, [sp, r2, lsr #14]!
     800:	320d0000 	andcc	r0, sp, #0
     804:	06000006 	streq	r0, [r0], -r6
     808:	004d1226 	subeq	r1, sp, r6, lsr #4
     80c:	0d000000 	stceq	0, cr0, [r0, #-0]
     810:	0000088a 	andeq	r0, r0, sl, lsl #17
     814:	1f1d2906 	svcne	0x001d2906
     818:	04000005 	streq	r0, [r0], #-5
     81c:	0005d70d 	andeq	sp, r5, sp, lsl #14
     820:	1d2c0600 	stcne	6, cr0, [ip, #-0]
     824:	0000051f 	andeq	r0, r0, pc, lsl r5
     828:	06011b08 	streq	r1, [r1], -r8, lsl #22
     82c:	2f060000 	svccs	0x00060000
     830:	000ba70e 	andeq	sl, fp, lr, lsl #14
     834:	00057300 	andeq	r7, r5, r0, lsl #6
     838:	00057e00 	andeq	r7, r5, r0, lsl #28
     83c:	07b20f00 	ldreq	r0, [r2, r0, lsl #30]!
     840:	1f100000 	svcne	0x00100000
     844:	00000005 	andeq	r0, r0, r5
     848:	0006411c 	andeq	r4, r6, ip, lsl r1
     84c:	0e310600 	cfmsuba32eq	mvax0, mvax0, mvfx1, mvfx0
     850:	00000c2e 	andeq	r0, r0, lr, lsr #24
     854:	00000325 	andeq	r0, r0, r5, lsr #6
     858:	00000596 	muleq	r0, r6, r5
     85c:	000005a1 	andeq	r0, r0, r1, lsr #11
     860:	0007b20f 	andeq	fp, r7, pc, lsl #4
     864:	05251000 	streq	r1, [r5, #-0]!
     868:	12000000 	andne	r0, r0, #0
     86c:	00000780 	andeq	r0, r0, r0, lsl #15
     870:	031d3506 	tsteq	sp, #25165824	; 0x1800000
     874:	1f000009 	svcne	0x00000009
     878:	02000005 	andeq	r0, r0, #5
     87c:	000005ba 			; <UNDEFINED> instruction: 0x000005ba
     880:	000005c0 	andeq	r0, r0, r0, asr #11
     884:	0007b20f 	andeq	fp, r7, pc, lsl #4
     888:	eb120000 	bl	480890 <__bss_end+0x477a64>
     88c:	0600000b 	streq	r0, [r0], -fp
     890:	0c081d37 	stceq	13, cr1, [r8], {55}	; 0x37
     894:	051f0000 	ldreq	r0, [pc, #-0]	; 89c <shift+0x89c>
     898:	d9020000 	stmdble	r2, {}	; <UNPREDICTABLE>
     89c:	df000005 	svcle	0x00000005
     8a0:	0f000005 	svceq	0x00000005
     8a4:	000007b2 			; <UNDEFINED> instruction: 0x000007b2
     8a8:	093f1d00 	ldmdbeq	pc!, {r8, sl, fp, ip}	; <UNPREDICTABLE>
     8ac:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
     8b0:	0007cb44 	andeq	ip, r7, r4, asr #22
     8b4:	12020c00 	andne	r0, r2, #0, 24
     8b8:	00000a93 	muleq	r0, r3, sl
     8bc:	d6093c06 	strle	r3, [r9], -r6, lsl #24
     8c0:	b2000008 	andlt	r0, r0, #8
     8c4:	01000007 	tsteq	r0, r7
     8c8:	00000606 	andeq	r0, r0, r6, lsl #12
     8cc:	0000060c 	andeq	r0, r0, ip, lsl #12
     8d0:	0007b20f 	andeq	fp, r7, pc, lsl #4
     8d4:	72120000 	andsvc	r0, r2, #0
     8d8:	06000006 	streq	r0, [r0], -r6
     8dc:	0711123f 			; <UNDEFINED> instruction: 0x0711123f
     8e0:	004d0000 	subeq	r0, sp, r0
     8e4:	25010000 	strcs	r0, [r1, #-0]
     8e8:	3a000006 	bcc	908 <shift+0x908>
     8ec:	0f000006 	svceq	0x00000006
     8f0:	000007b2 			; <UNDEFINED> instruction: 0x000007b2
     8f4:	0007d410 	andeq	sp, r7, r0, lsl r4
     8f8:	005e1000 	subseq	r1, lr, r0
     8fc:	25100000 	ldrcs	r0, [r0, #-0]
     900:	00000003 	andeq	r0, r0, r3
     904:	00070813 	andeq	r0, r7, r3, lsl r8
     908:	0e420600 	cdpeq	6, 4, cr0, cr2, cr0, {0}
     90c:	0000057f 	andeq	r0, r0, pc, ror r5
     910:	00064f01 	andeq	r4, r6, r1, lsl #30
     914:	00065500 	andeq	r5, r6, r0, lsl #10
     918:	07b20f00 	ldreq	r0, [r2, r0, lsl #30]!
     91c:	12000000 	andne	r0, r0, #0
     920:	000007b1 			; <UNDEFINED> instruction: 0x000007b1
     924:	d5174506 	ldrle	r4, [r7, #-1286]	; 0xfffffafa
     928:	25000004 	strcs	r0, [r0, #-4]
     92c:	01000005 	tsteq	r0, r5
     930:	0000066e 	andeq	r0, r0, lr, ror #12
     934:	00000674 	andeq	r0, r0, r4, ror r6
     938:	0007da0f 	andeq	sp, r7, pc, lsl #20
     93c:	a4120000 	ldrge	r0, [r2], #-0
     940:	06000009 	streq	r0, [r0], -r9
     944:	05521748 	ldrbeq	r1, [r2, #-1864]	; 0xfffff8b8
     948:	05250000 	streq	r0, [r5, #-0]!
     94c:	8d010000 	stchi	0, cr0, [r1, #-0]
     950:	98000006 	stmdals	r0, {r1, r2}
     954:	0f000006 	svceq	0x00000006
     958:	000007da 	ldrdeq	r0, [r0], -sl
     95c:	00004d10 	andeq	r4, r0, r0, lsl sp
     960:	15130000 	ldrne	r0, [r3, #-0]
     964:	06000008 	streq	r0, [r0], -r8
     968:	094d0e4b 	stmdbeq	sp, {r0, r1, r3, r6, r9, sl, fp}^
     96c:	ad010000 	stcge	0, cr0, [r1, #-0]
     970:	b3000006 	movwlt	r0, #6
     974:	0f000006 	svceq	0x00000006
     978:	000007b2 			; <UNDEFINED> instruction: 0x000007b2
     97c:	06411200 	strbeq	r1, [r1], -r0, lsl #4
     980:	4d060000 	stcmi	0, cr0, [r6, #-0]
     984:	0005a00e 	andeq	sl, r5, lr
     988:	00032500 	andeq	r2, r3, r0, lsl #10
     98c:	06cc0100 	strbeq	r0, [ip], r0, lsl #2
     990:	06d70000 	ldrbeq	r0, [r7], r0
     994:	b20f0000 	andlt	r0, pc, #0
     998:	10000007 	andne	r0, r0, r7
     99c:	0000004d 	andeq	r0, r0, sp, asr #32
     9a0:	09b71200 	ldmibeq	r7!, {r9, ip}
     9a4:	50060000 	andpl	r0, r6, r0
     9a8:	00085712 	andeq	r5, r8, r2, lsl r7
     9ac:	00004d00 	andeq	r4, r0, r0, lsl #26
     9b0:	06f00100 	ldrbteq	r0, [r0], r0, lsl #2
     9b4:	06fb0000 	ldrbteq	r0, [fp], r0
     9b8:	b20f0000 	andlt	r0, pc, #0
     9bc:	10000007 	andne	r0, r0, r7
     9c0:	00000354 	andeq	r0, r0, r4, asr r3
     9c4:	073c1200 	ldreq	r1, [ip, -r0, lsl #4]!
     9c8:	53060000 	movwpl	r0, #24576	; 0x6000
     9cc:	0007540e 	andeq	r5, r7, lr, lsl #8
     9d0:	00032500 	andeq	r2, r3, r0, lsl #10
     9d4:	07140100 	ldreq	r0, [r4, -r0, lsl #2]
     9d8:	071f0000 	ldreq	r0, [pc, -r0]
     9dc:	b20f0000 	andlt	r0, pc, #0
     9e0:	10000007 	andne	r0, r0, r7
     9e4:	0000004d 	andeq	r0, r0, sp, asr #32
     9e8:	097c1300 	ldmdbeq	ip!, {r8, r9, ip}^
     9ec:	56060000 	strpl	r0, [r6], -r0
     9f0:	0009d70e 	andeq	sp, r9, lr, lsl #14
     9f4:	07340100 	ldreq	r0, [r4, -r0, lsl #2]!
     9f8:	07530000 	ldrbeq	r0, [r3, -r0]
     9fc:	b20f0000 	andlt	r0, pc, #0
     a00:	10000007 	andne	r0, r0, r7
     a04:	0000008b 	andeq	r0, r0, fp, lsl #1
     a08:	00004d10 	andeq	r4, r0, r0, lsl sp
     a0c:	004d1000 	subeq	r1, sp, r0
     a10:	4d100000 	ldcmi	0, cr0, [r0, #-0]
     a14:	10000000 	andne	r0, r0, r0
     a18:	000007e0 	andeq	r0, r0, r0, ror #15
     a1c:	06501300 	ldrbeq	r1, [r0], -r0, lsl #6
     a20:	58060000 	stmdapl	r6, {}	; <UNPREDICTABLE>
     a24:	000a2f0e 	andeq	r2, sl, lr, lsl #30
     a28:	07680100 	strbeq	r0, [r8, -r0, lsl #2]!
     a2c:	07870000 	streq	r0, [r7, r0]
     a30:	b20f0000 	andlt	r0, pc, #0
     a34:	10000007 	andne	r0, r0, r7
     a38:	000000c2 	andeq	r0, r0, r2, asr #1
     a3c:	00004d10 	andeq	r4, r0, r0, lsl sp
     a40:	004d1000 	subeq	r1, sp, r0
     a44:	4d100000 	ldcmi	0, cr0, [r0, #-0]
     a48:	10000000 	andne	r0, r0, r0
     a4c:	000007e0 	andeq	r0, r0, r0, ror #15
     a50:	08f01400 	ldmeq	r0!, {sl, ip}^
     a54:	5b060000 	blpl	180a5c <__bss_end+0x177c30>
     a58:	000b160e 	andeq	r1, fp, lr, lsl #12
     a5c:	00032500 	andeq	r2, r3, r0, lsl #10
     a60:	079c0100 	ldreq	r0, [ip, r0, lsl #2]
     a64:	b20f0000 	andlt	r0, pc, #0
     a68:	10000007 	andne	r0, r0, r7
     a6c:	000004cb 	andeq	r0, r0, fp, asr #9
     a70:	0007e610 	andeq	lr, r7, r0, lsl r6
     a74:	03000000 	movweq	r0, #0
     a78:	0000052b 	andeq	r0, r0, fp, lsr #10
     a7c:	052b0417 	streq	r0, [fp, #-1047]!	; 0xfffffbe9
     a80:	1f1e0000 	svcne	0x001e0000
     a84:	c5000005 	strgt	r0, [r0, #-5]
     a88:	cb000007 	blgt	aac <shift+0xaac>
     a8c:	0f000007 	svceq	0x00000007
     a90:	000007b2 			; <UNDEFINED> instruction: 0x000007b2
     a94:	052b1f00 	streq	r1, [fp, #-3840]!	; 0xfffff100
     a98:	07b80000 	ldreq	r0, [r8, r0]!
     a9c:	04170000 	ldreq	r0, [r7], #-0
     aa0:	0000003f 	andeq	r0, r0, pc, lsr r0
     aa4:	07ad0417 			; <UNDEFINED> instruction: 0x07ad0417
     aa8:	04200000 	strteq	r0, [r0], #-0
     aac:	00000065 	andeq	r0, r0, r5, rrx
     ab0:	d0190421 	andsle	r0, r9, r1, lsr #8
     ab4:	06000007 	streq	r0, [r0], -r7
     ab8:	052b195e 	streq	r1, [fp, #-2398]!	; 0xfffff6a2
     abc:	2f220000 	svccs	0x00220000
     ac0:	01000005 	tsteq	r0, r5
     ac4:	00380505 	eorseq	r0, r8, r5, lsl #10
     ac8:	82340000 	eorshi	r0, r4, #0
     acc:	00480000 	subeq	r0, r8, r0
     ad0:	9c010000 	stcls	0, cr0, [r1], {-0}
     ad4:	0000082d 	andeq	r0, r0, sp, lsr #16
     ad8:	00063c23 	andeq	r3, r6, r3, lsr #24
     adc:	0e050100 	adfeqs	f0, f5, f0
     ae0:	00000038 	andeq	r0, r0, r8, lsr r0
     ae4:	23749102 	cmncs	r4, #-2147483648	; 0x80000000
     ae8:	0000074f 	andeq	r0, r0, pc, asr #14
     aec:	2d1b0501 	cfldr32cs	mvfx0, [fp, #-4]
     af0:	02000008 	andeq	r0, r0, #8
     af4:	17007091 			; <UNDEFINED> instruction: 0x17007091
     af8:	00083304 	andeq	r3, r8, r4, lsl #6
     afc:	25041700 	strcs	r1, [r4, #-1792]	; 0xfffff900
     b00:	00000000 	andeq	r0, r0, r0
     b04:	00000cd7 	ldrdeq	r0, [r0], -r7
     b08:	03dd0004 	bicseq	r0, sp, #4
     b0c:	01040000 	mrseq	r0, (UNDEF: 4)
     b10:	00000c96 	muleq	r0, r6, ip
     b14:	000dd704 	andeq	sp, sp, r4, lsl #14
     b18:	000e9900 	andeq	r9, lr, r0, lsl #18
     b1c:	00827c00 	addeq	r7, r2, r0, lsl #24
     b20:	00046000 	andeq	r6, r4, r0
     b24:	0003c700 	andeq	ip, r3, r0, lsl #14
     b28:	08010200 	stmdaeq	r1, {r9}
     b2c:	000007a1 	andeq	r0, r0, r1, lsr #15
     b30:	00002503 	andeq	r2, r0, r3, lsl #10
     b34:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     b38:	00000470 	andeq	r0, r0, r0, ror r4
     b3c:	69050404 	stmdbvs	r5, {r2, sl}
     b40:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
     b44:	07980801 	ldreq	r0, [r8, r1, lsl #16]
     b48:	02020000 	andeq	r0, r2, #0
     b4c:	00089d07 	andeq	r9, r8, r7, lsl #26
     b50:	07e10500 	strbeq	r0, [r1, r0, lsl #10]!
     b54:	09070000 	stmdbeq	r7, {}	; <UNPREDICTABLE>
     b58:	00005e1e 	andeq	r5, r0, lr, lsl lr
     b5c:	004d0300 	subeq	r0, sp, r0, lsl #6
     b60:	04020000 	streq	r0, [r2], #-0
     b64:	0016b607 	andseq	fp, r6, r7, lsl #12
     b68:	0a7b0600 	beq	1ec2370 <__bss_end+0x1eb9544>
     b6c:	02080000 	andeq	r0, r8, #0
     b70:	008b0806 	addeq	r0, fp, r6, lsl #16
     b74:	72070000 	andvc	r0, r7, #0
     b78:	08020030 	stmdaeq	r2, {r4, r5}
     b7c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     b80:	72070000 	andvc	r0, r7, #0
     b84:	09020031 	stmdbeq	r2, {r0, r4, r5}
     b88:	00004d0e 	andeq	r4, r0, lr, lsl #26
     b8c:	08000400 	stmdaeq	r0, {sl}
     b90:	00000ff7 	strdeq	r0, [r0], -r7
     b94:	00380405 	eorseq	r0, r8, r5, lsl #8
     b98:	0d020000 	stceq	0, cr0, [r2, #-0]
     b9c:	0000a90c 	andeq	sl, r0, ip, lsl #18
     ba0:	4b4f0900 	blmi	13c2fa8 <__bss_end+0x13ba17c>
     ba4:	170a0000 	strne	r0, [sl, -r0]
     ba8:	0100000e 	tsteq	r0, lr
     bac:	047a0800 	ldrbteq	r0, [sl], #-2048	; 0xfffff800
     bb0:	04050000 	streq	r0, [r5], #-0
     bb4:	00000038 	andeq	r0, r0, r8, lsr r0
     bb8:	e00c1e02 	and	r1, ip, r2, lsl #28
     bbc:	0a000000 	beq	bc4 <shift+0xbc4>
     bc0:	00000527 	andeq	r0, r0, r7, lsr #10
     bc4:	0b700a00 	bleq	1c033cc <__bss_end+0x1bfa5a0>
     bc8:	0a010000 	beq	40bd0 <__bss_end+0x37da4>
     bcc:	000003f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     bd0:	07020a02 	streq	r0, [r2, -r2, lsl #20]
     bd4:	0a030000 	beq	c0bdc <__bss_end+0xb7db0>
     bd8:	00000b61 	andeq	r0, r0, r1, ror #22
     bdc:	06810a04 	streq	r0, [r1], r4, lsl #20
     be0:	00050000 	andeq	r0, r5, r0
     be4:	00044d08 	andeq	r4, r4, r8, lsl #26
     be8:	38040500 	stmdacc	r4, {r8, sl}
     bec:	02000000 	andeq	r0, r0, #0
     bf0:	011d0c3f 	tsteq	sp, pc, lsr ip
     bf4:	520a0000 	andpl	r0, sl, #0
     bf8:	00000008 	andeq	r0, r0, r8
     bfc:	0007dc0a 	andeq	sp, r7, sl, lsl #24
     c00:	ca0a0100 	bgt	281008 <__bss_end+0x2781dc>
     c04:	02000007 	andeq	r0, r0, #7
     c08:	000a290a 	andeq	r2, sl, sl, lsl #18
     c0c:	cb0a0300 	blgt	281814 <__bss_end+0x2789e8>
     c10:	04000009 	streq	r0, [r0], #-9
     c14:	000aa40a 	andeq	sl, sl, sl, lsl #8
     c18:	930a0500 	movwls	r0, #42240	; 0xa500
     c1c:	06000007 	streq	r0, [r0], -r7
     c20:	10660800 	rsbne	r0, r6, r0, lsl #16
     c24:	04050000 	streq	r0, [r5], #-0
     c28:	00000038 	andeq	r0, r0, r8, lsr r0
     c2c:	480c6602 	stmdami	ip, {r1, r9, sl, sp, lr}
     c30:	0a000001 	beq	c3c <shift+0xc3c>
     c34:	00000f97 	muleq	r0, r7, pc	; <UNPREDICTABLE>
     c38:	0e740a00 	vaddeq.f32	s1, s8, s0
     c3c:	0a010000 	beq	40c44 <__bss_end+0x37e18>
     c40:	00000fc0 	andeq	r0, r0, r0, asr #31
     c44:	0ec80a02 	vdiveq.f32	s1, s16, s4
     c48:	00030000 	andeq	r0, r3, r0
     c4c:	0006a70b 	andeq	sl, r6, fp, lsl #14
     c50:	14050300 	strne	r0, [r5], #-768	; 0xfffffd00
     c54:	00000059 	andeq	r0, r0, r9, asr r0
     c58:	8dd00305 	ldclhi	3, cr0, [r0, #20]
     c5c:	870b0000 	strhi	r0, [fp, -r0]
     c60:	0300000a 	movweq	r0, #10
     c64:	00591406 	subseq	r1, r9, r6, lsl #8
     c68:	03050000 	movweq	r0, #20480	; 0x5000
     c6c:	00008dd4 	ldrdeq	r8, [r0], -r4
     c70:	00060b0b 	andeq	r0, r6, fp, lsl #22
     c74:	1a070400 	bne	1c1c7c <__bss_end+0x1b8e50>
     c78:	00000059 	andeq	r0, r0, r9, asr r0
     c7c:	8dd80305 	ldclhi	3, cr0, [r8, #20]
     c80:	c30b0000 	movwgt	r0, #45056	; 0xb000
     c84:	04000006 	streq	r0, [r0], #-6
     c88:	00591a09 	subseq	r1, r9, r9, lsl #20
     c8c:	03050000 	movweq	r0, #20480	; 0x5000
     c90:	00008ddc 	ldrdeq	r8, [r0], -ip
     c94:	0009310b 	andeq	r3, r9, fp, lsl #2
     c98:	1a0b0400 	bne	2c1ca0 <__bss_end+0x2b8e74>
     c9c:	00000059 	andeq	r0, r0, r9, asr r0
     ca0:	8de00305 	stclhi	3, cr0, [r0, #20]!
     ca4:	ab0b0000 	blge	2c0cac <__bss_end+0x2b7e80>
     ca8:	0400000a 	streq	r0, [r0], #-10
     cac:	00591a0d 	subseq	r1, r9, sp, lsl #20
     cb0:	03050000 	movweq	r0, #20480	; 0x5000
     cb4:	00008de4 	andeq	r8, r0, r4, ror #27
     cb8:	0008ba0b 	andeq	fp, r8, fp, lsl #20
     cbc:	1a0f0400 	bne	3c1cc4 <__bss_end+0x3b8e98>
     cc0:	00000059 	andeq	r0, r0, r9, asr r0
     cc4:	8de80305 	stclhi	3, cr0, [r8, #20]!
     cc8:	05080000 	streq	r0, [r8, #-0]
     ccc:	05000008 	streq	r0, [r0, #-8]
     cd0:	00003804 	andeq	r3, r0, r4, lsl #16
     cd4:	0c1b0400 	cfldrseq	mvf0, [fp], {-0}
     cd8:	000001eb 	andeq	r0, r0, fp, ror #3
     cdc:	0008cc0a 	andeq	ip, r8, sl, lsl #24
     ce0:	f80a0000 			; <UNDEFINED> instruction: 0xf80a0000
     ce4:	0100000b 	tsteq	r0, fp
     ce8:	0007c50a 	andeq	ip, r7, sl, lsl #10
     cec:	0c000200 	sfmeq	f0, 4, [r0], {-0}
     cf0:	00000884 	andeq	r0, r0, r4, lsl #17
     cf4:	0006df0d 	andeq	sp, r6, sp, lsl #30
     cf8:	63049000 	movwvs	r9, #16384	; 0x4000
     cfc:	00035e07 	andeq	r5, r3, r7, lsl #28
     d00:	06b50600 	ldrteq	r0, [r5], r0, lsl #12
     d04:	04240000 	strteq	r0, [r4], #-0
     d08:	02781067 	rsbseq	r1, r8, #103	; 0x67
     d0c:	9e0e0000 	cdpls	0, 0, cr0, cr14, cr0, {0}
     d10:	0400001a 	streq	r0, [r0], #-26	; 0xffffffe6
     d14:	035e2869 	cmpeq	lr, #6881280	; 0x690000
     d18:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     d1c:	000005f5 	strdeq	r0, [r0], -r5
     d20:	6e206b04 	vmulvs.f64	d6, d0, d4
     d24:	10000003 	andne	r0, r0, r3
     d28:	0004010e 	andeq	r0, r4, lr, lsl #2
     d2c:	236d0400 	cmncs	sp, #0, 8
     d30:	0000004d 	andeq	r0, r0, sp, asr #32
     d34:	06a00e14 	ssateq	r0, #1, r4, lsl #28
     d38:	70040000 	andvc	r0, r4, r0
     d3c:	0003751c 	andeq	r7, r3, ip, lsl r5
     d40:	eb0e1800 	bl	386d48 <__bss_end+0x37df1c>
     d44:	04000006 	streq	r0, [r0], #-6
     d48:	03751c72 	cmneq	r5, #29184	; 0x7200
     d4c:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
     d50:	00000c03 	andeq	r0, r0, r3, lsl #24
     d54:	751c7504 	ldrvc	r7, [ip, #-1284]	; 0xfffffafc
     d58:	20000003 	andcs	r0, r0, r3
     d5c:	00082b0f 	andeq	r2, r8, pc, lsl #22
     d60:	1c770400 	cfldrdne	mvd0, [r7], #-0
     d64:	00000abe 			; <UNDEFINED> instruction: 0x00000abe
     d68:	00000375 	andeq	r0, r0, r5, ror r3
     d6c:	0000026c 	andeq	r0, r0, ip, ror #4
     d70:	00037510 	andeq	r7, r3, r0, lsl r5
     d74:	037b1100 	cmneq	fp, #0, 2
     d78:	00000000 	andeq	r0, r0, r0
     d7c:	0007a606 	andeq	sl, r7, r6, lsl #12
     d80:	7b041800 	blvc	106d88 <__bss_end+0xfdf5c>
     d84:	0002ad10 	andeq	sl, r2, r0, lsl sp
     d88:	1a9e0e00 	bne	fe784590 <__bss_end+0xfe77b764>
     d8c:	7e040000 	cdpvc	0, 0, cr0, cr4, cr0, {0}
     d90:	00035e2c 	andeq	r5, r3, ip, lsr #28
     d94:	650e0000 	strvs	r0, [lr, #-0]
     d98:	04000004 	streq	r0, [r0], #-4
     d9c:	037b1980 	cmneq	fp, #128, 18	; 0x200000
     da0:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
     da4:	0000084b 	andeq	r0, r0, fp, asr #16
     da8:	86218204 	strthi	r8, [r1], -r4, lsl #4
     dac:	14000003 	strne	r0, [r0], #-3
     db0:	02780300 	rsbseq	r0, r8, #0, 6
     db4:	34120000 	ldrcc	r0, [r2], #-0
     db8:	04000005 	streq	r0, [r0], #-5
     dbc:	038c2186 	orreq	r2, ip, #-2147483615	; 0x80000021
     dc0:	40120000 	andsmi	r0, r2, r0
     dc4:	04000005 	streq	r0, [r0], #-5
     dc8:	00591f88 	subseq	r1, r9, r8, lsl #31
     dcc:	d10e0000 	mrsle	r0, (UNDEF: 14)
     dd0:	04000009 	streq	r0, [r0], #-9
     dd4:	01fd178b 	mvnseq	r1, fp, lsl #15
     dd8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     ddc:	0000040c 	andeq	r0, r0, ip, lsl #8
     de0:	fd178e04 	ldc2	14, cr8, [r7, #-16]
     de4:	24000001 	strcs	r0, [r0], #-1
     de8:	0008b00e 	andeq	fp, r8, lr
     dec:	178f0400 	strne	r0, [pc, r0, lsl #8]
     df0:	000001fd 	strdeq	r0, [r0], -sp
     df4:	08410e48 	stmdaeq	r1, {r3, r6, r9, sl, fp}^
     df8:	90040000 	andls	r0, r4, r0
     dfc:	0001fd17 	andeq	pc, r1, r7, lsl sp	; <UNPREDICTABLE>
     e00:	df136c00 	svcle	0x00136c00
     e04:	04000006 	streq	r0, [r0], #-6
     e08:	0b010993 	bleq	4345c <__bss_end+0x3a630>
     e0c:	03970000 	orrseq	r0, r7, #0
     e10:	17010000 	strne	r0, [r1, -r0]
     e14:	1d000003 	stcne	0, cr0, [r0, #-12]
     e18:	10000003 	andne	r0, r0, r3
     e1c:	00000397 	muleq	r0, r7, r3
     e20:	051c1400 	ldreq	r1, [ip, #-1024]	; 0xfffffc00
     e24:	96040000 	strls	r0, [r4], -r0
     e28:	000c640e 	andeq	r6, ip, lr, lsl #8
     e2c:	03320100 	teqeq	r2, #0, 2
     e30:	03380000 	teqeq	r8, #0
     e34:	97100000 	ldrls	r0, [r0, -r0]
     e38:	00000003 	andeq	r0, r0, r3
     e3c:	00085215 	andeq	r5, r8, r5, lsl r2
     e40:	10990400 	addsne	r0, r9, r0, lsl #8
     e44:	000007ea 	andeq	r0, r0, sl, ror #15
     e48:	0000039d 	muleq	r0, sp, r3
     e4c:	00034d01 	andeq	r4, r3, r1, lsl #26
     e50:	03971000 	orrseq	r1, r7, #0
     e54:	7b110000 	blvc	440e5c <__bss_end+0x438030>
     e58:	11000003 	tstne	r0, r3
     e5c:	000001c6 	andeq	r0, r0, r6, asr #3
     e60:	25160000 	ldrcs	r0, [r6, #-0]
     e64:	6e000000 	cdpvs	0, 0, cr0, cr0, cr0, {0}
     e68:	17000003 	strne	r0, [r0, -r3]
     e6c:	0000005e 	andeq	r0, r0, lr, asr r0
     e70:	0102000f 	tsteq	r2, pc
     e74:	00062d02 	andeq	r2, r6, r2, lsl #26
     e78:	fd041800 	stc2	8, cr1, [r4, #-0]
     e7c:	18000001 	stmdane	r0, {r0}
     e80:	00002c04 	andeq	r2, r0, r4, lsl #24
     e84:	0b7a0c00 	bleq	1e83e8c <__bss_end+0x1e7b060>
     e88:	04180000 	ldreq	r0, [r8], #-0
     e8c:	00000381 	andeq	r0, r0, r1, lsl #7
     e90:	0002ad16 	andeq	sl, r2, r6, lsl sp
     e94:	00039700 	andeq	r9, r3, r0, lsl #14
     e98:	18001900 	stmdane	r0, {r8, fp, ip}
     e9c:	0001f004 	andeq	pc, r1, r4
     ea0:	eb041800 	bl	106ea8 <__bss_end+0xfe07c>
     ea4:	1a000001 	bne	eb0 <shift+0xeb0>
     ea8:	00000621 	andeq	r0, r0, r1, lsr #12
     eac:	f0149c04 			; <UNDEFINED> instruction: 0xf0149c04
     eb0:	0b000001 	bleq	ebc <shift+0xebc>
     eb4:	00000503 	andeq	r0, r0, r3, lsl #10
     eb8:	59140405 	ldmdbpl	r4, {r0, r2, sl}
     ebc:	05000000 	streq	r0, [r0, #-0]
     ec0:	008dec03 	addeq	lr, sp, r3, lsl #24
     ec4:	03f60b00 	mvnseq	r0, #0, 22
     ec8:	07050000 	streq	r0, [r5, -r0]
     ecc:	00005914 	andeq	r5, r0, r4, lsl r9
     ed0:	f0030500 			; <UNDEFINED> instruction: 0xf0030500
     ed4:	0b00008d 	bleq	1110 <shift+0x1110>
     ed8:	00000aee 	andeq	r0, r0, lr, ror #21
     edc:	59140a05 	ldmdbpl	r4, {r0, r2, r9, fp}
     ee0:	05000000 	streq	r0, [r0, #-0]
     ee4:	008df403 	addeq	pc, sp, r3, lsl #8
     ee8:	04410800 	strbeq	r0, [r1], #-2048	; 0xfffff800
     eec:	04050000 	streq	r0, [r5], #-0
     ef0:	00000038 	andeq	r0, r0, r8, lsr r0
     ef4:	1c0c0d05 	stcne	13, cr0, [ip], {5}
     ef8:	09000004 	stmdbeq	r0, {r2}
     efc:	0077654e 	rsbseq	r6, r7, lr, asr #10
     f00:	09280a00 	stmdbeq	r8!, {r9, fp}
     f04:	0a010000 	beq	40f0c <__bss_end+0x380e0>
     f08:	00000b59 	andeq	r0, r0, r9, asr fp
     f0c:	08c40a02 	stmiaeq	r4, {r1, r9, fp}^
     f10:	0a030000 	beq	c0f18 <__bss_end+0xb80ec>
     f14:	000006f4 	strdeq	r0, [r0], -r4
     f18:	078c0a04 	streq	r0, [ip, r4, lsl #20]
     f1c:	00050000 	andeq	r0, r5, r0
     f20:	00043406 	andeq	r3, r4, r6, lsl #8
     f24:	1b051000 	blne	144f2c <__bss_end+0x13c100>
     f28:	00045b08 	andeq	r5, r4, r8, lsl #22
     f2c:	726c0700 	rsbvc	r0, ip, #0, 14
     f30:	131d0500 	tstne	sp, #0, 10
     f34:	0000045b 	andeq	r0, r0, fp, asr r4
     f38:	70730700 	rsbsvc	r0, r3, r0, lsl #14
     f3c:	131e0500 	tstne	lr, #0, 10
     f40:	0000045b 	andeq	r0, r0, fp, asr r4
     f44:	63700704 	cmnvs	r0, #4, 14	; 0x100000
     f48:	131f0500 	tstne	pc, #0, 10
     f4c:	0000045b 	andeq	r0, r0, fp, asr r4
     f50:	083b0e08 	ldmdaeq	fp!, {r3, r9, sl, fp}
     f54:	20050000 	andcs	r0, r5, r0
     f58:	00045b13 	andeq	r5, r4, r3, lsl fp
     f5c:	02000c00 	andeq	r0, r0, #0, 24
     f60:	16b10704 	ldrtne	r0, [r1], r4, lsl #14
     f64:	57060000 	strpl	r0, [r6, -r0]
     f68:	7000000c 	andvc	r0, r0, ip
     f6c:	f2082805 	vadd.i8	d2, d8, d5
     f70:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
     f74:	00000666 	andeq	r0, r0, r6, ror #12
     f78:	1c122a05 			; <UNDEFINED> instruction: 0x1c122a05
     f7c:	00000004 	andeq	r0, r0, r4
     f80:	64697007 	strbtvs	r7, [r9], #-7
     f84:	122b0500 	eorne	r0, fp, #0, 10
     f88:	0000005e 	andeq	r0, r0, lr, asr r0
     f8c:	148f0e10 	strne	r0, [pc], #3600	; f94 <shift+0xf94>
     f90:	2c050000 	stccs	0, cr0, [r5], {-0}
     f94:	0003e511 	andeq	lr, r3, r1, lsl r5
     f98:	dd0e1400 	cfstrsle	mvf1, [lr, #-0]
     f9c:	0500000b 	streq	r0, [r0, #-11]
     fa0:	005e122d 	subseq	r1, lr, sp, lsr #4
     fa4:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
     fa8:	0000068a 	andeq	r0, r0, sl, lsl #13
     fac:	5e122e05 	cdppl	14, 1, cr2, cr2, cr5, {0}
     fb0:	1c000000 	stcne	0, cr0, [r0], {-0}
     fb4:	0003e30e 	andeq	lr, r3, lr, lsl #6
     fb8:	312f0500 			; <UNDEFINED> instruction: 0x312f0500
     fbc:	000004f2 	strdeq	r0, [r0], -r2
     fc0:	06d50e20 	ldrbeq	r0, [r5], r0, lsr #28
     fc4:	30050000 	andcc	r0, r5, r0
     fc8:	00003809 	andeq	r3, r0, r9, lsl #16
     fcc:	280e6000 	stmdacs	lr, {sp, lr}
     fd0:	05000004 	streq	r0, [r0, #-4]
     fd4:	004d0e31 	subeq	r0, sp, r1, lsr lr
     fd8:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
     fdc:	0000041f 	andeq	r0, r0, pc, lsl r4
     fe0:	4d0e3305 	stcmi	3, cr3, [lr, #-20]	; 0xffffffec
     fe4:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
     fe8:	0004160e 	andeq	r1, r4, lr, lsl #12
     fec:	0e340500 	cfabs32eq	mvfx0, mvfx4
     ff0:	0000004d 	andeq	r0, r0, sp, asr #32
     ff4:	9d16006c 	ldcls	0, cr0, [r6, #-432]	; 0xfffffe50
     ff8:	02000003 	andeq	r0, r0, #3
     ffc:	17000005 	strne	r0, [r0, -r5]
    1000:	0000005e 	andeq	r0, r0, lr, asr r0
    1004:	c80b000f 	stmdagt	fp, {r0, r1, r2, r3}
    1008:	06000005 	streq	r0, [r0], -r5
    100c:	0059140a 	subseq	r1, r9, sl, lsl #8
    1010:	03050000 	movweq	r0, #20480	; 0x5000
    1014:	00008df8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    1018:	00098f08 	andeq	r8, r9, r8, lsl #30
    101c:	38040500 	stmdacc	r4, {r8, sl}
    1020:	06000000 	streq	r0, [r0], -r0
    1024:	05330c0d 	ldreq	r0, [r3, #-3085]!	; 0xfffff3f3
    1028:	920a0000 	andls	r0, sl, #0
    102c:	0000000b 	andeq	r0, r0, fp
    1030:	0005ea0a 	andeq	lr, r5, sl, lsl #20
    1034:	03000100 	movweq	r0, #256	; 0x100
    1038:	00000514 	andeq	r0, r0, r4, lsl r5
    103c:	000f2308 	andeq	r2, pc, r8, lsl #6
    1040:	38040500 	stmdacc	r4, {r8, sl}
    1044:	06000000 	streq	r0, [r0], -r0
    1048:	05570c14 	ldrbeq	r0, [r7, #-3092]	; 0xfffff3ec
    104c:	890a0000 	stmdbhi	sl, {}	; <UNPREDICTABLE>
    1050:	0000000c 	andeq	r0, r0, ip
    1054:	000fb20a 	andeq	fp, pc, sl, lsl #4
    1058:	03000100 	movweq	r0, #256	; 0x100
    105c:	00000538 	andeq	r0, r0, r8, lsr r5
    1060:	000bca06 	andeq	ip, fp, r6, lsl #20
    1064:	1b060c00 	blne	18406c <__bss_end+0x17b240>
    1068:	00059108 	andeq	r9, r5, r8, lsl #2
    106c:	0b8d0e00 	bleq	fe344874 <__bss_end+0xfe33ba48>
    1070:	1d060000 	stcne	0, cr0, [r6, #-0]
    1074:	00059119 	andeq	r9, r5, r9, lsl r1
    1078:	030e0000 	movweq	r0, #57344	; 0xe000
    107c:	0600000c 	streq	r0, [r0], -ip
    1080:	0591191e 	ldreq	r1, [r1, #2334]	; 0x91e
    1084:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
    1088:	00000836 	andeq	r0, r0, r6, lsr r8
    108c:	97131f06 	ldrls	r1, [r3, -r6, lsl #30]
    1090:	08000005 	stmdaeq	r0, {r0, r2}
    1094:	5c041800 	stcpl	8, cr1, [r4], {-0}
    1098:	18000005 	stmdane	r0, {r0, r2}
    109c:	00046204 	andeq	r6, r4, r4, lsl #4
    10a0:	0a930d00 	beq	fe4c44a8 <__bss_end+0xfe4bb67c>
    10a4:	06140000 	ldreq	r0, [r4], -r0
    10a8:	081f0722 	ldmdaeq	pc, {r1, r5, r8, r9, sl}	; <UNPREDICTABLE>
    10ac:	320e0000 	andcc	r0, lr, #0
    10b0:	06000006 	streq	r0, [r0], -r6
    10b4:	004d1226 	subeq	r1, sp, r6, lsr #4
    10b8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    10bc:	0000088a 	andeq	r0, r0, sl, lsl #17
    10c0:	911d2906 	tstls	sp, r6, lsl #18
    10c4:	04000005 	streq	r0, [r0], #-5
    10c8:	0005d70e 	andeq	sp, r5, lr, lsl #14
    10cc:	1d2c0600 	stcne	6, cr0, [ip, #-0]
    10d0:	00000591 	muleq	r0, r1, r5
    10d4:	06011b08 	streq	r1, [r1], -r8, lsl #22
    10d8:	2f060000 	svccs	0x00060000
    10dc:	000ba70e 	andeq	sl, fp, lr, lsl #14
    10e0:	0005e500 	andeq	lr, r5, r0, lsl #10
    10e4:	0005f000 	andeq	pc, r5, r0
    10e8:	08241000 	stmdaeq	r4!, {ip}
    10ec:	91110000 	tstls	r1, r0
    10f0:	00000005 	andeq	r0, r0, r5
    10f4:	0006411c 	andeq	r4, r6, ip, lsl r1
    10f8:	0e310600 	cfmsuba32eq	mvax0, mvax0, mvfx1, mvfx0
    10fc:	00000c2e 	andeq	r0, r0, lr, lsr #24
    1100:	0000036e 	andeq	r0, r0, lr, ror #6
    1104:	00000608 	andeq	r0, r0, r8, lsl #12
    1108:	00000613 	andeq	r0, r0, r3, lsl r6
    110c:	00082410 	andeq	r2, r8, r0, lsl r4
    1110:	05971100 	ldreq	r1, [r7, #256]	; 0x100
    1114:	13000000 	movwne	r0, #0
    1118:	00000780 	andeq	r0, r0, r0, lsl #15
    111c:	031d3506 	tsteq	sp, #25165824	; 0x1800000
    1120:	91000009 	tstls	r0, r9
    1124:	02000005 	andeq	r0, r0, #5
    1128:	0000062c 	andeq	r0, r0, ip, lsr #12
    112c:	00000632 	andeq	r0, r0, r2, lsr r6
    1130:	00082410 	andeq	r2, r8, r0, lsl r4
    1134:	eb130000 	bl	4c113c <__bss_end+0x4b8310>
    1138:	0600000b 	streq	r0, [r0], -fp
    113c:	0c081d37 	stceq	13, cr1, [r8], {55}	; 0x37
    1140:	05910000 	ldreq	r0, [r1]
    1144:	4b020000 	blmi	8114c <__bss_end+0x78320>
    1148:	51000006 	tstpl	r0, r6
    114c:	10000006 	andne	r0, r0, r6
    1150:	00000824 	andeq	r0, r0, r4, lsr #16
    1154:	093f1d00 	ldmdbeq	pc!, {r8, sl, fp, ip}	; <UNPREDICTABLE>
    1158:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
    115c:	00083d44 	andeq	r3, r8, r4, asr #26
    1160:	13020c00 	movwne	r0, #11264	; 0x2c00
    1164:	00000a93 	muleq	r0, r3, sl
    1168:	d6093c06 	strle	r3, [r9], -r6, lsl #24
    116c:	24000008 	strcs	r0, [r0], #-8
    1170:	01000008 	tsteq	r0, r8
    1174:	00000678 	andeq	r0, r0, r8, ror r6
    1178:	0000067e 	andeq	r0, r0, lr, ror r6
    117c:	00082410 	andeq	r2, r8, r0, lsl r4
    1180:	72130000 	andsvc	r0, r3, #0
    1184:	06000006 	streq	r0, [r0], -r6
    1188:	0711123f 			; <UNDEFINED> instruction: 0x0711123f
    118c:	004d0000 	subeq	r0, sp, r0
    1190:	97010000 	strls	r0, [r1, -r0]
    1194:	ac000006 	stcge	0, cr0, [r0], {6}
    1198:	10000006 	andne	r0, r0, r6
    119c:	00000824 	andeq	r0, r0, r4, lsr #16
    11a0:	00084611 	andeq	r4, r8, r1, lsl r6
    11a4:	005e1100 	subseq	r1, lr, r0, lsl #2
    11a8:	6e110000 	cdpvs	0, 1, cr0, cr1, cr0, {0}
    11ac:	00000003 	andeq	r0, r0, r3
    11b0:	00070814 	andeq	r0, r7, r4, lsl r8
    11b4:	0e420600 	cdpeq	6, 4, cr0, cr2, cr0, {0}
    11b8:	0000057f 	andeq	r0, r0, pc, ror r5
    11bc:	0006c101 	andeq	ip, r6, r1, lsl #2
    11c0:	0006c700 	andeq	ip, r6, r0, lsl #14
    11c4:	08241000 	stmdaeq	r4!, {ip}
    11c8:	13000000 	movwne	r0, #0
    11cc:	000007b1 			; <UNDEFINED> instruction: 0x000007b1
    11d0:	d5174506 	ldrle	r4, [r7, #-1286]	; 0xfffffafa
    11d4:	97000004 	strls	r0, [r0, -r4]
    11d8:	01000005 	tsteq	r0, r5
    11dc:	000006e0 	andeq	r0, r0, r0, ror #13
    11e0:	000006e6 	andeq	r0, r0, r6, ror #13
    11e4:	00084c10 	andeq	r4, r8, r0, lsl ip
    11e8:	a4130000 	ldrge	r0, [r3], #-0
    11ec:	06000009 	streq	r0, [r0], -r9
    11f0:	05521748 	ldrbeq	r1, [r2, #-1864]	; 0xfffff8b8
    11f4:	05970000 	ldreq	r0, [r7]
    11f8:	ff010000 			; <UNDEFINED> instruction: 0xff010000
    11fc:	0a000006 	beq	121c <shift+0x121c>
    1200:	10000007 	andne	r0, r0, r7
    1204:	0000084c 	andeq	r0, r0, ip, asr #16
    1208:	00004d11 	andeq	r4, r0, r1, lsl sp
    120c:	15140000 	ldrne	r0, [r4, #-0]
    1210:	06000008 	streq	r0, [r0], -r8
    1214:	094d0e4b 	stmdbeq	sp, {r0, r1, r3, r6, r9, sl, fp}^
    1218:	1f010000 	svcne	0x00010000
    121c:	25000007 	strcs	r0, [r0, #-7]
    1220:	10000007 	andne	r0, r0, r7
    1224:	00000824 	andeq	r0, r0, r4, lsr #16
    1228:	06411300 	strbeq	r1, [r1], -r0, lsl #6
    122c:	4d060000 	stcmi	0, cr0, [r6, #-0]
    1230:	0005a00e 	andeq	sl, r5, lr
    1234:	00036e00 	andeq	r6, r3, r0, lsl #28
    1238:	073e0100 	ldreq	r0, [lr, -r0, lsl #2]!
    123c:	07490000 	strbeq	r0, [r9, -r0]
    1240:	24100000 	ldrcs	r0, [r0], #-0
    1244:	11000008 	tstne	r0, r8
    1248:	0000004d 	andeq	r0, r0, sp, asr #32
    124c:	09b71300 	ldmibeq	r7!, {r8, r9, ip}
    1250:	50060000 	andpl	r0, r6, r0
    1254:	00085712 	andeq	r5, r8, r2, lsl r7
    1258:	00004d00 	andeq	r4, r0, r0, lsl #26
    125c:	07620100 	strbeq	r0, [r2, -r0, lsl #2]!
    1260:	076d0000 	strbeq	r0, [sp, -r0]!
    1264:	24100000 	ldrcs	r0, [r0], #-0
    1268:	11000008 	tstne	r0, r8
    126c:	0000039d 	muleq	r0, sp, r3
    1270:	073c1300 	ldreq	r1, [ip, -r0, lsl #6]!
    1274:	53060000 	movwpl	r0, #24576	; 0x6000
    1278:	0007540e 	andeq	r5, r7, lr, lsl #8
    127c:	00036e00 	andeq	r6, r3, r0, lsl #28
    1280:	07860100 	streq	r0, [r6, r0, lsl #2]
    1284:	07910000 	ldreq	r0, [r1, r0]
    1288:	24100000 	ldrcs	r0, [r0], #-0
    128c:	11000008 	tstne	r0, r8
    1290:	0000004d 	andeq	r0, r0, sp, asr #32
    1294:	097c1400 	ldmdbeq	ip!, {sl, ip}^
    1298:	56060000 	strpl	r0, [r6], -r0
    129c:	0009d70e 	andeq	sp, r9, lr, lsl #14
    12a0:	07a60100 	streq	r0, [r6, r0, lsl #2]!
    12a4:	07c50000 	strbeq	r0, [r5, r0]
    12a8:	24100000 	ldrcs	r0, [r0], #-0
    12ac:	11000008 	tstne	r0, r8
    12b0:	000000a9 	andeq	r0, r0, r9, lsr #1
    12b4:	00004d11 	andeq	r4, r0, r1, lsl sp
    12b8:	004d1100 	subeq	r1, sp, r0, lsl #2
    12bc:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    12c0:	11000000 	mrsne	r0, (UNDEF: 0)
    12c4:	00000852 	andeq	r0, r0, r2, asr r8
    12c8:	06501400 	ldrbeq	r1, [r0], -r0, lsl #8
    12cc:	58060000 	stmdapl	r6, {}	; <UNPREDICTABLE>
    12d0:	000a2f0e 	andeq	r2, sl, lr, lsl #30
    12d4:	07da0100 	ldrbeq	r0, [sl, r0, lsl #2]
    12d8:	07f90000 	ldrbeq	r0, [r9, r0]!
    12dc:	24100000 	ldrcs	r0, [r0], #-0
    12e0:	11000008 	tstne	r0, r8
    12e4:	000000e0 	andeq	r0, r0, r0, ror #1
    12e8:	00004d11 	andeq	r4, r0, r1, lsl sp
    12ec:	004d1100 	subeq	r1, sp, r0, lsl #2
    12f0:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    12f4:	11000000 	mrsne	r0, (UNDEF: 0)
    12f8:	00000852 	andeq	r0, r0, r2, asr r8
    12fc:	08f01500 	ldmeq	r0!, {r8, sl, ip}^
    1300:	5b060000 	blpl	181308 <__bss_end+0x1784dc>
    1304:	000b160e 	andeq	r1, fp, lr, lsl #12
    1308:	00036e00 	andeq	r6, r3, r0, lsl #28
    130c:	080e0100 	stmdaeq	lr, {r8}
    1310:	24100000 	ldrcs	r0, [r0], #-0
    1314:	11000008 	tstne	r0, r8
    1318:	00000514 	andeq	r0, r0, r4, lsl r5
    131c:	00085811 	andeq	r5, r8, r1, lsl r8
    1320:	03000000 	movweq	r0, #0
    1324:	0000059d 	muleq	r0, sp, r5
    1328:	059d0418 	ldreq	r0, [sp, #1048]	; 0x418
    132c:	911e0000 	tstls	lr, r0
    1330:	37000005 	strcc	r0, [r0, -r5]
    1334:	3d000008 	stccc	0, cr0, [r0, #-32]	; 0xffffffe0
    1338:	10000008 	andne	r0, r0, r8
    133c:	00000824 	andeq	r0, r0, r4, lsr #16
    1340:	059d1f00 	ldreq	r1, [sp, #3840]	; 0xf00
    1344:	082a0000 	stmdaeq	sl!, {}	; <UNPREDICTABLE>
    1348:	04180000 	ldreq	r0, [r8], #-0
    134c:	0000003f 	andeq	r0, r0, pc, lsr r0
    1350:	081f0418 	ldmdaeq	pc, {r3, r4, sl}	; <UNPREDICTABLE>
    1354:	04200000 	strteq	r0, [r0], #-0
    1358:	00000065 	andeq	r0, r0, r5, rrx
    135c:	d01a0421 	andsle	r0, sl, r1, lsr #8
    1360:	06000007 	streq	r0, [r0], -r7
    1364:	059d195e 	ldreq	r1, [sp, #2398]	; 0x95e
    1368:	2c160000 	ldccs	0, cr0, [r6], {-0}
    136c:	76000000 	strvc	r0, [r0], -r0
    1370:	17000008 	strne	r0, [r0, -r8]
    1374:	0000005e 	andeq	r0, r0, lr, asr r0
    1378:	66030009 	strvs	r0, [r3], -r9
    137c:	22000008 	andcs	r0, r0, #8
    1380:	00000e63 	andeq	r0, r0, r3, ror #28
    1384:	760ca401 	strvc	sl, [ip], -r1, lsl #8
    1388:	05000008 	streq	r0, [r0, #-8]
    138c:	008dfc03 	addeq	pc, sp, r3, lsl #24
    1390:	0d852300 	stceq	3, cr2, [r5]
    1394:	a6010000 	strge	r0, [r1], -r0
    1398:	000f170a 	andeq	r1, pc, sl, lsl #14
    139c:	00004d00 	andeq	r4, r0, r0, lsl #26
    13a0:	00862800 	addeq	r2, r6, r0, lsl #16
    13a4:	0000b400 	andeq	fp, r0, r0, lsl #8
    13a8:	eb9c0100 	bl	fe7017b0 <__bss_end+0xfe6f8984>
    13ac:	24000008 	strcs	r0, [r0], #-8
    13b0:	00001a9e 	muleq	r0, lr, sl
    13b4:	7b1ba601 	blvc	6eabc0 <__bss_end+0x6e1d94>
    13b8:	03000003 	movweq	r0, #3
    13bc:	247fac91 	ldrbtcs	sl, [pc], #-3217	; 13c4 <shift+0x13c4>
    13c0:	00000f76 	andeq	r0, r0, r6, ror pc
    13c4:	4d2aa601 	stcmi	6, cr10, [sl, #-4]!
    13c8:	03000000 	movweq	r0, #0
    13cc:	227fa891 	rsbscs	sl, pc, #9502720	; 0x910000
    13d0:	00000eff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    13d4:	eb0aa801 	bl	2ab3e0 <__bss_end+0x2a25b4>
    13d8:	03000008 	movweq	r0, #8
    13dc:	227fb491 	rsbscs	fp, pc, #-1862270976	; 0x91000000
    13e0:	00000d80 	andeq	r0, r0, r0, lsl #27
    13e4:	3809ac01 	stmdacc	r9, {r0, sl, fp, sp, pc}
    13e8:	02000000 	andeq	r0, r0, #0
    13ec:	16007491 			; <UNDEFINED> instruction: 0x16007491
    13f0:	00000025 	andeq	r0, r0, r5, lsr #32
    13f4:	000008fb 	strdeq	r0, [r0], -fp
    13f8:	00005e17 	andeq	r5, r0, r7, lsl lr
    13fc:	25003f00 	strcs	r3, [r0, #-3840]	; 0xfffff100
    1400:	00000f5b 	andeq	r0, r0, fp, asr pc
    1404:	d70a9801 	strle	r9, [sl, -r1, lsl #16]
    1408:	4d00000f 	stcmi	0, cr0, [r0, #-60]	; 0xffffffc4
    140c:	ec000000 	stc	0, cr0, [r0], {-0}
    1410:	3c000085 	stccc	0, cr0, [r0], {133}	; 0x85
    1414:	01000000 	mrseq	r0, (UNDEF: 0)
    1418:	0009389c 	muleq	r9, ip, r8
    141c:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1420:	9a010071 	bls	415ec <__bss_end+0x387c0>
    1424:	00055720 	andeq	r5, r5, r0, lsr #14
    1428:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    142c:	000f0c22 	andeq	r0, pc, r2, lsr #24
    1430:	0e9b0100 	fmleqe	f0, f3, f0
    1434:	0000004d 	andeq	r0, r0, sp, asr #32
    1438:	00709102 	rsbseq	r9, r0, r2, lsl #2
    143c:	000f8527 	andeq	r8, pc, r7, lsr #10
    1440:	068f0100 	streq	r0, [pc], r0, lsl #2
    1444:	00000da1 	andeq	r0, r0, r1, lsr #27
    1448:	000085b0 			; <UNDEFINED> instruction: 0x000085b0
    144c:	0000003c 	andeq	r0, r0, ip, lsr r0
    1450:	09719c01 	ldmdbeq	r1!, {r0, sl, fp, ip, pc}^
    1454:	4f240000 	svcmi	0x00240000
    1458:	0100000e 	tsteq	r0, lr
    145c:	004d218f 	subeq	r2, sp, pc, lsl #3
    1460:	91020000 	mrsls	r0, (UNDEF: 2)
    1464:	6572266c 	ldrbvs	r2, [r2, #-1644]!	; 0xfffff994
    1468:	91010071 	tstls	r1, r1, ror r0
    146c:	00055720 	andeq	r5, r5, r0, lsr #14
    1470:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1474:	0f382500 	svceq	0x00382500
    1478:	83010000 	movwhi	r0, #4096	; 0x1000
    147c:	000e7f0a 	andeq	r7, lr, sl, lsl #30
    1480:	00004d00 	andeq	r4, r0, r0, lsl #26
    1484:	00857400 	addeq	r7, r5, r0, lsl #8
    1488:	00003c00 	andeq	r3, r0, r0, lsl #24
    148c:	ae9c0100 	fmlgee	f0, f4, f0
    1490:	26000009 	strcs	r0, [r0], -r9
    1494:	00716572 	rsbseq	r6, r1, r2, ror r5
    1498:	33208501 			; <UNDEFINED> instruction: 0x33208501
    149c:	02000005 	andeq	r0, r0, #5
    14a0:	79227491 	stmdbvc	r2!, {r0, r4, r7, sl, ip, sp, lr}
    14a4:	0100000d 	tsteq	r0, sp
    14a8:	004d0e86 	subeq	r0, sp, r6, lsl #29
    14ac:	91020000 	mrsls	r0, (UNDEF: 2)
    14b0:	7f250070 	svcvc	0x00250070
    14b4:	01000010 	tsteq	r0, r0, lsl r0
    14b8:	0e250a77 			; <UNDEFINED> instruction: 0x0e250a77
    14bc:	004d0000 	subeq	r0, sp, r0
    14c0:	85380000 	ldrhi	r0, [r8, #-0]!
    14c4:	003c0000 	eorseq	r0, ip, r0
    14c8:	9c010000 	stcls	0, cr0, [r1], {-0}
    14cc:	000009eb 	andeq	r0, r0, fp, ror #19
    14d0:	71657226 	cmnvc	r5, r6, lsr #4
    14d4:	20790100 	rsbscs	r0, r9, r0, lsl #2
    14d8:	00000533 	andeq	r0, r0, r3, lsr r5
    14dc:	22749102 	rsbscs	r9, r4, #-2147483648	; 0x80000000
    14e0:	00000d79 	andeq	r0, r0, r9, ror sp
    14e4:	4d0e7a01 	vstrmi	s14, [lr, #-4]
    14e8:	02000000 	andeq	r0, r0, #0
    14ec:	25007091 	strcs	r7, [r0, #-145]	; 0xffffff6f
    14f0:	00000e93 	muleq	r0, r3, lr
    14f4:	a2066b01 	andge	r6, r6, #1024	; 0x400
    14f8:	6e00000f 	cdpvs	0, 0, cr0, cr0, cr15, {0}
    14fc:	e4000003 	str	r0, [r0], #-3
    1500:	54000084 	strpl	r0, [r0], #-132	; 0xffffff7c
    1504:	01000000 	mrseq	r0, (UNDEF: 0)
    1508:	000a379c 	muleq	sl, ip, r7
    150c:	0f0c2400 	svceq	0x000c2400
    1510:	6b010000 	blvs	41518 <__bss_end+0x386ec>
    1514:	00004d15 	andeq	r4, r0, r5, lsl sp
    1518:	6c910200 	lfmvs	f0, 4, [r1], {0}
    151c:	00041624 	andeq	r1, r4, r4, lsr #12
    1520:	256b0100 	strbcs	r0, [fp, #-256]!	; 0xffffff00
    1524:	0000004d 	andeq	r0, r0, sp, asr #32
    1528:	22689102 	rsbcs	r9, r8, #-2147483648	; 0x80000000
    152c:	00001077 	andeq	r1, r0, r7, ror r0
    1530:	4d0e6d01 	stcmi	13, cr6, [lr, #-4]
    1534:	02000000 	andeq	r0, r0, #0
    1538:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    153c:	00000db8 			; <UNDEFINED> instruction: 0x00000db8
    1540:	0e125e01 	cdpeq	14, 1, cr5, cr2, cr1, {0}
    1544:	8b000010 	blhi	158c <shift+0x158c>
    1548:	94000000 	strls	r0, [r0], #-0
    154c:	50000084 	andpl	r0, r0, r4, lsl #1
    1550:	01000000 	mrseq	r0, (UNDEF: 0)
    1554:	000a929c 	muleq	sl, ip, r2
    1558:	0fad2400 	svceq	0x00ad2400
    155c:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1560:	00004d20 	andeq	r4, r0, r0, lsr #26
    1564:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1568:	000f4124 	andeq	r4, pc, r4, lsr #2
    156c:	2f5e0100 	svccs	0x005e0100
    1570:	0000004d 	andeq	r0, r0, sp, asr #32
    1574:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1578:	00000416 	andeq	r0, r0, r6, lsl r4
    157c:	4d3f5e01 	ldcmi	14, cr5, [pc, #-4]!	; 1580 <shift+0x1580>
    1580:	02000000 	andeq	r0, r0, #0
    1584:	77226491 			; <UNDEFINED> instruction: 0x77226491
    1588:	01000010 	tsteq	r0, r0, lsl r0
    158c:	008b1660 	addeq	r1, fp, r0, ror #12
    1590:	91020000 	mrsls	r0, (UNDEF: 2)
    1594:	05250074 	streq	r0, [r5, #-116]!	; 0xffffff8c
    1598:	0100000f 	tsteq	r0, pc
    159c:	0dbd0a52 			; <UNDEFINED> instruction: 0x0dbd0a52
    15a0:	004d0000 	subeq	r0, sp, r0
    15a4:	84500000 	ldrbhi	r0, [r0], #-0
    15a8:	00440000 	subeq	r0, r4, r0
    15ac:	9c010000 	stcls	0, cr0, [r1], {-0}
    15b0:	00000ade 	ldrdeq	r0, [r0], -lr
    15b4:	000fad24 	andeq	sl, pc, r4, lsr #26
    15b8:	1a520100 	bne	14819c0 <__bss_end+0x1478b94>
    15bc:	0000004d 	andeq	r0, r0, sp, asr #32
    15c0:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    15c4:	00000f41 	andeq	r0, r0, r1, asr #30
    15c8:	4d295201 	sfmmi	f5, 4, [r9, #-4]!
    15cc:	02000000 	andeq	r0, r0, #0
    15d0:	3d226891 	stccc	8, cr6, [r2, #-580]!	; 0xfffffdbc
    15d4:	01000010 	tsteq	r0, r0, lsl r0
    15d8:	004d0e54 	subeq	r0, sp, r4, asr lr
    15dc:	91020000 	mrsls	r0, (UNDEF: 2)
    15e0:	37250074 			; <UNDEFINED> instruction: 0x37250074
    15e4:	01000010 	tsteq	r0, r0, lsl r0
    15e8:	10190a45 	andsne	r0, r9, r5, asr #20
    15ec:	004d0000 	subeq	r0, sp, r0
    15f0:	84000000 	strhi	r0, [r0], #-0
    15f4:	00500000 	subseq	r0, r0, r0
    15f8:	9c010000 	stcls	0, cr0, [r1], {-0}
    15fc:	00000b39 	andeq	r0, r0, r9, lsr fp
    1600:	000fad24 	andeq	sl, pc, r4, lsr #26
    1604:	19450100 	stmdbne	r5, {r8}^
    1608:	0000004d 	andeq	r0, r0, sp, asr #32
    160c:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1610:	00000ee0 	andeq	r0, r0, r0, ror #29
    1614:	1d304501 	cfldr32ne	mvfx4, [r0, #-4]!
    1618:	02000001 	andeq	r0, r0, #1
    161c:	47246891 			; <UNDEFINED> instruction: 0x47246891
    1620:	0100000f 	tsteq	r0, pc
    1624:	08584145 	ldmdaeq	r8, {r0, r2, r6, r8, lr}^
    1628:	91020000 	mrsls	r0, (UNDEF: 2)
    162c:	10772264 	rsbsne	r2, r7, r4, ror #4
    1630:	47010000 	strmi	r0, [r1, -r0]
    1634:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1638:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    163c:	0c832700 	stceq	7, cr2, [r3], {0}
    1640:	3f010000 	svccc	0x00010000
    1644:	000eea06 	andeq	lr, lr, r6, lsl #20
    1648:	0083d400 	addeq	sp, r3, r0, lsl #8
    164c:	00002c00 	andeq	r2, r0, r0, lsl #24
    1650:	639c0100 	orrsvs	r0, ip, #0, 2
    1654:	2400000b 	strcs	r0, [r0], #-11
    1658:	00000fad 	andeq	r0, r0, sp, lsr #31
    165c:	4d153f01 	ldcmi	15, cr3, [r5, #-4]
    1660:	02000000 	andeq	r0, r0, #0
    1664:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1668:	00000f7f 	andeq	r0, r0, pc, ror pc
    166c:	4d0a3201 	sfmmi	f3, 4, [sl, #-4]
    1670:	4d00000f 	stcmi	0, cr0, [r0, #-60]	; 0xffffffc4
    1674:	84000000 	strhi	r0, [r0], #-0
    1678:	50000083 	andpl	r0, r0, r3, lsl #1
    167c:	01000000 	mrseq	r0, (UNDEF: 0)
    1680:	000bbe9c 	muleq	fp, ip, lr
    1684:	0fad2400 	svceq	0x00ad2400
    1688:	32010000 	andcc	r0, r1, #0
    168c:	00004d19 	andeq	r4, r0, r9, lsl sp
    1690:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1694:	00105324 	andseq	r5, r0, r4, lsr #6
    1698:	2b320100 	blcs	c81aa0 <__bss_end+0xc78c74>
    169c:	0000037b 	andeq	r0, r0, fp, ror r3
    16a0:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    16a4:	00000f7a 	andeq	r0, r0, sl, ror pc
    16a8:	4d3c3201 	lfmmi	f3, 4, [ip, #-4]!
    16ac:	02000000 	andeq	r0, r0, #0
    16b0:	08226491 	stmdaeq	r2!, {r0, r4, r7, sl, sp, lr}
    16b4:	01000010 	tsteq	r0, r0, lsl r0
    16b8:	004d0e34 	subeq	r0, sp, r4, lsr lr
    16bc:	91020000 	mrsls	r0, (UNDEF: 2)
    16c0:	a1250074 			; <UNDEFINED> instruction: 0xa1250074
    16c4:	01000010 	tsteq	r0, r0, lsl r0
    16c8:	105a0a25 	subsne	r0, sl, r5, lsr #20
    16cc:	004d0000 	subeq	r0, sp, r0
    16d0:	83340000 	teqhi	r4, #0
    16d4:	00500000 	subseq	r0, r0, r0
    16d8:	9c010000 	stcls	0, cr0, [r1], {-0}
    16dc:	00000c19 	andeq	r0, r0, r9, lsl ip
    16e0:	000fad24 	andeq	sl, pc, r4, lsr #26
    16e4:	18250100 	stmdane	r5!, {r8}
    16e8:	0000004d 	andeq	r0, r0, sp, asr #32
    16ec:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    16f0:	00001053 	andeq	r1, r0, r3, asr r0
    16f4:	1f2a2501 	svcne	0x002a2501
    16f8:	0200000c 	andeq	r0, r0, #12
    16fc:	7a246891 	bvc	91b948 <__bss_end+0x912b1c>
    1700:	0100000f 	tsteq	r0, pc
    1704:	004d3b25 	subeq	r3, sp, r5, lsr #22
    1708:	91020000 	mrsls	r0, (UNDEF: 2)
    170c:	0d8a2264 	sfmeq	f2, 4, [sl, #400]	; 0x190
    1710:	27010000 	strcs	r0, [r1, -r0]
    1714:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1718:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    171c:	25041800 	strcs	r1, [r4, #-2048]	; 0xfffff800
    1720:	03000000 	movweq	r0, #0
    1724:	00000c19 	andeq	r0, r0, r9, lsl ip
    1728:	000f1225 	andeq	r1, pc, r5, lsr #4
    172c:	0a190100 	beq	641b34 <__bss_end+0x638d08>
    1730:	000010ad 	andeq	r1, r0, sp, lsr #1
    1734:	0000004d 	andeq	r0, r0, sp, asr #32
    1738:	000082f0 	strdeq	r8, [r0], -r0
    173c:	00000044 	andeq	r0, r0, r4, asr #32
    1740:	0c709c01 	ldcleq	12, cr9, [r0], #-4
    1744:	98240000 	stmdals	r4!, {}	; <UNPREDICTABLE>
    1748:	01000010 	tsteq	r0, r0, lsl r0
    174c:	037b1b19 	cmneq	fp, #25600	; 0x6400
    1750:	91020000 	mrsls	r0, (UNDEF: 2)
    1754:	104e246c 	subne	r2, lr, ip, ror #8
    1758:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    175c:	0001c635 	andeq	ip, r1, r5, lsr r6
    1760:	68910200 	ldmvs	r1, {r9}
    1764:	000fad22 	andeq	sl, pc, r2, lsr #26
    1768:	0e1b0100 	mufeqe	f0, f3, f0
    176c:	0000004d 	andeq	r0, r0, sp, asr #32
    1770:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1774:	000e4328 	andeq	r4, lr, r8, lsr #6
    1778:	06140100 	ldreq	r0, [r4], -r0, lsl #2
    177c:	00000d90 	muleq	r0, r0, sp
    1780:	000082d4 	ldrdeq	r8, [r0], -r4
    1784:	0000001c 	andeq	r0, r0, ip, lsl r0
    1788:	44279c01 	strtmi	r9, [r7], #-3073	; 0xfffff3ff
    178c:	01000010 	tsteq	r0, r0, lsl r0
    1790:	0dc9060e 	stcleq	6, cr0, [r9, #56]	; 0x38
    1794:	82a80000 	adchi	r0, r8, #0
    1798:	002c0000 	eoreq	r0, ip, r0
    179c:	9c010000 	stcls	0, cr0, [r1], {-0}
    17a0:	00000cb0 			; <UNDEFINED> instruction: 0x00000cb0
    17a4:	000e1c24 	andeq	r1, lr, r4, lsr #24
    17a8:	140e0100 	strne	r0, [lr], #-256	; 0xffffff00
    17ac:	00000038 	andeq	r0, r0, r8, lsr r0
    17b0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    17b4:	0010a629 	andseq	sl, r0, r9, lsr #12
    17b8:	0a040100 	beq	101bc0 <__bss_end+0xf8d94>
    17bc:	00000ef4 	strdeq	r0, [r0], -r4
    17c0:	0000004d 	andeq	r0, r0, sp, asr #32
    17c4:	0000827c 	andeq	r8, r0, ip, ror r2
    17c8:	0000002c 	andeq	r0, r0, ip, lsr #32
    17cc:	70269c01 	eorvc	r9, r6, r1, lsl #24
    17d0:	01006469 	tsteq	r0, r9, ror #8
    17d4:	004d0e06 	subeq	r0, sp, r6, lsl #28
    17d8:	91020000 	mrsls	r0, (UNDEF: 2)
    17dc:	2e000074 	mcrcs	0, 0, r0, cr0, cr4, {3}
    17e0:	04000003 	streq	r0, [r0], #-3
    17e4:	00068800 	andeq	r8, r6, r0, lsl #16
    17e8:	96010400 	strls	r0, [r1], -r0, lsl #8
    17ec:	0400000c 	streq	r0, [r0], #-12
    17f0:	000010ed 	andeq	r1, r0, sp, ror #1
    17f4:	00000e99 	muleq	r0, r9, lr
    17f8:	000086dc 	ldrdeq	r8, [r0], -ip
    17fc:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
    1800:	0000066e 	andeq	r0, r0, lr, ror #12
    1804:	00004902 	andeq	r4, r0, r2, lsl #18
    1808:	112f0300 			; <UNDEFINED> instruction: 0x112f0300
    180c:	05010000 	streq	r0, [r1, #-0]
    1810:	00006110 	andeq	r6, r0, r0, lsl r1
    1814:	31301100 	teqcc	r0, r0, lsl #2
    1818:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
    181c:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
    1820:	44434241 	strbmi	r4, [r3], #-577	; 0xfffffdbf
    1824:	00004645 	andeq	r4, r0, r5, asr #12
    1828:	01030104 	tsteq	r3, r4, lsl #2
    182c:	00000025 	andeq	r0, r0, r5, lsr #32
    1830:	00007405 	andeq	r7, r0, r5, lsl #8
    1834:	00006100 	andeq	r6, r0, r0, lsl #2
    1838:	00660600 	rsbeq	r0, r6, r0, lsl #12
    183c:	00100000 	andseq	r0, r0, r0
    1840:	00005107 	andeq	r5, r0, r7, lsl #2
    1844:	07040800 	streq	r0, [r4, -r0, lsl #16]
    1848:	000016b6 			; <UNDEFINED> instruction: 0x000016b6
    184c:	a1080108 	tstge	r8, r8, lsl #2
    1850:	07000007 	streq	r0, [r0, -r7]
    1854:	0000006d 	andeq	r0, r0, sp, rrx
    1858:	00002a09 	andeq	r2, r0, r9, lsl #20
    185c:	115e0a00 	cmpne	lr, r0, lsl #20
    1860:	64010000 	strvs	r0, [r1], #-0
    1864:	00114906 	andseq	r4, r1, r6, lsl #18
    1868:	008b1400 	addeq	r1, fp, r0, lsl #8
    186c:	00008000 	andeq	r8, r0, r0
    1870:	fb9c0100 	blx	fe701c7a <__bss_end+0xfe6f8e4e>
    1874:	0b000000 	bleq	187c <shift+0x187c>
    1878:	00637273 	rsbeq	r7, r3, r3, ror r2
    187c:	fb196401 	blx	65a88a <__bss_end+0x651a5e>
    1880:	02000000 	andeq	r0, r0, #0
    1884:	640b6491 	strvs	r6, [fp], #-1169	; 0xfffffb6f
    1888:	01007473 	tsteq	r0, r3, ror r4
    188c:	01022464 	tsteq	r2, r4, ror #8
    1890:	91020000 	mrsls	r0, (UNDEF: 2)
    1894:	756e0b60 	strbvc	r0, [lr, #-2912]!	; 0xfffff4a0
    1898:	6401006d 	strvs	r0, [r1], #-109	; 0xffffff93
    189c:	0001042d 	andeq	r0, r1, sp, lsr #8
    18a0:	5c910200 	lfmpl	f0, 4, [r1], {0}
    18a4:	0011c30c 	andseq	ip, r1, ip, lsl #6
    18a8:	0e660100 	poweqs	f0, f6, f0
    18ac:	0000010b 	andeq	r0, r0, fp, lsl #2
    18b0:	0c709102 	ldfeqp	f1, [r0], #-8
    18b4:	0000113b 	andeq	r1, r0, fp, lsr r1
    18b8:	11086701 	tstne	r8, r1, lsl #14
    18bc:	02000001 	andeq	r0, r0, #1
    18c0:	3c0d6c91 	stccc	12, cr6, [sp], {145}	; 0x91
    18c4:	4800008b 	stmdami	r0, {r0, r1, r3, r7}
    18c8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    18cc:	69010069 	stmdbvs	r1, {r0, r3, r5, r6}
    18d0:	0001040b 	andeq	r0, r1, fp, lsl #8
    18d4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    18d8:	040f0000 	streq	r0, [pc], #-0	; 18e0 <shift+0x18e0>
    18dc:	00000101 	andeq	r0, r0, r1, lsl #2
    18e0:	12041110 	andne	r1, r4, #16, 2
    18e4:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    18e8:	040f0074 	streq	r0, [pc], #-116	; 18f0 <shift+0x18f0>
    18ec:	00000074 	andeq	r0, r0, r4, ror r0
    18f0:	006d040f 	rsbeq	r0, sp, pc, lsl #8
    18f4:	d40a0000 	strle	r0, [sl], #-0
    18f8:	01000010 	tsteq	r0, r0, lsl r0
    18fc:	10e1065c 	rscne	r0, r1, ip, asr r6
    1900:	8aac0000 	bhi	feb01908 <__bss_end+0xfeaf8adc>
    1904:	00680000 	rsbeq	r0, r8, r0
    1908:	9c010000 	stcls	0, cr0, [r1], {-0}
    190c:	00000176 	andeq	r0, r0, r6, ror r1
    1910:	0011bc13 	andseq	fp, r1, r3, lsl ip
    1914:	125c0100 	subsne	r0, ip, #0, 2
    1918:	00000102 	andeq	r0, r0, r2, lsl #2
    191c:	136c9102 	cmnne	ip, #-2147483648	; 0x80000000
    1920:	000010da 	ldrdeq	r1, [r0], -sl
    1924:	041e5c01 	ldreq	r5, [lr], #-3073	; 0xfffff3ff
    1928:	02000001 	andeq	r0, r0, #1
    192c:	6d0e6891 	stcvs	8, cr6, [lr, #-580]	; 0xfffffdbc
    1930:	01006d65 	tsteq	r0, r5, ror #26
    1934:	0111085e 	tsteq	r1, lr, asr r8
    1938:	91020000 	mrsls	r0, (UNDEF: 2)
    193c:	8ac80d70 	bhi	ff204f04 <__bss_end+0xff1fc0d8>
    1940:	003c0000 	eorseq	r0, ip, r0
    1944:	690e0000 	stmdbvs	lr, {}	; <UNPREDICTABLE>
    1948:	0b600100 	bleq	1801d50 <__bss_end+0x17f8f24>
    194c:	00000104 	andeq	r0, r0, r4, lsl #2
    1950:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1954:	11651400 	cmnne	r5, r0, lsl #8
    1958:	52010000 	andpl	r0, r1, #0
    195c:	00117e05 	andseq	r7, r1, r5, lsl #28
    1960:	00010400 	andeq	r0, r1, r0, lsl #8
    1964:	008a5800 	addeq	r5, sl, r0, lsl #16
    1968:	00005400 	andeq	r5, r0, r0, lsl #8
    196c:	af9c0100 	svcge	0x009c0100
    1970:	0b000001 	bleq	197c <shift+0x197c>
    1974:	52010073 	andpl	r0, r1, #115	; 0x73
    1978:	00010b18 	andeq	r0, r1, r8, lsl fp
    197c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1980:	0100690e 	tsteq	r0, lr, lsl #18
    1984:	01040654 	tsteq	r4, r4, asr r6
    1988:	91020000 	mrsls	r0, (UNDEF: 2)
    198c:	ac140074 	ldcge	0, cr0, [r4], {116}	; 0x74
    1990:	01000011 	tsteq	r0, r1, lsl r0
    1994:	116c0542 	cmnne	ip, r2, asr #10
    1998:	01040000 	mrseq	r0, (UNDEF: 4)
    199c:	89ac0000 	stmibhi	ip!, {}	; <UNPREDICTABLE>
    19a0:	00ac0000 	adceq	r0, ip, r0
    19a4:	9c010000 	stcls	0, cr0, [r1], {-0}
    19a8:	00000215 	andeq	r0, r0, r5, lsl r2
    19ac:	0031730b 	eorseq	r7, r1, fp, lsl #6
    19b0:	0b194201 	bleq	6521bc <__bss_end+0x649390>
    19b4:	02000001 	andeq	r0, r0, #1
    19b8:	730b6c91 	movwvc	r6, #48273	; 0xbc91
    19bc:	42010032 	andmi	r0, r1, #50	; 0x32
    19c0:	00010b29 	andeq	r0, r1, r9, lsr #22
    19c4:	68910200 	ldmvs	r1, {r9}
    19c8:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    19cc:	31420100 	mrscc	r0, (UNDEF: 82)
    19d0:	00000104 	andeq	r0, r0, r4, lsl #2
    19d4:	0e649102 	lgneqs	f1, f2
    19d8:	01003175 	tsteq	r0, r5, ror r1
    19dc:	02151044 	andseq	r1, r5, #68	; 0x44
    19e0:	91020000 	mrsls	r0, (UNDEF: 2)
    19e4:	32750e77 	rsbscc	r0, r5, #1904	; 0x770
    19e8:	14440100 	strbne	r0, [r4], #-256	; 0xffffff00
    19ec:	00000215 	andeq	r0, r0, r5, lsl r2
    19f0:	00769102 	rsbseq	r9, r6, r2, lsl #2
    19f4:	98080108 	stmdals	r8, {r3, r8}
    19f8:	14000007 	strne	r0, [r0], #-7
    19fc:	000011b4 			; <UNDEFINED> instruction: 0x000011b4
    1a00:	9b073601 	blls	1cf20c <__bss_end+0x1c63e0>
    1a04:	11000011 	tstne	r0, r1, lsl r0
    1a08:	ec000001 	stc	0, cr0, [r0], {1}
    1a0c:	c0000088 	andgt	r0, r0, r8, lsl #1
    1a10:	01000000 	mrseq	r0, (UNDEF: 0)
    1a14:	0002759c 	muleq	r2, ip, r5
    1a18:	10cf1300 	sbcne	r1, pc, r0, lsl #6
    1a1c:	36010000 	strcc	r0, [r1], -r0
    1a20:	00011115 	andeq	r1, r1, r5, lsl r1
    1a24:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1a28:	6372730b 	cmnvs	r2, #738197504	; 0x2c000000
    1a2c:	27360100 	ldrcs	r0, [r6, -r0, lsl #2]!
    1a30:	0000010b 	andeq	r0, r0, fp, lsl #2
    1a34:	0b689102 	bleq	1a25e44 <__bss_end+0x1a1d018>
    1a38:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1a3c:	04303601 	ldrteq	r3, [r0], #-1537	; 0xfffff9ff
    1a40:	02000001 	andeq	r0, r0, #1
    1a44:	690e6491 	stmdbvs	lr, {r0, r4, r7, sl, sp, lr}
    1a48:	06380100 	ldrteq	r0, [r8], -r0, lsl #2
    1a4c:	00000104 	andeq	r0, r0, r4, lsl #2
    1a50:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1a54:	00118b14 	andseq	r8, r1, r4, lsl fp
    1a58:	05240100 	streq	r0, [r4, #-256]!	; 0xffffff00
    1a5c:	00001190 	muleq	r0, r0, r1
    1a60:	00000104 	andeq	r0, r0, r4, lsl #2
    1a64:	00008850 	andeq	r8, r0, r0, asr r8
    1a68:	0000009c 	muleq	r0, ip, r0
    1a6c:	02b29c01 	adcseq	r9, r2, #256	; 0x100
    1a70:	c9130000 	ldmdbgt	r3, {}	; <UNPREDICTABLE>
    1a74:	01000010 	tsteq	r0, r0, lsl r0
    1a78:	010b1624 	tsteq	fp, r4, lsr #12
    1a7c:	91020000 	mrsls	r0, (UNDEF: 2)
    1a80:	11420c6c 	cmpne	r2, ip, ror #24
    1a84:	26010000 	strcs	r0, [r1], -r0
    1a88:	00010406 	andeq	r0, r1, r6, lsl #8
    1a8c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1a90:	11ca1500 	bicne	r1, sl, r0, lsl #10
    1a94:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1a98:	0011cf06 	andseq	ip, r1, r6, lsl #30
    1a9c:	0086dc00 	addeq	sp, r6, r0, lsl #24
    1aa0:	00017400 	andeq	r7, r1, r0, lsl #8
    1aa4:	139c0100 	orrsne	r0, ip, #0, 2
    1aa8:	000010c9 	andeq	r1, r0, r9, asr #1
    1aac:	66180801 	ldrvs	r0, [r8], -r1, lsl #16
    1ab0:	02000000 	andeq	r0, r0, #0
    1ab4:	42136491 	andsmi	r6, r3, #-1862270976	; 0x91000000
    1ab8:	01000011 	tsteq	r0, r1, lsl r0
    1abc:	01112508 	tsteq	r1, r8, lsl #10
    1ac0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ac4:	11591360 	cmpne	r9, r0, ror #6
    1ac8:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    1acc:	0000663a 	andeq	r6, r0, sl, lsr r6
    1ad0:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1ad4:	0100690e 	tsteq	r0, lr, lsl #18
    1ad8:	0104060a 	tsteq	r4, sl, lsl #12
    1adc:	91020000 	mrsls	r0, (UNDEF: 2)
    1ae0:	87a80d74 			; <UNDEFINED> instruction: 0x87a80d74
    1ae4:	00980000 	addseq	r0, r8, r0
    1ae8:	6a0e0000 	bvs	381af0 <__bss_end+0x378cc4>
    1aec:	0b1c0100 	bleq	701ef4 <__bss_end+0x6f90c8>
    1af0:	00000104 	andeq	r0, r0, r4, lsl #2
    1af4:	0d709102 	ldfeqp	f1, [r0, #-8]!
    1af8:	000087d0 	ldrdeq	r8, [r0], -r0
    1afc:	00000060 	andeq	r0, r0, r0, rrx
    1b00:	0100630e 	tsteq	r0, lr, lsl #6
    1b04:	006d081e 	rsbeq	r0, sp, lr, lsl r8
    1b08:	91020000 	mrsls	r0, (UNDEF: 2)
    1b0c:	0000006f 	andeq	r0, r0, pc, rrx
    1b10:	00002200 	andeq	r2, r0, r0, lsl #4
    1b14:	af000200 	svcge	0x00000200
    1b18:	04000007 	streq	r0, [r0], #-7
    1b1c:	0008a401 	andeq	sl, r8, r1, lsl #8
    1b20:	008b9400 	addeq	r9, fp, r0, lsl #8
    1b24:	008da000 	addeq	sl, sp, r0
    1b28:	0011db00 	andseq	sp, r1, r0, lsl #22
    1b2c:	00120b00 	andseq	r0, r2, r0, lsl #22
    1b30:	00127000 	andseq	r7, r2, r0
    1b34:	22800100 	addcs	r0, r0, #0, 2
    1b38:	02000000 	andeq	r0, r0, #0
    1b3c:	0007c300 	andeq	ip, r7, r0, lsl #6
    1b40:	21010400 	tstcs	r1, r0, lsl #8
    1b44:	a0000009 	andge	r0, r0, r9
    1b48:	a400008d 	strge	r0, [r0], #-141	; 0xffffff73
    1b4c:	db00008d 	blle	1d88 <shift+0x1d88>
    1b50:	0b000011 	bleq	1b9c <shift+0x1b9c>
    1b54:	70000012 	andvc	r0, r0, r2, lsl r0
    1b58:	01000012 	tsteq	r0, r2, lsl r0
    1b5c:	000a0980 	andeq	r0, sl, r0, lsl #19
    1b60:	d7000400 	strle	r0, [r0, -r0, lsl #8]
    1b64:	04000007 	streq	r0, [r0], #-7
    1b68:	00231001 	eoreq	r1, r3, r1
    1b6c:	15520c00 	ldrbne	r0, [r2, #-3072]	; 0xfffff400
    1b70:	120b0000 	andne	r0, fp, #0
    1b74:	09810000 	stmibeq	r1, {}	; <UNPREDICTABLE>
    1b78:	04020000 	streq	r0, [r2], #-0
    1b7c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1b80:	07040300 	streq	r0, [r4, -r0, lsl #6]
    1b84:	000016b6 			; <UNDEFINED> instruction: 0x000016b6
    1b88:	5f050803 	svcpl	0x00050803
    1b8c:	03000003 	movweq	r0, #3
    1b90:	1e570408 	cdpne	4, 5, cr0, cr7, cr8, {0}
    1b94:	bf040000 	svclt	0x00040000
    1b98:	01000015 	tsteq	r0, r5, lsl r0
    1b9c:	0024162a 	eoreq	r1, r4, sl, lsr #12
    1ba0:	22040000 	andcs	r0, r4, #0
    1ba4:	0100001a 	tsteq	r0, sl, lsl r0
    1ba8:	0051152f 	subseq	r1, r1, pc, lsr #10
    1bac:	04050000 	streq	r0, [r5], #-0
    1bb0:	00000057 	andeq	r0, r0, r7, asr r0
    1bb4:	00003906 	andeq	r3, r0, r6, lsl #18
    1bb8:	00006600 	andeq	r6, r0, r0, lsl #12
    1bbc:	00660700 	rsbeq	r0, r6, r0, lsl #14
    1bc0:	05000000 	streq	r0, [r0, #-0]
    1bc4:	00006c04 	andeq	r6, r0, r4, lsl #24
    1bc8:	c1040800 	tstgt	r4, r0, lsl #16
    1bcc:	01000022 	tsteq	r0, r2, lsr #32
    1bd0:	00790f36 	rsbseq	r0, r9, r6, lsr pc
    1bd4:	04050000 	streq	r0, [r5], #-0
    1bd8:	0000007f 	andeq	r0, r0, pc, ror r0
    1bdc:	00001d06 	andeq	r1, r0, r6, lsl #26
    1be0:	00009300 	andeq	r9, r0, r0, lsl #6
    1be4:	00660700 	rsbeq	r0, r6, r0, lsl #14
    1be8:	66070000 	strvs	r0, [r7], -r0
    1bec:	00000000 	andeq	r0, r0, r0
    1bf0:	98080103 	stmdals	r8, {r0, r1, r8}
    1bf4:	09000007 	stmdbeq	r0, {r0, r1, r2}
    1bf8:	00001c85 	andeq	r1, r0, r5, lsl #25
    1bfc:	4512bb01 	ldrmi	fp, [r2, #-2817]	; 0xfffff4ff
    1c00:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    1c04:	000022ef 	andeq	r2, r0, pc, ror #5
    1c08:	6d10be01 	ldcvs	14, cr11, [r0, #-4]
    1c0c:	03000000 	movweq	r0, #0
    1c10:	079a0601 	ldreq	r0, [sl, r1, lsl #12]
    1c14:	290a0000 	stmdbcs	sl, {}	; <UNPREDICTABLE>
    1c18:	07000019 	smladeq	r0, r9, r0, r0
    1c1c:	00009301 	andeq	r9, r0, r1, lsl #6
    1c20:	06170200 	ldreq	r0, [r7], -r0, lsl #4
    1c24:	000001e6 	andeq	r0, r0, r6, ror #3
    1c28:	0014260b 	andseq	r2, r4, fp, lsl #12
    1c2c:	210b0000 	mrscs	r0, (UNDEF: 11)
    1c30:	01000018 	tsteq	r0, r8, lsl r0
    1c34:	001d7d0b 	andseq	r7, sp, fp, lsl #26
    1c38:	050b0200 	streq	r0, [fp, #-512]	; 0xfffffe00
    1c3c:	03000022 	movweq	r0, #34	; 0x22
    1c40:	001d090b 	andseq	r0, sp, fp, lsl #18
    1c44:	cc0b0400 	cfstrsgt	mvf0, [fp], {-0}
    1c48:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    1c4c:	001ff20b 	andseq	pc, pc, fp, lsl #4
    1c50:	470b0600 	strmi	r0, [fp, -r0, lsl #12]
    1c54:	07000014 	smladeq	r0, r4, r0, r0
    1c58:	0020e10b 	eoreq	lr, r0, fp, lsl #2
    1c5c:	ef0b0800 	svc	0x000b0800
    1c60:	09000020 	stmdbeq	r0, {r5}
    1c64:	0021e00b 	eoreq	lr, r1, fp
    1c68:	4b0b0a00 	blmi	2c4470 <__bss_end+0x2bb644>
    1c6c:	0b00001c 	bleq	1ce4 <shift+0x1ce4>
    1c70:	0016000b 	andseq	r0, r6, fp
    1c74:	b20b0c00 	andlt	r0, fp, #0, 24
    1c78:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
    1c7c:	0021380b 	eoreq	r3, r1, fp, lsl #16
    1c80:	6d0b0e00 	stcvs	14, cr0, [fp, #-0]
    1c84:	0f000019 	svceq	0x00000019
    1c88:	0019830b 	andseq	r8, r9, fp, lsl #6
    1c8c:	580b1000 	stmdapl	fp, {ip}
    1c90:	11000018 	tstne	r0, r8, lsl r0
    1c94:	001ced0b 	andseq	lr, ip, fp, lsl #26
    1c98:	e50b1200 	str	r1, [fp, #-512]	; 0xfffffe00
    1c9c:	13000018 	movwne	r0, #24
    1ca0:	00259d0b 	eoreq	r9, r5, fp, lsl #26
    1ca4:	b50b1400 	strlt	r1, [fp, #-1024]	; 0xfffffc00
    1ca8:	1500001d 	strne	r0, [r0, #-29]	; 0xffffffe3
    1cac:	001b120b 	andseq	r1, fp, fp, lsl #4
    1cb0:	a40b1600 	strge	r1, [fp], #-1536	; 0xfffffa00
    1cb4:	17000014 	smladne	r0, r4, r0, r0
    1cb8:	0022280b 	eoreq	r2, r2, fp, lsl #16
    1cbc:	320b1800 	andcc	r1, fp, #0, 16
    1cc0:	19000024 	stmdbne	r0, {r2, r5}
    1cc4:	0022360b 	eoreq	r3, r2, fp, lsl #12
    1cc8:	350b1a00 	strcc	r1, [fp, #-2560]	; 0xfffff600
    1ccc:	1b000019 	blne	1d38 <shift+0x1d38>
    1cd0:	0022440b 	eoreq	r4, r2, fp, lsl #8
    1cd4:	000b1c00 	andeq	r1, fp, r0, lsl #24
    1cd8:	1d000013 	stcne	0, cr0, [r0, #-76]	; 0xffffffb4
    1cdc:	0022520b 	eoreq	r5, r2, fp, lsl #4
    1ce0:	600b1e00 	andvs	r1, fp, r0, lsl #28
    1ce4:	1f000022 	svcne	0x00000022
    1ce8:	0012990b 	andseq	r9, r2, fp, lsl #18
    1cec:	d80b2000 	stmdale	fp, {sp}
    1cf0:	2100001e 	tstcs	r0, lr, lsl r0
    1cf4:	001cbf0b 	andseq	fp, ip, fp, lsl #30
    1cf8:	1b0b2200 	blne	2ca500 <__bss_end+0x2c16d4>
    1cfc:	23000022 	movwcs	r0, #34	; 0x22
    1d00:	001b8f0b 	andseq	r8, fp, fp, lsl #30
    1d04:	e30b2400 	movw	r2, #46080	; 0xb400
    1d08:	2500001f 	strcs	r0, [r0, #-31]	; 0xffffffe1
    1d0c:	001a850b 	andseq	r8, sl, fp, lsl #10
    1d10:	610b2600 	tstvs	fp, r0, lsl #12
    1d14:	27000017 	smladcs	r0, r7, r0, r0
    1d18:	001aa30b 	andseq	sl, sl, fp, lsl #6
    1d1c:	fd0b2800 	stc2	8, cr2, [fp, #-0]
    1d20:	29000017 	stmdbcs	r0, {r0, r1, r2, r4}
    1d24:	001ab30b 	andseq	fp, sl, fp, lsl #6
    1d28:	310b2a00 	tstcc	fp, r0, lsl #20
    1d2c:	2b00001c 	blcs	1da4 <shift+0x1da4>
    1d30:	001a2c0b 	andseq	r2, sl, fp, lsl #24
    1d34:	f70b2c00 			; <UNDEFINED> instruction: 0xf70b2c00
    1d38:	2d00001e 	stccs	0, cr0, [r0, #-120]	; 0xffffff88
    1d3c:	0017a20b 	andseq	sl, r7, fp, lsl #4
    1d40:	0a002e00 	beq	d548 <__bss_end+0x471c>
    1d44:	000019bf 			; <UNDEFINED> instruction: 0x000019bf
    1d48:	00930107 	addseq	r0, r3, r7, lsl #2
    1d4c:	17030000 	strne	r0, [r3, -r0]
    1d50:	00049f06 	andeq	r9, r4, r6, lsl #30
    1d54:	16140b00 	ldrne	r0, [r4], -r0, lsl #22
    1d58:	0b000000 	bleq	1d60 <shift+0x1d60>
    1d5c:	000024c6 	andeq	r2, r0, r6, asr #9
    1d60:	16240b01 	strtne	r0, [r4], -r1, lsl #22
    1d64:	0b020000 	bleq	81d6c <__bss_end+0x78f40>
    1d68:	00001647 	andeq	r1, r0, r7, asr #12
    1d6c:	22ff0b03 	rscscs	r0, pc, #3072	; 0xc00
    1d70:	0b040000 	bleq	101d78 <__bss_end+0xf8f4c>
    1d74:	00001f5d 	andeq	r1, r0, sp, asr pc
    1d78:	16d10b05 	ldrbne	r0, [r1], r5, lsl #22
    1d7c:	0b060000 	bleq	181d84 <__bss_end+0x178f58>
    1d80:	00001846 	andeq	r1, r0, r6, asr #16
    1d84:	16570b07 	ldrbne	r0, [r7], -r7, lsl #22
    1d88:	0b080000 	bleq	201d90 <__bss_end+0x1f8f64>
    1d8c:	0000258c 	andeq	r2, r0, ip, lsl #11
    1d90:	13770b09 	cmnne	r7, #9216	; 0x2400
    1d94:	0b0a0000 	bleq	281d9c <__bss_end+0x278f70>
    1d98:	000024b5 			; <UNDEFINED> instruction: 0x000024b5
    1d9c:	1b9e0b0b 	blne	fe7849d0 <__bss_end+0xfe77bba4>
    1da0:	0b0c0000 	bleq	301da8 <__bss_end+0x2f8f7c>
    1da4:	00002449 	andeq	r2, r0, r9, asr #8
    1da8:	1ee50b0d 	vfmane.f64	d16, d5, d13
    1dac:	0b0e0000 	bleq	381db4 <__bss_end+0x378f88>
    1db0:	0000217e 	andeq	r2, r0, lr, ror r1
    1db4:	17320b0f 	ldrne	r0, [r2, -pc, lsl #22]!
    1db8:	0b100000 	bleq	401dc0 <__bss_end+0x3f8f94>
    1dbc:	00001634 	andeq	r1, r0, r4, lsr r6
    1dc0:	1e9d0b11 	vmovne.32	r0, d13[0]
    1dc4:	0b120000 	bleq	481dcc <__bss_end+0x478fa0>
    1dc8:	0000171d 	andeq	r1, r0, sp, lsl r7
    1dcc:	24a40b13 	strtcs	r0, [r4], #2835	; 0xb13
    1dd0:	0b140000 	bleq	501dd8 <__bss_end+0x4f8fac>
    1dd4:	000013a1 	andeq	r1, r0, r1, lsr #7
    1dd8:	1aed0b15 	bne	ffb44a34 <__bss_end+0xffb3bc08>
    1ddc:	0b160000 	bleq	581de4 <__bss_end+0x578fb8>
    1de0:	00001667 	andeq	r1, r0, r7, ror #12
    1de4:	133e0b17 	teqne	lr, #23552	; 0x5c00
    1de8:	0b180000 	bleq	601df0 <__bss_end+0x5f8fc4>
    1dec:	00002532 	andeq	r2, r0, r2, lsr r5
    1df0:	21ed0b19 	mvncs	r0, r9, lsl fp
    1df4:	0b1a0000 	bleq	681dfc <__bss_end+0x678fd0>
    1df8:	00002001 	andeq	r2, r0, r1
    1dfc:	21650b1b 	cmncs	r5, fp, lsl fp
    1e00:	0b1c0000 	bleq	701e08 <__bss_end+0x6f8fdc>
    1e04:	000022c9 	andeq	r2, r0, r9, asr #5
    1e08:	16870b1d 	pkhbtne	r0, r7, sp, lsl #22
    1e0c:	0b1e0000 	bleq	781e14 <__bss_end+0x778fe8>
    1e10:	00001412 	andeq	r1, r0, r2, lsl r4
    1e14:	201a0b1f 	andscs	r0, sl, pc, lsl fp
    1e18:	0b200000 	bleq	801e20 <__bss_end+0x7f8ff4>
    1e1c:	0000177e 	andeq	r1, r0, lr, ror r7
    1e20:	1f6f0b21 	svcne	0x006f0b21
    1e24:	0b220000 	bleq	881e2c <__bss_end+0x879000>
    1e28:	00001b6f 	andeq	r1, r0, pc, ror #22
    1e2c:	16770b23 	ldrbtne	r0, [r7], -r3, lsr #22
    1e30:	0b240000 	bleq	901e38 <__bss_end+0x8f900c>
    1e34:	0000211d 	andeq	r2, r0, sp, lsl r1
    1e38:	158a0b25 	strne	r0, [sl, #2853]	; 0xb25
    1e3c:	0b260000 	bleq	981e44 <__bss_end+0x979018>
    1e40:	000022ae 	andeq	r2, r0, lr, lsr #5
    1e44:	25790b27 	ldrbcs	r0, [r9, #-2855]!	; 0xfffff4d9
    1e48:	0b280000 	bleq	a01e50 <__bss_end+0x9f9024>
    1e4c:	00001e70 	andeq	r1, r0, r0, ror lr
    1e50:	19170b29 	ldmdbne	r7, {r0, r3, r5, r8, r9, fp}
    1e54:	0b2a0000 	bleq	a81e5c <__bss_end+0xa79030>
    1e58:	00002044 	andeq	r2, r0, r4, asr #32
    1e5c:	1bcd0b2b 	blne	ff344b10 <__bss_end+0xff33bce4>
    1e60:	0b2c0000 	bleq	b01e68 <__bss_end+0xaf903c>
    1e64:	00001465 	andeq	r1, r0, r5, ror #8
    1e68:	13e90b2d 	mvnne	r0, #46080	; 0xb400
    1e6c:	0b2e0000 	bleq	b81e74 <__bss_end+0xb79048>
    1e70:	00002407 	andeq	r2, r0, r7, lsl #8
    1e74:	1b5b0b2f 	blne	16c4b38 <__bss_end+0x16bbd0c>
    1e78:	0b300000 	bleq	c01e80 <__bss_end+0xbf9054>
    1e7c:	000016f7 	strdeq	r1, [r0], -r7
    1e80:	1b3a0b31 	blne	e84b4c <__bss_end+0xe7bd20>
    1e84:	0b320000 	bleq	c81e8c <__bss_end+0xc79060>
    1e88:	00001de9 	andeq	r1, r0, r9, ror #27
    1e8c:	13d70b33 	bicsne	r0, r7, #52224	; 0xcc00
    1e90:	0b340000 	bleq	d01e98 <__bss_end+0xcf906c>
    1e94:	00002567 	andeq	r2, r0, r7, ror #10
    1e98:	1c1e0b35 			; <UNDEFINED> instruction: 0x1c1e0b35
    1e9c:	0b360000 	bleq	d81ea4 <__bss_end+0xd79078>
    1ea0:	000018b0 			; <UNDEFINED> instruction: 0x000018b0
    1ea4:	1c5b0b37 	vmovne	r0, fp, d23
    1ea8:	0b380000 	bleq	e01eb0 <__bss_end+0xdf9084>
    1eac:	0000246f 	andeq	r2, r0, pc, ror #8
    1eb0:	151c0b39 	ldrne	r0, [ip, #-2873]	; 0xfffff4c7
    1eb4:	0b3a0000 	bleq	e81ebc <__bss_end+0xe79090>
    1eb8:	000018c3 	andeq	r1, r0, r3, asr #17
    1ebc:	188f0b3b 	stmne	pc, {r0, r1, r3, r4, r5, r8, r9, fp}	; <UNPREDICTABLE>
    1ec0:	0b3c0000 	bleq	f01ec8 <__bss_end+0xef909c>
    1ec4:	000012a8 	andeq	r1, r0, r8, lsr #5
    1ec8:	1bb00b3d 	blne	fec04bc4 <__bss_end+0xfebfbd98>
    1ecc:	0b3e0000 	bleq	f81ed4 <__bss_end+0xf790a8>
    1ed0:	0000198f 	andeq	r1, r0, pc, lsl #19
    1ed4:	14300b3f 	ldrtne	r0, [r0], #-2879	; 0xfffff4c1
    1ed8:	0b400000 	bleq	1001ee0 <__bss_end+0xff90b4>
    1edc:	0000241b 	andeq	r2, r0, fp, lsl r4
    1ee0:	1b000b41 	blne	4bec <shift+0x4bec>
    1ee4:	0b420000 	bleq	1081eec <__bss_end+0x10790c0>
    1ee8:	00001879 	andeq	r1, r0, r9, ror r8
    1eec:	12e90b43 	rscne	r0, r9, #68608	; 0x10c00
    1ef0:	0b440000 	bleq	1101ef8 <__bss_end+0x10f90cc>
    1ef4:	00001a5d 	andeq	r1, r0, sp, asr sl
    1ef8:	1a490b45 	bne	1244c14 <__bss_end+0x123bde8>
    1efc:	0b460000 	bleq	1181f04 <__bss_end+0x11790d8>
    1f00:	00001fc4 	andeq	r1, r0, r4, asr #31
    1f04:	208c0b47 	addcs	r0, ip, r7, asr #22
    1f08:	0b480000 	bleq	1201f10 <__bss_end+0x11f90e4>
    1f0c:	000023e6 	andeq	r2, r0, r6, ror #7
    1f10:	17af0b49 	strne	r0, [pc, r9, asr #22]!
    1f14:	0b4a0000 	bleq	1281f1c <__bss_end+0x12790f0>
    1f18:	00001d9f 	muleq	r0, pc, sp	; <UNPREDICTABLE>
    1f1c:	20590b4b 	subscs	r0, r9, fp, asr #22
    1f20:	0b4c0000 	bleq	1301f28 <__bss_end+0x12f90fc>
    1f24:	00001f06 	andeq	r1, r0, r6, lsl #30
    1f28:	1f1a0b4d 	svcne	0x001a0b4d
    1f2c:	0b4e0000 	bleq	1381f34 <__bss_end+0x1379108>
    1f30:	00001f2e 	andeq	r1, r0, lr, lsr #30
    1f34:	15aa0b4f 	strne	r0, [sl, #2895]!	; 0xb4f
    1f38:	0b500000 	bleq	1401f40 <__bss_end+0x13f9114>
    1f3c:	00001507 	andeq	r1, r0, r7, lsl #10
    1f40:	152f0b51 	strne	r0, [pc, #-2897]!	; 13f7 <shift+0x13f7>
    1f44:	0b520000 	bleq	1481f4c <__bss_end+0x1479120>
    1f48:	00002190 	muleq	r0, r0, r1
    1f4c:	15750b53 	ldrbne	r0, [r5, #-2899]!	; 0xfffff4ad
    1f50:	0b540000 	bleq	1501f58 <__bss_end+0x14f912c>
    1f54:	000021a4 	andeq	r2, r0, r4, lsr #3
    1f58:	21b80b55 			; <UNDEFINED> instruction: 0x21b80b55
    1f5c:	0b560000 	bleq	1581f64 <__bss_end+0x1579138>
    1f60:	000021cc 	andeq	r2, r0, ip, asr #3
    1f64:	17090b57 	smlsdne	r9, r7, fp, r0
    1f68:	0b580000 	bleq	1601f70 <__bss_end+0x15f9144>
    1f6c:	000016e3 	andeq	r1, r0, r3, ror #13
    1f70:	1a710b59 	bne	1c44cdc <__bss_end+0x1c3beb0>
    1f74:	0b5a0000 	bleq	1681f7c <__bss_end+0x1679150>
    1f78:	00001c6e 	andeq	r1, r0, lr, ror #24
    1f7c:	19f70b5b 	ldmibne	r7!, {r0, r1, r3, r4, r6, r8, r9, fp}^
    1f80:	0b5c0000 	bleq	1701f88 <__bss_end+0x16f915c>
    1f84:	0000127c 	andeq	r1, r0, ip, ror r2
    1f88:	18310b5d 	ldmdane	r1!, {r0, r2, r3, r4, r6, r8, r9, fp}
    1f8c:	0b5e0000 	bleq	1781f94 <__bss_end+0x1779168>
    1f90:	00001c97 	muleq	r0, r7, ip
    1f94:	1ac30b5f 	bne	ff0c4d18 <__bss_end+0xff0bbeec>
    1f98:	0b600000 	bleq	1801fa0 <__bss_end+0x17f9174>
    1f9c:	00001f82 	andeq	r1, r0, r2, lsl #31
    1fa0:	24e40b61 	strbtcs	r0, [r4], #2913	; 0xb61
    1fa4:	0b620000 	bleq	1881fac <__bss_end+0x1879180>
    1fa8:	00001d8a 	andeq	r1, r0, sl, lsl #27
    1fac:	17d40b63 	ldrbne	r0, [r4, r3, ror #22]
    1fb0:	0b640000 	bleq	1901fb8 <__bss_end+0x18f918c>
    1fb4:	00001350 	andeq	r1, r0, r0, asr r3
    1fb8:	130e0b65 	movwne	r0, #60261	; 0xeb65
    1fbc:	0b660000 	bleq	1981fc4 <__bss_end+0x1979198>
    1fc0:	00001ccf 	andeq	r1, r0, pc, asr #25
    1fc4:	1e0a0b67 	vmlsne.f64	d0, d10, d23
    1fc8:	0b680000 	bleq	1a01fd0 <__bss_end+0x19f91a4>
    1fcc:	00001fa6 	andeq	r1, r0, r6, lsr #31
    1fd0:	1ad80b69 	bne	ff604d7c <__bss_end+0xff5fbf50>
    1fd4:	0b6a0000 	bleq	1a81fdc <__bss_end+0x1a791b0>
    1fd8:	0000251d 	andeq	r2, r0, sp, lsl r5
    1fdc:	1bee0b6b 	blne	ffb84d90 <__bss_end+0xffb7bf64>
    1fe0:	0b6c0000 	bleq	1b01fe8 <__bss_end+0x1af91bc>
    1fe4:	000012cd 	andeq	r1, r0, sp, asr #5
    1fe8:	13fd0b6d 	mvnsne	r0, #111616	; 0x1b400
    1fec:	0b6e0000 	bleq	1b81ff4 <__bss_end+0x1b791c8>
    1ff0:	000017e8 	andeq	r1, r0, r8, ror #15
    1ff4:	16980b6f 	ldrne	r0, [r8], pc, ror #22
    1ff8:	00700000 	rsbseq	r0, r0, r0
    1ffc:	9d070203 	sfmls	f0, 4, [r7, #-12]
    2000:	0c000008 	stceq	0, cr0, [r0], {8}
    2004:	000004bc 			; <UNDEFINED> instruction: 0x000004bc
    2008:	000004b1 			; <UNDEFINED> instruction: 0x000004b1
    200c:	a60e000d 	strge	r0, [lr], -sp
    2010:	05000004 	streq	r0, [r0, #-4]
    2014:	0004c804 	andeq	ip, r4, r4, lsl #16
    2018:	04b60e00 	ldrteq	r0, [r6], #3584	; 0xe00
    201c:	01030000 	mrseq	r0, (UNDEF: 3)
    2020:	0007a108 	andeq	sl, r7, r8, lsl #2
    2024:	04c10e00 	strbeq	r0, [r1], #3584	; 0xe00
    2028:	950f0000 	strls	r0, [pc, #-0]	; 2030 <shift+0x2030>
    202c:	04000014 	streq	r0, [r0], #-20	; 0xffffffec
    2030:	b11a0144 	tstlt	sl, r4, asr #2
    2034:	0f000004 	svceq	0x00000004
    2038:	00001869 	andeq	r1, r0, r9, ror #16
    203c:	1a017904 	bne	60454 <__bss_end+0x57628>
    2040:	000004b1 			; <UNDEFINED> instruction: 0x000004b1
    2044:	0004c10c 	andeq	ip, r4, ip, lsl #2
    2048:	0004f200 	andeq	pc, r4, r0, lsl #4
    204c:	09000d00 	stmdbeq	r0, {r8, sl, fp}
    2050:	00001a95 	muleq	r0, r5, sl
    2054:	e70d2d05 	str	r2, [sp, -r5, lsl #26]
    2058:	09000004 	stmdbeq	r0, {r2}
    205c:	0000228a 	andeq	r2, r0, sl, lsl #5
    2060:	e61c3505 	ldr	r3, [ip], -r5, lsl #10
    2064:	0a000001 	beq	2070 <shift+0x2070>
    2068:	00001745 	andeq	r1, r0, r5, asr #14
    206c:	00930107 	addseq	r0, r3, r7, lsl #2
    2070:	37050000 	strcc	r0, [r5, -r0]
    2074:	00057d0e 	andeq	r7, r5, lr, lsl #26
    2078:	12e20b00 	rscne	r0, r2, #0, 22
    207c:	0b000000 	bleq	2084 <shift+0x2084>
    2080:	0000197c 	andeq	r1, r0, ip, ror r9
    2084:	24810b01 	strcs	r0, [r1], #2817	; 0xb01
    2088:	0b020000 	bleq	82090 <__bss_end+0x79264>
    208c:	0000245c 	andeq	r2, r0, ip, asr r4
    2090:	1d380b03 	fldmdbxne	r8!, {d0}	;@ Deprecated
    2094:	0b040000 	bleq	10209c <__bss_end+0xf9270>
    2098:	000020da 	ldrdeq	r2, [r0], -sl
    209c:	14d80b05 	ldrbne	r0, [r8], #2821	; 0xb05
    20a0:	0b060000 	bleq	1820a8 <__bss_end+0x17927c>
    20a4:	000014ba 			; <UNDEFINED> instruction: 0x000014ba
    20a8:	160d0b07 	strne	r0, [sp], -r7, lsl #22
    20ac:	0b080000 	bleq	2020b4 <__bss_end+0x1f9288>
    20b0:	00001bc6 	andeq	r1, r0, r6, asr #23
    20b4:	14df0b09 	ldrbne	r0, [pc], #2825	; 20bc <shift+0x20bc>
    20b8:	0b0a0000 	bleq	2820c0 <__bss_end+0x279294>
    20bc:	0000154b 	andeq	r1, r0, fp, asr #10
    20c0:	15440b0b 	strbne	r0, [r4, #-2827]	; 0xfffff4f5
    20c4:	0b0c0000 	bleq	3020cc <__bss_end+0x2f92a0>
    20c8:	000014d1 	ldrdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    20cc:	21310b0d 	teqcs	r1, sp, lsl #22
    20d0:	0b0e0000 	bleq	3820d8 <__bss_end+0x3792ac>
    20d4:	00001e28 	andeq	r1, r0, r8, lsr #28
    20d8:	dc04000f 	stcle	0, cr0, [r4], {15}
    20dc:	0500001f 	streq	r0, [r0, #-31]	; 0xffffffe1
    20e0:	050a013c 	streq	r0, [sl, #-316]	; 0xfffffec4
    20e4:	ad090000 	stcge	0, cr0, [r9, #-0]
    20e8:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    20ec:	057d0f3e 	ldrbeq	r0, [sp, #-3902]!	; 0xfffff0c2
    20f0:	54090000 	strpl	r0, [r9], #-0
    20f4:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    20f8:	001d0c47 	andseq	r0, sp, r7, asr #24
    20fc:	85090000 	strhi	r0, [r9, #-0]
    2100:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    2104:	001d0c48 	andseq	r0, sp, r8, asr #24
    2108:	6e100000 	cdpvs	0, 1, cr0, cr0, cr0, {0}
    210c:	09000022 	stmdbeq	r0, {r1, r5}
    2110:	000020bc 	strheq	r2, [r0], -ip
    2114:	be144905 	vnmlslt.f16	s8, s8, s10	; <UNPREDICTABLE>
    2118:	05000005 	streq	r0, [r0, #-5]
    211c:	0005ad04 	andeq	sl, r5, r4, lsl #26
    2120:	46091100 	strmi	r1, [r9], -r0, lsl #2
    2124:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    2128:	05d10f4b 	ldrbeq	r0, [r1, #3915]	; 0xf4b
    212c:	04050000 	streq	r0, [r5], #-0
    2130:	000005c4 	andeq	r0, r0, r4, asr #11
    2134:	00202f12 	eoreq	r2, r0, r2, lsl pc
    2138:	1d250900 			; <UNDEFINED> instruction: 0x1d250900
    213c:	4f050000 	svcmi	0x00050000
    2140:	0005e80d 	andeq	lr, r5, sp, lsl #16
    2144:	d7040500 	strle	r0, [r4, -r0, lsl #10]
    2148:	13000005 	movwne	r0, #5
    214c:	000015f3 	strdeq	r1, [r0], -r3
    2150:	01580534 	cmpeq	r8, r4, lsr r5
    2154:	00061915 	andeq	r1, r6, r5, lsl r9
    2158:	1a9e1400 	bne	fe787160 <__bss_end+0xfe77e334>
    215c:	5a050000 	bpl	142164 <__bss_end+0x139338>
    2160:	04b60f01 	ldrteq	r0, [r6], #3841	; 0xf01
    2164:	14000000 	strne	r0, [r0], #-0
    2168:	000015d7 	ldrdeq	r1, [r0], -r7
    216c:	14015b05 	strne	r5, [r1], #-2821	; 0xfffff4fb
    2170:	0000061e 	andeq	r0, r0, lr, lsl r6
    2174:	ee0e0004 	cdp	0, 0, cr0, cr14, cr4, {0}
    2178:	0c000005 	stceq	0, cr0, [r0], {5}
    217c:	000000b9 	strheq	r0, [r0], -r9
    2180:	0000062e 	andeq	r0, r0, lr, lsr #12
    2184:	00002415 	andeq	r2, r0, r5, lsl r4
    2188:	0c002d00 	stceq	13, cr2, [r0], {-0}
    218c:	00000619 	andeq	r0, r0, r9, lsl r6
    2190:	00000639 	andeq	r0, r0, r9, lsr r6
    2194:	2e0e000d 	cdpcs	0, 0, cr0, cr14, cr13, {0}
    2198:	0f000006 	svceq	0x00000006
    219c:	000019ce 	andeq	r1, r0, lr, asr #19
    21a0:	03015c05 	movweq	r5, #7173	; 0x1c05
    21a4:	00000639 	andeq	r0, r0, r9, lsr r6
    21a8:	001c3e0f 	andseq	r3, ip, pc, lsl #28
    21ac:	015f0500 	cmpeq	pc, r0, lsl #10
    21b0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    21b4:	206d1600 	rsbcs	r1, sp, r0, lsl #12
    21b8:	01070000 	mrseq	r0, (UNDEF: 7)
    21bc:	00000093 	muleq	r0, r3, r0
    21c0:	06017205 	streq	r7, [r1], -r5, lsl #4
    21c4:	0000070e 	andeq	r0, r0, lr, lsl #14
    21c8:	001d190b 	andseq	r1, sp, fp, lsl #18
    21cc:	890b0000 	stmdbhi	fp, {}	; <UNPREDICTABLE>
    21d0:	02000013 	andeq	r0, r0, #19
    21d4:	0013950b 	andseq	r9, r3, fp, lsl #10
    21d8:	710b0300 	mrsvc	r0, (UNDEF: 59)
    21dc:	03000017 	movweq	r0, #23
    21e0:	001d550b 	andseq	r5, sp, fp, lsl #10
    21e4:	d80b0400 	stmdale	fp, {sl}
    21e8:	04000018 	streq	r0, [r0], #-24	; 0xffffffe8
    21ec:	0013b30b 	andseq	fp, r3, fp, lsl #6
    21f0:	a50b0500 	strge	r0, [fp, #-1280]	; 0xfffffb00
    21f4:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    21f8:	0019df0b 	andseq	sp, r9, fp, lsl #30
    21fc:	090b0500 	stmdbeq	fp, {r8, sl}
    2200:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    2204:	0014760b 	andseq	r7, r4, fp, lsl #12
    2208:	bf0b0500 	svclt	0x000b0500
    220c:	06000013 			; <UNDEFINED> instruction: 0x06000013
    2210:	001b4e0b 	andseq	r4, fp, fp, lsl #28
    2214:	c90b0600 	stmdbgt	fp, {r9, sl}
    2218:	06000015 			; <UNDEFINED> instruction: 0x06000015
    221c:	001e630b 	andseq	r6, lr, fp, lsl #6
    2220:	fd0b0600 	stc2	6, cr0, [fp, #-0]
    2224:	06000020 	streq	r0, [r0], -r0, lsr #32
    2228:	001b820b 	andseq	r8, fp, fp, lsl #4
    222c:	e10b0600 	tst	fp, r0, lsl #12
    2230:	0600001b 			; <UNDEFINED> instruction: 0x0600001b
    2234:	0013cb0b 	andseq	ip, r3, fp, lsl #22
    2238:	fc0b0700 	stc2	7, cr0, [fp], {-0}
    223c:	0700001c 	smladeq	r0, ip, r0, r0
    2240:	001d610b 	andseq	r6, sp, fp, lsl #2
    2244:	470b0700 	strmi	r0, [fp, -r0, lsl #14]
    2248:	07000021 	streq	r0, [r0, -r1, lsr #32]
    224c:	00159c0b 	andseq	r9, r5, fp, lsl #24
    2250:	dc0b0700 	stcle	7, cr0, [fp], {-0}
    2254:	0800001d 	stmdaeq	r0, {r0, r2, r3, r4}
    2258:	00132c0b 	andseq	r2, r3, fp, lsl #24
    225c:	0b0b0800 	bleq	2c4264 <__bss_end+0x2bb438>
    2260:	08000021 	stmdaeq	r0, {r0, r5}
    2264:	001dfd0b 	andseq	pc, sp, fp, lsl #26
    2268:	0f000800 	svceq	0x00000800
    226c:	00002496 	muleq	r0, r6, r4
    2270:	1f019205 	svcne	0x00019205
    2274:	00000658 	andeq	r0, r0, r8, asr r6
    2278:	0018a50f 	andseq	sl, r8, pc, lsl #10
    227c:	01950500 	orrseq	r0, r5, r0, lsl #10
    2280:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2284:	1e2f0f00 	cdpne	15, 2, cr0, cr15, cr0, {0}
    2288:	98050000 	stmdals	r5, {}	; <UNPREDICTABLE>
    228c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2290:	ec0f0000 	stc	0, cr0, [pc], {-0}
    2294:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    2298:	1d0c019b 	stfnes	f0, [ip, #-620]	; 0xfffffd94
    229c:	0f000000 	svceq	0x00000000
    22a0:	00001e39 	andeq	r1, r0, r9, lsr lr
    22a4:	0c019e05 	stceq	14, cr9, [r1], {5}
    22a8:	0000001d 	andeq	r0, r0, sp, lsl r0
    22ac:	001b2f0f 	andseq	r2, fp, pc, lsl #30
    22b0:	01a10500 			; <UNDEFINED> instruction: 0x01a10500
    22b4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    22b8:	1e830f00 	cdpne	15, 8, cr0, cr3, cr0, {0}
    22bc:	a4050000 	strge	r0, [r5], #-0
    22c0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    22c4:	3f0f0000 	svccc	0x000f0000
    22c8:	0500001d 	streq	r0, [r0, #-29]	; 0xffffffe3
    22cc:	1d0c01a7 	stfnes	f0, [ip, #-668]	; 0xfffffd64
    22d0:	0f000000 	svceq	0x00000000
    22d4:	00001d4a 	andeq	r1, r0, sl, asr #26
    22d8:	0c01aa05 			; <UNDEFINED> instruction: 0x0c01aa05
    22dc:	0000001d 	andeq	r0, r0, sp, lsl r0
    22e0:	001e430f 	andseq	r4, lr, pc, lsl #6
    22e4:	01ad0500 			; <UNDEFINED> instruction: 0x01ad0500
    22e8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    22ec:	1b210f00 	blne	845ef4 <__bss_end+0x83d0c8>
    22f0:	b0050000 	andlt	r0, r5, r0
    22f4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    22f8:	d80f0000 	stmdale	pc, {}	; <UNPREDICTABLE>
    22fc:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    2300:	1d0c01b3 	stfnes	f0, [ip, #-716]	; 0xfffffd34
    2304:	0f000000 	svceq	0x00000000
    2308:	00001e4d 	andeq	r1, r0, sp, asr #28
    230c:	0c01b605 	stceq	6, cr11, [r1], {5}
    2310:	0000001d 	andeq	r0, r0, sp, lsl r0
    2314:	0025b50f 	eoreq	fp, r5, pc, lsl #10
    2318:	01b90500 			; <UNDEFINED> instruction: 0x01b90500
    231c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2320:	24630f00 	strbtcs	r0, [r3], #-3840	; 0xfffff100
    2324:	bc050000 	stclt	0, cr0, [r5], {-0}
    2328:	001d0c01 	andseq	r0, sp, r1, lsl #24
    232c:	880f0000 	stmdahi	pc, {}	; <UNPREDICTABLE>
    2330:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    2334:	1d0c01c0 	stfnes	f0, [ip, #-768]	; 0xfffffd00
    2338:	0f000000 	svceq	0x00000000
    233c:	000025a8 	andeq	r2, r0, r8, lsr #11
    2340:	0c01c305 	stceq	3, cr12, [r1], {5}
    2344:	0000001d 	andeq	r0, r0, sp, lsl r0
    2348:	0014e60f 	andseq	lr, r4, pc, lsl #12
    234c:	01c60500 	biceq	r0, r6, r0, lsl #10
    2350:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2354:	12bd0f00 	adcsne	r0, sp, #0, 30
    2358:	c9050000 	stmdbgt	r5, {}	; <UNPREDICTABLE>
    235c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2360:	910f0000 	mrsls	r0, CPSR
    2364:	05000017 	streq	r0, [r0, #-23]	; 0xffffffe9
    2368:	1d0c01cc 	stfnes	f0, [ip, #-816]	; 0xfffffcd0
    236c:	0f000000 	svceq	0x00000000
    2370:	000014c1 	andeq	r1, r0, r1, asr #9
    2374:	0c01cf05 	stceq	15, cr12, [r1], {5}
    2378:	0000001d 	andeq	r0, r0, sp, lsl r0
    237c:	001e8d0f 	andseq	r8, lr, pc, lsl #26
    2380:	01d20500 	bicseq	r0, r2, r0, lsl #10
    2384:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2388:	1a140f00 	bne	505f90 <__bss_end+0x4fd164>
    238c:	d5050000 	strle	r0, [r5, #-0]
    2390:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2394:	ac0f0000 	stcge	0, cr0, [pc], {-0}
    2398:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    239c:	1d0c01d8 	stfnes	f0, [ip, #-864]	; 0xfffffca0
    23a0:	0f000000 	svceq	0x00000000
    23a4:	00002293 	muleq	r0, r3, r2
    23a8:	0c01df05 	stceq	15, cr13, [r1], {5}
    23ac:	0000001d 	andeq	r0, r0, sp, lsl r0
    23b0:	0025470f 	eoreq	r4, r5, pc, lsl #14
    23b4:	01e20500 	mvneq	r0, r0, lsl #10
    23b8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    23bc:	25570f00 	ldrbcs	r0, [r7, #-3840]	; 0xfffff100
    23c0:	e5050000 	str	r0, [r5, #-0]
    23c4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    23c8:	e00f0000 	and	r0, pc, r0
    23cc:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    23d0:	1d0c01e8 	stfnes	f0, [ip, #-928]	; 0xfffffc60
    23d4:	0f000000 	svceq	0x00000000
    23d8:	000022da 	ldrdeq	r2, [r0], -sl
    23dc:	0c01eb05 			; <UNDEFINED> instruction: 0x0c01eb05
    23e0:	0000001d 	andeq	r0, r0, sp, lsl r0
    23e4:	001dc40f 	andseq	ip, sp, pc, lsl #8
    23e8:	01ee0500 	mvneq	r0, r0, lsl #10
    23ec:	00001d0c 	andeq	r1, r0, ip, lsl #26
    23f0:	180a0f00 	stmdane	sl, {r8, r9, sl, fp}
    23f4:	f2050000 	vhadd.s8	d0, d5, d0
    23f8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    23fc:	7f0f0000 	svcvc	0x000f0000
    2400:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    2404:	1d0c01fa 	stfnes	f0, [ip, #-1000]	; 0xfffffc18
    2408:	0f000000 	svceq	0x00000000
    240c:	000016c3 	andeq	r1, r0, r3, asr #13
    2410:	0c01fd05 	stceq	13, cr15, [r1], {5}
    2414:	0000001d 	andeq	r0, r0, sp, lsl r0
    2418:	00001d0c 	andeq	r1, r0, ip, lsl #26
    241c:	0008c600 	andeq	ip, r8, r0, lsl #12
    2420:	0f000d00 	svceq	0x00000d00
    2424:	000018f4 	strdeq	r1, [r0], -r4
    2428:	0c03eb05 			; <UNDEFINED> instruction: 0x0c03eb05
    242c:	000008bb 			; <UNDEFINED> instruction: 0x000008bb
    2430:	0005be0c 	andeq	fp, r5, ip, lsl #28
    2434:	0008e300 	andeq	lr, r8, r0, lsl #6
    2438:	00241500 	eoreq	r1, r4, r0, lsl #10
    243c:	000d0000 	andeq	r0, sp, r0
    2440:	001ec30f 	andseq	ip, lr, pc, lsl #6
    2444:	05740500 	ldrbeq	r0, [r4, #-1280]!	; 0xfffffb00
    2448:	0008d314 	andeq	sp, r8, r4, lsl r3
    244c:	19d71600 	ldmibne	r7, {r9, sl, ip}^
    2450:	01070000 	mrseq	r0, (UNDEF: 7)
    2454:	00000093 	muleq	r0, r3, r0
    2458:	06057b05 	streq	r7, [r5], -r5, lsl #22
    245c:	0000092e 	andeq	r0, r0, lr, lsr #18
    2460:	0017530b 	andseq	r5, r7, fp, lsl #6
    2464:	0c0b0000 	stceq	0, cr0, [fp], {-0}
    2468:	0100001c 	tsteq	r0, ip, lsl r0
    246c:	0013620b 	andseq	r6, r3, fp, lsl #4
    2470:	090b0200 	stmdbeq	fp, {r9}
    2474:	03000025 	movweq	r0, #37	; 0x25
    2478:	001f4f0b 	andseq	r4, pc, fp, lsl #30
    247c:	420b0400 	andmi	r0, fp, #0, 8
    2480:	0500001f 	streq	r0, [r0, #-31]	; 0xffffffe1
    2484:	0014550b 	andseq	r5, r4, fp, lsl #10
    2488:	0f000600 	svceq	0x00000600
    248c:	000024f9 	strdeq	r2, [r0], -r9
    2490:	15058805 	strne	r8, [r5, #-2053]	; 0xfffff7fb
    2494:	000008f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    2498:	0023d50f 	eoreq	sp, r3, pc, lsl #10
    249c:	07890500 	streq	r0, [r9, r0, lsl #10]
    24a0:	00002411 	andeq	r2, r0, r1, lsl r4
    24a4:	1eb00f00 	cdpne	15, 11, cr0, cr0, cr0, {0}
    24a8:	9e050000 	cdpls	0, 0, cr0, cr5, cr0, {0}
    24ac:	001d0c07 	andseq	r0, sp, r7, lsl #24
    24b0:	82040000 	andhi	r0, r4, #0
    24b4:	06000022 	streq	r0, [r0], -r2, lsr #32
    24b8:	0093167b 	addseq	r1, r3, fp, ror r6
    24bc:	550e0000 	strpl	r0, [lr, #-0]
    24c0:	03000009 	movweq	r0, #9
    24c4:	04700502 	ldrbteq	r0, [r0], #-1282	; 0xfffffafe
    24c8:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    24cc:	0016ac07 	andseq	sl, r6, r7, lsl #24
    24d0:	04040300 	streq	r0, [r4], #-768	; 0xfffffd00
    24d4:	00001501 	andeq	r1, r0, r1, lsl #10
    24d8:	f9030803 			; <UNDEFINED> instruction: 0xf9030803
    24dc:	03000014 	movweq	r0, #20
    24e0:	1e5c0408 	cdpne	4, 5, cr0, cr12, cr8, {0}
    24e4:	10030000 	andne	r0, r3, r0
    24e8:	001f9703 	andseq	r9, pc, r3, lsl #14
    24ec:	09610c00 	stmdbeq	r1!, {sl, fp}^
    24f0:	09a00000 	stmibeq	r0!, {}	; <UNPREDICTABLE>
    24f4:	24150000 	ldrcs	r0, [r5], #-0
    24f8:	ff000000 			; <UNDEFINED> instruction: 0xff000000
    24fc:	09900e00 	ldmibeq	r0, {r9, sl, fp}
    2500:	6e0f0000 	cdpvs	0, 0, cr0, cr15, cr0, {0}
    2504:	0600001d 			; <UNDEFINED> instruction: 0x0600001d
    2508:	a01601fc 			; <UNDEFINED> instruction: 0xa01601fc
    250c:	0f000009 	svceq	0x00000009
    2510:	000014b0 			; <UNDEFINED> instruction: 0x000014b0
    2514:	16020206 	strne	r0, [r2], -r6, lsl #4
    2518:	000009a0 	andeq	r0, r0, r0, lsr #19
    251c:	0022a504 	eoreq	sl, r2, r4, lsl #10
    2520:	102a0700 	eorne	r0, sl, r0, lsl #14
    2524:	000005d1 	ldrdeq	r0, [r0], -r1
    2528:	0009bf0c 	andeq	fp, r9, ip, lsl #30
    252c:	0009d600 	andeq	sp, r9, r0, lsl #12
    2530:	09000d00 	stmdbeq	r0, {r8, sl, fp}
    2534:	0000037a 	andeq	r0, r0, sl, ror r3
    2538:	cb112f07 	blgt	44e15c <__bss_end+0x445330>
    253c:	09000009 	stmdbeq	r0, {r0, r3}
    2540:	0000023c 	andeq	r0, r0, ip, lsr r2
    2544:	cb113007 	blgt	44e568 <__bss_end+0x44573c>
    2548:	17000009 	strne	r0, [r0, -r9]
    254c:	000009d6 	ldrdeq	r0, [r0], -r6
    2550:	0a093608 	beq	24fd78 <__bss_end+0x246f4c>
    2554:	8e190305 	cdphi	3, 1, cr0, cr9, cr5, {0}
    2558:	e2170000 	ands	r0, r7, #0
    255c:	08000009 	stmdaeq	r0, {r0, r3}
    2560:	050a0937 	streq	r0, [sl, #-2359]	; 0xfffff6c9
    2564:	008e1903 	addeq	r1, lr, r3, lsl #18
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x377de8>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb9ef0>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9f10>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9f28>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <__bss_end+0x264>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7aa68>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39f4c>
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
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x377e90>
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
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf79eec>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c5b04>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7aaec>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe39fd0>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <shift+0x16c>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9fe4>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__bss_end+0x334>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7ab24>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe3a008>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeba018>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x377fa0>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c5b90>
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
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c5ba4>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x377fd4>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf79fe4>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 1e8:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 1ec:	0b0b0024 	bleq	2c0284 <__bss_end+0x2b7458>
 1f0:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 1f4:	16050000 	strne	r0, [r5], -r0
 1f8:	3a0e0300 	bcc	380e00 <__bss_end+0x377fd4>
 1fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 200:	0013490b 	andseq	r4, r3, fp, lsl #18
 204:	01130600 	tsteq	r3, r0, lsl #12
 208:	0b0b0e03 	bleq	2c3a1c <__bss_end+0x2babf0>
 20c:	0b3b0b3a 	bleq	ec2efc <__bss_end+0xeba0d0>
 210:	13010b39 	movwne	r0, #6969	; 0x1b39
 214:	0d070000 	stceq	0, cr0, [r7, #-0]
 218:	3a080300 	bcc	200e20 <__bss_end+0x1f7ff4>
 21c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 220:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 224:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 228:	0e030104 	adfeqs	f0, f3, f4
 22c:	0b3e196d 	bleq	f867e8 <__bss_end+0xf7d9bc>
 230:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 234:	0b3b0b3a 	bleq	ec2f24 <__bss_end+0xeba0f8>
 238:	13010b39 	movwne	r0, #6969	; 0x1b39
 23c:	28090000 	stmdacs	r9, {}	; <UNPREDICTABLE>
 240:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 244:	0a00000b 	beq	278 <shift+0x278>
 248:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 24c:	0b3b0b3a 	bleq	ec2f3c <__bss_end+0xeba110>
 250:	13490b39 	movtne	r0, #39737	; 0x9b39
 254:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 258:	020b0000 	andeq	r0, fp, #0
 25c:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 260:	0c000019 	stceq	0, cr0, [r0], {25}
 264:	0e030102 	adfeqs	f0, f3, f2
 268:	0b3a0b0b 	bleq	e82e9c <__bss_end+0xe7a070>
 26c:	0b390b3b 	bleq	e42f60 <__bss_end+0xe3a134>
 270:	00001301 	andeq	r1, r0, r1, lsl #6
 274:	03000d0d 	movweq	r0, #3341	; 0xd0d
 278:	3b0b3a0e 	blcc	2ceab8 <__bss_end+0x2c5c8c>
 27c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 280:	000b3813 	andeq	r3, fp, r3, lsl r8
 284:	012e0e00 			; <UNDEFINED> instruction: 0x012e0e00
 288:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 28c:	0b3b0b3a 	bleq	ec2f7c <__bss_end+0xeba150>
 290:	0e6e0b39 	vmoveq.8	d14[5], r0
 294:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 298:	00001364 	andeq	r1, r0, r4, ror #6
 29c:	4900050f 	stmdbmi	r0, {r0, r1, r2, r3, r8, sl}
 2a0:	00193413 	andseq	r3, r9, r3, lsl r4
 2a4:	00051000 	andeq	r1, r5, r0
 2a8:	00001349 	andeq	r1, r0, r9, asr #6
 2ac:	03000d11 	movweq	r0, #3345	; 0xd11
 2b0:	3b0b3a0e 	blcc	2ceaf0 <__bss_end+0x2c5cc4>
 2b4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 2b8:	3c193f13 	ldccc	15, cr3, [r9], {19}
 2bc:	12000019 	andne	r0, r0, #25
 2c0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 2c4:	0b3a0e03 	bleq	e83ad8 <__bss_end+0xe7acac>
 2c8:	0b390b3b 	bleq	e42fbc <__bss_end+0xe3a190>
 2cc:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 2d0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 2d4:	13011364 	movwne	r1, #4964	; 0x1364
 2d8:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 2dc:	03193f01 	tsteq	r9, #1, 30
 2e0:	3b0b3a0e 	blcc	2ceb20 <__bss_end+0x2c5cf4>
 2e4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2e8:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 2ec:	01136419 	tsteq	r3, r9, lsl r4
 2f0:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 2f4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 2f8:	0b3a0e03 	bleq	e83b0c <__bss_end+0xe7ace0>
 2fc:	0b390b3b 	bleq	e42ff0 <__bss_end+0xe3a1c4>
 300:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 304:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 308:	00001364 	andeq	r1, r0, r4, ror #6
 30c:	49010115 	stmdbmi	r1, {r0, r2, r4, r8}
 310:	00130113 	andseq	r0, r3, r3, lsl r1
 314:	00211600 	eoreq	r1, r1, r0, lsl #12
 318:	0b2f1349 	bleq	bc5044 <__bss_end+0xbbc218>
 31c:	0f170000 	svceq	0x00170000
 320:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 324:	18000013 	stmdane	r0, {r0, r1, r4}
 328:	00000021 	andeq	r0, r0, r1, lsr #32
 32c:	03003419 	movweq	r3, #1049	; 0x419
 330:	3b0b3a0e 	blcc	2ceb70 <__bss_end+0x2c5d44>
 334:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 338:	3c193f13 	ldccc	15, cr3, [r9], {19}
 33c:	1a000019 	bne	3a8 <shift+0x3a8>
 340:	08030028 	stmdaeq	r3, {r3, r5}
 344:	00000b1c 	andeq	r0, r0, ip, lsl fp
 348:	3f012e1b 	svccc	0x00012e1b
 34c:	3a0e0319 	bcc	380fb8 <__bss_end+0x37818c>
 350:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 354:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
 358:	01136419 	tsteq	r3, r9, lsl r4
 35c:	1c000013 	stcne	0, cr0, [r0], {19}
 360:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 364:	0b3a0e03 	bleq	e83b78 <__bss_end+0xe7ad4c>
 368:	0b390b3b 	bleq	e4305c <__bss_end+0xe3a230>
 36c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 370:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 374:	00001301 	andeq	r1, r0, r1, lsl #6
 378:	03000d1d 	movweq	r0, #3357	; 0xd1d
 37c:	3b0b3a0e 	blcc	2cebbc <__bss_end+0x2c5d90>
 380:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 384:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
 388:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
 38c:	13490115 	movtne	r0, #37141	; 0x9115
 390:	13011364 	movwne	r1, #4964	; 0x1364
 394:	1f1f0000 	svcne	0x001f0000
 398:	49131d00 	ldmdbmi	r3, {r8, sl, fp, ip}
 39c:	20000013 	andcs	r0, r0, r3, lsl r0
 3a0:	0b0b0010 	bleq	2c03e8 <__bss_end+0x2b75bc>
 3a4:	00001349 	andeq	r1, r0, r9, asr #6
 3a8:	0b000f21 	bleq	4034 <shift+0x4034>
 3ac:	2200000b 	andcs	r0, r0, #11
 3b0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 3b4:	0b3a0e03 	bleq	e83bc8 <__bss_end+0xe7ad9c>
 3b8:	0b390b3b 	bleq	e430ac <__bss_end+0xe3a280>
 3bc:	01111349 	tsteq	r1, r9, asr #6
 3c0:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 3c4:	01194296 			; <UNDEFINED> instruction: 0x01194296
 3c8:	23000013 	movwcs	r0, #19
 3cc:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 3d0:	0b3b0b3a 	bleq	ec30c0 <__bss_end+0xeba294>
 3d4:	13490b39 	movtne	r0, #39737	; 0x9b39
 3d8:	00001802 	andeq	r1, r0, r2, lsl #16
 3dc:	01110100 	tsteq	r1, r0, lsl #2
 3e0:	0b130e25 	bleq	4c3c7c <__bss_end+0x4bae50>
 3e4:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 3e8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 3ec:	00001710 	andeq	r1, r0, r0, lsl r7
 3f0:	0b002402 	bleq	9400 <__bss_end+0x5d4>
 3f4:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 3f8:	0300000e 	movweq	r0, #14
 3fc:	13490026 	movtne	r0, #36902	; 0x9026
 400:	24040000 	strcs	r0, [r4], #-0
 404:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 408:	0008030b 	andeq	r0, r8, fp, lsl #6
 40c:	00160500 	andseq	r0, r6, r0, lsl #10
 410:	0b3a0e03 	bleq	e83c24 <__bss_end+0xe7adf8>
 414:	0b390b3b 	bleq	e43108 <__bss_end+0xe3a2dc>
 418:	00001349 	andeq	r1, r0, r9, asr #6
 41c:	03011306 	movweq	r1, #4870	; 0x1306
 420:	3a0b0b0e 	bcc	2c3060 <__bss_end+0x2ba234>
 424:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 428:	0013010b 	andseq	r0, r3, fp, lsl #2
 42c:	000d0700 	andeq	r0, sp, r0, lsl #14
 430:	0b3a0803 	bleq	e82444 <__bss_end+0xe79618>
 434:	0b390b3b 	bleq	e43128 <__bss_end+0xe3a2fc>
 438:	0b381349 	bleq	e05164 <__bss_end+0xdfc338>
 43c:	04080000 	streq	r0, [r8], #-0
 440:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 444:	0b0b3e19 	bleq	2cfcb0 <__bss_end+0x2c6e84>
 448:	3a13490b 	bcc	4d287c <__bss_end+0x4c9a50>
 44c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 450:	0013010b 	andseq	r0, r3, fp, lsl #2
 454:	00280900 	eoreq	r0, r8, r0, lsl #18
 458:	0b1c0803 	bleq	70246c <__bss_end+0x6f9640>
 45c:	280a0000 	stmdacs	sl, {}	; <UNPREDICTABLE>
 460:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 464:	0b00000b 	bleq	498 <shift+0x498>
 468:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 46c:	0b3b0b3a 	bleq	ec315c <__bss_end+0xeba330>
 470:	13490b39 	movtne	r0, #39737	; 0x9b39
 474:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 478:	020c0000 	andeq	r0, ip, #0
 47c:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 480:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 484:	0e030102 	adfeqs	f0, f3, f2
 488:	0b3a0b0b 	bleq	e830bc <__bss_end+0xe7a290>
 48c:	0b390b3b 	bleq	e43180 <__bss_end+0xe3a354>
 490:	00001301 	andeq	r1, r0, r1, lsl #6
 494:	03000d0e 	movweq	r0, #3342	; 0xd0e
 498:	3b0b3a0e 	blcc	2cecd8 <__bss_end+0x2c5eac>
 49c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4a0:	000b3813 	andeq	r3, fp, r3, lsl r8
 4a4:	012e0f00 			; <UNDEFINED> instruction: 0x012e0f00
 4a8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 4ac:	0b3b0b3a 	bleq	ec319c <__bss_end+0xeba370>
 4b0:	0e6e0b39 	vmoveq.8	d14[5], r0
 4b4:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 4b8:	00001364 	andeq	r1, r0, r4, ror #6
 4bc:	49000510 	stmdbmi	r0, {r4, r8, sl}
 4c0:	00193413 	andseq	r3, r9, r3, lsl r4
 4c4:	00051100 	andeq	r1, r5, r0, lsl #2
 4c8:	00001349 	andeq	r1, r0, r9, asr #6
 4cc:	03000d12 	movweq	r0, #3346	; 0xd12
 4d0:	3b0b3a0e 	blcc	2ced10 <__bss_end+0x2c5ee4>
 4d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4d8:	3c193f13 	ldccc	15, cr3, [r9], {19}
 4dc:	13000019 	movwne	r0, #25
 4e0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 4e4:	0b3a0e03 	bleq	e83cf8 <__bss_end+0xe7aecc>
 4e8:	0b390b3b 	bleq	e431dc <__bss_end+0xe3a3b0>
 4ec:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 4f0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 4f4:	13011364 	movwne	r1, #4964	; 0x1364
 4f8:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 4fc:	03193f01 	tsteq	r9, #1, 30
 500:	3b0b3a0e 	blcc	2ced40 <__bss_end+0x2c5f14>
 504:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 508:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 50c:	01136419 	tsteq	r3, r9, lsl r4
 510:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 514:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 518:	0b3a0e03 	bleq	e83d2c <__bss_end+0xe7af00>
 51c:	0b390b3b 	bleq	e43210 <__bss_end+0xe3a3e4>
 520:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 524:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 528:	00001364 	andeq	r1, r0, r4, ror #6
 52c:	49010116 	stmdbmi	r1, {r1, r2, r4, r8}
 530:	00130113 	andseq	r0, r3, r3, lsl r1
 534:	00211700 	eoreq	r1, r1, r0, lsl #14
 538:	0b2f1349 	bleq	bc5264 <__bss_end+0xbbc438>
 53c:	0f180000 	svceq	0x00180000
 540:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 544:	19000013 	stmdbne	r0, {r0, r1, r4}
 548:	00000021 	andeq	r0, r0, r1, lsr #32
 54c:	0300341a 	movweq	r3, #1050	; 0x41a
 550:	3b0b3a0e 	blcc	2ced90 <__bss_end+0x2c5f64>
 554:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 558:	3c193f13 	ldccc	15, cr3, [r9], {19}
 55c:	1b000019 	blne	5c8 <shift+0x5c8>
 560:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 564:	0b3a0e03 	bleq	e83d78 <__bss_end+0xe7af4c>
 568:	0b390b3b 	bleq	e4325c <__bss_end+0xe3a430>
 56c:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 570:	13011364 	movwne	r1, #4964	; 0x1364
 574:	2e1c0000 	cdpcs	0, 1, cr0, cr12, cr0, {0}
 578:	03193f01 	tsteq	r9, #1, 30
 57c:	3b0b3a0e 	blcc	2cedbc <__bss_end+0x2c5f90>
 580:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 584:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 588:	01136419 	tsteq	r3, r9, lsl r4
 58c:	1d000013 	stcne	0, cr0, [r0, #-76]	; 0xffffffb4
 590:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 594:	0b3b0b3a 	bleq	ec3284 <__bss_end+0xeba458>
 598:	13490b39 	movtne	r0, #39737	; 0x9b39
 59c:	0b320b38 	bleq	c83284 <__bss_end+0xc7a458>
 5a0:	151e0000 	ldrne	r0, [lr, #-0]
 5a4:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
 5a8:	00130113 	andseq	r0, r3, r3, lsl r1
 5ac:	001f1f00 	andseq	r1, pc, r0, lsl #30
 5b0:	1349131d 	movtne	r1, #37661	; 0x931d
 5b4:	10200000 	eorne	r0, r0, r0
 5b8:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 5bc:	21000013 	tstcs	r0, r3, lsl r0
 5c0:	0b0b000f 	bleq	2c0604 <__bss_end+0x2b77d8>
 5c4:	34220000 	strtcc	r0, [r2], #-0
 5c8:	3a0e0300 	bcc	3811d0 <__bss_end+0x3783a4>
 5cc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5d0:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 5d4:	23000018 	movwcs	r0, #24
 5d8:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 5dc:	0b3a0e03 	bleq	e83df0 <__bss_end+0xe7afc4>
 5e0:	0b390b3b 	bleq	e432d4 <__bss_end+0xe3a4a8>
 5e4:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 5e8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 5ec:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 5f0:	00130119 	andseq	r0, r3, r9, lsl r1
 5f4:	00052400 	andeq	r2, r5, r0, lsl #8
 5f8:	0b3a0e03 	bleq	e83e0c <__bss_end+0xe7afe0>
 5fc:	0b390b3b 	bleq	e432f0 <__bss_end+0xe3a4c4>
 600:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 604:	2e250000 	cdpcs	0, 2, cr0, cr5, cr0, {0}
 608:	03193f01 	tsteq	r9, #1, 30
 60c:	3b0b3a0e 	blcc	2cee4c <__bss_end+0x2c6020>
 610:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 614:	1113490e 	tstne	r3, lr, lsl #18
 618:	40061201 	andmi	r1, r6, r1, lsl #4
 61c:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 620:	00001301 	andeq	r1, r0, r1, lsl #6
 624:	03003426 	movweq	r3, #1062	; 0x426
 628:	3b0b3a08 	blcc	2cee50 <__bss_end+0x2c6024>
 62c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 630:	00180213 	andseq	r0, r8, r3, lsl r2
 634:	012e2700 			; <UNDEFINED> instruction: 0x012e2700
 638:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 63c:	0b3b0b3a 	bleq	ec332c <__bss_end+0xeba500>
 640:	0e6e0b39 	vmoveq.8	d14[5], r0
 644:	06120111 			; <UNDEFINED> instruction: 0x06120111
 648:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 64c:	00130119 	andseq	r0, r3, r9, lsl r1
 650:	002e2800 	eoreq	r2, lr, r0, lsl #16
 654:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 658:	0b3b0b3a 	bleq	ec3348 <__bss_end+0xeba51c>
 65c:	0e6e0b39 	vmoveq.8	d14[5], r0
 660:	06120111 			; <UNDEFINED> instruction: 0x06120111
 664:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 668:	29000019 	stmdbcs	r0, {r0, r3, r4}
 66c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 670:	0b3a0e03 	bleq	e83e84 <__bss_end+0xe7b058>
 674:	0b390b3b 	bleq	e43368 <__bss_end+0xe3a53c>
 678:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 67c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 680:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 684:	00000019 	andeq	r0, r0, r9, lsl r0
 688:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 68c:	030b130e 	movweq	r1, #45838	; 0xb30e
 690:	110e1b0e 	tstne	lr, lr, lsl #22
 694:	10061201 	andne	r1, r6, r1, lsl #4
 698:	02000017 	andeq	r0, r0, #23
 69c:	13010139 	movwne	r0, #4409	; 0x1139
 6a0:	34030000 	strcc	r0, [r3], #-0
 6a4:	3a0e0300 	bcc	3812ac <__bss_end+0x378480>
 6a8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6ac:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 6b0:	000a1c19 	andeq	r1, sl, r9, lsl ip
 6b4:	003a0400 	eorseq	r0, sl, r0, lsl #8
 6b8:	0b3b0b3a 	bleq	ec33a8 <__bss_end+0xeba57c>
 6bc:	13180b39 	tstne	r8, #58368	; 0xe400
 6c0:	01050000 	mrseq	r0, (UNDEF: 5)
 6c4:	01134901 	tsteq	r3, r1, lsl #18
 6c8:	06000013 			; <UNDEFINED> instruction: 0x06000013
 6cc:	13490021 	movtne	r0, #36897	; 0x9021
 6d0:	00000b2f 	andeq	r0, r0, pc, lsr #22
 6d4:	49002607 	stmdbmi	r0, {r0, r1, r2, r9, sl, sp}
 6d8:	08000013 	stmdaeq	r0, {r0, r1, r4}
 6dc:	0b0b0024 	bleq	2c0774 <__bss_end+0x2b7948>
 6e0:	0e030b3e 	vmoveq.16	d3[0], r0
 6e4:	34090000 	strcc	r0, [r9], #-0
 6e8:	00134700 	andseq	r4, r3, r0, lsl #14
 6ec:	012e0a00 			; <UNDEFINED> instruction: 0x012e0a00
 6f0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 6f4:	0b3b0b3a 	bleq	ec33e4 <__bss_end+0xeba5b8>
 6f8:	0e6e0b39 	vmoveq.8	d14[5], r0
 6fc:	06120111 			; <UNDEFINED> instruction: 0x06120111
 700:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 704:	00130119 	andseq	r0, r3, r9, lsl r1
 708:	00050b00 	andeq	r0, r5, r0, lsl #22
 70c:	0b3a0803 	bleq	e82720 <__bss_end+0xe798f4>
 710:	0b390b3b 	bleq	e43404 <__bss_end+0xe3a5d8>
 714:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 718:	340c0000 	strcc	r0, [ip], #-0
 71c:	3a0e0300 	bcc	381324 <__bss_end+0x3784f8>
 720:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 724:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 728:	0d000018 	stceq	0, cr0, [r0, #-96]	; 0xffffffa0
 72c:	0111010b 	tsteq	r1, fp, lsl #2
 730:	00000612 	andeq	r0, r0, r2, lsl r6
 734:	0300340e 	movweq	r3, #1038	; 0x40e
 738:	3b0b3a08 	blcc	2cef60 <__bss_end+0x2c6134>
 73c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 740:	00180213 	andseq	r0, r8, r3, lsl r2
 744:	000f0f00 	andeq	r0, pc, r0, lsl #30
 748:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 74c:	26100000 	ldrcs	r0, [r0], -r0
 750:	11000000 	mrsne	r0, (UNDEF: 0)
 754:	0b0b000f 	bleq	2c0798 <__bss_end+0x2b796c>
 758:	24120000 	ldrcs	r0, [r2], #-0
 75c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 760:	0008030b 	andeq	r0, r8, fp, lsl #6
 764:	00051300 	andeq	r1, r5, r0, lsl #6
 768:	0b3a0e03 	bleq	e83f7c <__bss_end+0xe7b150>
 76c:	0b390b3b 	bleq	e43460 <__bss_end+0xe3a634>
 770:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 774:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 778:	03193f01 	tsteq	r9, #1, 30
 77c:	3b0b3a0e 	blcc	2cefbc <__bss_end+0x2c6190>
 780:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 784:	1113490e 	tstne	r3, lr, lsl #18
 788:	40061201 	andmi	r1, r6, r1, lsl #4
 78c:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 790:	00001301 	andeq	r1, r0, r1, lsl #6
 794:	3f012e15 	svccc	0x00012e15
 798:	3a0e0319 	bcc	381404 <__bss_end+0x3785d8>
 79c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7a0:	110e6e0b 	tstne	lr, fp, lsl #28
 7a4:	40061201 	andmi	r1, r6, r1, lsl #4
 7a8:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 7ac:	01000000 	mrseq	r0, (UNDEF: 0)
 7b0:	06100011 			; <UNDEFINED> instruction: 0x06100011
 7b4:	01120111 	tsteq	r2, r1, lsl r1
 7b8:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 7bc:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 7c0:	01000000 	mrseq	r0, (UNDEF: 0)
 7c4:	06100011 			; <UNDEFINED> instruction: 0x06100011
 7c8:	01120111 	tsteq	r2, r1, lsl r1
 7cc:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 7d0:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 7d4:	01000000 	mrseq	r0, (UNDEF: 0)
 7d8:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 7dc:	0e030b13 	vmoveq.32	d3[0], r0
 7e0:	17100e1b 			; <UNDEFINED> instruction: 0x17100e1b
 7e4:	24020000 	strcs	r0, [r2], #-0
 7e8:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 7ec:	0008030b 	andeq	r0, r8, fp, lsl #6
 7f0:	00240300 	eoreq	r0, r4, r0, lsl #6
 7f4:	0b3e0b0b 	bleq	f83428 <__bss_end+0xf7a5fc>
 7f8:	00000e03 	andeq	r0, r0, r3, lsl #28
 7fc:	03001604 	movweq	r1, #1540	; 0x604
 800:	3b0b3a0e 	blcc	2cf040 <__bss_end+0x2c6214>
 804:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 808:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 80c:	0b0b000f 	bleq	2c0850 <__bss_end+0x2b7a24>
 810:	00001349 	andeq	r1, r0, r9, asr #6
 814:	27011506 	strcs	r1, [r1, -r6, lsl #10]
 818:	01134919 	tsteq	r3, r9, lsl r9
 81c:	07000013 	smladeq	r0, r3, r0, r0
 820:	13490005 	movtne	r0, #36869	; 0x9005
 824:	26080000 	strcs	r0, [r8], -r0
 828:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
 82c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 830:	0b3b0b3a 	bleq	ec3520 <__bss_end+0xeba6f4>
 834:	13490b39 	movtne	r0, #39737	; 0x9b39
 838:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 83c:	040a0000 	streq	r0, [sl], #-0
 840:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 844:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 848:	3b0b3a13 	blcc	2cf09c <__bss_end+0x2c6270>
 84c:	010b390b 	tsteq	fp, fp, lsl #18
 850:	0b000013 	bleq	8a4 <shift+0x8a4>
 854:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 858:	00000b1c 	andeq	r0, r0, ip, lsl fp
 85c:	4901010c 	stmdbmi	r1, {r2, r3, r8}
 860:	00130113 	andseq	r0, r3, r3, lsl r1
 864:	00210d00 	eoreq	r0, r1, r0, lsl #26
 868:	260e0000 	strcs	r0, [lr], -r0
 86c:	00134900 	andseq	r4, r3, r0, lsl #18
 870:	00340f00 	eorseq	r0, r4, r0, lsl #30
 874:	0b3a0e03 	bleq	e84088 <__bss_end+0xe7b25c>
 878:	0b39053b 	bleq	e41d6c <__bss_end+0xe38f40>
 87c:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 880:	0000193c 	andeq	r1, r0, ip, lsr r9
 884:	03001310 	movweq	r1, #784	; 0x310
 888:	00193c0e 	andseq	r3, r9, lr, lsl #24
 88c:	00151100 	andseq	r1, r5, r0, lsl #2
 890:	00001927 	andeq	r1, r0, r7, lsr #18
 894:	03001712 	movweq	r1, #1810	; 0x712
 898:	00193c0e 	andseq	r3, r9, lr, lsl #24
 89c:	01131300 	tsteq	r3, r0, lsl #6
 8a0:	0b0b0e03 	bleq	2c40b4 <__bss_end+0x2bb288>
 8a4:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 8a8:	13010b39 	movwne	r0, #6969	; 0x1b39
 8ac:	0d140000 	ldceq	0, cr0, [r4, #-0]
 8b0:	3a0e0300 	bcc	3814b8 <__bss_end+0x37868c>
 8b4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 8b8:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 8bc:	1500000b 	strne	r0, [r0, #-11]
 8c0:	13490021 	movtne	r0, #36897	; 0x9021
 8c4:	00000b2f 	andeq	r0, r0, pc, lsr #22
 8c8:	03010416 	movweq	r0, #5142	; 0x1416
 8cc:	0b0b3e0e 	bleq	2d010c <__bss_end+0x2c72e0>
 8d0:	3a13490b 	bcc	4d2d04 <__bss_end+0x4c9ed8>
 8d4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 8d8:	0013010b 	andseq	r0, r3, fp, lsl #2
 8dc:	00341700 	eorseq	r1, r4, r0, lsl #14
 8e0:	0b3a1347 	bleq	e85604 <__bss_end+0xe7c7d8>
 8e4:	0b39053b 	bleq	e41dd8 <__bss_end+0xe38fac>
 8e8:	00001802 	andeq	r1, r0, r2, lsl #16
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
  74:	00000048 	andeq	r0, r0, r8, asr #32
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	0b040002 	bleq	100094 <__bss_end+0xf7268>
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	0000827c 	andeq	r8, r0, ip, ror r2
  94:	00000460 	andeq	r0, r0, r0, ror #8
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	17df0002 	ldrbne	r0, [pc, r2]
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	000086dc 	ldrdeq	r8, [r0], -ip
  b4:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	1b110002 	blne	4400d4 <__bss_end+0x4372a8>
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00008b94 	muleq	r0, r4, fp
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	1b370002 	blne	dc00f4 <__bss_end+0xdb72c8>
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00008da0 	andeq	r8, r0, r0, lsr #27
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	1b5d0002 	blne	1740114 <__bss_end+0x17372e8>
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff7120>
       4:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
       8:	6b69746e 	blvs	1a5d1c8 <__bss_end+0x1a5439c>
       c:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
      10:	56494b2f 	strbpl	r4, [r9], -pc, lsr #22
      14:	4f54522d 	svcmi	0x0054522d
      18:	616d2d53 	cmnvs	sp, r3, asr sp
      1c:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
      20:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffcf9 <__bss_end+0xffff6ecd>
      24:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
      28:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
      2c:	61707372 	cmnvs	r0, r2, ror r3
      30:	632f6563 			; <UNDEFINED> instruction: 0x632f6563
      34:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
      38:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
      3c:	2f656d6f 	svccs	0x00656d6f
      40:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
      44:	642f6b69 	strtvs	r6, [pc], #-2921	; 4c <shift+0x4c>
      48:	4b2f7665 	blmi	bdd9e4 <__bss_end+0xbd4bb8>
      4c:	522d5649 	eorpl	r5, sp, #76546048	; 0x4900000
      50:	2d534f54 	ldclcs	15, cr4, [r3, #-336]	; 0xfffffeb0
      54:	7473616d 	ldrbtvc	r6, [r3], #-365	; 0xfffffe93
      58:	732f7265 			; <UNDEFINED> instruction: 0x732f7265
      5c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
      60:	752f7365 	strvc	r7, [pc, #-869]!	; fffffd03 <__bss_end+0xffff6ed7>
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
     268:	2b2b4320 	blcs	ad0ef0 <__bss_end+0xac80c4>
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
     2fc:	6a363731 	bvs	d8dfc8 <__bss_end+0xd8519c>
     300:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     304:	616d2d20 	cmnvs	sp, r0, lsr #26
     308:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     30c:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     310:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     314:	7a36766d 	bvc	d9dcd0 <__bss_end+0xd94ea4>
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
     3e0:	6f007070 	svcvs	0x00007070
     3e4:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     3e8:	69665f64 	stmdbvs	r6!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     3ec:	0073656c 	rsbseq	r6, r3, ip, ror #10
     3f0:	6c656959 			; <UNDEFINED> instruction: 0x6c656959
     3f4:	6e490064 	cdpvs	0, 4, cr0, cr9, cr4, {3}
     3f8:	69666564 	stmdbvs	r6!, {r2, r5, r6, r8, sl, sp, lr}^
     3fc:	6574696e 	ldrbvs	r6, [r4, #-2414]!	; 0xfffff692
     400:	69726400 	ldmdbvs	r2!, {sl, sp, lr}^
     404:	5f726576 	svcpl	0x00726576
     408:	00786469 	rsbseq	r6, r8, r9, ror #8
     40c:	6f6f526d 	svcvs	0x006f526d
     410:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     414:	6f6e0076 	svcvs	0x006e0076
     418:	69666974 	stmdbvs	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     41c:	645f6465 	ldrbvs	r6, [pc], #-1125	; 424 <shift+0x424>
     420:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     424:	00656e69 	rsbeq	r6, r5, r9, ror #28
     428:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
     42c:	69745f70 	ldmdbvs	r4!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     430:	0072656d 	rsbseq	r6, r2, sp, ror #10
     434:	55504354 	ldrbpl	r4, [r0, #-852]	; 0xfffffcac
     438:	6e6f435f 	mcrvs	3, 3, r4, cr15, cr15, {2}
     43c:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     440:	61544e00 	cmpvs	r4, r0, lsl #28
     444:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
     448:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
     44c:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     450:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
     454:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     458:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     45c:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     460:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     464:	756f6d00 	strbvc	r6, [pc, #-3328]!	; fffff76c <__bss_end+0xffff6940>
     468:	6f50746e 	svcvs	0x0050746e
     46c:	00746e69 	rsbseq	r6, r4, r9, ror #28
     470:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     474:	6e692074 	mcrvs	0, 3, r2, cr9, cr4, {3}
     478:	534e0074 	movtpl	r0, #57460	; 0xe074
     47c:	505f4957 	subspl	r4, pc, r7, asr r9	; <UNPREDICTABLE>
     480:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     484:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     488:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     48c:	2f006563 	svccs	0x00006563
     490:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     494:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
     498:	2f6b6974 	svccs	0x006b6974
     49c:	2f766564 	svccs	0x00766564
     4a0:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
     4a4:	534f5452 	movtpl	r5, #62546	; 0xf452
     4a8:	73616d2d 	cmnvc	r1, #2880	; 0xb40
     4ac:	2f726574 	svccs	0x00726574
     4b0:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     4b4:	2f736563 	svccs	0x00736563
     4b8:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     4bc:	63617073 	cmnvs	r1, #115	; 0x73
     4c0:	6e692f65 	cdpvs	15, 6, cr2, cr9, cr5, {3}
     4c4:	745f7469 	ldrbvc	r7, [pc], #-1129	; 4cc <shift+0x4cc>
     4c8:	2f6b7361 	svccs	0x006b7361
     4cc:	6e69616d 	powvsez	f6, f1, #5.0
     4d0:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     4d4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     4d8:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     4dc:	636f7250 	cmnvs	pc, #80, 4
     4e0:	5f737365 	svcpl	0x00737365
     4e4:	616e614d 	cmnvs	lr, sp, asr #2
     4e8:	31726567 	cmncc	r2, r7, ror #10
     4ec:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     4f0:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     4f4:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     4f8:	6f72505f 	svcvs	0x0072505f
     4fc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     500:	4d007645 	stcmi	6, cr7, [r0, #-276]	; 0xfffffeec
     504:	505f7861 	subspl	r7, pc, r1, ror #16
     508:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     50c:	4f5f7373 	svcmi	0x005f7373
     510:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     514:	69465f64 	stmdbvs	r6, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     518:	0073656c 	rsbseq	r6, r3, ip, ror #10
     51c:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
     520:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     524:	4700657a 	smlsdxmi	r0, sl, r5, r6
     528:	505f7465 	subspl	r7, pc, r5, ror #8
     52c:	6d004449 	cfstrsvs	mvf4, [r0, #-292]	; 0xfffffedc
     530:	006e6961 	rsbeq	r6, lr, r1, ror #18
     534:	5f534667 	svcpl	0x00534667
     538:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     53c:	00737265 	rsbseq	r7, r3, r5, ror #4
     540:	5f534667 	svcpl	0x00534667
     544:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     548:	5f737265 	svcpl	0x00737265
     54c:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     550:	5a5f0074 	bpl	17c0728 <__bss_end+0x17b78fc>
     554:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
     558:	6f725043 	svcvs	0x00725043
     55c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     560:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     564:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     568:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     56c:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     570:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     574:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     578:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     57c:	5f006a45 	svcpl	0x00006a45
     580:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     584:	6f725043 	svcvs	0x00725043
     588:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     58c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     590:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     594:	68635338 	stmdavs	r3!, {r3, r4, r5, r8, r9, ip, lr}^
     598:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     59c:	00764565 	rsbseq	r4, r6, r5, ror #10
     5a0:	314e5a5f 	cmpcc	lr, pc, asr sl
     5a4:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     5a8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5ac:	614d5f73 	hvcvs	54771	; 0xd5f3
     5b0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     5b4:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     5b8:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     5bc:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     5c0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5c4:	006a4573 	rsbeq	r4, sl, r3, ror r5
     5c8:	61766e49 	cmnvs	r6, r9, asr #28
     5cc:	5f64696c 	svcpl	0x0064696c
     5d0:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     5d4:	6d00656c 	cfstr32vs	mvfx6, [r0, #-432]	; 0xfffffe50
     5d8:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     5dc:	5f746e65 	svcpl	0x00746e65
     5e0:	6b736154 	blvs	1cd8b38 <__bss_end+0x1ccfd0c>
     5e4:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 5ec <shift+0x5ec>
     5e8:	69540065 	ldmdbvs	r4, {r0, r2, r5, r6}^
     5ec:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     5f0:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     5f4:	44736900 	ldrbtmi	r6, [r3], #-2304	; 0xfffff700
     5f8:	63657269 	cmnvs	r5, #-1879048186	; 0x90000006
     5fc:	79726f74 	ldmdbvc	r2!, {r2, r4, r5, r6, r8, r9, sl, fp, sp, lr}^
     600:	69775300 	ldmdbvs	r7!, {r8, r9, ip, lr}^
     604:	5f686374 	svcpl	0x00686374
     608:	4d006f54 	stcmi	15, cr6, [r0, #-336]	; 0xfffffeb0
     60c:	53467861 	movtpl	r7, #26721	; 0x6861
     610:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     614:	614e7265 	cmpvs	lr, r5, ror #4
     618:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     61c:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     620:	69467300 	stmdbvs	r6, {r8, r9, ip, sp, lr}^
     624:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     628:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     62c:	6f6f6200 	svcvs	0x006f6200
     630:	4c6d006c 	stclmi	0, cr0, [sp], #-432	; 0xfffffe50
     634:	5f747361 	svcpl	0x00747361
     638:	00444950 	subeq	r4, r4, r0, asr r9
     63c:	63677261 	cmnvs	r7, #268435462	; 0x10000006
     640:	746f4e00 	strbtvc	r4, [pc], #-3584	; 648 <shift+0x648>
     644:	5f796669 	svcpl	0x00796669
     648:	636f7250 	cmnvs	pc, #80, 4
     64c:	00737365 	rsbseq	r7, r3, r5, ror #6
     650:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     654:	465f656c 	ldrbmi	r6, [pc], -ip, ror #10
     658:	73656c69 	cmnvc	r5, #26880	; 0x6900
     65c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     660:	57535f6d 	ldrbpl	r5, [r3, -sp, ror #30]
     664:	70630049 	rsbvc	r0, r3, r9, asr #32
     668:	6f635f75 	svcvs	0x00635f75
     66c:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     670:	72430074 	subvc	r0, r3, #116	; 0x74
     674:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     678:	6f72505f 	svcvs	0x0072505f
     67c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     680:	61654400 	cmnvs	r5, r0, lsl #8
     684:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     688:	63730065 	cmnvs	r3, #101	; 0x65
     68c:	5f646568 	svcpl	0x00646568
     690:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
     694:	705f6369 	subsvc	r6, pc, r9, ror #6
     698:	726f6972 	rsbvc	r6, pc, #1867776	; 0x1c8000
     69c:	00797469 	rsbseq	r7, r9, r9, ror #8
     6a0:	65726170 	ldrbvs	r6, [r2, #-368]!	; 0xfffffe90
     6a4:	4c00746e 	cfstrsmi	mvf7, [r0], {110}	; 0x6e
     6a8:	5f6b636f 	svcpl	0x006b636f
     6ac:	6f6c6e55 	svcvs	0x006c6e55
     6b0:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     6b4:	53465400 	movtpl	r5, #25600	; 0x6400
     6b8:	6572545f 	ldrbvs	r5, [r2, #-1119]!	; 0xfffffba1
     6bc:	6f4e5f65 	svcvs	0x004e5f65
     6c0:	4d006564 	cfstr32mi	mvfx6, [r0, #-400]	; 0xfffffe70
     6c4:	69467861 	stmdbvs	r6, {r0, r5, r6, fp, ip, sp, lr}^
     6c8:	616e656c 	cmnvs	lr, ip, ror #10
     6cc:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     6d0:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     6d4:	69786500 	ldmdbvs	r8!, {r8, sl, sp, lr}^
     6d8:	6f635f74 	svcvs	0x00635f74
     6dc:	43006564 	movwmi	r6, #1380	; 0x564
     6e0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     6e4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     6e8:	63006d65 	movwvs	r6, #3429	; 0xd65
     6ec:	646c6968 	strbtvs	r6, [ip], #-2408	; 0xfffff698
     6f0:	006e6572 	rsbeq	r6, lr, r2, ror r5
     6f4:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     6f8:	70757272 	rsbsvc	r7, r5, r2, ror r2
     6fc:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
     700:	6c535f65 	mrrcvs	15, 6, r5, r3, cr5
     704:	00706565 	rsbseq	r6, r0, r5, ror #10
     708:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     70c:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     710:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     714:	50433631 	subpl	r3, r3, r1, lsr r6
     718:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     71c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 558 <shift+0x558>
     720:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     724:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     728:	61657243 	cmnvs	r5, r3, asr #4
     72c:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
     730:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     734:	50457373 	subpl	r7, r5, r3, ror r3
     738:	00626a68 	rsbeq	r6, r2, r8, ror #20
     73c:	616d6e55 	cmnvs	sp, r5, asr lr
     740:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     744:	435f656c 	cmpmi	pc, #108, 10	; 0x1b000000
     748:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     74c:	6100746e 	tstvs	r0, lr, ror #8
     750:	00766772 	rsbseq	r6, r6, r2, ror r7
     754:	314e5a5f 	cmpcc	lr, pc, asr sl
     758:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     75c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     760:	614d5f73 	hvcvs	54771	; 0xd5f3
     764:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     768:	55383172 	ldrpl	r3, [r8, #-370]!	; 0xfffffe8e
     76c:	70616d6e 	rsbvc	r6, r1, lr, ror #26
     770:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     774:	75435f65 	strbvc	r5, [r3, #-3941]	; 0xfffff09b
     778:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     77c:	006a4574 	rsbeq	r4, sl, r4, ror r5
     780:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     784:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     788:	0052525f 	subseq	r5, r2, pc, asr r2
     78c:	626d6f5a 	rsbvs	r6, sp, #360	; 0x168
     790:	57006569 	strpl	r6, [r0, -r9, ror #10]
     794:	00746961 	rsbseq	r6, r4, r1, ror #18
     798:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     79c:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     7a0:	61686320 	cmnvs	r8, r0, lsr #6
     7a4:	46540072 			; <UNDEFINED> instruction: 0x46540072
     7a8:	72445f53 	subvc	r5, r4, #332	; 0x14c
     7ac:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     7b0:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     7b4:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     7b8:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     7bc:	6f72505f 	svcvs	0x0072505f
     7c0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     7c4:	61655200 	cmnvs	r5, r0, lsl #4
     7c8:	72575f64 	subsvc	r5, r7, #100, 30	; 0x190
     7cc:	00657469 	rsbeq	r7, r5, r9, ror #8
     7d0:	6f725073 	svcvs	0x00725073
     7d4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     7d8:	0072674d 	rsbseq	r6, r2, sp, asr #14
     7dc:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     7e0:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
     7e4:	5f323374 	svcpl	0x00323374
     7e8:	5a5f0074 	bpl	17c09c0 <__bss_end+0x17b7b94>
     7ec:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
     7f0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     7f4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     7f8:	4f346d65 	svcmi	0x00346d65
     7fc:	456e6570 	strbmi	r6, [lr, #-1392]!	; 0xfffffa90
     800:	31634b50 	cmncc	r3, r0, asr fp
     804:	69464e35 	stmdbvs	r6, {r0, r2, r4, r5, r9, sl, fp, lr}^
     808:	4f5f656c 	svcmi	0x005f656c
     80c:	5f6e6570 	svcpl	0x006e6570
     810:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     814:	6f6c4200 	svcvs	0x006c4200
     818:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     81c:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     820:	505f746e 	subspl	r7, pc, lr, ror #8
     824:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     828:	46007373 			; <UNDEFINED> instruction: 0x46007373
     82c:	5f646e69 	svcpl	0x00646e69
     830:	6c696843 	stclvs	8, cr6, [r9], #-268	; 0xfffffef4
     834:	61740064 	cmnvs	r4, r4, rrx
     838:	74006b73 	strvc	r6, [r0], #-2931	; 0xfffff48d
     83c:	30726274 	rsbscc	r6, r2, r4, ror r2
     840:	6f526d00 	svcvs	0x00526d00
     844:	4d5f746f 	cfldrdmi	mvd7, [pc, #-444]	; 690 <shift+0x690>
     848:	6400746e 	strvs	r7, [r0], #-1134	; 0xfffffb92
     84c:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     850:	704f0072 	subvc	r0, pc, r2, ror r0	; <UNPREDICTABLE>
     854:	5f006e65 	svcpl	0x00006e65
     858:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     85c:	6f725043 	svcvs	0x00725043
     860:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     864:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     868:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     86c:	614d3931 	cmpvs	sp, r1, lsr r9
     870:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     874:	545f656c 	ldrbpl	r6, [pc], #-1388	; 87c <shift+0x87c>
     878:	75435f6f 	strbvc	r5, [r3, #-3951]	; 0xfffff091
     87c:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     880:	35504574 	ldrbcc	r4, [r0, #-1396]	; 0xfffffa8c
     884:	6c694649 	stclvs	6, cr4, [r9], #-292	; 0xfffffedc
     888:	506d0065 	rsbpl	r0, sp, r5, rrx
     88c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     890:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     894:	5f747369 	svcpl	0x00747369
     898:	64616548 	strbtvs	r6, [r1], #-1352	; 0xfffffab8
     89c:	6f687300 	svcvs	0x00687300
     8a0:	75207472 	strvc	r7, [r0, #-1138]!	; 0xfffffb8e
     8a4:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     8a8:	2064656e 	rsbcs	r6, r4, lr, ror #10
     8ac:	00746e69 	rsbseq	r6, r4, r9, ror #28
     8b0:	6f6f526d 	svcvs	0x006f526d
     8b4:	79535f74 	ldmdbvc	r3, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     8b8:	6f4e0073 	svcvs	0x004e0073
     8bc:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     8c0:	006c6c41 	rsbeq	r6, ip, r1, asr #24
     8c4:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     8c8:	0064656b 	rsbeq	r6, r4, fp, ror #10
     8cc:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     8d0:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
     8d4:	5a5f0079 	bpl	17c0ac0 <__bss_end+0x17b7c94>
     8d8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     8dc:	636f7250 	cmnvs	pc, #80, 4
     8e0:	5f737365 	svcpl	0x00737365
     8e4:	616e614d 	cmnvs	lr, sp, asr #2
     8e8:	43726567 	cmnmi	r2, #432013312	; 0x19c00000
     8ec:	00764534 	rsbseq	r4, r6, r4, lsr r5
     8f0:	5f746547 	svcpl	0x00746547
     8f4:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     8f8:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     8fc:	6e495f72 	mcrvs	15, 2, r5, cr9, cr2, {3}
     900:	5f006f66 	svcpl	0x00006f66
     904:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     908:	6f725043 	svcvs	0x00725043
     90c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     910:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     914:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     918:	63533131 	cmpvs	r3, #1073741836	; 0x4000000c
     91c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     920:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
     924:	00764552 	rsbseq	r4, r6, r2, asr r5
     928:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     92c:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     930:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     934:	68746150 	ldmdavs	r4!, {r4, r6, r8, sp, lr}^
     938:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     93c:	6d006874 	stcvs	8, cr6, [r0, #-464]	; 0xfffffe30
     940:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     944:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     948:	636e465f 	cmnvs	lr, #99614720	; 0x5f00000
     94c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     950:	50433631 	subpl	r3, r3, r1, lsr r6
     954:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     958:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 794 <shift+0x794>
     95c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     960:	31327265 	teqcc	r2, r5, ror #4
     964:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     968:	75435f6b 	strbvc	r5, [r3, #-3947]	; 0xfffff095
     96c:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     970:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     974:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     978:	00764573 	rsbseq	r4, r6, r3, ror r5
     97c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     980:	505f656c 	subspl	r6, pc, ip, ror #10
     984:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     988:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     98c:	4e004957 			; <UNDEFINED> instruction: 0x4e004957
     990:	5f746547 	svcpl	0x00746547
     994:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     998:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     99c:	545f6f66 	ldrbpl	r6, [pc], #-3942	; 9a4 <shift+0x9a4>
     9a0:	00657079 	rsbeq	r7, r5, r9, ror r0
     9a4:	5f746547 	svcpl	0x00746547
     9a8:	636f7250 	cmnvs	pc, #80, 4
     9ac:	5f737365 	svcpl	0x00737365
     9b0:	505f7942 	subspl	r7, pc, r2, asr #18
     9b4:	4d004449 	cfstrsmi	mvf4, [r0, #-292]	; 0xfffffedc
     9b8:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     9bc:	5f656c69 	svcpl	0x00656c69
     9c0:	435f6f54 	cmpmi	pc, #84, 30	; 0x150
     9c4:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     9c8:	4900746e 	stmdbmi	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
     9cc:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     9d0:	6f526d00 	svcvs	0x00526d00
     9d4:	5f00746f 	svcpl	0x0000746f
     9d8:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     9dc:	6f725043 	svcvs	0x00725043
     9e0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     9e4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     9e8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     9ec:	61483831 	cmpvs	r8, r1, lsr r8
     9f0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     9f4:	6f72505f 	svcvs	0x0072505f
     9f8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     9fc:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     a00:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     a04:	5f495753 	svcpl	0x00495753
     a08:	636f7250 	cmnvs	pc, #80, 4
     a0c:	5f737365 	svcpl	0x00737365
     a10:	76726553 			; <UNDEFINED> instruction: 0x76726553
     a14:	6a656369 	bvs	19597c0 <__bss_end+0x1950994>
     a18:	31526a6a 	cmpcc	r2, sl, ror #20
     a1c:	57535431 	smmlarpl	r3, r1, r4, r5
     a20:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     a24:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     a28:	6f6c4300 	svcvs	0x006c4300
     a2c:	5f006573 	svcpl	0x00006573
     a30:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     a34:	6f725043 	svcvs	0x00725043
     a38:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     a3c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     a40:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     a44:	61483132 	cmpvs	r8, r2, lsr r1
     a48:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     a4c:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     a50:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     a54:	5f6d6574 	svcpl	0x006d6574
     a58:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
     a5c:	534e3332 	movtpl	r3, #58162	; 0xe332
     a60:	465f4957 			; <UNDEFINED> instruction: 0x465f4957
     a64:	73656c69 	cmnvc	r5, #26880	; 0x6900
     a68:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     a6c:	65535f6d 	ldrbvs	r5, [r3, #-3949]	; 0xfffff093
     a70:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     a74:	6a6a6a65 	bvs	1a9b410 <__bss_end+0x1a925e4>
     a78:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
     a7c:	5f495753 	svcpl	0x00495753
     a80:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     a84:	4c00746c 	cfstrsmi	mvf7, [r0], {108}	; 0x6c
     a88:	5f6b636f 	svcpl	0x006b636f
     a8c:	6b636f4c 	blvs	18dc7c4 <__bss_end+0x18d3998>
     a90:	43006465 	movwmi	r6, #1125	; 0x465
     a94:	636f7250 	cmnvs	pc, #80, 4
     a98:	5f737365 	svcpl	0x00737365
     a9c:	616e614d 	cmnvs	lr, sp, asr #2
     aa0:	00726567 	rsbseq	r6, r2, r7, ror #10
     aa4:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     aa8:	4e007966 	vmlsmi.f16	s14, s0, s13	; <UNPREDICTABLE>
     aac:	6c69466f 	stclvs	6, cr4, [r9], #-444	; 0xfffffe44
     ab0:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     ab4:	446d6574 	strbtmi	r6, [sp], #-1396	; 0xfffffa8c
     ab8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     abc:	5a5f0072 	bpl	17c0c8c <__bss_end+0x17b7e60>
     ac0:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
     ac4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     ac8:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     acc:	33316d65 	teqcc	r1, #6464	; 0x1940
     ad0:	5f534654 	svcpl	0x00534654
     ad4:	65657254 	strbvs	r7, [r5, #-596]!	; 0xfffffdac
     ad8:	646f4e5f 	strbtvs	r4, [pc], #-3679	; ae0 <shift+0xae0>
     adc:	46303165 	ldrtmi	r3, [r0], -r5, ror #2
     ae0:	5f646e69 	svcpl	0x00646e69
     ae4:	6c696843 	stclvs	8, cr6, [r9], #-268	; 0xfffffef4
     ae8:	4b504564 	blmi	1412080 <__bss_end+0x1409254>
     aec:	65440063 	strbvs	r0, [r4, #-99]	; 0xffffff9d
     af0:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     af4:	555f656e 	ldrbpl	r6, [pc, #-1390]	; 58e <shift+0x58e>
     af8:	6168636e 	cmnvs	r8, lr, ror #6
     afc:	6465676e 	strbtvs	r6, [r5], #-1902	; 0xfffff892
     b00:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     b04:	46433131 			; <UNDEFINED> instruction: 0x46433131
     b08:	73656c69 	cmnvc	r5, #26880	; 0x6900
     b0c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     b10:	4534436d 	ldrmi	r4, [r4, #-877]!	; 0xfffffc93
     b14:	5a5f0076 	bpl	17c0cf4 <__bss_end+0x17b7ec8>
     b18:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     b1c:	636f7250 	cmnvs	pc, #80, 4
     b20:	5f737365 	svcpl	0x00737365
     b24:	616e614d 	cmnvs	lr, sp, asr #2
     b28:	31726567 	cmncc	r2, r7, ror #10
     b2c:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     b30:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     b34:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     b38:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     b3c:	456f666e 	strbmi	r6, [pc, #-1646]!	; 4d6 <shift+0x4d6>
     b40:	474e3032 	smlaldxmi	r3, lr, r2, r0
     b44:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     b48:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     b4c:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     b50:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     b54:	76506570 			; <UNDEFINED> instruction: 0x76506570
     b58:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
     b5c:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
     b60:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     b64:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     b68:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     b6c:	006f666e 	rsbeq	r6, pc, lr, ror #12
     b70:	6d726554 	cfldr64vs	mvdx6, [r2, #-336]!	; 0xfffffeb0
     b74:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
     b78:	46490065 	strbmi	r0, [r9], -r5, rrx
     b7c:	73656c69 	cmnvc	r5, #26880	; 0x6900
     b80:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     b84:	72445f6d 	subvc	r5, r4, #436	; 0x1b4
     b88:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     b8c:	65727000 	ldrbvs	r7, [r2, #-0]!
     b90:	63410076 	movtvs	r0, #4214	; 0x1076
     b94:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     b98:	6f72505f 	svcvs	0x0072505f
     b9c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     ba0:	756f435f 	strbvc	r4, [pc, #-863]!	; 849 <shift+0x849>
     ba4:	5f00746e 	svcpl	0x0000746e
     ba8:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     bac:	6f725043 	svcvs	0x00725043
     bb0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     bb4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     bb8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     bbc:	69775339 	ldmdbvs	r7!, {r0, r3, r4, r5, r8, r9, ip, lr}^
     bc0:	5f686374 	svcpl	0x00686374
     bc4:	50456f54 	subpl	r6, r5, r4, asr pc
     bc8:	50433831 	subpl	r3, r3, r1, lsr r8
     bcc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     bd0:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     bd4:	5f747369 	svcpl	0x00747369
     bd8:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     bdc:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     be0:	635f6465 	cmpvs	pc, #1694498816	; 0x65000000
     be4:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     be8:	53007265 	movwpl	r7, #613	; 0x265
     bec:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     bf0:	5f656c75 	svcpl	0x00656c75
     bf4:	00464445 	subeq	r4, r6, r5, asr #8
     bf8:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     bfc:	6e4f5f65 	cdpvs	15, 4, cr5, cr15, cr5, {3}
     c00:	6e00796c 	vmlsvs.f16	s14, s0, s25	; <UNPREDICTABLE>
     c04:	00747865 	rsbseq	r7, r4, r5, ror #16
     c08:	314e5a5f 	cmpcc	lr, pc, asr sl
     c0c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     c10:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     c14:	614d5f73 	hvcvs	54771	; 0xd5f3
     c18:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     c1c:	53323172 	teqpl	r2, #-2147483620	; 0x8000001c
     c20:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     c24:	5f656c75 	svcpl	0x00656c75
     c28:	45464445 	strbmi	r4, [r6, #-1093]	; 0xfffffbbb
     c2c:	5a5f0076 	bpl	17c0e0c <__bss_end+0x17b7fe0>
     c30:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     c34:	636f7250 	cmnvs	pc, #80, 4
     c38:	5f737365 	svcpl	0x00737365
     c3c:	616e614d 	cmnvs	lr, sp, asr #2
     c40:	31726567 	cmncc	r2, r7, ror #10
     c44:	746f4e34 	strbtvc	r4, [pc], #-3636	; c4c <shift+0xc4c>
     c48:	5f796669 	svcpl	0x00796669
     c4c:	636f7250 	cmnvs	pc, #80, 4
     c50:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     c54:	54323150 	ldrtpl	r3, [r2], #-336	; 0xfffffeb0
     c58:	6b736154 	blvs	1cd91b0 <__bss_end+0x1cd0384>
     c5c:	7274535f 	rsbsvc	r5, r4, #2080374785	; 0x7c000001
     c60:	00746375 	rsbseq	r6, r4, r5, ror r3
     c64:	314e5a5f 	cmpcc	lr, pc, asr sl
     c68:	69464331 	stmdbvs	r6, {r0, r4, r5, r8, r9, lr}^
     c6c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     c70:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     c74:	6e493031 	mcrvs	0, 2, r3, cr9, cr1, {1}
     c78:	61697469 	cmnvs	r9, r9, ror #8
     c7c:	657a696c 	ldrbvs	r6, [sl, #-2412]!	; 0xfffff694
     c80:	63007645 	movwvs	r7, #1605	; 0x645
     c84:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
     c88:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     c8c:	6c65525f 	sfmvs	f5, 2, [r5], #-380	; 0xfffffe84
     c90:	76697461 	strbtvc	r7, [r9], -r1, ror #8
     c94:	4e470065 	cdpmi	0, 4, cr0, cr7, cr5, {3}
     c98:	2b432055 	blcs	10c8df4 <__bss_end+0x10bffc8>
     c9c:	2034312b 	eorscs	r3, r4, fp, lsr #2
     ca0:	2e332e38 	mrccs	14, 1, r2, cr3, cr8, {1}
     ca4:	30322031 	eorscc	r2, r2, r1, lsr r0
     ca8:	37303931 			; <UNDEFINED> instruction: 0x37303931
     cac:	28203330 	stmdacs	r0!, {r4, r5, r8, r9, ip, sp}
     cb0:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
     cb4:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
     cb8:	63675b20 	cmnvs	r7, #32, 22	; 0x8000
     cbc:	2d382d63 	ldccs	13, cr2, [r8, #-396]!	; 0xfffffe74
     cc0:	6e617262 	cdpvs	2, 6, cr7, cr1, cr2, {3}
     cc4:	72206863 	eorvc	r6, r0, #6488064	; 0x630000
     cc8:	73697665 	cmnvc	r9, #105906176	; 0x6500000
     ccc:	206e6f69 	rsbcs	r6, lr, r9, ror #30
     cd0:	30333732 	eorscc	r3, r3, r2, lsr r7
     cd4:	205d3732 	subscs	r3, sp, r2, lsr r7
     cd8:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
     cdc:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
     ce0:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     ce4:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     ce8:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     cec:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
     cf0:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     cf4:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
     cf8:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
     cfc:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
     d00:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
     d04:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
     d08:	6f6c666d 	svcvs	0x006c666d
     d0c:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
     d10:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
     d14:	20647261 	rsbcs	r7, r4, r1, ror #4
     d18:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
     d1c:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
     d20:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
     d24:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
     d28:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     d2c:	36373131 			; <UNDEFINED> instruction: 0x36373131
     d30:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
     d34:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
     d38:	206d7261 	rsbcs	r7, sp, r1, ror #4
     d3c:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     d40:	613d6863 	teqvs	sp, r3, ror #16
     d44:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
     d48:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
     d4c:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
     d50:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     d54:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     d58:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
     d5c:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
     d60:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; bd0 <shift+0xbd0>
     d64:	65637865 	strbvs	r7, [r3, #-2149]!	; 0xfffff79b
     d68:	6f697470 	svcvs	0x00697470
     d6c:	2d20736e 	stccs	3, cr7, [r0, #-440]!	; 0xfffffe48
     d70:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; be0 <shift+0xbe0>
     d74:	69747472 	ldmdbvs	r4!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     d78:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
     d7c:	006c6176 	rsbeq	r6, ip, r6, ror r1
     d80:	7275636e 	rsbsvc	r6, r5, #-1207959551	; 0xb8000001
     d84:	70697000 	rsbvc	r7, r9, r0
     d88:	64720065 	ldrbtvs	r0, [r2], #-101	; 0xffffff9b
     d8c:	006d756e 	rsbeq	r7, sp, lr, ror #10
     d90:	31315a5f 	teqcc	r1, pc, asr sl
     d94:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     d98:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     d9c:	76646c65 	strbtvc	r6, [r4], -r5, ror #24
     da0:	315a5f00 	cmpcc	sl, r0, lsl #30
     da4:	74657337 	strbtvc	r7, [r5], #-823	; 0xfffffcc9
     da8:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     dac:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
     db0:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     db4:	006a656e 	rsbeq	r6, sl, lr, ror #10
     db8:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
     dbc:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
     dc0:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     dc4:	6a6a7966 	bvs	1a9f364 <__bss_end+0x1a96538>
     dc8:	395a5f00 	ldmdbcc	sl, {r8, r9, sl, fp, ip, lr}^
     dcc:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
     dd0:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
     dd4:	2f006965 	svccs	0x00006965
     dd8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     ddc:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
     de0:	2f6b6974 	svccs	0x006b6974
     de4:	2f766564 	svccs	0x00766564
     de8:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
     dec:	534f5452 	movtpl	r5, #62546	; 0xf452
     df0:	73616d2d 	cmnvc	r1, #2880	; 0xb40
     df4:	2f726574 	svccs	0x00726574
     df8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     dfc:	2f736563 	svccs	0x00736563
     e00:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
     e04:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
     e08:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
     e0c:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
     e10:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
     e14:	46007070 			; <UNDEFINED> instruction: 0x46007070
     e18:	006c6961 	rsbeq	r6, ip, r1, ror #18
     e1c:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     e20:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     e24:	325a5f00 	subscc	r5, sl, #0, 30
     e28:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
     e2c:	7463615f 	strbtvc	r6, [r3], #-351	; 0xfffffea1
     e30:	5f657669 	svcpl	0x00657669
     e34:	636f7270 	cmnvs	pc, #112, 4
     e38:	5f737365 	svcpl	0x00737365
     e3c:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     e40:	73007674 	movwvc	r7, #1652	; 0x674
     e44:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     e48:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
     e4c:	7400646c 	strvc	r6, [r0], #-1132	; 0xfffffb94
     e50:	5f6b6369 	svcpl	0x006b6369
     e54:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     e58:	65725f74 	ldrbvs	r5, [r2, #-3956]!	; 0xfffff08c
     e5c:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
     e60:	50006465 	andpl	r6, r0, r5, ror #8
     e64:	5f657069 	svcpl	0x00657069
     e68:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     e6c:	6572505f 	ldrbvs	r5, [r2, #-95]!	; 0xffffffa1
     e70:	00786966 	rsbseq	r6, r8, r6, ror #18
     e74:	5f746553 	svcpl	0x00746553
     e78:	61726150 	cmnvs	r2, r0, asr r1
     e7c:	5f00736d 	svcpl	0x0000736d
     e80:	6734315a 			; <UNDEFINED> instruction: 0x6734315a
     e84:	745f7465 	ldrbvc	r7, [pc], #-1125	; e8c <shift+0xe8c>
     e88:	5f6b6369 	svcpl	0x006b6369
     e8c:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     e90:	73007674 	movwvc	r7, #1652	; 0x674
     e94:	7065656c 	rsbvc	r6, r5, ip, ror #10
     e98:	6f682f00 	svcvs	0x00682f00
     e9c:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
     ea0:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
     ea4:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
     ea8:	494b2f76 	stmdbmi	fp, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
     eac:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
     eb0:	6d2d534f 	stcvs	3, cr5, [sp, #-316]!	; 0xfffffec4
     eb4:	65747361 	ldrbvs	r7, [r4, #-865]!	; 0xfffffc9f
     eb8:	6f732f72 	svcvs	0x00732f72
     ebc:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     ec0:	75622f73 	strbvc	r2, [r2, #-3955]!	; 0xfffff08d
     ec4:	00646c69 	rsbeq	r6, r4, r9, ror #24
     ec8:	61736944 	cmnvs	r3, r4, asr #18
     ecc:	5f656c62 	svcpl	0x00656c62
     ed0:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     ed4:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     ed8:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     edc:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     ee0:	7265706f 	rsbvc	r7, r5, #111	; 0x6f
     ee4:	6f697461 	svcvs	0x00697461
     ee8:	5a5f006e 	bpl	17c10a8 <__bss_end+0x17b827c>
     eec:	6f6c6335 	svcvs	0x006c6335
     ef0:	006a6573 	rsbeq	r6, sl, r3, ror r5
     ef4:	67365a5f 			; <UNDEFINED> instruction: 0x67365a5f
     ef8:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
     efc:	66007664 	strvs	r7, [r0], -r4, ror #12
     f00:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     f04:	746f6e00 	strbtvc	r6, [pc], #-3584	; f0c <shift+0xf0c>
     f08:	00796669 	rsbseq	r6, r9, r9, ror #12
     f0c:	6b636974 	blvs	18db4e4 <__bss_end+0x18d26b8>
     f10:	706f0073 	rsbvc	r0, pc, r3, ror r0	; <UNPREDICTABLE>
     f14:	5f006e65 	svcpl	0x00006e65
     f18:	6970345a 	ldmdbvs	r0!, {r1, r3, r4, r6, sl, ip, sp}^
     f1c:	4b506570 	blmi	141a4e4 <__bss_end+0x14116b8>
     f20:	4e006a63 	vmlsmi.f32	s12, s0, s7
     f24:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     f28:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     f2c:	6275535f 	rsbsvs	r5, r5, #2080374785	; 0x7c000001
     f30:	76726573 			; <UNDEFINED> instruction: 0x76726573
     f34:	00656369 	rsbeq	r6, r5, r9, ror #6
     f38:	5f746567 	svcpl	0x00746567
     f3c:	6b636974 	blvs	18db514 <__bss_end+0x18d26e8>
     f40:	756f635f 	strbvc	r6, [pc, #-863]!	; be9 <shift+0xbe9>
     f44:	7000746e 	andvc	r7, r0, lr, ror #8
     f48:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     f4c:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     f50:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
     f54:	4b506a65 	blmi	141b8f0 <__bss_end+0x1412ac4>
     f58:	67006a63 	strvs	r6, [r0, -r3, ror #20]
     f5c:	745f7465 	ldrbvc	r7, [pc], #-1125	; f64 <shift+0xf64>
     f60:	5f6b7361 	svcpl	0x006b7361
     f64:	6b636974 	blvs	18db53c <__bss_end+0x18d2710>
     f68:	6f745f73 	svcvs	0x00745f73
     f6c:	6165645f 	cmnvs	r5, pc, asr r4
     f70:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     f74:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
     f78:	69735f66 	ldmdbvs	r3!, {r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     f7c:	7700657a 	smlsdxvc	r0, sl, r5, r6
     f80:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     f84:	74657300 	strbtvc	r7, [r5], #-768	; 0xfffffd00
     f88:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     f8c:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
     f90:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     f94:	4700656e 	strmi	r6, [r0, -lr, ror #10]
     f98:	505f7465 	subspl	r7, pc, r5, ror #8
     f9c:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     fa0:	5a5f0073 	bpl	17c1174 <__bss_end+0x17b8348>
     fa4:	656c7335 	strbvs	r7, [ip, #-821]!	; 0xfffffccb
     fa8:	6a6a7065 	bvs	1a9d144 <__bss_end+0x1a94318>
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
     fe4:	6b636974 	blvs	18db5bc <__bss_end+0x18d2790>
     fe8:	6f745f73 	svcvs	0x00745f73
     fec:	6165645f 	cmnvs	r5, pc, asr r4
     ff0:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     ff4:	4e007665 	cfmadd32mi	mvax3, mvfx7, mvfx0, mvfx5
     ff8:	5f495753 	svcpl	0x00495753
     ffc:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
    1000:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
    1004:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1008:	756e7277 	strbvc	r7, [lr, #-631]!	; 0xfffffd89
    100c:	5a5f006d 	bpl	17c11c8 <__bss_end+0x17b839c>
    1010:	69617734 	stmdbvs	r1!, {r2, r4, r5, r8, r9, sl, ip, sp, lr}^
    1014:	6a6a6a74 	bvs	1a9b9ec <__bss_end+0x1a92bc0>
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
    1058:	5a5f0072 	bpl	17c1228 <__bss_end+0x17b83fc>
    105c:	61657234 	cmnvs	r5, r4, lsr r2
    1060:	63506a64 	cmpvs	r0, #100, 20	; 0x64000
    1064:	494e006a 	stmdbmi	lr, {r1, r3, r5, r6}^
    1068:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
    106c:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    1070:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    1074:	72006e6f 	andvc	r6, r0, #1776	; 0x6f0
    1078:	6f637465 	svcvs	0x00637465
    107c:	67006564 	strvs	r6, [r0, -r4, ror #10]
    1080:	615f7465 	cmpvs	pc, r5, ror #8
    1084:	76697463 	strbtvc	r7, [r9], -r3, ror #8
    1088:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
    108c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1090:	6f635f73 	svcvs	0x00635f73
    1094:	00746e75 	rsbseq	r6, r4, r5, ror lr
    1098:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    109c:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    10a0:	61657200 	cmnvs	r5, r0, lsl #4
    10a4:	65670064 	strbvs	r0, [r7, #-100]!	; 0xffffff9c
    10a8:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
    10ac:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    10b0:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
    10b4:	31634b50 	cmncc	r3, r0, asr fp
    10b8:	69464e35 	stmdbvs	r6, {r0, r2, r4, r5, r9, sl, fp, lr}^
    10bc:	4f5f656c 	svcmi	0x005f656c
    10c0:	5f6e6570 	svcpl	0x006e6570
    10c4:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
    10c8:	706e6900 	rsbvc	r6, lr, r0, lsl #18
    10cc:	64007475 	strvs	r7, [r0], #-1141	; 0xfffffb8b
    10d0:	00747365 	rsbseq	r7, r4, r5, ror #6
    10d4:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    10d8:	656c006f 	strbvs	r0, [ip, #-111]!	; 0xffffff91
    10dc:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
    10e0:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    10e4:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    10e8:	6976506f 	ldmdbvs	r6!, {r0, r1, r2, r3, r5, r6, ip, lr}^
    10ec:	6f682f00 	svcvs	0x00682f00
    10f0:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    10f4:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    10f8:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
    10fc:	494b2f76 	stmdbmi	fp, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
    1100:	54522d56 	ldrbpl	r2, [r2], #-3414	; 0xfffff2aa
    1104:	6d2d534f 	stcvs	3, cr5, [sp, #-316]!	; 0xfffffec4
    1108:	65747361 	ldrbvs	r7, [r4, #-865]!	; 0xfffffc9f
    110c:	6f732f72 	svcvs	0x00732f72
    1110:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1114:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    1118:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    111c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    1120:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1124:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1128:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
    112c:	43007070 	movwmi	r7, #112	; 0x70
    1130:	43726168 	cmnmi	r2, #104, 2
    1134:	41766e6f 	cmnmi	r6, pc, ror #28
    1138:	6d007272 	sfmvs	f7, 4, [r0, #-456]	; 0xfffffe38
    113c:	73646d65 	cmnvc	r4, #6464	; 0x1940
    1140:	756f0074 	strbvc	r0, [pc, #-116]!	; 10d4 <shift+0x10d4>
    1144:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    1148:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    114c:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    1150:	4b507970 	blmi	141f718 <__bss_end+0x14168ec>
    1154:	69765076 	ldmdbvs	r6!, {r1, r2, r4, r5, r6, ip, lr}^
    1158:	73616200 	cmnvc	r1, #0, 4
    115c:	656d0065 	strbvs	r0, [sp, #-101]!	; 0xffffff9b
    1160:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    1164:	72747300 	rsbsvc	r7, r4, #0, 6
    1168:	006e656c 	rsbeq	r6, lr, ip, ror #10
    116c:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    1170:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1174:	4b50706d 	blmi	141d330 <__bss_end+0x1414504>
    1178:	5f305363 	svcpl	0x00305363
    117c:	5a5f0069 	bpl	17c1328 <__bss_end+0x17b84fc>
    1180:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
    1184:	506e656c 	rsbpl	r6, lr, ip, ror #10
    1188:	6100634b 	tstvs	r0, fp, asr #6
    118c:	00696f74 	rsbeq	r6, r9, r4, ror pc
    1190:	61345a5f 	teqvs	r4, pc, asr sl
    1194:	50696f74 	rsbpl	r6, r9, r4, ror pc
    1198:	5f00634b 	svcpl	0x0000634b
    119c:	7473375a 	ldrbtvc	r3, [r3], #-1882	; 0xfffff8a6
    11a0:	70636e72 	rsbvc	r6, r3, r2, ror lr
    11a4:	50635079 	rsbpl	r5, r3, r9, ror r0
    11a8:	0069634b 	rsbeq	r6, r9, fp, asr #6
    11ac:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    11b0:	00706d63 	rsbseq	r6, r0, r3, ror #26
    11b4:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    11b8:	00797063 	rsbseq	r7, r9, r3, rrx
    11bc:	6f6d656d 	svcvs	0x006d656d
    11c0:	6d007972 	vstrvs.16	s14, [r0, #-228]	; 0xffffff1c	; <UNPREDICTABLE>
    11c4:	72736d65 	rsbsvc	r6, r3, #6464	; 0x1940
    11c8:	74690063 	strbtvc	r0, [r9], #-99	; 0xffffff9d
    11cc:	5f00616f 	svcpl	0x0000616f
    11d0:	7469345a 	strbtvc	r3, [r9], #-1114	; 0xfffffba6
    11d4:	506a616f 	rsbpl	r6, sl, pc, ror #2
    11d8:	2e006a63 	vmlscs.f32	s12, s0, s7
    11dc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    11e0:	2f2e2e2f 	svccs	0x002e2e2f
    11e4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    11e8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    11ec:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    11f0:	2f636367 	svccs	0x00636367
    11f4:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    11f8:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    11fc:	6c2f6d72 	stcvs	13, cr6, [pc], #-456	; 103c <shift+0x103c>
    1200:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
    1204:	73636e75 	cmnvc	r3, #1872	; 0x750
    1208:	2f00532e 	svccs	0x0000532e
    120c:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1210:	63672f64 	cmnvs	r7, #100, 30	; 0x190
    1214:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    1218:	6f6e2d6d 	svcvs	0x006e2d6d
    121c:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1220:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1224:	5662537a 			; <UNDEFINED> instruction: 0x5662537a
    1228:	672f6e66 	strvs	r6, [pc, -r6, ror #28]!
    122c:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    1230:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1234:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1238:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    123c:	322d382d 	eorcc	r3, sp, #2949120	; 0x2d0000
    1240:	2d393130 	ldfcss	f3, [r9, #-192]!	; 0xffffff40
    1244:	622f3371 	eorvs	r3, pc, #-1006632959	; 0xc4000001
    1248:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    124c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1250:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    1254:	61652d65 	cmnvs	r5, r5, ror #26
    1258:	612f6962 			; <UNDEFINED> instruction: 0x612f6962
    125c:	762f6d72 			; <UNDEFINED> instruction: 0x762f6d72
    1260:	2f657435 	svccs	0x00657435
    1264:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1268:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    126c:	00636367 	rsbeq	r6, r3, r7, ror #6
    1270:	20554e47 	subscs	r4, r5, r7, asr #28
    1274:	32205341 	eorcc	r5, r0, #67108865	; 0x4000001
    1278:	0034332e 	eorseq	r3, r4, lr, lsr #6
    127c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1280:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1284:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1288:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    128c:	37316178 			; <UNDEFINED> instruction: 0x37316178
    1290:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1294:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1298:	61736900 	cmnvs	r3, r0, lsl #18
    129c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    12a0:	5f70665f 	svcpl	0x0070665f
    12a4:	006c6264 	rsbeq	r6, ip, r4, ror #4
    12a8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    12ac:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    12b0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    12b4:	31316d72 	teqcc	r1, r2, ror sp
    12b8:	736a3633 	cmnvc	sl, #53477376	; 0x3300000
    12bc:	6d726100 	ldfvse	f6, [r2, #-0]
    12c0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    12c4:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    12c8:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    12cc:	52415400 	subpl	r5, r1, #0, 8
    12d0:	5f544547 	svcpl	0x00544547
    12d4:	5f555043 	svcpl	0x00555043
    12d8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    12dc:	326d7865 	rsbcc	r7, sp, #6619136	; 0x650000
    12e0:	52410033 	subpl	r0, r1, #51	; 0x33
    12e4:	51455f4d 	cmppl	r5, sp, asr #30
    12e8:	52415400 	subpl	r5, r1, #0, 8
    12ec:	5f544547 	svcpl	0x00544547
    12f0:	5f555043 	svcpl	0x00555043
    12f4:	316d7261 	cmncc	sp, r1, ror #4
    12f8:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    12fc:	00736632 	rsbseq	r6, r3, r2, lsr r6
    1300:	5f617369 	svcpl	0x00617369
    1304:	5f746962 	svcpl	0x00746962
    1308:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    130c:	41540062 	cmpmi	r4, r2, rrx
    1310:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1314:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1318:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    131c:	61786574 	cmnvs	r8, r4, ror r5
    1320:	6f633735 	svcvs	0x00633735
    1324:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1328:	00333561 	eorseq	r3, r3, r1, ror #10
    132c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1330:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1334:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    1338:	5341425f 	movtpl	r4, #4703	; 0x125f
    133c:	41540045 	cmpmi	r4, r5, asr #32
    1340:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1344:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1348:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    134c:	00303138 	eorseq	r3, r0, r8, lsr r1
    1350:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1354:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1358:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    135c:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    1360:	52410031 	subpl	r0, r1, #49	; 0x31
    1364:	43505f4d 	cmpmi	r0, #308	; 0x134
    1368:	41415f53 	cmpmi	r1, r3, asr pc
    136c:	5f534350 	svcpl	0x00534350
    1370:	4d4d5749 	stclmi	7, cr5, [sp, #-292]	; 0xfffffedc
    1374:	54005458 	strpl	r5, [r0], #-1112	; 0xfffffba8
    1378:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    137c:	50435f54 	subpl	r5, r3, r4, asr pc
    1380:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1384:	6964376d 	stmdbvs	r4!, {r0, r2, r3, r5, r6, r8, r9, sl, ip, sp}^
    1388:	53414200 	movtpl	r4, #4608	; 0x1200
    138c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1390:	325f4843 	subscc	r4, pc, #4390912	; 0x430000
    1394:	53414200 	movtpl	r4, #4608	; 0x1200
    1398:	52415f45 	subpl	r5, r1, #276	; 0x114
    139c:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    13a0:	52415400 	subpl	r5, r1, #0, 8
    13a4:	5f544547 	svcpl	0x00544547
    13a8:	5f555043 	svcpl	0x00555043
    13ac:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    13b0:	42006d64 	andmi	r6, r0, #100, 26	; 0x1900
    13b4:	5f455341 	svcpl	0x00455341
    13b8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    13bc:	4200355f 	andmi	r3, r0, #398458880	; 0x17c00000
    13c0:	5f455341 	svcpl	0x00455341
    13c4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    13c8:	4200365f 	andmi	r3, r0, #99614720	; 0x5f00000
    13cc:	5f455341 	svcpl	0x00455341
    13d0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    13d4:	5400375f 	strpl	r3, [r0], #-1887	; 0xfffff8a1
    13d8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    13dc:	50435f54 	subpl	r5, r3, r4, asr pc
    13e0:	73785f55 	cmnvc	r8, #340	; 0x154
    13e4:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    13e8:	52415400 	subpl	r5, r1, #0, 8
    13ec:	5f544547 	svcpl	0x00544547
    13f0:	5f555043 	svcpl	0x00555043
    13f4:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    13f8:	73653634 	cmnvc	r5, #52, 12	; 0x3400000
    13fc:	52415400 	subpl	r5, r1, #0, 8
    1400:	5f544547 	svcpl	0x00544547
    1404:	5f555043 	svcpl	0x00555043
    1408:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    140c:	336d7865 	cmncc	sp, #6619136	; 0x650000
    1410:	41540033 	cmpmi	r4, r3, lsr r0
    1414:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1418:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    141c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1420:	6d647437 	cfstrdvs	mvd7, [r4, #-220]!	; 0xffffff24
    1424:	73690069 	cmnvc	r9, #105	; 0x69
    1428:	6f6e5f61 	svcvs	0x006e5f61
    142c:	00746962 	rsbseq	r6, r4, r2, ror #18
    1430:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1434:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1438:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    143c:	31316d72 	teqcc	r1, r2, ror sp
    1440:	7a6a3637 	bvc	1a8ed24 <__bss_end+0x1a85ef8>
    1444:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1448:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    144c:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1450:	32767066 	rsbscc	r7, r6, #102	; 0x66
    1454:	4d524100 	ldfmie	f4, [r2, #-0]
    1458:	5343505f 	movtpl	r5, #12383	; 0x305f
    145c:	4b4e555f 	blmi	13969e0 <__bss_end+0x138dbb4>
    1460:	4e574f4e 	cdpmi	15, 5, cr4, cr7, cr14, {2}
    1464:	52415400 	subpl	r5, r1, #0, 8
    1468:	5f544547 	svcpl	0x00544547
    146c:	5f555043 	svcpl	0x00555043
    1470:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1474:	41420065 	cmpmi	r2, r5, rrx
    1478:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    147c:	5f484352 	svcpl	0x00484352
    1480:	4a455435 	bmi	115655c <__bss_end+0x114d730>
    1484:	6d726100 	ldfvse	f6, [r2, #-0]
    1488:	6663635f 			; <UNDEFINED> instruction: 0x6663635f
    148c:	735f6d73 	cmpvc	pc, #7360	; 0x1cc0
    1490:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
    1494:	736e7500 	cmnvc	lr, #0, 10
    1498:	5f636570 	svcpl	0x00636570
    149c:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    14a0:	0073676e 	rsbseq	r6, r3, lr, ror #14
    14a4:	5f617369 	svcpl	0x00617369
    14a8:	5f746962 	svcpl	0x00746962
    14ac:	00636573 	rsbeq	r6, r3, r3, ror r5
    14b0:	6c635f5f 	stclvs	15, cr5, [r3], #-380	; 0xfffffe84
    14b4:	61745f7a 	cmnvs	r4, sl, ror pc
    14b8:	52410062 	subpl	r0, r1, #98	; 0x62
    14bc:	43565f4d 	cmpmi	r6, #308	; 0x134
    14c0:	6d726100 	ldfvse	f6, [r2, #-0]
    14c4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    14c8:	73785f68 	cmnvc	r8, #104, 30	; 0x1a0
    14cc:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    14d0:	4d524100 	ldfmie	f4, [r2, #-0]
    14d4:	00454c5f 	subeq	r4, r5, pc, asr ip
    14d8:	5f4d5241 	svcpl	0x004d5241
    14dc:	41005356 	tstmi	r0, r6, asr r3
    14e0:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    14e4:	72610045 	rsbvc	r0, r1, #69	; 0x45
    14e8:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    14ec:	735f656e 	cmpvc	pc, #461373440	; 0x1b800000
    14f0:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    14f4:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    14f8:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 1500 <shift+0x1500>
    14fc:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    1500:	6f6c6620 	svcvs	0x006c6620
    1504:	54007461 	strpl	r7, [r0], #-1121	; 0xfffffb9f
    1508:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    150c:	50435f54 	subpl	r5, r3, r4, asr pc
    1510:	6f635f55 	svcvs	0x00635f55
    1514:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1518:	00353161 	eorseq	r3, r5, r1, ror #2
    151c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1520:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1524:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1528:	36323761 	ldrtcc	r3, [r2], -r1, ror #14
    152c:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    1530:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1534:	50435f54 	subpl	r5, r3, r4, asr pc
    1538:	6f635f55 	svcvs	0x00635f55
    153c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1540:	00373161 	eorseq	r3, r7, r1, ror #2
    1544:	5f4d5241 	svcpl	0x004d5241
    1548:	41005447 	tstmi	r0, r7, asr #8
    154c:	4c5f4d52 	mrrcmi	13, 5, r4, pc, cr2	; <UNPREDICTABLE>
    1550:	2e2e0054 	mcrcs	0, 1, r0, cr14, cr4, {2}
    1554:	2f2e2e2f 	svccs	0x002e2e2f
    1558:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    155c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1560:	2f2e2e2f 	svccs	0x002e2e2f
    1564:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1568:	6c2f6363 	stcvs	3, cr6, [pc], #-396	; 13e4 <shift+0x13e4>
    156c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1570:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    1574:	52415400 	subpl	r5, r1, #0, 8
    1578:	5f544547 	svcpl	0x00544547
    157c:	5f555043 	svcpl	0x00555043
    1580:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1584:	34727865 	ldrbtcc	r7, [r2], #-2149	; 0xfffff79b
    1588:	41540066 	cmpmi	r4, r6, rrx
    158c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1590:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1594:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1598:	00303239 	eorseq	r3, r0, r9, lsr r2
    159c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    15a0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    15a4:	45375f48 	ldrmi	r5, [r7, #-3912]!	; 0xfffff0b8
    15a8:	4154004d 	cmpmi	r4, sp, asr #32
    15ac:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    15b0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    15b4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    15b8:	61786574 	cmnvs	r8, r4, ror r5
    15bc:	68003231 	stmdavs	r0, {r0, r4, r5, r9, ip, sp}
    15c0:	76687361 	strbtvc	r7, [r8], -r1, ror #6
    15c4:	745f6c61 	ldrbvc	r6, [pc], #-3169	; 15cc <shift+0x15cc>
    15c8:	53414200 	movtpl	r4, #4608	; 0x1200
    15cc:	52415f45 	subpl	r5, r1, #276	; 0x114
    15d0:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    15d4:	69005a4b 	stmdbvs	r0, {r0, r1, r3, r6, r9, fp, ip, lr}
    15d8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    15dc:	00737469 	rsbseq	r7, r3, r9, ror #8
    15e0:	5f6d7261 	svcpl	0x006d7261
    15e4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    15e8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    15ec:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
    15f0:	61007669 	tstvs	r0, r9, ror #12
    15f4:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    15f8:	645f7570 	ldrbvs	r7, [pc], #-1392	; 1600 <shift+0x1600>
    15fc:	00637365 	rsbeq	r7, r3, r5, ror #6
    1600:	5f617369 	svcpl	0x00617369
    1604:	5f746962 	svcpl	0x00746962
    1608:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    160c:	4d524100 	ldfmie	f4, [r2, #-0]
    1610:	0049485f 	subeq	r4, r9, pc, asr r8
    1614:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1618:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    161c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1620:	00326d72 	eorseq	r6, r2, r2, ror sp
    1624:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1628:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    162c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1630:	00336d72 	eorseq	r6, r3, r2, ror sp
    1634:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1638:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    163c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1640:	31376d72 	teqcc	r7, r2, ror sp
    1644:	54003030 	strpl	r3, [r0], #-48	; 0xffffffd0
    1648:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    164c:	50435f54 	subpl	r5, r3, r4, asr pc
    1650:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1654:	5400366d 	strpl	r3, [r0], #-1645	; 0xfffff993
    1658:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    165c:	50435f54 	subpl	r5, r3, r4, asr pc
    1660:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1664:	5400376d 	strpl	r3, [r0], #-1901	; 0xfffff893
    1668:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    166c:	50435f54 	subpl	r5, r3, r4, asr pc
    1670:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1674:	5400386d 	strpl	r3, [r0], #-2157	; 0xfffff793
    1678:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    167c:	50435f54 	subpl	r5, r3, r4, asr pc
    1680:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1684:	5400396d 	strpl	r3, [r0], #-2413	; 0xfffff693
    1688:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    168c:	50435f54 	subpl	r5, r3, r4, asr pc
    1690:	61665f55 	cmnvs	r6, r5, asr pc
    1694:	00363236 	eorseq	r3, r6, r6, lsr r2
    1698:	47524154 			; <UNDEFINED> instruction: 0x47524154
    169c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    16a0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    16a4:	6e5f6d72 	mrcvs	13, 2, r6, cr15, cr2, {3}
    16a8:	00656e6f 	rsbeq	r6, r5, pc, ror #28
    16ac:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    16b0:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
    16b4:	6e752067 	cdpvs	0, 7, cr2, cr5, cr7, {3}
    16b8:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    16bc:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
    16c0:	6100746e 	tstvs	r0, lr, ror #8
    16c4:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    16c8:	5f686372 	svcpl	0x00686372
    16cc:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    16d0:	52415400 	subpl	r5, r1, #0, 8
    16d4:	5f544547 	svcpl	0x00544547
    16d8:	5f555043 	svcpl	0x00555043
    16dc:	366d7261 	strbtcc	r7, [sp], -r1, ror #4
    16e0:	54003031 	strpl	r3, [r0], #-49	; 0xffffffcf
    16e4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    16e8:	50435f54 	subpl	r5, r3, r4, asr pc
    16ec:	6f635f55 	svcvs	0x00635f55
    16f0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    16f4:	5400346d 	strpl	r3, [r0], #-1133	; 0xfffffb93
    16f8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    16fc:	50435f54 	subpl	r5, r3, r4, asr pc
    1700:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1704:	6530316d 	ldrvs	r3, [r0, #-365]!	; 0xfffffe93
    1708:	52415400 	subpl	r5, r1, #0, 8
    170c:	5f544547 	svcpl	0x00544547
    1710:	5f555043 	svcpl	0x00555043
    1714:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1718:	376d7865 	strbcc	r7, [sp, -r5, ror #16]!
    171c:	52415400 	subpl	r5, r1, #0, 8
    1720:	5f544547 	svcpl	0x00544547
    1724:	5f555043 	svcpl	0x00555043
    1728:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    172c:	66303035 			; <UNDEFINED> instruction: 0x66303035
    1730:	41540065 	cmpmi	r4, r5, rrx
    1734:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1738:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    173c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1740:	63303137 	teqvs	r0, #-1073741811	; 0xc000000d
    1744:	6d726100 	ldfvse	f6, [r2, #-0]
    1748:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    174c:	6f635f64 	svcvs	0x00635f64
    1750:	41006564 	tstmi	r0, r4, ror #10
    1754:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1758:	415f5343 	cmpmi	pc, r3, asr #6
    175c:	53435041 	movtpl	r5, #12353	; 0x3041
    1760:	61736900 	cmnvs	r3, r0, lsl #18
    1764:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1768:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    176c:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
    1770:	53414200 	movtpl	r4, #4608	; 0x1200
    1774:	52415f45 	subpl	r5, r1, #276	; 0x114
    1778:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    177c:	4154004d 	cmpmi	r4, sp, asr #32
    1780:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1784:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1788:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    178c:	74303137 	ldrtvc	r3, [r0], #-311	; 0xfffffec9
    1790:	6d726100 	ldfvse	f6, [r2, #-0]
    1794:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1798:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    179c:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    17a0:	73690032 	cmnvc	r9, #50	; 0x32
    17a4:	756e5f61 	strbvc	r5, [lr, #-3937]!	; 0xfffff09f
    17a8:	69625f6d 	stmdbvs	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    17ac:	54007374 	strpl	r7, [r0], #-884	; 0xfffffc8c
    17b0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    17b4:	50435f54 	subpl	r5, r3, r4, asr pc
    17b8:	6f635f55 	svcvs	0x00635f55
    17bc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    17c0:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    17c4:	6d737375 	ldclvs	3, cr7, [r3, #-468]!	; 0xfffffe2c
    17c8:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    17cc:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    17d0:	00796c70 	rsbseq	r6, r9, r0, ror ip
    17d4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    17d8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    17dc:	655f5550 	ldrbvs	r5, [pc, #-1360]	; 1294 <shift+0x1294>
    17e0:	6f6e7978 	svcvs	0x006e7978
    17e4:	00316d73 	eorseq	r6, r1, r3, ror sp
    17e8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    17ec:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    17f0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    17f4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    17f8:	32357278 	eorscc	r7, r5, #120, 4	; 0x80000007
    17fc:	61736900 	cmnvs	r3, r0, lsl #18
    1800:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1804:	6964745f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
    1808:	72700076 	rsbsvc	r0, r0, #118	; 0x76
    180c:	72656665 	rsbvc	r6, r5, #105906176	; 0x6500000
    1810:	6f656e5f 	svcvs	0x00656e5f
    1814:	6f665f6e 	svcvs	0x00665f6e
    1818:	34365f72 	ldrtcc	r5, [r6], #-3954	; 0xfffff08e
    181c:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1820:	61736900 	cmnvs	r3, r0, lsl #18
    1824:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1828:	3170665f 	cmncc	r0, pc, asr r6
    182c:	6c6d6636 	stclvs	6, cr6, [sp], #-216	; 0xffffff28
    1830:	52415400 	subpl	r5, r1, #0, 8
    1834:	5f544547 	svcpl	0x00544547
    1838:	5f555043 	svcpl	0x00555043
    183c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1840:	33617865 	cmncc	r1, #6619136	; 0x650000
    1844:	41540032 	cmpmi	r4, r2, lsr r0
    1848:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    184c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1850:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1854:	00303236 	eorseq	r3, r0, r6, lsr r2
    1858:	5f617369 	svcpl	0x00617369
    185c:	5f746962 	svcpl	0x00746962
    1860:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1864:	766e6f63 	strbtvc	r6, [lr], -r3, ror #30
    1868:	736e7500 	cmnvc	lr, #0, 10
    186c:	76636570 			; <UNDEFINED> instruction: 0x76636570
    1870:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    1874:	73676e69 	cmnvc	r7, #1680	; 0x690
    1878:	52415400 	subpl	r5, r1, #0, 8
    187c:	5f544547 	svcpl	0x00544547
    1880:	5f555043 	svcpl	0x00555043
    1884:	316d7261 	cmncc	sp, r1, ror #4
    1888:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    188c:	54007332 	strpl	r7, [r0], #-818	; 0xfffffcce
    1890:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1894:	50435f54 	subpl	r5, r3, r4, asr pc
    1898:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    189c:	3230316d 	eorscc	r3, r0, #1073741851	; 0x4000001b
    18a0:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    18a4:	6d726100 	ldfvse	f6, [r2, #-0]
    18a8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    18ac:	006d3368 	rsbeq	r3, sp, r8, ror #6
    18b0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    18b4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    18b8:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    18bc:	36303661 	ldrtcc	r3, [r0], -r1, ror #12
    18c0:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    18c4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    18c8:	50435f54 	subpl	r5, r3, r4, asr pc
    18cc:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    18d0:	3632396d 	ldrtcc	r3, [r2], -sp, ror #18
    18d4:	00736a65 	rsbseq	r6, r3, r5, ror #20
    18d8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    18dc:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    18e0:	54345f48 	ldrtpl	r5, [r4], #-3912	; 0xfffff0b8
    18e4:	61736900 	cmnvs	r3, r0, lsl #18
    18e8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    18ec:	7972635f 	ldmdbvc	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
    18f0:	006f7470 	rsbeq	r7, pc, r0, ror r4	; <UNPREDICTABLE>
    18f4:	5f6d7261 	svcpl	0x006d7261
    18f8:	73676572 	cmnvc	r7, #478150656	; 0x1c800000
    18fc:	5f6e695f 	svcpl	0x006e695f
    1900:	75716573 	ldrbvc	r6, [r1, #-1395]!	; 0xfffffa8d
    1904:	65636e65 	strbvs	r6, [r3, #-3685]!	; 0xfffff19b
    1908:	53414200 	movtpl	r4, #4608	; 0x1200
    190c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1910:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 10d5 <shift+0x10d5>
    1914:	54004554 	strpl	r4, [r0], #-1364	; 0xfffffaac
    1918:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    191c:	50435f54 	subpl	r5, r3, r4, asr pc
    1920:	70655f55 	rsbvc	r5, r5, r5, asr pc
    1924:	32313339 	eorscc	r3, r1, #-469762048	; 0xe4000000
    1928:	61736900 	cmnvs	r3, r0, lsl #18
    192c:	6165665f 	cmnvs	r5, pc, asr r6
    1930:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    1934:	61736900 	cmnvs	r3, r0, lsl #18
    1938:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    193c:	616d735f 	cmnvs	sp, pc, asr r3
    1940:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    1944:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    1948:	616c5f6d 	cmnvs	ip, sp, ror #30
    194c:	6f5f676e 	svcvs	0x005f676e
    1950:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
    1954:	626f5f74 	rsbvs	r5, pc, #116, 30	; 0x1d0
    1958:	7463656a 	strbtvc	r6, [r3], #-1386	; 0xfffffa96
    195c:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    1960:	75626972 	strbvc	r6, [r2, #-2418]!	; 0xfffff68e
    1964:	5f736574 	svcpl	0x00736574
    1968:	6b6f6f68 	blvs	1bdd710 <__bss_end+0x1bd48e4>
    196c:	61736900 	cmnvs	r3, r0, lsl #18
    1970:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1974:	5f70665f 	svcpl	0x0070665f
    1978:	00323364 	eorseq	r3, r2, r4, ror #6
    197c:	5f4d5241 	svcpl	0x004d5241
    1980:	6900454e 	stmdbvs	r0, {r1, r2, r3, r6, r8, sl, lr}
    1984:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1988:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
    198c:	54003865 	strpl	r3, [r0], #-2149	; 0xfffff79b
    1990:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1994:	50435f54 	subpl	r5, r3, r4, asr pc
    1998:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    199c:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    19a0:	737a6a36 	cmnvc	sl, #221184	; 0x36000
    19a4:	53414200 	movtpl	r4, #4608	; 0x1200
    19a8:	52415f45 	subpl	r5, r1, #276	; 0x114
    19ac:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 1171 <shift+0x1171>
    19b0:	73690045 	cmnvc	r9, #69	; 0x45
    19b4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    19b8:	64615f74 	strbtvs	r5, [r1], #-3956	; 0xfffff08c
    19bc:	70007669 	andvc	r7, r0, r9, ror #12
    19c0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    19c4:	726f7373 	rsbvc	r7, pc, #-872415231	; 0xcc000001
    19c8:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    19cc:	6c610065 	stclvs	0, cr0, [r1], #-404	; 0xfffffe6c
    19d0:	70665f6c 	rsbvc	r5, r6, ip, ror #30
    19d4:	61007375 	tstvs	r0, r5, ror r3
    19d8:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    19dc:	42007363 	andmi	r7, r0, #-1946157055	; 0x8c000001
    19e0:	5f455341 	svcpl	0x00455341
    19e4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    19e8:	0054355f 	subseq	r3, r4, pc, asr r5
    19ec:	5f6d7261 	svcpl	0x006d7261
    19f0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    19f4:	54007434 	strpl	r7, [r0], #-1076	; 0xfffffbcc
    19f8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    19fc:	50435f54 	subpl	r5, r3, r4, asr pc
    1a00:	6f635f55 	svcvs	0x00635f55
    1a04:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1a08:	63353161 	teqvs	r5, #1073741848	; 0x40000018
    1a0c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1a10:	00376178 	eorseq	r6, r7, r8, ror r1
    1a14:	5f6d7261 	svcpl	0x006d7261
    1a18:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    1a1c:	7562775f 	strbvc	r7, [r2, #-1887]!	; 0xfffff8a1
    1a20:	74680066 	strbtvc	r0, [r8], #-102	; 0xffffff9a
    1a24:	685f6261 	ldmdavs	pc, {r0, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    1a28:	00687361 	rsbeq	r7, r8, r1, ror #6
    1a2c:	5f617369 	svcpl	0x00617369
    1a30:	5f746962 	svcpl	0x00746962
    1a34:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    1a38:	6f6e5f6b 	svcvs	0x006e5f6b
    1a3c:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 18c8 <shift+0x18c8>
    1a40:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    1a44:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    1a48:	52415400 	subpl	r5, r1, #0, 8
    1a4c:	5f544547 	svcpl	0x00544547
    1a50:	5f555043 	svcpl	0x00555043
    1a54:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1a58:	306d7865 	rsbcc	r7, sp, r5, ror #16
    1a5c:	52415400 	subpl	r5, r1, #0, 8
    1a60:	5f544547 	svcpl	0x00544547
    1a64:	5f555043 	svcpl	0x00555043
    1a68:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1a6c:	316d7865 	cmncc	sp, r5, ror #16
    1a70:	52415400 	subpl	r5, r1, #0, 8
    1a74:	5f544547 	svcpl	0x00544547
    1a78:	5f555043 	svcpl	0x00555043
    1a7c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1a80:	336d7865 	cmncc	sp, #6619136	; 0x650000
    1a84:	61736900 	cmnvs	r3, r0, lsl #18
    1a88:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1a8c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1a90:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    1a94:	6d726100 	ldfvse	f6, [r2, #-0]
    1a98:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1a9c:	616e5f68 	cmnvs	lr, r8, ror #30
    1aa0:	6900656d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, sl, sp, lr}
    1aa4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1aa8:	615f7469 	cmpvs	pc, r9, ror #8
    1aac:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1ab0:	6900335f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp}
    1ab4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ab8:	615f7469 	cmpvs	pc, r9, ror #8
    1abc:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1ac0:	5400345f 	strpl	r3, [r0], #-1119	; 0xfffffba1
    1ac4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ac8:	50435f54 	subpl	r5, r3, r4, asr pc
    1acc:	6f635f55 	svcvs	0x00635f55
    1ad0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ad4:	00333561 	eorseq	r3, r3, r1, ror #10
    1ad8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1adc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ae0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1ae4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1ae8:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    1aec:	52415400 	subpl	r5, r1, #0, 8
    1af0:	5f544547 	svcpl	0x00544547
    1af4:	5f555043 	svcpl	0x00555043
    1af8:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1afc:	00696d64 	rsbeq	r6, r9, r4, ror #26
    1b00:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b04:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b08:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 19d0 <shift+0x19d0>
    1b0c:	726f6370 	rsbvc	r6, pc, #112, 6	; 0xc0000001
    1b10:	73690065 	cmnvc	r9, #101	; 0x65
    1b14:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1b18:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1b1c:	6d33766d 	ldcvs	6, cr7, [r3, #-436]!	; 0xfffffe4c
    1b20:	6d726100 	ldfvse	f6, [r2, #-0]
    1b24:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1b28:	6f6e5f68 	svcvs	0x006e5f68
    1b2c:	61006d74 	tstvs	r0, r4, ror sp
    1b30:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1b34:	35686372 	strbcc	r6, [r8, #-882]!	; 0xfffffc8e
    1b38:	41540065 	cmpmi	r4, r5, rrx
    1b3c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b40:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b44:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1b48:	30323031 	eorscc	r3, r2, r1, lsr r0
    1b4c:	41420065 	cmpmi	r2, r5, rrx
    1b50:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1b54:	5f484352 	svcpl	0x00484352
    1b58:	54004a36 	strpl	r4, [r0], #-2614	; 0xfffff5ca
    1b5c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b60:	50435f54 	subpl	r5, r3, r4, asr pc
    1b64:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1b68:	3836396d 	ldmdacc	r6!, {r0, r2, r3, r5, r6, r8, fp, ip, sp}
    1b6c:	54007365 	strpl	r7, [r0], #-869	; 0xfffffc9b
    1b70:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b74:	50435f54 	subpl	r5, r3, r4, asr pc
    1b78:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1b7c:	3034376d 	eorscc	r3, r4, sp, ror #14
    1b80:	41420074 	hvcmi	8196	; 0x2004
    1b84:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1b88:	5f484352 	svcpl	0x00484352
    1b8c:	69004d36 	stmdbvs	r0, {r1, r2, r4, r5, r8, sl, fp, lr}
    1b90:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1b94:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1b98:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1b9c:	41540074 	cmpmi	r4, r4, ror r0
    1ba0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ba4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ba8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1bac:	00303037 	eorseq	r3, r0, r7, lsr r0
    1bb0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1bb4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1bb8:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1bbc:	31316d72 	teqcc	r1, r2, ror sp
    1bc0:	666a3633 			; <UNDEFINED> instruction: 0x666a3633
    1bc4:	52410073 	subpl	r0, r1, #115	; 0x73
    1bc8:	534c5f4d 	movtpl	r5, #53069	; 0xcf4d
    1bcc:	52415400 	subpl	r5, r1, #0, 8
    1bd0:	5f544547 	svcpl	0x00544547
    1bd4:	5f555043 	svcpl	0x00555043
    1bd8:	316d7261 	cmncc	sp, r1, ror #4
    1bdc:	74303230 	ldrtvc	r3, [r0], #-560	; 0xfffffdd0
    1be0:	53414200 	movtpl	r4, #4608	; 0x1200
    1be4:	52415f45 	subpl	r5, r1, #276	; 0x114
    1be8:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1bec:	4154005a 	cmpmi	r4, sl, asr r0
    1bf0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1bf4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1bf8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1bfc:	61786574 	cmnvs	r8, r4, ror r5
    1c00:	6f633537 	svcvs	0x00633537
    1c04:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1c08:	00353561 	eorseq	r3, r5, r1, ror #10
    1c0c:	5f4d5241 	svcpl	0x004d5241
    1c10:	5f534350 	svcpl	0x00534350
    1c14:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    1c18:	46565f53 	usaxmi	r5, r6, r3
    1c1c:	41540050 	cmpmi	r4, r0, asr r0
    1c20:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c24:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c28:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1c2c:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    1c30:	61736900 	cmnvs	r3, r0, lsl #18
    1c34:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1c38:	6f656e5f 	svcvs	0x00656e5f
    1c3c:	7261006e 	rsbvc	r0, r1, #110	; 0x6e
    1c40:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    1c44:	74615f75 	strbtvc	r5, [r1], #-3957	; 0xfffff08b
    1c48:	69007274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp, lr}
    1c4c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1c50:	615f7469 	cmpvs	pc, r9, ror #8
    1c54:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    1c58:	54006d65 	strpl	r6, [r0], #-3429	; 0xfffff29b
    1c5c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c60:	50435f54 	subpl	r5, r3, r4, asr pc
    1c64:	61665f55 	cmnvs	r6, r5, asr pc
    1c68:	74363236 	ldrtvc	r3, [r6], #-566	; 0xfffffdca
    1c6c:	41540065 	cmpmi	r4, r5, rrx
    1c70:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c74:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c78:	72616d5f 	rsbvc	r6, r1, #6080	; 0x17c0
    1c7c:	6c6c6576 	cfstr64vs	mvdx6, [ip], #-472	; 0xfffffe28
    1c80:	346a705f 	strbtcc	r7, [sl], #-95	; 0xffffffa1
    1c84:	61746800 	cmnvs	r4, r0, lsl #16
    1c88:	61685f62 	cmnvs	r8, r2, ror #30
    1c8c:	705f6873 	subsvc	r6, pc, r3, ror r8	; <UNPREDICTABLE>
    1c90:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    1c94:	54007265 	strpl	r7, [r0], #-613	; 0xfffffd9b
    1c98:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c9c:	50435f54 	subpl	r5, r3, r4, asr pc
    1ca0:	6f635f55 	svcvs	0x00635f55
    1ca4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ca8:	00353361 	eorseq	r3, r5, r1, ror #6
    1cac:	5f6d7261 	svcpl	0x006d7261
    1cb0:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    1cb4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1cb8:	5f786574 	svcpl	0x00786574
    1cbc:	69003961 	stmdbvs	r0, {r0, r5, r6, r8, fp, ip, sp}
    1cc0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1cc4:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1cc8:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1ccc:	54003274 	strpl	r3, [r0], #-628	; 0xfffffd8c
    1cd0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1cd4:	50435f54 	subpl	r5, r3, r4, asr pc
    1cd8:	6f635f55 	svcvs	0x00635f55
    1cdc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ce0:	63323761 	teqvs	r2, #25427968	; 0x1840000
    1ce4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1ce8:	33356178 	teqcc	r5, #120, 2
    1cec:	61736900 	cmnvs	r3, r0, lsl #18
    1cf0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1cf4:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    1cf8:	0032626d 	eorseq	r6, r2, sp, ror #4
    1cfc:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1d00:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1d04:	41375f48 	teqmi	r7, r8, asr #30
    1d08:	61736900 	cmnvs	r3, r0, lsl #18
    1d0c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1d10:	746f645f 	strbtvc	r6, [pc], #-1119	; 1d18 <shift+0x1d18>
    1d14:	646f7270 	strbtvs	r7, [pc], #-624	; 1d1c <shift+0x1d1c>
    1d18:	53414200 	movtpl	r4, #4608	; 0x1200
    1d1c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1d20:	305f4843 	subscc	r4, pc, r3, asr #16
    1d24:	6d726100 	ldfvse	f6, [r2, #-0]
    1d28:	3170665f 	cmncc	r0, pc, asr r6
    1d2c:	79745f36 	ldmdbvc	r4!, {r1, r2, r4, r5, r8, r9, sl, fp, ip, lr}^
    1d30:	6e5f6570 	mrcvs	5, 2, r6, cr15, cr0, {3}
    1d34:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1d38:	5f4d5241 	svcpl	0x004d5241
    1d3c:	6100494d 	tstvs	r0, sp, asr #18
    1d40:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1d44:	36686372 			; <UNDEFINED> instruction: 0x36686372
    1d48:	7261006b 	rsbvc	r0, r1, #107	; 0x6b
    1d4c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1d50:	6d366863 	ldcvs	8, cr6, [r6, #-396]!	; 0xfffffe74
    1d54:	53414200 	movtpl	r4, #4608	; 0x1200
    1d58:	52415f45 	subpl	r5, r1, #276	; 0x114
    1d5c:	345f4843 	ldrbcc	r4, [pc], #-2115	; 1d64 <shift+0x1d64>
    1d60:	53414200 	movtpl	r4, #4608	; 0x1200
    1d64:	52415f45 	subpl	r5, r1, #276	; 0x114
    1d68:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    1d6c:	5f5f0052 	svcpl	0x005f0052
    1d70:	63706f70 	cmnvs	r0, #112, 30	; 0x1c0
    1d74:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1d78:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    1d7c:	61736900 	cmnvs	r3, r0, lsl #18
    1d80:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1d84:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    1d88:	41540065 	cmpmi	r4, r5, rrx
    1d8c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d90:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d94:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1d98:	61786574 	cmnvs	r8, r4, ror r5
    1d9c:	54003337 	strpl	r3, [r0], #-823	; 0xfffffcc9
    1da0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1da4:	50435f54 	subpl	r5, r3, r4, asr pc
    1da8:	65675f55 	strbvs	r5, [r7, #-3925]!	; 0xfffff0ab
    1dac:	6972656e 	ldmdbvs	r2!, {r1, r2, r3, r5, r6, r8, sl, sp, lr}^
    1db0:	61377663 	teqvs	r7, r3, ror #12
    1db4:	61736900 	cmnvs	r3, r0, lsl #18
    1db8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1dbc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1dc0:	00653576 	rsbeq	r3, r5, r6, ror r5
    1dc4:	5f6d7261 	svcpl	0x006d7261
    1dc8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1dcc:	5f6f6e5f 	svcpl	0x006f6e5f
    1dd0:	616c6f76 	smcvs	50934	; 0xc6f6
    1dd4:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    1dd8:	0065635f 	rsbeq	r6, r5, pc, asr r3
    1ddc:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1de0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1de4:	41385f48 	teqmi	r8, r8, asr #30
    1de8:	52415400 	subpl	r5, r1, #0, 8
    1dec:	5f544547 	svcpl	0x00544547
    1df0:	5f555043 	svcpl	0x00555043
    1df4:	316d7261 	cmncc	sp, r1, ror #4
    1df8:	65323230 	ldrvs	r3, [r2, #-560]!	; 0xfffffdd0
    1dfc:	53414200 	movtpl	r4, #4608	; 0x1200
    1e00:	52415f45 	subpl	r5, r1, #276	; 0x114
    1e04:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    1e08:	41540052 	cmpmi	r4, r2, asr r0
    1e0c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e10:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e14:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1e18:	61786574 	cmnvs	r8, r4, ror r5
    1e1c:	6f633337 	svcvs	0x00633337
    1e20:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1e24:	00353361 	eorseq	r3, r5, r1, ror #6
    1e28:	5f4d5241 	svcpl	0x004d5241
    1e2c:	6100564e 	tstvs	r0, lr, asr #12
    1e30:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1e34:	34686372 	strbtcc	r6, [r8], #-882	; 0xfffffc8e
    1e38:	6d726100 	ldfvse	f6, [r2, #-0]
    1e3c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1e40:	61003568 	tstvs	r0, r8, ror #10
    1e44:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1e48:	37686372 			; <UNDEFINED> instruction: 0x37686372
    1e4c:	6d726100 	ldfvse	f6, [r2, #-0]
    1e50:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1e54:	6c003868 	stcvs	8, cr3, [r0], {104}	; 0x68
    1e58:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    1e5c:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    1e60:	4200656c 	andmi	r6, r0, #108, 10	; 0x1b000000
    1e64:	5f455341 	svcpl	0x00455341
    1e68:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1e6c:	004b365f 	subeq	r3, fp, pc, asr r6
    1e70:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1e74:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1e78:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1e7c:	34396d72 	ldrtcc	r6, [r9], #-3442	; 0xfffff28e
    1e80:	61007430 	tstvs	r0, r0, lsr r4
    1e84:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1e88:	36686372 			; <UNDEFINED> instruction: 0x36686372
    1e8c:	6d726100 	ldfvse	f6, [r2, #-0]
    1e90:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    1e94:	73785f65 	cmnvc	r8, #404	; 0x194
    1e98:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1e9c:	52415400 	subpl	r5, r1, #0, 8
    1ea0:	5f544547 	svcpl	0x00544547
    1ea4:	5f555043 	svcpl	0x00555043
    1ea8:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1eac:	00303035 	eorseq	r3, r0, r5, lsr r0
    1eb0:	696b616d 	stmdbvs	fp!, {r0, r2, r3, r5, r6, r8, sp, lr}^
    1eb4:	635f676e 	cmpvs	pc, #28835840	; 0x1b80000
    1eb8:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
    1ebc:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    1ec0:	7400656c 	strvc	r6, [r0], #-1388	; 0xfffffa94
    1ec4:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    1ec8:	6c61635f 	stclvs	3, cr6, [r1], #-380	; 0xfffffe84
    1ecc:	69765f6c 	ldmdbvs	r6!, {r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ed0:	616c5f61 	cmnvs	ip, r1, ror #30
    1ed4:	006c6562 	rsbeq	r6, ip, r2, ror #10
    1ed8:	5f617369 	svcpl	0x00617369
    1edc:	5f746962 	svcpl	0x00746962
    1ee0:	35767066 	ldrbcc	r7, [r6, #-102]!	; 0xffffff9a
    1ee4:	52415400 	subpl	r5, r1, #0, 8
    1ee8:	5f544547 	svcpl	0x00544547
    1eec:	5f555043 	svcpl	0x00555043
    1ef0:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1ef4:	69003031 	stmdbvs	r0, {r0, r4, r5, ip, sp}
    1ef8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1efc:	615f7469 	cmpvs	pc, r9, ror #8
    1f00:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1f04:	4154006b 	cmpmi	r4, fp, rrx
    1f08:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f0c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f10:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1f14:	61786574 	cmnvs	r8, r4, ror r5
    1f18:	41540037 	cmpmi	r4, r7, lsr r0
    1f1c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f20:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f24:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1f28:	61786574 	cmnvs	r8, r4, ror r5
    1f2c:	41540038 	cmpmi	r4, r8, lsr r0
    1f30:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f34:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f38:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1f3c:	61786574 	cmnvs	r8, r4, ror r5
    1f40:	52410039 	subpl	r0, r1, #57	; 0x39
    1f44:	43505f4d 	cmpmi	r0, #308	; 0x134
    1f48:	50415f53 	subpl	r5, r1, r3, asr pc
    1f4c:	41005343 	tstmi	r0, r3, asr #6
    1f50:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1f54:	415f5343 	cmpmi	pc, r3, asr #6
    1f58:	53435054 	movtpl	r5, #12372	; 0x3054
    1f5c:	52415400 	subpl	r5, r1, #0, 8
    1f60:	5f544547 	svcpl	0x00544547
    1f64:	5f555043 	svcpl	0x00555043
    1f68:	366d7261 	strbtcc	r7, [sp], -r1, ror #4
    1f6c:	54003030 	strpl	r3, [r0], #-48	; 0xffffffd0
    1f70:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f74:	50435f54 	subpl	r5, r3, r4, asr pc
    1f78:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1f7c:	3032376d 	eorscc	r3, r2, sp, ror #14
    1f80:	41540074 	cmpmi	r4, r4, ror r0
    1f84:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f88:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f8c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1f90:	61786574 	cmnvs	r8, r4, ror r5
    1f94:	63003735 	movwvs	r3, #1845	; 0x735
    1f98:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    1f9c:	64207865 	strtvs	r7, [r0], #-2149	; 0xfffff79b
    1fa0:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    1fa4:	41540065 	cmpmi	r4, r5, rrx
    1fa8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1fac:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1fb0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1fb4:	61786574 	cmnvs	r8, r4, ror r5
    1fb8:	6f633337 	svcvs	0x00633337
    1fbc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1fc0:	00333561 	eorseq	r3, r3, r1, ror #10
    1fc4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1fc8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1fcc:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1fd0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1fd4:	70306d78 	eorsvc	r6, r0, r8, ror sp
    1fd8:	0073756c 	rsbseq	r7, r3, ip, ror #10
    1fdc:	5f6d7261 	svcpl	0x006d7261
    1fe0:	69006363 	stmdbvs	r0, {r0, r1, r5, r6, r8, r9, sp, lr}
    1fe4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1fe8:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 1e4c <shift+0x1e4c>
    1fec:	3265646f 	rsbcc	r6, r5, #1862270976	; 0x6f000000
    1ff0:	73690036 	cmnvc	r9, #54	; 0x36
    1ff4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ff8:	73785f74 	cmnvc	r8, #116, 30	; 0x1d0
    1ffc:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    2000:	52415400 	subpl	r5, r1, #0, 8
    2004:	5f544547 	svcpl	0x00544547
    2008:	5f555043 	svcpl	0x00555043
    200c:	6f727473 	svcvs	0x00727473
    2010:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    2014:	3031316d 	eorscc	r3, r1, sp, ror #2
    2018:	41540030 	cmpmi	r4, r0, lsr r0
    201c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2020:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2024:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2028:	6d647437 	cfstrdvs	mvd7, [r4, #-220]!	; 0xffffff24
    202c:	5f007369 	svcpl	0x00007369
    2030:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    2034:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    2038:	6572745f 	ldrbvs	r7, [r2, #-1119]!	; 0xfffffba1
    203c:	65685f65 	strbvs	r5, [r8, #-3941]!	; 0xfffff09b
    2040:	005f6572 	subseq	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    2044:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2048:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    204c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2050:	30316d72 	eorscc	r6, r1, r2, ror sp
    2054:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    2058:	52415400 	subpl	r5, r1, #0, 8
    205c:	5f544547 	svcpl	0x00544547
    2060:	5f555043 	svcpl	0x00555043
    2064:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2068:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    206c:	73616200 	cmnvc	r1, #0, 4
    2070:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    2074:	74696863 	strbtvc	r6, [r9], #-2147	; 0xfffff79d
    2078:	75746365 	ldrbvc	r6, [r4, #-869]!	; 0xfffffc9b
    207c:	61006572 	tstvs	r0, r2, ror r5
    2080:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2084:	5f686372 	svcpl	0x00686372
    2088:	00637263 	rsbeq	r7, r3, r3, ror #4
    208c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2090:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2094:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2098:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    209c:	73316d78 	teqvc	r1, #120, 26	; 0x1e00
    20a0:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    20a4:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    20a8:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    20ac:	6d726100 	ldfvse	f6, [r2, #-0]
    20b0:	7275635f 	rsbsvc	r6, r5, #2080374785	; 0x7c000001
    20b4:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    20b8:	0063635f 	rsbeq	r6, r3, pc, asr r3
    20bc:	5f6d7261 	svcpl	0x006d7261
    20c0:	67726174 			; <UNDEFINED> instruction: 0x67726174
    20c4:	695f7465 	ldmdbvs	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    20c8:	006e736e 	rsbeq	r7, lr, lr, ror #6
    20cc:	5f617369 	svcpl	0x00617369
    20d0:	5f746962 	svcpl	0x00746962
    20d4:	33637263 	cmncc	r3, #805306374	; 0x30000006
    20d8:	52410032 	subpl	r0, r1, #50	; 0x32
    20dc:	4c505f4d 	mrrcmi	15, 4, r5, r0, cr13
    20e0:	61736900 	cmnvs	r3, r0, lsl #18
    20e4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    20e8:	7066765f 	rsbvc	r7, r6, pc, asr r6
    20ec:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
    20f0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    20f4:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    20f8:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
    20fc:	53414200 	movtpl	r4, #4608	; 0x1200
    2100:	52415f45 	subpl	r5, r1, #276	; 0x114
    2104:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    2108:	42003254 	andmi	r3, r0, #84, 4	; 0x40000005
    210c:	5f455341 	svcpl	0x00455341
    2110:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2114:	5f4d385f 	svcpl	0x004d385f
    2118:	4e49414d 	dvfmiem	f4, f1, #5.0
    211c:	52415400 	subpl	r5, r1, #0, 8
    2120:	5f544547 	svcpl	0x00544547
    2124:	5f555043 	svcpl	0x00555043
    2128:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    212c:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    2130:	4d524100 	ldfmie	f4, [r2, #-0]
    2134:	004c415f 	subeq	r4, ip, pc, asr r1
    2138:	5f617369 	svcpl	0x00617369
    213c:	5f746962 	svcpl	0x00746962
    2140:	65646f6d 	strbvs	r6, [r4, #-3949]!	; 0xfffff093
    2144:	42003233 	andmi	r3, r0, #805306371	; 0x30000003
    2148:	5f455341 	svcpl	0x00455341
    214c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2150:	004d375f 	subeq	r3, sp, pc, asr r7
    2154:	5f6d7261 	svcpl	0x006d7261
    2158:	67726174 			; <UNDEFINED> instruction: 0x67726174
    215c:	6c5f7465 	cfldrdvs	mvd7, [pc], {101}	; 0x65
    2160:	6c656261 	sfmvs	f6, 2, [r5], #-388	; 0xfffffe7c
    2164:	52415400 	subpl	r5, r1, #0, 8
    2168:	5f544547 	svcpl	0x00544547
    216c:	5f555043 	svcpl	0x00555043
    2170:	6f727473 	svcvs	0x00727473
    2174:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    2178:	3131316d 	teqcc	r1, sp, ror #2
    217c:	41540030 	cmpmi	r4, r0, lsr r0
    2180:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2184:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2188:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    218c:	00303237 	eorseq	r3, r0, r7, lsr r2
    2190:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2194:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2198:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    219c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    21a0:	00347278 	eorseq	r7, r4, r8, ror r2
    21a4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    21a8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    21ac:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    21b0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    21b4:	00357278 	eorseq	r7, r5, r8, ror r2
    21b8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    21bc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    21c0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    21c4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    21c8:	00377278 	eorseq	r7, r7, r8, ror r2
    21cc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    21d0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    21d4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    21d8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    21dc:	00387278 	eorseq	r7, r8, r8, ror r2
    21e0:	5f617369 	svcpl	0x00617369
    21e4:	5f746962 	svcpl	0x00746962
    21e8:	6561706c 	strbvs	r7, [r1, #-108]!	; 0xffffff94
    21ec:	52415400 	subpl	r5, r1, #0, 8
    21f0:	5f544547 	svcpl	0x00544547
    21f4:	5f555043 	svcpl	0x00555043
    21f8:	6f727473 	svcvs	0x00727473
    21fc:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    2200:	3031316d 	eorscc	r3, r1, sp, ror #2
    2204:	61736900 	cmnvs	r3, r0, lsl #18
    2208:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    220c:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    2210:	615f6b72 	cmpvs	pc, r2, ror fp	; <UNPREDICTABLE>
    2214:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    2218:	69007a6b 	stmdbvs	r0, {r0, r1, r3, r5, r6, r9, fp, ip, sp, lr}
    221c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2220:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    2224:	006d746f 	rsbeq	r7, sp, pc, ror #8
    2228:	5f617369 	svcpl	0x00617369
    222c:	5f746962 	svcpl	0x00746962
    2230:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2234:	73690034 	cmnvc	r9, #52	; 0x34
    2238:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    223c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2240:	0035766d 	eorseq	r7, r5, sp, ror #12
    2244:	5f617369 	svcpl	0x00617369
    2248:	5f746962 	svcpl	0x00746962
    224c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2250:	73690036 	cmnvc	r9, #54	; 0x36
    2254:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2258:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    225c:	0037766d 	eorseq	r7, r7, sp, ror #12
    2260:	5f617369 	svcpl	0x00617369
    2264:	5f746962 	svcpl	0x00746962
    2268:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    226c:	645f0038 	ldrbvs	r0, [pc], #-56	; 2274 <shift+0x2274>
    2270:	5f746e6f 	svcpl	0x00746e6f
    2274:	5f657375 	svcpl	0x00657375
    2278:	5f787472 	svcpl	0x00787472
    227c:	65726568 	ldrbvs	r6, [r2, #-1384]!	; 0xfffffa98
    2280:	5155005f 	cmppl	r5, pc, asr r0
    2284:	70797449 	rsbsvc	r7, r9, r9, asr #8
    2288:	72610065 	rsbvc	r0, r1, #101	; 0x65
    228c:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    2290:	6100656e 	tstvs	r0, lr, ror #10
    2294:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    2298:	695f7070 	ldmdbvs	pc, {r4, r5, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    229c:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    22a0:	6b726f77 	blvs	1c9e084 <__bss_end+0x1c95258>
    22a4:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
    22a8:	74705f63 	ldrbtvc	r5, [r0], #-3939	; 0xfffff09d
    22ac:	41540072 	cmpmi	r4, r2, ror r0
    22b0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    22b4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    22b8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    22bc:	74303239 	ldrtvc	r3, [r0], #-569	; 0xfffffdc7
    22c0:	61746800 	cmnvs	r4, r0, lsl #16
    22c4:	71655f62 	cmnvc	r5, r2, ror #30
    22c8:	52415400 	subpl	r5, r1, #0, 8
    22cc:	5f544547 	svcpl	0x00544547
    22d0:	5f555043 	svcpl	0x00555043
    22d4:	32356166 	eorscc	r6, r5, #-2147483623	; 0x80000019
    22d8:	72610036 	rsbvc	r0, r1, #54	; 0x36
    22dc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    22e0:	745f6863 	ldrbvc	r6, [pc], #-2147	; 22e8 <shift+0x22e8>
    22e4:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    22e8:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
    22ec:	68007669 	stmdavs	r0, {r0, r3, r5, r6, r9, sl, ip, sp, lr}
    22f0:	5f626174 	svcpl	0x00626174
    22f4:	705f7165 	subsvc	r7, pc, r5, ror #2
    22f8:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    22fc:	54007265 	strpl	r7, [r0], #-613	; 0xfffffd9b
    2300:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2304:	50435f54 	subpl	r5, r3, r4, asr pc
    2308:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    230c:	0030366d 	eorseq	r3, r0, sp, ror #12
    2310:	20554e47 	subscs	r4, r5, r7, asr #28
    2314:	20373143 	eorscs	r3, r7, r3, asr #2
    2318:	2e332e38 	mrccs	14, 1, r2, cr3, cr8, {1}
    231c:	30322031 	eorscc	r2, r2, r1, lsr r0
    2320:	37303931 			; <UNDEFINED> instruction: 0x37303931
    2324:	28203330 	stmdacs	r0!, {r4, r5, r8, r9, ip, sp}
    2328:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    232c:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    2330:	63675b20 	cmnvs	r7, #32, 22	; 0x8000
    2334:	2d382d63 	ldccs	13, cr2, [r8, #-396]!	; 0xfffffe74
    2338:	6e617262 	cdpvs	2, 6, cr7, cr1, cr2, {3}
    233c:	72206863 	eorvc	r6, r0, #6488064	; 0x630000
    2340:	73697665 	cmnvc	r9, #105906176	; 0x6500000
    2344:	206e6f69 	rsbcs	r6, lr, r9, ror #30
    2348:	30333732 	eorscc	r3, r3, r2, lsr r7
    234c:	205d3732 	subscs	r3, sp, r2, lsr r7
    2350:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    2354:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
    2358:	616f6c66 	cmnvs	pc, r6, ror #24
    235c:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    2360:	61683d69 	cmnvs	r8, r9, ror #26
    2364:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    2368:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
    236c:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
    2370:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    2374:	70662b65 	rsbvc	r2, r6, r5, ror #22
    2378:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    237c:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    2380:	4f2d2067 	svcmi	0x002d2067
    2384:	4f2d2032 	svcmi	0x002d2032
    2388:	4f2d2032 	svcmi	0x002d2032
    238c:	662d2032 			; <UNDEFINED> instruction: 0x662d2032
    2390:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    2394:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
    2398:	62696c2d 	rsbvs	r6, r9, #11520	; 0x2d00
    239c:	20636367 	rsbcs	r6, r3, r7, ror #6
    23a0:	6f6e662d 	svcvs	0x006e662d
    23a4:	6174732d 	cmnvs	r4, sp, lsr #6
    23a8:	702d6b63 	eorvc	r6, sp, r3, ror #22
    23ac:	65746f72 	ldrbvs	r6, [r4, #-3954]!	; 0xfffff08e
    23b0:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    23b4:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    23b8:	6e692d6f 	cdpvs	13, 6, cr2, cr9, cr15, {3}
    23bc:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    23c0:	76662d20 	strbtvc	r2, [r6], -r0, lsr #26
    23c4:	62697369 	rsbvs	r7, r9, #-1543503871	; 0xa4000001
    23c8:	74696c69 	strbtvc	r6, [r9], #-3177	; 0xfffff397
    23cc:	69683d79 	stmdbvs	r8!, {r0, r3, r4, r5, r6, r8, sl, fp, ip, sp}^
    23d0:	6e656464 	cdpvs	4, 6, cr6, cr5, cr4, {3}
    23d4:	6d726100 	ldfvse	f6, [r2, #-0]
    23d8:	6369705f 	cmnvs	r9, #95	; 0x5f
    23dc:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    23e0:	65747369 	ldrbvs	r7, [r4, #-873]!	; 0xfffffc97
    23e4:	41540072 	cmpmi	r4, r2, ror r0
    23e8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    23ec:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    23f0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    23f4:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    23f8:	616d7330 	cmnvs	sp, r0, lsr r3
    23fc:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    2400:	7069746c 	rsbvc	r7, r9, ip, ror #8
    2404:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    2408:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    240c:	50435f54 	subpl	r5, r3, r4, asr pc
    2410:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2414:	3636396d 	ldrtcc	r3, [r6], -sp, ror #18
    2418:	54007365 	strpl	r7, [r0], #-869	; 0xfffffc9b
    241c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2420:	50435f54 	subpl	r5, r3, r4, asr pc
    2424:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    2428:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    242c:	66766f6e 	ldrbtvs	r6, [r6], -lr, ror #30
    2430:	73690070 	cmnvc	r9, #112	; 0x70
    2434:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2438:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    243c:	5f6b7269 	svcpl	0x006b7269
    2440:	5f336d63 	svcpl	0x00336d63
    2444:	6472646c 	ldrbtvs	r6, [r2], #-1132	; 0xfffffb94
    2448:	52415400 	subpl	r5, r1, #0, 8
    244c:	5f544547 	svcpl	0x00544547
    2450:	5f555043 	svcpl	0x00555043
    2454:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    2458:	00693030 	rsbeq	r3, r9, r0, lsr r0
    245c:	5f4d5241 	svcpl	0x004d5241
    2460:	61004343 	tstvs	r0, r3, asr #6
    2464:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2468:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    246c:	5400325f 	strpl	r3, [r0], #-607	; 0xfffffda1
    2470:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2474:	50435f54 	subpl	r5, r3, r4, asr pc
    2478:	6d665f55 	stclvs	15, cr5, [r6, #-340]!	; 0xfffffeac
    247c:	36323670 			; <UNDEFINED> instruction: 0x36323670
    2480:	4d524100 	ldfmie	f4, [r2, #-0]
    2484:	0053435f 	subseq	r4, r3, pc, asr r3
    2488:	5f6d7261 	svcpl	0x006d7261
    248c:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    2490:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    2494:	72610074 	rsbvc	r0, r1, #116	; 0x74
    2498:	61625f6d 	cmnvs	r2, sp, ror #30
    249c:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    24a0:	00686372 	rsbeq	r6, r8, r2, ror r3
    24a4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    24a8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    24ac:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    24b0:	6d376d72 	ldcvs	13, cr6, [r7, #-456]!	; 0xfffffe38
    24b4:	52415400 	subpl	r5, r1, #0, 8
    24b8:	5f544547 	svcpl	0x00544547
    24bc:	5f555043 	svcpl	0x00555043
    24c0:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    24c4:	41540030 	cmpmi	r4, r0, lsr r0
    24c8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    24cc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    24d0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    24d4:	00303532 	eorseq	r3, r0, r2, lsr r5
    24d8:	5f6d7261 	svcpl	0x006d7261
    24dc:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    24e0:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    24e4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    24e8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    24ec:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    24f0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    24f4:	32376178 	eorscc	r6, r7, #120, 2
    24f8:	6d726100 	ldfvse	f6, [r2, #-0]
    24fc:	7363705f 	cmnvc	r3, #95	; 0x5f
    2500:	6665645f 			; <UNDEFINED> instruction: 0x6665645f
    2504:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
    2508:	4d524100 	ldfmie	f4, [r2, #-0]
    250c:	5343505f 	movtpl	r5, #12383	; 0x305f
    2510:	5041415f 	subpl	r4, r1, pc, asr r1
    2514:	4c5f5343 	mrrcmi	3, 4, r5, pc, cr3	; <UNPREDICTABLE>
    2518:	4c41434f 	mcrrmi	3, 4, r4, r1, cr15
    251c:	52415400 	subpl	r5, r1, #0, 8
    2520:	5f544547 	svcpl	0x00544547
    2524:	5f555043 	svcpl	0x00555043
    2528:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    252c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2530:	41540035 	cmpmi	r4, r5, lsr r0
    2534:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2538:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    253c:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    2540:	61676e6f 	cmnvs	r7, pc, ror #28
    2544:	61006d72 	tstvs	r0, r2, ror sp
    2548:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    254c:	5f686372 	svcpl	0x00686372
    2550:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2554:	61003162 	tstvs	r0, r2, ror #2
    2558:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    255c:	5f686372 	svcpl	0x00686372
    2560:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2564:	54003262 	strpl	r3, [r0], #-610	; 0xfffffd9e
    2568:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    256c:	50435f54 	subpl	r5, r3, r4, asr pc
    2570:	77695f55 			; <UNDEFINED> instruction: 0x77695f55
    2574:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    2578:	52415400 	subpl	r5, r1, #0, 8
    257c:	5f544547 	svcpl	0x00544547
    2580:	5f555043 	svcpl	0x00555043
    2584:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    2588:	00743232 	rsbseq	r3, r4, r2, lsr r2
    258c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2590:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2594:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2598:	64376d72 	ldrtvs	r6, [r7], #-3442	; 0xfffff28e
    259c:	61736900 	cmnvs	r3, r0, lsl #18
    25a0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    25a4:	00706d5f 	rsbseq	r6, r0, pc, asr sp
    25a8:	5f6d7261 	svcpl	0x006d7261
    25ac:	735f646c 	cmpvc	pc, #108, 8	; 0x6c000000
    25b0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    25b4:	6d726100 	ldfvse	f6, [r2, #-0]
    25b8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    25bc:	315f3868 	cmpcc	pc, r8, ror #16
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
  20:	8b040e42 	blhi	103930 <__bss_end+0xfab04>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x347a04>
  28:	420d0d66 	andmi	r0, sp, #6528	; 0x1980
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	0000806c 	andeq	r8, r0, ip, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1fab24>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9e54>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080ac 	andeq	r8, r0, ip, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfab54>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x347a54>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080e4 	andeq	r8, r0, r4, ror #1
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfab74>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x347a74>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008110 	andeq	r8, r0, r0, lsl r1
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfab94>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x347a94>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008130 	andeq	r8, r0, r0, lsr r1
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfabb4>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x347ab4>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008148 	andeq	r8, r0, r8, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfabd4>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x347ad4>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008160 	andeq	r8, r0, r0, ror #2
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfabf4>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x347af4>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008178 	andeq	r8, r0, r8, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfac14>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x347b14>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	00008184 	andeq	r8, r0, r4, lsl #3
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1fac2c>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081dc 	ldrdeq	r8, [r0], -ip
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1fac4c>
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
 194:	00000048 	andeq	r0, r0, r8, asr #32
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1fac7c>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	0000827c 	andeq	r8, r0, ip, ror r2
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfaca8>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x347ba8>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	000082a8 	andeq	r8, r0, r8, lsr #5
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfacc8>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x347bc8>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	000082d4 	ldrdeq	r8, [r0], -r4
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xface8>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x347be8>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	000082f0 	strdeq	r8, [r0], -r0
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfad08>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x347c08>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	00008334 	andeq	r8, r0, r4, lsr r3
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfad28>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x347c28>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	00008384 	andeq	r8, r0, r4, lsl #7
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfad48>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x347c48>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	000083d4 	ldrdeq	r8, [r0], -r4
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfad68>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347c68>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	00008400 	andeq	r8, r0, r0, lsl #8
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfad88>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347c88>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	00008450 	andeq	r8, r0, r0, asr r4
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfada8>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x347ca8>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	00008494 	muleq	r0, r4, r4
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfadc8>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x347cc8>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	000084e4 	andeq	r8, r0, r4, ror #9
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfade8>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x347ce8>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	00008538 	andeq	r8, r0, r8, lsr r5
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfae08>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x347d08>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	00008574 	andeq	r8, r0, r4, ror r5
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfae28>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x347d28>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	000085b0 			; <UNDEFINED> instruction: 0x000085b0
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfae48>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347d48>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	000085ec 	andeq	r8, r0, ip, ror #11
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfae68>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347d68>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	00008628 	andeq	r8, r0, r8, lsr #12
 3a0:	000000b4 	strheq	r0, [r0], -r4
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1fae88>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c52 	stmdaeq	sp, {r1, r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	000086dc 	ldrdeq	r8, [r0], -ip
 3d0:	00000174 	andeq	r0, r0, r4, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1faeb8>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	00008850 	andeq	r8, r0, r0, asr r8
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfaed8>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x347dd8>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	000088ec 	andeq	r8, r0, ip, ror #17
 410:	000000c0 	andeq	r0, r0, r0, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfaef8>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x347df8>
 41c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	000089ac 	andeq	r8, r0, ip, lsr #19
 430:	000000ac 	andeq	r0, r0, ip, lsr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfaf18>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x347e18>
 43c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008a58 	andeq	r8, r0, r8, asr sl
 450:	00000054 	andeq	r0, r0, r4, asr r0
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfaf38>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347e38>
 45c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008aac 	andeq	r8, r0, ip, lsr #21
 470:	00000068 	andeq	r0, r0, r8, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfaf58>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347e58>
 47c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008b14 	andeq	r8, r0, r4, lsl fp
 490:	00000080 	andeq	r0, r0, r0, lsl #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfaf78>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347e78>
 49c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000000c 	andeq	r0, r0, ip
 4a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4ac:	7c010001 	stcvc	0, cr0, [r1], {1}
 4b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4b4:	0000000c 	andeq	r0, r0, ip
 4b8:	000004a4 	andeq	r0, r0, r4, lsr #9
 4bc:	00008b94 	muleq	r0, r4, fp
 4c0:	000001ec 	andeq	r0, r0, ip, ror #3
