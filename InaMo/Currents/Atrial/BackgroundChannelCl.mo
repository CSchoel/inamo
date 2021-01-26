within InaMo.Components.IonCurrents;
model BackgroundChannelCl "I_B,Cl for atrial cell model (Lindblad 1996)"
    extends IonChannelElectric(
        v_eq=v_eq_cl - 0.49 * (v_eq_cl - 30.59e-3),
        g = g_max * (1 + expFit(v, x0=v_eq_cl + 36.95e-3, sx=1000/74.514))
    );
    extends InaMo.Icons.OpenChannel;
    extends InaMo.Icons.Current(current_name="I_b,Cl");
    extends Modelica.Icons.UnderConstruction;
    parameter SI.Voltage v_eq_cl "equilibrium potential for Cl- ions";
end BackgroundChannelCl;
