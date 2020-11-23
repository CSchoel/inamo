import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.axes import Axes
import os


def save_plot(f, name, postfix=""):
    if len(postfix) > 0:
        postfix = "-"+postfix
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/{}{}.pdf".format(name, postfix))
    f.savefig("plots/{}{}.png".format(name, postfix))


def plot_steady(ax, data, fields):
    for id, label in fields:
        ax.plot(data["vc.v"] * 1000, data[id], label=label)
    ax.legend(loc="best")
    ax.set_xlabel("holding potential [mV]")
    ax.set_ylabel("steady state value [1]")
    ax.grid()


def plot_tau(subplots, data, fields):
    if isinstance(subplots, Axes):
        subplots = [subplots] * len(fields)
    for ax, (id, label) in zip(subplots, fields):
        ax.plot(data["vc.v"] * 1000, data[id] * 1000, label=label)
        ax.set_title(label)
        ax.set_xlabel("holding potential [mV]")
        ax.set_ylabel("time constant [ms]")
        ax.grid()


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
    ax.grid()


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
        ax.grid()
    if single and len(amplitudes) > 1:
        ax.legend(loc="best")


def na_lindblad1997_2A(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [
        ("m3_steady", "activation ($m^3$)"),
        ("h_steady", "inactivation($h_1$ and $h_2$)")
    ])
    ax.set_xlim(-90, 100)
    save_plot(f, "na_lindblad1997_2A", postfix=postfix)


def na_lindblad1997_2B(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(ax, data, x="vc.vs_peak", y="cd", normalize=False, factor=1)
    ax.set_xlim(-90, 80)
    save_plot(f, "na_lindblad1997_2B", postfix=postfix)


def na_lindblad1997_2CDE(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    subplots = f.subplots(1, 3, sharex="all")
    plot_tau(subplots, data, [
        ("tau_m", r"$\tau_m$"), ("tau_h1", r"$\tau_{h_1}$"),
        ("tau_h2", r"$\tau_{h_2}$")
    ])
    subplots[0].set_xlim(-90, 100)
    save_plot(f, "na_lindblad1997_2C-E", postfix=postfix)


def k1_lindblad1997_8(fname, postfix=""):
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
    ax.grid()
    save_plot(f, "k1_lindblad1997_8", postfix=postfix)


def ghkFlux(fname, postfix=""):
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
    ax.grid()
    save_plot(f, "ghkFlux", postfix=postfix)


def cal_inada2009_S1AB(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [
        ("act_steady", "activation (AN, NH)"),
        ("act_steady_n", "activation (N)"),
        ("inact_steady", "inactivation")
    ])
    ax.set_xlim(-80, 60)
    save_plot(f, "cal_inada2009_S1AB", postfix=postfix)


def cal_inada2009_S1CD(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    subplots = f.subplots(1, 3, sharex="all")
    plot_tau(subplots, data, [
        ("inact_tau_fast", "inactivation (fast)"),
        ("inact_tau_slow", "inactivation (slow)"),
        ("act_tau", "activation")
    ])
    subplots[0].set_xlim(-80, 60)
    save_plot(f, "cal_inada2009_S1CD", postfix=postfix)


def cal_inada2009_S1E(fname_nh_an, fname_n, postfix=""):
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
    ax.grid()
    save_plot(f, "cal_inada2009_S1E", postfix=postfix)


def cal_inada2009_S1H(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(data["time"] * 1000, data["vc.i"] * 1e12)
    ax.set_ylabel("current [pA]")
    ax.set_xlim(990, 1150)
    ax.set_xlabel("time [ms]")
    ax.grid()
    save_plot(f, "cal_inada2009_S1H", postfix=postfix)


def to_inada2009_S2AB(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [
        ("act_steady", "activation"),
        ("inact_steady", "inactivation")
    ])
    ax.set_xlim(-80, 60)
    save_plot(f, "to_inada2009_S2AB", postfix=postfix)


def to_inada2009_S2CD(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    subplots = f.subplots(1, 3, sharex="all")
    plot_tau(subplots, data, [
        ("inact_tau_fast", "inactivation (fast)"),
        ("inact_tau_slow", "inactivation (slow)"),
        ("act_tau", "activation")
    ])
    subplots[0].set_xlim(-120, 60)
    save_plot(f, "to_inada2009_S2CD", postfix=postfix)


def to_inada2009_S2E(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_i(ax, data, [-10, 0, 20, 40], after=0.5)
    ax.set_xlim(0, 490)
    save_plot(f, "to_inada2009_S2E", postfix=postfix)


def to_inada2009_S2F(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(ax, data, x="vc.vs_peak", y="vc.is_peak")
    ax.set_xlim(-60, 60)
    save_plot(f, "to_inada2009_S2F", postfix=postfix)


def kir_inada2009_S3A(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [
        ("act_steady", "activation"),
        ("inact_steady", "inactivation")
    ])
    ax.set_xlim(-80, 60)
    save_plot(f, "kir_inada2009_S3A", postfix=postfix)


def kir_inada2009_S3B(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    subplots = f.subplots(1, 3, sharex="all")
    plot_tau(subplots, data, [
        ("act_tau_fast", "activation (fast)"),
        ("act_tau_slow", "activation (slow)"),
        ("inact_tau", "inactivation")
    ])
    subplots[0].set_xlim(-120, 80)
    save_plot(f, "kir_inada2009_S3B", postfix=postfix)


def kir_inada2009_S3CD(fname, postfix=""):
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
    save_plot(f, "kir_inada2009_S3CD", postfix=postfix)


def kir_inada2009_S3E(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(6, 4), tight_layout=True)
    subplots = f.subplots(3, 1, sharex="all", sharey="all")
    plot_i(subplots, data, [-10, 10, 30], after=1)
    subplots[0].set_xlim(0, 1000)
    subplots[0].set_yticks([0, 20, 40, 60])
    subplots[0].set_ylim(0, 60)
    save_plot(f, "kir_inada2009_S3E", postfix=postfix)


def f_inada2009_S4A(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [("act_steady", "activation")])
    ax.set_xlim(-120, -40)
    save_plot(f, "f_inada2009_S4A", postfix=postfix)


def f_inada2009_S4B(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_tau(ax, data, [("act_tau", "activation")])
    ax.set_xlim(-120, -40)
    save_plot(f, "f_inada2009_S4B", postfix=postfix)


def f_inada2009_S4C(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(
        ax, data, x="vc.vs_end", y="vc.is_end",
        normalize=False, factor=1/29e-12
    )
    ax.set_xlim(-120, -50)
    save_plot(f, "f_inada2009_S4C", postfix=postfix)


def f_inada2009_S4D(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(6, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_i(ax, data, np.arange(-120, -50, 10), after=6)
    ax.set_ylim(-90, 0)
    ax.set_xlim(0, 6000)
    save_plot(f, "f_inada2009_S4D", postfix=postfix)


def st_inada2009_S5A(fname, postfix=""):
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
    save_plot(f, "st_inada2009_S5A", postfix=postfix)


def st_inada2009_S5_tau(fname, postfix=""):
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
    save_plot(f, "st_inada2009_S5_tau", postfix=postfix)


def st_inada2009_S5B(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(6, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_i(ax, data, np.arange(-80, 70, 10), before=0.05, after=0.85)
    # ax.set_ylim(-90, 0)
    ax.set_xlim(-50, 850)
    save_plot(f, "st_inada2009_S5B", postfix=postfix)


def st_inada2009_S5C(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(
        ax, data, x="vc.vs_peak", y="vc.is_peak",
        normalize=False, factor=1/29e-12
    )
    ax.set_xlim(-80, 60)
    save_plot(f, "st_inada2009_S5C", postfix=postfix)


def st_kurata2002_4bl(fname, postfix=""):
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
    save_plot(f, "st_kurata2002_4bl", postfix=postfix)


def st_kurata2002_4br(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(
        ax, data, x="vc.vs_peak", y="vc.is_peak",
        normalize=False, factor=1/32e-12
    )
    ax.set_xlim(-80, 60)
    save_plot(f, "st_kurata2002_4br", postfix=postfix)


def nak_demir1994_12(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(data["vc.v"] * 1000, data["p.i"] * 1e12)
    ax.set_xlim(-60, 40)
    ax.set_xlabel("membrane potential [mV]")
    ax.set_ylabel("current [pA]")
    ax.grid()
    save_plot(f, "nak_demir1994_12", postfix=postfix)


def naca_inada2009_S6A(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(6, 18), tight_layout=True)
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
    ax3.legend(loc="upper right")
    ax3.set_xlabel("time[ms]")
    ax3.set_ylabel("reaction constant [1/s]")
    ax4.plot(data["time"] * 1000, data["an_nh.vc.v"] * 1000)
    ax4.set_xlabel("time [ms]")
    ax4.set_ylabel("voltage [mV]")
    ax4.set_xlim(0, 500)
    for ax in [ax1, ax2, ax3, ax4]:
        ax.grid()
    save_plot(f, "naca_inada2009_S6A", postfix=postfix)


def naca_inada2009_S6B(fname, postfix=""):
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
    save_plot(f, "naca_inada2009_S6B", postfix=postfix)


def naca_kurata2002_17ur(fname, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(data["vc.v"] * 1000, data["naca.i"] / 32e-12)
    ax.set_xlabel("membrane potential [mV]")
    ax.set_ylabel("current density [pA/pF]")
    ax.set_xlim(-100, 50)
    ax.set_ylim(-1.5, 2.5)
    ax.grid()
    save_plot(f, "naca_kurata2002_17ur", postfix=postfix)


def naca_matsuoka1992_19(fname, postfix=""):
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
    save_plot(f, "naca_matsuoka1992_19", postfix=postfix)


def plot_full_cell(
        axv, axc, data, types=("AN", "N", "NH"), label="%s", time=(0, -1),
        ltype="-", colors=("C0", "C1", "C2")):
    f = np.argmax(data["time"] > time[0])
    t = np.argmax(data["time"] > time[1]) if time[1] > 0 else len(data["time"])
    for tp, c in zip(types, colors):
        kv = "{}.cell.v".format(tp.lower())
        if kv in data:
            axv.plot(
                data["time"][f:t] - data["time"][f], data[kv][f:t] * 1000,
                ltype, color=c, label=label % tp
            )
        kc = "{}.cell.ca.cyto.con".format(tp.lower())
        if kc in data:
            axc.plot(
                data["time"][f:t] - data["time"][f], data[kc][f:t] * 1000,
                ltype, color=c, label=label % tp
            )


def full_inada2009_S7(fname_c, fname_d, refdir=None, postfix=""):
    data_c = pd.read_csv(fname_c, delimiter=",", encoding="utf-8")
    data_d = pd.read_csv(fname_d, delimiter=",", encoding="utf-8")
    f = plt.Figure(figsize=(8, 8), tight_layout=True)
    d_hold = 0.3  # holding duration between pulses
    t_off = 1  # offset from begining of simulation (plot next pulse)
    t_start = np.ceil(t_off/d_hold) * d_hold - 0.05  # start 50 ms before pulse
    d = 0.2  # full width of plot = 200 ms
    t_spon_const = 0.362  # start of spontaneous AP in constant case
    t_spon_dyn = 0.2535  # start of spontaneous AP in dynamic case
    axv, axc = f.subplots(2, 1, sharex="all")
    plot_full_cell(
        axv, axc, data_d, types=["N"], time=(t_spon_dyn, t_spon_dyn + d),
        label="%s (InaMo)", colors=("C2",)
    )
    plot_full_cell(
        axv, axc, data_d, types=["AN", "NH"], time=(t_start, t_start + d),
        label="%s (InaMo)"
    )
    if refdir is not None:
        for c in ["an", "nh", "n"]:
            ref_v = pd.read_csv(os.path.join(refdir, "{}_v.csv".format(c)))
            ref_ca = pd.read_csv(os.path.join(refdir, "{}_ca.csv".format(c)))
            axv.plot(
                ref_v["time[ms]"]/1000, ref_v["voltage[mV]"], ":",
                label="{} (Inada 2009, S7)".format(c.upper())
            )
            axc.plot(
                ref_ca["time[ms]"]/1000, ref_ca["[Ca2+]_i[μM]"], ":",
                label="{} (Inada 2009, S7)".format(c.upper())
            )

    def axv_settings(axv):
        axv.set_ylim(-81, 50)
        axv.set_ylabel("voltage [mV]")
        axv.legend(loc="best")
        axv.grid()

    def axc_settings(axc):
        axc.set_ylim(0, 1)
        axc.set_xlim(0, 0.2)
        axc.set_ylabel("concentration [μM]")
        axc.set_xlabel("time [s]")
        axc.legend(loc="best")
        axc.grid()

    axv_settings(axv)
    axc_settings(axc)
    save_plot(f, "full_inada2009_S7", postfix=postfix)
    # second figure comparing constant and dynamic case
    f2 = plt.Figure(figsize=(8, 8), tight_layout=True)
    axv2, axc2 = f2.subplots(2, 1, sharex="all")
    plot_full_cell(
        axv2, axc2, data_c, types=["N"], time=(t_spon_const, t_spon_const + d),
        label="%s (constant $[Ca^{2+}]_i$)", ltype="--", colors=("C2",)
    )
    plot_full_cell(
        axv2, axc2, data_c, types=["AN", "NH"], time=(t_start, t_start + d),
        label="%s (constant $[Ca^{2+}]_i$)", ltype="--"
    )
    plot_full_cell(
        axv2, axc2, data_d, types=["N"], time=(t_spon_dyn, t_spon_dyn + d),
        label="%s (dynamic $[Ca^{2+}]_i$)", colors=("C2",)
    )
    plot_full_cell(
        axv2, axc2, data_d, types=["AN", "NH"], time=(t_start, t_start + d),
        label="%s (dynamic $[Ca^{2+}]_i$)"
    )
    axv_settings(axv2)
    axc_settings(axc2)
    save_plot(f2, "full_inada2009_S7_const", postfix=postfix)


def ca_custom(fname, fname_i=None, postfix=""):
    refoff = -0.11
    data = pd.read_csv(fname, delimiter=",")
    if fname_i is not None:
        data_i = pd.read_csv(fname_i, delimiter=",")
    f = plt.Figure(figsize=(8, 8), tight_layout=True)
    ax1, ax2, ax3 = f.subplots(3, 1, sharex="all")
    ax1.plot(data["time"], data["ca.jsr.con"]*1e3, label="$[Ca^{2+}]_{jsr}$")
    ax1.plot(data["time"], data["ca.nsr.con"]*1e3, label="$[Ca^{2+}]_{nsr}$")
    ax1.set_ylabel("concentration [μM]")
    ax2.plot(data["time"], data["ca.sub.con"]*1e3, label="$[Ca^{2+}]_{sub}$")
    ax2.plot(data["time"], data["ca.cyto.con"]*1e3, label="$[Ca^{2+}]_{cyto}$")
    ax2.set_ylabel("concentration [μM]")
    # def nsef(x, x0, sx, y_min, y_max):
    #     x_adj = sx * (x - x0)
    #     y = y_min + (y_max - y_min) * np.exp(-(x_adj ** 2))
    #     return y
    ax3.plot(data["time"], data["naca.i"] * 1e12, label="$I_{NaCa}$")
    ax3.plot(data["time"], data["cal.i"] * 1e12, label="$I_{Ca,L}$")
    if fname_i is not None:
        ax3.plot(
            data_i["time"] + refoff, data_i["cell.naca.i"] * 1e12,
            linestyle="--", label="$I_{NaCa}$ (reference)"
        )
        ax3.plot(
            data_i["time"] + refoff, data_i["cell.cal.i"] * 1e12,
            linestyle="--", label="$I_{Ca,L}$ (reference)"
        )
    ax3.set_ylabel("current [pA]")
    ax1.set_xlim(0, 0.5)
    ax3.set_xlabel("time [s]")
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
        ax.grid()
    save_plot(f, "ca_custom", postfix=postfix)


def plot_all(datadir, postfix=""):
    na_lindblad1997_2A(
        os.path.join(datadir, "InaMo.Examples.SodiumChannelSteady_res.csv"),
        postfix=postfix
    )
    na_lindblad1997_2B(
        os.path.join(datadir, "InaMo.Examples.SodiumChannelIV_res.csv"),
        postfix=postfix
    )
    na_lindblad1997_2CDE(
        os.path.join(datadir, "InaMo.Examples.SodiumChannelSteady_res.csv"),
        postfix=postfix
    )
    k1_lindblad1997_8(
        os.path.join(datadir, "InaMo.Examples.InwardRectifierLin_res.csv"),
        postfix=postfix
    )
    ghkFlux(
        os.path.join(datadir, "InaMo.Examples.GHKFlux_res.csv"),
        postfix=postfix
    )
    cal_inada2009_S1AB(
        os.path.join(datadir, "InaMo.Examples.LTypeCalciumSteady_res.csv"),
        postfix=postfix
    )
    cal_inada2009_S1CD(
        os.path.join(datadir, "InaMo.Examples.LTypeCalciumSteady_res.csv"),
        postfix=postfix
    )
    cal_inada2009_S1E(
        os.path.join(datadir, "InaMo.Examples.LTypeCalciumIV_res.csv"),
        os.path.join(datadir, "InaMo.Examples.LTypeCalciumIVN_res.csv"),
        postfix=postfix
    )
    cal_inada2009_S1H(
        os.path.join(datadir, "InaMo.Examples.LTypeCalciumStep_res.csv"),
        postfix=postfix
    )
    to_inada2009_S2AB(
        os.path.join(datadir, "InaMo.Examples.TransientOutwardSteady_res.csv"),
        postfix=postfix
    )
    to_inada2009_S2CD(
        os.path.join(datadir, "InaMo.Examples.TransientOutwardSteady_res.csv"),
        postfix=postfix
    )
    to_inada2009_S2E(
        os.path.join(datadir, "InaMo.Examples.TransientOutwardIV_res.csv"),
        postfix=postfix
    )
    to_inada2009_S2F(
        os.path.join(datadir, "InaMo.Examples.TransientOutwardIV_res.csv"),
        postfix=postfix
    )
    kir_inada2009_S3A(
        os.path.join(
            datadir, "InaMo.Examples.RapidDelayedRectifierSteady_res.csv"),
        postfix=postfix
    )
    kir_inada2009_S3B(
        os.path.join(
            datadir, "InaMo.Examples.RapidDelayedRectifierSteady_res.csv"),
        postfix=postfix
    )
    kir_inada2009_S3CD(
        os.path.join(datadir, "InaMo.Examples.RapidDelayedRectifierIV_res.csv"),
        postfix=postfix
    )
    kir_inada2009_S3E(
        os.path.join(datadir, "InaMo.Examples.RapidDelayedRectifierIV_res.csv"),
        postfix=postfix
    )
    f_inada2009_S4A(
        os.path.join(
            datadir, "InaMo.Examples.HyperpolarizationActivatedSteady_res.csv"),
        postfix=postfix
    )
    f_inada2009_S4B(
        os.path.join(
            datadir, "InaMo.Examples.HyperpolarizationActivatedSteady_res.csv"),
        postfix=postfix
    )
    f_inada2009_S4C(
        os.path.join(
            datadir, "InaMo.Examples.HyperpolarizationActivatedIV_res.csv"),
        postfix=postfix
    )
    f_inada2009_S4D(
        os.path.join(
            datadir, "InaMo.Examples.HyperpolarizationActivatedIV_res.csv"),
        postfix=postfix
    )
    st_inada2009_S5A(
        os.path.join(datadir, "InaMo.Examples.SustainedInwardSteady_res.csv"),
        postfix=postfix
    )
    st_inada2009_S5_tau(
        os.path.join(datadir, "InaMo.Examples.SustainedInwardSteady_res.csv"),
        postfix=postfix
    )
    st_inada2009_S5B(
        os.path.join(datadir, "InaMo.Examples.SustainedInwardIV_res.csv"),
        postfix=postfix
    )
    st_inada2009_S5C(
        os.path.join(datadir, "InaMo.Examples.SustainedInwardIV_res.csv"),
        postfix=postfix
    )
    st_kurata2002_4bl(
        os.path.join(datadir, "InaMo.Examples.SustainedInwardIVKurata_res.csv"),
        postfix=postfix
    )
    st_kurata2002_4br(
        os.path.join(datadir, "InaMo.Examples.SustainedInwardIVKurata_res.csv"),
        postfix=postfix
    )
    nak_demir1994_12(
        os.path.join(datadir, "InaMo.Examples.SodiumPotassiumPumpLin_res.csv"),
        postfix=postfix
    )
    naca_inada2009_S6A(
        os.path.join(
            datadir, "InaMo.Examples.SodiumCalciumExchangerRampInada_res.csv"),
        postfix=postfix
    )
    naca_inada2009_S6B(
        os.path.join(
            datadir, "InaMo.Examples.SodiumCalciumExchangerRampInada_res.csv"),
        postfix=postfix
    )
    naca_matsuoka1992_19(
        os.path.join(
            datadir,
            "InaMo.Examples.SodiumCalciumExchangerLinMatsuoka_res.csv"
        ),
        postfix=postfix
    )
    naca_kurata2002_17ur(
        os.path.join(
            datadir, "InaMo.Examples.SodiumCalciumExchangerLinKurata_res.csv"),
        postfix=postfix
    )
    full_inada2009_S7(
        os.path.join(datadir, "InaMo.Examples.AllCellsC_res.csv"),
        os.path.join(datadir, "InaMo.Examples.AllCells_res.csv"),
        postfix=postfix,
        refdir="data/reconstruct_full_cells_S7"
    )
    ca_custom(
        os.path.join(datadir, "InaMo.Examples.CaHandlingApprox_res.csv"),
        os.path.join(datadir, "InaMo.Examples.FullCellSpon_res.csv"),
        postfix=postfix
    )


if __name__ == "__main__":
    plot_all("out")
    plot_all("regRefData", postfix="ref")
