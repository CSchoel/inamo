within InaMo.Components.IonChannels;
model BackgroundChannelCl "I_B,Cl for atrial cell model (Lindblad 1996)"
    extends BackgroundChannel(
        v_eq=v_eq_cl - 0.49 * (v_eq_cl - 30.59e-3),
        g = g_max * (1 + scaledExpFit(v, x0=v_eq_cl + 36.95e-3, sx=1000/74.514))
    );
    parameter SI.Voltage v_eq_cl "equilibrium potential for Cl- ions";
end BackgroundChannelCl;
