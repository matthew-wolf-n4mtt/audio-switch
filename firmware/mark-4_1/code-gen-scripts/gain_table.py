x = float(27.5)
step = float(0.5)

for i in range(0,255):
    print  "Gain%sTs	brw\n" % i,
    print  "				dt		\"%5s\",0\n" % x,
    x = x - step

