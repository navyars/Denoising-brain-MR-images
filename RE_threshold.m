function t_new = RE_threshold(In,g,t)
%select thresholds in the range of the noisey threshold, Compute RETs and
%select the maximum RET
for k = 1:20
if(k >= 1 && k <=10)
	k_i1 = -k;
else
	k_i1 = k-10;
end
Bl = 0;
Bu = 0;
Ol = 0;
Ou = 0;
flag = 0;	
dim11 = size(In);
for r=1:256
	for c=1:256
		if (mod(r,g) == 1 && mod(c,g) == 1)
            r1 = r+(g-1);
            c1 = c+(g-1);
            rMax = r+(g-1);
            cMax = c+(g-1);
            
			%Ol
			flag = 0;
			for i=r:rMax
				for j=c:cMax
					if(In(i,j) <= t+k_i1)	%for all j, Pj > threshold	
						flag = 1;
						break;
					end
				end
				if flag == 1
					break;
				end		
			end	
			if flag == 0
				Ol = Ol + 1;
			end	
				
			%Bl
			flag = 0;
			for i=r:rMax
				for j=c:cMax
					if(In(i,j) > t+k_i1)	%for all j, Pj <= threshold	
						flag = 1;
						break;
					end
				end
				if flag == 1
					break;
				end		
			end	
			if flag == 0
				Bl = Bl + 1;	
			end	
				
			%Ou
			flag = 0;
			for i=r:rMax
				for j=c:cMax
					if(In(i,j) > t+k_i1)	%there exists a j such that Pj > threshold
						Ou = Ou + 1;
						flag = 1;
						break;
					end
				end
				if flag == 1
					break;
				end		
			end	
			
			%Bu
			flag = 0;
			for i=r:rMax
				for j=c:cMax
					if(In(i,j) <= t+k_i1)	%there exists a j such that Pj <= threshold
						Bu = Bu + 1;
						flag = 1;
						break;
					end
				end
				if flag == 1
					break;
				end		
			end	
					
		end
	end
end
Ro = (Ou - Ol)/(Ou * 1.0);
Rb = (Bu - Bl)/(Bu * 1.0);
e = 2.718;
RET = -1*(e/2)*(Ro*log(Ro) + Rb*log(Rb));
Thresholds1(k) = RET;
end
t_new = (max(Thresholds1))*255;
end
