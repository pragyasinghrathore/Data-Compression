function number = golomb_rice_decoding(bits,p)    
    bits       = reshape(bits,1,[]);
    bits       = bits(1: find(bits,1,'last'));
    plus_minus = 1;
    if bits(1) == 1
        plus_minus = -1;
    end
    r = 0;
    if p~=0
        r=bi2de(bits(2:2+p-1),'left-msb');
    end
    q       = (2^p)*(length(bits)-p-2);
    number  = plus_minus*int16(r+q);
 end