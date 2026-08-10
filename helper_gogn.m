function T = helper_gogn(gagnasafn)
% =========================================================================
%  helper_gogn  -  Les data_grein.csv og skilar einu gagnasafni úr henni.
%
%  data_grein.csv geymir öll gögn greinarinnar í löngu sniði með dálkunum
%  gagnasafn, rod, lykill, dags, gildi og texti. Fallið les skrána einu sinni
%  og geymir efni hennar í minni (persistent) svo endurtekin köll séu hröð.
%
%  INNTAK:
%     gagnasafn = heiti gagnasafns, t.d. "fastar" eða "rir_ibudalan"
%  ÚTTAK:
%     T = tafla með línum viðkomandi gagnasafns, í sömu röð og í skránni
% =========================================================================

    persistent D
    if isempty(D)
        scriptDir = fileparts(mfilename("fullpath"));
        skra = fullfile(scriptDir, "data_grein.csv");
        if ~isfile(skra)
            error("Finn ekki data_grein.csv í %s. Skráin þarf að vera í sömu möppu og forritin.", scriptDir);
        end
        opts = detectImportOptions(skra, "TextType", "string", ...
            "VariableNamingRule", "preserve");
        opts = setvartype(opts, ["gagnasafn" "rod" "lykill" "dags" "texti"], "string");
        opts = setvartype(opts, "gildi", "double");
        D = readtable(skra, opts);
        % Tómir textareitir eiga að vera tómir strengir, ekki <missing>.
        for v = ["gagnasafn" "rod" "lykill" "dags" "texti"]
            D.(v)(ismissing(D.(v))) = "";
        end
    end
    T = D(D.gagnasafn == string(gagnasafn), :);
    if isempty(T)
        error("Gagnasafnið '%s' finnst ekki í data_grein.csv.", gagnasafn);
    end
end
