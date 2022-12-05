#pragma once
#include <hal/intdef.h>

namespace buffer_constants
{
    const int BUFFER_SIZE = 256;
}

class Buffer
{
    private:
        char mBuffer[buffer_constants::BUFFER_SIZE];
        bool mClaimed;
        
        int mPushPtr;
        int mPullPtr;
    
    public:
        Buffer();
        
        bool Claim();
        
        void Release();
        
        void Push(char c);
        
        char Pull();
        
        int GetDifference();
};

extern Buffer circBuffer;
