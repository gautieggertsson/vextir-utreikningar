function fig10_ny_evru_riki_samleitni()
% =========================================================================
%  fig10_ny_evru_riki_samleitni
%
%  Teiknar 10 ára ríkisskuldabréfavexti nýrra evruríkja og Þýskalands.
%  Myndin sýnir vaxtastig í prósentum, ekki vaxtamun, til samræmis við
%  samleitnimyndina í meginniðurstöðum.
%
%  Gögnin eru hálfsársmeðaltöl mánaðarlegra Eurostat-gagna:
%  EMU convergence criterion series, irt_lt_mcby_m.
%
%  10 ára vextir eru notaðir vegna þess að þeir eru hið opinbera
%  Maastricht/EMU-samleitniviðmið fyrir langtímavexti. Þeir eru því
%  samræmdur markaðsmælikvarði á aðlögun að evru.
%
%  Kýpur er ekki tekin með vegna þess að Eurostat-röðin fyrir Kýpur byggir á
%  ávöxtun við frumútgáfu skuldabréfa. Hún er því minna sambærileg og sýnir
%  miklar skammtímasveiflur.
% =========================================================================
    % Gögnin koma úr data_grein.csv, gagnasafninu "ny_evru_riki".
    N = helper_gogn("ny_evru_riki");
    T = table();
    T.year_decimal = str2double(N.dags(N.lykill == "Germany"));
    T.Germany  = N.gildi(N.lykill == "Germany");
    T.Slovenia = N.gildi(N.lykill == "Slovenia");
    T.Malta    = N.gildi(N.lykill == "Malta");
    T.Slovakia = N.gildi(N.lykill == "Slovakia");
    x = T.year_decimal;

    black  = [26 26 26] / 255;
    blue   = [43 108 176] / 255;
    green  = [47 133 90] / 255;
    purple = [128 90 213] / 255;
    grey   = [102 102 102] / 255;

    eu_accession  = decimal_year(2004, 5, 1);
    erm_start     = decimal_year(2004, 6, 28);
    slovenia_euro = decimal_year(2007, 1, 1);

    f = figure("Color","w","Units","inches","Position",[1 1 10.8 6.1]);
    ax = axes(f, "Position",[0.09 0.20 0.73 0.60]); hold(ax,"on");

    xMin = 2002.05;
    xMax = 2007.45;
    xlim(ax, [xMin xMax]);
    ylim(ax, [2.8 10.0]);

    patch(ax, [erm_start xMax xMax erm_start], [2.8 2.8 10.0 10.0], ...
        [0.85 0.85 0.85], "FaceAlpha",0.26, "EdgeColor","none");
    text(ax, 2005.38, 9.55, "ERM II", "FontSize",9.4, ...
        "Color",[0.34 0.34 0.34], "VerticalAlignment","top", ...
        "HorizontalAlignment","center");

    xline(ax, eu_accession, "--", "Color",[0.34 0.34 0.34], "LineWidth",1.1);
    text(ax, eu_accession + 0.035, 9.55, sprintf("ESB-aðild\n1. maí 2004"), ...
        "FontSize",8.3, "Color",[0.29 0.29 0.29], "VerticalAlignment","top");

    xline(ax, slovenia_euro, "--", "Color",blue, "LineWidth",1.25);
    text(ax, slovenia_euro - 0.090, 9.55, sprintf("Slóvenía\ntekur upp evru\n2007"), ...
        "FontSize",8.0, "Color",blue, "VerticalAlignment","top", ...
        "HorizontalAlignment","right");

    h0 = plot(ax, x, T.Germany, "-o", "Color",black, "LineWidth",2.8, ...
        "MarkerSize",4.8, "MarkerFaceColor",black);
    h1 = plot(ax, x, T.Slovenia, "-o", "Color",blue, "LineWidth",2.3, ...
        "MarkerSize",4.5, "MarkerFaceColor",blue);
    h2 = plot(ax, x, T.Malta, "-o", "Color",green, "LineWidth",2.3, ...
        "MarkerSize",4.5, "MarkerFaceColor",green);
    h3 = plot(ax, x, T.Slovakia, "-o", "Color",purple, "LineWidth",2.3, ...
        "MarkerSize",4.5, "MarkerFaceColor",purple);

    ax.YGrid = "on";
    ax.GridColor = [0.91 0.91 0.91];
    ax.GridAlpha = 1;
    ax.Layer = "top";
    set(ax, "YTick",3:1:10, "XTick",2002:2007, ...
        "FontSize",9.5, "TickLength",[0 0]);
    ax.XColor = [0.36 0.36 0.36];
    ax.YColor = [0.36 0.36 0.36];
    box(ax,"off");
    ylabel(ax, "10 ára ríkisskuldabréfavextir (%)", ...
        "FontSize",10, "Color",[0.2 0.2 0.2]);

    title(ax, "10 ára ríkisskuldabréfavextir nýrra evruríkja og Þýskalands", ...
        "FontSize",15.0, "FontWeight","bold", "Color",black, ...
        "HorizontalAlignment","left");
    ax.Title.Units = "normalized";
    ax.Title.Position(1) = 0;
    ax.Title.Position(2) = 1.08;
    text(ax, 0, 1.025, ...
        "Hálfsársmeðaltöl mánaðarlegra EMU-samleitniviðmiða. Gögnin enda í júní 2007.", ...
        "Units","normalized", "FontSize",9.15, "Color",grey);

    legend(ax, [h0 h1 h2 h3], {'Þýskaland','Slóvenía','Malta','Slóvakía'}, ...
        "Orientation","horizontal", "Box","off", "FontSize",9.2, ...
        "Location","southoutside");

    annotation(f, "textbox", [0.845 0.63 0.13 0.12], ...
        "String", sprintf("Evruupptaka síðar\n\nMalta 2008\nSlóvakía 2009  →"), ...
        "FontSize",8.9, "Color",[0.30 0.30 0.30], "EdgeColor","none", ...
        "VerticalAlignment","top", "Interpreter","none");

    annotation(f, "textbox", [0.075 0.035 0.88 0.035], ...
        "String","Heimild: Eurostat, EMU convergence criterion series (irt_lt_mcby_m). Kýpur er sleppt vegna þess að röðin byggir á ávöxtun við frumútgáfu skuldabréfa og er því minna sambærileg.", ...
        "FontSize",7.6, "Color",grey, "EdgeColor","none", ...
        "VerticalAlignment","top", "Interpreter","none");
end

function y = decimal_year(ar, manudur, dagur)
    d = datetime(ar, manudur, dagur);
    y = ar + (day(d, "dayofyear") - 1) / days(datetime(ar,12,31) - datetime(ar,1,1) + 1);
end
