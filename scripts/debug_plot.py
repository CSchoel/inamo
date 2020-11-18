import matplotlib.pyplot as plt
import numpy as np
import pandas
from pathlib import Path

def debug_plot(model, variables):
    curpath = Path("out") / "{}_res.csv".format(model)
    refpath = Path("regRefData") / "{}_res.csv".format(model)
    curdata = pandas.read_csv(curpath)
    refdata = pandas.read_csv(refpath)
    if variables is None:
        variables = refdata.columns
    colors = ["C{}".format(i) for i in range(1, 10)]
    for v, c in zip(variables, colors):
        if v.startswith("rΔ"):
            v = v[2:]
            curiter = np.interp(refdata["time"], curdata["time"], curdata[v])
            scale = np.minimum(np.abs(curiter), np.abs(refdata[v]))
            delta = np.abs(curiter - refdata[v]) / scale
            plt.plot(refdata["time"], delta, color=c, label="rel. Δ{}".format(v))
        elif v.startswith("Δ"):
            v = v[1:]
            curiter = np.interp(refdata["time"], curdata["time"], curdata[v])
            delta = curiter - refdata[v]
            plt.plot(refdata["time"], delta, color=c, label="Δ{}".format(v))
        else:
            plt.plot(curdata["time"], curdata[v], linestyle="-", color=c, label="{} (cur)".format(v))
            plt.plot(refdata["time"], refdata[v], linestyle="--", color="black", label="{} (ref)".format(v))
    plt.legend()
    plt.show()

if __name__ == "__main__":
    # Δ
    debug_plot("InaMo.Examples.AllCells", ["rΔn.cell.v"])
