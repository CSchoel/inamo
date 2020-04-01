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


def lindblad1997_2A(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [
        ("m3_steady", "activation ($m^3$)"),
        ("h_steady", "inactivation($h_1$ and $h_2$)")
    ])
    ax.set_xlim(-90, 100)
    save_plot(f, "lindblad1997_2A")


def lindblad1997_2B(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(ax, data, x="vc.vs_peak", y="cd", normalize=False, factor=1)
    ax.set_xlim(-90, 80)
    save_plot(f, "lindblad1997_2B")


def lindblad1997_2CDE(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    subplots = f.subplots(1, 3, sharex="all")
    plot_tau(subplots, data, [
        ("tau_m", r"$\tau_m$"), ("tau_h1", r"$\tau_{h_1}$"),
        ("tau_h2", r"$\tau_{h_2}$")
    ])
    subplots[0].set_xlim(-90, 100)
    save_plot(f, "lindblad1997_2C-E")


def lindblad1997_8(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    v = data["vc.v"]
    i = data["vc.i"]
    i_max = data["i_max"].iloc[-1]
    ax.plot(v * 1000, i / i_max)
    ax.set_xlim(-100, 45)
    ax.set_ylim(-0.5, 1.1)
    ax.set_xlabel("potential [mV]")
    ax.set_ylabel("relative current")
    save_plot(f, "lindblad1997_8")


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


def inada2009_S1AB(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [
        ("act_steady", "activation (AN, NH)"),
        ("act_steady_n", "activation (N)"),
        ("inact_steady", "inactivation")
    ])
    ax.set_xlim(-80, 60)
    save_plot(f, "inada2009_S1AB")


def inada2009_S1CD(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    subplots = f.subplots(1, 3, sharex="all")
    plot_tau(subplots, data, [
        ("inact_tau_fast", "inactivation (fast)"),
        ("inact_tau_slow", "inactivation (slow)"),
        ("act_tau", "activation")
    ])
    subplots[0].set_xlim(-80, 60)
    save_plot(f, "inada2009_S1CD")


def inada2009_S1E(fname_nh_an, fname_n):
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
    save_plot(f, "inada2009_S1E")


def inada2009_S1H(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(data["time"] * 1000, data["vc.i"] * 1e12)
    ax.set_ylabel("current [pA]")
    ax.set_xlim(990, 1150)
    ax.set_xlabel("time [ms]")
    save_plot(f, "inada2009_S1H")


def inada2009_S2AB(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [
        ("act_steady", "activation"),
        ("inact_steady", "inactivation")
    ])
    ax.set_xlim(-80, 60)
    save_plot(f, "inada2009_S2AB")


def inada2009_S2CD(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    subplots = f.subplots(1, 3, sharex="all")
    plot_tau(subplots, data, [
        ("inact_tau_fast", "inactivation (fast)"),
        ("inact_tau_slow", "inactivation (slow)"),
        ("act_tau", "activation")
    ])
    subplots[0].set_xlim(-120, 60)
    save_plot(f, "inada2009_S2CD")


def inada2009_S2E(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_i(ax, data, [-10, 0, 20, 40], after=0.5)
    save_plot(f, "inada2009_S2E")


def inada2009_S2F(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(ax, data, x="vc.vs_peak", y="vc.is_peak")
    ax.set_xlim(-60, 60)
    save_plot(f, "inada2009_S2F")


def inada2009_S3A(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [
        ("act_steady", "activation"),
        ("inact_steady", "inactivation")
    ])
    ax.set_xlim(-80, 60)
    save_plot(f, "inada2009_S3A")


def inada2009_S3B(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    subplots = f.subplots(1, 3, sharex="all")
    plot_tau(subplots, data, [
        ("act_tau_fast", "activation (fast)"),
        ("act_tau_slow", "activation (slow)"),
        ("inact_tau", "inactivation")
    ])
    subplots[0].set_xlim(-120, 80)
    save_plot(f, "inada2009_S3B")


def inada2009_S3CD(fname):
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
    save_plot(f, "inada2009_S3CD")


def inada2009_S3E(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(6, 4), tight_layout=True)
    subplots = f.subplots(3, 1, sharex="all", sharey="all")
    plot_i(subplots, data, [-10, 10, 30], after=1)
    subplots[0].set_xlim(0, 1000)
    subplots[0].set_yticks([0, 20, 40, 60])
    subplots[0].set_ylim(0, 60)
    save_plot(f, "inada2009_S3E")


def inada2009_S4A(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [("act_steady", "activation")])
    ax.set_xlim(-120, -40)
    save_plot(f, "inada2009_S4A")


def inada2009_S4B(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_tau(ax, data, [("act_tau", "activation")])
    ax.set_xlim(-120, -40)
    save_plot(f, "inada2009_S4B")


def inada2009_S4C(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(
        ax, data, x="vc.vs_end", y="vc.is_end",
        normalize=False, factor=1/29e-12
    )
    ax.set_xlim(-120, -50)
    save_plot(f, "inada2009_S4C")


def inada2009_S4D(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(6, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_i(ax, data, np.arange(-120, -50, 10), after=6)
    ax.set_ylim(-90, 0)
    ax.set_xlim(0, 6000)
    save_plot(f, "inada2009_S4D")


def inada2009_S5A(fname):
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
    save_plot(f, "inada2009_S5A")


def inada2009_S5_tau(fname):
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
    save_plot(f, "inada2009_S5_tau")


def inada2009_S5B(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(6, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_i(ax, data, np.arange(-80, 70, 10), before=0.05, after=0.85)
    # ax.set_ylim(-90, 0)
    ax.set_xlim(-50, 850)
    save_plot(f, "inada2009_S5B")


def inada2009_S5C(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(
        ax, data, x="vc.vs_peak", y="vc.is_peak",
        normalize=False, factor=1/29e-12
    )
    ax.set_xlim(-80, 60)
    save_plot(f, "inada2009_S5C")


def kurata2002_4bl(fname):
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
    save_plot(f, "kurata_2002_4bl")


def kurata2002_4br(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(
        ax, data, x="vc.vs_peak", y="vc.is_peak",
        normalize=False, factor=1/32e-12
    )
    ax.set_xlim(-80, 60)
    save_plot(f, "kurata_2002_4br")


def demir1994_12(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(data["vc.v"] * 1000, data["vc.i"] * 1e12)
    ax.set_xlim(-60, 40)
    save_plot(f, "demir1994_12")


if __name__ == "__main__":
    lindblad1997_2A("out/InaMo.Examples.SodiumChannelSteady_res.csv")
    lindblad1997_2B("out/InaMo.Examples.SodiumChannelIV_res.csv")
    lindblad1997_2CDE("out/InaMo.Examples.SodiumChannelSteady_res.csv")
    lindblad1997_8("out/InaMo.Examples.InwardRectifierLin_res.csv")
    ghkFlux("out/InaMo.Examples.GHKFlux_res.csv")
    inada2009_S1AB("out/InaMo.Examples.LTypeCalcium_res.csv")
    inada2009_S1CD("out/InaMo.Examples.LTypeCalcium_res.csv")
    inada2009_S1E(
        "out/InaMo.Examples.LTypeCalciumIV_res.csv",
        "out/InaMo.Examples.LTypeCalciumIVN_res.csv"
    )
    inada2009_S1H("out/InaMo.Examples.LTypeCalciumStep_res.csv")
    inada2009_S2AB("out/InaMo.Examples.TransientOutwardSteady_res.csv")
    inada2009_S2CD("out/InaMo.Examples.TransientOutwardSteady_res.csv")
    inada2009_S2E("out/InaMo.Examples.TransientOutwardIV_res.csv")
    inada2009_S2F("out/InaMo.Examples.TransientOutwardIV_res.csv")
    inada2009_S3A("out/InaMo.Examples.RapidDelayedRectifierSteady_res.csv")
    inada2009_S3B("out/InaMo.Examples.RapidDelayedRectifierSteady_res.csv")
    inada2009_S3CD("out/InaMo.Examples.RapidDelayedRectifierIV_res.csv")
    inada2009_S3E("out/InaMo.Examples.RapidDelayedRectifierIV_res.csv")
    inada2009_S4A(
        "out/InaMo.Examples.HyperpolarizationActivatedSteady_res.csv"
    )
    inada2009_S4B(
        "out/InaMo.Examples.HyperpolarizationActivatedSteady_res.csv"
    )
    inada2009_S4C("out/InaMo.Examples.HyperpolarizationActivatedIV_res.csv")
    inada2009_S4D("out/InaMo.Examples.HyperpolarizationActivatedIV_res.csv")
    inada2009_S5A("out/InaMo.Examples.SustainedInwardSteady_res.csv")
    inada2009_S5_tau("out/InaMo.Examples.SustainedInwardSteady_res.csv")
    inada2009_S5B("out/InaMo.Examples.SustainedInwardIV_res.csv")
    inada2009_S5C("out/InaMo.Examples.SustainedInwardIV_res.csv")
    kurata2002_4bl("out/InaMo.Examples.SustainedInwardIVKurata_res.csv")
    kurata2002_4br("out/InaMo.Examples.SustainedInwardIVKurata_res.csv")
    demir1994_12("out/InaMo.Examples.SodiumPotassiumPumpLin_res.csv")
