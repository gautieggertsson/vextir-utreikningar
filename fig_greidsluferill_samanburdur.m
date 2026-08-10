function fig_greidsluferill_samanburdur()
% =========================================================================
%  fig_greidsluferill_samanburdur
%
%  Teiknar greiðsluferil sama 60 m.kr. láns til 25 ára við íslenska
%  raunvexti og evru-raunvexti. Myndin sýnir mánaðargreiðslu, skipt í
%  niðurgreiðslu höfuðstóls og vexti, á föstu verðlagi 2026.
% =========================================================================
% Forsendur úr data_grein.csv. Evrudæmið notar grunnmatið, 0,77%, eins og
% mynd 1; í myndatextum er talan birt sem 0,8%.
P = helper_fasti("lan_hofudstoll_mkr");   % m.kr.
n = helper_fasti("lan_ar") * 12;
cases = [
    struct("title","Íslenskir raunvextir", "subtitle","raunvextir 4,5%", ...
        "rate", helper_fasti("r_island_verdtryggt"))
    struct("title","Evru-raunvextir", "subtitle","raunvextir 0,8%", ...
        "rate", helper_fasti("r_evra_grunnmat"))
];

GREEN = [94 156 123] / 255;
RED = [178 58 72] / 255;
DARK = [0.11 0.11 0.11];
GREY = [0.47 0.47 0.47];

months = (1:n) / 12;
f = figure("Color","w","Units","inches","Position",[1 1 12.2 6.3]);
axesList = gobjects(1,2);

for j = 1:2
    ax = subplot(1,2,j); hold(ax,"on");
    axesList(j) = ax;
    [payment, principal, interest] = payment_series(P, cases(j).rate, n);
    total = principal + interest;
    totalInterest = sum(interest) / 1000;

    a = area(ax, months, [principal(:) interest(:)], "LineStyle","none");
    a(1).FaceColor = GREEN;
    a(2).FaceColor = RED;
    plot(ax, months, total, "Color",DARK, "LineWidth",1.4);

    title(ax, sprintf("%s\n%s", cases(j).title, cases(j).subtitle), ...
        "FontSize",12, "FontWeight","bold", "Color",DARK);
    xlim(ax, [0 25]);
    ylim(ax, [0 360]);
    set(ax, "XTick",[0 5 10 15 20 25], "FontSize",9.5, "TickLength",[0 0]);
    xlabel(ax, "Ár frá lántöku", "FontSize",10.5, "Color",[0.2 0.2 0.2]);
    ax.YGrid = "on";
    ax.GridColor = [0.94 0.94 0.94];
    ax.GridAlpha = 1;
    ax.XColor = [0.30 0.30 0.30];
    ax.YColor = [0.45 0.45 0.45];
    box(ax,"off");

    text(ax, 0.8, principal(1) / 2, "Niðurgreiðsla" + newline + "höfuðstóls", ...
        "Color","w", "FontWeight","bold", "FontSize",9.5, ...
        "HorizontalAlignment","left", "VerticalAlignment","middle");
    if interest(1) > 80
        text(ax, 0.8, principal(1) + interest(1) / 2, "Vextir" + newline + "til bankans", ...
            "Color","w", "FontWeight","bold", "FontSize",9.5, ...
            "HorizontalAlignment","left", "VerticalAlignment","middle");
    else
        text(ax, 3.5, principal(1) + interest(1) + 55, "Vextir til bankans", ...
            "Color",RED, "FontWeight","bold", "FontSize",9.5, ...
            "HorizontalAlignment","left", "VerticalAlignment","middle");
        plot(ax, [1.0 3.3], [principal(1) + interest(1), principal(1) + interest(1) + 47], ...
            "-", "Color",RED, "LineWidth",1.0);
    end

    text(ax, 24.2, total(end) + 7, sprintf("%.0f þús.kr./mán", payment * 1000), ...
        "Color",DARK, "FontWeight","bold", "FontSize",10.5, ...
        "HorizontalAlignment","right", "VerticalAlignment","bottom");
    text(ax, 24.2, 18, sprintf("Heild: %.0f m.kr.\nVextir: %.0f m.kr.", P + totalInterest, totalInterest), ...
        "Color",DARK, "FontWeight","bold", "FontSize",10.5, ...
        "HorizontalAlignment","right", "VerticalAlignment","bottom");
end

ylabel(axesList(1), "Mánaðargreiðsla (þús.kr., verðlag 2026)", ...
    "FontSize",10.5, "Color",[0.2 0.2 0.2]);
set(axesList(1), "Position",[0.08 0.18 0.42 0.56]);
set(axesList(2), "Position",[0.55 0.18 0.42 0.56]);

annotation(f, "textbox", [0.055 0.955 0.90 0.050], ...
    "String","Skipting mánaðargreiðslunnar yfir lánstímann", ...
    "FontSize",15, "FontWeight","bold", "Color",DARK, ...
    "EdgeColor","none", "VerticalAlignment","top");
annotation(f, "textbox", [0.055 0.905 0.90 0.035], ...
    "String","Sama 60 m.kr. lán til 25 ára, reiknað í raunvirði á verðlagi 2026", ...
    "FontSize",10.5, "Color",GREY, "EdgeColor","none", "VerticalAlignment","top");
annotation(f, "rectangle", [0.058 0.842 0.020 0.013], "FaceColor",GREEN, "EdgeColor","none");
annotation(f, "textbox", [0.085 0.838 0.42 0.025], ...
    "String","Niðurgreiðsla höfuðstóls / eignamyndun", "FontSize",9.8, ...
    "Color",DARK, "EdgeColor","none");
annotation(f, "rectangle", [0.058 0.812 0.020 0.013], "FaceColor",RED, "EdgeColor","none");
annotation(f, "textbox", [0.085 0.808 0.42 0.025], ...
    "String","Vextir til bankans", "FontSize",9.8, ...
    "Color",DARK, "EdgeColor","none");
annotation(f, "textbox", [0.055 0.055 0.90 0.070], ...
    "String","Heildargreiðslur yfir 25 ár: um 100 m.kr. við íslenska raunvexti og 66 m.kr. við evru-raunvexti; munurinn er um 34 m.kr. Vaxtagreiðslur: 40 m.kr. á móti 6 m.kr.", ...
    "FontSize",8.4, "Color",GREY, "EdgeColor","none", "VerticalAlignment","top");
end

function [payment, principal, interest] = payment_series(P, annualRate, n)
    monthlyRate = annualRate / 100 / 12;
    payment = helper_annuity(P, annualRate, n);
    balance = P;
    principal = zeros(n,1);
    interest = zeros(n,1);
    for t = 1:n
        interestM = balance * monthlyRate;
        principalM = payment - interestM;
        interest(t) = interestM * 1000;
        principal(t) = principalM * 1000;
        balance = balance - principalM;
    end
end
