function fig1_manadargreidsla()
% =========================================================================
%  fig1_manadargreidsla  -  Mynd 1: mánaðargreiðsla, króna á móti evru.
%
%  Höfundur: Gauti B. Eggertsson  (Gauti_Eggertsson@brown.edu)
%  Dagsetning: 19. júní 2026
% =========================================================================
%  Súlurit af fyrstu mánaðargreiðslu nýs 60 m.kr. láns,
%  skipt í eignamyndun og vexti. Samanburðurinn notar íslenska raunvexti
%  (4,5%) og evru-raunvexti (0,8%). Forsendurnar eru lesnar úr
%  data_grein.csv og tölurnar reiknaðar hér í þúsundum króna.
% =========================================================================
    % Forsendur úr data_grein.csv og skipting fyrstu greiðslu.
    P    = helper_fasti("lan_hofudstoll_mkr");   % m.kr.
    n    = 12 * helper_fasti("lan_ar");          % mánuðir
    rIce = helper_fasti("r_island_verdtryggt");
    rEu  = helper_fasti("r_evra_grunnmat");

    M_ice = helper_annuity(P, rIce, n);
    M_eu  = helper_annuity(P, rEu,  n);
    vextir_ice_man = P * (rIce / 100 / 12);
    vextir_eu_man  = P * (rEu  / 100 / 12);

    eign_ice = round((M_ice - vextir_ice_man) * 1000);
    vext_ice = round(vextir_ice_man * 1000);
    eign_eu  = round((M_eu - vextir_eu_man) * 1000);
    vext_eu  = round(vextir_eu_man * 1000);

    GREEN = [94 156 123]/255;   % litur eignamyndunar
    RED   = [178 58 72]/255;    % litur vaxta til bankans

    % Heildargreiðslan er summa eignamyndunar og vaxta.
    tot_ice = eign_ice + vext_ice;
    tot_eu  = eign_eu  + vext_eu;

    % Hver lína er ein súla; dálkarnir eru hlutar hennar.
    data = [eign_ice vext_ice;      % súla 1: króna
            eign_eu  vext_eu];      % súla 2: evra
    xpos = [1 2];

    f  = figure("Color","w","Units","inches","Position",[1 1 7.8 7.8]);
    ax = axes(f); hold(ax,"on");

    % Staflað súlurit: b(1) er eignamyndun og b(2) eru vextir.
    b = bar(ax, xpos, data, 0.55, "stacked");
    b(1).FaceColor=GREEN; b(1).EdgeColor="w"; b(1).LineWidth=1.0;
    b(2).FaceColor=RED;   b(2).EdgeColor="w"; b(2).LineWidth=1.0;

    % --- Merki inni í súlunum ------------------------------------------
    % Textinn er settur um miðju hvors hluta súlunnar.
    text(ax,1,eign_ice/2, sprintf("Eignamyndun\n%d þús.kr.",eign_ice), ...
         "Color","w","FontWeight","bold","FontSize",10.5, ...
         "HorizontalAlignment","center","VerticalAlignment","middle");
    text(ax,1,eign_ice+vext_ice/2, sprintf("Vextir\ntil bankans\n%d þús.kr.",vext_ice), ...
         "Color","w","FontWeight","bold","FontSize",11, ...
         "HorizontalAlignment","center","VerticalAlignment","middle");
    text(ax,2,eign_eu/2, sprintf("Eignamyndun\n%d þús.kr.",eign_eu), ...
         "Color","w","FontWeight","bold","FontSize",10.5, ...
         "HorizontalAlignment","center","VerticalAlignment","middle");
    % Evruvextirnir eru svo lágir að merkið kemst ekki vel fyrir í súlunni.
    % Þess vegna er textinn færður til hliðar.
    yv = eign_eu+vext_eu/2;
    plot(ax,[2.28 2.32],[yv yv],"-","Color",RED,"LineWidth",0.9);
    text(ax,2.34,yv, sprintf("Vextir: %d þús.kr.",vext_eu),"Color",RED, ...
         "FontWeight","bold","FontSize",10.5,"HorizontalAlignment","left", ...
         "VerticalAlignment","middle");

    % --- Heildartölur fyrir ofan súlurnar -------------------------------
    text(ax,1,tot_ice+13, sprintf("%d þús.kr.\ná mánuði",tot_ice), ...
         "Color",[0.11 0.11 0.11],"FontWeight","bold","FontSize",12.5, ...
         "HorizontalAlignment","center","VerticalAlignment","bottom");
    text(ax,2,tot_eu+13, sprintf("%d þús.kr.\ná mánuði",tot_eu), ...
         "Color",[0.11 0.11 0.11],"FontWeight","bold","FontSize",12.5, ...
         "HorizontalAlignment","center","VerticalAlignment","bottom");

    % --- Svigi sem sýnir muninn ----------------------------------------
    bx = 2.64; mismunur = tot_ice - tot_eu;
    plot(ax,[bx bx],[tot_eu tot_ice],"-","Color",[0.27 0.27 0.27],"LineWidth",1.3);
    plot(ax,[bx-0.05 bx],[tot_eu tot_eu],"-","Color",[0.27 0.27 0.27],"LineWidth",1.3);
    plot(ax,[bx-0.05 bx],[tot_ice tot_ice],"-","Color",[0.27 0.27 0.27],"LineWidth",1.3);
    text(ax,bx+0.07,(tot_eu+tot_ice)/2, ...
         sprintf("%d þús.kr.\nlægri greiðsla\nvið evrukjör",mismunur), ...
         "Color",[0.13 0.13 0.13],"FontWeight","bold","FontSize",10.5, ...
         "HorizontalAlignment","left","VerticalAlignment","middle");

    % --- Ásar, titill og skýringar -------------------------------------
    set(ax,"XTick",xpos,"XTickLabel", ...
        {'Lán í krónum (raunvextir 4,5%)','Lán í evru (raunvextir 0,8%)'}, ...
        "FontSize",11,"TickLength",[0 0]);
    xlim(ax,[0.35 3.25]); ylim(ax,[0 tot_ice*1.23]);
    ylabel(ax,"Mánaðargreiðsla (þús.kr., verðlag 2026)","FontSize",10.5,"Color",[0.2 0.2 0.2]);
    ax.YColor=[0.45 0.45 0.45]; ax.XColor=[0.3 0.3 0.3];
    ax.YGrid="on"; ax.GridColor=[0.94 0.94 0.94]; ax.GridAlpha=1; ax.Layer="bottom";
    box(ax,"off"); set(ax,"Position",[0.115 0.205 0.85 0.565]);

    bordi(f,[0.055 0.935 0.92 0.05],"Mánaðargreiðsla nýs íbúðaláns: vextir og eignamyndun",13.5,"bold",[0.11 0.11 0.11]);
    bordi(f,[0.055 0.898 0.92 0.03],"Nýtt 60 m.kr. íbúðalán, fyrsta greiðsla: krónukjör og evrukjör",9.8,"normal",[0.47 0.47 0.47]);
    annotation(f,"rectangle",[0.058 0.849 0.020 0.013],"FaceColor",GREEN,"EdgeColor","none");
    bordi(f,[0.085 0.865 0.85 0.02],"Eignamyndun með niðurgreiðslu höfuðstóls",9.5,"normal",[0.11 0.11 0.11]);
    annotation(f,"rectangle",[0.058 0.827 0.020 0.013],"FaceColor",RED,"EdgeColor","none");
    bordi(f,[0.085 0.843 0.85 0.02],"Vextir til bankans",9.5,"normal",[0.11 0.11 0.11]);
    bordi(f,[0.055 0.06 0.92 0.025],"Verðtryggt jafngreiðslulán til 25 ára. Raunvextir: Ísland 4,5%, evrusvæði 0,8%. Skipting fyrsta mánaðar, verðlag 2026.",7.6,"normal",[0.47 0.47 0.47]);

end

function bordi(f,pos,str,fs,fw,col)
% Lítið hjálparfall sem setur textareit á myndina.
    annotation(f,"textbox",pos,"String",str,"FontSize",fs,"FontWeight",fw, ...
        "Color",col,"EdgeColor","none","VerticalAlignment","top", ...
        "HorizontalAlignment","left");
end
