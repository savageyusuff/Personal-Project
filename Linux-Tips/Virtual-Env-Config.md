# Virtual Environment Configuration

The main reference from this guide come from this [website](https://www.pyimagesearch.com/2018/09/26/install-opencv-4-on-your-raspberry-pi/)

Virtual environments will allow you to run different versions of Python software in isolation on your system. Today we’ll be setting up just one environment, but you could easily have an environment for each project.

First, install ```virtualenv```  and ```virtualenvwrapper```  by typing the command into the terminal:
``` shell
sudo pip install virtualenv virtualenvwrapper
sudo rm -rf ~/get-pip.py ~/.cache/pip
sudo pip install virtualenv virtualenvwrapper
sudo rm -rf ~/get-pip.py ~/.cache/pip
``` 

To finish the install of these tools, we need to update our  ```~/.profile```  file (similar to ```~/.bashrc```  or ```~/.bash_profile``` ).

Using a terminal text editor such as vi / vim  or nano , add the following lines to your ~/.profile :
``` shell
# virtualenv and virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
```

Alternatively, you can append the lines directly via bash commands:
```shell
$ echo -e "\n# virtualenv and virtualenvwrapper" >> ~/.profile
$ echo "export WORKON_HOME=$HOME/.virtualenvs" >> ~/.profile
$ echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.profile
$ echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.profile
```

Next, source the ```~/.profile```  file with this command: ``` source ~/.profile ```

Create a virtual environment to hold OpenCV 4 and additional packages

To create a vritual environmet, type the name of the virtual environment and the python version which u wish to install in the virtual environment. The format of the command is

```shell
mkvirtualenv <name> -p <python_version>
```
For example, the command below create a virtual environment cv with the latest version of python 3 installed in the enviroment.
``` shell
mkvirtualenv cv -p python3
```

To activate the environment, type the folowing command: ```workon <env_name>```. If the environment is installed, u would see the following results in the command prompt
``` shell
yusuff@yusuff-VirtualBox:~$ workon cv
(cv) yusuff@yusuff-VirtualBox:~$
```

## Checking what are the virtualenv on your system
Sometimes managing many virtual environments can be difficult. Here are a few ways to check what are the virtual environments that u have in the system

1) Using ```lsvirtualenv```, in which there are two options "long" or "brief":

"long" option is the default one, it searches for any hook you may have around this command and executes it, which takes more time.

"brief" just take the virtualenvs names and prints it.

brief usage:

```lsvirtualenv -b```

long usage:

```lsvirtualenv -l```

