function b = rho(x,y,i,j,I1,I2)
    %varying these rho values will affect the result.
    rho_l = 0.4;
    rho_m = 0.7;
    rho_s = 0.8;
	if I2(i,j) == 1
		if I1(i,j) == I1(x,y)
			b = rho_m;
		else
			b = rho_s;
		end
	else
		if I1(i,j) == I1(x,y)
			if I2(x,y) == 1
				b = rho_m;
			else
				b = rho_l;
			end
		else
			if I2(x,y) == 1
				b = rho_s;
			else
				b = rho_l;
			end
		end
	end									
end	


