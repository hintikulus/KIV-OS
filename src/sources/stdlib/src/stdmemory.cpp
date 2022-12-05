#include <stdmemory.h>
#include<hal/intdef.h>
#include<memory/memmap.h>

CUserHeapMan sUserHeap;

CUserHeapMan::CUserHeapMan()
{
    mFirst = nullptr;
    PTptr = nullptr;
    uint32_t tempAddr = GetFirstNewPage(0x20000);
    
    mSize = mem::PageSize;
    mVSize = 0;
    mBrake = 0x20000;
}

uint32_t CUserHeapMan::GetFirstNewPage(uint32_t NewVAddress)
{
    uint32_t address;
    uint32_t PTptr_temp;

    asm volatile("mov r1, %0" : : "r" (NewVAddress));
    asm volatile("swi 6");
    asm volatile("mov %0, r0" : "=r" (address));
    asm volatile("mov %0, r1" : "=r" (PTptr_temp));
    *PTptr = PTptr_temp;

    return address;
}

uint32_t CUserHeapMan::GetNewPage(uint32_t NewVAddress)
{
    uint32_t address;

    asm volatile("mov r1, %0" : : "r" (NewVAddress));
    asm volatile("mov r2, %0" : : "r" (PTptr));
    asm volatile("swi 8");
    asm volatile("mov %0, r0" : "=r" (address));

    return address;
}

void CUserHeapMan::sbrk(uint32_t size, bool over)
{
    uint32_t newsize = mVSize + size + sizeof(UPage);
    if(over)
    {
        uint32_t tempaddr = GetNewPage(0x20000 + size + mem::PageSize);
        
        UPage* newchunk = reinterpret_cast<UPage*>(tempaddr);
        newchunk->prev = mFirst;
        newchunk->next = nullptr;
        newchunk->address = tempaddr + sizeof(UPage);
        newchunk->free = false;
        newchunk->size = size;
        
        mFirst->next = newchunk;
        mFirst = newchunk;
        
        mSize = mSize + mem::PageSize;
        mVSize = mVSize + sizeof(UPage);
        mBrake = mFirst->address;
        return;
    }
    else
    {
        mBrake = mBrake + size + sizeof(UPage);
        return;
    }
}

void* CUserHeapMan::Alloc(uint32_t size)
{
    uint32_t saveBreak = mBrake;

    if(mFirst == nullptr)
    {
        mFirst = reinterpret_cast<UPage*>(0x20000);
        mFirst->prev = nullptr;
        mFirst->next = nullptr;
        mFirst->address = 0x20000;
        mFirst->size = size;
        mFirst->free = false;
        sbrk(size + sizeof(UPage), false);
        return reinterpret_cast<uint8_t*>(mFirst->address) + sizeof(UPage);
    }
    
    if(size + sizeof(UPage) + mVSize > mSize)
    {
        sbrk(size, true);
        return reinterpret_cast<uint8_t*>(mFirst->address);
    }
    
    UPage* newchunk = reinterpret_cast<UPage*>(mBrake);
    newchunk->prev = mFirst;
    newchunk->next = nullptr;
    newchunk->address = mBrake + sizeof(UPage);
    newchunk->free = false;
    newchunk->size = size;
    
    mFirst->next = newchunk;
    mFirst = newchunk;
    sbrk(size + sizeof(UPage),false);
    return reinterpret_cast<uint8_t*>(mFirst->address); // vracime az pouzitelnou pamet, tedy to co nasleduje po hlavicce    
}
