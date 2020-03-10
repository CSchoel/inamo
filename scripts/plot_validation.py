import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os


def lindblad1997_2A(fname, v_inc=0.005, hold_period=2):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    time = data["time"]
    n = int(np.ceil(time.iloc[-1]/hold_period))
    tval = np.arange(n) * hold_period + 0.001
    m3 = np.interp(tval, time, data["m3_steady"])
    v_stim = np.interp(tval, time, data["vc.v_stim"])
    h_total = np.interp(tval, time, data["h_steady"])
    ax.plot(v_stim * 1000, m3, label="activation ($m^3$)")
    ax.plot(v_stim * 1000, h_total, label="inactivation ($h_1$ + $h_2$)")
    ax.set_xlim(-90, 100)
    ax.set_xlabel("holding potential [mV]")
    ax.set_ylabel("ratio of open gates")
    ax.legend(loc="best")
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/lindblad1997_2A.pdf")
    f.savefig("plots/lindblad1997_2A.png")


def lindblad1997_2B(fname, hold_period=2, v_inc=0.005):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    time = data["time"]
    n = int(np.ceil(time.iloc[-1]/hold_period))
    tval = np.arange(n-2) * hold_period + 2 * hold_period + 0.001
    cd = np.interp(tval, time, data["cd"])
    v_pulse = np.interp(tval, time, data["vc.v_pulse"])
    ax.plot((v_pulse - v_inc) * 1000, cd)
    ax.set_xlim(-90, 80)
    ax.set_xlabel("pulse potential [mV]")
    ax.set_ylabel("peak current density [A/F]")
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/lindblad1997_2B.pdf")
    f.savefig("plots/lindblad1997_2B.png")


def lindblad1997_2CDE(fname, hold_period=2):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax1, ax2, ax3 = f.subplots(1, 3, sharex="all")
    time = data["time"]
    n = int(np.ceil(time.iloc[-1]/hold_period))
    tval = np.arange(n) * hold_period + 0.001
    tau_m = np.interp(tval, time, data["tau_m"])
    tau_h1 = np.interp(tval, time, data["tau_h1"])
    tau_h2 = np.interp(tval, time, data["tau_h2"])
    v_stim = np.interp(tval, time, data["vc.v_stim"])
    ax1.plot(v_stim * 1000, tau_m * 1000000)
    ax2.plot(v_stim * 1000, tau_h1 * 1000)
    ax3.plot(v_stim * 1000, tau_h2 * 1000)
    ax1.set_ylabel("time constant [$\\mu$s]")
    ax2.set_ylabel("time constant [ms]")
    ax3.set_ylabel("time constant [ms]")
    for ax in [ax1, ax2, ax3]:
        ax.set_xlim(-90, 100)
        ax.set_xlabel("holding potential [mV]")
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    ax1.set_title(r"$\tau_m$")
    ax2.set_title(r"$\tau_{h_1}$")
    ax3.set_title(r"$\tau_{h_2}$")
    f.savefig("plots/lindblad1997_2C-E.pdf")
    f.savefig("plots/lindblad1997_2C-E.png")


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
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/lindblad1997_8.pdf")
    f.savefig("plots/lindblad1997_8.png")


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
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/ghkFlux.pdf")
    f.savefig("plots/ghkFlux.png")


def inada2009_S1AB(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(data["v"] * 1000, data["act_steady"], label="activation (AN, NH)")
    ax.plot(data["v"] * 1000, data["act_steady_n"], label="activation (N)")
    ax.plot(data["v"] * 1000, data["inact_steady"], label="inactivation")
    ax.legend(loc="best")
    ax.set_xlabel("holding potential [mV]")
    ax.set_ylabel("steady state value")
    ax.set_xlim(-80, 60)
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S1AB.pdf")
    f.savefig("plots/inada2009_S1AB.png")


def inada2009_S1CD(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax1, ax2 = f.subplots(1, 2, sharex="all")
    ax1.plot(data["v"] * 1000, data["inact_tau_fast"] * 1000)
    ax2.plot(data["v"] * 1000, data["inact_tau_slow"] * 1000)
    ax1.set_xlabel("holding potential [mV]")
    ax1.set_ylabel("time constant [ms]")
    for ax in [ax1, ax2]:
        ax.set_xlim(-80, 60)
        ax.set_xlabel("holding potential [mV]")
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S1CD.pdf")
    f.savefig("plots/inada2009_S1CD.png")
    print("foo")


if __name__ == "__main__":
    lindblad1997_2A("out/InaMo.Examples.SodiumChannelSteady_res.csv")
    lindblad1997_2B("out/InaMo.Examples.SodiumChannelIV_res.csv")
    lindblad1997_2CDE("out/InaMo.Examples.SodiumChannelSteady_res.csv")
    lindblad1997_8("out/InaMo.Examples.InwardRectifierLin_res.csv")
    ghkFlux("out/InaMo.Examples.GHKFlux_res.csv")
    inada2009_S1AB("out/InaMo.Examples.LTypeCalcium_res.csv")
    inada2009_S1CD("out/InaMo.Examples.LTypeCalcium_res.csv")
