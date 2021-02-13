function estimation = predictor(A,i,j)
    values = [];
    west_i  = i-1;
    west_j  = j-1;
    north_j = j+1;
    
    if (west_i>=1)
        values(end+1)=A(west_i,j);
        if (west_j>=1)
            values(end+1) = A(west_i, west_j);
        end
        if (north_j<=size(A,2))
            values(end+1)=A(west_i, north_j);
        end
    end
    if (west_j>= 1)
        values(end+1)=A(i,west_j);
    end
    estimation = int16(median(values));
end