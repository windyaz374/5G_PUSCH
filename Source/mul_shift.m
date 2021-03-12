%mul_shift is shifting array x to the left k times
function y = mul_shift(x,k)
if (k == -1)
    y = zeros(1,length(x));
else 
    %y = [x(k+1:end) x(1:k)];
    y = circshift(x,-k);
end 

        
       