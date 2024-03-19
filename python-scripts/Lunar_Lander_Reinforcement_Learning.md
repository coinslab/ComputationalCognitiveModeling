# Lunar Lander - Reinforcement Learning Example

## Execute the below commands to install the required packages
**Open command prompt in Windows or open Terminal -> New Terminal in vscode or use %pip Magic Command in Jupyter notebook (or Colab notebook)**
* pip install pygame
* pip install gymnasium[box2d]
* pip install torch
* Install swig using conda https://anaconda.org/anaconda/swig: conda install -c anaconda swig
  * or install swig by following the instructions at https://swig.org/Doc1.3/Windows.html
* pip install moviepy
    * if the video generation code (end of this notebook) gives error, please execute below commands
        * pip uninstall moviepy decorator
        * pip install moviepy

## Python code 
* Download the software from github repo [Julian Kappler - Lunar Lander](https://github.com/juliankappler/lunar-lander)
* Execute the notebook train and visualize agent.ipynb
  * If you face trouble executing code block 7 under the heading **Plot training stats** then comment below line in code block 7
    * plot_returns_and_durations(training_results=training_results)  


