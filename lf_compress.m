function BS=lf_compress(A_input,file_name,b)
    fprintf('compressing')

% padding   
    e2            = b-mod(size(A_input,2),b);
    e1            = b-mod(size(A_input,1),b);
    A             = padarray(A_input,[e1,e2],'replicate','post'); 
    rows          = (size(A,1)/b);
    columns       = (size(A,2)/b);
    blocks_number = rows*columns;

% residual matrix
   Z_ = zeros(size(A));
   for i = 1:size(A,1)
        for j = 1:size(A,2)
            if (i ~= 1 && j ~= 1)
                Z_(i, j) = predictor(A,i,j);
            end
        end
    end
    E      = int16(A)-int16(Z_);
    E(1,1) = A(1,1);

% encode
    BS = reshape(de2bi([b,rows,columns,e1,e2],8,'left-msb')',1,[]);
    for bi = 1:blocks_number
        
        % obtain block      
        columns_2 = (size(E,2)/b) ;
        rows_i = floor(bi/columns_2);
        columns_i = mod(bi, columns_2) ;
        if (columns_i == 0) 
            columns_i = columns_2;
            rows_i = rows_i - 1 ;
        end
        columns_i = columns_i-1;
        block = E((b*rows_i+1):(b*(rows_i+1)),(b*columns_i+1):(b*(columns_i+1)));
    
        % optimal parameters
        vector       = reshape(block,1,[]);
        m            = log(mean(abs(vector)));
        [~,i]        = min(abs(double(0:8)-m));
        p            = i-1;
        
        % encoding loop
        bit_stream = [];
        vector_p = p*ones(1,length(vector));
            for iterator = 1:length(vector)
                bit_stream = [bit_stream golomb_rice_coding(vector(iterator), vector_p(iterator))];
            end
    
        p_optimal    = p;
        bs_optimal   = [de2bi(p_optimal,8,'left-msb') bit_stream];      
        BS = [BS bs_optimal];      
    end
    
% save
    fileID = fopen(file_name, 'w');
    fwrite(fileID, BS, 'ubit1');
    fclose(fileID);
    file_size = length(BS);
end