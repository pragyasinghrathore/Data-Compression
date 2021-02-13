function output_image = lf_decompress(file_name)
    fprintf('decompressing')
% open BS
    fileID = fopen(file_name);
    BS = fread(fileID, '*ubit1', 'ieee-le');
    fclose(fileID);
    BS_input = BS(1:find(BS,1,'last'));
    bl_vect = bs_to_blocks(BS_input);
    
% E matrix
    bl_size = bl_vect(1); bl_rows = bl_vect(2); bl_cols = bl_vect(3);    
    im_size = [(bl_rows*bl_size-bl_vect(4)) (bl_cols*bl_size-bl_vect(5))];
    bl_vect = bl_vect(6:end);
    blocks  = reshape(bl_vect, bl_size, bl_size, []);
    E_      = zeros(bl_rows*bl_size,bl_cols*bl_size);
    for r = 0:bl_rows-1
        for c = 0:bl_cols-1
            E_((bl_size*r+1):(bl_size*(r+1)),(bl_size*c+1):(bl_size*(c+1)))=blocks(:,:,r*bl_cols+c+1);
        end
    end
    
% image
    output_image = uint8(restore_image_from_residual(E_));
    output_image = output_image(1:im_size(1),1:im_size(2));
end