## The Cood Programming Language

Cood (code and food) is an interpreted stack-based esolang (esoteric programming language) I made based on the phrases you usually will say in a restaurant.

As it's simple, anyone can create an interpreter/compiler for it. I've made three interpreters: AutoIt, PHP and Javascript (running on this page, below).

More details about it [on my blog](http://jefrey.ml/cood).

## Download
* [32 bits interpreter here](https://mega.co.nz/#!84klRAAb!YP54zKS3XZ9CmSvI6U6zoZ1d5c1YOHUqVXK6VPTTzss)
* [64 bits interpreter here](https://mega.co.nz/#!JssTybwB!7SeVADIAcFbGCye4Vdyh6BXgburgqy_4Qw_gPPI-paM)
* [32 bits bamcompiled (a little heavy cause it includes php.exe, but faster, maybe 'cause of Memcache)](https://mega.co.nz/#!94EH0CTQ!T9UI7YQNVmsSr8a2IuhC9TxdmEZim15DPqy3d_JX71A)
* C++ interpreter soon

## Official interpreters' source codes
* [AutoIt](https://github.com/jesobreira/cood/blob/au3-interpreter/interpreter.au3)
* [PHP](https://github.com/jesobreira/cood/blob/php-interpreter/interpreter.php) (command line or [bamcompile](www.bambalam.se/bamcompile)d)
* [Javascript](https://github.com/jesobreira/cood/blob/javascript-interpreter/cood.js)

## On-line interpreter



 Debug mode
Run
 



## Documentation

All your scripts will start with a "Hey, waiter!".

Well... this is not mandatory, but it's cool :D

Then you will have access to 65.535 data cells, starting in pointer 32.767, and will be able to use the following commands:
Command	**Function**
Hey, waiter!	Starts the script.
The bill, please.	Ends the script.
I want this.	Increases a byte on the current data pointer.
I don't want this.	Decreases a byte on the current data pointer.
What do you have for dessert?	Increments the data pointer (points to the next cell to the right).
What do you have for tidbit?	Decrements the data pointer (points to the next cell in the left).
May I ask something?	Reads STDIN (user input).
I'm hungry.	Reads the current data pointer value, and adds a trailing line break.
I'm very hungry.	Reads the current data pointer, without trailing line break.
How much is it?	Reads the current data pointer as decimal value rather than ASCII.
I hate this.	Zeroes the current data pointer.
I want [number] of this.	Puts [number] value on the current data pointer.
More [number] of this.	Adds [number] value to the current data pointer.
Less [number] of this.	Decreases [number] value on the current data pointer.
What do you suggest?	Starts a loop. Read below about loops.
Nothing more?	Ends a loop. Read below about loops.
Know a joke? [comment]	Way to comment out your code.

***Note: some of my friends reported that, on Windows 8, when using "May I ask something?" with the AutoIt interpreter, it is needed to put the value and hit enter twice, so it works fine. As I dislike Windows and hate Windows 8, I can't confirm it. But it seems to be working fine on Windows 7. However, they also reported that the PHP interpreter, bamcompiled (so, an .exe file too) has no problem on reading STDIN stream.***

#### Loops

Loops are a way to repeat your code.

In Cood, it is made using "What do you suggest?" and "Nothing more?". All the code between these tags are repeated until the current pointer (it must be the current pointer at the time of "Nothing more?" call) is zero. Example:

```
Hey, waiter!
I want 10 of this.
What do you suggest?
Know a joke? This line will run ten times.
I don't want this.
Nothing more?
```

It's worth to remember to always decrease the pointer value (or increase if you're using negative values), as the loop doesn't decreases it automatically. This is made using the "I don't want this.". Also, the code above won't display anything.

### Facilities (?)

Of course you're not going to use any esoteric language on your next project, as esolangs are just for fun. But Cood has some facilities. First, all punctiation (commas, periods) aren't mandatory. You can also indent your code with spaces (as many as you want) or tabs. Also, the code will understand if you replace "I'm" with "I am", and some others.

### Debugging

You'll have access to a line-by-line simple debugger showing the data pointer value on every command if you put "--debug" when running your script. Example:

> 
interpreter "My awesome script.cood" --debug


### Examples

#### Hello world

Let's start with a "Hello world". Of course there are many cool ways to do it, but as we are just starting, let's do the easiest way. Just lookup for a ASCII table and do the following:

```
Hey, waiter!
I want 72 of this.
I'm very hungry.
I want 101 of this.
I'm very hungry.
I want 108 of this.
I'm very hungry.
I'm very hungry.
I want 111 of this.
I'm very hungry.
I want 32 of this.
I'm very hungry.
I want 87 of this.
I'm very hungry.
I want 111 of this.
I'm very hungry.
I want 114 of this.
I'm very hungry.
I want 108 of this.
I'm very hungry.
I want 100 of this.
I'm very hungry.
I want 33 of this.
I'm hungry.
```

As you see, every two lines we set the value of the current data pointer to the same decimal value of every char of the string we wanna write, then display it. Simple, huh?

Now let's loop a little bit.

#### Countdown

As the decimal 0 (zero) value is not the char 0 (zero), and the numbers start at the position 48 on the ASCII char, we must work with two data cells: the first one, with value 10, we will use to loop. The second one, with the value 57 (chr '9'), that we will display. Remember we must decrease both the cells values and move to the right one before the loop ends. We will have something like this:

```
Hey waiter!
Know a joke? This is a comment
I want 10 of this.
What do you have for dessert?
I want 57 of this.
What do you have for tidbit?
What do you suggest?
What do you have for dessert?
I'm hungry.
I don't want this.
What do you have for tidbit?
I don't want this.
Nothing more?
```

If the user supplies the number we must loop from?

The number must be from 1 to 9, as we are just starting and didn't make support for two-digits numbers.

Same thing. The current cell will be filled up with the user input. We must copy the value of this cell to other two cells, but as we haven't variables or strcpy() function, we must work hard: we will loop to copy the value of the user input cell to other two cells. So we can do like we did above.

```
Hey waiter!
Know a joke? This is a comment
May I ask something?
What do you suggest?
What do you have for dessert?
I want this.
What do you have for dessert?
I want this.
What do you have for tidbit?
What do you have for tidbit?
I don't want this.
Nothing more?
What do you have for dessert?
More 48 of this.
What do you have for dessert?
What do you suggest?
What do you have for tidbit?
I'm hungry.
I don't want this.
What do you have for dessert?
I don't want this.
Nothing more?
```

#### Some math

Now let's create a script that requires the user to write two numbers and then show the sum between them.

We will have to store the user's numbers in two different cells, then loop one over another, decreasing one of them and increasing in the other. For example, if the user puts the numbers "2" and "3", we will have two stacks:

> 
[2] [3]


We will loop and add the first stack over the second. So, while we run the loop, this is what happens to our stacks:

> 
[2] \[3\]  \(initial state\)
>
[1] [4]
>
[0] [5]


The result is showed on the second stack, and we can show it as decimal.

Well, here's the code:

```
Hey, waiter!
Know a joke? This is the sum calculator.
May I ask something?
What do you have for dessert?
May I ask something?
What do you suggest?
What do you have for tidbit?
I want this.
What do you have for dessert?
I don't want this.
Nothing more?
What do you have for tidbit?
How much is it?
```

## Seriously... What's that for?

Obviously you won't create many things with it, as we have many real programming languages available. Esolangs are just for fun. Also, working with them is always a math and logic challenge, and that's what makes them cool. I wanna challenge you to make a four-operation basic calculator using it (it is possible). Please do not challenge me on creating a Cood compiler cooded in Cood :P

Bon appetit!
