function fig11_eystrasaltsriki_rikisbref()
% =========================================================================
%  fig11_eystrasaltsriki_rikisbref
%
%  Teiknar 10 ára ríkisskuldabréfavexti Lettlands, Litháens og Þýskalands.
%  Gögnin eru hálfsársmeðaltöl mánaðarlegra Eurostat-gagna:
%  EMU convergence criterion series, irt_lt_mcby_m.
%
%  Eistland er ekki með í myndinni vegna þess að 10 ára Eurostat-röðin
%  byrjar fyrst 2020. Myndin sýnir að fast gengi kom ekki að fullu í
%  stað evru: Lettland og Litháen héldu genginu stöðugu í fjármálakreppunni,
%  en 10 ára vextir hækkuðu samt mikið og lækkuðu síðar aftur að evrukjörum.
% =========================================================================
    % Gögnin koma úr data_grein.csv, gagnasafninu "eystrasalt".
    E = helper_gogn("eystrasalt");
    T = table();
    T.x  = str2double(E.dags(E.lykill == "DE"));
    T.DE = E.gildi(E.lykill == "DE");
    T.LT = E.gildi(E.lykill == "LT");
    T.LV = E.gildi(E.lykill == "LV");
    x = T.x;

    black = [26 26 26] / 255;
    red   = [159 29 53] / 255;
    green = [47 133 90] / 255;
    grey  = [102 102 102] / 255;

    eu_accession = decimal_year(2004, 5, 1);
    erm_start    = decimal_year(2004, 6, 28);
    latvia_euro  = 2014;
    lith_euro    = 2015;

    f = figure("Color","w","Units","inches","Position",[1 1 10.8 6.1]);
    ax = axes(f, "Position",[0.09 0.19 0.86 0.62]); hold(ax,"on");

    xMin = 2000.8; xMax = 2016.3;
    yMin = 0;      yMax = 15.2;
    xlim(ax, [xMin xMax]); ylim(ax, [yMin yMax]);

    patch(ax, [erm_start lith_euro lith_euro erm_start], [yMin yMin yMax yMax], ...
        [0.85 0.85 0.85], "FaceAlpha",0.22, "EdgeColor","none");
    text(ax, 2009.75, 14.25, "ERM II", ...
        "FontSize",8.7, "Color",[0.34 0.34 0.34], ...
        "HorizontalAlignment","center", "VerticalAlignment","top", ...
        "Interpreter","none");

    xline(ax, eu_accession, "--", "Color",[0.45 0.45 0.45], "LineWidth",1.0);
    text(ax, eu_accession + 0.08, 14.2, "ESB 2004", ...
        "FontSize",8.0, "Color",[0.34 0.34 0.34], ...
        "VerticalAlignment","top", "Interpreter","none");

    xline(ax, latvia_euro, "--", "Color",red, "LineWidth",1.15);
    text(ax, latvia_euro - 0.08, 14.2, "LV 2014", ...
        "FontSize",8.0, "Color",red, "HorizontalAlignment","right", ...
        "VerticalAlignment","top", "Interpreter","none");

    xline(ax, lith_euro, "--", "Color",green, "LineWidth",1.15);
    text(ax, lith_euro + 0.08, 14.2, "LT 2015", ...
        "FontSize",8.0, "Color",green, "HorizontalAlignment","left", ...
        "VerticalAlignment","top", "Interpreter","none");

    hDE = plot(ax, x, T.DE, "-o", "Color",black, "LineWidth",2.7, ...
        "MarkerSize",4.0, "MarkerFaceColor",black);
    hLV = plot(ax, x, T.LV, "-o", "Color",red, "LineWidth",2.5, ...
        "MarkerSize",4.0, "MarkerFaceColor",red);
    hLT = plot(ax, x, T.LT, "-o", "Color",green, "LineWidth",2.5, ...
        "MarkerSize",4.0, "MarkerFaceColor",green);

    ax.YGrid = "on";
    ax.GridColor = [0.91 0.91 0.91];
    ax.GridAlpha = 1;
    ax.Layer = "top";
    set(ax, "YTick",0:2:14, "XTick",2002:2:2016, ...
        "FontSize",9.5, "TickLength",[0 0]);
    ax.XColor = [0.36 0.36 0.36];
    ax.YColor = [0.36 0.36 0.36];
    box(ax,"off");
    ylabel(ax, "10 ára ríkisskuldabréfavextir (%)", ...
        "FontSize",10.3, "Color",[0.2 0.2 0.2]);

    annotation(f, "textbox", [0.055 0.920 0.92 0.050], ...
        "String","10 ára ríkisskuldabréfavextir í Lettlandi, Litháen og Þýskalandi", ...
        "FontSize",15.5, "FontWeight","bold", "Color",black, ...
        "EdgeColor","none", "VerticalAlignment","top", "Interpreter","none");
    annotation(f, "textbox", [0.055 0.882 0.92 0.030], ...
        "String","Hálfsársmeðaltöl. Tímabilið sýnir samleitni fyrir kreppu, vaxtahækkunina í kreppunni og síðari aðlögun að evru.", ...
        "FontSize",9.0, "Color",grey, "EdgeColor","none", ...
        "VerticalAlignment","top", "Interpreter","none");

    legend(ax, [hDE hLV hLT], {'Þýskaland','Lettland','Litháen'}, ...
        "Orientation","horizontal", "Box","off", "FontSize",9.4, ...
        "Location","southoutside", "Interpreter","none");

    annotation(f, "textbox", [0.055 0.040 0.92 0.030], ...
        "String","Heimild: Eurostat, EMU convergence criterion series (irt_lt_mcby_m). Eistland kemur fyrst inn í 10 ára röðina árið 2020.", ...
        "FontSize",7.6, "Color",grey, "EdgeColor","none", ...
        "VerticalAlignment","top", "Interpreter","none");
end

function y = decimal_year(ar, manudur, dagur)
    d = datetime(ar, manudur, dagur);
    y = ar + (day(d, "dayofyear") - 1) / days(datetime(ar,12,31) - datetime(ar,1,1) + 1);
end
