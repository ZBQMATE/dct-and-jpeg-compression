#include "dct.h"
#include <math.h>

using namespace std;

//recommended size 8
//double* dct::transdct(double inpt[], int size) {
double* dct::transdct(double inpt[]) {
	
	double pi = 3.1415926535897932;
	
	double ipt[size * size];
	for (int i = 0; i < size * size; i++) {
		ipt[i] = inpt[i];
	}
	
	double output[size * size];
	for (int i = 0; i < size * size; i++) {
		output[i] = 0;
	}
	
	/**/
	double para = 0;
	double ds = (double) size;
	double accu = 0;
	double ttt = 0;
	
	double du, dv, di, dj = 0;
	
	for (int u = 0; u < size; u++) {
		for (int v = 0; v < size; v++) {
			
			if (u == 0 & v == 0) {
				para = 1 / ds;
			}
			if (u == 0 & v != 0) {
				para = sqrt(2) / ds;
			}
			if (u != 0 & v == 0) {
				para = sqrt(2) / ds;
			}
			if (u != 0 & v != 0) {
				para = 2 / ds;
			}
			
			
			for (int i = 0; i < size; i++) {
				for (int j = 0; j < size; j++) {
					
					du = (double) u;
					dv = (double) v;
					di = (double) i;
					dj = (double) j;
					
					ttt = cos((2 * di + 1) * du * pi / (2 * ds));
					ttt = ttt * cos((2 * dj + 1) * dv * pi / (2 * ds));
					
					ttt = ttt * ipt[i * size + j];
					
					accu = accu + ttt;
					
				}
			}
			
			output[u * size + v] = para * accu;
			accu = 0;
		}
	}
	
	double *opt;
	opt = output;
	
	return opt;
	
}