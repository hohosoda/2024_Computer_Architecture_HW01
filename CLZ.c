#include <stdio.h>

int clz(unsigned int value) {
    int count = 0;
    for (int i = 31; i >= 0; i--) {
        if ((value & (1U << i)) == 0) {
            count++;
        } else {
            break;
        }
    }
    return count;
}

int main() {

    unsigned int test_cases[] = {0x00000000, 0x00080000, 0x80000000};

    for (int i = 0; i < 3; i++) {
        unsigned int test_value = test_cases[i];
        int result = clz(test_value);
        printf("Test case %d : leading zeros = %d\n",i + 1, result);
    }

    return 0;
}