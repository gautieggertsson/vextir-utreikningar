function manadargreidsla = helper_annuity(P, r_arsprosent, n_manudir)
% =========================================================================
%  helper_annuity  -  Reiknar fasta mánaðargreiðslu af jafngreiðsluláni.
%
%  Höfundur: Gauti B. Eggertsson  (Gauti_Eggertsson@brown.edu)
%  Dagsetning: 19. júní 2026
% =========================================================================
%
%  Hvað gerir fallið?
%  -----------------------
%  Jafngreiðslulán er lán þar sem greiðslan er sú sama í hverjum mánuði allan
%  lánstímann. Hér er greiðslan reiknuð í raunvirði, því fallið fær
%  raunvexti sem inntak.
%
%  Mánaðargreiðslan er:
%
%                        i
%        M = P * -----------------
%                 1 - (1 + i)^(-n)
%
%  þar sem
%        P = höfuðstóll lánsins
%        i = mánaðarvextir sem hlutfall
%        n = fjöldi mánaða
%
%  INNTAK:
%     P             = höfuðstóll, t.d. 60 fyrir 60 milljónir króna
%     r_arsprosent  = ársvextir í prósentum, t.d. 4,5
%     n_manudir     = fjöldi mánaða, t.d. 300
%  ÚTTAK:
%     manadargreidsla = föst mánaðargreiðsla í sömu einingu og P
% =========================================================================

    % Breytum ársvöxtum í prósentum yfir í mánaðarvexti sem hlutfall.
    i = r_arsprosent / 100 / 12;

    % Setjum stærðirnar inn í jafngreiðsluformúluna.
    manadargreidsla = P * i / (1 - (1 + i)^(-n_manudir));
end
