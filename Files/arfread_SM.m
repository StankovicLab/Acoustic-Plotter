function data = arfread_SM(PATH, varargin)
%ARFREAD  TDT arf file reader.
%   data = arfread(PATH), where PATH is a string containing the path to an 
%   arf file, retrieves all data from specified arf file in struct format.
%
%   data.groups
%     contains array of all group information 
%
%   data.groups(..).recs
%     contains array of all record information from the indexed group
%
%   data.groups(..).recs(..).data
%     contains the actual ABR data from the indexed group and record
%
%   data = arfread(PATH, 'parameter', value,...)
%
%   'parameter', value pairs
%      'PLOT'       logical, turns plotting on or off (default = false)
%      'RP'         logical, file was recorded by BioSigRP (default = false for BioSigRZ files)
%

% defaults
PLOT  = false;
RP    = false;

% parse varargin
for i = 1:2:length(varargin)
    eval([upper(varargin{i}) '=varargin{i+1};']);
end

isRZ = ~RP;

data = struct('RecHead', [], 'groups', []);

%open file
fid = fopen(PATH,'r');
if fid == -1, error(['error opening file ' PATH]), end;

%open RecHead data
data.RecHead.ftype=fread(fid,1,'int16');
data.RecHead.ngrps=fread(fid,1,'int16');
data.RecHead.nrecs=fread(fid,1,'int16');
data.RecHead.grpseek=fread(fid,200,'int32');
data.RecHead.recseek=fread(fid,2000,'int32');
data.RecHead.file_ptr=fread(fid,1,'int32');

data.groups = [];
bFirstPass = true;
for x = 1:data.RecHead.ngrps
    
    % jump to the group location in the file
    fseek(fid,data.RecHead.grpseek(x),'bof');

    % open the group
    data.groups(x).grpn=fread(fid,1,'int16');
    data.groups(x).frecn=fread(fid,1,'int16');
    data.groups(x).nrecs=fread(fid,1,'int16');
    data.groups(x).ID=get_str(fread(fid,16,'uint8'));
    data.groups(x).ref1=get_str(fread(fid,16,'uint8'));
    data.groups(x).ref2=get_str(fread(fid,16,'uint8'));
    data.groups(x).memo=get_str(fread(fid,50,'uint8'));

    % read temporary timestamp
    if bFirstPass
        if isRZ
            ttt = fread(fid,1,'int64');
            fseek(fid, -8, 0); 
            data.fileType = 'BioSigRZ';
        else
            ttt = fread(fid,1,'uint32');
            fseek(fid, -4, 0);
            data.fileType = 'BioSigRP';
        end
        data.fileTime = datestr(ttt/86400+datenum(1970,1,1));
        bFirstPass = false;
    end
        
    if isRZ
        data.groups(x).beg_t=fread(fid,1,'int64');
        data.groups(x).end_t=fread(fid,1,'int64');
    else
        data.groups(x).beg_t=fread(fid,1,'int32');
        data.groups(x).end_t=fread(fid,1,'int32');
    end

    data.groups(x).sgfname1=get_str(fread(fid,100,'uint8'));
    data.groups(x).sgfname2=get_str(fread(fid,100,'uint8'));

    data.groups(x).VarName1=get_str(fread(fid,15,'uint8'));
    data.groups(x).VarName2=get_str(fread(fid,15,'uint8'));
    data.groups(x).VarName3=get_str(fread(fid,15,'uint8'));
    data.groups(x).VarName4=get_str(fread(fid,15,'uint8'));
    data.groups(x).VarName5=get_str(fread(fid,15,'uint8'));
    data.groups(x).VarName6=get_str(fread(fid,15,'uint8'));
    data.groups(x).VarName7=get_str(fread(fid,15,'uint8'));
    data.groups(x).VarName8=get_str(fread(fid,15,'uint8'));
    data.groups(x).VarName9=get_str(fread(fid,15,'uint8'));
    data.groups(x).VarName10=get_str(fread(fid,15,'uint8'));

    data.groups(x).VarUnit1=get_str(fread(fid,5,'uint8'));
    data.groups(x).VarUnit2=get_str(fread(fid,5,'uint8'));
    data.groups(x).VarUnit3=get_str(fread(fid,5,'uint8'));
    data.groups(x).VarUnit4=get_str(fread(fid,5,'uint8'));
    data.groups(x).VarUnit5=get_str(fread(fid,5,'uint8'));
    data.groups(x).VarUnit6=get_str(fread(fid,5,'uint8'));
    data.groups(x).VarUnit7=get_str(fread(fid,5,'uint8'));
    data.groups(x).VarUnit8=get_str(fread(fid,5,'uint8'));
    data.groups(x).VarUnit9=get_str(fread(fid,5,'uint8'));
    data.groups(x).VarUnit10=get_str(fread(fid,5,'uint8'));

    data.groups(x).SampPer_us=fread(fid,1,'float');

    data.groups(x).cc_t=fread(fid,1,'int32');
    data.groups(x).version=fread(fid,1,'int16');
    data.groups(x).postproc=fread(fid,1,'int32');
    data.groups(x).dump=get_str(fread(fid,92,'uint8'));

    %disp(data.groups(x).ID)
    %disp(data.groups(x).ref1)
    %disp(data.groups(x).ref2)

    data.groups(x).recs = [];%cell(1, data.groups(x).nrecs);
    for i=1:data.groups(x).nrecs
        data.groups(x).recs(i).recn=fread(fid,1,'int16');
        data.groups(x).recs(i).grpid=fread(fid,1,'int16');
        if isRZ
            data.groups(x).recs(i).grp_t=fread(fid,1,'int64');
        else
            data.groups(x).recs(i).grp_t=fread(fid,1,'int32');
        end
        data.groups(x).recs(i).grp_d=datestr(data.groups(x).recs(i).grp_t/86400+datenum(1970,1,1));
        data.groups(x).recs(i).newgrp=fread(fid,1,'int16');
        data.groups(x).recs(i).sgi=fread(fid,1,'int16');
        data.groups(x).recs(i).chan=fread(fid,1,'uint8');
        data.groups(x).recs(i).rtype=get_str(fread(fid,1,'uint8'));

        if isRZ
            data.groups(x).recs(i).npts=fread(fid,1,'uint16');
        else
            data.groups(x).recs(i).npts=fread(fid,1,'int16');
        end
        data.groups(x).recs(i).osdel=fread(fid,1,'float');
        data.groups(x).recs(i).dur_ms=fread(fid,1,'float');
        data.groups(x).recs(i).SampPer_us=fread(fid,1,'float');

        data.groups(x).recs(i).artthresh=fread(fid,1,'float');
        data.groups(x).recs(i).gain=fread(fid,1,'float');
        data.groups(x).recs(i).accouple=fread(fid,1,'int16');

        data.groups(x).recs(i).navgs=fread(fid,1,'int16');
        data.groups(x).recs(i).narts=fread(fid,1,'int16');

        if isRZ
            data.groups(x).recs(i).beg_t=fread(fid,1,'int64');
            data.groups(x).recs(i).end_t=fread(fid,1,'int64');
        else
            data.groups(x).recs(i).beg_t=fread(fid,1,'int32');
            data.groups(x).recs(i).end_t=fread(fid,1,'int32');
        end
        data.groups(x).recs(i).Var1=fread(fid,1,'float');
        data.groups(x).recs(i).Var2=fread(fid,1,'float');
        data.groups(x).recs(i).Var3=fread(fid,1,'float');
        data.groups(x).recs(i).Var4=fread(fid,1,'float');
        data.groups(x).recs(i).Var5=fread(fid,1,'float');
        data.groups(x).recs(i).Var6=fread(fid,1,'float');
        data.groups(x).recs(i).Var7=fread(fid,1,'float');
        data.groups(x).recs(i).Var8=fread(fid,1,'float');
        data.groups(x).recs(i).Var9=fread(fid,1,'float');
        data.groups(x).recs(i).Var10=fread(fid,1,'float');

        % index current location
        idx = ftell(fid);

        % extract curser frequency information and read into struct,
        for j = 1:9*10
            % catch to make sure there was a curser
            go = fread(fid,1,'float');
            if isempty(go)
                test(j) =  nan;
            else
                test(j) =  go;
            end
        end

        data.groups(x).recs(i).Cur1F=test(1);
        data.groups(x).recs(i).Cur2F=test(10);
        data.groups(x).recs(i).Cur3F=test(19);
        data.groups(x).recs(i).Cur4F=test(28);
        data.groups(x).recs(i).Cur5F=test(37);
        data.groups(x).recs(i).Cur6F=test(46);
        data.groups(x).recs(i).Cur7F=test(55);
        data.groups(x).recs(i).Cur8F=test(64);
        data.groups(x).recs(i).Cur9F=test(73);
        data.groups(x).recs(i).Cur10F=test(82);

        % go back to begining and skip to indexed location
        fseek(fid,idx,'bof');
        % skip all 10 cursors placeholders
        fseek(fid,36*10,'cof');

        % catch to make sure there is data
        try
            data.groups(x).recs(i).data=fread(fid,data.groups(x).recs(i).npts,'float');
        catch
            disp(['Group ', num2str(x), ' Recording ', num2str(i), ' not found'])
        end
    end

    if PLOT
        figure;
        
        % determine reasonable spacing between plots
        d = arrayfun(@(x)(x.data), data.groups(1).recs, 'UniformOutput', false);
        plot_offset = max(max(abs(cell2mat(d))))*1.2;
        
        for i = 1:data.groups(x).nrecs
            plot(data.groups(x).recs(i).data - plot_offset*i);
            hold on;
        end
        
        % use Var2 as the Y-axis label
        %set(gca,'YTick',(-plot_offset*data.groups(x).nrecs):plot_offset:0)
        %d = arrayfun(@(x)(num2str(x.Var2)), data.groups(x).recs, 'UniformOutput', false);
        %set(gca,'YTickLabel',fliplr(d))
        
        title(['Group ' num2str(data.groups(x).grpn)]);
        axis 'off';

    end
end

fclose(fid);

end

function str = get_str(str)
    % return string up until null character only
    ind = find(str == 0, 1);
    if ind > 1
        str = str(1:ind-1);
    end
    str = char(str');
end