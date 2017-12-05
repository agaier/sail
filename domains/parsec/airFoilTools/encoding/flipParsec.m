%% flip map
% Transposes all the fields in a parsec map to align with those of the
% others (temporary, just in case you swap categorization)

A = fieldnames(Parsec);
FlipParsec = Parsec;
for i=1:length(A)-2
    eval(['FlipParsec.' A{i} ' = permute(Parsec.' A{i} ',[2 1 3])'])    
end
FlipParsec.genes = permute(Parsec.genes,[2 1 3 4]);