import unittest
from pathlib import Path
import OMPython
import os
import time


def escape_mostring(s):
    t = str.maketrans({
        "\\": "\\\\",
        '"': '\\"',
        '?': '\\?',
        '\a': '\\a',
        '\b': '\\b',
        '\f': '\\f',
        '\n': '\\n',
        '\r': '\\r',
        '\t': '\\t',
        '\v': '\\v',
    })
    return str(s).translate(t)


def assert_sim_noerror(test, model, duration, stepsize, tolerance=1e-6):
    omc = TestIonChannels.omc
    intervals = int(duration // stepsize)
    r = omc.sendExpression("loadModel({})".format(model))
    test.assertTrue(r)
    es = omc.sendExpression("getErrorString()")
    test.assertEqual(0, len(es), msg=es)
    r = omc.sendExpression(
        ("simulate({}, stopTime={}, numberOfIntervals={}, tolerance={}, "
            + "outputFormat=\"csv\")")
        .format(model, duration, intervals, tolerance)
    )
    test.assertFalse("| warning |" in r["messages"], msg=r["messages"])
    test.assertFalse(
        r["messages"].startswith("Simulation execution failed"),
        msg=r["messages"]
    )
    es = omc.sendExpression("getErrorString()")
    test.assertEqual(0, len(es), msg=es)


class TestIonChannels(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        moroot = Path(__file__).parent.parent
        outdir = moroot / "out"
        os.chdir(outdir)
        if not outdir.is_dir():
            outdir.mkdir()
        cls.omc = OMPython.OMCSessionZMQ()
        mopath = cls.omc.sendExpression("getModelicaPath()")
        mopath = ":".join([mopath, escape_mostring(moroot)])
        print("Setting MODELICAPATH to ", mopath)
        cls.omc.sendExpression('setModelicaPath(\"{}\")'.format(mopath))
        # load Modelica standard library
        cls.omc.sendExpression("loadModel(Modelica)")

    @classmethod
    def tearDownClass(cls):
        print("Closing OMC session")
        time.sleep(1)
        cls.omc.sendExpression("quit()", parsed=False)
        print("Done")

    def test_sodium_channel_steady(self):
        assert_sim_noerror(
            self, "InaMo.Examples.SodiumChannelSteady", 80, 1e-2
        )

    def test_SodiumChannelIV(self):
        assert_sim_noerror(
            self, "InaMo.Examples.SodiumChannelIV", 80, 1e-2  # 1e-5
        )

    def test_InwardRectifierLin(self):
        assert_sim_noerror(
            self, "InaMo.Examples.InwardRectifierLin", 150, 1,
            tolerance=1e-12
        )

    def test_GHKFlux(self):
        assert_sim_noerror(
            self, "InaMo.Examples.GHKFlux", 100, 1e-1
        )

    def test_LTypeCalciumSteady(self):
        assert_sim_noerror(
            self, "InaMo.Examples.LTypeCalciumSteady", 140, 1
        )

    def test_LTypeCalciumIV(self):
        assert_sim_noerror(
            self, "InaMo.Examples.LTypeCalciumIV", 800, 1e-2
        )

    def test_LTypeCalciumIVN(self):
        assert_sim_noerror(
            self, "InaMo.Examples.LTypeCalciumIVN", 800, 1e-2
        )

    def test_LTypeCalciumStep(self):
        assert_sim_noerror(
            self, "InaMo.Examples.LTypeCalciumStep", 2, 1e-4
        )

    def test_TransientOutwardSteady(self):
        assert_sim_noerror(
            self, "InaMo.Examples.TransientOutwardSteady", 180, 1
        )

    def test_TransientOutwardIV(self):
        assert_sim_noerror(
            self, "InaMo.Examples.TransientOutwardIV", 108, 1e-2
        )

    def test_RapidDelayedRectifierSteady(self):
        assert_sim_noerror(
            self, "InaMo.Examples.RapidDelayedRectifierSteady", 200, 1
        )

    def test_RapidDelayedRectifierIV(self):
        assert_sim_noerror(
            self, "InaMo.Examples.RapidDelayedRectifierIV", 108, 1e-2
        )

    def test_HyperpolarizationActivatedSteady(self):
        assert_sim_noerror(
            self, "InaMo.Examples.HyperpolarizationActivatedSteady", 80, 1
        )

    def test_HyperpolarizationActivatedIV(self):
        assert_sim_noerror(
            self, "InaMo.Examples.HyperpolarizationActivatedIV", 340, 1e-1
        )

    def test_SustainedInwardSteady(self):
        assert_sim_noerror(
            self, "InaMo.Examples.SustainedInwardSteady", 140, 1
        )

    def test_SustainedInwardIV(self):
        assert_sim_noerror(
            self, "InaMo.Examples.SustainedInwardIV", 124, 1e-2
        )

    def test_SustainedInwardIVKurata(self):
        assert_sim_noerror(
            self, "InaMo.Examples.SustainedInwardIVKurata", 124, 1e-2,
            tolerance=1e-12
        )


if __name__ == '__main__':
    unittest.main()
