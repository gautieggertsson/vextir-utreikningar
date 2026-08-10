function r = helper_fisher(i, pi)
% =========================================================================
%  helper_fisher  -  Reiknar raunvexti út frá nafnvöxtum og verðbólgu.
%
%  Höfundur: Gauti B. Eggertsson  (Gauti_Eggertsson@brown.edu)
%  Dagsetning: 19. júní 2026
% =========================================================================
%
%  Hvað gerir fallið?
%  ----------------------------------
%  Nafnvextir eru þeir vextir sem standa í lánasamningi. Raunvextir eru
%  vextir leiðréttir fyrir verðbólgu. Fallið notar Fisher-sambandið:
%
%        1 + raunvextir = (1 + nafnvextir) / (1 + verðbólga)
%
%  Inntak og úttak eru í prósentum. Því er deilt með 100 inni í
%  útreikningnum og margfaldað aftur með 100 í lokin.
%
%  INNTAK:
%     i   = nafnvextir í prósentum, t.d. 9,19
%     pi  = verðbólga í prósentum, t.d. 4,9
%  ÚTTAK:
%     r   = raunvextir í prósentum, t.d. 4,09
% =========================================================================

    % Breytum prósentum í hlutföll, notum Fisher-sambandið og færum
    % niðurstöðuna aftur í prósent.
    r = ( (1 + i/100) ./ (1 + pi/100) - 1 ) * 100;

    % Punkturinn í "./" tryggir að fallið virki bæði fyrir stakar tölur og vigra.
end
