Artificial Neural Network 
=========================

In an effort to learn adaptive critic designs better, we wrote our own neural network functions rather than modifying functions already in existence (i.e. MATLAB Neural Network Toolbox). We will describe only a few of the most important ones for ACD.  Each of these functions are called on a neural network object.
 - run – Performs a forward pass through the neural network and returns the result.
 - dOfYWithRespectedToX – Returns the derivative of each of the outputs with respect to each of the inputs.  This function can be used to find the derivative of the actor with respect to all of its inputs – a derivative that is needed for DHP.
 - train – Performs a normal gradient descent train on a neural network, using inputs, expected outputs, a learning rate, and numbers of epochs.
 - trainWithSpecifiedError – This function is identical to train with the exception of an additional input.  This function is used when the error that to train the neural network with is calculated outside of the network (for example in HDP or DHP where the error used to train the actor is a string of partial derivatives).
 - trainActorWithCriticConnected – This function takes as a parameter another neural network object.  It is used especially for action dependent version of HDP and DHP where the actor and the critic are directly connect with no model in between.  It performs a normal gradient descent algorithm for training the actor, but the error for training is obtained at the inputs of the critic network after backpropagation through the critic.  The critic network weights are not updated in this function. 

