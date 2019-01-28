# Saving Terminal Output

Saving terminal output is useful if you are replicating installation steps for softwares and libraries. There are two ways to save terminal output, one is by manual while the other automates the logging. These steps can be found at this [page](https://unix.stackexchange.com/questions/200637/save-all-the-terminal-output-to-a-file)

## Manual logging of terminal output

You can use ``script``. It will basically save everything printed on the terminal in that script session.

From [``man script``](http://man7.org/linux/man-pages/man1/script.1.html):


```shell
script makes a typescript of everything printed on your terminal. 
It is useful for students who need a hardcopy record of an 
interactive session as proof of an assignment, as the typescript file 
can be printed out later with lpr(1).
```

You can start a script session by just typing script in the terminal, all the subsequent commands and their outputs will all be saved in a file named typescript in the current directory. You can save the result to a different file too by just starting script like:

```shell
script output.txt
```

To logout of the screen session (stop saving the contents), just type ```exit```.

Here is an example:

```shell
$ script output.txt
Script started, file is output.txt

$ ls
output.txt  testfile.txt  foo.txt

$ exit
exit
Script done, file is output.txt
```

Now if I read the file:

```shell
$ cat output.txt

Script started on Mon 20 Apr 2015 08:00:14 AM BDT
$ ls
output.txt  testfile.txt  foo.txt
$ exit
exit

Script done on Mon 20 Apr 2015 08:00:21 AM BDT
```

script also has many options e.g. running quietly ```-q``` (```--quiet```) without showing/saving program messages, it can also run a specific command ```-c``` (```--command```) rather than a session, it also has many other options. Check [``man script``](http://man7.org/linux/man-pages/man1/script.1.html) to get more ideas.

## Automatic logging of terminal output
