import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.axes import Axes
from matplotlib.colors import ColorConverter
import colorsys
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
    ax.set_ylim(0, 1)
    ax.grid(True)


def plot_tau(subplots, data, fields):
    if isinstance(subplots, Axes):
        subplots = [subplots] * len(fields)
    for ax, (id, label) in zip(subplots, fields):
        ax.plot(data["vc.v"] * 1000, data[id] * 1000, label=label)
        ax.set_title(label)
        ax.set_xlabel("holding potential [mV]")
        ax.set_ylabel("time constant [ms]")
        ax.grid(True)


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
    ax.grid(True)


def plot_i(subplots, data, amplitudes, before=0, after=1, factor=1e12):
    single = isinstance(subplots, Axes)
    if single:
        subplots = [subplots] * len(amplitudes)
    for ax, v in zip(subplots, amplitudes):
        start_pulse = np.argmax(np.logical_and(
            np.isclose(data["vc.v"] * 1e3, data["vc.v_pulse"] * 1e3),
            np.isclose(data["vc.v"] * 1e3, v)
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
        ax.grid(True)
    if single and len(amplitudes) > 1:
        ax.legend(loc="best")


def scale_lightness(c, factor):
    # idea from https://stackoverflow.com/a/60562502
    rgb = ColorConverter.to_rgb(c)
    h, l, s = colorsys.rgb_to_hls(*rgb)
    # manipulate h, l, s values and return as rgb
    return colorsys.hls_to_rgb(h, min(1, l * factor), s)


def plot_ref(ax, fname, color, label=None, xoff=0, xscale=1, yscale=1):
    data = pd.read_csv(fname, delimiter=",")
    x, y = data.columns
    c = scale_lightness(color, 0.7)
    ax.plot((data[x] + xoff)*xscale, data[y]*yscale, color=c, linestyle="--", label=label)


def na_lindblad1996_2A(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [
        ("m3_steady", "activation ($m^3$)"),
        ("h_steady", "inactivation($h_1$ and $h_2$)")
    ])
    plot_ref(ax, ref.format("act"), "C0")
    plot_ref(ax, ref.format("inact"), "C1")
    ax.set_xlim(-90, 25)
    save_plot(f, "na_lindblad1996_2A", postfix=postfix)


def na_lindblad1996_2B(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(ax, data, x="vc.vs_peak", y="cd", normalize=False, factor=1)
    plot_ref(ax, ref, "C0")
    ax.set_xlim(-90, 80)
    save_plot(f, "na_lindblad1996_2B", postfix=postfix)


def na_lindblad1996_2CDE(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    subplots = f.subplots(1, 3, sharex="all")
    plot_tau(subplots, data, [
        ("tau_m", r"$\tau_m$"), ("tau_h1", r"$\tau_{h_1}$"),
        ("tau_h2", r"$\tau_{h_2}$")
    ])
    plot_ref(subplots[0], ref.format("C"), "C0")
    plot_ref(subplots[1], ref.format("D"), "C0")
    plot_ref(subplots[2], ref.format("E"), "C0")
    subplots[0].set_xlim(-90, 100)
    save_plot(f, "na_lindblad1996_2C-E", postfix=postfix)


def k1_lindblad1996_8(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    v = data["vc.v"]
    i = data["kir.i"]
    i_max = data["i_max"].iloc[-1]
    ax.plot(v * 1000, i / i_max)
    # NOTE a slight adjustment of x axis is required, because PDF of original
    # paper is slightly rotated and skewed
    plot_ref(ax, ref, "C0", xoff=1, xscale=1.05)
    ax.set_xlim(-100, 45)
    ax.set_ylim(-0.5, 1.1)
    ax.set_xlabel("potential [mV]")
    ax.set_ylabel("relative current")
    ax.grid(True)
    save_plot(f, "k1_lindblad1996_8", postfix=postfix)


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
    ax.grid(True)
    save_plot(f, "ghkFlux", postfix=postfix)


def cal_inada2009_S1AB(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [
        ("act_steady", "activation (AN, NH)"),
        ("act_steady_n", "activation (N)"),
        ("inact_steady", "inactivation")
    ])
    plot_ref(ax, ref.format("A_orig_steady_1"), "C1")
    plot_ref(ax, ref.format("A_orig_steady_2"), "C0")
    plot_ref(ax, ref.format("B_orig_inact_steady"), "C2")
    ax.set_xlim(-80, 60)
    save_plot(f, "cal_inada2009_S1AB", postfix=postfix)


def cal_inada2009_S1CD(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    subplots = f.subplots(1, 3, sharex="all")
    plot_tau(subplots, data, [
        ("inact_tau_fast", "inactivation (fast)"),
        ("inact_tau_slow", "inactivation (slow)"),
        ("act_tau", "activation")
    ])
    plot_ref(subplots[0], ref.format("C"), "C0")
    plot_ref(subplots[1], ref.format("D"), "C0")
    subplots[0].set_xlim(-80, 60)
    save_plot(f, "cal_inada2009_S1CD", postfix=postfix)


def cal_inada2009_S1E(fname_nh_an, fname_n, ref, postfix=""):
    data_an_nh = pd.read_csv(fname_nh_an, delimiter=",")
    data_n = pd.read_csv(fname_n, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(
        ax, data_an_nh, x="vc.vs_peak", y="vc.is_peak",
        label="AN and NH cells"
    )
    plot_iv(ax, data_n, x="vc.vs_peak",  y="vc.is_peak", label="N cells")
    plot_ref(ax, ref.format("iv_2"), "C0")
    plot_ref(ax, ref.format("iv_1"), "C1")
    ax.legend(loc="best")
    ax.set_xlim(-60, 80)
    save_plot(f, "cal_inada2009_S1E", postfix=postfix)


def cal_inada2009_S1H(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(data["time"] * 1000, data["vc.i"] * 1e12)
    # NOTE reference data needs to be scaled, because x-axis is only given
    # as measuring strip, which seems to only apply to experimental data in S1H
    plot_ref(ax, ref, "C0", xoff=948/0.75, xscale=0.75)
    ax.set_ylabel("current [pA]")
    ax.set_xlim(990, 1150)
    ax.set_xlabel("time [ms]")
    ax.grid(True)
    save_plot(f, "cal_inada2009_S1H", postfix=postfix)


def to_inada2009_S2AB(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [
        ("act_steady", "activation"),
        ("inact_steady", "inactivation")
    ])
    plot_ref(ax, ref.format("A_orig_act_steady"), "C0")
    plot_ref(ax, ref.format("B_orig_inact_steady"), "C1")
    ax.set_xlim(-80, 60)
    save_plot(f, "to_inada2009_S2AB", postfix=postfix)


def to_inada2009_S2CD(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    subplots = f.subplots(1, 3, sharex="all")
    plot_tau(subplots, data, [
        ("inact_tau_fast", "inactivation (fast)"),
        ("inact_tau_slow", "inactivation (slow)"),
        ("act_tau", "activation")
    ])
    plot_ref(subplots[0], ref.format("C"), "C0")
    plot_ref(subplots[1], ref.format("D"), "C0")
    subplots[0].set_xlim(-120, 60)
    save_plot(f, "to_inada2009_S2CD", postfix=postfix)


def to_inada2009_S2E(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_i(ax, data, [-10, 0, 20, 40], after=0.5)
    for i, v in enumerate([-10, 0, 20, 40]):
        # yscale = 1.33 makes differences vanish
        plot_ref(ax, ref.format(str(v)), "C{}".format(i), xoff=-53)
    ax.set_xlim(0, 490)
    save_plot(f, "to_inada2009_S2E", postfix=postfix)


def to_inada2009_S2F(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(ax, data, x="vc.vs_peak", y="vc.is_peak")
    plot_ref(ax, ref, "C0")
    ax.set_xlim(-60, 60)
    save_plot(f, "to_inada2009_S2F", postfix=postfix)


def kr_inada2009_S3A(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [
        ("act_steady", "activation"),
        ("inact_steady", "inactivation")
    ])
    plot_ref(ax, ref, "C0")
    ax.set_xlim(-80, 60)
    save_plot(f, "kr_inada2009_S3A", postfix=postfix)


def kr_inada2009_S3B(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    subplots = f.subplots(1, 3, sharex="all")
    plot_tau(subplots, data, [
        ("act_tau_fast", "activation (fast)"),
        ("act_tau_slow", "activation (slow)"),
        ("inact_tau", "inactivation")
    ])
    plot_ref(subplots[0], ref, "C0")
    subplots[0].set_xlim(-120, 80)
    save_plot(f, "kr_inada2009_S3B", postfix=postfix)


def kr_inada2009_S3CD(fname, ref, postfix=""):
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
    plot_ref(ax, ref.format("C"), "C2")
    plot_ref(ax, ref.format("D"), "C1")
    ax.set_xlim(-40, 60)
    ax.legend(loc="best")
    save_plot(f, "kr_inada2009_S3CD", postfix=postfix)


def kr_inada2009_S3E(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(6, 4), tight_layout=True)
    subplots = f.subplots(3, 1, sharex="all", sharey="all")
    plot_i(subplots, data, [-10, 10, 30], after=1)
    plot_ref(subplots[0], ref.format("1"), "C0")
    plot_ref(subplots[1], ref.format("2"), "C0")
    plot_ref(subplots[2], ref.format("3"), "C0")
    subplots[0].set_xlim(0, 1000)
    subplots[0].set_yticks([0, 20, 40, 60])
    subplots[0].set_ylim(0, 60)
    save_plot(f, "kr_inada2009_S3E", postfix=postfix)


def f_inada2009_S4A(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [("act_steady", "activation")])
    plot_ref(ax, ref, "C0")
    ax.set_xlim(-120, -40)
    save_plot(f, "f_inada2009_S4A", postfix=postfix)


def f_inada2009_S4B(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_tau(ax, data, [("act_tau", "activation")])
    plot_ref(ax, ref, "C0")
    ax.set_xlim(-120, -40)
    save_plot(f, "f_inada2009_S4B", postfix=postfix)


def f_inada2009_S4C(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(
        ax, data, x="vc.vs_end", y="vc.is_end",
        normalize=False, factor=1/29e-12
    )
    plot_ref(ax, ref, "C0")
    ax.set_xlim(-120, -50)
    save_plot(f, "f_inada2009_S4C", postfix=postfix)


def f_inada2009_S4D(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(6, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_i(ax, data, np.arange(-120, -50, 10), after=6)
    for i in range(1, 8):
        # NOTE xscale required due to inaccurate measuring strip for x axis
        plot_ref(ax, ref.format(i), "C{}".format(i-1), xscale=0.975)
    ax.set_ylim(-90, 0)
    ax.set_xlim(0, 6000)
    save_plot(f, "f_inada2009_S4D", postfix=postfix)


def st_inada2009_S5A(fname, ref, postfix="", debug_info=False):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [
        ("act_steady", "activation"),
        ("inact_steady", "inactivation")
    ])
    plot_ref(ax, ref, "C0")
    if debug_info:
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


def st_inada2009_S5B(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(6, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_i(
        ax, data, np.arange(-80, 70, 10),
        before=0.05, after=0.85, factor=1/29e-12
    )
    for i, v in enumerate(range(-80, 70, 10)):
        plot_ref(ax, ref.format(str(v)), "C{}".format(i))
    # ax.set_ylim(-90, 0)
    ax.set_xlim(-50, 850)
    save_plot(f, "st_inada2009_S5B", postfix=postfix)


def st_inada2009_S5C(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(
        ax, data, x="vc.vs_peak", y="vc.is_peak",
        normalize=False, factor=1/29e-12
    )
    plot_ref(ax, ref, "C0")
    ax.set_xlim(-80, 60)
    save_plot(f, "st_inada2009_S5C", postfix=postfix)


def st_kurata2002_4bl(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(6, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_i(
        ax, data, np.arange(-70, 60, 10), before=0.05, after=0.85,
        factor=1/32e-12
    )
    ax.legend(loc="right")
    for i, v in enumerate(range(-70, 60, 10)):
        plot_ref(ax, ref.format(str(v)), "C{}".format(i), xoff=-50)
    # ax.set_ylim(-90, 0)
    ax.set_xlim(-50, 850)
    save_plot(f, "st_kurata2002_4bl", postfix=postfix)


def st_kurata2002_4br(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(
        ax, data, x="vc.vs_peak", y="vc.is_peak",
        normalize=False, factor=1/32e-12
    )
    plot_ref(ax, ref, "C0")
    ax.set_xlim(-80, 60)
    save_plot(f, "st_kurata2002_4br", postfix=postfix)


def nak_demir1994_12(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(data["vc.v"] * 1000, data["p.i"] * 1e12)
    plot_ref(ax, ref, "C0")
    ax.set_xlim(-60, 40)
    ax.set_xlabel("membrane potential [mV]")
    ax.set_ylabel("current [pA]")
    ax.grid(True)
    save_plot(f, "nak_demir1994_12", postfix=postfix)


def naca_inada2009_S6A(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(10, 8), tight_layout=True)
    (ax_ul, ax_ur), (ax_bl, ax_br) = f.subplots(2, 2, sharex="all")
    ax_ul.plot(
        data["time"] * 1000,
        data["an_nh.naca.i"] / 40e-12, label="AN, NH"
    )
    ax_ul.plot(
        data["time"] * 1000,
        data["n.naca.i"] / 29e-12, label="N"
    )
    plot_ref(ax_ul, ref.format("AN+NH"), "C0")
    plot_ref(ax_ul, ref.format("n"), "C1")
    ax_ul.set_xlabel("time[ms]")
    ax_ul.set_ylabel("current density [pA/pF]")
    ax_ul.legend(loc="best")
    for id, label in [("n", "N"), ("an_nh", "AN, NH")]:
        for i in range(1, 5):
            ax_ur.plot(
                data["time"] * 1000,
                data["{}.naca.e{}".format(id, i)],
                label="E{} ({})".format(i, label),
                linestyle="-" if id == "n" else "--"
            )
    ax_ur.set_xlabel("time[ms]")
    ax_ur.set_ylabel("ratio of molecules in state [1]")
    ax_ur.legend(loc="best")
    seq = [(i, i % 4 + 1) for i in range(1, 5)]
    for a, b in seq + [(b, a) for a, b in seq]:
        # if a != 1 or b != 4:
        #   continue
        ax_br.plot(
            data["time"] * 1000,
            data["an_nh.naca.k_{}{}".format(a, b)],
            label="$k_{{{}{}}}$ (AN, NH)".format(a, b),
            alpha=0.5
        )
    for v in ["12", "14"]:  # only k_12 and k_14 depend on ca_sub
        ax_br.plot(
            data["time"] * 1000,
            data["n.naca.k_"+v],
            label="$k_{{{}}}$ (N)".format(v),
            linestyle="--",
            alpha=0.5
        )
    ax_br.legend(loc="upper right")
    ax_br.set_xlabel("time[ms]")
    ax_br.set_ylabel("reaction constant [1/s]")
    ax_bl.plot(data["time"] * 1000, data["an_nh.vc.v"] * 1000)
    ax_bl.set_xlabel("time [ms]")
    ax_bl.set_ylabel("voltage [mV]")
    ax_bl.set_xlim(0, 500)
    for ax in [ax_ul, ax_ur, ax_bl, ax_br]:
        ax.grid(True)
    save_plot(f, "naca_inada2009_S6A", postfix=postfix)


def naca_inada2009_S6B(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    s = np.argmax(data["time"] > 0.05) + 1
    e = np.argmax(data["time"] >= 0.3)
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(
        data["an_nh.vc.v"][s:e] * 1000,
        data["an_nh.naca.i"][s:e] / 40e-12, label="AN, NH"
    )
    ax.plot(
        data["n.vc.v"][s:e] * 1000,
        data["n.naca.i"][s:e] / 29e-12, label="N"
    )
    plot_ref(ax, ref.format("AN+NH"), "C0")
    plot_ref(ax, ref.format("N"), "C1")
    ax.set_xlabel("membrane potential [mV]")
    ax.set_ylabel("current density [pA/pF]")
    ax.set_xlim(-80, 60)
    ax.set_ylim(-1, 3)
    ax.grid(True)
    save_plot(f, "naca_inada2009_S6B", postfix=postfix)


def naca_kurata2002_17ur(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(data["vc.v"] * 1000, data["naca.i"] / 32e-12)
    plot_ref(ax, ref, "C0")
    ax.set_xlabel("membrane potential [mV]")
    ax.set_ylabel("current density [pA/pF]")
    ax.set_xlim(-100, 50)
    ax.set_ylim(-1.5, 2.5)
    ax.grid(True)
    save_plot(f, "naca_kurata2002_17ur", postfix=postfix)


def naca_matsuoka1992_19(fname, ref, postfix=""):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 8), tight_layout=True)
    subplots = f.subplots(2, 2, sharex="all")
    titles = {
        "a": "A ($[Na^+]_i = 25$ mM, $[Na^+]_o = 0$ mM,"
             + "\n $[Ca^{2+}]_o = 8$ mM, $k_{NaCa} = 1$ nA)",
        "b": "B ($[Na^+]_i = 100$ mM, $[Na^+]_o = 0$ mM,"
             + "\n $[Ca^{2+}]_o = 8$ mM, $k_{NaCa} = 0.25$ nA)",
        "c": "C ($[Na^+]_o = 150$ mM, $[Ca^{2+}]_o = 0$ mM,"
             + "\n$[Ca^{2+}]_{sub} = 3$ μM, $k_{NaCa} = 0.33$ nA)",
        "d": "D ($[Na^+]_o = 150$ mM, $[Ca^{2+}]_o = 0$ mM,"
             + "\n $[Ca^{2+}]_{sub} = 1.08$ mM, $k_{NaCa} = 0.5$ nA)"
    }
    labels = {
        "a1": "$[Ca^{2+}]_{sub} = 0$ μM",
        "a2": "$[Ca^{2+}]_{sub} = 16$ μM",
        "a3": "$[Ca^{2+}]_{sub} = 234$ μM",
        "b1": "$[Ca^{2+}]_{sub} = 0$ μM",
        "b2": "$[Ca^{2+}]_{sub} = 64$ μM",
        "b3": "$[Ca^{2+}]_{sub} = 1080$ μM",
        "c1": "$[Na^+]_i = 0$ mM",
        "c2": "$[Na^+]_i = 25$ mM",
        "c3": "$[Na^+]_i = 50$ mM",
        "d1": "$[Na^+]_i = 0$ mM",
        "d2": "$[Na^+]_i = 25$ mM",
        "d3": "$[Na^+]_i = 100$ mM"
    }
    for c, ax in zip("abcd", subplots.flatten()):
        for i in range(1, 4):
            ax.plot(
                data["{}{}.vc.v".format(c, i)] * 1000,
                data["{}{}.naca.i".format(c, i)] * 1e12,
                label=labels[c+str(i)]
            )
        ax.set_title(titles[c])
    for ax in subplots.flatten():
        ax.set_xlabel("membrane potential [mV]")
        ax.set_xlim(-140, 120)
        ax.set_ylabel("current [pA]")
        ax.grid(True)
        ax.legend()
    for i, cai in enumerate([0, 16, 234]):
        plot_ref(subplots[0][0], ref.format("A", "Cai_{}".format(cai)), "C{}".format(i))
    for i, cai in enumerate([0, 64, 1081]):
        plot_ref(subplots[0][1], ref.format("B", "Cai_{}".format(cai)), "C{}".format(i))
    for i, nai in enumerate([0, 25, 50]):
        plot_ref(subplots[1][0], ref.format("C", "Nai_{}".format(nai)), "C{}".format(i))
    for i, nai in enumerate([0, 25, 100]):
        plot_ref(subplots[1][1], ref.format("D", "Nai_{}".format(nai)), "C{}".format(i))

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
    d_hold = 0.3     # holding duration
    d_pulse = 0.001  # pulse duration
    d_cycle = d_hold + d_pulse  # cycle duration
    t_off = 1  # offset from begining of simulation (plot next pulse)
    # start 50 ms before pulse
    t_start = np.ceil(t_off/d_cycle) * d_cycle - d_pulse - 0.05
    d = 0.2  # full width of plot = 200 ms
    t_spon_const = 0.323  # start of spontaneous AP in constant case
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
        axv.grid(True)

    def axc_settings(axc):
        axc.set_ylim(0, 1)
        axc.set_xlim(0, 0.2)
        axc.set_ylabel("concentration [μM]")
        axc.set_xlabel("time [s]")
        axc.legend(loc="best")
        axc.grid(True)

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
        ax.grid(True)
    save_plot(f, "ca_custom", postfix=postfix)


def plot_ca(data, ax, cons):
    for k in cons:
        label = r"$[Ca^{2+}]_\text{%s}$" % k
        ax.plot(data["time"] * 1000, data["ca_{}.con".format(k)], label=label)
    ax.grid(True)
    ax.set_xlabel("time [ms]")
    ax.set_ylabel("concentration [mM]")


def ca_custom_buffer(fname_buff, fname_buff2, postfix=""):
    data_buff = pd.read_csv(fname_buff, delimiter=",")
    data_buff2 = pd.read_csv(fname_buff2, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax1, ax2 = f.subplots(1, 2)
    ax1.set_title("Buffer")
    ax2.set_title("Buffer2")
    plot_ca(data_buff, ax1, ["cyto"])
    plot_ca(data_buff2, ax2, ["cyto"])
    save_plot(f, "ca_custom_buffer", postfix=postfix)


def ca_custom_transport(fname_simple, fname_mm, fname_hl, postfix=""):
    data_simple = pd.read_csv(fname_simple, delimiter=",")
    data_mm = pd.read_csv(fname_mm, delimiter=",")
    data_hl = pd.read_csv(fname_hl, delimiter=",")
    f = plt.Figure(figsize=(8, 8), tight_layout=True)
    (ax1, ax2), (ax3, ax4) = f.subplots(2, 2)
    ax1.set_title("Diffusion")
    ax2.set_title("SERCAPump")
    ax3.set_title("RyanodineReceptor")
    plot_ca(data_simple, ax1, ["cyto", "sub"])
    plot_ca(data_mm, ax2, ["cyto", "nsr"])
    plot_ca(data_hl, ax3, ["jsr", "sub"])
    save_plot(f, "ca_custom_transport", postfix=postfix)


def plot_all(datadir, postfix=""):
    refdir = "data"
    na_lindblad1996_2A(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.SodiumChannelSteady_res.csv"),
        os.path.join(refdir, "reconstruct_na_lindblad1996_2A_orig_{}_total.csv"),
        postfix=postfix
    )
    na_lindblad1996_2B(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.SodiumChannelIV_res.csv"),
        os.path.join(refdir, "reconstruct_na_lindblad1996_2B_orig_iv.csv"),
        postfix=postfix
    )
    na_lindblad1996_2CDE(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.SodiumChannelSteady_res.csv"),
        os.path.join(refdir, "reconstruct_na_lindblad1996_2{}_orig_tau.csv"),
        postfix=postfix
    )
    k1_lindblad1996_8(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.InwardRectifierLin_res.csv"),
        os.path.join(refdir, "reconstruct_k1_lindblad1996_8_orig_iv.csv"),
        postfix=postfix
    )
    ghkFlux(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.GHKFlux_res.csv"),
        postfix=postfix
    )
    cal_inada2009_S1AB(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.LTypeCalciumSteady_res.csv"),
        os.path.join(refdir, "reconstruct_cal_inada2009_S1{}.csv"),
        postfix=postfix
    )
    cal_inada2009_S1CD(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.LTypeCalciumSteady_res.csv"),
        os.path.join(refdir, "reconstruct_cal_inada2009_S1{}_orig_tau.csv"),
        postfix=postfix
    )
    cal_inada2009_S1E(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.LTypeCalciumIV_res.csv"),
        os.path.join(datadir, "InaMo.Examples.ComponentTests.LTypeCalciumIVN_res.csv"),
        os.path.join(refdir, "reconstruct_cal_inada2009_S1E_orig_{}.csv"),
        postfix=postfix
    )
    cal_inada2009_S1H(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.LTypeCalciumStep_res.csv"),
        os.path.join(refdir, "reconstruct_cal_inada2009_S1H_orig_I_cal.csv"),
        postfix=postfix
    )
    to_inada2009_S2AB(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.TransientOutwardSteady_res.csv"),
        os.path.join(refdir, "reconstruct_to_inada2009_S2{}.csv"),
        postfix=postfix
    )
    to_inada2009_S2CD(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.TransientOutwardSteady_res.csv"),
        os.path.join(refdir, "reconstruct_to_inada2009_S2{}_orig_inact_tau.csv"),
        postfix=postfix
    )
    to_inada2009_S2E(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.TransientOutwardIV_res.csv"),
        os.path.join(refdir, "reconstruct_to_inada2009_S2E_orig_{}mV.csv"),
        postfix=postfix
    )
    to_inada2009_S2F(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.TransientOutwardIV_res.csv"),
        os.path.join(refdir, "reconstruct_to_inada2009_S2F_orig_iv.csv"),
        postfix=postfix
    )
    kr_inada2009_S3A(
        os.path.join(
            datadir, "InaMo.Examples.ComponentTests.RapidDelayedRectifierSteady_res.csv"),
        os.path.join(refdir, "reconstruct_kr_inada2009_S3A_orig_act_steady.csv"),
        postfix=postfix
    )
    kr_inada2009_S3B(
        os.path.join(
            datadir, "InaMo.Examples.ComponentTests.RapidDelayedRectifierSteady_res.csv"),
        os.path.join(refdir, "reconstruct_kr_inada2009_S3B_orig_act_tau.csv"),
        postfix=postfix
    )
    kr_inada2009_S3CD(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.RapidDelayedRectifierIV_res.csv"),
        os.path.join(refdir, "reconstruct_kr_inada2009_S3{}_orig_iv.csv"),
        postfix=postfix
    )
    kr_inada2009_S3E(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.RapidDelayedRectifierIV_res.csv"),
        os.path.join(refdir, "reconstruct_kr_inada2009_S3E{}_orig_I_Kr.csv"),
        postfix=postfix
    )
    f_inada2009_S4A(
        os.path.join(
            datadir, "InaMo.Examples.ComponentTests.HyperpolarizationActivatedSteady_res.csv"),
        os.path.join(refdir, "reconstruct_f_inada2009_S4A_orig_act_steady.csv"),
        postfix=postfix
    )
    f_inada2009_S4B(
        os.path.join(
            datadir, "InaMo.Examples.ComponentTests.HyperpolarizationActivatedSteady_res.csv"),
        os.path.join(refdir, "reconstruct_f_inada2009_S4B_orig_act_tau.csv"),
        postfix=postfix
    )
    f_inada2009_S4C(
        os.path.join(
            datadir, "InaMo.Examples.ComponentTests.HyperpolarizationActivatedIV_res.csv"),
        os.path.join(refdir, "reconstruct_f_inada2009_S4C_orig_iv.csv"),
        postfix=postfix
    )
    f_inada2009_S4D(
        os.path.join(
            datadir, "InaMo.Examples.ComponentTests.HyperpolarizationActivatedIV_res.csv"),
        os.path.join(refdir, "reconstruct_f_inada2009_S4D_orig_I_f_{}.csv"),
        postfix=postfix
    )
    st_inada2009_S5A(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.SustainedInwardSteady_res.csv"),
        os.path.join(refdir, "reconstruct_st_inada2009_S5A_orig_steady.csv"),
        postfix=postfix
    )
    st_inada2009_S5_tau(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.SustainedInwardSteady_res.csv"),
        postfix=postfix
    )
    st_inada2009_S5B(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.SustainedInwardIV_res.csv"),
        os.path.join(refdir, "reconstruct_st_inada2009_S5B_orig_{}mV.csv"),
        postfix=postfix
    )
    st_inada2009_S5C(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.SustainedInwardIV_res.csv"),
        os.path.join(refdir, "reconstruct_st_inada2009_S5C_orig_iv.csv"),
        postfix=postfix
    )
    st_kurata2002_4bl(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.SustainedInwardIVKurata_res.csv"),
        os.path.join(refdir, "reconstruct_st_kurata2002_4bl_orig_{}mV.csv"),
        postfix=postfix
    )
    st_kurata2002_4br(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.SustainedInwardIVKurata_res.csv"),
        os.path.join(refdir, "reconstruct_st_kurata2002_4br_orig_iv.csv"),
        postfix=postfix
    )
    nak_demir1994_12(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.SodiumPotassiumPumpLin_res.csv"),
        os.path.join(refdir, "reconstruct_nak_demir1994_12_orig_I_NaK+X.csv"),
        postfix=postfix
    )
    naca_inada2009_S6A(
        os.path.join(
            datadir, "InaMo.Examples.ComponentTests.SodiumCalciumExchangerRampInada_res.csv"),
        os.path.join(refdir, "reconstruct_naca_inada2009_S6A_orig_I_NaCa_{}.csv"),
        postfix=postfix
    )
    naca_inada2009_S6B(
        os.path.join(
            datadir, "InaMo.Examples.ComponentTests.SodiumCalciumExchangerRampInada_res.csv"),
        os.path.join(refdir, "reconstruct_naca_inada2009_S6B_orig_iv_{}.csv"),
        postfix=postfix
    )
    naca_matsuoka1992_19(
        os.path.join(
            datadir,
            "InaMo.Examples.ComponentTests.SodiumCalciumExchangerLinMatsuoka_res.csv"
        ),
        os.path.join(refdir, "reconstruct_naca_matsuoka1992_19{}_orig_I_NaCa_{}.csv"),
        postfix=postfix
    )
    naca_kurata2002_17ur(
        os.path.join(
            datadir, "InaMo.Examples.ComponentTests.SodiumCalciumExchangerLinKurata_res.csv"),
        os.path.join(refdir, "reconstruct_naca_kurata2002_17ur_orig_I_NaCa.csv"),
        postfix=postfix
    )
    full_inada2009_S7(
        os.path.join(datadir, "InaMo.Examples.FullCell.AllCellsC_res.csv"),
        os.path.join(datadir, "InaMo.Examples.FullCell.AllCells_res.csv"),
        postfix=postfix,
        refdir="data/reconstruct_full_cells_S7"
    )
    ca_custom(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.CaHandlingApprox_res.csv"),
        os.path.join(datadir, "InaMo.Examples.FullCell.FullCellSpon_res.csv"),
        postfix=postfix
    )
    ca_custom_buffer(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.CaBuffer_res.csv"),
        os.path.join(datadir, "InaMo.Examples.ComponentTests.CaBuffer2_res.csv"),
        postfix=postfix
    )
    ca_custom_transport(
        os.path.join(datadir, "InaMo.Examples.ComponentTests.CaDiffusion_res.csv"),
        os.path.join(datadir, "InaMo.Examples.ComponentTests.CaSERCA_res.csv"),
        os.path.join(datadir, "InaMo.Examples.ComponentTests.CaRyanodineReceptor_res.csv"),
        postfix=postfix
    )

if __name__ == "__main__":
    plot_all("out")
    plot_all("regRefData", postfix="ref")
