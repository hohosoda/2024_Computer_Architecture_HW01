#include <stdio.h>

void bitwise_divide(int dividend, int divisor, int *quotient, int *remainder) {
    *quotient = 0;
    *remainder = dividend;

    if (divisor == 0) {
        return;
    }
    
    for (int i = 31 ; i >= 0; i--) {
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