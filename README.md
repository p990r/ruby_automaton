# ruby_automaton
Introduction
============
In this assignment you will investigate some properties of the attached binary.

To complete the assignment you need a Linux system. If you're used to working
on a Windows or OS X based system, you can install Linux in a VirtualBox. If you
encounter any problems please let us know as soon as possible. We prefer you to
work on the assignments, not on installing a system.


Context
=======
TorX is a Model Based Testing tool developed by the consortium of academia and
industrial partners during a research project. Given a model and some glue
software it can automatically test a system.

We have used TorX to compile a spex-promela model into an executable that wraps
the model with a TorX explorer. The compiled model corresponds to a labelled
transition system: a state machine with labelled transitions, whose labels
document the 'action' performed to follow the transition.


Installation notes
==================
Use Ubuntu 16.04. If you have, or installed, a 64-bits
Linux version, then you may need to install i386 compatibility libraries.
E.g. (for 64-bit Ubuntu):

  $ sudo apt-get install gcc-multilib


The POS explorer executable
===========================
The attached pos.tx file is a 32-bit Linux executable. You can communicate with
the process using the communication protocol that is described in
http://fmt.cs.utwente.nl/tools/torx/torx-explorer.5.html.

When you run the executable, you'll see a cursor waiting for input:

  $ ./pos.tx
  _

If you now type

  e 0

followed by 'enter', then you should see

  e 0
  A_DEBUG Command received: e 0
  EB
  Ee	1	0	1	(run POS())
  EE

You have now explored state 0 and it tells you that state 1 (the first number
after an Ee) is now available for exploration. The second and third number
are not important, while the last string is a textual description of the action
that would be performed to transition from state 0 to state 1.

You can ignore lines starting with A_DEBUG or A_LOG.

If you type

  e 1

you should see

  A_DEBUG Command received: e 1
  A_DEBUG (spexio) trans_text set to: pos2env ! 220 ! DUMMY_MTYPE !  DUMMY_MTYPE ! 999
  EB
  A_DEBUG trans_text for 2 is: |pos2env ! 220 ! DUMMY_MTYPE !  DUMMY_MTYPE ! 999|
  Ee	2	1	1	pos2env ! 220 ! DUMMY_MTYPE ! DUMMY_MTYPE ! 999
  EE

Here the textual description takes a format you will see more often from
now on:

  pos2env ! action ! param1 ! param2 ! param3

There is now a state with id 2 available for exploration. This state is reached
by following an output transition (pos2env is output, env2pos is input) and it
is labelled with the action '220'. There are always 3 parameters, but as you may
have guessed from the values, in this case all 3 values are dummies.

In these two examples the states that are returned are new states that were not
yet available before. This is not always the case. When it is not the case, the
Ee line includes an additional number after param3 (the 'identical' from the
protocol documentation), which is the id of a state that became available
earlier in the exploration, to which the newly available state is identical.

The model models a point of sale (POS) system, which can be used to register
articles, open accounts, pay for articles etc. This may help explain some of
the descriptions that are shown for later transitions.


Assignment 1
============
Make a program in Ruby that communicates with the executable [1] and
explores the transition system. During the exploration it should keep
track of the states and transitions of the system. Use this information
to draw a visual representation of the transition system. Also show a list of
unique input and output actions.

At the end of the assignment you should be able to show:
* What states and transitions the transition system consists of
* What transition system looks like [2]
* The list of unique input and output actions

[1] You may want to use the Open3 library (#popen2/3) to connect to the
    explorer (http://ruby-doc.org/stdlib-2.2.3/libdoc/open3/rdoc/Open3.html)

[2] It is most convenient to use a standard library for this, for
    example graphiz (dotty)


Assignment 2
============
Test your code with the rspec framework (http://rspec.info/). For
installation type 'gem install rspec'. If you already start testing your
code while you solve assignment 1, you may find you're done faster.



