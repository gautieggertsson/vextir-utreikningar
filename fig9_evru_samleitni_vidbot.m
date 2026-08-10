function fig9_evru_samleitni_vidbot()
% =========================================================================
%  fig9_evru_samleitni_vidbot
%
%  Mynd fyrir kaflann um reynslu ríkja sem tóku upp evru. Hún sýnir hversu
%  hratt dreifing vaxta milli landa minnkaði við upptöku evru.
%
%  Öll gögn koma úr data_grein.csv: ríkisbréfagögnin úr gagnasafninu
%  "rikisbref_1992_2002" og íbúðalánagögnin (ECB RIR) úr "rir_ibudalan".
% =========================================================================
    % ---- Ríkisskuldabréf: sömu gögn og samleitnimyndin ----------------
    B = helper_gogn("rikisbref_1992_2002");
    ar   = unique(str2double(B.dags));
    DE_b = B.gildi(B.lykill == "DE");
    IT_b = B.gildi(B.lykill == "IT");
    ES_b = B.gildi(B.lykill == "ES");
    PT_b = B.gildi(B.lykill == "PT");
    IE_b = B.gildi(B.lykill == "IE");
    GR_b = B.gildi(B.lykill == "GR");
    bond = [DE_b GR_b IT_b ES_b PT_b IE_b]; %#ok<NASGU>

    % ---- Íbúðalán: ECB RIR úr data_grein.csv --------------------------
    [t_m, DE_m, IT_m, ES_m, PT_m, IE_m, GR_m] = helper_rir_tafla();
    mort = [DE_m GR_m IT_m ES_m PT_m IE_m]; %#ok<NASGU>

    % ---- Litir ---------------------------------------------------------
    dark = [0.11 0.11 0.11];
    grey = [0.45 0.45 0.45];
    cIT = [0.80 0.36 0.31];
    cES = [0.85 0.62 0.22];
    cPT = [0.27 0.45 0.62];
    cIE = [0.36 0.55 0.40];
    cGR = [0.47 0.32 0.74];

    % ===================================================================
    %  Dreifing vaxta milli landa
    % ===================================================================
    f2 = figure("Color","w","Units","inches","Position",[1 1 10.8 6.1]);
    annotation(f2, "textbox", [0.055 0.948 0.90 0.050], ...
        "String","Dreifing vaxta milli ríkja dróst hratt saman", ...
        "FontSize",15.5, "FontWeight","bold", "Color",dark, ...
        "EdgeColor","none", "VerticalAlignment","top");
    annotation(f2, "textbox", [0.055 0.912 0.90 0.035], ...
        "String","Myndin sýnir bil milli hæstu og lægstu vaxta í föstum landahópi með samfelld gögn.", ...
        "FontSize",9.6, "Color",grey, "EdgeColor","none", "VerticalAlignment","top");

    ax3 = axes(f2, "Position",[0.075 0.205 0.405 0.63]); hold(ax3,"on");
    ax4 = axes(f2, "Position",[0.565 0.205 0.405 0.63]); hold(ax4,"on");

    % Dreifingarmyndin heldur landahópnum föstum. Grikkland er sýnt í
    % samleitnimyndinni, en RIR-íbúðalánaröðin fyrir Grikkland hefst fyrst
    % við upptöku evru og myndi því breyta landahópnum í miðri mynd.
    bondDisp = [DE_b IT_b ES_b PT_b IE_b];
    mortDisp = [DE_m IT_m ES_m PT_m IE_m];
    bondRange = max(bondDisp, [], 2) - min(bondDisp, [], 2);
    mortRange = nan_bil(mortDisp);
    bondStd = std(bondDisp, 0, 2);
    mortStd = nan_stadalfraevik(mortDisp);

    setup_range_axes(ax3, [1991.5 2002.7], ar, 0:2:8, [0 8]);
    plot(ax3, [1999 1999], [0 8], "--", "Color",[0.62 0.62 0.62], "LineWidth",0.9);
    hR1 = plot(ax3, ar, bondRange, "-o", "Color",dark, "LineWidth",2.3, "MarkerSize",3.6, "MarkerFaceColor",dark);
    hS1 = plot(ax3, ar, bondStd, "--o", "Color",[0.45 0.45 0.45], "LineWidth",1.6, "MarkerSize",3.0, "MarkerFaceColor",[0.45 0.45 0.45]);
    title(ax3, "(a) 10 ára ríkisskuldabréf", "FontSize",10.5, "FontWeight","bold", "Color",dark);
    ylabel(ax3, "Dreifing milli landa (prósentustig)", "FontSize",9.5, "Color",[0.2 0.2 0.2]);
    text(ax3, 1999.08, 7.6, "evran 1999", "Color",[0.5 0.5 0.5], "FontSize",8.4, "VerticalAlignment","top");

    setup_range_axes(ax4, [1995.5 2003.8], 1996:2:2002, 0:2:8, [0 8]);
    plot(ax4, [1999 1999], [0 8], "--", "Color",[0.62 0.62 0.62], "LineWidth",0.9);
    hR2 = plot(ax4, t_m, mortRange, "-", "Color",dark, "LineWidth",2.3);
    hS2 = plot(ax4, t_m, mortStd, "--", "Color",[0.45 0.45 0.45], "LineWidth",1.6);
    title(ax4, "(b) Ný íbúðalán heimila", "FontSize",10.5, "FontWeight","bold", "Color",dark);
    text(ax4, 1999.05, 7.6, "evran 1999", "Color",[0.5 0.5 0.5], "FontSize",8.4, "VerticalAlignment","top");

    legend(ax3, [hR1 hS1], {'Bil hæsta og lægsta vaxta','Staðalfrávik'}, ...
        "Orientation","horizontal", "Box","off", "FontSize",8.5);
    lgd2 = legend(ax3);
    lgd2.Position = [0.30 0.105 0.40 0.045];

    annotation(f2, "textbox", [0.055 0.045 0.90 0.045], ...
        "String","Heimildir: Eurostat, EMU-samleitniviðmið, langtímavextir; Seðlabanki Evrópu, Retail Interest Rates (RIR), ný íbúðalán til heimila.", ...
        "FontSize",7.5, "Color",grey, "EdgeColor","none", "VerticalAlignment","top");
end

function setup_spread_axes(ax, xLimits, xTicks, yTicks, yLimits)
    ylim(ax,yLimits);
    set(ax, "YTick",yTicks, "XTick",xTicks, "FontSize",9.2, "TickLength",[0 0]);
    xlim(ax,xLimits);
    ax.YGrid = "on";
    ax.GridColor = [0.92 0.92 0.92];
    ax.GridAlpha = 1;
    ax.Layer = "bottom";
    ax.XColor = [0.30 0.30 0.30];
    ax.YColor = [0.45 0.45 0.45];
    box(ax,"off");
end

function setup_range_axes(ax, xLimits, xTicks, yTicks, yLimits)
    ylim(ax,yLimits);
    set(ax, "YTick",yTicks, "XTick",xTicks, "FontSize",9.2, "TickLength",[0 0]);
    xlim(ax,xLimits);
    ax.YGrid = "on";
    ax.GridColor = [0.92 0.92 0.92];
    ax.GridAlpha = 1;
    ax.Layer = "bottom";
    ax.XColor = [0.30 0.30 0.30];
    ax.YColor = [0.45 0.45 0.45];
    box(ax,"off");
end

function r = nan_bil(X)
% Bil hæsta og lægsta gildis í hverri línu; tóm gildi eru hunsuð.
    r = NaN(size(X,1),1);
    for i = 1:size(X,1)
        xi = X(i, ~isnan(X(i,:)));
        if ~isempty(xi)
            r(i) = max(xi) - min(xi);
        end
    end
end

function s = nan_stadalfraevik(X)
% Staðalfrávik í hverri línu, reiknað af tiltækum löndum hverju sinni.
    s = NaN(size(X,1),1);
    for i = 1:size(X,1)
        xi = X(i, ~isnan(X(i,:)));
        if numel(xi) > 1
            s(i) = std(xi, 0);
        end
    end
end
