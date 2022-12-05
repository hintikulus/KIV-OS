#include <stdbuffer.h>

Buffer circBuffer;

Buffer::Buffer()
    : mPushPtr(0), mPullPtr(0), mClaimed(false)
{
    for(int i = 0; i < buffer_constants::BUFFER_SIZE; i++)
    {
        mBuffer[i] = '\0';
    }
}

bool Buffer::Claim()
{
    if(mClaimed)
        return false;
        
    mClaimed = true;
    return true;
}

void Buffer::Release()
{
    for(int i = 0; i <= buffer_constants::BUFFER_SIZE; i++)
    {
        mBuffer[i] = '\0';
    }
    
    mClaimed = false;
}

int Buffer::GetDifference()
{
    return mPushPtr-mPullPtr;
}

void Buffer::Push(char c)
{
    mBuffer[mPushPtr] = c;
    mPushPtr = (mPushPtr + 1) % buffer_constants::BUFFER_SIZE;
}

char Buffer::Pull()
{
    if(mPullPtr == mPushPtr)
        return '\0';
    char ret;
    ret = mBuffer[mPullPtr];
    mPullPtr = (mPullPtr + 1) % buffer_constants::BUFFER_SIZE;    
    return ret;
}

