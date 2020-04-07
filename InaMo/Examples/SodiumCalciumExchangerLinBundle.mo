within InaMo.Examples;
model SodiumCalciumExchangerLinBundle "bundles all experiments required to reproduce Figure 19 of Matsuoka 1992"
  SodiumCalciumExchangerLin a1(sodium(c_in=25, c_ex=0), ca_sub(c_const=0), calcium(c_ex=8));
  SodiumCalciumExchangerLin a2(sodium(c_in=25, c_ex=0), ca_sub(c_const=0.016), calcium(c_ex=8));
  SodiumCalciumExchangerLin a3(sodium(c_in=25, c_ex=0), ca_sub(c_const=0.234), calcium(c_ex=8));
  SodiumCalciumExchangerLin b1(sodium(c_in=100, c_ex=0), ca_sub(c_const=0), calcium(c_ex=8));
  SodiumCalciumExchangerLin b2(sodium(c_in=100, c_ex=0), ca_sub(c_const=0.064), calcium(c_ex=8));
  SodiumCalciumExchangerLin b3(sodium(c_in=100, c_ex=0), ca_sub(c_const=1.08), calcium(c_ex=8));
  SodiumCalciumExchangerLin c1(sodium(c_in=0, c_ex=150), ca_sub(c_const=0.003), calcium(c_ex=0));
  SodiumCalciumExchangerLin c2(sodium(c_in=25, c_ex=150), ca_sub(c_const=0.003), calcium(c_ex=0));
  SodiumCalciumExchangerLin c3(sodium(c_in=50, c_ex=150), ca_sub(c_const=0.003), calcium(c_ex=0));
  SodiumCalciumExchangerLin d1(sodium(c_in=0, c_ex=150), ca_sub(c_const=1.08), calcium(c_ex=0));
  SodiumCalciumExchangerLin d2(sodium(c_in=25, c_ex=150), ca_sub(c_const=1.08), calcium(c_ex=0));
  SodiumCalciumExchangerLin d3(sodium(c_in=100, c_ex=150), ca_sub(c_const=1.08), calcium(c_ex=0));
end SodiumCalciumExchangerLinBundle;
