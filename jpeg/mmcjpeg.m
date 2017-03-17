function mmcjpeg()
	input_img = imread('C:\Users\USER1\Desktop\IMG_PRS\jpeg\h.jpg');
	%input_img = rgb2gray(input_img);
	
	r = input_img(:,:,1);
	g = input_img(:,:,2);
	b = input_img(:,:,3);
	
	y = 0.299 * r + 0.587 * g + 0.114 * b;
	u = -0.147 * r - 0.289 * g + 0.436 * b;
	v = 0.615 * r - 0.515 * g - 0.100 * b;
	
	input_img(:,:,1) = y;
	input_img(:,:,2) = u;
	input_img(:,:,3) = v;
	
	
	[input_row, input_col, layer] = size(input_img);
	num_row = input_row / 8;
	num_col = input_col / 8;
	
	hhh = zeros(input_col * input_row, 1);
	bbby = zeros(8);
	bbbu = zeros(8);
	bbbv = zeros(8);
	
	%quantize tables
	low_compression = 
	
		[1,1,1,1,1,2,2,4;
		1,1,1,1,1,2,2,4;
		1,1,1,1,2,2,2,4;
		1,1,1,1,2,2,4,8;
		1,1,2,2,2,2,4,8;
		2,2,2,2,2,4,8,8;
		2,2,2,4,4,8,8,16;
		4,4,4,4,8,8,16,16];
	
	high_compression = 
	
		[1,2,4,8,16,32,64,128;
		2,4,4,8,16,32,64,128;
		4,4,8,16,32,64,128,128;
		8,8,16,32,64,128,128,256;
		16,16,32,64,128,128,256,256;
		32,32,64,128,128,256,256,256;
		64,64,128,128,256,256,256,156;
		128,128,128,256,256,256,256,256];
	
	map = 
	
		[1,2,6,7,15,16,28,29;
		3,5,8,14,17,27,30,43;
		4,9,13,18,26,31,42,44;
		10,12,19,25,32,41,45,54;
		11,20,24,33,40,46,53,55;
		21,23,34,39,47,52,56,61;
		22,35,38,48,51,57,60,62;
		36,37,49,50,58,59,63,64]
		
	fffy = 1 : 64;
	fffu = 1 : 64;
	fffv = 1 : 64;
	
	cy = 1;
	cu = 1;
	cv = 1;
	
	accu = [0];
	
	output = [];
	%segmentation, devided into 8 * 8 blocks
	
	for i = 0 : (num_row - 1),
		for j = 0 : (num_col - 1),
			
			for ti = 1 : 8,
				for tj = 1 : 8,
					
					bbby(ti,tj) = input_img(ti + i * 8, tj + j * 8, 1);
					bbbu(ti,tj) = input_img(ti + i * 8, tj + j * 8, 2);
					bbbv(ti,tj) = input_img(ti + i * 8, tj + j * 8, 3);
					
				end
			end
			
			bbby = dct2(bbby);
			bbbu = dct2(bbbu);
			bbbv = dct2(bbbv);
			
			%quantize
			
			bbby = bbby./low_compression;
			bbbu = bbbu./high_compression;
			bbbv = bbbv./high_compression;
			
			%zig zag
			
			for ti = 1 : 8,
				for tj = 1 : 8,
					
					st = map(ti, tj);
					fffy(st) = bbby(ti, tj);
					fffu(st) = bbbu(ti, tj);
					fffv(st) = bbbv(ti, tj);
					
				end
			end
			
			%run length coding
			yyy = fffy(1);
			uuu = fffu(1);
			vvv = fffv(1);
			
			for df = 1 : 64,
				
				if fffy(df) == fffy(df - 1),
					cy = cy + 1;
				end
				
				if fffy(df) ~= fffy(df - 1),
					yyy = [yyy cy];
					yyy = [yyy fffy(df)];
					cy = 1;
				end
				
				
				if fffu(df) == fffu(df - 1),
					cu = cu + 1;
				end
				
				if fffu(df) ~= fffu(df - 1),
					uuu = [uuu cu];
					uuu = [uuu fffu(df)];
					cu = 1;
				end
				
				
				if fffv(df) == fffv(df - 1),
					cv = cv + 1;
				end
				
				if fffv(df) ~= fffv(df - 1),
					vvv = [vvv cv];
					vvv = [vvv fffv(df)];
					cv = 1;
				end
				
			end
			
			accu = yyy;
			accu = [accu uuu];
			accu = [accu vvv];
			
			output = [output accu];
		end
	end
	
	%entropy encoding, here we use huffman encoding
	
	p = [];
	
	for jkl = 1 : 10,
		pp = 0;
		for nb = 1 : size(output),
			if jkl == output(nb),
				pp = pp + 1;
			end
		end
		pp = pp / size(output);
		p = [p pp];
	end
	
	[dict, avglen] = huffmandict([1 : 10], p);
	
	comp = huffmanenco(output, dict);
	
	%finish encoding