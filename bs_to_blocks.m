function vector = bs_to_blocks(BS)
    BS     = reshape(BS,1,[]);
    BS     = BS(1: find(BS, 1, 'last'));
    vector = zeros(1,5);
    for iterator = 0:4
        vector(iterator+1) = bi2de(BS(iterator*8+(1:8)), 'left-msb');
    end
    BS       = BS((8*5+1):end);
    iterator = 0;
    while ~isempty(BS)
        if(mod(iterator, vector(1)*vector(1))==0)
            p  = double(bi2de(BS(1:8),'left-msb'));
            BS = BS(9:end);
        end
        iterator      = iterator+1;
        last_iterator = find(BS(1+p+1:end),1,'first')+(1+p);
        if isempty(last_iterator)
            break;
        end
        vector = [vector golomb_rice_decoding(BS(1:last_iterator),p)];
        BS     = BS(last_iterator + 1:end);
    end
end