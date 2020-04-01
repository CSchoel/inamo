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


def assert_sim_noerror(test, model, override=None):
    if override is None:
        override = {}
    omc = TestIonChannels.omc
    r = omc.sendExpression("loadModel({})".format(model))
    test.assertTrue(r)
    es = omc.sendExpression("getErrorString()")
    test.assertEqual(0, len(es), msg=es)
    start, stop, tol, noi, _ = omc.sendExpression(
        "getSimulationOptions({})".format(model)
    )
    settings = {
        "startTime": start, "stopTime": stop,
        "tolerance": tol, "numberOfIntervals": noi,
        "outputFormat": '"csv"'
    }
    for x in settings:
        if x in override:
            settings[x] = override[x]
    r = omc.sendExpression(
        "simulate({}, {})".format(
            model,
            ", ".join(["{}={}".format(x, settings[x]) for x in settings])
        )
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
        assert_sim_noerror(self, "InaMo.Examples.SodiumChannelSteady")

    def test_SodiumChannelIV(self):
        assert_sim_noerror(self, "InaMo.Examples.SodiumChannelIV")

    def test_InwardRectifierLin(self):
        assert_sim_noerror(self, "InaMo.Examples.InwardRectifierLin")

    def test_GHKFlux(self):
        assert_sim_noerror(self, "InaMo.Examples.GHKFlux", override={
            "stopTime": 100, "numberOfIntervals": 1000
        })

    def test_LTypeCalciumSteady(self):
        assert_sim_noerror(self, "InaMo.Examples.LTypeCalciumSteady")

    def test_LTypeCalciumIV(self):
        assert_sim_noerror(self, "InaMo.Examples.LTypeCalciumIV")

    def test_LTypeCalciumIVN(self):
        assert_sim_noerror(self, "InaMo.Examples.LTypeCalciumIVN")

    def test_LTypeCalciumStep(self):
        assert_sim_noerror(self, "InaMo.Examples.LTypeCalciumStep")

    def test_TransientOutwardSteady(self):
        assert_sim_noerror(self, "InaMo.Examples.TransientOutwardSteady")

    def test_TransientOutwardIV(self):
        assert_sim_noerror(self, "InaMo.Examples.TransientOutwardIV")

    def test_RapidDelayedRectifierSteady(self):
        assert_sim_noerror(self, "InaMo.Examples.RapidDelayedRectifierSteady")

    def test_RapidDelayedRectifierIV(self):
        assert_sim_noerror(self, "InaMo.Examples.RapidDelayedRectifierIV")

    def test_HyperpolarizationActivatedSteady(self):
        assert_sim_noerror(
            self, "InaMo.Examples.HyperpolarizationActivatedSteady"
        )

    def test_HyperpolarizationActivatedIV(self):
        assert_sim_noerror(self, "InaMo.Examples.HyperpolarizationActivatedIV")

    def test_SustainedInwardSteady(self):
        assert_sim_noerror(self, "InaMo.Examples.SustainedInwardSteady")

    def test_SustainedInwardIV(self):
        assert_sim_noerror(self, "InaMo.Examples.SustainedInwardIV")

    def test_SustainedInwardIVKurata(self):
        assert_sim_noerror(self, "InaMo.Examples.SustainedInwardIVKurata")

    def test_SodiumPotassiumPumpLin(self):
        assert_sim_noerror(self, "InaMo.Examples.SodiumPotassiumPumpLin")

    def test_SodiumCalciumExchangerRamp(self):
        assert_sim_noerror(self, "InaMo.Examples.SodiumCalciumExchangerRamp")

    def test_SodiumCalciumExchangerLin(self):
        assert_sim_noerror(self, "InaMo.Examples.SodiumCalciumExchangerLin")


if __name__ == '__main__':
    unittest.main()
