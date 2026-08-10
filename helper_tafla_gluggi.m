function helper_tafla_gluggi(titill, undirtitill, hausar, jofnun, radir, athugasemd)
% =========================================================================
%  helper_tafla_gluggi  -  Sýnir töflu sem sjálfstæðan MATLAB-glugga.
%
%  Taflan er teiknuð í venjulegan myndglugga og birtist á skjánum þegar
%  forritið er keyrt gagnvirkt. Ekkert er vistað á disk.
%
%  INNTAK:
%     titill      = heiti töflunnar (einnig heiti gluggans)
%     undirtitill = grá skýringarlína undir titli ("" = engin)
%     hausar      = 1xk strengir; dálkhausar (mega innihalda línuskil)
%     jofnun      = 1xk strengir; "l" = vinstrijöfnun, "r" = hægrijöfnun
%     radir       = nxk strengir; efni töflunnar
%     athugasemd  = neðanmálslína ("" = engin)
% =========================================================================

    [n, k] = size(radir);
    fs = 11;                                   % leturstærð efnis

    % ---- Dálkbreiddir út frá lengsta streng í hverjum dálki ------------
    chW = 6.4;                                 % áætluð breidd stafs í px
    colW = zeros(1, k);
    for j = 1:k
        hlutar = split(hausar(j), newline);
        lengd = max([strlength(hlutar); strlength(radir(:, j))]);
        colW(j) = max(58, double(lengd) * chW + 26);
    end
    xL = [0 cumsum(colW(1:end-1))] + 20;       % vinstri brún hvers dálks
    xR = cumsum(colW) + 20;                    % hægri brún hvers dálks

    % ---- Hæðir ----------------------------------------------------------
    hausLinur = max(arrayfun(@(h) numel(split(h, newline)), hausar));
    titilH  = 30 + 18 * (strlength(undirtitill) > 0);
    hausH   = 14 * hausLinur + 12;
    rodH    = 19;
    botnH   = 26 * (strlength(athugasemd) > 0);
    W = xR(end) + 20;
    H = titilH + hausH + n * rodH + botnH + 26;

    % ---- Gluggi og ásar -------------------------------------------------
    f = figure("Name", titill, "NumberTitle", "off", "Color", "w", ...
        "Units", "pixels", "Position", [90 90 W H]);
    ax = axes(f, "Units", "pixels", "Position", [0 0 W H], ...
        "XLim", [0 W], "YLim", [0 H], "YDir", "reverse", "Visible", "off");
    hold(ax, "on");

    % ---- Titill og undirtitill -----------------------------------------
    text(ax, 20, 18, titill, "FontSize", 13, "FontWeight", "bold", ...
        "Color", [0.10 0.10 0.10], "Interpreter", "none");
    if strlength(undirtitill) > 0
        text(ax, 20, 36, undirtitill, "FontSize", 9, ...
            "Color", [0.45 0.45 0.45], "Interpreter", "none");
    end

    % ---- Hausar og línur -----------------------------------------------
    yHaus = titilH + 6;
    for j = 1:k
        if jofnun(j) == "r"
            text(ax, xR(j) - 8, yHaus, hausar(j), "FontSize", fs - 1, ...
                "FontWeight", "bold", "HorizontalAlignment", "right", ...
                "VerticalAlignment", "top", "Interpreter", "none");
        else
            text(ax, xL(j) + 8, yHaus, hausar(j), "FontSize", fs - 1, ...
                "FontWeight", "bold", "HorizontalAlignment", "left", ...
                "VerticalAlignment", "top", "Interpreter", "none");
        end
    end
    yTop  = titilH + 2;
    yMid  = titilH + hausH;
    yBot  = yMid + n * rodH + 6;
    plot(ax, [20 W-20], [yTop yTop], "-", "Color", [0.25 0.25 0.25], "LineWidth", 1.2);
    plot(ax, [20 W-20], [yMid yMid], "-", "Color", [0.25 0.25 0.25], "LineWidth", 0.8);
    plot(ax, [20 W-20], [yBot yBot], "-", "Color", [0.25 0.25 0.25], "LineWidth", 1.2);

    % ---- Efni töflunnar -------------------------------------------------
    for i = 1:n
        y = yMid + (i - 0.35) * rodH;
        for j = 1:k
            if jofnun(j) == "r"
                text(ax, xR(j) - 8, y, radir(i, j), "FontSize", fs, ...
                    "HorizontalAlignment", "right", "Interpreter", "none", ...
                    "Color", [0.15 0.15 0.15]);
            else
                text(ax, xL(j) + 8, y, radir(i, j), "FontSize", fs, ...
                    "HorizontalAlignment", "left", "Interpreter", "none", ...
                    "Color", [0.15 0.15 0.15]);
            end
        end
    end

    % ---- Athugasemd -----------------------------------------------------
    if strlength(athugasemd) > 0
        text(ax, 20, yBot + 14, athugasemd, "FontSize", 8.2, ...
            "Color", [0.45 0.45 0.45], "Interpreter", "none");
    end

end
