function bit_stream = golomb_rice_coding(n,p)
    plus_minus = n < 0;
    n   = uint8(abs(n));
    less_significant  = [];
    if p ~= 0
        % Convert decimal numbers to binary vectors
        less_significant = de2bi(bitand(n,(2^p)-1),p,'left-msb');
    end
    most_significant = [zeros(1,floor(double(n)/(2^p))) 1];
    bit_stream = [plus_minus, less_significant, most_significant];
 end
