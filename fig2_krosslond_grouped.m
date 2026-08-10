function fig2_krosslond_grouped()
% =========================================================================
%  fig2_krosslond_grouped  -  raunvextir nýrra íbúðalána í Evrópu,
%                              raðað eftir gjaldmiðlafyrirkomulagi.
%
%  Höfundur: Gauti B. Eggertsson  (Gauti_Eggertsson@brown.edu)
%  Dagsetning: 19. júní 2026
% =========================================================================
%  Löndum er ekki raðað í eina samfellda röð, heldur eftir
%  gjaldmiðlafyrirkomulagi:
%     1. Ísland (svart)
%     2. eigin gjaldmiðill, fljótandi gengi (rautt)
%     3. eigin gjaldmiðill, fasttengdur evru (Danmörk; ljósrautt)
%     4. evruríki (blátt, innan skyggðs beltis)
%     5. evrusvæðið í heild (grænt)
%  Innan flokka eru löndin röðuð eftir raunvöxtum. Gögnin koma úr
%  data_grein.csv, gagnasafninu "mynd_krosslond".
%
%  Notkun: run_all.m kallar á fallið, en einnig má keyra það sérstaklega úr
%  þessari möppu.
% =========================================================================
    % ---- 1) Lesa gögnin úr data_grein.csv -----------------------------
    M = helper_gogn("mynd_krosslond");
    land   = M.lykill(M.rod == "flokkur");
    flokk  = M.texti(M.rod == "flokkur");        % "iceland","own","own_peg","euro","euro_area"
    nafn   = M.gildi(M.rod == "nafnvextir");     % nafnvextir (%)
    vaent  = M.gildi(M.rod == "vaent_notud");    % vænt verðbólga sem dregin er frá (%)
    yfir   = M.gildi(M.rod == "raungildi_beint");% bein raungildi fyrir Ísland
    efri   = M.gildi(M.rod == "efri_mork");      % efri mörk Íslands (5,5)

    % ---- 2) Reikna raunvexti ------------------------------------------
    n = numel(land);
    raun = zeros(n,1);
    for k = 1:n
        if ~isnan(yfir(k))
            raun(k) = yfir(k);                       % Ísland: 4,50 beint
        else
            raun(k) = helper_fisher(nafn(k), vaent(k));
        end
    end

    % ---- 3) Litir eftir flokki -----------------------------------------
    C.iceland   = [ 26  26  26]/255;   % svart
    C.own       = [192  57  43]/255;   % fljótandi eigin mynt
    C.own_peg   = [200 111 100]/255;   % fasttenging við evru
    C.euro      = [ 31  78 150]/255;   % evruríki
    C.euro_area = [ 27 122  75]/255;   % evrusvæðisviðmið
    BAND        = [238 244 255]/255;   % belti utan um evruríkin

    % ---- 4) Raða eftir flokkum og innan flokka eftir vöxtum ------------
    ord = [ find(flokk=="iceland");
            sortdesc(find(flokk=="own"),      raun);
            sortdesc(find(flokk=="own_peg"),  raun);
            sortdesc(find(flokk=="euro"),     raun);
            find(flokk=="euro_area") ];

    % ---- 5) y-stöður: aukabil er sett milli flokka --------------------
    m = numel(ord);
    ypos = zeros(m,1);
    y = 0; last = "";
    for i = 1:m
        g = flokk(ord(i));
        if last~="" && g~=last;  y = y + 0.78;  end   % bil milli flokka
        ypos(i) = y;
        y = y + 1.0;
        last = g;
    end
    gflokk = flokk(ord);            % flokkur hverrar súlu í réttri röð
    ev = raun(ord(gflokk=="euro_area"));   % evrusvæðisviðmið (~0,77)

    % ---- 6) Mynd og ásar ----------------------------------------------
    f  = figure("Color","w","Units","inches","Position",[1 1 9.4 13.2]);
    ax = axes(f); hold(ax,"on");

    % Skyggt belti utan um evruríkin er teiknað fyrst svo súlurnar leggist ofan á.
    epos = ypos(gflokk=="euro");
    patch(ax,[-1.25 6.35 6.35 -1.25], ...
             [min(epos)-0.48 min(epos)-0.48 max(epos)+0.48 max(epos)+0.48], ...
             BAND, "EdgeColor","none");

    % Lóðrétt lína við núll og græn viðmiðunarlína fyrir evrusvæðið.
    plot(ax,[0 0],[-2.35 max(ypos)+0.8],"-","Color",[0.55 0.56 0.58],"LineWidth",0.9);
    plot(ax,[ev ev],[-2.35 max(ypos)+0.8],"--","Color",C.euro_area,"LineWidth",1.0);

    % ---- 7) Teikna súlurnar -------------------------------------------
    for i = 1:m
        k = ord(i);  r = raun(k);  yy = ypos(i);  g = gflokk(i);
        c = litur(g, C);
        patch(ax,[0 r r 0],[yy-0.36 yy-0.36 yy+0.36 yy+0.36], c, ...
              "EdgeColor","w","LineWidth",0.7);
        if g=="own_peg"
            % MATLAB teiknar ekki strikafyllingu sjálfkrafa; hvít skástrik
            % merkja fasttengingu dönsku krónunnar við evru.
            for xi = 0.10:0.22:r-0.04
                plot(ax,[xi min(xi+0.18,r-0.01)],[yy+0.30 yy-0.30],"-","Color","w","LineWidth",0.8);
            end
        end
        % Gildismerki við enda súlunnar, með íslenskri kommu.
        s = strrep(sprintf("%.1f", r), ".", ",");
        if g=="iceland"
            text(ax,r-0.12,yy,s,"Color","w","FontWeight","bold","FontSize",11, ...
                 "HorizontalAlignment","right","VerticalAlignment","middle");
        elseif r>=0
            text(ax,r+0.07,yy,s,"Color",[0.23 0.23 0.23],"FontSize",9.5, ...
                 "HorizontalAlignment","left","VerticalAlignment","middle");
        else
            text(ax,r-0.07,yy,s,"Color",[0.23 0.23 0.23],"FontSize",9.5, ...
                 "HorizontalAlignment","right","VerticalAlignment","middle");
        end
    end

    % ---- 8) Bil íslensku viðmiðanna (4,5 til 5,5) ----------------------
    iIce = find(gflokk=="iceland",1);  yIce = ypos(iIce);
    rIce = raun(ord(iIce));            ub   = efri(ord(iIce));
    ice  = C.iceland;
    plot(ax,[rIce ub],[yIce yIce],"-","Color",ice,"LineWidth",1.6);
    plot(ax,[rIce rIce],[yIce-0.18 yIce+0.18],"-","Color",ice,"LineWidth",1.6);
    plot(ax,[ub ub],[yIce-0.18 yIce+0.18],"-","Color",ice,"LineWidth",1.6);
    text(ax,ub+0.12,yIce,"að 5,5","Color",ice,"FontAngle","italic","FontSize",9.5, ...
         "HorizontalAlignment","left","VerticalAlignment","middle");

    % ---- 9) Svigi sem sýnir muninn gagnvart Íslandi --------------------
    yb = -1.18;
    plot(ax,[ev ub],[yb yb],"-","Color",[0.29 0.29 0.29],"LineWidth",1.2);
    plot(ax,[ev ev],[yb yb+0.20],"-","Color",[0.29 0.29 0.29],"LineWidth",1.2);
    plot(ax,[ub ub],[yb yb+0.20],"-","Color",[0.29 0.29 0.29],"LineWidth",1.2);
    text(ax,ev+0.10,yb-0.30, sprintf("Munur á Íslandi og evrusvæðinu.\nÍsland 4,5-5,5%%; evrusvæði 0,8%%."), ...
         "Color",[0.13 0.13 0.13],"FontWeight","bold","FontSize",11.5, ...
         "HorizontalAlignment","left","VerticalAlignment","bottom");

    % ---- 10) Flokksheiti vinstra megin --------------------------------
    blokk = { "iceland","ÍSLAND";
              "own",     "EIGIN MYNT";
              "own_peg", "FASTTENGD EVRU";
              "euro",    "EVRURÍKI";
              "euro_area","EVRUSVÆÐIÐ" };
    for b = 1:size(blokk,1)
        g = blokk{b,1};
        j = find(gflokk==g,1);            % fyrsta súlan í flokknum
        if isempty(j); continue; end
        text(ax,-1.20, ypos(j), blokk{b,2}, "Color",litur(g,C), ...
             "FontWeight","bold","FontSize",8.2, ...
             "HorizontalAlignment","left","VerticalAlignment","middle");
    end

    % ---- 11) Skýringartexti í evrubeltinu -----------------------------
    text(ax,3.05, min(epos)-0.10, ...
         sprintf("Evrulönd: lágt og þröngt vaxtabil.\nÓlík lánaform skýra hluta dreifingar.\nÍsland: 4,5-5,5%%."), ...
         "Color",C.euro,"FontWeight","bold","FontSize",9.7, ...
         "HorizontalAlignment","left","VerticalAlignment","top");

    % ---- 12) Ásar -----------------------------------------------------
    set(ax,"YDir","reverse");                 % Ísland efst
    set(ax,"YTick",ypos,"YTickLabel",cellstr(land(ord)),"FontSize",10);
    xlim(ax,[-1.25 6.35]); ylim(ax,[-2.35 max(ypos)+0.8]); set(ax,"XTick",0:6);
    xlabel(ax,"Raunvextir (%)","FontSize",11,"Color",[0.29 0.29 0.29]);
    ax.XGrid="on"; ax.GridColor=[0.91 0.91 0.91]; ax.GridAlpha=1; ax.Layer="bottom";
    ax.YColor=[0.47 0.47 0.47]; ax.XColor=[0.47 0.47 0.47]; ax.TickLength=[0 0];
    box(ax,"off");
    set(ax,"Position",[0.215 0.128 0.75 0.682]);

    % ---- 13) Skýring með ósýnilegum hlutum fyrir skýringarreit --------
    h1 = patch(ax,"XData",NaN,"YData",NaN,"FaceColor",C.iceland,"EdgeColor","none");
    h2 = patch(ax,"XData",NaN,"YData",NaN,"FaceColor",C.own,"EdgeColor","none");
    h3 = patch(ax,"XData",NaN,"YData",NaN,"FaceColor",C.own_peg,"EdgeColor","none");
    h4 = patch(ax,"XData",NaN,"YData",NaN,"FaceColor",C.euro,"EdgeColor","none");
    h5 = patch(ax,"XData",NaN,"YData",NaN,"FaceColor",C.euro_area,"EdgeColor","none");
    legend(ax,[h1 h2 h3 h4 h5], ...
        {'Ísland','Eigin gjaldmiðill','Fasttengdur evru','Evruríki','Evrusvæði (viðmið)'}, ...
        "Location","southeast","Box","off","FontSize",9.2);

    % ---- 14) Titill, undirtitill og heimildir -------------------------
    bordi(f,[0.055 0.905 0.92 0.055],"Raunvextir nýrra íbúðalána í Evrópu",20,"bold",[0.10 0.10 0.10]);
    bordi(f,[0.055 0.862 0.92 0.040], ...
        sprintf("Raunvextir miðað við verðbólguspá myntsvæðis. Evrulöndin liggja þétt á lágvaxtabili;\nmunur innan hópsins endurspeglar að hluta ólík lánaform. Finnland er nærtækasta samanburðarlandið að lánaformi."), ...
        9.2,"normal",[0.33 0.33 0.33]);
    bordi(f,[0.055 0.068 0.92 0.030],"Evrulöndin mynda þröngt lágvaxtabil; Ísland liggur langt fyrir ofan það bil.",9.5,"bold",[0.13 0.13 0.13]);
    bordi(f,[0.055 0.044 0.92 0.020],"Heimildir: ECB MIR (öll evrulönd, apríl 2026), Eurostat (HICP), framkvæmdastjórn ESB (vorspá 2026); lönd utan evru: EMF/innlendar heimildir; Seðlabanki Íslands.",7.4,"normal",[0.47 0.47 0.47]);
    bordi(f,[0.055 0.026 0.92 0.020],"Reiknað með Fisher-sambandinu. Ísland: bil 4,5-5,5%. Noregur: vænt verðbólga skv. Norges Bank. Rúmenía: vænt verðbólga skv. vorspá framkvæmdastjórnar ESB.",7.4,"normal",[0.47 0.47 0.47]);

end


% ======================= Hjálparföll =====================================

function idx = sortdesc(idx, raun)
% Raðar vísunum í lækkandi röð eftir raunvöxtum.
    [~, o] = sort(raun(idx), "descend");
    idx = idx(o);
end

function c = litur(g, C)
% Skilar lit fyrir gefinn flokk.
    switch char(g)
        case 'iceland';   c = C.iceland;
        case 'own';       c = C.own;
        case 'own_peg';   c = C.own_peg;
        case 'euro';      c = C.euro;
        case 'euro_area'; c = C.euro_area;
        otherwise;        c = [0.4 0.4 0.4];
    end
end

function bordi(f, pos, str, fs, fw, col)
% Setur textareit á myndina í hlutfallslegum hnitum.
    annotation(f,"textbox",pos,"String",str,"FontSize",fs,"FontWeight",fw, ...
        "Color",col,"EdgeColor","none","VerticalAlignment","top","HorizontalAlignment","left");
end
