import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.axes import Axes
import os


def save_plot(f, name):
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/{}.pdf".format(name))
    f.savefig("plots/{}.png".format(name))


def plot_steady(ax, data, fields):
    for id, label in fields:
        ax.plot(data["vc.v"] * 1000, data[id], label=label)
    ax.legend(loc="best")
    ax.set_xlabel("holding potential [mV]")
    ax.set_ylabel("steady state value [1]")


def plot_tau(subplots, data, fields):
    if isinstance(subplots, Axes):
        subplots = [subplots] * len(fields)
    for ax, (id, label) in zip(subplots, fields):
        ax.plot(data["vc.v"] * 1000, data[id] * 1000, label=label)
        ax.set_title(label)
        ax.set_xlabel("holding potential [mV]")
        ax.set_ylabel("time constant [ms]")


def plot_iv(
    ax, data, x="vs_peak", y="is_peak", normalize=True, factor=1e12,
    label=None
        ):
    skip = np.argmax(np.abs(data[x]) > 0)  # skip beginnging where data[x] == 0
    xvals = data[x][skip:] * 1000
    yvals = data[y][skip:] * factor
    if normalize:
        yvals /= np.max(np.abs(yvals))
    ax.set_xlabel("pulse potential [mV]")
    if normalize:
        ax.set_ylabel("normalized current [1]")
    elif factor == 1e12:
        ax.set_ylabel("current [pA]")
    else:
        ax.set_ylabel("current density [pA/pF]")
    ax.plot(xvals, yvals, label=label)


def plot_i(subplots, data, amplitudes, before=0, after=1, factor=1e12):
    single = isinstance(subplots, Axes)
    if single:
        subplots = [subplots] * len(amplitudes)
    for ax, v in zip(subplots, amplitudes):
        start_pulse = np.argmax(np.logical_and(
            data["vc.v"] == data["vc.v_pulse"],
            np.abs(data["vc.v"] - v / 1000) < 1e-6
        ))
        start = np.argmax(data["time"] >= data["time"][start_pulse] - before)
        end = np.argmax(data["time"] >= data["time"][start_pulse] + after)
        xvals = (data["time"][start:end] - data["time"][start_pulse]) * 1000
        # NOTE it is ok to plot vc.i, because pulse experiments have der(v) = 0
        # => l2.i = 0
        yvals = data["vc.i"][start:end] * factor
        ax.plot(xvals, yvals, label="{} mV".format(v))
        ax.set_xlabel("time [ms]")
        if factor == 1e12:
            ax.set_ylabel("current [pA]")
        else:
            ax.set_ylabel("current density [pA/pF]")
        if not single:
            ax.set_title("{} mV".format(v))
    if single and len(amplitudes) > 1:
        ax.legend(loc="best")


def na_lindblad1997_2A(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [
        ("m3_steady", "activation ($m^3$)"),
        ("h_steady", "inactivation($h_1$ and $h_2$)")
    ])
    ax.set_xlim(-90, 100)
    save_plot(f, "na_lindblad1997_2A")


def na_lindblad1997_2B(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(ax, data, x="vc.vs_peak", y="cd", normalize=False, factor=1)
    ax.set_xlim(-90, 80)
    save_plot(f, "na_lindblad1997_2B")


def na_lindblad1997_2CDE(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    subplots = f.subplots(1, 3, sharex="all")
    plot_tau(subplots, data, [
        ("tau_m", r"$\tau_m$"), ("tau_h1", r"$\tau_{h_1}$"),
        ("tau_h2", r"$\tau_{h_2}$")
    ])
    subplots[0].set_xlim(-90, 100)
    save_plot(f, "na_lindblad1997_2C-E")


def k1_lindblad1997_8(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    v = data["vc.v"]
    i = data["kir.i"]
    i_max = data["i_max"].iloc[-1]
    ax.plot(v * 1000, i / i_max)
    ax.set_xlim(-100, 45)
    ax.set_ylim(-0.5, 1.1)
    ax.set_xlabel("potential [mV]")
    ax.set_ylabel("relative current")
    save_plot(f, "k1_lindblad1997_8")


def ghkFlux(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(data["v"] * 1000, data["flux"] * 1e9, label="ghkFlux(V)")
    ax.plot(data["v"] * 1000, data["flux0"] * 1e9, label="ghkFlux(0)")
    ax.axvline(0, linestyle="--", color="black")
    ax.legend(loc="best")
    ax.set_xlabel("potential[mV]")
    ax.set_ylabel("current density [nA/m²]")
    ax.set_xlim(-20, 80)
    save_plot(f, "ghkFlux")


def cal_inada2009_S1AB(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [
        ("act_steady", "activation (AN, NH)"),
        ("act_steady_n", "activation (N)"),
        ("inact_steady", "inactivation")
    ])
    ax.set_xlim(-80, 60)
    save_plot(f, "cal_inada2009_S1AB")


def cal_inada2009_S1CD(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    subplots = f.subplots(1, 3, sharex="all")
    plot_tau(subplots, data, [
        ("inact_tau_fast", "inactivation (fast)"),
        ("inact_tau_slow", "inactivation (slow)"),
        ("act_tau", "activation")
    ])
    subplots[0].set_xlim(-80, 60)
    save_plot(f, "cal_inada2009_S1CD")


def cal_inada2009_S1E(fname_nh_an, fname_n):
    data_an_nh = pd.read_csv(fname_nh_an, delimiter=",")
    data_n = pd.read_csv(fname_n, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(
        ax, data_an_nh, x="vc.vs_peak", y="vc.is_peak",
        label="AN and NH cells"
    )
    plot_iv(ax, data_n, x="vc.vs_peak",  y="vc.is_peak", label="N cells")
    ax.legend(loc="best")
    ax.set_xlim(-60, 80)
    save_plot(f, "cal_inada2009_S1E")


def cal_inada2009_S1H(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(data["time"] * 1000, data["vc.i"] * 1e12)
    ax.set_ylabel("current [pA]")
    ax.set_xlim(990, 1150)
    ax.set_xlabel("time [ms]")
    save_plot(f, "cal_inada2009_S1H")


def to_inada2009_S2AB(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [
        ("act_steady", "activation"),
        ("inact_steady", "inactivation")
    ])
    ax.set_xlim(-80, 60)
    save_plot(f, "to_inada2009_S2AB")


def to_inada2009_S2CD(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    subplots = f.subplots(1, 3, sharex="all")
    plot_tau(subplots, data, [
        ("inact_tau_fast", "inactivation (fast)"),
        ("inact_tau_slow", "inactivation (slow)"),
        ("act_tau", "activation")
    ])
    subplots[0].set_xlim(-120, 60)
    save_plot(f, "to_inada2009_S2CD")


def to_inada2009_S2E(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_i(ax, data, [-10, 0, 20, 40], after=0.5)
    save_plot(f, "to_inada2009_S2E")


def to_inada2009_S2F(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(ax, data, x="vc.vs_peak", y="vc.is_peak")
    ax.set_xlim(-60, 60)
    save_plot(f, "to_inada2009_S2F")


def kir_inada2009_S3A(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [
        ("act_steady", "activation"),
        ("inact_steady", "inactivation")
    ])
    ax.set_xlim(-80, 60)
    save_plot(f, "kir_inada2009_S3A")


def kir_inada2009_S3B(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    subplots = f.subplots(1, 3, sharex="all")
    plot_tau(subplots, data, [
        ("act_tau_fast", "activation (fast)"),
        ("act_tau_slow", "activation (slow)"),
        ("inact_tau", "inactivation")
    ])
    subplots[0].set_xlim(-120, 80)
    save_plot(f, "kir_inada2009_S3B")


def kir_inada2009_S3CD(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(
        ax, data, x="vc.vs_peak", y="vc.is_peak", label="peak current"
    )
    plot_iv(
        ax, data, x="vc.vs_tail", y="vc.is_tail", label="peak tail current"
    )
    plot_iv(
        ax, data, x="vc.vs_end", y="vc.is_end", label="current at end of pulse"
    )
    ax.set_xlim(-40, 60)
    ax.legend(loc="best")
    save_plot(f, "kir_inada2009_S3CD")


def kir_inada2009_S3E(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(6, 4), tight_layout=True)
    subplots = f.subplots(3, 1, sharex="all", sharey="all")
    plot_i(subplots, data, [-10, 10, 30], after=1)
    subplots[0].set_xlim(0, 1000)
    subplots[0].set_yticks([0, 20, 40, 60])
    subplots[0].set_ylim(0, 60)
    save_plot(f, "kir_inada2009_S3E")


def f_inada2009_S4A(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [("act_steady", "activation")])
    ax.set_xlim(-120, -40)
    save_plot(f, "f_inada2009_S4A")


def f_inada2009_S4B(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_tau(ax, data, [("act_tau", "activation")])
    ax.set_xlim(-120, -40)
    save_plot(f, "f_inada2009_S4B")


def f_inada2009_S4C(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(
        ax, data, x="vc.vs_end", y="vc.is_end",
        normalize=False, factor=1/29e-12
    )
    ax.set_xlim(-120, -50)
    save_plot(f, "f_inada2009_S4C")


def f_inada2009_S4D(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(6, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_i(ax, data, np.arange(-120, -50, 10), after=6)
    ax.set_ylim(-90, 0)
    ax.set_xlim(0, 6000)
    save_plot(f, "f_inada2009_S4D")


def st_inada2009_S5A(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [
        ("act_steady", "activation"),
        ("inact_steady", "inactivation")
    ])
    ax.plot(
        data["v"] * 1000, data["act_steady2"], "r--",
        label="activation reference"
    )
    ax.plot(
        data["v"] * 1000, data["inact_steady2"], "r--",
        label="inactivation reference"
    )
    ax.set_xlim(-80, 60)
    save_plot(f, "st_inada2009_S5A")


def st_inada2009_S5_tau(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    subplots = f.subplots(1, 2, sharex="all")
    plot_tau(subplots, data, [
        ("act_tau", "activation"),
        ("inact_tau", "inactivation")
    ])
    subplots[0].plot(data["v"] * 1000, data["act_tau2"] * 1000, "r--")
    subplots[1].plot(data["v"] * 1000, data["inact_tau2"] * 1000, "r--")
    subplots[0].set_xlim(-80, 60)
    save_plot(f, "st_inada2009_S5_tau")


def st_inada2009_S5B(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(6, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_i(ax, data, np.arange(-80, 70, 10), before=0.05, after=0.85)
    # ax.set_ylim(-90, 0)
    ax.set_xlim(-50, 850)
    save_plot(f, "st_inada2009_S5B")


def st_inada2009_S5C(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(
        ax, data, x="vc.vs_peak", y="vc.is_peak",
        normalize=False, factor=1/29e-12
    )
    ax.set_xlim(-80, 60)
    save_plot(f, "st_inada2009_S5C")


def st_kurata2002_4bl(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(6, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_i(
        ax, data, np.arange(-70, 60, 10), before=0.05, after=0.85,
        factor=1/32e-12
    )
    ax.legend(loc="right")
    # ax.set_ylim(-90, 0)
    ax.set_xlim(-50, 850)
    save_plot(f, "st_kurata2002_4bl")


def st_kurata2002_4br(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(
        ax, data, x="vc.vs_peak", y="vc.is_peak",
        normalize=False, factor=1/32e-12
    )
    ax.set_xlim(-80, 60)
    save_plot(f, "st_kurata2002_4br")


def nak_demir1994_12(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(data["vc.v"] * 1000, data["p.i"] * 1e12)
    ax.set_xlim(-60, 40)
    ax.set_xlabel("membrane potential [mV]")
    ax.set_ylabel("current [pA]")
    save_plot(f, "nak_demir1994_12")


def naca_inada2009_S6A(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 12), tight_layout=True)
    ax1, ax2, ax3, ax4 = f.subplots(4, 1, sharex="all")
    ax1.plot(
        data["time"] * 1000,
        data["an_nh.naca.i"] / 40e-12, label="AN, NH"
    )
    ax1.plot(
        data["time"] * 1000,
        data["n.naca.i"] / 29e-12, label="N"
    )
    ax1.set_xlabel("time[ms]")
    ax1.set_ylabel("current density [pA/pF]")
    ax1.legend(loc="best")
    for id, label in [("n", "N"), ("an_nh", "AN, NH")]:
        for i in range(1, 5):
            ax2.plot(
                data["time"] * 1000,
                data["{}.naca.e{}".format(id, i)],
                label="E{} ({})".format(i, label),
                linestyle="-" if id == "n" else "--"
            )
    ax2.set_xlabel("time[ms]")
    ax2.set_ylabel("ratio of molecules in state [1]")
    ax2.legend(loc="best")
    seq = [(i, i % 4 + 1) for i in range(1, 5)]
    for a, b in seq + [(b, a) for a, b in seq]:
        # if a != 1 or b != 4:
        #   continue
        ax3.plot(
            data["time"] * 1000,
            data["an_nh.naca.k_{}{}".format(a, b)],
            label="$k_{{{}{}}}$ (AN, NH)".format(a, b),
            alpha=0.5
        )
    for v in ["12", "14"]:  # only k_12 and k_14 depend on ca_sub
        ax3.plot(
            data["time"] * 1000,
            data["n.naca.k_"+v],
            label="$k_{{{}}}$ (N)".format(v),
            linestyle="--",
            alpha=0.5
        )
    ax3.legend(loc="best")
    ax3.set_xlabel("time[ms]")
    ax3.set_ylabel("reaction constant [1/s]")
    ax4.plot(data["time"] * 1000, data["an_nh.vc.v"] * 1000)
    ax4.set_xlabel("time [ms]")
    ax4.set_ylabel("voltage [mV]")
    save_plot(f, "naca_inada2009_S6A")


def naca_inada2009_S6B(fname):
    data = pd.read_csv(fname, delimiter=",")
    s = np.argmax(data["time"] > 0.05) + 1
    e = np.argmax(data["time"] >= 0.3)
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(
        data["an_nh.vc.v"][s:e] * 1000,
        data["an_nh.naca.i"][s:e] / 40e-12, label="AN, NH"
    )
    ax.plot(
        data["n.vc.v"][s:e] * 1000,
        data["n.naca.i"][s:e] / 29e-12, label="N"
    )
    ax.set_xlabel("membrane potential [mV]")
    ax.set_ylabel("current density [pA/pF]")
    ax.set_xlim(-80, 60)
    ax.set_ylim(-1, 3)
    ax.grid()
    save_plot(f, "naca_inada2009_S6B")


def naca_kurata2002_17ur(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(data["vc.v"] * 1000, data["naca.i"] / 32e-12)
    ax.set_xlabel("membrane potential [mV]")
    ax.set_ylabel("current density [pA/pF]")
    ax.set_xlim(-100, 50)
    ax.set_ylim(-1.5, 2.5)
    save_plot(f, "naca_kurata2002_17ur")


def naca_matsuoka1992_19(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 8), tight_layout=True)
    subplots = f.subplots(2, 2, sharex="all")
    for c, ax in zip("abcd", subplots.flatten()):
        for i in range(1, 4):
            ax.plot(
                data["{}{}.vc.v".format(c, i)] * 1000,
                data["{}{}.naca.i".format(c, i)] * 1e12
            )
        ax.set_title(c.upper())
    for ax in subplots.flatten():
        ax.set_xlabel("membrane potential [mV]")
        ax.set_xlim(-140, 120)
        ax.set_ylabel("current [pA]")
        ax.grid()
    save_plot(f, "naca_matsuoka1992_19")


def full_inada2009_S7(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 8), tight_layout=True)
    ax1, ax2 = f.subplots(2, 1, sharex="all")
    for tp in ["AN", "N", "NH"]:
        line = ax1.plot(
            data["time"], data["{}.cell.v".format(tp.lower())], label=tp
        )
        ax2.plot(
            data["time"],
            data["{}.cell.ca.cyto.c.c".format(tp.lower())],
            label="$Ca_{{i}}$ ({})".format(tp), color=line[0].get_color()
        )
        ax2.plot(
            data["time"],
            data["{}.cell.ca.sub.c.c".format(tp.lower())],
            "--", color=line[0].get_color(),
            label="$Ca_{{sub}}$ ({})".format(tp)
        )
    ax1.legend(loc="best")
    ax2.legend(loc="best")
    save_plot(f, "full_inada2009_S7")


def full_inada2009_S7_c(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    for tp in ["AN", "N", "NH"]:
        ax.plot(data["time"], data["{}.cell.v".format(tp.lower())], label=tp)
    ax.legend(loc="best")
    save_plot(f, "full_inada2009_S7_c")


def ca_custom(fname, fname_i=None):
    data = pd.read_csv(fname, delimiter=",")
    if fname_i is not None:
        data_i = pd.read_csv(fname_i, delimiter=",")
    f = plt.Figure(figsize=(8, 8), tight_layout=True)
    ax1, ax2, ax3 = f.subplots(3, 1, sharex="all")
    ax1.plot(data["time"], data["ca.jsr.c.c"], label="$[Ca^{2+}]_{jsr}$")
    ax1.plot(data["time"], data["ca.nsr.c.c"], label="$[Ca^{2+}]_{nsr}$")
    ax2.plot(data["time"], data["ca.sub.c.c"], label="$[Ca^{2+}]_{sub}$")
    ax2.plot(data["time"], data["ca.cyto.c.c"], label="$[Ca^{2+}]_{cyto}$")
    def nsef(x, x0, sx, y_min, y_max):
        x_adj = sx * (x - x0)
        y = y_min + (y_max - y_min) * np.exp(-(x_adj ** 2))
        return y
    ax3.plot(data["time"], data["naca.i"], label="$I_{NaCa}$")
    ax3.plot(data["time"], data["cal.i"], label="$I_{Ca,L}$")
    if fname_i is not None:
        ax3.plot(
            data_i["time"], data_i["cell.naca.i"],
            label="$I_{NaCa}$ (reference)"
        )
        ax3.plot(
            data_i["time"], data_i["cell.cal.i"],
            label="$I_{Ca,L}$ (reference)"
        )
    # ax3.plot(
    #     data["time"],
    #     nsef(data["time"], 0.2, 200, 0, -3e-10)
    #     + nsef(data["time"], 0.23, 30, 0, -1e-10)
    #     + nsef(data["time"], -0.1, 6, 0, -1e-10), label="$I_{Ca,L}$"
    # )
    # ax3.plot(
    #     data["time"],
    #     nsef(data["time"], 0.2, 200, -0.5e-11, -4e-11)
    #     + nsef(data["time"], 0.23, 50, -0.5e-11, 0.3e-11)
    #     + nsef(data["time"], -0.1, 6, 0, -0.5e-10), label="$I_{NaCa}$"
    # )
    for ax in [ax1, ax2, ax3]:
        ax.legend(loc="best")
    save_plot(f, "ca_custom")


if __name__ == "__main__":
    na_lindblad1997_2A("out/InaMo.Examples.SodiumChannelSteady_res.csv")
    na_lindblad1997_2B("out/InaMo.Examples.SodiumChannelIV_res.csv")
    na_lindblad1997_2CDE("out/InaMo.Examples.SodiumChannelSteady_res.csv")
    k1_lindblad1997_8("out/InaMo.Examples.InwardRectifierLin_res.csv")
    ghkFlux("out/InaMo.Examples.GHKFlux_res.csv")
    cal_inada2009_S1AB("out/InaMo.Examples.LTypeCalciumSteady_res.csv")
    cal_inada2009_S1CD("out/InaMo.Examples.LTypeCalciumSteady_res.csv")
    cal_inada2009_S1E(
        "out/InaMo.Examples.LTypeCalciumIV_res.csv",
        "out/InaMo.Examples.LTypeCalciumIVN_res.csv"
    )
    cal_inada2009_S1H("out/InaMo.Examples.LTypeCalciumStep_res.csv")
    to_inada2009_S2AB("out/InaMo.Examples.TransientOutwardSteady_res.csv")
    to_inada2009_S2CD("out/InaMo.Examples.TransientOutwardSteady_res.csv")
    to_inada2009_S2E("out/InaMo.Examples.TransientOutwardIV_res.csv")
    to_inada2009_S2F("out/InaMo.Examples.TransientOutwardIV_res.csv")
    kir_inada2009_S3A("out/InaMo.Examples.RapidDelayedRectifierSteady_res.csv")
    kir_inada2009_S3B("out/InaMo.Examples.RapidDelayedRectifierSteady_res.csv")
    kir_inada2009_S3CD("out/InaMo.Examples.RapidDelayedRectifierIV_res.csv")
    kir_inada2009_S3E("out/InaMo.Examples.RapidDelayedRectifierIV_res.csv")
    f_inada2009_S4A(
        "out/InaMo.Examples.HyperpolarizationActivatedSteady_res.csv"
    )
    f_inada2009_S4B(
        "out/InaMo.Examples.HyperpolarizationActivatedSteady_res.csv"
    )
    f_inada2009_S4C("out/InaMo.Examples.HyperpolarizationActivatedIV_res.csv")
    f_inada2009_S4D("out/InaMo.Examples.HyperpolarizationActivatedIV_res.csv")
    st_inada2009_S5A("out/InaMo.Examples.SustainedInwardSteady_res.csv")
    st_inada2009_S5_tau("out/InaMo.Examples.SustainedInwardSteady_res.csv")
    st_inada2009_S5B("out/InaMo.Examples.SustainedInwardIV_res.csv")
    st_inada2009_S5C("out/InaMo.Examples.SustainedInwardIV_res.csv")
    st_kurata2002_4bl("out/InaMo.Examples.SustainedInwardIVKurata_res.csv")
    st_kurata2002_4br("out/InaMo.Examples.SustainedInwardIVKurata_res.csv")
    nak_demir1994_12("out/InaMo.Examples.SodiumPotassiumPumpLin_res.csv")
    naca_inada2009_S6A(
        "out/InaMo.Examples.SodiumCalciumExchangerRampInada_res.csv"
    )
    naca_inada2009_S6B(
        "out/InaMo.Examples.SodiumCalciumExchangerRampInada_res.csv"
    )
    naca_matsuoka1992_19(
        "out/InaMo.Examples.SodiumCalciumExchangerLinMatsuoka_res.csv"
    )
    naca_kurata2002_17ur(
        "out/InaMo.Examples.SodiumCalciumExchangerLinKurata_res.csv"
    )
    full_inada2009_S7("out/InaMo.Examples.AllCellsSpon_res.csv")
    full_inada2009_S7_c("out/InaMo.Examples.AllCellsSponC_res.csv")
    ca_custom(
        "out/InaMo.Examples.CaHandlingApprox_res.csv",
        "out/InaMo.Examples.FullCellSpon_res.csv"
    )
