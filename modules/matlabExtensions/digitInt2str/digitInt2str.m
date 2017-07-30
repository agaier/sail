function string = digitInt2str(integer,digits)
%% DigitInt2Str - Converts integer to string with leading zeros
%
% usage: digitInt2str(integer, numberOfDigits)
%
string = int2str(integer);
addZeros = digits - length(string);
if addZeros > 0;
    string = strcat(repmat('0',1,addZeros), string);
end

end