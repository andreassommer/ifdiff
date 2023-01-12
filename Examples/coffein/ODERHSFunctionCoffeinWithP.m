function dy = ODERHSFunction(Time,y,p)

P_0 = 9500;  % CoffeinSimulation|Organism|SA proportionality factor
P_1 = 1;  % CoffeinSimulation|Organism|Surface area scaling exponent
P_2 = 0.37;  % CoffeinSimulation|Organism|Protein ratio (interstial/plasma)
P_3 = 0.005;  % CoffeinSimulation|Organism|Vf (lipid, blood cells)
P_4 = 0.007;  % CoffeinSimulation|Organism|Vf (lipid, plasma)
P_5 = 0.003;  % CoffeinSimulation|Organism|Vf (neutral lipid, blood cells)-WS
P_6 = 0.926;  % CoffeinSimulation|Organism|Vf (water,plasma)
P_7 = 0.0032;  % CoffeinSimulation|Organism|Vf (neutral lipid, plasma)-RR
P_8 = 0.325;  % CoffeinSimulation|Organism|Vf (protein,blood cells)
P_9 = 0.067;  % CoffeinSimulation|Organism|Vf (protein,plasma)
P_10 = 0.625;  % CoffeinSimulation|Organism|Vf (water,blood cells)
P_11 = 0.9350000000000001;  % CoffeinSimulation|Organism|Vf (water,interstitial)
P_12 = 7.22;  % CoffeinSimulation|Organism|pH (blood cells)
P_13 = 7.4;  % CoffeinSimulation|Organism|pH (interstitial)
P_14 = 7;  % CoffeinSimulation|Organism|pH (intracellular)
P_15 = 7.4;  % CoffeinSimulation|Organism|pH (plasma)
P_16 = 0.667;  % CoffeinSimulation|Organism|Scaling exponent for fluid recirculation flow rate
P_17 = 3e-06;  % CoffeinSimulation|Organism|Thickness (endothelium)
P_18 = 40;  % CoffeinSimulation|Organism|Gestational age
P_19 = 30;  % CoffeinSimulation|Organism|Age
P_20 = 928.8;  % CoffeinSimulation|Organism|R*T
P_21 = 6.022e+17;  % CoffeinSimulation|Organism|Na
P_22 = 0.2;  % CoffeinSimulation|Organism|Fraction endosomal (global)
P_23 = 0.0021;  % CoffeinSimulation|Organism|Vf (neutral phospholipid, plasma)-RR
P_24 = 0.0059;  % CoffeinSimulation|Organism|Vf (neutral phospholipid, blood cells)-WS
P_25 = 0.0035;  % CoffeinSimulation|Organism|Vf (neutral lipid, plasma)-PT
P_26 = 167000;  % CoffeinSimulation|Organism|Surface/Volume ratio (blood cells)
P_27 = 0.00225;  % CoffeinSimulation|Organism|Vf (phospholipid, plasma)-PT
P_28 = 0.0012;  % CoffeinSimulation|Organism|Vf (neutral lipid, blood cells)-RR
P_29 = 0.001;  % CoffeinSimulation|Organism|Vf (acidic phospholipids, blood cells)-WS
P_30 = 0.5;  % CoffeinSimulation|Organism|Fraction of endosomal uptake from plasma (global)
P_31 = 1;  % CoffeinSimulation|Organism|Plasma protein scale factor
P_32 = 1;  % CoffeinSimulation|Organism|Ontogeny factor (alpha1-acid glycoprotein)
P_33 = 1;  % CoffeinSimulation|Organism|Ontogeny factor (albumin)
P_34 = 17.6;  % CoffeinSimulation|Organism|Height
P_35 = 0.945;  % CoffeinSimulation|Organism|Vf (water,plasma)-PT
P_36 = 0.0033;  % CoffeinSimulation|Organism|Vf (neutral phospholipid, blood cells)-RR
P_37 = 0.57;  % CoffeinSimulation|Organism|Acidic phospholipids (blood cells) [mg/g] - RR
P_38 = 0.5;  % CoffeinSimulation|Organism|Fraction recycled to plasma (global)
P_39 = 0.63;  % CoffeinSimulation|Organism|Vf (intracellular water, blood cells)-RR
P_40 = 0.36;  % CoffeinSimulation|Organism|Rate constant for endosomal uptake (global)
P_41 = 0.083;  % CoffeinSimulation|Organism|Rate constant for recycling from endosomal space (global)
P_42 = 0.47;  % CoffeinSimulation|Organism|Hematocrit
P_43 = 73;  % CoffeinSimulation|Organism|MeanBW
P_44 = 17.6;  % CoffeinSimulation|Organism|MeanHeight
P_45 = 1;  % CoffeinSimulation|Organism|VenousBlood|Density (tissue)
P_46 = 0.75;  % CoffeinSimulation|Organism|VenousBlood|Allometric scale factor
P_47 = 1;  % CoffeinSimulation|Organism|VenousBlood|Fraction vascular
P_48 = 0.964022191428847;  % CoffeinSimulation|Organism|VenousBlood|Volume
P_49 = 1;  % CoffeinSimulation|Organism|VenousBlood|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_50 = 1;  % CoffeinSimulation|Organism|VenousBlood|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_51 = 1;  % CoffeinSimulation|Organism|VenousBlood|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_52 = 1;  % CoffeinSimulation|Organism|VenousBlood|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_53 = 1;  % CoffeinSimulation|Organism|ArterialBlood|Density (tissue)
P_54 = 0;  % CoffeinSimulation|Organism|ArterialBlood|Peripheral blood flow fraction
P_55 = 0.75;  % CoffeinSimulation|Organism|ArterialBlood|Allometric scale factor
P_56 = 1;  % CoffeinSimulation|Organism|ArterialBlood|Fraction vascular
P_57 = 0.419107448106746;  % CoffeinSimulation|Organism|ArterialBlood|Volume
P_58 = 1;  % CoffeinSimulation|Organism|ArterialBlood|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_59 = 1;  % CoffeinSimulation|Organism|ArterialBlood|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_60 = 1;  % CoffeinSimulation|Organism|ArterialBlood|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_61 = 1;  % CoffeinSimulation|Organism|ArterialBlood|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_62 = 0;  % CoffeinSimulation|Organism|Gallbladder|Gallbladder emptying active
P_63 = 1;  % CoffeinSimulation|Organism|Gallbladder|Volume
P_64 = 19.7;  % CoffeinSimulation|Organism|Gallbladder|Gallbladder ejection half-time
P_65 = 0.65;  % CoffeinSimulation|Organism|Gallbladder|Gallbladder ejection fraction
P_66 = 0.00158;  % CoffeinSimulation|Organism|Bone|Organ volume mouse
P_67 = 1;  % CoffeinSimulation|Organism|Bone|Density (tissue)
P_68 = 0.000662;  % CoffeinSimulation|Organism|Bone|Lymph flow proportionality factor
P_69 = 0;  % CoffeinSimulation|Organism|Bone|Peripheral blood flow fraction
P_70 = 0.96;  % CoffeinSimulation|Organism|Bone|Fluid recirculation flow proportionality factor
P_71 = 2;  % CoffeinSimulation|Organism|Bone|Allometric scale factor
P_72 = 1;  % CoffeinSimulation|Organism|Bone|Fraction of blood for sampling
P_73 = 3.3e-07;  % CoffeinSimulation|Organism|Bone|Radius (large pores)
P_74 = 0.8;  % CoffeinSimulation|Organism|Bone|Flow fraction via large pores
P_75 = 3.88888888888889e-11;  % CoffeinSimulation|Organism|Bone|Hydraulic conductivity
P_76 = 9e-08;  % CoffeinSimulation|Organism|Bone|Radius (small pores)
P_77 = 0.074;  % CoffeinSimulation|Organism|Bone|Vf (neutral lipid)-PT
P_78 = 0.268;  % CoffeinSimulation|Organism|Bone|Vf (lipid)
P_79 = 0.034;  % CoffeinSimulation|Organism|Bone|Fraction vascular
P_80 = 0.268;  % CoffeinSimulation|Organism|Bone|Vf (protein)
P_81 = 0.0011;  % CoffeinSimulation|Organism|Bone|Vf (phospholipid)-PT
P_82 = 0.439;  % CoffeinSimulation|Organism|Bone|Vf (water)-PT
P_83 = 0.465;  % CoffeinSimulation|Organism|Bone|Vf (water)
P_84 = 0.05;  % CoffeinSimulation|Organism|Bone|Lipoprotein ratio (tissue/plasma)
P_85 = 0.5;  % CoffeinSimulation|Organism|Bone|Albumin ratio (tissue/plasma)-PT
P_86 = 0.1;  % CoffeinSimulation|Organism|Bone|Albumin ratio (tissue/plasma)
P_87 = 0.1;  % CoffeinSimulation|Organism|Bone|Fraction interstitial
P_88 = 0.0174;  % CoffeinSimulation|Organism|Bone|Vf (neutral lipid)-RR
P_89 = 0.017;  % CoffeinSimulation|Organism|Bone|Vf (neutral lipid)-WS
P_90 = 0.0016;  % CoffeinSimulation|Organism|Bone|Vf (neutral phospholipid)-RR
P_91 = 0.0022;  % CoffeinSimulation|Organism|Bone|Vf (neutral phospholipid, plasma)-WS
P_92 = 0.21;  % CoffeinSimulation|Organism|Bone|Vf (protein)-WS
P_93 = 0.1;  % CoffeinSimulation|Organism|Bone|Vf (extracellular water)-RR
P_94 = 0.26;  % CoffeinSimulation|Organism|Bone|Vf (water)-WS
P_95 = 0.317;  % CoffeinSimulation|Organism|Bone|Vf (intracellular water)-RR
P_96 = 0.67;  % CoffeinSimulation|Organism|Bone|Acidic phospholipids [mg/g] - RR
P_97 = 0.0008;  % CoffeinSimulation|Organism|Bone|Vf (acidic phospholipids)-WS
P_98 = 0.027495;  % CoffeinSimulation|Organism|Bone|Specific blood flow rate
P_99 = 11.8189123400907;  % CoffeinSimulation|Organism|Bone|Volume
P_100 = 1;  % CoffeinSimulation|Organism|Bone|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_101 = 1;  % CoffeinSimulation|Organism|Bone|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_102 = 1;  % CoffeinSimulation|Organism|Bone|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_103 = 1;  % CoffeinSimulation|Organism|Bone|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_104 = 7;  % CoffeinSimulation|Organism|Bone|Intracellular|pH
P_105 = 0;  % CoffeinSimulation|Organism|Bone|Intracellular|CYP1A2|Relative expression
P_106 = 0;  % CoffeinSimulation|Organism|Bone|Intracellular|CYP1A2|Relative expression (normalized)
P_107 = 1;  % CoffeinSimulation|Organism|Bone|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_108 = 1;  % CoffeinSimulation|Organism|Bone|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_109 = 1;  % CoffeinSimulation|Organism|Brain|Density (tissue)
P_110 = 0.404;  % CoffeinSimulation|Organism|Brain|Fluid recirculation flow proportionality factor
P_111 = 7.270000000000001e-05;  % CoffeinSimulation|Organism|Brain|Lymph flow proportionality factor
P_112 = 0.00017;  % CoffeinSimulation|Organism|Brain|Organ volume mouse
P_113 = 0;  % CoffeinSimulation|Organism|Brain|Allometric scale factor
P_114 = 1;  % CoffeinSimulation|Organism|Brain|Fraction of blood for sampling
P_115 = 4.5e-08;  % CoffeinSimulation|Organism|Brain|Radius (small pores)
P_116 = 5e-14;  % CoffeinSimulation|Organism|Brain|Hydraulic conductivity
P_117 = 0.05;  % CoffeinSimulation|Organism|Brain|Flow fraction via large pores
P_118 = 2.5e-07;  % CoffeinSimulation|Organism|Brain|Radius (large pores)
P_119 = 0.051;  % CoffeinSimulation|Organism|Brain|Vf (neutral lipid)-PT
P_120 = 0.11;  % CoffeinSimulation|Organism|Brain|Vf (lipid)
P_121 = 0.039;  % CoffeinSimulation|Organism|Brain|Fraction vascular
P_122 = 0.081;  % CoffeinSimulation|Organism|Brain|Vf (protein)
P_123 = 0.0565;  % CoffeinSimulation|Organism|Brain|Vf (phospholipid)-PT
P_124 = 0.048;  % CoffeinSimulation|Organism|Brain|Albumin ratio (tissue/plasma)
P_125 = 0.8080000000000001;  % CoffeinSimulation|Organism|Brain|Vf (water)
P_126 = 0.77;  % CoffeinSimulation|Organism|Brain|Vf (water)-PT
P_127 = 0.5;  % CoffeinSimulation|Organism|Brain|Albumin ratio (tissue/plasma)-PT
P_128 = 0.041;  % CoffeinSimulation|Organism|Brain|Lipoprotein ratio (tissue/plasma)
P_129 = 0.004;  % CoffeinSimulation|Organism|Brain|Fraction interstitial
P_130 = 0.0391;  % CoffeinSimulation|Organism|Brain|Vf (neutral lipid)-RR
P_131 = 0.0429;  % CoffeinSimulation|Organism|Brain|Vf (neutral lipid)-WS
P_132 = 0.0528;  % CoffeinSimulation|Organism|Brain|Vf (neutral phospholipid, plasma)-WS
P_133 = 0.0015;  % CoffeinSimulation|Organism|Brain|Vf (neutral phospholipid)-RR
P_134 = 0.08;  % CoffeinSimulation|Organism|Brain|Vf (protein)-WS
P_135 = 0.162;  % CoffeinSimulation|Organism|Brain|Vf (extracellular water)-RR
P_136 = 0.79;  % CoffeinSimulation|Organism|Brain|Vf (water)-WS
P_137 = 0.591;  % CoffeinSimulation|Organism|Brain|Vf (intracellular water)-RR
P_138 = 0.4;  % CoffeinSimulation|Organism|Brain|Acidic phospholipids [mg/g] - RR
P_139 = 0.0143;  % CoffeinSimulation|Organism|Brain|Vf (acidic phospholipids)-WS
P_140 = 1.50914168857358;  % CoffeinSimulation|Organism|Brain|Volume
P_141 = 0.51675;  % CoffeinSimulation|Organism|Brain|Specific blood flow rate
P_142 = 1;  % CoffeinSimulation|Organism|Brain|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_143 = 1;  % CoffeinSimulation|Organism|Brain|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_144 = 1;  % CoffeinSimulation|Organism|Brain|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_145 = 1;  % CoffeinSimulation|Organism|Brain|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_146 = 7.1;  % CoffeinSimulation|Organism|Brain|Intracellular|pH
P_147 = 0;  % CoffeinSimulation|Organism|Brain|Intracellular|CYP1A2|Relative expression
P_148 = 0;  % CoffeinSimulation|Organism|Brain|Intracellular|CYP1A2|Relative expression (normalized)
P_149 = 1;  % CoffeinSimulation|Organism|Brain|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_150 = 1;  % CoffeinSimulation|Organism|Brain|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_151 = 0.001;  % CoffeinSimulation|Organism|Fat|Organ volume mouse
P_152 = 0.00754;  % CoffeinSimulation|Organism|Fat|Lymph flow proportionality factor
P_153 = 0;  % CoffeinSimulation|Organism|Fat|Peripheral blood flow fraction
P_154 = 1;  % CoffeinSimulation|Organism|Fat|Density (tissue)
P_155 = 0.357;  % CoffeinSimulation|Organism|Fat|Fluid recirculation flow proportionality factor
P_156 = 2;  % CoffeinSimulation|Organism|Fat|Allometric scale factor
P_157 = 1;  % CoffeinSimulation|Organism|Fat|Fraction of blood for sampling
P_158 = 4.5e-08;  % CoffeinSimulation|Organism|Fat|Radius (small pores)
P_159 = 2.5e-07;  % CoffeinSimulation|Organism|Fat|Radius (large pores)
P_160 = 4.16666666666667e-12;  % CoffeinSimulation|Organism|Fat|Hydraulic conductivity
P_161 = 0.05;  % CoffeinSimulation|Organism|Fat|Flow fraction via large pores
P_162 = 0.018;  % CoffeinSimulation|Organism|Fat|Fraction vascular
P_163 = 0.05;  % CoffeinSimulation|Organism|Fat|Vf (protein)
P_164 = 0.068;  % CoffeinSimulation|Organism|Fat|Lipoprotein ratio (tissue/plasma)
P_165 = 0;  % CoffeinSimulation|Organism|Fat|Albumin ratio (tissue/plasma)-PT
P_166 = 0.049;  % CoffeinSimulation|Organism|Fat|Albumin ratio (tissue/plasma)
P_167 = 0.06;  % CoffeinSimulation|Organism|Fat|Vf (protein)-WS
P_168 = 0.000552;  % CoffeinSimulation|Organism|Fat|Vf (acidic phospholipids)-WS
P_169 = 0.4;  % CoffeinSimulation|Organism|Fat|Acidic phospholipids [mg/g] - RR
P_170 = 14.6532390773743;  % CoffeinSimulation|Organism|Fat|Volume
P_171 = 0.79;  % CoffeinSimulation|Organism|Fat|Vf (neutral lipid)-PT
P_172 = 0.8;  % CoffeinSimulation|Organism|Fat|Vf (lipid)
P_173 = 0.002;  % CoffeinSimulation|Organism|Fat|Vf (phospholipid)-PT
P_174 = 0.16;  % CoffeinSimulation|Organism|Fat|Fraction interstitial
P_175 = 0.15;  % CoffeinSimulation|Organism|Fat|Vf (water)
P_176 = 0.18;  % CoffeinSimulation|Organism|Fat|Vf (water)-PT
P_177 = 0.853;  % CoffeinSimulation|Organism|Fat|Vf (neutral lipid)-RR
P_178 = 0.92;  % CoffeinSimulation|Organism|Fat|Vf (neutral lipid)-WS
P_179 = 0.0016;  % CoffeinSimulation|Organism|Fat|Vf (neutral phospholipid)-RR
P_180 = 0.002024;  % CoffeinSimulation|Organism|Fat|Vf (neutral phospholipid, plasma)-WS
P_181 = 0.135;  % CoffeinSimulation|Organism|Fat|Vf (extracellular water)-RR
P_182 = 0.00899999999999998;  % CoffeinSimulation|Organism|Fat|Vf (intracellular water)-RR
P_183 = 0.03;  % CoffeinSimulation|Organism|Fat|Vf (water)-WS
P_184 = 0.02184;  % CoffeinSimulation|Organism|Fat|Specific blood flow rate
P_185 = 1;  % CoffeinSimulation|Organism|Fat|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_186 = 1;  % CoffeinSimulation|Organism|Fat|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_187 = 1;  % CoffeinSimulation|Organism|Fat|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_188 = 1;  % CoffeinSimulation|Organism|Fat|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_189 = 7.1;  % CoffeinSimulation|Organism|Fat|Intracellular|pH
P_190 = 0;  % CoffeinSimulation|Organism|Fat|Intracellular|CYP1A2|Relative expression
P_191 = 0;  % CoffeinSimulation|Organism|Fat|Intracellular|CYP1A2|Relative expression (normalized)
P_192 = 1;  % CoffeinSimulation|Organism|Fat|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_193 = 1;  % CoffeinSimulation|Organism|Fat|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_194 = 1;  % CoffeinSimulation|Organism|Gonads|Density (tissue)
P_195 = 0.96;  % CoffeinSimulation|Organism|Gonads|Fluid recirculation flow proportionality factor
P_196 = 0.0111;  % CoffeinSimulation|Organism|Gonads|Lymph flow proportionality factor
P_197 = 0.00025;  % CoffeinSimulation|Organism|Gonads|Organ volume mouse
P_198 = 0.75;  % CoffeinSimulation|Organism|Gonads|Allometric scale factor
P_199 = 1;  % CoffeinSimulation|Organism|Gonads|Fraction of blood for sampling
P_200 = 2.5e-07;  % CoffeinSimulation|Organism|Gonads|Radius (large pores)
P_201 = 1.66666666666667e-12;  % CoffeinSimulation|Organism|Gonads|Hydraulic conductivity
P_202 = 0.05;  % CoffeinSimulation|Organism|Gonads|Flow fraction via large pores
P_203 = 4.5e-08;  % CoffeinSimulation|Organism|Gonads|Radius (small pores)
P_204 = 0.0048;  % CoffeinSimulation|Organism|Gonads|Vf (neutral lipid)-PT
P_205 = 0.031;  % CoffeinSimulation|Organism|Gonads|Vf (lipid)
P_206 = 0.055;  % CoffeinSimulation|Organism|Gonads|Fraction vascular
P_207 = 0.01405;  % CoffeinSimulation|Organism|Gonads|Vf (phospholipid)-PT
P_208 = 0.12;  % CoffeinSimulation|Organism|Gonads|Vf (protein)
P_209 = 0.8;  % CoffeinSimulation|Organism|Gonads|Vf (water)-PT
P_210 = 0.048;  % CoffeinSimulation|Organism|Gonads|Albumin ratio (tissue/plasma)
P_211 = 0.5;  % CoffeinSimulation|Organism|Gonads|Albumin ratio (tissue/plasma)-PT
P_212 = 0.041;  % CoffeinSimulation|Organism|Gonads|Lipoprotein ratio (tissue/plasma)
P_213 = 0.8;  % CoffeinSimulation|Organism|Gonads|Vf (water)
P_214 = 0.06900000000000001;  % CoffeinSimulation|Organism|Gonads|Fraction interstitial
P_215 = 0.0048;  % CoffeinSimulation|Organism|Gonads|Vf (neutral lipid)-RR
P_216 = 0;  % CoffeinSimulation|Organism|Gonads|Vf (neutral lipid)-WS
P_217 = 0.0116;  % CoffeinSimulation|Organism|Gonads|Vf (neutral phospholipid)-RR
P_218 = 0.0249;  % CoffeinSimulation|Organism|Gonads|Vf (neutral phospholipid, plasma)-WS
P_219 = 0.13;  % CoffeinSimulation|Organism|Gonads|Vf (protein)-WS
P_220 = 0.03;  % CoffeinSimulation|Organism|Gonads|Vf (extracellular water)-RR
P_221 = 0.78;  % CoffeinSimulation|Organism|Gonads|Vf (water)-WS
P_222 = 0.83;  % CoffeinSimulation|Organism|Gonads|Vf (intracellular water)-RR
P_223 = 0.0054;  % CoffeinSimulation|Organism|Gonads|Vf (acidic phospholipids)-WS
P_224 = 2.45;  % CoffeinSimulation|Organism|Gonads|Acidic phospholipids [mg/g] - RR
P_225 = 0.0402685905816942;  % CoffeinSimulation|Organism|Gonads|Volume
P_226 = 0.0806;  % CoffeinSimulation|Organism|Gonads|Specific blood flow rate
P_227 = 1;  % CoffeinSimulation|Organism|Gonads|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_228 = 1;  % CoffeinSimulation|Organism|Gonads|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_229 = 1;  % CoffeinSimulation|Organism|Gonads|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_230 = 1;  % CoffeinSimulation|Organism|Gonads|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_231 = 7;  % CoffeinSimulation|Organism|Gonads|Intracellular|pH
P_232 = 0.000295597484276729;  % CoffeinSimulation|Organism|Gonads|Intracellular|CYP1A2|Relative expression
P_233 = 0.000295597484276729;  % CoffeinSimulation|Organism|Gonads|Intracellular|CYP1A2|Relative expression (normalized)
P_234 = 1;  % CoffeinSimulation|Organism|Gonads|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_235 = 1;  % CoffeinSimulation|Organism|Gonads|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_236 = 1;  % CoffeinSimulation|Organism|Heart|Density (tissue)
P_237 = 0.96;  % CoffeinSimulation|Organism|Heart|Fluid recirculation flow proportionality factor
P_238 = 9.500000000000001e-05;  % CoffeinSimulation|Organism|Heart|Organ volume mouse
P_239 = 0.00147;  % CoffeinSimulation|Organism|Heart|Lymph flow proportionality factor
P_240 = 0.75;  % CoffeinSimulation|Organism|Heart|Allometric scale factor
P_241 = 1;  % CoffeinSimulation|Organism|Heart|Fraction of blood for sampling
P_242 = 4.5e-08;  % CoffeinSimulation|Organism|Heart|Radius (small pores)
P_243 = 2.5e-07;  % CoffeinSimulation|Organism|Heart|Radius (large pores)
P_244 = 0.05;  % CoffeinSimulation|Organism|Heart|Flow fraction via large pores
P_245 = 1.43333333333333e-11;  % CoffeinSimulation|Organism|Heart|Hydraulic conductivity
P_246 = 0.0115;  % CoffeinSimulation|Organism|Heart|Vf (neutral lipid)-PT
P_247 = 0.1;  % CoffeinSimulation|Organism|Heart|Vf (lipid)
P_248 = 0.14;  % CoffeinSimulation|Organism|Heart|Fraction vascular
P_249 = 0.0166;  % CoffeinSimulation|Organism|Heart|Vf (phospholipid)-PT
P_250 = 0.168;  % CoffeinSimulation|Organism|Heart|Vf (protein)
P_251 = 0.157;  % CoffeinSimulation|Organism|Heart|Albumin ratio (tissue/plasma)
P_252 = 0.5;  % CoffeinSimulation|Organism|Heart|Albumin ratio (tissue/plasma)-PT
P_253 = 0.16;  % CoffeinSimulation|Organism|Heart|Lipoprotein ratio (tissue/plasma)
P_254 = 0.731;  % CoffeinSimulation|Organism|Heart|Vf (water)
P_255 = 0.758;  % CoffeinSimulation|Organism|Heart|Vf (water)-PT
P_256 = 0.1;  % CoffeinSimulation|Organism|Heart|Fraction interstitial
P_257 = 0.0528;  % CoffeinSimulation|Organism|Heart|Vf (neutral lipid)-WS
P_258 = 0.0135;  % CoffeinSimulation|Organism|Heart|Vf (neutral lipid)-RR
P_259 = 0.0106;  % CoffeinSimulation|Organism|Heart|Vf (neutral phospholipid)-RR
P_260 = 0.0473;  % CoffeinSimulation|Organism|Heart|Vf (neutral phospholipid, plasma)-WS
P_261 = 0.32;  % CoffeinSimulation|Organism|Heart|Vf (extracellular water)-RR
P_262 = 0.19;  % CoffeinSimulation|Organism|Heart|Vf (protein)-WS
P_263 = 0.7;  % CoffeinSimulation|Organism|Heart|Vf (water)-WS
P_264 = 0.248;  % CoffeinSimulation|Organism|Heart|Vf (intracellular water)-RR
P_265 = 2.25;  % CoffeinSimulation|Organism|Heart|Acidic phospholipids [mg/g] - RR
P_266 = 0.009900000000000001;  % CoffeinSimulation|Organism|Heart|Vf (acidic phospholipids)-WS
P_267 = 0.41764041794364;  % CoffeinSimulation|Organism|Heart|Volume
P_268 = 0.62335;  % CoffeinSimulation|Organism|Heart|Specific blood flow rate
P_269 = 1;  % CoffeinSimulation|Organism|Heart|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_270 = 1;  % CoffeinSimulation|Organism|Heart|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_271 = 1;  % CoffeinSimulation|Organism|Heart|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_272 = 1;  % CoffeinSimulation|Organism|Heart|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_273 = 7.1;  % CoffeinSimulation|Organism|Heart|Intracellular|pH
P_274 = 0;  % CoffeinSimulation|Organism|Heart|Intracellular|CYP1A2|Relative expression
P_275 = 0;  % CoffeinSimulation|Organism|Heart|Intracellular|CYP1A2|Relative expression (normalized)
P_276 = 1;  % CoffeinSimulation|Organism|Heart|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_277 = 1;  % CoffeinSimulation|Organism|Heart|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_278 = 1;  % CoffeinSimulation|Organism|Kidney|Renal aging scaling factor
P_279 = 1;  % CoffeinSimulation|Organism|Kidney|Density (tissue)
P_280 = 0.761;  % CoffeinSimulation|Organism|Kidney|Fluid recirculation flow proportionality factor
P_281 = 0.000709;  % CoffeinSimulation|Organism|Kidney|Lymph flow proportionality factor
P_282 = 0.00034;  % CoffeinSimulation|Organism|Kidney|Organ volume mouse
P_283 = 0.75;  % CoffeinSimulation|Organism|Kidney|Allometric scale factor
P_284 = 0.44;  % CoffeinSimulation|Organism|Kidney|Volume (standard kidney)
P_285 = 1;  % CoffeinSimulation|Organism|Kidney|Fraction of blood for sampling
P_286 = 4.5e-08;  % CoffeinSimulation|Organism|Kidney|Radius (small pores)
P_287 = 2.5e-07;  % CoffeinSimulation|Organism|Kidney|Radius (large pores)
P_288 = 1.53888888888889e-10;  % CoffeinSimulation|Organism|Kidney|Hydraulic conductivity
P_289 = 0.05;  % CoffeinSimulation|Organism|Kidney|Flow fraction via large pores
P_290 = 0.052;  % CoffeinSimulation|Organism|Kidney|Vf (lipid)
P_291 = 0.0207;  % CoffeinSimulation|Organism|Kidney|Vf (neutral lipid)-PT
P_292 = 0.23;  % CoffeinSimulation|Organism|Kidney|Fraction vascular
P_293 = 0.171;  % CoffeinSimulation|Organism|Kidney|Vf (protein)
P_294 = 0.0162;  % CoffeinSimulation|Organism|Kidney|Vf (phospholipid)-PT
P_295 = 0.5;  % CoffeinSimulation|Organism|Kidney|Albumin ratio (tissue/plasma)-PT
P_296 = 0.774;  % CoffeinSimulation|Organism|Kidney|Vf (water)
P_297 = 0.13;  % CoffeinSimulation|Organism|Kidney|Albumin ratio (tissue/plasma)
P_298 = 0.137;  % CoffeinSimulation|Organism|Kidney|Lipoprotein ratio (tissue/plasma)
P_299 = 0.783;  % CoffeinSimulation|Organism|Kidney|Vf (water)-PT
P_300 = 0.2;  % CoffeinSimulation|Organism|Kidney|Fraction interstitial
P_301 = 0.0156;  % CoffeinSimulation|Organism|Kidney|Vf (neutral lipid)-WS
P_302 = 0.0121;  % CoffeinSimulation|Organism|Kidney|Vf (neutral lipid)-RR
P_303 = 0.024;  % CoffeinSimulation|Organism|Kidney|Vf (neutral phospholipid)-RR
P_304 = 0.0366;  % CoffeinSimulation|Organism|Kidney|Vf (neutral phospholipid, plasma)-WS
P_305 = 0.273;  % CoffeinSimulation|Organism|Kidney|Vf (extracellular water)-RR
P_306 = 0.21;  % CoffeinSimulation|Organism|Kidney|Vf (protein)-WS
P_307 = 0.73;  % CoffeinSimulation|Organism|Kidney|Vf (water)-WS
P_308 = 0.399;  % CoffeinSimulation|Organism|Kidney|Vf (intracellular water)-RR
P_309 = 0.0078;  % CoffeinSimulation|Organism|Kidney|Vf (acidic phospholipids)-WS
P_310 = 5.03;  % CoffeinSimulation|Organism|Kidney|Acidic phospholipids [mg/g] - RR
P_311 = 0.258;  % CoffeinSimulation|Organism|Kidney|fGFRpremat
P_312 = 0.438488372656042;  % CoffeinSimulation|Organism|Kidney|Volume
P_313 = 0.9;  % CoffeinSimulation|Organism|Kidney|Maximal decreasing rate factor
P_314 = 44.4;  % CoffeinSimulation|Organism|Kidney|TM50 for GFR
P_315 = 30;  % CoffeinSimulation|Organism|Kidney|Age of aging onset
P_316 = 0.11704;  % CoffeinSimulation|Organism|Kidney|GFRmat
P_317 = 54;  % CoffeinSimulation|Organism|Kidney|Aging half-time
P_318 = 15;  % CoffeinSimulation|Organism|Kidney|Hill coefficient for GFR
P_319 = 1.5;  % CoffeinSimulation|Organism|Kidney|Hill coefficient for aging GFR
P_320 = 3.02705;  % CoffeinSimulation|Organism|Kidney|Specific blood flow rate
P_321 = 1;  % CoffeinSimulation|Organism|Kidney|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_322 = 1;  % CoffeinSimulation|Organism|Kidney|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_323 = 1;  % CoffeinSimulation|Organism|Kidney|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_324 = 1;  % CoffeinSimulation|Organism|Kidney|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_325 = 7.22;  % CoffeinSimulation|Organism|Kidney|Intracellular|pH
P_326 = 4.40251572327045e-06;  % CoffeinSimulation|Organism|Kidney|Intracellular|CYP1A2|Relative expression
P_327 = 4.40251572327045e-06;  % CoffeinSimulation|Organism|Kidney|Intracellular|CYP1A2|Relative expression (normalized)
P_328 = 1;  % CoffeinSimulation|Organism|Kidney|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_329 = 1;  % CoffeinSimulation|Organism|Kidney|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_330 = 1;  % CoffeinSimulation|Organism|Kidney|Urine|Volume
P_331 = 1;  % CoffeinSimulation|Organism|Lumen|OralApplicationsEnabled
P_332 = 1;  % CoffeinSimulation|Organism|Lumen|Paracellular absorption sink condition
P_333 = 1;  % CoffeinSimulation|Organism|Lumen|Transcellular absorption sink condition
P_334 = 1.00000000260982;  % CoffeinSimulation|Organism|Lumen|Effective surface area variability factor
P_335 = 0;  % CoffeinSimulation|Organism|Lumen|Stomach|Absorption of liquid
P_336 = 60;  % CoffeinSimulation|Organism|Lumen|Stomach|GET of non-disintegrated moiety
P_337 = 0.022668;  % CoffeinSimulation|Organism|Lumen|Stomach|Thickness of gut wall
P_338 = 0.030169;  % CoffeinSimulation|Organism|Lumen|Stomach|Fractional steady state fill level
P_339 = 5.5;  % CoffeinSimulation|Organism|Lumen|Stomach|pH in fed state
P_340 = 2;  % CoffeinSimulation|Organism|Lumen|Stomach|pH in fasted state
P_341 = 15;  % CoffeinSimulation|Organism|Lumen|Stomach|Inverse rate of inflow of liquid into stomach
P_342 = 0.5;  % CoffeinSimulation|Organism|Lumen|Stomach|Distal radius
P_343 = 0.999999963215789;  % CoffeinSimulation|Organism|Lumen|Stomach|GET_beta (Weibull function) variability factor
P_344 = 15.0000000391473;  % CoffeinSimulation|Organism|Lumen|Stomach|Gastric emptying time
P_345 = 1.00000002079922;  % CoffeinSimulation|Organism|Lumen|Stomach|GET_alpha (Weibull function) variability factor
P_346 = 2;  % CoffeinSimulation|Organism|Lumen|Stomach|Length
P_347 = 0.5;  % CoffeinSimulation|Organism|Lumen|Stomach|Proximal radius
P_348 = 0;  % CoffeinSimulation|Organism|Lumen|Stomach|CYP1A2|Relative expression
P_349 = 0;  % CoffeinSimulation|Organism|Lumen|Stomach|CYP1A2|Relative expression (normalized)
P_350 = 1;  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine|Partition coefficient (water/container)
P_351 = 1;  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine-CYP1A2-MM|Km interaction factor
P_352 = 1;  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine-CYP1A2-MM|kcat interaction factor
P_353 = 25;  % CoffeinSimulation|Organism|Lumen|Duodenum|Microvilli factor
P_354 = -0.0289872252;  % CoffeinSimulation|Organism|Lumen|Duodenum|L_p0
P_355 = 116;  % CoffeinSimulation|Organism|Lumen|Duodenum|Intestinal transit rate
P_356 = 0.06;  % CoffeinSimulation|Organism|Lumen|Duodenum|Fractional steady state fill level
P_357 = -0.002264627;  % CoffeinSimulation|Organism|Lumen|Duodenum|r1_p0
P_358 = 0.129622362;  % CoffeinSimulation|Organism|Lumen|Duodenum|L_p1
P_359 = -0.30705627;  % CoffeinSimulation|Organism|Lumen|Duodenum|Thickness_p3
P_360 = 0.0441002752;  % CoffeinSimulation|Organism|Lumen|Duodenum|Thickness_p2
P_361 = -0.0186500479;  % CoffeinSimulation|Organism|Lumen|Duodenum|Thickness_p1
P_362 = 0.00925874;  % CoffeinSimulation|Organism|Lumen|Duodenum|r2_p1
P_363 = -0.0020705161;  % CoffeinSimulation|Organism|Lumen|Duodenum|r2_p0
P_364 = 0.010126747;  % CoffeinSimulation|Organism|Lumen|Duodenum|r1_p1
P_365 = 6;  % CoffeinSimulation|Organism|Lumen|Duodenum|pH
P_366 = 292.6883;  % CoffeinSimulation|Organism|Lumen|Duodenum|Effective surface area enhancement factor
P_367 = 0;  % CoffeinSimulation|Organism|Lumen|Duodenum|CYP1A2|Relative expression
P_368 = 0;  % CoffeinSimulation|Organism|Lumen|Duodenum|CYP1A2|Relative expression (normalized)
P_369 = 1;  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine|Partition coefficient (water/container)
P_370 = 1;  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine-CYP1A2-MM|Km interaction factor
P_371 = 1;  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine-CYP1A2-MM|kcat interaction factor
P_372 = 0.00925874;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|r1_p1
P_373 = -0.0020705161;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|r1_p0
P_374 = 25;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Microvilli factor
P_375 = 0.299751712;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|L_p1
P_376 = -0.06703295820000001;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|L_p0
P_377 = 0.008680069;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|r2_p1
P_378 = 0.064841;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Fractional steady state fill level
P_379 = -0.024936327;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Thickness_p1
P_380 = 5.0162;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Intestinal transit rate
P_381 = -0.0019411088;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|r2_p0
P_382 = -0.30703115;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Thickness_p3
P_383 = 0.0589752766;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Thickness_p2
P_384 = 6.25;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|pH
P_385 = 447.9877;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Effective surface area enhancement factor
P_386 = 0;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|CYP1A2|Relative expression
P_387 = 0;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|CYP1A2|Relative expression (normalized)
P_388 = 1;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine|Partition coefficient (water/container)
P_389 = 1;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine-CYP1A2-MM|Km interaction factor
P_390 = 1;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine-CYP1A2-MM|kcat interaction factor
P_391 = -0.30703115;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Thickness_p3
P_392 = 0.299751712;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|L_p1
P_393 = 0.0465856499;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Thickness_p2
P_394 = -0.0196976609;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Thickness_p1
P_395 = 0.008101397999999999;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|r2_p1
P_396 = -0.0018117016;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|r2_p0
P_397 = 0.008680069;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|r1_p1
P_398 = 25;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Microvilli factor
P_399 = -0.06703295820000001;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|L_p0
P_400 = 5.0162;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Intestinal transit rate
P_401 = 0.064841;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Fractional steady state fill level
P_402 = -0.0019411088;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|r1_p0
P_403 = 6.9167;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|pH
P_404 = 372.9358;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Effective surface area enhancement factor
P_405 = 0;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|CYP1A2|Relative expression
P_406 = 0;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|CYP1A2|Relative expression (normalized)
P_407 = 1;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine|Partition coefficient (water/container)
P_408 = 1;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine-CYP1A2-MM|Km interaction factor
P_409 = 1;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine-CYP1A2-MM|kcat interaction factor
P_410 = -0.0015528871;  % CoffeinSimulation|Organism|Lumen|UpperIleum|r2_p0
P_411 = -0.30703115;  % CoffeinSimulation|Organism|Lumen|UpperIleum|Thickness_p3
P_412 = 0.061552122;  % CoffeinSimulation|Organism|Lumen|UpperIleum|Thickness_p2
P_413 = 0.006944055;  % CoffeinSimulation|Organism|Lumen|UpperIleum|r2_p1
P_414 = 0.008101397999999999;  % CoffeinSimulation|Organism|Lumen|UpperIleum|r1_p1
P_415 = -0.0018117016;  % CoffeinSimulation|Organism|Lumen|UpperIleum|r1_p0
P_416 = 25;  % CoffeinSimulation|Organism|Lumen|UpperIleum|Microvilli factor
P_417 = 0.445576869;  % CoffeinSimulation|Organism|Lumen|UpperIleum|L_p1
P_418 = -0.0996435866;  % CoffeinSimulation|Organism|Lumen|UpperIleum|L_p0
P_419 = 3.3745;  % CoffeinSimulation|Organism|Lumen|UpperIleum|Intestinal transit rate
P_420 = -0.0260258863;  % CoffeinSimulation|Organism|Lumen|UpperIleum|Thickness_p1
P_421 = 0.064841;  % CoffeinSimulation|Organism|Lumen|UpperIleum|Fractional steady state fill level
P_422 = 7.2083;  % CoffeinSimulation|Organism|Lumen|UpperIleum|pH
P_423 = 260.7527;  % CoffeinSimulation|Organism|Lumen|UpperIleum|Effective surface area enhancement factor
P_424 = 0;  % CoffeinSimulation|Organism|Lumen|UpperIleum|CYP1A2|Relative expression
P_425 = 0;  % CoffeinSimulation|Organism|Lumen|UpperIleum|CYP1A2|Relative expression (normalized)
P_426 = 1;  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine|Partition coefficient (water/container)
P_427 = 1;  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine-CYP1A2-MM|Km interaction factor
P_428 = 1;  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine-CYP1A2-MM|kcat interaction factor
P_429 = 3.3745;  % CoffeinSimulation|Organism|Lumen|LowerIleum|Intestinal transit rate
P_430 = 0.064841;  % CoffeinSimulation|Organism|Lumen|LowerIleum|Fractional steady state fill level
P_431 = 25;  % CoffeinSimulation|Organism|Lumen|LowerIleum|Microvilli factor
P_432 = -0.0148137399;  % CoffeinSimulation|Organism|Lumen|LowerIleum|Thickness_p1
P_433 = -0.0996435866;  % CoffeinSimulation|Organism|Lumen|LowerIleum|L_p0
P_434 = 0.0350288649;  % CoffeinSimulation|Organism|Lumen|LowerIleum|Thickness_p2
P_435 = 0.445576869;  % CoffeinSimulation|Organism|Lumen|LowerIleum|L_p1
P_436 = 0.005786713;  % CoffeinSimulation|Organism|Lumen|LowerIleum|r2_p1
P_437 = -0.0012940725;  % CoffeinSimulation|Organism|Lumen|LowerIleum|r2_p0
P_438 = 0.006944055;  % CoffeinSimulation|Organism|Lumen|LowerIleum|r1_p1
P_439 = -0.0015528871;  % CoffeinSimulation|Organism|Lumen|LowerIleum|r1_p0
P_440 = 7.4583;  % CoffeinSimulation|Organism|Lumen|LowerIleum|pH
P_441 = -0.30705627;  % CoffeinSimulation|Organism|Lumen|LowerIleum|Thickness_p3
P_442 = 146.565;  % CoffeinSimulation|Organism|Lumen|LowerIleum|Effective surface area enhancement factor
P_443 = 0;  % CoffeinSimulation|Organism|Lumen|LowerIleum|CYP1A2|Relative expression
P_444 = 0;  % CoffeinSimulation|Organism|Lumen|LowerIleum|CYP1A2|Relative expression (normalized)
P_445 = 1;  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine|Partition coefficient (water/container)
P_446 = 1;  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine-CYP1A2-MM|Km interaction factor
P_447 = 1;  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine-CYP1A2-MM|kcat interaction factor
P_448 = 0.015672726;  % CoffeinSimulation|Organism|Lumen|Caecum|r1_p1
P_449 = -0.08978849999999999;  % CoffeinSimulation|Organism|Lumen|Caecum|Thickness_p3
P_450 = 0.0446435379;  % CoffeinSimulation|Organism|Lumen|Caecum|Thickness_p2
P_451 = -0.00877;  % CoffeinSimulation|Organism|Lumen|Caecum|Thickness_p1
P_452 = 0.015672726;  % CoffeinSimulation|Organism|Lumen|Caecum|r2_p1
P_453 = 0.067256381;  % CoffeinSimulation|Organism|Lumen|Caecum|r1_p0
P_454 = 0.067256381;  % CoffeinSimulation|Organism|Lumen|Caecum|r2_p0
P_455 = 1;  % CoffeinSimulation|Organism|Lumen|Caecum|Microvilli factor
P_456 = 0.026864843;  % CoffeinSimulation|Organism|Lumen|Caecum|L_p1
P_457 = 0.1152851235;  % CoffeinSimulation|Organism|Lumen|Caecum|L_p0
P_458 = 18.3333;  % CoffeinSimulation|Organism|Lumen|Caecum|Intestinal transit rate
P_459 = 0.0060009;  % CoffeinSimulation|Organism|Lumen|Caecum|Fractional steady state fill level
P_460 = 5.7;  % CoffeinSimulation|Organism|Lumen|Caecum|pH
P_461 = 1.8;  % CoffeinSimulation|Organism|Lumen|Caecum|Effective surface area enhancement factor
P_462 = 0;  % CoffeinSimulation|Organism|Lumen|Caecum|CYP1A2|Relative expression
P_463 = 0;  % CoffeinSimulation|Organism|Lumen|Caecum|CYP1A2|Relative expression (normalized)
P_464 = 1;  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine|Partition coefficient (water/container)
P_465 = 1;  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine-CYP1A2-MM|Km interaction factor
P_466 = 1;  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine-CYP1A2-MM|kcat interaction factor
P_467 = 0.0060009;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Fractional steady state fill level
P_468 = 0.015672726;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|r1_p1
P_469 = 0.067256381;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|r1_p0
P_470 = 5.6;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|pH
P_471 = 1;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Microvilli factor
P_472 = 0.075727844;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|L_p1
P_473 = 0.015672726;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|r2_p1
P_474 = 10;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Intestinal transit rate
P_475 = -0.00554;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Thickness_p1
P_476 = 0.3117189273;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|L_p0
P_477 = 0.067256381;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|r2_p0
P_478 = -0.09106073000000001;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Thickness_p3
P_479 = 0.0280138174;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Thickness_p2
P_480 = 2.5;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Effective surface area enhancement factor
P_481 = 0;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|CYP1A2|Relative expression
P_482 = 0;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|CYP1A2|Relative expression (normalized)
P_483 = 1;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine|Partition coefficient (water/container)
P_484 = 1;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine-CYP1A2-MM|Km interaction factor
P_485 = 1;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine-CYP1A2-MM|kcat interaction factor
P_486 = 0.0394956146;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Thickness_p2
P_487 = 0.144607745;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|L_p1
P_488 = -0.0076;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Thickness_p1
P_489 = 0.008955843;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|r2_p1
P_490 = 0.0384322177;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|r2_p0
P_491 = 0.015672726;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|r1_p1
P_492 = 0.067256381;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|r1_p0
P_493 = 1;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Microvilli factor
P_494 = -0.08637087;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Thickness_p3
P_495 = 0.6886041141;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|L_p0
P_496 = 3.3333;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Intestinal transit rate
P_497 = 0.0060009;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Fractional steady state fill level
P_498 = 5.7;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|pH
P_499 = 2.5;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Effective surface area enhancement factor
P_500 = 0;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|CYP1A2|Relative expression
P_501 = 0;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|CYP1A2|Relative expression (normalized)
P_502 = 1;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine|Partition coefficient (water/container)
P_503 = 1;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine-CYP1A2-MM|Km interaction factor
P_504 = 1;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine-CYP1A2-MM|kcat interaction factor
P_505 = 0.0384322177;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|r1_p0
P_506 = -0.08977747;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Thickness_p3
P_507 = 0.0601543776;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Thickness_p2
P_508 = -0.0118;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Thickness_p1
P_509 = 0.008955843;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|r2_p1
P_510 = 0.008955843;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|r1_p1
P_511 = 6.6;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|pH
P_512 = 1;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Microvilli factor
P_513 = 0.098514277;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|L_p1
P_514 = 0.4227543951;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|L_p0
P_515 = 5;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Intestinal transit rate
P_516 = 0.0060009;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Fractional steady state fill level
P_517 = 0.0384322177;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|r2_p0
P_518 = 2.5;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Effective surface area enhancement factor
P_519 = 0;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|CYP1A2|Relative expression
P_520 = 0;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|CYP1A2|Relative expression (normalized)
P_521 = 1;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine|Partition coefficient (water/container)
P_522 = 1;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine-CYP1A2-MM|Km interaction factor
P_523 = 1;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine-CYP1A2-MM|kcat interaction factor
P_524 = 0.5337898629;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|L_p0
P_525 = 0.0384322177;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|r2_p0
P_526 = -0.08890140000000001;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Thickness_p3
P_527 = 0.0274432593;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Thickness_p2
P_528 = 0.0060009;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Fractional steady state fill level
P_529 = 0.008955843;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|r2_p1
P_530 = 4.0741;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Intestinal transit rate
P_531 = 0.008955843;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|r1_p1
P_532 = 0.0384322177;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|r1_p0
P_533 = 6.6;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|pH
P_534 = 1;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Microvilli factor
P_535 = 0.121300709;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|L_p1
P_536 = -0.00536;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Thickness_p1
P_537 = 2.5;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Effective surface area enhancement factor
P_538 = 0;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|CYP1A2|Relative expression
P_539 = 0;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|CYP1A2|Relative expression (normalized)
P_540 = 1;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine|Partition coefficient (water/container)
P_541 = 1;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine-CYP1A2-MM|Km interaction factor
P_542 = 1;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine-CYP1A2-MM|kcat interaction factor
P_543 = 0.052420808;  % CoffeinSimulation|Organism|Lumen|Rectum|L_p1
P_544 = 315.618;  % CoffeinSimulation|Organism|Lumen|Rectum|Intestinal transit rate
P_545 = 0.0060009;  % CoffeinSimulation|Organism|Lumen|Rectum|Fractional steady state fill level
P_546 = 1;  % CoffeinSimulation|Organism|Lumen|Rectum|Microvilli factor
P_547 = 0.1569046761;  % CoffeinSimulation|Organism|Lumen|Rectum|L_p0
P_548 = 0.0324721331;  % CoffeinSimulation|Organism|Lumen|Rectum|Thickness_p2
P_549 = -0.10014267;  % CoffeinSimulation|Organism|Lumen|Rectum|Thickness_p3
P_550 = -0.00665;  % CoffeinSimulation|Organism|Lumen|Rectum|Thickness_p1
P_551 = 0.005597402;  % CoffeinSimulation|Organism|Lumen|Rectum|r2_p1
P_552 = 0.0240201361;  % CoffeinSimulation|Organism|Lumen|Rectum|r2_p0
P_553 = 0.008955843;  % CoffeinSimulation|Organism|Lumen|Rectum|r1_p1
P_554 = 0.0384322177;  % CoffeinSimulation|Organism|Lumen|Rectum|r1_p0
P_555 = 6.6;  % CoffeinSimulation|Organism|Lumen|Rectum|pH
P_556 = 3.56;  % CoffeinSimulation|Organism|Lumen|Rectum|Effective surface area enhancement factor
P_557 = 0;  % CoffeinSimulation|Organism|Lumen|Rectum|CYP1A2|Relative expression
P_558 = 0;  % CoffeinSimulation|Organism|Lumen|Rectum|CYP1A2|Relative expression (normalized)
P_559 = 1;  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine|Partition coefficient (water/container)
P_560 = 1;  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine-CYP1A2-MM|Km interaction factor
P_561 = 1;  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine-CYP1A2-MM|kcat interaction factor
P_562 = 1;  % CoffeinSimulation|Organism|Lumen|Feces|Volume
P_563 = 1;  % CoffeinSimulation|Organism|Stomach|Density (tissue)
P_564 = 0.96;  % CoffeinSimulation|Organism|Stomach|Fluid recirculation flow proportionality factor
P_565 = 0.00204;  % CoffeinSimulation|Organism|Stomach|Lymph flow proportionality factor
P_566 = 0.00011;  % CoffeinSimulation|Organism|Stomach|Organ volume mouse
P_567 = 0.75;  % CoffeinSimulation|Organism|Stomach|Allometric scale factor
P_568 = 1;  % CoffeinSimulation|Organism|Stomach|Fraction of blood for sampling
P_569 = 3.97222222222222e-11;  % CoffeinSimulation|Organism|Stomach|Hydraulic conductivity
P_570 = 0.05;  % CoffeinSimulation|Organism|Stomach|Flow fraction via large pores
P_571 = 4.5e-08;  % CoffeinSimulation|Organism|Stomach|Radius (small pores)
P_572 = 2.5e-07;  % CoffeinSimulation|Organism|Stomach|Radius (large pores)
P_573 = 0.0487;  % CoffeinSimulation|Organism|Stomach|Vf (neutral lipid)-PT
P_574 = 0.062;  % CoffeinSimulation|Organism|Stomach|Vf (lipid)
P_575 = 0.032;  % CoffeinSimulation|Organism|Stomach|Fraction vascular
P_576 = 0.133;  % CoffeinSimulation|Organism|Stomach|Vf (protein)
P_577 = 0.0163;  % CoffeinSimulation|Organism|Stomach|Vf (phospholipid)-PT
P_578 = 0.718;  % CoffeinSimulation|Organism|Stomach|Vf (water)-PT
P_579 = 0.158;  % CoffeinSimulation|Organism|Stomach|Albumin ratio (tissue/plasma)
P_580 = 0.5;  % CoffeinSimulation|Organism|Stomach|Albumin ratio (tissue/plasma)-PT
P_581 = 0.141;  % CoffeinSimulation|Organism|Stomach|Lipoprotein ratio (tissue/plasma)
P_582 = 0.792;  % CoffeinSimulation|Organism|Stomach|Vf (water)
P_583 = 0.1;  % CoffeinSimulation|Organism|Stomach|Fraction interstitial
P_584 = 0.0375;  % CoffeinSimulation|Organism|Stomach|Vf (neutral lipid)-RR
P_585 = 0.0483;  % CoffeinSimulation|Organism|Stomach|Vf (neutral lipid)-WS
P_586 = 0.0124;  % CoffeinSimulation|Organism|Stomach|Vf (neutral phospholipid)-RR
P_587 = 0.0182;  % CoffeinSimulation|Organism|Stomach|Vf (neutral phospholipid, plasma)-WS
P_588 = 0.282;  % CoffeinSimulation|Organism|Stomach|Vf (extracellular water)-RR
P_589 = 0.15;  % CoffeinSimulation|Organism|Stomach|Vf (protein)-WS
P_590 = 0.456;  % CoffeinSimulation|Organism|Stomach|Vf (intracellular water)-RR
P_591 = 0.78;  % CoffeinSimulation|Organism|Stomach|Vf (water)-WS
P_592 = 0.0035;  % CoffeinSimulation|Organism|Stomach|Vf (acidic phospholipids)-WS
P_593 = 2.41;  % CoffeinSimulation|Organism|Stomach|Acidic phospholipids [mg/g] - RR
P_594 = 0.168515096759977;  % CoffeinSimulation|Organism|Stomach|Volume
P_595 = 0.3861;  % CoffeinSimulation|Organism|Stomach|Specific blood flow rate
P_596 = 1;  % CoffeinSimulation|Organism|Stomach|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_597 = 1;  % CoffeinSimulation|Organism|Stomach|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_598 = 1;  % CoffeinSimulation|Organism|Stomach|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_599 = 1;  % CoffeinSimulation|Organism|Stomach|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_600 = 7.4;  % CoffeinSimulation|Organism|Stomach|Intracellular|pH
P_601 = 0;  % CoffeinSimulation|Organism|Stomach|Intracellular|CYP1A2|Relative expression
P_602 = 0;  % CoffeinSimulation|Organism|Stomach|Intracellular|CYP1A2|Relative expression (normalized)
P_603 = 1;  % CoffeinSimulation|Organism|Stomach|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_604 = 1;  % CoffeinSimulation|Organism|Stomach|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_605 = 0.001406;  % CoffeinSimulation|Organism|SmallIntestine|Organ volume mouse
P_606 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Density (tissue)
P_607 = 0.00195;  % CoffeinSimulation|Organism|SmallIntestine|Lymph flow proportionality factor
P_608 = 0.179;  % CoffeinSimulation|Organism|SmallIntestine|Fluid recirculation flow proportionality factor
P_609 = 0.75;  % CoffeinSimulation|Organism|SmallIntestine|Allometric scale factor
P_610 = 0.602;  % CoffeinSimulation|Organism|SmallIntestine|Small intestinal transit time factor slope
P_611 = 0.75;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa blood flow fraction
P_612 = -4.52;  % CoffeinSimulation|Organism|SmallIntestine|Small intestinal transit time factor intercept
P_613 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Fraction of blood for sampling
P_614 = 0.05;  % CoffeinSimulation|Organism|SmallIntestine|Flow fraction via large pores
P_615 = 2.5e-07;  % CoffeinSimulation|Organism|SmallIntestine|Radius (large pores)
P_616 = 1.53888888888889e-10;  % CoffeinSimulation|Organism|SmallIntestine|Hydraulic conductivity
P_617 = 4.5e-08;  % CoffeinSimulation|Organism|SmallIntestine|Radius (small pores)
P_618 = 0.062;  % CoffeinSimulation|Organism|SmallIntestine|Vf (lipid)
P_619 = 0.0487;  % CoffeinSimulation|Organism|SmallIntestine|Vf (neutral lipid)-PT
P_620 = 0.024;  % CoffeinSimulation|Organism|SmallIntestine|Fraction vascular
P_621 = 0.0163;  % CoffeinSimulation|Organism|SmallIntestine|Vf (phospholipid)-PT
P_622 = 0.133;  % CoffeinSimulation|Organism|SmallIntestine|Vf (protein)
P_623 = 0.792;  % CoffeinSimulation|Organism|SmallIntestine|Vf (water)
P_624 = 0.141;  % CoffeinSimulation|Organism|SmallIntestine|Lipoprotein ratio (tissue/plasma)
P_625 = 0.158;  % CoffeinSimulation|Organism|SmallIntestine|Albumin ratio (tissue/plasma)
P_626 = 0.718;  % CoffeinSimulation|Organism|SmallIntestine|Vf (water)-PT
P_627 = 0.5;  % CoffeinSimulation|Organism|SmallIntestine|Albumin ratio (tissue/plasma)-PT
P_628 = 0.094;  % CoffeinSimulation|Organism|SmallIntestine|Fraction interstitial
P_629 = 0.0375;  % CoffeinSimulation|Organism|SmallIntestine|Vf (neutral lipid)-RR
P_630 = 0.0483;  % CoffeinSimulation|Organism|SmallIntestine|Vf (neutral lipid)-WS
P_631 = 0.0124;  % CoffeinSimulation|Organism|SmallIntestine|Vf (neutral phospholipid)-RR
P_632 = 0.0182;  % CoffeinSimulation|Organism|SmallIntestine|Vf (neutral phospholipid, plasma)-WS
P_633 = 0.15;  % CoffeinSimulation|Organism|SmallIntestine|Vf (protein)-WS
P_634 = 0.282;  % CoffeinSimulation|Organism|SmallIntestine|Vf (extracellular water)-RR
P_635 = 0.456;  % CoffeinSimulation|Organism|SmallIntestine|Vf (intracellular water)-RR
P_636 = 0.78;  % CoffeinSimulation|Organism|SmallIntestine|Vf (water)-WS
P_637 = 2.41;  % CoffeinSimulation|Organism|SmallIntestine|Acidic phospholipids [mg/g] - RR
P_638 = 0.0035;  % CoffeinSimulation|Organism|SmallIntestine|Vf (acidic phospholipids)-WS
P_639 = 126.000000328837;  % CoffeinSimulation|Organism|SmallIntestine|Small intestinal transit time
P_640 = 0.72454704410184;  % CoffeinSimulation|Organism|SmallIntestine|Volume
P_641 = 0.8976499999999999;  % CoffeinSimulation|Organism|SmallIntestine|Specific blood flow rate
P_642 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_643 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_644 = 1;  % CoffeinSimulation|Organism|SmallIntestine|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_645 = 1;  % CoffeinSimulation|Organism|SmallIntestine|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_646 = 7.4;  % CoffeinSimulation|Organism|SmallIntestine|Intracellular|pH
P_647 = 0;  % CoffeinSimulation|Organism|SmallIntestine|Intracellular|CYP1A2|Relative expression
P_648 = 0;  % CoffeinSimulation|Organism|SmallIntestine|Intracellular|CYP1A2|Relative expression (normalized)
P_649 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_650 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_651 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Density (tissue)
P_652 = 0.093;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Fraction of regional blood flow rate
P_653 = 0.26;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Fraction mucosa
P_654 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Fraction of blood for sampling
P_655 = 0.05;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Flow fraction via large pores
P_656 = 1.53888888888889e-10;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Hydraulic conductivity
P_657 = 2.5e-07;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Radius (large pores)
P_658 = 4.5e-08;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Radius (small pores)
P_659 = 0.06;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Vf (lipid)
P_660 = 0.0487;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Vf (neutral lipid)-PT
P_661 = 0.13;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Fraction vascular
P_662 = 0.0163;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Vf (phospholipid)-PT
P_663 = 0.08;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Vf (protein)
P_664 = 0.5;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Albumin ratio (tissue/plasma)-PT
P_665 = 0.141;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Lipoprotein ratio (tissue/plasma)
P_666 = 0.158;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Albumin ratio (tissue/plasma)
P_667 = 0.8;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Vf (water)
P_668 = 0.718;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Vf (water)-PT
P_669 = 0.42;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Fraction interstitial
P_670 = 0.0483;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Vf (neutral lipid)-WS
P_671 = 0.0375;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Vf (neutral lipid)-RR
P_672 = 0.0124;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Vf (neutral phospholipid)-RR
P_673 = 0.0182;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Vf (neutral phospholipid, plasma)-WS
P_674 = 0.15;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Vf (protein)-WS
P_675 = 0.282;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Vf (extracellular water)-RR
P_676 = 0.456;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Vf (intracellular water)-RR
P_677 = 0.78;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Vf (water)-WS
P_678 = 0.0035;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Vf (acidic phospholipids)-WS
P_679 = 2.41;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Acidic phospholipids [mg/g] - RR
P_680 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_681 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_682 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_683 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_684 = 7.3;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Intracellular|pH
P_685 = 0;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Intracellular|CYP1A2|Relative expression
P_686 = 0;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Intracellular|CYP1A2|Relative expression (normalized)
P_687 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_688 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_689 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Density (tissue)
P_690 = 0.219;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Fraction of regional blood flow rate
P_691 = 0.26;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Fraction mucosa
P_692 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Fraction of blood for sampling
P_693 = 1.53888888888889e-10;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Hydraulic conductivity
P_694 = 2.5e-07;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Radius (large pores)
P_695 = 4.5e-08;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Radius (small pores)
P_696 = 0.05;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Flow fraction via large pores
P_697 = 0.0487;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Vf (neutral lipid)-PT
P_698 = 0.06;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Vf (lipid)
P_699 = 0.13;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Fraction vascular
P_700 = 0.08;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Vf (protein)
P_701 = 0.0163;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Vf (phospholipid)-PT
P_702 = 0.718;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Vf (water)-PT
P_703 = 0.8;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Vf (water)
P_704 = 0.158;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Albumin ratio (tissue/plasma)
P_705 = 0.5;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Albumin ratio (tissue/plasma)-PT
P_706 = 0.141;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Lipoprotein ratio (tissue/plasma)
P_707 = 0.35;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Fraction interstitial
P_708 = 0.0375;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Vf (neutral lipid)-RR
P_709 = 0.0483;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Vf (neutral lipid)-WS
P_710 = 0.0182;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Vf (neutral phospholipid, plasma)-WS
P_711 = 0.0124;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Vf (neutral phospholipid)-RR
P_712 = 0.15;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Vf (protein)-WS
P_713 = 0.282;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Vf (extracellular water)-RR
P_714 = 0.78;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Vf (water)-WS
P_715 = 0.456;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Vf (intracellular water)-RR
P_716 = 2.41;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Acidic phospholipids [mg/g] - RR
P_717 = 0.0035;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Vf (acidic phospholipids)-WS
P_718 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_719 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_720 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_721 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_722 = 7.3;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Intracellular|pH
P_723 = 0;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Intracellular|CYP1A2|Relative expression
P_724 = 0;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Intracellular|CYP1A2|Relative expression (normalized)
P_725 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_726 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_727 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Density (tissue)
P_728 = 0.219;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Fraction of regional blood flow rate
P_729 = 0.26;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Fraction mucosa
P_730 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Fraction of blood for sampling
P_731 = 0.05;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Flow fraction via large pores
P_732 = 1.53888888888889e-10;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Hydraulic conductivity
P_733 = 2.5e-07;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Radius (large pores)
P_734 = 4.5e-08;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Radius (small pores)
P_735 = 0.0487;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Vf (neutral lipid)-PT
P_736 = 0.06;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Vf (lipid)
P_737 = 0.13;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Fraction vascular
P_738 = 0.08;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Vf (protein)
P_739 = 0.0163;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Vf (phospholipid)-PT
P_740 = 0.158;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Albumin ratio (tissue/plasma)
P_741 = 0.8;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Vf (water)
P_742 = 0.141;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Lipoprotein ratio (tissue/plasma)
P_743 = 0.718;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Vf (water)-PT
P_744 = 0.5;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Albumin ratio (tissue/plasma)-PT
P_745 = 0.32;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Fraction interstitial
P_746 = 0.0483;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Vf (neutral lipid)-WS
P_747 = 0.0375;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Vf (neutral lipid)-RR
P_748 = 0.0182;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Vf (neutral phospholipid, plasma)-WS
P_749 = 0.0124;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Vf (neutral phospholipid)-RR
P_750 = 0.15;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Vf (protein)-WS
P_751 = 0.282;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Vf (extracellular water)-RR
P_752 = 0.456;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Vf (intracellular water)-RR
P_753 = 0.78;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Vf (water)-WS
P_754 = 2.41;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Acidic phospholipids [mg/g] - RR
P_755 = 0.0035;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Vf (acidic phospholipids)-WS
P_756 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_757 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_758 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_759 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_760 = 7.3;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Intracellular|pH
P_761 = 0;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Intracellular|CYP1A2|Relative expression
P_762 = 0;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Intracellular|CYP1A2|Relative expression (normalized)
P_763 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_764 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_765 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Density (tissue)
P_766 = 0.13;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Fraction mucosa
P_767 = 0.2345;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Fraction of regional blood flow rate
P_768 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Fraction of blood for sampling
P_769 = 4.5e-08;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Radius (small pores)
P_770 = 0.05;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Flow fraction via large pores
P_771 = 2.5e-07;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Radius (large pores)
P_772 = 1.53888888888889e-10;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Hydraulic conductivity
P_773 = 0.06;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Vf (lipid)
P_774 = 0.0487;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Vf (neutral lipid)-PT
P_775 = 0.13;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Fraction vascular
P_776 = 0.0163;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Vf (phospholipid)-PT
P_777 = 0.08;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Vf (protein)
P_778 = 0.141;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Lipoprotein ratio (tissue/plasma)
P_779 = 0.718;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Vf (water)-PT
P_780 = 0.8;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Vf (water)
P_781 = 0.5;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Albumin ratio (tissue/plasma)-PT
P_782 = 0.158;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Albumin ratio (tissue/plasma)
P_783 = 0.31;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Fraction interstitial
P_784 = 0.0483;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Vf (neutral lipid)-WS
P_785 = 0.0375;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Vf (neutral lipid)-RR
P_786 = 0.0182;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Vf (neutral phospholipid, plasma)-WS
P_787 = 0.0124;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Vf (neutral phospholipid)-RR
P_788 = 0.282;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Vf (extracellular water)-RR
P_789 = 0.15;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Vf (protein)-WS
P_790 = 0.456;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Vf (intracellular water)-RR
P_791 = 0.78;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Vf (water)-WS
P_792 = 0.0035;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Vf (acidic phospholipids)-WS
P_793 = 2.41;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Acidic phospholipids [mg/g] - RR
P_794 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_795 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_796 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_797 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_798 = 7.3;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Intracellular|pH
P_799 = 0;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Intracellular|CYP1A2|Relative expression
P_800 = 0;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Intracellular|CYP1A2|Relative expression (normalized)
P_801 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_802 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_803 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Density (tissue)
P_804 = 0.2345;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Fraction of regional blood flow rate
P_805 = 0.13;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Fraction mucosa
P_806 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Fraction of blood for sampling
P_807 = 4.5e-08;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Radius (small pores)
P_808 = 1.53888888888889e-10;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Hydraulic conductivity
P_809 = 2.5e-07;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Radius (large pores)
P_810 = 0.05;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Flow fraction via large pores
P_811 = 0.0487;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Vf (neutral lipid)-PT
P_812 = 0.06;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Vf (lipid)
P_813 = 0.13;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Fraction vascular
P_814 = 0.08;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Vf (protein)
P_815 = 0.0163;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Vf (phospholipid)-PT
P_816 = 0.8;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Vf (water)
P_817 = 0.718;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Vf (water)-PT
P_818 = 0.141;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Lipoprotein ratio (tissue/plasma)
P_819 = 0.158;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Albumin ratio (tissue/plasma)
P_820 = 0.5;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Albumin ratio (tissue/plasma)-PT
P_821 = 0.32;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Fraction interstitial
P_822 = 0.0483;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Vf (neutral lipid)-WS
P_823 = 0.0375;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Vf (neutral lipid)-RR
P_824 = 0.0182;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Vf (neutral phospholipid, plasma)-WS
P_825 = 0.0124;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Vf (neutral phospholipid)-RR
P_826 = 0.282;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Vf (extracellular water)-RR
P_827 = 0.15;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Vf (protein)-WS
P_828 = 0.456;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Vf (intracellular water)-RR
P_829 = 0.78;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Vf (water)-WS
P_830 = 2.41;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Acidic phospholipids [mg/g] - RR
P_831 = 0.0035;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Vf (acidic phospholipids)-WS
P_832 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_833 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_834 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_835 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_836 = 7.3;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Intracellular|pH
P_837 = 0;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Intracellular|CYP1A2|Relative expression
P_838 = 0;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Intracellular|CYP1A2|Relative expression (normalized)
P_839 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_840 = 1;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_841 = 0.000627;  % CoffeinSimulation|Organism|LargeIntestine|Organ volume mouse
P_842 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Density (tissue)
P_843 = 0.179;  % CoffeinSimulation|Organism|LargeIntestine|Fluid recirculation flow proportionality factor
P_844 = 0.0144;  % CoffeinSimulation|Organism|LargeIntestine|Lymph flow proportionality factor
P_845 = 0.75;  % CoffeinSimulation|Organism|LargeIntestine|Allometric scale factor
P_846 = 0.75;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa blood flow fraction
P_847 = 0.9379999999999999;  % CoffeinSimulation|Organism|LargeIntestine|Large intestinal transit time factor slope
P_848 = 47.6;  % CoffeinSimulation|Organism|LargeIntestine|Large intestinal transit time factor intercept
P_849 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Fraction of blood for sampling
P_850 = 2.5e-07;  % CoffeinSimulation|Organism|LargeIntestine|Radius (large pores)
P_851 = 0.05;  % CoffeinSimulation|Organism|LargeIntestine|Flow fraction via large pores
P_852 = 4.5e-08;  % CoffeinSimulation|Organism|LargeIntestine|Radius (small pores)
P_853 = 1.86944444444444e-10;  % CoffeinSimulation|Organism|LargeIntestine|Hydraulic conductivity
P_854 = 0.062;  % CoffeinSimulation|Organism|LargeIntestine|Vf (lipid)
P_855 = 0.0487;  % CoffeinSimulation|Organism|LargeIntestine|Vf (neutral lipid)-PT
P_856 = 0.024;  % CoffeinSimulation|Organism|LargeIntestine|Fraction vascular
P_857 = 0.0163;  % CoffeinSimulation|Organism|LargeIntestine|Vf (phospholipid)-PT
P_858 = 0.133;  % CoffeinSimulation|Organism|LargeIntestine|Vf (protein)
P_859 = 0.158;  % CoffeinSimulation|Organism|LargeIntestine|Albumin ratio (tissue/plasma)
P_860 = 0.5;  % CoffeinSimulation|Organism|LargeIntestine|Albumin ratio (tissue/plasma)-PT
P_861 = 0.141;  % CoffeinSimulation|Organism|LargeIntestine|Lipoprotein ratio (tissue/plasma)
P_862 = 0.792;  % CoffeinSimulation|Organism|LargeIntestine|Vf (water)
P_863 = 0.718;  % CoffeinSimulation|Organism|LargeIntestine|Vf (water)-PT
P_864 = 0.094;  % CoffeinSimulation|Organism|LargeIntestine|Fraction interstitial
P_865 = 0.0375;  % CoffeinSimulation|Organism|LargeIntestine|Vf (neutral lipid)-RR
P_866 = 0.0483;  % CoffeinSimulation|Organism|LargeIntestine|Vf (neutral lipid)-WS
P_867 = 0.0182;  % CoffeinSimulation|Organism|LargeIntestine|Vf (neutral phospholipid, plasma)-WS
P_868 = 0.0124;  % CoffeinSimulation|Organism|LargeIntestine|Vf (neutral phospholipid)-RR
P_869 = 0.15;  % CoffeinSimulation|Organism|LargeIntestine|Vf (protein)-WS
P_870 = 0.282;  % CoffeinSimulation|Organism|LargeIntestine|Vf (extracellular water)-RR
P_871 = 0.78;  % CoffeinSimulation|Organism|LargeIntestine|Vf (water)-WS
P_872 = 0.456;  % CoffeinSimulation|Organism|LargeIntestine|Vf (intracellular water)-RR
P_873 = 0.0035;  % CoffeinSimulation|Organism|LargeIntestine|Vf (acidic phospholipids)-WS
P_874 = 2.41;  % CoffeinSimulation|Organism|LargeIntestine|Acidic phospholipids [mg/g] - RR
P_875 = 2652;  % CoffeinSimulation|Organism|LargeIntestine|Large intestinal transit time
P_876 = 0.4125858347626;  % CoffeinSimulation|Organism|LargeIntestine|Volume
P_877 = 0.6304999999999999;  % CoffeinSimulation|Organism|LargeIntestine|Specific blood flow rate
P_878 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_879 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_880 = 1;  % CoffeinSimulation|Organism|LargeIntestine|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_881 = 1;  % CoffeinSimulation|Organism|LargeIntestine|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_882 = 7.4;  % CoffeinSimulation|Organism|LargeIntestine|Intracellular|pH
P_883 = 0;  % CoffeinSimulation|Organism|LargeIntestine|Intracellular|CYP1A2|Relative expression
P_884 = 0;  % CoffeinSimulation|Organism|LargeIntestine|Intracellular|CYP1A2|Relative expression (normalized)
P_885 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_886 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_887 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Density (tissue)
P_888 = 0.084706;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Fraction of regional blood flow rate
P_889 = 0.19;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Fraction mucosa
P_890 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Fraction of blood for sampling
P_891 = 4.5e-08;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Radius (small pores)
P_892 = 2.5e-07;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Radius (large pores)
P_893 = 1.86944444444444e-10;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Hydraulic conductivity
P_894 = 0.05;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Flow fraction via large pores
P_895 = 0.0487;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Vf (neutral lipid)-PT
P_896 = 0.06;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Vf (lipid)
P_897 = 0.13;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Fraction vascular
P_898 = 0.0163;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Vf (phospholipid)-PT
P_899 = 0.08;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Vf (protein)
P_900 = 0.5;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Albumin ratio (tissue/plasma)-PT
P_901 = 0.141;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Lipoprotein ratio (tissue/plasma)
P_902 = 0.158;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Albumin ratio (tissue/plasma)
P_903 = 0.8;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Vf (water)
P_904 = 0.718;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Vf (water)-PT
P_905 = 0.73;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Fraction interstitial
P_906 = 0.0375;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Vf (neutral lipid)-RR
P_907 = 0.0483;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Vf (neutral lipid)-WS
P_908 = 0.0124;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Vf (neutral phospholipid)-RR
P_909 = 0.0182;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Vf (neutral phospholipid, plasma)-WS
P_910 = 0.282;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Vf (extracellular water)-RR
P_911 = 0.15;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Vf (protein)-WS
P_912 = 0.78;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Vf (water)-WS
P_913 = 0.456;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Vf (intracellular water)-RR
P_914 = 0.0035;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Vf (acidic phospholipids)-WS
P_915 = 2.41;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Acidic phospholipids [mg/g] - RR
P_916 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_917 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_918 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_919 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_920 = 7.3;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Intracellular|pH
P_921 = 0;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Intracellular|CYP1A2|Relative expression
P_922 = 0;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Intracellular|CYP1A2|Relative expression (normalized)
P_923 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_924 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_925 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Density (tissue)
P_926 = 0.19;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Fraction mucosa
P_927 = 0.15529;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Fraction of regional blood flow rate
P_928 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Fraction of blood for sampling
P_929 = 0.05;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Flow fraction via large pores
P_930 = 1.86944444444444e-10;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Hydraulic conductivity
P_931 = 4.5e-08;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Radius (small pores)
P_932 = 2.5e-07;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Radius (large pores)
P_933 = 0.06;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Vf (lipid)
P_934 = 0.0487;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Vf (neutral lipid)-PT
P_935 = 0.13;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Fraction vascular
P_936 = 0.0163;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Vf (phospholipid)-PT
P_937 = 0.08;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Vf (protein)
P_938 = 0.718;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Vf (water)-PT
P_939 = 0.8;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Vf (water)
P_940 = 0.5;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Albumin ratio (tissue/plasma)-PT
P_941 = 0.141;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Lipoprotein ratio (tissue/plasma)
P_942 = 0.158;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Albumin ratio (tissue/plasma)
P_943 = 0.73;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Fraction interstitial
P_944 = 0.0483;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Vf (neutral lipid)-WS
P_945 = 0.0375;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Vf (neutral lipid)-RR
P_946 = 0.0182;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Vf (neutral phospholipid, plasma)-WS
P_947 = 0.0124;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Vf (neutral phospholipid)-RR
P_948 = 0.15;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Vf (protein)-WS
P_949 = 0.282;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Vf (extracellular water)-RR
P_950 = 0.78;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Vf (water)-WS
P_951 = 0.456;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Vf (intracellular water)-RR
P_952 = 0.0035;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Vf (acidic phospholipids)-WS
P_953 = 2.41;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Acidic phospholipids [mg/g] - RR
P_954 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_955 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_956 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_957 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_958 = 7.3;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Intracellular|pH
P_959 = 0;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Intracellular|CYP1A2|Relative expression
P_960 = 0;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Intracellular|CYP1A2|Relative expression (normalized)
P_961 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_962 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_963 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Density (tissue)
P_964 = 0.32;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Fraction of regional blood flow rate
P_965 = 0.21;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Fraction mucosa
P_966 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Fraction of blood for sampling
P_967 = 2.5e-07;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Radius (large pores)
P_968 = 4.5e-08;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Radius (small pores)
P_969 = 0.05;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Flow fraction via large pores
P_970 = 1.86944444444444e-10;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Hydraulic conductivity
P_971 = 0.06;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Vf (lipid)
P_972 = 0.0487;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Vf (neutral lipid)-PT
P_973 = 0.12;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Fraction vascular
P_974 = 0.0163;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Vf (phospholipid)-PT
P_975 = 0.08;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Vf (protein)
P_976 = 0.718;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Vf (water)-PT
P_977 = 0.8;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Vf (water)
P_978 = 0.158;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Albumin ratio (tissue/plasma)
P_979 = 0.141;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Lipoprotein ratio (tissue/plasma)
P_980 = 0.5;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Albumin ratio (tissue/plasma)-PT
P_981 = 0.74;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Fraction interstitial
P_982 = 0.0375;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Vf (neutral lipid)-RR
P_983 = 0.0483;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Vf (neutral lipid)-WS
P_984 = 0.0182;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Vf (neutral phospholipid, plasma)-WS
P_985 = 0.0124;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Vf (neutral phospholipid)-RR
P_986 = 0.15;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Vf (protein)-WS
P_987 = 0.282;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Vf (extracellular water)-RR
P_988 = 0.456;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Vf (intracellular water)-RR
P_989 = 0.78;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Vf (water)-WS
P_990 = 0.0035;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Vf (acidic phospholipids)-WS
P_991 = 2.41;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Acidic phospholipids [mg/g] - RR
P_992 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_993 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_994 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_995 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_996 = 7.3;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Intracellular|pH
P_997 = 0;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Intracellular|CYP1A2|Relative expression
P_998 = 0;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Intracellular|CYP1A2|Relative expression (normalized)
P_999 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_1000 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_1001 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Density (tissue)
P_1002 = 0.24;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Fraction of regional blood flow rate
P_1003 = 0.14;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Fraction mucosa
P_1004 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Fraction of blood for sampling
P_1005 = 4.5e-08;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Radius (small pores)
P_1006 = 2.5e-07;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Radius (large pores)
P_1007 = 1.86944444444444e-10;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Hydraulic conductivity
P_1008 = 0.05;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Flow fraction via large pores
P_1009 = 0.0487;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Vf (neutral lipid)-PT
P_1010 = 0.06;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Vf (lipid)
P_1011 = 0.12;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Fraction vascular
P_1012 = 0.0163;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Vf (phospholipid)-PT
P_1013 = 0.08;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Vf (protein)
P_1014 = 0.141;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Lipoprotein ratio (tissue/plasma)
P_1015 = 0.5;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Albumin ratio (tissue/plasma)-PT
P_1016 = 0.158;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Albumin ratio (tissue/plasma)
P_1017 = 0.718;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Vf (water)-PT
P_1018 = 0.8;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Vf (water)
P_1019 = 0.74;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Fraction interstitial
P_1020 = 0.0483;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Vf (neutral lipid)-WS
P_1021 = 0.0375;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Vf (neutral lipid)-RR
P_1022 = 0.0182;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Vf (neutral phospholipid, plasma)-WS
P_1023 = 0.0124;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Vf (neutral phospholipid)-RR
P_1024 = 0.282;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Vf (extracellular water)-RR
P_1025 = 0.15;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Vf (protein)-WS
P_1026 = 0.78;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Vf (water)-WS
P_1027 = 0.456;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Vf (intracellular water)-RR
P_1028 = 2.41;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Acidic phospholipids [mg/g] - RR
P_1029 = 0.0035;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Vf (acidic phospholipids)-WS
P_1030 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_1031 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_1032 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_1033 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_1034 = 7.3;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Intracellular|pH
P_1035 = 0;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Intracellular|CYP1A2|Relative expression
P_1036 = 0;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Intracellular|CYP1A2|Relative expression (normalized)
P_1037 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_1038 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_1039 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Density (tissue)
P_1040 = 0.135;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Fraction of regional blood flow rate
P_1041 = 0.3;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Fraction mucosa
P_1042 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Fraction of blood for sampling
P_1043 = 2.5e-07;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Radius (large pores)
P_1044 = 1.86944444444444e-10;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Hydraulic conductivity
P_1045 = 4.5e-08;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Radius (small pores)
P_1046 = 0.05;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Flow fraction via large pores
P_1047 = 0.06;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Vf (lipid)
P_1048 = 0.0487;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Vf (neutral lipid)-PT
P_1049 = 0.08;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Fraction vascular
P_1050 = 0.0163;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Vf (phospholipid)-PT
P_1051 = 0.08;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Vf (protein)
P_1052 = 0.158;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Albumin ratio (tissue/plasma)
P_1053 = 0.141;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Lipoprotein ratio (tissue/plasma)
P_1054 = 0.5;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Albumin ratio (tissue/plasma)-PT
P_1055 = 0.8;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Vf (water)
P_1056 = 0.718;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Vf (water)-PT
P_1057 = 0.78;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Fraction interstitial
P_1058 = 0.0483;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Vf (neutral lipid)-WS
P_1059 = 0.0375;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Vf (neutral lipid)-RR
P_1060 = 0.0124;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Vf (neutral phospholipid)-RR
P_1061 = 0.0182;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Vf (neutral phospholipid, plasma)-WS
P_1062 = 0.282;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Vf (extracellular water)-RR
P_1063 = 0.15;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Vf (protein)-WS
P_1064 = 0.456;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Vf (intracellular water)-RR
P_1065 = 0.78;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Vf (water)-WS
P_1066 = 2.41;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Acidic phospholipids [mg/g] - RR
P_1067 = 0.0035;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Vf (acidic phospholipids)-WS
P_1068 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_1069 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_1070 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_1071 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_1072 = 7.3;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Intracellular|pH
P_1073 = 0;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Intracellular|CYP1A2|Relative expression
P_1074 = 0;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Intracellular|CYP1A2|Relative expression (normalized)
P_1075 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_1076 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_1077 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Density (tissue)
P_1078 = 0.055;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Fraction of regional blood flow rate
P_1079 = 0.3;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Fraction mucosa
P_1080 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Fraction of blood for sampling
P_1081 = 4.5e-08;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Radius (small pores)
P_1082 = 2.5e-07;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Radius (large pores)
P_1083 = 1.86944444444444e-10;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Hydraulic conductivity
P_1084 = 0.05;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Flow fraction via large pores
P_1085 = 0.06;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Vf (lipid)
P_1086 = 0.0487;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Vf (neutral lipid)-PT
P_1087 = 0.08;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Fraction vascular
P_1088 = 0.0163;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Vf (phospholipid)-PT
P_1089 = 0.08;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Vf (protein)
P_1090 = 0.141;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Lipoprotein ratio (tissue/plasma)
P_1091 = 0.8;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Vf (water)
P_1092 = 0.718;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Vf (water)-PT
P_1093 = 0.158;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Albumin ratio (tissue/plasma)
P_1094 = 0.5;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Albumin ratio (tissue/plasma)-PT
P_1095 = 0.6899999999999999;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Fraction interstitial
P_1096 = 0.0375;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Vf (neutral lipid)-RR
P_1097 = 0.0483;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Vf (neutral lipid)-WS
P_1098 = 0.0182;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Vf (neutral phospholipid, plasma)-WS
P_1099 = 0.0124;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Vf (neutral phospholipid)-RR
P_1100 = 0.15;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Vf (protein)-WS
P_1101 = 0.282;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Vf (extracellular water)-RR
P_1102 = 0.78;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Vf (water)-WS
P_1103 = 0.456;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Vf (intracellular water)-RR
P_1104 = 0.0035;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Vf (acidic phospholipids)-WS
P_1105 = 2.41;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Acidic phospholipids [mg/g] - RR
P_1106 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_1107 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_1108 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_1109 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_1110 = 7.3;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Intracellular|pH
P_1111 = 0;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Intracellular|CYP1A2|Relative expression
P_1112 = 0;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Intracellular|CYP1A2|Relative expression (normalized)
P_1113 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_1114 = 1;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_1115 = 0;  % CoffeinSimulation|Organism|Liver|Is liver zonated
P_1116 = 0.5;  % CoffeinSimulation|Organism|Liver|Fraction of periportal zone
P_1117 = 0.96;  % CoffeinSimulation|Organism|Liver|Fluid recirculation flow proportionality factor
P_1118 = 0.0199;  % CoffeinSimulation|Organism|Liver|Lymph flow proportionality factor
P_1119 = 0.0013;  % CoffeinSimulation|Organism|Liver|Organ volume mouse
P_1120 = 0;  % CoffeinSimulation|Organism|Liver|EHC continuous fraction
P_1121 = 1;  % CoffeinSimulation|Organism|Liver|Density (tissue)
P_1122 = 0.75;  % CoffeinSimulation|Organism|Liver|Allometric scale factor
P_1123 = 1;  % CoffeinSimulation|Organism|Liver|Fraction of blood for sampling
P_1124 = 9e-08;  % CoffeinSimulation|Organism|Liver|Radius (small pores)
P_1125 = 3.88888888888889e-11;  % CoffeinSimulation|Organism|Liver|Hydraulic conductivity
P_1126 = 0.8;  % CoffeinSimulation|Organism|Liver|Flow fraction via large pores
P_1127 = 3.3e-07;  % CoffeinSimulation|Organism|Liver|Radius (large pores)
P_1128 = 0.0348;  % CoffeinSimulation|Organism|Liver|Vf (neutral lipid)-PT
P_1129 = 0.06900000000000001;  % CoffeinSimulation|Organism|Liver|Vf (lipid)
P_1130 = 0.17;  % CoffeinSimulation|Organism|Liver|Fraction vascular
P_1131 = 0.0252;  % CoffeinSimulation|Organism|Liver|Vf (phospholipid)-PT
P_1132 = 0.184;  % CoffeinSimulation|Organism|Liver|Vf (protein)
P_1133 = 0.08599999999999999;  % CoffeinSimulation|Organism|Liver|Albumin ratio (tissue/plasma)
P_1134 = 0.5;  % CoffeinSimulation|Organism|Liver|Albumin ratio (tissue/plasma)-PT
P_1135 = 0.161;  % CoffeinSimulation|Organism|Liver|Lipoprotein ratio (tissue/plasma)
P_1136 = 0.747;  % CoffeinSimulation|Organism|Liver|Vf (water)
P_1137 = 0.751;  % CoffeinSimulation|Organism|Liver|Vf (water)-PT
P_1138 = 0.04;  % CoffeinSimulation|Organism|Liver|Microsomal protein mass/g tissue
P_1139 = 139000;  % CoffeinSimulation|Organism|Liver|Number of cells/g tissue
P_1140 = 0.163;  % CoffeinSimulation|Organism|Liver|Fraction interstitial
P_1141 = 0.0135;  % CoffeinSimulation|Organism|Liver|Vf (neutral lipid)-RR
P_1142 = 0.0232;  % CoffeinSimulation|Organism|Liver|Vf (neutral lipid)-WS
P_1143 = 0.0238;  % CoffeinSimulation|Organism|Liver|Vf (neutral phospholipid)-RR
P_1144 = 0.0472;  % CoffeinSimulation|Organism|Liver|Vf (neutral phospholipid, plasma)-WS
P_1145 = 0.161;  % CoffeinSimulation|Organism|Liver|Vf (extracellular water)-RR
P_1146 = 0.21;  % CoffeinSimulation|Organism|Liver|Vf (protein)-WS
P_1147 = 0.481;  % CoffeinSimulation|Organism|Liver|Vf (intracellular water)-RR
P_1148 = 0.68;  % CoffeinSimulation|Organism|Liver|Vf (water)-WS
P_1149 = 0.008800000000000001;  % CoffeinSimulation|Organism|Liver|Vf (acidic phospholipids)-WS
P_1150 = 4.56;  % CoffeinSimulation|Organism|Liver|Acidic phospholipids [mg/g] - RR
P_1151 = 2.37706985120915;  % CoffeinSimulation|Organism|Liver|Volume
P_1152 = 0.1794;  % CoffeinSimulation|Organism|Liver|Specific blood flow rate
P_1153 = 1;  % CoffeinSimulation|Organism|Liver|Periportal|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_1154 = 1;  % CoffeinSimulation|Organism|Liver|Periportal|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_1155 = 1;  % CoffeinSimulation|Organism|Liver|Periportal|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_1156 = 1;  % CoffeinSimulation|Organism|Liver|Periportal|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_1157 = 1;  % CoffeinSimulation|Organism|Liver|Periportal|Intracellular|CYP1A2|Relative expression
P_1158 = 1;  % CoffeinSimulation|Organism|Liver|Periportal|Intracellular|CYP1A2|Relative expression (normalized)
P_1159 = 1;  % CoffeinSimulation|Organism|Liver|Periportal|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_1160 = 1;  % CoffeinSimulation|Organism|Liver|Periportal|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_1161 = 1;  % CoffeinSimulation|Organism|Liver|Pericentral|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_1162 = 1;  % CoffeinSimulation|Organism|Liver|Pericentral|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_1163 = 1;  % CoffeinSimulation|Organism|Liver|Pericentral|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_1164 = 1;  % CoffeinSimulation|Organism|Liver|Pericentral|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_1165 = 1;  % CoffeinSimulation|Organism|Liver|Pericentral|Intracellular|CYP1A2|Relative expression
P_1166 = 1;  % CoffeinSimulation|Organism|Liver|Pericentral|Intracellular|CYP1A2|Relative expression (normalized)
P_1167 = 1;  % CoffeinSimulation|Organism|Liver|Pericentral|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_1168 = 1;  % CoffeinSimulation|Organism|Liver|Pericentral|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_1169 = 7.23;  % CoffeinSimulation|Organism|Liver|Intracellular|pH
P_1170 = 1;  % CoffeinSimulation|Organism|Lung|Density (tissue)
P_1171 = 0.01;  % CoffeinSimulation|Organism|Lung|Fluid recirculation flow proportionality factor
P_1172 = 3.56e-05;  % CoffeinSimulation|Organism|Lung|Lymph flow proportionality factor
P_1173 = 0.0001;  % CoffeinSimulation|Organism|Lung|Organ volume mouse
P_1174 = 0.75;  % CoffeinSimulation|Organism|Lung|Allometric scale factor
P_1175 = 1;  % CoffeinSimulation|Organism|Lung|Fraction of blood for sampling
P_1176 = 5.66666666666667e-12;  % CoffeinSimulation|Organism|Lung|Hydraulic conductivity
P_1177 = 2.5e-07;  % CoffeinSimulation|Organism|Lung|Radius (large pores)
P_1178 = 4.5e-08;  % CoffeinSimulation|Organism|Lung|Radius (small pores)
P_1179 = 0.05;  % CoffeinSimulation|Organism|Lung|Flow fraction via large pores
P_1180 = 0.01;  % CoffeinSimulation|Organism|Lung|Vf (lipid)
P_1181 = 0.003;  % CoffeinSimulation|Organism|Lung|Vf (neutral lipid)-PT
P_1182 = 0.183;  % CoffeinSimulation|Organism|Lung|Vf (protein)
P_1183 = 0.008999999999999999;  % CoffeinSimulation|Organism|Lung|Vf (phospholipid)-PT
P_1184 = 0.8110000000000001;  % CoffeinSimulation|Organism|Lung|Vf (water)-PT
P_1185 = 0.8070000000000001;  % CoffeinSimulation|Organism|Lung|Vf (water)
P_1186 = 0.5;  % CoffeinSimulation|Organism|Lung|Albumin ratio (tissue/plasma)-PT
P_1187 = 0.168;  % CoffeinSimulation|Organism|Lung|Lipoprotein ratio (tissue/plasma)
P_1188 = 0.212;  % CoffeinSimulation|Organism|Lung|Albumin ratio (tissue/plasma)
P_1189 = 0.188;  % CoffeinSimulation|Organism|Lung|Fraction interstitial
P_1190 = 0.0204;  % CoffeinSimulation|Organism|Lung|Vf (neutral lipid)-WS
P_1191 = 0.0215;  % CoffeinSimulation|Organism|Lung|Vf (neutral lipid)-RR
P_1192 = 0.0152;  % CoffeinSimulation|Organism|Lung|Vf (neutral phospholipid, plasma)-WS
P_1193 = 0.0123;  % CoffeinSimulation|Organism|Lung|Vf (neutral phospholipid)-RR
P_1194 = 0.11;  % CoffeinSimulation|Organism|Lung|Vf (protein)-WS
P_1195 = 0.336;  % CoffeinSimulation|Organism|Lung|Vf (extracellular water)-RR
P_1196 = 0.238;  % CoffeinSimulation|Organism|Lung|Vf (intracellular water)-RR
P_1197 = 0.74;  % CoffeinSimulation|Organism|Lung|Vf (water)-WS
P_1198 = 0.0044;  % CoffeinSimulation|Organism|Lung|Vf (acidic phospholipids)-WS
P_1199 = 3.91;  % CoffeinSimulation|Organism|Lung|Acidic phospholipids [mg/g] - RR
P_1200 = 1.2145537567735;  % CoffeinSimulation|Organism|Lung|Volume
P_1201 = 0.58;  % CoffeinSimulation|Organism|Lung|Fraction vascular
P_1202 = 1;  % CoffeinSimulation|Organism|Lung|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_1203 = 1;  % CoffeinSimulation|Organism|Lung|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_1204 = 1;  % CoffeinSimulation|Organism|Lung|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_1205 = 1;  % CoffeinSimulation|Organism|Lung|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_1206 = 6.6;  % CoffeinSimulation|Organism|Lung|Intracellular|pH
P_1207 = 2.49475890985325e-05;  % CoffeinSimulation|Organism|Lung|Intracellular|CYP1A2|Relative expression
P_1208 = 2.49475890985325e-05;  % CoffeinSimulation|Organism|Lung|Intracellular|CYP1A2|Relative expression (normalized)
P_1209 = 1;  % CoffeinSimulation|Organism|Lung|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_1210 = 1;  % CoffeinSimulation|Organism|Lung|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_1211 = 0.00201;  % CoffeinSimulation|Organism|Muscle|Lymph flow proportionality factor
P_1212 = 0.292;  % CoffeinSimulation|Organism|Muscle|Fluid recirculation flow proportionality factor
P_1213 = 0.01;  % CoffeinSimulation|Organism|Muscle|Organ volume mouse
P_1214 = 0.287;  % CoffeinSimulation|Organism|Muscle|Peripheral blood flow fraction
P_1215 = 1;  % CoffeinSimulation|Organism|Muscle|Density (tissue)
P_1216 = 2;  % CoffeinSimulation|Organism|Muscle|Allometric scale factor
P_1217 = 1;  % CoffeinSimulation|Organism|Muscle|Fraction of blood for sampling
P_1218 = 4.5e-08;  % CoffeinSimulation|Organism|Muscle|Radius (small pores)
P_1219 = 2.5e-07;  % CoffeinSimulation|Organism|Muscle|Radius (large pores)
P_1220 = 4.16666666666667e-12;  % CoffeinSimulation|Organism|Muscle|Hydraulic conductivity
P_1221 = 0.05;  % CoffeinSimulation|Organism|Muscle|Flow fraction via large pores
P_1222 = 0.064;  % CoffeinSimulation|Organism|Muscle|Albumin ratio (tissue/plasma)
P_1223 = 0.059;  % CoffeinSimulation|Organism|Muscle|Lipoprotein ratio (tissue/plasma)
P_1224 = 0.5;  % CoffeinSimulation|Organism|Muscle|Albumin ratio (tissue/plasma)-PT
P_1225 = 0.025;  % CoffeinSimulation|Organism|Muscle|Fraction vascular
P_1226 = 0.0009;  % CoffeinSimulation|Organism|Muscle|Vf (acidic phospholipids)-WS
P_1227 = 2.42;  % CoffeinSimulation|Organism|Muscle|Acidic phospholipids [mg/g] - RR
P_1228 = 32.6439570688243;  % CoffeinSimulation|Organism|Muscle|Volume
P_1229 = 0.0238;  % CoffeinSimulation|Organism|Muscle|Vf (neutral lipid)-PT
P_1230 = 0.013;  % CoffeinSimulation|Organism|Muscle|Vf (lipid)
P_1231 = 0.177;  % CoffeinSimulation|Organism|Muscle|Vf (protein)
P_1232 = 0.0072;  % CoffeinSimulation|Organism|Muscle|Vf (phospholipid)-PT
P_1233 = 0.76;  % CoffeinSimulation|Organism|Muscle|Vf (water)-PT
P_1234 = 0.8110000000000001;  % CoffeinSimulation|Organism|Muscle|Vf (water)
P_1235 = 0.16;  % CoffeinSimulation|Organism|Muscle|Fraction interstitial
P_1236 = 0.0049;  % CoffeinSimulation|Organism|Muscle|Vf (neutral lipid)-WS
P_1237 = 0.022;  % CoffeinSimulation|Organism|Muscle|Vf (neutral lipid)-RR
P_1238 = 0.0042;  % CoffeinSimulation|Organism|Muscle|Vf (neutral phospholipid, plasma)-WS
P_1239 = 0.0078;  % CoffeinSimulation|Organism|Muscle|Vf (neutral phospholipid)-RR
P_1240 = 0.079;  % CoffeinSimulation|Organism|Muscle|Vf (extracellular water)-RR
P_1241 = 0.19;  % CoffeinSimulation|Organism|Muscle|Vf (protein)-WS
P_1242 = 0.666;  % CoffeinSimulation|Organism|Muscle|Vf (intracellular water)-RR
P_1243 = 0.76;  % CoffeinSimulation|Organism|Muscle|Vf (water)-WS
P_1244 = 0.03419;  % CoffeinSimulation|Organism|Muscle|Specific blood flow rate
P_1245 = 1;  % CoffeinSimulation|Organism|Muscle|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_1246 = 1;  % CoffeinSimulation|Organism|Muscle|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_1247 = 1;  % CoffeinSimulation|Organism|Muscle|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_1248 = 1;  % CoffeinSimulation|Organism|Muscle|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_1249 = 6.81;  % CoffeinSimulation|Organism|Muscle|Intracellular|pH
P_1250 = 0;  % CoffeinSimulation|Organism|Muscle|Intracellular|CYP1A2|Relative expression
P_1251 = 0;  % CoffeinSimulation|Organism|Muscle|Intracellular|CYP1A2|Relative expression (normalized)
P_1252 = 1;  % CoffeinSimulation|Organism|Muscle|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_1253 = 1;  % CoffeinSimulation|Organism|Muscle|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_1254 = 1;  % CoffeinSimulation|Organism|Pancreas|Density (tissue)
P_1255 = 0.01;  % CoffeinSimulation|Organism|Pancreas|Fluid recirculation flow proportionality factor
P_1256 = 0.0303;  % CoffeinSimulation|Organism|Pancreas|Lymph flow proportionality factor
P_1257 = 0.00013;  % CoffeinSimulation|Organism|Pancreas|Organ volume mouse
P_1258 = 0.75;  % CoffeinSimulation|Organism|Pancreas|Allometric scale factor
P_1259 = 1;  % CoffeinSimulation|Organism|Pancreas|Fraction of blood for sampling
P_1260 = 0.05;  % CoffeinSimulation|Organism|Pancreas|Flow fraction via large pores
P_1261 = 3.22222222222222e-11;  % CoffeinSimulation|Organism|Pancreas|Hydraulic conductivity
P_1262 = 2.5e-07;  % CoffeinSimulation|Organism|Pancreas|Radius (large pores)
P_1263 = 4.5e-08;  % CoffeinSimulation|Organism|Pancreas|Radius (small pores)
P_1264 = 0.08;  % CoffeinSimulation|Organism|Pancreas|Vf (lipid)
P_1265 = 0.0403;  % CoffeinSimulation|Organism|Pancreas|Vf (neutral lipid)-PT
P_1266 = 0.13;  % CoffeinSimulation|Organism|Pancreas|Vf (protein)
P_1267 = 0.01067;  % CoffeinSimulation|Organism|Pancreas|Vf (phospholipid)-PT
P_1268 = 0.71;  % CoffeinSimulation|Organism|Pancreas|Vf (water)-PT
P_1269 = 0.71;  % CoffeinSimulation|Organism|Pancreas|Vf (water)
P_1270 = 0.06;  % CoffeinSimulation|Organism|Pancreas|Albumin ratio (tissue/plasma)
P_1271 = 0.5;  % CoffeinSimulation|Organism|Pancreas|Albumin ratio (tissue/plasma)-PT
P_1272 = 0.06;  % CoffeinSimulation|Organism|Pancreas|Lipoprotein ratio (tissue/plasma)
P_1273 = 0.2;  % CoffeinSimulation|Organism|Pancreas|Fraction vascular
P_1274 = 0.12;  % CoffeinSimulation|Organism|Pancreas|Fraction interstitial
P_1275 = 0.0403;  % CoffeinSimulation|Organism|Pancreas|Vf (neutral lipid)-RR
P_1276 = 0.0403;  % CoffeinSimulation|Organism|Pancreas|Vf (neutral lipid)-WS
P_1277 = 0.008999999999999999;  % CoffeinSimulation|Organism|Pancreas|Vf (neutral phospholipid, plasma)-WS
P_1278 = 0.008999999999999999;  % CoffeinSimulation|Organism|Pancreas|Vf (neutral phospholipid)-RR
P_1279 = 0.12;  % CoffeinSimulation|Organism|Pancreas|Vf (extracellular water)-RR
P_1280 = 0.13;  % CoffeinSimulation|Organism|Pancreas|Vf (protein)-WS
P_1281 = 0.71;  % CoffeinSimulation|Organism|Pancreas|Vf (water)-WS
P_1282 = 0.521;  % CoffeinSimulation|Organism|Pancreas|Vf (intracellular water)-RR
P_1283 = 1.67;  % CoffeinSimulation|Organism|Pancreas|Acidic phospholipids [mg/g] - RR
P_1284 = 0.00167;  % CoffeinSimulation|Organism|Pancreas|Vf (acidic phospholipids)-WS
P_1285 = 0.190473011700579;  % CoffeinSimulation|Organism|Pancreas|Volume
P_1286 = 0.3419;  % CoffeinSimulation|Organism|Pancreas|Specific blood flow rate
P_1287 = 1;  % CoffeinSimulation|Organism|Pancreas|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_1288 = 1;  % CoffeinSimulation|Organism|Pancreas|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_1289 = 1;  % CoffeinSimulation|Organism|Pancreas|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_1290 = 1;  % CoffeinSimulation|Organism|Pancreas|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_1291 = 7.4;  % CoffeinSimulation|Organism|Pancreas|Intracellular|pH
P_1292 = 0;  % CoffeinSimulation|Organism|Pancreas|Intracellular|CYP1A2|Relative expression
P_1293 = 0;  % CoffeinSimulation|Organism|Pancreas|Intracellular|CYP1A2|Relative expression (normalized)
P_1294 = 1;  % CoffeinSimulation|Organism|Pancreas|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_1295 = 1;  % CoffeinSimulation|Organism|Pancreas|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_1296 = 1;  % CoffeinSimulation|Organism|PortalVein|Density (tissue)
P_1297 = 0.75;  % CoffeinSimulation|Organism|PortalVein|Allometric scale factor
P_1298 = 1;  % CoffeinSimulation|Organism|PortalVein|Fraction vascular
P_1299 = 1.03738129823828;  % CoffeinSimulation|Organism|PortalVein|Volume
P_1300 = 1;  % CoffeinSimulation|Organism|PortalVein|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_1301 = 1;  % CoffeinSimulation|Organism|PortalVein|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_1302 = 1;  % CoffeinSimulation|Organism|PortalVein|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_1303 = 1;  % CoffeinSimulation|Organism|PortalVein|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_1304 = 1;  % CoffeinSimulation|Organism|Skin|Density (tissue)
P_1305 = 0.617;  % CoffeinSimulation|Organism|Skin|Fluid recirculation flow proportionality factor
P_1306 = 0.00352;  % CoffeinSimulation|Organism|Skin|Lymph flow proportionality factor
P_1307 = 0.0029;  % CoffeinSimulation|Organism|Skin|Organ volume mouse
P_1308 = 0.713;  % CoffeinSimulation|Organism|Skin|Peripheral blood flow fraction
P_1309 = 1.6;  % CoffeinSimulation|Organism|Skin|Allometric scale factor
P_1310 = 1;  % CoffeinSimulation|Organism|Skin|Fraction of blood for sampling
P_1311 = 0.046;  % CoffeinSimulation|Organism|Skin|Fraction vascular
P_1312 = 0.05;  % CoffeinSimulation|Organism|Skin|Flow fraction via large pores
P_1313 = 1.66666666666667e-12;  % CoffeinSimulation|Organism|Skin|Hydraulic conductivity
P_1314 = 4.5e-08;  % CoffeinSimulation|Organism|Skin|Radius (small pores)
P_1315 = 2.5e-07;  % CoffeinSimulation|Organism|Skin|Radius (large pores)
P_1316 = 0.1;  % CoffeinSimulation|Organism|Skin|Vf (lipid)
P_1317 = 0.0284;  % CoffeinSimulation|Organism|Skin|Vf (neutral lipid)-PT
P_1318 = 0.0111;  % CoffeinSimulation|Organism|Skin|Vf (phospholipid)-PT
P_1319 = 0.288;  % CoffeinSimulation|Organism|Skin|Vf (protein)
P_1320 = 0.096;  % CoffeinSimulation|Organism|Skin|Lipoprotein ratio (tissue/plasma)
P_1321 = 0.277;  % CoffeinSimulation|Organism|Skin|Albumin ratio (tissue/plasma)
P_1322 = 0.718;  % CoffeinSimulation|Organism|Skin|Vf (water)-PT
P_1323 = 0.5;  % CoffeinSimulation|Organism|Skin|Albumin ratio (tissue/plasma)-PT
P_1324 = 0.612;  % CoffeinSimulation|Organism|Skin|Vf (water)
P_1325 = 0.302;  % CoffeinSimulation|Organism|Skin|Fraction interstitial
P_1326 = 0.0603;  % CoffeinSimulation|Organism|Skin|Vf (neutral lipid)-RR
P_1327 = 0.126;  % CoffeinSimulation|Organism|Skin|Vf (neutral lipid)-WS
P_1328 = 0.0112;  % CoffeinSimulation|Organism|Skin|Vf (neutral phospholipid, plasma)-WS
P_1329 = 0.0044;  % CoffeinSimulation|Organism|Skin|Vf (neutral phospholipid)-RR
P_1330 = 0.41;  % CoffeinSimulation|Organism|Skin|Vf (protein)-WS
P_1331 = 0.382;  % CoffeinSimulation|Organism|Skin|Vf (extracellular water)-RR
P_1332 = 0.276;  % CoffeinSimulation|Organism|Skin|Vf (intracellular water)-RR
P_1333 = 0.47;  % CoffeinSimulation|Organism|Skin|Vf (water)-WS
P_1334 = 1.32;  % CoffeinSimulation|Organism|Skin|Acidic phospholipids [mg/g] - RR
P_1335 = 0.0028;  % CoffeinSimulation|Organism|Skin|Vf (acidic phospholipids)-WS
P_1336 = 3.76321105782727;  % CoffeinSimulation|Organism|Skin|Volume
P_1337 = 0.08645;  % CoffeinSimulation|Organism|Skin|Specific blood flow rate
P_1338 = 1;  % CoffeinSimulation|Organism|Skin|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_1339 = 1;  % CoffeinSimulation|Organism|Skin|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_1340 = 1;  % CoffeinSimulation|Organism|Skin|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_1341 = 1;  % CoffeinSimulation|Organism|Skin|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_1342 = 7;  % CoffeinSimulation|Organism|Skin|Intracellular|pH
P_1343 = 0;  % CoffeinSimulation|Organism|Skin|Intracellular|CYP1A2|Relative expression
P_1344 = 0;  % CoffeinSimulation|Organism|Skin|Intracellular|CYP1A2|Relative expression (normalized)
P_1345 = 1;  % CoffeinSimulation|Organism|Skin|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_1346 = 1;  % CoffeinSimulation|Organism|Skin|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_1347 = 1;  % CoffeinSimulation|Organism|Spleen|Density (tissue)
P_1348 = 0.01;  % CoffeinSimulation|Organism|Spleen|Fluid recirculation flow proportionality factor
P_1349 = 0.0199;  % CoffeinSimulation|Organism|Spleen|Lymph flow proportionality factor
P_1350 = 0.0001;  % CoffeinSimulation|Organism|Spleen|Organ volume mouse
P_1351 = 0.75;  % CoffeinSimulation|Organism|Spleen|Allometric scale factor
P_1352 = 1;  % CoffeinSimulation|Organism|Spleen|Fraction of blood for sampling
P_1353 = 3.88888888888889e-11;  % CoffeinSimulation|Organism|Spleen|Hydraulic conductivity
P_1354 = 9e-08;  % CoffeinSimulation|Organism|Spleen|Radius (small pores)
P_1355 = 0.8;  % CoffeinSimulation|Organism|Spleen|Flow fraction via large pores
P_1356 = 3.3e-07;  % CoffeinSimulation|Organism|Spleen|Radius (large pores)
P_1357 = 0.016;  % CoffeinSimulation|Organism|Spleen|Vf (lipid)
P_1358 = 0.0201;  % CoffeinSimulation|Organism|Spleen|Vf (neutral lipid)-PT
P_1359 = 0.0198;  % CoffeinSimulation|Organism|Spleen|Vf (phospholipid)-PT
P_1360 = 0.194;  % CoffeinSimulation|Organism|Spleen|Vf (protein)
P_1361 = 0.33;  % CoffeinSimulation|Organism|Spleen|Fraction vascular
P_1362 = 0.778;  % CoffeinSimulation|Organism|Spleen|Vf (water)
P_1363 = 0.5;  % CoffeinSimulation|Organism|Spleen|Albumin ratio (tissue/plasma)-PT
P_1364 = 0.788;  % CoffeinSimulation|Organism|Spleen|Vf (water)-PT
P_1365 = 0.097;  % CoffeinSimulation|Organism|Spleen|Albumin ratio (tissue/plasma)
P_1366 = 0.207;  % CoffeinSimulation|Organism|Spleen|Lipoprotein ratio (tissue/plasma)
P_1367 = 0.15;  % CoffeinSimulation|Organism|Spleen|Fraction interstitial
P_1368 = 0.0071;  % CoffeinSimulation|Organism|Spleen|Vf (neutral lipid)-RR
P_1369 = 0.006;  % CoffeinSimulation|Organism|Spleen|Vf (neutral lipid)-WS
P_1370 = 0.0108;  % CoffeinSimulation|Organism|Spleen|Vf (neutral phospholipid, plasma)-WS
P_1371 = 0.0107;  % CoffeinSimulation|Organism|Spleen|Vf (neutral phospholipid)-RR
P_1372 = 0.207;  % CoffeinSimulation|Organism|Spleen|Vf (extracellular water)-RR
P_1373 = 0.23;  % CoffeinSimulation|Organism|Spleen|Vf (protein)-WS
P_1374 = 0.75;  % CoffeinSimulation|Organism|Spleen|Vf (water)-WS
P_1375 = 0.355;  % CoffeinSimulation|Organism|Spleen|Vf (intracellular water)-RR
P_1376 = 0.003;  % CoffeinSimulation|Organism|Spleen|Vf (acidic phospholipids)-WS
P_1377 = 3.18;  % CoffeinSimulation|Organism|Spleen|Acidic phospholipids [mg/g] - RR
P_1378 = 0.206886220501498;  % CoffeinSimulation|Organism|Spleen|Volume
P_1379 = 0.801125;  % CoffeinSimulation|Organism|Spleen|Specific blood flow rate
P_1380 = 1;  % CoffeinSimulation|Organism|Spleen|Plasma|Caffeine-CYP1A2-MM|Km interaction factor
P_1381 = 1;  % CoffeinSimulation|Organism|Spleen|Plasma|Caffeine-CYP1A2-MM|kcat interaction factor
P_1382 = 1;  % CoffeinSimulation|Organism|Spleen|BloodCells|Caffeine-CYP1A2-MM|Km interaction factor
P_1383 = 1;  % CoffeinSimulation|Organism|Spleen|BloodCells|Caffeine-CYP1A2-MM|kcat interaction factor
P_1384 = 7;  % CoffeinSimulation|Organism|Spleen|Intracellular|pH
P_1385 = 0;  % CoffeinSimulation|Organism|Spleen|Intracellular|CYP1A2|Relative expression
P_1386 = 0;  % CoffeinSimulation|Organism|Spleen|Intracellular|CYP1A2|Relative expression (normalized)
P_1387 = 1;  % CoffeinSimulation|Organism|Spleen|Intracellular|Caffeine-CYP1A2-MM|Km interaction factor
P_1388 = 1;  % CoffeinSimulation|Organism|Spleen|Intracellular|Caffeine-CYP1A2-MM|kcat interaction factor
P_1389 = 0.001;  % CoffeinSimulation|Organism|Saliva|Saliva flow rate
P_1390 = 1;  % CoffeinSimulation|Organism|Saliva|Density (tissue)
P_1391 = 7.4;  % CoffeinSimulation|Organism|Saliva|Saliva|pH (saliva)
P_1392 = 1;  % CoffeinSimulation|Neighborhoods|Bone_int_Bone_cell|Caffeine|P_cell_int_factor
P_1393 = 1;  % CoffeinSimulation|Neighborhoods|Bone_int_Bone_cell|Caffeine|P_int_cell_factor
P_1394 = 10;  % CoffeinSimulation|Neighborhoods|Bone_pls_Bone_int|Caffeine|P (plasma<->interstitial)
P_1395 = 1;  % CoffeinSimulation|Neighborhoods|Brain_int_Brain_cell|Caffeine|P_int_cell_factor
P_1396 = 1;  % CoffeinSimulation|Neighborhoods|Brain_int_Brain_cell|Caffeine|P_cell_int_factor
P_1397 = 10;  % CoffeinSimulation|Neighborhoods|Fat_pls_Fat_int|Caffeine|P (plasma<->interstitial)
P_1398 = 1;  % CoffeinSimulation|Neighborhoods|Fat_int_Fat_cell|Caffeine|P_int_cell_factor
P_1399 = 1;  % CoffeinSimulation|Neighborhoods|Fat_int_Fat_cell|Caffeine|P_cell_int_factor
P_1400 = 1;  % CoffeinSimulation|Neighborhoods|Gonads_int_Gonads_cell|Caffeine|P_cell_int_factor
P_1401 = 1;  % CoffeinSimulation|Neighborhoods|Gonads_int_Gonads_cell|Caffeine|P_int_cell_factor
P_1402 = 10;  % CoffeinSimulation|Neighborhoods|Gonads_pls_Gonads_int|Caffeine|P (plasma<->interstitial)
P_1403 = 10;  % CoffeinSimulation|Neighborhoods|Heart_pls_Heart_int|Caffeine|P (plasma<->interstitial)
P_1404 = 1;  % CoffeinSimulation|Neighborhoods|Heart_int_Heart_cell|Caffeine|P_cell_int_factor
P_1405 = 1;  % CoffeinSimulation|Neighborhoods|Heart_int_Heart_cell|Caffeine|P_int_cell_factor
P_1406 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_pls|Caffeine|Sum of active process rates
P_1407 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|Sum of active process rates
P_1408 = 1;  % CoffeinSimulation|Neighborhoods|Kidney_int_Kidney_cell|Caffeine|P_int_cell_factor
P_1409 = 1;  % CoffeinSimulation|Neighborhoods|Kidney_int_Kidney_cell|Caffeine|P_cell_int_factor
P_1410 = 10;  % CoffeinSimulation|Neighborhoods|Kidney_pls_Kidney_int|Caffeine|P (plasma<->interstitial)
P_1411 = 73.00017908367521;  % CoffeinSimulation|Neighborhoods|Kidney_pls_Kidney_ur|Caffeine|Renal Clearances-Birkett and Miners 1991|Body weight
P_1412 = 0.43771998528;  % CoffeinSimulation|Neighborhoods|Kidney_pls_Kidney_ur|Caffeine|Renal Clearances-Birkett and Miners 1991|Volume (kidney)
P_1413 = 0.47;  % CoffeinSimulation|Neighborhoods|Kidney_pls_Kidney_ur|Caffeine|Renal Clearances-Birkett and Miners 1991|Hematocrit
P_1414 = 1.32500028144182;  % CoffeinSimulation|Neighborhoods|Kidney_pls_Kidney_ur|Caffeine|Renal Clearances-Birkett and Miners 1991|Blood flow rate (kidney)
P_1415 = 0.7;  % CoffeinSimulation|Neighborhoods|Kidney_pls_Kidney_ur|Caffeine|Renal Clearances-Birkett and Miners 1991|Fraction unbound (experiment)
P_1416 = 1.033051e-05;  % CoffeinSimulation|Neighborhoods|Kidney_pls_Kidney_ur|Caffeine|Renal Clearances-Birkett and Miners 1991|Plasma clearance
P_1417 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_pls|Caffeine|Sum of active process rates
P_1418 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|Sum of active process rates
P_1419 = 10;  % CoffeinSimulation|Neighborhoods|Stomach_pls_Stomach_int|Caffeine|P (plasma<->interstitial)
P_1420 = 1;  % CoffeinSimulation|Neighborhoods|Stomach_int_Stomach_cell|Caffeine|P_cell_int_factor
P_1421 = 1;  % CoffeinSimulation|Neighborhoods|Stomach_int_Stomach_cell|Caffeine|P_int_cell_factor
P_1422 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_pls|Caffeine|Sum of active process rates
P_1423 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|Sum of active process rates
P_1424 = 1;  % CoffeinSimulation|Neighborhoods|SmallIntestine_int_SmallIntestine_cell|Caffeine|P_cell_int_factor
P_1425 = 1;  % CoffeinSimulation|Neighborhoods|SmallIntestine_int_SmallIntestine_cell|Caffeine|P_int_cell_factor
P_1426 = 10;  % CoffeinSimulation|Neighborhoods|SmallIntestine_pls_SmallIntestine_int|Caffeine|P (plasma<->interstitial)
P_1427 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|Sum of active process rates
P_1428 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_pls|Caffeine|Sum of active process rates
P_1429 = 1;  % CoffeinSimulation|Neighborhoods|LargeIntestine_int_LargeIntestine_cell|Caffeine|P_cell_int_factor
P_1430 = 1;  % CoffeinSimulation|Neighborhoods|LargeIntestine_int_LargeIntestine_cell|Caffeine|P_int_cell_factor
P_1431 = 10;  % CoffeinSimulation|Neighborhoods|LargeIntestine_pls_LargeIntestine_int|Caffeine|P (plasma<->interstitial)
P_1432 = 10;  % CoffeinSimulation|Neighborhoods|Periportal_pls_Periportal_int|Caffeine|P (plasma<->interstitial)
P_1433 = 1;  % CoffeinSimulation|Neighborhoods|Periportal_int_Periportal_cell|Caffeine|P_cell_int_factor
P_1434 = 1;  % CoffeinSimulation|Neighborhoods|Periportal_int_Periportal_cell|Caffeine|P_int_cell_factor
P_1435 = 1;  % CoffeinSimulation|Neighborhoods|Pericentral_int_Pericentral_cell|Caffeine|P_cell_int_factor
P_1436 = 1;  % CoffeinSimulation|Neighborhoods|Pericentral_int_Pericentral_cell|Caffeine|P_int_cell_factor
P_1437 = 10;  % CoffeinSimulation|Neighborhoods|Pericentral_pls_Pericentral_int|Caffeine|P (plasma<->interstitial)
P_1438 = 10;  % CoffeinSimulation|Neighborhoods|Lung_pls_Lung_int|Caffeine|P (plasma<->interstitial)
P_1439 = 1;  % CoffeinSimulation|Neighborhoods|Lung_int_Lung_cell|Caffeine|P_cell_int_factor
P_1440 = 1;  % CoffeinSimulation|Neighborhoods|Lung_int_Lung_cell|Caffeine|P_int_cell_factor
P_1441 = 10;  % CoffeinSimulation|Neighborhoods|Muscle_pls_Muscle_int|Caffeine|P (plasma<->interstitial)
P_1442 = 1;  % CoffeinSimulation|Neighborhoods|Muscle_int_Muscle_cell|Caffeine|P_cell_int_factor
P_1443 = 1;  % CoffeinSimulation|Neighborhoods|Muscle_int_Muscle_cell|Caffeine|P_int_cell_factor
P_1444 = 10;  % CoffeinSimulation|Neighborhoods|Pancreas_pls_Pancreas_int|Caffeine|P (plasma<->interstitial)
P_1445 = 1;  % CoffeinSimulation|Neighborhoods|Pancreas_int_Pancreas_cell|Caffeine|P_cell_int_factor
P_1446 = 1;  % CoffeinSimulation|Neighborhoods|Pancreas_int_Pancreas_cell|Caffeine|P_int_cell_factor
P_1447 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_pls|Caffeine|Sum of active process rates
P_1448 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_pls|Caffeine|Sum of passive process rates
P_1449 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|Sum of active process rates
P_1450 = 10;  % CoffeinSimulation|Neighborhoods|Skin_pls_Skin_int|Caffeine|P (plasma<->interstitial)
P_1451 = 1;  % CoffeinSimulation|Neighborhoods|Skin_int_Skin_cell|Caffeine|P_cell_int_factor
P_1452 = 1;  % CoffeinSimulation|Neighborhoods|Skin_int_Skin_cell|Caffeine|P_int_cell_factor
P_1453 = 10;  % CoffeinSimulation|Neighborhoods|Spleen_pls_Spleen_int|Caffeine|P (plasma<->interstitial)
P_1454 = 1;  % CoffeinSimulation|Neighborhoods|Spleen_int_Spleen_cell|Caffeine|P_cell_int_factor
P_1455 = 1;  % CoffeinSimulation|Neighborhoods|Spleen_int_Spleen_cell|Caffeine|P_int_cell_factor
P_1456 = 1;  % CoffeinSimulation|Neighborhoods|Saliva_slv_Saliva_slv|Caffeine|SalivaPlasmaRatio
P_1457 = 10;  % CoffeinSimulation|Neighborhoods|Duodenum_pls_Duodenum_int|Caffeine|P (plasma<->interstitial)
P_1458 = 1;  % CoffeinSimulation|Neighborhoods|Duodenum_int_Duodenum_cell|Caffeine|P_int_cell_factor
P_1459 = 1;  % CoffeinSimulation|Neighborhoods|Duodenum_int_Duodenum_cell|Caffeine|P_cell_int_factor
P_1460 = 10;  % CoffeinSimulation|Neighborhoods|UpperJejunum_pls_UpperJejunum_int|Caffeine|P (plasma<->interstitial)
P_1461 = 1;  % CoffeinSimulation|Neighborhoods|UpperJejunum_int_UpperJejunum_cell|Caffeine|P_cell_int_factor
P_1462 = 1;  % CoffeinSimulation|Neighborhoods|UpperJejunum_int_UpperJejunum_cell|Caffeine|P_int_cell_factor
P_1463 = 1;  % CoffeinSimulation|Neighborhoods|LowerJejunum_int_LowerJejunum_cell|Caffeine|P_cell_int_factor
P_1464 = 1;  % CoffeinSimulation|Neighborhoods|LowerJejunum_int_LowerJejunum_cell|Caffeine|P_int_cell_factor
P_1465 = 10;  % CoffeinSimulation|Neighborhoods|LowerJejunum_pls_LowerJejunum_int|Caffeine|P (plasma<->interstitial)
P_1466 = 10;  % CoffeinSimulation|Neighborhoods|UpperIleum_pls_UpperIleum_int|Caffeine|P (plasma<->interstitial)
P_1467 = 1;  % CoffeinSimulation|Neighborhoods|UpperIleum_int_UpperIleum_cell|Caffeine|P_cell_int_factor
P_1468 = 1;  % CoffeinSimulation|Neighborhoods|UpperIleum_int_UpperIleum_cell|Caffeine|P_int_cell_factor
P_1469 = 1;  % CoffeinSimulation|Neighborhoods|LowerIleum_int_LowerIleum_cell|Caffeine|P_cell_int_factor
P_1470 = 1;  % CoffeinSimulation|Neighborhoods|LowerIleum_int_LowerIleum_cell|Caffeine|P_int_cell_factor
P_1471 = 10;  % CoffeinSimulation|Neighborhoods|LowerIleum_pls_LowerIleum_int|Caffeine|P (plasma<->interstitial)
P_1472 = 10;  % CoffeinSimulation|Neighborhoods|Caecum_pls_Caecum_int|Caffeine|P (plasma<->interstitial)
P_1473 = 1;  % CoffeinSimulation|Neighborhoods|Caecum_int_Caecum_cell|Caffeine|P_cell_int_factor
P_1474 = 1;  % CoffeinSimulation|Neighborhoods|Caecum_int_Caecum_cell|Caffeine|P_int_cell_factor
P_1475 = 1;  % CoffeinSimulation|Neighborhoods|ColonAscendens_int_ColonAscendens_cell|Caffeine|P_cell_int_factor
P_1476 = 1;  % CoffeinSimulation|Neighborhoods|ColonAscendens_int_ColonAscendens_cell|Caffeine|P_int_cell_factor
P_1477 = 10;  % CoffeinSimulation|Neighborhoods|ColonAscendens_pls_ColonAscendens_int|Caffeine|P (plasma<->interstitial)
P_1478 = 10;  % CoffeinSimulation|Neighborhoods|ColonTransversum_pls_ColonTransversum_int|Caffeine|P (plasma<->interstitial)
P_1479 = 1;  % CoffeinSimulation|Neighborhoods|ColonTransversum_int_ColonTransversum_cell|Caffeine|P_cell_int_factor
P_1480 = 1;  % CoffeinSimulation|Neighborhoods|ColonTransversum_int_ColonTransversum_cell|Caffeine|P_int_cell_factor
P_1481 = 1;  % CoffeinSimulation|Neighborhoods|ColonDescendens_int_ColonDescendens_cell|Caffeine|P_cell_int_factor
P_1482 = 1;  % CoffeinSimulation|Neighborhoods|ColonDescendens_int_ColonDescendens_cell|Caffeine|P_int_cell_factor
P_1483 = 10;  % CoffeinSimulation|Neighborhoods|ColonDescendens_pls_ColonDescendens_int|Caffeine|P (plasma<->interstitial)
P_1484 = 1;  % CoffeinSimulation|Neighborhoods|ColonSigmoid_int_ColonSigmoid_cell|Caffeine|P_cell_int_factor
P_1485 = 1;  % CoffeinSimulation|Neighborhoods|ColonSigmoid_int_ColonSigmoid_cell|Caffeine|P_int_cell_factor
P_1486 = 10;  % CoffeinSimulation|Neighborhoods|ColonSigmoid_pls_ColonSigmoid_int|Caffeine|P (plasma<->interstitial)
P_1487 = 1;  % CoffeinSimulation|Neighborhoods|Rectum_int_Rectum_cell|Caffeine|P_int_cell_factor
P_1488 = 1;  % CoffeinSimulation|Neighborhoods|Rectum_int_Rectum_cell|Caffeine|P_cell_int_factor
P_1489 = 10;  % CoffeinSimulation|Neighborhoods|Rectum_pls_Rectum_int|Caffeine|P (plasma<->interstitial)
P_1490 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_pls|Caffeine|Sum of active process rates
P_1491 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_pls|Caffeine|Sum of passive process rates
P_1492 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|Sum of active process rates
P_1493 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_pls|Caffeine|Sum of active process rates
P_1494 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|Sum of active process rates
P_1495 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_pls|Caffeine|Sum of active process rates
P_1496 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_pls|Caffeine|Sum of passive process rates
P_1497 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|Sum of active process rates
P_1498 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_pls|Caffeine|Sum of active process rates
P_1499 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_pls|Caffeine|Sum of passive process rates
P_1500 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|Sum of active process rates
P_1501 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_pls|Caffeine|Sum of active process rates
P_1502 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_pls|Caffeine|Sum of passive process rates
P_1503 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_pls|Caffeine|Sum of active process rates
P_1504 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_pls|Caffeine|Sum of passive process rates
P_1505 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|Sum of active process rates
P_1506 = 0;  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|Sum of active process rates
P_1507 = 1;  % CoffeinSimulation|Caffeine|P_pls_bc_factor
P_1508 = 1;  % CoffeinSimulation|Caffeine|P_bc_pls_factor
P_1509 = 0;  % CoffeinSimulation|Caffeine|Intestinal permeability (paracellular)
P_1510 = 1;  % CoffeinSimulation|Caffeine|Plasma protein binding partner
P_1511 = 0;  % CoffeinSimulation|Caffeine|Total oral drug mass
P_1512 = 0;  % CoffeinSimulation|Caffeine|CT_NEUTRAL
P_1513 = 2;  % CoffeinSimulation|Caffeine|BP_UNKNOWN
P_1514 = 0;  % CoffeinSimulation|Caffeine|Br
P_1515 = 0;  % CoffeinSimulation|Caffeine|Cl
P_1516 = 1;  % CoffeinSimulation|Caffeine|Compound type 0
P_1517 = 0;  % CoffeinSimulation|Caffeine|Compound type 1
P_1518 = 0;  % CoffeinSimulation|Caffeine|Compound type 2
P_1519 = 0;  % CoffeinSimulation|Caffeine|BP_AGP
P_1520 = 1;  % CoffeinSimulation|Caffeine|CT_BASE
P_1521 = 0.1;  % CoffeinSimulation|Caffeine|base_For_Pint_Factor
P_1522 = 0;  % CoffeinSimulation|Caffeine|F
P_1523 = 0;  % CoffeinSimulation|Caffeine|I
P_1524 = -1;  % CoffeinSimulation|Caffeine|CT_ACID
P_1525 = 1;  % CoffeinSimulation|Caffeine|BP_ALBUMIN
P_1526 = 1;  % CoffeinSimulation|Caffeine|Is floating in lumen
P_1527 = 20;  % CoffeinSimulation|Caffeine|base_For_KaPL_Factor
P_1528 = 0.001;  % CoffeinSimulation|Caffeine|base_For_logD_Factor
P_1529 = 0.001;  % CoffeinSimulation|Caffeine|base_For_P_cell_Factor
P_1530 = 1;  % CoffeinSimulation|Caffeine|Is small molecule
P_1531 = 1.942e-07;  % CoffeinSimulation|Caffeine|Molecular weight
P_1532 = 0.8;  % CoffeinSimulation|Caffeine|pKa value 0
P_1533 = 0;  % CoffeinSimulation|Caffeine|pKa value 1
P_1534 = 0;  % CoffeinSimulation|Caffeine|pKa value 2
P_1535 = -0.07000000000000001;  % CoffeinSimulation|Caffeine|Lipophilicity
P_1536 = 0.7;  % CoffeinSimulation|Caffeine|Fraction unbound (plasma, reference value)
P_1537 = 0.0216;  % CoffeinSimulation|Caffeine|Solubility at reference pH
P_1538 = 7;  % CoffeinSimulation|Caffeine|Reference pH
P_1539 = 1000;  % CoffeinSimulation|Caffeine|Solubility gain per charge
P_1540 = 1;  % CoffeinSimulation|Caffeine|Treat precipitated drug as
P_1541 = 1;  % CoffeinSimulation|Caffeine|Density (drug)
P_1542 = 1e-07;  % CoffeinSimulation|Caffeine|Immediately dissolve particles smaller than
P_1543 = 999999;  % CoffeinSimulation|Caffeine|Kd (FcRn) in endosomal space
P_1544 = 999999;  % CoffeinSimulation|Caffeine|Kd (FcRn) in plasma/interstitial
P_1545 = 60;  % CoffeinSimulation|Caffeine|kass (FcRn)
P_1546 = 0;  % CoffeinSimulation|Caffeine|Use pH- and pKa-dependent penalty factor for charged molecule fraction
P_1547 = 1;  % CoffeinSimulation|Caffeine|Parameter m for correlation of intestinal permeability (transcellular)
P_1548 = 0;  % CoffeinSimulation|Caffeine|Parameter b for correlation of intestinal permeability (transcellular)
P_1549 = 1;  % CoffeinSimulation|CYP1A2|Ontogeny factor
P_1550 = 1380;  % CoffeinSimulation|CYP1A2|t1/2 (intestine)
P_1551 = 0;  % CoffeinSimulation|CYP1A2|Relative expression in plasma
P_1552 = 1;  % CoffeinSimulation|CYP1A2|Ontogeny factor GI
P_1553 = 1.8;  % CoffeinSimulation|CYP1A2|Reference concentration
P_1554 = 1;  % CoffeinSimulation|CYP1A2|Rel. exp. variability factor
P_1555 = 0;  % CoffeinSimulation|CYP1A2|Relative expression in blood cells (normalized)
P_1556 = 2340;  % CoffeinSimulation|CYP1A2|t1/2 (liver)
P_1557 = 0;  % CoffeinSimulation|CYP1A2|Relative expression in plasma (normalized)
P_1558 = 0;  % CoffeinSimulation|CYP1A2|Relative expression in vascular endothelium
P_1559 = 0;  % CoffeinSimulation|CYP1A2|Relative expression in vascular endothelium (normalized)
P_1560 = 0;  % CoffeinSimulation|CYP1A2|Relative expression in blood cells
P_1561 = 1;  % CoffeinSimulation|CYP1A2|Plasma protein binding partner
P_1562 = 0;  % CoffeinSimulation|CYP1A2|Total drug mass
P_1563 = 0;  % CoffeinSimulation|CYP1A2|Total oral drug mass
P_1564 = 0;  % CoffeinSimulation|CYP1A2|CT_NEUTRAL
P_1565 = 2;  % CoffeinSimulation|CYP1A2|BP_UNKNOWN
P_1566 = 0;  % CoffeinSimulation|CYP1A2|Br
P_1567 = 0;  % CoffeinSimulation|CYP1A2|Cl
P_1568 = 0;  % CoffeinSimulation|CYP1A2|Compound type 0
P_1569 = 0;  % CoffeinSimulation|CYP1A2|Compound type 1
P_1570 = 0;  % CoffeinSimulation|CYP1A2|Compound type 2
P_1571 = 0;  % CoffeinSimulation|CYP1A2|BP_AGP
P_1572 = 1;  % CoffeinSimulation|CYP1A2|CT_BASE
P_1573 = 0.1;  % CoffeinSimulation|CYP1A2|base_For_Pint_Factor
P_1574 = 0;  % CoffeinSimulation|CYP1A2|F
P_1575 = 0;  % CoffeinSimulation|CYP1A2|I
P_1576 = -1;  % CoffeinSimulation|CYP1A2|CT_ACID
P_1577 = 1;  % CoffeinSimulation|CYP1A2|BP_ALBUMIN
P_1578 = 0;  % CoffeinSimulation|CYP1A2|Is floating in lumen
P_1579 = 20;  % CoffeinSimulation|CYP1A2|base_For_KaPL_Factor
P_1580 = 0.001;  % CoffeinSimulation|CYP1A2|base_For_logD_Factor
P_1581 = 0.001;  % CoffeinSimulation|CYP1A2|base_For_P_cell_Factor
P_1582 = 1;  % CoffeinSimulation|CYP1A2|Is small molecule
P_1583 = 0;  % CoffeinSimulation|CYP1A2|Molecular weight
P_1584 = 0;  % CoffeinSimulation|CYP1A2|pKa value 0
P_1585 = 0;  % CoffeinSimulation|CYP1A2|pKa value 1
P_1586 = 0;  % CoffeinSimulation|CYP1A2|pKa value 2
P_1587 = 0;  % CoffeinSimulation|CYP1A2|Lipophilicity
P_1588 = 0;  % CoffeinSimulation|CYP1A2|Fraction unbound (plasma, reference value)
P_1589 = 0;  % CoffeinSimulation|CYP1A2|Solubility at reference pH
P_1590 = 7;  % CoffeinSimulation|CYP1A2|Reference pH
P_1591 = 1000;  % CoffeinSimulation|CYP1A2|Solubility gain per charge
P_1592 = 1;  % CoffeinSimulation|CYP1A2|Treat precipitated drug as
P_1593 = 1;  % CoffeinSimulation|CYP1A2|Density (drug)
P_1594 = 1e-07;  % CoffeinSimulation|CYP1A2|Immediately dissolve particles smaller than
P_1595 = 999999;  % CoffeinSimulation|CYP1A2|Kd (FcRn) in endosomal space
P_1596 = 999999;  % CoffeinSimulation|CYP1A2|Kd (FcRn) in plasma/interstitial
P_1597 = 0.87;  % CoffeinSimulation|CYP1A2|kass (FcRn)
P_1598 = 0;  % CoffeinSimulation|CYP1A2|Use pH- and pKa-dependent penalty factor for charged molecule fraction
P_1599 = 1;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Plasma protein binding partner
P_1600 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Total drug mass
P_1601 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Total oral drug mass
P_1602 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|CT_NEUTRAL
P_1603 = 2;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|BP_UNKNOWN
P_1604 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Br
P_1605 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Cl
P_1606 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Compound type 0
P_1607 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Compound type 1
P_1608 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Compound type 2
P_1609 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|BP_AGP
P_1610 = 1;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|CT_BASE
P_1611 = 0.1;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|base_For_Pint_Factor
P_1612 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|F
P_1613 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|I
P_1614 = -1;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|CT_ACID
P_1615 = 1;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|BP_ALBUMIN
P_1616 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Is floating in lumen
P_1617 = 20;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|base_For_KaPL_Factor
P_1618 = 0.001;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|base_For_logD_Factor
P_1619 = 0.001;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|base_For_P_cell_Factor
P_1620 = 1;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Is small molecule
P_1621 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Molecular weight
P_1622 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa value 0
P_1623 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa value 1
P_1624 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa value 2
P_1625 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Lipophilicity
P_1626 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Fraction unbound (plasma, reference value)
P_1627 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Solubility at reference pH
P_1628 = 7;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Reference pH
P_1629 = 1000;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Solubility gain per charge
P_1630 = 1;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Treat precipitated drug as
P_1631 = 1;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Density (drug)
P_1632 = 1e-07;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Immediately dissolve particles smaller than
P_1633 = 999999;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Kd (FcRn) in endosomal space
P_1634 = 999999;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Kd (FcRn) in plasma/interstitial
P_1635 = 0.87;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|kass (FcRn)
P_1636 = 0;  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Use pH- and pKa-dependent penalty factor for charged molecule fraction
P_1637 = 109;  % CoffeinSimulation|Caffeine-CYP1A2-MM|In vitro Vmax for liver microsomes
P_1638 = 108;  % CoffeinSimulation|Caffeine-CYP1A2-MM|Content of CYP proteins in liver microsomes
P_1639 = 14.7;  % CoffeinSimulation|Caffeine-CYP1A2-MM|Km
global P_1640;
if isempty(P_1640)
    P_1640 = 0;  % CoffeinSimulation|Applications|3 mg per kg Infusion (10 min)|Application_1|Application rate
end
global P_1641;
P_1641 = 0;  % CoffeinSimulation|Applications|3 mg per kg Infusion (10 min)|Application_1|ProtocolSchemaItem|Start time
P_1642 = 3e-06;  % CoffeinSimulation|Applications|3 mg per kg Infusion (10 min)|Application_1|ProtocolSchemaItem|DosePerBodyWeight
P_1643 = 0;  % CoffeinSimulation|Applications|3 mg per kg Infusion (10 min)|Application_1|ProtocolSchemaItem|DosePerBodySurfaceArea
global P_1644;
P_1644 = 10;  % CoffeinSimulation|Applications|3 mg per kg Infusion (10 min)|Application_1|ProtocolSchemaItem|Infusion time
P_1645 = 1;  % CoffeinSimulation|Applications|3 mg per kg Infusion (10 min)|Application_1|Volume
P_1646 = 1e-10;  % AbsTol
P_1647 = 1e-05;  % RelTol
P_1648 = 1e-10;  % H0
P_1649 = 0;  % HMin
P_1650 = 60;  % HMax
P_1651 = 100000;  % MxStep
P_1652 = 1;  % UseJacobian
P_1653 = (IIf(((P_40-P_41) >= 0),(P_40-P_41),0));  % CoffeinSimulation|Organism|Specific clearance (endosome)
P_1654 = ((P_19*52.17857142857143)+P_18);  % CoffeinSimulation|Organism|Estimated gestational age
P_1655 = (P_48*P_45);  % CoffeinSimulation|Organism|VenousBlood|Weight (tissue)
P_1656 = ((1-P_42)*P_48);  % CoffeinSimulation|Organism|VenousBlood|Plasma|Volume
P_1657 = P_1551;  % CoffeinSimulation|Organism|VenousBlood|Plasma|CYP1A2|Relative expression
P_1658 = P_1557;  % CoffeinSimulation|Organism|VenousBlood|Plasma|CYP1A2|Relative expression (normalized)
P_1659 = P_1549;  % CoffeinSimulation|Organism|VenousBlood|Plasma|CYP1A2|Ontogeny factor
P_1660 = P_1556;  % CoffeinSimulation|Organism|VenousBlood|Plasma|CYP1A2|t1/2
P_1661 = (P_1639*P_49);  % CoffeinSimulation|Organism|VenousBlood|Plasma|Caffeine-CYP1A2-MM|Km_app
P_1662 = (P_42*P_48);  % CoffeinSimulation|Organism|VenousBlood|BloodCells|Volume
P_1663 = P_1560;  % CoffeinSimulation|Organism|VenousBlood|BloodCells|CYP1A2|Relative expression
P_1664 = P_1555;  % CoffeinSimulation|Organism|VenousBlood|BloodCells|CYP1A2|Relative expression (normalized)
P_1665 = P_1549;  % CoffeinSimulation|Organism|VenousBlood|BloodCells|CYP1A2|Ontogeny factor
P_1666 = P_1556;  % CoffeinSimulation|Organism|VenousBlood|BloodCells|CYP1A2|t1/2
P_1667 = (P_1639*P_51);  % CoffeinSimulation|Organism|VenousBlood|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_1668 = (P_57*P_53);  % CoffeinSimulation|Organism|ArterialBlood|Weight (tissue)
P_1669 = ((1-P_42)*P_57);  % CoffeinSimulation|Organism|ArterialBlood|Plasma|Volume
P_1670 = P_1551;  % CoffeinSimulation|Organism|ArterialBlood|Plasma|CYP1A2|Relative expression
P_1671 = P_1557;  % CoffeinSimulation|Organism|ArterialBlood|Plasma|CYP1A2|Relative expression (normalized)
P_1672 = P_1549;  % CoffeinSimulation|Organism|ArterialBlood|Plasma|CYP1A2|Ontogeny factor
P_1673 = P_1556;  % CoffeinSimulation|Organism|ArterialBlood|Plasma|CYP1A2|t1/2
P_1674 = (P_1639*P_58);  % CoffeinSimulation|Organism|ArterialBlood|Plasma|Caffeine-CYP1A2-MM|Km_app
P_1675 = (P_42*P_57);  % CoffeinSimulation|Organism|ArterialBlood|BloodCells|Volume
P_1676 = P_1560;  % CoffeinSimulation|Organism|ArterialBlood|BloodCells|CYP1A2|Relative expression
P_1677 = P_1555;  % CoffeinSimulation|Organism|ArterialBlood|BloodCells|CYP1A2|Relative expression (normalized)
P_1678 = P_1549;  % CoffeinSimulation|Organism|ArterialBlood|BloodCells|CYP1A2|Ontogeny factor
P_1679 = P_1556;  % CoffeinSimulation|Organism|ArterialBlood|BloodCells|CYP1A2|t1/2
P_1680 = (P_1639*P_60);  % CoffeinSimulation|Organism|ArterialBlood|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_1681 = (6*P_64);  % CoffeinSimulation|Organism|Gallbladder|Time to complete gallbladder refilling
P_1682 = (IIf((P_63 > 0),(y(9)/P_63),0));  % CoffeinSimulation|Organism|Gallbladder|Caffeine|Concentration
P_1683 = (P_99*P_67);  % CoffeinSimulation|Organism|Bone|Weight (tissue)
P_1684 = (1-(P_87+P_79));  % CoffeinSimulation|Organism|Bone|Fraction intracellular
P_1685 = (P_79*(1-P_42)*P_99);  % CoffeinSimulation|Organism|Bone|Plasma|Volume
P_1686 = P_1551;  % CoffeinSimulation|Organism|Bone|Plasma|CYP1A2|Relative expression
P_1687 = P_1557;  % CoffeinSimulation|Organism|Bone|Plasma|CYP1A2|Relative expression (normalized)
P_1688 = P_1549;  % CoffeinSimulation|Organism|Bone|Plasma|CYP1A2|Ontogeny factor
P_1689 = P_1556;  % CoffeinSimulation|Organism|Bone|Plasma|CYP1A2|t1/2
P_1690 = (P_1639*P_100);  % CoffeinSimulation|Organism|Bone|Plasma|Caffeine-CYP1A2-MM|Km_app
P_1691 = (P_79*P_42*P_99);  % CoffeinSimulation|Organism|Bone|BloodCells|Volume
P_1692 = P_1560;  % CoffeinSimulation|Organism|Bone|BloodCells|CYP1A2|Relative expression
P_1693 = P_1555;  % CoffeinSimulation|Organism|Bone|BloodCells|CYP1A2|Relative expression (normalized)
P_1694 = P_1549;  % CoffeinSimulation|Organism|Bone|BloodCells|CYP1A2|Ontogeny factor
P_1695 = P_1556;  % CoffeinSimulation|Organism|Bone|BloodCells|CYP1A2|t1/2
P_1696 = (P_1639*P_102);  % CoffeinSimulation|Organism|Bone|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_1697 = (P_87*P_99);  % CoffeinSimulation|Organism|Bone|Interstitial|Volume
P_1698 = P_13;  % CoffeinSimulation|Organism|Bone|Interstitial|pH
P_1699 = P_99;  % CoffeinSimulation|Organism|Bone|Intracellular|Volume of protein container
P_1700 = P_106;  % CoffeinSimulation|Organism|Bone|Intracellular|CYP1A2|Relative expression out.
P_1701 = P_1549;  % CoffeinSimulation|Organism|Bone|Intracellular|CYP1A2|Ontogeny factor
P_1702 = P_1556;  % CoffeinSimulation|Organism|Bone|Intracellular|CYP1A2|t1/2
P_1703 = (P_1639*P_107);  % CoffeinSimulation|Organism|Bone|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_1704 = (P_140*P_109);  % CoffeinSimulation|Organism|Brain|Weight (tissue)
P_1705 = (1-(P_129+P_121));  % CoffeinSimulation|Organism|Brain|Fraction intracellular
P_1706 = (P_121*(1-P_42)*P_140);  % CoffeinSimulation|Organism|Brain|Plasma|Volume
P_1707 = P_1551;  % CoffeinSimulation|Organism|Brain|Plasma|CYP1A2|Relative expression
P_1708 = P_1557;  % CoffeinSimulation|Organism|Brain|Plasma|CYP1A2|Relative expression (normalized)
P_1709 = P_1556;  % CoffeinSimulation|Organism|Brain|Plasma|CYP1A2|t1/2
P_1710 = P_1549;  % CoffeinSimulation|Organism|Brain|Plasma|CYP1A2|Ontogeny factor
P_1711 = (P_1639*P_142);  % CoffeinSimulation|Organism|Brain|Plasma|Caffeine-CYP1A2-MM|Km_app
P_1712 = (P_121*P_42*P_140);  % CoffeinSimulation|Organism|Brain|BloodCells|Volume
P_1713 = P_1560;  % CoffeinSimulation|Organism|Brain|BloodCells|CYP1A2|Relative expression
P_1714 = P_1555;  % CoffeinSimulation|Organism|Brain|BloodCells|CYP1A2|Relative expression (normalized)
P_1715 = P_1549;  % CoffeinSimulation|Organism|Brain|BloodCells|CYP1A2|Ontogeny factor
P_1716 = P_1556;  % CoffeinSimulation|Organism|Brain|BloodCells|CYP1A2|t1/2
P_1717 = (P_1639*P_144);  % CoffeinSimulation|Organism|Brain|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_1718 = (P_129*P_140);  % CoffeinSimulation|Organism|Brain|Interstitial|Volume
P_1719 = P_13;  % CoffeinSimulation|Organism|Brain|Interstitial|pH
P_1720 = P_140;  % CoffeinSimulation|Organism|Brain|Intracellular|Volume of protein container
P_1721 = P_148;  % CoffeinSimulation|Organism|Brain|Intracellular|CYP1A2|Relative expression out.
P_1722 = P_1549;  % CoffeinSimulation|Organism|Brain|Intracellular|CYP1A2|Ontogeny factor
P_1723 = P_1556;  % CoffeinSimulation|Organism|Brain|Intracellular|CYP1A2|t1/2
P_1724 = (P_1639*P_149);  % CoffeinSimulation|Organism|Brain|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_1725 = (P_170*P_154);  % CoffeinSimulation|Organism|Fat|Weight (tissue)
P_1726 = (1-(P_174+P_162));  % CoffeinSimulation|Organism|Fat|Fraction intracellular
P_1727 = (P_162*(1-P_42)*P_170);  % CoffeinSimulation|Organism|Fat|Plasma|Volume
P_1728 = P_1551;  % CoffeinSimulation|Organism|Fat|Plasma|CYP1A2|Relative expression
P_1729 = P_1557;  % CoffeinSimulation|Organism|Fat|Plasma|CYP1A2|Relative expression (normalized)
P_1730 = P_1549;  % CoffeinSimulation|Organism|Fat|Plasma|CYP1A2|Ontogeny factor
P_1731 = P_1556;  % CoffeinSimulation|Organism|Fat|Plasma|CYP1A2|t1/2
P_1732 = (P_1639*P_185);  % CoffeinSimulation|Organism|Fat|Plasma|Caffeine-CYP1A2-MM|Km_app
P_1733 = (P_162*P_42*P_170);  % CoffeinSimulation|Organism|Fat|BloodCells|Volume
P_1734 = P_1560;  % CoffeinSimulation|Organism|Fat|BloodCells|CYP1A2|Relative expression
P_1735 = P_1555;  % CoffeinSimulation|Organism|Fat|BloodCells|CYP1A2|Relative expression (normalized)
P_1736 = P_1556;  % CoffeinSimulation|Organism|Fat|BloodCells|CYP1A2|t1/2
P_1737 = P_1549;  % CoffeinSimulation|Organism|Fat|BloodCells|CYP1A2|Ontogeny factor
P_1738 = (P_1639*P_187);  % CoffeinSimulation|Organism|Fat|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_1739 = (P_174*P_170);  % CoffeinSimulation|Organism|Fat|Interstitial|Volume
P_1740 = P_13;  % CoffeinSimulation|Organism|Fat|Interstitial|pH
P_1741 = P_170;  % CoffeinSimulation|Organism|Fat|Intracellular|Volume of protein container
P_1742 = P_191;  % CoffeinSimulation|Organism|Fat|Intracellular|CYP1A2|Relative expression out.
P_1743 = P_1549;  % CoffeinSimulation|Organism|Fat|Intracellular|CYP1A2|Ontogeny factor
P_1744 = P_1556;  % CoffeinSimulation|Organism|Fat|Intracellular|CYP1A2|t1/2
P_1745 = (P_1639*P_192);  % CoffeinSimulation|Organism|Fat|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_1746 = (P_225*P_194);  % CoffeinSimulation|Organism|Gonads|Weight (tissue)
P_1747 = (1-(P_214+P_206));  % CoffeinSimulation|Organism|Gonads|Fraction intracellular
P_1748 = (P_206*(1-P_42)*P_225);  % CoffeinSimulation|Organism|Gonads|Plasma|Volume
P_1749 = P_1551;  % CoffeinSimulation|Organism|Gonads|Plasma|CYP1A2|Relative expression
P_1750 = P_1557;  % CoffeinSimulation|Organism|Gonads|Plasma|CYP1A2|Relative expression (normalized)
P_1751 = P_1556;  % CoffeinSimulation|Organism|Gonads|Plasma|CYP1A2|t1/2
P_1752 = P_1549;  % CoffeinSimulation|Organism|Gonads|Plasma|CYP1A2|Ontogeny factor
P_1753 = (P_1639*P_227);  % CoffeinSimulation|Organism|Gonads|Plasma|Caffeine-CYP1A2-MM|Km_app
P_1754 = (P_206*P_42*P_225);  % CoffeinSimulation|Organism|Gonads|BloodCells|Volume
P_1755 = P_1560;  % CoffeinSimulation|Organism|Gonads|BloodCells|CYP1A2|Relative expression
P_1756 = P_1555;  % CoffeinSimulation|Organism|Gonads|BloodCells|CYP1A2|Relative expression (normalized)
P_1757 = P_1549;  % CoffeinSimulation|Organism|Gonads|BloodCells|CYP1A2|Ontogeny factor
P_1758 = P_1556;  % CoffeinSimulation|Organism|Gonads|BloodCells|CYP1A2|t1/2
P_1759 = (P_1639*P_229);  % CoffeinSimulation|Organism|Gonads|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_1760 = (P_214*P_225);  % CoffeinSimulation|Organism|Gonads|Interstitial|Volume
P_1761 = P_13;  % CoffeinSimulation|Organism|Gonads|Interstitial|pH
P_1762 = P_225;  % CoffeinSimulation|Organism|Gonads|Intracellular|Volume of protein container
P_1763 = P_233;  % CoffeinSimulation|Organism|Gonads|Intracellular|CYP1A2|Relative expression out.
P_1764 = P_1549;  % CoffeinSimulation|Organism|Gonads|Intracellular|CYP1A2|Ontogeny factor
P_1765 = P_1556;  % CoffeinSimulation|Organism|Gonads|Intracellular|CYP1A2|t1/2
P_1766 = (P_1639*P_234);  % CoffeinSimulation|Organism|Gonads|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_1767 = (P_267*P_236);  % CoffeinSimulation|Organism|Heart|Weight (tissue)
P_1768 = (1-(P_256+P_248));  % CoffeinSimulation|Organism|Heart|Fraction intracellular
P_1769 = (P_248*(1-P_42)*P_267);  % CoffeinSimulation|Organism|Heart|Plasma|Volume
P_1770 = P_1551;  % CoffeinSimulation|Organism|Heart|Plasma|CYP1A2|Relative expression
P_1771 = P_1557;  % CoffeinSimulation|Organism|Heart|Plasma|CYP1A2|Relative expression (normalized)
P_1772 = P_1556;  % CoffeinSimulation|Organism|Heart|Plasma|CYP1A2|t1/2
P_1773 = P_1549;  % CoffeinSimulation|Organism|Heart|Plasma|CYP1A2|Ontogeny factor
P_1774 = (P_1639*P_269);  % CoffeinSimulation|Organism|Heart|Plasma|Caffeine-CYP1A2-MM|Km_app
P_1775 = (P_248*P_42*P_267);  % CoffeinSimulation|Organism|Heart|BloodCells|Volume
P_1776 = P_1560;  % CoffeinSimulation|Organism|Heart|BloodCells|CYP1A2|Relative expression
P_1777 = P_1555;  % CoffeinSimulation|Organism|Heart|BloodCells|CYP1A2|Relative expression (normalized)
P_1778 = P_1556;  % CoffeinSimulation|Organism|Heart|BloodCells|CYP1A2|t1/2
P_1779 = P_1549;  % CoffeinSimulation|Organism|Heart|BloodCells|CYP1A2|Ontogeny factor
P_1780 = (P_1639*P_271);  % CoffeinSimulation|Organism|Heart|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_1781 = (P_256*P_267);  % CoffeinSimulation|Organism|Heart|Interstitial|Volume
P_1782 = P_13;  % CoffeinSimulation|Organism|Heart|Interstitial|pH
P_1783 = P_267;  % CoffeinSimulation|Organism|Heart|Intracellular|Volume of protein container
P_1784 = P_275;  % CoffeinSimulation|Organism|Heart|Intracellular|CYP1A2|Relative expression out.
P_1785 = P_1549;  % CoffeinSimulation|Organism|Heart|Intracellular|CYP1A2|Ontogeny factor
P_1786 = P_1556;  % CoffeinSimulation|Organism|Heart|Intracellular|CYP1A2|t1/2
P_1787 = (P_1639*P_276);  % CoffeinSimulation|Organism|Heart|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_1788 = (P_312*P_279);  % CoffeinSimulation|Organism|Kidney|Weight (tissue)
P_1789 = (1-(P_300+P_292));  % CoffeinSimulation|Organism|Kidney|Fraction intracellular
P_1790 = (P_292*(1-P_42)*P_312);  % CoffeinSimulation|Organism|Kidney|Plasma|Volume
P_1791 = P_1551;  % CoffeinSimulation|Organism|Kidney|Plasma|CYP1A2|Relative expression
P_1792 = P_1557;  % CoffeinSimulation|Organism|Kidney|Plasma|CYP1A2|Relative expression (normalized)
P_1793 = P_1556;  % CoffeinSimulation|Organism|Kidney|Plasma|CYP1A2|t1/2
P_1794 = P_1549;  % CoffeinSimulation|Organism|Kidney|Plasma|CYP1A2|Ontogeny factor
P_1795 = (P_1639*P_321);  % CoffeinSimulation|Organism|Kidney|Plasma|Caffeine-CYP1A2-MM|Km_app
P_1796 = (P_292*P_42*P_312);  % CoffeinSimulation|Organism|Kidney|BloodCells|Volume
P_1797 = P_1560;  % CoffeinSimulation|Organism|Kidney|BloodCells|CYP1A2|Relative expression
P_1798 = P_1555;  % CoffeinSimulation|Organism|Kidney|BloodCells|CYP1A2|Relative expression (normalized)
P_1799 = P_1556;  % CoffeinSimulation|Organism|Kidney|BloodCells|CYP1A2|t1/2
P_1800 = P_1549;  % CoffeinSimulation|Organism|Kidney|BloodCells|CYP1A2|Ontogeny factor
P_1801 = (P_1639*P_323);  % CoffeinSimulation|Organism|Kidney|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_1802 = (P_300*P_312);  % CoffeinSimulation|Organism|Kidney|Interstitial|Volume
P_1803 = P_13;  % CoffeinSimulation|Organism|Kidney|Interstitial|pH
P_1804 = P_312;  % CoffeinSimulation|Organism|Kidney|Intracellular|Volume of protein container
P_1805 = P_327;  % CoffeinSimulation|Organism|Kidney|Intracellular|CYP1A2|Relative expression out.
P_1806 = P_1556;  % CoffeinSimulation|Organism|Kidney|Intracellular|CYP1A2|t1/2
P_1807 = P_1549;  % CoffeinSimulation|Organism|Kidney|Intracellular|CYP1A2|Ontogeny factor
P_1808 = (P_1639*P_328);  % CoffeinSimulation|Organism|Kidney|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_1809 = (IIf((P_330 > 0),(y(52)/P_330),0));  % CoffeinSimulation|Organism|Kidney|Urine|Caffeine|Concentration
P_1810 = (3.141592653589793*(P_347+P_342)*P_346);  % CoffeinSimulation|Organism|Lumen|Stomach|Geometric surface area
P_1811 = (1/P_344);  % CoffeinSimulation|Organism|Lumen|Stomach|Intestinal transit rate (absolute)
P_1812 = (((P_347*P_347)+(P_347*P_342)+(P_342*P_342))*P_346*1.047197551196598);  % CoffeinSimulation|Organism|Lumen|Stomach|Volume
P_1813 = P_340;  % CoffeinSimulation|Organism|Lumen|Stomach|pH
P_1814 = P_349;  % CoffeinSimulation|Organism|Lumen|Stomach|CYP1A2|Relative expression out.
P_1815 = P_1550;  % CoffeinSimulation|Organism|Lumen|Stomach|CYP1A2|t1/2
P_1816 = P_1552;  % CoffeinSimulation|Organism|Lumen|Stomach|CYP1A2|Ontogeny factor
P_1817 = (P_1639*P_351);  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine-CYP1A2-MM|Km_app
P_1818 = (P_354+(P_34*P_358));  % CoffeinSimulation|Organism|Lumen|Duodenum|Length
P_1819 = (P_357+(P_34*P_364));  % CoffeinSimulation|Organism|Lumen|Duodenum|Proximal radius
P_1820 = (P_361+(P_360*(1-(exp((P_359*P_34))))));  % CoffeinSimulation|Organism|Lumen|Duodenum|Thickness of gut wall
P_1821 = (P_640*0.08699999999999999);  % CoffeinSimulation|Organism|Lumen|Duodenum|Volume (gut wall)
P_1822 = (P_363+(P_34*P_362));  % CoffeinSimulation|Organism|Lumen|Duodenum|Distal radius
P_1823 = P_368;  % CoffeinSimulation|Organism|Lumen|Duodenum|CYP1A2|Relative expression out.
P_1824 = P_1552;  % CoffeinSimulation|Organism|Lumen|Duodenum|CYP1A2|Ontogeny factor
P_1825 = P_1550;  % CoffeinSimulation|Organism|Lumen|Duodenum|CYP1A2|t1/2
P_1826 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_365))))),1));  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine|pKa_pH_WS_lum_F1
P_1827 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_365))))),1));  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine|pKa_pH_WS_lum_F3
P_1828 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_365))))),1));  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine|pKa_pH_WS_lum_F2
P_1829 = (P_1639*P_370);  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine-CYP1A2-MM|Km_app
P_1830 = (P_640*0.249);  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Volume (gut wall)
P_1831 = (P_376+(P_34*P_375));  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Length
P_1832 = (P_373+(P_34*P_372));  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Proximal radius
P_1833 = (P_379+(P_383*(1-(exp((P_382*P_34))))));  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Thickness of gut wall
P_1834 = (P_381+(P_34*P_377));  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Distal radius
P_1835 = P_387;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|CYP1A2|Relative expression out.
P_1836 = P_1550;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|CYP1A2|t1/2
P_1837 = P_1552;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|CYP1A2|Ontogeny factor
P_1838 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_384))))),1));  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine|pKa_pH_WS_lum_F2
P_1839 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_384))))),1));  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine|pKa_pH_WS_lum_F3
P_1840 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_384))))),1));  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine|pKa_pH_WS_lum_F1
P_1841 = (P_1639*P_389);  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine-CYP1A2-MM|Km_app
P_1842 = (P_402+(P_34*P_397));  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Proximal radius
P_1843 = (P_394+(P_393*(1-(exp((P_391*P_34))))));  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Thickness of gut wall
P_1844 = (P_640*0.184);  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Volume (gut wall)
P_1845 = (P_399+(P_34*P_392));  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Length
P_1846 = (P_396+(P_34*P_395));  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Distal radius
P_1847 = P_406;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|CYP1A2|Relative expression out.
P_1848 = P_1550;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|CYP1A2|t1/2
P_1849 = P_1552;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|CYP1A2|Ontogeny factor
P_1850 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_403))))),1));  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine|pKa_pH_WS_lum_F1
P_1851 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_403))))),1));  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine|pKa_pH_WS_lum_F2
P_1852 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_403))))),1));  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine|pKa_pH_WS_lum_F3
P_1853 = (P_1639*P_408);  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine-CYP1A2-MM|Km_app
P_1854 = (P_410+(P_34*P_413));  % CoffeinSimulation|Organism|Lumen|UpperIleum|Distal radius
P_1855 = (P_415+(P_34*P_414));  % CoffeinSimulation|Organism|Lumen|UpperIleum|Proximal radius
P_1856 = (P_418+(P_34*P_417));  % CoffeinSimulation|Organism|Lumen|UpperIleum|Length
P_1857 = (P_420+(P_412*(1-(exp((P_411*P_34))))));  % CoffeinSimulation|Organism|Lumen|UpperIleum|Thickness of gut wall
P_1858 = (P_640*0.324);  % CoffeinSimulation|Organism|Lumen|UpperIleum|Volume (gut wall)
P_1859 = P_425;  % CoffeinSimulation|Organism|Lumen|UpperIleum|CYP1A2|Relative expression out.
P_1860 = P_1552;  % CoffeinSimulation|Organism|Lumen|UpperIleum|CYP1A2|Ontogeny factor
P_1861 = P_1550;  % CoffeinSimulation|Organism|Lumen|UpperIleum|CYP1A2|t1/2
P_1862 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_422))))),1));  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine|pKa_pH_WS_lum_F2
P_1863 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_422))))),1));  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine|pKa_pH_WS_lum_F1
P_1864 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_422))))),1));  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine|pKa_pH_WS_lum_F3
P_1865 = (P_1639*P_427);  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine-CYP1A2-MM|Km_app
P_1866 = (P_640*0.156);  % CoffeinSimulation|Organism|Lumen|LowerIleum|Volume (gut wall)
P_1867 = (P_432+(P_434*(1-(exp((P_441*P_34))))));  % CoffeinSimulation|Organism|Lumen|LowerIleum|Thickness of gut wall
P_1868 = (P_433+(P_34*P_435));  % CoffeinSimulation|Organism|Lumen|LowerIleum|Length
P_1869 = (P_439+(P_34*P_438));  % CoffeinSimulation|Organism|Lumen|LowerIleum|Proximal radius
P_1870 = (P_437+(P_34*P_436));  % CoffeinSimulation|Organism|Lumen|LowerIleum|Distal radius
P_1871 = P_444;  % CoffeinSimulation|Organism|Lumen|LowerIleum|CYP1A2|Relative expression out.
P_1872 = P_1550;  % CoffeinSimulation|Organism|Lumen|LowerIleum|CYP1A2|t1/2
P_1873 = P_1552;  % CoffeinSimulation|Organism|Lumen|LowerIleum|CYP1A2|Ontogeny factor
P_1874 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_440))))),1));  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine|pKa_pH_WS_lum_F3
P_1875 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_440))))),1));  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine|pKa_pH_WS_lum_F2
P_1876 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_440))))),1));  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine|pKa_pH_WS_lum_F1
P_1877 = (P_1639*P_446);  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine-CYP1A2-MM|Km_app
P_1878 = (P_876*0.08470588);  % CoffeinSimulation|Organism|Lumen|Caecum|Volume (gut wall)
P_1879 = (P_454+(P_34*P_452));  % CoffeinSimulation|Organism|Lumen|Caecum|Distal radius
P_1880 = (P_457+(P_34*P_456));  % CoffeinSimulation|Organism|Lumen|Caecum|Length
P_1881 = (P_453+(P_34*P_448));  % CoffeinSimulation|Organism|Lumen|Caecum|Proximal radius
P_1882 = (P_451+(P_450*(1-(exp((P_449*P_34))))));  % CoffeinSimulation|Organism|Lumen|Caecum|Thickness of gut wall
P_1883 = P_463;  % CoffeinSimulation|Organism|Lumen|Caecum|CYP1A2|Relative expression out.
P_1884 = P_1552;  % CoffeinSimulation|Organism|Lumen|Caecum|CYP1A2|Ontogeny factor
P_1885 = P_1550;  % CoffeinSimulation|Organism|Lumen|Caecum|CYP1A2|t1/2
P_1886 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_460))))),1));  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine|pKa_pH_WS_lum_F1
P_1887 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_460))))),1));  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine|pKa_pH_WS_lum_F2
P_1888 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_460))))),1));  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine|pKa_pH_WS_lum_F3
P_1889 = (P_1639*P_465);  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine-CYP1A2-MM|Km_app
P_1890 = (P_876*0.15529412);  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Volume (gut wall)
P_1891 = (P_477+(P_34*P_473));  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Distal radius
P_1892 = (P_476+(P_34*P_472));  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Length
P_1893 = (P_469+(P_34*P_468));  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Proximal radius
P_1894 = (P_475+(P_479*(1-(exp((P_478*P_34))))));  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Thickness of gut wall
P_1895 = P_482;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|CYP1A2|Relative expression out.
P_1896 = P_1550;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|CYP1A2|t1/2
P_1897 = P_1552;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|CYP1A2|Ontogeny factor
P_1898 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_470))))),1));  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine|pKa_pH_WS_lum_F1
P_1899 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_470))))),1));  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine|pKa_pH_WS_lum_F2
P_1900 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_470))))),1));  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine|pKa_pH_WS_lum_F3
P_1901 = (P_1639*P_484);  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine-CYP1A2-MM|Km_app
P_1902 = (P_492+(P_34*P_491));  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Proximal radius
P_1903 = (P_490+(P_34*P_489));  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Distal radius
P_1904 = (P_495+(P_34*P_487));  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Length
P_1905 = (P_488+(P_486*(1-(exp((P_494*P_34))))));  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Thickness of gut wall
P_1906 = (P_876*0.32);  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Volume (gut wall)
P_1907 = P_501;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|CYP1A2|Relative expression out.
P_1908 = P_1550;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|CYP1A2|t1/2
P_1909 = P_1552;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|CYP1A2|Ontogeny factor
P_1910 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_498))))),1));  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine|pKa_pH_WS_lum_F1
P_1911 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_498))))),1));  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine|pKa_pH_WS_lum_F2
P_1912 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_498))))),1));  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine|pKa_pH_WS_lum_F3
P_1913 = (P_1639*P_503);  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine-CYP1A2-MM|Km_app
P_1914 = (P_508+(P_507*(1-(exp((P_506*P_34))))));  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Thickness of gut wall
P_1915 = (P_514+(P_34*P_513));  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Length
P_1916 = (P_876*0.24);  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Volume (gut wall)
P_1917 = (P_517+(P_34*P_509));  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Distal radius
P_1918 = (P_505+(P_34*P_510));  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Proximal radius
P_1919 = P_520;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|CYP1A2|Relative expression out.
P_1920 = P_1552;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|CYP1A2|Ontogeny factor
P_1921 = P_1550;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|CYP1A2|t1/2
P_1922 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_511))))),1));  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine|pKa_pH_WS_lum_F2
P_1923 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_511))))),1));  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine|pKa_pH_WS_lum_F1
P_1924 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_511))))),1));  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine|pKa_pH_WS_lum_F3
P_1925 = (P_1639*P_522);  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine-CYP1A2-MM|Km_app
P_1926 = (P_524+(P_34*P_535));  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Length
P_1927 = (P_532+(P_34*P_531));  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Proximal radius
P_1928 = (P_536+(P_527*(1-(exp((P_526*P_34))))));  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Thickness of gut wall
P_1929 = (P_876*0.135);  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Volume (gut wall)
P_1930 = (P_525+(P_34*P_529));  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Distal radius
P_1931 = P_539;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|CYP1A2|Relative expression out.
P_1932 = P_1550;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|CYP1A2|t1/2
P_1933 = P_1552;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|CYP1A2|Ontogeny factor
P_1934 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_533))))),1));  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine|pKa_pH_WS_lum_F1
P_1935 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_533))))),1));  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine|pKa_pH_WS_lum_F2
P_1936 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_533))))),1));  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine|pKa_pH_WS_lum_F3
P_1937 = (P_1639*P_541);  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine-CYP1A2-MM|Km_app
P_1938 = (P_552+(P_34*P_551));  % CoffeinSimulation|Organism|Lumen|Rectum|Distal radius
P_1939 = (P_547+(P_34*P_543));  % CoffeinSimulation|Organism|Lumen|Rectum|Length
P_1940 = (P_876*0.055);  % CoffeinSimulation|Organism|Lumen|Rectum|Volume (gut wall)
P_1941 = (P_554+(P_34*P_553));  % CoffeinSimulation|Organism|Lumen|Rectum|Proximal radius
P_1942 = (P_550+(P_548*(1-(exp((P_549*P_34))))));  % CoffeinSimulation|Organism|Lumen|Rectum|Thickness of gut wall
P_1943 = P_558;  % CoffeinSimulation|Organism|Lumen|Rectum|CYP1A2|Relative expression out.
P_1944 = P_1550;  % CoffeinSimulation|Organism|Lumen|Rectum|CYP1A2|t1/2
P_1945 = P_1552;  % CoffeinSimulation|Organism|Lumen|Rectum|CYP1A2|Ontogeny factor
P_1946 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_555))))),1));  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine|pKa_pH_WS_lum_F3
P_1947 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_555))))),1));  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine|pKa_pH_WS_lum_F2
P_1948 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_555))))),1));  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine|pKa_pH_WS_lum_F1
P_1949 = (P_1639*P_560);  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine-CYP1A2-MM|Km_app
P_1950 = (IIf((P_562 > 0),(y(101)/P_562),0));  % CoffeinSimulation|Organism|Lumen|Feces|Caffeine|Concentration
P_1951 = (P_594*P_563);  % CoffeinSimulation|Organism|Stomach|Weight (tissue)
P_1952 = (1-(P_583+P_575));  % CoffeinSimulation|Organism|Stomach|Fraction intracellular
P_1953 = (P_575*(1-P_42)*P_594);  % CoffeinSimulation|Organism|Stomach|Plasma|Volume
P_1954 = P_1551;  % CoffeinSimulation|Organism|Stomach|Plasma|CYP1A2|Relative expression
P_1955 = P_1557;  % CoffeinSimulation|Organism|Stomach|Plasma|CYP1A2|Relative expression (normalized)
P_1956 = P_1549;  % CoffeinSimulation|Organism|Stomach|Plasma|CYP1A2|Ontogeny factor
P_1957 = P_1556;  % CoffeinSimulation|Organism|Stomach|Plasma|CYP1A2|t1/2
P_1958 = (P_1639*P_596);  % CoffeinSimulation|Organism|Stomach|Plasma|Caffeine-CYP1A2-MM|Km_app
P_1959 = (P_575*P_42*P_594);  % CoffeinSimulation|Organism|Stomach|BloodCells|Volume
P_1960 = P_1560;  % CoffeinSimulation|Organism|Stomach|BloodCells|CYP1A2|Relative expression
P_1961 = P_1555;  % CoffeinSimulation|Organism|Stomach|BloodCells|CYP1A2|Relative expression (normalized)
P_1962 = P_1549;  % CoffeinSimulation|Organism|Stomach|BloodCells|CYP1A2|Ontogeny factor
P_1963 = P_1556;  % CoffeinSimulation|Organism|Stomach|BloodCells|CYP1A2|t1/2
P_1964 = (P_1639*P_598);  % CoffeinSimulation|Organism|Stomach|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_1965 = (P_583*P_594);  % CoffeinSimulation|Organism|Stomach|Interstitial|Volume
P_1966 = P_13;  % CoffeinSimulation|Organism|Stomach|Interstitial|pH
P_1967 = P_594;  % CoffeinSimulation|Organism|Stomach|Intracellular|Volume of protein container
P_1968 = P_602;  % CoffeinSimulation|Organism|Stomach|Intracellular|CYP1A2|Relative expression out.
P_1969 = P_1549;  % CoffeinSimulation|Organism|Stomach|Intracellular|CYP1A2|Ontogeny factor
P_1970 = P_1556;  % CoffeinSimulation|Organism|Stomach|Intracellular|CYP1A2|t1/2
P_1971 = (P_1639*P_603);  % CoffeinSimulation|Organism|Stomach|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_1972 = (P_640*P_606);  % CoffeinSimulation|Organism|SmallIntestine|Weight (tissue)
P_1973 = ((P_610*P_639)+P_612);  % CoffeinSimulation|Organism|SmallIntestine|Small intestinal transit time factor
P_1974 = (1-(P_628+P_620));  % CoffeinSimulation|Organism|SmallIntestine|Fraction intracellular
P_1975 = P_1551;  % CoffeinSimulation|Organism|SmallIntestine|Plasma|CYP1A2|Relative expression
P_1976 = P_1557;  % CoffeinSimulation|Organism|SmallIntestine|Plasma|CYP1A2|Relative expression (normalized)
P_1977 = P_1549;  % CoffeinSimulation|Organism|SmallIntestine|Plasma|CYP1A2|Ontogeny factor
P_1978 = P_1556;  % CoffeinSimulation|Organism|SmallIntestine|Plasma|CYP1A2|t1/2
P_1979 = (P_1639*P_642);  % CoffeinSimulation|Organism|SmallIntestine|Plasma|Caffeine-CYP1A2-MM|Km_app
P_1980 = P_1560;  % CoffeinSimulation|Organism|SmallIntestine|BloodCells|CYP1A2|Relative expression
P_1981 = P_1555;  % CoffeinSimulation|Organism|SmallIntestine|BloodCells|CYP1A2|Relative expression (normalized)
P_1982 = P_1549;  % CoffeinSimulation|Organism|SmallIntestine|BloodCells|CYP1A2|Ontogeny factor
P_1983 = P_1556;  % CoffeinSimulation|Organism|SmallIntestine|BloodCells|CYP1A2|t1/2
P_1984 = (P_1639*P_644);  % CoffeinSimulation|Organism|SmallIntestine|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_1985 = P_13;  % CoffeinSimulation|Organism|SmallIntestine|Interstitial|pH
P_1986 = P_648;  % CoffeinSimulation|Organism|SmallIntestine|Intracellular|CYP1A2|Relative expression out.
P_1987 = P_1549;  % CoffeinSimulation|Organism|SmallIntestine|Intracellular|CYP1A2|Ontogeny factor
P_1988 = P_1556;  % CoffeinSimulation|Organism|SmallIntestine|Intracellular|CYP1A2|t1/2
P_1989 = (P_1639*P_649);  % CoffeinSimulation|Organism|SmallIntestine|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_1990 = (1-(P_669+P_661));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Fraction intracellular
P_1991 = P_1551;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Plasma|CYP1A2|Relative expression
P_1992 = P_1557;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Plasma|CYP1A2|Relative expression (normalized)
P_1993 = P_1550;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Plasma|CYP1A2|t1/2
P_1994 = P_1549;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Plasma|CYP1A2|Ontogeny factor
P_1995 = (P_1639*P_680);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Plasma|Caffeine-CYP1A2-MM|Km_app
P_1996 = P_1560;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|BloodCells|CYP1A2|Relative expression
P_1997 = P_1555;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|BloodCells|CYP1A2|Relative expression (normalized)
P_1998 = P_1549;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|BloodCells|CYP1A2|Ontogeny factor
P_1999 = P_1550;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|BloodCells|CYP1A2|t1/2
P_2000 = (P_1639*P_682);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2001 = P_13;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Interstitial|pH
P_2002 = P_686;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Intracellular|CYP1A2|Relative expression out.
P_2003 = P_1550;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Intracellular|CYP1A2|t1/2
P_2004 = P_1549;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Intracellular|CYP1A2|Ontogeny factor
P_2005 = (P_1639*P_687);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_2006 = (1-(P_707+P_699));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Fraction intracellular
P_2007 = P_1551;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Plasma|CYP1A2|Relative expression
P_2008 = P_1557;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Plasma|CYP1A2|Relative expression (normalized)
P_2009 = P_1549;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Plasma|CYP1A2|Ontogeny factor
P_2010 = P_1550;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Plasma|CYP1A2|t1/2
P_2011 = (P_1639*P_718);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Plasma|Caffeine-CYP1A2-MM|Km_app
P_2012 = P_1560;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|BloodCells|CYP1A2|Relative expression
P_2013 = P_1555;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|BloodCells|CYP1A2|Relative expression (normalized)
P_2014 = P_1549;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|BloodCells|CYP1A2|Ontogeny factor
P_2015 = P_1550;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|BloodCells|CYP1A2|t1/2
P_2016 = (P_1639*P_720);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2017 = P_13;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Interstitial|pH
P_2018 = P_724;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Intracellular|CYP1A2|Relative expression out.
P_2019 = P_1549;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Intracellular|CYP1A2|Ontogeny factor
P_2020 = P_1550;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Intracellular|CYP1A2|t1/2
P_2021 = (P_1639*P_725);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_2022 = (1-(P_745+P_737));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Fraction intracellular
P_2023 = P_1551;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Plasma|CYP1A2|Relative expression
P_2024 = P_1557;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Plasma|CYP1A2|Relative expression (normalized)
P_2025 = P_1550;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Plasma|CYP1A2|t1/2
P_2026 = P_1549;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Plasma|CYP1A2|Ontogeny factor
P_2027 = (P_1639*P_756);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Plasma|Caffeine-CYP1A2-MM|Km_app
P_2028 = P_1560;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|BloodCells|CYP1A2|Relative expression
P_2029 = P_1555;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|BloodCells|CYP1A2|Relative expression (normalized)
P_2030 = P_1549;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|BloodCells|CYP1A2|Ontogeny factor
P_2031 = P_1550;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|BloodCells|CYP1A2|t1/2
P_2032 = (P_1639*P_758);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2033 = P_13;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Interstitial|pH
P_2034 = P_762;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Intracellular|CYP1A2|Relative expression out.
P_2035 = P_1549;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Intracellular|CYP1A2|Ontogeny factor
P_2036 = P_1550;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Intracellular|CYP1A2|t1/2
P_2037 = (P_1639*P_763);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_2038 = (1-(P_783+P_775));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Fraction intracellular
P_2039 = P_1551;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Plasma|CYP1A2|Relative expression
P_2040 = P_1557;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Plasma|CYP1A2|Relative expression (normalized)
P_2041 = P_1549;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Plasma|CYP1A2|Ontogeny factor
P_2042 = P_1550;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Plasma|CYP1A2|t1/2
P_2043 = (P_1639*P_794);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Plasma|Caffeine-CYP1A2-MM|Km_app
P_2044 = P_1560;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|BloodCells|CYP1A2|Relative expression
P_2045 = P_1555;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|BloodCells|CYP1A2|Relative expression (normalized)
P_2046 = P_1549;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|BloodCells|CYP1A2|Ontogeny factor
P_2047 = P_1550;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|BloodCells|CYP1A2|t1/2
P_2048 = (P_1639*P_796);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2049 = P_13;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Interstitial|pH
P_2050 = P_800;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Intracellular|CYP1A2|Relative expression out.
P_2051 = P_1550;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Intracellular|CYP1A2|t1/2
P_2052 = P_1549;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Intracellular|CYP1A2|Ontogeny factor
P_2053 = (P_1639*P_801);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_2054 = (1-(P_821+P_813));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Fraction intracellular
P_2055 = P_1551;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Plasma|CYP1A2|Relative expression
P_2056 = P_1557;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Plasma|CYP1A2|Relative expression (normalized)
P_2057 = P_1550;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Plasma|CYP1A2|t1/2
P_2058 = P_1549;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Plasma|CYP1A2|Ontogeny factor
P_2059 = (P_1639*P_832);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Plasma|Caffeine-CYP1A2-MM|Km_app
P_2060 = P_1560;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|BloodCells|CYP1A2|Relative expression
P_2061 = P_1555;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|BloodCells|CYP1A2|Relative expression (normalized)
P_2062 = P_1549;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|BloodCells|CYP1A2|Ontogeny factor
P_2063 = P_1550;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|BloodCells|CYP1A2|t1/2
P_2064 = (P_1639*P_834);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2065 = P_13;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Interstitial|pH
P_2066 = P_838;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Intracellular|CYP1A2|Relative expression out.
P_2067 = P_1549;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Intracellular|CYP1A2|Ontogeny factor
P_2068 = P_1550;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Intracellular|CYP1A2|t1/2
P_2069 = (P_1639*P_839);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_2070 = (P_876*P_842);  % CoffeinSimulation|Organism|LargeIntestine|Weight (tissue)
P_2071 = ((P_847*P_875)+P_848);  % CoffeinSimulation|Organism|LargeIntestine|Large intestinal transit time factor
P_2072 = (1-(P_864+P_856));  % CoffeinSimulation|Organism|LargeIntestine|Fraction intracellular
P_2073 = P_1551;  % CoffeinSimulation|Organism|LargeIntestine|Plasma|CYP1A2|Relative expression
P_2074 = P_1557;  % CoffeinSimulation|Organism|LargeIntestine|Plasma|CYP1A2|Relative expression (normalized)
P_2075 = P_1556;  % CoffeinSimulation|Organism|LargeIntestine|Plasma|CYP1A2|t1/2
P_2076 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Plasma|CYP1A2|Ontogeny factor
P_2077 = (P_1639*P_878);  % CoffeinSimulation|Organism|LargeIntestine|Plasma|Caffeine-CYP1A2-MM|Km_app
P_2078 = P_1560;  % CoffeinSimulation|Organism|LargeIntestine|BloodCells|CYP1A2|Relative expression
P_2079 = P_1555;  % CoffeinSimulation|Organism|LargeIntestine|BloodCells|CYP1A2|Relative expression (normalized)
P_2080 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|BloodCells|CYP1A2|Ontogeny factor
P_2081 = P_1556;  % CoffeinSimulation|Organism|LargeIntestine|BloodCells|CYP1A2|t1/2
P_2082 = (P_1639*P_880);  % CoffeinSimulation|Organism|LargeIntestine|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2083 = P_13;  % CoffeinSimulation|Organism|LargeIntestine|Interstitial|pH
P_2084 = P_884;  % CoffeinSimulation|Organism|LargeIntestine|Intracellular|CYP1A2|Relative expression out.
P_2085 = P_1556;  % CoffeinSimulation|Organism|LargeIntestine|Intracellular|CYP1A2|t1/2
P_2086 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Intracellular|CYP1A2|Ontogeny factor
P_2087 = (P_1639*P_885);  % CoffeinSimulation|Organism|LargeIntestine|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_2088 = (1-(P_905+P_897));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Fraction intracellular
P_2089 = P_1551;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Plasma|CYP1A2|Relative expression
P_2090 = P_1557;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Plasma|CYP1A2|Relative expression (normalized)
P_2091 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Plasma|CYP1A2|Ontogeny factor
P_2092 = P_1550;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Plasma|CYP1A2|t1/2
P_2093 = (P_1639*P_916);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Plasma|Caffeine-CYP1A2-MM|Km_app
P_2094 = P_1560;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|BloodCells|CYP1A2|Relative expression
P_2095 = P_1555;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|BloodCells|CYP1A2|Relative expression (normalized)
P_2096 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|BloodCells|CYP1A2|Ontogeny factor
P_2097 = P_1550;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|BloodCells|CYP1A2|t1/2
P_2098 = (P_1639*P_918);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2099 = P_13;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Interstitial|pH
P_2100 = P_922;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Intracellular|CYP1A2|Relative expression out.
P_2101 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Intracellular|CYP1A2|Ontogeny factor
P_2102 = P_1550;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Intracellular|CYP1A2|t1/2
P_2103 = (P_1639*P_923);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_2104 = (1-(P_943+P_935));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Fraction intracellular
P_2105 = P_1551;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Plasma|CYP1A2|Relative expression
P_2106 = P_1557;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Plasma|CYP1A2|Relative expression (normalized)
P_2107 = P_1550;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Plasma|CYP1A2|t1/2
P_2108 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Plasma|CYP1A2|Ontogeny factor
P_2109 = (P_1639*P_954);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Plasma|Caffeine-CYP1A2-MM|Km_app
P_2110 = P_1560;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|BloodCells|CYP1A2|Relative expression
P_2111 = P_1555;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|BloodCells|CYP1A2|Relative expression (normalized)
P_2112 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|BloodCells|CYP1A2|Ontogeny factor
P_2113 = P_1550;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|BloodCells|CYP1A2|t1/2
P_2114 = (P_1639*P_956);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2115 = P_13;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Interstitial|pH
P_2116 = P_960;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Intracellular|CYP1A2|Relative expression out.
P_2117 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Intracellular|CYP1A2|Ontogeny factor
P_2118 = P_1550;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Intracellular|CYP1A2|t1/2
P_2119 = (P_1639*P_961);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_2120 = (1-(P_981+P_973));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Fraction intracellular
P_2121 = P_1551;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Plasma|CYP1A2|Relative expression
P_2122 = P_1557;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Plasma|CYP1A2|Relative expression (normalized)
P_2123 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Plasma|CYP1A2|Ontogeny factor
P_2124 = P_1550;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Plasma|CYP1A2|t1/2
P_2125 = (P_1639*P_992);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Plasma|Caffeine-CYP1A2-MM|Km_app
P_2126 = P_1560;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|BloodCells|CYP1A2|Relative expression
P_2127 = P_1555;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|BloodCells|CYP1A2|Relative expression (normalized)
P_2128 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|BloodCells|CYP1A2|Ontogeny factor
P_2129 = P_1550;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|BloodCells|CYP1A2|t1/2
P_2130 = (P_1639*P_994);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2131 = P_13;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Interstitial|pH
P_2132 = P_998;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Intracellular|CYP1A2|Relative expression out.
P_2133 = P_1550;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Intracellular|CYP1A2|t1/2
P_2134 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Intracellular|CYP1A2|Ontogeny factor
P_2135 = (P_1639*P_999);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_2136 = (1-(P_1019+P_1011));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Fraction intracellular
P_2137 = P_1551;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Plasma|CYP1A2|Relative expression
P_2138 = P_1557;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Plasma|CYP1A2|Relative expression (normalized)
P_2139 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Plasma|CYP1A2|Ontogeny factor
P_2140 = P_1550;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Plasma|CYP1A2|t1/2
P_2141 = (P_1639*P_1030);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Plasma|Caffeine-CYP1A2-MM|Km_app
P_2142 = P_1560;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|BloodCells|CYP1A2|Relative expression
P_2143 = P_1555;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|BloodCells|CYP1A2|Relative expression (normalized)
P_2144 = P_1550;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|BloodCells|CYP1A2|t1/2
P_2145 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|BloodCells|CYP1A2|Ontogeny factor
P_2146 = (P_1639*P_1032);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2147 = P_13;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Interstitial|pH
P_2148 = P_1036;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Intracellular|CYP1A2|Relative expression out.
P_2149 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Intracellular|CYP1A2|Ontogeny factor
P_2150 = P_1550;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Intracellular|CYP1A2|t1/2
P_2151 = (P_1639*P_1037);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_2152 = (1-(P_1057+P_1049));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Fraction intracellular
P_2153 = P_1551;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Plasma|CYP1A2|Relative expression
P_2154 = P_1557;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Plasma|CYP1A2|Relative expression (normalized)
P_2155 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Plasma|CYP1A2|Ontogeny factor
P_2156 = P_1550;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Plasma|CYP1A2|t1/2
P_2157 = (P_1639*P_1068);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Plasma|Caffeine-CYP1A2-MM|Km_app
P_2158 = P_1560;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|BloodCells|CYP1A2|Relative expression
P_2159 = P_1555;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|BloodCells|CYP1A2|Relative expression (normalized)
P_2160 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|BloodCells|CYP1A2|Ontogeny factor
P_2161 = P_1550;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|BloodCells|CYP1A2|t1/2
P_2162 = (P_1639*P_1070);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2163 = P_13;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Interstitial|pH
P_2164 = P_1074;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Intracellular|CYP1A2|Relative expression out.
P_2165 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Intracellular|CYP1A2|Ontogeny factor
P_2166 = P_1550;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Intracellular|CYP1A2|t1/2
P_2167 = (P_1639*P_1075);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_2168 = (1-(P_1095+P_1087));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Fraction intracellular
P_2169 = P_1551;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Plasma|CYP1A2|Relative expression
P_2170 = P_1557;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Plasma|CYP1A2|Relative expression (normalized)
P_2171 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Plasma|CYP1A2|Ontogeny factor
P_2172 = P_1550;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Plasma|CYP1A2|t1/2
P_2173 = (P_1639*P_1106);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Plasma|Caffeine-CYP1A2-MM|Km_app
P_2174 = P_1560;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|BloodCells|CYP1A2|Relative expression
P_2175 = P_1555;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|BloodCells|CYP1A2|Relative expression (normalized)
P_2176 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|BloodCells|CYP1A2|Ontogeny factor
P_2177 = P_1550;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|BloodCells|CYP1A2|t1/2
P_2178 = (P_1639*P_1108);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2179 = P_13;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Interstitial|pH
P_2180 = P_1112;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Intracellular|CYP1A2|Relative expression out.
P_2181 = P_1550;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Intracellular|CYP1A2|t1/2
P_2182 = P_1549;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Intracellular|CYP1A2|Ontogeny factor
P_2183 = (P_1639*P_1113);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_2184 = (P_1151*P_1121);  % CoffeinSimulation|Organism|Liver|Weight (tissue)
P_2185 = (1-(P_1140+P_1130));  % CoffeinSimulation|Organism|Liver|Fraction intracellular
P_2186 = P_1122;  % CoffeinSimulation|Organism|Liver|Periportal|Allometric scale factor
P_2187 = P_1121;  % CoffeinSimulation|Organism|Liver|Periportal|Density (tissue)
P_2188 = P_1123;  % CoffeinSimulation|Organism|Liver|Periportal|Fraction of blood for sampling
P_2189 = (P_1151*(IIf(P_1115,P_1116,1)));  % CoffeinSimulation|Organism|Liver|Periportal|Volume
P_2190 = P_1126;  % CoffeinSimulation|Organism|Liver|Periportal|Flow fraction via large pores
P_2191 = P_1125;  % CoffeinSimulation|Organism|Liver|Periportal|Hydraulic conductivity
P_2192 = P_1127;  % CoffeinSimulation|Organism|Liver|Periportal|Radius (large pores)
P_2193 = P_1124;  % CoffeinSimulation|Organism|Liver|Periportal|Radius (small pores)
P_2194 = P_1128;  % CoffeinSimulation|Organism|Liver|Periportal|Vf (neutral lipid)-PT
P_2195 = P_1129;  % CoffeinSimulation|Organism|Liver|Periportal|Vf (lipid)
P_2196 = P_1131;  % CoffeinSimulation|Organism|Liver|Periportal|Vf (phospholipid)-PT
P_2197 = P_1132;  % CoffeinSimulation|Organism|Liver|Periportal|Vf (protein)
P_2198 = P_1135;  % CoffeinSimulation|Organism|Liver|Periportal|Lipoprotein ratio (tissue/plasma)
P_2199 = P_1136;  % CoffeinSimulation|Organism|Liver|Periportal|Vf (water)
P_2200 = P_1138;  % CoffeinSimulation|Organism|Liver|Periportal|Microsomal protein mass/g tissue
P_2201 = P_1137;  % CoffeinSimulation|Organism|Liver|Periportal|Vf (water)-PT
P_2202 = P_1130;  % CoffeinSimulation|Organism|Liver|Periportal|Fraction vascular
P_2203 = P_1134;  % CoffeinSimulation|Organism|Liver|Periportal|Albumin ratio (tissue/plasma)-PT
P_2204 = P_1133;  % CoffeinSimulation|Organism|Liver|Periportal|Albumin ratio (tissue/plasma)
P_2205 = P_1139;  % CoffeinSimulation|Organism|Liver|Periportal|Number of cells/g tissue
P_2206 = P_1140;  % CoffeinSimulation|Organism|Liver|Periportal|Fraction interstitial
P_2207 = P_1141;  % CoffeinSimulation|Organism|Liver|Periportal|Vf (neutral lipid)-RR
P_2208 = P_1142;  % CoffeinSimulation|Organism|Liver|Periportal|Vf (neutral lipid)-WS
P_2209 = P_1144;  % CoffeinSimulation|Organism|Liver|Periportal|Vf (neutral phospholipid, plasma)-WS
P_2210 = P_1143;  % CoffeinSimulation|Organism|Liver|Periportal|Vf (neutral phospholipid)-RR
P_2211 = P_1146;  % CoffeinSimulation|Organism|Liver|Periportal|Vf (protein)-WS
P_2212 = P_1145;  % CoffeinSimulation|Organism|Liver|Periportal|Vf (extracellular water)-RR
P_2213 = P_1147;  % CoffeinSimulation|Organism|Liver|Periportal|Vf (intracellular water)-RR
P_2214 = P_1148;  % CoffeinSimulation|Organism|Liver|Periportal|Vf (water)-WS
P_2215 = P_1150;  % CoffeinSimulation|Organism|Liver|Periportal|Acidic phospholipids [mg/g] - RR
P_2216 = P_1149;  % CoffeinSimulation|Organism|Liver|Periportal|Vf (acidic phospholipids)-WS
P_2217 = P_1152;  % CoffeinSimulation|Organism|Liver|Periportal|Specific blood flow rate
P_2218 = P_1551;  % CoffeinSimulation|Organism|Liver|Periportal|Plasma|CYP1A2|Relative expression
P_2219 = P_1557;  % CoffeinSimulation|Organism|Liver|Periportal|Plasma|CYP1A2|Relative expression (normalized)
P_2220 = P_1549;  % CoffeinSimulation|Organism|Liver|Periportal|Plasma|CYP1A2|Ontogeny factor
P_2221 = P_1556;  % CoffeinSimulation|Organism|Liver|Periportal|Plasma|CYP1A2|t1/2
P_2222 = (P_1639*P_1153);  % CoffeinSimulation|Organism|Liver|Periportal|Plasma|Caffeine-CYP1A2-MM|Km_app
P_2223 = P_1560;  % CoffeinSimulation|Organism|Liver|Periportal|BloodCells|CYP1A2|Relative expression
P_2224 = P_1555;  % CoffeinSimulation|Organism|Liver|Periportal|BloodCells|CYP1A2|Relative expression (normalized)
P_2225 = P_1549;  % CoffeinSimulation|Organism|Liver|Periportal|BloodCells|CYP1A2|Ontogeny factor
P_2226 = P_1556;  % CoffeinSimulation|Organism|Liver|Periportal|BloodCells|CYP1A2|t1/2
P_2227 = (P_1639*P_1155);  % CoffeinSimulation|Organism|Liver|Periportal|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2228 = P_13;  % CoffeinSimulation|Organism|Liver|Periportal|Interstitial|pH
P_2229 = P_1169;  % CoffeinSimulation|Organism|Liver|Periportal|Intracellular|pH
P_2230 = P_1158;  % CoffeinSimulation|Organism|Liver|Periportal|Intracellular|CYP1A2|Relative expression out.
P_2231 = P_1549;  % CoffeinSimulation|Organism|Liver|Periportal|Intracellular|CYP1A2|Ontogeny factor
P_2232 = P_1556;  % CoffeinSimulation|Organism|Liver|Periportal|Intracellular|CYP1A2|t1/2
P_2233 = (P_1639*P_1159);  % CoffeinSimulation|Organism|Liver|Periportal|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_2234 = P_1122;  % CoffeinSimulation|Organism|Liver|Pericentral|Allometric scale factor
P_2235 = P_1121;  % CoffeinSimulation|Organism|Liver|Pericentral|Density (tissue)
P_2236 = P_1123;  % CoffeinSimulation|Organism|Liver|Pericentral|Fraction of blood for sampling
P_2237 = (P_1151*(IIf(P_1115,(1-P_1116),0)));  % CoffeinSimulation|Organism|Liver|Pericentral|Volume
P_2238 = P_1124;  % CoffeinSimulation|Organism|Liver|Pericentral|Radius (small pores)
P_2239 = P_1127;  % CoffeinSimulation|Organism|Liver|Pericentral|Radius (large pores)
P_2240 = P_1125;  % CoffeinSimulation|Organism|Liver|Pericentral|Hydraulic conductivity
P_2241 = P_1126;  % CoffeinSimulation|Organism|Liver|Pericentral|Flow fraction via large pores
P_2242 = P_1128;  % CoffeinSimulation|Organism|Liver|Pericentral|Vf (neutral lipid)-PT
P_2243 = P_1129;  % CoffeinSimulation|Organism|Liver|Pericentral|Vf (lipid)
P_2244 = P_1132;  % CoffeinSimulation|Organism|Liver|Pericentral|Vf (protein)
P_2245 = P_1131;  % CoffeinSimulation|Organism|Liver|Pericentral|Vf (phospholipid)-PT
P_2246 = P_1130;  % CoffeinSimulation|Organism|Liver|Pericentral|Fraction vascular
P_2247 = P_1135;  % CoffeinSimulation|Organism|Liver|Pericentral|Lipoprotein ratio (tissue/plasma)
P_2248 = P_1133;  % CoffeinSimulation|Organism|Liver|Pericentral|Albumin ratio (tissue/plasma)
P_2249 = P_1134;  % CoffeinSimulation|Organism|Liver|Pericentral|Albumin ratio (tissue/plasma)-PT
P_2250 = P_1136;  % CoffeinSimulation|Organism|Liver|Pericentral|Vf (water)
P_2251 = P_1137;  % CoffeinSimulation|Organism|Liver|Pericentral|Vf (water)-PT
P_2252 = P_1138;  % CoffeinSimulation|Organism|Liver|Pericentral|Microsomal protein mass/g tissue
P_2253 = P_1139;  % CoffeinSimulation|Organism|Liver|Pericentral|Number of cells/g tissue
P_2254 = P_1140;  % CoffeinSimulation|Organism|Liver|Pericentral|Fraction interstitial
P_2255 = P_1142;  % CoffeinSimulation|Organism|Liver|Pericentral|Vf (neutral lipid)-WS
P_2256 = P_1141;  % CoffeinSimulation|Organism|Liver|Pericentral|Vf (neutral lipid)-RR
P_2257 = P_1144;  % CoffeinSimulation|Organism|Liver|Pericentral|Vf (neutral phospholipid, plasma)-WS
P_2258 = P_1143;  % CoffeinSimulation|Organism|Liver|Pericentral|Vf (neutral phospholipid)-RR
P_2259 = P_1145;  % CoffeinSimulation|Organism|Liver|Pericentral|Vf (extracellular water)-RR
P_2260 = P_1146;  % CoffeinSimulation|Organism|Liver|Pericentral|Vf (protein)-WS
P_2261 = P_1148;  % CoffeinSimulation|Organism|Liver|Pericentral|Vf (water)-WS
P_2262 = P_1147;  % CoffeinSimulation|Organism|Liver|Pericentral|Vf (intracellular water)-RR
P_2263 = P_1149;  % CoffeinSimulation|Organism|Liver|Pericentral|Vf (acidic phospholipids)-WS
P_2264 = P_1150;  % CoffeinSimulation|Organism|Liver|Pericentral|Acidic phospholipids [mg/g] - RR
P_2265 = P_1152;  % CoffeinSimulation|Organism|Liver|Pericentral|Specific blood flow rate
P_2266 = P_1551;  % CoffeinSimulation|Organism|Liver|Pericentral|Plasma|CYP1A2|Relative expression
P_2267 = P_1557;  % CoffeinSimulation|Organism|Liver|Pericentral|Plasma|CYP1A2|Relative expression (normalized)
P_2268 = P_1549;  % CoffeinSimulation|Organism|Liver|Pericentral|Plasma|CYP1A2|Ontogeny factor
P_2269 = P_1556;  % CoffeinSimulation|Organism|Liver|Pericentral|Plasma|CYP1A2|t1/2
P_2270 = (P_1639*P_1161);  % CoffeinSimulation|Organism|Liver|Pericentral|Plasma|Caffeine-CYP1A2-MM|Km_app
P_2271 = P_1560;  % CoffeinSimulation|Organism|Liver|Pericentral|BloodCells|CYP1A2|Relative expression
P_2272 = P_1555;  % CoffeinSimulation|Organism|Liver|Pericentral|BloodCells|CYP1A2|Relative expression (normalized)
P_2273 = P_1556;  % CoffeinSimulation|Organism|Liver|Pericentral|BloodCells|CYP1A2|t1/2
P_2274 = P_1549;  % CoffeinSimulation|Organism|Liver|Pericentral|BloodCells|CYP1A2|Ontogeny factor
P_2275 = (P_1639*P_1163);  % CoffeinSimulation|Organism|Liver|Pericentral|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2276 = P_13;  % CoffeinSimulation|Organism|Liver|Pericentral|Interstitial|pH
P_2277 = P_1169;  % CoffeinSimulation|Organism|Liver|Pericentral|Intracellular|pH
P_2278 = P_1166;  % CoffeinSimulation|Organism|Liver|Pericentral|Intracellular|CYP1A2|Relative expression out.
P_2279 = P_1549;  % CoffeinSimulation|Organism|Liver|Pericentral|Intracellular|CYP1A2|Ontogeny factor
P_2280 = P_1556;  % CoffeinSimulation|Organism|Liver|Pericentral|Intracellular|CYP1A2|t1/2
P_2281 = (P_1639*P_1167);  % CoffeinSimulation|Organism|Liver|Pericentral|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_2282 = (P_1130*(1-P_42)*P_1151);  % CoffeinSimulation|Organism|Liver|Plasma|Volume
P_2283 = (P_1130*P_42*P_1151);  % CoffeinSimulation|Organism|Liver|BloodCells|Volume
P_2284 = (P_1140*P_1151);  % CoffeinSimulation|Organism|Liver|Interstitial|Volume
P_2285 = P_13;  % CoffeinSimulation|Organism|Liver|Interstitial|pH
P_2286 = (P_1200*P_1170);  % CoffeinSimulation|Organism|Lung|Weight (tissue)
P_2287 = (1-(P_1189+P_1201));  % CoffeinSimulation|Organism|Lung|Fraction intracellular
P_2288 = (P_1201*(1-P_42)*P_1200);  % CoffeinSimulation|Organism|Lung|Plasma|Volume
P_2289 = P_1551;  % CoffeinSimulation|Organism|Lung|Plasma|CYP1A2|Relative expression
P_2290 = P_1557;  % CoffeinSimulation|Organism|Lung|Plasma|CYP1A2|Relative expression (normalized)
P_2291 = P_1549;  % CoffeinSimulation|Organism|Lung|Plasma|CYP1A2|Ontogeny factor
P_2292 = P_1556;  % CoffeinSimulation|Organism|Lung|Plasma|CYP1A2|t1/2
P_2293 = (P_1639*P_1202);  % CoffeinSimulation|Organism|Lung|Plasma|Caffeine-CYP1A2-MM|Km_app
P_2294 = (P_1201*P_42*P_1200);  % CoffeinSimulation|Organism|Lung|BloodCells|Volume
P_2295 = P_1560;  % CoffeinSimulation|Organism|Lung|BloodCells|CYP1A2|Relative expression
P_2296 = P_1555;  % CoffeinSimulation|Organism|Lung|BloodCells|CYP1A2|Relative expression (normalized)
P_2297 = P_1549;  % CoffeinSimulation|Organism|Lung|BloodCells|CYP1A2|Ontogeny factor
P_2298 = P_1556;  % CoffeinSimulation|Organism|Lung|BloodCells|CYP1A2|t1/2
P_2299 = (P_1639*P_1204);  % CoffeinSimulation|Organism|Lung|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2300 = (P_1189*P_1200);  % CoffeinSimulation|Organism|Lung|Interstitial|Volume
P_2301 = P_13;  % CoffeinSimulation|Organism|Lung|Interstitial|pH
P_2302 = P_1200;  % CoffeinSimulation|Organism|Lung|Intracellular|Volume of protein container
P_2303 = P_1208;  % CoffeinSimulation|Organism|Lung|Intracellular|CYP1A2|Relative expression out.
P_2304 = P_1549;  % CoffeinSimulation|Organism|Lung|Intracellular|CYP1A2|Ontogeny factor
P_2305 = P_1556;  % CoffeinSimulation|Organism|Lung|Intracellular|CYP1A2|t1/2
P_2306 = (P_1639*P_1209);  % CoffeinSimulation|Organism|Lung|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_2307 = (P_1228*P_1215);  % CoffeinSimulation|Organism|Muscle|Weight (tissue)
P_2308 = (1-(P_1235+P_1225));  % CoffeinSimulation|Organism|Muscle|Fraction intracellular
P_2309 = (P_1225*(1-P_42)*P_1228);  % CoffeinSimulation|Organism|Muscle|Plasma|Volume
P_2310 = P_1551;  % CoffeinSimulation|Organism|Muscle|Plasma|CYP1A2|Relative expression
P_2311 = P_1557;  % CoffeinSimulation|Organism|Muscle|Plasma|CYP1A2|Relative expression (normalized)
P_2312 = P_1556;  % CoffeinSimulation|Organism|Muscle|Plasma|CYP1A2|t1/2
P_2313 = P_1549;  % CoffeinSimulation|Organism|Muscle|Plasma|CYP1A2|Ontogeny factor
P_2314 = (P_1639*P_1245);  % CoffeinSimulation|Organism|Muscle|Plasma|Caffeine-CYP1A2-MM|Km_app
P_2315 = (P_1225*P_42*P_1228);  % CoffeinSimulation|Organism|Muscle|BloodCells|Volume
P_2316 = P_1560;  % CoffeinSimulation|Organism|Muscle|BloodCells|CYP1A2|Relative expression
P_2317 = P_1555;  % CoffeinSimulation|Organism|Muscle|BloodCells|CYP1A2|Relative expression (normalized)
P_2318 = P_1549;  % CoffeinSimulation|Organism|Muscle|BloodCells|CYP1A2|Ontogeny factor
P_2319 = P_1556;  % CoffeinSimulation|Organism|Muscle|BloodCells|CYP1A2|t1/2
P_2320 = (P_1639*P_1247);  % CoffeinSimulation|Organism|Muscle|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2321 = (P_1235*P_1228);  % CoffeinSimulation|Organism|Muscle|Interstitial|Volume
P_2322 = P_13;  % CoffeinSimulation|Organism|Muscle|Interstitial|pH
P_2323 = P_1228;  % CoffeinSimulation|Organism|Muscle|Intracellular|Volume of protein container
P_2324 = P_1251;  % CoffeinSimulation|Organism|Muscle|Intracellular|CYP1A2|Relative expression out.
P_2325 = P_1549;  % CoffeinSimulation|Organism|Muscle|Intracellular|CYP1A2|Ontogeny factor
P_2326 = P_1556;  % CoffeinSimulation|Organism|Muscle|Intracellular|CYP1A2|t1/2
P_2327 = (P_1639*P_1252);  % CoffeinSimulation|Organism|Muscle|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_2328 = (P_1285*P_1254);  % CoffeinSimulation|Organism|Pancreas|Weight (tissue)
P_2329 = (1-(P_1274+P_1273));  % CoffeinSimulation|Organism|Pancreas|Fraction intracellular
P_2330 = (P_1273*(1-P_42)*P_1285);  % CoffeinSimulation|Organism|Pancreas|Plasma|Volume
P_2331 = P_1551;  % CoffeinSimulation|Organism|Pancreas|Plasma|CYP1A2|Relative expression
P_2332 = P_1557;  % CoffeinSimulation|Organism|Pancreas|Plasma|CYP1A2|Relative expression (normalized)
P_2333 = P_1556;  % CoffeinSimulation|Organism|Pancreas|Plasma|CYP1A2|t1/2
P_2334 = P_1549;  % CoffeinSimulation|Organism|Pancreas|Plasma|CYP1A2|Ontogeny factor
P_2335 = (P_1639*P_1287);  % CoffeinSimulation|Organism|Pancreas|Plasma|Caffeine-CYP1A2-MM|Km_app
P_2336 = (P_1273*P_42*P_1285);  % CoffeinSimulation|Organism|Pancreas|BloodCells|Volume
P_2337 = P_1560;  % CoffeinSimulation|Organism|Pancreas|BloodCells|CYP1A2|Relative expression
P_2338 = P_1555;  % CoffeinSimulation|Organism|Pancreas|BloodCells|CYP1A2|Relative expression (normalized)
P_2339 = P_1549;  % CoffeinSimulation|Organism|Pancreas|BloodCells|CYP1A2|Ontogeny factor
P_2340 = P_1556;  % CoffeinSimulation|Organism|Pancreas|BloodCells|CYP1A2|t1/2
P_2341 = (P_1639*P_1289);  % CoffeinSimulation|Organism|Pancreas|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2342 = (P_1274*P_1285);  % CoffeinSimulation|Organism|Pancreas|Interstitial|Volume
P_2343 = P_13;  % CoffeinSimulation|Organism|Pancreas|Interstitial|pH
P_2344 = P_1285;  % CoffeinSimulation|Organism|Pancreas|Intracellular|Volume of protein container
P_2345 = P_1293;  % CoffeinSimulation|Organism|Pancreas|Intracellular|CYP1A2|Relative expression out.
P_2346 = P_1549;  % CoffeinSimulation|Organism|Pancreas|Intracellular|CYP1A2|Ontogeny factor
P_2347 = P_1556;  % CoffeinSimulation|Organism|Pancreas|Intracellular|CYP1A2|t1/2
P_2348 = (P_1639*P_1294);  % CoffeinSimulation|Organism|Pancreas|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_2349 = (P_1299*P_1296);  % CoffeinSimulation|Organism|PortalVein|Weight (tissue)
P_2350 = ((1-P_42)*P_1299);  % CoffeinSimulation|Organism|PortalVein|Plasma|Volume
P_2351 = P_1551;  % CoffeinSimulation|Organism|PortalVein|Plasma|CYP1A2|Relative expression
P_2352 = P_1557;  % CoffeinSimulation|Organism|PortalVein|Plasma|CYP1A2|Relative expression (normalized)
P_2353 = P_1556;  % CoffeinSimulation|Organism|PortalVein|Plasma|CYP1A2|t1/2
P_2354 = P_1549;  % CoffeinSimulation|Organism|PortalVein|Plasma|CYP1A2|Ontogeny factor
P_2355 = (P_1639*P_1300);  % CoffeinSimulation|Organism|PortalVein|Plasma|Caffeine-CYP1A2-MM|Km_app
P_2356 = (P_42*P_1299);  % CoffeinSimulation|Organism|PortalVein|BloodCells|Volume
P_2357 = P_1560;  % CoffeinSimulation|Organism|PortalVein|BloodCells|CYP1A2|Relative expression
P_2358 = P_1555;  % CoffeinSimulation|Organism|PortalVein|BloodCells|CYP1A2|Relative expression (normalized)
P_2359 = P_1549;  % CoffeinSimulation|Organism|PortalVein|BloodCells|CYP1A2|Ontogeny factor
P_2360 = P_1556;  % CoffeinSimulation|Organism|PortalVein|BloodCells|CYP1A2|t1/2
P_2361 = (P_1639*P_1302);  % CoffeinSimulation|Organism|PortalVein|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2362 = (P_1336*P_1304);  % CoffeinSimulation|Organism|Skin|Weight (tissue)
P_2363 = (1-(P_1325+P_1311));  % CoffeinSimulation|Organism|Skin|Fraction intracellular
P_2364 = (P_1311*(1-P_42)*P_1336);  % CoffeinSimulation|Organism|Skin|Plasma|Volume
P_2365 = P_1551;  % CoffeinSimulation|Organism|Skin|Plasma|CYP1A2|Relative expression
P_2366 = P_1557;  % CoffeinSimulation|Organism|Skin|Plasma|CYP1A2|Relative expression (normalized)
P_2367 = P_1556;  % CoffeinSimulation|Organism|Skin|Plasma|CYP1A2|t1/2
P_2368 = P_1549;  % CoffeinSimulation|Organism|Skin|Plasma|CYP1A2|Ontogeny factor
P_2369 = (P_1639*P_1338);  % CoffeinSimulation|Organism|Skin|Plasma|Caffeine-CYP1A2-MM|Km_app
P_2370 = (P_1311*P_42*P_1336);  % CoffeinSimulation|Organism|Skin|BloodCells|Volume
P_2371 = P_1560;  % CoffeinSimulation|Organism|Skin|BloodCells|CYP1A2|Relative expression
P_2372 = P_1555;  % CoffeinSimulation|Organism|Skin|BloodCells|CYP1A2|Relative expression (normalized)
P_2373 = P_1549;  % CoffeinSimulation|Organism|Skin|BloodCells|CYP1A2|Ontogeny factor
P_2374 = P_1556;  % CoffeinSimulation|Organism|Skin|BloodCells|CYP1A2|t1/2
P_2375 = (P_1639*P_1340);  % CoffeinSimulation|Organism|Skin|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2376 = (P_1325*P_1336);  % CoffeinSimulation|Organism|Skin|Interstitial|Volume
P_2377 = P_13;  % CoffeinSimulation|Organism|Skin|Interstitial|pH
P_2378 = P_1336;  % CoffeinSimulation|Organism|Skin|Intracellular|Volume of protein container
P_2379 = P_1344;  % CoffeinSimulation|Organism|Skin|Intracellular|CYP1A2|Relative expression out.
P_2380 = P_1549;  % CoffeinSimulation|Organism|Skin|Intracellular|CYP1A2|Ontogeny factor
P_2381 = P_1556;  % CoffeinSimulation|Organism|Skin|Intracellular|CYP1A2|t1/2
P_2382 = (P_1639*P_1345);  % CoffeinSimulation|Organism|Skin|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_2383 = (P_1378*P_1347);  % CoffeinSimulation|Organism|Spleen|Weight (tissue)
P_2384 = (1-(P_1367+P_1361));  % CoffeinSimulation|Organism|Spleen|Fraction intracellular
P_2385 = (P_1361*(1-P_42)*P_1378);  % CoffeinSimulation|Organism|Spleen|Plasma|Volume
P_2386 = P_1551;  % CoffeinSimulation|Organism|Spleen|Plasma|CYP1A2|Relative expression
P_2387 = P_1557;  % CoffeinSimulation|Organism|Spleen|Plasma|CYP1A2|Relative expression (normalized)
P_2388 = P_1549;  % CoffeinSimulation|Organism|Spleen|Plasma|CYP1A2|Ontogeny factor
P_2389 = P_1556;  % CoffeinSimulation|Organism|Spleen|Plasma|CYP1A2|t1/2
P_2390 = (P_1639*P_1380);  % CoffeinSimulation|Organism|Spleen|Plasma|Caffeine-CYP1A2-MM|Km_app
P_2391 = (P_1361*P_42*P_1378);  % CoffeinSimulation|Organism|Spleen|BloodCells|Volume
P_2392 = P_1560;  % CoffeinSimulation|Organism|Spleen|BloodCells|CYP1A2|Relative expression
P_2393 = P_1555;  % CoffeinSimulation|Organism|Spleen|BloodCells|CYP1A2|Relative expression (normalized)
P_2394 = P_1549;  % CoffeinSimulation|Organism|Spleen|BloodCells|CYP1A2|Ontogeny factor
P_2395 = P_1556;  % CoffeinSimulation|Organism|Spleen|BloodCells|CYP1A2|t1/2
P_2396 = (P_1639*P_1382);  % CoffeinSimulation|Organism|Spleen|BloodCells|Caffeine-CYP1A2-MM|Km_app
P_2397 = (P_1367*P_1378);  % CoffeinSimulation|Organism|Spleen|Interstitial|Volume
P_2398 = P_13;  % CoffeinSimulation|Organism|Spleen|Interstitial|pH
P_2399 = P_1378;  % CoffeinSimulation|Organism|Spleen|Intracellular|Volume of protein container
P_2400 = P_1386;  % CoffeinSimulation|Organism|Spleen|Intracellular|CYP1A2|Relative expression out.
P_2401 = P_1549;  % CoffeinSimulation|Organism|Spleen|Intracellular|CYP1A2|Ontogeny factor
P_2402 = P_1556;  % CoffeinSimulation|Organism|Spleen|Intracellular|CYP1A2|t1/2
P_2403 = (P_1639*P_1387);  % CoffeinSimulation|Organism|Spleen|Intracellular|Caffeine-CYP1A2-MM|Km_app
P_2404 = (P_42*P_26*0.6*P_48);  % CoffeinSimulation|Neighborhoods|VenousBlood_pls_VenousBlood_bc|Surface area (blood cells/plasma)
P_2405 = (P_42*P_26*0.6*P_57);  % CoffeinSimulation|Neighborhoods|ArterialBlood_pls_ArterialBlood_bc|Surface area (blood cells/plasma)
P_2406 = (((P_99*35.46099290780142)^0.75)*1000);  % CoffeinSimulation|Neighborhoods|Bone_int_Bone_cell|Surface area (interstitial/intracellular)
P_2407 = (P_0*P_79*P_99);  % CoffeinSimulation|Neighborhoods|Bone_pls_Bone_int|Surface area (plasma/interstitial)
P_2408 = (P_42*P_26*0.6*P_99*P_79);  % CoffeinSimulation|Neighborhoods|Bone_pls_Bone_bc|Surface area (blood cells/plasma)
P_2409 = (P_0*P_121*P_140);  % CoffeinSimulation|Neighborhoods|Brain_pls_Brain_int|Surface area (plasma/interstitial)
P_2410 = (((P_140*598.4440454817475)^0.75)*0.06);  % CoffeinSimulation|Neighborhoods|Brain_int_Brain_cell|Surface area (interstitial/intracellular)
P_2411 = (P_42*P_26*0.6*P_140*P_121);  % CoffeinSimulation|Neighborhoods|Brain_pls_Brain_bc|Surface area (blood cells/plasma)
P_2412 = (P_0*P_162*P_170);  % CoffeinSimulation|Neighborhoods|Fat_pls_Fat_int|Surface area (plasma/interstitial)
P_2413 = (((P_170*70.42253521126761)^0.75)*500);  % CoffeinSimulation|Neighborhoods|Fat_int_Fat_cell|Surface area (interstitial/intracellular)
P_2414 = (P_42*P_26*0.6*P_170*P_162);  % CoffeinSimulation|Neighborhoods|Fat_pls_Fat_bc|Surface area (blood cells/plasma)
P_2415 = (((P_225*400)^0.75)*200);  % CoffeinSimulation|Neighborhoods|Gonads_int_Gonads_cell|Surface area (interstitial/intracellular)
P_2416 = (P_0*P_206*P_225);  % CoffeinSimulation|Neighborhoods|Gonads_pls_Gonads_int|Surface area (plasma/interstitial)
P_2417 = (P_42*P_26*0.6*P_225*P_206);  % CoffeinSimulation|Neighborhoods|Gonads_pls_Gonads_bc|Surface area (blood cells/plasma)
P_2418 = (P_0*P_248*P_267);  % CoffeinSimulation|Neighborhoods|Heart_pls_Heart_int|Surface area (plasma/interstitial)
P_2419 = (P_42*P_26*0.6*P_267*P_248);  % CoffeinSimulation|Neighborhoods|Heart_pls_Heart_bc|Surface area (blood cells/plasma)
P_2420 = (((P_267*833.3333333333334)^0.75)*754);  % CoffeinSimulation|Neighborhoods|Heart_int_Heart_cell|Surface area (interstitial/intracellular)
P_2421 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_384))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_lum_F2
P_2422 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_722))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_cell_F3
P_2423 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_384))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_lum_F1
P_2424 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_384))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_lum_F3
P_2425 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_722))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_cell_F2
P_2426 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_722))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_cell_F1
P_2427 = (((P_312*142.8571428571429)^0.75)*100000);  % CoffeinSimulation|Neighborhoods|Kidney_int_Kidney_cell|Surface area (interstitial/intracellular)
P_2428 = (P_42*P_26*0.6*P_312*P_292);  % CoffeinSimulation|Neighborhoods|Kidney_pls_Kidney_bc|Surface area (blood cells/plasma)
P_2429 = (P_0*P_292*P_312);  % CoffeinSimulation|Neighborhoods|Kidney_pls_Kidney_int|Surface area (plasma/interstitial)
P_2430 = (IIf(((P_1415*((P_1414*(1-P_1413))-(P_1416*P_1411))) > 0),(P_1416*P_1411*P_1414*((1-P_1413)/(P_1415*((P_1414*(1-P_1413))-(P_1416*P_1411))*P_1412))),1000000));  % CoffeinSimulation|Neighborhoods|Kidney_pls_Kidney_ur|Caffeine|Renal Clearances-Birkett and Miners 1991|Specific clearance
P_2431 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_403))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_lum_F1
P_2432 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_403))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_lum_F2
P_2433 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_760))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_cell_F3
P_2434 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_403))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_lum_F3
P_2435 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_760))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_cell_F1
P_2436 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_760))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_cell_F2
P_2437 = (y(58)+y(62)+y(66)+y(70)+y(74)+y(78)+y(82)+y(86)+y(90)+y(94)+y(98));  % CoffeinSimulation|Neighborhoods|Lumen_sto_Lumen_duo|Caffeine|Oral mass absorbed
P_2438 = (P_0*P_575*P_594);  % CoffeinSimulation|Neighborhoods|Stomach_pls_Stomach_int|Surface area (plasma/interstitial)
P_2439 = (((P_594*909.090909090909)^0.75)*100000);  % CoffeinSimulation|Neighborhoods|Stomach_int_Stomach_cell|Surface area (interstitial/intracellular)
P_2440 = (P_42*P_26*0.6*P_594*P_575);  % CoffeinSimulation|Neighborhoods|Stomach_pls_Stomach_bc|Surface area (blood cells/plasma)
P_2441 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_422))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_lum_F1
P_2442 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_422))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_lum_F2
P_2443 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_422))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_lum_F3
P_2444 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_798))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_cell_F1
P_2445 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_798))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_cell_F2
P_2446 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_798))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_cell_F3
P_2447 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_440))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_lum_F3
P_2448 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_836))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_cell_F3
P_2449 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_836))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_cell_F2
P_2450 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_440))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_lum_F1
P_2451 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_440))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_lum_F2
P_2452 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_836))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_cell_F1
P_2453 = (P_0*P_1130*P_1151);  % CoffeinSimulation|Neighborhoods|Liver_pls_Liver_int|Surface area (plasma/interstitial)
P_2454 = (P_42*P_26*0.6*P_1151*P_1130);  % CoffeinSimulation|Neighborhoods|Liver_pls_Liver_bc|Surface area (blood cells/plasma)
P_2455 = (((P_1151*100)^0.75)*8200);  % CoffeinSimulation|Neighborhoods|Liver_int_Liver_cell|Surface area (interstitial/intracellular)
P_2456 = (P_0*P_1201*P_1200);  % CoffeinSimulation|Neighborhoods|Lung_pls_Lung_int|Surface area (plasma/interstitial)
P_2457 = (P_42*P_26*0.6*P_1200*P_1201);  % CoffeinSimulation|Neighborhoods|Lung_pls_Lung_bc|Surface area (blood cells/plasma)
P_2458 = (((P_1200*454.5454545454545)^0.75)*9.6);  % CoffeinSimulation|Neighborhoods|Lung_int_Lung_cell|Surface area (interstitial/intracellular)
P_2459 = (P_0*P_1225*P_1228);  % CoffeinSimulation|Neighborhoods|Muscle_pls_Muscle_int|Surface area (plasma/interstitial)
P_2460 = (((P_1228*9.082652134423252)^0.75)*754);  % CoffeinSimulation|Neighborhoods|Muscle_int_Muscle_cell|Surface area (interstitial/intracellular)
P_2461 = (P_42*P_26*0.6*P_1228*P_1225);  % CoffeinSimulation|Neighborhoods|Muscle_pls_Muscle_bc|Surface area (blood cells/plasma)
P_2462 = (P_42*P_26*0.6*P_1285*P_1273);  % CoffeinSimulation|Neighborhoods|Pancreas_pls_Pancreas_bc|Surface area (blood cells/plasma)
P_2463 = (P_0*P_1273*P_1285);  % CoffeinSimulation|Neighborhoods|Pancreas_pls_Pancreas_int|Surface area (plasma/interstitial)
P_2464 = (((P_1285*769.2307692307692)^0.75)*100000);  % CoffeinSimulation|Neighborhoods|Pancreas_int_Pancreas_cell|Surface area (interstitial/intracellular)
P_2465 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_1110))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_cell_F1
P_2466 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_555))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_lum_F2
P_2467 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_1110))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_cell_F2
P_2468 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_1110))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_cell_F3
P_2469 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_555))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_lum_F3
P_2470 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_555))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_lum_F1
P_2471 = (P_42*P_26*0.6*P_1299);  % CoffeinSimulation|Neighborhoods|PortalVein_pls_PortalVein_bc|Surface area (blood cells/plasma)
P_2472 = (P_42*P_26*0.6*P_1336*P_1311);  % CoffeinSimulation|Neighborhoods|Skin_pls_Skin_bc|Surface area (blood cells/plasma)
P_2473 = (P_0*P_1311*P_1336);  % CoffeinSimulation|Neighborhoods|Skin_pls_Skin_int|Surface area (plasma/interstitial)
P_2474 = (((P_1336*23.04147465437788)^0.75)*12);  % CoffeinSimulation|Neighborhoods|Skin_int_Skin_cell|Surface area (interstitial/intracellular)
P_2475 = (P_0*P_1361*P_1378);  % CoffeinSimulation|Neighborhoods|Spleen_pls_Spleen_int|Surface area (plasma/interstitial)
P_2476 = (P_42*P_26*0.6*P_1378*P_1361);  % CoffeinSimulation|Neighborhoods|Spleen_pls_Spleen_bc|Surface area (blood cells/plasma)
P_2477 = (((P_1378*769.2307692307692)^0.75)*100000);  % CoffeinSimulation|Neighborhoods|Spleen_int_Spleen_cell|Surface area (interstitial/intracellular)
P_2478 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_1072))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_cell_F1
P_2479 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_1072))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_cell_F2
P_2480 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_1072))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_cell_F3
P_2481 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_533))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_lum_F1
P_2482 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_533))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_lum_F3
P_2483 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_533))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_lum_F2
P_2484 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_684))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_cell_F1
P_2485 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_684))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_cell_F2
P_2486 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_684))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_cell_F3
P_2487 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_365))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_lum_F1
P_2488 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_365))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_lum_F2
P_2489 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_365))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_lum_F3
P_2490 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_511))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_lum_F2
P_2491 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_1034))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_cell_F2
P_2492 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_1034))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_cell_F1
P_2493 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_511))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_lum_F3
P_2494 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_1034))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_cell_F3
P_2495 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_511))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_lum_F1
P_2496 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_920))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_cell_F1
P_2497 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_920))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_cell_F2
P_2498 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_920))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_cell_F3
P_2499 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_460))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_lum_F1
P_2500 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_460))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_lum_F2
P_2501 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_460))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_lum_F3
P_2502 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_996))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_cell_F3
P_2503 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_498))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_lum_F1
P_2504 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_498))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_lum_F3
P_2505 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_498))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_lum_F2
P_2506 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_996))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_cell_F2
P_2507 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_996))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_cell_F1
P_2508 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_470))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_lum_F3
P_2509 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_958))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_cell_F2
P_2510 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_958))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_cell_F1
P_2511 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_958))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_cell_F3
P_2512 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_470))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_lum_F1
P_2513 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_470))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_lum_F2
P_2514 = (1*(P_31/(1+((IIf((P_1510 == P_1525),P_33,(IIf((P_1510 == P_1519),P_32,1))))*((1-P_1536)/P_1536)))));  % CoffeinSimulation|Caffeine|Fraction unbound (plasma)
P_2515 = (P_1531-((P_1522*1.7e-08)+(P_1515*2.2e-08)+(P_1514*6.2e-08)+(P_1523*9.8e-08)));  % CoffeinSimulation|Caffeine|Effective molecular weight
P_2516 = ((P_1514+P_1515+P_1522+P_1523) > 0);  % CoffeinSimulation|Caffeine|Has halogens
P_2517 = ((IIf((P_1516 == P_1520),1,0))+(IIf((P_1517 == P_1520),1,0))+(IIf((P_1518 == P_1520),1,0)));  % CoffeinSimulation|Caffeine|pKa_Bases_Count
P_2518 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_1538))))),1));  % CoffeinSimulation|Caffeine|pKa_pH_WS_sol_F1
P_2519 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_1538))))),1));  % CoffeinSimulation|Caffeine|pKa_pH_WS_sol_F3
P_2520 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_1538))))),1));  % CoffeinSimulation|Caffeine|pKa_pH_WS_sol_F2
P_2521 = ((P_1516 == 0) & ((P_1517 == 0) & (P_1518 == 0)));  % CoffeinSimulation|Caffeine|Is neutral
P_2522 = (((P_1516 == 1) & (P_1532 >= 7)) | (((P_1517 == 1) & (P_1533 >= 7)) | ((P_1518 == 1) & (P_1534 >= 7))));  % CoffeinSimulation|Caffeine|Is strong base
P_2523 = ((IIf((P_1516 == P_1524),1,0))+(IIf((P_1517 == P_1524),1,0))+(IIf((P_1518 == P_1524),1,0)));  % CoffeinSimulation|Caffeine|pKa_Acids_Count
P_2524 = ((0.8100000000000001+(0.11*(10^P_1535)))*0.2006420545746388);  % CoffeinSimulation|Caffeine|Partition coefficient (water/protein)
P_2525 = ((10^(0-(4.113+(0.4609*(log10((P_1531*1000000000)))))))*0.6);  % CoffeinSimulation|Caffeine|Aqueous diffusion coefficient
P_2526 = (((P_1531*1000000000)^0.4226)*3.33e-10);  % CoffeinSimulation|Caffeine|Radius (solute)
P_2527 = (P_1583-((P_1574*1.7e-08)+(P_1567*2.2e-08)+(P_1566*6.2e-08)+(P_1575*9.8e-08)));  % CoffeinSimulation|CYP1A2|Effective molecular weight
P_2528 = ((P_1566+P_1567+P_1574+P_1575) > 0);  % CoffeinSimulation|CYP1A2|Has halogens
P_2529 = ((IIf((P_1568 == P_1572),1,0))+(IIf((P_1569 == P_1572),1,0))+(IIf((P_1570 == P_1572),1,0)));  % CoffeinSimulation|CYP1A2|pKa_Bases_Count
P_2530 = (IIf((P_1568 ~= P_1564),(1/(1+(10^(P_1568*(P_1584-P_1590))))),1));  % CoffeinSimulation|CYP1A2|pKa_pH_WS_sol_F1
P_2531 = (IIf((P_1570 ~= P_1564),(1/(1+(10^(P_1570*(P_1586-P_1590))))),1));  % CoffeinSimulation|CYP1A2|pKa_pH_WS_sol_F3
P_2532 = (IIf((P_1569 ~= P_1564),(1/(1+(10^(P_1569*(P_1585-P_1590))))),1));  % CoffeinSimulation|CYP1A2|pKa_pH_WS_sol_F2
P_2533 = ((P_1568 == 0) & ((P_1569 == 0) & (P_1570 == 0)));  % CoffeinSimulation|CYP1A2|Is neutral
P_2534 = (((P_1568 == 1) & (P_1584 >= 7)) | (((P_1569 == 1) & (P_1585 >= 7)) | ((P_1570 == 1) & (P_1586 >= 7))));  % CoffeinSimulation|CYP1A2|Is strong base
P_2535 = ((IIf((P_1568 == P_1576),1,0))+(IIf((P_1569 == P_1576),1,0))+(IIf((P_1570 == P_1576),1,0)));  % CoffeinSimulation|CYP1A2|pKa_Acids_Count
P_2536 = ((0.8100000000000001+(0.11*(10^P_1587)))*0.2006420545746388);  % CoffeinSimulation|CYP1A2|Partition coefficient (water/protein)
P_2537 = ((10^(0-(4.113+(0.4609*(log10((P_1583*1000000000)))))))*0.6);  % CoffeinSimulation|CYP1A2|Aqueous diffusion coefficient
P_2538 = (((P_1583*1000000000)^0.4226)*3.33e-10);  % CoffeinSimulation|CYP1A2|Radius (solute)
P_2539 = (P_1621-((P_1612*1.7e-08)+(P_1605*2.2e-08)+(P_1604*6.2e-08)+(P_1613*9.8e-08)));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Effective molecular weight
P_2540 = ((P_1604+P_1605+P_1612+P_1613) > 0);  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Has halogens
P_2541 = ((IIf((P_1606 == P_1610),1,0))+(IIf((P_1607 == P_1610),1,0))+(IIf((P_1608 == P_1610),1,0)));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_Bases_Count
P_2542 = (IIf((P_1606 ~= P_1602),(1/(1+(10^(P_1606*(P_1622-P_1628))))),1));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_pH_WS_sol_F1
P_2543 = (IIf((P_1608 ~= P_1602),(1/(1+(10^(P_1608*(P_1624-P_1628))))),1));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_pH_WS_sol_F3
P_2544 = (IIf((P_1607 ~= P_1602),(1/(1+(10^(P_1607*(P_1623-P_1628))))),1));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_pH_WS_sol_F2
P_2545 = ((P_1606 == 0) & ((P_1607 == 0) & (P_1608 == 0)));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Is neutral
P_2546 = (((P_1606 == 1) & (P_1622 >= 7)) | (((P_1607 == 1) & (P_1623 >= 7)) | ((P_1608 == 1) & (P_1624 >= 7))));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Is strong base
P_2547 = ((IIf((P_1606 == P_1614),1,0))+(IIf((P_1607 == P_1614),1,0))+(IIf((P_1608 == P_1614),1,0)));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_Acids_Count
P_2548 = ((0.8100000000000001+(0.11*(10^P_1625)))*0.2006420545746388);  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Partition coefficient (water/protein)
P_2549 = ((10^(0-(4.113+(0.4609*(log10((P_1621*1000000000)))))))*0.6);  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Aqueous diffusion coefficient
P_2550 = (((P_1621*1000000000)^0.4226)*3.33e-10);  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Radius (solute)
P_2551 = (P_1637/P_1638);  % CoffeinSimulation|Caffeine-CYP1A2-MM|kcat
P_2552 = (P_1655+P_1668+P_2349);  % CoffeinSimulation|Organism|Weight of blood organs
P_2553 = P_1656;  % CoffeinSimulation|Organism|VenousBlood|Plasma|Volume of protein container
P_2554 = (0.6931471805599453/P_1660);  % CoffeinSimulation|Organism|VenousBlood|Plasma|CYP1A2|Degradation coefficient
P_2555 = P_1658;  % CoffeinSimulation|Organism|VenousBlood|Plasma|CYP1A2|Relative expression out.
P_2556 = (IIf((P_1656 > 0),(y(1)/P_1656),0));  % CoffeinSimulation|Organism|VenousBlood|Plasma|Caffeine|Concentration
P_2557 = P_2514;  % CoffeinSimulation|Organism|VenousBlood|Plasma|Caffeine|Partition coefficient (water/container)
P_2558 = (IIf((P_1656 > 0),(y(2)/P_1656),0));  % CoffeinSimulation|Organism|VenousBlood|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_2559 = (P_2551*P_50);  % CoffeinSimulation|Organism|VenousBlood|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2560 = P_1662;  % CoffeinSimulation|Organism|VenousBlood|BloodCells|Volume of protein container
P_2561 = (0.6931471805599453/P_1666);  % CoffeinSimulation|Organism|VenousBlood|BloodCells|CYP1A2|Degradation coefficient
P_2562 = P_1664;  % CoffeinSimulation|Organism|VenousBlood|BloodCells|CYP1A2|Relative expression out.
P_2563 = (IIf((P_1662 > 0),(y(3)/P_1662),0));  % CoffeinSimulation|Organism|VenousBlood|BloodCells|Caffeine|Concentration
P_2564 = (IIf((P_1662 > 0),(y(4)/P_1662),0));  % CoffeinSimulation|Organism|VenousBlood|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_2565 = (P_2551*P_52);  % CoffeinSimulation|Organism|VenousBlood|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2566 = P_1669;  % CoffeinSimulation|Organism|ArterialBlood|Plasma|Volume of protein container
P_2567 = (0.6931471805599453/P_1673);  % CoffeinSimulation|Organism|ArterialBlood|Plasma|CYP1A2|Degradation coefficient
P_2568 = P_1671;  % CoffeinSimulation|Organism|ArterialBlood|Plasma|CYP1A2|Relative expression out.
P_2569 = (IIf((P_1669 > 0),(y(5)/P_1669),0));  % CoffeinSimulation|Organism|ArterialBlood|Plasma|Caffeine|Concentration
P_2570 = P_2514;  % CoffeinSimulation|Organism|ArterialBlood|Plasma|Caffeine|Partition coefficient (water/container)
P_2571 = (IIf((P_1669 > 0),(y(6)/P_1669),0));  % CoffeinSimulation|Organism|ArterialBlood|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_2572 = (P_2551*P_59);  % CoffeinSimulation|Organism|ArterialBlood|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2573 = P_1675;  % CoffeinSimulation|Organism|ArterialBlood|BloodCells|Volume of protein container
P_2574 = (0.6931471805599453/P_1679);  % CoffeinSimulation|Organism|ArterialBlood|BloodCells|CYP1A2|Degradation coefficient
P_2575 = P_1677;  % CoffeinSimulation|Organism|ArterialBlood|BloodCells|CYP1A2|Relative expression out.
P_2576 = (IIf((P_1675 > 0),(y(7)/P_1675),0));  % CoffeinSimulation|Organism|ArterialBlood|BloodCells|Caffeine|Concentration
P_2577 = (IIf((P_1675 > 0),(y(8)/P_1675),0));  % CoffeinSimulation|Organism|ArterialBlood|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_2578 = (P_2551*P_61);  % CoffeinSimulation|Organism|ArterialBlood|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2579 = (P_98*P_1683);  % CoffeinSimulation|Organism|Bone|Blood flow rate
P_2580 = (P_2407*P_17);  % CoffeinSimulation|Organism|Bone|Volume (endothelium)
P_2581 = P_1685;  % CoffeinSimulation|Organism|Bone|Plasma|Volume of protein container
P_2582 = (0.6931471805599453/P_1689);  % CoffeinSimulation|Organism|Bone|Plasma|CYP1A2|Degradation coefficient
P_2583 = P_1687;  % CoffeinSimulation|Organism|Bone|Plasma|CYP1A2|Relative expression out.
P_2584 = (IIf((P_1685 > 0),(y(10)/P_1685),0));  % CoffeinSimulation|Organism|Bone|Plasma|Caffeine|Concentration
P_2585 = P_2514;  % CoffeinSimulation|Organism|Bone|Plasma|Caffeine|Partition coefficient (water/container)
P_2586 = (IIf((P_1685 > 0),(y(11)/P_1685),0));  % CoffeinSimulation|Organism|Bone|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_2587 = (P_2551*P_101);  % CoffeinSimulation|Organism|Bone|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2588 = P_1691;  % CoffeinSimulation|Organism|Bone|BloodCells|Volume of protein container
P_2589 = (0.6931471805599453/P_1695);  % CoffeinSimulation|Organism|Bone|BloodCells|CYP1A2|Degradation coefficient
P_2590 = P_1693;  % CoffeinSimulation|Organism|Bone|BloodCells|CYP1A2|Relative expression out.
P_2591 = (IIf((P_1691 > 0),(y(12)/P_1691),0));  % CoffeinSimulation|Organism|Bone|BloodCells|Caffeine|Concentration
P_2592 = (IIf((P_1691 > 0),(y(13)/P_1691),0));  % CoffeinSimulation|Organism|Bone|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_2593 = (P_2551*P_103);  % CoffeinSimulation|Organism|Bone|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2594 = P_1697;  % CoffeinSimulation|Organism|Bone|Interstitial|Volume of protein container
P_2595 = (IIf((P_1697 > 0),(y(14)/P_1697),0));  % CoffeinSimulation|Organism|Bone|Interstitial|Caffeine|Concentration
P_2596 = (P_1684*P_99);  % CoffeinSimulation|Organism|Bone|Intracellular|Volume
P_2597 = (0.6931471805599453/P_1702);  % CoffeinSimulation|Organism|Bone|Intracellular|CYP1A2|Degradation coefficient
P_2598 = (P_1700*P_1553*P_1701*P_1699);  % CoffeinSimulation|Organism|Bone|Intracellular|CYP1A2|Start amount
P_2599 = (P_2551*P_108);  % CoffeinSimulation|Organism|Bone|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_2600 = (P_2409*P_17);  % CoffeinSimulation|Organism|Brain|Volume (endothelium)
P_2601 = (P_141*P_1704);  % CoffeinSimulation|Organism|Brain|Blood flow rate
P_2602 = P_1706;  % CoffeinSimulation|Organism|Brain|Plasma|Volume of protein container
P_2603 = (0.6931471805599453/P_1709);  % CoffeinSimulation|Organism|Brain|Plasma|CYP1A2|Degradation coefficient
P_2604 = P_1708;  % CoffeinSimulation|Organism|Brain|Plasma|CYP1A2|Relative expression out.
P_2605 = (IIf((P_1706 > 0),(y(17)/P_1706),0));  % CoffeinSimulation|Organism|Brain|Plasma|Caffeine|Concentration
P_2606 = P_2514;  % CoffeinSimulation|Organism|Brain|Plasma|Caffeine|Partition coefficient (water/container)
P_2607 = (IIf((P_1706 > 0),(y(18)/P_1706),0));  % CoffeinSimulation|Organism|Brain|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_2608 = (P_2551*P_143);  % CoffeinSimulation|Organism|Brain|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2609 = P_1712;  % CoffeinSimulation|Organism|Brain|BloodCells|Volume of protein container
P_2610 = (0.6931471805599453/P_1716);  % CoffeinSimulation|Organism|Brain|BloodCells|CYP1A2|Degradation coefficient
P_2611 = P_1714;  % CoffeinSimulation|Organism|Brain|BloodCells|CYP1A2|Relative expression out.
P_2612 = (IIf((P_1712 > 0),(y(19)/P_1712),0));  % CoffeinSimulation|Organism|Brain|BloodCells|Caffeine|Concentration
P_2613 = (IIf((P_1712 > 0),(y(20)/P_1712),0));  % CoffeinSimulation|Organism|Brain|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_2614 = (P_2551*P_145);  % CoffeinSimulation|Organism|Brain|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2615 = P_1718;  % CoffeinSimulation|Organism|Brain|Interstitial|Volume of protein container
P_2616 = (IIf((P_1718 > 0),(y(21)/P_1718),0));  % CoffeinSimulation|Organism|Brain|Interstitial|Caffeine|Concentration
P_2617 = (P_1705*P_140);  % CoffeinSimulation|Organism|Brain|Intracellular|Volume
P_2618 = (0.6931471805599453/P_1723);  % CoffeinSimulation|Organism|Brain|Intracellular|CYP1A2|Degradation coefficient
P_2619 = (P_1721*P_1553*P_1722*P_1720);  % CoffeinSimulation|Organism|Brain|Intracellular|CYP1A2|Start amount
P_2620 = (P_2551*P_150);  % CoffeinSimulation|Organism|Brain|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_2621 = (P_2412*P_17);  % CoffeinSimulation|Organism|Fat|Volume (endothelium)
P_2622 = (P_184*P_1725);  % CoffeinSimulation|Organism|Fat|Blood flow rate
P_2623 = P_1727;  % CoffeinSimulation|Organism|Fat|Plasma|Volume of protein container
P_2624 = (0.6931471805599453/P_1731);  % CoffeinSimulation|Organism|Fat|Plasma|CYP1A2|Degradation coefficient
P_2625 = P_1729;  % CoffeinSimulation|Organism|Fat|Plasma|CYP1A2|Relative expression out.
P_2626 = (IIf((P_1727 > 0),(y(24)/P_1727),0));  % CoffeinSimulation|Organism|Fat|Plasma|Caffeine|Concentration
P_2627 = P_2514;  % CoffeinSimulation|Organism|Fat|Plasma|Caffeine|Partition coefficient (water/container)
P_2628 = (IIf((P_1727 > 0),(y(25)/P_1727),0));  % CoffeinSimulation|Organism|Fat|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_2629 = (P_2551*P_186);  % CoffeinSimulation|Organism|Fat|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2630 = P_1733;  % CoffeinSimulation|Organism|Fat|BloodCells|Volume of protein container
P_2631 = (0.6931471805599453/P_1736);  % CoffeinSimulation|Organism|Fat|BloodCells|CYP1A2|Degradation coefficient
P_2632 = P_1735;  % CoffeinSimulation|Organism|Fat|BloodCells|CYP1A2|Relative expression out.
P_2633 = (IIf((P_1733 > 0),(y(26)/P_1733),0));  % CoffeinSimulation|Organism|Fat|BloodCells|Caffeine|Concentration
P_2634 = (IIf((P_1733 > 0),(y(27)/P_1733),0));  % CoffeinSimulation|Organism|Fat|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_2635 = (P_2551*P_188);  % CoffeinSimulation|Organism|Fat|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2636 = P_1739;  % CoffeinSimulation|Organism|Fat|Interstitial|Volume of protein container
P_2637 = (IIf((P_1739 > 0),(y(28)/P_1739),0));  % CoffeinSimulation|Organism|Fat|Interstitial|Caffeine|Concentration
P_2638 = (P_1726*P_170);  % CoffeinSimulation|Organism|Fat|Intracellular|Volume
P_2639 = (0.6931471805599453/P_1744);  % CoffeinSimulation|Organism|Fat|Intracellular|CYP1A2|Degradation coefficient
P_2640 = (P_1742*P_1553*P_1743*P_1741);  % CoffeinSimulation|Organism|Fat|Intracellular|CYP1A2|Start amount
P_2641 = (P_2551*P_193);  % CoffeinSimulation|Organism|Fat|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_2642 = (P_2416*P_17);  % CoffeinSimulation|Organism|Gonads|Volume (endothelium)
P_2643 = (P_226*P_1746);  % CoffeinSimulation|Organism|Gonads|Blood flow rate
P_2644 = P_1748;  % CoffeinSimulation|Organism|Gonads|Plasma|Volume of protein container
P_2645 = (0.6931471805599453/P_1751);  % CoffeinSimulation|Organism|Gonads|Plasma|CYP1A2|Degradation coefficient
P_2646 = P_1750;  % CoffeinSimulation|Organism|Gonads|Plasma|CYP1A2|Relative expression out.
P_2647 = (IIf((P_1748 > 0),(y(31)/P_1748),0));  % CoffeinSimulation|Organism|Gonads|Plasma|Caffeine|Concentration
P_2648 = P_2514;  % CoffeinSimulation|Organism|Gonads|Plasma|Caffeine|Partition coefficient (water/container)
P_2649 = (IIf((P_1748 > 0),(y(32)/P_1748),0));  % CoffeinSimulation|Organism|Gonads|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_2650 = (P_2551*P_228);  % CoffeinSimulation|Organism|Gonads|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2651 = P_1754;  % CoffeinSimulation|Organism|Gonads|BloodCells|Volume of protein container
P_2652 = (0.6931471805599453/P_1758);  % CoffeinSimulation|Organism|Gonads|BloodCells|CYP1A2|Degradation coefficient
P_2653 = P_1756;  % CoffeinSimulation|Organism|Gonads|BloodCells|CYP1A2|Relative expression out.
P_2654 = (IIf((P_1754 > 0),(y(33)/P_1754),0));  % CoffeinSimulation|Organism|Gonads|BloodCells|Caffeine|Concentration
P_2655 = (IIf((P_1754 > 0),(y(34)/P_1754),0));  % CoffeinSimulation|Organism|Gonads|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_2656 = (P_2551*P_230);  % CoffeinSimulation|Organism|Gonads|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2657 = P_1760;  % CoffeinSimulation|Organism|Gonads|Interstitial|Volume of protein container
P_2658 = (IIf((P_1760 > 0),(y(35)/P_1760),0));  % CoffeinSimulation|Organism|Gonads|Interstitial|Caffeine|Concentration
P_2659 = (P_1747*P_225);  % CoffeinSimulation|Organism|Gonads|Intracellular|Volume
P_2660 = (0.6931471805599453/P_1765);  % CoffeinSimulation|Organism|Gonads|Intracellular|CYP1A2|Degradation coefficient
P_2661 = (P_1763*P_1553*P_1764*P_1762);  % CoffeinSimulation|Organism|Gonads|Intracellular|CYP1A2|Start amount
P_2662 = (P_2551*P_235);  % CoffeinSimulation|Organism|Gonads|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_2663 = (P_2418*P_17);  % CoffeinSimulation|Organism|Heart|Volume (endothelium)
P_2664 = (P_268*P_1767);  % CoffeinSimulation|Organism|Heart|Blood flow rate
P_2665 = P_1769;  % CoffeinSimulation|Organism|Heart|Plasma|Volume of protein container
P_2666 = (0.6931471805599453/P_1772);  % CoffeinSimulation|Organism|Heart|Plasma|CYP1A2|Degradation coefficient
P_2667 = P_1771;  % CoffeinSimulation|Organism|Heart|Plasma|CYP1A2|Relative expression out.
P_2668 = (IIf((P_1769 > 0),(y(38)/P_1769),0));  % CoffeinSimulation|Organism|Heart|Plasma|Caffeine|Concentration
P_2669 = P_2514;  % CoffeinSimulation|Organism|Heart|Plasma|Caffeine|Partition coefficient (water/container)
P_2670 = (IIf((P_1769 > 0),(y(39)/P_1769),0));  % CoffeinSimulation|Organism|Heart|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_2671 = (P_2551*P_270);  % CoffeinSimulation|Organism|Heart|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2672 = P_1775;  % CoffeinSimulation|Organism|Heart|BloodCells|Volume of protein container
P_2673 = (0.6931471805599453/P_1778);  % CoffeinSimulation|Organism|Heart|BloodCells|CYP1A2|Degradation coefficient
P_2674 = P_1777;  % CoffeinSimulation|Organism|Heart|BloodCells|CYP1A2|Relative expression out.
P_2675 = (IIf((P_1775 > 0),(y(40)/P_1775),0));  % CoffeinSimulation|Organism|Heart|BloodCells|Caffeine|Concentration
P_2676 = (IIf((P_1775 > 0),(y(41)/P_1775),0));  % CoffeinSimulation|Organism|Heart|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_2677 = (P_2551*P_272);  % CoffeinSimulation|Organism|Heart|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2678 = P_1781;  % CoffeinSimulation|Organism|Heart|Interstitial|Volume of protein container
P_2679 = (IIf((P_1781 > 0),(y(42)/P_1781),0));  % CoffeinSimulation|Organism|Heart|Interstitial|Caffeine|Concentration
P_2680 = (P_1768*P_267);  % CoffeinSimulation|Organism|Heart|Intracellular|Volume
P_2681 = (0.6931471805599453/P_1786);  % CoffeinSimulation|Organism|Heart|Intracellular|CYP1A2|Degradation coefficient
P_2682 = (P_1784*P_1553*P_1785*P_1783);  % CoffeinSimulation|Organism|Heart|Intracellular|CYP1A2|Start amount
P_2683 = (P_2551*P_277);  % CoffeinSimulation|Organism|Heart|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_2684 = (P_2429*P_17);  % CoffeinSimulation|Organism|Kidney|Volume (endothelium)
P_2685 = ((((P_1654^P_318)*((1-P_311)/((P_314^P_318)+(P_1654^P_318))))+P_311)*P_316*(P_278/P_284));  % CoffeinSimulation|Organism|Kidney|GFR (specific)
P_2686 = (P_320*P_1788);  % CoffeinSimulation|Organism|Kidney|Blood flow rate
P_2687 = P_1790;  % CoffeinSimulation|Organism|Kidney|Plasma|Volume of protein container
P_2688 = (0.6931471805599453/P_1793);  % CoffeinSimulation|Organism|Kidney|Plasma|CYP1A2|Degradation coefficient
P_2689 = P_1792;  % CoffeinSimulation|Organism|Kidney|Plasma|CYP1A2|Relative expression out.
P_2690 = (IIf((P_1790 > 0),(y(45)/P_1790),0));  % CoffeinSimulation|Organism|Kidney|Plasma|Caffeine|Concentration
P_2691 = P_2514;  % CoffeinSimulation|Organism|Kidney|Plasma|Caffeine|Partition coefficient (water/container)
P_2692 = (IIf((P_1790 > 0),(y(46)/P_1790),0));  % CoffeinSimulation|Organism|Kidney|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_2693 = (P_2551*P_322);  % CoffeinSimulation|Organism|Kidney|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2694 = P_1796;  % CoffeinSimulation|Organism|Kidney|BloodCells|Volume of protein container
P_2695 = (0.6931471805599453/P_1799);  % CoffeinSimulation|Organism|Kidney|BloodCells|CYP1A2|Degradation coefficient
P_2696 = P_1798;  % CoffeinSimulation|Organism|Kidney|BloodCells|CYP1A2|Relative expression out.
P_2697 = (IIf((P_1796 > 0),(y(47)/P_1796),0));  % CoffeinSimulation|Organism|Kidney|BloodCells|Caffeine|Concentration
P_2698 = (IIf((P_1796 > 0),(y(48)/P_1796),0));  % CoffeinSimulation|Organism|Kidney|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_2699 = (P_2551*P_324);  % CoffeinSimulation|Organism|Kidney|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2700 = P_1802;  % CoffeinSimulation|Organism|Kidney|Interstitial|Volume of protein container
P_2701 = (IIf((P_1802 > 0),(y(49)/P_1802),0));  % CoffeinSimulation|Organism|Kidney|Interstitial|Caffeine|Concentration
P_2702 = (P_1789*P_312);  % CoffeinSimulation|Organism|Kidney|Intracellular|Volume
P_2703 = (0.6931471805599453/P_1806);  % CoffeinSimulation|Organism|Kidney|Intracellular|CYP1A2|Degradation coefficient
P_2704 = (P_1805*P_1553*P_1807*P_1804);  % CoffeinSimulation|Organism|Kidney|Intracellular|CYP1A2|Start amount
P_2705 = (P_2551*P_329);  % CoffeinSimulation|Organism|Kidney|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_2706 = (P_338*(P_1812/P_341));  % CoffeinSimulation|Organism|Lumen|Stomach|Secretion of liquid
P_2707 = (P_1810*P_337);  % CoffeinSimulation|Organism|Lumen|Stomach|Volume (gut wall)
P_2708 = P_1812;  % CoffeinSimulation|Organism|Lumen|Stomach|Volume of protein container
P_2709 = (0.6931471805599453/P_1815);  % CoffeinSimulation|Organism|Lumen|Stomach|CYP1A2|Degradation coefficient
P_2710 = (IIf((P_1812 > 0),(y(54)/P_1812),0));  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine|Concentration
P_2711 = (IIf((P_1518 ~= P_1512),(1/(1+(10^(P_1518*(P_1534-P_1813))))),1));  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine|pKa_pH_WS_lum_F3
P_2712 = (IIf((P_1517 ~= P_1512),(1/(1+(10^(P_1517*(P_1533-P_1813))))),1));  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine|pKa_pH_WS_lum_F2
P_2713 = (IIf((P_1516 ~= P_1512),(1/(1+(10^(P_1516*(P_1532-P_1813))))),1));  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine|pKa_pH_WS_lum_F1
P_2714 = (IIf((P_1812 > 0),(y(55)/P_1812),0));  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine-CYP1A2 Metabolite|Concentration
P_2715 = (P_2551*P_352);  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine-CYP1A2-MM|kcat_app
P_2716 = (P_355/P_1973);  % CoffeinSimulation|Organism|Lumen|Duodenum|Intestinal transit rate (absolute)
P_2717 = (((P_1819*P_1819)+(P_1819*P_1822)+(P_1822*P_1822))*P_1818*1.047197551196598);  % CoffeinSimulation|Organism|Lumen|Duodenum|Volume
P_2718 = (3.141592653589793*(P_1819+P_1822)*P_1818);  % CoffeinSimulation|Organism|Lumen|Duodenum|Geometric surface area
P_2719 = (0.6931471805599453/P_1825);  % CoffeinSimulation|Organism|Lumen|Duodenum|CYP1A2|Degradation coefficient
P_2720 = (P_1826*P_1828*P_1827);  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine|pKa_pH_WS_lum_K1
P_2721 = ((1-P_1826)*P_1828*P_1827);  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine|pKa_pH_WS_lum_K2
P_2722 = (P_1826*(1-P_1828)*P_1827);  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine|pKa_pH_WS_lum_K3
P_2723 = (P_1826*P_1828*(1-P_1827));  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine|pKa_pH_WS_lum_K4
P_2724 = ((1-P_1826)*(1-P_1828)*P_1827);  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine|pKa_pH_WS_lum_K5
P_2725 = ((1-P_1826)*P_1828*(1-P_1827));  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine|pKa_pH_WS_lum_K6
P_2726 = (P_1826*(1-P_1828)*(1-P_1827));  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine|pKa_pH_WS_lum_K7
P_2727 = ((1-P_1826)*(1-P_1828)*(1-P_1827));  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine|pKa_pH_WS_lum_K8
P_2728 = (P_2551*P_371);  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine-CYP1A2-MM|kcat_app
P_2729 = (((P_1832*P_1832)+(P_1832*P_1834)+(P_1834*P_1834))*P_1831*1.047197551196598);  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Volume
P_2730 = (P_380/P_1973);  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Intestinal transit rate (absolute)
P_2731 = (3.141592653589793*(P_1832+P_1834)*P_1831);  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Geometric surface area
P_2732 = (0.6931471805599453/P_1836);  % CoffeinSimulation|Organism|Lumen|UpperJejunum|CYP1A2|Degradation coefficient
P_2733 = (P_1840*(1-P_1838)*(1-P_1839));  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine|pKa_pH_WS_lum_K7
P_2734 = ((1-P_1840)*P_1838*(1-P_1839));  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine|pKa_pH_WS_lum_K6
P_2735 = ((1-P_1840)*(1-P_1838)*P_1839);  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine|pKa_pH_WS_lum_K5
P_2736 = (P_1840*P_1838*(1-P_1839));  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine|pKa_pH_WS_lum_K4
P_2737 = (P_1840*(1-P_1838)*P_1839);  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine|pKa_pH_WS_lum_K3
P_2738 = ((1-P_1840)*P_1838*P_1839);  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine|pKa_pH_WS_lum_K2
P_2739 = (P_1840*P_1838*P_1839);  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine|pKa_pH_WS_lum_K1
P_2740 = ((1-P_1840)*(1-P_1838)*(1-P_1839));  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine|pKa_pH_WS_lum_K8
P_2741 = (P_2551*P_390);  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine-CYP1A2-MM|kcat_app
P_2742 = (((P_1842*P_1842)+(P_1842*P_1846)+(P_1846*P_1846))*P_1845*1.047197551196598);  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Volume
P_2743 = (3.141592653589793*(P_1842+P_1846)*P_1845);  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Geometric surface area
P_2744 = (P_400/P_1973);  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Intestinal transit rate (absolute)
P_2745 = (0.6931471805599453/P_1848);  % CoffeinSimulation|Organism|Lumen|LowerJejunum|CYP1A2|Degradation coefficient
P_2746 = (P_1850*P_1851*P_1852);  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine|pKa_pH_WS_lum_K1
P_2747 = ((1-P_1850)*P_1851*P_1852);  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine|pKa_pH_WS_lum_K2
P_2748 = (P_1850*(1-P_1851)*P_1852);  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine|pKa_pH_WS_lum_K3
P_2749 = (P_1850*P_1851*(1-P_1852));  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine|pKa_pH_WS_lum_K4
P_2750 = ((1-P_1850)*(1-P_1851)*P_1852);  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine|pKa_pH_WS_lum_K5
P_2751 = ((1-P_1850)*P_1851*(1-P_1852));  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine|pKa_pH_WS_lum_K6
P_2752 = ((1-P_1850)*(1-P_1851)*(1-P_1852));  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine|pKa_pH_WS_lum_K8
P_2753 = (P_1850*(1-P_1851)*(1-P_1852));  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine|pKa_pH_WS_lum_K7
P_2754 = (P_2551*P_409);  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine-CYP1A2-MM|kcat_app
P_2755 = (3.141592653589793*(P_1855+P_1854)*P_1856);  % CoffeinSimulation|Organism|Lumen|UpperIleum|Geometric surface area
P_2756 = (P_419/P_1973);  % CoffeinSimulation|Organism|Lumen|UpperIleum|Intestinal transit rate (absolute)
P_2757 = (((P_1855*P_1855)+(P_1855*P_1854)+(P_1854*P_1854))*P_1856*1.047197551196598);  % CoffeinSimulation|Organism|Lumen|UpperIleum|Volume
P_2758 = (0.6931471805599453/P_1861);  % CoffeinSimulation|Organism|Lumen|UpperIleum|CYP1A2|Degradation coefficient
P_2759 = (P_1863*P_1862*P_1864);  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine|pKa_pH_WS_lum_K1
P_2760 = ((1-P_1863)*P_1862*P_1864);  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine|pKa_pH_WS_lum_K2
P_2761 = ((1-P_1863)*(1-P_1862)*(1-P_1864));  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine|pKa_pH_WS_lum_K8
P_2762 = (P_1863*(1-P_1862)*(1-P_1864));  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine|pKa_pH_WS_lum_K7
P_2763 = ((1-P_1863)*P_1862*(1-P_1864));  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine|pKa_pH_WS_lum_K6
P_2764 = ((1-P_1863)*(1-P_1862)*P_1864);  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine|pKa_pH_WS_lum_K5
P_2765 = (P_1863*P_1862*(1-P_1864));  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine|pKa_pH_WS_lum_K4
P_2766 = (P_1863*(1-P_1862)*P_1864);  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine|pKa_pH_WS_lum_K3
P_2767 = (P_2551*P_428);  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine-CYP1A2-MM|kcat_app
P_2768 = (((P_1869*P_1869)+(P_1869*P_1870)+(P_1870*P_1870))*P_1868*1.047197551196598);  % CoffeinSimulation|Organism|Lumen|LowerIleum|Volume
P_2769 = (3.141592653589793*(P_1869+P_1870)*P_1868);  % CoffeinSimulation|Organism|Lumen|LowerIleum|Geometric surface area
P_2770 = (P_429/P_1973);  % CoffeinSimulation|Organism|Lumen|LowerIleum|Intestinal transit rate (absolute)
P_2771 = (0.6931471805599453/P_1872);  % CoffeinSimulation|Organism|Lumen|LowerIleum|CYP1A2|Degradation coefficient
P_2772 = (P_1876*P_1875*P_1874);  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine|pKa_pH_WS_lum_K1
P_2773 = ((1-P_1876)*P_1875*P_1874);  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine|pKa_pH_WS_lum_K2
P_2774 = (P_1876*(1-P_1875)*P_1874);  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine|pKa_pH_WS_lum_K3
P_2775 = (P_1876*P_1875*(1-P_1874));  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine|pKa_pH_WS_lum_K4
P_2776 = ((1-P_1876)*(1-P_1875)*P_1874);  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine|pKa_pH_WS_lum_K5
P_2777 = ((1-P_1876)*P_1875*(1-P_1874));  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine|pKa_pH_WS_lum_K6
P_2778 = (P_1876*(1-P_1875)*(1-P_1874));  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine|pKa_pH_WS_lum_K7
P_2779 = ((1-P_1876)*(1-P_1875)*(1-P_1874));  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine|pKa_pH_WS_lum_K8
P_2780 = (P_2551*P_447);  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine-CYP1A2-MM|kcat_app
P_2781 = (P_458/P_2071);  % CoffeinSimulation|Organism|Lumen|Caecum|Intestinal transit rate (absolute)
P_2782 = (3.141592653589793*(P_1881+P_1879)*P_1880);  % CoffeinSimulation|Organism|Lumen|Caecum|Geometric surface area
P_2783 = (((P_1881*P_1881)+(P_1881*P_1879)+(P_1879*P_1879))*P_1880*1.047197551196598);  % CoffeinSimulation|Organism|Lumen|Caecum|Volume
P_2784 = (0.6931471805599453/P_1885);  % CoffeinSimulation|Organism|Lumen|Caecum|CYP1A2|Degradation coefficient
P_2785 = (P_1886*(1-P_1887)*(1-P_1888));  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine|pKa_pH_WS_lum_K7
P_2786 = (P_1886*P_1887*P_1888);  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine|pKa_pH_WS_lum_K1
P_2787 = ((1-P_1886)*P_1887*P_1888);  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine|pKa_pH_WS_lum_K2
P_2788 = (P_1886*(1-P_1887)*P_1888);  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine|pKa_pH_WS_lum_K3
P_2789 = (P_1886*P_1887*(1-P_1888));  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine|pKa_pH_WS_lum_K4
P_2790 = ((1-P_1886)*P_1887*(1-P_1888));  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine|pKa_pH_WS_lum_K6
P_2791 = ((1-P_1886)*(1-P_1887)*(1-P_1888));  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine|pKa_pH_WS_lum_K8
P_2792 = ((1-P_1886)*(1-P_1887)*P_1888);  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine|pKa_pH_WS_lum_K5
P_2793 = (P_2551*P_466);  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine-CYP1A2-MM|kcat_app
P_2794 = (3.141592653589793*(P_1893+P_1891)*P_1892);  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Geometric surface area
P_2795 = (((P_1893*P_1893)+(P_1893*P_1891)+(P_1891*P_1891))*P_1892*1.047197551196598);  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Volume
P_2796 = (P_474/P_2071);  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Intestinal transit rate (absolute)
P_2797 = (0.6931471805599453/P_1896);  % CoffeinSimulation|Organism|Lumen|ColonAscendens|CYP1A2|Degradation coefficient
P_2798 = (P_1898*P_1899*(1-P_1900));  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine|pKa_pH_WS_lum_K4
P_2799 = ((1-P_1898)*(1-P_1899)*P_1900);  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine|pKa_pH_WS_lum_K5
P_2800 = ((1-P_1898)*P_1899*(1-P_1900));  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine|pKa_pH_WS_lum_K6
P_2801 = (P_1898*(1-P_1899)*(1-P_1900));  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine|pKa_pH_WS_lum_K7
P_2802 = ((1-P_1898)*(1-P_1899)*(1-P_1900));  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine|pKa_pH_WS_lum_K8
P_2803 = (P_1898*P_1899*P_1900);  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine|pKa_pH_WS_lum_K1
P_2804 = (P_1898*(1-P_1899)*P_1900);  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine|pKa_pH_WS_lum_K3
P_2805 = ((1-P_1898)*P_1899*P_1900);  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine|pKa_pH_WS_lum_K2
P_2806 = (P_2551*P_485);  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine-CYP1A2-MM|kcat_app
P_2807 = (3.141592653589793*(P_1902+P_1903)*P_1904);  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Geometric surface area
P_2808 = (P_496/P_2071);  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Intestinal transit rate (absolute)
P_2809 = (((P_1902*P_1902)+(P_1902*P_1903)+(P_1903*P_1903))*P_1904*1.047197551196598);  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Volume
P_2810 = (0.6931471805599453/P_1908);  % CoffeinSimulation|Organism|Lumen|ColonTransversum|CYP1A2|Degradation coefficient
P_2811 = ((1-P_1910)*P_1911*(1-P_1912));  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine|pKa_pH_WS_lum_K6
P_2812 = (P_1910*(1-P_1911)*(1-P_1912));  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine|pKa_pH_WS_lum_K7
P_2813 = ((1-P_1910)*(1-P_1911)*(1-P_1912));  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine|pKa_pH_WS_lum_K8
P_2814 = (P_1910*(1-P_1911)*P_1912);  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine|pKa_pH_WS_lum_K3
P_2815 = ((1-P_1910)*(1-P_1911)*P_1912);  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine|pKa_pH_WS_lum_K5
P_2816 = (P_1910*P_1911*(1-P_1912));  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine|pKa_pH_WS_lum_K4
P_2817 = (P_1910*P_1911*P_1912);  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine|pKa_pH_WS_lum_K1
P_2818 = ((1-P_1910)*P_1911*P_1912);  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine|pKa_pH_WS_lum_K2
P_2819 = (P_2551*P_504);  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine-CYP1A2-MM|kcat_app
P_2820 = (3.141592653589793*(P_1918+P_1917)*P_1915);  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Geometric surface area
P_2821 = (P_515/P_2071);  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Intestinal transit rate (absolute)
P_2822 = (((P_1918*P_1918)+(P_1918*P_1917)+(P_1917*P_1917))*P_1915*1.047197551196598);  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Volume
P_2823 = (0.6931471805599453/P_1921);  % CoffeinSimulation|Organism|Lumen|ColonDescendens|CYP1A2|Degradation coefficient
P_2824 = (P_1923*P_1922*P_1924);  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine|pKa_pH_WS_lum_K1
P_2825 = ((1-P_1923)*P_1922*P_1924);  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine|pKa_pH_WS_lum_K2
P_2826 = (P_1923*(1-P_1922)*P_1924);  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine|pKa_pH_WS_lum_K3
P_2827 = (P_1923*P_1922*(1-P_1924));  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine|pKa_pH_WS_lum_K4
P_2828 = ((1-P_1923)*(1-P_1922)*P_1924);  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine|pKa_pH_WS_lum_K5
P_2829 = ((1-P_1923)*P_1922*(1-P_1924));  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine|pKa_pH_WS_lum_K6
P_2830 = (P_1923*(1-P_1922)*(1-P_1924));  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine|pKa_pH_WS_lum_K7
P_2831 = ((1-P_1923)*(1-P_1922)*(1-P_1924));  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine|pKa_pH_WS_lum_K8
P_2832 = (P_2551*P_523);  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine-CYP1A2-MM|kcat_app
P_2833 = (((P_1927*P_1927)+(P_1927*P_1930)+(P_1930*P_1930))*P_1926*1.047197551196598);  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Volume
P_2834 = (3.141592653589793*(P_1927+P_1930)*P_1926);  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Geometric surface area
P_2835 = (P_530/P_2071);  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Intestinal transit rate (absolute)
P_2836 = (0.6931471805599453/P_1932);  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|CYP1A2|Degradation coefficient
P_2837 = (P_1934*P_1935*P_1936);  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine|pKa_pH_WS_lum_K1
P_2838 = ((1-P_1934)*P_1935*P_1936);  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine|pKa_pH_WS_lum_K2
P_2839 = (P_1934*(1-P_1935)*P_1936);  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine|pKa_pH_WS_lum_K3
P_2840 = (P_1934*P_1935*(1-P_1936));  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine|pKa_pH_WS_lum_K4
P_2841 = ((1-P_1934)*(1-P_1935)*P_1936);  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine|pKa_pH_WS_lum_K5
P_2842 = ((1-P_1934)*P_1935*(1-P_1936));  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine|pKa_pH_WS_lum_K6
P_2843 = ((1-P_1934)*(1-P_1935)*(1-P_1936));  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine|pKa_pH_WS_lum_K8
P_2844 = (P_1934*(1-P_1935)*(1-P_1936));  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine|pKa_pH_WS_lum_K7
P_2845 = (P_2551*P_542);  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine-CYP1A2-MM|kcat_app
P_2846 = (3.141592653589793*(P_1941+P_1938)*P_1939);  % CoffeinSimulation|Organism|Lumen|Rectum|Geometric surface area
P_2847 = (((P_1941*P_1941)+(P_1941*P_1938)+(P_1938*P_1938))*P_1939*1.047197551196598);  % CoffeinSimulation|Organism|Lumen|Rectum|Volume
P_2848 = (P_544/P_2071);  % CoffeinSimulation|Organism|Lumen|Rectum|Intestinal transit rate (absolute)
P_2849 = (0.6931471805599453/P_1944);  % CoffeinSimulation|Organism|Lumen|Rectum|CYP1A2|Degradation coefficient
P_2850 = ((1-P_1948)*(1-P_1947)*P_1946);  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine|pKa_pH_WS_lum_K5
P_2851 = ((1-P_1948)*(1-P_1947)*(1-P_1946));  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine|pKa_pH_WS_lum_K8
P_2852 = (P_1948*(1-P_1947)*(1-P_1946));  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine|pKa_pH_WS_lum_K7
P_2853 = (P_1948*P_1947*(1-P_1946));  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine|pKa_pH_WS_lum_K4
P_2854 = ((1-P_1948)*P_1947*(1-P_1946));  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine|pKa_pH_WS_lum_K6
P_2855 = (P_1948*(1-P_1947)*P_1946);  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine|pKa_pH_WS_lum_K3
P_2856 = ((1-P_1948)*P_1947*P_1946);  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine|pKa_pH_WS_lum_K2
P_2857 = (P_1948*P_1947*P_1946);  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine|pKa_pH_WS_lum_K1
P_2858 = (P_2551*P_561);  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine-CYP1A2-MM|kcat_app
P_2859 = (P_2438*P_17);  % CoffeinSimulation|Organism|Stomach|Volume (endothelium)
P_2860 = (P_595*P_1951);  % CoffeinSimulation|Organism|Stomach|Blood flow rate
P_2861 = P_1953;  % CoffeinSimulation|Organism|Stomach|Plasma|Volume of protein container
P_2862 = (0.6931471805599453/P_1957);  % CoffeinSimulation|Organism|Stomach|Plasma|CYP1A2|Degradation coefficient
P_2863 = P_1955;  % CoffeinSimulation|Organism|Stomach|Plasma|CYP1A2|Relative expression out.
P_2864 = (IIf((P_1953 > 0),(y(102)/P_1953),0));  % CoffeinSimulation|Organism|Stomach|Plasma|Caffeine|Concentration
P_2865 = P_2514;  % CoffeinSimulation|Organism|Stomach|Plasma|Caffeine|Partition coefficient (water/container)
P_2866 = (IIf((P_1953 > 0),(y(103)/P_1953),0));  % CoffeinSimulation|Organism|Stomach|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_2867 = (P_2551*P_597);  % CoffeinSimulation|Organism|Stomach|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2868 = P_1959;  % CoffeinSimulation|Organism|Stomach|BloodCells|Volume of protein container
P_2869 = (0.6931471805599453/P_1963);  % CoffeinSimulation|Organism|Stomach|BloodCells|CYP1A2|Degradation coefficient
P_2870 = P_1961;  % CoffeinSimulation|Organism|Stomach|BloodCells|CYP1A2|Relative expression out.
P_2871 = (IIf((P_1959 > 0),(y(104)/P_1959),0));  % CoffeinSimulation|Organism|Stomach|BloodCells|Caffeine|Concentration
P_2872 = (IIf((P_1959 > 0),(y(105)/P_1959),0));  % CoffeinSimulation|Organism|Stomach|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_2873 = (P_2551*P_599);  % CoffeinSimulation|Organism|Stomach|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2874 = P_1965;  % CoffeinSimulation|Organism|Stomach|Interstitial|Volume of protein container
P_2875 = (IIf((P_1965 > 0),(y(106)/P_1965),0));  % CoffeinSimulation|Organism|Stomach|Interstitial|Caffeine|Concentration
P_2876 = (P_1952*P_594);  % CoffeinSimulation|Organism|Stomach|Intracellular|Volume
P_2877 = (0.6931471805599453/P_1970);  % CoffeinSimulation|Organism|Stomach|Intracellular|CYP1A2|Degradation coefficient
P_2878 = (P_1968*P_1553*P_1969*P_1967);  % CoffeinSimulation|Organism|Stomach|Intracellular|CYP1A2|Start amount
P_2879 = (P_2551*P_604);  % CoffeinSimulation|Organism|Stomach|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_2880 = (P_641*P_1972);  % CoffeinSimulation|Organism|SmallIntestine|Blood flow rate
P_2881 = (0.6931471805599453/P_1978);  % CoffeinSimulation|Organism|SmallIntestine|Plasma|CYP1A2|Degradation coefficient
P_2882 = P_1976;  % CoffeinSimulation|Organism|SmallIntestine|Plasma|CYP1A2|Relative expression out.
P_2883 = P_2514;  % CoffeinSimulation|Organism|SmallIntestine|Plasma|Caffeine|Partition coefficient (water/container)
P_2884 = (P_2551*P_643);  % CoffeinSimulation|Organism|SmallIntestine|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2885 = (0.6931471805599453/P_1983);  % CoffeinSimulation|Organism|SmallIntestine|BloodCells|CYP1A2|Degradation coefficient
P_2886 = P_1981;  % CoffeinSimulation|Organism|SmallIntestine|BloodCells|CYP1A2|Relative expression out.
P_2887 = (P_2551*P_645);  % CoffeinSimulation|Organism|SmallIntestine|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2888 = (0.6931471805599453/P_1988);  % CoffeinSimulation|Organism|SmallIntestine|Intracellular|CYP1A2|Degradation coefficient
P_2889 = (P_2551*P_650);  % CoffeinSimulation|Organism|SmallIntestine|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_2890 = (P_1821*P_653);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Volume
P_2891 = (0.6931471805599453/P_1993);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Plasma|CYP1A2|Degradation coefficient
P_2892 = P_1992;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Plasma|CYP1A2|Relative expression out.
P_2893 = P_2514;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Plasma|Caffeine|Partition coefficient (water/container)
P_2894 = (P_2551*P_681);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2895 = (0.6931471805599453/P_1999);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|BloodCells|CYP1A2|Degradation coefficient
P_2896 = P_1997;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|BloodCells|CYP1A2|Relative expression out.
P_2897 = (P_2551*P_683);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2898 = (0.6931471805599453/P_2003);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Intracellular|CYP1A2|Degradation coefficient
P_2899 = (P_2551*P_688);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_2900 = (P_1830*P_691);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Volume
P_2901 = (0.6931471805599453/P_2010);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Plasma|CYP1A2|Degradation coefficient
P_2902 = P_2008;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Plasma|CYP1A2|Relative expression out.
P_2903 = P_2514;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Plasma|Caffeine|Partition coefficient (water/container)
P_2904 = (P_2551*P_719);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2905 = (0.6931471805599453/P_2015);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|BloodCells|CYP1A2|Degradation coefficient
P_2906 = P_2013;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|BloodCells|CYP1A2|Relative expression out.
P_2907 = (P_2551*P_721);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2908 = (0.6931471805599453/P_2020);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Intracellular|CYP1A2|Degradation coefficient
P_2909 = (P_2551*P_726);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_2910 = (P_1844*P_729);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Volume
P_2911 = (0.6931471805599453/P_2025);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Plasma|CYP1A2|Degradation coefficient
P_2912 = P_2024;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Plasma|CYP1A2|Relative expression out.
P_2913 = P_2514;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Plasma|Caffeine|Partition coefficient (water/container)
P_2914 = (P_2551*P_757);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2915 = (0.6931471805599453/P_2031);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|BloodCells|CYP1A2|Degradation coefficient
P_2916 = P_2029;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|BloodCells|CYP1A2|Relative expression out.
P_2917 = (P_2551*P_759);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2918 = (0.6931471805599453/P_2036);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Intracellular|CYP1A2|Degradation coefficient
P_2919 = (P_2551*P_764);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_2920 = (P_1858*P_766);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Volume
P_2921 = (0.6931471805599453/P_2042);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Plasma|CYP1A2|Degradation coefficient
P_2922 = P_2040;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Plasma|CYP1A2|Relative expression out.
P_2923 = P_2514;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Plasma|Caffeine|Partition coefficient (water/container)
P_2924 = (P_2551*P_795);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2925 = (0.6931471805599453/P_2047);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|BloodCells|CYP1A2|Degradation coefficient
P_2926 = P_2045;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|BloodCells|CYP1A2|Relative expression out.
P_2927 = (P_2551*P_797);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2928 = (0.6931471805599453/P_2051);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Intracellular|CYP1A2|Degradation coefficient
P_2929 = (P_2551*P_802);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_2930 = (P_1866*P_805);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Volume
P_2931 = (0.6931471805599453/P_2057);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Plasma|CYP1A2|Degradation coefficient
P_2932 = P_2056;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Plasma|CYP1A2|Relative expression out.
P_2933 = P_2514;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Plasma|Caffeine|Partition coefficient (water/container)
P_2934 = (P_2551*P_833);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2935 = (0.6931471805599453/P_2063);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|BloodCells|CYP1A2|Degradation coefficient
P_2936 = P_2061;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|BloodCells|CYP1A2|Relative expression out.
P_2937 = (P_2551*P_835);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2938 = (0.6931471805599453/P_2068);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Intracellular|CYP1A2|Degradation coefficient
P_2939 = (P_2551*P_840);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_2940 = (P_877*P_2070);  % CoffeinSimulation|Organism|LargeIntestine|Blood flow rate
P_2941 = (0.6931471805599453/P_2075);  % CoffeinSimulation|Organism|LargeIntestine|Plasma|CYP1A2|Degradation coefficient
P_2942 = P_2074;  % CoffeinSimulation|Organism|LargeIntestine|Plasma|CYP1A2|Relative expression out.
P_2943 = P_2514;  % CoffeinSimulation|Organism|LargeIntestine|Plasma|Caffeine|Partition coefficient (water/container)
P_2944 = (P_2551*P_879);  % CoffeinSimulation|Organism|LargeIntestine|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2945 = (0.6931471805599453/P_2081);  % CoffeinSimulation|Organism|LargeIntestine|BloodCells|CYP1A2|Degradation coefficient
P_2946 = P_2079;  % CoffeinSimulation|Organism|LargeIntestine|BloodCells|CYP1A2|Relative expression out.
P_2947 = (P_2551*P_881);  % CoffeinSimulation|Organism|LargeIntestine|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2948 = (0.6931471805599453/P_2085);  % CoffeinSimulation|Organism|LargeIntestine|Intracellular|CYP1A2|Degradation coefficient
P_2949 = (P_2551*P_886);  % CoffeinSimulation|Organism|LargeIntestine|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_2950 = (P_1878*P_889);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Volume
P_2951 = (0.6931471805599453/P_2092);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Plasma|CYP1A2|Degradation coefficient
P_2952 = P_2090;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Plasma|CYP1A2|Relative expression out.
P_2953 = P_2514;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Plasma|Caffeine|Partition coefficient (water/container)
P_2954 = (P_2551*P_917);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2955 = (0.6931471805599453/P_2097);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|BloodCells|CYP1A2|Degradation coefficient
P_2956 = P_2095;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|BloodCells|CYP1A2|Relative expression out.
P_2957 = (P_2551*P_919);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2958 = (0.6931471805599453/P_2102);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Intracellular|CYP1A2|Degradation coefficient
P_2959 = (P_2551*P_924);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_2960 = (P_1890*P_926);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Volume
P_2961 = (0.6931471805599453/P_2107);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Plasma|CYP1A2|Degradation coefficient
P_2962 = P_2106;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Plasma|CYP1A2|Relative expression out.
P_2963 = P_2514;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Plasma|Caffeine|Partition coefficient (water/container)
P_2964 = (P_2551*P_955);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2965 = (0.6931471805599453/P_2113);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|BloodCells|CYP1A2|Degradation coefficient
P_2966 = P_2111;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|BloodCells|CYP1A2|Relative expression out.
P_2967 = (P_2551*P_957);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2968 = (0.6931471805599453/P_2118);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Intracellular|CYP1A2|Degradation coefficient
P_2969 = (P_2551*P_962);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_2970 = (P_1906*P_965);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Volume
P_2971 = (0.6931471805599453/P_2124);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Plasma|CYP1A2|Degradation coefficient
P_2972 = P_2122;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Plasma|CYP1A2|Relative expression out.
P_2973 = P_2514;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Plasma|Caffeine|Partition coefficient (water/container)
P_2974 = (P_2551*P_993);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2975 = (0.6931471805599453/P_2129);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|BloodCells|CYP1A2|Degradation coefficient
P_2976 = P_2127;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|BloodCells|CYP1A2|Relative expression out.
P_2977 = (P_2551*P_995);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2978 = (0.6931471805599453/P_2133);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Intracellular|CYP1A2|Degradation coefficient
P_2979 = (P_2551*P_1000);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_2980 = (P_1916*P_1003);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Volume
P_2981 = (0.6931471805599453/P_2140);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Plasma|CYP1A2|Degradation coefficient
P_2982 = P_2138;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Plasma|CYP1A2|Relative expression out.
P_2983 = P_2514;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Plasma|Caffeine|Partition coefficient (water/container)
P_2984 = (P_2551*P_1031);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2985 = (0.6931471805599453/P_2144);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|BloodCells|CYP1A2|Degradation coefficient
P_2986 = P_2143;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|BloodCells|CYP1A2|Relative expression out.
P_2987 = (P_2551*P_1033);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2988 = (0.6931471805599453/P_2150);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Intracellular|CYP1A2|Degradation coefficient
P_2989 = (P_2551*P_1038);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_2990 = (P_1929*P_1041);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Volume
P_2991 = (0.6931471805599453/P_2156);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Plasma|CYP1A2|Degradation coefficient
P_2992 = P_2154;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Plasma|CYP1A2|Relative expression out.
P_2993 = P_2514;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Plasma|Caffeine|Partition coefficient (water/container)
P_2994 = (P_2551*P_1069);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_2995 = (0.6931471805599453/P_2161);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|BloodCells|CYP1A2|Degradation coefficient
P_2996 = P_2159;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|BloodCells|CYP1A2|Relative expression out.
P_2997 = (P_2551*P_1071);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_2998 = (0.6931471805599453/P_2166);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Intracellular|CYP1A2|Degradation coefficient
P_2999 = (P_2551*P_1076);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_3000 = (P_1940*P_1079);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Volume
P_3001 = (0.6931471805599453/P_2172);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Plasma|CYP1A2|Degradation coefficient
P_3002 = P_2170;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Plasma|CYP1A2|Relative expression out.
P_3003 = P_2514;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Plasma|Caffeine|Partition coefficient (water/container)
P_3004 = (P_2551*P_1107);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_3005 = (0.6931471805599453/P_2177);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|BloodCells|CYP1A2|Degradation coefficient
P_3006 = P_2175;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|BloodCells|CYP1A2|Relative expression out.
P_3007 = (P_2551*P_1109);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_3008 = (0.6931471805599453/P_2181);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Intracellular|CYP1A2|Degradation coefficient
P_3009 = (P_2551*P_1114);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_3010 = (P_2453*P_17);  % CoffeinSimulation|Organism|Liver|Volume (endothelium)
P_3011 = (P_1152*P_2184);  % CoffeinSimulation|Organism|Liver|Blood flow rate
P_3012 = (P_2189*P_2187);  % CoffeinSimulation|Organism|Liver|Periportal|Weight (tissue)
P_3013 = P_2185;  % CoffeinSimulation|Organism|Liver|Periportal|Fraction intracellular
P_3014 = (P_2202*(1-P_42)*P_2189);  % CoffeinSimulation|Organism|Liver|Periportal|Plasma|Volume
P_3015 = (0.6931471805599453/P_2221);  % CoffeinSimulation|Organism|Liver|Periportal|Plasma|CYP1A2|Degradation coefficient
P_3016 = P_2219;  % CoffeinSimulation|Organism|Liver|Periportal|Plasma|CYP1A2|Relative expression out.
P_3017 = P_2514;  % CoffeinSimulation|Organism|Liver|Periportal|Plasma|Caffeine|Partition coefficient (water/container)
P_3018 = (P_2551*P_1154);  % CoffeinSimulation|Organism|Liver|Periportal|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_3019 = (P_2202*P_42*P_2189);  % CoffeinSimulation|Organism|Liver|Periportal|BloodCells|Volume
P_3020 = (0.6931471805599453/P_2226);  % CoffeinSimulation|Organism|Liver|Periportal|BloodCells|CYP1A2|Degradation coefficient
P_3021 = P_2224;  % CoffeinSimulation|Organism|Liver|Periportal|BloodCells|CYP1A2|Relative expression out.
P_3022 = (P_2551*P_1156);  % CoffeinSimulation|Organism|Liver|Periportal|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_3023 = (P_2206*P_2189);  % CoffeinSimulation|Organism|Liver|Periportal|Interstitial|Volume
P_3024 = P_2189;  % CoffeinSimulation|Organism|Liver|Periportal|Intracellular|Volume of protein container
P_3025 = (0.6931471805599453/P_2232);  % CoffeinSimulation|Organism|Liver|Periportal|Intracellular|CYP1A2|Degradation coefficient
P_3026 = (P_2551*P_1160);  % CoffeinSimulation|Organism|Liver|Periportal|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_3027 = (P_2237*P_2235);  % CoffeinSimulation|Organism|Liver|Pericentral|Weight (tissue)
P_3028 = P_2185;  % CoffeinSimulation|Organism|Liver|Pericentral|Fraction intracellular
P_3029 = (P_2246*(1-P_42)*P_2237);  % CoffeinSimulation|Organism|Liver|Pericentral|Plasma|Volume
P_3030 = (0.6931471805599453/P_2269);  % CoffeinSimulation|Organism|Liver|Pericentral|Plasma|CYP1A2|Degradation coefficient
P_3031 = P_2267;  % CoffeinSimulation|Organism|Liver|Pericentral|Plasma|CYP1A2|Relative expression out.
P_3032 = P_2514;  % CoffeinSimulation|Organism|Liver|Pericentral|Plasma|Caffeine|Partition coefficient (water/container)
P_3033 = (P_2551*P_1162);  % CoffeinSimulation|Organism|Liver|Pericentral|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_3034 = (P_2246*P_42*P_2237);  % CoffeinSimulation|Organism|Liver|Pericentral|BloodCells|Volume
P_3035 = (0.6931471805599453/P_2273);  % CoffeinSimulation|Organism|Liver|Pericentral|BloodCells|CYP1A2|Degradation coefficient
P_3036 = P_2272;  % CoffeinSimulation|Organism|Liver|Pericentral|BloodCells|CYP1A2|Relative expression out.
P_3037 = (P_2551*P_1164);  % CoffeinSimulation|Organism|Liver|Pericentral|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_3038 = (P_2254*P_2237);  % CoffeinSimulation|Organism|Liver|Pericentral|Interstitial|Volume
P_3039 = P_2237;  % CoffeinSimulation|Organism|Liver|Pericentral|Intracellular|Volume of protein container
P_3040 = (0.6931471805599453/P_2280);  % CoffeinSimulation|Organism|Liver|Pericentral|Intracellular|CYP1A2|Degradation coefficient
P_3041 = (P_2551*P_1168);  % CoffeinSimulation|Organism|Liver|Pericentral|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_3042 = (P_2185*P_1151);  % CoffeinSimulation|Organism|Liver|Intracellular|Volume
P_3043 = (P_2456*P_17);  % CoffeinSimulation|Organism|Lung|Volume (endothelium)
P_3044 = P_2288;  % CoffeinSimulation|Organism|Lung|Plasma|Volume of protein container
P_3045 = (0.6931471805599453/P_2292);  % CoffeinSimulation|Organism|Lung|Plasma|CYP1A2|Degradation coefficient
P_3046 = P_2290;  % CoffeinSimulation|Organism|Lung|Plasma|CYP1A2|Relative expression out.
P_3047 = (IIf((P_2288 > 0),(y(214)/P_2288),0));  % CoffeinSimulation|Organism|Lung|Plasma|Caffeine|Concentration
P_3048 = P_2514;  % CoffeinSimulation|Organism|Lung|Plasma|Caffeine|Partition coefficient (water/container)
P_3049 = (IIf((P_2288 > 0),(y(215)/P_2288),0));  % CoffeinSimulation|Organism|Lung|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_3050 = (P_2551*P_1203);  % CoffeinSimulation|Organism|Lung|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_3051 = P_2294;  % CoffeinSimulation|Organism|Lung|BloodCells|Volume of protein container
P_3052 = (0.6931471805599453/P_2298);  % CoffeinSimulation|Organism|Lung|BloodCells|CYP1A2|Degradation coefficient
P_3053 = P_2296;  % CoffeinSimulation|Organism|Lung|BloodCells|CYP1A2|Relative expression out.
P_3054 = (IIf((P_2294 > 0),(y(216)/P_2294),0));  % CoffeinSimulation|Organism|Lung|BloodCells|Caffeine|Concentration
P_3055 = (IIf((P_2294 > 0),(y(217)/P_2294),0));  % CoffeinSimulation|Organism|Lung|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_3056 = (P_2551*P_1205);  % CoffeinSimulation|Organism|Lung|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_3057 = P_2300;  % CoffeinSimulation|Organism|Lung|Interstitial|Volume of protein container
P_3058 = (IIf((P_2300 > 0),(y(218)/P_2300),0));  % CoffeinSimulation|Organism|Lung|Interstitial|Caffeine|Concentration
P_3059 = (P_2287*P_1200);  % CoffeinSimulation|Organism|Lung|Intracellular|Volume
P_3060 = (0.6931471805599453/P_2305);  % CoffeinSimulation|Organism|Lung|Intracellular|CYP1A2|Degradation coefficient
P_3061 = (P_2303*P_1553*P_2304*P_2302);  % CoffeinSimulation|Organism|Lung|Intracellular|CYP1A2|Start amount
P_3062 = (P_2551*P_1210);  % CoffeinSimulation|Organism|Lung|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_3063 = (P_2459*P_17);  % CoffeinSimulation|Organism|Muscle|Volume (endothelium)
P_3064 = (P_1244*P_2307);  % CoffeinSimulation|Organism|Muscle|Blood flow rate
P_3065 = P_2309;  % CoffeinSimulation|Organism|Muscle|Plasma|Volume of protein container
P_3066 = (0.6931471805599453/P_2312);  % CoffeinSimulation|Organism|Muscle|Plasma|CYP1A2|Degradation coefficient
P_3067 = P_2311;  % CoffeinSimulation|Organism|Muscle|Plasma|CYP1A2|Relative expression out.
P_3068 = (IIf((P_2309 > 0),(y(221)/P_2309),0));  % CoffeinSimulation|Organism|Muscle|Plasma|Caffeine|Concentration
P_3069 = P_2514;  % CoffeinSimulation|Organism|Muscle|Plasma|Caffeine|Partition coefficient (water/container)
P_3070 = (IIf((P_2309 > 0),(y(222)/P_2309),0));  % CoffeinSimulation|Organism|Muscle|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_3071 = (P_2551*P_1246);  % CoffeinSimulation|Organism|Muscle|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_3072 = P_2315;  % CoffeinSimulation|Organism|Muscle|BloodCells|Volume of protein container
P_3073 = (0.6931471805599453/P_2319);  % CoffeinSimulation|Organism|Muscle|BloodCells|CYP1A2|Degradation coefficient
P_3074 = P_2317;  % CoffeinSimulation|Organism|Muscle|BloodCells|CYP1A2|Relative expression out.
P_3075 = (IIf((P_2315 > 0),(y(223)/P_2315),0));  % CoffeinSimulation|Organism|Muscle|BloodCells|Caffeine|Concentration
P_3076 = (IIf((P_2315 > 0),(y(224)/P_2315),0));  % CoffeinSimulation|Organism|Muscle|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_3077 = (P_2551*P_1248);  % CoffeinSimulation|Organism|Muscle|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_3078 = P_2321;  % CoffeinSimulation|Organism|Muscle|Interstitial|Volume of protein container
P_3079 = (IIf((P_2321 > 0),(y(225)/P_2321),0));  % CoffeinSimulation|Organism|Muscle|Interstitial|Caffeine|Concentration
P_3080 = (P_2308*P_1228);  % CoffeinSimulation|Organism|Muscle|Intracellular|Volume
P_3081 = (0.6931471805599453/P_2326);  % CoffeinSimulation|Organism|Muscle|Intracellular|CYP1A2|Degradation coefficient
P_3082 = (P_2324*P_1553*P_2325*P_2323);  % CoffeinSimulation|Organism|Muscle|Intracellular|CYP1A2|Start amount
P_3083 = (P_2551*P_1253);  % CoffeinSimulation|Organism|Muscle|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_3084 = (P_2463*P_17);  % CoffeinSimulation|Organism|Pancreas|Volume (endothelium)
P_3085 = (P_1286*P_2328);  % CoffeinSimulation|Organism|Pancreas|Blood flow rate
P_3086 = P_2330;  % CoffeinSimulation|Organism|Pancreas|Plasma|Volume of protein container
P_3087 = (0.6931471805599453/P_2333);  % CoffeinSimulation|Organism|Pancreas|Plasma|CYP1A2|Degradation coefficient
P_3088 = P_2332;  % CoffeinSimulation|Organism|Pancreas|Plasma|CYP1A2|Relative expression out.
P_3089 = (IIf((P_2330 > 0),(y(228)/P_2330),0));  % CoffeinSimulation|Organism|Pancreas|Plasma|Caffeine|Concentration
P_3090 = P_2514;  % CoffeinSimulation|Organism|Pancreas|Plasma|Caffeine|Partition coefficient (water/container)
P_3091 = (IIf((P_2330 > 0),(y(229)/P_2330),0));  % CoffeinSimulation|Organism|Pancreas|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_3092 = (P_2551*P_1288);  % CoffeinSimulation|Organism|Pancreas|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_3093 = P_2336;  % CoffeinSimulation|Organism|Pancreas|BloodCells|Volume of protein container
P_3094 = (0.6931471805599453/P_2340);  % CoffeinSimulation|Organism|Pancreas|BloodCells|CYP1A2|Degradation coefficient
P_3095 = P_2338;  % CoffeinSimulation|Organism|Pancreas|BloodCells|CYP1A2|Relative expression out.
P_3096 = (IIf((P_2336 > 0),(y(230)/P_2336),0));  % CoffeinSimulation|Organism|Pancreas|BloodCells|Caffeine|Concentration
P_3097 = (IIf((P_2336 > 0),(y(231)/P_2336),0));  % CoffeinSimulation|Organism|Pancreas|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_3098 = (P_2551*P_1290);  % CoffeinSimulation|Organism|Pancreas|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_3099 = P_2342;  % CoffeinSimulation|Organism|Pancreas|Interstitial|Volume of protein container
P_3100 = (IIf((P_2342 > 0),(y(232)/P_2342),0));  % CoffeinSimulation|Organism|Pancreas|Interstitial|Caffeine|Concentration
P_3101 = (P_2329*P_1285);  % CoffeinSimulation|Organism|Pancreas|Intracellular|Volume
P_3102 = (0.6931471805599453/P_2347);  % CoffeinSimulation|Organism|Pancreas|Intracellular|CYP1A2|Degradation coefficient
P_3103 = (P_2345*P_1553*P_2346*P_2344);  % CoffeinSimulation|Organism|Pancreas|Intracellular|CYP1A2|Start amount
P_3104 = (P_2551*P_1295);  % CoffeinSimulation|Organism|Pancreas|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_3105 = P_2350;  % CoffeinSimulation|Organism|PortalVein|Plasma|Volume of protein container
P_3106 = (0.6931471805599453/P_2353);  % CoffeinSimulation|Organism|PortalVein|Plasma|CYP1A2|Degradation coefficient
P_3107 = P_2352;  % CoffeinSimulation|Organism|PortalVein|Plasma|CYP1A2|Relative expression out.
P_3108 = (IIf((P_2350 > 0),(y(235)/P_2350),0));  % CoffeinSimulation|Organism|PortalVein|Plasma|Caffeine|Concentration
P_3109 = P_2514;  % CoffeinSimulation|Organism|PortalVein|Plasma|Caffeine|Partition coefficient (water/container)
P_3110 = (IIf((P_2350 > 0),(y(236)/P_2350),0));  % CoffeinSimulation|Organism|PortalVein|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_3111 = (P_2551*P_1301);  % CoffeinSimulation|Organism|PortalVein|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_3112 = P_2356;  % CoffeinSimulation|Organism|PortalVein|BloodCells|Volume of protein container
P_3113 = (0.6931471805599453/P_2360);  % CoffeinSimulation|Organism|PortalVein|BloodCells|CYP1A2|Degradation coefficient
P_3114 = P_2358;  % CoffeinSimulation|Organism|PortalVein|BloodCells|CYP1A2|Relative expression out.
P_3115 = (IIf((P_2356 > 0),(y(237)/P_2356),0));  % CoffeinSimulation|Organism|PortalVein|BloodCells|Caffeine|Concentration
P_3116 = (IIf((P_2356 > 0),(y(238)/P_2356),0));  % CoffeinSimulation|Organism|PortalVein|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_3117 = (P_2551*P_1303);  % CoffeinSimulation|Organism|PortalVein|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_3118 = (P_2473*P_17);  % CoffeinSimulation|Organism|Skin|Volume (endothelium)
P_3119 = (P_1337*P_2362);  % CoffeinSimulation|Organism|Skin|Blood flow rate
P_3120 = P_2364;  % CoffeinSimulation|Organism|Skin|Plasma|Volume of protein container
P_3121 = (0.6931471805599453/P_2367);  % CoffeinSimulation|Organism|Skin|Plasma|CYP1A2|Degradation coefficient
P_3122 = P_2366;  % CoffeinSimulation|Organism|Skin|Plasma|CYP1A2|Relative expression out.
P_3123 = (IIf((P_2364 > 0),(y(239)/P_2364),0));  % CoffeinSimulation|Organism|Skin|Plasma|Caffeine|Concentration
P_3124 = P_2514;  % CoffeinSimulation|Organism|Skin|Plasma|Caffeine|Partition coefficient (water/container)
P_3125 = (IIf((P_2364 > 0),(y(240)/P_2364),0));  % CoffeinSimulation|Organism|Skin|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_3126 = (P_2551*P_1339);  % CoffeinSimulation|Organism|Skin|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_3127 = P_2370;  % CoffeinSimulation|Organism|Skin|BloodCells|Volume of protein container
P_3128 = (0.6931471805599453/P_2374);  % CoffeinSimulation|Organism|Skin|BloodCells|CYP1A2|Degradation coefficient
P_3129 = P_2372;  % CoffeinSimulation|Organism|Skin|BloodCells|CYP1A2|Relative expression out.
P_3130 = (IIf((P_2370 > 0),(y(241)/P_2370),0));  % CoffeinSimulation|Organism|Skin|BloodCells|Caffeine|Concentration
P_3131 = (IIf((P_2370 > 0),(y(242)/P_2370),0));  % CoffeinSimulation|Organism|Skin|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_3132 = (P_2551*P_1341);  % CoffeinSimulation|Organism|Skin|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_3133 = P_2376;  % CoffeinSimulation|Organism|Skin|Interstitial|Volume of protein container
P_3134 = (IIf((P_2376 > 0),(y(243)/P_2376),0));  % CoffeinSimulation|Organism|Skin|Interstitial|Caffeine|Concentration
P_3135 = (P_2363*P_1336);  % CoffeinSimulation|Organism|Skin|Intracellular|Volume
P_3136 = (0.6931471805599453/P_2381);  % CoffeinSimulation|Organism|Skin|Intracellular|CYP1A2|Degradation coefficient
P_3137 = (P_2379*P_1553*P_2380*P_2378);  % CoffeinSimulation|Organism|Skin|Intracellular|CYP1A2|Start amount
P_3138 = (P_2551*P_1346);  % CoffeinSimulation|Organism|Skin|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_3139 = (P_2475*P_17);  % CoffeinSimulation|Organism|Spleen|Volume (endothelium)
P_3140 = (P_1379*P_2383);  % CoffeinSimulation|Organism|Spleen|Blood flow rate
P_3141 = P_2385;  % CoffeinSimulation|Organism|Spleen|Plasma|Volume of protein container
P_3142 = (0.6931471805599453/P_2389);  % CoffeinSimulation|Organism|Spleen|Plasma|CYP1A2|Degradation coefficient
P_3143 = P_2387;  % CoffeinSimulation|Organism|Spleen|Plasma|CYP1A2|Relative expression out.
P_3144 = (IIf((P_2385 > 0),(y(246)/P_2385),0));  % CoffeinSimulation|Organism|Spleen|Plasma|Caffeine|Concentration
P_3145 = P_2514;  % CoffeinSimulation|Organism|Spleen|Plasma|Caffeine|Partition coefficient (water/container)
P_3146 = (IIf((P_2385 > 0),(y(247)/P_2385),0));  % CoffeinSimulation|Organism|Spleen|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_3147 = (P_2551*P_1381);  % CoffeinSimulation|Organism|Spleen|Plasma|Caffeine-CYP1A2-MM|kcat_app
P_3148 = P_2391;  % CoffeinSimulation|Organism|Spleen|BloodCells|Volume of protein container
P_3149 = (0.6931471805599453/P_2395);  % CoffeinSimulation|Organism|Spleen|BloodCells|CYP1A2|Degradation coefficient
P_3150 = P_2393;  % CoffeinSimulation|Organism|Spleen|BloodCells|CYP1A2|Relative expression out.
P_3151 = (IIf((P_2391 > 0),(y(248)/P_2391),0));  % CoffeinSimulation|Organism|Spleen|BloodCells|Caffeine|Concentration
P_3152 = (IIf((P_2391 > 0),(y(249)/P_2391),0));  % CoffeinSimulation|Organism|Spleen|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_3153 = (P_2551*P_1383);  % CoffeinSimulation|Organism|Spleen|BloodCells|Caffeine-CYP1A2-MM|kcat_app
P_3154 = P_2397;  % CoffeinSimulation|Organism|Spleen|Interstitial|Volume of protein container
P_3155 = (IIf((P_2397 > 0),(y(250)/P_2397),0));  % CoffeinSimulation|Organism|Spleen|Interstitial|Caffeine|Concentration
P_3156 = (P_2384*P_1378);  % CoffeinSimulation|Organism|Spleen|Intracellular|Volume
P_3157 = (0.6931471805599453/P_2402);  % CoffeinSimulation|Organism|Spleen|Intracellular|CYP1A2|Degradation coefficient
P_3158 = (P_2400*P_1553*P_2401*P_2399);  % CoffeinSimulation|Organism|Spleen|Intracellular|CYP1A2|Start amount
P_3159 = (P_2551*P_1388);  % CoffeinSimulation|Organism|Spleen|Intracellular|Caffeine-CYP1A2-MM|kcat_app
P_3160 = ((P_83+(P_78*(10^P_1535))+(P_80*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|Bone_int_Bone_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3161 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|Bone_pls_Bone_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3162 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|Brain_pls_Brain_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3163 = ((P_125+(P_120*(10^P_1535))+(P_122*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|Brain_int_Brain_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3164 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|Fat_pls_Fat_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3165 = ((P_175+(P_172*(10^P_1535))+(P_163*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|Fat_int_Fat_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3166 = ((P_213+(P_205*(10^P_1535))+(P_208*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|Gonads_int_Gonads_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3167 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|Gonads_pls_Gonads_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3168 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|Heart_pls_Heart_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3169 = ((P_254+(P_247*(10^P_1535))+(P_250*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|Heart_int_Heart_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3170 = ((1-P_2423)*(1-P_2421)*(1-P_2424));  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_lum_K8
P_3171 = (P_2426*P_2425*P_2422);  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_cell_K1
P_3172 = ((1-P_2426)*P_2425*P_2422);  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_cell_K2
P_3173 = (P_2426*(1-P_2425)*P_2422);  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_cell_K3
P_3174 = (P_2426*P_2425*(1-P_2422));  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_cell_K4
P_3175 = ((1-P_2426)*(1-P_2425)*P_2422);  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_cell_K5
P_3176 = ((1-P_2426)*P_2425*(1-P_2422));  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_cell_K6
P_3177 = (P_2426*(1-P_2425)*(1-P_2422));  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_cell_K7
P_3178 = (P_2423*P_2421*P_2424);  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_lum_K1
P_3179 = ((1-P_2423)*P_2421*P_2424);  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_lum_K2
P_3180 = (P_2423*(1-P_2421)*P_2424);  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_lum_K3
P_3181 = (P_2423*P_2421*(1-P_2424));  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_lum_K4
P_3182 = ((1-P_2423)*(1-P_2421)*P_2424);  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_lum_K5
P_3183 = ((1-P_2423)*P_2421*(1-P_2424));  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_lum_K6
P_3184 = (P_2423*(1-P_2421)*(1-P_2424));  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_lum_K7
P_3185 = ((1-P_2426)*(1-P_2425)*(1-P_2422));  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|pKa_pH_WS_cell_K8
P_3186 = ((P_296+(P_290*(10^P_1535))+(P_293*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|Kidney_int_Kidney_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3187 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|Kidney_pls_Kidney_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3188 = ((1-P_2431)*P_2432*P_2434);  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_lum_K2
P_3189 = (P_2435*(1-P_2436)*P_2433);  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_cell_K3
P_3190 = (P_2435*P_2436*(1-P_2433));  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_cell_K4
P_3191 = ((1-P_2435)*(1-P_2436)*P_2433);  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_cell_K5
P_3192 = ((1-P_2435)*P_2436*(1-P_2433));  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_cell_K6
P_3193 = (P_2435*(1-P_2436)*(1-P_2433));  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_cell_K7
P_3194 = ((1-P_2435)*(1-P_2436)*(1-P_2433));  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_cell_K8
P_3195 = (P_2431*P_2432*P_2434);  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_lum_K1
P_3196 = (P_2431*(1-P_2432)*P_2434);  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_lum_K3
P_3197 = (P_2431*P_2432*(1-P_2434));  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_lum_K4
P_3198 = ((1-P_2431)*(1-P_2432)*P_2434);  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_lum_K5
P_3199 = ((1-P_2431)*P_2432*(1-P_2434));  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_lum_K6
P_3200 = (P_2431*(1-P_2432)*(1-P_2434));  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_lum_K7
P_3201 = ((1-P_2431)*(1-P_2432)*(1-P_2434));  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_lum_K8
P_3202 = ((1-P_2435)*P_2436*P_2433);  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_cell_K2
P_3203 = (P_2435*P_2436*P_2433);  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|pKa_pH_WS_cell_K1
P_3204 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|Stomach_pls_Stomach_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3205 = ((P_582+(P_574*(10^P_1535))+(P_576*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|Stomach_int_Stomach_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3206 = ((1-P_2441)*(1-P_2442)*P_2443);  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_lum_K5
P_3207 = ((1-P_2444)*P_2445*(1-P_2446));  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_cell_K6
P_3208 = (P_2444*(1-P_2445)*(1-P_2446));  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_cell_K7
P_3209 = ((1-P_2444)*(1-P_2445)*(1-P_2446));  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_cell_K8
P_3210 = (P_2441*P_2442*P_2443);  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_lum_K1
P_3211 = ((1-P_2441)*P_2442*P_2443);  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_lum_K2
P_3212 = (P_2441*P_2442*(1-P_2443));  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_lum_K4
P_3213 = (P_2444*(1-P_2445)*P_2446);  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_cell_K3
P_3214 = ((1-P_2441)*P_2442*(1-P_2443));  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_lum_K6
P_3215 = (P_2441*(1-P_2442)*(1-P_2443));  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_lum_K7
P_3216 = ((1-P_2441)*(1-P_2442)*(1-P_2443));  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_lum_K8
P_3217 = (P_2441*(1-P_2442)*P_2443);  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_lum_K3
P_3218 = ((1-P_2444)*(1-P_2445)*P_2446);  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_cell_K5
P_3219 = (P_2444*P_2445*(1-P_2446));  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_cell_K4
P_3220 = (P_2444*P_2445*P_2446);  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_cell_K1
P_3221 = ((1-P_2444)*P_2445*P_2446);  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|pKa_pH_WS_cell_K2
P_3222 = ((P_623+(P_618*(10^P_1535))+(P_622*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|SmallIntestine_int_SmallIntestine_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3223 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|SmallIntestine_pls_SmallIntestine_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3224 = (P_2450*(1-P_2451)*P_2447);  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_lum_K3
P_3225 = (P_2450*P_2451*(1-P_2447));  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_lum_K4
P_3226 = ((1-P_2450)*(1-P_2451)*P_2447);  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_lum_K5
P_3227 = ((1-P_2450)*P_2451*(1-P_2447));  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_lum_K6
P_3228 = (P_2450*(1-P_2451)*(1-P_2447));  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_lum_K7
P_3229 = ((1-P_2450)*(1-P_2451)*(1-P_2447));  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_lum_K8
P_3230 = ((1-P_2450)*P_2451*P_2447);  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_lum_K2
P_3231 = (P_2450*P_2451*P_2447);  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_lum_K1
P_3232 = (P_2452*P_2449*P_2448);  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_cell_K1
P_3233 = ((1-P_2452)*P_2449*P_2448);  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_cell_K2
P_3234 = (P_2452*(1-P_2449)*P_2448);  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_cell_K3
P_3235 = (P_2452*P_2449*(1-P_2448));  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_cell_K4
P_3236 = ((1-P_2452)*(1-P_2449)*P_2448);  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_cell_K5
P_3237 = ((1-P_2452)*P_2449*(1-P_2448));  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_cell_K6
P_3238 = (P_2452*(1-P_2449)*(1-P_2448));  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_cell_K7
P_3239 = ((1-P_2452)*(1-P_2449)*(1-P_2448));  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|pKa_pH_WS_cell_K8
P_3240 = ((P_862+(P_854*(10^P_1535))+(P_858*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|LargeIntestine_int_LargeIntestine_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3241 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|LargeIntestine_pls_LargeIntestine_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3242 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|Periportal_pls_Periportal_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3243 = (P_2453*(IIf(P_1115,P_1116,1)));  % CoffeinSimulation|Neighborhoods|Periportal_pls_Periportal_int|Surface area (plasma/interstitial)
P_3244 = (P_2454*(IIf(P_1115,P_1116,1)));  % CoffeinSimulation|Neighborhoods|Periportal_pls_Periportal_bc|Surface area (blood cells/plasma)
P_3245 = ((P_2199+(P_2195*(10^P_1535))+(P_2197*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|Periportal_int_Periportal_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3246 = (P_2455*(IIf(P_1115,P_1116,1)));  % CoffeinSimulation|Neighborhoods|Periportal_int_Periportal_cell|Surface area (interstitial/intracellular)
P_3247 = ((P_2250+(P_2243*(10^P_1535))+(P_2244*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|Pericentral_int_Pericentral_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3248 = (P_2455*(IIf(P_1115,(1-P_1116),0)));  % CoffeinSimulation|Neighborhoods|Pericentral_int_Pericentral_cell|Surface area (interstitial/intracellular)
P_3249 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|Pericentral_pls_Pericentral_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3250 = (P_2453*(IIf(P_1115,(1-P_1116),0)));  % CoffeinSimulation|Neighborhoods|Pericentral_pls_Pericentral_int|Surface area (plasma/interstitial)
P_3251 = (P_2454*(IIf(P_1115,(1-P_1116),0)));  % CoffeinSimulation|Neighborhoods|Pericentral_pls_Pericentral_bc|Surface area (blood cells/plasma)
P_3252 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|Lung_pls_Lung_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3253 = ((P_1185+(P_1180*(10^P_1535))+(P_1182*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|Lung_int_Lung_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3254 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|Muscle_pls_Muscle_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3255 = ((P_1234+(P_1230*(10^P_1535))+(P_1231*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|Muscle_int_Muscle_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3256 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|Pancreas_pls_Pancreas_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3257 = ((P_1269+(P_1264*(10^P_1535))+(P_1266*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|Pancreas_int_Pancreas_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3258 = (P_2465*P_2467*P_2468);  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_cell_K1
P_3259 = ((1-P_2465)*P_2467*P_2468);  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_cell_K2
P_3260 = (P_2465*(1-P_2467)*P_2468);  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_cell_K3
P_3261 = (P_2465*P_2467*(1-P_2468));  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_cell_K4
P_3262 = ((1-P_2465)*(1-P_2467)*P_2468);  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_cell_K5
P_3263 = ((1-P_2465)*P_2467*(1-P_2468));  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_cell_K6
P_3264 = (P_2465*(1-P_2467)*(1-P_2468));  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_cell_K7
P_3265 = ((1-P_2465)*(1-P_2467)*(1-P_2468));  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_cell_K8
P_3266 = (P_2470*P_2466*P_2469);  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_lum_K1
P_3267 = ((1-P_2470)*P_2466*P_2469);  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_lum_K2
P_3268 = (P_2470*(1-P_2466)*P_2469);  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_lum_K3
P_3269 = (P_2470*P_2466*(1-P_2469));  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_lum_K4
P_3270 = ((1-P_2470)*(1-P_2466)*P_2469);  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_lum_K5
P_3271 = ((1-P_2470)*P_2466*(1-P_2469));  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_lum_K6
P_3272 = (P_2470*(1-P_2466)*(1-P_2469));  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_lum_K7
P_3273 = ((1-P_2470)*(1-P_2466)*(1-P_2469));  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|pKa_pH_WS_lum_K8
P_3274 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|Skin_pls_Skin_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3275 = ((P_1324+(P_1316*(10^P_1535))+(P_1319*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|Skin_int_Skin_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3276 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|Spleen_pls_Spleen_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3277 = ((P_1362+(P_1357*(10^P_1535))+(P_1360*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|Spleen_int_Spleen_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3278 = (P_1456*P_2514);  % CoffeinSimulation|Neighborhoods|Saliva_slv_Saliva_slv|Caffeine|Partition coefficient (intracellular/plasma)
P_3279 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|Duodenum_pls_Duodenum_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3280 = ((P_667+(P_659*(10^P_1535))+(P_663*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|Duodenum_int_Duodenum_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3281 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|UpperJejunum_pls_UpperJejunum_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3282 = ((P_703+(P_698*(10^P_1535))+(P_700*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|UpperJejunum_int_UpperJejunum_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3283 = ((P_741+(P_736*(10^P_1535))+(P_738*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|LowerJejunum_int_LowerJejunum_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3284 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|LowerJejunum_pls_LowerJejunum_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3285 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|UpperIleum_pls_UpperIleum_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3286 = ((P_780+(P_773*(10^P_1535))+(P_777*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|UpperIleum_int_UpperIleum_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3287 = ((P_816+(P_812*(10^P_1535))+(P_814*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|LowerIleum_int_LowerIleum_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3288 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|LowerIleum_pls_LowerIleum_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3289 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|Caecum_pls_Caecum_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3290 = ((P_903+(P_896*(10^P_1535))+(P_899*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|Caecum_int_Caecum_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3291 = ((P_939+(P_933*(10^P_1535))+(P_937*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|ColonAscendens_int_ColonAscendens_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3292 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|ColonAscendens_pls_ColonAscendens_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3293 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|ColonTransversum_pls_ColonTransversum_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3294 = ((P_977+(P_971*(10^P_1535))+(P_975*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|ColonTransversum_int_ColonTransversum_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3295 = ((P_1018+(P_1010*(10^P_1535))+(P_1013*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|ColonDescendens_int_ColonDescendens_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3296 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|ColonDescendens_pls_ColonDescendens_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3297 = ((P_1055+(P_1047*(10^P_1535))+(P_1051*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|ColonSigmoid_int_ColonSigmoid_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3298 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|ColonSigmoid_pls_ColonSigmoid_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3299 = ((P_1091+(P_1085*(10^P_1535))+(P_1089*P_2524))*P_2514);  % CoffeinSimulation|Neighborhoods|Rectum_int_Rectum_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3300 = ((P_11+(P_2*((1/P_2514)-P_6)))*P_2514);  % CoffeinSimulation|Neighborhoods|Rectum_pls_Rectum_int|Caffeine|Partition coefficient (interstitial/plasma)
P_3301 = (P_2481*P_2483*P_2482);  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_lum_K1
P_3302 = (P_2478*P_2479*P_2480);  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_cell_K1
P_3303 = ((1-P_2478)*P_2479*P_2480);  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_cell_K2
P_3304 = (P_2478*(1-P_2479)*P_2480);  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_cell_K3
P_3305 = (P_2478*P_2479*(1-P_2480));  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_cell_K4
P_3306 = ((1-P_2478)*(1-P_2479)*P_2480);  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_cell_K5
P_3307 = ((1-P_2478)*P_2479*(1-P_2480));  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_cell_K6
P_3308 = (P_2478*(1-P_2479)*(1-P_2480));  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_cell_K7
P_3309 = ((1-P_2478)*(1-P_2479)*(1-P_2480));  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_cell_K8
P_3310 = ((1-P_2481)*P_2483*P_2482);  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_lum_K2
P_3311 = (P_2481*(1-P_2483)*P_2482);  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_lum_K3
P_3312 = (P_2481*P_2483*(1-P_2482));  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_lum_K4
P_3313 = ((1-P_2481)*(1-P_2483)*P_2482);  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_lum_K5
P_3314 = ((1-P_2481)*P_2483*(1-P_2482));  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_lum_K6
P_3315 = (P_2481*(1-P_2483)*(1-P_2482));  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_lum_K7
P_3316 = ((1-P_2481)*(1-P_2483)*(1-P_2482));  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|pKa_pH_WS_lum_K8
P_3317 = (P_2484*(1-P_2485)*(1-P_2486));  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_cell_K7
P_3318 = (P_2484*P_2485*P_2486);  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_cell_K1
P_3319 = ((1-P_2484)*P_2485*P_2486);  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_cell_K2
P_3320 = (P_2484*(1-P_2485)*P_2486);  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_cell_K3
P_3321 = (P_2484*P_2485*(1-P_2486));  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_cell_K4
P_3322 = ((1-P_2487)*(1-P_2488)*P_2489);  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_lum_K5
P_3323 = ((1-P_2484)*P_2485*(1-P_2486));  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_cell_K6
P_3324 = ((1-P_2484)*(1-P_2485)*(1-P_2486));  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_cell_K8
P_3325 = (P_2487*P_2488*P_2489);  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_lum_K1
P_3326 = ((1-P_2487)*P_2488*P_2489);  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_lum_K2
P_3327 = (P_2487*(1-P_2488)*P_2489);  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_lum_K3
P_3328 = ((1-P_2484)*(1-P_2485)*P_2486);  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_cell_K5
P_3329 = ((1-P_2487)*P_2488*(1-P_2489));  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_lum_K6
P_3330 = (P_2487*P_2488*(1-P_2489));  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_lum_K4
P_3331 = (P_2487*(1-P_2488)*(1-P_2489));  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_lum_K7
P_3332 = ((1-P_2487)*(1-P_2488)*(1-P_2489));  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|pKa_pH_WS_lum_K8
P_3333 = ((1-P_2495)*P_2490*P_2493);  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_lum_K2
P_3334 = (P_2495*(1-P_2490)*P_2493);  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_lum_K3
P_3335 = (P_2495*P_2490*(1-P_2493));  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_lum_K4
P_3336 = ((1-P_2495)*(1-P_2490)*P_2493);  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_lum_K5
P_3337 = ((1-P_2495)*P_2490*(1-P_2493));  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_lum_K6
P_3338 = (P_2495*(1-P_2490)*(1-P_2493));  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_lum_K7
P_3339 = ((1-P_2495)*(1-P_2490)*(1-P_2493));  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_lum_K8
P_3340 = (P_2495*P_2490*P_2493);  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_lum_K1
P_3341 = (P_2492*P_2491*P_2494);  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_cell_K1
P_3342 = ((1-P_2492)*P_2491*P_2494);  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_cell_K2
P_3343 = (P_2492*(1-P_2491)*P_2494);  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_cell_K3
P_3344 = (P_2492*P_2491*(1-P_2494));  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_cell_K4
P_3345 = ((1-P_2492)*(1-P_2491)*P_2494);  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_cell_K5
P_3346 = ((1-P_2492)*P_2491*(1-P_2494));  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_cell_K6
P_3347 = (P_2492*(1-P_2491)*(1-P_2494));  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_cell_K7
P_3348 = ((1-P_2492)*(1-P_2491)*(1-P_2494));  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|pKa_pH_WS_cell_K8
P_3349 = ((1-P_2499)*P_2500*P_2501);  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_lum_K2
P_3350 = (P_2496*P_2497*P_2498);  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_cell_K1
P_3351 = ((1-P_2496)*P_2497*P_2498);  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_cell_K2
P_3352 = (P_2496*(1-P_2497)*P_2498);  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_cell_K3
P_3353 = (P_2496*P_2497*(1-P_2498));  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_cell_K4
P_3354 = ((1-P_2496)*(1-P_2497)*P_2498);  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_cell_K5
P_3355 = ((1-P_2496)*P_2497*(1-P_2498));  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_cell_K6
P_3356 = (P_2496*(1-P_2497)*(1-P_2498));  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_cell_K7
P_3357 = ((1-P_2496)*(1-P_2497)*(1-P_2498));  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_cell_K8
P_3358 = (P_2499*P_2500*P_2501);  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_lum_K1
P_3359 = (P_2499*(1-P_2500)*P_2501);  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_lum_K3
P_3360 = (P_2499*P_2500*(1-P_2501));  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_lum_K4
P_3361 = ((1-P_2499)*(1-P_2500)*P_2501);  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_lum_K5
P_3362 = ((1-P_2499)*P_2500*(1-P_2501));  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_lum_K6
P_3363 = (P_2499*(1-P_2500)*(1-P_2501));  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_lum_K7
P_3364 = ((1-P_2499)*(1-P_2500)*(1-P_2501));  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|pKa_pH_WS_lum_K8
P_3365 = (P_2503*P_2505*P_2504);  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_lum_K1
P_3366 = (P_2507*P_2506*P_2502);  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_cell_K1
P_3367 = ((1-P_2507)*P_2506*P_2502);  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_cell_K2
P_3368 = (P_2507*(1-P_2506)*P_2502);  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_cell_K3
P_3369 = (P_2507*P_2506*(1-P_2502));  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_cell_K4
P_3370 = ((1-P_2507)*(1-P_2506)*P_2502);  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_cell_K5
P_3371 = ((1-P_2507)*P_2506*(1-P_2502));  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_cell_K6
P_3372 = (P_2507*(1-P_2506)*(1-P_2502));  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_cell_K7
P_3373 = ((1-P_2507)*(1-P_2506)*(1-P_2502));  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_cell_K8
P_3374 = ((1-P_2503)*P_2505*P_2504);  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_lum_K2
P_3375 = (P_2503*(1-P_2505)*P_2504);  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_lum_K3
P_3376 = (P_2503*P_2505*(1-P_2504));  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_lum_K4
P_3377 = ((1-P_2503)*(1-P_2505)*P_2504);  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_lum_K5
P_3378 = ((1-P_2503)*P_2505*(1-P_2504));  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_lum_K6
P_3379 = (P_2503*(1-P_2505)*(1-P_2504));  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_lum_K7
P_3380 = ((1-P_2503)*(1-P_2505)*(1-P_2504));  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|pKa_pH_WS_lum_K8
P_3381 = (P_2512*P_2513*P_2508);  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_lum_K1
P_3382 = (P_2512*(1-P_2513)*P_2508);  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_lum_K3
P_3383 = (P_2512*P_2513*(1-P_2508));  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_lum_K4
P_3384 = ((1-P_2512)*(1-P_2513)*P_2508);  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_lum_K5
P_3385 = ((1-P_2512)*P_2513*(1-P_2508));  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_lum_K6
P_3386 = (P_2512*(1-P_2513)*(1-P_2508));  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_lum_K7
P_3387 = ((1-P_2512)*(1-P_2513)*(1-P_2508));  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_lum_K8
P_3388 = ((1-P_2512)*P_2513*P_2508);  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_lum_K2
P_3389 = (P_2510*P_2509*P_2511);  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_cell_K1
P_3390 = ((1-P_2510)*P_2509*P_2511);  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_cell_K2
P_3391 = (P_2510*(1-P_2509)*P_2511);  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_cell_K3
P_3392 = (P_2510*P_2509*(1-P_2511));  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_cell_K4
P_3393 = ((1-P_2510)*(1-P_2509)*P_2511);  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_cell_K5
P_3394 = ((1-P_2510)*P_2509*(1-P_2511));  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_cell_K6
P_3395 = (P_2510*(1-P_2509)*(1-P_2511));  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_cell_K7
P_3396 = ((1-P_2510)*(1-P_2509)*(1-P_2511));  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|pKa_pH_WS_cell_K8
P_3397 = ((P_10+(P_3*(10^P_1535))+(P_8*P_2524))*P_2514);  % CoffeinSimulation|Caffeine|Partition coefficient (blood cells/plasma)
P_3398 = (((P_10+(P_3*(10^P_1535))+(P_8*P_2524))*P_2514*P_42)+(1-P_42));  % CoffeinSimulation|Caffeine|Blood/Plasma concentration ratio
P_3399 = (IIf((P_2523 == 2),(IIf((P_1516 ~= P_1524),(max(P_1533,P_1534)),(IIf((P_1517 ~= P_1524),(max(P_1532,P_1534)),(max(P_1532,P_1533)))))),0));  % CoffeinSimulation|Caffeine|pKa_TwoAcids_1
P_3400 = (IIf((P_2517 == 2),(IIf((P_1516 ~= P_1520),(min(P_1533,P_1534)),(IIf((P_1517 ~= P_1520),(min(P_1532,P_1534)),(min(P_1532,P_1533)))))),0));  % CoffeinSimulation|Caffeine|pKa_TwoBases_0
P_3401 = (IIf((P_2517 == 2),(IIf((P_1516 ~= P_1520),(max(P_1533,P_1534)),(IIf((P_1517 ~= P_1520),(max(P_1532,P_1534)),(max(P_1532,P_1533)))))),0));  % CoffeinSimulation|Caffeine|pKa_TwoBases_1
P_3402 = (IIf(((P_2523 == 1) & (P_2517 == 2)),1,0));  % CoffeinSimulation|Caffeine|Is diprotic base monoprotic acid
P_3403 = (IIf(P_1530,(((P_2515*1000000000)^(-4.5))*(10^P_1535)*1596),0));  % CoffeinSimulation|Caffeine|Calculated specific intestinal permeability (transcellular)
P_3404 = (IIf(((P_2523 == 2) & (P_2517 == 0)),1,0));  % CoffeinSimulation|Caffeine|Is diprotic acid
P_3405 = (IIf((P_2523 == 2),(IIf((P_1516 ~= P_1524),(min(P_1533,P_1534)),(IIf((P_1517 ~= P_1524),(min(P_1532,P_1534)),(min(P_1532,P_1533)))))),0));  % CoffeinSimulation|Caffeine|pKa_TwoAcids_0
P_3406 = (P_2518*P_2520*P_2519);  % CoffeinSimulation|Caffeine|pKa_pH_WS_sol_K1
P_3407 = (IIf(((P_2523 == 0) & (P_2517 == 2)),1,0));  % CoffeinSimulation|Caffeine|Is diprotic base
P_3408 = (IIf((P_2523 == 1),(IIf((P_1516 == P_1524),P_1532,(IIf((P_1517 == P_1524),P_1533,P_1534)))),0));  % CoffeinSimulation|Caffeine|pKa_OneAcid_0
P_3409 = (IIf((P_2517 == 1),(IIf((P_1516 == P_1520),P_1532,(IIf((P_1517 == P_1520),P_1533,P_1534)))),0));  % CoffeinSimulation|Caffeine|pKa_OneBase_0
P_3410 = ((1-P_2518)*P_2520*P_2519);  % CoffeinSimulation|Caffeine|pKa_pH_WS_sol_K2
P_3411 = (P_2518*(1-P_2520)*P_2519);  % CoffeinSimulation|Caffeine|pKa_pH_WS_sol_K3
P_3412 = (P_2518*P_2520*(1-P_2519));  % CoffeinSimulation|Caffeine|pKa_pH_WS_sol_K4
P_3413 = ((1-P_2518)*(1-P_2520)*P_2519);  % CoffeinSimulation|Caffeine|pKa_pH_WS_sol_K5
P_3414 = ((1-P_2518)*P_2520*(1-P_2519));  % CoffeinSimulation|Caffeine|pKa_pH_WS_sol_K6
P_3415 = (P_2518*(1-P_2520)*(1-P_2519));  % CoffeinSimulation|Caffeine|pKa_pH_WS_sol_K7
P_3416 = ((1-P_2518)*(1-P_2520)*(1-P_2519));  % CoffeinSimulation|Caffeine|pKa_pH_WS_sol_K8
P_3417 = (IIf(((P_2523 == 1) & (P_2517 == 0)),1,0));  % CoffeinSimulation|Caffeine|Is monoprotic acid
P_3418 = (IIf(((P_2523 == 0) & (P_2517 == 1)),1,0));  % CoffeinSimulation|Caffeine|Is monoprotic base
P_3419 = (IIf(((P_2523 == 2) & (P_2517 == 1)),1,0));  % CoffeinSimulation|Caffeine|Is monoprotic base diprotic acid
P_3420 = (IIf(((P_2523 == 1) & (P_2517 == 1)),1,0));  % CoffeinSimulation|Caffeine|Is monoprotic base monoprotic acid
P_3421 = (IIf(((P_2523 == 3) & (P_2517 == 0)),1,0));  % CoffeinSimulation|Caffeine|Is triprotic acid
P_3422 = (IIf(((P_2523 == 0) & (P_2517 == 3)),1,0));  % CoffeinSimulation|Caffeine|Is triprotic base
P_3423 = (IIf(P_1530,(((P_2515*2976190.476190476)^(-6))*(10^P_1535)*2e-06),0));  % CoffeinSimulation|Caffeine|Permeability
P_3424 = (IIf(P_1530,(((P_2515*1000000000)^(-4.5))*(10^P_1535)*1596),0));  % CoffeinSimulation|Caffeine|Specific intestinal permeability (transcellular)
P_3425 = (IIf((P_2535 == 2),(IIf((P_1568 ~= P_1576),(max(P_1585,P_1586)),(IIf((P_1569 ~= P_1576),(max(P_1584,P_1586)),(max(P_1584,P_1585)))))),0));  % CoffeinSimulation|CYP1A2|pKa_TwoAcids_1
P_3426 = (IIf((P_2529 == 2),(IIf((P_1568 ~= P_1572),(min(P_1585,P_1586)),(IIf((P_1569 ~= P_1572),(min(P_1584,P_1586)),(min(P_1584,P_1585)))))),0));  % CoffeinSimulation|CYP1A2|pKa_TwoBases_0
P_3427 = (IIf((P_2529 == 2),(IIf((P_1568 ~= P_1572),(max(P_1585,P_1586)),(IIf((P_1569 ~= P_1572),(max(P_1584,P_1586)),(max(P_1584,P_1585)))))),0));  % CoffeinSimulation|CYP1A2|pKa_TwoBases_1
P_3428 = (IIf(((P_2535 == 1) & (P_2529 == 2)),1,0));  % CoffeinSimulation|CYP1A2|Is diprotic base monoprotic acid
P_3429 = (IIf(P_1582,(((P_2527*1000000000)^(-4.5))*(10^P_1587)*1596),0));  % CoffeinSimulation|CYP1A2|Calculated specific intestinal permeability (transcellular)
P_3430 = (IIf(((P_2535 == 2) & (P_2529 == 0)),1,0));  % CoffeinSimulation|CYP1A2|Is diprotic acid
P_3431 = (IIf((P_2535 == 2),(IIf((P_1568 ~= P_1576),(min(P_1585,P_1586)),(IIf((P_1569 ~= P_1576),(min(P_1584,P_1586)),(min(P_1584,P_1585)))))),0));  % CoffeinSimulation|CYP1A2|pKa_TwoAcids_0
P_3432 = (P_2530*P_2532*P_2531);  % CoffeinSimulation|CYP1A2|pKa_pH_WS_sol_K1
P_3433 = (IIf(((P_2535 == 0) & (P_2529 == 2)),1,0));  % CoffeinSimulation|CYP1A2|Is diprotic base
P_3434 = (IIf((P_2535 == 1),(IIf((P_1568 == P_1576),P_1584,(IIf((P_1569 == P_1576),P_1585,P_1586)))),0));  % CoffeinSimulation|CYP1A2|pKa_OneAcid_0
P_3435 = (IIf((P_2529 == 1),(IIf((P_1568 == P_1572),P_1584,(IIf((P_1569 == P_1572),P_1585,P_1586)))),0));  % CoffeinSimulation|CYP1A2|pKa_OneBase_0
P_3436 = ((1-P_2530)*P_2532*P_2531);  % CoffeinSimulation|CYP1A2|pKa_pH_WS_sol_K2
P_3437 = (P_2530*(1-P_2532)*P_2531);  % CoffeinSimulation|CYP1A2|pKa_pH_WS_sol_K3
P_3438 = (P_2530*P_2532*(1-P_2531));  % CoffeinSimulation|CYP1A2|pKa_pH_WS_sol_K4
P_3439 = ((1-P_2530)*(1-P_2532)*P_2531);  % CoffeinSimulation|CYP1A2|pKa_pH_WS_sol_K5
P_3440 = ((1-P_2530)*P_2532*(1-P_2531));  % CoffeinSimulation|CYP1A2|pKa_pH_WS_sol_K6
P_3441 = (P_2530*(1-P_2532)*(1-P_2531));  % CoffeinSimulation|CYP1A2|pKa_pH_WS_sol_K7
P_3442 = ((1-P_2530)*(1-P_2532)*(1-P_2531));  % CoffeinSimulation|CYP1A2|pKa_pH_WS_sol_K8
P_3443 = (IIf(((P_2535 == 1) & (P_2529 == 0)),1,0));  % CoffeinSimulation|CYP1A2|Is monoprotic acid
P_3444 = (IIf(((P_2535 == 0) & (P_2529 == 1)),1,0));  % CoffeinSimulation|CYP1A2|Is monoprotic base
P_3445 = (IIf(((P_2535 == 2) & (P_2529 == 1)),1,0));  % CoffeinSimulation|CYP1A2|Is monoprotic base diprotic acid
P_3446 = (IIf(((P_2535 == 1) & (P_2529 == 1)),1,0));  % CoffeinSimulation|CYP1A2|Is monoprotic base monoprotic acid
P_3447 = (IIf(((P_2535 == 3) & (P_2529 == 0)),1,0));  % CoffeinSimulation|CYP1A2|Is triprotic acid
P_3448 = (IIf(((P_2535 == 0) & (P_2529 == 3)),1,0));  % CoffeinSimulation|CYP1A2|Is triprotic base
P_3449 = (IIf(P_1582,(((P_2527*2976190.476190476)^(-6))*(10^P_1587)*2e-06),0));  % CoffeinSimulation|CYP1A2|Permeability
P_3450 = (IIf(P_1582,(((P_2527*1000000000)^(-4.5))*(10^P_1587)*1596),0));  % CoffeinSimulation|CYP1A2|Specific intestinal permeability (transcellular)
P_3451 = (IIf((P_2547 == 2),(IIf((P_1606 ~= P_1614),(max(P_1623,P_1624)),(IIf((P_1607 ~= P_1614),(max(P_1622,P_1624)),(max(P_1622,P_1623)))))),0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_TwoAcids_1
P_3452 = (IIf((P_2541 == 2),(IIf((P_1606 ~= P_1610),(min(P_1623,P_1624)),(IIf((P_1607 ~= P_1610),(min(P_1622,P_1624)),(min(P_1622,P_1623)))))),0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_TwoBases_0
P_3453 = (IIf((P_2541 == 2),(IIf((P_1606 ~= P_1610),(max(P_1623,P_1624)),(IIf((P_1607 ~= P_1610),(max(P_1622,P_1624)),(max(P_1622,P_1623)))))),0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_TwoBases_1
P_3454 = (IIf(((P_2547 == 1) & (P_2541 == 2)),1,0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Is diprotic base monoprotic acid
P_3455 = (IIf(P_1620,(((P_2539*1000000000)^(-4.5))*(10^P_1625)*1596),0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Calculated specific intestinal permeability (transcellular)
P_3456 = (IIf(((P_2547 == 2) & (P_2541 == 0)),1,0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Is diprotic acid
P_3457 = (IIf((P_2547 == 2),(IIf((P_1606 ~= P_1614),(min(P_1623,P_1624)),(IIf((P_1607 ~= P_1614),(min(P_1622,P_1624)),(min(P_1622,P_1623)))))),0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_TwoAcids_0
P_3458 = (P_2542*P_2544*P_2543);  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_pH_WS_sol_K1
P_3459 = (IIf(((P_2547 == 0) & (P_2541 == 2)),1,0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Is diprotic base
P_3460 = (IIf((P_2547 == 1),(IIf((P_1606 == P_1614),P_1622,(IIf((P_1607 == P_1614),P_1623,P_1624)))),0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_OneAcid_0
P_3461 = (IIf((P_2541 == 1),(IIf((P_1606 == P_1610),P_1622,(IIf((P_1607 == P_1610),P_1623,P_1624)))),0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_OneBase_0
P_3462 = ((1-P_2542)*P_2544*P_2543);  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_pH_WS_sol_K2
P_3463 = (P_2542*(1-P_2544)*P_2543);  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_pH_WS_sol_K3
P_3464 = (P_2542*P_2544*(1-P_2543));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_pH_WS_sol_K4
P_3465 = ((1-P_2542)*(1-P_2544)*P_2543);  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_pH_WS_sol_K5
P_3466 = ((1-P_2542)*P_2544*(1-P_2543));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_pH_WS_sol_K6
P_3467 = (P_2542*(1-P_2544)*(1-P_2543));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_pH_WS_sol_K7
P_3468 = ((1-P_2542)*(1-P_2544)*(1-P_2543));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_pH_WS_sol_K8
P_3469 = (IIf(((P_2547 == 1) & (P_2541 == 0)),1,0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Is monoprotic acid
P_3470 = (IIf(((P_2547 == 0) & (P_2541 == 1)),1,0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Is monoprotic base
P_3471 = (IIf(((P_2547 == 2) & (P_2541 == 1)),1,0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Is monoprotic base diprotic acid
P_3472 = (IIf(((P_2547 == 1) & (P_2541 == 1)),1,0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Is monoprotic base monoprotic acid
P_3473 = (IIf(((P_2547 == 3) & (P_2541 == 0)),1,0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Is triprotic acid
P_3474 = (IIf(((P_2547 == 0) & (P_2541 == 3)),1,0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Is triprotic base
P_3475 = (IIf(P_1620,(((P_2539*2976190.476190476)^(-6))*(10^P_1625)*2e-06),0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Permeability
P_3476 = (IIf(P_1620,(((P_2539*1000000000)^(-4.5))*(10^P_1625)*1596),0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Specific intestinal permeability (transcellular)
P_3477 = (P_1683+P_1704+P_1725+P_1746+P_1767+P_1788+P_1951+P_1972+P_2070+P_3012+P_3027+P_2286+P_2307+P_2328+P_2362+P_2383);  % CoffeinSimulation|Organism|Weight of tissue organs
P_3478 = (P_2555*P_1553*P_1659*P_2553);  % CoffeinSimulation|Organism|VenousBlood|Plasma|CYP1A2|Start amount
P_3479 = (P_2562*P_1553*P_1665*P_2560);  % CoffeinSimulation|Organism|VenousBlood|BloodCells|CYP1A2|Start amount
P_3480 = (P_3397/P_2514);  % CoffeinSimulation|Organism|VenousBlood|BloodCells|Caffeine|Partition coefficient (water/container)
P_3481 = (P_2568*P_1553*P_1672*P_2566);  % CoffeinSimulation|Organism|ArterialBlood|Plasma|CYP1A2|Start amount
P_3482 = (P_2575*P_1553*P_1678*P_2573);  % CoffeinSimulation|Organism|ArterialBlood|BloodCells|CYP1A2|Start amount
P_3483 = (P_3397/P_2514);  % CoffeinSimulation|Organism|ArterialBlood|BloodCells|Caffeine|Partition coefficient (water/container)
P_3484 = (P_68*P_2579*(1-P_42));  % CoffeinSimulation|Organism|Bone|Lymph flow rate
P_3485 = (P_2583*P_1553*P_1688*P_2581);  % CoffeinSimulation|Organism|Bone|Plasma|CYP1A2|Start amount
P_3486 = (P_2590*P_1553*P_1694*P_2588);  % CoffeinSimulation|Organism|Bone|BloodCells|CYP1A2|Start amount
P_3487 = (P_3397/P_2514);  % CoffeinSimulation|Organism|Bone|BloodCells|Caffeine|Partition coefficient (water/container)
P_3488 = P_2598;  % CoffeinSimulation|Organism|Bone|Intracellular|CYP1A2
P_3489 = (IIf((P_2596 > 0),(y(15)/P_2596),0));  % CoffeinSimulation|Organism|Bone|Intracellular|Caffeine|Concentration
P_3490 = (IIf((P_2596 > 0),(y(16)/P_2596),0));  % CoffeinSimulation|Organism|Bone|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_3491 = (P_111*P_2601*(1-P_42));  % CoffeinSimulation|Organism|Brain|Lymph flow rate
P_3492 = (P_2604*P_1553*P_1710*P_2602);  % CoffeinSimulation|Organism|Brain|Plasma|CYP1A2|Start amount
P_3493 = (P_2611*P_1553*P_1715*P_2609);  % CoffeinSimulation|Organism|Brain|BloodCells|CYP1A2|Start amount
P_3494 = (P_3397/P_2514);  % CoffeinSimulation|Organism|Brain|BloodCells|Caffeine|Partition coefficient (water/container)
P_3495 = P_2619;  % CoffeinSimulation|Organism|Brain|Intracellular|CYP1A2
P_3496 = (IIf((P_2617 > 0),(y(22)/P_2617),0));  % CoffeinSimulation|Organism|Brain|Intracellular|Caffeine|Concentration
P_3497 = (IIf((P_2617 > 0),(y(23)/P_2617),0));  % CoffeinSimulation|Organism|Brain|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_3498 = (P_152*P_2622*(1-P_42));  % CoffeinSimulation|Organism|Fat|Lymph flow rate
P_3499 = (P_2625*P_1553*P_1730*P_2623);  % CoffeinSimulation|Organism|Fat|Plasma|CYP1A2|Start amount
P_3500 = (P_2632*P_1553*P_1737*P_2630);  % CoffeinSimulation|Organism|Fat|BloodCells|CYP1A2|Start amount
P_3501 = (P_3397/P_2514);  % CoffeinSimulation|Organism|Fat|BloodCells|Caffeine|Partition coefficient (water/container)
P_3502 = P_2640;  % CoffeinSimulation|Organism|Fat|Intracellular|CYP1A2
P_3503 = (IIf((P_2638 > 0),(y(29)/P_2638),0));  % CoffeinSimulation|Organism|Fat|Intracellular|Caffeine|Concentration
P_3504 = (IIf((P_2638 > 0),(y(30)/P_2638),0));  % CoffeinSimulation|Organism|Fat|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_3505 = (P_196*P_2643*(1-P_42));  % CoffeinSimulation|Organism|Gonads|Lymph flow rate
P_3506 = (P_2646*P_1553*P_1752*P_2644);  % CoffeinSimulation|Organism|Gonads|Plasma|CYP1A2|Start amount
P_3507 = (P_2653*P_1553*P_1757*P_2651);  % CoffeinSimulation|Organism|Gonads|BloodCells|CYP1A2|Start amount
P_3508 = (P_3397/P_2514);  % CoffeinSimulation|Organism|Gonads|BloodCells|Caffeine|Partition coefficient (water/container)
P_3509 = P_2661;  % CoffeinSimulation|Organism|Gonads|Intracellular|CYP1A2
P_3510 = (IIf((P_2659 > 0),(y(36)/P_2659),0));  % CoffeinSimulation|Organism|Gonads|Intracellular|Caffeine|Concentration
P_3511 = (IIf((P_2659 > 0),(y(37)/P_2659),0));  % CoffeinSimulation|Organism|Gonads|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_3512 = (P_239*P_2664*(1-P_42));  % CoffeinSimulation|Organism|Heart|Lymph flow rate
P_3513 = (P_2667*P_1553*P_1773*P_2665);  % CoffeinSimulation|Organism|Heart|Plasma|CYP1A2|Start amount
P_3514 = (P_2674*P_1553*P_1779*P_2672);  % CoffeinSimulation|Organism|Heart|BloodCells|CYP1A2|Start amount
P_3515 = (P_3397/P_2514);  % CoffeinSimulation|Organism|Heart|BloodCells|Caffeine|Partition coefficient (water/container)
P_3516 = P_2682;  % CoffeinSimulation|Organism|Heart|Intracellular|CYP1A2
P_3517 = (IIf((P_2680 > 0),(y(43)/P_2680),0));  % CoffeinSimulation|Organism|Heart|Intracellular|Caffeine|Concentration
P_3518 = (IIf((P_2680 > 0),(y(44)/P_2680),0));  % CoffeinSimulation|Organism|Heart|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_3519 = (P_281*P_2686*(1-P_42));  % CoffeinSimulation|Organism|Kidney|Lymph flow rate
P_3520 = (P_2685*P_1788);  % CoffeinSimulation|Organism|Kidney|GFR
P_3521 = (P_2689*P_1553*P_1794*P_2687);  % CoffeinSimulation|Organism|Kidney|Plasma|CYP1A2|Start amount
P_3522 = (P_2696*P_1553*P_1800*P_2694);  % CoffeinSimulation|Organism|Kidney|BloodCells|CYP1A2|Start amount
P_3523 = (P_3397/P_2514);  % CoffeinSimulation|Organism|Kidney|BloodCells|Caffeine|Partition coefficient (water/container)
P_3524 = P_2704;  % CoffeinSimulation|Organism|Kidney|Intracellular|CYP1A2
P_3525 = (IIf((P_2702 > 0),(y(50)/P_2702),0));  % CoffeinSimulation|Organism|Kidney|Intracellular|Caffeine|Concentration
P_3526 = (IIf((P_2702 > 0),(y(51)/P_2702),0));  % CoffeinSimulation|Organism|Kidney|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_3527 = (y(53)/P_1812);  % CoffeinSimulation|Organism|Lumen|Stomach|Fraction of geometric volume filled with liquid
P_3528 = (P_1814*P_1553*P_1816*P_2708);  % CoffeinSimulation|Organism|Lumen|Stomach|CYP1A2|Start amount
P_3529 = (P_2713*(1-P_2712)*P_2711);  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine|pKa_pH_WS_lum_K3
P_3530 = ((1-P_2713)*(1-P_2712)*(1-P_2711));  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine|pKa_pH_WS_lum_K8
P_3531 = (P_2713*(1-P_2712)*(1-P_2711));  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine|pKa_pH_WS_lum_K7
P_3532 = ((1-P_2713)*P_2712*(1-P_2711));  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine|pKa_pH_WS_lum_K6
P_3533 = (P_2713*P_2712*(1-P_2711));  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine|pKa_pH_WS_lum_K4
P_3534 = ((1-P_2713)*P_2712*P_2711);  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine|pKa_pH_WS_lum_K2
P_3535 = (P_2713*P_2712*P_2711);  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine|pKa_pH_WS_lum_K1
P_3536 = ((1-P_2713)*(1-P_2712)*P_2711);  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine|pKa_pH_WS_lum_K5
P_3537 = (0.02894*P_2717);  % CoffeinSimulation|Organism|Lumen|Duodenum|Secretion of liquid
P_3538 = P_2717;  % CoffeinSimulation|Organism|Lumen|Duodenum|Volume of protein container
P_3539 = (P_2718*P_366*P_334);  % CoffeinSimulation|Organism|Lumen|Duodenum|Effective surface area
P_3540 = (IIf((P_2717 > 0),(y(57)/P_2717),0));  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine|Concentration
P_3541 = (P_2720+(P_2721/(P_1539^(P_1516^2)))+(P_2722/(P_1539^(P_1517^2)))+(P_2723/(P_1539^(P_1518^2)))+(P_2724/(P_1539^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_2725/(P_1539^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_2726/(P_1539^(max((P_1517+P_1518),(0-(P_1517+P_1518))))))+(P_2727/(P_1539^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518)))))));  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine|Solubility_pKa_pH_Factor
P_3542 = (IIf((P_2717 > 0),(y(59)/P_2717),0));  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine-CYP1A2 Metabolite|Concentration
P_3543 = (0.0031572*P_2729);  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Secretion of liquid
P_3544 = P_2729;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Volume of protein container
P_3545 = (P_2731*P_385*P_334);  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Effective surface area
P_3546 = (IIf((P_2729 > 0),(y(61)/P_2729),0));  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine|Concentration
P_3547 = (P_2739+(P_2738/(P_1539^(P_1516^2)))+(P_2737/(P_1539^(P_1517^2)))+(P_2736/(P_1539^(P_1518^2)))+(P_2735/(P_1539^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_2734/(P_1539^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_2733/(P_1539^(max((P_1517+P_1518),(0-(P_1517+P_1518))))))+(P_2740/(P_1539^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518)))))));  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine|Solubility_pKa_pH_Factor
P_3548 = (IIf((P_2729 > 0),(y(63)/P_2729),0));  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine-CYP1A2 Metabolite|Concentration
P_3549 = (0.0025102*P_2742);  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Secretion of liquid
P_3550 = P_2742;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Volume of protein container
P_3551 = (P_2743*P_404*P_334);  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Effective surface area
P_3552 = (IIf((P_2742 > 0),(y(65)/P_2742),0));  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine|Concentration
P_3553 = (P_2746+(P_2747/(P_1539^(P_1516^2)))+(P_2748/(P_1539^(P_1517^2)))+(P_2749/(P_1539^(P_1518^2)))+(P_2750/(P_1539^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_2751/(P_1539^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_2753/(P_1539^(max((P_1517+P_1518),(0-(P_1517+P_1518))))))+(P_2752/(P_1539^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518)))))));  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine|Solubility_pKa_pH_Factor
P_3554 = (IIf((P_2742 > 0),(y(67)/P_2742),0));  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine-CYP1A2 Metabolite|Concentration
P_3555 = (P_2755*P_423*P_334);  % CoffeinSimulation|Organism|Lumen|UpperIleum|Effective surface area
P_3556 = (0.0029585*P_2757);  % CoffeinSimulation|Organism|Lumen|UpperIleum|Secretion of liquid
P_3557 = P_2757;  % CoffeinSimulation|Organism|Lumen|UpperIleum|Volume of protein container
P_3558 = (IIf((P_2757 > 0),(y(69)/P_2757),0));  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine|Concentration
P_3559 = (P_2759+(P_2760/(P_1539^(P_1516^2)))+(P_2766/(P_1539^(P_1517^2)))+(P_2765/(P_1539^(P_1518^2)))+(P_2764/(P_1539^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_2763/(P_1539^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_2762/(P_1539^(max((P_1517+P_1518),(0-(P_1517+P_1518))))))+(P_2761/(P_1539^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518)))))));  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine|Solubility_pKa_pH_Factor
P_3560 = (IIf((P_2757 > 0),(y(71)/P_2757),0));  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine-CYP1A2 Metabolite|Concentration
P_3561 = P_2768;  % CoffeinSimulation|Organism|Lumen|LowerIleum|Volume of protein container
P_3562 = (P_2769*P_442*P_334);  % CoffeinSimulation|Organism|Lumen|LowerIleum|Effective surface area
P_3563 = (0.0017657*P_2768);  % CoffeinSimulation|Organism|Lumen|LowerIleum|Secretion of liquid
P_3564 = (IIf((P_2768 > 0),(y(73)/P_2768),0));  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine|Concentration
P_3565 = (P_2772+(P_2773/(P_1539^(P_1516^2)))+(P_2774/(P_1539^(P_1517^2)))+(P_2775/(P_1539^(P_1518^2)))+(P_2776/(P_1539^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_2777/(P_1539^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_2778/(P_1539^(max((P_1517+P_1518),(0-(P_1517+P_1518))))))+(P_2779/(P_1539^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518)))))));  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine|Solubility_pKa_pH_Factor
P_3566 = (IIf((P_2768 > 0),(y(75)/P_2768),0));  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine-CYP1A2 Metabolite|Concentration
P_3567 = P_2783;  % CoffeinSimulation|Organism|Lumen|Caecum|Volume of protein container
P_3568 = (P_2782*P_461*P_334);  % CoffeinSimulation|Organism|Lumen|Caecum|Effective surface area
P_3569 = 0;  % CoffeinSimulation|Organism|Lumen|Caecum|Secretion of liquid
P_3570 = (IIf((P_2783 > 0),(y(77)/P_2783),0));  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine|Concentration
P_3571 = (P_2786+(P_2787/(P_1539^(P_1516^2)))+(P_2788/(P_1539^(P_1517^2)))+(P_2789/(P_1539^(P_1518^2)))+(P_2792/(P_1539^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_2790/(P_1539^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_2785/(P_1539^(max((P_1517+P_1518),(0-(P_1517+P_1518))))))+(P_2791/(P_1539^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518)))))));  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine|Solubility_pKa_pH_Factor
P_3572 = (IIf((P_2783 > 0),(y(79)/P_2783),0));  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine-CYP1A2 Metabolite|Concentration
P_3573 = P_2795;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Volume of protein container
P_3574 = (P_2794*P_480*P_334);  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Effective surface area
P_3575 = (0.00098426*P_2795);  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Secretion of liquid
P_3576 = (IIf((P_2795 > 0),(y(81)/P_2795),0));  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine|Concentration
P_3577 = (P_2803+(P_2805/(P_1539^(P_1516^2)))+(P_2804/(P_1539^(P_1517^2)))+(P_2798/(P_1539^(P_1518^2)))+(P_2799/(P_1539^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_2800/(P_1539^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_2801/(P_1539^(max((P_1517+P_1518),(0-(P_1517+P_1518))))))+(P_2802/(P_1539^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518)))))));  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine|Solubility_pKa_pH_Factor
P_3578 = (IIf((P_2795 > 0),(y(83)/P_2795),0));  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine-CYP1A2 Metabolite|Concentration
P_3579 = (P_2807*P_499*P_334);  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Effective surface area
P_3580 = (0.00020285*P_2809);  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Secretion of liquid
P_3581 = P_2809;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Volume of protein container
P_3582 = (IIf((P_2809 > 0),(y(85)/P_2809),0));  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine|Concentration
P_3583 = (P_2817+(P_2818/(P_1539^(P_1516^2)))+(P_2814/(P_1539^(P_1517^2)))+(P_2816/(P_1539^(P_1518^2)))+(P_2815/(P_1539^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_2811/(P_1539^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_2812/(P_1539^(max((P_1517+P_1518),(0-(P_1517+P_1518))))))+(P_2813/(P_1539^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518)))))));  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine|Solubility_pKa_pH_Factor
P_3584 = (IIf((P_2809 > 0),(y(87)/P_2809),0));  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine-CYP1A2 Metabolite|Concentration
P_3585 = (P_2820*P_518*P_334);  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Effective surface area
P_3586 = (0.00023004*P_2822);  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Secretion of liquid
P_3587 = P_2822;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Volume of protein container
P_3588 = (IIf((P_2822 > 0),(y(89)/P_2822),0));  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine|Concentration
P_3589 = (P_2824+(P_2825/(P_1539^(P_1516^2)))+(P_2826/(P_1539^(P_1517^2)))+(P_2827/(P_1539^(P_1518^2)))+(P_2828/(P_1539^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_2829/(P_1539^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_2830/(P_1539^(max((P_1517+P_1518),(0-(P_1517+P_1518))))))+(P_2831/(P_1539^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518)))))));  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine|Solubility_pKa_pH_Factor
P_3590 = (IIf((P_2822 > 0),(y(91)/P_2822),0));  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine-CYP1A2 Metabolite|Concentration
P_3591 = (0.00013099*P_2833);  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Secretion of liquid
P_3592 = (P_2834*P_537*P_334);  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Effective surface area
P_3593 = P_2833;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Volume of protein container
P_3594 = (IIf((P_2833 > 0),(y(93)/P_2833),0));  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine|Concentration
P_3595 = (P_2837+(P_2838/(P_1539^(P_1516^2)))+(P_2839/(P_1539^(P_1517^2)))+(P_2840/(P_1539^(P_1518^2)))+(P_2841/(P_1539^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_2842/(P_1539^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_2844/(P_1539^(max((P_1517+P_1518),(0-(P_1517+P_1518))))))+(P_2843/(P_1539^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518)))))));  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine|Solubility_pKa_pH_Factor
P_3596 = (IIf((P_2833 > 0),(y(95)/P_2833),0));  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine-CYP1A2 Metabolite|Concentration
P_3597 = (P_2846*P_556*P_334);  % CoffeinSimulation|Organism|Lumen|Rectum|Effective surface area
P_3598 = (0.00071247*P_2847);  % CoffeinSimulation|Organism|Lumen|Rectum|Secretion of liquid
P_3599 = P_2847;  % CoffeinSimulation|Organism|Lumen|Rectum|Volume of protein container
P_3600 = (IIf((P_2847 > 0),(y(97)/P_2847),0));  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine|Concentration
P_3601 = (P_2857+(P_2856/(P_1539^(P_1516^2)))+(P_2855/(P_1539^(P_1517^2)))+(P_2853/(P_1539^(P_1518^2)))+(P_2850/(P_1539^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_2854/(P_1539^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_2852/(P_1539^(max((P_1517+P_1518),(0-(P_1517+P_1518))))))+(P_2851/(P_1539^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518)))))));  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine|Solubility_pKa_pH_Factor
P_3602 = (IIf((P_2847 > 0),(y(99)/P_2847),0));  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine-CYP1A2 Metabolite|Concentration
P_3603 = (P_565*P_2860*(1-P_42));  % CoffeinSimulation|Organism|Stomach|Lymph flow rate
P_3604 = (P_2863*P_1553*P_1956*P_2861);  % CoffeinSimulation|Organism|Stomach|Plasma|CYP1A2|Start amount
P_3605 = (P_2870*P_1553*P_1962*P_2868);  % CoffeinSimulation|Organism|Stomach|BloodCells|CYP1A2|Start amount
P_3606 = (P_3397/P_2514);  % CoffeinSimulation|Organism|Stomach|BloodCells|Caffeine|Partition coefficient (water/container)
P_3607 = P_2878;  % CoffeinSimulation|Organism|Stomach|Intracellular|CYP1A2
P_3608 = (IIf((P_2876 > 0),(y(107)/P_2876),0));  % CoffeinSimulation|Organism|Stomach|Intracellular|Caffeine|Concentration
P_3609 = (IIf((P_2876 > 0),(y(108)/P_2876),0));  % CoffeinSimulation|Organism|Stomach|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_3610 = (P_607*P_2880*(1-P_42));  % CoffeinSimulation|Organism|SmallIntestine|Lymph flow rate (incl. mucosa)
P_3611 = (P_2890+P_2900+P_2910+P_2920+P_2930);  % CoffeinSimulation|Organism|SmallIntestine|Volume (mucosa)
P_3612 = (P_3397/P_2514);  % CoffeinSimulation|Organism|SmallIntestine|BloodCells|Caffeine|Partition coefficient (water/container)
P_3613 = (P_2890*P_651);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Weight (tissue)
P_3614 = (P_2880*P_611*P_652);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Blood flow rate
P_3615 = (P_661*(1-P_42)*P_2890);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Plasma|Volume
P_3616 = (P_661*P_42*P_2890);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|BloodCells|Volume
P_3617 = (P_3397/P_2514);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|BloodCells|Caffeine|Partition coefficient (water/container)
P_3618 = (P_669*P_2890);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Interstitial|Volume
P_3619 = P_2890;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Intracellular|Volume of protein container
P_3620 = (P_1990*P_2890);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Intracellular|Volume
P_3621 = (P_2900*P_689);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Weight (tissue)
P_3622 = (P_2880*P_611*P_690);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Blood flow rate
P_3623 = (P_699*(1-P_42)*P_2900);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Plasma|Volume
P_3624 = (P_699*P_42*P_2900);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|BloodCells|Volume
P_3625 = (P_3397/P_2514);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|BloodCells|Caffeine|Partition coefficient (water/container)
P_3626 = (P_707*P_2900);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Interstitial|Volume
P_3627 = P_2900;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Intracellular|Volume of protein container
P_3628 = (P_2006*P_2900);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Intracellular|Volume
P_3629 = (P_2910*P_727);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Weight (tissue)
P_3630 = (P_2880*P_611*P_728);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Blood flow rate
P_3631 = (P_737*(1-P_42)*P_2910);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Plasma|Volume
P_3632 = (P_737*P_42*P_2910);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|BloodCells|Volume
P_3633 = (P_3397/P_2514);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|BloodCells|Caffeine|Partition coefficient (water/container)
P_3634 = (P_745*P_2910);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Interstitial|Volume
P_3635 = P_2910;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Intracellular|Volume of protein container
P_3636 = (P_2022*P_2910);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Intracellular|Volume
P_3637 = (P_2920*P_765);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Weight (tissue)
P_3638 = (P_2880*P_611*P_767);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Blood flow rate
P_3639 = (P_775*(1-P_42)*P_2920);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Plasma|Volume
P_3640 = (P_775*P_42*P_2920);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|BloodCells|Volume
P_3641 = (P_3397/P_2514);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|BloodCells|Caffeine|Partition coefficient (water/container)
P_3642 = (P_783*P_2920);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Interstitial|Volume
P_3643 = P_2920;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Intracellular|Volume of protein container
P_3644 = (P_2038*P_2920);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Intracellular|Volume
P_3645 = (P_2930*P_803);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Weight (tissue)
P_3646 = (P_2880*P_611*P_804);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Blood flow rate
P_3647 = (P_813*(1-P_42)*P_2930);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Plasma|Volume
P_3648 = (P_813*P_42*P_2930);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|BloodCells|Volume
P_3649 = (P_3397/P_2514);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|BloodCells|Caffeine|Partition coefficient (water/container)
P_3650 = (P_821*P_2930);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Interstitial|Volume
P_3651 = P_2930;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Intracellular|Volume of protein container
P_3652 = (P_2054*P_2930);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Intracellular|Volume
P_3653 = (P_2950+P_2960+P_2970+P_2980+P_2990+P_3000);  % CoffeinSimulation|Organism|LargeIntestine|Volume (mucosa)
P_3654 = (P_844*P_2940*(1-P_42));  % CoffeinSimulation|Organism|LargeIntestine|Lymph flow rate (incl. mucosa)
P_3655 = (P_3397/P_2514);  % CoffeinSimulation|Organism|LargeIntestine|BloodCells|Caffeine|Partition coefficient (water/container)
P_3656 = (P_2950*P_887);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Weight (tissue)
P_3657 = (P_2940*P_846*P_888);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Blood flow rate
P_3658 = (P_897*(1-P_42)*P_2950);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Plasma|Volume
P_3659 = (P_897*P_42*P_2950);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|BloodCells|Volume
P_3660 = (P_3397/P_2514);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|BloodCells|Caffeine|Partition coefficient (water/container)
P_3661 = (P_905*P_2950);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Interstitial|Volume
P_3662 = P_2950;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Intracellular|Volume of protein container
P_3663 = (P_2088*P_2950);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Intracellular|Volume
P_3664 = (P_2960*P_925);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Weight (tissue)
P_3665 = (P_2940*P_846*P_927);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Blood flow rate
P_3666 = (P_935*(1-P_42)*P_2960);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Plasma|Volume
P_3667 = (P_935*P_42*P_2960);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|BloodCells|Volume
P_3668 = (P_3397/P_2514);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|BloodCells|Caffeine|Partition coefficient (water/container)
P_3669 = (P_943*P_2960);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Interstitial|Volume
P_3670 = P_2960;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Intracellular|Volume of protein container
P_3671 = (P_2104*P_2960);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Intracellular|Volume
P_3672 = (P_2970*P_963);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Weight (tissue)
P_3673 = (P_2940*P_846*P_964);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Blood flow rate
P_3674 = (P_973*(1-P_42)*P_2970);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Plasma|Volume
P_3675 = (P_973*P_42*P_2970);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|BloodCells|Volume
P_3676 = (P_3397/P_2514);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|BloodCells|Caffeine|Partition coefficient (water/container)
P_3677 = (P_981*P_2970);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Interstitial|Volume
P_3678 = P_2970;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Intracellular|Volume of protein container
P_3679 = (P_2120*P_2970);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Intracellular|Volume
P_3680 = (P_2980*P_1001);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Weight (tissue)
P_3681 = (P_2940*P_846*P_1002);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Blood flow rate
P_3682 = (P_1011*(1-P_42)*P_2980);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Plasma|Volume
P_3683 = (P_1011*P_42*P_2980);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|BloodCells|Volume
P_3684 = (P_3397/P_2514);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|BloodCells|Caffeine|Partition coefficient (water/container)
P_3685 = (P_1019*P_2980);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Interstitial|Volume
P_3686 = P_2980;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Intracellular|Volume of protein container
P_3687 = (P_2136*P_2980);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Intracellular|Volume
P_3688 = (P_2990*P_1039);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Weight (tissue)
P_3689 = (P_2940*P_846*P_1040);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Blood flow rate
P_3690 = (P_1049*(1-P_42)*P_2990);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Plasma|Volume
P_3691 = (P_1049*P_42*P_2990);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|BloodCells|Volume
P_3692 = (P_3397/P_2514);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|BloodCells|Caffeine|Partition coefficient (water/container)
P_3693 = (P_1057*P_2990);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Interstitial|Volume
P_3694 = P_2990;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Intracellular|Volume of protein container
P_3695 = (P_2152*P_2990);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Intracellular|Volume
P_3696 = (P_3000*P_1077);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Weight (tissue)
P_3697 = (P_2940*P_846*P_1078);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Blood flow rate
P_3698 = (P_1087*(1-P_42)*P_3000);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Plasma|Volume
P_3699 = (P_1087*P_42*P_3000);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|BloodCells|Volume
P_3700 = (P_3397/P_2514);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|BloodCells|Caffeine|Partition coefficient (water/container)
P_3701 = (P_1095*P_3000);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Interstitial|Volume
P_3702 = P_3000;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Intracellular|Volume of protein container
P_3703 = (P_2168*P_3000);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Intracellular|Volume
P_3704 = (P_1118*P_3011*(1-P_42));  % CoffeinSimulation|Organism|Liver|Lymph flow rate
P_3705 = (P_3243*P_17);  % CoffeinSimulation|Organism|Liver|Periportal|Volume (endothelium)
P_3706 = P_3011;  % CoffeinSimulation|Organism|Liver|Periportal|Blood flow rate
P_3707 = P_3014;  % CoffeinSimulation|Organism|Liver|Periportal|Plasma|Volume of protein container
P_3708 = (IIf((P_3014 > 0),(y(200)/P_3014),0));  % CoffeinSimulation|Organism|Liver|Periportal|Plasma|Caffeine|Concentration
P_3709 = (IIf((P_3014 > 0),(y(201)/P_3014),0));  % CoffeinSimulation|Organism|Liver|Periportal|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_3710 = P_3019;  % CoffeinSimulation|Organism|Liver|Periportal|BloodCells|Volume of protein container
P_3711 = (IIf((P_3019 > 0),(y(202)/P_3019),0));  % CoffeinSimulation|Organism|Liver|Periportal|BloodCells|Caffeine|Concentration
P_3712 = (P_3397/P_2514);  % CoffeinSimulation|Organism|Liver|Periportal|BloodCells|Caffeine|Partition coefficient (water/container)
P_3713 = (IIf((P_3019 > 0),(y(203)/P_3019),0));  % CoffeinSimulation|Organism|Liver|Periportal|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_3714 = P_3023;  % CoffeinSimulation|Organism|Liver|Periportal|Interstitial|Volume of protein container
P_3715 = (IIf((P_3023 > 0),(y(204)/P_3023),0));  % CoffeinSimulation|Organism|Liver|Periportal|Interstitial|Caffeine|Concentration
P_3716 = (P_3013*P_2189);  % CoffeinSimulation|Organism|Liver|Periportal|Intracellular|Volume
P_3717 = (P_2230*P_1553*P_2231*P_3024);  % CoffeinSimulation|Organism|Liver|Periportal|Intracellular|CYP1A2|Start amount
P_3718 = (P_3250*P_17);  % CoffeinSimulation|Organism|Liver|Pericentral|Volume (endothelium)
P_3719 = P_3011;  % CoffeinSimulation|Organism|Liver|Pericentral|Blood flow rate
P_3720 = P_3029;  % CoffeinSimulation|Organism|Liver|Pericentral|Plasma|Volume of protein container
P_3721 = (IIf((P_3029 > 0),(y(207)/P_3029),0));  % CoffeinSimulation|Organism|Liver|Pericentral|Plasma|Caffeine|Concentration
P_3722 = (IIf((P_3029 > 0),(y(208)/P_3029),0));  % CoffeinSimulation|Organism|Liver|Pericentral|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_3723 = P_3034;  % CoffeinSimulation|Organism|Liver|Pericentral|BloodCells|Volume of protein container
P_3724 = (IIf((P_3034 > 0),(y(209)/P_3034),0));  % CoffeinSimulation|Organism|Liver|Pericentral|BloodCells|Caffeine|Concentration
P_3725 = (P_3397/P_2514);  % CoffeinSimulation|Organism|Liver|Pericentral|BloodCells|Caffeine|Partition coefficient (water/container)
P_3726 = (IIf((P_3034 > 0),(y(210)/P_3034),0));  % CoffeinSimulation|Organism|Liver|Pericentral|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_3727 = P_3038;  % CoffeinSimulation|Organism|Liver|Pericentral|Interstitial|Volume of protein container
P_3728 = (IIf((P_3038 > 0),(y(211)/P_3038),0));  % CoffeinSimulation|Organism|Liver|Pericentral|Interstitial|Caffeine|Concentration
P_3729 = (P_3028*P_2237);  % CoffeinSimulation|Organism|Liver|Pericentral|Intracellular|Volume
P_3730 = (P_2278*P_1553*P_2279*P_3039);  % CoffeinSimulation|Organism|Liver|Pericentral|Intracellular|CYP1A2|Start amount
P_3731 = (P_2860+P_2880+P_2940+P_3085+P_3140+P_3011+P_3064+P_2622+P_3119+P_2686+P_2601+P_2664+P_2579+P_2643);  % CoffeinSimulation|Organism|Lung|Blood flow rate
P_3732 = (P_3046*P_1553*P_2291*P_3044);  % CoffeinSimulation|Organism|Lung|Plasma|CYP1A2|Start amount
P_3733 = (P_3053*P_1553*P_2297*P_3051);  % CoffeinSimulation|Organism|Lung|BloodCells|CYP1A2|Start amount
P_3734 = (P_3397/P_2514);  % CoffeinSimulation|Organism|Lung|BloodCells|Caffeine|Partition coefficient (water/container)
P_3735 = P_3061;  % CoffeinSimulation|Organism|Lung|Intracellular|CYP1A2
P_3736 = (IIf((P_3059 > 0),(y(219)/P_3059),0));  % CoffeinSimulation|Organism|Lung|Intracellular|Caffeine|Concentration
P_3737 = (IIf((P_3059 > 0),(y(220)/P_3059),0));  % CoffeinSimulation|Organism|Lung|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_3738 = (P_1211*P_3064*(1-P_42));  % CoffeinSimulation|Organism|Muscle|Lymph flow rate
P_3739 = (P_3067*P_1553*P_2313*P_3065);  % CoffeinSimulation|Organism|Muscle|Plasma|CYP1A2|Start amount
P_3740 = (P_3074*P_1553*P_2318*P_3072);  % CoffeinSimulation|Organism|Muscle|BloodCells|CYP1A2|Start amount
P_3741 = (P_3397/P_2514);  % CoffeinSimulation|Organism|Muscle|BloodCells|Caffeine|Partition coefficient (water/container)
P_3742 = P_3082;  % CoffeinSimulation|Organism|Muscle|Intracellular|CYP1A2
P_3743 = (IIf((P_3080 > 0),(y(226)/P_3080),0));  % CoffeinSimulation|Organism|Muscle|Intracellular|Caffeine|Concentration
P_3744 = (IIf((P_3080 > 0),(y(227)/P_3080),0));  % CoffeinSimulation|Organism|Muscle|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_3745 = (P_1256*P_3085*(1-P_42));  % CoffeinSimulation|Organism|Pancreas|Lymph flow rate
P_3746 = (P_3088*P_1553*P_2334*P_3086);  % CoffeinSimulation|Organism|Pancreas|Plasma|CYP1A2|Start amount
P_3747 = (P_3095*P_1553*P_2339*P_3093);  % CoffeinSimulation|Organism|Pancreas|BloodCells|CYP1A2|Start amount
P_3748 = (P_3397/P_2514);  % CoffeinSimulation|Organism|Pancreas|BloodCells|Caffeine|Partition coefficient (water/container)
P_3749 = P_3103;  % CoffeinSimulation|Organism|Pancreas|Intracellular|CYP1A2
P_3750 = (IIf((P_3101 > 0),(y(233)/P_3101),0));  % CoffeinSimulation|Organism|Pancreas|Intracellular|Caffeine|Concentration
P_3751 = (IIf((P_3101 > 0),(y(234)/P_3101),0));  % CoffeinSimulation|Organism|Pancreas|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_3752 = (P_2860+P_2880+P_2940+P_3085+P_3140);  % CoffeinSimulation|Organism|PortalVein|Blood flow rate
P_3753 = (P_3107*P_1553*P_2354*P_3105);  % CoffeinSimulation|Organism|PortalVein|Plasma|CYP1A2|Start amount
P_3754 = (P_3114*P_1553*P_2359*P_3112);  % CoffeinSimulation|Organism|PortalVein|BloodCells|CYP1A2|Start amount
P_3755 = (P_3397/P_2514);  % CoffeinSimulation|Organism|PortalVein|BloodCells|Caffeine|Partition coefficient (water/container)
P_3756 = (P_1306*P_3119*(1-P_42));  % CoffeinSimulation|Organism|Skin|Lymph flow rate
P_3757 = (P_3122*P_1553*P_2368*P_3120);  % CoffeinSimulation|Organism|Skin|Plasma|CYP1A2|Start amount
P_3758 = (P_3129*P_1553*P_2373*P_3127);  % CoffeinSimulation|Organism|Skin|BloodCells|CYP1A2|Start amount
P_3759 = (P_3397/P_2514);  % CoffeinSimulation|Organism|Skin|BloodCells|Caffeine|Partition coefficient (water/container)
P_3760 = P_3137;  % CoffeinSimulation|Organism|Skin|Intracellular|CYP1A2
P_3761 = (IIf((P_3135 > 0),(y(244)/P_3135),0));  % CoffeinSimulation|Organism|Skin|Intracellular|Caffeine|Concentration
P_3762 = (IIf((P_3135 > 0),(y(245)/P_3135),0));  % CoffeinSimulation|Organism|Skin|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_3763 = (P_1349*P_3140*(1-P_42));  % CoffeinSimulation|Organism|Spleen|Lymph flow rate
P_3764 = (P_3143*P_1553*P_2388*P_3141);  % CoffeinSimulation|Organism|Spleen|Plasma|CYP1A2|Start amount
P_3765 = (P_3150*P_1553*P_2394*P_3148);  % CoffeinSimulation|Organism|Spleen|BloodCells|CYP1A2|Start amount
P_3766 = (P_3397/P_2514);  % CoffeinSimulation|Organism|Spleen|BloodCells|Caffeine|Partition coefficient (water/container)
P_3767 = P_3158;  % CoffeinSimulation|Organism|Spleen|Intracellular|CYP1A2
P_3768 = (IIf((P_3156 > 0),(y(251)/P_3156),0));  % CoffeinSimulation|Organism|Spleen|Intracellular|Caffeine|Concentration
P_3769 = (IIf((P_3156 > 0),(y(252)/P_3156),0));  % CoffeinSimulation|Organism|Spleen|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_3770 = (P_2514/P_3160);  % CoffeinSimulation|Neighborhoods|Bone_int_Bone_cell|Caffeine|Partition coefficient (intracellular/water)
P_3771 = (P_3423*P_1392);  % CoffeinSimulation|Neighborhoods|Bone_int_Bone_cell|Caffeine|P (intracellular->interstitial)
P_3772 = (P_3423*P_1393);  % CoffeinSimulation|Neighborhoods|Bone_int_Bone_cell|Caffeine|P (interstitial->intracellular)
P_3773 = (P_2514/P_3161);  % CoffeinSimulation|Neighborhoods|Bone_int_Bone_cell|Caffeine|Partition coefficient (interstitial/water)
P_3774 = (P_3423*0.5);  % CoffeinSimulation|Neighborhoods|Brain_pls_Brain_int|Caffeine|P (plasma<->interstitial)
P_3775 = (P_3423*P_1396);  % CoffeinSimulation|Neighborhoods|Brain_int_Brain_cell|Caffeine|P (intracellular->interstitial)
P_3776 = (P_3423*P_1395);  % CoffeinSimulation|Neighborhoods|Brain_int_Brain_cell|Caffeine|P (interstitial->intracellular)
P_3777 = (P_2514/P_3163);  % CoffeinSimulation|Neighborhoods|Brain_int_Brain_cell|Caffeine|Partition coefficient (intracellular/water)
P_3778 = (P_2514/P_3162);  % CoffeinSimulation|Neighborhoods|Brain_int_Brain_cell|Caffeine|Partition coefficient (interstitial/water)
P_3779 = (P_2514/P_3165);  % CoffeinSimulation|Neighborhoods|Fat_int_Fat_cell|Caffeine|Partition coefficient (intracellular/water)
P_3780 = (P_3423*P_1399);  % CoffeinSimulation|Neighborhoods|Fat_int_Fat_cell|Caffeine|P (intracellular->interstitial)
P_3781 = (P_3423*P_1398);  % CoffeinSimulation|Neighborhoods|Fat_int_Fat_cell|Caffeine|P (interstitial->intracellular)
P_3782 = (P_2514/P_3164);  % CoffeinSimulation|Neighborhoods|Fat_int_Fat_cell|Caffeine|Partition coefficient (interstitial/water)
P_3783 = (P_2514/P_3166);  % CoffeinSimulation|Neighborhoods|Gonads_int_Gonads_cell|Caffeine|Partition coefficient (intracellular/water)
P_3784 = (P_3423*P_1400);  % CoffeinSimulation|Neighborhoods|Gonads_int_Gonads_cell|Caffeine|P (intracellular->interstitial)
P_3785 = (P_3423*P_1401);  % CoffeinSimulation|Neighborhoods|Gonads_int_Gonads_cell|Caffeine|P (interstitial->intracellular)
P_3786 = (P_2514/P_3167);  % CoffeinSimulation|Neighborhoods|Gonads_int_Gonads_cell|Caffeine|Partition coefficient (interstitial/water)
P_3787 = (P_3423*P_1404);  % CoffeinSimulation|Neighborhoods|Heart_int_Heart_cell|Caffeine|P (intracellular->interstitial)
P_3788 = (P_2514/P_3169);  % CoffeinSimulation|Neighborhoods|Heart_int_Heart_cell|Caffeine|Partition coefficient (intracellular/water)
P_3789 = (P_3423*P_1405);  % CoffeinSimulation|Neighborhoods|Heart_int_Heart_cell|Caffeine|P (interstitial->intracellular)
P_3790 = (P_2514/P_3168);  % CoffeinSimulation|Neighborhoods|Heart_int_Heart_cell|Caffeine|Partition coefficient (interstitial/water)
P_3791 = (IIf(P_1546,(P_3171+((P_3172+P_3173+P_3174)*(P_1521^1))+(P_3175*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3176*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3177*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3185*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|P_int_trans_cell_lum_factor
P_3792 = (IIf(P_1546,(P_3178+((P_3179+P_3180+P_3181)*(P_1521^1))+(P_3182*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3183*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3184*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3170*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|P_int_trans_lum_cell_factor
P_3793 = P_3282;  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3794 = (P_2514/P_3186);  % CoffeinSimulation|Neighborhoods|Kidney_int_Kidney_cell|Caffeine|Partition coefficient (intracellular/water)
P_3795 = (P_3423*P_1408);  % CoffeinSimulation|Neighborhoods|Kidney_int_Kidney_cell|Caffeine|P (interstitial->intracellular)
P_3796 = (P_3423*P_1409);  % CoffeinSimulation|Neighborhoods|Kidney_int_Kidney_cell|Caffeine|P (intracellular->interstitial)
P_3797 = (P_2514/P_3187);  % CoffeinSimulation|Neighborhoods|Kidney_int_Kidney_cell|Caffeine|Partition coefficient (interstitial/water)
P_3798 = (IIf(P_1546,(P_3203+((P_3202+P_3189+P_3190)*(P_1521^1))+(P_3191*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3192*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3193*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3194*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|P_int_trans_cell_lum_factor
P_3799 = (IIf(P_1546,(P_3195+((P_3188+P_3196+P_3197)*(P_1521^1))+(P_3198*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3199*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3200*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3201*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|P_int_trans_lum_cell_factor
P_3800 = P_3283;  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3801 = (P_3423*P_1420);  % CoffeinSimulation|Neighborhoods|Stomach_int_Stomach_cell|Caffeine|P (intracellular->interstitial)
P_3802 = (P_3423*P_1421);  % CoffeinSimulation|Neighborhoods|Stomach_int_Stomach_cell|Caffeine|P (interstitial->intracellular)
P_3803 = (P_2514/P_3205);  % CoffeinSimulation|Neighborhoods|Stomach_int_Stomach_cell|Caffeine|Partition coefficient (intracellular/water)
P_3804 = (P_2514/P_3204);  % CoffeinSimulation|Neighborhoods|Stomach_int_Stomach_cell|Caffeine|Partition coefficient (interstitial/water)
P_3805 = (IIf(P_1546,(P_3220+((P_3221+P_3213+P_3219)*(P_1521^1))+(P_3218*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3207*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3208*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3209*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|P_int_trans_cell_lum_factor
P_3806 = (IIf(P_1546,(P_3210+((P_3211+P_3217+P_3212)*(P_1521^1))+(P_3206*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3214*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3215*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3216*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|P_int_trans_lum_cell_factor
P_3807 = P_3286;  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3808 = (P_2514/P_3222);  % CoffeinSimulation|Neighborhoods|SmallIntestine_int_SmallIntestine_cell|Caffeine|Partition coefficient (intracellular/water)
P_3809 = (P_3423*P_1425);  % CoffeinSimulation|Neighborhoods|SmallIntestine_int_SmallIntestine_cell|Caffeine|P (interstitial->intracellular)
P_3810 = (P_3423*P_1424);  % CoffeinSimulation|Neighborhoods|SmallIntestine_int_SmallIntestine_cell|Caffeine|P (intracellular->interstitial)
P_3811 = (P_2514/P_3223);  % CoffeinSimulation|Neighborhoods|SmallIntestine_int_SmallIntestine_cell|Caffeine|Partition coefficient (interstitial/water)
P_3812 = (IIf(P_1546,(P_3232+((P_3233+P_3234+P_3235)*(P_1521^1))+(P_3236*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3237*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3238*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3239*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|P_int_trans_cell_lum_factor
P_3813 = (IIf(P_1546,(P_3231+((P_3230+P_3224+P_3225)*(P_1521^1))+(P_3226*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3227*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3228*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3229*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|P_int_trans_lum_cell_factor
P_3814 = P_3287;  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3815 = (P_3423*P_1430);  % CoffeinSimulation|Neighborhoods|LargeIntestine_int_LargeIntestine_cell|Caffeine|P (interstitial->intracellular)
P_3816 = (P_3423*P_1429);  % CoffeinSimulation|Neighborhoods|LargeIntestine_int_LargeIntestine_cell|Caffeine|P (intracellular->interstitial)
P_3817 = (P_2514/P_3240);  % CoffeinSimulation|Neighborhoods|LargeIntestine_int_LargeIntestine_cell|Caffeine|Partition coefficient (intracellular/water)
P_3818 = (P_2514/P_3241);  % CoffeinSimulation|Neighborhoods|LargeIntestine_int_LargeIntestine_cell|Caffeine|Partition coefficient (interstitial/water)
P_3819 = (P_2514/P_3245);  % CoffeinSimulation|Neighborhoods|Periportal_int_Periportal_cell|Caffeine|Partition coefficient (intracellular/water)
P_3820 = (P_3423*P_1434);  % CoffeinSimulation|Neighborhoods|Periportal_int_Periportal_cell|Caffeine|P (interstitial->intracellular)
P_3821 = (P_3423*P_1433);  % CoffeinSimulation|Neighborhoods|Periportal_int_Periportal_cell|Caffeine|P (intracellular->interstitial)
P_3822 = (P_2514/P_3242);  % CoffeinSimulation|Neighborhoods|Periportal_int_Periportal_cell|Caffeine|Partition coefficient (interstitial/water)
P_3823 = (P_3423*P_1436);  % CoffeinSimulation|Neighborhoods|Pericentral_int_Pericentral_cell|Caffeine|P (interstitial->intracellular)
P_3824 = (P_3423*P_1435);  % CoffeinSimulation|Neighborhoods|Pericentral_int_Pericentral_cell|Caffeine|P (intracellular->interstitial)
P_3825 = (P_2514/P_3247);  % CoffeinSimulation|Neighborhoods|Pericentral_int_Pericentral_cell|Caffeine|Partition coefficient (intracellular/water)
P_3826 = (P_2514/P_3249);  % CoffeinSimulation|Neighborhoods|Pericentral_int_Pericentral_cell|Caffeine|Partition coefficient (interstitial/water)
P_3827 = (P_2514/P_3253);  % CoffeinSimulation|Neighborhoods|Lung_int_Lung_cell|Caffeine|Partition coefficient (intracellular/water)
P_3828 = (P_3423*P_1440);  % CoffeinSimulation|Neighborhoods|Lung_int_Lung_cell|Caffeine|P (interstitial->intracellular)
P_3829 = (P_3423*P_1439);  % CoffeinSimulation|Neighborhoods|Lung_int_Lung_cell|Caffeine|P (intracellular->interstitial)
P_3830 = (P_2514/P_3252);  % CoffeinSimulation|Neighborhoods|Lung_int_Lung_cell|Caffeine|Partition coefficient (interstitial/water)
P_3831 = (P_3423*P_1443);  % CoffeinSimulation|Neighborhoods|Muscle_int_Muscle_cell|Caffeine|P (interstitial->intracellular)
P_3832 = (P_3423*P_1442);  % CoffeinSimulation|Neighborhoods|Muscle_int_Muscle_cell|Caffeine|P (intracellular->interstitial)
P_3833 = (P_2514/P_3255);  % CoffeinSimulation|Neighborhoods|Muscle_int_Muscle_cell|Caffeine|Partition coefficient (intracellular/water)
P_3834 = (P_2514/P_3254);  % CoffeinSimulation|Neighborhoods|Muscle_int_Muscle_cell|Caffeine|Partition coefficient (interstitial/water)
P_3835 = (P_3423*P_1446);  % CoffeinSimulation|Neighborhoods|Pancreas_int_Pancreas_cell|Caffeine|P (interstitial->intracellular)
P_3836 = (P_2514/P_3257);  % CoffeinSimulation|Neighborhoods|Pancreas_int_Pancreas_cell|Caffeine|Partition coefficient (intracellular/water)
P_3837 = (P_3423*P_1445);  % CoffeinSimulation|Neighborhoods|Pancreas_int_Pancreas_cell|Caffeine|P (intracellular->interstitial)
P_3838 = (P_2514/P_3256);  % CoffeinSimulation|Neighborhoods|Pancreas_int_Pancreas_cell|Caffeine|Partition coefficient (interstitial/water)
P_3839 = (IIf(P_1546,(P_3258+((P_3259+P_3260+P_3261)*(P_1521^1))+(P_3262*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3263*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3264*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3265*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|P_int_trans_cell_lum_factor
P_3840 = (IIf(P_1546,(P_3266+((P_3267+P_3268+P_3269)*(P_1521^1))+(P_3270*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3271*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3272*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3273*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|P_int_trans_lum_cell_factor
P_3841 = P_3299;  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3842 = (P_3423*P_1452);  % CoffeinSimulation|Neighborhoods|Skin_int_Skin_cell|Caffeine|P (interstitial->intracellular)
P_3843 = (P_3423*P_1451);  % CoffeinSimulation|Neighborhoods|Skin_int_Skin_cell|Caffeine|P (intracellular->interstitial)
P_3844 = (P_2514/P_3275);  % CoffeinSimulation|Neighborhoods|Skin_int_Skin_cell|Caffeine|Partition coefficient (intracellular/water)
P_3845 = (P_2514/P_3274);  % CoffeinSimulation|Neighborhoods|Skin_int_Skin_cell|Caffeine|Partition coefficient (interstitial/water)
P_3846 = (P_3423*P_1454);  % CoffeinSimulation|Neighborhoods|Spleen_int_Spleen_cell|Caffeine|P (intracellular->interstitial)
P_3847 = (P_2514/P_3277);  % CoffeinSimulation|Neighborhoods|Spleen_int_Spleen_cell|Caffeine|Partition coefficient (intracellular/water)
P_3848 = (P_3423*P_1455);  % CoffeinSimulation|Neighborhoods|Spleen_int_Spleen_cell|Caffeine|P (interstitial->intracellular)
P_3849 = (P_2514/P_3276);  % CoffeinSimulation|Neighborhoods|Spleen_int_Spleen_cell|Caffeine|Partition coefficient (interstitial/water)
P_3850 = (P_0*P_661*P_2890);  % CoffeinSimulation|Neighborhoods|Duodenum_pls_Duodenum_int|Surface area (plasma/interstitial)
P_3851 = (P_42*P_26*0.6*P_2890*P_661);  % CoffeinSimulation|Neighborhoods|Duodenum_pls_Duodenum_bc|Surface area (blood cells/plasma)
P_3852 = (P_2514/P_3280);  % CoffeinSimulation|Neighborhoods|Duodenum_int_Duodenum_cell|Caffeine|Partition coefficient (intracellular/water)
P_3853 = (P_2514/P_3223);  % CoffeinSimulation|Neighborhoods|Duodenum_int_Duodenum_cell|Caffeine|Partition coefficient (interstitial/water)
P_3854 = (P_0*P_699*P_2900);  % CoffeinSimulation|Neighborhoods|UpperJejunum_pls_UpperJejunum_int|Surface area (plasma/interstitial)
P_3855 = (P_2514/P_3282);  % CoffeinSimulation|Neighborhoods|UpperJejunum_int_UpperJejunum_cell|Caffeine|Partition coefficient (intracellular/water)
P_3856 = (P_2514/P_3223);  % CoffeinSimulation|Neighborhoods|UpperJejunum_int_UpperJejunum_cell|Caffeine|Partition coefficient (interstitial/water)
P_3857 = (P_42*P_26*0.6*P_2900*P_699);  % CoffeinSimulation|Neighborhoods|UpperJejunum_pls_UpperJejunum_bc|Surface area (blood cells/plasma)
P_3858 = (P_2514/P_3283);  % CoffeinSimulation|Neighborhoods|LowerJejunum_int_LowerJejunum_cell|Caffeine|Partition coefficient (intracellular/water)
P_3859 = (P_2514/P_3223);  % CoffeinSimulation|Neighborhoods|LowerJejunum_int_LowerJejunum_cell|Caffeine|Partition coefficient (interstitial/water)
P_3860 = (P_0*P_737*P_2910);  % CoffeinSimulation|Neighborhoods|LowerJejunum_pls_LowerJejunum_int|Surface area (plasma/interstitial)
P_3861 = (P_42*P_26*0.6*P_2910*P_737);  % CoffeinSimulation|Neighborhoods|LowerJejunum_pls_LowerJejunum_bc|Surface area (blood cells/plasma)
P_3862 = (P_0*P_775*P_2920);  % CoffeinSimulation|Neighborhoods|UpperIleum_pls_UpperIleum_int|Surface area (plasma/interstitial)
P_3863 = (P_2514/P_3286);  % CoffeinSimulation|Neighborhoods|UpperIleum_int_UpperIleum_cell|Caffeine|Partition coefficient (intracellular/water)
P_3864 = (P_2514/P_3223);  % CoffeinSimulation|Neighborhoods|UpperIleum_int_UpperIleum_cell|Caffeine|Partition coefficient (interstitial/water)
P_3865 = (P_42*P_26*0.6*P_2920*P_775);  % CoffeinSimulation|Neighborhoods|UpperIleum_pls_UpperIleum_bc|Surface area (blood cells/plasma)
P_3866 = (P_42*P_26*0.6*P_2930*P_813);  % CoffeinSimulation|Neighborhoods|LowerIleum_pls_LowerIleum_bc|Surface area (blood cells/plasma)
P_3867 = (P_2514/P_3287);  % CoffeinSimulation|Neighborhoods|LowerIleum_int_LowerIleum_cell|Caffeine|Partition coefficient (intracellular/water)
P_3868 = (P_2514/P_3223);  % CoffeinSimulation|Neighborhoods|LowerIleum_int_LowerIleum_cell|Caffeine|Partition coefficient (interstitial/water)
P_3869 = (P_0*P_813*P_2930);  % CoffeinSimulation|Neighborhoods|LowerIleum_pls_LowerIleum_int|Surface area (plasma/interstitial)
P_3870 = (P_0*P_897*P_2950);  % CoffeinSimulation|Neighborhoods|Caecum_pls_Caecum_int|Surface area (plasma/interstitial)
P_3871 = (P_2514/P_3290);  % CoffeinSimulation|Neighborhoods|Caecum_int_Caecum_cell|Caffeine|Partition coefficient (intracellular/water)
P_3872 = (P_2514/P_3241);  % CoffeinSimulation|Neighborhoods|Caecum_int_Caecum_cell|Caffeine|Partition coefficient (interstitial/water)
P_3873 = (P_42*P_26*0.6*P_2950*P_897);  % CoffeinSimulation|Neighborhoods|Caecum_pls_Caecum_bc|Surface area (blood cells/plasma)
P_3874 = (P_42*P_26*0.6*P_2960*P_935);  % CoffeinSimulation|Neighborhoods|ColonAscendens_pls_ColonAscendens_bc|Surface area (blood cells/plasma)
P_3875 = (P_2514/P_3291);  % CoffeinSimulation|Neighborhoods|ColonAscendens_int_ColonAscendens_cell|Caffeine|Partition coefficient (intracellular/water)
P_3876 = (P_2514/P_3241);  % CoffeinSimulation|Neighborhoods|ColonAscendens_int_ColonAscendens_cell|Caffeine|Partition coefficient (interstitial/water)
P_3877 = (P_0*P_935*P_2960);  % CoffeinSimulation|Neighborhoods|ColonAscendens_pls_ColonAscendens_int|Surface area (plasma/interstitial)
P_3878 = (P_0*P_973*P_2970);  % CoffeinSimulation|Neighborhoods|ColonTransversum_pls_ColonTransversum_int|Surface area (plasma/interstitial)
P_3879 = (P_2514/P_3294);  % CoffeinSimulation|Neighborhoods|ColonTransversum_int_ColonTransversum_cell|Caffeine|Partition coefficient (intracellular/water)
P_3880 = (P_2514/P_3241);  % CoffeinSimulation|Neighborhoods|ColonTransversum_int_ColonTransversum_cell|Caffeine|Partition coefficient (interstitial/water)
P_3881 = (P_42*P_26*0.6*P_2970*P_973);  % CoffeinSimulation|Neighborhoods|ColonTransversum_pls_ColonTransversum_bc|Surface area (blood cells/plasma)
P_3882 = (P_2514/P_3295);  % CoffeinSimulation|Neighborhoods|ColonDescendens_int_ColonDescendens_cell|Caffeine|Partition coefficient (intracellular/water)
P_3883 = (P_2514/P_3241);  % CoffeinSimulation|Neighborhoods|ColonDescendens_int_ColonDescendens_cell|Caffeine|Partition coefficient (interstitial/water)
P_3884 = (P_42*P_26*0.6*P_2980*P_1011);  % CoffeinSimulation|Neighborhoods|ColonDescendens_pls_ColonDescendens_bc|Surface area (blood cells/plasma)
P_3885 = (P_0*P_1011*P_2980);  % CoffeinSimulation|Neighborhoods|ColonDescendens_pls_ColonDescendens_int|Surface area (plasma/interstitial)
P_3886 = (P_2514/P_3297);  % CoffeinSimulation|Neighborhoods|ColonSigmoid_int_ColonSigmoid_cell|Caffeine|Partition coefficient (intracellular/water)
P_3887 = (P_2514/P_3241);  % CoffeinSimulation|Neighborhoods|ColonSigmoid_int_ColonSigmoid_cell|Caffeine|Partition coefficient (interstitial/water)
P_3888 = (P_42*P_26*0.6*P_2990*P_1049);  % CoffeinSimulation|Neighborhoods|ColonSigmoid_pls_ColonSigmoid_bc|Surface area (blood cells/plasma)
P_3889 = (P_0*P_1049*P_2990);  % CoffeinSimulation|Neighborhoods|ColonSigmoid_pls_ColonSigmoid_int|Surface area (plasma/interstitial)
P_3890 = (P_42*P_26*0.6*P_3000*P_1087);  % CoffeinSimulation|Neighborhoods|Rectum_pls_Rectum_bc|Surface area (blood cells/plasma)
P_3891 = (P_2514/P_3299);  % CoffeinSimulation|Neighborhoods|Rectum_int_Rectum_cell|Caffeine|Partition coefficient (intracellular/water)
P_3892 = (P_2514/P_3241);  % CoffeinSimulation|Neighborhoods|Rectum_int_Rectum_cell|Caffeine|Partition coefficient (interstitial/water)
P_3893 = (P_0*P_1087*P_3000);  % CoffeinSimulation|Neighborhoods|Rectum_pls_Rectum_int|Surface area (plasma/interstitial)
P_3894 = (IIf(P_1546,(P_3302+((P_3303+P_3304+P_3305)*(P_1521^1))+(P_3306*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3307*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3308*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3309*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|P_int_trans_cell_lum_factor
P_3895 = (IIf(P_1546,(P_3301+((P_3310+P_3311+P_3312)*(P_1521^1))+(P_3313*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3314*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3315*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3316*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|P_int_trans_lum_cell_factor
P_3896 = P_3297;  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3897 = (IIf(P_1546,(P_3318+((P_3319+P_3320+P_3321)*(P_1521^1))+(P_3328*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3323*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3317*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3324*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|P_int_trans_cell_lum_factor
P_3898 = P_3280;  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3899 = (IIf(P_1546,(P_3325+((P_3326+P_3327+P_3330)*(P_1521^1))+(P_3322*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3329*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3331*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3332*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|P_int_trans_lum_cell_factor
P_3900 = (IIf(P_1546,(P_3341+((P_3342+P_3343+P_3344)*(P_1521^1))+(P_3345*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3346*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3347*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3348*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|P_int_trans_cell_lum_factor
P_3901 = (IIf(P_1546,(P_3340+((P_3333+P_3334+P_3335)*(P_1521^1))+(P_3336*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3337*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3338*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3339*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|P_int_trans_lum_cell_factor
P_3902 = P_3295;  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3903 = (IIf(P_1546,(P_3350+((P_3351+P_3352+P_3353)*(P_1521^1))+(P_3354*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3355*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3356*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3357*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|P_int_trans_cell_lum_factor
P_3904 = (IIf(P_1546,(P_3358+((P_3349+P_3359+P_3360)*(P_1521^1))+(P_3361*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3362*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3363*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3364*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|P_int_trans_lum_cell_factor
P_3905 = P_3290;  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3906 = (IIf(P_1546,(P_3366+((P_3367+P_3368+P_3369)*(P_1521^1))+(P_3370*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3371*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3372*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3373*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|P_int_trans_cell_lum_factor
P_3907 = (IIf(P_1546,(P_3365+((P_3374+P_3375+P_3376)*(P_1521^1))+(P_3377*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3378*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3379*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3380*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|P_int_trans_lum_cell_factor
P_3908 = P_3294;  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3909 = (IIf(P_1546,(P_3389+((P_3390+P_3391+P_3392)*(P_1521^1))+(P_3393*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3394*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3395*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3396*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|P_int_trans_cell_lum_factor
P_3910 = (IIf(P_1546,(P_3381+((P_3388+P_3382+P_3383)*(P_1521^1))+(P_3384*(P_1521^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3385*(P_1521^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3386*(P_1521^(max((P_1518+P_1517),(0-(P_1518+P_1517))))))+(P_3387*(P_1521^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518))))))),1));  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|P_int_trans_lum_cell_factor
P_3911 = P_3291;  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|Partition coefficient (intracellular/plasma)
P_3912 = (P_3423*P_1508);  % CoffeinSimulation|Caffeine|P (blood cells->plasma)
P_3913 = (10^((P_1547*(log10(P_3424)))+P_1548));  % CoffeinSimulation|Caffeine|Intestinal permeability (transcellular)
P_3914 = (10^((P_1547*(log10(P_3403)))+P_1548));  % CoffeinSimulation|Caffeine|Default Intestinal permeability (transcellular)
P_3915 = (P_3423*P_1507);  % CoffeinSimulation|Caffeine|P (plasma->blood cells)
P_3916 = (P_3406+(P_3410/(P_1539^(P_1516^2)))+(P_3411/(P_1539^(P_1517^2)))+(P_3412/(P_1539^(P_1518^2)))+(P_3413/(P_1539^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3414/(P_1539^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3415/(P_1539^(max((P_1517+P_1518),(0-(P_1517+P_1518))))))+(P_3416/(P_1539^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518)))))));  % CoffeinSimulation|Caffeine|Solubility_pKa_pH_Factor
P_3917 = (IIf(P_3422,(min(P_1532,(min(P_1533,P_1534)))),0));  % CoffeinSimulation|Caffeine|pKa_ThreeBases_0
P_3918 = (IIf(P_3422,(max(P_1532,(max(P_1533,P_1534)))),0));  % CoffeinSimulation|Caffeine|pKa_Base_2
P_3919 = (IIf(P_3421,(max(P_1532,(max(P_1533,P_1534)))),0));  % CoffeinSimulation|Caffeine|pKa_Acid_2
P_3920 = (IIf(P_3421,(min(P_1532,(min(P_1533,P_1534)))),0));  % CoffeinSimulation|Caffeine|pKa_ThreeAcids_0
P_3921 = (P_3432+(P_3436/(P_1591^(P_1568^2)))+(P_3437/(P_1591^(P_1569^2)))+(P_3438/(P_1591^(P_1570^2)))+(P_3439/(P_1591^(max((P_1568+P_1569),(0-(P_1568+P_1569))))))+(P_3440/(P_1591^(max((P_1568+P_1570),(0-(P_1568+P_1570))))))+(P_3441/(P_1591^(max((P_1569+P_1570),(0-(P_1569+P_1570))))))+(P_3442/(P_1591^(max((P_1568+P_1569+P_1570),(0-(P_1568+P_1569+P_1570)))))));  % CoffeinSimulation|CYP1A2|Solubility_pKa_pH_Factor
P_3922 = (IIf(P_3448,(min(P_1584,(min(P_1585,P_1586)))),0));  % CoffeinSimulation|CYP1A2|pKa_ThreeBases_0
P_3923 = (IIf(P_3448,(max(P_1584,(max(P_1585,P_1586)))),0));  % CoffeinSimulation|CYP1A2|pKa_Base_2
P_3924 = (IIf(P_3447,(max(P_1584,(max(P_1585,P_1586)))),0));  % CoffeinSimulation|CYP1A2|pKa_Acid_2
P_3925 = (IIf(P_3447,(min(P_1584,(min(P_1585,P_1586)))),0));  % CoffeinSimulation|CYP1A2|pKa_ThreeAcids_0
P_3926 = (P_3458+(P_3462/(P_1629^(P_1606^2)))+(P_3463/(P_1629^(P_1607^2)))+(P_3464/(P_1629^(P_1608^2)))+(P_3465/(P_1629^(max((P_1606+P_1607),(0-(P_1606+P_1607))))))+(P_3466/(P_1629^(max((P_1606+P_1608),(0-(P_1606+P_1608))))))+(P_3467/(P_1629^(max((P_1607+P_1608),(0-(P_1607+P_1608))))))+(P_3468/(P_1629^(max((P_1606+P_1607+P_1608),(0-(P_1606+P_1607+P_1608)))))));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|Solubility_pKa_pH_Factor
P_3927 = (IIf(P_3474,(min(P_1622,(min(P_1623,P_1624)))),0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_ThreeBases_0
P_3928 = (IIf(P_3474,(max(P_1622,(max(P_1623,P_1624)))),0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_Base_2
P_3929 = (IIf(P_3473,(max(P_1622,(max(P_1623,P_1624)))),0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_Acid_2
P_3930 = (IIf(P_3473,(min(P_1622,(min(P_1623,P_1624)))),0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_ThreeAcids_0
P_3931 = (P_2552+P_3477);  % CoffeinSimulation|Organism|Weight
P_3932 = P_3478;  % CoffeinSimulation|Organism|VenousBlood|Plasma|CYP1A2
P_3933 = P_3479;  % CoffeinSimulation|Organism|VenousBlood|BloodCells|CYP1A2
P_3934 = P_3481;  % CoffeinSimulation|Organism|ArterialBlood|Plasma|CYP1A2
P_3935 = P_3482;  % CoffeinSimulation|Organism|ArterialBlood|BloodCells|CYP1A2
P_3936 = (P_70*(1-P_74)*P_3484*((P_99/P_66)^(P_16+(-1))));  % CoffeinSimulation|Organism|Bone|Fluid recirculation flow rate
P_3937 = P_3485;  % CoffeinSimulation|Organism|Bone|Plasma|CYP1A2
P_3938 = P_3486;  % CoffeinSimulation|Organism|Bone|BloodCells|CYP1A2
P_3939 = P_3773;  % CoffeinSimulation|Organism|Bone|Interstitial|Caffeine|Partition coefficient (water/container)
P_3940 = (IIf((P_2596 > 0),(P_3488/P_2596),0));  % CoffeinSimulation|Organism|Bone|Intracellular|CYP1A2|Concentration
P_3941 = P_3770;  % CoffeinSimulation|Organism|Bone|Intracellular|Caffeine|Partition coefficient (water/container)
P_3942 = (P_110*(1-P_117)*P_3491*((P_140/P_112)^(P_16+(-1))));  % CoffeinSimulation|Organism|Brain|Fluid recirculation flow rate
P_3943 = P_3492;  % CoffeinSimulation|Organism|Brain|Plasma|CYP1A2
P_3944 = P_3493;  % CoffeinSimulation|Organism|Brain|BloodCells|CYP1A2
P_3945 = P_3778;  % CoffeinSimulation|Organism|Brain|Interstitial|Caffeine|Partition coefficient (water/container)
P_3946 = (IIf((P_2617 > 0),(P_3495/P_2617),0));  % CoffeinSimulation|Organism|Brain|Intracellular|CYP1A2|Concentration
P_3947 = P_3777;  % CoffeinSimulation|Organism|Brain|Intracellular|Caffeine|Partition coefficient (water/container)
P_3948 = (P_155*(1-P_161)*P_3498*((P_170/P_151)^(P_16+(-1))));  % CoffeinSimulation|Organism|Fat|Fluid recirculation flow rate
P_3949 = P_3499;  % CoffeinSimulation|Organism|Fat|Plasma|CYP1A2
P_3950 = P_3500;  % CoffeinSimulation|Organism|Fat|BloodCells|CYP1A2
P_3951 = P_3782;  % CoffeinSimulation|Organism|Fat|Interstitial|Caffeine|Partition coefficient (water/container)
P_3952 = (IIf((P_2638 > 0),(P_3502/P_2638),0));  % CoffeinSimulation|Organism|Fat|Intracellular|CYP1A2|Concentration
P_3953 = P_3779;  % CoffeinSimulation|Organism|Fat|Intracellular|Caffeine|Partition coefficient (water/container)
P_3954 = (P_195*(1-P_202)*P_3505*((P_225/P_197)^(P_16+(-1))));  % CoffeinSimulation|Organism|Gonads|Fluid recirculation flow rate
P_3955 = P_3506;  % CoffeinSimulation|Organism|Gonads|Plasma|CYP1A2
P_3956 = P_3507;  % CoffeinSimulation|Organism|Gonads|BloodCells|CYP1A2
P_3957 = P_3786;  % CoffeinSimulation|Organism|Gonads|Interstitial|Caffeine|Partition coefficient (water/container)
P_3958 = (IIf((P_2659 > 0),(P_3509/P_2659),0));  % CoffeinSimulation|Organism|Gonads|Intracellular|CYP1A2|Concentration
P_3959 = P_3783;  % CoffeinSimulation|Organism|Gonads|Intracellular|Caffeine|Partition coefficient (water/container)
P_3960 = (P_237*(1-P_244)*P_3512*((P_267/P_238)^(P_16+(-1))));  % CoffeinSimulation|Organism|Heart|Fluid recirculation flow rate
P_3961 = P_3513;  % CoffeinSimulation|Organism|Heart|Plasma|CYP1A2
P_3962 = P_3514;  % CoffeinSimulation|Organism|Heart|BloodCells|CYP1A2
P_3963 = P_3790;  % CoffeinSimulation|Organism|Heart|Interstitial|Caffeine|Partition coefficient (water/container)
P_3964 = (IIf((P_2680 > 0),(P_3516/P_2680),0));  % CoffeinSimulation|Organism|Heart|Intracellular|CYP1A2|Concentration
P_3965 = P_3788;  % CoffeinSimulation|Organism|Heart|Intracellular|Caffeine|Partition coefficient (water/container)
P_3966 = (P_280*(1-P_289)*P_3519*((P_312/P_282)^(P_16+(-1))));  % CoffeinSimulation|Organism|Kidney|Fluid recirculation flow rate
P_3967 = P_3521;  % CoffeinSimulation|Organism|Kidney|Plasma|CYP1A2
P_3968 = P_3522;  % CoffeinSimulation|Organism|Kidney|BloodCells|CYP1A2
P_3969 = P_3797;  % CoffeinSimulation|Organism|Kidney|Interstitial|Caffeine|Partition coefficient (water/container)
P_3970 = (IIf((P_2702 > 0),(P_3524/P_2702),0));  % CoffeinSimulation|Organism|Kidney|Intracellular|CYP1A2|Concentration
P_3971 = P_3794;  % CoffeinSimulation|Organism|Kidney|Intracellular|Caffeine|Partition coefficient (water/container)
P_3972 = (IIf((P_3527 < 0.9),1,(1/(1+(exp(((P_3527+(-1))*100)))))));  % CoffeinSimulation|Organism|Lumen|Stomach|FillLevelFlag
P_3973 = P_3528;  % CoffeinSimulation|Organism|Lumen|Stomach|CYP1A2
P_3974 = (P_3535+(P_3534/(P_1539^(P_1516^2)))+(P_3529/(P_1539^(P_1517^2)))+(P_3533/(P_1539^(P_1518^2)))+(P_3536/(P_1539^(max((P_1516+P_1517),(0-(P_1516+P_1517))))))+(P_3532/(P_1539^(max((P_1516+P_1518),(0-(P_1516+P_1518))))))+(P_3531/(P_1539^(max((P_1517+P_1518),(0-(P_1517+P_1518))))))+(P_3530/(P_1539^(max((P_1516+P_1517+P_1518),(0-(P_1516+P_1517+P_1518)))))));  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine|Solubility_pKa_pH_Factor
P_3975 = (y(56)/P_2717);  % CoffeinSimulation|Organism|Lumen|Duodenum|Fraction of geometric volume filled with liquid
P_3976 = (((P_1811*P_338*P_1812)+(P_3537-(P_2716*P_356*P_2717)))/(P_356*P_2717));  % CoffeinSimulation|Organism|Lumen|Duodenum|Absorption of liquid
P_3977 = (P_1823*P_1553*P_1824*P_3538);  % CoffeinSimulation|Organism|Lumen|Duodenum|CYP1A2|Start amount
P_3978 = (P_1537*(P_3916/P_3541));  % CoffeinSimulation|Organism|Lumen|Duodenum|Caffeine|Solubility
P_3979 = (y(60)/P_2729);  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Fraction of geometric volume filled with liquid
P_3980 = (((P_2716*P_356*P_2717)+(P_3543-(P_2730*P_378*P_2729)))/(P_378*P_2729));  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Absorption of liquid
P_3981 = (P_1835*P_1553*P_1837*P_3544);  % CoffeinSimulation|Organism|Lumen|UpperJejunum|CYP1A2|Start amount
P_3982 = (P_1537*(P_3916/P_3547));  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Caffeine|Solubility
P_3983 = (((P_2730*P_378*P_2729)+(P_3549-(P_2744*P_401*P_2742)))/(P_401*P_2742));  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Absorption of liquid
P_3984 = (y(64)/P_2742);  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Fraction of geometric volume filled with liquid
P_3985 = (P_1847*P_1553*P_1849*P_3550);  % CoffeinSimulation|Organism|Lumen|LowerJejunum|CYP1A2|Start amount
P_3986 = (P_1537*(P_3916/P_3553));  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Caffeine|Solubility
P_3987 = (((P_2744*P_401*P_2742)+(P_3556-(P_2756*P_421*P_2757)))/(P_421*P_2757));  % CoffeinSimulation|Organism|Lumen|UpperIleum|Absorption of liquid
P_3988 = (y(68)/P_2757);  % CoffeinSimulation|Organism|Lumen|UpperIleum|Fraction of geometric volume filled with liquid
P_3989 = (P_1859*P_1553*P_1860*P_3557);  % CoffeinSimulation|Organism|Lumen|UpperIleum|CYP1A2|Start amount
P_3990 = (P_1537*(P_3916/P_3559));  % CoffeinSimulation|Organism|Lumen|UpperIleum|Caffeine|Solubility
P_3991 = (((P_2756*P_421*P_2757)+(P_3563-(P_2770*P_430*P_2768)))/(P_430*P_2768));  % CoffeinSimulation|Organism|Lumen|LowerIleum|Absorption of liquid
P_3992 = (y(72)/P_2768);  % CoffeinSimulation|Organism|Lumen|LowerIleum|Fraction of geometric volume filled with liquid
P_3993 = (P_1871*P_1553*P_1873*P_3561);  % CoffeinSimulation|Organism|Lumen|LowerIleum|CYP1A2|Start amount
P_3994 = (P_1537*(P_3916/P_3565));  % CoffeinSimulation|Organism|Lumen|LowerIleum|Caffeine|Solubility
P_3995 = (((P_2770*P_430*P_2768)+(P_3569-(P_2781*P_459*P_2783)))/(P_459*P_2783));  % CoffeinSimulation|Organism|Lumen|Caecum|Absorption of liquid
P_3996 = (y(76)/P_2783);  % CoffeinSimulation|Organism|Lumen|Caecum|Fraction of geometric volume filled with liquid
P_3997 = (P_1883*P_1553*P_1884*P_3567);  % CoffeinSimulation|Organism|Lumen|Caecum|CYP1A2|Start amount
P_3998 = (P_1537*(P_3916/P_3571));  % CoffeinSimulation|Organism|Lumen|Caecum|Caffeine|Solubility
P_3999 = (((P_2781*P_459*P_2783)+(P_3575-(P_2796*P_467*P_2795)))/(P_467*P_2795));  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Absorption of liquid
P_4000 = (y(80)/P_2795);  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Fraction of geometric volume filled with liquid
P_4001 = (P_1895*P_1553*P_1897*P_3573);  % CoffeinSimulation|Organism|Lumen|ColonAscendens|CYP1A2|Start amount
P_4002 = (P_1537*(P_3916/P_3577));  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Caffeine|Solubility
P_4003 = (y(84)/P_2809);  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Fraction of geometric volume filled with liquid
P_4004 = (((P_2796*P_467*P_2795)+(P_3580-(P_2808*P_497*P_2809)))/(P_497*P_2809));  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Absorption of liquid
P_4005 = (P_1907*P_1553*P_1909*P_3581);  % CoffeinSimulation|Organism|Lumen|ColonTransversum|CYP1A2|Start amount
P_4006 = (P_1537*(P_3916/P_3583));  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Caffeine|Solubility
P_4007 = (((P_2808*P_497*P_2809)+(P_3586-(P_2821*P_516*P_2822)))/(P_516*P_2822));  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Absorption of liquid
P_4008 = (y(88)/P_2822);  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Fraction of geometric volume filled with liquid
P_4009 = (P_1919*P_1553*P_1920*P_3587);  % CoffeinSimulation|Organism|Lumen|ColonDescendens|CYP1A2|Start amount
P_4010 = (P_1537*(P_3916/P_3589));  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Caffeine|Solubility
P_4011 = (y(92)/P_2833);  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Fraction of geometric volume filled with liquid
P_4012 = (((P_2821*P_516*P_2822)+(P_3591-(P_2835*P_528*P_2833)))/(P_528*P_2833));  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Absorption of liquid
P_4013 = (P_1931*P_1553*P_1933*P_3593);  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|CYP1A2|Start amount
P_4014 = (P_1537*(P_3916/P_3595));  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Caffeine|Solubility
P_4015 = (((P_2835*P_528*P_2833)+(P_3598-(P_2848*P_545*P_2847)))/(P_545*P_2847));  % CoffeinSimulation|Organism|Lumen|Rectum|Absorption of liquid
P_4016 = (y(96)/P_2847);  % CoffeinSimulation|Organism|Lumen|Rectum|Fraction of geometric volume filled with liquid
P_4017 = (P_2848*y(96));  % CoffeinSimulation|Organism|Lumen|Rectum|Liquid transfer rate
P_4018 = (P_1943*P_1553*P_1945*P_3599);  % CoffeinSimulation|Organism|Lumen|Rectum|CYP1A2|Start amount
P_4019 = (P_1537*(P_3916/P_3601));  % CoffeinSimulation|Organism|Lumen|Rectum|Caffeine|Solubility
P_4020 = (P_564*(1-P_570)*P_3603*((P_594/P_566)^(P_16+(-1))));  % CoffeinSimulation|Organism|Stomach|Fluid recirculation flow rate
P_4021 = P_3604;  % CoffeinSimulation|Organism|Stomach|Plasma|CYP1A2
P_4022 = P_3605;  % CoffeinSimulation|Organism|Stomach|BloodCells|CYP1A2
P_4023 = P_3804;  % CoffeinSimulation|Organism|Stomach|Interstitial|Caffeine|Partition coefficient (water/container)
P_4024 = (IIf((P_2876 > 0),(P_3607/P_2876),0));  % CoffeinSimulation|Organism|Stomach|Intracellular|CYP1A2|Concentration
P_4025 = P_3803;  % CoffeinSimulation|Organism|Stomach|Intracellular|Caffeine|Partition coefficient (water/container)
P_4026 = (P_620*(1-P_42)*(P_640-P_3611));  % CoffeinSimulation|Organism|SmallIntestine|Plasma|Volume
P_4027 = (P_620*P_42*(P_640-P_3611));  % CoffeinSimulation|Organism|SmallIntestine|BloodCells|Volume
P_4028 = (P_628*(P_640-P_3611));  % CoffeinSimulation|Organism|SmallIntestine|Interstitial|Volume
P_4029 = P_3811;  % CoffeinSimulation|Organism|SmallIntestine|Interstitial|Caffeine|Partition coefficient (water/container)
P_4030 = (P_640-P_3611);  % CoffeinSimulation|Organism|SmallIntestine|Intracellular|Volume of protein container
P_4031 = (P_1974*(P_640-P_3611));  % CoffeinSimulation|Organism|SmallIntestine|Intracellular|Volume
P_4032 = P_3808;  % CoffeinSimulation|Organism|SmallIntestine|Intracellular|Caffeine|Partition coefficient (water/container)
P_4033 = (P_3610*(P_2890/P_640));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Lymph flow rate
P_4034 = (P_3850*P_17);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Volume (endothelium)
P_4035 = P_3615;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Plasma|Volume of protein container
P_4036 = (IIf((P_3615 > 0),(y(116)/P_3615),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Plasma|Caffeine|Concentration
P_4037 = (IIf((P_3615 > 0),(y(117)/P_3615),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_4038 = P_3616;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|BloodCells|Volume of protein container
P_4039 = (IIf((P_3616 > 0),(y(118)/P_3616),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|BloodCells|Caffeine|Concentration
P_4040 = (IIf((P_3616 > 0),(y(119)/P_3616),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_4041 = P_3618;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Interstitial|Volume of protein container
P_4042 = (IIf((P_3618 > 0),(y(120)/P_3618),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Interstitial|Caffeine|Concentration
P_4043 = P_3853;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Interstitial|Caffeine|Partition coefficient (water/container)
P_4044 = (P_2002*P_1553*P_2004*P_3619);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Intracellular|CYP1A2|Start amount
P_4045 = (IIf((P_3620 > 0),(y(121)/P_3620),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Intracellular|Caffeine|Concentration
P_4046 = P_3852;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Intracellular|Caffeine|Partition coefficient (water/container)
P_4047 = (IIf((P_3620 > 0),(y(122)/P_3620),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_4048 = (P_3610*(P_2900/P_640));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Lymph flow rate
P_4049 = (P_3854*P_17);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Volume (endothelium)
P_4050 = P_3623;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Plasma|Volume of protein container
P_4051 = (IIf((P_3623 > 0),(y(123)/P_3623),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Plasma|Caffeine|Concentration
P_4052 = (IIf((P_3623 > 0),(y(124)/P_3623),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_4053 = P_3624;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|BloodCells|Volume of protein container
P_4054 = (IIf((P_3624 > 0),(y(125)/P_3624),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|BloodCells|Caffeine|Concentration
P_4055 = (IIf((P_3624 > 0),(y(126)/P_3624),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_4056 = P_3626;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Interstitial|Volume of protein container
P_4057 = (IIf((P_3626 > 0),(y(127)/P_3626),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Interstitial|Caffeine|Concentration
P_4058 = P_3856;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Interstitial|Caffeine|Partition coefficient (water/container)
P_4059 = (P_2018*P_1553*P_2019*P_3627);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Intracellular|CYP1A2|Start amount
P_4060 = (IIf((P_3628 > 0),(y(128)/P_3628),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Intracellular|Caffeine|Concentration
P_4061 = P_3855;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Intracellular|Caffeine|Partition coefficient (water/container)
P_4062 = (IIf((P_3628 > 0),(y(129)/P_3628),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_4063 = (P_3860*P_17);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Volume (endothelium)
P_4064 = (P_3610*(P_2910/P_640));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Lymph flow rate
P_4065 = P_3631;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Plasma|Volume of protein container
P_4066 = (IIf((P_3631 > 0),(y(130)/P_3631),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Plasma|Caffeine|Concentration
P_4067 = (IIf((P_3631 > 0),(y(131)/P_3631),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_4068 = P_3632;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|BloodCells|Volume of protein container
P_4069 = (IIf((P_3632 > 0),(y(132)/P_3632),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|BloodCells|Caffeine|Concentration
P_4070 = (IIf((P_3632 > 0),(y(133)/P_3632),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_4071 = P_3634;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Interstitial|Volume of protein container
P_4072 = (IIf((P_3634 > 0),(y(134)/P_3634),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Interstitial|Caffeine|Concentration
P_4073 = P_3859;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Interstitial|Caffeine|Partition coefficient (water/container)
P_4074 = (P_2034*P_1553*P_2035*P_3635);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Intracellular|CYP1A2|Start amount
P_4075 = (IIf((P_3636 > 0),(y(135)/P_3636),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Intracellular|Caffeine|Concentration
P_4076 = P_3858;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Intracellular|Caffeine|Partition coefficient (water/container)
P_4077 = (IIf((P_3636 > 0),(y(136)/P_3636),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_4078 = (P_3862*P_17);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Volume (endothelium)
P_4079 = (P_3610*(P_2920/P_640));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Lymph flow rate
P_4080 = P_3639;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Plasma|Volume of protein container
P_4081 = (IIf((P_3639 > 0),(y(137)/P_3639),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Plasma|Caffeine|Concentration
P_4082 = (IIf((P_3639 > 0),(y(138)/P_3639),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_4083 = P_3640;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|BloodCells|Volume of protein container
P_4084 = (IIf((P_3640 > 0),(y(139)/P_3640),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|BloodCells|Caffeine|Concentration
P_4085 = (IIf((P_3640 > 0),(y(140)/P_3640),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_4086 = P_3642;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Interstitial|Volume of protein container
P_4087 = (IIf((P_3642 > 0),(y(141)/P_3642),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Interstitial|Caffeine|Concentration
P_4088 = P_3864;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Interstitial|Caffeine|Partition coefficient (water/container)
P_4089 = (P_2050*P_1553*P_2052*P_3643);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Intracellular|CYP1A2|Start amount
P_4090 = (IIf((P_3644 > 0),(y(142)/P_3644),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Intracellular|Caffeine|Concentration
P_4091 = P_3863;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Intracellular|Caffeine|Partition coefficient (water/container)
P_4092 = (IIf((P_3644 > 0),(y(143)/P_3644),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_4093 = (P_3869*P_17);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Volume (endothelium)
P_4094 = (P_3610*(P_2930/P_640));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Lymph flow rate
P_4095 = P_3647;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Plasma|Volume of protein container
P_4096 = (IIf((P_3647 > 0),(y(144)/P_3647),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Plasma|Caffeine|Concentration
P_4097 = (IIf((P_3647 > 0),(y(145)/P_3647),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_4098 = P_3648;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|BloodCells|Volume of protein container
P_4099 = (IIf((P_3648 > 0),(y(146)/P_3648),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|BloodCells|Caffeine|Concentration
P_4100 = (IIf((P_3648 > 0),(y(147)/P_3648),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_4101 = P_3650;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Interstitial|Volume of protein container
P_4102 = (IIf((P_3650 > 0),(y(148)/P_3650),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Interstitial|Caffeine|Concentration
P_4103 = P_3868;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Interstitial|Caffeine|Partition coefficient (water/container)
P_4104 = (P_2066*P_1553*P_2067*P_3651);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Intracellular|CYP1A2|Start amount
P_4105 = (IIf((P_3652 > 0),(y(149)/P_3652),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Intracellular|Caffeine|Concentration
P_4106 = P_3867;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Intracellular|Caffeine|Partition coefficient (water/container)
P_4107 = (IIf((P_3652 > 0),(y(150)/P_3652),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_4108 = (P_856*(1-P_42)*(P_876-P_3653));  % CoffeinSimulation|Organism|LargeIntestine|Plasma|Volume
P_4109 = (P_856*P_42*(P_876-P_3653));  % CoffeinSimulation|Organism|LargeIntestine|BloodCells|Volume
P_4110 = (P_864*(P_876-P_3653));  % CoffeinSimulation|Organism|LargeIntestine|Interstitial|Volume
P_4111 = P_3818;  % CoffeinSimulation|Organism|LargeIntestine|Interstitial|Caffeine|Partition coefficient (water/container)
P_4112 = (P_876-P_3653);  % CoffeinSimulation|Organism|LargeIntestine|Intracellular|Volume of protein container
P_4113 = (P_2072*(P_876-P_3653));  % CoffeinSimulation|Organism|LargeIntestine|Intracellular|Volume
P_4114 = P_3817;  % CoffeinSimulation|Organism|LargeIntestine|Intracellular|Caffeine|Partition coefficient (water/container)
P_4115 = (P_3870*P_17);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Volume (endothelium)
P_4116 = (P_3654*(P_2950/P_876));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Lymph flow rate
P_4117 = P_3658;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Plasma|Volume of protein container
P_4118 = (IIf((P_3658 > 0),(y(158)/P_3658),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Plasma|Caffeine|Concentration
P_4119 = (IIf((P_3658 > 0),(y(159)/P_3658),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_4120 = P_3659;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|BloodCells|Volume of protein container
P_4121 = (IIf((P_3659 > 0),(y(160)/P_3659),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|BloodCells|Caffeine|Concentration
P_4122 = (IIf((P_3659 > 0),(y(161)/P_3659),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_4123 = P_3661;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Interstitial|Volume of protein container
P_4124 = (IIf((P_3661 > 0),(y(162)/P_3661),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Interstitial|Caffeine|Concentration
P_4125 = P_3872;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Interstitial|Caffeine|Partition coefficient (water/container)
P_4126 = (P_2100*P_1553*P_2101*P_3662);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Intracellular|CYP1A2|Start amount
P_4127 = (IIf((P_3663 > 0),(y(163)/P_3663),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Intracellular|Caffeine|Concentration
P_4128 = P_3871;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Intracellular|Caffeine|Partition coefficient (water/container)
P_4129 = (IIf((P_3663 > 0),(y(164)/P_3663),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_4130 = (P_3654*(P_2960/P_876));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Lymph flow rate
P_4131 = (P_3877*P_17);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Volume (endothelium)
P_4132 = P_3666;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Plasma|Volume of protein container
P_4133 = (IIf((P_3666 > 0),(y(165)/P_3666),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Plasma|Caffeine|Concentration
P_4134 = (IIf((P_3666 > 0),(y(166)/P_3666),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_4135 = P_3667;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|BloodCells|Volume of protein container
P_4136 = (IIf((P_3667 > 0),(y(167)/P_3667),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|BloodCells|Caffeine|Concentration
P_4137 = (IIf((P_3667 > 0),(y(168)/P_3667),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_4138 = P_3669;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Interstitial|Volume of protein container
P_4139 = (IIf((P_3669 > 0),(y(169)/P_3669),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Interstitial|Caffeine|Concentration
P_4140 = P_3876;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Interstitial|Caffeine|Partition coefficient (water/container)
P_4141 = (P_2116*P_1553*P_2117*P_3670);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Intracellular|CYP1A2|Start amount
P_4142 = (IIf((P_3671 > 0),(y(170)/P_3671),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Intracellular|Caffeine|Concentration
P_4143 = P_3875;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Intracellular|Caffeine|Partition coefficient (water/container)
P_4144 = (IIf((P_3671 > 0),(y(171)/P_3671),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_4145 = (P_3654*(P_2970/P_876));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Lymph flow rate
P_4146 = (P_3878*P_17);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Volume (endothelium)
P_4147 = P_3674;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Plasma|Volume of protein container
P_4148 = (IIf((P_3674 > 0),(y(172)/P_3674),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Plasma|Caffeine|Concentration
P_4149 = (IIf((P_3674 > 0),(y(173)/P_3674),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_4150 = P_3675;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|BloodCells|Volume of protein container
P_4151 = (IIf((P_3675 > 0),(y(174)/P_3675),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|BloodCells|Caffeine|Concentration
P_4152 = (IIf((P_3675 > 0),(y(175)/P_3675),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_4153 = P_3677;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Interstitial|Volume of protein container
P_4154 = (IIf((P_3677 > 0),(y(176)/P_3677),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Interstitial|Caffeine|Concentration
P_4155 = P_3880;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Interstitial|Caffeine|Partition coefficient (water/container)
P_4156 = (P_2132*P_1553*P_2134*P_3678);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Intracellular|CYP1A2|Start amount
P_4157 = (IIf((P_3679 > 0),(y(177)/P_3679),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Intracellular|Caffeine|Concentration
P_4158 = P_3879;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Intracellular|Caffeine|Partition coefficient (water/container)
P_4159 = (IIf((P_3679 > 0),(y(178)/P_3679),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_4160 = (P_3885*P_17);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Volume (endothelium)
P_4161 = (P_3654*(P_2980/P_876));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Lymph flow rate
P_4162 = P_3682;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Plasma|Volume of protein container
P_4163 = (IIf((P_3682 > 0),(y(179)/P_3682),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Plasma|Caffeine|Concentration
P_4164 = (IIf((P_3682 > 0),(y(180)/P_3682),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_4165 = P_3683;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|BloodCells|Volume of protein container
P_4166 = (IIf((P_3683 > 0),(y(181)/P_3683),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|BloodCells|Caffeine|Concentration
P_4167 = (IIf((P_3683 > 0),(y(182)/P_3683),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_4168 = P_3685;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Interstitial|Volume of protein container
P_4169 = (IIf((P_3685 > 0),(y(183)/P_3685),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Interstitial|Caffeine|Concentration
P_4170 = P_3883;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Interstitial|Caffeine|Partition coefficient (water/container)
P_4171 = (P_2148*P_1553*P_2149*P_3686);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Intracellular|CYP1A2|Start amount
P_4172 = (IIf((P_3687 > 0),(y(184)/P_3687),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Intracellular|Caffeine|Concentration
P_4173 = P_3882;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Intracellular|Caffeine|Partition coefficient (water/container)
P_4174 = (IIf((P_3687 > 0),(y(185)/P_3687),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_4175 = (P_3889*P_17);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Volume (endothelium)
P_4176 = (P_3654*(P_2990/P_876));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Lymph flow rate
P_4177 = P_3690;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Plasma|Volume of protein container
P_4178 = (IIf((P_3690 > 0),(y(186)/P_3690),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Plasma|Caffeine|Concentration
P_4179 = (IIf((P_3690 > 0),(y(187)/P_3690),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_4180 = P_3691;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|BloodCells|Volume of protein container
P_4181 = (IIf((P_3691 > 0),(y(188)/P_3691),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|BloodCells|Caffeine|Concentration
P_4182 = (IIf((P_3691 > 0),(y(189)/P_3691),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_4183 = P_3693;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Interstitial|Volume of protein container
P_4184 = (IIf((P_3693 > 0),(y(190)/P_3693),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Interstitial|Caffeine|Concentration
P_4185 = P_3887;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Interstitial|Caffeine|Partition coefficient (water/container)
P_4186 = (P_2164*P_1553*P_2165*P_3694);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Intracellular|CYP1A2|Start amount
P_4187 = (IIf((P_3695 > 0),(y(191)/P_3695),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Intracellular|Caffeine|Concentration
P_4188 = P_3886;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Intracellular|Caffeine|Partition coefficient (water/container)
P_4189 = (IIf((P_3695 > 0),(y(192)/P_3695),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_4190 = (P_3893*P_17);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Volume (endothelium)
P_4191 = (P_3654*(P_3000/P_876));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Lymph flow rate
P_4192 = P_3698;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Plasma|Volume of protein container
P_4193 = (IIf((P_3698 > 0),(y(193)/P_3698),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Plasma|Caffeine|Concentration
P_4194 = (IIf((P_3698 > 0),(y(194)/P_3698),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_4195 = P_3699;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|BloodCells|Volume of protein container
P_4196 = (IIf((P_3699 > 0),(y(195)/P_3699),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|BloodCells|Caffeine|Concentration
P_4197 = (IIf((P_3699 > 0),(y(196)/P_3699),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_4198 = P_3701;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Interstitial|Volume of protein container
P_4199 = (IIf((P_3701 > 0),(y(197)/P_3701),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Interstitial|Caffeine|Concentration
P_4200 = P_3892;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Interstitial|Caffeine|Partition coefficient (water/container)
P_4201 = (P_2180*P_1553*P_2182*P_3702);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Intracellular|CYP1A2|Start amount
P_4202 = (IIf((P_3703 > 0),(y(198)/P_3703),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Intracellular|Caffeine|Concentration
P_4203 = P_3891;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Intracellular|Caffeine|Partition coefficient (water/container)
P_4204 = (IIf((P_3703 > 0),(y(199)/P_3703),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_4205 = (P_1117*(1-P_1126)*P_3704*((P_1151/P_1119)^(P_16+(-1))));  % CoffeinSimulation|Organism|Liver|Fluid recirculation flow rate
P_4206 = (P_3704*(IIf(P_1115,P_1116,1)));  % CoffeinSimulation|Organism|Liver|Periportal|Lymph flow rate
P_4207 = (P_3016*P_1553*P_2220*P_3707);  % CoffeinSimulation|Organism|Liver|Periportal|Plasma|CYP1A2|Start amount
P_4208 = (P_3021*P_1553*P_2225*P_3710);  % CoffeinSimulation|Organism|Liver|Periportal|BloodCells|CYP1A2|Start amount
P_4209 = P_3822;  % CoffeinSimulation|Organism|Liver|Periportal|Interstitial|Caffeine|Partition coefficient (water/container)
P_4210 = P_3717;  % CoffeinSimulation|Organism|Liver|Periportal|Intracellular|CYP1A2
P_4211 = (IIf((P_3716 > 0),(y(205)/P_3716),0));  % CoffeinSimulation|Organism|Liver|Periportal|Intracellular|Caffeine|Concentration
P_4212 = P_3819;  % CoffeinSimulation|Organism|Liver|Periportal|Intracellular|Caffeine|Partition coefficient (water/container)
P_4213 = (IIf((P_3716 > 0),(y(206)/P_3716),0));  % CoffeinSimulation|Organism|Liver|Periportal|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_4214 = (P_3704*(IIf(P_1115,(1-P_1116),0)));  % CoffeinSimulation|Organism|Liver|Pericentral|Lymph flow rate
P_4215 = (P_3031*P_1553*P_2268*P_3720);  % CoffeinSimulation|Organism|Liver|Pericentral|Plasma|CYP1A2|Start amount
P_4216 = (P_3036*P_1553*P_2274*P_3723);  % CoffeinSimulation|Organism|Liver|Pericentral|BloodCells|CYP1A2|Start amount
P_4217 = P_3822;  % CoffeinSimulation|Organism|Liver|Pericentral|Interstitial|Caffeine|Partition coefficient (water/container)
P_4218 = P_3730;  % CoffeinSimulation|Organism|Liver|Pericentral|Intracellular|CYP1A2
P_4219 = (IIf((P_3729 > 0),(y(212)/P_3729),0));  % CoffeinSimulation|Organism|Liver|Pericentral|Intracellular|Caffeine|Concentration
P_4220 = P_3819;  % CoffeinSimulation|Organism|Liver|Pericentral|Intracellular|Caffeine|Partition coefficient (water/container)
P_4221 = (IIf((P_3729 > 0),(y(213)/P_3729),0));  % CoffeinSimulation|Organism|Liver|Pericentral|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_4222 = (P_1172*P_3731*(1-P_42));  % CoffeinSimulation|Organism|Lung|Lymph flow rate
P_4223 = P_3732;  % CoffeinSimulation|Organism|Lung|Plasma|CYP1A2
P_4224 = P_3733;  % CoffeinSimulation|Organism|Lung|BloodCells|CYP1A2
P_4225 = P_3830;  % CoffeinSimulation|Organism|Lung|Interstitial|Caffeine|Partition coefficient (water/container)
P_4226 = (IIf((P_3059 > 0),(P_3735/P_3059),0));  % CoffeinSimulation|Organism|Lung|Intracellular|CYP1A2|Concentration
P_4227 = P_3827;  % CoffeinSimulation|Organism|Lung|Intracellular|Caffeine|Partition coefficient (water/container)
P_4228 = (P_1212*(1-P_1221)*P_3738*((P_1228/P_1213)^(P_16+(-1))));  % CoffeinSimulation|Organism|Muscle|Fluid recirculation flow rate
P_4229 = P_3739;  % CoffeinSimulation|Organism|Muscle|Plasma|CYP1A2
P_4230 = P_3740;  % CoffeinSimulation|Organism|Muscle|BloodCells|CYP1A2
P_4231 = P_3834;  % CoffeinSimulation|Organism|Muscle|Interstitial|Caffeine|Partition coefficient (water/container)
P_4232 = (IIf((P_3080 > 0),(P_3742/P_3080),0));  % CoffeinSimulation|Organism|Muscle|Intracellular|CYP1A2|Concentration
P_4233 = P_3833;  % CoffeinSimulation|Organism|Muscle|Intracellular|Caffeine|Partition coefficient (water/container)
P_4234 = (P_1255*(1-P_1260)*P_3745*((P_1285/P_1257)^(P_16+(-1))));  % CoffeinSimulation|Organism|Pancreas|Fluid recirculation flow rate
P_4235 = P_3746;  % CoffeinSimulation|Organism|Pancreas|Plasma|CYP1A2
P_4236 = P_3747;  % CoffeinSimulation|Organism|Pancreas|BloodCells|CYP1A2
P_4237 = P_3838;  % CoffeinSimulation|Organism|Pancreas|Interstitial|Caffeine|Partition coefficient (water/container)
P_4238 = (IIf((P_3101 > 0),(P_3749/P_3101),0));  % CoffeinSimulation|Organism|Pancreas|Intracellular|CYP1A2|Concentration
P_4239 = P_3836;  % CoffeinSimulation|Organism|Pancreas|Intracellular|Caffeine|Partition coefficient (water/container)
P_4240 = (P_3603+P_3610+P_3654+P_3745+P_3763);  % CoffeinSimulation|Organism|PortalVein|Lymph flow rate
P_4241 = P_3753;  % CoffeinSimulation|Organism|PortalVein|Plasma|CYP1A2
P_4242 = P_3754;  % CoffeinSimulation|Organism|PortalVein|BloodCells|CYP1A2
P_4243 = (P_1305*(1-P_1312)*P_3756*((P_1336/P_1307)^(P_16+(-1))));  % CoffeinSimulation|Organism|Skin|Fluid recirculation flow rate
P_4244 = P_3757;  % CoffeinSimulation|Organism|Skin|Plasma|CYP1A2
P_4245 = P_3758;  % CoffeinSimulation|Organism|Skin|BloodCells|CYP1A2
P_4246 = P_3845;  % CoffeinSimulation|Organism|Skin|Interstitial|Caffeine|Partition coefficient (water/container)
P_4247 = (IIf((P_3135 > 0),(P_3760/P_3135),0));  % CoffeinSimulation|Organism|Skin|Intracellular|CYP1A2|Concentration
P_4248 = P_3844;  % CoffeinSimulation|Organism|Skin|Intracellular|Caffeine|Partition coefficient (water/container)
P_4249 = (P_1348*(1-P_1355)*P_3763*((P_1378/P_1350)^(P_16+(-1))));  % CoffeinSimulation|Organism|Spleen|Fluid recirculation flow rate
P_4250 = P_3764;  % CoffeinSimulation|Organism|Spleen|Plasma|CYP1A2
P_4251 = P_3765;  % CoffeinSimulation|Organism|Spleen|BloodCells|CYP1A2
P_4252 = P_3849;  % CoffeinSimulation|Organism|Spleen|Interstitial|Caffeine|Partition coefficient (water/container)
P_4253 = (IIf((P_3156 > 0),(P_3767/P_3156),0));  % CoffeinSimulation|Organism|Spleen|Intracellular|CYP1A2|Concentration
P_4254 = P_3847;  % CoffeinSimulation|Organism|Spleen|Intracellular|Caffeine|Partition coefficient (water/container)
P_4255 = (P_3771*P_2406);  % CoffeinSimulation|Neighborhoods|Bone_int_Bone_cell|Caffeine|P*SA intracellular -> interstitial
P_4256 = (P_3772*P_2406);  % CoffeinSimulation|Neighborhoods|Bone_int_Bone_cell|Caffeine|P*SA interstitial -> intracellular
P_4257 = (P_3775*P_2410);  % CoffeinSimulation|Neighborhoods|Brain_int_Brain_cell|Caffeine|P*SA intracellular -> interstitial
P_4258 = (P_3776*P_2410);  % CoffeinSimulation|Neighborhoods|Brain_int_Brain_cell|Caffeine|P*SA interstitial -> intracellular
P_4259 = (P_3780*P_2413);  % CoffeinSimulation|Neighborhoods|Fat_int_Fat_cell|Caffeine|P*SA intracellular -> interstitial
P_4260 = (P_3781*P_2413);  % CoffeinSimulation|Neighborhoods|Fat_int_Fat_cell|Caffeine|P*SA interstitial -> intracellular
P_4261 = (P_3784*P_2415);  % CoffeinSimulation|Neighborhoods|Gonads_int_Gonads_cell|Caffeine|P*SA intracellular -> interstitial
P_4262 = (P_3785*P_2415);  % CoffeinSimulation|Neighborhoods|Gonads_int_Gonads_cell|Caffeine|P*SA interstitial -> intracellular
P_4263 = (P_3789*P_2420);  % CoffeinSimulation|Neighborhoods|Heart_int_Heart_cell|Caffeine|P*SA interstitial -> intracellular
P_4264 = (P_3787*P_2420);  % CoffeinSimulation|Neighborhoods|Heart_int_Heart_cell|Caffeine|P*SA intracellular -> interstitial
P_4265 = P_3855;  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|Partition coefficient (intracellular/water)
P_4266 = (P_3796*P_2427);  % CoffeinSimulation|Neighborhoods|Kidney_int_Kidney_cell|Caffeine|P*SA intracellular -> interstitial
P_4267 = (P_3795*P_2427);  % CoffeinSimulation|Neighborhoods|Kidney_int_Kidney_cell|Caffeine|P*SA interstitial -> intracellular
P_4268 = P_3794;  % CoffeinSimulation|Neighborhoods|Kidney_cell_Kidney_ur|Caffeine|Partition coefficient (intracellular/water)
P_4269 = P_3858;  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|Partition coefficient (intracellular/water)
P_4270 = (P_3802*P_2439);  % CoffeinSimulation|Neighborhoods|Stomach_int_Stomach_cell|Caffeine|P*SA interstitial -> intracellular
P_4271 = (P_3801*P_2439);  % CoffeinSimulation|Neighborhoods|Stomach_int_Stomach_cell|Caffeine|P*SA intracellular -> interstitial
P_4272 = P_3863;  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|Partition coefficient (intracellular/water)
P_4273 = ((((P_640-P_3611)*90.09009009009009)^0.75)*100000);  % CoffeinSimulation|Neighborhoods|SmallIntestine_int_SmallIntestine_cell|Surface area (interstitial/intracellular)
P_4274 = (P_0*P_620*(P_640-P_3611));  % CoffeinSimulation|Neighborhoods|SmallIntestine_pls_SmallIntestine_int|Surface area (plasma/interstitial)
P_4275 = (P_42*P_26*0.6*(P_640-P_3611)*P_620);  % CoffeinSimulation|Neighborhoods|SmallIntestine_pls_SmallIntestine_bc|Surface area (blood cells/plasma)
P_4276 = P_3867;  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|Partition coefficient (intracellular/water)
P_4277 = (P_42*P_26*0.6*(P_876-P_3653)*P_856);  % CoffeinSimulation|Neighborhoods|LargeIntestine_pls_LargeIntestine_bc|Surface area (blood cells/plasma)
P_4278 = ((((P_876-P_3653)*90.09009009009009)^0.75)*100000);  % CoffeinSimulation|Neighborhoods|LargeIntestine_int_LargeIntestine_cell|Surface area (interstitial/intracellular)
P_4279 = (P_0*P_856*(P_876-P_3653));  % CoffeinSimulation|Neighborhoods|LargeIntestine_pls_LargeIntestine_int|Surface area (plasma/interstitial)
P_4280 = (P_3820*P_3246);  % CoffeinSimulation|Neighborhoods|Periportal_int_Periportal_cell|Caffeine|P*SA interstitial -> intracellular
P_4281 = (P_3821*P_3246);  % CoffeinSimulation|Neighborhoods|Periportal_int_Periportal_cell|Caffeine|P*SA intracellular -> interstitial
P_4282 = (P_3823*P_3248);  % CoffeinSimulation|Neighborhoods|Pericentral_int_Pericentral_cell|Caffeine|P*SA interstitial -> intracellular
P_4283 = (P_3824*P_3248);  % CoffeinSimulation|Neighborhoods|Pericentral_int_Pericentral_cell|Caffeine|P*SA intracellular -> interstitial
P_4284 = (P_3828*P_2458);  % CoffeinSimulation|Neighborhoods|Lung_int_Lung_cell|Caffeine|P*SA interstitial -> intracellular
P_4285 = (P_3829*P_2458);  % CoffeinSimulation|Neighborhoods|Lung_int_Lung_cell|Caffeine|P*SA intracellular -> interstitial
P_4286 = (P_3831*P_2460);  % CoffeinSimulation|Neighborhoods|Muscle_int_Muscle_cell|Caffeine|P*SA interstitial -> intracellular
P_4287 = (P_3832*P_2460);  % CoffeinSimulation|Neighborhoods|Muscle_int_Muscle_cell|Caffeine|P*SA intracellular -> interstitial
P_4288 = (P_3837*P_2464);  % CoffeinSimulation|Neighborhoods|Pancreas_int_Pancreas_cell|Caffeine|P*SA intracellular -> interstitial
P_4289 = (P_3835*P_2464);  % CoffeinSimulation|Neighborhoods|Pancreas_int_Pancreas_cell|Caffeine|P*SA interstitial -> intracellular
P_4290 = P_3891;  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|Partition coefficient (intracellular/water)
P_4291 = (P_3843*P_2474);  % CoffeinSimulation|Neighborhoods|Skin_int_Skin_cell|Caffeine|P*SA intracellular -> interstitial
P_4292 = (P_3842*P_2474);  % CoffeinSimulation|Neighborhoods|Skin_int_Skin_cell|Caffeine|P*SA interstitial -> intracellular
P_4293 = (P_3848*P_2477);  % CoffeinSimulation|Neighborhoods|Spleen_int_Spleen_cell|Caffeine|P*SA interstitial -> intracellular
P_4294 = (P_3846*P_2477);  % CoffeinSimulation|Neighborhoods|Spleen_int_Spleen_cell|Caffeine|P*SA intracellular -> interstitial
P_4295 = (P_3539/P_353);  % CoffeinSimulation|Neighborhoods|Duodenum_int_Duodenum_cell|Surface area (interstitial/intracellular)
P_4296 = (P_3545/P_374);  % CoffeinSimulation|Neighborhoods|UpperJejunum_int_UpperJejunum_cell|Surface area (interstitial/intracellular)
P_4297 = (P_3551/P_398);  % CoffeinSimulation|Neighborhoods|LowerJejunum_int_LowerJejunum_cell|Surface area (interstitial/intracellular)
P_4298 = (P_3555/P_416);  % CoffeinSimulation|Neighborhoods|UpperIleum_int_UpperIleum_cell|Surface area (interstitial/intracellular)
P_4299 = (P_3562/P_431);  % CoffeinSimulation|Neighborhoods|LowerIleum_int_LowerIleum_cell|Surface area (interstitial/intracellular)
P_4300 = (P_3568/P_455);  % CoffeinSimulation|Neighborhoods|Caecum_int_Caecum_cell|Surface area (interstitial/intracellular)
P_4301 = (P_3574/P_471);  % CoffeinSimulation|Neighborhoods|ColonAscendens_int_ColonAscendens_cell|Surface area (interstitial/intracellular)
P_4302 = (P_3579/P_493);  % CoffeinSimulation|Neighborhoods|ColonTransversum_int_ColonTransversum_cell|Surface area (interstitial/intracellular)
P_4303 = (P_3585/P_512);  % CoffeinSimulation|Neighborhoods|ColonDescendens_int_ColonDescendens_cell|Surface area (interstitial/intracellular)
P_4304 = (P_3592/P_534);  % CoffeinSimulation|Neighborhoods|ColonSigmoid_int_ColonSigmoid_cell|Surface area (interstitial/intracellular)
P_4305 = (P_3597/P_546);  % CoffeinSimulation|Neighborhoods|Rectum_int_Rectum_cell|Surface area (interstitial/intracellular)
P_4306 = P_3886;  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|Partition coefficient (intracellular/water)
P_4307 = P_3852;  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|Partition coefficient (intracellular/water)
P_4308 = P_3882;  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|Partition coefficient (intracellular/water)
P_4309 = P_3871;  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|Partition coefficient (intracellular/water)
P_4310 = P_3879;  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|Partition coefficient (intracellular/water)
P_4311 = P_3875;  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|Partition coefficient (intracellular/water)
P_4312 = (IIf((P_3914 > 0),(P_3913/P_3914),0));  % CoffeinSimulation|Caffeine|Mucosa permeability scale factor (transcellular)
P_4313 = (P_3409+P_3400+P_3917);  % CoffeinSimulation|Caffeine|pKa_Base_0
P_4314 = (P_3408+P_3405+P_3920);  % CoffeinSimulation|Caffeine|pKa_Acid_0
P_4315 = (P_3435+P_3426+P_3922);  % CoffeinSimulation|CYP1A2|pKa_Base_0
P_4316 = (P_3434+P_3431+P_3925);  % CoffeinSimulation|CYP1A2|pKa_Acid_0
P_4317 = (P_3461+P_3452+P_3927);  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_Base_0
P_4318 = (P_3460+P_3457+P_3930);  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_Acid_0
P_4319 = (P_1669+P_1685+P_1706+P_3658+P_3666+P_3682+P_3690+P_3674+P_3615+P_1727+P_1748+P_1769+P_1790+P_4108+P_3647+P_3631+P_2288+P_2309+P_2330+P_3029+P_3014+P_2350+P_3698+P_2364+P_4026+P_2385+P_1953+P_3639+P_3623+P_1656);  % CoffeinSimulation|Organism|Volume (plasma)
P_4320 = (IIf((P_34 > 0),(P_3931/(P_34^2)),0));  % CoffeinSimulation|Organism|BMI
P_4321 = (1.6667*(P_3931^0.5)*((P_34*10)^0.5));  % CoffeinSimulation|Organism|BSA
P_4322 = (IIf((P_1656 > 0),(P_3932/P_1656),0));  % CoffeinSimulation|Organism|VenousBlood|Plasma|CYP1A2|Concentration
P_4323 = (IIf((P_1662 > 0),(P_3933/P_1662),0));  % CoffeinSimulation|Organism|VenousBlood|BloodCells|CYP1A2|Concentration
P_4324 = (IIf((P_1669 > 0),(P_3934/P_1669),0));  % CoffeinSimulation|Organism|ArterialBlood|Plasma|CYP1A2|Concentration
P_4325 = (IIf((P_1675 > 0),(P_3935/P_1675),0));  % CoffeinSimulation|Organism|ArterialBlood|BloodCells|CYP1A2|Concentration
P_4326 = (IIf((P_1685 > 0),(P_3937/P_1685),0));  % CoffeinSimulation|Organism|Bone|Plasma|CYP1A2|Concentration
P_4327 = (IIf((P_1691 > 0),(P_3938/P_1691),0));  % CoffeinSimulation|Organism|Bone|BloodCells|CYP1A2|Concentration
P_4328 = (IIf((P_1706 > 0),(P_3943/P_1706),0));  % CoffeinSimulation|Organism|Brain|Plasma|CYP1A2|Concentration
P_4329 = (IIf((P_1712 > 0),(P_3944/P_1712),0));  % CoffeinSimulation|Organism|Brain|BloodCells|CYP1A2|Concentration
P_4330 = (IIf((P_1727 > 0),(P_3949/P_1727),0));  % CoffeinSimulation|Organism|Fat|Plasma|CYP1A2|Concentration
P_4331 = (IIf((P_1733 > 0),(P_3950/P_1733),0));  % CoffeinSimulation|Organism|Fat|BloodCells|CYP1A2|Concentration
P_4332 = (IIf((P_1748 > 0),(P_3955/P_1748),0));  % CoffeinSimulation|Organism|Gonads|Plasma|CYP1A2|Concentration
P_4333 = (IIf((P_1754 > 0),(P_3956/P_1754),0));  % CoffeinSimulation|Organism|Gonads|BloodCells|CYP1A2|Concentration
P_4334 = (IIf((P_1769 > 0),(P_3961/P_1769),0));  % CoffeinSimulation|Organism|Heart|Plasma|CYP1A2|Concentration
P_4335 = (IIf((P_1775 > 0),(P_3962/P_1775),0));  % CoffeinSimulation|Organism|Heart|BloodCells|CYP1A2|Concentration
P_4336 = (IIf((P_1790 > 0),(P_3967/P_1790),0));  % CoffeinSimulation|Organism|Kidney|Plasma|CYP1A2|Concentration
P_4337 = (IIf((P_1796 > 0),(P_3968/P_1796),0));  % CoffeinSimulation|Organism|Kidney|BloodCells|CYP1A2|Concentration
P_4338 = (IIf((P_1812 > 0),(P_3973/P_1812),0));  % CoffeinSimulation|Organism|Lumen|Stomach|CYP1A2|Concentration
P_4339 = (P_1537*(P_3916/P_3974));  % CoffeinSimulation|Organism|Lumen|Stomach|Caffeine|Solubility
P_4340 = (IIf((P_3975 < 0.9),1,(1/(1+(exp(((P_3975+(-1))*100)))))));  % CoffeinSimulation|Organism|Lumen|Duodenum|FillLevelFlag
P_4341 = P_3977;  % CoffeinSimulation|Organism|Lumen|Duodenum|CYP1A2
P_4342 = (IIf((P_3979 < 0.9),1,(1/(1+(exp(((P_3979+(-1))*100)))))));  % CoffeinSimulation|Organism|Lumen|UpperJejunum|FillLevelFlag
P_4343 = P_3981;  % CoffeinSimulation|Organism|Lumen|UpperJejunum|CYP1A2
P_4344 = (IIf((P_3984 < 0.9),1,(1/(1+(exp(((P_3984+(-1))*100)))))));  % CoffeinSimulation|Organism|Lumen|LowerJejunum|FillLevelFlag
P_4345 = P_3985;  % CoffeinSimulation|Organism|Lumen|LowerJejunum|CYP1A2
P_4346 = (IIf((P_3988 < 0.9),1,(1/(1+(exp(((P_3988+(-1))*100)))))));  % CoffeinSimulation|Organism|Lumen|UpperIleum|FillLevelFlag
P_4347 = P_3989;  % CoffeinSimulation|Organism|Lumen|UpperIleum|CYP1A2
P_4348 = (IIf((P_3992 < 0.9),1,(1/(1+(exp(((P_3992+(-1))*100)))))));  % CoffeinSimulation|Organism|Lumen|LowerIleum|FillLevelFlag
P_4349 = P_3993;  % CoffeinSimulation|Organism|Lumen|LowerIleum|CYP1A2
P_4350 = (IIf((P_3996 < 0.9),1,(1/(1+(exp(((P_3996+(-1))*100)))))));  % CoffeinSimulation|Organism|Lumen|Caecum|FillLevelFlag
P_4351 = P_3997;  % CoffeinSimulation|Organism|Lumen|Caecum|CYP1A2
P_4352 = (IIf((P_4000 < 0.9),1,(1/(1+(exp(((P_4000+(-1))*100)))))));  % CoffeinSimulation|Organism|Lumen|ColonAscendens|FillLevelFlag
P_4353 = P_4001;  % CoffeinSimulation|Organism|Lumen|ColonAscendens|CYP1A2
P_4354 = (IIf((P_4003 < 0.9),1,(1/(1+(exp(((P_4003+(-1))*100)))))));  % CoffeinSimulation|Organism|Lumen|ColonTransversum|FillLevelFlag
P_4355 = P_4005;  % CoffeinSimulation|Organism|Lumen|ColonTransversum|CYP1A2
P_4356 = (IIf((P_4008 < 0.9),1,(1/(1+(exp(((P_4008+(-1))*100)))))));  % CoffeinSimulation|Organism|Lumen|ColonDescendens|FillLevelFlag
P_4357 = P_4009;  % CoffeinSimulation|Organism|Lumen|ColonDescendens|CYP1A2
P_4358 = (IIf((P_4011 < 0.9),1,(1/(1+(exp(((P_4011+(-1))*100)))))));  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|FillLevelFlag
P_4359 = P_4013;  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|CYP1A2
P_4360 = (IIf((P_4016 < 0.9),1,(1/(1+(exp(((P_4016+(-1))*100)))))));  % CoffeinSimulation|Organism|Lumen|Rectum|FillLevelFlag
P_4361 = P_4018;  % CoffeinSimulation|Organism|Lumen|Rectum|CYP1A2
P_4362 = (IIf((P_1953 > 0),(P_4021/P_1953),0));  % CoffeinSimulation|Organism|Stomach|Plasma|CYP1A2|Concentration
P_4363 = (IIf((P_1959 > 0),(P_4022/P_1959),0));  % CoffeinSimulation|Organism|Stomach|BloodCells|CYP1A2|Concentration
P_4364 = (P_4274*P_17);  % CoffeinSimulation|Organism|SmallIntestine|Volume (endothelium)
P_4365 = (P_3610-(P_4033+P_4048+P_4064+P_4079+P_4094));  % CoffeinSimulation|Organism|SmallIntestine|Lymph flow rate
P_4366 = P_4026;  % CoffeinSimulation|Organism|SmallIntestine|Plasma|Volume of protein container
P_4367 = (IIf((P_4026 > 0),(y(109)/P_4026),0));  % CoffeinSimulation|Organism|SmallIntestine|Plasma|Caffeine|Concentration
P_4368 = (IIf((P_4026 > 0),(y(110)/P_4026),0));  % CoffeinSimulation|Organism|SmallIntestine|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_4369 = P_4027;  % CoffeinSimulation|Organism|SmallIntestine|BloodCells|Volume of protein container
P_4370 = (IIf((P_4027 > 0),(y(111)/P_4027),0));  % CoffeinSimulation|Organism|SmallIntestine|BloodCells|Caffeine|Concentration
P_4371 = (IIf((P_4027 > 0),(y(112)/P_4027),0));  % CoffeinSimulation|Organism|SmallIntestine|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_4372 = P_4028;  % CoffeinSimulation|Organism|SmallIntestine|Interstitial|Volume of protein container
P_4373 = (IIf((P_4028 > 0),(y(113)/P_4028),0));  % CoffeinSimulation|Organism|SmallIntestine|Interstitial|Caffeine|Concentration
P_4374 = (P_1986*P_1553*P_1987*P_4030);  % CoffeinSimulation|Organism|SmallIntestine|Intracellular|CYP1A2|Start amount
P_4375 = (IIf((P_4031 > 0),(y(114)/P_4031),0));  % CoffeinSimulation|Organism|SmallIntestine|Intracellular|Caffeine|Concentration
P_4376 = (IIf((P_4031 > 0),(y(115)/P_4031),0));  % CoffeinSimulation|Organism|SmallIntestine|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_4377 = (P_2892*P_1553*P_1994*P_4035);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Plasma|CYP1A2|Start amount
P_4378 = (P_2896*P_1553*P_1998*P_4038);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|BloodCells|CYP1A2|Start amount
P_4379 = P_4044;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Intracellular|CYP1A2
P_4380 = (P_2902*P_1553*P_2009*P_4050);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Plasma|CYP1A2|Start amount
P_4381 = (P_2906*P_1553*P_2014*P_4053);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|BloodCells|CYP1A2|Start amount
P_4382 = P_4059;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Intracellular|CYP1A2
P_4383 = (P_2912*P_1553*P_2026*P_4065);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Plasma|CYP1A2|Start amount
P_4384 = (P_2916*P_1553*P_2030*P_4068);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|BloodCells|CYP1A2|Start amount
P_4385 = P_4074;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Intracellular|CYP1A2
P_4386 = (P_2922*P_1553*P_2041*P_4080);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Plasma|CYP1A2|Start amount
P_4387 = (P_2926*P_1553*P_2046*P_4083);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|BloodCells|CYP1A2|Start amount
P_4388 = P_4089;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Intracellular|CYP1A2
P_4389 = (P_2932*P_1553*P_2058*P_4095);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Plasma|CYP1A2|Start amount
P_4390 = (P_2936*P_1553*P_2062*P_4098);  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|BloodCells|CYP1A2|Start amount
P_4391 = P_4104;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Intracellular|CYP1A2
P_4392 = (P_3654-(P_4116+P_4130+P_4145+P_4161+P_4176+P_4191));  % CoffeinSimulation|Organism|LargeIntestine|Lymph flow rate
P_4393 = (P_4279*P_17);  % CoffeinSimulation|Organism|LargeIntestine|Volume (endothelium)
P_4394 = P_4108;  % CoffeinSimulation|Organism|LargeIntestine|Plasma|Volume of protein container
P_4395 = (IIf((P_4108 > 0),(y(151)/P_4108),0));  % CoffeinSimulation|Organism|LargeIntestine|Plasma|Caffeine|Concentration
P_4396 = (IIf((P_4108 > 0),(y(152)/P_4108),0));  % CoffeinSimulation|Organism|LargeIntestine|Plasma|Caffeine-CYP1A2 Metabolite|Concentration
P_4397 = P_4109;  % CoffeinSimulation|Organism|LargeIntestine|BloodCells|Volume of protein container
P_4398 = (IIf((P_4109 > 0),(y(153)/P_4109),0));  % CoffeinSimulation|Organism|LargeIntestine|BloodCells|Caffeine|Concentration
P_4399 = (IIf((P_4109 > 0),(y(154)/P_4109),0));  % CoffeinSimulation|Organism|LargeIntestine|BloodCells|Caffeine-CYP1A2 Metabolite|Concentration
P_4400 = P_4110;  % CoffeinSimulation|Organism|LargeIntestine|Interstitial|Volume of protein container
P_4401 = (IIf((P_4110 > 0),(y(155)/P_4110),0));  % CoffeinSimulation|Organism|LargeIntestine|Interstitial|Caffeine|Concentration
P_4402 = (P_2084*P_1553*P_2086*P_4112);  % CoffeinSimulation|Organism|LargeIntestine|Intracellular|CYP1A2|Start amount
P_4403 = (IIf((P_4113 > 0),(y(156)/P_4113),0));  % CoffeinSimulation|Organism|LargeIntestine|Intracellular|Caffeine|Concentration
P_4404 = (IIf((P_4113 > 0),(y(157)/P_4113),0));  % CoffeinSimulation|Organism|LargeIntestine|Intracellular|Caffeine-CYP1A2 Metabolite|Concentration
P_4405 = (P_2952*P_1553*P_2091*P_4117);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Plasma|CYP1A2|Start amount
P_4406 = (P_2956*P_1553*P_2096*P_4120);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|BloodCells|CYP1A2|Start amount
P_4407 = P_4126;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Intracellular|CYP1A2
P_4408 = (P_2962*P_1553*P_2108*P_4132);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Plasma|CYP1A2|Start amount
P_4409 = (P_2966*P_1553*P_2112*P_4135);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|BloodCells|CYP1A2|Start amount
P_4410 = P_4141;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Intracellular|CYP1A2
P_4411 = (P_2972*P_1553*P_2123*P_4147);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Plasma|CYP1A2|Start amount
P_4412 = (P_2976*P_1553*P_2128*P_4150);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|BloodCells|CYP1A2|Start amount
P_4413 = P_4156;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Intracellular|CYP1A2
P_4414 = (P_2982*P_1553*P_2139*P_4162);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Plasma|CYP1A2|Start amount
P_4415 = (P_2986*P_1553*P_2145*P_4165);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|BloodCells|CYP1A2|Start amount
P_4416 = P_4171;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Intracellular|CYP1A2
P_4417 = (P_2992*P_1553*P_2155*P_4177);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Plasma|CYP1A2|Start amount
P_4418 = (P_2996*P_1553*P_2160*P_4180);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|BloodCells|CYP1A2|Start amount
P_4419 = P_4186;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Intracellular|CYP1A2
P_4420 = (P_3002*P_1553*P_2171*P_4192);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Plasma|CYP1A2|Start amount
P_4421 = (P_3006*P_1553*P_2176*P_4195);  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|BloodCells|CYP1A2|Start amount
P_4422 = P_4201;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Intracellular|CYP1A2
P_4423 = (P_4205*(IIf(P_1115,P_1116,1)));  % CoffeinSimulation|Organism|Liver|Periportal|Fluid recirculation flow rate
P_4424 = P_4207;  % CoffeinSimulation|Organism|Liver|Periportal|Plasma|CYP1A2
P_4425 = P_4208;  % CoffeinSimulation|Organism|Liver|Periportal|BloodCells|CYP1A2
P_4426 = (IIf((P_3716 > 0),(P_4210/P_3716),0));  % CoffeinSimulation|Organism|Liver|Periportal|Intracellular|CYP1A2|Concentration
P_4427 = (P_4205*(IIf(P_1115,(1-P_1116),0)));  % CoffeinSimulation|Organism|Liver|Pericentral|Fluid recirculation flow rate
P_4428 = P_4215;  % CoffeinSimulation|Organism|Liver|Pericentral|Plasma|CYP1A2
P_4429 = P_4216;  % CoffeinSimulation|Organism|Liver|Pericentral|BloodCells|CYP1A2
P_4430 = (IIf((P_3729 > 0),(P_4218/P_3729),0));  % CoffeinSimulation|Organism|Liver|Pericentral|Intracellular|CYP1A2|Concentration
P_4431 = (P_1171*(1-P_1179)*P_4222*((P_1200/P_1173)^(P_16+(-1))));  % CoffeinSimulation|Organism|Lung|Fluid recirculation flow rate
P_4432 = (IIf((P_2288 > 0),(P_4223/P_2288),0));  % CoffeinSimulation|Organism|Lung|Plasma|CYP1A2|Concentration
P_4433 = (IIf((P_2294 > 0),(P_4224/P_2294),0));  % CoffeinSimulation|Organism|Lung|BloodCells|CYP1A2|Concentration
P_4434 = (IIf((P_2309 > 0),(P_4229/P_2309),0));  % CoffeinSimulation|Organism|Muscle|Plasma|CYP1A2|Concentration
P_4435 = (IIf((P_2315 > 0),(P_4230/P_2315),0));  % CoffeinSimulation|Organism|Muscle|BloodCells|CYP1A2|Concentration
P_4436 = (IIf((P_2330 > 0),(P_4235/P_2330),0));  % CoffeinSimulation|Organism|Pancreas|Plasma|CYP1A2|Concentration
P_4437 = (IIf((P_2336 > 0),(P_4236/P_2336),0));  % CoffeinSimulation|Organism|Pancreas|BloodCells|CYP1A2|Concentration
P_4438 = (IIf((P_2350 > 0),(P_4241/P_2350),0));  % CoffeinSimulation|Organism|PortalVein|Plasma|CYP1A2|Concentration
P_4439 = (IIf((P_2356 > 0),(P_4242/P_2356),0));  % CoffeinSimulation|Organism|PortalVein|BloodCells|CYP1A2|Concentration
P_4440 = (IIf((P_2364 > 0),(P_4244/P_2364),0));  % CoffeinSimulation|Organism|Skin|Plasma|CYP1A2|Concentration
P_4441 = (IIf((P_2370 > 0),(P_4245/P_2370),0));  % CoffeinSimulation|Organism|Skin|BloodCells|CYP1A2|Concentration
P_4442 = (IIf((P_2385 > 0),(P_4250/P_2385),0));  % CoffeinSimulation|Organism|Spleen|Plasma|CYP1A2|Concentration
P_4443 = (IIf((P_2391 > 0),(P_4251/P_2391),0));  % CoffeinSimulation|Organism|Spleen|BloodCells|CYP1A2|Concentration
P_4444 = (P_3931*8.219178082191781e-05);  % CoffeinSimulation|Organism|Saliva|Volume
P_4445 = (IIf(P_331,(P_1509*P_3545*((min((P_3982/P_1531),(y(61)/y(60))))-(IIf((~P_332),(P_2514*P_4051),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_pls|Caffeine|Drug absorption rate (lumen to mucosa)
P_4446 = (IIf(P_331,(P_3913*P_3545*((P_3792*(min((P_3982/P_1531),(y(61)/y(60)))))-(IIf((~P_333),(P_3791*P_2514*(P_4060/P_3793)),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|Drug absorption rate (lumen to mucosa)
P_4447 = (P_3622*(1-P_42)*P_4051);  % CoffeinSimulation|Neighborhoods|UpperJejunum_pls_PortalVein_pls|Caffeine|Mass transfer rate (mucosa to portal vein plasma)
P_4448 = (P_3622*P_42*P_4054);  % CoffeinSimulation|Neighborhoods|UpperJejunum_bc_PortalVein_bc|Caffeine|Mass transfer rate (mucosa to portal vein blood cells)
P_4449 = (IIf(P_331,(P_1509*P_3551*((min((P_3986/P_1531),(y(65)/y(64))))-(IIf((~P_332),(P_2514*P_4066),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_pls|Caffeine|Drug absorption rate (lumen to mucosa)
P_4450 = (IIf(P_331,(P_3913*P_3551*((P_3799*(min((P_3986/P_1531),(y(65)/y(64)))))-(IIf((~P_333),(P_3798*P_2514*(P_4075/P_3800)),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|Drug absorption rate (lumen to mucosa)
P_4451 = (P_3630*(1-P_42)*P_4066);  % CoffeinSimulation|Neighborhoods|LowerJejunum_pls_PortalVein_pls|Caffeine|Mass transfer rate (mucosa to portal vein plasma)
P_4452 = (P_3630*P_42*P_4069);  % CoffeinSimulation|Neighborhoods|LowerJejunum_bc_PortalVein_bc|Caffeine|Mass transfer rate (mucosa to portal vein blood cells)
P_4453 = (IIf(P_331,(P_1509*P_3555*((min((P_3990/P_1531),(y(69)/y(68))))-(IIf((~P_332),(P_2514*P_4081),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_pls|Caffeine|Drug absorption rate (lumen to mucosa)
P_4454 = (IIf(P_331,(P_3913*P_3555*((P_3806*(min((P_3990/P_1531),(y(69)/y(68)))))-(IIf((~P_333),(P_3805*P_2514*(P_4090/P_3807)),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|Drug absorption rate (lumen to mucosa)
P_4455 = (P_3638*(1-P_42)*P_4081);  % CoffeinSimulation|Neighborhoods|UpperIleum_pls_PortalVein_pls|Caffeine|Mass transfer rate (mucosa to portal vein plasma)
P_4456 = (P_3638*P_42*P_4084);  % CoffeinSimulation|Neighborhoods|UpperIleum_bc_PortalVein_bc|Caffeine|Mass transfer rate (mucosa to portal vein blood cells)
P_4457 = (P_3809*P_4273);  % CoffeinSimulation|Neighborhoods|SmallIntestine_int_SmallIntestine_cell|Caffeine|P*SA interstitial -> intracellular
P_4458 = (P_3810*P_4273);  % CoffeinSimulation|Neighborhoods|SmallIntestine_int_SmallIntestine_cell|Caffeine|P*SA intracellular -> interstitial
P_4459 = (P_3646*P_42*P_4099);  % CoffeinSimulation|Neighborhoods|LowerIleum_bc_PortalVein_bc|Caffeine|Mass transfer rate (mucosa to portal vein blood cells)
P_4460 = (P_3646*(1-P_42)*P_4096);  % CoffeinSimulation|Neighborhoods|LowerIleum_pls_PortalVein_pls|Caffeine|Mass transfer rate (mucosa to portal vein plasma)
P_4461 = (IIf(P_331,(P_3913*P_3562*((P_3813*(min((P_3994/P_1531),(y(73)/y(72)))))-(IIf((~P_333),(P_3812*P_2514*(P_4105/P_3814)),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|Drug absorption rate (lumen to mucosa)
P_4462 = (IIf(P_331,(P_1509*P_3562*((min((P_3994/P_1531),(y(73)/y(72))))-(IIf((~P_332),(P_2514*P_4096),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_pls|Caffeine|Drug absorption rate (lumen to mucosa)
P_4463 = (P_3815*P_4278);  % CoffeinSimulation|Neighborhoods|LargeIntestine_int_LargeIntestine_cell|Caffeine|P*SA interstitial -> intracellular
P_4464 = (P_3816*P_4278);  % CoffeinSimulation|Neighborhoods|LargeIntestine_int_LargeIntestine_cell|Caffeine|P*SA intracellular -> interstitial
P_4465 = (P_3697*(1-P_42)*P_4193);  % CoffeinSimulation|Neighborhoods|Rectum_pls_PortalVein_pls|Caffeine|Mass transfer rate (mucosa to portal vein plasma)
P_4466 = (P_3697*P_42*P_4196);  % CoffeinSimulation|Neighborhoods|Rectum_bc_PortalVein_bc|Caffeine|Mass transfer rate (mucosa to portal vein blood cells)
P_4467 = (IIf(P_331,(P_1509*P_3597*((min((P_4019/P_1531),(y(97)/y(96))))-(IIf((~P_332),(P_2514*P_4193),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_pls|Caffeine|Drug absorption rate (lumen to mucosa)
P_4468 = (IIf(P_331,(P_3913*P_3597*((P_3840*(min((P_4019/P_1531),(y(97)/y(96)))))-(IIf((~P_333),(P_3839*P_2514*(P_4202/P_3841)),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|Drug absorption rate (lumen to mucosa)
P_4469 = (P_3423*P_1458*P_4312);  % CoffeinSimulation|Neighborhoods|Duodenum_int_Duodenum_cell|Caffeine|P (interstitial->intracellular)
P_4470 = (P_3423*P_1459*P_4312);  % CoffeinSimulation|Neighborhoods|Duodenum_int_Duodenum_cell|Caffeine|P (intracellular->interstitial)
P_4471 = (P_3423*P_1462*P_4312);  % CoffeinSimulation|Neighborhoods|UpperJejunum_int_UpperJejunum_cell|Caffeine|P (interstitial->intracellular)
P_4472 = (P_3423*P_1461*P_4312);  % CoffeinSimulation|Neighborhoods|UpperJejunum_int_UpperJejunum_cell|Caffeine|P (intracellular->interstitial)
P_4473 = (P_3423*P_1464*P_4312);  % CoffeinSimulation|Neighborhoods|LowerJejunum_int_LowerJejunum_cell|Caffeine|P (interstitial->intracellular)
P_4474 = (P_3423*P_1463*P_4312);  % CoffeinSimulation|Neighborhoods|LowerJejunum_int_LowerJejunum_cell|Caffeine|P (intracellular->interstitial)
P_4475 = (P_3423*P_1468*P_4312);  % CoffeinSimulation|Neighborhoods|UpperIleum_int_UpperIleum_cell|Caffeine|P (interstitial->intracellular)
P_4476 = (P_3423*P_1467*P_4312);  % CoffeinSimulation|Neighborhoods|UpperIleum_int_UpperIleum_cell|Caffeine|P (intracellular->interstitial)
P_4477 = (P_3423*P_1470*P_4312);  % CoffeinSimulation|Neighborhoods|LowerIleum_int_LowerIleum_cell|Caffeine|P (interstitial->intracellular)
P_4478 = (P_3423*P_1469*P_4312);  % CoffeinSimulation|Neighborhoods|LowerIleum_int_LowerIleum_cell|Caffeine|P (intracellular->interstitial)
P_4479 = (P_3423*P_1474*P_4312);  % CoffeinSimulation|Neighborhoods|Caecum_int_Caecum_cell|Caffeine|P (interstitial->intracellular)
P_4480 = (P_3423*P_1473*P_4312);  % CoffeinSimulation|Neighborhoods|Caecum_int_Caecum_cell|Caffeine|P (intracellular->interstitial)
P_4481 = (P_3423*P_1476*P_4312);  % CoffeinSimulation|Neighborhoods|ColonAscendens_int_ColonAscendens_cell|Caffeine|P (interstitial->intracellular)
P_4482 = (P_3423*P_1475*P_4312);  % CoffeinSimulation|Neighborhoods|ColonAscendens_int_ColonAscendens_cell|Caffeine|P (intracellular->interstitial)
P_4483 = (P_3423*P_1480*P_4312);  % CoffeinSimulation|Neighborhoods|ColonTransversum_int_ColonTransversum_cell|Caffeine|P (interstitial->intracellular)
P_4484 = (P_3423*P_1479*P_4312);  % CoffeinSimulation|Neighborhoods|ColonTransversum_int_ColonTransversum_cell|Caffeine|P (intracellular->interstitial)
P_4485 = (P_3423*P_1482*P_4312);  % CoffeinSimulation|Neighborhoods|ColonDescendens_int_ColonDescendens_cell|Caffeine|P (interstitial->intracellular)
P_4486 = (P_3423*P_1481*P_4312);  % CoffeinSimulation|Neighborhoods|ColonDescendens_int_ColonDescendens_cell|Caffeine|P (intracellular->interstitial)
P_4487 = (P_3423*P_1485*P_4312);  % CoffeinSimulation|Neighborhoods|ColonSigmoid_int_ColonSigmoid_cell|Caffeine|P (interstitial->intracellular)
P_4488 = (P_3423*P_1484*P_4312);  % CoffeinSimulation|Neighborhoods|ColonSigmoid_int_ColonSigmoid_cell|Caffeine|P (intracellular->interstitial)
P_4489 = (P_3423*P_1487*P_4312);  % CoffeinSimulation|Neighborhoods|Rectum_int_Rectum_cell|Caffeine|P (interstitial->intracellular)
P_4490 = (P_3423*P_1488*P_4312);  % CoffeinSimulation|Neighborhoods|Rectum_int_Rectum_cell|Caffeine|P (intracellular->interstitial)
P_4491 = (P_3681*(1-P_42)*P_4163);  % CoffeinSimulation|Neighborhoods|ColonDescendens_pls_PortalVein_pls|Caffeine|Mass transfer rate (mucosa to portal vein plasma)
P_4492 = (P_3681*P_42*P_4166);  % CoffeinSimulation|Neighborhoods|ColonDescendens_bc_PortalVein_bc|Caffeine|Mass transfer rate (mucosa to portal vein blood cells)
P_4493 = (IIf(P_331,(P_1509*P_3592*((min((P_4014/P_1531),(y(93)/y(92))))-(IIf((~P_332),(P_2514*P_4178),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_pls|Caffeine|Drug absorption rate (lumen to mucosa)
P_4494 = (IIf(P_331,(P_3913*P_3592*((P_3895*(min((P_4014/P_1531),(y(93)/y(92)))))-(IIf((~P_333),(P_3894*P_2514*(P_4187/P_3896)),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|Drug absorption rate (lumen to mucosa)
P_4495 = (P_3689*(1-P_42)*P_4178);  % CoffeinSimulation|Neighborhoods|ColonSigmoid_pls_PortalVein_pls|Caffeine|Mass transfer rate (mucosa to portal vein plasma)
P_4496 = (P_3689*P_42*P_4181);  % CoffeinSimulation|Neighborhoods|ColonSigmoid_bc_PortalVein_bc|Caffeine|Mass transfer rate (mucosa to portal vein blood cells)
P_4497 = (IIf(P_331,(P_1509*P_3539*((min((P_3978/P_1531),(y(57)/y(56))))-(IIf((~P_332),(P_2514*P_4036),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_pls|Caffeine|Drug absorption rate (lumen to mucosa)
P_4498 = (IIf(P_331,(P_3913*P_3539*((P_3899*(min((P_3978/P_1531),(y(57)/y(56)))))-(IIf((~P_333),(P_3897*P_2514*(P_4045/P_3898)),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|Drug absorption rate (lumen to mucosa)
P_4499 = (P_3614*(1-P_42)*P_4036);  % CoffeinSimulation|Neighborhoods|Duodenum_pls_PortalVein_pls|Caffeine|Mass transfer rate (mucosa to portal vein plasma)
P_4500 = (P_3614*P_42*P_4039);  % CoffeinSimulation|Neighborhoods|Duodenum_bc_PortalVein_bc|Caffeine|Mass transfer rate (mucosa to portal vein blood cells)
P_4501 = (P_3673*(1-P_42)*P_4148);  % CoffeinSimulation|Neighborhoods|ColonTransversum_pls_PortalVein_pls|Caffeine|Mass transfer rate (mucosa to portal vein plasma)
P_4502 = (P_3673*P_42*P_4151);  % CoffeinSimulation|Neighborhoods|ColonTransversum_bc_PortalVein_bc|Caffeine|Mass transfer rate (mucosa to portal vein blood cells)
P_4503 = (IIf(P_331,(P_1509*P_3585*((min((P_4010/P_1531),(y(89)/y(88))))-(IIf((~P_332),(P_2514*P_4163),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_pls|Caffeine|Drug absorption rate (lumen to mucosa)
P_4504 = (IIf(P_331,(P_3913*P_3585*((P_3901*(min((P_4010/P_1531),(y(89)/y(88)))))-(IIf((~P_333),(P_3900*P_2514*(P_4172/P_3902)),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|Drug absorption rate (lumen to mucosa)
P_4505 = (P_3665*P_42*P_4136);  % CoffeinSimulation|Neighborhoods|ColonAscendens_bc_PortalVein_bc|Caffeine|Mass transfer rate (mucosa to portal vein blood cells)
P_4506 = (IIf(P_331,(P_1509*P_3568*((min((P_3998/P_1531),(y(77)/y(76))))-(IIf((~P_332),(P_2514*P_4118),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_pls|Caffeine|Drug absorption rate (lumen to mucosa)
P_4507 = (IIf(P_331,(P_3913*P_3568*((P_3904*(min((P_3998/P_1531),(y(77)/y(76)))))-(IIf((~P_333),(P_3903*P_2514*(P_4127/P_3905)),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|Drug absorption rate (lumen to mucosa)
P_4508 = (P_3657*(1-P_42)*P_4118);  % CoffeinSimulation|Neighborhoods|Caecum_pls_PortalVein_pls|Caffeine|Mass transfer rate (mucosa to portal vein plasma)
P_4509 = (P_3657*P_42*P_4121);  % CoffeinSimulation|Neighborhoods|Caecum_bc_PortalVein_bc|Caffeine|Mass transfer rate (mucosa to portal vein blood cells)
P_4510 = (IIf(P_331,(P_1509*P_3574*((min((P_4002/P_1531),(y(81)/y(80))))-(IIf((~P_332),(P_2514*P_4133),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_pls|Caffeine|Drug absorption rate (lumen to mucosa)
P_4511 = (P_3665*(1-P_42)*P_4133);  % CoffeinSimulation|Neighborhoods|ColonAscendens_pls_PortalVein_pls|Caffeine|Mass transfer rate (mucosa to portal vein plasma)
P_4512 = (IIf(P_331,(P_1509*P_3579*((min((P_4006/P_1531),(y(85)/y(84))))-(IIf((~P_332),(P_2514*P_4148),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_pls|Caffeine|Drug absorption rate (lumen to mucosa)
P_4513 = (IIf(P_331,(P_3913*P_3579*((P_3907*(min((P_4006/P_1531),(y(85)/y(84)))))-(IIf((~P_333),(P_3906*P_2514*(P_4157/P_3908)),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|Drug absorption rate (lumen to mucosa)
P_4514 = (IIf(P_331,(P_3913*P_3574*((P_3910*(min((P_4002/P_1531),(y(81)/y(80)))))-(IIf((~P_333),(P_3909*P_2514*(P_4142/P_3911)),0)))),0));  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|Drug absorption rate (lumen to mucosa)
P_4515 = (IIf(P_3422,(IIf((P_1532 <= P_4313),(min(P_1533,P_1534)),(IIf((P_1532 >= P_3918),(max(P_1533,P_1534)),P_1532)))),0));  % CoffeinSimulation|Caffeine|pKa_ThreeBases_1
P_4516 = (IIf(P_3421,(IIf((P_1532 <= P_4314),(min(P_1533,P_1534)),(IIf((P_1532 >= P_3919),(max(P_1533,P_1534)),P_1532)))),0));  % CoffeinSimulation|Caffeine|pKa_ThreeAcids_1
P_4517 = (IIf(P_3448,(IIf((P_1584 <= P_4315),(min(P_1585,P_1586)),(IIf((P_1584 >= P_3923),(max(P_1585,P_1586)),P_1584)))),0));  % CoffeinSimulation|CYP1A2|pKa_ThreeBases_1
P_4518 = (IIf(P_3447,(IIf((P_1584 <= P_4316),(min(P_1585,P_1586)),(IIf((P_1584 >= P_3924),(max(P_1585,P_1586)),P_1584)))),0));  % CoffeinSimulation|CYP1A2|pKa_ThreeAcids_1
P_4519 = (IIf(P_3474,(IIf((P_1622 <= P_4317),(min(P_1623,P_1624)),(IIf((P_1622 >= P_3928),(max(P_1623,P_1624)),P_1622)))),0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_ThreeBases_1
P_4520 = (IIf(P_3473,(IIf((P_1622 <= P_4318),(min(P_1623,P_1624)),(IIf((P_1622 >= P_3929),(max(P_1623,P_1624)),P_1622)))),0));  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_ThreeAcids_1
P_4521 = (P_1642*P_3931);  % CoffeinSimulation|Applications|3 mg per kg Infusion (10 min)|Application_1|ProtocolSchemaItem|Dose
P_4522 = (P_1811*y(53)*P_4340);  % CoffeinSimulation|Organism|Lumen|Stomach|Liquid transfer rate
P_4523 = (P_2716*y(56)*P_4342);  % CoffeinSimulation|Organism|Lumen|Duodenum|Liquid transfer rate
P_4524 = (IIf((P_2717 > 0),(P_4341/P_2717),0));  % CoffeinSimulation|Organism|Lumen|Duodenum|CYP1A2|Concentration
P_4525 = (P_2730*y(60)*P_4344);  % CoffeinSimulation|Organism|Lumen|UpperJejunum|Liquid transfer rate
P_4526 = (IIf((P_2729 > 0),(P_4343/P_2729),0));  % CoffeinSimulation|Organism|Lumen|UpperJejunum|CYP1A2|Concentration
P_4527 = (P_2744*y(64)*P_4346);  % CoffeinSimulation|Organism|Lumen|LowerJejunum|Liquid transfer rate
P_4528 = (IIf((P_2742 > 0),(P_4345/P_2742),0));  % CoffeinSimulation|Organism|Lumen|LowerJejunum|CYP1A2|Concentration
P_4529 = (P_2756*y(68)*P_4348);  % CoffeinSimulation|Organism|Lumen|UpperIleum|Liquid transfer rate
P_4530 = (IIf((P_2757 > 0),(P_4347/P_2757),0));  % CoffeinSimulation|Organism|Lumen|UpperIleum|CYP1A2|Concentration
P_4531 = (P_2770*y(72)*P_4350);  % CoffeinSimulation|Organism|Lumen|LowerIleum|Liquid transfer rate
P_4532 = (IIf((P_2768 > 0),(P_4349/P_2768),0));  % CoffeinSimulation|Organism|Lumen|LowerIleum|CYP1A2|Concentration
P_4533 = (P_2781*y(76)*P_4352);  % CoffeinSimulation|Organism|Lumen|Caecum|Liquid transfer rate
P_4534 = (IIf((P_2783 > 0),(P_4351/P_2783),0));  % CoffeinSimulation|Organism|Lumen|Caecum|CYP1A2|Concentration
P_4535 = (P_2796*y(80)*P_4354);  % CoffeinSimulation|Organism|Lumen|ColonAscendens|Liquid transfer rate
P_4536 = (IIf((P_2795 > 0),(P_4353/P_2795),0));  % CoffeinSimulation|Organism|Lumen|ColonAscendens|CYP1A2|Concentration
P_4537 = (P_2808*y(84)*P_4356);  % CoffeinSimulation|Organism|Lumen|ColonTransversum|Liquid transfer rate
P_4538 = (IIf((P_2809 > 0),(P_4355/P_2809),0));  % CoffeinSimulation|Organism|Lumen|ColonTransversum|CYP1A2|Concentration
P_4539 = (P_2821*y(88)*P_4358);  % CoffeinSimulation|Organism|Lumen|ColonDescendens|Liquid transfer rate
P_4540 = (IIf((P_2822 > 0),(P_4357/P_2822),0));  % CoffeinSimulation|Organism|Lumen|ColonDescendens|CYP1A2|Concentration
P_4541 = (P_2835*y(92)*P_4360);  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|Liquid transfer rate
P_4542 = (IIf((P_2833 > 0),(P_4359/P_2833),0));  % CoffeinSimulation|Organism|Lumen|ColonSigmoid|CYP1A2|Concentration
P_4543 = (IIf((P_2847 > 0),(P_4361/P_2847),0));  % CoffeinSimulation|Organism|Lumen|Rectum|CYP1A2|Concentration
P_4544 = (P_608*(1-P_614)*P_4365*((P_640/P_605)^(P_16+(-1))));  % CoffeinSimulation|Organism|SmallIntestine|Fluid recirculation flow rate (incl. mucosa)
P_4545 = (P_2882*P_1553*P_1977*P_4366);  % CoffeinSimulation|Organism|SmallIntestine|Plasma|CYP1A2|Start amount
P_4546 = (P_2886*P_1553*P_1982*P_4369);  % CoffeinSimulation|Organism|SmallIntestine|BloodCells|CYP1A2|Start amount
P_4547 = P_4374;  % CoffeinSimulation|Organism|SmallIntestine|Intracellular|CYP1A2
P_4548 = P_4377;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Plasma|CYP1A2
P_4549 = P_4378;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|BloodCells|CYP1A2
P_4550 = (IIf((P_3620 > 0),(P_4379/P_3620),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Intracellular|CYP1A2|Concentration
P_4551 = P_4380;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Plasma|CYP1A2
P_4552 = P_4381;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|BloodCells|CYP1A2
P_4553 = (IIf((P_3628 > 0),(P_4382/P_3628),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Intracellular|CYP1A2|Concentration
P_4554 = P_4383;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Plasma|CYP1A2
P_4555 = P_4384;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|BloodCells|CYP1A2
P_4556 = (IIf((P_3636 > 0),(P_4385/P_3636),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Intracellular|CYP1A2|Concentration
P_4557 = P_4386;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Plasma|CYP1A2
P_4558 = P_4387;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|BloodCells|CYP1A2
P_4559 = (IIf((P_3644 > 0),(P_4388/P_3644),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Intracellular|CYP1A2|Concentration
P_4560 = P_4389;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Plasma|CYP1A2
P_4561 = P_4390;  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|BloodCells|CYP1A2
P_4562 = (IIf((P_3652 > 0),(P_4391/P_3652),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Intracellular|CYP1A2|Concentration
P_4563 = (P_843*(1-P_851)*P_4392*((P_876/P_841)^(P_16+(-1))));  % CoffeinSimulation|Organism|LargeIntestine|Fluid recirculation flow rate (incl. mucosa)
P_4564 = (P_2942*P_1553*P_2076*P_4394);  % CoffeinSimulation|Organism|LargeIntestine|Plasma|CYP1A2|Start amount
P_4565 = (P_2946*P_1553*P_2080*P_4397);  % CoffeinSimulation|Organism|LargeIntestine|BloodCells|CYP1A2|Start amount
P_4566 = P_4402;  % CoffeinSimulation|Organism|LargeIntestine|Intracellular|CYP1A2
P_4567 = P_4405;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Plasma|CYP1A2
P_4568 = P_4406;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|BloodCells|CYP1A2
P_4569 = (IIf((P_3663 > 0),(P_4407/P_3663),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Intracellular|CYP1A2|Concentration
P_4570 = P_4408;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Plasma|CYP1A2
P_4571 = P_4409;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|BloodCells|CYP1A2
P_4572 = (IIf((P_3671 > 0),(P_4410/P_3671),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Intracellular|CYP1A2|Concentration
P_4573 = P_4411;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Plasma|CYP1A2
P_4574 = P_4412;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|BloodCells|CYP1A2
P_4575 = (IIf((P_3679 > 0),(P_4413/P_3679),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Intracellular|CYP1A2|Concentration
P_4576 = P_4414;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Plasma|CYP1A2
P_4577 = P_4415;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|BloodCells|CYP1A2
P_4578 = (IIf((P_3687 > 0),(P_4416/P_3687),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Intracellular|CYP1A2|Concentration
P_4579 = P_4417;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Plasma|CYP1A2
P_4580 = P_4418;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|BloodCells|CYP1A2
P_4581 = (IIf((P_3695 > 0),(P_4419/P_3695),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Intracellular|CYP1A2|Concentration
P_4582 = P_4420;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Plasma|CYP1A2
P_4583 = P_4421;  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|BloodCells|CYP1A2
P_4584 = (IIf((P_3703 > 0),(P_4422/P_3703),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Intracellular|CYP1A2|Concentration
P_4585 = (IIf((P_3014 > 0),(P_4424/P_3014),0));  % CoffeinSimulation|Organism|Liver|Periportal|Plasma|CYP1A2|Concentration
P_4586 = (IIf((P_3019 > 0),(P_4425/P_3019),0));  % CoffeinSimulation|Organism|Liver|Periportal|BloodCells|CYP1A2|Concentration
P_4587 = (IIf((P_3029 > 0),(P_4428/P_3029),0));  % CoffeinSimulation|Organism|Liver|Pericentral|Plasma|CYP1A2|Concentration
P_4588 = (IIf((P_3034 > 0),(P_4429/P_3034),0));  % CoffeinSimulation|Organism|Liver|Pericentral|BloodCells|CYP1A2|Concentration
P_4589 = (P_4444*P_1390);  % CoffeinSimulation|Organism|Saliva|Weight (tissue)
P_4590 = P_4444;  % CoffeinSimulation|Organism|Saliva|Saliva|Volume
P_4591 = P_4444;  % CoffeinSimulation|Organism|Saliva|SalivaGland|Volume
P_4592 = P_4445;  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_pls|Caffeine|DrugAbsorption_para|ProcessRate
P_4593 = P_4446;  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|DrugAbsorption_trans|ProcessRate
P_4594 = P_4449;  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_pls|Caffeine|DrugAbsorption_para|ProcessRate
P_4595 = P_4450;  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|DrugAbsorption_trans|ProcessRate
P_4596 = P_4453;  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_pls|Caffeine|DrugAbsorption_para|ProcessRate
P_4597 = P_4454;  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|DrugAbsorption_trans|ProcessRate
P_4598 = (P_3614*(1-P_42)*P_4367);  % CoffeinSimulation|Neighborhoods|SmallIntestine_pls_Duodenum_pls|Caffeine|Mass transfer rate (intestine to mucosa plasma)
P_4599 = (P_3622*(1-P_42)*P_4367);  % CoffeinSimulation|Neighborhoods|SmallIntestine_pls_UpperJejunum_pls|Caffeine|Mass transfer rate (intestine to mucosa plasma)
P_4600 = (P_3622*P_42*P_4370);  % CoffeinSimulation|Neighborhoods|SmallIntestine_bc_UpperJejunum_bc|Caffeine|Mass transfer rate (intestine to mucosa blood cells)
P_4601 = (P_3646*P_42*P_4370);  % CoffeinSimulation|Neighborhoods|SmallIntestine_bc_LowerIleum_bc|Caffeine|Mass transfer rate (intestine to mucosa blood cells)
P_4602 = (P_3646*(1-P_42)*P_4367);  % CoffeinSimulation|Neighborhoods|SmallIntestine_pls_LowerIleum_pls|Caffeine|Mass transfer rate (intestine to mucosa plasma)
P_4603 = P_4461;  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|DrugAbsorption_trans|ProcessRate
P_4604 = (P_3614*P_42*P_4370);  % CoffeinSimulation|Neighborhoods|SmallIntestine_bc_Duodenum_bc|Caffeine|Mass transfer rate (intestine to mucosa blood cells)
P_4605 = P_4462;  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_pls|Caffeine|DrugAbsorption_para|ProcessRate
P_4606 = (P_3638*P_42*P_4370);  % CoffeinSimulation|Neighborhoods|SmallIntestine_bc_UpperIleum_bc|Caffeine|Mass transfer rate (intestine to mucosa blood cells)
P_4607 = (P_3638*(1-P_42)*P_4367);  % CoffeinSimulation|Neighborhoods|SmallIntestine_pls_UpperIleum_pls|Caffeine|Mass transfer rate (intestine to mucosa plasma)
P_4608 = (P_3630*P_42*P_4370);  % CoffeinSimulation|Neighborhoods|SmallIntestine_bc_LowerJejunum_bc|Caffeine|Mass transfer rate (intestine to mucosa blood cells)
P_4609 = (P_3630*(1-P_42)*P_4367);  % CoffeinSimulation|Neighborhoods|SmallIntestine_pls_LowerJejunum_pls|Caffeine|Mass transfer rate (intestine to mucosa plasma)
P_4610 = (P_3689*(1-P_42)*P_4395);  % CoffeinSimulation|Neighborhoods|LargeIntestine_pls_ColonSigmoid_pls|Caffeine|Mass transfer rate (intestine to mucosa plasma)
P_4611 = (P_3697*(1-P_42)*P_4395);  % CoffeinSimulation|Neighborhoods|LargeIntestine_pls_Rectum_pls|Caffeine|Mass transfer rate (intestine to mucosa plasma)
P_4612 = (P_3697*P_42*P_4398);  % CoffeinSimulation|Neighborhoods|LargeIntestine_bc_Rectum_bc|Caffeine|Mass transfer rate (intestine to mucosa blood cells)
P_4613 = (P_3657*(1-P_42)*P_4395);  % CoffeinSimulation|Neighborhoods|LargeIntestine_pls_Caecum_pls|Caffeine|Mass transfer rate (intestine to mucosa plasma)
P_4614 = (P_3689*P_42*P_4398);  % CoffeinSimulation|Neighborhoods|LargeIntestine_bc_ColonSigmoid_bc|Caffeine|Mass transfer rate (intestine to mucosa blood cells)
P_4615 = (P_3665*(1-P_42)*P_4395);  % CoffeinSimulation|Neighborhoods|LargeIntestine_pls_ColonAscendens_pls|Caffeine|Mass transfer rate (intestine to mucosa plasma)
P_4616 = (P_3657*P_42*P_4398);  % CoffeinSimulation|Neighborhoods|LargeIntestine_bc_Caecum_bc|Caffeine|Mass transfer rate (intestine to mucosa blood cells)
P_4617 = (P_3665*P_42*P_4398);  % CoffeinSimulation|Neighborhoods|LargeIntestine_bc_ColonAscendens_bc|Caffeine|Mass transfer rate (intestine to mucosa blood cells)
P_4618 = (P_3673*(1-P_42)*P_4395);  % CoffeinSimulation|Neighborhoods|LargeIntestine_pls_ColonTransversum_pls|Caffeine|Mass transfer rate (intestine to mucosa plasma)
P_4619 = (P_3673*P_42*P_4398);  % CoffeinSimulation|Neighborhoods|LargeIntestine_bc_ColonTransversum_bc|Caffeine|Mass transfer rate (intestine to mucosa blood cells)
P_4620 = (P_3681*(1-P_42)*P_4395);  % CoffeinSimulation|Neighborhoods|LargeIntestine_pls_ColonDescendens_pls|Caffeine|Mass transfer rate (intestine to mucosa plasma)
P_4621 = (P_3681*P_42*P_4398);  % CoffeinSimulation|Neighborhoods|LargeIntestine_bc_ColonDescendens_bc|Caffeine|Mass transfer rate (intestine to mucosa blood cells)
P_4622 = P_4468;  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|DrugAbsorption_trans|ProcessRate
P_4623 = (P_4469*P_4295);  % CoffeinSimulation|Neighborhoods|Duodenum_int_Duodenum_cell|Caffeine|P*SA interstitial -> intracellular
P_4624 = (P_4470*P_4295);  % CoffeinSimulation|Neighborhoods|Duodenum_int_Duodenum_cell|Caffeine|P*SA intracellular -> interstitial
P_4625 = (P_4472*P_4296);  % CoffeinSimulation|Neighborhoods|UpperJejunum_int_UpperJejunum_cell|Caffeine|P*SA intracellular -> interstitial
P_4626 = (P_4471*P_4296);  % CoffeinSimulation|Neighborhoods|UpperJejunum_int_UpperJejunum_cell|Caffeine|P*SA interstitial -> intracellular
P_4627 = (P_4473*P_4297);  % CoffeinSimulation|Neighborhoods|LowerJejunum_int_LowerJejunum_cell|Caffeine|P*SA interstitial -> intracellular
P_4628 = (P_4474*P_4297);  % CoffeinSimulation|Neighborhoods|LowerJejunum_int_LowerJejunum_cell|Caffeine|P*SA intracellular -> interstitial
P_4629 = (P_4475*P_4298);  % CoffeinSimulation|Neighborhoods|UpperIleum_int_UpperIleum_cell|Caffeine|P*SA interstitial -> intracellular
P_4630 = (P_4476*P_4298);  % CoffeinSimulation|Neighborhoods|UpperIleum_int_UpperIleum_cell|Caffeine|P*SA intracellular -> interstitial
P_4631 = (P_4478*P_4299);  % CoffeinSimulation|Neighborhoods|LowerIleum_int_LowerIleum_cell|Caffeine|P*SA intracellular -> interstitial
P_4632 = (P_4477*P_4299);  % CoffeinSimulation|Neighborhoods|LowerIleum_int_LowerIleum_cell|Caffeine|P*SA interstitial -> intracellular
P_4633 = (P_4479*P_4300);  % CoffeinSimulation|Neighborhoods|Caecum_int_Caecum_cell|Caffeine|P*SA interstitial -> intracellular
P_4634 = (P_4480*P_4300);  % CoffeinSimulation|Neighborhoods|Caecum_int_Caecum_cell|Caffeine|P*SA intracellular -> interstitial
P_4635 = (P_4482*P_4301);  % CoffeinSimulation|Neighborhoods|ColonAscendens_int_ColonAscendens_cell|Caffeine|P*SA intracellular -> interstitial
P_4636 = (P_4481*P_4301);  % CoffeinSimulation|Neighborhoods|ColonAscendens_int_ColonAscendens_cell|Caffeine|P*SA interstitial -> intracellular
P_4637 = (P_4483*P_4302);  % CoffeinSimulation|Neighborhoods|ColonTransversum_int_ColonTransversum_cell|Caffeine|P*SA interstitial -> intracellular
P_4638 = (P_4484*P_4302);  % CoffeinSimulation|Neighborhoods|ColonTransversum_int_ColonTransversum_cell|Caffeine|P*SA intracellular -> interstitial
P_4639 = (P_4485*P_4303);  % CoffeinSimulation|Neighborhoods|ColonDescendens_int_ColonDescendens_cell|Caffeine|P*SA interstitial -> intracellular
P_4640 = (P_4486*P_4303);  % CoffeinSimulation|Neighborhoods|ColonDescendens_int_ColonDescendens_cell|Caffeine|P*SA intracellular -> interstitial
P_4641 = (P_4487*P_4304);  % CoffeinSimulation|Neighborhoods|ColonSigmoid_int_ColonSigmoid_cell|Caffeine|P*SA interstitial -> intracellular
P_4642 = (P_4488*P_4304);  % CoffeinSimulation|Neighborhoods|ColonSigmoid_int_ColonSigmoid_cell|Caffeine|P*SA intracellular -> interstitial
P_4643 = (P_4489*P_4305);  % CoffeinSimulation|Neighborhoods|Rectum_int_Rectum_cell|Caffeine|P*SA interstitial -> intracellular
P_4644 = (P_4490*P_4305);  % CoffeinSimulation|Neighborhoods|Rectum_int_Rectum_cell|Caffeine|P*SA intracellular -> interstitial
P_4645 = P_4494;  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|DrugAbsorption_trans|ProcessRate
P_4646 = P_4497;  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_pls|Caffeine|DrugAbsorption_para|ProcessRate
P_4647 = P_4498;  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|DrugAbsorption_trans|ProcessRate
P_4648 = P_4504;  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|DrugAbsorption_trans|ProcessRate
P_4649 = P_4507;  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|DrugAbsorption_trans|ProcessRate
P_4650 = P_4513;  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|DrugAbsorption_trans|ProcessRate
P_4651 = P_4514;  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|DrugAbsorption_trans|ProcessRate
P_4652 = (P_3401+P_4515);  % CoffeinSimulation|Caffeine|pKa_Base_1
P_4653 = (P_3399+P_4516);  % CoffeinSimulation|Caffeine|pKa_Acid_1
P_4654 = (P_3427+P_4517);  % CoffeinSimulation|CYP1A2|pKa_Base_1
P_4655 = (P_3425+P_4518);  % CoffeinSimulation|CYP1A2|pKa_Acid_1
P_4656 = (P_3453+P_4519);  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_Base_1
P_4657 = (P_3451+P_4520);  % CoffeinSimulation|Caffeine-CYP1A2 Metabolite|pKa_Acid_1
global P_4658;
P_4658 = (P_4521/P_1531);  % CoffeinSimulation|Applications|3 mg per kg Infusion (10 min)|Application_1|ProtocolSchemaItem|DrugMass
P_4659 = P_4545;  % CoffeinSimulation|Organism|SmallIntestine|Plasma|CYP1A2
P_4660 = P_4546;  % CoffeinSimulation|Organism|SmallIntestine|BloodCells|CYP1A2
P_4661 = (IIf((P_4031 > 0),(P_4547/P_4031),0));  % CoffeinSimulation|Organism|SmallIntestine|Intracellular|CYP1A2|Concentration
P_4662 = (P_4544*(P_2890/P_640));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Fluid recirculation flow rate
P_4663 = (IIf((P_3615 > 0),(P_4548/P_3615),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|Plasma|CYP1A2|Concentration
P_4664 = (IIf((P_3616 > 0),(P_4549/P_3616),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|Duodenum|BloodCells|CYP1A2|Concentration
P_4665 = (P_4544*(P_2900/P_640));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Fluid recirculation flow rate
P_4666 = (IIf((P_3623 > 0),(P_4551/P_3623),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|Plasma|CYP1A2|Concentration
P_4667 = (IIf((P_3624 > 0),(P_4552/P_3624),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperJejunum|BloodCells|CYP1A2|Concentration
P_4668 = (P_4544*(P_2910/P_640));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Fluid recirculation flow rate
P_4669 = (IIf((P_3631 > 0),(P_4554/P_3631),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|Plasma|CYP1A2|Concentration
P_4670 = (IIf((P_3632 > 0),(P_4555/P_3632),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerJejunum|BloodCells|CYP1A2|Concentration
P_4671 = (P_4544*(P_2920/P_640));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Fluid recirculation flow rate
P_4672 = (IIf((P_3639 > 0),(P_4557/P_3639),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|Plasma|CYP1A2|Concentration
P_4673 = (IIf((P_3640 > 0),(P_4558/P_3640),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|UpperIleum|BloodCells|CYP1A2|Concentration
P_4674 = (P_4544*(P_2930/P_640));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Fluid recirculation flow rate
P_4675 = (IIf((P_3647 > 0),(P_4560/P_3647),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|Plasma|CYP1A2|Concentration
P_4676 = (IIf((P_3648 > 0),(P_4561/P_3648),0));  % CoffeinSimulation|Organism|SmallIntestine|Mucosa|LowerIleum|BloodCells|CYP1A2|Concentration
P_4677 = P_4564;  % CoffeinSimulation|Organism|LargeIntestine|Plasma|CYP1A2
P_4678 = P_4565;  % CoffeinSimulation|Organism|LargeIntestine|BloodCells|CYP1A2
P_4679 = (IIf((P_4113 > 0),(P_4566/P_4113),0));  % CoffeinSimulation|Organism|LargeIntestine|Intracellular|CYP1A2|Concentration
P_4680 = (P_4563*(P_2950/P_876));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Fluid recirculation flow rate
P_4681 = (IIf((P_3658 > 0),(P_4567/P_3658),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|Plasma|CYP1A2|Concentration
P_4682 = (IIf((P_3659 > 0),(P_4568/P_3659),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Caecum|BloodCells|CYP1A2|Concentration
P_4683 = (P_4563*(P_2960/P_876));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Fluid recirculation flow rate
P_4684 = (IIf((P_3666 > 0),(P_4570/P_3666),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|Plasma|CYP1A2|Concentration
P_4685 = (IIf((P_3667 > 0),(P_4571/P_3667),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonAscendens|BloodCells|CYP1A2|Concentration
P_4686 = (P_4563*(P_2970/P_876));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Fluid recirculation flow rate
P_4687 = (IIf((P_3674 > 0),(P_4573/P_3674),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|Plasma|CYP1A2|Concentration
P_4688 = (IIf((P_3675 > 0),(P_4574/P_3675),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonTransversum|BloodCells|CYP1A2|Concentration
P_4689 = (P_4563*(P_2980/P_876));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Fluid recirculation flow rate
P_4690 = (IIf((P_3682 > 0),(P_4576/P_3682),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|Plasma|CYP1A2|Concentration
P_4691 = (IIf((P_3683 > 0),(P_4577/P_3683),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonDescendens|BloodCells|CYP1A2|Concentration
P_4692 = (P_4563*(P_2990/P_876));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Fluid recirculation flow rate
P_4693 = (IIf((P_3690 > 0),(P_4579/P_3690),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|Plasma|CYP1A2|Concentration
P_4694 = (IIf((P_3691 > 0),(P_4580/P_3691),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|ColonSigmoid|BloodCells|CYP1A2|Concentration
P_4695 = (P_4563*(P_3000/P_876));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Fluid recirculation flow rate
P_4696 = (IIf((P_3698 > 0),(P_4582/P_3698),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|Plasma|CYP1A2|Concentration
P_4697 = (IIf((P_3699 > 0),(P_4583/P_3699),0));  % CoffeinSimulation|Organism|LargeIntestine|Mucosa|Rectum|BloodCells|CYP1A2|Concentration
P_4698 = (IIf((P_4590 > 0),(y(253)/P_4590),0));  % CoffeinSimulation|Organism|Saliva|Saliva|Caffeine|Concentration
P_4699 = (IIf((P_4591 > 0),(y(254)/P_4591),0));  % CoffeinSimulation|Organism|Saliva|SalivaGland|Caffeine|Concentration
P_4700 = P_4592;  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_pls|Caffeine|Sum of passive process rates
P_4701 = P_4593;  % CoffeinSimulation|Neighborhoods|Lumen_uje_UpperJejunum_cell|Caffeine|Sum of passive process rates
P_4702 = P_4594;  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_pls|Caffeine|Sum of passive process rates
P_4703 = P_4595;  % CoffeinSimulation|Neighborhoods|Lumen_lje_LowerJejunum_cell|Caffeine|Sum of passive process rates
P_4704 = P_4596;  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_pls|Caffeine|Sum of passive process rates
P_4705 = P_4597;  % CoffeinSimulation|Neighborhoods|Lumen_uil_UpperIleum_cell|Caffeine|Sum of passive process rates
P_4706 = P_4603;  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_cell|Caffeine|Sum of passive process rates
P_4707 = P_4605;  % CoffeinSimulation|Neighborhoods|Lumen_lil_LowerIleum_pls|Caffeine|Sum of passive process rates
P_4708 = P_4622;  % CoffeinSimulation|Neighborhoods|Lumen_rect_Rectum_cell|Caffeine|Sum of passive process rates
P_4709 = P_4645;  % CoffeinSimulation|Neighborhoods|Lumen_colsigm_ColonSigmoid_cell|Caffeine|Sum of passive process rates
P_4710 = P_4646;  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_pls|Caffeine|Sum of passive process rates
P_4711 = P_4647;  % CoffeinSimulation|Neighborhoods|Lumen_duo_Duodenum_cell|Caffeine|Sum of passive process rates
P_4712 = P_4648;  % CoffeinSimulation|Neighborhoods|Lumen_coldesc_ColonDescendens_cell|Caffeine|Sum of passive process rates
P_4713 = P_4649;  % CoffeinSimulation|Neighborhoods|Lumen_cae_Caecum_cell|Caffeine|Sum of passive process rates
P_4714 = P_4650;  % CoffeinSimulation|Neighborhoods|Lumen_coltrans_ColonTransversum_cell|Caffeine|Sum of passive process rates
P_4715 = P_4651;  % CoffeinSimulation|Neighborhoods|Lumen_colasc_ColonAscendens_cell|Caffeine|Sum of passive process rates
P_4716 = P_4658;  % CoffeinSimulation|Caffeine|Total drug mass
P_4717 = (P_4544-(P_4662+P_4665+P_4668+P_4671+P_4674));  % CoffeinSimulation|Organism|SmallIntestine|Fluid recirculation flow rate
P_4718 = (IIf((P_4026 > 0),(P_4659/P_4026),0));  % CoffeinSimulation|Organism|SmallIntestine|Plasma|CYP1A2|Concentration
P_4719 = (IIf((P_4027 > 0),(P_4660/P_4027),0));  % CoffeinSimulation|Organism|SmallIntestine|BloodCells|CYP1A2|Concentration
P_4720 = (P_4563-(P_4680+P_4683+P_4686+P_4689+P_4692+P_4695));  % CoffeinSimulation|Organism|LargeIntestine|Fluid recirculation flow rate
P_4721 = (IIf((P_4108 > 0),(P_4677/P_4108),0));  % CoffeinSimulation|Organism|LargeIntestine|Plasma|CYP1A2|Concentration
P_4722 = (IIf((P_4109 > 0),(P_4678/P_4109),0));  % CoffeinSimulation|Organism|LargeIntestine|BloodCells|CYP1A2|Concentration
P_4723 = (IIf((P_1645 > 0),(y(255)/P_1645),0));  % CoffeinSimulation|Applications|3 mg per kg Infusion (10 min)|Application_1|Caffeine|Concentration

dy(1) =  ...
            (0-(P_4322*P_2559*P_1656*P_2557*(P_2556/(P_1661+(P_2557*P_2556))))) ...
            +(0-(P_2404*P_2514*((P_3915*P_2556)-(P_3912*(P_2563/P_3397))))) ...
            +(0-(P_3731*(1-P_42)*P_2556)) ...
            +(P_2579*(1-P_42)*P_2584) ...
            +(P_2601*(1-P_42)*P_2605) ...
            +(P_2622*(1-P_42)*P_2626) ...
            +(P_2643*(1-P_42)*P_2647) ...
            +(P_2664*(1-P_42)*P_2668) ...
            +(P_2686*(1-P_42)*P_2690) ...
            +(P_3064*(1-P_42)*P_3068) ...
            +(P_3119*(1-P_42)*P_3123) ...
            +(IIf(P_1115,((P_3719+P_3752)*(1-P_42)*P_3721),0)) ...
            +(IIf(P_1115,0,((P_3706+P_3752)*(1-P_42)*P_3708))) ...
            +EvalParameter(P_1640, Time, y);
dy(2) =  ...
            (P_4322*P_2559*P_1656*P_2557*(P_2556/(P_1661+(P_2557*P_2556))));
dy(3) =  ...
            (0-(P_4323*P_2565*P_1662*P_3480*(P_2563/(P_1667+(P_3480*P_2563))))) ...
            +(0-(P_3731*P_42*P_2563)) ...
            +(P_2404*P_2514*((P_3915*P_2556)-(P_3912*(P_2563/P_3397)))) ...
            +(P_2579*P_42*P_2591) ...
            +(P_2601*P_42*P_2612) ...
            +(P_2622*P_42*P_2633) ...
            +(P_2643*P_42*P_2654) ...
            +(P_2664*P_42*P_2675) ...
            +(P_2686*P_42*P_2697) ...
            +(P_3064*P_42*P_3075) ...
            +(P_3119*P_42*P_3130) ...
            +(IIf(P_1115,0,((P_3706+P_3752)*P_42*P_3711))) ...
            +(IIf(P_1115,((P_3719+P_3752)*P_42*P_3724),0));
dy(4) =  ...
            (P_4323*P_2565*P_1662*P_3480*(P_2563/(P_1667+(P_3480*P_2563))));
dy(5) =  ...
            (0-(P_4324*P_2572*P_1669*P_2570*(P_2569/(P_1674+(P_2570*P_2569))))) ...
            +(0-(P_2405*P_2514*((P_3915*P_2569)-(P_3912*(P_2576/P_3397))))) ...
            +(P_3731*(1-P_42)*P_3047) ...
            +(0-(P_2664*(1-P_42)*P_2569)) ...
            +(0-(P_2860*(1-P_42)*P_2569)) ...
            +(0-(P_3140*(1-P_42)*P_2569)) ...
            +(0-(P_2880*(1-P_42)*P_2569)) ...
            +(0-(P_3119*(1-P_42)*P_2569)) ...
            +(0-(P_3085*(1-P_42)*P_2569)) ...
            +(0-(P_3064*(1-P_42)*P_2569)) ...
            +(0-(P_2686*(1-P_42)*P_2569)) ...
            +(0-(P_2643*(1-P_42)*P_2569)) ...
            +(0-(P_2622*(1-P_42)*P_2569)) ...
            +(0-(P_2601*(1-P_42)*P_2569)) ...
            +(0-(P_2579*(1-P_42)*P_2569)) ...
            +(0-(P_2940*(1-P_42)*P_2569)) ...
            +(0-(P_3706*(1-P_42)*P_2569));
dy(6) =  ...
            (P_4324*P_2572*P_1669*P_2570*(P_2569/(P_1674+(P_2570*P_2569))));
dy(7) =  ...
            (0-(P_4325*P_2578*P_1675*P_3483*(P_2576/(P_1680+(P_3483*P_2576))))) ...
            +(P_2405*P_2514*((P_3915*P_2569)-(P_3912*(P_2576/P_3397)))) ...
            +(P_3731*P_42*P_3054) ...
            +(0-(P_2860*P_42*P_2576)) ...
            +(0-(P_3140*P_42*P_2576)) ...
            +(0-(P_2880*P_42*P_2576)) ...
            +(0-(P_3119*P_42*P_2576)) ...
            +(0-(P_3085*P_42*P_2576)) ...
            +(0-(P_3064*P_42*P_2576)) ...
            +(0-(P_2664*P_42*P_2576)) ...
            +(0-(P_2940*P_42*P_2576)) ...
            +(0-(P_2643*P_42*P_2576)) ...
            +(0-(P_2622*P_42*P_2576)) ...
            +(0-(P_2601*P_42*P_2576)) ...
            +(0-(P_2579*P_42*P_2576)) ...
            +(0-(P_2686*P_42*P_2576)) ...
            +(0-(P_3706*P_42*P_2576));
dy(8) =  ...
            (P_4325*P_2578*P_1675*P_3483*(P_2576/(P_1680+(P_3483*P_2576))));
dy(9) =  ...
            (0-(IIf(P_62,(0.6931471805599453*y(9)*(P_65/P_64)),0)));
dy(10) =  ...
            (0-(P_4326*P_2587*P_1685*P_2585*(P_2584/(P_1690+(P_2585*P_2584))))) ...
            +(0-(P_2514*P_1394*P_2407*(P_2584-(P_2595/P_3161)))) ...
            +(0-(P_2579*(1-P_42)*P_2584)) ...
            +(0-(P_2408*P_2514*((P_3915*P_2584)-(P_3912*(P_2591/P_3397))))) ...
            +(P_2579*(1-P_42)*P_2569);
dy(11) =  ...
            (P_4326*P_2587*P_1685*P_2585*(P_2584/(P_1690+(P_2585*P_2584))));
dy(12) =  ...
            (0-(P_4327*P_2593*P_1691*P_3487*(P_2591/(P_1696+(P_3487*P_2591))))) ...
            +(0-(P_2579*P_42*P_2591)) ...
            +(P_2408*P_2514*((P_3915*P_2584)-(P_3912*(P_2591/P_3397)))) ...
            +(P_2579*P_42*P_2576);
dy(13) =  ...
            (P_4327*P_2593*P_1691*P_3487*(P_2591/(P_1696+(P_3487*P_2591))));
dy(14) =  ...
            (0-((P_3773*P_4256*P_2595)-(P_3770*P_4255*P_3489))) ...
            +(P_2514*P_1394*P_2407*(P_2584-(P_2595/P_3161)));
dy(15) =  ...
            (0-(P_3940*P_2599*P_2596*P_3941*(P_3489/(P_1703+(P_3941*P_3489))))) ...
            +((P_3773*P_4256*P_2595)-(P_3770*P_4255*P_3489));
dy(16) =  ...
            (P_3940*P_2599*P_2596*P_3941*(P_3489/(P_1703+(P_3941*P_3489))));
dy(17) =  ...
            (0-(P_4328*P_2608*P_1706*P_2606*(P_2605/(P_1711+(P_2606*P_2605))))) ...
            +(0-(P_2514*P_3774*P_2409*(P_2605-(P_2616/P_3162)))) ...
            +(0-(P_2601*(1-P_42)*P_2605)) ...
            +(0-(P_2411*P_2514*((P_3915*P_2605)-(P_3912*(P_2612/P_3397))))) ...
            +(P_2601*(1-P_42)*P_2569);
dy(18) =  ...
            (P_4328*P_2608*P_1706*P_2606*(P_2605/(P_1711+(P_2606*P_2605))));
dy(19) =  ...
            (0-(P_4329*P_2614*P_1712*P_3494*(P_2612/(P_1717+(P_3494*P_2612))))) ...
            +(0-(P_2601*P_42*P_2612)) ...
            +(P_2411*P_2514*((P_3915*P_2605)-(P_3912*(P_2612/P_3397)))) ...
            +(P_2601*P_42*P_2576);
dy(20) =  ...
            (P_4329*P_2614*P_1712*P_3494*(P_2612/(P_1717+(P_3494*P_2612))));
dy(21) =  ...
            (P_2514*P_3774*P_2409*(P_2605-(P_2616/P_3162))) ...
            +(0-((P_3778*P_4258*P_2616)-(P_3777*P_4257*P_3496)));
dy(22) =  ...
            (0-(P_3946*P_2620*P_2617*P_3947*(P_3496/(P_1724+(P_3947*P_3496))))) ...
            +((P_3778*P_4258*P_2616)-(P_3777*P_4257*P_3496));
dy(23) =  ...
            (P_3946*P_2620*P_2617*P_3947*(P_3496/(P_1724+(P_3947*P_3496))));
dy(24) =  ...
            (0-(P_4330*P_2629*P_1727*P_2627*(P_2626/(P_1732+(P_2627*P_2626))))) ...
            +(0-(P_2514*P_1397*P_2412*(P_2626-(P_2637/P_3164)))) ...
            +(0-(P_2622*(1-P_42)*P_2626)) ...
            +(0-(P_2414*P_2514*((P_3915*P_2626)-(P_3912*(P_2633/P_3397))))) ...
            +(P_2622*(1-P_42)*P_2569);
dy(25) =  ...
            (P_4330*P_2629*P_1727*P_2627*(P_2626/(P_1732+(P_2627*P_2626))));
dy(26) =  ...
            (0-(P_4331*P_2635*P_1733*P_3501*(P_2633/(P_1738+(P_3501*P_2633))))) ...
            +(P_2414*P_2514*((P_3915*P_2626)-(P_3912*(P_2633/P_3397)))) ...
            +(0-(P_2622*P_42*P_2633)) ...
            +(P_2622*P_42*P_2576);
dy(27) =  ...
            (P_4331*P_2635*P_1733*P_3501*(P_2633/(P_1738+(P_3501*P_2633))));
dy(28) =  ...
            (P_2514*P_1397*P_2412*(P_2626-(P_2637/P_3164))) ...
            +(0-((P_3782*P_4260*P_2637)-(P_3779*P_4259*P_3503)));
dy(29) =  ...
            (0-(P_3952*P_2641*P_2638*P_3953*(P_3503/(P_1745+(P_3953*P_3503))))) ...
            +((P_3782*P_4260*P_2637)-(P_3779*P_4259*P_3503));
dy(30) =  ...
            (P_3952*P_2641*P_2638*P_3953*(P_3503/(P_1745+(P_3953*P_3503))));
dy(31) =  ...
            (0-(P_4332*P_2650*P_1748*P_2648*(P_2647/(P_1753+(P_2648*P_2647))))) ...
            +(0-(P_2643*(1-P_42)*P_2647)) ...
            +(0-(P_2514*P_1402*P_2416*(P_2647-(P_2658/P_3167)))) ...
            +(0-(P_2417*P_2514*((P_3915*P_2647)-(P_3912*(P_2654/P_3397))))) ...
            +(P_2643*(1-P_42)*P_2569);
dy(32) =  ...
            (P_4332*P_2650*P_1748*P_2648*(P_2647/(P_1753+(P_2648*P_2647))));
dy(33) =  ...
            (0-(P_4333*P_2656*P_1754*P_3508*(P_2654/(P_1759+(P_3508*P_2654))))) ...
            +(0-(P_2643*P_42*P_2654)) ...
            +(P_2417*P_2514*((P_3915*P_2647)-(P_3912*(P_2654/P_3397)))) ...
            +(P_2643*P_42*P_2576);
dy(34) =  ...
            (P_4333*P_2656*P_1754*P_3508*(P_2654/(P_1759+(P_3508*P_2654))));
dy(35) =  ...
            (0-((P_3786*P_4262*P_2658)-(P_3783*P_4261*P_3510))) ...
            +(P_2514*P_1402*P_2416*(P_2647-(P_2658/P_3167)));
dy(36) =  ...
            (0-(P_3958*P_2662*P_2659*P_3959*(P_3510/(P_1766+(P_3959*P_3510))))) ...
            +((P_3786*P_4262*P_2658)-(P_3783*P_4261*P_3510));
dy(37) =  ...
            (P_3958*P_2662*P_2659*P_3959*(P_3510/(P_1766+(P_3959*P_3510))));
dy(38) =  ...
            (0-(P_4334*P_2671*P_1769*P_2669*(P_2668/(P_1774+(P_2669*P_2668))))) ...
            +(0-(P_2514*P_1403*P_2418*(P_2668-(P_2679/P_3168)))) ...
            +(0-(P_2419*P_2514*((P_3915*P_2668)-(P_3912*(P_2675/P_3397))))) ...
            +(0-(P_2664*(1-P_42)*P_2668)) ...
            +(P_2664*(1-P_42)*P_2569);
dy(39) =  ...
            (P_4334*P_2671*P_1769*P_2669*(P_2668/(P_1774+(P_2669*P_2668))));
dy(40) =  ...
            (0-(P_4335*P_2677*P_1775*P_3515*(P_2675/(P_1780+(P_3515*P_2675))))) ...
            +(P_2419*P_2514*((P_3915*P_2668)-(P_3912*(P_2675/P_3397)))) ...
            +(0-(P_2664*P_42*P_2675)) ...
            +(P_2664*P_42*P_2576);
dy(41) =  ...
            (P_4335*P_2677*P_1775*P_3515*(P_2675/(P_1780+(P_3515*P_2675))));
dy(42) =  ...
            (P_2514*P_1403*P_2418*(P_2668-(P_2679/P_3168))) ...
            +(0-((P_3790*P_4263*P_2679)-(P_3788*P_4264*P_3517)));
dy(43) =  ...
            (0-(P_3964*P_2683*P_2680*P_3965*(P_3517/(P_1787+(P_3965*P_3517))))) ...
            +((P_3790*P_4263*P_2679)-(P_3788*P_4264*P_3517));
dy(44) =  ...
            (P_3964*P_2683*P_2680*P_3965*(P_3517/(P_1787+(P_3965*P_3517))));
dy(45) =  ...
            (0-(P_4336*P_2693*P_1790*P_2691*(P_2690/(P_1795+(P_2691*P_2690))))) ...
            +(0-(P_2428*P_2514*((P_3915*P_2690)-(P_3912*(P_2697/P_3397))))) ...
            +(0-(P_2514*P_1410*P_2429*(P_2690-(P_2701/P_3187)))) ...
            +(0-(P_312*P_2430*P_2690*P_2514)) ...
            +(0-(P_2686*(1-P_42)*P_2690)) ...
            +(P_2686*(1-P_42)*P_2569);
dy(46) =  ...
            (P_4336*P_2693*P_1790*P_2691*(P_2690/(P_1795+(P_2691*P_2690))));
dy(47) =  ...
            (0-(P_4337*P_2699*P_1796*P_3523*(P_2697/(P_1801+(P_3523*P_2697))))) ...
            +(P_2428*P_2514*((P_3915*P_2690)-(P_3912*(P_2697/P_3397)))) ...
            +(0-(P_2686*P_42*P_2697)) ...
            +(P_2686*P_42*P_2576);
dy(48) =  ...
            (P_4337*P_2699*P_1796*P_3523*(P_2697/(P_1801+(P_3523*P_2697))));
dy(49) =  ...
            (0-((P_3797*P_4267*P_2701)-(P_3794*P_4266*P_3525))) ...
            +(P_2514*P_1410*P_2429*(P_2690-(P_2701/P_3187)));
dy(50) =  ...
            (0-(P_3970*P_2705*P_2702*P_3971*(P_3525/(P_1808+(P_3971*P_3525))))) ...
            +((P_3797*P_4267*P_2701)-(P_3794*P_4266*P_3525));
dy(51) =  ...
            (P_3970*P_2705*P_2702*P_3971*(P_3525/(P_1808+(P_3971*P_3525))));
dy(52) =  ...
            (P_312*P_2430*P_2690*P_2514);
dy(53) =  ...
            (IIf(P_331,(0+((P_2706*P_3972)-P_4522)),0));
dy(54) =  ...
            (0-(P_4338*P_2715*P_1812*P_350*(P_2710/(P_1817+(P_350*P_2710))))) ...
            +(0-(IIf((P_331 & P_1526),(P_1811*y(54)*P_4340),0)));
dy(55) =  ...
            (P_4338*P_2715*P_1812*P_350*(P_2710/(P_1817+(P_350*P_2710))));
dy(56) =  ...
            (IIf(P_331,(P_4522+((P_3537*P_4340)-(P_4523+(P_3976*y(56))))),0));
dy(57) =  ...
            (0-(P_4524*P_2728*P_2717*P_369*(P_3540/(P_1829+(P_369*P_3540))))) ...
            +(0-(IIf((P_331 & P_1526),(P_2716*y(57)*P_4342),0))) ...
            +(IIf((P_331 & P_1526),(P_1811*y(54)*P_4340),0)) ...
            +(IIf(P_62,(0.6931471805599453*y(9)*(P_65/P_64)),0)) ...
            +(0-P_4497) ...
            +(0-P_4498);
dy(58) =  ...
            (P_4710+(P_4711-(P_1493+P_1494)));
dy(59) =  ...
            (P_4524*P_2728*P_2717*P_369*(P_3540/(P_1829+(P_369*P_3540))));
dy(60) =  ...
            (IIf(P_331,(P_4523+((P_3543*P_4342)-(P_4525+(P_3980*y(60))))),0));
dy(61) =  ...
            (0-(P_4526*P_2741*P_2729*P_388*(P_3546/(P_1841+(P_388*P_3546))))) ...
            +(0-P_4445) ...
            +(0-P_4446) ...
            +(0-(IIf((P_331 & P_1526),(P_2730*y(61)*P_4344),0))) ...
            +(IIf((P_331 & P_1526),(P_2716*y(57)*P_4342),0));
dy(62) =  ...
            (P_4700+(P_4701-(P_1406+P_1407)));
dy(63) =  ...
            (P_4526*P_2741*P_2729*P_388*(P_3546/(P_1841+(P_388*P_3546))));
dy(64) =  ...
            (IIf(P_331,(P_4525+((P_3549*P_4344)-(P_4527+(P_3983*y(64))))),0));
dy(65) =  ...
            (0-(P_4528*P_2754*P_2742*P_407*(P_3552/(P_1853+(P_407*P_3552))))) ...
            +(0-P_4449) ...
            +(0-P_4450) ...
            +(IIf((P_331 & P_1526),(P_2730*y(61)*P_4344),0)) ...
            +(0-(IIf((P_331 & P_1526),(P_2744*y(65)*P_4346),0)));
dy(66) =  ...
            (P_4702+(P_4703-(P_1417+P_1418)));
dy(67) =  ...
            (P_4528*P_2754*P_2742*P_407*(P_3552/(P_1853+(P_407*P_3552))));
dy(68) =  ...
            (IIf(P_331,(P_4527+((P_3556*P_4346)-(P_4529+(P_3987*y(68))))),0));
dy(69) =  ...
            (0-(P_4530*P_2767*P_2757*P_426*(P_3558/(P_1865+(P_426*P_3558))))) ...
            +(IIf((P_331 & P_1526),(P_2744*y(65)*P_4346),0)) ...
            +(0-(IIf((P_331 & P_1526),(P_2756*y(69)*P_4348),0))) ...
            +(0-P_4453) ...
            +(0-P_4454);
dy(70) =  ...
            (P_4704+(P_4705-(P_1422+P_1423)));
dy(71) =  ...
            (P_4530*P_2767*P_2757*P_426*(P_3558/(P_1865+(P_426*P_3558))));
dy(72) =  ...
            (IIf(P_331,(P_4529+((P_3563*P_4348)-(P_4531+(P_3991*y(72))))),0));
dy(73) =  ...
            (0-(P_4532*P_2780*P_2768*P_445*(P_3564/(P_1877+(P_445*P_3564))))) ...
            +(0-(IIf((P_331 & P_1526),(P_2770*y(73)*P_4350),0))) ...
            +(IIf((P_331 & P_1526),(P_2756*y(69)*P_4348),0)) ...
            +(0-P_4461) ...
            +(0-P_4462);
dy(74) =  ...
            (P_4707+(P_4706-(P_1428+P_1427)));
dy(75) =  ...
            (P_4532*P_2780*P_2768*P_445*(P_3564/(P_1877+(P_445*P_3564))));
dy(76) =  ...
            (IIf(P_331,(P_4531+((P_3569*P_4350)-(P_4533+(P_3995*y(76))))),0));
dy(77) =  ...
            (0-(P_4534*P_2793*P_2783*P_464*(P_3570/(P_1889+(P_464*P_3570))))) ...
            +(0-(IIf((P_331 & P_1526),(P_2781*y(77)*P_4352),0))) ...
            +(IIf((P_331 & P_1526),(P_2770*y(73)*P_4350),0)) ...
            +(0-P_4507);
dy(78) =  ...
            (P_1499+(P_4713-(P_1498+P_1500)));
dy(79) =  ...
            (P_4534*P_2793*P_2783*P_464*(P_3570/(P_1889+(P_464*P_3570))));
dy(80) =  ...
            (IIf(P_331,(P_4533+((P_3575*P_4352)-(P_4535+(P_3999*y(80))))),0));
dy(81) =  ...
            (0-(P_4536*P_2806*P_2795*P_483*(P_3576/(P_1901+(P_483*P_3576))))) ...
            +(0-(IIf((P_331 & P_1526),(P_2796*y(81)*P_4354),0))) ...
            +(IIf((P_331 & P_1526),(P_2781*y(77)*P_4352),0)) ...
            +(0-P_4514);
dy(82) =  ...
            (P_1502+(P_4715-(P_1501+P_1506)));
dy(83) =  ...
            (P_4536*P_2806*P_2795*P_483*(P_3576/(P_1901+(P_483*P_3576))));
dy(84) =  ...
            (IIf(P_331,(P_4535+((P_3580*P_4354)-(P_4537+(P_4004*y(84))))),0));
dy(85) =  ...
            (0-(P_4538*P_2819*P_2809*P_502*(P_3582/(P_1913+(P_502*P_3582))))) ...
            +(IIf((P_331 & P_1526),(P_2796*y(81)*P_4354),0)) ...
            +(0-(IIf((P_331 & P_1526),(P_2808*y(85)*P_4356),0))) ...
            +(0-P_4513);
dy(86) =  ...
            (P_1504+(P_4714-(P_1503+P_1505)));
dy(87) =  ...
            (P_4538*P_2819*P_2809*P_502*(P_3582/(P_1913+(P_502*P_3582))));
dy(88) =  ...
            (IIf(P_331,(P_4537+((P_3586*P_4356)-(P_4539+(P_4007*y(88))))),0));
dy(89) =  ...
            (0-(P_4540*P_2832*P_2822*P_521*(P_3588/(P_1925+(P_521*P_3588))))) ...
            +(0-(IIf((P_331 & P_1526),(P_2821*y(89)*P_4358),0))) ...
            +(IIf((P_331 & P_1526),(P_2808*y(85)*P_4356),0)) ...
            +(0-P_4504);
dy(90) =  ...
            (P_1496+(P_4712-(P_1495+P_1497)));
dy(91) =  ...
            (P_4540*P_2832*P_2822*P_521*(P_3588/(P_1925+(P_521*P_3588))));
dy(92) =  ...
            (IIf(P_331,(P_4539+((P_3591*P_4358)-(P_4541+(P_4012*y(92))))),0));
dy(93) =  ...
            (0-(P_4542*P_2845*P_2833*P_540*(P_3594/(P_1937+(P_540*P_3594))))) ...
            +(0-(IIf((P_331 & P_1526),(P_2835*y(93)*P_4360),0))) ...
            +(IIf((P_331 & P_1526),(P_2821*y(89)*P_4358),0)) ...
            +(0-P_4494);
dy(94) =  ...
            (P_1491+(P_4709-(P_1490+P_1492)));
dy(95) =  ...
            (P_4542*P_2845*P_2833*P_540*(P_3594/(P_1937+(P_540*P_3594))));
dy(96) =  ...
            (IIf(P_331,(P_4541+((P_3598*P_4360)-P_4017)),0));
dy(97) =  ...
            (0-(P_4543*P_2858*P_2847*P_559*(P_3600/(P_1949+(P_559*P_3600))))) ...
            +(0-(IIf(P_331,(P_2848*y(97)),0))) ...
            +(IIf((P_331 & P_1526),(P_2835*y(93)*P_4360),0)) ...
            +(0-P_4468);
dy(98) =  ...
            (P_1448+(P_4708-(P_1447+P_1449)));
dy(99) =  ...
            (P_4543*P_2858*P_2847*P_559*(P_3600/(P_1949+(P_559*P_3600))));
dy(100) =  ...
            (IIf(P_331,P_4017,0));
dy(101) =  ...
            (IIf(P_331,(P_2848*y(97)),0));
dy(102) =  ...
            (0-(P_4362*P_2867*P_1953*P_2865*(P_2864/(P_1958+(P_2865*P_2864))))) ...
            +(0-(P_2514*P_1419*P_2438*(P_2864-(P_2875/P_3204)))) ...
            +(0-(P_2860*(1-P_42)*P_2864)) ...
            +(0-(P_2440*P_2514*((P_3915*P_2864)-(P_3912*(P_2871/P_3397))))) ...
            +(P_2860*(1-P_42)*P_2569);
dy(103) =  ...
            (P_4362*P_2867*P_1953*P_2865*(P_2864/(P_1958+(P_2865*P_2864))));
dy(104) =  ...
            (0-(P_4363*P_2873*P_1959*P_3606*(P_2871/(P_1964+(P_3606*P_2871))))) ...
            +(0-(P_2860*P_42*P_2871)) ...
            +(P_2440*P_2514*((P_3915*P_2864)-(P_3912*(P_2871/P_3397)))) ...
            +(P_2860*P_42*P_2576);
dy(105) =  ...
            (P_4363*P_2873*P_1959*P_3606*(P_2871/(P_1964+(P_3606*P_2871))));
dy(106) =  ...
            (P_2514*P_1419*P_2438*(P_2864-(P_2875/P_3204))) ...
            +(0-((P_3804*P_4270*P_2875)-(P_3803*P_4271*P_3608)));
dy(107) =  ...
            (0-(P_4024*P_2879*P_2876*P_4025*(P_3608/(P_1971+(P_4025*P_3608))))) ...
            +((P_3804*P_4270*P_2875)-(P_3803*P_4271*P_3608));
dy(108) =  ...
            (P_4024*P_2879*P_2876*P_4025*(P_3608/(P_1971+(P_4025*P_3608))));
dy(109) =  ...
            (0-(P_4718*P_2884*P_4026*P_2883*(P_4367/(P_1979+(P_2883*P_4367))))) ...
            +(0-((1-P_611)*P_2880*(1-P_42)*P_4367)) ...
            +(0-P_4598) ...
            +(0-(P_2514*P_1426*P_4274*(P_4367-(P_4373/P_3223)))) ...
            +(0-(P_4275*P_2514*((P_3915*P_4367)-(P_3912*(P_4370/P_3397))))) ...
            +(0-P_4599) ...
            +(0-P_4602) ...
            +(0-P_4607) ...
            +(0-P_4609) ...
            +(P_2880*(1-P_42)*P_2569);
dy(110) =  ...
            (P_4718*P_2884*P_4026*P_2883*(P_4367/(P_1979+(P_2883*P_4367))));
dy(111) =  ...
            (0-(P_4719*P_2887*P_4027*P_3612*(P_4370/(P_1984+(P_3612*P_4370))))) ...
            +(P_4275*P_2514*((P_3915*P_4367)-(P_3912*(P_4370/P_3397)))) ...
            +(0-P_4600) ...
            +(0-((1-P_611)*P_2880*P_42*P_4370)) ...
            +(0-P_4601) ...
            +(0-P_4604) ...
            +(0-P_4606) ...
            +(0-P_4608) ...
            +(P_2880*P_42*P_2576);
dy(112) =  ...
            (P_4719*P_2887*P_4027*P_3612*(P_4370/(P_1984+(P_3612*P_4370))));
dy(113) =  ...
            (0-((P_3811*P_4457*P_4373)-(P_3808*P_4458*P_4375))) ...
            +(P_2514*P_1426*P_4274*(P_4367-(P_4373/P_3223)));
dy(114) =  ...
            (0-(P_4661*P_2889*P_4031*P_4032*(P_4375/(P_1989+(P_4032*P_4375))))) ...
            +((P_3811*P_4457*P_4373)-(P_3808*P_4458*P_4375));
dy(115) =  ...
            (P_4661*P_2889*P_4031*P_4032*(P_4375/(P_1989+(P_4032*P_4375))));
dy(116) =  ...
            (0-(P_4663*P_2894*P_3615*P_2893*(P_4036/(P_1995+(P_2893*P_4036))))) ...
            +P_4598 ...
            +(0-(P_2514*P_1457*P_3850*(P_4036-(P_4042/P_3279)))) ...
            +(0-(P_3851*P_2514*((P_3915*P_4036)-(P_3912*(P_4039/P_3397))))) ...
            +P_4497 ...
            +(0-P_4499);
dy(117) =  ...
            (P_4663*P_2894*P_3615*P_2893*(P_4036/(P_1995+(P_2893*P_4036))));
dy(118) =  ...
            (0-(P_4664*P_2897*P_3616*P_3617*(P_4039/(P_2000+(P_3617*P_4039))))) ...
            +P_4604 ...
            +(P_3851*P_2514*((P_3915*P_4036)-(P_3912*(P_4039/P_3397)))) ...
            +(0-P_4500);
dy(119) =  ...
            (P_4664*P_2897*P_3616*P_3617*(P_4039/(P_2000+(P_3617*P_4039))));
dy(120) =  ...
            (P_2514*P_1457*P_3850*(P_4036-(P_4042/P_3279))) ...
            +(0-((P_3853*P_4623*P_4042)-(P_3852*P_4624*P_4045)));
dy(121) =  ...
            (0-(P_4550*P_2899*P_3620*P_4046*(P_4045/(P_2005+(P_4046*P_4045))))) ...
            +((P_3853*P_4623*P_4042)-(P_3852*P_4624*P_4045)) ...
            +P_4498;
dy(122) =  ...
            (P_4550*P_2899*P_3620*P_4046*(P_4045/(P_2005+(P_4046*P_4045))));
dy(123) =  ...
            (0-(P_4666*P_2904*P_3623*P_2903*(P_4051/(P_2011+(P_2903*P_4051))))) ...
            +P_4445 ...
            +(0-P_4447) ...
            +P_4599 ...
            +(0-(P_2514*P_1460*P_3854*(P_4051-(P_4057/P_3281)))) ...
            +(0-(P_3857*P_2514*((P_3915*P_4051)-(P_3912*(P_4054/P_3397)))));
dy(124) =  ...
            (P_4666*P_2904*P_3623*P_2903*(P_4051/(P_2011+(P_2903*P_4051))));
dy(125) =  ...
            (0-(P_4667*P_2907*P_3624*P_3625*(P_4054/(P_2016+(P_3625*P_4054))))) ...
            +(0-P_4448) ...
            +P_4600 ...
            +(P_3857*P_2514*((P_3915*P_4051)-(P_3912*(P_4054/P_3397))));
dy(126) =  ...
            (P_4667*P_2907*P_3624*P_3625*(P_4054/(P_2016+(P_3625*P_4054))));
dy(127) =  ...
            (P_2514*P_1460*P_3854*(P_4051-(P_4057/P_3281))) ...
            +(0-((P_3856*P_4626*P_4057)-(P_3855*P_4625*P_4060)));
dy(128) =  ...
            (0-(P_4553*P_2909*P_3628*P_4061*(P_4060/(P_2021+(P_4061*P_4060))))) ...
            +P_4446 ...
            +((P_3856*P_4626*P_4057)-(P_3855*P_4625*P_4060));
dy(129) =  ...
            (P_4553*P_2909*P_3628*P_4061*(P_4060/(P_2021+(P_4061*P_4060))));
dy(130) =  ...
            (0-(P_4669*P_2914*P_3631*P_2913*(P_4066/(P_2027+(P_2913*P_4066))))) ...
            +P_4449 ...
            +(0-P_4451) ...
            +P_4609 ...
            +(0-(P_2514*P_1465*P_3860*(P_4066-(P_4072/P_3284)))) ...
            +(0-(P_3861*P_2514*((P_3915*P_4066)-(P_3912*(P_4069/P_3397)))));
dy(131) =  ...
            (P_4669*P_2914*P_3631*P_2913*(P_4066/(P_2027+(P_2913*P_4066))));
dy(132) =  ...
            (0-(P_4670*P_2917*P_3632*P_3633*(P_4069/(P_2032+(P_3633*P_4069))))) ...
            +(0-P_4452) ...
            +P_4608 ...
            +(P_3861*P_2514*((P_3915*P_4066)-(P_3912*(P_4069/P_3397))));
dy(133) =  ...
            (P_4670*P_2917*P_3632*P_3633*(P_4069/(P_2032+(P_3633*P_4069))));
dy(134) =  ...
            (0-((P_3859*P_4627*P_4072)-(P_3858*P_4628*P_4075))) ...
            +(P_2514*P_1465*P_3860*(P_4066-(P_4072/P_3284)));
dy(135) =  ...
            (0-(P_4556*P_2919*P_3636*P_4076*(P_4075/(P_2037+(P_4076*P_4075))))) ...
            +P_4450 ...
            +((P_3859*P_4627*P_4072)-(P_3858*P_4628*P_4075));
dy(136) =  ...
            (P_4556*P_2919*P_3636*P_4076*(P_4075/(P_2037+(P_4076*P_4075))));
dy(137) =  ...
            (0-(P_4672*P_2924*P_3639*P_2923*(P_4081/(P_2043+(P_2923*P_4081))))) ...
            +P_4453 ...
            +(0-P_4455) ...
            +P_4607 ...
            +(0-(P_2514*P_1466*P_3862*(P_4081-(P_4087/P_3285)))) ...
            +(0-(P_3865*P_2514*((P_3915*P_4081)-(P_3912*(P_4084/P_3397)))));
dy(138) =  ...
            (P_4672*P_2924*P_3639*P_2923*(P_4081/(P_2043+(P_2923*P_4081))));
dy(139) =  ...
            (0-(P_4673*P_2927*P_3640*P_3641*(P_4084/(P_2048+(P_3641*P_4084))))) ...
            +(0-P_4456) ...
            +P_4606 ...
            +(P_3865*P_2514*((P_3915*P_4081)-(P_3912*(P_4084/P_3397))));
dy(140) =  ...
            (P_4673*P_2927*P_3640*P_3641*(P_4084/(P_2048+(P_3641*P_4084))));
dy(141) =  ...
            (P_2514*P_1466*P_3862*(P_4081-(P_4087/P_3285))) ...
            +(0-((P_3864*P_4629*P_4087)-(P_3863*P_4630*P_4090)));
dy(142) =  ...
            (0-(P_4559*P_2929*P_3644*P_4091*(P_4090/(P_2053+(P_4091*P_4090))))) ...
            +P_4454 ...
            +((P_3864*P_4629*P_4087)-(P_3863*P_4630*P_4090));
dy(143) =  ...
            (P_4559*P_2929*P_3644*P_4091*(P_4090/(P_2053+(P_4091*P_4090))));
dy(144) =  ...
            (0-(P_4675*P_2934*P_3647*P_2933*(P_4096/(P_2059+(P_2933*P_4096))))) ...
            +(0-P_4460) ...
            +P_4602 ...
            +P_4462 ...
            +(0-(P_3866*P_2514*((P_3915*P_4096)-(P_3912*(P_4099/P_3397))))) ...
            +(0-(P_2514*P_1471*P_3869*(P_4096-(P_4102/P_3288))));
dy(145) =  ...
            (P_4675*P_2934*P_3647*P_2933*(P_4096/(P_2059+(P_2933*P_4096))));
dy(146) =  ...
            (0-(P_4676*P_2937*P_3648*P_3649*(P_4099/(P_2064+(P_3649*P_4099))))) ...
            +(0-P_4459) ...
            +P_4601 ...
            +(P_3866*P_2514*((P_3915*P_4096)-(P_3912*(P_4099/P_3397))));
dy(147) =  ...
            (P_4676*P_2937*P_3648*P_3649*(P_4099/(P_2064+(P_3649*P_4099))));
dy(148) =  ...
            (0-((P_3868*P_4632*P_4102)-(P_3867*P_4631*P_4105))) ...
            +(P_2514*P_1471*P_3869*(P_4096-(P_4102/P_3288)));
dy(149) =  ...
            (0-(P_4562*P_2939*P_3652*P_4106*(P_4105/(P_2069+(P_4106*P_4105))))) ...
            +P_4461 ...
            +((P_3868*P_4632*P_4102)-(P_3867*P_4631*P_4105));
dy(150) =  ...
            (P_4562*P_2939*P_3652*P_4106*(P_4105/(P_2069+(P_4106*P_4105))));
dy(151) =  ...
            (0-(P_4721*P_2944*P_4108*P_2943*(P_4395/(P_2077+(P_2943*P_4395))))) ...
            +(0-P_4610) ...
            +(0-P_4611) ...
            +(0-P_4613) ...
            +(0-P_4615) ...
            +(0-P_4618) ...
            +(0-P_4620) ...
            +(0-(P_4277*P_2514*((P_3915*P_4395)-(P_3912*(P_4398/P_3397))))) ...
            +(0-(P_2514*P_1431*P_4279*(P_4395-(P_4401/P_3241)))) ...
            +(0-((1-P_846)*P_2940*(1-P_42)*P_4395)) ...
            +(P_2940*(1-P_42)*P_2569);
dy(152) =  ...
            (P_4721*P_2944*P_4108*P_2943*(P_4395/(P_2077+(P_2943*P_4395))));
dy(153) =  ...
            (0-(P_4722*P_2947*P_4109*P_3655*(P_4398/(P_2082+(P_3655*P_4398))))) ...
            +(0-P_4612) ...
            +(0-P_4614) ...
            +(0-P_4616) ...
            +(0-P_4617) ...
            +(0-P_4619) ...
            +(0-P_4621) ...
            +(P_4277*P_2514*((P_3915*P_4395)-(P_3912*(P_4398/P_3397)))) ...
            +(0-((1-P_846)*P_2940*P_42*P_4398)) ...
            +(P_2940*P_42*P_2576);
dy(154) =  ...
            (P_4722*P_2947*P_4109*P_3655*(P_4398/(P_2082+(P_3655*P_4398))));
dy(155) =  ...
            (0-((P_3818*P_4463*P_4401)-(P_3817*P_4464*P_4403))) ...
            +(P_2514*P_1431*P_4279*(P_4395-(P_4401/P_3241)));
dy(156) =  ...
            (0-(P_4679*P_2949*P_4113*P_4114*(P_4403/(P_2087+(P_4114*P_4403))))) ...
            +((P_3818*P_4463*P_4401)-(P_3817*P_4464*P_4403));
dy(157) =  ...
            (P_4679*P_2949*P_4113*P_4114*(P_4403/(P_2087+(P_4114*P_4403))));
dy(158) =  ...
            (0-(P_4681*P_2954*P_3658*P_2953*(P_4118/(P_2093+(P_2953*P_4118))))) ...
            +P_4613 ...
            +(0-(P_2514*P_1472*P_3870*(P_4118-(P_4124/P_3289)))) ...
            +(0-(P_3873*P_2514*((P_3915*P_4118)-(P_3912*(P_4121/P_3397))))) ...
            +(0-P_4508);
dy(159) =  ...
            (P_4681*P_2954*P_3658*P_2953*(P_4118/(P_2093+(P_2953*P_4118))));
dy(160) =  ...
            (0-(P_4682*P_2957*P_3659*P_3660*(P_4121/(P_2098+(P_3660*P_4121))))) ...
            +P_4616 ...
            +(P_3873*P_2514*((P_3915*P_4118)-(P_3912*(P_4121/P_3397)))) ...
            +(0-P_4509);
dy(161) =  ...
            (P_4682*P_2957*P_3659*P_3660*(P_4121/(P_2098+(P_3660*P_4121))));
dy(162) =  ...
            (P_2514*P_1472*P_3870*(P_4118-(P_4124/P_3289))) ...
            +(0-((P_3872*P_4633*P_4124)-(P_3871*P_4634*P_4127)));
dy(163) =  ...
            (0-(P_4569*P_2959*P_3663*P_4128*(P_4127/(P_2103+(P_4128*P_4127))))) ...
            +((P_3872*P_4633*P_4124)-(P_3871*P_4634*P_4127)) ...
            +P_4507;
dy(164) =  ...
            (P_4569*P_2959*P_3663*P_4128*(P_4127/(P_2103+(P_4128*P_4127))));
dy(165) =  ...
            (0-(P_4684*P_2964*P_3666*P_2963*(P_4133/(P_2109+(P_2963*P_4133))))) ...
            +P_4615 ...
            +(0-(P_3874*P_2514*((P_3915*P_4133)-(P_3912*(P_4136/P_3397))))) ...
            +(0-(P_2514*P_1477*P_3877*(P_4133-(P_4139/P_3292)))) ...
            +(0-P_4511);
dy(166) =  ...
            (P_4684*P_2964*P_3666*P_2963*(P_4133/(P_2109+(P_2963*P_4133))));
dy(167) =  ...
            (0-(P_4685*P_2967*P_3667*P_3668*(P_4136/(P_2114+(P_3668*P_4136))))) ...
            +P_4617 ...
            +(P_3874*P_2514*((P_3915*P_4133)-(P_3912*(P_4136/P_3397)))) ...
            +(0-P_4505);
dy(168) =  ...
            (P_4685*P_2967*P_3667*P_3668*(P_4136/(P_2114+(P_3668*P_4136))));
dy(169) =  ...
            (0-((P_3876*P_4636*P_4139)-(P_3875*P_4635*P_4142))) ...
            +(P_2514*P_1477*P_3877*(P_4133-(P_4139/P_3292)));
dy(170) =  ...
            (0-(P_4572*P_2969*P_3671*P_4143*(P_4142/(P_2119+(P_4143*P_4142))))) ...
            +((P_3876*P_4636*P_4139)-(P_3875*P_4635*P_4142)) ...
            +P_4514;
dy(171) =  ...
            (P_4572*P_2969*P_3671*P_4143*(P_4142/(P_2119+(P_4143*P_4142))));
dy(172) =  ...
            (0-(P_4687*P_2974*P_3674*P_2973*(P_4148/(P_2125+(P_2973*P_4148))))) ...
            +P_4618 ...
            +(0-(P_2514*P_1478*P_3878*(P_4148-(P_4154/P_3293)))) ...
            +(0-(P_3881*P_2514*((P_3915*P_4148)-(P_3912*(P_4151/P_3397))))) ...
            +(0-P_4501);
dy(173) =  ...
            (P_4687*P_2974*P_3674*P_2973*(P_4148/(P_2125+(P_2973*P_4148))));
dy(174) =  ...
            (0-(P_4688*P_2977*P_3675*P_3676*(P_4151/(P_2130+(P_3676*P_4151))))) ...
            +P_4619 ...
            +(P_3881*P_2514*((P_3915*P_4148)-(P_3912*(P_4151/P_3397)))) ...
            +(0-P_4502);
dy(175) =  ...
            (P_4688*P_2977*P_3675*P_3676*(P_4151/(P_2130+(P_3676*P_4151))));
dy(176) =  ...
            (P_2514*P_1478*P_3878*(P_4148-(P_4154/P_3293))) ...
            +(0-((P_3880*P_4637*P_4154)-(P_3879*P_4638*P_4157)));
dy(177) =  ...
            (0-(P_4575*P_2979*P_3679*P_4158*(P_4157/(P_2135+(P_4158*P_4157))))) ...
            +((P_3880*P_4637*P_4154)-(P_3879*P_4638*P_4157)) ...
            +P_4513;
dy(178) =  ...
            (P_4575*P_2979*P_3679*P_4158*(P_4157/(P_2135+(P_4158*P_4157))));
dy(179) =  ...
            (0-(P_4690*P_2984*P_3682*P_2983*(P_4163/(P_2141+(P_2983*P_4163))))) ...
            +P_4620 ...
            +(0-(P_3884*P_2514*((P_3915*P_4163)-(P_3912*(P_4166/P_3397))))) ...
            +(0-(P_2514*P_1483*P_3885*(P_4163-(P_4169/P_3296)))) ...
            +(0-P_4491);
dy(180) =  ...
            (P_4690*P_2984*P_3682*P_2983*(P_4163/(P_2141+(P_2983*P_4163))));
dy(181) =  ...
            (0-(P_4691*P_2987*P_3683*P_3684*(P_4166/(P_2146+(P_3684*P_4166))))) ...
            +P_4621 ...
            +(P_3884*P_2514*((P_3915*P_4163)-(P_3912*(P_4166/P_3397)))) ...
            +(0-P_4492);
dy(182) =  ...
            (P_4691*P_2987*P_3683*P_3684*(P_4166/(P_2146+(P_3684*P_4166))));
dy(183) =  ...
            (0-((P_3883*P_4639*P_4169)-(P_3882*P_4640*P_4172))) ...
            +(P_2514*P_1483*P_3885*(P_4163-(P_4169/P_3296)));
dy(184) =  ...
            (0-(P_4578*P_2989*P_3687*P_4173*(P_4172/(P_2151+(P_4173*P_4172))))) ...
            +((P_3883*P_4639*P_4169)-(P_3882*P_4640*P_4172)) ...
            +P_4504;
dy(185) =  ...
            (P_4578*P_2989*P_3687*P_4173*(P_4172/(P_2151+(P_4173*P_4172))));
dy(186) =  ...
            (0-(P_4693*P_2994*P_3690*P_2993*(P_4178/(P_2157+(P_2993*P_4178))))) ...
            +P_4610 ...
            +(0-(P_3888*P_2514*((P_3915*P_4178)-(P_3912*(P_4181/P_3397))))) ...
            +(0-(P_2514*P_1486*P_3889*(P_4178-(P_4184/P_3298)))) ...
            +(0-P_4495);
dy(187) =  ...
            (P_4693*P_2994*P_3690*P_2993*(P_4178/(P_2157+(P_2993*P_4178))));
dy(188) =  ...
            (0-(P_4694*P_2997*P_3691*P_3692*(P_4181/(P_2162+(P_3692*P_4181))))) ...
            +P_4614 ...
            +(P_3888*P_2514*((P_3915*P_4178)-(P_3912*(P_4181/P_3397)))) ...
            +(0-P_4496);
dy(189) =  ...
            (P_4694*P_2997*P_3691*P_3692*(P_4181/(P_2162+(P_3692*P_4181))));
dy(190) =  ...
            (0-((P_3887*P_4641*P_4184)-(P_3886*P_4642*P_4187))) ...
            +(P_2514*P_1486*P_3889*(P_4178-(P_4184/P_3298)));
dy(191) =  ...
            (0-(P_4581*P_2999*P_3695*P_4188*(P_4187/(P_2167+(P_4188*P_4187))))) ...
            +((P_3887*P_4641*P_4184)-(P_3886*P_4642*P_4187)) ...
            +P_4494;
dy(192) =  ...
            (P_4581*P_2999*P_3695*P_4188*(P_4187/(P_2167+(P_4188*P_4187))));
dy(193) =  ...
            (0-(P_4696*P_3004*P_3698*P_3003*(P_4193/(P_2173+(P_3003*P_4193))))) ...
            +P_4611 ...
            +(0-P_4465) ...
            +(0-(P_3890*P_2514*((P_3915*P_4193)-(P_3912*(P_4196/P_3397))))) ...
            +(0-(P_2514*P_1489*P_3893*(P_4193-(P_4199/P_3300))));
dy(194) =  ...
            (P_4696*P_3004*P_3698*P_3003*(P_4193/(P_2173+(P_3003*P_4193))));
dy(195) =  ...
            (0-(P_4697*P_3007*P_3699*P_3700*(P_4196/(P_2178+(P_3700*P_4196))))) ...
            +P_4612 ...
            +(0-P_4466) ...
            +(P_3890*P_2514*((P_3915*P_4193)-(P_3912*(P_4196/P_3397))));
dy(196) =  ...
            (P_4697*P_3007*P_3699*P_3700*(P_4196/(P_2178+(P_3700*P_4196))));
dy(197) =  ...
            (0-((P_3892*P_4643*P_4199)-(P_3891*P_4644*P_4202))) ...
            +(P_2514*P_1489*P_3893*(P_4193-(P_4199/P_3300)));
dy(198) =  ...
            (0-(P_4584*P_3009*P_3703*P_4203*(P_4202/(P_2183+(P_4203*P_4202))))) ...
            +P_4468 ...
            +((P_3892*P_4643*P_4199)-(P_3891*P_4644*P_4202));
dy(199) =  ...
            (P_4584*P_3009*P_3703*P_4203*(P_4202/(P_2183+(P_4203*P_4202))));
dy(200) =  ...
            (0-(P_4585*P_3018*P_3014*P_3017*(P_3708/(P_2222+(P_3017*P_3708))))) ...
            +(0-(P_2514*P_1432*P_3243*(P_3708-(P_3715/P_3242)))) ...
            +(0-(P_3244*P_2514*((P_3915*P_3708)-(P_3912*(P_3711/P_3397))))) ...
            +(0-(IIf(P_1115,((P_3706+P_3752)*(1-P_42)*P_3708),0))) ...
            +(0-(IIf(P_1115,0,((P_3706+P_3752)*(1-P_42)*P_3708)))) ...
            +(P_3752*(1-P_42)*P_3108) ...
            +(P_3706*(1-P_42)*P_2569);
dy(201) =  ...
            (P_4585*P_3018*P_3014*P_3017*(P_3708/(P_2222+(P_3017*P_3708))));
dy(202) =  ...
            (0-(P_4586*P_3022*P_3019*P_3712*(P_3711/(P_2227+(P_3712*P_3711))))) ...
            +(P_3244*P_2514*((P_3915*P_3708)-(P_3912*(P_3711/P_3397)))) ...
            +(0-(IIf(P_1115,((P_3706+P_3752)*P_42*P_3711),0))) ...
            +(0-(IIf(P_1115,0,((P_3706+P_3752)*P_42*P_3711)))) ...
            +(P_3752*P_42*P_3115) ...
            +(P_3706*P_42*P_2576);
dy(203) =  ...
            (P_4586*P_3022*P_3019*P_3712*(P_3711/(P_2227+(P_3712*P_3711))));
dy(204) =  ...
            (P_2514*P_1432*P_3243*(P_3708-(P_3715/P_3242))) ...
            +(0-((P_3822*P_4280*P_3715)-(P_3819*P_4281*P_4211)));
dy(205) =  ...
            (0-(P_4426*P_3026*P_3716*P_4212*(P_4211/(P_2233+(P_4212*P_4211))))) ...
            +((P_3822*P_4280*P_3715)-(P_3819*P_4281*P_4211));
dy(206) =  ...
            (P_4426*P_3026*P_3716*P_4212*(P_4211/(P_2233+(P_4212*P_4211))));
dy(207) =  ...
            (0-(P_4587*P_3033*P_3029*P_3032*(P_3721/(P_2270+(P_3032*P_3721))))) ...
            +(0-(P_2514*P_1437*P_3250*(P_3721-(P_3728/P_3249)))) ...
            +(0-(P_3251*P_2514*((P_3915*P_3721)-(P_3912*(P_3724/P_3397))))) ...
            +(0-(IIf(P_1115,((P_3719+P_3752)*(1-P_42)*P_3721),0))) ...
            +(IIf(P_1115,((P_3706+P_3752)*(1-P_42)*P_3708),0));
dy(208) =  ...
            (P_4587*P_3033*P_3029*P_3032*(P_3721/(P_2270+(P_3032*P_3721))));
dy(209) =  ...
            (0-(P_4588*P_3037*P_3034*P_3725*(P_3724/(P_2275+(P_3725*P_3724))))) ...
            +(P_3251*P_2514*((P_3915*P_3721)-(P_3912*(P_3724/P_3397)))) ...
            +(IIf(P_1115,((P_3706+P_3752)*P_42*P_3711),0)) ...
            +(0-(IIf(P_1115,((P_3719+P_3752)*P_42*P_3724),0)));
dy(210) =  ...
            (P_4588*P_3037*P_3034*P_3725*(P_3724/(P_2275+(P_3725*P_3724))));
dy(211) =  ...
            (0-((P_3826*P_4282*P_3728)-(P_3825*P_4283*P_4219))) ...
            +(P_2514*P_1437*P_3250*(P_3721-(P_3728/P_3249)));
dy(212) =  ...
            (0-(P_4430*P_3041*P_3729*P_4220*(P_4219/(P_2281+(P_4220*P_4219))))) ...
            +((P_3826*P_4282*P_3728)-(P_3825*P_4283*P_4219));
dy(213) =  ...
            (P_4430*P_3041*P_3729*P_4220*(P_4219/(P_2281+(P_4220*P_4219))));
dy(214) =  ...
            (0-(P_4432*P_3050*P_2288*P_3048*(P_3047/(P_2293+(P_3048*P_3047))))) ...
            +(P_3731*(1-P_42)*P_2556) ...
            +(0-(P_2514*P_1438*P_2456*(P_3047-(P_3058/P_3252)))) ...
            +(0-(P_2457*P_2514*((P_3915*P_3047)-(P_3912*(P_3054/P_3397))))) ...
            +(0-(P_3731*(1-P_42)*P_3047));
dy(215) =  ...
            (P_4432*P_3050*P_2288*P_3048*(P_3047/(P_2293+(P_3048*P_3047))));
dy(216) =  ...
            (0-(P_4433*P_3056*P_2294*P_3734*(P_3054/(P_2299+(P_3734*P_3054))))) ...
            +(P_3731*P_42*P_2563) ...
            +(P_2457*P_2514*((P_3915*P_3047)-(P_3912*(P_3054/P_3397)))) ...
            +(0-(P_3731*P_42*P_3054));
dy(217) =  ...
            (P_4433*P_3056*P_2294*P_3734*(P_3054/(P_2299+(P_3734*P_3054))));
dy(218) =  ...
            (P_2514*P_1438*P_2456*(P_3047-(P_3058/P_3252))) ...
            +(0-((P_3830*P_4284*P_3058)-(P_3827*P_4285*P_3736)));
dy(219) =  ...
            (0-(P_4226*P_3062*P_3059*P_4227*(P_3736/(P_2306+(P_4227*P_3736))))) ...
            +((P_3830*P_4284*P_3058)-(P_3827*P_4285*P_3736));
dy(220) =  ...
            (P_4226*P_3062*P_3059*P_4227*(P_3736/(P_2306+(P_4227*P_3736))));
dy(221) =  ...
            (0-(P_4434*P_3071*P_2309*P_3069*(P_3068/(P_2314+(P_3069*P_3068))))) ...
            +(0-(P_2514*P_1441*P_2459*(P_3068-(P_3079/P_3254)))) ...
            +(0-(P_2461*P_2514*((P_3915*P_3068)-(P_3912*(P_3075/P_3397))))) ...
            +(0-(P_3064*(1-P_42)*P_3068)) ...
            +(P_3064*(1-P_42)*P_2569);
dy(222) =  ...
            (P_4434*P_3071*P_2309*P_3069*(P_3068/(P_2314+(P_3069*P_3068))));
dy(223) =  ...
            (0-(P_4435*P_3077*P_2315*P_3741*(P_3075/(P_2320+(P_3741*P_3075))))) ...
            +(0-(P_3064*P_42*P_3075)) ...
            +(P_2461*P_2514*((P_3915*P_3068)-(P_3912*(P_3075/P_3397)))) ...
            +(P_3064*P_42*P_2576);
dy(224) =  ...
            (P_4435*P_3077*P_2315*P_3741*(P_3075/(P_2320+(P_3741*P_3075))));
dy(225) =  ...
            (P_2514*P_1441*P_2459*(P_3068-(P_3079/P_3254))) ...
            +(0-((P_3834*P_4286*P_3079)-(P_3833*P_4287*P_3743)));
dy(226) =  ...
            (0-(P_4232*P_3083*P_3080*P_4233*(P_3743/(P_2327+(P_4233*P_3743))))) ...
            +((P_3834*P_4286*P_3079)-(P_3833*P_4287*P_3743));
dy(227) =  ...
            (P_4232*P_3083*P_3080*P_4233*(P_3743/(P_2327+(P_4233*P_3743))));
dy(228) =  ...
            (0-(P_4436*P_3092*P_2330*P_3090*(P_3089/(P_2335+(P_3090*P_3089))))) ...
            +(0-(P_2462*P_2514*((P_3915*P_3089)-(P_3912*(P_3096/P_3397))))) ...
            +(0-(P_2514*P_1444*P_2463*(P_3089-(P_3100/P_3256)))) ...
            +(0-(P_3085*(1-P_42)*P_3089)) ...
            +(P_3085*(1-P_42)*P_2569);
dy(229) =  ...
            (P_4436*P_3092*P_2330*P_3090*(P_3089/(P_2335+(P_3090*P_3089))));
dy(230) =  ...
            (0-(P_4437*P_3098*P_2336*P_3748*(P_3096/(P_2341+(P_3748*P_3096))))) ...
            +(P_2462*P_2514*((P_3915*P_3089)-(P_3912*(P_3096/P_3397)))) ...
            +(0-(P_3085*P_42*P_3096)) ...
            +(P_3085*P_42*P_2576);
dy(231) =  ...
            (P_4437*P_3098*P_2336*P_3748*(P_3096/(P_2341+(P_3748*P_3096))));
dy(232) =  ...
            (P_2514*P_1444*P_2463*(P_3089-(P_3100/P_3256))) ...
            +(0-((P_3838*P_4289*P_3100)-(P_3836*P_4288*P_3750)));
dy(233) =  ...
            (0-(P_4238*P_3104*P_3101*P_4239*(P_3750/(P_2348+(P_4239*P_3750))))) ...
            +((P_3838*P_4289*P_3100)-(P_3836*P_4288*P_3750));
dy(234) =  ...
            (P_4238*P_3104*P_3101*P_4239*(P_3750/(P_2348+(P_4239*P_3750))));
dy(235) =  ...
            (0-(P_4438*P_3111*P_2350*P_3109*(P_3108/(P_2355+(P_3109*P_3108))))) ...
            +P_4447 ...
            +P_4451 ...
            +(P_2860*(1-P_42)*P_2864) ...
            +P_4455 ...
            +((1-P_611)*P_2880*(1-P_42)*P_4367) ...
            +P_4460 ...
            +((1-P_846)*P_2940*(1-P_42)*P_4395) ...
            +(P_3085*(1-P_42)*P_3089) ...
            +P_4465 ...
            +(0-(P_2471*P_2514*((P_3915*P_3108)-(P_3912*(P_3115/P_3397))))) ...
            +(P_3140*(1-P_42)*P_3144) ...
            +P_4491 ...
            +P_4495 ...
            +P_4499 ...
            +P_4501 ...
            +P_4508 ...
            +P_4511 ...
            +(0-(P_3752*(1-P_42)*P_3108));
dy(236) =  ...
            (P_4438*P_3111*P_2350*P_3109*(P_3108/(P_2355+(P_3109*P_3108))));
dy(237) =  ...
            (0-(P_4439*P_3117*P_2356*P_3755*(P_3115/(P_2361+(P_3755*P_3115))))) ...
            +P_4448 ...
            +P_4452 ...
            +(P_2860*P_42*P_2871) ...
            +P_4456 ...
            +((1-P_611)*P_2880*P_42*P_4370) ...
            +P_4459 ...
            +((1-P_846)*P_2940*P_42*P_4398) ...
            +(P_3085*P_42*P_3096) ...
            +P_4466 ...
            +(P_2471*P_2514*((P_3915*P_3108)-(P_3912*(P_3115/P_3397)))) ...
            +(P_3140*P_42*P_3151) ...
            +P_4492 ...
            +P_4496 ...
            +P_4500 ...
            +P_4502 ...
            +P_4505 ...
            +P_4509 ...
            +(0-(P_3752*P_42*P_3115));
dy(238) =  ...
            (P_4439*P_3117*P_2356*P_3755*(P_3115/(P_2361+(P_3755*P_3115))));
dy(239) =  ...
            (0-(P_4440*P_3126*P_2364*P_3124*(P_3123/(P_2369+(P_3124*P_3123))))) ...
            +(0-(P_2472*P_2514*((P_3915*P_3123)-(P_3912*(P_3130/P_3397))))) ...
            +(0-(P_2514*P_1450*P_2473*(P_3123-(P_3134/P_3274)))) ...
            +(0-(P_3119*(1-P_42)*P_3123)) ...
            +(P_3119*(1-P_42)*P_2569);
dy(240) =  ...
            (P_4440*P_3126*P_2364*P_3124*(P_3123/(P_2369+(P_3124*P_3123))));
dy(241) =  ...
            (0-(P_4441*P_3132*P_2370*P_3759*(P_3130/(P_2375+(P_3759*P_3130))))) ...
            +(P_2472*P_2514*((P_3915*P_3123)-(P_3912*(P_3130/P_3397)))) ...
            +(0-(P_3119*P_42*P_3130)) ...
            +(P_3119*P_42*P_2576);
dy(242) =  ...
            (P_4441*P_3132*P_2370*P_3759*(P_3130/(P_2375+(P_3759*P_3130))));
dy(243) =  ...
            (P_2514*P_1450*P_2473*(P_3123-(P_3134/P_3274))) ...
            +(0-((P_3845*P_4292*P_3134)-(P_3844*P_4291*P_3761)));
dy(244) =  ...
            (0-(P_4247*P_3138*P_3135*P_4248*(P_3761/(P_2382+(P_4248*P_3761))))) ...
            +((P_3845*P_4292*P_3134)-(P_3844*P_4291*P_3761));
dy(245) =  ...
            (P_4247*P_3138*P_3135*P_4248*(P_3761/(P_2382+(P_4248*P_3761))));
dy(246) =  ...
            (0-(P_4442*P_3147*P_2385*P_3145*(P_3144/(P_2390+(P_3145*P_3144))))) ...
            +(0-(P_2514*P_1453*P_2475*(P_3144-(P_3155/P_3276)))) ...
            +(0-(P_2476*P_2514*((P_3915*P_3144)-(P_3912*(P_3151/P_3397))))) ...
            +(0-(P_3140*(1-P_42)*P_3144)) ...
            +(P_3140*(1-P_42)*P_2569);
dy(247) =  ...
            (P_4442*P_3147*P_2385*P_3145*(P_3144/(P_2390+(P_3145*P_3144))));
dy(248) =  ...
            (0-(P_4443*P_3153*P_2391*P_3766*(P_3151/(P_2396+(P_3766*P_3151))))) ...
            +(P_2476*P_2514*((P_3915*P_3144)-(P_3912*(P_3151/P_3397)))) ...
            +(0-(P_3140*P_42*P_3151)) ...
            +(P_3140*P_42*P_2576);
dy(249) =  ...
            (P_4443*P_3153*P_2391*P_3766*(P_3151/(P_2396+(P_3766*P_3151))));
dy(250) =  ...
            (P_2514*P_1453*P_2475*(P_3144-(P_3155/P_3276))) ...
            +(0-((P_3849*P_4293*P_3155)-(P_3847*P_4294*P_3768)));
dy(251) =  ...
            (0-(P_4253*P_3159*P_3156*P_4254*(P_3768/(P_2403+(P_4254*P_3768))))) ...
            +((P_3849*P_4293*P_3155)-(P_3847*P_4294*P_3768));
dy(252) =  ...
            (P_4253*P_3159*P_3156*P_4254*(P_3768/(P_2403+(P_4254*P_3768))));
dy(253) =  ...
            (P_2514*(P_2569-(P_4698/P_3278))*P_1389);
dy(254) =  ...
            (0-(P_2514*(P_2569-(P_4698/P_3278))*P_1389));
dy(255) =  ...
            (0-EvalParameter(P_1640, Time, y));
dy = dy';
