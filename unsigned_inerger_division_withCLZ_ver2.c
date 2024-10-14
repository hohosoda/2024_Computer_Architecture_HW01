#include <stdio.h>

int clz(unsigned int x) {
    x |= (x >> 1);
    x |= (x >> 2);
    x |= (x >> 4);
    x |= (x >> 8);
    x |= (x >> 16);

    /* count ones (population count) */
    x -= ((x >> 1) & 0x55555555);
    x = ((x >> 2) & 0x33333333) + (x & 0x33333333);
    x = ((x >> 4) + x) & 0x0f0f0f0f;
    x += (x >> 8);
    x += (x >> 16);

    return (32 - (x & 0x7f));
}

void bitwise_divide(int dividend, int divisor, int *quotient, int *remainder) {
    *quotient = 0;
    *remainder = dividend;

    if (divisor == 0) {
        return;
    }

    int dividend_clz = clz(dividend);
    
    for (int i = 31 - dividend_clz; i >= 0; i--) {
        if ((*remainder >> i) >= divisor) {
            *remainder -= (divisor << i);
            *quotient |= (1 << i);
        }
    }
}

int main() {
    int test_cases[3][2] = {
        {11, 3},
        {19, 0},
        {1, 23}
    };

    for (int i = 0; i < 3; i++) {
        int dividend = test_cases[i][0];
        int divisor = test_cases[i][1];
        int quotient, remainder;

        bitwise_divide(dividend, divisor, &quotient, &remainder);

        if (divisor != 0) {
            printf("Test case : %d => Quotient: %d, Remainder: %d\n", i+1, quotient, remainder);
        } else {
            printf("Test case : %d => Error: Divided by zero!\n", i+1);
        }
    }

    return 0;
}