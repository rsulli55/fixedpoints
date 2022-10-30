+++
title = "Efficient Programming with Components Lecture 1"
date = 2022-08-05
[taxonomies]
categories = ["lectures", "programming"]
tags = ["Efficient Programming with Components"]
[extra]
math = true
+++

---
**Link to lectures**
  - [Lecture 1 Part 1](https://www.youtube.com/watch?v=aIHAEYyoTUc&list=PLHxtyCq_WDLXryyw91lahwdtpZsmo4BGD)
  - [Lecture 1 Part 2](https://www.youtube.com/watch?v=DOoO7_yvjQE&list=PLHxtyCq_WDLXryyw91lahwdtpZsmo4BGD&index=2)

#### Highlights and Thoughts
The motivating example introduced towards the beginning of the lecture is finding the the number of unique elements from a collection of numbers.  
Stepanov explains they found the following "very clever" approach:
```c++
int a[] = {1, 3, 1, 4, 1, 5}
std::set set_of_ints<int>(a, a + 6);
std::cout << set_of_ints.size() << std::endl;
```
This approach performs $n \log n$ comparisons which is optimal\*, but it is "awfully slow" because of allocations, insertions, rebalancing, "cache miss on every step through the set."  We will see
later that it is approximately 20 to 50 times slower than a sorting approach.

The approach suggested in class in the following:
```c++
int a[] = {1, 3, 1, 4, 1, 5}
std::sort(a, a + 6);
std::cout << std::unique(a, a + 6) - a << std::endl;
```
I thought using count unique elements as the example was interesting. I don't know if I would have turned to `std::set` in C++ for this, but if I was programming in Python
I likely would use
```python
len(set(a))
``` 
without thinking twice about it.

**Two pieces of advice to remember**:
  1. "Whenever you can, use vector."
  2. "If you cannot, find a way you can."
Only on "very special occassion" should one use advanced data structures because they are typically slower than simple data structures because of how computers are now days.
`std::set` can be reasonable data structure when it is constantly growing and shrinking dynamically.

#### Quotes
  - In regards to a map of maps: "Before STL, nobody in his right mind would dare to say: I'm going to have a self-balancing tree which at every node has self-balancing tree.  
  Why they wouldn't think of it? Because it would take them five years to implement it."

#### Notes
  - \* This is optimal because in general finding the number of unique elements does require sorting.  If we had a bound on the range of possible values, we
  could trade off time for space and get to linear time. But this is not reasonable if our collection can have any of the $2^{32}$ (or $2^{64}$) possible ints.
  This as an example of the statement "things we can do with ordering cannot be done effectively with just equality."

