function output_image = restore_image_from_residual(E)
    output_image = E;
    predict_image=zeros(size(E));
    E = double(E);
    E(1,1) = 0;
    for i=1:size(E,1)
        for j=1:size(E,2)
             if (i~=1 && j~=1)
                predict_image(i,j)=predictor(output_image,i,j);
                output_image(i,j)=E(i,j)+predict_image(i,j);
             end
        end
    end
output_image = uint8(output_image);
end