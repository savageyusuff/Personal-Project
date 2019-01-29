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

Add to your .bash_aliases this:

```shell
# Execute "script" command just once
smart_script(){
    # if there's no SCRIPT_LOG_FILE exported yet
    if [ -z "$SCRIPT_LOG_FILE" ]; then
        # make folder paths
        logdirparent=~/Terminal_typescripts
        logdirraw=raw/$(date +%F)
        logdir=$logdirparent/$logdirraw
        logfile=$logdir/$(date +%F_%T).$$.rawlog

        # if no folder exist - make one
        if [ ! -d $logdir ]; then
            mkdir -p $logdir
        fi

        export SCRIPT_LOG_FILE=$logfile
        export SCRIPT_LOG_PARENT_FOLDER=$logdirparent

        # quiet output if no args are passed
        if [ ! -z "$1" ]; then
            script -f $logfile
        else
            script -f -q $logfile
        fi

        exit
    fi
}

# Start logging into new file
alias startnewlog='unset SCRIPT_LOG_FILE && smart_script -v'

# Manually saves current log file: $ savelog logname
savelog(){
    # make folder path
    manualdir=$SCRIPT_LOG_PARENT_FOLDER/manual
    # if no folder exists - make one
    if [ ! -d $manualdir ]; then
        mkdir -p $manualdir
    fi
    # make log name
    logname=${SCRIPT_LOG_FILE##*/}
    logname=${logname%.*}
    # add user logname if passed as argument
    if [ ! -z $1 ]; then
        logname=$logname'_'$1
    fi
    # make filepaths
    txtfile=$manualdir/$logname'.txt'
    rawfile=$manualdir/$logname'.rawlog'
    # make .rawlog readable and save it to .txt file
    cat $SCRIPT_LOG_FILE | perl -pe 's/\e([^\[\]]|\[.*?[a-zA-Z]|\].*?\a)//g' | col -b > $txtfile
    # copy corresponding .rawfile
    cp $SCRIPT_LOG_FILE $rawfile
    printf 'Saved logs:\n    '$txtfile'\n    '$rawfile'\n'
}
```

And to the end of your .bashrc file add this:

```shell
smart_script
```
After you've done this, "script" command will be executed once in every terminal session, logging everything to '~/Terminal_typescripts/raw'. If you want, you can save current session log after the fact (in the end of the session) by typing 'savelog' or 'savelog logname' - this will copy current raw log to '~/Terminal_typescripts/manual' and also create readable .txt log in this folder. (If you forget to do so, raw log files will still be in their folder, you'll just have to find them.) Also you may start recording to a new log file by typing 'startnewlog'.

There will be a lot of junk log files, but you can clean old ones from time to time, so it's not a big problem.

(Based on https://answers.launchpad.net/ubuntu/+source/gnome-terminal/+question/7131 , https://askubuntu.com/a/493326/473790 )
