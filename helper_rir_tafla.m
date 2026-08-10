function [t, DE, IT, ES, PT, IE, GR] = helper_rir_tafla()
% =========================================================================
%  helper_rir_tafla  -  ECB RIR-raðirnar á sameiginlegum mánaðarás.
%
%  Les gagnasafnið "rir_ibudalan" úr data_grein.csv, þ.e. vexti nýrra
%  íbúðalána 1995-2003 úr eldri vaxtatölfræði Seðlabanka Evrópu (RIR), og
%  skilar röðunum á sameiginlegum tímaás. NaN stendur þar sem land hefur
%  ekki gögn; gríska röðin hefst t.d. fyrst 1999.
% =========================================================================

    T = helper_gogn("rir_ibudalan");
    t = unique(str2double(T.dags));
    lond = ["DE" "IT" "ES" "PT" "IE" "GR"];
    X = NaN(numel(t), numel(lond));
    for k = 1:numel(lond)
        i = T.lykill == lond(k);
        tk = str2double(T.dags(i));
        vk = T.gildi(i);
        [~, ia, ib] = intersect(tk, t);
        X(ib, k) = vk(ia);
    end
    DE = X(:,1); IT = X(:,2); ES = X(:,3); PT = X(:,4); IE = X(:,5); GR = X(:,6);
end
