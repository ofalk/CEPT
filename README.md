CEPT
====

Make sure you create a config file called CEPT.yml with the following content:

	appkey: <yourappkey>
	appid: <yourappid>

Examples of using the testscript.

Similarterms:
=============
	[CEPT.git $] perl CEPT_test.pl -m similarterms --t1 tiger 
	0: tiger 0
	1: royal 0.492063492536545
	2: outbreak 0.507936537265778
	3: 1940 0.513888895511627
	4: korean war 0.519480526447296
	5: war 0.521126747131348
	6: wartime 0.523809552192688
	7: airport 0.52439022064209
	8: training 0.52439022064209
	9: 1941 0.526315808296204
	10: moth 0.529411792755127
	11: training plan 0.534482777118683
	12: p 0.536231875419617
	13: douglas 0.53658539056778
	14: 1944 0.538461565971375
	15: skyhawk 0.538461565971375
	16: airstrips 0.540540516376495
	17: fleet 0.541176497936249
	18: army 0.541666686534882
	19: aircrews 0.54216867685318

Autocomplete:
=============
	[CEPT.git $] perl CEPT_test.pl -m autocomplete --t1 appl --rows 10
	applied
	application
	applications
	apply
	apple
	applies
	applying
	applicable
	applicants
	appliances
