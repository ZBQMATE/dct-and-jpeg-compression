#include "dct.h"
#include <math.h>

using namespace std;

double* idct::transidct(double inpt[]) {
	
	double pi = 3.1415926535897932;
	
	double ipt[size * size];
	for (int i = 0; i < size * size; i++) {
		ipt[i] = inpt[i];
	}
	
	double output[size * size];
	for (int i = 0; i < size * size; i++) {
		output[i] = 0;
	}
	
	double para = 0;
	double ds = (double) size;
	double accu = 0;
	
	double ttta = 0;
	double tttb = 0;
	double tttc = 0;
	double tttd = 0;
	
	//double tps = 0;
	
	double du, dv, di, dj = 0;
	
	for(int i = 0; i < size; i++) {
		for (int j = 0; j < size; j++) {
			
			for (int u = 0; u < size; u++) {
				for ( int v = 0; v < size; v++) {
					
					du = (double) u;
					dv = (double) v;
					di = (double) i;
					dj = (double) j;
					
					if (u == 0 & v == 0) {
						ttta = ttta + (1 / ds) * ipt[u * size + v];
					}
					
					if (u == 0 & v != 0) {
						tttb = tttb + (sqrt(2) / ds) * ipt[u * size + v] * cos((2 * dj + 1) * pi * dv / (2 * ds));
					}
					
					if (u != 0 & v == 0) {
						tttc = tttc + (sqrt(2) / ds) * ipt[u * size + v] * cos((2 * di + 1) * pi * du / (2 * ds));
					}
					
					if (u != 0 & v != 0) {
						tttd = tttd + (2 / ds) * ipt[u * size + v] * cos((2 * di + 1) * pi * du / (2 * ds)) * cos((2 * dj + 1) * pi * dv / (2 * ds));
					}
					
					accu = ttta + tttb + tttc + tttd;
					
				}
			}
			
			output[i * size + j] = accu;
			ttta = 0;
			tttb = 0;
			tttc = 0;
			tttd = 0;
		}
	}
	
	double *opt;
	opt = output;
	
	return opt;
}