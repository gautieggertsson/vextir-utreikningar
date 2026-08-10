ÚTREIKNINGAR
============

GREININ
-------

PDF-útgáfa greinarinnar fylgir hér í möppunni:
Drog_ad_mati_vaxtakostnadar_2026.pdf

Bein vefslóð á greinina, sem opnast í vafra og hentar til að deila:
https://gautieggertsson.github.io/vextir-utreikningar/Drog_ad_mati_vaxtakostnadar_2026.pdf

Alla möppuna má sækja sem zip-skrá með hnappinum Code -> Download ZIP
á GitHub-síðunni: https://github.com/gautieggertsson/vextir-utreikningar

Þessi mappa geymir þau forrit og gögn sem þarf til að endurgera
útreikninga, töflur og myndir í greininni "Drög að mati á lækkun
vaxtakostnaðar íslenskra heimila við upptöku evru".

Markmiðið er að niðurstöður greinarinnar séu rekjanlegar: hér eru þau
gögn sem útreikningar, töflur og myndir byggja á og forritin sem reikna
út allar helstu niðurstöður.

Öll gögn eru í einni skrá, data_grein.csv. Þar má finna þær tölur sem
útreikningar, töflur og myndir byggja á, ásamt heimild hverrar stærðar.
Engin gögn eru geymd í forritunum sjálfum. Fremst í skránni er
skýringarhluti (gagnasafnið skilgreiningar) sem skilgreinir hverja stærð,
tilgreinir heimild og gefur vefslóð þar sem hægt er að nálgast gögnin.
Annar skýringarhluti (utskyringar) lýsir helstu útreikningum.
Gögnin eru fryst: þau eru eins og þau voru þegar greinin var
skrifuð. Vilji lesandi kanna áhrif nýrra gagna eða annarra forsendna má
breyta gildum í data_grein.csv og keyra forritin aftur; heimild hverrar
tölu segir hvar finna má uppfærð gildi.


HVERNIG Á AÐ KEYRA
------------------

1. Opnaðu MATLAB.
2. Færðu þig í þessa möppu.
3. Keyrðu:

   run_all

Allar myndir og töflur greinarinnar birtast sem sjálfstæðir
MATLAB-gluggar. Ekkert er vistað á disk og forritið notar ekki
nettengingu.


GAGNASKRÁIN data_grein.csv
--------------------------

Skráin er í löngu sniði; hver lína er ein tala eða texti. Dálkarnir eru:

   gagnasafn : hvaða hluta greinarinnar gögnin tilheyra
   rod       : heiti tímaraðar eða stærðar
   lykill    : land eða sviðsmynd, þar sem það á við
   dags      : dagsetning eða ár, þar sem það á við
   gildi     : tölugildi
   texti     : texti, t.d. flokkun eða heimild, þar sem það á við

Fremst í skránni eru tveir skýringarhlutar:

   skilgreiningar      : skýringarhluti skrárinnar. Skilgreinir hverja
                         stærð og tímaröð, með einingu, heimild og
                         vefslóð þar sem hægt er að nálgast gögnin
   utskyringar         : útskýrir hvern útreikning sem forritin gera
                         (Fisher-samband, jafngreiðsla, APRC/ÁHK,
                         hálfsársmeðaltöl o.s.frv.)

Gagnasöfnin sjálf eru:

   fastar              : stakar stærðir (höfuðstóll viðmiðunarlánsins,
                         raunvaxtaviðmið, skuldir heimila, VLF, gjöld
                         Landsbankans o.s.frv.), hver með heimild
   svidsmyndir         : raunvaxtaforsendur næmnigreiningarinnar
   lanaform            : lýsandi tafla um lánaform í evrulöndum
   tafla_raunvextir    : samanburðartafla raunvaxta milli landa
   mynd_krosslond      : gögn samanburðarmyndarinnar milli landa
   rikisbref_1992_2002 : 10 ára ríkisskuldabréfavextir 1992-2002 (Eurostat)
   rir_ibudalan        : vextir nýrra íbúðalána 1995-2003 (ECB RIR)
   island_finnland     : vaxtamunur Íslands og Finnlands yfir tíma
   ny_evru_riki        : 10 ára vextir ríkja sem gengu í ESB árið 2004
   eystrasalt          : 10 ára vextir Lettlands, Litháens og Þýskalands


SKRÁR
-----

run_all.m
   Aðalkeyrsla. Endurgerir allar töflur og myndir út frá data_grein.csv
   og birtir þær sem sjálfstæða glugga.

data_grein.csv
   Öll gögn greinarinnar í einni skrá, með heimildum.

helper_gogn.m
   Les data_grein.csv og skilar einu gagnasafni úr henni.

helper_tafla_gluggi.m
   Sýnir töflu sem sjálfstæðan MATLAB-glugga.

helper_fasti.m
   Skilar stakri stærð úr gagnasafninu "fastar".

helper_rir_tafla.m
   Skilar ECB RIR-röðunum á sameiginlegum mánaðarás.

helper_fisher.m
   Reiknar raunvexti með Fisher-sambandinu.

helper_annuity.m
   Reiknar mánaðargreiðslu jafngreiðsluláns.

table_lanaform.m
   Birtir lýsandi töflu um algeng lánaform í evrulöndum.

table5_real_rates_sensitivity.m
   Samanburðartafla raunvaxta milli landa og næmnipróf, sýnd sem gluggar. Íslensku
   APRC/ÁHK-gildin eru reiknuð hér út frá gjöldum og vöxtum Landsbankans
   í data_grein.csv.

fig1_manadargreidsla.m
   Fyrsta mánaðargreiðsla 60 m.kr. láns, skipt í vexti og eignamyndun.

fig_greidsluferill_samanburdur.m
   Greiðsluferill yfir 25 ár: íslenskir raunvextir og evru-raunvextir.

fig2_krosslond_grouped.m
   Samanburðarmynd milli landa um raunvexti nýrra íbúðalána í Evrópu.

fig_heildarskuldir_sparnadur.m
   Árleg raunvaxtabyrði útistandandi íbúðalána heimila.

fig_household_monthly_sensitivity.m
   Næmnigreining fyrir mánaðargreiðslu dæmigerðs heimilis.

fig7_vaxtamunur_minmax_skyggt.m
   Vaxtamunur Íslands og Finnlands yfir tíma.

fig8_evru_samleitni_sameinud.m
   Samleitni ríkisskuldabréfa- og íbúðalánavaxta við upptöku evru.

fig9_evru_samleitni_vidbot.m
   Dreifing vaxta milli ríkja sem tóku upp evru.

fig10_ny_evru_riki_samleitni.m
   10 ára ríkisskuldabréfavextir nýrra evruríkja og Þýskalands.

fig11_eystrasaltsriki_rikisbref.m
   10 ára ríkisskuldabréfavextir Lettlands, Litháens og Þýskalands.


ATHUGASEMDIR
------------

Í næmnitöflunni byggir APRC/ÁHK-dálkurinn á birtri ECB MIR APRC-röð fyrir
evrulönd. Íslensku línurnar eru nálgun sem byggir á birtum bankakjörum og
verðskrá Landsbankans; öll inntaksgögn eru í data_grein.csv og útreikningurinn
er í table5_real_rates_sensitivity.m. Fastur kostnaður er metinn
77.495 kr. og settur í hlutfall við 60 m.kr. lán til 25 ára. Fyrstu
kaupendur fá 100% afslátt af lántökugjaldi Landsbankans; sá afsláttur er
ekki notaður í almennu APRC/ÁHK-næmniprófi.
