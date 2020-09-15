# uses data from hand-drawn SVG images to reconstruct plot data

import numpy as np
import lxml.etree as et
import svgpathtools as svgpath


def convert_path(path, x0, xfactor, y0, yfactor, steps):
    p = svgpath.parse_path(path)
    res = []
    for i in range(steps):
        t = i / (steps-1)
        res.append(p.point(t))
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
    dom = et.parse(fname)
    ylim_v = (
        (first_point(path_by_id(dom, "voltage_low"))[1], -80),
        (first_point(path_by_id(dom, "voltage_high"))[1], 40)
    )
    ylim_c = (
        (first_point(path_by_id(dom, "ca_low"))[1], 0),
        (first_point(path_by_id(dom, "ca_high"))[1], 1)
    )
    x0s = [
        first_point(path_by_id(dom, "x0_"+x))[0]
        for x in ["am", "an", "n", "nh"]
    ]
    xfactor = width(path_by_id(dom, "xbar")) / 50
    print(ylim_v)
    print(ylim_c)
    print(x0s)
    print(xfactor)
    ylim_v = ((112.59237, -80), (49.120929, 40))
    ylim_c = ((196.29762, 0), (122.3152, 1))
    x0s = [-102.12249, 8.5055034, 111.50644, 214.79407]
    xfactor = 23.99138 / 50


if __name__ == "__main__":
    reconstruct_full_cells_S7("img/inada_orig_cells_discrete.svg")
