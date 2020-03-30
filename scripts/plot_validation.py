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


def plot_i(subplots, data, amplitudes, before=0, after=1):
    single = isinstance(subplots, Axes)
    if single:
        subplots = [subplots] * len(amplitudes)
    for ax, v in zip(subplots, amplitudes):
        is_pulse = data["vc.v"] == data["vc.v_pulse"]
        start_pulse = np.argmax(is_pulse and np.abs(data["vc.v"] - v) < 1e-6)
        start = np.argmax(data["time"] >= data["time"][start_pulse] - before)
        end = np.argmax(data["time"] >= data["time"][start_pulse] + after)
        xvals = (data["time"][start:end] - data["time"][start_pulse]) * 1000
        yvals = data["vc.i"][start:end] * 1e12
        ax.plot(xvals, yvals, label="{} mV".format(v))
        ax.set_xlabel("time [ms]")
        ax.set_ylabel("current [pA]")
        if not single:
            ax.set_title("{} mV")


def lindblad1997_2A(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_steady(ax, data, [
        ("m3_steady", "activation ($m^3$)"),
        ("h_steady", "inactivation($h_1$ and $h_2$)")
    ])
    ax.set_xlim(-90, 100)
    ax.legend(loc="best")
    save_plot(f, "lindblad1997_2A")


def lindblad1997_2B(fname, hold_period=2, v_inc=0.005):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(ax, data, x="vc.vs_peak", y="cd", normalize=False, factor=1)
    ax.set_xlim(-90, 80)
    save_plot(f, "lindblad1997_2B")


def lindblad1997_2CDE(fname, hold_period=2):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    subplots = f.subplots(1, 3, sharex="all")
    plot_tau(subplots, data, [
        ("tau_m", r"$\tau_m$"), ("tau_h1", r"$\tau_{h_1}$"),
        ("tau_m", r"$\tau_{h_2}$")
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
    ax1, ax2, ax3 = f.subplots(1, 3, sharex="all")
    ax1.plot(data["v"] * 1000, data["inact_tau_fast"] * 1000)
    ax2.plot(data["v"] * 1000, data["inact_tau_slow"] * 1000)
    ax3.plot(data["v"] * 1000, data["act_tau"] * 1000)
    ax1.set_ylabel("time constant [ms]")
    for ax in [ax1, ax2, ax3]:
        ax.set_xlim(-80, 60)
        ax.set_xlabel("holding potential [mV]")
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S1CD.pdf")
    f.savefig("plots/inada2009_S1CD.png")


def inada2009_S1E(fname_nh_an, fname_n, hold_period=5, v_inc=0.005):
    data_an_nh = pd.read_csv(fname_nh_an, delimiter=",")
    data_n = pd.read_csv(fname_n, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    na_hn = plot_iv(ax, data_an_nh, hold_period=hold_period, v_inc=v_inc, field="vc.is_peak")
    n = plot_iv(ax, data_n, hold_period=hold_period, v_inc=v_inc, field="vc.is_peak")
    ax.legend([na_hn, n], ["NA and NH cells", "N cells"], loc="best")
    ax.set_xlim(-60, 80)
    ax.set_xlabel("pulse potential [mV]")
    ax.set_ylabel("normalized current [1]")
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S1E.pdf")
    f.savefig("plots/inada2009_S1E.png")


def inada2009_S1H(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(data["time"] * 1000, data["vc.i"] * 1e12)
    ax.set_ylabel("current [pA]")
    ax.set_xlim(990, 1150)
    ax.set_xlabel("time [ms]")
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S1H.pdf")
    f.savefig("plots/inada2009_S1H.png")


def inada2009_S2AB(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(data["v"] * 1000, data["act_steady"], label="activation")
    ax.plot(data["v"] * 1000, data["inact_steady"], label="inactivation")
    ax.legend(loc="best")
    ax.set_xlabel("holding potential [mV]")
    ax.set_ylabel("steady state value")
    ax.set_xlim(-80, 60)
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S2AB.pdf")
    f.savefig("plots/inada2009_S2AB.png")


def inada2009_S2CD(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax1, ax2, ax3 = f.subplots(1, 3, sharex="all")
    ax1.plot(data["v"] * 1000, data["inact_tau_fast"] * 1000)
    ax1.set_xticks([-120, -80, -40, 0, 40, 80])
    ax1.set_ylim(0, 250)
    ax2.plot(data["v"] * 1000, data["inact_tau_slow"] * 1000)
    ax3.plot(data["v"] * 1000, data["act_tau"] * 1000)
    ax1.set_ylabel("time constant [ms]")
    for ax in [ax1, ax2, ax3]:
        ax.set_xlim(-120, 60)
        ax.set_xlabel("holding potential [mV]")
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S2CD.pdf")
    f.savefig("plots/inada2009_S2CD.png")


def inada2009_S2E(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    for v in [-10, 0, 20, 40]:
        start = np.argmax(data["vc.v"] >= v / 1000)
        end = np.argmax(data["time"] >= data["time"][start] + 0.5)
        xvals = (data["time"][start:end] - data["time"][start]) * 1000
        ax.plot(xvals, data["vc.i"][start:end] * 1e12, label="%d mV" % v)
    ax.set_xlabel("time [ms]")
    ax.set_ylabel("current [pA]")
    ax.legend(loc="best")
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S2E.pdf")
    f.savefig("plots/inada2009_S2E.png")


def inada2009_S2F(fname, hold_period=4, v_inc=0.005):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(ax, data, hold_period=hold_period, v_inc=v_inc, field="vc.is_peak")
    ax.set_xlim(-60, 60)
    ax.set_xlabel("pulse potential [mV]")
    ax.set_ylabel("normalized current [1]")
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S2F.pdf")
    f.savefig("plots/inada2009_S2F.png")


def inada2009_S3A(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(data["v"] * 1000, data["act_steady"], label="activation")
    ax.plot(data["v"] * 1000, data["inact_steady"], label="inactivation")
    ax.set_xlabel("holding potential [mV]")
    ax.set_ylabel("steady state value")
    ax.set_xlim(-80, 60)
    ax.legend(loc="best")
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S3A.pdf")
    f.savefig("plots/inada2009_S3A.png")


def inada2009_S3B(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax1, ax2, ax3 = f.subplots(1, 3, sharex="all")
    ax1.plot(data["v"] * 1000, data["act_tau_fast"] * 1000)
    ax2.plot(data["v"] * 1000, data["act_tau_slow"] * 1000)
    ax3.plot(data["v"] * 1000, data["inact_tau"] * 1000)
    ax1.set_ylabel("time constant [ms]")
    for ax in [ax1, ax2, ax3]:
        ax.set_xlim(-120, 80)
        ax.set_xlabel("holding potential [mV]")
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S3B.pdf")
    f.savefig("plots/inada2009_S3B.png")


def inada2009_S3CD(fname, hold_period=5, v_inc=0.005):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    p = plot_iv(
        ax, data, hold_period=hold_period, v_inc=v_inc, field="vc.is_peak"
    )
    t = plot_iv(
        ax, data, hold_period=hold_period, v_inc=v_inc, field="vc.is_tail"
    )
    e = plot_iv(
        ax, data, hold_period=hold_period, v_inc=v_inc, field="vc.is_end"
    )
    ax.set_xlim(-40, 60)
    ax.set_xlabel("pulse potential [mV]")
    ax.set_ylabel("normalized current [1]")
    ax.legend(
        [p, t, e], ["pulse peak", "tail peak", "end of pulse"], loc="best"
    )
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S3CD.pdf")
    f.savefig("plots/inada2009_S3CD.png")


def inada2009_S3E(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(6, 4), tight_layout=True)
    ax1, ax2, ax3 = f.subplots(3, 1, sharex="all", sharey="all")
    for ax, v in zip([ax1, ax2, ax3], [-10, 10, 30]):
        start = np.argmax(data["vc.v"] >= v / 1000)
        end = np.argmax(data["time"] >= data["time"][start] + 1)
        xvals = (data["time"][start:end] - data["time"][start]) * 1000
        ax.plot(xvals, data["vc.i"][start:end] * 1e12, label="%d mV" % v)
        ax.set_xlabel("time [ms]")
        ax.set_ylabel("current [pA]")
    ax1.set_ylim(0, 60)
    ax1.set_xlim(0, 1000)
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S3E.pdf")
    f.savefig("plots/inada2009_S3E.png")


def inada2009_S4A(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(data["v"] * 1000, data["act_steady"], label="activation")
    ax.set_xlabel("holding potential [mV]")
    ax.set_ylabel("steady state value")
    ax.set_xlim(-120, -40)
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S4A.pdf")
    f.savefig("plots/inada2009_S4A.png")


def inada2009_S4B(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(4, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(data["v"] * 1000, data["act_tau"] * 1000)
    ax.set_ylabel("time constant [ms]")
    ax.set_xlabel("holding potential [mV]")
    ax.set_xlim(-120, -40)
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S4B.pdf")
    f.savefig("plots/inada2009_S4B.png")


def inada2009_S4C(fname, hold_period=20, v_inc=0.005):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(
        ax, data, hold_period=hold_period, v_inc=v_inc, field="vc.is_end",
        normalize=False, factor=1/29e-12
    )
    ax.set_xlim(-120, -50)
    ax.set_xlabel("pulse potential [mV]")
    ax.set_ylabel("current density [pA/pF]")
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S4C.pdf")
    f.savefig("plots/inada2009_S4C.png")


def inada2009_S4D(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(6, 4), tight_layout=True)
    ax = f.add_subplot()
    for v in [-120, -110, -100, -90, -80, -70, -60]:
        start = np.argmax(np.abs(data["vc.v"] - v / 1000) < 1e-6)
        end = np.argmax(data["time"] >= data["time"][start] + 6)
        xvals = (data["time"][start:end] - data["time"][start]) * 1000
        ax.plot(xvals, data["vc.i"][start:end] * 1e12, label="%d mV" % v)
    ax.set_xlabel("time [ms]")
    ax.set_ylabel("current [pA]")
    ax.set_ylim(-90, 0)
    ax.set_xlim(0, 6000)
    ax.legend(loc="best")
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S4D.pdf")
    f.savefig("plots/inada2009_S4D.png")


def inada2009_S5A(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    ax.plot(data["v"] * 1000, data["act_steady"], label="activation")
    ax.plot(data["v"] * 1000, data["inact_steady"], label="inactivation")
    ax.plot(data["v"] * 1000, data["act_steady2"], "r--", label="act test")
    ax.plot(data["v"] * 1000, data["inact_steady2"], "r--", label="inact test")
    ax.set_xlabel("holding potential [mV]")
    ax.set_ylabel("steady state value")
    ax.set_xlim(-80, 60)
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S5A.pdf")
    f.savefig("plots/inada2009_S5A.png")


def inada2009_S5_tau(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax1, ax2 = f.subplots(1, 2, sharex="all")
    ax1.plot(data["v"] * 1000, data["act_tau"] * 1000)
    ax2.plot(data["v"] * 1000, data["inact_tau"] * 1000)
    ax1.plot(data["v"] * 1000, data["act_tau2"] * 1000, "r--")
    ax2.plot(data["v"] * 1000, data["inact_tau2"] * 1000, "r--")
    for ax in [ax1, ax2]:
        ax.set_ylabel("time constant [ms]")
        ax.set_xlabel("holding potential [mV]")
        ax.set_xlim(-80, 60)
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S5_tau.pdf")
    f.savefig("plots/inada2009_S5_tau.png")


def inada2009_S5B(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(6, 4), tight_layout=True)
    ax = f.add_subplot()
    vs = np.arange(15) * 10 - 80
    for v in vs:
        start = np.argmax(np.abs(data["vc.v"] - v / 1000) < 1e-6)
        start = np.argmax(data["time"] >= data["time"][start] - 0.05)
        end = np.argmax(data["time"] >= data["time"][start] + 0.85)
        xvals = (data["time"][start:end] - data["time"][start]) * 1000
        ax.plot(xvals, data["vc.i"][start:end] / 29e-12, label="%d mV" % v)
    ax.set_xlabel("time [ms]")
    ax.set_ylabel("current [pA/pF]")
    # ax.set_ylim(-90, 0)
    ax.set_xlim(0, 850)
    ax.legend(loc="right")
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S5B.pdf")
    f.savefig("plots/inada2009_S5B.png")


def inada2009_S5C(fname, hold_period=15, v_inc=0.005):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(
        ax, data, hold_period=hold_period, v_inc=v_inc, field="vc.is_peak",
        normalize=False, factor=1/29e-12
    )
    ax.set_xlim(-80, 60)
    ax.set_xlabel("pulse potential [mV]")
    ax.set_ylabel("current density [pA/pF]")
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/inada2009_S5C.pdf")
    f.savefig("plots/inada2009_S5C.png")


def kurata2002_4bl(fname):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(6, 4), tight_layout=True)
    ax = f.add_subplot()
    vs = np.arange(13) * 10 - 70
    for v in vs:
        start = np.argmax(np.abs(data["vc.v"] - v / 1000) < 1e-6)
        start = np.argmax(data["time"] >= data["time"][start] - 0.05)
        end = np.argmax(data["time"] >= data["time"][start] + 0.85)
        xvals = (data["time"][start:end] - data["time"][start]) * 1000
        ax.plot(xvals, data["vc.i"][start:end] / 32e-12, label="%d mV" % v)
    ax.set_xlabel("time [ms]")
    ax.set_ylabel("current [pA/pF]")
    # ax.set_ylim(-90, 0)
    ax.set_xlim(0, 850)
    ax.legend(loc="right")
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/kurata_2002_4bl.pdf")
    f.savefig("plots/kurata_2002_4bl.png")


def kurata2002_4br(fname, hold_period=15, v_inc=0.005):
    data = pd.read_csv(fname, delimiter=",")
    f = plt.Figure(figsize=(8, 4), tight_layout=True)
    ax = f.add_subplot()
    plot_iv(
        ax, data, hold_period=hold_period, v_inc=v_inc, field="vc.is_peak",
        normalize=False, factor=1/32e-12
    )
    ax.set_xlim(-80, 60)
    ax.set_xlabel("pulse potential [mV]")
    ax.set_ylabel("current density [pA/pF]")
    if not os.path.isdir("plots"):
        os.mkdir("plots")
    f.savefig("plots/kurata_2002_4br.pdf")
    f.savefig("plots/kurata_2002_4br.png")


if __name__ == "__main__":
    lindblad1997_2A("out/InaMo.Examples.SodiumChannelSteady_res.csv")
    lindblad1997_2B("out/InaMo.Examples.SodiumChannelIV_res.csv")
    lindblad1997_2CDE("out/InaMo.Examples.SodiumChannelSteady_res.csv")
    lindblad1997_8("out/InaMo.Examples.InwardRectifierLin_res.csv")
    ghkFlux("out/InaMo.Examples.GHKFlux_res.csv")
    """
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
    """
