#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>

#define MAXITER 10000000

int fibonacci(int n) {
	if (n == 0)
		return 0;
	else if (n == 1)
		return 1;
	else
		return fibonacci(n - 1) + fibonacci(n - 2);
}

int main(int argc, char** argv) {
	int i;
	double sum;
	
	sum = 0;
        #pragma omp parallel for private(i) reduction(+:sum)
	for (i = 0; i < MAXITER; i++) {
		sum += fibonacci(i%20);
	}
	printf("%.2lf\n", sum);
	return 0;
}

