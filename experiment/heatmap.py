
import numpy as np
import matplotlib.pyplot as plt
import csv

def load():
    file = 'c-result.csv'
    csvf = open(file)
    raw = csv.reader(csvf)
    data = np.array([row for row in raw]).astype('float')
    return data;


def pltColorMap(fig, position, data, xlabel, ylabel):
    ax = fig.add_subplot(position)
    im = ax.pcolor(data,cmap=plt.cm.Oranges, shading = 'faceted')
    ax.set_xticklabels(xlabel, minor=False)
    ax.set_yticklabels(ylabel, minor=False)
    # put the major ticks at the middle of each cell
    ax.set_xticks(np.arange(data.shape[1])+0.5, minor=False)
    ax.set_yticks(np.arange(data.shape[0])+0.5, minor=False)
    # want a more natural, table-like display
    ax.invert_yaxis()
    ax.xaxis.tick_top()
    ax.set_xlabel('Gesture Index')
    return im

data = load()
row_labels = [1,2,3,4,5,6,7,8,9,10,11,12,13]
column_labels = ['Tap', 'ForceTouch', 'DigitalCrown', 'Swipe-Left', 'Swipe-Right']
fig = plt.figure()

im = pltColorMap(fig, 111, data, row_labels, column_labels)
fig.subplots_adjust(right=0.8)
cbar_ax = fig.add_axes([0.83, 0.10, 0.02, 0.80])
im.set_clim(vmin=0, vmax=10)
fig.colorbar(im, cax=cbar_ax)

plt.savefig('heat.eps', format='eps')
