
./user_task:     file format elf32-littlearm


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
    8058:	0000bdd8 	ldrdeq	fp, [r0], -r8
    805c:	0000bf08 	andeq	fp, r0, r8, lsl #30

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
    807c:	eb0004a2 	bl	930c <main>
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
    81c8:	0000bdd0 	ldrdeq	fp, [r0], -r0
    81cc:	0000bdd8 	ldrdeq	fp, [r0], -r8

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
    8220:	0000bdd8 	ldrdeq	fp, [r0], -r8
    8224:	0000bdd8 	ldrdeq	fp, [r0], -r8

00008228 <_Z3absd>:
_Z3absd():
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:21

void Quicksort(Parameters v[], int start, int end);

unsigned int rand(uint32_t file, uint32_t output_start, uint32_t output_end);

double abs(double x) {
    8228:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    822c:	e28db000 	add	fp, sp, #0
    8230:	e24dd00c 	sub	sp, sp, #12
    8234:	ed0b0b03 	vstr	d0, [fp, #-12]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:22
    return x < 0 ? -x : x;
    8238:	ed1b7b03 	vldr	d7, [fp, #-12]
    823c:	eeb57bc0 	vcmpe.f64	d7, #0.0
    8240:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8244:	5a000002 	bpl	8254 <_Z3absd+0x2c>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:22 (discriminator 1)
    8248:	ed1b7b03 	vldr	d7, [fp, #-12]
    824c:	eeb17b47 	vneg.f64	d7, d7
    8250:	ea000000 	b	8258 <_Z3absd+0x30>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:22 (discriminator 2)
    8254:	ed1b7b03 	vldr	d7, [fp, #-12]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:23 (discriminator 5)
}
    8258:	eeb00b47 	vmov.f64	d0, d7
    825c:	e28bd000 	add	sp, fp, #0
    8260:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8264:	e12fff1e 	bx	lr

00008268 <_ZL5fputsjPKc>:
_ZL5fputsjPKc():
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:52

        return ans;
    }
};

static void fputs(uint32_t file, const char *string) {
    8268:	e92d4800 	push	{fp, lr}
    826c:	e28db004 	add	fp, sp, #4
    8270:	e24dd008 	sub	sp, sp, #8
    8274:	e50b0008 	str	r0, [fp, #-8]
    8278:	e50b100c 	str	r1, [fp, #-12]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:53
    write(file, string, strlen(string));
    827c:	e51b000c 	ldr	r0, [fp, #-12]
    8280:	eb000aa4 	bl	ad18 <_Z6strlenPKc>
    8284:	e1a03000 	mov	r3, r0
    8288:	e1a02003 	mov	r2, r3
    828c:	e51b100c 	ldr	r1, [fp, #-12]
    8290:	e51b0008 	ldr	r0, [fp, #-8]
    8294:	eb00064e 	bl	9bd4 <_Z5writejPKcj>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:54
}
    8298:	e320f000 	nop	{0}
    829c:	e24bd004 	sub	sp, fp, #4
    82a0:	e8bd8800 	pop	{fp, pc}

000082a4 <_ZL5fgetsjPci>:
_ZL5fgetsjPci():
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:56

static void fgets(uint32_t file, char *buf, int size) {
    82a4:	e92d4800 	push	{fp, lr}
    82a8:	e28db004 	add	fp, sp, #4
    82ac:	e24dd010 	sub	sp, sp, #16
    82b0:	e50b0008 	str	r0, [fp, #-8]
    82b4:	e50b100c 	str	r1, [fp, #-12]
    82b8:	e50b2010 	str	r2, [fp, #-16]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:57
    read(file, buf, size);
    82bc:	e51b3010 	ldr	r3, [fp, #-16]
    82c0:	e1a02003 	mov	r2, r3
    82c4:	e51b100c 	ldr	r1, [fp, #-12]
    82c8:	e51b0008 	ldr	r0, [fp, #-8]
    82cc:	eb00062c 	bl	9b84 <_Z4readjPcj>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:58
}
    82d0:	e320f000 	nop	{0}
    82d4:	e24bd004 	sub	sp, fp, #4
    82d8:	e8bd8800 	pop	{fp, pc}

000082dc <_Z11await_inputjPc>:
_Z11await_inputjPc():
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:65
/**
 * Cteni radky vstupu
 * @param file
 * @param buffer
 */
void await_input(uint32_t file, char *buffer) {
    82dc:	e92d4800 	push	{fp, lr}
    82e0:	e28db004 	add	fp, sp, #4
    82e4:	e24dd018 	sub	sp, sp, #24
    82e8:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    82ec:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:66
    char *buf = new char[1];
    82f0:	e3a00001 	mov	r0, #1
    82f4:	eb0004e9 	bl	96a0 <_Znaj>
    82f8:	e1a03000 	mov	r3, r0
    82fc:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:69

    double input;
    fputs(file, ">");
    8300:	e59f10d0 	ldr	r1, [pc, #208]	; 83d8 <_Z11await_inputjPc+0xfc>
    8304:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8308:	ebffffd6 	bl	8268 <_ZL5fputsjPKc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:72

    while (1) {
        fgets(file, buf, 1);
    830c:	e3a02001 	mov	r2, #1
    8310:	e51b100c 	ldr	r1, [fp, #-12]
    8314:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8318:	ebffffe1 	bl	82a4 <_ZL5fgetsjPci>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:73
        if (buf[0] == '\r') //buf[0] == '\u000D' | buf[0] == '\x0D' | buf[0] == '\015'|
    831c:	e51b300c 	ldr	r3, [fp, #-12]
    8320:	e5d33000 	ldrb	r3, [r3]
    8324:	e353000d 	cmp	r3, #13
    8328:	1a00001e 	bne	83a8 <_Z11await_inputjPc+0xcc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:75
        {
            fputs(file, "\n");
    832c:	e59f10a8 	ldr	r1, [pc, #168]	; 83dc <_Z11await_inputjPc+0x100>
    8330:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8334:	ebffffcb 	bl	8268 <_ZL5fputsjPKc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:76
            int i = circBuffer.GetDifference();
    8338:	e59f00a0 	ldr	r0, [pc, #160]	; 83e0 <_Z11await_inputjPc+0x104>
    833c:	eb000579 	bl	9928 <_ZN6Buffer13GetDifferenceEv>
    8340:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:77
            for (int x = 0; x < i; x++) {
    8344:	e3a03000 	mov	r3, #0
    8348:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:77 (discriminator 3)
    834c:	e51b2008 	ldr	r2, [fp, #-8]
    8350:	e51b3010 	ldr	r3, [fp, #-16]
    8354:	e1520003 	cmp	r2, r3
    8358:	aa00000c 	bge	8390 <_Z11await_inputjPc+0xb4>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:78 (discriminator 2)
                char out = circBuffer.Pull();
    835c:	e59f007c 	ldr	r0, [pc, #124]	; 83e0 <_Z11await_inputjPc+0x104>
    8360:	eb000595 	bl	99bc <_ZN6Buffer4PullEv>
    8364:	e1a03000 	mov	r3, r0
    8368:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:79 (discriminator 2)
                buffer[x] = out;
    836c:	e51b3008 	ldr	r3, [fp, #-8]
    8370:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8374:	e0823003 	add	r3, r2, r3
    8378:	e55b2011 	ldrb	r2, [fp, #-17]	; 0xffffffef
    837c:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:77 (discriminator 2)
            for (int x = 0; x < i; x++) {
    8380:	e51b3008 	ldr	r3, [fp, #-8]
    8384:	e2833001 	add	r3, r3, #1
    8388:	e50b3008 	str	r3, [fp, #-8]
    838c:	eaffffee 	b	834c <_Z11await_inputjPc+0x70>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:82
                //fputs(uart_file, &out); // zopakuje zadany vstup
            }
            buffer[i] = '\0';
    8390:	e51b3010 	ldr	r3, [fp, #-16]
    8394:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8398:	e0823003 	add	r3, r2, r3
    839c:	e3a02000 	mov	r2, #0
    83a0:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:83
            break;
    83a4:	ea000008 	b	83cc <_Z11await_inputjPc+0xf0>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:85
        }
        circBuffer.Push(buf[0]);
    83a8:	e51b300c 	ldr	r3, [fp, #-12]
    83ac:	e5d33000 	ldrb	r3, [r3]
    83b0:	e1a01003 	mov	r1, r3
    83b4:	e59f0024 	ldr	r0, [pc, #36]	; 83e0 <_Z11await_inputjPc+0x104>
    83b8:	eb000567 	bl	995c <_ZN6Buffer4PushEc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:86
        fputs(file, buf);
    83bc:	e51b100c 	ldr	r1, [fp, #-12]
    83c0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    83c4:	ebffffa7 	bl	8268 <_ZL5fputsjPKc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:87
    }
    83c8:	eaffffcf 	b	830c <_Z11await_inputjPc+0x30>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:88
}
    83cc:	e320f000 	nop	{0}
    83d0:	e24bd004 	sub	sp, fp, #4
    83d4:	e8bd8800 	pop	{fp, pc}
    83d8:	0000bb7c 	andeq	fp, r0, ip, ror fp
    83dc:	0000bb80 	andeq	fp, r0, r0, lsl #23
    83e0:	0000bdd8 	ldrdeq	fp, [r0], -r8

000083e4 <_Z20print_int_value_linejPKciS0_>:
_Z20print_int_value_linejPKciS0_():
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:96
 * Vypsani celeho cisla
 * @param file
 * @param label
 * @param value
 */
void print_int_value_line(uint32_t file, const char *prefix, int value, const char *suffix) {
    83e4:	e92d4800 	push	{fp, lr}
    83e8:	e28db004 	add	fp, sp, #4
    83ec:	e24dd048 	sub	sp, sp, #72	; 0x48
    83f0:	e50b0040 	str	r0, [fp, #-64]	; 0xffffffc0
    83f4:	e50b1044 	str	r1, [fp, #-68]	; 0xffffffbc
    83f8:	e50b2048 	str	r2, [fp, #-72]	; 0xffffffb8
    83fc:	e50b304c 	str	r3, [fp, #-76]	; 0xffffffb4
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:99
    char buffer[50];

    fputs(file, prefix);
    8400:	e51b1044 	ldr	r1, [fp, #-68]	; 0xffffffbc
    8404:	e51b0040 	ldr	r0, [fp, #-64]	; 0xffffffc0
    8408:	ebffff96 	bl	8268 <_ZL5fputsjPKc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:100
    itoa(value, buffer, 10);
    840c:	e51b3048 	ldr	r3, [fp, #-72]	; 0xffffffb8
    8410:	e24b1038 	sub	r1, fp, #56	; 0x38
    8414:	e3a0200a 	mov	r2, #10
    8418:	e1a00003 	mov	r0, r3
    841c:	eb00095e 	bl	a99c <_Z4itoajPcj>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:101
    fputs(file, buffer);
    8420:	e24b3038 	sub	r3, fp, #56	; 0x38
    8424:	e1a01003 	mov	r1, r3
    8428:	e51b0040 	ldr	r0, [fp, #-64]	; 0xffffffc0
    842c:	ebffff8d 	bl	8268 <_ZL5fputsjPKc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:102
    fputs(file, suffix);
    8430:	e51b104c 	ldr	r1, [fp, #-76]	; 0xffffffb4
    8434:	e51b0040 	ldr	r0, [fp, #-64]	; 0xffffffc0
    8438:	ebffff8a 	bl	8268 <_ZL5fputsjPKc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:103
}
    843c:	e320f000 	nop	{0}
    8440:	e24bd004 	sub	sp, fp, #4
    8444:	e8bd8800 	pop	{fp, pc}

00008448 <_Z22print_float_value_linejPKcfS0_>:
_Z22print_float_value_linejPKcfS0_():
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:111
 * Vyspani cisla s desetinnou teckou
 * @param file
 * @param label
 * @param value
 */
void print_float_value_line(uint32_t file, const char *prefix, float value, const char *suffix) {
    8448:	e92d4800 	push	{fp, lr}
    844c:	e28db004 	add	fp, sp, #4
    8450:	e24dd048 	sub	sp, sp, #72	; 0x48
    8454:	e50b0040 	str	r0, [fp, #-64]	; 0xffffffc0
    8458:	e50b1044 	str	r1, [fp, #-68]	; 0xffffffbc
    845c:	ed0b0a12 	vstr	s0, [fp, #-72]	; 0xffffffb8
    8460:	e50b204c 	str	r2, [fp, #-76]	; 0xffffffb4
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:114
    char buffer[50];

    fputs(file, prefix);
    8464:	e51b1044 	ldr	r1, [fp, #-68]	; 0xffffffbc
    8468:	e51b0040 	ldr	r0, [fp, #-64]	; 0xffffffc0
    846c:	ebffff7d 	bl	8268 <_ZL5fputsjPKc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:115
    ftoa(value, buffer);
    8470:	e24b3038 	sub	r3, fp, #56	; 0x38
    8474:	e1a00003 	mov	r0, r3
    8478:	ed1b0a12 	vldr	s0, [fp, #-72]	; 0xffffffb8
    847c:	eb0007d1 	bl	a3c8 <_Z4ftoafPc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:116
    fputs(file, buffer);
    8480:	e24b3038 	sub	r3, fp, #56	; 0x38
    8484:	e1a01003 	mov	r1, r3
    8488:	e51b0040 	ldr	r0, [fp, #-64]	; 0xffffffc0
    848c:	ebffff75 	bl	8268 <_ZL5fputsjPKc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:117
    fputs(file, suffix);
    8490:	e51b104c 	ldr	r1, [fp, #-76]	; 0xffffffb4
    8494:	e51b0040 	ldr	r0, [fp, #-64]	; 0xffffffc0
    8498:	ebffff72 	bl	8268 <_ZL5fputsjPKc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:118
}
    849c:	e320f000 	nop	{0}
    84a0:	e24bd004 	sub	sp, fp, #4
    84a4:	e8bd8800 	pop	{fp, pc}

000084a8 <_Z12read_integerjPc>:
_Z12read_integerjPc():
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:126
 * Cteni celeho cisla ze vstupu
 * @param file
 * @param input_buffer
 * @return
 */
int read_integer(uint32_t file, char *input_buffer) {
    84a8:	e92d4800 	push	{fp, lr}
    84ac:	e28db004 	add	fp, sp, #4
    84b0:	e24dd008 	sub	sp, sp, #8
    84b4:	e50b0008 	str	r0, [fp, #-8]
    84b8:	e50b100c 	str	r1, [fp, #-12]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:128
    while (1) {
        await_input(file, input_buffer);
    84bc:	e51b100c 	ldr	r1, [fp, #-12]
    84c0:	e51b0008 	ldr	r0, [fp, #-8]
    84c4:	ebffff84 	bl	82dc <_Z11await_inputjPc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:129
        if (!is_decimal(input_buffer)) {
    84c8:	e51b000c 	ldr	r0, [fp, #-12]
    84cc:	eb000a92 	bl	af1c <_Z10is_decimalPKc>
    84d0:	e1a03000 	mov	r3, r0
    84d4:	e2233001 	eor	r3, r3, #1
    84d8:	e6ef3073 	uxtb	r3, r3
    84dc:	e3530000 	cmp	r3, #0
    84e0:	0a000003 	beq	84f4 <_Z12read_integerjPc+0x4c>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:130 (discriminator 1)
            fputs(file, "Nesprávný vstup. Zadejte celočíselnou hodnotu.\n");
    84e4:	e59f1028 	ldr	r1, [pc, #40]	; 8514 <_Z12read_integerjPc+0x6c>
    84e8:	e51b0008 	ldr	r0, [fp, #-8]
    84ec:	ebffff5d 	bl	8268 <_ZL5fputsjPKc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:131 (discriminator 1)
            continue;
    84f0:	ea000003 	b	8504 <_Z12read_integerjPc+0x5c>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:134
        }

        return atoi(input_buffer);
    84f4:	e51b000c 	ldr	r0, [fp, #-12]
    84f8:	eb000984 	bl	ab10 <_Z4atoiPKc>
    84fc:	e1a03000 	mov	r3, r0
    8500:	ea000000 	b	8508 <_Z12read_integerjPc+0x60>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:128
        await_input(file, input_buffer);
    8504:	eaffffec 	b	84bc <_Z12read_integerjPc+0x14>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:136 (discriminator 1)
    }
}
    8508:	e1a00003 	mov	r0, r3
    850c:	e24bd004 	sub	sp, fp, #4
    8510:	e8bd8800 	pop	{fp, pc}
    8514:	0000bb84 	andeq	fp, r0, r4, lsl #23

00008518 <_Z10read_floatjPc>:
_Z10read_floatjPc():
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:144
 * Cteni cisla s pohyblivou desetinnou teckou ze vstupu
 * @param file
 * @param input_buffer
 * @return
 */
float read_float(uint32_t file, char *input_buffer) {
    8518:	e92d4800 	push	{fp, lr}
    851c:	e28db004 	add	fp, sp, #4
    8520:	e24dd008 	sub	sp, sp, #8
    8524:	e50b0008 	str	r0, [fp, #-8]
    8528:	e50b100c 	str	r1, [fp, #-12]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:146
    while (1) {
        await_input(file, input_buffer);
    852c:	e51b100c 	ldr	r1, [fp, #-12]
    8530:	e51b0008 	ldr	r0, [fp, #-8]
    8534:	ebffff68 	bl	82dc <_Z11await_inputjPc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:147
        if (!is_float(input_buffer)) {
    8538:	e51b000c 	ldr	r0, [fp, #-12]
    853c:	eb000abc 	bl	b034 <_Z8is_floatPKc>
    8540:	e1a03000 	mov	r3, r0
    8544:	e2233001 	eor	r3, r3, #1
    8548:	e6ef3073 	uxtb	r3, r3
    854c:	e3530000 	cmp	r3, #0
    8550:	0a000003 	beq	8564 <_Z10read_floatjPc+0x4c>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:148 (discriminator 1)
            fputs(file, "Nesprávný vstup. Zadejte číslo prosím.\n");
    8554:	e59f1028 	ldr	r1, [pc, #40]	; 8584 <_Z10read_floatjPc+0x6c>
    8558:	e51b0008 	ldr	r0, [fp, #-8]
    855c:	ebffff41 	bl	8268 <_ZL5fputsjPKc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:149 (discriminator 1)
            continue;
    8560:	ea000003 	b	8574 <_Z10read_floatjPc+0x5c>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:152
        }

        return atof(input_buffer);
    8564:	e51b000c 	ldr	r0, [fp, #-12]
    8568:	eb00085e 	bl	a6e8 <_Z4atofPKc>
    856c:	eef07a40 	vmov.f32	s15, s0
    8570:	ea000000 	b	8578 <_Z10read_floatjPc+0x60>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:146
        await_input(file, input_buffer);
    8574:	eaffffec 	b	852c <_Z10read_floatjPc+0x14>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:154 (discriminator 1)
    }
}
    8578:	eeb00a67 	vmov.f32	s0, s15
    857c:	e24bd004 	sub	sp, fp, #4
    8580:	e8bd8800 	pop	{fp, pc}
    8584:	0000bbb8 			; <UNDEFINED> instruction: 0x0000bbb8

00008588 <_Z12print_paramsj10ParametersPc>:
_Z12print_paramsj10ParametersPc():
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:162
 * Vypis parametru modelu
 * @param file
 * @param population
 * @param input_buffer
 */
void print_params(uint32_t file, Parameters population, char *input_buffer) {
    8588:	e24dd008 	sub	sp, sp, #8
    858c:	e92d4800 	push	{fp, lr}
    8590:	e28db004 	add	fp, sp, #4
    8594:	e24dd008 	sub	sp, sp, #8
    8598:	e50b0008 	str	r0, [fp, #-8]
    859c:	e28b1004 	add	r1, fp, #4
    85a0:	e881000c 	stm	r1, {r2, r3}
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:163
    print_float_value_line(file, "A = ", population.a, ", ");
    85a4:	ed9b7b03 	vldr	d7, [fp, #12]
    85a8:	eef77bc7 	vcvt.f32.f64	s15, d7
    85ac:	e59f2090 	ldr	r2, [pc, #144]	; 8644 <_Z12print_paramsj10ParametersPc+0xbc>
    85b0:	eeb00a67 	vmov.f32	s0, s15
    85b4:	e59f108c 	ldr	r1, [pc, #140]	; 8648 <_Z12print_paramsj10ParametersPc+0xc0>
    85b8:	e51b0008 	ldr	r0, [fp, #-8]
    85bc:	ebffffa1 	bl	8448 <_Z22print_float_value_linejPKcfS0_>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:164
    print_float_value_line(file, "B = ", population.b, ", ");
    85c0:	ed9b7b05 	vldr	d7, [fp, #20]
    85c4:	eef77bc7 	vcvt.f32.f64	s15, d7
    85c8:	e59f2074 	ldr	r2, [pc, #116]	; 8644 <_Z12print_paramsj10ParametersPc+0xbc>
    85cc:	eeb00a67 	vmov.f32	s0, s15
    85d0:	e59f1074 	ldr	r1, [pc, #116]	; 864c <_Z12print_paramsj10ParametersPc+0xc4>
    85d4:	e51b0008 	ldr	r0, [fp, #-8]
    85d8:	ebffff9a 	bl	8448 <_Z22print_float_value_linejPKcfS0_>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:165
    print_float_value_line(file, "C = ", population.c, ", ");
    85dc:	ed9b7b07 	vldr	d7, [fp, #28]
    85e0:	eef77bc7 	vcvt.f32.f64	s15, d7
    85e4:	e59f2058 	ldr	r2, [pc, #88]	; 8644 <_Z12print_paramsj10ParametersPc+0xbc>
    85e8:	eeb00a67 	vmov.f32	s0, s15
    85ec:	e59f105c 	ldr	r1, [pc, #92]	; 8650 <_Z12print_paramsj10ParametersPc+0xc8>
    85f0:	e51b0008 	ldr	r0, [fp, #-8]
    85f4:	ebffff93 	bl	8448 <_Z22print_float_value_linejPKcfS0_>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:166
    print_float_value_line(file, "D = ", population.d, ", ");
    85f8:	ed9b7b09 	vldr	d7, [fp, #36]	; 0x24
    85fc:	eef77bc7 	vcvt.f32.f64	s15, d7
    8600:	e59f203c 	ldr	r2, [pc, #60]	; 8644 <_Z12print_paramsj10ParametersPc+0xbc>
    8604:	eeb00a67 	vmov.f32	s0, s15
    8608:	e59f1044 	ldr	r1, [pc, #68]	; 8654 <_Z12print_paramsj10ParametersPc+0xcc>
    860c:	e51b0008 	ldr	r0, [fp, #-8]
    8610:	ebffff8c 	bl	8448 <_Z22print_float_value_linejPKcfS0_>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:167
    print_float_value_line(file, "E = ", population.e, "\n");
    8614:	ed9b7b0b 	vldr	d7, [fp, #44]	; 0x2c
    8618:	eef77bc7 	vcvt.f32.f64	s15, d7
    861c:	e59f2034 	ldr	r2, [pc, #52]	; 8658 <_Z12print_paramsj10ParametersPc+0xd0>
    8620:	eeb00a67 	vmov.f32	s0, s15
    8624:	e59f1030 	ldr	r1, [pc, #48]	; 865c <_Z12print_paramsj10ParametersPc+0xd4>
    8628:	e51b0008 	ldr	r0, [fp, #-8]
    862c:	ebffff85 	bl	8448 <_Z22print_float_value_linejPKcfS0_>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:168
}
    8630:	e320f000 	nop	{0}
    8634:	e24bd004 	sub	sp, fp, #4
    8638:	e8bd4800 	pop	{fp, lr}
    863c:	e28dd008 	add	sp, sp, #8
    8640:	e12fff1e 	bx	lr
    8644:	0000bbe8 	andeq	fp, r0, r8, ror #23
    8648:	0000bbec 	andeq	fp, r0, ip, ror #23
    864c:	0000bbf4 	strdeq	fp, [r0], -r4
    8650:	0000bbfc 	strdeq	fp, [r0], -ip
    8654:	0000bc04 	andeq	fp, r0, r4, lsl #24
    8658:	0000bb80 	andeq	fp, r0, r0, lsl #23
    865c:	0000bc0c 	andeq	fp, r0, ip, lsl #24

00008660 <_Z7programj>:
_Z7programj():
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:175
/**
 * Vstupni bod do casti programu s vypoctem
 * @param file
 * @return
 */
int program(uint32_t file) {
    8660:	e92d4bf0 	push	{r4, r5, r6, r7, r8, r9, fp, lr}
    8664:	ed2d8b08 	vpush	{d8-d11}
    8668:	e28db03c 	add	fp, sp, #60	; 0x3c
    866c:	e24ddd9a 	sub	sp, sp, #9856	; 0x2680
    8670:	e24dd020 	sub	sp, sp, #32
    8674:	e24b3a02 	sub	r3, fp, #8192	; 0x2000
    8678:	e243303c 	sub	r3, r3, #60	; 0x3c
    867c:	e503066c 	str	r0, [r3, #-1644]	; 0xfffff994
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:180
    int t_delta; // velikost krokovani (minuty)
    int t_pred; // vzdalenost predikce (minuty)
    int time; // probehly cas (minuty)
    float values[VALUE_ARRAY_SIZE];
    int index = 0;
    8680:	e3a03000 	mov	r3, #0
    8684:	e50b3044 	str	r3, [fp, #-68]	; 0xffffffbc
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:182

    uint32_t trng_file = open("DEV:trng", NFile_Open_Mode::Read_Only);
    8688:	e3a01000 	mov	r1, #0
    868c:	e59f0b04 	ldr	r0, [pc, #2820]	; 9198 <_Z7programj+0xb38>
    8690:	eb00052a 	bl	9b40 <_Z4openPKc15NFile_Open_Mode>
    8694:	e50b0060 	str	r0, [fp, #-96]	; 0xffffffa0
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:184

    char *input_buffer = new char[buffer_constants::BUFFER_SIZE];
    8698:	e3a00c01 	mov	r0, #256	; 0x100
    869c:	eb0003ff 	bl	96a0 <_Znaj>
    86a0:	e1a03000 	mov	r3, r0
    86a4:	e50b3064 	str	r3, [fp, #-100]	; 0xffffff9c
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:191
    /*
     * Definice krokovani a predikce
     */

    // Cteni krokovani
    t_delta = read_integer(file, input_buffer);
    86a8:	e24b3a02 	sub	r3, fp, #8192	; 0x2000
    86ac:	e243303c 	sub	r3, r3, #60	; 0x3c
    86b0:	e51b1064 	ldr	r1, [fp, #-100]	; 0xffffff9c
    86b4:	e513066c 	ldr	r0, [r3, #-1644]	; 0xfffff994
    86b8:	ebffff7a 	bl	84a8 <_Z12read_integerjPc>
    86bc:	e50b0068 	str	r0, [fp, #-104]	; 0xffffff98
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:192
    print_int_value_line(file, "OK, krokovani ", t_delta, " minut\n");
    86c0:	e24b3a02 	sub	r3, fp, #8192	; 0x2000
    86c4:	e243303c 	sub	r3, r3, #60	; 0x3c
    86c8:	e1a00003 	mov	r0, r3
    86cc:	e59f3ac8 	ldr	r3, [pc, #2760]	; 919c <_Z7programj+0xb3c>
    86d0:	e51b2068 	ldr	r2, [fp, #-104]	; 0xffffff98
    86d4:	e59f1ac4 	ldr	r1, [pc, #2756]	; 91a0 <_Z7programj+0xb40>
    86d8:	e510066c 	ldr	r0, [r0, #-1644]	; 0xfffff994
    86dc:	ebffff40 	bl	83e4 <_Z20print_int_value_linejPKciS0_>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:195

    // Cteni velikosti predikce
    t_pred = read_integer(file, input_buffer);
    86e0:	e24b3a02 	sub	r3, fp, #8192	; 0x2000
    86e4:	e243303c 	sub	r3, r3, #60	; 0x3c
    86e8:	e51b1064 	ldr	r1, [fp, #-100]	; 0xffffff9c
    86ec:	e513066c 	ldr	r0, [r3, #-1644]	; 0xfffff994
    86f0:	ebffff6c 	bl	84a8 <_Z12read_integerjPc>
    86f4:	e50b006c 	str	r0, [fp, #-108]	; 0xffffff94
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:196
    print_int_value_line(file, "OK, predikce ", t_pred, " minut\n");
    86f8:	e24b3a02 	sub	r3, fp, #8192	; 0x2000
    86fc:	e243303c 	sub	r3, r3, #60	; 0x3c
    8700:	e1a00003 	mov	r0, r3
    8704:	e59f3a90 	ldr	r3, [pc, #2704]	; 919c <_Z7programj+0xb3c>
    8708:	e51b206c 	ldr	r2, [fp, #-108]	; 0xffffff94
    870c:	e59f1a90 	ldr	r1, [pc, #2704]	; 91a4 <_Z7programj+0xb44>
    8710:	e510066c 	ldr	r0, [r0, #-1644]	; 0xfffff994
    8714:	ebffff32 	bl	83e4 <_Z20print_int_value_linejPKciS0_>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:202

    /*
     * Priprava genetickeho algoritmu
     */

    time = 0;
    8718:	e3a03000 	mov	r3, #0
    871c:	e50b3040 	str	r3, [fp, #-64]	; 0xffffffc0
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:204

    const int SOLUTION_SIZE = 100;
    8720:	e3a03064 	mov	r3, #100	; 0x64
    8724:	e50b3070 	str	r3, [fp, #-112]	; 0xffffff90
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:209

    Parameters populations[SOLUTION_SIZE];

    // Generace populace
    for (int i = 0; i < SOLUTION_SIZE; i++) {
    8728:	e3a03000 	mov	r3, #0
    872c:	e50b3048 	str	r3, [fp, #-72]	; 0xffffffb8
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:209 (discriminator 3)
    8730:	e51b3048 	ldr	r3, [fp, #-72]	; 0xffffffb8
    8734:	e3530063 	cmp	r3, #99	; 0x63
    8738:	ca000065 	bgt	88d4 <_Z7programj+0x274>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:212 (discriminator 2)
        populations[i] = Parameters{
                0,
                (double) rand(trng_file, 0, 30),
    873c:	e3a0201e 	mov	r2, #30
    8740:	e3a01000 	mov	r1, #0
    8744:	e51b0060 	ldr	r0, [fp, #-96]	; 0xffffffa0
    8748:	eb000310 	bl	9390 <_Z4randjjj>
    874c:	ee070a90 	vmov	s15, r0
    8750:	eeb8bb67 	vcvt.f64.u32	d11, s15
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:213 (discriminator 2)
                (double) rand(trng_file, 0, 30),
    8754:	e3a0201e 	mov	r2, #30
    8758:	e3a01000 	mov	r1, #0
    875c:	e51b0060 	ldr	r0, [fp, #-96]	; 0xffffffa0
    8760:	eb00030a 	bl	9390 <_Z4randjjj>
    8764:	ee070a90 	vmov	s15, r0
    8768:	eeb8ab67 	vcvt.f64.u32	d10, s15
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:214 (discriminator 2)
                (double) rand(trng_file, 0, 30),
    876c:	e3a0201e 	mov	r2, #30
    8770:	e3a01000 	mov	r1, #0
    8774:	e51b0060 	ldr	r0, [fp, #-96]	; 0xffffffa0
    8778:	eb000304 	bl	9390 <_Z4randjjj>
    877c:	ee070a90 	vmov	s15, r0
    8780:	eeb89b67 	vcvt.f64.u32	d9, s15
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:215 (discriminator 2)
                (double) rand(trng_file, 0, 30),
    8784:	e3a0201e 	mov	r2, #30
    8788:	e3a01000 	mov	r1, #0
    878c:	e51b0060 	ldr	r0, [fp, #-96]	; 0xffffffa0
    8790:	eb0002fe 	bl	9390 <_Z4randjjj>
    8794:	ee070a90 	vmov	s15, r0
    8798:	eeb88b67 	vcvt.f64.u32	d8, s15
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:216 (discriminator 2)
                (double) rand(trng_file, 0, 30)
    879c:	e3a0201e 	mov	r2, #30
    87a0:	e3a01000 	mov	r1, #0
    87a4:	e51b0060 	ldr	r0, [fp, #-96]	; 0xffffffa0
    87a8:	eb0002f8 	bl	9390 <_Z4randjjj>
    87ac:	ee070a90 	vmov	s15, r0
    87b0:	eeb87b67 	vcvt.f64.u32	d7, s15
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:210 (discriminator 2)
        populations[i] = Parameters{
    87b4:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    87b8:	e243303c 	sub	r3, r3, #60	; 0x3c
    87bc:	e1a01003 	mov	r1, r3
    87c0:	e51b2048 	ldr	r2, [fp, #-72]	; 0xffffffb8
    87c4:	e1a03002 	mov	r3, r2
    87c8:	e1a03083 	lsl	r3, r3, #1
    87cc:	e0833002 	add	r3, r3, r2
    87d0:	e1a03203 	lsl	r3, r3, #4
    87d4:	e0813003 	add	r3, r1, r3
    87d8:	e2431fea 	sub	r1, r3, #936	; 0x3a8
    87dc:	e3a02000 	mov	r2, #0
    87e0:	e3a03000 	mov	r3, #0
    87e4:	e1c120f0 	strd	r2, [r1]
    87e8:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    87ec:	e243303c 	sub	r3, r3, #60	; 0x3c
    87f0:	e1a01003 	mov	r1, r3
    87f4:	e51b2048 	ldr	r2, [fp, #-72]	; 0xffffffb8
    87f8:	e1a03002 	mov	r3, r2
    87fc:	e1a03083 	lsl	r3, r3, #1
    8800:	e0833002 	add	r3, r3, r2
    8804:	e1a03203 	lsl	r3, r3, #4
    8808:	e0813003 	add	r3, r1, r3
    880c:	e2433e3a 	sub	r3, r3, #928	; 0x3a0
    8810:	ed83bb00 	vstr	d11, [r3]
    8814:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    8818:	e243303c 	sub	r3, r3, #60	; 0x3c
    881c:	e1a01003 	mov	r1, r3
    8820:	e51b2048 	ldr	r2, [fp, #-72]	; 0xffffffb8
    8824:	e1a03002 	mov	r3, r2
    8828:	e1a03083 	lsl	r3, r3, #1
    882c:	e0833002 	add	r3, r3, r2
    8830:	e1a03203 	lsl	r3, r3, #4
    8834:	e0813003 	add	r3, r1, r3
    8838:	e2433fe6 	sub	r3, r3, #920	; 0x398
    883c:	ed83ab00 	vstr	d10, [r3]
    8840:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    8844:	e243303c 	sub	r3, r3, #60	; 0x3c
    8848:	e1a01003 	mov	r1, r3
    884c:	e51b2048 	ldr	r2, [fp, #-72]	; 0xffffffb8
    8850:	e1a03002 	mov	r3, r2
    8854:	e1a03083 	lsl	r3, r3, #1
    8858:	e0833002 	add	r3, r3, r2
    885c:	e1a03203 	lsl	r3, r3, #4
    8860:	e0813003 	add	r3, r1, r3
    8864:	e2433e39 	sub	r3, r3, #912	; 0x390
    8868:	ed839b00 	vstr	d9, [r3]
    886c:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    8870:	e243303c 	sub	r3, r3, #60	; 0x3c
    8874:	e1a01003 	mov	r1, r3
    8878:	e51b2048 	ldr	r2, [fp, #-72]	; 0xffffffb8
    887c:	e1a03002 	mov	r3, r2
    8880:	e1a03083 	lsl	r3, r3, #1
    8884:	e0833002 	add	r3, r3, r2
    8888:	e1a03203 	lsl	r3, r3, #4
    888c:	e0813003 	add	r3, r1, r3
    8890:	e2433fe2 	sub	r3, r3, #904	; 0x388
    8894:	ed838b00 	vstr	d8, [r3]
    8898:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    889c:	e243303c 	sub	r3, r3, #60	; 0x3c
    88a0:	e1a01003 	mov	r1, r3
    88a4:	e51b2048 	ldr	r2, [fp, #-72]	; 0xffffffb8
    88a8:	e1a03002 	mov	r3, r2
    88ac:	e1a03083 	lsl	r3, r3, #1
    88b0:	e0833002 	add	r3, r3, r2
    88b4:	e1a03203 	lsl	r3, r3, #4
    88b8:	e0813003 	add	r3, r1, r3
    88bc:	e2433d0e 	sub	r3, r3, #896	; 0x380
    88c0:	ed837b00 	vstr	d7, [r3]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:209 (discriminator 2)
    for (int i = 0; i < SOLUTION_SIZE; i++) {
    88c4:	e51b3048 	ldr	r3, [fp, #-72]	; 0xffffffb8
    88c8:	e2833001 	add	r3, r3, #1
    88cc:	e50b3048 	str	r3, [fp, #-72]	; 0xffffffb8
    88d0:	eaffff96 	b	8730 <_Z7programj+0xd0>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:225
    /*
     * Vstup od uzivatele
     */

    while (1) {
        await_input(file, input_buffer);
    88d4:	e24b3a02 	sub	r3, fp, #8192	; 0x2000
    88d8:	e243303c 	sub	r3, r3, #60	; 0x3c
    88dc:	e51b1064 	ldr	r1, [fp, #-100]	; 0xffffff9c
    88e0:	e513066c 	ldr	r0, [r3, #-1644]	; 0xfffff994
    88e4:	ebfffe7c 	bl	82dc <_Z11await_inputjPc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:226
        int input_size = strlen(input_buffer);
    88e8:	e51b0064 	ldr	r0, [fp, #-100]	; 0xffffff9c
    88ec:	eb000909 	bl	ad18 <_Z6strlenPKc>
    88f0:	e50b0074 	str	r0, [fp, #-116]	; 0xffffff8c
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:229

        // Vstup je prazdny retezec
        if (input_size == 0) {
    88f4:	e51b3074 	ldr	r3, [fp, #-116]	; 0xffffff8c
    88f8:	e3530000 	cmp	r3, #0
    88fc:	0a00027e 	beq	92fc <_Z7programj+0xc9c>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:234
            continue;
        }

        // Je zadan prikaz stop
        if (!strncmp(input_buffer, "stop", input_size)) {
    8900:	e51b2074 	ldr	r2, [fp, #-116]	; 0xffffff8c
    8904:	e59f189c 	ldr	r1, [pc, #2204]	; 91a8 <_Z7programj+0xb48>
    8908:	e51b0064 	ldr	r0, [fp, #-100]	; 0xffffff9c
    890c:	eb0008d6 	bl	ac6c <_Z7strncmpPKcS0_i>
    8910:	e1a03000 	mov	r3, r0
    8914:	e3530000 	cmp	r3, #0
    8918:	03a03001 	moveq	r3, #1
    891c:	13a03000 	movne	r3, #0
    8920:	e6ef3073 	uxtb	r3, r3
    8924:	e3530000 	cmp	r3, #0
    8928:	1a000275 	bne	9304 <_Z7programj+0xca4>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:239
            continue;
        }

        // Je zadan prikaz parameters
        if (!strncmp(input_buffer, "parameters", input_size)) {
    892c:	e51b2074 	ldr	r2, [fp, #-116]	; 0xffffff8c
    8930:	e59f1874 	ldr	r1, [pc, #2164]	; 91ac <_Z7programj+0xb4c>
    8934:	e51b0064 	ldr	r0, [fp, #-100]	; 0xffffff9c
    8938:	eb0008cb 	bl	ac6c <_Z7strncmpPKcS0_i>
    893c:	e1a03000 	mov	r3, r0
    8940:	e3530000 	cmp	r3, #0
    8944:	03a03001 	moveq	r3, #1
    8948:	13a03000 	movne	r3, #0
    894c:	e6ef3073 	uxtb	r3, r3
    8950:	e3530000 	cmp	r3, #0
    8954:	0a000014 	beq	89ac <_Z7programj+0x34c>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:240 (discriminator 1)
            print_params(file, (populations[0]), input_buffer);
    8958:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    895c:	e243303c 	sub	r3, r3, #60	; 0x3c
    8960:	e1a04003 	mov	r4, r3
    8964:	e24b3a02 	sub	r3, fp, #8192	; 0x2000
    8968:	e243303c 	sub	r3, r3, #60	; 0x3c
    896c:	e1a05003 	mov	r5, r3
    8970:	e51b3064 	ldr	r3, [fp, #-100]	; 0xffffff9c
    8974:	e58d3028 	str	r3, [sp, #40]	; 0x28
    8978:	e1a0e00d 	mov	lr, sp
    897c:	e244ce3a 	sub	ip, r4, #928	; 0x3a0
    8980:	e8bc000f 	ldm	ip!, {r0, r1, r2, r3}
    8984:	e8ae000f 	stmia	lr!, {r0, r1, r2, r3}
    8988:	e8bc000f 	ldm	ip!, {r0, r1, r2, r3}
    898c:	e8ae000f 	stmia	lr!, {r0, r1, r2, r3}
    8990:	e89c0003 	ldm	ip, {r0, r1}
    8994:	e88e0003 	stm	lr, {r0, r1}
    8998:	e2443fea 	sub	r3, r4, #936	; 0x3a8
    899c:	e893000c 	ldm	r3, {r2, r3}
    89a0:	e515066c 	ldr	r0, [r5, #-1644]	; 0xfffff994
    89a4:	ebfffef7 	bl	8588 <_Z12print_paramsj10ParametersPc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:241 (discriminator 1)
            continue;
    89a8:	ea000256 	b	9308 <_Z7programj+0xca8>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:245
        }

        // Vstup je hodnota y(t)
        if (is_float(input_buffer)) {
    89ac:	e51b0064 	ldr	r0, [fp, #-100]	; 0xffffff9c
    89b0:	eb00099f 	bl	b034 <_Z8is_floatPKc>
    89b4:	e1a03000 	mov	r3, r0
    89b8:	e3530000 	cmp	r3, #0
    89bc:	0a000248 	beq	92e4 <_Z7programj+0xc84>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:246
            float value = atof(input_buffer);
    89c0:	e51b0064 	ldr	r0, [fp, #-100]	; 0xffffff9c
    89c4:	eb000747 	bl	a6e8 <_Z4atofPKc>
    89c8:	ed0b0a1e 	vstr	s0, [fp, #-120]	; 0xffffff88
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:247
            values[index] = value;
    89cc:	e51b3044 	ldr	r3, [fp, #-68]	; 0xffffffbc
    89d0:	e1a03103 	lsl	r3, r3, #2
    89d4:	e24b203c 	sub	r2, fp, #60	; 0x3c
    89d8:	e0823003 	add	r3, r2, r3
    89dc:	e24330e4 	sub	r3, r3, #228	; 0xe4
    89e0:	e51b2078 	ldr	r2, [fp, #-120]	; 0xffffff88
    89e4:	e5832000 	str	r2, [r3]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:249

            if (time < t_pred) {
    89e8:	e51b2040 	ldr	r2, [fp, #-64]	; 0xffffffc0
    89ec:	e51b306c 	ldr	r3, [fp, #-108]	; 0xffffff94
    89f0:	e1520003 	cmp	r2, r3
    89f4:	aa000009 	bge	8a20 <_Z7programj+0x3c0>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:250
                time += t_delta;
    89f8:	e51b2040 	ldr	r2, [fp, #-64]	; 0xffffffc0
    89fc:	e51b3068 	ldr	r3, [fp, #-104]	; 0xffffff98
    8a00:	e0823003 	add	r3, r2, r3
    8a04:	e50b3040 	str	r3, [fp, #-64]	; 0xffffffc0
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:251
                fputs(file, "NaN\n");
    8a08:	e24b3a02 	sub	r3, fp, #8192	; 0x2000
    8a0c:	e243303c 	sub	r3, r3, #60	; 0x3c
    8a10:	e59f1798 	ldr	r1, [pc, #1944]	; 91b0 <_Z7programj+0xb50>
    8a14:	e513066c 	ldr	r0, [r3, #-1644]	; 0xfffff994
    8a18:	ebfffe12 	bl	8268 <_ZL5fputsjPKc>
    8a1c:	ea000222 	b	92ac <_Z7programj+0xc4c>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:253
            } else {
                fputs(file, "Pocitam...\n");
    8a20:	e24b3a02 	sub	r3, fp, #8192	; 0x2000
    8a24:	e243303c 	sub	r3, r3, #60	; 0x3c
    8a28:	e59f1784 	ldr	r1, [pc, #1924]	; 91b4 <_Z7programj+0xb54>
    8a2c:	e513066c 	ldr	r0, [r3, #-1644]	; 0xfffff994
    8a30:	ebfffe0c 	bl	8268 <_ZL5fputsjPKc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:255

                for (int i = 0; i < SOLUTION_SIZE; i++) {
    8a34:	e3a03000 	mov	r3, #0
    8a38:	e50b304c 	str	r3, [fp, #-76]	; 0xffffffb4
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:255 (discriminator 3)
    8a3c:	e51b304c 	ldr	r3, [fp, #-76]	; 0xffffffb4
    8a40:	e3530063 	cmp	r3, #99	; 0x63
    8a44:	ca00002e 	bgt	8b04 <_Z7programj+0x4a4>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:256 (discriminator 2)
                    populations[i].fitness(values[(index - (t_pred / t_delta)) % VALUE_ARRAY_SIZE], values[index]);
    8a48:	e24b2d4e 	sub	r2, fp, #4992	; 0x1380
    8a4c:	e242203c 	sub	r2, r2, #60	; 0x3c
    8a50:	e2422028 	sub	r2, r2, #40	; 0x28
    8a54:	e51b104c 	ldr	r1, [fp, #-76]	; 0xffffffb4
    8a58:	e1a03001 	mov	r3, r1
    8a5c:	e1a03083 	lsl	r3, r3, #1
    8a60:	e0833001 	add	r3, r3, r1
    8a64:	e1a03203 	lsl	r3, r3, #4
    8a68:	e0824003 	add	r4, r2, r3
    8a6c:	e51b1068 	ldr	r1, [fp, #-104]	; 0xffffff98
    8a70:	e51b006c 	ldr	r0, [fp, #-108]	; 0xffffff94
    8a74:	eb000a63 	bl	b408 <__divsi3>
    8a78:	e1a03000 	mov	r3, r0
    8a7c:	e1a02003 	mov	r2, r3
    8a80:	e51b3044 	ldr	r3, [fp, #-68]	; 0xffffffbc
    8a84:	e0431002 	sub	r1, r3, r2
    8a88:	e59f3730 	ldr	r3, [pc, #1840]	; 91c0 <_Z7programj+0xb60>
    8a8c:	e0c32193 	smull	r2, r3, r3, r1
    8a90:	e1a02243 	asr	r2, r3, #4
    8a94:	e1a03fc1 	asr	r3, r1, #31
    8a98:	e0422003 	sub	r2, r2, r3
    8a9c:	e1a03002 	mov	r3, r2
    8aa0:	e1a03103 	lsl	r3, r3, #2
    8aa4:	e0833002 	add	r3, r3, r2
    8aa8:	e1a03183 	lsl	r3, r3, #3
    8aac:	e0412003 	sub	r2, r1, r3
    8ab0:	e1a03102 	lsl	r3, r2, #2
    8ab4:	e24b203c 	sub	r2, fp, #60	; 0x3c
    8ab8:	e0823003 	add	r3, r2, r3
    8abc:	e24330e4 	sub	r3, r3, #228	; 0xe4
    8ac0:	edd37a00 	vldr	s15, [r3]
    8ac4:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8ac8:	e51b3044 	ldr	r3, [fp, #-68]	; 0xffffffbc
    8acc:	e1a03103 	lsl	r3, r3, #2
    8ad0:	e24b203c 	sub	r2, fp, #60	; 0x3c
    8ad4:	e0823003 	add	r3, r2, r3
    8ad8:	e24330e4 	sub	r3, r3, #228	; 0xe4
    8adc:	edd36a00 	vldr	s13, [r3]
    8ae0:	eeb76ae6 	vcvt.f64.f32	d6, s13
    8ae4:	eeb01b46 	vmov.f64	d1, d6
    8ae8:	eeb00b47 	vmov.f64	d0, d7
    8aec:	e1a00004 	mov	r0, r4
    8af0:	eb000312 	bl	9740 <_ZN10Parameters7fitnessEdd>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:255 (discriminator 2)
                for (int i = 0; i < SOLUTION_SIZE; i++) {
    8af4:	e51b304c 	ldr	r3, [fp, #-76]	; 0xffffffb4
    8af8:	e2833001 	add	r3, r3, #1
    8afc:	e50b304c 	str	r3, [fp, #-76]	; 0xffffffb4
    8b00:	eaffffcd 	b	8a3c <_Z7programj+0x3dc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:260
                }

                // Razeni populace dle fitness funkce
                Quicksort(populations, 0, SOLUTION_SIZE - 1);
    8b04:	e24b3d4e 	sub	r3, fp, #4992	; 0x1380
    8b08:	e243303c 	sub	r3, r3, #60	; 0x3c
    8b0c:	e2433028 	sub	r3, r3, #40	; 0x28
    8b10:	e3a02063 	mov	r2, #99	; 0x63
    8b14:	e3a01000 	mov	r1, #0
    8b18:	e1a00003 	mov	r0, r3
    8b1c:	eb0002c1 	bl	9628 <_Z9QuicksortP10Parametersii>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:263


                const int SAMPLE_SIZE = 100;
    8b20:	e3a03064 	mov	r3, #100	; 0x64
    8b24:	e50b307c 	str	r3, [fp, #-124]	; 0xffffff84
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:266
                Parameters sample[SOLUTION_SIZE];

                for (int x = 0; x < SOLUTION_SIZE; x++) {
    8b28:	e3a03000 	mov	r3, #0
    8b2c:	e50b3050 	str	r3, [fp, #-80]	; 0xffffffb0
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:266 (discriminator 3)
    8b30:	e51b3050 	ldr	r3, [fp, #-80]	; 0xffffffb0
    8b34:	e3530063 	cmp	r3, #99	; 0x63
    8b38:	ca000020 	bgt	8bc0 <_Z7programj+0x560>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:267 (discriminator 2)
                    sample[x] = populations[x];
    8b3c:	e24b3a02 	sub	r3, fp, #8192	; 0x2000
    8b40:	e243303c 	sub	r3, r3, #60	; 0x3c
    8b44:	e1a01003 	mov	r1, r3
    8b48:	e51b2050 	ldr	r2, [fp, #-80]	; 0xffffffb0
    8b4c:	e1a03002 	mov	r3, r2
    8b50:	e1a03083 	lsl	r3, r3, #1
    8b54:	e0833002 	add	r3, r3, r2
    8b58:	e1a03203 	lsl	r3, r3, #4
    8b5c:	e0813003 	add	r3, r1, r3
    8b60:	e2432e66 	sub	r2, r3, #1632	; 0x660
    8b64:	e2422008 	sub	r2, r2, #8
    8b68:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    8b6c:	e243303c 	sub	r3, r3, #60	; 0x3c
    8b70:	e1a00003 	mov	r0, r3
    8b74:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    8b78:	e1a03001 	mov	r3, r1
    8b7c:	e1a03083 	lsl	r3, r3, #1
    8b80:	e0833001 	add	r3, r3, r1
    8b84:	e1a03203 	lsl	r3, r3, #4
    8b88:	e0803003 	add	r3, r0, r3
    8b8c:	e2433fea 	sub	r3, r3, #936	; 0x3a8
    8b90:	e1a0c002 	mov	ip, r2
    8b94:	e1a0e003 	mov	lr, r3
    8b98:	e8be000f 	ldm	lr!, {r0, r1, r2, r3}
    8b9c:	e8ac000f 	stmia	ip!, {r0, r1, r2, r3}
    8ba0:	e8be000f 	ldm	lr!, {r0, r1, r2, r3}
    8ba4:	e8ac000f 	stmia	ip!, {r0, r1, r2, r3}
    8ba8:	e89e000f 	ldm	lr, {r0, r1, r2, r3}
    8bac:	e88c000f 	stm	ip, {r0, r1, r2, r3}
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:266 (discriminator 2)
                for (int x = 0; x < SOLUTION_SIZE; x++) {
    8bb0:	e51b3050 	ldr	r3, [fp, #-80]	; 0xffffffb0
    8bb4:	e2833001 	add	r3, r3, #1
    8bb8:	e50b3050 	str	r3, [fp, #-80]	; 0xffffffb0
    8bbc:	eaffffdb 	b	8b30 <_Z7programj+0x4d0>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:270
                }

                for (int i = 0; i < SOLUTION_SIZE; i++) {
    8bc0:	e3a03000 	mov	r3, #0
    8bc4:	e50b3054 	str	r3, [fp, #-84]	; 0xffffffac
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:270 (discriminator 3)
    8bc8:	e51b3054 	ldr	r3, [fp, #-84]	; 0xffffffac
    8bcc:	e3530063 	cmp	r3, #99	; 0x63
    8bd0:	ca000096 	bgt	8e30 <_Z7programj+0x7d0>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:273 (discriminator 2)
                    populations[i] = (Parameters{
                            0,
                            sample[rand(trng_file, 0, SAMPLE_SIZE - 1)].a,
    8bd4:	e3a02063 	mov	r2, #99	; 0x63
    8bd8:	e3a01000 	mov	r1, #0
    8bdc:	e51b0060 	ldr	r0, [fp, #-96]	; 0xffffffa0
    8be0:	eb0001ea 	bl	9390 <_Z4randjjj>
    8be4:	e1a02000 	mov	r2, r0
    8be8:	e24b3a02 	sub	r3, fp, #8192	; 0x2000
    8bec:	e243303c 	sub	r3, r3, #60	; 0x3c
    8bf0:	e2433e66 	sub	r3, r3, #1632	; 0x660
    8bf4:	e1a01003 	mov	r1, r3
    8bf8:	e1a03002 	mov	r3, r2
    8bfc:	e1a03083 	lsl	r3, r3, #1
    8c00:	e0833002 	add	r3, r3, r2
    8c04:	e1a03203 	lsl	r3, r3, #4
    8c08:	e0813003 	add	r3, r1, r3
    8c0c:	ed938b00 	vldr	d8, [r3]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:274 (discriminator 2)
                            sample[rand(trng_file, 0, SAMPLE_SIZE - 1)].b,
    8c10:	e3a02063 	mov	r2, #99	; 0x63
    8c14:	e3a01000 	mov	r1, #0
    8c18:	e51b0060 	ldr	r0, [fp, #-96]	; 0xffffffa0
    8c1c:	eb0001db 	bl	9390 <_Z4randjjj>
    8c20:	e1a02000 	mov	r2, r0
    8c24:	e24b3a02 	sub	r3, fp, #8192	; 0x2000
    8c28:	e243303c 	sub	r3, r3, #60	; 0x3c
    8c2c:	e2433e66 	sub	r3, r3, #1632	; 0x660
    8c30:	e1a01003 	mov	r1, r3
    8c34:	e1a03002 	mov	r3, r2
    8c38:	e1a03083 	lsl	r3, r3, #1
    8c3c:	e0833002 	add	r3, r3, r2
    8c40:	e1a03203 	lsl	r3, r3, #4
    8c44:	e0813003 	add	r3, r1, r3
    8c48:	e2833008 	add	r3, r3, #8
    8c4c:	e1c380d0 	ldrd	r8, [r3]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:275 (discriminator 2)
                            sample[rand(trng_file, 0, SAMPLE_SIZE - 1)].c,
    8c50:	e3a02063 	mov	r2, #99	; 0x63
    8c54:	e3a01000 	mov	r1, #0
    8c58:	e51b0060 	ldr	r0, [fp, #-96]	; 0xffffffa0
    8c5c:	eb0001cb 	bl	9390 <_Z4randjjj>
    8c60:	e1a02000 	mov	r2, r0
    8c64:	e24b3a02 	sub	r3, fp, #8192	; 0x2000
    8c68:	e243303c 	sub	r3, r3, #60	; 0x3c
    8c6c:	e2433e66 	sub	r3, r3, #1632	; 0x660
    8c70:	e1a01003 	mov	r1, r3
    8c74:	e1a03002 	mov	r3, r2
    8c78:	e1a03083 	lsl	r3, r3, #1
    8c7c:	e0833002 	add	r3, r3, r2
    8c80:	e1a03203 	lsl	r3, r3, #4
    8c84:	e0813003 	add	r3, r1, r3
    8c88:	e2833010 	add	r3, r3, #16
    8c8c:	e1c360d0 	ldrd	r6, [r3]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:276 (discriminator 2)
                            sample[rand(trng_file, 0, SAMPLE_SIZE - 1)].d,
    8c90:	e3a02063 	mov	r2, #99	; 0x63
    8c94:	e3a01000 	mov	r1, #0
    8c98:	e51b0060 	ldr	r0, [fp, #-96]	; 0xffffffa0
    8c9c:	eb0001bb 	bl	9390 <_Z4randjjj>
    8ca0:	e1a02000 	mov	r2, r0
    8ca4:	e24b3a02 	sub	r3, fp, #8192	; 0x2000
    8ca8:	e243303c 	sub	r3, r3, #60	; 0x3c
    8cac:	e2433e66 	sub	r3, r3, #1632	; 0x660
    8cb0:	e1a01003 	mov	r1, r3
    8cb4:	e1a03002 	mov	r3, r2
    8cb8:	e1a03083 	lsl	r3, r3, #1
    8cbc:	e0833002 	add	r3, r3, r2
    8cc0:	e1a03203 	lsl	r3, r3, #4
    8cc4:	e0813003 	add	r3, r1, r3
    8cc8:	e2833018 	add	r3, r3, #24
    8ccc:	e1c340d0 	ldrd	r4, [r3]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:277 (discriminator 2)
                            sample[rand(trng_file, 0, SAMPLE_SIZE - 1)].e,
    8cd0:	e3a02063 	mov	r2, #99	; 0x63
    8cd4:	e3a01000 	mov	r1, #0
    8cd8:	e51b0060 	ldr	r0, [fp, #-96]	; 0xffffffa0
    8cdc:	eb0001ab 	bl	9390 <_Z4randjjj>
    8ce0:	e1a02000 	mov	r2, r0
    8ce4:	e24b3a02 	sub	r3, fp, #8192	; 0x2000
    8ce8:	e243303c 	sub	r3, r3, #60	; 0x3c
    8cec:	e2433e66 	sub	r3, r3, #1632	; 0x660
    8cf0:	e1a01003 	mov	r1, r3
    8cf4:	e1a03002 	mov	r3, r2
    8cf8:	e1a03083 	lsl	r3, r3, #1
    8cfc:	e0833002 	add	r3, r3, r2
    8d00:	e1a03203 	lsl	r3, r3, #4
    8d04:	e0813003 	add	r3, r1, r3
    8d08:	e2833020 	add	r3, r3, #32
    8d0c:	e1c300d0 	ldrd	r0, [r3]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:271 (discriminator 2)
                    populations[i] = (Parameters{
    8d10:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    8d14:	e243303c 	sub	r3, r3, #60	; 0x3c
    8d18:	e1a0c003 	mov	ip, r3
    8d1c:	e51b2054 	ldr	r2, [fp, #-84]	; 0xffffffac
    8d20:	e1a03002 	mov	r3, r2
    8d24:	e1a03083 	lsl	r3, r3, #1
    8d28:	e0833002 	add	r3, r3, r2
    8d2c:	e1a03203 	lsl	r3, r3, #4
    8d30:	e08c3003 	add	r3, ip, r3
    8d34:	e243cfea 	sub	ip, r3, #936	; 0x3a8
    8d38:	e3a02000 	mov	r2, #0
    8d3c:	e3a03000 	mov	r3, #0
    8d40:	e1cc20f0 	strd	r2, [ip]
    8d44:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    8d48:	e243303c 	sub	r3, r3, #60	; 0x3c
    8d4c:	e1a0c003 	mov	ip, r3
    8d50:	e51b2054 	ldr	r2, [fp, #-84]	; 0xffffffac
    8d54:	e1a03002 	mov	r3, r2
    8d58:	e1a03083 	lsl	r3, r3, #1
    8d5c:	e0833002 	add	r3, r3, r2
    8d60:	e1a03203 	lsl	r3, r3, #4
    8d64:	e08c3003 	add	r3, ip, r3
    8d68:	e2433e3a 	sub	r3, r3, #928	; 0x3a0
    8d6c:	ed838b00 	vstr	d8, [r3]
    8d70:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    8d74:	e243303c 	sub	r3, r3, #60	; 0x3c
    8d78:	e1a0c003 	mov	ip, r3
    8d7c:	e51b2054 	ldr	r2, [fp, #-84]	; 0xffffffac
    8d80:	e1a03002 	mov	r3, r2
    8d84:	e1a03083 	lsl	r3, r3, #1
    8d88:	e0833002 	add	r3, r3, r2
    8d8c:	e1a03203 	lsl	r3, r3, #4
    8d90:	e08c3003 	add	r3, ip, r3
    8d94:	e2433fe6 	sub	r3, r3, #920	; 0x398
    8d98:	e1c380f0 	strd	r8, [r3]
    8d9c:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    8da0:	e243303c 	sub	r3, r3, #60	; 0x3c
    8da4:	e1a0c003 	mov	ip, r3
    8da8:	e51b2054 	ldr	r2, [fp, #-84]	; 0xffffffac
    8dac:	e1a03002 	mov	r3, r2
    8db0:	e1a03083 	lsl	r3, r3, #1
    8db4:	e0833002 	add	r3, r3, r2
    8db8:	e1a03203 	lsl	r3, r3, #4
    8dbc:	e08c3003 	add	r3, ip, r3
    8dc0:	e2433e39 	sub	r3, r3, #912	; 0x390
    8dc4:	e1c360f0 	strd	r6, [r3]
    8dc8:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    8dcc:	e243303c 	sub	r3, r3, #60	; 0x3c
    8dd0:	e1a0c003 	mov	ip, r3
    8dd4:	e51b2054 	ldr	r2, [fp, #-84]	; 0xffffffac
    8dd8:	e1a03002 	mov	r3, r2
    8ddc:	e1a03083 	lsl	r3, r3, #1
    8de0:	e0833002 	add	r3, r3, r2
    8de4:	e1a03203 	lsl	r3, r3, #4
    8de8:	e08c3003 	add	r3, ip, r3
    8dec:	e2433fe2 	sub	r3, r3, #904	; 0x388
    8df0:	e1c340f0 	strd	r4, [r3]
    8df4:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    8df8:	e243303c 	sub	r3, r3, #60	; 0x3c
    8dfc:	e1a0c003 	mov	ip, r3
    8e00:	e51b2054 	ldr	r2, [fp, #-84]	; 0xffffffac
    8e04:	e1a03002 	mov	r3, r2
    8e08:	e1a03083 	lsl	r3, r3, #1
    8e0c:	e0833002 	add	r3, r3, r2
    8e10:	e1a03203 	lsl	r3, r3, #4
    8e14:	e08c3003 	add	r3, ip, r3
    8e18:	e2433d0e 	sub	r3, r3, #896	; 0x380
    8e1c:	e1c300f0 	strd	r0, [r3]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:270 (discriminator 2)
                for (int i = 0; i < SOLUTION_SIZE; i++) {
    8e20:	e51b3054 	ldr	r3, [fp, #-84]	; 0xffffffac
    8e24:	e2833001 	add	r3, r3, #1
    8e28:	e50b3054 	str	r3, [fp, #-84]	; 0xffffffac
    8e2c:	eaffff65 	b	8bc8 <_Z7programj+0x568>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:282
                    });
                }

                // Mutace populace
                for (int j = 0; j < SOLUTION_SIZE; ++j) {
    8e30:	e3a03000 	mov	r3, #0
    8e34:	e50b3058 	str	r3, [fp, #-88]	; 0xffffffa8
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:282 (discriminator 3)
    8e38:	e51b3058 	ldr	r3, [fp, #-88]	; 0xffffffa8
    8e3c:	e3530063 	cmp	r3, #99	; 0x63
    8e40:	ca00009e 	bgt	90c0 <_Z7programj+0xa60>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:283 (discriminator 2)
                    (populations[j]).a *= (rand(trng_file, 99, 101) / 100.0);
    8e44:	e3a02065 	mov	r2, #101	; 0x65
    8e48:	e3a01063 	mov	r1, #99	; 0x63
    8e4c:	e51b0060 	ldr	r0, [fp, #-96]	; 0xffffffa0
    8e50:	eb00014e 	bl	9390 <_Z4randjjj>
    8e54:	ee070a90 	vmov	s15, r0
    8e58:	eeb87b67 	vcvt.f64.u32	d7, s15
    8e5c:	ed9f5bcb 	vldr	d5, [pc, #812]	; 9190 <_Z7programj+0xb30>
    8e60:	ee876b05 	vdiv.f64	d6, d7, d5
    8e64:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    8e68:	e243303c 	sub	r3, r3, #60	; 0x3c
    8e6c:	e1a01003 	mov	r1, r3
    8e70:	e51b2058 	ldr	r2, [fp, #-88]	; 0xffffffa8
    8e74:	e1a03002 	mov	r3, r2
    8e78:	e1a03083 	lsl	r3, r3, #1
    8e7c:	e0833002 	add	r3, r3, r2
    8e80:	e1a03203 	lsl	r3, r3, #4
    8e84:	e0813003 	add	r3, r1, r3
    8e88:	e2433e3a 	sub	r3, r3, #928	; 0x3a0
    8e8c:	ed937b00 	vldr	d7, [r3]
    8e90:	ee267b07 	vmul.f64	d7, d6, d7
    8e94:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    8e98:	e243303c 	sub	r3, r3, #60	; 0x3c
    8e9c:	e1a01003 	mov	r1, r3
    8ea0:	e51b2058 	ldr	r2, [fp, #-88]	; 0xffffffa8
    8ea4:	e1a03002 	mov	r3, r2
    8ea8:	e1a03083 	lsl	r3, r3, #1
    8eac:	e0833002 	add	r3, r3, r2
    8eb0:	e1a03203 	lsl	r3, r3, #4
    8eb4:	e0813003 	add	r3, r1, r3
    8eb8:	e2433e3a 	sub	r3, r3, #928	; 0x3a0
    8ebc:	ed837b00 	vstr	d7, [r3]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:284 (discriminator 2)
                    (populations[j]).b *= (rand(trng_file, 99, 101) / 100.0);
    8ec0:	e3a02065 	mov	r2, #101	; 0x65
    8ec4:	e3a01063 	mov	r1, #99	; 0x63
    8ec8:	e51b0060 	ldr	r0, [fp, #-96]	; 0xffffffa0
    8ecc:	eb00012f 	bl	9390 <_Z4randjjj>
    8ed0:	ee070a90 	vmov	s15, r0
    8ed4:	eeb87b67 	vcvt.f64.u32	d7, s15
    8ed8:	ed9f5bac 	vldr	d5, [pc, #688]	; 9190 <_Z7programj+0xb30>
    8edc:	ee876b05 	vdiv.f64	d6, d7, d5
    8ee0:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    8ee4:	e243303c 	sub	r3, r3, #60	; 0x3c
    8ee8:	e1a01003 	mov	r1, r3
    8eec:	e51b2058 	ldr	r2, [fp, #-88]	; 0xffffffa8
    8ef0:	e1a03002 	mov	r3, r2
    8ef4:	e1a03083 	lsl	r3, r3, #1
    8ef8:	e0833002 	add	r3, r3, r2
    8efc:	e1a03203 	lsl	r3, r3, #4
    8f00:	e0813003 	add	r3, r1, r3
    8f04:	e2433fe6 	sub	r3, r3, #920	; 0x398
    8f08:	ed937b00 	vldr	d7, [r3]
    8f0c:	ee267b07 	vmul.f64	d7, d6, d7
    8f10:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    8f14:	e243303c 	sub	r3, r3, #60	; 0x3c
    8f18:	e1a01003 	mov	r1, r3
    8f1c:	e51b2058 	ldr	r2, [fp, #-88]	; 0xffffffa8
    8f20:	e1a03002 	mov	r3, r2
    8f24:	e1a03083 	lsl	r3, r3, #1
    8f28:	e0833002 	add	r3, r3, r2
    8f2c:	e1a03203 	lsl	r3, r3, #4
    8f30:	e0813003 	add	r3, r1, r3
    8f34:	e2433fe6 	sub	r3, r3, #920	; 0x398
    8f38:	ed837b00 	vstr	d7, [r3]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:285 (discriminator 2)
                    (populations[j]).c *= (rand(trng_file, 99, 101) / 100.0);
    8f3c:	e3a02065 	mov	r2, #101	; 0x65
    8f40:	e3a01063 	mov	r1, #99	; 0x63
    8f44:	e51b0060 	ldr	r0, [fp, #-96]	; 0xffffffa0
    8f48:	eb000110 	bl	9390 <_Z4randjjj>
    8f4c:	ee070a90 	vmov	s15, r0
    8f50:	eeb87b67 	vcvt.f64.u32	d7, s15
    8f54:	ed9f5b8d 	vldr	d5, [pc, #564]	; 9190 <_Z7programj+0xb30>
    8f58:	ee876b05 	vdiv.f64	d6, d7, d5
    8f5c:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    8f60:	e243303c 	sub	r3, r3, #60	; 0x3c
    8f64:	e1a01003 	mov	r1, r3
    8f68:	e51b2058 	ldr	r2, [fp, #-88]	; 0xffffffa8
    8f6c:	e1a03002 	mov	r3, r2
    8f70:	e1a03083 	lsl	r3, r3, #1
    8f74:	e0833002 	add	r3, r3, r2
    8f78:	e1a03203 	lsl	r3, r3, #4
    8f7c:	e0813003 	add	r3, r1, r3
    8f80:	e2433e39 	sub	r3, r3, #912	; 0x390
    8f84:	ed937b00 	vldr	d7, [r3]
    8f88:	ee267b07 	vmul.f64	d7, d6, d7
    8f8c:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    8f90:	e243303c 	sub	r3, r3, #60	; 0x3c
    8f94:	e1a01003 	mov	r1, r3
    8f98:	e51b2058 	ldr	r2, [fp, #-88]	; 0xffffffa8
    8f9c:	e1a03002 	mov	r3, r2
    8fa0:	e1a03083 	lsl	r3, r3, #1
    8fa4:	e0833002 	add	r3, r3, r2
    8fa8:	e1a03203 	lsl	r3, r3, #4
    8fac:	e0813003 	add	r3, r1, r3
    8fb0:	e2433e39 	sub	r3, r3, #912	; 0x390
    8fb4:	ed837b00 	vstr	d7, [r3]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:286 (discriminator 2)
                    (populations[j]).d *= (rand(trng_file, 99, 101) / 100.0);
    8fb8:	e3a02065 	mov	r2, #101	; 0x65
    8fbc:	e3a01063 	mov	r1, #99	; 0x63
    8fc0:	e51b0060 	ldr	r0, [fp, #-96]	; 0xffffffa0
    8fc4:	eb0000f1 	bl	9390 <_Z4randjjj>
    8fc8:	ee070a90 	vmov	s15, r0
    8fcc:	eeb87b67 	vcvt.f64.u32	d7, s15
    8fd0:	ed9f5b6e 	vldr	d5, [pc, #440]	; 9190 <_Z7programj+0xb30>
    8fd4:	ee876b05 	vdiv.f64	d6, d7, d5
    8fd8:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    8fdc:	e243303c 	sub	r3, r3, #60	; 0x3c
    8fe0:	e1a01003 	mov	r1, r3
    8fe4:	e51b2058 	ldr	r2, [fp, #-88]	; 0xffffffa8
    8fe8:	e1a03002 	mov	r3, r2
    8fec:	e1a03083 	lsl	r3, r3, #1
    8ff0:	e0833002 	add	r3, r3, r2
    8ff4:	e1a03203 	lsl	r3, r3, #4
    8ff8:	e0813003 	add	r3, r1, r3
    8ffc:	e2433fe2 	sub	r3, r3, #904	; 0x388
    9000:	ed937b00 	vldr	d7, [r3]
    9004:	ee267b07 	vmul.f64	d7, d6, d7
    9008:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    900c:	e243303c 	sub	r3, r3, #60	; 0x3c
    9010:	e1a01003 	mov	r1, r3
    9014:	e51b2058 	ldr	r2, [fp, #-88]	; 0xffffffa8
    9018:	e1a03002 	mov	r3, r2
    901c:	e1a03083 	lsl	r3, r3, #1
    9020:	e0833002 	add	r3, r3, r2
    9024:	e1a03203 	lsl	r3, r3, #4
    9028:	e0813003 	add	r3, r1, r3
    902c:	e2433fe2 	sub	r3, r3, #904	; 0x388
    9030:	ed837b00 	vstr	d7, [r3]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:287 (discriminator 2)
                    (populations[j]).e *= (rand(trng_file, 99, 101) / 100.0);
    9034:	e3a02065 	mov	r2, #101	; 0x65
    9038:	e3a01063 	mov	r1, #99	; 0x63
    903c:	e51b0060 	ldr	r0, [fp, #-96]	; 0xffffffa0
    9040:	eb0000d2 	bl	9390 <_Z4randjjj>
    9044:	ee070a90 	vmov	s15, r0
    9048:	eeb87b67 	vcvt.f64.u32	d7, s15
    904c:	ed9f5b4f 	vldr	d5, [pc, #316]	; 9190 <_Z7programj+0xb30>
    9050:	ee876b05 	vdiv.f64	d6, d7, d5
    9054:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    9058:	e243303c 	sub	r3, r3, #60	; 0x3c
    905c:	e1a01003 	mov	r1, r3
    9060:	e51b2058 	ldr	r2, [fp, #-88]	; 0xffffffa8
    9064:	e1a03002 	mov	r3, r2
    9068:	e1a03083 	lsl	r3, r3, #1
    906c:	e0833002 	add	r3, r3, r2
    9070:	e1a03203 	lsl	r3, r3, #4
    9074:	e0813003 	add	r3, r1, r3
    9078:	e2433d0e 	sub	r3, r3, #896	; 0x380
    907c:	ed937b00 	vldr	d7, [r3]
    9080:	ee267b07 	vmul.f64	d7, d6, d7
    9084:	e24b3a01 	sub	r3, fp, #4096	; 0x1000
    9088:	e243303c 	sub	r3, r3, #60	; 0x3c
    908c:	e1a01003 	mov	r1, r3
    9090:	e51b2058 	ldr	r2, [fp, #-88]	; 0xffffffa8
    9094:	e1a03002 	mov	r3, r2
    9098:	e1a03083 	lsl	r3, r3, #1
    909c:	e0833002 	add	r3, r3, r2
    90a0:	e1a03203 	lsl	r3, r3, #4
    90a4:	e0813003 	add	r3, r1, r3
    90a8:	e2433d0e 	sub	r3, r3, #896	; 0x380
    90ac:	ed837b00 	vstr	d7, [r3]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:282 (discriminator 2)
                for (int j = 0; j < SOLUTION_SIZE; ++j) {
    90b0:	e51b3058 	ldr	r3, [fp, #-88]	; 0xffffffa8
    90b4:	e2833001 	add	r3, r3, #1
    90b8:	e50b3058 	str	r3, [fp, #-88]	; 0xffffffa8
    90bc:	eaffff5d 	b	8e38 <_Z7programj+0x7d8>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:290
                }
                
                for (int i = 0; i < SOLUTION_SIZE; i++) {
    90c0:	e3a03000 	mov	r3, #0
    90c4:	e50b305c 	str	r3, [fp, #-92]	; 0xffffffa4
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:290 (discriminator 3)
    90c8:	e51b305c 	ldr	r3, [fp, #-92]	; 0xffffffa4
    90cc:	e3530063 	cmp	r3, #99	; 0x63
    90d0:	ca00003c 	bgt	91c8 <_Z7programj+0xb68>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:291 (discriminator 2)
                    populations[i].fitness(values[(index - (t_pred / t_delta)) % VALUE_ARRAY_SIZE], values[index]);
    90d4:	e24b2d4e 	sub	r2, fp, #4992	; 0x1380
    90d8:	e242203c 	sub	r2, r2, #60	; 0x3c
    90dc:	e2422028 	sub	r2, r2, #40	; 0x28
    90e0:	e51b105c 	ldr	r1, [fp, #-92]	; 0xffffffa4
    90e4:	e1a03001 	mov	r3, r1
    90e8:	e1a03083 	lsl	r3, r3, #1
    90ec:	e0833001 	add	r3, r3, r1
    90f0:	e1a03203 	lsl	r3, r3, #4
    90f4:	e0824003 	add	r4, r2, r3
    90f8:	e51b1068 	ldr	r1, [fp, #-104]	; 0xffffff98
    90fc:	e51b006c 	ldr	r0, [fp, #-108]	; 0xffffff94
    9100:	eb0008c0 	bl	b408 <__divsi3>
    9104:	e1a03000 	mov	r3, r0
    9108:	e1a02003 	mov	r2, r3
    910c:	e51b3044 	ldr	r3, [fp, #-68]	; 0xffffffbc
    9110:	e0431002 	sub	r1, r3, r2
    9114:	e59f30a4 	ldr	r3, [pc, #164]	; 91c0 <_Z7programj+0xb60>
    9118:	e0c32193 	smull	r2, r3, r3, r1
    911c:	e1a02243 	asr	r2, r3, #4
    9120:	e1a03fc1 	asr	r3, r1, #31
    9124:	e0422003 	sub	r2, r2, r3
    9128:	e1a03002 	mov	r3, r2
    912c:	e1a03103 	lsl	r3, r3, #2
    9130:	e0833002 	add	r3, r3, r2
    9134:	e1a03183 	lsl	r3, r3, #3
    9138:	e0412003 	sub	r2, r1, r3
    913c:	e1a03102 	lsl	r3, r2, #2
    9140:	e24b203c 	sub	r2, fp, #60	; 0x3c
    9144:	e0823003 	add	r3, r2, r3
    9148:	e24330e4 	sub	r3, r3, #228	; 0xe4
    914c:	edd37a00 	vldr	s15, [r3]
    9150:	eeb77ae7 	vcvt.f64.f32	d7, s15
    9154:	e51b3044 	ldr	r3, [fp, #-68]	; 0xffffffbc
    9158:	e1a03103 	lsl	r3, r3, #2
    915c:	e24b203c 	sub	r2, fp, #60	; 0x3c
    9160:	e0823003 	add	r3, r2, r3
    9164:	e24330e4 	sub	r3, r3, #228	; 0xe4
    9168:	edd36a00 	vldr	s13, [r3]
    916c:	eeb76ae6 	vcvt.f64.f32	d6, s13
    9170:	eeb01b46 	vmov.f64	d1, d6
    9174:	eeb00b47 	vmov.f64	d0, d7
    9178:	e1a00004 	mov	r0, r4
    917c:	eb00016f 	bl	9740 <_ZN10Parameters7fitnessEdd>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:290 (discriminator 2)
                for (int i = 0; i < SOLUTION_SIZE; i++) {
    9180:	e51b305c 	ldr	r3, [fp, #-92]	; 0xffffffa4
    9184:	e2833001 	add	r3, r3, #1
    9188:	e50b305c 	str	r3, [fp, #-92]	; 0xffffffa4
    918c:	eaffffcd 	b	90c8 <_Z7programj+0xa68>
    9190:	00000000 	andeq	r0, r0, r0
    9194:	40590000 	subsmi	r0, r9, r0
    9198:	0000bc14 	andeq	fp, r0, r4, lsl ip
    919c:	0000bc20 	andeq	fp, r0, r0, lsr #24
    91a0:	0000bc28 	andeq	fp, r0, r8, lsr #24
    91a4:	0000bc38 	andeq	fp, r0, r8, lsr ip
    91a8:	0000bc48 	andeq	fp, r0, r8, asr #24
    91ac:	0000bc50 	andeq	fp, r0, r0, asr ip
    91b0:	0000bc5c 	andeq	fp, r0, ip, asr ip
    91b4:	0000bc64 	andeq	fp, r0, r4, ror #24
    91b8:	0000bb80 	andeq	fp, r0, r0, lsl #23
    91bc:	0000bc70 	andeq	fp, r0, r0, ror ip
    91c0:	66666667 	strbtvs	r6, [r6], -r7, ror #12
    91c4:	0000bc74 	andeq	fp, r0, r4, ror ip
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:295
                }

                // Razeni populace dle fitness funkce
                Quicksort(populations, 0, SOLUTION_SIZE - 1);
    91c8:	e24b3d4e 	sub	r3, fp, #4992	; 0x1380
    91cc:	e243303c 	sub	r3, r3, #60	; 0x3c
    91d0:	e2433028 	sub	r3, r3, #40	; 0x28
    91d4:	e3a02063 	mov	r2, #99	; 0x63
    91d8:	e3a01000 	mov	r1, #0
    91dc:	e1a00003 	mov	r0, r3
    91e0:	eb000110 	bl	9628 <_Z9QuicksortP10Parametersii>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:297

                float result_value = populations[0].fitness(values[(index - (t_pred / t_delta)) % VALUE_ARRAY_SIZE],
    91e4:	e51b1068 	ldr	r1, [fp, #-104]	; 0xffffff98
    91e8:	e51b006c 	ldr	r0, [fp, #-108]	; 0xffffff94
    91ec:	eb000885 	bl	b408 <__divsi3>
    91f0:	e1a03000 	mov	r3, r0
    91f4:	e1a02003 	mov	r2, r3
    91f8:	e51b3044 	ldr	r3, [fp, #-68]	; 0xffffffbc
    91fc:	e0431002 	sub	r1, r3, r2
    9200:	e51f3048 	ldr	r3, [pc, #-72]	; 91c0 <_Z7programj+0xb60>
    9204:	e0c32193 	smull	r2, r3, r3, r1
    9208:	e1a02243 	asr	r2, r3, #4
    920c:	e1a03fc1 	asr	r3, r1, #31
    9210:	e0422003 	sub	r2, r2, r3
    9214:	e1a03002 	mov	r3, r2
    9218:	e1a03103 	lsl	r3, r3, #2
    921c:	e0833002 	add	r3, r3, r2
    9220:	e1a03183 	lsl	r3, r3, #3
    9224:	e0412003 	sub	r2, r1, r3
    9228:	e1a03102 	lsl	r3, r2, #2
    922c:	e24b203c 	sub	r2, fp, #60	; 0x3c
    9230:	e0823003 	add	r3, r2, r3
    9234:	e24330e4 	sub	r3, r3, #228	; 0xe4
    9238:	edd37a00 	vldr	s15, [r3]
    923c:	eeb77ae7 	vcvt.f64.f32	d7, s15
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:298
                                                            values[index]);
    9240:	e51b3044 	ldr	r3, [fp, #-68]	; 0xffffffbc
    9244:	e1a03103 	lsl	r3, r3, #2
    9248:	e24b203c 	sub	r2, fp, #60	; 0x3c
    924c:	e0823003 	add	r3, r2, r3
    9250:	e24330e4 	sub	r3, r3, #228	; 0xe4
    9254:	edd36a00 	vldr	s13, [r3]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:297
                float result_value = populations[0].fitness(values[(index - (t_pred / t_delta)) % VALUE_ARRAY_SIZE],
    9258:	eeb76ae6 	vcvt.f64.f32	d6, s13
    925c:	e24b3d4e 	sub	r3, fp, #4992	; 0x1380
    9260:	e243303c 	sub	r3, r3, #60	; 0x3c
    9264:	e2433028 	sub	r3, r3, #40	; 0x28
    9268:	eeb01b46 	vmov.f64	d1, d6
    926c:	eeb00b47 	vmov.f64	d0, d7
    9270:	e1a00003 	mov	r0, r3
    9274:	eb000131 	bl	9740 <_ZN10Parameters7fitnessEdd>
    9278:	eeb07b40 	vmov.f64	d7, d0
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:298
                                                            values[index]);
    927c:	eef77bc7 	vcvt.f32.f64	s15, d7
    9280:	ed4b7a20 	vstr	s15, [fp, #-128]	; 0xffffff80
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:300

                ftoa(result_value, input_buffer);
    9284:	e51b0064 	ldr	r0, [fp, #-100]	; 0xffffff9c
    9288:	ed1b0a20 	vldr	s0, [fp, #-128]	; 0xffffff80
    928c:	eb00044d 	bl	a3c8 <_Z4ftoafPc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:301
                print_float_value_line(file, "", result_value, "\n");
    9290:	e24b3a02 	sub	r3, fp, #8192	; 0x2000
    9294:	e243303c 	sub	r3, r3, #60	; 0x3c
    9298:	e51f20e8 	ldr	r2, [pc, #-232]	; 91b8 <_Z7programj+0xb58>
    929c:	ed1b0a20 	vldr	s0, [fp, #-128]	; 0xffffff80
    92a0:	e51f10ec 	ldr	r1, [pc, #-236]	; 91bc <_Z7programj+0xb5c>
    92a4:	e513066c 	ldr	r0, [r3, #-1644]	; 0xfffff994
    92a8:	ebfffc66 	bl	8448 <_Z22print_float_value_linejPKcfS0_>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:304
            }

            index = (index + 1) % VALUE_ARRAY_SIZE;
    92ac:	e51b3044 	ldr	r3, [fp, #-68]	; 0xffffffbc
    92b0:	e2832001 	add	r2, r3, #1
    92b4:	e51f30fc 	ldr	r3, [pc, #-252]	; 91c0 <_Z7programj+0xb60>
    92b8:	e0c31293 	smull	r1, r3, r3, r2
    92bc:	e1a01243 	asr	r1, r3, #4
    92c0:	e1a03fc2 	asr	r3, r2, #31
    92c4:	e0411003 	sub	r1, r1, r3
    92c8:	e1a03001 	mov	r3, r1
    92cc:	e1a03103 	lsl	r3, r3, #2
    92d0:	e0833001 	add	r3, r3, r1
    92d4:	e1a03183 	lsl	r3, r3, #3
    92d8:	e0423003 	sub	r3, r2, r3
    92dc:	e50b3044 	str	r3, [fp, #-68]	; 0xffffffbc
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:306

            continue;
    92e0:	ea000008 	b	9308 <_Z7programj+0xca8>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:310
        }

        // Vstup je nekorektni resp. neni prikaz ani hodnota
        fputs(file, "Nekorektni vstup\n");
    92e4:	e24b3a02 	sub	r3, fp, #8192	; 0x2000
    92e8:	e243303c 	sub	r3, r3, #60	; 0x3c
    92ec:	e51f1130 	ldr	r1, [pc, #-304]	; 91c4 <_Z7programj+0xb64>
    92f0:	e513066c 	ldr	r0, [r3, #-1644]	; 0xfffff994
    92f4:	ebfffbdb 	bl	8268 <_ZL5fputsjPKc>
    92f8:	eafffd75 	b	88d4 <_Z7programj+0x274>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:230
            continue;
    92fc:	e320f000 	nop	{0}
    9300:	eafffd73 	b	88d4 <_Z7programj+0x274>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:235
            continue;
    9304:	e320f000 	nop	{0}
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:311
    }
    9308:	eafffd71 	b	88d4 <_Z7programj+0x274>

0000930c <main>:
main():
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:322
 * Hlavni vstup do programu / procesu
 * @param argc
 * @param argv
 * @return
 */
int main(int argc, char **argv) {
    930c:	e92d4800 	push	{fp, lr}
    9310:	e28db004 	add	fp, sp, #4
    9314:	e24dd018 	sub	sp, sp, #24
    9318:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    931c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:323
    uint32_t uart_file = open("DEV:uart/0", NFile_Open_Mode::Read_Write);
    9320:	e3a01002 	mov	r1, #2
    9324:	e59f0054 	ldr	r0, [pc, #84]	; 9380 <main+0x74>
    9328:	eb000204 	bl	9b40 <_Z4openPKc15NFile_Open_Mode>
    932c:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:325
    TUART_IOCtl_Params params;
    params.baud_rate = NUART_Baud_Rate::BR_115200;
    9330:	e59f304c 	ldr	r3, [pc, #76]	; 9384 <main+0x78>
    9334:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:326
    params.char_length = NUART_Char_Length::Char_8;
    9338:	e3a03001 	mov	r3, #1
    933c:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:327
    ioctl(uart_file, NIOCtl_Operation::Set_Params, &params);
    9340:	e24b3010 	sub	r3, fp, #16
    9344:	e1a02003 	mov	r2, r3
    9348:	e3a01001 	mov	r1, #1
    934c:	e51b0008 	ldr	r0, [fp, #-8]
    9350:	eb00023e 	bl	9c50 <_Z5ioctlj16NIOCtl_OperationPv>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:329

    fputs(uart_file,
    9354:	e59f102c 	ldr	r1, [pc, #44]	; 9388 <main+0x7c>
    9358:	e51b0008 	ldr	r0, [fp, #-8]
    935c:	ebfffbc1 	bl	8268 <_ZL5fputsjPKc>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:334
          "CalcOS v1.0\nAutor: Jan Hinterholzinger (A22N0045P)\n"
          "Zadejte nejprve casovy rozestup a predikcni okenko v minutach\n"
          "Dale podporovany prikazy: stop, parameters\n");

    circBuffer.Claim();
    9360:	e59f0024 	ldr	r0, [pc, #36]	; 938c <main+0x80>
    9364:	eb000144 	bl	987c <_ZN6Buffer5ClaimEv>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:337

    // Spusteni podprogramu s vypoctem
    program(uart_file);
    9368:	e51b0008 	ldr	r0, [fp, #-8]
    936c:	ebfffcbb 	bl	8660 <_Z7programj>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:339

    return 0;
    9370:	e3a03000 	mov	r3, #0
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:340
}
    9374:	e1a00003 	mov	r0, r3
    9378:	e24bd004 	sub	sp, fp, #4
    937c:	e8bd8800 	pop	{fp, pc}
    9380:	0000bc88 	andeq	fp, r0, r8, lsl #25
    9384:	0001c200 	andeq	ip, r1, r0, lsl #4
    9388:	0000bc94 	muleq	r0, r4, ip
    938c:	0000bdd8 	ldrdeq	fp, [r0], -r8

00009390 <_Z4randjjj>:
_Z4randjjj():
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:349
 * @param file
 * @param output_start
 * @param output_end
 * @return
 */
unsigned int rand(uint32_t file, uint32_t output_start, uint32_t output_end) {
    9390:	e92d4800 	push	{fp, lr}
    9394:	e28db004 	add	fp, sp, #4
    9398:	e24dd028 	sub	sp, sp, #40	; 0x28
    939c:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    93a0:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
    93a4:	e50b2028 	str	r2, [fp, #-40]	; 0xffffffd8
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:350
    uint32_t input_start = 0;
    93a8:	e3a03000 	mov	r3, #0
    93ac:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:351
    uint32_t input_end = 4294967295;
    93b0:	e3e03000 	mvn	r3, #0
    93b4:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:353

    uint32_t num = 0;
    93b8:	e3a03000 	mov	r3, #0
    93bc:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:354
    read(file, reinterpret_cast<char *>(&num), sizeof(num));
    93c0:	e24b3018 	sub	r3, fp, #24
    93c4:	e3a02004 	mov	r2, #4
    93c8:	e1a01003 	mov	r1, r3
    93cc:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    93d0:	eb0001eb 	bl	9b84 <_Z4readjPcj>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:355
    double slope = 1.0 * (output_end - output_start) / (input_end - input_start);
    93d4:	e51b2028 	ldr	r2, [fp, #-40]	; 0xffffffd8
    93d8:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    93dc:	e0423003 	sub	r3, r2, r3
    93e0:	ee073a90 	vmov	s15, r3
    93e4:	eeb85b67 	vcvt.f64.u32	d5, s15
    93e8:	e51b200c 	ldr	r2, [fp, #-12]
    93ec:	e51b3008 	ldr	r3, [fp, #-8]
    93f0:	e0423003 	sub	r3, r2, r3
    93f4:	ee073a90 	vmov	s15, r3
    93f8:	eeb86b67 	vcvt.f64.u32	d6, s15
    93fc:	ee857b06 	vdiv.f64	d7, d5, d6
    9400:	ed0b7b05 	vstr	d7, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:356
    return output_start + slope * (num - input_start);
    9404:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    9408:	ee073a90 	vmov	s15, r3
    940c:	eeb86b67 	vcvt.f64.u32	d6, s15
    9410:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9414:	e51b3008 	ldr	r3, [fp, #-8]
    9418:	e0423003 	sub	r3, r2, r3
    941c:	ee073a90 	vmov	s15, r3
    9420:	eeb85b67 	vcvt.f64.u32	d5, s15
    9424:	ed1b7b05 	vldr	d7, [fp, #-20]	; 0xffffffec
    9428:	ee257b07 	vmul.f64	d7, d5, d7
    942c:	ee367b07 	vadd.f64	d7, d6, d7
    9430:	eefc7bc7 	vcvt.u32.f64	s15, d7
    9434:	ee173a90 	vmov	r3, s15
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:357
}
    9438:	e1a00003 	mov	r0, r3
    943c:	e24bd004 	sub	sp, fp, #4
    9440:	e8bd8800 	pop	{fp, pc}

00009444 <_Z9PartitionP10Parametersii>:
_Z9PartitionP10Parametersii():
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:360

// last element is taken as pivot
int Partition(Parameters v[], int start, int end) {
    9444:	e92d4800 	push	{fp, lr}
    9448:	e28db004 	add	fp, sp, #4
    944c:	e24dd020 	sub	sp, sp, #32
    9450:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    9454:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    9458:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:362

    int pivot = end;
    945c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    9460:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:363
    int j = start;
    9464:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9468:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:364
    for (int i = start; i < end; i++) {
    946c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9470:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:364 (discriminator 1)
    9474:	e51b200c 	ldr	r2, [fp, #-12]
    9478:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    947c:	e1520003 	cmp	r2, r3
    9480:	aa00001f 	bge	9504 <_Z9PartitionP10Parametersii+0xc0>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:365
        if (v[i].rank < v[pivot].rank) {
    9484:	e51b200c 	ldr	r2, [fp, #-12]
    9488:	e1a03002 	mov	r3, r2
    948c:	e1a03083 	lsl	r3, r3, #1
    9490:	e0833002 	add	r3, r3, r2
    9494:	e1a03203 	lsl	r3, r3, #4
    9498:	e1a02003 	mov	r2, r3
    949c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    94a0:	e0833002 	add	r3, r3, r2
    94a4:	ed936b00 	vldr	d6, [r3]
    94a8:	e51b2010 	ldr	r2, [fp, #-16]
    94ac:	e1a03002 	mov	r3, r2
    94b0:	e1a03083 	lsl	r3, r3, #1
    94b4:	e0833002 	add	r3, r3, r2
    94b8:	e1a03203 	lsl	r3, r3, #4
    94bc:	e1a02003 	mov	r2, r3
    94c0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    94c4:	e0833002 	add	r3, r3, r2
    94c8:	ed937b00 	vldr	d7, [r3]
    94cc:	eeb46bc7 	vcmpe.f64	d6, d7
    94d0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    94d4:	5a000006 	bpl	94f4 <_Z9PartitionP10Parametersii+0xb0>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:366
            swap(v, i, j);
    94d8:	e51b2008 	ldr	r2, [fp, #-8]
    94dc:	e51b100c 	ldr	r1, [fp, #-12]
    94e0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    94e4:	eb00000e 	bl	9524 <_Z4swapP10Parametersii>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:367
            ++j;
    94e8:	e51b3008 	ldr	r3, [fp, #-8]
    94ec:	e2833001 	add	r3, r3, #1
    94f0:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:364 (discriminator 2)
    for (int i = start; i < end; i++) {
    94f4:	e51b300c 	ldr	r3, [fp, #-12]
    94f8:	e2833001 	add	r3, r3, #1
    94fc:	e50b300c 	str	r3, [fp, #-12]
    9500:	eaffffdb 	b	9474 <_Z9PartitionP10Parametersii+0x30>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:370
        }
    }
    swap(v, j, pivot);
    9504:	e51b2010 	ldr	r2, [fp, #-16]
    9508:	e51b1008 	ldr	r1, [fp, #-8]
    950c:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9510:	eb000003 	bl	9524 <_Z4swapP10Parametersii>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:371
    return j;
    9514:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:373

}
    9518:	e1a00003 	mov	r0, r3
    951c:	e24bd004 	sub	sp, fp, #4
    9520:	e8bd8800 	pop	{fp, pc}

00009524 <_Z4swapP10Parametersii>:
_Z4swapP10Parametersii():
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:375

void swap(Parameters arr[], int pos1, int pos2) {
    9524:	e92d4800 	push	{fp, lr}
    9528:	e28db004 	add	fp, sp, #4
    952c:	e24dd040 	sub	sp, sp, #64	; 0x40
    9530:	e50b0038 	str	r0, [fp, #-56]	; 0xffffffc8
    9534:	e50b103c 	str	r1, [fp, #-60]	; 0xffffffc4
    9538:	e50b2040 	str	r2, [fp, #-64]	; 0xffffffc0
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:376
    Parameters temp = arr[pos1];
    953c:	e51b203c 	ldr	r2, [fp, #-60]	; 0xffffffc4
    9540:	e1a03002 	mov	r3, r2
    9544:	e1a03083 	lsl	r3, r3, #1
    9548:	e0833002 	add	r3, r3, r2
    954c:	e1a03203 	lsl	r3, r3, #4
    9550:	e1a02003 	mov	r2, r3
    9554:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9558:	e0833002 	add	r3, r3, r2
    955c:	e24bc034 	sub	ip, fp, #52	; 0x34
    9560:	e1a0e003 	mov	lr, r3
    9564:	e8be000f 	ldm	lr!, {r0, r1, r2, r3}
    9568:	e8ac000f 	stmia	ip!, {r0, r1, r2, r3}
    956c:	e8be000f 	ldm	lr!, {r0, r1, r2, r3}
    9570:	e8ac000f 	stmia	ip!, {r0, r1, r2, r3}
    9574:	e89e000f 	ldm	lr, {r0, r1, r2, r3}
    9578:	e88c000f 	stm	ip, {r0, r1, r2, r3}
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:377
    arr[pos1] = arr[pos2];
    957c:	e51b2040 	ldr	r2, [fp, #-64]	; 0xffffffc0
    9580:	e1a03002 	mov	r3, r2
    9584:	e1a03083 	lsl	r3, r3, #1
    9588:	e0833002 	add	r3, r3, r2
    958c:	e1a03203 	lsl	r3, r3, #4
    9590:	e1a02003 	mov	r2, r3
    9594:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9598:	e0831002 	add	r1, r3, r2
    959c:	e51b203c 	ldr	r2, [fp, #-60]	; 0xffffffc4
    95a0:	e1a03002 	mov	r3, r2
    95a4:	e1a03083 	lsl	r3, r3, #1
    95a8:	e0833002 	add	r3, r3, r2
    95ac:	e1a03203 	lsl	r3, r3, #4
    95b0:	e1a02003 	mov	r2, r3
    95b4:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    95b8:	e0833002 	add	r3, r3, r2
    95bc:	e1a0c003 	mov	ip, r3
    95c0:	e1a0e001 	mov	lr, r1
    95c4:	e8be000f 	ldm	lr!, {r0, r1, r2, r3}
    95c8:	e8ac000f 	stmia	ip!, {r0, r1, r2, r3}
    95cc:	e8be000f 	ldm	lr!, {r0, r1, r2, r3}
    95d0:	e8ac000f 	stmia	ip!, {r0, r1, r2, r3}
    95d4:	e89e000f 	ldm	lr, {r0, r1, r2, r3}
    95d8:	e88c000f 	stm	ip, {r0, r1, r2, r3}
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:378
    arr[pos2] = temp;
    95dc:	e51b2040 	ldr	r2, [fp, #-64]	; 0xffffffc0
    95e0:	e1a03002 	mov	r3, r2
    95e4:	e1a03083 	lsl	r3, r3, #1
    95e8:	e0833002 	add	r3, r3, r2
    95ec:	e1a03203 	lsl	r3, r3, #4
    95f0:	e1a02003 	mov	r2, r3
    95f4:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    95f8:	e0833002 	add	r3, r3, r2
    95fc:	e1a0e003 	mov	lr, r3
    9600:	e24bc034 	sub	ip, fp, #52	; 0x34
    9604:	e8bc000f 	ldm	ip!, {r0, r1, r2, r3}
    9608:	e8ae000f 	stmia	lr!, {r0, r1, r2, r3}
    960c:	e8bc000f 	ldm	ip!, {r0, r1, r2, r3}
    9610:	e8ae000f 	stmia	lr!, {r0, r1, r2, r3}
    9614:	e89c000f 	ldm	ip, {r0, r1, r2, r3}
    9618:	e88e000f 	stm	lr, {r0, r1, r2, r3}
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:379
}
    961c:	e320f000 	nop	{0}
    9620:	e24bd004 	sub	sp, fp, #4
    9624:	e8bd8800 	pop	{fp, pc}

00009628 <_Z9QuicksortP10Parametersii>:
_Z9QuicksortP10Parametersii():
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:387
 * Implementace QuickSortu pro razeni populaci dle fitness funkce
 * @param v
 * @param start
 * @param end
 */
void Quicksort(Parameters v[], int start, int end) {
    9628:	e92d4800 	push	{fp, lr}
    962c:	e28db004 	add	fp, sp, #4
    9630:	e24dd018 	sub	sp, sp, #24
    9634:	e50b0010 	str	r0, [fp, #-16]
    9638:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    963c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:388
    if (start < end) {
    9640:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    9644:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9648:	e1520003 	cmp	r2, r3
    964c:	aa000010 	bge	9694 <_Z9QuicksortP10Parametersii+0x6c>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:389
        int p = Partition(v, start, end);
    9650:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9654:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    9658:	e51b0010 	ldr	r0, [fp, #-16]
    965c:	ebffff78 	bl	9444 <_Z9PartitionP10Parametersii>
    9660:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:390
        Quicksort(v, start, p - 1);
    9664:	e51b3008 	ldr	r3, [fp, #-8]
    9668:	e2433001 	sub	r3, r3, #1
    966c:	e1a02003 	mov	r2, r3
    9670:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    9674:	e51b0010 	ldr	r0, [fp, #-16]
    9678:	ebffffea 	bl	9628 <_Z9QuicksortP10Parametersii>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:391
        Quicksort(v, p + 1, end);
    967c:	e51b3008 	ldr	r3, [fp, #-8]
    9680:	e2833001 	add	r3, r3, #1
    9684:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    9688:	e1a01003 	mov	r1, r3
    968c:	e51b0010 	ldr	r0, [fp, #-16]
    9690:	ebffffe4 	bl	9628 <_Z9QuicksortP10Parametersii>
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:393
    }
}
    9694:	e320f000 	nop	{0}
    9698:	e24bd004 	sub	sp, fp, #4
    969c:	e8bd8800 	pop	{fp, pc}

000096a0 <_Znaj>:
_Znaj():
/home/hintik/dev/final/src/sources/userspace/../stdlib/include/stdmemory.h:45
{
    return sUserHeap.Alloc(size);
}

inline void* operator new[](uint32_t size)
{
    96a0:	e92d4800 	push	{fp, lr}
    96a4:	e28db004 	add	fp, sp, #4
    96a8:	e24dd008 	sub	sp, sp, #8
    96ac:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/final/src/sources/userspace/../stdlib/include/stdmemory.h:46
    return sUserHeap.Alloc(size);
    96b0:	e51b1008 	ldr	r1, [fp, #-8]
    96b4:	e59f0010 	ldr	r0, [pc, #16]	; 96cc <_Znaj+0x2c>
    96b8:	eb0002a7 	bl	a15c <_ZN12CUserHeapMan5AllocEj>
    96bc:	e1a03000 	mov	r3, r0
/home/hintik/dev/final/src/sources/userspace/../stdlib/include/stdmemory.h:47
}
    96c0:	e1a00003 	mov	r0, r3
    96c4:	e24bd004 	sub	sp, fp, #4
    96c8:	e8bd8800 	pop	{fp, pc}
    96cc:	0000bee4 	andeq	fp, r0, r4, ror #29

000096d0 <_ZN10Parameters2btEd>:
_ZN10Parameters2btEd():
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:32
    double bt(double y) {
    96d0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    96d4:	e28db000 	add	fp, sp, #0
    96d8:	e24dd014 	sub	sp, sp, #20
    96dc:	e50b0008 	str	r0, [fp, #-8]
    96e0:	ed0b0b05 	vstr	d0, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:33
        return d / e * (1.0 / (24.0 * 60.0 * 60.0)) + 1 / e * y;
    96e4:	e51b3008 	ldr	r3, [fp, #-8]
    96e8:	ed935b08 	vldr	d5, [r3, #32]
    96ec:	e51b3008 	ldr	r3, [fp, #-8]
    96f0:	ed936b0a 	vldr	d6, [r3, #40]	; 0x28
    96f4:	ee857b06 	vdiv.f64	d7, d5, d6
    96f8:	ed9f6b0c 	vldr	d6, [pc, #48]	; 9730 <_ZN10Parameters2btEd+0x60>
    96fc:	ee276b06 	vmul.f64	d6, d7, d6
    9700:	e51b3008 	ldr	r3, [fp, #-8]
    9704:	ed937b0a 	vldr	d7, [r3, #40]	; 0x28
    9708:	ed9f4b0a 	vldr	d4, [pc, #40]	; 9738 <_ZN10Parameters2btEd+0x68>
    970c:	ee845b07 	vdiv.f64	d5, d4, d7
    9710:	ed1b7b05 	vldr	d7, [fp, #-20]	; 0xffffffec
    9714:	ee257b07 	vmul.f64	d7, d5, d7
    9718:	ee367b07 	vadd.f64	d7, d6, d7
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:34
    }
    971c:	eeb00b47 	vmov.f64	d0, d7
    9720:	e28bd000 	add	sp, fp, #0
    9724:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9728:	e12fff1e 	bx	lr
    972c:	e320f000 	nop	{0}
    9730:	a0ce5129 	sbcge	r5, lr, r9, lsr #2
    9734:	3ee845c8 	cdpcc	5, 14, cr4, cr8, cr8, {6}
    9738:	00000000 	andeq	r0, r0, r0
    973c:	3ff00000 	svccc	0x00f00000	; IMB

00009740 <_ZN10Parameters7fitnessEdd>:
_ZN10Parameters7fitnessEdd():
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:42
    double fitness(double t_pred, double y_real) {
    9740:	e92d4800 	push	{fp, lr}
    9744:	ed2d8b04 	vpush	{d8-d9}
    9748:	e28db014 	add	fp, sp, #20
    974c:	e24dd020 	sub	sp, sp, #32
    9750:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    9754:	ed0b0b0b 	vstr	d0, [fp, #-44]	; 0xffffffd4
    9758:	ed0b1b0d 	vstr	d1, [fp, #-52]	; 0xffffffcc
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:44
        double ans = bt(t_pred) * a + b * bt(t_pred) * (bt(t_pred) - t_pred) + c;
    975c:	ed1b0b0b 	vldr	d0, [fp, #-44]	; 0xffffffd4
    9760:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    9764:	ebffffd9 	bl	96d0 <_ZN10Parameters2btEd>
    9768:	eeb06b40 	vmov.f64	d6, d0
    976c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    9770:	ed937b02 	vldr	d7, [r3, #8]
    9774:	ee268b07 	vmul.f64	d8, d6, d7
    9778:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    977c:	ed939b04 	vldr	d9, [r3, #16]
    9780:	ed1b0b0b 	vldr	d0, [fp, #-44]	; 0xffffffd4
    9784:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    9788:	ebffffd0 	bl	96d0 <_ZN10Parameters2btEd>
    978c:	eeb07b40 	vmov.f64	d7, d0
    9790:	ee299b07 	vmul.f64	d9, d9, d7
    9794:	ed1b0b0b 	vldr	d0, [fp, #-44]	; 0xffffffd4
    9798:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    979c:	ebffffcb 	bl	96d0 <_ZN10Parameters2btEd>
    97a0:	eeb06b40 	vmov.f64	d6, d0
    97a4:	ed1b7b0b 	vldr	d7, [fp, #-44]	; 0xffffffd4
    97a8:	ee367b47 	vsub.f64	d7, d6, d7
    97ac:	ee297b07 	vmul.f64	d7, d9, d7
    97b0:	ee386b07 	vadd.f64	d6, d8, d7
    97b4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    97b8:	ed937b06 	vldr	d7, [r3, #24]
    97bc:	ee367b07 	vadd.f64	d7, d6, d7
    97c0:	ed0b7b07 	vstr	d7, [fp, #-28]	; 0xffffffe4
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:46
        rank = abs(ans - y_real);
    97c4:	ed1b6b07 	vldr	d6, [fp, #-28]	; 0xffffffe4
    97c8:	ed1b7b0d 	vldr	d7, [fp, #-52]	; 0xffffffcc
    97cc:	ee367b47 	vsub.f64	d7, d6, d7
    97d0:	eeb00b47 	vmov.f64	d0, d7
    97d4:	ebfffa93 	bl	8228 <_Z3absd>
    97d8:	eeb07b40 	vmov.f64	d7, d0
    97dc:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    97e0:	ed837b00 	vstr	d7, [r3]
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:48
        return ans;
    97e4:	e14b21dc 	ldrd	r2, [fp, #-28]	; 0xffffffe4
    97e8:	ec432b17 	vmov	d7, r2, r3
/home/hintik/dev/final/src/sources/userspace/user_task/main.cpp:49
    }
    97ec:	eeb00b47 	vmov.f64	d0, d7
    97f0:	e24bd014 	sub	sp, fp, #20
    97f4:	ecbd8b04 	vpop	{d8-d9}
    97f8:	e8bd8800 	pop	{fp, pc}

000097fc <_ZN6BufferC1Ev>:
_ZN6BufferC2Ev():
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:5
#include <stdbuffer.h>

Buffer circBuffer;

Buffer::Buffer()
    97fc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9800:	e28db000 	add	fp, sp, #0
    9804:	e24dd014 	sub	sp, sp, #20
    9808:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:6
    : mPushPtr(0), mPullPtr(0), mClaimed(false)
    980c:	e51b3010 	ldr	r3, [fp, #-16]
    9810:	e3a02000 	mov	r2, #0
    9814:	e5c32100 	strb	r2, [r3, #256]	; 0x100
    9818:	e51b3010 	ldr	r3, [fp, #-16]
    981c:	e3a02000 	mov	r2, #0
    9820:	e5832104 	str	r2, [r3, #260]	; 0x104
    9824:	e51b3010 	ldr	r3, [fp, #-16]
    9828:	e3a02000 	mov	r2, #0
    982c:	e5832108 	str	r2, [r3, #264]	; 0x108
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:8
{
    for(int i = 0; i < buffer_constants::BUFFER_SIZE; i++)
    9830:	e3a03000 	mov	r3, #0
    9834:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:8 (discriminator 3)
    9838:	e51b3008 	ldr	r3, [fp, #-8]
    983c:	e35300ff 	cmp	r3, #255	; 0xff
    9840:	ca000008 	bgt	9868 <_ZN6BufferC1Ev+0x6c>
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:10 (discriminator 2)
    {
        mBuffer[i] = '\0';
    9844:	e51b2010 	ldr	r2, [fp, #-16]
    9848:	e51b3008 	ldr	r3, [fp, #-8]
    984c:	e0823003 	add	r3, r2, r3
    9850:	e3a02000 	mov	r2, #0
    9854:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:8 (discriminator 2)
    for(int i = 0; i < buffer_constants::BUFFER_SIZE; i++)
    9858:	e51b3008 	ldr	r3, [fp, #-8]
    985c:	e2833001 	add	r3, r3, #1
    9860:	e50b3008 	str	r3, [fp, #-8]
    9864:	eafffff3 	b	9838 <_ZN6BufferC1Ev+0x3c>
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:12
    }
}
    9868:	e51b3010 	ldr	r3, [fp, #-16]
    986c:	e1a00003 	mov	r0, r3
    9870:	e28bd000 	add	sp, fp, #0
    9874:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9878:	e12fff1e 	bx	lr

0000987c <_ZN6Buffer5ClaimEv>:
_ZN6Buffer5ClaimEv():
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:15

bool Buffer::Claim()
{
    987c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9880:	e28db000 	add	fp, sp, #0
    9884:	e24dd00c 	sub	sp, sp, #12
    9888:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:16
    if(mClaimed)
    988c:	e51b3008 	ldr	r3, [fp, #-8]
    9890:	e5d33100 	ldrb	r3, [r3, #256]	; 0x100
    9894:	e3530000 	cmp	r3, #0
    9898:	0a000001 	beq	98a4 <_ZN6Buffer5ClaimEv+0x28>
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:17
        return false;
    989c:	e3a03000 	mov	r3, #0
    98a0:	ea000003 	b	98b4 <_ZN6Buffer5ClaimEv+0x38>
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:19
        
    mClaimed = true;
    98a4:	e51b3008 	ldr	r3, [fp, #-8]
    98a8:	e3a02001 	mov	r2, #1
    98ac:	e5c32100 	strb	r2, [r3, #256]	; 0x100
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:20
    return true;
    98b0:	e3a03001 	mov	r3, #1
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:21
}
    98b4:	e1a00003 	mov	r0, r3
    98b8:	e28bd000 	add	sp, fp, #0
    98bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    98c0:	e12fff1e 	bx	lr

000098c4 <_ZN6Buffer7ReleaseEv>:
_ZN6Buffer7ReleaseEv():
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:24

void Buffer::Release()
{
    98c4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    98c8:	e28db000 	add	fp, sp, #0
    98cc:	e24dd014 	sub	sp, sp, #20
    98d0:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:25
    for(int i = 0; i <= buffer_constants::BUFFER_SIZE; i++)
    98d4:	e3a03000 	mov	r3, #0
    98d8:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:25 (discriminator 3)
    98dc:	e51b3008 	ldr	r3, [fp, #-8]
    98e0:	e3530c01 	cmp	r3, #256	; 0x100
    98e4:	ca000008 	bgt	990c <_ZN6Buffer7ReleaseEv+0x48>
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:27 (discriminator 2)
    {
        mBuffer[i] = '\0';
    98e8:	e51b2010 	ldr	r2, [fp, #-16]
    98ec:	e51b3008 	ldr	r3, [fp, #-8]
    98f0:	e0823003 	add	r3, r2, r3
    98f4:	e3a02000 	mov	r2, #0
    98f8:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:25 (discriminator 2)
    for(int i = 0; i <= buffer_constants::BUFFER_SIZE; i++)
    98fc:	e51b3008 	ldr	r3, [fp, #-8]
    9900:	e2833001 	add	r3, r3, #1
    9904:	e50b3008 	str	r3, [fp, #-8]
    9908:	eafffff3 	b	98dc <_ZN6Buffer7ReleaseEv+0x18>
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:30
    }
    
    mClaimed = false;
    990c:	e51b3010 	ldr	r3, [fp, #-16]
    9910:	e3a02000 	mov	r2, #0
    9914:	e5c32100 	strb	r2, [r3, #256]	; 0x100
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:31
}
    9918:	e320f000 	nop	{0}
    991c:	e28bd000 	add	sp, fp, #0
    9920:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9924:	e12fff1e 	bx	lr

00009928 <_ZN6Buffer13GetDifferenceEv>:
_ZN6Buffer13GetDifferenceEv():
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:34

int Buffer::GetDifference()
{
    9928:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    992c:	e28db000 	add	fp, sp, #0
    9930:	e24dd00c 	sub	sp, sp, #12
    9934:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:35
    return mPushPtr-mPullPtr;
    9938:	e51b3008 	ldr	r3, [fp, #-8]
    993c:	e5932104 	ldr	r2, [r3, #260]	; 0x104
    9940:	e51b3008 	ldr	r3, [fp, #-8]
    9944:	e5933108 	ldr	r3, [r3, #264]	; 0x108
    9948:	e0423003 	sub	r3, r2, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:36
}
    994c:	e1a00003 	mov	r0, r3
    9950:	e28bd000 	add	sp, fp, #0
    9954:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9958:	e12fff1e 	bx	lr

0000995c <_ZN6Buffer4PushEc>:
_ZN6Buffer4PushEc():
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:39

void Buffer::Push(char c)
{
    995c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9960:	e28db000 	add	fp, sp, #0
    9964:	e24dd00c 	sub	sp, sp, #12
    9968:	e50b0008 	str	r0, [fp, #-8]
    996c:	e1a03001 	mov	r3, r1
    9970:	e54b3009 	strb	r3, [fp, #-9]
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:40
    mBuffer[mPushPtr] = c;
    9974:	e51b3008 	ldr	r3, [fp, #-8]
    9978:	e5933104 	ldr	r3, [r3, #260]	; 0x104
    997c:	e51b2008 	ldr	r2, [fp, #-8]
    9980:	e55b1009 	ldrb	r1, [fp, #-9]
    9984:	e7c21003 	strb	r1, [r2, r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:41
    mPushPtr = (mPushPtr + 1) % buffer_constants::BUFFER_SIZE;
    9988:	e51b3008 	ldr	r3, [fp, #-8]
    998c:	e5933104 	ldr	r3, [r3, #260]	; 0x104
    9990:	e2833001 	add	r3, r3, #1
    9994:	e2732000 	rsbs	r2, r3, #0
    9998:	e6ef3073 	uxtb	r3, r3
    999c:	e6ef2072 	uxtb	r2, r2
    99a0:	52623000 	rsbpl	r3, r2, #0
    99a4:	e51b2008 	ldr	r2, [fp, #-8]
    99a8:	e5823104 	str	r3, [r2, #260]	; 0x104
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:42
}
    99ac:	e320f000 	nop	{0}
    99b0:	e28bd000 	add	sp, fp, #0
    99b4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    99b8:	e12fff1e 	bx	lr

000099bc <_ZN6Buffer4PullEv>:
_ZN6Buffer4PullEv():
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:45

char Buffer::Pull()
{
    99bc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    99c0:	e28db000 	add	fp, sp, #0
    99c4:	e24dd014 	sub	sp, sp, #20
    99c8:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:46
    if(mPullPtr == mPushPtr)
    99cc:	e51b3010 	ldr	r3, [fp, #-16]
    99d0:	e5932108 	ldr	r2, [r3, #264]	; 0x108
    99d4:	e51b3010 	ldr	r3, [fp, #-16]
    99d8:	e5933104 	ldr	r3, [r3, #260]	; 0x104
    99dc:	e1520003 	cmp	r2, r3
    99e0:	1a000001 	bne	99ec <_ZN6Buffer4PullEv+0x30>
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:47
        return '\0';
    99e4:	e3a03000 	mov	r3, #0
    99e8:	ea00000e 	b	9a28 <_ZN6Buffer4PullEv+0x6c>
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:49
    char ret;
    ret = mBuffer[mPullPtr];
    99ec:	e51b3010 	ldr	r3, [fp, #-16]
    99f0:	e5933108 	ldr	r3, [r3, #264]	; 0x108
    99f4:	e51b2010 	ldr	r2, [fp, #-16]
    99f8:	e7d23003 	ldrb	r3, [r2, r3]
    99fc:	e54b3005 	strb	r3, [fp, #-5]
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:50
    mPullPtr = (mPullPtr + 1) % buffer_constants::BUFFER_SIZE;    
    9a00:	e51b3010 	ldr	r3, [fp, #-16]
    9a04:	e5933108 	ldr	r3, [r3, #264]	; 0x108
    9a08:	e2833001 	add	r3, r3, #1
    9a0c:	e2732000 	rsbs	r2, r3, #0
    9a10:	e6ef3073 	uxtb	r3, r3
    9a14:	e6ef2072 	uxtb	r2, r2
    9a18:	52623000 	rsbpl	r3, r2, #0
    9a1c:	e51b2010 	ldr	r2, [fp, #-16]
    9a20:	e5823108 	str	r3, [r2, #264]	; 0x108
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:51
    return ret;
    9a24:	e55b3005 	ldrb	r3, [fp, #-5]
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:52
}
    9a28:	e1a00003 	mov	r0, r3
    9a2c:	e28bd000 	add	sp, fp, #0
    9a30:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9a34:	e12fff1e 	bx	lr

00009a38 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:52
    9a38:	e92d4800 	push	{fp, lr}
    9a3c:	e28db004 	add	fp, sp, #4
    9a40:	e24dd008 	sub	sp, sp, #8
    9a44:	e50b0008 	str	r0, [fp, #-8]
    9a48:	e50b100c 	str	r1, [fp, #-12]
    9a4c:	e51b3008 	ldr	r3, [fp, #-8]
    9a50:	e3530001 	cmp	r3, #1
    9a54:	1a000005 	bne	9a70 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:52 (discriminator 1)
    9a58:	e51b300c 	ldr	r3, [fp, #-12]
    9a5c:	e59f2018 	ldr	r2, [pc, #24]	; 9a7c <_Z41__static_initialization_and_destruction_0ii+0x44>
    9a60:	e1530002 	cmp	r3, r2
    9a64:	1a000001 	bne	9a70 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:3
Buffer circBuffer;
    9a68:	e59f0010 	ldr	r0, [pc, #16]	; 9a80 <_Z41__static_initialization_and_destruction_0ii+0x48>
    9a6c:	ebffff62 	bl	97fc <_ZN6BufferC1Ev>
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:52
}
    9a70:	e320f000 	nop	{0}
    9a74:	e24bd004 	sub	sp, fp, #4
    9a78:	e8bd8800 	pop	{fp, pc}
    9a7c:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    9a80:	0000bdd8 	ldrdeq	fp, [r0], -r8

00009a84 <_GLOBAL__sub_I_circBuffer>:
_GLOBAL__sub_I_circBuffer():
/home/hintik/dev/final/src/sources/stdlib/src/stdbuffer.cpp:52
    9a84:	e92d4800 	push	{fp, lr}
    9a88:	e28db004 	add	fp, sp, #4
    9a8c:	e59f1008 	ldr	r1, [pc, #8]	; 9a9c <_GLOBAL__sub_I_circBuffer+0x18>
    9a90:	e3a00001 	mov	r0, #1
    9a94:	ebffffe7 	bl	9a38 <_Z41__static_initialization_and_destruction_0ii>
    9a98:	e8bd8800 	pop	{fp, pc}
    9a9c:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00009aa0 <_Z6getpidv>:
_Z6getpidv():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    9aa0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9aa4:	e28db000 	add	fp, sp, #0
    9aa8:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    9aac:	ef000000 	svc	0x00000000
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    9ab0:	e1a03000 	mov	r3, r0
    9ab4:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:11

    return pid;
    9ab8:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:12
}
    9abc:	e1a00003 	mov	r0, r3
    9ac0:	e28bd000 	add	sp, fp, #0
    9ac4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9ac8:	e12fff1e 	bx	lr

00009acc <_Z17get_random_numberv>:
_Z17get_random_numberv():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:15

uint32_t get_random_number()
{
    9acc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9ad0:	e28db000 	add	fp, sp, #0
    9ad4:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:18
    uint32_t rng;

    asm volatile("swi 7");
    9ad8:	ef000007 	svc	0x00000007
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:19
    asm volatile("mov %0, r0" : "=r" (rng));
    9adc:	e1a03000 	mov	r3, r0
    9ae0:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:21

    return rng;
    9ae4:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:22
}
    9ae8:	e1a00003 	mov	r0, r3
    9aec:	e28bd000 	add	sp, fp, #0
    9af0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9af4:	e12fff1e 	bx	lr

00009af8 <_Z9terminatei>:
_Z9terminatei():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:25

void terminate(int exitcode)
{
    9af8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9afc:	e28db000 	add	fp, sp, #0
    9b00:	e24dd00c 	sub	sp, sp, #12
    9b04:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:26
    asm volatile("mov r0, %0" : : "r" (exitcode));
    9b08:	e51b3008 	ldr	r3, [fp, #-8]
    9b0c:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:27
    asm volatile("swi 1");
    9b10:	ef000001 	svc	0x00000001
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:28
}
    9b14:	e320f000 	nop	{0}
    9b18:	e28bd000 	add	sp, fp, #0
    9b1c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9b20:	e12fff1e 	bx	lr

00009b24 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:31

void sched_yield()
{
    9b24:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9b28:	e28db000 	add	fp, sp, #0
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:32
    asm volatile("swi 2");
    9b2c:	ef000002 	svc	0x00000002
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:33
}
    9b30:	e320f000 	nop	{0}
    9b34:	e28bd000 	add	sp, fp, #0
    9b38:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9b3c:	e12fff1e 	bx	lr

00009b40 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:36

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    9b40:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9b44:	e28db000 	add	fp, sp, #0
    9b48:	e24dd014 	sub	sp, sp, #20
    9b4c:	e50b0010 	str	r0, [fp, #-16]
    9b50:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:39
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    9b54:	e51b3010 	ldr	r3, [fp, #-16]
    9b58:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:40
    asm volatile("mov r1, %0" : : "r" (mode));
    9b5c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9b60:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:41
    asm volatile("swi 64");
    9b64:	ef000040 	svc	0x00000040
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov %0, r0" : "=r" (file));
    9b68:	e1a03000 	mov	r3, r0
    9b6c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:44

    return file;
    9b70:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:45
}
    9b74:	e1a00003 	mov	r0, r3
    9b78:	e28bd000 	add	sp, fp, #0
    9b7c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9b80:	e12fff1e 	bx	lr

00009b84 <_Z4readjPcj>:
_Z4readjPcj():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:48

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    9b84:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9b88:	e28db000 	add	fp, sp, #0
    9b8c:	e24dd01c 	sub	sp, sp, #28
    9b90:	e50b0010 	str	r0, [fp, #-16]
    9b94:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9b98:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:51
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    9b9c:	e51b3010 	ldr	r3, [fp, #-16]
    9ba0:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:52
    asm volatile("mov r1, %0" : : "r" (buffer));
    9ba4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9ba8:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:53
    asm volatile("mov r2, %0" : : "r" (size));
    9bac:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9bb0:	e1a02003 	mov	r2, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:54
    asm volatile("swi 65");
    9bb4:	ef000041 	svc	0x00000041
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov %0, r0" : "=r" (rdnum));
    9bb8:	e1a03000 	mov	r3, r0
    9bbc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:57

    return rdnum;
    9bc0:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:58
}
    9bc4:	e1a00003 	mov	r0, r3
    9bc8:	e28bd000 	add	sp, fp, #0
    9bcc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9bd0:	e12fff1e 	bx	lr

00009bd4 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:61

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    9bd4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9bd8:	e28db000 	add	fp, sp, #0
    9bdc:	e24dd01c 	sub	sp, sp, #28
    9be0:	e50b0010 	str	r0, [fp, #-16]
    9be4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9be8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:64
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    9bec:	e51b3010 	ldr	r3, [fp, #-16]
    9bf0:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r1, %0" : : "r" (buffer));
    9bf4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9bf8:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:66
    asm volatile("mov r2, %0" : : "r" (size));
    9bfc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9c00:	e1a02003 	mov	r2, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:67
    asm volatile("swi 66");
    9c04:	ef000042 	svc	0x00000042
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:68
    asm volatile("mov %0, r0" : "=r" (wrnum));
    9c08:	e1a03000 	mov	r3, r0
    9c0c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:70

    return wrnum;
    9c10:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:71
}
    9c14:	e1a00003 	mov	r0, r3
    9c18:	e28bd000 	add	sp, fp, #0
    9c1c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9c20:	e12fff1e 	bx	lr

00009c24 <_Z5closej>:
_Z5closej():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:74

void close(uint32_t file)
{
    9c24:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9c28:	e28db000 	add	fp, sp, #0
    9c2c:	e24dd00c 	sub	sp, sp, #12
    9c30:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r0, %0" : : "r" (file));
    9c34:	e51b3008 	ldr	r3, [fp, #-8]
    9c38:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 67");
    9c3c:	ef000043 	svc	0x00000043
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:77
}
    9c40:	e320f000 	nop	{0}
    9c44:	e28bd000 	add	sp, fp, #0
    9c48:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9c4c:	e12fff1e 	bx	lr

00009c50 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:80

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    9c50:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9c54:	e28db000 	add	fp, sp, #0
    9c58:	e24dd01c 	sub	sp, sp, #28
    9c5c:	e50b0010 	str	r0, [fp, #-16]
    9c60:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9c64:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:83
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    9c68:	e51b3010 	ldr	r3, [fp, #-16]
    9c6c:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:84
    asm volatile("mov r1, %0" : : "r" (operation));
    9c70:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9c74:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:85
    asm volatile("mov r2, %0" : : "r" (param));
    9c78:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9c7c:	e1a02003 	mov	r2, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:86
    asm volatile("swi 68");
    9c80:	ef000044 	svc	0x00000044
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov %0, r0" : "=r" (retcode));
    9c84:	e1a03000 	mov	r3, r0
    9c88:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:89

    return retcode;
    9c8c:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:90
}
    9c90:	e1a00003 	mov	r0, r3
    9c94:	e28bd000 	add	sp, fp, #0
    9c98:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9c9c:	e12fff1e 	bx	lr

00009ca0 <_Z6notifyjj>:
_Z6notifyjj():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:93

uint32_t notify(uint32_t file, uint32_t count)
{
    9ca0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9ca4:	e28db000 	add	fp, sp, #0
    9ca8:	e24dd014 	sub	sp, sp, #20
    9cac:	e50b0010 	str	r0, [fp, #-16]
    9cb0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:96
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    9cb4:	e51b3010 	ldr	r3, [fp, #-16]
    9cb8:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:97
    asm volatile("mov r1, %0" : : "r" (count));
    9cbc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9cc0:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:98
    asm volatile("swi 69");
    9cc4:	ef000045 	svc	0x00000045
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov %0, r0" : "=r" (retcnt));
    9cc8:	e1a03000 	mov	r3, r0
    9ccc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:101

    return retcnt;
    9cd0:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:102
}
    9cd4:	e1a00003 	mov	r0, r3
    9cd8:	e28bd000 	add	sp, fp, #0
    9cdc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9ce0:	e12fff1e 	bx	lr

00009ce4 <_Z4waitjjj>:
_Z4waitjjj():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:105

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    9ce4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9ce8:	e28db000 	add	fp, sp, #0
    9cec:	e24dd01c 	sub	sp, sp, #28
    9cf0:	e50b0010 	str	r0, [fp, #-16]
    9cf4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9cf8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:108
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    9cfc:	e51b3010 	ldr	r3, [fp, #-16]
    9d00:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:109
    asm volatile("mov r1, %0" : : "r" (count));
    9d04:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9d08:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:110
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    9d0c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9d10:	e1a02003 	mov	r2, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:111
    asm volatile("swi 70");
    9d14:	ef000046 	svc	0x00000046
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov %0, r0" : "=r" (retcode));
    9d18:	e1a03000 	mov	r3, r0
    9d1c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:114

    return retcode;
    9d20:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:115
}
    9d24:	e1a00003 	mov	r0, r3
    9d28:	e28bd000 	add	sp, fp, #0
    9d2c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9d30:	e12fff1e 	bx	lr

00009d34 <_Z5sleepjj>:
_Z5sleepjj():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:118

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    9d34:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9d38:	e28db000 	add	fp, sp, #0
    9d3c:	e24dd014 	sub	sp, sp, #20
    9d40:	e50b0010 	str	r0, [fp, #-16]
    9d44:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:121
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    9d48:	e51b3010 	ldr	r3, [fp, #-16]
    9d4c:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:122
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    9d50:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9d54:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:123
    asm volatile("swi 3");
    9d58:	ef000003 	svc	0x00000003
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:124
    asm volatile("mov %0, r0" : "=r" (retcode));
    9d5c:	e1a03000 	mov	r3, r0
    9d60:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:126

    return retcode;
    9d64:	e51b3008 	ldr	r3, [fp, #-8]
    9d68:	e3530000 	cmp	r3, #0
    9d6c:	13a03001 	movne	r3, #1
    9d70:	03a03000 	moveq	r3, #0
    9d74:	e6ef3073 	uxtb	r3, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:127
}
    9d78:	e1a00003 	mov	r0, r3
    9d7c:	e28bd000 	add	sp, fp, #0
    9d80:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9d84:	e12fff1e 	bx	lr

00009d88 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:130

uint32_t get_active_process_count()
{
    9d88:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9d8c:	e28db000 	add	fp, sp, #0
    9d90:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:131
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    9d94:	e3a03000 	mov	r3, #0
    9d98:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:134
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    9d9c:	e3a03000 	mov	r3, #0
    9da0:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:135
    asm volatile("mov r1, %0" : : "r" (&retval));
    9da4:	e24b300c 	sub	r3, fp, #12
    9da8:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:136
    asm volatile("swi 4");
    9dac:	ef000004 	svc	0x00000004
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:138

    return retval;
    9db0:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:139
}
    9db4:	e1a00003 	mov	r0, r3
    9db8:	e28bd000 	add	sp, fp, #0
    9dbc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9dc0:	e12fff1e 	bx	lr

00009dc4 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:142

uint32_t get_tick_count()
{
    9dc4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9dc8:	e28db000 	add	fp, sp, #0
    9dcc:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:143
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    9dd0:	e3a03001 	mov	r3, #1
    9dd4:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:146
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    9dd8:	e3a03001 	mov	r3, #1
    9ddc:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:147
    asm volatile("mov r1, %0" : : "r" (&retval));
    9de0:	e24b300c 	sub	r3, fp, #12
    9de4:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:148
    asm volatile("swi 4");
    9de8:	ef000004 	svc	0x00000004
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:150

    return retval;
    9dec:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:151
}
    9df0:	e1a00003 	mov	r0, r3
    9df4:	e28bd000 	add	sp, fp, #0
    9df8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9dfc:	e12fff1e 	bx	lr

00009e00 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:154

void set_task_deadline(uint32_t tick_count_required)
{
    9e00:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9e04:	e28db000 	add	fp, sp, #0
    9e08:	e24dd014 	sub	sp, sp, #20
    9e0c:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:155
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    9e10:	e3a03000 	mov	r3, #0
    9e14:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:157

    asm volatile("mov r0, %0" : : "r" (req));
    9e18:	e3a03000 	mov	r3, #0
    9e1c:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    9e20:	e24b3010 	sub	r3, fp, #16
    9e24:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    9e28:	ef000005 	svc	0x00000005
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:160
}
    9e2c:	e320f000 	nop	{0}
    9e30:	e28bd000 	add	sp, fp, #0
    9e34:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9e38:	e12fff1e 	bx	lr

00009e3c <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:163

uint32_t get_task_ticks_to_deadline()
{
    9e3c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9e40:	e28db000 	add	fp, sp, #0
    9e44:	e24dd00c 	sub	sp, sp, #12
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:164
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    9e48:	e3a03001 	mov	r3, #1
    9e4c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:167
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    9e50:	e3a03001 	mov	r3, #1
    9e54:	e1a00003 	mov	r0, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:168
    asm volatile("mov r1, %0" : : "r" (&ticks));
    9e58:	e24b300c 	sub	r3, fp, #12
    9e5c:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:169
    asm volatile("swi 5");
    9e60:	ef000005 	svc	0x00000005
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:171

    return ticks;
    9e64:	e51b300c 	ldr	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:172
}
    9e68:	e1a00003 	mov	r0, r3
    9e6c:	e28bd000 	add	sp, fp, #0
    9e70:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9e74:	e12fff1e 	bx	lr

00009e78 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:177

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    9e78:	e92d4800 	push	{fp, lr}
    9e7c:	e28db004 	add	fp, sp, #4
    9e80:	e24dd050 	sub	sp, sp, #80	; 0x50
    9e84:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    9e88:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:179
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    9e8c:	e24b3048 	sub	r3, fp, #72	; 0x48
    9e90:	e3a0200a 	mov	r2, #10
    9e94:	e59f108c 	ldr	r1, [pc, #140]	; 9f28 <_Z4pipePKcj+0xb0>
    9e98:	e1a00003 	mov	r0, r3
    9e9c:	eb000342 	bl	abac <_Z7strncpyPcPKci>
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:180
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    9ea0:	e24b3048 	sub	r3, fp, #72	; 0x48
    9ea4:	e283300a 	add	r3, r3, #10
    9ea8:	e3a02035 	mov	r2, #53	; 0x35
    9eac:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    9eb0:	e1a00003 	mov	r0, r3
    9eb4:	eb00033c 	bl	abac <_Z7strncpyPcPKci>
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:182

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    9eb8:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    9ebc:	eb000395 	bl	ad18 <_Z6strlenPKc>
    9ec0:	e1a03000 	mov	r3, r0
    9ec4:	e283300a 	add	r3, r3, #10
    9ec8:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:184

    fname[ncur++] = '#';
    9ecc:	e51b3008 	ldr	r3, [fp, #-8]
    9ed0:	e2832001 	add	r2, r3, #1
    9ed4:	e50b2008 	str	r2, [fp, #-8]
    9ed8:	e24b2004 	sub	r2, fp, #4
    9edc:	e0823003 	add	r3, r2, r3
    9ee0:	e3a02023 	mov	r2, #35	; 0x23
    9ee4:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:186

    itoa(buf_size, &fname[ncur], 10);
    9ee8:	e24b2048 	sub	r2, fp, #72	; 0x48
    9eec:	e51b3008 	ldr	r3, [fp, #-8]
    9ef0:	e0823003 	add	r3, r2, r3
    9ef4:	e3a0200a 	mov	r2, #10
    9ef8:	e1a01003 	mov	r1, r3
    9efc:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    9f00:	eb0002a5 	bl	a99c <_Z4itoajPcj>
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:188

    return open(fname, NFile_Open_Mode::Read_Write);
    9f04:	e24b3048 	sub	r3, fp, #72	; 0x48
    9f08:	e3a01002 	mov	r1, #2
    9f0c:	e1a00003 	mov	r0, r3
    9f10:	ebffff0a 	bl	9b40 <_Z4openPKc15NFile_Open_Mode>
    9f14:	e1a03000 	mov	r3, r0
    9f18:	e320f000 	nop	{0}
/home/hintik/dev/final/src/sources/stdlib/src/stdfile.cpp:189
}
    9f1c:	e1a00003 	mov	r0, r3
    9f20:	e24bd004 	sub	sp, fp, #4
    9f24:	e8bd8800 	pop	{fp, pc}
    9f28:	0000bd64 	andeq	fp, r0, r4, ror #26

00009f2c <_ZN12CUserHeapManC1Ev>:
_ZN12CUserHeapManC2Ev():
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:7
#include<hal/intdef.h>
#include<memory/memmap.h>

CUserHeapMan sUserHeap;

CUserHeapMan::CUserHeapMan()
    9f2c:	e92d4800 	push	{fp, lr}
    9f30:	e28db004 	add	fp, sp, #4
    9f34:	e24dd010 	sub	sp, sp, #16
    9f38:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:9
{
    mFirst = nullptr;
    9f3c:	e51b3010 	ldr	r3, [fp, #-16]
    9f40:	e3a02000 	mov	r2, #0
    9f44:	e5832000 	str	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:10
    PTptr = nullptr;
    9f48:	e51b3010 	ldr	r3, [fp, #-16]
    9f4c:	e3a02000 	mov	r2, #0
    9f50:	e5832010 	str	r2, [r3, #16]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:11
    uint32_t tempAddr = GetFirstNewPage(0x20000);
    9f54:	e3a01802 	mov	r1, #131072	; 0x20000
    9f58:	e51b0010 	ldr	r0, [fp, #-16]
    9f5c:	eb00000d 	bl	9f98 <_ZN12CUserHeapMan15GetFirstNewPageEj>
    9f60:	e50b0008 	str	r0, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:13
    
    mSize = mem::PageSize;
    9f64:	e51b3010 	ldr	r3, [fp, #-16]
    9f68:	e3a02601 	mov	r2, #1048576	; 0x100000
    9f6c:	e5832004 	str	r2, [r3, #4]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:14
    mVSize = 0;
    9f70:	e51b3010 	ldr	r3, [fp, #-16]
    9f74:	e3a02000 	mov	r2, #0
    9f78:	e5832008 	str	r2, [r3, #8]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:15
    mBrake = 0x20000;
    9f7c:	e51b3010 	ldr	r3, [fp, #-16]
    9f80:	e3a02802 	mov	r2, #131072	; 0x20000
    9f84:	e583200c 	str	r2, [r3, #12]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:16
}
    9f88:	e51b3010 	ldr	r3, [fp, #-16]
    9f8c:	e1a00003 	mov	r0, r3
    9f90:	e24bd004 	sub	sp, fp, #4
    9f94:	e8bd8800 	pop	{fp, pc}

00009f98 <_ZN12CUserHeapMan15GetFirstNewPageEj>:
_ZN12CUserHeapMan15GetFirstNewPageEj():
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:19

uint32_t CUserHeapMan::GetFirstNewPage(uint32_t NewVAddress)
{
    9f98:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9f9c:	e28db000 	add	fp, sp, #0
    9fa0:	e24dd014 	sub	sp, sp, #20
    9fa4:	e50b0010 	str	r0, [fp, #-16]
    9fa8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:23
    uint32_t address;
    uint32_t PTptr_temp;

    asm volatile("mov r1, %0" : : "r" (NewVAddress));
    9fac:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9fb0:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:24
    asm volatile("swi 6");
    9fb4:	ef000006 	svc	0x00000006
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:25
    asm volatile("mov %0, r0" : "=r" (address));
    9fb8:	e1a03000 	mov	r3, r0
    9fbc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:26
    asm volatile("mov %0, r1" : "=r" (PTptr_temp));
    9fc0:	e1a03001 	mov	r3, r1
    9fc4:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:27
    *PTptr = PTptr_temp;
    9fc8:	e51b3010 	ldr	r3, [fp, #-16]
    9fcc:	e5933010 	ldr	r3, [r3, #16]
    9fd0:	e51b200c 	ldr	r2, [fp, #-12]
    9fd4:	e5832000 	str	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:29

    return address;
    9fd8:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:30
}
    9fdc:	e1a00003 	mov	r0, r3
    9fe0:	e28bd000 	add	sp, fp, #0
    9fe4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9fe8:	e12fff1e 	bx	lr

00009fec <_ZN12CUserHeapMan10GetNewPageEj>:
_ZN12CUserHeapMan10GetNewPageEj():
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:33

uint32_t CUserHeapMan::GetNewPage(uint32_t NewVAddress)
{
    9fec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9ff0:	e28db000 	add	fp, sp, #0
    9ff4:	e24dd014 	sub	sp, sp, #20
    9ff8:	e50b0010 	str	r0, [fp, #-16]
    9ffc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:36
    uint32_t address;

    asm volatile("mov r1, %0" : : "r" (NewVAddress));
    a000:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a004:	e1a01003 	mov	r1, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:37
    asm volatile("mov r2, %0" : : "r" (PTptr));
    a008:	e51b3010 	ldr	r3, [fp, #-16]
    a00c:	e5933010 	ldr	r3, [r3, #16]
    a010:	e1a02003 	mov	r2, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:38
    asm volatile("swi 8");
    a014:	ef000008 	svc	0x00000008
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:39
    asm volatile("mov %0, r0" : "=r" (address));
    a018:	e1a03000 	mov	r3, r0
    a01c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:41

    return address;
    a020:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:42
}
    a024:	e1a00003 	mov	r0, r3
    a028:	e28bd000 	add	sp, fp, #0
    a02c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a030:	e12fff1e 	bx	lr

0000a034 <_ZN12CUserHeapMan4sbrkEjb>:
_ZN12CUserHeapMan4sbrkEjb():
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:45

void CUserHeapMan::sbrk(uint32_t size, bool over)
{
    a034:	e92d4800 	push	{fp, lr}
    a038:	e28db004 	add	fp, sp, #4
    a03c:	e24dd020 	sub	sp, sp, #32
    a040:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    a044:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    a048:	e1a03002 	mov	r3, r2
    a04c:	e54b301d 	strb	r3, [fp, #-29]	; 0xffffffe3
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:46
    uint32_t newsize = mVSize + size + sizeof(UPage);
    a050:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a054:	e5932008 	ldr	r2, [r3, #8]
    a058:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    a05c:	e0823003 	add	r3, r2, r3
    a060:	e2833014 	add	r3, r3, #20
    a064:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:47
    if(over)
    a068:	e55b301d 	ldrb	r3, [fp, #-29]	; 0xffffffe3
    a06c:	e3530000 	cmp	r3, #0
    a070:	0a00002f 	beq	a134 <_ZN12CUserHeapMan4sbrkEjb+0x100>
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:49
    {
        uint32_t tempaddr = GetNewPage(0x20000 + size + mem::PageSize);
    a074:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    a078:	e2833812 	add	r3, r3, #1179648	; 0x120000
    a07c:	e1a01003 	mov	r1, r3
    a080:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    a084:	ebffffd8 	bl	9fec <_ZN12CUserHeapMan10GetNewPageEj>
    a088:	e50b000c 	str	r0, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:51
        
        UPage* newchunk = reinterpret_cast<UPage*>(tempaddr);
    a08c:	e51b300c 	ldr	r3, [fp, #-12]
    a090:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:52
        newchunk->prev = mFirst;
    a094:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a098:	e5932000 	ldr	r2, [r3]
    a09c:	e51b3010 	ldr	r3, [fp, #-16]
    a0a0:	e5832000 	str	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:53
        newchunk->next = nullptr;
    a0a4:	e51b3010 	ldr	r3, [fp, #-16]
    a0a8:	e3a02000 	mov	r2, #0
    a0ac:	e5832004 	str	r2, [r3, #4]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:54
        newchunk->address = tempaddr + sizeof(UPage);
    a0b0:	e51b300c 	ldr	r3, [fp, #-12]
    a0b4:	e2832014 	add	r2, r3, #20
    a0b8:	e51b3010 	ldr	r3, [fp, #-16]
    a0bc:	e5832008 	str	r2, [r3, #8]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:55
        newchunk->free = false;
    a0c0:	e51b3010 	ldr	r3, [fp, #-16]
    a0c4:	e3a02000 	mov	r2, #0
    a0c8:	e5c32010 	strb	r2, [r3, #16]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:56
        newchunk->size = size;
    a0cc:	e51b3010 	ldr	r3, [fp, #-16]
    a0d0:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a0d4:	e583200c 	str	r2, [r3, #12]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:58
        
        mFirst->next = newchunk;
    a0d8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a0dc:	e5933000 	ldr	r3, [r3]
    a0e0:	e51b2010 	ldr	r2, [fp, #-16]
    a0e4:	e5832004 	str	r2, [r3, #4]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:59
        mFirst = newchunk;
    a0e8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a0ec:	e51b2010 	ldr	r2, [fp, #-16]
    a0f0:	e5832000 	str	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:61
        
        mSize = mSize + mem::PageSize;
    a0f4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a0f8:	e5933004 	ldr	r3, [r3, #4]
    a0fc:	e2832601 	add	r2, r3, #1048576	; 0x100000
    a100:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a104:	e5832004 	str	r2, [r3, #4]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:62
        mVSize = mVSize + sizeof(UPage);
    a108:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a10c:	e5933008 	ldr	r3, [r3, #8]
    a110:	e2832014 	add	r2, r3, #20
    a114:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a118:	e5832008 	str	r2, [r3, #8]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:63
        mBrake = mFirst->address;
    a11c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a120:	e5933000 	ldr	r3, [r3]
    a124:	e5932008 	ldr	r2, [r3, #8]
    a128:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a12c:	e583200c 	str	r2, [r3, #12]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:64
        return;
    a130:	ea000007 	b	a154 <_ZN12CUserHeapMan4sbrkEjb+0x120>
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:68
    }
    else
    {
        mBrake = mBrake + size + sizeof(UPage);
    a134:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a138:	e593200c 	ldr	r2, [r3, #12]
    a13c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    a140:	e0823003 	add	r3, r2, r3
    a144:	e2832014 	add	r2, r3, #20
    a148:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a14c:	e583200c 	str	r2, [r3, #12]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:69
        return;
    a150:	e320f000 	nop	{0}
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:71
    }
}
    a154:	e24bd004 	sub	sp, fp, #4
    a158:	e8bd8800 	pop	{fp, pc}

0000a15c <_ZN12CUserHeapMan5AllocEj>:
_ZN12CUserHeapMan5AllocEj():
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:74

void* CUserHeapMan::Alloc(uint32_t size)
{
    a15c:	e92d4800 	push	{fp, lr}
    a160:	e28db004 	add	fp, sp, #4
    a164:	e24dd010 	sub	sp, sp, #16
    a168:	e50b0010 	str	r0, [fp, #-16]
    a16c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:75
    uint32_t saveBreak = mBrake;
    a170:	e51b3010 	ldr	r3, [fp, #-16]
    a174:	e593300c 	ldr	r3, [r3, #12]
    a178:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:77

    if(mFirst == nullptr)
    a17c:	e51b3010 	ldr	r3, [fp, #-16]
    a180:	e5933000 	ldr	r3, [r3]
    a184:	e3530000 	cmp	r3, #0
    a188:	1a000021 	bne	a214 <_ZN12CUserHeapMan5AllocEj+0xb8>
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:79
    {
        mFirst = reinterpret_cast<UPage*>(0x20000);
    a18c:	e51b3010 	ldr	r3, [fp, #-16]
    a190:	e3a02802 	mov	r2, #131072	; 0x20000
    a194:	e5832000 	str	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:80
        mFirst->prev = nullptr;
    a198:	e51b3010 	ldr	r3, [fp, #-16]
    a19c:	e5933000 	ldr	r3, [r3]
    a1a0:	e3a02000 	mov	r2, #0
    a1a4:	e5832000 	str	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:81
        mFirst->next = nullptr;
    a1a8:	e51b3010 	ldr	r3, [fp, #-16]
    a1ac:	e5933000 	ldr	r3, [r3]
    a1b0:	e3a02000 	mov	r2, #0
    a1b4:	e5832004 	str	r2, [r3, #4]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:82
        mFirst->address = 0x20000;
    a1b8:	e51b3010 	ldr	r3, [fp, #-16]
    a1bc:	e5933000 	ldr	r3, [r3]
    a1c0:	e3a02802 	mov	r2, #131072	; 0x20000
    a1c4:	e5832008 	str	r2, [r3, #8]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:83
        mFirst->size = size;
    a1c8:	e51b3010 	ldr	r3, [fp, #-16]
    a1cc:	e5933000 	ldr	r3, [r3]
    a1d0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a1d4:	e583200c 	str	r2, [r3, #12]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:84
        mFirst->free = false;
    a1d8:	e51b3010 	ldr	r3, [fp, #-16]
    a1dc:	e5933000 	ldr	r3, [r3]
    a1e0:	e3a02000 	mov	r2, #0
    a1e4:	e5c32010 	strb	r2, [r3, #16]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:85
        sbrk(size + sizeof(UPage), false);
    a1e8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a1ec:	e2833014 	add	r3, r3, #20
    a1f0:	e3a02000 	mov	r2, #0
    a1f4:	e1a01003 	mov	r1, r3
    a1f8:	e51b0010 	ldr	r0, [fp, #-16]
    a1fc:	ebffff8c 	bl	a034 <_ZN12CUserHeapMan4sbrkEjb>
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:86
        return reinterpret_cast<uint8_t*>(mFirst->address) + sizeof(UPage);
    a200:	e51b3010 	ldr	r3, [fp, #-16]
    a204:	e5933000 	ldr	r3, [r3]
    a208:	e5933008 	ldr	r3, [r3, #8]
    a20c:	e2833014 	add	r3, r3, #20
    a210:	ea000035 	b	a2ec <_ZN12CUserHeapMan5AllocEj+0x190>
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:89
    }
    
    if(size + sizeof(UPage) + mVSize > mSize)
    a214:	e51b3010 	ldr	r3, [fp, #-16]
    a218:	e5932008 	ldr	r2, [r3, #8]
    a21c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a220:	e0823003 	add	r3, r2, r3
    a224:	e2832014 	add	r2, r3, #20
    a228:	e51b3010 	ldr	r3, [fp, #-16]
    a22c:	e5933004 	ldr	r3, [r3, #4]
    a230:	e1520003 	cmp	r2, r3
    a234:	9a000007 	bls	a258 <_ZN12CUserHeapMan5AllocEj+0xfc>
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:91
    {
        sbrk(size, true);
    a238:	e3a02001 	mov	r2, #1
    a23c:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    a240:	e51b0010 	ldr	r0, [fp, #-16]
    a244:	ebffff7a 	bl	a034 <_ZN12CUserHeapMan4sbrkEjb>
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:92
        return reinterpret_cast<uint8_t*>(mFirst->address);
    a248:	e51b3010 	ldr	r3, [fp, #-16]
    a24c:	e5933000 	ldr	r3, [r3]
    a250:	e5933008 	ldr	r3, [r3, #8]
    a254:	ea000024 	b	a2ec <_ZN12CUserHeapMan5AllocEj+0x190>
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:95
    }
    
    UPage* newchunk = reinterpret_cast<UPage*>(mBrake);
    a258:	e51b3010 	ldr	r3, [fp, #-16]
    a25c:	e593300c 	ldr	r3, [r3, #12]
    a260:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:96
    newchunk->prev = mFirst;
    a264:	e51b3010 	ldr	r3, [fp, #-16]
    a268:	e5932000 	ldr	r2, [r3]
    a26c:	e51b300c 	ldr	r3, [fp, #-12]
    a270:	e5832000 	str	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:97
    newchunk->next = nullptr;
    a274:	e51b300c 	ldr	r3, [fp, #-12]
    a278:	e3a02000 	mov	r2, #0
    a27c:	e5832004 	str	r2, [r3, #4]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:98
    newchunk->address = mBrake + sizeof(UPage);
    a280:	e51b3010 	ldr	r3, [fp, #-16]
    a284:	e593300c 	ldr	r3, [r3, #12]
    a288:	e2832014 	add	r2, r3, #20
    a28c:	e51b300c 	ldr	r3, [fp, #-12]
    a290:	e5832008 	str	r2, [r3, #8]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:99
    newchunk->free = false;
    a294:	e51b300c 	ldr	r3, [fp, #-12]
    a298:	e3a02000 	mov	r2, #0
    a29c:	e5c32010 	strb	r2, [r3, #16]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:100
    newchunk->size = size;
    a2a0:	e51b300c 	ldr	r3, [fp, #-12]
    a2a4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a2a8:	e583200c 	str	r2, [r3, #12]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:102
    
    mFirst->next = newchunk;
    a2ac:	e51b3010 	ldr	r3, [fp, #-16]
    a2b0:	e5933000 	ldr	r3, [r3]
    a2b4:	e51b200c 	ldr	r2, [fp, #-12]
    a2b8:	e5832004 	str	r2, [r3, #4]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:103
    mFirst = newchunk;
    a2bc:	e51b3010 	ldr	r3, [fp, #-16]
    a2c0:	e51b200c 	ldr	r2, [fp, #-12]
    a2c4:	e5832000 	str	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:104
    sbrk(size + sizeof(UPage),false);
    a2c8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a2cc:	e2833014 	add	r3, r3, #20
    a2d0:	e3a02000 	mov	r2, #0
    a2d4:	e1a01003 	mov	r1, r3
    a2d8:	e51b0010 	ldr	r0, [fp, #-16]
    a2dc:	ebffff54 	bl	a034 <_ZN12CUserHeapMan4sbrkEjb>
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:105
    return reinterpret_cast<uint8_t*>(mFirst->address); // vracime az pouzitelnou pamet, tedy to co nasleduje po hlavicce    
    a2e0:	e51b3010 	ldr	r3, [fp, #-16]
    a2e4:	e5933000 	ldr	r3, [r3]
    a2e8:	e5933008 	ldr	r3, [r3, #8]
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:106
}
    a2ec:	e1a00003 	mov	r0, r3
    a2f0:	e24bd004 	sub	sp, fp, #4
    a2f4:	e8bd8800 	pop	{fp, pc}

0000a2f8 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:106
    a2f8:	e92d4800 	push	{fp, lr}
    a2fc:	e28db004 	add	fp, sp, #4
    a300:	e24dd008 	sub	sp, sp, #8
    a304:	e50b0008 	str	r0, [fp, #-8]
    a308:	e50b100c 	str	r1, [fp, #-12]
    a30c:	e51b3008 	ldr	r3, [fp, #-8]
    a310:	e3530001 	cmp	r3, #1
    a314:	1a000005 	bne	a330 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:106 (discriminator 1)
    a318:	e51b300c 	ldr	r3, [fp, #-12]
    a31c:	e59f2018 	ldr	r2, [pc, #24]	; a33c <_Z41__static_initialization_and_destruction_0ii+0x44>
    a320:	e1530002 	cmp	r3, r2
    a324:	1a000001 	bne	a330 <_Z41__static_initialization_and_destruction_0ii+0x38>
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:5
CUserHeapMan sUserHeap;
    a328:	e59f0010 	ldr	r0, [pc, #16]	; a340 <_Z41__static_initialization_and_destruction_0ii+0x48>
    a32c:	ebfffefe 	bl	9f2c <_ZN12CUserHeapManC1Ev>
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:106
}
    a330:	e320f000 	nop	{0}
    a334:	e24bd004 	sub	sp, fp, #4
    a338:	e8bd8800 	pop	{fp, pc}
    a33c:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    a340:	0000bee4 	andeq	fp, r0, r4, ror #29

0000a344 <_GLOBAL__sub_I_sUserHeap>:
_GLOBAL__sub_I_sUserHeap():
/home/hintik/dev/final/src/sources/stdlib/src/stdmemory.cpp:106
    a344:	e92d4800 	push	{fp, lr}
    a348:	e28db004 	add	fp, sp, #4
    a34c:	e59f1008 	ldr	r1, [pc, #8]	; a35c <_GLOBAL__sub_I_sUserHeap+0x18>
    a350:	e3a00001 	mov	r0, #1
    a354:	ebffffe7 	bl	a2f8 <_Z41__static_initialization_and_destruction_0ii>
    a358:	e8bd8800 	pop	{fp, pc}
    a35c:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

0000a360 <_Z4n_tuii>:
_Z4n_tuii():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:7

namespace {
    const char CharConvArr[] = "0123456789ABCDEF";
}

int n_tu(int number, int count) {
    a360:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a364:	e28db000 	add	fp, sp, #0
    a368:	e24dd014 	sub	sp, sp, #20
    a36c:	e50b0010 	str	r0, [fp, #-16]
    a370:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:8
    int result = 1;
    a374:	e3a03001 	mov	r3, #1
    a378:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:9
    while (count-- > 0)
    a37c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a380:	e2432001 	sub	r2, r3, #1
    a384:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    a388:	e3530000 	cmp	r3, #0
    a38c:	c3a03001 	movgt	r3, #1
    a390:	d3a03000 	movle	r3, #0
    a394:	e6ef3073 	uxtb	r3, r3
    a398:	e3530000 	cmp	r3, #0
    a39c:	0a000004 	beq	a3b4 <_Z4n_tuii+0x54>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:10
        result *= number;
    a3a0:	e51b3008 	ldr	r3, [fp, #-8]
    a3a4:	e51b2010 	ldr	r2, [fp, #-16]
    a3a8:	e0030392 	mul	r3, r2, r3
    a3ac:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:9
    while (count-- > 0)
    a3b0:	eafffff1 	b	a37c <_Z4n_tuii+0x1c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:12

    return result;
    a3b4:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:13
}
    a3b8:	e1a00003 	mov	r0, r3
    a3bc:	e28bd000 	add	sp, fp, #0
    a3c0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a3c4:	e12fff1e 	bx	lr

0000a3c8 <_Z4ftoafPc>:
_Z4ftoafPc():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:15

void ftoa(float f, char *r) {
    a3c8:	e92d4bf0 	push	{r4, r5, r6, r7, r8, r9, fp, lr}
    a3cc:	e28db01c 	add	fp, sp, #28
    a3d0:	e24dd060 	sub	sp, sp, #96	; 0x60
    a3d4:	ed0b0a16 	vstr	s0, [fp, #-88]	; 0xffffffa8
    a3d8:	e50b005c 	str	r0, [fp, #-92]	; 0xffffffa4
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:19
    long long int length, length2, i, number, position, sign;
    float number2;

    sign = -1;   // -1 == positive number
    a3dc:	e3e02000 	mvn	r2, #0
    a3e0:	e3e03000 	mvn	r3, #0
    a3e4:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:20
    if (f < 0) {
    a3e8:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    a3ec:	eef57ac0 	vcmpe.f32	s15, #0.0
    a3f0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    a3f4:	5a000005 	bpl	a410 <_Z4ftoafPc+0x48>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:21
        sign = '-';
    a3f8:	e3a0202d 	mov	r2, #45	; 0x2d
    a3fc:	e3a03000 	mov	r3, #0
    a400:	e14b23fc 	strd	r2, [fp, #-60]	; 0xffffffc4
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:22
        f *= -1;
    a404:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    a408:	eef17a67 	vneg.f32	s15, s15
    a40c:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:25
    }

    number2 = f;
    a410:	e51b3058 	ldr	r3, [fp, #-88]	; 0xffffffa8
    a414:	e50b3040 	str	r3, [fp, #-64]	; 0xffffffc0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:26
    number = f;
    a418:	e51b0058 	ldr	r0, [fp, #-88]	; 0xffffffa8
    a41c:	eb000553 	bl	b970 <__aeabi_f2lz>
    a420:	e1a02000 	mov	r2, r0
    a424:	e1a03001 	mov	r3, r1
    a428:	e14b23f4 	strd	r2, [fp, #-52]	; 0xffffffcc
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:27
    length = 0;  // Size of decimal part
    a42c:	e3a02000 	mov	r2, #0
    a430:	e3a03000 	mov	r3, #0
    a434:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:28
    length2 = 0; // Size of tenth
    a438:	e3a02000 	mov	r2, #0
    a43c:	e3a03000 	mov	r3, #0
    a440:	e14b22f4 	strd	r2, [fp, #-36]	; 0xffffffdc
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:31

    /* Calculate length2 tenth part */
    while ((number2 - (float) number) != 0.0 && !((number2 - (float) number) < 0.0)) {
    a444:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    a448:	eb0004f4 	bl	b820 <__aeabi_l2f>
    a44c:	ee070a10 	vmov	s14, r0
    a450:	ed5b7a10 	vldr	s15, [fp, #-64]	; 0xffffffc0
    a454:	ee777ac7 	vsub.f32	s15, s15, s14
    a458:	eef57a40 	vcmp.f32	s15, #0.0
    a45c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    a460:	0a00001b 	beq	a4d4 <_Z4ftoafPc+0x10c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:31 (discriminator 1)
    a464:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    a468:	eb0004ec 	bl	b820 <__aeabi_l2f>
    a46c:	ee070a10 	vmov	s14, r0
    a470:	ed5b7a10 	vldr	s15, [fp, #-64]	; 0xffffffc0
    a474:	ee777ac7 	vsub.f32	s15, s15, s14
    a478:	eef57ac0 	vcmpe.f32	s15, #0.0
    a47c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    a480:	4a000013 	bmi	a4d4 <_Z4ftoafPc+0x10c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:32
        number2 = f * (n_tu(10.0, length2 + 1));
    a484:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    a488:	e2833001 	add	r3, r3, #1
    a48c:	e1a01003 	mov	r1, r3
    a490:	e3a0000a 	mov	r0, #10
    a494:	ebffffb1 	bl	a360 <_Z4n_tuii>
    a498:	ee070a90 	vmov	s15, r0
    a49c:	eef87ae7 	vcvt.f32.s32	s15, s15
    a4a0:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    a4a4:	ee677a27 	vmul.f32	s15, s14, s15
    a4a8:	ed4b7a10 	vstr	s15, [fp, #-64]	; 0xffffffc0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:33
        number = number2;
    a4ac:	e51b0040 	ldr	r0, [fp, #-64]	; 0xffffffc0
    a4b0:	eb00052e 	bl	b970 <__aeabi_f2lz>
    a4b4:	e1a02000 	mov	r2, r0
    a4b8:	e1a03001 	mov	r3, r1
    a4bc:	e14b23f4 	strd	r2, [fp, #-52]	; 0xffffffcc
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:35

        length2++;
    a4c0:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    a4c4:	e2926001 	adds	r6, r2, #1
    a4c8:	e2a37000 	adc	r7, r3, #0
    a4cc:	e14b62f4 	strd	r6, [fp, #-36]	; 0xffffffdc
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:31
    while ((number2 - (float) number) != 0.0 && !((number2 - (float) number) < 0.0)) {
    a4d0:	eaffffdb 	b	a444 <_Z4ftoafPc+0x7c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:39
    }

    /* Calculate length decimal part */
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    a4d4:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    a4d8:	ed9f7a80 	vldr	s14, [pc, #512]	; a6e0 <_Z4ftoafPc+0x318>
    a4dc:	eef47ac7 	vcmpe.f32	s15, s14
    a4e0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    a4e4:	c3a03001 	movgt	r3, #1
    a4e8:	d3a03000 	movle	r3, #0
    a4ec:	e6ef3073 	uxtb	r3, r3
    a4f0:	e2233001 	eor	r3, r3, #1
    a4f4:	e6ef3073 	uxtb	r3, r3
    a4f8:	e6ef2073 	uxtb	r2, r3
    a4fc:	e3a03000 	mov	r3, #0
    a500:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:39 (discriminator 3)
    a504:	ed5b7a16 	vldr	s15, [fp, #-88]	; 0xffffffa8
    a508:	ed9f7a74 	vldr	s14, [pc, #464]	; a6e0 <_Z4ftoafPc+0x318>
    a50c:	eef47ac7 	vcmpe.f32	s15, s14
    a510:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    a514:	da00000b 	ble	a548 <_Z4ftoafPc+0x180>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:40 (discriminator 2)
        f /= 10;
    a518:	ed1b7a16 	vldr	s14, [fp, #-88]	; 0xffffffa8
    a51c:	eddf6a70 	vldr	s13, [pc, #448]	; a6e4 <_Z4ftoafPc+0x31c>
    a520:	eec77a26 	vdiv.f32	s15, s14, s13
    a524:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:39 (discriminator 2)
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
    a528:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    a52c:	e2921001 	adds	r1, r2, #1
    a530:	e50b1064 	str	r1, [fp, #-100]	; 0xffffff9c
    a534:	e2a33000 	adc	r3, r3, #0
    a538:	e50b3060 	str	r3, [fp, #-96]	; 0xffffffa0
    a53c:	e14b26d4 	ldrd	r2, [fp, #-100]	; 0xffffff9c
    a540:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
    a544:	eaffffee 	b	a504 <_Z4ftoafPc+0x13c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:42

    position = length;
    a548:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    a54c:	e14b25f4 	strd	r2, [fp, #-84]	; 0xffffffac
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:43
    length = length + 1 + length2;
    a550:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    a554:	e2924001 	adds	r4, r2, #1
    a558:	e2a35000 	adc	r5, r3, #0
    a55c:	e14b22d4 	ldrd	r2, [fp, #-36]	; 0xffffffdc
    a560:	e0941002 	adds	r1, r4, r2
    a564:	e50b106c 	str	r1, [fp, #-108]	; 0xffffff94
    a568:	e0a53003 	adc	r3, r5, r3
    a56c:	e50b3068 	str	r3, [fp, #-104]	; 0xffffff98
    a570:	e14b26dc 	ldrd	r2, [fp, #-108]	; 0xffffff94
    a574:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:44
    number = number2;
    a578:	e51b0040 	ldr	r0, [fp, #-64]	; 0xffffffc0
    a57c:	eb0004fb 	bl	b970 <__aeabi_f2lz>
    a580:	e1a02000 	mov	r2, r0
    a584:	e1a03001 	mov	r3, r1
    a588:	e14b23f4 	strd	r2, [fp, #-52]	; 0xffffffcc
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:45
    if (sign == '-') {
    a58c:	e14b23dc 	ldrd	r2, [fp, #-60]	; 0xffffffc4
    a590:	e3530000 	cmp	r3, #0
    a594:	0352002d 	cmpeq	r2, #45	; 0x2d
    a598:	1a00000d 	bne	a5d4 <_Z4ftoafPc+0x20c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:46
        length++;
    a59c:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    a5a0:	e2921001 	adds	r1, r2, #1
    a5a4:	e50b1074 	str	r1, [fp, #-116]	; 0xffffff8c
    a5a8:	e2a33000 	adc	r3, r3, #0
    a5ac:	e50b3070 	str	r3, [fp, #-112]	; 0xffffff90
    a5b0:	e14b27d4 	ldrd	r2, [fp, #-116]	; 0xffffff8c
    a5b4:	e14b24fc 	strd	r2, [fp, #-76]	; 0xffffffb4
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:47
        position++;
    a5b8:	e14b25d4 	ldrd	r2, [fp, #-84]	; 0xffffffac
    a5bc:	e2921001 	adds	r1, r2, #1
    a5c0:	e50b107c 	str	r1, [fp, #-124]	; 0xffffff84
    a5c4:	e2a33000 	adc	r3, r3, #0
    a5c8:	e50b3078 	str	r3, [fp, #-120]	; 0xffffff88
    a5cc:	e14b27dc 	ldrd	r2, [fp, #-124]	; 0xffffff84
    a5d0:	e14b25f4 	strd	r2, [fp, #-84]	; 0xffffffac
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:50
    }

    for (i = length; i >= 0; i--) {
    a5d4:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    a5d8:	e14b22fc 	strd	r2, [fp, #-44]	; 0xffffffd4
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:50 (discriminator 1)
    a5dc:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    a5e0:	e3520000 	cmp	r2, #0
    a5e4:	e2d33000 	sbcs	r3, r3, #0
    a5e8:	ba000039 	blt	a6d4 <_Z4ftoafPc+0x30c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:51
        if (i == (length))
    a5ec:	e14b24dc 	ldrd	r2, [fp, #-76]	; 0xffffffb4
    a5f0:	e14b02dc 	ldrd	r0, [fp, #-44]	; 0xffffffd4
    a5f4:	e1510003 	cmp	r1, r3
    a5f8:	01500002 	cmpeq	r0, r2
    a5fc:	1a000005 	bne	a618 <_Z4ftoafPc+0x250>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:52
            r[i] = '\0';
    a600:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    a604:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    a608:	e0823003 	add	r3, r2, r3
    a60c:	e3a02000 	mov	r2, #0
    a610:	e5c32000 	strb	r2, [r3]
    a614:	ea000029 	b	a6c0 <_Z4ftoafPc+0x2f8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:53
        else if (i == (position))
    a618:	e14b25d4 	ldrd	r2, [fp, #-84]	; 0xffffffac
    a61c:	e14b02dc 	ldrd	r0, [fp, #-44]	; 0xffffffd4
    a620:	e1510003 	cmp	r1, r3
    a624:	01500002 	cmpeq	r0, r2
    a628:	1a000005 	bne	a644 <_Z4ftoafPc+0x27c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:54
            r[i] = '.';
    a62c:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    a630:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    a634:	e0823003 	add	r3, r2, r3
    a638:	e3a0202e 	mov	r2, #46	; 0x2e
    a63c:	e5c32000 	strb	r2, [r3]
    a640:	ea00001e 	b	a6c0 <_Z4ftoafPc+0x2f8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:55
        else if (sign == '-' && i == 0)
    a644:	e14b23dc 	ldrd	r2, [fp, #-60]	; 0xffffffc4
    a648:	e3530000 	cmp	r3, #0
    a64c:	0352002d 	cmpeq	r2, #45	; 0x2d
    a650:	1a000008 	bne	a678 <_Z4ftoafPc+0x2b0>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:55 (discriminator 1)
    a654:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    a658:	e1923003 	orrs	r3, r2, r3
    a65c:	1a000005 	bne	a678 <_Z4ftoafPc+0x2b0>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:56
            r[i] = '-';
    a660:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    a664:	e51b205c 	ldr	r2, [fp, #-92]	; 0xffffffa4
    a668:	e0823003 	add	r3, r2, r3
    a66c:	e3a0202d 	mov	r2, #45	; 0x2d
    a670:	e5c32000 	strb	r2, [r3]
    a674:	ea000011 	b	a6c0 <_Z4ftoafPc+0x2f8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:58
        else {
            r[i] = (number % 10) + '0';
    a678:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    a67c:	e3a0200a 	mov	r2, #10
    a680:	e3a03000 	mov	r3, #0
    a684:	eb000484 	bl	b89c <__aeabi_ldivmod>
    a688:	e6ef2072 	uxtb	r2, r2
    a68c:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    a690:	e51b105c 	ldr	r1, [fp, #-92]	; 0xffffffa4
    a694:	e0813003 	add	r3, r1, r3
    a698:	e2822030 	add	r2, r2, #48	; 0x30
    a69c:	e6ef2072 	uxtb	r2, r2
    a6a0:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:59
            number /= 10;
    a6a4:	e14b03d4 	ldrd	r0, [fp, #-52]	; 0xffffffcc
    a6a8:	e3a0200a 	mov	r2, #10
    a6ac:	e3a03000 	mov	r3, #0
    a6b0:	eb000479 	bl	b89c <__aeabi_ldivmod>
    a6b4:	e1a02000 	mov	r2, r0
    a6b8:	e1a03001 	mov	r3, r1
    a6bc:	e14b23f4 	strd	r2, [fp, #-52]	; 0xffffffcc
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:50 (discriminator 2)
    for (i = length; i >= 0; i--) {
    a6c0:	e14b22dc 	ldrd	r2, [fp, #-44]	; 0xffffffd4
    a6c4:	e2528001 	subs	r8, r2, #1
    a6c8:	e2c39000 	sbc	r9, r3, #0
    a6cc:	e14b82fc 	strd	r8, [fp, #-44]	; 0xffffffd4
    a6d0:	eaffffc1 	b	a5dc <_Z4ftoafPc+0x214>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:62
        }
    }
}
    a6d4:	e320f000 	nop	{0}
    a6d8:	e24bd01c 	sub	sp, fp, #28
    a6dc:	e8bd8bf0 	pop	{r4, r5, r6, r7, r8, r9, fp, pc}
    a6e0:	3f800000 	svccc	0x00800000
    a6e4:	41200000 			; <UNDEFINED> instruction: 0x41200000

0000a6e8 <_Z4atofPKc>:
_Z4atofPKc():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:66

#define isdigit(c) (c >= '0' && c <= '9')

float atof(const char *s) {
    a6e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a6ec:	e28db000 	add	fp, sp, #0
    a6f0:	e24dd024 	sub	sp, sp, #36	; 0x24
    a6f4:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:67
    float a = 0.0;
    a6f8:	e3a03000 	mov	r3, #0
    a6fc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:68
    int e = 0;
    a700:	e3a03000 	mov	r3, #0
    a704:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:70
    int c;
    while ((c = *s++) != '\0' && isdigit(c)) {
    a708:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a70c:	e2832001 	add	r2, r3, #1
    a710:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a714:	e5d33000 	ldrb	r3, [r3]
    a718:	e50b3010 	str	r3, [fp, #-16]
    a71c:	e51b3010 	ldr	r3, [fp, #-16]
    a720:	e3530000 	cmp	r3, #0
    a724:	0a000007 	beq	a748 <_Z4atofPKc+0x60>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:70 (discriminator 1)
    a728:	e51b3010 	ldr	r3, [fp, #-16]
    a72c:	e353002f 	cmp	r3, #47	; 0x2f
    a730:	da000004 	ble	a748 <_Z4atofPKc+0x60>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:70 (discriminator 3)
    a734:	e51b3010 	ldr	r3, [fp, #-16]
    a738:	e3530039 	cmp	r3, #57	; 0x39
    a73c:	ca000001 	bgt	a748 <_Z4atofPKc+0x60>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:70 (discriminator 5)
    a740:	e3a03001 	mov	r3, #1
    a744:	ea000000 	b	a74c <_Z4atofPKc+0x64>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:70 (discriminator 6)
    a748:	e3a03000 	mov	r3, #0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:70 (discriminator 8)
    a74c:	e3530000 	cmp	r3, #0
    a750:	0a00000b 	beq	a784 <_Z4atofPKc+0x9c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:71
        a = a * 10.0 + (c - '0');
    a754:	ed5b7a02 	vldr	s15, [fp, #-8]
    a758:	eeb77ae7 	vcvt.f64.f32	d7, s15
    a75c:	ed9f6b89 	vldr	d6, [pc, #548]	; a988 <_Z4atofPKc+0x2a0>
    a760:	ee276b06 	vmul.f64	d6, d7, d6
    a764:	e51b3010 	ldr	r3, [fp, #-16]
    a768:	e2433030 	sub	r3, r3, #48	; 0x30
    a76c:	ee073a90 	vmov	s15, r3
    a770:	eeb87be7 	vcvt.f64.s32	d7, s15
    a774:	ee367b07 	vadd.f64	d7, d6, d7
    a778:	eef77bc7 	vcvt.f32.f64	s15, d7
    a77c:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:70
    while ((c = *s++) != '\0' && isdigit(c)) {
    a780:	eaffffe0 	b	a708 <_Z4atofPKc+0x20>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:73
    }
    if (c == '.') {
    a784:	e51b3010 	ldr	r3, [fp, #-16]
    a788:	e353002e 	cmp	r3, #46	; 0x2e
    a78c:	1a000021 	bne	a818 <_Z4atofPKc+0x130>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:74
        while ((c = *s++) != '\0' && isdigit(c)) {
    a790:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a794:	e2832001 	add	r2, r3, #1
    a798:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a79c:	e5d33000 	ldrb	r3, [r3]
    a7a0:	e50b3010 	str	r3, [fp, #-16]
    a7a4:	e51b3010 	ldr	r3, [fp, #-16]
    a7a8:	e3530000 	cmp	r3, #0
    a7ac:	0a000007 	beq	a7d0 <_Z4atofPKc+0xe8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:74 (discriminator 1)
    a7b0:	e51b3010 	ldr	r3, [fp, #-16]
    a7b4:	e353002f 	cmp	r3, #47	; 0x2f
    a7b8:	da000004 	ble	a7d0 <_Z4atofPKc+0xe8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:74 (discriminator 3)
    a7bc:	e51b3010 	ldr	r3, [fp, #-16]
    a7c0:	e3530039 	cmp	r3, #57	; 0x39
    a7c4:	ca000001 	bgt	a7d0 <_Z4atofPKc+0xe8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:74 (discriminator 5)
    a7c8:	e3a03001 	mov	r3, #1
    a7cc:	ea000000 	b	a7d4 <_Z4atofPKc+0xec>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:74 (discriminator 6)
    a7d0:	e3a03000 	mov	r3, #0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:74 (discriminator 8)
    a7d4:	e3530000 	cmp	r3, #0
    a7d8:	0a00000e 	beq	a818 <_Z4atofPKc+0x130>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:75
            a = a * 10.0 + (c - '0');
    a7dc:	ed5b7a02 	vldr	s15, [fp, #-8]
    a7e0:	eeb77ae7 	vcvt.f64.f32	d7, s15
    a7e4:	ed9f6b67 	vldr	d6, [pc, #412]	; a988 <_Z4atofPKc+0x2a0>
    a7e8:	ee276b06 	vmul.f64	d6, d7, d6
    a7ec:	e51b3010 	ldr	r3, [fp, #-16]
    a7f0:	e2433030 	sub	r3, r3, #48	; 0x30
    a7f4:	ee073a90 	vmov	s15, r3
    a7f8:	eeb87be7 	vcvt.f64.s32	d7, s15
    a7fc:	ee367b07 	vadd.f64	d7, d6, d7
    a800:	eef77bc7 	vcvt.f32.f64	s15, d7
    a804:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:76
            e = e - 1;
    a808:	e51b300c 	ldr	r3, [fp, #-12]
    a80c:	e2433001 	sub	r3, r3, #1
    a810:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:74
        while ((c = *s++) != '\0' && isdigit(c)) {
    a814:	eaffffdd 	b	a790 <_Z4atofPKc+0xa8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:79
        }
    }
    if (c == 'e' || c == 'E') {
    a818:	e51b3010 	ldr	r3, [fp, #-16]
    a81c:	e3530065 	cmp	r3, #101	; 0x65
    a820:	0a000002 	beq	a830 <_Z4atofPKc+0x148>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:79 (discriminator 1)
    a824:	e51b3010 	ldr	r3, [fp, #-16]
    a828:	e3530045 	cmp	r3, #69	; 0x45
    a82c:	1a000037 	bne	a910 <_Z4atofPKc+0x228>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:80
        int sign = 1;
    a830:	e3a03001 	mov	r3, #1
    a834:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:81
        int i = 0;
    a838:	e3a03000 	mov	r3, #0
    a83c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:82
        c = *s++;
    a840:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a844:	e2832001 	add	r2, r3, #1
    a848:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a84c:	e5d33000 	ldrb	r3, [r3]
    a850:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:83
        if (c == '+')
    a854:	e51b3010 	ldr	r3, [fp, #-16]
    a858:	e353002b 	cmp	r3, #43	; 0x2b
    a85c:	1a000005 	bne	a878 <_Z4atofPKc+0x190>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:84
            c = *s++;
    a860:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a864:	e2832001 	add	r2, r3, #1
    a868:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a86c:	e5d33000 	ldrb	r3, [r3]
    a870:	e50b3010 	str	r3, [fp, #-16]
    a874:	ea000009 	b	a8a0 <_Z4atofPKc+0x1b8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:85
        else if (c == '-') {
    a878:	e51b3010 	ldr	r3, [fp, #-16]
    a87c:	e353002d 	cmp	r3, #45	; 0x2d
    a880:	1a000006 	bne	a8a0 <_Z4atofPKc+0x1b8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:86
            c = *s++;
    a884:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a888:	e2832001 	add	r2, r3, #1
    a88c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a890:	e5d33000 	ldrb	r3, [r3]
    a894:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:87
            sign = -1;
    a898:	e3e03000 	mvn	r3, #0
    a89c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:89
        }
        while (isdigit(c)) {
    a8a0:	e51b3010 	ldr	r3, [fp, #-16]
    a8a4:	e353002f 	cmp	r3, #47	; 0x2f
    a8a8:	da000012 	ble	a8f8 <_Z4atofPKc+0x210>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:89 (discriminator 1)
    a8ac:	e51b3010 	ldr	r3, [fp, #-16]
    a8b0:	e3530039 	cmp	r3, #57	; 0x39
    a8b4:	ca00000f 	bgt	a8f8 <_Z4atofPKc+0x210>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:90
            i = i * 10 + (c - '0');
    a8b8:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    a8bc:	e1a03002 	mov	r3, r2
    a8c0:	e1a03103 	lsl	r3, r3, #2
    a8c4:	e0833002 	add	r3, r3, r2
    a8c8:	e1a03083 	lsl	r3, r3, #1
    a8cc:	e1a02003 	mov	r2, r3
    a8d0:	e51b3010 	ldr	r3, [fp, #-16]
    a8d4:	e2433030 	sub	r3, r3, #48	; 0x30
    a8d8:	e0823003 	add	r3, r2, r3
    a8dc:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:91
            c = *s++;
    a8e0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a8e4:	e2832001 	add	r2, r3, #1
    a8e8:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a8ec:	e5d33000 	ldrb	r3, [r3]
    a8f0:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:89
        while (isdigit(c)) {
    a8f4:	eaffffe9 	b	a8a0 <_Z4atofPKc+0x1b8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:93
        }
        e += i * sign;
    a8f8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a8fc:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a900:	e0030392 	mul	r3, r2, r3
    a904:	e51b200c 	ldr	r2, [fp, #-12]
    a908:	e0823003 	add	r3, r2, r3
    a90c:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:95
    }
    while (e > 0) {
    a910:	e51b300c 	ldr	r3, [fp, #-12]
    a914:	e3530000 	cmp	r3, #0
    a918:	da000007 	ble	a93c <_Z4atofPKc+0x254>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:96
        a *= 10.0;
    a91c:	ed5b7a02 	vldr	s15, [fp, #-8]
    a920:	ed9f7a1c 	vldr	s14, [pc, #112]	; a998 <_Z4atofPKc+0x2b0>
    a924:	ee677a87 	vmul.f32	s15, s15, s14
    a928:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:97
        e--;
    a92c:	e51b300c 	ldr	r3, [fp, #-12]
    a930:	e2433001 	sub	r3, r3, #1
    a934:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:95
    while (e > 0) {
    a938:	eafffff4 	b	a910 <_Z4atofPKc+0x228>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:99
    }
    while (e < 0) {
    a93c:	e51b300c 	ldr	r3, [fp, #-12]
    a940:	e3530000 	cmp	r3, #0
    a944:	aa000009 	bge	a970 <_Z4atofPKc+0x288>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:100
        a *= 0.1;
    a948:	ed5b7a02 	vldr	s15, [fp, #-8]
    a94c:	eeb77ae7 	vcvt.f64.f32	d7, s15
    a950:	ed9f6b0e 	vldr	d6, [pc, #56]	; a990 <_Z4atofPKc+0x2a8>
    a954:	ee277b06 	vmul.f64	d7, d7, d6
    a958:	eef77bc7 	vcvt.f32.f64	s15, d7
    a95c:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:101
        e++;
    a960:	e51b300c 	ldr	r3, [fp, #-12]
    a964:	e2833001 	add	r3, r3, #1
    a968:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:99
    while (e < 0) {
    a96c:	eafffff2 	b	a93c <_Z4atofPKc+0x254>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:103
    }
    return a;
    a970:	e51b3008 	ldr	r3, [fp, #-8]
    a974:	ee073a90 	vmov	s15, r3
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:104
}
    a978:	eeb00a67 	vmov.f32	s0, s15
    a97c:	e28bd000 	add	sp, fp, #0
    a980:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a984:	e12fff1e 	bx	lr
    a988:	00000000 	andeq	r0, r0, r0
    a98c:	40240000 	eormi	r0, r4, r0
    a990:	9999999a 	ldmibls	r9, {r1, r3, r4, r7, r8, fp, ip, pc}
    a994:	3fb99999 	svccc	0x00b99999
    a998:	41200000 			; <UNDEFINED> instruction: 0x41200000

0000a99c <_Z4itoajPcj>:
_Z4itoajPcj():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:106

void itoa(unsigned int input, char *output, unsigned int base) {
    a99c:	e92d4800 	push	{fp, lr}
    a9a0:	e28db004 	add	fp, sp, #4
    a9a4:	e24dd020 	sub	sp, sp, #32
    a9a8:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    a9ac:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    a9b0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:107
    int i = 0;
    a9b4:	e3a03000 	mov	r3, #0
    a9b8:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:109

    while (input > 0) {
    a9bc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a9c0:	e3530000 	cmp	r3, #0
    a9c4:	0a000014 	beq	aa1c <_Z4itoajPcj+0x80>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:110
        output[i] = CharConvArr[input % base];
    a9c8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a9cc:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    a9d0:	e1a00003 	mov	r0, r3
    a9d4:	eb000283 	bl	b3e8 <__aeabi_uidivmod>
    a9d8:	e1a03001 	mov	r3, r1
    a9dc:	e1a01003 	mov	r1, r3
    a9e0:	e51b3008 	ldr	r3, [fp, #-8]
    a9e4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a9e8:	e0823003 	add	r3, r2, r3
    a9ec:	e59f2118 	ldr	r2, [pc, #280]	; ab0c <_Z4itoajPcj+0x170>
    a9f0:	e7d22001 	ldrb	r2, [r2, r1]
    a9f4:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:111
        input /= base;
    a9f8:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    a9fc:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    aa00:	eb0001fd 	bl	b1fc <__udivsi3>
    aa04:	e1a03000 	mov	r3, r0
    aa08:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:112
        i++;
    aa0c:	e51b3008 	ldr	r3, [fp, #-8]
    aa10:	e2833001 	add	r3, r3, #1
    aa14:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:109
    while (input > 0) {
    aa18:	eaffffe7 	b	a9bc <_Z4itoajPcj+0x20>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:115
    }

    if (i == 0) {
    aa1c:	e51b3008 	ldr	r3, [fp, #-8]
    aa20:	e3530000 	cmp	r3, #0
    aa24:	1a000007 	bne	aa48 <_Z4itoajPcj+0xac>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:116
        output[i] = CharConvArr[0];
    aa28:	e51b3008 	ldr	r3, [fp, #-8]
    aa2c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    aa30:	e0823003 	add	r3, r2, r3
    aa34:	e3a02030 	mov	r2, #48	; 0x30
    aa38:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:117
        i++;
    aa3c:	e51b3008 	ldr	r3, [fp, #-8]
    aa40:	e2833001 	add	r3, r3, #1
    aa44:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:120
    }

    output[i] = '\0';
    aa48:	e51b3008 	ldr	r3, [fp, #-8]
    aa4c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    aa50:	e0823003 	add	r3, r2, r3
    aa54:	e3a02000 	mov	r2, #0
    aa58:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:121
    i--;
    aa5c:	e51b3008 	ldr	r3, [fp, #-8]
    aa60:	e2433001 	sub	r3, r3, #1
    aa64:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:123

    for (int j = 0; j <= i / 2; j++) {
    aa68:	e3a03000 	mov	r3, #0
    aa6c:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:123 (discriminator 3)
    aa70:	e51b3008 	ldr	r3, [fp, #-8]
    aa74:	e1a02fa3 	lsr	r2, r3, #31
    aa78:	e0823003 	add	r3, r2, r3
    aa7c:	e1a030c3 	asr	r3, r3, #1
    aa80:	e1a02003 	mov	r2, r3
    aa84:	e51b300c 	ldr	r3, [fp, #-12]
    aa88:	e1530002 	cmp	r3, r2
    aa8c:	ca00001b 	bgt	ab00 <_Z4itoajPcj+0x164>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:124 (discriminator 2)
        char c = output[i - j];
    aa90:	e51b2008 	ldr	r2, [fp, #-8]
    aa94:	e51b300c 	ldr	r3, [fp, #-12]
    aa98:	e0423003 	sub	r3, r2, r3
    aa9c:	e1a02003 	mov	r2, r3
    aaa0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    aaa4:	e0833002 	add	r3, r3, r2
    aaa8:	e5d33000 	ldrb	r3, [r3]
    aaac:	e54b300d 	strb	r3, [fp, #-13]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:125 (discriminator 2)
        output[i - j] = output[j];
    aab0:	e51b300c 	ldr	r3, [fp, #-12]
    aab4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    aab8:	e0822003 	add	r2, r2, r3
    aabc:	e51b1008 	ldr	r1, [fp, #-8]
    aac0:	e51b300c 	ldr	r3, [fp, #-12]
    aac4:	e0413003 	sub	r3, r1, r3
    aac8:	e1a01003 	mov	r1, r3
    aacc:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    aad0:	e0833001 	add	r3, r3, r1
    aad4:	e5d22000 	ldrb	r2, [r2]
    aad8:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:126 (discriminator 2)
        output[j] = c;
    aadc:	e51b300c 	ldr	r3, [fp, #-12]
    aae0:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    aae4:	e0823003 	add	r3, r2, r3
    aae8:	e55b200d 	ldrb	r2, [fp, #-13]
    aaec:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:123 (discriminator 2)
    for (int j = 0; j <= i / 2; j++) {
    aaf0:	e51b300c 	ldr	r3, [fp, #-12]
    aaf4:	e2833001 	add	r3, r3, #1
    aaf8:	e50b300c 	str	r3, [fp, #-12]
    aafc:	eaffffdb 	b	aa70 <_Z4itoajPcj+0xd4>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:128
    }
}
    ab00:	e320f000 	nop	{0}
    ab04:	e24bd004 	sub	sp, fp, #4
    ab08:	e8bd8800 	pop	{fp, pc}
    ab0c:	0000bdb4 			; <UNDEFINED> instruction: 0x0000bdb4

0000ab10 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:130

int atoi(const char *input) {
    ab10:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    ab14:	e28db000 	add	fp, sp, #0
    ab18:	e24dd014 	sub	sp, sp, #20
    ab1c:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:131
    int output = 0;
    ab20:	e3a03000 	mov	r3, #0
    ab24:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:133

    while (*input != '\0') {
    ab28:	e51b3010 	ldr	r3, [fp, #-16]
    ab2c:	e5d33000 	ldrb	r3, [r3]
    ab30:	e3530000 	cmp	r3, #0
    ab34:	0a000017 	beq	ab98 <_Z4atoiPKc+0x88>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:134
        output *= 10;
    ab38:	e51b2008 	ldr	r2, [fp, #-8]
    ab3c:	e1a03002 	mov	r3, r2
    ab40:	e1a03103 	lsl	r3, r3, #2
    ab44:	e0833002 	add	r3, r3, r2
    ab48:	e1a03083 	lsl	r3, r3, #1
    ab4c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:135
        if (*input > '9' || *input < '0')
    ab50:	e51b3010 	ldr	r3, [fp, #-16]
    ab54:	e5d33000 	ldrb	r3, [r3]
    ab58:	e3530039 	cmp	r3, #57	; 0x39
    ab5c:	8a00000d 	bhi	ab98 <_Z4atoiPKc+0x88>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:135 (discriminator 1)
    ab60:	e51b3010 	ldr	r3, [fp, #-16]
    ab64:	e5d33000 	ldrb	r3, [r3]
    ab68:	e353002f 	cmp	r3, #47	; 0x2f
    ab6c:	9a000009 	bls	ab98 <_Z4atoiPKc+0x88>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:138
            break;

        output += *input - '0';
    ab70:	e51b3010 	ldr	r3, [fp, #-16]
    ab74:	e5d33000 	ldrb	r3, [r3]
    ab78:	e2433030 	sub	r3, r3, #48	; 0x30
    ab7c:	e51b2008 	ldr	r2, [fp, #-8]
    ab80:	e0823003 	add	r3, r2, r3
    ab84:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:140

        input++;
    ab88:	e51b3010 	ldr	r3, [fp, #-16]
    ab8c:	e2833001 	add	r3, r3, #1
    ab90:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:133
    while (*input != '\0') {
    ab94:	eaffffe3 	b	ab28 <_Z4atoiPKc+0x18>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:143
    }

    return output;
    ab98:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:144
}
    ab9c:	e1a00003 	mov	r0, r3
    aba0:	e28bd000 	add	sp, fp, #0
    aba4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    aba8:	e12fff1e 	bx	lr

0000abac <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:146

char *strncpy(char *dest, const char *src, int num) {
    abac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    abb0:	e28db000 	add	fp, sp, #0
    abb4:	e24dd01c 	sub	sp, sp, #28
    abb8:	e50b0010 	str	r0, [fp, #-16]
    abbc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    abc0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:149
    int i;

    for (i = 0; i < num && src[i] != '\0'; i++)
    abc4:	e3a03000 	mov	r3, #0
    abc8:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:149 (discriminator 4)
    abcc:	e51b2008 	ldr	r2, [fp, #-8]
    abd0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    abd4:	e1520003 	cmp	r2, r3
    abd8:	aa000011 	bge	ac24 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:149 (discriminator 2)
    abdc:	e51b3008 	ldr	r3, [fp, #-8]
    abe0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    abe4:	e0823003 	add	r3, r2, r3
    abe8:	e5d33000 	ldrb	r3, [r3]
    abec:	e3530000 	cmp	r3, #0
    abf0:	0a00000b 	beq	ac24 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:150 (discriminator 3)
        dest[i] = src[i];
    abf4:	e51b3008 	ldr	r3, [fp, #-8]
    abf8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    abfc:	e0822003 	add	r2, r2, r3
    ac00:	e51b3008 	ldr	r3, [fp, #-8]
    ac04:	e51b1010 	ldr	r1, [fp, #-16]
    ac08:	e0813003 	add	r3, r1, r3
    ac0c:	e5d22000 	ldrb	r2, [r2]
    ac10:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:149 (discriminator 3)
    for (i = 0; i < num && src[i] != '\0'; i++)
    ac14:	e51b3008 	ldr	r3, [fp, #-8]
    ac18:	e2833001 	add	r3, r3, #1
    ac1c:	e50b3008 	str	r3, [fp, #-8]
    ac20:	eaffffe9 	b	abcc <_Z7strncpyPcPKci+0x20>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:151 (discriminator 2)
    for (; i < num; i++)
    ac24:	e51b2008 	ldr	r2, [fp, #-8]
    ac28:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    ac2c:	e1520003 	cmp	r2, r3
    ac30:	aa000008 	bge	ac58 <_Z7strncpyPcPKci+0xac>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:152 (discriminator 1)
        dest[i] = '\0';
    ac34:	e51b3008 	ldr	r3, [fp, #-8]
    ac38:	e51b2010 	ldr	r2, [fp, #-16]
    ac3c:	e0823003 	add	r3, r2, r3
    ac40:	e3a02000 	mov	r2, #0
    ac44:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:151 (discriminator 1)
    for (; i < num; i++)
    ac48:	e51b3008 	ldr	r3, [fp, #-8]
    ac4c:	e2833001 	add	r3, r3, #1
    ac50:	e50b3008 	str	r3, [fp, #-8]
    ac54:	eafffff2 	b	ac24 <_Z7strncpyPcPKci+0x78>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:154

    return dest;
    ac58:	e51b3010 	ldr	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:155
}
    ac5c:	e1a00003 	mov	r0, r3
    ac60:	e28bd000 	add	sp, fp, #0
    ac64:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    ac68:	e12fff1e 	bx	lr

0000ac6c <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:157

int strncmp(const char *s1, const char *s2, int num) {
    ac6c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    ac70:	e28db000 	add	fp, sp, #0
    ac74:	e24dd01c 	sub	sp, sp, #28
    ac78:	e50b0010 	str	r0, [fp, #-16]
    ac7c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    ac80:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:159
    unsigned char u1, u2;
    while (num-- > 0) {
    ac84:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    ac88:	e2432001 	sub	r2, r3, #1
    ac8c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    ac90:	e3530000 	cmp	r3, #0
    ac94:	c3a03001 	movgt	r3, #1
    ac98:	d3a03000 	movle	r3, #0
    ac9c:	e6ef3073 	uxtb	r3, r3
    aca0:	e3530000 	cmp	r3, #0
    aca4:	0a000016 	beq	ad04 <_Z7strncmpPKcS0_i+0x98>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:160
        u1 = (unsigned char) *s1++;
    aca8:	e51b3010 	ldr	r3, [fp, #-16]
    acac:	e2832001 	add	r2, r3, #1
    acb0:	e50b2010 	str	r2, [fp, #-16]
    acb4:	e5d33000 	ldrb	r3, [r3]
    acb8:	e54b3005 	strb	r3, [fp, #-5]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:161
        u2 = (unsigned char) *s2++;
    acbc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    acc0:	e2832001 	add	r2, r3, #1
    acc4:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    acc8:	e5d33000 	ldrb	r3, [r3]
    accc:	e54b3006 	strb	r3, [fp, #-6]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:162
        if (u1 != u2)
    acd0:	e55b2005 	ldrb	r2, [fp, #-5]
    acd4:	e55b3006 	ldrb	r3, [fp, #-6]
    acd8:	e1520003 	cmp	r2, r3
    acdc:	0a000003 	beq	acf0 <_Z7strncmpPKcS0_i+0x84>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:163
            return u1 - u2;
    ace0:	e55b2005 	ldrb	r2, [fp, #-5]
    ace4:	e55b3006 	ldrb	r3, [fp, #-6]
    ace8:	e0423003 	sub	r3, r2, r3
    acec:	ea000005 	b	ad08 <_Z7strncmpPKcS0_i+0x9c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:164
        if (u1 == '\0')
    acf0:	e55b3005 	ldrb	r3, [fp, #-5]
    acf4:	e3530000 	cmp	r3, #0
    acf8:	1affffe1 	bne	ac84 <_Z7strncmpPKcS0_i+0x18>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:165
            return 0;
    acfc:	e3a03000 	mov	r3, #0
    ad00:	ea000000 	b	ad08 <_Z7strncmpPKcS0_i+0x9c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:168
    }

    return 0;
    ad04:	e3a03000 	mov	r3, #0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:169
}
    ad08:	e1a00003 	mov	r0, r3
    ad0c:	e28bd000 	add	sp, fp, #0
    ad10:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    ad14:	e12fff1e 	bx	lr

0000ad18 <_Z6strlenPKc>:
_Z6strlenPKc():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:171

int strlen(const char *s) {
    ad18:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    ad1c:	e28db000 	add	fp, sp, #0
    ad20:	e24dd014 	sub	sp, sp, #20
    ad24:	e50b0010 	str	r0, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:172
    int i = 0;
    ad28:	e3a03000 	mov	r3, #0
    ad2c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:174

    while (s[i] != '\0')
    ad30:	e51b3008 	ldr	r3, [fp, #-8]
    ad34:	e51b2010 	ldr	r2, [fp, #-16]
    ad38:	e0823003 	add	r3, r2, r3
    ad3c:	e5d33000 	ldrb	r3, [r3]
    ad40:	e3530000 	cmp	r3, #0
    ad44:	0a000003 	beq	ad58 <_Z6strlenPKc+0x40>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:175
        i++;
    ad48:	e51b3008 	ldr	r3, [fp, #-8]
    ad4c:	e2833001 	add	r3, r3, #1
    ad50:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:174
    while (s[i] != '\0')
    ad54:	eafffff5 	b	ad30 <_Z6strlenPKc+0x18>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:177

    return i;
    ad58:	e51b3008 	ldr	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:178
}
    ad5c:	e1a00003 	mov	r0, r3
    ad60:	e28bd000 	add	sp, fp, #0
    ad64:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    ad68:	e12fff1e 	bx	lr

0000ad6c <_Z9constainsPKcc>:
_Z9constainsPKcc():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:180

bool constains(const char *source, const char target) {
    ad6c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    ad70:	e28db000 	add	fp, sp, #0
    ad74:	e24dd014 	sub	sp, sp, #20
    ad78:	e50b0010 	str	r0, [fp, #-16]
    ad7c:	e1a03001 	mov	r3, r1
    ad80:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:181
    int i = 0;
    ad84:	e3a03000 	mov	r3, #0
    ad88:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:183

    while (source[i] != '\0') {
    ad8c:	e51b3008 	ldr	r3, [fp, #-8]
    ad90:	e51b2010 	ldr	r2, [fp, #-16]
    ad94:	e0823003 	add	r3, r2, r3
    ad98:	e5d33000 	ldrb	r3, [r3]
    ad9c:	e3530000 	cmp	r3, #0
    ada0:	0a00000c 	beq	add8 <_Z9constainsPKcc+0x6c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:184
        if (source[i] == target)
    ada4:	e51b3008 	ldr	r3, [fp, #-8]
    ada8:	e51b2010 	ldr	r2, [fp, #-16]
    adac:	e0823003 	add	r3, r2, r3
    adb0:	e5d33000 	ldrb	r3, [r3]
    adb4:	e55b2011 	ldrb	r2, [fp, #-17]	; 0xffffffef
    adb8:	e1520003 	cmp	r2, r3
    adbc:	1a000001 	bne	adc8 <_Z9constainsPKcc+0x5c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:185
            return true;
    adc0:	e3a03001 	mov	r3, #1
    adc4:	ea000004 	b	addc <_Z9constainsPKcc+0x70>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:186
        i++;
    adc8:	e51b3008 	ldr	r3, [fp, #-8]
    adcc:	e2833001 	add	r3, r3, #1
    add0:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:183
    while (source[i] != '\0') {
    add4:	eaffffec 	b	ad8c <_Z9constainsPKcc+0x20>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:188
    }
    return false;
    add8:	e3a03000 	mov	r3, #0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:189
}
    addc:	e1a00003 	mov	r0, r3
    ade0:	e28bd000 	add	sp, fp, #0
    ade4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    ade8:	e12fff1e 	bx	lr

0000adec <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:191

void bzero(void *memory, int length) {
    adec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    adf0:	e28db000 	add	fp, sp, #0
    adf4:	e24dd014 	sub	sp, sp, #20
    adf8:	e50b0010 	str	r0, [fp, #-16]
    adfc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:192
    char *mem = reinterpret_cast<char *>(memory);
    ae00:	e51b3010 	ldr	r3, [fp, #-16]
    ae04:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:194

    for (int i = 0; i < length; i++)
    ae08:	e3a03000 	mov	r3, #0
    ae0c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:194 (discriminator 3)
    ae10:	e51b2008 	ldr	r2, [fp, #-8]
    ae14:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    ae18:	e1520003 	cmp	r2, r3
    ae1c:	aa000008 	bge	ae44 <_Z5bzeroPvi+0x58>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:195 (discriminator 2)
        mem[i] = 0;
    ae20:	e51b3008 	ldr	r3, [fp, #-8]
    ae24:	e51b200c 	ldr	r2, [fp, #-12]
    ae28:	e0823003 	add	r3, r2, r3
    ae2c:	e3a02000 	mov	r2, #0
    ae30:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:194 (discriminator 2)
    for (int i = 0; i < length; i++)
    ae34:	e51b3008 	ldr	r3, [fp, #-8]
    ae38:	e2833001 	add	r3, r3, #1
    ae3c:	e50b3008 	str	r3, [fp, #-8]
    ae40:	eafffff2 	b	ae10 <_Z5bzeroPvi+0x24>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:196
}
    ae44:	e320f000 	nop	{0}
    ae48:	e28bd000 	add	sp, fp, #0
    ae4c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    ae50:	e12fff1e 	bx	lr

0000ae54 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:198

void memcpy(const void *src, void *dst, int num) {
    ae54:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    ae58:	e28db000 	add	fp, sp, #0
    ae5c:	e24dd024 	sub	sp, sp, #36	; 0x24
    ae60:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    ae64:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    ae68:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:199
    const char *memsrc = reinterpret_cast<const char *>(src);
    ae6c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    ae70:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:200
    char *memdst = reinterpret_cast<char *>(dst);
    ae74:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    ae78:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:202

    for (int i = 0; i < num; i++)
    ae7c:	e3a03000 	mov	r3, #0
    ae80:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:202 (discriminator 3)
    ae84:	e51b2008 	ldr	r2, [fp, #-8]
    ae88:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    ae8c:	e1520003 	cmp	r2, r3
    ae90:	aa00000b 	bge	aec4 <_Z6memcpyPKvPvi+0x70>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:203 (discriminator 2)
        memdst[i] = memsrc[i];
    ae94:	e51b3008 	ldr	r3, [fp, #-8]
    ae98:	e51b200c 	ldr	r2, [fp, #-12]
    ae9c:	e0822003 	add	r2, r2, r3
    aea0:	e51b3008 	ldr	r3, [fp, #-8]
    aea4:	e51b1010 	ldr	r1, [fp, #-16]
    aea8:	e0813003 	add	r3, r1, r3
    aeac:	e5d22000 	ldrb	r2, [r2]
    aeb0:	e5c32000 	strb	r2, [r3]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:202 (discriminator 2)
    for (int i = 0; i < num; i++)
    aeb4:	e51b3008 	ldr	r3, [fp, #-8]
    aeb8:	e2833001 	add	r3, r3, #1
    aebc:	e50b3008 	str	r3, [fp, #-8]
    aec0:	eaffffef 	b	ae84 <_Z6memcpyPKvPvi+0x30>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:204
}
    aec4:	e320f000 	nop	{0}
    aec8:	e28bd000 	add	sp, fp, #0
    aecc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    aed0:	e12fff1e 	bx	lr

0000aed4 <_Z8is_digitc>:
_Z8is_digitc():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:206

bool is_digit(char c) {
    aed4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    aed8:	e28db000 	add	fp, sp, #0
    aedc:	e24dd00c 	sub	sp, sp, #12
    aee0:	e1a03000 	mov	r3, r0
    aee4:	e54b3005 	strb	r3, [fp, #-5]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:207
    return (c >= '0') && (c <= '9');
    aee8:	e55b3005 	ldrb	r3, [fp, #-5]
    aeec:	e353002f 	cmp	r3, #47	; 0x2f
    aef0:	9a000004 	bls	af08 <_Z8is_digitc+0x34>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:207 (discriminator 1)
    aef4:	e55b3005 	ldrb	r3, [fp, #-5]
    aef8:	e3530039 	cmp	r3, #57	; 0x39
    aefc:	8a000001 	bhi	af08 <_Z8is_digitc+0x34>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:207 (discriminator 3)
    af00:	e3a03001 	mov	r3, #1
    af04:	ea000000 	b	af0c <_Z8is_digitc+0x38>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:207 (discriminator 4)
    af08:	e3a03000 	mov	r3, #0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:208 (discriminator 6)
}
    af0c:	e1a00003 	mov	r0, r3
    af10:	e28bd000 	add	sp, fp, #0
    af14:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    af18:	e12fff1e 	bx	lr

0000af1c <_Z10is_decimalPKc>:
_Z10is_decimalPKc():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:210

bool is_decimal(const char *str) {
    af1c:	e92d4800 	push	{fp, lr}
    af20:	e28db004 	add	fp, sp, #4
    af24:	e24dd018 	sub	sp, sp, #24
    af28:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:211
    char c = str[0];
    af2c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    af30:	e5d33000 	ldrb	r3, [r3]
    af34:	e54b300d 	strb	r3, [fp, #-13]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:212
    if (c == '\0') return false;
    af38:	e55b300d 	ldrb	r3, [fp, #-13]
    af3c:	e3530000 	cmp	r3, #0
    af40:	1a000001 	bne	af4c <_Z10is_decimalPKc+0x30>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:212 (discriminator 1)
    af44:	e3a03000 	mov	r3, #0
    af48:	ea000036 	b	b028 <_Z10is_decimalPKc+0x10c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:214

    int size = 0;
    af4c:	e3a03000 	mov	r3, #0
    af50:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:216

    if (!is_digit(c)) {
    af54:	e55b300d 	ldrb	r3, [fp, #-13]
    af58:	e1a00003 	mov	r0, r3
    af5c:	ebffffdc 	bl	aed4 <_Z8is_digitc>
    af60:	e1a03000 	mov	r3, r0
    af64:	e2233001 	eor	r3, r3, #1
    af68:	e6ef3073 	uxtb	r3, r3
    af6c:	e3530000 	cmp	r3, #0
    af70:	0a000007 	beq	af94 <_Z10is_decimalPKc+0x78>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:217
        if (c != '+' && c != '-') {
    af74:	e55b300d 	ldrb	r3, [fp, #-13]
    af78:	e353002b 	cmp	r3, #43	; 0x2b
    af7c:	0a000007 	beq	afa0 <_Z10is_decimalPKc+0x84>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:217 (discriminator 1)
    af80:	e55b300d 	ldrb	r3, [fp, #-13]
    af84:	e353002d 	cmp	r3, #45	; 0x2d
    af88:	0a000004 	beq	afa0 <_Z10is_decimalPKc+0x84>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:218
            return false;
    af8c:	e3a03000 	mov	r3, #0
    af90:	ea000024 	b	b028 <_Z10is_decimalPKc+0x10c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:221
        }
    } else {
        size++;
    af94:	e51b3008 	ldr	r3, [fp, #-8]
    af98:	e2833001 	add	r3, r3, #1
    af9c:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:224
    }

    int i = 1;
    afa0:	e3a03001 	mov	r3, #1
    afa4:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:225
    while (str[i] != '\0') {
    afa8:	e51b300c 	ldr	r3, [fp, #-12]
    afac:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    afb0:	e0823003 	add	r3, r2, r3
    afb4:	e5d33000 	ldrb	r3, [r3]
    afb8:	e3530000 	cmp	r3, #0
    afbc:	0a000013 	beq	b010 <_Z10is_decimalPKc+0xf4>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:226
        if (!is_digit(str[i])) {
    afc0:	e51b300c 	ldr	r3, [fp, #-12]
    afc4:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    afc8:	e0823003 	add	r3, r2, r3
    afcc:	e5d33000 	ldrb	r3, [r3]
    afd0:	e1a00003 	mov	r0, r3
    afd4:	ebffffbe 	bl	aed4 <_Z8is_digitc>
    afd8:	e1a03000 	mov	r3, r0
    afdc:	e2233001 	eor	r3, r3, #1
    afe0:	e6ef3073 	uxtb	r3, r3
    afe4:	e3530000 	cmp	r3, #0
    afe8:	0a000001 	beq	aff4 <_Z10is_decimalPKc+0xd8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:227
            return false;
    afec:	e3a03000 	mov	r3, #0
    aff0:	ea00000c 	b	b028 <_Z10is_decimalPKc+0x10c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:229
        }
        size++;
    aff4:	e51b3008 	ldr	r3, [fp, #-8]
    aff8:	e2833001 	add	r3, r3, #1
    affc:	e50b3008 	str	r3, [fp, #-8]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:230
        i++;
    b000:	e51b300c 	ldr	r3, [fp, #-12]
    b004:	e2833001 	add	r3, r3, #1
    b008:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:225
    while (str[i] != '\0') {
    b00c:	eaffffe5 	b	afa8 <_Z10is_decimalPKc+0x8c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:233
    }

    if (size == 0) {
    b010:	e51b3008 	ldr	r3, [fp, #-8]
    b014:	e3530000 	cmp	r3, #0
    b018:	1a000001 	bne	b024 <_Z10is_decimalPKc+0x108>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:234
        return false;
    b01c:	e3a03000 	mov	r3, #0
    b020:	ea000000 	b	b028 <_Z10is_decimalPKc+0x10c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:237
    }

    return true;
    b024:	e3a03001 	mov	r3, #1
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:238
}
    b028:	e1a00003 	mov	r0, r3
    b02c:	e24bd004 	sub	sp, fp, #4
    b030:	e8bd8800 	pop	{fp, pc}

0000b034 <_Z8is_floatPKc>:
_Z8is_floatPKc():
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:240

bool is_float(const char *str) {
    b034:	e92d4800 	push	{fp, lr}
    b038:	e28db004 	add	fp, sp, #4
    b03c:	e24dd020 	sub	sp, sp, #32
    b040:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:241
    char c = str[0];
    b044:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    b048:	e5d33000 	ldrb	r3, [r3]
    b04c:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:242
    bool point = false;
    b050:	e3a03000 	mov	r3, #0
    b054:	e54b3005 	strb	r3, [fp, #-5]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:243
    int after_point = 0;
    b058:	e3a03000 	mov	r3, #0
    b05c:	e50b300c 	str	r3, [fp, #-12]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:244
    int before_point = 0;
    b060:	e3a03000 	mov	r3, #0
    b064:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:246

    if (c == '\0') return false;
    b068:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    b06c:	e3530000 	cmp	r3, #0
    b070:	1a000001 	bne	b07c <_Z8is_floatPKc+0x48>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:246 (discriminator 1)
    b074:	e3a03000 	mov	r3, #0
    b078:	ea00005c 	b	b1f0 <_Z8is_floatPKc+0x1bc>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:248

    if (c != '+' && c != '-' && !is_digit(c)) return false;
    b07c:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    b080:	e353002b 	cmp	r3, #43	; 0x2b
    b084:	0a00000c 	beq	b0bc <_Z8is_floatPKc+0x88>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:248 (discriminator 1)
    b088:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    b08c:	e353002d 	cmp	r3, #45	; 0x2d
    b090:	0a000009 	beq	b0bc <_Z8is_floatPKc+0x88>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:248 (discriminator 3)
    b094:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    b098:	e1a00003 	mov	r0, r3
    b09c:	ebffff8c 	bl	aed4 <_Z8is_digitc>
    b0a0:	e1a03000 	mov	r3, r0
    b0a4:	e2233001 	eor	r3, r3, #1
    b0a8:	e6ef3073 	uxtb	r3, r3
    b0ac:	e3530000 	cmp	r3, #0
    b0b0:	0a000001 	beq	b0bc <_Z8is_floatPKc+0x88>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:248 (discriminator 5)
    b0b4:	e3a03001 	mov	r3, #1
    b0b8:	ea000000 	b	b0c0 <_Z8is_floatPKc+0x8c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:248 (discriminator 6)
    b0bc:	e3a03000 	mov	r3, #0
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:248 (discriminator 8)
    b0c0:	e3530000 	cmp	r3, #0
    b0c4:	0a000001 	beq	b0d0 <_Z8is_floatPKc+0x9c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:248 (discriminator 9)
    b0c8:	e3a03000 	mov	r3, #0
    b0cc:	ea000047 	b	b1f0 <_Z8is_floatPKc+0x1bc>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:250

    if (is_digit(c)) {
    b0d0:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    b0d4:	e1a00003 	mov	r0, r3
    b0d8:	ebffff7d 	bl	aed4 <_Z8is_digitc>
    b0dc:	e1a03000 	mov	r3, r0
    b0e0:	e3530000 	cmp	r3, #0
    b0e4:	0a000002 	beq	b0f4 <_Z8is_floatPKc+0xc0>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:251
        before_point++;
    b0e8:	e51b3010 	ldr	r3, [fp, #-16]
    b0ec:	e2833001 	add	r3, r3, #1
    b0f0:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:254
    }

    int i = 1;
    b0f4:	e3a03001 	mov	r3, #1
    b0f8:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:255
    while (str[i] != '\0') {
    b0fc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    b100:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    b104:	e0823003 	add	r3, r2, r3
    b108:	e5d33000 	ldrb	r3, [r3]
    b10c:	e3530000 	cmp	r3, #0
    b110:	0a000028 	beq	b1b8 <_Z8is_floatPKc+0x184>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:256
        if (!is_digit(str[i])) {
    b114:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    b118:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    b11c:	e0823003 	add	r3, r2, r3
    b120:	e5d33000 	ldrb	r3, [r3]
    b124:	e1a00003 	mov	r0, r3
    b128:	ebffff69 	bl	aed4 <_Z8is_digitc>
    b12c:	e1a03000 	mov	r3, r0
    b130:	e2233001 	eor	r3, r3, #1
    b134:	e6ef3073 	uxtb	r3, r3
    b138:	e3530000 	cmp	r3, #0
    b13c:	0a00000f 	beq	b180 <_Z8is_floatPKc+0x14c>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:257
            if (str[i] == '.' && point == false) {
    b140:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    b144:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    b148:	e0823003 	add	r3, r2, r3
    b14c:	e5d33000 	ldrb	r3, [r3]
    b150:	e353002e 	cmp	r3, #46	; 0x2e
    b154:	1a000007 	bne	b178 <_Z8is_floatPKc+0x144>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:257 (discriminator 1)
    b158:	e55b3005 	ldrb	r3, [fp, #-5]
    b15c:	e2233001 	eor	r3, r3, #1
    b160:	e6ef3073 	uxtb	r3, r3
    b164:	e3530000 	cmp	r3, #0
    b168:	0a000002 	beq	b178 <_Z8is_floatPKc+0x144>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:258
                point = true;
    b16c:	e3a03001 	mov	r3, #1
    b170:	e54b3005 	strb	r3, [fp, #-5]
    b174:	ea00000b 	b	b1a8 <_Z8is_floatPKc+0x174>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:260
            } else {
                return false;
    b178:	e3a03000 	mov	r3, #0
    b17c:	ea00001b 	b	b1f0 <_Z8is_floatPKc+0x1bc>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:263
            }
        } else {
            if (point == true) {
    b180:	e55b3005 	ldrb	r3, [fp, #-5]
    b184:	e3530000 	cmp	r3, #0
    b188:	0a000003 	beq	b19c <_Z8is_floatPKc+0x168>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:264
                after_point++;
    b18c:	e51b300c 	ldr	r3, [fp, #-12]
    b190:	e2833001 	add	r3, r3, #1
    b194:	e50b300c 	str	r3, [fp, #-12]
    b198:	ea000002 	b	b1a8 <_Z8is_floatPKc+0x174>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:266
            } else {
                before_point++;
    b19c:	e51b3010 	ldr	r3, [fp, #-16]
    b1a0:	e2833001 	add	r3, r3, #1
    b1a4:	e50b3010 	str	r3, [fp, #-16]
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:269
            }
        }
        i++;
    b1a8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    b1ac:	e2833001 	add	r3, r3, #1
    b1b0:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:255
    while (str[i] != '\0') {
    b1b4:	eaffffd0 	b	b0fc <_Z8is_floatPKc+0xc8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:272
    }

    if (before_point < 0) {
    b1b8:	e51b3010 	ldr	r3, [fp, #-16]
    b1bc:	e3530000 	cmp	r3, #0
    b1c0:	aa000001 	bge	b1cc <_Z8is_floatPKc+0x198>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:273
        return false;
    b1c4:	e3a03000 	mov	r3, #0
    b1c8:	ea000008 	b	b1f0 <_Z8is_floatPKc+0x1bc>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:276
    }

    if (point == true && after_point == 0) {
    b1cc:	e55b3005 	ldrb	r3, [fp, #-5]
    b1d0:	e3530000 	cmp	r3, #0
    b1d4:	0a000004 	beq	b1ec <_Z8is_floatPKc+0x1b8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:276 (discriminator 1)
    b1d8:	e51b300c 	ldr	r3, [fp, #-12]
    b1dc:	e3530000 	cmp	r3, #0
    b1e0:	1a000001 	bne	b1ec <_Z8is_floatPKc+0x1b8>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:277
        return false;
    b1e4:	e3a03000 	mov	r3, #0
    b1e8:	ea000000 	b	b1f0 <_Z8is_floatPKc+0x1bc>
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:280
    }

    return true;
    b1ec:	e3a03001 	mov	r3, #1
/home/hintik/dev/final/src/sources/stdlib/src/stdstring.cpp:281
    b1f0:	e1a00003 	mov	r0, r3
    b1f4:	e24bd004 	sub	sp, fp, #4
    b1f8:	e8bd8800 	pop	{fp, pc}

0000b1fc <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1150
    b1fc:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1152
    b200:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1153
    b204:	3a000074 	bcc	b3dc <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1154
    b208:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1155
    b20c:	9a00006b 	bls	b3c0 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    b210:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    b214:	0a00006c 	beq	b3cc <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    b218:	e16f3f10 	clz	r3, r0
    b21c:	e16f2f11 	clz	r2, r1
    b220:	e0423003 	sub	r3, r2, r3
    b224:	e273301f 	rsbs	r3, r3, #31
    b228:	10833083 	addne	r3, r3, r3, lsl #1
    b22c:	e3a02000 	mov	r2, #0
    b230:	108ff103 	addne	pc, pc, r3, lsl #2
    b234:	e1a00000 	nop			; (mov r0, r0)
    b238:	e1500f81 	cmp	r0, r1, lsl #31
    b23c:	e0a22002 	adc	r2, r2, r2
    b240:	20400f81 	subcs	r0, r0, r1, lsl #31
    b244:	e1500f01 	cmp	r0, r1, lsl #30
    b248:	e0a22002 	adc	r2, r2, r2
    b24c:	20400f01 	subcs	r0, r0, r1, lsl #30
    b250:	e1500e81 	cmp	r0, r1, lsl #29
    b254:	e0a22002 	adc	r2, r2, r2
    b258:	20400e81 	subcs	r0, r0, r1, lsl #29
    b25c:	e1500e01 	cmp	r0, r1, lsl #28
    b260:	e0a22002 	adc	r2, r2, r2
    b264:	20400e01 	subcs	r0, r0, r1, lsl #28
    b268:	e1500d81 	cmp	r0, r1, lsl #27
    b26c:	e0a22002 	adc	r2, r2, r2
    b270:	20400d81 	subcs	r0, r0, r1, lsl #27
    b274:	e1500d01 	cmp	r0, r1, lsl #26
    b278:	e0a22002 	adc	r2, r2, r2
    b27c:	20400d01 	subcs	r0, r0, r1, lsl #26
    b280:	e1500c81 	cmp	r0, r1, lsl #25
    b284:	e0a22002 	adc	r2, r2, r2
    b288:	20400c81 	subcs	r0, r0, r1, lsl #25
    b28c:	e1500c01 	cmp	r0, r1, lsl #24
    b290:	e0a22002 	adc	r2, r2, r2
    b294:	20400c01 	subcs	r0, r0, r1, lsl #24
    b298:	e1500b81 	cmp	r0, r1, lsl #23
    b29c:	e0a22002 	adc	r2, r2, r2
    b2a0:	20400b81 	subcs	r0, r0, r1, lsl #23
    b2a4:	e1500b01 	cmp	r0, r1, lsl #22
    b2a8:	e0a22002 	adc	r2, r2, r2
    b2ac:	20400b01 	subcs	r0, r0, r1, lsl #22
    b2b0:	e1500a81 	cmp	r0, r1, lsl #21
    b2b4:	e0a22002 	adc	r2, r2, r2
    b2b8:	20400a81 	subcs	r0, r0, r1, lsl #21
    b2bc:	e1500a01 	cmp	r0, r1, lsl #20
    b2c0:	e0a22002 	adc	r2, r2, r2
    b2c4:	20400a01 	subcs	r0, r0, r1, lsl #20
    b2c8:	e1500981 	cmp	r0, r1, lsl #19
    b2cc:	e0a22002 	adc	r2, r2, r2
    b2d0:	20400981 	subcs	r0, r0, r1, lsl #19
    b2d4:	e1500901 	cmp	r0, r1, lsl #18
    b2d8:	e0a22002 	adc	r2, r2, r2
    b2dc:	20400901 	subcs	r0, r0, r1, lsl #18
    b2e0:	e1500881 	cmp	r0, r1, lsl #17
    b2e4:	e0a22002 	adc	r2, r2, r2
    b2e8:	20400881 	subcs	r0, r0, r1, lsl #17
    b2ec:	e1500801 	cmp	r0, r1, lsl #16
    b2f0:	e0a22002 	adc	r2, r2, r2
    b2f4:	20400801 	subcs	r0, r0, r1, lsl #16
    b2f8:	e1500781 	cmp	r0, r1, lsl #15
    b2fc:	e0a22002 	adc	r2, r2, r2
    b300:	20400781 	subcs	r0, r0, r1, lsl #15
    b304:	e1500701 	cmp	r0, r1, lsl #14
    b308:	e0a22002 	adc	r2, r2, r2
    b30c:	20400701 	subcs	r0, r0, r1, lsl #14
    b310:	e1500681 	cmp	r0, r1, lsl #13
    b314:	e0a22002 	adc	r2, r2, r2
    b318:	20400681 	subcs	r0, r0, r1, lsl #13
    b31c:	e1500601 	cmp	r0, r1, lsl #12
    b320:	e0a22002 	adc	r2, r2, r2
    b324:	20400601 	subcs	r0, r0, r1, lsl #12
    b328:	e1500581 	cmp	r0, r1, lsl #11
    b32c:	e0a22002 	adc	r2, r2, r2
    b330:	20400581 	subcs	r0, r0, r1, lsl #11
    b334:	e1500501 	cmp	r0, r1, lsl #10
    b338:	e0a22002 	adc	r2, r2, r2
    b33c:	20400501 	subcs	r0, r0, r1, lsl #10
    b340:	e1500481 	cmp	r0, r1, lsl #9
    b344:	e0a22002 	adc	r2, r2, r2
    b348:	20400481 	subcs	r0, r0, r1, lsl #9
    b34c:	e1500401 	cmp	r0, r1, lsl #8
    b350:	e0a22002 	adc	r2, r2, r2
    b354:	20400401 	subcs	r0, r0, r1, lsl #8
    b358:	e1500381 	cmp	r0, r1, lsl #7
    b35c:	e0a22002 	adc	r2, r2, r2
    b360:	20400381 	subcs	r0, r0, r1, lsl #7
    b364:	e1500301 	cmp	r0, r1, lsl #6
    b368:	e0a22002 	adc	r2, r2, r2
    b36c:	20400301 	subcs	r0, r0, r1, lsl #6
    b370:	e1500281 	cmp	r0, r1, lsl #5
    b374:	e0a22002 	adc	r2, r2, r2
    b378:	20400281 	subcs	r0, r0, r1, lsl #5
    b37c:	e1500201 	cmp	r0, r1, lsl #4
    b380:	e0a22002 	adc	r2, r2, r2
    b384:	20400201 	subcs	r0, r0, r1, lsl #4
    b388:	e1500181 	cmp	r0, r1, lsl #3
    b38c:	e0a22002 	adc	r2, r2, r2
    b390:	20400181 	subcs	r0, r0, r1, lsl #3
    b394:	e1500101 	cmp	r0, r1, lsl #2
    b398:	e0a22002 	adc	r2, r2, r2
    b39c:	20400101 	subcs	r0, r0, r1, lsl #2
    b3a0:	e1500081 	cmp	r0, r1, lsl #1
    b3a4:	e0a22002 	adc	r2, r2, r2
    b3a8:	20400081 	subcs	r0, r0, r1, lsl #1
    b3ac:	e1500001 	cmp	r0, r1
    b3b0:	e0a22002 	adc	r2, r2, r2
    b3b4:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    b3b8:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    b3bc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1165
    b3c0:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1166
    b3c4:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1167
    b3c8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1169
    b3cc:	e16f2f11 	clz	r2, r1
    b3d0:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1171
    b3d4:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1172
    b3d8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1176
    b3dc:	e3500000 	cmp	r0, #0
    b3e0:	13e00000 	mvnne	r0, #0
    b3e4:	ea000097 	b	b648 <__aeabi_idiv0>

0000b3e8 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1207
    b3e8:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1208
    b3ec:	0afffffa 	beq	b3dc <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1209
    b3f0:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1210
    b3f4:	ebffff80 	bl	b1fc <__udivsi3>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1211
    b3f8:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1212
    b3fc:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1213
    b400:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1214
    b404:	e12fff1e 	bx	lr

0000b408 <__divsi3>:
__divsi3():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1343
    b408:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1344
    b40c:	0a000081 	beq	b618 <.divsi3_skip_div0_test+0x208>

0000b410 <.divsi3_skip_div0_test>:
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1346
    b410:	e020c001 	eor	ip, r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1348
    b414:	42611000 	rsbmi	r1, r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1349
    b418:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1350
    b41c:	0a000070 	beq	b5e4 <.divsi3_skip_div0_test+0x1d4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1351
    b420:	e1b03000 	movs	r3, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1353
    b424:	42603000 	rsbmi	r3, r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1354
    b428:	e1530001 	cmp	r3, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1355
    b42c:	9a00006f 	bls	b5f0 <.divsi3_skip_div0_test+0x1e0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1356
    b430:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1357
    b434:	0a000071 	beq	b600 <.divsi3_skip_div0_test+0x1f0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1359
    b438:	e16f2f13 	clz	r2, r3
    b43c:	e16f0f11 	clz	r0, r1
    b440:	e0402002 	sub	r2, r0, r2
    b444:	e272201f 	rsbs	r2, r2, #31
    b448:	10822082 	addne	r2, r2, r2, lsl #1
    b44c:	e3a00000 	mov	r0, #0
    b450:	108ff102 	addne	pc, pc, r2, lsl #2
    b454:	e1a00000 	nop			; (mov r0, r0)
    b458:	e1530f81 	cmp	r3, r1, lsl #31
    b45c:	e0a00000 	adc	r0, r0, r0
    b460:	20433f81 	subcs	r3, r3, r1, lsl #31
    b464:	e1530f01 	cmp	r3, r1, lsl #30
    b468:	e0a00000 	adc	r0, r0, r0
    b46c:	20433f01 	subcs	r3, r3, r1, lsl #30
    b470:	e1530e81 	cmp	r3, r1, lsl #29
    b474:	e0a00000 	adc	r0, r0, r0
    b478:	20433e81 	subcs	r3, r3, r1, lsl #29
    b47c:	e1530e01 	cmp	r3, r1, lsl #28
    b480:	e0a00000 	adc	r0, r0, r0
    b484:	20433e01 	subcs	r3, r3, r1, lsl #28
    b488:	e1530d81 	cmp	r3, r1, lsl #27
    b48c:	e0a00000 	adc	r0, r0, r0
    b490:	20433d81 	subcs	r3, r3, r1, lsl #27
    b494:	e1530d01 	cmp	r3, r1, lsl #26
    b498:	e0a00000 	adc	r0, r0, r0
    b49c:	20433d01 	subcs	r3, r3, r1, lsl #26
    b4a0:	e1530c81 	cmp	r3, r1, lsl #25
    b4a4:	e0a00000 	adc	r0, r0, r0
    b4a8:	20433c81 	subcs	r3, r3, r1, lsl #25
    b4ac:	e1530c01 	cmp	r3, r1, lsl #24
    b4b0:	e0a00000 	adc	r0, r0, r0
    b4b4:	20433c01 	subcs	r3, r3, r1, lsl #24
    b4b8:	e1530b81 	cmp	r3, r1, lsl #23
    b4bc:	e0a00000 	adc	r0, r0, r0
    b4c0:	20433b81 	subcs	r3, r3, r1, lsl #23
    b4c4:	e1530b01 	cmp	r3, r1, lsl #22
    b4c8:	e0a00000 	adc	r0, r0, r0
    b4cc:	20433b01 	subcs	r3, r3, r1, lsl #22
    b4d0:	e1530a81 	cmp	r3, r1, lsl #21
    b4d4:	e0a00000 	adc	r0, r0, r0
    b4d8:	20433a81 	subcs	r3, r3, r1, lsl #21
    b4dc:	e1530a01 	cmp	r3, r1, lsl #20
    b4e0:	e0a00000 	adc	r0, r0, r0
    b4e4:	20433a01 	subcs	r3, r3, r1, lsl #20
    b4e8:	e1530981 	cmp	r3, r1, lsl #19
    b4ec:	e0a00000 	adc	r0, r0, r0
    b4f0:	20433981 	subcs	r3, r3, r1, lsl #19
    b4f4:	e1530901 	cmp	r3, r1, lsl #18
    b4f8:	e0a00000 	adc	r0, r0, r0
    b4fc:	20433901 	subcs	r3, r3, r1, lsl #18
    b500:	e1530881 	cmp	r3, r1, lsl #17
    b504:	e0a00000 	adc	r0, r0, r0
    b508:	20433881 	subcs	r3, r3, r1, lsl #17
    b50c:	e1530801 	cmp	r3, r1, lsl #16
    b510:	e0a00000 	adc	r0, r0, r0
    b514:	20433801 	subcs	r3, r3, r1, lsl #16
    b518:	e1530781 	cmp	r3, r1, lsl #15
    b51c:	e0a00000 	adc	r0, r0, r0
    b520:	20433781 	subcs	r3, r3, r1, lsl #15
    b524:	e1530701 	cmp	r3, r1, lsl #14
    b528:	e0a00000 	adc	r0, r0, r0
    b52c:	20433701 	subcs	r3, r3, r1, lsl #14
    b530:	e1530681 	cmp	r3, r1, lsl #13
    b534:	e0a00000 	adc	r0, r0, r0
    b538:	20433681 	subcs	r3, r3, r1, lsl #13
    b53c:	e1530601 	cmp	r3, r1, lsl #12
    b540:	e0a00000 	adc	r0, r0, r0
    b544:	20433601 	subcs	r3, r3, r1, lsl #12
    b548:	e1530581 	cmp	r3, r1, lsl #11
    b54c:	e0a00000 	adc	r0, r0, r0
    b550:	20433581 	subcs	r3, r3, r1, lsl #11
    b554:	e1530501 	cmp	r3, r1, lsl #10
    b558:	e0a00000 	adc	r0, r0, r0
    b55c:	20433501 	subcs	r3, r3, r1, lsl #10
    b560:	e1530481 	cmp	r3, r1, lsl #9
    b564:	e0a00000 	adc	r0, r0, r0
    b568:	20433481 	subcs	r3, r3, r1, lsl #9
    b56c:	e1530401 	cmp	r3, r1, lsl #8
    b570:	e0a00000 	adc	r0, r0, r0
    b574:	20433401 	subcs	r3, r3, r1, lsl #8
    b578:	e1530381 	cmp	r3, r1, lsl #7
    b57c:	e0a00000 	adc	r0, r0, r0
    b580:	20433381 	subcs	r3, r3, r1, lsl #7
    b584:	e1530301 	cmp	r3, r1, lsl #6
    b588:	e0a00000 	adc	r0, r0, r0
    b58c:	20433301 	subcs	r3, r3, r1, lsl #6
    b590:	e1530281 	cmp	r3, r1, lsl #5
    b594:	e0a00000 	adc	r0, r0, r0
    b598:	20433281 	subcs	r3, r3, r1, lsl #5
    b59c:	e1530201 	cmp	r3, r1, lsl #4
    b5a0:	e0a00000 	adc	r0, r0, r0
    b5a4:	20433201 	subcs	r3, r3, r1, lsl #4
    b5a8:	e1530181 	cmp	r3, r1, lsl #3
    b5ac:	e0a00000 	adc	r0, r0, r0
    b5b0:	20433181 	subcs	r3, r3, r1, lsl #3
    b5b4:	e1530101 	cmp	r3, r1, lsl #2
    b5b8:	e0a00000 	adc	r0, r0, r0
    b5bc:	20433101 	subcs	r3, r3, r1, lsl #2
    b5c0:	e1530081 	cmp	r3, r1, lsl #1
    b5c4:	e0a00000 	adc	r0, r0, r0
    b5c8:	20433081 	subcs	r3, r3, r1, lsl #1
    b5cc:	e1530001 	cmp	r3, r1
    b5d0:	e0a00000 	adc	r0, r0, r0
    b5d4:	20433001 	subcs	r3, r3, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1361
    b5d8:	e35c0000 	cmp	ip, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1363
    b5dc:	42600000 	rsbmi	r0, r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1364
    b5e0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1366
    b5e4:	e13c0000 	teq	ip, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1368
    b5e8:	42600000 	rsbmi	r0, r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1369
    b5ec:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1372
    b5f0:	33a00000 	movcc	r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1374
    b5f4:	01a00fcc 	asreq	r0, ip, #31
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1375
    b5f8:	03800001 	orreq	r0, r0, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1376
    b5fc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1378
    b600:	e16f2f11 	clz	r2, r1
    b604:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1380
    b608:	e35c0000 	cmp	ip, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1381
    b60c:	e1a00233 	lsr	r0, r3, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1383
    b610:	42600000 	rsbmi	r0, r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1384
    b614:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1388
    b618:	e3500000 	cmp	r0, #0
    b61c:	c3e00102 	mvngt	r0, #-2147483648	; 0x80000000
    b620:	b3a00102 	movlt	r0, #-2147483648	; 0x80000000
    b624:	ea000007 	b	b648 <__aeabi_idiv0>

0000b628 <__aeabi_idivmod>:
__aeabi_idivmod():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1419
    b628:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1420
    b62c:	0afffff9 	beq	b618 <.divsi3_skip_div0_test+0x208>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1421
    b630:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1422
    b634:	ebffff75 	bl	b410 <.divsi3_skip_div0_test>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1423
    b638:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1424
    b63c:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1425
    b640:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1426
    b644:	e12fff1e 	bx	lr

0000b648 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1512
    b648:	e12fff1e 	bx	lr

0000b64c <__aeabi_frsub>:
__aeabi_frsub():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:59
    b64c:	e2200102 	eor	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:60
    b650:	ea000000 	b	b658 <__addsf3>

0000b654 <__aeabi_fsub>:
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:65
    b654:	e2211102 	eor	r1, r1, #-2147483648	; 0x80000000

0000b658 <__addsf3>:
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:74
    b658:	e1b02080 	lsls	r2, r0, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:76
    b65c:	11b03081 	lslsne	r3, r1, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:77
    b660:	11320003 	teqne	r2, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:78
    b664:	11f0cc42 	mvnsne	ip, r2, asr #24
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:79
    b668:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:80
    b66c:	0a00003c 	beq	b764 <__addsf3+0x10c>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:84
    b670:	e1a02c22 	lsr	r2, r2, #24
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:85
    b674:	e0723c23 	rsbs	r3, r2, r3, lsr #24
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:87
    b678:	c0822003 	addgt	r2, r2, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:88
    b67c:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:89
    b680:	c0210000 	eorgt	r0, r1, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:90
    b684:	c0201001 	eorgt	r1, r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:92
    b688:	b2633000 	rsblt	r3, r3, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:97
    b68c:	e3530019 	cmp	r3, #25
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:99
    b690:	812fff1e 	bxhi	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:102
    b694:	e3100102 	tst	r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:103
    b698:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:104
    b69c:	e3c004ff 	bic	r0, r0, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:106
    b6a0:	12600000 	rsbne	r0, r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:107
    b6a4:	e3110102 	tst	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:108
    b6a8:	e3811502 	orr	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:109
    b6ac:	e3c114ff 	bic	r1, r1, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:111
    b6b0:	12611000 	rsbne	r1, r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:115
    b6b4:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:116
    b6b8:	0a000023 	beq	b74c <__addsf3+0xf4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:120
    b6bc:	e2422001 	sub	r2, r2, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:124
    b6c0:	e0900351 	adds	r0, r0, r1, asr r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:125
    b6c4:	e2633020 	rsb	r3, r3, #32
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:126
    b6c8:	e1a01311 	lsl	r1, r1, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:129
    b6cc:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:130
    b6d0:	5a000001 	bpl	b6dc <__addsf3+0x84>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:135
    b6d4:	e2711000 	rsbs	r1, r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:136
    b6d8:	e2e00000 	rsc	r0, r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:141
    b6dc:	e3500502 	cmp	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:142
    b6e0:	3a00000b 	bcc	b714 <__addsf3+0xbc>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:143
    b6e4:	e3500401 	cmp	r0, #16777216	; 0x1000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:144
    b6e8:	3a000004 	bcc	b700 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:147
    b6ec:	e1b000a0 	lsrs	r0, r0, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:148
    b6f0:	e1a01061 	rrx	r1, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:149
    b6f4:	e2822001 	add	r2, r2, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:152
    b6f8:	e35200fe 	cmp	r2, #254	; 0xfe
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:153
    b6fc:	2a00002d 	bcs	b7b8 <__addsf3+0x160>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:160
    b700:	e3510102 	cmp	r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:161
    b704:	e0a00b82 	adc	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:163
    b708:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:164
    b70c:	e1800003 	orr	r0, r0, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:165
    b710:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:169
    b714:	e1b01081 	lsls	r1, r1, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:170
    b718:	e0a00000 	adc	r0, r0, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:171
    b71c:	e3100502 	tst	r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:172
    b720:	e2422001 	sub	r2, r2, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:173
    b724:	1afffff5 	bne	b700 <__addsf3+0xa8>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:198
    b728:	e16fcf10 	clz	ip, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:199
    b72c:	e24cc008 	sub	ip, ip, #8
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:200
    b730:	e052200c 	subs	r2, r2, ip
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:201
    b734:	e1a00c10 	lsl	r0, r0, ip
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:208
    b738:	a0800b82 	addge	r0, r0, r2, lsl #23
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:209
    b73c:	b2622000 	rsblt	r2, r2, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:210
    b740:	a1800003 	orrge	r0, r0, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:216
    b744:	b1830230 	orrlt	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:218
    b748:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:223
    b74c:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:224
    b750:	e2211502 	eor	r1, r1, #8388608	; 0x800000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:226
    b754:	02200502 	eoreq	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:227
    b758:	02822001 	addeq	r2, r2, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:228
    b75c:	12433001 	subne	r3, r3, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:229
    b760:	eaffffd5 	b	b6bc <__addsf3+0x64>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:232
    b764:	e1a03081 	lsl	r3, r1, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:234
    b768:	e1f0cc42 	mvns	ip, r2, asr #24
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:236
    b76c:	11f0cc43 	mvnsne	ip, r3, asr #24
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:237
    b770:	0a000013 	beq	b7c4 <__addsf3+0x16c>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:239
    b774:	e1320003 	teq	r2, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:240
    b778:	0a000002 	beq	b788 <__addsf3+0x130>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:243
    b77c:	e3320000 	teq	r2, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:245
    b780:	01a00001 	moveq	r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:246
    b784:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:248
    b788:	e1300001 	teq	r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:252
    b78c:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:253
    b790:	112fff1e 	bxne	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:256
    b794:	e31204ff 	tst	r2, #-16777216	; 0xff000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:257
    b798:	1a000002 	bne	b7a8 <__addsf3+0x150>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:258
    b79c:	e1b00080 	lsls	r0, r0, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:260
    b7a0:	23800102 	orrcs	r0, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:261
    b7a4:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:262
    b7a8:	e2922402 	adds	r2, r2, #33554432	; 0x2000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:264
    b7ac:	32800502 	addcc	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:265
    b7b0:	312fff1e 	bxcc	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:266
    b7b4:	e2003102 	and	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:270
    b7b8:	e383047f 	orr	r0, r3, #2130706432	; 0x7f000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:271
    b7bc:	e3800502 	orr	r0, r0, #8388608	; 0x800000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:272
    b7c0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:281
    b7c4:	e1f02c42 	mvns	r2, r2, asr #24
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:283
    b7c8:	11a00001 	movne	r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:284
    b7cc:	01f03c43 	mvnseq	r3, r3, asr #24
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:285
    b7d0:	11a01000 	movne	r1, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:286
    b7d4:	e1b02480 	lsls	r2, r0, #9
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:288
    b7d8:	01b03481 	lslseq	r3, r1, #9
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:289
    b7dc:	01300001 	teqeq	r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:290
    b7e0:	13800501 	orrne	r0, r0, #4194304	; 0x400000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:291
    b7e4:	e12fff1e 	bx	lr

0000b7e8 <__aeabi_ui2f>:
__aeabi_ui2f():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:304
    b7e8:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:305
    b7ec:	ea000001 	b	b7f8 <__aeabi_i2f+0x8>

0000b7f0 <__aeabi_i2f>:
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:310
    b7f0:	e2103102 	ands	r3, r0, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:312
    b7f4:	42600000 	rsbmi	r0, r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:314
    b7f8:	e1b0c000 	movs	ip, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:316
    b7fc:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:319
    b800:	e383344b 	orr	r3, r3, #1258291200	; 0x4b000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:322
    b804:	e1a01000 	mov	r1, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:324
    b808:	e3a00000 	mov	r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:325
    b80c:	ea00000f 	b	b850 <__aeabi_l2f+0x30>

0000b810 <__aeabi_ul2f>:
__floatundisf():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:337
    b810:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:339
    b814:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:341
    b818:	e3a03000 	mov	r3, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:342
    b81c:	ea000005 	b	b838 <__aeabi_l2f+0x18>

0000b820 <__aeabi_l2f>:
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:347
    b820:	e1902001 	orrs	r2, r0, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:349
    b824:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:351
    b828:	e2113102 	ands	r3, r1, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:352
    b82c:	5a000001 	bpl	b838 <__aeabi_l2f+0x18>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:357
    b830:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:358
    b834:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:361
    b838:	e1b0c001 	movs	ip, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:363
    b83c:	01a0c000 	moveq	ip, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:364
    b840:	01a01000 	moveq	r1, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:365
    b844:	03a00000 	moveq	r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:368
    b848:	e383345b 	orr	r3, r3, #1526726656	; 0x5b000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:370
    b84c:	02433201 	subeq	r3, r3, #268435456	; 0x10000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:371
    b850:	e2433502 	sub	r3, r3, #8388608	; 0x800000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:396
    b854:	e16f2f1c 	clz	r2, ip
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:397
    b858:	e2522008 	subs	r2, r2, #8
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:401
    b85c:	e0433b82 	sub	r3, r3, r2, lsl #23
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:402
    b860:	ba000006 	blt	b880 <__aeabi_l2f+0x60>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:404
    b864:	e0833211 	add	r3, r3, r1, lsl r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:405
    b868:	e1a0c210 	lsl	ip, r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:406
    b86c:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:407
    b870:	e35c0102 	cmp	ip, #-2147483648	; 0x80000000
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:408
    b874:	e0a30230 	adc	r0, r3, r0, lsr r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:410
    b878:	03c00001 	biceq	r0, r0, #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:411
    b87c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:413
    b880:	e2822020 	add	r2, r2, #32
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:414
    b884:	e1a0c211 	lsl	ip, r1, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:415
    b888:	e2622020 	rsb	r2, r2, #32
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:416
    b88c:	e190008c 	orrs	r0, r0, ip, lsl #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:417
    b890:	e0a30231 	adc	r0, r3, r1, lsr r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:419
    b894:	01c00fac 	biceq	r0, r0, ip, lsr #31
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/ieee754-sf.S:420
    b898:	e12fff1e 	bx	lr

0000b89c <__aeabi_ldivmod>:
__aeabi_ldivmod():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:186
    b89c:	e3530000 	cmp	r3, #0
    b8a0:	03520000 	cmpeq	r2, #0
    b8a4:	1a000007 	bne	b8c8 <__aeabi_ldivmod+0x2c>
    b8a8:	e3510000 	cmp	r1, #0
    b8ac:	b3a01102 	movlt	r1, #-2147483648	; 0x80000000
    b8b0:	b3a00000 	movlt	r0, #0
    b8b4:	ba000002 	blt	b8c4 <__aeabi_ldivmod+0x28>
    b8b8:	03500000 	cmpeq	r0, #0
    b8bc:	13e01102 	mvnne	r1, #-2147483648	; 0x80000000
    b8c0:	13e00000 	mvnne	r0, #0
    b8c4:	eaffff5f 	b	b648 <__aeabi_idiv0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:188
    b8c8:	e24dd008 	sub	sp, sp, #8
    b8cc:	e92d6000 	push	{sp, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:189
    b8d0:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:190
    b8d4:	ba000006 	blt	b8f4 <__aeabi_ldivmod+0x58>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:191
    b8d8:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:192
    b8dc:	ba000011 	blt	b928 <__aeabi_ldivmod+0x8c>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:194
    b8e0:	eb00003e 	bl	b9e0 <__udivmoddi4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:196
    b8e4:	e59de004 	ldr	lr, [sp, #4]
    b8e8:	e28dd008 	add	sp, sp, #8
    b8ec:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:197
    b8f0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:201
    b8f4:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:202
    b8f8:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:203
    b8fc:	e3530000 	cmp	r3, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:204
    b900:	ba000011 	blt	b94c <__aeabi_ldivmod+0xb0>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:206
    b904:	eb000035 	bl	b9e0 <__udivmoddi4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:208
    b908:	e59de004 	ldr	lr, [sp, #4]
    b90c:	e28dd008 	add	sp, sp, #8
    b910:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:209
    b914:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:210
    b918:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:211
    b91c:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:212
    b920:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:213
    b924:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:217
    b928:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:218
    b92c:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:220
    b930:	eb00002a 	bl	b9e0 <__udivmoddi4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:222
    b934:	e59de004 	ldr	lr, [sp, #4]
    b938:	e28dd008 	add	sp, sp, #8
    b93c:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:223
    b940:	e2700000 	rsbs	r0, r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:224
    b944:	e0c11081 	sbc	r1, r1, r1, lsl #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:225
    b948:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:229
    b94c:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:230
    b950:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:232
    b954:	eb000021 	bl	b9e0 <__udivmoddi4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:233
    b958:	e59de004 	ldr	lr, [sp, #4]
    b95c:	e28dd008 	add	sp, sp, #8
    b960:	e8bd000c 	pop	{r2, r3}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:234
    b964:	e2722000 	rsbs	r2, r2, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:235
    b968:	e0c33083 	sbc	r3, r3, r3, lsl #1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/bpabi.S:236
    b96c:	e12fff1e 	bx	lr

0000b970 <__aeabi_f2lz>:
__fixsfdi():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    b970:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1531
    b974:	eef57ac0 	vcmpe.f32	s15, #0.0
    b978:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    b97c:	4a000000 	bmi	b984 <__aeabi_f2lz+0x14>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1533
    b980:	ea000006 	b	b9a0 <__aeabi_f2ulz>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1530
    b984:	e92d4010 	push	{r4, lr}
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1532
    b988:	e2200102 	eor	r0, r0, #-2147483648	; 0x80000000
    b98c:	eb000003 	bl	b9a0 <__aeabi_f2ulz>
    b990:	e2700000 	rsbs	r0, r0, #0
    b994:	e2e11000 	rsc	r1, r1, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1534
    b998:	e8bd8010 	pop	{r4, pc}
__aeabi_f2lz():
    b99c:	00000000 	andeq	r0, r0, r0

0000b9a0 <__aeabi_f2ulz>:
__fixunssfdi():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    b9a0:	ee070a90 	vmov	s15, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    b9a4:	ed9f5b09 	vldr	d5, [pc, #36]	; b9d0 <__aeabi_f2ulz+0x30>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1471
    b9a8:	eeb76ae7 	vcvt.f64.f32	d6, s15
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1476
    b9ac:	ed9f7b09 	vldr	d7, [pc, #36]	; b9d8 <__aeabi_f2ulz+0x38>
    b9b0:	ee267b07 	vmul.f64	d7, d6, d7
    b9b4:	eebc7bc7 	vcvt.u32.f64	s14, d7
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    b9b8:	eeb84b47 	vcvt.f64.u32	d4, s14
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    b9bc:	ee171a10 	vmov	r1, s14
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1481
    b9c0:	ee046b45 	vmls.f64	d6, d4, d5
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1524
    b9c4:	eefc7bc6 	vcvt.u32.f64	s15, d6
    b9c8:	ee170a90 	vmov	r0, s15
    b9cc:	e12fff1e 	bx	lr
    b9d0:	00000000 	andeq	r0, r0, r0
    b9d4:	41f00000 	mvnsmi	r0, r0
    b9d8:	00000000 	andeq	r0, r0, r0
    b9dc:	3df00000 	ldclcc	0, cr0, [r0]

0000b9e0 <__udivmoddi4>:
__udivmoddi4():
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    b9e0:	e1510003 	cmp	r1, r3
    b9e4:	01500002 	cmpeq	r0, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    b9e8:	e92d4ff0 	push	{r4, r5, r6, r7, r8, r9, sl, fp, lr}
    b9ec:	e1a04000 	mov	r4, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    b9f0:	33a00000 	movcc	r0, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:948
    b9f4:	e1a05001 	mov	r5, r1
    b9f8:	e59de024 	ldr	lr, [sp, #36]	; 0x24
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    b9fc:	31a01000 	movcc	r1, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:960
    ba00:	3a00003d 	bcc	bafc <__udivmoddi4+0x11c>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:962
    ba04:	e3530000 	cmp	r3, #0
    ba08:	016fcf12 	clzeq	ip, r2
    ba0c:	116fcf13 	clzne	ip, r3
    ba10:	028cc020 	addeq	ip, ip, #32
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:963
    ba14:	e3550000 	cmp	r5, #0
    ba18:	016f1f14 	clzeq	r1, r4
    ba1c:	02811020 	addeq	r1, r1, #32
    ba20:	116f1f15 	clzne	r1, r5
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:965
    ba24:	e04cc001 	sub	ip, ip, r1
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:966
    ba28:	e1a09c13 	lsl	r9, r3, ip
    ba2c:	e24cb020 	sub	fp, ip, #32
    ba30:	e1899b12 	orr	r9, r9, r2, lsl fp
    ba34:	e26ca020 	rsb	sl, ip, #32
    ba38:	e1899a32 	orr	r9, r9, r2, lsr sl
    ba3c:	e1a08c12 	lsl	r8, r2, ip
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    ba40:	e1550009 	cmp	r5, r9
    ba44:	01540008 	cmpeq	r4, r8
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:949
    ba48:	33a00000 	movcc	r0, #0
    ba4c:	31a01000 	movcc	r1, r0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:973
    ba50:	3a000005 	bcc	ba6c <__udivmoddi4+0x8c>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    ba54:	e3a00001 	mov	r0, #1
    ba58:	e1a01b10 	lsl	r1, r0, fp
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    ba5c:	e0544008 	subs	r4, r4, r8
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:976
    ba60:	e1811a30 	orr	r1, r1, r0, lsr sl
    ba64:	e1a00c10 	lsl	r0, r0, ip
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:975
    ba68:	e0c55009 	sbc	r5, r5, r9
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:979
    ba6c:	e35c0000 	cmp	ip, #0
    ba70:	0a000021 	beq	bafc <__udivmoddi4+0x11c>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:981
    ba74:	e1a060a8 	lsr	r6, r8, #1
    ba78:	e1866f89 	orr	r6, r6, r9, lsl #31
    ba7c:	e1a070a9 	lsr	r7, r9, #1
    ba80:	e1a0200c 	mov	r2, ip
    ba84:	ea000007 	b	baa8 <__udivmoddi4+0xc8>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:989
    ba88:	e0543006 	subs	r3, r4, r6
    ba8c:	e0c58007 	sbc	r8, r5, r7
    ba90:	e0933003 	adds	r3, r3, r3
    ba94:	e0a88008 	adc	r8, r8, r8
    ba98:	e2934001 	adds	r4, r3, #1
    ba9c:	e2a85000 	adc	r5, r8, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    baa0:	e2522001 	subs	r2, r2, #1
    baa4:	0a000006 	beq	bac4 <__udivmoddi4+0xe4>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:988
    baa8:	e1550007 	cmp	r5, r7
    baac:	01540006 	cmpeq	r4, r6
    bab0:	2afffff4 	bcs	ba88 <__udivmoddi4+0xa8>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:991
    bab4:	e0944004 	adds	r4, r4, r4
    bab8:	e0a55005 	adc	r5, r5, r5
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:993
    babc:	e2522001 	subs	r2, r2, #1
    bac0:	1afffff8 	bne	baa8 <__udivmoddi4+0xc8>
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    bac4:	e1a03c34 	lsr	r3, r4, ip
    bac8:	e1833a15 	orr	r3, r3, r5, lsl sl
    bacc:	e1a02c35 	lsr	r2, r5, ip
    bad0:	e1833b35 	orr	r3, r3, r5, lsr fp
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    bad4:	e0900004 	adds	r0, r0, r4
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    bad8:	e1a04003 	mov	r4, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:999
    badc:	e1a03c12 	lsl	r3, r2, ip
    bae0:	e1833b14 	orr	r3, r3, r4, lsl fp
    bae4:	e1a0cc14 	lsl	ip, r4, ip
    bae8:	e1833a34 	orr	r3, r3, r4, lsr sl
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:997
    baec:	e0a11005 	adc	r1, r1, r5
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:999
    baf0:	e050000c 	subs	r0, r0, ip
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:998
    baf4:	e1a05002 	mov	r5, r2
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:999
    baf8:	e0c11003 	sbc	r1, r1, r3
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1003
    bafc:	e35e0000 	cmp	lr, #0
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1004
    bb00:	11ce40f0 	strdne	r4, [lr]
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:1006
    bb04:	e8bd8ff0 	pop	{r4, r5, r6, r7, r8, r9, sl, fp, pc}

Disassembly of section .rodata:

0000bb08 <_ZL13Lock_Unlocked>:
    bb08:	00000000 	andeq	r0, r0, r0

0000bb0c <_ZL11Lock_Locked>:
    bb0c:	00000001 	andeq	r0, r0, r1

0000bb10 <_ZL21MaxFSDriverNameLength>:
    bb10:	00000010 	andeq	r0, r0, r0, lsl r0

0000bb14 <_ZL17MaxFilenameLength>:
    bb14:	00000010 	andeq	r0, r0, r0, lsl r0

0000bb18 <_ZL13MaxPathLength>:
    bb18:	00000080 	andeq	r0, r0, r0, lsl #1

0000bb1c <_ZL18NoFilesystemDriver>:
    bb1c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000bb20 <_ZL9NotifyAll>:
    bb20:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000bb24 <_ZL24Max_Process_Opened_Files>:
    bb24:	00000010 	andeq	r0, r0, r0, lsl r0

0000bb28 <_ZL10Indefinite>:
    bb28:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000bb2c <_ZL18Deadline_Unchanged>:
    bb2c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000bb30 <_ZL14Invalid_Handle>:
    bb30:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000bb34 <_ZN16buffer_constantsL11BUFFER_SIZEE>:
    bb34:	00000100 	andeq	r0, r0, r0, lsl #2

0000bb38 <_ZN3halL18Default_Clock_RateE>:
    bb38:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000bb3c <_ZN3halL15Peripheral_BaseE>:
    bb3c:	20000000 	andcs	r0, r0, r0

0000bb40 <_ZN3halL9GPIO_BaseE>:
    bb40:	20200000 	eorcs	r0, r0, r0

0000bb44 <_ZN3halL14GPIO_Pin_CountE>:
    bb44:	00000036 	andeq	r0, r0, r6, lsr r0

0000bb48 <_ZN3halL8AUX_BaseE>:
    bb48:	20215000 	eorcs	r5, r1, r0

0000bb4c <_ZN3halL25Interrupt_Controller_BaseE>:
    bb4c:	2000b200 	andcs	fp, r0, r0, lsl #4

0000bb50 <_ZN3halL10Timer_BaseE>:
    bb50:	2000b400 	andcs	fp, r0, r0, lsl #8

0000bb54 <_ZN3halL9TRNG_BaseE>:
    bb54:	20104000 	andscs	r4, r0, r0

0000bb58 <_ZN3halL9BSC0_BaseE>:
    bb58:	20205000 	eorcs	r5, r0, r0

0000bb5c <_ZN3halL9BSC1_BaseE>:
    bb5c:	20804000 	addcs	r4, r0, r0

0000bb60 <_ZN3halL9BSC2_BaseE>:
    bb60:	20805000 	addcs	r5, r0, r0

0000bb64 <_ZN3memL8PageSizeE>:
    bb64:	00100000 	andseq	r0, r0, r0

0000bb68 <_ZN3memL9LowMemoryE>:
    bb68:	c1000000 	mrsgt	r0, (UNDEF: 0)

0000bb6c <_ZN3memL10HighMemoryE>:
    bb6c:	d1000000 	mrsle	r0, (UNDEF: 0)

0000bb70 <_ZN3memL17MemoryVirtualBaseE>:
    bb70:	c0000000 	andgt	r0, r0, r0

0000bb74 <_ZN3memL16PagingMemorySizeE>:
    bb74:	10000000 	andne	r0, r0, r0

0000bb78 <_ZN3memL9PageCountE>:
    bb78:	00000100 	andeq	r0, r0, r0, lsl #2
    bb7c:	0000003e 	andeq	r0, r0, lr, lsr r0
    bb80:	0000000a 	andeq	r0, r0, sl
    bb84:	7073654e 	rsbsvc	r6, r3, lr, asr #10
    bb88:	76a1c372 			; <UNDEFINED> instruction: 0x76a1c372
    bb8c:	20bdc36e 	adcscs	ip, sp, lr, ror #6
    bb90:	75747376 	ldrbvc	r7, [r4, #-886]!	; 0xfffffc8a
    bb94:	5a202e70 	bpl	81755c <__bss_end+0x80b654>
    bb98:	6a656461 	bvs	1964d24 <__bss_end+0x1958e1c>
    bb9c:	63206574 			; <UNDEFINED> instruction: 0x63206574
    bba0:	c46f6c65 	strbtgt	r6, [pc], #-3173	; bba8 <_ZN3memL9PageCountE+0x30>
    bba4:	73adc38d 			; <UNDEFINED> instruction: 0x73adc38d
    bba8:	6f6e6c65 	svcvs	0x006e6c65
    bbac:	6f682075 	svcvs	0x00682075
    bbb0:	746f6e64 	strbtvc	r6, [pc], #-3684	; bbb8 <_ZN3memL9PageCountE+0x40>
    bbb4:	000a2e75 	andeq	r2, sl, r5, ror lr
    bbb8:	7073654e 	rsbsvc	r6, r3, lr, asr #10
    bbbc:	76a1c372 			; <UNDEFINED> instruction: 0x76a1c372
    bbc0:	20bdc36e 	adcscs	ip, sp, lr, ror #6
    bbc4:	75747376 	ldrbvc	r7, [r4, #-886]!	; 0xfffffc8a
    bbc8:	5a202e70 	bpl	817590 <__bss_end+0x80b688>
    bbcc:	6a656461 	bvs	1964d58 <__bss_end+0x1958e50>
    bbd0:	c4206574 	strtgt	r6, [r0], #-1396	; 0xfffffa8c
    bbd4:	73adc38d 			; <UNDEFINED> instruction: 0x73adc38d
    bbd8:	70206f6c 	eorvc	r6, r0, ip, ror #30
    bbdc:	c3736f72 	cmngt	r3, #456	; 0x1c8
    bbe0:	0a2e6dad 	beq	ba729c <__bss_end+0xb9b394>
    bbe4:	00000000 	andeq	r0, r0, r0
    bbe8:	0000202c 	andeq	r2, r0, ip, lsr #32
    bbec:	203d2041 	eorscs	r2, sp, r1, asr #32
    bbf0:	00000000 	andeq	r0, r0, r0
    bbf4:	203d2042 	eorscs	r2, sp, r2, asr #32
    bbf8:	00000000 	andeq	r0, r0, r0
    bbfc:	203d2043 	eorscs	r2, sp, r3, asr #32
    bc00:	00000000 	andeq	r0, r0, r0
    bc04:	203d2044 	eorscs	r2, sp, r4, asr #32
    bc08:	00000000 	andeq	r0, r0, r0
    bc0c:	203d2045 	eorscs	r2, sp, r5, asr #32
    bc10:	00000000 	andeq	r0, r0, r0
    bc14:	3a564544 	bcc	159d12c <__bss_end+0x1591224>
    bc18:	676e7274 			; <UNDEFINED> instruction: 0x676e7274
    bc1c:	00000000 	andeq	r0, r0, r0
    bc20:	6e696d20 	cdpvs	13, 6, cr6, cr9, cr0, {1}
    bc24:	000a7475 	andeq	r7, sl, r5, ror r4
    bc28:	202c4b4f 	eorcs	r4, ip, pc, asr #22
    bc2c:	6b6f726b 	blvs	1be85e0 <__bss_end+0x1bdc6d8>
    bc30:	6e61766f 	cdpvs	6, 6, cr7, cr1, cr15, {3}
    bc34:	00002069 	andeq	r2, r0, r9, rrx
    bc38:	202c4b4f 	eorcs	r4, ip, pc, asr #22
    bc3c:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
    bc40:	65636b69 	strbvs	r6, [r3, #-2921]!	; 0xfffff497
    bc44:	00000020 	andeq	r0, r0, r0, lsr #32
    bc48:	706f7473 	rsbvc	r7, pc, r3, ror r4	; <UNPREDICTABLE>
    bc4c:	00000000 	andeq	r0, r0, r0
    bc50:	61726170 	cmnvs	r2, r0, ror r1
    bc54:	6574656d 	ldrbvs	r6, [r4, #-1389]!	; 0xfffffa93
    bc58:	00007372 	andeq	r7, r0, r2, ror r3
    bc5c:	0a4e614e 	beq	13a419c <__bss_end+0x1398294>
    bc60:	00000000 	andeq	r0, r0, r0
    bc64:	69636f50 	stmdbvs	r3!, {r4, r6, r8, r9, sl, fp, sp, lr}^
    bc68:	2e6d6174 	mcrcs	1, 3, r6, cr13, cr4, {3}
    bc6c:	000a2e2e 	andeq	r2, sl, lr, lsr #28
    bc70:	00000000 	andeq	r0, r0, r0
    bc74:	6f6b654e 	svcvs	0x006b654e
    bc78:	746b6572 	strbtvc	r6, [fp], #-1394	; 0xfffffa8e
    bc7c:	7620696e 	strtvc	r6, [r0], -lr, ror #18
    bc80:	70757473 	rsbsvc	r7, r5, r3, ror r4
    bc84:	0000000a 	andeq	r0, r0, sl
    bc88:	3a564544 	bcc	159d1a0 <__bss_end+0x1591298>
    bc8c:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
    bc90:	0000302f 	andeq	r3, r0, pc, lsr #32
    bc94:	636c6143 	cmnvs	ip, #-1073741808	; 0xc0000010
    bc98:	7620534f 	strtvc	r5, [r0], -pc, asr #6
    bc9c:	0a302e31 	beq	c17568 <__bss_end+0xc0b660>
    bca0:	6f747541 	svcvs	0x00747541
    bca4:	4a203a72 	bmi	81a674 <__bss_end+0x80e76c>
    bca8:	48206e61 	stmdami	r0!, {r0, r5, r6, r9, sl, fp, sp, lr}
    bcac:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    bcb0:	6c6f6872 	stclvs	8, cr6, [pc], #-456	; baf0 <__udivmoddi4+0x110>
    bcb4:	676e697a 			; <UNDEFINED> instruction: 0x676e697a
    bcb8:	28207265 	stmdacs	r0!, {r0, r2, r5, r6, r9, ip, sp, lr}
    bcbc:	4e323241 	cdpmi	2, 3, cr3, cr2, cr1, {2}
    bcc0:	35343030 	ldrcc	r3, [r4, #-48]!	; 0xffffffd0
    bcc4:	5a0a2950 	bpl	29620c <__bss_end+0x28a304>
    bcc8:	6a656461 	bvs	1964e54 <__bss_end+0x1958f4c>
    bccc:	6e206574 	mcrvs	5, 1, r6, cr0, cr4, {3}
    bcd0:	72706a65 	rsbsvc	r6, r0, #413696	; 0x65000
    bcd4:	63206576 			; <UNDEFINED> instruction: 0x63206576
    bcd8:	766f7361 	strbtvc	r7, [pc], -r1, ror #6
    bcdc:	6f722079 	svcvs	0x00722079
    bce0:	7473657a 	ldrbtvc	r6, [r3], #-1402	; 0xfffffa86
    bce4:	61207075 			; <UNDEFINED> instruction: 0x61207075
    bce8:	65727020 	ldrbvs	r7, [r2, #-32]!	; 0xffffffe0
    bcec:	636b6964 	cmnvs	fp, #100, 18	; 0x190000
    bcf0:	6f20696e 	svcvs	0x0020696e
    bcf4:	6b6e656b 	blvs	1ba52a8 <__bss_end+0x1b993a0>
    bcf8:	2076206f 	rsbscs	r2, r6, pc, rrx
    bcfc:	756e696d 	strbvc	r6, [lr, #-2413]!	; 0xfffff693
    bd00:	68636174 	stmdavs	r3!, {r2, r4, r5, r6, r8, sp, lr}^
    bd04:	6c61440a 	cfstrdvs	mvd4, [r1], #-40	; 0xffffffd8
    bd08:	6f702065 	svcvs	0x00702065
    bd0c:	726f7064 	rsbvc	r7, pc, #100	; 0x64
    bd10:	6e61766f 	cdpvs	6, 6, cr7, cr1, cr15, {3}
    bd14:	72702079 	rsbsvc	r2, r0, #121	; 0x79
    bd18:	7a616b69 	bvc	1866ac4 <__bss_end+0x185abbc>
    bd1c:	73203a79 			; <UNDEFINED> instruction: 0x73203a79
    bd20:	2c706f74 	ldclcs	15, cr6, [r0], #-464	; 0xfffffe30
    bd24:	72617020 	rsbvc	r7, r1, #32
    bd28:	74656d61 	strbtvc	r6, [r5], #-3425	; 0xfffff29f
    bd2c:	0a737265 	beq	1ce86c8 <__bss_end+0x1cdc7c0>
    bd30:	00000000 	andeq	r0, r0, r0

0000bd34 <_ZN16buffer_constantsL11BUFFER_SIZEE>:
    bd34:	00000100 	andeq	r0, r0, r0, lsl #2

0000bd38 <_ZL13Lock_Unlocked>:
    bd38:	00000000 	andeq	r0, r0, r0

0000bd3c <_ZL11Lock_Locked>:
    bd3c:	00000001 	andeq	r0, r0, r1

0000bd40 <_ZL21MaxFSDriverNameLength>:
    bd40:	00000010 	andeq	r0, r0, r0, lsl r0

0000bd44 <_ZL17MaxFilenameLength>:
    bd44:	00000010 	andeq	r0, r0, r0, lsl r0

0000bd48 <_ZL13MaxPathLength>:
    bd48:	00000080 	andeq	r0, r0, r0, lsl #1

0000bd4c <_ZL18NoFilesystemDriver>:
    bd4c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000bd50 <_ZL9NotifyAll>:
    bd50:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000bd54 <_ZL24Max_Process_Opened_Files>:
    bd54:	00000010 	andeq	r0, r0, r0, lsl r0

0000bd58 <_ZL10Indefinite>:
    bd58:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000bd5c <_ZL18Deadline_Unchanged>:
    bd5c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000bd60 <_ZL14Invalid_Handle>:
    bd60:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000bd64 <_ZL16Pipe_File_Prefix>:
    bd64:	3a535953 	bcc	14e22b8 <__bss_end+0x14d63b0>
    bd68:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    bd6c:	0000002f 	andeq	r0, r0, pc, lsr #32

0000bd70 <_ZN3halL18Default_Clock_RateE>:
    bd70:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000bd74 <_ZN3halL15Peripheral_BaseE>:
    bd74:	20000000 	andcs	r0, r0, r0

0000bd78 <_ZN3halL9GPIO_BaseE>:
    bd78:	20200000 	eorcs	r0, r0, r0

0000bd7c <_ZN3halL14GPIO_Pin_CountE>:
    bd7c:	00000036 	andeq	r0, r0, r6, lsr r0

0000bd80 <_ZN3halL8AUX_BaseE>:
    bd80:	20215000 	eorcs	r5, r1, r0

0000bd84 <_ZN3halL25Interrupt_Controller_BaseE>:
    bd84:	2000b200 	andcs	fp, r0, r0, lsl #4

0000bd88 <_ZN3halL10Timer_BaseE>:
    bd88:	2000b400 	andcs	fp, r0, r0, lsl #8

0000bd8c <_ZN3halL9TRNG_BaseE>:
    bd8c:	20104000 	andscs	r4, r0, r0

0000bd90 <_ZN3halL9BSC0_BaseE>:
    bd90:	20205000 	eorcs	r5, r0, r0

0000bd94 <_ZN3halL9BSC1_BaseE>:
    bd94:	20804000 	addcs	r4, r0, r0

0000bd98 <_ZN3halL9BSC2_BaseE>:
    bd98:	20805000 	addcs	r5, r0, r0

0000bd9c <_ZN3memL8PageSizeE>:
    bd9c:	00100000 	andseq	r0, r0, r0

0000bda0 <_ZN3memL9LowMemoryE>:
    bda0:	c1000000 	mrsgt	r0, (UNDEF: 0)

0000bda4 <_ZN3memL10HighMemoryE>:
    bda4:	d1000000 	mrsle	r0, (UNDEF: 0)

0000bda8 <_ZN3memL17MemoryVirtualBaseE>:
    bda8:	c0000000 	andgt	r0, r0, r0

0000bdac <_ZN3memL16PagingMemorySizeE>:
    bdac:	10000000 	andne	r0, r0, r0

0000bdb0 <_ZN3memL9PageCountE>:
    bdb0:	00000100 	andeq	r0, r0, r0, lsl #2

0000bdb4 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    bdb4:	33323130 	teqcc	r2, #48, 2
    bdb8:	37363534 			; <UNDEFINED> instruction: 0x37363534
    bdbc:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    bdc0:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .ARM.exidx:

0000bdc8 <.ARM.exidx>:
    bdc8:	7ffffc18 	svcvc	0x00fffc18
    bdcc:	00000001 	andeq	r0, r0, r1

Disassembly of section .data:

0000bdd0 <__CTOR_LIST__>:
/build/gcc-arm-none-eabi-zSbVfn/gcc-arm-none-eabi-8-2019-q3/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/libgcc2.c:2358
    bdd0:	00009a84 	andeq	r9, r0, r4, lsl #21
    bdd4:	0000a344 	andeq	sl, r0, r4, asr #6

Disassembly of section .bss:

0000bdd8 <circBuffer>:
	...

0000bee4 <sUserHeap>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1681924>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x3651c>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3a130>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c4e1c>
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
     100:	fb010200 	blx	4090a <__bss_end+0x34a02>
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
     12c:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffe05 <__bss_end+0xffff3efd>
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
     164:	0a030000 	beq	c016c <__bss_end+0xb4264>
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
     1b8:	6a0d05a1 	bvs	341844 <__bss_end+0x33593c>
     1bc:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
     1c0:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     1c4:	04020004 	streq	r0, [r2], #-4
     1c8:	0b058302 	bleq	160dd8 <__bss_end+0x154ed0>
     1cc:	02040200 	andeq	r0, r4, #0, 4
     1d0:	0002054a 	andeq	r0, r2, sl, asr #10
     1d4:	2d020402 	cfstrscs	mvf0, [r2, #-8]
     1d8:	05850905 	streq	r0, [r5, #2309]	; 0x905
     1dc:	0a022f01 	beq	8bde8 <__bss_end+0x7fee0>
     1e0:	b4010100 	strlt	r0, [r1], #-256	; 0xffffff00
     1e4:	03000007 	movweq	r0, #7
     1e8:	0002a000 	andeq	sl, r2, r0
     1ec:	fb010200 	blx	409f6 <__bss_end+0x34aee>
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
     218:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffef1 <__bss_end+0xffff3fe9>
     21c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     220:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     224:	61707372 	cmnvs	r0, r2, ror r3
     228:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
     22c:	74732f2e 	ldrbtvc	r2, [r3], #-3886	; 0xfffff0d2
     230:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     234:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     238:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     23c:	6f682f00 	svcvs	0x00682f00
     240:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
     244:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
     248:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
     24c:	69662f76 	stmdbvs	r6!, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
     250:	2f6c616e 	svccs	0x006c616e
     254:	2f637273 	svccs	0x00637273
     258:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     25c:	2f736563 	svccs	0x00736563
     260:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     264:	63617073 	cmnvs	r1, #115	; 0x73
     268:	73752f65 	cmnvc	r5, #404	; 0x194
     26c:	745f7265 	ldrbvc	r7, [pc], #-613	; 274 <shift+0x274>
     270:	006b7361 	rsbeq	r7, fp, r1, ror #6
     274:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 1c0 <shift+0x1c0>
     278:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     27c:	6b69746e 	blvs	1a5d43c <__bss_end+0x1a51534>
     280:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
     284:	6e69662f 	cdpvs	6, 6, cr6, cr9, cr15, {1}
     288:	732f6c61 			; <UNDEFINED> instruction: 0x732f6c61
     28c:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
     290:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     294:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff37 <__bss_end+0xffff402f>
     298:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     29c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     2a0:	2f2e2e2f 	svccs	0x002e2e2f
     2a4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     2a8:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     2ac:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     2b0:	702f6564 	eorvc	r6, pc, r4, ror #10
     2b4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     2b8:	2f007373 	svccs	0x00007373
     2bc:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     2c0:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
     2c4:	2f6b6974 	svccs	0x006b6974
     2c8:	2f766564 	svccs	0x00766564
     2cc:	616e6966 	cmnvs	lr, r6, ror #18
     2d0:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     2d4:	6f732f63 	svcvs	0x00732f63
     2d8:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     2dc:	73752f73 	cmnvc	r5, #460	; 0x1cc
     2e0:	70737265 	rsbsvc	r7, r3, r5, ror #4
     2e4:	2f656361 	svccs	0x00656361
     2e8:	6b2f2e2e 	blvs	bcbba8 <__bss_end+0xbbfca0>
     2ec:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     2f0:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     2f4:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     2f8:	73662f65 	cmnvc	r6, #404	; 0x194
     2fc:	6f682f00 	svcvs	0x00682f00
     300:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
     304:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
     308:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
     30c:	69662f76 	stmdbvs	r6!, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
     310:	2f6c616e 	svccs	0x006c616e
     314:	2f637273 	svccs	0x00637273
     318:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     31c:	2f736563 	svccs	0x00736563
     320:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     324:	63617073 	cmnvs	r1, #115	; 0x73
     328:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     32c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     330:	2f6c656e 	svccs	0x006c656e
     334:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     338:	2f656475 	svccs	0x00656475
     33c:	72616f62 	rsbvc	r6, r1, #392	; 0x188
     340:	70722f64 	rsbsvc	r2, r2, r4, ror #30
     344:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
     348:	2f006c61 	svccs	0x00006c61
     34c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     350:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
     354:	2f6b6974 	svccs	0x006b6974
     358:	2f766564 	svccs	0x00766564
     35c:	616e6966 	cmnvs	lr, r6, ror #18
     360:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     364:	6f732f63 	svcvs	0x00732f63
     368:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     36c:	73752f73 	cmnvc	r5, #460	; 0x1cc
     370:	70737265 	rsbsvc	r7, r3, r5, ror #4
     374:	2f656361 	svccs	0x00656361
     378:	6b2f2e2e 	blvs	bcbc38 <__bss_end+0xbbfd30>
     37c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     380:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     384:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     388:	656d2f65 	strbvs	r2, [sp, #-3941]!	; 0xfffff09b
     38c:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     390:	6f682f00 	svcvs	0x00682f00
     394:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
     398:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
     39c:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
     3a0:	69662f76 	stmdbvs	r6!, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
     3a4:	2f6c616e 	svccs	0x006c616e
     3a8:	2f637273 	svccs	0x00637273
     3ac:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     3b0:	2f736563 	svccs	0x00736563
     3b4:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     3b8:	63617073 	cmnvs	r1, #115	; 0x73
     3bc:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     3c0:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     3c4:	2f6c656e 	svccs	0x006c656e
     3c8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     3cc:	2f656475 	svccs	0x00656475
     3d0:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     3d4:	2f737265 	svccs	0x00737265
     3d8:	64697262 	strbtvs	r7, [r9], #-610	; 0xfffffd9e
     3dc:	00736567 	rsbseq	r6, r3, r7, ror #10
     3e0:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
     3e4:	6f6d656d 	svcvs	0x006d656d
     3e8:	682e7972 	stmdavs	lr!, {r1, r4, r5, r6, r8, fp, ip, sp, lr}
     3ec:	00000100 	andeq	r0, r0, r0, lsl #2
     3f0:	6e69616d 	powvsez	f6, f1, #5.0
     3f4:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     3f8:	00000200 	andeq	r0, r0, r0, lsl #4
     3fc:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
     400:	00030068 	andeq	r0, r3, r8, rrx
     404:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
     408:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     40c:	00682e6b 	rsbeq	r2, r8, fp, ror #28
     410:	66000003 	strvs	r0, [r0], -r3
     414:	73656c69 	cmnvc	r5, #26880	; 0x6900
     418:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     41c:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     420:	70000004 	andvc	r0, r0, r4
     424:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     428:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
     42c:	00000300 	andeq	r0, r0, r0, lsl #6
     430:	636f7270 	cmnvs	pc, #112, 4
     434:	5f737365 	svcpl	0x00737365
     438:	616e616d 	cmnvs	lr, sp, ror #2
     43c:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
     440:	00030068 	andeq	r0, r3, r8, rrx
     444:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
     448:	66667562 	strbtvs	r7, [r6], -r2, ror #10
     44c:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
     450:	00000100 	andeq	r0, r0, r0, lsl #2
     454:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
     458:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
     45c:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
     460:	00050068 	andeq	r0, r5, r8, rrx
     464:	6d656d00 	stclvs	13, cr6, [r5, #-0]
     468:	2e70616d 	rpwcssz	f6, f0, #5.0
     46c:	00060068 	andeq	r0, r6, r8, rrx
     470:	72617500 	rsbvc	r7, r1, #0, 10
     474:	65645f74 	strbvs	r5, [r4, #-3956]!	; 0xfffff08c
     478:	682e7366 	stmdavs	lr!, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
     47c:	00000700 	andeq	r0, r0, r0, lsl #14
     480:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
     484:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
     488:	00000500 	andeq	r0, r0, r0, lsl #10
     48c:	00010500 	andeq	r0, r1, r0, lsl #10
     490:	96a00205 	strtls	r0, [r0], r5, lsl #4
     494:	2c030000 	stccs	0, cr0, [r3], {-0}
     498:	831b0501 	tsthi	fp, #4194304	; 0x400000
     49c:	02830105 	addeq	r0, r3, #1073741825	; 0x40000001
     4a0:	01010008 	tsteq	r1, r8
     4a4:	16050204 	strne	r0, [r5], -r4, lsl #4
     4a8:	28020500 	stmdacs	r2, {r8, sl}
     4ac:	03000082 	movweq	r0, #130	; 0x82
     4b0:	12050114 	andne	r0, r5, #20, 2
     4b4:	04020083 	streq	r0, [r2], #-131	; 0xffffff7d
     4b8:	05820601 	streq	r0, [r2, #1537]	; 0x601
     4bc:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
     4c0:	054a0601 	strbeq	r0, [sl, #-1537]	; 0xfffff9ff
     4c4:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
     4c8:	01052e02 	tsteq	r5, r2, lsl #28
     4cc:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
     4d0:	0336052f 	teqeq	r6, #197132288	; 0xbc00000
     4d4:	1f05821d 	svcne	0x0005821d
     4d8:	660a059f 			; <UNDEFINED> instruction: 0x660a059f
     4dc:	05830105 	streq	r0, [r3, #261]	; 0x105
     4e0:	09056837 	stmdbeq	r5, {r0, r1, r2, r4, r5, fp, sp, lr}
     4e4:	9f0105bb 	svcls	0x000105bb
     4e8:	056d2f05 	strbeq	r2, [sp, #-3845]!	; 0xfffff0fb
     4ec:	0a059f1b 	beq	168160 <__bss_end+0x15c258>
     4f0:	690e0585 	stmdbvs	lr, {r0, r2, r7, r8, sl}
     4f4:	05831205 	streq	r1, [r3, #517]	; 0x205
     4f8:	12054a09 	andne	r4, r5, #36864	; 0x9000
     4fc:	672d054c 	strvs	r0, [sp, -ip, asr #10]!
     500:	05671605 	strbeq	r1, [r7, #-1541]!	; 0xfffff9fb
     504:	0402001f 	streq	r0, [r2], #-31	; 0xffffffe1
     508:	2b054a03 	blcs	152d1c <__bss_end+0x146e14>
     50c:	02040200 	andeq	r0, r4, #0, 4
     510:	00190583 	andseq	r0, r9, r3, lsl #11
     514:	83020402 	movwhi	r0, #9218	; 0x2402
     518:	02001b05 	andeq	r1, r0, #5120	; 0x1400
     51c:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
     520:	0402000d 	streq	r0, [r2], #-13
     524:	15054802 	strne	r4, [r5, #-2050]	; 0xfffff7fe
     528:	66170587 	ldrvs	r0, [r7], -r7, lsl #11
     52c:	054b0d05 	strbeq	r0, [fp, #-3333]	; 0xfffff2fb
     530:	0e053018 	mcreq	0, 0, r3, cr5, cr8, {0}
     534:	6705059f 			; <UNDEFINED> instruction: 0x6705059f
     538:	052f0105 	streq	r0, [pc, #-261]!	; 43b <shift+0x43b>
     53c:	0a05c25d 	beq	170eb8 <__bss_end+0x164fb0>
     540:	670905d9 			; <UNDEFINED> instruction: 0x670905d9
     544:	839f0a05 	orrshi	r0, pc, #20480	; 0x5000
     548:	05670105 	strbeq	r0, [r7, #-261]!	; 0xfffffefb
     54c:	0a056e61 	beq	15bed8 <__bss_end+0x14ffd0>
     550:	670905d9 			; <UNDEFINED> instruction: 0x670905d9
     554:	83830a05 	orrhi	r0, r3, #20480	; 0x5000
     558:	05670105 	strbeq	r0, [r7, #-261]!	; 0xfffffefb
     55c:	14056e35 	strne	r6, [r5], #-3637	; 0xfffff1cb
     560:	671805a0 	ldrvs	r0, [r8, -r0, lsr #11]
     564:	05660d05 	strbeq	r0, [r6, #-3333]!	; 0xfffff2fb
     568:	12054a09 	andne	r4, r5, #36864	; 0x9000
     56c:	01040200 	mrseq	r0, R12_usr
     570:	000d054b 	andeq	r0, sp, fp, asr #10
     574:	67010402 	strvs	r0, [r1, -r2, lsl #8]
     578:	05311405 	ldreq	r1, [r1, #-1029]!	; 0xfffffbfb
     57c:	14056621 	strne	r6, [r5], #-1569	; 0xfffff9df
     580:	052e7a03 	streq	r7, [lr, #-2563]!	; 0xfffff5fd
     584:	04020001 	streq	r0, [r2], #-1
     588:	35053601 	strcc	r3, [r5, #-1537]	; 0xfffff9ff
     58c:	a014058a 	andsge	r0, r4, sl, lsl #11
     590:	05671605 	strbeq	r1, [r7, #-1541]!	; 0xfffff9fb
     594:	0905660d 	stmdbeq	r5, {r0, r2, r3, r9, sl, sp, lr}
     598:	0012054a 	andseq	r0, r2, sl, asr #10
     59c:	4b010402 	blmi	415ac <__bss_end+0x356a4>
     5a0:	02000d05 	andeq	r0, r0, #320	; 0x140
     5a4:	05670104 	strbeq	r0, [r7, #-260]!	; 0xfffffefc
     5a8:	21053114 	tstcs	r5, r4, lsl r1
     5ac:	03140566 	tsteq	r4, #427819008	; 0x19800000
     5b0:	01052e7a 	tsteq	r5, sl, ror lr
     5b4:	01040200 	mrseq	r0, R12_usr
     5b8:	8a4d0536 	bhi	1341a98 <__bss_end+0x1335b90>
     5bc:	05d73505 	ldrbeq	r3, [r7, #1285]	; 0x505
     5c0:	35052e1b 	strcc	r2, [r5, #-3611]	; 0xfffff1e5
     5c4:	2e1b05bb 	cfcmp64cs	r0, mvdx11, mvdx11
     5c8:	05bb3505 	ldreq	r3, [fp, #1285]!	; 0x505
     5cc:	35052e1b 	strcc	r2, [r5, #-3611]	; 0xfffff1e5
     5d0:	2e1b05bb 	cfcmp64cs	r0, mvdx11, mvdx11
     5d4:	05bb3505 	ldreq	r3, [fp, #1285]!	; 0x505
     5d8:	01052e1b 	tsteq	r5, fp, lsl lr
     5dc:	081c05bb 	ldmdaeq	ip, {r0, r1, r3, r4, r5, r7, r8, sl}
     5e0:	f709057b 			; <UNDEFINED> instruction: 0xf709057b
     5e4:	054c1e05 	strbeq	r1, [ip, #-3589]	; 0xfffff1fb
     5e8:	1b058440 	blne	1616f0 <__bss_end+0x1557e8>
     5ec:	bb190589 	bllt	641c18 <__bss_end+0x635d10>
     5f0:	05f51a05 	ldrbeq	r1, [r5, #2565]!	; 0xa05
     5f4:	0a05bb19 	beq	16f260 <__bss_end+0x163358>
     5f8:	4c0f05f8 	cfstr32mi	mvfx0, [pc], {248}	; 0xf8
     5fc:	054f0e05 	strbeq	r0, [pc, #-3589]	; fffff7ff <__bss_end+0xffff38f7>
     600:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
     604:	1e054a03 	vmlane.f32	s8, s10, s6
     608:	02040200 	andeq	r0, r4, #0, 4
     60c:	00110569 	andseq	r0, r1, r9, ror #10
     610:	9e020402 	cdpls	4, 0, cr0, cr2, cr2, {0}
     614:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
     618:	052f0204 	streq	r0, [pc, #-516]!	; 41c <shift+0x41c>
     61c:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
     620:	1e059e02 	cdpne	14, 0, cr9, cr5, cr2, {0}
     624:	02040200 	andeq	r0, r4, #0, 4
     628:	0011052f 	andseq	r0, r1, pc, lsr #10
     62c:	9e020402 	cdpls	4, 0, cr0, cr2, cr2, {0}
     630:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
     634:	052f0204 	streq	r0, [pc, #-516]!	; 438 <shift+0x438>
     638:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
     63c:	1e059e02 	cdpne	14, 0, cr9, cr5, cr2, {0}
     640:	02040200 	andeq	r0, r4, #0, 4
     644:	0011052f 	andseq	r0, r1, pc, lsr #10
     648:	9e020402 	cdpls	4, 0, cr0, cr2, cr2, {0}
     64c:	02001805 	andeq	r1, r0, #327680	; 0x50000
     650:	7a030204 	bvc	c0e68 <__bss_end+0xb4f60>
     654:	0005052e 	andeq	r0, r5, lr, lsr #10
     658:	02020402 	andeq	r0, r2, #33554432	; 0x2000000
     65c:	05110188 	ldreq	r0, [r1, #-392]	; 0xfffffe78
     660:	82100314 	andshi	r0, r0, #20, 6	; 0x50000000
     664:	059f2005 	ldreq	r2, [pc, #5]	; 671 <shift+0x671>
     668:	15056909 	strne	r6, [r5, #-2313]	; 0xfffff6f7
     66c:	9e0d056b 	cfsh32ls	mvfx0, mvfx13, #59
     670:	05820905 	streq	r0, [r2, #2309]	; 0x905
     674:	0d054f15 	stceq	15, cr4, [r5, #-84]	; 0xffffffac
     678:	8209059e 	andhi	r0, r9, #662700032	; 0x27800000
     67c:	02001905 	andeq	r1, r0, #81920	; 0x14000
     680:	054b0104 	strbeq	r0, [fp, #-260]	; 0xfffffefc
     684:	0402000d 	streq	r0, [r2], #-13
     688:	13280201 			; <UNDEFINED> instruction: 0x13280201
     68c:	05321505 	ldreq	r1, [r2, #-1285]!	; 0xfffffafb
     690:	1f056609 	svcne	0x00056609
     694:	671b054b 	ldrvs	r0, [fp, -fp, asr #10]
     698:	05d80d05 	ldrbeq	r0, [r8, #3333]	; 0xd05
     69c:	bc838316 	stclt	3, cr8, [r3], {22}
     6a0:	05a01a05 	streq	r1, [r0, #2565]!	; 0xa05
     6a4:	04020023 	streq	r0, [r2], #-35	; 0xffffffdd
     6a8:	2b054a03 	blcs	152ebc <__bss_end+0x146fb4>
     6ac:	02040200 	andeq	r0, r4, #0, 4
     6b0:	00440567 	subeq	r0, r4, r7, ror #10
     6b4:	08020402 	stmdaeq	r2, {r1, sl}
     6b8:	003a0520 	eorseq	r0, sl, r0, lsr #10
     6bc:	9e020402 	cdpls	4, 0, cr0, cr2, cr2, {0}
     6c0:	02005005 	andeq	r5, r0, #5
     6c4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     6c8:	04020062 	streq	r0, [r2], #-98	; 0xffffff9e
     6cc:	053c0802 	ldreq	r0, [ip, #-2050]!	; 0xfffff7fe
     6d0:	0402002b 	streq	r0, [r2], #-43	; 0xffffffd5
     6d4:	71059e02 	tstvc	r5, r2, lsl #28
     6d8:	02040200 	andeq	r0, r4, #0, 4
     6dc:	002b052e 	eoreq	r0, fp, lr, lsr #10
     6e0:	ba020402 	blt	816f0 <__bss_end+0x757e8>
     6e4:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
     6e8:	059d0204 	ldreq	r0, [sp, #516]	; 0x204
     6ec:	1b05871a 	blne	16235c <__bss_end+0x156454>
     6f0:	4d1a05d9 	cfldr32mi	mvfx0, [sl, #-868]	; 0xfffffc9c
     6f4:	02002305 	andeq	r2, r0, #335544320	; 0x14000000
     6f8:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     6fc:	0402001f 	streq	r0, [r2], #-31	; 0xffffffe1
     700:	11056702 	tstne	r5, r2, lsl #14
     704:	02040200 	andeq	r0, r4, #0, 4
     708:	05113a02 	ldreq	r3, [r1, #-2562]	; 0xfffff5fe
     70c:	2305861a 	movwcs	r8, #22042	; 0x561a
     710:	03040200 	movweq	r0, #16896	; 0x4200
     714:	0028054a 	eoreq	r0, r8, sl, asr #10
     718:	69020402 	stmdbvs	r2, {r1, sl}
     71c:	02004905 	andeq	r4, r0, #81920	; 0x14000
     720:	059e0204 	ldreq	r0, [lr, #516]	; 0x204
     724:	04020028 	streq	r0, [r2], #-40	; 0xffffffd8
     728:	053d0802 	ldreq	r0, [sp, #-2050]!	; 0xfffff7fe
     72c:	04020049 	streq	r0, [r2], #-73	; 0xffffffb7
     730:	28059e02 	stmdacs	r5, {r1, r9, sl, fp, ip, pc}
     734:	02040200 	andeq	r0, r4, #0, 4
     738:	49055908 	stmdbmi	r5, {r3, r8, fp, ip, lr}
     73c:	02040200 	andeq	r0, r4, #0, 4
     740:	0028059e 	mlaeq	r8, lr, r5, r0
     744:	08020402 	stmdaeq	r2, {r1, sl}
     748:	00490559 	subeq	r0, r9, r9, asr r5
     74c:	9e020402 	cdpls	4, 0, cr0, cr2, cr2, {0}
     750:	02002805 	andeq	r2, r0, #327680	; 0x50000
     754:	59080204 	stmdbpl	r8, {r2, r9}
     758:	02004905 	andeq	r4, r0, #81920	; 0x14000
     75c:	059e0204 	ldreq	r0, [lr, #516]	; 0x204
     760:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
     764:	087a0302 	ldmdaeq	sl!, {r1, r8, r9}^
     768:	00110558 	andseq	r0, r1, r8, asr r5
     76c:	02020402 	andeq	r0, r2, #33554432	; 0x2000000
     770:	05110188 	ldreq	r0, [r1, #-392]	; 0xfffffe78
     774:	820c031a 	andhi	r0, ip, #1744830464	; 0x68000000
     778:	02002305 	andeq	r2, r0, #335544320	; 0x14000000
     77c:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     780:	04020030 	streq	r0, [r2], #-48	; 0xffffffd0
     784:	45056702 	strmi	r6, [r5, #-1794]	; 0xfffff8fe
     788:	02040200 	andeq	r0, r4, #0, 4
     78c:	0028059e 	mlaeq	r8, lr, r5, r0
     790:	66020402 	strvs	r0, [r2], -r2, lsl #8
     794:	02003005 	andeq	r3, r0, #5
     798:	2e020204 	cdpcs	2, 0, cr0, cr2, cr4, {0}
     79c:	00450513 	subeq	r0, r5, r3, lsl r5
     7a0:	9e020402 	cdpls	4, 0, cr0, cr2, cr2, {0}
     7a4:	02002805 	andeq	r2, r0, #327680	; 0x50000
     7a8:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
     7ac:	04020030 	streq	r0, [r2], #-48	; 0xffffffd0
     7b0:	132e0202 			; <UNDEFINED> instruction: 0x132e0202
     7b4:	02004505 	andeq	r4, r0, #20971520	; 0x1400000
     7b8:	059e0204 	ldreq	r0, [lr, #516]	; 0x204
     7bc:	04020028 	streq	r0, [r2], #-40	; 0xffffffd8
     7c0:	30056602 	andcc	r6, r5, r2, lsl #12
     7c4:	02040200 	andeq	r0, r4, #0, 4
     7c8:	05132e02 	ldreq	r2, [r3, #-3586]	; 0xfffff1fe
     7cc:	04020045 	streq	r0, [r2], #-69	; 0xffffffbb
     7d0:	28059e02 	stmdacs	r5, {r1, r9, sl, fp, ip, pc}
     7d4:	02040200 	andeq	r0, r4, #0, 4
     7d8:	00300566 	eorseq	r0, r0, r6, ror #10
     7dc:	02020402 	andeq	r0, r2, #33554432	; 0x2000000
     7e0:	4505132e 	strmi	r1, [r5, #-814]	; 0xfffffcd2
     7e4:	02040200 	andeq	r0, r4, #0, 4
     7e8:	0028059e 	mlaeq	r8, lr, r5, r0
     7ec:	66020402 	strvs	r0, [r2], -r2, lsl #8
     7f0:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
     7f4:	2e020204 	cdpcs	2, 0, cr0, cr2, cr4, {0}
     7f8:	8a1a050d 	bhi	681c34 <__bss_end+0x675d2c>
     7fc:	02002305 	andeq	r2, r0, #335544320	; 0x14000000
     800:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     804:	0402002b 	streq	r0, [r2], #-43	; 0xffffffd5
     808:	44056702 	strmi	r6, [r5], #-1794	; 0xfffff8fe
     80c:	02040200 	andeq	r0, r4, #0, 4
     810:	3a052008 	bcc	148838 <__bss_end+0x13c930>
     814:	02040200 	andeq	r0, r4, #0, 4
     818:	0050059e 			; <UNDEFINED> instruction: 0x0050059e
     81c:	4a020402 	bmi	8182c <__bss_end+0x75924>
     820:	02006205 	andeq	r6, r0, #1342177280	; 0x50000000
     824:	3c080204 	sfmcc	f0, 4, [r8], {4}
     828:	02002b05 	andeq	r2, r0, #5120	; 0x1400
     82c:	059e0204 	ldreq	r0, [lr, #516]	; 0x204
     830:	04020071 	streq	r0, [r2], #-113	; 0xffffff8f
     834:	2b052e02 	blcs	14c044 <__bss_end+0x14013c>
     838:	02040200 	andeq	r0, r4, #0, 4
     83c:	001105ba 			; <UNDEFINED> instruction: 0x001105ba
     840:	9d020402 	cfstrsls	mvf0, [r2, #-8]
     844:	24021a05 	strcs	r1, [r2], #-2565	; 0xfffff5fb
     848:	d8550517 	ldmdale	r5, {r0, r1, r2, r4, r8, sl}^
     84c:	059e4b05 	ldreq	r4, [lr, #2821]	; 0xb05
     850:	73054a61 	movwvc	r4, #23137	; 0x5a61
     854:	3c053c08 	stccc	12, cr3, [r5], {8}
     858:	2f49059e 	svccs	0x0049059e
     85c:	05b93c05 	ldreq	r3, [r9, #3077]!	; 0xc05
     860:	0521084a 	streq	r0, [r1, #-2122]!	; 0xfffff7b6
     864:	27054c15 	smladcs	r5, r5, ip, r4
     868:	d91c0567 	ldmdble	ip, {r0, r1, r2, r5, r6, r8, sl}
     86c:	054a1305 	strbeq	r1, [sl, #-773]	; 0xfffffcfb
     870:	055a080d 	ldrbeq	r0, [sl, #-2061]	; 0xfffff7f3
     874:	0d05320e 	sfmeq	f3, 4, [r5, #-56]	; 0xffffffc8
     878:	ba7fb003 	blt	1fec88c <__bss_end+0x1fe0984>
     87c:	0305054f 	movweq	r0, #21839	; 0x554f
     880:	052e00cc 	streq	r0, [lr, #-204]!	; 0xffffff34
     884:	2e0b0321 	cdpcs	3, 0, cr0, cr11, cr1, {1}
     888:	059f1e05 	ldreq	r1, [pc, #3589]	; 1695 <shift+0x1695>
     88c:	18058416 	stmdane	r5, {r1, r2, r4, sl, pc}
     890:	4b0a054b 	blmi	281dc4 <__bss_end+0x275ebc>
     894:	6b1505a0 	blvs	541f1c <__bss_end+0x536014>
     898:	4c4d0c05 	mcrrmi	12, 0, r0, sp, cr5
     89c:	052f0105 	streq	r0, [pc, #-261]!	; 79f <shift+0x79f>
     8a0:	d609034e 	strle	r0, [r9], -lr, asr #6
     8a4:	4bbb0e05 	blmi	feec40c0 <__bss_end+0xfeeb81b8>
     8a8:	4b09054c 	blmi	241de0 <__bss_end+0x235ed8>
     8ac:	059f2605 	ldreq	r2, [pc, #1541]	; eb9 <shift+0xeb9>
     8b0:	43056636 	movwmi	r6, #22070	; 0x5636
     8b4:	6636054a 	ldrtvs	r0, [r6], -sl, asr #10
     8b8:	054a0c05 	strbeq	r0, [sl, #-3077]	; 0xfffff3fb
     8bc:	28054b19 	stmdacs	r5, {r0, r3, r4, r8, r9, fp, lr}
     8c0:	66210566 	strtvs	r0, [r1], -r6, ror #10
     8c4:	05821905 	streq	r1, [r2, #2309]	; 0x905
     8c8:	01052e35 	tsteq	r5, r5, lsr lr
     8cc:	6933054b 	ldmdbvs	r3!, {r0, r1, r3, r6, r8, sl}
     8d0:	4bbc0905 	blmi	fef02cec <__bss_end+0xfeef6de4>
     8d4:	054b0e05 	strbeq	r0, [fp, #-3589]	; 0xfffff1fb
     8d8:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
     8dc:	10054a01 	andne	r4, r5, r1, lsl #20
     8e0:	f2120583 	vrshl.s16	d0, d3, d18
     8e4:	052e2005 	streq	r2, [lr, #-5]!
     8e8:	0905f222 	stmdbeq	r5, {r1, r5, r9, ip, sp, lr, pc}
     8ec:	6711052e 	ldrvs	r0, [r1, -lr, lsr #10]
     8f0:	05830d05 	streq	r0, [r3, #3333]	; 0xd05
     8f4:	04020005 	streq	r0, [r2], #-5
     8f8:	09056302 	stmdbeq	r5, {r1, r8, r9, sp, lr}
     8fc:	830c0588 	movwhi	r0, #50568	; 0xc588
     900:	05300105 	ldreq	r0, [r0, #-261]!	; 0xfffffefb
     904:	1f056831 	svcne	0x00056831
     908:	f21005bb 	vqrshl.s16	d0, d27, d16
     90c:	05f31905 	ldrbeq	r1, [r3, #2309]!	; 0x905
     910:	e508f20f 	str	pc, [r8, #-527]	; 0xfffffdf1
     914:	e5080105 	str	r0, [r8, #-261]	; 0xfffffefb
     918:	056e3405 	strbeq	r3, [lr, #-1029]!	; 0xfffffbfb
     91c:	1a05bb05 	bne	16f538 <__bss_end+0x163630>
     920:	9f120583 	svcls	0x00120583
     924:	bc0105bb 	cfstr32lt	mvfx0, [r1], {187}	; 0xbb
     928:	01000602 	tsteq	r0, r2, lsl #12
     92c:	05020401 	streq	r0, [r2, #-1025]	; 0xfffffbff
     930:	0205000c 	andeq	r0, r5, #12
     934:	000096d0 	ldrdeq	r9, [r0], -r0
     938:	05011f03 	streq	r1, [r1, #-3843]	; 0xfffff0fd
     93c:	14059f10 	strne	r9, [r5], #-3856	; 0xfffff0f0
     940:	4a12054a 	bmi	481e70 <__bss_end+0x475f68>
     944:	052e1605 	streq	r1, [lr, #-1541]!	; 0xfffff9fb
     948:	39054a3b 	stmdbcc	r5, {r0, r1, r3, r4, r5, r9, fp, lr}
     94c:	4a3d054a 	bmi	f41e7c <__bss_end+0xf35f74>
     950:	054a3f05 	strbeq	r3, [sl, #-3845]	; 0xfffff0fb
     954:	12022f05 	andne	r2, r2, #5, 30
     958:	04010100 	streq	r0, [r1], #-256	; 0xffffff00
     95c:	000c0502 	andeq	r0, ip, r2, lsl #10
     960:	97400205 	strbls	r0, [r0, -r5, lsl #4]
     964:	29030000 	stmdbcs	r3, {}	; <UNPREDICTABLE>
     968:	d8180501 	ldmdale	r8, {r0, r8, sl}
     96c:	05822305 	streq	r2, [r2, #773]	; 0x305
     970:	27054a21 	strcs	r4, [r5, -r1, lsr #20]
     974:	4a2d052e 	bmi	b41e34 <__bss_end+0xb35f2c>
     978:	05822905 	streq	r2, [r2, #2309]	; 0x905
     97c:	44052e3b 	strmi	r2, [r5], #-3643	; 0xfffff1c5
     980:	4a360582 	bmi	d81f90 <__bss_end+0xd76088>
     984:	052e2505 	streq	r2, [lr, #-1285]!	; 0xfffffafb
     988:	13052e50 	movwne	r2, #24144	; 0x5e50
     98c:	ba0e0584 	blt	381fa4 <__bss_end+0x37609c>
     990:	054c1005 	strbeq	r1, [ip, #-5]
     994:	08024b05 	stmdaeq	r2, {r0, r2, r8, r9, fp, lr}
     998:	53010100 	movwpl	r0, #4352	; 0x1100
     99c:	03000001 	movweq	r0, #1
     9a0:	00009300 	andeq	r9, r0, r0, lsl #6
     9a4:	fb010200 	blx	411ae <__bss_end+0x352a6>
     9a8:	01000d0e 	tsteq	r0, lr, lsl #26
     9ac:	00010101 	andeq	r0, r1, r1, lsl #2
     9b0:	00010000 	andeq	r0, r1, r0
     9b4:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     9b8:	2f656d6f 	svccs	0x00656d6f
     9bc:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
     9c0:	642f6b69 	strtvs	r6, [pc], #-2921	; 9c8 <shift+0x9c8>
     9c4:	662f7665 	strtvs	r7, [pc], -r5, ror #12
     9c8:	6c616e69 	stclvs	14, cr6, [r1], #-420	; 0xfffffe5c
     9cc:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     9d0:	756f732f 	strbvc	r7, [pc, #-815]!	; 6a9 <shift+0x6a9>
     9d4:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     9d8:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     9dc:	2f62696c 	svccs	0x0062696c
     9e0:	00637273 	rsbeq	r7, r3, r3, ror r2
     9e4:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 930 <shift+0x930>
     9e8:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     9ec:	6b69746e 	blvs	1a5dbac <__bss_end+0x1a51ca4>
     9f0:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
     9f4:	6e69662f 	cdpvs	6, 6, cr6, cr9, cr15, {1}
     9f8:	732f6c61 			; <UNDEFINED> instruction: 0x732f6c61
     9fc:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
     a00:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     a04:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
     a08:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
     a0c:	6e692f62 	cdpvs	15, 6, cr2, cr9, cr2, {3}
     a10:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     a14:	73000065 	movwvc	r0, #101	; 0x65
     a18:	75626474 	strbvc	r6, [r2, #-1140]!	; 0xfffffb8c
     a1c:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     a20:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     a24:	00000100 	andeq	r0, r0, r0, lsl #2
     a28:	62647473 	rsbvs	r7, r4, #1929379840	; 0x73000000
     a2c:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     a30:	00682e72 	rsbeq	r2, r8, r2, ror lr
     a34:	00000002 	andeq	r0, r0, r2
     a38:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
     a3c:	0097fc02 	addseq	pc, r7, r2, lsl #24
     a40:	2f051600 	svccs	0x00051600
     a44:	080d0583 	stmdaeq	sp, {r0, r1, r7, r8, sl}
     a48:	00160522 	andseq	r0, r6, r2, lsr #10
     a4c:	4a030402 	bmi	c1a5c <__bss_end+0xb5b54>
     a50:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
     a54:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
     a58:	04020005 	streq	r0, [r2], #-5
     a5c:	01059c02 	tsteq	r5, r2, lsl #24
     a60:	0805a186 	stmdaeq	r5, {r1, r2, r7, r8, sp, pc}
     a64:	4a050583 	bmi	142078 <__bss_end+0x136170>
     a68:	054b1005 	strbeq	r1, [fp, #-5]
     a6c:	0c054c0e 	stceq	12, cr4, [r5], {14}
     a70:	2f010567 	svccs	0x00010567
     a74:	830d0585 	movwhi	r0, #54661	; 0xd585
     a78:	02001605 	andeq	r1, r0, #5242880	; 0x500000
     a7c:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     a80:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
     a84:	05056802 	streq	r6, [r5, #-2050]	; 0xfffff7fe
     a88:	02040200 	andeq	r0, r4, #0, 4
     a8c:	870e059c 			; <UNDEFINED> instruction: 0x870e059c
     a90:	85670105 	strbhi	r0, [r7, #-261]!	; 0xfffffefb
     a94:	05830c05 	streq	r0, [r3, #3077]	; 0xc05
     a98:	01054a15 	tsteq	r5, r5, lsl sl
     a9c:	0d058567 	cfstr32eq	mvfx8, [r5, #-412]	; 0xfffffe64
     aa0:	4a1705bb 	bmi	5c2194 <__bss_end+0x5b628c>
     aa4:	05671105 	strbeq	r1, [r7, #-261]!	; 0xfffffefb
     aa8:	1f054a1a 	svcne	0x00054a1a
     aac:	820e052e 	andhi	r0, lr, #192937984	; 0xb800000
     ab0:	854b0105 	strbhi	r0, [fp, #-261]	; 0xfffffefb
     ab4:	05830805 	streq	r0, [r3, #2053]	; 0x805
     ab8:	05054a14 	streq	r4, [r5, #-2580]	; 0xfffff5ec
     abc:	4b10054a 	blmi	401fec <__bss_end+0x3f60e4>
     ac0:	054c1305 	strbeq	r1, [ip, #-773]	; 0xfffffcfb
     ac4:	11054a09 	tstne	r5, r9, lsl #20
     ac8:	4a1a0567 	bmi	68206c <__bss_end+0x676164>
     acc:	052e1f05 	streq	r1, [lr, #-3845]!	; 0xfffff0fb
     ad0:	0c05820e 	sfmeq	f0, 1, [r5], {14}
     ad4:	2f01054b 	svccs	0x0001054b
     ad8:	02009e82 	andeq	r9, r0, #2080	; 0x820
     adc:	66060104 	strvs	r0, [r6], -r4, lsl #2
     ae0:	03060805 	movweq	r0, #26629	; 0x6805
     ae4:	0105824f 	tsteq	r5, pc, asr #4
     ae8:	9e4a3103 	dvflse	f3, f2, f3
     aec:	000a024a 	andeq	r0, sl, sl, asr #4
     af0:	02980101 	addseq	r0, r8, #1073741824	; 0x40000000
     af4:	00030000 	andeq	r0, r3, r0
     af8:	00000155 	andeq	r0, r0, r5, asr r1
     afc:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     b00:	0101000d 	tsteq	r1, sp
     b04:	00000101 	andeq	r0, r0, r1, lsl #2
     b08:	00000100 	andeq	r0, r0, r0, lsl #2
     b0c:	6f682f01 	svcvs	0x00682f01
     b10:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
     b14:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
     b18:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
     b1c:	69662f76 	stmdbvs	r6!, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
     b20:	2f6c616e 	svccs	0x006c616e
     b24:	2f637273 	svccs	0x00637273
     b28:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     b2c:	2f736563 	svccs	0x00736563
     b30:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
     b34:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
     b38:	2f006372 	svccs	0x00006372
     b3c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     b40:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
     b44:	2f6b6974 	svccs	0x006b6974
     b48:	2f766564 	svccs	0x00766564
     b4c:	616e6966 	cmnvs	lr, r6, ror #18
     b50:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     b54:	6f732f63 	svcvs	0x00732f63
     b58:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     b5c:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
     b60:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     b64:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     b68:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     b6c:	6f72702f 	svcvs	0x0072702f
     b70:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b74:	6f682f00 	svcvs	0x00682f00
     b78:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
     b7c:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
     b80:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
     b84:	69662f76 	stmdbvs	r6!, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
     b88:	2f6c616e 	svccs	0x006c616e
     b8c:	2f637273 	svccs	0x00637273
     b90:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     b94:	2f736563 	svccs	0x00736563
     b98:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     b9c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     ba0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     ba4:	662f6564 	strtvs	r6, [pc], -r4, ror #10
     ba8:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     bac:	2f656d6f 	svccs	0x00656d6f
     bb0:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
     bb4:	642f6b69 	strtvs	r6, [pc], #-2921	; bbc <shift+0xbbc>
     bb8:	662f7665 	strtvs	r7, [pc], -r5, ror #12
     bbc:	6c616e69 	stclvs	14, cr6, [r1], #-420	; 0xfffffe5c
     bc0:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     bc4:	756f732f 	strbvc	r7, [pc, #-815]!	; 89d <shift+0x89d>
     bc8:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     bcc:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     bd0:	2f6c656e 	svccs	0x006c656e
     bd4:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     bd8:	2f656475 	svccs	0x00656475
     bdc:	72616f62 	rsbvc	r6, r1, #392	; 0x188
     be0:	70722f64 	rsbsvc	r2, r2, r4, ror #30
     be4:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
     be8:	00006c61 	andeq	r6, r0, r1, ror #24
     bec:	66647473 			; <UNDEFINED> instruction: 0x66647473
     bf0:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
     bf4:	00707063 	rsbseq	r7, r0, r3, rrx
     bf8:	73000001 	movwvc	r0, #1
     bfc:	682e6977 	stmdavs	lr!, {r0, r1, r2, r4, r5, r6, r8, fp, sp, lr}
     c00:	00000200 	andeq	r0, r0, r0, lsl #4
     c04:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
     c08:	6b636f6c 	blvs	18dc9c0 <__bss_end+0x18d0ab8>
     c0c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     c10:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
     c14:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     c18:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     c1c:	0300682e 	movweq	r6, #2094	; 0x82e
     c20:	72700000 	rsbsvc	r0, r0, #0
     c24:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     c28:	00682e73 	rsbeq	r2, r8, r3, ror lr
     c2c:	70000002 	andvc	r0, r0, r2
     c30:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     c34:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; a70 <shift+0xa70>
     c38:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     c3c:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
     c40:	00000200 	andeq	r0, r0, r0, lsl #4
     c44:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
     c48:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
     c4c:	00000400 	andeq	r0, r0, r0, lsl #8
     c50:	00010500 	andeq	r0, r1, r0, lsl #10
     c54:	9aa00205 	bls	fe801470 <__bss_end+0xfe7f5568>
     c58:	05160000 	ldreq	r0, [r6, #-0]
     c5c:	2c05691a 			; <UNDEFINED> instruction: 0x2c05691a
     c60:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     c64:	852f0105 	strhi	r0, [pc, #-261]!	; b67 <shift+0xb67>
     c68:	05691a05 	strbeq	r1, [r9, #-2565]!	; 0xfffff5fb
     c6c:	0c052f2c 	stceq	15, cr2, [r5], {44}	; 0x2c
     c70:	2f01054c 	svccs	0x0001054c
     c74:	83320585 	teqhi	r2, #557842432	; 0x21400000
     c78:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
     c7c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     c80:	01054b1a 	tsteq	r5, sl, lsl fp
     c84:	3205852f 	andcc	r8, r5, #197132288	; 0xbc00000
     c88:	4b2e05a1 	blmi	b82314 <__bss_end+0xb7640c>
     c8c:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
     c90:	0c052f2d 	stceq	15, cr2, [r5], {45}	; 0x2d
     c94:	2f01054c 	svccs	0x0001054c
     c98:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
     c9c:	054b3005 	strbeq	r3, [fp, #-5]
     ca0:	1b054b2e 	blne	153960 <__bss_end+0x147a58>
     ca4:	2f2e054b 	svccs	0x002e054b
     ca8:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     cac:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     cb0:	3005bd2e 	andcc	fp, r5, lr, lsr #26
     cb4:	4b2e054b 	blmi	b821e8 <__bss_end+0xb762e0>
     cb8:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
     cbc:	0c052f2e 	stceq	15, cr2, [r5], {46}	; 0x2e
     cc0:	2f01054c 	svccs	0x0001054c
     cc4:	832e0585 			; <UNDEFINED> instruction: 0x832e0585
     cc8:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
     ccc:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     cd0:	3305bd2e 	movwcc	fp, #23854	; 0x5d2e
     cd4:	4b2f054b 	blmi	bc2208 <__bss_end+0xbb6300>
     cd8:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
     cdc:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
     ce0:	2f01054c 	svccs	0x0001054c
     ce4:	a12e0585 	smlawbge	lr, r5, r5, r0
     ce8:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
     cec:	2f054b1b 	svccs	0x00054b1b
     cf0:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     cf4:	852f0105 	strhi	r0, [pc, #-261]!	; bf7 <shift+0xbf7>
     cf8:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
     cfc:	3b054b2f 	blcc	1539c0 <__bss_end+0x147ab8>
     d00:	4b1b054b 	blmi	6c2234 <__bss_end+0x6b632c>
     d04:	052f3005 	streq	r3, [pc, #-5]!	; d07 <shift+0xd07>
     d08:	01054c0c 	tsteq	r5, ip, lsl #24
     d0c:	2f05852f 	svccs	0x0005852f
     d10:	4b3b05a1 	blmi	ec239c <__bss_end+0xeb6494>
     d14:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
     d18:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
     d1c:	9f01054c 	svcls	0x0001054c
     d20:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
     d24:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
     d28:	1a054b31 	bne	1539f4 <__bss_end+0x147aec>
     d2c:	300c054b 	andcc	r0, ip, fp, asr #10
     d30:	852f0105 	strhi	r0, [pc, #-261]!	; c33 <shift+0xc33>
     d34:	05672005 	strbeq	r2, [r7, #-5]!
     d38:	31054d2d 	tstcc	r5, sp, lsr #26
     d3c:	4b1a054b 	blmi	682270 <__bss_end+0x676368>
     d40:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
     d44:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     d48:	2d058320 	stccs	3, cr8, [r5, #-128]	; 0xffffff80
     d4c:	4b3e054c 	blmi	f82284 <__bss_end+0xf7637c>
     d50:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
     d54:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     d58:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
     d5c:	4b30054d 	blmi	c02298 <__bss_end+0xbf6390>
     d60:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
     d64:	0105300c 	tsteq	r5, ip
     d68:	0c05872f 	stceq	7, cr8, [r5], {47}	; 0x2f
     d6c:	31059fa0 	smlatbcc	r5, r0, pc, r9	; <UNPREDICTABLE>
     d70:	662905bc 			; <UNDEFINED> instruction: 0x662905bc
     d74:	052e3605 	streq	r3, [lr, #-1541]!	; 0xfffff9fb
     d78:	1305300f 	movwne	r3, #20495	; 0x500f
     d7c:	84090566 	strhi	r0, [r9], #-1382	; 0xfffffa9a
     d80:	05d81005 	ldrbeq	r1, [r8, #5]
     d84:	01059e33 	tsteq	r5, r3, lsr lr
     d88:	0008022f 	andeq	r0, r8, pc, lsr #4
     d8c:	02800101 	addeq	r0, r0, #1073741824	; 0x40000000
     d90:	00030000 	andeq	r0, r3, r0
     d94:	00000136 	andeq	r0, r0, r6, lsr r1
     d98:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
     d9c:	0101000d 	tsteq	r1, sp
     da0:	00000101 	andeq	r0, r0, r1, lsl #2
     da4:	00000100 	andeq	r0, r0, r0, lsl #2
     da8:	6f682f01 	svcvs	0x00682f01
     dac:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
     db0:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
     db4:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
     db8:	69662f76 	stmdbvs	r6!, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
     dbc:	2f6c616e 	svccs	0x006c616e
     dc0:	2f637273 	svccs	0x00637273
     dc4:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     dc8:	2f736563 	svccs	0x00736563
     dcc:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
     dd0:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
     dd4:	2f006372 	svccs	0x00006372
     dd8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     ddc:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
     de0:	2f6b6974 	svccs	0x006b6974
     de4:	2f766564 	svccs	0x00766564
     de8:	616e6966 	cmnvs	lr, r6, ror #18
     dec:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
     df0:	6f732f63 	svcvs	0x00732f63
     df4:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     df8:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
     dfc:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     e00:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     e04:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     e08:	616f622f 	cmnvs	pc, pc, lsr #4
     e0c:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
     e10:	2f306970 	svccs	0x00306970
     e14:	006c6168 	rsbeq	r6, ip, r8, ror #2
     e18:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; d64 <shift+0xd64>
     e1c:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     e20:	6b69746e 	blvs	1a5dfe0 <__bss_end+0x1a520d8>
     e24:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
     e28:	6e69662f 	cdpvs	6, 6, cr6, cr9, cr15, {1}
     e2c:	732f6c61 			; <UNDEFINED> instruction: 0x732f6c61
     e30:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
     e34:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     e38:	6b2f7365 	blvs	bddbd4 <__bss_end+0xbd1ccc>
     e3c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
     e40:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
     e44:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
     e48:	656d2f65 	strbvs	r2, [sp, #-3941]!	; 0xfffff09b
     e4c:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     e50:	6f682f00 	svcvs	0x00682f00
     e54:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
     e58:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
     e5c:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
     e60:	69662f76 	stmdbvs	r6!, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
     e64:	2f6c616e 	svccs	0x006c616e
     e68:	2f637273 	svccs	0x00637273
     e6c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     e70:	2f736563 	svccs	0x00736563
     e74:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
     e78:	692f6269 	stmdbvs	pc!, {r0, r3, r5, r6, r9, sp, lr}	; <UNPREDICTABLE>
     e7c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     e80:	00006564 	andeq	r6, r0, r4, ror #10
     e84:	6d647473 	cfstrdvs	mvd7, [r4, #-460]!	; 0xfffffe34
     e88:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
     e8c:	70632e79 	rsbvc	r2, r3, r9, ror lr
     e90:	00010070 	andeq	r0, r1, r0, ror r0
     e94:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     e98:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
     e9c:	00020068 	andeq	r0, r2, r8, rrx
     ea0:	72657000 	rsbvc	r7, r5, #0
     ea4:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
     ea8:	736c6172 	cmnvc	ip, #-2147483620	; 0x8000001c
     eac:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     eb0:	656d0000 	strbvs	r0, [sp, #-0]!
     eb4:	70616d6d 	rsbvc	r6, r1, sp, ror #26
     eb8:	0300682e 	movweq	r6, #2094	; 0x82e
     ebc:	74730000 	ldrbtvc	r0, [r3], #-0
     ec0:	6d656d64 	stclvs	13, cr6, [r5, #-400]!	; 0xfffffe70
     ec4:	2e79726f 	cdpcs	2, 7, cr7, cr9, cr15, {3}
     ec8:	00040068 	andeq	r0, r4, r8, rrx
     ecc:	01050000 	mrseq	r0, (UNDEF: 5)
     ed0:	2c020500 	cfstr32cs	mvfx0, [r2], {-0}
     ed4:	1800009f 	stmdane	r0, {r0, r1, r2, r3, r4, r7}
     ed8:	05840c05 	streq	r0, [r4, #3077]	; 0xc05
     edc:	2805670b 	stmdacs	r5, {r0, r1, r3, r8, r9, sl, sp, lr}
     ee0:	840b0567 	strhi	r0, [fp], #-1383	; 0xfffffa99
     ee4:	67670c05 	strbvs	r0, [r7, -r5, lsl #24]!
     ee8:	85670105 	strbhi	r0, [r7, #-261]!	; 0xfffffefb
     eec:	05a23505 	streq	r3, [r2, #1285]!	; 0x505
     ef0:	30054b1a 	andcc	r4, r5, sl, lsl fp
     ef4:	4b33052f 	blmi	cc23b8 <__bss_end+0xcb64b0>
     ef8:	054b0605 	strbeq	r0, [fp, #-1541]	; 0xfffff9fb
     efc:	054c4a0c 	strbeq	r4, [ip, #-2572]	; 0xfffff5f4
     f00:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     f04:	2805a135 	stmdacs	r5, {r0, r2, r4, r5, r8, sp, pc}
     f08:	4a2f054b 	bmi	bc243c <__bss_end+0xbb6534>
     f0c:	052f1a05 	streq	r1, [pc, #-2565]!	; 50f <shift+0x50f>
     f10:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
     f14:	2f01054c 	svccs	0x0001054c
     f18:	d7180585 	ldrle	r0, [r8, -r5, lsl #11]
     f1c:	054a1f05 	strbeq	r1, [sl, #-3845]	; 0xfffff0fb
     f20:	05054a0e 	streq	r4, [r5, #-2574]	; 0xfffff5f2
     f24:	6827054b 	stmdavs	r7!, {r0, r1, r3, r6, r8, sl}
     f28:	05bc1005 	ldreq	r1, [ip, #5]!
     f2c:	18054b1a 	stmdane	r5, {r1, r3, r4, r8, r9, fp, lr}
     f30:	26054b4a 	strcs	r4, [r5], -sl, asr #22
     f34:	4a1b0567 	bmi	6c24d8 <__bss_end+0x6b65d0>
     f38:	674b1805 	strbvs	r1, [fp, -r5, lsl #16]
     f3c:	05680905 	strbeq	r0, [r8, #-2309]!	; 0xfffff6fb
     f40:	10054a16 	andne	r4, r5, r6, lsl sl
     f44:	6811054b 	ldmdavs	r1, {r0, r1, r3, r6, r8, sl}
     f48:	054a1705 	strbeq	r1, [sl, #-1797]	; 0xfffff8fb
     f4c:	12052e0f 	andne	r2, r5, #15, 28	; 0xf0
     f50:	4a19054b 	bmi	642484 <__bss_end+0x63657c>
     f54:	052e1005 	streq	r1, [lr, #-5]!
     f58:	1a054b12 	bne	153ba8 <__bss_end+0x147ca0>
     f5c:	2e10054a 	cfmac32cs	mvfx0, mvfx0, mvfx10
     f60:	054b0905 	strbeq	r0, [fp, #-2309]	; 0xfffff6fb
     f64:	19053212 	stmdbne	r5, {r1, r4, r9, ip, sp}
     f68:	4a20054a 	bmi	802498 <__bss_end+0x7f6590>
     f6c:	052e1005 	streq	r1, [lr, #-5]!
     f70:	01054b09 	tsteq	r5, r9, lsl #22
     f74:	0e054d30 	mcreq	13, 0, r4, cr5, cr0, {1}
     f78:	6808059f 	stmdavs	r8, {r0, r1, r2, r3, r4, r7, r8, sl}
     f7c:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
     f80:	09054c10 	stmdbeq	r5, {r4, sl, fp, lr}
     f84:	4a160567 	bmi	582528 <__bss_end+0x576620>
     f88:	054b0905 	strbeq	r0, [fp, #-2309]	; 0xfffff6fb
     f8c:	09054a16 	stmdbeq	r5, {r1, r2, r4, r9, fp, lr}
     f90:	4a19054b 	bmi	6424c4 <__bss_end+0x6365bc>
     f94:	054b0905 	strbeq	r0, [fp, #-2309]	; 0xfffff6fb
     f98:	09054a16 	stmdbeq	r5, {r1, r2, r4, r9, fp, lr}
     f9c:	4a16054b 	bmi	5824d0 <__bss_end+0x5765c8>
     fa0:	054b0d05 	strbeq	r0, [fp, #-3333]	; 0xfffff2fb
     fa4:	3305bb2b 	movwcc	fp, #23339	; 0x5b2b
     fa8:	2e3c054a 	cdpcs	5, 3, cr0, cr12, cr10, {2}
     fac:	052e4a05 	streq	r4, [lr, #-2565]!	; 0xfffff5fb
     fb0:	1d05311f 	stfnes	f3, [r5, #-124]	; 0xffffff84
     fb4:	6628054a 	strtvs	r0, [r8], -sl, asr #10
     fb8:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
     fbc:	2b054c0d 	blcs	153ff8 <__bss_end+0x1480f0>
     fc0:	4a330583 	bmi	cc25d4 <__bss_end+0xcb66cc>
     fc4:	052e3a05 	streq	r3, [lr, #-2565]!	; 0xfffff5fb
     fc8:	0c053130 	stfeqs	f3, [r5], {48}	; 0x30
     fcc:	2f16054a 	svccs	0x0016054a
     fd0:	4b4a1405 	blmi	1285fec <__bss_end+0x127a0e4>
     fd4:	05671905 	strbeq	r1, [r7, #-2309]!	; 0xfffff6fb
     fd8:	17054a20 	strne	r4, [r5, -r0, lsr #20]
     fdc:	4b14052e 	blmi	50249c <__bss_end+0x4f6594>
     fe0:	68050567 	stmdavs	r5, {r0, r1, r2, r5, r6, r8, sl}
     fe4:	054a1205 	strbeq	r1, [sl, #-517]	; 0xfffffdfb
     fe8:	09054b0c 	stmdbeq	r5, {r2, r3, r8, r9, fp, lr}
     fec:	bb270567 	bllt	9c2590 <__bss_end+0x9b6688>
     ff0:	054a2f05 	strbeq	r2, [sl, #-3845]	; 0xfffff0fb
     ff4:	9e662f01 	cdpls	15, 6, cr2, cr6, cr1, {0}
     ff8:	01040200 	mrseq	r0, R12_usr
     ffc:	0e056606 	cfmadd32eq	mvax0, mvfx6, mvfx5, mvfx6
    1000:	7f9b0306 	svcvc	0x009b0306
    1004:	03010582 	movweq	r0, #5506	; 0x1582
    1008:	9e4a00e5 	cdpls	0, 4, cr0, cr10, cr5, {7}
    100c:	000a024a 	andeq	r0, sl, sl, asr #4
    1010:	055d0101 	ldrbeq	r0, [sp, #-257]	; 0xfffffeff
    1014:	00030000 	andeq	r0, r3, r0
    1018:	00000052 	andeq	r0, r0, r2, asr r0
    101c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    1020:	0101000d 	tsteq	r1, sp
    1024:	00000101 	andeq	r0, r0, r1, lsl #2
    1028:	00000100 	andeq	r0, r0, r0, lsl #2
    102c:	6f682f01 	svcvs	0x00682f01
    1030:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    1034:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    1038:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
    103c:	69662f76 	stmdbvs	r6!, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
    1040:	2f6c616e 	svccs	0x006c616e
    1044:	2f637273 	svccs	0x00637273
    1048:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    104c:	2f736563 	svccs	0x00736563
    1050:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    1054:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    1058:	00006372 	andeq	r6, r0, r2, ror r3
    105c:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
    1060:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    1064:	70632e67 	rsbvc	r2, r3, r7, ror #28
    1068:	00010070 	andeq	r0, r1, r0, ror r0
    106c:	21050000 	mrscs	r0, (UNDEF: 5)
    1070:	60020500 	andvs	r0, r2, r0, lsl #10
    1074:	180000a3 	stmdane	r0, {r0, r1, r5, r7}
    1078:	059f0905 	ldreq	r0, [pc, #2309]	; 1985 <shift+0x1985>
    107c:	14054b11 	strne	r4, [r5], #-2833	; 0xfffff4ef
    1080:	bb100566 	bllt	402620 <__bss_end+0x3f6718>
    1084:	05810505 	streq	r0, [r1, #1285]	; 0x505
    1088:	0105310c 	tsteq	r5, ip, lsl #2
    108c:	841d052f 	ldrhi	r0, [sp], #-1327	; 0xfffffad1
    1090:	05a20a05 	streq	r0, [r2, #2565]!	; 0xa05
    1094:	0e056705 	cdpeq	7, 0, cr6, cr5, cr5, {0}
    1098:	670b0583 	strvs	r0, [fp, -r3, lsl #11]
    109c:	05690d05 	strbeq	r0, [r9, #-3333]!	; 0xfffff2fb
    10a0:	059f4b0c 	ldreq	r4, [pc, #2828]	; 1bb4 <shift+0x1bb4>
    10a4:	1705670d 	strne	r6, [r5, -sp, lsl #14]
    10a8:	66150569 	ldrvs	r0, [r5], -r9, ror #10
    10ac:	054a2e05 	strbeq	r2, [sl, #-3589]	; 0xfffff1fb
    10b0:	0402003e 	streq	r0, [r2], #-62	; 0xffffffc2
    10b4:	3c056601 	stccc	6, cr6, [r5], {1}
    10b8:	01040200 	mrseq	r0, R12_usr
    10bc:	002e0566 	eoreq	r0, lr, r6, ror #10
    10c0:	4a010402 	bmi	420d0 <__bss_end+0x361c8>
    10c4:	05672b05 	strbeq	r2, [r7, #-2821]!	; 0xfffff4fb
    10c8:	15054a1c 	strne	r4, [r5, #-2588]	; 0xfffff5e4
    10cc:	2e110582 	cdpcs	5, 1, cr0, cr1, cr2, {4}
    10d0:	a0671005 	rsbge	r1, r7, r5
    10d4:	057e0505 	ldrbeq	r0, [lr, #-1285]!	; 0xfffffafb
    10d8:	1b053616 	blne	14e938 <__bss_end+0x142a30>
    10dc:	821105d6 	andshi	r0, r1, #897581056	; 0x35800000
    10e0:	02002605 	andeq	r2, r0, #5242880	; 0x500000
    10e4:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
    10e8:	0402000b 	streq	r0, [r2], #-11
    10ec:	05059f02 	streq	r9, [r5, #-3842]	; 0xfffff0fe
    10f0:	02040200 	andeq	r0, r4, #0, 4
    10f4:	f50e0581 			; <UNDEFINED> instruction: 0xf50e0581
    10f8:	054b1505 	strbeq	r1, [fp, #-1285]	; 0xfffffafb
    10fc:	0c056619 	stceq	6, cr6, [r5], {25}
    1100:	05054b9e 	streq	r4, [r5, #-2974]	; 0xfffff462
    1104:	830f059f 	movwhi	r0, #62879	; 0xf59f
    1108:	05d71105 	ldrbeq	r1, [r7, #261]	; 0x105
    110c:	1805d90c 	stmdane	r5, {r2, r3, r8, fp, ip, lr, pc}
    1110:	01040200 	mrseq	r0, R12_usr
    1114:	830f054a 	movwhi	r0, #62794	; 0xf54a
    1118:	052e0905 	streq	r0, [lr, #-2309]!	; 0xfffff6fb
    111c:	12058310 	andne	r8, r5, #16, 6	; 0x40000000
    1120:	67140566 	ldrvs	r0, [r4, -r6, ror #10]
    1124:	052e0e05 	streq	r0, [lr, #-3589]!	; 0xfffff1fb
    1128:	12058310 	andne	r8, r5, #16, 6	; 0x40000000
    112c:	670e0566 	strvs	r0, [lr, -r6, ror #10]
    1130:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
    1134:	05820104 	streq	r0, [r2, #260]	; 0x104
    1138:	12056710 	andne	r6, r5, #16, 14	; 0x400000
    113c:	681c0566 	ldmdavs	ip, {r1, r2, r5, r6, r8, sl}
    1140:	05822205 	streq	r2, [r2, #517]	; 0x205
    1144:	22052e10 	andcs	r2, r5, #16, 28	; 0x100
    1148:	4a120566 	bmi	4826e8 <__bss_end+0x4767e0>
    114c:	052f1405 	streq	r1, [pc, #-1029]!	; d4f <shift+0xd4f>
    1150:	04020005 	streq	r0, [r2], #-5
    1154:	d6770302 	ldrbtle	r0, [r7], -r2, lsl #6
    1158:	0c030105 	stfeqs	f0, [r3], {5}
    115c:	a21b059e 	andsge	r0, fp, #662700032	; 0x27800000
    1160:	05830b05 	streq	r0, [r3, #2821]	; 0xb05
    1164:	13054b09 	movwne	r4, #23305	; 0x5b09
    1168:	6611054c 	ldrvs	r0, [r1], -ip, asr #10
    116c:	052e0f05 	streq	r0, [lr, #-3845]!	; 0xfffff0fb
    1170:	02002e1f 	andeq	r2, r0, #496	; 0x1f0
    1174:	66060104 	strvs	r0, [r6], -r4, lsl #2
    1178:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
    117c:	66060304 	strvs	r0, [r6], -r4, lsl #6
    1180:	02001f05 	andeq	r1, r0, #5, 30
    1184:	00660504 	rsbeq	r0, r6, r4, lsl #10
    1188:	06060402 	streq	r0, [r6], -r2, lsl #8
    118c:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
    1190:	0f052e08 	svceq	0x00052e08
    1194:	1b054b06 	blne	153db4 <__bss_end+0x147eac>
    1198:	4a160582 	bmi	5827a8 <__bss_end+0x5768a0>
    119c:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
    11a0:	05314905 	ldreq	r4, [r1, #-2309]!	; 0xfffff6fb
    11a4:	15056717 	strne	r6, [r5, #-1815]	; 0xfffff8e9
    11a8:	2e130566 	cfmsc32cs	mvfx0, mvfx3, mvfx6
    11ac:	002e2305 	eoreq	r2, lr, r5, lsl #6
    11b0:	06010402 	streq	r0, [r1], -r2, lsl #8
    11b4:	00260566 	eoreq	r0, r6, r6, ror #10
    11b8:	06030402 	streq	r0, [r3], -r2, lsl #8
    11bc:	00230566 	eoreq	r0, r3, r6, ror #10
    11c0:	66050402 	strvs	r0, [r5], -r2, lsl #8
    11c4:	06040200 	streq	r0, [r4], -r0, lsl #4
    11c8:	02004a06 	andeq	r4, r0, #24576	; 0x6000
    11cc:	052e0804 	streq	r0, [lr, #-2052]!	; 0xfffff7fc
    11d0:	054b0613 	strbeq	r0, [fp, #-1555]	; 0xfffff9ed
    11d4:	1a05821f 	bne	161a58 <__bss_end+0x155b50>
    11d8:	660f054a 	strvs	r0, [pc], -sl, asr #10
    11dc:	6409054b 	strvs	r0, [r9], #-1355	; 0xfffffab5
    11e0:	05330505 	ldreq	r0, [r3, #-1285]!	; 0xfffffafb
    11e4:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
    11e8:	0d056601 	stceq	6, cr6, [r5, #-4]
    11ec:	0f054b67 	svceq	0x00054b67
    11f0:	660d054b 	strvs	r0, [sp], -fp, asr #10
    11f4:	052e0b05 	streq	r0, [lr, #-2821]!	; 0xfffff4fb
    11f8:	13052f09 	movwne	r2, #24329	; 0x5f09
    11fc:	66110567 	ldrvs	r0, [r1], -r7, ror #10
    1200:	052e0f05 	streq	r0, [lr, #-3845]!	; 0xfffff0fb
    1204:	13054b0e 	movwne	r4, #23310	; 0x5b0e
    1208:	66110567 	ldrvs	r0, [r1], -r7, ror #10
    120c:	052e0f05 	streq	r0, [lr, #-3845]!	; 0xfffff0fb
    1210:	10052f12 	andne	r2, r5, r2, lsl pc
    1214:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
    1218:	05660601 	strbeq	r0, [r6, #-1537]!	; 0xfffff9ff
    121c:	05670613 	strbeq	r0, [r7, #-1555]!	; 0xfffff9ed
    1220:	0f05ba1d 	svceq	0x0005ba1d
    1224:	4b13054a 	blmi	4c2754 <__bss_end+0x4b684c>
    1228:	05661105 	strbeq	r1, [r6, #-261]!	; 0xfffffefb
    122c:	09052e0f 	stmdbeq	r5, {r0, r1, r2, r3, r9, sl, fp, sp}
    1230:	3210052c 	andscc	r0, r0, #44, 10	; 0xb000000
    1234:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
    1238:	0b05680e 	bleq	15b278 <__bss_end+0x14f370>
    123c:	830a0567 	movwhi	r0, #42343	; 0xa567
    1240:	05640505 	strbeq	r0, [r4, #-1285]!	; 0xfffffafb
    1244:	0b05320e 	bleq	14da84 <__bss_end+0x141b7c>
    1248:	bb0a0567 	bllt	2827ec <__bss_end+0x2768e4>
    124c:	05640505 	strbeq	r0, [r4, #-1285]!	; 0xfffffafb
    1250:	0105320c 	tsteq	r5, ip, lsl #4
    1254:	0840054b 	stmdaeq	r0, {r0, r1, r3, r6, r8, sl}^
    1258:	bb090522 	bllt	2426e8 <__bss_end+0x2367e0>
    125c:	054c1205 	strbeq	r1, [ip, #-517]	; 0xfffffdfb
    1260:	11056727 	tstne	r5, r7, lsr #14
    1264:	662d05ba 			; <UNDEFINED> instruction: 0x662d05ba
    1268:	054a1305 	strbeq	r1, [sl, #-773]	; 0xfffffcfb
    126c:	0a052f0f 	beq	14ceb0 <__bss_end+0x140fa8>
    1270:	6305059f 	movwvs	r0, #21919	; 0x559f
    1274:	67110534 			; <UNDEFINED> instruction: 0x67110534
    1278:	05662205 	strbeq	r2, [r6, #-517]!	; 0xfffffdfb
    127c:	0a052e13 	beq	14cad0 <__bss_end+0x140bc8>
    1280:	690d052f 	stmdbvs	sp, {r0, r1, r2, r3, r5, r8, sl}
    1284:	05660f05 	strbeq	r0, [r6, #-3845]!	; 0xfffff0fb
    1288:	0e054b06 	vmlaeq.f64	d4, d5, d6
    128c:	001c0568 	andseq	r0, ip, r8, ror #10
    1290:	4a030402 	bmi	c22a0 <__bss_end+0xb6398>
    1294:	02001705 	andeq	r1, r0, #1310720	; 0x140000
    1298:	059e0304 	ldreq	r0, [lr, #772]	; 0x304
    129c:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
    12a0:	1e056702 	cdpne	7, 0, cr6, cr5, cr2, {0}
    12a4:	02040200 	andeq	r0, r4, #0, 4
    12a8:	000e0582 	andeq	r0, lr, r2, lsl #11
    12ac:	4a020402 	bmi	822bc <__bss_end+0x763b4>
    12b0:	02002105 	andeq	r2, r0, #1073741825	; 0x40000001
    12b4:	054b0204 	strbeq	r0, [fp, #-516]	; 0xfffffdfc
    12b8:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
    12bc:	15056602 	strne	r6, [r5, #-1538]	; 0xfffff9fe
    12c0:	02040200 	andeq	r0, r4, #0, 4
    12c4:	00210582 	eoreq	r0, r1, r2, lsl #11
    12c8:	4a020402 	bmi	822d8 <__bss_end+0x763d0>
    12cc:	02001705 	andeq	r1, r0, #1310720	; 0x140000
    12d0:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
    12d4:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
    12d8:	13052f02 	movwne	r2, #24322	; 0x5f02
    12dc:	02040200 	andeq	r0, r4, #0, 4
    12e0:	00050566 	andeq	r0, r5, r6, ror #10
    12e4:	47020402 	strmi	r0, [r2, -r2, lsl #8]
    12e8:	05870105 	streq	r0, [r7, #261]	; 0x105
    12ec:	0905841d 	stmdbeq	r5, {r0, r2, r3, r4, sl, pc}
    12f0:	4c0c0583 	cfstr32mi	mvfx0, [ip], {131}	; 0x83
    12f4:	054a1305 	strbeq	r1, [sl, #-773]	; 0xfffffcfb
    12f8:	0d054b10 	vstreq	d4, [r5, #-64]	; 0xffffffc0
    12fc:	4a0905bb 	bmi	2429f0 <__bss_end+0x236ae8>
    1300:	02001d05 	andeq	r1, r0, #320	; 0x140
    1304:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
    1308:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
    130c:	13054a01 	movwne	r4, #23041	; 0x5a01
    1310:	4a1a054d 	bmi	68284c <__bss_end+0x676944>
    1314:	052e1005 	streq	r1, [lr, #-5]!
    1318:	0505680e 	streq	r6, [r5, #-2062]	; 0xfffff7f2
    131c:	05667903 	strbeq	r7, [r6, #-2307]!	; 0xfffff6fd
    1320:	2e0a030c 	cdpcs	3, 0, cr0, cr10, cr12, {0}
    1324:	052f0105 	streq	r0, [pc, #-261]!	; 1227 <shift+0x1227>
    1328:	0c058435 	cfstrseq	mvf8, [r5], {53}	; 0x35
    132c:	001905bd 			; <UNDEFINED> instruction: 0x001905bd
    1330:	4a040402 	bmi	102340 <__bss_end+0xf6438>
    1334:	02002105 	andeq	r2, r0, #1073741825	; 0x40000001
    1338:	05820204 	streq	r0, [r2, #516]	; 0x204
    133c:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
    1340:	18058202 	stmdane	r5, {r1, r9, pc}
    1344:	03040200 	movweq	r0, #16896	; 0x4200
    1348:	000f054b 	andeq	r0, pc, fp, asr #10
    134c:	66030402 	strvs	r0, [r3], -r2, lsl #8
    1350:	02001805 	andeq	r1, r0, #327680	; 0x50000
    1354:	05660304 	strbeq	r0, [r6, #-772]!	; 0xfffffcfc
    1358:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
    135c:	05052e03 	streq	r2, [r5, #-3587]	; 0xfffff1fd
    1360:	03040200 	movweq	r0, #16896	; 0x4200
    1364:	000e052d 	andeq	r0, lr, sp, lsr #10
    1368:	84020402 	strhi	r0, [r2], #-1026	; 0xfffffbfe
    136c:	02000f05 	andeq	r0, r0, #5, 30
    1370:	05830104 	streq	r0, [r3, #260]	; 0x104
    1374:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
    1378:	05056601 	streq	r6, [r5, #-1537]	; 0xfffff9ff
    137c:	01040200 	mrseq	r0, R12_usr
    1380:	850c0549 	strhi	r0, [ip, #-1353]	; 0xfffffab7
    1384:	052f0105 	streq	r0, [pc, #-261]!	; 1287 <shift+0x1287>
    1388:	0f058436 	svceq	0x00058436
    138c:	661205bc 			; <UNDEFINED> instruction: 0x661205bc
    1390:	05bb2105 	ldreq	r2, [fp, #261]!	; 0x105
    1394:	2105660c 	tstcs	r5, ip, lsl #12
    1398:	660c054b 	strvs	r0, [ip], -fp, asr #10
    139c:	054b0905 	strbeq	r0, [fp, #-2309]	; 0xfffff6fb
    13a0:	19058317 	stmdbne	r5, {r0, r1, r2, r4, r8, r9, pc}
    13a4:	4b09054a 	blmi	2428d4 <__bss_end+0x2369cc>
    13a8:	05671405 	strbeq	r1, [r7, #-1029]!	; 0xfffffbfb
    13ac:	01054d0c 	tsteq	r5, ip, lsl #26
    13b0:	841b052f 	ldrhi	r0, [fp], #-1327	; 0xfffffad1
    13b4:	05830905 	streq	r0, [r3, #2309]	; 0x905
    13b8:	11054c0f 	tstne	r5, pc, lsl #24
    13bc:	4b0a0582 	blmi	2829cc <__bss_end+0x276ac4>
    13c0:	05650505 	strbeq	r0, [r5, #-1285]!	; 0xfffffafb
    13c4:	0105310c 	tsteq	r5, ip, lsl #2
    13c8:	8437052f 	ldrthi	r0, [r7], #-1327	; 0xfffffad1
    13cc:	05bb0905 	ldreq	r0, [fp, #2309]!	; 0x905
    13d0:	16054c14 			; <UNDEFINED> instruction: 0x16054c14
    13d4:	4b150582 	blmi	5429e4 <__bss_end+0x536adc>
    13d8:	05820905 	streq	r0, [r2, #2309]	; 0x905
    13dc:	0a056714 	beq	15b034 <__bss_end+0x14f12c>
    13e0:	6305054b 	movwvs	r0, #21835	; 0x554b
    13e4:	05330c05 	ldreq	r0, [r3, #-3077]!	; 0xfffff3fb
    13e8:	26052f01 	strcs	r2, [r5], -r1, lsl #30
    13ec:	9f0b0584 	svcls	0x000b0584
    13f0:	054c0e05 	strbeq	r0, [ip, #-3589]	; 0xfffff1fb
    13f4:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
    13f8:	0e054a03 	vmlaeq.f32	s8, s10, s6
    13fc:	02040200 	andeq	r0, r4, #0, 4
    1400:	00100583 	andseq	r0, r0, r3, lsl #11
    1404:	66020402 	strvs	r0, [r2], -r2, lsl #8
    1408:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
    140c:	05490204 	strbeq	r0, [r9, #-516]	; 0xfffffdfc
    1410:	32058401 	andcc	r8, r5, #16777216	; 0x1000000
    1414:	bb110584 	bllt	442a2c <__bss_end+0x436b24>
    1418:	054b0b05 	strbeq	r0, [fp, #-2821]	; 0xfffff4fb
    141c:	17054c0e 	strne	r4, [r5, -lr, lsl #24]
    1420:	03040200 	movweq	r0, #16896	; 0x4200
    1424:	001d054a 	andseq	r0, sp, sl, asr #10
    1428:	83020402 	movwhi	r0, #9218	; 0x2402
    142c:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
    1430:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
    1434:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
    1438:	13056602 	movwne	r6, #22018	; 0x5602
    143c:	02040200 	andeq	r0, r4, #0, 4
    1440:	0005052e 	andeq	r0, r5, lr, lsr #10
    1444:	2d020402 	cfstrscs	mvf0, [r2, #-8]
    1448:	05840105 	streq	r0, [r4, #261]	; 0x105
    144c:	009f8417 	addseq	r8, pc, r7, lsl r4	; <UNPREDICTABLE>
    1450:	06010402 	streq	r0, [r1], -r2, lsl #8
    1454:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
    1458:	02006603 	andeq	r6, r0, #3145728	; 0x300000
    145c:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
    1460:	04020001 	streq	r0, [r2], #-1
    1464:	052f0606 	streq	r0, [pc, #-1542]!	; e66 <shift+0xe66>
    1468:	0a058422 	beq	1624f8 <__bss_end+0x1565f0>
    146c:	67050583 	strvs	r0, [r5, -r3, lsl #11]
    1470:	02001b05 	andeq	r1, r0, #5120	; 0x1400
    1474:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
    1478:	12054c09 	andne	r4, r5, #2304	; 0x900
    147c:	8209054c 	andhi	r0, r9, #76, 10	; 0x13000000
    1480:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
    1484:	16054b09 	strne	r4, [r5], -r9, lsl #22
    1488:	01040200 	mrseq	r0, R12_usr
    148c:	67140566 	ldrvs	r0, [r4, -r6, ror #10]
    1490:	054d0d05 	strbeq	r0, [sp, #-3333]	; 0xfffff2fb
    1494:	11056909 	tstne	r5, r9, lsl #18
    1498:	8213054b 	andshi	r0, r3, #314572800	; 0x12c00000
    149c:	054b1c05 	strbeq	r1, [fp, #-3077]	; 0xfffff3fb
    14a0:	0d056616 	stceq	6, cr6, [r5, #-88]	; 0xffffffa8
    14a4:	4a090582 	bmi	242ab4 <__bss_end+0x236bac>
    14a8:	054b1405 	strbeq	r1, [fp, #-1029]	; 0xfffffbfb
    14ac:	0a054c0d 	beq	1544e8 <__bss_end+0x1485e0>
    14b0:	61050567 	tstvs	r5, r7, ror #10
    14b4:	67100536 			; <UNDEFINED> instruction: 0x67100536
    14b8:	054d0c05 	strbeq	r0, [sp, #-3077]	; 0xfffff3fb
    14bc:	20052f01 	andcs	r2, r5, r1, lsl #30
    14c0:	830a0568 	movwhi	r0, #42344	; 0xa568
    14c4:	4b090567 	blmi	242a68 <__bss_end+0x236b60>
    14c8:	4c05054b 	cfstr32mi	mvfx0, [r5], {75}	; 0x4b
    14cc:	02001b05 	andeq	r1, r0, #5120	; 0x1400
    14d0:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
    14d4:	12054c1e 	andne	r4, r5, #7680	; 0x1e00
    14d8:	01040200 	mrseq	r0, R12_usr
    14dc:	002a0566 	eoreq	r0, sl, r6, ror #10
    14e0:	66030402 	strvs	r0, [r3], -r2, lsl #8
    14e4:	02002105 	andeq	r2, r0, #1073741825	; 0x40000001
    14e8:	05820304 	streq	r0, [r2, #772]	; 0x304
    14ec:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
    14f0:	02004a03 	andeq	r4, r0, #12288	; 0x3000
    14f4:	4a060504 	bmi	18290c <__bss_end+0x176a04>
    14f8:	06040200 	streq	r0, [r4], -r0, lsl #4
    14fc:	0005054a 	andeq	r0, r5, sl, asr #10
    1500:	06080402 	streq	r0, [r8], -r2, lsl #8
    1504:	0036052e 	eorseq	r0, r6, lr, lsr #10
    1508:	4a090402 	bmi	242518 <__bss_end+0x236610>
    150c:	054c1105 	strbeq	r1, [ip, #-261]	; 0xfffffefb
    1510:	15058205 	strne	r8, [r5, #-517]	; 0xfffffdfb
    1514:	6909054b 	stmdbvs	r9, {r0, r1, r3, r6, r8, sl}
    1518:	054b1105 	strbeq	r1, [fp, #-261]	; 0xfffffefb
    151c:	1c058213 	sfmne	f0, 1, [r5], {19}
    1520:	6616054b 	ldrvs	r0, [r6], -fp, asr #10
    1524:	05820d05 	streq	r0, [r2, #3333]	; 0xd05
    1528:	16054a09 	strne	r4, [r5], -r9, lsl #20
    152c:	820d054b 	andhi	r0, sp, #314572800	; 0x12c00000
    1530:	02002805 	andeq	r2, r0, #327680	; 0x50000
    1534:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
    1538:	0402001f 	streq	r0, [r2], #-31	; 0xffffffe1
    153c:	17056601 	strne	r6, [r5, -r1, lsl #12]
    1540:	6818054b 	ldmdavs	r8, {r0, r1, r3, r6, r8, sl}
    1544:	054d0d05 	strbeq	r0, [sp, #-3333]	; 0xfffff2fb
    1548:	1d05671c 	stcne	7, cr6, [r5, #-112]	; 0xffffff90
    154c:	690a0584 	stmdbvs	sl, {r2, r7, r8, sl}
    1550:	72030505 	andvc	r0, r3, #20971520	; 0x1400000
    1554:	2e110366 	cdpcs	3, 1, cr0, cr1, cr6, {3}
    1558:	05671005 	strbeq	r1, [r7, #-5]!
    155c:	17054d05 	strne	r4, [r5, -r5, lsl #26]
    1560:	01040200 	mrseq	r0, R12_usr
    1564:	67100566 	ldrvs	r0, [r0, -r6, ror #10]
    1568:	054d0c05 	strbeq	r0, [sp, #-3077]	; 0xfffff3fb
    156c:	06022f01 	streq	r2, [r2], -r1, lsl #30
    1570:	79010100 	stmdbvc	r1, {r8}
    1574:	03000000 	movweq	r0, #0
    1578:	00004600 	andeq	r4, r0, r0, lsl #12
    157c:	fb010200 	blx	41d86 <__bss_end+0x35e7e>
    1580:	01000d0e 	tsteq	r0, lr, lsl #26
    1584:	00010101 	andeq	r0, r1, r1, lsl #2
    1588:	00010000 	andeq	r0, r1, r0
    158c:	2e2e0100 	sufcse	f0, f6, f0
    1590:	2f2e2e2f 	svccs	0x002e2e2f
    1594:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1598:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    159c:	2f2e2e2f 	svccs	0x002e2e2f
    15a0:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    15a4:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    15a8:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    15ac:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    15b0:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
    15b4:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
    15b8:	73636e75 	cmnvc	r3, #1872	; 0x750
    15bc:	0100532e 	tsteq	r0, lr, lsr #6
    15c0:	00000000 	andeq	r0, r0, r0
    15c4:	b1fc0205 	mvnslt	r0, r5, lsl #4
    15c8:	fd030000 	stc2	0, cr0, [r3, #-0]
    15cc:	2f300108 	svccs	0x00300108
    15d0:	2f2f2f2f 	svccs	0x002f2f2f
    15d4:	01d00230 	bicseq	r0, r0, r0, lsr r2
    15d8:	2f312f14 	svccs	0x00312f14
    15dc:	2f4c302f 	svccs	0x004c302f
    15e0:	661f0332 			; <UNDEFINED> instruction: 0x661f0332
    15e4:	2f2f2f2f 	svccs	0x002f2f2f
    15e8:	022f2f2f 	eoreq	r2, pc, #47, 30	; 0xbc
    15ec:	01010002 	tsteq	r1, r2
    15f0:	00000085 	andeq	r0, r0, r5, lsl #1
    15f4:	00460003 	subeq	r0, r6, r3
    15f8:	01020000 	mrseq	r0, (UNDEF: 2)
    15fc:	000d0efb 	strdeq	r0, [sp], -fp
    1600:	01010101 	tsteq	r1, r1, lsl #2
    1604:	01000000 	mrseq	r0, (UNDEF: 0)
    1608:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
    160c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1610:	2f2e2e2f 	svccs	0x002e2e2f
    1614:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1618:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    161c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1620:	2f636367 	svccs	0x00636367
    1624:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    1628:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    162c:	00006d72 	andeq	r6, r0, r2, ror sp
    1630:	3162696c 	cmncc	r2, ip, ror #18
    1634:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    1638:	00532e73 	subseq	r2, r3, r3, ror lr
    163c:	00000001 	andeq	r0, r0, r1
    1640:	08020500 	stmdaeq	r2, {r8, sl}
    1644:	030000b4 	movweq	r0, #180	; 0xb4
    1648:	2f010abe 	svccs	0x00010abe
    164c:	2f2f3030 	svccs	0x002f3030
    1650:	2f2f302f 	svccs	0x002f302f
    1654:	02302f2f 	eorseq	r2, r0, #47, 30	; 0xbc
    1658:	301401d0 			; <UNDEFINED> instruction: 0x301401d0
    165c:	2f30302f 	svccs	0x0030302f
    1660:	2f2f3031 	svccs	0x002f3031
    1664:	302f4c30 	eorcc	r4, pc, r0, lsr ip	; <UNPREDICTABLE>
    1668:	1f03322f 	svcne	0x0003322f
    166c:	2f2f2f82 	svccs	0x002f2f82
    1670:	2f2f2f2f 	svccs	0x002f2f2f
    1674:	01000202 	tsteq	r0, r2, lsl #4
    1678:	00005c01 	andeq	r5, r0, r1, lsl #24
    167c:	46000300 	strmi	r0, [r0], -r0, lsl #6
    1680:	02000000 	andeq	r0, r0, #0
    1684:	0d0efb01 	vstreq	d15, [lr, #-4]
    1688:	01010100 	mrseq	r0, (UNDEF: 17)
    168c:	00000001 	andeq	r0, r0, r1
    1690:	01000001 	tsteq	r0, r1
    1694:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1698:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    169c:	2f2e2e2f 	svccs	0x002e2e2f
    16a0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    16a4:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    16a8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    16ac:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    16b0:	2f676966 	svccs	0x00676966
    16b4:	006d7261 	rsbeq	r7, sp, r1, ror #4
    16b8:	62696c00 	rsbvs	r6, r9, #0, 24
    16bc:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
    16c0:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
    16c4:	00000100 	andeq	r0, r0, r0, lsl #2
    16c8:	02050000 	andeq	r0, r5, #0
    16cc:	0000b648 	andeq	fp, r0, r8, asr #12
    16d0:	010be703 	tsteq	fp, r3, lsl #14
    16d4:	01000202 	tsteq	r0, r2, lsl #4
    16d8:	0000fb01 	andeq	pc, r0, r1, lsl #22
    16dc:	47000300 	strmi	r0, [r0, -r0, lsl #6]
    16e0:	02000000 	andeq	r0, r0, #0
    16e4:	0d0efb01 	vstreq	d15, [lr, #-4]
    16e8:	01010100 	mrseq	r0, (UNDEF: 17)
    16ec:	00000001 	andeq	r0, r0, r1
    16f0:	01000001 	tsteq	r0, r1
    16f4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    16f8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    16fc:	2f2e2e2f 	svccs	0x002e2e2f
    1700:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1704:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1708:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    170c:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1710:	2f676966 	svccs	0x00676966
    1714:	006d7261 	rsbeq	r7, sp, r1, ror #4
    1718:	65656900 	strbvs	r6, [r5, #-2304]!	; 0xfffff700
    171c:	34353765 	ldrtcc	r3, [r5], #-1893	; 0xfffff89b
    1720:	2e66732d 	cdpcs	3, 6, cr7, cr6, cr13, {1}
    1724:	00010053 	andeq	r0, r1, r3, asr r0
    1728:	05000000 	streq	r0, [r0, #-0]
    172c:	00b64c02 	adcseq	r4, r6, r2, lsl #24
    1730:	013a0300 	teqeq	sl, r0, lsl #6
    1734:	0903332f 	stmdbeq	r3, {r0, r1, r2, r3, r5, r8, r9, ip, sp}
    1738:	2f2f302e 	svccs	0x002f302e
    173c:	2f322f2f 	svccs	0x00322f2f
    1740:	2f2f2f30 	svccs	0x002f2f30
    1744:	31303330 	teqcc	r0, r0, lsr r3
    1748:	2f302f2f 	svccs	0x00302f2f
    174c:	32302f2f 	eorscc	r2, r0, #47, 30	; 0xbc
    1750:	2f32322f 	svccs	0x0032322f
    1754:	332f312f 			; <UNDEFINED> instruction: 0x332f312f
    1758:	2f2f332f 	svccs	0x002f332f
    175c:	2f2f312f 	svccs	0x002f312f
    1760:	2f352f31 	svccs	0x00352f31
    1764:	322f2f30 	eorcc	r2, pc, #48, 30	; 0xc0
    1768:	2f2f2f2f 	svccs	0x002f2f2f
    176c:	2f2e1903 	svccs	0x002e1903
    1770:	2f352f2f 	svccs	0x00352f2f
    1774:	3330342f 	teqcc	r0, #788529152	; 0x2f000000
    1778:	2f2f302f 	svccs	0x002f302f
    177c:	3030312f 	eorscc	r3, r0, pc, lsr #2
    1780:	312f302f 			; <UNDEFINED> instruction: 0x312f302f
    1784:	32302f30 	eorscc	r2, r0, #48, 30	; 0xc0
    1788:	2f2f312f 	svccs	0x002f312f
    178c:	302f2f30 	eorcc	r2, pc, r0, lsr pc	; <UNPREDICTABLE>
    1790:	2f322f2f 	svccs	0x00322f2f
    1794:	2e09032f 	cdpcs	3, 0, cr0, cr9, cr15, {1}
    1798:	2f2f2f30 	svccs	0x002f2f30
    179c:	2f2f2f30 	svccs	0x002f2f30
    17a0:	2f2e0d03 	svccs	0x002e0d03
    17a4:	30303033 	eorscc	r3, r0, r3, lsr r0
    17a8:	2f303131 	svccs	0x00303131
    17ac:	302e0c03 	eorcc	r0, lr, r3, lsl #24
    17b0:	30332f30 	eorscc	r2, r3, r0, lsr pc
    17b4:	2f332f30 	svccs	0x00332f30
    17b8:	2f2f3031 	svccs	0x002f3031
    17bc:	032f3031 			; <UNDEFINED> instruction: 0x032f3031
    17c0:	322f2e19 	eorcc	r2, pc, #400	; 0x190
    17c4:	2f2f302f 	svccs	0x002f302f
    17c8:	2f302f2f 	svccs	0x00302f2f
    17cc:	2f2f2f30 	svccs	0x002f2f30
    17d0:	022f302f 	eoreq	r3, pc, #47	; 0x2f
    17d4:	01010002 	tsteq	r1, r2
    17d8:	0000007a 	andeq	r0, r0, sl, ror r0
    17dc:	00420003 	subeq	r0, r2, r3
    17e0:	01020000 	mrseq	r0, (UNDEF: 2)
    17e4:	000d0efb 	strdeq	r0, [sp], -fp
    17e8:	01010101 	tsteq	r1, r1, lsl #2
    17ec:	01000000 	mrseq	r0, (UNDEF: 0)
    17f0:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
    17f4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    17f8:	2f2e2e2f 	svccs	0x002e2e2f
    17fc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1800:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1804:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1808:	2f636367 	svccs	0x00636367
    180c:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    1810:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1814:	00006d72 	andeq	r6, r0, r2, ror sp
    1818:	62617062 	rsbvs	r7, r1, #98	; 0x62
    181c:	00532e69 	subseq	r2, r3, r9, ror #28
    1820:	00000001 	andeq	r0, r0, r1
    1824:	9c020500 	cfstr32ls	mvfx0, [r2], {-0}
    1828:	030000b8 	movweq	r0, #184	; 0xb8
    182c:	080101b9 	stmdaeq	r1, {r0, r3, r4, r5, r7, r8}
    1830:	2f2f4b5a 	svccs	0x002f4b5a
    1834:	6730302f 	ldrvs	r3, [r0, -pc, lsr #32]!
    1838:	2f2f2f32 	svccs	0x002f2f32
    183c:	2f673030 	svccs	0x00673030
    1840:	322f2f2f 	eorcc	r2, pc, #47, 30	; 0xbc
    1844:	6730302f 	ldrvs	r3, [r0, -pc, lsr #32]!
    1848:	2f322f2f 	svccs	0x00322f2f
    184c:	2f672f30 	svccs	0x00672f30
    1850:	0002022f 	andeq	r0, r2, pc, lsr #4
    1854:	01030101 	tsteq	r3, r1, lsl #2
    1858:	00030000 	andeq	r0, r3, r0
    185c:	000000fd 	strdeq	r0, [r0], -sp
    1860:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    1864:	0101000d 	tsteq	r1, sp
    1868:	00000101 	andeq	r0, r0, r1, lsl #2
    186c:	00000100 	andeq	r0, r0, r0, lsl #2
    1870:	2f2e2e01 	svccs	0x002e2e01
    1874:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1878:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    187c:	2f2e2e2f 	svccs	0x002e2e2f
    1880:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 17d0 <shift+0x17d0>
    1884:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1888:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
    188c:	636e692f 	cmnvs	lr, #770048	; 0xbc000
    1890:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
    1894:	2f2e2e00 	svccs	0x002e2e00
    1898:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    189c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    18a0:	2f2e2e2f 	svccs	0x002e2e2f
    18a4:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
    18a8:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
    18ac:	2f2e2e2f 	svccs	0x002e2e2f
    18b0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    18b4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    18b8:	2f2e2e2f 	svccs	0x002e2e2f
    18bc:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    18c0:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
    18c4:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
    18c8:	6f632f63 	svcvs	0x00632f63
    18cc:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    18d0:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    18d4:	2f2e2e00 	svccs	0x002e2e00
    18d8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    18dc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    18e0:	2f2e2e2f 	svccs	0x002e2e2f
    18e4:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1834 <shift+0x1834>
    18e8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    18ec:	68000063 	stmdavs	r0, {r0, r1, r5, r6}
    18f0:	74687361 	strbtvc	r7, [r8], #-865	; 0xfffffc9f
    18f4:	682e6261 	stmdavs	lr!, {r0, r5, r6, r9, sp, lr}
    18f8:	00000100 	andeq	r0, r0, r0, lsl #2
    18fc:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1900:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
    1904:	00020068 	andeq	r0, r2, r8, rrx
    1908:	6d726100 	ldfvse	f6, [r2, #-0]
    190c:	7570632d 	ldrbvc	r6, [r0, #-813]!	; 0xfffffcd3
    1910:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    1914:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
    1918:	632d6e73 			; <UNDEFINED> instruction: 0x632d6e73
    191c:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
    1920:	73746e61 	cmnvc	r4, #1552	; 0x610
    1924:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    1928:	72610000 	rsbvc	r0, r1, #0
    192c:	00682e6d 	rsbeq	r2, r8, sp, ror #28
    1930:	6c000003 	stcvs	0, cr0, [r0], {3}
    1934:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1938:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
    193c:	00000400 	andeq	r0, r0, r0, lsl #8
    1940:	2d6c6267 	sfmcs	f6, 2, [ip, #-412]!	; 0xfffffe64
    1944:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    1948:	00682e73 	rsbeq	r2, r8, r3, ror lr
    194c:	6c000004 	stcvs	0, cr0, [r0], {4}
    1950:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1954:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    1958:	00000400 	andeq	r0, r0, r0, lsl #8
    195c:	00012a00 	andeq	r2, r1, r0, lsl #20
    1960:	ee000300 	cdp	3, 0, cr0, cr0, cr0, {0}
    1964:	02000000 	andeq	r0, r0, #0
    1968:	0d0efb01 	vstreq	d15, [lr, #-4]
    196c:	01010100 	mrseq	r0, (UNDEF: 17)
    1970:	00000001 	andeq	r0, r0, r1
    1974:	01000001 	tsteq	r0, r1
    1978:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    197c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1980:	2f2e2e2f 	svccs	0x002e2e2f
    1984:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1988:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    198c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1990:	2f2e2e00 	svccs	0x002e2e00
    1994:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1998:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    199c:	2f2e2e2f 	svccs	0x002e2e2f
    19a0:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 18f0 <shift+0x18f0>
    19a4:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    19a8:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
    19ac:	636e692f 	cmnvs	lr, #770048	; 0xbc000
    19b0:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
    19b4:	2f2e2e00 	svccs	0x002e2e00
    19b8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    19bc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    19c0:	2f2e2e2f 	svccs	0x002e2e2f
    19c4:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
    19c8:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
    19cc:	2f2e2e2f 	svccs	0x002e2e2f
    19d0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    19d4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    19d8:	2f2e2e2f 	svccs	0x002e2e2f
    19dc:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    19e0:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
    19e4:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
    19e8:	6f632f63 	svcvs	0x00632f63
    19ec:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    19f0:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    19f4:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
    19f8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    19fc:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    1a00:	68000001 	stmdavs	r0, {r0}
    1a04:	74687361 	strbtvc	r7, [r8], #-865	; 0xfffffc9f
    1a08:	682e6261 	stmdavs	lr!, {r0, r5, r6, r9, sp, lr}
    1a0c:	00000200 	andeq	r0, r0, r0, lsl #4
    1a10:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1a14:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
    1a18:	00030068 	andeq	r0, r3, r8, rrx
    1a1c:	6d726100 	ldfvse	f6, [r2, #-0]
    1a20:	7570632d 	ldrbvc	r6, [r0, #-813]!	; 0xfffffcd3
    1a24:	0300682e 	movweq	r6, #2094	; 0x82e
    1a28:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
    1a2c:	632d6e73 			; <UNDEFINED> instruction: 0x632d6e73
    1a30:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
    1a34:	73746e61 	cmnvc	r4, #1552	; 0x610
    1a38:	0300682e 	movweq	r6, #2094	; 0x82e
    1a3c:	72610000 	rsbvc	r0, r1, #0
    1a40:	00682e6d 	rsbeq	r2, r8, sp, ror #28
    1a44:	6c000004 	stcvs	0, cr0, [r0], {4}
    1a48:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1a4c:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
    1a50:	00000100 	andeq	r0, r0, r0, lsl #2
    1a54:	00010500 	andeq	r0, r1, r0, lsl #10
    1a58:	b9700205 	ldmdblt	r0!, {r0, r2, r9}^
    1a5c:	f9030000 			; <UNDEFINED> instruction: 0xf9030000
    1a60:	0305010b 	movweq	r0, #20747	; 0x510b
    1a64:	06010513 			; <UNDEFINED> instruction: 0x06010513
    1a68:	2f060511 	svccs	0x00060511
    1a6c:	68060305 	stmdavs	r6, {r0, r2, r8, r9}
    1a70:	01060a05 	tsteq	r6, r5, lsl #20
    1a74:	2d060505 	cfstr32cs	mvfx0, [r6, #-20]	; 0xffffffec
    1a78:	10060105 	andne	r0, r6, r5, lsl #2
    1a7c:	2e300e05 	cdpcs	14, 3, cr0, cr0, cr5, {0}
    1a80:	052e0c05 	streq	r0, [lr, #-3077]!	; 0xfffff3fb
    1a84:	02024c01 	andeq	r4, r2, #256	; 0x100
    1a88:	3b010100 	blcc	41e90 <__bss_end+0x35f88>
    1a8c:	03000001 	movweq	r0, #1
    1a90:	0000ee00 	andeq	lr, r0, r0, lsl #28
    1a94:	fb010200 	blx	4229e <__bss_end+0x36396>
    1a98:	01000d0e 	tsteq	r0, lr, lsl #26
    1a9c:	00010101 	andeq	r0, r1, r1, lsl #2
    1aa0:	00010000 	andeq	r0, r1, r0
    1aa4:	2e2e0100 	sufcse	f0, f6, f0
    1aa8:	2f2e2e2f 	svccs	0x002e2e2f
    1aac:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1ab0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1ab4:	2f2e2e2f 	svccs	0x002e2e2f
    1ab8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1abc:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
    1ac0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1ac4:	2f2e2e2f 	svccs	0x002e2e2f
    1ac8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1acc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1ad0:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1ad4:	2f636367 	svccs	0x00636367
    1ad8:	692f2e2e 	stmdbvs	pc!, {r1, r2, r3, r5, r9, sl, fp, sp}	; <UNPREDICTABLE>
    1adc:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    1ae0:	2e006564 	cfsh32cs	mvfx6, mvfx0, #52
    1ae4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1ae8:	2f2e2e2f 	svccs	0x002e2e2f
    1aec:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1af0:	2f2e2f2e 	svccs	0x002e2f2e
    1af4:	00636367 	rsbeq	r6, r3, r7, ror #6
    1af8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1afc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1b00:	2f2e2e2f 	svccs	0x002e2e2f
    1b04:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1b08:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1b0c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1b10:	2f2e2e2f 	svccs	0x002e2e2f
    1b14:	2f636367 	svccs	0x00636367
    1b18:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    1b1c:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1b20:	00006d72 	andeq	r6, r0, r2, ror sp
    1b24:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1b28:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    1b2c:	00010063 	andeq	r0, r1, r3, rrx
    1b30:	73616800 	cmnvc	r1, #0, 16
    1b34:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    1b38:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    1b3c:	72610000 	rsbvc	r0, r1, #0
    1b40:	73692d6d 	cmnvc	r9, #6976	; 0x1b40
    1b44:	00682e61 	rsbeq	r2, r8, r1, ror #28
    1b48:	61000003 	tstvs	r0, r3
    1b4c:	632d6d72 			; <UNDEFINED> instruction: 0x632d6d72
    1b50:	682e7570 	stmdavs	lr!, {r4, r5, r6, r8, sl, ip, sp, lr}
    1b54:	00000300 	andeq	r0, r0, r0, lsl #6
    1b58:	6e736e69 	cdpvs	14, 7, cr6, cr3, cr9, {3}
    1b5c:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
    1b60:	6e617473 	mcrvs	4, 3, r7, cr1, cr3, {3}
    1b64:	682e7374 	stmdavs	lr!, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
    1b68:	00000300 	andeq	r0, r0, r0, lsl #6
    1b6c:	2e6d7261 	cdpcs	2, 6, cr7, cr13, cr1, {3}
    1b70:	00040068 	andeq	r0, r4, r8, rrx
    1b74:	62696c00 	rsbvs	r6, r9, #0, 24
    1b78:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
    1b7c:	0100682e 	tsteq	r0, lr, lsr #16
    1b80:	05000000 	streq	r0, [r0, #-0]
    1b84:	02050001 	andeq	r0, r5, #1
    1b88:	0000b9a0 	andeq	fp, r0, r0, lsr #19
    1b8c:	010bb903 	tsteq	fp, r3, lsl #18
    1b90:	05170305 	ldreq	r0, [r7, #-773]	; 0xfffffcfb
    1b94:	05010610 	streq	r0, [r1, #-1552]	; 0xfffff9f0
    1b98:	2e0a0327 	cdpcs	3, 0, cr0, cr10, cr7, {1}
    1b9c:	76031005 	strvc	r1, [r3], -r5
    1ba0:	0603052e 	streq	r0, [r3], -lr, lsr #10
    1ba4:	06190533 			; <UNDEFINED> instruction: 0x06190533
    1ba8:	4a100501 	bmi	402fb4 <__bss_end+0x3f70ac>
    1bac:	33060305 	movwcc	r0, #25349	; 0x6305
    1bb0:	061b0515 			; <UNDEFINED> instruction: 0x061b0515
    1bb4:	0301050f 	movweq	r0, #5391	; 0x150f
    1bb8:	19052e2b 	stmdbne	r5, {r0, r1, r3, r5, r9, sl, fp, sp}
    1bbc:	052e5503 	streq	r5, [lr, #-1283]!	; 0xfffffafd
    1bc0:	2e2b0301 	cdpcs	3, 2, cr0, cr11, cr1, {0}
    1bc4:	000a024a 	andeq	r0, sl, sl, asr #4
    1bc8:	01f60101 	mvnseq	r0, r1, lsl #2
    1bcc:	00030000 	andeq	r0, r3, r0
    1bd0:	000000ee 	andeq	r0, r0, lr, ror #1
    1bd4:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    1bd8:	0101000d 	tsteq	r1, sp
    1bdc:	00000101 	andeq	r0, r0, r1, lsl #2
    1be0:	00000100 	andeq	r0, r0, r0, lsl #2
    1be4:	2f2e2e01 	svccs	0x002e2e01
    1be8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1bec:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1bf0:	2f2e2e2f 	svccs	0x002e2e2f
    1bf4:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1b44 <shift+0x1b44>
    1bf8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1bfc:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
    1c00:	2f2e2e2f 	svccs	0x002e2e2f
    1c04:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c08:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1c0c:	2f2e2e2f 	svccs	0x002e2e2f
    1c10:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1c14:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
    1c18:	6e692f2e 	cdpvs	15, 6, cr2, cr9, cr14, {1}
    1c1c:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    1c20:	2e2e0065 	cdpcs	0, 2, cr0, cr14, cr5, {3}
    1c24:	2f2e2e2f 	svccs	0x002e2e2f
    1c28:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c2c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1c30:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
    1c34:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
    1c38:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1c3c:	2f2e2e2f 	svccs	0x002e2e2f
    1c40:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c44:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1c48:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1c4c:	2f636367 	svccs	0x00636367
    1c50:	672f2e2e 	strvs	r2, [pc, -lr, lsr #28]!
    1c54:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    1c58:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    1c5c:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    1c60:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
    1c64:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1c68:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    1c6c:	00000100 	andeq	r0, r0, r0, lsl #2
    1c70:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    1c74:	2e626174 	mcrcs	1, 3, r6, cr2, cr4, {3}
    1c78:	00020068 	andeq	r0, r2, r8, rrx
    1c7c:	6d726100 	ldfvse	f6, [r2, #-0]
    1c80:	6173692d 	cmnvs	r3, sp, lsr #18
    1c84:	0300682e 	movweq	r6, #2094	; 0x82e
    1c88:	72610000 	rsbvc	r0, r1, #0
    1c8c:	70632d6d 	rsbvc	r2, r3, sp, ror #26
    1c90:	00682e75 	rsbeq	r2, r8, r5, ror lr
    1c94:	69000003 	stmdbvs	r0, {r0, r1}
    1c98:	2d6e736e 	stclcs	3, cr7, [lr, #-440]!	; 0xfffffe48
    1c9c:	736e6f63 	cmnvc	lr, #396	; 0x18c
    1ca0:	746e6174 	strbtvc	r6, [lr], #-372	; 0xfffffe8c
    1ca4:	00682e73 	rsbeq	r2, r8, r3, ror lr
    1ca8:	61000003 	tstvs	r0, r3
    1cac:	682e6d72 	stmdavs	lr!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}
    1cb0:	00000400 	andeq	r0, r0, r0, lsl #8
    1cb4:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1cb8:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    1cbc:	00010068 	andeq	r0, r1, r8, rrx
    1cc0:	01050000 	mrseq	r0, (UNDEF: 5)
    1cc4:	e0020500 	and	r0, r2, r0, lsl #10
    1cc8:	030000b9 	movweq	r0, #185	; 0xb9
    1ccc:	050107b3 	streq	r0, [r1, #-1971]	; 0xfffff84d
    1cd0:	06051303 	streq	r1, [r5], -r3, lsl #6
    1cd4:	010b0306 	tsteq	fp, r6, lsl #6
    1cd8:	74030105 	strvc	r0, [r3], #-261	; 0xfffffefb
    1cdc:	0b052e4a 	bleq	14d60c <__bss_end+0x141704>
    1ce0:	2d01052f 	cfstr32cs	mvfx0, [r1, #-188]	; 0xffffff44
    1ce4:	30060305 	andcc	r0, r6, r5, lsl #6
    1ce8:	05010a03 	streq	r0, [r1, #-2563]	; 0xfffff5fd
    1cec:	74030601 	strvc	r0, [r3], #-1537	; 0xfffff9ff
    1cf0:	2f0b0501 	svccs	0x000b0501
    1cf4:	0b030605 	bleq	c3510 <__bss_end+0xb7608>
    1cf8:	0607052e 	streq	r0, [r7], -lr, lsr #10
    1cfc:	060d0530 			; <UNDEFINED> instruction: 0x060d0530
    1d00:	06070501 	streq	r0, [r7], -r1, lsl #10
    1d04:	060d0583 	streq	r0, [sp], -r3, lsl #11
    1d08:	07052e01 	streq	r2, [r5, -r1, lsl #28]
    1d0c:	09056806 	stmdbeq	r5, {r1, r2, fp, sp, lr}
    1d10:	07050106 	streq	r0, [r5, -r6, lsl #2]
    1d14:	09052f06 	stmdbeq	r5, {r1, r2, r8, r9, sl, fp, sp}
    1d18:	07050106 	streq	r0, [r5, -r6, lsl #2]
    1d1c:	0a05c106 	beq	17213c <__bss_end+0x166234>
    1d20:	0b050106 	bleq	142140 <__bss_end+0x136238>
    1d24:	054a6803 	strbeq	r6, [sl, #-2051]	; 0xfffff7fd
    1d28:	4a18030a 	bmi	602958 <__bss_end+0x5f6a50>
    1d2c:	30060405 	andcc	r0, r6, r5, lsl #8
    1d30:	13060605 	movwne	r0, #26117	; 0x6605
    1d34:	05492f49 	strbeq	r2, [r9, #-3913]	; 0xfffff0b7
    1d38:	052f0604 	streq	r0, [pc, #-1540]!	; 173c <shift+0x173c>
    1d3c:	0a051507 	beq	147160 <__bss_end+0x13b258>
    1d40:	04050106 	streq	r0, [r5], #-262	; 0xfffffefa
    1d44:	06054c06 	streq	r4, [r5], -r6, lsl #24
    1d48:	04050106 	streq	r0, [r5], #-262	; 0xfffffefa
    1d4c:	06056a06 	streq	r6, [r5], -r6, lsl #20
    1d50:	052e0e06 	streq	r0, [lr, #-3590]!	; 0xfffff1fa
    1d54:	1005360b 	andne	r3, r5, fp, lsl #12
    1d58:	4a05054a 	bmi	143288 <__bss_end+0x137380>
    1d5c:	0608052e 	streq	r0, [r8], -lr, lsr #10
    1d60:	06060531 			; <UNDEFINED> instruction: 0x06060531
    1d64:	04052e13 	streq	r2, [r5], #-3603	; 0xfffff1ed
    1d68:	2e790306 	cdpcs	3, 7, cr0, cr9, cr6, {0}
    1d6c:	05140805 	ldreq	r0, [r4, #-2053]	; 0xfffff7fb
    1d70:	05141303 	ldreq	r1, [r4, #-771]	; 0xfffffcfd
    1d74:	050f060b 	streq	r0, [pc, #-1547]	; 1771 <shift+0x1771>
    1d78:	052e6905 	streq	r6, [lr, #-2309]!	; 0xfffff6fb
    1d7c:	052f0608 	streq	r0, [pc, #-1544]!	; 177c <shift+0x177c>
    1d80:	2e130606 	cfmsub32cs	mvax0, mvfx0, mvfx3, mvfx6
    1d84:	32060405 	andcc	r0, r6, #83886080	; 0x5000000
    1d88:	13060605 	movwne	r0, #26117	; 0x6605
    1d8c:	052f2d66 	streq	r2, [pc, #-3430]!	; 102e <shift+0x102e>
    1d90:	05662f0f 	strbeq	r2, [r6, #-3855]!	; 0xfffff0f1
    1d94:	04052c06 	streq	r2, [r5], #-3078	; 0xfffff3fa
    1d98:	06052f06 	streq	r2, [r5], -r6, lsl #30
    1d9c:	052d1306 	streq	r1, [sp, #-774]!	; 0xfffffcfa
    1da0:	052f0604 	streq	r0, [pc, #-1540]!	; 17a4 <shift+0x17a4>
    1da4:	05010606 	streq	r0, [r1, #-1542]	; 0xfffff9fa
    1da8:	05320603 	ldreq	r0, [r2, #-1539]!	; 0xfffff9fd
    1dac:	05010606 	streq	r0, [r1, #-1542]	; 0xfffff9fa
    1db0:	052f0605 	streq	r0, [pc, #-1541]!	; 17b3 <shift+0x17b3>
    1db4:	05010609 	streq	r0, [r1, #-1545]	; 0xfffff9f7
    1db8:	052f0603 	streq	r0, [pc, #-1539]!	; 17bd <shift+0x17bd>
    1dbc:	02130601 	andseq	r0, r3, #1048576	; 0x100000
    1dc0:	01010002 	tsteq	r1, r2

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
      58:	1f8e0704 	svcne	0x008e0704
      5c:	c0020000 	andgt	r0, r2, r0
      60:	01000000 	mrseq	r0, (UNDEF: 0)
      64:	00311507 	eorseq	r1, r1, r7, lsl #10
      68:	9a040000 	bls	100070 <__bss_end+0xf4168>
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
     128:	00001f8e 	andeq	r1, r0, lr, lsl #31
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
     174:	cb104801 	blgt	412180 <__bss_end+0x406278>
     178:	d0000000 	andle	r0, r0, r0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	02150a00 	andseq	r0, r5, #0, 20
     18c:	4a010000 	bmi	40194 <__bss_end+0x3428c>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x477f50>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03b11000 			; <UNDEFINED> instruction: 0x03b11000
     25c:	0a010000 	beq	40264 <__bss_end+0x3435c>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f4584>
     2b8:	a0000001 	andge	r0, r0, r1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	0000156c 	andeq	r1, r0, ip, ror #10
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	00000285 	andeq	r0, r0, r5, lsl #5
     2e4:	00092e04 	andeq	r2, r9, r4, lsl #28
     2e8:	00003400 	andeq	r3, r0, r0, lsl #8
	...
     2f4:	0001e300 	andeq	lr, r1, r0, lsl #6
     2f8:	08010200 	stmdaeq	r1, {r9}
     2fc:	0000108d 	andeq	r1, r0, sp, lsl #1
     300:	00002503 	andeq	r2, r0, r3, lsl #10
     304:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     308:	00000de7 	andeq	r0, r0, r7, ror #27
     30c:	69050404 	stmdbvs	r5, {r2, sl}
     310:	0300746e 	movweq	r7, #1134	; 0x46e
     314:	00000038 	andeq	r0, r0, r8, lsr r0
     318:	84080102 	strhi	r0, [r8], #-258	; 0xfffffefe
     31c:	02000010 	andeq	r0, r0, #16
     320:	11d20702 	bicsne	r0, r2, r2, lsl #14
     324:	15050000 	strne	r0, [r5, #-0]
     328:	0c000007 	stceq	0, cr0, [r0], {7}
     32c:	00631e09 	rsbeq	r1, r3, r9, lsl #28
     330:	52030000 	andpl	r0, r3, #0
     334:	02000000 	andeq	r0, r0, #0
     338:	1f8e0704 	svcne	0x008e0704
     33c:	63030000 	movwvs	r0, #12288	; 0x3000
     340:	06000000 	streq	r0, [r0], -r0
     344:	000012f2 	strdeq	r1, [r0], -r2
     348:	08060308 	stmdaeq	r6, {r3, r8, r9}
     34c:	00000095 	muleq	r0, r5, r0
     350:	00307207 	eorseq	r7, r0, r7, lsl #4
     354:	520e0803 	andpl	r0, lr, #196608	; 0x30000
     358:	00000000 	andeq	r0, r0, r0
     35c:	00317207 	eorseq	r7, r1, r7, lsl #4
     360:	520e0903 	andpl	r0, lr, #49152	; 0xc000
     364:	04000000 	streq	r0, [r0], #-0
     368:	0f130800 	svceq	0x00130800
     36c:	04050000 	streq	r0, [r5], #-0
     370:	00000038 	andeq	r0, r0, r8, lsr r0
     374:	de0c1e03 	cdple	14, 0, cr1, cr12, cr3, {0}
     378:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     37c:	0000070d 	andeq	r0, r0, sp, lsl #14
     380:	09730900 	ldmdbeq	r3!, {r8, fp}^
     384:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     388:	00000f35 	andeq	r0, r0, r5, lsr pc
     38c:	10c10902 	sbcne	r0, r1, r2, lsl #18
     390:	09030000 	stmdbeq	r3, {}	; <UNPREDICTABLE>
     394:	000008fc 	strdeq	r0, [r0], -ip
     398:	0dbf0904 			; <UNDEFINED> instruction: 0x0dbf0904
     39c:	09050000 	stmdbeq	r5, {}	; <UNPREDICTABLE>
     3a0:	00000453 	andeq	r0, r0, r3, asr r4
     3a4:	07c20906 	strbeq	r0, [r2, r6, lsl #18]
     3a8:	09070000 	stmdbeq	r7, {}	; <UNPREDICTABLE>
     3ac:	0000044e 	andeq	r0, r0, lr, asr #8
     3b0:	fb080008 	blx	2003da <__bss_end+0x1f44d2>
     3b4:	0500000e 	streq	r0, [r0, #-14]
     3b8:	00003804 	andeq	r3, r0, r4, lsl #16
     3bc:	0c4a0300 	mcrreq	3, 0, r0, sl, cr0
     3c0:	0000011b 	andeq	r0, r0, fp, lsl r1
     3c4:	00081509 	andeq	r1, r8, r9, lsl #10
     3c8:	6e090000 	cdpvs	0, 0, cr0, cr9, cr0, {0}
     3cc:	01000009 	tsteq	r0, r9
     3d0:	00128109 	andseq	r8, r2, r9, lsl #2
     3d4:	60090200 	andvs	r0, r9, r0, lsl #4
     3d8:	0300000c 	movweq	r0, #12
     3dc:	00090b09 	andeq	r0, r9, r9, lsl #22
     3e0:	fb090400 	blx	2413ea <__bss_end+0x2354e2>
     3e4:	05000009 	streq	r0, [r0, #-9]
     3e8:	00075c09 	andeq	r5, r7, r9, lsl #24
     3ec:	08000600 	stmdaeq	r0, {r9, sl}
     3f0:	0000073b 	andeq	r0, r0, fp, lsr r7
     3f4:	00380405 	eorseq	r0, r8, r5, lsl #8
     3f8:	71030000 	mrsvc	r0, (UNDEF: 3)
     3fc:	0001460c 	andeq	r4, r1, ip, lsl #12
     400:	10790900 	rsbsne	r0, r9, r0, lsl #18
     404:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     408:	000005eb 	andeq	r0, r0, fp, ror #11
     40c:	0f590901 	svceq	0x00590901
     410:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
     414:	00000dcf 	andeq	r0, r0, pc, asr #27
     418:	0c0a0003 	stceq	0, cr0, [sl], {3}
     41c:	0400000c 	streq	r0, [r0], #-12
     420:	005e1405 	subseq	r1, lr, r5, lsl #8
     424:	03050000 	movweq	r0, #20480	; 0x5000
     428:	0000bb08 	andeq	fp, r0, r8, lsl #22
     42c:	000fc20a 	andeq	ip, pc, sl, lsl #4
     430:	14060400 	strne	r0, [r6], #-1024	; 0xfffffc00
     434:	0000005e 	andeq	r0, r0, lr, asr r0
     438:	bb0c0305 	bllt	301054 <__bss_end+0x2f514c>
     43c:	9e0a0000 	cdpls	0, 0, cr0, cr10, cr0, {0}
     440:	0500000a 	streq	r0, [r0, #-10]
     444:	005e1a07 	subseq	r1, lr, r7, lsl #20
     448:	03050000 	movweq	r0, #20480	; 0x5000
     44c:	0000bb10 	andeq	fp, r0, r0, lsl fp
     450:	000df70a 	andeq	pc, sp, sl, lsl #14
     454:	1a090500 	bne	24185c <__bss_end+0x235954>
     458:	0000005e 	andeq	r0, r0, lr, asr r0
     45c:	bb140305 	bllt	501078 <__bss_end+0x4f5170>
     460:	700a0000 	andvc	r0, sl, r0
     464:	0500000a 	streq	r0, [r0, #-10]
     468:	005e1a0b 	subseq	r1, lr, fp, lsl #20
     46c:	03050000 	movweq	r0, #20480	; 0x5000
     470:	0000bb18 	andeq	fp, r0, r8, lsl fp
     474:	000d990a 	andeq	r9, sp, sl, lsl #18
     478:	1a0d0500 	bne	341880 <__bss_end+0x335978>
     47c:	0000005e 	andeq	r0, r0, lr, asr r0
     480:	bb1c0305 	bllt	70109c <__bss_end+0x6f5194>
     484:	ed0a0000 	stc	0, cr0, [sl, #-0]
     488:	05000006 	streq	r0, [r0, #-6]
     48c:	005e1a0f 	subseq	r1, lr, pc, lsl #20
     490:	03050000 	movweq	r0, #20480	; 0x5000
     494:	0000bb20 	andeq	fp, r0, r0, lsr #22
     498:	000c4608 	andeq	r4, ip, r8, lsl #12
     49c:	38040500 	stmdacc	r4, {r8, sl}
     4a0:	05000000 	streq	r0, [r0, #-0]
     4a4:	01e90c1b 	mvneq	r0, fp, lsl ip
     4a8:	8b090000 	blhi	2404b0 <__bss_end+0x2345a8>
     4ac:	00000006 	andeq	r0, r0, r6
     4b0:	0010ef09 	andseq	lr, r0, r9, lsl #30
     4b4:	7c090100 	stfvcs	f0, [r9], {-0}
     4b8:	02000012 	andeq	r0, r0, #18
     4bc:	04350b00 	ldrteq	r0, [r5], #-2816	; 0xfffff500
     4c0:	0c0c0000 	stceq	0, cr0, [ip], {-0}
     4c4:	90000005 	andls	r0, r0, r5
     4c8:	5c076405 	cfstrspl	mvf6, [r7], {5}
     4cc:	06000003 	streq	r0, [r0], -r3
     4d0:	0000064c 	andeq	r0, r0, ip, asr #12
     4d4:	10680524 	rsbne	r0, r8, r4, lsr #10
     4d8:	00000276 	andeq	r0, r0, r6, ror r2
     4dc:	0023760d 	eoreq	r7, r3, sp, lsl #12
     4e0:	286a0500 	stmdacs	sl!, {r8, sl}^
     4e4:	0000035c 	andeq	r0, r0, ip, asr r3
     4e8:	081a0d00 	ldmdaeq	sl, {r8, sl, fp}
     4ec:	6c050000 	stcvs	0, cr0, [r5], {-0}
     4f0:	00036c20 	andeq	r6, r3, r0, lsr #24
     4f4:	740d1000 	strvc	r1, [sp], #-0
     4f8:	05000006 	streq	r0, [r0, #-6]
     4fc:	0052236e 	subseq	r2, r2, lr, ror #6
     500:	0d140000 	ldceq	0, cr0, [r4, #-0]
     504:	00000dc8 	andeq	r0, r0, r8, asr #27
     508:	731c7105 	tstvc	ip, #1073741825	; 0x40000001
     50c:	18000003 	stmdane	r0, {r0, r1}
     510:	00120d0d 	andseq	r0, r2, sp, lsl #26
     514:	1c730500 	cfldr64ne	mvdx0, [r3], #-0
     518:	00000373 	andeq	r0, r0, r3, ror r3
     51c:	05070d1c 	streq	r0, [r7, #-3356]	; 0xfffff2e4
     520:	76050000 	strvc	r0, [r5], -r0
     524:	0003731c 	andeq	r7, r3, ip, lsl r3
     528:	c50e2000 	strgt	r2, [lr, #-0]
     52c:	0500000e 	streq	r0, [r0, #-14]
     530:	11821c78 	orrne	r1, r2, r8, ror ip
     534:	03730000 	cmneq	r3, #0
     538:	026a0000 	rsbeq	r0, sl, #0
     53c:	730f0000 	movwvc	r0, #61440	; 0xf000
     540:	10000003 	andne	r0, r0, r3
     544:	00000379 	andeq	r0, r0, r9, ror r3
     548:	71060000 	mrsvc	r0, (UNDEF: 6)
     54c:	18000012 	stmdane	r0, {r1, r4}
     550:	ab107c05 	blge	41f56c <__bss_end+0x413664>
     554:	0d000002 	stceq	0, cr0, [r0, #-8]
     558:	00002376 	andeq	r2, r0, r6, ror r3
     55c:	5c2c7f05 	stcpl	15, cr7, [ip], #-20	; 0xffffffec
     560:	00000003 	andeq	r0, r0, r3
     564:	0005970d 	andeq	r9, r5, sp, lsl #14
     568:	19810500 	stmibne	r1, {r8, sl}
     56c:	00000379 	andeq	r0, r0, r9, ror r3
     570:	0a020d10 	beq	839b8 <__bss_end+0x77ab0>
     574:	83050000 	movwhi	r0, #20480	; 0x5000
     578:	00038421 	andeq	r8, r3, r1, lsr #8
     57c:	03001400 	movweq	r1, #1024	; 0x400
     580:	00000276 	andeq	r0, r0, r6, ror r2
     584:	00049211 	andeq	r9, r4, r1, lsl r2
     588:	21870500 	orrcs	r0, r7, r0, lsl #10
     58c:	0000038a 	andeq	r0, r0, sl, lsl #7
     590:	00086211 	andeq	r6, r8, r1, lsl r2
     594:	1f890500 	svcne	0x00890500
     598:	0000005e 	andeq	r0, r0, lr, asr r0
     59c:	000e1b0d 	andeq	r1, lr, sp, lsl #22
     5a0:	178c0500 	strne	r0, [ip, r0, lsl #10]
     5a4:	000001fb 	strdeq	r0, [r0], -fp
     5a8:	07b80d00 	ldreq	r0, [r8, r0, lsl #26]!
     5ac:	8f050000 	svchi	0x00050000
     5b0:	0001fb17 	andeq	pc, r1, r7, lsl fp	; <UNPREDICTABLE>
     5b4:	8e0d2400 	cfcpyshi	mvf2, mvf13
     5b8:	0500000b 	streq	r0, [r0, #-11]
     5bc:	01fb1790 			; <UNDEFINED> instruction: 0x01fb1790
     5c0:	0d480000 	stcleq	0, cr0, [r8, #-0]
     5c4:	000009c7 	andeq	r0, r0, r7, asr #19
     5c8:	fb179105 	blx	5e49e6 <__bss_end+0x5d8ade>
     5cc:	6c000001 	stcvs	0, cr0, [r0], {1}
     5d0:	00050c12 	andeq	r0, r5, r2, lsl ip
     5d4:	09940500 	ldmibeq	r4, {r8, sl}
     5d8:	00000d3c 	andeq	r0, r0, ip, lsr sp
     5dc:	00000395 	muleq	r0, r5, r3
     5e0:	00031501 	andeq	r1, r3, r1, lsl #10
     5e4:	00031b00 	andeq	r1, r3, r0, lsl #22
     5e8:	03950f00 	orrseq	r0, r5, #0, 30
     5ec:	13000000 	movwne	r0, #0
     5f0:	00000ea8 	andeq	r0, r0, r8, lsr #29
     5f4:	710e9705 	tstvc	lr, r5, lsl #14
     5f8:	01000005 	tsteq	r0, r5
     5fc:	00000330 	andeq	r0, r0, r0, lsr r3
     600:	00000336 	andeq	r0, r0, r6, lsr r3
     604:	0003950f 	andeq	r9, r3, pc, lsl #10
     608:	15140000 	ldrne	r0, [r4, #-0]
     60c:	05000008 	streq	r0, [r0, #-8]
     610:	0c2b109a 	stceq	0, cr1, [fp], #-616	; 0xfffffd98
     614:	039b0000 	orrseq	r0, fp, #0
     618:	4b010000 	blmi	40620 <__bss_end+0x34718>
     61c:	0f000003 	svceq	0x00000003
     620:	00000395 	muleq	r0, r5, r3
     624:	00037910 	andeq	r7, r3, r0, lsl r9
     628:	01c41000 	biceq	r1, r4, r0
     62c:	00000000 	andeq	r0, r0, r0
     630:	00002515 	andeq	r2, r0, r5, lsl r5
     634:	00036c00 	andeq	r6, r3, r0, lsl #24
     638:	00631600 	rsbeq	r1, r3, r0, lsl #12
     63c:	000f0000 	andeq	r0, pc, r0
     640:	21020102 	tstcs	r2, r2, lsl #2
     644:	1700000b 	strne	r0, [r0, -fp]
     648:	0001fb04 	andeq	pc, r1, r4, lsl #22
     64c:	2c041700 	stccs	7, cr1, [r4], {-0}
     650:	0b000000 	bleq	658 <shift+0x658>
     654:	0000115f 	andeq	r1, r0, pc, asr r1
     658:	037f0417 	cmneq	pc, #385875968	; 0x17000000
     65c:	ab150000 	blge	540664 <__bss_end+0x53475c>
     660:	95000002 	strls	r0, [r0, #-2]
     664:	18000003 	stmdane	r0, {r0, r1}
     668:	ee041700 	cdp	7, 0, cr1, cr4, cr0, {0}
     66c:	17000001 	strne	r0, [r0, -r1]
     670:	0001e904 	andeq	lr, r1, r4, lsl #18
     674:	0e8f1900 	vdiveq.f16	s2, s30, s0	; <UNPREDICTABLE>
     678:	9d050000 	stcls	0, cr0, [r5, #-0]
     67c:	0001ee14 	andeq	lr, r1, r4, lsl lr
     680:	06a60a00 	strteq	r0, [r6], r0, lsl #20
     684:	04060000 	streq	r0, [r6], #-0
     688:	00005e14 	andeq	r5, r0, r4, lsl lr
     68c:	24030500 	strcs	r0, [r3], #-1280	; 0xfffffb00
     690:	0a0000bb 	beq	984 <shift+0x984>
     694:	00000f3b 	andeq	r0, r0, fp, lsr pc
     698:	5e140706 	cdppl	7, 1, cr0, cr4, cr6, {0}
     69c:	05000000 	streq	r0, [r0, #-0]
     6a0:	00bb2803 	adcseq	r2, fp, r3, lsl #16
     6a4:	055e0a00 	ldrbeq	r0, [lr, #-2560]	; 0xfffff600
     6a8:	0a060000 	beq	1806b0 <__bss_end+0x1747a8>
     6ac:	00005e14 	andeq	r5, r0, r4, lsl lr
     6b0:	2c030500 	cfstr32cs	mvfx0, [r3], {-0}
     6b4:	080000bb 	stmdaeq	r0, {r0, r1, r3, r4, r5, r7}
     6b8:	0000076c 	andeq	r0, r0, ip, ror #14
     6bc:	00380405 	eorseq	r0, r8, r5, lsl #8
     6c0:	0d060000 	stceq	0, cr0, [r6, #-0]
     6c4:	00041a0c 	andeq	r1, r4, ip, lsl #20
     6c8:	654e1a00 	strbvs	r1, [lr, #-2560]	; 0xfffff600
     6cc:	09000077 	stmdbeq	r0, {r0, r1, r2, r4, r5, r6}
     6d0:	00000982 	andeq	r0, r0, r2, lsl #19
     6d4:	05560901 	ldrbeq	r0, [r6, #-2305]	; 0xfffff6ff
     6d8:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
     6dc:	00000785 	andeq	r0, r0, r5, lsl #15
     6e0:	10b30903 	adcsne	r0, r3, r3, lsl #18
     6e4:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     6e8:	000004f8 	strdeq	r0, [r0], -r8
     6ec:	bf060005 	svclt	0x00060005
     6f0:	10000006 	andne	r0, r0, r6
     6f4:	59081b06 	stmdbpl	r8, {r1, r2, r8, r9, fp, ip}
     6f8:	07000004 	streq	r0, [r0, -r4]
     6fc:	0600726c 	streq	r7, [r0], -ip, ror #4
     700:	0459131d 	ldrbeq	r1, [r9], #-797	; 0xfffffce3
     704:	07000000 	streq	r0, [r0, -r0]
     708:	06007073 			; <UNDEFINED> instruction: 0x06007073
     70c:	0459131e 	ldrbeq	r1, [r9], #-798	; 0xfffffce2
     710:	07040000 	streq	r0, [r4, -r0]
     714:	06006370 			; <UNDEFINED> instruction: 0x06006370
     718:	0459131f 	ldrbeq	r1, [r9], #-799	; 0xfffffce1
     71c:	0d080000 	stceq	0, cr0, [r8, #-0]
     720:	00000ed0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     724:	59132006 	ldmdbpl	r3, {r1, r2, sp}
     728:	0c000004 	stceq	0, cr0, [r0], {4}
     72c:	07040200 	streq	r0, [r4, -r0, lsl #4]
     730:	00001f89 	andeq	r1, r0, r9, lsl #31
     734:	00045903 	andeq	r5, r4, r3, lsl #18
     738:	08ef0600 	stmiaeq	pc!, {r9, sl}^	; <UNPREDICTABLE>
     73c:	06700000 	ldrbteq	r0, [r0], -r0
     740:	04f50828 	ldrbteq	r0, [r5], #2088	; 0x828
     744:	e70d0000 	str	r0, [sp, -r0]
     748:	06000007 	streq	r0, [r0], -r7
     74c:	041a122a 	ldreq	r1, [sl], #-554	; 0xfffffdd6
     750:	07000000 	streq	r0, [r0, -r0]
     754:	00646970 	rsbeq	r6, r4, r0, ror r9
     758:	63122b06 	tstvs	r2, #6144	; 0x1800
     75c:	10000000 	andne	r0, r0, r0
     760:	001d670d 	andseq	r6, sp, sp, lsl #14
     764:	112c0600 			; <UNDEFINED> instruction: 0x112c0600
     768:	000003e3 	andeq	r0, r0, r3, ror #7
     76c:	106b0d14 	rsbne	r0, fp, r4, lsl sp
     770:	2d060000 	stccs	0, cr0, [r6, #-0]
     774:	00006312 	andeq	r6, r0, r2, lsl r3
     778:	c50d1800 	strgt	r1, [sp, #-2048]	; 0xfffff800
     77c:	06000003 	streq	r0, [r0], -r3
     780:	0063122e 	rsbeq	r1, r3, lr, lsr #4
     784:	0d1c0000 	ldceq	0, cr0, [ip, #-0]
     788:	00000f28 	andeq	r0, r0, r8, lsr #30
     78c:	f5312f06 			; <UNDEFINED> instruction: 0xf5312f06
     790:	20000004 	andcs	r0, r0, r4
     794:	00045f0d 	andeq	r5, r4, sp, lsl #30
     798:	09300600 	ldmdbeq	r0!, {r9, sl}
     79c:	00000038 	andeq	r0, r0, r8, lsr r0
     7a0:	0afb0d60 	beq	ffec3d28 <__bss_end+0xffeb7e20>
     7a4:	31060000 	mrscc	r0, (UNDEF: 6)
     7a8:	0000520e 	andeq	r5, r0, lr, lsl #4
     7ac:	e90d6400 	stmdb	sp, {sl, sp, lr}
     7b0:	0600000c 	streq	r0, [r0], -ip
     7b4:	00520e33 	subseq	r0, r2, r3, lsr lr
     7b8:	0d680000 	stcleq	0, cr0, [r8, #-0]
     7bc:	00000ce0 	andeq	r0, r0, r0, ror #25
     7c0:	520e3406 	andpl	r3, lr, #100663296	; 0x6000000
     7c4:	6c000000 	stcvs	0, cr0, [r0], {-0}
     7c8:	039b1500 	orrseq	r1, fp, #0, 10
     7cc:	05050000 	streq	r0, [r5, #-0]
     7d0:	63160000 	tstvs	r6, #0
     7d4:	0f000000 	svceq	0x00000000
     7d8:	05340a00 	ldreq	r0, [r4, #-2560]!	; 0xfffff600
     7dc:	0a070000 	beq	1c07e4 <__bss_end+0x1b48dc>
     7e0:	00005e14 	andeq	r5, r0, r4, lsl lr
     7e4:	30030500 	andcc	r0, r3, r0, lsl #10
     7e8:	080000bb 	stmdaeq	r0, {r0, r1, r3, r4, r5, r7}
     7ec:	00000ae6 	andeq	r0, r0, r6, ror #21
     7f0:	00380405 	eorseq	r0, r8, r5, lsl #8
     7f4:	0d070000 	stceq	0, cr0, [r7, #-0]
     7f8:	0005360c 	andeq	r3, r5, ip, lsl #12
     7fc:	12910900 	addsne	r0, r1, #0, 18
     800:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     804:	00001128 	andeq	r1, r0, r8, lsr #2
     808:	ae060001 	cdpge	0, 0, cr0, cr6, cr1, {0}
     80c:	0c000008 	stceq	0, cr0, [r0], {8}
     810:	6b081b07 	blvs	207434 <__bss_end+0x1fb52c>
     814:	0d000005 	stceq	0, cr0, [r0, #-20]	; 0xffffffec
     818:	00000609 	andeq	r0, r0, r9, lsl #12
     81c:	6b191d07 	blvs	647c40 <__bss_end+0x63bd38>
     820:	00000005 	andeq	r0, r0, r5
     824:	0005070d 	andeq	r0, r5, sp, lsl #14
     828:	191e0700 	ldmdbne	lr, {r8, r9, sl}
     82c:	0000056b 	andeq	r0, r0, fp, ror #10
     830:	0b160d04 	bleq	583c48 <__bss_end+0x577d40>
     834:	1f070000 	svcne	0x00070000
     838:	00057113 	andeq	r7, r5, r3, lsl r1
     83c:	17000800 	strne	r0, [r0, -r0, lsl #16]
     840:	00053604 	andeq	r3, r5, r4, lsl #12
     844:	65041700 	strvs	r1, [r4, #-1792]	; 0xfffff900
     848:	0c000004 	stceq	0, cr0, [r0], {4}
     84c:	00000e4a 	andeq	r0, r0, sl, asr #28
     850:	07220714 			; <UNDEFINED> instruction: 0x07220714
     854:	000007f9 	strdeq	r0, [r0], -r9
     858:	000c1a0d 	andeq	r1, ip, sp, lsl #20
     85c:	12260700 	eorne	r0, r6, #0, 14
     860:	00000052 	andeq	r0, r0, r2, asr r0
     864:	0f700d00 	svceq	0x00700d00
     868:	29070000 	stmdbcs	r7, {}	; <UNPREDICTABLE>
     86c:	00056b1d 	andeq	r6, r5, sp, lsl fp
     870:	8d0d0400 	cfstrshi	mvf0, [sp, #-0]
     874:	07000007 	streq	r0, [r0, -r7]
     878:	056b1d2c 	strbeq	r1, [fp, #-3372]!	; 0xfffff2d4
     87c:	1b080000 	blne	200884 <__bss_end+0x1f497c>
     880:	00000c56 	andeq	r0, r0, r6, asr ip
     884:	8b0e2f07 	blhi	38c4a8 <__bss_end+0x3805a0>
     888:	bf000008 	svclt	0x00000008
     88c:	ca000005 	bgt	8a8 <shift+0x8a8>
     890:	0f000005 	svceq	0x00000005
     894:	000007fe 	strdeq	r0, [r0], -lr
     898:	00056b10 	andeq	r6, r5, r0, lsl fp
     89c:	8b1c0000 	blhi	7008a4 <__bss_end+0x6f499c>
     8a0:	07000009 	streq	r0, [r0, -r9]
     8a4:	08c60e31 	stmiaeq	r6, {r0, r4, r5, r9, sl, fp}^
     8a8:	036c0000 	cmneq	ip, #0
     8ac:	05e20000 	strbeq	r0, [r2, #0]!
     8b0:	05ed0000 	strbeq	r0, [sp, #0]!
     8b4:	fe0f0000 	cdp2	0, 0, cr0, cr15, cr0, {0}
     8b8:	10000007 	andne	r0, r0, r7
     8bc:	00000571 	andeq	r0, r0, r1, ror r5
     8c0:	10c71200 	sbcne	r1, r7, r0, lsl #4
     8c4:	35070000 	strcc	r0, [r7, #-0]
     8c8:	000ac11d 	andeq	ip, sl, sp, lsl r1
     8cc:	00056b00 	andeq	r6, r5, r0, lsl #22
     8d0:	06060200 	streq	r0, [r6], -r0, lsl #4
     8d4:	060c0000 	streq	r0, [ip], -r0
     8d8:	fe0f0000 	cdp2	0, 0, cr0, cr15, cr0, {0}
     8dc:	00000007 	andeq	r0, r0, r7
     8e0:	00077812 	andeq	r7, r7, r2, lsl r8
     8e4:	1d370700 	ldcne	7, cr0, [r7, #-0]
     8e8:	00000c66 	andeq	r0, r0, r6, ror #24
     8ec:	0000056b 	andeq	r0, r0, fp, ror #10
     8f0:	00062502 	andeq	r2, r6, r2, lsl #10
     8f4:	00062b00 	andeq	r2, r6, r0, lsl #22
     8f8:	07fe0f00 	ldrbeq	r0, [lr, r0, lsl #30]!
     8fc:	1d000000 	stcne	0, cr0, [r0, #-0]
     900:	00000b9e 	muleq	r0, lr, fp
     904:	17443907 	strbne	r3, [r4, -r7, lsl #18]
     908:	0c000008 	stceq	0, cr0, [r0], {8}
     90c:	0e4a1202 	cdpeq	2, 4, cr1, cr10, cr2, {0}
     910:	3c070000 	stccc	0, cr0, [r7], {-0}
     914:	00099a09 	andeq	r9, r9, r9, lsl #20
     918:	0007fe00 	andeq	pc, r7, r0, lsl #28
     91c:	06520100 	ldrbeq	r0, [r2], -r0, lsl #2
     920:	06580000 	ldrbeq	r0, [r8], -r0
     924:	fe0f0000 	cdp2	0, 0, cr0, cr15, cr0, {0}
     928:	00000007 	andeq	r0, r0, r7
     92c:	0007f312 	andeq	pc, r7, r2, lsl r3	; <UNPREDICTABLE>
     930:	123f0700 	eorsne	r0, pc, #0, 14
     934:	000005c0 	andeq	r0, r0, r0, asr #11
     938:	00000052 	andeq	r0, r0, r2, asr r0
     93c:	00067101 	andeq	r7, r6, r1, lsl #2
     940:	00068600 	andeq	r8, r6, r0, lsl #12
     944:	07fe0f00 	ldrbeq	r0, [lr, r0, lsl #30]!
     948:	20100000 	andscs	r0, r0, r0
     94c:	10000008 	andne	r0, r0, r8
     950:	00000063 	andeq	r0, r0, r3, rrx
     954:	00036c10 	andeq	r6, r3, r0, lsl ip
     958:	fa130000 	blx	4c0960 <__bss_end+0x4b4a58>
     95c:	07000010 	smladeq	r0, r0, r0, r0
     960:	06cc0e42 	strbeq	r0, [ip], r2, asr #28
     964:	9b010000 	blls	4096c <__bss_end+0x34a64>
     968:	a1000006 	tstge	r0, r6
     96c:	0f000006 	svceq	0x00000006
     970:	000007fe 	strdeq	r0, [r0], -lr
     974:	05a21200 	streq	r1, [r2, #512]!	; 0x200
     978:	45070000 	strmi	r0, [r7, #-0]
     97c:	00060e17 	andeq	r0, r6, r7, lsl lr
     980:	00057100 	andeq	r7, r5, r0, lsl #2
     984:	06ba0100 	ldrteq	r0, [sl], r0, lsl #2
     988:	06c00000 	strbeq	r0, [r0], r0
     98c:	260f0000 	strcs	r0, [pc], -r0
     990:	00000008 	andeq	r0, r0, r8
     994:	000f4612 	andeq	r4, pc, r2, lsl r6	; <UNPREDICTABLE>
     998:	17480700 	strbne	r0, [r8, -r0, lsl #14]
     99c:	000003db 	ldrdeq	r0, [r0], -fp
     9a0:	00000571 	andeq	r0, r0, r1, ror r5
     9a4:	0006d901 	andeq	sp, r6, r1, lsl #18
     9a8:	0006e400 	andeq	lr, r6, r0, lsl #8
     9ac:	08260f00 	stmdaeq	r6!, {r8, r9, sl, fp}
     9b0:	52100000 	andspl	r0, r0, #0
     9b4:	00000000 	andeq	r0, r0, r0
     9b8:	0006f713 	andeq	pc, r6, r3, lsl r7	; <UNPREDICTABLE>
     9bc:	0e4b0700 	cdpeq	7, 4, cr0, cr11, cr0, {0}
     9c0:	00000bc8 	andeq	r0, r0, r8, asr #23
     9c4:	0006f901 	andeq	pc, r6, r1, lsl #18
     9c8:	0006ff00 	andeq	pc, r6, r0, lsl #30
     9cc:	07fe0f00 	ldrbeq	r0, [lr, r0, lsl #30]!
     9d0:	12000000 	andne	r0, r0, #0
     9d4:	0000098b 	andeq	r0, r0, fp, lsl #19
     9d8:	710e4d07 	tstvc	lr, r7, lsl #26
     9dc:	6c00000d 	stcvs	0, cr0, [r0], {13}
     9e0:	01000003 	tsteq	r0, r3
     9e4:	00000718 	andeq	r0, r0, r8, lsl r7
     9e8:	00000723 	andeq	r0, r0, r3, lsr #14
     9ec:	0007fe0f 	andeq	pc, r7, pc, lsl #28
     9f0:	00521000 	subseq	r1, r2, r0
     9f4:	12000000 	andne	r0, r0, #0
     9f8:	000004e4 	andeq	r0, r0, r4, ror #9
     9fc:	08125007 	ldmdaeq	r2, {r0, r1, r2, ip, lr}
     a00:	52000004 	andpl	r0, r0, #4
     a04:	01000000 	mrseq	r0, (UNDEF: 0)
     a08:	0000073c 	andeq	r0, r0, ip, lsr r7
     a0c:	00000747 	andeq	r0, r0, r7, asr #14
     a10:	0007fe0f 	andeq	pc, r7, pc, lsl #28
     a14:	039b1000 	orrseq	r1, fp, #0
     a18:	12000000 	andne	r0, r0, #0
     a1c:	0000043b 	andeq	r0, r0, fp, lsr r4
     a20:	330e5307 	movwcc	r5, #58119	; 0xe307
     a24:	6c000011 	stcvs	0, cr0, [r0], {17}
     a28:	01000003 	tsteq	r0, r3
     a2c:	00000760 	andeq	r0, r0, r0, ror #14
     a30:	0000076b 	andeq	r0, r0, fp, ror #14
     a34:	0007fe0f 	andeq	pc, r7, pc, lsl #28
     a38:	00521000 	subseq	r1, r2, r0
     a3c:	13000000 	movwne	r0, #0
     a40:	0000049e 	muleq	r0, lr, r4
     a44:	e50e5607 	str	r5, [lr, #-1543]	; 0xfffff9f9
     a48:	0100000f 	tsteq	r0, pc
     a4c:	00000780 	andeq	r0, r0, r0, lsl #15
     a50:	0000079f 	muleq	r0, pc, r7	; <UNPREDICTABLE>
     a54:	0007fe0f 	andeq	pc, r7, pc, lsl #28
     a58:	00951000 	addseq	r1, r5, r0
     a5c:	52100000 	andspl	r0, r0, #0
     a60:	10000000 	andne	r0, r0, r0
     a64:	00000052 	andeq	r0, r0, r2, asr r0
     a68:	00005210 	andeq	r5, r0, r0, lsl r2
     a6c:	082c1000 	stmdaeq	ip!, {ip}
     a70:	13000000 	movwne	r0, #0
     a74:	000011b2 			; <UNDEFINED> instruction: 0x000011b2
     a78:	a60e5807 	strge	r5, [lr], -r7, lsl #16
     a7c:	01000012 	tsteq	r0, r2, lsl r0
     a80:	000007b4 			; <UNDEFINED> instruction: 0x000007b4
     a84:	000007d3 	ldrdeq	r0, [r0], -r3
     a88:	0007fe0f 	andeq	pc, r7, pc, lsl #28
     a8c:	00de1000 	sbcseq	r1, lr, r0
     a90:	52100000 	andspl	r0, r0, #0
     a94:	10000000 	andne	r0, r0, r0
     a98:	00000052 	andeq	r0, r0, r2, asr r0
     a9c:	00005210 	andeq	r5, r0, r0, lsl r2
     aa0:	082c1000 	stmdaeq	ip!, {ip}
     aa4:	14000000 	strne	r0, [r0], #-0
     aa8:	000004b1 			; <UNDEFINED> instruction: 0x000004b1
     aac:	260e5b07 	strcs	r5, [lr], -r7, lsl #22
     ab0:	6c00000b 	stcvs	0, cr0, [r0], {11}
     ab4:	01000003 	tsteq	r0, r3
     ab8:	000007e8 	andeq	r0, r0, r8, ror #15
     abc:	0007fe0f 	andeq	pc, r7, pc, lsl #28
     ac0:	05171000 	ldreq	r1, [r7, #-0]
     ac4:	32100000 	andscc	r0, r0, #0
     ac8:	00000008 	andeq	r0, r0, r8
     acc:	05770300 	ldrbeq	r0, [r7, #-768]!	; 0xfffffd00
     ad0:	04170000 	ldreq	r0, [r7], #-0
     ad4:	00000577 	andeq	r0, r0, r7, ror r5
     ad8:	00056b1e 	andeq	r6, r5, lr, lsl fp
     adc:	00081100 	andeq	r1, r8, r0, lsl #2
     ae0:	00081700 	andeq	r1, r8, r0, lsl #14
     ae4:	07fe0f00 	ldrbeq	r0, [lr, r0, lsl #30]!
     ae8:	1f000000 	svcne	0x00000000
     aec:	00000577 	andeq	r0, r0, r7, ror r5
     af0:	00000804 	andeq	r0, r0, r4, lsl #16
     af4:	00440417 	subeq	r0, r4, r7, lsl r4
     af8:	04170000 	ldreq	r0, [r7], #-0
     afc:	000007f9 	strdeq	r0, [r0], -r9
     b00:	006f0420 	rsbeq	r0, pc, r0, lsr #8
     b04:	04210000 	strteq	r0, [r1], #-0
     b08:	0011f519 	andseq	pc, r1, r9, lsl r5	; <UNPREDICTABLE>
     b0c:	195e0700 	ldmdbne	lr, {r8, r9, sl}^
     b10:	00000577 	andeq	r0, r0, r7, ror r5
     b14:	000d2322 	andeq	r2, sp, r2, lsr #6
     b18:	0b040800 	bleq	102b20 <__bss_end+0xf6c18>
     b1c:	0000085b 	andeq	r0, r0, fp, asr r8
     b20:	000a4f23 	andeq	r4, sl, r3, lsr #30
     b24:	0f060800 	svceq	0x00060800
     b28:	0000003f 	andeq	r0, r0, pc, lsr r0
     b2c:	24000100 	strcs	r0, [r0], #-256	; 0xffffff00
     b30:	0000084c 	andeq	r0, r0, ip, asr #16
     b34:	0014c525 	andseq	ip, r4, r5, lsr #10
     b38:	08010c00 	stmdaeq	r1, {sl, fp}
     b3c:	09590709 	ldmdbeq	r9, {r0, r3, r8, r9, sl}^
     b40:	690d0000 	stmdbvs	sp, {}	; <UNPREDICTABLE>
     b44:	0800000b 	stmdaeq	r0, {r0, r1, r3}
     b48:	0959330c 	ldmdbeq	r9, {r2, r3, r8, r9, ip, sp}^
     b4c:	26000000 	strcs	r0, [r0], -r0
     b50:	00000a09 	andeq	r0, r0, r9, lsl #20
     b54:	6c0e0d08 	stcvs	13, cr0, [lr], {8}
     b58:	00000003 	andeq	r0, r0, r3
     b5c:	10dc2601 	sbcsne	r2, ip, r1, lsl #12
     b60:	0f080000 	svceq	0x00080000
     b64:	0000380d 	andeq	r3, r0, sp, lsl #16
     b68:	26010400 	strcs	r0, [r1], -r0, lsl #8
     b6c:	00000cb7 			; <UNDEFINED> instruction: 0x00000cb7
     b70:	380d1008 	stmdacc	sp, {r3, ip}
     b74:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     b78:	14c51201 	strbne	r1, [r5], #513	; 0x201
     b7c:	13080000 	movwne	r0, #32768	; 0x8000
     b80:	000e3409 	andeq	r3, lr, r9, lsl #8
     b84:	00096900 	andeq	r6, r9, r0, lsl #18
     b88:	08be0100 	ldmeq	lr!, {r8}
     b8c:	08c40000 	stmiaeq	r4, {}^	; <UNPREDICTABLE>
     b90:	690f0000 	stmdbvs	pc, {}	; <UNPREDICTABLE>
     b94:	00000009 	andeq	r0, r0, r9
     b98:	00091112 	andeq	r1, r9, r2, lsl r1
     b9c:	0e150800 	cdpeq	8, 1, cr0, cr5, cr0, {0}
     ba0:	000005f6 	strdeq	r0, [r0], -r6
     ba4:	0000036c 	andeq	r0, r0, ip, ror #6
     ba8:	0008dd01 	andeq	sp, r8, r1, lsl #26
     bac:	0008e300 	andeq	lr, r8, r0, lsl #6
     bb0:	09690f00 	stmdbeq	r9!, {r8, r9, sl, fp}^
     bb4:	13000000 	movwne	r0, #0
     bb8:	000004ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     bbc:	5c0e1708 	stcpl	7, cr1, [lr], {8}
     bc0:	01000012 	tsteq	r0, r2, lsl r0
     bc4:	000008f8 	strdeq	r0, [r0], -r8
     bc8:	000008fe 	strdeq	r0, [r0], -lr
     bcc:	0009690f 	andeq	r6, r9, pc, lsl #18
     bd0:	93130000 	tstls	r3, #0
     bd4:	0800000f 	stmdaeq	r0, {r0, r1, r2, r3}
     bd8:	0e090e19 	mcreq	14, 0, r0, cr9, cr9, {0}
     bdc:	13010000 	movwne	r0, #4096	; 0x1000
     be0:	1e000009 	cdpne	0, 0, cr0, cr0, cr9, {0}
     be4:	0f000009 	svceq	0x00000009
     be8:	00000969 	andeq	r0, r0, r9, ror #18
     bec:	00002510 	andeq	r2, r0, r0, lsl r5
     bf0:	74120000 	ldrvc	r0, [r2], #-0
     bf4:	08000008 	stmdaeq	r0, {r3}
     bf8:	0eb30e1b 	mrceq	14, 5, r0, cr3, cr11, {0}
     bfc:	00250000 	eoreq	r0, r5, r0
     c00:	37010000 	strcc	r0, [r1, -r0]
     c04:	3d000009 	stccc	0, cr0, [r0, #-36]	; 0xffffffdc
     c08:	0f000009 	svceq	0x00000009
     c0c:	00000969 	andeq	r0, r0, r9, ror #18
     c10:	12341400 	eorsne	r1, r4, #0, 8
     c14:	1d080000 	stcne	0, cr0, [r8, #-0]
     c18:	0005180d 	andeq	r1, r5, sp, lsl #16
     c1c:	00003800 	andeq	r3, r0, r0, lsl #16
     c20:	09520100 	ldmdbeq	r2, {r8}^
     c24:	690f0000 	stmdbvs	pc, {}	; <UNPREDICTABLE>
     c28:	00000009 	andeq	r0, r0, r9
     c2c:	00251500 	eoreq	r1, r5, r0, lsl #10
     c30:	09690000 	stmdbeq	r9!, {}^	; <UNPREDICTABLE>
     c34:	63160000 	tstvs	r6, #0
     c38:	ff000000 			; <UNDEFINED> instruction: 0xff000000
     c3c:	60041700 	andvs	r1, r4, r0, lsl #14
     c40:	19000008 	stmdbne	r0, {r3}
     c44:	000014c1 	andeq	r1, r0, r1, asr #9
     c48:	600f2008 	andvs	r2, pc, r8
     c4c:	27000008 	strcs	r0, [r0, -r8]
     c50:	006c6168 	rsbeq	r6, ip, r8, ror #2
     c54:	350b0509 	strcc	r0, [fp, #-1289]	; 0xfffffaf7
     c58:	2800000a 	stmdacs	r0, {r1, r3}
     c5c:	00000b7b 	andeq	r0, r0, fp, ror fp
     c60:	6a190709 	bvs	64288c <__bss_end+0x636984>
     c64:	80000000 	andhi	r0, r0, r0
     c68:	280ee6b2 	stmdacs	lr, {r1, r4, r5, r7, r9, sl, sp, lr, pc}
     c6c:	00000f83 	andeq	r0, r0, r3, lsl #31
     c70:	601a0a09 	andsvs	r0, sl, r9, lsl #20
     c74:	00000004 	andeq	r0, r0, r4
     c78:	28200000 	stmdacs	r0!, {}	; <UNPREDICTABLE>
     c7c:	000005b6 			; <UNDEFINED> instruction: 0x000005b6
     c80:	601a0d09 	andsvs	r0, sl, r9, lsl #26
     c84:	00000004 	andeq	r0, r0, r4
     c88:	29202000 	stmdbcs	r0!, {sp}
     c8c:	00000b07 	andeq	r0, r0, r7, lsl #22
     c90:	5e151009 	cdppl	0, 1, cr1, cr5, cr9, {0}
     c94:	36000000 	strcc	r0, [r0], -r0
     c98:	0010d328 	andseq	sp, r0, r8, lsr #6
     c9c:	1a420900 	bne	10830a4 <__bss_end+0x107719c>
     ca0:	00000460 	andeq	r0, r0, r0, ror #8
     ca4:	20215000 	eorcs	r5, r1, r0
     ca8:	00124228 	andseq	r4, r2, r8, lsr #4
     cac:	1a710900 	bne	1c430b4 <__bss_end+0x1c371ac>
     cb0:	00000460 	andeq	r0, r0, r0, ror #8
     cb4:	2000b200 	andcs	fp, r0, r0, lsl #4
     cb8:	00085028 	andeq	r5, r8, r8, lsr #32
     cbc:	1aa40900 	bne	fe9030c4 <__bss_end+0xfe8f71bc>
     cc0:	00000460 	andeq	r0, r0, r0, ror #8
     cc4:	2000b400 	andcs	fp, r0, r0, lsl #8
     cc8:	000b7128 	andeq	r7, fp, r8, lsr #2
     ccc:	1ab30900 	bne	fecc30d4 <__bss_end+0xfecb71cc>
     cd0:	00000460 	andeq	r0, r0, r0, ror #8
     cd4:	20104000 	andscs	r4, r0, r0
     cd8:	000c8c28 	andeq	r8, ip, r8, lsr #24
     cdc:	1abe0900 	bne	fef830e4 <__bss_end+0xfef771dc>
     ce0:	00000460 	andeq	r0, r0, r0, ror #8
     ce4:	20205000 	eorcs	r5, r0, r0
     ce8:	00075228 	andeq	r5, r7, r8, lsr #4
     cec:	1abf0900 	bne	fefc30f4 <__bss_end+0xfefb71ec>
     cf0:	00000460 	andeq	r0, r0, r0, ror #8
     cf4:	20804000 	addcs	r4, r0, r0
     cf8:	0010e528 	andseq	lr, r0, r8, lsr #10
     cfc:	1ac00900 	bne	ff003104 <__bss_end+0xfeff71fc>
     d00:	00000460 	andeq	r0, r0, r0, ror #8
     d04:	20805000 	addcs	r5, r0, r0
     d08:	09872400 	stmibeq	r7, {sl, sp}
     d0c:	97240000 	strls	r0, [r4, -r0]!
     d10:	24000009 	strcs	r0, [r0], #-9
     d14:	000009a7 	andeq	r0, r0, r7, lsr #19
     d18:	0009b724 	andeq	fp, r9, r4, lsr #14
     d1c:	09c42400 	stmibeq	r4, {sl, sp}^
     d20:	d4240000 	strtle	r0, [r4], #-0
     d24:	24000009 	strcs	r0, [r0], #-9
     d28:	000009e4 	andeq	r0, r0, r4, ror #19
     d2c:	0009f424 	andeq	pc, r9, r4, lsr #8
     d30:	0a042400 	beq	109d38 <__bss_end+0xfde30>
     d34:	14240000 	strtne	r0, [r4], #-0
     d38:	2400000a 	strcs	r0, [r0], #-10
     d3c:	00000a24 	andeq	r0, r0, r4, lsr #20
     d40:	6d656d27 	stclvs	13, cr6, [r5, #-156]!	; 0xffffff64
     d44:	0b060a00 	bleq	18354c <__bss_end+0x177644>
     d48:	00000ad7 	ldrdeq	r0, [r0], -r7
     d4c:	0009d128 	andeq	sp, r9, r8, lsr #2
     d50:	18090a00 	stmdane	r9, {r9, fp}
     d54:	0000005e 	andeq	r0, r0, lr, asr r0
     d58:	00100000 	andseq	r0, r0, r0
     d5c:	0009da28 	andeq	sp, r9, r8, lsr #20
     d60:	180e0a00 	stmdane	lr, {r9, fp}
     d64:	0000005e 	andeq	r0, r0, lr, asr r0
     d68:	c1000000 	mrsgt	r0, (UNDEF: 0)
     d6c:	000fa428 	andeq	sl, pc, r8, lsr #8
     d70:	18110a00 	ldmdane	r1, {r9, fp}
     d74:	0000005e 	andeq	r0, r0, lr, asr r0
     d78:	d1000000 	mrsle	r0, (UNDEF: 0)
     d7c:	000fce28 	andeq	ip, pc, r8, lsr #28
     d80:	18150a00 	ldmdane	r5, {r9, fp}
     d84:	0000005e 	andeq	r0, r0, lr, asr r0
     d88:	c0000000 	andgt	r0, r0, r0
     d8c:	0007d628 	andeq	sp, r7, r8, lsr #12
     d90:	18180a00 	ldmdane	r8, {r9, fp}
     d94:	0000005e 	andeq	r0, r0, lr, asr r0
     d98:	10000000 	andne	r0, r0, r0
     d9c:	000ef12a 	andeq	pc, lr, sl, lsr #2
     da0:	181b0a00 	ldmdane	fp, {r9, fp}
     da4:	0000005e 	andeq	r0, r0, lr, asr r0
     da8:	24000100 	strcs	r0, [r0], #-256	; 0xffffff00
     dac:	00000a78 	andeq	r0, r0, r8, ror sl
     db0:	000a8824 	andeq	r8, sl, r4, lsr #16
     db4:	0a982400 	beq	fe609dbc <__bss_end+0xfe5fdeb4>
     db8:	a8240000 	stmdage	r4!, {}	; <UNPREDICTABLE>
     dbc:	2400000a 	strcs	r0, [r0], #-10
     dc0:	00000ab8 			; <UNDEFINED> instruction: 0x00000ab8
     dc4:	000ac824 	andeq	ip, sl, r4, lsr #16
     dc8:	10530600 	subsne	r0, r3, r0, lsl #12
     dcc:	01140000 	tsteq	r4, r0
     dd0:	0b440806 	bleq	1102df0 <__bss_end+0x10f6ee8>
     dd4:	090d0000 	stmdbeq	sp, {}	; <UNPREDICTABLE>
     dd8:	01000006 	tsteq	r0, r6
     ddc:	0b440c08 	bleq	1103e04 <__bss_end+0x10f7efc>
     de0:	0d000000 	stceq	0, cr0, [r0, #-0]
     de4:	00000507 	andeq	r0, r0, r7, lsl #10
     de8:	440c0901 	strmi	r0, [ip], #-2305	; 0xfffff6ff
     dec:	0400000b 	streq	r0, [r0], #-11
     df0:	000faf0d 	andeq	sl, pc, sp, lsl #30
     df4:	0e0a0100 	adfeqe	f0, f2, f0
     df8:	00000052 	andeq	r0, r0, r2, asr r0
     dfc:	16600d08 	strbtne	r0, [r0], -r8, lsl #26
     e00:	0b010000 	bleq	40e08 <__bss_end+0x34f00>
     e04:	0000520e 	andeq	r5, r0, lr, lsl #4
     e08:	c10d0c00 	tstgt	sp, r0, lsl #24
     e0c:	01000008 	tsteq	r0, r8
     e10:	036c0a0c 	cmneq	ip, #12, 20	; 0xc000
     e14:	00100000 	andseq	r0, r0, r0
     e18:	0af50417 	beq	ffd41e7c <__bss_end+0xffd35f74>
     e1c:	5b0c0000 	blpl	300e24 <__bss_end+0x2f4f1c>
     e20:	1400000e 	strne	r0, [r0], #-14
     e24:	43070f01 	movwmi	r0, #32513	; 0x7f01
     e28:	0d00000c 	stceq	0, cr0, [r0, #-48]	; 0xffffffd0
     e2c:	00000c24 	andeq	r0, r0, r4, lsr #24
     e30:	44101201 	ldrmi	r1, [r0], #-513	; 0xfffffdff
     e34:	0000000b 	andeq	r0, r0, fp
     e38:	000c9f0d 	andeq	r9, ip, sp, lsl #30
     e3c:	12130100 	andsne	r0, r3, #0, 2
     e40:	00000052 	andeq	r0, r0, r2, asr r0
     e44:	069f0d04 	ldreq	r0, [pc], r4, lsl #26
     e48:	14010000 	strne	r0, [r1], #-0
     e4c:	00005212 	andeq	r5, r0, r2, lsl r2
     e50:	430d0800 	movwmi	r0, #55296	; 0xd800
     e54:	0100000e 	tsteq	r0, lr
     e58:	00521215 	subseq	r1, r2, r5, lsl r2
     e5c:	0d0c0000 	stceq	0, cr0, [ip, #-0]
     e60:	00000df1 	strdeq	r0, [r0], -r1
     e64:	43131601 	tstmi	r3, #1048576	; 0x100000
     e68:	1000000c 	andne	r0, r0, ip
     e6c:	000fb71c 	andeq	fp, pc, ip, lsl r7	; <UNPREDICTABLE>
     e70:	12170100 	andsne	r0, r7, #0, 2
     e74:	00000d51 	andeq	r0, r0, r1, asr sp
     e78:	00000052 	andeq	r0, r0, r2, asr r0
     e7c:	00000bb0 			; <UNDEFINED> instruction: 0x00000bb0
     e80:	00000bbb 			; <UNDEFINED> instruction: 0x00000bbb
     e84:	000c490f 	andeq	r4, ip, pc, lsl #18
     e88:	00521000 	subseq	r1, r2, r0
     e8c:	1c000000 	stcne	0, cr0, [r0], {-0}
     e90:	00000840 	andeq	r0, r0, r0, asr #16
     e94:	03121801 	tsteq	r2, #65536	; 0x10000
     e98:	52000011 	andpl	r0, r0, #17
     e9c:	d3000000 	movwle	r0, #0
     ea0:	de00000b 	cdple	0, 0, cr0, cr0, cr11, {0}
     ea4:	0f00000b 	svceq	0x0000000b
     ea8:	00000c49 	andeq	r0, r0, r9, asr #24
     eac:	00005210 	andeq	r5, r0, r0, lsl r2
     eb0:	5b120000 	blpl	480eb8 <__bss_end+0x474fb0>
     eb4:	0100000e 	tsteq	r0, lr
     eb8:	109d091b 	addsne	r0, sp, fp, lsl r9
     ebc:	0c490000 	mareq	acc0, r0, r9
     ec0:	f7010000 			; <UNDEFINED> instruction: 0xf7010000
     ec4:	fd00000b 	stc2	0, cr0, [r0, #-44]	; 0xffffffd4
     ec8:	0f00000b 	svceq	0x0000000b
     ecc:	00000c49 	andeq	r0, r0, r9, asr #24
     ed0:	0e7d1200 	cdpeq	2, 7, cr1, cr13, cr0, {0}
     ed4:	1c010000 	stcne	0, cr0, [r1], {-0}
     ed8:	00065a0f 	andeq	r5, r6, pc, lsl #20
     edc:	00083200 	andeq	r3, r8, r0, lsl #4
     ee0:	0c160100 	ldfeqs	f0, [r6], {-0}
     ee4:	0c210000 	stceq	0, cr0, [r1], #-0
     ee8:	490f0000 	stmdbmi	pc, {}	; <UNPREDICTABLE>
     eec:	1000000c 	andne	r0, r0, ip
     ef0:	00000052 	andeq	r0, r0, r2, asr r0
     ef4:	07a02b00 	streq	r2, [r0, r0, lsl #22]!
     ef8:	22010000 	andcs	r0, r1, #0
     efc:	0008260e 	andeq	r2, r8, lr, lsl #12
     f00:	0c320100 	ldfeqs	f0, [r2], #-0
     f04:	490f0000 	stmdbmi	pc, {}	; <UNPREDICTABLE>
     f08:	1000000c 	andne	r0, r0, ip
     f0c:	00000052 	andeq	r0, r0, r2, asr r0
     f10:	00036c10 	andeq	r6, r3, r0, lsl ip
     f14:	17000000 	strne	r0, [r0, -r0]
     f18:	00005204 	andeq	r5, r0, r4, lsl #4
     f1c:	4a041700 	bmi	106b24 <__bss_end+0xfac1c>
     f20:	1900000b 	stmdbne	r0, {r0, r1, r3}
     f24:	0000180f 	andeq	r1, r0, pc, lsl #16
     f28:	4a152501 	bmi	54a334 <__bss_end+0x53e42c>
     f2c:	0800000b 	stmdaeq	r0, {r0, r1, r3}
     f30:	00001222 	andeq	r1, r0, r2, lsr #4
     f34:	00380405 	eorseq	r0, r8, r5, lsl #8
     f38:	030b0000 	movweq	r0, #45056	; 0xb000
     f3c:	000c7a0c 	andeq	r7, ip, ip, lsl #20
     f40:	07a50900 	streq	r0, [r5, r0, lsl #18]!
     f44:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     f48:	000007ac 	andeq	r0, r0, ip, lsr #15
     f4c:	82080001 	andhi	r0, r8, #1
     f50:	05000004 	streq	r0, [r0, #-4]
     f54:	00003804 	andeq	r3, r0, r4, lsl #16
     f58:	0c090b00 			; <UNDEFINED> instruction: 0x0c090b00
     f5c:	00000cc7 	andeq	r0, r0, r7, asr #25
     f60:	0005432c 	andeq	r4, r5, ip, lsr #6
     f64:	2c04b000 	stccs	0, cr11, [r4], {-0}
     f68:	00000a5b 	andeq	r0, r0, fp, asr sl
     f6c:	262c0960 	strtcs	r0, [ip], -r0, ror #18
     f70:	c0000007 	andgt	r0, r0, r7
     f74:	08022c12 	stmdaeq	r2, {r1, r4, sl, fp, sp}
     f78:	25800000 	strcs	r0, [r0]
     f7c:	000c032c 	andeq	r0, ip, ip, lsr #6
     f80:	2c4b0000 	marcs	acc0, r0, fp
     f84:	00000d1a 	andeq	r0, r0, sl, lsl sp
     f88:	962c9600 	strtls	r9, [ip], -r0, lsl #12
     f8c:	0000000c 	andeq	r0, r0, ip
     f90:	12fe2de1 	rscsne	r2, lr, #14400	; 0x3840
     f94:	c2000000 	andgt	r0, r0, #0
     f98:	06000001 	streq	r0, [r0], -r1
     f9c:	000004c4 	andeq	r0, r0, r4, asr #9
     fa0:	08160b08 	ldmdaeq	r6, {r3, r8, r9, fp}
     fa4:	00000cef 	andeq	r0, r0, pc, ror #25
     fa8:	000f980d 	andeq	r9, pc, sp, lsl #16
     fac:	17180b00 	ldrne	r0, [r8, -r0, lsl #22]
     fb0:	00000c5b 	andeq	r0, r0, fp, asr ip
     fb4:	12870d00 	addne	r0, r7, #0, 26
     fb8:	190b0000 	stmdbne	fp, {}	; <UNPREDICTABLE>
     fbc:	000c7a15 	andeq	r7, ip, r5, lsl sl
     fc0:	2e000400 	cfcpyscs	mvf0, mvf0
     fc4:	40110b02 	andsmi	r0, r1, r2, lsl #22
     fc8:	06000008 	streq	r0, [r0], -r8
     fcc:	000011ea 	andeq	r1, r0, sl, ror #3
     fd0:	081c0230 	ldmdaeq	ip, {r4, r5, r9}
     fd4:	00000d8f 	andeq	r0, r0, pc, lsl #27
     fd8:	00047d0d 	andeq	r7, r4, sp, lsl #26
     fdc:	0c1e0200 	lfmeq	f0, 4, [lr], {-0}
     fe0:	00000d8f 	andeq	r0, r0, pc, lsl #27
     fe4:	00610700 	rsbeq	r0, r1, r0, lsl #14
     fe8:	8f121e02 	svchi	0x00121e02
     fec:	0800000d 	stmdaeq	r0, {r0, r2, r3}
     ff0:	02006207 	andeq	r6, r0, #1879048192	; 0x70000000
     ff4:	0d8f151e 	cfstr32eq	mvfx1, [pc, #120]	; 1074 <shift+0x1074>
     ff8:	07100000 	ldreq	r0, [r0, -r0]
     ffc:	1e020063 	cdpne	0, 0, cr0, cr2, cr3, {3}
    1000:	000d8f18 	andeq	r8, sp, r8, lsl pc
    1004:	64071800 	strvs	r1, [r7], #-2048	; 0xfffff800
    1008:	1b1e0200 	blne	781810 <__bss_end+0x775908>
    100c:	00000d8f 	andeq	r0, r0, pc, lsl #27
    1010:	00650720 	rsbeq	r0, r5, r0, lsr #14
    1014:	8f1e1e02 	svchi	0x001e1e02
    1018:	2800000d 	stmdacs	r0, {r0, r2, r3}
    101c:	0074622f 	rsbseq	r6, r4, pc, lsr #4
    1020:	370c2002 	strcc	r2, [ip, -r2]
    1024:	8f000010 	svchi	0x00000010
    1028:	5f00000d 	svcpl	0x0000000d
    102c:	6a00000d 	bvs	1068 <shift+0x1068>
    1030:	0f00000d 	svceq	0x0000000d
    1034:	00000d96 	muleq	r0, r6, sp
    1038:	000d8f10 	andeq	r8, sp, r0, lsl pc
    103c:	1e0e0000 	cdpne	0, 0, cr0, cr14, cr0, {0}
    1040:	02000007 	andeq	r0, r0, #7
    1044:	0a830c2a 	beq	fe0c40f4 <__bss_end+0xfe0b81ec>
    1048:	0d8f0000 	stceq	0, cr0, [pc]	; 1050 <shift+0x1050>
    104c:	0d7e0000 	ldcleq	0, cr0, [lr, #-0]
    1050:	960f0000 	strls	r0, [pc], -r0
    1054:	1000000d 	andne	r0, r0, sp
    1058:	00000d8f 	andeq	r0, r0, pc, lsl #27
    105c:	000d8f10 	andeq	r8, sp, r0, lsl pc
    1060:	02000000 	andeq	r0, r0, #0
    1064:	27340408 	ldrcs	r0, [r4, -r8, lsl #8]!
    1068:	04170000 	ldreq	r0, [r7], #-0
    106c:	00000cf7 	strdeq	r0, [r0], -r7
    1070:	000d9603 	andeq	r9, sp, r3, lsl #12
    1074:	11c83000 	bicne	r3, r8, r0
    1078:	83020000 	movwhi	r0, #8192	; 0x2000
    107c:	0a330601 	beq	cc2888 <__bss_end+0xcb6980>
    1080:	96280000 	strtls	r0, [r8], -r0
    1084:	00780000 	rsbseq	r0, r8, r0
    1088:	9c010000 	stcls	0, cr0, [r1], {-0}
    108c:	00000e03 	andeq	r0, r0, r3, lsl #28
    1090:	02007631 	andeq	r7, r0, #51380224	; 0x3100000
    1094:	961b0183 	ldrls	r0, [fp], -r3, lsl #3
    1098:	0200000d 	andeq	r0, r0, #13
    109c:	94326c91 	ldrtls	r6, [r2], #-3217	; 0xfffff36f
    10a0:	02000001 	andeq	r0, r0, #1
    10a4:	38240183 	stmdacc	r4!, {r0, r1, r7, r8}
    10a8:	02000000 	andeq	r0, r0, #0
    10ac:	65316891 	ldrvs	r6, [r1, #-2193]!	; 0xfffff76f
    10b0:	0200646e 	andeq	r6, r0, #1845493760	; 0x6e000000
    10b4:	382f0183 	stmdacc	pc!, {r0, r1, r7, r8}	; <UNPREDICTABLE>
    10b8:	02000000 	andeq	r0, r0, #0
    10bc:	50336491 	mlaspl	r3, r1, r4, r6
    10c0:	44000096 	strmi	r0, [r0], #-150	; 0xffffff6a
    10c4:	34000000 	strcc	r0, [r0], #-0
    10c8:	85020070 	strhi	r0, [r2, #-112]	; 0xffffff90
    10cc:	00380d01 	eorseq	r0, r8, r1, lsl #26
    10d0:	91020000 	mrsls	r0, (UNDEF: 2)
    10d4:	35000074 	strcc	r0, [r0, #-116]	; 0xffffff8c
    10d8:	00000a7e 	andeq	r0, r0, lr, ror sl
    10dc:	06017702 	streq	r7, [r1], -r2, lsl #14
    10e0:	000009e4 	andeq	r0, r0, r4, ror #19
    10e4:	00009524 	andeq	r9, r0, r4, lsr #10
    10e8:	00000104 	andeq	r0, r0, r4, lsl #2
    10ec:	0e609c01 	cdpeq	12, 6, cr9, cr0, cr1, {0}
    10f0:	61310000 	teqvs	r1, r0
    10f4:	02007272 	andeq	r7, r0, #536870919	; 0x20000007
    10f8:	96160177 			; <UNDEFINED> instruction: 0x96160177
    10fc:	0200000d 	andeq	r0, r0, #13
    1100:	e0324491 	mlas	r2, r1, r4, r4
    1104:	0200000f 	andeq	r0, r0, #15
    1108:	38210177 	stmdacc	r1!, {r0, r1, r2, r4, r5, r6, r8}
    110c:	02000000 	andeq	r0, r0, #0
    1110:	08324091 	ldmdaeq	r2!, {r0, r4, r7, lr}
    1114:	02000013 	andeq	r0, r0, #19
    1118:	382b0177 	stmdacc	fp!, {r0, r1, r2, r4, r5, r6, r8}
    111c:	03000000 	movweq	r0, #0
    1120:	367fbc91 			; <UNDEFINED> instruction: 0x367fbc91
    1124:	000017fb 	strdeq	r1, [r0], -fp
    1128:	10017802 	andne	r7, r1, r2, lsl #16
    112c:	00000cf7 	strdeq	r0, [r0], -r7
    1130:	00489102 	subeq	r9, r8, r2, lsl #2
    1134:	00087937 	andeq	r7, r8, r7, lsr r9
    1138:	01680200 	cmneq	r8, r0, lsl #4
    113c:	000bac05 	andeq	sl, fp, r5, lsl #24
    1140:	00003800 	andeq	r3, r0, r0, lsl #16
    1144:	00944400 	addseq	r4, r4, r0, lsl #8
    1148:	0000e000 	andeq	lr, r0, r0
    114c:	e49c0100 	ldr	r0, [ip], #256	; 0x100
    1150:	3100000e 	tstcc	r0, lr
    1154:	68020076 	stmdavs	r2, {r1, r2, r4, r5, r6}
    1158:	0d961a01 	vldreq	s2, [r6, #4]
    115c:	91020000 	mrsls	r0, (UNDEF: 2)
    1160:	01943264 	orrseq	r3, r4, r4, ror #4
    1164:	68020000 	stmdavs	r2, {}	; <UNPREDICTABLE>
    1168:	00382301 	eorseq	r2, r8, r1, lsl #6
    116c:	91020000 	mrsls	r0, (UNDEF: 2)
    1170:	6e653160 	powvssz	f3, f5, f0
    1174:	68020064 	stmdavs	r2, {r2, r5, r6}
    1178:	00382e01 	eorseq	r2, r8, r1, lsl #28
    117c:	91020000 	mrsls	r0, (UNDEF: 2)
    1180:	0735365c 			; <UNDEFINED> instruction: 0x0735365c
    1184:	6a020000 	bvs	8118c <__bss_end+0x75284>
    1188:	00380901 	eorseq	r0, r8, r1, lsl #18
    118c:	91020000 	mrsls	r0, (UNDEF: 2)
    1190:	006a346c 	rsbeq	r3, sl, ip, ror #8
    1194:	09016b02 	stmdbeq	r1, {r1, r8, r9, fp, sp, lr}
    1198:	00000038 	andeq	r0, r0, r8, lsr r0
    119c:	33749102 	cmncc	r4, #-2147483648	; 0x80000000
    11a0:	0000946c 	andeq	r9, r0, ip, ror #8
    11a4:	00000098 	muleq	r0, r8, r0
    11a8:	02006934 	andeq	r6, r0, #52, 18	; 0xd0000
    11ac:	380e016c 	stmdacc	lr, {r2, r3, r5, r6, r8}
    11b0:	02000000 	andeq	r0, r0, #0
    11b4:	00007091 	muleq	r0, r1, r0
    11b8:	00097d37 	andeq	r7, r9, r7, lsr sp
    11bc:	015d0200 	cmpeq	sp, r0, lsl #4
    11c0:	0007610e 	andeq	r6, r7, lr, lsl #2
    11c4:	00006300 	andeq	r6, r0, r0, lsl #6
    11c8:	00939000 	addseq	r9, r3, r0
    11cc:	0000b400 	andeq	fp, r0, r0, lsl #8
    11d0:	749c0100 	ldrvc	r0, [ip], #256	; 0x100
    11d4:	3200000f 	andcc	r0, r0, #15
    11d8:	00001312 	andeq	r1, r0, r2, lsl r3
    11dc:	1c015d02 	stcne	13, cr5, [r1], {2}
    11e0:	00000052 	andeq	r0, r0, r2, asr r0
    11e4:	325c9102 	subscc	r9, ip, #-2147483648	; 0x80000000
    11e8:	000004d7 	ldrdeq	r0, [r0], -r7
    11ec:	2b015d02 	blcs	585fc <__bss_end+0x4c6f4>
    11f0:	00000052 	andeq	r0, r0, r2, asr r0
    11f4:	32589102 	subscc	r9, r8, #-2147483648	; 0x80000000
    11f8:	0000080a 	andeq	r0, r0, sl, lsl #16
    11fc:	42015d02 	andmi	r5, r1, #2, 26	; 0x80
    1200:	00000052 	andeq	r0, r0, r2, asr r0
    1204:	36549102 	ldrbcc	r9, [r4], -r2, lsl #2
    1208:	00000e83 	andeq	r0, r0, r3, lsl #29
    120c:	0e015e02 	cdpeq	14, 0, cr5, cr1, cr2, {0}
    1210:	00000052 	andeq	r0, r0, r2, asr r0
    1214:	36749102 	ldrbtcc	r9, [r4], -r2, lsl #2
    1218:	00000695 	muleq	r0, r5, r6
    121c:	0e015f02 	cdpeq	15, 0, cr5, cr1, cr2, {0}
    1220:	00000052 	andeq	r0, r0, r2, asr r0
    1224:	34709102 	ldrbtcc	r9, [r0], #-258	; 0xfffffefe
    1228:	006d756e 	rsbeq	r7, sp, lr, ror #10
    122c:	0e016102 	adfeqs	f6, f1, f2
    1230:	00000052 	andeq	r0, r0, r2, asr r0
    1234:	36649102 	strbtcc	r9, [r4], -r2, lsl #2
    1238:	00000b98 	muleq	r0, r8, fp
    123c:	0c016302 	stceq	3, cr6, [r1], {2}
    1240:	00000d8f 	andeq	r0, r0, pc, lsl #27
    1244:	00689102 	rsbeq	r9, r8, r2, lsl #2
    1248:	0011e538 	andseq	lr, r1, r8, lsr r5
    124c:	01420200 	mrseq	r0, (UNDEF: 98)
    1250:	00003805 	andeq	r3, r0, r5, lsl #16
    1254:	00930c00 	addseq	r0, r3, r0, lsl #24
    1258:	00008400 	andeq	r8, r0, r0, lsl #8
    125c:	d09c0100 	addsle	r0, ip, r0, lsl #2
    1260:	3200000f 	andcc	r0, r0, #15
    1264:	00000cac 	andeq	r0, r0, ip, lsr #25
    1268:	0e014202 	cdpeq	2, 0, cr4, cr1, cr2, {0}
    126c:	00000038 	andeq	r0, r0, r8, lsr r0
    1270:	32649102 	rsbcc	r9, r4, #-2147483648	; 0x80000000
    1274:	00000d15 	andeq	r0, r0, r5, lsl sp
    1278:	1b014202 	blne	51a88 <__bss_end+0x45b80>
    127c:	00000fd0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1280:	36609102 	strbtcc	r9, [r0], -r2, lsl #2
    1284:	0000063c 	andeq	r0, r0, ip, lsr r6
    1288:	0e014302 	cdpeq	3, 0, cr4, cr1, cr2, {0}
    128c:	00000052 	andeq	r0, r0, r2, asr r0
    1290:	36749102 	ldrbtcc	r9, [r4], -r2, lsl #2
    1294:	00000ea1 	andeq	r0, r0, r1, lsr #29
    1298:	18014402 	stmdane	r1, {r1, sl, lr}
    129c:	00000cc7 	andeq	r0, r0, r7, asr #25
    12a0:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    12a4:	0fd60417 	svceq	0x00d60417
    12a8:	04170000 	ldreq	r0, [r7], #-0
    12ac:	00000025 	andeq	r0, r0, r5, lsr #32
    12b0:	00088339 	andeq	r8, r8, r9, lsr r3
    12b4:	05af0200 	streq	r0, [pc, #512]!	; 14bc <shift+0x14bc>
    12b8:	00000bf7 	strdeq	r0, [r0], -r7
    12bc:	00000038 	andeq	r0, r0, r8, lsr r0
    12c0:	00008660 	andeq	r8, r0, r0, ror #12
    12c4:	00000cac 	andeq	r0, r0, ip, lsr #25
    12c8:	11b69c01 			; <UNDEFINED> instruction: 0x11b69c01
    12cc:	123a0000 	eorsne	r0, sl, #0
    12d0:	02000013 	andeq	r0, r0, #19
    12d4:	005216af 	subseq	r1, r2, pc, lsr #13
    12d8:	91040000 	mrsls	r0, (UNDEF: 4)
    12dc:	3b7fb2d4 	blcc	1fede34 <__bss_end+0x1fe1f2c>
    12e0:	00000d34 	andeq	r0, r0, r4, lsr sp
    12e4:	3809b002 	stmdacc	r9, {r1, ip, sp, pc}
    12e8:	03000000 	movweq	r0, #0
    12ec:	3b7f9491 	blcc	1fe6538 <__bss_end+0x1fda630>
    12f0:	0000072e 	andeq	r0, r0, lr, lsr #14
    12f4:	3809b102 	stmdacc	r9, {r1, r8, ip, sp, pc}
    12f8:	03000000 	movweq	r0, #0
    12fc:	3b7f9091 	blcc	1fe5548 <__bss_end+0x1fd9640>
    1300:	000007b3 			; <UNDEFINED> instruction: 0x000007b3
    1304:	3809b202 	stmdacc	r9, {r1, r9, ip, sp, pc}
    1308:	03000000 	movweq	r0, #0
    130c:	3b7fbc91 	blcc	1ff0558 <__bss_end+0x1fe4650>
    1310:	00000590 	muleq	r0, r0, r5
    1314:	b60bb302 	strlt	fp, [fp], -r2, lsl #6
    1318:	03000011 	movweq	r0, #17
    131c:	3b7ddc91 	blcc	1f78568 <__bss_end+0x1f6c660>
    1320:	0000074c 	andeq	r0, r0, ip, asr #14
    1324:	3809b402 	stmdacc	r9, {r1, sl, ip, sp, pc}
    1328:	03000000 	movweq	r0, #0
    132c:	3b7fb891 	blcc	1fef578 <__bss_end+0x1fe3670>
    1330:	0000130d 	andeq	r1, r0, sp, lsl #6
    1334:	520eb602 	andpl	fp, lr, #2097152	; 0x200000
    1338:	03000000 	movweq	r0, #0
    133c:	3b7f9c91 	blcc	1fe8588 <__bss_end+0x1fdc680>
    1340:	00000ee4 	andeq	r0, r0, r4, ror #29
    1344:	d60bb802 	strle	fp, [fp], -r2, lsl #16
    1348:	0300000f 	movweq	r0, #15
    134c:	3b7f9891 	blcc	1fe7598 <__bss_end+0x1fdb690>
    1350:	00000ed6 	ldrdeq	r0, [r0], -r6
    1354:	3f0fcc02 	svccc	0x000fcc02
    1358:	03000000 	movweq	r0, #0
    135c:	3b7f8c91 	blcc	1fe45a8 <__bss_end+0x1fd86a0>
    1360:	0000067f 	andeq	r0, r0, pc, ror r6
    1364:	cd10ce02 	ldcgt	14, cr12, [r0, #-8]
    1368:	03000011 	movweq	r0, #17
    136c:	3c589891 	mrrccc	8, 9, r9, r8, cr1
    1370:	00008728 	andeq	r8, r0, r8, lsr #14
    1374:	000001ac 	andeq	r0, r0, ip, lsr #3
    1378:	000010b7 	strheq	r1, [r0], -r7
    137c:	0200693d 	andeq	r6, r0, #999424	; 0xf4000
    1380:	00380ed1 	ldrsbteq	r0, [r8], -r1
    1384:	91030000 	mrsls	r0, (UNDEF: 3)
    1388:	33007fb4 	movwcc	r7, #4020	; 0xfb4
    138c:	000088d4 	ldrdeq	r8, [r0], -r4
    1390:	00000a34 	andeq	r0, r0, r4, lsr sl
    1394:	0010923b 	andseq	r9, r0, fp, lsr r2
    1398:	0de20200 	sfmeq	f0, 2, [r2]
    139c:	00000038 	andeq	r0, r0, r8, lsr r0
    13a0:	7f889103 	svcvc	0x00889103
    13a4:	0089c033 	addeq	ip, r9, r3, lsr r0
    13a8:	00092400 	andeq	r2, r9, r0, lsl #8
    13ac:	0a6a3b00 	beq	1a8ffb4 <__bss_end+0x1a840ac>
    13b0:	f6020000 			; <UNDEFINED> instruction: 0xf6020000
    13b4:	0011c613 	andseq	ip, r1, r3, lsl r6
    13b8:	84910300 	ldrhi	r0, [r1], #768	; 0x300
    13bc:	8a20337f 	bhi	80e1c0 <__bss_end+0x8022b8>
    13c0:	088c0000 	stmeq	ip, {}	; <UNPREDICTABLE>
    13c4:	16360000 	ldrtne	r0, [r6], -r0
    13c8:	02000012 	andeq	r0, r0, #18
    13cc:	3f1b0107 	svccc	0x001b0107
    13d0:	03000000 	movweq	r0, #0
    13d4:	367f8091 			; <UNDEFINED> instruction: 0x367f8091
    13d8:	0000104c 	andeq	r1, r0, ip, asr #32
    13dc:	1c010802 	stcne	8, cr0, [r1], {2}
    13e0:	000011cd 	andeq	r1, r0, sp, asr #3
    13e4:	b2d89104 	sbcslt	r9, r8, #4, 2
    13e8:	0a63367f 	beq	18cedec <__bss_end+0x18c2ee4>
    13ec:	29020000 	stmdbcs	r2, {}	; <UNPREDICTABLE>
    13f0:	11c61701 	bicne	r1, r6, r1, lsl #14
    13f4:	91030000 	mrsls	r0, (UNDEF: 3)
    13f8:	343c7efc 	ldrtcc	r7, [ip], #-3836	; 0xfffff104
    13fc:	d000008a 	andle	r0, r0, sl, lsl #1
    1400:	42000000 	andmi	r0, r0, #0
    1404:	3d000011 	stccc	0, cr0, [r0, #-68]	; 0xffffffbc
    1408:	ff020069 			; <UNDEFINED> instruction: 0xff020069
    140c:	0000381a 	andeq	r3, r0, sl, lsl r8
    1410:	b0910300 	addslt	r0, r1, r0, lsl #6
    1414:	283c007f 	ldmdacs	ip!, {r0, r1, r2, r3, r4, r5, r6}
    1418:	9800008b 	stmdals	r0, {r0, r1, r3, r7}
    141c:	5f000000 	svcpl	0x00000000
    1420:	34000011 	strcc	r0, [r0], #-17	; 0xffffffef
    1424:	0a020078 	beq	8160c <__bss_end+0x75704>
    1428:	00381a01 	eorseq	r1, r8, r1, lsl #20
    142c:	91030000 	mrsls	r0, (UNDEF: 3)
    1430:	3c007fac 	stccc	15, cr7, [r0], {172}	; 0xac
    1434:	00008bc0 	andeq	r8, r0, r0, asr #23
    1438:	00000270 	andeq	r0, r0, r0, ror r2
    143c:	0000117c 	andeq	r1, r0, ip, ror r1
    1440:	02006934 	andeq	r6, r0, #52, 18	; 0xd0000
    1444:	381a010e 	ldmdacc	sl, {r1, r2, r3, r8}
    1448:	03000000 	movweq	r0, #0
    144c:	007fa891 			; <UNDEFINED> instruction: 0x007fa891
    1450:	008e303c 	addeq	r3, lr, ip, lsr r0
    1454:	00029000 	andeq	r9, r2, r0
    1458:	00119900 	andseq	r9, r1, r0, lsl #18
    145c:	006a3400 	rsbeq	r3, sl, r0, lsl #8
    1460:	1a011a02 	bne	47c70 <__bss_end+0x3bd68>
    1464:	00000038 	andeq	r0, r0, r8, lsr r0
    1468:	7fa49103 	svcvc	0x00a49103
    146c:	90c03300 	sbcls	r3, r0, r0, lsl #6
    1470:	01080000 	mrseq	r0, (UNDEF: 8)
    1474:	69340000 	ldmdbvs	r4!, {}	; <UNPREDICTABLE>
    1478:	01220200 			; <UNDEFINED> instruction: 0x01220200
    147c:	0000381a 	andeq	r3, r0, sl, lsl r8
    1480:	a0910300 	addsge	r0, r1, r0, lsl #6
    1484:	0000007f 	andeq	r0, r0, pc, ror r0
    1488:	c6150000 	ldrgt	r0, [r5], -r0
    148c:	c6000011 			; <UNDEFINED> instruction: 0xc6000011
    1490:	16000011 			; <UNDEFINED> instruction: 0x16000011
    1494:	00000063 	andeq	r0, r0, r3, rrx
    1498:	04020027 	streq	r0, [r2], #-39	; 0xffffffd9
    149c:	001dd904 	andseq	sp, sp, r4, lsl #18
    14a0:	0cf71500 	cfldr64eq	mvdx1, [r7]
    14a4:	11dd0000 	bicsne	r0, sp, r0
    14a8:	63160000 	tstvs	r6, #0
    14ac:	63000000 	movwvs	r0, #0
    14b0:	0e9b3e00 	cdpeq	14, 9, cr3, cr11, cr0, {0}
    14b4:	a2020000 	andge	r0, r2, #0
    14b8:	000cc006 	andeq	ip, ip, r6
    14bc:	00858800 	addeq	r8, r5, r0, lsl #16
    14c0:	0000d800 	andeq	sp, r0, r0, lsl #16
    14c4:	259c0100 	ldrcs	r0, [ip, #256]	; 0x100
    14c8:	3a000012 	bcc	1518 <shift+0x1518>
    14cc:	00001312 	andeq	r1, r0, r2, lsl r3
    14d0:	521ca202 	andspl	sl, ip, #536870912	; 0x20000000
    14d4:	02000000 	andeq	r0, r0, #0
    14d8:	4b3a6c91 	blmi	e9c724 <__bss_end+0xe9081c>
    14dc:	02000005 	andeq	r0, r0, #5
    14e0:	0cf72da2 	ldcleq	13, cr2, [r7], #648	; 0x288
    14e4:	91020000 	mrsls	r0, (UNDEF: 2)
    14e8:	0ee43a78 			; <UNDEFINED> instruction: 0x0ee43a78
    14ec:	a2020000 	andge	r0, r2, #0
    14f0:	000fd63f 	andeq	sp, pc, pc, lsr r6	; <UNPREDICTABLE>
    14f4:	28910200 	ldmcs	r1, {r9}
    14f8:	0dac3900 			; <UNDEFINED> instruction: 0x0dac3900
    14fc:	90020000 	andls	r0, r2, r0
    1500:	00105907 	andseq	r5, r0, r7, lsl #18
    1504:	0011c600 	andseq	ip, r1, r0, lsl #12
    1508:	00851800 	addeq	r1, r5, r0, lsl #16
    150c:	00007000 	andeq	r7, r0, r0
    1510:	629c0100 	addsvs	r0, ip, #0, 2
    1514:	3a000012 	bcc	1564 <shift+0x1564>
    1518:	00001312 	andeq	r1, r0, r2, lsl r3
    151c:	521b9002 	andspl	r9, fp, #2
    1520:	02000000 	andeq	r0, r0, #0
    1524:	e43a7491 	ldrt	r7, [sl], #-1169	; 0xfffffb6f
    1528:	0200000e 	andeq	r0, r0, #14
    152c:	0fd62790 	svceq	0x00d62790
    1530:	91020000 	mrsls	r0, (UNDEF: 2)
    1534:	b4390070 	ldrtlt	r0, [r9], #-112	; 0xffffff90
    1538:	0200000a 	andeq	r0, r0, #10
    153c:	0469057e 	strbteq	r0, [r9], #-1406	; 0xfffffa82
    1540:	00380000 	eorseq	r0, r8, r0
    1544:	84a80000 	strthi	r0, [r8], #0
    1548:	00700000 	rsbseq	r0, r0, r0
    154c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1550:	0000129f 	muleq	r0, pc, r2	; <UNPREDICTABLE>
    1554:	0013123a 	andseq	r1, r3, sl, lsr r2
    1558:	1b7e0200 	blne	1f81d60 <__bss_end+0x1f75e58>
    155c:	00000052 	andeq	r0, r0, r2, asr r0
    1560:	3a749102 	bcc	1d25970 <__bss_end+0x1d19a68>
    1564:	00000ee4 	andeq	r0, r0, r4, ror #29
    1568:	d6277e02 	strtle	r7, [r7], -r2, lsl #28
    156c:	0200000f 	andeq	r0, r0, #15
    1570:	3e007091 	mcrcc	0, 0, r7, cr0, cr1, {4}
    1574:	00000917 	andeq	r0, r0, r7, lsl r9
    1578:	f2066f02 	vmax.f32	d6, d6, d2
    157c:	4800000c 	stmdami	r0, {r2, r3}
    1580:	60000084 	andvs	r0, r0, r4, lsl #1
    1584:	01000000 	mrseq	r0, (UNDEF: 0)
    1588:	0013099c 	mulseq	r3, ip, r9
    158c:	13123a00 	tstne	r2, #0, 20
    1590:	6f020000 	svcvs	0x00020000
    1594:	00005226 	andeq	r5, r0, r6, lsr #4
    1598:	bc910300 	ldclt	3, cr0, [r1], {0}
    159c:	085b3a7f 	ldmdaeq	fp, {r0, r1, r2, r3, r4, r5, r6, r9, fp, ip, sp}^
    15a0:	6f020000 	svcvs	0x00020000
    15a4:	00037938 	andeq	r7, r3, r8, lsr r9
    15a8:	b8910300 	ldmlt	r1, {r8, r9}
    15ac:	0a6a3a7f 	beq	1a8ffb0 <__bss_end+0x1a840a8>
    15b0:	6f020000 	svcvs	0x00020000
    15b4:	0011c646 	andseq	ip, r1, r6, asr #12
    15b8:	b4910300 	ldrlt	r0, [r1], #768	; 0x300
    15bc:	0ca53a7f 	vstmiaeq	r5!, {s6-s132}
    15c0:	6f020000 	svcvs	0x00020000
    15c4:	00037959 	andeq	r7, r3, r9, asr r9
    15c8:	b0910300 	addslt	r0, r1, r0, lsl #6
    15cc:	0eea3b7f 			; <UNDEFINED> instruction: 0x0eea3b7f
    15d0:	70020000 	andvc	r0, r2, r0
    15d4:	0013090a 	andseq	r0, r3, sl, lsl #18
    15d8:	44910200 	ldrmi	r0, [r1], #512	; 0x200
    15dc:	00251500 	eoreq	r1, r5, r0, lsl #10
    15e0:	13190000 	tstne	r9, #0
    15e4:	63160000 	tstvs	r6, #0
    15e8:	31000000 	mrscc	r0, (UNDEF: 0)
    15ec:	0e683e00 	cdpeq	14, 6, cr3, cr8, cr0, {0}
    15f0:	60020000 	andvs	r0, r2, r0
    15f4:	000a1206 	andeq	r1, sl, r6, lsl #4
    15f8:	0083e400 	addeq	lr, r3, r0, lsl #8
    15fc:	00006400 	andeq	r6, r0, r0, lsl #8
    1600:	839c0100 	orrshi	r0, ip, #0, 2
    1604:	3a000013 	bcc	1658 <shift+0x1658>
    1608:	00001312 	andeq	r1, r0, r2, lsl r3
    160c:	52246002 	eorpl	r6, r4, #2
    1610:	03000000 	movweq	r0, #0
    1614:	3a7fbc91 	bcc	1ff0860 <__bss_end+0x1fe4958>
    1618:	0000085b 	andeq	r0, r0, fp, asr r8
    161c:	79366002 	ldmdbvc	r6!, {r1, sp, lr}
    1620:	03000003 	movweq	r0, #3
    1624:	3a7fb891 	bcc	1fef870 <__bss_end+0x1fe3968>
    1628:	00000a6a 	andeq	r0, r0, sl, ror #20
    162c:	38426002 	stmdacc	r2, {r1, sp, lr}^
    1630:	03000000 	movweq	r0, #0
    1634:	3a7fb491 	bcc	1fee880 <__bss_end+0x1fe2978>
    1638:	00000ca5 	andeq	r0, r0, r5, lsr #25
    163c:	79556002 	ldmdbvc	r5, {r1, sp, lr}^
    1640:	03000003 	movweq	r0, #3
    1644:	3b7fb091 	blcc	1fed890 <__bss_end+0x1fe1988>
    1648:	00000eea 	andeq	r0, r0, sl, ror #29
    164c:	090a6102 	stmdbeq	sl, {r1, r8, sp, lr}
    1650:	02000013 	andeq	r0, r0, #19
    1654:	3e004491 	mcrcc	4, 0, r4, cr0, cr1, {4}
    1658:	000009b4 			; <UNDEFINED> instruction: 0x000009b4
    165c:	21064102 	tstcs	r6, r2, lsl #2
    1660:	dc00000e 	stcle	0, cr0, [r0], {14}
    1664:	08000082 	stmdaeq	r0, {r1, r7}
    1668:	01000001 	tsteq	r0, r1
    166c:	00141e9c 	mulseq	r4, ip, lr
    1670:	13123a00 	tstne	r2, #0, 20
    1674:	41020000 	mrsmi	r0, (UNDEF: 2)
    1678:	0000521b 	andeq	r5, r0, fp, lsl r2
    167c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1680:	000eea3a 	andeq	lr, lr, sl, lsr sl
    1684:	27410200 	strbcs	r0, [r1, -r0, lsl #4]
    1688:	00000fd6 	ldrdeq	r0, [r0], -r6
    168c:	3d609102 	stfccp	f1, [r0, #-8]!
    1690:	00667562 	rsbeq	r7, r6, r2, ror #10
    1694:	d60b4202 	strle	r4, [fp], -r2, lsl #4
    1698:	0200000f 	andeq	r0, r0, #15
    169c:	ba3f7091 	blt	fdd8e8 <__bss_end+0xfd19e0>
    16a0:	02000009 	andeq	r0, r0, #9
    16a4:	0d8f0c44 	stceq	12, cr0, [pc, #272]	; 17bc <shift+0x17bc>
    16a8:	2c330000 	ldccs	0, cr0, [r3], #-0
    16ac:	7c000083 	stcvc	0, cr0, [r0], {131}	; 0x83
    16b0:	3d000000 	stccc	0, cr0, [r0, #-0]
    16b4:	4c020069 	stcmi	0, cr0, [r2], {105}	; 0x69
    16b8:	00003811 	andeq	r3, r0, r1, lsl r8
    16bc:	6c910200 	lfmvs	f0, 4, [r1], {0}
    16c0:	00834433 	addeq	r4, r3, r3, lsr r4
    16c4:	00004c00 	andeq	r4, r0, r0, lsl #24
    16c8:	00783d00 	rsbseq	r3, r8, r0, lsl #26
    16cc:	38164d02 	ldmdacc	r6, {r1, r8, sl, fp, lr}
    16d0:	02000000 	andeq	r0, r0, #0
    16d4:	5c337491 	cfldrspl	mvf7, [r3], #-580	; 0xfffffdbc
    16d8:	24000083 	strcs	r0, [r0], #-131	; 0xffffff7d
    16dc:	3d000000 	stccc	0, cr0, [r0, #-0]
    16e0:	0074756f 	rsbseq	r7, r4, pc, ror #10
    16e4:	25164e02 	ldrcs	r4, [r6, #-3586]	; 0xfffff1fe
    16e8:	02000000 	andeq	r0, r0, #0
    16ec:	00006b91 	muleq	r0, r1, fp
    16f0:	b1400000 	mrslt	r0, (UNDEF: 64)
    16f4:	0200000c 	andeq	r0, r0, #12
    16f8:	82a40d38 	adchi	r0, r4, #56, 26	; 0xe00
    16fc:	00380000 	eorseq	r0, r8, r0
    1700:	9c010000 	stcls	0, cr0, [r1], {-0}
    1704:	00001462 	andeq	r1, r0, r2, ror #8
    1708:	0013123a 	andseq	r1, r3, sl, lsr r2
    170c:	1c380200 	lfmne	f0, 4, [r8], #-0
    1710:	00000052 	andeq	r0, r0, r2, asr r0
    1714:	41749102 	cmnmi	r4, r2, lsl #2
    1718:	00667562 	rsbeq	r7, r6, r2, ror #10
    171c:	d6283802 	strtle	r3, [r8], -r2, lsl #16
    1720:	0200000f 	andeq	r0, r0, #15
    1724:	603a7091 	mlasvs	sl, r1, r0, r7
    1728:	02000016 	andeq	r0, r0, #22
    172c:	00383138 	eorseq	r3, r8, r8, lsr r1
    1730:	91020000 	mrsls	r0, (UNDEF: 2)
    1734:	4640006c 	strbmi	r0, [r0], -ip, rrx
    1738:	02000006 	andeq	r0, r0, #6
    173c:	82680d34 	rsbhi	r0, r8, #52, 26	; 0xd00
    1740:	003c0000 	eorseq	r0, ip, r0
    1744:	9c010000 	stcls	0, cr0, [r1], {-0}
    1748:	00001497 	muleq	r0, r7, r4
    174c:	0013123a 	andseq	r1, r3, sl, lsr r2
    1750:	1c340200 	lfmne	f0, 4, [r4], #-0
    1754:	00000052 	andeq	r0, r0, r2, asr r0
    1758:	3a749102 	bcc	1d25b68 <__bss_end+0x1d19c60>
    175c:	000009c0 	andeq	r0, r0, r0, asr #19
    1760:	792e3402 	stmdbvc	lr!, {r1, sl, ip, sp}
    1764:	02000003 	andeq	r0, r0, #3
    1768:	42007091 	andmi	r7, r0, #145	; 0x91
    176c:	00000d6a 	andeq	r0, r0, sl, ror #26
    1770:	000014ae 	andeq	r1, r0, lr, lsr #9
    1774:	00009740 	andeq	r9, r0, r0, asr #14
    1778:	000000bc 	strheq	r0, [r0], -ip
    177c:	14e89c01 	strbtne	r9, [r8], #3073	; 0xc01
    1780:	01430000 	mrseq	r0, (UNDEF: 67)
    1784:	9c000012 	stcls	0, cr0, [r0], {18}
    1788:	0200000d 	andeq	r0, r0, #13
    178c:	2e3a5c91 	mrccs	12, 1, r5, cr10, cr1, {4}
    1790:	02000007 	andeq	r0, r0, #7
    1794:	0d8f1b2a 	vstreq	d1, [pc, #168]	; 1844 <shift+0x1844>
    1798:	91020000 	mrsls	r0, (UNDEF: 2)
    179c:	12063a50 	andne	r3, r6, #80, 20	; 0x50000
    17a0:	2a020000 	bcs	817a8 <__bss_end+0x758a0>
    17a4:	000d8f2a 	andeq	r8, sp, sl, lsr #30
    17a8:	48910200 	ldmmi	r1, {r9}
    17ac:	736e613d 	cmnvc	lr, #1073741839	; 0x4000000f
    17b0:	102c0200 	eorne	r0, ip, r0, lsl #4
    17b4:	00000d8f 	andeq	r0, r0, pc, lsl #27
    17b8:	00609102 	rsbeq	r9, r0, r2, lsl #2
    17bc:	000d4844 	andeq	r4, sp, r4, asr #16
    17c0:	0014ff00 	andseq	pc, r4, r0, lsl #30
    17c4:	0096d000 	addseq	sp, r6, r0
    17c8:	00007000 	andeq	r7, r0, r0
    17cc:	199c0100 	ldmibne	ip, {r8}
    17d0:	43000015 	movwmi	r0, #21
    17d4:	00001201 	andeq	r1, r0, r1, lsl #4
    17d8:	00000d9c 	muleq	r0, ip, sp
    17dc:	41749102 	cmnmi	r4, r2, lsl #2
    17e0:	20020079 	andcs	r0, r2, r9, ror r0
    17e4:	000d8f16 	andeq	r8, sp, r6, lsl pc
    17e8:	68910200 	ldmvs	r1, {r9}
    17ec:	62614500 	rsbvs	r4, r1, #0, 10
    17f0:	15020073 	strne	r0, [r2, #-115]	; 0xffffff8d
    17f4:	000db708 	andeq	fp, sp, r8, lsl #14
    17f8:	000d8f00 	andeq	r8, sp, r0, lsl #30
    17fc:	00822800 	addeq	r2, r2, r0, lsl #16
    1800:	00004000 	andeq	r4, r0, r0
    1804:	459c0100 	ldrmi	r0, [ip, #256]	; 0x100
    1808:	41000015 	tstmi	r0, r5, lsl r0
    180c:	15020078 	strne	r0, [r2, #-120]	; 0xffffff88
    1810:	000d8f13 	andeq	r8, sp, r3, lsl pc
    1814:	70910200 	addsvc	r0, r1, r0, lsl #4
    1818:	11724600 	cmnne	r2, r0, lsl #12
    181c:	2c010000 	stccs	0, cr0, [r1], {-0}
    1820:	000b1b0e 	andeq	r1, fp, lr, lsl #22
    1824:	00083200 	andeq	r3, r8, r0, lsl #4
    1828:	0096a000 	addseq	sl, r6, r0
    182c:	00003000 	andeq	r3, r0, r0
    1830:	3a9c0100 	bcc	fe701c38 <__bss_end+0xfe6f5d30>
    1834:	00001660 	andeq	r1, r0, r0, ror #12
    1838:	52262c01 	eorpl	r2, r6, #256	; 0x100
    183c:	02000000 	andeq	r0, r0, #0
    1840:	00007491 	muleq	r0, r1, r4
    1844:	00000348 	andeq	r0, r0, r8, asr #6
    1848:	06900004 	ldreq	r0, [r0], r4
    184c:	01040000 	mrseq	r0, (UNDEF: 4)
    1850:	0000137d 	andeq	r1, r0, sp, ror r3
    1854:	00134104 	andseq	r4, r3, r4, lsl #2
    1858:	00148900 	andseq	r8, r4, r0, lsl #18
    185c:	0097fc00 	addseq	pc, r7, r0, lsl #24
    1860:	0002a400 	andeq	sl, r2, r0, lsl #8
    1864:	00099b00 	andeq	r9, r9, r0, lsl #22
    1868:	08010200 	stmdaeq	r1, {r9}
    186c:	0000108d 	andeq	r1, r0, sp, lsl #1
    1870:	e7050202 	str	r0, [r5, -r2, lsl #4]
    1874:	0300000d 	movweq	r0, #13
    1878:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    187c:	33040074 	movwcc	r0, #16500	; 0x4074
    1880:	02000000 	andeq	r0, r0, #0
    1884:	10840801 	addne	r0, r4, r1, lsl #16
    1888:	02020000 	andeq	r0, r2, #0
    188c:	0011d207 	andseq	sp, r1, r7, lsl #4
    1890:	07040200 	streq	r0, [r4, -r0, lsl #4]
    1894:	00001f8e 	andeq	r1, r0, lr, lsl #31
    1898:	000d2305 	andeq	r2, sp, r5, lsl #6
    189c:	0b040200 	bleq	1020a4 <__bss_end+0xf619c>
    18a0:	0000006f 	andeq	r0, r0, pc, rrx
    18a4:	000a4f06 	andeq	r4, sl, r6, lsl #30
    18a8:	0f060200 	svceq	0x00060200
    18ac:	0000003a 	andeq	r0, r0, sl, lsr r0
    18b0:	07000100 	streq	r0, [r0, -r0, lsl #2]
    18b4:	00000060 	andeq	r0, r0, r0, rrx
    18b8:	0014c508 	andseq	ip, r4, r8, lsl #10
    18bc:	02010c00 	andeq	r0, r1, #0, 24
    18c0:	016d0709 	cmneq	sp, r9, lsl #14
    18c4:	69090000 	stmdbvs	r9, {}	; <UNPREDICTABLE>
    18c8:	0200000b 	andeq	r0, r0, #11
    18cc:	016d330c 	cmneq	sp, ip, lsl #6
    18d0:	0a000000 	beq	18d8 <shift+0x18d8>
    18d4:	00000a09 	andeq	r0, r0, r9, lsl #20
    18d8:	7d0e0d02 	stcvc	13, cr0, [lr, #-8]
    18dc:	00000001 	andeq	r0, r0, r1
    18e0:	10dc0a01 	sbcsne	r0, ip, r1, lsl #20
    18e4:	0f020000 	svceq	0x00020000
    18e8:	0000330d 	andeq	r3, r0, sp, lsl #6
    18ec:	0a010400 	beq	428f4 <__bss_end+0x369ec>
    18f0:	00000cb7 			; <UNDEFINED> instruction: 0x00000cb7
    18f4:	330d1002 	movwcc	r1, #53250	; 0xd002
    18f8:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    18fc:	14c50b01 	strbne	r0, [r5], #2817	; 0xb01
    1900:	13020000 	movwne	r0, #8192	; 0x2000
    1904:	000e3409 	andeq	r3, lr, r9, lsl #8
    1908:	00018400 	andeq	r8, r1, r0, lsl #8
    190c:	00d20100 	sbcseq	r0, r2, r0, lsl #2
    1910:	00d80000 	sbcseq	r0, r8, r0
    1914:	840c0000 	strhi	r0, [ip], #-0
    1918:	00000001 	andeq	r0, r0, r1
    191c:	0009110b 	andeq	r1, r9, fp, lsl #2
    1920:	0e150200 	cdpeq	2, 1, cr0, cr5, cr0, {0}
    1924:	000005f6 	strdeq	r0, [r0], -r6
    1928:	0000017d 	andeq	r0, r0, sp, ror r1
    192c:	0000f101 	andeq	pc, r0, r1, lsl #2
    1930:	0000f700 	andeq	pc, r0, r0, lsl #14
    1934:	01840c00 	orreq	r0, r4, r0, lsl #24
    1938:	0d000000 	stceq	0, cr0, [r0, #-0]
    193c:	000004ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1940:	5c0e1702 	stcpl	7, cr1, [lr], {2}
    1944:	01000012 	tsteq	r0, r2, lsl r0
    1948:	0000010c 	andeq	r0, r0, ip, lsl #2
    194c:	00000112 	andeq	r0, r0, r2, lsl r1
    1950:	0001840c 	andeq	r8, r1, ip, lsl #8
    1954:	930d0000 	movwls	r0, #53248	; 0xd000
    1958:	0200000f 	andeq	r0, r0, #15
    195c:	0e090e19 	mcreq	14, 0, r0, cr9, cr9, {0}
    1960:	27010000 	strcs	r0, [r1, -r0]
    1964:	32000001 	andcc	r0, r0, #1
    1968:	0c000001 	stceq	0, cr0, [r0], {1}
    196c:	00000184 	andeq	r0, r0, r4, lsl #3
    1970:	0000250e 	andeq	r2, r0, lr, lsl #10
    1974:	740b0000 	strvc	r0, [fp], #-0
    1978:	02000008 	andeq	r0, r0, #8
    197c:	0eb30e1b 	mrceq	14, 5, r0, cr3, cr11, {0}
    1980:	00250000 	eoreq	r0, r5, r0
    1984:	4b010000 	blmi	4198c <__bss_end+0x35a84>
    1988:	51000001 	tstpl	r0, r1
    198c:	0c000001 	stceq	0, cr0, [r0], {1}
    1990:	00000184 	andeq	r0, r0, r4, lsl #3
    1994:	12340f00 	eorsne	r0, r4, #0, 30
    1998:	1d020000 	stcne	0, cr0, [r2, #-0]
    199c:	0005180d 	andeq	r1, r5, sp, lsl #16
    19a0:	00003300 	andeq	r3, r0, r0, lsl #6
    19a4:	01660100 	cmneq	r6, r0, lsl #2
    19a8:	840c0000 	strhi	r0, [ip], #-0
    19ac:	00000001 	andeq	r0, r0, r1
    19b0:	00251000 	eoreq	r1, r5, r0
    19b4:	017d0000 	cmneq	sp, r0
    19b8:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    19bc:	ff000000 			; <UNDEFINED> instruction: 0xff000000
    19c0:	02010200 	andeq	r0, r1, #0, 4
    19c4:	00000b21 	andeq	r0, r0, r1, lsr #22
    19c8:	00740412 	rsbseq	r0, r4, r2, lsl r4
    19cc:	84040000 	strhi	r0, [r4], #-0
    19d0:	13000001 	movwne	r0, #1
    19d4:	000014c1 	andeq	r1, r0, r1, asr #9
    19d8:	740f2002 	strvc	r2, [pc], #-2	; 19e0 <shift+0x19e0>
    19dc:	14000000 	strne	r0, [r0], #-0
    19e0:	0000018f 	andeq	r0, r0, pc, lsl #3
    19e4:	05080301 	streq	r0, [r8, #-769]	; 0xfffffcff
    19e8:	00bdd803 	adcseq	sp, sp, r3, lsl #16
    19ec:	14b21500 	ldrtne	r1, [r2], #1280	; 0x500
    19f0:	9a840000 	bls	fe1019f8 <__bss_end+0xfe0f5af0>
    19f4:	001c0000 	andseq	r0, ip, r0
    19f8:	9c010000 	stcls	0, cr0, [r1], {-0}
    19fc:	00131716 	andseq	r1, r3, r6, lsl r7
    1a00:	009a3800 	addseq	r3, sl, r0, lsl #16
    1a04:	00004c00 	andeq	r4, r0, r0, lsl #24
    1a08:	ea9c0100 	b	fe701e10 <__bss_end+0xfe6f5f08>
    1a0c:	17000001 	strne	r0, [r0, -r1]
    1a10:	0000146b 	andeq	r1, r0, fp, ror #8
    1a14:	33013401 	movwcc	r3, #5121	; 0x1401
    1a18:	02000000 	andeq	r0, r0, #0
    1a1c:	60177491 	mulsvs	r7, r1, r4
    1a20:	01000014 	tsteq	r0, r4, lsl r0
    1a24:	00330134 	eorseq	r0, r3, r4, lsr r1
    1a28:	91020000 	mrsls	r0, (UNDEF: 2)
    1a2c:	32180070 	andscc	r0, r8, #112	; 0x70
    1a30:	01000001 	tsteq	r0, r1
    1a34:	0204062c 	andeq	r0, r4, #44, 12	; 0x2c00000
    1a38:	99bc0000 	ldmibls	ip!, {}	; <UNPREDICTABLE>
    1a3c:	007c0000 	rsbseq	r0, ip, r0
    1a40:	9c010000 	stcls	0, cr0, [r1], {-0}
    1a44:	00000220 	andeq	r0, r0, r0, lsr #4
    1a48:	00120119 	andseq	r0, r2, r9, lsl r1
    1a4c:	00018a00 	andeq	r8, r1, r0, lsl #20
    1a50:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1a54:	7465721a 	strbtvc	r7, [r5], #-538	; 0xfffffde6
    1a58:	0a300100 	beq	c01e60 <__bss_end+0xbf5f58>
    1a5c:	00000025 	andeq	r0, r0, r5, lsr #32
    1a60:	00779102 	rsbseq	r9, r7, r2, lsl #2
    1a64:	00011218 	andeq	r1, r1, r8, lsl r2
    1a68:	06260100 	strteq	r0, [r6], -r0, lsl #2
    1a6c:	0000023a 	andeq	r0, r0, sl, lsr r2
    1a70:	0000995c 	andeq	r9, r0, ip, asr r9
    1a74:	00000060 	andeq	r0, r0, r0, rrx
    1a78:	02549c01 	subseq	r9, r4, #256	; 0x100
    1a7c:	01190000 	tsteq	r9, r0
    1a80:	8a000012 	bhi	1ad0 <shift+0x1ad0>
    1a84:	02000001 	andeq	r0, r0, #1
    1a88:	631b7491 	tstvs	fp, #-1862270976	; 0x91000000
    1a8c:	18260100 	stmdane	r6!, {r8}
    1a90:	00000025 	andeq	r0, r0, r5, lsr #32
    1a94:	00739102 	rsbseq	r9, r3, r2, lsl #2
    1a98:	00015118 	andeq	r5, r1, r8, lsl r1
    1a9c:	05210100 	streq	r0, [r1, #-256]!	; 0xffffff00
    1aa0:	0000026e 	andeq	r0, r0, lr, ror #4
    1aa4:	00009928 	andeq	r9, r0, r8, lsr #18
    1aa8:	00000034 	andeq	r0, r0, r4, lsr r0
    1aac:	027b9c01 	rsbseq	r9, fp, #256	; 0x100
    1ab0:	01190000 	tsteq	r9, r0
    1ab4:	8a000012 	bhi	1b04 <shift+0x1b04>
    1ab8:	02000001 	andeq	r0, r0, #1
    1abc:	1c007491 	cfstrsne	mvf7, [r0], {145}	; 0x91
    1ac0:	000000f7 	strdeq	r0, [r0], -r7
    1ac4:	02940601 	addseq	r0, r4, #1048576	; 0x100000
    1ac8:	98c40000 	stmials	r4, {}^	; <UNPREDICTABLE>
    1acc:	00640000 	rsbeq	r0, r4, r0
    1ad0:	9c010000 	stcls	0, cr0, [r1], {-0}
    1ad4:	000002b8 			; <UNDEFINED> instruction: 0x000002b8
    1ad8:	00120119 	andseq	r0, r2, r9, lsl r1
    1adc:	00018a00 	andeq	r8, r1, r0, lsl #20
    1ae0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1ae4:	0098d41d 	addseq	sp, r8, sp, lsl r4
    1ae8:	00003800 	andeq	r3, r0, r0, lsl #16
    1aec:	00691a00 	rsbeq	r1, r9, r0, lsl #20
    1af0:	330d1901 	movwcc	r1, #55553	; 0xd901
    1af4:	02000000 	andeq	r0, r0, #0
    1af8:	00007491 	muleq	r0, r1, r4
    1afc:	0000d818 	andeq	sp, r0, r8, lsl r8
    1b00:	060e0100 	streq	r0, [lr], -r0, lsl #2
    1b04:	000002d2 	ldrdeq	r0, [r0], -r2
    1b08:	0000987c 	andeq	r9, r0, ip, ror r8
    1b0c:	00000048 	andeq	r0, r0, r8, asr #32
    1b10:	02df9c01 	sbcseq	r9, pc, #256	; 0x100
    1b14:	01190000 	tsteq	r9, r0
    1b18:	8a000012 	bhi	1b68 <shift+0x1b68>
    1b1c:	02000001 	andeq	r0, r0, #1
    1b20:	1e007491 	mcrne	4, 0, r7, cr0, cr1, {4}
    1b24:	000000b9 	strheq	r0, [r0], -r9
    1b28:	f0010501 			; <UNDEFINED> instruction: 0xf0010501
    1b2c:	00000002 	andeq	r0, r0, r2
    1b30:	00000306 	andeq	r0, r0, r6, lsl #6
    1b34:	0012011f 	andseq	r0, r2, pc, lsl r1
    1b38:	00018a00 	andeq	r8, r1, r0, lsl #20
    1b3c:	69212000 	stmdbvs	r1!, {sp}
    1b40:	0d080100 	stfeqs	f0, [r8, #-0]
    1b44:	00000033 	andeq	r0, r0, r3, lsr r0
    1b48:	df220000 	svcle	0x00220000
    1b4c:	7a000002 	bvc	1b5c <shift+0x1b5c>
    1b50:	1d000014 	stcne	0, cr0, [r0, #-80]	; 0xffffffb0
    1b54:	fc000003 	stc2	0, cr0, [r0], {3}
    1b58:	80000097 	mulhi	r0, r7, r0
    1b5c:	01000000 	mrseq	r0, (UNDEF: 0)
    1b60:	02f0239c 	rscseq	r2, r0, #156, 6	; 0x70000002
    1b64:	91020000 	mrsls	r0, (UNDEF: 2)
    1b68:	02f9246c 	rscseq	r2, r9, #108, 8	; 0x6c000000
    1b6c:	03340000 	teqeq	r4, #0
    1b70:	fa250000 	blx	941b78 <__bss_end+0x935c70>
    1b74:	00000002 	andeq	r0, r0, r2
    1b78:	0002f926 	andeq	pc, r2, r6, lsr #18
    1b7c:	00983000 	addseq	r3, r8, r0
    1b80:	00003800 	andeq	r3, r0, r0, lsl #16
    1b84:	02fa2700 	rscseq	r2, sl, #0, 14
    1b88:	91020000 	mrsls	r0, (UNDEF: 2)
    1b8c:	00000074 	andeq	r0, r0, r4, ror r0
    1b90:	00000d17 	andeq	r0, r0, r7, lsl sp
    1b94:	08cb0004 	stmiaeq	fp, {r2}^
    1b98:	01040000 	mrseq	r0, (UNDEF: 4)
    1b9c:	0000137d 	andeq	r1, r0, sp, ror r3
    1ba0:	00175104 	andseq	r5, r7, r4, lsl #2
    1ba4:	00148900 	andseq	r8, r4, r0, lsl #18
    1ba8:	009aa000 	addseq	sl, sl, r0
    1bac:	00048c00 	andeq	r8, r4, r0, lsl #24
    1bb0:	000af200 	andeq	pc, sl, r0, lsl #4
    1bb4:	08010200 	stmdaeq	r1, {r9}
    1bb8:	0000108d 	andeq	r1, r0, sp, lsl #1
    1bbc:	00002503 	andeq	r2, r0, r3, lsl #10
    1bc0:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    1bc4:	00000de7 	andeq	r0, r0, r7, ror #27
    1bc8:	69050404 	stmdbvs	r5, {r2, sl}
    1bcc:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    1bd0:	10840801 	addne	r0, r4, r1, lsl #16
    1bd4:	02020000 	andeq	r0, r2, #0
    1bd8:	0011d207 	andseq	sp, r1, r7, lsl #4
    1bdc:	07150500 	ldreq	r0, [r5, -r0, lsl #10]
    1be0:	09070000 	stmdbeq	r7, {}	; <UNPREDICTABLE>
    1be4:	00005e1e 	andeq	r5, r0, lr, lsl lr
    1be8:	004d0300 	subeq	r0, sp, r0, lsl #6
    1bec:	04020000 	streq	r0, [r2], #-0
    1bf0:	001f8e07 	andseq	r8, pc, r7, lsl #28
    1bf4:	12f20600 	rscsne	r0, r2, #0, 12
    1bf8:	02080000 	andeq	r0, r8, #0
    1bfc:	008b0806 	addeq	r0, fp, r6, lsl #16
    1c00:	72070000 	andvc	r0, r7, #0
    1c04:	08020030 	stmdaeq	r2, {r4, r5}
    1c08:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1c0c:	72070000 	andvc	r0, r7, #0
    1c10:	09020031 	stmdbeq	r2, {r0, r4, r5}
    1c14:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1c18:	08000400 	stmdaeq	r0, {sl}
    1c1c:	000016e9 	andeq	r1, r0, r9, ror #13
    1c20:	00380405 	eorseq	r0, r8, r5, lsl #8
    1c24:	0d020000 	stceq	0, cr0, [r2, #-0]
    1c28:	0000a90c 	andeq	sl, r0, ip, lsl #18
    1c2c:	4b4f0900 	blmi	13c4034 <__bss_end+0x13b812c>
    1c30:	3d0a0000 	stccc	0, cr0, [sl, #-0]
    1c34:	01000015 	tsteq	r0, r5, lsl r0
    1c38:	0f130800 	svceq	0x00130800
    1c3c:	04050000 	streq	r0, [r5], #-0
    1c40:	00000038 	andeq	r0, r0, r8, lsr r0
    1c44:	f20c1e02 	vceq.f32	d1, d12, d2
    1c48:	0a000000 	beq	1c50 <shift+0x1c50>
    1c4c:	0000070d 	andeq	r0, r0, sp, lsl #14
    1c50:	09730a00 	ldmdbeq	r3!, {r9, fp}^
    1c54:	0a010000 	beq	41c5c <__bss_end+0x35d54>
    1c58:	00000f35 	andeq	r0, r0, r5, lsr pc
    1c5c:	10c10a02 	sbcne	r0, r1, r2, lsl #20
    1c60:	0a030000 	beq	c1c68 <__bss_end+0xb5d60>
    1c64:	000008fc 	strdeq	r0, [r0], -ip
    1c68:	0dbf0a04 			; <UNDEFINED> instruction: 0x0dbf0a04
    1c6c:	0a050000 	beq	141c74 <__bss_end+0x135d6c>
    1c70:	00000453 	andeq	r0, r0, r3, asr r4
    1c74:	07c20a06 	strbeq	r0, [r2, r6, lsl #20]
    1c78:	0a070000 	beq	1c1c80 <__bss_end+0x1b5d78>
    1c7c:	0000044e 	andeq	r0, r0, lr, asr #8
    1c80:	fb080008 	blx	201caa <__bss_end+0x1f5da2>
    1c84:	0500000e 	streq	r0, [r0, #-14]
    1c88:	00003804 	andeq	r3, r0, r4, lsl #16
    1c8c:	0c4a0200 	sfmeq	f0, 2, [sl], {-0}
    1c90:	0000012f 	andeq	r0, r0, pc, lsr #2
    1c94:	0008150a 	andeq	r1, r8, sl, lsl #10
    1c98:	6e0a0000 	cdpvs	0, 0, cr0, cr10, cr0, {0}
    1c9c:	01000009 	tsteq	r0, r9
    1ca0:	0012810a 	andseq	r8, r2, sl, lsl #2
    1ca4:	600a0200 	andvs	r0, sl, r0, lsl #4
    1ca8:	0300000c 	movweq	r0, #12
    1cac:	00090b0a 	andeq	r0, r9, sl, lsl #22
    1cb0:	fb0a0400 	blx	282cba <__bss_end+0x276db2>
    1cb4:	05000009 	streq	r0, [r0, #-9]
    1cb8:	00075c0a 	andeq	r5, r7, sl, lsl #24
    1cbc:	08000600 	stmdaeq	r0, {r9, sl}
    1cc0:	0000073b 	andeq	r0, r0, fp, lsr r7
    1cc4:	00380405 	eorseq	r0, r8, r5, lsl #8
    1cc8:	71020000 	mrsvc	r0, (UNDEF: 2)
    1ccc:	00015a0c 	andeq	r5, r1, ip, lsl #20
    1cd0:	10790a00 	rsbsne	r0, r9, r0, lsl #20
    1cd4:	0a000000 	beq	1cdc <shift+0x1cdc>
    1cd8:	000005eb 	andeq	r0, r0, fp, ror #11
    1cdc:	0f590a01 	svceq	0x00590a01
    1ce0:	0a020000 	beq	81ce8 <__bss_end+0x75de0>
    1ce4:	00000dcf 	andeq	r0, r0, pc, asr #27
    1ce8:	0c0b0003 	stceq	0, cr0, [fp], {3}
    1cec:	0300000c 	movweq	r0, #12
    1cf0:	00591405 	subseq	r1, r9, r5, lsl #8
    1cf4:	03050000 	movweq	r0, #20480	; 0x5000
    1cf8:	0000bd38 	andeq	fp, r0, r8, lsr sp
    1cfc:	000fc20b 	andeq	ip, pc, fp, lsl #4
    1d00:	14060300 	strne	r0, [r6], #-768	; 0xfffffd00
    1d04:	00000059 	andeq	r0, r0, r9, asr r0
    1d08:	bd3c0305 	ldclt	3, cr0, [ip, #-20]!	; 0xffffffec
    1d0c:	9e0b0000 	cdpls	0, 0, cr0, cr11, cr0, {0}
    1d10:	0400000a 	streq	r0, [r0], #-10
    1d14:	00591a07 	subseq	r1, r9, r7, lsl #20
    1d18:	03050000 	movweq	r0, #20480	; 0x5000
    1d1c:	0000bd40 	andeq	fp, r0, r0, asr #26
    1d20:	000df70b 	andeq	pc, sp, fp, lsl #14
    1d24:	1a090400 	bne	242d2c <__bss_end+0x236e24>
    1d28:	00000059 	andeq	r0, r0, r9, asr r0
    1d2c:	bd440305 	stcllt	3, cr0, [r4, #-20]	; 0xffffffec
    1d30:	700b0000 	andvc	r0, fp, r0
    1d34:	0400000a 	streq	r0, [r0], #-10
    1d38:	00591a0b 	subseq	r1, r9, fp, lsl #20
    1d3c:	03050000 	movweq	r0, #20480	; 0x5000
    1d40:	0000bd48 	andeq	fp, r0, r8, asr #26
    1d44:	000d990b 	andeq	r9, sp, fp, lsl #18
    1d48:	1a0d0400 	bne	342d50 <__bss_end+0x336e48>
    1d4c:	00000059 	andeq	r0, r0, r9, asr r0
    1d50:	bd4c0305 	stcllt	3, cr0, [ip, #-20]	; 0xffffffec
    1d54:	ed0b0000 	stc	0, cr0, [fp, #-0]
    1d58:	04000006 	streq	r0, [r0], #-6
    1d5c:	00591a0f 	subseq	r1, r9, pc, lsl #20
    1d60:	03050000 	movweq	r0, #20480	; 0x5000
    1d64:	0000bd50 	andeq	fp, r0, r0, asr sp
    1d68:	000c4608 	andeq	r4, ip, r8, lsl #12
    1d6c:	38040500 	stmdacc	r4, {r8, sl}
    1d70:	04000000 	streq	r0, [r0], #-0
    1d74:	01fd0c1b 	mvnseq	r0, fp, lsl ip
    1d78:	8b0a0000 	blhi	281d80 <__bss_end+0x275e78>
    1d7c:	00000006 	andeq	r0, r0, r6
    1d80:	0010ef0a 	andseq	lr, r0, sl, lsl #30
    1d84:	7c0a0100 	stfvcs	f0, [sl], {-0}
    1d88:	02000012 	andeq	r0, r0, #18
    1d8c:	04350c00 	ldrteq	r0, [r5], #-3072	; 0xfffff400
    1d90:	0c0d0000 	stceq	0, cr0, [sp], {-0}
    1d94:	90000005 	andls	r0, r0, r5
    1d98:	70076404 	andvc	r6, r7, r4, lsl #8
    1d9c:	06000003 	streq	r0, [r0], -r3
    1da0:	0000064c 	andeq	r0, r0, ip, asr #12
    1da4:	10680424 	rsbne	r0, r8, r4, lsr #8
    1da8:	0000028a 	andeq	r0, r0, sl, lsl #5
    1dac:	0023760e 	eoreq	r7, r3, lr, lsl #12
    1db0:	286a0400 	stmdacs	sl!, {sl}^
    1db4:	00000370 	andeq	r0, r0, r0, ror r3
    1db8:	081a0e00 	ldmdaeq	sl, {r9, sl, fp}
    1dbc:	6c040000 	stcvs	0, cr0, [r4], {-0}
    1dc0:	00038020 	andeq	r8, r3, r0, lsr #32
    1dc4:	740e1000 	strvc	r1, [lr], #-0
    1dc8:	04000006 	streq	r0, [r0], #-6
    1dcc:	004d236e 	subeq	r2, sp, lr, ror #6
    1dd0:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
    1dd4:	00000dc8 	andeq	r0, r0, r8, asr #27
    1dd8:	871c7104 	ldrhi	r7, [ip, -r4, lsl #2]
    1ddc:	18000003 	stmdane	r0, {r0, r1}
    1de0:	00120d0e 	andseq	r0, r2, lr, lsl #26
    1de4:	1c730400 	cfldrdne	mvd0, [r3], #-0
    1de8:	00000387 	andeq	r0, r0, r7, lsl #7
    1dec:	05070e1c 	streq	r0, [r7, #-3612]	; 0xfffff1e4
    1df0:	76040000 	strvc	r0, [r4], -r0
    1df4:	0003871c 	andeq	r8, r3, ip, lsl r7
    1df8:	c50f2000 	strgt	r2, [pc, #-0]	; 1e00 <shift+0x1e00>
    1dfc:	0400000e 	streq	r0, [r0], #-14
    1e00:	11821c78 	orrne	r1, r2, r8, ror ip
    1e04:	03870000 	orreq	r0, r7, #0
    1e08:	027e0000 	rsbseq	r0, lr, #0
    1e0c:	87100000 	ldrhi	r0, [r0, -r0]
    1e10:	11000003 	tstne	r0, r3
    1e14:	0000038d 	andeq	r0, r0, sp, lsl #7
    1e18:	71060000 	mrsvc	r0, (UNDEF: 6)
    1e1c:	18000012 	stmdane	r0, {r1, r4}
    1e20:	bf107c04 	svclt	0x00107c04
    1e24:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
    1e28:	00002376 	andeq	r2, r0, r6, ror r3
    1e2c:	702c7f04 	eorvc	r7, ip, r4, lsl #30
    1e30:	00000003 	andeq	r0, r0, r3
    1e34:	0005970e 	andeq	r9, r5, lr, lsl #14
    1e38:	19810400 	stmibne	r1, {sl}
    1e3c:	0000038d 	andeq	r0, r0, sp, lsl #7
    1e40:	0a020e10 	beq	85688 <__bss_end+0x79780>
    1e44:	83040000 	movwhi	r0, #16384	; 0x4000
    1e48:	00039821 	andeq	r9, r3, r1, lsr #16
    1e4c:	03001400 	movweq	r1, #1024	; 0x400
    1e50:	0000028a 	andeq	r0, r0, sl, lsl #5
    1e54:	00049212 	andeq	r9, r4, r2, lsl r2
    1e58:	21870400 	orrcs	r0, r7, r0, lsl #8
    1e5c:	0000039e 	muleq	r0, lr, r3
    1e60:	00086212 	andeq	r6, r8, r2, lsl r2
    1e64:	1f890400 	svcne	0x00890400
    1e68:	00000059 	andeq	r0, r0, r9, asr r0
    1e6c:	000e1b0e 	andeq	r1, lr, lr, lsl #22
    1e70:	178c0400 	strne	r0, [ip, r0, lsl #8]
    1e74:	0000020f 	andeq	r0, r0, pc, lsl #4
    1e78:	07b80e00 	ldreq	r0, [r8, r0, lsl #28]!
    1e7c:	8f040000 	svchi	0x00040000
    1e80:	00020f17 	andeq	r0, r2, r7, lsl pc
    1e84:	8e0e2400 	cfcpyshi	mvf2, mvf14
    1e88:	0400000b 	streq	r0, [r0], #-11
    1e8c:	020f1790 	andeq	r1, pc, #144, 14	; 0x2400000
    1e90:	0e480000 	cdpeq	0, 4, cr0, cr8, cr0, {0}
    1e94:	000009c7 	andeq	r0, r0, r7, asr #19
    1e98:	0f179104 	svceq	0x00179104
    1e9c:	6c000002 	stcvs	0, cr0, [r0], {2}
    1ea0:	00050c13 	andeq	r0, r5, r3, lsl ip
    1ea4:	09940400 	ldmibeq	r4, {sl}
    1ea8:	00000d3c 	andeq	r0, r0, ip, lsr sp
    1eac:	000003a9 	andeq	r0, r0, r9, lsr #7
    1eb0:	00032901 	andeq	r2, r3, r1, lsl #18
    1eb4:	00032f00 	andeq	r2, r3, r0, lsl #30
    1eb8:	03a91000 			; <UNDEFINED> instruction: 0x03a91000
    1ebc:	14000000 	strne	r0, [r0], #-0
    1ec0:	00000ea8 	andeq	r0, r0, r8, lsr #29
    1ec4:	710e9704 	tstvc	lr, r4, lsl #14
    1ec8:	01000005 	tsteq	r0, r5
    1ecc:	00000344 	andeq	r0, r0, r4, asr #6
    1ed0:	0000034a 	andeq	r0, r0, sl, asr #6
    1ed4:	0003a910 	andeq	sl, r3, r0, lsl r9
    1ed8:	15150000 	ldrne	r0, [r5, #-0]
    1edc:	04000008 	streq	r0, [r0], #-8
    1ee0:	0c2b109a 	stceq	0, cr1, [fp], #-616	; 0xfffffd98
    1ee4:	03af0000 			; <UNDEFINED> instruction: 0x03af0000
    1ee8:	5f010000 	svcpl	0x00010000
    1eec:	10000003 	andne	r0, r0, r3
    1ef0:	000003a9 	andeq	r0, r0, r9, lsr #7
    1ef4:	00038d11 	andeq	r8, r3, r1, lsl sp
    1ef8:	01d81100 	bicseq	r1, r8, r0, lsl #2
    1efc:	00000000 	andeq	r0, r0, r0
    1f00:	00002516 	andeq	r2, r0, r6, lsl r5
    1f04:	00038000 	andeq	r8, r3, r0
    1f08:	005e1700 	subseq	r1, lr, r0, lsl #14
    1f0c:	000f0000 	andeq	r0, pc, r0
    1f10:	21020102 	tstcs	r2, r2, lsl #2
    1f14:	1800000b 	stmdane	r0, {r0, r1, r3}
    1f18:	00020f04 	andeq	r0, r2, r4, lsl #30
    1f1c:	2c041800 	stccs	8, cr1, [r4], {-0}
    1f20:	0c000000 	stceq	0, cr0, [r0], {-0}
    1f24:	0000115f 	andeq	r1, r0, pc, asr r1
    1f28:	03930418 	orrseq	r0, r3, #24, 8	; 0x18000000
    1f2c:	bf160000 	svclt	0x00160000
    1f30:	a9000002 	stmdbge	r0, {r1}
    1f34:	19000003 	stmdbne	r0, {r0, r1}
    1f38:	02041800 	andeq	r1, r4, #0, 16
    1f3c:	18000002 	stmdane	r0, {r1}
    1f40:	0001fd04 	andeq	pc, r1, r4, lsl #26
    1f44:	0e8f1a00 	vdiveq.f32	s2, s30, s0
    1f48:	9d040000 	stcls	0, cr0, [r4, #-0]
    1f4c:	00020214 	andeq	r0, r2, r4, lsl r2
    1f50:	06a60b00 	strteq	r0, [r6], r0, lsl #22
    1f54:	04050000 	streq	r0, [r5], #-0
    1f58:	00005914 	andeq	r5, r0, r4, lsl r9
    1f5c:	54030500 	strpl	r0, [r3], #-1280	; 0xfffffb00
    1f60:	0b0000bd 	bleq	225c <shift+0x225c>
    1f64:	00000f3b 	andeq	r0, r0, fp, lsr pc
    1f68:	59140705 	ldmdbpl	r4, {r0, r2, r8, r9, sl}
    1f6c:	05000000 	streq	r0, [r0, #-0]
    1f70:	00bd5803 	adcseq	r5, sp, r3, lsl #16
    1f74:	055e0b00 	ldrbeq	r0, [lr, #-2816]	; 0xfffff500
    1f78:	0a050000 	beq	141f80 <__bss_end+0x136078>
    1f7c:	00005914 	andeq	r5, r0, r4, lsl r9
    1f80:	5c030500 	cfstr32pl	mvfx0, [r3], {-0}
    1f84:	080000bd 	stmdaeq	r0, {r0, r2, r3, r4, r5, r7}
    1f88:	0000076c 	andeq	r0, r0, ip, ror #14
    1f8c:	00380405 	eorseq	r0, r8, r5, lsl #8
    1f90:	0d050000 	stceq	0, cr0, [r5, #-0]
    1f94:	00042e0c 	andeq	r2, r4, ip, lsl #28
    1f98:	654e0900 	strbvs	r0, [lr, #-2304]	; 0xfffff700
    1f9c:	0a000077 	beq	2180 <shift+0x2180>
    1fa0:	00000982 	andeq	r0, r0, r2, lsl #19
    1fa4:	05560a01 	ldrbeq	r0, [r6, #-2561]	; 0xfffff5ff
    1fa8:	0a020000 	beq	81fb0 <__bss_end+0x760a8>
    1fac:	00000785 	andeq	r0, r0, r5, lsl #15
    1fb0:	10b30a03 	adcsne	r0, r3, r3, lsl #20
    1fb4:	0a040000 	beq	101fbc <__bss_end+0xf60b4>
    1fb8:	000004f8 	strdeq	r0, [r0], -r8
    1fbc:	bf060005 	svclt	0x00060005
    1fc0:	10000006 	andne	r0, r0, r6
    1fc4:	6d081b05 	vstrvs	d1, [r8, #-20]	; 0xffffffec
    1fc8:	07000004 	streq	r0, [r0, -r4]
    1fcc:	0500726c 	streq	r7, [r0, #-620]	; 0xfffffd94
    1fd0:	046d131d 	strbteq	r1, [sp], #-797	; 0xfffffce3
    1fd4:	07000000 	streq	r0, [r0, -r0]
    1fd8:	05007073 	streq	r7, [r0, #-115]	; 0xffffff8d
    1fdc:	046d131e 	strbteq	r1, [sp], #-798	; 0xfffffce2
    1fe0:	07040000 	streq	r0, [r4, -r0]
    1fe4:	05006370 	streq	r6, [r0, #-880]	; 0xfffffc90
    1fe8:	046d131f 	strbteq	r1, [sp], #-799	; 0xfffffce1
    1fec:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
    1ff0:	00000ed0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1ff4:	6d132005 	ldcvs	0, cr2, [r3, #-20]	; 0xffffffec
    1ff8:	0c000004 	stceq	0, cr0, [r0], {4}
    1ffc:	07040200 	streq	r0, [r4, -r0, lsl #4]
    2000:	00001f89 	andeq	r1, r0, r9, lsl #31
    2004:	0008ef06 	andeq	lr, r8, r6, lsl #30
    2008:	28057000 	stmdacs	r5, {ip, sp, lr}
    200c:	00050408 	andeq	r0, r5, r8, lsl #8
    2010:	07e70e00 	strbeq	r0, [r7, r0, lsl #28]!
    2014:	2a050000 	bcs	14201c <__bss_end+0x136114>
    2018:	00042e12 	andeq	r2, r4, r2, lsl lr
    201c:	70070000 	andvc	r0, r7, r0
    2020:	05006469 	streq	r6, [r0, #-1129]	; 0xfffffb97
    2024:	005e122b 	subseq	r1, lr, fp, lsr #4
    2028:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
    202c:	00001d67 	andeq	r1, r0, r7, ror #26
    2030:	f7112c05 			; <UNDEFINED> instruction: 0xf7112c05
    2034:	14000003 	strne	r0, [r0], #-3
    2038:	00106b0e 	andseq	r6, r0, lr, lsl #22
    203c:	122d0500 	eorne	r0, sp, #0, 10
    2040:	0000005e 	andeq	r0, r0, lr, asr r0
    2044:	03c50e18 	biceq	r0, r5, #24, 28	; 0x180
    2048:	2e050000 	cdpcs	0, 0, cr0, cr5, cr0, {0}
    204c:	00005e12 	andeq	r5, r0, r2, lsl lr
    2050:	280e1c00 	stmdacs	lr, {sl, fp, ip}
    2054:	0500000f 	streq	r0, [r0, #-15]
    2058:	0504312f 	streq	r3, [r4, #-303]	; 0xfffffed1
    205c:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
    2060:	0000045f 	andeq	r0, r0, pc, asr r4
    2064:	38093005 	stmdacc	r9, {r0, r2, ip, sp}
    2068:	60000000 	andvs	r0, r0, r0
    206c:	000afb0e 	andeq	pc, sl, lr, lsl #22
    2070:	0e310500 	cfabs32eq	mvfx0, mvfx1
    2074:	0000004d 	andeq	r0, r0, sp, asr #32
    2078:	0ce90e64 	stcleq	14, cr0, [r9], #400	; 0x190
    207c:	33050000 	movwcc	r0, #20480	; 0x5000
    2080:	00004d0e 	andeq	r4, r0, lr, lsl #26
    2084:	e00e6800 	and	r6, lr, r0, lsl #16
    2088:	0500000c 	streq	r0, [r0, #-12]
    208c:	004d0e34 	subeq	r0, sp, r4, lsr lr
    2090:	006c0000 	rsbeq	r0, ip, r0
    2094:	0003af16 	andeq	sl, r3, r6, lsl pc
    2098:	00051400 	andeq	r1, r5, r0, lsl #8
    209c:	005e1700 	subseq	r1, lr, r0, lsl #14
    20a0:	000f0000 	andeq	r0, pc, r0
    20a4:	0005340b 	andeq	r3, r5, fp, lsl #8
    20a8:	140a0600 	strne	r0, [sl], #-1536	; 0xfffffa00
    20ac:	00000059 	andeq	r0, r0, r9, asr r0
    20b0:	bd600305 	stcllt	3, cr0, [r0, #-20]!	; 0xffffffec
    20b4:	e6080000 	str	r0, [r8], -r0
    20b8:	0500000a 	streq	r0, [r0, #-10]
    20bc:	00003804 	andeq	r3, r0, r4, lsl #16
    20c0:	0c0d0600 	stceq	6, cr0, [sp], {-0}
    20c4:	00000545 	andeq	r0, r0, r5, asr #10
    20c8:	0012910a 	andseq	r9, r2, sl, lsl #2
    20cc:	280a0000 	stmdacs	sl, {}	; <UNPREDICTABLE>
    20d0:	01000011 	tsteq	r0, r1, lsl r0
    20d4:	05260300 	streq	r0, [r6, #-768]!	; 0xfffffd00
    20d8:	09080000 	stmdbeq	r8, {}	; <UNPREDICTABLE>
    20dc:	05000016 	streq	r0, [r0, #-22]	; 0xffffffea
    20e0:	00003804 	andeq	r3, r0, r4, lsl #16
    20e4:	0c140600 	ldceq	6, cr0, [r4], {-0}
    20e8:	00000569 	andeq	r0, r0, r9, ror #10
    20ec:	0014d20a 	andseq	sp, r4, sl, lsl #4
    20f0:	bb0a0000 	bllt	2820f8 <__bss_end+0x2761f0>
    20f4:	01000016 	tsteq	r0, r6, lsl r0
    20f8:	054a0300 	strbeq	r0, [sl, #-768]	; 0xfffffd00
    20fc:	ae060000 	cdpge	0, 0, cr0, cr6, cr0, {0}
    2100:	0c000008 	stceq	0, cr0, [r0], {8}
    2104:	a3081b06 	movwge	r1, #35590	; 0x8b06
    2108:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
    210c:	00000609 	andeq	r0, r0, r9, lsl #12
    2110:	a3191d06 	tstge	r9, #384	; 0x180
    2114:	00000005 	andeq	r0, r0, r5
    2118:	0005070e 	andeq	r0, r5, lr, lsl #14
    211c:	191e0600 	ldmdbne	lr, {r9, sl}
    2120:	000005a3 	andeq	r0, r0, r3, lsr #11
    2124:	0b160e04 	bleq	58593c <__bss_end+0x579a34>
    2128:	1f060000 	svcne	0x00060000
    212c:	0005a913 	andeq	sl, r5, r3, lsl r9
    2130:	18000800 	stmdane	r0, {fp}
    2134:	00056e04 	andeq	r6, r5, r4, lsl #28
    2138:	74041800 	strvc	r1, [r4], #-2048	; 0xfffff800
    213c:	0d000004 	stceq	0, cr0, [r0, #-16]
    2140:	00000e4a 	andeq	r0, r0, sl, asr #28
    2144:	07220614 			; <UNDEFINED> instruction: 0x07220614
    2148:	00000831 	andeq	r0, r0, r1, lsr r8
    214c:	000c1a0e 	andeq	r1, ip, lr, lsl #20
    2150:	12260600 	eorne	r0, r6, #0, 12
    2154:	0000004d 	andeq	r0, r0, sp, asr #32
    2158:	0f700e00 	svceq	0x00700e00
    215c:	29060000 	stmdbcs	r6, {}	; <UNPREDICTABLE>
    2160:	0005a31d 	andeq	sl, r5, sp, lsl r3
    2164:	8d0e0400 	cfstrshi	mvf0, [lr, #-0]
    2168:	06000007 	streq	r0, [r0], -r7
    216c:	05a31d2c 	streq	r1, [r3, #3372]!	; 0xd2c
    2170:	1b080000 	blne	202178 <__bss_end+0x1f6270>
    2174:	00000c56 	andeq	r0, r0, r6, asr ip
    2178:	8b0e2f06 	blhi	38dd98 <__bss_end+0x381e90>
    217c:	f7000008 			; <UNDEFINED> instruction: 0xf7000008
    2180:	02000005 	andeq	r0, r0, #5
    2184:	10000006 	andne	r0, r0, r6
    2188:	00000836 	andeq	r0, r0, r6, lsr r8
    218c:	0005a311 	andeq	sl, r5, r1, lsl r3
    2190:	8b1c0000 	blhi	702198 <__bss_end+0x6f6290>
    2194:	06000009 	streq	r0, [r0], -r9
    2198:	08c60e31 	stmiaeq	r6, {r0, r4, r5, r9, sl, fp}^
    219c:	03800000 	orreq	r0, r0, #0
    21a0:	061a0000 	ldreq	r0, [sl], -r0
    21a4:	06250000 	strteq	r0, [r5], -r0
    21a8:	36100000 	ldrcc	r0, [r0], -r0
    21ac:	11000008 	tstne	r0, r8
    21b0:	000005a9 	andeq	r0, r0, r9, lsr #11
    21b4:	10c71300 	sbcne	r1, r7, r0, lsl #6
    21b8:	35060000 	strcc	r0, [r6, #-0]
    21bc:	000ac11d 	andeq	ip, sl, sp, lsl r1
    21c0:	0005a300 	andeq	sl, r5, r0, lsl #6
    21c4:	063e0200 	ldrteq	r0, [lr], -r0, lsl #4
    21c8:	06440000 	strbeq	r0, [r4], -r0
    21cc:	36100000 	ldrcc	r0, [r0], -r0
    21d0:	00000008 	andeq	r0, r0, r8
    21d4:	00077813 	andeq	r7, r7, r3, lsl r8
    21d8:	1d370600 	ldcne	6, cr0, [r7, #-0]
    21dc:	00000c66 	andeq	r0, r0, r6, ror #24
    21e0:	000005a3 	andeq	r0, r0, r3, lsr #11
    21e4:	00065d02 	andeq	r5, r6, r2, lsl #26
    21e8:	00066300 	andeq	r6, r6, r0, lsl #6
    21ec:	08361000 	ldmdaeq	r6!, {ip}
    21f0:	1d000000 	stcne	0, cr0, [r0, #-0]
    21f4:	00000b9e 	muleq	r0, lr, fp
    21f8:	4f443906 	svcmi	0x00443906
    21fc:	0c000008 	stceq	0, cr0, [r0], {8}
    2200:	0e4a1302 	cdpeq	3, 4, cr1, cr10, cr2, {0}
    2204:	3c060000 	stccc	0, cr0, [r6], {-0}
    2208:	00099a09 	andeq	r9, r9, r9, lsl #20
    220c:	00083600 	andeq	r3, r8, r0, lsl #12
    2210:	068a0100 	streq	r0, [sl], r0, lsl #2
    2214:	06900000 	ldreq	r0, [r0], r0
    2218:	36100000 	ldrcc	r0, [r0], -r0
    221c:	00000008 	andeq	r0, r0, r8
    2220:	0007f313 	andeq	pc, r7, r3, lsl r3	; <UNPREDICTABLE>
    2224:	123f0600 	eorsne	r0, pc, #0, 12
    2228:	000005c0 	andeq	r0, r0, r0, asr #11
    222c:	0000004d 	andeq	r0, r0, sp, asr #32
    2230:	0006a901 	andeq	sl, r6, r1, lsl #18
    2234:	0006be00 	andeq	fp, r6, r0, lsl #28
    2238:	08361000 	ldmdaeq	r6!, {ip}
    223c:	58110000 	ldmdapl	r1, {}	; <UNPREDICTABLE>
    2240:	11000008 	tstne	r0, r8
    2244:	0000005e 	andeq	r0, r0, lr, asr r0
    2248:	00038011 	andeq	r8, r3, r1, lsl r0
    224c:	fa140000 	blx	502254 <__bss_end+0x4f634c>
    2250:	06000010 			; <UNDEFINED> instruction: 0x06000010
    2254:	06cc0e42 	strbeq	r0, [ip], r2, asr #28
    2258:	d3010000 	movwle	r0, #4096	; 0x1000
    225c:	d9000006 	stmdble	r0, {r1, r2}
    2260:	10000006 	andne	r0, r0, r6
    2264:	00000836 	andeq	r0, r0, r6, lsr r8
    2268:	05a21300 	streq	r1, [r2, #768]!	; 0x300
    226c:	45060000 	strmi	r0, [r6, #-0]
    2270:	00060e17 	andeq	r0, r6, r7, lsl lr
    2274:	0005a900 	andeq	sl, r5, r0, lsl #18
    2278:	06f20100 	ldrbteq	r0, [r2], r0, lsl #2
    227c:	06f80000 	ldrbteq	r0, [r8], r0
    2280:	5e100000 	cdppl	0, 1, cr0, cr0, cr0, {0}
    2284:	00000008 	andeq	r0, r0, r8
    2288:	000f4613 	andeq	r4, pc, r3, lsl r6	; <UNPREDICTABLE>
    228c:	17480600 	strbne	r0, [r8, -r0, lsl #12]
    2290:	000003db 	ldrdeq	r0, [r0], -fp
    2294:	000005a9 	andeq	r0, r0, r9, lsr #11
    2298:	00071101 	andeq	r1, r7, r1, lsl #2
    229c:	00071c00 	andeq	r1, r7, r0, lsl #24
    22a0:	085e1000 	ldmdaeq	lr, {ip}^
    22a4:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    22a8:	00000000 	andeq	r0, r0, r0
    22ac:	0006f714 	andeq	pc, r6, r4, lsl r7	; <UNPREDICTABLE>
    22b0:	0e4b0600 	cdpeq	6, 4, cr0, cr11, cr0, {0}
    22b4:	00000bc8 	andeq	r0, r0, r8, asr #23
    22b8:	00073101 	andeq	r3, r7, r1, lsl #2
    22bc:	00073700 	andeq	r3, r7, r0, lsl #14
    22c0:	08361000 	ldmdaeq	r6!, {ip}
    22c4:	13000000 	movwne	r0, #0
    22c8:	0000098b 	andeq	r0, r0, fp, lsl #19
    22cc:	710e4d06 	tstvc	lr, r6, lsl #26
    22d0:	8000000d 	andhi	r0, r0, sp
    22d4:	01000003 	tsteq	r0, r3
    22d8:	00000750 	andeq	r0, r0, r0, asr r7
    22dc:	0000075b 	andeq	r0, r0, fp, asr r7
    22e0:	00083610 	andeq	r3, r8, r0, lsl r6
    22e4:	004d1100 	subeq	r1, sp, r0, lsl #2
    22e8:	13000000 	movwne	r0, #0
    22ec:	000004e4 	andeq	r0, r0, r4, ror #9
    22f0:	08125006 	ldmdaeq	r2, {r1, r2, ip, lr}
    22f4:	4d000004 	stcmi	0, cr0, [r0, #-16]
    22f8:	01000000 	mrseq	r0, (UNDEF: 0)
    22fc:	00000774 	andeq	r0, r0, r4, ror r7
    2300:	0000077f 	andeq	r0, r0, pc, ror r7
    2304:	00083610 	andeq	r3, r8, r0, lsl r6
    2308:	03af1100 			; <UNDEFINED> instruction: 0x03af1100
    230c:	13000000 	movwne	r0, #0
    2310:	0000043b 	andeq	r0, r0, fp, lsr r4
    2314:	330e5306 	movwcc	r5, #58118	; 0xe306
    2318:	80000011 	andhi	r0, r0, r1, lsl r0
    231c:	01000003 	tsteq	r0, r3
    2320:	00000798 	muleq	r0, r8, r7
    2324:	000007a3 	andeq	r0, r0, r3, lsr #15
    2328:	00083610 	andeq	r3, r8, r0, lsl r6
    232c:	004d1100 	subeq	r1, sp, r0, lsl #2
    2330:	14000000 	strne	r0, [r0], #-0
    2334:	0000049e 	muleq	r0, lr, r4
    2338:	e50e5606 	str	r5, [lr, #-1542]	; 0xfffff9fa
    233c:	0100000f 	tsteq	r0, pc
    2340:	000007b8 			; <UNDEFINED> instruction: 0x000007b8
    2344:	000007d7 	ldrdeq	r0, [r0], -r7
    2348:	00083610 	andeq	r3, r8, r0, lsl r6
    234c:	00a91100 	adceq	r1, r9, r0, lsl #2
    2350:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    2354:	11000000 	mrsne	r0, (UNDEF: 0)
    2358:	0000004d 	andeq	r0, r0, sp, asr #32
    235c:	00004d11 	andeq	r4, r0, r1, lsl sp
    2360:	08641100 	stmdaeq	r4!, {r8, ip}^
    2364:	14000000 	strne	r0, [r0], #-0
    2368:	000011b2 			; <UNDEFINED> instruction: 0x000011b2
    236c:	a60e5806 	strge	r5, [lr], -r6, lsl #16
    2370:	01000012 	tsteq	r0, r2, lsl r0
    2374:	000007ec 	andeq	r0, r0, ip, ror #15
    2378:	0000080b 	andeq	r0, r0, fp, lsl #16
    237c:	00083610 	andeq	r3, r8, r0, lsl r6
    2380:	00f21100 	rscseq	r1, r2, r0, lsl #2
    2384:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    2388:	11000000 	mrsne	r0, (UNDEF: 0)
    238c:	0000004d 	andeq	r0, r0, sp, asr #32
    2390:	00004d11 	andeq	r4, r0, r1, lsl sp
    2394:	08641100 	stmdaeq	r4!, {r8, ip}^
    2398:	15000000 	strne	r0, [r0, #-0]
    239c:	000004b1 			; <UNDEFINED> instruction: 0x000004b1
    23a0:	260e5b06 	strcs	r5, [lr], -r6, lsl #22
    23a4:	8000000b 	andhi	r0, r0, fp
    23a8:	01000003 	tsteq	r0, r3
    23ac:	00000820 	andeq	r0, r0, r0, lsr #16
    23b0:	00083610 	andeq	r3, r8, r0, lsl r6
    23b4:	05261100 	streq	r1, [r6, #-256]!	; 0xffffff00
    23b8:	6a110000 	bvs	4423c0 <__bss_end+0x4364b8>
    23bc:	00000008 	andeq	r0, r0, r8
    23c0:	05af0300 	streq	r0, [pc, #768]!	; 26c8 <shift+0x26c8>
    23c4:	04180000 	ldreq	r0, [r8], #-0
    23c8:	000005af 	andeq	r0, r0, pc, lsr #11
    23cc:	0005a31e 	andeq	sl, r5, lr, lsl r3
    23d0:	00084900 	andeq	r4, r8, r0, lsl #18
    23d4:	00084f00 	andeq	r4, r8, r0, lsl #30
    23d8:	08361000 	ldmdaeq	r6!, {ip}
    23dc:	1f000000 	svcne	0x00000000
    23e0:	000005af 	andeq	r0, r0, pc, lsr #11
    23e4:	0000083c 	andeq	r0, r0, ip, lsr r8
    23e8:	003f0418 	eorseq	r0, pc, r8, lsl r4	; <UNPREDICTABLE>
    23ec:	04180000 	ldreq	r0, [r8], #-0
    23f0:	00000831 	andeq	r0, r0, r1, lsr r8
    23f4:	00650420 	rsbeq	r0, r5, r0, lsr #8
    23f8:	04210000 	strteq	r0, [r1], #-0
    23fc:	0011f51a 	andseq	pc, r1, sl, lsl r5	; <UNPREDICTABLE>
    2400:	195e0600 	ldmdbne	lr, {r9, sl}^
    2404:	000005af 	andeq	r0, r0, pc, lsr #11
    2408:	00002c16 	andeq	r2, r0, r6, lsl ip
    240c:	00088800 	andeq	r8, r8, r0, lsl #16
    2410:	005e1700 	subseq	r1, lr, r0, lsl #14
    2414:	00090000 	andeq	r0, r9, r0
    2418:	00087803 	andeq	r7, r8, r3, lsl #16
    241c:	15892200 	strne	r2, [r9, #512]	; 0x200
    2420:	ae010000 	cdpge	0, 0, cr0, cr1, cr0, {0}
    2424:	0008880c 	andeq	r8, r8, ip, lsl #16
    2428:	64030500 	strvs	r0, [r3], #-1280	; 0xfffffb00
    242c:	230000bd 	movwcs	r0, #189	; 0xbd
    2430:	000014eb 	andeq	r1, r0, fp, ror #9
    2434:	fd0ab001 	stc2	0, cr11, [sl, #-4]
    2438:	4d000015 	stcmi	0, cr0, [r0, #-84]	; 0xffffffac
    243c:	78000000 	stmdavc	r0, {}	; <UNPREDICTABLE>
    2440:	b400009e 	strlt	r0, [r0], #-158	; 0xffffff62
    2444:	01000000 	mrseq	r0, (UNDEF: 0)
    2448:	0008fd9c 	muleq	r8, ip, sp
    244c:	23762400 	cmncs	r6, #0, 8
    2450:	b0010000 	andlt	r0, r1, r0
    2454:	00038d1b 	andeq	r8, r3, fp, lsl sp
    2458:	ac910300 	ldcge	3, cr0, [r1], {0}
    245c:	165c247f 			; <UNDEFINED> instruction: 0x165c247f
    2460:	b0010000 	andlt	r0, r1, r0
    2464:	00004d2a 	andeq	r4, r0, sl, lsr #26
    2468:	a8910300 	ldmge	r1, {r8, r9}
    246c:	15d3227f 	ldrbne	r2, [r3, #639]	; 0x27f
    2470:	b2010000 	andlt	r0, r1, #0
    2474:	0008fd0a 	andeq	pc, r8, sl, lsl #26
    2478:	b4910300 	ldrlt	r0, [r1], #768	; 0x300
    247c:	14e6227f 	strbtne	r2, [r6], #639	; 0x27f
    2480:	b6010000 	strlt	r0, [r1], -r0
    2484:	00003809 	andeq	r3, r0, r9, lsl #16
    2488:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    248c:	00251600 	eoreq	r1, r5, r0, lsl #12
    2490:	090d0000 	stmdbeq	sp, {}	; <UNPREDICTABLE>
    2494:	5e170000 	cdppl	0, 1, cr0, cr7, cr0, {0}
    2498:	3f000000 	svccc	0x00000000
    249c:	16412500 	strbne	r2, [r1], -r0, lsl #10
    24a0:	a2010000 	andge	r0, r1, #0
    24a4:	0016c90a 	andseq	ip, r6, sl, lsl #18
    24a8:	00004d00 	andeq	r4, r0, r0, lsl #26
    24ac:	009e3c00 	addseq	r3, lr, r0, lsl #24
    24b0:	00003c00 	andeq	r3, r0, r0, lsl #24
    24b4:	4a9c0100 	bmi	fe7028bc <__bss_end+0xfe6f69b4>
    24b8:	26000009 	strcs	r0, [r0], -r9
    24bc:	00716572 	rsbseq	r6, r1, r2, ror r5
    24c0:	6920a401 	stmdbvs	r0!, {r0, sl, sp, pc}
    24c4:	02000005 	andeq	r0, r0, #5
    24c8:	f2227491 	vqshl.s32	d7, d1, d18
    24cc:	01000015 	tsteq	r0, r5, lsl r0
    24d0:	004d0ea5 	subeq	r0, sp, r5, lsr #29
    24d4:	91020000 	mrsls	r0, (UNDEF: 2)
    24d8:	9e270070 	mcrls	0, 1, r0, cr7, cr0, {3}
    24dc:	01000016 	tsteq	r0, r6, lsl r0
    24e0:	15070699 	strne	r0, [r7, #-1689]	; 0xfffff967
    24e4:	9e000000 	cdpls	0, 0, cr0, cr0, cr0, {0}
    24e8:	003c0000 	eorseq	r0, ip, r0
    24ec:	9c010000 	stcls	0, cr0, [r1], {-0}
    24f0:	00000983 	andeq	r0, r0, r3, lsl #19
    24f4:	00157524 	andseq	r7, r5, r4, lsr #10
    24f8:	21990100 	orrscs	r0, r9, r0, lsl #2
    24fc:	0000004d 	andeq	r0, r0, sp, asr #32
    2500:	266c9102 	strbtcs	r9, [ip], -r2, lsl #2
    2504:	00716572 	rsbseq	r6, r1, r2, ror r5
    2508:	69209b01 	stmdbvs	r0!, {r0, r8, r9, fp, ip, pc}
    250c:	02000005 	andeq	r0, r0, #5
    2510:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    2514:	0000161e 	andeq	r1, r0, lr, lsl r6
    2518:	9a0a8d01 	bls	2a5924 <__bss_end+0x299a1c>
    251c:	4d000015 	stcmi	0, cr0, [r0, #-84]	; 0xffffffac
    2520:	c4000000 	strgt	r0, [r0], #-0
    2524:	3c00009d 	stccc	0, cr0, [r0], {157}	; 0x9d
    2528:	01000000 	mrseq	r0, (UNDEF: 0)
    252c:	0009c09c 	muleq	r9, ip, r0
    2530:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    2534:	8f010071 	svchi	0x00010071
    2538:	00054520 	andeq	r4, r5, r0, lsr #10
    253c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2540:	0014df22 	andseq	sp, r4, r2, lsr #30
    2544:	0e900100 	fmleqs	f0, f0, f0
    2548:	0000004d 	andeq	r0, r0, sp, asr #32
    254c:	00709102 	rsbseq	r9, r0, r2, lsl #2
    2550:	00179325 	andseq	r9, r7, r5, lsr #6
    2554:	0a810100 	beq	fe04295c <__bss_end+0xfe036a54>
    2558:	0000154b 	andeq	r1, r0, fp, asr #10
    255c:	0000004d 	andeq	r0, r0, sp, asr #32
    2560:	00009d88 	andeq	r9, r0, r8, lsl #27
    2564:	0000003c 	andeq	r0, r0, ip, lsr r0
    2568:	09fd9c01 	ldmibeq	sp!, {r0, sl, fp, ip, pc}^
    256c:	72260000 	eorvc	r0, r6, #0
    2570:	01007165 	tsteq	r0, r5, ror #2
    2574:	05452083 	strbeq	r2, [r5, #-131]	; 0xffffff7d
    2578:	91020000 	mrsls	r0, (UNDEF: 2)
    257c:	14df2274 	ldrbne	r2, [pc], #628	; 2584 <shift+0x2584>
    2580:	84010000 	strhi	r0, [r1], #-0
    2584:	00004d0e 	andeq	r4, r0, lr, lsl #26
    2588:	70910200 	addsvc	r0, r1, r0, lsl #4
    258c:	15ae2500 	strne	r2, [lr, #1280]!	; 0x500
    2590:	75010000 	strvc	r0, [r1, #-0]
    2594:	0016b006 	andseq	fp, r6, r6
    2598:	00038000 	andeq	r8, r3, r0
    259c:	009d3400 	addseq	r3, sp, r0, lsl #8
    25a0:	00005400 	andeq	r5, r0, r0, lsl #8
    25a4:	499c0100 	ldmibmi	ip, {r8}
    25a8:	2400000a 	strcs	r0, [r0], #-10
    25ac:	000015f2 	strdeq	r1, [r0], -r2
    25b0:	4d157501 	cfldr32mi	mvfx7, [r5, #-4]
    25b4:	02000000 	andeq	r0, r0, #0
    25b8:	e0246c91 	mla	r4, r1, ip, r6
    25bc:	0100000c 	tsteq	r0, ip
    25c0:	004d2575 	subeq	r2, sp, r5, ror r5
    25c4:	91020000 	mrsls	r0, (UNDEF: 2)
    25c8:	178b2268 	strne	r2, [fp, r8, ror #4]
    25cc:	77010000 	strvc	r0, [r1, -r0]
    25d0:	00004d0e 	andeq	r4, r0, lr, lsl #26
    25d4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    25d8:	151e2500 	ldrne	r2, [lr, #-1280]	; 0xfffffb00
    25dc:	68010000 	stmdavs	r1, {}	; <UNPREDICTABLE>
    25e0:	00170012 	andseq	r0, r7, r2, lsl r0
    25e4:	00008b00 	andeq	r8, r0, r0, lsl #22
    25e8:	009ce400 	addseq	lr, ip, r0, lsl #8
    25ec:	00005000 	andeq	r5, r0, r0
    25f0:	a49c0100 	ldrge	r0, [ip], #256	; 0x100
    25f4:	2400000a 	strcs	r0, [r0], #-10
    25f8:	00001312 	andeq	r1, r0, r2, lsl r3
    25fc:	4d206801 	stcmi	8, cr6, [r0, #-4]!
    2600:	02000000 	andeq	r0, r0, #0
    2604:	27246c91 			; <UNDEFINED> instruction: 0x27246c91
    2608:	01000016 	tsteq	r0, r6, lsl r0
    260c:	004d2f68 	subeq	r2, sp, r8, ror #30
    2610:	91020000 	mrsls	r0, (UNDEF: 2)
    2614:	0ce02468 	cfstrdeq	mvd2, [r0], #416	; 0x1a0
    2618:	68010000 	stmdavs	r1, {}	; <UNPREDICTABLE>
    261c:	00004d3f 	andeq	r4, r0, pc, lsr sp
    2620:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2624:	00178b22 	andseq	r8, r7, r2, lsr #22
    2628:	166a0100 	strbtne	r0, [sl], -r0, lsl #2
    262c:	0000008b 	andeq	r0, r0, fp, lsl #1
    2630:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2634:	0015eb25 	andseq	lr, r5, r5, lsr #22
    2638:	0a5c0100 	beq	1702a40 <__bss_end+0x16f6b38>
    263c:	00001523 	andeq	r1, r0, r3, lsr #10
    2640:	0000004d 	andeq	r0, r0, sp, asr #32
    2644:	00009ca0 	andeq	r9, r0, r0, lsr #25
    2648:	00000044 	andeq	r0, r0, r4, asr #32
    264c:	0af09c01 	beq	ffc29658 <__bss_end+0xffc1d750>
    2650:	12240000 	eorne	r0, r4, #0
    2654:	01000013 	tsteq	r0, r3, lsl r0
    2658:	004d1a5c 	subeq	r1, sp, ip, asr sl
    265c:	91020000 	mrsls	r0, (UNDEF: 2)
    2660:	1627246c 	strtne	r2, [r7], -ip, ror #8
    2664:	5c010000 	stcpl	0, cr0, [r1], {-0}
    2668:	00004d29 	andeq	r4, r0, r9, lsr #26
    266c:	68910200 	ldmvs	r1, {r9}
    2670:	00172f22 	andseq	r2, r7, r2, lsr #30
    2674:	0e5e0100 	rdfeqe	f0, f6, f0
    2678:	0000004d 	andeq	r0, r0, sp, asr #32
    267c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2680:	00172925 	andseq	r2, r7, r5, lsr #18
    2684:	0a4f0100 	beq	13c2a8c <__bss_end+0x13b6b84>
    2688:	0000170b 	andeq	r1, r0, fp, lsl #14
    268c:	0000004d 	andeq	r0, r0, sp, asr #32
    2690:	00009c50 	andeq	r9, r0, r0, asr ip
    2694:	00000050 	andeq	r0, r0, r0, asr r0
    2698:	0b4b9c01 	bleq	12e96a4 <__bss_end+0x12dd79c>
    269c:	12240000 	eorne	r0, r4, #0
    26a0:	01000013 	tsteq	r0, r3, lsl r0
    26a4:	004d194f 	subeq	r1, sp, pc, asr #18
    26a8:	91020000 	mrsls	r0, (UNDEF: 2)
    26ac:	15b4246c 	ldrne	r2, [r4, #1132]!	; 0x46c
    26b0:	4f010000 	svcmi	0x00010000
    26b4:	00012f30 	andeq	r2, r1, r0, lsr pc
    26b8:	68910200 	ldmvs	r1, {r9}
    26bc:	00162d24 	andseq	r2, r6, r4, lsr #26
    26c0:	414f0100 	mrsmi	r0, (UNDEF: 95)
    26c4:	0000086a 	andeq	r0, r0, sl, ror #16
    26c8:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    26cc:	0000178b 	andeq	r1, r0, fp, lsl #15
    26d0:	4d0e5101 	stfmis	f5, [lr, #-4]
    26d4:	02000000 	andeq	r0, r0, #0
    26d8:	27007491 			; <UNDEFINED> instruction: 0x27007491
    26dc:	000014cc 	andeq	r1, r0, ip, asr #9
    26e0:	be064901 	vmlalt.f16	s8, s12, s2	; <UNPREDICTABLE>
    26e4:	24000015 	strcs	r0, [r0], #-21	; 0xffffffeb
    26e8:	2c00009c 	stccs	0, cr0, [r0], {156}	; 0x9c
    26ec:	01000000 	mrseq	r0, (UNDEF: 0)
    26f0:	000b759c 	muleq	fp, ip, r5
    26f4:	13122400 	tstne	r2, #0, 8
    26f8:	49010000 	stmdbmi	r1, {}	; <UNPREDICTABLE>
    26fc:	00004d15 	andeq	r4, r0, r5, lsl sp
    2700:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2704:	16982500 	ldrne	r2, [r8], r0, lsl #10
    2708:	3c010000 	stccc	0, cr0, [r1], {-0}
    270c:	0016330a 	andseq	r3, r6, sl, lsl #6
    2710:	00004d00 	andeq	r4, r0, r0, lsl #26
    2714:	009bd400 	addseq	sp, fp, r0, lsl #8
    2718:	00005000 	andeq	r5, r0, r0
    271c:	d09c0100 	addsle	r0, ip, r0, lsl #2
    2720:	2400000b 	strcs	r0, [r0], #-11
    2724:	00001312 	andeq	r1, r0, r2, lsl r3
    2728:	4d193c01 	ldcmi	12, cr3, [r9, #-4]
    272c:	02000000 	andeq	r0, r0, #0
    2730:	ea246c91 	b	91d97c <__bss_end+0x911a74>
    2734:	0100000e 	tsteq	r0, lr
    2738:	038d2b3c 	orreq	r2, sp, #60, 22	; 0xf000
    273c:	91020000 	mrsls	r0, (UNDEF: 2)
    2740:	16602468 	strbtne	r2, [r0], -r8, ror #8
    2744:	3c010000 	stccc	0, cr0, [r1], {-0}
    2748:	00004d3c 	andeq	r4, r0, ip, lsr sp
    274c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2750:	0016fa22 	andseq	pc, r6, r2, lsr #20
    2754:	0e3e0100 	rsfeqe	f0, f6, f0
    2758:	0000004d 	andeq	r0, r0, sp, asr #32
    275c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2760:	0017b525 	andseq	fp, r7, r5, lsr #10
    2764:	0a2f0100 	beq	bc2b6c <__bss_end+0xbb6c64>
    2768:	00001745 	andeq	r1, r0, r5, asr #14
    276c:	0000004d 	andeq	r0, r0, sp, asr #32
    2770:	00009b84 	andeq	r9, r0, r4, lsl #23
    2774:	00000050 	andeq	r0, r0, r0, asr r0
    2778:	0c2b9c01 	stceq	12, cr9, [fp], #-4
    277c:	12240000 	eorne	r0, r4, #0
    2780:	01000013 	tsteq	r0, r3, lsl r0
    2784:	004d182f 	subeq	r1, sp, pc, lsr #16
    2788:	91020000 	mrsls	r0, (UNDEF: 2)
    278c:	0eea246c 	cdpeq	4, 14, cr2, cr10, cr12, {3}
    2790:	2f010000 	svccs	0x00010000
    2794:	000c312a 	andeq	r3, ip, sl, lsr #2
    2798:	68910200 	ldmvs	r1, {r9}
    279c:	00166024 	andseq	r6, r6, r4, lsr #32
    27a0:	3b2f0100 	blcc	bc2ba8 <__bss_end+0xbb6ca0>
    27a4:	0000004d 	andeq	r0, r0, sp, asr #32
    27a8:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    27ac:	000014f0 	strdeq	r1, [r0], -r0
    27b0:	4d0e3101 	stfmis	f3, [lr, #-4]
    27b4:	02000000 	andeq	r0, r0, #0
    27b8:	18007491 	stmdane	r0, {r0, r4, r7, sl, ip, sp, lr}
    27bc:	00002504 	andeq	r2, r0, r4, lsl #10
    27c0:	0c2b0300 	stceq	3, cr0, [fp], #-0
    27c4:	f8250000 			; <UNDEFINED> instruction: 0xf8250000
    27c8:	01000015 	tsteq	r0, r5, lsl r0
    27cc:	167c0a23 	ldrbtne	r0, [ip], -r3, lsr #20
    27d0:	004d0000 	subeq	r0, sp, r0
    27d4:	9b400000 	blls	10027dc <__bss_end+0xff68d4>
    27d8:	00440000 	subeq	r0, r4, r0
    27dc:	9c010000 	stcls	0, cr0, [r1], {-0}
    27e0:	00000c82 	andeq	r0, r0, r2, lsl #25
    27e4:	0017ac24 	andseq	sl, r7, r4, lsr #24
    27e8:	1b230100 	blne	8c2bf0 <__bss_end+0x8b6ce8>
    27ec:	0000038d 	andeq	r0, r0, sp, lsl #7
    27f0:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    27f4:	00001740 	andeq	r1, r0, r0, asr #14
    27f8:	d8352301 	ldmdale	r5!, {r0, r8, r9, sp}
    27fc:	02000001 	andeq	r0, r0, #1
    2800:	12226891 	eorne	r6, r2, #9502720	; 0x910000
    2804:	01000013 	tsteq	r0, r3, lsl r0
    2808:	004d0e25 	subeq	r0, sp, r5, lsr #28
    280c:	91020000 	mrsls	r0, (UNDEF: 2)
    2810:	69280074 	stmdbvs	r8!, {r2, r4, r5, r6}
    2814:	01000015 	tsteq	r0, r5, lsl r0
    2818:	14f6061e 	ldrbtne	r0, [r6], #1566	; 0x61e
    281c:	9b240000 	blls	902824 <__bss_end+0x8f691c>
    2820:	001c0000 	andseq	r0, ip, r0
    2824:	9c010000 	stcls	0, cr0, [r1], {-0}
    2828:	00173627 	andseq	r3, r7, r7, lsr #12
    282c:	06180100 	ldreq	r0, [r8], -r0, lsl #2
    2830:	0000152f 	andeq	r1, r0, pc, lsr #10
    2834:	00009af8 	strdeq	r9, [r0], -r8
    2838:	0000002c 	andeq	r0, r0, ip, lsr #32
    283c:	0cc29c01 	stcleq	12, cr9, [r2], {1}
    2840:	42240000 	eormi	r0, r4, #0
    2844:	01000015 	tsteq	r0, r5, lsl r0
    2848:	00381418 	eorseq	r1, r8, r8, lsl r4
    284c:	91020000 	mrsls	r0, (UNDEF: 2)
    2850:	d9250074 	stmdble	r5!, {r2, r4, r5, r6}
    2854:	01000015 	tsteq	r0, r5, lsl r0
    2858:	16650a0e 	strbtne	r0, [r5], -lr, lsl #20
    285c:	004d0000 	subeq	r0, sp, r0
    2860:	9acc0000 	bls	ff302868 <__bss_end+0xff2f6960>
    2864:	002c0000 	eoreq	r0, ip, r0
    2868:	9c010000 	stcls	0, cr0, [r1], {-0}
    286c:	00000cf0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    2870:	676e7226 	strbvs	r7, [lr, -r6, lsr #4]!
    2874:	0e100100 	mufeqs	f0, f0, f0
    2878:	0000004d 	andeq	r0, r0, sp, asr #32
    287c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2880:	0017ba29 	andseq	fp, r7, r9, lsr #20
    2884:	0a040100 	beq	102c8c <__bss_end+0xf6d84>
    2888:	000015c8 	andeq	r1, r0, r8, asr #11
    288c:	0000004d 	andeq	r0, r0, sp, asr #32
    2890:	00009aa0 	andeq	r9, r0, r0, lsr #21
    2894:	0000002c 	andeq	r0, r0, ip, lsr #32
    2898:	70269c01 	eorvc	r9, r6, r1, lsl #24
    289c:	01006469 	tsteq	r0, r9, ror #8
    28a0:	004d0e06 	subeq	r0, sp, r6, lsl #28
    28a4:	91020000 	mrsls	r0, (UNDEF: 2)
    28a8:	8e000074 	mcrhi	0, 0, r0, cr0, cr4, {3}
    28ac:	04000005 	streq	r0, [r0], #-5
    28b0:	000b7600 	andeq	r7, fp, r0, lsl #12
    28b4:	7d010400 	cfstrsvc	mvf0, [r1, #-0]
    28b8:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
    28bc:	00001838 	andeq	r1, r0, r8, lsr r8
    28c0:	00001489 	andeq	r1, r0, r9, lsl #9
    28c4:	00009f2c 	andeq	r9, r0, ip, lsr #30
    28c8:	00000434 	andeq	r0, r0, r4, lsr r4
    28cc:	00000d8e 	andeq	r0, r0, lr, lsl #27
    28d0:	8d080102 	stfhis	f0, [r8, #-8]
    28d4:	02000010 	andeq	r0, r0, #16
    28d8:	0de70502 	cfstr64eq	mvdx0, [r7, #8]!
    28dc:	04030000 	streq	r0, [r3], #-0
    28e0:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    28e4:	17ed0400 	strbne	r0, [sp, r0, lsl #8]!
    28e8:	07020000 	streq	r0, [r2, -r0]
    28ec:	0000461e 	andeq	r4, r0, lr, lsl r6
    28f0:	08010200 	stmdaeq	r1, {r9}
    28f4:	00001084 	andeq	r1, r0, r4, lsl #1
    28f8:	d2070202 	andle	r0, r7, #536870912	; 0x20000000
    28fc:	04000011 	streq	r0, [r0], #-17	; 0xffffffef
    2900:	00000715 	andeq	r0, r0, r5, lsl r7
    2904:	651e0902 	ldrvs	r0, [lr, #-2306]	; 0xfffff6fe
    2908:	05000000 	streq	r0, [r0, #-0]
    290c:	00000054 	andeq	r0, r0, r4, asr r0
    2910:	8e070402 	cdphi	4, 0, cr0, cr7, cr2, {0}
    2914:	0500001f 	streq	r0, [r0, #-31]	; 0xffffffe1
    2918:	00000065 	andeq	r0, r0, r5, rrx
    291c:	6c616806 	stclvs	8, cr6, [r1], #-24	; 0xffffffe8
    2920:	0b050300 	bleq	143528 <__bss_end+0x137620>
    2924:	0000012b 	andeq	r0, r0, fp, lsr #2
    2928:	000b7b07 	andeq	r7, fp, r7, lsl #22
    292c:	19070300 	stmdbne	r7, {r8, r9}
    2930:	0000006c 	andeq	r0, r0, ip, rrx
    2934:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
    2938:	000f8307 	andeq	r8, pc, r7, lsl #6
    293c:	1a0a0300 	bne	283544 <__bss_end+0x27763c>
    2940:	00000137 	andeq	r0, r0, r7, lsr r1
    2944:	20000000 	andcs	r0, r0, r0
    2948:	0005b607 	andeq	fp, r5, r7, lsl #12
    294c:	1a0d0300 	bne	343554 <__bss_end+0x33764c>
    2950:	00000137 	andeq	r0, r0, r7, lsr r1
    2954:	20200000 	eorcs	r0, r0, r0
    2958:	000b0708 	andeq	r0, fp, r8, lsl #14
    295c:	15100300 	ldrne	r0, [r0, #-768]	; 0xfffffd00
    2960:	00000060 	andeq	r0, r0, r0, rrx
    2964:	10d30736 	sbcsne	r0, r3, r6, lsr r7
    2968:	42030000 	andmi	r0, r3, #0
    296c:	0001371a 	andeq	r3, r1, sl, lsl r7
    2970:	21500000 	cmpcs	r0, r0
    2974:	12420720 	subne	r0, r2, #32, 14	; 0x800000
    2978:	71030000 	mrsvc	r0, (UNDEF: 3)
    297c:	0001371a 	andeq	r3, r1, sl, lsl r7
    2980:	00b20000 	adcseq	r0, r2, r0
    2984:	08500720 	ldmdaeq	r0, {r5, r8, r9, sl}^
    2988:	a4030000 	strge	r0, [r3], #-0
    298c:	0001371a 	andeq	r3, r1, sl, lsl r7
    2990:	00b40000 	adcseq	r0, r4, r0
    2994:	0b710720 	bleq	1c4461c <__bss_end+0x1c38714>
    2998:	b3030000 	movwlt	r0, #12288	; 0x3000
    299c:	0001371a 	andeq	r3, r1, sl, lsl r7
    29a0:	10400000 	subne	r0, r0, r0
    29a4:	0c8c0720 	stceq	7, cr0, [ip], {32}
    29a8:	be030000 	cdplt	0, 0, cr0, cr3, cr0, {0}
    29ac:	0001371a 	andeq	r3, r1, sl, lsl r7
    29b0:	20500000 	subscs	r0, r0, r0
    29b4:	07520720 	ldrbeq	r0, [r2, -r0, lsr #14]
    29b8:	bf030000 	svclt	0x00030000
    29bc:	0001371a 	andeq	r3, r1, sl, lsl r7
    29c0:	80400000 	subhi	r0, r0, r0
    29c4:	10e50720 	rscne	r0, r5, r0, lsr #14
    29c8:	c0030000 	andgt	r0, r3, r0
    29cc:	0001371a 	andeq	r3, r1, sl, lsl r7
    29d0:	80500000 	subshi	r0, r0, r0
    29d4:	7d090020 	stcvc	0, cr0, [r9, #-128]	; 0xffffff80
    29d8:	02000000 	andeq	r0, r0, #0
    29dc:	1f890704 	svcne	0x00890704
    29e0:	30050000 	andcc	r0, r5, r0
    29e4:	09000001 	stmdbeq	r0, {r0}
    29e8:	0000008d 	andeq	r0, r0, sp, lsl #1
    29ec:	00009d09 	andeq	r9, r0, r9, lsl #26
    29f0:	00ad0900 	adceq	r0, sp, r0, lsl #18
    29f4:	ba090000 	blt	2429fc <__bss_end+0x236af4>
    29f8:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    29fc:	000000ca 	andeq	r0, r0, sl, asr #1
    2a00:	0000da09 	andeq	sp, r0, r9, lsl #20
    2a04:	00ea0900 	rsceq	r0, sl, r0, lsl #18
    2a08:	fa090000 	blx	242a10 <__bss_end+0x236b08>
    2a0c:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2a10:	0000010a 	andeq	r0, r0, sl, lsl #2
    2a14:	00011a09 	andeq	r1, r1, r9, lsl #20
    2a18:	656d0600 	strbvs	r0, [sp, #-1536]!	; 0xfffffa00
    2a1c:	0604006d 	streq	r0, [r4], -sp, rrx
    2a20:	0001d90b 	andeq	sp, r1, fp, lsl #18
    2a24:	09d10700 	ldmibeq	r1, {r8, r9, sl}^
    2a28:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
    2a2c:	00006018 	andeq	r6, r0, r8, lsl r0
    2a30:	10000000 	andne	r0, r0, r0
    2a34:	09da0700 	ldmibeq	sl, {r8, r9, sl}^
    2a38:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
    2a3c:	00006018 	andeq	r6, r0, r8, lsl r0
    2a40:	00000000 	andeq	r0, r0, r0
    2a44:	0fa407c1 	svceq	0x00a407c1
    2a48:	11040000 	mrsne	r0, (UNDEF: 4)
    2a4c:	00006018 	andeq	r6, r0, r8, lsl r0
    2a50:	00000000 	andeq	r0, r0, r0
    2a54:	0fce07d1 	svceq	0x00ce07d1
    2a58:	15040000 	strne	r0, [r4, #-0]
    2a5c:	00006018 	andeq	r6, r0, r8, lsl r0
    2a60:	00000000 	andeq	r0, r0, r0
    2a64:	07d607c0 	ldrbeq	r0, [r6, r0, asr #15]
    2a68:	18040000 	stmdane	r4, {}	; <UNPREDICTABLE>
    2a6c:	00006018 	andeq	r6, r0, r8, lsl r0
    2a70:	00000000 	andeq	r0, r0, r0
    2a74:	0ef10a10 	vmrseq	r0, fpscr
    2a78:	1b040000 	blne	102a80 <__bss_end+0xf6b78>
    2a7c:	00006018 	andeq	r6, r0, r8, lsl r0
    2a80:	00010000 	andeq	r0, r1, r0
    2a84:	00017a09 	andeq	r7, r1, r9, lsl #20
    2a88:	018a0900 	orreq	r0, sl, r0, lsl #18
    2a8c:	9a090000 	bls	242a94 <__bss_end+0x236b8c>
    2a90:	09000001 	stmdbeq	r0, {r0}
    2a94:	000001aa 	andeq	r0, r0, sl, lsr #3
    2a98:	0001ba09 	andeq	fp, r1, r9, lsl #20
    2a9c:	01ca0900 	biceq	r0, sl, r0, lsl #18
    2aa0:	530b0000 	movwpl	r0, #45056	; 0xb000
    2aa4:	14000010 	strne	r0, [r0], #-16
    2aa8:	46080605 	strmi	r0, [r8], -r5, lsl #12
    2aac:	0c000002 	stceq	0, cr0, [r0], {2}
    2ab0:	00000609 	andeq	r0, r0, r9, lsl #12
    2ab4:	460c0805 	strmi	r0, [ip], -r5, lsl #16
    2ab8:	00000002 	andeq	r0, r0, r2
    2abc:	0005070c 	andeq	r0, r5, ip, lsl #14
    2ac0:	0c090500 	cfstr32eq	mvfx0, [r9], {-0}
    2ac4:	00000246 	andeq	r0, r0, r6, asr #4
    2ac8:	0faf0c04 	svceq	0x00af0c04
    2acc:	0a050000 	beq	142ad4 <__bss_end+0x136bcc>
    2ad0:	0000540e 	andeq	r5, r0, lr, lsl #8
    2ad4:	600c0800 	andvs	r0, ip, r0, lsl #16
    2ad8:	05000016 	streq	r0, [r0, #-22]	; 0xffffffea
    2adc:	00540e0b 	subseq	r0, r4, fp, lsl #28
    2ae0:	0c0c0000 	stceq	0, cr0, [ip], {-0}
    2ae4:	000008c1 	andeq	r0, r0, r1, asr #17
    2ae8:	4c0a0c05 	stcmi	12, cr0, [sl], {5}
    2aec:	10000002 	andne	r0, r0, r2
    2af0:	f7040d00 			; <UNDEFINED> instruction: 0xf7040d00
    2af4:	02000001 	andeq	r0, r0, #1
    2af8:	0b210201 	bleq	843304 <__bss_end+0x8373fc>
    2afc:	5b0e0000 	blpl	382b04 <__bss_end+0x376bfc>
    2b00:	1400000e 	strne	r0, [r0], #-14
    2b04:	4c070f05 	stcmi	15, cr0, [r7], {5}
    2b08:	0c000003 	stceq	0, cr0, [r0], {3}
    2b0c:	00000c24 	andeq	r0, r0, r4, lsr #24
    2b10:	46101205 	ldrmi	r1, [r0], -r5, lsl #4
    2b14:	00000002 	andeq	r0, r0, r2
    2b18:	000c9f0c 	andeq	r9, ip, ip, lsl #30
    2b1c:	12130500 	andsne	r0, r3, #0, 10
    2b20:	00000054 	andeq	r0, r0, r4, asr r0
    2b24:	069f0c04 	ldreq	r0, [pc], r4, lsl #24
    2b28:	14050000 	strne	r0, [r5], #-0
    2b2c:	00005412 	andeq	r5, r0, r2, lsl r4
    2b30:	430c0800 	movwmi	r0, #51200	; 0xc800
    2b34:	0500000e 	streq	r0, [r0, #-14]
    2b38:	00541215 	subseq	r1, r4, r5, lsl r2
    2b3c:	0c0c0000 	stceq	0, cr0, [ip], {-0}
    2b40:	00000df1 	strdeq	r0, [r0], -r1
    2b44:	4c131605 	ldcmi	6, cr1, [r3], {5}
    2b48:	10000003 	andne	r0, r0, r3
    2b4c:	000fb70f 	andeq	fp, pc, pc, lsl #14
    2b50:	12170500 	andsne	r0, r7, #0, 10
    2b54:	00000d51 	andeq	r0, r0, r1, asr sp
    2b58:	00000054 	andeq	r0, r0, r4, asr r0
    2b5c:	000002b9 			; <UNDEFINED> instruction: 0x000002b9
    2b60:	000002c4 	andeq	r0, r0, r4, asr #5
    2b64:	00035210 	andeq	r5, r3, r0, lsl r2
    2b68:	00541100 	subseq	r1, r4, r0, lsl #2
    2b6c:	0f000000 	svceq	0x00000000
    2b70:	00000840 	andeq	r0, r0, r0, asr #16
    2b74:	03121805 	tsteq	r2, #327680	; 0x50000
    2b78:	54000011 	strpl	r0, [r0], #-17	; 0xffffffef
    2b7c:	dc000000 	stcle	0, cr0, [r0], {-0}
    2b80:	e7000002 	str	r0, [r0, -r2]
    2b84:	10000002 	andne	r0, r0, r2
    2b88:	00000352 	andeq	r0, r0, r2, asr r3
    2b8c:	00005411 	andeq	r5, r0, r1, lsl r4
    2b90:	5b120000 	blpl	482b98 <__bss_end+0x476c90>
    2b94:	0500000e 	streq	r0, [r0, #-14]
    2b98:	109d091b 	addsne	r0, sp, fp, lsl r9
    2b9c:	03520000 	cmpeq	r2, #0
    2ba0:	00010000 	andeq	r0, r1, r0
    2ba4:	06000003 	streq	r0, [r0], -r3
    2ba8:	10000003 	andne	r0, r0, r3
    2bac:	00000352 	andeq	r0, r0, r2, asr r3
    2bb0:	0e7d1200 	cdpeq	2, 7, cr1, cr13, cr0, {0}
    2bb4:	1c050000 	stcne	0, cr0, [r5], {-0}
    2bb8:	00065a0f 	andeq	r5, r6, pc, lsl #20
    2bbc:	00035d00 	andeq	r5, r3, r0, lsl #26
    2bc0:	031f0100 	tsteq	pc, #0, 2
    2bc4:	032a0000 			; <UNDEFINED> instruction: 0x032a0000
    2bc8:	52100000 	andspl	r0, r0, #0
    2bcc:	11000003 	tstne	r0, r3
    2bd0:	00000054 	andeq	r0, r0, r4, asr r0
    2bd4:	07a01300 	streq	r1, [r0, r0, lsl #6]!
    2bd8:	22050000 	andcs	r0, r5, #0
    2bdc:	0008260e 	andeq	r2, r8, lr, lsl #12
    2be0:	033b0100 	teqeq	fp, #0, 2
    2be4:	52100000 	andspl	r0, r0, #0
    2be8:	11000003 	tstne	r0, r3
    2bec:	00000054 	andeq	r0, r0, r4, asr r0
    2bf0:	00024c11 	andeq	r4, r2, r1, lsl ip
    2bf4:	0d000000 	stceq	0, cr0, [r0, #-0]
    2bf8:	00005404 	andeq	r5, r0, r4, lsl #8
    2bfc:	53040d00 	movwpl	r0, #19712	; 0x4d00
    2c00:	05000002 	streq	r0, [r0, #-2]
    2c04:	00000352 	andeq	r0, r0, r2, asr r3
    2c08:	0f150414 	svceq	0x00150414
    2c0c:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    2c10:	02531525 	subseq	r1, r3, #155189248	; 0x9400000
    2c14:	5f160000 	svcpl	0x00160000
    2c18:	01000003 	tsteq	r0, r3
    2c1c:	03050e05 	movweq	r0, #24069	; 0x5e05
    2c20:	0000bee4 	andeq	fp, r0, r4, ror #29
    2c24:	00180017 	andseq	r0, r8, r7, lsl r0
    2c28:	00a34400 	adceq	r4, r3, r0, lsl #8
    2c2c:	00001c00 	andeq	r1, r0, r0, lsl #24
    2c30:	189c0100 	ldmne	ip, {r8}
    2c34:	00001317 	andeq	r1, r0, r7, lsl r3
    2c38:	0000a2f8 	strdeq	sl, [r0], -r8
    2c3c:	0000004c 	andeq	r0, r0, ip, asr #32
    2c40:	03ba9c01 			; <UNDEFINED> instruction: 0x03ba9c01
    2c44:	6b190000 	blvs	642c4c <__bss_end+0x636d44>
    2c48:	01000014 	tsteq	r0, r4, lsl r0
    2c4c:	0033016a 	eorseq	r0, r3, sl, ror #2
    2c50:	91020000 	mrsls	r0, (UNDEF: 2)
    2c54:	14601974 	strbtne	r1, [r0], #-2420	; 0xfffff68c
    2c58:	6a010000 	bvs	42c60 <__bss_end+0x36d58>
    2c5c:	00003301 	andeq	r3, r0, r1, lsl #6
    2c60:	70910200 	addsvc	r0, r1, r0, lsl #4
    2c64:	03061a00 	movweq	r1, #27136	; 0x6a00
    2c68:	49010000 	stmdbmi	r1, {}	; <UNPREDICTABLE>
    2c6c:	0003d407 	andeq	sp, r3, r7, lsl #8
    2c70:	00a15c00 	adceq	r5, r1, r0, lsl #24
    2c74:	00019c00 	andeq	r9, r1, r0, lsl #24
    2c78:	0e9c0100 	fmleqe	f0, f4, f0
    2c7c:	1b000004 	blne	2c94 <shift+0x2c94>
    2c80:	00001201 	andeq	r1, r0, r1, lsl #4
    2c84:	00000358 	andeq	r0, r0, r8, asr r3
    2c88:	196c9102 	stmdbne	ip!, {r1, r8, ip, pc}^
    2c8c:	00001660 	andeq	r1, r0, r0, ror #12
    2c90:	54244901 	strtpl	r4, [r4], #-2305	; 0xfffff6ff
    2c94:	02000000 	andeq	r0, r0, #0
    2c98:	e31c6891 	tst	ip, #9502720	; 0x910000
    2c9c:	01000017 	tsteq	r0, r7, lsl r0
    2ca0:	00540e4b 	subseq	r0, r4, fp, asr #28
    2ca4:	91020000 	mrsls	r0, (UNDEF: 2)
    2ca8:	18741c74 	ldmdane	r4!, {r2, r4, r5, r6, sl, fp, ip}^
    2cac:	5f010000 	svcpl	0x00010000
    2cb0:	0002460c 	andeq	r4, r2, ip, lsl #12
    2cb4:	70910200 	addsvc	r0, r1, r0, lsl #4
    2cb8:	032a1a00 			; <UNDEFINED> instruction: 0x032a1a00
    2cbc:	2c010000 	stccs	0, cr0, [r1], {-0}
    2cc0:	00042806 	andeq	r2, r4, r6, lsl #16
    2cc4:	00a03400 	adceq	r3, r0, r0, lsl #8
    2cc8:	00012800 	andeq	r2, r1, r0, lsl #16
    2ccc:	8a9c0100 	bhi	fe7030d4 <__bss_end+0xfe6f71cc>
    2cd0:	1b000004 	blne	2ce8 <shift+0x2ce8>
    2cd4:	00001201 	andeq	r1, r0, r1, lsl #4
    2cd8:	00000358 	andeq	r0, r0, r8, asr r3
    2cdc:	19649102 	stmdbne	r4!, {r1, r8, ip, pc}^
    2ce0:	00001660 	andeq	r1, r0, r0, ror #12
    2ce4:	54222c01 	strtpl	r2, [r2], #-3073	; 0xfffff3ff
    2ce8:	02000000 	andeq	r0, r0, #0
    2cec:	de196091 	mrcle	0, 0, r6, cr9, cr1, {4}
    2cf0:	01000017 	tsteq	r0, r7, lsl r0
    2cf4:	024c2d2c 	subeq	r2, ip, #44, 26	; 0xb00
    2cf8:	91020000 	mrsls	r0, (UNDEF: 2)
    2cfc:	17ca1c5f 			; <UNDEFINED> instruction: 0x17ca1c5f
    2d00:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
    2d04:	0000540e 	andeq	r5, r0, lr, lsl #8
    2d08:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2d0c:	00a0741d 	adceq	r7, r0, sp, lsl r4
    2d10:	0000c000 	andeq	ip, r0, r0
    2d14:	17c11c00 	strbne	r1, [r1, r0, lsl #24]
    2d18:	31010000 	mrscc	r0, (UNDEF: 1)
    2d1c:	00005412 	andeq	r5, r0, r2, lsl r4
    2d20:	70910200 	addsvc	r0, r1, r0, lsl #4
    2d24:	0018741c 	andseq	r7, r8, ip, lsl r4
    2d28:	10330100 	eorsne	r0, r3, r0, lsl #2
    2d2c:	00000246 	andeq	r0, r0, r6, asr #4
    2d30:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    2d34:	02a11e00 	adceq	r1, r1, #0, 28
    2d38:	20010000 	andcs	r0, r1, r0
    2d3c:	0004a40a 	andeq	sl, r4, sl, lsl #8
    2d40:	009fec00 	addseq	lr, pc, r0, lsl #24
    2d44:	00004800 	andeq	r4, r0, r0, lsl #16
    2d48:	cf9c0100 	svcgt	0x009c0100
    2d4c:	1b000004 	blne	2d64 <shift+0x2d64>
    2d50:	00001201 	andeq	r1, r0, r1, lsl #4
    2d54:	00000358 	andeq	r0, r0, r8, asr r3
    2d58:	196c9102 	stmdbne	ip!, {r1, r8, ip, pc}^
    2d5c:	000017d2 	ldrdeq	r1, [r0], -r2
    2d60:	542c2001 	strtpl	r2, [ip], #-1
    2d64:	02000000 	andeq	r0, r0, #0
    2d68:	af1c6891 	svcge	0x001c6891
    2d6c:	0100000f 	tsteq	r0, pc
    2d70:	00540e22 	subseq	r0, r4, r2, lsr #28
    2d74:	91020000 	mrsls	r0, (UNDEF: 2)
    2d78:	c41e0074 	ldrgt	r0, [lr], #-116	; 0xffffff8c
    2d7c:	01000002 	tsteq	r0, r2
    2d80:	04e90a12 	strbteq	r0, [r9], #2578	; 0xa12
    2d84:	9f980000 	svcls	0x00980000
    2d88:	00540000 	subseq	r0, r4, r0
    2d8c:	9c010000 	stcls	0, cr0, [r1], {-0}
    2d90:	00000523 	andeq	r0, r0, r3, lsr #10
    2d94:	0012011b 	andseq	r0, r2, fp, lsl r1
    2d98:	00035800 	andeq	r5, r3, r0, lsl #16
    2d9c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2da0:	0017d219 	andseq	sp, r7, r9, lsl r2
    2da4:	31120100 	tstcc	r2, r0, lsl #2
    2da8:	00000054 	andeq	r0, r0, r4, asr r0
    2dac:	1c689102 	stfnep	f1, [r8], #-8
    2db0:	00000faf 	andeq	r0, r0, pc, lsr #31
    2db4:	540e1401 	strpl	r1, [lr], #-1025	; 0xfffffbff
    2db8:	02000000 	andeq	r0, r0, #0
    2dbc:	f51c7491 			; <UNDEFINED> instruction: 0xf51c7491
    2dc0:	01000017 	tsteq	r0, r7, lsl r0
    2dc4:	00540e15 	subseq	r0, r4, r5, lsl lr
    2dc8:	91020000 	mrsls	r0, (UNDEF: 2)
    2dcc:	e71f0070 			; <UNDEFINED> instruction: 0xe71f0070
    2dd0:	01000002 	tsteq	r0, r2
    2dd4:	05340107 	ldreq	r0, [r4, #-263]!	; 0xfffffef9
    2dd8:	4c000000 	stcmi	0, cr0, [r0], {-0}
    2ddc:	20000005 	andcs	r0, r0, r5
    2de0:	00001201 	andeq	r1, r0, r1, lsl #4
    2de4:	00000358 	andeq	r0, r0, r8, asr r3
    2de8:	182f2221 	stmdane	pc!, {r0, r5, r9, sp}	; <UNPREDICTABLE>
    2dec:	0b010000 	bleq	42df4 <__bss_end+0x36eec>
    2df0:	0000540e 	andeq	r5, r0, lr, lsl #8
    2df4:	23000000 	movwcs	r0, #0
    2df8:	00000523 	andeq	r0, r0, r3, lsr #10
    2dfc:	00001819 	andeq	r1, r0, r9, lsl r8
    2e00:	00000563 	andeq	r0, r0, r3, ror #10
    2e04:	00009f2c 	andeq	r9, r0, ip, lsr #30
    2e08:	0000006c 	andeq	r0, r0, ip, rrx
    2e0c:	34249c01 	strtcc	r9, [r4], #-3073	; 0xfffff3ff
    2e10:	02000005 	andeq	r0, r0, #5
    2e14:	3d256c91 	stccc	12, cr6, [r5, #-580]!	; 0xfffffdbc
    2e18:	7a000005 	bvc	2e34 <shift+0x2e34>
    2e1c:	26000005 	strcs	r0, [r0], -r5
    2e20:	0000053e 	andeq	r0, r0, lr, lsr r5
    2e24:	053d2700 	ldreq	r2, [sp, #-1792]!	; 0xfffff900
    2e28:	9f3c0000 	svcls	0x003c0000
    2e2c:	004c0000 	subeq	r0, ip, r0
    2e30:	3e280000 	cdpcc	0, 2, cr0, cr8, cr0, {0}
    2e34:	02000005 	andeq	r0, r0, #5
    2e38:	00007491 	muleq	r0, r1, r4
    2e3c:	0005eb00 	andeq	lr, r5, r0, lsl #22
    2e40:	d0000400 	andle	r0, r0, r0, lsl #8
    2e44:	0400000d 	streq	r0, [r0], #-13
    2e48:	00137d01 	andseq	r7, r3, r1, lsl #26
    2e4c:	18a70400 	stmiane	r7!, {sl}
    2e50:	14890000 	strne	r0, [r9], #0
    2e54:	a3600000 	cmnge	r0, #0
    2e58:	0e9c0000 	cdpeq	0, 9, cr0, cr12, cr0, {0}
    2e5c:	10120000 	andsne	r0, r2, r0
    2e60:	49020000 	stmdbmi	r2, {}	; <UNPREDICTABLE>
    2e64:	03000000 	movweq	r0, #0
    2e68:	0000199a 	muleq	r0, sl, r9
    2e6c:	61100401 	tstvs	r0, r1, lsl #8
    2e70:	11000000 	mrsne	r0, (UNDEF: 0)
    2e74:	33323130 	teqcc	r2, #48, 2
    2e78:	37363534 			; <UNDEFINED> instruction: 0x37363534
    2e7c:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    2e80:	46454443 	strbmi	r4, [r5], -r3, asr #8
    2e84:	01040000 	mrseq	r0, (UNDEF: 4)
    2e88:	00250103 	eoreq	r0, r5, r3, lsl #2
    2e8c:	74050000 	strvc	r0, [r5], #-0
    2e90:	61000000 	mrsvs	r0, (UNDEF: 0)
    2e94:	06000000 	streq	r0, [r0], -r0
    2e98:	00000066 	andeq	r0, r0, r6, rrx
    2e9c:	51070010 	tstpl	r7, r0, lsl r0
    2ea0:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2ea4:	1f8e0704 	svcne	0x008e0704
    2ea8:	01080000 	mrseq	r0, (UNDEF: 8)
    2eac:	00108d08 	andseq	r8, r0, r8, lsl #26
    2eb0:	006d0700 	rsbeq	r0, sp, r0, lsl #14
    2eb4:	2a090000 	bcs	242ebc <__bss_end+0x236fb4>
    2eb8:	0a000000 	beq	2ec0 <shift+0x2ec0>
    2ebc:	000018f4 	strdeq	r1, [r0], -r4
    2ec0:	fa06f001 	blx	1beecc <__bss_end+0x1b2fc4>
    2ec4:	f3000019 	vqadd.u8	d0, d0, d9
    2ec8:	34000000 	strcc	r0, [r0], #-0
    2ecc:	c80000b0 	stmdagt	r0, {r4, r5, r7}
    2ed0:	01000001 	tsteq	r0, r1
    2ed4:	0000f39c 	muleq	r0, ip, r3
    2ed8:	74730b00 	ldrbtvc	r0, [r3], #-2816	; 0xfffff500
    2edc:	f0010072 			; <UNDEFINED> instruction: 0xf0010072
    2ee0:	0000fa1b 	andeq	pc, r0, fp, lsl sl	; <UNPREDICTABLE>
    2ee4:	5c910200 	lfmpl	f0, 4, [r1], {0}
    2ee8:	0100630c 	tsteq	r0, ip, lsl #6
    2eec:	006d0af1 	strdeq	r0, [sp], #-161	; 0xffffff5f	; <UNPREDICTABLE>
    2ef0:	91020000 	mrsls	r0, (UNDEF: 2)
    2ef4:	18910d67 	ldmne	r1, {r0, r1, r2, r5, r6, r8, sl, fp}
    2ef8:	f2010000 	vhadd.s8	d0, d1, d0
    2efc:	0000f30a 	andeq	pc, r0, sl, lsl #6
    2f00:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    2f04:	0019360d 	andseq	r3, r9, sp, lsl #12
    2f08:	09f30100 	ldmibeq	r3!, {r8}^
    2f0c:	00000100 	andeq	r0, r0, r0, lsl #2
    2f10:	0d709102 	ldfeqp	f1, [r0, #-8]!
    2f14:	0000188a 	andeq	r1, r0, sl, lsl #17
    2f18:	0009f401 	andeq	pc, r9, r1, lsl #8
    2f1c:	02000001 	andeq	r0, r0, #1
    2f20:	690c6c91 	stmdbvs	ip, {r0, r4, r7, sl, fp, sp, lr}
    2f24:	09fe0100 	ldmibeq	lr!, {r8}^
    2f28:	00000100 	andeq	r0, r0, r0, lsl #2
    2f2c:	00689102 	rsbeq	r9, r8, r2, lsl #2
    2f30:	21020108 	tstcs	r2, r8, lsl #2
    2f34:	0e00000b 	cdpeq	0, 0, cr0, cr0, cr11, {0}
    2f38:	00007404 	andeq	r7, r0, r4, lsl #8
    2f3c:	05040f00 	streq	r0, [r4, #-3840]	; 0xfffff100
    2f40:	00746e69 	rsbseq	r6, r4, r9, ror #28
    2f44:	0019710a 	andseq	r7, r9, sl, lsl #2
    2f48:	06d20100 	ldrbeq	r0, [r2], r0, lsl #2
    2f4c:	000019e8 	andeq	r1, r0, r8, ror #19
    2f50:	000000f3 	strdeq	r0, [r0], -r3
    2f54:	0000af1c 	andeq	sl, r0, ip, lsl pc
    2f58:	00000118 	andeq	r0, r0, r8, lsl r1
    2f5c:	015e9c01 	cmpeq	lr, r1, lsl #24
    2f60:	730b0000 	movwvc	r0, #45056	; 0xb000
    2f64:	01007274 	tsteq	r0, r4, ror r2
    2f68:	00fa1dd2 	ldrsbteq	r1, [sl], #210	; 0xd2
    2f6c:	91020000 	mrsls	r0, (UNDEF: 2)
    2f70:	00630c64 	rsbeq	r0, r3, r4, ror #24
    2f74:	6d0ad301 	stcvs	3, cr13, [sl, #-4]
    2f78:	02000000 	andeq	r0, r0, #0
    2f7c:	600d6f91 	mulvs	sp, r1, pc	; <UNPREDICTABLE>
    2f80:	01000016 	tsteq	r0, r6, lsl r0
    2f84:	010009d6 	ldrdeq	r0, [r0, -r6]
    2f88:	91020000 	mrsls	r0, (UNDEF: 2)
    2f8c:	00690c74 	rsbeq	r0, r9, r4, ror ip
    2f90:	0009e001 	andeq	lr, r9, r1
    2f94:	02000001 	andeq	r0, r0, #1
    2f98:	10007091 	mulne	r0, r1, r0
    2f9c:	00001985 	andeq	r1, r0, r5, lsl #19
    2fa0:	7d06ce01 	stcvc	14, cr12, [r6, #-4]
    2fa4:	f3000018 	vqadd.u8	d0, d0, d8
    2fa8:	d4000000 	strle	r0, [r0], #-0
    2fac:	480000ae 	stmdami	r0, {r1, r2, r3, r5, r7}
    2fb0:	01000000 	mrseq	r0, (UNDEF: 0)
    2fb4:	00018a9c 	muleq	r1, ip, sl
    2fb8:	00630b00 	rsbeq	r0, r3, r0, lsl #22
    2fbc:	6d14ce01 	ldcvs	14, cr12, [r4, #-4]
    2fc0:	02000000 	andeq	r0, r0, #0
    2fc4:	11007791 			; <UNDEFINED> instruction: 0x11007791
    2fc8:	000019ca 	andeq	r1, r0, sl, asr #19
    2fcc:	9706c601 	strls	ip, [r6, -r1, lsl #12]
    2fd0:	54000018 	strpl	r0, [r0], #-24	; 0xffffffe8
    2fd4:	800000ae 	andhi	r0, r0, lr, lsr #1
    2fd8:	01000000 	mrseq	r0, (UNDEF: 0)
    2fdc:	0002079c 	muleq	r2, ip, r7
    2fe0:	72730b00 	rsbsvc	r0, r3, #0, 22
    2fe4:	c6010063 	strgt	r0, [r1], -r3, rrx
    2fe8:	00020719 	andeq	r0, r2, r9, lsl r7
    2fec:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2ff0:	7473640b 	ldrbtvc	r6, [r3], #-1035	; 0xfffffbf5
    2ff4:	24c60100 	strbcs	r0, [r6], #256	; 0x100
    2ff8:	0000020e 	andeq	r0, r0, lr, lsl #4
    2ffc:	0b609102 	bleq	182740c <__bss_end+0x181b504>
    3000:	006d756e 	rsbeq	r7, sp, lr, ror #10
    3004:	002dc601 	eoreq	ip, sp, r1, lsl #12
    3008:	02000001 	andeq	r0, r0, #1
    300c:	b50d5c91 	strlt	r5, [sp, #-3217]	; 0xfffff36f
    3010:	01000019 	tsteq	r0, r9, lsl r0
    3014:	00fa11c7 	rscseq	r1, sl, r7, asr #3
    3018:	91020000 	mrsls	r0, (UNDEF: 2)
    301c:	19930d70 	ldmibne	r3, {r4, r5, r6, r8, sl, fp}
    3020:	c8010000 	stmdagt	r1, {}	; <UNPREDICTABLE>
    3024:	0002100b 	andeq	r1, r2, fp
    3028:	6c910200 	lfmvs	f0, 4, [r1], {0}
    302c:	00ae7c12 	adceq	r7, lr, r2, lsl ip
    3030:	00004800 	andeq	r4, r0, r0, lsl #16
    3034:	00690c00 	rsbeq	r0, r9, r0, lsl #24
    3038:	000eca01 	andeq	ip, lr, r1, lsl #20
    303c:	02000001 	andeq	r0, r0, #1
    3040:	00007491 	muleq	r0, r1, r4
    3044:	020d040e 	andeq	r0, sp, #234881024	; 0xe000000
    3048:	14130000 	ldrne	r0, [r3], #-0
    304c:	6d040e04 	stcvs	14, cr0, [r4, #-16]
    3050:	11000000 	mrsne	r0, (UNDEF: 0)
    3054:	000019c4 	andeq	r1, r0, r4, asr #19
    3058:	4206bf01 	andmi	fp, r6, #1, 30
    305c:	ec000019 	stc	0, cr0, [r0], {25}
    3060:	680000ad 	stmdavs	r0, {r0, r2, r3, r5, r7}
    3064:	01000000 	mrseq	r0, (UNDEF: 0)
    3068:	0002759c 	muleq	r2, ip, r5
    306c:	1a4f1500 	bne	13c8474 <__bss_end+0x13bc56c>
    3070:	bf010000 	svclt	0x00010000
    3074:	00020e12 	andeq	r0, r2, r2, lsl lr
    3078:	6c910200 	lfmvs	f0, 4, [r1], {0}
    307c:	000f9d15 	andeq	r9, pc, r5, lsl sp	; <UNPREDICTABLE>
    3080:	1ebf0100 	frdnee	f0, f7, f0
    3084:	00000100 	andeq	r0, r0, r0, lsl #2
    3088:	0c689102 	stfeqp	f1, [r8], #-8
    308c:	006d656d 	rsbeq	r6, sp, sp, ror #10
    3090:	100bc001 	andne	ip, fp, r1
    3094:	02000002 	andeq	r0, r0, #2
    3098:	08127091 	ldmdaeq	r2, {r0, r4, r7, ip, sp, lr}
    309c:	3c0000ae 	stccc	0, cr0, [r0], {174}	; 0xae
    30a0:	0c000000 	stceq	0, cr0, [r0], {-0}
    30a4:	c2010069 	andgt	r0, r1, #105	; 0x69
    30a8:	0001000e 	andeq	r0, r1, lr
    30ac:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    30b0:	2c100000 	ldccs	0, cr0, [r0], {-0}
    30b4:	01000019 	tsteq	r0, r9, lsl r0
    30b8:	191606b4 	ldmdbne	r6, {r2, r4, r5, r7, r9, sl}
    30bc:	00f30000 	rscseq	r0, r3, r0
    30c0:	ad6c0000 	stclge	0, cr0, [ip, #-0]
    30c4:	00800000 	addeq	r0, r0, r0
    30c8:	9c010000 	stcls	0, cr0, [r1], {-0}
    30cc:	000002bf 			; <UNDEFINED> instruction: 0x000002bf
    30d0:	001a3d15 	andseq	r3, sl, r5, lsl sp
    30d4:	1cb40100 	ldfnes	f0, [r4]
    30d8:	000000fa 	strdeq	r0, [r0], -sl
    30dc:	156c9102 	strbne	r9, [ip, #-258]!	; 0xfffffefe
    30e0:	000018fd 	strdeq	r1, [r0], -sp
    30e4:	742fb401 	strtvc	fp, [pc], #-1025	; 30ec <shift+0x30ec>
    30e8:	02000000 	andeq	r0, r0, #0
    30ec:	690c6b91 	stmdbvs	ip, {r0, r4, r7, r8, r9, fp, sp, lr}
    30f0:	09b50100 	ldmibeq	r5!, {r8}
    30f4:	00000100 	andeq	r0, r0, r0, lsl #2
    30f8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    30fc:	00190410 	andseq	r0, r9, r0, lsl r4
    3100:	05ab0100 	streq	r0, [fp, #256]!	; 0x100
    3104:	00001a13 	andeq	r1, r0, r3, lsl sl
    3108:	00000100 	andeq	r0, r0, r0, lsl #2
    310c:	0000ad18 	andeq	sl, r0, r8, lsl sp
    3110:	00000054 	andeq	r0, r0, r4, asr r0
    3114:	02f89c01 	rscseq	r9, r8, #256	; 0x100
    3118:	730b0000 	movwvc	r0, #45056	; 0xb000
    311c:	18ab0100 	stmiane	fp!, {r8}
    3120:	000000fa 	strdeq	r0, [r0], -sl
    3124:	0c6c9102 	stfeqp	f1, [ip], #-8
    3128:	ac010069 	stcge	0, cr0, [r1], {105}	; 0x69
    312c:	00010009 	andeq	r0, r1, r9
    3130:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    3134:	19d91000 	ldmibne	r9, {ip}^
    3138:	9d010000 	stcls	0, cr0, [r1, #-0]
    313c:	001a2005 	andseq	r2, sl, r5
    3140:	00010000 	andeq	r0, r1, r0
    3144:	00ac6c00 	adceq	r6, ip, r0, lsl #24
    3148:	0000ac00 	andeq	sl, r0, r0, lsl #24
    314c:	5e9c0100 	fmlple	f0, f4, f0
    3150:	0b000003 	bleq	3164 <shift+0x3164>
    3154:	01003173 	tsteq	r0, r3, ror r1
    3158:	00fa199d 	smlalseq	r1, sl, sp, r9
    315c:	91020000 	mrsls	r0, (UNDEF: 2)
    3160:	32730b6c 	rsbscc	r0, r3, #108, 22	; 0x1b000
    3164:	299d0100 	ldmibcs	sp, {r8}
    3168:	000000fa 	strdeq	r0, [r0], -sl
    316c:	0b689102 	bleq	1a2757c <__bss_end+0x1a1b674>
    3170:	006d756e 	rsbeq	r7, sp, lr, ror #10
    3174:	00319d01 	eorseq	r9, r1, r1, lsl #26
    3178:	02000001 	andeq	r0, r0, #1
    317c:	750c6491 	strvc	r6, [ip, #-1169]	; 0xfffffb6f
    3180:	9e010031 	mcrls	0, 0, r0, cr1, cr1, {1}
    3184:	00035e13 	andeq	r5, r3, r3, lsl lr
    3188:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    318c:	0032750c 	eorseq	r7, r2, ip, lsl #10
    3190:	5e179e01 	cdppl	14, 1, cr9, cr7, cr1, {0}
    3194:	02000003 	andeq	r0, r0, #3
    3198:	08007691 	stmdaeq	r0, {r0, r4, r7, r9, sl, ip, sp, lr}
    319c:	10840801 	addne	r0, r4, r1, lsl #16
    31a0:	4e100000 	cdpmi	0, 1, cr0, cr0, cr0, {0}
    31a4:	01000019 	tsteq	r0, r9, lsl r0
    31a8:	19600792 	stmdbne	r0!, {r1, r4, r7, r8, r9, sl}^
    31ac:	02100000 	andseq	r0, r0, #0
    31b0:	abac0000 	blge	feb031b8 <__bss_end+0xfeaf72b0>
    31b4:	00c00000 	sbceq	r0, r0, r0
    31b8:	9c010000 	stcls	0, cr0, [r1], {-0}
    31bc:	000003be 			; <UNDEFINED> instruction: 0x000003be
    31c0:	00195b15 	andseq	r5, r9, r5, lsl fp
    31c4:	15920100 	ldrne	r0, [r2, #256]	; 0x100
    31c8:	00000210 	andeq	r0, r0, r0, lsl r2
    31cc:	0b6c9102 	bleq	1b275dc <__bss_end+0x1b1b6d4>
    31d0:	00637273 	rsbeq	r7, r3, r3, ror r2
    31d4:	fa279201 	blx	9e79e0 <__bss_end+0x9dbad8>
    31d8:	02000000 	andeq	r0, r0, #0
    31dc:	6e0b6891 	mcrvs	8, 0, r6, cr11, cr1, {4}
    31e0:	01006d75 	tsteq	r0, r5, ror sp
    31e4:	01003092 	swpeq	r3, r2, [r0]
    31e8:	91020000 	mrsls	r0, (UNDEF: 2)
    31ec:	00690c64 	rsbeq	r0, r9, r4, ror #24
    31f0:	00099301 	andeq	r9, r9, r1, lsl #6
    31f4:	02000001 	andeq	r0, r0, #1
    31f8:	10007491 	mulne	r0, r1, r4
    31fc:	000019a6 	andeq	r1, r0, r6, lsr #19
    3200:	32058201 	andcc	r8, r5, #268435456	; 0x10000000
    3204:	0000001a 	andeq	r0, r0, sl, lsl r0
    3208:	10000001 	andne	r0, r0, r1
    320c:	9c0000ab 	stcls	0, cr0, [r0], {171}	; 0xab
    3210:	01000000 	mrseq	r0, (UNDEF: 0)
    3214:	0003fb9c 	muleq	r3, ip, fp
    3218:	09ba1500 	ldmibeq	sl!, {r8, sl, ip}
    321c:	82010000 	andhi	r0, r1, #0
    3220:	0000fa16 	andeq	pc, r0, r6, lsl sl	; <UNPREDICTABLE>
    3224:	6c910200 	lfmvs	f0, 4, [r1], {0}
    3228:	0019e10d 	andseq	lr, r9, sp, lsl #2
    322c:	09830100 	stmibeq	r3, {r8}
    3230:	00000100 	andeq	r0, r0, r0, lsl #2
    3234:	00749102 	rsbseq	r9, r4, r2, lsl #2
    3238:	00195616 	andseq	r5, r9, r6, lsl r6
    323c:	066a0100 	strbteq	r0, [sl], -r0, lsl #2
    3240:	000018e8 	andeq	r1, r0, r8, ror #17
    3244:	0000a99c 	muleq	r0, ip, r9
    3248:	00000174 	andeq	r0, r0, r4, ror r1
    324c:	047e9c01 	ldrbteq	r9, [lr], #-3073	; 0xfffff3ff
    3250:	ba150000 	blt	543258 <__bss_end+0x537350>
    3254:	01000009 	tsteq	r0, r9
    3258:	0066186a 	rsbeq	r1, r6, sl, ror #16
    325c:	91020000 	mrsls	r0, (UNDEF: 2)
    3260:	19e11564 	stmibne	r1!, {r2, r5, r6, r8, sl, ip}^
    3264:	6a010000 	bvs	4326c <__bss_end+0x37364>
    3268:	00021025 	andeq	r1, r2, r5, lsr #32
    326c:	60910200 	addsvs	r0, r1, r0, lsl #4
    3270:	00192715 	andseq	r2, r9, r5, lsl r7
    3274:	3a6a0100 	bcc	1a8367c <__bss_end+0x1a77774>
    3278:	00000066 	andeq	r0, r0, r6, rrx
    327c:	0c5c9102 	ldfeqp	f1, [ip], {2}
    3280:	6b010069 	blvs	4342c <__bss_end+0x37524>
    3284:	00010009 	andeq	r0, r1, r9
    3288:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    328c:	00aa6812 	adceq	r6, sl, r2, lsl r8
    3290:	00009800 	andeq	r9, r0, r0, lsl #16
    3294:	006a0c00 	rsbeq	r0, sl, r0, lsl #24
    3298:	000e7b01 	andeq	r7, lr, r1, lsl #22
    329c:	02000001 	andeq	r0, r0, #1
    32a0:	90127091 	mulsls	r2, r1, r0
    32a4:	600000aa 	andvs	r0, r0, sl, lsr #1
    32a8:	0c000000 	stceq	0, cr0, [r0], {-0}
    32ac:	7c010063 	stcvc	0, cr0, [r1], {99}	; 0x63
    32b0:	00006d0e 	andeq	r6, r0, lr, lsl #26
    32b4:	6f910200 	svcvs	0x00910200
    32b8:	10000000 	andne	r0, r0, r0
    32bc:	0000198e 	andeq	r1, r0, lr, lsl #19
    32c0:	0b074201 	bleq	1d3acc <__bss_end+0x1c7bc4>
    32c4:	f7000019 			; <UNDEFINED> instruction: 0xf7000019
    32c8:	e8000004 	stmda	r0, {r2}
    32cc:	b40000a6 	strlt	r0, [r0], #-166	; 0xffffff5a
    32d0:	01000002 	tsteq	r0, r2
    32d4:	0004f79c 	muleq	r4, ip, r7
    32d8:	00730b00 	rsbseq	r0, r3, r0, lsl #22
    32dc:	fa184201 	blx	613ae8 <__bss_end+0x607be0>
    32e0:	02000000 	andeq	r0, r0, #0
    32e4:	610c5c91 			; <UNDEFINED> instruction: 0x610c5c91
    32e8:	0b430100 	bleq	10c36f0 <__bss_end+0x10b77e8>
    32ec:	000004f7 	strdeq	r0, [r0], -r7
    32f0:	0c749102 	ldfeqp	f1, [r4], #-8
    32f4:	44010065 	strmi	r0, [r1], #-101	; 0xffffff9b
    32f8:	00010009 	andeq	r0, r1, r9
    32fc:	70910200 	addsvc	r0, r1, r0, lsl #4
    3300:	0100630c 	tsteq	r0, ip, lsl #6
    3304:	01000945 	tsteq	r0, r5, asr #18
    3308:	91020000 	mrsls	r0, (UNDEF: 2)
    330c:	a830126c 	ldmdage	r0!, {r2, r3, r5, r6, r9, ip}
    3310:	00e00000 	rsceq	r0, r0, r0
    3314:	0e0d0000 	cdpeq	0, 0, cr0, cr13, cr0, {0}
    3318:	0100001a 	tsteq	r0, sl, lsl r0
    331c:	01000d50 	tsteq	r0, r0, asr sp
    3320:	91020000 	mrsls	r0, (UNDEF: 2)
    3324:	00690c68 	rsbeq	r0, r9, r8, ror #24
    3328:	000d5101 	andeq	r5, sp, r1, lsl #2
    332c:	02000001 	andeq	r0, r0, #1
    3330:	00006491 	muleq	r0, r1, r4
    3334:	d9040408 	stmdble	r4, {r3, sl}
    3338:	1600001d 			; <UNDEFINED> instruction: 0x1600001d
    333c:	000018e3 	andeq	r1, r0, r3, ror #17
    3340:	44060f01 	strmi	r0, [r6], #-3841	; 0xfffff0ff
    3344:	c800001a 	stmdagt	r0, {r1, r3, r4}
    3348:	200000a3 	andcs	r0, r0, r3, lsr #1
    334c:	01000003 	tsteq	r0, r3
    3350:	00059f9c 	muleq	r5, ip, pc	; <UNPREDICTABLE>
    3354:	00660b00 	rsbeq	r0, r6, r0, lsl #22
    3358:	f7110f01 			; <UNDEFINED> instruction: 0xf7110f01
    335c:	03000004 	movweq	r0, #4
    3360:	0b7fa491 	bleq	1fec5ac <__bss_end+0x1fe06a4>
    3364:	0f010072 	svceq	0x00010072
    3368:	0002101a 	andeq	r1, r2, sl, lsl r0
    336c:	a0910300 	addsge	r0, r1, r0, lsl #6
    3370:	0f9d0d7f 	svceq	0x009d0d7f
    3374:	10010000 	andne	r0, r1, r0
    3378:	00059f13 	andeq	r9, r5, r3, lsl pc
    337c:	b0910300 	addslt	r0, r1, r0, lsl #6
    3380:	19d10d7f 	ldmibne	r1, {r0, r1, r2, r3, r4, r5, r6, r8, sl, fp}^
    3384:	10010000 	andne	r0, r1, r0
    3388:	00059f1b 	andeq	r9, r5, fp, lsl pc
    338c:	58910200 	ldmpl	r1, {r9}
    3390:	0100690c 	tsteq	r0, ip, lsl #18
    3394:	059f2410 	ldreq	r2, [pc, #1040]	; 37ac <shift+0x37ac>
    3398:	91020000 	mrsls	r0, (UNDEF: 2)
    339c:	15e40d50 	strbne	r0, [r4, #3408]!	; 0xd50
    33a0:	10010000 	andne	r0, r1, r0
    33a4:	00059f27 	andeq	r9, r5, r7, lsr #30
    33a8:	48910200 	ldmmi	r1, {r9}
    33ac:	00197c0d 	andseq	r7, r9, sp, lsl #24
    33b0:	2f100100 	svccs	0x00100100
    33b4:	0000059f 	muleq	r0, pc, r5	; <UNPREDICTABLE>
    33b8:	7fa89103 	svcvc	0x00a89103
    33bc:	001a0e0d 	andseq	r0, sl, sp, lsl #28
    33c0:	39100100 	ldmdbcc	r0, {r8}
    33c4:	0000059f 	muleq	r0, pc, r5	; <UNPREDICTABLE>
    33c8:	0d409102 	stfeqp	f1, [r0, #-8]
    33cc:	000019bc 			; <UNDEFINED> instruction: 0x000019bc
    33d0:	f70b1101 			; <UNDEFINED> instruction: 0xf70b1101
    33d4:	03000004 	movweq	r0, #4
    33d8:	007fbc91 			; <UNDEFINED> instruction: 0x007fbc91
    33dc:	7f050808 	svcvc	0x00050808
    33e0:	17000003 	strne	r0, [r0, -r3]
    33e4:	00001a09 	andeq	r1, r0, r9, lsl #20
    33e8:	ab050701 	blge	144ff4 <__bss_end+0x1390ec>
    33ec:	00000019 	andeq	r0, r0, r9, lsl r0
    33f0:	60000001 	andvs	r0, r0, r1
    33f4:	680000a3 	stmdavs	r0, {r0, r1, r5, r7}
    33f8:	01000000 	mrseq	r0, (UNDEF: 0)
    33fc:	15e4159c 	strbne	r1, [r4, #1436]!	; 0x59c
    3400:	07010000 	streq	r0, [r1, -r0]
    3404:	0001000e 	andeq	r0, r1, lr
    3408:	6c910200 	lfmvs	f0, 4, [r1], {0}
    340c:	00162715 	andseq	r2, r6, r5, lsl r7
    3410:	1a070100 	bne	1c3818 <__bss_end+0x1b7910>
    3414:	00000100 	andeq	r0, r0, r0, lsl #2
    3418:	0d689102 	stfeqp	f1, [r8, #-8]!
    341c:	000000b9 	strheq	r0, [r0], -r9
    3420:	00090801 	andeq	r0, r9, r1, lsl #16
    3424:	02000001 	andeq	r0, r0, #1
    3428:	00007491 	muleq	r0, r1, r4
    342c:	00000022 	andeq	r0, r0, r2, lsr #32
    3430:	0f330002 	svceq	0x00330002
    3434:	01040000 	mrseq	r0, (UNDEF: 4)
    3438:	00001573 	andeq	r1, r0, r3, ror r5
    343c:	0000b1fc 	strdeq	fp, [r0], -ip
    3440:	0000b408 	andeq	fp, r0, r8, lsl #8
    3444:	00001a56 	andeq	r1, r0, r6, asr sl
    3448:	00001a86 	andeq	r1, r0, r6, lsl #21
    344c:	00001aeb 	andeq	r1, r0, fp, ror #21
    3450:	00228001 	eoreq	r8, r2, r1
    3454:	00020000 	andeq	r0, r2, r0
    3458:	00000f47 	andeq	r0, r0, r7, asr #30
    345c:	15f00104 	ldrbne	r0, [r0, #260]!	; 0x104
    3460:	b4080000 	strlt	r0, [r8], #-0
    3464:	b6480000 	strblt	r0, [r8], -r0
    3468:	1a560000 	bne	1583470 <__bss_end+0x1577568>
    346c:	1a860000 	bne	fe183474 <__bss_end+0xfe17756c>
    3470:	1aeb0000 	bne	ffac3478 <__bss_end+0xffab7570>
    3474:	80010000 	andhi	r0, r1, r0
    3478:	00000022 	andeq	r0, r0, r2, lsr #32
    347c:	0f5b0002 	svceq	0x005b0002
    3480:	01040000 	mrseq	r0, (UNDEF: 4)
    3484:	00001679 	andeq	r1, r0, r9, ror r6
    3488:	0000b648 	andeq	fp, r0, r8, asr #12
    348c:	0000b64c 	andeq	fp, r0, ip, asr #12
    3490:	00001a56 	andeq	r1, r0, r6, asr sl
    3494:	00001a86 	andeq	r1, r0, r6, lsl #21
    3498:	00001aeb 	andeq	r1, r0, fp, ror #21
    349c:	00228001 	eoreq	r8, r2, r1
    34a0:	00020000 	andeq	r0, r2, r0
    34a4:	00000f6f 	andeq	r0, r0, pc, ror #30
    34a8:	16d90104 	ldrbne	r0, [r9], r4, lsl #2
    34ac:	b64c0000 	strblt	r0, [ip], -r0
    34b0:	b89c0000 	ldmlt	ip, {}	; <UNPREDICTABLE>
    34b4:	1af70000 	bne	ffdc34bc <__bss_end+0xffdb75b4>
    34b8:	1a860000 	bne	fe1834c0 <__bss_end+0xfe1775b8>
    34bc:	1aeb0000 	bne	ffac34c4 <__bss_end+0xffab75bc>
    34c0:	80010000 	andhi	r0, r1, r0
    34c4:	00000022 	andeq	r0, r0, r2, lsr #32
    34c8:	0f830002 	svceq	0x00830002
    34cc:	01040000 	mrseq	r0, (UNDEF: 4)
    34d0:	000017d8 	ldrdeq	r1, [r0], -r8
    34d4:	0000b89c 	muleq	r0, ip, r8
    34d8:	0000b970 	andeq	fp, r0, r0, ror r9
    34dc:	00001b28 	andeq	r1, r0, r8, lsr #22
    34e0:	00001a86 	andeq	r1, r0, r6, lsl #21
    34e4:	00001aeb 	andeq	r1, r0, fp, ror #21
    34e8:	0a098001 	beq	2634f4 <__bss_end+0x2575ec>
    34ec:	00040000 	andeq	r0, r4, r0
    34f0:	00000f97 	muleq	r0, r7, pc	; <UNPREDICTABLE>
    34f4:	2be80104 	blcs	ffa0390c <__bss_end+0xff9f7a04>
    34f8:	2a0c0000 	bcs	303500 <__bss_end+0x2f75f8>
    34fc:	8600001e 			; <UNDEFINED> instruction: 0x8600001e
    3500:	5600001a 			; <UNDEFINED> instruction: 0x5600001a
    3504:	02000018 	andeq	r0, r0, #24
    3508:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    350c:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    3510:	001f8e07 	andseq	r8, pc, r7, lsl #28
    3514:	05080300 	streq	r0, [r8, #-768]	; 0xfffffd00
    3518:	0000037f 	andeq	r0, r0, pc, ror r3
    351c:	2f040803 	svccs	0x00040803
    3520:	04000027 	streq	r0, [r0], #-39	; 0xffffffd9
    3524:	00001e97 	muleq	r0, r7, lr
    3528:	24162a01 	ldrcs	r2, [r6], #-2561	; 0xfffff5ff
    352c:	04000000 	streq	r0, [r0], #-0
    3530:	000022fa 	strdeq	r2, [r0], -sl
    3534:	51152f01 	tstpl	r5, r1, lsl #30
    3538:	05000000 	streq	r0, [r0, #-0]
    353c:	00005704 	andeq	r5, r0, r4, lsl #14
    3540:	00390600 	eorseq	r0, r9, r0, lsl #12
    3544:	00660000 	rsbeq	r0, r6, r0
    3548:	66070000 	strvs	r0, [r7], -r0
    354c:	00000000 	andeq	r0, r0, r0
    3550:	006c0405 	rsbeq	r0, ip, r5, lsl #8
    3554:	04080000 	streq	r0, [r8], #-0
    3558:	00002b99 	muleq	r0, r9, fp
    355c:	790f3601 	stmdbvc	pc, {r0, r9, sl, ip, sp}	; <UNPREDICTABLE>
    3560:	05000000 	streq	r0, [r0, #-0]
    3564:	00007f04 	andeq	r7, r0, r4, lsl #30
    3568:	001d0600 	andseq	r0, sp, r0, lsl #12
    356c:	00930000 	addseq	r0, r3, r0
    3570:	66070000 	strvs	r0, [r7], -r0
    3574:	07000000 	streq	r0, [r0, -r0]
    3578:	00000066 	andeq	r0, r0, r6, rrx
    357c:	08010300 	stmdaeq	r1, {r8, r9}
    3580:	00001084 	andeq	r1, r0, r4, lsl #1
    3584:	00255d09 	eoreq	r5, r5, r9, lsl #26
    3588:	12bb0100 	adcsne	r0, fp, #0, 2
    358c:	00000045 	andeq	r0, r0, r5, asr #32
    3590:	002bc709 	eoreq	ip, fp, r9, lsl #14
    3594:	10be0100 	adcsne	r0, lr, r0, lsl #2
    3598:	0000006d 	andeq	r0, r0, sp, rrx
    359c:	86060103 	strhi	r0, [r6], -r3, lsl #2
    35a0:	0a000010 	beq	35e8 <shift+0x35e8>
    35a4:	00002201 	andeq	r2, r0, r1, lsl #4
    35a8:	00930107 	addseq	r0, r3, r7, lsl #2
    35ac:	17020000 	strne	r0, [r2, -r0]
    35b0:	0001e606 	andeq	lr, r1, r6, lsl #12
    35b4:	1cfe0b00 	vldmiane	lr!, {d16-d15}
    35b8:	0b000000 	bleq	35c0 <shift+0x35c0>
    35bc:	000020f9 	strdeq	r2, [r0], -r9
    35c0:	26550b01 	ldrbcs	r0, [r5], -r1, lsl #22
    35c4:	0b020000 	bleq	835cc <__bss_end+0x776c4>
    35c8:	00002add 	ldrdeq	r2, [r0], -sp
    35cc:	25e10b03 	strbcs	r0, [r1, #2819]!	; 0xb03
    35d0:	0b040000 	bleq	1035d8 <__bss_end+0xf76d0>
    35d4:	000029a4 	andeq	r2, r0, r4, lsr #19
    35d8:	28ca0b05 	stmiacs	sl, {r0, r2, r8, r9, fp}^
    35dc:	0b060000 	bleq	1835e4 <__bss_end+0x1776dc>
    35e0:	00001d1f 	andeq	r1, r0, pc, lsl sp
    35e4:	29b90b07 	ldmibcs	r9!, {r0, r1, r2, r8, r9, fp}
    35e8:	0b080000 	bleq	2035f0 <__bss_end+0x1f76e8>
    35ec:	000029c7 	andeq	r2, r0, r7, asr #19
    35f0:	2ab80b09 	bcs	fee0621c <__bss_end+0xfedfa314>
    35f4:	0b0a0000 	bleq	2835fc <__bss_end+0x2776f4>
    35f8:	00002523 	andeq	r2, r0, r3, lsr #10
    35fc:	1ed80b0b 	vfnmsne.f64	d16, d8, d11
    3600:	0b0c0000 	bleq	303608 <__bss_end+0x2f7700>
    3604:	0000228a 	andeq	r2, r0, sl, lsl #5
    3608:	2a100b0d 	bcs	406244 <__bss_end+0x3fa33c>
    360c:	0b0e0000 	bleq	383614 <__bss_end+0x37770c>
    3610:	00002245 	andeq	r2, r0, r5, asr #4
    3614:	225b0b0f 	subscs	r0, fp, #15360	; 0x3c00
    3618:	0b100000 	bleq	403620 <__bss_end+0x3f7718>
    361c:	00002130 	andeq	r2, r0, r0, lsr r1
    3620:	25c50b11 	strbcs	r0, [r5, #2833]	; 0xb11
    3624:	0b120000 	bleq	48362c <__bss_end+0x477724>
    3628:	000021bd 			; <UNDEFINED> instruction: 0x000021bd
    362c:	2e750b13 	vmovcs.s8	r0, d5[4]
    3630:	0b140000 	bleq	503638 <__bss_end+0x4f7730>
    3634:	0000268d 	andeq	r2, r0, sp, lsl #13
    3638:	23ea0b15 	mvncs	r0, #21504	; 0x5400
    363c:	0b160000 	bleq	583644 <__bss_end+0x57773c>
    3640:	00001d7c 	andeq	r1, r0, ip, ror sp
    3644:	2b000b17 	blcs	62a8 <shift+0x62a8>
    3648:	0b180000 	bleq	603650 <__bss_end+0x5f7748>
    364c:	00002d0a 	andeq	r2, r0, sl, lsl #26
    3650:	2b0e0b19 	blcs	3862bc <__bss_end+0x37a3b4>
    3654:	0b1a0000 	bleq	68365c <__bss_end+0x677754>
    3658:	0000220d 	andeq	r2, r0, sp, lsl #4
    365c:	2b1c0b1b 	blcs	7062d0 <__bss_end+0x6fa3c8>
    3660:	0b1c0000 	bleq	703668 <__bss_end+0x6f7760>
    3664:	00001bd8 	ldrdeq	r1, [r0], -r8
    3668:	2b2a0b1d 	blcs	a862e4 <__bss_end+0xa7a3dc>
    366c:	0b1e0000 	bleq	783674 <__bss_end+0x77776c>
    3670:	00002b38 	andeq	r2, r0, r8, lsr fp
    3674:	1b710b1f 	blne	1c462f8 <__bss_end+0x1c3a3f0>
    3678:	0b200000 	bleq	803680 <__bss_end+0x7f7778>
    367c:	000027b0 			; <UNDEFINED> instruction: 0x000027b0
    3680:	25970b21 	ldrcs	r0, [r7, #2849]	; 0xb21
    3684:	0b220000 	bleq	88368c <__bss_end+0x877784>
    3688:	00002af3 	strdeq	r2, [r0], -r3
    368c:	24670b23 	strbtcs	r0, [r7], #-2851	; 0xfffff4dd
    3690:	0b240000 	bleq	903698 <__bss_end+0x8f7790>
    3694:	000028bb 			; <UNDEFINED> instruction: 0x000028bb
    3698:	235d0b25 	cmpcs	sp, #37888	; 0x9400
    369c:	0b260000 	bleq	9836a4 <__bss_end+0x97779c>
    36a0:	00002039 	andeq	r2, r0, r9, lsr r0
    36a4:	237b0b27 	cmncs	fp, #39936	; 0x9c00
    36a8:	0b280000 	bleq	a036b0 <__bss_end+0x9f77a8>
    36ac:	000020d5 	ldrdeq	r2, [r0], -r5
    36b0:	238b0b29 	orrcs	r0, fp, #41984	; 0xa400
    36b4:	0b2a0000 	bleq	a836bc <__bss_end+0xa777b4>
    36b8:	00002509 	andeq	r2, r0, r9, lsl #10
    36bc:	23040b2b 	movwcs	r0, #19243	; 0x4b2b
    36c0:	0b2c0000 	bleq	b036c8 <__bss_end+0xaf77c0>
    36c4:	000027cf 	andeq	r2, r0, pc, asr #15
    36c8:	207a0b2d 	rsbscs	r0, sl, sp, lsr #22
    36cc:	002e0000 	eoreq	r0, lr, r0
    36d0:	0022970a 	eoreq	r9, r2, sl, lsl #14
    36d4:	93010700 	movwls	r0, #5888	; 0x1700
    36d8:	03000000 	movweq	r0, #0
    36dc:	049f0617 	ldreq	r0, [pc], #1559	; 36e4 <shift+0x36e4>
    36e0:	ec0b0000 	stc	0, cr0, [fp], {-0}
    36e4:	0000001e 	andeq	r0, r0, lr, lsl r0
    36e8:	002d9e0b 	eoreq	r9, sp, fp, lsl #28
    36ec:	fc0b0100 	stc2	1, cr0, [fp], {-0}
    36f0:	0200001e 	andeq	r0, r0, #30
    36f4:	001f1f0b 	andseq	r1, pc, fp, lsl #30
    36f8:	d70b0300 	strle	r0, [fp, -r0, lsl #6]
    36fc:	0400002b 	streq	r0, [r0], #-43	; 0xffffffd5
    3700:	0028350b 	eoreq	r3, r8, fp, lsl #10
    3704:	a90b0500 	stmdbge	fp, {r8, sl}
    3708:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
    370c:	00211e0b 	eoreq	r1, r1, fp, lsl #28
    3710:	2f0b0700 	svccs	0x000b0700
    3714:	0800001f 	stmdaeq	r0, {r0, r1, r2, r3, r4}
    3718:	002e640b 	eoreq	r6, lr, fp, lsl #8
    371c:	4f0b0900 	svcmi	0x000b0900
    3720:	0a00001c 	beq	3798 <shift+0x3798>
    3724:	002d8d0b 	eoreq	r8, sp, fp, lsl #26
    3728:	760b0b00 	strvc	r0, [fp], -r0, lsl #22
    372c:	0c000024 	stceq	0, cr0, [r0], {36}	; 0x24
    3730:	002d210b 	eoreq	r2, sp, fp, lsl #2
    3734:	bd0b0d00 	stclt	13, cr0, [fp, #-0]
    3738:	0e000027 	cdpeq	0, 0, cr0, cr0, cr7, {1}
    373c:	002a560b 	eoreq	r5, sl, fp, lsl #12
    3740:	0a0b0f00 	beq	2c7348 <__bss_end+0x2bb440>
    3744:	10000020 	andne	r0, r0, r0, lsr #32
    3748:	001f0c0b 	andseq	r0, pc, fp, lsl #24
    374c:	750b1100 	strvc	r1, [fp, #-256]	; 0xffffff00
    3750:	12000027 	andne	r0, r0, #39	; 0x27
    3754:	001ff50b 	andseq	pc, pc, fp, lsl #10
    3758:	7c0b1300 	stcvc	3, cr1, [fp], {-0}
    375c:	1400002d 	strne	r0, [r0], #-45	; 0xffffffd3
    3760:	001c790b 	andseq	r7, ip, fp, lsl #18
    3764:	c50b1500 	strgt	r1, [fp, #-1280]	; 0xfffffb00
    3768:	16000023 	strne	r0, [r0], -r3, lsr #32
    376c:	001f3f0b 	andseq	r3, pc, fp, lsl #30
    3770:	160b1700 	strne	r1, [fp], -r0, lsl #14
    3774:	1800001c 	stmdane	r0, {r2, r3, r4}
    3778:	002e0a0b 	eoreq	r0, lr, fp, lsl #20
    377c:	c50b1900 	strgt	r1, [fp, #-2304]	; 0xfffff700
    3780:	1a00002a 	bne	3830 <shift+0x3830>
    3784:	0028d90b 	eoreq	sp, r8, fp, lsl #18
    3788:	3d0b1b00 	vstrcc	d1, [fp, #-0]
    378c:	1c00002a 	stcne	0, cr0, [r0], {42}	; 0x2a
    3790:	002ba10b 	eoreq	sl, fp, fp, lsl #2
    3794:	5f0b1d00 	svcpl	0x000b1d00
    3798:	1e00001f 	mcrne	0, 0, r0, cr0, cr15, {0}
    379c:	001cea0b 	andseq	lr, ip, fp, lsl #20
    37a0:	f20b1f00 	vmax.f32	d1, d11, d0
    37a4:	20000028 	andcs	r0, r0, r8, lsr #32
    37a8:	0020560b 	eoreq	r5, r0, fp, lsl #12
    37ac:	470b2100 	strmi	r2, [fp, -r0, lsl #2]
    37b0:	22000028 	andcs	r0, r0, #40	; 0x28
    37b4:	0024470b 	eoreq	r4, r4, fp, lsl #14
    37b8:	4f0b2300 	svcmi	0x000b2300
    37bc:	2400001f 	strcs	r0, [r0], #-31	; 0xffffffe1
    37c0:	0029f50b 	eoreq	pc, r9, fp, lsl #10
    37c4:	620b2500 	andvs	r2, fp, #0, 10
    37c8:	2600001e 			; <UNDEFINED> instruction: 0x2600001e
    37cc:	002b860b 	eoreq	r8, fp, fp, lsl #12
    37d0:	510b2700 	tstpl	fp, r0, lsl #14
    37d4:	2800002e 	stmdacs	r0, {r1, r2, r3, r5}
    37d8:	0027480b 	eoreq	r4, r7, fp, lsl #16
    37dc:	ef0b2900 	svc	0x000b2900
    37e0:	2a000021 	bcs	386c <shift+0x386c>
    37e4:	00291c0b 	eoreq	r1, r9, fp, lsl #24
    37e8:	a50b2b00 	strge	r2, [fp, #-2816]	; 0xfffff500
    37ec:	2c000024 	stccs	0, cr0, [r0], {36}	; 0x24
    37f0:	001d3d0b 	andseq	r3, sp, fp, lsl #26
    37f4:	c10b2d00 	tstgt	fp, r0, lsl #26
    37f8:	2e00001c 	mcrcs	0, 0, r0, cr0, cr12, {0}
    37fc:	002cdf0b 	eoreq	sp, ip, fp, lsl #30
    3800:	330b2f00 	movwcc	r2, #48896	; 0xbf00
    3804:	30000024 	andcc	r0, r0, r4, lsr #32
    3808:	001fcf0b 	andseq	ip, pc, fp, lsl #30
    380c:	120b3100 	andne	r3, fp, #0, 2
    3810:	32000024 	andcc	r0, r0, #36	; 0x24
    3814:	0026c10b 	eoreq	ip, r6, fp, lsl #2
    3818:	af0b3300 	svcge	0x000b3300
    381c:	3400001c 	strcc	r0, [r0], #-28	; 0xffffffe4
    3820:	002e3f0b 	eoreq	r3, lr, fp, lsl #30
    3824:	f60b3500 			; <UNDEFINED> instruction: 0xf60b3500
    3828:	36000024 	strcc	r0, [r0], -r4, lsr #32
    382c:	0021880b 	eoreq	r8, r1, fp, lsl #16
    3830:	330b3700 	movwcc	r3, #46848	; 0xb700
    3834:	38000025 	stmdacc	r0, {r0, r2, r5}
    3838:	002d470b 	eoreq	r4, sp, fp, lsl #14
    383c:	f40b3900 	vst2.8	{d3,d5}, [fp], r0
    3840:	3a00001d 	bcc	38bc <shift+0x38bc>
    3844:	00219b0b 	eoreq	r9, r1, fp, lsl #22
    3848:	670b3b00 	strvs	r3, [fp, -r0, lsl #22]
    384c:	3c000021 	stccc	0, cr0, [r0], {33}	; 0x21
    3850:	001b800b 	andseq	r8, fp, fp
    3854:	880b3d00 	stmdahi	fp, {r8, sl, fp, ip, sp}
    3858:	3e000024 	cdpcc	0, 0, cr0, cr0, cr4, {1}
    385c:	0022670b 	eoreq	r6, r2, fp, lsl #14
    3860:	080b3f00 	stmdaeq	fp, {r8, r9, sl, fp, ip, sp}
    3864:	4000001d 	andmi	r0, r0, sp, lsl r0
    3868:	002cf30b 	eoreq	pc, ip, fp, lsl #6
    386c:	d80b4100 	stmdale	fp, {r8, lr}
    3870:	42000023 	andmi	r0, r0, #35	; 0x23
    3874:	0021510b 	eoreq	r5, r1, fp, lsl #2
    3878:	c10b4300 	mrsgt	r4, (UNDEF: 59)
    387c:	4400001b 	strmi	r0, [r0], #-27	; 0xffffffe5
    3880:	0023350b 	eoreq	r3, r3, fp, lsl #10
    3884:	210b4500 	tstcs	fp, r0, lsl #10
    3888:	46000023 	strmi	r0, [r0], -r3, lsr #32
    388c:	00289c0b 	eoreq	r9, r8, fp, lsl #24
    3890:	640b4700 	strvs	r4, [fp], #-1792	; 0xfffff900
    3894:	48000029 	stmdami	r0, {r0, r3, r5}
    3898:	002cbe0b 	eoreq	fp, ip, fp, lsl #28
    389c:	870b4900 	strhi	r4, [fp, -r0, lsl #18]
    38a0:	4a000020 	bmi	3928 <shift+0x3928>
    38a4:	0026770b 	eoreq	r7, r6, fp, lsl #14
    38a8:	310b4b00 	tstcc	fp, r0, lsl #22
    38ac:	4c000029 	stcmi	0, cr0, [r0], {41}	; 0x29
    38b0:	0027de0b 	eoreq	sp, r7, fp, lsl #28
    38b4:	f20b4d00 	vadd.f32	d4, d11, d0
    38b8:	4e000027 	cdpmi	0, 0, cr0, cr0, cr7, {1}
    38bc:	0028060b 	eoreq	r0, r8, fp, lsl #12
    38c0:	820b4f00 	andhi	r4, fp, #0, 30
    38c4:	5000001e 	andpl	r0, r0, lr, lsl r0
    38c8:	001ddf0b 	andseq	sp, sp, fp, lsl #30
    38cc:	070b5100 	streq	r5, [fp, -r0, lsl #2]
    38d0:	5200001e 	andpl	r0, r0, #30
    38d4:	002a680b 	eoreq	r6, sl, fp, lsl #16
    38d8:	4d0b5300 	stcmi	3, cr5, [fp, #-0]
    38dc:	5400001e 	strpl	r0, [r0], #-30	; 0xffffffe2
    38e0:	002a7c0b 	eoreq	r7, sl, fp, lsl #24
    38e4:	900b5500 	andls	r5, fp, r0, lsl #10
    38e8:	5600002a 	strpl	r0, [r0], -sl, lsr #32
    38ec:	002aa40b 	eoreq	sl, sl, fp, lsl #8
    38f0:	e10b5700 	tst	fp, r0, lsl #14
    38f4:	5800001f 	stmdapl	r0, {r0, r1, r2, r3, r4}
    38f8:	001fbb0b 	andseq	fp, pc, fp, lsl #22
    38fc:	490b5900 	stmdbmi	fp, {r8, fp, ip, lr}
    3900:	5a000023 	bpl	3994 <shift+0x3994>
    3904:	0025460b 	eoreq	r4, r5, fp, lsl #12
    3908:	cf0b5b00 	svcgt	0x000b5b00
    390c:	5c000022 	stcpl	0, cr0, [r0], {34}	; 0x22
    3910:	001b540b 	andseq	r5, fp, fp, lsl #8
    3914:	090b5d00 	stmdbeq	fp, {r8, sl, fp, ip, lr}
    3918:	5e000021 	cdppl	0, 0, cr0, cr0, cr1, {1}
    391c:	00256f0b 	eoreq	r6, r5, fp, lsl #30
    3920:	9b0b5f00 	blls	2db528 <__bss_end+0x2cf620>
    3924:	60000023 	andvs	r0, r0, r3, lsr #32
    3928:	00285a0b 	eoreq	r5, r8, fp, lsl #20
    392c:	bc0b6100 	stflts	f6, [fp], {-0}
    3930:	6200002d 	andvs	r0, r0, #45	; 0x2d
    3934:	0026620b 	eoreq	r6, r6, fp, lsl #4
    3938:	ac0b6300 	stcge	3, cr6, [fp], {-0}
    393c:	64000020 	strvs	r0, [r0], #-32	; 0xffffffe0
    3940:	001c280b 	andseq	r2, ip, fp, lsl #16
    3944:	e60b6500 	str	r6, [fp], -r0, lsl #10
    3948:	6600001b 			; <UNDEFINED> instruction: 0x6600001b
    394c:	0025a70b 	eoreq	sl, r5, fp, lsl #14
    3950:	e20b6700 	and	r6, fp, #0, 14
    3954:	68000026 	stmdavs	r0, {r1, r2, r5}
    3958:	00287e0b 	eoreq	r7, r8, fp, lsl #28
    395c:	b00b6900 	andlt	r6, fp, r0, lsl #18
    3960:	6a000023 	bvs	39f4 <shift+0x39f4>
    3964:	002df50b 	eoreq	pc, sp, fp, lsl #10
    3968:	c60b6b00 	strgt	r6, [fp], -r0, lsl #22
    396c:	6c000024 	stcvs	0, cr0, [r0], {36}	; 0x24
    3970:	001ba50b 	andseq	sl, fp, fp, lsl #10
    3974:	d50b6d00 	strle	r6, [fp, #-3328]	; 0xfffff300
    3978:	6e00001c 	mcrvs	0, 0, r0, cr0, cr12, {0}
    397c:	0020c00b 	eoreq	ip, r0, fp
    3980:	700b6f00 	andvc	r6, fp, r0, lsl #30
    3984:	7000001f 	andvc	r0, r0, pc, lsl r0
    3988:	07020300 	streq	r0, [r2, -r0, lsl #6]
    398c:	000011d2 	ldrdeq	r1, [r0], -r2
    3990:	0004bc0c 	andeq	fp, r4, ip, lsl #24
    3994:	0004b100 	andeq	fp, r4, r0, lsl #2
    3998:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    399c:	000004a6 	andeq	r0, r0, r6, lsr #9
    39a0:	04c80405 	strbeq	r0, [r8], #1029	; 0x405
    39a4:	b60e0000 	strlt	r0, [lr], -r0
    39a8:	03000004 	movweq	r0, #4
    39ac:	108d0801 	addne	r0, sp, r1, lsl #16
    39b0:	c10e0000 	mrsgt	r0, (UNDEF: 14)
    39b4:	0f000004 	svceq	0x00000004
    39b8:	00001d6d 	andeq	r1, r0, sp, ror #26
    39bc:	1a014404 	bne	549d4 <__bss_end+0x48acc>
    39c0:	000004b1 			; <UNDEFINED> instruction: 0x000004b1
    39c4:	0021410f 	eoreq	r4, r1, pc, lsl #2
    39c8:	01790400 	cmneq	r9, r0, lsl #8
    39cc:	0004b11a 	andeq	fp, r4, sl, lsl r1
    39d0:	04c10c00 	strbeq	r0, [r1], #3072	; 0xc00
    39d4:	04f20000 	ldrbteq	r0, [r2], #0
    39d8:	000d0000 	andeq	r0, sp, r0
    39dc:	00236d09 	eoreq	r6, r3, r9, lsl #26
    39e0:	0d2d0500 	cfstr32eq	mvfx0, [sp, #-0]
    39e4:	000004e7 	andeq	r0, r0, r7, ror #9
    39e8:	002b6209 	eoreq	r6, fp, r9, lsl #4
    39ec:	1c350500 	cfldr32ne	mvfx0, [r5], #-0
    39f0:	000001e6 	andeq	r0, r0, r6, ror #3
    39f4:	00201d0a 	eoreq	r1, r0, sl, lsl #26
    39f8:	93010700 	movwls	r0, #5888	; 0x1700
    39fc:	05000000 	streq	r0, [r0, #-0]
    3a00:	057d0e37 	ldrbeq	r0, [sp, #-3639]!	; 0xfffff1c9
    3a04:	ba0b0000 	blt	2c3a0c <__bss_end+0x2b7b04>
    3a08:	0000001b 	andeq	r0, r0, fp, lsl r0
    3a0c:	0022540b 	eoreq	r5, r2, fp, lsl #8
    3a10:	590b0100 	stmdbpl	fp, {r8}
    3a14:	0200002d 	andeq	r0, r0, #45	; 0x2d
    3a18:	002d340b 	eoreq	r3, sp, fp, lsl #8
    3a1c:	100b0300 	andne	r0, fp, r0, lsl #6
    3a20:	04000026 	streq	r0, [r0], #-38	; 0xffffffda
    3a24:	0029b20b 	eoreq	fp, r9, fp, lsl #4
    3a28:	b00b0500 	andlt	r0, fp, r0, lsl #10
    3a2c:	0600001d 			; <UNDEFINED> instruction: 0x0600001d
    3a30:	001d920b 	andseq	r9, sp, fp, lsl #4
    3a34:	e50b0700 	str	r0, [fp, #-1792]	; 0xfffff900
    3a38:	0800001e 	stmdaeq	r0, {r1, r2, r3, r4}
    3a3c:	00249e0b 	eoreq	r9, r4, fp, lsl #28
    3a40:	b70b0900 	strlt	r0, [fp, -r0, lsl #18]
    3a44:	0a00001d 	beq	3ac0 <shift+0x3ac0>
    3a48:	001e230b 	andseq	r2, lr, fp, lsl #6
    3a4c:	1c0b0b00 			; <UNDEFINED> instruction: 0x1c0b0b00
    3a50:	0c00001e 	stceq	0, cr0, [r0], {30}
    3a54:	001da90b 	andseq	sl, sp, fp, lsl #18
    3a58:	090b0d00 	stmdbeq	fp, {r8, sl, fp}
    3a5c:	0e00002a 	cdpeq	0, 0, cr0, cr0, cr10, {1}
    3a60:	0027000b 	eoreq	r0, r7, fp
    3a64:	04000f00 	streq	r0, [r0], #-3840	; 0xfffff100
    3a68:	000028b4 			; <UNDEFINED> instruction: 0x000028b4
    3a6c:	0a013c05 	beq	52a88 <__bss_end+0x46b80>
    3a70:	09000005 	stmdbeq	r0, {r0, r2}
    3a74:	00002985 	andeq	r2, r0, r5, lsl #19
    3a78:	7d0f3e05 	stcvc	14, cr3, [pc, #-20]	; 3a6c <shift+0x3a6c>
    3a7c:	09000005 	stmdbeq	r0, {r0, r2}
    3a80:	00002a2c 	andeq	r2, r0, ip, lsr #20
    3a84:	1d0c4705 	stcne	7, cr4, [ip, #-20]	; 0xffffffec
    3a88:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    3a8c:	00001d5d 	andeq	r1, r0, sp, asr sp
    3a90:	1d0c4805 	stcne	8, cr4, [ip, #-20]	; 0xffffffec
    3a94:	10000000 	andne	r0, r0, r0
    3a98:	00002b46 	andeq	r2, r0, r6, asr #22
    3a9c:	00299409 	eoreq	r9, r9, r9, lsl #8
    3aa0:	14490500 	strbne	r0, [r9], #-1280	; 0xfffffb00
    3aa4:	000005be 			; <UNDEFINED> instruction: 0x000005be
    3aa8:	05ad0405 	streq	r0, [sp, #1029]!	; 0x405
    3aac:	09110000 	ldmdbeq	r1, {}	; <UNPREDICTABLE>
    3ab0:	0000221e 	andeq	r2, r0, lr, lsl r2
    3ab4:	d10f4b05 	tstle	pc, r5, lsl #22
    3ab8:	05000005 	streq	r0, [r0, #-5]
    3abc:	0005c404 	andeq	ip, r5, r4, lsl #8
    3ac0:	29071200 	stmdbcs	r7, {r9, ip}
    3ac4:	fd090000 	stc2	0, cr0, [r9, #-0]
    3ac8:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    3acc:	05e80d4f 	strbeq	r0, [r8, #3407]!	; 0xd4f
    3ad0:	04050000 	streq	r0, [r5], #-0
    3ad4:	000005d7 	ldrdeq	r0, [r0], -r7
    3ad8:	001ecb13 	andseq	ip, lr, r3, lsl fp
    3adc:	58053400 	stmdapl	r5, {sl, ip, sp}
    3ae0:	06191501 	ldreq	r1, [r9], -r1, lsl #10
    3ae4:	76140000 	ldrvc	r0, [r4], -r0
    3ae8:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    3aec:	b60f015a 			; <UNDEFINED> instruction: 0xb60f015a
    3af0:	00000004 	andeq	r0, r0, r4
    3af4:	001eaf14 	andseq	sl, lr, r4, lsl pc
    3af8:	015b0500 	cmpeq	fp, r0, lsl #10
    3afc:	00061e14 	andeq	r1, r6, r4, lsl lr
    3b00:	0e000400 	cfcpyseq	mvf0, mvf0
    3b04:	000005ee 	andeq	r0, r0, lr, ror #11
    3b08:	0000b90c 	andeq	fp, r0, ip, lsl #18
    3b0c:	00062e00 	andeq	r2, r6, r0, lsl #28
    3b10:	00241500 	eoreq	r1, r4, r0, lsl #10
    3b14:	002d0000 	eoreq	r0, sp, r0
    3b18:	0006190c 	andeq	r1, r6, ip, lsl #18
    3b1c:	00063900 	andeq	r3, r6, r0, lsl #18
    3b20:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    3b24:	0000062e 	andeq	r0, r0, lr, lsr #12
    3b28:	0022a60f 	eoreq	sl, r2, pc, lsl #12
    3b2c:	015c0500 	cmpeq	ip, r0, lsl #10
    3b30:	00063903 	andeq	r3, r6, r3, lsl #18
    3b34:	25160f00 	ldrcs	r0, [r6, #-3840]	; 0xfffff100
    3b38:	5f050000 	svcpl	0x00050000
    3b3c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3b40:	45160000 	ldrmi	r0, [r6, #-0]
    3b44:	07000029 	streq	r0, [r0, -r9, lsr #32]
    3b48:	00009301 	andeq	r9, r0, r1, lsl #6
    3b4c:	01720500 	cmneq	r2, r0, lsl #10
    3b50:	00070e06 	andeq	r0, r7, r6, lsl #28
    3b54:	25f10b00 	ldrbcs	r0, [r1, #2816]!	; 0xb00
    3b58:	0b000000 	bleq	3b60 <shift+0x3b60>
    3b5c:	00001c61 	andeq	r1, r0, r1, ror #24
    3b60:	1c6d0b02 			; <UNDEFINED> instruction: 0x1c6d0b02
    3b64:	0b030000 	bleq	c3b6c <__bss_end+0xb7c64>
    3b68:	00002049 	andeq	r2, r0, r9, asr #32
    3b6c:	262d0b03 	strtcs	r0, [sp], -r3, lsl #22
    3b70:	0b040000 	bleq	103b78 <__bss_end+0xf7c70>
    3b74:	000021b0 			; <UNDEFINED> instruction: 0x000021b0
    3b78:	1c8b0b04 	vstmiane	fp, {d0-d1}
    3b7c:	0b050000 	bleq	143b84 <__bss_end+0x137c7c>
    3b80:	0000227d 	andeq	r2, r0, sp, ror r2
    3b84:	22b70b05 	adcscs	r0, r7, #5120	; 0x1400
    3b88:	0b050000 	bleq	143b90 <__bss_end+0x137c88>
    3b8c:	000021e1 	andeq	r2, r0, r1, ror #3
    3b90:	1d4e0b05 	vstrne	d16, [lr, #-20]	; 0xffffffec
    3b94:	0b050000 	bleq	143b9c <__bss_end+0x137c94>
    3b98:	00001c97 	muleq	r0, r7, ip
    3b9c:	24260b06 	strtcs	r0, [r6], #-2822	; 0xfffff4fa
    3ba0:	0b060000 	bleq	183ba8 <__bss_end+0x177ca0>
    3ba4:	00001ea1 	andeq	r1, r0, r1, lsr #29
    3ba8:	273b0b06 	ldrcs	r0, [fp, -r6, lsl #22]!
    3bac:	0b060000 	bleq	183bb4 <__bss_end+0x177cac>
    3bb0:	000029d5 	ldrdeq	r2, [r0], -r5
    3bb4:	245a0b06 	ldrbcs	r0, [sl], #-2822	; 0xfffff4fa
    3bb8:	0b060000 	bleq	183bc0 <__bss_end+0x177cb8>
    3bbc:	000024b9 			; <UNDEFINED> instruction: 0x000024b9
    3bc0:	1ca30b06 	vstmiane	r3!, {d0-d2}
    3bc4:	0b070000 	bleq	1c3bcc <__bss_end+0x1b7cc4>
    3bc8:	000025d4 	ldrdeq	r2, [r0], -r4
    3bcc:	26390b07 	ldrtcs	r0, [r9], -r7, lsl #22
    3bd0:	0b070000 	bleq	1c3bd8 <__bss_end+0x1b7cd0>
    3bd4:	00002a1f 	andeq	r2, r0, pc, lsl sl
    3bd8:	1e740b07 	vaddne.f64	d16, d4, d7
    3bdc:	0b070000 	bleq	1c3be4 <__bss_end+0x1b7cdc>
    3be0:	000026b4 			; <UNDEFINED> instruction: 0x000026b4
    3be4:	1c040b08 			; <UNDEFINED> instruction: 0x1c040b08
    3be8:	0b080000 	bleq	203bf0 <__bss_end+0x1f7ce8>
    3bec:	000029e3 	andeq	r2, r0, r3, ror #19
    3bf0:	26d50b08 	ldrbcs	r0, [r5], r8, lsl #22
    3bf4:	00080000 	andeq	r0, r8, r0
    3bf8:	002d6e0f 	eoreq	r6, sp, pc, lsl #28
    3bfc:	01920500 	orrseq	r0, r2, r0, lsl #10
    3c00:	0006581f 	andeq	r5, r6, pc, lsl r8
    3c04:	217d0f00 	cmncs	sp, r0, lsl #30
    3c08:	95050000 	strls	r0, [r5, #-0]
    3c0c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3c10:	070f0000 	streq	r0, [pc, -r0]
    3c14:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    3c18:	1d0c0198 	stfnes	f0, [ip, #-608]	; 0xfffffda0
    3c1c:	0f000000 	svceq	0x00000000
    3c20:	000022c4 	andeq	r2, r0, r4, asr #5
    3c24:	0c019b05 			; <UNDEFINED> instruction: 0x0c019b05
    3c28:	0000001d 	andeq	r0, r0, sp, lsl r0
    3c2c:	0027110f 	eoreq	r1, r7, pc, lsl #2
    3c30:	019e0500 	orrseq	r0, lr, r0, lsl #10
    3c34:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3c38:	24070f00 	strcs	r0, [r7], #-3840	; 0xfffff100
    3c3c:	a1050000 	mrsge	r0, (UNDEF: 5)
    3c40:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3c44:	5b0f0000 	blpl	3c3c4c <__bss_end+0x3b7d44>
    3c48:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    3c4c:	1d0c01a4 	stfnes	f0, [ip, #-656]	; 0xfffffd70
    3c50:	0f000000 	svceq	0x00000000
    3c54:	00002617 	andeq	r2, r0, r7, lsl r6
    3c58:	0c01a705 	stceq	7, cr10, [r1], {5}
    3c5c:	0000001d 	andeq	r0, r0, sp, lsl r0
    3c60:	0026220f 	eoreq	r2, r6, pc, lsl #4
    3c64:	01aa0500 			; <UNDEFINED> instruction: 0x01aa0500
    3c68:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3c6c:	271b0f00 	ldrcs	r0, [fp, -r0, lsl #30]
    3c70:	ad050000 	stcge	0, cr0, [r5, #-0]
    3c74:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3c78:	f90f0000 			; <UNDEFINED> instruction: 0xf90f0000
    3c7c:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    3c80:	1d0c01b0 	stfnes	f0, [ip, #-704]	; 0xfffffd40
    3c84:	0f000000 	svceq	0x00000000
    3c88:	00002db0 			; <UNDEFINED> instruction: 0x00002db0
    3c8c:	0c01b305 	stceq	3, cr11, [r1], {5}
    3c90:	0000001d 	andeq	r0, r0, sp, lsl r0
    3c94:	0027250f 	eoreq	r2, r7, pc, lsl #10
    3c98:	01b60500 			; <UNDEFINED> instruction: 0x01b60500
    3c9c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3ca0:	2e8d0f00 	cdpcs	15, 8, cr0, cr13, cr0, {0}
    3ca4:	b9050000 	stmdblt	r5, {}	; <UNPREDICTABLE>
    3ca8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3cac:	3b0f0000 	blcc	3c3cb4 <__bss_end+0x3b7dac>
    3cb0:	0500002d 	streq	r0, [r0, #-45]	; 0xffffffd3
    3cb4:	1d0c01bc 	stfnes	f0, [ip, #-752]	; 0xfffffd10
    3cb8:	0f000000 	svceq	0x00000000
    3cbc:	00002d60 	andeq	r2, r0, r0, ror #26
    3cc0:	0c01c005 	stceq	0, cr12, [r1], {5}
    3cc4:	0000001d 	andeq	r0, r0, sp, lsl r0
    3cc8:	002e800f 	eoreq	r8, lr, pc
    3ccc:	01c30500 	biceq	r0, r3, r0, lsl #10
    3cd0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3cd4:	1dbe0f00 	ldcne	15, cr0, [lr]
    3cd8:	c6050000 	strgt	r0, [r5], -r0
    3cdc:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3ce0:	950f0000 	strls	r0, [pc, #-0]	; 3ce8 <shift+0x3ce8>
    3ce4:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    3ce8:	1d0c01c9 	stfnes	f0, [ip, #-804]	; 0xfffffcdc
    3cec:	0f000000 	svceq	0x00000000
    3cf0:	00002069 	andeq	r2, r0, r9, rrx
    3cf4:	0c01cc05 	stceq	12, cr12, [r1], {5}
    3cf8:	0000001d 	andeq	r0, r0, sp, lsl r0
    3cfc:	001d990f 	andseq	r9, sp, pc, lsl #18
    3d00:	01cf0500 	biceq	r0, pc, r0, lsl #10
    3d04:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3d08:	27650f00 	strbcs	r0, [r5, -r0, lsl #30]!
    3d0c:	d2050000 	andle	r0, r5, #0
    3d10:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3d14:	ec0f0000 	stc	0, cr0, [pc], {-0}
    3d18:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    3d1c:	1d0c01d5 	stfnes	f0, [ip, #-852]	; 0xfffffcac
    3d20:	0f000000 	svceq	0x00000000
    3d24:	00002584 	andeq	r2, r0, r4, lsl #11
    3d28:	0c01d805 	stceq	8, cr13, [r1], {5}
    3d2c:	0000001d 	andeq	r0, r0, sp, lsl r0
    3d30:	002b6b0f 	eoreq	r6, fp, pc, lsl #22
    3d34:	01df0500 	bicseq	r0, pc, r0, lsl #10
    3d38:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3d3c:	2e1f0f00 	cdpcs	15, 1, cr0, cr15, cr0, {0}
    3d40:	e2050000 	and	r0, r5, #0
    3d44:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3d48:	2f0f0000 	svccs	0x000f0000
    3d4c:	0500002e 	streq	r0, [r0, #-46]	; 0xffffffd2
    3d50:	1d0c01e5 	stfnes	f0, [ip, #-916]	; 0xfffffc6c
    3d54:	0f000000 	svceq	0x00000000
    3d58:	00001eb8 			; <UNDEFINED> instruction: 0x00001eb8
    3d5c:	0c01e805 	stceq	8, cr14, [r1], {5}
    3d60:	0000001d 	andeq	r0, r0, sp, lsl r0
    3d64:	002bb20f 	eoreq	fp, fp, pc, lsl #4
    3d68:	01eb0500 	mvneq	r0, r0, lsl #10
    3d6c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3d70:	269c0f00 	ldrcs	r0, [ip], r0, lsl #30
    3d74:	ee050000 	cdp	0, 0, cr0, cr5, cr0, {0}
    3d78:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3d7c:	e20f0000 	and	r0, pc, #0
    3d80:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    3d84:	1d0c01f2 	stfnes	f0, [ip, #-968]	; 0xfffffc38
    3d88:	0f000000 	svceq	0x00000000
    3d8c:	00002957 	andeq	r2, r0, r7, asr r9
    3d90:	0c01fa05 			; <UNDEFINED> instruction: 0x0c01fa05
    3d94:	0000001d 	andeq	r0, r0, sp, lsl r0
    3d98:	001f9b0f 	andseq	r9, pc, pc, lsl #22
    3d9c:	01fd0500 	mvnseq	r0, r0, lsl #10
    3da0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3da4:	001d0c00 	andseq	r0, sp, r0, lsl #24
    3da8:	08c60000 	stmiaeq	r6, {}^	; <UNPREDICTABLE>
    3dac:	000d0000 	andeq	r0, sp, r0
    3db0:	0021cc0f 	eoreq	ip, r1, pc, lsl #24
    3db4:	03eb0500 	mvneq	r0, #0, 10
    3db8:	0008bb0c 	andeq	fp, r8, ip, lsl #22
    3dbc:	05be0c00 	ldreq	r0, [lr, #3072]!	; 0xc00
    3dc0:	08e30000 	stmiaeq	r3!, {}^	; <UNPREDICTABLE>
    3dc4:	24150000 	ldrcs	r0, [r5], #-0
    3dc8:	0d000000 	stceq	0, cr0, [r0, #-0]
    3dcc:	279b0f00 	ldrcs	r0, [fp, r0, lsl #30]
    3dd0:	74050000 	strvc	r0, [r5], #-0
    3dd4:	08d31405 	ldmeq	r3, {r0, r2, sl, ip}^
    3dd8:	af160000 	svcge	0x00160000
    3ddc:	07000022 	streq	r0, [r0, -r2, lsr #32]
    3de0:	00009301 	andeq	r9, r0, r1, lsl #6
    3de4:	057b0500 	ldrbeq	r0, [fp, #-1280]!	; 0xfffffb00
    3de8:	00092e06 	andeq	r2, r9, r6, lsl #28
    3dec:	202b0b00 	eorcs	r0, fp, r0, lsl #22
    3df0:	0b000000 	bleq	3df8 <shift+0x3df8>
    3df4:	000024e4 	andeq	r2, r0, r4, ror #9
    3df8:	1c3a0b01 			; <UNDEFINED> instruction: 0x1c3a0b01
    3dfc:	0b020000 	bleq	83e04 <__bss_end+0x77efc>
    3e00:	00002de1 	andeq	r2, r0, r1, ror #27
    3e04:	28270b03 	stmdacs	r7!, {r0, r1, r8, r9, fp}
    3e08:	0b040000 	bleq	103e10 <__bss_end+0xf7f08>
    3e0c:	0000281a 	andeq	r2, r0, sl, lsl r8
    3e10:	1d2d0b05 	fstmdbxne	sp!, {d0-d1}	;@ Deprecated
    3e14:	00060000 	andeq	r0, r6, r0
    3e18:	002dd10f 	eoreq	sp, sp, pc, lsl #2
    3e1c:	05880500 	streq	r0, [r8, #1280]	; 0x500
    3e20:	0008f015 	andeq	pc, r8, r5, lsl r0	; <UNPREDICTABLE>
    3e24:	2cad0f00 	stccs	15, cr0, [sp]
    3e28:	89050000 	stmdbhi	r5, {}	; <UNPREDICTABLE>
    3e2c:	00241107 	eoreq	r1, r4, r7, lsl #2
    3e30:	880f0000 	stmdahi	pc, {}	; <UNPREDICTABLE>
    3e34:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    3e38:	1d0c079e 	stcne	7, cr0, [ip, #-632]	; 0xfffffd88
    3e3c:	04000000 	streq	r0, [r0], #-0
    3e40:	00002b5a 	andeq	r2, r0, sl, asr fp
    3e44:	93167b06 	tstls	r6, #6144	; 0x1800
    3e48:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    3e4c:	00000955 	andeq	r0, r0, r5, asr r9
    3e50:	e7050203 	str	r0, [r5, -r3, lsl #4]
    3e54:	0300000d 	movweq	r0, #13
    3e58:	1f840708 	svcne	0x00840708
    3e5c:	04030000 	streq	r0, [r3], #-0
    3e60:	001dd904 	andseq	sp, sp, r4, lsl #18
    3e64:	03080300 	movweq	r0, #33536	; 0x8300
    3e68:	00001dd1 	ldrdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    3e6c:	34040803 	strcc	r0, [r4], #-2051	; 0xfffff7fd
    3e70:	03000027 	movweq	r0, #39	; 0x27
    3e74:	286f0310 	stmdacs	pc!, {r4, r8, r9}^	; <UNPREDICTABLE>
    3e78:	610c0000 	mrsvs	r0, (UNDEF: 12)
    3e7c:	a0000009 	andge	r0, r0, r9
    3e80:	15000009 	strne	r0, [r0, #-9]
    3e84:	00000024 	andeq	r0, r0, r4, lsr #32
    3e88:	900e00ff 	strdls	r0, [lr], -pc	; <UNPREDICTABLE>
    3e8c:	0f000009 	svceq	0x00000009
    3e90:	00002646 	andeq	r2, r0, r6, asr #12
    3e94:	1601fc06 	strne	pc, [r1], -r6, lsl #24
    3e98:	000009a0 	andeq	r0, r0, r0, lsr #19
    3e9c:	001d880f 	andseq	r8, sp, pc, lsl #16
    3ea0:	02020600 	andeq	r0, r2, #0, 12
    3ea4:	0009a016 	andeq	sl, r9, r6, lsl r0
    3ea8:	2b7d0400 	blcs	1f44eb0 <__bss_end+0x1f38fa8>
    3eac:	2a070000 	bcs	1c3eb4 <__bss_end+0x1b7fac>
    3eb0:	0005d110 	andeq	sp, r5, r0, lsl r1
    3eb4:	09bf0c00 	ldmibeq	pc!, {sl, fp}	; <UNPREDICTABLE>
    3eb8:	09d60000 	ldmibeq	r6, {}^	; <UNPREDICTABLE>
    3ebc:	000d0000 	andeq	r0, sp, r0
    3ec0:	00039a09 	andeq	r9, r3, r9, lsl #20
    3ec4:	112f0700 			; <UNDEFINED> instruction: 0x112f0700
    3ec8:	000009cb 	andeq	r0, r0, fp, asr #19
    3ecc:	00025c09 	andeq	r5, r2, r9, lsl #24
    3ed0:	11300700 	teqne	r0, r0, lsl #14
    3ed4:	000009cb 	andeq	r0, r0, fp, asr #19
    3ed8:	0009d617 	andeq	sp, r9, r7, lsl r6
    3edc:	09360800 	ldmdbeq	r6!, {fp}
    3ee0:	d003050a 	andle	r0, r3, sl, lsl #10
    3ee4:	170000bd 			; <UNDEFINED> instruction: 0x170000bd
    3ee8:	000009e2 	andeq	r0, r0, r2, ror #19
    3eec:	0a093708 	beq	251b14 <__bss_end+0x245c0c>
    3ef0:	bdd80305 	ldcllt	3, cr0, [r8, #20]
    3ef4:	42000000 	andmi	r0, r0, #0
    3ef8:	0400000a 	streq	r0, [r0], #-10
    3efc:	0010ad00 	andseq	sl, r0, r0, lsl #26
    3f00:	e8010400 	stmda	r1, {sl}
    3f04:	0c00002b 	stceq	0, cr0, [r0], {43}	; 0x2b
    3f08:	00001e2a 	andeq	r1, r0, sl, lsr #28
    3f0c:	00001a86 	andeq	r1, r0, r6, lsl #21
    3f10:	0000b970 	andeq	fp, r0, r0, ror r9
    3f14:	0000002c 	andeq	r0, r0, ip, lsr #32
    3f18:	0000195d 	andeq	r1, r0, sp, asr r9
    3f1c:	d9040402 	stmdble	r4, {r1, sl}
    3f20:	0300001d 	movweq	r0, #29
    3f24:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    3f28:	04020074 	streq	r0, [r2], #-116	; 0xffffff8c
    3f2c:	001f8e07 	andseq	r8, pc, r7, lsl #28
    3f30:	05080200 	streq	r0, [r8, #-512]	; 0xfffffe00
    3f34:	0000037f 	andeq	r0, r0, pc, ror r3
    3f38:	2f040802 	svccs	0x00040802
    3f3c:	04000027 	streq	r0, [r0], #-39	; 0xffffffd9
    3f40:	00001e97 	muleq	r0, r7, lr
    3f44:	33162a02 	tstcc	r6, #8192	; 0x2000
    3f48:	04000000 	streq	r0, [r0], #-0
    3f4c:	000022fa 	strdeq	r2, [r0], -sl
    3f50:	60152f02 	andsvs	r2, r5, r2, lsl #30
    3f54:	05000000 	streq	r0, [r0, #-0]
    3f58:	00006604 	andeq	r6, r0, r4, lsl #12
    3f5c:	00480600 	subeq	r0, r8, r0, lsl #12
    3f60:	00750000 	rsbseq	r0, r5, r0
    3f64:	75070000 	strvc	r0, [r7, #-0]
    3f68:	00000000 	andeq	r0, r0, r0
    3f6c:	007b0405 	rsbseq	r0, fp, r5, lsl #8
    3f70:	04080000 	streq	r0, [r8], #-0
    3f74:	00002b99 	muleq	r0, r9, fp
    3f78:	880f3602 	stmdahi	pc, {r1, r9, sl, ip, sp}	; <UNPREDICTABLE>
    3f7c:	05000000 	streq	r0, [r0, #-0]
    3f80:	00008e04 	andeq	r8, r0, r4, lsl #28
    3f84:	002c0600 	eoreq	r0, ip, r0, lsl #12
    3f88:	00a20000 	adceq	r0, r2, r0
    3f8c:	75070000 	strvc	r0, [r7, #-0]
    3f90:	07000000 	streq	r0, [r0, -r0]
    3f94:	00000075 	andeq	r0, r0, r5, ror r0
    3f98:	08010200 	stmdaeq	r1, {r9}
    3f9c:	00001084 	andeq	r1, r0, r4, lsl #1
    3fa0:	00255d09 	eoreq	r5, r5, r9, lsl #26
    3fa4:	12bb0200 	adcsne	r0, fp, #0, 4
    3fa8:	00000054 	andeq	r0, r0, r4, asr r0
    3fac:	002bc709 	eoreq	ip, fp, r9, lsl #14
    3fb0:	10be0200 	adcsne	r0, lr, r0, lsl #4
    3fb4:	0000007c 	andeq	r0, r0, ip, ror r0
    3fb8:	86060102 	strhi	r0, [r6], -r2, lsl #2
    3fbc:	0a000010 	beq	4004 <shift+0x4004>
    3fc0:	00002201 	andeq	r2, r0, r1, lsl #4
    3fc4:	00a20107 	adceq	r0, r2, r7, lsl #2
    3fc8:	17030000 	strne	r0, [r3, -r0]
    3fcc:	0001f506 	andeq	pc, r1, r6, lsl #10
    3fd0:	1cfe0b00 	vldmiane	lr!, {d16-d15}
    3fd4:	0b000000 	bleq	3fdc <shift+0x3fdc>
    3fd8:	000020f9 	strdeq	r2, [r0], -r9
    3fdc:	26550b01 	ldrbcs	r0, [r5], -r1, lsl #22
    3fe0:	0b020000 	bleq	83fe8 <__bss_end+0x780e0>
    3fe4:	00002add 	ldrdeq	r2, [r0], -sp
    3fe8:	25e10b03 	strbcs	r0, [r1, #2819]!	; 0xb03
    3fec:	0b040000 	bleq	103ff4 <__bss_end+0xf80ec>
    3ff0:	000029a4 	andeq	r2, r0, r4, lsr #19
    3ff4:	28ca0b05 	stmiacs	sl, {r0, r2, r8, r9, fp}^
    3ff8:	0b060000 	bleq	184000 <__bss_end+0x1780f8>
    3ffc:	00001d1f 	andeq	r1, r0, pc, lsl sp
    4000:	29b90b07 	ldmibcs	r9!, {r0, r1, r2, r8, r9, fp}
    4004:	0b080000 	bleq	20400c <__bss_end+0x1f8104>
    4008:	000029c7 	andeq	r2, r0, r7, asr #19
    400c:	2ab80b09 	bcs	fee06c38 <__bss_end+0xfedfad30>
    4010:	0b0a0000 	bleq	284018 <__bss_end+0x278110>
    4014:	00002523 	andeq	r2, r0, r3, lsr #10
    4018:	1ed80b0b 	vfnmsne.f64	d16, d8, d11
    401c:	0b0c0000 	bleq	304024 <__bss_end+0x2f811c>
    4020:	0000228a 	andeq	r2, r0, sl, lsl #5
    4024:	2a100b0d 	bcs	406c60 <__bss_end+0x3fad58>
    4028:	0b0e0000 	bleq	384030 <__bss_end+0x378128>
    402c:	00002245 	andeq	r2, r0, r5, asr #4
    4030:	225b0b0f 	subscs	r0, fp, #15360	; 0x3c00
    4034:	0b100000 	bleq	40403c <__bss_end+0x3f8134>
    4038:	00002130 	andeq	r2, r0, r0, lsr r1
    403c:	25c50b11 	strbcs	r0, [r5, #2833]	; 0xb11
    4040:	0b120000 	bleq	484048 <__bss_end+0x478140>
    4044:	000021bd 			; <UNDEFINED> instruction: 0x000021bd
    4048:	2e750b13 	vmovcs.s8	r0, d5[4]
    404c:	0b140000 	bleq	504054 <__bss_end+0x4f814c>
    4050:	0000268d 	andeq	r2, r0, sp, lsl #13
    4054:	23ea0b15 	mvncs	r0, #21504	; 0x5400
    4058:	0b160000 	bleq	584060 <__bss_end+0x578158>
    405c:	00001d7c 	andeq	r1, r0, ip, ror sp
    4060:	2b000b17 	blcs	6cc4 <shift+0x6cc4>
    4064:	0b180000 	bleq	60406c <__bss_end+0x5f8164>
    4068:	00002d0a 	andeq	r2, r0, sl, lsl #26
    406c:	2b0e0b19 	blcs	386cd8 <__bss_end+0x37add0>
    4070:	0b1a0000 	bleq	684078 <__bss_end+0x678170>
    4074:	0000220d 	andeq	r2, r0, sp, lsl #4
    4078:	2b1c0b1b 	blcs	706cec <__bss_end+0x6fade4>
    407c:	0b1c0000 	bleq	704084 <__bss_end+0x6f817c>
    4080:	00001bd8 	ldrdeq	r1, [r0], -r8
    4084:	2b2a0b1d 	blcs	a86d00 <__bss_end+0xa7adf8>
    4088:	0b1e0000 	bleq	784090 <__bss_end+0x778188>
    408c:	00002b38 	andeq	r2, r0, r8, lsr fp
    4090:	1b710b1f 	blne	1c46d14 <__bss_end+0x1c3ae0c>
    4094:	0b200000 	bleq	80409c <__bss_end+0x7f8194>
    4098:	000027b0 			; <UNDEFINED> instruction: 0x000027b0
    409c:	25970b21 	ldrcs	r0, [r7, #2849]	; 0xb21
    40a0:	0b220000 	bleq	8840a8 <__bss_end+0x8781a0>
    40a4:	00002af3 	strdeq	r2, [r0], -r3
    40a8:	24670b23 	strbtcs	r0, [r7], #-2851	; 0xfffff4dd
    40ac:	0b240000 	bleq	9040b4 <__bss_end+0x8f81ac>
    40b0:	000028bb 			; <UNDEFINED> instruction: 0x000028bb
    40b4:	235d0b25 	cmpcs	sp, #37888	; 0x9400
    40b8:	0b260000 	bleq	9840c0 <__bss_end+0x9781b8>
    40bc:	00002039 	andeq	r2, r0, r9, lsr r0
    40c0:	237b0b27 	cmncs	fp, #39936	; 0x9c00
    40c4:	0b280000 	bleq	a040cc <__bss_end+0x9f81c4>
    40c8:	000020d5 	ldrdeq	r2, [r0], -r5
    40cc:	238b0b29 	orrcs	r0, fp, #41984	; 0xa400
    40d0:	0b2a0000 	bleq	a840d8 <__bss_end+0xa781d0>
    40d4:	00002509 	andeq	r2, r0, r9, lsl #10
    40d8:	23040b2b 	movwcs	r0, #19243	; 0x4b2b
    40dc:	0b2c0000 	bleq	b040e4 <__bss_end+0xaf81dc>
    40e0:	000027cf 	andeq	r2, r0, pc, asr #15
    40e4:	207a0b2d 	rsbscs	r0, sl, sp, lsr #22
    40e8:	002e0000 	eoreq	r0, lr, r0
    40ec:	0022970a 	eoreq	r9, r2, sl, lsl #14
    40f0:	a2010700 	andge	r0, r1, #0, 14
    40f4:	04000000 	streq	r0, [r0], #-0
    40f8:	04ae0617 	strteq	r0, [lr], #1559	; 0x617
    40fc:	ec0b0000 	stc	0, cr0, [fp], {-0}
    4100:	0000001e 	andeq	r0, r0, lr, lsl r0
    4104:	002d9e0b 	eoreq	r9, sp, fp, lsl #28
    4108:	fc0b0100 	stc2	1, cr0, [fp], {-0}
    410c:	0200001e 	andeq	r0, r0, #30
    4110:	001f1f0b 	andseq	r1, pc, fp, lsl #30
    4114:	d70b0300 	strle	r0, [fp, -r0, lsl #6]
    4118:	0400002b 	streq	r0, [r0], #-43	; 0xffffffd5
    411c:	0028350b 	eoreq	r3, r8, fp, lsl #10
    4120:	a90b0500 	stmdbge	fp, {r8, sl}
    4124:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
    4128:	00211e0b 	eoreq	r1, r1, fp, lsl #28
    412c:	2f0b0700 	svccs	0x000b0700
    4130:	0800001f 	stmdaeq	r0, {r0, r1, r2, r3, r4}
    4134:	002e640b 	eoreq	r6, lr, fp, lsl #8
    4138:	4f0b0900 	svcmi	0x000b0900
    413c:	0a00001c 	beq	41b4 <shift+0x41b4>
    4140:	002d8d0b 	eoreq	r8, sp, fp, lsl #26
    4144:	760b0b00 	strvc	r0, [fp], -r0, lsl #22
    4148:	0c000024 	stceq	0, cr0, [r0], {36}	; 0x24
    414c:	002d210b 	eoreq	r2, sp, fp, lsl #2
    4150:	bd0b0d00 	stclt	13, cr0, [fp, #-0]
    4154:	0e000027 	cdpeq	0, 0, cr0, cr0, cr7, {1}
    4158:	002a560b 	eoreq	r5, sl, fp, lsl #12
    415c:	0a0b0f00 	beq	2c7d64 <__bss_end+0x2bbe5c>
    4160:	10000020 	andne	r0, r0, r0, lsr #32
    4164:	001f0c0b 	andseq	r0, pc, fp, lsl #24
    4168:	750b1100 	strvc	r1, [fp, #-256]	; 0xffffff00
    416c:	12000027 	andne	r0, r0, #39	; 0x27
    4170:	001ff50b 	andseq	pc, pc, fp, lsl #10
    4174:	7c0b1300 	stcvc	3, cr1, [fp], {-0}
    4178:	1400002d 	strne	r0, [r0], #-45	; 0xffffffd3
    417c:	001c790b 	andseq	r7, ip, fp, lsl #18
    4180:	c50b1500 	strgt	r1, [fp, #-1280]	; 0xfffffb00
    4184:	16000023 	strne	r0, [r0], -r3, lsr #32
    4188:	001f3f0b 	andseq	r3, pc, fp, lsl #30
    418c:	160b1700 	strne	r1, [fp], -r0, lsl #14
    4190:	1800001c 	stmdane	r0, {r2, r3, r4}
    4194:	002e0a0b 	eoreq	r0, lr, fp, lsl #20
    4198:	c50b1900 	strgt	r1, [fp, #-2304]	; 0xfffff700
    419c:	1a00002a 	bne	424c <shift+0x424c>
    41a0:	0028d90b 	eoreq	sp, r8, fp, lsl #18
    41a4:	3d0b1b00 	vstrcc	d1, [fp, #-0]
    41a8:	1c00002a 	stcne	0, cr0, [r0], {42}	; 0x2a
    41ac:	002ba10b 	eoreq	sl, fp, fp, lsl #2
    41b0:	5f0b1d00 	svcpl	0x000b1d00
    41b4:	1e00001f 	mcrne	0, 0, r0, cr0, cr15, {0}
    41b8:	001cea0b 	andseq	lr, ip, fp, lsl #20
    41bc:	f20b1f00 	vmax.f32	d1, d11, d0
    41c0:	20000028 	andcs	r0, r0, r8, lsr #32
    41c4:	0020560b 	eoreq	r5, r0, fp, lsl #12
    41c8:	470b2100 	strmi	r2, [fp, -r0, lsl #2]
    41cc:	22000028 	andcs	r0, r0, #40	; 0x28
    41d0:	0024470b 	eoreq	r4, r4, fp, lsl #14
    41d4:	4f0b2300 	svcmi	0x000b2300
    41d8:	2400001f 	strcs	r0, [r0], #-31	; 0xffffffe1
    41dc:	0029f50b 	eoreq	pc, r9, fp, lsl #10
    41e0:	620b2500 	andvs	r2, fp, #0, 10
    41e4:	2600001e 			; <UNDEFINED> instruction: 0x2600001e
    41e8:	002b860b 	eoreq	r8, fp, fp, lsl #12
    41ec:	510b2700 	tstpl	fp, r0, lsl #14
    41f0:	2800002e 	stmdacs	r0, {r1, r2, r3, r5}
    41f4:	0027480b 	eoreq	r4, r7, fp, lsl #16
    41f8:	ef0b2900 	svc	0x000b2900
    41fc:	2a000021 	bcs	4288 <shift+0x4288>
    4200:	00291c0b 	eoreq	r1, r9, fp, lsl #24
    4204:	a50b2b00 	strge	r2, [fp, #-2816]	; 0xfffff500
    4208:	2c000024 	stccs	0, cr0, [r0], {36}	; 0x24
    420c:	001d3d0b 	andseq	r3, sp, fp, lsl #26
    4210:	c10b2d00 	tstgt	fp, r0, lsl #26
    4214:	2e00001c 	mcrcs	0, 0, r0, cr0, cr12, {0}
    4218:	002cdf0b 	eoreq	sp, ip, fp, lsl #30
    421c:	330b2f00 	movwcc	r2, #48896	; 0xbf00
    4220:	30000024 	andcc	r0, r0, r4, lsr #32
    4224:	001fcf0b 	andseq	ip, pc, fp, lsl #30
    4228:	120b3100 	andne	r3, fp, #0, 2
    422c:	32000024 	andcc	r0, r0, #36	; 0x24
    4230:	0026c10b 	eoreq	ip, r6, fp, lsl #2
    4234:	af0b3300 	svcge	0x000b3300
    4238:	3400001c 	strcc	r0, [r0], #-28	; 0xffffffe4
    423c:	002e3f0b 	eoreq	r3, lr, fp, lsl #30
    4240:	f60b3500 			; <UNDEFINED> instruction: 0xf60b3500
    4244:	36000024 	strcc	r0, [r0], -r4, lsr #32
    4248:	0021880b 	eoreq	r8, r1, fp, lsl #16
    424c:	330b3700 	movwcc	r3, #46848	; 0xb700
    4250:	38000025 	stmdacc	r0, {r0, r2, r5}
    4254:	002d470b 	eoreq	r4, sp, fp, lsl #14
    4258:	f40b3900 	vst2.8	{d3,d5}, [fp], r0
    425c:	3a00001d 	bcc	42d8 <shift+0x42d8>
    4260:	00219b0b 	eoreq	r9, r1, fp, lsl #22
    4264:	670b3b00 	strvs	r3, [fp, -r0, lsl #22]
    4268:	3c000021 	stccc	0, cr0, [r0], {33}	; 0x21
    426c:	001b800b 	andseq	r8, fp, fp
    4270:	880b3d00 	stmdahi	fp, {r8, sl, fp, ip, sp}
    4274:	3e000024 	cdpcc	0, 0, cr0, cr0, cr4, {1}
    4278:	0022670b 	eoreq	r6, r2, fp, lsl #14
    427c:	080b3f00 	stmdaeq	fp, {r8, r9, sl, fp, ip, sp}
    4280:	4000001d 	andmi	r0, r0, sp, lsl r0
    4284:	002cf30b 	eoreq	pc, ip, fp, lsl #6
    4288:	d80b4100 	stmdale	fp, {r8, lr}
    428c:	42000023 	andmi	r0, r0, #35	; 0x23
    4290:	0021510b 	eoreq	r5, r1, fp, lsl #2
    4294:	c10b4300 	mrsgt	r4, (UNDEF: 59)
    4298:	4400001b 	strmi	r0, [r0], #-27	; 0xffffffe5
    429c:	0023350b 	eoreq	r3, r3, fp, lsl #10
    42a0:	210b4500 	tstcs	fp, r0, lsl #10
    42a4:	46000023 	strmi	r0, [r0], -r3, lsr #32
    42a8:	00289c0b 	eoreq	r9, r8, fp, lsl #24
    42ac:	640b4700 	strvs	r4, [fp], #-1792	; 0xfffff900
    42b0:	48000029 	stmdami	r0, {r0, r3, r5}
    42b4:	002cbe0b 	eoreq	fp, ip, fp, lsl #28
    42b8:	870b4900 	strhi	r4, [fp, -r0, lsl #18]
    42bc:	4a000020 	bmi	4344 <shift+0x4344>
    42c0:	0026770b 	eoreq	r7, r6, fp, lsl #14
    42c4:	310b4b00 	tstcc	fp, r0, lsl #22
    42c8:	4c000029 	stcmi	0, cr0, [r0], {41}	; 0x29
    42cc:	0027de0b 	eoreq	sp, r7, fp, lsl #28
    42d0:	f20b4d00 	vadd.f32	d4, d11, d0
    42d4:	4e000027 	cdpmi	0, 0, cr0, cr0, cr7, {1}
    42d8:	0028060b 	eoreq	r0, r8, fp, lsl #12
    42dc:	820b4f00 	andhi	r4, fp, #0, 30
    42e0:	5000001e 	andpl	r0, r0, lr, lsl r0
    42e4:	001ddf0b 	andseq	sp, sp, fp, lsl #30
    42e8:	070b5100 	streq	r5, [fp, -r0, lsl #2]
    42ec:	5200001e 	andpl	r0, r0, #30
    42f0:	002a680b 	eoreq	r6, sl, fp, lsl #16
    42f4:	4d0b5300 	stcmi	3, cr5, [fp, #-0]
    42f8:	5400001e 	strpl	r0, [r0], #-30	; 0xffffffe2
    42fc:	002a7c0b 	eoreq	r7, sl, fp, lsl #24
    4300:	900b5500 	andls	r5, fp, r0, lsl #10
    4304:	5600002a 	strpl	r0, [r0], -sl, lsr #32
    4308:	002aa40b 	eoreq	sl, sl, fp, lsl #8
    430c:	e10b5700 	tst	fp, r0, lsl #14
    4310:	5800001f 	stmdapl	r0, {r0, r1, r2, r3, r4}
    4314:	001fbb0b 	andseq	fp, pc, fp, lsl #22
    4318:	490b5900 	stmdbmi	fp, {r8, fp, ip, lr}
    431c:	5a000023 	bpl	43b0 <shift+0x43b0>
    4320:	0025460b 	eoreq	r4, r5, fp, lsl #12
    4324:	cf0b5b00 	svcgt	0x000b5b00
    4328:	5c000022 	stcpl	0, cr0, [r0], {34}	; 0x22
    432c:	001b540b 	andseq	r5, fp, fp, lsl #8
    4330:	090b5d00 	stmdbeq	fp, {r8, sl, fp, ip, lr}
    4334:	5e000021 	cdppl	0, 0, cr0, cr0, cr1, {1}
    4338:	00256f0b 	eoreq	r6, r5, fp, lsl #30
    433c:	9b0b5f00 	blls	2dbf44 <__bss_end+0x2d003c>
    4340:	60000023 	andvs	r0, r0, r3, lsr #32
    4344:	00285a0b 	eoreq	r5, r8, fp, lsl #20
    4348:	bc0b6100 	stflts	f6, [fp], {-0}
    434c:	6200002d 	andvs	r0, r0, #45	; 0x2d
    4350:	0026620b 	eoreq	r6, r6, fp, lsl #4
    4354:	ac0b6300 	stcge	3, cr6, [fp], {-0}
    4358:	64000020 	strvs	r0, [r0], #-32	; 0xffffffe0
    435c:	001c280b 	andseq	r2, ip, fp, lsl #16
    4360:	e60b6500 	str	r6, [fp], -r0, lsl #10
    4364:	6600001b 			; <UNDEFINED> instruction: 0x6600001b
    4368:	0025a70b 	eoreq	sl, r5, fp, lsl #14
    436c:	e20b6700 	and	r6, fp, #0, 14
    4370:	68000026 	stmdavs	r0, {r1, r2, r5}
    4374:	00287e0b 	eoreq	r7, r8, fp, lsl #28
    4378:	b00b6900 	andlt	r6, fp, r0, lsl #18
    437c:	6a000023 	bvs	4410 <shift+0x4410>
    4380:	002df50b 	eoreq	pc, sp, fp, lsl #10
    4384:	c60b6b00 	strgt	r6, [fp], -r0, lsl #22
    4388:	6c000024 	stcvs	0, cr0, [r0], {36}	; 0x24
    438c:	001ba50b 	andseq	sl, fp, fp, lsl #10
    4390:	d50b6d00 	strle	r6, [fp, #-3328]	; 0xfffff300
    4394:	6e00001c 	mcrvs	0, 0, r0, cr0, cr12, {0}
    4398:	0020c00b 	eoreq	ip, r0, fp
    439c:	700b6f00 	andvc	r6, fp, r0, lsl #30
    43a0:	7000001f 	andvc	r0, r0, pc, lsl r0
    43a4:	07020200 	streq	r0, [r2, -r0, lsl #4]
    43a8:	000011d2 	ldrdeq	r1, [r0], -r2
    43ac:	0004cb0c 	andeq	ip, r4, ip, lsl #22
    43b0:	0004c000 	andeq	ip, r4, r0
    43b4:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    43b8:	000004b5 			; <UNDEFINED> instruction: 0x000004b5
    43bc:	04d70405 	ldrbeq	r0, [r7], #1029	; 0x405
    43c0:	c50e0000 	strgt	r0, [lr, #-0]
    43c4:	02000004 	andeq	r0, r0, #4
    43c8:	108d0801 	addne	r0, sp, r1, lsl #16
    43cc:	d00e0000 	andle	r0, lr, r0
    43d0:	0f000004 	svceq	0x00000004
    43d4:	00001d6d 	andeq	r1, r0, sp, ror #26
    43d8:	1a014405 	bne	553f4 <__bss_end+0x494ec>
    43dc:	000004c0 	andeq	r0, r0, r0, asr #9
    43e0:	0021410f 	eoreq	r4, r1, pc, lsl #2
    43e4:	01790500 	cmneq	r9, r0, lsl #10
    43e8:	0004c01a 	andeq	ip, r4, sl, lsl r0
    43ec:	04d00c00 	ldrbeq	r0, [r0], #3072	; 0xc00
    43f0:	05010000 	streq	r0, [r1, #-0]
    43f4:	000d0000 	andeq	r0, sp, r0
    43f8:	00236d09 	eoreq	r6, r3, r9, lsl #26
    43fc:	0d2d0600 	stceq	6, cr0, [sp, #-0]
    4400:	000004f6 	strdeq	r0, [r0], -r6
    4404:	002b6209 	eoreq	r6, fp, r9, lsl #4
    4408:	1c350600 	ldcne	6, cr0, [r5], #-0
    440c:	000001f5 	strdeq	r0, [r0], -r5
    4410:	00201d0a 	eoreq	r1, r0, sl, lsl #26
    4414:	a2010700 	andge	r0, r1, #0, 14
    4418:	06000000 	streq	r0, [r0], -r0
    441c:	058c0e37 	streq	r0, [ip, #3639]	; 0xe37
    4420:	ba0b0000 	blt	2c4428 <__bss_end+0x2b8520>
    4424:	0000001b 	andeq	r0, r0, fp, lsl r0
    4428:	0022540b 	eoreq	r5, r2, fp, lsl #8
    442c:	590b0100 	stmdbpl	fp, {r8}
    4430:	0200002d 	andeq	r0, r0, #45	; 0x2d
    4434:	002d340b 	eoreq	r3, sp, fp, lsl #8
    4438:	100b0300 	andne	r0, fp, r0, lsl #6
    443c:	04000026 	streq	r0, [r0], #-38	; 0xffffffda
    4440:	0029b20b 	eoreq	fp, r9, fp, lsl #4
    4444:	b00b0500 	andlt	r0, fp, r0, lsl #10
    4448:	0600001d 			; <UNDEFINED> instruction: 0x0600001d
    444c:	001d920b 	andseq	r9, sp, fp, lsl #4
    4450:	e50b0700 	str	r0, [fp, #-1792]	; 0xfffff900
    4454:	0800001e 	stmdaeq	r0, {r1, r2, r3, r4}
    4458:	00249e0b 	eoreq	r9, r4, fp, lsl #28
    445c:	b70b0900 	strlt	r0, [fp, -r0, lsl #18]
    4460:	0a00001d 	beq	44dc <shift+0x44dc>
    4464:	001e230b 	andseq	r2, lr, fp, lsl #6
    4468:	1c0b0b00 			; <UNDEFINED> instruction: 0x1c0b0b00
    446c:	0c00001e 	stceq	0, cr0, [r0], {30}
    4470:	001da90b 	andseq	sl, sp, fp, lsl #18
    4474:	090b0d00 	stmdbeq	fp, {r8, sl, fp}
    4478:	0e00002a 	cdpeq	0, 0, cr0, cr0, cr10, {1}
    447c:	0027000b 	eoreq	r0, r7, fp
    4480:	04000f00 	streq	r0, [r0], #-3840	; 0xfffff100
    4484:	000028b4 			; <UNDEFINED> instruction: 0x000028b4
    4488:	19013c06 	stmdbne	r1, {r1, r2, sl, fp, ip, sp}
    448c:	09000005 	stmdbeq	r0, {r0, r2}
    4490:	00002985 	andeq	r2, r0, r5, lsl #19
    4494:	8c0f3e06 	stchi	14, cr3, [pc], {6}
    4498:	09000005 	stmdbeq	r0, {r0, r2}
    449c:	00002a2c 	andeq	r2, r0, ip, lsr #20
    44a0:	2c0c4706 	stccs	7, cr4, [ip], {6}
    44a4:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    44a8:	00001d5d 	andeq	r1, r0, sp, asr sp
    44ac:	2c0c4806 	stccs	8, cr4, [ip], {6}
    44b0:	10000000 	andne	r0, r0, r0
    44b4:	00002b46 	andeq	r2, r0, r6, asr #22
    44b8:	00299409 	eoreq	r9, r9, r9, lsl #8
    44bc:	14490600 	strbne	r0, [r9], #-1536	; 0xfffffa00
    44c0:	000005cd 	andeq	r0, r0, sp, asr #11
    44c4:	05bc0405 	ldreq	r0, [ip, #1029]!	; 0x405
    44c8:	09110000 	ldmdbeq	r1, {}	; <UNPREDICTABLE>
    44cc:	0000221e 	andeq	r2, r0, lr, lsl r2
    44d0:	e00f4b06 	and	r4, pc, r6, lsl #22
    44d4:	05000005 	streq	r0, [r0, #-5]
    44d8:	0005d304 	andeq	sp, r5, r4, lsl #6
    44dc:	29071200 	stmdbcs	r7, {r9, ip}
    44e0:	fd090000 	stc2	0, cr0, [r9, #-0]
    44e4:	06000025 	streq	r0, [r0], -r5, lsr #32
    44e8:	05f70d4f 	ldrbeq	r0, [r7, #3407]!	; 0xd4f
    44ec:	04050000 	streq	r0, [r5], #-0
    44f0:	000005e6 	andeq	r0, r0, r6, ror #11
    44f4:	001ecb13 	andseq	ip, lr, r3, lsl fp
    44f8:	58063400 	stmdapl	r6, {sl, ip, sp}
    44fc:	06281501 	strteq	r1, [r8], -r1, lsl #10
    4500:	76140000 	ldrvc	r0, [r4], -r0
    4504:	06000023 	streq	r0, [r0], -r3, lsr #32
    4508:	c50f015a 	strgt	r0, [pc, #-346]	; 43b6 <shift+0x43b6>
    450c:	00000004 	andeq	r0, r0, r4
    4510:	001eaf14 	andseq	sl, lr, r4, lsl pc
    4514:	015b0600 	cmpeq	fp, r0, lsl #12
    4518:	00062d14 	andeq	r2, r6, r4, lsl sp
    451c:	0e000400 	cfcpyseq	mvf0, mvf0
    4520:	000005fd 	strdeq	r0, [r0], -sp
    4524:	0000c80c 	andeq	ip, r0, ip, lsl #16
    4528:	00063d00 	andeq	r3, r6, r0, lsl #26
    452c:	00331500 	eorseq	r1, r3, r0, lsl #10
    4530:	002d0000 	eoreq	r0, sp, r0
    4534:	0006280c 	andeq	r2, r6, ip, lsl #16
    4538:	00064800 	andeq	r4, r6, r0, lsl #16
    453c:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    4540:	0000063d 	andeq	r0, r0, sp, lsr r6
    4544:	0022a60f 	eoreq	sl, r2, pc, lsl #12
    4548:	015c0600 	cmpeq	ip, r0, lsl #12
    454c:	00064803 	andeq	r4, r6, r3, lsl #16
    4550:	25160f00 	ldrcs	r0, [r6, #-3840]	; 0xfffff100
    4554:	5f060000 	svcpl	0x00060000
    4558:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    455c:	45160000 	ldrmi	r0, [r6, #-0]
    4560:	07000029 	streq	r0, [r0, -r9, lsr #32]
    4564:	0000a201 	andeq	sl, r0, r1, lsl #4
    4568:	01720600 	cmneq	r2, r0, lsl #12
    456c:	00071d06 	andeq	r1, r7, r6, lsl #26
    4570:	25f10b00 	ldrbcs	r0, [r1, #2816]!	; 0xb00
    4574:	0b000000 	bleq	457c <shift+0x457c>
    4578:	00001c61 	andeq	r1, r0, r1, ror #24
    457c:	1c6d0b02 			; <UNDEFINED> instruction: 0x1c6d0b02
    4580:	0b030000 	bleq	c4588 <__bss_end+0xb8680>
    4584:	00002049 	andeq	r2, r0, r9, asr #32
    4588:	262d0b03 	strtcs	r0, [sp], -r3, lsl #22
    458c:	0b040000 	bleq	104594 <__bss_end+0xf868c>
    4590:	000021b0 			; <UNDEFINED> instruction: 0x000021b0
    4594:	1c8b0b04 	vstmiane	fp, {d0-d1}
    4598:	0b050000 	bleq	1445a0 <__bss_end+0x138698>
    459c:	0000227d 	andeq	r2, r0, sp, ror r2
    45a0:	22b70b05 	adcscs	r0, r7, #5120	; 0x1400
    45a4:	0b050000 	bleq	1445ac <__bss_end+0x1386a4>
    45a8:	000021e1 	andeq	r2, r0, r1, ror #3
    45ac:	1d4e0b05 	vstrne	d16, [lr, #-20]	; 0xffffffec
    45b0:	0b050000 	bleq	1445b8 <__bss_end+0x1386b0>
    45b4:	00001c97 	muleq	r0, r7, ip
    45b8:	24260b06 	strtcs	r0, [r6], #-2822	; 0xfffff4fa
    45bc:	0b060000 	bleq	1845c4 <__bss_end+0x1786bc>
    45c0:	00001ea1 	andeq	r1, r0, r1, lsr #29
    45c4:	273b0b06 	ldrcs	r0, [fp, -r6, lsl #22]!
    45c8:	0b060000 	bleq	1845d0 <__bss_end+0x1786c8>
    45cc:	000029d5 	ldrdeq	r2, [r0], -r5
    45d0:	245a0b06 	ldrbcs	r0, [sl], #-2822	; 0xfffff4fa
    45d4:	0b060000 	bleq	1845dc <__bss_end+0x1786d4>
    45d8:	000024b9 			; <UNDEFINED> instruction: 0x000024b9
    45dc:	1ca30b06 	vstmiane	r3!, {d0-d2}
    45e0:	0b070000 	bleq	1c45e8 <__bss_end+0x1b86e0>
    45e4:	000025d4 	ldrdeq	r2, [r0], -r4
    45e8:	26390b07 	ldrtcs	r0, [r9], -r7, lsl #22
    45ec:	0b070000 	bleq	1c45f4 <__bss_end+0x1b86ec>
    45f0:	00002a1f 	andeq	r2, r0, pc, lsl sl
    45f4:	1e740b07 	vaddne.f64	d16, d4, d7
    45f8:	0b070000 	bleq	1c4600 <__bss_end+0x1b86f8>
    45fc:	000026b4 			; <UNDEFINED> instruction: 0x000026b4
    4600:	1c040b08 			; <UNDEFINED> instruction: 0x1c040b08
    4604:	0b080000 	bleq	20460c <__bss_end+0x1f8704>
    4608:	000029e3 	andeq	r2, r0, r3, ror #19
    460c:	26d50b08 	ldrbcs	r0, [r5], r8, lsl #22
    4610:	00080000 	andeq	r0, r8, r0
    4614:	002d6e0f 	eoreq	r6, sp, pc, lsl #28
    4618:	01920600 	orrseq	r0, r2, r0, lsl #12
    461c:	0006671f 	andeq	r6, r6, pc, lsl r7
    4620:	217d0f00 	cmncs	sp, r0, lsl #30
    4624:	95060000 	strls	r0, [r6, #-0]
    4628:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    462c:	070f0000 	streq	r0, [pc, -r0]
    4630:	06000027 	streq	r0, [r0], -r7, lsr #32
    4634:	2c0c0198 	stfcss	f0, [ip], {152}	; 0x98
    4638:	0f000000 	svceq	0x00000000
    463c:	000022c4 	andeq	r2, r0, r4, asr #5
    4640:	0c019b06 			; <UNDEFINED> instruction: 0x0c019b06
    4644:	0000002c 	andeq	r0, r0, ip, lsr #32
    4648:	0027110f 	eoreq	r1, r7, pc, lsl #2
    464c:	019e0600 	orrseq	r0, lr, r0, lsl #12
    4650:	00002c0c 	andeq	r2, r0, ip, lsl #24
    4654:	24070f00 	strcs	r0, [r7], #-3840	; 0xfffff100
    4658:	a1060000 	mrsge	r0, (UNDEF: 6)
    465c:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    4660:	5b0f0000 	blpl	3c4668 <__bss_end+0x3b8760>
    4664:	06000027 	streq	r0, [r0], -r7, lsr #32
    4668:	2c0c01a4 	stfcss	f0, [ip], {164}	; 0xa4
    466c:	0f000000 	svceq	0x00000000
    4670:	00002617 	andeq	r2, r0, r7, lsl r6
    4674:	0c01a706 	stceq	7, cr10, [r1], {6}
    4678:	0000002c 	andeq	r0, r0, ip, lsr #32
    467c:	0026220f 	eoreq	r2, r6, pc, lsl #4
    4680:	01aa0600 			; <UNDEFINED> instruction: 0x01aa0600
    4684:	00002c0c 	andeq	r2, r0, ip, lsl #24
    4688:	271b0f00 	ldrcs	r0, [fp, -r0, lsl #30]
    468c:	ad060000 	stcge	0, cr0, [r6, #-0]
    4690:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    4694:	f90f0000 			; <UNDEFINED> instruction: 0xf90f0000
    4698:	06000023 	streq	r0, [r0], -r3, lsr #32
    469c:	2c0c01b0 	stfcss	f0, [ip], {176}	; 0xb0
    46a0:	0f000000 	svceq	0x00000000
    46a4:	00002db0 			; <UNDEFINED> instruction: 0x00002db0
    46a8:	0c01b306 	stceq	3, cr11, [r1], {6}
    46ac:	0000002c 	andeq	r0, r0, ip, lsr #32
    46b0:	0027250f 	eoreq	r2, r7, pc, lsl #10
    46b4:	01b60600 			; <UNDEFINED> instruction: 0x01b60600
    46b8:	00002c0c 	andeq	r2, r0, ip, lsl #24
    46bc:	2e8d0f00 	cdpcs	15, 8, cr0, cr13, cr0, {0}
    46c0:	b9060000 	stmdblt	r6, {}	; <UNPREDICTABLE>
    46c4:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    46c8:	3b0f0000 	blcc	3c46d0 <__bss_end+0x3b87c8>
    46cc:	0600002d 	streq	r0, [r0], -sp, lsr #32
    46d0:	2c0c01bc 	stfcss	f0, [ip], {188}	; 0xbc
    46d4:	0f000000 	svceq	0x00000000
    46d8:	00002d60 	andeq	r2, r0, r0, ror #26
    46dc:	0c01c006 	stceq	0, cr12, [r1], {6}
    46e0:	0000002c 	andeq	r0, r0, ip, lsr #32
    46e4:	002e800f 	eoreq	r8, lr, pc
    46e8:	01c30600 	biceq	r0, r3, r0, lsl #12
    46ec:	00002c0c 	andeq	r2, r0, ip, lsl #24
    46f0:	1dbe0f00 	ldcne	15, cr0, [lr]
    46f4:	c6060000 	strgt	r0, [r6], -r0
    46f8:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    46fc:	950f0000 	strls	r0, [pc, #-0]	; 4704 <shift+0x4704>
    4700:	0600001b 			; <UNDEFINED> instruction: 0x0600001b
    4704:	2c0c01c9 	stfcss	f0, [ip], {201}	; 0xc9
    4708:	0f000000 	svceq	0x00000000
    470c:	00002069 	andeq	r2, r0, r9, rrx
    4710:	0c01cc06 	stceq	12, cr12, [r1], {6}
    4714:	0000002c 	andeq	r0, r0, ip, lsr #32
    4718:	001d990f 	andseq	r9, sp, pc, lsl #18
    471c:	01cf0600 	biceq	r0, pc, r0, lsl #12
    4720:	00002c0c 	andeq	r2, r0, ip, lsl #24
    4724:	27650f00 	strbcs	r0, [r5, -r0, lsl #30]!
    4728:	d2060000 	andle	r0, r6, #0
    472c:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    4730:	ec0f0000 	stc	0, cr0, [pc], {-0}
    4734:	06000022 	streq	r0, [r0], -r2, lsr #32
    4738:	2c0c01d5 	stfcss	f0, [ip], {213}	; 0xd5
    473c:	0f000000 	svceq	0x00000000
    4740:	00002584 	andeq	r2, r0, r4, lsl #11
    4744:	0c01d806 	stceq	8, cr13, [r1], {6}
    4748:	0000002c 	andeq	r0, r0, ip, lsr #32
    474c:	002b6b0f 	eoreq	r6, fp, pc, lsl #22
    4750:	01df0600 	bicseq	r0, pc, r0, lsl #12
    4754:	00002c0c 	andeq	r2, r0, ip, lsl #24
    4758:	2e1f0f00 	cdpcs	15, 1, cr0, cr15, cr0, {0}
    475c:	e2060000 	and	r0, r6, #0
    4760:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    4764:	2f0f0000 	svccs	0x000f0000
    4768:	0600002e 	streq	r0, [r0], -lr, lsr #32
    476c:	2c0c01e5 	stfcss	f0, [ip], {229}	; 0xe5
    4770:	0f000000 	svceq	0x00000000
    4774:	00001eb8 			; <UNDEFINED> instruction: 0x00001eb8
    4778:	0c01e806 	stceq	8, cr14, [r1], {6}
    477c:	0000002c 	andeq	r0, r0, ip, lsr #32
    4780:	002bb20f 	eoreq	fp, fp, pc, lsl #4
    4784:	01eb0600 	mvneq	r0, r0, lsl #12
    4788:	00002c0c 	andeq	r2, r0, ip, lsl #24
    478c:	269c0f00 	ldrcs	r0, [ip], r0, lsl #30
    4790:	ee060000 	cdp	0, 0, cr0, cr6, cr0, {0}
    4794:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    4798:	e20f0000 	and	r0, pc, #0
    479c:	06000020 	streq	r0, [r0], -r0, lsr #32
    47a0:	2c0c01f2 	stfcss	f0, [ip], {242}	; 0xf2
    47a4:	0f000000 	svceq	0x00000000
    47a8:	00002957 	andeq	r2, r0, r7, asr r9
    47ac:	0c01fa06 			; <UNDEFINED> instruction: 0x0c01fa06
    47b0:	0000002c 	andeq	r0, r0, ip, lsr #32
    47b4:	001f9b0f 	andseq	r9, pc, pc, lsl #22
    47b8:	01fd0600 	mvnseq	r0, r0, lsl #12
    47bc:	00002c0c 	andeq	r2, r0, ip, lsl #24
    47c0:	002c0c00 	eoreq	r0, ip, r0, lsl #24
    47c4:	08d50000 	ldmeq	r5, {}^	; <UNPREDICTABLE>
    47c8:	000d0000 	andeq	r0, sp, r0
    47cc:	0021cc0f 	eoreq	ip, r1, pc, lsl #24
    47d0:	03eb0600 	mvneq	r0, #0, 12
    47d4:	0008ca0c 	andeq	ip, r8, ip, lsl #20
    47d8:	05cd0c00 	strbeq	r0, [sp, #3072]	; 0xc00
    47dc:	08f20000 	ldmeq	r2!, {}^	; <UNPREDICTABLE>
    47e0:	33150000 	tstcc	r5, #0
    47e4:	0d000000 	stceq	0, cr0, [r0, #-0]
    47e8:	279b0f00 	ldrcs	r0, [fp, r0, lsl #30]
    47ec:	74060000 	strvc	r0, [r6], #-0
    47f0:	08e21405 	stmiaeq	r2!, {r0, r2, sl, ip}^
    47f4:	af160000 	svcge	0x00160000
    47f8:	07000022 	streq	r0, [r0, -r2, lsr #32]
    47fc:	0000a201 	andeq	sl, r0, r1, lsl #4
    4800:	057b0600 	ldrbeq	r0, [fp, #-1536]!	; 0xfffffa00
    4804:	00093d06 	andeq	r3, r9, r6, lsl #26
    4808:	202b0b00 	eorcs	r0, fp, r0, lsl #22
    480c:	0b000000 	bleq	4814 <shift+0x4814>
    4810:	000024e4 	andeq	r2, r0, r4, ror #9
    4814:	1c3a0b01 			; <UNDEFINED> instruction: 0x1c3a0b01
    4818:	0b020000 	bleq	84820 <__bss_end+0x78918>
    481c:	00002de1 	andeq	r2, r0, r1, ror #27
    4820:	28270b03 	stmdacs	r7!, {r0, r1, r8, r9, fp}
    4824:	0b040000 	bleq	10482c <__bss_end+0xf8924>
    4828:	0000281a 	andeq	r2, r0, sl, lsl r8
    482c:	1d2d0b05 	fstmdbxne	sp!, {d0-d1}	;@ Deprecated
    4830:	00060000 	andeq	r0, r6, r0
    4834:	002dd10f 	eoreq	sp, sp, pc, lsl #2
    4838:	05880600 	streq	r0, [r8, #1536]	; 0x600
    483c:	0008ff15 	andeq	pc, r8, r5, lsl pc	; <UNPREDICTABLE>
    4840:	2cad0f00 	stccs	15, cr0, [sp]
    4844:	89060000 	stmdbhi	r6, {}	; <UNPREDICTABLE>
    4848:	00331107 	eorseq	r1, r3, r7, lsl #2
    484c:	880f0000 	stmdahi	pc, {}	; <UNPREDICTABLE>
    4850:	06000027 	streq	r0, [r0], -r7, lsr #32
    4854:	2c0c079e 	stccs	7, cr0, [ip], {158}	; 0x9e
    4858:	04000000 	streq	r0, [r0], #-0
    485c:	00002b5a 	andeq	r2, r0, sl, asr fp
    4860:	a2167b07 	andsge	r7, r6, #7168	; 0x1c00
    4864:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    4868:	00000964 	andeq	r0, r0, r4, ror #18
    486c:	e7050202 	str	r0, [r5, -r2, lsl #4]
    4870:	0400000d 	streq	r0, [r0], #-13
    4874:	00002ec6 	andeq	r2, r0, r6, asr #29
    4878:	3a0f8407 	bcc	3e589c <__bss_end+0x3d9994>
    487c:	02000000 	andeq	r0, r0, #0
    4880:	1f840708 	svcne	0x00840708
    4884:	b4040000 	strlt	r0, [r4], #-0
    4888:	0700002e 	streq	r0, [r0, -lr, lsr #32]
    488c:	00251093 	mlaeq	r5, r3, r0, r1
    4890:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    4894:	001dd103 	andseq	sp, sp, r3, lsl #2
    4898:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    489c:	00002734 	andeq	r2, r0, r4, lsr r7
    48a0:	6f031002 	svcvs	0x00031002
    48a4:	0c000028 	stceq	0, cr0, [r0], {40}	; 0x28
    48a8:	00000970 	andeq	r0, r0, r0, ror r9
    48ac:	000009c0 	andeq	r0, r0, r0, asr #19
    48b0:	00003315 	andeq	r3, r0, r5, lsl r3
    48b4:	0e00ff00 	cdpeq	15, 0, cr15, cr0, cr0, {0}
    48b8:	000009b0 			; <UNDEFINED> instruction: 0x000009b0
    48bc:	0026460f 	eoreq	r4, r6, pc, lsl #12
    48c0:	01fc0700 	mvnseq	r0, r0, lsl #14
    48c4:	0009c016 	andeq	ip, r9, r6, lsl r0
    48c8:	1d880f00 	stcne	15, cr0, [r8]
    48cc:	02070000 	andeq	r0, r7, #0
    48d0:	09c01602 	stmibeq	r0, {r1, r9, sl, ip}^
    48d4:	bb170000 	bllt	5c48dc <__bss_end+0x5b89d4>
    48d8:	0100002e 	tsteq	r0, lr, lsr #32
    48dc:	7c0105f9 	cfstr32vc	mvfx0, [r1], {249}	; 0xf9
    48e0:	70000009 	andvc	r0, r0, r9
    48e4:	2c0000b9 	stccs	0, cr0, [r0], {185}	; 0xb9
    48e8:	01000000 	mrseq	r0, (UNDEF: 0)
    48ec:	000a399c 	muleq	sl, ip, r9
    48f0:	00611800 	rsbeq	r1, r1, r0, lsl #16
    48f4:	1305f901 	movwne	pc, #22785	; 0x5901	; <UNPREDICTABLE>
    48f8:	0000098f 	andeq	r0, r0, pc, lsl #19
    48fc:	0000000a 	andeq	r0, r0, sl
    4900:	00000000 	andeq	r0, r0, r0
    4904:	00b98419 	adcseq	r8, r9, r9, lsl r4
    4908:	000a3900 	andeq	r3, sl, r0, lsl #18
    490c:	000a2400 	andeq	r2, sl, r0, lsl #8
    4910:	50011a00 	andpl	r1, r1, r0, lsl #20
    4914:	f503f305 			; <UNDEFINED> instruction: 0xf503f305
    4918:	1b002500 	blne	dd20 <__bss_end+0x1e18>
    491c:	0000b990 	muleq	r0, r0, r9
    4920:	00000a39 	andeq	r0, r0, r9, lsr sl
    4924:	0650011a 			; <UNDEFINED> instruction: 0x0650011a
    4928:	00f503f3 	ldrshteq	r0, [r5], #51	; 0x33
    492c:	00001f25 	andeq	r1, r0, r5, lsr #30
    4930:	002ea61c 	eoreq	sl, lr, ip, lsl r6
    4934:	002e9900 	eoreq	r9, lr, r0, lsl #18
    4938:	033b0100 	teqeq	fp, #0, 2
    493c:	000a6600 	andeq	r6, sl, r0, lsl #12
    4940:	24000400 	strcs	r0, [r0], #-1024	; 0xfffffc00
    4944:	04000012 	streq	r0, [r0], #-18	; 0xffffffee
    4948:	002be801 	eoreq	lr, fp, r1, lsl #16
    494c:	1e2a0c00 	cdpne	12, 2, cr0, cr10, cr0, {0}
    4950:	1a860000 	bne	fe184958 <__bss_end+0xfe178a50>
    4954:	b9a00000 	stmiblt	r0!, {}	; <UNPREDICTABLE>
    4958:	00400000 	subeq	r0, r0, r0
    495c:	1a8b0000 	bne	fe2c4964 <__bss_end+0xfe2b8a5c>
    4960:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    4964:	00273404 	eoreq	r3, r7, r4, lsl #8
    4968:	07040200 	streq	r0, [r4, -r0, lsl #4]
    496c:	00001f8e 	andeq	r1, r0, lr, lsl #31
    4970:	d9040402 	stmdble	r4, {r1, sl}
    4974:	0300001d 	movweq	r0, #29
    4978:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    497c:	08020074 	stmdaeq	r2, {r2, r4, r5, r6}
    4980:	00037f05 	andeq	r7, r3, r5, lsl #30
    4984:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    4988:	0000272f 	andeq	r2, r0, pc, lsr #14
    498c:	001e9704 	andseq	r9, lr, r4, lsl #14
    4990:	162a0200 	strtne	r0, [sl], -r0, lsl #4
    4994:	0000002c 	andeq	r0, r0, ip, lsr #32
    4998:	0022fa04 	eoreq	pc, r2, r4, lsl #20
    499c:	152f0200 	strne	r0, [pc, #-512]!	; 47a4 <shift+0x47a4>
    49a0:	00000067 	andeq	r0, r0, r7, rrx
    49a4:	006d0405 	rsbeq	r0, sp, r5, lsl #8
    49a8:	4f060000 	svcmi	0x00060000
    49ac:	7c000000 	stcvc	0, cr0, [r0], {-0}
    49b0:	07000000 	streq	r0, [r0, -r0]
    49b4:	0000007c 	andeq	r0, r0, ip, ror r0
    49b8:	82040500 	andhi	r0, r4, #0, 10
    49bc:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    49c0:	002b9904 	eoreq	r9, fp, r4, lsl #18
    49c4:	0f360200 	svceq	0x00360200
    49c8:	0000008f 	andeq	r0, r0, pc, lsl #1
    49cc:	00950405 	addseq	r0, r5, r5, lsl #8
    49d0:	3a060000 	bcc	1849d8 <__bss_end+0x178ad0>
    49d4:	a9000000 	stmdbge	r0, {}	; <UNPREDICTABLE>
    49d8:	07000000 	streq	r0, [r0, -r0]
    49dc:	0000007c 	andeq	r0, r0, ip, ror r0
    49e0:	00007c07 	andeq	r7, r0, r7, lsl #24
    49e4:	01020000 	mrseq	r0, (UNDEF: 2)
    49e8:	00108408 	andseq	r8, r0, r8, lsl #8
    49ec:	255d0900 	ldrbcs	r0, [sp, #-2304]	; 0xfffff700
    49f0:	bb020000 	bllt	849f8 <__bss_end+0x78af0>
    49f4:	00005b12 	andeq	r5, r0, r2, lsl fp
    49f8:	2bc70900 	blcs	ff1c6e00 <__bss_end+0xff1baef8>
    49fc:	be020000 	cdplt	0, 0, cr0, cr2, cr0, {0}
    4a00:	00008310 	andeq	r8, r0, r0, lsl r3
    4a04:	06010200 	streq	r0, [r1], -r0, lsl #4
    4a08:	00001086 	andeq	r1, r0, r6, lsl #1
    4a0c:	0022010a 	eoreq	r0, r2, sl, lsl #2
    4a10:	a9010700 	stmdbge	r1, {r8, r9, sl}
    4a14:	03000000 	movweq	r0, #0
    4a18:	01fc0617 	mvnseq	r0, r7, lsl r6
    4a1c:	fe0b0000 	cdp2	0, 0, cr0, cr11, cr0, {0}
    4a20:	0000001c 	andeq	r0, r0, ip, lsl r0
    4a24:	0020f90b 	eoreq	pc, r0, fp, lsl #18
    4a28:	550b0100 	strpl	r0, [fp, #-256]	; 0xffffff00
    4a2c:	02000026 	andeq	r0, r0, #38	; 0x26
    4a30:	002add0b 	eoreq	sp, sl, fp, lsl #26
    4a34:	e10b0300 	mrs	r0, (UNDEF: 59)
    4a38:	04000025 	streq	r0, [r0], #-37	; 0xffffffdb
    4a3c:	0029a40b 	eoreq	sl, r9, fp, lsl #8
    4a40:	ca0b0500 	bgt	2c5e48 <__bss_end+0x2b9f40>
    4a44:	06000028 	streq	r0, [r0], -r8, lsr #32
    4a48:	001d1f0b 	andseq	r1, sp, fp, lsl #30
    4a4c:	b90b0700 	stmdblt	fp, {r8, r9, sl}
    4a50:	08000029 	stmdaeq	r0, {r0, r3, r5}
    4a54:	0029c70b 	eoreq	ip, r9, fp, lsl #14
    4a58:	b80b0900 	stmdalt	fp, {r8, fp}
    4a5c:	0a00002a 	beq	4b0c <shift+0x4b0c>
    4a60:	0025230b 	eoreq	r2, r5, fp, lsl #6
    4a64:	d80b0b00 	stmdale	fp, {r8, r9, fp}
    4a68:	0c00001e 	stceq	0, cr0, [r0], {30}
    4a6c:	00228a0b 	eoreq	r8, r2, fp, lsl #20
    4a70:	100b0d00 	andne	r0, fp, r0, lsl #26
    4a74:	0e00002a 	cdpeq	0, 0, cr0, cr0, cr10, {1}
    4a78:	0022450b 	eoreq	r4, r2, fp, lsl #10
    4a7c:	5b0b0f00 	blpl	2c8684 <__bss_end+0x2bc77c>
    4a80:	10000022 	andne	r0, r0, r2, lsr #32
    4a84:	0021300b 	eoreq	r3, r1, fp
    4a88:	c50b1100 	strgt	r1, [fp, #-256]	; 0xffffff00
    4a8c:	12000025 	andne	r0, r0, #37	; 0x25
    4a90:	0021bd0b 	eoreq	fp, r1, fp, lsl #26
    4a94:	750b1300 	strvc	r1, [fp, #-768]	; 0xfffffd00
    4a98:	1400002e 	strne	r0, [r0], #-46	; 0xffffffd2
    4a9c:	00268d0b 	eoreq	r8, r6, fp, lsl #26
    4aa0:	ea0b1500 	b	2c9ea8 <__bss_end+0x2bdfa0>
    4aa4:	16000023 	strne	r0, [r0], -r3, lsr #32
    4aa8:	001d7c0b 	andseq	r7, sp, fp, lsl #24
    4aac:	000b1700 	andeq	r1, fp, r0, lsl #14
    4ab0:	1800002b 	stmdane	r0, {r0, r1, r3, r5}
    4ab4:	002d0a0b 	eoreq	r0, sp, fp, lsl #20
    4ab8:	0e0b1900 	vmlaeq.f16	s2, s22, s0	; <UNPREDICTABLE>
    4abc:	1a00002b 	bne	4b70 <shift+0x4b70>
    4ac0:	00220d0b 	eoreq	r0, r2, fp, lsl #26
    4ac4:	1c0b1b00 			; <UNDEFINED> instruction: 0x1c0b1b00
    4ac8:	1c00002b 	stcne	0, cr0, [r0], {43}	; 0x2b
    4acc:	001bd80b 	andseq	sp, fp, fp, lsl #16
    4ad0:	2a0b1d00 	bcs	2cbed8 <__bss_end+0x2bffd0>
    4ad4:	1e00002b 	cdpne	0, 0, cr0, cr0, cr11, {1}
    4ad8:	002b380b 	eoreq	r3, fp, fp, lsl #16
    4adc:	710b1f00 	tstvc	fp, r0, lsl #30
    4ae0:	2000001b 	andcs	r0, r0, fp, lsl r0
    4ae4:	0027b00b 	eoreq	fp, r7, fp
    4ae8:	970b2100 	strls	r2, [fp, -r0, lsl #2]
    4aec:	22000025 	andcs	r0, r0, #37	; 0x25
    4af0:	002af30b 	eoreq	pc, sl, fp, lsl #6
    4af4:	670b2300 	strvs	r2, [fp, -r0, lsl #6]
    4af8:	24000024 	strcs	r0, [r0], #-36	; 0xffffffdc
    4afc:	0028bb0b 	eoreq	fp, r8, fp, lsl #22
    4b00:	5d0b2500 	cfstr32pl	mvfx2, [fp, #-0]
    4b04:	26000023 	strcs	r0, [r0], -r3, lsr #32
    4b08:	0020390b 	eoreq	r3, r0, fp, lsl #18
    4b0c:	7b0b2700 	blvc	2ce714 <__bss_end+0x2c280c>
    4b10:	28000023 	stmdacs	r0, {r0, r1, r5}
    4b14:	0020d50b 	eoreq	sp, r0, fp, lsl #10
    4b18:	8b0b2900 	blhi	2cef20 <__bss_end+0x2c3018>
    4b1c:	2a000023 	bcs	4bb0 <shift+0x4bb0>
    4b20:	0025090b 	eoreq	r0, r5, fp, lsl #18
    4b24:	040b2b00 	streq	r2, [fp], #-2816	; 0xfffff500
    4b28:	2c000023 	stccs	0, cr0, [r0], {35}	; 0x23
    4b2c:	0027cf0b 	eoreq	ip, r7, fp, lsl #30
    4b30:	7a0b2d00 	bvc	2cff38 <__bss_end+0x2c4030>
    4b34:	2e000020 	cdpcs	0, 0, cr0, cr0, cr0, {1}
    4b38:	22970a00 	addscs	r0, r7, #0, 20
    4b3c:	01070000 	mrseq	r0, (UNDEF: 7)
    4b40:	000000a9 	andeq	r0, r0, r9, lsr #1
    4b44:	b5061704 	strlt	r1, [r6, #-1796]	; 0xfffff8fc
    4b48:	0b000004 	bleq	4b60 <shift+0x4b60>
    4b4c:	00001eec 	andeq	r1, r0, ip, ror #29
    4b50:	2d9e0b00 	vldrcs	d0, [lr]
    4b54:	0b010000 	bleq	44b5c <__bss_end+0x38c54>
    4b58:	00001efc 	strdeq	r1, [r0], -ip
    4b5c:	1f1f0b02 	svcne	0x001f0b02
    4b60:	0b030000 	bleq	c4b68 <__bss_end+0xb8c60>
    4b64:	00002bd7 	ldrdeq	r2, [r0], -r7
    4b68:	28350b04 	ldmdacs	r5!, {r2, r8, r9, fp}
    4b6c:	0b050000 	bleq	144b74 <__bss_end+0x138c6c>
    4b70:	00001fa9 	andeq	r1, r0, r9, lsr #31
    4b74:	211e0b06 	tstcs	lr, r6, lsl #22
    4b78:	0b070000 	bleq	1c4b80 <__bss_end+0x1b8c78>
    4b7c:	00001f2f 	andeq	r1, r0, pc, lsr #30
    4b80:	2e640b08 	vmulcs.f64	d16, d4, d8
    4b84:	0b090000 	bleq	244b8c <__bss_end+0x238c84>
    4b88:	00001c4f 	andeq	r1, r0, pc, asr #24
    4b8c:	2d8d0b0a 	vstrcs	d0, [sp, #40]	; 0x28
    4b90:	0b0b0000 	bleq	2c4b98 <__bss_end+0x2b8c90>
    4b94:	00002476 	andeq	r2, r0, r6, ror r4
    4b98:	2d210b0c 	vstmdbcs	r1!, {d0-d5}
    4b9c:	0b0d0000 	bleq	344ba4 <__bss_end+0x338c9c>
    4ba0:	000027bd 			; <UNDEFINED> instruction: 0x000027bd
    4ba4:	2a560b0e 	bcs	15877e4 <__bss_end+0x157b8dc>
    4ba8:	0b0f0000 	bleq	3c4bb0 <__bss_end+0x3b8ca8>
    4bac:	0000200a 	andeq	r2, r0, sl
    4bb0:	1f0c0b10 	svcne	0x000c0b10
    4bb4:	0b110000 	bleq	444bbc <__bss_end+0x438cb4>
    4bb8:	00002775 	andeq	r2, r0, r5, ror r7
    4bbc:	1ff50b12 	svcne	0x00f50b12
    4bc0:	0b130000 	bleq	4c4bc8 <__bss_end+0x4b8cc0>
    4bc4:	00002d7c 	andeq	r2, r0, ip, ror sp
    4bc8:	1c790b14 			; <UNDEFINED> instruction: 0x1c790b14
    4bcc:	0b150000 	bleq	544bd4 <__bss_end+0x538ccc>
    4bd0:	000023c5 	andeq	r2, r0, r5, asr #7
    4bd4:	1f3f0b16 	svcne	0x003f0b16
    4bd8:	0b170000 	bleq	5c4be0 <__bss_end+0x5b8cd8>
    4bdc:	00001c16 	andeq	r1, r0, r6, lsl ip
    4be0:	2e0a0b18 	vmovcs.32	d10[0], r0
    4be4:	0b190000 	bleq	644bec <__bss_end+0x638ce4>
    4be8:	00002ac5 	andeq	r2, r0, r5, asr #21
    4bec:	28d90b1a 	ldmcs	r9, {r1, r3, r4, r8, r9, fp}^
    4bf0:	0b1b0000 	bleq	6c4bf8 <__bss_end+0x6b8cf0>
    4bf4:	00002a3d 	andeq	r2, r0, sp, lsr sl
    4bf8:	2ba10b1c 	blcs	fe847870 <__bss_end+0xfe83b968>
    4bfc:	0b1d0000 	bleq	744c04 <__bss_end+0x738cfc>
    4c00:	00001f5f 	andeq	r1, r0, pc, asr pc
    4c04:	1cea0b1e 	vstmiane	sl!, {d16-d30}
    4c08:	0b1f0000 	bleq	7c4c10 <__bss_end+0x7b8d08>
    4c0c:	000028f2 	strdeq	r2, [r0], -r2	; <UNPREDICTABLE>
    4c10:	20560b20 	subscs	r0, r6, r0, lsr #22
    4c14:	0b210000 	bleq	844c1c <__bss_end+0x838d14>
    4c18:	00002847 	andeq	r2, r0, r7, asr #16
    4c1c:	24470b22 	strbcs	r0, [r7], #-2850	; 0xfffff4de
    4c20:	0b230000 	bleq	8c4c28 <__bss_end+0x8b8d20>
    4c24:	00001f4f 	andeq	r1, r0, pc, asr #30
    4c28:	29f50b24 	ldmibcs	r5!, {r2, r5, r8, r9, fp}^
    4c2c:	0b250000 	bleq	944c34 <__bss_end+0x938d2c>
    4c30:	00001e62 	andeq	r1, r0, r2, ror #28
    4c34:	2b860b26 	blcs	fe1878d4 <__bss_end+0xfe17b9cc>
    4c38:	0b270000 	bleq	9c4c40 <__bss_end+0x9b8d38>
    4c3c:	00002e51 	andeq	r2, r0, r1, asr lr
    4c40:	27480b28 	strbcs	r0, [r8, -r8, lsr #22]
    4c44:	0b290000 	bleq	a44c4c <__bss_end+0xa38d44>
    4c48:	000021ef 	andeq	r2, r0, pc, ror #3
    4c4c:	291c0b2a 	ldmdbcs	ip, {r1, r3, r5, r8, r9, fp}
    4c50:	0b2b0000 	bleq	ac4c58 <__bss_end+0xab8d50>
    4c54:	000024a5 	andeq	r2, r0, r5, lsr #9
    4c58:	1d3d0b2c 	vldmdbne	sp!, {d0-d21}
    4c5c:	0b2d0000 	bleq	b44c64 <__bss_end+0xb38d5c>
    4c60:	00001cc1 	andeq	r1, r0, r1, asr #25
    4c64:	2cdf0b2e 	vldmiacs	pc, {d16-<overflow reg d38>}
    4c68:	0b2f0000 	bleq	bc4c70 <__bss_end+0xbb8d68>
    4c6c:	00002433 	andeq	r2, r0, r3, lsr r4
    4c70:	1fcf0b30 	svcne	0x00cf0b30
    4c74:	0b310000 	bleq	c44c7c <__bss_end+0xc38d74>
    4c78:	00002412 	andeq	r2, r0, r2, lsl r4
    4c7c:	26c10b32 			; <UNDEFINED> instruction: 0x26c10b32
    4c80:	0b330000 	bleq	cc4c88 <__bss_end+0xcb8d80>
    4c84:	00001caf 	andeq	r1, r0, pc, lsr #25
    4c88:	2e3f0b34 	vmovcs.s16	r0, d15[2]
    4c8c:	0b350000 	bleq	d44c94 <__bss_end+0xd38d8c>
    4c90:	000024f6 	strdeq	r2, [r0], -r6
    4c94:	21880b36 	orrcs	r0, r8, r6, lsr fp
    4c98:	0b370000 	bleq	dc4ca0 <__bss_end+0xdb8d98>
    4c9c:	00002533 	andeq	r2, r0, r3, lsr r5
    4ca0:	2d470b38 	vstrcs	d16, [r7, #-224]	; 0xffffff20
    4ca4:	0b390000 	bleq	e44cac <__bss_end+0xe38da4>
    4ca8:	00001df4 	strdeq	r1, [r0], -r4
    4cac:	219b0b3a 	orrscs	r0, fp, sl, lsr fp
    4cb0:	0b3b0000 	bleq	ec4cb8 <__bss_end+0xeb8db0>
    4cb4:	00002167 	andeq	r2, r0, r7, ror #2
    4cb8:	1b800b3c 	blne	fe0079b0 <__bss_end+0xfdffbaa8>
    4cbc:	0b3d0000 	bleq	f44cc4 <__bss_end+0xf38dbc>
    4cc0:	00002488 	andeq	r2, r0, r8, lsl #9
    4cc4:	22670b3e 	rsbcs	r0, r7, #63488	; 0xf800
    4cc8:	0b3f0000 	bleq	fc4cd0 <__bss_end+0xfb8dc8>
    4ccc:	00001d08 	andeq	r1, r0, r8, lsl #26
    4cd0:	2cf30b40 	vldmiacs	r3!, {d16-<overflow reg d47>}
    4cd4:	0b410000 	bleq	1044cdc <__bss_end+0x1038dd4>
    4cd8:	000023d8 	ldrdeq	r2, [r0], -r8
    4cdc:	21510b42 	cmpcs	r1, r2, asr #22
    4ce0:	0b430000 	bleq	10c4ce8 <__bss_end+0x10b8de0>
    4ce4:	00001bc1 	andeq	r1, r0, r1, asr #23
    4ce8:	23350b44 	teqcs	r5, #68, 22	; 0x11000
    4cec:	0b450000 	bleq	1144cf4 <__bss_end+0x1138dec>
    4cf0:	00002321 	andeq	r2, r0, r1, lsr #6
    4cf4:	289c0b46 	ldmcs	ip, {r1, r2, r6, r8, r9, fp}
    4cf8:	0b470000 	bleq	11c4d00 <__bss_end+0x11b8df8>
    4cfc:	00002964 	andeq	r2, r0, r4, ror #18
    4d00:	2cbe0b48 	vldmiacs	lr!, {d0-<overflow reg d35>}
    4d04:	0b490000 	bleq	1244d0c <__bss_end+0x1238e04>
    4d08:	00002087 	andeq	r2, r0, r7, lsl #1
    4d0c:	26770b4a 	ldrbtcs	r0, [r7], -sl, asr #22
    4d10:	0b4b0000 	bleq	12c4d18 <__bss_end+0x12b8e10>
    4d14:	00002931 	andeq	r2, r0, r1, lsr r9
    4d18:	27de0b4c 	ldrbcs	r0, [lr, ip, asr #22]
    4d1c:	0b4d0000 	bleq	1344d24 <__bss_end+0x1338e1c>
    4d20:	000027f2 	strdeq	r2, [r0], -r2	; <UNPREDICTABLE>
    4d24:	28060b4e 	stmdacs	r6, {r1, r2, r3, r6, r8, r9, fp}
    4d28:	0b4f0000 	bleq	13c4d30 <__bss_end+0x13b8e28>
    4d2c:	00001e82 	andeq	r1, r0, r2, lsl #29
    4d30:	1ddf0b50 	vldrne	d16, [pc, #320]	; 4e78 <shift+0x4e78>
    4d34:	0b510000 	bleq	1444d3c <__bss_end+0x1438e34>
    4d38:	00001e07 	andeq	r1, r0, r7, lsl #28
    4d3c:	2a680b52 	bcs	1a07a8c <__bss_end+0x19fbb84>
    4d40:	0b530000 	bleq	14c4d48 <__bss_end+0x14b8e40>
    4d44:	00001e4d 	andeq	r1, r0, sp, asr #28
    4d48:	2a7c0b54 	bcs	1f07aa0 <__bss_end+0x1efbb98>
    4d4c:	0b550000 	bleq	1544d54 <__bss_end+0x1538e4c>
    4d50:	00002a90 	muleq	r0, r0, sl
    4d54:	2aa40b56 	bcs	fe907ab4 <__bss_end+0xfe8fbbac>
    4d58:	0b570000 	bleq	15c4d60 <__bss_end+0x15b8e58>
    4d5c:	00001fe1 	andeq	r1, r0, r1, ror #31
    4d60:	1fbb0b58 	svcne	0x00bb0b58
    4d64:	0b590000 	bleq	1644d6c <__bss_end+0x1638e64>
    4d68:	00002349 	andeq	r2, r0, r9, asr #6
    4d6c:	25460b5a 	strbcs	r0, [r6, #-2906]	; 0xfffff4a6
    4d70:	0b5b0000 	bleq	16c4d78 <__bss_end+0x16b8e70>
    4d74:	000022cf 	andeq	r2, r0, pc, asr #5
    4d78:	1b540b5c 	blne	1507af0 <__bss_end+0x14fbbe8>
    4d7c:	0b5d0000 	bleq	1744d84 <__bss_end+0x1738e7c>
    4d80:	00002109 	andeq	r2, r0, r9, lsl #2
    4d84:	256f0b5e 	strbcs	r0, [pc, #-2910]!	; 422e <shift+0x422e>
    4d88:	0b5f0000 	bleq	17c4d90 <__bss_end+0x17b8e88>
    4d8c:	0000239b 	muleq	r0, fp, r3
    4d90:	285a0b60 	ldmdacs	sl, {r5, r6, r8, r9, fp}^
    4d94:	0b610000 	bleq	1844d9c <__bss_end+0x1838e94>
    4d98:	00002dbc 			; <UNDEFINED> instruction: 0x00002dbc
    4d9c:	26620b62 	strbtcs	r0, [r2], -r2, ror #22
    4da0:	0b630000 	bleq	18c4da8 <__bss_end+0x18b8ea0>
    4da4:	000020ac 	andeq	r2, r0, ip, lsr #1
    4da8:	1c280b64 			; <UNDEFINED> instruction: 0x1c280b64
    4dac:	0b650000 	bleq	1944db4 <__bss_end+0x1938eac>
    4db0:	00001be6 	andeq	r1, r0, r6, ror #23
    4db4:	25a70b66 	strcs	r0, [r7, #2918]!	; 0xb66
    4db8:	0b670000 	bleq	19c4dc0 <__bss_end+0x19b8eb8>
    4dbc:	000026e2 	andeq	r2, r0, r2, ror #13
    4dc0:	287e0b68 	ldmdacs	lr!, {r3, r5, r6, r8, r9, fp}^
    4dc4:	0b690000 	bleq	1a44dcc <__bss_end+0x1a38ec4>
    4dc8:	000023b0 			; <UNDEFINED> instruction: 0x000023b0
    4dcc:	2df50b6a 			; <UNDEFINED> instruction: 0x2df50b6a
    4dd0:	0b6b0000 	bleq	1ac4dd8 <__bss_end+0x1ab8ed0>
    4dd4:	000024c6 	andeq	r2, r0, r6, asr #9
    4dd8:	1ba50b6c 	blne	fe947b90 <__bss_end+0xfe93bc88>
    4ddc:	0b6d0000 	bleq	1b44de4 <__bss_end+0x1b38edc>
    4de0:	00001cd5 	ldrdeq	r1, [r0], -r5
    4de4:	20c00b6e 	sbccs	r0, r0, lr, ror #22
    4de8:	0b6f0000 	bleq	1bc4df0 <__bss_end+0x1bb8ee8>
    4dec:	00001f70 	andeq	r1, r0, r0, ror pc
    4df0:	02020070 	andeq	r0, r2, #112	; 0x70
    4df4:	0011d207 	andseq	sp, r1, r7, lsl #4
    4df8:	04d20c00 	ldrbeq	r0, [r2], #3072	; 0xc00
    4dfc:	04c70000 	strbeq	r0, [r7], #0
    4e00:	000d0000 	andeq	r0, sp, r0
    4e04:	0004bc0e 	andeq	fp, r4, lr, lsl #24
    4e08:	de040500 	cfsh32le	mvfx0, mvfx4, #0
    4e0c:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
    4e10:	000004cc 	andeq	r0, r0, ip, asr #9
    4e14:	8d080102 	stfhis	f0, [r8, #-8]
    4e18:	0e000010 	mcreq	0, 0, r0, cr0, cr0, {0}
    4e1c:	000004d7 	ldrdeq	r0, [r0], -r7
    4e20:	001d6d0f 	andseq	r6, sp, pc, lsl #26
    4e24:	01440500 	cmpeq	r4, r0, lsl #10
    4e28:	0004c71a 	andeq	ip, r4, sl, lsl r7
    4e2c:	21410f00 	cmpcs	r1, r0, lsl #30
    4e30:	79050000 	stmdbvc	r5, {}	; <UNPREDICTABLE>
    4e34:	04c71a01 	strbeq	r1, [r7], #2561	; 0xa01
    4e38:	d70c0000 	strle	r0, [ip, -r0]
    4e3c:	08000004 	stmdaeq	r0, {r2}
    4e40:	0d000005 	stceq	0, cr0, [r0, #-20]	; 0xffffffec
    4e44:	236d0900 	cmncs	sp, #0, 18
    4e48:	2d060000 	stccs	0, cr0, [r6, #-0]
    4e4c:	0004fd0d 	andeq	pc, r4, sp, lsl #26
    4e50:	2b620900 	blcs	1887258 <__bss_end+0x187b350>
    4e54:	35060000 	strcc	r0, [r6, #-0]
    4e58:	0001fc1c 	andeq	pc, r1, ip, lsl ip	; <UNPREDICTABLE>
    4e5c:	201d0a00 	andscs	r0, sp, r0, lsl #20
    4e60:	01070000 	mrseq	r0, (UNDEF: 7)
    4e64:	000000a9 	andeq	r0, r0, r9, lsr #1
    4e68:	930e3706 	movwls	r3, #59142	; 0xe706
    4e6c:	0b000005 	bleq	4e88 <shift+0x4e88>
    4e70:	00001bba 			; <UNDEFINED> instruction: 0x00001bba
    4e74:	22540b00 	subscs	r0, r4, #0, 22
    4e78:	0b010000 	bleq	44e80 <__bss_end+0x38f78>
    4e7c:	00002d59 	andeq	r2, r0, r9, asr sp
    4e80:	2d340b02 	vldmdbcs	r4!, {d0}
    4e84:	0b030000 	bleq	c4e8c <__bss_end+0xb8f84>
    4e88:	00002610 	andeq	r2, r0, r0, lsl r6
    4e8c:	29b20b04 	ldmibcs	r2!, {r2, r8, r9, fp}
    4e90:	0b050000 	bleq	144e98 <__bss_end+0x138f90>
    4e94:	00001db0 			; <UNDEFINED> instruction: 0x00001db0
    4e98:	1d920b06 	vldrne	d0, [r2, #24]
    4e9c:	0b070000 	bleq	1c4ea4 <__bss_end+0x1b8f9c>
    4ea0:	00001ee5 	andeq	r1, r0, r5, ror #29
    4ea4:	249e0b08 	ldrcs	r0, [lr], #2824	; 0xb08
    4ea8:	0b090000 	bleq	244eb0 <__bss_end+0x238fa8>
    4eac:	00001db7 			; <UNDEFINED> instruction: 0x00001db7
    4eb0:	1e230b0a 	vmulne.f64	d0, d3, d10
    4eb4:	0b0b0000 	bleq	2c4ebc <__bss_end+0x2b8fb4>
    4eb8:	00001e1c 	andeq	r1, r0, ip, lsl lr
    4ebc:	1da90b0c 			; <UNDEFINED> instruction: 0x1da90b0c
    4ec0:	0b0d0000 	bleq	344ec8 <__bss_end+0x338fc0>
    4ec4:	00002a09 	andeq	r2, r0, r9, lsl #20
    4ec8:	27000b0e 	strcs	r0, [r0, -lr, lsl #22]
    4ecc:	000f0000 	andeq	r0, pc, r0
    4ed0:	0028b404 	eoreq	fp, r8, r4, lsl #8
    4ed4:	013c0600 	teqeq	ip, r0, lsl #12
    4ed8:	00000520 	andeq	r0, r0, r0, lsr #10
    4edc:	00298509 	eoreq	r8, r9, r9, lsl #10
    4ee0:	0f3e0600 	svceq	0x003e0600
    4ee4:	00000593 	muleq	r0, r3, r5
    4ee8:	002a2c09 	eoreq	r2, sl, r9, lsl #24
    4eec:	0c470600 	mcrreq	6, 0, r0, r7, cr0
    4ef0:	0000003a 	andeq	r0, r0, sl, lsr r0
    4ef4:	001d5d09 	andseq	r5, sp, r9, lsl #26
    4ef8:	0c480600 	mcrreq	6, 0, r0, r8, cr0
    4efc:	0000003a 	andeq	r0, r0, sl, lsr r0
    4f00:	002b4610 	eoreq	r4, fp, r0, lsl r6
    4f04:	29940900 	ldmibcs	r4, {r8, fp}
    4f08:	49060000 	stmdbmi	r6, {}	; <UNPREDICTABLE>
    4f0c:	0005d414 	andeq	sp, r5, r4, lsl r4
    4f10:	c3040500 	movwgt	r0, #17664	; 0x4500
    4f14:	11000005 	tstne	r0, r5
    4f18:	00221e09 	eoreq	r1, r2, r9, lsl #28
    4f1c:	0f4b0600 	svceq	0x004b0600
    4f20:	000005e7 	andeq	r0, r0, r7, ror #11
    4f24:	05da0405 	ldrbeq	r0, [sl, #1029]	; 0x405
    4f28:	07120000 	ldreq	r0, [r2, -r0]
    4f2c:	09000029 	stmdbeq	r0, {r0, r3, r5}
    4f30:	000025fd 	strdeq	r2, [r0], -sp
    4f34:	fe0d4f06 	cdp2	15, 0, cr4, cr13, cr6, {0}
    4f38:	05000005 	streq	r0, [r0, #-5]
    4f3c:	0005ed04 	andeq	lr, r5, r4, lsl #26
    4f40:	1ecb1300 	cdpne	3, 12, cr1, cr11, cr0, {0}
    4f44:	06340000 	ldrteq	r0, [r4], -r0
    4f48:	2f150158 	svccs	0x00150158
    4f4c:	14000006 	strne	r0, [r0], #-6
    4f50:	00002376 	andeq	r2, r0, r6, ror r3
    4f54:	0f015a06 	svceq	0x00015a06
    4f58:	000004cc 	andeq	r0, r0, ip, asr #9
    4f5c:	1eaf1400 	cdpne	4, 10, cr1, cr15, cr0, {0}
    4f60:	5b060000 	blpl	184f68 <__bss_end+0x179060>
    4f64:	06341401 	ldrteq	r1, [r4], -r1, lsl #8
    4f68:	00040000 	andeq	r0, r4, r0
    4f6c:	0006040e 	andeq	r0, r6, lr, lsl #8
    4f70:	00cf0c00 	sbceq	r0, pc, r0, lsl #24
    4f74:	06440000 	strbeq	r0, [r4], -r0
    4f78:	2c150000 	ldccs	0, cr0, [r5], {-0}
    4f7c:	2d000000 	stccs	0, cr0, [r0, #-0]
    4f80:	062f0c00 	strteq	r0, [pc], -r0, lsl #24
    4f84:	064f0000 	strbeq	r0, [pc], -r0
    4f88:	000d0000 	andeq	r0, sp, r0
    4f8c:	0006440e 	andeq	r4, r6, lr, lsl #8
    4f90:	22a60f00 	adccs	r0, r6, #0, 30
    4f94:	5c060000 	stcpl	0, cr0, [r6], {-0}
    4f98:	064f0301 	strbeq	r0, [pc], -r1, lsl #6
    4f9c:	160f0000 	strne	r0, [pc], -r0
    4fa0:	06000025 	streq	r0, [r0], -r5, lsr #32
    4fa4:	3a0c015f 	bcc	305528 <__bss_end+0x2f9620>
    4fa8:	16000000 	strne	r0, [r0], -r0
    4fac:	00002945 	andeq	r2, r0, r5, asr #18
    4fb0:	00a90107 	adceq	r0, r9, r7, lsl #2
    4fb4:	72060000 	andvc	r0, r6, #0
    4fb8:	07240601 	streq	r0, [r4, -r1, lsl #12]!
    4fbc:	f10b0000 			; <UNDEFINED> instruction: 0xf10b0000
    4fc0:	00000025 	andeq	r0, r0, r5, lsr #32
    4fc4:	001c610b 	andseq	r6, ip, fp, lsl #2
    4fc8:	6d0b0200 	sfmvs	f0, 4, [fp, #-0]
    4fcc:	0300001c 	movweq	r0, #28
    4fd0:	0020490b 	eoreq	r4, r0, fp, lsl #18
    4fd4:	2d0b0300 	stccs	3, cr0, [fp, #-0]
    4fd8:	04000026 	streq	r0, [r0], #-38	; 0xffffffda
    4fdc:	0021b00b 	eoreq	fp, r1, fp
    4fe0:	8b0b0400 	blhi	2c5fe8 <__bss_end+0x2ba0e0>
    4fe4:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    4fe8:	00227d0b 	eoreq	r7, r2, fp, lsl #26
    4fec:	b70b0500 	strlt	r0, [fp, -r0, lsl #10]
    4ff0:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    4ff4:	0021e10b 	eoreq	lr, r1, fp, lsl #2
    4ff8:	4e0b0500 	cfsh32mi	mvfx0, mvfx11, #0
    4ffc:	0500001d 	streq	r0, [r0, #-29]	; 0xffffffe3
    5000:	001c970b 	andseq	r9, ip, fp, lsl #14
    5004:	260b0600 	strcs	r0, [fp], -r0, lsl #12
    5008:	06000024 	streq	r0, [r0], -r4, lsr #32
    500c:	001ea10b 	andseq	sl, lr, fp, lsl #2
    5010:	3b0b0600 	blcc	2c6818 <__bss_end+0x2ba910>
    5014:	06000027 	streq	r0, [r0], -r7, lsr #32
    5018:	0029d50b 	eoreq	sp, r9, fp, lsl #10
    501c:	5a0b0600 	bpl	2c6824 <__bss_end+0x2ba91c>
    5020:	06000024 	streq	r0, [r0], -r4, lsr #32
    5024:	0024b90b 	eoreq	fp, r4, fp, lsl #18
    5028:	a30b0600 	movwge	r0, #46592	; 0xb600
    502c:	0700001c 	smladeq	r0, ip, r0, r0
    5030:	0025d40b 	eoreq	sp, r5, fp, lsl #8
    5034:	390b0700 	stmdbcc	fp, {r8, r9, sl}
    5038:	07000026 	streq	r0, [r0, -r6, lsr #32]
    503c:	002a1f0b 	eoreq	r1, sl, fp, lsl #30
    5040:	740b0700 	strvc	r0, [fp], #-1792	; 0xfffff900
    5044:	0700001e 	smladeq	r0, lr, r0, r0
    5048:	0026b40b 	eoreq	fp, r6, fp, lsl #8
    504c:	040b0800 	streq	r0, [fp], #-2048	; 0xfffff800
    5050:	0800001c 	stmdaeq	r0, {r2, r3, r4}
    5054:	0029e30b 	eoreq	lr, r9, fp, lsl #6
    5058:	d50b0800 	strle	r0, [fp, #-2048]	; 0xfffff800
    505c:	08000026 	stmdaeq	r0, {r1, r2, r5}
    5060:	2d6e0f00 	stclcs	15, cr0, [lr, #-0]
    5064:	92060000 	andls	r0, r6, #0
    5068:	066e1f01 	strbteq	r1, [lr], -r1, lsl #30
    506c:	7d0f0000 	stcvc	0, cr0, [pc, #-0]	; 5074 <shift+0x5074>
    5070:	06000021 	streq	r0, [r0], -r1, lsr #32
    5074:	3a0c0195 	bcc	3056d0 <__bss_end+0x2f97c8>
    5078:	0f000000 	svceq	0x00000000
    507c:	00002707 	andeq	r2, r0, r7, lsl #14
    5080:	0c019806 	stceq	8, cr9, [r1], {6}
    5084:	0000003a 	andeq	r0, r0, sl, lsr r0
    5088:	0022c40f 	eoreq	ip, r2, pc, lsl #8
    508c:	019b0600 	orrseq	r0, fp, r0, lsl #12
    5090:	00003a0c 	andeq	r3, r0, ip, lsl #20
    5094:	27110f00 	ldrcs	r0, [r1, -r0, lsl #30]
    5098:	9e060000 	cdpls	0, 0, cr0, cr6, cr0, {0}
    509c:	003a0c01 	eorseq	r0, sl, r1, lsl #24
    50a0:	070f0000 	streq	r0, [pc, -r0]
    50a4:	06000024 	streq	r0, [r0], -r4, lsr #32
    50a8:	3a0c01a1 	bcc	305734 <__bss_end+0x2f982c>
    50ac:	0f000000 	svceq	0x00000000
    50b0:	0000275b 	andeq	r2, r0, fp, asr r7
    50b4:	0c01a406 	cfstrseq	mvf10, [r1], {6}
    50b8:	0000003a 	andeq	r0, r0, sl, lsr r0
    50bc:	0026170f 	eoreq	r1, r6, pc, lsl #14
    50c0:	01a70600 			; <UNDEFINED> instruction: 0x01a70600
    50c4:	00003a0c 	andeq	r3, r0, ip, lsl #20
    50c8:	26220f00 	strtcs	r0, [r2], -r0, lsl #30
    50cc:	aa060000 	bge	1850d4 <__bss_end+0x1791cc>
    50d0:	003a0c01 	eorseq	r0, sl, r1, lsl #24
    50d4:	1b0f0000 	blne	3c50dc <__bss_end+0x3b91d4>
    50d8:	06000027 	streq	r0, [r0], -r7, lsr #32
    50dc:	3a0c01ad 	bcc	305798 <__bss_end+0x2f9890>
    50e0:	0f000000 	svceq	0x00000000
    50e4:	000023f9 	strdeq	r2, [r0], -r9
    50e8:	0c01b006 	stceq	0, cr11, [r1], {6}
    50ec:	0000003a 	andeq	r0, r0, sl, lsr r0
    50f0:	002db00f 	eoreq	fp, sp, pc
    50f4:	01b30600 			; <UNDEFINED> instruction: 0x01b30600
    50f8:	00003a0c 	andeq	r3, r0, ip, lsl #20
    50fc:	27250f00 	strcs	r0, [r5, -r0, lsl #30]!
    5100:	b6060000 	strlt	r0, [r6], -r0
    5104:	003a0c01 	eorseq	r0, sl, r1, lsl #24
    5108:	8d0f0000 	stchi	0, cr0, [pc, #-0]	; 5110 <shift+0x5110>
    510c:	0600002e 	streq	r0, [r0], -lr, lsr #32
    5110:	3a0c01b9 	bcc	3057fc <__bss_end+0x2f98f4>
    5114:	0f000000 	svceq	0x00000000
    5118:	00002d3b 	andeq	r2, r0, fp, lsr sp
    511c:	0c01bc06 	stceq	12, cr11, [r1], {6}
    5120:	0000003a 	andeq	r0, r0, sl, lsr r0
    5124:	002d600f 	eoreq	r6, sp, pc
    5128:	01c00600 	biceq	r0, r0, r0, lsl #12
    512c:	00003a0c 	andeq	r3, r0, ip, lsl #20
    5130:	2e800f00 	cdpcs	15, 8, cr0, cr0, cr0, {0}
    5134:	c3060000 	movwgt	r0, #24576	; 0x6000
    5138:	003a0c01 	eorseq	r0, sl, r1, lsl #24
    513c:	be0f0000 	cdplt	0, 0, cr0, cr15, cr0, {0}
    5140:	0600001d 			; <UNDEFINED> instruction: 0x0600001d
    5144:	3a0c01c6 	bcc	305864 <__bss_end+0x2f995c>
    5148:	0f000000 	svceq	0x00000000
    514c:	00001b95 	muleq	r0, r5, fp
    5150:	0c01c906 			; <UNDEFINED> instruction: 0x0c01c906
    5154:	0000003a 	andeq	r0, r0, sl, lsr r0
    5158:	0020690f 	eoreq	r6, r0, pc, lsl #18
    515c:	01cc0600 	biceq	r0, ip, r0, lsl #12
    5160:	00003a0c 	andeq	r3, r0, ip, lsl #20
    5164:	1d990f00 	ldcne	15, cr0, [r9]
    5168:	cf060000 	svcgt	0x00060000
    516c:	003a0c01 	eorseq	r0, sl, r1, lsl #24
    5170:	650f0000 	strvs	r0, [pc, #-0]	; 5178 <shift+0x5178>
    5174:	06000027 	streq	r0, [r0], -r7, lsr #32
    5178:	3a0c01d2 	bcc	3058c8 <__bss_end+0x2f99c0>
    517c:	0f000000 	svceq	0x00000000
    5180:	000022ec 	andeq	r2, r0, ip, ror #5
    5184:	0c01d506 	cfstr32eq	mvfx13, [r1], {6}
    5188:	0000003a 	andeq	r0, r0, sl, lsr r0
    518c:	0025840f 	eoreq	r8, r5, pc, lsl #8
    5190:	01d80600 	bicseq	r0, r8, r0, lsl #12
    5194:	00003a0c 	andeq	r3, r0, ip, lsl #20
    5198:	2b6b0f00 	blcs	1ac8da0 <__bss_end+0x1abce98>
    519c:	df060000 	svcle	0x00060000
    51a0:	003a0c01 	eorseq	r0, sl, r1, lsl #24
    51a4:	1f0f0000 	svcne	0x000f0000
    51a8:	0600002e 	streq	r0, [r0], -lr, lsr #32
    51ac:	3a0c01e2 	bcc	30593c <__bss_end+0x2f9a34>
    51b0:	0f000000 	svceq	0x00000000
    51b4:	00002e2f 	andeq	r2, r0, pc, lsr #28
    51b8:	0c01e506 	cfstr32eq	mvfx14, [r1], {6}
    51bc:	0000003a 	andeq	r0, r0, sl, lsr r0
    51c0:	001eb80f 	andseq	fp, lr, pc, lsl #16
    51c4:	01e80600 	mvneq	r0, r0, lsl #12
    51c8:	00003a0c 	andeq	r3, r0, ip, lsl #20
    51cc:	2bb20f00 	blcs	fec88dd4 <__bss_end+0xfec7cecc>
    51d0:	eb060000 	bl	1851d8 <__bss_end+0x1792d0>
    51d4:	003a0c01 	eorseq	r0, sl, r1, lsl #24
    51d8:	9c0f0000 	stcls	0, cr0, [pc], {-0}
    51dc:	06000026 	streq	r0, [r0], -r6, lsr #32
    51e0:	3a0c01ee 	bcc	3059a0 <__bss_end+0x2f9a98>
    51e4:	0f000000 	svceq	0x00000000
    51e8:	000020e2 	andeq	r2, r0, r2, ror #1
    51ec:	0c01f206 	sfmeq	f7, 1, [r1], {6}
    51f0:	0000003a 	andeq	r0, r0, sl, lsr r0
    51f4:	0029570f 	eoreq	r5, r9, pc, lsl #14
    51f8:	01fa0600 	mvnseq	r0, r0, lsl #12
    51fc:	00003a0c 	andeq	r3, r0, ip, lsl #20
    5200:	1f9b0f00 	svcne	0x009b0f00
    5204:	fd060000 	stc2	0, cr0, [r6, #-0]
    5208:	003a0c01 	eorseq	r0, sl, r1, lsl #24
    520c:	3a0c0000 	bcc	305214 <__bss_end+0x2f930c>
    5210:	dc000000 	stcle	0, cr0, [r0], {-0}
    5214:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
    5218:	21cc0f00 	biccs	r0, ip, r0, lsl #30
    521c:	eb060000 	bl	185224 <__bss_end+0x17931c>
    5220:	08d10c03 	ldmeq	r1, {r0, r1, sl, fp}^
    5224:	d40c0000 	strle	r0, [ip], #-0
    5228:	f9000005 			; <UNDEFINED> instruction: 0xf9000005
    522c:	15000008 	strne	r0, [r0, #-8]
    5230:	0000002c 	andeq	r0, r0, ip, lsr #32
    5234:	9b0f000d 	blls	3c5270 <__bss_end+0x3b9368>
    5238:	06000027 	streq	r0, [r0], -r7, lsr #32
    523c:	e9140574 	ldmdb	r4, {r2, r4, r5, r6, r8, sl}
    5240:	16000008 	strne	r0, [r0], -r8
    5244:	000022af 	andeq	r2, r0, pc, lsr #5
    5248:	00a90107 	adceq	r0, r9, r7, lsl #2
    524c:	7b060000 	blvc	185254 <__bss_end+0x17934c>
    5250:	09440605 	stmdbeq	r4, {r0, r2, r9, sl}^
    5254:	2b0b0000 	blcs	2c525c <__bss_end+0x2b9354>
    5258:	00000020 	andeq	r0, r0, r0, lsr #32
    525c:	0024e40b 	eoreq	lr, r4, fp, lsl #8
    5260:	3a0b0100 	bcc	2c5668 <__bss_end+0x2b9760>
    5264:	0200001c 	andeq	r0, r0, #28
    5268:	002de10b 	eoreq	lr, sp, fp, lsl #2
    526c:	270b0300 	strcs	r0, [fp, -r0, lsl #6]
    5270:	04000028 	streq	r0, [r0], #-40	; 0xffffffd8
    5274:	00281a0b 	eoreq	r1, r8, fp, lsl #20
    5278:	2d0b0500 	cfstr32cs	mvfx0, [fp, #-0]
    527c:	0600001d 			; <UNDEFINED> instruction: 0x0600001d
    5280:	2dd10f00 	ldclcs	15, cr0, [r1]
    5284:	88060000 	stmdahi	r6, {}	; <UNPREDICTABLE>
    5288:	09061505 	stmdbeq	r6, {r0, r2, r8, sl, ip}
    528c:	ad0f0000 	stcge	0, cr0, [pc, #-0]	; 5294 <shift+0x5294>
    5290:	0600002c 	streq	r0, [r0], -ip, lsr #32
    5294:	2c110789 	ldccs	7, cr0, [r1], {137}	; 0x89
    5298:	0f000000 	svceq	0x00000000
    529c:	00002788 	andeq	r2, r0, r8, lsl #15
    52a0:	0c079e06 	stceq	14, cr9, [r7], {6}
    52a4:	0000003a 	andeq	r0, r0, sl, lsr r0
    52a8:	002b5a04 	eoreq	r5, fp, r4, lsl #20
    52ac:	167b0700 	ldrbtne	r0, [fp], -r0, lsl #14
    52b0:	000000a9 	andeq	r0, r0, r9, lsr #1
    52b4:	00096b0e 	andeq	r6, r9, lr, lsl #22
    52b8:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    52bc:	00000de7 	andeq	r0, r0, r7, ror #27
    52c0:	002ecd04 	eoreq	ip, lr, r4, lsl #26
    52c4:	16810700 	strne	r0, [r1], r0, lsl #14
    52c8:	0000002c 	andeq	r0, r0, ip, lsr #32
    52cc:	0009830e 	andeq	r8, r9, lr, lsl #6
    52d0:	2ec50400 	cdpcs	4, 12, cr0, cr5, cr0, {0}
    52d4:	85070000 	strhi	r0, [r7, #-0]
    52d8:	0009a016 	andeq	sl, r9, r6, lsl r0
    52dc:	07080200 	streq	r0, [r8, -r0, lsl #4]
    52e0:	00001f84 	andeq	r1, r0, r4, lsl #31
    52e4:	002eb404 	eoreq	fp, lr, r4, lsl #8
    52e8:	10930700 	addsne	r0, r3, r0, lsl #14
    52ec:	00000033 	andeq	r0, r0, r3, lsr r0
    52f0:	d1030802 	tstle	r3, r2, lsl #16
    52f4:	0400001d 	streq	r0, [r0], #-29	; 0xffffffe3
    52f8:	00002ed5 	ldrdeq	r2, [r0], -r5
    52fc:	25109707 	ldrcs	r9, [r0, #-1799]	; 0xfffff8f9
    5300:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    5304:	000009ba 			; <UNDEFINED> instruction: 0x000009ba
    5308:	6f031002 	svcvs	0x00031002
    530c:	0c000028 	stceq	0, cr0, [r0], {40}	; 0x28
    5310:	00000977 	andeq	r0, r0, r7, ror r9
    5314:	000009e2 	andeq	r0, r0, r2, ror #19
    5318:	00002c15 	andeq	r2, r0, r5, lsl ip
    531c:	0e00ff00 	cdpeq	15, 0, cr15, cr0, cr0, {0}
    5320:	000009d2 	ldrdeq	r0, [r0], -r2
    5324:	0026460f 	eoreq	r4, r6, pc, lsl #12
    5328:	01fc0700 	mvnseq	r0, r0, lsl #14
    532c:	0009e216 	andeq	lr, r9, r6, lsl r2
    5330:	1d880f00 	stcne	15, cr0, [r8]
    5334:	02070000 	andeq	r0, r7, #0
    5338:	09e21602 	stmibeq	r2!, {r1, r9, sl, ip}^
    533c:	99170000 	ldmdbls	r7, {}	; <UNPREDICTABLE>
    5340:	0100002e 	tsteq	r0, lr, lsr #32
    5344:	940105b9 	strls	r0, [r1], #-1465	; 0xfffffa47
    5348:	a0000009 	andge	r0, r0, r9
    534c:	400000b9 	strhmi	r0, [r0], -r9
    5350:	01000000 	mrseq	r0, (UNDEF: 0)
    5354:	0061189c 	mlseq	r1, ip, r8, r1
    5358:	1605b901 	strne	fp, [r5], -r1, lsl #18
    535c:	000009a7 	andeq	r0, r0, r7, lsr #19
    5360:	00000058 	andeq	r0, r0, r8, asr r0
    5364:	00000054 	andeq	r0, r0, r4, asr r0
    5368:	61666419 	cmnvs	r6, r9, lsl r4
    536c:	05bf0100 	ldreq	r0, [pc, #256]!	; 5474 <shift+0x5474>
    5370:	0009c610 	andeq	ip, r9, r0, lsl r6
    5374:	00008100 	andeq	r8, r0, r0, lsl #2
    5378:	00007b00 	andeq	r7, r0, r0, lsl #22
    537c:	69681900 	stmdbvs	r8!, {r8, fp, ip}^
    5380:	05c40100 	strbeq	r0, [r4, #256]	; 0x100
    5384:	00098f10 	andeq	r8, r9, r0, lsl pc
    5388:	0000bf00 	andeq	fp, r0, r0, lsl #30
    538c:	0000bd00 	andeq	fp, r0, r0, lsl #26
    5390:	6f6c1900 	svcvs	0x006c1900
    5394:	05c90100 	strbeq	r0, [r9, #256]	; 0x100
    5398:	00098f10 	andeq	r8, r9, r0, lsl pc
    539c:	0000d900 	andeq	sp, r0, r0, lsl #18
    53a0:	0000d300 	andeq	sp, r0, r0, lsl #6
    53a4:	b4000000 	strlt	r0, [r0], #-0
    53a8:	0400000a 	streq	r0, [r0], #-10
    53ac:	00137300 	andseq	r7, r3, r0, lsl #6
    53b0:	e9010400 	stmdb	r1, {sl}
    53b4:	0c00002e 	stceq	0, cr0, [r0], {46}	; 0x2e
    53b8:	00001e2a 	andeq	r1, r0, sl, lsr #28
    53bc:	00001a86 	andeq	r1, r0, r6, lsl #21
    53c0:	0000b9e0 	andeq	fp, r0, r0, ror #19
    53c4:	00000128 	andeq	r0, r0, r8, lsr #2
    53c8:	00001bca 	andeq	r1, r0, sl, asr #23
    53cc:	84070802 	strhi	r0, [r7], #-2050	; 0xfffff7fe
    53d0:	0300001f 	movweq	r0, #31
    53d4:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    53d8:	04020074 	streq	r0, [r2], #-116	; 0xffffff8c
    53dc:	001f8e07 	andseq	r8, pc, r7, lsl #28
    53e0:	05080200 	streq	r0, [r8, #-512]	; 0xfffffe00
    53e4:	0000037f 	andeq	r0, r0, pc, ror r3
    53e8:	2f040802 	svccs	0x00040802
    53ec:	04000027 	streq	r0, [r0], #-39	; 0xffffffd9
    53f0:	00001e97 	muleq	r0, r7, lr
    53f4:	33162a02 	tstcc	r6, #8192	; 0x2000
    53f8:	04000000 	streq	r0, [r0], #-0
    53fc:	000022fa 	strdeq	r2, [r0], -sl
    5400:	60152f02 	andsvs	r2, r5, r2, lsl #30
    5404:	05000000 	streq	r0, [r0, #-0]
    5408:	00006604 	andeq	r6, r0, r4, lsl #12
    540c:	00480600 	subeq	r0, r8, r0, lsl #12
    5410:	00750000 	rsbseq	r0, r5, r0
    5414:	75070000 	strvc	r0, [r7, #-0]
    5418:	00000000 	andeq	r0, r0, r0
    541c:	007b0405 	rsbseq	r0, fp, r5, lsl #8
    5420:	04080000 	streq	r0, [r8], #-0
    5424:	00002b99 	muleq	r0, r9, fp
    5428:	880f3602 	stmdahi	pc, {r1, r9, sl, ip, sp}	; <UNPREDICTABLE>
    542c:	05000000 	streq	r0, [r0, #-0]
    5430:	00008e04 	andeq	r8, r0, r4, lsl #28
    5434:	002c0600 	eoreq	r0, ip, r0, lsl #12
    5438:	00a20000 	adceq	r0, r2, r0
    543c:	75070000 	strvc	r0, [r7, #-0]
    5440:	07000000 	streq	r0, [r0, -r0]
    5444:	00000075 	andeq	r0, r0, r5, ror r0
    5448:	08010200 	stmdaeq	r1, {r9}
    544c:	00001084 	andeq	r1, r0, r4, lsl #1
    5450:	00255d09 	eoreq	r5, r5, r9, lsl #26
    5454:	12bb0200 	adcsne	r0, fp, #0, 4
    5458:	00000054 	andeq	r0, r0, r4, asr r0
    545c:	002bc709 	eoreq	ip, fp, r9, lsl #14
    5460:	10be0200 	adcsne	r0, lr, r0, lsl #4
    5464:	0000007c 	andeq	r0, r0, ip, ror r0
    5468:	86060102 	strhi	r0, [r6], -r2, lsl #2
    546c:	0a000010 	beq	54b4 <shift+0x54b4>
    5470:	00002201 	andeq	r2, r0, r1, lsl #4
    5474:	00a20107 	adceq	r0, r2, r7, lsl #2
    5478:	17030000 	strne	r0, [r3, -r0]
    547c:	0001f506 	andeq	pc, r1, r6, lsl #10
    5480:	1cfe0b00 	vldmiane	lr!, {d16-d15}
    5484:	0b000000 	bleq	548c <shift+0x548c>
    5488:	000020f9 	strdeq	r2, [r0], -r9
    548c:	26550b01 	ldrbcs	r0, [r5], -r1, lsl #22
    5490:	0b020000 	bleq	85498 <__bss_end+0x79590>
    5494:	00002add 	ldrdeq	r2, [r0], -sp
    5498:	25e10b03 	strbcs	r0, [r1, #2819]!	; 0xb03
    549c:	0b040000 	bleq	1054a4 <__bss_end+0xf959c>
    54a0:	000029a4 	andeq	r2, r0, r4, lsr #19
    54a4:	28ca0b05 	stmiacs	sl, {r0, r2, r8, r9, fp}^
    54a8:	0b060000 	bleq	1854b0 <__bss_end+0x1795a8>
    54ac:	00001d1f 	andeq	r1, r0, pc, lsl sp
    54b0:	29b90b07 	ldmibcs	r9!, {r0, r1, r2, r8, r9, fp}
    54b4:	0b080000 	bleq	2054bc <__bss_end+0x1f95b4>
    54b8:	000029c7 	andeq	r2, r0, r7, asr #19
    54bc:	2ab80b09 	bcs	fee080e8 <__bss_end+0xfedfc1e0>
    54c0:	0b0a0000 	bleq	2854c8 <__bss_end+0x2795c0>
    54c4:	00002523 	andeq	r2, r0, r3, lsr #10
    54c8:	1ed80b0b 	vfnmsne.f64	d16, d8, d11
    54cc:	0b0c0000 	bleq	3054d4 <__bss_end+0x2f95cc>
    54d0:	0000228a 	andeq	r2, r0, sl, lsl #5
    54d4:	2a100b0d 	bcs	408110 <__bss_end+0x3fc208>
    54d8:	0b0e0000 	bleq	3854e0 <__bss_end+0x3795d8>
    54dc:	00002245 	andeq	r2, r0, r5, asr #4
    54e0:	225b0b0f 	subscs	r0, fp, #15360	; 0x3c00
    54e4:	0b100000 	bleq	4054ec <__bss_end+0x3f95e4>
    54e8:	00002130 	andeq	r2, r0, r0, lsr r1
    54ec:	25c50b11 	strbcs	r0, [r5, #2833]	; 0xb11
    54f0:	0b120000 	bleq	4854f8 <__bss_end+0x4795f0>
    54f4:	000021bd 			; <UNDEFINED> instruction: 0x000021bd
    54f8:	2e750b13 	vmovcs.s8	r0, d5[4]
    54fc:	0b140000 	bleq	505504 <__bss_end+0x4f95fc>
    5500:	0000268d 	andeq	r2, r0, sp, lsl #13
    5504:	23ea0b15 	mvncs	r0, #21504	; 0x5400
    5508:	0b160000 	bleq	585510 <__bss_end+0x579608>
    550c:	00001d7c 	andeq	r1, r0, ip, ror sp
    5510:	2b000b17 	blcs	8174 <__aeabi_unwind_cpp_pr1+0x8>
    5514:	0b180000 	bleq	60551c <__bss_end+0x5f9614>
    5518:	00002d0a 	andeq	r2, r0, sl, lsl #26
    551c:	2b0e0b19 	blcs	388188 <__bss_end+0x37c280>
    5520:	0b1a0000 	bleq	685528 <__bss_end+0x679620>
    5524:	0000220d 	andeq	r2, r0, sp, lsl #4
    5528:	2b1c0b1b 	blcs	70819c <__bss_end+0x6fc294>
    552c:	0b1c0000 	bleq	705534 <__bss_end+0x6f962c>
    5530:	00001bd8 	ldrdeq	r1, [r0], -r8
    5534:	2b2a0b1d 	blcs	a881b0 <__bss_end+0xa7c2a8>
    5538:	0b1e0000 	bleq	785540 <__bss_end+0x779638>
    553c:	00002b38 	andeq	r2, r0, r8, lsr fp
    5540:	1b710b1f 	blne	1c481c4 <__bss_end+0x1c3c2bc>
    5544:	0b200000 	bleq	80554c <__bss_end+0x7f9644>
    5548:	000027b0 			; <UNDEFINED> instruction: 0x000027b0
    554c:	25970b21 	ldrcs	r0, [r7, #2849]	; 0xb21
    5550:	0b220000 	bleq	885558 <__bss_end+0x879650>
    5554:	00002af3 	strdeq	r2, [r0], -r3
    5558:	24670b23 	strbtcs	r0, [r7], #-2851	; 0xfffff4dd
    555c:	0b240000 	bleq	905564 <__bss_end+0x8f965c>
    5560:	000028bb 			; <UNDEFINED> instruction: 0x000028bb
    5564:	235d0b25 	cmpcs	sp, #37888	; 0x9400
    5568:	0b260000 	bleq	985570 <__bss_end+0x979668>
    556c:	00002039 	andeq	r2, r0, r9, lsr r0
    5570:	237b0b27 	cmncs	fp, #39936	; 0x9c00
    5574:	0b280000 	bleq	a0557c <__bss_end+0x9f9674>
    5578:	000020d5 	ldrdeq	r2, [r0], -r5
    557c:	238b0b29 	orrcs	r0, fp, #41984	; 0xa400
    5580:	0b2a0000 	bleq	a85588 <__bss_end+0xa79680>
    5584:	00002509 	andeq	r2, r0, r9, lsl #10
    5588:	23040b2b 	movwcs	r0, #19243	; 0x4b2b
    558c:	0b2c0000 	bleq	b05594 <__bss_end+0xaf968c>
    5590:	000027cf 	andeq	r2, r0, pc, asr #15
    5594:	207a0b2d 	rsbscs	r0, sl, sp, lsr #22
    5598:	002e0000 	eoreq	r0, lr, r0
    559c:	0022970a 	eoreq	r9, r2, sl, lsl #14
    55a0:	a2010700 	andge	r0, r1, #0, 14
    55a4:	04000000 	streq	r0, [r0], #-0
    55a8:	04ae0617 	strteq	r0, [lr], #1559	; 0x617
    55ac:	ec0b0000 	stc	0, cr0, [fp], {-0}
    55b0:	0000001e 	andeq	r0, r0, lr, lsl r0
    55b4:	002d9e0b 	eoreq	r9, sp, fp, lsl #28
    55b8:	fc0b0100 	stc2	1, cr0, [fp], {-0}
    55bc:	0200001e 	andeq	r0, r0, #30
    55c0:	001f1f0b 	andseq	r1, pc, fp, lsl #30
    55c4:	d70b0300 	strle	r0, [fp, -r0, lsl #6]
    55c8:	0400002b 	streq	r0, [r0], #-43	; 0xffffffd5
    55cc:	0028350b 	eoreq	r3, r8, fp, lsl #10
    55d0:	a90b0500 	stmdbge	fp, {r8, sl}
    55d4:	0600001f 			; <UNDEFINED> instruction: 0x0600001f
    55d8:	00211e0b 	eoreq	r1, r1, fp, lsl #28
    55dc:	2f0b0700 	svccs	0x000b0700
    55e0:	0800001f 	stmdaeq	r0, {r0, r1, r2, r3, r4}
    55e4:	002e640b 	eoreq	r6, lr, fp, lsl #8
    55e8:	4f0b0900 	svcmi	0x000b0900
    55ec:	0a00001c 	beq	5664 <shift+0x5664>
    55f0:	002d8d0b 	eoreq	r8, sp, fp, lsl #26
    55f4:	760b0b00 	strvc	r0, [fp], -r0, lsl #22
    55f8:	0c000024 	stceq	0, cr0, [r0], {36}	; 0x24
    55fc:	002d210b 	eoreq	r2, sp, fp, lsl #2
    5600:	bd0b0d00 	stclt	13, cr0, [fp, #-0]
    5604:	0e000027 	cdpeq	0, 0, cr0, cr0, cr7, {1}
    5608:	002a560b 	eoreq	r5, sl, fp, lsl #12
    560c:	0a0b0f00 	beq	2c9214 <__bss_end+0x2bd30c>
    5610:	10000020 	andne	r0, r0, r0, lsr #32
    5614:	001f0c0b 	andseq	r0, pc, fp, lsl #24
    5618:	750b1100 	strvc	r1, [fp, #-256]	; 0xffffff00
    561c:	12000027 	andne	r0, r0, #39	; 0x27
    5620:	001ff50b 	andseq	pc, pc, fp, lsl #10
    5624:	7c0b1300 	stcvc	3, cr1, [fp], {-0}
    5628:	1400002d 	strne	r0, [r0], #-45	; 0xffffffd3
    562c:	001c790b 	andseq	r7, ip, fp, lsl #18
    5630:	c50b1500 	strgt	r1, [fp, #-1280]	; 0xfffffb00
    5634:	16000023 	strne	r0, [r0], -r3, lsr #32
    5638:	001f3f0b 	andseq	r3, pc, fp, lsl #30
    563c:	160b1700 	strne	r1, [fp], -r0, lsl #14
    5640:	1800001c 	stmdane	r0, {r2, r3, r4}
    5644:	002e0a0b 	eoreq	r0, lr, fp, lsl #20
    5648:	c50b1900 	strgt	r1, [fp, #-2304]	; 0xfffff700
    564c:	1a00002a 	bne	56fc <shift+0x56fc>
    5650:	0028d90b 	eoreq	sp, r8, fp, lsl #18
    5654:	3d0b1b00 	vstrcc	d1, [fp, #-0]
    5658:	1c00002a 	stcne	0, cr0, [r0], {42}	; 0x2a
    565c:	002ba10b 	eoreq	sl, fp, fp, lsl #2
    5660:	5f0b1d00 	svcpl	0x000b1d00
    5664:	1e00001f 	mcrne	0, 0, r0, cr0, cr15, {0}
    5668:	001cea0b 	andseq	lr, ip, fp, lsl #20
    566c:	f20b1f00 	vmax.f32	d1, d11, d0
    5670:	20000028 	andcs	r0, r0, r8, lsr #32
    5674:	0020560b 	eoreq	r5, r0, fp, lsl #12
    5678:	470b2100 	strmi	r2, [fp, -r0, lsl #2]
    567c:	22000028 	andcs	r0, r0, #40	; 0x28
    5680:	0024470b 	eoreq	r4, r4, fp, lsl #14
    5684:	4f0b2300 	svcmi	0x000b2300
    5688:	2400001f 	strcs	r0, [r0], #-31	; 0xffffffe1
    568c:	0029f50b 	eoreq	pc, r9, fp, lsl #10
    5690:	620b2500 	andvs	r2, fp, #0, 10
    5694:	2600001e 			; <UNDEFINED> instruction: 0x2600001e
    5698:	002b860b 	eoreq	r8, fp, fp, lsl #12
    569c:	510b2700 	tstpl	fp, r0, lsl #14
    56a0:	2800002e 	stmdacs	r0, {r1, r2, r3, r5}
    56a4:	0027480b 	eoreq	r4, r7, fp, lsl #16
    56a8:	ef0b2900 	svc	0x000b2900
    56ac:	2a000021 	bcs	5738 <shift+0x5738>
    56b0:	00291c0b 	eoreq	r1, r9, fp, lsl #24
    56b4:	a50b2b00 	strge	r2, [fp, #-2816]	; 0xfffff500
    56b8:	2c000024 	stccs	0, cr0, [r0], {36}	; 0x24
    56bc:	001d3d0b 	andseq	r3, sp, fp, lsl #26
    56c0:	c10b2d00 	tstgt	fp, r0, lsl #26
    56c4:	2e00001c 	mcrcs	0, 0, r0, cr0, cr12, {0}
    56c8:	002cdf0b 	eoreq	sp, ip, fp, lsl #30
    56cc:	330b2f00 	movwcc	r2, #48896	; 0xbf00
    56d0:	30000024 	andcc	r0, r0, r4, lsr #32
    56d4:	001fcf0b 	andseq	ip, pc, fp, lsl #30
    56d8:	120b3100 	andne	r3, fp, #0, 2
    56dc:	32000024 	andcc	r0, r0, #36	; 0x24
    56e0:	0026c10b 	eoreq	ip, r6, fp, lsl #2
    56e4:	af0b3300 	svcge	0x000b3300
    56e8:	3400001c 	strcc	r0, [r0], #-28	; 0xffffffe4
    56ec:	002e3f0b 	eoreq	r3, lr, fp, lsl #30
    56f0:	f60b3500 			; <UNDEFINED> instruction: 0xf60b3500
    56f4:	36000024 	strcc	r0, [r0], -r4, lsr #32
    56f8:	0021880b 	eoreq	r8, r1, fp, lsl #16
    56fc:	330b3700 	movwcc	r3, #46848	; 0xb700
    5700:	38000025 	stmdacc	r0, {r0, r2, r5}
    5704:	002d470b 	eoreq	r4, sp, fp, lsl #14
    5708:	f40b3900 	vst2.8	{d3,d5}, [fp], r0
    570c:	3a00001d 	bcc	5788 <shift+0x5788>
    5710:	00219b0b 	eoreq	r9, r1, fp, lsl #22
    5714:	670b3b00 	strvs	r3, [fp, -r0, lsl #22]
    5718:	3c000021 	stccc	0, cr0, [r0], {33}	; 0x21
    571c:	001b800b 	andseq	r8, fp, fp
    5720:	880b3d00 	stmdahi	fp, {r8, sl, fp, ip, sp}
    5724:	3e000024 	cdpcc	0, 0, cr0, cr0, cr4, {1}
    5728:	0022670b 	eoreq	r6, r2, fp, lsl #14
    572c:	080b3f00 	stmdaeq	fp, {r8, r9, sl, fp, ip, sp}
    5730:	4000001d 	andmi	r0, r0, sp, lsl r0
    5734:	002cf30b 	eoreq	pc, ip, fp, lsl #6
    5738:	d80b4100 	stmdale	fp, {r8, lr}
    573c:	42000023 	andmi	r0, r0, #35	; 0x23
    5740:	0021510b 	eoreq	r5, r1, fp, lsl #2
    5744:	c10b4300 	mrsgt	r4, (UNDEF: 59)
    5748:	4400001b 	strmi	r0, [r0], #-27	; 0xffffffe5
    574c:	0023350b 	eoreq	r3, r3, fp, lsl #10
    5750:	210b4500 	tstcs	fp, r0, lsl #10
    5754:	46000023 	strmi	r0, [r0], -r3, lsr #32
    5758:	00289c0b 	eoreq	r9, r8, fp, lsl #24
    575c:	640b4700 	strvs	r4, [fp], #-1792	; 0xfffff900
    5760:	48000029 	stmdami	r0, {r0, r3, r5}
    5764:	002cbe0b 	eoreq	fp, ip, fp, lsl #28
    5768:	870b4900 	strhi	r4, [fp, -r0, lsl #18]
    576c:	4a000020 	bmi	57f4 <shift+0x57f4>
    5770:	0026770b 	eoreq	r7, r6, fp, lsl #14
    5774:	310b4b00 	tstcc	fp, r0, lsl #22
    5778:	4c000029 	stcmi	0, cr0, [r0], {41}	; 0x29
    577c:	0027de0b 	eoreq	sp, r7, fp, lsl #28
    5780:	f20b4d00 	vadd.f32	d4, d11, d0
    5784:	4e000027 	cdpmi	0, 0, cr0, cr0, cr7, {1}
    5788:	0028060b 	eoreq	r0, r8, fp, lsl #12
    578c:	820b4f00 	andhi	r4, fp, #0, 30
    5790:	5000001e 	andpl	r0, r0, lr, lsl r0
    5794:	001ddf0b 	andseq	sp, sp, fp, lsl #30
    5798:	070b5100 	streq	r5, [fp, -r0, lsl #2]
    579c:	5200001e 	andpl	r0, r0, #30
    57a0:	002a680b 	eoreq	r6, sl, fp, lsl #16
    57a4:	4d0b5300 	stcmi	3, cr5, [fp, #-0]
    57a8:	5400001e 	strpl	r0, [r0], #-30	; 0xffffffe2
    57ac:	002a7c0b 	eoreq	r7, sl, fp, lsl #24
    57b0:	900b5500 	andls	r5, fp, r0, lsl #10
    57b4:	5600002a 	strpl	r0, [r0], -sl, lsr #32
    57b8:	002aa40b 	eoreq	sl, sl, fp, lsl #8
    57bc:	e10b5700 	tst	fp, r0, lsl #14
    57c0:	5800001f 	stmdapl	r0, {r0, r1, r2, r3, r4}
    57c4:	001fbb0b 	andseq	fp, pc, fp, lsl #22
    57c8:	490b5900 	stmdbmi	fp, {r8, fp, ip, lr}
    57cc:	5a000023 	bpl	5860 <shift+0x5860>
    57d0:	0025460b 	eoreq	r4, r5, fp, lsl #12
    57d4:	cf0b5b00 	svcgt	0x000b5b00
    57d8:	5c000022 	stcpl	0, cr0, [r0], {34}	; 0x22
    57dc:	001b540b 	andseq	r5, fp, fp, lsl #8
    57e0:	090b5d00 	stmdbeq	fp, {r8, sl, fp, ip, lr}
    57e4:	5e000021 	cdppl	0, 0, cr0, cr0, cr1, {1}
    57e8:	00256f0b 	eoreq	r6, r5, fp, lsl #30
    57ec:	9b0b5f00 	blls	2dd3f4 <__bss_end+0x2d14ec>
    57f0:	60000023 	andvs	r0, r0, r3, lsr #32
    57f4:	00285a0b 	eoreq	r5, r8, fp, lsl #20
    57f8:	bc0b6100 	stflts	f6, [fp], {-0}
    57fc:	6200002d 	andvs	r0, r0, #45	; 0x2d
    5800:	0026620b 	eoreq	r6, r6, fp, lsl #4
    5804:	ac0b6300 	stcge	3, cr6, [fp], {-0}
    5808:	64000020 	strvs	r0, [r0], #-32	; 0xffffffe0
    580c:	001c280b 	andseq	r2, ip, fp, lsl #16
    5810:	e60b6500 	str	r6, [fp], -r0, lsl #10
    5814:	6600001b 			; <UNDEFINED> instruction: 0x6600001b
    5818:	0025a70b 	eoreq	sl, r5, fp, lsl #14
    581c:	e20b6700 	and	r6, fp, #0, 14
    5820:	68000026 	stmdavs	r0, {r1, r2, r5}
    5824:	00287e0b 	eoreq	r7, r8, fp, lsl #28
    5828:	b00b6900 	andlt	r6, fp, r0, lsl #18
    582c:	6a000023 	bvs	58c0 <shift+0x58c0>
    5830:	002df50b 	eoreq	pc, sp, fp, lsl #10
    5834:	c60b6b00 	strgt	r6, [fp], -r0, lsl #22
    5838:	6c000024 	stcvs	0, cr0, [r0], {36}	; 0x24
    583c:	001ba50b 	andseq	sl, fp, fp, lsl #10
    5840:	d50b6d00 	strle	r6, [fp, #-3328]	; 0xfffff300
    5844:	6e00001c 	mcrvs	0, 0, r0, cr0, cr12, {0}
    5848:	0020c00b 	eoreq	ip, r0, fp
    584c:	700b6f00 	andvc	r6, fp, r0, lsl #30
    5850:	7000001f 	andvc	r0, r0, pc, lsl r0
    5854:	07020200 	streq	r0, [r2, -r0, lsl #4]
    5858:	000011d2 	ldrdeq	r1, [r0], -r2
    585c:	0004cb0c 	andeq	ip, r4, ip, lsl #22
    5860:	0004c000 	andeq	ip, r4, r0
    5864:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    5868:	000004b5 			; <UNDEFINED> instruction: 0x000004b5
    586c:	04d70405 	ldrbeq	r0, [r7], #1029	; 0x405
    5870:	c50e0000 	strgt	r0, [lr, #-0]
    5874:	02000004 	andeq	r0, r0, #4
    5878:	108d0801 	addne	r0, sp, r1, lsl #16
    587c:	d00e0000 	andle	r0, lr, r0
    5880:	0f000004 	svceq	0x00000004
    5884:	00001d6d 	andeq	r1, r0, sp, ror #26
    5888:	1a014405 	bne	568a4 <__bss_end+0x4a99c>
    588c:	000004c0 	andeq	r0, r0, r0, asr #9
    5890:	0021410f 	eoreq	r4, r1, pc, lsl #2
    5894:	01790500 	cmneq	r9, r0, lsl #10
    5898:	0004c01a 	andeq	ip, r4, sl, lsl r0
    589c:	04d00c00 	ldrbeq	r0, [r0], #3072	; 0xc00
    58a0:	05010000 	streq	r0, [r1, #-0]
    58a4:	000d0000 	andeq	r0, sp, r0
    58a8:	00236d09 	eoreq	r6, r3, r9, lsl #26
    58ac:	0d2d0600 	stceq	6, cr0, [sp, #-0]
    58b0:	000004f6 	strdeq	r0, [r0], -r6
    58b4:	002b6209 	eoreq	r6, fp, r9, lsl #4
    58b8:	1c350600 	ldcne	6, cr0, [r5], #-0
    58bc:	000001f5 	strdeq	r0, [r0], -r5
    58c0:	00201d0a 	eoreq	r1, r0, sl, lsl #26
    58c4:	a2010700 	andge	r0, r1, #0, 14
    58c8:	06000000 	streq	r0, [r0], -r0
    58cc:	058c0e37 	streq	r0, [ip, #3639]	; 0xe37
    58d0:	ba0b0000 	blt	2c58d8 <__bss_end+0x2b99d0>
    58d4:	0000001b 	andeq	r0, r0, fp, lsl r0
    58d8:	0022540b 	eoreq	r5, r2, fp, lsl #8
    58dc:	590b0100 	stmdbpl	fp, {r8}
    58e0:	0200002d 	andeq	r0, r0, #45	; 0x2d
    58e4:	002d340b 	eoreq	r3, sp, fp, lsl #8
    58e8:	100b0300 	andne	r0, fp, r0, lsl #6
    58ec:	04000026 	streq	r0, [r0], #-38	; 0xffffffda
    58f0:	0029b20b 	eoreq	fp, r9, fp, lsl #4
    58f4:	b00b0500 	andlt	r0, fp, r0, lsl #10
    58f8:	0600001d 			; <UNDEFINED> instruction: 0x0600001d
    58fc:	001d920b 	andseq	r9, sp, fp, lsl #4
    5900:	e50b0700 	str	r0, [fp, #-1792]	; 0xfffff900
    5904:	0800001e 	stmdaeq	r0, {r1, r2, r3, r4}
    5908:	00249e0b 	eoreq	r9, r4, fp, lsl #28
    590c:	b70b0900 	strlt	r0, [fp, -r0, lsl #18]
    5910:	0a00001d 	beq	598c <shift+0x598c>
    5914:	001e230b 	andseq	r2, lr, fp, lsl #6
    5918:	1c0b0b00 			; <UNDEFINED> instruction: 0x1c0b0b00
    591c:	0c00001e 	stceq	0, cr0, [r0], {30}
    5920:	001da90b 	andseq	sl, sp, fp, lsl #18
    5924:	090b0d00 	stmdbeq	fp, {r8, sl, fp}
    5928:	0e00002a 	cdpeq	0, 0, cr0, cr0, cr10, {1}
    592c:	0027000b 	eoreq	r0, r7, fp
    5930:	04000f00 	streq	r0, [r0], #-3840	; 0xfffff100
    5934:	000028b4 			; <UNDEFINED> instruction: 0x000028b4
    5938:	19013c06 	stmdbne	r1, {r1, r2, sl, fp, ip, sp}
    593c:	09000005 	stmdbeq	r0, {r0, r2}
    5940:	00002985 	andeq	r2, r0, r5, lsl #19
    5944:	8c0f3e06 	stchi	14, cr3, [pc], {6}
    5948:	09000005 	stmdbeq	r0, {r0, r2}
    594c:	00002a2c 	andeq	r2, r0, ip, lsr #20
    5950:	2c0c4706 	stccs	7, cr4, [ip], {6}
    5954:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    5958:	00001d5d 	andeq	r1, r0, sp, asr sp
    595c:	2c0c4806 	stccs	8, cr4, [ip], {6}
    5960:	10000000 	andne	r0, r0, r0
    5964:	00002b46 	andeq	r2, r0, r6, asr #22
    5968:	00299409 	eoreq	r9, r9, r9, lsl #8
    596c:	14490600 	strbne	r0, [r9], #-1536	; 0xfffffa00
    5970:	000005cd 	andeq	r0, r0, sp, asr #11
    5974:	05bc0405 	ldreq	r0, [ip, #1029]!	; 0x405
    5978:	09110000 	ldmdbeq	r1, {}	; <UNPREDICTABLE>
    597c:	0000221e 	andeq	r2, r0, lr, lsl r2
    5980:	e00f4b06 	and	r4, pc, r6, lsl #22
    5984:	05000005 	streq	r0, [r0, #-5]
    5988:	0005d304 	andeq	sp, r5, r4, lsl #6
    598c:	29071200 	stmdbcs	r7, {r9, ip}
    5990:	fd090000 	stc2	0, cr0, [r9, #-0]
    5994:	06000025 	streq	r0, [r0], -r5, lsr #32
    5998:	05f70d4f 	ldrbeq	r0, [r7, #3407]!	; 0xd4f
    599c:	04050000 	streq	r0, [r5], #-0
    59a0:	000005e6 	andeq	r0, r0, r6, ror #11
    59a4:	001ecb13 	andseq	ip, lr, r3, lsl fp
    59a8:	58063400 	stmdapl	r6, {sl, ip, sp}
    59ac:	06281501 	strteq	r1, [r8], -r1, lsl #10
    59b0:	76140000 	ldrvc	r0, [r4], -r0
    59b4:	06000023 	streq	r0, [r0], -r3, lsr #32
    59b8:	c50f015a 	strgt	r0, [pc, #-346]	; 5866 <shift+0x5866>
    59bc:	00000004 	andeq	r0, r0, r4
    59c0:	001eaf14 	andseq	sl, lr, r4, lsl pc
    59c4:	015b0600 	cmpeq	fp, r0, lsl #12
    59c8:	00062d14 	andeq	r2, r6, r4, lsl sp
    59cc:	0e000400 	cfcpyseq	mvf0, mvf0
    59d0:	000005fd 	strdeq	r0, [r0], -sp
    59d4:	0000c80c 	andeq	ip, r0, ip, lsl #16
    59d8:	00063d00 	andeq	r3, r6, r0, lsl #26
    59dc:	00331500 	eorseq	r1, r3, r0, lsl #10
    59e0:	002d0000 	eoreq	r0, sp, r0
    59e4:	0006280c 	andeq	r2, r6, ip, lsl #16
    59e8:	00064800 	andeq	r4, r6, r0, lsl #16
    59ec:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    59f0:	0000063d 	andeq	r0, r0, sp, lsr r6
    59f4:	0022a60f 	eoreq	sl, r2, pc, lsl #12
    59f8:	015c0600 	cmpeq	ip, r0, lsl #12
    59fc:	00064803 	andeq	r4, r6, r3, lsl #16
    5a00:	25160f00 	ldrcs	r0, [r6, #-3840]	; 0xfffff100
    5a04:	5f060000 	svcpl	0x00060000
    5a08:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    5a0c:	45160000 	ldrmi	r0, [r6, #-0]
    5a10:	07000029 	streq	r0, [r0, -r9, lsr #32]
    5a14:	0000a201 	andeq	sl, r0, r1, lsl #4
    5a18:	01720600 	cmneq	r2, r0, lsl #12
    5a1c:	00071d06 	andeq	r1, r7, r6, lsl #26
    5a20:	25f10b00 	ldrbcs	r0, [r1, #2816]!	; 0xb00
    5a24:	0b000000 	bleq	5a2c <shift+0x5a2c>
    5a28:	00001c61 	andeq	r1, r0, r1, ror #24
    5a2c:	1c6d0b02 			; <UNDEFINED> instruction: 0x1c6d0b02
    5a30:	0b030000 	bleq	c5a38 <__bss_end+0xb9b30>
    5a34:	00002049 	andeq	r2, r0, r9, asr #32
    5a38:	262d0b03 	strtcs	r0, [sp], -r3, lsl #22
    5a3c:	0b040000 	bleq	105a44 <__bss_end+0xf9b3c>
    5a40:	000021b0 			; <UNDEFINED> instruction: 0x000021b0
    5a44:	1c8b0b04 	vstmiane	fp, {d0-d1}
    5a48:	0b050000 	bleq	145a50 <__bss_end+0x139b48>
    5a4c:	0000227d 	andeq	r2, r0, sp, ror r2
    5a50:	22b70b05 	adcscs	r0, r7, #5120	; 0x1400
    5a54:	0b050000 	bleq	145a5c <__bss_end+0x139b54>
    5a58:	000021e1 	andeq	r2, r0, r1, ror #3
    5a5c:	1d4e0b05 	vstrne	d16, [lr, #-20]	; 0xffffffec
    5a60:	0b050000 	bleq	145a68 <__bss_end+0x139b60>
    5a64:	00001c97 	muleq	r0, r7, ip
    5a68:	24260b06 	strtcs	r0, [r6], #-2822	; 0xfffff4fa
    5a6c:	0b060000 	bleq	185a74 <__bss_end+0x179b6c>
    5a70:	00001ea1 	andeq	r1, r0, r1, lsr #29
    5a74:	273b0b06 	ldrcs	r0, [fp, -r6, lsl #22]!
    5a78:	0b060000 	bleq	185a80 <__bss_end+0x179b78>
    5a7c:	000029d5 	ldrdeq	r2, [r0], -r5
    5a80:	245a0b06 	ldrbcs	r0, [sl], #-2822	; 0xfffff4fa
    5a84:	0b060000 	bleq	185a8c <__bss_end+0x179b84>
    5a88:	000024b9 			; <UNDEFINED> instruction: 0x000024b9
    5a8c:	1ca30b06 	vstmiane	r3!, {d0-d2}
    5a90:	0b070000 	bleq	1c5a98 <__bss_end+0x1b9b90>
    5a94:	000025d4 	ldrdeq	r2, [r0], -r4
    5a98:	26390b07 	ldrtcs	r0, [r9], -r7, lsl #22
    5a9c:	0b070000 	bleq	1c5aa4 <__bss_end+0x1b9b9c>
    5aa0:	00002a1f 	andeq	r2, r0, pc, lsl sl
    5aa4:	1e740b07 	vaddne.f64	d16, d4, d7
    5aa8:	0b070000 	bleq	1c5ab0 <__bss_end+0x1b9ba8>
    5aac:	000026b4 			; <UNDEFINED> instruction: 0x000026b4
    5ab0:	1c040b08 			; <UNDEFINED> instruction: 0x1c040b08
    5ab4:	0b080000 	bleq	205abc <__bss_end+0x1f9bb4>
    5ab8:	000029e3 	andeq	r2, r0, r3, ror #19
    5abc:	26d50b08 	ldrbcs	r0, [r5], r8, lsl #22
    5ac0:	00080000 	andeq	r0, r8, r0
    5ac4:	002d6e0f 	eoreq	r6, sp, pc, lsl #28
    5ac8:	01920600 	orrseq	r0, r2, r0, lsl #12
    5acc:	0006671f 	andeq	r6, r6, pc, lsl r7
    5ad0:	217d0f00 	cmncs	sp, r0, lsl #30
    5ad4:	95060000 	strls	r0, [r6, #-0]
    5ad8:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    5adc:	070f0000 	streq	r0, [pc, -r0]
    5ae0:	06000027 	streq	r0, [r0], -r7, lsr #32
    5ae4:	2c0c0198 	stfcss	f0, [ip], {152}	; 0x98
    5ae8:	0f000000 	svceq	0x00000000
    5aec:	000022c4 	andeq	r2, r0, r4, asr #5
    5af0:	0c019b06 			; <UNDEFINED> instruction: 0x0c019b06
    5af4:	0000002c 	andeq	r0, r0, ip, lsr #32
    5af8:	0027110f 	eoreq	r1, r7, pc, lsl #2
    5afc:	019e0600 	orrseq	r0, lr, r0, lsl #12
    5b00:	00002c0c 	andeq	r2, r0, ip, lsl #24
    5b04:	24070f00 	strcs	r0, [r7], #-3840	; 0xfffff100
    5b08:	a1060000 	mrsge	r0, (UNDEF: 6)
    5b0c:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    5b10:	5b0f0000 	blpl	3c5b18 <__bss_end+0x3b9c10>
    5b14:	06000027 	streq	r0, [r0], -r7, lsr #32
    5b18:	2c0c01a4 	stfcss	f0, [ip], {164}	; 0xa4
    5b1c:	0f000000 	svceq	0x00000000
    5b20:	00002617 	andeq	r2, r0, r7, lsl r6
    5b24:	0c01a706 	stceq	7, cr10, [r1], {6}
    5b28:	0000002c 	andeq	r0, r0, ip, lsr #32
    5b2c:	0026220f 	eoreq	r2, r6, pc, lsl #4
    5b30:	01aa0600 			; <UNDEFINED> instruction: 0x01aa0600
    5b34:	00002c0c 	andeq	r2, r0, ip, lsl #24
    5b38:	271b0f00 	ldrcs	r0, [fp, -r0, lsl #30]
    5b3c:	ad060000 	stcge	0, cr0, [r6, #-0]
    5b40:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    5b44:	f90f0000 			; <UNDEFINED> instruction: 0xf90f0000
    5b48:	06000023 	streq	r0, [r0], -r3, lsr #32
    5b4c:	2c0c01b0 	stfcss	f0, [ip], {176}	; 0xb0
    5b50:	0f000000 	svceq	0x00000000
    5b54:	00002db0 			; <UNDEFINED> instruction: 0x00002db0
    5b58:	0c01b306 	stceq	3, cr11, [r1], {6}
    5b5c:	0000002c 	andeq	r0, r0, ip, lsr #32
    5b60:	0027250f 	eoreq	r2, r7, pc, lsl #10
    5b64:	01b60600 			; <UNDEFINED> instruction: 0x01b60600
    5b68:	00002c0c 	andeq	r2, r0, ip, lsl #24
    5b6c:	2e8d0f00 	cdpcs	15, 8, cr0, cr13, cr0, {0}
    5b70:	b9060000 	stmdblt	r6, {}	; <UNPREDICTABLE>
    5b74:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    5b78:	3b0f0000 	blcc	3c5b80 <__bss_end+0x3b9c78>
    5b7c:	0600002d 	streq	r0, [r0], -sp, lsr #32
    5b80:	2c0c01bc 	stfcss	f0, [ip], {188}	; 0xbc
    5b84:	0f000000 	svceq	0x00000000
    5b88:	00002d60 	andeq	r2, r0, r0, ror #26
    5b8c:	0c01c006 	stceq	0, cr12, [r1], {6}
    5b90:	0000002c 	andeq	r0, r0, ip, lsr #32
    5b94:	002e800f 	eoreq	r8, lr, pc
    5b98:	01c30600 	biceq	r0, r3, r0, lsl #12
    5b9c:	00002c0c 	andeq	r2, r0, ip, lsl #24
    5ba0:	1dbe0f00 	ldcne	15, cr0, [lr]
    5ba4:	c6060000 	strgt	r0, [r6], -r0
    5ba8:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    5bac:	950f0000 	strls	r0, [pc, #-0]	; 5bb4 <shift+0x5bb4>
    5bb0:	0600001b 			; <UNDEFINED> instruction: 0x0600001b
    5bb4:	2c0c01c9 	stfcss	f0, [ip], {201}	; 0xc9
    5bb8:	0f000000 	svceq	0x00000000
    5bbc:	00002069 	andeq	r2, r0, r9, rrx
    5bc0:	0c01cc06 	stceq	12, cr12, [r1], {6}
    5bc4:	0000002c 	andeq	r0, r0, ip, lsr #32
    5bc8:	001d990f 	andseq	r9, sp, pc, lsl #18
    5bcc:	01cf0600 	biceq	r0, pc, r0, lsl #12
    5bd0:	00002c0c 	andeq	r2, r0, ip, lsl #24
    5bd4:	27650f00 	strbcs	r0, [r5, -r0, lsl #30]!
    5bd8:	d2060000 	andle	r0, r6, #0
    5bdc:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    5be0:	ec0f0000 	stc	0, cr0, [pc], {-0}
    5be4:	06000022 	streq	r0, [r0], -r2, lsr #32
    5be8:	2c0c01d5 	stfcss	f0, [ip], {213}	; 0xd5
    5bec:	0f000000 	svceq	0x00000000
    5bf0:	00002584 	andeq	r2, r0, r4, lsl #11
    5bf4:	0c01d806 	stceq	8, cr13, [r1], {6}
    5bf8:	0000002c 	andeq	r0, r0, ip, lsr #32
    5bfc:	002b6b0f 	eoreq	r6, fp, pc, lsl #22
    5c00:	01df0600 	bicseq	r0, pc, r0, lsl #12
    5c04:	00002c0c 	andeq	r2, r0, ip, lsl #24
    5c08:	2e1f0f00 	cdpcs	15, 1, cr0, cr15, cr0, {0}
    5c0c:	e2060000 	and	r0, r6, #0
    5c10:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    5c14:	2f0f0000 	svccs	0x000f0000
    5c18:	0600002e 	streq	r0, [r0], -lr, lsr #32
    5c1c:	2c0c01e5 	stfcss	f0, [ip], {229}	; 0xe5
    5c20:	0f000000 	svceq	0x00000000
    5c24:	00001eb8 			; <UNDEFINED> instruction: 0x00001eb8
    5c28:	0c01e806 	stceq	8, cr14, [r1], {6}
    5c2c:	0000002c 	andeq	r0, r0, ip, lsr #32
    5c30:	002bb20f 	eoreq	fp, fp, pc, lsl #4
    5c34:	01eb0600 	mvneq	r0, r0, lsl #12
    5c38:	00002c0c 	andeq	r2, r0, ip, lsl #24
    5c3c:	269c0f00 	ldrcs	r0, [ip], r0, lsl #30
    5c40:	ee060000 	cdp	0, 0, cr0, cr6, cr0, {0}
    5c44:	002c0c01 	eoreq	r0, ip, r1, lsl #24
    5c48:	e20f0000 	and	r0, pc, #0
    5c4c:	06000020 	streq	r0, [r0], -r0, lsr #32
    5c50:	2c0c01f2 	stfcss	f0, [ip], {242}	; 0xf2
    5c54:	0f000000 	svceq	0x00000000
    5c58:	00002957 	andeq	r2, r0, r7, asr r9
    5c5c:	0c01fa06 			; <UNDEFINED> instruction: 0x0c01fa06
    5c60:	0000002c 	andeq	r0, r0, ip, lsr #32
    5c64:	001f9b0f 	andseq	r9, pc, pc, lsl #22
    5c68:	01fd0600 	mvnseq	r0, r0, lsl #12
    5c6c:	00002c0c 	andeq	r2, r0, ip, lsl #24
    5c70:	002c0c00 	eoreq	r0, ip, r0, lsl #24
    5c74:	08d50000 	ldmeq	r5, {}^	; <UNPREDICTABLE>
    5c78:	000d0000 	andeq	r0, sp, r0
    5c7c:	0021cc0f 	eoreq	ip, r1, pc, lsl #24
    5c80:	03eb0600 	mvneq	r0, #0, 12
    5c84:	0008ca0c 	andeq	ip, r8, ip, lsl #20
    5c88:	05cd0c00 	strbeq	r0, [sp, #3072]	; 0xc00
    5c8c:	08f20000 	ldmeq	r2!, {}^	; <UNPREDICTABLE>
    5c90:	33150000 	tstcc	r5, #0
    5c94:	0d000000 	stceq	0, cr0, [r0, #-0]
    5c98:	279b0f00 	ldrcs	r0, [fp, r0, lsl #30]
    5c9c:	74060000 	strvc	r0, [r6], #-0
    5ca0:	08e21405 	stmiaeq	r2!, {r0, r2, sl, ip}^
    5ca4:	af160000 	svcge	0x00160000
    5ca8:	07000022 	streq	r0, [r0, -r2, lsr #32]
    5cac:	0000a201 	andeq	sl, r0, r1, lsl #4
    5cb0:	057b0600 	ldrbeq	r0, [fp, #-1536]!	; 0xfffffa00
    5cb4:	00093d06 	andeq	r3, r9, r6, lsl #26
    5cb8:	202b0b00 	eorcs	r0, fp, r0, lsl #22
    5cbc:	0b000000 	bleq	5cc4 <shift+0x5cc4>
    5cc0:	000024e4 	andeq	r2, r0, r4, ror #9
    5cc4:	1c3a0b01 			; <UNDEFINED> instruction: 0x1c3a0b01
    5cc8:	0b020000 	bleq	85cd0 <__bss_end+0x79dc8>
    5ccc:	00002de1 	andeq	r2, r0, r1, ror #27
    5cd0:	28270b03 	stmdacs	r7!, {r0, r1, r8, r9, fp}
    5cd4:	0b040000 	bleq	105cdc <__bss_end+0xf9dd4>
    5cd8:	0000281a 	andeq	r2, r0, sl, lsl r8
    5cdc:	1d2d0b05 	fstmdbxne	sp!, {d0-d1}	;@ Deprecated
    5ce0:	00060000 	andeq	r0, r6, r0
    5ce4:	002dd10f 	eoreq	sp, sp, pc, lsl #2
    5ce8:	05880600 	streq	r0, [r8, #1536]	; 0x600
    5cec:	0008ff15 	andeq	pc, r8, r5, lsl pc	; <UNPREDICTABLE>
    5cf0:	2cad0f00 	stccs	15, cr0, [sp]
    5cf4:	89060000 	stmdbhi	r6, {}	; <UNPREDICTABLE>
    5cf8:	00331107 	eorseq	r1, r3, r7, lsl #2
    5cfc:	880f0000 	stmdahi	pc, {}	; <UNPREDICTABLE>
    5d00:	06000027 	streq	r0, [r0], -r7, lsr #32
    5d04:	2c0c079e 	stccs	7, cr0, [ip], {158}	; 0x9e
    5d08:	04000000 	streq	r0, [r0], #-0
    5d0c:	00002b5a 	andeq	r2, r0, sl, asr fp
    5d10:	a2167b07 	andsge	r7, r6, #7168	; 0x1c00
    5d14:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    5d18:	00000964 	andeq	r0, r0, r4, ror #18
    5d1c:	e7050202 	str	r0, [r5, -r2, lsl #4]
    5d20:	0400000d 	streq	r0, [r0], #-13
    5d24:	00002ecd 	andeq	r2, r0, sp, asr #29
    5d28:	33168107 	tstcc	r6, #-1073741823	; 0xc0000001
    5d2c:	04000000 	streq	r0, [r0], #-0
    5d30:	00002ec5 	andeq	r2, r0, r5, asr #29
    5d34:	25168507 	ldrcs	r8, [r6, #-1287]	; 0xfffffaf9
    5d38:	02000000 	andeq	r0, r0, #0
    5d3c:	1dd90404 	cfldrdne	mvd0, [r9, #16]
    5d40:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    5d44:	001dd103 	andseq	sp, sp, r3, lsl #2
    5d48:	04080200 	streq	r0, [r8], #-512	; 0xfffffe00
    5d4c:	00002734 	andeq	r2, r0, r4, lsr r7
    5d50:	6f031002 	svcvs	0x00031002
    5d54:	0c000028 	stceq	0, cr0, [r0], {40}	; 0x28
    5d58:	00000970 	andeq	r0, r0, r0, ror r9
    5d5c:	000009c0 	andeq	r0, r0, r0, asr #19
    5d60:	00003315 	andeq	r3, r0, r5, lsl r3
    5d64:	0e00ff00 	cdpeq	15, 0, cr15, cr0, cr0, {0}
    5d68:	000009b0 			; <UNDEFINED> instruction: 0x000009b0
    5d6c:	0026460f 	eoreq	r4, r6, pc, lsl #12
    5d70:	01fc0700 	mvnseq	r0, r0, lsl #14
    5d74:	0009c016 	andeq	ip, r9, r6, lsl r0
    5d78:	1d880f00 	stcne	15, cr0, [r8]
    5d7c:	02070000 	andeq	r0, r7, #0
    5d80:	09c01602 	stmibeq	r0, {r1, r9, sl, ip}^
    5d84:	dc170000 	ldcle	0, cr0, [r7], {-0}
    5d88:	0100002e 	tsteq	r0, lr, lsr #32
    5d8c:	880103b3 	stmdahi	r1, {r0, r1, r4, r5, r7, r8, r9}
    5d90:	e0000009 	and	r0, r0, r9
    5d94:	280000b9 	stmdacs	r0, {r0, r3, r4, r5, r7}
    5d98:	01000001 	tsteq	r0, r1
    5d9c:	000ab19c 	muleq	sl, ip, r1
    5da0:	006e1800 	rsbeq	r1, lr, r0, lsl #16
    5da4:	1703b301 	strne	fp, [r3, -r1, lsl #6]
    5da8:	00000988 	andeq	r0, r0, r8, lsl #19
    5dac:	00000157 	andeq	r0, r0, r7, asr r1
    5db0:	00000153 	andeq	r0, r0, r3, asr r1
    5db4:	01006418 	tsteq	r0, r8, lsl r4
    5db8:	882203b3 	stmdahi	r2!, {r0, r1, r4, r5, r7, r8, r9}
    5dbc:	83000009 	movwhi	r0, #9
    5dc0:	7f000001 	svcvc	0x00000001
    5dc4:	19000001 	stmdbne	r0, {r0}
    5dc8:	01007072 	tsteq	r0, r2, ror r0
    5dcc:	b12e03b3 			; <UNDEFINED> instruction: 0xb12e03b3
    5dd0:	0200000a 	andeq	r0, r0, #10
    5dd4:	711a0091 			; <UNDEFINED> instruction: 0x711a0091
    5dd8:	03b50100 			; <UNDEFINED> instruction: 0x03b50100
    5ddc:	0009880b 	andeq	r8, r9, fp, lsl #16
    5de0:	0001b300 	andeq	fp, r1, r0, lsl #6
    5de4:	0001ab00 	andeq	sl, r1, r0, lsl #22
    5de8:	00721a00 	rsbseq	r1, r2, r0, lsl #20
    5dec:	1203b501 	andne	fp, r3, #4194304	; 0x400000
    5df0:	00000988 	andeq	r0, r0, r8, lsl #19
    5df4:	00000209 	andeq	r0, r0, r9, lsl #4
    5df8:	000001ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    5dfc:	0100791a 	tsteq	r0, sl, lsl r9
    5e00:	881903b5 	ldmdahi	r9, {r0, r2, r4, r5, r7, r8, r9}
    5e04:	67000009 	strvs	r0, [r0, -r9]
    5e08:	61000002 	tstvs	r0, r2
    5e0c:	1b000002 	blne	5e1c <shift+0x5e1c>
    5e10:	00317a6c 	eorseq	r7, r1, ip, ror #20
    5e14:	0a03b601 	beq	f3620 <__bss_end+0xe7718>
    5e18:	0000097c 	andeq	r0, r0, ip, ror r9
    5e1c:	327a6c1a 	rsbscc	r6, sl, #6656	; 0x1a00
    5e20:	03b60100 			; <UNDEFINED> instruction: 0x03b60100
    5e24:	00097c0f 	andeq	r7, r9, pc, lsl #24
    5e28:	0002a100 	andeq	sl, r2, r0, lsl #2
    5e2c:	00029f00 	andeq	r9, r2, r0, lsl #30
    5e30:	00691a00 	rsbeq	r1, r9, r0, lsl #20
    5e34:	1403b601 	strne	fp, [r3], #-1537	; 0xfffff9ff
    5e38:	0000097c 	andeq	r0, r0, ip, ror r9
    5e3c:	000002c0 	andeq	r0, r0, r0, asr #5
    5e40:	000002b4 			; <UNDEFINED> instruction: 0x000002b4
    5e44:	01006b1a 	tsteq	r0, sl, lsl fp
    5e48:	7c1703b6 	ldcvc	3, cr0, [r7], {182}	; 0xb6
    5e4c:	12000009 	andne	r0, r0, #9
    5e50:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    5e54:	00000003 	andeq	r0, r0, r3
    5e58:	09880405 	stmibeq	r8, {r0, r2, sl}
    5e5c:	Address 0x0000000000005e5c is out of bounds.


Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
       0:	10001101 	andne	r1, r0, r1, lsl #2
       4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
       8:	1b0e0301 	blne	380c14 <__bss_end+0x374d0c>
       c:	130e250e 	movwne	r2, #58638	; 0xe50e
      10:	00000005 	andeq	r0, r0, r5
      14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
      18:	030b130e 	movweq	r1, #45838	; 0xb30e
      1c:	110e1b0e 	tstne	lr, lr, lsl #22
      20:	10061201 	andne	r1, r6, r1, lsl #4
      24:	02000017 	andeq	r0, r0, #23
      28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
      2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb6e14>
      30:	13490b39 	movtne	r0, #39737	; 0x9b39
      34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
      38:	24030000 	strcs	r0, [r3], #-0
      3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
      40:	000e030b 	andeq	r0, lr, fp, lsl #6
      44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
      48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
      4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb6e34>
      50:	01110b39 	tsteq	r1, r9, lsr fp
      54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
      58:	01194296 			; <UNDEFINED> instruction: 0x01194296
      5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
      60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
      64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb6e4c>
      68:	13490b39 	movtne	r0, #39737	; 0x9b39
      6c:	00001802 	andeq	r1, r0, r2, lsl #16
      70:	0b002406 	bleq	9090 <_Z7programj+0xa30>
      74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
      78:	07000008 	streq	r0, [r0, -r8]
      7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
      80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7798c>
      84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe36e70>
      88:	06120111 			; <UNDEFINED> instruction: 0x06120111
      8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
      90:	00130119 	andseq	r0, r3, r9, lsl r1
      94:	010b0800 	tsteq	fp, r0, lsl #16
      98:	06120111 			; <UNDEFINED> instruction: 0x06120111
      9c:	34090000 	strcc	r0, [r9], #-0
      a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f4da0>
      a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
      a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
      ac:	0a000018 	beq	114 <shift+0x114>
      b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b41ec>
      b4:	00001349 	andeq	r1, r0, r9, asr #6
      b8:	01110100 	tsteq	r1, r0, lsl #2
      bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b7a50>
      c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
      c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
      c8:	00001710 	andeq	r1, r0, r0, lsl r7
      cc:	03001602 	movweq	r1, #1538	; 0x602
      d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c2a08>
      d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
      d8:	03000013 	movweq	r0, #19
      dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b4218>
      e0:	00001349 	andeq	r1, r0, r9, asr #6
      e4:	00001504 	andeq	r1, r0, r4, lsl #10
      e8:	01010500 	tsteq	r1, r0, lsl #10
      ec:	13011349 	movwne	r1, #4937	; 0x1349
      f0:	21060000 	mrscs	r0, (UNDEF: 6)
      f4:	2f134900 	svccs	0x00134900
      f8:	07000006 	streq	r0, [r0, -r6]
      fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b428c>
     100:	0e030b3e 	vmoveq.16	d3[0], r0
     104:	34080000 	strcc	r0, [r8], #-0
     108:	3a0e0300 	bcc	380d10 <__bss_end+0x374e08>
     10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     110:	3f13490b 	svccc	0x0013490b
     114:	00193c19 	andseq	r3, r9, r9, lsl ip
     118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
     11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb6f08>
     124:	13490b39 	movtne	r0, #39737	; 0x9b39
     128:	06120111 			; <UNDEFINED> instruction: 0x06120111
     12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     130:	00130119 	andseq	r0, r3, r9, lsl r1
     134:	00340a00 	eorseq	r0, r4, r0, lsl #20
     138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe77a44>
     13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe36f28>
     140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     144:	240b0000 	strcs	r0, [fp], #-0
     148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     14c:	0008030b 	andeq	r0, r8, fp, lsl #6
     150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
     154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb6f40>
     15c:	01110b39 	tsteq	r1, r9, lsr fp
     160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     164:	00194297 	mulseq	r9, r7, r2
     168:	01390d00 	teqeq	r9, r0, lsl #26
     16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe77a78>
     170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
     174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
     178:	03193f01 	tsteq	r9, #1, 30
     17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c2ab4>
     180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
     184:	00130119 	andseq	r0, r3, r9, lsl r1
     188:	00050f00 	andeq	r0, r5, r0, lsl #30
     18c:	00001349 	andeq	r1, r0, r9, asr #6
     190:	3f012e10 	svccc	0x00012e10
     194:	3a0e0319 	bcc	380e00 <__bss_end+0x374ef8>
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
     1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f4ec0>
     1c4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     1c8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     1cc:	14000018 	strne	r0, [r0], #-24	; 0xffffffe8
     1d0:	1347012e 	movtne	r0, #28974	; 0x712e
     1d4:	06120111 			; <UNDEFINED> instruction: 0x06120111
     1d8:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     1dc:	00000019 	andeq	r0, r0, r9, lsl r0
     1e0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
     1e4:	030b130e 	movweq	r1, #45838	; 0xb30e
     1e8:	550e1b0e 	strpl	r1, [lr, #-2830]	; 0xfffff4f2
     1ec:	10011117 	andne	r1, r1, r7, lsl r1
     1f0:	02000017 	andeq	r0, r0, #23
     1f4:	0b0b0024 	bleq	2c028c <__bss_end+0x2b4384>
     1f8:	0e030b3e 	vmoveq.16	d3[0], r0
     1fc:	26030000 	strcs	r0, [r3], -r0
     200:	00134900 	andseq	r4, r3, r0, lsl #18
     204:	00240400 	eoreq	r0, r4, r0, lsl #8
     208:	0b3e0b0b 	bleq	f82e3c <__bss_end+0xf76f34>
     20c:	00000803 	andeq	r0, r0, r3, lsl #16
     210:	03001605 	movweq	r1, #1541	; 0x605
     214:	3b0b3a0e 	blcc	2cea54 <__bss_end+0x2c2b4c>
     218:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     21c:	06000013 			; <UNDEFINED> instruction: 0x06000013
     220:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
     224:	0b3a0b0b 	bleq	e82e58 <__bss_end+0xe76f50>
     228:	0b390b3b 	bleq	e42f1c <__bss_end+0xe37014>
     22c:	00001301 	andeq	r1, r0, r1, lsl #6
     230:	03000d07 	movweq	r0, #3335	; 0xd07
     234:	3b0b3a08 	blcc	2cea5c <__bss_end+0x2c2b54>
     238:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     23c:	000b3813 	andeq	r3, fp, r3, lsl r8
     240:	01040800 	tsteq	r4, r0, lsl #16
     244:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
     248:	0b0b0b3e 	bleq	2c2f48 <__bss_end+0x2b7040>
     24c:	0b3a1349 	bleq	e84f78 <__bss_end+0xe79070>
     250:	0b390b3b 	bleq	e42f44 <__bss_end+0xe3703c>
     254:	00001301 	andeq	r1, r0, r1, lsl #6
     258:	03002809 	movweq	r2, #2057	; 0x809
     25c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
     260:	00340a00 	eorseq	r0, r4, r0, lsl #20
     264:	0b3a0e03 	bleq	e83a78 <__bss_end+0xe77b70>
     268:	0b390b3b 	bleq	e42f5c <__bss_end+0xe37054>
     26c:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
     270:	00001802 	andeq	r1, r0, r2, lsl #16
     274:	0300020b 	movweq	r0, #523	; 0x20b
     278:	00193c0e 	andseq	r3, r9, lr, lsl #24
     27c:	01020c00 	tsteq	r2, r0, lsl #24
     280:	0b0b0e03 	bleq	2c3a94 <__bss_end+0x2b7b8c>
     284:	0b3b0b3a 	bleq	ec2f74 <__bss_end+0xeb706c>
     288:	13010b39 	movwne	r0, #6969	; 0x1b39
     28c:	0d0d0000 	stceq	0, cr0, [sp, #-0]
     290:	3a0e0300 	bcc	380e98 <__bss_end+0x374f90>
     294:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     298:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     29c:	0e00000b 	cdpeq	0, 0, cr0, cr0, cr11, {0}
     2a0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     2a4:	0b3a0e03 	bleq	e83ab8 <__bss_end+0xe77bb0>
     2a8:	0b390b3b 	bleq	e42f9c <__bss_end+0xe37094>
     2ac:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     2b0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     2b4:	050f0000 	streq	r0, [pc, #-0]	; 2bc <shift+0x2bc>
     2b8:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
     2bc:	10000019 	andne	r0, r0, r9, lsl r0
     2c0:	13490005 	movtne	r0, #36869	; 0x9005
     2c4:	0d110000 	ldceq	0, cr0, [r1, #-0]
     2c8:	3a0e0300 	bcc	380ed0 <__bss_end+0x374fc8>
     2cc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     2d0:	3f13490b 	svccc	0x0013490b
     2d4:	00193c19 	andseq	r3, r9, r9, lsl ip
     2d8:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
     2dc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     2e0:	0b3b0b3a 	bleq	ec2fd0 <__bss_end+0xeb70c8>
     2e4:	0e6e0b39 	vmoveq.8	d14[5], r0
     2e8:	0b321349 	bleq	c85014 <__bss_end+0xc7910c>
     2ec:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     2f0:	00001301 	andeq	r1, r0, r1, lsl #6
     2f4:	3f012e13 	svccc	0x00012e13
     2f8:	3a0e0319 	bcc	380f64 <__bss_end+0x37505c>
     2fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     300:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
     304:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     308:	00130113 	andseq	r0, r3, r3, lsl r1
     30c:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
     310:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     314:	0b3b0b3a 	bleq	ec3004 <__bss_end+0xeb70fc>
     318:	0e6e0b39 	vmoveq.8	d14[5], r0
     31c:	0b321349 	bleq	c85048 <__bss_end+0xc79140>
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
     348:	3a0e0300 	bcc	380f50 <__bss_end+0x375048>
     34c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     350:	3f13490b 	svccc	0x0013490b
     354:	00193c19 	andseq	r3, r9, r9, lsl ip
     358:	00281a00 	eoreq	r1, r8, r0, lsl #20
     35c:	0b1c0803 	bleq	702370 <__bss_end+0x6f6468>
     360:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
     364:	03193f01 	tsteq	r9, #1, 30
     368:	3b0b3a0e 	blcc	2ceba8 <__bss_end+0x2c2ca0>
     36c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     370:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
     374:	00130113 	andseq	r0, r3, r3, lsl r1
     378:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
     37c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     380:	0b3b0b3a 	bleq	ec3070 <__bss_end+0xeb7168>
     384:	0e6e0b39 	vmoveq.8	d14[5], r0
     388:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     38c:	13011364 	movwne	r1, #4964	; 0x1364
     390:	0d1d0000 	ldceq	0, cr0, [sp, #-0]
     394:	3a0e0300 	bcc	380f9c <__bss_end+0x375094>
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
     3c8:	01392200 	teqeq	r9, r0, lsl #4
     3cc:	0b3a0e03 	bleq	e83be0 <__bss_end+0xe77cd8>
     3d0:	0b390b3b 	bleq	e430c4 <__bss_end+0xe371bc>
     3d4:	00001301 	andeq	r1, r0, r1, lsl #6
     3d8:	03003423 	movweq	r3, #1059	; 0x423
     3dc:	3b0b3a0e 	blcc	2cec1c <__bss_end+0x2c2d14>
     3e0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     3e4:	1c193c13 	ldcne	12, cr3, [r9], {19}
     3e8:	24000005 	strcs	r0, [r0], #-5
     3ec:	13470034 	movtne	r0, #28724	; 0x7034
     3f0:	02250000 	eoreq	r0, r5, #0
     3f4:	0b0e0301 	bleq	381000 <__bss_end+0x3750f8>
     3f8:	3b0b3a05 	blcc	2cec14 <__bss_end+0x2c2d0c>
     3fc:	010b390b 	tsteq	fp, fp, lsl #18
     400:	26000013 			; <UNDEFINED> instruction: 0x26000013
     404:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     408:	0b3b0b3a 	bleq	ec30f8 <__bss_end+0xeb71f0>
     40c:	13490b39 	movtne	r0, #39737	; 0x9b39
     410:	00000538 	andeq	r0, r0, r8, lsr r5
     414:	03013927 	movweq	r3, #6439	; 0x1927
     418:	3b0b3a08 	blcc	2cec40 <__bss_end+0x2c2d38>
     41c:	010b390b 	tsteq	fp, fp, lsl #18
     420:	28000013 	stmdacs	r0, {r0, r1, r4}
     424:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     428:	0b3b0b3a 	bleq	ec3118 <__bss_end+0xeb7210>
     42c:	13490b39 	movtne	r0, #39737	; 0x9b39
     430:	061c193c 			; <UNDEFINED> instruction: 0x061c193c
     434:	0000196c 	andeq	r1, r0, ip, ror #18
     438:	03003429 	movweq	r3, #1065	; 0x429
     43c:	3b0b3a0e 	blcc	2cec7c <__bss_end+0x2c2d74>
     440:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     444:	1c193c13 	ldcne	12, cr3, [r9], {19}
     448:	00196c0b 	andseq	r6, r9, fp, lsl #24
     44c:	00342a00 	eorseq	r2, r4, r0, lsl #20
     450:	0b3a0e03 	bleq	e83c64 <__bss_end+0xe77d5c>
     454:	0b390b3b 	bleq	e43148 <__bss_end+0xe37240>
     458:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     45c:	196c051c 	stmdbne	ip!, {r2, r3, r4, r8, sl}^
     460:	2e2b0000 	cdpcs	0, 2, cr0, cr11, cr0, {0}
     464:	03193f01 	tsteq	r9, #1, 30
     468:	3b0b3a0e 	blcc	2ceca8 <__bss_end+0x2c2da0>
     46c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     470:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     474:	00136419 	andseq	r6, r3, r9, lsl r4
     478:	00282c00 	eoreq	r2, r8, r0, lsl #24
     47c:	051c0e03 	ldreq	r0, [ip, #-3587]	; 0xfffff1fd
     480:	282d0000 	stmdacs	sp!, {}	; <UNPREDICTABLE>
     484:	1c0e0300 	stcne	3, cr0, [lr], {-0}
     488:	2e000006 	cdpcs	0, 0, cr0, cr0, cr6, {0}
     48c:	0b3a003a 	bleq	e8057c <__bss_end+0xe74674>
     490:	0b390b3b 	bleq	e43184 <__bss_end+0xe3727c>
     494:	00001318 	andeq	r1, r0, r8, lsl r3
     498:	3f012e2f 	svccc	0x00012e2f
     49c:	3a080319 	bcc	201108 <__bss_end+0x1f5200>
     4a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     4a4:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     4a8:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
     4ac:	00130113 	andseq	r0, r3, r3, lsl r1
     4b0:	012e3000 			; <UNDEFINED> instruction: 0x012e3000
     4b4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     4b8:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
     4bc:	0e6e0b39 	vmoveq.8	d14[5], r0
     4c0:	06120111 			; <UNDEFINED> instruction: 0x06120111
     4c4:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     4c8:	00130119 	andseq	r0, r3, r9, lsl r1
     4cc:	00053100 	andeq	r3, r5, r0, lsl #2
     4d0:	0b3a0803 	bleq	e824e4 <__bss_end+0xe765dc>
     4d4:	0b39053b 	bleq	e419c8 <__bss_end+0xe35ac0>
     4d8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     4dc:	05320000 	ldreq	r0, [r2, #-0]!
     4e0:	3a0e0300 	bcc	3810e8 <__bss_end+0x3751e0>
     4e4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
     4e8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     4ec:	33000018 	movwcc	r0, #24
     4f0:	0111010b 	tsteq	r1, fp, lsl #2
     4f4:	00000612 	andeq	r0, r0, r2, lsl r6
     4f8:	03003434 	movweq	r3, #1076	; 0x434
     4fc:	3b0b3a08 	blcc	2ced24 <__bss_end+0x2c2e1c>
     500:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
     504:	00180213 	andseq	r0, r8, r3, lsl r2
     508:	012e3500 			; <UNDEFINED> instruction: 0x012e3500
     50c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     510:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
     514:	0e6e0b39 	vmoveq.8	d14[5], r0
     518:	06120111 			; <UNDEFINED> instruction: 0x06120111
     51c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     520:	00130119 	andseq	r0, r3, r9, lsl r1
     524:	00343600 	eorseq	r3, r4, r0, lsl #12
     528:	0b3a0e03 	bleq	e83d3c <__bss_end+0xe77e34>
     52c:	0b39053b 	bleq	e41a20 <__bss_end+0xe35b18>
     530:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     534:	2e370000 	cdpcs	0, 3, cr0, cr7, cr0, {0}
     538:	03193f01 	tsteq	r9, #1, 30
     53c:	3b0b3a0e 	blcc	2ced7c <__bss_end+0x2c2e74>
     540:	6e0b3905 	vmlavs.f16	s6, s22, s10	; <UNPREDICTABLE>
     544:	1113490e 	tstne	r3, lr, lsl #18
     548:	40061201 	andmi	r1, r6, r1, lsl #4
     54c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     550:	00001301 	andeq	r1, r0, r1, lsl #6
     554:	3f012e38 	svccc	0x00012e38
     558:	3a0e0319 	bcc	3811c4 <__bss_end+0x3752bc>
     55c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
     560:	1113490b 	tstne	r3, fp, lsl #18
     564:	40061201 	andmi	r1, r6, r1, lsl #4
     568:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     56c:	00001301 	andeq	r1, r0, r1, lsl #6
     570:	3f012e39 	svccc	0x00012e39
     574:	3a0e0319 	bcc	3811e0 <__bss_end+0x3752d8>
     578:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     57c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     580:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     584:	96184006 	ldrls	r4, [r8], -r6
     588:	13011942 	movwne	r1, #6466	; 0x1942
     58c:	053a0000 	ldreq	r0, [sl, #-0]!
     590:	3a0e0300 	bcc	381198 <__bss_end+0x375290>
     594:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     598:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     59c:	3b000018 	blcc	604 <shift+0x604>
     5a0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     5a4:	0b3b0b3a 	bleq	ec3294 <__bss_end+0xeb738c>
     5a8:	13490b39 	movtne	r0, #39737	; 0x9b39
     5ac:	00001802 	andeq	r1, r0, r2, lsl #16
     5b0:	11010b3c 	tstne	r1, ip, lsr fp
     5b4:	01061201 	tsteq	r6, r1, lsl #4
     5b8:	3d000013 	stccc	0, cr0, [r0, #-76]	; 0xffffffb4
     5bc:	08030034 	stmdaeq	r3, {r2, r4, r5}
     5c0:	0b3b0b3a 	bleq	ec32b0 <__bss_end+0xeb73a8>
     5c4:	13490b39 	movtne	r0, #39737	; 0x9b39
     5c8:	00001802 	andeq	r1, r0, r2, lsl #16
     5cc:	3f012e3e 	svccc	0x00012e3e
     5d0:	3a0e0319 	bcc	38123c <__bss_end+0x375334>
     5d4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     5d8:	110e6e0b 	tstne	lr, fp, lsl #28
     5dc:	40061201 	andmi	r1, r6, r1, lsl #4
     5e0:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     5e4:	00001301 	andeq	r1, r0, r1, lsl #6
     5e8:	0300343f 	movweq	r3, #1087	; 0x43f
     5ec:	3b0b3a0e 	blcc	2cee2c <__bss_end+0x2c2f24>
     5f0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     5f4:	40000013 	andmi	r0, r0, r3, lsl r0
     5f8:	0e03012e 	adfeqsp	f0, f3, #0.5
     5fc:	0b3b0b3a 	bleq	ec32ec <__bss_end+0xeb73e4>
     600:	01110b39 	tsteq	r1, r9, lsr fp
     604:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     608:	01194296 			; <UNDEFINED> instruction: 0x01194296
     60c:	41000013 	tstmi	r0, r3, lsl r0
     610:	08030005 	stmdaeq	r3, {r0, r2}
     614:	0b3b0b3a 	bleq	ec3304 <__bss_end+0xeb73fc>
     618:	13490b39 	movtne	r0, #39737	; 0x9b39
     61c:	00001802 	andeq	r1, r0, r2, lsl #16
     620:	47012e42 	strmi	r2, [r1, -r2, asr #28]
     624:	11136413 	tstne	r3, r3, lsl r4
     628:	40061201 	andmi	r1, r6, r1, lsl #4
     62c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     630:	00001301 	andeq	r1, r0, r1, lsl #6
     634:	03000543 	movweq	r0, #1347	; 0x543
     638:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
     63c:	00180219 	andseq	r0, r8, r9, lsl r2
     640:	012e4400 			; <UNDEFINED> instruction: 0x012e4400
     644:	13641347 	cmnne	r4, #469762049	; 0x1c000001
     648:	06120111 			; <UNDEFINED> instruction: 0x06120111
     64c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
     650:	00130119 	andseq	r0, r3, r9, lsl r1
     654:	012e4500 			; <UNDEFINED> instruction: 0x012e4500
     658:	0803193f 	stmdaeq	r3, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
     65c:	0b3b0b3a 	bleq	ec334c <__bss_end+0xeb7444>
     660:	0e6e0b39 	vmoveq.8	d14[5], r0
     664:	01111349 	tsteq	r1, r9, asr #6
     668:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     66c:	01194297 			; <UNDEFINED> instruction: 0x01194297
     670:	46000013 			; <UNDEFINED> instruction: 0x46000013
     674:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     678:	0b3a0e03 	bleq	e83e8c <__bss_end+0xe77f84>
     67c:	0b390b3b 	bleq	e43370 <__bss_end+0xe37468>
     680:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     684:	06120111 			; <UNDEFINED> instruction: 0x06120111
     688:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
     68c:	00000019 	andeq	r0, r0, r9, lsl r0
     690:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
     694:	030b130e 	movweq	r1, #45838	; 0xb30e
     698:	110e1b0e 	tstne	lr, lr, lsl #22
     69c:	10061201 	andne	r1, r6, r1, lsl #4
     6a0:	02000017 	andeq	r0, r0, #23
     6a4:	0b0b0024 	bleq	2c073c <__bss_end+0x2b4834>
     6a8:	0e030b3e 	vmoveq.16	d3[0], r0
     6ac:	24030000 	strcs	r0, [r3], #-0
     6b0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     6b4:	0008030b 	andeq	r0, r8, fp, lsl #6
     6b8:	00260400 	eoreq	r0, r6, r0, lsl #8
     6bc:	00001349 	andeq	r1, r0, r9, asr #6
     6c0:	03013905 	movweq	r3, #6405	; 0x1905
     6c4:	3b0b3a0e 	blcc	2cef04 <__bss_end+0x2c2ffc>
     6c8:	010b390b 	tsteq	fp, fp, lsl #18
     6cc:	06000013 			; <UNDEFINED> instruction: 0x06000013
     6d0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     6d4:	0b3b0b3a 	bleq	ec33c4 <__bss_end+0xeb74bc>
     6d8:	13490b39 	movtne	r0, #39737	; 0x9b39
     6dc:	051c193c 	ldreq	r1, [ip, #-2364]	; 0xfffff6c4
     6e0:	34070000 	strcc	r0, [r7], #-0
     6e4:	00134700 	andseq	r4, r3, r0, lsl #14
     6e8:	01020800 	tsteq	r2, r0, lsl #16
     6ec:	050b0e03 	streq	r0, [fp, #-3587]	; 0xfffff1fd
     6f0:	0b3b0b3a 	bleq	ec33e0 <__bss_end+0xeb74d8>
     6f4:	13010b39 	movwne	r0, #6969	; 0x1b39
     6f8:	0d090000 	stceq	0, cr0, [r9, #-0]
     6fc:	3a0e0300 	bcc	381304 <__bss_end+0x3753fc>
     700:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     704:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     708:	0a00000b 	beq	73c <shift+0x73c>
     70c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     710:	0b3b0b3a 	bleq	ec3400 <__bss_end+0xeb74f8>
     714:	13490b39 	movtne	r0, #39737	; 0x9b39
     718:	00000538 	andeq	r0, r0, r8, lsr r5
     71c:	3f012e0b 	svccc	0x00012e0b
     720:	3a0e0319 	bcc	38138c <__bss_end+0x375484>
     724:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     728:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     72c:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     730:	01136419 	tsteq	r3, r9, lsl r4
     734:	0c000013 	stceq	0, cr0, [r0], {19}
     738:	13490005 	movtne	r0, #36869	; 0x9005
     73c:	00001934 	andeq	r1, r0, r4, lsr r9
     740:	3f012e0d 	svccc	0x00012e0d
     744:	3a0e0319 	bcc	3813b0 <__bss_end+0x3754a8>
     748:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     74c:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
     750:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     754:	00130113 	andseq	r0, r3, r3, lsl r1
     758:	00050e00 	andeq	r0, r5, r0, lsl #28
     75c:	00001349 	andeq	r1, r0, r9, asr #6
     760:	3f012e0f 	svccc	0x00012e0f
     764:	3a0e0319 	bcc	3813d0 <__bss_end+0x3754c8>
     768:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     76c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     770:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
     774:	00136419 	andseq	r6, r3, r9, lsl r4
     778:	01011000 	mrseq	r1, (UNDEF: 1)
     77c:	13011349 	movwne	r1, #4937	; 0x1349
     780:	21110000 	tstcs	r1, r0
     784:	2f134900 	svccs	0x00134900
     788:	1200000b 	andne	r0, r0, #11
     78c:	0b0b000f 	bleq	2c07d0 <__bss_end+0x2b48c8>
     790:	00001349 	andeq	r1, r0, r9, asr #6
     794:	03003413 	movweq	r3, #1043	; 0x413
     798:	3b0b3a0e 	blcc	2cefd8 <__bss_end+0x2c30d0>
     79c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     7a0:	3c193f13 	ldccc	15, cr3, [r9], {19}
     7a4:	14000019 	strne	r0, [r0], #-25	; 0xffffffe7
     7a8:	13470034 	movtne	r0, #28724	; 0x7034
     7ac:	0b3b0b3a 	bleq	ec349c <__bss_end+0xeb7594>
     7b0:	18020b39 	stmdane	r2, {r0, r3, r4, r5, r8, r9, fp}
     7b4:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
     7b8:	340e0300 	strcc	r0, [lr], #-768	; 0xfffffd00
     7bc:	12011119 	andne	r1, r1, #1073741830	; 0x40000006
     7c0:	96184006 	ldrls	r4, [r8], -r6
     7c4:	00001942 	andeq	r1, r0, r2, asr #18
     7c8:	03012e16 	movweq	r2, #7702	; 0x1e16
     7cc:	1119340e 	tstne	r9, lr, lsl #8
     7d0:	40061201 	andmi	r1, r6, r1, lsl #4
     7d4:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     7d8:	00001301 	andeq	r1, r0, r1, lsl #6
     7dc:	03000517 	movweq	r0, #1303	; 0x517
     7e0:	3b0b3a0e 	blcc	2cf020 <__bss_end+0x2c3118>
     7e4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     7e8:	00180213 	andseq	r0, r8, r3, lsl r2
     7ec:	012e1800 			; <UNDEFINED> instruction: 0x012e1800
     7f0:	0b3a1347 	bleq	e85514 <__bss_end+0xe7960c>
     7f4:	0b390b3b 	bleq	e434e8 <__bss_end+0xe375e0>
     7f8:	01111364 	tsteq	r1, r4, ror #6
     7fc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     800:	01194297 			; <UNDEFINED> instruction: 0x01194297
     804:	19000013 	stmdbne	r0, {r0, r1, r4}
     808:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     80c:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     810:	00001802 	andeq	r1, r0, r2, lsl #16
     814:	0300341a 	movweq	r3, #1050	; 0x41a
     818:	3b0b3a08 	blcc	2cf040 <__bss_end+0x2c3138>
     81c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     820:	00180213 	andseq	r0, r8, r3, lsl r2
     824:	00051b00 	andeq	r1, r5, r0, lsl #22
     828:	0b3a0803 	bleq	e8283c <__bss_end+0xe76934>
     82c:	0b390b3b 	bleq	e43520 <__bss_end+0xe37618>
     830:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     834:	2e1c0000 	cdpcs	0, 1, cr0, cr12, cr0, {0}
     838:	3a134701 	bcc	4d2444 <__bss_end+0x4c653c>
     83c:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     840:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     844:	97184006 	ldrls	r4, [r8, -r6]
     848:	13011942 	movwne	r1, #6466	; 0x1942
     84c:	0b1d0000 	bleq	740854 <__bss_end+0x73494c>
     850:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
     854:	1e000006 	cdpne	0, 0, cr0, cr0, cr6, {0}
     858:	1347012e 	movtne	r0, #28974	; 0x712e
     85c:	0b3b0b3a 	bleq	ec354c <__bss_end+0xeb7644>
     860:	13640b39 	cmnne	r4, #58368	; 0xe400
     864:	13010b20 	movwne	r0, #6944	; 0x1b20
     868:	051f0000 	ldreq	r0, [pc, #-0]	; 870 <shift+0x870>
     86c:	490e0300 	stmdbmi	lr, {r8, r9}
     870:	00193413 	andseq	r3, r9, r3, lsl r4
     874:	010b2000 	mrseq	r2, (UNDEF: 11)
     878:	34210000 	strtcc	r0, [r1], #-0
     87c:	3a080300 	bcc	201484 <__bss_end+0x1f557c>
     880:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     884:	0013490b 	andseq	r4, r3, fp, lsl #18
     888:	012e2200 			; <UNDEFINED> instruction: 0x012e2200
     88c:	0e6e1331 	mcreq	3, 3, r1, cr14, cr1, {1}
     890:	01111364 	tsteq	r1, r4, ror #6
     894:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     898:	00194297 	mulseq	r9, r7, r2
     89c:	00052300 	andeq	r2, r5, r0, lsl #6
     8a0:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
     8a4:	0b240000 	bleq	9008ac <__bss_end+0x8f49a4>
     8a8:	01133101 	tsteq	r3, r1, lsl #2
     8ac:	25000013 	strcs	r0, [r0, #-19]	; 0xffffffed
     8b0:	13310034 	teqne	r1, #52	; 0x34
     8b4:	0b260000 	bleq	9808bc <__bss_end+0x9749b4>
     8b8:	11133101 	tstne	r3, r1, lsl #2
     8bc:	00061201 	andeq	r1, r6, r1, lsl #4
     8c0:	00342700 	eorseq	r2, r4, r0, lsl #14
     8c4:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
     8c8:	01000000 	mrseq	r0, (UNDEF: 0)
     8cc:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
     8d0:	0e030b13 	vmoveq.32	d3[0], r0
     8d4:	01110e1b 	tsteq	r1, fp, lsl lr
     8d8:	17100612 			; <UNDEFINED> instruction: 0x17100612
     8dc:	24020000 	strcs	r0, [r2], #-0
     8e0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     8e4:	000e030b 	andeq	r0, lr, fp, lsl #6
     8e8:	00260300 	eoreq	r0, r6, r0, lsl #6
     8ec:	00001349 	andeq	r1, r0, r9, asr #6
     8f0:	0b002404 	bleq	9908 <_ZN6Buffer7ReleaseEv+0x44>
     8f4:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     8f8:	05000008 	streq	r0, [r0, #-8]
     8fc:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
     900:	0b3b0b3a 	bleq	ec35f0 <__bss_end+0xeb76e8>
     904:	13490b39 	movtne	r0, #39737	; 0x9b39
     908:	13060000 	movwne	r0, #24576	; 0x6000
     90c:	0b0e0301 	bleq	381518 <__bss_end+0x375610>
     910:	3b0b3a0b 	blcc	2cf144 <__bss_end+0x2c323c>
     914:	010b390b 	tsteq	fp, fp, lsl #18
     918:	07000013 	smladeq	r0, r3, r0, r0
     91c:	0803000d 	stmdaeq	r3, {r0, r2, r3}
     920:	0b3b0b3a 	bleq	ec3610 <__bss_end+0xeb7708>
     924:	13490b39 	movtne	r0, #39737	; 0x9b39
     928:	00000b38 	andeq	r0, r0, r8, lsr fp
     92c:	03010408 	movweq	r0, #5128	; 0x1408
     930:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
     934:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
     938:	3b0b3a13 	blcc	2cf18c <__bss_end+0x2c3284>
     93c:	010b390b 	tsteq	fp, fp, lsl #18
     940:	09000013 	stmdbeq	r0, {r0, r1, r4}
     944:	08030028 	stmdaeq	r3, {r3, r5}
     948:	00000b1c 	andeq	r0, r0, ip, lsl fp
     94c:	0300280a 	movweq	r2, #2058	; 0x80a
     950:	000b1c0e 	andeq	r1, fp, lr, lsl #24
     954:	00340b00 	eorseq	r0, r4, r0, lsl #22
     958:	0b3a0e03 	bleq	e8416c <__bss_end+0xe78264>
     95c:	0b390b3b 	bleq	e43650 <__bss_end+0xe37748>
     960:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
     964:	00001802 	andeq	r1, r0, r2, lsl #16
     968:	0300020c 	movweq	r0, #524	; 0x20c
     96c:	00193c0e 	andseq	r3, r9, lr, lsl #24
     970:	01020d00 	tsteq	r2, r0, lsl #26
     974:	0b0b0e03 	bleq	2c4188 <__bss_end+0x2b8280>
     978:	0b3b0b3a 	bleq	ec3668 <__bss_end+0xeb7760>
     97c:	13010b39 	movwne	r0, #6969	; 0x1b39
     980:	0d0e0000 	stceq	0, cr0, [lr, #-0]
     984:	3a0e0300 	bcc	38158c <__bss_end+0x375684>
     988:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     98c:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
     990:	0f00000b 	svceq	0x0000000b
     994:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     998:	0b3a0e03 	bleq	e841ac <__bss_end+0xe782a4>
     99c:	0b390b3b 	bleq	e43690 <__bss_end+0xe37788>
     9a0:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     9a4:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     9a8:	05100000 	ldreq	r0, [r0, #-0]
     9ac:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
     9b0:	11000019 	tstne	r0, r9, lsl r0
     9b4:	13490005 	movtne	r0, #36869	; 0x9005
     9b8:	0d120000 	ldceq	0, cr0, [r2, #-0]
     9bc:	3a0e0300 	bcc	3815c4 <__bss_end+0x3756bc>
     9c0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     9c4:	3f13490b 	svccc	0x0013490b
     9c8:	00193c19 	andseq	r3, r9, r9, lsl ip
     9cc:	012e1300 			; <UNDEFINED> instruction: 0x012e1300
     9d0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     9d4:	0b3b0b3a 	bleq	ec36c4 <__bss_end+0xeb77bc>
     9d8:	0e6e0b39 	vmoveq.8	d14[5], r0
     9dc:	0b321349 	bleq	c85708 <__bss_end+0xc79800>
     9e0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     9e4:	00001301 	andeq	r1, r0, r1, lsl #6
     9e8:	3f012e14 	svccc	0x00012e14
     9ec:	3a0e0319 	bcc	381658 <__bss_end+0x375750>
     9f0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     9f4:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
     9f8:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
     9fc:	00130113 	andseq	r0, r3, r3, lsl r1
     a00:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
     a04:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     a08:	0b3b0b3a 	bleq	ec36f8 <__bss_end+0xeb77f0>
     a0c:	0e6e0b39 	vmoveq.8	d14[5], r0
     a10:	0b321349 	bleq	c8573c <__bss_end+0xc79834>
     a14:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     a18:	01160000 	tsteq	r6, r0
     a1c:	01134901 	tsteq	r3, r1, lsl #18
     a20:	17000013 	smladne	r0, r3, r0, r0
     a24:	13490021 	movtne	r0, #36897	; 0x9021
     a28:	00000b2f 	andeq	r0, r0, pc, lsr #22
     a2c:	0b000f18 	bleq	4694 <shift+0x4694>
     a30:	0013490b 	andseq	r4, r3, fp, lsl #18
     a34:	00211900 	eoreq	r1, r1, r0, lsl #18
     a38:	341a0000 	ldrcc	r0, [sl], #-0
     a3c:	3a0e0300 	bcc	381644 <__bss_end+0x37573c>
     a40:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     a44:	3f13490b 	svccc	0x0013490b
     a48:	00193c19 	andseq	r3, r9, r9, lsl ip
     a4c:	012e1b00 			; <UNDEFINED> instruction: 0x012e1b00
     a50:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     a54:	0b3b0b3a 	bleq	ec3744 <__bss_end+0xeb783c>
     a58:	0e6e0b39 	vmoveq.8	d14[5], r0
     a5c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
     a60:	00001301 	andeq	r1, r0, r1, lsl #6
     a64:	3f012e1c 	svccc	0x00012e1c
     a68:	3a0e0319 	bcc	3816d4 <__bss_end+0x3757cc>
     a6c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     a70:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     a74:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
     a78:	00130113 	andseq	r0, r3, r3, lsl r1
     a7c:	000d1d00 	andeq	r1, sp, r0, lsl #26
     a80:	0b3a0e03 	bleq	e84294 <__bss_end+0xe7838c>
     a84:	0b390b3b 	bleq	e43778 <__bss_end+0xe37870>
     a88:	0b381349 	bleq	e057b4 <__bss_end+0xdf98ac>
     a8c:	00000b32 	andeq	r0, r0, r2, lsr fp
     a90:	4901151e 	stmdbmi	r1, {r1, r2, r3, r4, r8, sl, ip}
     a94:	01136413 	tsteq	r3, r3, lsl r4
     a98:	1f000013 	svcne	0x00000013
     a9c:	131d001f 	tstne	sp, #31
     aa0:	00001349 	andeq	r1, r0, r9, asr #6
     aa4:	0b001020 	bleq	4b2c <shift+0x4b2c>
     aa8:	0013490b 	andseq	r4, r3, fp, lsl #18
     aac:	000f2100 	andeq	r2, pc, r0, lsl #2
     ab0:	00000b0b 	andeq	r0, r0, fp, lsl #22
     ab4:	03003422 	movweq	r3, #1058	; 0x422
     ab8:	3b0b3a0e 	blcc	2cf2f8 <__bss_end+0x2c33f0>
     abc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     ac0:	00180213 	andseq	r0, r8, r3, lsl r2
     ac4:	012e2300 			; <UNDEFINED> instruction: 0x012e2300
     ac8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     acc:	0b3b0b3a 	bleq	ec37bc <__bss_end+0xeb78b4>
     ad0:	0e6e0b39 	vmoveq.8	d14[5], r0
     ad4:	01111349 	tsteq	r1, r9, asr #6
     ad8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     adc:	01194296 			; <UNDEFINED> instruction: 0x01194296
     ae0:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
     ae4:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     ae8:	0b3b0b3a 	bleq	ec37d8 <__bss_end+0xeb78d0>
     aec:	13490b39 	movtne	r0, #39737	; 0x9b39
     af0:	00001802 	andeq	r1, r0, r2, lsl #16
     af4:	3f012e25 	svccc	0x00012e25
     af8:	3a0e0319 	bcc	381764 <__bss_end+0x37585c>
     afc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     b00:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
     b04:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
     b08:	97184006 	ldrls	r4, [r8, -r6]
     b0c:	13011942 	movwne	r1, #6466	; 0x1942
     b10:	34260000 	strtcc	r0, [r6], #-0
     b14:	3a080300 	bcc	20171c <__bss_end+0x1f5814>
     b18:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     b1c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
     b20:	27000018 	smladcs	r0, r8, r0, r0
     b24:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     b28:	0b3a0e03 	bleq	e8433c <__bss_end+0xe78434>
     b2c:	0b390b3b 	bleq	e43820 <__bss_end+0xe37918>
     b30:	01110e6e 	tsteq	r1, lr, ror #28
     b34:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     b38:	01194297 			; <UNDEFINED> instruction: 0x01194297
     b3c:	28000013 	stmdacs	r0, {r0, r1, r4}
     b40:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
     b44:	0b3a0e03 	bleq	e84358 <__bss_end+0xe78450>
     b48:	0b390b3b 	bleq	e4383c <__bss_end+0xe37934>
     b4c:	01110e6e 	tsteq	r1, lr, ror #28
     b50:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     b54:	00194297 	mulseq	r9, r7, r2
     b58:	012e2900 			; <UNDEFINED> instruction: 0x012e2900
     b5c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     b60:	0b3b0b3a 	bleq	ec3850 <__bss_end+0xeb7948>
     b64:	0e6e0b39 	vmoveq.8	d14[5], r0
     b68:	01111349 	tsteq	r1, r9, asr #6
     b6c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     b70:	00194297 	mulseq	r9, r7, r2
     b74:	11010000 	mrsne	r0, (UNDEF: 1)
     b78:	130e2501 	movwne	r2, #58625	; 0xe501
     b7c:	1b0e030b 	blne	3817b0 <__bss_end+0x3758a8>
     b80:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
     b84:	00171006 	andseq	r1, r7, r6
     b88:	00240200 	eoreq	r0, r4, r0, lsl #4
     b8c:	0b3e0b0b 	bleq	f837c0 <__bss_end+0xf778b8>
     b90:	00000e03 	andeq	r0, r0, r3, lsl #28
     b94:	0b002403 	bleq	9ba8 <_Z4readjPcj+0x24>
     b98:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
     b9c:	04000008 	streq	r0, [r0], #-8
     ba0:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
     ba4:	0b3b0b3a 	bleq	ec3894 <__bss_end+0xeb798c>
     ba8:	13490b39 	movtne	r0, #39737	; 0x9b39
     bac:	26050000 	strcs	r0, [r5], -r0
     bb0:	00134900 	andseq	r4, r3, r0, lsl #18
     bb4:	01390600 	teqeq	r9, r0, lsl #12
     bb8:	0b3a0803 	bleq	e82bcc <__bss_end+0xe76cc4>
     bbc:	0b390b3b 	bleq	e438b0 <__bss_end+0xe379a8>
     bc0:	00001301 	andeq	r1, r0, r1, lsl #6
     bc4:	03003407 	movweq	r3, #1031	; 0x407
     bc8:	3b0b3a0e 	blcc	2cf408 <__bss_end+0x2c3500>
     bcc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     bd0:	1c193c13 	ldcne	12, cr3, [r9], {19}
     bd4:	00196c06 	andseq	r6, r9, r6, lsl #24
     bd8:	00340800 	eorseq	r0, r4, r0, lsl #16
     bdc:	0b3a0e03 	bleq	e843f0 <__bss_end+0xe784e8>
     be0:	0b390b3b 	bleq	e438d4 <__bss_end+0xe379cc>
     be4:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     be8:	196c0b1c 	stmdbne	ip!, {r2, r3, r4, r8, r9, fp}^
     bec:	34090000 	strcc	r0, [r9], #-0
     bf0:	00134700 	andseq	r4, r3, r0, lsl #14
     bf4:	00340a00 	eorseq	r0, r4, r0, lsl #20
     bf8:	0b3a0e03 	bleq	e8440c <__bss_end+0xe78504>
     bfc:	0b390b3b 	bleq	e438f0 <__bss_end+0xe379e8>
     c00:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
     c04:	196c051c 	stmdbne	ip!, {r2, r3, r4, r8, sl}^
     c08:	130b0000 	movwne	r0, #45056	; 0xb000
     c0c:	0b0e0301 	bleq	381818 <__bss_end+0x375910>
     c10:	3b0b3a0b 	blcc	2cf444 <__bss_end+0x2c353c>
     c14:	010b390b 	tsteq	fp, fp, lsl #18
     c18:	0c000013 	stceq	0, cr0, [r0], {19}
     c1c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
     c20:	0b3b0b3a 	bleq	ec3910 <__bss_end+0xeb7a08>
     c24:	13490b39 	movtne	r0, #39737	; 0x9b39
     c28:	00000b38 	andeq	r0, r0, r8, lsr fp
     c2c:	0b000f0d 	bleq	4868 <shift+0x4868>
     c30:	0013490b 	andseq	r4, r3, fp, lsl #18
     c34:	01020e00 	tsteq	r2, r0, lsl #28
     c38:	0b0b0e03 	bleq	2c444c <__bss_end+0x2b8544>
     c3c:	0b3b0b3a 	bleq	ec392c <__bss_end+0xeb7a24>
     c40:	13010b39 	movwne	r0, #6969	; 0x1b39
     c44:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
     c48:	03193f01 	tsteq	r9, #1, 30
     c4c:	3b0b3a0e 	blcc	2cf48c <__bss_end+0x2c3584>
     c50:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     c54:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
     c58:	01136419 	tsteq	r3, r9, lsl r4
     c5c:	10000013 	andne	r0, r0, r3, lsl r0
     c60:	13490005 	movtne	r0, #36869	; 0x9005
     c64:	00001934 	andeq	r1, r0, r4, lsr r9
     c68:	49000511 	stmdbmi	r0, {r0, r4, r8, sl}
     c6c:	12000013 	andne	r0, r0, #19
     c70:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
     c74:	0b3a0e03 	bleq	e84488 <__bss_end+0xe78580>
     c78:	0b390b3b 	bleq	e4396c <__bss_end+0xe37a64>
     c7c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
     c80:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
     c84:	13011364 	movwne	r1, #4964	; 0x1364
     c88:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
     c8c:	03193f01 	tsteq	r9, #1, 30
     c90:	3b0b3a0e 	blcc	2cf4d0 <__bss_end+0x2c35c8>
     c94:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     c98:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
     c9c:	00136419 	andseq	r6, r3, r9, lsl r4
     ca0:	000f1400 	andeq	r1, pc, r0, lsl #8
     ca4:	00000b0b 	andeq	r0, r0, fp, lsl #22
     ca8:	03003415 	movweq	r3, #1045	; 0x415
     cac:	3b0b3a0e 	blcc	2cf4ec <__bss_end+0x2c35e4>
     cb0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     cb4:	3c193f13 	ldccc	15, cr3, [r9], {19}
     cb8:	16000019 			; <UNDEFINED> instruction: 0x16000019
     cbc:	13470034 	movtne	r0, #28724	; 0x7034
     cc0:	0b3b0b3a 	bleq	ec39b0 <__bss_end+0xeb7aa8>
     cc4:	18020b39 	stmdane	r2, {r0, r3, r4, r5, r8, r9, fp}
     cc8:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
     ccc:	340e0300 	strcc	r0, [lr], #-768	; 0xfffffd00
     cd0:	12011119 	andne	r1, r1, #1073741830	; 0x40000006
     cd4:	96184006 	ldrls	r4, [r8], -r6
     cd8:	00001942 	andeq	r1, r0, r2, asr #18
     cdc:	03012e18 	movweq	r2, #7704	; 0x1e18
     ce0:	1119340e 	tstne	r9, lr, lsl #8
     ce4:	40061201 	andmi	r1, r6, r1, lsl #4
     ce8:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     cec:	00001301 	andeq	r1, r0, r1, lsl #6
     cf0:	03000519 	movweq	r0, #1305	; 0x519
     cf4:	3b0b3a0e 	blcc	2cf534 <__bss_end+0x2c362c>
     cf8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     cfc:	00180213 	andseq	r0, r8, r3, lsl r2
     d00:	012e1a00 			; <UNDEFINED> instruction: 0x012e1a00
     d04:	0b3a1347 	bleq	e85a28 <__bss_end+0xe79b20>
     d08:	0b390b3b 	bleq	e439fc <__bss_end+0xe37af4>
     d0c:	01111364 	tsteq	r1, r4, ror #6
     d10:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     d14:	01194296 			; <UNDEFINED> instruction: 0x01194296
     d18:	1b000013 	blne	d6c <shift+0xd6c>
     d1c:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     d20:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     d24:	00001802 	andeq	r1, r0, r2, lsl #16
     d28:	0300341c 	movweq	r3, #1052	; 0x41c
     d2c:	3b0b3a0e 	blcc	2cf56c <__bss_end+0x2c3664>
     d30:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     d34:	00180213 	andseq	r0, r8, r3, lsl r2
     d38:	010b1d00 	tsteq	fp, r0, lsl #26
     d3c:	06120111 			; <UNDEFINED> instruction: 0x06120111
     d40:	2e1e0000 	cdpcs	0, 1, cr0, cr14, cr0, {0}
     d44:	3a134701 	bcc	4d2950 <__bss_end+0x4c6a48>
     d48:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     d4c:	1113640b 	tstne	r3, fp, lsl #8
     d50:	40061201 	andmi	r1, r6, r1, lsl #4
     d54:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     d58:	00001301 	andeq	r1, r0, r1, lsl #6
     d5c:	47012e1f 	smladmi	r1, pc, lr, r2	; <UNPREDICTABLE>
     d60:	3b0b3a13 	blcc	2cf5b4 <__bss_end+0x2c36ac>
     d64:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
     d68:	010b2013 	tsteq	fp, r3, lsl r0
     d6c:	20000013 	andcs	r0, r0, r3, lsl r0
     d70:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
     d74:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
     d78:	0b210000 	bleq	840d80 <__bss_end+0x834e78>
     d7c:	22000001 	andcs	r0, r0, #1
     d80:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     d84:	0b3b0b3a 	bleq	ec3a74 <__bss_end+0xeb7b6c>
     d88:	13490b39 	movtne	r0, #39737	; 0x9b39
     d8c:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
     d90:	6e133101 	mufvss	f3, f3, f1
     d94:	1113640e 	tstne	r3, lr, lsl #8
     d98:	40061201 	andmi	r1, r6, r1, lsl #4
     d9c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
     da0:	05240000 	streq	r0, [r4, #-0]!
     da4:	02133100 	andseq	r3, r3, #0, 2
     da8:	25000018 	strcs	r0, [r0, #-24]	; 0xffffffe8
     dac:	1331010b 	teqne	r1, #-1073741822	; 0xc0000002
     db0:	00001301 	andeq	r1, r0, r1, lsl #6
     db4:	31003426 	tstcc	r0, r6, lsr #8
     db8:	27000013 	smladcs	r0, r3, r0, r0
     dbc:	1331010b 	teqne	r1, #-1073741822	; 0xc0000002
     dc0:	06120111 			; <UNDEFINED> instruction: 0x06120111
     dc4:	34280000 	strtcc	r0, [r8], #-0
     dc8:	02133100 	andseq	r3, r3, #0, 2
     dcc:	00000018 	andeq	r0, r0, r8, lsl r0
     dd0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
     dd4:	030b130e 	movweq	r1, #45838	; 0xb30e
     dd8:	110e1b0e 	tstne	lr, lr, lsl #22
     ddc:	10061201 	andne	r1, r6, r1, lsl #4
     de0:	02000017 	andeq	r0, r0, #23
     de4:	13010139 	movwne	r0, #4409	; 0x1139
     de8:	34030000 	strcc	r0, [r3], #-0
     dec:	3a0e0300 	bcc	3819f4 <__bss_end+0x375aec>
     df0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     df4:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
     df8:	000a1c19 	andeq	r1, sl, r9, lsl ip
     dfc:	003a0400 	eorseq	r0, sl, r0, lsl #8
     e00:	0b3b0b3a 	bleq	ec3af0 <__bss_end+0xeb7be8>
     e04:	13180b39 	tstne	r8, #58368	; 0xe400
     e08:	01050000 	mrseq	r0, (UNDEF: 5)
     e0c:	01134901 	tsteq	r3, r1, lsl #18
     e10:	06000013 			; <UNDEFINED> instruction: 0x06000013
     e14:	13490021 	movtne	r0, #36897	; 0x9021
     e18:	00000b2f 	andeq	r0, r0, pc, lsr #22
     e1c:	49002607 	stmdbmi	r0, {r0, r1, r2, r9, sl, sp}
     e20:	08000013 	stmdaeq	r0, {r0, r1, r4}
     e24:	0b0b0024 	bleq	2c0ebc <__bss_end+0x2b4fb4>
     e28:	0e030b3e 	vmoveq.16	d3[0], r0
     e2c:	34090000 	strcc	r0, [r9], #-0
     e30:	00134700 	andseq	r4, r3, r0, lsl #14
     e34:	012e0a00 			; <UNDEFINED> instruction: 0x012e0a00
     e38:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
     e3c:	0b3b0b3a 	bleq	ec3b2c <__bss_end+0xeb7c24>
     e40:	0e6e0b39 	vmoveq.8	d14[5], r0
     e44:	01111349 	tsteq	r1, r9, asr #6
     e48:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
     e4c:	01194296 			; <UNDEFINED> instruction: 0x01194296
     e50:	0b000013 	bleq	ea4 <shift+0xea4>
     e54:	08030005 	stmdaeq	r3, {r0, r2}
     e58:	0b3b0b3a 	bleq	ec3b48 <__bss_end+0xeb7c40>
     e5c:	13490b39 	movtne	r0, #39737	; 0x9b39
     e60:	00001802 	andeq	r1, r0, r2, lsl #16
     e64:	0300340c 	movweq	r3, #1036	; 0x40c
     e68:	3b0b3a08 	blcc	2cf690 <__bss_end+0x2c3788>
     e6c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     e70:	00180213 	andseq	r0, r8, r3, lsl r2
     e74:	00340d00 	eorseq	r0, r4, r0, lsl #26
     e78:	0b3a0e03 	bleq	e8468c <__bss_end+0xe78784>
     e7c:	0b390b3b 	bleq	e43b70 <__bss_end+0xe37c68>
     e80:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     e84:	0f0e0000 	svceq	0x000e0000
     e88:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
     e8c:	0f000013 	svceq	0x00000013
     e90:	0b0b0024 	bleq	2c0f28 <__bss_end+0x2b5020>
     e94:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
     e98:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
     e9c:	03193f01 	tsteq	r9, #1, 30
     ea0:	3b0b3a0e 	blcc	2cf6e0 <__bss_end+0x2c37d8>
     ea4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     ea8:	1113490e 	tstne	r3, lr, lsl #18
     eac:	40061201 	andmi	r1, r6, r1, lsl #4
     eb0:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     eb4:	00001301 	andeq	r1, r0, r1, lsl #6
     eb8:	3f012e11 	svccc	0x00012e11
     ebc:	3a0e0319 	bcc	381b28 <__bss_end+0x375c20>
     ec0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
     ec4:	110e6e0b 	tstne	lr, fp, lsl #28
     ec8:	40061201 	andmi	r1, r6, r1, lsl #4
     ecc:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     ed0:	00001301 	andeq	r1, r0, r1, lsl #6
     ed4:	11010b12 	tstne	r1, r2, lsl fp
     ed8:	00061201 	andeq	r1, r6, r1, lsl #4
     edc:	00261300 	eoreq	r1, r6, r0, lsl #6
     ee0:	0f140000 	svceq	0x00140000
     ee4:	000b0b00 	andeq	r0, fp, r0, lsl #22
     ee8:	00051500 	andeq	r1, r5, r0, lsl #10
     eec:	0b3a0e03 	bleq	e84700 <__bss_end+0xe787f8>
     ef0:	0b390b3b 	bleq	e43be4 <__bss_end+0xe37cdc>
     ef4:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
     ef8:	2e160000 	cdpcs	0, 1, cr0, cr6, cr0, {0}
     efc:	03193f01 	tsteq	r9, #1, 30
     f00:	3b0b3a0e 	blcc	2cf740 <__bss_end+0x2c3838>
     f04:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     f08:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
     f0c:	96184006 	ldrls	r4, [r8], -r6
     f10:	13011942 	movwne	r1, #6466	; 0x1942
     f14:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
     f18:	03193f01 	tsteq	r9, #1, 30
     f1c:	3b0b3a0e 	blcc	2cf75c <__bss_end+0x2c3854>
     f20:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
     f24:	1113490e 	tstne	r3, lr, lsl #18
     f28:	40061201 	andmi	r1, r6, r1, lsl #4
     f2c:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
     f30:	01000000 	mrseq	r0, (UNDEF: 0)
     f34:	06100011 			; <UNDEFINED> instruction: 0x06100011
     f38:	01120111 	tsteq	r2, r1, lsl r1
     f3c:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
     f40:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
     f44:	01000000 	mrseq	r0, (UNDEF: 0)
     f48:	06100011 			; <UNDEFINED> instruction: 0x06100011
     f4c:	01120111 	tsteq	r2, r1, lsl r1
     f50:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
     f54:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
     f58:	01000000 	mrseq	r0, (UNDEF: 0)
     f5c:	06100011 			; <UNDEFINED> instruction: 0x06100011
     f60:	01120111 	tsteq	r2, r1, lsl r1
     f64:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
     f68:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
     f6c:	01000000 	mrseq	r0, (UNDEF: 0)
     f70:	06100011 			; <UNDEFINED> instruction: 0x06100011
     f74:	01120111 	tsteq	r2, r1, lsl r1
     f78:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
     f7c:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
     f80:	01000000 	mrseq	r0, (UNDEF: 0)
     f84:	06100011 			; <UNDEFINED> instruction: 0x06100011
     f88:	01120111 	tsteq	r2, r1, lsl r1
     f8c:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
     f90:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
     f94:	01000000 	mrseq	r0, (UNDEF: 0)
     f98:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
     f9c:	0e030b13 	vmoveq.32	d3[0], r0
     fa0:	17100e1b 			; <UNDEFINED> instruction: 0x17100e1b
     fa4:	24020000 	strcs	r0, [r2], #-0
     fa8:	3e0b0b00 	vmlacc.f64	d0, d11, d0
     fac:	0008030b 	andeq	r0, r8, fp, lsl #6
     fb0:	00240300 	eoreq	r0, r4, r0, lsl #6
     fb4:	0b3e0b0b 	bleq	f83be8 <__bss_end+0xf77ce0>
     fb8:	00000e03 	andeq	r0, r0, r3, lsl #28
     fbc:	03001604 	movweq	r1, #1540	; 0x604
     fc0:	3b0b3a0e 	blcc	2cf800 <__bss_end+0x2c38f8>
     fc4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
     fc8:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
     fcc:	0b0b000f 	bleq	2c1010 <__bss_end+0x2b5108>
     fd0:	00001349 	andeq	r1, r0, r9, asr #6
     fd4:	27011506 	strcs	r1, [r1, -r6, lsl #10]
     fd8:	01134919 	tsteq	r3, r9, lsl r9
     fdc:	07000013 	smladeq	r0, r3, r0, r0
     fe0:	13490005 	movtne	r0, #36869	; 0x9005
     fe4:	26080000 	strcs	r0, [r8], -r0
     fe8:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     fec:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
     ff0:	0b3b0b3a 	bleq	ec3ce0 <__bss_end+0xeb7dd8>
     ff4:	13490b39 	movtne	r0, #39737	; 0x9b39
     ff8:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
     ffc:	040a0000 	streq	r0, [sl], #-0
    1000:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
    1004:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
    1008:	3b0b3a13 	blcc	2cf85c <__bss_end+0x2c3954>
    100c:	010b390b 	tsteq	fp, fp, lsl #18
    1010:	0b000013 	bleq	1064 <shift+0x1064>
    1014:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
    1018:	00000b1c 	andeq	r0, r0, ip, lsl fp
    101c:	4901010c 	stmdbmi	r1, {r2, r3, r8}
    1020:	00130113 	andseq	r0, r3, r3, lsl r1
    1024:	00210d00 	eoreq	r0, r1, r0, lsl #26
    1028:	260e0000 	strcs	r0, [lr], -r0
    102c:	00134900 	andseq	r4, r3, r0, lsl #18
    1030:	00340f00 	eorseq	r0, r4, r0, lsl #30
    1034:	0b3a0e03 	bleq	e84848 <__bss_end+0xe78940>
    1038:	0b39053b 	bleq	e4252c <__bss_end+0xe36624>
    103c:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
    1040:	0000193c 	andeq	r1, r0, ip, lsr r9
    1044:	03001310 	movweq	r1, #784	; 0x310
    1048:	00193c0e 	andseq	r3, r9, lr, lsl #24
    104c:	00151100 	andseq	r1, r5, r0, lsl #2
    1050:	00001927 	andeq	r1, r0, r7, lsr #18
    1054:	03001712 	movweq	r1, #1810	; 0x712
    1058:	00193c0e 	andseq	r3, r9, lr, lsl #24
    105c:	01131300 	tsteq	r3, r0, lsl #6
    1060:	0b0b0e03 	bleq	2c4874 <__bss_end+0x2b896c>
    1064:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    1068:	13010b39 	movwne	r0, #6969	; 0x1b39
    106c:	0d140000 	ldceq	0, cr0, [r4, #-0]
    1070:	3a0e0300 	bcc	381c78 <__bss_end+0x375d70>
    1074:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    1078:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
    107c:	1500000b 	strne	r0, [r0, #-11]
    1080:	13490021 	movtne	r0, #36897	; 0x9021
    1084:	00000b2f 	andeq	r0, r0, pc, lsr #22
    1088:	03010416 	movweq	r0, #5142	; 0x1416
    108c:	0b0b3e0e 	bleq	2d08cc <__bss_end+0x2c49c4>
    1090:	3a13490b 	bcc	4d34c4 <__bss_end+0x4c75bc>
    1094:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    1098:	0013010b 	andseq	r0, r3, fp, lsl #2
    109c:	00341700 	eorseq	r1, r4, r0, lsl #14
    10a0:	0b3a1347 	bleq	e85dc4 <__bss_end+0xe79ebc>
    10a4:	0b39053b 	bleq	e42598 <__bss_end+0xe36690>
    10a8:	00001802 	andeq	r1, r0, r2, lsl #16
    10ac:	01110100 	tsteq	r1, r0, lsl #2
    10b0:	0b130e25 	bleq	4c494c <__bss_end+0x4b8a44>
    10b4:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
    10b8:	06120111 			; <UNDEFINED> instruction: 0x06120111
    10bc:	00001710 	andeq	r1, r0, r0, lsl r7
    10c0:	0b002402 	bleq	a0d0 <_ZN12CUserHeapMan4sbrkEjb+0x9c>
    10c4:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
    10c8:	0300000e 	movweq	r0, #14
    10cc:	0b0b0024 	bleq	2c1164 <__bss_end+0x2b525c>
    10d0:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
    10d4:	16040000 	strne	r0, [r4], -r0
    10d8:	3a0e0300 	bcc	381ce0 <__bss_end+0x375dd8>
    10dc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    10e0:	0013490b 	andseq	r4, r3, fp, lsl #18
    10e4:	000f0500 	andeq	r0, pc, r0, lsl #10
    10e8:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    10ec:	15060000 	strne	r0, [r6, #-0]
    10f0:	49192701 	ldmdbmi	r9, {r0, r8, r9, sl, sp}
    10f4:	00130113 	andseq	r0, r3, r3, lsl r1
    10f8:	00050700 	andeq	r0, r5, r0, lsl #14
    10fc:	00001349 	andeq	r1, r0, r9, asr #6
    1100:	00002608 	andeq	r2, r0, r8, lsl #12
    1104:	00340900 	eorseq	r0, r4, r0, lsl #18
    1108:	0b3a0e03 	bleq	e8491c <__bss_end+0xe78a14>
    110c:	0b390b3b 	bleq	e43e00 <__bss_end+0xe37ef8>
    1110:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
    1114:	0000193c 	andeq	r1, r0, ip, lsr r9
    1118:	0301040a 	movweq	r0, #5130	; 0x140a
    111c:	0b0b3e0e 	bleq	2d095c <__bss_end+0x2c4a54>
    1120:	3a13490b 	bcc	4d3554 <__bss_end+0x4c764c>
    1124:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1128:	0013010b 	andseq	r0, r3, fp, lsl #2
    112c:	00280b00 	eoreq	r0, r8, r0, lsl #22
    1130:	0b1c0e03 	bleq	704944 <__bss_end+0x6f8a3c>
    1134:	010c0000 	mrseq	r0, (UNDEF: 12)
    1138:	01134901 	tsteq	r3, r1, lsl #18
    113c:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
    1140:	00000021 	andeq	r0, r0, r1, lsr #32
    1144:	4900260e 	stmdbmi	r0, {r1, r2, r3, r9, sl, sp}
    1148:	0f000013 	svceq	0x00000013
    114c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
    1150:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    1154:	13490b39 	movtne	r0, #39737	; 0x9b39
    1158:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
    115c:	13100000 	tstne	r0, #0
    1160:	3c0e0300 	stccc	3, cr0, [lr], {-0}
    1164:	11000019 	tstne	r0, r9, lsl r0
    1168:	19270015 	stmdbne	r7!, {r0, r2, r4}
    116c:	17120000 	ldrne	r0, [r2, -r0]
    1170:	3c0e0300 	stccc	3, cr0, [lr], {-0}
    1174:	13000019 	movwne	r0, #25
    1178:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
    117c:	0b3a0b0b 	bleq	e83db0 <__bss_end+0xe77ea8>
    1180:	0b39053b 	bleq	e42674 <__bss_end+0xe3676c>
    1184:	00001301 	andeq	r1, r0, r1, lsl #6
    1188:	03000d14 	movweq	r0, #3348	; 0xd14
    118c:	3b0b3a0e 	blcc	2cf9cc <__bss_end+0x2c3ac4>
    1190:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
    1194:	000b3813 	andeq	r3, fp, r3, lsl r8
    1198:	00211500 	eoreq	r1, r1, r0, lsl #10
    119c:	0b2f1349 	bleq	bc5ec8 <__bss_end+0xbb9fc0>
    11a0:	04160000 	ldreq	r0, [r6], #-0
    11a4:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
    11a8:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
    11ac:	3b0b3a13 	blcc	2cfa00 <__bss_end+0x2c3af8>
    11b0:	010b3905 	tsteq	fp, r5, lsl #18
    11b4:	17000013 	smladne	r0, r3, r0, r0
    11b8:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
    11bc:	0b3a0e03 	bleq	e849d0 <__bss_end+0xe78ac8>
    11c0:	0b39053b 	bleq	e426b4 <__bss_end+0xe367ac>
    11c4:	13491927 	movtne	r1, #39207	; 0x9927
    11c8:	06120111 			; <UNDEFINED> instruction: 0x06120111
    11cc:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
    11d0:	00130119 	andseq	r0, r3, r9, lsl r1
    11d4:	00051800 	andeq	r1, r5, r0, lsl #16
    11d8:	0b3a0803 	bleq	e831ec <__bss_end+0xe772e4>
    11dc:	0b39053b 	bleq	e426d0 <__bss_end+0xe367c8>
    11e0:	17021349 	strne	r1, [r2, -r9, asr #6]
    11e4:	001742b7 			; <UNDEFINED> instruction: 0x001742b7
    11e8:	82891900 	addhi	r1, r9, #0, 18
    11ec:	01110101 	tsteq	r1, r1, lsl #2
    11f0:	31194295 			; <UNDEFINED> instruction: 0x31194295
    11f4:	00130113 	andseq	r0, r3, r3, lsl r1
    11f8:	828a1a00 	addhi	r1, sl, #0, 20
    11fc:	18020001 	stmdane	r2, {r0}
    1200:	00184291 	mulseq	r8, r1, r2
    1204:	82891b00 	addhi	r1, r9, #0, 22
    1208:	01110101 	tsteq	r1, r1, lsl #2
    120c:	00001331 	andeq	r1, r0, r1, lsr r3
    1210:	3f002e1c 	svccc	0x00002e1c
    1214:	6e193c19 	mrcvs	12, 0, r3, cr9, cr9, {0}
    1218:	3a0e030e 	bcc	381e58 <__bss_end+0x375f50>
    121c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
    1220:	0000000b 	andeq	r0, r0, fp
    1224:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
    1228:	030b130e 	movweq	r1, #45838	; 0xb30e
    122c:	110e1b0e 	tstne	lr, lr, lsl #22
    1230:	10061201 	andne	r1, r6, r1, lsl #4
    1234:	02000017 	andeq	r0, r0, #23
    1238:	0b0b0024 	bleq	2c12d0 <__bss_end+0x2b53c8>
    123c:	0e030b3e 	vmoveq.16	d3[0], r0
    1240:	24030000 	strcs	r0, [r3], #-0
    1244:	3e0b0b00 	vmlacc.f64	d0, d11, d0
    1248:	0008030b 	andeq	r0, r8, fp, lsl #6
    124c:	00160400 	andseq	r0, r6, r0, lsl #8
    1250:	0b3a0e03 	bleq	e84a64 <__bss_end+0xe78b5c>
    1254:	0b390b3b 	bleq	e43f48 <__bss_end+0xe38040>
    1258:	00001349 	andeq	r1, r0, r9, asr #6
    125c:	0b000f05 	bleq	4e78 <shift+0x4e78>
    1260:	0013490b 	andseq	r4, r3, fp, lsl #18
    1264:	01150600 	tsteq	r5, r0, lsl #12
    1268:	13491927 	movtne	r1, #39207	; 0x9927
    126c:	00001301 	andeq	r1, r0, r1, lsl #6
    1270:	49000507 	stmdbmi	r0, {r0, r1, r2, r8, sl}
    1274:	08000013 	stmdaeq	r0, {r0, r1, r4}
    1278:	00000026 	andeq	r0, r0, r6, lsr #32
    127c:	03003409 	movweq	r3, #1033	; 0x409
    1280:	3b0b3a0e 	blcc	2cfac0 <__bss_end+0x2c3bb8>
    1284:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    1288:	3c193f13 	ldccc	15, cr3, [r9], {19}
    128c:	0a000019 	beq	12f8 <shift+0x12f8>
    1290:	0e030104 	adfeqs	f0, f3, f4
    1294:	0b0b0b3e 	bleq	2c3f94 <__bss_end+0x2b808c>
    1298:	0b3a1349 	bleq	e85fc4 <__bss_end+0xe7a0bc>
    129c:	0b390b3b 	bleq	e43f90 <__bss_end+0xe38088>
    12a0:	00001301 	andeq	r1, r0, r1, lsl #6
    12a4:	0300280b 	movweq	r2, #2059	; 0x80b
    12a8:	000b1c0e 	andeq	r1, fp, lr, lsl #24
    12ac:	01010c00 	tsteq	r1, r0, lsl #24
    12b0:	13011349 	movwne	r1, #4937	; 0x1349
    12b4:	210d0000 	mrscs	r0, (UNDEF: 13)
    12b8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    12bc:	13490026 	movtne	r0, #36902	; 0x9026
    12c0:	340f0000 	strcc	r0, [pc], #-0	; 12c8 <shift+0x12c8>
    12c4:	3a0e0300 	bcc	381ecc <__bss_end+0x375fc4>
    12c8:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    12cc:	3f13490b 	svccc	0x0013490b
    12d0:	00193c19 	andseq	r3, r9, r9, lsl ip
    12d4:	00131000 	andseq	r1, r3, r0
    12d8:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
    12dc:	15110000 	ldrne	r0, [r1, #-0]
    12e0:	00192700 	andseq	r2, r9, r0, lsl #14
    12e4:	00171200 	andseq	r1, r7, r0, lsl #4
    12e8:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
    12ec:	13130000 	tstne	r3, #0
    12f0:	0b0e0301 	bleq	381efc <__bss_end+0x375ff4>
    12f4:	3b0b3a0b 	blcc	2cfb28 <__bss_end+0x2c3c20>
    12f8:	010b3905 	tsteq	fp, r5, lsl #18
    12fc:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
    1300:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
    1304:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    1308:	13490b39 	movtne	r0, #39737	; 0x9b39
    130c:	00000b38 	andeq	r0, r0, r8, lsr fp
    1310:	49002115 	stmdbmi	r0, {r0, r2, r4, r8, sp}
    1314:	000b2f13 	andeq	r2, fp, r3, lsl pc
    1318:	01041600 	tsteq	r4, r0, lsl #12
    131c:	0b3e0e03 	bleq	f84b30 <__bss_end+0xf78c28>
    1320:	13490b0b 	movtne	r0, #39691	; 0x9b0b
    1324:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    1328:	13010b39 	movwne	r0, #6969	; 0x1b39
    132c:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
    1330:	03193f01 	tsteq	r9, #1, 30
    1334:	3b0b3a0e 	blcc	2cfb74 <__bss_end+0x2c3c6c>
    1338:	270b3905 	strcs	r3, [fp, -r5, lsl #18]
    133c:	11134919 	tstne	r3, r9, lsl r9
    1340:	40061201 	andmi	r1, r6, r1, lsl #4
    1344:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
    1348:	05180000 	ldreq	r0, [r8, #-0]
    134c:	3a080300 	bcc	201f54 <__bss_end+0x1f604c>
    1350:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    1354:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    1358:	1742b717 	smlaldne	fp, r2, r7, r7
    135c:	34190000 	ldrcc	r0, [r9], #-0
    1360:	3a080300 	bcc	201f68 <__bss_end+0x1f6060>
    1364:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    1368:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
    136c:	1742b717 	smlaldne	fp, r2, r7, r7
    1370:	01000000 	mrseq	r0, (UNDEF: 0)
    1374:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
    1378:	0e030b13 	vmoveq.32	d3[0], r0
    137c:	01110e1b 	tsteq	r1, fp, lsl lr
    1380:	17100612 			; <UNDEFINED> instruction: 0x17100612
    1384:	24020000 	strcs	r0, [r2], #-0
    1388:	3e0b0b00 	vmlacc.f64	d0, d11, d0
    138c:	000e030b 	andeq	r0, lr, fp, lsl #6
    1390:	00240300 	eoreq	r0, r4, r0, lsl #6
    1394:	0b3e0b0b 	bleq	f83fc8 <__bss_end+0xf780c0>
    1398:	00000803 	andeq	r0, r0, r3, lsl #16
    139c:	03001604 	movweq	r1, #1540	; 0x604
    13a0:	3b0b3a0e 	blcc	2cfbe0 <__bss_end+0x2c3cd8>
    13a4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
    13a8:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    13ac:	0b0b000f 	bleq	2c13f0 <__bss_end+0x2b54e8>
    13b0:	00001349 	andeq	r1, r0, r9, asr #6
    13b4:	27011506 	strcs	r1, [r1, -r6, lsl #10]
    13b8:	01134919 	tsteq	r3, r9, lsl r9
    13bc:	07000013 	smladeq	r0, r3, r0, r0
    13c0:	13490005 	movtne	r0, #36869	; 0x9005
    13c4:	26080000 	strcs	r0, [r8], -r0
    13c8:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    13cc:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
    13d0:	0b3b0b3a 	bleq	ec40c0 <__bss_end+0xeb81b8>
    13d4:	13490b39 	movtne	r0, #39737	; 0x9b39
    13d8:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
    13dc:	040a0000 	streq	r0, [sl], #-0
    13e0:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
    13e4:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
    13e8:	3b0b3a13 	blcc	2cfc3c <__bss_end+0x2c3d34>
    13ec:	010b390b 	tsteq	fp, fp, lsl #18
    13f0:	0b000013 	bleq	1444 <shift+0x1444>
    13f4:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
    13f8:	00000b1c 	andeq	r0, r0, ip, lsl fp
    13fc:	4901010c 	stmdbmi	r1, {r2, r3, r8}
    1400:	00130113 	andseq	r0, r3, r3, lsl r1
    1404:	00210d00 	eoreq	r0, r1, r0, lsl #26
    1408:	260e0000 	strcs	r0, [lr], -r0
    140c:	00134900 	andseq	r4, r3, r0, lsl #18
    1410:	00340f00 	eorseq	r0, r4, r0, lsl #30
    1414:	0b3a0e03 	bleq	e84c28 <__bss_end+0xe78d20>
    1418:	0b39053b 	bleq	e4290c <__bss_end+0xe36a04>
    141c:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
    1420:	0000193c 	andeq	r1, r0, ip, lsr r9
    1424:	03001310 	movweq	r1, #784	; 0x310
    1428:	00193c0e 	andseq	r3, r9, lr, lsl #24
    142c:	00151100 	andseq	r1, r5, r0, lsl #2
    1430:	00001927 	andeq	r1, r0, r7, lsr #18
    1434:	03001712 	movweq	r1, #1810	; 0x712
    1438:	00193c0e 	andseq	r3, r9, lr, lsl #24
    143c:	01131300 	tsteq	r3, r0, lsl #6
    1440:	0b0b0e03 	bleq	2c4c54 <__bss_end+0x2b8d4c>
    1444:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    1448:	13010b39 	movwne	r0, #6969	; 0x1b39
    144c:	0d140000 	ldceq	0, cr0, [r4, #-0]
    1450:	3a0e0300 	bcc	382058 <__bss_end+0x376150>
    1454:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    1458:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
    145c:	1500000b 	strne	r0, [r0, #-11]
    1460:	13490021 	movtne	r0, #36897	; 0x9021
    1464:	00000b2f 	andeq	r0, r0, pc, lsr #22
    1468:	03010416 	movweq	r0, #5142	; 0x1416
    146c:	0b0b3e0e 	bleq	2d0cac <__bss_end+0x2c4da4>
    1470:	3a13490b 	bcc	4d38a4 <__bss_end+0x4c799c>
    1474:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
    1478:	0013010b 	andseq	r0, r3, fp, lsl #2
    147c:	012e1700 			; <UNDEFINED> instruction: 0x012e1700
    1480:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
    1484:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    1488:	19270b39 	stmdbne	r7!, {r0, r3, r4, r5, r8, r9, fp}
    148c:	01111349 	tsteq	r1, r9, asr #6
    1490:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
    1494:	01194297 			; <UNDEFINED> instruction: 0x01194297
    1498:	18000013 	stmdane	r0, {r0, r1, r4}
    149c:	08030005 	stmdaeq	r3, {r0, r2}
    14a0:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    14a4:	13490b39 	movtne	r0, #39737	; 0x9b39
    14a8:	42b71702 	adcsmi	r1, r7, #524288	; 0x80000
    14ac:	19000017 	stmdbne	r0, {r0, r1, r2, r4}
    14b0:	08030005 	stmdaeq	r3, {r0, r2}
    14b4:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
    14b8:	13490b39 	movtne	r0, #39737	; 0x9b39
    14bc:	00001802 	andeq	r1, r0, r2, lsl #16
    14c0:	0300341a 	movweq	r3, #1050	; 0x41a
    14c4:	3b0b3a08 	blcc	2cfcec <__bss_end+0x2c3de4>
    14c8:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
    14cc:	b7170213 			; <UNDEFINED> instruction: 0xb7170213
    14d0:	00001742 	andeq	r1, r0, r2, asr #14
    14d4:	0300341b 	movweq	r3, #1051	; 0x41b
    14d8:	3b0b3a08 	blcc	2cfd00 <__bss_end+0x2c3df8>
    14dc:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
    14e0:	00000013 	andeq	r0, r0, r3, lsl r0

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
  60:	00000034 	andeq	r0, r0, r4, lsr r0
  64:	02d40002 	sbcseq	r0, r4, #2
  68:	00040000 	andeq	r0, r4, r0
  6c:	00000000 	andeq	r0, r0, r0
  70:	00008228 	andeq	r8, r0, r8, lsr #4
  74:	00001478 	andeq	r1, r0, r8, ror r4
  78:	000096a0 	andeq	r9, r0, r0, lsr #13
  7c:	00000030 	andeq	r0, r0, r0, lsr r0
  80:	000096d0 	ldrdeq	r9, [r0], -r0
  84:	00000070 	andeq	r0, r0, r0, ror r0
  88:	00009740 	andeq	r9, r0, r0, asr #14
  8c:	000000bc 	strheq	r0, [r0], -ip
	...
  98:	0000001c 	andeq	r0, r0, ip, lsl r0
  9c:	18440002 	stmdane	r4, {r1}^
  a0:	00040000 	andeq	r0, r4, r0
  a4:	00000000 	andeq	r0, r0, r0
  a8:	000097fc 	strdeq	r9, [r0], -ip
  ac:	000002a4 	andeq	r0, r0, r4, lsr #5
	...
  b8:	0000001c 	andeq	r0, r0, ip, lsl r0
  bc:	1b900002 	blne	fe4000cc <__bss_end+0xfe3f41c4>
  c0:	00040000 	andeq	r0, r4, r0
  c4:	00000000 	andeq	r0, r0, r0
  c8:	00009aa0 	andeq	r9, r0, r0, lsr #21
  cc:	0000048c 	andeq	r0, r0, ip, lsl #9
	...
  d8:	0000001c 	andeq	r0, r0, ip, lsl r0
  dc:	28ab0002 	stmiacs	fp!, {r1}
  e0:	00040000 	andeq	r0, r4, r0
  e4:	00000000 	andeq	r0, r0, r0
  e8:	00009f2c 	andeq	r9, r0, ip, lsr #30
  ec:	00000434 	andeq	r0, r0, r4, lsr r4
	...
  f8:	0000001c 	andeq	r0, r0, ip, lsl r0
  fc:	2e3d0002 	cdpcs	0, 3, cr0, cr13, cr2, {0}
 100:	00040000 	andeq	r0, r4, r0
 104:	00000000 	andeq	r0, r0, r0
 108:	0000a360 	andeq	sl, r0, r0, ror #6
 10c:	00000e9c 	muleq	r0, ip, lr
	...
 118:	0000001c 	andeq	r0, r0, ip, lsl r0
 11c:	342c0002 	strtcc	r0, [ip], #-2
 120:	00040000 	andeq	r0, r4, r0
 124:	00000000 	andeq	r0, r0, r0
 128:	0000b1fc 	strdeq	fp, [r0], -ip
 12c:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	34520002 	ldrbcc	r0, [r2], #-2
 140:	00040000 	andeq	r0, r4, r0
 144:	00000000 	andeq	r0, r0, r0
 148:	0000b408 	andeq	fp, r0, r8, lsl #8
 14c:	00000240 	andeq	r0, r0, r0, asr #4
	...
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	34780002 	ldrbtcc	r0, [r8], #-2
 160:	00040000 	andeq	r0, r4, r0
 164:	00000000 	andeq	r0, r0, r0
 168:	0000b648 	andeq	fp, r0, r8, asr #12
 16c:	00000004 	andeq	r0, r0, r4
	...
 178:	0000001c 	andeq	r0, r0, ip, lsl r0
 17c:	349e0002 	ldrcc	r0, [lr], #2
 180:	00040000 	andeq	r0, r4, r0
 184:	00000000 	andeq	r0, r0, r0
 188:	0000b64c 	andeq	fp, r0, ip, asr #12
 18c:	00000250 	andeq	r0, r0, r0, asr r2
	...
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	34c40002 	strbcc	r0, [r4], #2
 1a0:	00040000 	andeq	r0, r4, r0
 1a4:	00000000 	andeq	r0, r0, r0
 1a8:	0000b89c 	muleq	r0, ip, r8
 1ac:	000000d4 	ldrdeq	r0, [r0], -r4
	...
 1b8:	00000014 	andeq	r0, r0, r4, lsl r0
 1bc:	34ea0002 	strbtcc	r0, [sl], #2
 1c0:	00040000 	andeq	r0, r4, r0
	...
 1d0:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d4:	3ef70002 	cdpcc	0, 15, cr0, cr7, cr2, {0}
 1d8:	00040000 	andeq	r0, r4, r0
 1dc:	00000000 	andeq	r0, r0, r0
 1e0:	0000b970 	andeq	fp, r0, r0, ror r9
 1e4:	0000002c 	andeq	r0, r0, ip, lsr #32
	...
 1f0:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f4:	493d0002 	ldmdbmi	sp!, {r1}
 1f8:	00040000 	andeq	r0, r4, r0
 1fc:	00000000 	andeq	r0, r0, r0
 200:	0000b9a0 	andeq	fp, r0, r0, lsr #19
 204:	00000040 	andeq	r0, r0, r0, asr #32
	...
 210:	0000001c 	andeq	r0, r0, ip, lsl r0
 214:	53a70002 			; <UNDEFINED> instruction: 0x53a70002
 218:	00040000 	andeq	r0, r4, r0
 21c:	00000000 	andeq	r0, r0, r0
 220:	0000b9e0 	andeq	fp, r0, r0, ror #19
 224:	00000128 	andeq	r0, r0, r8, lsr #2
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff4044>
       4:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
       8:	6b69746e 	blvs	1a5d1c8 <__bss_end+0x1a512c0>
       c:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
      10:	6e69662f 	cdpvs	6, 6, cr6, cr9, cr15, {1}
      14:	732f6c61 			; <UNDEFINED> instruction: 0x732f6c61
      18:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
      1c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
      20:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcc3 <__bss_end+0xffff3dbb>
      24:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
      28:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
      2c:	7472632f 	ldrbtvc	r6, [r2], #-815	; 0xfffffcd1
      30:	00732e30 	rsbseq	r2, r3, r0, lsr lr
      34:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff80 <__bss_end+0xffff4078>
      38:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
      3c:	6b69746e 	blvs	1a5d1fc <__bss_end+0x1a512f4>
      40:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
      44:	6e69662f 	cdpvs	6, 6, cr6, cr9, cr15, {1}
      48:	732f6c61 			; <UNDEFINED> instruction: 0x732f6c61
      4c:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
      50:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
      54:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcf7 <__bss_end+0xffff3def>
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
      e8:	5b202965 	blpl	80a684 <__bss_end+0x7fe77c>
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
     130:	6a363731 	bvs	d8ddfc <__bss_end+0xd81ef4>
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
     160:	7a6a3637 	bvc	1a8da44 <__bss_end+0x1a81b3c>
     164:	20732d66 	rsbscs	r2, r3, r6, ror #26
     168:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     16c:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
     170:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
     174:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     178:	6b7a3676 	blvs	1e8db58 <__bss_end+0x1e81c50>
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
     288:	2b2b4320 	blcs	ad0f10 <__bss_end+0xac5008>
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
     31c:	6a363731 	bvs	d8dfe8 <__bss_end+0xd820e0>
     320:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     324:	616d2d20 	cmnvs	sp, r0, lsr #26
     328:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     32c:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     330:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     334:	7a36766d 	bvc	d9dcf0 <__bss_end+0xd91de8>
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
     3c4:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     3c8:	735f6465 	cmpvc	pc, #1694498816	; 0x65000000
     3cc:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     3d0:	72705f63 	rsbsvc	r5, r0, #396	; 0x18c
     3d4:	69726f69 	ldmdbvs	r2!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     3d8:	5f007974 	svcpl	0x00007974
     3dc:	314b4e5a 	cmpcc	fp, sl, asr lr
     3e0:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     3e4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     3e8:	614d5f73 	hvcvs	54771	; 0xd5f3
     3ec:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     3f0:	47383172 			; <UNDEFINED> instruction: 0x47383172
     3f4:	505f7465 	subspl	r7, pc, r5, ror #8
     3f8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     3fc:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
     400:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     404:	006a4544 	rsbeq	r4, sl, r4, asr #10
     408:	314e5a5f 	cmpcc	lr, pc, asr sl
     40c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     410:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     414:	614d5f73 	hvcvs	54771	; 0xd5f3
     418:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     41c:	4d393172 	ldfmis	f3, [r9, #-456]!	; 0xfffffe38
     420:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     424:	5f656c69 	svcpl	0x00656c69
     428:	435f6f54 	cmpmi	pc, #84, 30	; 0x150
     42c:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     430:	5045746e 	subpl	r7, r5, lr, ror #8
     434:	69464935 	stmdbvs	r6, {r0, r2, r4, r5, r8, fp, lr}^
     438:	5500656c 	strpl	r6, [r0, #-1388]	; 0xfffffa94
     43c:	70616d6e 	rsbvc	r6, r1, lr, ror #26
     440:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     444:	75435f65 	strbvc	r5, [r3, #-3941]	; 0xfffff09b
     448:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     44c:	69460074 	stmdbvs	r6, {r2, r4, r5, r6}^
     450:	50747372 	rsbspl	r7, r4, r2, ror r3
     454:	52656761 	rsbpl	r6, r5, #25427968	; 0x1840000
     458:	65757165 	ldrbvs	r7, [r5, #-357]!	; 0xfffffe9b
     45c:	65007473 	strvs	r7, [r0, #-1139]	; 0xfffffb8d
     460:	5f746978 	svcpl	0x00746978
     464:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     468:	315a5f00 	cmpcc	sl, r0, lsl #30
     46c:	61657232 	cmnvs	r5, r2, lsr r2
     470:	6e695f64 	cdpvs	15, 6, cr5, cr9, cr4, {3}
     474:	65676574 	strbvs	r6, [r7, #-1396]!	; 0xfffffa8c
     478:	63506a72 	cmpvs	r0, #466944	; 0x72000
     47c:	6e617200 	cdpvs	2, 6, cr7, cr1, cr0, {0}
     480:	554e006b 	strbpl	r0, [lr, #-107]	; 0xffffff95
     484:	5f545241 	svcpl	0x00545241
     488:	64756142 	ldrbtvs	r6, [r5], #-322	; 0xfffffebe
     48c:	7461525f 	strbtvc	r5, [r1], #-607	; 0xfffffda1
     490:	46670065 	strbtmi	r0, [r7], -r5, rrx
     494:	72445f53 	subvc	r5, r4, #332	; 0x14c
     498:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     49c:	61480073 	hvcvs	32771	; 0x8003
     4a0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     4a4:	6f72505f 	svcvs	0x0072505f
     4a8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4ac:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     4b0:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     4b4:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     4b8:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     4bc:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     4c0:	006f666e 	rsbeq	r6, pc, lr, ror #12
     4c4:	52415554 	subpl	r5, r1, #84, 10	; 0x15000000
     4c8:	4f495f54 	svcmi	0x00495f54
     4cc:	5f6c7443 	svcpl	0x006c7443
     4d0:	61726150 	cmnvs	r2, r0, asr r1
     4d4:	6f00736d 	svcvs	0x0000736d
     4d8:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
     4dc:	74735f74 	ldrbtvc	r5, [r3], #-3956	; 0xfffff08c
     4e0:	00747261 	rsbseq	r7, r4, r1, ror #4
     4e4:	5f70614d 	svcpl	0x0070614d
     4e8:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     4ec:	5f6f545f 	svcpl	0x006f545f
     4f0:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     4f4:	00746e65 	rsbseq	r6, r4, r5, ror #28
     4f8:	626d6f5a 	rsbvs	r6, sp, #360	; 0x168
     4fc:	52006569 	andpl	r6, r0, #440401920	; 0x1a400000
     500:	61656c65 	cmnvs	r5, r5, ror #24
     504:	6e006573 	cfrshl64vs	mvdx0, mvdx3, r6
     508:	00747865 	rsbseq	r7, r4, r5, ror #16
     50c:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     510:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     514:	006d6574 	rsbeq	r6, sp, r4, ror r5
     518:	364e5a5f 			; <UNDEFINED> instruction: 0x364e5a5f
     51c:	66667542 	strbtvs	r7, [r6], -r2, asr #10
     520:	33317265 	teqcc	r1, #1342177286	; 0x50000006
     524:	44746547 	ldrbtmi	r6, [r4], #-1351	; 0xfffffab9
     528:	65666669 	strbvs	r6, [r6, #-1641]!	; 0xfffff997
     52c:	636e6572 	cmnvs	lr, #478150656	; 0x1c800000
     530:	00764565 	rsbseq	r4, r6, r5, ror #10
     534:	61766e49 	cmnvs	r6, r9, asr #28
     538:	5f64696c 	svcpl	0x0064696c
     53c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     540:	4200656c 	andmi	r6, r0, #108, 10	; 0x1b000000
     544:	32315f52 	eorscc	r5, r1, #328	; 0x148
     548:	70003030 	andvc	r3, r0, r0, lsr r0
     54c:	6c75706f 	ldclvs	0, cr7, [r5], #-444	; 0xfffffe44
     550:	6f697461 	svcvs	0x00697461
     554:	7552006e 	ldrbvc	r0, [r2, #-110]	; 0xffffff92
     558:	6e696e6e 	cdpvs	14, 6, cr6, cr9, cr14, {3}
     55c:	65440067 	strbvs	r0, [r4, #-103]	; 0xffffff99
     560:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     564:	555f656e 	ldrbpl	r6, [pc, #-1390]	; fffffffe <__bss_end+0xffff40f6>
     568:	6168636e 	cmnvs	r8, lr, ror #6
     56c:	6465676e 	strbtvs	r6, [r5], #-1902	; 0xfffff892
     570:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     574:	46433131 			; <UNDEFINED> instruction: 0x46433131
     578:	73656c69 	cmnvc	r5, #26880	; 0x6900
     57c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     580:	4930316d 	ldmdbmi	r0!, {r0, r2, r3, r5, r6, r8, ip, sp}
     584:	6974696e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, fp, sp, lr}^
     588:	7a696c61 	bvc	1a5b714 <__bss_end+0x1a4f80c>
     58c:	00764565 	rsbseq	r4, r6, r5, ror #10
     590:	756c6176 	strbvc	r6, [ip, #-374]!	; 0xfffffe8a
     594:	6d007365 	stcvs	3, cr7, [r0, #-404]	; 0xfffffe6c
     598:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     59c:	6e696f50 	mcrvs	15, 3, r6, cr9, cr0, {2}
     5a0:	65470074 	strbvs	r0, [r7, #-116]	; 0xffffff8c
     5a4:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     5a8:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     5ac:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     5b0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5b4:	50470073 	subpl	r0, r7, r3, ror r0
     5b8:	425f4f49 	subsmi	r4, pc, #292	; 0x124
     5bc:	00657361 	rsbeq	r7, r5, r1, ror #6
     5c0:	314e5a5f 	cmpcc	lr, pc, asr sl
     5c4:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     5c8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5cc:	614d5f73 	hvcvs	54771	; 0xd5f3
     5d0:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     5d4:	43343172 	teqmi	r4, #-2147483620	; 0x8000001c
     5d8:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
     5dc:	72505f65 	subsvc	r5, r0, #404	; 0x194
     5e0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     5e4:	68504573 	ldmdavs	r0, {r0, r1, r4, r5, r6, r8, sl, lr}^
     5e8:	5300626a 	movwpl	r6, #618	; 0x26a
     5ec:	505f7465 	subspl	r7, pc, r5, ror #8
     5f0:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     5f4:	5a5f0073 	bpl	17c07c8 <__bss_end+0x17b48c0>
     5f8:	7542364e 	strbvc	r3, [r2, #-1614]	; 0xfffff9b2
     5fc:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     600:	616c4335 	cmnvs	ip, r5, lsr r3
     604:	76456d69 	strbvc	r6, [r5], -r9, ror #26
     608:	65727000 	ldrbvs	r7, [r2, #-0]!
     60c:	5a5f0076 	bpl	17c07ec <__bss_end+0x17b48e4>
     610:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
     614:	6f725043 	svcvs	0x00725043
     618:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     61c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     620:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     624:	65473931 	strbvs	r3, [r7, #-2353]	; 0xfffff6cf
     628:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     62c:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     630:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     634:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     638:	00764573 	rsbseq	r4, r6, r3, ror r5
     63c:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
     640:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     644:	70660065 	rsbvc	r0, r6, r5, rrx
     648:	00737475 	rsbseq	r7, r3, r5, ror r4
     64c:	5f534654 	svcpl	0x00534654
     650:	65657254 	strbvs	r7, [r5, #-596]!	; 0xfffffdac
     654:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 65c <shift+0x65c>
     658:	5a5f0065 	bpl	17c07f4 <__bss_end+0x17b48ec>
     65c:	4332314e 	teqmi	r2, #-2147483629	; 0x80000013
     660:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     664:	70616548 	rsbvc	r6, r1, r8, asr #10
     668:	356e614d 	strbcc	r6, [lr, #-333]!	; 0xfffffeb3
     66c:	6f6c6c41 	svcvs	0x006c6c41
     670:	006a4563 	rsbeq	r4, sl, r3, ror #10
     674:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     678:	695f7265 	ldmdbvs	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     67c:	70007864 	andvc	r7, r0, r4, ror #16
     680:	6c75706f 	ldclvs	0, cr7, [r5], #-444	; 0xfffffe44
     684:	6f697461 	svcvs	0x00697461
     688:	5200736e 	andpl	r7, r0, #-1207959551	; 0xb8000001
     68c:	5f646165 	svcpl	0x00646165
     690:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
     694:	706e6900 	rsbvc	r6, lr, r0, lsl #18
     698:	655f7475 	ldrbvs	r7, [pc, #-1141]	; 22b <shift+0x22b>
     69c:	6d00646e 	cfstrsvs	mvf6, [r0, #-440]	; 0xfffffe48
     6a0:	7a695356 	bvc	1a55400 <__bss_end+0x1a494f8>
     6a4:	614d0065 	cmpvs	sp, r5, rrx
     6a8:	72505f78 	subsvc	r5, r0, #120, 30	; 0x1e0
     6ac:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     6b0:	704f5f73 	subvc	r5, pc, r3, ror pc	; <UNPREDICTABLE>
     6b4:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     6b8:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     6bc:	54007365 	strpl	r7, [r0], #-869	; 0xfffffc9b
     6c0:	5f555043 	svcpl	0x00555043
     6c4:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     6c8:	00747865 	rsbseq	r7, r4, r5, ror #16
     6cc:	314e5a5f 	cmpcc	lr, pc, asr sl
     6d0:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     6d4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     6d8:	614d5f73 	hvcvs	54771	; 0xd5f3
     6dc:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     6e0:	63533872 	cmpvs	r3, #7471104	; 0x720000
     6e4:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     6e8:	7645656c 	strbvc	r6, [r5], -ip, ror #10
     6ec:	746f4e00 	strbtvc	r4, [pc], #-3584	; 6f4 <shift+0x6f4>
     6f0:	41796669 	cmnmi	r9, r9, ror #12
     6f4:	42006c6c 	andmi	r6, r0, #108, 24	; 0x6c00
     6f8:	6b636f6c 	blvs	18dc4b0 <__bss_end+0x18d05a8>
     6fc:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     700:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     704:	6f72505f 	svcvs	0x0072505f
     708:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     70c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     710:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     714:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
     718:	5f323374 	svcpl	0x00323374
     71c:	69660074 	stmdbvs	r6!, {r2, r4, r5, r6}^
     720:	73656e74 	cmnvc	r5, #116, 28	; 0x740
     724:	52420073 	subpl	r0, r2, #115	; 0x73
     728:	3038345f 	eorscc	r3, r8, pc, asr r4
     72c:	5f740030 	svcpl	0x00740030
     730:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
     734:	76697000 	strbtvc	r7, [r9], -r0
     738:	4e00746f 	cdpmi	4, 0, cr7, cr0, cr15, {3}
     73c:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
     740:	704f5f6c 	subvc	r5, pc, ip, ror #30
     744:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     748:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     74c:	65646e69 	strbvs	r6, [r4, #-3689]!	; 0xfffff197
     750:	53420078 	movtpl	r0, #8312	; 0x2078
     754:	425f3143 	subsmi	r3, pc, #-1073741808	; 0xc0000010
     758:	00657361 	rsbeq	r7, r5, r1, ror #6
     75c:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     760:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
     764:	646e6172 	strbtvs	r6, [lr], #-370	; 0xfffffe8e
     768:	006a6a6a 	rsbeq	r6, sl, sl, ror #20
     76c:	7361544e 	cmnvc	r1, #1308622848	; 0x4e000000
     770:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     774:	00657461 	rsbeq	r7, r5, r1, ror #8
     778:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     77c:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     780:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     784:	6f6c4200 	svcvs	0x006c4200
     788:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     78c:	75436d00 	strbvc	r6, [r3, #-3328]	; 0xfffff300
     790:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     794:	61545f74 	cmpvs	r4, r4, ror pc
     798:	4e5f6b73 	vmovmi.s8	r6, d15[3]
     79c:	0065646f 	rsbeq	r6, r5, pc, ror #8
     7a0:	6b726273 	blvs	1c99174 <__bss_end+0x1c8d26c>
     7a4:	61684300 	cmnvs	r8, r0, lsl #6
     7a8:	00375f72 	eorseq	r5, r7, r2, ror pc
     7ac:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
     7b0:	7400385f 	strvc	r3, [r0], #-2143	; 0xfffff7a1
     7b4:	00656d69 	rsbeq	r6, r5, r9, ror #26
     7b8:	6f6f526d 	svcvs	0x006f526d
     7bc:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     7c0:	61520076 	cmpvs	r2, r6, ror r0
     7c4:	6d6f646e 	cfstrdvs	mvd6, [pc, #-440]!	; 614 <shift+0x614>
     7c8:	626d754e 	rsbvs	r7, sp, #327155712	; 0x13800000
     7cc:	65527265 	ldrbvs	r7, [r2, #-613]	; 0xfffffd9b
     7d0:	73657571 	cmnvc	r5, #473956352	; 0x1c400000
     7d4:	61500074 	cmpvs	r0, r4, ror r0
     7d8:	676e6967 	strbvs	r6, [lr, -r7, ror #18]!
     7dc:	6f6d654d 	svcvs	0x006d654d
     7e0:	69537972 	ldmdbvs	r3, {r1, r4, r5, r6, r8, fp, ip, sp, lr}^
     7e4:	6300657a 	movwvs	r6, #1402	; 0x57a
     7e8:	635f7570 	cmpvs	pc, #112, 10	; 0x1c000000
     7ec:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     7f0:	43007478 	movwmi	r7, #1144	; 0x478
     7f4:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
     7f8:	72505f65 	subsvc	r5, r0, #404	; 0x194
     7fc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     800:	52420073 	subpl	r0, r2, #115	; 0x73
     804:	3036395f 	eorscc	r3, r6, pc, asr r9
     808:	756f0030 	strbvc	r0, [pc, #-48]!	; 7e0 <shift+0x7e0>
     80c:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
     810:	646e655f 	strbtvs	r6, [lr], #-1375	; 0xfffffaa1
     814:	65704f00 	ldrbvs	r4, [r0, #-3840]!	; 0xfffff100
     818:	7369006e 	cmnvc	r9, #110	; 0x6e
     81c:	65726944 	ldrbvs	r6, [r2, #-2372]!	; 0xfffff6bc
     820:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
     824:	5a5f0079 	bpl	17c0a10 <__bss_end+0x17b4b08>
     828:	4332314e 	teqmi	r2, #-2147483629	; 0x80000013
     82c:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     830:	70616548 	rsbvc	r6, r1, r8, asr #10
     834:	346e614d 	strbtcc	r6, [lr], #-333	; 0xfffffeb3
     838:	6b726273 	blvs	1c9920c <__bss_end+0x1c8d304>
     83c:	00626a45 	rsbeq	r6, r2, r5, asr #20
     840:	46746547 	ldrbtmi	r6, [r4], -r7, asr #10
     844:	74737269 	ldrbtvc	r7, [r3], #-617	; 0xfffffd97
     848:	5077654e 	rsbspl	r6, r7, lr, asr #10
     84c:	00656761 	rsbeq	r6, r5, r1, ror #14
     850:	656d6954 	strbvs	r6, [sp, #-2388]!	; 0xfffff6ac
     854:	61425f72 	hvcvs	9714	; 0x25f2
     858:	70006573 	andvc	r6, r0, r3, ror r5
     85c:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     860:	46670078 			; <UNDEFINED> instruction: 0x46670078
     864:	72445f53 	subvc	r5, r4, #332	; 0x14c
     868:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     86c:	6f435f73 	svcvs	0x00435f73
     870:	00746e75 	rsbseq	r6, r4, r5, ror lr
     874:	6c6c7550 	cfstr64vs	mvdx7, [ip], #-320	; 0xfffffec0
     878:	72615000 	rsbvc	r5, r1, #0
     87c:	69746974 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     880:	70006e6f 	andvc	r6, r0, pc, ror #28
     884:	72676f72 	rsbvc	r6, r7, #456	; 0x1c8
     888:	5f006d61 	svcpl	0x00006d61
     88c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     890:	6f725043 	svcvs	0x00725043
     894:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     898:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     89c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     8a0:	69775339 	ldmdbvs	r7!, {r0, r3, r4, r5, r8, r9, ip, lr}^
     8a4:	5f686374 	svcpl	0x00686374
     8a8:	50456f54 	subpl	r6, r5, r4, asr pc
     8ac:	50433831 	subpl	r3, r3, r1, lsr r8
     8b0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     8b4:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     8b8:	5f747369 	svcpl	0x00747369
     8bc:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     8c0:	65726600 	ldrbvs	r6, [r2, #-1536]!	; 0xfffffa00
     8c4:	5a5f0065 	bpl	17c0a60 <__bss_end+0x17b4b58>
     8c8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     8cc:	636f7250 	cmnvs	pc, #80, 4
     8d0:	5f737365 	svcpl	0x00737365
     8d4:	616e614d 	cmnvs	lr, sp, asr #2
     8d8:	31726567 	cmncc	r2, r7, ror #10
     8dc:	746f4e34 	strbtvc	r4, [pc], #-3636	; 8e4 <shift+0x8e4>
     8e0:	5f796669 	svcpl	0x00796669
     8e4:	636f7250 	cmnvs	pc, #80, 4
     8e8:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     8ec:	54323150 	ldrtpl	r3, [r2], #-336	; 0xfffffeb0
     8f0:	6b736154 	blvs	1cd8e48 <__bss_end+0x1cccf40>
     8f4:	7274535f 	rsbsvc	r5, r4, #2080374785	; 0x7c000001
     8f8:	00746375 	rsbseq	r6, r4, r5, ror r3
     8fc:	5f746547 	svcpl	0x00746547
     900:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     904:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     908:	49006f66 	stmdbmi	r0, {r1, r2, r5, r6, r8, r9, sl, fp, sp, lr}
     90c:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     910:	616c4300 	cmnvs	ip, r0, lsl #6
     914:	70006d69 	andvc	r6, r0, r9, ror #26
     918:	746e6972 	strbtvc	r6, [lr], #-2418	; 0xfffff68e
     91c:	6f6c665f 	svcvs	0x006c665f
     920:	765f7461 	ldrbvc	r7, [pc], -r1, ror #8
     924:	65756c61 	ldrbvs	r6, [r5, #-3169]!	; 0xfffff39f
     928:	6e696c5f 	mcrvs	12, 3, r6, cr9, cr15, {2}
     92c:	682f0065 	stmdavs	pc!, {r0, r2, r5, r6}	; <UNPREDICTABLE>
     930:	2f656d6f 	svccs	0x00656d6f
     934:	746e6968 	strbtvc	r6, [lr], #-2408	; 0xfffff698
     938:	642f6b69 	strtvs	r6, [pc], #-2921	; 940 <shift+0x940>
     93c:	662f7665 	strtvs	r7, [pc], -r5, ror #12
     940:	6c616e69 	stclvs	14, cr6, [r1], #-420	; 0xfffffe5c
     944:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     948:	756f732f 	strbvc	r7, [pc, #-815]!	; 621 <shift+0x621>
     94c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     950:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     954:	61707372 	cmnvs	r0, r2, ror r3
     958:	752f6563 	strvc	r6, [pc, #-1379]!	; 3fd <shift+0x3fd>
     95c:	5f726573 	svcpl	0x00726573
     960:	6b736174 	blvs	1cd8f38 <__bss_end+0x1ccd030>
     964:	69616d2f 	stmdbvs	r1!, {r0, r1, r2, r3, r5, r8, sl, fp, sp, lr}^
     968:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     96c:	65520070 	ldrbvs	r0, [r2, #-112]	; 0xffffff90
     970:	54006461 	strpl	r6, [r0], #-1121	; 0xfffffb9f
     974:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     978:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     97c:	6e617200 	cdpvs	2, 6, cr7, cr1, cr0, {0}
     980:	75520064 	ldrbvc	r0, [r2, #-100]	; 0xffffff9c
     984:	62616e6e 	rsbvs	r6, r1, #1760	; 0x6e0
     988:	4e00656c 	cfsh32mi	mvfx6, mvfx0, #60
     98c:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     990:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     994:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     998:	5a5f0073 	bpl	17c0b6c <__bss_end+0x17b4c64>
     99c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     9a0:	636f7250 	cmnvs	pc, #80, 4
     9a4:	5f737365 	svcpl	0x00737365
     9a8:	616e614d 	cmnvs	lr, sp, asr #2
     9ac:	43726567 	cmnmi	r2, #432013312	; 0x19c00000
     9b0:	00764534 	rsbseq	r4, r6, r4, lsr r5
     9b4:	69617761 	stmdbvs	r1!, {r0, r5, r6, r8, r9, sl, ip, sp, lr}^
     9b8:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
     9bc:	00747570 	rsbseq	r7, r4, r0, ror r5
     9c0:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
     9c4:	6d00676e 	stcvs	7, cr6, [r0, #-440]	; 0xfffffe48
     9c8:	746f6f52 	strbtvc	r6, [pc], #-3922	; 9d0 <shift+0x9d0>
     9cc:	746e4d5f 	strbtvc	r4, [lr], #-3423	; 0xfffff2a1
     9d0:	67615000 	strbvs	r5, [r1, -r0]!
     9d4:	7a695365 	bvc	1a55770 <__bss_end+0x1a49868>
     9d8:	6f4c0065 	svcvs	0x004c0065
     9dc:	6d654d77 	stclvs	13, cr4, [r5, #-476]!	; 0xfffffe24
     9e0:	0079726f 	rsbseq	r7, r9, pc, ror #4
     9e4:	73345a5f 	teqvc	r4, #389120	; 0x5f000
     9e8:	50706177 	rsbspl	r6, r0, r7, ror r1
     9ec:	61503031 	cmpvs	r0, r1, lsr r0
     9f0:	656d6172 	strbvs	r6, [sp, #-370]!	; 0xfffffe8e
     9f4:	73726574 	cmnvc	r2, #116, 10	; 0x1d000000
     9f8:	4e006969 	vmlsmi.f16	s12, s0, s19	; <UNPREDICTABLE>
     9fc:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     a00:	72640079 	rsbvc	r0, r4, #121	; 0x79
     a04:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     a08:	6c436d00 	mcrrvs	13, 0, r6, r3, cr0
     a0c:	656d6961 	strbvs	r6, [sp, #-2401]!	; 0xfffff69f
     a10:	5a5f0064 	bpl	17c0ba8 <__bss_end+0x17b4ca0>
     a14:	72703032 	rsbsvc	r3, r0, #50	; 0x32
     a18:	5f746e69 	svcpl	0x00746e69
     a1c:	5f746e69 	svcpl	0x00746e69
     a20:	756c6176 	strbvc	r6, [ip, #-374]!	; 0xfffffe8a
     a24:	696c5f65 	stmdbvs	ip!, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     a28:	506a656e 	rsbpl	r6, sl, lr, ror #10
     a2c:	5369634b 	cmnpl	r9, #738197505	; 0x2c000001
     a30:	5f005f30 	svcpl	0x00005f30
     a34:	7551395a 	ldrbvc	r3, [r1, #-2394]	; 0xfffff6a6
     a38:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
     a3c:	5074726f 	rsbspl	r7, r4, pc, ror #4
     a40:	61503031 	cmpvs	r0, r1, lsr r0
     a44:	656d6172 	strbvs	r6, [sp, #-370]!	; 0xfffffe8e
     a48:	73726574 	cmnvc	r2, #116, 10	; 0x1d000000
     a4c:	42006969 	andmi	r6, r0, #1720320	; 0x1a4000
     a50:	45464655 	strbmi	r4, [r6, #-1621]	; 0xfffff9ab
     a54:	49535f52 	ldmdbmi	r3, {r1, r4, r6, r8, r9, sl, fp, ip, lr}^
     a58:	4200455a 	andmi	r4, r0, #377487360	; 0x16800000
     a5c:	34325f52 	ldrtcc	r5, [r2], #-3922	; 0xfffff0ae
     a60:	72003030 	andvc	r3, r0, #48	; 0x30
     a64:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     a68:	61765f74 	cmnvs	r6, r4, ror pc
     a6c:	0065756c 	rsbeq	r7, r5, ip, ror #10
     a70:	5078614d 	rsbspl	r6, r8, sp, asr #2
     a74:	4c687461 	cfstrdmi	mvd7, [r8], #-388	; 0xfffffe7c
     a78:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     a7c:	77730068 	ldrbvc	r0, [r3, -r8, rrx]!
     a80:	5f007061 	svcpl	0x00007061
     a84:	30314e5a 	eorscc	r4, r1, sl, asr lr
     a88:	61726150 	cmnvs	r2, r0, asr r1
     a8c:	6574656d 	ldrbvs	r6, [r4, #-1389]!	; 0xfffffa93
     a90:	66377372 			; <UNDEFINED> instruction: 0x66377372
     a94:	656e7469 	strbvs	r7, [lr, #-1129]!	; 0xfffffb97
     a98:	64457373 	strbvs	r7, [r5], #-883	; 0xfffffc8d
     a9c:	614d0064 	cmpvs	sp, r4, rrx
     aa0:	44534678 	ldrbmi	r4, [r3], #-1656	; 0xfffff988
     aa4:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     aa8:	6d614e72 	stclvs	14, cr4, [r1, #-456]!	; 0xfffffe38
     aac:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     ab0:	00687467 	rsbeq	r7, r8, r7, ror #8
     ab4:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
     ab8:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
     abc:	72656765 	rsbvc	r6, r5, #26476544	; 0x1940000
     ac0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     ac4:	50433631 	subpl	r3, r3, r1, lsr r6
     ac8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     acc:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 908 <shift+0x908>
     ad0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     ad4:	31317265 	teqcc	r1, r5, ror #4
     ad8:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     adc:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     ae0:	4552525f 	ldrbmi	r5, [r2, #-607]	; 0xfffffda1
     ae4:	474e0076 	smlsldxmi	r0, lr, r6, r0
     ae8:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     aec:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     af0:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     af4:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     af8:	73006570 	movwvc	r6, #1392	; 0x570
     afc:	7065656c 	rsbvc	r6, r5, ip, ror #10
     b00:	6d69745f 	cfstrdvs	mvd7, [r9, #-380]!	; 0xfffffe84
     b04:	47007265 	strmi	r7, [r0, -r5, ror #4]
     b08:	5f4f4950 	svcpl	0x004f4950
     b0c:	5f6e6950 	svcpl	0x006e6950
     b10:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     b14:	61740074 	cmnvs	r4, r4, ror r0
     b18:	5f006b73 	svcpl	0x00006b73
     b1c:	6a616e5a 	bvs	185c48c <__bss_end+0x1850584>
     b20:	6f6f6200 	svcvs	0x006f6200
     b24:	5a5f006c 	bpl	17c0cdc <__bss_end+0x17b4dd4>
     b28:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     b2c:	636f7250 	cmnvs	pc, #80, 4
     b30:	5f737365 	svcpl	0x00737365
     b34:	616e614d 	cmnvs	lr, sp, asr #2
     b38:	31726567 	cmncc	r2, r7, ror #10
     b3c:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     b40:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     b44:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     b48:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     b4c:	456f666e 	strbmi	r6, [pc, #-1646]!	; 4e6 <shift+0x4e6>
     b50:	474e3032 	smlaldxmi	r3, lr, r2, r0
     b54:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     b58:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     b5c:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     b60:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     b64:	76506570 			; <UNDEFINED> instruction: 0x76506570
     b68:	75426d00 	strbvc	r6, [r2, #-3328]	; 0xfffff300
     b6c:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     b70:	4e525400 	cdpmi	4, 5, cr5, cr2, cr0, {0}
     b74:	61425f47 	cmpvs	r2, r7, asr #30
     b78:	44006573 	strmi	r6, [r0], #-1395	; 0xfffffa8d
     b7c:	75616665 	strbvc	r6, [r1, #-1637]!	; 0xfffff99b
     b80:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
     b84:	6b636f6c 	blvs	18dc93c <__bss_end+0x18d0a34>
     b88:	7461525f 	strbtvc	r5, [r1], #-607	; 0xfffffda1
     b8c:	526d0065 	rsbpl	r0, sp, #101	; 0x65
     b90:	5f746f6f 	svcpl	0x00746f6f
     b94:	00737953 	rsbseq	r7, r3, r3, asr r9
     b98:	706f6c73 	rsbvc	r6, pc, r3, ror ip	; <UNPREDICTABLE>
     b9c:	536d0065 	cmnpl	sp, #101	; 0x65
     ba0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     ba4:	5f656c75 	svcpl	0x00656c75
     ba8:	00636e46 	rsbeq	r6, r3, r6, asr #28
     bac:	50395a5f 	eorspl	r5, r9, pc, asr sl
     bb0:	69747261 	ldmdbvs	r4!, {r0, r5, r6, r9, ip, sp, lr}^
     bb4:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     bb8:	50303150 	eorspl	r3, r0, r0, asr r1
     bbc:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     bc0:	72657465 	rsbvc	r7, r5, #1694498816	; 0x65000000
     bc4:	00696973 	rsbeq	r6, r9, r3, ror r9
     bc8:	314e5a5f 	cmpcc	lr, pc, asr sl
     bcc:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     bd0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     bd4:	614d5f73 	hvcvs	54771	; 0xd5f3
     bd8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     bdc:	42313272 	eorsmi	r3, r1, #536870919	; 0x20000007
     be0:	6b636f6c 	blvs	18dc998 <__bss_end+0x18d0a90>
     be4:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     be8:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     bec:	6f72505f 	svcvs	0x0072505f
     bf0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     bf4:	5f007645 	svcpl	0x00007645
     bf8:	7270375a 	rsbsvc	r3, r0, #23592960	; 0x1680000
     bfc:	6172676f 	cmnvs	r2, pc, ror #14
     c00:	42006a6d 	andmi	r6, r0, #446464	; 0x6d000
     c04:	39315f52 	ldmdbcc	r1!, {r1, r4, r6, r8, r9, sl, fp, ip, lr}
     c08:	00303032 	eorseq	r3, r0, r2, lsr r0
     c0c:	6b636f4c 	blvs	18dc944 <__bss_end+0x18d0a3c>
     c10:	6c6e555f 	cfstr64vs	mvdx5, [lr], #-380	; 0xfffffe84
     c14:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     c18:	4c6d0064 	stclmi	0, cr0, [sp], #-400	; 0xfffffe70
     c1c:	5f747361 	svcpl	0x00747361
     c20:	00444950 	subeq	r4, r4, r0, asr r9
     c24:	7269466d 	rsbvc	r4, r9, #114294784	; 0x6d00000
     c28:	5f007473 	svcpl	0x00007473
     c2c:	31314e5a 	teqcc	r1, sl, asr lr
     c30:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     c34:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     c38:	346d6574 	strbtcc	r6, [sp], #-1396	; 0xfffffa8c
     c3c:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     c40:	634b5045 	movtvs	r5, #45125	; 0xb045
     c44:	464e3531 			; <UNDEFINED> instruction: 0x464e3531
     c48:	5f656c69 	svcpl	0x00656c69
     c4c:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     c50:	646f4d5f 	strbtvs	r4, [pc], #-3423	; c58 <shift+0xc58>
     c54:	77530065 	ldrbvc	r0, [r3, -r5, rrx]
     c58:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     c5c:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
     c60:	736f6c43 	cmnvc	pc, #17152	; 0x4300
     c64:	5a5f0065 	bpl	17c0e00 <__bss_end+0x17b4ef8>
     c68:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     c6c:	636f7250 	cmnvs	pc, #80, 4
     c70:	5f737365 	svcpl	0x00737365
     c74:	616e614d 	cmnvs	lr, sp, asr #2
     c78:	31726567 	cmncc	r2, r7, ror #10
     c7c:	68635332 	stmdavs	r3!, {r1, r4, r5, r8, r9, ip, lr}^
     c80:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     c84:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     c88:	00764546 	rsbseq	r4, r6, r6, asr #10
     c8c:	30435342 	subcc	r5, r3, r2, asr #6
     c90:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     c94:	52420065 	subpl	r0, r2, #101	; 0x65
     c98:	3637355f 			; <UNDEFINED> instruction: 0x3637355f
     c9c:	6d003030 	stcvs	0, cr3, [r0, #-192]	; 0xffffff40
     ca0:	657a6953 	ldrbvs	r6, [sl, #-2387]!	; 0xfffff6ad
     ca4:	66757300 	ldrbtvs	r7, [r5], -r0, lsl #6
     ca8:	00786966 	rsbseq	r6, r8, r6, ror #18
     cac:	63677261 	cmnvs	r7, #268435462	; 0x10000006
     cb0:	65676600 	strbvs	r6, [r7, #-1536]!	; 0xfffffa00
     cb4:	6d007374 	stcvs	3, cr7, [r0, #-464]	; 0xfffffe30
     cb8:	6c6c7550 	cfstr64vs	mvdx7, [ip], #-320	; 0xfffffec0
     cbc:	00727450 	rsbseq	r7, r2, r0, asr r4
     cc0:	32315a5f 	eorscc	r5, r1, #389120	; 0x5f000
     cc4:	6e697270 	mcrvs	2, 3, r7, cr9, cr0, {3}
     cc8:	61705f74 	cmnvs	r0, r4, ror pc
     ccc:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     cd0:	5030316a 	eorspl	r3, r0, sl, ror #2
     cd4:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     cd8:	72657465 	rsbvc	r7, r5, #1694498816	; 0x65000000
     cdc:	00635073 	rsbeq	r5, r3, r3, ror r0
     ce0:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     ce4:	64656966 	strbtvs	r6, [r5], #-2406	; 0xfffff69a
     ce8:	6165645f 	cmnvs	r5, pc, asr r4
     cec:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     cf0:	5a5f0065 	bpl	17c0e8c <__bss_end+0x17b4f84>
     cf4:	72703232 	rsbsvc	r3, r0, #536870915	; 0x20000003
     cf8:	5f746e69 	svcpl	0x00746e69
     cfc:	616f6c66 	cmnvs	pc, r6, ror #24
     d00:	61765f74 	cmnvs	r6, r4, ror pc
     d04:	5f65756c 	svcpl	0x0065756c
     d08:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     d0c:	634b506a 	movtvs	r5, #45162	; 0xb06a
     d10:	5f305366 	svcpl	0x00305366
     d14:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     d18:	52420076 	subpl	r0, r2, #118	; 0x76
     d1c:	3438335f 	ldrtcc	r3, [r8], #-863	; 0xfffffca1
     d20:	62003030 	andvs	r3, r0, #48	; 0x30
     d24:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     d28:	6f635f72 	svcvs	0x00635f72
     d2c:	6174736e 	cmnvs	r4, lr, ror #6
     d30:	0073746e 	rsbseq	r7, r3, lr, ror #8
     d34:	65645f74 	strbvs	r5, [r4, #-3956]!	; 0xfffff08c
     d38:	0061746c 	rsbeq	r7, r1, ip, ror #8
     d3c:	314e5a5f 	cmpcc	lr, pc, asr sl
     d40:	69464331 	stmdbvs	r6, {r0, r4, r5, r8, r9, lr}^
     d44:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     d48:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     d4c:	76453443 	strbvc	r3, [r5], -r3, asr #8
     d50:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     d54:	55433231 	strbpl	r3, [r3, #-561]	; 0xfffffdcf
     d58:	48726573 	ldmdami	r2!, {r0, r1, r4, r5, r6, r8, sl, sp, lr}^
     d5c:	4d706165 	ldfmie	f6, [r0, #-404]!	; 0xfffffe6c
     d60:	30316e61 	eorscc	r6, r1, r1, ror #28
     d64:	4e746547 	cdpmi	5, 7, cr6, cr4, cr7, {2}
     d68:	61507765 	cmpvs	r0, r5, ror #14
     d6c:	6a456567 	bvs	115a310 <__bss_end+0x114e408>
     d70:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     d74:	50433631 	subpl	r3, r3, r1, lsr r6
     d78:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     d7c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; bb8 <shift+0xbb8>
     d80:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     d84:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     d88:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     d8c:	505f7966 	subspl	r7, pc, r6, ror #18
     d90:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     d94:	6a457373 	bvs	115db68 <__bss_end+0x1151c60>
     d98:	466f4e00 	strbtmi	r4, [pc], -r0, lsl #28
     d9c:	73656c69 	cmnvc	r5, #26880	; 0x6900
     da0:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     da4:	6972446d 	ldmdbvs	r2!, {r0, r2, r3, r5, r6, sl, lr}^
     da8:	00726576 	rsbseq	r6, r2, r6, ror r5
     dac:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
     db0:	6f6c665f 	svcvs	0x006c665f
     db4:	5f007461 	svcpl	0x00007461
     db8:	6261335a 	rsbvs	r3, r1, #1744830465	; 0x68000001
     dbc:	44006473 	strmi	r6, [r0], #-1139	; 0xfffffb8d
     dc0:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     dc4:	00656e69 	rsbeq	r6, r5, r9, ror #28
     dc8:	65726170 	ldrbvs	r6, [r2, #-368]!	; 0xfffffe90
     dcc:	4400746e 	strmi	r7, [r0], #-1134	; 0xfffffb92
     dd0:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     dd4:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 870 <shift+0x870>
     dd8:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     ddc:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     de0:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     de4:	73006e6f 	movwvc	r6, #3695	; 0xe6f
     de8:	74726f68 	ldrbtvc	r6, [r2], #-3944	; 0xfffff098
     dec:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     df0:	70545000 	subsvc	r5, r4, r0
     df4:	4d007274 	sfmmi	f7, 4, [r0, #-464]	; 0xfffffe30
     df8:	69467861 	stmdbvs	r6, {r0, r5, r6, fp, ip, sp, lr}^
     dfc:	616e656c 	cmnvs	lr, ip, ror #10
     e00:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     e04:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     e08:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     e0c:	66754236 			; <UNDEFINED> instruction: 0x66754236
     e10:	34726566 	ldrbtcc	r6, [r2], #-1382	; 0xfffffa9a
     e14:	68737550 	ldmdavs	r3!, {r4, r6, r8, sl, ip, sp, lr}^
     e18:	6d006345 	stcvs	3, cr6, [r0, #-276]	; 0xfffffeec
     e1c:	746f6f52 	strbtvc	r6, [pc], #-3922	; e24 <shift+0xe24>
     e20:	315a5f00 	cmpcc	sl, r0, lsl #30
     e24:	61776131 	cmnvs	r7, r1, lsr r1
     e28:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     e2c:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
     e30:	0063506a 	rsbeq	r5, r3, sl, rrx
     e34:	364e5a5f 			; <UNDEFINED> instruction: 0x364e5a5f
     e38:	66667542 	strbtvs	r7, [r6], -r2, asr #10
     e3c:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
     e40:	6d007645 	stcvs	6, cr7, [r0, #-276]	; 0xfffffeec
     e44:	6b617242 	blvs	185d754 <__bss_end+0x185184c>
     e48:	50430065 	subpl	r0, r3, r5, rrx
     e4c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     e50:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; c8c <shift+0xc8c>
     e54:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     e58:	43007265 	movwmi	r7, #613	; 0x265
     e5c:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
     e60:	70616548 	rsbvc	r6, r1, r8, asr #10
     e64:	006e614d 	rsbeq	r6, lr, sp, asr #2
     e68:	6e697270 	mcrvs	2, 3, r7, cr9, cr0, {3}
     e6c:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
     e70:	61765f74 	cmnvs	r6, r4, ror pc
     e74:	5f65756c 	svcpl	0x0065756c
     e78:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     e7c:	6c6c4100 	stfvse	f4, [ip], #-0
     e80:	6900636f 	stmdbvs	r0, {r0, r1, r2, r3, r5, r6, r8, r9, sp, lr}
     e84:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
     e88:	6174735f 	cmnvs	r4, pc, asr r3
     e8c:	73007472 	movwvc	r7, #1138	; 0x472
     e90:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     e94:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     e98:	70006d65 	andvc	r6, r0, r5, ror #26
     e9c:	746e6972 	strbtvc	r6, [lr], #-2418	; 0xfffff68e
     ea0:	7261705f 	rsbvc	r7, r1, #95	; 0x5f
     ea4:	00736d61 	rsbseq	r6, r3, r1, ror #26
     ea8:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
     eac:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     eb0:	5f00657a 	svcpl	0x0000657a
     eb4:	42364e5a 	eorsmi	r4, r6, #1440	; 0x5a0
     eb8:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     ebc:	75503472 	ldrbvc	r3, [r0, #-1138]	; 0xfffffb8e
     ec0:	76456c6c 	strbvc	r6, [r5], -ip, ror #24
     ec4:	6e694600 	cdpvs	6, 6, cr4, cr9, cr0, {0}
     ec8:	68435f64 	stmdavs	r3, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     ecc:	00646c69 	rsbeq	r6, r4, r9, ror #24
     ed0:	72627474 	rsbvc	r7, r2, #116, 8	; 0x74000000
     ed4:	4f530030 	svcmi	0x00530030
     ed8:	4954554c 	ldmdbmi	r4, {r2, r3, r6, r8, sl, ip, lr}^
     edc:	535f4e4f 	cmppl	pc, #1264	; 0x4f0
     ee0:	00455a49 	subeq	r5, r5, r9, asr #20
     ee4:	75706e69 	ldrbvc	r6, [r0, #-3689]!	; 0xfffff197
     ee8:	75625f74 	strbvc	r5, [r2, #-3956]!	; 0xfffff08c
     eec:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     ef0:	67615000 	strbvs	r5, [r1, -r0]!
     ef4:	756f4365 	strbvc	r4, [pc, #-869]!	; b97 <shift+0xb97>
     ef8:	4e00746e 	cdpmi	4, 0, cr7, cr0, cr14, {3}
     efc:	5f495753 	svcpl	0x00495753
     f00:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     f04:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     f08:	535f6d65 	cmppl	pc, #6464	; 0x1940
     f0c:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     f10:	4e006563 	cfsh32mi	mvfx6, mvfx0, #51
     f14:	5f495753 	svcpl	0x00495753
     f18:	636f7250 	cmnvs	pc, #80, 4
     f1c:	5f737365 	svcpl	0x00737365
     f20:	76726553 			; <UNDEFINED> instruction: 0x76726553
     f24:	00656369 	rsbeq	r6, r5, r9, ror #6
     f28:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
     f2c:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
     f30:	73656c69 	cmnvc	r5, #26880	; 0x6900
     f34:	65695900 	strbvs	r5, [r9, #-2304]!	; 0xfffff700
     f38:	4900646c 	stmdbmi	r0, {r2, r3, r5, r6, sl, sp, lr}
     f3c:	6665646e 	strbtvs	r6, [r5], -lr, ror #8
     f40:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     f44:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     f48:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     f4c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     f50:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     f54:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     f58:	616e4500 	cmnvs	lr, r0, lsl #10
     f5c:	5f656c62 	svcpl	0x00656c62
     f60:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     f64:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     f68:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     f6c:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     f70:	6f72506d 	svcvs	0x0072506d
     f74:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     f78:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     f7c:	65485f74 	strbvs	r5, [r8, #-3956]	; 0xfffff08c
     f80:	50006461 	andpl	r6, r0, r1, ror #8
     f84:	70697265 	rsbvc	r7, r9, r5, ror #4
     f88:	61726568 	cmnvs	r2, r8, ror #10
     f8c:	61425f6c 	cmpvs	r2, ip, ror #30
     f90:	50006573 	andpl	r6, r0, r3, ror r5
     f94:	00687375 	rsbeq	r7, r8, r5, ror r3
     f98:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
     f9c:	6e656c5f 	mcrvs	12, 3, r6, cr5, cr15, {2}
     fa0:	00687467 	rsbeq	r7, r8, r7, ror #8
     fa4:	68676948 	stmdavs	r7!, {r3, r6, r8, fp, sp, lr}^
     fa8:	6f6d654d 	svcvs	0x006d654d
     fac:	61007972 	tstvs	r0, r2, ror r9
     fb0:	65726464 	ldrbvs	r6, [r2, #-1124]!	; 0xfffffb9c
     fb4:	47007373 	smlsdxmi	r0, r3, r3, r7
     fb8:	654e7465 	strbvs	r7, [lr, #-1125]	; 0xfffffb9b
     fbc:	67615077 			; <UNDEFINED> instruction: 0x67615077
     fc0:	6f4c0065 	svcvs	0x004c0065
     fc4:	4c5f6b63 	mrrcmi	11, 6, r6, pc, cr3	; <UNPREDICTABLE>
     fc8:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     fcc:	654d0064 	strbvs	r0, [sp, #-100]	; 0xffffff9c
     fd0:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     fd4:	74726956 	ldrbtvc	r6, [r2], #-2390	; 0xfffff6aa
     fd8:	426c6175 	rsbmi	r6, ip, #1073741853	; 0x4000001d
     fdc:	00657361 	rsbeq	r7, r5, r1, ror #6
     fe0:	31736f70 	cmncc	r3, r0, ror pc
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
    1024:	6a6a6a65 	bvs	1a9b9c0 <__bss_end+0x1a8fab8>
    1028:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
    102c:	5f495753 	svcpl	0x00495753
    1030:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
    1034:	5f00746c 	svcpl	0x0000746c
    1038:	30314e5a 	eorscc	r4, r1, sl, asr lr
    103c:	61726150 	cmnvs	r2, r0, asr r1
    1040:	6574656d 	ldrbvs	r6, [r4, #-1389]!	; 0xfffffa93
    1044:	62327372 	eorsvs	r7, r2, #-939524095	; 0xc8000001
    1048:	00644574 	rsbeq	r4, r4, r4, ror r5
    104c:	706d6173 	rsbvc	r6, sp, r3, ror r1
    1050:	5500656c 	strpl	r6, [r0, #-1388]	; 0xfffffa94
    1054:	65676150 	strbvs	r6, [r7, #-336]!	; 0xfffffeb0
    1058:	315a5f00 	cmpcc	sl, r0, lsl #30
    105c:	61657230 	cmnvs	r5, r0, lsr r2
    1060:	6c665f64 	stclvs	15, cr5, [r6], #-400	; 0xfffffe70
    1064:	6a74616f 	bvs	1d19628 <__bss_end+0x1d0d720>
    1068:	73006350 	movwvc	r6, #848	; 0x350
    106c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    1070:	756f635f 	strbvc	r6, [pc, #-863]!	; d19 <shift+0xd19>
    1074:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    1078:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    107c:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
    1080:	00736d61 	rsbseq	r6, r3, r1, ror #26
    1084:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
    1088:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
    108c:	61686320 	cmnvs	r8, r0, lsr #6
    1090:	6e690072 	mcrvs	0, 3, r0, cr9, cr2, {3}
    1094:	5f747570 	svcpl	0x00747570
    1098:	657a6973 	ldrbvs	r6, [sl, #-2419]!	; 0xfffff68d
    109c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    10a0:	55433231 	strbpl	r3, [r3, #-561]	; 0xfffffdcf
    10a4:	48726573 	ldmdami	r2!, {r0, r1, r4, r5, r6, r8, sl, sp, lr}^
    10a8:	4d706165 	ldfmie	f6, [r0, #-404]!	; 0xfffffe6c
    10ac:	34436e61 	strbcc	r6, [r3], #-3681	; 0xfffff19f
    10b0:	49007645 	stmdbmi	r0, {r0, r2, r6, r9, sl, ip, sp, lr}
    10b4:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    10b8:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
    10bc:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    10c0:	656c535f 	strbvs	r5, [ip, #-863]!	; 0xfffffca1
    10c4:	53007065 	movwpl	r7, #101	; 0x65
    10c8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    10cc:	5f656c75 	svcpl	0x00656c75
    10d0:	41005252 	tstmi	r0, r2, asr r2
    10d4:	425f5855 	subsmi	r5, pc, #5570560	; 0x550000
    10d8:	00657361 	rsbeq	r7, r5, r1, ror #6
    10dc:	7375506d 	cmnvc	r5, #109	; 0x6d
    10e0:	72745068 	rsbsvc	r5, r4, #104	; 0x68
    10e4:	43534200 	cmpmi	r3, #0, 4
    10e8:	61425f32 	cmpvs	r2, r2, lsr pc
    10ec:	57006573 	smlsdxpl	r0, r3, r5, r6
    10f0:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    10f4:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
    10f8:	63530079 	cmpvs	r3, #121	; 0x79
    10fc:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
    1100:	5f00656c 	svcpl	0x0000656c
    1104:	32314e5a 	eorscc	r4, r1, #1440	; 0x5a0
    1108:	65735543 	ldrbvs	r5, [r3, #-1347]!	; 0xfffffabd
    110c:	61654872 	smcvs	21634	; 0x5482
    1110:	6e614d70 	mcrvs	13, 3, r4, cr1, cr0, {3}
    1114:	65473531 	strbvs	r3, [r7, #-1329]	; 0xfffffacf
    1118:	72694674 	rsbvc	r4, r9, #116, 12	; 0x7400000
    111c:	654e7473 	strbvs	r7, [lr, #-1139]	; 0xfffffb8d
    1120:	67615077 			; <UNDEFINED> instruction: 0x67615077
    1124:	006a4565 	rsbeq	r4, sl, r5, ror #10
    1128:	6b636954 	blvs	18db680 <__bss_end+0x18cf778>
    112c:	756f435f 	strbvc	r4, [pc, #-863]!	; dd5 <shift+0xdd5>
    1130:	5f00746e 	svcpl	0x0000746e
    1134:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1138:	6f725043 	svcvs	0x00725043
    113c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1140:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1144:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1148:	6e553831 	mrcvs	8, 2, r3, cr5, cr1, {1}
    114c:	5f70616d 	svcpl	0x0070616d
    1150:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1154:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
    1158:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    115c:	49006a45 	stmdbmi	r0, {r0, r2, r6, r9, fp, sp, lr}
    1160:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1164:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    1168:	445f6d65 	ldrbmi	r6, [pc], #-3429	; 1170 <shift+0x1170>
    116c:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
    1170:	706f0072 	rsbvc	r0, pc, r2, ror r0	; <UNPREDICTABLE>
    1174:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
    1178:	6e20726f 	cdpvs	2, 2, cr7, cr0, cr15, {3}
    117c:	5b207765 	blpl	81ef18 <__bss_end+0x813010>
    1180:	5a5f005d 	bpl	17c12fc <__bss_end+0x17b53f4>
    1184:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
    1188:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    118c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    1190:	33316d65 	teqcc	r1, #6464	; 0x1940
    1194:	5f534654 	svcpl	0x00534654
    1198:	65657254 	strbvs	r7, [r5, #-596]!	; 0xfffffdac
    119c:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 11a4 <shift+0x11a4>
    11a0:	46303165 	ldrtmi	r3, [r0], -r5, ror #2
    11a4:	5f646e69 	svcpl	0x00646e69
    11a8:	6c696843 	stclvs	8, cr6, [r9], #-268	; 0xfffffef4
    11ac:	4b504564 	blmi	1412744 <__bss_end+0x140683c>
    11b0:	61480063 	cmpvs	r8, r3, rrx
    11b4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    11b8:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
    11bc:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    11c0:	5f6d6574 	svcpl	0x006d6574
    11c4:	00495753 	subeq	r5, r9, r3, asr r7
    11c8:	63697551 	cmnvs	r9, #339738624	; 0x14400000
    11cc:	726f736b 	rsbvc	r7, pc, #-1409286143	; 0xac000001
    11d0:	68730074 	ldmdavs	r3!, {r2, r4, r5, r6}^
    11d4:	2074726f 	rsbscs	r7, r4, pc, ror #4
    11d8:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
    11dc:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
    11e0:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
    11e4:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
    11e8:	6150006e 	cmpvs	r0, lr, rrx
    11ec:	656d6172 	strbvs	r6, [sp, #-370]!	; 0xfffffe8e
    11f0:	73726574 	cmnvc	r2, #116, 10	; 0x1d000000
    11f4:	72507300 	subsvc	r7, r0, #0, 6
    11f8:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    11fc:	72674d73 	rsbvc	r4, r7, #7360	; 0x1cc0
    1200:	69687400 	stmdbvs	r8!, {sl, ip, sp, lr}^
    1204:	5f790073 	svcpl	0x00790073
    1208:	6c616572 	cfstr64vs	mvdx6, [r1], #-456	; 0xfffffe38
    120c:	69686300 	stmdbvs	r8!, {r8, r9, sp, lr}^
    1210:	6572646c 	ldrbvs	r6, [r2, #-1132]!	; 0xfffffb94
    1214:	4153006e 	cmpmi	r3, lr, rrx
    1218:	454c504d 	strbmi	r5, [ip, #-77]	; 0xffffffb3
    121c:	5a49535f 	bpl	1255fa0 <__bss_end+0x124a098>
    1220:	554e0045 	strbpl	r0, [lr, #-69]	; 0xffffffbb
    1224:	5f545241 	svcpl	0x00545241
    1228:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    122c:	6e654c5f 	mcrvs	12, 3, r4, cr5, cr15, {2}
    1230:	00687467 	rsbeq	r7, r8, r7, ror #8
    1234:	44746547 	ldrbtmi	r6, [r4], #-1351	; 0xfffffab9
    1238:	65666669 	strbvs	r6, [r6, #-1641]!	; 0xfffff997
    123c:	636e6572 	cmnvs	lr, #478150656	; 0x1c800000
    1240:	6e490065 	cdpvs	0, 4, cr0, cr9, cr5, {3}
    1244:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
    1248:	5f747075 	svcpl	0x00747075
    124c:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
    1250:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
    1254:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
    1258:	00657361 	rsbeq	r7, r5, r1, ror #6
    125c:	364e5a5f 			; <UNDEFINED> instruction: 0x364e5a5f
    1260:	66667542 	strbtvs	r7, [r6], -r2, asr #10
    1264:	52377265 	eorspl	r7, r7, #1342177286	; 0x50000006
    1268:	61656c65 	cmnvs	r5, r5, ror #24
    126c:	76456573 			; <UNDEFINED> instruction: 0x76456573
    1270:	53465400 	movtpl	r5, #25600	; 0x6400
    1274:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
    1278:	00726576 	rsbseq	r6, r2, r6, ror r5
    127c:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
    1280:	6972575f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, ip, lr}^
    1284:	62006574 	andvs	r6, r0, #116, 10	; 0x1d000000
    1288:	5f647561 	svcpl	0x00647561
    128c:	65746172 	ldrbvs	r6, [r4, #-370]!	; 0xfffffe8e
    1290:	74634100 	strbtvc	r4, [r3], #-256	; 0xffffff00
    1294:	5f657669 	svcpl	0x00657669
    1298:	636f7250 	cmnvs	pc, #80, 4
    129c:	5f737365 	svcpl	0x00737365
    12a0:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
    12a4:	5a5f0074 	bpl	17c147c <__bss_end+0x17b5574>
    12a8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    12ac:	636f7250 	cmnvs	pc, #80, 4
    12b0:	5f737365 	svcpl	0x00737365
    12b4:	616e614d 	cmnvs	lr, sp, asr #2
    12b8:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
    12bc:	6e614831 	mcrvs	8, 3, r4, cr1, cr1, {1}
    12c0:	5f656c64 	svcpl	0x00656c64
    12c4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    12c8:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    12cc:	535f6d65 	cmppl	pc, #6464	; 0x1940
    12d0:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
    12d4:	57534e33 	smmlarpl	r3, r3, lr, r4
    12d8:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
    12dc:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    12e0:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    12e4:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
    12e8:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
    12ec:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
    12f0:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
    12f4:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
    12f8:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
    12fc:	52420074 	subpl	r0, r2, #116	; 0x74
    1300:	3531315f 	ldrcc	r3, [r1, #-351]!	; 0xfffffea1
    1304:	00303032 	eorseq	r3, r0, r2, lsr r0
    1308:	32736f70 	rsbscc	r6, r3, #112, 30	; 0x1c0
    130c:	6e727400 	cdpvs	4, 7, cr7, cr2, cr0, {0}
    1310:	69665f67 	stmdbvs	r6!, {r0, r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    1314:	5f00656c 	svcpl	0x0000656c
    1318:	6174735f 	cmnvs	r4, pc, asr r3
    131c:	5f636974 	svcpl	0x00636974
    1320:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
    1324:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
    1328:	6974617a 	ldmdbvs	r4!, {r1, r3, r4, r5, r6, r8, sp, lr}^
    132c:	615f6e6f 	cmpvs	pc, pc, ror #28
    1330:	645f646e 	ldrbvs	r6, [pc], #-1134	; 1338 <shift+0x1338>
    1334:	72747365 	rsbsvc	r7, r4, #-1811939327	; 0x94000001
    1338:	69746375 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, r8, r9, sp, lr}^
    133c:	305f6e6f 	subscc	r6, pc, pc, ror #28
    1340:	6f682f00 	svcvs	0x00682f00
    1344:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    1348:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    134c:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
    1350:	69662f76 	stmdbvs	r6!, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
    1354:	2f6c616e 	svccs	0x006c616e
    1358:	2f637273 	svccs	0x00637273
    135c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    1360:	2f736563 	svccs	0x00736563
    1364:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    1368:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    136c:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    1370:	75626474 	strbvc	r6, [r2, #-1140]!	; 0xfffffb8c
    1374:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
    1378:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    137c:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    1380:	2b2b4320 	blcs	ad2008 <__bss_end+0xac6100>
    1384:	38203431 	stmdacc	r0!, {r0, r4, r5, sl, ip, sp}
    1388:	312e332e 			; <UNDEFINED> instruction: 0x312e332e
    138c:	31303220 	teqcc	r0, r0, lsr #4
    1390:	30373039 	eorscc	r3, r7, r9, lsr r0
    1394:	72282033 	eorvc	r2, r8, #51	; 0x33
    1398:	61656c65 	cmnvs	r5, r5, ror #24
    139c:	20296573 	eorcs	r6, r9, r3, ror r5
    13a0:	6363675b 	cmnvs	r3, #23855104	; 0x16c0000
    13a4:	622d382d 	eorvs	r3, sp, #2949120	; 0x2d0000
    13a8:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
    13ac:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
    13b0:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    13b4:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
    13b8:	32303337 	eorscc	r3, r0, #-603979776	; 0xdc000000
    13bc:	2d205d37 	stccs	13, cr5, [r0, #-220]!	; 0xffffff24
    13c0:	6f6c666d 	svcvs	0x006c666d
    13c4:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    13c8:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    13cc:	20647261 	rsbcs	r7, r4, r1, ror #4
    13d0:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
    13d4:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
    13d8:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
    13dc:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    13e0:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    13e4:	36373131 			; <UNDEFINED> instruction: 0x36373131
    13e8:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
    13ec:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
    13f0:	616f6c66 	cmnvs	pc, r6, ror #24
    13f4:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    13f8:	61683d69 	cmnvs	r8, r9, ror #26
    13fc:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    1400:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
    1404:	7066763d 	rsbvc	r7, r6, sp, lsr r6
    1408:	746d2d20 	strbtvc	r2, [sp], #-3360	; 0xfffff2e0
    140c:	3d656e75 	stclcc	14, cr6, [r5, #-468]!	; 0xfffffe2c
    1410:	316d7261 	cmncc	sp, r1, ror #4
    1414:	6a363731 	bvs	d8f0e0 <__bss_end+0xd831d8>
    1418:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
    141c:	616d2d20 	cmnvs	sp, r0, lsr #26
    1420:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
    1424:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
    1428:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
    142c:	7a36766d 	bvc	d9ede8 <__bss_end+0xd92ee0>
    1430:	70662b6b 	rsbvc	r2, r6, fp, ror #22
    1434:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1438:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    143c:	4f2d2067 	svcmi	0x002d2067
    1440:	4f2d2030 	svcmi	0x002d2030
    1444:	662d2030 			; <UNDEFINED> instruction: 0x662d2030
    1448:	652d6f6e 	strvs	r6, [sp, #-3950]!	; 0xfffff092
    144c:	70656378 	rsbvc	r6, r5, r8, ror r3
    1450:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1454:	662d2073 			; <UNDEFINED> instruction: 0x662d2073
    1458:	722d6f6e 	eorvc	r6, sp, #440	; 0x1b8
    145c:	00697474 	rsbeq	r7, r9, r4, ror r4
    1460:	72705f5f 	rsbsvc	r5, r0, #380	; 0x17c
    1464:	69726f69 	ldmdbvs	r2!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1468:	5f007974 	svcpl	0x00007974
    146c:	696e695f 	stmdbvs	lr!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
    1470:	6c616974 			; <UNDEFINED> instruction: 0x6c616974
    1474:	5f657a69 	svcpl	0x00657a69
    1478:	5a5f0070 	bpl	17c1640 <__bss_end+0x17b5738>
    147c:	7542364e 	strbvc	r3, [r2, #-1614]	; 0xfffff9b2
    1480:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
    1484:	76453243 	strbvc	r3, [r5], -r3, asr #4
    1488:	6f682f00 	svcvs	0x00682f00
    148c:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    1490:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    1494:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
    1498:	69662f76 	stmdbvs	r6!, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
    149c:	2f6c616e 	svccs	0x006c616e
    14a0:	2f637273 	svccs	0x00637273
    14a4:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    14a8:	2f736563 	svccs	0x00736563
    14ac:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    14b0:	475f0064 	ldrbmi	r0, [pc, -r4, rrx]
    14b4:	41424f4c 	cmpmi	r2, ip, asr #30
    14b8:	735f5f4c 	cmpvc	pc, #76, 30	; 0x130
    14bc:	495f6275 	ldmdbmi	pc, {r0, r2, r4, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    14c0:	7269635f 	rsbvc	r6, r9, #2080374785	; 0x7c000001
    14c4:	66754263 	ldrbtvs	r4, [r5], -r3, ror #4
    14c8:	00726566 	rsbseq	r6, r2, r6, ror #10
    14cc:	736f6c63 	cmnvc	pc, #25344	; 0x6300
    14d0:	65530065 	ldrbvs	r0, [r3, #-101]	; 0xffffff9b
    14d4:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
    14d8:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    14dc:	72006576 	andvc	r6, r0, #494927872	; 0x1d800000
    14e0:	61767465 	cmnvs	r6, r5, ror #8
    14e4:	636e006c 	cmnvs	lr, #108	; 0x6c
    14e8:	70007275 	andvc	r7, r0, r5, ror r2
    14ec:	00657069 	rsbeq	r7, r5, r9, rrx
    14f0:	756e6472 	strbvc	r6, [lr, #-1138]!	; 0xfffffb8e
    14f4:	5a5f006d 	bpl	17c16b0 <__bss_end+0x17b57a8>
    14f8:	63733131 	cmnvs	r3, #1073741836	; 0x4000000c
    14fc:	5f646568 	svcpl	0x00646568
    1500:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
    1504:	5f007664 	svcpl	0x00007664
    1508:	7337315a 	teqvc	r7, #-2147483626	; 0x80000016
    150c:	745f7465 	ldrbvc	r7, [pc], #-1125	; 1514 <shift+0x1514>
    1510:	5f6b7361 	svcpl	0x006b7361
    1514:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
    1518:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    151c:	6177006a 	cmnvs	r7, sl, rrx
    1520:	5f007469 	svcpl	0x00007469
    1524:	6f6e365a 	svcvs	0x006e365a
    1528:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
    152c:	5f006a6a 	svcpl	0x00006a6a
    1530:	6574395a 	ldrbvs	r3, [r4, #-2394]!	; 0xfffff6a6
    1534:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
    1538:	69657461 	stmdbvs	r5!, {r0, r5, r6, sl, ip, sp, lr}^
    153c:	69614600 	stmdbvs	r1!, {r9, sl, lr}^
    1540:	7865006c 	stmdavc	r5!, {r2, r3, r5, r6}^
    1544:	6f637469 	svcvs	0x00637469
    1548:	5f006564 	svcpl	0x00006564
    154c:	6734325a 			; <UNDEFINED> instruction: 0x6734325a
    1550:	615f7465 	cmpvs	pc, r5, ror #8
    1554:	76697463 	strbtvc	r7, [r9], -r3, ror #8
    1558:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
    155c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1560:	6f635f73 	svcvs	0x00635f73
    1564:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
    1568:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
    156c:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
    1570:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
    1574:	63697400 	cmnvs	r9, #0, 8
    1578:	6f635f6b 	svcvs	0x00635f6b
    157c:	5f746e75 	svcpl	0x00746e75
    1580:	75716572 	ldrbvc	r6, [r1, #-1394]!	; 0xfffffa8e
    1584:	64657269 	strbtvs	r7, [r5], #-617	; 0xfffffd97
    1588:	70695000 	rsbvc	r5, r9, r0
    158c:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    1590:	505f656c 	subspl	r6, pc, ip, ror #10
    1594:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1598:	5a5f0078 	bpl	17c1780 <__bss_end+0x17b5878>
    159c:	65673431 	strbvs	r3, [r7, #-1073]!	; 0xfffffbcf
    15a0:	69745f74 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    15a4:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
    15a8:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    15ac:	6c730076 	ldclvs	0, cr0, [r3], #-472	; 0xfffffe28
    15b0:	00706565 	rsbseq	r6, r0, r5, ror #10
    15b4:	7265706f 	rsbvc	r7, r5, #111	; 0x6f
    15b8:	6f697461 	svcvs	0x00697461
    15bc:	5a5f006e 	bpl	17c177c <__bss_end+0x17b5874>
    15c0:	6f6c6335 	svcvs	0x006c6335
    15c4:	006a6573 	rsbeq	r6, sl, r3, ror r5
    15c8:	67365a5f 			; <UNDEFINED> instruction: 0x67365a5f
    15cc:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
    15d0:	66007664 	strvs	r7, [r0], -r4, ror #12
    15d4:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    15d8:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    15dc:	6e61725f 	mcrvs	2, 3, r7, cr1, cr15, {2}
    15e0:	5f6d6f64 	svcpl	0x006d6f64
    15e4:	626d756e 	rsbvs	r7, sp, #461373440	; 0x1b800000
    15e8:	6e007265 	cdpvs	2, 0, cr7, cr0, cr5, {3}
    15ec:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
    15f0:	69740079 	ldmdbvs	r4!, {r0, r3, r4, r5, r6}^
    15f4:	00736b63 	rsbseq	r6, r3, r3, ror #22
    15f8:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
    15fc:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1600:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    1604:	6a634b50 	bvs	18d434c <__bss_end+0x18c8444>
    1608:	65444e00 	strbvs	r4, [r4, #-3584]	; 0xfffff200
    160c:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    1610:	535f656e 	cmppl	pc, #461373440	; 0x1b800000
    1614:	65736275 	ldrbvs	r6, [r3, #-629]!	; 0xfffffd8b
    1618:	63697672 	cmnvs	r9, #119537664	; 0x7200000
    161c:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
    1620:	69745f74 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1624:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
    1628:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    162c:	72617000 	rsbvc	r7, r1, #0
    1630:	5f006d61 	svcpl	0x00006d61
    1634:	7277355a 	rsbsvc	r3, r7, #377487360	; 0x16800000
    1638:	6a657469 	bvs	195e7e4 <__bss_end+0x19528dc>
    163c:	6a634b50 	bvs	18d4384 <__bss_end+0x18c847c>
    1640:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    1644:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    1648:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    164c:	5f736b63 	svcpl	0x00736b63
    1650:	645f6f74 	ldrbvs	r6, [pc], #-3956	; 1658 <shift+0x1658>
    1654:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    1658:	00656e69 	rsbeq	r6, r5, r9, ror #28
    165c:	5f667562 	svcpl	0x00667562
    1660:	657a6973 	ldrbvs	r6, [sl, #-2419]!	; 0xfffff68d
    1664:	315a5f00 	cmpcc	sl, r0, lsl #30
    1668:	74656737 	strbtvc	r6, [r5], #-1847	; 0xfffff8c9
    166c:	6e61725f 	mcrvs	2, 3, r7, cr1, cr15, {2}
    1670:	5f6d6f64 	svcpl	0x006d6f64
    1674:	626d756e 	rsbvs	r7, sp, #461373440	; 0x1b800000
    1678:	00767265 	rsbseq	r7, r6, r5, ror #4
    167c:	6f345a5f 	svcvs	0x00345a5f
    1680:	506e6570 	rsbpl	r6, lr, r0, ror r5
    1684:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
    1688:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
    168c:	704f5f65 	subvc	r5, pc, r5, ror #30
    1690:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; 1504 <shift+0x1504>
    1694:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1698:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
    169c:	65730065 	ldrbvs	r0, [r3, #-101]!	; 0xffffff9b
    16a0:	61745f74 	cmnvs	r4, r4, ror pc
    16a4:	645f6b73 	ldrbvs	r6, [pc], #-2931	; 16ac <shift+0x16ac>
    16a8:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    16ac:	00656e69 	rsbeq	r6, r5, r9, ror #28
    16b0:	73355a5f 	teqvc	r5, #389120	; 0x5f000
    16b4:	7065656c 	rsbvc	r6, r5, ip, ror #10
    16b8:	47006a6a 	strmi	r6, [r0, -sl, ror #20]
    16bc:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
    16c0:	69616d65 	stmdbvs	r1!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}^
    16c4:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
    16c8:	325a5f00 	subscc	r5, sl, #0, 30
    16cc:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
    16d0:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    16d4:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    16d8:	5f736b63 	svcpl	0x00736b63
    16dc:	645f6f74 	ldrbvs	r6, [pc], #-3956	; 16e4 <shift+0x16e4>
    16e0:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    16e4:	76656e69 	strbtvc	r6, [r5], -r9, ror #28
    16e8:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
    16ec:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
    16f0:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
    16f4:	646f435f 	strbtvs	r4, [pc], #-863	; 16fc <shift+0x16fc>
    16f8:	72770065 	rsbsvc	r0, r7, #101	; 0x65
    16fc:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1700:	77345a5f 			; <UNDEFINED> instruction: 0x77345a5f
    1704:	6a746961 	bvs	1d1bc90 <__bss_end+0x1d0fd88>
    1708:	5f006a6a 	svcpl	0x00006a6a
    170c:	6f69355a 	svcvs	0x0069355a
    1710:	6a6c7463 	bvs	1b1e8a4 <__bss_end+0x1b1299c>
    1714:	494e3631 	stmdbmi	lr, {r0, r4, r5, r9, sl, ip, sp}^
    1718:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
    171c:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    1720:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    1724:	76506e6f 	ldrbvc	r6, [r0], -pc, ror #28
    1728:	636f6900 	cmnvs	pc, #0, 18
    172c:	72006c74 	andvc	r6, r0, #116, 24	; 0x7400
    1730:	6e637465 	cdpvs	4, 6, cr7, cr3, cr5, {3}
    1734:	65740074 	ldrbvs	r0, [r4, #-116]!	; 0xffffff8c
    1738:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
    173c:	00657461 	rsbeq	r7, r5, r1, ror #8
    1740:	65646f6d 	strbvs	r6, [r4, #-3949]!	; 0xfffff093
    1744:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1748:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    174c:	6a63506a 	bvs	18d58fc <__bss_end+0x18c99f4>
    1750:	6f682f00 	svcvs	0x00682f00
    1754:	682f656d 	stmdavs	pc!, {r0, r2, r3, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    1758:	69746e69 	ldmdbvs	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    175c:	65642f6b 	strbvs	r2, [r4, #-3947]!	; 0xfffff095
    1760:	69662f76 	stmdbvs	r6!, {r1, r2, r4, r5, r6, r8, r9, sl, fp, sp}^
    1764:	2f6c616e 	svccs	0x006c616e
    1768:	2f637273 	svccs	0x00637273
    176c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    1770:	2f736563 	svccs	0x00736563
    1774:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    1778:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    177c:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    1780:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
    1784:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
    1788:	72007070 	andvc	r7, r0, #112	; 0x70
    178c:	6f637465 	svcvs	0x00637465
    1790:	67006564 	strvs	r6, [r0, -r4, ror #10]
    1794:	615f7465 	cmpvs	pc, r5, ror #8
    1798:	76697463 	strbtvc	r7, [r9], -r3, ror #8
    179c:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
    17a0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    17a4:	6f635f73 	svcvs	0x00635f73
    17a8:	00746e75 	rsbseq	r6, r4, r5, ror lr
    17ac:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    17b0:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    17b4:	61657200 	cmnvs	r5, r0, lsl #4
    17b8:	65670064 	strbvs	r0, [r7, #-100]!	; 0xffffff9c
    17bc:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
    17c0:	6d657400 	cfstrdvs	mvd7, [r5, #-0]
    17c4:	64646170 	strbtvs	r6, [r4], #-368	; 0xfffffe90
    17c8:	656e0072 	strbvs	r0, [lr, #-114]!	; 0xffffff8e
    17cc:	7a697377 	bvc	1a5e5b0 <__bss_end+0x1a526a8>
    17d0:	654e0065 	strbvs	r0, [lr, #-101]	; 0xffffff9b
    17d4:	64415677 	strbvs	r5, [r1], #-1655	; 0xfffff989
    17d8:	73657264 	cmnvc	r5, #100, 4	; 0x40000006
    17dc:	766f0073 			; <UNDEFINED> instruction: 0x766f0073
    17e0:	73007265 	movwvc	r7, #613	; 0x265
    17e4:	42657661 	rsbmi	r7, r5, #101711872	; 0x6100000
    17e8:	6b616572 	blvs	185adb8 <__bss_end+0x184eeb0>
    17ec:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
    17f0:	745f3874 	ldrbvc	r3, [pc], #-2164	; 17f8 <shift+0x17f8>
    17f4:	70545000 	subsvc	r5, r4, r0
    17f8:	745f7274 	ldrbvc	r7, [pc], #-628	; 1800 <shift+0x1800>
    17fc:	00706d65 	rsbseq	r6, r0, r5, ror #26
    1800:	4f4c475f 	svcmi	0x004c475f
    1804:	5f4c4142 	svcpl	0x004c4142
    1808:	6275735f 	rsbsvs	r7, r5, #2080374785	; 0x7c000001
    180c:	735f495f 	cmpvc	pc, #1556480	; 0x17c000
    1810:	72657355 	rsbvc	r7, r5, #1409286145	; 0x54000001
    1814:	70616548 	rsbvc	r6, r1, r8, asr #10
    1818:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    181c:	55433231 	strbpl	r3, [r3, #-561]	; 0xfffffdcf
    1820:	48726573 	ldmdami	r2!, {r0, r1, r4, r5, r6, r8, sl, sp, lr}^
    1824:	4d706165 	ldfmie	f6, [r0, #-404]!	; 0xfffffe6c
    1828:	32436e61 	subcc	r6, r3, #1552	; 0x610
    182c:	74007645 	strvc	r7, [r0], #-1605	; 0xfffff9bb
    1830:	41706d65 	cmnmi	r0, r5, ror #26
    1834:	00726464 	rsbseq	r6, r2, r4, ror #8
    1838:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 1784 <shift+0x1784>
    183c:	69682f65 	stmdbvs	r8!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
    1840:	6b69746e 	blvs	1a5ea00 <__bss_end+0x1a52af8>
    1844:	7665642f 	strbtvc	r6, [r5], -pc, lsr #8
    1848:	6e69662f 	cdpvs	6, 6, cr6, cr9, cr15, {1}
    184c:	732f6c61 			; <UNDEFINED> instruction: 0x732f6c61
    1850:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    1854:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1858:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    185c:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    1860:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    1864:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    1868:	6d656d64 	stclvs	13, cr6, [r5, #-400]!	; 0xfffffe70
    186c:	2e79726f 	cdpcs	2, 7, cr7, cr9, cr15, {3}
    1870:	00707063 	rsbseq	r7, r0, r3, rrx
    1874:	6377656e 	cmnvs	r7, #461373440	; 0x1b800000
    1878:	6b6e7568 	blvs	1b9ee20 <__bss_end+0x1b92f18>
    187c:	385a5f00 	ldmdacc	sl, {r8, r9, sl, fp, ip, lr}^
    1880:	645f7369 	ldrbvs	r7, [pc], #-873	; 1888 <shift+0x1888>
    1884:	74696769 	strbtvc	r6, [r9], #-1897	; 0xfffff897
    1888:	65620063 	strbvs	r0, [r2, #-99]!	; 0xffffff9d
    188c:	65726f66 	ldrbvs	r6, [r2, #-3942]!	; 0xfffff09a
    1890:	696f705f 	stmdbvs	pc!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    1894:	5f00746e 	svcpl	0x0000746e
    1898:	656d365a 	strbvs	r3, [sp, #-1626]!	; 0xfffff9a6
    189c:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    18a0:	50764b50 	rsbspl	r4, r6, r0, asr fp
    18a4:	2f006976 	svccs	0x00006976
    18a8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    18ac:	6e69682f 	cdpvs	8, 6, cr6, cr9, cr15, {1}
    18b0:	2f6b6974 	svccs	0x006b6974
    18b4:	2f766564 	svccs	0x00766564
    18b8:	616e6966 	cmnvs	lr, r6, ror #18
    18bc:	72732f6c 	rsbsvc	r2, r3, #108, 30	; 0x1b0
    18c0:	6f732f63 	svcvs	0x00732f63
    18c4:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    18c8:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    18cc:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    18d0:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    18d4:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    18d8:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    18dc:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
    18e0:	66007070 			; <UNDEFINED> instruction: 0x66007070
    18e4:	00616f74 	rsbeq	r6, r1, r4, ror pc
    18e8:	69345a5f 	ldmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    18ec:	6a616f74 	bvs	185d6c4 <__bss_end+0x18517bc>
    18f0:	006a6350 	rsbeq	r6, sl, r0, asr r3
    18f4:	665f7369 	ldrbvs	r7, [pc], -r9, ror #6
    18f8:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    18fc:	72617400 	rsbvc	r7, r1, #0, 8
    1900:	00746567 	rsbseq	r6, r4, r7, ror #10
    1904:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    1908:	5f006e65 	svcpl	0x00006e65
    190c:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    1910:	4b50666f 	blmi	141b2d4 <__bss_end+0x140f3cc>
    1914:	5a5f0063 	bpl	17c1aa8 <__bss_end+0x17b5ba0>
    1918:	6e6f6339 	mcrvs	3, 3, r6, cr15, cr9, {1}
    191c:	69617473 	stmdbvs	r1!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1920:	4b50736e 	blmi	141e6e0 <__bss_end+0x14127d8>
    1924:	62006363 	andvs	r6, r0, #-1946157055	; 0x8c000001
    1928:	00657361 	rsbeq	r7, r5, r1, ror #6
    192c:	736e6f63 	cmnvc	lr, #396	; 0x18c
    1930:	6e696174 	mcrvs	1, 3, r6, cr9, cr4, {3}
    1934:	66610073 			; <UNDEFINED> instruction: 0x66610073
    1938:	5f726574 	svcpl	0x00726574
    193c:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    1940:	5a5f0074 	bpl	17c1b18 <__bss_end+0x17b5c10>
    1944:	657a6235 	ldrbvs	r6, [sl, #-565]!	; 0xfffffdcb
    1948:	76506f72 	usub16vc	r6, r0, r2
    194c:	74730069 	ldrbtvc	r0, [r3], #-105	; 0xffffff97
    1950:	70636e72 	rsbvc	r6, r3, r2, ror lr
    1954:	74690079 	strbtvc	r0, [r9], #-121	; 0xffffff87
    1958:	6400616f 	strvs	r6, [r0], #-367	; 0xfffffe91
    195c:	00747365 	rsbseq	r7, r4, r5, ror #6
    1960:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    1964:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1968:	63507970 	cmpvs	r0, #112, 18	; 0x1c0000
    196c:	69634b50 	stmdbvs	r3!, {r4, r6, r8, r9, fp, lr}^
    1970:	5f736900 	svcpl	0x00736900
    1974:	69636564 	stmdbvs	r3!, {r2, r5, r6, r8, sl, sp, lr}^
    1978:	006c616d 	rsbeq	r6, ip, sp, ror #2
    197c:	69736f70 	ldmdbvs	r3!, {r4, r5, r6, r8, r9, sl, fp, sp, lr}^
    1980:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1984:	5f736900 	svcpl	0x00736900
    1988:	69676964 	stmdbvs	r7!, {r2, r5, r6, r8, fp, sp, lr}^
    198c:	74610074 	strbtvc	r0, [r1], #-116	; 0xffffff8c
    1990:	6d00666f 	stcvs	6, cr6, [r0, #-444]	; 0xfffffe44
    1994:	73646d65 	cmnvc	r4, #6464	; 0x1940
    1998:	68430074 	stmdavs	r3, {r2, r4, r5, r6}^
    199c:	6f437261 	svcvs	0x00437261
    19a0:	7241766e 	subvc	r7, r1, #115343360	; 0x6e00000
    19a4:	74610072 	strbtvc	r0, [r1], #-114	; 0xffffff8e
    19a8:	5f00696f 	svcpl	0x0000696f
    19ac:	5f6e345a 	svcpl	0x006e345a
    19b0:	69697574 	stmdbvs	r9!, {r2, r4, r5, r6, r8, sl, ip, sp, lr}^
    19b4:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    19b8:	00637273 	rsbeq	r7, r3, r3, ror r2
    19bc:	626d756e 	rsbvs	r7, sp, #461373440	; 0x1b800000
    19c0:	00327265 	eorseq	r7, r2, r5, ror #4
    19c4:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    19c8:	656d006f 	strbvs	r0, [sp, #-111]!	; 0xffffff91
    19cc:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    19d0:	6e656c00 	cdpvs	12, 6, cr6, cr5, cr0, {0}
    19d4:	32687467 	rsbcc	r7, r8, #1728053248	; 0x67000000
    19d8:	72747300 	rsbsvc	r7, r4, #0, 6
    19dc:	706d636e 	rsbvc	r6, sp, lr, ror #6
    19e0:	74756f00 	ldrbtvc	r6, [r5], #-3840	; 0xfffff100
    19e4:	00747570 	rsbseq	r7, r4, r0, ror r5
    19e8:	30315a5f 	eorscc	r5, r1, pc, asr sl
    19ec:	645f7369 	ldrbvs	r7, [pc], #-873	; 19f4 <shift+0x19f4>
    19f0:	6d696365 	stclvs	3, cr6, [r9, #-404]!	; 0xfffffe6c
    19f4:	4b506c61 	blmi	141cb80 <__bss_end+0x1410c78>
    19f8:	5a5f0063 	bpl	17c1b8c <__bss_end+0x17b5c84>
    19fc:	5f736938 	svcpl	0x00736938
    1a00:	616f6c66 	cmnvs	pc, r6, ror #24
    1a04:	634b5074 	movtvs	r5, #45172	; 0xb074
    1a08:	745f6e00 	ldrbvc	r6, [pc], #-3584	; 1a10 <shift+0x1a10>
    1a0c:	69730075 	ldmdbvs	r3!, {r0, r2, r4, r5, r6}^
    1a10:	5f006e67 	svcpl	0x00006e67
    1a14:	7473365a 	ldrbtvc	r3, [r3], #-1626	; 0xfffff9a6
    1a18:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
    1a1c:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1a20:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    1a24:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1a28:	4b50706d 	blmi	141dbe4 <__bss_end+0x1411cdc>
    1a2c:	5f305363 	svcpl	0x00305363
    1a30:	5a5f0069 	bpl	17c1bdc <__bss_end+0x17b5cd4>
    1a34:	6f746134 	svcvs	0x00746134
    1a38:	634b5069 	movtvs	r5, #45161	; 0xb069
    1a3c:	756f7300 	strbvc	r7, [pc, #-768]!	; 1744 <shift+0x1744>
    1a40:	00656372 	rsbeq	r6, r5, r2, ror r3
    1a44:	66345a5f 			; <UNDEFINED> instruction: 0x66345a5f
    1a48:	66616f74 	uqsub16vs	r6, r1, r4
    1a4c:	6d006350 	stcvs	3, cr6, [r0, #-320]	; 0xfffffec0
    1a50:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    1a54:	2e2e0079 	mcrcs	0, 1, r0, cr14, cr9, {3}
    1a58:	2f2e2e2f 	svccs	0x002e2e2f
    1a5c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1a60:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1a64:	2f2e2e2f 	svccs	0x002e2e2f
    1a68:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1a6c:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    1a70:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    1a74:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    1a78:	696c2f6d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp}^
    1a7c:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
    1a80:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
    1a84:	622f0053 	eorvs	r0, pc, #83	; 0x53
    1a88:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1a8c:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    1a90:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    1a94:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    1a98:	61652d65 	cmnvs	r5, r5, ror #26
    1a9c:	7a2d6962 	bvc	b5c02c <__bss_end+0xb50124>
    1aa0:	66566253 			; <UNDEFINED> instruction: 0x66566253
    1aa4:	63672f6e 	cmnvs	r7, #440	; 0x1b8
    1aa8:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    1aac:	6f6e2d6d 	svcvs	0x006e2d6d
    1ab0:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1ab4:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1ab8:	30322d38 	eorscc	r2, r2, r8, lsr sp
    1abc:	712d3931 			; <UNDEFINED> instruction: 0x712d3931
    1ac0:	75622f33 	strbvc	r2, [r2, #-3891]!	; 0xfffff0cd
    1ac4:	2f646c69 	svccs	0x00646c69
    1ac8:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1acc:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1ad0:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1ad4:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
    1ad8:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
    1adc:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    1ae0:	2f647261 	svccs	0x00647261
    1ae4:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1ae8:	47006363 	strmi	r6, [r0, -r3, ror #6]
    1aec:	4120554e 			; <UNDEFINED> instruction: 0x4120554e
    1af0:	2e322053 	mrccs	0, 1, r2, cr2, cr3, {2}
    1af4:	2e003433 	cfmvdhrcs	mvd0, r3
    1af8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1afc:	2f2e2e2f 	svccs	0x002e2e2f
    1b00:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1b04:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1b08:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1b0c:	2f636367 	svccs	0x00636367
    1b10:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
    1b14:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
    1b18:	692f6d72 	stmdbvs	pc!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}	; <UNPREDICTABLE>
    1b1c:	37656565 	strbcc	r6, [r5, -r5, ror #10]!
    1b20:	732d3435 			; <UNDEFINED> instruction: 0x732d3435
    1b24:	00532e66 	subseq	r2, r3, r6, ror #28
    1b28:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1b2c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1b30:	2f2e2e2f 	svccs	0x002e2e2f
    1b34:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1b38:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1b3c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1b40:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1b44:	2f676966 	svccs	0x00676966
    1b48:	2f6d7261 	svccs	0x006d7261
    1b4c:	62617062 	rsbvs	r7, r1, #98	; 0x62
    1b50:	00532e69 	subseq	r2, r3, r9, ror #28
    1b54:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b58:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b5c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1b60:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1b64:	37316178 			; <UNDEFINED> instruction: 0x37316178
    1b68:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1b6c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1b70:	61736900 	cmnvs	r3, r0, lsl #18
    1b74:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1b78:	5f70665f 	svcpl	0x0070665f
    1b7c:	006c6264 	rsbeq	r6, ip, r4, ror #4
    1b80:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b84:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b88:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1b8c:	31316d72 	teqcc	r1, r2, ror sp
    1b90:	736a3633 	cmnvc	sl, #53477376	; 0x3300000
    1b94:	6d726100 	ldfvse	f6, [r2, #-0]
    1b98:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1b9c:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    1ba0:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1ba4:	52415400 	subpl	r5, r1, #0, 8
    1ba8:	5f544547 	svcpl	0x00544547
    1bac:	5f555043 	svcpl	0x00555043
    1bb0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1bb4:	326d7865 	rsbcc	r7, sp, #6619136	; 0x650000
    1bb8:	52410033 	subpl	r0, r1, #51	; 0x33
    1bbc:	51455f4d 	cmppl	r5, sp, asr #30
    1bc0:	52415400 	subpl	r5, r1, #0, 8
    1bc4:	5f544547 	svcpl	0x00544547
    1bc8:	5f555043 	svcpl	0x00555043
    1bcc:	316d7261 	cmncc	sp, r1, ror #4
    1bd0:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    1bd4:	00736632 	rsbseq	r6, r3, r2, lsr r6
    1bd8:	5f617369 	svcpl	0x00617369
    1bdc:	5f746962 	svcpl	0x00746962
    1be0:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    1be4:	41540062 	cmpmi	r4, r2, rrx
    1be8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1bec:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1bf0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1bf4:	61786574 	cmnvs	r8, r4, ror r5
    1bf8:	6f633735 	svcvs	0x00633735
    1bfc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1c00:	00333561 	eorseq	r3, r3, r1, ror #10
    1c04:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1c08:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1c0c:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    1c10:	5341425f 	movtpl	r4, #4703	; 0x125f
    1c14:	41540045 	cmpmi	r4, r5, asr #32
    1c18:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c1c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c20:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1c24:	00303138 	eorseq	r3, r0, r8, lsr r1
    1c28:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c2c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c30:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1c34:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    1c38:	52410031 	subpl	r0, r1, #49	; 0x31
    1c3c:	43505f4d 	cmpmi	r0, #308	; 0x134
    1c40:	41415f53 	cmpmi	r1, r3, asr pc
    1c44:	5f534350 	svcpl	0x00534350
    1c48:	4d4d5749 	stclmi	7, cr5, [sp, #-292]	; 0xfffffedc
    1c4c:	54005458 	strpl	r5, [r0], #-1112	; 0xfffffba8
    1c50:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c54:	50435f54 	subpl	r5, r3, r4, asr pc
    1c58:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1c5c:	6964376d 	stmdbvs	r4!, {r0, r2, r3, r5, r6, r8, r9, sl, ip, sp}^
    1c60:	53414200 	movtpl	r4, #4608	; 0x1200
    1c64:	52415f45 	subpl	r5, r1, #276	; 0x114
    1c68:	325f4843 	subscc	r4, pc, #4390912	; 0x430000
    1c6c:	53414200 	movtpl	r4, #4608	; 0x1200
    1c70:	52415f45 	subpl	r5, r1, #276	; 0x114
    1c74:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    1c78:	52415400 	subpl	r5, r1, #0, 8
    1c7c:	5f544547 	svcpl	0x00544547
    1c80:	5f555043 	svcpl	0x00555043
    1c84:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1c88:	42006d64 	andmi	r6, r0, #100, 26	; 0x1900
    1c8c:	5f455341 	svcpl	0x00455341
    1c90:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1c94:	4200355f 	andmi	r3, r0, #398458880	; 0x17c00000
    1c98:	5f455341 	svcpl	0x00455341
    1c9c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1ca0:	4200365f 	andmi	r3, r0, #99614720	; 0x5f00000
    1ca4:	5f455341 	svcpl	0x00455341
    1ca8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1cac:	5400375f 	strpl	r3, [r0], #-1887	; 0xfffff8a1
    1cb0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1cb4:	50435f54 	subpl	r5, r3, r4, asr pc
    1cb8:	73785f55 	cmnvc	r8, #340	; 0x154
    1cbc:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1cc0:	52415400 	subpl	r5, r1, #0, 8
    1cc4:	5f544547 	svcpl	0x00544547
    1cc8:	5f555043 	svcpl	0x00555043
    1ccc:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1cd0:	73653634 	cmnvc	r5, #52, 12	; 0x3400000
    1cd4:	52415400 	subpl	r5, r1, #0, 8
    1cd8:	5f544547 	svcpl	0x00544547
    1cdc:	5f555043 	svcpl	0x00555043
    1ce0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1ce4:	336d7865 	cmncc	sp, #6619136	; 0x650000
    1ce8:	41540033 	cmpmi	r4, r3, lsr r0
    1cec:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cf0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cf4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1cf8:	6d647437 	cfstrdvs	mvd7, [r4, #-220]!	; 0xffffff24
    1cfc:	73690069 	cmnvc	r9, #105	; 0x69
    1d00:	6f6e5f61 	svcvs	0x006e5f61
    1d04:	00746962 	rsbseq	r6, r4, r2, ror #18
    1d08:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d0c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d10:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1d14:	31316d72 	teqcc	r1, r2, ror sp
    1d18:	7a6a3637 	bvc	1a8f5fc <__bss_end+0x1a836f4>
    1d1c:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1d20:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1d24:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1d28:	32767066 	rsbscc	r7, r6, #102	; 0x66
    1d2c:	4d524100 	ldfmie	f4, [r2, #-0]
    1d30:	5343505f 	movtpl	r5, #12383	; 0x305f
    1d34:	4b4e555f 	blmi	13972b8 <__bss_end+0x138b3b0>
    1d38:	4e574f4e 	cdpmi	15, 5, cr4, cr7, cr14, {2}
    1d3c:	52415400 	subpl	r5, r1, #0, 8
    1d40:	5f544547 	svcpl	0x00544547
    1d44:	5f555043 	svcpl	0x00555043
    1d48:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1d4c:	41420065 	cmpmi	r2, r5, rrx
    1d50:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1d54:	5f484352 	svcpl	0x00484352
    1d58:	4a455435 	bmi	1156e34 <__bss_end+0x114af2c>
    1d5c:	6d726100 	ldfvse	f6, [r2, #-0]
    1d60:	6663635f 			; <UNDEFINED> instruction: 0x6663635f
    1d64:	735f6d73 	cmpvc	pc, #7360	; 0x1cc0
    1d68:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
    1d6c:	736e7500 	cmnvc	lr, #0, 10
    1d70:	5f636570 	svcpl	0x00636570
    1d74:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1d78:	0073676e 	rsbseq	r6, r3, lr, ror #14
    1d7c:	5f617369 	svcpl	0x00617369
    1d80:	5f746962 	svcpl	0x00746962
    1d84:	00636573 	rsbeq	r6, r3, r3, ror r5
    1d88:	6c635f5f 	stclvs	15, cr5, [r3], #-380	; 0xfffffe84
    1d8c:	61745f7a 	cmnvs	r4, sl, ror pc
    1d90:	52410062 	subpl	r0, r1, #98	; 0x62
    1d94:	43565f4d 	cmpmi	r6, #308	; 0x134
    1d98:	6d726100 	ldfvse	f6, [r2, #-0]
    1d9c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1da0:	73785f68 	cmnvc	r8, #104, 30	; 0x1a0
    1da4:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1da8:	4d524100 	ldfmie	f4, [r2, #-0]
    1dac:	00454c5f 	subeq	r4, r5, pc, asr ip
    1db0:	5f4d5241 	svcpl	0x004d5241
    1db4:	41005356 	tstmi	r0, r6, asr r3
    1db8:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    1dbc:	72610045 	rsbvc	r0, r1, #69	; 0x45
    1dc0:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1dc4:	735f656e 	cmpvc	pc, #461373440	; 0x1b800000
    1dc8:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    1dcc:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    1dd0:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 1dd8 <shift+0x1dd8>
    1dd4:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    1dd8:	6f6c6620 	svcvs	0x006c6620
    1ddc:	54007461 	strpl	r7, [r0], #-1121	; 0xfffffb9f
    1de0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1de4:	50435f54 	subpl	r5, r3, r4, asr pc
    1de8:	6f635f55 	svcvs	0x00635f55
    1dec:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1df0:	00353161 	eorseq	r3, r5, r1, ror #2
    1df4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1df8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1dfc:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1e00:	36323761 	ldrtcc	r3, [r2], -r1, ror #14
    1e04:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    1e08:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e0c:	50435f54 	subpl	r5, r3, r4, asr pc
    1e10:	6f635f55 	svcvs	0x00635f55
    1e14:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1e18:	00373161 	eorseq	r3, r7, r1, ror #2
    1e1c:	5f4d5241 	svcpl	0x004d5241
    1e20:	41005447 	tstmi	r0, r7, asr #8
    1e24:	4c5f4d52 	mrrcmi	13, 5, r4, pc, cr2	; <UNPREDICTABLE>
    1e28:	2e2e0054 	mcrcs	0, 1, r0, cr14, cr4, {2}
    1e2c:	2f2e2e2f 	svccs	0x002e2e2f
    1e30:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1e34:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1e38:	2f2e2e2f 	svccs	0x002e2e2f
    1e3c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1e40:	6c2f6363 	stcvs	3, cr6, [pc], #-396	; 1cbc <shift+0x1cbc>
    1e44:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1e48:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    1e4c:	52415400 	subpl	r5, r1, #0, 8
    1e50:	5f544547 	svcpl	0x00544547
    1e54:	5f555043 	svcpl	0x00555043
    1e58:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1e5c:	34727865 	ldrbtcc	r7, [r2], #-2149	; 0xfffff79b
    1e60:	41540066 	cmpmi	r4, r6, rrx
    1e64:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e68:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e6c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1e70:	00303239 	eorseq	r3, r0, r9, lsr r2
    1e74:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1e78:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1e7c:	45375f48 	ldrmi	r5, [r7, #-3912]!	; 0xfffff0b8
    1e80:	4154004d 	cmpmi	r4, sp, asr #32
    1e84:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e88:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e8c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1e90:	61786574 	cmnvs	r8, r4, ror r5
    1e94:	68003231 	stmdavs	r0, {r0, r4, r5, r9, ip, sp}
    1e98:	76687361 	strbtvc	r7, [r8], -r1, ror #6
    1e9c:	745f6c61 	ldrbvc	r6, [pc], #-3169	; 1ea4 <shift+0x1ea4>
    1ea0:	53414200 	movtpl	r4, #4608	; 0x1200
    1ea4:	52415f45 	subpl	r5, r1, #276	; 0x114
    1ea8:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1eac:	69005a4b 	stmdbvs	r0, {r0, r1, r3, r6, r9, fp, ip, lr}
    1eb0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1eb4:	00737469 	rsbseq	r7, r3, r9, ror #8
    1eb8:	5f6d7261 	svcpl	0x006d7261
    1ebc:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1ec0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1ec4:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
    1ec8:	61007669 	tstvs	r0, r9, ror #12
    1ecc:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    1ed0:	645f7570 	ldrbvs	r7, [pc], #-1392	; 1ed8 <shift+0x1ed8>
    1ed4:	00637365 	rsbeq	r7, r3, r5, ror #6
    1ed8:	5f617369 	svcpl	0x00617369
    1edc:	5f746962 	svcpl	0x00746962
    1ee0:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1ee4:	4d524100 	ldfmie	f4, [r2, #-0]
    1ee8:	0049485f 	subeq	r4, r9, pc, asr r8
    1eec:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ef0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ef4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1ef8:	00326d72 	eorseq	r6, r2, r2, ror sp
    1efc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f00:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f04:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1f08:	00336d72 	eorseq	r6, r3, r2, ror sp
    1f0c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f10:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f14:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1f18:	31376d72 	teqcc	r7, r2, ror sp
    1f1c:	54003030 	strpl	r3, [r0], #-48	; 0xffffffd0
    1f20:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f24:	50435f54 	subpl	r5, r3, r4, asr pc
    1f28:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1f2c:	5400366d 	strpl	r3, [r0], #-1645	; 0xfffff993
    1f30:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f34:	50435f54 	subpl	r5, r3, r4, asr pc
    1f38:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1f3c:	5400376d 	strpl	r3, [r0], #-1901	; 0xfffff893
    1f40:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f44:	50435f54 	subpl	r5, r3, r4, asr pc
    1f48:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1f4c:	5400386d 	strpl	r3, [r0], #-2157	; 0xfffff793
    1f50:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f54:	50435f54 	subpl	r5, r3, r4, asr pc
    1f58:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1f5c:	5400396d 	strpl	r3, [r0], #-2413	; 0xfffff693
    1f60:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f64:	50435f54 	subpl	r5, r3, r4, asr pc
    1f68:	61665f55 	cmnvs	r6, r5, asr pc
    1f6c:	00363236 	eorseq	r3, r6, r6, lsr r2
    1f70:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f74:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f78:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1f7c:	6e5f6d72 	mrcvs	13, 2, r6, cr15, cr2, {3}
    1f80:	00656e6f 	rsbeq	r6, r5, pc, ror #28
    1f84:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    1f88:	6e6f6c20 	cdpvs	12, 6, cr6, cr15, cr0, {1}
    1f8c:	6e752067 	cdpvs	0, 7, cr2, cr5, cr7, {3}
    1f90:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    1f94:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
    1f98:	6100746e 	tstvs	r0, lr, ror #8
    1f9c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1fa0:	5f686372 	svcpl	0x00686372
    1fa4:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    1fa8:	52415400 	subpl	r5, r1, #0, 8
    1fac:	5f544547 	svcpl	0x00544547
    1fb0:	5f555043 	svcpl	0x00555043
    1fb4:	366d7261 	strbtcc	r7, [sp], -r1, ror #4
    1fb8:	54003031 	strpl	r3, [r0], #-49	; 0xffffffcf
    1fbc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1fc0:	50435f54 	subpl	r5, r3, r4, asr pc
    1fc4:	6f635f55 	svcvs	0x00635f55
    1fc8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1fcc:	5400346d 	strpl	r3, [r0], #-1133	; 0xfffffb93
    1fd0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1fd4:	50435f54 	subpl	r5, r3, r4, asr pc
    1fd8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1fdc:	6530316d 	ldrvs	r3, [r0, #-365]!	; 0xfffffe93
    1fe0:	52415400 	subpl	r5, r1, #0, 8
    1fe4:	5f544547 	svcpl	0x00544547
    1fe8:	5f555043 	svcpl	0x00555043
    1fec:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1ff0:	376d7865 	strbcc	r7, [sp, -r5, ror #16]!
    1ff4:	52415400 	subpl	r5, r1, #0, 8
    1ff8:	5f544547 	svcpl	0x00544547
    1ffc:	5f555043 	svcpl	0x00555043
    2000:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    2004:	66303035 			; <UNDEFINED> instruction: 0x66303035
    2008:	41540065 	cmpmi	r4, r5, rrx
    200c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2010:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2014:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2018:	63303137 	teqvs	r0, #-1073741811	; 0xc000000d
    201c:	6d726100 	ldfvse	f6, [r2, #-0]
    2020:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    2024:	6f635f64 	svcvs	0x00635f64
    2028:	41006564 	tstmi	r0, r4, ror #10
    202c:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    2030:	415f5343 	cmpmi	pc, r3, asr #6
    2034:	53435041 	movtpl	r5, #12353	; 0x3041
    2038:	61736900 	cmnvs	r3, r0, lsl #18
    203c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2040:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2044:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
    2048:	53414200 	movtpl	r4, #4608	; 0x1200
    204c:	52415f45 	subpl	r5, r1, #276	; 0x114
    2050:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    2054:	4154004d 	cmpmi	r4, sp, asr #32
    2058:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    205c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2060:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2064:	74303137 	ldrtvc	r3, [r0], #-311	; 0xfffffec9
    2068:	6d726100 	ldfvse	f6, [r2, #-0]
    206c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2070:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    2074:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    2078:	73690032 	cmnvc	r9, #50	; 0x32
    207c:	756e5f61 	strbvc	r5, [lr, #-3937]!	; 0xfffff09f
    2080:	69625f6d 	stmdbvs	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    2084:	54007374 	strpl	r7, [r0], #-884	; 0xfffffc8c
    2088:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    208c:	50435f54 	subpl	r5, r3, r4, asr pc
    2090:	6f635f55 	svcvs	0x00635f55
    2094:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2098:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    209c:	6d737375 	ldclvs	3, cr7, [r3, #-468]!	; 0xfffffe2c
    20a0:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    20a4:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    20a8:	00796c70 	rsbseq	r6, r9, r0, ror ip
    20ac:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20b0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20b4:	655f5550 	ldrbvs	r5, [pc, #-1360]	; 1b6c <shift+0x1b6c>
    20b8:	6f6e7978 	svcvs	0x006e7978
    20bc:	00316d73 	eorseq	r6, r1, r3, ror sp
    20c0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20c4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20c8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    20cc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    20d0:	32357278 	eorscc	r7, r5, #120, 4	; 0x80000007
    20d4:	61736900 	cmnvs	r3, r0, lsl #18
    20d8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    20dc:	6964745f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
    20e0:	72700076 	rsbsvc	r0, r0, #118	; 0x76
    20e4:	72656665 	rsbvc	r6, r5, #105906176	; 0x6500000
    20e8:	6f656e5f 	svcvs	0x00656e5f
    20ec:	6f665f6e 	svcvs	0x00665f6e
    20f0:	34365f72 	ldrtcc	r5, [r6], #-3954	; 0xfffff08e
    20f4:	73746962 	cmnvc	r4, #1605632	; 0x188000
    20f8:	61736900 	cmnvs	r3, r0, lsl #18
    20fc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2100:	3170665f 	cmncc	r0, pc, asr r6
    2104:	6c6d6636 	stclvs	6, cr6, [sp], #-216	; 0xffffff28
    2108:	52415400 	subpl	r5, r1, #0, 8
    210c:	5f544547 	svcpl	0x00544547
    2110:	5f555043 	svcpl	0x00555043
    2114:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2118:	33617865 	cmncc	r1, #6619136	; 0x650000
    211c:	41540032 	cmpmi	r4, r2, lsr r0
    2120:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2124:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2128:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    212c:	00303236 	eorseq	r3, r0, r6, lsr r2
    2130:	5f617369 	svcpl	0x00617369
    2134:	5f746962 	svcpl	0x00746962
    2138:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    213c:	766e6f63 	strbtvc	r6, [lr], -r3, ror #30
    2140:	736e7500 	cmnvc	lr, #0, 10
    2144:	76636570 			; <UNDEFINED> instruction: 0x76636570
    2148:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    214c:	73676e69 	cmnvc	r7, #1680	; 0x690
    2150:	52415400 	subpl	r5, r1, #0, 8
    2154:	5f544547 	svcpl	0x00544547
    2158:	5f555043 	svcpl	0x00555043
    215c:	316d7261 	cmncc	sp, r1, ror #4
    2160:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    2164:	54007332 	strpl	r7, [r0], #-818	; 0xfffffcce
    2168:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    216c:	50435f54 	subpl	r5, r3, r4, asr pc
    2170:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2174:	3230316d 	eorscc	r3, r0, #1073741851	; 0x4000001b
    2178:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    217c:	6d726100 	ldfvse	f6, [r2, #-0]
    2180:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2184:	006d3368 	rsbeq	r3, sp, r8, ror #6
    2188:	47524154 			; <UNDEFINED> instruction: 0x47524154
    218c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2190:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    2194:	36303661 	ldrtcc	r3, [r0], -r1, ror #12
    2198:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    219c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21a0:	50435f54 	subpl	r5, r3, r4, asr pc
    21a4:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    21a8:	3632396d 	ldrtcc	r3, [r2], -sp, ror #18
    21ac:	00736a65 	rsbseq	r6, r3, r5, ror #20
    21b0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    21b4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    21b8:	54345f48 	ldrtpl	r5, [r4], #-3912	; 0xfffff0b8
    21bc:	61736900 	cmnvs	r3, r0, lsl #18
    21c0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    21c4:	7972635f 	ldmdbvc	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
    21c8:	006f7470 	rsbeq	r7, pc, r0, ror r4	; <UNPREDICTABLE>
    21cc:	5f6d7261 	svcpl	0x006d7261
    21d0:	73676572 	cmnvc	r7, #478150656	; 0x1c800000
    21d4:	5f6e695f 	svcpl	0x006e695f
    21d8:	75716573 	ldrbvc	r6, [r1, #-1395]!	; 0xfffffa8d
    21dc:	65636e65 	strbvs	r6, [r3, #-3685]!	; 0xfffff19b
    21e0:	53414200 	movtpl	r4, #4608	; 0x1200
    21e4:	52415f45 	subpl	r5, r1, #276	; 0x114
    21e8:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 19ad <shift+0x19ad>
    21ec:	54004554 	strpl	r4, [r0], #-1364	; 0xfffffaac
    21f0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21f4:	50435f54 	subpl	r5, r3, r4, asr pc
    21f8:	70655f55 	rsbvc	r5, r5, r5, asr pc
    21fc:	32313339 	eorscc	r3, r1, #-469762048	; 0xe4000000
    2200:	61736900 	cmnvs	r3, r0, lsl #18
    2204:	6165665f 	cmnvs	r5, pc, asr r6
    2208:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    220c:	61736900 	cmnvs	r3, r0, lsl #18
    2210:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2214:	616d735f 	cmnvs	sp, pc, asr r3
    2218:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    221c:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    2220:	616c5f6d 	cmnvs	ip, sp, ror #30
    2224:	6f5f676e 	svcvs	0x005f676e
    2228:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
    222c:	626f5f74 	rsbvs	r5, pc, #116, 30	; 0x1d0
    2230:	7463656a 	strbtvc	r6, [r3], #-1386	; 0xfffffa96
    2234:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    2238:	75626972 	strbvc	r6, [r2, #-2418]!	; 0xfffff68e
    223c:	5f736574 	svcpl	0x00736574
    2240:	6b6f6f68 	blvs	1bddfe8 <__bss_end+0x1bd20e0>
    2244:	61736900 	cmnvs	r3, r0, lsl #18
    2248:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    224c:	5f70665f 	svcpl	0x0070665f
    2250:	00323364 	eorseq	r3, r2, r4, ror #6
    2254:	5f4d5241 	svcpl	0x004d5241
    2258:	6900454e 	stmdbvs	r0, {r1, r2, r3, r6, r8, sl, lr}
    225c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2260:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
    2264:	54003865 	strpl	r3, [r0], #-2149	; 0xfffff79b
    2268:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    226c:	50435f54 	subpl	r5, r3, r4, asr pc
    2270:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2274:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    2278:	737a6a36 	cmnvc	sl, #221184	; 0x36000
    227c:	53414200 	movtpl	r4, #4608	; 0x1200
    2280:	52415f45 	subpl	r5, r1, #276	; 0x114
    2284:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 1a49 <shift+0x1a49>
    2288:	73690045 	cmnvc	r9, #69	; 0x45
    228c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2290:	64615f74 	strbtvs	r5, [r1], #-3956	; 0xfffff08c
    2294:	70007669 	andvc	r7, r0, r9, ror #12
    2298:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    229c:	726f7373 	rsbvc	r7, pc, #-872415231	; 0xcc000001
    22a0:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    22a4:	6c610065 	stclvs	0, cr0, [r1], #-404	; 0xfffffe6c
    22a8:	70665f6c 	rsbvc	r5, r6, ip, ror #30
    22ac:	61007375 	tstvs	r0, r5, ror r3
    22b0:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    22b4:	42007363 	andmi	r7, r0, #-1946157055	; 0x8c000001
    22b8:	5f455341 	svcpl	0x00455341
    22bc:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    22c0:	0054355f 	subseq	r3, r4, pc, asr r5
    22c4:	5f6d7261 	svcpl	0x006d7261
    22c8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    22cc:	54007434 	strpl	r7, [r0], #-1076	; 0xfffffbcc
    22d0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    22d4:	50435f54 	subpl	r5, r3, r4, asr pc
    22d8:	6f635f55 	svcvs	0x00635f55
    22dc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    22e0:	63353161 	teqvs	r5, #1073741848	; 0x40000018
    22e4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    22e8:	00376178 	eorseq	r6, r7, r8, ror r1
    22ec:	5f6d7261 	svcpl	0x006d7261
    22f0:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    22f4:	7562775f 	strbvc	r7, [r2, #-1887]!	; 0xfffff8a1
    22f8:	74680066 	strbtvc	r0, [r8], #-102	; 0xffffff9a
    22fc:	685f6261 	ldmdavs	pc, {r0, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    2300:	00687361 	rsbeq	r7, r8, r1, ror #6
    2304:	5f617369 	svcpl	0x00617369
    2308:	5f746962 	svcpl	0x00746962
    230c:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    2310:	6f6e5f6b 	svcvs	0x006e5f6b
    2314:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 21a0 <shift+0x21a0>
    2318:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    231c:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    2320:	52415400 	subpl	r5, r1, #0, 8
    2324:	5f544547 	svcpl	0x00544547
    2328:	5f555043 	svcpl	0x00555043
    232c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2330:	306d7865 	rsbcc	r7, sp, r5, ror #16
    2334:	52415400 	subpl	r5, r1, #0, 8
    2338:	5f544547 	svcpl	0x00544547
    233c:	5f555043 	svcpl	0x00555043
    2340:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2344:	316d7865 	cmncc	sp, r5, ror #16
    2348:	52415400 	subpl	r5, r1, #0, 8
    234c:	5f544547 	svcpl	0x00544547
    2350:	5f555043 	svcpl	0x00555043
    2354:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2358:	336d7865 	cmncc	sp, #6619136	; 0x650000
    235c:	61736900 	cmnvs	r3, r0, lsl #18
    2360:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2364:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2368:	315f3876 	cmpcc	pc, r6, ror r8	; <UNPREDICTABLE>
    236c:	6d726100 	ldfvse	f6, [r2, #-0]
    2370:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2374:	616e5f68 	cmnvs	lr, r8, ror #30
    2378:	6900656d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, sl, sp, lr}
    237c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2380:	615f7469 	cmpvs	pc, r9, ror #8
    2384:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    2388:	6900335f 	stmdbvs	r0, {r0, r1, r2, r3, r4, r6, r8, r9, ip, sp}
    238c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2390:	615f7469 	cmpvs	pc, r9, ror #8
    2394:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    2398:	5400345f 	strpl	r3, [r0], #-1119	; 0xfffffba1
    239c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    23a0:	50435f54 	subpl	r5, r3, r4, asr pc
    23a4:	6f635f55 	svcvs	0x00635f55
    23a8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    23ac:	00333561 	eorseq	r3, r3, r1, ror #10
    23b0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    23b4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    23b8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    23bc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    23c0:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    23c4:	52415400 	subpl	r5, r1, #0, 8
    23c8:	5f544547 	svcpl	0x00544547
    23cc:	5f555043 	svcpl	0x00555043
    23d0:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    23d4:	00696d64 	rsbeq	r6, r9, r4, ror #26
    23d8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    23dc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    23e0:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 22a8 <shift+0x22a8>
    23e4:	726f6370 	rsbvc	r6, pc, #112, 6	; 0xc0000001
    23e8:	73690065 	cmnvc	r9, #101	; 0x65
    23ec:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    23f0:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    23f4:	6d33766d 	ldcvs	6, cr7, [r3, #-436]!	; 0xfffffe4c
    23f8:	6d726100 	ldfvse	f6, [r2, #-0]
    23fc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2400:	6f6e5f68 	svcvs	0x006e5f68
    2404:	61006d74 	tstvs	r0, r4, ror sp
    2408:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    240c:	35686372 	strbcc	r6, [r8, #-882]!	; 0xfffffc8e
    2410:	41540065 	cmpmi	r4, r5, rrx
    2414:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2418:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    241c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2420:	30323031 	eorscc	r3, r2, r1, lsr r0
    2424:	41420065 	cmpmi	r2, r5, rrx
    2428:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    242c:	5f484352 	svcpl	0x00484352
    2430:	54004a36 	strpl	r4, [r0], #-2614	; 0xfffff5ca
    2434:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2438:	50435f54 	subpl	r5, r3, r4, asr pc
    243c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2440:	3836396d 	ldmdacc	r6!, {r0, r2, r3, r5, r6, r8, fp, ip, sp}
    2444:	54007365 	strpl	r7, [r0], #-869	; 0xfffffc9b
    2448:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    244c:	50435f54 	subpl	r5, r3, r4, asr pc
    2450:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2454:	3034376d 	eorscc	r3, r4, sp, ror #14
    2458:	41420074 	hvcmi	8196	; 0x2004
    245c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2460:	5f484352 	svcpl	0x00484352
    2464:	69004d36 	stmdbvs	r0, {r1, r2, r4, r5, r8, sl, fp, lr}
    2468:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    246c:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    2470:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    2474:	41540074 	cmpmi	r4, r4, ror r0
    2478:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    247c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2480:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2484:	00303037 	eorseq	r3, r0, r7, lsr r0
    2488:	47524154 			; <UNDEFINED> instruction: 0x47524154
    248c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2490:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2494:	31316d72 	teqcc	r1, r2, ror sp
    2498:	666a3633 			; <UNDEFINED> instruction: 0x666a3633
    249c:	52410073 	subpl	r0, r1, #115	; 0x73
    24a0:	534c5f4d 	movtpl	r5, #53069	; 0xcf4d
    24a4:	52415400 	subpl	r5, r1, #0, 8
    24a8:	5f544547 	svcpl	0x00544547
    24ac:	5f555043 	svcpl	0x00555043
    24b0:	316d7261 	cmncc	sp, r1, ror #4
    24b4:	74303230 	ldrtvc	r3, [r0], #-560	; 0xfffffdd0
    24b8:	53414200 	movtpl	r4, #4608	; 0x1200
    24bc:	52415f45 	subpl	r5, r1, #276	; 0x114
    24c0:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    24c4:	4154005a 	cmpmi	r4, sl, asr r0
    24c8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    24cc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    24d0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    24d4:	61786574 	cmnvs	r8, r4, ror r5
    24d8:	6f633537 	svcvs	0x00633537
    24dc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    24e0:	00353561 	eorseq	r3, r5, r1, ror #10
    24e4:	5f4d5241 	svcpl	0x004d5241
    24e8:	5f534350 	svcpl	0x00534350
    24ec:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    24f0:	46565f53 	usaxmi	r5, r6, r3
    24f4:	41540050 	cmpmi	r4, r0, asr r0
    24f8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    24fc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2500:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    2504:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    2508:	61736900 	cmnvs	r3, r0, lsl #18
    250c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2510:	6f656e5f 	svcvs	0x00656e5f
    2514:	7261006e 	rsbvc	r0, r1, #110	; 0x6e
    2518:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    251c:	74615f75 	strbtvc	r5, [r1], #-3957	; 0xfffff08b
    2520:	69007274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp, lr}
    2524:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2528:	615f7469 	cmpvs	pc, r9, ror #8
    252c:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    2530:	54006d65 	strpl	r6, [r0], #-3429	; 0xfffff29b
    2534:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2538:	50435f54 	subpl	r5, r3, r4, asr pc
    253c:	61665f55 	cmnvs	r6, r5, asr pc
    2540:	74363236 	ldrtvc	r3, [r6], #-566	; 0xfffffdca
    2544:	41540065 	cmpmi	r4, r5, rrx
    2548:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    254c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2550:	72616d5f 	rsbvc	r6, r1, #6080	; 0x17c0
    2554:	6c6c6576 	cfstr64vs	mvdx6, [ip], #-472	; 0xfffffe28
    2558:	346a705f 	strbtcc	r7, [sl], #-95	; 0xffffffa1
    255c:	61746800 	cmnvs	r4, r0, lsl #16
    2560:	61685f62 	cmnvs	r8, r2, ror #30
    2564:	705f6873 	subsvc	r6, pc, r3, ror r8	; <UNPREDICTABLE>
    2568:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    256c:	54007265 	strpl	r7, [r0], #-613	; 0xfffffd9b
    2570:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2574:	50435f54 	subpl	r5, r3, r4, asr pc
    2578:	6f635f55 	svcvs	0x00635f55
    257c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2580:	00353361 	eorseq	r3, r5, r1, ror #6
    2584:	5f6d7261 	svcpl	0x006d7261
    2588:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    258c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2590:	5f786574 	svcpl	0x00786574
    2594:	69003961 	stmdbvs	r0, {r0, r5, r6, r8, fp, ip, sp}
    2598:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    259c:	695f7469 	ldmdbvs	pc, {r0, r3, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    25a0:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    25a4:	54003274 	strpl	r3, [r0], #-628	; 0xfffffd8c
    25a8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    25ac:	50435f54 	subpl	r5, r3, r4, asr pc
    25b0:	6f635f55 	svcvs	0x00635f55
    25b4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    25b8:	63323761 	teqvs	r2, #25427968	; 0x1840000
    25bc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    25c0:	33356178 	teqcc	r5, #120, 2
    25c4:	61736900 	cmnvs	r3, r0, lsl #18
    25c8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    25cc:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    25d0:	0032626d 	eorseq	r6, r2, sp, ror #4
    25d4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    25d8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    25dc:	41375f48 	teqmi	r7, r8, asr #30
    25e0:	61736900 	cmnvs	r3, r0, lsl #18
    25e4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    25e8:	746f645f 	strbtvc	r6, [pc], #-1119	; 25f0 <shift+0x25f0>
    25ec:	646f7270 	strbtvs	r7, [pc], #-624	; 25f4 <shift+0x25f4>
    25f0:	53414200 	movtpl	r4, #4608	; 0x1200
    25f4:	52415f45 	subpl	r5, r1, #276	; 0x114
    25f8:	305f4843 	subscc	r4, pc, r3, asr #16
    25fc:	6d726100 	ldfvse	f6, [r2, #-0]
    2600:	3170665f 	cmncc	r0, pc, asr r6
    2604:	79745f36 	ldmdbvc	r4!, {r1, r2, r4, r5, r8, r9, sl, fp, ip, lr}^
    2608:	6e5f6570 	mrcvs	5, 2, r6, cr15, cr0, {3}
    260c:	0065646f 	rsbeq	r6, r5, pc, ror #8
    2610:	5f4d5241 	svcpl	0x004d5241
    2614:	6100494d 	tstvs	r0, sp, asr #18
    2618:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    261c:	36686372 			; <UNDEFINED> instruction: 0x36686372
    2620:	7261006b 	rsbvc	r0, r1, #107	; 0x6b
    2624:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2628:	6d366863 	ldcvs	8, cr6, [r6, #-396]!	; 0xfffffe74
    262c:	53414200 	movtpl	r4, #4608	; 0x1200
    2630:	52415f45 	subpl	r5, r1, #276	; 0x114
    2634:	345f4843 	ldrbcc	r4, [pc], #-2115	; 263c <shift+0x263c>
    2638:	53414200 	movtpl	r4, #4608	; 0x1200
    263c:	52415f45 	subpl	r5, r1, #276	; 0x114
    2640:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    2644:	5f5f0052 	svcpl	0x005f0052
    2648:	63706f70 	cmnvs	r0, #112, 30	; 0x1c0
    264c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    2650:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    2654:	61736900 	cmnvs	r3, r0, lsl #18
    2658:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    265c:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    2660:	41540065 	cmpmi	r4, r5, rrx
    2664:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2668:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    266c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2670:	61786574 	cmnvs	r8, r4, ror r5
    2674:	54003337 	strpl	r3, [r0], #-823	; 0xfffffcc9
    2678:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    267c:	50435f54 	subpl	r5, r3, r4, asr pc
    2680:	65675f55 	strbvs	r5, [r7, #-3925]!	; 0xfffff0ab
    2684:	6972656e 	ldmdbvs	r2!, {r1, r2, r3, r5, r6, r8, sl, sp, lr}^
    2688:	61377663 	teqvs	r7, r3, ror #12
    268c:	61736900 	cmnvs	r3, r0, lsl #18
    2690:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2694:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2698:	00653576 	rsbeq	r3, r5, r6, ror r5
    269c:	5f6d7261 	svcpl	0x006d7261
    26a0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    26a4:	5f6f6e5f 	svcpl	0x006f6e5f
    26a8:	616c6f76 	smcvs	50934	; 0xc6f6
    26ac:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    26b0:	0065635f 	rsbeq	r6, r5, pc, asr r3
    26b4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    26b8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    26bc:	41385f48 	teqmi	r8, r8, asr #30
    26c0:	52415400 	subpl	r5, r1, #0, 8
    26c4:	5f544547 	svcpl	0x00544547
    26c8:	5f555043 	svcpl	0x00555043
    26cc:	316d7261 	cmncc	sp, r1, ror #4
    26d0:	65323230 	ldrvs	r3, [r2, #-560]!	; 0xfffffdd0
    26d4:	53414200 	movtpl	r4, #4608	; 0x1200
    26d8:	52415f45 	subpl	r5, r1, #276	; 0x114
    26dc:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    26e0:	41540052 	cmpmi	r4, r2, asr r0
    26e4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    26e8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    26ec:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    26f0:	61786574 	cmnvs	r8, r4, ror r5
    26f4:	6f633337 	svcvs	0x00633337
    26f8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    26fc:	00353361 	eorseq	r3, r5, r1, ror #6
    2700:	5f4d5241 	svcpl	0x004d5241
    2704:	6100564e 	tstvs	r0, lr, asr #12
    2708:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    270c:	34686372 	strbtcc	r6, [r8], #-882	; 0xfffffc8e
    2710:	6d726100 	ldfvse	f6, [r2, #-0]
    2714:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2718:	61003568 	tstvs	r0, r8, ror #10
    271c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2720:	37686372 			; <UNDEFINED> instruction: 0x37686372
    2724:	6d726100 	ldfvse	f6, [r2, #-0]
    2728:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    272c:	6c003868 	stcvs	8, cr3, [r0], {104}	; 0x68
    2730:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    2734:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    2738:	4200656c 	andmi	r6, r0, #108, 10	; 0x1b000000
    273c:	5f455341 	svcpl	0x00455341
    2740:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2744:	004b365f 	subeq	r3, fp, pc, asr r6
    2748:	47524154 			; <UNDEFINED> instruction: 0x47524154
    274c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2750:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2754:	34396d72 	ldrtcc	r6, [r9], #-3442	; 0xfffff28e
    2758:	61007430 	tstvs	r0, r0, lsr r4
    275c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2760:	36686372 			; <UNDEFINED> instruction: 0x36686372
    2764:	6d726100 	ldfvse	f6, [r2, #-0]
    2768:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    276c:	73785f65 	cmnvc	r8, #404	; 0x194
    2770:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    2774:	52415400 	subpl	r5, r1, #0, 8
    2778:	5f544547 	svcpl	0x00544547
    277c:	5f555043 	svcpl	0x00555043
    2780:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    2784:	00303035 	eorseq	r3, r0, r5, lsr r0
    2788:	696b616d 	stmdbvs	fp!, {r0, r2, r3, r5, r6, r8, sp, lr}^
    278c:	635f676e 	cmpvs	pc, #28835840	; 0x1b80000
    2790:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
    2794:	6261745f 	rsbvs	r7, r1, #1593835520	; 0x5f000000
    2798:	7400656c 	strvc	r6, [r0], #-1388	; 0xfffffa94
    279c:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    27a0:	6c61635f 	stclvs	3, cr6, [r1], #-380	; 0xfffffe84
    27a4:	69765f6c 	ldmdbvs	r6!, {r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    27a8:	616c5f61 	cmnvs	ip, r1, ror #30
    27ac:	006c6562 	rsbeq	r6, ip, r2, ror #10
    27b0:	5f617369 	svcpl	0x00617369
    27b4:	5f746962 	svcpl	0x00746962
    27b8:	35767066 	ldrbcc	r7, [r6, #-102]!	; 0xffffff9a
    27bc:	52415400 	subpl	r5, r1, #0, 8
    27c0:	5f544547 	svcpl	0x00544547
    27c4:	5f555043 	svcpl	0x00555043
    27c8:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    27cc:	69003031 	stmdbvs	r0, {r0, r4, r5, ip, sp}
    27d0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    27d4:	615f7469 	cmpvs	pc, r9, ror #8
    27d8:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    27dc:	4154006b 	cmpmi	r4, fp, rrx
    27e0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    27e4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    27e8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    27ec:	61786574 	cmnvs	r8, r4, ror r5
    27f0:	41540037 	cmpmi	r4, r7, lsr r0
    27f4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    27f8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    27fc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2800:	61786574 	cmnvs	r8, r4, ror r5
    2804:	41540038 	cmpmi	r4, r8, lsr r0
    2808:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    280c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2810:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2814:	61786574 	cmnvs	r8, r4, ror r5
    2818:	52410039 	subpl	r0, r1, #57	; 0x39
    281c:	43505f4d 	cmpmi	r0, #308	; 0x134
    2820:	50415f53 	subpl	r5, r1, r3, asr pc
    2824:	41005343 	tstmi	r0, r3, asr #6
    2828:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    282c:	415f5343 	cmpmi	pc, r3, asr #6
    2830:	53435054 	movtpl	r5, #12372	; 0x3054
    2834:	52415400 	subpl	r5, r1, #0, 8
    2838:	5f544547 	svcpl	0x00544547
    283c:	5f555043 	svcpl	0x00555043
    2840:	366d7261 	strbtcc	r7, [sp], -r1, ror #4
    2844:	54003030 	strpl	r3, [r0], #-48	; 0xffffffd0
    2848:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    284c:	50435f54 	subpl	r5, r3, r4, asr pc
    2850:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2854:	3032376d 	eorscc	r3, r2, sp, ror #14
    2858:	41540074 	cmpmi	r4, r4, ror r0
    285c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2860:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2864:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2868:	61786574 	cmnvs	r8, r4, ror r5
    286c:	63003735 	movwvs	r3, #1845	; 0x735
    2870:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    2874:	64207865 	strtvs	r7, [r0], #-2149	; 0xfffff79b
    2878:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    287c:	41540065 	cmpmi	r4, r5, rrx
    2880:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2884:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2888:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    288c:	61786574 	cmnvs	r8, r4, ror r5
    2890:	6f633337 	svcvs	0x00633337
    2894:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2898:	00333561 	eorseq	r3, r3, r1, ror #10
    289c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    28a0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    28a4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    28a8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    28ac:	70306d78 	eorsvc	r6, r0, r8, ror sp
    28b0:	0073756c 	rsbseq	r7, r3, ip, ror #10
    28b4:	5f6d7261 	svcpl	0x006d7261
    28b8:	69006363 	stmdbvs	r0, {r0, r1, r5, r6, r8, r9, sp, lr}
    28bc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    28c0:	6d5f7469 	cfldrdvs	mvd7, [pc, #-420]	; 2724 <shift+0x2724>
    28c4:	3265646f 	rsbcc	r6, r5, #1862270976	; 0x6f000000
    28c8:	73690036 	cmnvc	r9, #54	; 0x36
    28cc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    28d0:	73785f74 	cmnvc	r8, #116, 30	; 0x1d0
    28d4:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    28d8:	52415400 	subpl	r5, r1, #0, 8
    28dc:	5f544547 	svcpl	0x00544547
    28e0:	5f555043 	svcpl	0x00555043
    28e4:	6f727473 	svcvs	0x00727473
    28e8:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    28ec:	3031316d 	eorscc	r3, r1, sp, ror #2
    28f0:	41540030 	cmpmi	r4, r0, lsr r0
    28f4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    28f8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    28fc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2900:	6d647437 	cfstrdvs	mvd7, [r4, #-220]!	; 0xffffff24
    2904:	5f007369 	svcpl	0x00007369
    2908:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    290c:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    2910:	6572745f 	ldrbvs	r7, [r2, #-1119]!	; 0xfffffba1
    2914:	65685f65 	strbvs	r5, [r8, #-3941]!	; 0xfffff09b
    2918:	005f6572 	subseq	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    291c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2920:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2924:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2928:	30316d72 	eorscc	r6, r1, r2, ror sp
    292c:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    2930:	52415400 	subpl	r5, r1, #0, 8
    2934:	5f544547 	svcpl	0x00544547
    2938:	5f555043 	svcpl	0x00555043
    293c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2940:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2944:	73616200 	cmnvc	r1, #0, 4
    2948:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    294c:	74696863 	strbtvc	r6, [r9], #-2147	; 0xfffff79d
    2950:	75746365 	ldrbvc	r6, [r4, #-869]!	; 0xfffffc9b
    2954:	61006572 	tstvs	r0, r2, ror r5
    2958:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    295c:	5f686372 	svcpl	0x00686372
    2960:	00637263 	rsbeq	r7, r3, r3, ror #4
    2964:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2968:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    296c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2970:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2974:	73316d78 	teqvc	r1, #120, 26	; 0x1e00
    2978:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    297c:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    2980:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    2984:	6d726100 	ldfvse	f6, [r2, #-0]
    2988:	7275635f 	rsbsvc	r6, r5, #2080374785	; 0x7c000001
    298c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    2990:	0063635f 	rsbeq	r6, r3, pc, asr r3
    2994:	5f6d7261 	svcpl	0x006d7261
    2998:	67726174 			; <UNDEFINED> instruction: 0x67726174
    299c:	695f7465 	ldmdbvs	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    29a0:	006e736e 	rsbeq	r7, lr, lr, ror #6
    29a4:	5f617369 	svcpl	0x00617369
    29a8:	5f746962 	svcpl	0x00746962
    29ac:	33637263 	cmncc	r3, #805306374	; 0x30000006
    29b0:	52410032 	subpl	r0, r1, #50	; 0x32
    29b4:	4c505f4d 	mrrcmi	15, 4, r5, r0, cr13
    29b8:	61736900 	cmnvs	r3, r0, lsl #18
    29bc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    29c0:	7066765f 	rsbvc	r7, r6, pc, asr r6
    29c4:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
    29c8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    29cc:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    29d0:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
    29d4:	53414200 	movtpl	r4, #4608	; 0x1200
    29d8:	52415f45 	subpl	r5, r1, #276	; 0x114
    29dc:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    29e0:	42003254 	andmi	r3, r0, #84, 4	; 0x40000005
    29e4:	5f455341 	svcpl	0x00455341
    29e8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    29ec:	5f4d385f 	svcpl	0x004d385f
    29f0:	4e49414d 	dvfmiem	f4, f1, #5.0
    29f4:	52415400 	subpl	r5, r1, #0, 8
    29f8:	5f544547 	svcpl	0x00544547
    29fc:	5f555043 	svcpl	0x00555043
    2a00:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    2a04:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    2a08:	4d524100 	ldfmie	f4, [r2, #-0]
    2a0c:	004c415f 	subeq	r4, ip, pc, asr r1
    2a10:	5f617369 	svcpl	0x00617369
    2a14:	5f746962 	svcpl	0x00746962
    2a18:	65646f6d 	strbvs	r6, [r4, #-3949]!	; 0xfffff093
    2a1c:	42003233 	andmi	r3, r0, #805306371	; 0x30000003
    2a20:	5f455341 	svcpl	0x00455341
    2a24:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2a28:	004d375f 	subeq	r3, sp, pc, asr r7
    2a2c:	5f6d7261 	svcpl	0x006d7261
    2a30:	67726174 			; <UNDEFINED> instruction: 0x67726174
    2a34:	6c5f7465 	cfldrdvs	mvd7, [pc], {101}	; 0x65
    2a38:	6c656261 	sfmvs	f6, 2, [r5], #-388	; 0xfffffe7c
    2a3c:	52415400 	subpl	r5, r1, #0, 8
    2a40:	5f544547 	svcpl	0x00544547
    2a44:	5f555043 	svcpl	0x00555043
    2a48:	6f727473 	svcvs	0x00727473
    2a4c:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    2a50:	3131316d 	teqcc	r1, sp, ror #2
    2a54:	41540030 	cmpmi	r4, r0, lsr r0
    2a58:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2a5c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2a60:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2a64:	00303237 	eorseq	r3, r0, r7, lsr r2
    2a68:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2a6c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2a70:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2a74:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2a78:	00347278 	eorseq	r7, r4, r8, ror r2
    2a7c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2a80:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2a84:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2a88:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2a8c:	00357278 	eorseq	r7, r5, r8, ror r2
    2a90:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2a94:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2a98:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2a9c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2aa0:	00377278 	eorseq	r7, r7, r8, ror r2
    2aa4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2aa8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2aac:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2ab0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2ab4:	00387278 	eorseq	r7, r8, r8, ror r2
    2ab8:	5f617369 	svcpl	0x00617369
    2abc:	5f746962 	svcpl	0x00746962
    2ac0:	6561706c 	strbvs	r7, [r1, #-108]!	; 0xffffff94
    2ac4:	52415400 	subpl	r5, r1, #0, 8
    2ac8:	5f544547 	svcpl	0x00544547
    2acc:	5f555043 	svcpl	0x00555043
    2ad0:	6f727473 	svcvs	0x00727473
    2ad4:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    2ad8:	3031316d 	eorscc	r3, r1, sp, ror #2
    2adc:	61736900 	cmnvs	r3, r0, lsl #18
    2ae0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2ae4:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    2ae8:	615f6b72 	cmpvs	pc, r2, ror fp	; <UNPREDICTABLE>
    2aec:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    2af0:	69007a6b 	stmdbvs	r0, {r0, r1, r3, r5, r6, r9, fp, ip, sp, lr}
    2af4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2af8:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    2afc:	006d746f 	rsbeq	r7, sp, pc, ror #8
    2b00:	5f617369 	svcpl	0x00617369
    2b04:	5f746962 	svcpl	0x00746962
    2b08:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2b0c:	73690034 	cmnvc	r9, #52	; 0x34
    2b10:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2b14:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2b18:	0035766d 	eorseq	r7, r5, sp, ror #12
    2b1c:	5f617369 	svcpl	0x00617369
    2b20:	5f746962 	svcpl	0x00746962
    2b24:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2b28:	73690036 	cmnvc	r9, #54	; 0x36
    2b2c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2b30:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2b34:	0037766d 	eorseq	r7, r7, sp, ror #12
    2b38:	5f617369 	svcpl	0x00617369
    2b3c:	5f746962 	svcpl	0x00746962
    2b40:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2b44:	645f0038 	ldrbvs	r0, [pc], #-56	; 2b4c <shift+0x2b4c>
    2b48:	5f746e6f 	svcpl	0x00746e6f
    2b4c:	5f657375 	svcpl	0x00657375
    2b50:	5f787472 	svcpl	0x00787472
    2b54:	65726568 	ldrbvs	r6, [r2, #-1384]!	; 0xfffffa98
    2b58:	5155005f 	cmppl	r5, pc, asr r0
    2b5c:	70797449 	rsbsvc	r7, r9, r9, asr #8
    2b60:	72610065 	rsbvc	r0, r1, #101	; 0x65
    2b64:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    2b68:	6100656e 	tstvs	r0, lr, ror #10
    2b6c:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    2b70:	695f7070 	ldmdbvs	pc, {r4, r5, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    2b74:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    2b78:	6b726f77 	blvs	1c9e95c <__bss_end+0x1c92a54>
    2b7c:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
    2b80:	74705f63 	ldrbtvc	r5, [r0], #-3939	; 0xfffff09d
    2b84:	41540072 	cmpmi	r4, r2, ror r0
    2b88:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2b8c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2b90:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2b94:	74303239 	ldrtvc	r3, [r0], #-569	; 0xfffffdc7
    2b98:	61746800 	cmnvs	r4, r0, lsl #16
    2b9c:	71655f62 	cmnvc	r5, r2, ror #30
    2ba0:	52415400 	subpl	r5, r1, #0, 8
    2ba4:	5f544547 	svcpl	0x00544547
    2ba8:	5f555043 	svcpl	0x00555043
    2bac:	32356166 	eorscc	r6, r5, #-2147483623	; 0x80000019
    2bb0:	72610036 	rsbvc	r0, r1, #54	; 0x36
    2bb4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2bb8:	745f6863 	ldrbvc	r6, [pc], #-2147	; 2bc0 <shift+0x2bc0>
    2bbc:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    2bc0:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
    2bc4:	68007669 	stmdavs	r0, {r0, r3, r5, r6, r9, sl, ip, sp, lr}
    2bc8:	5f626174 	svcpl	0x00626174
    2bcc:	705f7165 	subsvc	r7, pc, r5, ror #2
    2bd0:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    2bd4:	54007265 	strpl	r7, [r0], #-613	; 0xfffffd9b
    2bd8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2bdc:	50435f54 	subpl	r5, r3, r4, asr pc
    2be0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2be4:	0030366d 	eorseq	r3, r0, sp, ror #12
    2be8:	20554e47 	subscs	r4, r5, r7, asr #28
    2bec:	20373143 	eorscs	r3, r7, r3, asr #2
    2bf0:	2e332e38 	mrccs	14, 1, r2, cr3, cr8, {1}
    2bf4:	30322031 	eorscc	r2, r2, r1, lsr r0
    2bf8:	37303931 			; <UNDEFINED> instruction: 0x37303931
    2bfc:	28203330 	stmdacs	r0!, {r4, r5, r8, r9, ip, sp}
    2c00:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    2c04:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    2c08:	63675b20 	cmnvs	r7, #32, 22	; 0x8000
    2c0c:	2d382d63 	ldccs	13, cr2, [r8, #-396]!	; 0xfffffe74
    2c10:	6e617262 	cdpvs	2, 6, cr7, cr1, cr2, {3}
    2c14:	72206863 	eorvc	r6, r0, #6488064	; 0x630000
    2c18:	73697665 	cmnvc	r9, #105906176	; 0x6500000
    2c1c:	206e6f69 	rsbcs	r6, lr, r9, ror #30
    2c20:	30333732 	eorscc	r3, r3, r2, lsr r7
    2c24:	205d3732 	subscs	r3, sp, r2, lsr r7
    2c28:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    2c2c:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
    2c30:	616f6c66 	cmnvs	pc, r6, ror #24
    2c34:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    2c38:	61683d69 	cmnvs	r8, r9, ror #26
    2c3c:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    2c40:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
    2c44:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
    2c48:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    2c4c:	70662b65 	rsbvc	r2, r6, r5, ror #22
    2c50:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    2c54:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    2c58:	4f2d2067 	svcmi	0x002d2067
    2c5c:	4f2d2032 	svcmi	0x002d2032
    2c60:	4f2d2032 	svcmi	0x002d2032
    2c64:	662d2032 			; <UNDEFINED> instruction: 0x662d2032
    2c68:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    2c6c:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
    2c70:	62696c2d 	rsbvs	r6, r9, #11520	; 0x2d00
    2c74:	20636367 	rsbcs	r6, r3, r7, ror #6
    2c78:	6f6e662d 	svcvs	0x006e662d
    2c7c:	6174732d 	cmnvs	r4, sp, lsr #6
    2c80:	702d6b63 	eorvc	r6, sp, r3, ror #22
    2c84:	65746f72 	ldrbvs	r6, [r4, #-3954]!	; 0xfffff08e
    2c88:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    2c8c:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    2c90:	6e692d6f 	cdpvs	13, 6, cr2, cr9, cr15, {3}
    2c94:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    2c98:	76662d20 	strbtvc	r2, [r6], -r0, lsr #26
    2c9c:	62697369 	rsbvs	r7, r9, #-1543503871	; 0xa4000001
    2ca0:	74696c69 	strbtvc	r6, [r9], #-3177	; 0xfffff397
    2ca4:	69683d79 	stmdbvs	r8!, {r0, r3, r4, r5, r6, r8, sl, fp, ip, sp}^
    2ca8:	6e656464 	cdpvs	4, 6, cr6, cr5, cr4, {3}
    2cac:	6d726100 	ldfvse	f6, [r2, #-0]
    2cb0:	6369705f 	cmnvs	r9, #95	; 0x5f
    2cb4:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    2cb8:	65747369 	ldrbvs	r7, [r4, #-873]!	; 0xfffffc97
    2cbc:	41540072 	cmpmi	r4, r2, ror r0
    2cc0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2cc4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2cc8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2ccc:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2cd0:	616d7330 	cmnvs	sp, r0, lsr r3
    2cd4:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    2cd8:	7069746c 	rsbvc	r7, r9, ip, ror #8
    2cdc:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    2ce0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2ce4:	50435f54 	subpl	r5, r3, r4, asr pc
    2ce8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2cec:	3636396d 	ldrtcc	r3, [r6], -sp, ror #18
    2cf0:	54007365 	strpl	r7, [r0], #-869	; 0xfffffc9b
    2cf4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2cf8:	50435f54 	subpl	r5, r3, r4, asr pc
    2cfc:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    2d00:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    2d04:	66766f6e 	ldrbtvs	r6, [r6], -lr, ror #30
    2d08:	73690070 	cmnvc	r9, #112	; 0x70
    2d0c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2d10:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    2d14:	5f6b7269 	svcpl	0x006b7269
    2d18:	5f336d63 	svcpl	0x00336d63
    2d1c:	6472646c 	ldrbtvs	r6, [r2], #-1132	; 0xfffffb94
    2d20:	52415400 	subpl	r5, r1, #0, 8
    2d24:	5f544547 	svcpl	0x00544547
    2d28:	5f555043 	svcpl	0x00555043
    2d2c:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    2d30:	00693030 	rsbeq	r3, r9, r0, lsr r0
    2d34:	5f4d5241 	svcpl	0x004d5241
    2d38:	61004343 	tstvs	r0, r3, asr #6
    2d3c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2d40:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2d44:	5400325f 	strpl	r3, [r0], #-607	; 0xfffffda1
    2d48:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2d4c:	50435f54 	subpl	r5, r3, r4, asr pc
    2d50:	6d665f55 	stclvs	15, cr5, [r6, #-340]!	; 0xfffffeac
    2d54:	36323670 			; <UNDEFINED> instruction: 0x36323670
    2d58:	4d524100 	ldfmie	f4, [r2, #-0]
    2d5c:	0053435f 	subseq	r4, r3, pc, asr r3
    2d60:	5f6d7261 	svcpl	0x006d7261
    2d64:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    2d68:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    2d6c:	72610074 	rsbvc	r0, r1, #116	; 0x74
    2d70:	61625f6d 	cmnvs	r2, sp, ror #30
    2d74:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    2d78:	00686372 	rsbeq	r6, r8, r2, ror r3
    2d7c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2d80:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2d84:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2d88:	6d376d72 	ldcvs	13, cr6, [r7, #-456]!	; 0xfffffe38
    2d8c:	52415400 	subpl	r5, r1, #0, 8
    2d90:	5f544547 	svcpl	0x00544547
    2d94:	5f555043 	svcpl	0x00555043
    2d98:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    2d9c:	41540030 	cmpmi	r4, r0, lsr r0
    2da0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2da4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2da8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2dac:	00303532 	eorseq	r3, r0, r2, lsr r5
    2db0:	5f6d7261 	svcpl	0x006d7261
    2db4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2db8:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    2dbc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2dc0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2dc4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2dc8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2dcc:	32376178 	eorscc	r6, r7, #120, 2
    2dd0:	6d726100 	ldfvse	f6, [r2, #-0]
    2dd4:	7363705f 	cmnvc	r3, #95	; 0x5f
    2dd8:	6665645f 			; <UNDEFINED> instruction: 0x6665645f
    2ddc:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
    2de0:	4d524100 	ldfmie	f4, [r2, #-0]
    2de4:	5343505f 	movtpl	r5, #12383	; 0x305f
    2de8:	5041415f 	subpl	r4, r1, pc, asr r1
    2dec:	4c5f5343 	mrrcmi	3, 4, r5, pc, cr3	; <UNPREDICTABLE>
    2df0:	4c41434f 	mcrrmi	3, 4, r4, r1, cr15
    2df4:	52415400 	subpl	r5, r1, #0, 8
    2df8:	5f544547 	svcpl	0x00544547
    2dfc:	5f555043 	svcpl	0x00555043
    2e00:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2e04:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2e08:	41540035 	cmpmi	r4, r5, lsr r0
    2e0c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2e10:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2e14:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    2e18:	61676e6f 	cmnvs	r7, pc, ror #28
    2e1c:	61006d72 	tstvs	r0, r2, ror sp
    2e20:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2e24:	5f686372 	svcpl	0x00686372
    2e28:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2e2c:	61003162 	tstvs	r0, r2, ror #2
    2e30:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2e34:	5f686372 	svcpl	0x00686372
    2e38:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2e3c:	54003262 	strpl	r3, [r0], #-610	; 0xfffffd9e
    2e40:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2e44:	50435f54 	subpl	r5, r3, r4, asr pc
    2e48:	77695f55 			; <UNDEFINED> instruction: 0x77695f55
    2e4c:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    2e50:	52415400 	subpl	r5, r1, #0, 8
    2e54:	5f544547 	svcpl	0x00544547
    2e58:	5f555043 	svcpl	0x00555043
    2e5c:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    2e60:	00743232 	rsbseq	r3, r4, r2, lsr r2
    2e64:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2e68:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2e6c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2e70:	64376d72 	ldrtvs	r6, [r7], #-3442	; 0xfffff28e
    2e74:	61736900 	cmnvs	r3, r0, lsl #18
    2e78:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2e7c:	00706d5f 	rsbseq	r6, r0, pc, asr sp
    2e80:	5f6d7261 	svcpl	0x006d7261
    2e84:	735f646c 	cmpvc	pc, #108, 8	; 0x6c000000
    2e88:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    2e8c:	6d726100 	ldfvse	f6, [r2, #-0]
    2e90:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2e94:	315f3868 	cmpcc	pc, r8, ror #16
    2e98:	665f5f00 	ldrbvs	r5, [pc], -r0, lsl #30
    2e9c:	6e757869 	cdpvs	8, 7, cr7, cr5, cr9, {3}
    2ea0:	64667373 	strbtvs	r7, [r6], #-883	; 0xfffffc8d
    2ea4:	5f5f0069 	svcpl	0x005f0069
    2ea8:	62616561 	rsbvs	r6, r1, #406847488	; 0x18400000
    2eac:	32665f69 	rsbcc	r5, r6, #420	; 0x1a4
    2eb0:	007a6c75 	rsbseq	r6, sl, r5, ror ip
    2eb4:	79744653 	ldmdbvc	r4!, {r0, r1, r4, r6, r9, sl, lr}^
    2eb8:	5f006570 	svcpl	0x00006570
    2ebc:	7869665f 	stmdavc	r9!, {r0, r1, r2, r3, r4, r6, r9, sl, sp, lr}^
    2ec0:	69646673 	stmdbvs	r4!, {r0, r1, r4, r5, r6, r9, sl, sp, lr}^
    2ec4:	49445500 	stmdbmi	r4, {r8, sl, ip, lr}^
    2ec8:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    2ecc:	49535500 	ldmdbmi	r3, {r8, sl, ip, lr}^
    2ed0:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    2ed4:	74464400 	strbvc	r4, [r6], #-1024	; 0xfffffc00
    2ed8:	00657079 	rsbeq	r7, r5, r9, ror r0
    2edc:	64755f5f 	ldrbtvs	r5, [r5], #-3935	; 0xfffff0a1
    2ee0:	6f6d7669 	svcvs	0x006d7669
    2ee4:	34696464 	strbtcc	r6, [r9], #-1124	; 0xfffffb9c
    2ee8:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    2eec:	37314320 	ldrcc	r4, [r1, -r0, lsr #6]!
    2ef0:	332e3820 			; <UNDEFINED> instruction: 0x332e3820
    2ef4:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    2ef8:	30393130 	eorscc	r3, r9, r0, lsr r1
    2efc:	20333037 	eorscs	r3, r3, r7, lsr r0
    2f00:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    2f04:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    2f08:	675b2029 	ldrbvs	r2, [fp, -r9, lsr #32]
    2f0c:	382d6363 	stmdacc	sp!, {r0, r1, r5, r6, r8, r9, sp, lr}
    2f10:	6172622d 	cmnvs	r2, sp, lsr #4
    2f14:	2068636e 	rsbcs	r6, r8, lr, ror #6
    2f18:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    2f1c:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
    2f20:	33373220 	teqcc	r7, #32, 4
    2f24:	5d373230 	lfmpl	f3, 4, [r7, #-192]!	; 0xffffff40
    2f28:	616d2d20 	cmnvs	sp, r0, lsr #26
    2f2c:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
    2f30:	6f6c666d 	svcvs	0x006c666d
    2f34:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    2f38:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    2f3c:	20647261 	rsbcs	r7, r4, r1, ror #4
    2f40:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    2f44:	613d6863 	teqvs	sp, r3, ror #16
    2f48:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    2f4c:	662b6574 			; <UNDEFINED> instruction: 0x662b6574
    2f50:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
    2f54:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    2f58:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    2f5c:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    2f60:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    2f64:	2d20324f 	sfmcs	f3, 4, [r0, #-316]!	; 0xfffffec4
    2f68:	69756266 	ldmdbvs	r5!, {r1, r2, r5, r6, r9, sp, lr}^
    2f6c:	6e69646c 	cdpvs	4, 6, cr6, cr9, cr12, {3}
    2f70:	696c2d67 	stmdbvs	ip!, {r0, r1, r2, r5, r6, r8, sl, fp, sp}^
    2f74:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    2f78:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    2f7c:	74732d6f 	ldrbtvc	r2, [r3], #-3439	; 0xfffff291
    2f80:	2d6b6361 	stclcs	3, cr6, [fp, #-388]!	; 0xfffffe7c
    2f84:	746f7270 	strbtvc	r7, [pc], #-624	; 2f8c <shift+0x2f8c>
    2f88:	6f746365 	svcvs	0x00746365
    2f8c:	662d2072 			; <UNDEFINED> instruction: 0x662d2072
    2f90:	692d6f6e 	pushvs	{r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}
    2f94:	6e696c6e 	cdpvs	12, 6, cr6, cr9, cr14, {3}
    2f98:	662d2065 	strtvs	r2, [sp], -r5, rrx
    2f9c:	65637865 	strbvs	r7, [r3, #-2149]!	; 0xfffff79b
    2fa0:	6f697470 	svcvs	0x00697470
    2fa4:	2d20736e 	stccs	3, cr7, [r0, #-440]!	; 0xfffffe48
    2fa8:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    2fac:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    2fb0:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    2fb4:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    2fb8:	Address 0x0000000000002fb8 is out of bounds.


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
  20:	8b040e42 	blhi	103930 <__bss_end+0xf7a28>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x344928>
  28:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008060 	andeq	r8, r0, r0, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f7a48>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf6d78>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a0 	andeq	r8, r0, r0, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf7a78>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x344978>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080d8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf7a98>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x344998>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008104 	andeq	r8, r0, r4, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf7ab8>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x3449b8>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008124 	andeq	r8, r0, r4, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf7ad8>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x3449d8>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	0000813c 	andeq	r8, r0, ip, lsr r1
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf7af8>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x3449f8>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008154 	andeq	r8, r0, r4, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf7b18>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x344a18>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	0000816c 	andeq	r8, r0, ip, ror #2
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf7b38>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x344a38>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	00008178 	andeq	r8, r0, r8, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f7b50>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d0 	ldrdeq	r8, [r0], -r0
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f7b70>
 16c:	42018e02 	andmi	r8, r1, #2, 28
 170:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 174:	00080d0c 	andeq	r0, r8, ip, lsl #26
 178:	0000000c 	andeq	r0, r0, ip
 17c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 180:	7c020001 	stcvc	0, cr0, [r2], {1}
 184:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 188:	0000001c 	andeq	r0, r0, ip, lsl r0
 18c:	00000178 	andeq	r0, r0, r8, ror r1
 190:	000096a0 	andeq	r9, r0, r0, lsr #13
 194:	00000030 	andeq	r0, r0, r0, lsr r0
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1f7ba0>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	50040b0c 	andpl	r0, r4, ip, lsl #22
 1a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1ac:	00000178 	andeq	r0, r0, r8, ror r1
 1b0:	00008228 	andeq	r8, r0, r8, lsr #4
 1b4:	00000040 	andeq	r0, r0, r0, asr #32
 1b8:	8b040e42 	blhi	103ac8 <__bss_end+0xf7bc0>
 1bc:	0b0d4201 	bleq	3509c8 <__bss_end+0x344ac0>
 1c0:	420d0d58 	andmi	r0, sp, #88, 26	; 0x1600
 1c4:	00000ecb 	andeq	r0, r0, fp, asr #29
 1c8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1cc:	00000178 	andeq	r0, r0, r8, ror r1
 1d0:	000096d0 	ldrdeq	r9, [r0], -r0
 1d4:	00000070 	andeq	r0, r0, r0, ror r0
 1d8:	8b040e42 	blhi	103ae8 <__bss_end+0xf7be0>
 1dc:	0b0d4201 	bleq	3509e8 <__bss_end+0x344ae0>
 1e0:	420d0d66 	andmi	r0, sp, #6528	; 0x1980
 1e4:	00000ecb 	andeq	r0, r0, fp, asr #29
 1e8:	00000038 	andeq	r0, r0, r8, lsr r0
 1ec:	00000178 	andeq	r0, r0, r8, ror r1
 1f0:	00009740 	andeq	r9, r0, r0, asr #14
 1f4:	000000bc 	strheq	r0, [r0], -ip
 1f8:	8b080e42 	blhi	203b08 <__bss_end+0x1f7c00>
 1fc:	42018e02 	andmi	r8, r1, #2, 28
 200:	5005180e 	andpl	r1, r5, lr, lsl #16
 204:	05510506 	ldrbeq	r0, [r1, #-1286]	; 0xfffffafa
 208:	05045205 	streq	r5, [r4, #-517]	; 0xfffffdfb
 20c:	0c420353 	mcrreq	3, 5, r0, r2, cr3
 210:	5402040b 	strpl	r0, [r2], #-1035	; 0xfffffbf5
 214:	42180d0c 	andsmi	r0, r8, #12, 26	; 0x300
 218:	53065206 	movwpl	r5, #25094	; 0x6206
 21c:	51065006 	tstpl	r6, r6
 220:	0000080e 	andeq	r0, r0, lr, lsl #16
 224:	0000001c 	andeq	r0, r0, ip, lsl r0
 228:	00000178 	andeq	r0, r0, r8, ror r1
 22c:	00008268 	andeq	r8, r0, r8, ror #4
 230:	0000003c 	andeq	r0, r0, ip, lsr r0
 234:	8b080e42 	blhi	203b44 <__bss_end+0x1f7c3c>
 238:	42018e02 	andmi	r8, r1, #2, 28
 23c:	58040b0c 	stmdapl	r4, {r2, r3, r8, r9, fp}
 240:	00080d0c 	andeq	r0, r8, ip, lsl #26
 244:	0000001c 	andeq	r0, r0, ip, lsl r0
 248:	00000178 	andeq	r0, r0, r8, ror r1
 24c:	000082a4 	andeq	r8, r0, r4, lsr #5
 250:	00000038 	andeq	r0, r0, r8, lsr r0
 254:	8b080e42 	blhi	203b64 <__bss_end+0x1f7c5c>
 258:	42018e02 	andmi	r8, r1, #2, 28
 25c:	56040b0c 	strpl	r0, [r4], -ip, lsl #22
 260:	00080d0c 	andeq	r0, r8, ip, lsl #26
 264:	0000001c 	andeq	r0, r0, ip, lsl r0
 268:	00000178 	andeq	r0, r0, r8, ror r1
 26c:	000082dc 	ldrdeq	r8, [r0], -ip
 270:	00000108 	andeq	r0, r0, r8, lsl #2
 274:	8b080e42 	blhi	203b84 <__bss_end+0x1f7c7c>
 278:	42018e02 	andmi	r8, r1, #2, 28
 27c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 280:	080d0c78 	stmdaeq	sp, {r3, r4, r5, r6, sl, fp}
 284:	0000001c 	andeq	r0, r0, ip, lsl r0
 288:	00000178 	andeq	r0, r0, r8, ror r1
 28c:	000083e4 	andeq	r8, r0, r4, ror #7
 290:	00000064 	andeq	r0, r0, r4, rrx
 294:	8b080e42 	blhi	203ba4 <__bss_end+0x1f7c9c>
 298:	42018e02 	andmi	r8, r1, #2, 28
 29c:	6c040b0c 			; <UNDEFINED> instruction: 0x6c040b0c
 2a0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 2a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2a8:	00000178 	andeq	r0, r0, r8, ror r1
 2ac:	00008448 	andeq	r8, r0, r8, asr #8
 2b0:	00000060 	andeq	r0, r0, r0, rrx
 2b4:	8b080e42 	blhi	203bc4 <__bss_end+0x1f7cbc>
 2b8:	42018e02 	andmi	r8, r1, #2, 28
 2bc:	6a040b0c 	bvs	102ef4 <__bss_end+0xf6fec>
 2c0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 2c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2c8:	00000178 	andeq	r0, r0, r8, ror r1
 2cc:	000084a8 	andeq	r8, r0, r8, lsr #9
 2d0:	00000070 	andeq	r0, r0, r0, ror r0
 2d4:	8b080e42 	blhi	203be4 <__bss_end+0x1f7cdc>
 2d8:	42018e02 	andmi	r8, r1, #2, 28
 2dc:	70040b0c 	andvc	r0, r4, ip, lsl #22
 2e0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 2e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2e8:	00000178 	andeq	r0, r0, r8, ror r1
 2ec:	00008518 	andeq	r8, r0, r8, lsl r5
 2f0:	00000070 	andeq	r0, r0, r0, ror r0
 2f4:	8b080e42 	blhi	203c04 <__bss_end+0x1f7cfc>
 2f8:	42018e02 	andmi	r8, r1, #2, 28
 2fc:	70040b0c 	andvc	r0, r4, ip, lsl #22
 300:	00080d0c 	andeq	r0, r8, ip, lsl #26
 304:	00000028 	andeq	r0, r0, r8, lsr #32
 308:	00000178 	andeq	r0, r0, r8, ror r1
 30c:	00008588 	andeq	r8, r0, r8, lsl #11
 310:	000000d8 	ldrdeq	r0, [r0], -r8
 314:	42080e42 	andmi	r0, r8, #1056	; 0x420
 318:	048b100e 	streq	r1, [fp], #14
 31c:	0c42038e 	mcrreq	3, 8, r0, r2, cr14
 320:	52020c0b 	andpl	r0, r2, #2816	; 0xb00
 324:	42100d0c 	andsmi	r0, r0, #12, 26	; 0x300
 328:	080ecbce 	stmdaeq	lr, {r1, r2, r3, r6, r7, r8, r9, fp, lr, pc}
 32c:	00000e42 	andeq	r0, r0, r2, asr #28
 330:	00000040 	andeq	r0, r0, r0, asr #32
 334:	00000178 	andeq	r0, r0, r8, ror r1
 338:	00008660 	andeq	r8, r0, r0, ror #12
 33c:	00000cac 	andeq	r0, r0, ip, lsr #25
 340:	84200e42 	strthi	r0, [r0], #-3650	; 0xfffff1be
 344:	86078508 	strhi	r8, [r7], -r8, lsl #10
 348:	88058706 	stmdahi	r5, {r1, r2, r8, r9, sl, pc}
 34c:	8b038904 	blhi	e2764 <__bss_end+0xd685c>
 350:	42018e02 	andmi	r8, r1, #2, 28
 354:	5005400e 	andpl	r4, r5, lr
 358:	0f510510 	svceq	0x00510510
 35c:	050e5205 	streq	r5, [lr, #-517]	; 0xfffffdfb
 360:	54050d53 	strpl	r0, [r5], #-3411	; 0xfffff2ad
 364:	0b55050c 	bleq	154179c <__bss_end+0x1535894>
 368:	050a5605 	streq	r5, [sl, #-1541]	; 0xfffff9fb
 36c:	0c420957 	mcrreq	9, 5, r0, r2, cr7	; <UNPREDICTABLE>
 370:	0000040b 	andeq	r0, r0, fp, lsl #8
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	00000178 	andeq	r0, r0, r8, ror r1
 37c:	0000930c 	andeq	r9, r0, ip, lsl #6
 380:	00000084 	andeq	r0, r0, r4, lsl #1
 384:	8b080e42 	blhi	203c94 <__bss_end+0x1f7d8c>
 388:	42018e02 	andmi	r8, r1, #2, 28
 38c:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 390:	00080d0c 	andeq	r0, r8, ip, lsl #26
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	00000178 	andeq	r0, r0, r8, ror r1
 39c:	00009390 	muleq	r0, r0, r3
 3a0:	000000b4 	strheq	r0, [r0], -r4
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1f7dac>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c54 	stmdaeq	sp, {r2, r4, r6, sl, fp}
 3b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3b8:	00000178 	andeq	r0, r0, r8, ror r1
 3bc:	00009444 	andeq	r9, r0, r4, asr #8
 3c0:	000000e0 	andeq	r0, r0, r0, ror #1
 3c4:	8b080e42 	blhi	203cd4 <__bss_end+0x1f7dcc>
 3c8:	42018e02 	andmi	r8, r1, #2, 28
 3cc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3d0:	080d0c6a 	stmdaeq	sp, {r1, r3, r5, r6, sl, fp}
 3d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3d8:	00000178 	andeq	r0, r0, r8, ror r1
 3dc:	00009524 	andeq	r9, r0, r4, lsr #10
 3e0:	00000104 	andeq	r0, r0, r4, lsl #2
 3e4:	8b080e42 	blhi	203cf4 <__bss_end+0x1f7dec>
 3e8:	42018e02 	andmi	r8, r1, #2, 28
 3ec:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3f0:	080d0c7c 	stmdaeq	sp, {r2, r3, r4, r5, r6, sl, fp}
 3f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3f8:	00000178 	andeq	r0, r0, r8, ror r1
 3fc:	00009628 	andeq	r9, r0, r8, lsr #12
 400:	00000078 	andeq	r0, r0, r8, ror r0
 404:	8b080e42 	blhi	203d14 <__bss_end+0x1f7e0c>
 408:	42018e02 	andmi	r8, r1, #2, 28
 40c:	76040b0c 	strvc	r0, [r4], -ip, lsl #22
 410:	00080d0c 	andeq	r0, r8, ip, lsl #26
 414:	0000000c 	andeq	r0, r0, ip
 418:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 41c:	7c020001 	stcvc	0, cr0, [r2], {1}
 420:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	00000414 	andeq	r0, r0, r4, lsl r4
 42c:	000097fc 	strdeq	r9, [r0], -ip
 430:	00000080 	andeq	r0, r0, r0, lsl #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xf7e3c>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x344d3c>
 43c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 440:	00000ecb 	andeq	r0, r0, fp, asr #29
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	00000414 	andeq	r0, r0, r4, lsl r4
 44c:	0000987c 	andeq	r9, r0, ip, ror r8
 450:	00000048 	andeq	r0, r0, r8, asr #32
 454:	8b040e42 	blhi	103d64 <__bss_end+0xf7e5c>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x344d5c>
 45c:	420d0d5c 	andmi	r0, sp, #92, 26	; 0x1700
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	00000414 	andeq	r0, r0, r4, lsl r4
 46c:	000098c4 	andeq	r9, r0, r4, asr #17
 470:	00000064 	andeq	r0, r0, r4, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xf7e7c>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x344d7c>
 47c:	420d0d6a 	andmi	r0, sp, #6784	; 0x1a80
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	00000414 	andeq	r0, r0, r4, lsl r4
 48c:	00009928 	andeq	r9, r0, r8, lsr #18
 490:	00000034 	andeq	r0, r0, r4, lsr r0
 494:	8b040e42 	blhi	103da4 <__bss_end+0xf7e9c>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x344d9c>
 49c:	420d0d52 	andmi	r0, sp, #5248	; 0x1480
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	00000414 	andeq	r0, r0, r4, lsl r4
 4ac:	0000995c 	andeq	r9, r0, ip, asr r9
 4b0:	00000060 	andeq	r0, r0, r0, rrx
 4b4:	8b040e42 	blhi	103dc4 <__bss_end+0xf7ebc>
 4b8:	0b0d4201 	bleq	350cc4 <__bss_end+0x344dbc>
 4bc:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
 4c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4c8:	00000414 	andeq	r0, r0, r4, lsl r4
 4cc:	000099bc 			; <UNDEFINED> instruction: 0x000099bc
 4d0:	0000007c 	andeq	r0, r0, ip, ror r0
 4d4:	8b040e42 	blhi	103de4 <__bss_end+0xf7edc>
 4d8:	0b0d4201 	bleq	350ce4 <__bss_end+0x344ddc>
 4dc:	420d0d76 	andmi	r0, sp, #7552	; 0x1d80
 4e0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4e8:	00000414 	andeq	r0, r0, r4, lsl r4
 4ec:	00009a38 	andeq	r9, r0, r8, lsr sl
 4f0:	0000004c 	andeq	r0, r0, ip, asr #32
 4f4:	8b080e42 	blhi	203e04 <__bss_end+0x1f7efc>
 4f8:	42018e02 	andmi	r8, r1, #2, 28
 4fc:	5c040b0c 			; <UNDEFINED> instruction: 0x5c040b0c
 500:	00080d0c 	andeq	r0, r8, ip, lsl #26
 504:	00000018 	andeq	r0, r0, r8, lsl r0
 508:	00000414 	andeq	r0, r0, r4, lsl r4
 50c:	00009a84 	andeq	r9, r0, r4, lsl #21
 510:	0000001c 	andeq	r0, r0, ip, lsl r0
 514:	8b080e42 	blhi	203e24 <__bss_end+0x1f7f1c>
 518:	42018e02 	andmi	r8, r1, #2, 28
 51c:	00040b0c 	andeq	r0, r4, ip, lsl #22
 520:	0000000c 	andeq	r0, r0, ip
 524:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 528:	7c020001 	stcvc	0, cr0, [r2], {1}
 52c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 530:	0000001c 	andeq	r0, r0, ip, lsl r0
 534:	00000520 	andeq	r0, r0, r0, lsr #10
 538:	00009aa0 	andeq	r9, r0, r0, lsr #21
 53c:	0000002c 	andeq	r0, r0, ip, lsr #32
 540:	8b040e42 	blhi	103e50 <__bss_end+0xf7f48>
 544:	0b0d4201 	bleq	350d50 <__bss_end+0x344e48>
 548:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 54c:	00000ecb 	andeq	r0, r0, fp, asr #29
 550:	0000001c 	andeq	r0, r0, ip, lsl r0
 554:	00000520 	andeq	r0, r0, r0, lsr #10
 558:	00009acc 	andeq	r9, r0, ip, asr #21
 55c:	0000002c 	andeq	r0, r0, ip, lsr #32
 560:	8b040e42 	blhi	103e70 <__bss_end+0xf7f68>
 564:	0b0d4201 	bleq	350d70 <__bss_end+0x344e68>
 568:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 56c:	00000ecb 	andeq	r0, r0, fp, asr #29
 570:	0000001c 	andeq	r0, r0, ip, lsl r0
 574:	00000520 	andeq	r0, r0, r0, lsr #10
 578:	00009af8 	strdeq	r9, [r0], -r8
 57c:	0000002c 	andeq	r0, r0, ip, lsr #32
 580:	8b040e42 	blhi	103e90 <__bss_end+0xf7f88>
 584:	0b0d4201 	bleq	350d90 <__bss_end+0x344e88>
 588:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 58c:	00000ecb 	andeq	r0, r0, fp, asr #29
 590:	0000001c 	andeq	r0, r0, ip, lsl r0
 594:	00000520 	andeq	r0, r0, r0, lsr #10
 598:	00009b24 	andeq	r9, r0, r4, lsr #22
 59c:	0000001c 	andeq	r0, r0, ip, lsl r0
 5a0:	8b040e42 	blhi	103eb0 <__bss_end+0xf7fa8>
 5a4:	0b0d4201 	bleq	350db0 <__bss_end+0x344ea8>
 5a8:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 5ac:	00000ecb 	andeq	r0, r0, fp, asr #29
 5b0:	0000001c 	andeq	r0, r0, ip, lsl r0
 5b4:	00000520 	andeq	r0, r0, r0, lsr #10
 5b8:	00009b40 	andeq	r9, r0, r0, asr #22
 5bc:	00000044 	andeq	r0, r0, r4, asr #32
 5c0:	8b040e42 	blhi	103ed0 <__bss_end+0xf7fc8>
 5c4:	0b0d4201 	bleq	350dd0 <__bss_end+0x344ec8>
 5c8:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 5cc:	00000ecb 	andeq	r0, r0, fp, asr #29
 5d0:	0000001c 	andeq	r0, r0, ip, lsl r0
 5d4:	00000520 	andeq	r0, r0, r0, lsr #10
 5d8:	00009b84 	andeq	r9, r0, r4, lsl #23
 5dc:	00000050 	andeq	r0, r0, r0, asr r0
 5e0:	8b040e42 	blhi	103ef0 <__bss_end+0xf7fe8>
 5e4:	0b0d4201 	bleq	350df0 <__bss_end+0x344ee8>
 5e8:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 5ec:	00000ecb 	andeq	r0, r0, fp, asr #29
 5f0:	0000001c 	andeq	r0, r0, ip, lsl r0
 5f4:	00000520 	andeq	r0, r0, r0, lsr #10
 5f8:	00009bd4 	ldrdeq	r9, [r0], -r4
 5fc:	00000050 	andeq	r0, r0, r0, asr r0
 600:	8b040e42 	blhi	103f10 <__bss_end+0xf8008>
 604:	0b0d4201 	bleq	350e10 <__bss_end+0x344f08>
 608:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 60c:	00000ecb 	andeq	r0, r0, fp, asr #29
 610:	0000001c 	andeq	r0, r0, ip, lsl r0
 614:	00000520 	andeq	r0, r0, r0, lsr #10
 618:	00009c24 	andeq	r9, r0, r4, lsr #24
 61c:	0000002c 	andeq	r0, r0, ip, lsr #32
 620:	8b040e42 	blhi	103f30 <__bss_end+0xf8028>
 624:	0b0d4201 	bleq	350e30 <__bss_end+0x344f28>
 628:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 62c:	00000ecb 	andeq	r0, r0, fp, asr #29
 630:	0000001c 	andeq	r0, r0, ip, lsl r0
 634:	00000520 	andeq	r0, r0, r0, lsr #10
 638:	00009c50 	andeq	r9, r0, r0, asr ip
 63c:	00000050 	andeq	r0, r0, r0, asr r0
 640:	8b040e42 	blhi	103f50 <__bss_end+0xf8048>
 644:	0b0d4201 	bleq	350e50 <__bss_end+0x344f48>
 648:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 64c:	00000ecb 	andeq	r0, r0, fp, asr #29
 650:	0000001c 	andeq	r0, r0, ip, lsl r0
 654:	00000520 	andeq	r0, r0, r0, lsr #10
 658:	00009ca0 	andeq	r9, r0, r0, lsr #25
 65c:	00000044 	andeq	r0, r0, r4, asr #32
 660:	8b040e42 	blhi	103f70 <__bss_end+0xf8068>
 664:	0b0d4201 	bleq	350e70 <__bss_end+0x344f68>
 668:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 66c:	00000ecb 	andeq	r0, r0, fp, asr #29
 670:	0000001c 	andeq	r0, r0, ip, lsl r0
 674:	00000520 	andeq	r0, r0, r0, lsr #10
 678:	00009ce4 	andeq	r9, r0, r4, ror #25
 67c:	00000050 	andeq	r0, r0, r0, asr r0
 680:	8b040e42 	blhi	103f90 <__bss_end+0xf8088>
 684:	0b0d4201 	bleq	350e90 <__bss_end+0x344f88>
 688:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 68c:	00000ecb 	andeq	r0, r0, fp, asr #29
 690:	0000001c 	andeq	r0, r0, ip, lsl r0
 694:	00000520 	andeq	r0, r0, r0, lsr #10
 698:	00009d34 	andeq	r9, r0, r4, lsr sp
 69c:	00000054 	andeq	r0, r0, r4, asr r0
 6a0:	8b040e42 	blhi	103fb0 <__bss_end+0xf80a8>
 6a4:	0b0d4201 	bleq	350eb0 <__bss_end+0x344fa8>
 6a8:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 6ac:	00000ecb 	andeq	r0, r0, fp, asr #29
 6b0:	0000001c 	andeq	r0, r0, ip, lsl r0
 6b4:	00000520 	andeq	r0, r0, r0, lsr #10
 6b8:	00009d88 	andeq	r9, r0, r8, lsl #27
 6bc:	0000003c 	andeq	r0, r0, ip, lsr r0
 6c0:	8b040e42 	blhi	103fd0 <__bss_end+0xf80c8>
 6c4:	0b0d4201 	bleq	350ed0 <__bss_end+0x344fc8>
 6c8:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 6cc:	00000ecb 	andeq	r0, r0, fp, asr #29
 6d0:	0000001c 	andeq	r0, r0, ip, lsl r0
 6d4:	00000520 	andeq	r0, r0, r0, lsr #10
 6d8:	00009dc4 	andeq	r9, r0, r4, asr #27
 6dc:	0000003c 	andeq	r0, r0, ip, lsr r0
 6e0:	8b040e42 	blhi	103ff0 <__bss_end+0xf80e8>
 6e4:	0b0d4201 	bleq	350ef0 <__bss_end+0x344fe8>
 6e8:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 6ec:	00000ecb 	andeq	r0, r0, fp, asr #29
 6f0:	0000001c 	andeq	r0, r0, ip, lsl r0
 6f4:	00000520 	andeq	r0, r0, r0, lsr #10
 6f8:	00009e00 	andeq	r9, r0, r0, lsl #28
 6fc:	0000003c 	andeq	r0, r0, ip, lsr r0
 700:	8b040e42 	blhi	104010 <__bss_end+0xf8108>
 704:	0b0d4201 	bleq	350f10 <__bss_end+0x345008>
 708:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 70c:	00000ecb 	andeq	r0, r0, fp, asr #29
 710:	0000001c 	andeq	r0, r0, ip, lsl r0
 714:	00000520 	andeq	r0, r0, r0, lsr #10
 718:	00009e3c 	andeq	r9, r0, ip, lsr lr
 71c:	0000003c 	andeq	r0, r0, ip, lsr r0
 720:	8b040e42 	blhi	104030 <__bss_end+0xf8128>
 724:	0b0d4201 	bleq	350f30 <__bss_end+0x345028>
 728:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 72c:	00000ecb 	andeq	r0, r0, fp, asr #29
 730:	0000001c 	andeq	r0, r0, ip, lsl r0
 734:	00000520 	andeq	r0, r0, r0, lsr #10
 738:	00009e78 	andeq	r9, r0, r8, ror lr
 73c:	000000b4 	strheq	r0, [r0], -r4
 740:	8b080e42 	blhi	204050 <__bss_end+0x1f8148>
 744:	42018e02 	andmi	r8, r1, #2, 28
 748:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 74c:	080d0c52 	stmdaeq	sp, {r1, r4, r6, sl, fp}
 750:	0000000c 	andeq	r0, r0, ip
 754:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 758:	7c020001 	stcvc	0, cr0, [r2], {1}
 75c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 760:	0000001c 	andeq	r0, r0, ip, lsl r0
 764:	00000750 	andeq	r0, r0, r0, asr r7
 768:	00009f2c 	andeq	r9, r0, ip, lsr #30
 76c:	0000006c 	andeq	r0, r0, ip, rrx
 770:	8b080e42 	blhi	204080 <__bss_end+0x1f8178>
 774:	42018e02 	andmi	r8, r1, #2, 28
 778:	70040b0c 	andvc	r0, r4, ip, lsl #22
 77c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 780:	0000001c 	andeq	r0, r0, ip, lsl r0
 784:	00000750 	andeq	r0, r0, r0, asr r7
 788:	00009f98 	muleq	r0, r8, pc	; <UNPREDICTABLE>
 78c:	00000054 	andeq	r0, r0, r4, asr r0
 790:	8b040e42 	blhi	1040a0 <__bss_end+0xf8198>
 794:	0b0d4201 	bleq	350fa0 <__bss_end+0x345098>
 798:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 79c:	00000ecb 	andeq	r0, r0, fp, asr #29
 7a0:	0000001c 	andeq	r0, r0, ip, lsl r0
 7a4:	00000750 	andeq	r0, r0, r0, asr r7
 7a8:	00009fec 	andeq	r9, r0, ip, ror #31
 7ac:	00000048 	andeq	r0, r0, r8, asr #32
 7b0:	8b040e42 	blhi	1040c0 <__bss_end+0xf81b8>
 7b4:	0b0d4201 	bleq	350fc0 <__bss_end+0x3450b8>
 7b8:	420d0d5c 	andmi	r0, sp, #92, 26	; 0x1700
 7bc:	00000ecb 	andeq	r0, r0, fp, asr #29
 7c0:	0000001c 	andeq	r0, r0, ip, lsl r0
 7c4:	00000750 	andeq	r0, r0, r0, asr r7
 7c8:	0000a034 	andeq	sl, r0, r4, lsr r0
 7cc:	00000128 	andeq	r0, r0, r8, lsr #2
 7d0:	8b080e42 	blhi	2040e0 <__bss_end+0x1f81d8>
 7d4:	42018e02 	andmi	r8, r1, #2, 28
 7d8:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 7dc:	080d0c8e 	stmdaeq	sp, {r1, r2, r3, r7, sl, fp}
 7e0:	0000001c 	andeq	r0, r0, ip, lsl r0
 7e4:	00000750 	andeq	r0, r0, r0, asr r7
 7e8:	0000a15c 	andeq	sl, r0, ip, asr r1
 7ec:	0000019c 	muleq	r0, ip, r1
 7f0:	8b080e42 	blhi	204100 <__bss_end+0x1f81f8>
 7f4:	42018e02 	andmi	r8, r1, #2, 28
 7f8:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 7fc:	080d0cc8 	stmdaeq	sp, {r3, r6, r7, sl, fp}
 800:	0000001c 	andeq	r0, r0, ip, lsl r0
 804:	00000750 	andeq	r0, r0, r0, asr r7
 808:	0000a2f8 	strdeq	sl, [r0], -r8
 80c:	0000004c 	andeq	r0, r0, ip, asr #32
 810:	8b080e42 	blhi	204120 <__bss_end+0x1f8218>
 814:	42018e02 	andmi	r8, r1, #2, 28
 818:	5c040b0c 			; <UNDEFINED> instruction: 0x5c040b0c
 81c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 820:	00000018 	andeq	r0, r0, r8, lsl r0
 824:	00000750 	andeq	r0, r0, r0, asr r7
 828:	0000a344 	andeq	sl, r0, r4, asr #6
 82c:	0000001c 	andeq	r0, r0, ip, lsl r0
 830:	8b080e42 	blhi	204140 <__bss_end+0x1f8238>
 834:	42018e02 	andmi	r8, r1, #2, 28
 838:	00040b0c 	andeq	r0, r4, ip, lsl #22
 83c:	0000000c 	andeq	r0, r0, ip
 840:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 844:	7c020001 	stcvc	0, cr0, [r2], {1}
 848:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 84c:	0000001c 	andeq	r0, r0, ip, lsl r0
 850:	0000083c 	andeq	r0, r0, ip, lsr r8
 854:	0000a360 	andeq	sl, r0, r0, ror #6
 858:	00000068 	andeq	r0, r0, r8, rrx
 85c:	8b040e42 	blhi	10416c <__bss_end+0xf8264>
 860:	0b0d4201 	bleq	35106c <__bss_end+0x345164>
 864:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 868:	00000ecb 	andeq	r0, r0, fp, asr #29
 86c:	0000002c 	andeq	r0, r0, ip, lsr #32
 870:	0000083c 	andeq	r0, r0, ip, lsr r8
 874:	0000a3c8 	andeq	sl, r0, r8, asr #7
 878:	00000320 	andeq	r0, r0, r0, lsr #6
 87c:	84200e42 	strthi	r0, [r0], #-3650	; 0xfffff1be
 880:	86078508 	strhi	r8, [r7], -r8, lsl #10
 884:	88058706 	stmdahi	r5, {r1, r2, r8, r9, sl, pc}
 888:	8b038904 	blhi	e2ca0 <__bss_end+0xd6d98>
 88c:	42018e02 	andmi	r8, r1, #2, 28
 890:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 894:	0d0c0186 	stfeqs	f0, [ip, #-536]	; 0xfffffde8
 898:	00000020 	andeq	r0, r0, r0, lsr #32
 89c:	00000020 	andeq	r0, r0, r0, lsr #32
 8a0:	0000083c 	andeq	r0, r0, ip, lsr r8
 8a4:	0000a6e8 	andeq	sl, r0, r8, ror #13
 8a8:	000002b4 			; <UNDEFINED> instruction: 0x000002b4
 8ac:	8b040e42 	blhi	1041bc <__bss_end+0xf82b4>
 8b0:	0b0d4201 	bleq	3510bc <__bss_end+0x3451b4>
 8b4:	0d014803 	stceq	8, cr4, [r1, #-12]
 8b8:	0ecb420d 	cdpeq	2, 12, cr4, cr11, cr13, {0}
 8bc:	00000000 	andeq	r0, r0, r0
 8c0:	0000001c 	andeq	r0, r0, ip, lsl r0
 8c4:	0000083c 	andeq	r0, r0, ip, lsr r8
 8c8:	0000a99c 	muleq	r0, ip, r9
 8cc:	00000174 	andeq	r0, r0, r4, ror r1
 8d0:	8b080e42 	blhi	2041e0 <__bss_end+0x1f82d8>
 8d4:	42018e02 	andmi	r8, r1, #2, 28
 8d8:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 8dc:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 8e0:	0000001c 	andeq	r0, r0, ip, lsl r0
 8e4:	0000083c 	andeq	r0, r0, ip, lsr r8
 8e8:	0000ab10 	andeq	sl, r0, r0, lsl fp
 8ec:	0000009c 	muleq	r0, ip, r0
 8f0:	8b040e42 	blhi	104200 <__bss_end+0xf82f8>
 8f4:	0b0d4201 	bleq	351100 <__bss_end+0x3451f8>
 8f8:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 8fc:	000ecb42 	andeq	ip, lr, r2, asr #22
 900:	0000001c 	andeq	r0, r0, ip, lsl r0
 904:	0000083c 	andeq	r0, r0, ip, lsr r8
 908:	0000abac 	andeq	sl, r0, ip, lsr #23
 90c:	000000c0 	andeq	r0, r0, r0, asr #1
 910:	8b040e42 	blhi	104220 <__bss_end+0xf8318>
 914:	0b0d4201 	bleq	351120 <__bss_end+0x345218>
 918:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 91c:	000ecb42 	andeq	ip, lr, r2, asr #22
 920:	0000001c 	andeq	r0, r0, ip, lsl r0
 924:	0000083c 	andeq	r0, r0, ip, lsr r8
 928:	0000ac6c 	andeq	sl, r0, ip, ror #24
 92c:	000000ac 	andeq	r0, r0, ip, lsr #1
 930:	8b040e42 	blhi	104240 <__bss_end+0xf8338>
 934:	0b0d4201 	bleq	351140 <__bss_end+0x345238>
 938:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 93c:	000ecb42 	andeq	ip, lr, r2, asr #22
 940:	0000001c 	andeq	r0, r0, ip, lsl r0
 944:	0000083c 	andeq	r0, r0, ip, lsr r8
 948:	0000ad18 	andeq	sl, r0, r8, lsl sp
 94c:	00000054 	andeq	r0, r0, r4, asr r0
 950:	8b040e42 	blhi	104260 <__bss_end+0xf8358>
 954:	0b0d4201 	bleq	351160 <__bss_end+0x345258>
 958:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 95c:	00000ecb 	andeq	r0, r0, fp, asr #29
 960:	0000001c 	andeq	r0, r0, ip, lsl r0
 964:	0000083c 	andeq	r0, r0, ip, lsr r8
 968:	0000ad6c 	andeq	sl, r0, ip, ror #26
 96c:	00000080 	andeq	r0, r0, r0, lsl #1
 970:	8b040e42 	blhi	104280 <__bss_end+0xf8378>
 974:	0b0d4201 	bleq	351180 <__bss_end+0x345278>
 978:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 97c:	00000ecb 	andeq	r0, r0, fp, asr #29
 980:	0000001c 	andeq	r0, r0, ip, lsl r0
 984:	0000083c 	andeq	r0, r0, ip, lsr r8
 988:	0000adec 	andeq	sl, r0, ip, ror #27
 98c:	00000068 	andeq	r0, r0, r8, rrx
 990:	8b040e42 	blhi	1042a0 <__bss_end+0xf8398>
 994:	0b0d4201 	bleq	3511a0 <__bss_end+0x345298>
 998:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 99c:	00000ecb 	andeq	r0, r0, fp, asr #29
 9a0:	0000001c 	andeq	r0, r0, ip, lsl r0
 9a4:	0000083c 	andeq	r0, r0, ip, lsr r8
 9a8:	0000ae54 	andeq	sl, r0, r4, asr lr
 9ac:	00000080 	andeq	r0, r0, r0, lsl #1
 9b0:	8b040e42 	blhi	1042c0 <__bss_end+0xf83b8>
 9b4:	0b0d4201 	bleq	3511c0 <__bss_end+0x3452b8>
 9b8:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 9bc:	00000ecb 	andeq	r0, r0, fp, asr #29
 9c0:	0000001c 	andeq	r0, r0, ip, lsl r0
 9c4:	0000083c 	andeq	r0, r0, ip, lsr r8
 9c8:	0000aed4 	ldrdeq	sl, [r0], -r4
 9cc:	00000048 	andeq	r0, r0, r8, asr #32
 9d0:	8b040e42 	blhi	1042e0 <__bss_end+0xf83d8>
 9d4:	0b0d4201 	bleq	3511e0 <__bss_end+0x3452d8>
 9d8:	420d0d5c 	andmi	r0, sp, #92, 26	; 0x1700
 9dc:	00000ecb 	andeq	r0, r0, fp, asr #29
 9e0:	0000001c 	andeq	r0, r0, ip, lsl r0
 9e4:	0000083c 	andeq	r0, r0, ip, lsr r8
 9e8:	0000af1c 	andeq	sl, r0, ip, lsl pc
 9ec:	00000118 	andeq	r0, r0, r8, lsl r1
 9f0:	8b080e42 	blhi	204300 <__bss_end+0x1f83f8>
 9f4:	42018e02 	andmi	r8, r1, #2, 28
 9f8:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 9fc:	080d0c86 	stmdaeq	sp, {r1, r2, r7, sl, fp}
 a00:	0000001c 	andeq	r0, r0, ip, lsl r0
 a04:	0000083c 	andeq	r0, r0, ip, lsr r8
 a08:	0000b034 	andeq	fp, r0, r4, lsr r0
 a0c:	000001c8 	andeq	r0, r0, r8, asr #3
 a10:	8b080e42 	blhi	204320 <__bss_end+0x1f8418>
 a14:	42018e02 	andmi	r8, r1, #2, 28
 a18:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 a1c:	080d0cde 	stmdaeq	sp, {r1, r2, r3, r4, r6, r7, sl, fp}
 a20:	0000000c 	andeq	r0, r0, ip
 a24:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 a28:	7c010001 	stcvc	0, cr0, [r1], {1}
 a2c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 a30:	0000000c 	andeq	r0, r0, ip
 a34:	00000a20 	andeq	r0, r0, r0, lsr #20
 a38:	0000b1fc 	strdeq	fp, [r0], -ip
 a3c:	000001ec 	andeq	r0, r0, ip, ror #3
 a40:	0000000c 	andeq	r0, r0, ip
 a44:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 a48:	7c010001 	stcvc	0, cr0, [r1], {1}
 a4c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 a50:	0000000c 	andeq	r0, r0, ip
 a54:	00000a40 	andeq	r0, r0, r0, asr #20
 a58:	0000b408 	andeq	fp, r0, r8, lsl #8
 a5c:	00000220 	andeq	r0, r0, r0, lsr #4
 a60:	0000000c 	andeq	r0, r0, ip
 a64:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 a68:	7c020001 	stcvc	0, cr0, [r2], {1}
 a6c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 a70:	00000010 	andeq	r0, r0, r0, lsl r0
 a74:	00000a60 	andeq	r0, r0, r0, ror #20
 a78:	0000b64c 	andeq	fp, r0, ip, asr #12
 a7c:	0000019c 	muleq	r0, ip, r1
 a80:	0bce020a 	bleq	ff3812b0 <__bss_end+0xff3753a8>
 a84:	00000010 	andeq	r0, r0, r0, lsl r0
 a88:	00000a60 	andeq	r0, r0, r0, ror #20
 a8c:	0000b7e8 	andeq	fp, r0, r8, ror #15
 a90:	00000028 	andeq	r0, r0, r8, lsr #32
 a94:	000b540a 	andeq	r5, fp, sl, lsl #8
 a98:	00000010 	andeq	r0, r0, r0, lsl r0
 a9c:	00000a60 	andeq	r0, r0, r0, ror #20
 aa0:	0000b810 	andeq	fp, r0, r0, lsl r8
 aa4:	0000008c 	andeq	r0, r0, ip, lsl #1
 aa8:	0b46020a 	bleq	11812d8 <__bss_end+0x11753d0>
 aac:	0000000c 	andeq	r0, r0, ip
 ab0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 ab4:	7c020001 	stcvc	0, cr0, [r2], {1}
 ab8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 abc:	00000030 	andeq	r0, r0, r0, lsr r0
 ac0:	00000aac 	andeq	r0, r0, ip, lsr #21
 ac4:	0000b89c 	muleq	r0, ip, r8
 ac8:	000000d4 	ldrdeq	r0, [r0], -r4
 acc:	8e100e5a 	mrchi	14, 0, r0, cr0, cr10, {2}
 ad0:	460a4a03 	strmi	r4, [sl], -r3, lsl #20
 ad4:	42100ece 	andsmi	r0, r0, #3296	; 0xce0
 ad8:	460a4a0b 	strmi	r4, [sl], -fp, lsl #20
 adc:	4a100ece 	bmi	40461c <__bss_end+0x3f8714>
 ae0:	460a460b 	strmi	r4, [sl], -fp, lsl #12
 ae4:	46100ece 	ldrmi	r0, [r0], -lr, asr #29
 ae8:	0ece4c0b 	cdpeq	12, 12, cr4, cr14, cr11, {0}
 aec:	00000010 	andeq	r0, r0, r0, lsl r0
 af0:	0000000c 	andeq	r0, r0, ip
 af4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 af8:	7c020001 	stcvc	0, cr0, [r2], {1}
 afc:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 b00:	00000014 	andeq	r0, r0, r4, lsl r0
 b04:	00000af0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 b08:	0000b970 	andeq	fp, r0, r0, ror r9
 b0c:	0000002c 	andeq	r0, r0, ip, lsr #32
 b10:	84080e4c 	strhi	r0, [r8], #-3660	; 0xfffff1b4
 b14:	00018e02 	andeq	r8, r1, r2, lsl #28
 b18:	0000000c 	andeq	r0, r0, ip
 b1c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 b20:	7c020001 	stcvc	0, cr0, [r2], {1}
 b24:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 b28:	0000000c 	andeq	r0, r0, ip
 b2c:	00000b18 	andeq	r0, r0, r8, lsl fp
 b30:	0000b9a0 	andeq	fp, r0, r0, lsr #19
 b34:	00000040 	andeq	r0, r0, r0, asr #32
 b38:	0000000c 	andeq	r0, r0, ip
 b3c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 b40:	7c020001 	stcvc	0, cr0, [r2], {1}
 b44:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 b48:	00000024 	andeq	r0, r0, r4, lsr #32
 b4c:	00000b38 	andeq	r0, r0, r8, lsr fp
 b50:	0000b9e0 	andeq	fp, r0, r0, ror #19
 b54:	00000128 	andeq	r0, r0, r8, lsr #2
 b58:	84240e46 	strthi	r0, [r4], #-3654	; 0xfffff1ba
 b5c:	86088509 	strhi	r8, [r8], -r9, lsl #10
 b60:	88068707 	stmdahi	r6, {r0, r1, r2, r8, r9, sl, pc}
 b64:	8a048905 	bhi	122f80 <__bss_end+0x117078>
 b68:	8e028b03 	vmlahi.f64	d8, d2, d3
 b6c:	00000001 	andeq	r0, r0, r1

Disassembly of section .debug_ranges:

00000000 <.debug_ranges>:
   0:	00008228 	andeq	r8, r0, r8, lsr #4
   4:	000096a0 	andeq	r9, r0, r0, lsr #13
   8:	000096a0 	andeq	r9, r0, r0, lsr #13
   c:	000096d0 	ldrdeq	r9, [r0], -r0
  10:	000096d0 	ldrdeq	r9, [r0], -r0
  14:	00009740 	andeq	r9, r0, r0, asr #14
  18:	00009740 	andeq	r9, r0, r0, asr #14
  1c:	000097fc 	strdeq	r9, [r0], -ip
	...

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
