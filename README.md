# random-mtzig

The `random-mtzig` library is a Chicken Scheme wrapper for the MT19937
random number generator used in GNU Octave
(http://www.gnu.org/software/octave/).

## Procedures

<procedure>init ::  [SEED] -> STATE</procedure>

Creates an initial seed array and returns the corresponding generator
state vector. If the optional `SEED` is not specified, the generator
is initialized with a seed from `/dev/urandom` or with the current
time in seconds. If `SEED` can be an integer or an `u32vector`.



<procedure>random! :: STATE -> INTEGER</procedure>

Returns a random integer value between 0 and the largest
machine-representable unsigned integer on the current platform.



<procedure>randu! :: STATE -> NUMBER</procedure>

Returns a random value from a uniform distribution on the interval
`(0, 1)`.



<procedure>randn! :: STATE -> NUMBER</procedure>

Returns a random value from a normal (Gaussian) distribution, using
Marsaglia and Tsang's Ziggurat algorithm to transform a uniform
distribution into a normal one.



<procedure>rande! :: STATE -> NUMBER</procedure>

Returns a random value from an exponential distribution, using
Marsaglia and Tsang's Ziggurat algorithm to transform a uniform
distribution into an exponential one.



<procedure>randb! :: N * P * STATE -> NUMBER</procedure>

Returns a random value from a binomial distribution with `N`
experiments and probability `P`.

<procedure>randp! :: L * STATE -> NUMBER</procedure>

Returns a random value from a Poisson distribution with  mean value `L`.


<procedure>f64vector-randu! :: N * STATE -> F64VECTOR</procedure>

Returns an SRFI-4 `f64` vector of random values from a uniform
distribution on the interval `(0, 1)`.



<procedure>f64vector-randn! :: N * STATE -> F64VECTOR</procedure>

Returns an SRFI-4 `f64` vector of random values from a normal
(Gaussian) distribution, using Marsaglia and Tsang's Ziggurat
algorithm to transform a uniform distribution into a normal one.



<procedure>f64vector-rande! :: N * STATE -> F64VECTOR</procedure>

Returns an SRFI-4 `f64` vector of random values from am exponential
distribution, using Marsaglia and Tsang's Ziggurat algorithm to
transform a uniform distribution into an exponential one.



<procedure>f64vector-randb! :: N * P * XN * STATE -> F64VECTOR</procedure>

Returns an SRFI-4 `f64` vector of random values from a binomial
distribution with `N` experiments and probability `P`.

<procedure>f64vector-randp! :: L * XN * STATE -> F64VECTOR</procedure>

Returns an SRFI-4 `f64` vector of random values from a Poisson
distribution with mean value `L`.



<procedure>f32vector-randu! :: N * STATE -> F32VECTOR</procedure>

Returns an SRFI-4 `f32` vector of random values from a uniform
distribution on the interval `(0, 1)`.



<procedure>f32vector-randn! :: N * STATE -> F32VECTOR</procedure>

Returns an SRFI-4 `f32` vector of random values from a normal
(Gaussian) distribution, using Marsaglia and Tsang's Ziggurat
algorithm to transform a uniform distribution into a normal one.



<procedure>f32vector-rande! :: N * STATE -> F32VECTOR</procedure>

Returns an SRFI-4 `f32` vector of random values from am exponential
distribution, using Marsaglia and Tsang's Ziggurat algorithm to
transform a uniform distribution into an exponential one.



<procedure>f32vector-randb! :: N * P * XN * STATE -> F32VECTOR</procedure>

Returns an SRFI-4 `f32` vector of random values from a binomial
distribution with `N` experiments and probability `P`.


<procedure>f32vector-randb! :: L * XN * STATE -> F32VECTOR</procedure>

Returns an SRFI-4 `f32` vector of random values from a Poisson 
distribution with mean value `L`.



## Examples

```scheme
 (require-extension random-mtzig)
 (define st (init 24))
 (f64vector-randu! 20 st)
```

## License

```
 Chicken Scheme egg scripts and documentation Copyright 2007-2015 Ivan Raikov. 
 
    Coded by Takuji Nishimura and Makoto Matsumoto.
    This is a faster version by taking Shawn Cokus's optimization,
    Matthe Bellew's simplification, Isaku Wada's real version.
    David Bateman added normal and exponential distributions following
    Marsaglia and Tang's Ziggurat algorithm.
 
    Copyright (C) 1997 - 2002, Makoto Matsumoto and Takuji Nishimura,
    Copyright (C) 2004, David Bateman
    All rights reserved.
 
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions
    are met:
    
      1. Redistributions of source code must retain the above copyright
         notice, this list of conditions and the following disclaimer.
 
      2. Redistributions in binary form must reproduce the above copyright
         notice, this list of conditions and the following disclaimer in the
         documentation and/or other materials provided with the distribution.
 
      3. The names of its contributors may not be used to endorse or promote 
         products derived from this software without specific prior written 
         permission.
 
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
    A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER 
    OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
    EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
    PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
    PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
    LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
    NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```

