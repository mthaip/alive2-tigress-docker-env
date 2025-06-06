// Location of tigress header file in docker container
#include "/usr/local/bin/tigresspkg/4.0.7/tigress.h"

#include <time.h>
#include <pthread.h>
#include<stdlib.h>

int src(int input)
{
    while (input < 10)
    {
        int temp = input;
        if (temp < 6)
        {
            temp++;
        }
        else
        {
            temp += 3;
        }
        input = temp;
    }

    return input;
}

int main()
{
    int input = 0;
    int result = src(input);

    return 0;
}

// clang -S -emit-llvm src.c -o src.ll && clang -S -emit-llvm tgt.c -o tgt.ll

// clang -S -emit-llvm -Xclang -disable-llvm-passes src.c -o src.ll
// clang -S -emit-llvm -fno-discard-value-names src.c -o src.ll