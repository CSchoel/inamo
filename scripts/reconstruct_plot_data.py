# uses data from hand-drawn SVG images to reconstruct plot data

import numpy as np
import lxml.etree as et
import svgpathtools as svgpath
import matplotlib.pyplot as plt


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
    return res


def first_point(path):
    s = svgpath.parse_path(path).start
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
    cfactor = (ylim_c[1][1] - ylim_c[0][1]) / (ylim_c[1][0] - ylim_c[0][0])
    c0 = ylim_c[1][0] - ylim_c[1][1] / cfactor
    x0s = [
        first_point(path_by_id(dom, "x0_"+x))[0]
        for x in cell_types
    ]
    xfactor = 50 / width(path_by_id(dom, "xbar"))
    voltage_plots = [
        convert_path(
            path_by_id(dom, "voltage_" + x),
            x0, xfactor, v0, vfactor, 1000
        )
        for x, x0 in zip(cell_types, x0s)
    ]
    for c, d in zip(cell_types, voltage_plots):
        np.savetxt(
            "data/reconstruct_full_cells_S7/{}_v.csv".format(c), d,
            delimiter=",",
            header="time[ms],voltage[mV]",
            comments=""
        )


if __name__ == "__main__":
    reconstruct_full_cells_S7("img/inada_orig_cells_discrete.svg")