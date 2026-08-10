function table5_real_rates_sensitivity()
% =========================================================================
%  table5_real_rates_sensitivity
%
%  Býr til tvær gagnatöflur um raunvexti nýrra íbúðalána. Töflurnar eru ekki
%  myndræn framsetning heldur rekjanlegt yfirlit yfir mælikvarðana:
%    - íbúðarlánsvextir nýrra lána,
%    - nýjustu HICP-verðbólgu hvers lands til að setja spárnar í samhengi,
%    - landsbundna verðbólguspá og raunvexti miðað við hana,
%    - grunnmat með væntri verðbólgu viðkomandi myntsvæðis,
%    - mat miðað við verðbólgumarkmið,
%    - APRC/ÁHK-viðmið. Fyrir evrulönd er þetta birt APRC-röð ECB. Fyrir
%      Ísland er notuð nálgun sem byggir á föstum gjöldum Landsbankans.
%
%  Birtir:
%    - grunnmælingu raunvaxta,
%    - næmnipróf fyrir raunvaxtamatið.
%
%  Ekkert er vistað á disk. Töflurnar birtast sem MATLAB-gluggar þegar
%  run_all.m er keyrt.
% =========================================================================
% Öll gögn koma úr data_grein.csv: samanburðartaflan milli landa úr gagnasafninu
% "tafla_raunvextir" og stakar stærðir úr "fastar". Heimildir eru skráðar í
% data_grein.csv og í greininni.
ISL_HICP = helper_fasti("isl_hicp");

T5 = helper_gogn("tafla_raunvextir");
land            = T5.lykill(T5.rod == "ibudalanavextir");
ibudalanavextir = T5.gildi(T5.rod == "ibudalanavextir");
hicpLand        = T5.gildi(T5.rod == "hicp");
vaentLand       = T5.gildi(T5.rod == "vaent_land");
vaentGrunn      = T5.gildi(T5.rod == "vaent_grunn");
target          = T5.gildi(T5.rod == "markmid");
aprcVextir      = T5.gildi(T5.rod == "aprc");

erVerdtryggtIsland = land == "Ísland -- verðtryggt";
erOvtrIsland       = land == "Ísland -- óverðtryggt breytilegt";
erVidmid           = land == "Evrusvæði (viðmið)";

% Íslensku APRC/ÁHK-gildin eru reiknuð hér út frá föstum kostnaði
% Landsbankans; öll inntaksgögn koma úr "fastar" í data_grein.csv. Fastur
% kostnaður er settur í hlutfall við sama 60 m.kr. lán til 25 ára og notað
% er í heimilisdæminu. Fyrstu kaupendur fá 100% afslátt af lántökugjaldi
% Landsbankans; sá afsláttur er ekki notaður hér því taflan er almennt
% næmnipróf. Verðtryggða línan fylgir íslenskri framkvæmd á ÁHK: verðbætur
% eru reiknaðar miðað við nýjustu mældu verðbólgu.
islAprcLoan  = helper_fasti("lan_hofudstoll_mkr") * 1e6;
islAprcYears = helper_fasti("lan_ar");
islFixedFees = helper_fasti("gjald_lantoku") + helper_fasti("gjald_greidslumat") ...
    + helper_fasti("gjald_vedbokarvottord") + helper_fasti("gjald_rafraen_thinglysing") ...
    + helper_fasti("gjald_umsysla_thinglysing");
islIndexedNominalProxy = 100*((1 + helper_fasti("r_island_verdtryggt")/100)*(1 + ISL_HICP/100) - 1);
islUnindexedNominalProxy = helper_fasti("landsbanki_overdtryggt_breytilegt");
aprcVextir(erOvtrIsland) = helper_aprc_with_fixed_fee(islAprcLoan, ...
    islUnindexedNominalProxy, islAprcYears, islFixedFees);
aprcVextir(erVerdtryggtIsland) = helper_aprc_with_fixed_fee(islAprcLoan, ...
    islIndexedNominalProxy, islAprcYears, islFixedFees);

% Reikna raunvexti. Verðtryggða íslenska röðin er þegar raunvaxtaröð og er
% því ekki leiðrétt fyrir verðbólgu í fyrstu dálkunum.
rLand       = helper_fisher(ibudalanavextir, vaentLand);
rGrunn      = helper_fisher(ibudalanavextir, vaentGrunn);
rTarget     = helper_fisher(ibudalanavextir, target);
rLand(erVerdtryggtIsland)       = ibudalanavextir(erVerdtryggtIsland);
rGrunn(erVerdtryggtIsland)      = ibudalanavextir(erVerdtryggtIsland);
rTarget(erVerdtryggtIsland)     = ibudalanavextir(erVerdtryggtIsland);

% ÁHK/APRC er leiðrétt með sama verðbólguviðmiði og grunnmatið. Verðtryggða
% íslenska línan er færð í raunvexti með væntri verðbólgu á Íslandi, þ.e.
% sömu tölu og notuð er fyrir óverðtryggðu línuna.
rAprc = helper_fisher(aprcVextir, vaentGrunn);
rAprc(erVerdtryggtIsland) = helper_fisher(aprcVextir(erVerdtryggtIsland), ...
    vaentGrunn(erOvtrIsland));

% Raða eftir grunnmati, en setja evrusvæðisviðmiðið sérstaklega neðst.
idxMain = find(~erVidmid);
[~, o] = sort(rGrunn(idxMain), "descend");
ord = [idxMain(o); find(erVidmid)];

% Setja saman rekjanlega töflu með öllum reiknuðum dálkum.
T = table(land(ord), ibudalanavextir(ord), hicpLand(ord), vaentLand(ord), ...
    rLand(ord), vaentGrunn(ord), rGrunn(ord), target(ord), rTarget(ord), ...
    aprcVextir(ord), rAprc(ord), ...
    'VariableNames', {'land','ibudalanavextir','hicp_land','vaent_land', ...
    'raunvextir_landsspa','vaent_grunn','raunvextir_grunnmat', ...
    'verdbolgumarkmid','raunvextir_markmid','aprc_vextir', ...
    'raunvextir_aprc'});

% Sýna töflurnar sem sjálfstæða MATLAB-glugga.
o = ord;
n1 = numel(o);
radir1 = strings(n1, 7);
for k = 1:n1
    radir1(k,:) = [land(o(k)), fmt(ibudalanavextir(o(k))), fmt(hicpLand(o(k))), ...
        fmt(vaentLand(o(k))), fmt(rLand(o(k))), fmt(vaentGrunn(o(k))), fmt(rGrunn(o(k)))];
end
hausar1 = ["Land", sprintf("Íbúðarlánsv.\n(%%)"), sprintf("HICP\n(apríl 2026)"), ...
    sprintf("Vænt verðb.\n(landspá)"), sprintf("Raunvextir\n(landspá)"), ...
    sprintf("Vænt verðb.\n(myntsv.spá)"), sprintf("Raunvextir\n(myntsv.spá)")];
helper_tafla_gluggi("Grunnmæling raunvaxta nýrra íbúðalána", ...
    "Raðað eftir raunvöxtum miðað við vænta verðbólgu myntsvæðis; evrusvæðið neðst sem viðmið.", ...
    hausar1, ["l" repmat("r", 1, 6)], radir1, ...
    "Reiknað með Fisher-sambandinu án línulegrar nálgunar. Gögn: data_grein.csv.");

radir2 = strings(n1, 4);
for k = 1:n1
    radir2(k,:) = [land(o(k)), fmt(rGrunn(o(k))), fmt(rTarget(o(k))), fmt(rAprc(o(k)))];
end
hausar2 = ["Land", sprintf("Grunnmat\n(myntsv.spá)"), ...
    sprintf("Verðb.markmið\n(myntsv.)"), sprintf("ÁHK/APRC\n(viðmið)")];
helper_tafla_gluggi("Næmnipróf fyrir raunvaxtamatið", "", ...
    hausar2, ["l" "r" "r" "r"], radir2, ...
    "Reiknað með Fisher-sambandinu án línulegrar nálgunar. Gögn: data_grein.csv.");
end

function s = fmt(x)
if isnan(x)
    s = "--";
else
    s = strrep(sprintf("%.2f", x), ".", ",");
end
end

function aprc = helper_aprc_with_fixed_fee(loanAmount, annualRatePct, termYears, fixedFee)
% Reiknar árlega hlutfallstölu kostnaðar þegar lántaki fær lánsfjárhæðina en
% greiðir fastan kostnað við stofnun lánsins. Greiðsluflæðið fylgir sama
% mánaðarlega jafngreiðsluferil og grunnlánsvextirnir.
n = termYears * 12;
monthlyRate = (1 + annualRatePct/100)^(1/12) - 1;
payment = loanAmount * monthlyRate / (1 - (1 + monthlyRate)^(-n));
netDrawdown = loanAmount - fixedFee;

lo = 0;
hi = 0.50;
for iter = 1:200
    mid = (lo + hi) / 2;
    monthlyAprc = (1 + mid)^(1/12) - 1;
    pv = payment * (1 - (1 + monthlyAprc)^(-n)) / monthlyAprc;
    if pv > netDrawdown
        lo = mid;
    else
        hi = mid;
    end
end
aprc = 100 * (lo + hi) / 2;
end
