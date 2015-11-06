For `liveScript->Javascript` compilation you could use livescript itself and use the compile flag

``
lsc --compile MatLog.ls
``

however I have written another module know as `simple-livescript-watch` that you could use - this module compiles *all* livescript files in the directory is it being run from and compiles then whenever you make any changes to any `.ls` file. 

