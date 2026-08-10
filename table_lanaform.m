function table_lanaform()
% =========================================================================
%  table_lanaform
%
%  Birtir töflu um algeng lánaform í evrulöndum. Taflan er lýsandi
%  heimildatafla, ekki tölulegur útreikningur, en er búin til hér svo
%  run_all.m endurgeri allar töflur sem birtast í greininni.
% =========================================================================
% Gögnin koma úr data_grein.csv, gagnasafninu "lanaform".
L = helper_gogn("lanaform");
land        = L.lykill(L.rod == "lanstimi");
lanstimi    = L.texti(L.rod == "lanstimi");
festutimi   = L.texti(L.rod == "festutimi");
uppgreidsla = L.texti(L.rod == "uppgreidsla");

T = table(land, lanstimi, festutimi, uppgreidsla, ...
    'VariableNames', {'land','lanstimi','festutimi_endurverdlagning','uppgreidsla'});

% Sýna töfluna sem sjálfstæðan MATLAB-glugga.
radirL = [land, lanstimi, festutimi, uppgreidsla];
helper_tafla_gluggi("Lánaform nýrra íbúðalána í evrulöndum", ...
    "Ný íbúðalán eru ekki sami lánasamningur í öllum löndum; þess vegna er samsett vísitala ECB notuð.", ...
    ["Land", "Lánstími", "Festutími / endurverðl.", "Uppgreiðsla"], ...
    ["l" "l" "l" "l"], radirL, ...
    "Heimildir: Lea (2010); Allianz/Dresdner Bank (2008); Green & Wachter (2005); innlend löggjöf; ECB MIR.");
end
