within InaMo.Components.IonChannels;
model BackgroundChannelCl;
    extends BackgroundChannel(
        v_eq=v_eq_cl - 0.49 * (v_eq_cl - 30.59e-3),
        g = g_max * (1 + scaledExponentialFit(v, x0=v_eq_cl + 36.95e-3, sx=1000/74.514))
    );
    parameter SI.Voltage v_eq_cl "equilibrium potential for Cl- ions";
end BackgroundChannelCl;