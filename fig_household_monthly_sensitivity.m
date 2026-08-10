function fig_household_monthly_sensitivity()
% =========================================================================
%  fig_household_monthly_sensitivity
%
%  Næmnigreining fyrir dæmigert heimili:
%  mánaðarleg greiðsla af 60 m.kr. jafngreiðsluláni, skipt í vexti og
%  eignamyndun, undir þremur raunvaxtaforsendum. Birtir jafnframt töflu
%  um heildargreiðslur yfir allan lánstímann.
%
% =========================================================================
% Forsendur og sviðsmyndir úr data_grein.csv.
P = helper_fasti("lan_hofudstoll_mkr");   % m.kr.
years = helper_fasti("lan_ar");
n = years * 12;

scenario = ["Varfært mat"; "Miðmat"; "Hærra mat"];
S = helper_gogn("svidsmyndir");
sv = ["varfaert"; "midmat"; "haerra"];
iceRate  = arrayfun(@(s) S.gildi(S.rod == "r_island" & S.lykill == s), sv);
euroRate = arrayfun(@(s) S.gildi(S.rod == "r_evra"   & S.lykill == s), sv);

monthlyIce  = arrayfun(@(r) helper_annuity(P, r, n), iceRate);
monthlyEuro = arrayfun(@(r) helper_annuity(P, r, n), euroRate);

% Skipting fyrsta mánaðar. Allar stærðir í m.kr.; myndin notar þús.kr.
monthlyInterestIce  = P .* (iceRate / 100) / 12;
monthlyInterestEuro = P .* (euroRate / 100) / 12;
monthlyPrincipalIce  = monthlyIce  - monthlyInterestIce;
monthlyPrincipalEuro = monthlyEuro - monthlyInterestEuro;

totalIce  = monthlyIce  * n;
totalEuro = monthlyEuro * n;
interestIce  = totalIce  - P;
interestEuro = totalEuro - P;

% Rekjanleg tafla með öllum stærðum sem liggja að baki myndinni.
contract = repmat(["Króna"; "Evra"], 3, 1);
scenarioLong = repelem(scenario, 2);
rate = reshape([iceRate euroRate].', [], 1);
monthlyPayment = reshape([monthlyIce monthlyEuro].', [], 1);
monthlyInterest = reshape([monthlyInterestIce monthlyInterestEuro].', [], 1);
monthlyPrincipal = reshape([monthlyPrincipalIce monthlyPrincipalEuro].', [], 1);
totalPayment = reshape([totalIce totalEuro].', [], 1);
interestPaid = reshape([interestIce interestEuro].', [], 1);
interestShare = 100 * interestPaid ./ totalPayment;
T = table(scenarioLong, contract, rate, monthlyPayment, monthlyInterest, ...
    monthlyPrincipal, totalPayment, interestPaid, interestShare, ...
    'VariableNames', {'forsenda','lan','raunvextir','manadargreidsla_mkr', ...
    'manadarvextir_mkr','manadar_eignamyndun_mkr','heildargreidsla_mkr', ...
    'vextir_mkr','vextir_hlutfall'});

% Tafla um heildargreiðslur yfir 25 ár sem sjálfstæður MATLAB-gluggi.
radirT = strings(6, 6);
for k = 1:3
    radirT(2*k-1,:) = [scenario(k), "Króna", sprintf("%.0f", P), sprintf("%.0f", interestIce(k)), ...
        sprintf("%.0f", totalIce(k)), sprintf("%.0f%%", 100 * interestIce(k) / totalIce(k))];
    radirT(2*k,:)   = ["", "Evra", sprintf("%.0f", P), sprintf("%.0f", interestEuro(k)), ...
        sprintf("%.0f", totalEuro(k)), sprintf("%.0f%%", 100 * interestEuro(k) / totalEuro(k))];
end
helper_tafla_gluggi("Heildarútgjöld yfir 25 ára lánstíma", ...
    "Skipting heildargreiðslna í endurgreiddan höfuðstól og vexti, á verðlagi 2026.", ...
    ["Forsenda", "Lán", sprintf("Höfuðstóll\n(m.kr.)"), sprintf("Vextir\n(m.kr.)"), ...
     sprintf("Heildargreiðsla\n(m.kr.)"), sprintf("Vaxtahlutfall\naf greiðslum")], ...
    ["l" "l" "r" "r" "r" "r"], radirT, ...
    "Gögn: data_grein.csv.");

GREEN = [94 156 123] / 255;
RED   = [178 58 72] / 255;
DARK  = [0.12 0.12 0.12];
GRAY  = [0.47 0.47 0.47];

x = [1 2 3.8 4.8 6.6 7.6];
xLimits = [0.25 8.35];
axPosition = [0.09 0.25 0.88 0.58];

% Birtingartölur: heildargreiðslan og eignamyndunin eru ávalaðar í heilar
% þúsundir króna og vextirnir fást sem mismunur þeirra. Þannig stemma
% hlutar hverrar súlu innbyrðis og við mynd 1.
totals    = round(1000 * reshape([monthlyIce monthlyEuro].', [], 1));
principal = round(1000 * reshape([monthlyPrincipalIce monthlyPrincipalEuro].', [], 1));
interest  = totals - principal;
data = [principal interest];

barLabel = repmat(["Króna"; "Evra"], 3, 1);
rateLabel = strings(6, 1);
for k = 1:3
    rateLabel(2*k-1) = sprintf("%.1f%%", iceRate(k));
    rateLabel(2*k)   = sprintf("%.1f%%", euroRate(k));
end

f = figure("Color", "w", "Units", "inches", "Position", [1 1 9.2 6.4]);
ax = axes(f); hold(ax, "on");

b = bar(ax, x, data, 0.72, "stacked");
b(1).FaceColor = GREEN; b(1).EdgeColor = "w"; b(1).LineWidth = 1.0;
b(2).FaceColor = RED;   b(2).EdgeColor = "w"; b(2).LineWidth = 1.0;

yMax = max(totals) * 1.30;
ylim(ax, [-70 yMax]);
xlim(ax, xLimits);

% Merki inni í súlum.
for j = 1:numel(x)
    text(ax, x(j), principal(j)/2, sprintf("%.0f", principal(j)), ...
        "Color", "w", "FontWeight", "bold", "FontSize", 10.5, ...
        "HorizontalAlignment", "center", "VerticalAlignment", "middle");

    if interest(j) >= 28
        text(ax, x(j), principal(j) + interest(j)/2, sprintf("%.0f", interest(j)), ...
            "Color", "w", "FontWeight", "bold", "FontSize", 10.5, ...
            "HorizontalAlignment", "center", "VerticalAlignment", "middle");
    else
        text(ax, x(j), principal(j) + interest(j) + 9, sprintf("%.0f", interest(j)), ...
            "Color", RED, "FontWeight", "bold", "FontSize", 10.0, ...
            "HorizontalAlignment", "center", "VerticalAlignment", "bottom");
    end

    text(ax, x(j), totals(j) + 12, sprintf("%.0f þús.kr.", totals(j)), ...
        "Color", DARK, "FontWeight", "bold", "FontSize", 10.4, ...
        "HorizontalAlignment", "center", "VerticalAlignment", "bottom");

    text(ax, x(j), -15, sprintf("%s\n%s", barLabel(j), rateLabel(j)), ...
        "Color", DARK, "FontSize", 9.2, ...
        "HorizontalAlignment", "center", "VerticalAlignment", "top");
end

% Hópaheiti og munur í mánaðargreiðslu innan hvers hóps.
for k = 1:3
    idxIce = 2*k - 1;
    idxEu  = 2*k;
    xc = mean([x(idxIce), x(idxEu)]);

    diffMonthly = totals(idxIce) - totals(idxEu);
    yb = max(totals(idxIce), totals(idxEu)) + 42;
    plot(ax, [x(idxIce) x(idxEu)], [yb yb], "-", "Color", GRAY, "LineWidth", 1.1);
    plot(ax, [x(idxIce) x(idxIce)], [yb-7 yb], "-", "Color", GRAY, "LineWidth", 1.1);
    plot(ax, [x(idxEu) x(idxEu)], [yb-7 yb], "-", "Color", GRAY, "LineWidth", 1.1);
    text(ax, xc, yb + 9, sprintf("Munur: %.0f þús.kr.", diffMonthly), ...
        "Color", RED, "FontWeight", "bold", "FontSize", 9.3, ...
        "HorizontalAlignment", "center", "VerticalAlignment", "bottom");
end

set(ax, "XTick", [], "TickLength", [0 0], "FontSize", 10.5);
ax.YTick = 0:50:450;
ylabel(ax, "Mánaðargreiðsla (þús.kr., verðlag 2026)", ...
    "FontSize", 10.5, "Color", [0.2 0.2 0.2]);
ax.YGrid = "on"; ax.GridColor = [0.94 0.94 0.94]; ax.GridAlpha = 1;
ax.YColor = [0.45 0.45 0.45]; ax.XColor = [0.3 0.3 0.3];
box(ax, "off");
set(ax, "Position", axPosition);

% Hópaheitin eru sett inn sem textareitir svo þau rekist ekki í ásmerkingar.
for k = 1:3
    xc = mean([x(2*k-1), x(2*k)]);
    normX = axPosition(1) + axPosition(3) * (xc - xLimits(1)) / (xLimits(2) - xLimits(1));
    annotation(f, "textbox", [normX - 0.07 0.165 0.14 0.035], ...
        "String", scenario(k), "FontSize", 9.6, "FontWeight", "bold", ...
        "Color", DARK, "EdgeColor", "none", ...
        "HorizontalAlignment", "center", "VerticalAlignment", "middle");
end

annotation(f, "textbox", [0.055 0.925 0.90 0.05], ...
    "String", "Mánaðarleg greiðslubyrði: eignamyndun og vextir", ...
    "FontSize", 13.8, "FontWeight", "bold", "Color", DARK, ...
    "EdgeColor", "none", "VerticalAlignment", "top");
annotation(f, "textbox", [0.055 0.885 0.90 0.04], ...
    "String", "Sama 60 m.kr. lán til 25 ára við mismunandi raunvaxtaforsendur", ...
    "FontSize", 10.2, "Color", GRAY, "EdgeColor", "none", "VerticalAlignment", "top");

annotation(f, "rectangle", [0.058 0.835 0.018 0.014], "FaceColor", GREEN, "EdgeColor", "none");
annotation(f, "textbox", [0.083 0.832 0.34 0.025], "String", "Niðurgreiðsla höfuðstóls / eignamyndun", ...
    "FontSize", 9.4, "Color", DARK, "EdgeColor", "none", "VerticalAlignment", "middle");
annotation(f, "rectangle", [0.455 0.835 0.018 0.014], "FaceColor", RED, "EdgeColor", "none");
annotation(f, "textbox", [0.480 0.832 0.32 0.025], "String", "Vextir til bankans", ...
    "FontSize", 9.4, "Color", DARK, "EdgeColor", "none", "VerticalAlignment", "middle");
annotation(f, "textbox", [0.055 0.045 0.90 0.04], ...
    "String", "Forsendur: varfært mat 4,5%/1,4%; miðmat 4,5%/0,8%; hærra mat 5,5%/0,8%. Skipting fyrsta mánaðar, verðlag 2026.", ...
    "FontSize", 7.8, "Color", GRAY, "EdgeColor", "none", "VerticalAlignment", "top");
end
