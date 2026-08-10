function fig7_vaxtamunur_minmax_skyggt()
% =========================================================================
%  fig7_vaxtamunur_minmax_skyggt
%
%  Býr til mynd af tímaröð sem sýnir vaxtamun milli Íslands og Finnlands:
%     - nafnvaxtamun stýrivaxta: Seðlabanki Íslands að frádregnum ECB
%     - raunvaxtamun íbúðalána: Ísland að frádregnu Finnlandi.
%       Finnskir nafnvextir eru leiðréttir fyrir HICP-væntingum úr
%       EC/AMECO-spám þegar þær eru til; fyrir eldra tímabil er notuð
%       skammtímavæntingaröð ECB SPF sem nálgun. Allt er reiknað
%       með Fisher-sambandinu.
%
%  Skyggðu svæðin sýna lægsta og hæsta gildi hvorrar tímaraðar á
%  sameiginlegu tímabili raðanna. Brotalínur sýna meðaltal hverrar raðar.
%
%  Fallið má keyra úr þessari möppu eða kalla á það frá run_all.m.
% =========================================================================

    % ---- 1) Slóðir og gögn --------------------------------------------
    % Gögnin koma úr data_grein.csv, gagnasafninu "island_finnland".
    T = helper_gogn("island_finnland");
    iPol  = T.rod == "policy_nominal_spread";
    iMort = T.rod == "mortgage_real_spread_baseline";

    d        = datetime(T.dags(iPol), "InputFormat","yyyy-MM-dd");
    policy   = T.gildi(iPol);
    mortgage = T.gildi(iMort);

    keep = ~isnan(policy) & ~isnan(mortgage);
    d = d(keep);
    policy = policy(keep);
    mortgage = mortgage(keep);

    markerDate = d(end);
    markerValue = mortgage(end);

    % ---- 2) Stærðir ----------------------------------------------------
    pMin = min(policy);   pMax = max(policy);   pRange = pMax - pMin;
    mMin = min(mortgage); mMax = max(mortgage); mRange = mMax - mMin;
    rangeFraction = mRange / pRange;

    pMean = mean(policy, "omitnan");
    mMean = mean(mortgage, "omitnan");

    x = datenum(d);
    xMarker = datenum(markerDate);
    xLeft = datenum(d(1));
    xRight = datenum(d(end) + calmonths(6));

    % ---- 3) Litir ------------------------------------------------------
    blue = [48 101 164] / 255;
    red  = [182 74 69] / 255;
    dark = [34 34 34] / 255;
    grey = [102 102 102] / 255;
    lightGrey = [231 231 231] / 255;

    % ---- 4) Mynd -------------------------------------------------------
    f = figure("Color","w","Units","inches","Position",[1 1 9.8 6.25]);
    ax = axes(f); hold(ax, "on");

    % Skyggð bil frá lægsta til hæsta gildis.
    patch(ax, [xLeft xRight xRight xLeft], [pMin pMin pMax pMax], blue, ...
        "FaceAlpha",0.075, "EdgeColor","none");
    patch(ax, [xLeft xRight xRight xLeft], [mMin mMin mMax mMax], red, ...
        "FaceAlpha",0.12, "EdgeColor","none");

    % Jaðrar skyggðra bila.
    plot(ax, [xLeft xRight], [pMin pMin], "-", "Color",[blue 0.38], "LineWidth",1.0);
    plot(ax, [xLeft xRight], [pMax pMax], "-", "Color",[blue 0.38], "LineWidth",1.0);
    plot(ax, [xLeft xRight], [mMin mMin], "-", "Color",[red 0.45], "LineWidth",1.0);
    plot(ax, [xLeft xRight], [mMax mMax], "-", "Color",[red 0.45], "LineWidth",1.0);

    % Tímaraðir.
    hPolicy = plot(ax, x, policy, "-", "Color",blue, "LineWidth",2.0);
    hMortgage = plot(ax, x, mortgage, "-", "Color",red, "LineWidth",2.6);

    % Meðaltöl.
    plot(ax, [xLeft xRight], [pMean pMean], "--", "Color",[blue 0.65], "LineWidth",1.1);
    plot(ax, [xLeft xRight], [mMean mMean], "--", "Color",[red 0.75], "LineWidth",1.1);

    % Nýjasti punkturinn.
    scatter(ax, xMarker, markerValue, 62, red, "filled", ...
        "MarkerEdgeColor","w", "LineWidth",1.0);
    text(ax, xMarker - 805, markerValue + 2.35, ...
        "Apríl 2026", ...
        "Color",red, "FontSize",9.0, "HorizontalAlignment","left", ...
        "VerticalAlignment","bottom");
    plot(ax, [xMarker - 420 xMarker - 60], [markerValue + 1.8 markerValue + 0.25], ...
        "-", "Color",red, "LineWidth",0.8);

    % ---- 5) Útlit ------------------------------------------------------
    ylabel(ax, "Prósentustig", "Color",[0.2 0.2 0.2], "FontSize",11);
    ylim(ax, [-1 18]);
    xlim(ax, [xLeft xRight]);
    set(ax, "YTick",0:2:18);
    years = 2005:3:2026;
    set(ax, "XTick", datenum(datetime(years,1,1)), "XTickLabel", string(years));
    ax.YGrid = "on";
    ax.GridColor = lightGrey;
    ax.GridAlpha = 1;
    ax.Layer = "top";
    ax.TickLength = [0 0];
    ax.XColor = [0.28 0.28 0.28];
    ax.YColor = [0.28 0.28 0.28];
    box(ax, "off");
    set(ax, "Position",[0.105 0.185 0.86 0.64]);

    % Legend með brotalínum undir hvorri röð.
    meanBlue = plot(ax, NaN, NaN, "--", "Color",[blue 0.75], "LineWidth",1.1);
    meanRed  = plot(ax, NaN, NaN, "--", "Color",[red 0.80], "LineWidth",1.1);
    legend(ax, [hPolicy meanBlue hMortgage meanRed], ...
        {"Nafnvaxtamunur stýrivaxta: SÍ að frádregnum ECB", ...
         "Brotalína: sögulegt meðaltal nafnvaxtamunar", ...
         "Raunvaxtamunur íbúðalána: Ísland - Finnland", ...
         "Brotalína: sögulegt meðaltal raunvaxtamunar"}, ...
         "Location","northeast", "Box","off", "FontSize",8.7);
    lgd = legend(ax);
    lgd.Position(2) = lgd.Position(2) - 0.045;

    % Titill, undirtitill og heimildir.
    annotation(f, "textbox", [0.055 0.935 0.90 0.060], ...
        "String","Vaxtamunur milli Íslands og Finnlands", ...
        "FontSize",16, "FontWeight","bold", "Color",dark, ...
        "EdgeColor","none", "VerticalAlignment","top");
    annotation(f, "textbox", [0.055 0.895 0.90 0.040], ...
        "String","Nýjustu gögnin liggja innan sögulegs bils; raunvaxtamunurinn er mun stöðugri en nafnvaxtamunurinn.", ...
        "FontSize",10.1, "Color",grey, "EdgeColor","none", "VerticalAlignment","top");
    sourceText = sprintf([ ...
        'Heimildir: Seðlabanki Íslands (stýrivextir og verðtryggðir bankavextir íbúðalána), ECB policy rates og ECB MIR.\n' ...
        'Skyggt bil er hæsta og lægsta gildi á sameiginlegu tímabili raðanna, 2004--2026.\n' ...
        'Rauða röðin notar HICP-væntingar úr EC/AMECO frá 2011; fyrir eldra tímabil er notuð skammtímavæntingaröð ECB SPF sem nálgun. Raunvextir eru reiknaðir með Fisher-sambandinu.']);
    annotation(f, "textbox", [0.055 0.055 0.90 0.075], ...
        "String",sourceText, ...
        "FontSize",7.25, "Color",grey, "EdgeColor","none", "VerticalAlignment","top");

    fprintf("  Blátt bil: %.2f til %.2f, breidd %.2f pr.st.\n", pMin, pMax, pRange);
    fprintf("  Rautt bil: %.2f til %.2f, breidd %.2f pr.st. (%.0f%% af bláa bilinu)\n", ...
        mMin, mMax, mRange, 100 * rangeFraction);
end


function x = asdouble(v)
% Breytir töflugildi í double, hvort sem MATLAB las dálkinn sem tölu eða texta.
    if isnumeric(v)
        x = double(v);
    else
        x = str2double(string(v));
    end
end

function s = fmt(x)
% Tveir aukastafir með íslenskri kommu.
    s = strrep(sprintf("%.2f", x), ".", ",");
end
