<!--
Add here global page variables to use throughout your
website.
The website_* must be defined for the RSS to work
-->

@def prepath = "ComputationalCognitiveModeling/website"

@def website_title = "CGS 3342"
@def website_descr = "Cognitive & Neural Modeling Lab"
@def website_url   = "https://tlienart.github.io/FranklinTemplates.jl/"

@def author = "Cognitive Informatics and Statistics Lab"

@def mintoclevel = 2

<!--
Add here files or directories that should be ignored by Franklin, otherwise
these files might be copied and, if markdown, processed by Franklin which
you might not want. Indicate directories by ending the name with a `/`.
-->
@def ignore = ["node_modules/", "franklin", "franklin.pub"]

<!--
Add here global latex commands to use throughout your
pages. It can be math commands but does not need to be.
For instance:
* \newcommand{\phrase}{This is a long phrase to copy.}
-->
\newcommand{\R}{\mathbb R}
\newcommand{\scal}[1]{\langle #1 \rangle}
