# uses data from hand-drawn SVG images to reconstruct plot data

import numpy as np
import lxml.etree as et
import svgpathtools as svgpath
import matplotlib.pyplot as plt
import os


def convert_path(path, x0, xfactor, y0, yfactor, steps):
    p = svgpath.parse_path(path)
    res = []
    xlast = -np.inf
    for i in range(steps):
        t = i / (steps-1)
        pt = p.point(t)
        x = (pt.real - x0) * xfactor
        y = (pt.imag - y0) * yfactor
        # only add points that advance forward on x axis
        if x > xlast:
            res.append((x, y))
            xlast = x
    return np.asarray(res, dtype="float32")


def first_point(path):
    s = svgpath.parse_path(path).start
    s = (s.real, s.imag)
    return s


def last_point(path):
    s = svgpath.parse_path(path).end
    s = (s.real, s.imag)
    return s


def width(path):
    p = svgpath.parse_path(path)
    return abs(p.point(0).real - p.point(1).real)


def path_by_id(dom, id):
    ns = {"svg": "http://www.w3.org/2000/svg"}
    path = dom.xpath(
        "//svg:path[@id = '{}']".format(id), namespaces=ns
    )[0].get("d")
    return path


def get_data_paths(dom):
    ns = {"svg": "http://www.w3.org/2000/svg"}
    paths = dom.xpath(
        "//svg:path[starts-with(@id, 'data_')]", namespaces=ns
    )
    paths = [(x.get("id")[5:], x.get("d")) for x in paths]
    return paths


def scale_factor(plot_low, plot_high, data_low, data_high):
    plot_span = plot_high - plot_low
    data_span = data_high - data_low
    return data_span/plot_span


def reconstruct_generic(
    fname, xlim=(0, 1), ylim=(0, 1),
    steps=1000, xlabel="x", ylabel="y", debug_plot=False
):
    # generic function to reconstruct data from any 2D-plot
    x_low, x_high = xlim
    y_low, y_high = ylim
    dom = et.parse(fname)
    # FIXME this depends on path direction
    y_low_plot = first_point(path_by_id(dom, "yaxis"))[1]
    y_high_plot = last_point(path_by_id(dom, "yaxis"))[1]
    yfactor = scale_factor(y_low_plot, y_high_plot, y_low, y_high)
    x_low_plot = first_point(path_by_id(dom, "xaxis"))[0]
    x_high_plot = last_point(path_by_id(dom, "xaxis"))[0]
    xfactor = scale_factor(x_low_plot, x_high_plot, x_low, x_high)
    datapaths = get_data_paths(dom)
    for label, p in datapaths:
        data = convert_path(p, x_low_plot, xfactor, y_low_plot, yfactor, steps)
        data[:, 0] += x_low
        data[:, 1] += y_low
        outname = "data/reconstruct_{}_{}.csv".format(
            os.path.basename(fname)[:-4],
            label
        )
        np.savetxt(
            outname, data,
            delimiter=",",
            header="{},{}".format(xlabel, ylabel),
            comments="",
            encoding="utf-8"
        )
        if debug_plot:
            plt.plot(data[:, 0], data[:, 1], label=label)
    if debug_plot:
        plt.legend()
        plt.show()
        plt.close()


def reconstruct_full_cells_S7(fname):
    # data from img/inada_orig_cells_discrete.svg
    cell_types = ["am", "an", "n", "nh"]
    dom = et.parse(fname)
    ylim_v = (
        (first_point(path_by_id(dom, "voltage_low"))[1], -80),
        (first_point(path_by_id(dom, "voltage_high"))[1], 40)
    )
    vfactor = (ylim_v[1][1] - ylim_v[0][1]) / (ylim_v[1][0] - ylim_v[0][0])
    v0 = ylim_v[1][0] - ylim_v[1][1] / vfactor
    ylim_c = (
        (first_point(path_by_id(dom, "ca_low"))[1], 0),
        (first_point(path_by_id(dom, "ca_high"))[1], 1)
    )
    cafactor = (ylim_c[1][1] - ylim_c[0][1]) / (ylim_c[1][0] - ylim_c[0][0])
    ca0 = ylim_c[1][0] - ylim_c[1][1] / cafactor
    x0s = [
        first_point(path_by_id(dom, "x0_"+x))[0]
        for x in cell_types
    ]
    x_stims = [
        first_point(path_by_id(dom, "x_stim_"+x))[0]
        for x in cell_types
    ]
    xfactor = 50 / width(path_by_id(dom, "xbar"))
    # create offsets to ensure that stimulation occurs at x = 50 ms
    x_stims = [(x - x0) * xfactor for x, x0 in zip(x_stims, x0s)]
    x_offs = [50 - x for x in x_stims]
    voltage_plots = [
        convert_path(
            path_by_id(dom, "voltage_" + c),
            x0, xfactor, v0, vfactor, 1000
        )
        for c, x0 in zip(cell_types, x0s)
    ]
    ca_plots = [
        convert_path(
            path_by_id(dom, "ca_" + c),
            x0, xfactor, ca0, cafactor, 1000
        )
        for c, x0 in zip(cell_types, x0s)
    ]
    voltage_plots = [d + [off, 0] for d, off in zip(voltage_plots, x_offs)]
    ca_plots = [d + [off, 0] for d, off in zip(ca_plots, x_offs)]

    for c, d in zip(cell_types, voltage_plots):
        np.savetxt(
            "data/reconstruct_full_cells_S7/{}_v.csv".format(c), d,
            delimiter=",",
            header="time[ms],voltage[mV]",
            comments="",
            encoding="utf-8"
        )
    for c, d in zip(cell_types, ca_plots):
        np.savetxt(
            "data/reconstruct_full_cells_S7/{}_ca.csv".format(c), d,
            delimiter=",",
            header="time[ms],[Ca2+]_i[μM]",
            comments="",
            encoding="utf-8"
        )


if __name__ == "__main__":
    reconstruct_full_cells_S7("img/inada_orig_cells_discrete.svg")
    reconstruct_generic(
        "img/cal_inada2009_S1A_orig.svg",
        xlim=(-80, 60), ylim=(0, 1),
        xlabel="voltage[mV]", ylabel="steady state"
    )
    reconstruct_generic(
        "img/cal_inada2009_S1B_orig.svg",
        xlim=(-80, 60), ylim=(0, 1),
        xlabel="voltage[mV]", ylabel="steady state"
    )
    reconstruct_generic(
        "img/cal_inada2009_S1C_orig.svg",
        xlim=(-80, 60), ylim=(0, 200),
        xlabel="voltage[mV]", ylabel="time constant [ms]"
    )
    reconstruct_generic(
        "img/cal_inada2009_S1D_orig.svg",
        xlim=(-80, 60), ylim=(0, 1500),
        xlabel="voltage[mV]", ylabel="time constant [ms]", debug_plot=True
    )
