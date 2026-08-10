function gildi = helper_fasti(rod)
% =========================================================================
%  helper_fasti  -  Skilar stakri stærð úr gagnasafninu "fastar".
%
%  Fastar eru stakar tölur greinarinnar, t.d. höfuðstóll viðmiðunarlánsins,
%  raunvaxtaviðmið og útistandandi íbúðalán heimila. Þessar stærðir eru
%  geymdar í data_grein.csv ásamt heimild í textadálkinum.
%
%  INNTAK:
%     rod = heiti fastans, t.d. "skuldir_heimila_makr"
%  ÚTTAK:
%     gildi = tölugildið
% =========================================================================

    T = helper_gogn("fastar");
    i = T.rod == string(rod);
    if nnz(i) ~= 1
        error("Fastinn '%s' finnst ekki, eða er margskráður, í data_grein.csv.", rod);
    end
    gildi = T.gildi(i);
end
