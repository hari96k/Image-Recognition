function [ output ] = stdMessage( input, size )
output = strcat(input, {blanks(size - strlength(input))} ) ;
end

