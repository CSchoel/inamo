import unittest
from pathlib import Path
import OMPython


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


class TestIonChannels(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        moroot = Path(__file__).parent.parent
        outdir = moroot / "out"
        if not outdir.is_dir():
            outdir.mkdir()
        cls.omc = OMPython.OMCSessionZMQ()
        mopath = cls.omc.sendExpression("getModelicaPath()")
        mopath = ":".join([mopath, escape_mostring(moroot)])
        print("Setting MODELICAPATH to ", mopath)
        cls.omc.sendExpression('setModelicaPath(\"{}\")'.format(mopath))
        # load Modelica standard library
        cls.omc.sendExpression("loadModel(Modelica)")

    def test_sodium_channel_steady(self):
        assert_sim_noerror(
            self, "InaMo.Examples.SodiumChannelSteady", 80, 1e-2
        )


def assert_sim_noerror(test, model, duration, stepsize):
    omc = TestIonChannels.omc
    intervals = duration // stepsize
    r = omc.sendExpression("loadModel({})".format(model))
    test.assertTrue(r)
    es = omc.sendExpression("getErrorString()")
    test.assertEqual(0, len(es), msg=es)
    r = omc.sendExpression(
        "simulate({}, stopTime={}, numberOfIntervals={}, "
        + "outputFormat=\"csv\")".format(model, duration, intervals)
    )
    test.assertFalse(r["messages"].contains("| warning |"), msg=r["messages"])
    test.assertFalse(
        r["messages"].startswith("Simulation execution failed"),
        msg=r["messages"]
    )
    es = omc.sendExpression("getErrorString()")
    test.assertEquals(0, len(es), msg=es)


if __name__ == '__main__':
    unittest.main()
