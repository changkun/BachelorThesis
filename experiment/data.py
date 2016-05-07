import random
from scipy.stats import norm,rayleigh

data_count = [1981,2546,3989,5081,7576,7773,6845,5905,4485,4845,3512,2041,1384,1493,785,350,289,213,190,157];
x = {}

for key, count in enumerate(data_count):
    x[key] = []
    for i in xrange(0,count):
        value = random.randint(0+key*50,50+key*50)
        x[key].append(value)

data = []
for i in range(0,20):
    for value in x[i]:
        data.append(value)

from scipy.stats import norm
from numpy import linspace
from pylab import plot,show,hist,figure,title
from scipy.stats import norm,rayleigh


param = rayleigh.fit(data) # distribution fitting

x = linspace(0,1000,10)
# fitted distribution
pdf_fitted = rayleigh.pdf(x,loc=param[0],scale=param[1])
# original distribution
pdf = rayleigh.pdf(x,loc=5,scale=2)

title('Rayleigh distribution')
plot(x,pdf_fitted,'r-',x,pdf,'b-')
hist(data,normed=1,alpha=.3)
show()
