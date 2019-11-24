



for r = 0:1:255
   I(r+1) = round(255*exp((log(r/255))*0.45),0);
   %I(r+1) = round(255*((r/255)^0.45),0);
   %J(r+1) = round(255*exp((log10(r/255))*0.45),0);
end

%% output peak
fid20 = fopen('gamma_lut.coe', 'wt');
fprintf(fid20, 'memory_initialization_radix = 16;\n');
fprintf(fid20, 'memory_initialization_vector = \n');
for r = 1:1:255
	fprintf(fid20, '%.2x,\n', I(r));
end
fprintf(fid20, '%.2x;\n', I(256));
fid20 = fclose(fid20);
