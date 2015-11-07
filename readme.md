### MatLog : Display 2D matrices cleanly

MatLog is a tiny module to succiently view 2D matrices on the terminal.
```
matlog.mlog [[1,2,3][4,5,6]]

> 1 3 4
  2 3 5
 *1e+0
```
```
matlog.mlog [[0.5,0.4,0.24],[123,0.00001,0.3]]

>   5    4 2
 1e+3 1e-4 3
*1e-1
```
###### Installation

```
npm install matlog
```
###### How to Use

1. `Init` allows you to customize the printing ( by passing a `JSON`)
2. `mlog` pass your matrix into this function.


The function `mlog` also factors out the most common exponent so you get to see the most relevant values - while saving space. 

##### Init 

There are two JSON values that can be controller using `Init`

1. `MaxSigFig` - For Significant Figures.
2. `Blanks`    - Spacing between columns.

