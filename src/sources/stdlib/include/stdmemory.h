#pragma once
#include<hal/intdef.h>
#include<memory/memmap.h>


struct UPage
{
    UPage* prev;
    UPage* next;
    uint32_t address;
    uint32_t size;
    bool free;
};

class CUserHeapMan
{
    private:
        UPage* mFirst;
        uint32_t mSize;
        uint32_t mVSize;
        uint32_t mBrake;
        uint32_t* PTptr;
        uint32_t GetNewPage(uint32_t NewVAddress);
        uint32_t GetFirstNewPage(uint32_t NewVAddress);
        
    public:
        CUserHeapMan();
        void* Alloc(uint32_t size);
        template<class T>
        T* Alloc()
        {
            return reinterpret_cast<T*>(Alloc(sizeof(T)));
        }
        void sbrk(uint32_t size, bool over);
};

extern CUserHeapMan sUserHeap;

inline void* operator new(uint32_t size)
{
    return sUserHeap.Alloc(size);
}

inline void* operator new[](uint32_t size)
{
    return sUserHeap.Alloc(size);
}

inline void *operator new(uint32_t, void *p)
{
    return p;
}

inline void *operator new[](uint32_t, void *p)
{
    return p;
}

inline void operator delete(void* p)
{
   // sUserHeap.Free(p);
}

inline void operator delete(void* p, uint32_t)
{
   // sUserHeap.Free(p);
}

inline void  operator delete  (void *, void *)
{
}

inline void  operator delete[](void *, void *)
{
}
