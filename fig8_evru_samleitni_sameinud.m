function fig8_evru_samleitni_sameinud()
% =========================================================================
%  fig8_evru_samleitni_sameinud
%
% Sýnir meginniðurstöður í tveimur hlutum.
%     (a) samleitni 10 ára ríkisskuldabréfavaxta að þýskum vöxtum
%     (b) samleitni vaxta nýrra íbúðalána að þýskum vöxtum
%
%  Öll gögn koma úr data_grein.csv: ríkisbréfagögnin úr gagnasafninu
%  "rikisbref_1992_2002" og íbúðalánagögnin (ECB RIR) úr "rir_ibudalan".
% =========================================================================
    % ---- Hluti (a): 10 ára ríkisskuldabréf úr data_grein.csv ----------
    B = helper_gogn("rikisbref_1992_2002");
    ar = unique(str2double(B.dags)).';
    bond.DE = B.gildi(B.lykill == "DE").';
    bond.IT = B.gildi(B.lykill == "IT").';
    bond.ES = B.gildi(B.lykill == "ES").';
    bond.PT = B.gildi(B.lykill == "PT").';
    bond.IE = B.gildi(B.lykill == "IE").';
    bond.GR = B.gildi(B.lykill == "GR").';

    % ---- Hluti (b): íbúðalán (ECB RIR) úr data_grein.csv --------------
    [t, DE, IT, ES, PT, IE, GR] = helper_rir_tafla();
    tDE = t; tIT = t; tES = t; tPT = t; tIE = t; tGR = t;

    % ---- Litir ---------------------------------------------------------
    dark = [0.11 0.11 0.11];
    grey = [0.45 0.45 0.45];
    cIT = [0.80 0.36 0.31];
    cES = [0.85 0.62 0.22];
    cPT = [0.27 0.45 0.62];
    cIE = [0.36 0.55 0.40];
    cGR = [0.47 0.32 0.74];

    % ---- Mynd ----------------------------------------------------------
    f = figure("Color","w","Units","inches","Position",[1 1 10.8 6.25]);

    annotation(f, "textbox", [0.055 0.948 0.90 0.050], ...
        "String","Reynsla evruríkja: vextir runnu saman að þýskum vöxtum", ...
        "FontSize",15.5, "FontWeight","bold", "Color",dark, ...
        "EdgeColor","none", "VerticalAlignment","top");
    annotation(f, "textbox", [0.055 0.912 0.90 0.035], ...
        "String","Bæði ríkisskuldabréfavextir og vextir nýrra íbúðalána lækkuðu hratt í aðdraganda og við upptöku evru.", ...
        "FontSize",9.6, "Color",grey, "EdgeColor","none", "VerticalAlignment","top");

    ax1 = axes(f, "Position",[0.075 0.225 0.405 0.62]); hold(ax1,"on");
    ax2 = axes(f, "Position",[0.565 0.225 0.405 0.62]); hold(ax2,"on");

    % Hluti (a).
    setup_axes(ax1, 25, 0:5:25);
    plot(ax1, [1999 1999], [0 25], "--", "Color",[0.62 0.62 0.62], "LineWidth",0.9);
    text(ax1, 1999.08, 24.2, "evran 1999", "Color",[0.5 0.5 0.5], ...
        "FontSize",8.4, "VerticalAlignment","top");
    hGR = plot(ax1, ar, bond.GR, "-d", "Color",cGR, "LineWidth",1.8, "MarkerSize",3.2, "MarkerFaceColor",cGR);
    hPT = plot(ax1, ar, bond.PT, "-o", "Color",cPT, "LineWidth",1.8, "MarkerSize",3.2, "MarkerFaceColor",cPT);
    hIT = plot(ax1, ar, bond.IT, "-o", "Color",cIT, "LineWidth",1.8, "MarkerSize",3.2, "MarkerFaceColor",cIT);
    hES = plot(ax1, ar, bond.ES, "-o", "Color",cES, "LineWidth",1.8, "MarkerSize",3.2, "MarkerFaceColor",cES);
    hIE = plot(ax1, ar, bond.IE, "-o", "Color",cIE, "LineWidth",1.8, "MarkerSize",3.2, "MarkerFaceColor",cIE);
    hDE = plot(ax1, ar, bond.DE, "-o", "Color",dark, "LineWidth",2.4, "MarkerSize",3.7, "MarkerFaceColor",dark);
    xlim(ax1,[1991.5 2002.7]);
    set(ax1, "XTick", ar);
    title(ax1, "(a) 10 ára ríkisskuldabréf", "FontSize",10.5, "FontWeight","bold", "Color",dark);
    ylabel(ax1, "Vextir (%)", "FontSize",10, "Color",[0.2 0.2 0.2]);
    text(ax1, 1997.7, 1.9, sprintf("Vextir renna saman\nað þýskum vöxtum"), ...
        "Color",dark, "FontSize",8.7, "HorizontalAlignment","center");

    % Hluti (b).
    setup_axes(ax2, 15, 0:5:15);
    plot(ax2, [1999 1999], [0 15], "--", "Color",[0.62 0.62 0.62], "LineWidth",0.9);
    text(ax2, 1999.05, 14.4, "evran 1999", "Color",[0.5 0.5 0.5], ...
        "FontSize",8.4, "VerticalAlignment","top");
    plot(ax2, tPT, PT, "-", "Color",cPT, "LineWidth",1.8);
    plot(ax2, tIT, IT, "-", "Color",cIT, "LineWidth",1.8);
    plot(ax2, tES, ES, "-", "Color",cES, "LineWidth",1.8);
    plot(ax2, tIE, IE, "-", "Color",cIE, "LineWidth",1.8);
    if any(~isnan(GR))
        plot(ax2, tGR, GR, "-", "Color",cGR, "LineWidth",1.8);
    end
    plot(ax2, tDE, DE, "-", "Color",dark, "LineWidth",2.4);
    xlim(ax2,[1995.5 2003.8]);
    set(ax2, "XTick", 1996:2:2002);
    title(ax2, "(b) Ný íbúðalán heimila", "FontSize",10.5, "FontWeight","bold", "Color",dark);
    text(ax2, 1997.7, 1.9, sprintf("Vextir renna saman\nað þýskum vöxtum"), ...
        "Color",dark, "FontSize",8.7, "HorizontalAlignment","center");

    legend(ax1, [hDE hGR hIT hES hPT hIE], ...
        {'Þýskaland','Grikkland','Ítalía','Spánn','Portúgal','Írland'}, ...
        "Orientation","horizontal", "Box","off", "FontSize",8.5);
    lgd = legend(ax1);
    lgd.Position = [0.145 0.105 0.73 0.045];

    sourceText = ["Heimildir: Eurostat, EMU-samleitniviðmið, langtímavextir; " + ...
        "Seðlabanki Evrópu, Retail Interest Rates (RIR), ný íbúðalán til heimila. " + ...
        "Íbúðalánagögnin enda 2003 þegar MIR-tölfræðin tók við."];
    annotation(f, "textbox", [0.055 0.045 0.90 0.045], ...
        "String",sourceText, "FontSize",7.5, "Color",grey, ...
        "EdgeColor","none", "VerticalAlignment","top");
end


function setup_axes(ax, yMax, yTicks)
    ylim(ax,[0 yMax]);
    set(ax, "YTick",yTicks, "FontSize",9.2, "TickLength",[0 0]);
    ax.YGrid = "on";
    ax.GridColor = [0.92 0.92 0.92];
    ax.GridAlpha = 1;
    ax.Layer = "bottom";
    ax.XColor = [0.30 0.30 0.30];
    ax.YColor = [0.45 0.45 0.45];
    box(ax,"off");
end
