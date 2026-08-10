function fig_heildarskuldir_sparnadur()
% =========================================================================
%  fig_heildarskuldir_sparnadur
%
%  Reiknar og teiknar árlega raunvaxtabyrði útistandandi íbúðalána heimila
%  við núverandi íslenska raunvexti og við dæmigerða evru-raunvexti.
% =========================================================================
% Forsendur úr data_grein.csv.
debt  = helper_fasti("skuldir_heimila_makr");   % ma.kr., útistandandi íbúðalán heimila
gdp   = helper_fasti("vlf_makr");               % ma.kr., VLF-viðmið
rIce  = helper_fasti("r_island_verdtryggt");    % prósent
rEuro = helper_fasti("r_evra_grunnmat");        % prósent, ólínulegt grunnmat

current = debt * rIce / 100;
euro = debt * rEuro / 100;
saving = current - euro;

T = table(debt, gdp, rIce, rEuro, current, euro, saving, 100 * saving / gdp, ...
    'VariableNames', {'ibudalan_ma_kr','vlf_ma_kr','raunvextir_island', ...
    'raunvextir_evra','byrdi_island_ma_kr','byrdi_evra_ma_kr', ...
    'munur_ma_kr','munur_hlutfall_vlf'});

% Forsendutaflan sem sjálfstæður MATLAB-gluggi.
radirF = strings(6, 3);
radirF(1,:) = ["Útistandandi íbúðalán heimila", fmt1(debt) + " ma.kr.", "Seðlabanki Íslands, 4. ársfj. 2025"];
radirF(2,:) = ["Verg landsframleiðsla (VLF)", fmt0(gdp) + " ma.kr.", "Hagstofa Íslands, 2025"];
radirF(3,:) = ["Raunvextir Íslands", fmt1(rIce) + "%", "verðtryggð markaðstala"];
radirF(4,:) = ["Raunvextir evrusvæðis", fmt1(rEuro) + "%", "ECB MIR apríl 2026 / EC-spá"];
radirF(5,:) = ["Mismunur (verðtryggt viðmið)", fmt1(rIce - rEuro) + " pr.st.", "Ísland að frádregnu evrusvæði"];
radirF(6,:) = ["Árleg lækkun raunvaxtabyrði", fmt0(saving) + " ma.kr.", fmt1(100 * saving / gdp) + "% af VLF"];
helper_tafla_gluggi("Árleg lækkun raunvaxtabyrði: forsendur og miðmat", ...
    "Miðmatið notar verðtryggða íslenska raunvexti og grunnmat á evru-raunvöxtum.", ...
    ["Stærð", "Gildi", "Heimild"], ["l" "r" "l"], radirF, ...
    "Gögn: data_grein.csv.");

scenario = ["Varfært mat"; "Miðmat"; "Hærra vaxtamat"];
S = helper_gogn("svidsmyndir");
sv = ["varfaert"; "midmat"; "haerra"];
iceRate  = arrayfun(@(s) S.gildi(S.rod == "r_island" & S.lykill == s), sv);
euroRate = arrayfun(@(s) S.gildi(S.rod == "r_evra"   & S.lykill == s), sv);
burdenIce = debt .* iceRate ./ 100;
burdenEuro = debt .* euroRate ./ 100;
sensitivitySaving = burdenIce - burdenEuro;
shareGdp = 100 .* sensitivitySaving ./ gdp;
% Næmnitaflan sem sjálfstæður MATLAB-gluggi.
radirN = strings(3, 7);
for k = 1:3
    radirN(k,:) = [scenario(k), fmt2(iceRate(k)), fmt2(euroRate(k)), ...
        fmt0(burdenIce(k)), fmt0(burdenEuro(k)), fmt0(sensitivitySaving(k)), fmt1(shareGdp(k))];
end
helper_tafla_gluggi("Næmni mats á árlegri raunvaxtabyrði", ...
    "Sviðsmyndirnar eru þær sömu og í heimilisdæminu; mismunur er reiknaður á órúnnuðum tölum.", ...
    ["Forsenda", sprintf("r Ísl.\n(%%)"), sprintf("r evru\n(%%)"), sprintf("Byrði Ísl.\n(ma.kr.)"), ...
     sprintf("Byrði evru\n(ma.kr.)"), sprintf("Munur\n(ma.kr.)"), sprintf("%% af\nVLF")], ...
    ["l" "r" "r" "r" "r" "r" "r"], radirN, ...
    "Gögn: data_grein.csv.");

RED = [178 58 72] / 255;
BLUE = [48 101 164] / 255;
DARK = [0.11 0.11 0.11];
GREY = [0.47 0.47 0.47];

vals = [round(euro), round(current)];
shares = 100 * vals / gdp;
komma1 = @(x) strrep(sprintf("%.1f", x), ".", ",");
y = [1 2];

f = figure("Color","w","Units","inches","Position",[1 1 8.6 5.2]);
ax = axes(f); hold(ax,"on");
b = barh(ax, y, vals, 0.46, "FaceColor","flat", "EdgeColor","w", "LineWidth",1.2);
b.CData = [BLUE; RED];

for k = 1:2
    text(ax, vals(k) + 3, y(k), sprintf("%d ma.kr.\n%s%% af VLF", vals(k), komma1(shares(k))), ...
        "Color",DARK, "FontWeight","bold", "FontSize",11.5, ...
        "HorizontalAlignment","left", "VerticalAlignment","middle");
end

text(ax, 77, 1.45, sprintf("Munur: %.0f ma.kr. á ári\n%s%% af VLF", saving, komma1(100 * saving / gdp)), ...
    "Color",DARK, "FontWeight","bold", "FontSize",11.5, ...
    "HorizontalAlignment","center", "VerticalAlignment","middle");
plot(ax, [euro 67], [1.34 1.45], "-", "Color",GREY, "LineWidth",1.4);

xlim(ax, [0 150]);
ylim(ax, [0.45 2.55]);
set(ax, "YTick",[1 2], "YTickLabel",["Evrukjör", "Íslensk kjör"], ...
    "XTick",0:20:140, "FontSize",10.5, "TickLength",[0 0]);
xlabel(ax, "Árleg raunvaxtabyrði heimila (ma.kr., upphaf 2026)", ...
    "FontSize",10.5, "Color",[0.2 0.2 0.2]);
ax.XGrid = "on";
ax.GridColor = [0.94 0.94 0.94];
ax.GridAlpha = 1;
ax.Layer = "bottom";
ax.XColor = [0.30 0.30 0.30];
ax.YColor = [0.30 0.30 0.30];
box(ax,"off");
set(ax, "Position",[0.20 0.30 0.74 0.42]);

annotation(f, "textbox", [0.055 0.955 0.90 0.050], ...
    "String","Árleg raunvaxtabyrði útistandandi íbúðalána heimila", ...
    "FontSize",15, "FontWeight","bold", "Color",DARK, ...
    "EdgeColor","none", "VerticalAlignment","top");
annotation(f, "textbox", [0.055 0.895 0.90 0.035], ...
    "String","Íslenskir raunvextir bornir saman við dæmigerða evru-raunvexti", ...
    "FontSize",10.5, "Color",GREY, "EdgeColor","none", "VerticalAlignment","top");
annotation(f, "textbox", [0.055 0.055 0.90 0.060], ...
    "String","Forsendur: útistandandi íbúðalán heimila 2.896,5 ma.kr.; íslenskir raunvextir 4,5%; evru-raunvextir 0,77%. Gögn: Seðlabanki Íslands, 4. ársfjórðungur 2025; ECB MIR apríl 2026; vorspá framkvæmdastjórnar ESB og VLF Hagstofu Íslands 2025.", ...
    "FontSize",7.8, "Color",GREY, "EdgeColor","none", "VerticalAlignment","top");
end

function s = fmt0(x)
s = fmt_number(x, 0);
end

function s = fmt1(x)
s = fmt_number(x, 1);
end

function s = fmt2(x)
s = fmt_number(x, 2);
end

function s = fmt_number(x, decimals)
raw = sprintf(sprintf("%%.%df", decimals), x);
parts = strsplit(raw, ".");
whole = parts{1};
chunks = regexp(fliplr(whole), ".{1,3}", "match");
for j = 1:numel(chunks)
    chunks{j} = fliplr(chunks{j});
end
wholeOut = strjoin(fliplr(chunks), ".");
if decimals > 0
    s = wholeOut + "," + parts{2};
else
    s = string(wholeOut);
end
end
