function info = io_loadinfo_hl(infotxtdirectory)
    info.infoname = dir(fullfile(info.analyzefolder, '*_info.txt'));
        info.infoname = info.infoname.name;
        tmp.infopath = fullfile(info.analyzefolder, info.infoname);
        tmp.info_table = readtable(tmp.infopath);

        for i = 1:height(tmp.info_table)
            info.(tmp.info_table.Field{i}) = tmp.info_table.Value{i}; 
        end
        obj.info = info;
    end