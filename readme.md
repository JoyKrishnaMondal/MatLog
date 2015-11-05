### MatLog : Display 2D matrixes cleanly

MatLog is a tiny module to succiently view 2D matrices on the terminal.

###### Installation

```
npm install matlog
```

###### How to Use

1. `Init` allows you to customize the printing ( by passing a `JSON`)
  1. `MaxSigFig` - For Significant Figures.
  2. `Blanks`    - Spacing between columns.
2. `PrintMat` pass your matrix into this function.


The function `PrintMat` also factors out the most common exponent so you get to see the most relevant values - while saving space. 

