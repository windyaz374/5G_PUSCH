function x = layer_mapping(in,ncw,nlayer)
in = in';
    switch ncw
        case 1
            switch nlayer
                case 1
                    x = in;
                case 2
                    x = cell(1,2);
                    x{1} = in(1:2:end);
                    x{2} = in(2:2:end);
                case 3
                    x = cell(1,3);
                    x{1} = in(1:3:end);
                    x{2} = in(2:3:end);
                    x{3} = in(3:3:end);
                case 4
                    x = cell(1,4);
                    x{1} = in(1:4:end);
                    x{2} = in(2:4:end);
                    x{3} = in(3:4:end);
                    x{4} = in(4:3:end);
            end
        case 2
            switch nlayer
                case 5
                    x = cell(1,5);
                    x{1} = in{1}(1:2:end);
                    x{2} = in{1}(2:2:end);
                    x{3} = in{2}(1:3:end);
                    x{4} = in{2}(2:3:end);
                    x{5} = in{2}(3:3:end);
                case 6
                    x = cell(1,6);
                    x{1} = in{1}(1:3:end);
                    x{2} = in{1}(2:3:end);
                    x{3} = in{1}(3:3:end);
                    x{4} = in{2}(1:3:end);
                    x{5} = in{2}(2:3:end);
                    x{6} = in{2}(3:3:end);              
                case 7
                    x = cell(1,7);
                    x{1} = in{1}(1:3:end);
                    x{2} = in{1}(2:3:end);
                    x{3} = in{1}(3:3:end);
                    x{4} = in{2}(1:4:end);
                    x{5} = in{2}(2:4:end);
                    x{6} = in{2}(3:4:end);  
                    x{7} = in{2}(4:4:end); 
                case 8
                    x = cell(1,8);
                    x{1} = in{1}(1:4:end);
                    x{2} = in{1}(2:4:end);
                    x{3} = in{1}(3:4:end);
                    x{4} = in{1}(4:4:end);
                    x{5} = in{2}(1:4:end);
                    x{6} = in{2}(2:4:end);
                    x{7} = in{2}(3:4:end);  
                    x{8} = in{2}(4:4:end); 
            end
    end

x = x';
end

