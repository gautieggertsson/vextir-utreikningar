%% =======================================================================
%%  run_all.m  (Útreikningar_Public)
%%
%%  Endurgerir allar töflur og myndir greinarinnar
%%  "Drög að mati á lækkun vaxtakostnaðar íslenskra heimila við upptöku evru"
%%  út frá frystu gagnaskránni data_grein.csv.
%%
%%  Allar myndir og töflur birtast sem sjálfstæðir MATLAB-gluggar.
%%  Ekkert er vistað á disk og forritið notar ekki nettengingu.
%% =======================================================================

clear;
clc;
close all;

scriptDir = fileparts(mfilename("fullpath"));
cd(scriptDir);
fprintf("Keyri útreikninga. Öll gögn koma úr data_grein.csv.\n\n");

%% 1. Raunvextir nýrra íbúðalána og töflur
fprintf("1/6 Reikna raunvexti og birti töflur...\n");
table_lanaform();
table5_real_rates_sensitivity();
fig2_krosslond_grouped();

%% 2. Dæmigert heimili: aðalmyndir og næmnigreining
if batchStartupOptionUsed; close all; end
fprintf("2/6 Reikna greiðslubyrði dæmigerðs heimilis...\n");
fig1_manadargreidsla();
fig_greidsluferill_samanburdur();
fig_household_monthly_sensitivity();

%% 3. Heildarskuldir heimila
if batchStartupOptionUsed; close all; end
fprintf("3/6 Reikna árlega raunvaxtabyrði útistandandi íbúðalána...\n");
fig_heildarskuldir_sparnadur();

%% 4. Samanburður við Finnland
if batchStartupOptionUsed; close all; end
fprintf("4/6 Teikna sögulegan vaxtamun Íslands og Finnlands...\n");
fig7_vaxtamunur_minmax_skyggt();

%% 5. Söguleg reynsla evruríkja
if batchStartupOptionUsed; close all; end
fprintf("5/6 Teikna samleitni vaxta við upptöku evru...\n");
fig8_evru_samleitni_sameinud();
fig9_evru_samleitni_vidbot();
fig10_ny_evru_riki_samleitni();
fig11_eystrasaltsriki_rikisbref();

%% 6. Lokaskilaboð
fprintf("6/6 Lokið.\n");
fprintf("Allar myndir og töflur birtast sem sjálfstæðir gluggar.\n");
