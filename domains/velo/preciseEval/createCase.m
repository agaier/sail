function createCase(x, stlFileName,openFoamFolder)

% Create STL
[~,~,~,lRef,aRef] = expressVelo(x,'nPoints',64,'plotting',...
                    false,'export',true,'filename', stlFileName);

% Edit Reference length and Area in case file
forceFname = [openFoamFolder 'system/forceCoeffs'];
tmp = [openFoamFolder 'system/tmp'];
system(['sed -e "30s/.*/lRef ' num2str(lRef) '\;/" < ' forceFname ' > ' tmp]);
system(['sed -e "31s/.*/Aref ' num2str(aRef) '\;/" < ' tmp ' > ' forceFname]);

system(['echo ''' num2str(aRef) ''' > ' openFoamFolder 'aRef.dat']);